using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;

namespace IndoSlang
{
    public partial class SessionHistory : System.Web.UI.Page
    {
        public string UserName = "";
        public bool IsBuddy = false;
        public List<SessionItem> Sessions = new List<SessionItem>();
        public List<SessionItem> UpcomingSessions = new List<SessionItem>();
        public List<SessionItem> CompletedSessions = new List<SessionItem>();
        public List<SessionItem> CancelledSessions = new List<SessionItem>();
        public decimal TotalEarned = 0m;
        public decimal TotalSpent = 0m;
        public int CompletedCount = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["RoleID"] == null)
            { Response.Redirect("~/Login.aspx"); return; }

            int roleId = Convert.ToInt32(Session["RoleID"]);
            if (roleId != 2 && roleId != 3)
            { Response.Redirect("~/Login.aspx"); return; }

            IsBuddy = (roleId == 3);
            int userId = Convert.ToInt32(Session["UserID"]);

            LoadName(userId);
            LoadSessions(userId);
        }

        private void LoadName(int userId)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            using (SqlCommand cmd = new SqlCommand(
                "SELECT ISNULL(FirstName,'') FROM [User] WHERE UserID=@UID", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                conn.Open();
                object r = cmd.ExecuteScalar();
                if (r != null && r != DBNull.Value) UserName = r.ToString();
            }
        }

        private void LoadSessions(int userId)
        {
            Sessions.Clear();

            string otherLabel = IsBuddy ? "Member" : "Buddy";

            // Two explicit queries — avoids string.Format with column names
            string sql = IsBuddy
                ? @"SELECT s.SessionID,
                        ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS OtherName,
                        ISNULL(a.Date,      CAST(GETDATE() AS DATE))   AS SessionDate,
                        ISNULL(a.StartTime, CAST('00:00' AS TIME))     AS StartTime,
                        ISNULL(s.Duration,  60)                        AS Duration,
                        s.Status,
                        ISNULL(s.Amount, 0)                            AS Amount
                   FROM [Session] s
                   LEFT JOIN [User] u       ON u.UserID = s.MemberUserID
                   LEFT JOIN Availability a ON a.AvailabilityID = s.AvailabilityID
                   WHERE s.BuddyUserID = @UID
                   ORDER BY ISNULL(a.Date, CAST('2000-01-01' AS DATE)) DESC,
                            ISNULL(a.StartTime, CAST('00:00' AS TIME)) DESC"
                : @"SELECT s.SessionID,
                        ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS OtherName,
                        ISNULL(a.Date,      CAST(GETDATE() AS DATE))   AS SessionDate,
                        ISNULL(a.StartTime, CAST('00:00' AS TIME))     AS StartTime,
                        ISNULL(s.Duration,  60)                        AS Duration,
                        s.Status,
                        ISNULL(s.Amount, 0)                            AS Amount
                   FROM [Session] s
                   LEFT JOIN [User] u       ON u.UserID = s.BuddyUserID
                   LEFT JOIN Availability a ON a.AvailabilityID = s.AvailabilityID
                   WHERE s.MemberUserID = @UID
                   ORDER BY ISNULL(a.Date, CAST('2000-01-01' AS DATE)) DESC,
                            ISNULL(a.StartTime, CAST('00:00' AS TIME)) DESC";

            using (SqlConnection conn = DBHelper.GetConnection())
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                conn.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        DateTime date  = Convert.ToDateTime(r["SessionDate"]);
                        object rawTime = r["StartTime"];
                        TimeSpan time  = rawTime is TimeSpan
                                            ? (TimeSpan)rawTime
                                            : TimeSpan.Parse(rawTime.ToString());
                        string status  = r["Status"].ToString();
                        int duration   = Convert.ToInt32(r["Duration"]);
                        decimal amount = Convert.ToDecimal(r["Amount"]);

                        Sessions.Add(new SessionItem
                        {
                            SessionID     = Convert.ToInt32(r["SessionID"]),
                            OtherName     = r["OtherName"].ToString().Trim(),
                            OtherLabel    = otherLabel,
                            DateDisplay   = date.ToString("MMM d, yyyy"),
                            TimeDisplay   = DateTime.Today.Add(time).ToString("h:mm tt"),
                            Duration      = duration,
                            Status        = status,
                            CanCancel     = status == "Scheduled" && date.Date >= DateTime.Today,
                            Amount        = amount,
                            AmountDisplay = "RM " + amount.ToString("0.00"),
                            IsPaid        = status == "Completed" || status == "Scheduled",
                            SessionLink   = ""
                        });
                    }
                }
            }

            UpcomingSessions  = Sessions.Where(s => s.Status == "Scheduled").ToList();
            CompletedSessions = Sessions.Where(s => s.Status == "Completed").ToList();
            CancelledSessions = Sessions.Where(s => s.Status == "Cancelled").ToList();

            CompletedCount = CompletedSessions.Count;
            if (IsBuddy) TotalEarned = CompletedSessions.Sum(s => s.Amount);
            else         TotalSpent  = CompletedSessions.Sum(s => s.Amount);
        }

        protected void btnCancelConfirm_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            int sessionId;
            if (!int.TryParse(hfCancelId.Value, out sessionId)) return;

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                string ownerCol = IsBuddy ? "BuddyUserID" : "MemberUserID";
                int availId = 0;

                using (SqlCommand cmd = new SqlCommand(string.Format(
                    "SELECT AvailabilityID FROM [Session] WHERE SessionID=@SID AND {0}=@UID AND Status='Scheduled'",
                    ownerCol), conn))
                {
                    cmd.Parameters.AddWithValue("@SID", sessionId);
                    cmd.Parameters.AddWithValue("@UID", userId);
                    object result = cmd.ExecuteScalar();
                    if (result == null || result == DBNull.Value)
                    {
                        ShowMessage("Session not found or cannot be cancelled.", false);
                        LoadSessions(userId);
                        return;
                    }
                    availId = Convert.ToInt32(result);
                }

                using (SqlCommand cmd = new SqlCommand(
                    "UPDATE [Session] SET Status='Cancelled' WHERE SessionID=@SID", conn))
                {
                    cmd.Parameters.AddWithValue("@SID", sessionId);
                    cmd.ExecuteNonQuery();
                }

                using (SqlCommand cmd = new SqlCommand(
                    "UPDATE Availability SET IsBooked=0 WHERE AvailabilityID=@AID", conn))
                {
                    cmd.Parameters.AddWithValue("@AID", availId);
                    cmd.ExecuteNonQuery();
                }
            }

            LoadSessions(userId);
            ShowMessage("Session cancelled.", true);
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = System.Web.HttpUtility.HtmlEncode(msg);
            lblMessage.CssClass = success ? "msg-success" : "msg-error";
            lblMessage.Style["display"] = "block";
        }

        public class SessionItem
        {
            public int SessionID { get; set; }
            public string OtherName { get; set; }
            public string OtherLabel { get; set; }
            public string DateDisplay { get; set; }
            public string TimeDisplay { get; set; }
            public int Duration { get; set; }
            public string Status { get; set; }
            public bool CanCancel { get; set; }
            public decimal Amount { get; set; }
            public string AmountDisplay { get; set; }
            public bool IsPaid { get; set; }
            public string SessionLink { get; set; }

            public string StatusDisplay { get { return Status == "Scheduled" ? "Upcoming" : Status; } }
            public string StatusClass   { get { return Status == "Scheduled" ? "upcoming" : Status.ToLower(); } }

            public string JoinUrl
            {
                get
                {
                    if (!string.IsNullOrWhiteSpace(SessionLink))
                        return (SessionLink.StartsWith("http://") || SessionLink.StartsWith("https://"))
                            ? SessionLink : "https://" + SessionLink;

                    const string chars = "abcdefghijklmnopqrstuvwxyz";
                    var rng = new Random(SessionID * 7919);
                    var sb1 = new System.Text.StringBuilder();
                    var sb2 = new System.Text.StringBuilder();
                    var sb3 = new System.Text.StringBuilder();
                    for (int i = 0; i < 3; i++) sb1.Append(chars[rng.Next(chars.Length)]);
                    for (int i = 0; i < 4; i++) sb2.Append(chars[rng.Next(chars.Length)]);
                    for (int i = 0; i < 3; i++) sb3.Append(chars[rng.Next(chars.Length)]);
                    return "https://meet.google.com/" + sb1 + "-" + sb2 + "-" + sb3;
                }
            }
        }
    }
}
