<%@ WebService Language="C#" Class="wsAllTimesheets" %>

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
public class wsAllTimesheets : System.Web.Services.WebService
{
    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]

    public string bind_Clients(string compid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<_Bind_clients> obj_Job = new List<_Bind_clients>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_clients", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new _Bind_clients()
                    {
                        Cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["clientname"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<_Bind_clients> tbl = obj_Job as IEnumerable<_Bind_clients>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]

    public string bind_project(string compid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<_Bind_project> obj_Job = new List<_Bind_project>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_project", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new _Bind_project()
                    {
                        projectid = objComm.GetValue<int>(drrr["projectid"].ToString()),
                        projectName = objComm.GetValue<string>(drrr["projectname"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<_Bind_project> tbl = obj_Job as IEnumerable<_Bind_project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]

    public string bind_jobs(string compid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<_Bind_jobs> obj_Job = new List<_Bind_jobs>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bind_jobs", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new _Bind_jobs()
                    {
                        mJobID = objComm.GetValue<int>(drrr["MJobId"].ToString()),
                        MJobName = objComm.GetValue<string>(drrr["MJobName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<_Bind_jobs> tbl = obj_Job as IEnumerable<_Bind_jobs>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }
    [WebMethod]

    public string bind_Staffs(string compid="0")
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<_bind_staffs> obj_Job = new List<_bind_staffs>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_bind_staffs", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new _bind_staffs()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<_bind_staffs> tbl = obj_Job as IEnumerable<_bind_staffs>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]

    public string bind_Task(string compid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<_bind_staffs> obj_Job = new List<_bind_staffs>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_bind_Tasks", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new _bind_staffs()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["TaskId"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["TaskName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<_bind_staffs> tbl = obj_Job as IEnumerable<_bind_staffs>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod]

    public string bind_timesheets(string compid, string cltid, string projectid, string mjobid, string staffcode, string frtime, string totime, string status, string PageIndex, string PageSize, int muti, string task)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<_bind_timesheets> obj_Job = new List<_bind_timesheets>();
        List<AllTimesheetModel> obj_tmst = new List<AllTimesheetModel>();
        //try
        //{
        string spname = "";
        if (muti > 3)
        {
            spname = "usp_bind_timesheets_task";
        }
        else
        {
            spname = "usp_bind_timesheets";
        }
        string fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
        string todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
        Common ob = new Common();
        SqlParameter[] param = new SqlParameter[11];
        param[0] = new SqlParameter("@compid", compid);
        param[1] = new SqlParameter("@cltid", cltid);
        param[2] = new SqlParameter("@FromTime", fromdate);
        param[3] = new SqlParameter("@totime", todate);
        param[4] = new SqlParameter("@status", status);
        param[5] = new SqlParameter("@mJid", mjobid);
        param[6] = new SqlParameter("@sid", staffcode);
        param[7] = new SqlParameter("@projectid", projectid);
        param[8] = new SqlParameter("@PageIndex", PageIndex);
        param[9] = new SqlParameter("@PageSize", PageSize);
        param[10] = new SqlParameter("@task", task);
        ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, spname, param);
        //}
        //catch (Exception ex)
        //{
        //    throw ex;
        //}
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string bind_staff(int compid=0)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<bind_staff_unlock> obj_Job = new List<bind_staff_unlock>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@compid", Session["companyid"]);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_GetStaffName_locked", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new bind_staff_unlock()
                        {
                            staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                            userid = objComm.GetValue<string>(drrr["UserId"].ToString()),

                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<bind_staff_unlock> tbl = obj_Job as IEnumerable<bind_staff_unlock>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod]
    public string Unlock_staff(string uid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<bind_staff_unlock> obj_Job = new List<bind_staff_unlock>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@userid", uid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_unlock_staff", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new bind_staff_unlock()
                    {
                        sucess = objComm.GetValue<string>(drrr["sucess"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<bind_staff_unlock> tbl = obj_Job as IEnumerable<bind_staff_unlock>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod]
    public string bind_Staffsummary(int compid, string Start, string end, int staffcode)
    {
        string result = "";
        CommonFunctions objComm = new CommonFunctions();
        List<Staff_record> obj_ts = new List<Staff_record>();
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@start", Convert.ToDateTime(Start, ci));
            param[2] = new SqlParameter("@end", Convert.ToDateTime(end, ci));
            param[3] = new SqlParameter("@staffcode", staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Admin_StaffSummary", param))
            {
                #region DepartmentWise

                while (drrr.Read())
                {
                    obj_ts.Add(new Staff_record()
                    {
                        record = objComm.GetValue<int>(drrr["RecordCount"].ToString()),

                    });
                }

                List<Datemonth> listmonth_name = new List<Datemonth>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listmonth_name.Add(new Datemonth()
                            {
                                d1DM = objComm.GetValue<string>(drrr["d1"].ToString()),
                                d2DM = objComm.GetValue<string>(drrr["d2"].ToString()),
                                d3DM = objComm.GetValue<string>(drrr["d3"].ToString()),
                                d4DM = objComm.GetValue<string>(drrr["d4"].ToString()),
                                d5DM = objComm.GetValue<string>(drrr["d5"].ToString()),
                                d6DM = objComm.GetValue<string>(drrr["d6"].ToString()),
                                d7DM = objComm.GetValue<string>(drrr["d7"].ToString()),
                            });
                        }
                    }
                }

                List<list_weekname> listweek_name = new List<list_weekname>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listweek_name.Add(new list_weekname()
                            {
                                d1week = objComm.GetValue<string>(drrr["d1"].ToString()),
                                d2week = objComm.GetValue<string>(drrr["d2"].ToString()),
                                d3week = objComm.GetValue<string>(drrr["d3"].ToString()),
                                d4week = objComm.GetValue<string>(drrr["d4"].ToString()),
                                d5week = objComm.GetValue<string>(drrr["d5"].ToString()),
                                d6week = objComm.GetValue<string>(drrr["d6"].ToString()),
                                d7week = objComm.GetValue<string>(drrr["d7"].ToString()),
                            });
                        }
                    }
                }
                List<list_vertical> listVertical_Details = new List<list_vertical>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listVertical_Details.Add(new list_vertical()
                            {
                                d1vet = objComm.GetValue<string>(drrr["d1"].ToString()),
                                d2vet = objComm.GetValue<string>(drrr["d2"].ToString()),
                                d3vet = objComm.GetValue<string>(drrr["d3"].ToString()),
                                d4vet = objComm.GetValue<string>(drrr["d4"].ToString()),
                                d5vet = objComm.GetValue<string>(drrr["d5"].ToString()),
                                d6vet = objComm.GetValue<string>(drrr["d6"].ToString()),
                                d7vet = objComm.GetValue<string>(drrr["d7"].ToString()),
                            });
                        }
                    }
                }


                foreach (var item in obj_ts)
                {
                    item.tbl_Datemonth = listmonth_name;
                    item.tbl_list_weekname = listweek_name;
                    item.tbl_list_vertical = listVertical_Details;
                }
            }
            #endregion

            IEnumerable<Staff_record> tbl = obj_ts as IEnumerable<Staff_record>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }

    [WebMethod]
    public string bind_StaffsummaryData(int compid, string Start, string end, int pageindex, int pagesize, int staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<list_stff_summary> obj_Job = new List<list_stff_summary>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@start", Convert.ToDateTime(Start, ci));
            param[2] = new SqlParameter("@end", Convert.ToDateTime(end, ci));
            param[3] = new SqlParameter("@pageindex", pageindex);
            param[4] = new SqlParameter("@pagesize", pagesize);
            param[5] = new SqlParameter("@staffcode", staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Admin_StaffSummarydata", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new list_stff_summary()
                    {
                        srno = objComm.GetValue<int>(drrr["Srno"].ToString()),
                        Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        d1 = objComm.GetValue<string>(drrr["d1"].ToString()),
                        d2 = objComm.GetValue<string>(drrr["d2"].ToString()),
                        d3 = objComm.GetValue<string>(drrr["d3"].ToString()),
                        d4 = objComm.GetValue<string>(drrr["d4"].ToString()),
                        d5 = objComm.GetValue<string>(drrr["d5"].ToString()),
                        d6 = objComm.GetValue<string>(drrr["d6"].ToString()),
                        d7 = objComm.GetValue<string>(drrr["d7"].ToString()),
                        Total = objComm.GetValue<string>(drrr["Total"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<list_stff_summary> tbl = obj_Job as IEnumerable<list_stff_summary>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string bind_MinimumHrs(int compid, string Start, string end, int staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<MinimumHrs> obj_Job = new List<MinimumHrs>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@companyId", compid);
            param[1] = new SqlParameter("@from_date", Convert.ToDateTime(Start, ci));
            param[2] = new SqlParameter("@to_date", Convert.ToDateTime(end, ci));
            param[3] = new SqlParameter("@Sid", staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Minimum_Hours_report", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new MinimumHrs()
                    {
                        srno = objComm.GetValue<int>(drrr["SrNo"].ToString()),
                        Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Deptname = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        DesignName = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        Tdate = objComm.GetValue<string>(drrr["Tdate"].ToString()),
                        totaltm = objComm.GetValue<string>(drrr["TotalTime"].ToString()),
                        hors = objComm.GetValue<string>(drrr["Minimum_Hours"].ToString()),
                        diff = objComm.GetValue<string>(drrr["Difference"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<MinimumHrs> tbl = obj_Job as IEnumerable<MinimumHrs>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]

    public string StaffBind_Approver(int compid, string Staff_role, int Staffcode)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<_bind_staffs> obj_Job = new List<_bind_staffs>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffrole", Staff_role);
            param[2] = new SqlParameter("@staffcode", Staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_ApproverStaff", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new _bind_staffs()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<_bind_staffs> tbl = obj_Job as IEnumerable<_bind_staffs>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]
    public string bind_ApproverStaff_Staffsummary(int compid, string Start, string end, int staffcode, string staff_role, int sid)
    {
        string result = "";
        CommonFunctions objComm = new CommonFunctions();
        List<Staff_record> obj_ts = new List<Staff_record>();
        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@start", Convert.ToDateTime(Start, ci));
            param[2] = new SqlParameter("@end", Convert.ToDateTime(end, ci));
            param[3] = new SqlParameter("@staffcode", staffcode);
            param[4] = new SqlParameter("@staff_role", staff_role);
            param[5] = new SqlParameter("@Sid", sid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_AppStaff_StaffSummary", param))
            {
                #region DepartmentWise

                while (drrr.Read())
                {
                    obj_ts.Add(new Staff_record()
                    {
                        record = objComm.GetValue<int>(drrr["RecordCount"].ToString()),

                    });
                }

                List<Datemonth> listmonth_name = new List<Datemonth>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listmonth_name.Add(new Datemonth()
                            {
                                d1DM = objComm.GetValue<string>(drrr["d1"].ToString()),
                                d2DM = objComm.GetValue<string>(drrr["d2"].ToString()),
                                d3DM = objComm.GetValue<string>(drrr["d3"].ToString()),
                                d4DM = objComm.GetValue<string>(drrr["d4"].ToString()),
                                d5DM = objComm.GetValue<string>(drrr["d5"].ToString()),
                                d6DM = objComm.GetValue<string>(drrr["d6"].ToString()),
                                d7DM = objComm.GetValue<string>(drrr["d7"].ToString()),
                            });
                        }
                    }
                }

                List<list_weekname> listweek_name = new List<list_weekname>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listweek_name.Add(new list_weekname()
                            {
                                d1week = objComm.GetValue<string>(drrr["d1"].ToString()),
                                d2week = objComm.GetValue<string>(drrr["d2"].ToString()),
                                d3week = objComm.GetValue<string>(drrr["d3"].ToString()),
                                d4week = objComm.GetValue<string>(drrr["d4"].ToString()),
                                d5week = objComm.GetValue<string>(drrr["d5"].ToString()),
                                d6week = objComm.GetValue<string>(drrr["d6"].ToString()),
                                d7week = objComm.GetValue<string>(drrr["d7"].ToString()),
                            });
                        }
                    }
                }
                List<list_vertical> listVertical_Details = new List<list_vertical>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listVertical_Details.Add(new list_vertical()
                            {
                                d1vet = objComm.GetValue<string>(drrr["d1"].ToString()),
                                d2vet = objComm.GetValue<string>(drrr["d2"].ToString()),
                                d3vet = objComm.GetValue<string>(drrr["d3"].ToString()),
                                d4vet = objComm.GetValue<string>(drrr["d4"].ToString()),
                                d5vet = objComm.GetValue<string>(drrr["d5"].ToString()),
                                d6vet = objComm.GetValue<string>(drrr["d6"].ToString()),
                                d7vet = objComm.GetValue<string>(drrr["d7"].ToString()),
                            });
                        }
                    }
                }


                foreach (var item in obj_ts)
                {
                    item.tbl_Datemonth = listmonth_name;
                    item.tbl_list_weekname = listweek_name;
                    item.tbl_list_vertical = listVertical_Details;
                }
            }
            #endregion

            IEnumerable<Staff_record> tbl = obj_ts as IEnumerable<Staff_record>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }

    [WebMethod]
    public string bind_ApproverStaff_StaffsummaryData(int compid, string Start, string end, int pageindex, int pagesize, int staffcode, string staff_role, int sid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<list_stff_summary> obj_Job = new List<list_stff_summary>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@start", Convert.ToDateTime(Start, ci));
            param[2] = new SqlParameter("@end", Convert.ToDateTime(end, ci));
            param[3] = new SqlParameter("@pageindex", pageindex);
            param[4] = new SqlParameter("@pagesize", pagesize);
            param[5] = new SqlParameter("@staffcode", staffcode);
            param[6] = new SqlParameter("@staff_role", staff_role);
            param[7] = new SqlParameter("@Sid", sid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_staff_StaffSummarydata", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new list_stff_summary()
                    {
                        srno = objComm.GetValue<int>(drrr["Srno"].ToString()),
                        Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        d1 = objComm.GetValue<string>(drrr["d1"].ToString()),
                        d2 = objComm.GetValue<string>(drrr["d2"].ToString()),
                        d3 = objComm.GetValue<string>(drrr["d3"].ToString()),
                        d4 = objComm.GetValue<string>(drrr["d4"].ToString()),
                        d5 = objComm.GetValue<string>(drrr["d5"].ToString()),
                        d6 = objComm.GetValue<string>(drrr["d6"].ToString()),
                        d7 = objComm.GetValue<string>(drrr["d7"].ToString()),
                        Total = objComm.GetValue<string>(drrr["Total"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<list_stff_summary> tbl = obj_Job as IEnumerable<list_stff_summary>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string bind_Approver_MinimumHrs(int compid, string Start, string end, int staffcode, string staff_role, int sid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<MinimumHrs> obj_Job = new List<MinimumHrs>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@companyId", compid);
            param[1] = new SqlParameter("@from_date", Convert.ToDateTime(Start, ci));
            param[2] = new SqlParameter("@to_date", Convert.ToDateTime(end, ci));
            param[3] = new SqlParameter("@staffcode", staffcode);
            param[4] = new SqlParameter("@staff_role", staff_role);
            param[5] = new SqlParameter("@Sid", sid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Approverstaff_Minimum_Hours_report", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new MinimumHrs()
                    {
                        srno = objComm.GetValue<int>(drrr["SrNo"].ToString()),
                        Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Deptname = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        DesignName = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        Tdate = objComm.GetValue<string>(drrr["Tdate"].ToString()),
                        totaltm = objComm.GetValue<string>(drrr["TotalTime"].ToString()),
                        hors = objComm.GetValue<string>(drrr["Minimum_Hours"].ToString()),
                        diff = objComm.GetValue<string>(drrr["Difference"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<MinimumHrs> tbl = obj_Job as IEnumerable<MinimumHrs>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string bind_Approver_TimesheetNotSubmitted(int compid, string Start, string end, int staffcode, string staff_role, string wk)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_timesheet_not> obj_Job = new List<tbl_timesheet_not>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@companyId", compid);
            param[1] = new SqlParameter("@from_date", Convert.ToDateTime(Start, ci));
            param[2] = new SqlParameter("@to_date", Convert.ToDateTime(end, ci));
            param[3] = new SqlParameter("@staffcode", staffcode);
            param[4] = new SqlParameter("@staff_role", staff_role);
            param[5] = new SqlParameter("@Wk", wk);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Staff_TimeSheetNotSubmitted", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_timesheet_not()
                    {
                        srno = objComm.GetValue<int>(drrr["SrNo"].ToString()),
                        Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Deptname = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        DesignName = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        Tdate = objComm.GetValue<string>(drrr["lasttimesheet"].ToString()),
                        Approver = objComm.GetValue<string>(drrr["Approver"].ToString()),
                        mobile = objComm.GetValue<string>(drrr["Mobile"].ToString()),
                        email= objComm.GetValue<string>(drrr["Email"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_timesheet_not> tbl = obj_Job as IEnumerable<tbl_timesheet_not>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
}