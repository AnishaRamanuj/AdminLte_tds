<%@ WebService Language="C#" Class="wsJobName" %>

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
public class wsJobName  : System.Web.Services.WebService {
    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]
    public string bind_Projects(string compid, string mjobid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@mJobid", mjobid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_JobName_Projects", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
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

        IEnumerable<vw_JobnClientnStaff> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession=true)]
    public string bind_Task_Project(string tskid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_task_Project> obj_Job = new List<tbl_task_Project>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@tskid", tskid);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_Task_Project", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_task_Project()
                        {
                            Projectid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                            ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                            expdate = objComm.GetValue<string>(drrr["expdate"].ToString()),
                            ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_task_Project> tbl = obj_Job as IEnumerable<tbl_task_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]
    public string bind_Task_JobName(string compid, string tskid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_task_Jobname> obj_Job = new List<tbl_task_Jobname>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@tskid", tskid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_Task_JobName", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_task_Jobname()
                    {
                        mjobid = objComm.GetValue<int>(drrr["mJobId"].ToString()),
                        mjobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        //expdate=objComm.GetValue<string>(drrr["expdate"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_task_Jobname> tbl = obj_Job as IEnumerable<tbl_task_Jobname>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod(EnableSession=true)]
    public string bind_Task(tbl_task_Project currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_task_Project> obj_Job = new List<tbl_task_Project>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[6];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@PageIndex", currobj.pageIndex);
                param[2] = new SqlParameter("@PageSize", currobj.pageNewSize);
                param[3] = new SqlParameter("@LinkJT", currobj.Link_JobnTask);
                param[4] = new SqlParameter("@SType", currobj.jStatus);
                param[5] = new SqlParameter("@Srch", currobj.messg);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_get_Task_Project", param))
                {
                    if (currobj.Link_JobnTask != "0")
                    {
                        while (drrr.Read())
                        {
                            obj_Job.Add(new tbl_task_Project()
                            {
                                Task_Id = objComm.GetValue<int>(drrr["TaskId"].ToString()),
                                Task_name = objComm.GetValue<string>(drrr["TaskName"].ToString()),
                                ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                                expdate = objComm.GetValue<string>(drrr["expdate"].ToString()),
                                TotalCount = objComm.GetValue<int>(drrr["TotalCount"].ToString()),
                            });
                        }
                    }
                    else
                    {
                        while (drrr.Read())
                        {
                            obj_Job.Add(new tbl_task_Project()
                            {
                                Task_Id = objComm.GetValue<int>(drrr["TaskId"].ToString()),
                                Task_name = objComm.GetValue<string>(drrr["TaskName"].ToString()),
                                TotalCount = objComm.GetValue<int>(drrr["TotalCount"].ToString()),
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

        IEnumerable<tbl_task_Project> tbl = obj_Job as IEnumerable<tbl_task_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod]
    public string bind_TaskJobname(tbl_task_Jobname currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_task_Jobname> obj_Job = new List<tbl_task_Jobname>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@PageIndex", currobj.pageIndex);
            param[2] = new SqlParameter("@PageSize", currobj.pageNewSize);
            param[3] = new SqlParameter("@LinkJT", currobj.Link_JobnTask);
            param[4] = new SqlParameter("@SType", currobj.jStatus);
            param[5] = new SqlParameter("@Srch", currobj.messg);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_get_Task_Jobname", param))
            {
                if (currobj.Link_JobnTask != "0")
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_task_Jobname()
                        {
                            Task_Id = objComm.GetValue<int>(drrr["TaskId"].ToString()),
                            Task_name = objComm.GetValue<string>(drrr["TaskName"].ToString()),
                            mjobName = objComm.GetValue<string>(drrr["mjobname"].ToString()),
                            //expdate=objComm.GetValue<string>(drrr["expdate"].ToString()),
                            TotalCount = objComm.GetValue<int>(drrr["TotalCount"].ToString()),
                        });
                    }
                }
                else
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_task_Jobname()
                        {
                            Task_Id = objComm.GetValue<int>(drrr["TaskId"].ToString()),
                            Task_name = objComm.GetValue<string>(drrr["TaskName"].ToString()),
                            TotalCount = objComm.GetValue<int>(drrr["TotalCount"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_task_Jobname> tbl = obj_Job as IEnumerable<tbl_task_Jobname>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }



    [WebMethod]
    public string bind_Jobs(vw_JobnClientnStaff currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", currobj.CompId );
            param[1] = new SqlParameter("@PageIndex", currobj.pageIndex);
            param[2] = new SqlParameter("@PageSize", currobj.pageNewSize);
            param[3] = new SqlParameter("@LinkJT", currobj.Link_JobnTask);
            param[4] = new SqlParameter("@SType", currobj.jStatus);
            param[5] = new SqlParameter("@Srch", currobj.messg);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_JobName", param))
            {
                if (currobj.Link_JobnTask != "0")
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new vw_JobnClientnStaff()
                        {
                            mJobID = objComm.GetValue<int>(drrr["mJobId"].ToString()),
                            MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                            ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                            projectName = objComm.GetValue<string>(drrr["projectname"].ToString()),
                            TotalCount = objComm.GetValue<int>(drrr["TotalCount"].ToString()),

                        });
                    }
                }
                else
                {

                    while (drrr.Read())
                    {
                        obj_Job.Add(new vw_JobnClientnStaff()
                        {
                            mJobID = objComm.GetValue<int>(drrr["mJobId"].ToString()),
                            MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                            TotalCount = objComm.GetValue<int>(drrr["TotalCount"].ToString()),
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
    public string Jobname_Save(vw_JobnClientnStaff currobj)
    {
        string procname = "";
        if (currobj.mJobID > 0)
        {
            procname = "usp_JobNameUpdate";
        }
        else
        {
            procname = "usp_JobNameInsert";
        }

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@mJobId", currobj.mJobID);
            param[1] = new SqlParameter("@compid", currobj.CompId);
            param[2] = new SqlParameter("@mJobName", currobj.MJobName);
            param[3] = new SqlParameter("@Pid", currobj.Stf);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, procname, param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
                    {
                        mJobID = objComm.GetValue<int>(drrr["mJobId"].ToString()),

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


    [WebMethod(EnableSession=true)]
    public string Task_Save(vw_JobnClientnStaff currobj)
    {
        string procname = "";

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@taskname", currobj.Task_name);
                param[2] = new SqlParameter("@hidid", currobj.Task_Id);
                param[3] = new SqlParameter("@hndtid", currobj.projectName);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_save_task", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new vw_JobnClientnStaff()
                        {
                            Task_Id = objComm.GetValue<int>(drrr["TaskId"].ToString()),

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
    public string TaskJobname_Save(tbl_task_Jobname currobj)
    {
        string procname = "";

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_task_Jobname> obj_Job = new List<tbl_task_Jobname>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@taskname", currobj.Task_name );
            param[2] = new SqlParameter("@hidid", currobj.Task_Id );
            param[3] = new SqlParameter("@hndtid", currobj.mjobName);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_save_taskJobname", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_task_Jobname()
                    {
                        Task_Id = objComm.GetValue<int>(drrr["TaskId"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_task_Jobname> tbl = obj_Job as IEnumerable<tbl_task_Jobname>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Delete_Jobname(vw_JobnClientnStaff currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", currobj.CompId);
            param[1] = new SqlParameter("@mJobId", currobj.mJobID);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Delete_JobName", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
                    {
                        mJobID = objComm.GetValue<int>(drrr["mJobId"].ToString()),

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


    [WebMethod(EnableSession=true)]
    public string Delete_Task(vw_JobnClientnStaff currobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@Task_Id", currobj.Task_Id);
                //param[2] = new SqlParameter("@LinkJT", currobj.Link_JobnTask);
                //param[3] = new SqlParameter("@hdndpt", currobj.hdndpt);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Delete_Task", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new vw_JobnClientnStaff()
                        {
                            Task_Id = objComm.GetValue<int>(drrr["TaskId"].ToString()),

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

}