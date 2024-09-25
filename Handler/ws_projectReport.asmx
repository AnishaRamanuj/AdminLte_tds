<%@ WebService Language="C#" Class="ws_projectReport" %>

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
public class ws_projectReport : System.Web.Services.WebService
{
    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]
    public string getclientwiseProject(string cltid, string compid)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Project_master> obj_Job = new List<Project_master>();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_timesheet_project", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Project_master()
                    {
                        projectid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        projectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Bind_Client_Project_Deaprtment_All_Selected(ReprotAllStaffCilentJob currobj)//int compid, string UserType, string status, string StaffCode)
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[13];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@UserType", currobj.UserType);
            param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
            param[3] = new SqlParameter("@StaffCode", currobj.StaffCode == "" ? "0" : currobj.StaffCode);
            param[4] = new SqlParameter("@selectedclientid", currobj.selectedclientid.TrimEnd(','));
            param[5] = new SqlParameter("@neetclient", currobj.neetclient);
            param[6] = new SqlParameter("@FromDate", Convert.ToDateTime(currobj.FromDate, ci));
            param[7] = new SqlParameter("@ToDate", Convert.ToDateTime(currobj.ToDate, ci));
            param[8] = new SqlParameter("@RType", currobj.RType);
            param[9] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid);
            param[10] = new SqlParameter("@needProject", currobj.needproject);
            param[11] = new SqlParameter("@needdept", currobj.needdept);
            param[12] = new SqlParameter("@selecteddeptid", currobj.selecteddeptid);
           // DataSet da = SqlHelper.ExecuteDataset(NEwsqlConn, CommandType.StoredProcedure, "usp_report_Bind_staff_client_project_job_selected", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(NEwsqlConn, CommandType.StoredProcedure, "usp_Bootstrap_report_client_project_Department", param))
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