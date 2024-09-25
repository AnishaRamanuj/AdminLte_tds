using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Globalization;
using System.Data.SqlClient;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using System.Data;

/// <summary>
/// Summary description for wsTimesheet
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
//// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsTimesheet : System.Web.Services.WebService
{
    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");


    [WebMethod]
    public string GetThumbLoginDetials(int compid, string Date, string fromtime, string totime, string StaffCode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        string res = "";
        try
        {
            DateTime ddat = DateTime.Parse(Date);
            

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Date", ddat);
            param[2] = new SqlParameter("@fromtime", fromtime);
            param[3] = new SqlParameter("@totime", totime);
            param[4] = new SqlParameter("@StaffCode", StaffCode);
            DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_GetThumbLoginDetials", param);

            int inn=0,ouut=0;
            if(ds.Tables[1].Rows.Count>0)
            { inn = 1; }
            if (ds.Tables[2].Rows.Count > 0)
            { ouut = 1; }

            if (inn == 1 && ouut == 1)
            { res = "success"; }
            else { res = "missmatch between logs entry cannot find !"; }
            res = "success";
            //using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_GetThumbLoginDetials", param))
            //{
            //    while (drrr.Read())
            //    {
            //        res = objComm.GetValue<string>(drrr["StaffCode"].ToString());
            //        }
            //}
        }
        catch (Exception ex)
        {
            res = ex.Message;
        }
        return res;
    }

}
