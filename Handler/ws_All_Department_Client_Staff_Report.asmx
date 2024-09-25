<%@ WebService Language="C#" Class="ws_All_Department_Client_Staff_Report" %>

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
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.IO;
using System.Drawing;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ws_All_Department_Client_Staff_Report : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]
    public string Get_Department_Client_Staff_Report_Departments(int compid/*, int StaffCode*/)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Departmentwise_Report> List_SM = new List<tbl_Departmentwise_Report>();
        try
        {
            int StaffCode = 0;
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@StaffCode", StaffCode);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Department_Client_Staff_Report_Departments", param))
            {
                while (sdr.Read())
                {
                    List_SM.Add(new tbl_Departmentwise_Report
                    {
                        DeptId = objComm.GetValue<int>(sdr["DepId"].ToString()),
                        Department = objComm.GetValue<string>(sdr["DepartmentName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            return null;
        }
        IEnumerable<tbl_Departmentwise_Report> tbl = List_SM as IEnumerable<tbl_Departmentwise_Report>;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    [WebMethod]
    public string Get_Department_Client_Staff_Report_ProjectStaff(tbl_Departmentwise_Report currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Departmentwise_Report> List_SM = new List<tbl_Departmentwise_Report>();
        DateTime fromdate = Convert.ToDateTime(currobj.fromdate, ci);
        DateTime todate = Convert.ToDateTime(currobj.todate, ci);
        try
        {
            currobj.StaffCode = 0;

            SqlParameter[] param = new SqlParameter[10];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@StaffCode", currobj.StaffCode);
            param[2] = new SqlParameter("@status", currobj.status);
            param[3] = new SqlParameter("@Projectwise", currobj.Projectwise);
            param[4] = new SqlParameter("@staffwise", currobj.staffwise);
            param[5] = new SqlParameter("@fromdate", fromdate);
            param[6] = new SqlParameter("@todate", todate);
            param[7] = new SqlParameter("@DeptId", currobj.DeptId);
            param[8] = new SqlParameter("@selectedProject", currobj.selectedProject.TrimEnd(','));
            param[9] = new SqlParameter("@UserType", currobj.UserType);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Department_Client_Staff_Report_ProjectStaff", param))
            {
                while (sdr.Read())
                {
                    List_SM.Add(new tbl_Departmentwise_Report
                    {
                        Id = objComm.GetValue<int>(sdr["Id"].ToString()),
                        Name = objComm.GetValue<string>(sdr["Name"].ToString()),
                        Type = objComm.GetValue<string>(sdr["Type"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            return null;
        }
        IEnumerable<tbl_Departmentwise_Report> tbl = List_SM as IEnumerable<tbl_Departmentwise_Report>;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    [WebMethod]
    public string Get_Department_Job_Staff_Report_JobStaff(tbl_Departmentwise_Report currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Departmentwise_Report> List_SM = new List<tbl_Departmentwise_Report>();
        DateTime fromdate = Convert.ToDateTime(currobj.fromdate, ci);
        DateTime todate = Convert.ToDateTime(currobj.todate, ci);
        try
        {
            SqlParameter[] param = new SqlParameter[10];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@StaffCode", currobj.StaffCode);
            param[2] = new SqlParameter("@status", currobj.status);
            param[3] = new SqlParameter("@Jobwise", currobj.Jobwise);
            param[4] = new SqlParameter("@staffwise", currobj.staffwise);
            param[5] = new SqlParameter("@fromdate", fromdate);
            param[6] = new SqlParameter("@todate", todate);
            param[7] = new SqlParameter("@DeptId", currobj.DeptId);
            param[8] = new SqlParameter("@selectedJob", currobj.selectedJob.TrimEnd(','));
            param[9] = new SqlParameter("@UserType", currobj.UserType);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Department_Job_Staff_Report_JobStaff", param))
            {
                while (sdr.Read())
                {
                    List_SM.Add(new tbl_Departmentwise_Report
                    {
                        Id = objComm.GetValue<int>(sdr["Id"].ToString()),
                        Name = objComm.GetValue<string>(sdr["Name"].ToString()),
                        Type = objComm.GetValue<string>(sdr["Type"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            return null;
        }
        IEnumerable<tbl_Departmentwise_Report> tbl = List_SM as IEnumerable<tbl_Departmentwise_Report>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}