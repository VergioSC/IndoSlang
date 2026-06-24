using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace IndoSlang
{
    public partial class CommunityChat : System.Web.UI.Page
    {
        public string UserDisplayName = "User";
        public int    CurrentUserId   = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int roleId      = Convert.ToInt32(Session["RoleID"]);
            CurrentUserId   = Convert.ToInt32(Session["UserID"]);
            UserDisplayName = Session["UserName"]?.ToString() ?? "User";

            // Set sidebar dashboard links based on role
            if (roleId == 1) // Admin
            {
                lnkDashboard.HRef  = "HomePage.aspx";
                lnkDashboard2.HRef = "AdminDashboard.aspx";
                pnlMemberNav.Visible = false;
                pnlAdminNav.Visible  = true;
            }
            else
            {
                string dashboardUrl    = roleId == 3 ? "BuddyDashboard.aspx" : "MemberDashboard.aspx";
                lnkDashboard.HRef      = "HomePage.aspx";
                lnkDashboard2.HRef     = dashboardUrl;
                pnlMemberNav.Visible   = (roleId == 2);
                pnlBuddyNav.Visible    = (roleId == 3);
                pnlAdminNav.Visible    = false;
            }

            if (!IsPostBack)
            {
                LoadMessages();
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            string msg = txtMessage.Text.Trim();
            if (string.IsNullOrEmpty(msg)) return;

            int channelId = GetDefaultChannelId();

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string sql = @"INSERT INTO ChatMessage (ChannelID, UserID, Content, SentAt)
                               VALUES (@ChannelID, @UserID, @Message, GETDATE())";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@ChannelID", channelId);
                    cmd.Parameters.AddWithValue("@UserID",    CurrentUserId);
                    cmd.Parameters.AddWithValue("@Message",   msg);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            txtMessage.Text = "";
            LoadMessages();
        }

        private void LoadMessages()
        {
            int channelId = GetDefaultChannelId();

            var messages = new List<ChatMessageItem>();

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string sql = @"SELECT TOP 50
                                   cm.MessageID, cm.UserID, cm.Content, cm.SentAt,
                                   u.FirstName, u.Username
                               FROM ChatMessage cm
                               INNER JOIN [User] u ON cm.UserID = u.UserID
                               WHERE cm.ChannelID = @ChannelID
                               ORDER BY cm.SentAt DESC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@ChannelID", channelId);
                    conn.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            messages.Add(new ChatMessageItem
                            {
                                MessageID   = Convert.ToInt32(r["MessageID"]),
                                UserID      = Convert.ToInt32(r["UserID"]),
                                MessageText = r["Content"].ToString(),
                                SentAt      = Convert.ToDateTime(r["SentAt"]),
                                FirstName   = r["FirstName"].ToString(),
                                Username    = r["Username"].ToString()
                            });
                        }
                    }
                }
            }

            // Reverse so oldest appears at top
            messages.Reverse();
            rptMessages.DataSource = messages;
            rptMessages.DataBind();
            pnlNoMessages.Visible = (rptMessages.Items.Count == 0);
        }

        private int GetDefaultChannelId()
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();

                using (SqlCommand cmd = new SqlCommand(
                    "SELECT TOP 1 ChannelID FROM ChatChannel ORDER BY ChannelID", conn))
                {
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                        return Convert.ToInt32(result);
                }

                // No channel exists yet — create a General channel
                using (SqlCommand cmd = new SqlCommand(
                    "INSERT INTO ChatChannel (ChannelName, CreatedByUserID, CreatedAt) OUTPUT INSERTED.ChannelID VALUES ('General', @UserID, GETDATE())", conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", CurrentUserId);
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }

        // ── Template helpers ──────────────────────────────────────────────────────

        protected string GetInitial(object firstName)
        {
            string name = firstName?.ToString() ?? "?";
            return name.Length > 0 ? name[0].ToString().ToUpper() : "?";
        }

        protected string GetWrapCss(object userId)
        {
            return Convert.ToInt32(userId) == CurrentUserId ? "msg-wrap own" : "msg-wrap other";
        }

        protected string GetBubbleCss(object userId)
        {
            return Convert.ToInt32(userId) == CurrentUserId ? "msg-bubble own" : "msg-bubble other";
        }

        protected string GetAvatarCss(object userId)
        {
            return Convert.ToInt32(userId) == CurrentUserId ? "msg-avatar own-avatar" : "msg-avatar";
        }

        protected string FormatTime(object sentAt)
        {
            DateTime dt = Convert.ToDateTime(sentAt);
            return dt.Date == DateTime.Today
                ? dt.ToString("HH:mm")
                : dt.ToString("dd MMM, HH:mm");
        }

        public class ChatMessageItem
        {
            public int      MessageID   { get; set; }
            public int      UserID      { get; set; }
            public string   MessageText { get; set; }
            public DateTime SentAt      { get; set; }
            public string   FirstName   { get; set; }
            public string   Username    { get; set; }
        }
    }
}
