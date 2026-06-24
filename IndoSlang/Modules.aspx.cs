using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace IndoSlang
{
    public partial class Modules : System.Web.UI.Page
    {
        public string UserLevel = "Beginner";
        public string UserName = "Member";
        public string StartModule = "Module1.aspx";
        public string CompletedModulesCsv = "";
        public bool IsBuddy = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["RoleID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int roleId = Convert.ToInt32(Session["RoleID"]);

            if (roleId != 2 && roleId != 3)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            IsBuddy = (roleId == 3);
            int userId = Convert.ToInt32(Session["UserID"]);

            LoadUserInfo(userId);
            LoadCompletedModules(userId);
            SetStartModule();
        }

        private void LoadUserInfo(int userId)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    SELECT FirstName, Username, CurrentLevel
                    FROM [User] WHERE UserID = @UserID";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string firstName = reader["FirstName"] == DBNull.Value ? "" : reader["FirstName"].ToString();
                            string username = reader["Username"] == DBNull.Value ? "Member" : reader["Username"].ToString();
                            string currentLevel = reader["CurrentLevel"] == DBNull.Value ? "Beginner" : reader["CurrentLevel"].ToString();
                            UserName = string.IsNullOrWhiteSpace(firstName) ? username : firstName;
                            UserLevel = string.IsNullOrWhiteSpace(currentLevel) ? "Beginner" : currentLevel;
                        }
                    }
                }
            }
        }

        private void LoadCompletedModules(int userId)
        {
            List<string> completedModules = new List<string>();
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                string query = @"
                    SELECT DISTINCT m.ModuleOrder
                    FROM UserModuleProgress ump
                    INNER JOIN Module m ON ump.ModuleID = m.ModuleID
                    WHERE ump.UserID = @UserID AND ump.IsCompleted = 1
                    ORDER BY m.ModuleOrder";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                            completedModules.Add(reader["ModuleOrder"].ToString());
                    }
                }
            }
            CompletedModulesCsv = string.Join(",", completedModules);
        }

        private void SetStartModule()
        {
            int nextModule = 1;

            if (!string.IsNullOrWhiteSpace(CompletedModulesCsv))
            {
                int maxCompleted = 0;
                foreach (string s in CompletedModulesCsv.Split(','))
                {
                    if (int.TryParse(s, out int order) && order > maxCompleted)
                        maxCompleted = order;
                }
                nextModule = maxCompleted + 1;
                if (nextModule > 8) nextModule = 8;
            }

            int maxUnlocked = GetMaxUnlockedModuleByLevel(UserLevel);
            if (nextModule > maxUnlocked) nextModule = maxUnlocked;

            StartModule = "Module" + nextModule + ".aspx";
        }

        private int GetMaxUnlockedModuleByLevel(string level)
        {
            switch (level)
            {
                case "Elementary": return 4;
                case "Intermediate": return 6;
                case "Advanced": return 8;
                default: return 2;
            }
        }
    }
}