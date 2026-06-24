using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

namespace IndoSlang
{
    public partial class VerifyOtp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // redirect if no userId in URL
                if (string.IsNullOrEmpty(Request.QueryString["userId"]))
                    Response.Redirect("Register.aspx");
            }
        }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            string otpEntered = txtOtp.Text.Trim();
            int userId;

            if (!int.TryParse(Request.QueryString["userId"], out userId))
            {
                ShowError("Invalid request.");
                return;
            }

            if (string.IsNullOrWhiteSpace(otpEntered) || otpEntered.Length != 6)
            {
                ShowError("Please enter the 6-digit OTP.");
                return;
            }

            string secret = ConfigurationManager.AppSettings["OtpSecret"];
            string errorMsg;

            if (OtpHelper.VerifyOtp(userId, otpEntered, secret, out errorMsg))
            {
                string mode = Request.QueryString["mode"];

                if (mode == "reset")
                {
                    // forgot password flow - go to reset page
                    Response.Redirect("ResetPassword.aspx?userId=" + userId);
                }
                else
                {
                    // register flow - activate user and go to login
                    ActivateUser(userId);
                    ShowSuccess("Email verified! Redirecting to login...");
                    Response.AddHeader("REFRESH", "2;URL=Login.aspx");
                }
            }
            else
            {
                ShowError(errorMsg);
            }
        }

        private void ActivateUser(int userId)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                string query = "UPDATE [User] SET Status = 'Active' WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void ShowError(string message)
        {
            litError.Text = HttpUtility.HtmlEncode(message);
            litSuccess.Text = "";
        }

        private void ShowSuccess(string message)
        {
            litSuccess.Text = HttpUtility.HtmlEncode(message);
            litError.Text = "";
        }
    }
}