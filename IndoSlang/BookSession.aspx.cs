using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Script.Serialization;

namespace IndoSlang
{
    public partial class BookSession : System.Web.UI.Page
    {
        public string MemberName = "Member";
        public List<BuddyItem> Buddies = new List<BuddyItem>();
        public string BuddiesJson = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["RoleID"] == null)
            { Response.Redirect("~/Login.aspx"); return; }

            if (Convert.ToInt32(Session["RoleID"]) != 2)
            { Response.Redirect("~/MemberDashboard.aspx"); return; }

            Session["LastPage"] = "BookSession.aspx";
            if (!IsPostBack) LoadData();
        }

        private void LoadData()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();

                // get member name
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT ISNULL(FirstName,'') FROM [User] WHERE UserID=@UID", conn))
                {
                    cmd.Parameters.AddWithValue("@UID", userId);
                    object r = cmd.ExecuteScalar();
                    if (r != null && r != DBNull.Value) MemberName = r.ToString();
                }

                var buddyDict = new Dictionary<int, BuddyItem>();

                // join BuddyProfile to get correct SessionRate, ProficiencyLevel, City
                string sql = @"
                    SELECT
                        u.UserID,
                        ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS BuddyName,
                        ISNULL(bp.SessionRate, 25)        AS SessionRate,
                        ISNULL(bp.ProficiencyLevel,'Native') AS Proficiency,
                        ISNULL(bp.City,'')                AS City,
                        (SELECT COUNT(*) FROM [Session] s2
                         WHERE s2.BuddyUserID = u.UserID AND s2.Status = 'Completed') AS SessionCount,
                        a.AvailabilityID, a.Date, a.StartTime, a.Duration
                    FROM [User] u
                    LEFT JOIN BuddyProfile bp ON bp.UserID = u.UserID
                    INNER JOIN Availability a  ON a.BuddyUserID = u.UserID
                    WHERE u.RoleID = 3 AND u.Status = 'Active'
                      AND ISNULL(bp.IsActive, 1) = 1
                      AND a.IsBooked = 0 AND a.Date >= CAST(GETDATE() AS DATE)
                    ORDER BY u.FirstName, a.Date, a.StartTime";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            int buddyId = Convert.ToInt32(r["UserID"]);
                            if (!buddyDict.ContainsKey(buddyId))
                            {
                                buddyDict[buddyId] = new BuddyItem
                                {
                                    UserID = buddyId,
                                    Name = r["BuddyName"].ToString().Trim(),
                                    HourlyRate = Convert.ToDecimal(r["SessionRate"]),
                                    Proficiency = r["Proficiency"].ToString(),
                                    City = r["City"].ToString(),
                                    SessionCount = Convert.ToInt32(r["SessionCount"]),
                                    Description = "",
                                    Slots = new List<AvailSlot>()
                                };
                            }

                            DateTime date = Convert.ToDateTime(r["Date"]);
                            TimeSpan time;
                            object rawTime = r["StartTime"];
                            if (rawTime is TimeSpan) time = (TimeSpan)rawTime;
                            else time = TimeSpan.Parse(rawTime.ToString());

                            buddyDict[buddyId].Slots.Add(new AvailSlot
                            {
                                AvailabilityID = Convert.ToInt32(r["AvailabilityID"]),
                                Date = date.ToString("MMM d, yyyy"),
                                Time = DateTime.Today.Add(time).ToString("h:mm tt"),
                                Duration = Convert.ToInt32(r["Duration"])
                            });
                        }
                    }
                }

                // get topics from approved BuddyApplication
                foreach (var buddy in buddyDict.Values)
                {
                    try
                    {
                        using (SqlCommand cmd = new SqlCommand(@"
                            SELECT TOP 1 ISNULL(Topics,'') FROM BuddyApplication
                            WHERE UserID=@UID AND Status='Approved'
                            ORDER BY SubmittedAt DESC", conn))
                        {
                            cmd.Parameters.AddWithValue("@UID", buddy.UserID);
                            object r = cmd.ExecuteScalar();
                            if (r != null && r != DBNull.Value) buddy.Description = r.ToString();
                        }
                    }
                    catch { }
                }

                Buddies = buddyDict.Values.ToList();
            }

            BuddiesJson = new JavaScriptSerializer().Serialize(Buddies);
        }

        protected void btnBookConfirm_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            int availId;
            if (!int.TryParse(hfBookAvailId.Value, out availId))
            {
                ShowMessage("Invalid selection. Please try again.", false);
                LoadData();
                return;
            }

            string resultMsg = null;
            bool success = false;

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                using (SqlTransaction tx = conn.BeginTransaction())
                {
                    try
                    {
                        int buddyId = 0;
                        int duration = 0;
                        decimal rate = 25m;
                        bool slotAvailable = false;

                        using (SqlCommand cmd = new SqlCommand(@"
                            SELECT a.BuddyUserID, a.Duration, ISNULL(bp.SessionRate, 25) AS SessionRate
                            FROM Availability a
                            LEFT JOIN BuddyProfile bp ON bp.UserID = a.BuddyUserID
                            WHERE a.AvailabilityID = @AID AND a.IsBooked = 0
                              AND a.Date >= CAST(GETDATE() AS DATE)", conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@AID", availId);
                            using (SqlDataReader r = cmd.ExecuteReader())
                            {
                                if (r.Read())
                                {
                                    buddyId = Convert.ToInt32(r["BuddyUserID"]);
                                    duration = Convert.ToInt32(r["Duration"]);
                                    rate = Convert.ToDecimal(r["SessionRate"]);
                                    slotAvailable = true;
                                }
                            }
                        }

                        if (!slotAvailable)
                        {
                            tx.Rollback();
                            resultMsg = "This slot is no longer available.";
                        }
                        else
                        {
                            decimal amount = rate * duration / 60m;

                            string rawPay = Request.Form["payMethod"];
                            string payMethod = rawPay == "banking" ? "Banking" : "Card";

                            int newSessionId;
                            using (SqlCommand cmd = new SqlCommand(@"
                                INSERT INTO [Session]
                                (MemberUserID, BuddyUserID, AvailabilityID, Duration, Amount, Status, CreatedAt)
                                OUTPUT INSERTED.SessionID
                                VALUES (@MemberUID, @BuddyUID, @AID, @Dur, @Amount, 'Scheduled', GETDATE())", conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@MemberUID", userId);
                                cmd.Parameters.AddWithValue("@BuddyUID", buddyId);
                                cmd.Parameters.AddWithValue("@AID", availId);
                                cmd.Parameters.AddWithValue("@Dur", duration);
                                cmd.Parameters.AddWithValue("@Amount", amount);
                                newSessionId = Convert.ToInt32(cmd.ExecuteScalar());
                            }

                            using (SqlCommand cmd = new SqlCommand(@"
                                INSERT INTO Payment (SessionID, Amount, PaymentMethod, Status, PaidAt)
                                VALUES (@SID, @Amount, @Method, 'Completed', GETDATE())", conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@SID", newSessionId);
                                cmd.Parameters.AddWithValue("@Amount", amount);
                                cmd.Parameters.AddWithValue("@Method", payMethod);
                                cmd.ExecuteNonQuery();
                            }

                            using (SqlCommand cmd = new SqlCommand(
                                "UPDATE Availability SET IsBooked=1 WHERE AvailabilityID=@AID", conn, tx))
                            {
                                cmd.Parameters.AddWithValue("@AID", availId);
                                cmd.ExecuteNonQuery();
                            }

                            tx.Commit();
                            success = true;
                        }
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }

            if (success)
                ShowMessage("Session booked! You can view it in Session History.", true);
            else
                ShowMessage(resultMsg, false);

            LoadData();
        }

        private void ShowMessage(string msg, bool success)
        {
            lblMessage.Text = System.Web.HttpUtility.HtmlEncode(msg);
            lblMessage.CssClass = success ? "msg-success" : "msg-error";
            lblMessage.Style["display"] = "block";
        }

        public class BuddyItem
        {
            public int UserID { get; set; }
            public string Name { get; set; }
            public string Proficiency { get; set; }
            public string City { get; set; }
            public int SessionCount { get; set; }
            public string Description { get; set; }
            public decimal HourlyRate { get; set; }
            public List<AvailSlot> Slots { get; set; }
        }

        public class AvailSlot
        {
            public int AvailabilityID { get; set; }
            public string Date { get; set; }
            public string Time { get; set; }
            public int Duration { get; set; }
        }
    }
}