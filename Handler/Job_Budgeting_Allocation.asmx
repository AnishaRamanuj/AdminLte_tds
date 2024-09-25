<%@ WebService Language="C#" Class="Job_Budgeting_Allocation" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.ApplicationBlocks1.Data;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;
using CommonLibrary;
using System.Web.Script.Serialization;
using JTMSProject;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Job_Budgeting_Allocation  : System.Web.Services.WebService {

    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    [WebMethod]
    public string Get_Job_Budgeting_Allocation_Rolenames(int Compid, int StaffCode)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@StaffCode", StaffCode);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Job_Budgeting_Allocation_Rolenames", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        RoleID = objcomm.GetValue<int>(sdr["RoleID"].ToString()),
                        Rolename = objcomm.GetValue<string>(sdr["Rolename"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch
        {
            return null;
        }
    }


    [WebMethod]
    public string Delete_Job_Budgeting_Allocation_Budget(int Compid, int DeleteBudId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@DeleteBudId", DeleteBudId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Delete_Job_Budgeting_Allocation_Budget", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch
        {
            return null;
        }
    }


    [WebMethod]
    public string Get_Job_Budgeting_Allocation_ProjectNames(int Compid, int StaffCode, int RoleId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@StaffCode", StaffCode);
            param[2] = new SqlParameter("@RoleId", RoleId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Job_Budgeting_Allocation_ProjectNames", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["JobId"].ToString()),
                        Name = objcomm.GetValue<string>(sdr["Jobname"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch
        {
            return null;
        }
    }



    [WebMethod]
    public string Get_Job_Budgeting_Allocation_DepartmentNames(int Compid, int ProjectId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@ProjectId", ProjectId);

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Job_Budgeting_Allocation_DepartmentNames", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["DeptId"].ToString()),
                        Name = objcomm.GetValue<string>(sdr["DepartmentName"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch
        {
            return null;
        }
    }


    [WebMethod]
    public string Save_Job_Budgeting_Allocation_Hours(int Compid, int JobId, int DeptId, int ActivityId, string AllocHrs, int JobBudId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@DeptId", DeptId);

            param[3] = new SqlParameter("@ActivityId", ActivityId);

            param[4] = new SqlParameter("@AllocHrs", AllocHrs);

            param[5] = new SqlParameter("@JobBudId", JobBudId);


            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Job_Budgeting_Allocation_Hours", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id=objcomm.GetValue<int>(sdr["Id"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch
        {
            return null;
        }
    }


    [WebMethod]
    public string Save_Job_Budgeting_Allocation_BudgetHours(int Compid,  string AllocHrs, int JobBudId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@Compid", Compid);


            param[1] = new SqlParameter("@AllocHrs", AllocHrs);

            param[2] = new SqlParameter("@JobBudId", JobBudId);


            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Job_Budgeting_Allocation_BudgetHours", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch
        {
            return null;
        }
    }


    [WebMethod]
    public string Update_Job_Budgeting_Allocation_BudgetHours(int Compid, string AllocHrs, int JobBudId, int BudId, string BudDate)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@Compid", Compid);


            param[1] = new SqlParameter("@AllocHrs", AllocHrs);

            param[2] = new SqlParameter("@JobBudId", JobBudId);
            param[3] = new SqlParameter("@BudId", BudId);
            param[4] = new SqlParameter("@BudDate", BudDate);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Update_Job_Budgeting_Allocation_BudgetHours", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch
        {
            return null;
        }
    }

    [WebMethod]
    public string Delete_Job_Budgeting_Allocation_Jobs(int Compid, int JobBudId,string ip, string usr, string ut, string dt)
    {
        CommonFunctions objcomm = new CommonFunctions();
        DBAccess db = new DBAccess();
        DBAccess.PrintDelete(ip ,"Job Budgeting Allocation", usr, ut, dt);
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobBudId", JobBudId);

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Delete_Job_Budgeting_Allocation_Jobs", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch
        {
            return null;
        }
    }

    [WebMethod]
    public string Get_Job_Budgeting_Allocation_JobDetails(int Compid, int ProjectId, int DeptId, int JobBudId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Job_Budgeting_Allocation_Main> objtbl = new List<tbl_Job_Budgeting_Allocation_Main>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@ProjectId", ProjectId);
            param[2] = new SqlParameter("@DeptId", DeptId);
            param[3] = new SqlParameter("@JobBudId", JobBudId);

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Job_Budgeting_Allocation_JobDetails", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Job_Budgeting_Allocation_Main
                    {
                        AllocHrs = objcomm.GetValue<string>(sdr["AllocHrs"].ToString()),

                    });
                }

                List<tbl_Job_Budgeting_Allocation_jobNames> objtblJobs = new List<tbl_Job_Budgeting_Allocation_jobNames>();

                if (sdr.NextResult())
                {
                    if (sdr.HasRows)
                    {
                        while (sdr.Read())
                        {
                            objtblJobs.Add(new tbl_Job_Budgeting_Allocation_jobNames
                            {
                                ActivityId = objcomm.GetValue<int>(sdr["mJobid"].ToString()),
                                ActivityNames = objcomm.GetValue<string>(sdr["MJobName"].ToString()),

                            });
                        }
                    }
                }
                List<tbl_Job_Budgeting_Allocation_JobTable> objJobData = new List<tbl_Job_Budgeting_Allocation_JobTable>();
                if (sdr.NextResult())
                {
                    if (sdr.HasRows)
                    {
                        while (sdr.Read())
                        {
                            objJobData.Add(new tbl_Job_Budgeting_Allocation_JobTable
                            {
                                srno = objcomm.GetValue<int>(sdr["sino"].ToString()),
                                MJobName = objcomm.GetValue<string>(sdr["MJobName"].ToString()),
                                AllocHrs = objcomm.GetValue<string>(sdr["AllocatedHrs"].ToString()),
                                BudgetHours = objcomm.GetValue<string>(sdr["BudHours"].ToString()),
                                BuffHours = objcomm.GetValue<string>(sdr["BuffHours"].ToString()),
                                Id = objcomm.GetValue<int>(sdr["Id"].ToString()),

                            });
                        }
                    }
                }

                List<tbl_Job_Budgeting_Allocation> objtblBudData = new List<tbl_Job_Budgeting_Allocation>();
                if (sdr.NextResult())
                {
                    if (sdr.HasRows)
                    {
                        while (sdr.Read())
                        {
                            objtblBudData.Add(new tbl_Job_Budgeting_Allocation
                            {
                                sino = objcomm.GetValue<int>(sdr["sino"].ToString()),
                                FromDate = objcomm.GetValue<string>(sdr["FromDate"].ToString()),
                                ToDate = objcomm.GetValue<string>(sdr["ToDate"].ToString()),
                                BudgetHours = objcomm.GetValue<string>(sdr["BudHours"].ToString()),
                                Id = objcomm.GetValue<int>(sdr["Id"].ToString()),

                            });
                        }
                    }
                }

                foreach (var item in objtbl) {
                    item.tblBudJobname = objtblJobs;
                    item.tblJobTable = objJobData;
                    item.tbljobBudAlloc = objtblBudData;
                }
            }


            IEnumerable<tbl_Job_Budgeting_Allocation_Main> tbl = objtbl as IEnumerable<tbl_Job_Budgeting_Allocation_Main>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch
        {
            return null;
        }
    }





}