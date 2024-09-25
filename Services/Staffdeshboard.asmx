<%@ WebService Language="C#" Class="Staffdeshboard" %>

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
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.GraphDB 
[System.Web.Script.Services.ScriptService]
public class Staffdeshboard : System.Web.Services.WebService
{
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod(EnableSession = true)]
    public string GraphDB(int staffcode, string frtime, string totime, int Pagelevel)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<DB_Graph> List_DS = new List<DB_Graph>();
        string fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
        string todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[6];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@staffcode", staffcode);
                param[2] = new SqlParameter("@fromdt", fromdate);
                param[3] = new SqlParameter("@todt", todate);
                param[4] = new SqlParameter("@pagelevel", Pagelevel);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_SatffDashBoardGraph_new", param))
                {
                    while (drrr.Read())
                    {
                        List_DS.Add(new DB_Graph()
                        {
                            Compid = objComm.GetValue<int>(drrr["compid"].ToString()),
                            perct = objComm.GetValue<string>(drrr["perct"].ToString()),
                        });
                    }


                    List<list_stff_summary> listline = new List<list_stff_summary>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listline.Add(new list_stff_summary()
                                {
                                    d1 = objComm.GetValue<string>(drrr["d1"].ToString()),
                                    d2 = objComm.GetValue<string>(drrr["d2"].ToString()),
                                    d3 = objComm.GetValue<string>(drrr["d3"].ToString()),
                                    d4 = objComm.GetValue<string>(drrr["d4"].ToString()),
                                    d5 = objComm.GetValue<string>(drrr["d5"].ToString()),
                                    d6 = objComm.GetValue<string>(drrr["d6"].ToString()),
                                    d7 = objComm.GetValue<string>(drrr["d7"].ToString()),
                                    Total = objComm.GetValue<string>(drrr["Total"].ToString()),
                                });
                            }
                        }
                    }

                    //List<tblThumbLogins> listpie = new List<tblThumbLogins>();

                    //if (drrr.NextResult())
                    //{
                    //    if (drrr.HasRows)
                    //    {
                    //        while (drrr.Read())
                    //        {
                    //            listpie.Add(new tblThumbLogins()
                    //            {
                    //                status = objComm.GetValue<string>(drrr["status"].ToString()),
                    //                ttime = objComm.GetValue<string>(drrr["totaltime"].ToString()),

                    //            });
                    //        }
                    //    }
                    //}
                    //List<ApproverList> listApp = new List<ApproverList>();

                    //if (drrr.NextResult())
                    //{
                    //    if (drrr.HasRows)
                    //    {
                    //        while (drrr.Read())
                    //        {
                    //            listApp.Add(new ApproverList()
                    //            {
                    //                id = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                    //                PNAME = objComm.GetValue<string>(drrr["StaffName"].ToString()),

                    //            });
                    //        }
                    //    }
                    //}

                    //List<DashboardDetails> listDashboard = new List<DashboardDetails>();
                    //if (drrr.NextResult())
                    //{
                    //    if (drrr.HasRows)
                    //    {
                    //        while (drrr.Read())
                    //        {
                    //            listDashboard.Add(new DashboardDetails()
                    //            {
                    //                rejected = objComm.GetValue<int>(drrr["RejectedCount"].ToString()),
                    //                approved = objComm.GetValue<int>(drrr["ApproverCount"].ToString()),
                    //                pending = objComm.GetValue<int>(drrr["Pending"].ToString())
                    //            });
                    //        }
                    //    }
                    //}
                    foreach (var item in List_DS)
                    {
                        item.list_line = listline;
                        //item.list_status = listpie;
                        //item.list_App = listApp;
                        //item.list_StatusCounts = listDashboard;
                    }
                }
            }
        }

        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<DB_Graph> tbl = List_DS as IEnumerable<DB_Graph>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetUpcomingHolidays(string staffCode)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Monthly_Holidays> listMonthlyHolidays = new List<tbl_Monthly_Holidays>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@CompID", Session["companyid"]);
                param[1] = new SqlParameter("@StaffCode", staffCode);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetUpcomingHolidays", param))
                {

                    if (drrr.HasRows)
                    {

                        while (drrr.Read())
                        {
                            listMonthlyHolidays.Add(new tbl_Monthly_Holidays()
                            {
                                HolidayDate = objComm.GetValue<string>(drrr["HolidayDateStr"].ToString()),
                                HolidayName = objComm.GetValue<string>(drrr["HolidayName"].ToString()),
                                IsUpcoming = objComm.GetValue<DateTime>(drrr["HolidayDate"].ToString()) > DateTime.Today ? true : false
                            }); ;
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


    [WebMethod(EnableSession = true)]
    public string GetMyAttendance(string staffCode)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Monthly_Attendance> listMonthlyHolidays = new List<tbl_Monthly_Attendance>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@CompID", Session["companyid"]);
                param[1] = new SqlParameter("@StaffCode", staffCode);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetLast30DaysStaffAttendanceRecord", param))
                {

                    if (drrr.HasRows)
                    {

                        while (drrr.Read())
                        {
                            listMonthlyHolidays.Add(new tbl_Monthly_Attendance()
                            {
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
                            }); ;
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

    [WebMethod(EnableSession = true)]
    public string AttendenceMark(string currentstatus, string location, int staffcode, int LogID, int AttendEntryId, string TotalTime, string ClockTime)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<StaffAttendanceLog> List_ML = new List<StaffAttendanceLog>();

        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[10];
                param[0] = new SqlParameter("@LogID", LogID);
                param[1] = new SqlParameter("@AttendEntryId", AttendEntryId);
                param[2] = new SqlParameter("@compid", Session["companyid"]);
                param[3] = new SqlParameter("@CurrentStatus", currentstatus);
                param[4] = new SqlParameter("@empLocation", location);
                param[5] = new SqlParameter("@staffcode", staffcode);
                param[6] = new SqlParameter("@TotalTime", TotalTime);
                param[7] = new SqlParameter("@ClockTime", ClockTime);
                param[8] = new SqlParameter("@DeviceInfo", HttpContext.Current.Request.Headers["User-Agent"].ToString());
                param[9] = new SqlParameter("@IsMobileDevice", Convert.ToBoolean(HttpContext.Current.Request.Browser["IsMobileDevice"]));

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Staff_AttendenceMark", param))
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

    [WebMethod]
    public string GetProjectActivityPlan(int compid, string Startdt, string Enddt, int Staffcode)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<AssignDeptProjectActivity> obj_Job = new List<AssignDeptProjectActivity>();

        try
        {
            string fromdazte = Startdt != "" ? Convert.ToDateTime(Startdt, ci).ToString("MM/dd/yyyy") : null;
            string todate = Enddt != "" ? Convert.ToDateTime(Enddt, ci).ToString("MM/dd/yyyy") : null;

            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@startdt", fromdazte);
            param[2] = new SqlParameter("@enddt", todate);
            param[3] = new SqlParameter("@Staffcode", Staffcode);


            //DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_GetEndDate_Project_Staff", param);//for chacking the Data 
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetProjectActivityPlan", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new AssignDeptProjectActivity()
                    {
                        ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        FromDate = objComm.GetValue<string>(drrr["Frdt"].ToString()),
                        ToDate = objComm.GetValue<string>(drrr["Todt"].ToString()),
                        Hrs = objComm.GetValue<string>(drrr["TotalTime"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drrr["Average"].ToString()),
                        AssignId = objComm.GetValue<int>(drrr["Billable"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<AssignDeptProjectActivity> tbl = obj_Job as IEnumerable<AssignDeptProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]

    public string bind_timesheets(string compid, string cltid, string projectid, string mjobid, string staffcode, string frtime, string totime, string status, int muti, string task, int Sid, string Staffrole, string ChckMyTS, int deptId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Timesheets_data> List_DS = new List<tbl_Timesheets_data>();
        DataSet ds;
        try
        {
            string spname = "";
            string result = "";

            spname = "usp_Bootstrap_bind_timesheets";

            string fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
            string todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[13];
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
            param[10] = new SqlParameter("@task", task);
            param[11] = new SqlParameter("@ChckMyTS", ChckMyTS);
            param[12] = new SqlParameter("@deptId", deptId);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, spname, param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession = true)]
    public string GetDrawings(string startDt, string endDt, int staffCode)
    {
        string fromDate = startDt != "" ? Convert.ToDateTime(startDt, ci).ToString("MM/dd/yyyy") : null;
        string toDate = endDt != "" ? Convert.ToDateTime(endDt, ci).ToString("MM/dd/yyyy") : null;
        List<vw_DrawingMaster> drawings = new List<vw_DrawingMaster>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[6];
                param[0] = new SqlParameter("@Compid", Session["companyid"]);
                param[1] = new SqlParameter("@StaffCode", staffCode);
                param[2] = new SqlParameter("@StartDate", fromDate);
                param[3] = new SqlParameter("@EndDate", toDate);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DashboardDrawings", param))
                {
                    while (drrr.Read())
                    {
                        drawings.Add(new vw_DrawingMaster()
                        {
                            DrawingAllocationId = objComm.GetValue<int>(drrr["DrawingAllocationId"].ToString()),
                            DrawingNumber = objComm.GetValue<string>(drrr["DrawingNumber"].ToString()),
                            DrawingName = objComm.GetValue<string>(drrr["DrawingName"].ToString()),
                            TargetDate = objComm.GetValue<string>(drrr["TargetDate"].ToString()),
                            ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                            Revision = objComm.GetValue<string>(drrr["Revision"].ToString()),
                            SubmitDate = objComm.GetValue<string>(drrr["SubmitDate"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<vw_DrawingMaster> tbl = drawings as IEnumerable<vw_DrawingMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
}