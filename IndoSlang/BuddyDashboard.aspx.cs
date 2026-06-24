using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace IndoSlang
{
    public partial class BuddyDashboard : System.Web.UI.Page
    {
        public string BuddyFirstName = "Buddy";
        public string AvatarSrc = "";
        public int TotalSessions = 0;
        public int ThisMonthSessions = 0;
        public string AvgRating = "—";
        public string PendingEarnings = "RM 0";
        public string EarningThisMonth = "RM 0";
        public string EarningAllTime = "RM 0";
        public string LastWithdrawal = "—";
        public List<UpcomingItem> UpcomingList = new List<UpcomingItem>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["RoleID"] == null)
            { Response.Redirect("~/Login.aspx"); return; }

            if (Convert.ToInt32(Session["RoleID"]) != 3)
            { Response.Redirect("~/Login.aspx"); return; }

            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                LoadProfile(conn, userId);
                LoadStats(conn, userId);
                LoadUpcoming(conn, userId);
            }
        }

        private void LoadProfile(SqlConnection conn, int userId)
        {
            using (SqlCommand cmd = new SqlCommand(
                "SELECT ISNULL(FirstName,'Buddy') AS FirstName, ISNULL(ProfileImage,'') AS ProfileImage FROM [User] WHERE UserID=@UID", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        BuddyFirstName = r["FirstName"].ToString();
                        string img = r["ProfileImage"].ToString();
                        if (!string.IsNullOrEmpty(img))
                            AvatarSrc = System.Web.HttpUtility.JavaScriptStringEncode(
                                ResolveUrl("~/Images/Profiles/" + img));
                    }
                }
            }
        }

        private void LoadStats(SqlConnection conn, int userId)
        {
            using (SqlCommand cmd = new SqlCommand(
                "SELECT COUNT(*) FROM [Session] WHERE BuddyUserID=@UID", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                TotalSessions = Convert.ToInt32(cmd.ExecuteScalar());
            }

            using (SqlCommand cmd = new SqlCommand(@"
                SELECT COUNT(*) FROM [Session] s
                INNER JOIN Availability a ON s.AvailabilityID = a.AvailabilityID
                WHERE s.BuddyUserID=@UID
                  AND MONTH(a.Date)=MONTH(GETDATE()) AND YEAR(a.Date)=YEAR(GETDATE())", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                ThisMonthSessions = Convert.ToInt32(cmd.ExecuteScalar());
            }

            // avg rating from SessionReview
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT ISNULL(AVG(CAST(sr.Rating AS DECIMAL(3,1))), 0)
                FROM SessionReview sr
                INNER JOIN [Session] s ON s.SessionID = sr.SessionID
                WHERE s.BuddyUserID=@UID", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                object r = cmd.ExecuteScalar();
                decimal avg = r != null && r != DBNull.Value ? Convert.ToDecimal(r) : 0;
                AvgRating = avg > 0 ? avg.ToString("0.0") + " / 5" : "—";
            }

            // earnings from Payment * 0.95 (buddy 95% share)
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT ISNULL(SUM(p.Amount * 0.95), 0)
                FROM Payment p
                INNER JOIN [Session] s ON s.SessionID = p.SessionID
                WHERE s.BuddyUserID=@UID AND p.Status='Completed'", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                EarningAllTime = "RM " + Convert.ToDecimal(cmd.ExecuteScalar()).ToString("0.00");
            }

            using (SqlCommand cmd = new SqlCommand(@"
                SELECT ISNULL(SUM(p.Amount * 0.95), 0)
                FROM Payment p
                INNER JOIN [Session] s  ON s.SessionID = p.SessionID
                INNER JOIN Availability a ON a.AvailabilityID = s.AvailabilityID
                WHERE s.BuddyUserID=@UID AND p.Status='Completed'
                  AND MONTH(a.Date)=MONTH(GETDATE()) AND YEAR(a.Date)=YEAR(GETDATE())", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                EarningThisMonth = "RM " + Convert.ToDecimal(cmd.ExecuteScalar()).ToString("0.00");
            }

            // pending = scheduled sessions not yet paid
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT ISNULL(SUM(s.Amount * 0.95), 0)
                FROM [Session] s
                WHERE s.BuddyUserID=@UID AND s.Status='Scheduled'", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                PendingEarnings = "RM " + Convert.ToDecimal(cmd.ExecuteScalar()).ToString("0.00");
            }

            try
            {
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP 1 FORMAT(RequestedAt,'MMM d, yyyy') FROM Withdrawal
                    WHERE BuddyUserID=@UID ORDER BY RequestedAt DESC", conn))
                {
                    cmd.Parameters.AddWithValue("@UID", userId);
                    object r = cmd.ExecuteScalar();
                    if (r != null && r != DBNull.Value) LastWithdrawal = r.ToString();
                }
            }
            catch { }
        }

        private void LoadUpcoming(SqlConnection conn, int userId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT TOP 5
                    ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS MemberName,
                    a.Date, a.StartTime, s.Duration
                FROM [Session] s
                INNER JOIN [User] u       ON s.MemberUserID = u.UserID
                INNER JOIN Availability a ON s.AvailabilityID = a.AvailabilityID
                WHERE s.BuddyUserID=@UID AND s.Status='Scheduled'
                  AND a.Date >= CAST(GETDATE() AS DATE)
                ORDER BY a.Date, a.StartTime", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    while (r.Read())
                    {
                        DateTime date = Convert.ToDateTime(r["Date"]);
                        TimeSpan time;
                        object raw = r["StartTime"];
                        time = raw is TimeSpan ? (TimeSpan)raw : TimeSpan.Parse(raw.ToString());

                        string dateLabel = date.Date == DateTime.Today ? "Today" :
                                           date.Date == DateTime.Today.AddDays(1) ? "Tomorrow" :
                                           date.ToString("ddd, MMM d");

                        UpcomingList.Add(new UpcomingItem
                        {
                            MemberName = r["MemberName"].ToString().Trim(),
                            DateDisplay = dateLabel,
                            TimeDisplay = DateTime.Today.Add(time).ToString("h:mm tt"),
                            Duration = Convert.ToInt32(r["Duration"])
                        });
                    }
                }
            }
        }

        public class UpcomingItem
        {
            public string MemberName { get; set; }
            public string DateDisplay { get; set; }
            public string TimeDisplay { get; set; }
            public int Duration { get; set; }
        }
    }
}