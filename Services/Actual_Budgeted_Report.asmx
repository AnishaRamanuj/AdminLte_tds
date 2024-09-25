<%@ WebService Language="C#" Class="Actual_Budgeted_Report" %>

using CommonLibrary;
using Microsoft.ApplicationBlocks1.Data;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web.Services;
using System.Web.Script.Serialization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Actual_Budgeted_Report : System.Web.Services.WebService
{

    private static readonly CommonFunctions utils = new CommonFunctions();
    [WebMethod(EnableSession=true)]
    public string GetReport(string fromDate, string toDate, string clientIds, int pageIndex, int pageSize)
    {
        List<tbl_ActualBudgetedReport> obj_Report = new List<tbl_ActualBudgetedReport>();
        try
        {
            if (Session["companyid"] != null)
            {
                string fromdateT = fromDate != "" ? Convert.ToDateTime(fromDate).ToString("MM/dd/yyyy") : null;
                string todateT = toDate != "" ? Convert.ToDateTime(toDate).ToString("MM/dd/yyyy") : null;

                SqlParameter[] param = new SqlParameter[4]
                {
                new SqlParameter("@CompId", Session["companyid"]),
                new SqlParameter("@StartDate", fromdateT),
                new SqlParameter("@EndDate", todateT),
                new SqlParameter("@ClientIds", clientIds)
                    //new SqlParameter("@PageIndex", pageIndex),
                    //new SqlParameter("@PageSize", pageSize)
                };

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(utils._cnnString, CommandType.StoredProcedure, "usp_bootstrap_Budgeted_Actual_Report", param))
                {
                    while (drrr.Read())
                    {
                        obj_Report.Add(new tbl_ActualBudgetedReport()
                        {
                            ClientName = utils.GetValue<string>(drrr["ClientName"].ToString()),
                            ProjectName = utils.GetValue<string>(drrr["ProjectName"].ToString()),
                            StaffName = utils.GetValue<string>(drrr["StaffName"].ToString()),
                            Department = utils.GetValue<string>(drrr["DepartmentName"].ToString()),
                            Designation = utils.GetValue<string>(drrr["DesignationName"].ToString()),
                            BudgetedHrs = utils.GetValue<decimal>(drrr["BugetedHrs"].ToString()),
                            ActualHrs = utils.GetValue<decimal>(drrr["ActualHrs"].ToString()),
                            DifferenceHrs = utils.GetValue<decimal>(drrr["DifferenceHrs"].ToString()),
                            DifferencePercentage = utils.GetValue<int>(drrr["DifferencePercentage"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return JsonConvert.SerializeObject(obj_Report);
    }
    [WebMethod(EnableSession=true)]
    public string GetClients(int compId=0)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<_Bind_clients> objClientsList = new List<_Bind_clients>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@CompId", Session["companyid"]);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetClients", param))
                {
                    while (drrr.Read())
                    {
                        objClientsList.Add(new _Bind_clients()
                        {
                            ClientId = objComm.GetValue<int>(drrr["ClientId"].ToString()),
                            ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(objClientsList);
    }
}