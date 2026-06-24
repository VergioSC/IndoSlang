using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

namespace IndoSlang
{
    public partial class ManageContent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Convert.ToInt32(Session["RoleID"]) != 1)
            { Response.Redirect("~/Login.aspx"); return; }

            if (!IsPostBack)
            {
                LoadDictionary();
                PopulateModuleDropdown();
            }
        }

        // DICTIONARY

        private void LoadDictionary()
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string sql = @"SELECT SlangID, Word, Pronunciation, PartOfSpeech, Meaning, Level
                               FROM SlangWord ORDER BY Word";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    rptDictionary.DataSource = cmd.ExecuteReader();
                    rptDictionary.DataBind();
                }
            }
            pnlDictionaryEmpty.Visible = (rptDictionary.Items.Count == 0);
        }

        protected void btnShowAddWord_Click(object sender, EventArgs e)
        {
            hfSlangID.Value = "0";
            lblWordFormTitle.Text = "Add New Word";
            ClearWordForm();
            pnlWordForm.Visible = true;
            hfActiveTab.Value = "dictionaryTab";
        }

        protected void btnSaveWord_Click(object sender, EventArgs e)
        {
            int slangId = int.Parse(hfSlangID.Value);

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                if (slangId == 0)
                {
                    string sql = @"INSERT INTO SlangWord
                                   (Word, Pronunciation, PartOfSpeech, Meaning, FullExplanation,
                                    ExampleSentence, ExampleTranslation, Level, CreatedByUserID, CreatedAt)
                                   VALUES (@Word, @Pronunciation, @PartOfSpeech, @Meaning, @FullExplanation,
                                           @ExampleSentence, @ExampleTranslation, @Level, @CreatedBy, GETDATE())";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        AddWordParams(cmd);
                        cmd.Parameters.AddWithValue("@CreatedBy", Convert.ToInt32(Session["UserID"]));
                        cmd.ExecuteNonQuery();
                    }
                }
                else
                {
                    string sql = @"UPDATE SlangWord
                                   SET Word=@Word, Pronunciation=@Pronunciation, PartOfSpeech=@PartOfSpeech,
                                       Meaning=@Meaning, FullExplanation=@FullExplanation,
                                       ExampleSentence=@ExampleSentence, ExampleTranslation=@ExampleTranslation,
                                       Level=@Level
                                   WHERE SlangID=@SlangID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        AddWordParams(cmd);
                        cmd.Parameters.AddWithValue("@SlangID", slangId);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            pnlWordForm.Visible = false;
            hfActiveTab.Value = "dictionaryTab";
            LoadDictionary();
        }

        protected void btnCancelWord_Click(object sender, EventArgs e)
        {
            pnlWordForm.Visible = false;
            ClearWordForm();
            hfActiveTab.Value = "dictionaryTab";
        }

        protected void rptDictionary_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int slangId = Convert.ToInt32(e.CommandArgument);
            hfActiveTab.Value = "dictionaryTab";

            if (e.CommandName == "EditWord")
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    string sql = @"SELECT Word, Pronunciation, PartOfSpeech, Meaning, FullExplanation,
                                          ExampleSentence, ExampleTranslation, Level
                                   FROM SlangWord WHERE SlangID=@SlangID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@SlangID", slangId);
                        conn.Open();
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                hfSlangID.Value = slangId.ToString();
                                lblWordFormTitle.Text = "Edit Word";
                                txtWord.Text = r["Word"].ToString();
                                txtPronunciation.Text = r["Pronunciation"] == DBNull.Value ? "" : r["Pronunciation"].ToString();

                                string pos = r["PartOfSpeech"] == DBNull.Value ? "" : r["PartOfSpeech"].ToString();
                                ddlPartOfSpeech.SelectedIndex = 0;
                                if (ddlPartOfSpeech.Items.FindByValue(pos) != null)
                                    ddlPartOfSpeech.SelectedValue = pos;

                                txtMeaning.Text = r["Meaning"] == DBNull.Value ? "" : r["Meaning"].ToString();
                                txtFullExplanation.Text = r["FullExplanation"] == DBNull.Value ? "" : r["FullExplanation"].ToString();
                                txtExampleSentence.Text = r["ExampleSentence"] == DBNull.Value ? "" : r["ExampleSentence"].ToString();
                                txtExampleTranslation.Text = r["ExampleTranslation"] == DBNull.Value ? "" : r["ExampleTranslation"].ToString();

                                string lvl = r["Level"] == DBNull.Value ? "" : r["Level"].ToString();
                                ddlLevel.SelectedIndex = 0;
                                if (ddlLevel.Items.FindByValue(lvl) != null)
                                    ddlLevel.SelectedValue = lvl;

                                pnlWordForm.Visible = true;
                            }
                        }
                    }
                }
            }
            else if (e.CommandName == "DeleteWord")
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    string sql = "DELETE FROM SlangWord WHERE SlangID=@SlangID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@SlangID", slangId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            LoadDictionary();
        }

        private void AddWordParams(SqlCommand cmd)
        {
            cmd.Parameters.AddWithValue("@Word", txtWord.Text.Trim());
            cmd.Parameters.AddWithValue("@Pronunciation", txtPronunciation.Text.Trim());
            cmd.Parameters.AddWithValue("@PartOfSpeech", ddlPartOfSpeech.SelectedValue);
            cmd.Parameters.AddWithValue("@Meaning", txtMeaning.Text.Trim());
            cmd.Parameters.AddWithValue("@FullExplanation", txtFullExplanation.Text.Trim());
            cmd.Parameters.AddWithValue("@ExampleSentence", txtExampleSentence.Text.Trim());
            cmd.Parameters.AddWithValue("@ExampleTranslation", txtExampleTranslation.Text.Trim());
            cmd.Parameters.AddWithValue("@Level", ddlLevel.SelectedValue);
        }

        private void ClearWordForm()
        {
            txtWord.Text = "";
            txtPronunciation.Text = "";
            ddlPartOfSpeech.SelectedIndex = 0;
            txtMeaning.Text = "";
            txtFullExplanation.Text = "";
            txtExampleSentence.Text = "";
            txtExampleTranslation.Text = "";
            ddlLevel.SelectedIndex = 0;
        }

        // MODULE QUESTIONS

        private void PopulateModuleDropdown()
        {
            ddlModule.Items.Clear();
            ddlModule.Items.Add(new ListItem("-- Select a Module --", "0"));
            for (int i = 1; i <= 8; i++)
                ddlModule.Items.Add(new ListItem("Module " + i, i.ToString()));
        }

        protected void ddlModule_SelectedIndexChanged(object sender, EventArgs e)
        {
            hfActiveTab.Value = "questionsTab";
            int moduleOrder = int.Parse(ddlModule.SelectedValue);

            if (moduleOrder == 0) { pnlQuestionSection.Visible = false; return; }

            hfCurrentModuleOrder.Value = moduleOrder.ToString();
            pnlQuestionSection.Visible = true;
            lblQuestionsFor.Text = "Questions — Module " + moduleOrder;
            pnlQuestionForm.Visible = false;

            if (moduleOrder == 1)
            {
                pnlModule1Note.Visible = true;
                pnlQuestionList.Visible = false;
                btnShowAddQuestion.Visible = false;
            }
            else
            {
                pnlModule1Note.Visible = false;
                pnlQuestionList.Visible = true;
                btnShowAddQuestion.Visible = true;
                LoadModuleQuestions(moduleOrder);
            }
        }

        private void LoadModuleQuestions(int moduleOrder)
        {
            int moduleId = GetModuleIdByOrder(moduleOrder);
            if (moduleId == 0)
            {
                rptQuestions.DataSource = null;
                rptQuestions.DataBind();
                pnlQuestionsEmpty.Visible = true;
                return;
            }

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string sql = @"SELECT QuestionID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer
                               FROM Question WHERE ModuleID=@ModuleID ORDER BY QuestionNumber";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    conn.Open();
                    rptQuestions.DataSource = cmd.ExecuteReader();
                    rptQuestions.DataBind();
                }
            }
            pnlQuestionsEmpty.Visible = (rptQuestions.Items.Count == 0);
        }

        protected void btnShowAddQuestion_Click(object sender, EventArgs e)
        {
            hfQuestionID.Value = "0";
            lblQuestionFormTitle.Text = "Add New Question";
            ClearQuestionForm();
            pnlQuestionForm.Visible = true;
            hfActiveTab.Value = "questionsTab";
        }

        protected void btnSaveQuestion_Click(object sender, EventArgs e)
        {
            int questionId = int.Parse(hfQuestionID.Value);
            int moduleOrder = int.Parse(hfCurrentModuleOrder.Value);
            int moduleId = GetModuleIdByOrder(moduleOrder);
            if (moduleId == 0) return;

            int questionNumber;
            int.TryParse(txtQuestionNumber.Text.Trim(), out questionNumber);

            string questionType = ddlQuestionType.SelectedValue;
            string questionData = SerializeQuestionData(
                questionType,
                txtQuestionText.Text.Trim(),
                new[] { txtOptionA.Text.Trim(), txtOptionB.Text.Trim(), txtOptionC.Text.Trim(), txtOptionD.Text.Trim() },
                txtExplanation.Text.Trim()
            );
            string correctAnswer = txtCorrectAnswer.Text.Trim();

            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                if (questionId == 0)
                {
                    string sql = @"INSERT INTO Question (ModuleID, QuestionNumber, QuestionType, QuestionData, CorrectAnswer)
                                   VALUES (@ModuleID, @Number, @Type, @Data, @Answer)";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                        cmd.Parameters.AddWithValue("@Number", questionNumber);
                        cmd.Parameters.AddWithValue("@Type", questionType);
                        cmd.Parameters.AddWithValue("@Data", questionData);
                        cmd.Parameters.AddWithValue("@Answer", correctAnswer);
                        cmd.ExecuteNonQuery();
                    }
                }
                else
                {
                    string sql = @"UPDATE Question
                                   SET QuestionNumber=@Number, QuestionType=@Type,
                                       QuestionData=@Data, CorrectAnswer=@Answer
                                   WHERE QuestionID=@QID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Number", questionNumber);
                        cmd.Parameters.AddWithValue("@Type", questionType);
                        cmd.Parameters.AddWithValue("@Data", questionData);
                        cmd.Parameters.AddWithValue("@Answer", correctAnswer);
                        cmd.Parameters.AddWithValue("@QID", questionId);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            pnlQuestionForm.Visible = false;
            hfActiveTab.Value = "questionsTab";
            LoadModuleQuestions(moduleOrder);
        }

        protected void btnCancelQuestion_Click(object sender, EventArgs e)
        {
            pnlQuestionForm.Visible = false;
            ClearQuestionForm();
            hfActiveTab.Value = "questionsTab";
        }

        protected void rptQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int questionId = Convert.ToInt32(e.CommandArgument);
            int moduleOrder = int.Parse(hfCurrentModuleOrder.Value);
            hfActiveTab.Value = "questionsTab";

            if (e.CommandName == "EditQuestion")
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    string sql = @"SELECT QuestionNumber, QuestionType, QuestionData, CorrectAnswer
                                   FROM Question WHERE QuestionID=@QID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@QID", questionId);
                        conn.Open();
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                hfQuestionID.Value = questionId.ToString();
                                lblQuestionFormTitle.Text = "Edit Question";
                                txtQuestionNumber.Text = r["QuestionNumber"].ToString();
                                ddlQuestionType.SelectedValue = r["QuestionType"].ToString();
                                txtCorrectAnswer.Text = r["CorrectAnswer"].ToString();

                                var serializer = new JavaScriptSerializer();
                                var data = serializer.Deserialize<Dictionary<string, object>>(r["QuestionData"].ToString());
                                txtQuestionText.Text = data.ContainsKey("question") ? data["question"].ToString() : "";
                                txtExplanation.Text = data.ContainsKey("explanation") ? data["explanation"].ToString() : "";

                                if (data.ContainsKey("options") && data["options"] is System.Collections.ArrayList opts)
                                {
                                    txtOptionA.Text = opts.Count > 0 ? opts[0].ToString() : "";
                                    txtOptionB.Text = opts.Count > 1 ? opts[1].ToString() : "";
                                    txtOptionC.Text = opts.Count > 2 ? opts[2].ToString() : "";
                                    txtOptionD.Text = opts.Count > 3 ? opts[3].ToString() : "";
                                }
                                else txtOptionA.Text = txtOptionB.Text = txtOptionC.Text = txtOptionD.Text = "";

                                pnlQuestionForm.Visible = true;
                            }
                        }
                    }
                }
            }
            else if (e.CommandName == "DeleteQuestion")
            {
                using (SqlConnection conn = DBHelper.GetConnection())
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM UserQuestionAnswer WHERE QuestionID=@QID", conn))
                    {
                        cmd.Parameters.AddWithValue("@QID", questionId);
                        cmd.ExecuteNonQuery();
                    }
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM Question WHERE QuestionID=@QID", conn))
                    {
                        cmd.Parameters.AddWithValue("@QID", questionId);
                        cmd.ExecuteNonQuery();
                    }
                }
            }

            LoadModuleQuestions(moduleOrder);
        }

        private void ClearQuestionForm()
        {
            txtQuestionNumber.Text = "";
            ddlQuestionType.SelectedIndex = 0;
            txtQuestionText.Text = "";
            txtOptionA.Text = txtOptionB.Text = txtOptionC.Text = txtOptionD.Text = "";
            txtCorrectAnswer.Text = "";
            txtExplanation.Text = "";
        }

        // HELPERS

        private string SerializeQuestionData(string type, string questionText, string[] options, string explanation)
        {
            var s = new JavaScriptSerializer();
            if (type == "mcq")
                return s.Serialize(new { question = questionText, options, explanation });
            return s.Serialize(new { question = questionText, explanation });
        }

        private int GetModuleIdByOrder(int moduleOrder)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT TOP 1 ModuleID FROM Module WHERE ModuleOrder=@Order", conn))
                {
                    cmd.Parameters.AddWithValue("@Order", moduleOrder);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    return (result == null || result == DBNull.Value) ? 0 : Convert.ToInt32(result);
                }
            }
        }

        protected string GetQuestionText(object questionData)
        {
            if (questionData == null || questionData == DBNull.Value) return "";
            try
            {
                var d = new JavaScriptSerializer().Deserialize<Dictionary<string, object>>(questionData.ToString());
                string text = d.ContainsKey("question") ? d["question"].ToString() : "";
                return text.Length > 80 ? text.Substring(0, 80) + "..." : text;
            }
            catch { return questionData.ToString(); }
        }

        protected string GetTypeBadge(object type)
        {
            switch (type?.ToString())
            {
                case "mcq": return "MCQ";
                case "fill": return "Fill";
                case "truefalse": return "T/F";
                default: return type?.ToString() ?? "";
            }
        }
    }
}