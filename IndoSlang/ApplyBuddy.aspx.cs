using System;
using System.Data.SqlClient;
using System.Web;

namespace IndoSlang
{
    public partial class ApplyBuddy : System.Web.UI.Page
    {
        public string ApplicationStatus = "Not submitted";
        public string ApplicationStatusClass = "not-submitted";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["RoleID"] == null)
            { Response.Redirect("~/Login.aspx"); return; }

            int roleId = Convert.ToInt32(Session["RoleID"]);
            if (roleId == 3) { Response.Redirect("~/BuddyDashboard.aspx"); return; }
            if (roleId != 2) { Response.Redirect("~/Login.aspx"); return; }

            if (!IsPostBack)
            {
                PreFillName();
                CheckExistingApplication();
            }
        }

        private void PreFillName()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'') FROM [User] WHERE UserID = @UID", conn))
                {
                    cmd.Parameters.AddWithValue("@UID", userId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                        txtFullName.Text = result.ToString().Trim();
                }
            }
        }

        private void CheckExistingApplication()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP 1 Status FROM BuddyApplication
                    WHERE UserID = @UID ORDER BY SubmittedAt DESC", conn))
                {
                    cmd.Parameters.AddWithValue("@UID", userId);
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        string status = result.ToString();
                        SetStatusDisplay(status);

                        if (status == "Pending")
                        {
                            pnlForm.Visible = false;
                            pnlPending.Visible = true;
                            litPendingMsg.Text = HttpUtility.HtmlEncode(
                                "Your application is currently under review. We'll notify you once it's processed.");
                        }
                        else if (status == "Rejected")
                        {
                            ShowMessage("Your previous application was not approved. You may apply again below.", false);
                        }
                    }
                }
            }
        }

        private void SetStatusDisplay(string status)
        {
            switch (status)
            {
                case "Pending":
                    ApplicationStatus = "Pending review"; ApplicationStatusClass = "pending"; break;
                case "Approved":
                    ApplicationStatus = "Approved"; ApplicationStatusClass = "approved"; break;
                case "Rejected":
                    ApplicationStatus = "Rejected"; ApplicationStatusClass = "rejected"; break;
                default:
                    ApplicationStatus = "Not submitted"; ApplicationStatusClass = "not-submitted"; break;
            }
        }

        protected void btnApply_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            string fullName = txtFullName.Text.Trim();
            string city = txtCity.Text.Trim();
            string proficiency = hfProficiency.Value.Trim();
            string topics = txtTopics.Text.Trim();
            string reason = txtReason.Text.Trim();
            string rateStr = txtRate.Text.Trim();

            if (string.IsNullOrWhiteSpace(fullName)) { ShowMessage("Please enter your full name.", false); return; }
            if (string.IsNullOrWhiteSpace(city)) { ShowMessage("Please enter your city or region.", false); return; }
            if (string.IsNullOrWhiteSpace(reason)) { ShowMessage("Please tell us why you want to be a buddy.", false); return; }
            if (reason.Length < 20) { ShowMessage("Please write at least 20 characters for your reason.", false); return; }

            decimal sessionRate = 25m;
            if (!string.IsNullOrWhiteSpace(rateStr))
            {
                if (!decimal.TryParse(rateStr, out sessionRate) || sessionRate <= 0)
                { ShowMessage("Please enter a valid session rate (numbers only).", false); return; }
                if (sessionRate > 9999)
                { ShowMessage("Session rate cannot exceed RM 9,999.", false); return; }
            }

            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM BuddyApplication WHERE UserID = @UID AND Status = 'Pending'", conn))
                    {
                        cmd.Parameters.AddWithValue("@UID", userId);
                        if (Convert.ToInt32(cmd.ExecuteScalar()) > 0)
                        {
                            pnlForm.Visible = false;
                            pnlPending.Visible = true;
                            litPendingMsg.Text = HttpUtility.HtmlEncode("Your application is already under review.");
                            return;
                        }
                    }

                    using (SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO BuddyApplication
                        (UserID, FullName, City, Topics, WhyBuddy, SessionRate, ProficiencyLevel, Status, SubmittedAt)
                        VALUES (@UID, @FullName, @City, @Topics, @Reason, @Rate, @Prof, 'Pending', GETDATE())", conn))
                    {
                        cmd.Parameters.AddWithValue("@UID", userId);
                        cmd.Parameters.AddWithValue("@FullName", fullName);
                        cmd.Parameters.AddWithValue("@City", city);
                        cmd.Parameters.AddWithValue("@Topics", string.IsNullOrWhiteSpace(topics) ? (object)DBNull.Value : topics);
                        cmd.Parameters.AddWithValue("@Reason", reason);
                        cmd.Parameters.AddWithValue("@Rate", sessionRate);
                        cmd.Parameters.AddWithValue("@Prof", proficiency);
                        cmd.ExecuteNonQuery();
                    }
                }

                ApplicationStatus = "Pending review";
                ApplicationStatusClass = "pending";
                pnlForm.Visible = false;
                pnlPending.Visible = true;
                litPendingMsg.Text = HttpUtility.HtmlEncode(
                    "Your application has been submitted! We'll review it and get back to you soon.");
            }
            catch
            {
                ShowMessage("Failed to submit application. Please try again.", false);
            }
        }

        private void ShowMessage(string msg, bool success)
        {
            litMsg.Text = HttpUtility.HtmlEncode(msg);
        }
    }
}