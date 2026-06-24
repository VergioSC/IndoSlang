using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using System.Web;

namespace IndoSlang
{
    public partial class SessionReports : System.Web.UI.Page
    {
        private const int PageSize = 10;

        private int userId;
        public string UserDisplayName = "Admin";
        public int TotalSessions = 0;
        public decimal TotalRevenue = 0;
        public decimal PlatformFee = 0;
        public decimal PaidToBuddies = 0;
        public string CurrentFilter = "all";
        public string SearchTerm = "";
        public int CurrentPage = 1;
        public int TotalPages = 1;
        public int TotalCount = 0;
        public List<SessionReportItem> Sessions = new List<SessionReportItem>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["RoleID"] == null)
            { Response.Redirect("~/Login.aspx"); return; }
            if (Convert.ToInt32(Session["RoleID"]) != 1)
            { Response.Redirect("~/Login.aspx"); return; }

            userId = Convert.ToInt32(Session["UserID"]);
            UserDisplayName = HttpUtility.JavaScriptStringEncode(
                Session["UserName"] != null ? Session["UserName"].ToString() : "Admin");
            lnkLogo.HRef = "HomePage.aspx";

            CurrentFilter = (Request.QueryString["filter"] ?? "all").ToLower().Trim();
            if (CurrentFilter != "completed" && CurrentFilter != "upcoming" && CurrentFilter != "cancelled")
                CurrentFilter = "all";

            SearchTerm = (Request.QueryString["q"] ?? "").Trim();

            if (!int.TryParse(Request.QueryString["page"], out CurrentPage) || CurrentPage < 1)
                CurrentPage = 1;

            if (Request.QueryString["export"] == "csv")
            { ExportCsv(); return; }

            LoadStats();
            LoadSessions();
        }

        public string FilterUrl(string filter)
        {
            var qs = "?filter=" + filter;
            if (!string.IsNullOrEmpty(SearchTerm)) qs += "&q=" + Uri.EscapeDataString(SearchTerm);
            return "SessionReports.aspx" + qs;
        }

        public string PageUrl(int page)
        {
            var qs = "?filter=" + CurrentFilter + "&page=" + page;
            if (!string.IsNullOrEmpty(SearchTerm)) qs += "&q=" + Uri.EscapeDataString(SearchTerm);
            return "SessionReports.aspx" + qs;
        }

        public string ExportUrl
        {
            get
            {
                var qs = "?export=csv&filter=" + CurrentFilter;
                if (!string.IsNullOrEmpty(SearchTerm)) qs += "&q=" + Uri.EscapeDataString(SearchTerm);
                return "SessionReports.aspx" + qs;
            }
        }

        private string DbStatusForFilter()
        {
            switch (CurrentFilter)
            {
                case "upcoming": return "Scheduled";
                case "completed": return "Completed";
                case "cancelled": return "Cancelled";
                default: return null;
            }
        }

        private string BuildWhere()
        {
            var sb = new StringBuilder(" WHERE 1=1");
            if (CurrentFilter != "all")
                sb.Append(" AND s.Status = @Filter");
            if (!string.IsNullOrWhiteSpace(SearchTerm))
                sb.Append(" AND (ISNULL(m.FirstName,'') + ' ' + ISNULL(m.LastName,'') LIKE @Search OR ISNULL(b.FirstName,'') + ' ' + ISNULL(b.LastName,'') LIKE @Search)");
            return sb.ToString();
        }

        private void AddWhereParams(SqlCommand cmd)
        {
            if (CurrentFilter != "all")
                cmd.Parameters.AddWithValue("@Filter", DbStatusForFilter());
            if (!string.IsNullOrWhiteSpace(SearchTerm))
                cmd.Parameters.AddWithValue("@Search", "%" + SearchTerm + "%");
        }

        private void LoadStats()
        {
            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();

                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM [Session]", conn))
                        TotalSessions = Convert.ToInt32(cmd.ExecuteScalar());

                    using (var cmd = new SqlCommand(
                        "SELECT ISNULL(SUM(Amount),0) FROM [Payment] WHERE Status='Completed'", conn))
                        TotalRevenue = Convert.ToDecimal(cmd.ExecuteScalar());
                }
                PlatformFee = Math.Round(TotalRevenue * 0.05m, 2);
                PaidToBuddies = Math.Round(TotalRevenue * 0.95m, 2);
            }
            catch { }
        }

        private void LoadSessions()
        {
            try
            {
                string where = BuildWhere();
                string joinBase = @"
                    FROM [Session] s
                    JOIN [User] m       ON m.UserID = s.MemberUserID
                    JOIN [User] b       ON b.UserID = s.BuddyUserID
                    JOIN Availability a ON a.AvailabilityID = s.AvailabilityID";

                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();

                    using (var cmd = new SqlCommand("SELECT COUNT(*)" + joinBase + where, conn))
                    {
                        AddWhereParams(cmd);
                        TotalCount = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    TotalPages = Math.Max(1, (int)Math.Ceiling((double)TotalCount / PageSize));
                    if (CurrentPage > TotalPages) CurrentPage = TotalPages;
                    int offset = (CurrentPage - 1) * PageSize;

                    using (var cmd = new SqlCommand(
                        @"SELECT s.SessionID,
                                 ISNULL(m.FirstName,'') + ' ' + ISNULL(m.LastName,'') AS MemberName,
                                 ISNULL(b.FirstName,'') + ' ' + ISNULL(b.LastName,'') AS BuddyName,
                                 DATEADD(SECOND, DATEDIFF(SECOND,0,a.StartTime), CAST(a.[Date] AS DATETIME)) AS StartTime,
                                 ISNULL(s.Duration,60)  AS DurationMinutes,
                                 ISNULL(s.Amount,0)     AS TotalAmount,
                                 s.Status,
                                 ISNULL(m.CurrentLevel,'Beginner') AS MemberLevel"
                        + joinBase + where + @"
                          ORDER BY StartTime DESC
                          OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY", conn))
                    {
                        AddWhereParams(cmd);
                        cmd.Parameters.AddWithValue("@Offset", offset);
                        cmd.Parameters.AddWithValue("@PageSize", PageSize);

                        using (var r = cmd.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                Sessions.Add(new SessionReportItem
                                {
                                    SessionID = Convert.ToInt32(r["SessionID"]),
                                    MemberName = r["MemberName"].ToString().Trim(),
                                    BuddyName = r["BuddyName"].ToString().Trim(),
                                    StartTime = Convert.ToDateTime(r["StartTime"]),
                                    DurationMinutes = Convert.ToInt32(r["DurationMinutes"]),
                                    TotalAmount = Convert.ToDecimal(r["TotalAmount"]),
                                    Status = r["Status"].ToString(),
                                    MemberLevel = r["MemberLevel"].ToString()
                                });
                            }
                        }
                    }
                }
            }
            catch { }
        }

        private void ExportCsv()
        {
            Response.ContentType = "text/csv";
            Response.AddHeader("Content-Disposition", "attachment; filename=session-report.csv");

            var sb = new StringBuilder();
            sb.AppendLine("#,Member,Buddy,Date & Time,Duration,Amount,Status");

            try
            {
                string where = BuildWhere();
                string joinBase = @"
                    FROM [Session] s
                    JOIN [User] m       ON m.UserID = s.MemberUserID
                    JOIN [User] b       ON b.UserID = s.BuddyUserID
                    JOIN Availability a ON a.AvailabilityID = s.AvailabilityID";

                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();
                    using (var cmd = new SqlCommand(
                        @"SELECT s.SessionID,
                                 ISNULL(m.FirstName,'') + ' ' + ISNULL(m.LastName,'') AS MemberName,
                                 ISNULL(b.FirstName,'') + ' ' + ISNULL(b.LastName,'') AS BuddyName,
                                 DATEADD(SECOND, DATEDIFF(SECOND,0,a.StartTime), CAST(a.[Date] AS DATETIME)) AS StartTime,
                                 ISNULL(s.Duration,60) AS DurationMinutes,
                                 ISNULL(s.Amount,0)    AS TotalAmount,
                                 s.Status"
                        + joinBase + where + " ORDER BY StartTime DESC", conn))
                    {
                        AddWhereParams(cmd);
                        using (var r = cmd.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                string dt = Convert.ToDateTime(r["StartTime"]).ToString("MMM d yyyy h:mm tt");
                                string mem = "\"" + r["MemberName"].ToString().Replace("\"", "\"\"") + "\"";
                                string bud = "\"" + r["BuddyName"].ToString().Replace("\"", "\"\"") + "\"";
                                sb.AppendLine(string.Format("{0},{1},{2},{3},{4}m,RM {5:0.00},{6}",
                                    r["SessionID"], mem, bud, dt,
                                    r["DurationMinutes"],
                                    Convert.ToDecimal(r["TotalAmount"]),
                                    r["Status"]));
                            }
                        }
                    }
                }
            }
            catch { }

            Response.Write(sb.ToString());
            Response.End();
        }

        public class SessionReportItem
        {
            public int SessionID { get; set; }
            public string MemberName { get; set; }
            public string BuddyName { get; set; }
            public DateTime StartTime { get; set; }
            public int DurationMinutes { get; set; }
            public decimal TotalAmount { get; set; }
            public string Status { get; set; }
            public string MemberLevel { get; set; }

            public string FormattedDate
            {
                get { return StartTime.ToString("MMM d") + " · " + StartTime.ToString("h:mm tt"); }
            }

            public string StatusDisplay
            {
                get { return Status == "Scheduled" ? "Upcoming" : Status; }
            }

            public string StatusClass
            {
                get
                {
                    switch (Status.ToLower())
                    {
                        case "completed": return "completed";
                        case "cancelled": return "cancelled";
                        case "scheduled": return "upcoming";
                        default: return Status.ToLower();
                    }
                }
            }
        }
    }
}