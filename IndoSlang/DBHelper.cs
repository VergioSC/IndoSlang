using System.Configuration;
using System.Data.SqlClient;

public class DBHelper
{
    public static SqlConnection GetConnection()
    {
        string connStr = ConfigurationManager.ConnectionStrings["IndoSlangDB"].ConnectionString;
        return new SqlConnection(connStr);
    }
}