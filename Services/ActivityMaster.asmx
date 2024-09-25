<%@ WebService Language="C#" Class="ActivityMaster" %>

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
public class ActivityMaster : System.Web.Services.WebService
{

    [WebMethod]
    public string GetActivityRecord(string compid, string Srch, int pageIndex, int pageSize)
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


    [WebMethod(EnableSession = true)]
    public string GetDeptRecordActivity(int mjobid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_DepartmentBudgeting> obj_Job = new List<tbl_DepartmentBudgeting>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@mjobid", mjobid);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDepartment_old", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_DepartmentBudgeting()
                        {
                            depid = objComm.GetValue<int>(drrr["DepId"].ToString()),
                            Deptname = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                            Jobid = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_DepartmentBudgeting> tbl = obj_Job as IEnumerable<tbl_DepartmentBudgeting>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateActv(int compid, int mjobid, string Activityname, string hdnAllapp, string hdnOnly)
    {
        string Proc = "";
        if (hdnOnly == "1")
        {
            Proc = "usp_Bootstrap_InserUpdateActivity_Only";
        }
        else if (hdnOnly == "0")
        {
            Proc = "usp_Bootstrap_InserUpdateActivity";
        }
        else if (hdnOnly == "2")
        {
            Proc = "usp_Bootstrap_InserUpdateActivity_Assign";
        }
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@mjobid", mjobid);
            param[2] = new SqlParameter("@activtyname", Activityname);
            param[3] = new SqlParameter("@Deptid", hdnAllapp);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, Proc, param))
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

    [WebMethod(EnableSession = true)]
    public string DeleteActiv(int mjobid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
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

    [WebMethod(EnableSession = true)]
    public string GetClientRecord(string Srch, int pageIndex, int pageSize)
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
                        Link_JobnTask = objComm.GetValue<string>(drrr["Address1"].ToString()),
                        Task_Id = objComm.GetValue<int>(drrr["State_Code"].ToString()),
                        Task_name = objComm.GetValue<string>(drrr["GST_No"].ToString()),
                        hdnAlltsk = objComm.GetValue<string>(drrr["ContactNo"].ToString()),
                        Assign_Name = objComm.GetValue<string>(drrr["Fees_Type"].ToString()),
                        hdndpt = objComm.GetValue<int>(drrr["Fee"].ToString()),
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

    [WebMethod(EnableSession = true)]
    public string GetCGDrp(string compid = "0")
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ClientGroupMaster> obj_Job = new List<tbl_ClientGroupMaster>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

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

    [WebMethod(EnableSession = true)]
    public string GetStateDrp()
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ClientGroupMaster> obj_Job = new List<tbl_ClientGroupMaster>();
        try
        {
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Boostrap_GetStateList"))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ClientGroupMaster()
                    {

                        CgroupID = objComm.GetValue<int>(drrr["state_code"].ToString()),
                        cGroupName = objComm.GetValue<string>(drrr["state_name"].ToString()),

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


    [WebMethod(EnableSession = true)]
    public string InsertUpdateClint(int cltid, string cltname, string hdnAllapp)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
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

    [WebMethod(EnableSession = true)]
    public string DeleteCleint(int cltid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
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

    [WebMethod(EnableSession = true)]
    public string GetExpRecord(string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> obj_Job = new List<Expenses>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Expenses> tbl = obj_Job as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string InsertUpdateExpense(int cltid, string Expname)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string DeleteExpense(int cltid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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

    [WebMethod(EnableSession = true)]
    public string GetRoleRecord(string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> obj_Job = new List<Expenses>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Expenses> tbl = obj_Job as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string InsertUpdateRole(int cltid, string Rolename)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string DeleteRole(int Roleid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetDeptRecord(string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> obj_Job = new List<Expenses>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Expenses> tbl = obj_Job as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string InsertUpdateDept(int Dept, string Deptname)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession = true)]
    public string DeleteDept(int Deptid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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

    [WebMethod(EnableSession = true)]
    public string GetDesgnRecord(string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> obj_Job = new List<Expenses>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Expenses> tbl = obj_Job as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string InsertUpdateDesgn(int Dept, string Deptname)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string DeleteDesgn(int Deptid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
    [WebMethod(EnableSession = true)]
    public string GetBrchRecord(string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> obj_Job = new List<Expenses>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Expenses> tbl = obj_Job as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string InsertUpdateBranch(int Brid, string Brnch)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession = true)]
    public string DeleteBrnch(int Brid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
    [WebMethod(EnableSession = true)]
    public string GetHolidayRecord(string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Holiday> obj_Job = new List<tbl_Holiday>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Holiday> tbl = obj_Job as IEnumerable<tbl_Holiday>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetBrnchdrp(int compid = 0)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Branch_Master> obj_Job = new List<Branch_Master>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@compid", Session["companyid"]);

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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Branch_Master> tbl = obj_Job as IEnumerable<Branch_Master>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string InsertUpdateHoliday(int Hid, string Holiname, string Dt, int brchid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[5];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string DeleteHoliday(int Hid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetActivityGridDept(int Depid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Project_Activity> obj_Job = new List<tbl_Project_Activity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Project_Activity> tbl = obj_Job as IEnumerable<tbl_Project_Activity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string UpdateLinkActivityDept(int Depid, string hdnAllapp)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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

    [WebMethod(EnableSession = true)]
    public string GetSkillRecord(string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Skill> obj_Job = new List<Skill>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Skill> tbl = obj_Job as IEnumerable<Skill>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string InsertUpdateSkill(int id, string name)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Skill> obj_Job = new List<Skill>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Skill> tbl = obj_Job as IEnumerable<Skill>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string DeleteSkill(int Skillid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
    [WebMethod(EnableSession = true)]
    public string GetVendorRecord(string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string InsertUpdateVendor(int VuchrID, string Vltname, string hdnAllapp)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string DeleteVendor(int Vltid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession = true)]
    public string GetCertificationRecord(string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Certification> obj_Job = new List<Certification>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Certification> tbl = obj_Job as IEnumerable<Certification>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string InsertUpdateCertification(int id, string name)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Certification> obj_Job = new List<Certification>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Certification> tbl = obj_Job as IEnumerable<Certification>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string DeleteCertification(int Certificationid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Certification> obj_Job = new List<Certification>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
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