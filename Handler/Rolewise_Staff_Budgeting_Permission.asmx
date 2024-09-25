<%@ WebService Language="C#" Class="Rolewise_Staff_Budgeting_Permission" %>

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
public class Rolewise_Staff_Budgeting_Permission : System.Web.Services.WebService
{

    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

    [WebMethod]
    public string Get_Rolewise_Staff_Budgeting_Permission_RoleNames(int Compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Budgeting_Staff_Permission> objtbl = new List<tbl_Rolewise_Budgeting_Staff_Permission>();
        string Results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Compid);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Rolewise_Staff_Budgeting_Permission_RoleNames", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Rolewise_Budgeting_Staff_Permission
                    {
                        RoleID = objComm.GetValue<int>(sdr["RoleID"].ToString()),
                        Rolename = objComm.GetValue<string>(sdr["Rolename"].ToString()),
                    });
                }
            }

            IEnumerable<tbl_Rolewise_Budgeting_Staff_Permission> tbl = objtbl as IEnumerable<tbl_Rolewise_Budgeting_Staff_Permission>;
            Results = new JavaScriptSerializer().Serialize(tbl);
            return Results;
        }
        catch (Exception ex)
        {
            return null;
        }
    }


    [WebMethod]
    public string Get_Rolewise_Staff_Budgeting_Permission_StaffNames(int Compid, int RoleID)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Budgeting_Staff_Permission> objtbl = new List<tbl_Rolewise_Budgeting_Staff_Permission>();
        string Results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@RoleID", RoleID);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Rolewise_Staff_Budgeting_Permission_StaffNames", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Rolewise_Budgeting_Staff_Permission
                    {
                        StaffCode = objComm.GetValue<int>(sdr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(sdr["StaffName"].ToString()),
                    });
                }
            }

            IEnumerable<tbl_Rolewise_Budgeting_Staff_Permission> tbl = objtbl as IEnumerable<tbl_Rolewise_Budgeting_Staff_Permission>;
            Results = new JavaScriptSerializer().Serialize(tbl);
            return Results;
        }
        catch (Exception ex)
        {
            return null;
        }
    }



    [WebMethod]
    public string Save_Rolewise_Staff_Budgeting_Permissions(int Compid, int RoleID, int StaffCode, string permission, int RoleStaffBudId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Budgeting_Staff_Permission> objtbl = new List<tbl_Rolewise_Budgeting_Staff_Permission>();
        string Results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@RoleID", RoleID);
            param[2] = new SqlParameter("@StaffCode", StaffCode);
            param[3] = new SqlParameter("@permission", permission.TrimEnd(','));
            param[4] = new SqlParameter("@RoleStaffBudId", RoleStaffBudId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Rolewise_Staff_Budgeting_Permissions", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Rolewise_Budgeting_Staff_Permission
                    {
                        RoleStaffBudId = objComm.GetValue<int>(sdr["RoleStaffBudId"].ToString()),
                    });
                }
            }

            IEnumerable<tbl_Rolewise_Budgeting_Staff_Permission> tbl = objtbl as IEnumerable<tbl_Rolewise_Budgeting_Staff_Permission>;
            Results = new JavaScriptSerializer().Serialize(tbl);
            return Results;
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    [WebMethod]
    public string Get_Rolewise_Staff_Budgeting_Permission_Details(int Compid, int RoleID, string Srch)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Rolewise_Budgeting_Staff_Permission> objtbl = new List<tbl_Rolewise_Budgeting_Staff_Permission>();
        string Results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@RoleID", RoleID);
            param[2] = new SqlParameter("@Srch", Srch);

            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Rolewise_Staff_Budgeting_Permission_Details", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Rolewise_Budgeting_Staff_Permission
                    {
                        sino = objComm.GetValue<int>(sdr["sino"].ToString()),
                        RoleStaffBudId = objComm.GetValue<int>(sdr["RoleStaffBudId"].ToString()),
                        StaffCode = objComm.GetValue<int>(sdr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(sdr["StaffName"].ToString()),
                        RoleID = objComm.GetValue<int>(sdr["RoleID"].ToString()),
                        Rolename = objComm.GetValue<string>(sdr["Rolename"].ToString()),
                        Budgeting_type = objComm.GetValue<string>(sdr["Budgeting_type"].ToString()),
                    });
                }
            }

            IEnumerable<tbl_Rolewise_Budgeting_Staff_Permission> tbl = objtbl as IEnumerable<tbl_Rolewise_Budgeting_Staff_Permission>;
            Results = new JavaScriptSerializer().Serialize(tbl);
            return Results;
        }
        catch (Exception ex)
        {
            return null;
        }
    }



    [WebMethod]
    public string Delete_Rolewise_Staff_Budgeting_Permissions(int Compid, int RoleStaffBudId, string ip, string usr, string ut, string dt)
    {
        CommonFunctions objComm = new CommonFunctions();
        DBAccess db = new DBAccess();
        DBAccess.PrintDelete(ip, "Rolewise Budgeting Permissions", usr, ut, dt);
        List<tbl_Rolewise_Budgeting_Staff_Permission> objtbl = new List<tbl_Rolewise_Budgeting_Staff_Permission>();
        string Results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@RoleStaffBudId", RoleStaffBudId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Delete_Rolewise_Staff_Budgeting_Permissions", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Rolewise_Budgeting_Staff_Permission
                    {
                        RoleStaffBudId = objComm.GetValue<int>(sdr["RoleStaffBudId"].ToString()),
                    });
                }
            }

            IEnumerable<tbl_Rolewise_Budgeting_Staff_Permission> tbl = objtbl as IEnumerable<tbl_Rolewise_Budgeting_Staff_Permission>;
            Results = new JavaScriptSerializer().Serialize(tbl);
            return Results;
        }
        catch (Exception ex)
        {
            return null;
        }
    }



}