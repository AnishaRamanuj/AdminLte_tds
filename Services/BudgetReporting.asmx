<%@ WebService Language="C#" Class="BudgetReporting" %>

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
public class BudgetReporting : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod(EnableSession=true)]
    public string GetActivity(string frmdt, string Todt)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Alloc_Jobname> obj_Job = new List<tbl_Alloc_Jobname>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@fromdt", frmdt);
                param[2] = new SqlParameter("@todate", Todt);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetActivityBudgrpt", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_Alloc_Jobname()
                        {

                            mJobid = objComm.GetValue<int>(drrr["mJob_Id"].ToString()),
                            mJobname = objComm.GetValue<string>(drrr["MJobName"].ToString()),

                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Alloc_Jobname> tbl = obj_Job as IEnumerable<tbl_Alloc_Jobname>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string GetActivityReport(string compid, string frmdt, string Todt, string hdnAllapp)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ActivitywiseBudget> obj_Job = new List<tbl_ActivitywiseBudget>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@fromdt", frmdt);
            param[2] = new SqlParameter("@todate", Todt);
            param[3] = new SqlParameter("@Activutyids", hdnAllapp);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetActivityBudgdetailrpt", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ActivitywiseBudget()
                    {
                        Mjobname = objComm.GetValue<string>(drrr["Mjobname"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["Projectname"].ToString()),
                        JobHours = objComm.GetValue<string>(drrr["JobHours"].ToString()),
                        Department = objComm.GetValue<string>(drrr["Department"].ToString()),
                        TotalTime = objComm.GetValue<string>(drrr["TotalTime"].ToString()),
                        ActualCost = objComm.GetValue<string>(drrr["ActualCost"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ActivitywiseBudget> tbl = obj_Job as IEnumerable<tbl_ActivitywiseBudget>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetDepartment(string compid, string frmdt, string Todt)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Department_Master> obj_Job = new List<Department_Master>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@fromdt", frmdt);
            param[2] = new SqlParameter("@todate", Todt);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDepartmentBudgrpt", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Department_Master()
                    {

                        DepId = objComm.GetValue<int>(drrr["Dept_Id"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Department_Master> tbl = obj_Job as IEnumerable<Department_Master>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetDepartmentReport(string compid, string frmdt, string Todt, string hdnAllapp)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ActivitywiseBudget> obj_Job = new List<tbl_ActivitywiseBudget>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@fromdt", frmdt);
            param[2] = new SqlParameter("@todate", Todt);
            param[3] = new SqlParameter("@Departmntids", hdnAllapp);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDepartmentBudgdetailrpt", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ActivitywiseBudget()
                    {
                        Department = objComm.GetValue<string>(drrr["Department"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["Projectname"].ToString()),
                        Mjobname = objComm.GetValue<string>(drrr["Activity"].ToString()),
                        TotalTime = objComm.GetValue<string>(drrr["TotalTime"].ToString()),
                        ActualCost = objComm.GetValue<string>(drrr["ActualCost"].ToString()),
                        staffname = objComm.GetValue<string>(drrr["staffname"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ActivitywiseBudget> tbl = obj_Job as IEnumerable<tbl_ActivitywiseBudget>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Get_Staff_Project(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            DateTime strdate = Convert.ToDateTime(currobj.Fromdate, ci);
            DateTime enddate = Convert.ToDateTime(currobj.Todate, ci);

            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@fromdate", strdate);
            param[2] = new SqlParameter("@selectedStaff", currobj.selectedstaffCode.TrimEnd(','));
            param[3] = new SqlParameter("@needproject", currobj.needproject);
            param[4] = new SqlParameter("@needstaff", currobj.needstaff);
            param[5] = new SqlParameter("@Todate", enddate);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_StaffProjectwise", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetStaffwiseReport(string compid, string frmdt, string Todt, string TStatus, string Staffcodeids, string projectids)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffwiseBudget> obj_Job = new List<tbl_StaffwiseBudget>();
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@FromDate", frmdt);
            param[2] = new SqlParameter("@ToDate", Todt);
            param[3] = new SqlParameter("@TStatus", TStatus);
            param[4] = new SqlParameter("@selectedstaffcode", Staffcodeids);
            param[5] = new SqlParameter("@selectedjobid", projectids);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetStaffBudgdetailrpt", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_StaffwiseBudget()
                    {
                        Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["Projectname"].ToString()),
                        Mjobname = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        charges = objComm.GetValue<string>(drrr["charges"].ToString()),
                        hours = objComm.GetValue<string>(drrr["hours"].ToString()),
                        staffHours = objComm.GetValue<string>(drrr["staffHours"].ToString()),
                        Eff = objComm.GetValue<string>(drrr["Efficency"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_StaffwiseBudget> tbl = obj_Job as IEnumerable<tbl_StaffwiseBudget>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string GetClient_Project(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            DateTime strdate = Convert.ToDateTime(currobj.Fromdate, ci);
            DateTime enddate = Convert.ToDateTime(currobj.Todate, ci);

            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@Todate", enddate);
            param[2] = new SqlParameter("@selectedclient", currobj.selectedstaffCode.TrimEnd(','));
            param[3] = new SqlParameter("@needproject", currobj.needproject);
            param[4] = new SqlParameter("@needstaff", currobj.needstaff);
            param[5] = new SqlParameter("@fromdate", strdate);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_ClientProjectwise", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetProjectwiseReport(string compid, string frmdt, string Todt, string TStatus, string cltidids, string projectids)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectwiseBudget> obj_Job = new List<tbl_ProjectwiseBudget>();
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@FromDate", frmdt);
            param[2] = new SqlParameter("@ToDate", Todt);
            param[3] = new SqlParameter("@TStatus", TStatus);
            param[4] = new SqlParameter("@selectedcltid", cltidids);
            param[5] = new SqlParameter("@selectedjobid", projectids);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetProjectBudgdetailrpt", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectwiseBudget()
                    {
                        Client = objComm.GetValue<string>(drrr["Clientname"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["Projectname"].ToString()),
                        BudgAmt = objComm.GetValue<string>(drrr["staffname"].ToString()),
                        Budghrs = objComm.GetValue<string>(drrr["mJobname"].ToString()),
                        ActualHrs = objComm.GetValue<string>(drrr["ActulHrs"].ToString()),
                        ActulAmt = objComm.GetValue<string>(drrr["ActulAmt"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectwiseBudget> tbl = obj_Job as IEnumerable<tbl_ProjectwiseBudget>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string Get_Staff_Client(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            if (Session["companyid"] != null)
            {
                DateTime strdate = Convert.ToDateTime(currobj.Todate, ci);
                DateTime enddate = Convert.ToDateTime(currobj.Fromdate, ci);

                SqlParameter[] param = new SqlParameter[6];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@Todate", strdate);
                param[2] = new SqlParameter("@selectedStaff", currobj.selectedstaffCode.TrimEnd(','));
                param[3] = new SqlParameter("@needproject", currobj.needproject);
                param[4] = new SqlParameter("@needstaff", currobj.needstaff);
                param[5] = new SqlParameter("@fromdate", enddate);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_StaffClientwise", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new tbl_ProjectwiseReport()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                            Type = objComm.GetValue<string>(drrr["type"].ToString())
                        });
                    }
                    drrr.Close();
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession = true)]
    public string GetStaffClientwiseReport(string frmdt, string Todt, string TStatus, string Staffcodeids, string projectids)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffwiseBudget> obj_Job = new List<tbl_StaffwiseBudget>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[6];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@FromDate", frmdt);
                param[2] = new SqlParameter("@ToDate", Todt);
                param[3] = new SqlParameter("@TStatus", TStatus);
                param[4] = new SqlParameter("@selectedstaffcode", Staffcodeids);
                param[5] = new SqlParameter("@selectedjobid", projectids);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetStaffClientdetailrpt", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_StaffwiseBudget()
                        {
                            Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                            Projectname = objComm.GetValue<string>(drrr["clientname"].ToString()),
                            Mjobname = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                            charges = objComm.GetValue<string>(drrr["charges"].ToString()),
                            hours = objComm.GetValue<string>(drrr["hours"].ToString()),

                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_StaffwiseBudget> tbl = obj_Job as IEnumerable<tbl_StaffwiseBudget>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string Get_ClientStafflist(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            if (Session["companyid"] != null)
            {
                DateTime strdate = Convert.ToDateTime(currobj.Todate, ci);
                DateTime enddate = Convert.ToDateTime(currobj.Fromdate, ci);

                SqlParameter[] param = new SqlParameter[8];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@Todate", strdate);
                param[2] = new SqlParameter("@selectedclt", currobj.selectedstaffCode.TrimEnd(','));
                param[3] = new SqlParameter("@needproject", currobj.needproject);
                param[4] = new SqlParameter("@needstaff", currobj.needstaff);
                param[5] = new SqlParameter("@fromdate", enddate);
                param[6] = new SqlParameter("@staffcode", currobj.StaffCode);
                param[7] = new SqlParameter("@staffrole", currobj.rolename);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_ClientStaffwise", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new tbl_ProjectwiseReport()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                            Type = objComm.GetValue<string>(drrr["type"].ToString())
                        });
                    }
                    drrr.Close();
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetClientstaffwiseReport(string frmdt, string Todt, string TStatus, string Staffcodeids, string projectids)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffwiseBudget> obj_Job = new List<tbl_StaffwiseBudget>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[6];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@FromDate", frmdt);
                param[2] = new SqlParameter("@ToDate", Todt);
                param[3] = new SqlParameter("@TStatus", TStatus);
                param[4] = new SqlParameter("@selectedstaffcode", Staffcodeids);
                param[5] = new SqlParameter("@selectedjobid", projectids);
                DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetClientStaffdetailrpt", param);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetClientStaffdetailrpt", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_StaffwiseBudget()
                        {
                            Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                            Projectname = objComm.GetValue<string>(drrr["clientname"].ToString()),
                            Mjobname = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                            charges = objComm.GetValue<string>(drrr["charges"].ToString()),
                            hours = objComm.GetValue<string>(drrr["hours"].ToString()),

                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_StaffwiseBudget> tbl = obj_Job as IEnumerable<tbl_StaffwiseBudget>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string ActivityReport(string frmdt, string Todt, string hdnAllapp)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ActivitywiseBudget> obj_Job = new List<tbl_ActivitywiseBudget>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@fromdt", frmdt);
                param[2] = new SqlParameter("@todate", Todt);
                param[3] = new SqlParameter("@Activutyids", hdnAllapp);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetActivitywiserpt", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_ActivitywiseBudget()
                        {
                            Mjobname = objComm.GetValue<string>(drrr["Mjobname"].ToString()),
                            staffname = objComm.GetValue<string>(drrr["Staff"].ToString()),
                            Projectname = objComm.GetValue<string>(drrr["Client"].ToString()),
                            TotalTime = objComm.GetValue<string>(drrr["TotalTime"].ToString()),
                            ActualCost = objComm.GetValue<string>(drrr["ActualCost"].ToString()),

                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ActivitywiseBudget> tbl = obj_Job as IEnumerable<tbl_ActivitywiseBudget>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Get_Job_Client(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            DateTime strdate = Convert.ToDateTime(currobj.Fromdate, ci);
            DateTime enddate = Convert.ToDateTime(currobj.Todate, ci);

            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@fromdate", strdate);
            param[2] = new SqlParameter("@selectedmjobid", currobj.selectedJobidCode.TrimEnd(','));
            param[3] = new SqlParameter("@needproject", currobj.needproject);
            param[4] = new SqlParameter("@needJob", currobj.needstaff);
            param[5] = new SqlParameter("@Todate", enddate);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_JobClientwise", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetJobClientwiseReport(string compid, string frmdt, string Todt, string TStatus, string Mjobids, string Clientids)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_JobClientSummaryReport> obj_Job = new List<tbl_JobClientSummaryReport>();
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@FromDate", frmdt);
            param[2] = new SqlParameter("@ToDate", Todt);
            param[3] = new SqlParameter("@TStatus", TStatus);
            param[4] = new SqlParameter("@selectedjobid", Mjobids);
            param[5] = new SqlParameter("@selectedCltid", Clientids);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Boostrap_JobClientSummaryReport", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_JobClientSummaryReport()
                    {
                        Mjobname = objComm.GetValue<string>(drrr["mjobname"].ToString()),
                        clientgrp = objComm.GetValue<string>(drrr["Clientgrp"].ToString()),
                        client = objComm.GetValue<string>(drrr["Clientname"].ToString()),
                        Dept = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        Desg = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        Staffname = objComm.GetValue<string>(drrr["staffname"].ToString()),
                        charges = objComm.GetValue<string>(drrr["charges"].ToString()),
                        hours = objComm.GetValue<string>(drrr["hours"].ToString()),
                        Exp = objComm.GetValue<string>(drrr["OPE"].ToString()),
                        ExpCharges = objComm.GetValue<string>(drrr["OPECharges"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_JobClientSummaryReport> tbl = obj_Job as IEnumerable<tbl_JobClientSummaryReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Get_Job_Details(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            DateTime strdate = Convert.ToDateTime(currobj.Fromdate, ci);
            DateTime enddate = Convert.ToDateTime(currobj.Todate, ci);

            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@fromdate", strdate);
            param[2] = new SqlParameter("@Todate", enddate);
            param[3] = new SqlParameter("@selectedmjobid", currobj.selectedJobidCode.TrimEnd(','));
            param[4] = new SqlParameter("@selectedcltidCode", currobj.selectedcltidCode.TrimEnd(','));
            param[5] = new SqlParameter("@needJob", currobj.needJob);
            param[6] = new SqlParameter("@needClient", currobj.needClient);
            param[7] = new SqlParameter("@needstaff", currobj.needstaff);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_JobClientStaff", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetJobDetailsReport(string compid, string frmdt, string Todt, string TStatus, string Mjobids, string Clientids, string staffcodes)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_JobClientSummaryReport> obj_Job = new List<tbl_JobClientSummaryReport>();
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@FromDate", frmdt);
            param[2] = new SqlParameter("@ToDate", Todt);
            param[3] = new SqlParameter("@TStatus", TStatus);
            param[4] = new SqlParameter("@selectedjobid", Mjobids);
            param[5] = new SqlParameter("@selectedCltid", Clientids);
            param[6] = new SqlParameter("@selectedstaffcode", staffcodes);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Boostrap_JobDetailsReport", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_JobClientSummaryReport()
                    {
                        Mjobname = objComm.GetValue<string>(drrr["mjobname"].ToString()),

                        client = objComm.GetValue<string>(drrr["Clientname"].ToString()),
                        Dept = objComm.GetValue<string>(drrr["Date"].ToString()),
                        Desg = objComm.GetValue<string>(drrr["Nar"].ToString()),
                        Staffname = objComm.GetValue<string>(drrr["staffname"].ToString()),
                        charges = objComm.GetValue<string>(drrr["charges"].ToString()),
                        hours = objComm.GetValue<string>(drrr["hours"].ToString()),
                        Exp = objComm.GetValue<string>(drrr["OPE"].ToString()),
                        ExpCharges = objComm.GetValue<string>(drrr["OPECharges"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_JobClientSummaryReport> tbl = obj_Job as IEnumerable<tbl_JobClientSummaryReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    /// <summary>
    /// ////////////////Staff Name ResAlloc
    /// </summary>

    [WebMethod(EnableSession=true)]
    public string GetStaffResAlloc(string frmdt, string Todt)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Staff> obj_Job = new List<tbl_Staff>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@st_date", Convert.ToDateTime(frmdt, ci));
                param[2] = new SqlParameter("@Ed_date", Convert.ToDateTime(Todt, ci));

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ResourceAllocStaffList", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_Staff()
                        {

                            StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),

                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Staff> tbl = obj_Job as IEnumerable<tbl_Staff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string ResAllocReport(string frmdt, string Todt, string hdnAllapp)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ResourceAllocRpt> obj_Job = new List<tbl_ResourceAllocRpt>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@st_date", Convert.ToDateTime(frmdt, ci));
                param[2] = new SqlParameter("@Ed_date", Convert.ToDateTime(Todt, ci));
                param[3] = new SqlParameter("@Staffids", hdnAllapp);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ResourceAllocReport", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_ResourceAllocRpt()
                        {
                            Department = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                            staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                            Desg = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                            Projectname = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                            Approvername = objComm.GetValue<string>(drrr["Approvername"].ToString()),
                            Startdt = objComm.GetValue<string>(drrr["StartDateTS"].ToString()),
                            Endt = objComm.GetValue<string>(drrr["EndDateTs"].ToString()),
                            Avg = objComm.GetValue<string>(drrr["Avarage"].ToString()),
                            Bill = objComm.GetValue<string>(drrr["BillTot"].ToString()),
                            NonBill = objComm.GetValue<string>(drrr["NonBillTot"].ToString()),
                            JStartdt = objComm.GetValue<string>(drrr["ST"].ToString()),
                            JEndt = objComm.GetValue<string>(drrr["Ed"].ToString()),
                            Wkg = objComm.GetValue<string>(drrr["Wkg"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ResourceAllocRpt> tbl = obj_Job as IEnumerable<tbl_ResourceAllocRpt>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetBillNonBillStaffwiseReport(string frmdt, string Todt, string TStatus, string billtype, string brnch, string Staffids, string projectids, string Jobids, string TypeReport)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_JobClientSummaryReport> obj_Job = new List<tbl_JobClientSummaryReport>();
        try
        {
            if (Session["companyid"] != null)
            {
                string pname = "";
                if (Convert.ToBoolean(TypeReport) == false)
                {
                    pname = "usp_Bootstrap_BillNonBillStaffSummary_rpt";
                }
                else
                {
                    pname = "usp_Bootstrap_BillNonBillStaffDetail_rpt";
                }

                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[9];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@FromDate", frmdt);
                param[2] = new SqlParameter("@ToDate", Todt);
                param[3] = new SqlParameter("@TStatus", TStatus);
                param[4] = new SqlParameter("@type", billtype);
                param[5] = new SqlParameter("@Brid", brnch);
                param[6] = new SqlParameter("@selectedstaffcode", Staffids);
                param[7] = new SqlParameter("@selectedprojectid", projectids);
                param[8] = new SqlParameter("@selectedjobid", Jobids);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, pname, param))
                {
                    while (drrr.Read())
                    {
                        if (Convert.ToBoolean(TypeReport) == false)
                        {
                            obj_Job.Add(new tbl_JobClientSummaryReport()
                            {
                                Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                client = objComm.GetValue<string>(drrr["Projectname"].ToString()),
                                Mjobname = objComm.GetValue<string>(drrr["Jobname"].ToString()),
                                hours = objComm.GetValue<string>(drrr["Hours"].ToString()),
                                charges = objComm.GetValue<string>(drrr["charges"].ToString()),
                                Exp = objComm.GetValue<string>(drrr["ope"].ToString()),
                                ExpCharges = objComm.GetValue<string>(drrr["ChargeOPE"].ToString()),

                            });
                        }
                        else
                        {
                            obj_Job.Add(new tbl_JobClientSummaryReport()
                            {
                                Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                client = objComm.GetValue<string>(drrr["Projectname"].ToString()),
                                Mjobname = objComm.GetValue<string>(drrr["Jobname"].ToString()),
                                hours = objComm.GetValue<string>(drrr["Hours"].ToString()),
                                clientgrp = objComm.GetValue<string>(drrr["tDate"].ToString()),
                                charges = objComm.GetValue<string>(drrr["charges"].ToString()),
                                Exp = objComm.GetValue<string>(drrr["ope"].ToString()),
                                ExpCharges = objComm.GetValue<string>(drrr["ChargeOPE"].ToString()),

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

        IEnumerable<tbl_JobClientSummaryReport> tbl = obj_Job as IEnumerable<tbl_JobClientSummaryReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetBillNonBillProjectwiseReport(string frmdt, string Todt, string TStatus, string billtype, string brnch, string Staffids, string projectids, string Jobids, string TypeReport)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_JobClientSummaryReport> obj_Job = new List<tbl_JobClientSummaryReport>();
        try
        {
            if (Session["companyid"] != null)
            {
                string pname = "";
                if (Convert.ToBoolean(TypeReport) == false)
                {
                    pname = "usp_Bootstrap_BillNonBillProjectSummary_rpt";
                }
                else
                {
                    pname = "usp_Bootstrap_BillNonBillProjectDetail_rpt";
                }

                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[9];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@FromDate", frmdt);
                param[2] = new SqlParameter("@ToDate", Todt);
                param[3] = new SqlParameter("@TStatus", TStatus);
                param[4] = new SqlParameter("@type", billtype);
                param[5] = new SqlParameter("@Brid", brnch);
                param[6] = new SqlParameter("@selectedstaffcode", Staffids);
                param[7] = new SqlParameter("@selectedprojectid", projectids);
                param[8] = new SqlParameter("@selectedjobid", Jobids);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, pname, param))
                {
                    while (drrr.Read())
                    {
                        if (Convert.ToBoolean(TypeReport) == false)
                        {
                            obj_Job.Add(new tbl_JobClientSummaryReport()
                            {
                                Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                client = objComm.GetValue<string>(drrr["Projectname"].ToString()),
                                Mjobname = objComm.GetValue<string>(drrr["Jobname"].ToString()),
                                hours = objComm.GetValue<string>(drrr["Hours"].ToString()),
                                charges = objComm.GetValue<string>(drrr["charges"].ToString()),
                                Exp = objComm.GetValue<string>(drrr["ope"].ToString()),
                                ExpCharges = objComm.GetValue<string>(drrr["ChargeOPE"].ToString()),

                            });
                        }
                        else
                        {
                            obj_Job.Add(new tbl_JobClientSummaryReport()
                            {
                                Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                client = objComm.GetValue<string>(drrr["Projectname"].ToString()),
                                Mjobname = objComm.GetValue<string>(drrr["Jobname"].ToString()),
                                hours = objComm.GetValue<string>(drrr["Hours"].ToString()),
                                clientgrp = objComm.GetValue<string>(drrr["tDate"].ToString()),
                                charges = objComm.GetValue<string>(drrr["charges"].ToString()),
                                Exp = objComm.GetValue<string>(drrr["ope"].ToString()),
                                ExpCharges = objComm.GetValue<string>(drrr["ChargeOPE"].ToString()),

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

        IEnumerable<tbl_JobClientSummaryReport> tbl = obj_Job as IEnumerable<tbl_JobClientSummaryReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    //////////Actual vs Budget

    [WebMethod]
    public string GetClient_ProjectBudg(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            DateTime strdate = Convert.ToDateTime(currobj.Fromdate, ci);
            DateTime enddate = Convert.ToDateTime(currobj.Todate, ci);

            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@Todate", enddate);
            param[2] = new SqlParameter("@selectedclient", currobj.selectedstaffCode.TrimEnd(','));
            param[3] = new SqlParameter("@needproject", currobj.needproject);
            param[4] = new SqlParameter("@needstaff", currobj.needstaff);
            param[5] = new SqlParameter("@fromdate", strdate);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Boostrap_ClientProjectwiseBudg", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string GetProjectwiseBudgReport(string compid, string frmdt, string Todt, string TStatus, string cltidids, string projectids)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectwiseBudget> obj_Job = new List<tbl_ProjectwiseBudget>();
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@FromDate", frmdt);
            param[2] = new SqlParameter("@ToDate", Todt);
            param[3] = new SqlParameter("@TStatus", TStatus);
            param[4] = new SqlParameter("@selectedcltid", cltidids);
            param[5] = new SqlParameter("@selectedjobid", projectids);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ActualVsBudgRpt", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectwiseBudget()
                    {
                        Client = objComm.GetValue<string>(drrr["Client"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["Projectname"].ToString()),
                        PrjStart = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        PrjEnd = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        BudgAmt = objComm.GetValue<string>(drrr["PrjAmt"].ToString()),
                        Budghrs = objComm.GetValue<string>(drrr["PrjHrs"].ToString()),
                        ActualHrs = objComm.GetValue<string>(drrr["ActulHrs"].ToString()),
                        ActulAmt = objComm.GetValue<string>(drrr["ActulAmt"].ToString()),
                        Diff = objComm.GetValue<string>(drrr["BalanceHour"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectwiseBudget> tbl = obj_Job as IEnumerable<tbl_ProjectwiseBudget>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



}