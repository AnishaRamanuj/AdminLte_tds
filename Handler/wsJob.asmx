<%@ WebService Language="C#" Class="wsJob" %>

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
public class wsJob  : System.Web.Services.WebService  
{
    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]
    public string BindJobList(int compid, string UserType, string FromDate, string ToDate, string status, string Staffcode, string bill)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_JobMaster> obj_Job = new List<tbl_JobMaster>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@UserType", UserType);
            param[2] = new SqlParameter("@FromDate", Convert.ToDateTime(FromDate, ci));
            param[3] = new SqlParameter("@ToDate", Convert.ToDateTime(ToDate, ci));
            param[4] = new SqlParameter("@TStatus", status);
            param[5] = new SqlParameter("@Billable", bill);
            param[6] = new SqlParameter("@StaffCode", Staffcode);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_report_JobList_Name", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_JobMaster()
                    {
                        mJobid  = objComm.GetValue<int>(drrr["mJobid"].ToString()),
                        mJobName = objComm.GetValue<string>(drrr["mjobName"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_JobMaster> tbl = obj_Job as IEnumerable<tbl_JobMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    public static JobMaster JB = new JobMaster();
    [WebMethod]
    public string JobDetails(int jobid, int cid)
    {
        tbl_JobMaster obj = new tbl_JobMaster();

        obj.CompId = cid;
        obj.Jobid = jobid;
            IEnumerable<tbl_JobMaster> tbl = JB.JDetails(obj);
            var obbbbb = tbl;
            return new JavaScriptSerializer().Serialize(tbl);
   }


    [WebMethod]
    public string insertJobStatus(int jobid, int cid, string sts)
    {
        List<tbl_JobMaster> obj_Job = new List<tbl_JobMaster>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", cid);
            param[1] = new SqlParameter("@jobid", jobid);
            param[2] = new SqlParameter("@sts", sts);
            param[3] = new SqlParameter("@jType", "Status");

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Insert_JobDetails", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_JobMaster()
                    {
                        Errmsg = "Job Status Updated Successfully",
                    });
                }
            }
        }
        catch (Exception)
        {
            obj_Job.Add(new tbl_JobMaster()
            {
                Errmsg = "Job Status Updation Failed",
            });
        }
        IEnumerable<tbl_JobMaster> tbl = obj_Job as IEnumerable<tbl_JobMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string insertJobBillable(int jobid, int cid, string bill)
    {
        List<tbl_JobMaster> obj_Job = new List<tbl_JobMaster>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", cid);
            param[1] = new SqlParameter("@jobid", jobid);
            param[2] = new SqlParameter("@sts", bill);
            param[3] = new SqlParameter("@jType", "Bill");
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Insert_JobDetails", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_JobMaster()
                    {
                        Errmsg = "Job Billable Updated Successfully",
                    });
                }
            }
        }
        catch (Exception)
        {
            obj_Job.Add(new tbl_JobMaster()
            {
                Errmsg = "Job Billable Updation Failed",
            });
        }
        IEnumerable<tbl_JobMaster> tbl = obj_Job as IEnumerable<tbl_JobMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string insertJobEndDT(int jobid, int cid, string endDT)
    {
        List<tbl_JobMaster> obj_Job = new List<tbl_JobMaster>();
        try
        {
            CultureInfo info = new CultureInfo("en-GB", false);
            //DateTime dttodate = new DateTime(1900, 1, 1);
            //String _dateFormat = "dd/MM/yyyy";

            //if (endDT != "" && !DateTime.TryParseExact(endDT.Trim(), _dateFormat, info, DateTimeStyles.AllowWhiteSpaces, out dttodate))
            //{
            //}
            endDT = Convert.ToDateTime(endDT, ci).ToString("MM/dd/yyyy");
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", cid);
            param[1] = new SqlParameter("@jobid", jobid);
            param[2] = new SqlParameter("@sts", endDT);
            param[3] = new SqlParameter("@jType", "EndDT");
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Insert_JobDetails", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_JobMaster()
                    {
                        Errmsg = "Job End Date Updated Successfully",
                    });
                }

            }
            
            
        }
        catch (Exception)
        {
            obj_Job.Add(new tbl_JobMaster()
            {
                Errmsg = "Job End Date Updation Failed",
            });
        }
        IEnumerable<tbl_JobMaster> tbl = obj_Job as IEnumerable<tbl_JobMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string bindStaff(int compid, int jobid)
    {
        vw_JobnClientnStaff obj = new vw_JobnClientnStaff();
        obj.CompId = Convert.ToInt32(compid);
        obj.Jobid = jobid;
        obj.pageIndex = 1;
        obj.pageNewSize = 3000;
        IEnumerable<vw_JobnClientnStaff> tbl = JB.SqlDR_GetIenumrable_Edit_Staff(obj);
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string bindDept(int compid, int jobid)
    {
        vw_JobnClientnStaff obj = new vw_JobnClientnStaff();
        obj.CompId = Convert.ToInt32(compid);
        obj.Jobid = Convert.ToInt32(jobid);
        obj.pageIndex = 1;
        obj.pageNewSize = 3000;
        IEnumerable<vw_JobnClientnStaff> tbl = JB.SqlDR_GetIenumrable_Edit_Dept(obj);
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    
    [WebMethod]
    public string bindApprover(int compid, int jobid)
    {
        vw_JobnClientnStaff obj = new vw_JobnClientnStaff();
        obj.CompId = Convert.ToInt32(compid);
        obj.Jobid = jobid;
        obj.pageIndex=1;
        obj.pageNewSize = 3000;
        IEnumerable<vw_JobnClientnStaff> tbl = JB.SqlDR_GetIenumrable_Edit_Approver(obj);
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
        
    }



    [WebMethod]
    public string insertJobStaff(int jobid, int cid, string stf)
    {
        List<tbl_JobMaster> obj_Job = new List<tbl_JobMaster>();
        try
        {


            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", cid);
            param[1] = new SqlParameter("@jobid", jobid);
            param[2] = new SqlParameter("@stf", stf);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Insert_JobStaff", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_JobMaster()
                    {
                        Errmsg = "Job Staff Updated Successfully",
                    });
                }
            }
        }
        catch (Exception)
        {
            obj_Job.Add(new tbl_JobMaster()
            {
                Errmsg = "Job Staff Updation Failed",
            });
        }
        IEnumerable<tbl_JobMaster> tbl = obj_Job as IEnumerable<tbl_JobMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    [WebMethod]
    public string insertJobApprover(int jobid, int cid, string appr, int sappr)
    {
        List<tbl_JobMaster> obj_Job = new List<tbl_JobMaster>();
        try
        {


            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", cid);
            param[1] = new SqlParameter("@jobid", jobid);
            param[2] = new SqlParameter("@appr", appr);
            param[3] = new SqlParameter("@sappr", sappr);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Insert_JobApprover", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_JobMaster()
                    {
                        Errmsg = "Job Approver Updated Successfully",
                    });
                }
            }
        }
        catch (Exception)
        {
            obj_Job.Add(new tbl_JobMaster()
            {
                Errmsg = "Job Approver Updation Failed",
            });
        }
        IEnumerable<tbl_JobMaster> tbl = obj_Job as IEnumerable<tbl_JobMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
}