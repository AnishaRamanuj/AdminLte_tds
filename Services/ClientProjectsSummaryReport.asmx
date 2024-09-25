<%@ WebService Language="C#" Class="ClientProjectsSummaryReport" %>

using System;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ClientProjectsSummaryReport : System.Web.Services.WebService
{
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    [WebMethod(EnableSession=true)]
    public string GetClientsDeptwise(int deptId, string startDate, string endDate)
    {
        string stDate = startDate != "" ? Convert.ToDateTime(startDate).ToString("MM/dd/yyyy") : null;
        string edDate = endDate != "" ? Convert.ToDateTime(endDate).ToString("MM/dd/yyyy") : null;
        List<tbl_Clients_Dept> List_DS = new List<tbl_Clients_Dept>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@CompId", Session["companyid"]);
                param[1] = new SqlParameter("@DeptId", deptId);
                param[2] = new SqlParameter("@Startdate", stDate);
                param[3] = new SqlParameter("@Enddate", edDate);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstarp_GetClientsDeptwise", param))
                {
                    while (drrr.Read())
                    {
                        List_DS.Add(new tbl_Clients_Dept()
                        {
                            ClientId = objComm.GetValue<int>(drrr["ClientId"].ToString()),
                            ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString())
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
    public string GetClientwiseProjectSummary(int deptId, string startDate, string endDate, string clientIds, int pageIndex, int pageSize)
    {

        string stDate = startDate != "" ? Convert.ToDateTime(startDate).ToString("MM/dd/yyyy") : null;
        string edDate = endDate != "" ? Convert.ToDateTime(endDate).ToString("MM/dd/yyyy") : null;

        List<tbl_ClientwiseProjects> List_DS = new List<tbl_ClientwiseProjects>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[7];
                param[0] = new SqlParameter("@CompId", Session["companyid"]);
                param[1] = new SqlParameter("@DeptId", deptId);
                param[2] = new SqlParameter("@StartDate", startDate);
                param[3] = new SqlParameter("@EndDate", endDate);
                param[4] = new SqlParameter("@ClientId", clientIds);
                param[5] = new SqlParameter("@PageIndex", pageIndex);
                param[6] = new SqlParameter("@PageSize", pageSize);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetClientwiseProjectDetails_Report", param))
                {
                    while (drrr.Read())
                    {
                        List_DS.Add(new tbl_ClientwiseProjects()
                        {
                            //ClientId = drrr["ClientId"] == null ? 0 : objComm.GetValue<int>(drrr["ClientId"].ToString()),
                            Date = objComm.GetValue<string>(drrr["Date"].ToString()),
                            Project = drrr["Project"] == null ? "" : objComm.GetValue<string>(drrr["Project"].ToString()),
                            TotalTime = drrr["TotalTime"] == null ? 0 : objComm.GetValue<decimal>(drrr["TotalTime"].ToString()),
                            ActualTime = drrr["ActualTime"] == null ? 0 : objComm.GetValue<decimal>(drrr["ActualTime"].ToString()),
                            DayofMonth = drrr["DayofMonth"] == null ? "" : objComm.GetValue<string>(drrr["DayofMonth"].ToString()),
                            TotalCount = drrr["TotalCount"] == null ? 0 : objComm.GetValue<int>(drrr["TotalCount"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        { throw ex; }
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