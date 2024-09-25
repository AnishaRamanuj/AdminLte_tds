<%@ WebService Language="C#" Class="WS_ClientGroup" %>

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
public class WS_ClientGroup  : System.Web.Services.WebService {
public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
     [WebMethod]
    public string bind_Job_ClientGroup_staff_Selected(ClientGroup_R currobj)
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ClientGroup> List_SM = new List<tbl_ClientGroup>();
        try
        {
            
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[13];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@UserType", currobj.UserType);
            param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
            param[3] = new SqlParameter("@StaffCode", currobj.StaffCode == "" ? "0" : currobj.StaffCode);
            param[4] = new SqlParameter("@selectedstaffcode", currobj.selectedstaffcode.TrimEnd(','));
            param[5] = new SqlParameter("@selectedctgid", currobj.selectedclientgrpid.TrimEnd(','));
            param[6] = new SqlParameter("@selectedjobid", currobj.selectedjobid.TrimEnd(','));
            param[7] = new SqlParameter("@neetstaff",currobj.neetstaff);
            param[8] = new SqlParameter("@neetclientgrp", currobj.neetclientgrp);
            param[9] = new SqlParameter("@needjob", currobj.neetjob);
            param[10] = new SqlParameter("@FromDate", Convert.ToDateTime(currobj.FromDate, ci));
            param[11] = new SqlParameter("@ToDate", Convert.ToDateTime(currobj.ToDate, ci));
            param[12] = new SqlParameter("@RType", currobj.RType);
           // DataSet ds = SqlHelper.ExecuteDataset(NEwsqlConn, CommandType.StoredProcedure, "Usp_Get_Job_clientGroup_staff_Name", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(NEwsqlConn, CommandType.StoredProcedure, "Usp_Get_Job_clientGroup_staff_Name", param))

            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ClientGroup()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["NAME"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ClientGroup> tbl = List_SM as IEnumerable<tbl_ClientGroup>;
        return new JavaScriptSerializer().Serialize(tbl);

    }
   
}