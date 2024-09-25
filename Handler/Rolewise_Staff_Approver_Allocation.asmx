<%@ WebService Language="C#" Class="Rolewise_Staff_Approver_Allocation" %>

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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Rolewise_Staff_Approver_Allocation  : System.Web.Services.WebService {

    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    [WebMethod]
    public string Get_Roles_Projectwise_Rolesnames(int compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Project_Approver_Allocation> objtbl = new List<tbl_Rolewise_Project_Approver_Allocation>();
        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Roles_Projectwise_Rolesnames", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_Rolewise_Project_Approver_Allocation
                    {
                        Role_Id = objComm.GetValue<int>(drrr["RoleID"].ToString()),
                        Rolenames = objComm.GetValue<string>(drrr["Rolename"].ToString()),
                    });

                }
            }

            IEnumerable<tbl_Rolewise_Project_Approver_Allocation> tbl = objtbl as IEnumerable<tbl_Rolewise_Project_Approver_Allocation>;
            departmentnames = new JavaScriptSerializer().Serialize(tbl);

            return departmentnames;
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }


    }



    [WebMethod]
    public string Get_Rolewise_Staff(int compid, int Role_Id, int Type)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Project_Approver_Allocation> objtbl = new List<tbl_Rolewise_Project_Approver_Allocation>();


        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Role_Id", Role_Id);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Rolewise_Staff", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_Rolewise_Project_Approver_Allocation
                    {
                        Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffNames = objComm.GetValue<string>(drrr["staffname"].ToString()),
                    });

                }




            }

            IEnumerable<tbl_Rolewise_Project_Approver_Allocation> tbl = objtbl as IEnumerable<tbl_Rolewise_Project_Approver_Allocation>;
            departmentnames = new JavaScriptSerializer().Serialize(tbl);

            return departmentnames;
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }


    }



    [WebMethod]
    public string Get_Rolewise_client_project_departrment(int compid, int Role_Id, string Type, int Headid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Project_Approver_Allocation> objtbl = new List<tbl_Rolewise_Project_Approver_Allocation>();


        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Role_Id", Role_Id);
            param[2] = new SqlParameter("@Type", Type);
            param[3] = new SqlParameter("@Headid", Headid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Rolewise_client_project_staff", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_Rolewise_Project_Approver_Allocation
                    {
                        Id = objComm.GetValue<int>(drrr["Id"].ToString()),
                        Name = objComm.GetValue<string>(drrr["Name"].ToString()),
                        ischeck = objComm.GetValue<int>(drrr["ischeck"].ToString()),
                        Type = objComm.GetValue<string>(drrr["Type"].ToString()),
                        AppPattern = objComm.GetValue<string>(drrr["AppPattern"].ToString()),
                    });

                }

            }

            IEnumerable<tbl_Rolewise_Project_Approver_Allocation> tbl = objtbl as IEnumerable<tbl_Rolewise_Project_Approver_Allocation>;
            departmentnames = new JavaScriptSerializer().Serialize(tbl);

            return departmentnames;
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }


    }


    [WebMethod]
    public string Get_Rolewise_project_staff(int compid, int ProjectId, int Role_Id, int Headid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Project_Approver_Allocation> objtbl = new List<tbl_Rolewise_Project_Approver_Allocation>();


        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@ProjectId", ProjectId);
            param[2] = new SqlParameter("@Role_Id", Role_Id);
            param[3] = new SqlParameter("@Headid", Headid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Rolewise_project_staffs", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_Rolewise_Project_Approver_Allocation
                    {
                        Id = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        Name = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        ischeck = objComm.GetValue<int>(drrr["ischeck"].ToString()),
                        AppPattern = objComm.GetValue<string>(drrr["AppPattern"].ToString()),

                    });

                }

            }

            IEnumerable<tbl_Rolewise_Project_Approver_Allocation> tbl = objtbl as IEnumerable<tbl_Rolewise_Project_Approver_Allocation>;
            departmentnames = new JavaScriptSerializer().Serialize(tbl);

            return departmentnames;
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }


    }



    [WebMethod]
    ///////AllCPD=all Client Project Department RHeadId stand of report head id    
    public string Save_Rolewise_Report_Head(int compid, string Type, int Role_Id, string AllCPD, int RHeadId, int ProjectId, string AppPatern)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Project_Approver_Allocation> objtbl = new List<tbl_Rolewise_Project_Approver_Allocation>();


        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Role_Id", Role_Id);
            param[2] = new SqlParameter("@Type", Type);
            param[3] = new SqlParameter("@RHeadId", RHeadId);
            param[4] = new SqlParameter("@AllCPD", AllCPD.TrimEnd(','));
            param[5] = new SqlParameter("@ProjectId", ProjectId);
            param[6] = new SqlParameter("@AppPatern", AppPatern);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Rolewise_staff_Approver", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_Rolewise_Project_Approver_Allocation
                    {
                        Id = objComm.GetValue<int>(drrr["rid"].ToString()),

                    });

                }

            }

            IEnumerable<tbl_Rolewise_Project_Approver_Allocation> tbl = objtbl as IEnumerable<tbl_Rolewise_Project_Approver_Allocation>;
            departmentnames = new JavaScriptSerializer().Serialize(tbl);

            return departmentnames;
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }


    }


    [WebMethod]
    public string Get_Staff(int compid )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_User_roles> objtbl = new List<tbl_User_roles>();

        string staffnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_GetApproverName", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_User_roles
                    {
                        Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffNames = objComm.GetValue<string>(drrr["staffname"].ToString()),
                    });

                }
            }

            IEnumerable<tbl_User_roles> tbl = objtbl as IEnumerable<tbl_User_roles>;
            staffnames = new JavaScriptSerializer().Serialize(tbl);

            return staffnames;
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }
    }


    [WebMethod]
    public string Get_Approver_Projects(int compid, int staffid)  {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_job_ts> objtbl = new List<tbl_job_ts>();

        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffid", staffid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Approver_Jobid", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_job_ts
                    {
                        JobId = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["JPCName"].ToString()),
                        isCheck = objComm.GetValue<int>(drrr["ischeck"].ToString()),

                    });

                }

            }

            IEnumerable<tbl_job_ts> tbl = objtbl as IEnumerable<tbl_job_ts>;
            departmentnames = new JavaScriptSerializer().Serialize(tbl);

            return departmentnames;
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }
    }

    [WebMethod]
    ///////AllCPD=all Client Project Department RHeadId stand of report head id    
    public string Save_Assign_Approver(int compid, int staffid, string sft)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_job_ts> objtbl = new List<tbl_job_ts>();


        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffid", staffid);
            param[2] = new SqlParameter("@sft", sft);
            

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_TopApprover_departmentwise", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_job_ts
                    {
                        Id = objComm.GetValue<int>(drrr["Id"].ToString()),

                    });

                }

            }

            IEnumerable<tbl_job_ts> tbl = objtbl as IEnumerable<tbl_job_ts>;
            departmentnames = new JavaScriptSerializer().Serialize(tbl);

            return departmentnames;
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }


    }     
}