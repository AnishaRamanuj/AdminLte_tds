<%@ WebService Language="C#" Class="Report_Staff_ProjectwiseHours" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Data.SqlClient;
using CommonLibrary;
using System.Data;
using Microsoft.ApplicationBlocks.Data;
using System.Globalization;
using System.Web.Script.Serialization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Report_Staff_ProjectwiseHours : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]
    public string Get_Staff_Project(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            DateTime strdate = Convert.ToDateTime(currobj.Todate, ci);
            DateTime enddate = Convert.ToDateTime(currobj.Fromdate, ci);

            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@Todate", strdate);
            param[2] = new SqlParameter("@selectedStaff", currobj.selectedstaffCode.TrimEnd(','));
            param[3] = new SqlParameter("@needproject", currobj.needproject);
            param[4] = new SqlParameter("@needstaff", currobj.needstaff);
            param[5] = new SqlParameter("@fromdate", enddate);
            param[6] = new SqlParameter("@BrId", currobj.BrId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_StaffProjectwise", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Get_Client_Staff(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            DateTime strdate = Convert.ToDateTime(currobj.Todate, ci);
            DateTime enddate = Convert.ToDateTime(currobj.Fromdate, ci);

            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@Todate", strdate);
            param[2] = new SqlParameter("@selectedJobid", currobj.selectedJobidCode.TrimEnd(','));
            param[3] = new SqlParameter("@needClient", currobj.needClient);
            param[4] = new SqlParameter("@needstaff", currobj.needstaff);
            param[5] = new SqlParameter("@fromdate", enddate);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_ClientStaffwise", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string Get_Staff_ProjectResource(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            if (Session["companyid"] != null)
            {
                DateTime strdate = Convert.ToDateTime(currobj.Monthdate, ci);

                SqlParameter[] param = new SqlParameter[5];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@monthdate", strdate);
                param[2] = new SqlParameter("@selectedJobid", currobj.selectedJobidCode.TrimEnd(','));
                param[3] = new SqlParameter("@needproject", currobj.needproject);
                param[4] = new SqlParameter("@needstaff", currobj.needstaff);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_ProjectStaff_Resource", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new tbl_ProjectwiseReport()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                            Type = objComm.GetValue<string>(drrr["type"].ToString())
                        });
                    }
                    drrr.Close();
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string Get_Staff_ResourceUtilization(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            if (Session["companyid"] != null)
            {
                DateTime strdate = Convert.ToDateTime(currobj.Monthdate, ci);
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@monthdate", strdate);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_StaffName_Reasource", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new tbl_ProjectwiseReport()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                            Type = objComm.GetValue<string>(drrr["type"].ToString())
                        });
                    }
                    drrr.Close();
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Get_ProjectName(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", currobj.compid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetProjectName", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        Jobid = objComm.GetValue<int>(drrr["JobId"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Get_ClientName(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", currobj.compid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetClientName", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                        clientname = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Get_Client_Project(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@cltid", currobj.cltid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Client_Project", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Get_StaffName(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            DateTime strdate = Convert.ToDateTime(currobj.Monthdate, ci);

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@monthdate", strdate);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetStaffName_grp", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Get_StaffProject(staffprojectwise_Hours currobj)
    {
        DateTime strdate = Convert.ToDateTime(currobj.Monthdate, ci);

        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@monthdate", strdate);
            param[2] = new SqlParameter("@staffcode", currobj.StaffCode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_StaffProject_Grp", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod]
    public string GetApproverStaff(int compid, int Staffcode, string Fromadate, string Todate)
    {
        // DateTime strdate = Convert.ToDateTime(currobj.Monthdate, ci);
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ApproverStaff> List_SM = new List<tbl_ApproverStaff>();
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", Staffcode);
            param[2] = new SqlParameter("@fromdate", Convert.ToDateTime(Fromadate, ci));
            param[3] = new SqlParameter("@todate", Convert.ToDateTime(Todate, ci));

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Approverstaff_list", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ApproverStaff()
                    {
                        staff = objComm.GetValue<string>(drrr["Staffname"].ToString()),
                        dept = objComm.GetValue<string>(drrr["Deptname"].ToString()),
                        projstatus = objComm.GetValue<string>(drrr["jobstatus"].ToString()),
                        Proj = objComm.GetValue<string>(drrr["projectname"].ToString()),
                        Tottime = objComm.GetValue<string>(drrr["Totaltime"].ToString()),
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ApproverStaff> tbl = List_SM as IEnumerable<tbl_ApproverStaff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Get_Client_Reportdtl(int compid, string frmdt, string Todt, string TStatus, string Staffcodeids, string Cltids)
    {
        // DateTime strdate = Convert.ToDateTime(currobj.Monthdate, ci);
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_GetClientweise_Report> List_SM = new List<tbl_GetClientweise_Report>();
        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@FromDate", Convert.ToDateTime(frmdt, ci));
            param[2] = new SqlParameter("@ToDate", Convert.ToDateTime(Todt, ci));
            param[3] = new SqlParameter("@TStatus", TStatus);
            param[4] = new SqlParameter("@selectedstaffcode", Staffcodeids);
            param[5] = new SqlParameter("@selectedjobid", Cltids);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetClientweise_Report", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_GetClientweise_Report()
                    {
                        Client = objComm.GetValue<string>(drrr["Client"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["Projectname"].ToString()),
                        staffname = objComm.GetValue<string>(drrr["staffname"].ToString()),
                        mjobname = objComm.GetValue<string>(drrr["mjobname"].ToString()),
                        hours = objComm.GetValue<string>(drrr["hours"].ToString()),
                        Charges = objComm.GetValue<string>(drrr["Charges"].ToString()),
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_GetClientweise_Report> tbl = List_SM as IEnumerable<tbl_GetClientweise_Report>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetgridReportUtilization(string staffcode, string Monthdt)
    {
        DateTime strdate = Convert.ToDateTime(Monthdt, ci);
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Utilizationreport> List_SM = new List<tbl_Utilizationreport>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@monthdate", Convert.ToDateTime(Monthdt, ci));
                param[2] = new SqlParameter("@selectedStaffcode", staffcode);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Resource_NewUtilization_Report", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new tbl_Utilizationreport()
                        {
                            Staff = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                            Dept = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                            d1DM = objComm.GetValue<string>(drrr["d1"].ToString()),
                            d2DM = objComm.GetValue<string>(drrr["d2"].ToString()),
                            d3DM = objComm.GetValue<string>(drrr["d3"].ToString()),
                            d4DM = objComm.GetValue<string>(drrr["d4"].ToString()),
                            d5DM = objComm.GetValue<string>(drrr["d5"].ToString()),
                            d6DM = objComm.GetValue<string>(drrr["d6"].ToString()),
                            d7DM = objComm.GetValue<string>(drrr["d7"].ToString()),
                            d8DM = objComm.GetValue<string>(drrr["d8"].ToString()),
                            d9DM = objComm.GetValue<string>(drrr["d9"].ToString()),
                            d10DM = objComm.GetValue<string>(drrr["d10"].ToString()),
                            d11DM = objComm.GetValue<string>(drrr["d11"].ToString()),
                            d12DM = objComm.GetValue<string>(drrr["d12"].ToString()),
                            d13DM = objComm.GetValue<string>(drrr["d13"].ToString()),
                            d14DM = objComm.GetValue<string>(drrr["d14"].ToString()),
                            d15DM = objComm.GetValue<string>(drrr["d15"].ToString()),
                            d16DM = objComm.GetValue<string>(drrr["d16"].ToString()),
                            d17DM = objComm.GetValue<string>(drrr["d17"].ToString()),
                            d18DM = objComm.GetValue<string>(drrr["d18"].ToString()),
                            d19DM = objComm.GetValue<string>(drrr["d19"].ToString()),
                            d20DM = objComm.GetValue<string>(drrr["d20"].ToString()),
                            d21DM = objComm.GetValue<string>(drrr["d21"].ToString()),
                            d22DM = objComm.GetValue<string>(drrr["d22"].ToString()),
                            d23DM = objComm.GetValue<string>(drrr["d23"].ToString()),
                            d24DM = objComm.GetValue<string>(drrr["d24"].ToString()),
                            d25DM = objComm.GetValue<string>(drrr["d25"].ToString()),
                            d26DM = objComm.GetValue<string>(drrr["d26"].ToString()),
                            d27DM = objComm.GetValue<string>(drrr["d27"].ToString()),
                            d28DM = objComm.GetValue<string>(drrr["d28"].ToString()),
                            d29DM = objComm.GetValue<string>(drrr["d29"].ToString()),
                            d30DM = objComm.GetValue<string>(drrr["d30"].ToString()),
                            d31DM = objComm.GetValue<string>(drrr["d31"].ToString()),
                            Tot = objComm.GetValue<string>(drrr["Total"].ToString()),
                        });
                    }
                    drrr.Close();
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Utilizationreport> tbl = List_SM as IEnumerable<tbl_Utilizationreport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


}