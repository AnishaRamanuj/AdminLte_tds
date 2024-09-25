<%@ WebService Language="C#" Class="DirectorDasboard" %>

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
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class DirectorDasboard : System.Web.Services.WebService
{
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod(EnableSession = true)]
    public string YearlyBarGraph(string startDate, string endDate)
    {
        string fromDate = startDate != "" ? Convert.ToDateTime(startDate).ToString("MM/dd/yyyy") : null;
        string toDate = endDate != "" ? Convert.ToDateTime(endDate).ToString("MM/dd/yyyy") : null;
        DataSet ds;
        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@StartDate", fromDate);
            param[2] = new SqlParameter("@EndDate", toDate);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_YearlyBarGraph", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod(EnableSession = true)]
    public string GetClientsandProjectsData(string fromDate, string toDate, int mmdd)
    {
        string frtime;
        string totime;
        if (mmdd == 0)
        {
            frtime = fromDate != "" ? Convert.ToDateTime(fromDate, ci).ToString("MM/dd/yyyy") : null;
            totime = toDate != "" ? Convert.ToDateTime(toDate, ci).ToString("MM/dd/yyyy") : null;
        }
        else
        {
            frtime = fromDate;
            totime = toDate;
        }
        DataSet ds;
        DirectorDasboardData directorDasboardData = new DirectorDasboardData();

        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@FromDate", frtime);
            param[2] = new SqlParameter("@ToDate", totime);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetClientsandProjectsData_Dashboard", param);

            DirectorDasboardCounts dasboardCounts = new DirectorDasboardCounts();
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                dasboardCounts.CompId = Convert.ToInt32(row["CompId"]);
                dasboardCounts.BillableHrs = Convert.ToDecimal(row["BillableHrs"]);
                dasboardCounts.NonBillableHrs = Convert.ToDecimal(row["NonBillableHrs"]);
                dasboardCounts.TotalHrs = Convert.ToDecimal(row["TotalHrs"]);
                dasboardCounts.ApprovalPending = Convert.ToDecimal(row["ApprovalPending"]);
                dasboardCounts.TSNotSubmitted = Convert.ToInt32(row["TSNotSubmitted"]);
            }

            List<Client> clients = new List<Client>();
            foreach (DataRow row in ds.Tables[1].Rows)
            {
                Client client = new Client();
                client.ClientId = Convert.ToInt32(row["ClientId"]);
                client.ClientName = Convert.ToString(row["ClientName"]);
                client.BillableHrs = Convert.ToDecimal(row["BillableHrs"]);
                client.NonBillableHrs = Convert.ToDecimal(row["NonBillableHrs"]);
                client.TotalHrs = Convert.ToDecimal(row["TotalHrs"]);
                clients.Add(client);
            };

            List<ClientProject> clientProjects = new List<ClientProject>();
            foreach (DataRow row in ds.Tables[2].Rows)
            {
                ClientProject project = new ClientProject();
                project.ProjectId = Convert.ToInt32(row["ProjectId"]);
                project.ProjectName = Convert.ToString(row["ProjectName"]);
                project.ClientId = Convert.ToInt32(row["ClientId"]);
                project.BillableHrs = Convert.ToDecimal(row["BillableHrs"]);
                project.NonBillableHrs = Convert.ToDecimal(row["NonBillableHrs"]);
                project.TotalHrs = Convert.ToDecimal(row["TotalHrs"]);
                clientProjects.Add(project);
            };

            List<ClientStaff> clientstaffs = new List<ClientStaff>();
            foreach (DataRow row in ds.Tables[3].Rows)
            {
                ClientStaff staff = new ClientStaff();
                staff.StaffCode = Convert.ToInt32(row["StaffCode"]);
                staff.StaffName = Convert.ToString(row["StaffName"]);
                staff.ClientId = Convert.ToInt32(row["ClientId"]);
                staff.ProjectId = Convert.ToInt32(row["ProjectId"]);
                staff.BillableHrs = Convert.ToDecimal(row["BillableHrs"]);
                staff.NonBillableHrs = Convert.ToDecimal(row["NonBillableHrs"]);
                staff.TotalHrs = Convert.ToDecimal(row["TotalHrs"]);
                clientstaffs.Add(staff);
            };

            List<ClientTasks> clientTasks = new List<ClientTasks>();
            foreach (DataRow row in ds.Tables[4].Rows)
            {
                ClientTasks task = new ClientTasks();
                task.TaskId = Convert.ToInt32(row["TaskId"]);
                task.TaskName = Convert.ToString(row["TaskName"]);
                task.StaffCode = Convert.ToInt32(row["StaffCode"]);
                task.ClientId = Convert.ToInt32(row["ClientId"]);
                task.ProjectId = Convert.ToInt32(row["ProjectId"]);
                task.BillableHrs = Convert.ToDecimal(row["BillableHrs"]);
                task.NonBillableHrs = Convert.ToDecimal(row["NonBillableHrs"]);
                task.TotalHrs = Convert.ToDecimal(row["TotalHrs"]);
                clientTasks.Add(task);
            };

            List<ProjectTab> projects = new List<ProjectTab>();
            foreach (DataRow row in ds.Tables[5].Rows)
            {
                ProjectTab project = new ProjectTab();
                project.ProjectId = Convert.ToInt32(row["ProjectId"]);
                project.ProjectName = Convert.ToString(row["ProjectName"]);
                project.BillableHrs = Convert.ToDecimal(row["BillableHrs"]);
                project.NonBillableHrs = Convert.ToDecimal(row["NonBillableHrs"]);
                project.TotalHrs = Convert.ToDecimal(row["TotalHrs"]);
                projects.Add(project);
            };

            List<ProjectStaffs> projectStaffs = new List<ProjectStaffs>();
            foreach (DataRow row in ds.Tables[6].Rows)
            {
                ProjectStaffs staff = new ProjectStaffs();
                staff.StaffCode = Convert.ToInt32(row["StaffCode"]);
                staff.StaffName = Convert.ToString(row["StaffName"]);
                staff.ProjectId = Convert.ToInt32(row["ProjectId"]);
                staff.BillableHrs = Convert.ToDecimal(row["BillableHrs"]);
                staff.NonBillableHrs = Convert.ToDecimal(row["NonBillableHrs"]);
                staff.TotalHrs = Convert.ToDecimal(row["TotalHrs"]);
                projectStaffs.Add(staff);
            };

            List<ProjectTasks> projectTasks = new List<ProjectTasks>();
            foreach (DataRow row in ds.Tables[7].Rows)
            {
                ProjectTasks task = new ProjectTasks();
                task.TaskId = Convert.ToInt32(row["TaskId"]);
                task.TaskName = Convert.ToString(row["TaskName"]);
                task.StaffCode = Convert.ToInt32(row["StaffCode"]);
                task.ProjectId = Convert.ToInt32(row["ProjectId"]);
                task.BillableHrs = Convert.ToDecimal(row["BillableHrs"]);
                task.NonBillableHrs = Convert.ToDecimal(row["NonBillableHrs"]);
                task.TotalHrs = Convert.ToDecimal(row["TotalHrs"]);
                projectTasks.Add(task);
            };

            List<Employee> employees = new List<Employee>();
            foreach (DataRow row in ds.Tables[8].Rows)
            {
                Employee staff = new Employee();
                staff.StaffCode = Convert.ToInt32(row["StaffCode"]);
                staff.StaffName = Convert.ToString(row["StaffName"]);
                staff.BillableHrs = Convert.ToDecimal(row["BillableHrs"]);
                staff.NonBillableHrs = Convert.ToDecimal(row["NonBillableHrs"]);
                staff.TotalHrs = Convert.ToDecimal(row["TotalHrs"]);
                employees.Add(staff);
            };

            List<EmployeeTasks> employeeTasks = new List<EmployeeTasks>();
            foreach (DataRow row in ds.Tables[9].Rows)
            {
                EmployeeTasks task = new EmployeeTasks();
                task.TaskId = Convert.ToInt32(row["TaskId"]);
                task.TaskName = Convert.ToString(row["TaskName"]);
                task.StaffCode = Convert.ToInt32(row["StaffCode"]);
                task.BillableHrs = Convert.ToDecimal(row["BillableHrs"]);
                task.NonBillableHrs = Convert.ToDecimal(row["NonBillableHrs"]);
                task.TotalHrs = Convert.ToDecimal(row["TotalHrs"]);
                employeeTasks.Add(task);
            };

            List<Tasks> tasks = new List<Tasks>();
            foreach (DataRow row in ds.Tables[10].Rows)
            {
                Tasks task = new Tasks();
                task.TaskId = Convert.ToInt32(row["TaskId"]);
                task.TaskName = Convert.ToString(row["TaskName"]);
                task.BillableHrs = Convert.ToDecimal(row["BillableHrs"]);
                task.NonBillableHrs = Convert.ToDecimal(row["NonBillableHrs"]);
                task.TotalHrs = Convert.ToDecimal(row["TotalHrs"]);
                tasks.Add(task);
            };

            List<ApprovalPending> approvalPendingApprovers = new List<ApprovalPending>();
            foreach (DataRow row in ds.Tables[11].Rows)
            {
                ApprovalPending approvalPending = new ApprovalPending();
                approvalPending.ApproverId = Convert.ToInt32(row["ApproverId"]);
                approvalPending.AprroverName = Convert.ToString(row["ApproverName"]);
                approvalPending.PendingHrs = Convert.ToDecimal(row["HrsPending"]);
                approvalPendingApprovers.Add(approvalPending);
            };

            directorDasboardData.DirectorDasboardCounts = dasboardCounts;
            directorDasboardData.Clients = clients;
            directorDasboardData.ClientCount = clients.Count;
            directorDasboardData.ClientProjects = clientProjects;
            directorDasboardData.ProjectCount = clientProjects.Count;
            directorDasboardData.ClientStaffs = clientstaffs;
            directorDasboardData.StaffMemberCount = employees.Count;
            directorDasboardData.ClientTasks = clientTasks;
            directorDasboardData.TasksCount = tasks.Count;
            directorDasboardData.Projects = projects;
            directorDasboardData.ProjectStaffs = projectStaffs;
            directorDasboardData.ProjectTasks = projectTasks;
            directorDasboardData.Employees = employees;
            directorDasboardData.EmployeeTasks = employeeTasks;
            directorDasboardData.Tasks = tasks;
            directorDasboardData.ApprovalPendingApprovers = approvalPendingApprovers;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(directorDasboardData);
    }

    [WebMethod(EnableSession = true)]
    public string GetProjects(string status)
    {
        List<Project_master> projects = new List<Project_master>();

        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@Status", status);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetProjects_DirectorDashboard", param))
            {
                while (drrr.Read())
                {
                    projects.Add(new Project_master()
                    {
                        projectid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        projectName = objComm.GetValue<string>(drrr["ProjectName"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(projects);
    }

    [WebMethod(EnableSession = true)]
    public string GetDashboardResourcePlanning(string projectId)
    {
        DataSet ds;
        DirectorDasboardProjectResourcePlanning directorDasboardProjectResourcePlanning = new DirectorDasboardProjectResourcePlanning();
        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@ProjectId", projectId);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Dashboard_Resource_Planning", param);

            List<DashboardResourcePlanning_MonthlyConsumedHrs> monthlyConsumedHrs = new List<DashboardResourcePlanning_MonthlyConsumedHrs>();
            foreach (DataRow row in ds.Tables[0].Rows)
            {
                monthlyConsumedHrs.Add(new DashboardResourcePlanning_MonthlyConsumedHrs
                {
                    MonthNo = Convert.ToInt32(row["MonthNo"]),
                    MonthName = Convert.ToString(row["MonthName"]),
                    TotalHrs = Convert.ToDecimal(row["TotalHrs"]),
                    CumulativeTotalHrs = Convert.ToDecimal(row["CumulativeTotal"])
                });
            }

            DashboardResourcePlanning_ProjectData projectData = new DashboardResourcePlanning_ProjectData();
            foreach (DataRow row in ds.Tables[1].Rows)
            {
                projectData.ProjectId = Convert.ToInt32(row["ProjectId"]);
                projectData.ProjectName = Convert.ToString(row["ProjectName"]);
                projectData.ProjectStartDate = Convert.ToString(row["ProjectStartDate"]);
                projectData.ProjectEndDate = Convert.ToString(row["ProjectEndDate"]);
                projectData.ProjectedDays = Convert.ToInt32(row["ProjectedDays"]);
                projectData.StaffCount = Convert.ToInt32(row["StaffCount"]);
                projectData.DailyHrs = Convert.ToInt32(row["DailyHrs"]);
                projectData.PlannedHrs = Convert.ToDecimal(row["PlannedHrs"]);
                projectData.ConsumedHrs = Convert.ToDecimal(row["ConsumedHrs"]);
                projectData.BalanceHrs = Convert.ToDecimal(row["BalanceHrs"]);
                projectData.BalanceDays = Convert.ToInt32(row["BalanceDays"]);
            }
            directorDasboardProjectResourcePlanning.DashboardResourcePlanning_ProjectData = projectData;
            directorDasboardProjectResourcePlanning.DashboardResourcePlanning_MonthlyConsumedHrs = monthlyConsumedHrs;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(directorDasboardProjectResourcePlanning);
    }

    [WebMethod(EnableSession = true)]
    public string GetDashboardProjectwiseAnalytics(string projectIds, string status, int pageIndex, int pageSize, string fromDate, string toDate)
    {
        List<DashboardResourcePlanning_ProjectData> listProjectData = new List<DashboardResourcePlanning_ProjectData>();
        DirectorDasboardProjectResourcePlanningData directorDasboardProjectResourcePlanningData = new DirectorDasboardProjectResourcePlanningData();
        try
        {
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@ProjectIds", projectIds);
            param[2] = new SqlParameter("@Status", status);
            param[3] = new SqlParameter("@PageIndex", pageIndex);
            param[4] = new SqlParameter("@PageSize", pageSize);
            param[5] = new SqlParameter("@FromDate", fromDate);
            param[6] = new SqlParameter("@ToDate", toDate);

            DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Dashboard_Resource_Planning_ProjectList", param);

            foreach (DataRow row in ds.Tables[0].Rows)
            {
                DashboardResourcePlanning_ProjectData projectData = new DashboardResourcePlanning_ProjectData();
                projectData.ProjectId = row["ProjectId"] == DBNull.Value ? 0 : Convert.ToInt32(row["ProjectId"]);
                projectData.ProjectName = row["ProjectName"] == DBNull.Value ? "" : Convert.ToString(row["ProjectName"]);
                projectData.ClientName = row["ClientName"] == DBNull.Value ? "" : Convert.ToString(row["ClientName"]);
                projectData.ProjectStartDate = row["ProjectStartDate"] == DBNull.Value ? "" : Convert.ToString(row["ProjectStartDate"]);
                projectData.ProjectEndDate = row["ProjectEndDate"] == DBNull.Value ? "" : Convert.ToString(row["ProjectEndDate"]);
                projectData.ProjectedDays = row["ProjectedDays"] == DBNull.Value ? 0 : Convert.ToInt32(row["ProjectedDays"]);
                projectData.StaffCount = row["StaffCount"] == DBNull.Value ? 0 : Convert.ToInt32(row["StaffCount"]);
                projectData.DailyHrs = row["DailyHrs"] == DBNull.Value ? 0 : Convert.ToInt32(row["DailyHrs"]);
                projectData.PlannedHrs = row["PlannedHrs"] == DBNull.Value ? 0 : Convert.ToDecimal(row["PlannedHrs"]);
                projectData.ConsumedHrs = row["ConsumedHrs"] == DBNull.Value ? 0 : Convert.ToDecimal(row["ConsumedHrs"]);
                projectData.BalanceHrs = row["BalanceHrs"] == DBNull.Value ? 0 : Convert.ToDecimal(row["BalanceHrs"]);
                projectData.BalanceDays = row["BalanceDays"] == DBNull.Value ? 0 : Convert.ToInt32(row["BalanceDays"]);
                projectData.ActualAvailableHrs = row["ActualAvailableHrs"] == DBNull.Value ? 0 : Convert.ToDecimal(row["ActualAvailableHrs"]);
                projectData.ActualDaysReq = row["ActualDaysReq"] == DBNull.Value ? 0 : Convert.ToInt32(row["ActualDaysReq"]);
                projectData.ActualCompletionDate = row["ActualCompletionDate"] == DBNull.Value ? "" : Convert.ToString(row["ActualCompletionDate"]);
                projectData.ActualBalanceHrs = row["ActualBalanceHrs"] == DBNull.Value ? 0 : Convert.ToDecimal(row["ActualBalanceHrs"]);
                projectData.ExtraResourceReqCount = row["ExtraResourceReqCount"] == DBNull.Value ? 0 : Convert.ToInt32(row["ExtraResourceReqCount"]);
                projectData.ProjectCompletionStatus = row["ProjectCompletionStatus"] == DBNull.Value ? "" : Convert.ToString(row["ProjectCompletionStatus"]);

                listProjectData.Add(projectData);
            }

            DataTable dt = ds.Tables[1];
            var RecordCount = 0;
            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                RecordCount = Convert.ToInt32(row["Totalcount"]);
            }
            directorDasboardProjectResourcePlanningData.DashboardResourcePlanning_ProjectData = listProjectData;
            directorDasboardProjectResourcePlanningData.TotalCount = Convert.ToInt32(RecordCount);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(directorDasboardProjectResourcePlanningData);
    }
}

public class DirectorDasboardData
{
    public DirectorDasboardCounts DirectorDasboardCounts { get; set; }
    public List<Client> Clients { get; set; }
    public List<ClientProject> ClientProjects { get; set; }
    public List<ClientStaff> ClientStaffs { get; set; }
    public List<ClientTasks> ClientTasks { get; set; }
    public int ClientCount { get; set; }
    public int ProjectCount { get; set; }
    public int StaffMemberCount { get; set; }
    public int TasksCount { get; set; }
    public List<ProjectTab> Projects { get; set; }
    public List<ProjectStaffs> ProjectStaffs { get; set; }
    public List<ProjectTasks> ProjectTasks { get; set; }
    public List<Employee> Employees { get; set; }
    public List<EmployeeTasks> EmployeeTasks { get; set; }
    public List<Tasks> Tasks { get; set; }
    public List<ApprovalPending> ApprovalPendingApprovers { get; set; }
}

public class DirectorDasboardCounts
{
    public int CompId { get; set; }
    public decimal BillableHrs { get; set; }
    public decimal NonBillableHrs { get; set; }
    public decimal TotalHrs { get; set; }
    public decimal ApprovalPending { get; set; }
    public int TSNotSubmitted { get; set; }
}

public class Client
{
    public int ClientId { get; set; }
    public string ClientName { get; set; }
    public decimal BillableHrs { get; set; }
    public decimal NonBillableHrs { get; set; }
    public decimal TotalHrs { get; set; }
}

public class ClientProject
{
    public int ProjectId { get; set; }
    public string ProjectName { get; set; }
    public int ClientId { get; set; }
    public decimal BillableHrs { get; set; }
    public decimal NonBillableHrs { get; set; }
    public decimal TotalHrs { get; set; }
}

public class ClientStaff
{
    public int StaffCode { get; set; }
    public string StaffName { get; set; }
    public int ClientId { get; set; }
    public int ProjectId { get; set; }
    public decimal BillableHrs { get; set; }
    public decimal NonBillableHrs { get; set; }
    public decimal TotalHrs { get; set; }
}

public class ClientTasks
{
    public int TaskId { get; set; }
    public string TaskName { get; set; }
    public int StaffCode { get; set; }
    public int ClientId { get; set; }
    public int ProjectId { get; set; }
    public decimal BillableHrs { get; set; }
    public decimal NonBillableHrs { get; set; }
    public decimal TotalHrs { get; set; }
}

public class ProjectTab
{
    public int ProjectId { get; set; }
    public string ProjectName { get; set; }
    public int ClientId { get; set; }
    public decimal BillableHrs { get; set; }
    public decimal NonBillableHrs { get; set; }
    public decimal TotalHrs { get; set; }
}

public class ProjectStaffs
{
    public int StaffCode { get; set; }
    public string StaffName { get; set; }
    public int ProjectId { get; set; }
    public decimal BillableHrs { get; set; }
    public decimal NonBillableHrs { get; set; }
    public decimal TotalHrs { get; set; }
}

public class ProjectTasks
{
    public int TaskId { get; set; }
    public string TaskName { get; set; }
    public int StaffCode { get; set; }
    public int ClientId { get; set; }
    public int ProjectId { get; set; }
    public decimal BillableHrs { get; set; }
    public decimal NonBillableHrs { get; set; }
    public decimal TotalHrs { get; set; }
}

public class Employee
{
    public int StaffCode { get; set; }
    public string StaffName { get; set; }
    public int ProjectId { get; set; }
    public decimal BillableHrs { get; set; }
    public decimal NonBillableHrs { get; set; }
    public decimal TotalHrs { get; set; }
}


public class EmployeeTasks
{
    public int TaskId { get; set; }
    public string TaskName { get; set; }
    public int StaffCode { get; set; }
    public int ProjectId { get; set; }
    public decimal BillableHrs { get; set; }
    public decimal NonBillableHrs { get; set; }
    public decimal TotalHrs { get; set; }
}

public class Tasks
{
    public int TaskId { get; set; }
    public string TaskName { get; set; }
    public decimal BillableHrs { get; set; }
    public decimal NonBillableHrs { get; set; }
    public decimal TotalHrs { get; set; }
}

public class ApprovalPending
{
    public int ApproverId { get; set; }
    public string AprroverName { get; set; }
    public decimal PendingHrs { get; set; }
}

public class DashboardResourcePlanning_ProjectData
{
    public int ProjectId { get; set; }
    public string ProjectName { get; set; }
    public string ProjectStartDate { get; set; }
    public string ProjectEndDate { get; set; }
    public int ProjectedDays { get; set; }
    public int StaffCount { get; set; }
    public int DailyHrs { get; set; }
    public decimal PlannedHrs { get; set; }
    public decimal ConsumedHrs { get; set; }
    public decimal BalanceHrs { get; set; }
    public int BalanceDays { get; set; }
    public string ClientName { get; set; }
    public decimal ActualAvailableHrs { get; set; }
    public int ActualDaysReq { get; set; }
    public string ActualCompletionDate { get; set; }
    public decimal ActualBalanceHrs { get; set; }
    public int ExtraResourceReqCount { get; set; }
    public string ProjectCompletionStatus { get; set; }
}


public class DashboardResourcePlanning_MonthlyConsumedHrs
{
    public int ProjectId { get; set; }
    public int MonthNo { get; set; }
    public string MonthName { get; set; }
    public decimal TotalHrs { get; set; }
    public decimal CumulativeTotalHrs { get; set; }
}

public class DashboardResourcePlanning_StaffConsumedHrs
{
    public int ProjectId { get; set; }
    public int StaffCode { get; set; }
    public string StaffName { get; set; }
    public decimal TotalHrs { get; set; }
}

public class DirectorDasboardProjectResourcePlanning
{
    public DashboardResourcePlanning_ProjectData DashboardResourcePlanning_ProjectData { get; set; }
    public List<DashboardResourcePlanning_MonthlyConsumedHrs> DashboardResourcePlanning_MonthlyConsumedHrs { get; set; }

}

public class DirectorDasboardProjectResourcePlanningData
{
    public List<DashboardResourcePlanning_ProjectData> DashboardResourcePlanning_ProjectData { get; set; }
    public int TotalCount { get; set; }
}