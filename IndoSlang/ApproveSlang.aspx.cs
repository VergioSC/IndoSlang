using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;

namespace IndoSlang
{
    public partial class ApproveSlang : System.Web.UI.Page
    {
        private int userId;
        public string UserDisplayName = "Admin";
        public string CurrentFilter = "all";
        public int AllCount = 0;
        public int PendingCount = 0;
        public int ApprovedCount = 0;
        public int RejectedCount = 0;
        public string ActionMessage = "";
        public bool ActionSuccess = false;
        public List<SlangSuggestionItem> Suggestions = new List<SlangSuggestionItem>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["RoleID"] == null)
            { Response.Redirect("~/Login.aspx"); return; }
            if (Convert.ToInt32(Session["RoleID"]) != 1)
            { Response.Redirect("~/Login.aspx"); return; }

            userId = Convert.ToInt32(Session["UserID"]);
            UserDisplayName = HttpUtility.JavaScriptStringEncode(
                Session["UserName"] != null ? Session["UserName"].ToString() : "Admin");
            lnkLogo.HRef = "HomePage.aspx";

            if (IsPostBack)
            {
                string action = hdnAction.Value;
                string idStr = hdnSuggestionId.Value;
                int sugId;
                if (!string.IsNullOrEmpty(action) && int.TryParse(idStr, out sugId) && sugId > 0)
                {
                    ProcessAction(action, sugId);
                    string f = Request.QueryString["filter"] ?? "all";
                    string ok = ActionSuccess ? "1" : "0";
                    string msg = Uri.EscapeDataString(ActionMessage);
                    Response.Redirect("ApproveSlang.aspx?filter=" + f + "&msg=" + msg + "&ok=" + ok);
                    return;
                }
            }

            CurrentFilter = (Request.QueryString["filter"] ?? "all").ToLower().Trim();
            if (CurrentFilter != "pending" && CurrentFilter != "approved" && CurrentFilter != "rejected")
                CurrentFilter = "all";

            string msgParam = Request.QueryString["msg"];
            if (!string.IsNullOrEmpty(msgParam))
            {
                ActionMessage = msgParam;
                ActionSuccess = Request.QueryString["ok"] == "1";
            }

            LoadCounts();
            LoadSuggestions();
        }

        private void ProcessAction(string action, int sugId)
        {
            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();

                    string newStatus = action == "approve" ? "Approved" : "Rejected";
                    using (var cmd = new SqlCommand(
                        "UPDATE SlangSuggestion SET Status=@Status, ReviewedByUserID=@Admin, ReviewedAt=GETDATE() WHERE SuggestionID=@ID", conn))
                    {
                        cmd.Parameters.AddWithValue("@Status", newStatus);
                        cmd.Parameters.AddWithValue("@Admin", userId);
                        cmd.Parameters.AddWithValue("@ID", sugId);
                        cmd.ExecuteNonQuery();
                    }

                    if (action == "approve")
                    {
                        try
                        {
                            string word = "", level = "", meaning = "", example = "", trans = "", fullExp = "";
                            using (var sel = new SqlCommand(@"
                                SELECT Word,
                                       ISNULL(DifficultyLevel,'')    AS DifficultyLevel,
                                       ISNULL(ShortMeaning,'')       AS ShortMeaning,
                                       ISNULL(FullExplanation,'')    AS FullExplanation,
                                       ISNULL(ExampleSentence,'')    AS ExampleSentence,
                                       ISNULL(ExampleTranslation,'') AS ExampleTranslation
                                FROM SlangSuggestion WHERE SuggestionID=@ID", conn))
                            {
                                sel.Parameters.AddWithValue("@ID", sugId);
                                using (var r = sel.ExecuteReader())
                                {
                                    if (r.Read())
                                    {
                                        word = r["Word"].ToString();
                                        level = r["DifficultyLevel"].ToString();
                                        meaning = r["ShortMeaning"].ToString();
                                        fullExp = r["FullExplanation"].ToString();
                                        example = r["ExampleSentence"].ToString();
                                        trans = r["ExampleTranslation"].ToString();
                                    }
                                }
                            }

                            using (var ins = new SqlCommand(@"
                                IF NOT EXISTS (SELECT 1 FROM SlangWord WHERE LOWER(Word)=LOWER(@Word))
                                INSERT INTO SlangWord
                                    (SuggestionID, CreatedByUserID, Word, Meaning, FullExplanation,
                                     ExampleSentence, ExampleTranslation, Level, CreatedAt)
                                VALUES
                                    (@SuggID, @AdminID, @Word, @Meaning, @FullExp,
                                     @Example, @Trans, @Level, GETDATE())", conn))
                            {
                                ins.Parameters.AddWithValue("@SuggID", sugId);
                                ins.Parameters.AddWithValue("@AdminID", userId);
                                ins.Parameters.AddWithValue("@Word", word);
                                ins.Parameters.AddWithValue("@Meaning", meaning);
                                ins.Parameters.AddWithValue("@FullExp", fullExp);
                                ins.Parameters.AddWithValue("@Example", example);
                                ins.Parameters.AddWithValue("@Trans", trans);
                                ins.Parameters.AddWithValue("@Level", level);
                                ins.ExecuteNonQuery();
                            }
                        }
                        catch { }
                    }
                }

                ActionMessage = action == "approve"
                    ? "Slang approved and added to dictionary."
                    : "Slang suggestion rejected.";
                ActionSuccess = true;
            }
            catch (Exception ex)
            {
                ActionMessage = "Action failed: " + ex.Message;
                ActionSuccess = false;
            }
        }

        private void LoadCounts()
        {
            try
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();
                    using (var cmd = new SqlCommand(
                        "SELECT Status, COUNT(*) AS Cnt FROM SlangSuggestion GROUP BY Status", conn))
                    {
                        using (var r = cmd.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                int cnt = Convert.ToInt32(r["Cnt"]);
                                string s = r["Status"].ToString();
                                AllCount += cnt;
                                if (s == "Pending") PendingCount = cnt;
                                if (s == "Approved") ApprovedCount = cnt;
                                if (s == "Rejected") RejectedCount = cnt;
                            }
                        }
                    }
                }
            }
            catch { }
        }

        private void LoadSuggestions()
        {
            try
            {
                string filterClause = CurrentFilter == "all" ? "" : " AND ss.Status=@Filter";

                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();
                    using (var cmd = new SqlCommand(@"
                        SELECT ss.SuggestionID,
                               ss.Word,
                               '' AS PartOfSpeech,
                               ISNULL(ss.DifficultyLevel,'')    AS DifficultyLevel,
                               ISNULL(ss.ShortMeaning,'')       AS Meaning,
                               ISNULL(ss.ExampleSentence,'')    AS ExampleSentence,
                               ISNULL(ss.ExampleTranslation,'') AS Translation,
                               ss.Status,
                               ss.SubmittedAt,
                               ISNULL(u.FirstName,'') + ' ' + ISNULL(u.LastName,'') AS SubmitterName
                        FROM SlangSuggestion ss
                        JOIN [User] u ON u.UserID = ss.SubmittedByUserID"
                        + filterClause +
                        " ORDER BY ss.SubmittedAt DESC", conn))
                    {
                        if (CurrentFilter != "all")
                        {
                            string cap = char.ToUpper(CurrentFilter[0]) + CurrentFilter.Substring(1);
                            cmd.Parameters.AddWithValue("@Filter", cap);
                        }

                        using (var r = cmd.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                Suggestions.Add(new SlangSuggestionItem
                                {
                                    SuggestionID = Convert.ToInt32(r["SuggestionID"]),
                                    Word = r["Word"].ToString(),
                                    PartOfSpeech = r["PartOfSpeech"].ToString(),
                                    DifficultyLevel = r["DifficultyLevel"].ToString(),
                                    Meaning = r["Meaning"].ToString(),
                                    ExampleSentence = r["ExampleSentence"].ToString(),
                                    Translation = r["Translation"].ToString(),
                                    Status = r["Status"].ToString(),
                                    SubmittedAt = r["SubmittedAt"] == DBNull.Value
                                                        ? DateTime.MinValue
                                                        : Convert.ToDateTime(r["SubmittedAt"]),
                                    SubmitterName = r["SubmitterName"].ToString().Trim()
                                });
                            }
                        }
                    }
                }
            }
            catch { }
        }

        public class SlangSuggestionItem
        {
            public int SuggestionID { get; set; }
            public string Word { get; set; }
            public string PartOfSpeech { get; set; }
            public string DifficultyLevel { get; set; }
            public string Meaning { get; set; }
            public string ExampleSentence { get; set; }
            public string Translation { get; set; }
            public string Status { get; set; }
            public DateTime SubmittedAt { get; set; }
            public string SubmitterName { get; set; }
        }
    }
}