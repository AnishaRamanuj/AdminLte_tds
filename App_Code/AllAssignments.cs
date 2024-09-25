using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CommonLibrary;
using System.Configuration;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Data;
/// <summary>
/// Summary description for AllAssignments
/// </summary>
public class AllAssignments : CommonFunctions
{
    string con = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;

    public DataSet GetAssignments(Assignments obj)
    {
        DataSet ds = new DataSet();
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter adap = new SqlDataAdapter();
        cmd.Connection = sqlConn;
        cmd.CommandText = "usp_Bind_Assignments";
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandTimeout = 999999999;


        cmd.Parameters.AddWithValue("@companyId", obj.CompID);
        cmd.Parameters.AddWithValue("@PageIndex", obj.pageIndex );
        cmd.Parameters.AddWithValue("@PageSize", obj.pageNewSize );
        cmd.Parameters.AddWithValue("@Srch", obj.Srch);

        adap.SelectCommand = cmd;
        adap.Fill(ds, "attc");

        return ds;
  
	}
}