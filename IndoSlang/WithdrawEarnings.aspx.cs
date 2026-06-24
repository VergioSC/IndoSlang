using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Net.NetworkInformation;
using System.Web;

namespace IndoSlang
{
    public partial class WithdrawEarnings : System.Web.UI.Page
    {
        private int userId;
        public string UserDisplayName  = "Buddy";
        public decimal AvailableBalance = 0;
        public decimal TotalEarned      = 0;
        public string  LastWithdrawalDate = "N/A";
        public string  AlertMessage     = "";
        public bool    AlertSuccess     = false;
        public List<WithdrawalItem> Withdrawals = new List<WithdrawalItem>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["RoleID"] == null)
            {
                Response.Redirect("~/Login.aspx"); return;
            }
            if (Convert.ToInt32(Session["RoleID"]) != 3)
            {
                Response.Redirect("~/Login.aspx"); return;
            }

            userId = Convert.ToInt32(Session["UserID"]);
            UserDisplayName = HttpUtility.JavaScriptStringEncode(
                Session["UserName"] != null ? Session["UserName"].ToString() : "Buddy");

            if (!IsPostBack)
            {
                string msg = Request.QueryString["msg"];
                if (!string.IsNullOrEmpty(msg))
                {
                    AlertMessage = msg;
                    AlertSuccess = Request.QueryString["ok"] == "1";
                }

                LoadStats();
                LoadHistory();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string method = hdnPaymentMethod.Value.Trim();
            string notes  = txtNotes.Text.Trim();
            decimal amount;

            if (string.IsNullOrEmpty(method))
            {
                AlertMessage = "Please select a payment method.";
                AlertSuccess = false;
                LoadStats(); LoadHistory(); return;
            }

            if (!decimal.TryParse(txtAmount.Text.Trim(), out amount) || amount < 10)
            {
                AlertMessage = "Please enter a valid amount (minimum RM 10.00).";
                AlertSuccess = false;
                LoadStats(); LoadHistory(); return;
            }

            if (amount > AvailableBalance)
            {
                LoadStats();
                if (amount > AvailableBalance)
                {
                    AlertMessage = "Withdrawal amount exceeds your available balance.";
                    AlertSuccess = false;
                    LoadHistory(); return;
                }
            }

            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();
                    using (var cmd = new SqlCommand(
                        @"INSERT INTO Withdrawal (BuddyUserID, Amount, PaymentMethod, Notes, Status, RequestedAt)
                          VALUES (@BuddyID, @Amount, @Method, @Notes, 'Pending', GETDATE())", conn))
                    {
                        cmd.Parameters.AddWithValue("@BuddyID", userId);
                        cmd.Parameters.AddWithValue("@Amount",  amount);
                        cmd.Parameters.AddWithValue("@Method",  method);
                        cmd.Parameters.AddWithValue("@Notes",   notes);
                        cmd.ExecuteNonQuery();
                    }
                }

                string msg = Uri.EscapeDataString("Withdrawal request submitted successfully.");
                Response.Redirect("WithdrawEarnings.aspx?msg=" + msg + "&ok=1");
            }
            catch (Exception ex)
            {
                AlertMessage = "Failed to submit request: " + ex.Message;
                AlertSuccess = false;
                LoadStats(); LoadHistory();
            }
        }

        private void LoadStats()
        {
            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();

                    using (var cmd = new SqlCommand(
                        @"SELECT ISNULL(SUM(ISNULL(Amount * 0.95, 0)), 0) AS TotalEarned
                        FROM[Session]
                        WHERE BuddyUserID = @BuddyID AND Status = 'Completed'", conn))
                    {
                        cmd.Parameters.AddWithValue("@BuddyID", userId);
                        object result = cmd.ExecuteScalar();
                        TotalEarned = result != DBNull.Value ? Convert.ToDecimal(result) : 0;
                    }

                    decimal totalWithdrawn = 0;
                    using (var cmd = new SqlCommand(
                        @"SELECT ISNULL(SUM(Amount), 0)
                          FROM Withdrawal
                          WHERE BuddyUserID = @BuddyID AND Status IN ('Pending','Approved')", conn))
                    {
                        cmd.Parameters.AddWithValue("@BuddyID", userId);
                        object result = cmd.ExecuteScalar();
                        totalWithdrawn = result != DBNull.Value ? Convert.ToDecimal(result) : 0;
                    }

                    AvailableBalance = Math.Max(0, TotalEarned - totalWithdrawn);

                    using (var cmd = new SqlCommand(
                        @"SELECT TOP 1 RequestedAt
                          FROM Withdrawal
                          WHERE BuddyUserID = @BuddyID AND Status = 'Approved'
                          ORDER BY RequestedAt DESC", conn))
                    {
                        cmd.Parameters.AddWithValue("@BuddyID", userId);
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                            LastWithdrawalDate = Convert.ToDateTime(result).ToString("MMM d, yyyy");
                    }
                }
            }
            catch { }
        }

        private void LoadHistory()
        {
            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();
                    using (var cmd = new SqlCommand(
                        @"SELECT WithdrawalID, Amount, PaymentMethod,
                                 ISNULL(Notes,'') AS Notes, Status, RequestedAt
                          FROM Withdrawal
                          WHERE BuddyUserID = @BuddyID
                          ORDER BY RequestedAt DESC", conn))
                    {
                        cmd.Parameters.AddWithValue("@BuddyID", userId);
                        using (var r = cmd.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                Withdrawals.Add(new WithdrawalItem
                                {
                                    WithdrawalID   = Convert.ToInt32(r["WithdrawalID"]),
                                    Amount         = Convert.ToDecimal(r["Amount"]),
                                    PaymentMethod  = r["PaymentMethod"].ToString(),
                                    Notes          = r["Notes"].ToString(),
                                    Status         = r["Status"].ToString(),
                                    RequestedAt    = Convert.ToDateTime(r["RequestedAt"])
                                });
                            }
                        }
                    }
                }
            }
            catch { }
        }

        public class WithdrawalItem
        {
            public int      WithdrawalID  { get; set; }
            public decimal  Amount        { get; set; }
            public string   PaymentMethod { get; set; }
            public string   Notes         { get; set; }
            public string   Status        { get; set; }
            public DateTime RequestedAt   { get; set; }

            public string StatusClass
            {
                get
                {
                    switch (Status.ToLower())
                    {
                        case "approved": return "approved";
                        case "rejected": return "rejected";
                        default:         return "pending";
                    }
                }
            }
        }
    }
}
