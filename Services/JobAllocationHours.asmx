<%@ WebService Language="C#" Class="JobAllocationHours" %>

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
public class JobAllocationHours : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]
    public string BindClient(int compid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_GetAllrecordAllocHrs> List_DS = new List<tbl_GetAllrecordAllocHrs>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetClient_JobAlloctHrs", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_GetAllrecordAllocHrs()
                    {
                        id = objComm.GetValue<int>(drrr["compid"].ToString()),

                    });
                }
                List<tbl_Alloc_Client> listAlloc_Client = new List<tbl_Alloc_Client>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAlloc_Client.Add(new tbl_Alloc_Client()
                            {
                                cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),

                            });
                        }
                    }
                }
                List<tbl_Alloc_Project> listAlloc_Project = new List<tbl_Alloc_Project>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAlloc_Project.Add(new tbl_Alloc_Project()
                            {
                                cltid = objComm.GetValue<int>(drrr["ClientID"].ToString()),
                                Projid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                                Projectname = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                                ProjectHrs = objComm.GetValue<string>(drrr["Project_Hours"].ToString()),
                                Startdate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                                enddate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                                JobStatus = objComm.GetValue<string>(drrr["JobStatus"].ToString()),
                            });
                        }
                    }
                }
                List<tbl_Alloc_Jobname> listAlloc_Jobname = new List<tbl_Alloc_Jobname>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAlloc_Jobname.Add(new tbl_Alloc_Jobname()
                            {
                                mJobid = objComm.GetValue<int>(drrr["MJobId"].ToString()),
                                mJobname = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                            });
                        }
                    }
                }
                List<tbl_Alloc_Staffname> listAlloc_Staffname = new List<tbl_Alloc_Staffname>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAlloc_Staffname.Add(new tbl_Alloc_Staffname()
                            {
                                Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                Type = objComm.GetValue<string>(drrr["Type"].ToString()),
                            });
                        }
                    }
                }
                foreach (var item in List_DS)
                {
                    item.list_Alloc_Client = listAlloc_Client;
                    item.list_Alloc_Project = listAlloc_Project;
                    item.list_Alloc_Jobname = listAlloc_Jobname;
                    item.list_Alloc_Staffname = listAlloc_Staffname;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_GetAllrecordAllocHrs> tbl = List_DS as IEnumerable<tbl_GetAllrecordAllocHrs>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string BindProject(int compid, int Editid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Add_Project> List_DS = new List<tbl_Add_Project>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            //param[1] = new SqlParameter("@cltid", cltid);
            param[1] = new SqlParameter("@Editid", Editid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetProject_JobAlloctHrs", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Add_Project()
                    {
                        cltid = objComm.GetValue<int>(drrr["ClientID"].ToString()),
                        Projid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        ProjectHrs = objComm.GetValue<string>(drrr["Project_Hours"].ToString()),
                        Startdate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        enddate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        JobStatus = objComm.GetValue<string>(drrr["JobStatus"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Add_Project> tbl = List_DS as IEnumerable<tbl_Add_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string BindProjectDetail(int compid, int cltid, int Projid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectDetails_Joba> List_DS = new List<tbl_ProjectDetails_Joba>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@projid", Projid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetProjectdetail_JobAlloctHrs", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_ProjectDetails_Joba()
                    {
                        Jobid = objComm.GetValue<int>(drrr["JobId"].ToString()),
                        Prijecthrs = objComm.GetValue<string>(drrr["Project_Hours"].ToString()),
                        Strtdt = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        Enddt = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        Status = objComm.GetValue<string>(drrr["JobStatus"].ToString()),
                    });
                }

                List<tbl_User_roles> listJobMapping = new List<tbl_User_roles>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listJobMapping.Add(new tbl_User_roles()
                            {
                                Id = objComm.GetValue<int>(drrr["mJobid"].ToString()),
                                Name = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                                Type = objComm.GetValue<string>(drrr["Type"].ToString()),

                            });
                        }
                    }
                }

                foreach (var item in List_DS)
                {

                    item.list_JobMapping = listJobMapping;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectDetails_Joba> tbl = List_DS as IEnumerable<tbl_ProjectDetails_Joba>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string BindStaff(int compid, int cltid, int mJobid, int Projectid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_User_roles> List_DS = new List<tbl_User_roles>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@mjobid", mJobid);
            param[2] = new SqlParameter("@cltid", cltid);
            param[3] = new SqlParameter("@projectid", Projectid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetStaff_JobAlloctHrs", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_User_roles()
                    {
                        Id = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        Name = objComm.GetValue<string>(drrr["StaffHours"].ToString()),
                        Type = objComm.GetValue<string>(drrr["Jobhours"].ToString()),
                        Rolenames = objComm.GetValue<string>(drrr["Totaltime"].ToString()),
                        Role_Id = objComm.GetValue<int>(drrr["TLid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_User_roles> tbl = List_DS as IEnumerable<tbl_User_roles>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string TempAdd(int compid, int cltid, int Projectid, int mJobid, string JobHours, string stf ,int TLid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_User_roles> List_DS = new List<tbl_User_roles>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@mJobid", mJobid);
            param[3] = new SqlParameter("@JobHours", JobHours);
            param[4] = new SqlParameter("@stf", stf);
            param[5] = new SqlParameter("@Projectid", Projectid);
            param[6] = new SqlParameter("@TLid", TLid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Insert_TempRecord_AllcHours", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_User_roles()
                    {
                        Id = objComm.GetValue<int>(drrr["mJobid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_User_roles> tbl = List_DS as IEnumerable<tbl_User_roles>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string BindJobname(int compid, int cltid, int Projectid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Assignments> List_DS = new List<Assignments>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@Projectid", Projectid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetJobname_JobAllocHrs", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new Assignments()
                    {
                        mJobID = objComm.GetValue<int>(drrr["mJobid"].ToString()),
                        MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        Assign_Id = objComm.GetValue<int>(drrr["tlid"].ToString()),
                        Assign_Name = objComm.GetValue<string>(drrr["staffname"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drrr["JobHours"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<Assignments> tbl = List_DS as IEnumerable<Assignments>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertAllocHrs(int compid, int cltid, int projectid, int editid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_User_roles> List_DS = new List<tbl_User_roles>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            //param[1] = new SqlParameter("@jobid", Jobid);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@projectid", projectid);
            param[3] = new SqlParameter("@editid", editid);
            //param[4] = new SqlParameter("@plid", PLid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Boostrap_Insert_AllocateHours", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_User_roles()
                    {
                        Id = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_User_roles> tbl = List_DS as IEnumerable<tbl_User_roles>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetAllocHrs(int compid, string srch, int pageindex, int pagesize, string drpSrch)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_GetJobAllocHour> List_DS = new List<tbl_GetJobAllocHour>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Srch", srch);
            param[2] = new SqlParameter("@pageindex", pageindex);
            param[3] = new SqlParameter("@pagesize", pagesize);
            param[4] = new SqlParameter("@drpSrch", drpSrch);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_JobAllocationHours", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_GetJobAllocHour()
                    {
                        sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Clintname = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        //Jobname = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        Staffcount = objComm.GetValue<int>(drrr["staffcount"].ToString()),
                        Jobhrs = objComm.GetValue<string>(drrr["JobHours"].ToString()),
                        cltid = objComm.GetValue<int>(drrr["Cltid"].ToString()),
                        Projctid = objComm.GetValue<int>(drrr["Projectid"].ToString()),
                        //mjobid = objComm.GetValue<int>(drrr["mJobid"].ToString()),
                        Jobid = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                        //plid = objComm.GetValue<int>(drrr["plid"].ToString()),
                        //LeaderName = objComm.GetValue<string>(drrr["LeaderName"].ToString()),
                        Tcount = objComm.GetValue<int>(drrr["Tcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_GetJobAllocHour> tbl = List_DS as IEnumerable<tbl_GetJobAllocHour>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    ///Edit
    [WebMethod]
    public string Get_EditAllocHrs(int compid, int Jobid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_User_roles> List_DS = new List<tbl_User_roles>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Jobid", Jobid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Edit_JobAllocationHours", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_User_roles()
                    {
                        Id = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_User_roles> tbl = List_DS as IEnumerable<tbl_User_roles>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteAllocHrs(int compid, int Jobid, int cltid, int projid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_User_roles> List_DS = new List<tbl_User_roles>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", Jobid);
            param[2] = new SqlParameter("@cltid", cltid);
            param[3] = new SqlParameter("@projid", projid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Delete_JobAllocationHours", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_User_roles()
                    {
                        Id = objComm.GetValue<int>(drrr["Jobid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_User_roles> tbl = List_DS as IEnumerable<tbl_User_roles>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    ///Delete the temp record
    [WebMethod]
    public string Temp_DeleteAllocHrs(int compid, int mJobid, int cltid, int Projectid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_User_roles> List_DS = new List<tbl_User_roles>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            //param[1] = new SqlParameter("@jobid", Jobid);
            param[1] = new SqlParameter("@mjobid", mJobid);
            param[2] = new SqlParameter("@cltid", cltid);
            param[3] = new SqlParameter("@Projectid", Projectid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Delete_TempJobAllocationHours", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_User_roles()
                    {
                        Id = objComm.GetValue<int>(drrr["Jobid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_User_roles> tbl = List_DS as IEnumerable<tbl_User_roles>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetProjStaffreport(int compid, string Start, string end, string needproject, string needstaff, string Projectid, string TStatus)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_User_roles> List_DS = new List<tbl_User_roles>();

        string fromdate = Start != "" ? Convert.ToDateTime(Start, ci).ToString("MM/dd/yyyy") : null;
        string todate = end != "" ? Convert.ToDateTime(end, ci).ToString("MM/dd/yyyy") : null;

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Startdt", fromdate);
            param[2] = new SqlParameter("@enddt", todate);
            param[3] = new SqlParameter("@needproj", needproject);
            param[4] = new SqlParameter("@needstaff", needstaff);
            param[5] = new SqlParameter("@projectid", Projectid);
            param[6] = new SqlParameter("@Tstatus", TStatus);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetProjectStaffReport", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_User_roles()
                    {
                        Id = objComm.GetValue<int>(drrr["Id"].ToString()),
                        Name = objComm.GetValue<string>(drrr["Name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["Type"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_User_roles> tbl = List_DS as IEnumerable<tbl_User_roles>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetProjreport(int compid, string Status)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_User_roles> List_DS = new List<tbl_User_roles>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@status", Status);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetJsrProject", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_User_roles()
                    {
                        Id = objComm.GetValue<int>(drrr["Id"].ToString()),
                        Name = objComm.GetValue<string>(drrr["Name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["Type"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_User_roles> tbl = List_DS as IEnumerable<tbl_User_roles>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
}