<%@ WebService Language="C#" Class="TimesheetInput" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Data.SqlClient;
using CommonLibrary;
using System.Data;
using Microsoft.ApplicationBlocks1.Data;
using System.Web.Script.Serialization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class TimesheetInput : System.Web.Services.WebService
{

    [WebMethod(EnableSession = true)]

    public string getTimesheetInpurtrelatedDetails(string inputType, string lnk)
    {
        string result = "";
        string procname = "";
        if (inputType == "Multi")
        { procname = "usp_getTimesheetInpurtrelatedDetails_Multi"; }
        else if (inputType == "deptwise")
        { procname = "usp_getTimesheetInpurtrelatedDetails"; }
        else if (inputType == "")
        { procname = "usp_getTimesheetInpurtrelatedDetails_notypedefine"; }
        CommonFunctions objComm = new CommonFunctions();
        List<TimesheetInputDepartmentWise> obj_ts = new List<TimesheetInputDepartmentWise>();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", Session["staffid"]);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, procname, param))
            {
                ///////////get Staff Department details
                #region DepartmentWise
                if (procname == "usp_getTimesheetInpurtrelatedDetails")
                {
                    while (drrr.Read())
                    {
                        obj_ts.Add(new TimesheetInputDepartmentWise()
                        {
                            DepId = objComm.GetValue<string>(drrr["DepId"].ToString()),
                            DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                            staffBioServerid = objComm.GetValue<string>(drrr["staffBioServerid"].ToString()),
                            Branchname = objComm.GetValue<string>(drrr["BranchName"].ToString()),
                            HOD = objComm.GetValue<string>(drrr["HOD"].ToString()),
                            DesignationName = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        });
                    }

                    List<tbl_Job_Assign> listjobassign = new List<tbl_Job_Assign>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listjobassign.Add(new tbl_Job_Assign()
                                {
                                    Job_Assign_id = objComm.GetValue<int>(drrr["Job_Assign_id"].ToString()),
                                    Jobid = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                                    Assign_Id = objComm.GetValue<int>(drrr["Assign_Id"].ToString()),
                                    Dept_Id = objComm.GetValue<int>(drrr["Dept_Id"].ToString()),
                                    Compid = objComm.GetValue<int>(drrr["Compid"].ToString()),
                                });
                            }
                        }
                    }

                    List<Tbl_Assign_Details> listAssign_Details = new List<Tbl_Assign_Details>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listAssign_Details.Add(new Tbl_Assign_Details()
                                {
                                    Assign_Id = objComm.GetValue<int>(drrr["Assign_Id"].ToString()),
                                    Depid = objComm.GetValue<int>(drrr["Depid"].ToString()),
                                    mJobid = objComm.GetValue<int>(drrr["mJobid"].ToString()),
                                    MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                                    Billable = objComm.GetValue<bool>(drrr["Billable"].ToString()),
                                    //Hrs = objComm.GetValue<int>(drrr["hrs"].ToString()),
                                    //HrsExt = objComm.GetValue<string>(drrr["HrsExtend"].ToString()),

                                });
                            }
                        }
                    }

                    List<job_master_ts> listmaster_ts = new List<job_master_ts>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listmaster_ts.Add(new job_master_ts()
                                {
                                    JobId = objComm.GetValue<int>(drrr["JobId"].ToString()),
                                    CLTId = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                    CompId = objComm.GetValue<int>(drrr["CompId"].ToString()),
                                    JobName = objComm.GetValue<string>(drrr["JobName"].ToString()),
                                    JobGId = objComm.GetValue<int>(drrr["JobGId"].ToString()),
                                    CreationDate = objComm.GetValue<DateTime>(drrr["CreationDate"].ToString()),
                                    StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                    EndDate = objComm.GetValue<DateTime>(drrr["EndDate"].ToString()),
                                    BudHours = objComm.GetValue<float>(drrr["BudHours"].ToString()),
                                    BudAMt = objComm.GetValue<decimal>(drrr["BudAMt"].ToString()),
                                    ActualHours = objComm.GetValue<float>(drrr["ActualHours"].ToString()),
                                    ActualAmt = objComm.GetValue<decimal>(drrr["ActualAmt"].ToString()),
                                    JobStatus = objComm.GetValue<string>(drrr["JobStatus"].ToString()),
                                    ActualJobEndate = objComm.GetValue<DateTime>(drrr["ActualJobEndate"].ToString()),
                                    JobApprover = objComm.GetValue<int>(drrr["JobApprover"].ToString()),
                                    mJobID = objComm.GetValue<int>(drrr["mJobID"].ToString()),
                                    OtherBudAmt = objComm.GetValue<decimal>(drrr["OtherBudAmt"].ToString()),
                                    BudgetingSelection = objComm.GetValue<string>(drrr["BudgetingSelection"].ToString()),
                                    Billable = objComm.GetValue<bool>(drrr["Billable"].ToString()),
                                    ProjectID = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                                    ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                                    ProjectName = GetProjectNameWithProjectCode(objComm.GetValue<string>(drrr["ProjectName"].ToString()), objComm.GetValue<string>(drrr["Project_Code"].ToString())),
                                    PrjCode = objComm.GetValue<string>(drrr["Project_Code"].ToString()),
                                    Project_Hours = objComm.GetValue<string>(drrr["Project_Hours"].ToString()),
                                    Project_Amount = objComm.GetValue<string>(drrr["Project_Amount"].ToString()),
                                    BillVisible = objComm.GetValue<bool>(drrr["BillableVisible"].ToString()),
                                    PrjNeverEnd = objComm.GetValue<bool>(drrr["Never_Expires"].ToString()),
                                    CltCode = objComm.GetValue<string>(drrr["Client_Code"].ToString()),
                                    PlnType = objComm.GetValue<string>(drrr["Planner_Type"].ToString()),
                                });
                            }
                        }
                    }

                    List<tbl_UnfreezedDates> list_UnfreezedDates = new List<tbl_UnfreezedDates>();
                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                list_UnfreezedDates.Add(new tbl_UnfreezedDates()
                                {
                                    UnfreezedDate = objComm.GetValue<DateTime>(drrr["UnFreezeDate"].ToString()),
                                });
                            }
                        }
                    }

                    foreach (var item in obj_ts)
                    {
                        item.list_Assign_Details = listAssign_Details;
                        item.list_Job_Assign = listjobassign;
                        item.list_job_master_ts = listmaster_ts;
                        item.list_UnfreezedDates = list_UnfreezedDates;
                    }
                }
                #endregion
                /////////if input type task wise
                #region taskwise
                if (procname == "usp_getTimesheetInpurtrelatedDetails_Multi")
                {
                    while (drrr.Read())
                    {
                        obj_ts.Add(new TimesheetInputDepartmentWise()
                        {
                            DepId = objComm.GetValue<string>(drrr["DepId"].ToString()),
                            DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                            staffBioServerid = objComm.GetValue<string>(drrr["staffBioServerid"].ToString()),
                            Branchname = objComm.GetValue<string>(drrr["BranchName"].ToString()),
                            HOD = objComm.GetValue<string>(drrr["HOD"].ToString()),
                            DesignationName = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        });
                    }

                    List<tbl_Job_Assign> listjobassign = new List<tbl_Job_Assign>();
                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listjobassign.Add(new tbl_Job_Assign()
                                {
                                    Job_Assign_id = objComm.GetValue<int>(drrr["Job_Assign_id"].ToString()),
                                    Jobid = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                                    Assign_Id = objComm.GetValue<int>(drrr["Assign_Id"].ToString()),
                                    Dept_Id = objComm.GetValue<int>(drrr["Dept_Id"].ToString()),
                                    Compid = objComm.GetValue<int>(drrr["Compid"].ToString()),
                                });
                            }
                        }
                    }
                    ///////// if (procname == "usp_getTimesheetInpurtrelatedDetails_Multi")
                    List<Tbl_Assign_Details> listAssign_Details = new List<Tbl_Assign_Details>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listAssign_Details.Add(new Tbl_Assign_Details()
                                {
                                    Assign_Id = objComm.GetValue<int>(drrr["Assign_Id"].ToString()),
                                    Depid = objComm.GetValue<int>(drrr["Depid"].ToString()),
                                    mJobid = objComm.GetValue<int>(drrr["mJobid"].ToString()),
                                    MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                                });
                            }
                        }
                    }

                    List<job_master_ts> listmaster_ts = new List<job_master_ts>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listmaster_ts.Add(new job_master_ts()
                                {
                                    JobId = objComm.GetValue<int>(drrr["JobId"].ToString()),
                                    CLTId = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                    CompId = objComm.GetValue<int>(drrr["CompId"].ToString()),
                                    JobName = objComm.GetValue<string>(drrr["JobName"].ToString()),
                                    JobGId = objComm.GetValue<int>(drrr["JobGId"].ToString()),
                                    CreationDate = objComm.GetValue<DateTime>(drrr["CreationDate"].ToString()),
                                    StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                    EndDate = objComm.GetValue<DateTime>(drrr["EndDate"].ToString()),
                                    BudHours = objComm.GetValue<float>(drrr["BudHours"].ToString()),
                                    BudAMt = objComm.GetValue<decimal>(drrr["BudAMt"].ToString()),
                                    ActualHours = objComm.GetValue<float>(drrr["ActualHours"].ToString()),
                                    ActualAmt = objComm.GetValue<decimal>(drrr["ActualAmt"].ToString()),
                                    JobStatus = objComm.GetValue<string>(drrr["JobStatus"].ToString()),
                                    ActualJobEndate = objComm.GetValue<DateTime>(drrr["ActualJobEndate"].ToString()),
                                    JobApprover = objComm.GetValue<int>(drrr["JobApprover"].ToString()),
                                    mJobID = objComm.GetValue<int>(drrr["mJobID"].ToString()),
                                    OtherBudAmt = objComm.GetValue<decimal>(drrr["OtherBudAmt"].ToString()),
                                    BudgetingSelection = objComm.GetValue<string>(drrr["BudgetingSelection"].ToString()),
                                    Billable = objComm.GetValue<bool>(drrr["Billable"].ToString()),
                                    ProjectID = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                                    ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                                    ProjectName = GetProjectNameWithProjectCode(objComm.GetValue<string>(drrr["ProjectName"].ToString()), objComm.GetValue<string>(drrr["Project_Code"].ToString())),
                                    PrjCode = objComm.GetValue<string>(drrr["Project_Code"].ToString()),
                                    Project_Hours = objComm.GetValue<string>(drrr["Project_Hours"].ToString()),
                                    Project_Amount = objComm.GetValue<string>(drrr["Project_Amount"].ToString()),
                                    BillVisible = objComm.GetValue<bool>(drrr["BillableVisible"].ToString()),
                                    PrjNeverEnd = objComm.GetValue<bool>(drrr["Never_Expires"].ToString()),
                                    CltCode = objComm.GetValue<string>(drrr["Project_Code"].ToString()),
                                    PlnType = objComm.GetValue<string>(drrr["Planner_Type"].ToString()),
                                });
                            }
                        }
                    }

                    List<tbl_UnfreezedDates> list_UnfreezedDates = new List<tbl_UnfreezedDates>();
                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                list_UnfreezedDates.Add(new tbl_UnfreezedDates()
                                {
                                    UnfreezedDate = objComm.GetValue<DateTime>(drrr["UnFreezeDate"].ToString()),
                                });
                            }
                        }
                    }
                    /////// if (procname == "usp_getTimesheetInpurtrelatedDetails_Multi")
                    List<Tbl_Job_Task_Master> listtask = new List<Tbl_Job_Task_Master>();
                    if (lnk == "0")
                    {
                        if (drrr.NextResult())
                        {
                            if (drrr.HasRows)
                            {
                                while (drrr.Read())
                                {
                                    listtask.Add(new Tbl_Job_Task_Master()
                                    {
                                        //JobId = objComm.GetValue<int>(drrr["JobId"].ToString()),
                                        Projectid = objComm.GetValue<int>(drrr["Projectid"].ToString()),
                                        TaskId = objComm.GetValue<int>(drrr["TaskId"].ToString()),
                                        TaskName = objComm.GetValue<string>(drrr["TaskName"].ToString()),
                                        Expdate = objComm.GetValue<DateTime>(drrr["Expdate"].ToString()),
                                    });
                                }
                            }
                        }
                    }
                    else
                    {
                        if (drrr.NextResult())
                        {
                            if (drrr.HasRows)
                            {
                                while (drrr.Read())
                                {
                                    listtask.Add(new Tbl_Job_Task_Master()
                                    {
                                        mjobid = objComm.GetValue<int>(drrr["mJobId"].ToString()),
                                        TaskId = objComm.GetValue<int>(drrr["TaskId"].ToString()),
                                        TaskName = objComm.GetValue<string>(drrr["TaskName"].ToString()),
                                    });
                                }
                            }
                        }
                    }
                    foreach (var item in obj_ts)
                    {
                        item.list_job_task = listtask;
                        item.list_Assign_Details = listAssign_Details;
                        item.list_Job_Assign = listjobassign;
                        item.list_job_master_ts = listmaster_ts;
                        item.list_UnfreezedDates = list_UnfreezedDates;
                    }
                }
                #endregion
                /////////if input type not define
                #region Not define
                if (procname == "usp_getTimesheetInpurtrelatedDetails_notypedefine")
                {
                    while (drrr.Read())
                    {
                        obj_ts.Add(new TimesheetInputDepartmentWise()
                        {
                            DepId = objComm.GetValue<string>(drrr["DepId"].ToString()),
                            DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        });
                    }

                    List<job_master_ts> listmaster_ts = new List<job_master_ts>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listmaster_ts.Add(new job_master_ts()
                                {
                                    JobId = objComm.GetValue<int>(drrr["JobId"].ToString()),
                                    CLTId = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                    CompId = objComm.GetValue<int>(drrr["CompId"].ToString()),
                                    JobName = objComm.GetValue<string>(drrr["JobName"].ToString()),
                                    JobGId = objComm.GetValue<int>(drrr["JobGId"].ToString()),
                                    CreationDate = objComm.GetValue<DateTime>(drrr["CreationDate"].ToString()),
                                    StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                    EndDate = objComm.GetValue<DateTime>(drrr["EndDate"].ToString()),
                                    BudHours = objComm.GetValue<float>(drrr["BudHours"].ToString()),
                                    BudAMt = objComm.GetValue<decimal>(drrr["BudAMt"].ToString()),
                                    ActualHours = objComm.GetValue<float>(drrr["ActualHours"].ToString()),
                                    ActualAmt = objComm.GetValue<decimal>(drrr["ActualAmt"].ToString()),
                                    JobStatus = objComm.GetValue<string>(drrr["JobStatus"].ToString()),
                                    ActualJobEndate = objComm.GetValue<DateTime>(drrr["ActualJobEndate"].ToString()),
                                    JobApprover = objComm.GetValue<int>(drrr["JobApprover"].ToString()),
                                    mJobID = objComm.GetValue<int>(drrr["mJobID"].ToString()),
                                    OtherBudAmt = objComm.GetValue<decimal>(drrr["OtherBudAmt"].ToString()),
                                    BudgetingSelection = objComm.GetValue<string>(drrr["BudgetingSelection"].ToString()),
                                    Billable = objComm.GetValue<bool>(drrr["Billable"].ToString()),
                                    ProjectID = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                                    ProjectName = GetProjectNameWithProjectCode(objComm.GetValue<string>(drrr["ProjectName"].ToString()), objComm.GetValue<string>(drrr["Project_Code"].ToString())),
                                    PrjCode = objComm.GetValue<string>(drrr["Project_Code"].ToString()),
                                    ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                                    MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                                    BillVisible = objComm.GetValue<bool>(drrr["BillableVisible"].ToString()),
                                    PrjNeverEnd = objComm.GetValue<bool>(drrr["Never_Expires"].ToString()),
                                    CltCode = objComm.GetValue<string>(drrr["Project_Code"].ToString()),

                                });
                            }
                        }
                    }
                    foreach (var item in obj_ts)
                    {
                        item.list_job_master_ts = listmaster_ts;
                    }
                }
                #endregion
            }

            var serializer = new JavaScriptSerializer();
            serializer.MaxJsonLength = 900000000;
            IEnumerable<TimesheetInputDepartmentWise> tbl = obj_ts as IEnumerable<TimesheetInputDepartmentWise>;
            var obbbbb = tbl;
            //result = new JavaScriptSerializer().Serialize(tbl);
            result = serializer.Serialize(tbl);
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }

    private string GetProjectNameWithProjectCode(string name, string code)
    {
        return (code == string.Empty ? name : name + " ( " + code + " )");
    }

    [WebMethod(EnableSession = true)]
    public string Get_Client_Project_Activity(int compid, int staffcode)
    {
        string result = "";
        string procname = "";
        procname = "usp_getTimesheetInpurt_AllClients";

        CommonFunctions objComm = new CommonFunctions();
        List<TimesheetInput_AllClients> obj_ts = new List<TimesheetInput_AllClients>();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, procname, param))
            {
                while (drrr.Read())
                {
                    obj_ts.Add(new TimesheetInput_AllClients()
                    {
                        DepId = objComm.GetValue<string>(drrr["DepId"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        staffBioServerid = objComm.GetValue<string>(drrr["staffBioServerid"].ToString()),
                        Branchname = objComm.GetValue<string>(drrr["BranchName"].ToString()),
                        HOD = objComm.GetValue<string>(drrr["HOD"].ToString()),
                        DesignationName = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                    });
                }

                List<_Bind_clients> listjobassign = new List<_Bind_clients>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listjobassign.Add(new _Bind_clients()
                            {
                                Cltid = objComm.GetValue<int>(drrr["Cltid"].ToString()),
                                ClientName = objComm.GetValue<string>(drrr["Clientname"].ToString()),

                            });
                        }
                    }
                }

                List<_Bind_project> listAssign_Details = new List<_Bind_project>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAssign_Details.Add(new _Bind_project()
                            {
                                projectid = objComm.GetValue<int>(drrr["Projectid"].ToString()),
                                projectName = objComm.GetValue<string>(drrr["projectname"].ToString()),
                            });
                        }
                    }
                }

                List<_Bind_jobs> listmaster_ts = new List<_Bind_jobs>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listmaster_ts.Add(new _Bind_jobs()
                            {
                                MJobName = objComm.GetValue<string>(drrr["mJobName"].ToString()),
                                mJobID = objComm.GetValue<int>(drrr["mJobID"].ToString()),
                            });
                        }
                    }
                }

                List<tbl_UnfreezedDates> list_UnfreezedDates = new List<tbl_UnfreezedDates>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            list_UnfreezedDates.Add(new tbl_UnfreezedDates()
                            {
                                UnfreezedDate = objComm.GetValue<DateTime>(drrr["UnFreezeDate"].ToString()),
                            });
                        }
                    }
                }

                foreach (var item in obj_ts)
                {
                    item.list_Assign_Details = listAssign_Details;
                    item.list_Job_Assign = listjobassign;
                    item.list_job_master_ts = listmaster_ts;
                    item.list_UnfreezedDates = list_UnfreezedDates;
                }
            }

            IEnumerable<TimesheetInput_AllClients> tbl = obj_ts as IEnumerable<TimesheetInput_AllClients>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }

    [WebMethod(EnableSession = true)]
    public string Get_Job_Budgeted_Hours(timesheet_table ts)
    {
        string result = "";
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> obj_ts = new List<timesheet_table>();
        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@StaffCode", Session["staffid"]);
            param[1] = new SqlParameter("@JobId", ts.JobId);
            param[2] = new SqlParameter("@CompId", Session["companyid"]);
            param[3] = new SqlParameter("@mJob_Id", ts.mJob_Id);

            using (SqlDataReader rs = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Job_Staff_Hours", param))
            {
                while (rs.Read())
                {
                    obj_ts.Add(new timesheet_table()
                    {
                        Edit_Billing_Hrs = objComm.GetValue<string>(rs["BalHrs"].ToString()),
                    });
                }
            }

            IEnumerable<timesheet_table> tbl = obj_ts as IEnumerable<timesheet_table>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
        }
        return result;
    }

    [WebMethod(EnableSession = true)]
    public string Get_Job_Staff_Hours(timesheet_table ts)
    {
        string result = "";
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> obj_ts = new List<timesheet_table>();
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@StaffCode", Session["staffid"]);
            param[1] = new SqlParameter("@JobId", ts.JobId);
            param[2] = new SqlParameter("@CompId", Session["companyid"]);
            param[3] = new SqlParameter("@mJob_Id", ts.mJob_Id);
            using (SqlDataReader rs = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Job_Staff_Hours", param))
            {
                while (rs.Read())
                {
                    obj_ts.Add(new timesheet_table()
                    {
                        Edit_Billing_Hrs = objComm.GetValue<string>(rs["BalHrs"].ToString()),
                    });
                }
            }
            IEnumerable<timesheet_table> tbl = obj_ts as IEnumerable<timesheet_table>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
        }
        return result;
    }

    [WebMethod(EnableSession = true)]
    public string savetimesheetinput(List<timesheet_table> ts)
    {
        CommonFunctions objComm = new CommonFunctions();

        foreach (var item in ts)
        {
            try
            {
                DataTable dt = new DataTable();
                dt.Columns.Add("ExpId");
                dt.Columns.Add("IsBillable");
                dt.Columns.Add("Narration");
                dt.Columns.Add("Amt");
                dt.Columns.Add("Currency");
                dt.Columns.Add("Attachment");

                foreach (var li in item.list_ExpenseTs)
                {
                    DataRow dr = dt.NewRow();
                    dr["ExpId"] = li.ExpId;
                    dr["Narration"] = li.ExpNarration;
                    dr["Amt"] = li.Amt;
                    dr["Currency"] = li.Currency;
                    dt.Rows.Add(dr);
                }

                SqlParameter[] param = new SqlParameter[16];
                param[0] = new SqlParameter("@StaffCode", item.StaffCode);
                param[1] = new SqlParameter("@JobId", item.JobId);
                param[2] = new SqlParameter("@CompId", item.CompId);
                param[3] = new SqlParameter("@CLTId", item.CLTId);
                param[4] = new SqlParameter("@FromTime", item.FromTime);
                param[5] = new SqlParameter("@ToTime", item.ToTime);
                param[6] = new SqlParameter("@TotalTime", item.TotalTime);
                param[7] = new SqlParameter("@Date", item.Date);
                param[8] = new SqlParameter("@Status", item.Status.Split(',')[0]);
                param[9] = new SqlParameter("@Narration", item.Narration);
                param[10] = new SqlParameter("@Project_Id", item.Project_Id);
                param[11] = new SqlParameter("@mJob_Id", item.mJob_Id);
                param[12] = new SqlParameter("@Task_Id", item.Task_Id);
                param[13] = new SqlParameter("@TSId", item.TSId);
                param[13].Direction = ParameterDirection.Output;
                param[14] = new SqlParameter("@dtExpense", dt);
                param[15] = new SqlParameter("@LocId", item.LocId);

                var TSID = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_saveTSinput_New", param);
                if (TSID > 0)
                { item.TSId = Convert.ToInt32(param[13].Value); item.StaffName = "success"; }
                else { item.StaffName = "error"; }
            }
            catch (Exception ex)
            {
                item.StaffName = "error";
                item.InvoiceNo = ex.Message;
            }
        }
        return new JavaScriptSerializer().Serialize(ts as IEnumerable<timesheet_table>);
    }

    [WebMethod(EnableSession = true)]
    public string SaveMultipleTimesheets(timesheet_table ts)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> List_ts = new List<timesheet_table>();
        try
        {
            if (Session["staffid"] != null)
            {

                SqlParameter[] param = new SqlParameter[6];
                param[0] = new SqlParameter("@StaffCode", Session["staffid"]);
                param[1] = new SqlParameter("@CompId", Session["companyid"]);
                param[2] = new SqlParameter("@Sts", ts.Status);
                param[3] = new SqlParameter("@Timesheets", ts.Timesheets);
                param[4] = new SqlParameter("@Expenses", ts.Expenses.TrimStart('^'));
                param[5] = new SqlParameter("@PageName", ts.PageName);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_saveMultipleTimesheets_NewV2", param))
                {
                    while (drrr.Read())
                    {
                        List_ts.Add(new timesheet_table()
                        {
                            TSId = objComm.GetValue<int>(drrr["id"].ToString()),
                            Status = objComm.GetValue<string>(drrr["Stype"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            //throw ex;
        }
        IEnumerable<timesheet_table> tbl = List_ts as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string SaveTimesheets_AllClients(timesheet_table ts)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> List_ts = new List<timesheet_table>();

        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@StaffCode", ts.StaffCode);
            param[1] = new SqlParameter("@CompId", ts.CompId);
            param[2] = new SqlParameter("@Sts", ts.Status);
            param[3] = new SqlParameter("@Timesheets", ts.Timesheets);
            param[4] = new SqlParameter("@Expenses", ts.Expenses.TrimStart('^'));

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_saveTimesheets_AllClients", param))
            {
                while (drrr.Read())
                {
                    List_ts.Add(new timesheet_table()
                    {
                        TSId = objComm.GetValue<int>(drrr["id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            //throw ex;
        }
        IEnumerable<timesheet_table> tbl = List_ts as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetHolidays(timesheet_table ts)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> List_ts = new List<timesheet_table>();

        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@Fr", ts.FromDT);
            param[2] = new SqlParameter("@To", ts.ToDT);
            param[3] = new SqlParameter("@Staffcode", Session["staffid"]);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Holidays", param))
            {
                while (drrr.Read())
                {
                    List_ts.Add(new timesheet_table()
                    {
                        HolidayDT = objComm.GetValue<string>(drrr["HDT"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            //throw ex;
        }
        IEnumerable<timesheet_table> tbl = List_ts as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string getTimesheetsofSelectedWeek(DateTime startdate, DateTime enddate)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> tsList = new List<timesheet_table>();
        SqlParameter[] param = new SqlParameter[4];
        param[0] = new SqlParameter("@startdate", startdate);
        param[1] = new SqlParameter("@enddate", enddate);
        param[2] = new SqlParameter("@staffcode", Session["staffid"]);
        param[3] = new SqlParameter("@compid", Session["companyid"]);
        using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_getTimesheetsofSelectedWeek_new", param))
        {
            ///////////get Staff Department details
            while (drrr.Read())
            {
                tsList.Add(new timesheet_table()
                {
                    TSId = objComm.GetValue<int>(drrr["TSId"].ToString()),
                    //StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                    StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                    JobId = objComm.GetValue<int>(drrr["JobId"].ToString()),
                    //CompId = objComm.GetValue<int>(drrr["CompId"].ToString()),
                    CLTId = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                    JobApprover = objComm.GetValue<int>(drrr["JobApprover"].ToString()),
                    FromTime = objComm.GetValue<string>(drrr["FromTime"].ToString()),
                    ToTime = objComm.GetValue<string>(drrr["ToTime"].ToString()),
                    TotalTime = objComm.GetValue<string>(drrr["TotalTime"].ToString()),
                    OpeId = objComm.GetValue<int>(drrr["OpeId"].ToString()),
                    OpeAmt = objComm.GetValue<float>(drrr["OpeAmt"].ToString()),
                    LocId = objComm.GetValue<int>(drrr["LocId"].ToString()),
                    NarId = objComm.GetValue<int>(drrr["NarId"].ToString()),
                    Date1 = objComm.GetValue<string>(drrr["Date"].ToString()),
                    Status = objComm.GetValue<string>(drrr["Status"].ToString()),
                    Satffstatus = objComm.GetValue<string>(drrr["Satffstatus"].ToString()),
                    Project_Id = objComm.GetValue<int>(drrr["Project_Id"].ToString()),
                    Assign_Id = objComm.GetValue<int>(drrr["Assign_Id"].ToString()),
                    mJob_Id = objComm.GetValue<int>(drrr["mJob_Id"].ToString()),
                    Dept_Id = objComm.GetValue<int>(drrr["Dept_Id"].ToString()),
                    ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                    ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                    MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                    Narration = objComm.GetValue<string>(drrr["Narration"].ToString()),
                    TaskName = objComm.GetValue<string>(drrr["TaskName"].ToString()),
                    Billable = objComm.GetValue<bool>(drrr["Billable"].ToString()),
                    Reason = objComm.GetValue<string>(drrr["Reason"].ToString()),
                    DrawingAllocationId = objComm.GetValue<int>(drrr["DrawingAllocationId"].ToString())
                });
            }
        }
        return new JavaScriptSerializer().Serialize(tsList as IEnumerable<timesheet_table>);
    }

    [WebMethod(EnableSession = true)]
    public string getTimesheets_AllClients(DateTime startdate, DateTime enddate, int staffcode, int compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> tsList = new List<timesheet_table>();
        SqlParameter[] param = new SqlParameter[4];
        param[0] = new SqlParameter("@startdate", startdate);
        param[1] = new SqlParameter("@enddate", enddate);
        param[2] = new SqlParameter("@staffcode", staffcode);
        param[3] = new SqlParameter("@compid", compid);

        using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_getTimesheetsofSelectedWeek", param))
        {
            ///////////get Staff Department details
            while (drrr.Read())
            {
                tsList.Add(new timesheet_table()
                {
                    TSId = objComm.GetValue<int>(drrr["TSId"].ToString()),
                    StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                    StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                    JobId = objComm.GetValue<int>(drrr["JobId"].ToString()),
                    CompId = objComm.GetValue<int>(drrr["CompId"].ToString()),
                    CLTId = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                    JobApprover = objComm.GetValue<int>(drrr["JobApprover"].ToString()),
                    FromTime = objComm.GetValue<string>(drrr["FromTime"].ToString()),
                    ToTime = objComm.GetValue<string>(drrr["ToTime"].ToString()),
                    TotalTime = objComm.GetValue<string>(drrr["TotalTime"].ToString()),
                    OpeId = objComm.GetValue<int>(drrr["OpeId"].ToString()),
                    OpeAmt = objComm.GetValue<float>(drrr["OpeAmt"].ToString()),
                    LocId = objComm.GetValue<int>(drrr["LocId"].ToString()),
                    NarId = objComm.GetValue<int>(drrr["NarId"].ToString()),
                    Date1 = objComm.GetValue<string>(drrr["Date"].ToString()),
                    Status = objComm.GetValue<string>(drrr["Status"].ToString()),
                    Satffstatus = objComm.GetValue<string>(drrr["Satffstatus"].ToString()),
                    Project_Id = objComm.GetValue<int>(drrr["Project_Id"].ToString()),
                    Assign_Id = objComm.GetValue<int>(drrr["Assign_Id"].ToString()),
                    mJob_Id = objComm.GetValue<int>(drrr["mJob_Id"].ToString()),
                    Dept_Id = objComm.GetValue<int>(drrr["Dept_Id"].ToString()),
                    ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                    ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                    MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                    Narration = objComm.GetValue<string>(drrr["Narration"].ToString()),
                    TaskName = objComm.GetValue<string>(drrr["TaskName"].ToString()),
                    Billable = objComm.GetValue<bool>(drrr["Billable"].ToString()),
                    OnSite = objComm.GetValue<bool>(drrr["OnSite"].ToString()),

                    Reason = objComm.GetValue<string>(drrr["Reason"].ToString()),
                });
            }
        }
        return new JavaScriptSerializer().Serialize(tsList as IEnumerable<timesheet_table>);
    }

    [WebMethod(EnableSession = true)]
    public string deletesavedTimesheet(int TSID)
    {
        CommonFunctions objComm = new CommonFunctions();
        SqlParameter[] param = new SqlParameter[3];
        param[0] = new SqlParameter("@TSID", TSID);
        param[1] = new SqlParameter("@staffcode", Session["staffid"]);
        param[2] = new SqlParameter("@compid", Session["companyid"]);
        var res = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_deletesavedTimesheet", param);
        if (res > 0)
        { return "success"; }
        else { return "error"; }
    }

    [WebMethod(EnableSession = true)]
    public string saveeditSaveTimesheetInput(timesheet_table ts)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> List_ts = new List<timesheet_table>();
        string resString = "success";
        try
        {
            if (Session["staffid"] != null)
            {
                int i = 0;
                if (ts.Billable == true)
                {
                    i = 1;
                }

                int j = 0;
                if (ts.OnSite.HasValue)
                {
                    if (ts.OnSite == true)
                    {
                        j = 1;
                    }
                }

                SqlParameter[] param = new SqlParameter[19];
                param[0] = new SqlParameter("@StaffCode", Session["staffid"]);
                param[1] = new SqlParameter("@CompId", Session["companyid"]);
                param[2] = new SqlParameter("@FromTime", ts.FromTime);
                param[3] = new SqlParameter("@ToTime", ts.ToTime);
                param[4] = new SqlParameter("@TotalTime", ts.TotalTime);
                param[5] = new SqlParameter("@TSId", ts.TSId);
                param[6] = new SqlParameter("@Status", ts.Status);
                param[7] = new SqlParameter("@Narration", ts.Narration);
                param[8] = new SqlParameter("@LocId", ts.LocId);
                param[9] = new SqlParameter("@Billable", i);
                param[10] = new SqlParameter("@OnSite", j);
                param[11] = new SqlParameter("@DrawingAllocationId", ts.DrawingAllocationId);
                param[12] = new SqlParameter("@mjobid", ts.mJob_Id);
                param[13] = new SqlParameter("@ClientID", ts.CLTId );
                param[14] = new SqlParameter("@ProjectID", ts.Project_Id);
                param[15] = new SqlParameter("@TaskID", ts.Task_Id);
                param[16] = new SqlParameter("@AssignID", ts.Assign_Id); 
                param[17] = new SqlParameter("@JID", ts.JobId); 
                param[18] = new SqlParameter("@PageName", ts.PageName);
                //var TSID = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_saveeditSaveTimesheetInput_Billable_new", param);
                //DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_save_editedTimesheet", param);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_save_editedTimesheet", param))
                {
                    while (drrr.Read())
                    {
                        List_ts.Add(new timesheet_table()
                        {
                            //TSId = objComm.GetValue<int>(drrr["id"].ToString()),
                            Status = objComm.GetValue<string>(drrr["Stype"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            resString = "error";
        }
        IEnumerable<timesheet_table> tbl = List_ts as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    public string GetFileName(string filename)
    {
        if (!filename.Contains("/"))
        {
            return string.Empty;
        }
        else
        {
            return filename.Substring(filename.LastIndexOf("/") + 1);
        }
    }

    [WebMethod(EnableSession = true)]
    public string getExpenseagiainsTSID(int TSID)
    {
        string resString = "";
        CommonFunctions objComm = new CommonFunctions();
        List<ExpenseTs> obj_ts = new List<ExpenseTs>();
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@TSID", TSID);
            param[1] = new SqlParameter("@Compid", Session["companyid"]);
            param[2] = new SqlParameter("@StaffCode", Session["staffid"]);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_getExpenseagiainsTSID_NewV2", param))
            {
                while (drrr.Read())
                {
                    obj_ts.Add(new ExpenseTs()
                    {
                        ExpId = objComm.GetValue<int>(drrr["ExpId"].ToString()),
                        ExpNarration = objComm.GetValue<string>(drrr["ExpNarration"].ToString()),
                        TSId = objComm.GetValue<int>(drrr["TSId"].ToString()),
                        Amt = objComm.GetValue<float>(drrr["Amt"].ToString()),
                        Currency = objComm.GetValue<string>(drrr["Currency"].ToString()),
                        ExpName = objComm.GetValue<string>(drrr["OPEName"].ToString()),
                        Attachment = objComm.GetValue<string>(drrr["Attachment"].ToString()),
                        FileName = GetFileName(objComm.GetValue<string>(drrr["Attachment"].ToString())),
                    });
                }
            }
            resString = new JavaScriptSerializer().Serialize(obj_ts as IEnumerable<ExpenseTs>);
        }
        catch (Exception ex)
        {
            resString = "error" + ex.Message;
        }
        return resString;
    }

    [WebMethod(EnableSession = true)]
    public string saveExpenseagiainsTSID(int TSID, List<ExpenseTs> ts)
    {
        string res = "";
        try
        {
            CommonFunctions objComm = new CommonFunctions();

            DataTable dt = new DataTable();
            dt.Columns.Add("ExpId");
            dt.Columns.Add("IsBillable");
            dt.Columns.Add("Narration");
            dt.Columns.Add("Amt");
            dt.Columns.Add("Currency");
            dt.Columns.Add("Attachment");

            foreach (var li in ts)
            {
                DataRow dr = dt.NewRow();
                dr["ExpId"] = li.ExpId;
                dr["Narration"] = li.ExpNarration;
                dr["Amt"] = li.Amt;
                dr["Currency"] = li.Currency;
                dr["Attachment"] = li.Attachment;

                dt.Rows.Add(dr);
            }
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@staffcode", Session["staffid"]);
            param[1] = new SqlParameter("@TSID", TSID);
            param[2] = new SqlParameter("@compid", Session["companyid"]);
            param[3] = new SqlParameter("@dt", dt);
            var TSsID = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_saveExpenseagiainsTSIDV2", param);
            if (TSsID > 0)
            { res = "success"; }
            else { res = "error"; }
        }
        catch (Exception)
        {
            res = "error";
        }
        return res;
    }

    [WebMethod(EnableSession = true)]
    public string SubmitSavedTiemsheets(string TSIDS)
    {
        string res = "";
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> List_ts = new List<timesheet_table>();
        try
        {
            if (Session["staffid"] != null)
            {
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@TSIDS", TSIDS);
                param[1] = new SqlParameter("@staffcode", Session["staffid"]);
                param[2] = new SqlParameter("@compid", Session["companyid"]);
                //var TSsID = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_SubmitSavedTiemsheets", param);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_SubmitSavedTiemsheets", param))
                {
                    while (drrr.Read())
                    {
                        List_ts.Add(new timesheet_table()
                        {
                            //TSId = objComm.GetValue<int>(drrr["id"].ToString()),
                            Status = objComm.GetValue<string>(drrr["Stype"].ToString()),
                        });
                    }
                }

            }
            //if (TSsID > 0)
            //{ res = "success"; }
            //else { res = "error"; }
        }
        catch (Exception ex)
        {
            //throw ex;
        }
        IEnumerable<timesheet_table> tbl = List_ts as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string DeleteExpense(ExpenseTs currobj)
    {
        string res = "";
        try
        {
            string resString = "";
            CommonFunctions objComm = new CommonFunctions();
            List<ExpenseTs> obj_ts = new List<ExpenseTs>();

            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@ExpautoId", currobj.ExpAutoId);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_deleteExpense_againstTimesheet", param))
            {
                while (drrr.Read())
                {
                    obj_ts.Add(new ExpenseTs()
                    {
                        ExpAutoId = currobj.ExpAutoId,
                    });
                }
            }
            resString = new JavaScriptSerializer().Serialize(obj_ts as IEnumerable<ExpenseTs>);
        }
        catch (Exception)
        {
            res = "error";
        }
        return res;
    }

    [WebMethod(EnableSession = true)]
    public string Get_Drawing_Job_Based(timesheet_table ts)
    {
        string result = "";
        CommonFunctions objComm = new CommonFunctions();
        List<vw_DrawingMaster> List_ts = new List<vw_DrawingMaster>();

        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@StaffCode", ts.StaffCode);
            param[1] = new SqlParameter("@JobId", ts.JobId);
            param[2] = new SqlParameter("@CompId", ts.CompId);
            param[3] = new SqlParameter("@mJob_Id", ts.mJob_Id);
            param[4] = new SqlParameter("@ProjectId", ts.Project_Id);
            param[5] = new SqlParameter("@ClientId", ts.CLTId);

            using (SqlDataReader rs = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Drawing_List", param))
            {
                while (rs.Read())
                {
                    List_ts.Add(new vw_DrawingMaster()
                    {
                        DrawingId = objComm.GetValue<int>(rs["DId"].ToString()),
                        DrawingName = objComm.GetValue<string>(rs["DName"].ToString()),
                    });
                }
            }
            IEnumerable<vw_DrawingMaster> tbl = List_ts as IEnumerable<vw_DrawingMaster>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }

    [WebMethod(EnableSession = true)]
    public string GetDrawingAllocationsbyStaffCode(timesheet_table ts)
    {
        string result = "";
        CommonFunctions objComm = new CommonFunctions();
        List<vw_DrawingMaster> obj_ts = new List<vw_DrawingMaster>();
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@StaffCode", Session["staffid"]);
            param[2] = new SqlParameter("@ProjectId", ts.Project_Id);
            param[3] = new SqlParameter("@ClientId", ts.CLTId);
            //param[4] = new SqlParameter("@JobId", ts.mJob_Id);
            using (SqlDataReader rs = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetDrawingAllocationsbyStaffCode", param))
            {
                while (rs.Read())
                {
                    obj_ts.Add(new vw_DrawingMaster()
                    {
                        DrawingAllocationId = objComm.GetValue<int>(rs["DrawingAlloctionId"].ToString()),
                        DrawingNumber = objComm.GetValue<string>(rs["DrawingNumber"].ToString()),
                        Revision = objComm.GetValue<string>(rs["Revision"].ToString()),
                        EndDate = objComm.GetValue<string>(rs["EndDate"].ToString()),
                    });
                }
            }

            IEnumerable<vw_DrawingMaster> tbl = obj_ts as IEnumerable<vw_DrawingMaster>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }


    [WebMethod(EnableSession = true)]
    public string Get_Planner_Hours(tbl_Planner_JobDetails ts)
    {
        string result = "";
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Planner_JobDetails> obj_ts = new List<tbl_Planner_JobDetails>();
        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@StaffCode", Session["staffid"]);
            param[1] = new SqlParameter("@JobId", ts.jobid);
            param[2] = new SqlParameter("@CompId", Session["companyid"]);
            param[3] = new SqlParameter("@mJob_Id", ts.mJobid);
            param[4] = new SqlParameter("@dt", ts.fDT);
            DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_Hours", param);
            using (SqlDataReader rs = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_Hours", param))
            {
                while (rs.Read())
                {
                    obj_ts.Add(new tbl_Planner_JobDetails()
                    {
                        HrsAllocated = objComm.GetValue<double>(rs["Hours"].ToString()),
                        HrsExtend = objComm.GetValue<string>(rs["HrsExtend"].ToString()),
                        eff = objComm.GetValue<string>(rs["eff"].ToString()),
                        Pln = objComm.GetValue<int>(rs["Pln"].ToString()),
                        Prj_Block = objComm.GetValue<int>(rs["PHrsBlock"].ToString()),
                        todayeff = objComm.GetValue<string>(rs["todayeff"].ToString()),
                        fDT = objComm.GetValue<string>(rs["fromDT"].ToString()),
                        tDT = objComm.GetValue<string>(rs["todate"].ToString()),
                    });
                }
            }
            IEnumerable<tbl_Planner_JobDetails> tbl = obj_ts as IEnumerable<tbl_Planner_JobDetails>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
        }
        return result;
    }

    [WebMethod]
    public string saveDailyTimesheet(timesheet_table ts)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> List_ts = new List<timesheet_table>();
        string resString = "success";
        try
        {
            int i = 0;
            if (ts.Billable == true)
            {
                i = 1;
            }

            SqlParameter[] param = new SqlParameter[14];
            param[0] = new SqlParameter("@StaffCode", ts.StaffCode);
            param[1] = new SqlParameter("@CompId", ts.CompId);
            param[2] = new SqlParameter("@CLTId", ts.CLTId);
            param[3] = new SqlParameter("@Project_Id", ts.Project_Id);
            param[4] = new SqlParameter("@FromTime", ts.FromTime);
            param[5] = new SqlParameter("@ToTime", ts.ToTime);
            param[6] = new SqlParameter("@TotalTime", ts.TotalTime);
            param[7] = new SqlParameter("@Status", ts.Status);
            param[8] = new SqlParameter("@Narration", ts.Narration);
            param[9] = new SqlParameter("@LocId", ts.LocId);
            param[10] = new SqlParameter("@Billable", i);
            param[11] = new SqlParameter("@mJob_Id", ts.mJob_Id);
            param[12] = new SqlParameter("@JobId", ts.JobId);
            param[13] = new SqlParameter("@Date", ts.Date);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_save_DailyTimesheet", param))
            {
                while (drrr.Read())
                {
                    List_ts.Add(new timesheet_table()
                    {
                        //TSId = objComm.GetValue<int>(drrr["id"].ToString()),
                        Status = objComm.GetValue<string>(drrr["Stype"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            resString = "error";
        }
        IEnumerable<timesheet_table> tbl = List_ts as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod]
    public string saveWebDailyTimesheetVersion(timesheet_table ts)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> List_ts = new List<timesheet_table>();
        string resString = "success";
        try
        {
            int i = 0;
            if (ts.Billable == true)
            {
                i = 1;
            }

            int j = 0;
            if (ts.OnSite == true)
            {
                j = 1;
            }
            if (!ts.Task_Id.HasValue)
            {
                ts.Task_Id = 0;
            }

            SqlParameter[] param = new SqlParameter[18];
            param[0] = new SqlParameter("@StaffCode", ts.StaffCode);
            param[1] = new SqlParameter("@CompId", ts.CompId);
            param[2] = new SqlParameter("@CLTId", ts.CLTId);
            param[3] = new SqlParameter("@Project_Id", ts.Project_Id);
            param[4] = new SqlParameter("@FromTime", ts.FromTime);
            param[5] = new SqlParameter("@ToTime", ts.ToTime);
            param[6] = new SqlParameter("@TotalTime", ts.TotalTime);
            param[7] = new SqlParameter("@Status", ts.Status);
            param[8] = new SqlParameter("@Narration", ts.Narration);
            param[9] = new SqlParameter("@LocId", ts.LocId);
            param[10] = new SqlParameter("@Billable", i);
            param[11] = new SqlParameter("@mJob_Id", ts.mJob_Id);
            param[12] = new SqlParameter("@JobId", ts.JobId);
            param[13] = new SqlParameter("@Date", ts.Date);
            param[14] = new SqlParameter("@Expenses", ts.Expenses);
            param[15] = new SqlParameter("@OnSite", j);
            param[16] = new SqlParameter("@DrawingAllocationId", ts.DrawingAllocationId);
            param[17] = new SqlParameter("@TaskId", ts.Task_Id);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_save_WebDailyTimesheet", param))
            {
                while (drrr.Read())
                {
                    List_ts.Add(new timesheet_table()
                    {
                        //TSId = objComm.GetValue<int>(drrr["id"].ToString()),
                        Status = objComm.GetValue<string>(drrr["Stype"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            resString = "error";
        }
        IEnumerable<timesheet_table> tbl = List_ts as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

   [WebMethod(EnableSession=true)]
    public string Project_Blocking( string dt, int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectBlocking> List_DS = new List<tbl_ProjectBlocking>();
        DataSet ds;
        try
        {


            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@dt", dt);
            param[3] = new SqlParameter("@StaffCode", Session["staffid"]);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Timesheet_Project_Blocking", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_ProjectBlocking()
                    {
                        DT = objComm.GetValue<string>(drrr["frdt"].ToString()),
                        Cdt = objComm.GetValue<string>(drrr["cdt"].ToString()),
                    });
                }
            }            

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectBlocking> tbl = List_DS as IEnumerable<tbl_ProjectBlocking>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [System.Web.Http.HttpPost]
    [WebMethod(EnableSession=true)]
    public string InsertUpdateTimeLog(TimeLogs timeLogs)
    {
        CommonFunctions objComm = new CommonFunctions();
        try
        {
            SqlParameter[] param = new SqlParameter[12];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffCode", Session["staffid"]);
            param[2] = new SqlParameter("@id", timeLogs.Id);
            param[3] = new SqlParameter("@EntryDate", timeLogs.EntryDate);
            param[4] = new SqlParameter("@ProjectCode", timeLogs.ProjectCode);
            param[5] = new SqlParameter("@JobId", timeLogs.Jobid);
            param[6] = new SqlParameter("@Billable", timeLogs.Billable);
            param[7] = new SqlParameter("@Narration", timeLogs.Narration);
            param[8] = new SqlParameter("@CheckIn", timeLogs.CheckIn);
            param[9] = new SqlParameter("@CheckOut", timeLogs.CheckOut);
            param[10] = new SqlParameter("@TotalTM", timeLogs.TotalTM);
            param[11] = new SqlParameter("@BrId", timeLogs.BrId);


            var result = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Create_Update_Time_Log", param);
            int logId = 0;
            if (result.HasRows)
            {
                while (result.Read())
                {
                    logId = result.GetInt32(0);
                }
            }
            result.Close();
            return logId.ToString();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod(EnableSession=true)]
    public string GetTimeLog()
    {
        CommonFunctions objComm = new CommonFunctions();
        TimeLogOutput response = new TimeLogOutput();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@staffCode", Session["staffid"]);

            var result = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Time_Log", param);
            while (result.Read())
            {
                response.Id = objComm.GetValue<string>(result["Id"].ToString());
                response.ProjectCode = objComm.GetValue<string>(result["ProjectCode"].ToString());
                response.Jobid = objComm.GetValue<string>(result["JobId"].ToString());
                response.Billable = (bool)result["Billable"]; ;
                response.CheckOut = objComm.GetValue<string>(result["CheckOut"].ToString());
                response.Narration = objComm.GetValue<string>(result["Narration"].ToString());
                response.CurrentTime = objComm.GetValue<string>(result["CurrentTime"].ToString());
                response.DayTime = objComm.GetValue<string>(result["DayTime"].ToString());
                response.WeekTime = objComm.GetValue<string>(result["WeekTime"].ToString());
            }

            return new JavaScriptSerializer().Serialize(response);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod(EnableSession=true)]
    public string Branch(int Cid)
    {
        CommonFunctions objComm = new CommonFunctions();

        DataSet ds;
        try
        {
           //string Session["companyid"] = ob.companyid.ToString();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Timesheet_Branch", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }


}