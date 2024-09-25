<%@ WebService Language="C#" Class="ws_Dashboard" %>

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
public class ws_Dashboard  : System.Web.Services.WebService {


    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]
    public string bind_Project(string compid, string fr, string to , string srch,string Status)
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Dashboard_Projects> List_SM = new List<Dashboard_Projects>();
        try
        {
            int sh = 0;
            if (srch != "")
            {
                sh = Convert.ToInt32(srch);
            }
            else
            {
                sh = 0;
            }
            string[] dfrdate;
            string[] dtodate;
            dfrdate = fr.Split('/');
            dtodate = to.Split('/');
            string fromDate = dfrdate[1] + "/" + dfrdate[0] + "/" + dfrdate[2];
            string ToDate = dtodate[1] + "/" + dtodate[0] + "/" + dtodate[2];
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@fdate", fromDate);
            param[2] = new SqlParameter("@todate", ToDate);
            param[3] = new SqlParameter("@Srch", sh);
            param[4] = new SqlParameter("@status", Status);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(NEwsqlConn, CommandType.StoredProcedure, "Usp_Dashboard_Project", param))

            {
                while (drrr.Read())
                {
                    List_SM.Add(new Dashboard_Projects()
                    {
                        ////count(staffcode)Tcount, projectname, jobstatus, departmentname, TotalTime
                        TCount = objComm.GetValue<int>(drrr["Tcount"].ToString()),
                        Project = objComm.GetValue<string>(drrr["projectname"].ToString()),
                        JobStatus = objComm.GetValue<string>(drrr["jobstatus"].ToString()),
                        Startdt = objComm.GetValue<string>(drrr["StartDt"].ToString()),
                        Enddt = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        Department = objComm.GetValue<string>(drrr["departmentname"].ToString()),
                        TotalTime = objComm.GetValue<string>(drrr["TotalTime"].ToString()),
                        hCharge  = objComm.GetValue<double>(drrr["hourlycharges"].ToString()),
                        ProjectId = objComm.GetValue<int>(drrr["projectid"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Dashboard_Projects> tbl = List_SM as IEnumerable<Dashboard_Projects>;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod]
    public string Project_Dropdown(string compid, string fr, string to )
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Dashboard_Projects> List_Pr = new List<Dashboard_Projects>();
        try
        {
            string[] dfrdate;
            string[] dtodate;
            dfrdate = fr.Split('/');
            dtodate = to.Split('/');
            string fromDate = dfrdate[1] + "/" + dfrdate[0] + "/" + dfrdate[2];
            string ToDate = dtodate[1] + "/" + dtodate[0] + "/" + dtodate[2];
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@fdate", fromDate);
            param[2] = new SqlParameter("@todate", ToDate);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(NEwsqlConn, CommandType.StoredProcedure, "Usp_Dashboard_Project_Bind", param))
            {
                while (drrr.Read())
                {
                    List_Pr.Add(new Dashboard_Projects()
                    {
                        Project = objComm.GetValue<string>(drrr["projectname"].ToString()),
                        ProjectId = objComm.GetValue<int>(drrr["pid"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<Dashboard_Projects> tbl = List_Pr as IEnumerable<Dashboard_Projects>;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod]
    public string Drill_Project(string compid, string pid)
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Dashboard_Projects_Details> List_SM = new List<Dashboard_Projects_Details>();
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@ProjectId", pid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(NEwsqlConn, CommandType.StoredProcedure, "Usp_Dashboard_Project_Details", param))

            {
                while (drrr.Read())
                {
                    List_SM.Add(new Dashboard_Projects_Details()
                    {
                        ////count(staffcode)Tcount, projectname, jobstatus, departmentname, TotalTime

                        Department = objComm.GetValue<string>(drrr["departmentname"].ToString()),
                        TotalTime = objComm.GetValue<string>(drrr["TotalTime"].ToString()),
                        Staffname = objComm.GetValue<string>(drrr["staffname"].ToString()),
                        hCharge  = objComm.GetValue<double>(drrr["hourlycharges"].ToString())
                    });
                }

                List<Projects_Details> listPrj = new List<Projects_Details>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listPrj.Add(new Projects_Details()
                            {
                                Project = objComm.GetValue<string>(drrr["Projectname"].ToString()),
                                StartDT = objComm.GetValue<string>(drrr["CreationDate"].ToString()),
                                EndDT = objComm.GetValue<string>(drrr["ActualJobEndate"].ToString())


                            });
                        }
                    }
                }

                foreach (var item in List_SM)
                {
                    item.list_Project_Details = listPrj;

                }
            }
        }
        catch (Exception ex)
        {

            throw ex;
        }

        IEnumerable<Dashboard_Projects_Details> tbl = List_SM as IEnumerable<Dashboard_Projects_Details>;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]
    public string GetEndProject(int compid, string Startdt, string Enddt, int Deptwise,string ddl,string Srch)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<End_Project> obj_Job = new List<End_Project>();

        try
        {
            string fromdate = Startdt != "" ? Convert.ToDateTime(Startdt, ci).ToString("MM/dd/yyyy") : null;
            string todate = Enddt != "" ? Convert.ToDateTime(Enddt, ci).ToString("MM/dd/yyyy") : null;

            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@deptwise", Deptwise);
            param[2] = new SqlParameter("@startdt", fromdate);
            param[3] = new SqlParameter("@enddt", todate);
            param[4] = new SqlParameter("@ddl",ddl);
            param[5] = new SqlParameter("@srch", Srch);


            //DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_GetEndDate_Project", param);//for chacking the Data 
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetEndDate_Project", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new End_Project()
                    {
                        Jobid = objComm.GetValue<int>(drrr["JobId"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        PrjName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        Strtdt = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        Enddt = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        Count =objComm.GetValue<int>(drrr["Countid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<End_Project> tbl = obj_Job as IEnumerable<End_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]
    public string GetEndProject_staff(int compid, string Startdt, string Enddt, int Deptwise,int Staffcode)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<End_Project> obj_Job = new List<End_Project>();

        try
        {
            string fromdate = Startdt != "" ? Convert.ToDateTime(Startdt, ci).ToString("MM/dd/yyyy") : null;
            string todate = Enddt != "" ? Convert.ToDateTime(Enddt, ci).ToString("MM/dd/yyyy") : null;

            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@deptwise", Deptwise);
            param[2] = new SqlParameter("@startdt", fromdate);
            param[3] = new SqlParameter("@enddt", todate);
            param[4] = new SqlParameter("@Staffcode", Staffcode);


            //DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_GetEndDate_Project_Staff", param);//for chacking the Data 
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetEndDate_Project_Staff", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new End_Project()
                    {
                        Jobid = objComm.GetValue<int>(drrr["sino"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        PrjName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        Strtdt = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        Enddt = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        Count =objComm.GetValue<int>(drrr["Countid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<End_Project> tbl = obj_Job as IEnumerable<End_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod]
    public string UpdateEndProject(int compid, string Rid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<End_Project> obj_Job = new List<End_Project>();

        try
        {

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@rid", Rid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Update_EndDate", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new End_Project()
                    {
                        Jobid = objComm.GetValue<int>(drrr["id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<End_Project> tbl = obj_Job as IEnumerable<End_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

        [WebMethod]
    public string HorlyChargeStaff(int compid, int desig)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<End_Project> obj_Job = new List<End_Project>();

        try
        {

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Design", desig);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_HourlyChargesStaff", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new End_Project()
                    {
                        Jobid = objComm.GetValue<int>(drrr["HourlyCharges"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<End_Project> tbl = obj_Job as IEnumerable<End_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

}