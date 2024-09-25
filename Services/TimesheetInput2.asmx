<%@ WebService Language="C#" Class="TimesheetInput2" %>

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
using System.Globalization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class TimesheetInput2  : System.Web.Services.WebService {
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]
    public string getTimesheetDetails(int compid, int staffcode, int pnc, string cdt)
    {
        string result = "";
        string procname = "";

        if (pnc == 0)
        {
            procname = "usp_Bootstrap_Timesheet_Details_2Level";
        }
        else
        {
            procname = "usp_Bootstrap_Timesheet_Details_2Level_Job";
        }
        CommonFunctions objComm = new CommonFunctions();
        List<TimesheetInput_2Level> obj_ts = new List<TimesheetInput_2Level>();
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@cdt", cdt);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, procname, param))
            {
                if (procname == "usp_Bootstrap_Timesheet_Details_2Level")
                {
                    while (drrr.Read())
                    {
                        obj_ts.Add(new TimesheetInput_2Level()
                        {
                            TotalHrs = objComm.GetValue<string>(drrr["TotalHrs"].ToString()),
                            Billable = objComm.GetValue<string>(drrr["Billable"].ToString()),
                            NonBillable = objComm.GetValue<string>(drrr["NonBillable"].ToString()),
                            DOJ = objComm.GetValue<DateTime>(drrr["DateOfJoining"].ToString()),
                            DOL = objComm.GetValue<DateTime>(drrr["DateOfLeaving"].ToString()),
                        });
                    }
                    List<ClientnJobs_2Level> list_CJ = new List<ClientnJobs_2Level>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                list_CJ.Add(new ClientnJobs_2Level()
                                {
                                    Jid = objComm.GetValue<int>(drrr["JobId"].ToString()),
                                    Cid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                    Client = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                                    mJid = objComm.GetValue<int>(drrr["mJobID"].ToString()),
                                    mJob = objComm.GetValue<string>(drrr["mJobName"].ToString()),
                                    StarDt = objComm.GetValue<DateTime>(drrr["CreationDate"].ToString()),
                                    EndDt = objComm.GetValue<DateTime>(drrr["ActualJobEndate"].ToString()),
                                    JStatus = objComm.GetValue<string>(drrr["Billable"].ToString()),
                                    Billable = objComm.GetValue<string>(drrr["JobStatus"].ToString()),
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
                        item.list_CnJ = list_CJ;
                        item.list_UnfreezedDates = list_UnfreezedDates;
                    }
                }


                else if (procname == "usp_Bootstrap_Timesheet_Details_2Level_Job")
                {
                    while (drrr.Read())
                    {
                        obj_ts.Add(new TimesheetInput_2Level()
                        {
                            TotalHrs = objComm.GetValue<string>(drrr["TotalHrs"].ToString()),
                            Billable = objComm.GetValue<string>(drrr["Billable"].ToString()),
                            NonBillable = objComm.GetValue<string>(drrr["NonBillable"].ToString()),
                            DOJ = objComm.GetValue<DateTime>(drrr["DateOfJoining"].ToString()),
                            DOL = objComm.GetValue<DateTime>(drrr["DateOfLeaving"].ToString()),
                        });
                    }
                    List<tbl_Client> list_CJ = new List<tbl_Client>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                list_CJ.Add(new tbl_Client()
                                {

                                    Cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                    Clientname = objComm.GetValue<string>(drrr["ClientName"].ToString()),

                                });
                            }
                        }
                    }

                    List<tbl_JobName> list_Jb = new List<tbl_JobName>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                list_Jb.Add(new tbl_JobName()
                                {

                                    mjobid = objComm.GetValue<int>(drrr["mJobID"].ToString()),
                                    mjobName = objComm.GetValue<string>(drrr["mJobName"].ToString()),
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
                        item.list_mJ = list_Jb;
                        item.list_Cl = list_CJ;
                        item.list_UnfreezedDates = list_UnfreezedDates;
                    }

                }
            }
            IEnumerable<TimesheetInput_2Level> tbl = obj_ts as IEnumerable<TimesheetInput_2Level>;
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
    public string getTimesheetDetails_withoutJob(int compid, int staffcode)
    {
        string result = "";
        string procname = "";
        procname = "usp_Bootstrap_Timesheet_Details_2Level_Job";

        CommonFunctions objComm = new CommonFunctions();
        List<TimesheetInput_2Level> obj_ts = new List<TimesheetInput_2Level>();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, procname, param))
            {

                while (drrr.Read())
                {
                    obj_ts.Add(new TimesheetInput_2Level()
                    {
                        TotalHrs = objComm.GetValue<string>(drrr["TotalHrs"].ToString()),
                        Billable = objComm.GetValue<string>(drrr["Billable"].ToString()),
                        NonBillable = objComm.GetValue<string>(drrr["NonBillable"].ToString()),
                        DOJ = objComm.GetValue<DateTime>(drrr["DateOfJoining"].ToString()),
                        DOL = objComm.GetValue<DateTime>(drrr["DateOfLeaving"].ToString()),
                    });
                }
                List<tbl_Client> list_CJ = new List<tbl_Client>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            list_CJ.Add(new tbl_Client()
                            {

                                Cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                Clientname = objComm.GetValue<string>(drrr["ClientName"].ToString()),

                            });
                        }
                    }
                }

                List<tbl_JobName> list_Jb = new List<tbl_JobName>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            list_Jb.Add(new tbl_JobName()
                            {

                                mjobid = objComm.GetValue<int>(drrr["mJobID"].ToString()),
                                mjobName = objComm.GetValue<string>(drrr["mJobName"].ToString()),
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
                    item.list_mJ = list_Jb;
                    item.list_Cl= list_CJ;
                    item.list_UnfreezedDates = list_UnfreezedDates;
                }
            }

            IEnumerable<TimesheetInput_2Level> tbl = obj_ts as IEnumerable<TimesheetInput_2Level>;
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
    public string getTimesheetsofSelectedWeek(DateTime startdate, DateTime enddate, int staffcode, int compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> tsList = new List<timesheet_table>();
        string result = "";
        try
        {

            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@startdate", startdate);
            param[1] = new SqlParameter("@enddate", enddate);
            param[2] = new SqlParameter("@staffcode", staffcode);
            param[3] = new SqlParameter("@compid", compid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_BootStrap_TimesheetsofSelectedWeek_2Level", param))
            {

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
                        //Project_Id = objComm.GetValue<int>(drrr["Project_Id"].ToString()),
                        //Assign_Id = objComm.GetValue<int>(drrr["Assign_Id"].ToString()),
                        mJob_Id = objComm.GetValue<int>(drrr["mJob_Id"].ToString()),
                        Dept_Id = objComm.GetValue<int>(drrr["Dept_Id"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        //ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        Narration = objComm.GetValue<string>(drrr["Narration"].ToString()),
                        //TaskName = objComm.GetValue<string>(drrr["TaskName"].ToString()),
                        Billable = objComm.GetValue<bool>(drrr["Billable"].ToString()),
                        Reason = objComm.GetValue<string>(drrr["Reason"].ToString()),
                    });
                }
            }
            IEnumerable<timesheet_table> tbl = tsList as IEnumerable<timesheet_table>;

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
    public string SaveTimesheets_2level(timesheet_table ts)
    {

        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> List_ts = new List<timesheet_table>();

        try
        {
            //string s= ts.Expenses.Remove(0,2); 
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@StaffCode", ts.StaffCode);
            param[1] = new SqlParameter("@CompId", ts.CompId);
            param[2] = new SqlParameter("@Sts", ts.Status);
            param[3] = new SqlParameter("@Timesheets", ts.Timesheets);
            param[4] = new SqlParameter("@Expenses", ts.Expenses.TrimStart('^'));

            //var TSID = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_saveMultipleTimesheets", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_SaveTimesheets_2Level", param))
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
    public string saveeditSaveTimesheetInput(timesheet_table ts)
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
			
			using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Edit_Timesheets_2Level", param))
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
			
            //var TSID = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Edit_Timesheets_2Level", param);
            //if (TSID > 0)
            //{ resString = "success"; }
            //else { resString = "error"; }
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
    public string PieGraphTSViewer(int compid, int staffcode, string frdt, string todt)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tblThumbLogins> List_DS = new List<tblThumbLogins>();
        string fromdate = frdt != "" ? Convert.ToDateTime(frdt, ci).ToString("MM/dd/yyyy") : null;
        string todate = todt != "" ? Convert.ToDateTime(todt, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            //Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@fromdt", fromdate);
            param[3] = new SqlParameter("@todt", todate);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Timesheet_2LevelPie", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tblThumbLogins()
                    {
                        status = objComm.GetValue<string>(drrr["status"].ToString()),
                        ttime = objComm.GetValue<string>(drrr["totaltime"].ToString()),
                    });
                }
            }
        }

        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tblThumbLogins> tbl = List_DS as IEnumerable<tblThumbLogins>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string getExpenseAgainst_TSID(int TSID, int staffcode, int compid)
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
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_getExpenseagainst_TSID", param))
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
    public string SaveExpenseAgainst_TSID(int compid, int staffcode, int TSId, string Expenses)
    {
        string res = "";
        try
        {
            CommonFunctions objComm = new CommonFunctions();


            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@staffcode", staffcode);
            param[1] = new SqlParameter("@TSID",  TSId);
            param[2] = new SqlParameter("@compid", compid);
            param[3] = new SqlParameter("@Expenses", Expenses);
            var TSsID = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_SaveExpenseAgainst_TSID", param);
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


}