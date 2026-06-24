using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;

namespace IndoSlang
{
    public partial class HostSession : System.Web.UI.Page
    {
        private int userId;
        public string UserDisplayName = "Buddy";
        public SessionItem NextSession = null;
        public List<SessionItem> OtherSessions = new List<SessionItem>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["RoleID"] == null)
            { Response.Redirect("~/Login.aspx"); return; }
            if (Convert.ToInt32(Session["RoleID"]) != 3)
            { Response.Redirect("~/Login.aspx"); return; }

            userId = Convert.ToInt32(Session["UserID"]);
            UserDisplayName = HttpUtility.JavaScriptStringEncode(
                Session["UserName"] != null ? Session["UserName"].ToString() : "Buddy");

            lnkLogo.HRef = "HomePage.aspx";

            LoadSessions();
        }

        private void LoadSessions()
        {
            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();

                    string query = @"
                        SELECT
                            s.SessionID,
                            ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS MemberName,
                            DATEADD(SECOND, DATEDIFF(SECOND, 0, a.StartTime), CAST(a.[Date] AS DATETIME)) AS StartTime,
                            ISNULL(s.Duration, 60)             AS DurationMinutes,
                            s.Status,
                            ISNULL(s.SessionLink, '')          AS SessionLink,
                            ISNULL(u.CurrentLevel, 'Beginner') AS MemberLevel,
                            ISNULL(s.Amount * 0.95, 0)         AS BuddyCut,
                            (SELECT COUNT(*) FROM [Session] s2
                             WHERE s2.MemberUserID = s.MemberUserID AND s2.Status = 'Completed') AS MemberTotalSessions
                        FROM  [Session]    s
                        JOIN  [User]       u ON u.UserID = s.MemberUserID
                        JOIN  Availability a ON a.AvailabilityID = s.AvailabilityID
                        WHERE s.BuddyUserID = @BuddyID
                          AND s.Status = 'Scheduled'
                          AND DATEADD(SECOND, DATEDIFF(SECOND, 0, a.StartTime), CAST(a.[Date] AS DATETIME)) >= @Cutoff
                        ORDER BY StartTime ASC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@BuddyID", userId);
                        cmd.Parameters.AddWithValue("@Cutoff", DateTime.Now.AddMinutes(-30));

                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            bool isFirst = true;
                            while (r.Read())
                            {
                                var item = new SessionItem
                                {
                                    SessionID = Convert.ToInt32(r["SessionID"]),
                                    MemberName = r["MemberName"].ToString().Trim(),
                                    StartTime = Convert.ToDateTime(r["StartTime"]),
                                    DurationMinutes = Convert.ToInt32(r["DurationMinutes"]),
                                    Status = r["Status"].ToString(),
                                    SessionLink = r["SessionLink"].ToString(),
                                    MemberLevel = r["MemberLevel"].ToString(),
                                    MemberTotalSessions = Convert.ToInt32(r["MemberTotalSessions"]),
                                    BuddyCut = Convert.ToDecimal(r["BuddyCut"])
                                };

                                if (isFirst) { NextSession = item; isFirst = false; }
                                else OtherSessions.Add(item);
                            }
                        }
                    }
                }
            }
            catch { }
        }

        public class SessionItem
        {
            public int SessionID { get; set; }
            public string MemberName { get; set; }
            public DateTime StartTime { get; set; }
            public int DurationMinutes { get; set; }
            public string Status { get; set; }
            public string SessionLink { get; set; }
            public string MemberLevel { get; set; }
            public int MemberTotalSessions { get; set; }
            public decimal BuddyCut { get; set; }

            public string FormattedTime
            {
                get
                {
                    var end = StartTime.AddMinutes(DurationMinutes);
                    string date = StartTime.Date == DateTime.Today ? "Today" : StartTime.ToString("MMM d");
                    return date + " · " + StartTime.ToString("h:mm tt") + " – " + end.ToString("h:mm tt") + " · " + DurationMinutes + " min";
                }
            }

            public string TimeLabel
            {
                get
                {
                    var diff = StartTime - DateTime.Now;
                    if (diff.TotalMinutes < -30) return "In progress";
                    if (diff.TotalMinutes < 0) return "Starting now";
                    if (diff.TotalMinutes < 60) return "Starts in " + (int)diff.TotalMinutes + " min";
                    if (diff.TotalHours < 24) return "Starts in " + (int)diff.TotalHours + " hr";
                    return "Upcoming";
                }
            }

            public bool IsStartingSoon
            {
                get
                {
                    var d = StartTime - DateTime.Now;
                    return d.TotalMinutes >= -30 && d.TotalMinutes <= 60;
                }
            }

            public string DummyMeetLink
            {
                get
                {
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

            public string SafeSessionUrl
            {
                get
                {
                    if (!string.IsNullOrWhiteSpace(SessionLink))
                        return (SessionLink.StartsWith("http://") || SessionLink.StartsWith("https://"))
                            ? SessionLink : "https://" + SessionLink;
                    return DummyMeetLink;
                }
            }
        }
    }
}