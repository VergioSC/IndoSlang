using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Web;

namespace IndoSlang
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // redirect if no userId in URL
            if (!IsPostBack && string.IsNullOrEmpty(Request.QueryString["userId"]))
                Response.Redirect("ForgotPassword.aspx");
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;
            int userId;

            if (!int.TryParse(Request.QueryString["userId"], out userId))
            {
                ShowError("Invalid request.");
                return;
            }

            if (string.IsNullOrWhiteSpace(password) || password.Length < 8)
            {
                ShowError("Password must be at least 8 characters.");
                return;
            }

            if (password != confirmPassword)
            {
                ShowError("Passwords do not match.");
                return;
            }

            try
            {
                string newHash = HashPassword(password);

                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();

                    // update password
                    string query = "UPDATE [User] SET PasswordHash = @PasswordHash WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@PasswordHash", newHash);
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowSuccess("Password reset successfully! Redirecting to login...");
                Response.AddHeader("REFRESH", "2;URL=Login.aspx");
            }
            catch (Exception ex)
            {
                ShowError("Something went wrong. Please try again. " + ex.Message);
            }
        }

        private string HashPassword(string password)
        {
            int iterations = 100000;
            byte[] salt = new byte[16];

            using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(salt);
            }

            using (Rfc2898DeriveBytes pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations))
            {
                byte[] hash = pbkdf2.GetBytes(32);
                return "PBKDF2$" + iterations + "$" +
                       Convert.ToBase64String(salt) + "$" +
                       Convert.ToBase64String(hash);
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