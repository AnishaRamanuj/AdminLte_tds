<%@ WebService Language="C#" Class="wsVoucher" %>

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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsVoucher  : System.Web.Services.WebService {
    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");


    [WebMethod]
    public string BindExpList(int compid, string UserType, string FromDate, string ToDate, string ST, string StaffCode, int clt, int j)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> obj_Exp = new List<Expenses>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@UserType", UserType);
            param[2] = new SqlParameter("@FromDate", Convert.ToDateTime(FromDate, ci));
            param[3] = new SqlParameter("@ToDate", Convert.ToDateTime(ToDate, ci));
            param[4] = new SqlParameter("@TStatus", ST);
            param[5] = new SqlParameter("@StaffCode", StaffCode);
            param[6] = new SqlParameter("@CltID", clt);
            param[7] = new SqlParameter("@JobID", j);                        
            
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_report_ExpVoucher_Name", param))
            {
                while (drrr.Read())
                {
                    obj_Exp.Add(new Expenses()
                    {
                        Tsid = objComm.GetValue<int>(drrr["tsid"].ToString()),
                        opeName = objComm.GetValue<string>(drrr["opeName"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<Expenses> tbl = obj_Exp as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    
}