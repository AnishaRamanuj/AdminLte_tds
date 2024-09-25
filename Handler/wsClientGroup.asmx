<%@ WebService Language="C#" Class="wsClientGroup" %>

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
public class wsClientGroup  : System.Web.Services.WebService {

    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]
    public string BindGroup(int compid, string UserType, string FromDate, string ToDate, string status, string StaffCode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ClientGroupMaster> List_CG = new List<tbl_ClientGroupMaster>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@UserType", UserType);
            param[2] = new SqlParameter("@FromDate", Convert.ToDateTime(FromDate, ci));
            param[3] = new SqlParameter("@ToDate", Convert.ToDateTime(ToDate, ci));
            param[4] = new SqlParameter("@TStatus", status);
            param[5] = new SqlParameter("@StaffCode", StaffCode);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Report_ClientGroupList_Name", param))
            {
                while (drrr.Read())
                {
                    List_CG.Add(new tbl_ClientGroupMaster()
                    {
                        CgroupID  = objComm.GetValue<int>(drrr["ctgid"].ToString()),
                        cGroupName  = objComm.GetValue<string>(drrr["ClientGroupName"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ClientGroupMaster> tbl = List_CG as IEnumerable<tbl_ClientGroupMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


}