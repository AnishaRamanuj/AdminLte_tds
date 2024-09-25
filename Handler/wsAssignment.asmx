<%@ WebService Language="C#" Class="wsAssignment" %>

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
public class wsAssignment  : System.Web.Services.WebService {

    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]
    public string BindGrd(int compid, int p, string srch)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        AllAssignments obj = new AllAssignments();
        Assignments tbl = new Assignments();
        try
        {
            tbl.CompID = Convert.ToInt32(compid);
            tbl.pageIndex = Convert.ToInt32(p);
            tbl.pageNewSize = 25;
            tbl.Srch = srch ;
            DataSet ds;
            ds = obj.GetAssignments(tbl);
            return ds.GetXml(); 
        }
        catch (Exception ex)
        {
            throw ex;
        }

    }    
    
    [WebMethod]
    public string BindJob(string compid, string aid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Assignments> obj_Job = new List<Assignments>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@aid", aid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Assign_Job", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Assignments()
                    {
                        mJobID = objComm.GetValue<int>(drrr["mJobid"].ToString()),
                        MJobName = objComm.GetValue<string>(drrr["mjobName"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),                        
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

    [WebMethod]
    public string BindDept(string compid, string aid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Assignments> obj_Job = new List<Assignments>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@aid", aid);
            using (SqlDataReader drDept = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Assign_Dept", param))
            {
                while (drDept.Read())
                {
                    obj_Job.Add(new Assignments()
                    {
                        DeptId = objComm.GetValue<int>(drDept["DepId"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drDept["DepartmentName"].ToString()),
                        ischecked = objComm.GetValue<int>(drDept["ischecked"].ToString()),
                        //Did = objComm.GetValue<int>(drDept["Did"].ToString()),
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

    [WebMethod]
    public string Insert_Assignment(string compid, string a, string d, string jid) //int compid, int a, int d, string jid
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Assignments> obj_Job = new List<Assignments>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jid", jid);
            param[2] = new SqlParameter("@dep", d);
            param[3] = new SqlParameter("@Assign_Name", a);
            using (SqlDataReader drDept = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Insert_Assign", param))
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



    [WebMethod]
    public string Update_Assignment(string compid, string a, string d, string aid, string jid) //int compid, int a, int d, string jid
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Assignments> obj_Job = new List<Assignments>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jid", jid);
            param[2] = new SqlParameter("@dep", d);
            param[3] = new SqlParameter("@Assign_Name", a);
            param[4] = new SqlParameter("@aid", aid);
            using (SqlDataReader drDept = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Update_Assign", param))
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


    [WebMethod]
    public string Delete_Assignment(int compid, int aid, string ip, string usr, string ut, string dt) //int compid, int a, int d, string jid
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DBAccess db = new DBAccess();
        DBAccess.PrintDelete(ip ,"Assignments Master", usr, ut, dt);
        List<Assignments> obj_Job = new List<Assignments>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@CompanyId", compid);
            param[1] = new SqlParameter("@aid", aid);

            using (SqlDataReader drDept = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Delete_Assignments", param))
            {
                while (drDept.Read())
                {
                    obj_Job.Add(new Assignments()
                    {
                        Assign_Id = objComm.GetValue<int>(drDept["Assign_Id"].ToString()),
                        messg = objComm.GetValue<string>(drDept["msg"].ToString()),
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