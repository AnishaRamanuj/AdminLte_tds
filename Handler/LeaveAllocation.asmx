<%@ WebService Language="C#" Class="LeaveAllocation" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data.SqlClient;
using System.Data;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Globalization;
using JTMSProject;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class LeaveAllocation  : System.Web.Services.WebService {
    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");



    [WebMethod]
    public string Allocate(tbl_MonthlyLeave id)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_MonthlyLeave> List_ML = new List<tbl_MonthlyLeave>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", id.Company_ID);
            param[1] = new SqlParameter("@lid", id.Leave_ID);
            param[2] = new SqlParameter("@mth", id.MonthName);
     
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Leave_Monthly_Allocate", param))
            {
                while (drrr.Read())
                {
                    List_ML.Add(new tbl_MonthlyLeave()
                    {
                        MonthName = objComm.GetValue<string>(drrr["Month_Name"].ToString()),
                        MonthID = objComm.GetValue<int>(drrr["month1"].ToString()),
                        yearID = objComm.GetValue<int>(drrr["year1"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MonthlyLeave> tbl = List_ML as IEnumerable<tbl_MonthlyLeave>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    
}