<%@ WebService Language="C#" Class="All_Staff_Client_Project_Job_Details" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Globalization;
using System.Data.SqlClient;
using System.Data;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class All_Staff_Client_Project_Job_Details  : System.Web.Services.WebService {

    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]

    public string Get_Staff_Client_Project_All_Selected(ProjectStaff currobj)//int compid, string UserType, string status, string StaffCode)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {

            DateTime strdate = Convert.ToDateTime(currobj.fromdate, ci);
            DateTime todate = Convert.ToDateTime(currobj.todate, ci);
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[14];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@UserType", currobj.UserType);
            param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
            param[3] = new SqlParameter("@StaffCode", currobj.StaffCode == "" ? "0" : currobj.StaffCode);
            param[4] = new SqlParameter("@selectedstaffcode", currobj.selectedstaffcode.TrimEnd(','));
            param[5] = new SqlParameter("@selectedclientid", currobj.selectetdcltid.TrimEnd(','));
            param[6] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
            param[7] = new SqlParameter("@neetstaff", currobj.staffwise);
            param[8] = new SqlParameter("@neetclient", currobj.clientwise);
            param[9] = new SqlParameter("@needproject", currobj.projectwise);
            param[10] = new SqlParameter("@FromDate", strdate);
            param[11] = new SqlParameter("@ToDate", todate);
            param[12] = new SqlParameter("@RType", currobj.RType);
            param[13] = new SqlParameter("@needjob", currobj.jobwise);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Get_Staff_Client_Project_Job_Selected", param))
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


    [WebMethod(EnableSession=true)]
    public string Get_Client_Project_Selected(ProjectStaff currobj)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ClienwiseProject> List_SM = new List<tbl_ClienwiseProject>();

        try
        {
            if (Session["companyid"] != null)
            {
                DateTime strdate = Convert.ToDateTime(currobj.fromdate, ci);
                DateTime todate = Convert.ToDateTime(currobj.todate, ci);
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[9];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@UserType", currobj.UserType);
                param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
                //param[3] = new SqlParameter("@selecteddeptid", currobj.selectedDeptid.TrimEnd(','));
                param[3] = new SqlParameter("@selectedclientid", currobj.selectetdcltid.TrimEnd(','));
                param[4] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
                param[5] = new SqlParameter("@FromDate", strdate);
                param[6] = new SqlParameter("@ToDate", todate);
                param[7] = new SqlParameter("@type", currobj.Type);
                param[8] = new SqlParameter("@Branch", currobj.BrId);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Report_Clientwise_Project_Summery", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new tbl_ClienwiseProject()
                        {
                            Srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                            ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                            ClientName = objComm.GetValue<string>(drrr["clientname"].ToString()),
                            TotalHours = objComm.GetValue<string>(drrr["Hours"].ToString()),
                            Staffname = objComm.GetValue<string>(drrr["Staffname"].ToString()),
                            Jobname = objComm.GetValue<string>(drrr["Jobname"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ClienwiseProject> tbl = List_SM as IEnumerable<tbl_ClienwiseProject>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}