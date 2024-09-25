<%@ WebService Language="C#" Class="wsAllTimesheet" %>

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
using JTMSProject;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsAllTimesheet : System.Web.Services.WebService
{
    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]

    public string bind_timesheet(string staffid, string compid, string cltid, string projectid, string mjobid, string staffcode, string staffmode, string frtime, string totime, string status, string PageIndex, string PageSize)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        List<AllTimesheetModel> obj_tmst = new List<AllTimesheetModel>();
        try
        {
            string fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
            string todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[12];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@staffcode", staffid);
            param[3] = new SqlParameter("@FromTime", fromdate);
            param[4] = new SqlParameter("@totime", todate);
            param[5] = new SqlParameter("@status", status);
            param[6] = new SqlParameter("@mJid", mjobid);
            param[7] = new SqlParameter("@sid", staffcode);
            param[8] = new SqlParameter("@projectid", projectid);
            param[9] = new SqlParameter("@PageIndex", PageIndex);
            param[10] = new SqlParameter("@PageSize", PageSize);
            param[11] = new SqlParameter("@StaffMode", staffmode);
            ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_GetAllTimesheetGridStaffWise", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }


        return ds.GetXml();

    }

    [WebMethod]
    public void All_Timesheets_Update_Approvar_Time(int compid, string tsid)
    {
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@tsid", tsid);
            SqlHelper.ExecuteNonQuery(sqlConn, CommandType.StoredProcedure, "usp_All_Timesheets_Update_Approvar_Time", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public void edittimesheetsave(string tsid, string ftime, string ttime, string tottime, string locid, string narration, string status)
    {
        try
        {
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@tsid", tsid);
            param[1] = new SqlParameter("@ftime", ftime);
            param[2] = new SqlParameter("@ttime", ttime);
            param[3] = new SqlParameter("@tottime", tottime);
            param[4] = new SqlParameter("@locid", locid);
            param[5] = new SqlParameter("@narration", narration);
            param[6] = new SqlParameter("@status", status);
            SqlHelper.ExecuteNonQuery(sqlConn, CommandType.StoredProcedure, "usp_edittimesheetsave", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]

    public string Approve_timesheet(string compid, string staffcode, string tsid)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@tsid", tsid);
            ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_approve_timesheets", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        string tsids = ds.Tables[0].Rows[0][0].ToString();
        //string[] values = tsids.Split(',');
        //if (ds.Tables[0].Rows.Count > 0) {


        //}
        return tsids;

    }
    [WebMethod]
    public void saveReasions(string tsid, string reasion)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@tsid", tsid);
            param[1] = new SqlParameter("@reasion", reasion);
            SqlHelper.ExecuteNonQuery(sqlConn, CommandType.StoredProcedure, "usp_saveReasions", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]

    public string Reject_timesheet(string compid, string staffcode, string tsid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@tsid", tsid.TrimEnd(','));

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Reject_timesheets", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<vw_JobnClientnStaff> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod]

    public string excel_timesheet(string staffcode, string compid, string cltid, string projectid, string mjobid, string sid, string frtime, string totime, string status)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            string fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
            string todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@companyId", compid);
            param[1] = new SqlParameter("@StaffCode", staffcode);
            param[2] = new SqlParameter("@cid", cltid);
            param[3] = new SqlParameter("@projectid", projectid);
            param[4] = new SqlParameter("@mJid", mjobid);
            param[5] = new SqlParameter("@sid", sid);
            param[6] = new SqlParameter("@FromTime", fromdate);
            param[7] = new SqlParameter("@ToTime", todate);
            param[8] = new SqlParameter("@Status", status);

            ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_excel_timesheet", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_excel_timesheet", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
                    {

                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        //IEnumerable<vw_JobnClientnStaff> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff>;
        //var obbbbb = tbl;
        //return new JavaScriptSerializer().Serialize(tbl);
        return ds.GetXml();




    }

    [WebMethod]

    public string bind_Staff(string mjobid, string compid, string isapprover, string staffcode, string superapprid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@isapprover", isapprover);
            param[3] = new SqlParameter("@mjobId", mjobid);
            param[4] = new SqlParameter("@superappid", superapprid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_bind_staff_approver", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<vw_JobnClientnStaff> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]

    public string bind_Client(string compid, string isapprover, string staffcode, string superapprid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@isapprover", isapprover);
            param[2] = new SqlParameter("@staffcode", staffcode);
            param[3] = new SqlParameter("@superappr", superapprid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_timesheet_client", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
                    {
                        Cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }
    [WebMethod]

    public string bind_project(string compid, string cltid, string isapprover, string staffcode, string superapprid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@isapprover", isapprover);
            param[3] = new SqlParameter("@staffcode", staffcode);
            param[4] = new SqlParameter("@superappid", superapprid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_timesheet_project", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
                    {
                        projectid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        projectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]

    public string bind_job(string compid, string projectid, string isapprover, string staffcode, string superapprid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@isapprover", isapprover);
            param[2] = new SqlParameter("@projectid", projectid);
            param[3] = new SqlParameter("@staffcode", staffcode);
            param[4] = new SqlParameter("@superapprid", superapprid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_timesheet_job", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
                    {
                        mJobID = objComm.GetValue<int>(drrr["MJobId"].ToString()),
                        MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]

    public string config_update(string compid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<config_get_data> obj_Job = new List<config_get_data>();
        try
        {
        Common ob = new Common();
        SqlParameter[] param = new SqlParameter[1];
        param[0] = new SqlParameter("@Compid", compid);
        using (
            SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_get_config_data", param))
        {
            while (drrr.Read())
            {
                obj_Job.Add(new config_get_data()
                {
                    Compid = objComm.GetValue<int>(drrr["Compid"].ToString()),
                    CompConf_Id = objComm.GetValue<string>(drrr["CompConf_Id"].ToString()),
                    Multi_Roles = objComm.GetValue<Boolean>(drrr["Multi_Roles"].ToString()),
                    Dual_Approver = objComm.GetValue<Boolean>(drrr["Dual_Approver"].ToString()),
                    Leave_Year = objComm.GetValue<string>(drrr["Leave_Year"].ToString()),
                    WeekStart = objComm.GetValue<int>(drrr["WeekStart"].ToString()),
                    Narration = objComm.GetValue<Boolean>(drrr["Narration"].ToString()),
                    Expense = objComm.GetValue<Boolean>(drrr["Expense"].ToString()),
                    Location_mandatory = objComm.GetValue<Boolean>(drrr["Location_mandatory"].ToString()),
                    Edit_Reject_Timesheet = objComm.GetValue<Boolean>(drrr["Edit_Reject_Timesheet"].ToString()),
                    Hide_Billable = objComm.GetValue<Boolean>(drrr["Hide_Billable"].ToString()),
                    Timesheet_Decimals = objComm.GetValue<Boolean>(drrr["Timesheet_Decimals"].ToString()),
                    Max_hours = objComm.GetValue<double>(drrr["Max_hours"].ToString()),
                    Mon = objComm.GetValue<Boolean>(drrr["Mon"].ToString()),
                    Tue = objComm.GetValue<Boolean>(drrr["Tue"].ToString()),
                    Wed = objComm.GetValue<Boolean>(drrr["Wed"].ToString()),
                    Thu = objComm.GetValue<Boolean>(drrr["Thu"].ToString()),
                    Fri = objComm.GetValue<Boolean>(drrr["Fri"].ToString()),
                    Sat = objComm.GetValue<Boolean>(drrr["Sat"].ToString()),
                    Sun = objComm.GetValue<Boolean>(drrr["Sun"].ToString()),                    
                });
            }
        }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<config_get_data> tbl = obj_Job as IEnumerable<config_get_data>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Save_Config(config_get_data ts)
    { 
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<config_get_data> obj_Job = new List<config_get_data>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[16];
            param[0] = new SqlParameter("@Compid", ts.Compid);
            param[1] = new SqlParameter("@Multi_Roles", ts.Multi_Roles);
            param[2] = new SqlParameter("@Dual_Approver", ts.Dual_Approver);
            param[3] = new SqlParameter("@Leave_Year", ts.Leave_Year);
            param[4] = new SqlParameter("@Weekstart", ts.Wsrt);
            param[5] = new SqlParameter("@Narration", ts.Narration);
            param[6] = new SqlParameter("@Expense", ts.Expense);
            param[7] = new SqlParameter("@Location_mandatory", ts.Location_mandatory);
            param[8] = new SqlParameter("@Edit_Reject_Timesheet", ts.Edit_Reject_Timesheet);
            param[9] = new SqlParameter("@Hide_Billable", ts.Hide_Billable);
            param[10] = new SqlParameter("@Timesheet_Decimals", ts.Timesheet_Decimals);
            param[11] = new SqlParameter("@BBudget", ts.BBudget);
            param[12] = new SqlParameter("@Csv", ts.Csv);
            param[13] = new SqlParameter("@Max_hours", ts.Max_hours);
            param[14] = new SqlParameter("@Weekoff", ts.WOff);
            param[15] = new SqlParameter("@CompConf_Id", ts.CompConf_Id );
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_config_save", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new config_get_data()
                    {
                        Compid = objComm.GetValue<int>(drrr["Compid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<config_get_data> tbl = obj_Job as IEnumerable<config_get_data>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
}