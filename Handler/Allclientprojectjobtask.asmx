<%@ WebService Language="C#" Class="Allclientprojectjobtask" %>

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
public class Allclientprojectjobtask : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]

    public string Bind_Client_Project_Job_Task_All_Selected(ReprotAllStaffCilentJob currobj)//int compid, string UserType, string status, string StaffCode)
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[15];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
            param[2] = new SqlParameter("@selectedtask", currobj.selectedtask.TrimEnd(','));
            param[3] = new SqlParameter("@selectedclientid", currobj.selectedclientid.TrimEnd(','));
            param[4] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
            param[5] = new SqlParameter("@selectedjob", currobj.selectedjobid.TrimEnd(','));
            param[6] = new SqlParameter("@RType", currobj.RType);
            param[7] = new SqlParameter("@FromDate", Convert.ToDateTime(currobj.FromDate, ci));
            param[8] = new SqlParameter("@ToDate", Convert.ToDateTime(currobj.ToDate, ci));

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(NEwsqlConn, CommandType.StoredProcedure, "usp_Client_Project_Job_Task_All_Selected", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_StaffMaster()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



}