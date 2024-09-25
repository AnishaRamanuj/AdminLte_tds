<%@ WebService Language="C#" Class="TimesheetViewer" %>

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
public class TimesheetViewer : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod(EnableSession=true)]
    public string GetAlldropdown(int PageLevel, int staffcode, string staffrole, string SuperAppr, string SubAppr, string frtime, string totime, int pageIndex, int pageSize, int mmdd,string status)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_TSViewerdropdwon> List_DS = new List<tbl_TSViewerdropdwon>();
        if (staffrole == "Company-Admin")
        {
            staffrole = "";
            staffcode = 0;

        }
        string fromdate;
        string todate;

        if (mmdd == 0)
        {
            fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
            todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
        }
        else
        {
            fromdate = frtime;
            todate = totime;
        }

        DataSet ds;
        try
        {
            Common ob = new Common();

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[11];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@pagelevel", PageLevel);
            param[2] = new SqlParameter("@staffcode", staffcode);
            param[3] = new SqlParameter("@staffrole", staffrole);
            param[4] = new SqlParameter("@SuperAppr", SuperAppr);
            param[5] = new SqlParameter("@SubAppr", SubAppr);
            param[6] = new SqlParameter("@fromdate", fromdate);
            param[7] = new SqlParameter("@Todate", todate);
            param[8] = new SqlParameter("@pageIndex", pageIndex);
            param[9] = new SqlParameter("@pageSize", pageSize);
            param[10] = new SqlParameter("@Status", status);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DropdownTSViewer_new", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }
        //IEnumerable<tbl_TSViewerdropdwon> tbl = List_DS as IEnumerable<tbl_TSViewerdropdwon>;
        //var obbbbb = tbl;
        //var outputJsonResult = new JavaScriptSerializer();
        //outputJsonResult.MaxJsonLength = 10 * 1024 * 1024;
        //return outputJsonResult.Serialize(tbl);
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string GetJobdropdown(int staffcode, int projectid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<ProjectWiseBudgeting> List_DS = new List<ProjectWiseBudgeting>();

        try
        {
            Common ob = new Common();

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@projectid", projectid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DropdownJobnameTSViewer", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new ProjectWiseBudgeting()
                    {
                        MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        mjobid = objComm.GetValue<int>(drrr["MJobId"].ToString()),
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


    [WebMethod(EnableSession=true)]
    public string GetViewer_EditJobdropdown(int staffcode, int projectid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<ProjectWiseBudgeting> List_DS = new List<ProjectWiseBudgeting>();

        try
        {
            Common ob = new Common();

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@projectid", projectid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DropdownJobname_TSViewer", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new ProjectWiseBudgeting()
                    {
                        MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        mjobid = objComm.GetValue<int>(drrr["MJobId"].ToString()),
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

    [WebMethod(EnableSession=true)]

    public string bind_timesheets(string cltid, string projectid, string mjobid, string staffcode, string frtime, string totime, string status, int muti, string task, int Sid, string Staffrole, string ChckMyTS, string deptId, int pageIndex, int pageSize, int mmdd)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Timesheets_data> List_DS = new List<tbl_Timesheets_data>();
        DataSet ds;
        try
        {
            string spname = "";
            string result = "";
            if (task == "undefined")
            {
                task = "0";
            }
            if (Staffrole == "Company-Admin")
            {
                Staffrole = "";
                staffcode = "0";

            }
            spname = "usp_Bootstrap_bind_timesheets_new";
            //}
            string fromdate;
            string todate;

            if (mmdd == 0)
            {
                fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
                todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
            }
            else
            {
                fromdate = frtime;
                todate = totime;
            }

            Common ob = new Common();

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[15];
            param[0] = new SqlParameter("@compid", _Compid);
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
            param[13] = new SqlParameter("@pageIndex", pageIndex);
            param[14] = new SqlParameter("@pageSize", pageSize);
            //param[15] = new SqlParameter("@groupBy", "");
            //param[16] = new SqlParameter("@summary", "");

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, spname, param);

        }

        catch (Exception ex)
        {
            throw ex;
        }
        //IEnumerable<tbl_Timesheets_data> tbl = List_DS as IEnumerable<tbl_Timesheets_data>;
        //var obbbbb = tbl;
        //return new JavaScriptSerializer().Serialize(tbl);
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]

    public string Bind_TwoLTimesheet(string cltid, string mjobid, string staffcode, string frtime, string totime, string status, int Sid, string SuperAppr, string SubAppr, string ChckMyTS, int deptId, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Timesheets_data> List_DS = new List<tbl_Timesheets_data>();

        try
        {

            string fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
            string todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
            Common ob = new Common();

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[14];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@FromTime", fromdate);
            param[3] = new SqlParameter("@totime", todate);
            param[4] = new SqlParameter("@status", status);
            param[5] = new SqlParameter("@mJid", mjobid);
            param[6] = new SqlParameter("@Sid", Sid);
            param[7] = new SqlParameter("@staffcode", staffcode);
            param[8] = new SqlParameter("@SuperAppr", SuperAppr);
            param[9] = new SqlParameter("@SubAppr", SubAppr);
            param[10] = new SqlParameter("@ChckMyTS", ChckMyTS);
            param[11] = new SqlParameter("@deptId", deptId);
            param[12] = new SqlParameter("@pageIndex", pageIndex);
            param[13] = new SqlParameter("@pageSize", pageSize);


            using (SqlDataReader rs = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_2levelTimesheet_new", param))
            {
                while (rs.Read())
                {
                    List_DS.Add(new tbl_Timesheets_data()
                    {
                        MJobName = objComm.GetValue<string>(rs["MJobName"].ToString()),
                        StaffName = objComm.GetValue<string>(rs["staffname"].ToString()),
                        FromDT = objComm.GetValue<string>(rs["FromTime"].ToString()),
                        ToDT = objComm.GetValue<string>(rs["ToTime"].ToString()),
                        Status = objComm.GetValue<string>(rs["status"].ToString()),
                        Billable = objComm.GetValue<bool>(rs["Billable"].ToString()),
                        ClientName = objComm.GetValue<string>(rs["ClientName"].ToString()),
                        Dt = objComm.GetValue<string>(rs["Date"].ToString()),
                        TotalTime = objComm.GetValue<string>(rs["Totaltime"].ToString()),
                        TotalCount = objComm.GetValue<int>(rs["TotalCount"].ToString()),
                        Srno = objComm.GetValue<int>(rs["Srno"].ToString()),
                        TSId = objComm.GetValue<int>(rs["TSId"].ToString()),
                        Narration = objComm.GetValue<string>(rs["Narration"].ToString()),
                        OpeAmt = objComm.GetValue<float>(rs["opeamt"].ToString()),
                        Location = objComm.GetValue<string>(rs["LocationName"].ToString()),
                        Reason= objComm.GetValue<string>(rs["Reason"].ToString()),
                        Approver = objComm.GetValue<string>(rs["Approver"].ToString()),
                        mJobid = objComm.GetValue<int>(rs["mjobid"].ToString()),
                        Jobid = objComm.GetValue<int>(rs["jobid"].ToString()),
                        Cltid = objComm.GetValue<int>(rs["cltid"].ToString()),
                    });
                }
            }
        }

        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Timesheets_data> tbl = List_DS as IEnumerable<tbl_Timesheets_data>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string PieGraphTSViewer(int staffcode, string frtime, string totime, int Pagelevel, string Staffrole, string SuperAppr, string SubAppr, string ChckMyTS, int mmdd)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<TSDiagram> List_DS = new List<TSDiagram>();

        string fromdate;
        string todate;

        if (mmdd == 0)
        {
            fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
            todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
        }
        else
        {
            fromdate = frtime;
            todate = totime;
        }

        //string fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
        //string todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", _Compid);
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
                        Compid = 0,
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


    [WebMethod(EnableSession=true)]
    public string bind_StaffsummaryData(string Start, string end, int staffcode, int sid, string Staffrole, int PageLevel, string SuperAppr, string SubAppr, int pageIndex, int pageSize, int mmdd)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<list_stff_summary> obj_Job = new List<list_stff_summary>();

        string fromdate;
        string todate;

        if (mmdd == 0)
        {
            fromdate = Start != "" ? Convert.ToDateTime(Start, ci).ToString("MM/dd/yyyy") : null;
            todate = end != "" ? Convert.ToDateTime(end, ci).ToString("MM/dd/yyyy") : null;
        }
        else
        {
            fromdate = Start;
            todate = end;
        }

        //string fromdate = Start != "" ? Convert.ToDateTime(Start, ci).ToString("MM/dd/yyyy") : null;
        //string todate = end != "" ? Convert.ToDateTime(end, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[11];
            param[0] = new SqlParameter("@compid", _Compid);
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



    [WebMethod(EnableSession=true)]
    public string bind_Approver_TimesheetNotSubmitted(string Start, string end, int staffcode, int sid, string Staffrole,string wk, int pageIndex, int pageSize, int mmdd)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<list_stff_summary> obj_Job = new List<list_stff_summary>();

        string fromdate;
        string todate;

        if (mmdd == 0)
        {
            fromdate = Start != "" ? Convert.ToDateTime(Start, ci).ToString("MM/dd/yyyy") : null;
            todate = end != "" ? Convert.ToDateTime(end, ci).ToString("MM/dd/yyyy") : null;
        }
        else
        {
            fromdate = Start;
            todate = end;
        }

        //string fromdate = Start != "" ? Convert.ToDateTime(Start, ci).ToString("MM/dd/yyyy") : null;
        //string todate = end != "" ? Convert.ToDateTime(end, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@start", fromdate);
            param[2] = new SqlParameter("@end", todate);
            param[3] = new SqlParameter("@staffcode", staffcode);
            param[4] = new SqlParameter("@sid", sid);
            param[5] = new SqlParameter("@staffrole", Staffrole);
            param[6] = new SqlParameter("@wk",wk);
            param[7] = new SqlParameter("@pageIndex",pageIndex);
            param[8] = new SqlParameter("@pageSize",pageSize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_TimeSheetNotSubmitted_new", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new list_stff_summary()
                    {

                        staffcode=objComm.GetValue<string>(drrr["staffcode"].ToString()),
                        staffemail =objComm.GetValue<string>(drrr["staffemail"].ToString()),
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


    //[WebMethod]
    //public string bind_Approver_TimesheetNotSubmitted(int compid, string Start, string end, int staffcode, string staff_role, string wk, int pageindex, int pagesize, int Sid, int PageLevel, string SuperAppr, string SubAppr)
    //{
    //    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    //    List<tbl_timesheet_not> obj_Job = new List<tbl_timesheet_not>();
    //    try
    //    {
    //        string pram = "";
    //        //if (PageLevel > 2)
    //        //{
    //        if (staffcode == 0)
    //        {
    //            pram = "usp_Bootstrap_LastTimesheets";
    //        }
    //        else
    //        {
    //            pram = "usp_Bootstrap_Staff_TimeSheetNotSubmitted";
    //        }



    //        Common ob = new Common();
    //        SqlParameter[] param = new SqlParameter[11];
    //        param[0] = new SqlParameter("@companyId", compid);
    //        param[1] = new SqlParameter("@from_date", Convert.ToDateTime(Start, ci));
    //        param[2] = new SqlParameter("@to_date", Convert.ToDateTime(end, ci));
    //        param[3] = new SqlParameter("@staffcode", staffcode);
    //        param[4] = new SqlParameter("@staff_role", staff_role);
    //        param[5] = new SqlParameter("@Wk", wk);
    //        param[6] = new SqlParameter("@pageindex", pageindex);
    //        param[7] = new SqlParameter("@pagesize", pagesize);
    //        param[8] = new SqlParameter("@sid", Sid);
    //        param[9] = new SqlParameter("@SuperAppr", SuperAppr);
    //        param[10] = new SqlParameter("@SubAppr", SubAppr);

    //        using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, pram, param))
    //        {
    //            while (drrr.Read())
    //            {
    //                obj_Job.Add(new tbl_timesheet_not()
    //                {
    //                    srno = objComm.GetValue<int>(drrr["SrNo"].ToString()),
    //                    Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
    //                    Deptname = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
    //                    DesignName = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
    //                    Tdate = objComm.GetValue<string>(drrr["lasttimesheet"].ToString()),
    //                    Approver = objComm.GetValue<string>(drrr["Approver"].ToString()),
    //                    mobile = objComm.GetValue<string>(drrr["Mobile"].ToString()),
    //                    email = objComm.GetValue<string>(drrr["Email"].ToString()),
    //                    Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
    //                });
    //            }
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //    IEnumerable<tbl_timesheet_not> tbl = obj_Job as IEnumerable<tbl_timesheet_not>;
    //    var obbbbb = tbl;
    //    return new JavaScriptSerializer().Serialize(tbl);
    //}


    [WebMethod(EnableSession=true)]
    public string getDualApproverTimesheets(string staffcode, string cltid, string projectid, string mjobid, int Sid, string status, string Staffrole, string frtime, string totime, int deptId, int pageIndex, int pageSize, int mmdd)
    {
        string result = "";
        string procname = "";
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> obj_ts = new List<timesheet_table>();

        procname = "usp_Bootstrap_getViewer_Timesheet_new";

        try
        {

            string fromdate;
            string todate;

            if (mmdd == 0)
            {
                fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
                todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
            }
            else
            {
                fromdate = frtime;
                todate = totime;
            }

            Common ob = new Common();

            string _Compid = ob.companyid.ToString();


            //string fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
            //string todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;

            SqlParameter[] param = new SqlParameter[13];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@sts", status);
            param[3] = new SqlParameter("@cltid", cltid);
            param[4] = new SqlParameter("@projectid", projectid);
            param[5] = new SqlParameter("@MJid", mjobid);
            param[6] = new SqlParameter("@Staff_Role", Staffrole);
            param[7] = new SqlParameter("@Sid", Sid);
            param[8] = new SqlParameter("@FromDT", fromdate);
            param[9] = new SqlParameter("@ToDT", todate);
            param[10] = new SqlParameter("@deptId", deptId);
            param[11] = new SqlParameter("@pageIndex", pageIndex);
            param[12] = new SqlParameter("@pageSize", pageSize);

            //DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, procname, param);
            using (SqlDataReader rs = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, procname, param))
            {

                while (rs.Read())
                {
                    obj_ts.Add(new timesheet_table()
                    {
                        MJobName = objComm.GetValue<string>(rs["MJobName"].ToString()),
                        StaffName = objComm.GetValue<string>(rs["staffname"].ToString()),
                        TaskName = objComm.GetValue<string>(rs["Taskname"].ToString()),
                        Reason = objComm.GetValue<string>(rs["Reason"].ToString()),
                        FromDT = objComm.GetValue<string>(rs["TDate"].ToString()),
                        ToDT = objComm.GetValue<string>(rs["fDate"].ToString()),
                        StaffCode = objComm.GetValue<int>(rs["StaffCode"].ToString()),
                        Status = objComm.GetValue<string>(rs["status"].ToString()),
                        Billable = objComm.GetValue<bool>(rs["Billable"].ToString()),
                        ClientName = objComm.GetValue<string>(rs["ClientName"].ToString()),
                        ProjectName = objComm.GetValue<string>(rs["ProjectName"].ToString()),
                        TotalTime = objComm.GetValue<string>(rs["Totaltime"].ToString()),
                        TotalCount = objComm.GetValue<int>(rs["TotalCount"].ToString()),
                        RoleName = objComm.GetValue<string>(rs["Rolename"].ToString()),
                        APattern = objComm.GetValue<string>(rs["ApprovalPattern"].ToString()),
                        Srno = objComm.GetValue<int>(rs["Srno"].ToString()),
                        TSId = objComm.GetValue<int>(rs["TSId"].ToString()),
                        Narration = objComm.GetValue<string>(rs["Narration"].ToString()),
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


    [WebMethod(EnableSession=true)]
    public string bind_MinimumHrs(string Start, string end, int staffcode, string staff_role, int sid, int PageLevel, string SuperAppr, string SubAppr, int pageIndex, int pageSize)
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

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[10];
            param[0] = new SqlParameter("@companyId", _Compid);
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

    [WebMethod(EnableSession=true)]
    public string Update_Approve_Reject(timesheet_table ts)
    {
        string result = "";
        string procname = "";
        CommonFunctions objComm = new CommonFunctions();
        Common ob = new Common();

        string _Compid = ob.companyid.ToString();

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
            param[0] = new SqlParameter("@compid", _Compid);
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


    [WebMethod(EnableSession=true)]
    public string UpdateTimehseet(int TSID, string FrTim, string ToTim, string Totalime, string Narr)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<ProjectWiseBudgeting> List_DS = new List<ProjectWiseBudgeting>();

        try
        {
            Common ob = new Common();

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", _Compid);
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

    [WebMethod (EnableSession=true)]
    public string GetLeaveDate(timesheet_table ts)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> List_ts = new List<timesheet_table>();

        try
        {
            Common ob = new Common();

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@CompId", _Compid);
            param[1] = new SqlParameter("@Fr", ts.FromDT);
            param[2] = new SqlParameter("@To", ts.ToDT);
            param[3] = new SqlParameter("@Staffcode", Session["staffid"]);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_TimesheetLeaveSlab", param))
            {
                while (drrr.Read())
                {
                    List_ts.Add(new timesheet_table()
                    {
                        Date1 =  objComm.GetValue<string>(drrr["AllDates"].ToString()),
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

    [WebMethod(EnableSession=true)]
    public string deletesavedTimesheet(int TSID, int staffcode)
    {
        Common ob = new Common();

        string _Compid = ob.companyid.ToString();

        CommonFunctions objComm = new CommonFunctions();
        SqlParameter[] param = new SqlParameter[3];
        param[0] = new SqlParameter("@TSID", TSID);
        param[1] = new SqlParameter("@staffcode", staffcode);
        param[2] = new SqlParameter("@compid", _Compid);
        var res = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_deletesavedTimesheet", param);
        if (res > 0)
        { return "success"; }
        else { return "error"; }
    }


    [WebMethod(EnableSession = true)]
    public string ProjectSummary(int PLvl, int scode, string srole,int cid, int Pid, string frtime, string totime, string sts, int pIndex, int pSize, string dp, string pftr)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_TSViewerdropdwon> List_DS = new List<tbl_TSViewerdropdwon>();
        if (srole == "Company-Admin")
        {
            srole = "";
            scode = 0;

        }
        string fromdate;
        string todate;

        fromdate = frtime;
        todate = totime;

        string SuperAppr = "";
        string SubAppr = "";
        DataSet ds;
        try
        {
            Common ob = new Common();

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[13];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@pagelevel", PLvl);
            param[2] = new SqlParameter("@staffcode", scode);
            param[3] = new SqlParameter("@staffrole", srole);
            param[4] = new SqlParameter("@Projectid", Pid);

            param[5] = new SqlParameter("@FromTime", fromdate);
            param[6] = new SqlParameter("@ToTime", todate);
            param[7] = new SqlParameter("@pageIndex", pIndex);
            param[8] = new SqlParameter("@pageSize", pSize);
            param[9] = new SqlParameter("@Status", sts);
            param[10] = new SqlParameter("@dp", dp);
            param[11] = new SqlParameter("@pfltr", pftr);
            param[12] = new SqlParameter("@Clientid", cid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ProjectSummary_Viewer", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession = true)]
    public string TeamSummary(string cid, string pid, string mid, string sid, string sCode, string frtime, string totime, string sRole, string did, string PLvl, int pIndex, int pSize, int fltr)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_TSViewerdropdwon> List_DS = new List<tbl_TSViewerdropdwon>();
        if (sRole == "Company-Admin")
        {
            sRole = "";
            sCode = "0";

        }
        string fromdate;
        string todate;

        fromdate = frtime;
        todate = totime;


        DataSet ds;
        try
        {
            Common ob = new Common();

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[14];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@pagelevel", PLvl);
            param[2] = new SqlParameter("@staffcode", sCode);
            param[3] = new SqlParameter("@staffrole", sRole);
            param[4] = new SqlParameter("@Projectid", pid);
            param[5] = new SqlParameter("@FromTime", fromdate);
            param[6] = new SqlParameter("@ToTime", todate);
            param[7] = new SqlParameter("@pageIndex", pIndex);
            param[8] = new SqlParameter("@pageSize", pSize);
            param[9] = new SqlParameter("@dp", did);
            param[10] = new SqlParameter("@cltid", cid);
            param[11] = new SqlParameter("@mJid", mid);
            param[12] = new SqlParameter("@Sid", sid);
            param[13] = new SqlParameter("@fltr", fltr);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_TeamSummary_Viewer", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession = true)]
    public string ClientSummary(string cid, string pid, string mid, string sid, string sCode, string frtime, string totime, string sRole, string did, string PLvl, int pIndex, int pSize, string fltr)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_TSViewerdropdwon> List_DS = new List<tbl_TSViewerdropdwon>();
        if (sRole == "Company-Admin")
        {
            sRole = "";
            sCode = "0";

        }
        string fromdate;
        string todate;

        fromdate = frtime;
        todate = totime;


        DataSet ds;
        try
        {
            Common ob = new Common();

            string _Compid = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[14];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@pagelevel", PLvl);
            param[2] = new SqlParameter("@staffcode", sCode);
            param[3] = new SqlParameter("@staffrole", sRole);
            param[4] = new SqlParameter("@Projectid", pid);
            param[5] = new SqlParameter("@FromTime", fromdate);
            param[6] = new SqlParameter("@ToTime", todate);
            param[7] = new SqlParameter("@pageIndex", pIndex);
            param[8] = new SqlParameter("@pageSize", pSize);
            param[9] = new SqlParameter("@dp", did);
            param[10] = new SqlParameter("@cltid", cid);
            param[11] = new SqlParameter("@mJid", mid);
            param[12] = new SqlParameter("@Sid", sid);
            param[13] = new SqlParameter("@fltr", fltr);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ClientSummary_Viewer", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

}