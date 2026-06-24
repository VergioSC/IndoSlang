using System;

namespace IndoSlang
{
    public partial class PlacementQuiz : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string goal = Request.QueryString["goal"];
                string freq = Request.QueryString["freq"];
                string know = Request.QueryString["know"];
                if (!string.IsNullOrEmpty(goal)) Session["OnboardingGoal"]      = goal;
                if (!string.IsNullOrEmpty(freq)) Session["OnboardingFrequency"] = freq;
                if (!string.IsNullOrEmpty(know)) Session["OnboardingKnowledge"] = know;
            }
        }

        protected void btnSaveQuiz_Click(object sender, EventArgs e)
        {
            string level  = hfLevel.Value.Trim();
            string module = hfModule.Value.Trim();
            int score     = 0;
            int.TryParse(hfScore.Value.Trim(), out score);

            if (string.IsNullOrEmpty(level))  level  = "Beginner";
            if (string.IsNullOrEmpty(module)) module = "Module1.aspx";

            Session["AssignedLevel"]  = level;
            Session["PlacementScore"] = score;
            Session["StartModule"]    = module;

            Response.Redirect("~/Register.aspx");
        }
    }
}
