<%@ WebService Language="C#" Class="Job_budgeting" %>

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
public class Job_budgeting  : System.Web.Services.WebService {
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    [WebMethod]
    public string Get_Budgeting_Allocation_Rolenames(int Compid, int StaffCode)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@StaffCode", StaffCode);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Budgeting_Allocation_Rolenames", param))
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
        catch (Exception ex)
        {
            throw ex;
        }
    }




    [WebMethod]
    public string Get_Budgeting_Allocation_BudgetingType(int Compid, int StaffCode, int RoleID)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[1] = new SqlParameter("@StaffCode", StaffCode);
            param[2] = new SqlParameter("@RoleID", RoleID);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Budgeting_Allocation_BudgetingType", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Budgeting_type = objcomm.GetValue<string>(sdr["Budgeting_type"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]

    public string Get_Project_Budgeting_ProjectDetails(int Compid, int JobId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Project_Budgeting_ProjectDetails", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        sino = objcomm.GetValue<int>(sdr["sino"].ToString()),
                        Id = objcomm.GetValue<int>(sdr["ProjectBudDetailId"].ToString()),
                        BudgetHours = objcomm.GetValue<string>(sdr["BudgetHours"].ToString()),
                        FromDate = objcomm.GetValue<string>(sdr["FromDate"].ToString()),
                        ToDate = objcomm.GetValue<string>(sdr["TODATE"].ToString()),

                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]

    public string Save_Project_Budgeting_Budgeted_Hours(int Compid, int JobId, string BudHrs, int BudHrsId, string BudDate)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@BudHrs", BudHrs);
            param[3] = new SqlParameter("@BudHrsId", BudHrsId);
            param[4] = new SqlParameter("@BudDate", BudDate);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Project_Budgeting_Budgeted_Hours", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["ProjectBudId"].ToString()),
                        FromDate = objcomm.GetValue<string>(sdr["startdate"].ToString()),
                        ToDate = objcomm.GetValue<string>(sdr["enddate"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    //[WebMethod]
    //public string Get_Project_Budgeting_ProjectName(int Compid)
    //{
    //    CommonFunctions objcomm = new CommonFunctions();
    //    List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
    //    string results = "";
    //    try
    //    {
    //        SqlParameter[] param = new SqlParameter[4];
    //        param[0] = new SqlParameter("@Compid", Compid);

    //        using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Project_Budgeting_ProjectName", param))
    //        {
    //            while (sdr.Read())
    //            {
    //                objtbl.Add(new tbl_Budgeting_Allocation
    //                {
    //                    Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
    //                    Name = objcomm.GetValue<string>(sdr["name"].ToString()),
    //                    BudgetHours = objcomm.GetValue<string>(sdr["BudHrs"].ToString()),

    //                });
    //            }

    //        }
    //        IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
    //        results = new JavaScriptSerializer().Serialize(tbl);
    //        return results;
    //    }
    //     catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //}

    [WebMethod]
    public string Get_Project_Budgeting_ProjectName_Clientname(int Compid )
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@Compid", Compid);


            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Job_Budgeting_ProjectName_cilentname", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {

                        Name = objcomm.GetValue<string>(sdr["name"].ToString()),
                        Id = objcomm.GetValue<int>(sdr["jobid"].ToString()),

                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }


    //////////////project name for Job budgeting
    [WebMethod]
    public string Get_Job_Budgeting_ProjectName(int Compid)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@Compid", Compid);

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Job_Budgeting_ProjectName", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                        Name = objcomm.GetValue<string>(sdr["name"].ToString()),


                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }



    //////////////project name for department budgeting
    [WebMethod]
    public string Get_Department_Budgeting_ProjectName(int Compid)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@Compid", Compid);

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Department_Budgeting_ProjectName", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                        Name = objcomm.GetValue<string>(sdr["name"].ToString()),
                        BudgetHours = objcomm.GetValue<string>(sdr["BudHrs"].ToString()),

                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }


    [WebMethod]
    public string Get_Budgeting_Allocation_ClientProjectDepartmentJob(int Compid, int StaffCode, int RoleID, string Budgeting_Type)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@StaffCode", StaffCode);
            param[2] = new SqlParameter("@RoleID", RoleID);
            param[3] = new SqlParameter("@Budgeting_Type", Budgeting_Type);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Budgeting_Allocation_ClientProjectDepartmentJob", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                        Name = objcomm.GetValue<string>(sdr["name"].ToString()),
                        Type = objcomm.GetValue<string>(sdr["type"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }


    [WebMethod]
    public string Save_Budgeting_Allocation_ClientProjectDepartmentJob(int Compid, int JobId, int BudDeptid, int Activity, string BudHrs, string BuffHrs, string BudgetType)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@BudHrs", BudHrs);
            param[3] = new SqlParameter("@BuffHrs", BuffHrs);
            param[4] = new SqlParameter("@BudgetType", BudgetType);
            param[5] = new SqlParameter("@BudDeptid", BudDeptid);
            param[6] = new SqlParameter("@ActivityId", Activity);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Budgeting_Allocation_ClientProjectDepartmentJob", param))
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
        catch (Exception ex)
        {
            throw ex;
        }
    }


    [WebMethod]
    public string Save_Budgeting_Allocation_Departments_Hours(int Compid, int JobId, int Deptid, string BudHrs, string BudgetType, int HdnDeptId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@BudHrs", BudHrs);
            param[3] = new SqlParameter("@BudgetType", BudgetType);
            param[4] = new SqlParameter("@Deptid", Deptid);
            param[5] = new SqlParameter("@HdnDeptId", HdnDeptId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Budgeting_Allocation_Departments_Hours", param))
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
        catch (Exception ex)
        {
            throw ex;
        }
    }


    [WebMethod]
    public string Delete_Budgeting_Allocation_Department(int Compid, int BudDeptId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@Compid", Compid);

            param[1] = new SqlParameter("@BudDeptId", BudDeptId);

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Delete_Budgeting_Allocation_Department", param))
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
        catch (Exception ex)
        {
            throw ex;
        }
    }


    [WebMethod]
    public string Save_Budgeting_Allocation_Budgeted_Hours(int Compid, int JobId, int BudDeptId, int Activity, string BudHrs, string BudgetType, int BudHrsId, string BudDate)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@BudHrs", BudHrs);
            param[3] = new SqlParameter("@BudgetType", BudgetType);
            param[4] = new SqlParameter("@BudHrsId", BudHrsId);
            param[5] = new SqlParameter("@BudDate", BudDate);
            param[6] = new SqlParameter("@BudDeptId", BudDeptId);
            param[7] = new SqlParameter("@ActivityId", Activity);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Budgeting_Allocation_Budgeted_Hours", param))
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
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public string Delete_Project_Budgeting_BudgetedHours(int Compid, int JobId, int BudHrsId, string BudHrs)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@BudHrs", BudHrs);
            param[3] = new SqlParameter("@BudHrsId", BudHrsId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Delete_Project_Budgeting_BudgetedHours", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        message = objcomm.GetValue<string>(sdr["message"].ToString()),

                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }



    [WebMethod]
    public string Get_Budgeting_Allocation_Details(int Compid, string BudgetType, int JobId, int BudDeptid, int Activity)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation_main> objtbl = new List<tbl_Budgeting_Allocation_main>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@BudgetType", BudgetType);
            param[2] = new SqlParameter("@JobId", JobId);
            param[3] = new SqlParameter("@BudDeptid", BudDeptid);
            param[4] = new SqlParameter("@ActivityId", Activity);

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Budgeting_Allocation_Details", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation_main
                    {

                        AllocHrs = objcomm.GetValue<string>(sdr["AllocHrs"].ToString()),


                    });
                }
                List<tbl_Budgeting_Allocation> objtblBudget = new List<tbl_Budgeting_Allocation>();
                if (sdr.NextResult())
                {
                    if (sdr.HasRows)
                    {
                        while (sdr.Read())
                        {
                            objtblBudget.Add(new tbl_Budgeting_Allocation
                            {
                                sino = objcomm.GetValue<int>(sdr["sino"].ToString()),
                                Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                                FromDate = objcomm.GetValue<string>(sdr["FromDate"].ToString()),
                                ToDate = objcomm.GetValue<string>(sdr["ToDate"].ToString()),
                                BudgetHours = objcomm.GetValue<string>(sdr["BudgetHours"].ToString()),
                            });
                        }
                    }
                }
                List<tbl_Budgeting_Allocation_Department> list_Department = new List<tbl_Budgeting_Allocation_Department>();
                if (sdr.NextResult())
                {
                    if (sdr.HasRows)
                    {
                        while (sdr.Read())
                        {
                            list_Department.Add(new tbl_Budgeting_Allocation_Department
                            {
                                srno = objcomm.GetValue<int>(sdr["srno"].ToString()),
                                Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                                Name = objcomm.GetValue<string>(sdr["DepartmentName"].ToString()),
                                AllocHrs = objcomm.GetValue<string>(sdr["AllocatedHrs"].ToString()),
                                BuffHours = objcomm.GetValue<string>(sdr["BuffHours"].ToString()),
                                BudgetHours = objcomm.GetValue<string>(sdr["BudHours"].ToString())

                            });
                        }
                    }
                }
                List<tbl_Budgeting_Allocation_Department_names> list_Department_names = new List<tbl_Budgeting_Allocation_Department_names>();
                if (sdr.NextResult())
                {
                    if (sdr.HasRows)
                    {
                        while (sdr.Read())
                        {
                            list_Department_names.Add(new tbl_Budgeting_Allocation_Department_names
                            {

                                Id = objcomm.GetValue<int>(sdr["DepId"].ToString()),
                                Name = objcomm.GetValue<string>(sdr["DepartmentName"].ToString()),


                            });
                        }
                    }
                }
                foreach (var item in objtbl)
                {
                    item.list_Budgeting = objtblBudget;
                    item.list_Department = list_Department;
                    item.list_Department_Names = list_Department_names;
                }
            }

            IEnumerable<tbl_Budgeting_Allocation_main> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation_main>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }


    /////////////////////department Budegting


    [WebMethod]

    public string Get_Department_Budgeting_DepartmentDetails(int Compid, int JobId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Department_Budgeting_DepartmentDetails", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        sino = objcomm.GetValue<int>(sdr["sino"].ToString()),
                        Id = objcomm.GetValue<int>(sdr["DeptBudId"].ToString()),
                        Name = objcomm.GetValue<string>(sdr["DepartmentName"].ToString()),
                        BudgetHours = objcomm.GetValue<string>(sdr["AllocatedHrs"].ToString()),



                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }




    /////////////////////Job Budegting


    [WebMethod]

    public string Get_Job_Budgeting_DepartmentDetails(int Compid, int JobId, int DeptId, string FromDate, string ToDate, int pageindex, int pagesize)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@DeptId", DeptId);
            param[3]= new SqlParameter("@FromDate",FromDate);
            param[4]= new SqlParameter("@Todate",ToDate);
            param[5] = new SqlParameter("@pageindx", pageindex);
            param[6] = new SqlParameter("@pagesize", pagesize);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Job_Budgeting_DepartmentDetails", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        sino = objcomm.GetValue<int>(sdr["sino"].ToString()),
                        Jobdetid = objcomm.GetValue<int>(sdr["JobBudDetailId"].ToString()),
                        JobBudId = objcomm.GetValue<int>(sdr["JobBudId"].ToString()),
                        JobName = objcomm.GetValue<string>(sdr["MJobName"].ToString()),
                        BudgetHours = objcomm.GetValue<string>(sdr["AllocatedHrs"].ToString()),
                        FromDate = objcomm.GetValue<string>(sdr["FromDate"].ToString()),
                        ToDate = objcomm.GetValue<string>(sdr["ToDate"].ToString()),
                        budamt = objcomm.GetValue<string>(sdr["BudAmt"].ToString()),
                        Totalcount = objcomm.GetValue<int>(sdr["TotalCount"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public string Get_Department_Budgeting_DepartmentName(int Compid, int JobId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Department_Budgeting_DepartmentName", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                        Name = objcomm.GetValue<string>(sdr["name"].ToString()),


                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public string Get_Job_Budgeting_JobName(int Compid, int DeptId, int JobId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@DeptId", DeptId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Job_Budgeting_JobName", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                        Name = objcomm.GetValue<string>(sdr["name"].ToString()),


                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public string Get_fill_job_budgeting(int Compid, int JobId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@jobid", JobId);
            //param[2] = new SqlParameter("@FromDate", fdate);
            //param[3] = new SqlParameter("@Todate", todate);

            //using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_get_jobname_Budgeting", param))
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_get_jobname", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        jobid = objcomm.GetValue<int>(sdr["jobid"].ToString()),
                        Name = objcomm.GetValue<string>(sdr["name"].ToString()),
                        sino = objcomm.GetValue<int>(sdr["sino"].ToString()),
                        FromDate = objcomm.GetValue<string>(sdr["FromDate"].ToString()),
                        todate = objcomm.GetValue<string>(sdr["Todate"].ToString()),
                        budamt = objcomm.GetValue<string>(sdr["Budamt"].ToString()),
                        budhrs = objcomm.GetValue<string>(sdr["BudHours"].ToString()),
                        jid = objcomm.GetValue<int>(sdr["jid"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public string Save_Department_Budgeting_Allocated_Hours(int Compid, int JobId, string BudHrs, int DeptId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@DeptId", DeptId);
            param[3] = new SqlParameter("@BudHrs", BudHrs);

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Department_Budgeting_Allocated_Hours", param))
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
        catch (Exception ex)
        {
            throw ex;
        }
    }


    [WebMethod]
    public string Save_Job_Budgeting_Allocated_Hours(int Compid, int JobId, int DeptId, string BudHrs, string fdate, string todate, string budamt, string bb )
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@DeptId", DeptId);
            param[3] = new SqlParameter("@BudHrs", BudHrs);
            //param[4] = new SqlParameter("@mjobid", mjobid);
            param[4] = new SqlParameter("@Fromdate", fdate);
            param[5] = new SqlParameter("@Todate", todate);
            param[6] = new SqlParameter("@Budamt", budamt);
            param[7] = new SqlParameter("@bb", bb.TrimStart('^'));

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Job_Budgeting_Allocated_Hours", param))
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
        catch (Exception ex)
        {
            throw ex;
        }
    }


    [WebMethod]
    public string Delete_Job_Budgeting_AllocatedHours(int Compid, int DeptId, int BudHrsId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@DeptId", DeptId);
            param[2] = new SqlParameter("@BudHrsId", BudHrsId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Delete_Job_Budgeting_AllocatedHours", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        message = objcomm.GetValue<string>(sdr["message"].ToString()),

                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }



    [WebMethod]
    public string Delete_Department_Budgeting_AllocatedHours(int Compid, int JobId, int BudHrsId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@BudHrsId", BudHrsId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Delete_Department_Budgeting_AllocatedHours", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        message = objcomm.GetValue<string>(sdr["message"].ToString()),

                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }



    [WebMethod]
    public string Get_Department_Budgeting_BudgetDetails(int Compid, int BudHrsId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@Compid", Compid);

            param[1] = new SqlParameter("@BudHrsId", BudHrsId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Department_Budgeting_BudgetDetails", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        sino = objcomm.GetValue<int>(sdr["sino"].ToString()),
                        Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                        FromDate = objcomm.GetValue<string>(sdr["FromDate"].ToString()),
                        ToDate = objcomm.GetValue<string>(sdr["TODATE"].ToString()),
                        BudgetHours = objcomm.GetValue<string>(sdr["BudHours"].ToString()),

                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }





    [WebMethod]
    public string Get_Job_Budgeting_BudgetDetails(int Compid, int BudHrsId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@Compid", Compid);

            param[1] = new SqlParameter("@BudHrsId", BudHrsId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Job_Budgeting_BudgetDetails", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        sino = objcomm.GetValue<int>(sdr["sino"].ToString()),
                        Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                        FromDate = objcomm.GetValue<string>(sdr["FromDate"].ToString()),
                        ToDate = objcomm.GetValue<string>(sdr["TODATE"].ToString()),
                        BudgetHours = objcomm.GetValue<string>(sdr["BudHours"].ToString()),

                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }



    [WebMethod]

    public string Save_Department_budgeting_Budget_Hours(int Compid, int JobId, string BudHrs, int BudHrsId, string BudDate, int DetailBudId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@BudHrs", BudHrs);
            param[3] = new SqlParameter("@BudHrsId", BudHrsId);
            param[4] = new SqlParameter("@BudDate", BudDate);
            param[5] = new SqlParameter("@DetailBudId", DetailBudId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Department_budgeting_Budget_Hours", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["DeptBudId"].ToString()),
                        FromDate = objcomm.GetValue<string>(sdr["fromDate"].ToString()),
                        ToDate = objcomm.GetValue<string>(sdr["Todate"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }


    [WebMethod]

    public string Save_Job_budgeting_Budget_Hours(int Compid, int JobId, int DeptId, string BudHrs, int BudHrsId, string BudDate, int DetailBudId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@BudHrs", BudHrs);
            param[3] = new SqlParameter("@BudHrsId", BudHrsId);
            param[4] = new SqlParameter("@BudDate", BudDate);
            param[5] = new SqlParameter("@DetailBudId", DetailBudId);
            param[6] = new SqlParameter("@DeptId", DeptId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Job_budgeting_Budget_Hours", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["JobBudId"].ToString()),
                        FromDate = objcomm.GetValue<string>(sdr["fromDate"].ToString()),
                        ToDate = objcomm.GetValue<string>(sdr["Todate"].ToString()),
                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }





    [WebMethod]
    public string Delete_Department_Budgeting_BudgetedHours(int Compid, int JobId, int BudDptId, string BudHrs, int BudHrsId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@BudHrs", BudHrs);
            param[3] = new SqlParameter("@BudHrsId", BudHrsId);
            param[4] = new SqlParameter("@BudDptId", BudDptId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Delete_Department_Budgeting_BudgetedHours", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        message = objcomm.GetValue<string>(sdr["message"].ToString()),

                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }




    [WebMethod]
    public string Delete_Job_Budgeting_BudgetedHours(int Compid, int JobId, int DeptId, int BudDptId, string BudHrs, int BudHrsId,string ip, string usr, string ut, string dt)
    {
        CommonFunctions objcomm = new CommonFunctions();
        DBAccess db = new DBAccess();
        DBAccess.PrintDelete(ip ,"Job Budgeting Allocation", usr, ut, dt);
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);
            param[2] = new SqlParameter("@BudHrs", BudHrs);
            param[3] = new SqlParameter("@BudHrsId", BudHrsId);
            param[4] = new SqlParameter("@BudDptId", BudDptId);
            param[5] = new SqlParameter("@DeptId", DeptId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Delete_Job_Budgeting_BudgetedHours", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        message = objcomm.GetValue<string>(sdr["msg"].ToString()),

                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }



    ////////get job budgeting department names

    [WebMethod]
    public string Get_Job_Budgeting_DepartmentNames(int Compid, int JobId)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_Budgeting_Allocation> objtbl = new List<tbl_Budgeting_Allocation>();
        string results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@JobId", JobId);

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Job_Budgeting_DepartmentNames", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Budgeting_Allocation
                    {
                        Id = objcomm.GetValue<int>(sdr["Id"].ToString()),
                        Name = objcomm.GetValue<string>(sdr["Name"].ToString()),
                        BudgetHours = objcomm.GetValue<string>(sdr["BudgetHours"].ToString()),


                    });
                }

            }
            IEnumerable<tbl_Budgeting_Allocation> tbl = objtbl as IEnumerable<tbl_Budgeting_Allocation>;
            results = new JavaScriptSerializer().Serialize(tbl);
            return results;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public string Update_JobBudgetDetail(int Compid, string Fromdt, string Todt, string BudHrs, string BudAmt, int JobBudDtl)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_JobBudget_Update> objtbl = new List<tbl_JobBudget_Update>();

        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@jobdtid", JobBudDtl);
            param[2] = new SqlParameter("@frdate",Fromdt);
            param[3] = new SqlParameter("@todate", Todt);
            param[4] = new SqlParameter("@budhrs",BudHrs);
            param[5] = new SqlParameter("@budamt", BudAmt);

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Update_Budgetdetail", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_JobBudget_Update
                    {
                        Jobid = objcomm.GetValue<int>(sdr["id"].ToString()),
                    });
                }

            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_JobBudget_Update> tbl = objtbl as IEnumerable<tbl_JobBudget_Update>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Delete_JobBudgetDetail(int Compid, int JobBudDtl)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_JobBudget_Update> objtbl = new List<tbl_JobBudget_Update>();

        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@jobdtdid", JobBudDtl);

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Delete_Job_budgetdetail", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_JobBudget_Update
                    {
                        Jobid = objcomm.GetValue<int>(sdr["id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_JobBudget_Update> tbl = objtbl as IEnumerable<tbl_JobBudget_Update>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}
