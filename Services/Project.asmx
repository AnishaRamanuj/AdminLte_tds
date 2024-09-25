<%@ WebService Language="C#" Class="Project" %>

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
using System.Linq;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Project : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod(EnableSession=true)]
    public string OnPageLoad(int pageIndex, int pageSize, string Srch, string status,string sortType)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectonLoad> List_DS = new List<tbl_ProjectonLoad>();
        DataSet ds;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@pageIndex", pageIndex);
            param[2] = new SqlParameter("@pageSize", pageSize);
            param[3] = new SqlParameter("@Srch", Srch);
            param[4] = new SqlParameter("@status", status);
            param[5] = new SqlParameter("@SortBy", sortType);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        //IEnumerable<tbl_ProjectonLoad> tbl = List_DS as IEnumerable<tbl_ProjectonLoad>;
        //var obbbbb = tbl;
        //return new JavaScriptSerializer().Serialize(tbl);
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string ActnTeam(int compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectonLoad> List_DS = new List<tbl_ProjectonLoad>();
        DataSet ds;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_ActnTeam", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        //IEnumerable<tbl_ProjectonLoad> tbl = List_DS as IEnumerable<tbl_ProjectonLoad>;
        //var obbbbb = tbl;
        //return new JavaScriptSerializer().Serialize(tbl);
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string OnSelect(int Pid, string fromdate, string todate)
    {
        CommonFunctions objComm = new CommonFunctions();
        // List<tbl_ProjectonLoad> List_DS = new List<tbl_ProjectonLoad>();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        //DataSet ds;
        try
        {
            string Srch = "";
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            //ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Select_new", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Select_new", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project()
                    {
                        Compid = 0,
                    });
                }

                List<tbl_ProjectManagers> listProjectManagers = new List<tbl_ProjectManagers>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listProjectManagers.Add(new tbl_ProjectManagers()
                            {
                                StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                StaffRoll = objComm.GetValue<int>(drrr["Staff_roll"].ToString()),
                                StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                RoleId = objComm.GetValue<int>(drrr["RoleId"].ToString()),
                                RoleName = objComm.GetValue<string>(drrr["RoleName"].ToString()),
                                isChecked = objComm.GetValue<string>(drrr["isChecked"].ToString())
                            });
                        }
                    }
                }



                foreach (var item in List_DS)
                {

                    item.list_ProjectManager = listProjectManagers;

                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Project> tbl = List_DS as IEnumerable<tbl_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
        // return ds.GetXml();
    }



    [WebMethod(EnableSession=true)]
    public string OnEdit(int Pid, string fromdate, string todate)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            string DOJs = fromdate != "" ? Convert.ToDateTime(fromdate, ci).ToString("MM/dd/yyyy") : null;
            string DoLs = todate != "" ? Convert.ToDateTime(todate, ci).ToString("MM/dd/yyyy") : null;

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Edit_New", param);

            //using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Edit", param))
            //{
            //    while (drrr.Read())
            //    {
            //        List_DS.Add(new tbl_Project()
            //        {
            //            Compid = objComm.GetValue<int>(drrr["Compid"].ToString()),
            //        });
            //    }

            //    List<tbl_Project_Details> List_PD = new List<tbl_Project_Details>();

            //    if (drrr.NextResult())
            //    {
            //        if (drrr.HasRows)
            //        {
            //            while (drrr.Read())
            //            {
            //                List_PD.Add(new tbl_Project_Details()
            //                {
            //                    PAmount = objComm.GetValue<double>(drrr["Project_Amount"].ToString()),
            //                    Pid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
            //                    PCode = objComm.GetValue<string>(drrr["project_code"].ToString()),
            //                    Project = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
            //                    Cid = objComm.GetValue<int>(drrr["ClientID"].ToString()),
            //                    PHours = objComm.GetValue<double>(drrr["Project_Hours"].ToString()),
            //                    ProductLine = objComm.GetValue<string>(drrr["ProductLine"].ToString()),
            //                    StarDt = objComm.GetValue<string>(drrr["StartDate"].ToString()),
            //                    EndDt = objComm.GetValue<string>(drrr["EndDate"].ToString()),
            //                    Currency = objComm.GetValue<string>(drrr["Currency"].ToString()),
            //                    PStatus = objComm.GetValue<string>(drrr["ProjectStatus"].ToString()),
            //                    Billable = objComm.GetValue<string>(drrr["Billable"].ToString()),
            //                    Expires = objComm.GetValue<string>(drrr["Never_expires"].ToString()),
            //                    ProjectDays = objComm.GetValue<int>(drrr["Project_Days"].ToString()),
            //                    ProjectBudget = objComm.GetValue<double>(drrr["Project_Budget"].ToString()),
            //                    ProjectOverview = objComm.GetValue<string>(drrr["Project_Overview"].ToString()),
            //                });
            //            }

            //        }

            //    }
            //    List<tbl_HoursTotal> List_SM = new List<tbl_HoursTotal>();

            //    if (drrr.NextResult())
            //    {
            //        if (drrr.HasRows)
            //        {
            //            while (drrr.Read())
            //            {
            //                List_SM.Add(new tbl_HoursTotal()
            //                {
            //                    TotalHrs = objComm.GetValue<string>(drrr["TotalHours"].ToString()),
            //                    Billhrs = objComm.GetValue<string>(drrr["Billable"].ToString()),
            //                    NonBillhrs = objComm.GetValue<string>(drrr["NonBillable"].ToString()),
            //                });
            //            }
            //        }
            //    }

            //    List<list_weekname> List_Wk = new List<list_weekname>();

            //    if (drrr.NextResult())
            //    {
            //        if (drrr.HasRows)
            //        {
            //            while (drrr.Read())
            //            {
            //                List_Wk.Add(new list_weekname()
            //                {
            //                    d1week = objComm.GetValue<string>(drrr["d1"].ToString()),
            //                    d2week = objComm.GetValue<string>(drrr["d2"].ToString()),
            //                    d3week = objComm.GetValue<string>(drrr["d3"].ToString()),
            //                    d4week = objComm.GetValue<string>(drrr["d4"].ToString()),
            //                    d5week = objComm.GetValue<string>(drrr["d5"].ToString()),
            //                    d6week = objComm.GetValue<string>(drrr["d6"].ToString()),
            //                    d7week = objComm.GetValue<string>(drrr["d7"].ToString()),
            //                });
            //            }
            //        }
            //    }
            //    foreach (var item in List_DS)
            //    {
            //        item.list_pd = List_PD;
            //        item.list_sm = List_SM;
            //        item.list_wk = List_Wk;
            //    }
            //}
        }
        catch (Exception ex)
        {
            throw ex;
        }
        //IEnumerable<tbl_Project> tbl = List_DS as IEnumerable<tbl_Project>;
        //var obbbbb = tbl;
        //return new JavaScriptSerializer().Serialize(tbl);
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Project_Save(int Pid, string Pdts, string did, string aid, string sid, string hdnOnly, string PLsid, string ProjDtl, string ProjOverview, string ProjManagers)
    {
        CommonFunctions objComm = new CommonFunctions();
        string Proc = "";
        if (hdnOnly == "0")
        {
            Proc = "usp_Bootstrap_Project_Save";
        }
        else if (hdnOnly == "1")
        {
            Proc = "usp_Bootstrap_ProjectOnly_Save"; /////////// ICT, GNS
        }
        else if (hdnOnly == "2")
        {
            Proc = "usp_Bootstrap_Project_Save";
        }
        List<tbl_Project_Details> List_DS = new List<tbl_Project_Details>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[10];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@Pdts", Pdts);
            param[3] = new SqlParameter("@did", did);
            param[4] = new SqlParameter("@aid", aid);
            param[5] = new SqlParameter("@sid", sid);
            param[6] = new SqlParameter("@PLsid", PLsid);

            //Poonam: added projction details - 15/12/22
            param[7] = new SqlParameter("@ProjDtl", ProjDtl);
            param[8] = new SqlParameter("@ProjOverview", ProjOverview);
            //Poonam: added project managers details - 20/12/22
            param[9] = new SqlParameter("@ProjManagers", ProjManagers);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, Proc, param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project_Details()
                    {
                        Pid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Project_Details> tbl = List_DS as IEnumerable<tbl_Project_Details>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string Chk_Dep(int did)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project_Dept> List_DS = new List<tbl_Project_Dept>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@did", did);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Dept_Chk", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project_Dept()
                    {
                        Did = objComm.GetValue<int>(drrr["Dept_Id"].ToString()),
                        Mjid = objComm.GetValue<int>(drrr["mjobid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Project_Dept> tbl = List_DS as IEnumerable<tbl_Project_Dept>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string Chk_Act(int act, string did)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project_Dept> List_DS = new List<tbl_Project_Dept>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@aid", act);
            param[2] = new SqlParameter("@did", did);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Activity_Chk_New", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project_Dept()
                    {
                        Did = objComm.GetValue<int>(drrr["Dept_Id"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Project_Dept> tbl = List_DS as IEnumerable<tbl_Project_Dept>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    //[WebMethod]
    //public string Chk_Act(int compid, int act)
    //{
    //    CommonFunctions objComm = new CommonFunctions();
    //    List<tbl_Project_Dept> List_DS = new List<tbl_Project_Dept>();
    //    try
    //    {
    //        Common ob = new Common();
    //        SqlParameter[] param = new SqlParameter[2];
    //        param[0] = new SqlParameter("@compid", compid);
    //        param[1] = new SqlParameter("@act", act);

    //        using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Activity_Chk", param))
    //        {
    //            while (drrr.Read())
    //            {
    //                List_DS.Add(new tbl_Project_Dept()
    //                {
    //                    Did = objComm.GetValue<int>(drrr["Dept_Id"].ToString()),
    //                    Mjid = objComm.GetValue<int>(drrr["mjobid"].ToString()),
    //                });
    //            }
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //    IEnumerable<tbl_Project_Dept> tbl = List_DS as IEnumerable<tbl_Project_Dept>;
    //    var obbbbb = tbl;
    //    return new JavaScriptSerializer().Serialize(tbl);
    //}

    [WebMethod(EnableSession=true)]
    public string GetTotalHours(string fromdate, string todate, int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_HoursTotal> List_SM = new List<tbl_HoursTotal>();
        string DOJs = fromdate != "" ? Convert.ToDateTime(fromdate, ci).ToString("MM/dd/yyyy") : null;
        string DoLs = todate != "" ? Convert.ToDateTime(todate, ci).ToString("MM/dd/yyyy") : null;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@fromdate", DOJs);
            param[2] = new SqlParameter("@todate", DoLs);
            param[3] = new SqlParameter("@Pid", Pid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_TotalHours_Graph", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_HoursTotal()
                    {
                        TotalHrs = objComm.GetValue<string>(drrr["TotalHours"].ToString()),
                        Billhrs = objComm.GetValue<string>(drrr["Billable"].ToString()),
                        NonBillhrs = objComm.GetValue<string>(drrr["NonBillable"].ToString()),
                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_HoursTotal> tbl = List_SM as IEnumerable<tbl_HoursTotal>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetTotalHoursBarGraph(string fromdate, string todate, int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<list_weekname> List_SM = new List<list_weekname>();
        string DOJs = fromdate != "" ? Convert.ToDateTime(fromdate, ci).ToString("MM/dd/yyyy") : null;
        string DoLs = todate != "" ? Convert.ToDateTime(todate, ci).ToString("MM/dd/yyyy") : null;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@fromdate", DOJs);
            param[2] = new SqlParameter("@todate", DoLs);
            param[3] = new SqlParameter("@Pid", Pid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_WeekHourBarGraph", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new list_weekname()
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
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<list_weekname> tbl = List_SM as IEnumerable<list_weekname>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string Delete_Project(int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Delete", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project()
                    {
                        Pid = objComm.GetValue<int>(drrr["ProjectId"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Project> tbl = List_DS as IEnumerable<tbl_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string Get_Resourcedetail(string frmdt, string Todt, string staffcode, int projectid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ResourcePlanning_AllocValid> obj_Job = new List<tbl_ResourcePlanning_AllocValid>();

        string Strtdate = frmdt != "" ? Convert.ToDateTime(frmdt, ci).ToString("MM/dd/yyyy") : null;
        string Endate = Todt != "" ? Convert.ToDateTime(Todt, ci).ToString("MM/dd/yyyy") : null;
        try
        {

            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@fromdate", Strtdate);
            param[2] = new SqlParameter("@Todate", Endate);
            param[3] = new SqlParameter("@staffcode", staffcode);
            param[4] = new SqlParameter("@projectid", projectid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ResourceDetailWrokAlloc", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ResourcePlanning_AllocValid()
                    {
                        Perhrs = objComm.GetValue<int>(drrr["PerHrs"].ToString()),
                    });
                }

                List<tbl_ProjectwiseReport> listJobMapping = new List<tbl_ProjectwiseReport>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listJobMapping.Add(new tbl_ProjectwiseReport()
                            {
                                clientname = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                                Projectname = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                                StaffName = objComm.GetValue<string>(drrr["FromDate"].ToString()),
                                Type = objComm.GetValue<string>(drrr["ToDate"].ToString()),
                                StaffCode = objComm.GetValue<int>(drrr["PerHrs"].ToString()),

                            });
                        }
                    }
                }

                foreach (var item in obj_Job)
                {

                    item.list_Unit = listJobMapping;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ResourcePlanning_AllocValid> tbl = obj_Job as IEnumerable<tbl_ResourcePlanning_AllocValid>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Planner(int compid, int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_PlanneronLoad> List_DS = new List<tbl_PlanneronLoad>();
        DataSet ds;
        try
        {

            Common ob = new Common();

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Pid", Pid);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Planner", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }
        //IEnumerable<tbl_PlanneronLoad> tbl = List_DS as IEnumerable<tbl_PlanneronLoad>;
        //var obbbbb = tbl;
        //return new JavaScriptSerializer().Serialize(tbl);
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string GetProjectManagers(int compid=0)
    {
        CommonFunctions objComm = new CommonFunctions();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@Compid", Session["companyid"]);
            List<tbl_ProjectManagers> listProjectManagers = new List<tbl_ProjectManagers>();
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetPojectManager", param))
            {
                while (drrr.Read())
                {
                    listProjectManagers.Add(new tbl_ProjectManagers()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffRoll = objComm.GetValue<int>(drrr["Staff_roll"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString())
                    });
                }
            }
            return new JavaScriptSerializer().Serialize(listProjectManagers);
        }
        catch (Exception ex)
        {
            throw ex;
        }

    }

    [WebMethod(EnableSession=true)]
    public string SaveMilestone(int projectId, string milestone, DateTime startDate, DateTime endDate, int statusId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectMilestone> listProjectMilestones = new List<tbl_ProjectMilestone>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@Pid", projectId);
            param[1] = new SqlParameter("@CompId", Session["companyid"]);
            param[2] = new SqlParameter("@Milestone", milestone);
            param[3] = new SqlParameter("@StartDate", startDate);
            param[4] = new SqlParameter("@EndDate", endDate);
            param[5] = new SqlParameter("@StatusId", statusId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ProjectMilestone_Save", param))
            {
                while (drrr.Read())
                {
                    listProjectMilestones.Add(new tbl_ProjectMilestone()
                    {
                        ProjectMilestoneId = objComm.GetValue<int>(drrr["ProjectMilestoneId"].ToString()),
                        ProjectId = objComm.GetValue<int>(drrr["ProjectId"].ToString()),
                        MilestoneName = objComm.GetValue<string>(drrr["MilestoneName"].ToString()),
                        StartDate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        EndDate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        Status = objComm.GetValue<string>(drrr["StatusName"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(listProjectMilestones);
    }

    [WebMethod]
    public string GetMilestoneMaster(int compId)
    {
        CommonFunctions objComm = new CommonFunctions();
        ProjectMilestoneMaster projectMilestonesMaster = new ProjectMilestoneMaster();
        List<tbl_Milestone> listMilestoneMaster = new List<tbl_Milestone>();
        List<tbl_ProjectMilestone> listProjectMilestones = new List<tbl_ProjectMilestone>();
        List<Project_master> listProjectMaster = new List<Project_master>();

        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@CompId", compId);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_MilestoneMaster", param))
            {
                while (drrr.Read())
                {
                    listProjectMaster.Add(new Project_master()
                    {
                        projectid = objComm.GetValue<int>(drrr["ProjectId"].ToString()),
                        projectName = objComm.GetValue<string>(drrr["ProjectName"].ToString())
                    });
                }

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listMilestoneMaster.Add(new tbl_Milestone()
                            {
                                MId = objComm.GetValue<int>(drrr["MilestoneId"].ToString()),
                                MName = objComm.GetValue<string>(drrr["MilestoneName"].ToString())
                            });
                        }
                    }
                }

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listProjectMilestones.Add(new tbl_ProjectMilestone()
                            {
                                ProjectMilestoneId = objComm.GetValue<int>(drrr["ProjectMilestoneId"].ToString()),
                                ProjectId = objComm.GetValue<int>(drrr["ProjectId"].ToString()),
                                ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                                MilestoneId = objComm.GetValue<int>(drrr["MilestoneId"].ToString()),
                                MilestoneName = objComm.GetValue<string>(drrr["MilestoneName"].ToString()),
                                StartDate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                                EndDate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                                Status = objComm.GetValue<string>(drrr["StatusName"].ToString())
                            });
                        }
                    }
                }

                projectMilestonesMaster.list_ProjectMaster = listProjectMaster;
                projectMilestonesMaster.list_MilestoneMaster = listMilestoneMaster;
                projectMilestonesMaster.list_ProjectMilestone = listProjectMilestones;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return new JavaScriptSerializer().Serialize(projectMilestonesMaster);
    }


    /////////////////////////// Planner

    [WebMethod(EnableSession=true)]
    public string PlannerLoad(string dt, string projectId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_PlanneronLoad> List_DS = new List<tbl_PlanneronLoad>();
        DataSet ds;
        try
        {
            string[] d = dt.Split('-');
            string fr = "";
            int mth = 0;
            int yr = 0;
            int ii = Convert.ToInt32(d[0].ToString());
            int ij = Convert.ToInt32(d[0].Length);
            string toDt = "";
            mth = Convert.ToInt32(d[0]);
            yr = Convert.ToInt32(d[1]);

            if (ii < 10 && ij == 1)
            {
                d[0] = "0" + d[0];
            }

            fr = d[1] + "/" + d[0] + "/01";


            toDt = "01/01/2001";
            Common ob = new Common();

            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@fromDT", fr);
            param[2] = new SqlParameter("@toDT", toDt);
            param[3] = new SqlParameter("@projectID", projectId);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ProjectPlanner_WithHrs_New", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ProjectPlanner_WithHrs_New", param))
            {

                while (drrr.Read())
                {
                    List_DS.Add(new tbl_PlanneronLoad()
                    {
                        Compid = 0,
                        Jid = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                        HrsAllocated = objComm.GetValue<string>(drrr["THrs"].ToString()),
                        //PlnType = objComm.GetValue<string>(drrr["PlannerType"].ToString()),
                        //PlnTyid = objComm.GetValue<int>(drrr["PlntyID"].ToString()),

                    });
                }



                List<tbl_Staff> listTeam = new List<tbl_Staff>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listTeam.Add(new tbl_Staff()
                            {
                                StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),

                            });
                        }
                    }
                }




                List<tbl_Planner_StaffJob> listcnt = new List<tbl_Planner_StaffJob>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listcnt.Add(new tbl_Planner_StaffJob()
                            {
                                staffcode = objComm.GetValue<int>(drrr["staffcode"].ToString()),
                                jobcnt = objComm.GetValue<int>(drrr["jobcnt"].ToString()),
                                StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                jobid = objComm.GetValue<int>(drrr["jobid"].ToString()),
                            });
                        }
                    }
                }



                List<tbl_Planner_JobDetails> listdtls = new List<tbl_Planner_JobDetails>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listdtls.Add(new tbl_Planner_JobDetails()
                            {
                                staffcode = objComm.GetValue<int>(drrr["staffcode"].ToString()),
                                jobid = objComm.GetValue<int>(drrr["jobid"].ToString()),
                                Tdays = objComm.GetValue<int>(drrr["Tdays"].ToString()),
                                frDT = objComm.GetValue<int>(drrr["fromdate"].ToString()),
                                toDT = objComm.GetValue<int>(drrr["todate"].ToString()),
                                Pname = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                                fDT = objComm.GetValue<string>(drrr["fdate"].ToString()),
                                tDT = objComm.GetValue<string>(drrr["tdate"].ToString()),
                                Plid = objComm.GetValue<int>(drrr["Plid"].ToString()),
                                StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                average = objComm.GetValue<float>(drrr["Average"].ToString()),
                                comment = objComm.GetValue<string>(drrr["comment"].ToString()),
                                mJobid = objComm.GetValue<int>(drrr["mJobid"].ToString()),
                                MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                                Hours = objComm.GetValue<double>(drrr["Hours"].ToString()),
                                HrsExtend = objComm.GetValue<string>(drrr["HrsExtend"].ToString()),
                                ProjectID = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                                ProjectStartDt = objComm.GetValue<string>(drrr["ProjStartDt"].ToString()),
                                ProjectEndDt = objComm.GetValue<string>(drrr["ProjEndDt"].ToString()),
                                PLStartDt = objComm.GetValue<string>(drrr["ST"].ToString()),
                                PLEndDt = objComm.GetValue<string>(drrr["ED"].ToString()),
                                PLSTDt = objComm.GetValue<string>(drrr["STDT"].ToString()),
                                PLEDDt = objComm.GetValue<string>(drrr["EDDT"].ToString()),
                            });
                        }
                    }
                }
                foreach (var item in List_DS)
                {
                    item.list_Team = listTeam;
                    item.list_stfjob = listcnt;
                    item.list_jdtls = listdtls;

                }


            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_PlanneronLoad> tbl = List_DS as IEnumerable<tbl_PlanneronLoad>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession=true)]
    public string GetProjectActivity(int projectid, int sid)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Projectid", projectid);
            param[2] = new SqlParameter("@Sid", sid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ProjectActivity", param);


        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(ds);

    }


    [WebMethod(EnableSession=true)]
    public string SaveActivity(int j, string st, string ed, int sid, int plid, float average, string comment, int activity, string hrs, string hrsext)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[11];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@ProjectID", j);
            param[2] = new SqlParameter("@st", st);
            param[3] = new SqlParameter("@ed", ed);
            param[4] = new SqlParameter("@sid", sid);
            param[5] = new SqlParameter("@plid", plid);
            param[6] = new SqlParameter("@average", average);
            param[7] = new SqlParameter("@comment", comment);
            param[8] = new SqlParameter("@activity", activity);
            param[9] = new SqlParameter("@hrs", hrs);
            param[10] = new SqlParameter("@hrsext", hrsext);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_Save_WithHrs", param))
            {

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(j);

    }

    [WebMethod(EnableSession=true)]
    public string RemovePlanner(int j, int sid, int plid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@ProjectID", j);
            param[2] = new SqlParameter("@sid", sid);
            param[3] = new SqlParameter("@plid", plid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_Remove", param))
            {

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(j);

    }


    [WebMethod(EnableSession=true)]
    public string Chk_SelectedActivity(string did, string act)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@did", did);
            param[2] = new SqlParameter("@act", act);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Activity_Chk_ALL", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(ds);

    }

}