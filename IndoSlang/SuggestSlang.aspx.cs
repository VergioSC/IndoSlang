using System;
using System.Data.SqlClient;

namespace IndoSlang
{
    public partial class SuggestSlang : System.Web.UI.Page
    {
        public string UserDisplayName = "Member";
        public bool IsBuddy = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            { Response.Redirect("~/Login.aspx"); return; }

            int roleId = Convert.ToInt32(Session["RoleID"]);
            if (roleId != 2 && roleId != 3)
            { Response.Redirect("~/Login.aspx"); return; }

            IsBuddy = (roleId == 3);
            string dashboardUrl = IsBuddy ? "BuddyDashboard.aspx" : "MemberDashboard.aspx";
            if (lnkDashboard != null) lnkDashboard.HRef = "HomePage.aspx";
            if (lnkDashboard2 != null) lnkDashboard2.HRef = dashboardUrl;
            UserDisplayName = Session["UserName"]?.ToString() ?? "Member";

            if (!IsPostBack) LoadMySuggestions();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string sql = @"INSERT INTO SlangSuggestion
                               (SubmittedByUserID, Word, ShortMeaning, FullExplanation,
                                ExampleSentence, ExampleTranslation, DifficultyLevel, Status, SubmittedAt)
                               VALUES
                               (@UserID, @Word, @ShortMeaning, @FullExplanation,
                                @ExampleSentence, @ExampleTranslation, @Level, 'Pending', GETDATE())";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@Word", txtWord.Text.Trim());
                    cmd.Parameters.AddWithValue("@ShortMeaning", txtMeaning.Text.Trim());
                    cmd.Parameters.AddWithValue("@FullExplanation", txtFullExplanation.Text.Trim());
                    cmd.Parameters.AddWithValue("@ExampleSentence", txtExampleSentence.Text.Trim());
                    cmd.Parameters.AddWithValue("@ExampleTranslation", txtExampleTranslation.Text.Trim());
                    cmd.Parameters.AddWithValue("@Level", ddlLevel.SelectedValue);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            ClearForm();
            litSuccess.Text = "<div class=\"alert-success\">Your suggestion has been submitted and is pending review. Thank you!</div>";
            LoadMySuggestions();
        }

        private void LoadMySuggestions()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string sql = @"SELECT SuggestionID, Word, DifficultyLevel, Status, SubmittedAt
                               FROM SlangSuggestion
                               WHERE SubmittedByUserID = @UID
                               ORDER BY SubmittedAt DESC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@UID", userId);
                    conn.Open();
                    rptSuggestions.DataSource = cmd.ExecuteReader();
                    rptSuggestions.DataBind();
                }
            }

            pnlNoSuggestions.Visible = (rptSuggestions.Items.Count == 0);
        }

        private void ClearForm()
        {
            txtWord.Text = "";
            txtPronunciation.Text = "";
            ddlPartOfSpeech.SelectedIndex = 0;
            txtMeaning.Text = "";
            txtFullExplanation.Text = "";
            txtExampleSentence.Text = "";
            txtExampleTranslation.Text = "";
            ddlLevel.SelectedIndex = 0;
        }

        protected string GetStatusCss(object status)
        {
            switch (status?.ToString())
            {
                case "Approved": return "status-badge approved";
                case "Rejected": return "status-badge rejected";
                default: return "status-badge pending";
            }
        }

        protected string FormatDate(object date)
        {
            return Convert.ToDateTime(date).ToString("dd MMM yyyy");
        }
    }
}