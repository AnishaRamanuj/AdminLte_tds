using JTMSProject;
using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ConnectionClass
/// </summary>
public class ConnectionClass
{

    //public string DbConnection = @"Data Source=TEJAL-PC\SQL2014;Initial Catalog=NotificationManager;Integrated Security=True";
    private readonly DBAccess db = new DBAccess();
    string DataSoruce = string.Empty;
    string InitialCatalog = string.Empty;
    string UserId = string.Empty;
    string Password = string.Empty;
    string DbConnection = string.Empty;
    //public string DbConnection = @"Data Source=" + DataSoruce + ";Initial Catalog=NotificationManager;Integrated Security=True";

    public string getConnection()
    {

        try
        {
            DataSet ds = new DataSet();

            SqlParameter[] sqlParams = new SqlParameter[0];


            ds = SqlHelper.ExecuteDataset(db.ConString, CommandType.StoredProcedure, "usp_ConnectionString");
            if (ds.Tables[0].Rows.Count > 0)
            {
                DataSoruce = ds.Tables[0].Rows[0]["IpAddress"].ToString();
                InitialCatalog = ds.Tables[0].Rows[0]["DBName"].ToString();
                UserId = ds.Tables[0].Rows[0]["DBUsername"].ToString();
                Password = ds.Tables[0].Rows[0]["DBPassword"].ToString();
            }

            //DbConnection = @"Data Source=" + DataSoruce + ";Initial Catalog=" + InitialCatalog + ";Integrated Security=True";
            DbConnection = @"Data Source=" + DataSoruce + ";Initial Catalog="+InitialCatalog+ ";User ID="+UserId+ ";MultipleActiveResultSets=True;Password=" + Password+";";

        }
        catch (Exception ex)
        {
            throw ex;
        }
        return DbConnection;
    }

}