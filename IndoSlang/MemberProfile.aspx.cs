using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Security.Cryptography;
using System.Web;

namespace IndoSlang
{
    public partial class MemberProfile : System.Web.UI.Page
    {
        public string UserDisplayName = "Member";
        public string AvatarSrc = "";

        private int userId;
        private string otpSecret;

        protected void Page_Load(object sender, EventArgs e)
        {
            // check session
            if (Session["UserID"] == null || Session["RoleID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int roleId = Convert.ToInt32(Session["RoleID"]);

            // only member and buddy
            if (roleId != 2 && roleId != 3)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            userId = Convert.ToInt32(Session["UserID"]);
            UserDisplayName = HttpUtility.JavaScriptStringEncode(
                Session["UserName"] == null ? "Member" : Session["UserName"].ToString()
            );

            // same secret as VerifyOtp
            otpSecret = ConfigurationManager.AppSettings["OtpSecret"];

            // dashboard link by role
            string dashboardUrl = roleId == 3 ? "BuddyDashboard.aspx" : "MemberDashboard.aspx";
            lnkLogo.HRef = "HomePage.aspx";
            lnkDashboard.HRef = dashboardUrl;
            lnkBackDash.HRef = dashboardUrl;

            // save last page
            Session["LastPage"] = "MemberProfile.aspx";

            if (!IsPostBack)
            {
                LoadProfile();
            }
        }

        // load user data into form fields
        private void LoadProfile()
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    SELECT FirstName, LastName, Email, Username, ProfileImage, CurrentLevel
                    FROM [User] WHERE UserID = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtFirstName.Text = reader["FirstName"].ToString();
                            txtLastName.Text = reader["LastName"].ToString();
                            txtUsername.Text = reader["Username"].ToString();
                            txtCurrentEmail.Text = reader["Email"].ToString();
                            txtCurrentLevel.Text = reader["CurrentLevel"].ToString();

                            // display name and level badge
                            litFullName.Text = HttpUtility.HtmlEncode(reader["FirstName"] + " " + reader["LastName"]);
                            litLevel.Text = HttpUtility.HtmlEncode(reader["CurrentLevel"].ToString());

                            // avatar src
                            string profileImage = reader["ProfileImage"].ToString();
                            if (!string.IsNullOrEmpty(profileImage))
                            {
                                AvatarSrc = HttpUtility.JavaScriptStringEncode(ResolveUrl("~/Images/Profiles/" + profileImage));
                            }
                        }
                    }
                }
            }
        }

        // save profile name and username
        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string username = txtUsername.Text.Trim();

            if (string.IsNullOrEmpty(firstName) || string.IsNullOrEmpty(lastName) || string.IsNullOrEmpty(username))
            {
                litProfileMsg.Text = HttpUtility.HtmlEncode("All fields are required.");
                return;
            }

            // check username not taken by another user
            if (IsUsernameTaken(username))
            {
                litProfileMsg.Text = HttpUtility.HtmlEncode("Username is already taken.");
                return;
            }

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    UPDATE [User]
                    SET FirstName = @FirstName, LastName = @LastName, Username = @Username
                    WHERE UserID = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@FirstName", firstName);
                    cmd.Parameters.AddWithValue("@LastName", lastName);
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // update session name
            Session["UserName"] = firstName;
            UserDisplayName = HttpUtility.JavaScriptStringEncode(firstName);

            litProfileMsg.Text = HttpUtility.HtmlEncode("Profile updated successfully!");
            LoadProfile();
        }

        // upload and save profile photo
        protected void btnUploadPhoto_Click(object sender, EventArgs e)
        {
            if (!fuPhoto.HasFile)
            {
                litPhotoMsg.Text = HttpUtility.HtmlEncode("No file selected.");
                return;
            }

            string ext = Path.GetExtension(fuPhoto.FileName).ToLower();
            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif" && ext != ".webp")
            {
                litPhotoMsg.Text = HttpUtility.HtmlEncode("Only jpg, png, gif, webp allowed.");
                return;
            }

            // max 2MB check
            if (fuPhoto.FileBytes.Length > 2 * 1024 * 1024)
            {
                litPhotoMsg.Text = HttpUtility.HtmlEncode("File too large. Max 2MB.");
                return;
            }

            // save file to ~/Images/Profiles/
            string folder = Server.MapPath("~/Images/Profiles/");
            if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);

            string fileName = "user_" + userId + "_" + DateTime.Now.Ticks + ext;
            string filePath = Path.Combine(folder, fileName);
            fuPhoto.SaveAs(filePath);

            // update db
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = "UPDATE [User] SET ProfileImage = @ProfileImage WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ProfileImage", fileName);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            litPhotoMsg.Text = HttpUtility.HtmlEncode("Photo updated!");
            LoadProfile();
        }

        // delete profile photo
        protected void btnDeletePhoto_Click(object sender, EventArgs e)
        {
            // get current filename from db
            string currentFile = "";
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = "SELECT ProfileImage FROM [User] WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    currentFile = (result == null || result == DBNull.Value) ? "" : result.ToString();
                }
            }

            // delete file from server
            if (!string.IsNullOrEmpty(currentFile))
            {
                string filePath = Server.MapPath("~/Images/Profiles/" + currentFile);
                if (File.Exists(filePath)) File.Delete(filePath);
            }

            // set ProfileImage to NULL in db
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = "UPDATE [User] SET ProfileImage = NULL WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            litPhotoMsg.Text = HttpUtility.HtmlEncode("Photo removed.");
            LoadProfile();
        }

        // send OTP to new email
        protected void btnSendEmailOtp_Click(object sender, EventArgs e)
        {
            string newEmail = hfNewEmail.Value.Trim().ToLower();

            if (string.IsNullOrEmpty(newEmail))
            {
                litEmailMsg.Text = HttpUtility.HtmlEncode("Please enter a new email.");
                return;
            }

            // check email not already used by another user
            if (IsEmailTaken(newEmail))
            {
                litEmailMsg.Text = HttpUtility.HtmlEncode("This email is already in use.");
                return;
            }

            // delete existing OTPs for this user first
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string delQuery = "DELETE FROM EmailOtp WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(delQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // generate OTP
            string otpCode = OtpHelper.GenerateNumericOtp();
            string otpHash = OtpHelper.HmacOtp(otpCode, otpSecret);
            DateTime expiry = DateTime.Now.AddMinutes(5);

            // save to db
            OtpHelper.SaveOtpToDb(userId, otpHash, expiry);

            // send email
            EmailHelper.SendOtpEmail(newEmail, otpCode);

            // store pending email in session
            Session["PendingEmail"] = newEmail;
            hfAction.Value = "otpSent";

            litEmailMsg.Text = HttpUtility.HtmlEncode("Verification code sent to " + newEmail);
            LoadProfile();
        }

        // verify OTP and update email
        protected void btnVerifyEmailOtp_Click(object sender, EventArgs e)
        {
            string otpInput = txtEmailOtp.Text.Trim();
            string pendingEmail = Session["PendingEmail"] != null ? Session["PendingEmail"].ToString() : "";

            if (string.IsNullOrEmpty(otpInput) || string.IsNullOrEmpty(pendingEmail))
            {
                litEmailMsg.Text = HttpUtility.HtmlEncode("Invalid request. Please try again.");
                return;
            }

            // verify using OtpHelper
            string errorMsg;
            if (!OtpHelper.VerifyOtp(userId, otpInput, otpSecret, out errorMsg))
            {
                litEmailMsg.Text = HttpUtility.HtmlEncode(errorMsg);
                hfAction.Value = "otpSent";
                LoadProfile();
                return;
            }

            // update email in db
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = "UPDATE [User] SET Email = @Email WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", pendingEmail);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            Session["PendingEmail"] = null;
            hfAction.Value = "";
            litEmailMsg.Text = HttpUtility.HtmlEncode("Email updated successfully!");
            LoadProfile();
        }

        // change password
        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            string oldPassword = txtOldPassword.Text;
            string newPassword = txtNewPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;

            if (string.IsNullOrEmpty(oldPassword) || string.IsNullOrEmpty(newPassword) || string.IsNullOrEmpty(confirmPassword))
            {
                litPwdMsg.Text = HttpUtility.HtmlEncode("All password fields are required.");
                return;
            }

            if (newPassword != confirmPassword)
            {
                litPwdMsg.Text = HttpUtility.HtmlEncode("New passwords do not match.");
                return;
            }

            if (newPassword.Length < 8)
            {
                litPwdMsg.Text = HttpUtility.HtmlEncode("New password must be at least 8 characters.");
                return;
            }

            // get current hash
            string currentHash = "";
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = "SELECT PasswordHash FROM [User] WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    currentHash = (result == null || result == DBNull.Value) ? "" : result.ToString();
                }
            }

            // verify old password
            if (!VerifyPassword(oldPassword, currentHash))
            {
                litPwdMsg.Text = HttpUtility.HtmlEncode("Current password is incorrect.");
                return;
            }

            // hash and save new password
            string newHash = HashPassword(newPassword);
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = "UPDATE [User] SET PasswordHash = @PasswordHash WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PasswordHash", newHash);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // clear password fields
            txtOldPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";

            litPwdMsg.Text = HttpUtility.HtmlEncode("Password changed successfully!");
            LoadProfile();
        }

        // close account
        protected void btnCloseAccount_Click(object sender, EventArgs e)
        {
            string password = txtClosePassword.Text;

            if (string.IsNullOrEmpty(password))
            {
                litCloseMsg.Text = HttpUtility.HtmlEncode("Please enter your password to confirm.");
                return;
            }

            // verify password
            string currentHash = "";
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = "SELECT PasswordHash FROM [User] WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    currentHash = (result == null || result == DBNull.Value) ? "" : result.ToString();
                }
            }

            if (!VerifyPassword(password, currentHash))
            {
                litCloseMsg.Text = HttpUtility.HtmlEncode("Incorrect password.");
                return;
            }

            // set status closed
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = "UPDATE [User] SET Status = 'Closed' WHERE UserID = @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // clear session and go home
            Session.Clear();
            Response.Redirect("~/HomePage.aspx");
        }

        // check username taken by another user
        private bool IsUsernameTaken(string username)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = "SELECT COUNT(*) FROM [User] WHERE Username = @Username AND UserID != @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
                }
            }
        }

        // check email taken by another user
        private bool IsEmailTaken(string email)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = "SELECT COUNT(*) FROM [User] WHERE Email = @Email AND UserID != @UserID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
                }
            }
        }

        // verify PBKDF2 password
        private bool VerifyPassword(string password, string storedHash)
        {
            try
            {
                string[] parts = storedHash.Split('$');
                if (parts.Length != 4 || parts[0] != "PBKDF2") return false;
                int iterations = int.Parse(parts[1]);
                byte[] salt = Convert.FromBase64String(parts[2]);
                byte[] expected = Convert.FromBase64String(parts[3]);
                using (Rfc2898DeriveBytes pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations))
                {
                    byte[] actual = pbkdf2.GetBytes(32);
                    int diff = 0;
                    for (int i = 0; i < actual.Length; i++) diff |= actual[i] ^ expected[i];
                    return diff == 0;
                }
            }
            catch { return false; }
        }

        // hash new password PBKDF2
        private string HashPassword(string password)
        {
            int iterations = 100000;
            byte[] salt = new byte[16];
            using (RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider())
                rng.GetBytes(salt);
            using (Rfc2898DeriveBytes pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations))
            {
                byte[] hash = pbkdf2.GetBytes(32);
                return "PBKDF2$" + iterations + "$" + Convert.ToBase64String(salt) + "$" + Convert.ToBase64String(hash);
            }
        }
    }
}