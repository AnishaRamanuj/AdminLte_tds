<%@ WebService Language="C#" Class="Planner" %>

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
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Planner : System.Web.Services.WebService
{

    [WebMethod(EnableSession = true)]
    public string OnPageLoad(string dt, string Srch, string stf)
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

            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@fromDT", fr);
            param[2] = new SqlParameter("@toDT", toDt);
            param[3] = new SqlParameter("@Srch", Srch);
            param[4] = new SqlParameter("@Stf", stf);
            //param[5] = new SqlParameter("@stafid", stafid);
            //param[6] = new SqlParameter("@prjid", prjid);

            //ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_New_WithHrs", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_New_WithHrs", param))
            {
                if (Srch == "Staff")
                {
                    while (drrr.Read())
                    {
                        List_DS.Add(new tbl_PlanneronLoad()
                        {
                            Compid = objComm.GetValue<int>(drrr["Compid"].ToString()),
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
                                    eff = objComm.GetValue<string>(drrr["eff"].ToString()),
                                    PLStartDt = objComm.GetValue<string>(drrr["ST"].ToString()),
                                    PLEndDt = objComm.GetValue<string>(drrr["ED"].ToString()),
                                    PLSTDt = objComm.GetValue<string>(drrr["STDT"].ToString()),
                                    PLEDDt = objComm.GetValue<string>(drrr["EDDT"].ToString()),
                                    Approved = objComm.GetValue<string>(drrr["Appr"].ToString()),
                                    Submitted = objComm.GetValue<string>(drrr["Subm"].ToString()),
                                    Saved = objComm.GetValue<string>(drrr["Saved"].ToString()),
                                    rejected = objComm.GetValue<string>(drrr["reject"].ToString()),
                                });
                            }
                        }
                    }

                    List<tbl_Budgeting_Allocation_Department_names> listdeptdtls = new List<tbl_Budgeting_Allocation_Department_names>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listdeptdtls.Add(new tbl_Budgeting_Allocation_Department_names()
                                {
                                    Id = objComm.GetValue<int>(drrr["DepId"].ToString()),
                                    Name = objComm.GetValue<string>(drrr["DepartmentName"].ToString())

                                });
                            }
                        }
                    }
                    foreach (var item in List_DS)
                    {
                        item.list_Team = listTeam;
                        item.list_stfjob = listcnt;
                        item.list_jdtls = listdtls;
                        item.list_deptdtls = listdeptdtls;

                    }

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

    [WebMethod(EnableSession = true)]
    public string OnPageLoadDept(string dt, string Srch, string stf, int deptid)
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

            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@fromDT", fr);
            param[2] = new SqlParameter("@toDT", toDt);
            param[3] = new SqlParameter("@Srch", Srch);
            param[4] = new SqlParameter("@Stf", stf);
            param[5] = new SqlParameter("@deptid", deptid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_New_WithHrs_Dept", param))
            {
                if (Srch == "Staff")
                {
                    while (drrr.Read())
                    {
                        List_DS.Add(new tbl_PlanneronLoad()
                        {
                            Compid = objComm.GetValue<int>(drrr["Compid"].ToString()),
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
                                });
                            }
                        }
                    }

                    List<tbl_Budgeting_Allocation_Department_names> listdeptdtls = new List<tbl_Budgeting_Allocation_Department_names>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listdeptdtls.Add(new tbl_Budgeting_Allocation_Department_names()
                                {
                                    Id = objComm.GetValue<int>(drrr["DepId"].ToString()),
                                    Name = objComm.GetValue<string>(drrr["DepartmentName"].ToString())

                                });
                            }
                        }
                    }
                    foreach (var item in List_DS)
                    {
                        item.list_Team = listTeam;
                        item.list_stfjob = listcnt;
                        item.list_jdtls = listdtls;
                        item.list_deptdtls = listdeptdtls;
                    }

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

    [WebMethod(EnableSession = true)]
    public string GetProject(int compid = 0)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_Project", param);


        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(ds);

    }

    [WebMethod(EnableSession = true)]
    public string GetStaffProject(int stfid)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@stfid", stfid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_Project_New", param);


        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(ds);

    }

    [WebMethod(EnableSession = true)]
    public string GetActivity(int compid = 0)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_Activity", param);


        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(ds);

    }


    [WebMethod(EnableSession = true)]
    public string GetProjectActivity(int jid, int sid)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Jid", jid);
            param[2] = new SqlParameter("@Sid", sid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_ProjectActivity_New", param);


        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(ds);

    }

    [WebMethod(EnableSession = true)]
    public string SaveProject(int j, string st, string ed, int sid, int plid, float average, string comment, int activity, string hrs, string hrsext)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            //Common ob = new Common();
            //SqlParameter[] param = new SqlParameter[9];
            //param[0] = new SqlParameter("@compid", compid);
            //param[1] = new SqlParameter("@j", j);
            //param[2] = new SqlParameter("@st", st);
            //param[3] = new SqlParameter("@ed", ed);
            //param[4] = new SqlParameter("@sid", sid);
            //param[5] = new SqlParameter("@plid", plid);
            //param[6] = new SqlParameter("@average", average);
            //param[7] = new SqlParameter("@comment", comment);
            //param[8] = new SqlParameter("@activity", activity);
            //using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_Save_New", param))
            //{

            //}

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[11];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@j", j);
            param[2] = new SqlParameter("@st", st);
            param[3] = new SqlParameter("@ed", ed);
            param[4] = new SqlParameter("@sid", sid);
            param[5] = new SqlParameter("@plid", plid);
            param[6] = new SqlParameter("@average", average);
            param[7] = new SqlParameter("@comment", comment);
            param[8] = new SqlParameter("@activity", activity);
            param[9] = new SqlParameter("@hrs", hrs);
            param[10] = new SqlParameter("@hrsext", hrsext);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_Save_New_WithHrs", param))
            {

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(j);

    }

    [WebMethod(EnableSession = true)]
    public string GetStaffPlanner(string dt, int Staffid, string IsApprover)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Planner_JobDetails> listdtls = new List<tbl_Planner_JobDetails>();
        DataSet ds;
        try
        {
            if (Session["companyid"] != null)
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


                //toDt = "01/01/2001";
                toDt = d[1] + "/" + d[0] + "/" + DateTime.DaysInMonth(Convert.ToInt32(d[1]), Convert.ToInt32(d[0]));
                Common ob = new Common();

                SqlParameter[] param = new SqlParameter[5];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@fromDT", fr);
                param[2] = new SqlParameter("@toDT", toDt);
                param[3] = new SqlParameter("@StaffID", Staffid);
                param[4] = new SqlParameter("@IsApprover", IsApprover);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetStaffPlannerV2", param))
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
                            //Plid = objComm.GetValue<int>(drrr["Plid"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                            average = objComm.GetValue<float>(drrr["Average"].ToString()),
                            comment = objComm.GetValue<string>(drrr["comment"].ToString()),
                            clientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                            MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                            pendingDays = objComm.GetValue<int>(drrr["pendingDays"].ToString()),
                            allocatedHours = objComm.GetValue<string>(drrr["THrs"].ToString()),
                            effort_hour = objComm.GetValue<string>(drrr["effort_hour"].ToString()),
                            mJobid = objComm.GetValue<int>(drrr["mJobid"].ToString()),
                            jobStatus = objComm.GetValue<string>(drrr["JobStatus"].ToString()),
                        });
                    }



                    //foreach (var item in List_DS)
                    //{
                    //    item.list_jdtls = listdtls;

                    //}

                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Planner_JobDetails> tbl = listdtls as IEnumerable<tbl_Planner_JobDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod(EnableSession = true)]
    public string Planner_Available(string fromdt)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectonLoad> List_DS = new List<tbl_ProjectonLoad>();
        DataSet ds;
        try
        {
            string[] d = fromdt.Split('-');
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


            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@fromDT", fr);
            //param[2] = new SqlParameter("@toDT", todt);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_Available", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }




    [WebMethod(EnableSession = true)]
    public string StaffOnPageLoad(string dt, int Staffid, string IsApprover)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_PlanneronLoad> List_DS = new List<tbl_PlanneronLoad>();
        DataSet ds;
        try
        {
            if (Session["companyid"] != null)
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


                //toDt = "01/01/2001";
                toDt = d[1] + "/" + d[0] + "/" + DateTime.DaysInMonth(Convert.ToInt32(d[1]), Convert.ToInt32(d[0]));
                Common ob = new Common();

                SqlParameter[] param = new SqlParameter[5];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@fromDT", fr);
                param[2] = new SqlParameter("@toDT", toDt);
                param[3] = new SqlParameter("@StaffCode", Staffid);
                param[4] = new SqlParameter("@IsApprover", IsApprover);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_StaffV2", param))
                {

                    while (drrr.Read())
                    {
                        List_DS.Add(new tbl_PlanneronLoad()
                        {
                            Compid = objComm.GetValue<int>(drrr["Compid"].ToString()),
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
                                    mJobid = objComm.GetValue<int>(drrr["mJobid"].ToString()),
                                    MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
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
                                    eff = objComm.GetValue<string>(drrr["eff"].ToString()),
                                });
                            }
                        }
                    }

                    List<tbl_Budgeting_Allocation_Department_names> listdeptdtls = new List<tbl_Budgeting_Allocation_Department_names>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listdeptdtls.Add(new tbl_Budgeting_Allocation_Department_names()
                                {
                                    Id = objComm.GetValue<int>(drrr["DepId"].ToString()),
                                    Name = objComm.GetValue<string>(drrr["DepartmentName"].ToString())

                                });
                            }
                        }
                    }
                    foreach (var item in List_DS)
                    {
                        item.list_Team = listTeam;
                        item.list_stfjob = listcnt;
                        item.list_jdtls = listdtls;
                        item.list_deptdtls = listdeptdtls;

                    }


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

}

