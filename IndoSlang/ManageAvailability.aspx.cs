using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace IndoSlang
{
    public partial class ManageAvailability : System.Web.UI.Page
    {
        public string BuddyName = "Buddy";
        public List<SlotItem> Slots = new List<SlotItem>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["RoleID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (Convert.ToInt32(Session["RoleID"]) != 3)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);
            BuddyName = Session["UserName"] == null ? "Buddy" : Session["UserName"].ToString();

            if (!IsPostBack)
            {
                txtDate.Text = DateTime.Today.AddDays(1).ToString("yyyy-MM-dd");
            }

            LoadSlots(userId);
        }

        private void LoadSlots(int userId)
        {
            Slots.Clear();

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    SELECT AvailabilityID, Date, StartTime, Duration, IsBooked
                    FROM Availability
                    WHERE BuddyUserID = @UID
                    AND Date >= CAST(GETDATE() AS DATE)
                    ORDER BY Date, StartTime";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UID", userId);
                    conn.Open();

                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            DateTime date = Convert.ToDateTime(r["Date"]);
                            TimeSpan time = (TimeSpan)r["StartTime"];

                            Slots.Add(new SlotItem
                            {
                                AvailabilityID = Convert.ToInt32(r["AvailabilityID"]),
                                DateDisplay = date.ToString("MMM d, yyyy"),
                                DateValue = date.ToString("yyyy-MM-dd"),
                                TimeDisplay = DateTime.Today.Add(time).ToString("h:mm tt"),
                                TimeValue = DateTime.Today.Add(time).ToString("HH:mm"),
                                Duration = Convert.ToInt32(r["Duration"]),
                                IsBooked = Convert.ToBoolean(r["IsBooked"])
                            });
                        }
                    }
                }
            }
        }

        protected void btnAddSlot_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            if (string.IsNullOrWhiteSpace(txtDate.Text) || string.IsNullOrWhiteSpace(txtTime.Text))
            {
                ShowError("Please fill in both date and time.");
                return;
            }

            DateTime date;
            if (!DateTime.TryParse(txtDate.Text, out date))
            {
                ShowError("Invalid date.");
                return;
            }

            if (date.Date < DateTime.Today)
            {
                ShowError("Date must be today or in the future.");
                return;
            }

            TimeSpan time;
            if (!TimeSpan.TryParse(txtTime.Text, out time))
            {
                ShowError("Invalid time.");
                return;
            }

            int duration = Convert.ToInt32(ddlDuration.SelectedValue);
            string repeat = hfRepeat.Value;

            List<DateTime> dates = new List<DateTime>();
            dates.Add(date);

            if (repeat == "weekly")
            {
                for (int i = 1; i <= 3; i++)
                    dates.Add(date.AddDays(7 * i));
            }
            else if (repeat == "weekdays")
            {
                DateTime d = date.AddDays(1);
                int added = 0;
                while (added < 4)
                {
                    if (d.DayOfWeek != DayOfWeek.Saturday && d.DayOfWeek != DayOfWeek.Sunday)
                    {
                        dates.Add(d);
                        added++;
                    }
                    d = d.AddDays(1);
                }
            }

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                foreach (DateTime d in dates)
                {
                    if (repeat == "weekdays" &&
                        (d.DayOfWeek == DayOfWeek.Saturday || d.DayOfWeek == DayOfWeek.Sunday))
                        continue;

                    string query = @"
                        INSERT INTO Availability (BuddyUserID, Date, StartTime, Duration, IsBooked)
                        VALUES (@UID, @Date, @Time, @Dur, 0)";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UID", userId);
                        cmd.Parameters.AddWithValue("@Date", d.Date);
                        cmd.Parameters.AddWithValue("@Time", time);
                        cmd.Parameters.AddWithValue("@Dur", duration);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            ShowSuccess(dates.Count == 1 ? "Time slot added!" : "Slots added successfully!");
            LoadSlots(userId);
        }

        protected void btnEditConfirm_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            int availId;
            if (!int.TryParse(hfEditId.Value, out availId)) return;

            string newDateStr = Request.Form["editDate_" + availId];
            string newTimeStr = Request.Form["editTime_" + availId];
            string newDurStr = Request.Form["editDur_" + availId];

            DateTime newDate;
            TimeSpan newTime;
            int newDur;

            if (!DateTime.TryParse(newDateStr, out newDate) ||
                !TimeSpan.TryParse(newTimeStr, out newTime) ||
                !int.TryParse(newDurStr, out newDur))
            {
                ShowError("Invalid edit values. Please check date, time, and duration.");
                LoadSlots(userId);
                return;
            }

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    UPDATE Availability
                    SET Date = @Date, StartTime = @Time, Duration = @Dur
                    WHERE AvailabilityID = @AID AND BuddyUserID = @UID AND IsBooked = 0";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Date", newDate.Date);
                    cmd.Parameters.AddWithValue("@Time", newTime);
                    cmd.Parameters.AddWithValue("@Dur", newDur);
                    cmd.Parameters.AddWithValue("@AID", availId);
                    cmd.Parameters.AddWithValue("@UID", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            ShowSuccess("Slot updated!");
            LoadSlots(userId);
        }

        protected void btnDeleteConfirm_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            int availId;
            if (!int.TryParse(hfDeleteId.Value, out availId)) return;

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    DELETE FROM Availability
                    WHERE AvailabilityID = @AID AND BuddyUserID = @UID AND IsBooked = 0";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AID", availId);
                    cmd.Parameters.AddWithValue("@UID", userId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            ShowSuccess("Slot deleted.");
            LoadSlots(userId);
        }

        private void ShowSuccess(string msg)
        {
            lblSuccess.Text = msg;
            lblSuccess.Style["display"] = "block";
            lblError.Style["display"] = "none";
        }

        private void ShowError(string msg)
        {
            lblError.Text = msg;
            lblError.Style["display"] = "block";
            lblSuccess.Style["display"] = "none";
        }

        public class SlotItem
        {
            public int AvailabilityID { get; set; }
            public string DateDisplay { get; set; }
            public string DateValue { get; set; }
            public string TimeDisplay { get; set; }
            public string TimeValue { get; set; }
            public int Duration { get; set; }
            public bool IsBooked { get; set; }
        }
    }
}
