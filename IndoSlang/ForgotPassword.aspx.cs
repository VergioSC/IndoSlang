using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

namespace IndoSlang
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSendOtp_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim().ToLower();

            if (string.IsNullOrWhiteSpace(email))
            {
                ShowError("Please enter your email address.");
                return;
            }

            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();

                    // check if email exists and is active
                    string query = "SELECT UserID FROM [User] WHERE Email = @Email AND Status = 'Active'";
                    int userId = 0;

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        object result = cmd.ExecuteScalar();

                        if (result == null)
                        {
                            // dont reveal if email exists or not
                            ShowSuccess("If that email is registered, you'll receive a verification code shortly.");
                            return;
                        }

                        userId = Convert.ToInt32(result);
                    }

                    // clean up old OTPs for this user
                    string cleanupOtp = "DELETE FROM EmailOtp WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(cleanupOtp, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }

                    // generate and send OTP
                    string otp = OtpHelper.GenerateNumericOtp();
                    string secret = ConfigurationManager.AppSettings["OtpSecret"];
                    string otpHash = OtpHelper.HmacOtp(otp, secret);
                    DateTime expiresAt = DateTime.Now.AddMinutes(5);

                    OtpHelper.SaveOtpToDb(userId, otpHash, expiresAt);
                    EmailHelper.SendOtpEmail(email, otp);

                    Response.Redirect("VerifyOtp.aspx?userId=" + userId + "&mode=reset");
                }
            }
            catch (Exception ex)
            {
                ShowError("Something went wrong. Please try again. " + ex.Message);
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