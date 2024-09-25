<%@ WebService Language="C#" Class="wsTimeSheetInput2" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Data.SqlClient;
using CommonLibrary;
using System.Data;
using Microsoft.ApplicationBlocks.Data;
using System.Web.Script.Serialization;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class wsTimeSheetInput2  : System.Web.Services.WebService {

    [WebMethod]
    public string getTimesheetInpurtrelatedDetails(int compid, int staffcode, string inputType)
    {
        string result = "";
        string procname = "";
        if (inputType == "deptwise")
        { procname = "usp_getTimesheetInpurtrelatedDetails"; }
        else if (inputType == "taskwise")
        { procname = "usp_getTimesheetInpurtrelatedDetails_taskwise"; }
        else if (inputType == "")
        { procname = "usp_getTimesheetInpurtrelatedDetails_notypedefine"; }
        CommonFunctions objComm = new CommonFunctions();
        List<TimesheetInputDepartmentWise> obj_ts = new List<TimesheetInputDepartmentWise>();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, procname, param);
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
                                    ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                                    Project_Hours = objComm.GetValue<string>(drrr["Project_Hours"].ToString()),
                                    Project_Amount = objComm.GetValue<string>(drrr["Project_Amount"].ToString()),
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
                if (procname == "usp_getTimesheetInpurtrelatedDetails_taskwise")
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
                                    ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                                    ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                                    MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                                    SuperApprover = objComm.GetValue<string>(drrr["SuperApprover"].ToString()),
                                    Approvers = objComm.GetValue<string>(drrr["Approvers"].ToString())
                                });
                            }
                        }
                    }

                    List<Tbl_Job_Task_Master> listtask = new List<Tbl_Job_Task_Master>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listtask.Add(new Tbl_Job_Task_Master()
                                {
                                    JobId = objComm.GetValue<int>(drrr["JobId"].ToString()),
                                    TaskId = objComm.GetValue<int>(drrr["TaskId"].ToString()),
                                    TaskName = objComm.GetValue<string>(drrr["TaskName"].ToString()),
                                });
                            }
                        }
                    }

                    foreach (var item in obj_ts)
                    {
                        item.list_job_task = listtask;
                        item.list_job_master_ts = listmaster_ts;
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
                                    ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                                    ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                                    MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
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

            IEnumerable<TimesheetInputDepartmentWise> tbl = obj_ts as IEnumerable<TimesheetInputDepartmentWise>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }

    [WebMethod]
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

                /////DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_saveTSinput", param);
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

    [WebMethod]
    public string SaveMultipleTimesheets(timesheet_table ts)
    {

        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> List_ts = new List<timesheet_table>();

        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@StaffCode", ts.StaffCode);
            param[1] = new SqlParameter("@CompId", ts.CompId);
            param[2] = new SqlParameter("@Sts", ts.Status);
            param[3] = new SqlParameter("@Timesheets", ts.Timesheets);


            //var TSID = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_saveMultipleTimesheets", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_saveMultipleTimesheets", param))
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
            throw ex;
        }
        IEnumerable<timesheet_table> tbl = List_ts as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod]
    public string GetHolidays(timesheet_table ts)
    {

        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> List_ts = new List<timesheet_table>();

        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@CompId", ts.CompId);
            param[1] = new SqlParameter("@Fr", ts.FromDT);
            param[2] = new SqlParameter("@To", ts.ToDT);

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
            throw ex;
        }
        IEnumerable<timesheet_table> tbl = List_ts as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod]
    public string getTimesheetsofSelectedWeek(DateTime startdate, DateTime enddate, int staffcode, int compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> tsList = new List<timesheet_table>();
        SqlParameter[] param = new SqlParameter[12];
        param[0] = new SqlParameter("@startdate", startdate);
        param[1] = new SqlParameter("@enddate", enddate);
        param[2] = new SqlParameter("@staffcode", staffcode);
        param[3] = new SqlParameter("@compid", compid);
        //DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_getTimesheetsofSelectedWeek", param);
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
                    Date = objComm.GetValue<DateTime>(drrr["Date"].ToString()),
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
                    Billable = objComm.GetValue<bool>(drrr["Billable"].ToString())
                });
            }
        }

        return new JavaScriptSerializer().Serialize(tsList as IEnumerable<timesheet_table>);
    }

    [WebMethod]
    public string deletesavedTimesheet(int TSID, int staffcode, int compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        SqlParameter[] param = new SqlParameter[3];
        param[0] = new SqlParameter("@TSID", TSID);
        param[1] = new SqlParameter("@staffcode", staffcode);
        param[2] = new SqlParameter("@compid", compid);
        var res = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_deletesavedTimesheet", param);
        if (res > 0)
        { return "success"; }
        else { return "error"; }
    }

    [WebMethod]
    public string saveeditSaveTimesheetInput(timesheet_table ts)
    {

        CommonFunctions objComm = new CommonFunctions();
        string resString = "success";
        try
        {
            int i = 0;
            if (ts.Billable == true)
            {
                i = 1;
            }

            SqlParameter[] param = new SqlParameter[10];
            param[0] = new SqlParameter("@StaffCode", ts.StaffCode);
            param[1] = new SqlParameter("@CompId", ts.CompId);
            param[2] = new SqlParameter("@FromTime", ts.FromTime);
            param[3] = new SqlParameter("@ToTime", ts.ToTime);
            param[4] = new SqlParameter("@TotalTime", ts.TotalTime);
            param[5] = new SqlParameter("@TSId", ts.TSId);
            param[6] = new SqlParameter("@Status", ts.Status);
            param[7] = new SqlParameter("@Narration", ts.Narration);
            param[8] = new SqlParameter("@LocId", ts.LocId);
            param[9] = new SqlParameter("@Billable", i);
            var TSID = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_saveeditSaveTimesheetInput_Billable", param);
            if (TSID > 0)
            { resString = "success"; }
            else { resString = "error"; }
        }
        catch (Exception ex)
        {
            resString = "error";
        }
        return resString;
    }

    [WebMethod]
    public string getExpenseagiainsTSID(int TSID, int staffcode, int compid)
    {
        string resString = "";
        CommonFunctions objComm = new CommonFunctions();
        List<ExpenseTs> obj_ts = new List<ExpenseTs>();
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@TSID", TSID);
            param[1] = new SqlParameter("@Compid", compid);
            param[2] = new SqlParameter("@StaffCode", staffcode);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_getExpenseagiainsTSID", param))
            {
                while (drrr.Read())
                {
                    obj_ts.Add(new ExpenseTs()
                    {
                        ExpId = objComm.GetValue<int>(drrr["ExpId"].ToString()),
                        ExpNarration = objComm.GetValue<string>(drrr["ExpNarration"].ToString()),
                        TSId = objComm.GetValue<int>(drrr["TSId"].ToString()),
                        Amt = objComm.GetValue<float>(drrr["Amt"].ToString()),
                        ExpName = objComm.GetValue<string>(drrr["OPEName"].ToString()),
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


    [WebMethod]
    public string saveExpenseagiainsTSID(int TSID, int staffcode, int compid, List<ExpenseTs> ts)
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
                dt.Rows.Add(dr);
            }
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@staffcode", staffcode);
            param[1] = new SqlParameter("@TSID", TSID);
            param[2] = new SqlParameter("@compid", compid);
            param[3] = new SqlParameter("@dt", dt);
            var TSsID = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_saveExpenseagiainsTSID_New", param);
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

    [WebMethod]
    public string SubmitSavedTiemsheets(string TSIDS, int staffcode, int compid)
    {
        string res = "";
        try
        {
            CommonFunctions objComm = new CommonFunctions();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@TSIDS", TSIDS);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@compid", compid);
            var TSsID = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_SubmitSavedTiemsheets", param);
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


    [WebMethod]
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

    
}