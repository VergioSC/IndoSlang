using System;
using System.Data.SqlClient;

namespace IndoSlang
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Convert.ToInt32(Session["RoleID"]) != 1)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            LoadUsers();
        }

        private void LoadUsers()
        {
            string searchTerm  = txtSearch.Text.Trim();
            string roleFilter  = ddlRoleFilter.SelectedValue;
            bool   hasSearch   = !string.IsNullOrEmpty(searchTerm);

            string sql = @"SELECT UserID, FirstName, LastName, Username, Email,
                                  RoleID, CurrentLevel, Status, CreatedAt
                           FROM [User]
                           WHERE RoleID != 1";

            if (hasSearch)
                sql += @" AND (FirstName LIKE @Search OR LastName LIKE @Search
                               OR Username LIKE @Search OR Email LIKE @Search)";

            if      (roleFilter == "2") sql += " AND RoleID = 2";
            else if (roleFilter == "3") sql += " AND RoleID = 3";

            sql += " ORDER BY CreatedAt DESC";

            using (SqlConnection conn = DBHelper.GetConnection())
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                if (hasSearch)
                    cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");

                conn.Open();
                rptUsers.DataSource = cmd.ExecuteReader();
                rptUsers.DataBind();
            }

            pnlEmpty.Visible = (rptUsers.Items.Count == 0);
        }

        protected void btnBanUser_Click(object sender, EventArgs e)
        {
            int userId;
            if (!int.TryParse(hfBanUserId.Value, out userId) || userId <= 0) return;

            string currentStatus = GetCurrentStatus(userId);
            string newStatus     = currentStatus == "Banned" ? "Active" : "Banned";

            using (SqlConnection conn = DBHelper.GetConnection())
            using (SqlCommand cmd = new SqlCommand(
                "UPDATE [User] SET Status=@Status WHERE UserID=@UID", conn))
            {
                cmd.Parameters.AddWithValue("@Status", newStatus);
                cmd.Parameters.AddWithValue("@UID", userId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            LoadUsers();
        }

        private string GetCurrentStatus(int userId)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            using (SqlCommand cmd = new SqlCommand(
                "SELECT Status FROM [User] WHERE UserID=@UID", conn))
            {
                cmd.Parameters.AddWithValue("@UID", userId);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return result == null || result == DBNull.Value ? "Active" : result.ToString();
            }
        }

        // ── Template helpers ──────────────────────────────────────────────────────

        protected string GetRoleName(object roleId)
        {
            switch (Convert.ToInt32(roleId))
            {
                case 2:  return "Member";
                case 3:  return "Buddy";
                default: return "Unknown";
            }
        }

        protected string GetRoleBadgeCss(object roleId)
        {
            return Convert.ToInt32(roleId) == 3 ? "badge buddy" : "badge member";
        }

        protected string GetStatusBadgeCss(object status)
        {
            return status?.ToString() == "Banned" ? "badge banned" : "badge active-status";
        }

        protected string GetBanButtonText(object status)
        {
            return status?.ToString() == "Banned" ? "Unban" : "Ban";
        }

        protected string GetBanButtonCss(object status)
        {
            return status?.ToString() == "Banned" ? "action-btn" : "danger-btn";
        }

        protected string GetFullName(object first, object last)
        {
            return first + " " + last;
        }
    }
}
