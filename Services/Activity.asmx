<%@ WebService Language="C#" Class="Acitivity" %>

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
public class Acitivity  : System.Web.Services.WebService {

    [WebMethod(EnableSession=true)]
    public string GetActivityRecord(string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetActivity", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
                    {
                        TSId = objComm.GetValue<int>(drrr["sino"].ToString()),
                        mJobID = objComm.GetValue<int>(drrr["mJobId"].ToString()),
                        MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drrr["countdept"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["TotalCount"].ToString()),
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
    public string GetDeptRecordActivity(int mjobid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DataSet ds;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@mjobid", mjobid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Activity_GetDepartment", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string GetDeptnProject(int compid=0)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DataSet ds;

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);



            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDeptnProject", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }


        
    [WebMethod(EnableSession=true)]
    public string GetProject(string dep )
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DataSet ds;

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@dep", dep);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDeptwiseProject", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }
    [WebMethod(EnableSession=true)]
    public string InsertUpdateActv(int mjobid, string Activityname, string All_did, string All_pid, int PL)
    {
        string Proc = "";

        //Proc = "usp_Bootstrap_InserUpdateActivity_New";
        if (PL > 2)
        {
            Proc = "usp_Bootstrap_InserUpdate_Activity";
        }
        else
        {
            Proc = "usp_Bootstrap_InserUpdateActivity_Only";
        }
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@mjobid", mjobid);
            param[2] = new SqlParameter("@activtyname", Activityname);
            param[3] = new SqlParameter("@Deptid", All_did);
            param[4] = new SqlParameter("@Pid", All_pid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, Proc, param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["mj"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteActiv(int compid, int mjobid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@mjobid", mjobid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDeleteActvDepartment", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["mjobid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetClientRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetClient", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
                    {
                        TSId = objComm.GetValue<int>(drrr["sino"].ToString()),
                        stfBudChk = objComm.GetValue<string>(drrr["ClientCode"].ToString()),
                        Cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        ClientGroupName = objComm.GetValue<string>(drrr["ClientGroupName"].ToString()),
                        Departments = objComm.GetValue<string>(drrr["Country"].ToString()),
                        projectName = objComm.GetValue<string>(drrr["ContMob"].ToString()),
                        Billable = objComm.GetValue<string>(drrr["ContEmail"].ToString()),
                        Budgethours = objComm.GetValue<string>(drrr["ContPerson"].ToString()),
                        Jobid = objComm.GetValue<int>(drrr["CTGId"].ToString()),
                        projectid = objComm.GetValue<int>(drrr["prjcount"].ToString()),
                        StaffCode = objComm.GetValue<int>(drrr["staffcount"].ToString()),
                        UType = objComm.GetValue<string>(drrr["ClientRemark"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
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
    public string GetCGDrp(string compid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ClientGroupMaster> obj_Job = new List<tbl_ClientGroupMaster>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Boostrap_GetCliengpList", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ClientGroupMaster()
                    {

                        CgroupID = objComm.GetValue<int>(drrr["CTGId"].ToString()),
                        cGroupName = objComm.GetValue<string>(drrr["ClientGroupName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ClientGroupMaster> tbl = obj_Job as IEnumerable<tbl_ClientGroupMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateClint(int compid, int cltid, string cltname, string hdnAllapp)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@cltname", cltname);
            param[3] = new SqlParameter("@hdnAllapp", hdnAllapp);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateCleint", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["cltid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteCleint(int compid, int cltid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDeleteClient", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["cltid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetExpRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> obj_Job = new List<Expenses>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetExpense", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Expenses()
                    {
                        CompId = objComm.GetValue<int>(drrr["sino"].ToString()),
                        ExpenseId = objComm.GetValue<int>(drrr["OpeId"].ToString()),
                        ExpenseName = objComm.GetValue<string>(drrr["OPEName"].ToString()),
                        Tsid = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Expenses> tbl = obj_Job as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateExpense(int compid, int cltid, string Expname)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@expid", cltid);
            param[2] = new SqlParameter("@Expname", Expname);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateExpense", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["expid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteExpense(int compid, int cltid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@expid", cltid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteExpense", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["Expid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetCltgrpRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ClientGroupMaster> obj_Job = new List<tbl_ClientGroupMaster>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetClientGrp", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ClientGroupMaster()
                    {
                        sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                        CgroupID = objComm.GetValue<int>(drrr["CTGId"].ToString()),
                        cGroupName = objComm.GetValue<string>(drrr["ClientGroupName"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["TotalCount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ClientGroupMaster> tbl = obj_Job as IEnumerable<tbl_ClientGroupMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateClientGrp(int compid, int mjobid, string Activityname)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@mjobid", mjobid);
            param[2] = new SqlParameter("@activtyname", Activityname);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateClntGrp", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["cltgpid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteCltGrp(int compid, int mjobid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@mjobid", mjobid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDeletecltGrp", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["cltgpid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string GetActivitygrpRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ClientGroupMaster> obj_Job = new List<tbl_ClientGroupMaster>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetActivityGrp", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ClientGroupMaster()
                    {
                        sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                        CgroupID = objComm.GetValue<int>(drrr["JobGId"].ToString()),
                        cGroupName = objComm.GetValue<string>(drrr["JobGroupName"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["TotalCount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ClientGroupMaster> tbl = obj_Job as IEnumerable<tbl_ClientGroupMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateActivityGrp(int compid, int mjobid, string Activityname)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@mjobid", mjobid);
            param[2] = new SqlParameter("@activtyname", Activityname);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateActivityGrp", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["cltgpid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteActiivityGrp(int compid, int mjobid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@mjobid", mjobid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDeleteActivityGrp", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["cltgpid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetRoleRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> obj_Job = new List<Expenses>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetRole", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Expenses()
                    {
                        CompId = objComm.GetValue<int>(drrr["sino"].ToString()),
                        ExpenseId = objComm.GetValue<int>(drrr["RoleID"].ToString()),
                        ExpenseName = objComm.GetValue<string>(drrr["Rolename"].ToString()),
                        Tsid = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Expenses> tbl = obj_Job as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateRole(int compid, int cltid, string Rolename)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Roleid", cltid);
            param[2] = new SqlParameter("@Rolename", Rolename);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateRole", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["roleid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteRole(int compid, int Roleid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@roleid", Roleid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteRole", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["roleid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetDeptRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> obj_Job = new List<Expenses>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Department", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Expenses()
                    {
                        CompId = objComm.GetValue<int>(drrr["sino"].ToString()),
                        ExpenseId = objComm.GetValue<int>(drrr["DepId"].ToString()),
                        ExpenseName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        Tsid = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Expenses> tbl = obj_Job as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateDept(int compid, int Dept, string Deptname)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Deptid", Dept);
            param[2] = new SqlParameter("@Deptname", Deptname);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateDepartment", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["Deptid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string DeleteDept(int compid, int Deptid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Deptid", Deptid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteDept", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["deptid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    /////////////////////////////////////////////////////

    [WebMethod]
    public string GetDesgnRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> obj_Job = new List<Expenses>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Designation", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Expenses()
                    {
                        CompId = objComm.GetValue<int>(drrr["sino"].ToString()),
                        ExpenseId = objComm.GetValue<int>(drrr["DsgId"].ToString()),
                        ExpenseName = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        Tsid = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Expenses> tbl = obj_Job as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateDesgn(int compid, int Dept, string Deptname)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Desgnid", Dept);
            param[2] = new SqlParameter("@Desgnname", Deptname);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateDesignation", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["Desgnid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteDesgn(int compid, int Deptid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@DsgId", Deptid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteDesgn", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["DsgId"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    //////Branch
    [WebMethod]
    public string GetBrchRecord(int compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> obj_Job = new List<Expenses>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Branch", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Expenses()
                    {
                        CompId = objComm.GetValue<int>(drrr["sino"].ToString()),
                        ExpenseId = objComm.GetValue<int>(drrr["BrId"].ToString()),
                        ExpenseName = objComm.GetValue<string>(drrr["BranchName"].ToString()),
                        Tsid = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Expenses> tbl = obj_Job as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateBranch(int compid, int Brid, string Brnch)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Brid", Brid);
            param[2] = new SqlParameter("@Brnch", Brnch);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateBranch", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["Brid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string DeleteBrnch(int compid, int Brid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Brid", Brid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteBrid", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["Brid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    ///Location////////////////////////////////////////
    /// 
    [WebMethod]
    public string GetLocRecord(int compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> obj_Job = new List<Expenses>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Location", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Expenses()
                    {
                        CompId = objComm.GetValue<int>(drrr["sino"].ToString()),
                        ExpenseId = objComm.GetValue<int>(drrr["locid"].ToString()),
                        ExpenseName = objComm.GetValue<string>(drrr["LocationName"].ToString()),
                        Tsid = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Expenses> tbl = obj_Job as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateLocation(int compid, int locid, string locatname)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Locid", locid);
            param[2] = new SqlParameter("@Location ", locatname);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateLocation", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["LocId"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string DeleteLocatn(int compid, int LocId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Locid", LocId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteLocid", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["LocId"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    /////Holiday//////////////
    [WebMethod]
    public string GetHolidayRecord(int compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Holiday> obj_Job = new List<tbl_Holiday>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Holiday", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_Holiday()
                    {
                        sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Holid = objComm.GetValue<int>(drrr["HolidayId"].ToString()),
                        Brnchid = objComm.GetValue<int>(drrr["Branch_id"].ToString()),
                        HoliName = objComm.GetValue<string>(drrr["HolidayName"].ToString()),
                        HoliDate = objComm.GetValue<string>(drrr["HolidayDate"].ToString()),
                        HoliDate2 = objComm.GetValue<string>(drrr["HolidayDate2"].ToString()),
                        Branch = objComm.GetValue<string>(drrr["BranchName"].ToString()),
                        Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Holiday> tbl = obj_Job as IEnumerable<tbl_Holiday>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetBrnchdrp(int compid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Branch_Master> obj_Job = new List<Branch_Master>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetBranchlist", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Branch_Master()
                    {
                        BrId = objComm.GetValue<int>(drrr["BrId"].ToString()),
                        BranchName = objComm.GetValue<string>(drrr["BranchName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Branch_Master> tbl = obj_Job as IEnumerable<Branch_Master>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateHoliday(int compid, int Hid, string Holiname, string Dt, int brchid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Hid", Hid);
            param[2] = new SqlParameter("@Holiname", Holiname);
            param[3] = new SqlParameter("@Dt", Dt);
            param[4] = new SqlParameter("@brchid", brchid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateHoliday", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["Hid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteHoliday(int compid, int Hid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Hid", Hid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteHoli", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["Hid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetActivityGridDept(int compid, int Depid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Project_Activity> obj_Job = new List<tbl_Project_Activity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Depid", Depid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetActivityGridDept", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_Project_Activity()
                    {
                        Aid = objComm.GetValue<int>(drrr["Actvid"].ToString()),
                        Activity = objComm.GetValue<string>(drrr["ActvName"].ToString()),
                        isChecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Project_Activity> tbl = obj_Job as IEnumerable<tbl_Project_Activity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string UpdateLinkActivityDept(int compid, int Depid, string hdnAllapp)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Depid", Depid);
            param[2] = new SqlParameter("@hdnAllapp", hdnAllapp);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpdateLinkActivityDept", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["Deptid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    ///////////////Skill/////////////////

    [WebMethod]
    public string GetSkillRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Skill> obj_Job = new List<Skill>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Skill", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Skill()
                    {
                        SINo = objComm.GetValue<int>(drrr["sino"].ToString()),
                        SkillId = objComm.GetValue<int>(drrr["Skillid"].ToString()),

                        SkillName = objComm.GetValue<string>(drrr["SkillName"].ToString()),

                        TotalCount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Skill> tbl = obj_Job as IEnumerable<Skill>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateSkill(int compid, int id, string name)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Skill> obj_Job = new List<Skill>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@ID", id);
            param[2] = new SqlParameter("@Name", name);



            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateSkill", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Skill()
                    {
                        SkillId = objComm.GetValue<int>(drrr["Skillid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Skill> tbl = obj_Job as IEnumerable<Skill>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteSkill(int compid, int Skillid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Skillid", Skillid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteSkill", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["Skillid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    //////////////////////Vendor Master ///////////////////////
    [WebMethod]
    public string GetVendorRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Vendor", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
                    {
                        TSId = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Cltid = objComm.GetValue<int>(drrr["Vendrid"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["VendorName"].ToString()),
                        Budgethours = objComm.GetValue<string>(drrr["ContactPerson"].ToString()),
                        projectName = objComm.GetValue<string>(drrr["ContactNumber"].ToString()),
                        Billable = objComm.GetValue<string>(drrr["VEmail"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
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
    public string InsertUpdateVendor(int compid, int VuchrID, string Vltname, string hdnAllapp)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@VuchrID", VuchrID);
            param[2] = new SqlParameter("@Vltname", Vltname);
            param[3] = new SqlParameter("@hdnAllapp", hdnAllapp);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateVendor", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["vltid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteVendor(int compid, int Vltid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Vltid", Vltid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDeleteVendor", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["Vltid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string GetCertificationRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Certification> obj_Job = new List<Certification>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Certification", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Certification()
                    {
                        CompId = objComm.GetValue<int>(drrr["sino"].ToString()),

                        CertificationId = objComm.GetValue<int>(drrr["Certificationid"].ToString()),
                        CertificationName = objComm.GetValue<string>(drrr["CertificationName"].ToString()),

                        TotalCount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Certification> tbl = obj_Job as IEnumerable<Certification>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateCertification(int compid, int id, string name)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Certification> obj_Job = new List<Certification>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@ID", id);
            param[2] = new SqlParameter("@Name", name);



            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateCertification", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Certification()
                    {
                        CertificationId = objComm.GetValue<int>(drrr["Certificationid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Certification> tbl = obj_Job as IEnumerable<Certification>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteCertification(int compid, int Certificationid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Certification> obj_Job = new List<Certification>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Certificationid", Certificationid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteCertification", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Certification()
                    {
                        CertificationId = objComm.GetValue<int>(drrr["CertificationID"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Certification> tbl = obj_Job as IEnumerable<Certification>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}