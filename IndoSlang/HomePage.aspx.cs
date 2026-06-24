using System;
using System.Web.UI;

namespace IndoSlang
{
    public partial class HomePage : Page
    {
        public int SlangCount = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Title = "Speak like an Indonesian";

            if (!IsPostBack)
            {
                LoadSlangCount();
                LoadSlangOfTheDay();
            }
        }

        private void LoadSlangCount()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["IndoSlangDB"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                using (var cmd = new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM SlangWord", conn))
                    SlangCount = (int)cmd.ExecuteScalar();
            }
        }

        private void LoadSlangOfTheDay()
        {
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["IndoSlangDB"].ConnectionString;
            using (var conn = new System.Data.SqlClient.SqlConnection(connStr))
            {
                conn.Open();
                string sql = @"
                    SELECT Word, PartOfSpeech, Meaning, ExampleSentence, ExampleTranslation
                    FROM SlangWord
                    ORDER BY (SlangID * 1301 + DATEPART(dayofyear, GETDATE())) % (SELECT COUNT(*) FROM SlangWord)
                    OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY";
                using (var cmd = new System.Data.SqlClient.SqlCommand(sql, conn))
                using (var dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        sotdWord.InnerText = dr["Word"].ToString();
                        sotdPos.InnerText = dr["PartOfSpeech"].ToString();
                        sotdMeaning.InnerText = dr["Meaning"].ToString();
                        sotdExample.InnerText = "\u201c" + dr["ExampleSentence"] + "\u201d \u2014 " + dr["ExampleTranslation"];
                    }
                }
            }
        }
    }
}