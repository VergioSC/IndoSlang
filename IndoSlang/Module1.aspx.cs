using System;
using System.Data.SqlClient;
using System.Web;

namespace IndoSlang
{
    public partial class Module1 : System.Web.UI.Page
    {
        public string UserDisplayName = "Member";

        private int userId;
        private const int ModuleOrder = 1;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to login if no session
            if (Session["UserID"] == null || Session["RoleID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int roleId = Convert.ToInt32(Session["RoleID"]);

            // Only Member (2) and Buddy (3) can access modules
            if (roleId != 2 && roleId != 3)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            userId = Convert.ToInt32(Session["UserID"]);
            UserDisplayName = HttpUtility.JavaScriptStringEncode(
                Session["UserName"] == null ? "Member" : Session["UserName"].ToString()
            );

            // Set links — lnkLogo goes to HomePage, lnkDashboard goes to role dashboard
            lnkLogo.HRef = "HomePage.aspx";
            lnkDashboard.HRef = roleId == 3 ? "BuddyDashboard.aspx" : "MemberDashboard.aspx";

            // Save last page for resume after re-login
            Session["LastPage"] = "Module1.aspx";
        }

        // Fires when all flashcards are done and user clicks "Go to Module 2"
        protected void btnSaveResult_Click(object sender, EventArgs e)
        {
            if (hfCompleted.Value != "1") return;

            int moduleId = GetModuleIdByOrder(ModuleOrder);
            if (moduleId == 0)
            {
                Response.Redirect("~/Module2.aspx");
                return;
            }

            // Flashcards always count as completed with score 5
            int score = 5;
            int attemptNumber = GetNextAttemptNumber(moduleId);

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    INSERT INTO UserModuleProgress
                    (UserID, ModuleID, AttemptNumber, IsCompleted, Score, StartedAt, CompletedAt)
                    VALUES
                    (@UserID, @ModuleID, @AttemptNumber, 1, @Score, GETDATE(), GETDATE())";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    cmd.Parameters.AddWithValue("@AttemptNumber", attemptNumber);
                    cmd.Parameters.AddWithValue("@Score", score);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            Response.Redirect("~/Module2.aspx");
        }

        private int GetModuleIdByOrder(int moduleOrder)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = "SELECT TOP 1 ModuleID FROM Module WHERE ModuleOrder = @ModuleOrder";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ModuleOrder", moduleOrder);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    return (result == null || result == DBNull.Value) ? 0 : Convert.ToInt32(result);
                }
            }
        }

        private int GetNextAttemptNumber(int moduleId)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    SELECT ISNULL(MAX(AttemptNumber), 0) + 1
                    FROM UserModuleProgress
                    WHERE UserID = @UserID AND ModuleID = @ModuleID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }
    }
}