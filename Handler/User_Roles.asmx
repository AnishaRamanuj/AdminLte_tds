<%@ WebService Language="C#" Class="User_Roles" %>

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
public class User_Roles  : System.Web.Services.WebService {
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    [WebMethod]
    public string Get_User_Roles_Details(int compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_User_roles> objtbl = new List<tbl_User_roles>();
        string Results = "";
        try {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_User_Roles_Details", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_User_roles
                    {
                        Id = objComm.GetValue<int>(drrr["id"].ToString()),
                        Name = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString()),
                    });

                }
            }


            IEnumerable<tbl_User_roles> tbl = objtbl as IEnumerable<tbl_User_roles>;
            Results = new JavaScriptSerializer().Serialize(tbl);

            return Results;
        }
        catch {
            return null;
        }
    }


    [WebMethod]
    public string Get_User_Roles_Projects(int compid, int Staffcode, int RoleId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_User_roles> objtbl = new List<tbl_User_roles>();
        string Results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Staffcode", Staffcode);
            param[2] = new SqlParameter("@RoleId", RoleId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_User_Roles_Projects", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_User_roles
                    {
                        Id = objComm.GetValue<int>(drrr["JobId"].ToString()),
                        Name = objComm.GetValue<string>(drrr["jobname"].ToString()),
                        Type = objComm.GetValue<string>(drrr["ischecked"].ToString()),
                    });

                }
            }


            IEnumerable<tbl_User_roles> tbl = objtbl as IEnumerable<tbl_User_roles>;
            Results = new JavaScriptSerializer().Serialize(tbl);

            return Results;
        }
        catch
        {
            return null;
        }
    }





    [WebMethod]
    public string Save_User_Roles_Projects(int compid, int Staffcode, int RoleId, int DeptId, string SelectedProject)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_User_roles> objtbl = new List<tbl_User_roles>();
        string Results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Staffcode", Staffcode);
            param[2] = new SqlParameter("@RoleId", RoleId);
            param[3] = new SqlParameter("@DeptId", DeptId);
            param[4] = new SqlParameter("@SelectedProject", SelectedProject.TrimEnd(','));
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_User_Roles_Projects", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new tbl_User_roles
                    {
                        Id = objComm.GetValue<int>(drrr["id"].ToString()),

                    });

                }
            }


            IEnumerable<tbl_User_roles> tbl = objtbl as IEnumerable<tbl_User_roles>;
            Results = new JavaScriptSerializer().Serialize(tbl);

            return Results;
        }
        catch
        {
            return null;
        }
    }
    
}