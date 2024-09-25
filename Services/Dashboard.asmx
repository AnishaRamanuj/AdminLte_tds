<%@ WebService Language="C#" Class="Dashboard" %>

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
public class Dashboard : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");


    [WebMethod(EnableSession = true)]
    public string PieGraphTSViewer(string frdt, string todt, int Pagelevel, int Deptwise)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Timesheet_Pie> List_DS = new List<Timesheet_Pie>();
        string fromdate = frdt != "" ? Convert.ToDateTime(frdt, ci).ToString("MM/dd/yyyy") : null;
        string todate = todt != "" ? Convert.ToDateTime(todt, ci).ToString("MM/dd/yyyy") : null;
        DataSet ds;
        try
        {
            //Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@PageLevel", Pagelevel);
            param[2] = new SqlParameter("@fromdt", fromdate);
            param[3] = new SqlParameter("@todt", todate);
            param[4] = new SqlParameter("@deptwise", Deptwise);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Dashboard1", param);
            //using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Dashboard", param))
            //{
            //    while (drrr.Read())
            //    {
            //        List_DS.Add(new Timesheet_Pie()
            //        {
            //            status = objComm.GetValue<string>(drrr["Tstatus"].ToString()),
            //            ttime = objComm.GetValue<string>(drrr["Tcount"].ToString()),
            //        });
            //    }

            //    List<Dashboard_Charts> list_CJ = new List<Dashboard_Charts>();

            //    if (drrr.NextResult())
            //    {
            //        if (drrr.HasRows)
            //        {
            //            while (drrr.Read())
            //            {
            //                list_CJ.Add(new Dashboard_Charts()
            //                {
            //                    TotalHours = objComm.GetValue<string>(drrr["TotalHours"].ToString()),
            //                    Billable = objComm.GetValue<string>(drrr["Billable"].ToString()),
            //                    NonBillable = objComm.GetValue<string>(drrr["NonBillable"].ToString()),
            //                    ICount = objComm.GetValue<string>(drrr["ICount"].ToString()),
            //                    PCount = objComm.GetValue<string>(drrr["PCount"].ToString()),
            //                    Scount = objComm.GetValue<string>(drrr["Scount"].ToString()),
            //                    Whrs = objComm.GetValue<string>(drrr["Whrs"].ToString()),

            //                });
            //            }
            //        }
            //    }

            //    List<list_stff_summary> listline = new List<list_stff_summary>();

            //    if (drrr.NextResult())
            //    {
            //        if (drrr.HasRows)
            //        {
            //            while (drrr.Read())
            //            {
            //                listline.Add(new list_stff_summary()
            //                {
            //                    d1 = objComm.GetValue<string>(drrr["d1"].ToString()),
            //                    d2 = objComm.GetValue<string>(drrr["d2"].ToString()),
            //                    d3 = objComm.GetValue<string>(drrr["d3"].ToString()),
            //                    d4 = objComm.GetValue<string>(drrr["d4"].ToString()),
            //                    d5 = objComm.GetValue<string>(drrr["d5"].ToString()),
            //                    d6 = objComm.GetValue<string>(drrr["d6"].ToString()),
            //                    d7 = objComm.GetValue<string>(drrr["d7"].ToString()),
            //                    Total = objComm.GetValue<string>(drrr["Total"].ToString()),
            //                });
            //            }
            //        }
            //    }


            //    List<tbl_Topfive> listlTop = new List<tbl_Topfive>();

            //    if (drrr.NextResult())
            //    {
            //        if (drrr.HasRows)
            //        {
            //            while (drrr.Read())
            //            {
            //                listlTop.Add(new tbl_Topfive()
            //                {
            //                    project = objComm.GetValue<string>(drrr["Project"].ToString()),
            //                    Job = objComm.GetValue<string>(drrr["Jobname"].ToString()),
            //                    client = objComm.GetValue<string>(drrr["Client"].ToString()),
            //                    Totlhrs = objComm.GetValue<string>(drrr["Totaltime"].ToString()),
            //                    staffcode = objComm.GetValue<int>(drrr["staffcode"].ToString()),

            //                });
            //            }
            //        }
            //    }

            //    foreach (var item in List_DS)
            //    {
            //        item.list_CnJ = list_CJ;
            //        item.list_line = listline;
            //        item.list_Topfive = listlTop;
            //    }
            //}
        }

        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
        //IEnumerable<Timesheet_Pie> tbl = List_DS as IEnumerable<Timesheet_Pie>;
        //var obbbbb = tbl;
        //return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession = true)]
    public string UpdateEndProject(string Rid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<End_Project> obj_Job = new List<End_Project>();

        try
        {

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@rid", Rid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Update_EndDate", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new End_Project()
                    {
                        Jobid = objComm.GetValue<int>(drrr["id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<End_Project> tbl = obj_Job as IEnumerable<End_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession = true)]
    public string GetEndProject(string Startdt, string Enddt, int Deptwise, string ddl, string Srch)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<End_Project> obj_Job = new List<End_Project>();

        try
        {
            string fromdate = Startdt != "" ? Convert.ToDateTime(Startdt, ci).ToString("MM/dd/yyyy") : null;
            string todate = Enddt != "" ? Convert.ToDateTime(Enddt, ci).ToString("MM/dd/yyyy") : null;

            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@deptwise", Deptwise);
            param[2] = new SqlParameter("@startdt", fromdate);
            param[3] = new SqlParameter("@enddt", todate);
            param[4] = new SqlParameter("@ddl", ddl);
            param[5] = new SqlParameter("@srch", Srch);


            //DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_GetEndDate_Project", param);//for chacking the Data 
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetEndDate_Project", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new End_Project()
                    {
                        Jobid = objComm.GetValue<int>(drrr["JobId"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        PrjName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        Strtdt = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        Enddt = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        Count = objComm.GetValue<int>(drrr["Countid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<End_Project> tbl = obj_Job as IEnumerable<End_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession = true)]
    public string GetEndProject_staff(string Startdt, string Enddt, int Deptwise, int Staffcode)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<End_Project> obj_Job = new List<End_Project>();

        try
        {
            if (Session["companyid"] != null)
            {
                string fromdate = Startdt != "" ? Convert.ToDateTime(Startdt, ci).ToString("MM/dd/yyyy") : null;
                string todate = Enddt != "" ? Convert.ToDateTime(Enddt, ci).ToString("MM/dd/yyyy") : null;

                SqlParameter[] param = new SqlParameter[5];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@deptwise", Deptwise);
                param[2] = new SqlParameter("@startdt", fromdate);
                param[3] = new SqlParameter("@enddt", todate);
                param[4] = new SqlParameter("@Staffcode", Staffcode);


                //DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_GetEndDate_Project_Staff", param);//for chacking the Data 
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetEndDate_Project_Staff", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new End_Project()
                        {
                            Jobid = objComm.GetValue<int>(drrr["sino"].ToString()),
                            ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                            PrjName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                            Strtdt = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                            Enddt = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                            Count = objComm.GetValue<int>(drrr["Countid"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<End_Project> tbl = obj_Job as IEnumerable<End_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]
    public string GetLeaveWeek(int compid, string Startdt, string Enddt)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Leaveweek> obj_Job = new List<tbl_Leaveweek>();

        try
        {
            string fromdate = Startdt != "" ? Convert.ToDateTime(Startdt, ci).ToString("MM/dd/yyyy") : null;
            string todate = Enddt != "" ? Convert.ToDateTime(Enddt, ci).ToString("MM/dd/yyyy") : null;

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@frmdt", fromdate);
            param[2] = new SqlParameter("@todt", todate);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_AdminLeaveWeek", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_Leaveweek()
                    {
                        Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Desgn = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        Dept = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        Leave = objComm.GetValue<string>(drrr["Leave_Name"].ToString()),
                        start = objComm.GetValue<string>(drrr["Start_DT"].ToString()),
                        End = objComm.GetValue<string>(drrr["End_DT"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Leaveweek> tbl = obj_Job as IEnumerable<tbl_Leaveweek>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession = true)]
    public string GetTodayLeave(string TodayDate)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Leaveweek> obj_Job = new List<tbl_Leaveweek>();

        try
        {
            string CurrTodayDate = TodayDate != "" ? Convert.ToDateTime(TodayDate, ci).ToString("MM/dd/yyyy") : null;
            string comp = Session["companyid"].ToString();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@TodayDate", CurrTodayDate);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_AdminLeaveToday", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_Leaveweek()
                    {
                        Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Desgn = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        Dept = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        Leave = objComm.GetValue<string>(drrr["Leave_Name"].ToString()),
                        start = objComm.GetValue<string>(drrr["Start_DT"].ToString()),
                        End = objComm.GetValue<string>(drrr["End_DT"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Leaveweek> tbl = obj_Job as IEnumerable<tbl_Leaveweek>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession = true)]
    public string GetLeaveWeekStaff(string Startdt, string Enddt, int Staffcode)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffLeaveweek> obj_Job = new List<tbl_StaffLeaveweek>();

        try
        {
            if (Session["companyid"] != null)
            {
                string fromdate = Startdt != "" ? Convert.ToDateTime(Startdt, ci).ToString("MM/dd/yyyy") : null;
                string todate = Enddt != "" ? Convert.ToDateTime(Enddt, ci).ToString("MM/dd/yyyy") : null;

                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@frmdt", fromdate);
                param[2] = new SqlParameter("@todt", todate);
                param[3] = new SqlParameter("@Staffcode", Staffcode);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_StaffLeaveWeek", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_StaffLeaveweek()
                        {
                            Approver = objComm.GetValue<int>(drrr["Approver"].ToString()),

                        });
                    }

                    List<tbl_Leaveweek> list_CJ = new List<tbl_Leaveweek>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                list_CJ.Add(new tbl_Leaveweek()
                                {
                                    Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                    Desgn = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                                    Dept = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                                    Leave = objComm.GetValue<string>(drrr["Leave_Name"].ToString()),
                                    start = objComm.GetValue<string>(drrr["Start_DT"].ToString()),
                                    End = objComm.GetValue<string>(drrr["End_DT"].ToString()),

                                });
                            }
                        }
                    }

                    foreach (var item in obj_Job)
                    {
                        item.list_leave = list_CJ;

                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_StaffLeaveweek> tbl = obj_Job as IEnumerable<tbl_StaffLeaveweek>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession = true)]
    public string GetTodayLeaveStaff(string TodayDate, int staffcode)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Leaveweek> obj_Job = new List<tbl_Leaveweek>();

        try
        {
            if (Session["companyid"] != null)
            {
                string CurrTodayDate = TodayDate != "" ? Convert.ToDateTime(TodayDate, ci).ToString("MM/dd/yyyy") : null;

                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@TodayDate", CurrTodayDate);
                param[2] = new SqlParameter("@staffcode", staffcode);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_StaffLeaveToday", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_Leaveweek()
                        {
                            Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                            Desgn = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                            Dept = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                            Leave = objComm.GetValue<string>(drrr["Leave_Name"].ToString()),
                            start = objComm.GetValue<string>(drrr["Start_DT"].ToString()),
                            End = objComm.GetValue<string>(drrr["End_DT"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Leaveweek> tbl = obj_Job as IEnumerable<tbl_Leaveweek>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession = true)]
    public string GetAllStaffAttendance(string frdt, string todt)
    {
        string fromdate = frdt != "" ? Convert.ToDateTime(frdt, ci).ToString("MM/dd/yyyy") : null;
        string todate = todt != "" ? Convert.ToDateTime(todt, ci).ToString("MM/dd/yyyy") : null;
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Monthly_Attendance> listMonthlyHolidays = new List<tbl_Monthly_Attendance>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@CompID", Session["companyid"]);
                param[1] = new SqlParameter("@fromdt", fromdate);
                param[2] = new SqlParameter("@todt", todate);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetAllStaffCheckInDetails", param))
                {

                    if (drrr.HasRows)
                    {

                        while (drrr.Read())
                        {
                            listMonthlyHolidays.Add(new tbl_Monthly_Attendance()
                            {
                                staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                //designation = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                                department = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                                AttenDate = objComm.GetValue<string>(drrr["AttendanceDateStr"].ToString()),
                                CheckInTime = objComm.GetValue<string>(drrr["CheckInDateStr"].ToString()),
                                CheckOutTime = objComm.GetValue<string>(drrr["CheckOutDateStr"].ToString()),
                                ClockedTime = objComm.GetValue<string>(drrr["ClockedTime"].ToString()),
                                CheckInDevice = objComm.GetValue<string>(drrr["CheckInDevice"].ToString()),
                                CheckOutDevice = objComm.GetValue<string>(drrr["CheckOutDevice"].ToString()),
                                CheckInLocation = objComm.GetValue<string>(drrr["CheckInLocation"].ToString()),
                                CheckOutLocation = objComm.GetValue<string>(drrr["CheckOutLocation"].ToString()),
                                IsMobileDeviceCheckOut = objComm.GetValue<bool>(drrr["IsMobileDeviceCheckOut"].ToString()),
                                IsMobileDeviceCheckIn = objComm.GetValue<bool>(drrr["IsMobileDeviceCheckIn"].ToString()),
                            });
                        }

                    }

                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(listMonthlyHolidays);
    }

}