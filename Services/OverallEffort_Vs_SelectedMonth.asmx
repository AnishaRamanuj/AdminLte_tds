<%@ WebService Language="C#" Class="OverallEffort_Vs_SelectedMonth" %>

using System;
using System.Web;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Globalization;
using System.Linq;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class OverallEffort_Vs_SelectedMonth : System.Web.Services.WebService
{

    [WebMethod]
    public string OverallEffort_Vs_Selected_Report(int compId, string searchMonth, string projectIds, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<OverallEffort_Vs_Selected_Report> obj_Report = new List<OverallEffort_Vs_Selected_Report>();
        string monthDate = searchMonth != "" ? Convert.ToDateTime(searchMonth).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@CompId", compId);
            param[1] = new SqlParameter("@SearchMonth", monthDate);
            param[2] = new SqlParameter("@ProjectIds", projectIds);
            param[3] = new SqlParameter("@pageIndex", pageIndex);
            param[4] = new SqlParameter("@pageSize", pageSize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_OverallEffort_Vs_SelectedMonth_Report", param))
            {
                while (drrr.Read())
                {
                    obj_Report.Add(new OverallEffort_Vs_Selected_Report()
                    {
                        ProjectID = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        StartDate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        EndDate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        TotalApproved = objComm.GetValue<int>(drrr["TotalApproved"].ToString()),
                        TotalSubmitted = objComm.GetValue<int>(drrr["TotalSubmitted"].ToString()),
                        TotalSaved = objComm.GetValue<int>(drrr["TotalSaved"].ToString()),
                        TotalRejected = objComm.GetValue<int>(drrr["TotalRejected"].ToString()),
                        MonthApproved = objComm.GetValue<int>(drrr["MonthApproved"].ToString()),
                        MonthSubmitted = objComm.GetValue<int>(drrr["MonthSubmitted"].ToString()),
                        MonthSaved = objComm.GetValue<int>(drrr["MonthSaved"].ToString()),
                        MonthRejected = objComm.GetValue<int>(drrr["MonthRejected"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["TCount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(obj_Report);
    }

    [WebMethod]
    public string GetProjects_OverallVsSelectedMonthReport(int compId, string searchMonth)
    {
        var list_Project = new Dictionary<int, string>();
        Dictionary<string, int> columnOrdinals = null;
        string monthDate = searchMonth != "" ? Convert.ToDateTime(searchMonth).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@CompId", compId);
            param[1] = new SqlParameter("@SearchMonth", monthDate);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(ob._cnnString, CommandType.StoredProcedure, "GetProjects_OverallVsSelectedMonthReport", param))
            {
                while (drrr.Read())
                {
                    columnOrdinals = columnOrdinals ?? Enumerable.Range(0, drrr.FieldCount).ToDictionary(i => drrr.GetName(i), i => i, StringComparer.InvariantCultureIgnoreCase);
                    list_Project.Add(drrr.GetInt32(columnOrdinals["ProjectID"]), drrr.GetString(columnOrdinals["ProjectName"]) ?? string.Empty);
                };
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(list_Project.OrderBy(kvp => kvp.Value));
    }
}