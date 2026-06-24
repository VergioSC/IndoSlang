using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Security.Cryptography;
using System.Web;

namespace IndoSlang
{
    public partial class BuddyProfile : System.Web.UI.Page
    {
        private int userId;
        public string UserDisplayName = "Buddy";
        public string ProfileImageUrl = "";
        public int TotalSessions = 0;
        public string AvgRating = "N/A";
        public string JoinedDate = "N/A";

        private string otpSecret;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["RoleID"] == null)
            { Response.Redirect("~/Login.aspx"); return; }

            if (Convert.ToInt32(Session["RoleID"]) != 3)
            { Response.Redirect("~/Login.aspx"); return; }

            userId = Convert.ToInt32(Session["UserID"]);
            UserDisplayName = HttpUtility.JavaScriptStringEncode(
                Session["UserName"] != null ? Session["UserName"].ToString() : "Buddy");

            otpSecret = ConfigurationManager.AppSettings["OtpSecret"];
            lnkLogo.HRef = "HomePage.aspx";
            lnkDashboard.HRef = "BuddyDashboard.aspx";
            Session["LastPage"] = "BuddyProfile.aspx";

            LoadDisplayData();
            if (!IsPostBack) LoadEditableFields();
        }

        private void LoadDisplayData()
        {
            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT ProfileImage, CreatedAt FROM [User] WHERE UserID=@UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                ProfileImageUrl = r["ProfileImage"] == DBNull.Value ? "" : r["ProfileImage"].ToString();
                                if (r["CreatedAt"] != DBNull.Value)
                                    JoinedDate = Convert.ToDateTime(r["CreatedAt"]).ToString("MMM yyyy");
                            }
                        }
                    }
                }
            }
            catch { }

            LoadStats();
        }

        private void LoadEditableFields()
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();

                // basic user fields
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT FirstName, LastName, Email, Username FROM [User] WHERE UserID=@UserID", conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            txtFirstName.Text = r["FirstName"] == DBNull.Value ? "" : r["FirstName"].ToString();
                            txtLastName.Text = r["LastName"] == DBNull.Value ? "" : r["LastName"].ToString();
                            txtCurrentEmail.Text = r["Email"] == DBNull.Value ? "" : r["Email"].ToString();
                            txtUsername.Text = r["Username"] == DBNull.Value ? "" : r["Username"].ToString();
                        }
                    }
                }

                // City and SessionRate from BuddyProfile
                try
                {
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT ISNULL(City,'') AS City, ISNULL(SessionRate,0) AS SessionRate FROM BuddyProfile WHERE UserID=@UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                txtCity.Text = r["City"].ToString();
                                txtRate.Text = r["SessionRate"].ToString();
                            }
                        }
                    }
                }
                catch { }
            }
        }

        private void LoadStats()
        {
            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM [Session] WHERE BuddyUserID=@UserID AND Status='Completed'", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        TotalSessions = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    using (SqlCommand cmd = new SqlCommand(@"
                        SELECT ISNULL(AVG(CAST(sr.Rating AS DECIMAL(3,1))),0)
                        FROM SessionReview sr
                        INNER JOIN [Session] s ON s.SessionID = sr.SessionID
                        WHERE s.BuddyUserID=@UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        object r = cmd.ExecuteScalar();
                        decimal avg = r != null && r != DBNull.Value ? Convert.ToDecimal(r) : 0;
                        AvgRating = avg > 0 ? avg.ToString("0.0") : "N/A";
                    }
                }
            }
            catch { }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string username = txtUsername.Text.Trim();
            string city = txtCity.Text.Trim();
            decimal rate = 0;
            decimal.TryParse(txtRate.Text.Trim(), out rate);

            if (string.IsNullOrWhiteSpace(firstName))
            { ShowMsg(lblSaveMsg, "First name is required.", false); return; }

            string imgFileName = null;
            if (fuPhoto.HasFile)
            {
                string ext = Path.GetExtension(fuPhoto.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif" && ext != ".webp")
                { ShowMsg(lblSaveMsg, "Photo must be JPG, PNG, GIF, or WEBP.", false); return; }
                if (fuPhoto.FileBytes.Length > 2 * 1024 * 1024)
                { ShowMsg(lblSaveMsg, "Photo must be under 2 MB.", false); return; }

                string folder = Server.MapPath("~/Images/Profiles/");
                if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                imgFileName = "user_" + userId + "_" + DateTime.Now.Ticks + ext;
                fuPhoto.SaveAs(Path.Combine(folder, imgFileName));
                ProfileImageUrl = imgFileName;
            }

            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();

                    string baseQuery = imgFileName != null
                        ? "UPDATE [User] SET FirstName=@FirstName, LastName=@LastName, Username=@Username, ProfileImage=@ProfileImage WHERE UserID=@UserID"
                        : "UPDATE [User] SET FirstName=@FirstName, LastName=@LastName, Username=@Username WHERE UserID=@UserID";

                    using (SqlCommand cmd = new SqlCommand(baseQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@FirstName", firstName);
                        cmd.Parameters.AddWithValue("@LastName", lastName);
                        cmd.Parameters.AddWithValue("@Username", username);
                        if (imgFileName != null) cmd.Parameters.AddWithValue("@ProfileImage", imgFileName);
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }

                    // upsert City and SessionRate in BuddyProfile (creates the row if it was never made)
                    using (SqlCommand cmd = new SqlCommand(@"
                        IF EXISTS (SELECT 1 FROM BuddyProfile WHERE UserID=@UserID)
                            UPDATE BuddyProfile SET City=@City, SessionRate=@Rate WHERE UserID=@UserID
                        ELSE
                            INSERT INTO BuddyProfile (UserID, City, SessionRate, ProficiencyLevel, IsActive, TotalEarned, ReviewCount, AvgRating)
                            VALUES (@UserID, @City, @Rate, 'Native', 1, 0, 0, 0)", conn))
                    {
                        cmd.Parameters.AddWithValue("@City", city);
                        cmd.Parameters.AddWithValue("@Rate", rate);
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }
                }

                Session["UserName"] = firstName;
                UserDisplayName = HttpUtility.JavaScriptStringEncode(firstName);
                ShowMsg(lblSaveMsg, "Profile updated successfully.", true);
                LoadEditableFields();
            }
            catch (Exception ex) { ShowMsg(lblSaveMsg, "Failed to save: " + ex.Message, false); }
        }

        protected void btnSendEmailOtp_Click(object sender, EventArgs e)
        {
            string newEmail = hfNewEmail.Value.Trim().ToLower();
            if (string.IsNullOrEmpty(newEmail)) { ShowMsg(lblEmailMsg, "Please enter a new email.", false); return; }
            if (IsEmailTaken(newEmail)) { ShowMsg(lblEmailMsg, "This email is already in use.", false); return; }

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand("DELETE FROM EmailOtp WHERE UserID=@UserID", conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            string otp = OtpHelper.GenerateNumericOtp();
            string otpHash = OtpHelper.HmacOtp(otp, otpSecret);
            OtpHelper.SaveOtpToDb(userId, otpHash, DateTime.Now.AddMinutes(5));
            EmailHelper.SendOtpEmail(newEmail, otp);

            Session["PendingEmail"] = newEmail;
            hfAction.Value = "otpSent";
            ShowMsg(lblEmailMsg, "Verification code sent to " + newEmail, true);
            LoadEditableFields();
        }

        protected void btnVerifyEmailOtp_Click(object sender, EventArgs e)
        {
            string otpInput = txtEmailOtp.Text.Trim();
            string pendingEmail = Session["PendingEmail"] != null ? Session["PendingEmail"].ToString() : "";

            if (string.IsNullOrEmpty(otpInput) || string.IsNullOrEmpty(pendingEmail))
            { ShowMsg(lblEmailMsg, "Invalid request. Please try again.", false); return; }

            string errorMsg;
            if (!OtpHelper.VerifyOtp(userId, otpInput, otpSecret, out errorMsg))
            {
                ShowMsg(lblEmailMsg, errorMsg, false);
                hfAction.Value = "otpSent";
                LoadEditableFields();
                return;
            }

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand("UPDATE [User] SET Email=@Email WHERE UserID=@UserID", conn))
                {
                    cmd.Parameters.AddWithValue("@Email", pendingEmail);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            Session["PendingEmail"] = null;
            hfAction.Value = "";
            ShowMsg(lblEmailMsg, "Email updated successfully!", true);
            LoadEditableFields();
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            string current = txtCurrentPw.Text;
            string newPw = txtNewPw.Text;
            string confirm = txtConfirmPw.Text;

            if (string.IsNullOrWhiteSpace(current) || string.IsNullOrWhiteSpace(newPw) || string.IsNullOrWhiteSpace(confirm))
            { ShowMsg(lblPwMsg, "All password fields are required.", false); return; }
            if (newPw.Length < 8) { ShowMsg(lblPwMsg, "New password must be at least 8 characters.", false); return; }
            if (newPw != confirm) { ShowMsg(lblPwMsg, "New passwords do not match.", false); return; }

            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();
                    string storedHash = "";
                    using (SqlCommand cmd = new SqlCommand("SELECT PasswordHash FROM [User] WHERE UserID=@UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        object result = cmd.ExecuteScalar();
                        storedHash = (result == null || result == DBNull.Value) ? "" : result.ToString();
                    }
                    if (!VerifyPassword(current, storedHash))
                    { ShowMsg(lblPwMsg, "Current password is incorrect.", false); return; }

                    using (SqlCommand cmd = new SqlCommand("UPDATE [User] SET PasswordHash=@Hash WHERE UserID=@UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@Hash", HashPassword(newPw));
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }
                }
                txtCurrentPw.Text = ""; txtNewPw.Text = ""; txtConfirmPw.Text = "";
                ShowMsg(lblPwMsg, "Password changed successfully.", true);
            }
            catch (Exception ex) { ShowMsg(lblPwMsg, "Failed: " + ex.Message, false); }
        }

        protected void btnDeleteAccount_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("UPDATE [User] SET Status='Closed' WHERE UserID=@UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.ExecuteNonQuery();
                    }
                }
                Session.Clear();
                Response.Redirect("~/HomePage.aspx");
            }
            catch (Exception ex) { ShowMsg(lblDeleteMsg, "Failed: " + ex.Message, false); }
        }

        private bool IsEmailTaken(string email)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT COUNT(*) FROM [User] WHERE Email=@Email AND UserID!=@UserID", conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
                }
            }
        }

        private void ShowMsg(System.Web.UI.WebControls.Label lbl, string msg, bool success)
        {
            lbl.Text = HttpUtility.HtmlEncode(msg);
            lbl.CssClass = success ? "msg-box success" : "msg-box error";
        }

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