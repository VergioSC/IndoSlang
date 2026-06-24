using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using System.Web;

namespace IndoSlang
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        public string UserDisplayName = "Admin";
        public int TotalUsers = 0;
        public int ActiveMembers = 0;
        public int ActiveBuddies = 0;
        public int SessionsThisMonth = 0;
        public decimal RevenueThisMonth = 0;
        public int PendingBuddies = 0;
        public int PendingSlang = 0;
        public int PendingReports = 0;
        public List<RecentUserItem> RecentUsers = new List<RecentUserItem>();
        public string WeeklyChartJson = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["RoleID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (Convert.ToInt32(Session["RoleID"]) != 1)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            UserDisplayName = HttpUtility.JavaScriptStringEncode(
                Session["UserName"] != null ? Session["UserName"].ToString() : "Admin");

            lnkLogo.HRef = "HomePage.aspx";

            LoadStats();
        }

        private void LoadStats()
        {
            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();

                    using (var cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM [User] WHERE Status NOT IN ('Closed','Pending')", conn))
                        TotalUsers = Convert.ToInt32(cmd.ExecuteScalar());

                    using (var cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM [User] WHERE RoleID = 2 AND Status = 'Active'", conn))
                        ActiveMembers = Convert.ToInt32(cmd.ExecuteScalar());

                    using (var cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM [User] WHERE RoleID = 3 AND Status = 'Active'", conn))
                        ActiveBuddies = Convert.ToInt32(cmd.ExecuteScalar());

                    using (var cmd = new SqlCommand(@"
                        SELECT COUNT(*) FROM [Session]
                        WHERE MONTH(CreatedAt) = MONTH(GETDATE())
                          AND YEAR(CreatedAt)  = YEAR(GETDATE())", conn))
                    {
                        try { SessionsThisMonth = Convert.ToInt32(cmd.ExecuteScalar()); }
                        catch { SessionsThisMonth = 0; }
                    }

                    using (var cmd = new SqlCommand(@"
                        SELECT ISNULL(SUM(Amount), 0) FROM [Payment]
                        WHERE Status = 'Completed'
                          AND MONTH(PaidAt) = MONTH(GETDATE())
                          AND YEAR(PaidAt)  = YEAR(GETDATE())", conn))
                    {
                        try { RevenueThisMonth = Convert.ToDecimal(cmd.ExecuteScalar()); }
                        catch { RevenueThisMonth = 0; }
                    }

                    using (var cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM BuddyApplication WHERE Status = 'Pending'", conn))
                        PendingBuddies = Convert.ToInt32(cmd.ExecuteScalar());

                    using (var cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM SlangSuggestion WHERE Status = 'Pending'", conn))
                        PendingSlang = Convert.ToInt32(cmd.ExecuteScalar());

                    PendingReports = 0;

                    using (var cmd = new SqlCommand(@"
                        SELECT TOP 5
                            ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'') AS FullName,
                            CreatedAt
                        FROM [User]
                        WHERE Status NOT IN ('Closed','Pending')
                        ORDER BY CreatedAt DESC", conn))
                    {
                        using (var r = cmd.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                var created = Convert.ToDateTime(r["CreatedAt"]);
                                var diff = DateTime.Now - created;
                                string when = diff.TotalDays < 1 ? "Today" :
                                              diff.TotalDays < 2 ? "Yesterday" :
                                              diff.TotalDays < 7 ? ((int)diff.TotalDays) + "d ago" :
                                              created.ToString("MMM d");
                                RecentUsers.Add(new RecentUserItem
                                {
                                    FullName = r["FullName"].ToString().Trim(),
                                    WhenLabel = when
                                });
                            }
                        }
                    }

                    var today = DateTime.Today;
                    int dow = (int)today.DayOfWeek;
                    var monday = today.AddDays(-(dow == 0 ? 6 : dow - 1));

                    using (var cmd = new SqlCommand(@"
                        SELECT CAST(CreatedAt AS DATE) AS SessionDate, COUNT(*) AS Cnt
                        FROM [Session]
                        WHERE CreatedAt >= @Monday AND CreatedAt < @NextMonday
                        GROUP BY CAST(CreatedAt AS DATE)", conn))
                    {
                        cmd.Parameters.AddWithValue("@Monday", monday);
                        cmd.Parameters.AddWithValue("@NextMonday", monday.AddDays(7));

                        var dayCounts = new int[7];
                        try
                        {
                            using (var r = cmd.ExecuteReader())
                            {
                                while (r.Read())
                                {
                                    var d = Convert.ToDateTime(r["SessionDate"]);
                                    int idx = (int)(d - monday).TotalDays;
                                    if (idx >= 0 && idx < 7)
                                        dayCounts[idx] = Convert.ToInt32(r["Cnt"]);
                                }
                            }
                        }
                        catch { }

                        var sb = new StringBuilder("[");
                        for (int i = 0; i < 7; i++)
                        {
                            if (i > 0) sb.Append(",");
                            sb.Append("{\"count\":" + dayCounts[i] + "}");
                        }
                        sb.Append("]");
                        WeeklyChartJson = sb.ToString();
                    }
                }
            }
            catch { }
        }

        public class RecentUserItem
        {
            public string FullName { get; set; }
            public string WhenLabel { get; set; }
        }
    }
}