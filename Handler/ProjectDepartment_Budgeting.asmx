<%@ WebService Language="C#" Class="ProjectDepartment_Budgeting" %>

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
using System.Web.Script.Services;
using System.Linq;
    using JTMSProject;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ProjectDepartment_Budgeting : System.Web.Services.WebService
{

    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

    [WebMethod]
    public string FillDrpClient(int compid)
    {
        List<tbl_DepartmentBudgeting> List_Clint = new List<tbl_DepartmentBudgeting>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_ClientProjName_DepBudg", param))

            {
                while (drrr.Read())
                {
                    List_Clint.Add(new tbl_DepartmentBudgeting()
                    {
                        Jobid = objComm.GetValue<int>(drrr["jobid"].ToString()),
                        Clientname = objComm.GetValue<string>(drrr["Name"].ToString()),
                    });
                }

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_DepartmentBudgeting> tbl = List_Clint as IEnumerable<tbl_DepartmentBudgeting>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string FilldrpDept(int compid, int Jobid, int dept)
    {
        List<tbl_DepartmentBudgeting> List_dept = new List<tbl_DepartmentBudgeting>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", Jobid);
            param[2] = new SqlParameter("@dept", dept);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_DeptName_DeptBudg", param))

            {
                while (drrr.Read())
                {
                    List_dept.Add(new tbl_DepartmentBudgeting()
                    {
                        depid = objComm.GetValue<int>(drrr["Dept_Id"].ToString()),
                        Deptname = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                    });
                }

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_DepartmentBudgeting> tbl = List_dept as IEnumerable<tbl_DepartmentBudgeting>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string SaveDeptBudget(int compid, int Jobid, int Depid, int BudgHrs, int AllocatBudg, string BudgDt)
    {
        List<tbl_DepartmentBudgeting> List_Save = new List<tbl_DepartmentBudgeting>();
        string fromdate = BudgDt != "" ? Convert.ToDateTime(BudgDt, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", Jobid);
            param[2] = new SqlParameter("@Depid", Depid);
            param[3] = new SqlParameter("@BudgtHrs", BudgHrs);
            param[4] = new SqlParameter("@Allocthrs", AllocatBudg);
            param[5] = new SqlParameter("@fromdt", fromdate);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_SaveDeptBudget", param))
            {
                while (drrr.Read())
                {
                    List_Save.Add(new tbl_DepartmentBudgeting()
                    {
                        depid = objComm.GetValue<int>(drrr["id"].ToString()),
                    });
                }

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_DepartmentBudgeting> tbl = List_Save as IEnumerable<tbl_DepartmentBudgeting>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GridFillDept(int compid, string Srch)
    {
        List<tbl_DepartmentBudgeting> List_dept = new List<tbl_DepartmentBudgeting>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_DepartmentBudget_Grid", param))

            {
                while (drrr.Read())
                {
                    List_dept.Add(new tbl_DepartmentBudgeting()
                    {
                        depid = objComm.GetValue<int>(drrr["deptid"].ToString()),
                        Jobid = objComm.GetValue<int>(drrr["JobId"].ToString()),
                        srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Deptname = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        Clientname = objComm.GetValue<string>(drrr["clientname"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["Projectname"].ToString()),
                        BudgetHrs = objComm.GetValue<int>(drrr["BudHours"].ToString()),
                        Fromdate = objComm.GetValue<string>(drrr["FromDate"].ToString()),
                    });
                }

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_DepartmentBudgeting> tbl = List_dept as IEnumerable<tbl_DepartmentBudgeting>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string EditDept(int compid, int Jobid, int dept)
    {
        List<UserDetails> details = new List<UserDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", Jobid);
            param[2] = new SqlParameter("@dept", dept);
            DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_EditDept_Budgeting", param);
            if (dss != null)
            {
                if (dss.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dtrow in dss.Tables[0].Rows)
                    {
                        UserDetails user = new UserDetails();
                        user.fromdate = dtrow["FromDate"].ToString();
                        user.Budgethours = dtrow["BudHours"].ToString();
                        user.AllocatedHours = dtrow["AllocatedHrs"].ToString();
                        user.temp_Id = dtrow["DeptBudId"].ToString();
                        details.Add(user);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        var obbbbb = details;
        return new JavaScriptSerializer().Serialize(details);
    }

    [WebMethod]
    public string GetTempRecordEdit(UserDetails id)
    {
        List<UserDetails> details = new List<UserDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@temp_Id", id.temp_Id);
            DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_EditTemp_RecordDeptBudg", param);
            if (dss != null)
            {
                if (dss.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dtrow in dss.Tables[0].Rows)
                    {
                        UserDetails user = new UserDetails();
                        user.fromdate = dtrow["fromdate"].ToString();
                        user.AllocatedHours = dtrow["AllocatedHrs"].ToString();
                        user.Budgethours = dtrow["BudHours"].ToString();
                        details.Add(user);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        var obbbbb = details;
        return new JavaScriptSerializer().Serialize(details);
    }

    [WebMethod]
    public string Gettempdata(int compid, int Jobid, int Dept)
    {
        List<UserDetails> details = new List<UserDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", Jobid);
            param[2] = new SqlParameter("@deptid", Dept);
            DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Department_temp_insert", param);
            if (dss != null)
            {
                if (dss.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dtrow in dss.Tables[0].Rows)
                    {
                        UserDetails user = new UserDetails();

                        user.todate = dtrow["todate"].ToString();
                        user.fromdate = dtrow["fromdate"].ToString();
                        user.Budgethours = dtrow["BudHours"].ToString();
                        user.AllocatedHours = dtrow["AllocatedHrs"].ToString();
                        user.temp_Id = dtrow["Dept_Master_Temp_id"].ToString();
                        details.Add(user);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        var obbbbb = details;
        return new JavaScriptSerializer().Serialize(details);
    }

    [WebMethod]
    public string SetTempBudgetDetails(UserDetails id)
    {
        List<UserDetails> details = new List<UserDetails>();
        try
        {
            Common ob = new Common();
            CultureInfo ci = new CultureInfo("en-GB");
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", id.compid);
            param[1] = new SqlParameter("@jobid", id.jobid);
            param[2] = new SqlParameter("@Deptid ", id.Dept);
            param[3] = new SqlParameter("@AllocatedHrs", id.AllocatedHours);
            param[4] = new SqlParameter("@Budgethours", id.Budgethours);
            param[5] = new SqlParameter("@temp_Id", id.temp_Id);
            param[6] = new SqlParameter("@fromdate", Convert.ToDateTime(id.fromdate, ci));
            DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_SaveTemp_DepartmentBudget", param);
            if (dss != null)
            {
                if (dss.Tables[0].Rows.Count > 0)
                {
                    if (dss.Tables[0].Rows[0][0].ToString() == "Error")
                    {
                        UserDetails user = new UserDetails();
                        user.StaffCode = "Error";
                        details.Add(user);
                    }
                    foreach (DataRow dtrow in dss.Tables[1].Rows)
                    {
                        UserDetails user = new UserDetails();
                        user.todate = dtrow["todate"].ToString();
                        user.fromdate = dtrow["fromdate"].ToString();
                        user.AllocatedHours = dtrow["AllocatedHrs"].ToString();
                        user.Budgethours = dtrow["Budhours"].ToString();
                        user.temp_Id = dtrow["Dept_Master_Temp_id"].ToString();
                        details.Add(user);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        var obbbbb = details;
        return new JavaScriptSerializer().Serialize(details);
    }

    [WebMethod]
    public string CnacelEmptyTemp(int compid, int Jobid, int Dept)
    {
        List<UserDetails> details = new List<UserDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", Jobid);
            param[2] = new SqlParameter("@deptid", Dept);
            DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Department_temp_empty", param);
            if (dss != null)
            {
                if (dss.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dtrow in dss.Tables[0].Rows)
                    {
                        UserDetails user = new UserDetails();

                        user.temp_Id = dtrow["temp_Id"].ToString();
                        details.Add(user);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        var obbbbb = details;
        return new JavaScriptSerializer().Serialize(details);
    }

    [WebMethod]
    public string BudgetDelete(int Compid, int Dept, int Jobid,string ip, string usr, string ut, string dt)

    {
        DBAccess db = new DBAccess();
        DBAccess.PrintDelete(ip ,"Department Budgeting", usr, ut, dt);
        List<tbl_DepartmentBudgeting> List_dept = new List<tbl_DepartmentBudgeting>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@jobid", Jobid);
            param[2] = new SqlParameter("@deptid", Dept);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Delete_DepartmentBudget", param))
            {
                while (drrr.Read())
                {
                    List_dept.Add(new tbl_DepartmentBudgeting()
                    {
                        depid = objComm.GetValue<int>(drrr["deptid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_DepartmentBudgeting> tbl = List_dept as IEnumerable<tbl_DepartmentBudgeting>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string UpdateDepartmentBudget(int compid, int Dept, int Jobid)
    {
        List<tbl_DepartmentBudgeting> List_dept = new List<tbl_DepartmentBudgeting>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", Jobid);
            param[2] = new SqlParameter("@deptid", Dept);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Update_DepartmentBudget", param))
            {
                while (drrr.Read())
                {
                    List_dept.Add(new tbl_DepartmentBudgeting()
                    {
                        depid = objComm.GetValue<int>(drrr["deptid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_DepartmentBudgeting> tbl = List_dept as IEnumerable<tbl_DepartmentBudgeting>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    public class UserDetails
    {
        public string StaffCode { get; set; }

        public string Budgethours { get; set; }
        public string temp_Id { get; set; }
        public string fromdate { get; set; }
        public string todate { get; set; }
        public int Dept { get; set; }

        public string StaffActualHourRate { get; set; }

        public string AllocatedHours { get; set; }
        public int jobid { get; set; }
        public int compid { get; set; }
    }

}