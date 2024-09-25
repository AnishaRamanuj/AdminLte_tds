<%@ WebService Language="C#" Class="wsTimesheet_Viewer" %>

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
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.IO;
using System.Drawing;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsTimesheet_Viewer : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");


    [WebMethod(EnableSession = true)]
    public string getTimesheetInpurtrelatedDetails(int compid, int staffcode)
    {
        string result = "";
        string procname = "";
        if (Session["DualApprovers"].ToString() == "True")
        {
            procname = "usp_get_ViewerDetails";
        }
        else
        {
            procname = "usp_get_ViewerClientnProjectnJob";
        }
        CommonFunctions objComm = new CommonFunctions();
        List<TimesheetInputDepartmentWise_Approver> obj_ts = new List<TimesheetInputDepartmentWise_Approver>();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, procname, param))
            {
                #region DepartmentWise

                while (drrr.Read())
                {
                    obj_ts.Add(new TimesheetInputDepartmentWise_Approver()
                    {
                        DepId = objComm.GetValue<string>(drrr["DepId"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        Staff_Roll = objComm.GetValue<string>(drrr["Staff_Roll"].ToString()),
                        e_Timesheet = objComm.GetValue<int>(drrr["ET"].ToString()),
                    });
                }


                List<tbl_Viewer_Job_Assign> listjobassign = new List<tbl_Viewer_Job_Assign>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listjobassign.Add(new tbl_Viewer_Job_Assign()
                            {
                                Job_Assign_id = objComm.GetValue<int>(drrr["Job_Assign_id"].ToString()),
                                Jobid = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                                Assign_Id = objComm.GetValue<int>(drrr["Assign_Id"].ToString()),
                                Dept_Id = objComm.GetValue<int>(drrr["Dept_Id"].ToString()),

                            });
                        }
                    }
                }

                List<Tbl_Viewer_Assign_Details> listAssign_Details = new List<Tbl_Viewer_Assign_Details>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAssign_Details.Add(new Tbl_Viewer_Assign_Details()
                            {
                                Assign_Id = objComm.GetValue<int>(drrr["Assign_Id"].ToString()),
                                //Depid = objComm.GetValue<int>(drrr["Depid"].ToString()),
                                mJobid = objComm.GetValue<int>(drrr["mJobid"].ToString()),
                                MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                            });
                        }
                    }
                }

                List<tbl_job_ts> listmaster_ts = new List<tbl_job_ts>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listmaster_ts.Add(new tbl_job_ts()
                            {
                                JobId = objComm.GetValue<int>(drrr["JobId"].ToString()),
                                CLTId = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                //CompId = objComm.GetValue<int>(drrr["CompId"].ToString()),

                                ProjectID = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                                ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                                ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),

                            });
                        }
                    }
                }


                List<tbl_Staff> list_staff = new List<tbl_Staff>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            list_staff.Add(new tbl_Staff()
                            {

                                StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),

                            });
                        }
                    }
                }



                foreach (var item in obj_ts)
                {
                    item.list_Assign_Details = listAssign_Details;
                    //item.list_MultiDep = listmDep;
                    item.list_Job_Assign = listjobassign;
                    item.list_job_master_ts = listmaster_ts;
                    item.list_Staffmaster = list_staff;
                }
            }
            #endregion




            IEnumerable<TimesheetInputDepartmentWise_Approver> tbl = obj_ts as IEnumerable<TimesheetInputDepartmentWise_Approver>;
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
    public string getTimesheets(int compid, int staffcode, int cid, int pid, int jid, int sid, int PageIndex, int PageSize, int did, string Sts, string Staff_Role, string fdt, string tdt, int Task)
    {
        string result = "";
        string procname = "";
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Timesheets_data> obj_ts = new List<tbl_Timesheets_data>();
        if (Session["DualApprovers"].ToString() == "True")
        {
            result = getDualApproverTimesheets(compid, staffcode, cid, pid, jid, sid, PageIndex, PageSize, did, Sts, Staff_Role, fdt, tdt);

        }
        else
        {
            if (Staff_Role == "Staff")
            {

                procname = "usp_getViewer_Staff_Timesheet_Deptwise";
            }
            else
            {
                procname = "usp_getViewer_Approver_Timesheet_Deptwise";
            }

            try
            {

                string fromdate = fdt != "" ? Convert.ToDateTime(fdt, ci).ToString("MM/dd/yyyy") : null;
                string todate = tdt != "" ? Convert.ToDateTime(tdt, ci).ToString("MM/dd/yyyy") : null;

                SqlParameter[] param = new SqlParameter[14];
                param[0] = new SqlParameter("@compid", compid);
                param[1] = new SqlParameter("@staffcode", staffcode);
                param[2] = new SqlParameter("@sts", Sts);
                param[3] = new SqlParameter("@cltid", cid);
                param[4] = new SqlParameter("@projectid", pid);
                param[5] = new SqlParameter("@MJid", jid);
                param[6] = new SqlParameter("@Staff_Role", Staff_Role);
                param[7] = new SqlParameter("@Sid", sid);
                param[8] = new SqlParameter("@FromDT", fromdate);
                param[9] = new SqlParameter("@ToDT", todate);
                param[10] = new SqlParameter("@PageIndex", PageIndex);
                param[11] = new SqlParameter("@PageSize", PageSize);
                param[12] = new SqlParameter("@MDeptid", did);
                param[13] = new SqlParameter("@task", Task);

                DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, procname, param);
                using (SqlDataReader rs = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, procname, param))
                {

                    while (rs.Read())
                    {
                        obj_ts.Add(new tbl_Timesheets_data()
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
                            Srno = objComm.GetValue<int>(rs["Srno"].ToString()),
                            TSId = objComm.GetValue<int>(rs["TSId"].ToString()),
                            Narration = objComm.GetValue<string>(rs["Narration"].ToString()),
                            OpeAmt = objComm.GetValue<float>(rs["opeamt"].ToString()),
                            Edit_Billing_Hrs = objComm.GetValue<string>(rs["EditedBilling_Hrs"].ToString()),
                        });
                    }
                }
                IEnumerable<tbl_Timesheets_data> tbl = obj_ts as IEnumerable<tbl_Timesheets_data>;
                var obbbbb = tbl;
                result = new JavaScriptSerializer().Serialize(tbl);
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }
        }

        return result;
    }



    public string getDualApproverTimesheets(int compid, int staffcode, int cid, int pid, int jid, int sid, int PageIndex, int PageSize, int did, string Sts, string Staff_Role, string fdt, string tdt)
    {
        string result = "";
        string procname = "";
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> obj_ts = new List<timesheet_table>();

        procname = "usp_getViewer_Timesheet";

        try
        {

            string fromdate = fdt != "" ? Convert.ToDateTime(fdt, ci).ToString("MM/dd/yyyy") : null;
            string todate = tdt != "" ? Convert.ToDateTime(tdt, ci).ToString("MM/dd/yyyy") : null;

            SqlParameter[] param = new SqlParameter[12];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@sts", Sts);
            param[3] = new SqlParameter("@cltid", cid);
            param[4] = new SqlParameter("@projectid", pid);
            param[5] = new SqlParameter("@MJid", jid);
            param[6] = new SqlParameter("@Staff_Role", Staff_Role);
            param[7] = new SqlParameter("@Sid", sid);
            param[8] = new SqlParameter("@FromDT", fromdate);
            param[9] = new SqlParameter("@ToDT", todate);
            param[10] = new SqlParameter("@PageIndex", PageIndex);
            param[11] = new SqlParameter("@PageSize", PageSize);


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


    [WebMethod(EnableSession = true)]
    public string Update_Approve_Reject(timesheet_table ts)
    {
        string result = "";
        string procname = "";
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> obj_ts = new List<timesheet_table>();
        try
        {
            if (Session["DualApprovers"].ToString() == "True")
            {
                procname = "usp_Approver_DualTimesheet_Deptwise";
            }
            else
            {
                procname = "usp_Approver_Timesheet_Deptwise";
            }
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", ts.CompId);
            param[1] = new SqlParameter("@staffcode", ts.JobApprover);
            param[2] = new SqlParameter("@sts", ts.Status);
            param[3] = new SqlParameter("@Tsid", ts.Timesheets);


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
    public string saveEditedTimesheets(timesheet_table ts)
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

            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@StaffCode", ts.StaffCode);
            param[1] = new SqlParameter("@CompId", ts.CompId);
            param[2] = new SqlParameter("@TotalTime", ts.TotalTime);
            param[3] = new SqlParameter("@TSId", ts.TSId);
            param[4] = new SqlParameter("@Status", ts.Status);
            param[5] = new SqlParameter("@Narration", ts.Narration);
            param[6] = new SqlParameter("@Billable", i);
            var TSID = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_SaveEditedTimesheetInput_Billable", param);
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

    //[WebMethod]
    //public string bind_Staff(int cid, int s, int apr, int cview)
    //{   ////// cid: ' + cid + ',s: ' + s + ',apr:' + apr + ',cview
    //    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    //    List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
    //    try
    //    {
    //        Common ob = new Common();
    //        SqlParameter[] param = new SqlParameter[4];
    //        param[0] = new SqlParameter("@Compid", cid);
    //        param[1] = new SqlParameter("@Staffcode", s);
    //        param[2] = new SqlParameter("@isApprover", apr);
    //        param[3] = new SqlParameter("@StaffMode", cview);


    //        using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_get_staff_timesheet", param))
    //        {
    //            while (drrr.Read())
    //            {
    //                obj_Job.Add(new vw_JobnClientnStaff()
    //                {
    //                    StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
    //                    StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),

    //                });
    //            }
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }

    //    IEnumerable<vw_JobnClientnStaff> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff>;
    //    var obbbbb = tbl;
    //    return new JavaScriptSerializer().Serialize(tbl);

    //} 

    [WebMethod]
    public string StaffSummary(int compid, string fromDate, string ToDate, int staffcode, int sid, int projctid, int jobid, int cltid, string staff_Role)
    {
        string procname = "";
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();

        if (staff_Role == "Staff")
        {
            procname = "usp_GetStaffSummary_Staff";
        }
        else
        {
            procname = "usp_GetStaffSummary_Staff_Project_StaffProject";
        }


        try
        {
            string fromdate = fromDate != "" ? Convert.ToDateTime(fromDate, ci).ToString("MM/dd/yyyy") : null;
            string todate = ToDate != "" ? Convert.ToDateTime(ToDate, ci).ToString("MM/dd/yyyy") : null;
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@FromDT", fromdate);
            param[3] = new SqlParameter("@ToDT", todate);
            param[4] = new SqlParameter("@sid", sid);
            param[5] = new SqlParameter("@projectid", projctid);
            param[6] = new SqlParameter("@MJid", jobid);
            //param[7] = new SqlParameter("@cltid", cltid);
            param[7] = new SqlParameter("@MDeptid", cltid);


            /////DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_GetStaffSummary_Staff_Project_StaffProject", param);//for chacking the Data 
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, procname, param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
                    {
                        SrNo = objComm.GetValue<int>(drrr["sino"].ToString()),
                        StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Date = objComm.GetValue<string>(drrr["d1"].ToString()),
                        Date2 = objComm.GetValue<string>(drrr["d2"].ToString()),
                        Date3 = objComm.GetValue<string>(drrr["d3"].ToString()),
                        Date4 = objComm.GetValue<string>(drrr["d4"].ToString()),
                        Date5 = objComm.GetValue<string>(drrr["d5"].ToString()),
                        Date6 = objComm.GetValue<string>(drrr["d6"].ToString()),
                        Date7 = objComm.GetValue<string>(drrr["d7"].ToString()),
                        Total = objComm.GetValue<string>(drrr["Total"].ToString()),
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

}