<%@ WebService Language="C#" Class="ResourceDetailedReport" %>

using System;
using System.Web.Services;
using CommonLibrary;
using System.Data.SqlClient;
using System.Data;
using Microsoft.ApplicationBlocks1.Data;
using System.Web.Script.Serialization;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ResourceDetailedReport : System.Web.Services.WebService
{
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    [WebMethod(EnableSession=true)]
    public string GetResourceDetailedReport(int deptId, string startDate, string endDate, string staffIds, int pageIndex, int pageSize)
    {
        string stDate = startDate != "" ? Convert.ToDateTime(startDate).ToString("MM/dd/yyyy") : null;
        string edDate = endDate != "" ? Convert.ToDateTime(endDate).ToString("MM/dd/yyyy") : null;
        tbl_ResourceDetailedReport _ResourceDetailedReport = new tbl_ResourceDetailedReport();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[7];
                param[0] = new SqlParameter("@CompId", Session["companyid"]);
                param[1] = new SqlParameter("@DeptId", deptId);
                param[2] = new SqlParameter("@StartDate", stDate);
                param[3] = new SqlParameter("@EndDate", edDate);
                param[4] = new SqlParameter("@StaffIds", staffIds);
                param[5] = new SqlParameter("@PageIndex", pageIndex);
                //param[6] = new SqlParameter("@PageSize", pageSize);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstarp_ResourceDetailedReport", param))
                {
                    while (drrr.Read())
                    {
                        _ResourceDetailedReport.AvailableTime = drrr["AvailableHrs"] == null ? 0 : objComm.GetValue<decimal>(drrr["AvailableHrs"].ToString());
                        _ResourceDetailedReport.TotalTime = drrr["ActualEffortHrs"] == null ? 0 : objComm.GetValue<decimal>(drrr["ActualEffortHrs"].ToString());
                        _ResourceDetailedReport.ActualTime = drrr["BillableHrs"] == null ? 0 : objComm.GetValue<decimal>(drrr["BillableHrs"].ToString());
                        _ResourceDetailedReport.NoOfClients = drrr["NoofClients"] == null ? 0 : objComm.GetValue<int>(drrr["NoofClients"].ToString());
                        _ResourceDetailedReport.NoOfProjects = drrr["NoofProjects"] == null ? 0 : objComm.GetValue<int>(drrr["NoofProjects"].ToString());
                    }
                }
            }
        }
        catch (Exception ex)
        { throw ex; }
        return new JavaScriptSerializer().Serialize(_ResourceDetailedReport);
    }

    [WebMethod(EnableSession=true)]
    public string GetStaffsDeptwise(int deptId, string startDate, string endDate)
    {
        string stDate = startDate != "" ? Convert.ToDateTime(startDate).ToString("MM/dd/yyyy") : null;
        string edDate = endDate != "" ? Convert.ToDateTime(endDate).ToString("MM/dd/yyyy") : null;
        List<tbl_Staffs_Dept> List_DS = new List<tbl_Staffs_Dept>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@CompId", Session["companyid"]);
                param[1] = new SqlParameter("@DeptId", deptId);
                param[2] = new SqlParameter("@Startdate", stDate);
                param[3] = new SqlParameter("@Enddate", edDate);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstarp_GetStaffsDeptwise", param))
                {
                    while (drrr.Read())
                    {
                        List_DS.Add(new tbl_Staffs_Dept()
                        {
                            StaffId = objComm.GetValue<int>(drrr["StaffId"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(List_DS);
    }
    [WebMethod(EnableSession=true)]
    public string GetDepartments(int compId=0)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<Department_Master> listDepartmentMaster = new List<Department_Master>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@CompId", Session["companyid"]);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Departments", param))
                {
                    while (drrr.Read())
                    {
                        listDepartmentMaster.Add(new Department_Master()
                        {
                            DepId = objComm.GetValue<int>(drrr["DepId"].ToString()),
                            DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString())
                        });
                    }

                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(listDepartmentMaster);
    }
}