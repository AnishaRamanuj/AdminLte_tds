<%@ WebService Language="C#" Class="Project_Staffwise_Report" %>

using CommonLibrary;
using Microsoft.ApplicationBlocks1.Data;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Project_Staffwise_Report : System.Web.Services.WebService
{
    private static readonly CommonFunctions utils = new CommonFunctions();

    [WebMethod]
    public string Bind_Projects(int compId, string fromDate, string toDate)
    {
        var list_Project = new Dictionary<int, string>();

        fromDate = !string.IsNullOrEmpty(fromDate) ? Convert.ToDateTime(fromDate).ToString("MM/dd/yyyy") : null;
        toDate = !string.IsNullOrEmpty(toDate) ? Convert.ToDateTime(toDate).ToString("MM/dd/yyyy") : null;
        Dictionary<string, int> columnOrdinals = null;
        try
        {
            SqlParameter[] param = new SqlParameter[] {
                new SqlParameter("@compid", compId),
                new SqlParameter("@FromDate", fromDate),
                new SqlParameter("@ToDate", toDate)
            };
            using (SqlDataReader dr = SqlHelper.ExecuteReader(utils._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetProjects_Staffwise_Report", param))
            {
                while (dr.Read())
                {
                    columnOrdinals = columnOrdinals ?? Enumerable.Range(0, dr.FieldCount).ToDictionary(i => dr.GetName(i), i => i, StringComparer.InvariantCultureIgnoreCase);
                    list_Project.Add(dr.GetInt32(columnOrdinals["ProjectID"]), dr.GetString(columnOrdinals["ProjectName"]) ?? string.Empty);
                };
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(list_Project.OrderBy(kvp => kvp.Value));
    }

    [WebMethod]
    public string Bind_Staffs(string compId, string fromDate, string toDate, string projectIds)
    {
        var list_Staff = new Dictionary<int, string>();
        Dictionary<string, int> columnOrdinals_staff = null;
        try
        {
            fromDate = !string.IsNullOrEmpty(fromDate) ? Convert.ToDateTime(fromDate).ToString("MM/dd/yyyy") : null;
            toDate = !string.IsNullOrEmpty(toDate) ? Convert.ToDateTime(toDate).ToString("MM/dd/yyyy") : null;

            SqlParameter[] param = new SqlParameter[]
            {
                new SqlParameter("@Compid", compId),
                new SqlParameter("@SelectedpjtIds", projectIds),
                new SqlParameter("@Fromdate", fromDate),
                new SqlParameter("@Todate", toDate)
            };

            using (SqlDataReader dr = SqlHelper.ExecuteReader(utils._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetStaffByProject_Staffwise_Report", param))
            {
                while (dr.Read())
                {
                    columnOrdinals_staff = columnOrdinals_staff ?? Enumerable.Range(0, dr.FieldCount).ToDictionary(i => dr.GetName(i), i => i, StringComparer.InvariantCultureIgnoreCase);
                    list_Staff.Add(dr.GetInt32(columnOrdinals_staff["StaffId"]), dr.GetString(columnOrdinals_staff["StaffName"]) ?? string.Empty);
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(list_Staff.OrderBy(kvp => kvp.Value));
    }

    [WebMethod]
    public string GetReport(int compId, string frTime, string toTime, string pjtIds, string staffIds, int pageIndex, int pageSize)
    {
        List<tbl_Project_Staffwise_Report> obj_dept = new List<tbl_Project_Staffwise_Report>();
        try
        {
            string fromdate = frTime != "" ? Convert.ToDateTime(frTime).ToString("MM/dd/yyyy") : null;
            string todate = toTime != "" ? Convert.ToDateTime(toTime).ToString("MM/dd/yyyy") : null;

            SqlParameter[] param = new SqlParameter[]
            {
                new SqlParameter("@CompId", compId),
                new SqlParameter("@ProjectIds", pjtIds),
                new SqlParameter("@FromDate", fromdate),
                new SqlParameter("@ToDate", todate),
                new SqlParameter("@StaffIds", staffIds),
                new SqlParameter("@PageIndex", pageIndex),
                new SqlParameter("@PageSize", pageSize)
            };

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(utils._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Staffwise_Report", param))
            {
                while (drrr.Read())
                {
                    obj_dept.Add(new tbl_Project_Staffwise_Report()
                    {
                        SrNo = utils.GetValue<int>(drrr["Srno"].ToString()),
                        ProjectName = utils.GetValue<string>(drrr["ProjectName"].ToString()),
                        StaffName = utils.GetValue<string>(drrr["StaffName"].ToString()),
                        TotalBillable = utils.GetValue<string>(drrr["TotalBillable"].ToString()),
                        TotalNonBillable = utils.GetValue<string>(drrr["TotalNonBillable"].ToString()),
                        Others = utils.GetValue<string>(drrr["Others"].ToString()),
                        Totalcount = utils.GetValue<int>(drrr["TotalCount"].ToString()),
                        Total = utils.GetValue<string>(drrr["Total"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return JsonConvert.SerializeObject(obj_dept);
    }
}