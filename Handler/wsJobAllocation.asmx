<%@ WebService Language="C#" Class="wsJobAllocation" %>

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
public class wsJobAllocation : System.Web.Services.WebService
{
    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]
    public string bind_Client(string compid, string jobid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_bindclientproject> obj_Job = new List<vw_JobnClientnStaff_bindclientproject>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Jobid", jobid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_Job_client", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_bindclientproject()
                    {
                        Cltid = objComm.GetValue<int>(drrr["cltid"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_bindclientproject> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_bindclientproject>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod]
    public string Bind_Project(string compid, string cid, string jobid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_bindclientproject> obj_Job = new List<vw_JobnClientnStaff_bindclientproject>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cid);
            param[2] = new SqlParameter("@jobid", jobid);
            //param[2] = new SqlParameter("@JType", E);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_Job_Project", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_bindclientproject()
                    {
                        projectid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        projectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_bindclientproject> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_bindclientproject>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

            [WebMethod]
    public string Bind_ProjectStartEnd(string compid, int prjid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_bindclientproject> obj_Job = new List<vw_JobnClientnStaff_bindclientproject>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@prj", prjid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_GetProjectDate", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_bindclientproject()
                    {
                        Strtdt = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        Endt = objComm.GetValue<string>(drrr["EndDate"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_bindclientproject> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_bindclientproject>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]
    public string bind_Jobname(string compid, string jobid, string pid, string lnk)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_bindclientproject> obj_Job = new List<vw_JobnClientnStaff_bindclientproject>();
        try
        {
            string sp = "usp_Bind_Job_jobname";

            Common ob = new Common();
            SqlParameter[] param;
            if (lnk == "1")
            {
                param = new SqlParameter[3];
                param[0] = new SqlParameter("@compid", compid);
                param[1] = new SqlParameter("@jobid", jobid);
                param[2] = new SqlParameter("@pid", pid);
                sp = "usp_Bind_Job_jobname_Link";
            }
            else
            {
                param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", compid);
                param[1] = new SqlParameter("@jobid", jobid);
            }
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, sp, param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_bindclientproject()
                    {
                        mJobID = objComm.GetValue<int>(drrr["mJobid"].ToString()),
                        MJobName = objComm.GetValue<string>(drrr["mjobName"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }


        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_bindclientproject> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_bindclientproject>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]
    public string bind_Task(string compid, string jobid, string mjid, string lnk)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_bindclientproject> obj_Job = new List<vw_JobnClientnStaff_bindclientproject>();
        try
        {
            string sp = "usp_Bind_Job_Task";
            Common ob = new Common();
            SqlParameter[] param;

            if (lnk == "1")
            {
                param = new SqlParameter[3];
                param[0] = new SqlParameter("@compid", compid);
                param[1] = new SqlParameter("@jobid", jobid);
                param[2] = new SqlParameter("@mjid", mjid);
                sp = "usp_Bind_Job_Task_Link";
            }
            else
            {
                param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", compid);
                param[1] = new SqlParameter("@jobid", jobid);
            }

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, sp, param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_bindclientproject()
                    {
                        Task_Id = objComm.GetValue<int>(drrr["TaskId"].ToString()),
                        Task_name = objComm.GetValue<string>(drrr["TaskName"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_bindclientproject> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_bindclientproject>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }
    [WebMethod]
    public string bind_Assigment(string compid, string jobid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<JobAllocation> obj_Job = new List<JobAllocation>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", jobid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_Job_Assignment", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new JobAllocation()
                    {
                        Assign_Id = objComm.GetValue<int>(drrr["Assign_Id"].ToString()),
                        Assign_Name = objComm.GetValue<string>(drrr["Assign_Name"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                        DeptId = objComm.GetValue<int>(drrr["Depid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<JobAllocation> tbl = obj_Job as IEnumerable<JobAllocation>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]
    public string bind_AssignDepartment(string compid, string aid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_bindclientproject> obj_Job = new List<vw_JobnClientnStaff_bindclientproject>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@aid", aid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_Job_Department", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_bindclientproject()
                    {
                        DeptId = objComm.GetValue<int>(drrr["Depid"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drrr["departmentname"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_bindclientproject> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_bindclientproject>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }




    [WebMethod]
    public string bind_Staff(string compid, string jobid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_jbApprover> obj_Job = new List<vw_JobnClientnStaff_jbApprover>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", jobid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_Job_Staff", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_jbApprover()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["staffcode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                        DeptId = objComm.GetValue<int>(drrr["Depid"].ToString()),
                        /// IsApprover=objComm.GetValue<bool>(drrr["hod"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_jbApprover> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_jbApprover>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod]
    public string bind_Staff_Vals(string compid, string jobid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Job_Staff_Details> obj_Job = new List<tbl_Job_Staff_Details>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", jobid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_Job_Staff_details", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_Job_Staff_Details()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["staffcode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                        DeptId = objComm.GetValue<int>(drrr["Depid"].ToString()),
                        PerHrs =objComm.GetValue<string>(drrr["perhrs"].ToString()),
                        Fromdate = objComm.GetValue<string>(drrr["FromDate"].ToString()),
                        Todate=objComm.GetValue<string>(drrr["ToDate"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Job_Staff_Details> tbl = obj_Job as IEnumerable<tbl_Job_Staff_Details>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]
    public string bind_Approver(int compid, int jobid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_jbApprover> obj_Job = new List<vw_JobnClientnStaff_jbApprover>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", jobid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_Job_SubApprover", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_jbApprover()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        //SuperAppId = objComm.GetValue<int>(drrr["SuperAppId"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_jbApprover> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_jbApprover>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod]
    public string bind_StaffDepartment(string compid, string jobid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_bindclientproject> obj_Job = new List<vw_JobnClientnStaff_bindclientproject>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", jobid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_Job_StaffDepartment", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_bindclientproject()
                    {
                        DeptId = objComm.GetValue<int>(drrr["Depid"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drrr["departmentname"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_bindclientproject> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_bindclientproject>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string GetDetails(vw_JobnClientnStaff_GetDetails currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_GetDetails> obj_Job = new List<vw_JobnClientnStaff_GetDetails>();
        try
        {

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@hdndpt", currobj.hdndpt);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Get_JobAllocation_Details", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_GetDetails()
                    {
                        projectid = objComm.GetValue<int>(drrr["projectid"].ToString()),
                        Cltid = objComm.GetValue<int>(drrr["Cltid"].ToString()),
                        Jobid = objComm.GetValue<int>(drrr["jobid"].ToString()),
                        jStatus = objComm.GetValue<string>(drrr["jobstatus"].ToString()),
                        mJobID = objComm.GetValue<int>(drrr["mjobid"].ToString()),
                        CreationDate = objComm.GetValue<string>(drrr["ST"].ToString()),
                        todate = objComm.GetValue<string>(drrr["Ed"].ToString()),
                        Billable = objComm.GetValue<string>(drrr["Bill"].ToString()),
                        SuperAppId = objComm.GetValue<int>(drrr["sapp"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_GetDetails> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_GetDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    [WebMethod]
    public string GetapprDetails(vw_JobnClientnStaff_GetDetails currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_GetDetails> obj_Job = new List<vw_JobnClientnStaff_GetDetails>();
        try
        {

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@hdndpt", currobj.hdndpt);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Get_supappr_Details", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_GetDetails()
                    {
                        SuperAppId = objComm.GetValue<int>(drrr["sapp"].ToString()),
                        MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        Cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_GetDetails> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_GetDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetdateDetails(vw_JobnClientnStaff_GetDetails currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_GetDetails> obj_Job = new List<vw_JobnClientnStaff_GetDetails>();
        try
        {

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@hdndpt", currobj.hdndpt);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Get_dateDetails", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_GetDetails()
                    {

                        CreationDate = objComm.GetValue<string>(drrr["ST"].ToString()),
                        todate = objComm.GetValue<string>(drrr["Ed"].ToString()),
                        MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),


                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_GetDetails> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_GetDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetbillDetails(vw_JobnClientnStaff_GetDetails currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_GetDetails> obj_Job = new List<vw_JobnClientnStaff_GetDetails>();
        try
        {

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@hdndpt", currobj.hdndpt);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Get_billDetails", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_GetDetails()
                    {

                        Billable = objComm.GetValue<string>(drrr["Bill"].ToString()),
                        MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),


                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_GetDetails> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_GetDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetstatusDetails(vw_JobnClientnStaff_GetDetails currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_GetDetails> obj_Job = new List<vw_JobnClientnStaff_GetDetails>();
        try
        {

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@hdndpt", currobj.hdndpt);
            using (SqlDataReader drrrjob = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Get_JobstatusDetails", param))
            {
                while (drrrjob.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_GetDetails()
                    {

                        jStatus = objComm.GetValue<string>(drrrjob["jobstatus"].ToString()),
                        MJobName = objComm.GetValue<string>(drrrjob["MJobName"].ToString()),
                        ClientName = objComm.GetValue<string>(drrrjob["ClientName"].ToString()),


                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_GetDetails> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_GetDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    [WebMethod]

    public string Save_Job(Job_AddEdit currobj)
    {

        string dt=Convert.ToDateTime(currobj.fromdate, ci).ToString();

        string Strtdate = currobj.fromdate != "" ? Convert.ToDateTime(currobj.fromdate, ci).ToString("MM/dd/yyyy") : null;
        string Endate = currobj.todate != "" ? Convert.ToDateTime(currobj.todate, ci).ToString("MM/dd/yyyy") : null;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Job_AddEdit> obj_Job = new List<Job_AddEdit>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[16];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@Cltid", currobj.Cltid);
            param[3] = new SqlParameter("@projectid", currobj.projectid);
            param[4] = new SqlParameter("@SuperAppId", currobj.SuperAppId);
            //param[5] = new SqlParameter("@fromdate", Convert.ToDateTime(currobj.fromdate, ci).ToString());
            //param[6] = new SqlParameter("@todate", Convert.ToDateTime(currobj.todate, ci).ToString());
            param[5] = new SqlParameter("@fromdate", Strtdate);
            param[6] = new SqlParameter("@todate", Endate);
            param[7] = new SqlParameter("@Billable", currobj.Billable);
            param[8] = new SqlParameter("@jStatus", currobj.jStatus);
            param[9] = new SqlParameter("@hdndpt", currobj.hdndpt);
            param[10] = new SqlParameter("@hdnAllAdpt", currobj.hdnAllAdpt);
            param[11] = new SqlParameter("@mJobID", currobj.mJobID);
            param[12] = new SqlParameter("@hdntsk", currobj.hndtsk);
            param[13] = new SqlParameter("@hdnAlltsk", currobj.hdnAlltsk);
            param[14] = new SqlParameter("@hdnAllstf", currobj.hdnAllstf);
            param[15] = new SqlParameter("@hdnAllapp", currobj.hdnAllapp);

            var spname = "";

            if (Convert.ToInt32(currobj.Jobid) > 0)
            {
                spname = "usp_Update_JobAllocation";
            }
            else
            {
                spname = "usp_Insert_JobAllocation";
            }

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, spname, param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Job_AddEdit()
                    {
                        Jobid = objComm.GetValue<int>(drrr["jobid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Job_AddEdit> tbl = obj_Job as IEnumerable<Job_AddEdit>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]

    public string updatestatus(vw_JobnClientnStaff_GetDetails currobj)
    {


        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_GetDetails> obj_Job = new List<vw_JobnClientnStaff_GetDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@jStatus", currobj.jStatus);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_updatejobstatus", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_GetDetails()
                    {

                        jStatus = objComm.GetValue<string>(drrr["JobStatus"].ToString()),


                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_GetDetails> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_GetDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]

    public string updatenddate(vw_JobnClientnStaff_GetDetails currobj)
    {


        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_GetDetails> obj_Job = new List<vw_JobnClientnStaff_GetDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@todate", Convert.ToDateTime(currobj.jStatus, ci).ToString());
            //string s = Convert.ToDateTime(currobj.jStatus).ToString();

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_updatejobenddate", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_GetDetails()
                    {

                        jStatus = objComm.GetValue<string>(drrr["JobStatus"].ToString()),


                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_GetDetails> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_GetDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]

    public string updatebillable(vw_JobnClientnStaff_GetDetails currobj)
    {


        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_GetDetails> obj_Job = new List<vw_JobnClientnStaff_GetDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@Billable", currobj.jStatus);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_updatejobbillable", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_GetDetails()
                    {

                        jStatus = objComm.GetValue<string>(drrr["JobStatus"].ToString()),


                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_GetDetails> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_GetDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]

    public string updateapprover(vw_JobnClientnStaff_GetDetails currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_GetDetails> obj_Job = new List<vw_JobnClientnStaff_GetDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@SuperAppId", currobj.SuperAppId);
            param[3] = new SqlParameter("@Cltid", currobj.Cltid);
            param[4] = new SqlParameter("@hdnAllapp", currobj.hdnAllapp);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_updateapprover", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_GetDetails()
                    {

                        jStatus = objComm.GetValue<string>(drrr["JobStatus"].ToString()),


                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_GetDetails> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_GetDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]

    public string updatestaff(vw_JobnClientnStaff_GetDetails currobj)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_GetDetails> obj_Job = new List<vw_JobnClientnStaff_GetDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@hdnAllstf", currobj.hdnAllstf);
            // param[3] = new SqlParameter("@Cltid", currobj.Cltid);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_updatestaff", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_GetDetails()
                    {

                        jStatus = objComm.GetValue<string>(drrr["JobStatus"].ToString()),


                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_GetDetails> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_GetDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string bind_JobGrid(vw_JobnClientnStaff_bindclientproject currobj)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@PageIndex", currobj.pageIndex);
            param[2] = new SqlParameter("@PageSize", currobj.pageNewSize);
            param[3] = new SqlParameter("@JobStatus", currobj.jStatus);
            param[4] = new SqlParameter("@Cname", currobj.ClientName);
            param[5] = new SqlParameter("@jname", currobj.MJobName);
            param[6] = new SqlParameter("@project", currobj.projectName);
            param[7] = new SqlParameter("@hdndpt", currobj.hdndpt);

            ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_Bind_NewJobAllocation", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();

    }

    [WebMethod]

    public string Delete_Job(vw_JobnClientnStaff_bindclientproject currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DBAccess db = new DBAccess();
        DBAccess.PrintDelete(currobj.IP ,"Manage Job/Project", currobj.User, currobj.UType, currobj.dt);
        List<vw_JobnClientnStaff_bindclientproject> obj_Job = new List<vw_JobnClientnStaff_bindclientproject>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@hdndpt", currobj.hdndpt);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Delete_JobAllocation", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_bindclientproject()
                    {
                        Jobid = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                        messg = objComm.GetValue<string>(drrr["msg"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_bindclientproject> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_bindclientproject>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    public string GetBudgetingtype(vw_JobnClientnStaff_bindclientproject currobj)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_bindclientproject> obj_Job = new List<vw_JobnClientnStaff_bindclientproject>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);

            // param[3] = new SqlParameter("@Cltid", currobj.Cltid);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_updatestaff", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_bindclientproject()
                    {

                        ClientName = objComm.GetValue<string>(drrr["JobStatus"].ToString()),
                        projectName = objComm.GetValue<string>(drrr["JobStatus"].ToString()),


                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_bindclientproject> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_bindclientproject>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    /// <summary>
    /// /////////////////////////////////////////////////////////// Budgeting /////////////////////////////
    /// </summary>
    /// <param name="currobj"></param>
    /// <returns></returns>
    [WebMethod]
    public string bind_Job_Client_budget(vw_JobnClientnStaff_bindclientproject currobj)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_bindclientproject> obj_Job = new List<vw_JobnClientnStaff_bindclientproject>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@Jobid", currobj.Jobid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_Job_client_Budget", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff_bindclientproject()
                    {

                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),

                        projectName = objComm.GetValue<string>(drrr["projectname"].ToString()),

                        MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),

                        BudgetSelection = objComm.GetValue<string>(drrr["BudgetingSelection"].ToString()),

                        Cltid = objComm.GetValue<int>(drrr["cltid"].ToString()),



                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_bindclientproject> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_bindclientproject>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    //[WebMethod]
    //public string bind_Project_budgeting(vw_JobnClientnStaff_jbApprover currobj)
    //{

    //    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    //    List<vw_JobnClientnStaff_jbApprover> obj_Job = new List<vw_JobnClientnStaff_jbApprover>();
    //    try
    //    {
    //        Common ob = new Common();
    //        SqlParameter[] param = new SqlParameter[2];
    //        param[0] = new SqlParameter("@compid", currobj.CompId);
    //        param[1] = new SqlParameter("@Jobid", currobj.Jobid);

    //        using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_GetSataffBudgetedStaffOnEditJobAdd", param))
    //        {
    //            while (drrr.Read())
    //            {
    //                obj_Job.Add(new vw_JobnClientnStaff_jbApprover()
    //                {

    //                    Budgethours = objComm.GetValue<string>(drrr["BudHours"].ToString()),

    //                    BudgetAmount = objComm.GetValue<string>(drrr["BudAmt"].ToString()),

    //                    BudgetOthAmount = objComm.GetValue<string>(drrr["OtherAmt"].ToString()),

    //                });
    //            }

    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }

    //    IEnumerable<vw_JobnClientnStaff_jbApprover> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_jbApprover>;
    //    var obbbbb = tbl;
    //    return new JavaScriptSerializer().Serialize(tbl);

    //}

    //[WebMethod]
    //public string bindStaff_Budgeting(vw_JobnClientnStaff_jbApprover currobj)
    //{
    //    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    //    List<vw_JobnClientnStaff_jbApprover> obj_Job = new List<vw_JobnClientnStaff_jbApprover>();
    //    try
    //    {
    //        Common ob = new Common();
    //        SqlParameter[] param = new SqlParameter[4];
    //        param[0] = new SqlParameter("@CompanyID", currobj.CompId);
    //        param[1] = new SqlParameter("@PageIndex", currobj.pageIndex);
    //        param[2] = new SqlParameter("@PageSize", currobj.pageNewSize);
    //        param[3] = new SqlParameter("@Jobid", currobj.Jobid);
    //        //DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_eJob_Allocation_Staff", param);
    //        using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Staff_Budgeting_List", param))
    //        {
    //            while (drrr.Read())
    //            {
    //                obj_Job.Add(new vw_JobnClientnStaff_jbApprover()
    //                {
    //                    StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
    //                    DeptId = objComm.GetValue<int>(drrr["DepId"].ToString()),
    //                    DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
    //                    DesignationName = objComm.GetValue<string>(drrr["DesignationName"].ToString()),/////////////Designation Name
    //                    StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),

    //                    BudgetAmount = objComm.GetValue<string>(drrr["BudgetAmount"].ToString()),
    //                    Budgethours = objComm.GetValue<string>(drrr["Budgethours"].ToString()),
    //                    PlanedDrawing = objComm.GetValue<string>(drrr["PlanedDrawing"].ToString()),//////////planed Drawings
    //                    AllocatedHours = objComm.GetValue<string>(drrr["AllocatedHours"].ToString()),//////////Allocated Hours
    //                    StaffHourlyRate = objComm.GetValue<string>(drrr["HourlyCharges"].ToString()),//////////Hourly Charges     

    //                    ischecked = objComm.GetValue<int>(drrr["isNew"].ToString()),//////////Hourly Charges     
    //                });
    //            }

    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }

    //    IEnumerable<vw_JobnClientnStaff_jbApprover> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_jbApprover>;
    //    var obbbbb = tbl;
    //    return new JavaScriptSerializer().Serialize(tbl);
    //}


    //[WebMethod]
    //public string GetServerJobWiseBudgetDetails(vw_JobnClientnStaff_jbApprover currobj)
    //{
    //    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    //    List<vw_JobnClientnStaff_jbApprover> obj_Job = new List<vw_JobnClientnStaff_jbApprover>();
    //    try
    //    {

    //        Common ob = new Common();
    //        SqlParameter[] param = new SqlParameter[2];
    //        param[0] = new SqlParameter("@compid", currobj.CompId);
    //        param[1] = new SqlParameter("@jobid", currobj.Jobid);
    //        using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Ajax_EditJob_GetServerJobWiseBudgetDetails", param))
    //        {
    //            while (drrr.Read())
    //            {
    //                obj_Job.Add(new vw_JobnClientnStaff_jbApprover()
    //                {

    //                    StaffCode = objComm.GetValue<int>(drrr["otherAmt"].ToString()),
    //                    todate = objComm.GetValue<string>(drrr["todate"].ToString()),
    //                    fromdate = objComm.GetValue<string>(drrr["fromdate"].ToString()),
    //                    BudgetAmount = objComm.GetValue<string>(drrr["BudAmt"].ToString()),
    //                    Budgethours = objComm.GetValue<string>(drrr["Budhours"].ToString()),
    //                    temp_Id = objComm.GetValue<int>(drrr["Budget_Master_Temp_id"].ToString()),

    //                });
    //            }

    //        }

    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }

    //    IEnumerable<vw_JobnClientnStaff_jbApprover> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_jbApprover>;
    //    var obbbbb = tbl;
    //    return new JavaScriptSerializer().Serialize(tbl);
    //}

    [WebMethod]

    public string SetServerJobWiseBudgetDetails(vw_JobnClientnStaff_jbApprover currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_jbApprover> obj_Job = new List<vw_JobnClientnStaff_jbApprover>();
        try
        {
            string err = "";

            Common ob = new Common();
            CultureInfo ci = new CultureInfo("en-GB");
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@otheram", currobj.StaffCode);
            param[3] = new SqlParameter("@BudgetAmt", currobj.BudgetAmount);
            param[4] = new SqlParameter("@Budgethours", currobj.Budgethours);
            param[5] = new SqlParameter("@temp_Id", currobj.temp_Id);
            param[6] = new SqlParameter("@fromdate", Convert.ToDateTime(currobj.fromdate, ci));
            using (DataSet dss = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_Ajax_EditJob_SetServerJobWiseBudgetDetails", param))
            {

                if (dss != null)
                {
                    if (dss.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow dtrow in dss.Tables[1].Rows)
                        {
                            if (dss.Tables[0].Rows[0][0].ToString() == "Error")
                            {
                                obj_Job.Add(new vw_JobnClientnStaff_jbApprover()
                                {
                                    Stf = "Error",
                                    todate = "",
                                    fromdate = "",
                                    BudgetAmount = "",
                                    Budgethours = "",
                                    temp_Id = 0,
                                });
                            }
                            else
                            {
                                obj_Job.Add(new vw_JobnClientnStaff_jbApprover()
                                {
                                    //Stf = dtrow["otherAmt"].ToString(),
                                    todate = objComm.GetValue<string>(dtrow["todate"].ToString()),
                                    fromdate = objComm.GetValue<string>(dtrow["fromdate"].ToString()),
                                    BudgetAmount = objComm.GetValue<string>(dtrow["BudAmt"].ToString()),
                                    Budgethours = objComm.GetValue<string>(dtrow["Budhours"].ToString()),
                                    temp_Id = objComm.GetValue<int>(dtrow["Budget_Master_Temp_id"].ToString()),

                                });
                            }
                        }
                    }

                }

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_jbApprover> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_jbApprover>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string SaveJobWiseBudgetDetails(vw_SaveJobWiseBudgetDetails currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_SaveJobWiseBudgetDetails> obj_Job = new List<vw_SaveJobWiseBudgetDetails>();
        try
        {
            Common ob = new Common();
            currobj.stfBudChk = currobj.stfBudChk.Trim('/');
            string[] hdnAllstfCheckByAjaxCodeSplit = currobj.stfBudChk.Split('/');
            DataTable dtStaffBugetsEmployee = new DataTable();
            dtStaffBugetsEmployee.Columns.Add("staffcode");
            dtStaffBugetsEmployee.Columns.Add("budgetamt");
            dtStaffBugetsEmployee.Columns.Add("budgethr");
            dtStaffBugetsEmployee.Columns.Add("planneddrawings");////////planDrawing
            dtStaffBugetsEmployee.Columns.Add("allocatedhr");
            dtStaffBugetsEmployee.Columns.Add("staffactualrate");
            DataRow dr;
            foreach (string row in hdnAllstfCheckByAjaxCodeSplit)
            {
                string[] staffdetails = row.Split(',');
                if (staffdetails.Length == 7)
                {
                    dr = dtStaffBugetsEmployee.NewRow();
                    dr["staffcode"] = staffdetails[0];
                    dr["budgetamt"] = staffdetails[1];
                    dr["budgethr"] = staffdetails[2];
                    dr["planneddrawings"] = staffdetails[3];
                    dr["allocatedhr"] = staffdetails[4];
                    dr["staffactualrate"] = staffdetails[5];
                    dtStaffBugetsEmployee.Rows.Add(dr);
                }
            }


            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@dtStaffBugetsEmployee", dtStaffBugetsEmployee);
            param[1] = new SqlParameter("@compid", currobj.CompId);
            param[2] = new SqlParameter("@jobnameid", currobj.Jobid);
            param[3] = new SqlParameter("@clientid", currobj.Cltid);
            if (currobj.BudgetSelection == "Project Budgeting")
            {
                //param[4] = new SqlParameter("@BudAMt", txtBudAmt.Text);
                //param[5] = new SqlParameter("@BudHr", txtbudhours.Text);
                //param[6] = new SqlParameter("@Other", txtbudamtOth.Text);
            }
            else
            {
                param[4] = new SqlParameter("@BudAMt", 0);
                param[5] = new SqlParameter("@BudHr", 0);
                param[6] = new SqlParameter("@Other", 0);
            }
            param[7] = new SqlParameter("@BudgetingSelection", currobj.BudgetSelection);
            int resu = SqlHelper.ExecuteNonQuery(ob._cnnString, CommandType.StoredProcedure, "usp_insertStaffBudgettingFromjobadd", param);






            SqlParameter[] param1 = new SqlParameter[5];
            param1[0] = new SqlParameter("@compid", currobj.CompId);
            param1[1] = new SqlParameter("@jobid", currobj.Jobid);
            param1[2] = new SqlParameter("@bud", currobj.bud_Id);
            param1[3] = new SqlParameter("@budgeting", currobj.BudgetSelection);
            param1[4] = new SqlParameter("@Stfbudgeting", currobj.stfBudChk);
            //DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_EditJob_Insert_TempStaff_To_StaffBudget", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_EditJob_Insert_TempStaff_To_StaffBudget", param1))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_SaveJobWiseBudgetDetails()
                    {

                        Jobid = objComm.GetValue<int>(drrr["jobid"].ToString()),
                    });
                }

            }

        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_SaveJobWiseBudgetDetails> tbl = obj_Job as IEnumerable<vw_SaveJobWiseBudgetDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]

    public string BindGridTable(vw_JobnClientnStaff currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@StaffCode", currobj.StaffCode);
            //DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Get_EditJob_AjaxStaffDetails_FromTempTable", param);
            DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Get_Staff_Budget_TempTable", param);
            if (dss != null)
            {
                if (dss.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dtrow in dss.Tables[0].Rows)
                    {
                        obj_Job.Add(new vw_JobnClientnStaff()
                        {

                            temp_Id = objComm.GetValue<int>(dtrow["StaffbugdgetingTemp_Id"].ToString()),
                            fromdate = objComm.GetValue<string>(dtrow["fromdate"].ToString()),
                            todate = objComm.GetValue<string>(dtrow["todate"].ToString()),
                            BudgetAmount = objComm.GetValue<string>(dtrow["BudgetAmount"].ToString()),
                            Budgethours = objComm.GetValue<string>(dtrow["Budgethours"].ToString()),
                            startDT = objComm.GetValue<string>(dtrow["CreationDate"].ToString()),
                            //CompletedDrawing = objComm.GetValue<string>(dtrow["CompletedDrawing"].ToString()),
                            StaffActualHourRate = objComm.GetValue<string>(dtrow["StaffActualHourRate"].ToString()),
                            AllocatedHours = objComm.GetValue<string>(dtrow["AllocatedHours"].ToString()),
                        });
                    }
                }
                if (dss.Tables[1].Rows.Count > 0)
                {
                    foreach (DataRow dtrow in dss.Tables[1].Rows)
                    {
                        obj_Job.Add(new vw_JobnClientnStaff()
                        {

                            temp_Id = 0,
                            StaffActualHourRate = objComm.GetValue<string>(dtrow[0].ToString()),

                        });
                    }
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

    public string SaveOrUpdateBudget(vw_JobnClientnStaff_SaveOrUpdateBudget currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff_SaveOrUpdateBudget> obj_Job = new List<vw_JobnClientnStaff_SaveOrUpdateBudget>();
        try
        {

            Common ob = new Common();
            CultureInfo ci = new CultureInfo("en-GB");
            SqlParameter[] param = new SqlParameter[10];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@jobid", currobj.Jobid);
            param[2] = new SqlParameter("@StaffCode", currobj.StaffCode);
            param[3] = new SqlParameter("@BudgetAmt", currobj.BudgetAmount);
            param[4] = new SqlParameter("@Budgethours", currobj.Budgethours);
            param[5] = new SqlParameter("@temp_Id", currobj.temp_Id);
            param[6] = new SqlParameter("@fromdate", Convert.ToDateTime(currobj.fromdate, ci));
            param[7] = new SqlParameter("@PlanedDrawing", 0);
            param[8] = new SqlParameter("@AllocatedHours", currobj.AllocatedHours);
            param[9] = new SqlParameter("@StaffActualHourRate", currobj.StaffActualHourRate);
            DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Ajax_EditJob_SaveOrUpdateBudget", param);
            if (dss != null)
            {
                if (dss.Tables[0].Rows.Count > 0)
                {
                    if (dss.Tables[0].Rows[0][0].ToString() == "Error")
                    {
                        obj_Job.Add(new vw_JobnClientnStaff_SaveOrUpdateBudget()
                        {

                            Stf = "Error",
                        });
                    }
                    foreach (DataRow dtrow in dss.Tables[1].Rows)
                    {
                        obj_Job.Add(new vw_JobnClientnStaff_SaveOrUpdateBudget()
                        {
                            temp_Id = objComm.GetValue<int>(dtrow["StaffbugdgetingTemp_Id"].ToString()),
                            fromdate = objComm.GetValue<string>(dtrow["fromdate"].ToString()),
                            todate = objComm.GetValue<string>(dtrow["todate"].ToString()),
                            BudgetAmount = objComm.GetValue<string>(dtrow["BudgetAmount"].ToString()),
                            Budgethours = objComm.GetValue<string>(dtrow["Budgethours"].ToString()),
                            //startDT = objComm.GetValue<string>(dtrow["CreationDate"].ToString()),
                            //CompletedDrawing = objComm.GetValue<string>(dtrow["CompletedDrawing"].ToString()),
                            StaffActualHourRate = objComm.GetValue<string>(dtrow["StaffActualHourRate"].ToString()),
                            AllocatedHours = objComm.GetValue<string>(dtrow["AllocatedHours"].ToString()),
                        });

                    }
                }
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff_SaveOrUpdateBudget> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff_SaveOrUpdateBudget>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}