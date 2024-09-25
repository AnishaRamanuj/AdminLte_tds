<%@ WebService Language="C#" Class="ResourceUtilization_Report" %>

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
public class ResourceUtilization_Report : System.Web.Services.WebService
{
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    Common ob = new Common();
    [WebMethod(EnableSession=true)]
    public string GetDepartments(string fromDate, string toDate)
    {
        string sDate = fromDate != "" ? Convert.ToDateTime(fromDate).ToString("MM/dd/yyyy") : null;
        string tdate = toDate != "" ? Convert.ToDateTime(toDate).ToString("MM/dd/yyyy") : null;

        var listDepartmentMaster = new Dictionary<int, string>();
        Dictionary<string, int> columnOrdinals = null;
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@FromDate", sDate);
            param[2] = new SqlParameter("@ToDate", tdate);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Departments_ResourceUtilization", param))
            {
                while (drrr.Read())
                {
                    columnOrdinals = columnOrdinals ?? Enumerable.Range(0, drrr.FieldCount).ToDictionary(i => drrr.GetName(i), i => i, StringComparer.InvariantCultureIgnoreCase);
                    listDepartmentMaster.Add(drrr.GetInt32(columnOrdinals["DepId"]), drrr.GetString(columnOrdinals["DepartmentName"]) ?? string.Empty);
                };
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return JsonConvert.SerializeObject(listDepartmentMaster.OrderBy(kvp => kvp.Value));
    }

    [WebMethod(EnableSession=true)]
    public string Generate_ResourceUtilization_Report(string fromDate, string toDate, string departmentIds, string reportType)
    {
        string sDate = fromDate != "" ? Convert.ToDateTime(fromDate).ToString("MM/dd/yyyy") : null;
        string tdate = toDate != "" ? Convert.ToDateTime(toDate).ToString("MM/dd/yyyy") : null;
        string storedProcedureName = "";
        string result = "";
        if (reportType == "1")
        {
            storedProcedureName = "usp_Bootstrap_ResourceUtilization_Detailed_Report";
        }
        if (reportType == "0")
        {
            storedProcedureName = "usp_Bootstrap_ResourceUtilization_Summary_Report";
        }
        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@FromDate", sDate);
            param[2] = new SqlParameter("@ToDate", tdate);
            param[3] = new SqlParameter("@DepartmentIds", departmentIds);
            param[4] = new SqlParameter("@PageIndex", Convert.ToInt32(1));

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, storedProcedureName, param))
            {
                while (drrr.Read())
                {
                    result = objComm.GetValue<string>(drrr["Result"].ToString());
                }
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        return result;
    }
}