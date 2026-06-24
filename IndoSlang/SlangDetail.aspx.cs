using System;
using System.Data.SqlClient;

namespace IndoSlang
{
    public partial class SlangDetail : System.Web.UI.Page
    {
        public string UserDisplayName = "Member";
        public int SlangId = 0;
        public string Word = "";
        public string Pronunciation = "";
        public string PartOfSpeech = "";
        public string Meaning = "";
        public string FullExplanation = "";
        public string ExampleSentence = "";
        public string ExampleTranslation = "";
        public string UsedInContext = "";
        public string Origin = "";
        public string Level = "";
        public bool WordFound = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int roleId = Session["RoleID"] == null ? 2 : Convert.ToInt32(Session["RoleID"]);
            string dashboardUrl = roleId == 3 ? "BuddyDashboard.aspx" : "MemberDashboard.aspx";
            lnkDashboard.HRef = "HomePage.aspx";
            lnkDashboard2.HRef = dashboardUrl;
            UserDisplayName = Session["UserName"] == null ? "Member" : Session["UserName"].ToString();

            string idStr = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(idStr) && int.TryParse(idStr, out SlangId) && SlangId > 0)
            {
                LoadWord();
            }
            else
            {
                Response.Redirect("~/SlangDictionary.aspx");
            }
        }

        private void LoadWord()
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    SELECT Word, Pronunciation, PartOfSpeech, Meaning, FullExplanation,
                           ExampleSentence, ExampleTranslation, UsedInContext, Origin, Level
                    FROM SlangWord WHERE SlangID = @SlangID";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@SlangID", SlangId);
                    conn.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            WordFound = true;
                            Word = r["Word"] == DBNull.Value ? "" : r["Word"].ToString();
                            Pronunciation = r["Pronunciation"] == DBNull.Value ? "" : r["Pronunciation"].ToString();
                            PartOfSpeech = r["PartOfSpeech"] == DBNull.Value ? "" : r["PartOfSpeech"].ToString();
                            Meaning = r["Meaning"] == DBNull.Value ? "" : r["Meaning"].ToString();
                            FullExplanation = r["FullExplanation"] == DBNull.Value ? "" : r["FullExplanation"].ToString();
                            ExampleSentence = r["ExampleSentence"] == DBNull.Value ? "" : r["ExampleSentence"].ToString();
                            ExampleTranslation = r["ExampleTranslation"] == DBNull.Value ? "" : r["ExampleTranslation"].ToString();
                            UsedInContext = r["UsedInContext"] == DBNull.Value ? "" : r["UsedInContext"].ToString();
                            Origin = r["Origin"] == DBNull.Value ? "" : r["Origin"].ToString();
                            Level = r["Level"] == DBNull.Value ? "" : r["Level"].ToString();
                        }
                        else
                        {
                            Response.Redirect("~/SlangDictionary.aspx");
                        }
                    }
                }
            }
        }

        public static string GetLevelClass(string level)
        {
            switch ((level ?? "").ToLower())
            {
                case "beginner": return "level-beginner";
                case "elementary": return "level-elementary";
                case "intermediate": return "level-intermediate";
                case "advanced": return "level-advanced";
                default: return "level-beginner";
            }
        }
    }
}
