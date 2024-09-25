<%@ WebService Language="C#" Class="ws_StaffJobMapping" %>
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
public class ws_StaffJobMapping : System.Web.Services.WebService
{

    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");

      [WebMethod]
    public string BindGrd(int compid, int p, string srch, string rbtn)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<CountStaffwise> obj_Job = new List<CountStaffwise>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@companyId", compid);
            param[1] = new SqlParameter("@PageIndex", p);
            param[2] = new SqlParameter("@PageSize", 25);
            param[3] = new SqlParameter("@Srch", srch);
            param[4] = new SqlParameter("@rbtn", rbtn);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_StaffDepartments", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new CountStaffwise()
                    {
                        Staffwith =objComm.GetValue<int>(drrr["Staffwith"].ToString()),
                        Staffwithout =objComm.GetValue<int>(drrr["Staffwithout"].ToString()),
                    });
                }

                List<StaffJobMapping> list_StaffJob_Mapping = new List<StaffJobMapping>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            list_StaffJob_Mapping.Add(new StaffJobMapping()
                            {
                                Sino = objComm.GetValue<int>(drrr["Sino"].ToString()),
                                StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                Department = objComm.GetValue<string>(drrr["departmentname"].ToString()),
                                TCount = objComm.GetValue<int>(drrr["TotalCount"].ToString()),
                                Staffcode = objComm.GetValue<int>(drrr["Staffcode"].ToString()),
                                Designation = objComm.GetValue<string>(drrr["designation"].ToString()),
                                TotPrj = objComm.GetValue<int>(drrr["jid"].ToString()),
                            });
                        }
                    }
                }

                foreach (var item in obj_Job)
                {

                    item.list_StaffJobMapping = list_StaffJob_Mapping;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<CountStaffwise> tbl = obj_Job as IEnumerable<CountStaffwise>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string BindJob(string compid, string aid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<JobStaffMappings> obj_Job = new List<JobStaffMappings>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@StaffCode", aid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_StaffJobMapping", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new JobStaffMappings()
                    {
                        JobID = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                        Assign_Name = objComm.GetValue<string>(drrr["AssignmentName"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<JobStaffMappings> tbl = obj_Job as IEnumerable<JobStaffMappings>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string Show_Delete_Assignment(string compid, string aid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<JobStaffMappings> obj_Job = new List<JobStaffMappings>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@StaffCode", aid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_StaffJobMapping_Delete", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new JobStaffMappings()
                    {
                        JobID = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                        Assign_Name = objComm.GetValue<string>(drrr["AssignmentName"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<JobStaffMappings> tbl = obj_Job as IEnumerable<JobStaffMappings>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    [WebMethod]
    public string Update_Assignment(string compid, string aid, string jid) //int compid, int a, int d, string jid
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<JobStaffMappings> obj_Job = new List<JobStaffMappings>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jid", jid);
            param[2] = new SqlParameter("@aid", aid);
            using (SqlDataReader drDept = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Update_StaffJobMapping", param))
            {
                while (drDept.Read())
                {
                    obj_Job.Add(new JobStaffMappings()
                    {
                        StaffCode = objComm.GetValue<int>(drDept["StaffCode"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<JobStaffMappings> tbl = obj_Job as IEnumerable<JobStaffMappings>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string Delete_Assignment(int compid, int aid, string ip, string usr, string ut, string dt) //int compid, int a, int d, string jid
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DBAccess db = new DBAccess();
        DBAccess.PrintDelete(ip ,"Staff Job Allocation", usr, ut, dt);
        List<Assignments> obj_Job = new List<Assignments>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@CompanyId", compid);
            param[1] = new SqlParameter("@aid", aid);

            using (SqlDataReader drDept = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Delete_Staff_Jobs", param))
            {
                while (drDept.Read())
                {
                    obj_Job.Add(new Assignments()
                    {
                        Assign_Id = objComm.GetValue<int>(drDept["Assign_Id"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;

        }
        IEnumerable<Assignments> tbl = obj_Job as IEnumerable<Assignments>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}