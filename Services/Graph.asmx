<%@ WebService Language="C#" Class="Graph" %>

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
public class Graph  : System.Web.Services.WebService {
    public static CultureInfo ci = new CultureInfo("en-GB");
    ////Project Graph
    [WebMethod(EnableSession=true)]
    public string GetClient_ProjectBudg(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            if (Session["companyid"] != null)
            {
                DateTime strdate = Convert.ToDateTime(currobj.Fromdate, ci);
                DateTime enddate = Convert.ToDateTime(currobj.Todate, ci);

                SqlParameter[] param = new SqlParameter[6];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@Todate", enddate);
                param[2] = new SqlParameter("@selectedclient", currobj.selectedstaffCode.TrimEnd(','));
                param[3] = new SqlParameter("@needproject", currobj.needproject);
                param[4] = new SqlParameter("@needstaff", currobj.needstaff);
                param[5] = new SqlParameter("@fromdate", strdate);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Boostrap_ClientProjectwiseGrph", param))
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
    public string GetProjectwiseBudgReport(string frmdt, string Todt, string TStatus, string cltidids, string projectids)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectRptGrtph> obj_Job = new List<tbl_ProjectRptGrtph>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[6];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@FromDate", frmdt);
                param[2] = new SqlParameter("@ToDate", Todt);
                param[3] = new SqlParameter("@TStatus", TStatus);
                param[4] = new SqlParameter("@selectedcltid", cltidids);
                param[5] = new SqlParameter("@selectedjobid", projectids);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ProjectGrp", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_ProjectRptGrtph()
                        {
                            Compid = objComm.GetValue<int>(drrr["Compid"].ToString()),
                        });
                    }

                    List<tbl_ProjectGrph> listGrd = new List<tbl_ProjectGrph>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listGrd.Add(new tbl_ProjectGrph()
                                {
                                    project = objComm.GetValue<string>(drrr["project"].ToString()),
                                    M1 = objComm.GetValue<string>(drrr["M1"].ToString()),
                                    M2 = objComm.GetValue<string>(drrr["M2"].ToString()),
                                    M3 = objComm.GetValue<string>(drrr["M3"].ToString()),
                                    M4 = objComm.GetValue<string>(drrr["M4"].ToString()),
                                    M5 = objComm.GetValue<string>(drrr["M5"].ToString()),
                                    M6 = objComm.GetValue<string>(drrr["M6"].ToString()),
                                    M7 = objComm.GetValue<string>(drrr["M7"].ToString()),
                                    M8 = objComm.GetValue<string>(drrr["M8"].ToString()),
                                    M9 = objComm.GetValue<string>(drrr["M9"].ToString()),
                                    M10 = objComm.GetValue<string>(drrr["M10"].ToString()),
                                    M11 = objComm.GetValue<string>(drrr["M11"].ToString()),
                                    M12 = objComm.GetValue<string>(drrr["M12"].ToString()),
                                });
                            }
                        }
                    }

                    List<tbl_PrjGrphSummary> listDep = new List<tbl_PrjGrphSummary>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listDep.Add(new tbl_PrjGrphSummary()
                                {
                                    client = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                                    Project = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                                    StartDate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                                    EndDate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                                    Staffcount = objComm.GetValue<int>(drrr["Staffcount"].ToString()),
                                    Deptcount = objComm.GetValue<int>(drrr["Deptcount"].ToString()),
                                    Totaltime = objComm.GetValue<string>(drrr["Totaltime"].ToString()),
                                });
                            }
                        }
                    }

                    foreach (var item in obj_Job)
                    {
                        item.list_Grph = listGrd;
                        item.list_Summary = listDep;

                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectRptGrtph> tbl = obj_Job as IEnumerable<tbl_ProjectRptGrtph>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


}