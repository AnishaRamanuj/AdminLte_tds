<%@ WebService Language="C#" Class="TimesheetViewerDrawing" %>

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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class TimesheetViewerDrawing : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]
    public string GetAlldropdown(int compid, int PageLevel, int staffcode, string staffrole, string SuperAppr, string SubAppr)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_TSViewerdropdwon> List_DS = new List<tbl_TSViewerdropdwon>();
        if (staffrole == "Company-Admin")
        {
            staffrole = "";
            staffcode = 0;
        }
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@pagelevel", PageLevel);
            param[2] = new SqlParameter("@staffcode", staffcode);
            param[3] = new SqlParameter("@staffrole", staffrole);
            param[4] = new SqlParameter("@SuperAppr", SuperAppr);
            param[5] = new SqlParameter("@SubAppr", SubAppr);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DropdownTSViewer_new_Drawing", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_TSViewerdropdwon()
                    {
                        Compid = objComm.GetValue<int>(drrr["Compid"].ToString()),
                    });
                }
                List<Client_Master> listcltMaster = new List<Client_Master>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listcltMaster.Add(new Client_Master()
                            {
                                CLTId = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),

                            });
                        }
                    }
                }
                List<tbl_Project_Details> listProjectMaster = new List<tbl_Project_Details>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listProjectMaster.Add(new tbl_Project_Details()
                            {
                                Cid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                Jid = objComm.GetValue<int>(drrr["JobId"].ToString()),
                                Pid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                                Project = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                            });
                        }
                    }
                }
                List<ProjectWiseBudgeting> listmjobMaster = new List<ProjectWiseBudgeting>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listmjobMaster.Add(new ProjectWiseBudgeting()
                            {
                                jobid = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                                MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                                mjobid = objComm.GetValue<int>(drrr["MJobId"].ToString()),
                            });
                        }
                    }
                }
                List<StaffListDatails> listStaffMaster = new List<StaffListDatails>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listStaffMaster.Add(new StaffListDatails()
                            {
                                id = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                PNAME = objComm.GetValue<string>(drrr["StaffName"].ToString()),

                            });
                        }
                    }
                }
                List<tbl_task_Project> listtaskMaster = new List<tbl_task_Project>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listtaskMaster.Add(new tbl_task_Project()
                            {
                                Task_Id = objComm.GetValue<int>(drrr["TaskId"].ToString()),
                                Task_name = objComm.GetValue<string>(drrr["TaskName"].ToString()),

                            });
                        }
                    }
                }

                List<Department_Master> lstDeptMaster = new List<Department_Master>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            lstDeptMaster.Add(new Department_Master()
                            {
                                CompId = objComm.GetValue<int>(drrr["CompId"].ToString()),
                                DepId = objComm.GetValue<int>(drrr["DepId"].ToString()),
                                DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),

                            });
                        }
                    }
                }

                List<tbl_Drawing> lstDrawingNo = new List<tbl_Drawing>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            lstDrawingNo.Add(new tbl_Drawing()
                            {
                                DrwId = objComm.GetValue<int>(drrr["Drawing_Id"].ToString()),
                                DrawingNo = objComm.GetValue<string>(drrr["DNumber"].ToString())
                            });
                        }
                    }
                }
                foreach (var item in List_DS)
                {
                    item.list_ClientMaster = listcltMaster;
                    item.list_ProjectMaster = listProjectMaster;
                    item.list_MjobMaster = listmjobMaster;
                    item.list_staffMaster = listStaffMaster;
                    item.list_taskMaster = listtaskMaster;
                    item.list_depMaster = lstDeptMaster;
                    item.list_DrawingNoMaster = lstDrawingNo;

                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_TSViewerdropdwon> tbl = List_DS as IEnumerable<tbl_TSViewerdropdwon>;
        var obbbbb = tbl;
        var outputJsonResult = new JavaScriptSerializer();
        outputJsonResult.MaxJsonLength = 10 * 1024 * 1024;
        return outputJsonResult.Serialize(tbl);
    }

    [WebMethod]

    public string bind_timesheets(string compid, string cltid, string projectid, string mjobid, string staffcode, string frtime, string totime, string status, int muti, string drawingId, int Sid, string Staffrole, string ChckMyTS, string deptId, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Timesheets_data> List_DS = new List<tbl_Timesheets_data>();
        DataSet ds;
        try
        {
            string spname = "";
            string result = "";
            if (Staffrole == "Company-Admin")
            {
                Staffrole = "";
                staffcode = "0";
            }
            spname = "usp_Bootstrap_bind_timesheets_new_Drawing";
            //}

            string fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
            string todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[15];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@FromTime", fromdate);
            param[3] = new SqlParameter("@totime", todate);
            param[4] = new SqlParameter("@status", status);
            param[5] = new SqlParameter("@mJid", mjobid);
            param[6] = new SqlParameter("@staffcode", staffcode);
            param[7] = new SqlParameter("@projectid", projectid);
            param[8] = new SqlParameter("@Sid", Sid);
            param[9] = new SqlParameter("@staffrole", Staffrole);
            param[10] = new SqlParameter("@DrawingId", drawingId);
            param[11] = new SqlParameter("@ChckMyTS", ChckMyTS);
            param[12] = new SqlParameter("@deptId", deptId);
            param[13] = new SqlParameter("@pageIndex", pageIndex);
            param[14] = new SqlParameter("@pageSize", pageSize);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, spname, param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod]
    public string PieGraphTSViewer(int compid, int staffcode, string frtime, string totime, int Pagelevel, string Staffrole, string SuperAppr, string SubAppr, string ChckMyTS)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<TSDiagram> List_DS = new List<TSDiagram>();
        string fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
        string todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@fromdt", fromdate);
            param[3] = new SqlParameter("@todt", todate);
            param[4] = new SqlParameter("@pagelevel", Pagelevel);
            param[5] = new SqlParameter("@staffrole", Staffrole);
            param[6] = new SqlParameter("@SuperAppr", SuperAppr);
            param[7] = new SqlParameter("@SubAppr", SubAppr);
            param[8] = new SqlParameter("@ChckMyTS", ChckMyTS);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_TSViewerPie", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new TSDiagram()
                    {
                        Compid = objComm.GetValue<int>(drrr["compid"].ToString()),
                    });
                }

                List<tblThumbLogins> listpie = new List<tblThumbLogins>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listpie.Add(new tblThumbLogins()
                            {
                                status = objComm.GetValue<string>(drrr["status"].ToString()),
                                ttime = objComm.GetValue<string>(drrr["totaltime"].ToString()),

                            });
                        }
                    }
                }
                List<list_weekname> listline = new List<list_weekname>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listline.Add(new list_weekname()
                            {
                                d1week = objComm.GetValue<string>(drrr["d1"].ToString()),
                                d2week = objComm.GetValue<string>(drrr["d2"].ToString()),
                                d3week = objComm.GetValue<string>(drrr["d3"].ToString()),
                                d4week = objComm.GetValue<string>(drrr["d4"].ToString()),
                                d5week = objComm.GetValue<string>(drrr["d5"].ToString()),
                                d6week = objComm.GetValue<string>(drrr["d6"].ToString()),
                                d7week = objComm.GetValue<string>(drrr["d7"].ToString()),
                            });
                        }
                    }
                }
                foreach (var item in List_DS)
                {
                    item.list_Pie = listpie;
                    item.list_line = listline;
                }
            }
        }

        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<TSDiagram> tbl = List_DS as IEnumerable<TSDiagram>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string bind_StaffsummaryData(int compid, string Start, string end, int staffcode, int sid, string Staffrole, int PageLevel, string SuperAppr, string SubAppr, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<list_stff_summary> obj_Job = new List<list_stff_summary>();
        string fromdate = Start != "" ? Convert.ToDateTime(Start, ci).ToString("MM/dd/yyyy") : null;
        string todate = end != "" ? Convert.ToDateTime(end, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[11];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@start", fromdate);
            param[2] = new SqlParameter("@end", todate);
            param[3] = new SqlParameter("@staffcode", staffcode);
            param[4] = new SqlParameter("@sid", sid);
            param[5] = new SqlParameter("@staffrole", Staffrole);
            param[6] = new SqlParameter("@pagelevel", PageLevel);
            param[7] = new SqlParameter("@SuperAppr", SuperAppr);
            param[8] = new SqlParameter("@SubAppr", SubAppr);
            param[9] = new SqlParameter("@pageIndex", pageIndex);
            param[10] = new SqlParameter("@pageSize", pageSize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_StaffSummary_new", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new list_stff_summary()
                    {
                        // srno = objComm.GetValue<int>(drrr["Srno"].ToString()),
                        Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        d1 = objComm.GetValue<string>(drrr["d1"].ToString()),
                        d2 = objComm.GetValue<string>(drrr["d2"].ToString()),
                        d3 = objComm.GetValue<string>(drrr["d3"].ToString()),
                        d4 = objComm.GetValue<string>(drrr["d4"].ToString()),
                        d5 = objComm.GetValue<string>(drrr["d5"].ToString()),
                        d6 = objComm.GetValue<string>(drrr["d6"].ToString()),
                        d7 = objComm.GetValue<string>(drrr["d7"].ToString()),
                        Total = objComm.GetValue<string>(drrr["Total"].ToString()),
                        TotalCount = objComm.GetValue<string>(drrr["TotalCount"].ToString()),
                        SrNo = objComm.GetValue<string>(drrr["SrNo"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<list_stff_summary> tbl = obj_Job as IEnumerable<list_stff_summary>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod]
    public string bind_Approver_TimesheetNotSubmitted(int compid, string Start, string end, int staffcode, int sid, string Staffrole, string wk, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<list_stff_summary> obj_Job = new List<list_stff_summary>();
        string fromdate = Start != "" ? Convert.ToDateTime(Start, ci).ToString("MM/dd/yyyy") : null;
        string todate = end != "" ? Convert.ToDateTime(end, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@start", fromdate);
            param[2] = new SqlParameter("@end", todate);
            param[3] = new SqlParameter("@staffcode", staffcode);
            param[4] = new SqlParameter("@sid", sid);
            param[5] = new SqlParameter("@staffrole", Staffrole);
            param[6] = new SqlParameter("@wk", wk);
            param[7] = new SqlParameter("@pageIndex", pageIndex);
            param[8] = new SqlParameter("@pageSize", pageSize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_TimeSheetNotSubmitted_new", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new list_stff_summary()
                    {
                        staffcode = objComm.GetValue<string>(drrr["staffcode"].ToString()),
                        staffemail = objComm.GetValue<string>(drrr["staffemail"].ToString()),
                        Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        d1 = objComm.GetValue<string>(drrr["d1"].ToString()),
                        d2 = objComm.GetValue<string>(drrr["d2"].ToString()),
                        d3 = objComm.GetValue<string>(drrr["d3"].ToString()),
                        d4 = objComm.GetValue<string>(drrr["d4"].ToString()),
                        d5 = objComm.GetValue<string>(drrr["d5"].ToString()),
                        d6 = objComm.GetValue<string>(drrr["d6"].ToString()),
                        d7 = objComm.GetValue<string>(drrr["d7"].ToString()),
                        Total = objComm.GetValue<string>(drrr["Total"].ToString()),
                        srno = objComm.GetValue<int>(drrr["Totwek"].ToString()),
                        TotalCount = objComm.GetValue<string>(drrr["TotalCount"].ToString()),
                        SlNo = objComm.GetValue<string>(drrr["SrNo"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<list_stff_summary> tbl = obj_Job as IEnumerable<list_stff_summary>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod]
    public string bind_MinimumHrs(int compid, string Start, string end, int staffcode, string staff_role, int sid, int PageLevel, string SuperAppr, string SubAppr, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<MinimumHrs> obj_Job = new List<MinimumHrs>();
        try
        {
            string pram = "";
            if (staffcode == 0)
            {
                pram = "usp_Bootstrap_Minimum_Hours_report_new";
            }
            else
            {
                if (PageLevel > 2)
                {
                    pram = "usp_Bootstrap_3Approverstaff_Minimum_Hours_report_new";
                }
                else
                {
                    pram = "usp_Bootstrap_2Approverstaff_Minimum_Hours_report_new";
                }

            }
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[10];
            param[0] = new SqlParameter("@companyId", compid);
            param[1] = new SqlParameter("@from_date", Convert.ToDateTime(Start, ci));
            param[2] = new SqlParameter("@to_date", Convert.ToDateTime(end, ci));
            param[3] = new SqlParameter("@Sid", sid);
            param[4] = new SqlParameter("@staffcode", staffcode);
            param[5] = new SqlParameter("@staff_role", staff_role);
            param[6] = new SqlParameter("@SuperAppr", SuperAppr);
            param[7] = new SqlParameter("@SubAppr", SubAppr);
            param[8] = new SqlParameter("@pageIndex", pageIndex);
            param[9] = new SqlParameter("@pageSize", pageSize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, pram, param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new MinimumHrs()
                    {
                        srno = objComm.GetValue<int>(drrr["SrNo"].ToString()),
                        Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Deptname = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        DesignName = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        Tdate = objComm.GetValue<string>(drrr["Tdate"].ToString()),
                        totaltm = objComm.GetValue<string>(drrr["TotalTime"].ToString()),
                        hors = objComm.GetValue<string>(drrr["Minimum_Hours"].ToString()),
                        diff = objComm.GetValue<string>(drrr["Difference"].ToString()),
                        TotalCount = objComm.GetValue<string>(drrr["TotalCount"].ToString()),
                        SlNo = objComm.GetValue<string>(drrr["SrNo"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<MinimumHrs> tbl = obj_Job as IEnumerable<MinimumHrs>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod]
    public string Update_Approve_Reject(timesheet_table ts)
    {
        string result = "";
        string procname = "";
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> obj_ts = new List<timesheet_table>();
        try
        {
            if (ts.Satffstatus == "True")
            {
                procname = "usp_Bootstrap_Approver_DualTimesheet_Deptwise";
            }
            else
            {
                procname = "usp_Bootstrap_Approver_Timesheet_Deptwise";
            }
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", ts.CompId);
            param[1] = new SqlParameter("@staffcode", ts.JobApprover);
            param[2] = new SqlParameter("@sts", ts.Status);
            param[3] = new SqlParameter("@Tsid", ts.Timesheets);
            param[4] = new SqlParameter("@ApprovedPattern", ts.ApprovedPattern);

            using (SqlDataReader rs = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, procname, param))
            {

                while (rs.Read())
                {
                    obj_ts.Add(new timesheet_table()
                    {
                        TSId = objComm.GetValue<int>(rs["tsid"].ToString()),
                    });
                }
            }
            IEnumerable<timesheet_table> tbl = obj_ts as IEnumerable<timesheet_table>;
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
    public string UpdateTimehseet(int compid, int TSID, string FrTim, string ToTim, string Totalime, string Narr)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<ProjectWiseBudgeting> List_DS = new List<ProjectWiseBudgeting>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@TSID", TSID);
            param[2] = new SqlParameter("@FrTim", FrTim);
            param[3] = new SqlParameter("@ToTim", ToTim);
            param[4] = new SqlParameter("@Totalime", Totalime);
            param[5] = new SqlParameter("@Narr", Narr);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpdateTimehseet2level", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new ProjectWiseBudgeting()
                    {
                        mjobid = objComm.GetValue<int>(drrr["TSID"].ToString()),
                    });
                }
            }
        }

        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<ProjectWiseBudgeting> tbl = List_DS as IEnumerable<ProjectWiseBudgeting>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetLeaveDate(timesheet_table ts)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> List_ts = new List<timesheet_table>();

        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@CompId", ts.CompId);
            param[1] = new SqlParameter("@Fr", ts.FromDT);
            param[2] = new SqlParameter("@To", ts.ToDT);
            param[3] = new SqlParameter("@Staffcode", ts.StaffCode);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_TimesheetLeaveSlab", param))
            {
                while (drrr.Read())
                {
                    List_ts.Add(new timesheet_table()
                    {
                        Date1 = objComm.GetValue<string>(drrr["AllDates"].ToString()),
                        FromDT = objComm.GetValue<string>(drrr["Start_Dt"].ToString()),
                        ToDT = objComm.GetValue<string>(drrr["End_Dt"].ToString()),
                        Halftype = objComm.GetValue<string>(drrr["Half_type"].ToString()),
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
}