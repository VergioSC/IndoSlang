using System;
using System.Web.UI;

namespace IndoSlang
{
    public partial class About : Page
    {
        public int SlangCount = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Title = "About";

            if (!IsPostBack)
                LoadSlangCount();
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
    }
}