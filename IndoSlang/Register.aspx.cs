using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using System.Web;

namespace IndoSlang
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                ClearMessages();
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            ClearMessages();

            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string email = txtEmail.Text.Trim().ToLower();
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;

            if (!IsFormValid(firstName, lastName, email, username, password, confirmPassword))
                return;

            string assignedLevel = Session["AssignedLevel"] != null ? Session["AssignedLevel"].ToString() : "Beginner";
            int placementScore = Session["PlacementScore"] != null ? Convert.ToInt32(Session["PlacementScore"]) : 0;
            string goal = Session["OnboardingGoal"] != null ? Session["OnboardingGoal"].ToString() : "";
            string frequency = Session["OnboardingFrequency"] != null ? Session["OnboardingFrequency"].ToString() : "";
            string knowledge = Session["OnboardingKnowledge"] != null ? Session["OnboardingKnowledge"].ToString() : "";

            try
            {
                int newUserId;

                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();

                    if (EmailExists(conn, email)) { ShowError("This email is already registered."); return; }
                    if (UsernameExists(conn, username)) { ShowError("This username is already taken."); return; }

                    // cleanup Pending: PlacementResult → EmailOtp → User
                    using (SqlCommand cmd = new SqlCommand(@"
                        DELETE FROM PlacementResult WHERE UserID IN (
                            SELECT UserID FROM [User] WHERE (Email=@Email OR Username=@Username) AND Status='Pending')
                        DELETE FROM EmailOtp WHERE UserID IN (
                            SELECT UserID FROM [User] WHERE (Email=@Email OR Username=@Username) AND Status='Pending')
                        DELETE FROM [User] WHERE (Email=@Email OR Username=@Username) AND Status='Pending'", conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.ExecuteNonQuery();
                    }

                    // cleanup Closed: PlacementResult → EmailOtp → User
                    using (SqlCommand cmd = new SqlCommand(@"
                        DELETE FROM PlacementResult WHERE UserID IN (
                            SELECT UserID FROM [User] WHERE (Email=@Email OR Username=@Username) AND Status='Closed')
                        DELETE FROM EmailOtp WHERE UserID IN (
                            SELECT UserID FROM [User] WHERE (Email=@Email OR Username=@Username) AND Status='Closed')
                        DELETE FROM [User] WHERE (Email=@Email OR Username=@Username) AND Status='Closed'", conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.ExecuteNonQuery();
                    }

                    string passwordHash = HashPassword(password);

                    using (SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO [User]
                        (RoleID, FirstName, LastName, Email, Username, PasswordHash, ProfileImage, CurrentLevel, Status, CreatedAt)
                        OUTPUT INSERTED.UserID
                        VALUES (@RoleID, @FirstName, @LastName, @Email, @Username, @PasswordHash, @ProfileImage, @CurrentLevel, 'Pending', GETDATE())", conn))
                    {
                        cmd.Parameters.AddWithValue("@RoleID", 2);
                        cmd.Parameters.AddWithValue("@FirstName", firstName);
                        cmd.Parameters.AddWithValue("@LastName", lastName);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@PasswordHash", passwordHash);
                        cmd.Parameters.AddWithValue("@ProfileImage", DBNull.Value);
                        cmd.Parameters.AddWithValue("@CurrentLevel", assignedLevel);
                        newUserId = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    using (SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO PlacementResult
                        (UserID, SessionToken, Score, AssignedLevel, OnboardingGoal, OnboardingFrequency, OnboardingKnowledge, TakenAt)
                        VALUES (@UserID, @SessionToken, @Score, @AssignedLevel, @Goal, @Frequency, @Knowledge, GETDATE())", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", newUserId);
                        cmd.Parameters.AddWithValue("@SessionToken", Session.SessionID);
                        cmd.Parameters.AddWithValue("@Score", placementScore);
                        cmd.Parameters.AddWithValue("@AssignedLevel", assignedLevel);
                        cmd.Parameters.AddWithValue("@Goal", goal);
                        cmd.Parameters.AddWithValue("@Frequency", frequency);
                        cmd.Parameters.AddWithValue("@Knowledge", knowledge);
                        cmd.ExecuteNonQuery();
                    }

                    string otp = OtpHelper.GenerateNumericOtp();
                    string secret = ConfigurationManager.AppSettings["OtpSecret"];
                    string otpHash = OtpHelper.HmacOtp(otp, secret);
                    OtpHelper.SaveOtpToDb(newUserId, otpHash, DateTime.Now.AddMinutes(5));

                    try { EmailHelper.SendOtpEmail(email, otp); }
                    catch (Exception ex)
                    {
                        ShowError("Account created but email failed to send: " + ex.Message);
                        return;
                    }
                }

                Session.Remove("AssignedLevel");
                Session.Remove("PlacementScore");
                Session.Remove("StartModule");
                Session.Remove("OnboardingGoal");
                Session.Remove("OnboardingFrequency");
                Session.Remove("OnboardingKnowledge");

                Response.Redirect("VerifyOtp.aspx?userId=" + newUserId);
            }
            catch (Exception ex)
            {
                ShowError("Registration failed. Please try again. " + ex.Message);
            }
        }

        private bool IsFormValid(string firstName, string lastName, string email, string username, string password, string confirmPassword)
        {
            if (string.IsNullOrWhiteSpace(firstName)) { ShowError("First name is required."); return false; }
            if (string.IsNullOrWhiteSpace(lastName)) { ShowError("Last name is required."); return false; }
            if (string.IsNullOrWhiteSpace(email)) { ShowError("Email is required."); return false; }
            if (!IsValidEmail(email)) { ShowError("Please enter a valid email address."); return false; }
            if (string.IsNullOrWhiteSpace(username)) { ShowError("Username is required."); return false; }
            if (username.Contains(" ")) { ShowError("Username cannot contain spaces."); return false; }
            if (username.Length < 3) { ShowError("Username must be at least 3 characters."); return false; }
            if (string.IsNullOrWhiteSpace(password)) { ShowError("Password is required."); return false; }
            if (password.Length < 8) { ShowError("Password must be at least 8 characters."); return false; }
            if (password != confirmPassword) { ShowError("Passwords do not match."); return false; }
            return true;
        }

        private bool EmailExists(SqlConnection conn, string email)
        {
            using (SqlCommand cmd = new SqlCommand(
                "SELECT COUNT(*) FROM [User] WHERE Email=@Email AND Status NOT IN ('Pending','Closed')", conn))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        private bool UsernameExists(SqlConnection conn, string username)
        {
            using (SqlCommand cmd = new SqlCommand(
                "SELECT COUNT(*) FROM [User] WHERE Username=@Username AND Status NOT IN ('Pending','Closed')", conn))
            {
                cmd.Parameters.AddWithValue("@Username", username);
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        private bool IsValidEmail(string email)
        {
            return Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$");
        }

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

        private void ShowError(string msg) { litError.Text = HttpUtility.HtmlEncode(msg); litSuccess.Text = ""; }
        private void ShowSuccess(string msg) { litSuccess.Text = HttpUtility.HtmlEncode(msg); litError.Text = ""; }
        private void ClearMessages() { litError.Text = ""; litSuccess.Text = ""; }
    }
}