<%@ WebService Language="C#" Class="Departmentwise_Approver_Allocation" %>

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
public class Departmentwise_Approver_Allocation  : System.Web.Services.WebService {
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    [WebMethod]
    public string Get_RolewiseAprrover_Rolenames(int compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<RolewiseApp_Allocation> objtbl = new List<RolewiseApp_Allocation>();
        string departmentnames = "";
        try {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_RolewiseAprrover_Rolenames", param))
            {
                while (drrr.Read())
                {
                    objtbl.Add(new RolewiseApp_Allocation
                    {
                         RoleId = objComm.GetValue<int>(drrr["RoleID"].ToString()),
                        RoleName = objComm.GetValue<string>(drrr["Rolename"].ToString()),
                    });

                }
            }

            IEnumerable<RolewiseApp_Allocation> tbl = objtbl as IEnumerable<RolewiseApp_Allocation>;
            departmentnames = new JavaScriptSerializer().Serialize(tbl);
            
            return departmentnames;
        }
        catch (Exception ex) {
            return ex.ToString();
        }

        
    }




    [WebMethod]

    public string Get_RolewiseApprover_Roles_Details(int compid, int RoleId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<RolewiseApp_Allocation> objtbl = new List<RolewiseApp_Allocation>();
        string result = "";
        try { 
        return result;
        }
        
        catch(Exception ex){
        return result + ex;
        }
    
    }




    //[WebMethod]
    //public string Get_DepartmentwiseApprover_Staff_Details(int compid, int staffvalue, int Deptid)
    //{
    //    CommonFunctions objComm = new CommonFunctions();
    //    List<DepartmentWiseApp_Allocation> objtbl = new List<DepartmentWiseApp_Allocation>();
    //    string Result = "";
    //    try
    //    {
    //        List<Departmentwise_Approver_staff> objstaff = new List<Departmentwise_Approver_staff>();
    //        List<Departmentwise_Approver_HOD> objhod = new List<Departmentwise_Approver_HOD>();
    //        List<Departmentwise_Approver_TopApprover> objtop = new List<Departmentwise_Approver_TopApprover>();
           
    //        SqlParameter[] param = new SqlParameter[3];
    //        param[0] = new SqlParameter("@compid", compid);
    //        param[1] = new SqlParameter("@staffvalue", staffvalue);
    //        param[2] = new SqlParameter("@Deptid", Deptid);

    //        using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_DepartmentwiseApprover_Staff_Details", param))
    //        {
    //            while (drrr.Read())
    //            {

    //                objtbl.Add(new DepartmentWiseApp_Allocation
    //                {
    //                    Deptid = objComm.GetValue<int>(drrr["DepId"].ToString())

    //                });
                   

    //            }
    //            if (drrr.NextResult())
    //            {
    //                if (drrr.HasRows)
    //                {
    //                    while (drrr.Read())
    //                    {

    //                        objtop.Add(new Departmentwise_Approver_TopApprover
    //                        {
    //                            Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
    //                            StaffNames = objComm.GetValue<string>(drrr["staffname"].ToString()),
                              

    //                        });

    //                    }
    //                }
    //            }
    //            if (drrr.NextResult()) 
    //            {
    //                if (drrr.HasRows) 
    //                {
    //                    while (drrr.Read()) 
    //                    {

    //                        objstaff.Add(new Departmentwise_Approver_staff
    //                        {
    //                            Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
    //                            StaffNames = objComm.GetValue<string>(drrr["staffname"].ToString()),
    //                            Ischecked = objComm.GetValue<int>(drrr["ischeck"].ToString()),
    //                            TopApproverId = objComm.GetValue<int>(drrr["TopApproverId"].ToString()),

    //                        });
                           
    //                    }
    //                }
    //            }

    //            if (drrr.NextResult())
    //            {
    //                if (drrr.HasRows)
    //                {
    //                    while (drrr.Read())
    //                    {
    //                        objhod.Add(new Departmentwise_Approver_HOD
    //                        {
    //                            Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
    //                            StaffNames = objComm.GetValue<string>(drrr["staffname"].ToString()),
    //                            Ischecked = objComm.GetValue<int>(drrr["ischeck"].ToString()),
    //                            DepartmentName = objComm.GetValue<string>(drrr["departmentname"].ToString()),

    //                        });
    //                    }
    //                }
    //            }

    //            foreach (var item in objtbl) {
    //                item.objtop = objtop;
    //                item.objstaff = objstaff;
    //                item.objhod = objhod;
                    
    //            }
    //        }
    //        IEnumerable<DepartmentWiseApp_Allocation> tbl = objtbl as IEnumerable<DepartmentWiseApp_Allocation>;
    //        Result = new JavaScriptSerializer().Serialize(tbl);

    //        return Result;
            

    //    }
    //    catch (Exception ex)
    //    {
    //        return ex.ToString();
    //    }


    //}


    //[WebMethod]
    //public string Save_Departmentwise_Approver(int compid, int staffvalue, int Deptid, string Allstaff, string AllHOD, int TopAppId)
    //{
    //    CommonFunctions objComm = new CommonFunctions();
    //    List<DepartmentWiseApp_Allocation> objtbl = new List<DepartmentWiseApp_Allocation>();
    //    string Result = "";
    //    try
    //    {
    //        SqlParameter[] param = new SqlParameter[6];
    //        param[0] = new SqlParameter("@compid", compid);
    //        param[1] = new SqlParameter("@staffvalue", staffvalue);
    //        param[2] = new SqlParameter("@Deptid", Deptid);
    //        param[3] = new SqlParameter("@Allstaff", Allstaff.TrimEnd(','));
    //        param[4] = new SqlParameter("@AllHOD", AllHOD.TrimEnd(','));
    //        param[5] = new SqlParameter("@TopAppId", TopAppId);
    //        ///////DataSet ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_Save_Departmentwise_Approver", param);
    //        using (SqlDataReader drrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Departmentwise_Approver", param))
    //        {
    //            while (drrr.Read())
    //            {
    //                objtbl.Add(new DepartmentWiseApp_Allocation
    //                {
    //                    Deptid = objComm.GetValue<int>(drrr["DeptId"].ToString())
    //                });

    //            }
    //        }

    //        IEnumerable<DepartmentWiseApp_Allocation> tbl = objtbl as IEnumerable<DepartmentWiseApp_Allocation>;
    //        Result = new JavaScriptSerializer().Serialize(tbl);

    //        return Result;
    //    }
    //    catch (Exception ex)
    //    {
    //        return ex.ToString();
    //    }


    //}
    
}