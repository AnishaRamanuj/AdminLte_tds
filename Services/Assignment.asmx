<%@ WebService Language="C#" Class="Assignment" %>

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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Assignment : System.Web.Services.WebService
{

    [WebMethod]
    public string GetAssignmentRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Assignments> obj_Job = new List<Assignments>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@companyId", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Bind_Assignments", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Assignments()
                    {
                        mJobID = objComm.GetValue<int>(drrr["Sino"].ToString()),
                        Assign_Id = objComm.GetValue<int>(drrr["Assign_Id"].ToString()),
                        Assign_Name = objComm.GetValue<string>(drrr["Assign_Name"].ToString()),
                        DeptId = objComm.GetValue<int>(drrr["DepId"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
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
            using (SqlDataReader drDept = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Assign_Dept", param))
            {
                while (drDept.Read())
                {
                    obj_Job.Add(new Assignments()
                    {
                        DeptId = objComm.GetValue<int>(drDept["DepId"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drDept["DepartmentName"].ToString()),
                        //  ischecked = objComm.GetValue<int>(drDept["ischecked"].ToString()),
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
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Assign_Job", param))
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
    public string InsertUpdate_Assignment(string compid, string a, string d, string aid, string jid) //int compid, int a, int d, string jid
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
            using (SqlDataReader drDept = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InsertUpdate_Assign", param))
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
    public string DeleteAssign(int compid, int aid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Assignments> obj_Job = new List<Assignments>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@companyId", compid);
            param[1] = new SqlParameter("@aid", aid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Delete_Assignments", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Assignments()
                    {
                        Assign_Id = objComm.GetValue<int>(drrr["Assign_Id"].ToString()),
                        messg = objComm.GetValue<string>(drrr["msg"].ToString()),

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