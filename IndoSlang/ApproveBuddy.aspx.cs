using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace IndoSlang
{
    public partial class ApproveBuddy : System.Web.UI.Page
    {
        public List<ApplicationItem> Applications = new List<ApplicationItem>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["RoleID"] == null)
            { Response.Redirect("~/Login.aspx"); return; }

            if (Convert.ToInt32(Session["RoleID"]) != 1)
            { Response.Redirect("~/Login.aspx"); return; }

            LoadApplications();
        }

        private void LoadApplications()
        {
            Applications.Clear();
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"
                    SELECT ba.BuddyApplicationID,
                           ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS FullName,
                           u.Email, u.Username,
                           ba.WhyBuddy, ba.Status, ba.SubmittedAt
                    FROM BuddyApplication ba
                    INNER JOIN [User] u ON ba.UserID = u.UserID
                    ORDER BY
                        CASE WHEN ba.Status = 'Pending' THEN 0 ELSE 1 END,
                        ba.SubmittedAt DESC", conn))
                {
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            Applications.Add(new ApplicationItem
                            {
                                ApplicationID = Convert.ToInt32(r["BuddyApplicationID"]),
                                FullName = r["FullName"].ToString().Trim(),
                                Email = r["Email"].ToString(),
                                Username = r["Username"].ToString(),
                                Reason = r["WhyBuddy"] == DBNull.Value ? "" : r["WhyBuddy"].ToString(),
                                Status = r["Status"].ToString(),
                                AppliedAt = r["SubmittedAt"] == DBNull.Value ? "" : Convert.ToDateTime(r["SubmittedAt"]).ToString("MMM d, yyyy")
                            });
                        }
                    }
                }
            }
        }

        protected void btnActionConfirm_Click(object sender, EventArgs e)
        {
            int applicationId;
            if (!int.TryParse(hfApplicationId.Value, out applicationId)) return;

            string action = hfAction.Value;
            if (action != "approve" && action != "reject") return;

            int adminId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();

                if (action == "approve")
                {
                    int applicantUserId = 0;
                    string appCity = "";
                    decimal appRate = 25m;
                    string appProficiency = "Native";

                    using (SqlCommand cmd = new SqlCommand(@"
                        SELECT UserID,
                               ISNULL(City,'')                    AS City,
                               ISNULL(SessionRate, 25)            AS SessionRate,
                               ISNULL(ProficiencyLevel,'Native')  AS ProficiencyLevel
                        FROM BuddyApplication
                        WHERE BuddyApplicationID=@AID AND Status='Pending'", conn))
                    {
                        cmd.Parameters.AddWithValue("@AID", applicationId);
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (!r.Read())
                            {
                                ShowMessage("Application not found or already processed.", false);
                                LoadApplications();
                                return;
                            }
                            applicantUserId = Convert.ToInt32(r["UserID"]);
                            appCity        = r["City"].ToString();
                            appRate        = Convert.ToDecimal(r["SessionRate"]);
                            appProficiency = r["ProficiencyLevel"].ToString();
                        }
                    }

                    using (SqlCommand cmd = new SqlCommand(@"
                        UPDATE BuddyApplication
                        SET Status='Approved', ReviewedByUserID=@Admin, ReviewedAt=GETDATE()
                        WHERE BuddyApplicationID=@AID", conn))
                    {
                        cmd.Parameters.AddWithValue("@Admin", adminId);
                        cmd.Parameters.AddWithValue("@AID", applicationId);
                        cmd.ExecuteNonQuery();
                    }

                    using (SqlCommand cmd = new SqlCommand(
                        "UPDATE [User] SET RoleID=3 WHERE UserID=@UID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UID", applicantUserId);
                        cmd.ExecuteNonQuery();
                    }

                    // Create or activate the BuddyProfile so the buddy appears in BookSession
                    using (SqlCommand cmd = new SqlCommand(@"
                        IF EXISTS (SELECT 1 FROM BuddyProfile WHERE UserID=@UID)
                            UPDATE BuddyProfile
                            SET IsActive=1, City=@City, SessionRate=@Rate, ProficiencyLevel=@Prof
                            WHERE UserID=@UID
                        ELSE
                            INSERT INTO BuddyProfile (UserID, City, SessionRate, ProficiencyLevel, IsActive, TotalEarned, ReviewCount, AvgRating)
                            VALUES (@UID, @City, @Rate, @Prof, 1, 0, 0, 0)", conn))
                    {
                        cmd.Parameters.AddWithValue("@UID",  applicantUserId);
                        cmd.Parameters.AddWithValue("@City", appCity);
                        cmd.Parameters.AddWithValue("@Rate", appRate);
                        cmd.Parameters.AddWithValue("@Prof", appProficiency);
                        cmd.ExecuteNonQuery();
                    }

                    ShowMessage("Application approved. The user is now a Buddy.", true);
                }
                else
                {
                    using (SqlCommand cmd = new SqlCommand(@"
                        UPDATE BuddyApplication
                        SET Status='Rejected', ReviewedByUserID=@Admin, ReviewedAt=GETDATE()
                        WHERE BuddyApplicationID=@AID", conn))
                    {
                        cmd.Parameters.AddWithValue("@Admin", adminId);
                        cmd.Parameters.AddWithValue("@AID", applicationId);
                        cmd.ExecuteNonQuery();
                    }

                    ShowMessage("Application rejected.", true);
                }
            }

            LoadApplications();
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = System.Web.HttpUtility.HtmlEncode(msg);
            lblMessage.CssClass = success ? "msg-success" : "msg-error";
            lblMessage.Style["display"] = "block";
        }

        public class ApplicationItem
        {
            public int ApplicationID { get; set; }
            public string FullName { get; set; }
            public string Email { get; set; }
            public string Username { get; set; }
            public string Reason { get; set; }
            public string Status { get; set; }
            public string AppliedAt { get; set; }
        }
    }
}