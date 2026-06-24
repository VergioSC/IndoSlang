using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Web;

namespace IndoSlang
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null && Session["RoleID"] != null)
            {
                int roleId = Convert.ToInt32(Session["RoleID"]);
                string lastPage = Session["LastPage"] != null ? Session["LastPage"].ToString() : "";
                if (!string.IsNullOrEmpty(lastPage)) { Response.Redirect("~/" + lastPage); return; }
                if (roleId == 1) Response.Redirect("~/AdminDashboard.aspx");
                else if (roleId == 3) Response.Redirect("~/BuddyDashboard.aspx");
                else Response.Redirect("~/MemberDashboard.aspx");
            }

            if (!IsPostBack && Request.QueryString["error"] == "1")
                litError.Text = HttpUtility.HtmlEncode("Invalid email or password. Please try again.");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim().ToLower();
            string password = txtPassword.Text;

            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                litError.Text = HttpUtility.HtmlEncode("Please enter your email and password.");
                return;
            }

            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();
                    string query = @"
                        SELECT UserID, FirstName, RoleID, PasswordHash
                        FROM [User] WHERE Email = @Email AND Status = 'Active'";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", email);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read() && VerifyPassword(password, reader["PasswordHash"].ToString()))
                            {
                                int roleId = Convert.ToInt32(reader["RoleID"]);
                                string firstName = reader["FirstName"].ToString();

                                Session["UserID"] = reader["UserID"];
                                Session["UserName"] = string.IsNullOrWhiteSpace(firstName) ? email : firstName;
                                Session["RoleID"] = roleId.ToString();
                                Session["Role"] = roleId == 1 ? "Admin" : roleId == 3 ? "Buddy" : "Member";

                                string lastPage = Session["LastPage"] != null ? Session["LastPage"].ToString() : "";
                                Session["LastPage"] = null;

                                if (!string.IsNullOrEmpty(lastPage)) { Response.Redirect("~/" + lastPage); return; }
                                if (roleId == 1) Response.Redirect("~/AdminDashboard.aspx");
                                else if (roleId == 3) Response.Redirect("~/BuddyDashboard.aspx");
                                else Response.Redirect("~/MemberDashboard.aspx");
                            }
                            else
                            {
                                Response.Redirect("~/Login.aspx?error=1");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                litError.Text = HttpUtility.HtmlEncode("Login failed. Please try again. " + ex.Message);
            }
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
    }
}