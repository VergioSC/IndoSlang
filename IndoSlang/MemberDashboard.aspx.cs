using System;
using System.Data.SqlClient;

namespace IndoSlang
{
    public partial class MemberDashboard : System.Web.UI.Page
    {
        public string UserFirstName = "Member";
        public string UserLevel = "Beginner";
        public int ModulesDone = 0;
        public int SessionsCount = 0;
        public int QuestionsDone = 0;

        public bool HasCurrentModule = false;
        public string CurrentModuleTitle = "";
        public string CurrentModuleLink = "";
        public int CurrentModuleOrder = 0;
        public int CurrentModulePercent = 0;

        public bool HasNextModule = false;
        public string NextModuleTitle = "";
        public string NextModuleLink = "";
        public int NextModuleOrder = 0;

        public bool HasUpcomingSession = false;
        public string UpcomingBuddyName = "";
        public string UpcomingSessionTime = "";
        public int UpcomingDuration = 0;

        public int NewMessages = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // only members (RoleID = 2) allowed here
            int roleId = Convert.ToInt32(Session["RoleID"]);
            if (roleId != 2)
            {
                if (roleId == 1)
                    Response.Redirect("~/AdminDashboard.aspx");
                else if (roleId == 3)
                    Response.Redirect("~/BuddyDashboard.aspx");
                else
                    Response.Redirect("~/Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                LoadUserStats(conn, userId);
                LoadContinueLearning(conn, userId);
                LoadUpcomingSession(conn, userId);
                LoadChatMessages(conn, userId);
            }
        }

        private void LoadUserStats(SqlConnection conn, int userId)
        {
            using (SqlCommand cmd = new SqlCommand(
                "SELECT FirstName, CurrentLevel FROM [User] WHERE UserID = @UID", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        UserFirstName = r["FirstName"] == DBNull.Value ? "Member" : r["FirstName"].ToString();
                        UserLevel = r["CurrentLevel"] == DBNull.Value ? "Beginner" : r["CurrentLevel"].ToString();
                    }
                }
            }

            using (SqlCommand cmd = new SqlCommand(
                "SELECT COUNT(DISTINCT ModuleID) FROM UserModuleProgress WHERE UserID = @UID AND IsCompleted = 1", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                ModulesDone = Convert.ToInt32(cmd.ExecuteScalar());
            }

            using (SqlCommand cmd = new SqlCommand(
                "SELECT COUNT(*) FROM [Session] WHERE MemberUserID = @UID", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                SessionsCount = Convert.ToInt32(cmd.ExecuteScalar());
            }

            // count all answered questions (correct + wrong)
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT COUNT(*) FROM UserQuestionAnswer uqa
                INNER JOIN UserModuleProgress ump ON uqa.ProgressID = ump.ProgressID
                WHERE ump.UserID = @UID", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                QuestionsDone = Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private void LoadContinueLearning(SqlConnection conn, int userId)
        {
            // if all 8 modules done, skip — .aspx handles the all-done card
            if (ModulesDone >= 8) return;

            // Latest in-progress module
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT TOP 1 ump.ProgressID, m.Title, m.ModuleOrder,
                    (SELECT COUNT(*) FROM UserQuestionAnswer WHERE ProgressID = ump.ProgressID) AS Answered,
                    (SELECT COUNT(*) FROM Question WHERE ModuleID = m.ModuleID) AS Total
                FROM UserModuleProgress ump
                INNER JOIN Module m ON ump.ModuleID = m.ModuleID
                WHERE ump.UserID = @UID AND ump.IsCompleted = 0
                ORDER BY ump.StartedAt DESC", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        HasCurrentModule = true;
                        CurrentModuleTitle = r["Title"].ToString();
                        CurrentModuleOrder = Convert.ToInt32(r["ModuleOrder"]);
                        CurrentModuleLink = "Module" + CurrentModuleOrder + ".aspx";
                        int answered = Convert.ToInt32(r["Answered"]);
                        int total = Convert.ToInt32(r["Total"]);
                        CurrentModulePercent = total > 0 ? (answered * 100 / total) : 0;
                    }
                }
            }

            // Next module after current, or first unstarted if no in-progress
            string nextQuery = HasCurrentModule
                ? @"SELECT TOP 1 Title, ModuleOrder FROM Module
                    WHERE ModuleOrder = @Ref AND Status = 'Published'"
                : @"SELECT TOP 1 m.Title, m.ModuleOrder FROM Module m
                    WHERE m.Status = 'Published'
                    AND m.ModuleID NOT IN (
                        SELECT ModuleID FROM UserModuleProgress WHERE UserID = @UID AND IsCompleted = 1
                    )
                    ORDER BY m.ModuleOrder";

            using (SqlCommand cmd = new SqlCommand(nextQuery, conn))
            {
                if (HasCurrentModule)
                    cmd.Parameters.AddWithValue("@Ref", CurrentModuleOrder + 1);
                else
                    cmd.Parameters.AddWithValue("@UID", userId);

                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        HasNextModule = true;
                        NextModuleTitle = r["Title"].ToString();
                        NextModuleOrder = Convert.ToInt32(r["ModuleOrder"]);
                        NextModuleLink = "Module" + NextModuleOrder + ".aspx";
                    }
                }
            }
        }

        private void LoadUpcomingSession(SqlConnection conn, int userId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT TOP 1 u.FirstName AS BuddyName, a.Date, a.StartTime, s.Duration
                FROM [Session] s
                INNER JOIN [User] u ON s.BuddyUserID = u.UserID
                INNER JOIN Availability a ON s.AvailabilityID = a.AvailabilityID
                WHERE s.MemberUserID = @UID AND s.Status = 'Scheduled'
                AND a.Date >= CAST(GETDATE() AS DATE)
                ORDER BY a.Date, a.StartTime", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        HasUpcomingSession = true;
                        UpcomingBuddyName = r["BuddyName"].ToString();
                        DateTime date = Convert.ToDateTime(r["Date"]);
                        TimeSpan time = (TimeSpan)r["StartTime"];
                        UpcomingDuration = Convert.ToInt32(r["Duration"]);

                        string dateLabel = date.Date == DateTime.Today ? "Today" :
                                          date.Date == DateTime.Today.AddDays(1) ? "Tomorrow" :
                                          date.ToString("ddd, MMM d");

                        UpcomingSessionTime = dateLabel + " " + date.Date.Add(time).ToString("h:mm tt");
                    }
                }
            }
        }

        private void LoadChatMessages(SqlConnection conn, int userId)
        {
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT COUNT(*) FROM ChatMessage
                WHERE UserID != @UID AND SentAt >= DATEADD(HOUR, -24, GETDATE())", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                NewMessages = Convert.ToInt32(cmd.ExecuteScalar());
            }
        }
    }
}
