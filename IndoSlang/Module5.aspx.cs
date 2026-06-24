using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;

namespace IndoSlang
{
    public partial class Module5 : System.Web.UI.Page
    {
        public string QuestionsJson = "[]";
        public string UserDisplayName = "Member";

        private int userId;
        private const int ModuleOrder = 5;
        private const int PreviousModuleOrder = 4;
        private const int PassingScore = 4;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to login if no session
            if (Session["UserID"] == null || Session["RoleID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int roleId = Convert.ToInt32(Session["RoleID"]);

            // Only Member (2) and Buddy (3) can access modules
            if (roleId != 2 && roleId != 3)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            userId = Convert.ToInt32(Session["UserID"]);
            UserDisplayName = HttpUtility.JavaScriptStringEncode(
                Session["UserName"] == null ? "Member" : Session["UserName"].ToString()
            );

            // Set links — lnkLogo goes to HomePage, lnkDashboard goes to role dashboard
            lnkLogo.HRef = "HomePage.aspx";
            lnkDashboard.HRef = roleId == 3 ? "BuddyDashboard.aspx" : "MemberDashboard.aspx";

            // Save last page for resume after re-login
            Session["LastPage"] = "Module5.aspx";

            if (!IsPostBack)
            {
                CheckModuleAccess();
            }

            LoadQuestionsFromDatabase();
        }

        // Block access if Module 4 not completed
        private void CheckModuleAccess()
        {
            int prevModuleId = GetModuleIdByOrder(PreviousModuleOrder);
            if (prevModuleId == 0) return;

            if (!HasCompletedModule(prevModuleId))
            {
                Response.Redirect("~/Modules.aspx");
            }
        }

        // Load questions from DB for this module
        private void LoadQuestionsFromDatabase()
        {
            int moduleId = GetModuleIdByOrder(ModuleOrder);
            if (moduleId == 0) { QuestionsJson = "[]"; return; }

            List<QuestionItem> questions = new List<QuestionItem>();
            JavaScriptSerializer serializer = new JavaScriptSerializer();

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    SELECT QuestionID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer
                    FROM Question
                    WHERE ModuleID = @ModuleID
                    ORDER BY QuestionNumber";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string rawData = reader["QuestionData"] == DBNull.Value ? "{}" : reader["QuestionData"].ToString();
                            object parsedData;
                            try
                            {
                                parsedData = serializer.DeserializeObject(rawData);
                            }
                            catch
                            {
                                parsedData = new Dictionary<string, object>
                                {
                                    { "question", rawData },
                                    { "context", "" },
                                    { "options", new string[] { } },
                                    { "explanation", "" }
                                };
                            }

                            questions.Add(new QuestionItem
                            {
                                QuestionID = Convert.ToInt32(reader["QuestionID"]),
                                QuestionNumber = Convert.ToInt32(reader["QuestionNumber"]),
                                QuestionType = reader["QuestionType"] == DBNull.Value ? "mcq" : reader["QuestionType"].ToString(),
                                QuestionData = parsedData,
                                CorrectAnswer = reader["CorrectAnswer"] == DBNull.Value ? "" : reader["CorrectAnswer"].ToString()
                            });
                        }
                    }
                }
            }

            QuestionsJson = serializer.Serialize(questions);
        }

        // Save progress and answers when module is completed
        protected void btnSaveResult_Click(object sender, EventArgs e)
        {
            int moduleId = GetModuleIdByOrder(ModuleOrder);
            if (moduleId == 0) { Response.Redirect("~/Modules.aspx"); return; }

            int score = 0;
            int.TryParse(hfScore.Value, out score);
            bool passed = hfPassed.Value == "true" && score >= PassingScore;

            int progressId = CreateProgressAttempt(moduleId, score, passed);
            SaveQuestionAnswers(progressId, hfAnswersJson.Value);

            Response.Redirect(passed ? "~/Module6.aspx" : "~/Module5.aspx");
        }

        private int GetModuleIdByOrder(int moduleOrder)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = "SELECT TOP 1 ModuleID FROM Module WHERE ModuleOrder = @ModuleOrder";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ModuleOrder", moduleOrder);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    return (result == null || result == DBNull.Value) ? 0 : Convert.ToInt32(result);
                }
            }
        }

        private bool HasCompletedModule(int moduleId)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    SELECT COUNT(*) FROM UserModuleProgress
                    WHERE UserID = @UserID AND ModuleID = @ModuleID AND IsCompleted = 1";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
                }
            }
        }

        private int CreateProgressAttempt(int moduleId, int score, bool passed)
        {
            int attemptNumber = GetNextAttemptNumber(moduleId);
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    INSERT INTO UserModuleProgress
                    (UserID, ModuleID, AttemptNumber, IsCompleted, Score, StartedAt, CompletedAt)
                    OUTPUT INSERTED.ProgressID
                    VALUES (@UserID, @ModuleID, @AttemptNumber, @IsCompleted, @Score, GETDATE(), GETDATE())";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    cmd.Parameters.AddWithValue("@AttemptNumber", attemptNumber);
                    cmd.Parameters.AddWithValue("@IsCompleted", passed ? 1 : 0);
                    cmd.Parameters.AddWithValue("@Score", score);
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }

        private int GetNextAttemptNumber(int moduleId)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    SELECT ISNULL(MAX(AttemptNumber), 0) + 1
                    FROM UserModuleProgress
                    WHERE UserID = @UserID AND ModuleID = @ModuleID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }

        private void SaveQuestionAnswers(int progressId, string answersJson)
        {
            if (string.IsNullOrWhiteSpace(answersJson)) return;
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            List<AnswerRecord> answers = serializer.Deserialize<List<AnswerRecord>>(answersJson);

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                foreach (AnswerRecord ans in answers)
                {
                    string query = @"
                        INSERT INTO UserQuestionAnswer
                        (ProgressID, QuestionID, SelectedAnswer, IsCorrect, AnsweredAt)
                        VALUES (@ProgressID, @QuestionID, @SelectedAnswer, @IsCorrect, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ProgressID", progressId);
                        cmd.Parameters.AddWithValue("@QuestionID", ans.questionId);
                        cmd.Parameters.AddWithValue("@SelectedAnswer", ans.selectedAnswer ?? "");
                        cmd.Parameters.AddWithValue("@IsCorrect", ans.isCorrect ? 1 : 0);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }

        public class QuestionItem
        {
            public int QuestionID { get; set; }
            public int QuestionNumber { get; set; }
            public string QuestionType { get; set; }
            public object QuestionData { get; set; }
            public string CorrectAnswer { get; set; }
        }

        public class AnswerRecord
        {
            public int questionId { get; set; }
            public string selectedAnswer { get; set; }
            public bool isCorrect { get; set; }
        }
    }
}