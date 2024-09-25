<%@ WebService Language="C#" Class="wsStaff" %>

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
public class wsStaff : System.Web.Services.WebService
{
    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod(EnableSession = true)]
    public string BindPageLoadStaff(string UserType, string FromDate, string ToDate, string status, string StaffCode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[6];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@UserType", UserType);
                param[2] = new SqlParameter("@FromDate", Convert.ToDateTime(FromDate, ci));
                param[3] = new SqlParameter("@ToDate", Convert.ToDateTime(ToDate, ci));
                param[4] = new SqlParameter("@TStatus", status.TrimEnd(','));
                param[5] = new SqlParameter("@StaffCode", StaffCode);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_report_BindPageLoadStaff", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new tbl_StaffMaster()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod(EnableSession = true)]
    public string BindStaffList(string UserType, string status, string StaffCode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[5];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@UserType", UserType);
                param[2] = new SqlParameter("@Status", status);
                param[3] = new SqlParameter("@StaffCode", StaffCode);
                param[4] = new SqlParameter("@SelectedStaffCode", "Empty");
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_report_BindStaffList", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new tbl_StaffMaster()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string BindDepartment(string UserType, string status, string StaffCode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[5];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@UserType", UserType);
                param[2] = new SqlParameter("@Status", status);
                param[3] = new SqlParameter("@StaffCode", StaffCode);
                param[4] = new SqlParameter("@SelectedDepartment", "Empty");
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_report_BindDepartment", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new tbl_StaffMaster()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["DepId"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["DepartmentName"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string BindClientList(int compid = 0)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[5];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_report_BindClientList", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new tbl_StaffMaster()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["ClientName"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Bind_JobGroup_Job_Client_All_Selected(ReprotAllStaffCilentJob currobj)
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[13];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@UserType", currobj.UserType);
            param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
            param[3] = new SqlParameter("@StaffCode", currobj.StaffCode == "" ? "0" : currobj.StaffCode);
            param[4] = new SqlParameter("@selectedJobGrp", currobj.selectedJobGrp.TrimEnd(','));
            param[5] = new SqlParameter("@selectedclientid", currobj.selectedclientid.TrimEnd(','));
            param[6] = new SqlParameter("@selectedjobid", currobj.selectedjobid.TrimEnd(','));
            param[7] = new SqlParameter("@needJobGrp", currobj.needJobGrp);
            param[8] = new SqlParameter("@neetclient", currobj.neetclient);
            param[9] = new SqlParameter("@needjob", currobj.needjob);
            param[10] = new SqlParameter("@FromDate", Convert.ToDateTime(currobj.FromDate, ci));
            param[11] = new SqlParameter("@ToDate", Convert.ToDateTime(currobj.ToDate, ci));
            param[12] = new SqlParameter("@RType", currobj.RType);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(NEwsqlConn, CommandType.StoredProcedure, "usp_Bind_JobGroup_Job_Client_All_Selected", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_StaffMaster()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
            }

        }
        catch (Exception ex)
        { return null; }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod]
    public string Bind_Staff_Client_Job_All_Selected(ReprotAllStaffCilentJob currobj)//int compid, string UserType, string status, string StaffCode)
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();
        string fr = currobj.FromDate != "" ? Convert.ToDateTime(currobj.FromDate, ci).ToString("MM/dd/yyyy") : null;
        string to = currobj.ToDate != "" ? Convert.ToDateTime(currobj.ToDate, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[13];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@UserType", currobj.UserType);
            param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
            param[3] = new SqlParameter("@StaffCode", currobj.StaffCode == "" ? "0" : currobj.StaffCode);
            param[4] = new SqlParameter("@selectedstaffcode", currobj.selectedstaffcode.TrimEnd(','));
            param[5] = new SqlParameter("@selectedclientid", currobj.selectedclientid.TrimEnd(','));
            param[6] = new SqlParameter("@selectedjobid", currobj.selectedjobid.TrimEnd(','));
            param[7] = new SqlParameter("@neetstaff", currobj.neetstaff);
            param[8] = new SqlParameter("@neetclient", currobj.neetclient);
            param[9] = new SqlParameter("@needjob", currobj.needjob);
            param[10] = new SqlParameter("@FromDate", fr);
            param[11] = new SqlParameter("@ToDate", to);
            param[12] = new SqlParameter("@RType", currobj.RType);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(NEwsqlConn, CommandType.StoredProcedure, "usp_report_Bind_staff_client_job_selected", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_StaffMaster()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
            }


        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession=true)]
    public string Bind_dept_desg_All_Selected(ReprotAllStaffCilentJob currobj)
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_dept = new List<tbl_StaffMaster>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[5];
                param[0] = new SqlParameter("@compid", Session["companyid"]);

                param[1] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
                param[2] = new SqlParameter("@selecteddeptid", currobj.selecteddeptid.TrimEnd(','));
                param[3] = new SqlParameter("@FromDate", Convert.ToDateTime(currobj.FromDate, ci));
                param[4] = new SqlParameter("@ToDate", Convert.ToDateTime(currobj.ToDate, ci));

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(NEwsqlConn, CommandType.StoredProcedure, "usp_report_Bind_dept_desg_selected", param))
                {
                    while (drrr.Read())
                    {
                        List_dept.Add(new tbl_StaffMaster()
                        {
                            desgid = objComm.GetValue<int>(drrr["id"].ToString()),
                            designation = objComm.GetValue<string>(drrr["name"].ToString())

                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_dept as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string BindYear()
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Year_Master> List_Yr = new List<tbl_Year_Master>();

        try
        {
            Common ob = new Common();

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(NEwsqlConn, CommandType.StoredProcedure, "Usp_BindYear"))
            {
                while (drrr.Read())
                {
                    List_Yr.Add(new tbl_Year_Master()
                    {
                        Fin_Year_ID = objComm.GetValue<int>(drrr["Fin_Year_ID"].ToString()),
                        Fin_Year = objComm.GetValue<string>(drrr["Fin_Year"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Year_Master> tbl = List_Yr as IEnumerable<tbl_Year_Master>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string BindStaff(int compid, string UserType, string StaffCode)
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@UserType", UserType);
            param[2] = new SqlParameter("@StaffCode", StaffCode);
            param[3] = new SqlParameter("@SelectedStaffCode", "Empty");
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(NEwsqlConn, CommandType.StoredProcedure, "usp_report_BindStaff", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_StaffMaster()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string bind_client_project_staff_Selected(ReprotAllStaffCilentJob currobj)
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[13];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@UserType", currobj.UserType);
            param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
            param[3] = new SqlParameter("@StaffCode", currobj.StaffCode == "" ? "0" : currobj.StaffCode);
            param[4] = new SqlParameter("@selectedstaffcode", currobj.selectedstaffcode.TrimEnd(','));
            param[5] = new SqlParameter("@selectedclientid", currobj.selectedclientid.TrimEnd(','));
            param[6] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
            param[7] = new SqlParameter("@neetstaff", currobj.neetstaff);
            param[8] = new SqlParameter("@neetclient", currobj.neetclient);
            param[9] = new SqlParameter("@needproject", currobj.needproject);
            param[10] = new SqlParameter("@FromDate", Convert.ToDateTime(currobj.FromDate, ci));
            param[11] = new SqlParameter("@ToDate", Convert.ToDateTime(currobj.ToDate, ci));
            param[12] = new SqlParameter("@RType", currobj.RType);
            DataSet ds = SqlHelper.ExecuteDataset(NEwsqlConn, CommandType.StoredProcedure, "usp_Get_StaffSummary_Client_Project_Job_Selected", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(NEwsqlConn, CommandType.StoredProcedure, "usp_Get_StaffSummary_Client_Project_Job_Selected", param))

            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_StaffMaster()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["NAME"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]
    public string GetLeftStaff(int compid, string srch, int pageindex, int pagesize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@PageIndex", pageindex);
            param[2] = new SqlParameter("@PageSize", pagesize);
            param[3] = new SqlParameter("@Srch", srch);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_GetLeftStaff", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_StaffMaster()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        designation = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        Srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                        DateOfJoining = objComm.GetValue<string>(drrr["DateOfJoining"].ToString()),
                        DateOfLeaving = objComm.GetValue<string>(drrr["DateOfLeaving"].ToString()),
                        Total = objComm.GetValue<string>(drrr["Total"].ToString()),
                    });
                }
                List<tbl_leftstaff> listrecord = new List<tbl_leftstaff>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listrecord.Add(new tbl_leftstaff()
                            {
                                RecordCount = objComm.GetValue<int>(drrr["RecordCount"].ToString()),
                            });
                        }
                    }
                }
                foreach (var item in List_SM)
                {
                    item.list_RecordCount = listrecord;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string UpdateleftStaff(int compid, int Staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_leftstaff> List_SM = new List<tbl_leftstaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Staffcode", Staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Update_DateofLeaving", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_leftstaff()
                    {
                        id = objComm.GetValue<int>(drrr["srno"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_leftstaff> tbl = List_SM as IEnumerable<tbl_leftstaff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string AllClient_Alljob_AllStaff(string compid, string UType, string Sts, int Scode, string Staffids, string Cltids, string Jobids, string fr, string to, int rs)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            string Proc = "";
            if (rs == 1)
            {
                Proc = "usp_Report_ClientwiseTimesheetSummary";
            }
            else
            {
                Proc = "usp_Report_ClientwiseTimesheetDetailed_Format2";
            }


            string fromdate = fr != "" ? Convert.ToDateTime(fr, ci).ToString("MM/dd/yyyy") : null;
            string todate = to != "" ? Convert.ToDateTime(to, ci).ToString("MM/dd/yyyy") : null;

            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@UserType", UType);
            param[2] = new SqlParameter("@TStatus", Sts);
            param[3] = new SqlParameter("@StaffCode", Scode);

            param[4] = new SqlParameter("@selectedstaffcode", Staffids);
            param[5] = new SqlParameter("@selectedclientid", Cltids);
            param[6] = new SqlParameter("@selectedjobid", Jobids);
            param[7] = new SqlParameter("@FromDate", fromdate);
            param[8] = new SqlParameter("@ToDate", todate);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, Proc, param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }


}

