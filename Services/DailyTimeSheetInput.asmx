<%@ WebService Language="C#" Class="DailyTimeSheetInput" %>

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
using Newtonsoft.Json;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class DailyTimeSheetInput : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");



    [WebMethod]
    public string GetSingleClientProjectInputHeader(string CLTId, string ProjectID)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_InputsSummaryHeader> obj_Job = new List<vw_InputsSummaryHeader>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@CLTId", CLTId);
            param[1] = new SqlParameter("@ProjectID", ProjectID);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GETProjectSummaryDetail", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_InputsSummaryHeader()
                    {

                        CLTId = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                        ProjectID = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        DeptName = objComm.GetValue<string>(drrr["Department_Name"].ToString()),
                        ScopeOfWork = objComm.GetValue<string>(drrr["ProductLine"].ToString()),
                        BudgetHours = objComm.GetValue<string>(drrr["BudgetHours"].ToString()),
                        TotalBilledHours = objComm.GetValue<string>(drrr["BillableHours"].ToString()),
                        ConsumePercentage = objComm.GetValue<double>(drrr["Percentage_Consume"].ToString()),
                        ProjectHours = objComm.GetValue<double>(drrr["Project_Hours"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_InputsSummaryHeader> tbl = obj_Job as IEnumerable<vw_InputsSummaryHeader>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    [WebMethod]
    public string Bind_DrpClient(int compid, int staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<InputSummaryClient> obj_Job = new List<InputSummaryClient>();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            using (SqlDataReader dr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_getClientByStaffCode", param))
            {
                while (dr.Read())
                {
                    obj_Job.Add(new InputSummaryClient()
                    {
                        ClientID = objComm.GetValue<int>(dr["ClientId"].ToString()),
                        ClientName = objComm.GetValue<string>(dr["ClientName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<InputSummaryClient> tbl = obj_Job as IEnumerable<InputSummaryClient>;
        var obbbbb = tbl;
        return JsonConvert.SerializeObject(tbl);
    }
    [WebMethod(enableSession: true)]
    public string GetEmpDAYWeeklWiseEffort(string searchDate, string PrjId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DailyTimesheetInputEffort obj_Job = new DailyTimesheetInputEffort();
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@dt", searchDate);
            param[1] = new SqlParameter("@staffcode", Session["staffid"]);
            param[2] = new SqlParameter("@compid", Session["companyid"]);
            param[3] = new SqlParameter("@PrjId", PrjId);
            using (SqlDataReader dr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetEmpDAYWeeklWiseEffort", param))
            {
                while (dr.Read())
                {
                    obj_Job.DayEffort = objComm.GetValue<string>(dr["DayEffort"].ToString());
                    obj_Job.WeekEffort = objComm.GetValue<string>(dr["WeekEffort"].ToString());
                    obj_Job.TotalEffort = objComm.GetValue<string>(dr["TotalEffort"].ToString());

                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return JsonConvert.SerializeObject(obj_Job);
    }


    [WebMethod]
    public string Bind_DrpProject(int clientId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Alloc_Project> obj_Job = new List<tbl_Alloc_Project>();
        try
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@clientId", clientId) };
            using (SqlDataReader dr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_DailyTSInput_GetProjectData", param))
            {
                while (dr.Read())
                {
                    obj_Job.Add(new tbl_Alloc_Project()
                    {
                        Projid = objComm.GetValue<int>(dr["ProjectID"].ToString()),
                        Projectname = objComm.GetValue<string>(dr["ProjectName"].ToString()),
                        enddate = objComm.GetValue<string>(dr["EndDate"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Alloc_Project> tbl = obj_Job as IEnumerable<tbl_Alloc_Project>;
        var obbbbb = tbl;
        return JsonConvert.SerializeObject(tbl);
    }


    [WebMethod]
    public string InsertUpdateInputSummary(int CompId, int InputID, int ClientId, int ProjectId, string receivedStrDate, string receivedInput, string TaskSummary, string SubmissionMade)
    {


        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_InputsSummary> obj_Job = new List<vw_InputsSummary>();
        try
        {
            string receivedDate = receivedStrDate != "" ? Convert.ToDateTime(receivedStrDate, ci).ToString("MM/dd/yyyy") : null;
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@InputId", InputID);
            param[1] = new SqlParameter("@CLTId", ClientId);
            param[2] = new SqlParameter("@ProjectId", ProjectId);
            param[3] = new SqlParameter("@ReceivedDate", receivedDate);
            param[4] = new SqlParameter("@ReceivedInput", receivedInput);
            param[5] = new SqlParameter("@TaskSummary", TaskSummary);
            param[6] = new SqlParameter("@SubmissionMade", SubmissionMade);
            param[7] = new SqlParameter("@CompId", CompId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateInputSummary", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_InputsSummary()
                    {
                        InputId = objComm.GetValue<int>(drrr["InputId"].ToString())

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_InputsSummary> tbl = obj_Job as IEnumerable<vw_InputsSummary>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string GetClientDrp(string compid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Client> obj_Job = new List<tbl_Client>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetClientData", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_Client()
                    {

                        Cltid = objComm.GetValue<int>(drrr["ClientId"].ToString()),
                        Clientname = objComm.GetValue<string>(drrr["ClientName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Client> tbl = obj_Job as IEnumerable<tbl_Client>;
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
        using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Daily_getTimesheetsofSelectedWeek_new", param))
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
                    Task_Id = objComm.GetValue<int>(drrr["Task_Id"].ToString()),
                    Dept_Id = objComm.GetValue<int>(drrr["Dept_Id"].ToString()),
                    ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                    ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                    MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                    Narration = objComm.GetValue<string>(drrr["Narration"].ToString()),
                    TaskName = objComm.GetValue<string>(drrr["TaskName"].ToString()),
                    Billable = objComm.GetValue<bool>(drrr["Billable"].ToString()),
                    Reason = objComm.GetValue<string>(drrr["Reason"].ToString()),
                    DrawingAllocationId = objComm.GetValue<int>(drrr["DrawingAllocationId"].ToString()),
                    SubTaskName = objComm.GetValue<string>(drrr["SubTaskName"].ToString()),
                    AreaName = objComm.GetValue<string>(drrr["AreaName"].ToString()),
                    OrChange = objComm.GetValue<int>(drrr["OrChange"].ToString()),
                });
            }
        }
        return new JavaScriptSerializer().Serialize(tsList as IEnumerable<timesheet_table>);
    }

    [WebMethod(EnableSession = true)]
    public string TimeSheetAttendenceMark(string currentstatus, string location, int staffcode, int ProjectId, int CltId, int JobId, int mJobId, int TSEntryId, string TotalTime, string ClockTime)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<StaffAttendanceLog> List_ML = new List<StaffAttendanceLog>();

        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[13];
                param[0] = new SqlParameter("@TSEntryId", TSEntryId);
                param[1] = new SqlParameter("@compid", Session["companyid"]);
                param[2] = new SqlParameter("@staffcode", staffcode);
                param[3] = new SqlParameter("@CurrentStatus", currentstatus);
                param[4] = new SqlParameter("@empLocation", location);
                param[5] = new SqlParameter("@TotalTime", TotalTime);
                param[6] = new SqlParameter("@ClockTime", ClockTime);
                param[7] = new SqlParameter("@DeviceInfo", HttpContext.Current.Request.Headers["User-Agent"].ToString());
                param[8] = new SqlParameter("@IsMobileDevice", Convert.ToBoolean(HttpContext.Current.Request.Browser["IsMobileDevice"]));
                param[9] = new SqlParameter("@ProjectId", ProjectId);
                param[10] = new SqlParameter("@CltId", CltId);
                param[11] = new SqlParameter("@JobId", JobId);
                param[12] = new SqlParameter("@mJobId", mJobId);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_StaffTS_AttendenceMark", param))
                {
                    while (drrr.Read())
                    {
                        List_ML.Add(new StaffAttendanceLog()
                        {
                            CompId = objComm.GetValue<int>(drrr["compid"].ToString()),

                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<StaffAttendanceLog> tbl = List_ML as IEnumerable<StaffAttendanceLog>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public List<AllTimesheetModel> GetTSEntryLog(int TSEntryId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        try
        {
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@TSEntryId", TSEntryId);

            SqlDataReader dr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "[usp_GetTSEntryLog]", param);

            List<AllTimesheetModel> list = new List<AllTimesheetModel>();
            while (dr.Read())
            {
                list.Add(new AllTimesheetModel()
                {

                    TSEntryId = objComm.GetValue<int>(dr["TSEntryId"].ToString()),

                    CLTId = objComm.GetValue<string>(dr["CLTId"].ToString()),

                    mJobId = objComm.GetValue<string>(dr["mjobId"].ToString()),

                    JobId = objComm.GetValue<string>(dr["JobId"].ToString()),

                    PID = objComm.GetValue<int>(dr["ProjectId"].ToString()),

                    staffcode = objComm.GetValue<string>(dr["staffcode"].ToString()),

                });

            }
            return list;
        }
        catch (Exception ex)
        {
            return null;
        }

    }

    [WebMethod(EnableSession = true)]
    public string GetAreaProjDetails(int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {

            Common ob = new Common();
            string _Compid = ob.companyid.ToString();


            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@Pid", Pid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Area_Task", param);


        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession = true)]
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

            SqlParameter[] param = new SqlParameter[21];
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
            param[18] = new SqlParameter("@AreaId", ts.AreaId);
            param[19] = new SqlParameter("@OrChange", ts.OrChange);
            param[20] = new SqlParameter("@SUbTKid", ts.SUbTKid);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_save_EDCDailyTimesheet", param))
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
            throw ex;
            resString = "error";
        }
        IEnumerable<timesheet_table> tbl = List_ts as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
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

                SqlParameter[] param = new SqlParameter[22];
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
                param[13] = new SqlParameter("@ClientID", ts.CLTId);
                param[14] = new SqlParameter("@ProjectID", ts.Project_Id);
                param[15] = new SqlParameter("@TaskID", ts.Task_Id);
                param[16] = new SqlParameter("@AssignID", ts.Assign_Id);
                param[17] = new SqlParameter("@JID", ts.JobId);
                param[18] = new SqlParameter("@PageName", ts.PageName);
                param[19] = new SqlParameter("@AreaId", ts.AreaId);
                param[20] = new SqlParameter("@OrChange", ts.OrChange);
                param[21] = new SqlParameter("@SUbTKid", ts.SUbTKid);
                //var TSID = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_saveeditSaveTimesheetInput_Billable_new", param);
                //DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_save_editedTimesheet", param);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Daily_save_editedTimesheet", param))
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
            throw ex;
            resString = "error";
            return resString;
        }
        IEnumerable<timesheet_table> tbl = List_ts as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
}