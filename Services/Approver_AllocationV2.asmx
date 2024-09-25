<%@ WebService Language="C#" Class="Approver_AllocationV2" %>

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
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Approver_AllocationV2 : System.Web.Services.WebService
{

    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    [WebMethod(EnableSession=true)]
    public string Get_Roles_Projectwise_RolesnamesV2(int compid=0)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Project_Approver_Allocation> objtbl = new List<tbl_Rolewise_Project_Approver_Allocation>();
        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Roles_Projectwise_RolesnameV2", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_Rolewise_Project_Approver_Allocation
                    {
                        Role_Id = objComm.GetValue<int>(drrr["RoleID"].ToString()),
                        Rolenames = objComm.GetValue<string>(drrr["Rolename"].ToString()),
                        StaffAccessValue=objComm.GetValue<string>(drrr["StaffAccessValue"].ToString()),
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

    [WebMethod(EnableSession=true)]
    public string GetCompanyStaffLookUp(int compid=0)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Staff> objtbl = new List<tbl_Staff>();
        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_GetCompanyStaffLookUp", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_Staff
                    {
                        StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                    });

                }
            }

            IEnumerable<tbl_Staff> tbl = objtbl as IEnumerable<tbl_Staff>;
            departmentnames = new JavaScriptSerializer().Serialize(tbl);

            return departmentnames;
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }


    }

    [WebMethod(EnableSession=true)]
    public string GetEmployeeForApprovalByProject(string staffcode, string clientId, string projectId, string Srch, string pageIndex, string pageSize,int ApproverId)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffInfo> obj_Job = new List<tbl_StaffInfo>();
        DataSet ds;
        try
        {
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@clientId", clientId);
            param[3] = new SqlParameter("@projectId", projectId);
            param[4] = new SqlParameter("@srch", Srch);
            param[5] = new SqlParameter("@pageIndex", pageIndex);
            param[6] = new SqlParameter("@pageSize", pageSize);
            param[7] = new SqlParameter("@ApproverId", ApproverId);



            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_GetEmployeeForApproval", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        //IEnumerable<tbl_StaffInfo> tbl = obj_Job as IEnumerable<tbl_StaffInfo>;
        //var obbbbb = tbl;
        //return new JavaScriptSerializer().Serialize(tbl);
        return ds.GetXml();

    }

    [WebMethod(EnableSession=true)]
    public string GetCompanyEmployeeForApproval(string staffcode, string clientId, string projectId, string Srch, string pageIndex, string pageSize,string ViewMode,int ApproverId)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffInfo> obj_Job = new List<tbl_StaffInfo>();
        DataSet ds;
        try
        {


            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@srch", Srch);
            param[3] = new SqlParameter("@pageIndex", pageIndex);
            param[4] = new SqlParameter("@pageSize", pageSize);
            param[5] = new SqlParameter("@ApproverId", ApproverId);
            if (ViewMode == "PRJWISE" && ApproverId > 0)
            {
                ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_GetCompanyEmployeeForApprovalWithProjectWise", param);
            }
            else
            {
                ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_GetCompanyEmployeeForApprovalWithEmployeeWise", param);
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }

        //IEnumerable<tbl_StaffInfo> tbl = obj_Job as IEnumerable<tbl_StaffInfo>;
        //var obbbbb = tbl;
        //return new JavaScriptSerializer().Serialize(tbl);
        return ds.GetXml();

    }

    [WebMethod(EnableSession=true)]
    public string GetProjectByStaffCode(string staffcode,  string Srch, string pageIndex, string pageSize,int ApproverId)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DataSet ds;
        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@srch", Srch);
            param[3] = new SqlParameter("@pageIndex", pageIndex);
            param[4] = new SqlParameter("@pageSize", pageSize);
            param[5] = new SqlParameter("@ApproverId", ApproverId);


            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_GetProjectByStaffCode", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();

    }



    [WebMethod(EnableSession=true)]
    public string Bind_DrpClient(int staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<RoleApproverClient> obj_Job = new List<RoleApproverClient>();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", staffcode);
            using (SqlDataReader dr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_getRoleApprover_ClientByStaffCode", param))
            {
                while (dr.Read())
                {
                    obj_Job.Add(new RoleApproverClient()
                    {
                        ClientID = objComm.GetValue<int>(dr["ClientId"].ToString()),
                        ClientName = objComm.GetValue<string>(dr["ClientName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<RoleApproverClient> tbl = obj_Job as IEnumerable<RoleApproverClient>;
        var obbbbb = tbl;
        return JsonConvert.SerializeObject(tbl);
    }



    [WebMethod(EnableSession=true)]
    public string Get_Rolewise_StaffV2(int Role_Id, int Type)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Project_Approver_Allocation> objtbl = new List<tbl_Rolewise_Project_Approver_Allocation>();


        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Role_Id", Role_Id);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Bootstrap_Get_Rolewise_Staffv2", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_Rolewise_Project_Approver_Allocation
                    {
                        Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffNames = objComm.GetValue<string>(drrr["staffname"].ToString()),
                        Desig = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
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
    public string Bind_DrpProject(int clientId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<RoleApproverProject> obj_Job = new List<RoleApproverProject>();
        try
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@clientId", clientId) };
            using (SqlDataReader dr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_RoleApprover_GetProjectData", param))
            {
                while (dr.Read())
                {
                    obj_Job.Add(new RoleApproverProject()
                    {
                        ProjectID = objComm.GetValue<int>(dr["ProjectID"].ToString()),
                        ProjectName = objComm.GetValue<string>(dr["ProjectName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<RoleApproverProject> tbl = obj_Job as IEnumerable<RoleApproverProject>;
        var obbbbb = tbl;
        return JsonConvert.SerializeObject(tbl);
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



    [WebMethod(EnableSession=true)]
    ///////AllCPD=all Client Project Department RHeadId stand of report head id    
    public string Save_ProjectWiseProjectStaff(string Type, int Role_Id, string AllCPD, int RHeadId, int ProjectId,string RoleMapIDs,string unSelected, string AppPatern)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Project_Approver_Allocation> objtbl = new List<tbl_Rolewise_Project_Approver_Allocation>();


        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Role_Id", Role_Id);
            param[2] = new SqlParameter("@Type", Type);
            param[3] = new SqlParameter("@RHeadId", RHeadId);
            param[4] = new SqlParameter("@AllCPD", AllCPD.TrimEnd(','));
            param[5] = new SqlParameter("@ProjectId", ProjectId);
            param[6] = new SqlParameter("@AppPatern", AppPatern);
            param[7] = new SqlParameter("@RoleMapIDs", RoleMapIDs);
            param[8] = new SqlParameter("@unSelected", unSelected);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Bootstrap_Save_ProjectWiseProjectStaffV2", param))
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

    [WebMethod(EnableSession=true)]
    ///////AllCPD=all Client Project Department RHeadId stand of report head id    
    public string Save_ApproverWiseProjectStaff(string Type, int Role_Id, string AllCPD, int RHeadId, string RoleMapIDs,string unSelected,string AppPatern)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Project_Approver_Allocation> objtbl = new List<tbl_Rolewise_Project_Approver_Allocation>();


        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Role_Id", Role_Id);
            param[2] = new SqlParameter("@Type", Type);
            param[3] = new SqlParameter("@RHeadId", RHeadId);
            param[4] = new SqlParameter("@AllCPD", AllCPD.TrimEnd(','));
            param[5] = new SqlParameter("@AppPatern", AppPatern);
            param[6] = new SqlParameter("@RoleMapIDs", RoleMapIDs);
            param[7] = new SqlParameter("@unSelected", unSelected);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Bootstrap_Save_ApproverWiseProjectStaffV2", param))
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

    [WebMethod(EnableSession=true)]
    ///////AllCPD=all Client Project Department RHeadId stand of report head id    
    public string Save_MainApproverWiseProjectStaff(string Type, string AllCPD, int RHeadId, string RoleMapIDs,string unSelected,string AppPatern)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Project_Approver_Allocation> objtbl = new List<tbl_Rolewise_Project_Approver_Allocation>();


        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Type", Type);
            param[2] = new SqlParameter("@RHeadId", RHeadId);
            param[3] = new SqlParameter("@AllCPD", AllCPD.TrimEnd(','));
            param[4] = new SqlParameter("@AppPatern", AppPatern);
            param[5] = new SqlParameter("@RoleMapIDs", RoleMapIDs);
            param[6] = new SqlParameter("@unSelected", unSelected);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Bootstarp_Save_MainApproverWiseProjectStaff", param))
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

    [WebMethod(EnableSession=true)]
    public string Save_ApproverWiseForAllProjectStaff(string Type, int Role_Id, string AllCPD, int RHeadId, string RoleMapIDs,string unSelected,string AppPatern)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Project_Approver_Allocation> objtbl = new List<tbl_Rolewise_Project_Approver_Allocation>();


        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Role_Id", Role_Id);
            param[2] = new SqlParameter("@Type", Type);
            param[3] = new SqlParameter("@RHeadId", RHeadId);
            param[4] = new SqlParameter("@AllCPD", AllCPD.TrimEnd(','));
            param[5] = new SqlParameter("@AppPatern", AppPatern);
            param[6] = new SqlParameter("@RoleMapIDs", RoleMapIDs);
            param[7] = new SqlParameter("@unSelected", unSelected);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Bootstrap_Save_ApproverWiseAllProject", param))
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

    [WebMethod(EnableSession=true)]
    ///////AllCPD=all Client Project Department RHeadId stand of report head id    
    public string Save_Staffwise_Project_Approver(string Type, int Role_Id, string AllCPD, int RHeadId, int empStaffCode,string RoleMapIDs,string unSelected, string AppPatern)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Project_Approver_Allocation> objtbl = new List<tbl_Rolewise_Project_Approver_Allocation>();


        string departmentnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Role_Id", Role_Id);
            param[2] = new SqlParameter("@Type", Type);
            param[3] = new SqlParameter("@RHeadId", RHeadId);
            param[4] = new SqlParameter("@AllCPD", AllCPD.TrimEnd(','));
            param[5] = new SqlParameter("@empStaffCode", @empStaffCode);
            param[6] = new SqlParameter("@AppPatern", AppPatern);
            param[7] = new SqlParameter("@RoleMapIDs", RoleMapIDs);
            param[8] = new SqlParameter("@unSelected", unSelected);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Bootstrap_Save_Staffwise_Project_ApproverV2", param))
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
    public string Get_Staff(int compid)
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


    [WebMethod(EnableSession=true)]
    public string Get_MainApprover()
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_User_roles> objtbl = new List<tbl_User_roles>();

        string staffnames = "";
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Bootstarp_Get_Main_Approver", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_User_roles
                    {
                        Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffNames = objComm.GetValue<string>(drrr["StaffName"].ToString()),
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
    public string Get_Approver_Projects(int compid, int staffid)
    {
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

    [WebMethod(EnableSession=true)]
    public string GetStaffCodeApproverDetails(string staffcode,  string Srch, string pageIndex, string pageSize)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DataSet ds;
        try
        {
                SqlParameter[] param = new SqlParameter[6];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@staffcode", staffcode);
                param[2] = new SqlParameter("@srch", Srch);
                param[3] = new SqlParameter("@pageIndex", pageIndex);
                param[4] = new SqlParameter("@pageSize", pageSize);


                ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_GetProjectByStaffCodeDetails", param);
            
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();

    }

    [WebMethod(EnableSession=true)]
    public string GetEmployeesForMainApprover(string Srch, string pageIndex, string pageSize, int ApproverId)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DataSet ds;
        try
        {
                SqlParameter[] param = new SqlParameter[6];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[2] = new SqlParameter("@srch", Srch);
                param[3] = new SqlParameter("@pageIndex", pageIndex);
                param[4] = new SqlParameter("@pageSize", pageSize);
                param[4] = new SqlParameter("@ApproverId", ApproverId);


                ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_GetEmployeesForMainApprover", param);
            
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();

    }


}