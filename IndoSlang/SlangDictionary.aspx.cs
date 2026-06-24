using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace IndoSlang
{
    public partial class SlangDictionary : System.Web.UI.Page
    {
        public string UserDisplayName = "Member";
        public List<SlangWordItem> Words = new List<SlangWordItem>();
        public bool IsVisitor = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                // allow visitor preview — no redirect
                IsVisitor = true;
                lnkDashboard.HRef  = "HomePage.aspx";
                lnkDashboard2.HRef = "HomePage.aspx";
                pnlVisitorNav.Visible = true;
                pnlMemberNav.Visible  = false;
                pnlBuddyNav.Visible   = false;
                pnlAdminNav.Visible   = false;
                UserDisplayName = "Guest";
                LoadWords();
                return;
            }

            int roleId = Session["RoleID"] == null ? 2 : Convert.ToInt32(Session["RoleID"]);
            string dashboardUrl = roleId == 1 ? "AdminDashboard.aspx" : roleId == 3 ? "BuddyDashboard.aspx" : "MemberDashboard.aspx";
            lnkDashboard.HRef = "HomePage.aspx";
            lnkDashboard2.HRef = dashboardUrl;
            pnlVisitorNav.Visible = false;
            pnlMemberNav.Visible  = (roleId == 2);
            pnlBuddyNav.Visible   = (roleId == 3);
            pnlAdminNav.Visible   = (roleId == 1);
            UserDisplayName = Session["UserName"] == null ? "Member" : Session["UserName"].ToString();
            LoadWords();
        }

        private void LoadWords()
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT SlangID, Word, Pronunciation, PartOfSpeech, Meaning, Level FROM SlangWord ORDER BY Word", conn))
                {
                    conn.Open();
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        while (r.Read())
                        {
                            Words.Add(new SlangWordItem
                            {
                                SlangID = Convert.ToInt32(r["SlangID"]),
                                Word = r["Word"] == DBNull.Value ? "" : r["Word"].ToString(),
                                Pronunciation = r["Pronunciation"] == DBNull.Value ? "" : r["Pronunciation"].ToString(),
                                PartOfSpeech = r["PartOfSpeech"] == DBNull.Value ? "" : r["PartOfSpeech"].ToString(),
                                Meaning = r["Meaning"] == DBNull.Value ? "" : r["Meaning"].ToString(),
                                Level = r["Level"] == DBNull.Value ? "" : r["Level"].ToString()
                            });
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

        public class SlangWordItem
        {
            public int SlangID { get; set; }
            public string Word { get; set; }
            public string Pronunciation { get; set; }
            public string PartOfSpeech { get; set; }
            public string Meaning { get; set; }
            public string Level { get; set; }
        }
    }
}
