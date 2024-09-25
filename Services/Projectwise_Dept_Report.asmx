<%@ WebService Language="C#" Class="Projectwise_Dept_Report" %>

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

/// <summary>
/// Summary description for Projectwise_Dept_Report
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Projectwise_Dept_Report : System.Web.Services.WebService
{
    private static readonly CommonFunctions utils = new CommonFunctions();
    private static readonly CultureInfo ci = new CultureInfo("en-GB");
    public Projectwise_Dept_Report()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession=true)]
    public string GetDepartemtReport(string frtime, string totime, string pjtids, string deptIds)
    {
        List<Departement_Report> obj_dept = new List<Departement_Report>();
        try
        {
            if (Session["companyid"] != null)
            {
                string fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
                string todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;

                SqlParameter[] param = new SqlParameter[]
                {
                new SqlParameter("@compid", Session["companyid"]),
                new SqlParameter("@selectedpjtid", pjtids),
                new SqlParameter("@fromdate", frtime),
                new SqlParameter("@todate", totime),
                new SqlParameter("@selectedDepts", deptIds)
                };

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(utils._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDepartamentReport_On_Project", param))
                {
                    while (drrr.Read())
                    {
                        obj_dept.Add(new Departement_Report()
                        {
                            //sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                            DeptName = utils.GetValue<string>(drrr["DeptName"].ToString()),
                            Date = utils.GetValue<string>(drrr["Date"].ToString()),
                            DayName = utils.GetValue<string>(drrr["Day_Name"].ToString()),
                            ClientName = utils.GetValue<string>(drrr["ClientName"].ToString()),
                            ProjectName = utils.GetValue<string>(drrr["ProjectName"].ToString()),
                            ResourceName = utils.GetValue<string>(drrr["ResourceName"].ToString()),
                            JobName = utils.GetValue<string>(drrr["JobName"].ToString()),
                            TaskDescription = utils.GetValue<string>(drrr["TaskDescription"].ToString()),
                            ActualHours = utils.GetValue<string>(drrr["ActualHours"].ToString()),
                            BillingHours = utils.GetValue<string>(drrr["BillingHours"].ToString()),
                            Reason = utils.GetValue<string>(drrr["Reason"].ToString()),
                            NonBillingHours = utils.GetValue<string>(drrr["NonBillableHrs"].ToString()),
                            ScopeofWork = utils.GetValue<string>(drrr["ScopeofWork"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return JsonConvert.SerializeObject(obj_dept);
    }

    [WebMethod(EnableSession=true)]
    public string Bind_DrpDept(string fromDate, string toDate, string pjtids)
    {
        var list_Dept = new Dictionary<int, string>();
        Dictionary<string, int> columnOrdinals = null;
        try
        {
            if (Session["companyid"] != null)
            {
                fromDate = !string.IsNullOrEmpty(fromDate) ? Convert.ToDateTime(fromDate, ci).ToString("MM/dd/yyyy") : null;
                toDate = !string.IsNullOrEmpty(toDate) ? Convert.ToDateTime(toDate, ci).ToString("MM/dd/yyyy") : null;

                SqlParameter[] param = new SqlParameter[]
                {
                new SqlParameter("@compid", Session["companyid"]),
                new SqlParameter("@selectedpjtid", pjtids),
                new SqlParameter("@fromdate", fromDate),
                new SqlParameter("@todate", toDate)
                };

                using (SqlDataReader dr = SqlHelper.ExecuteReader(utils._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDeptByProject", param))
                {
                    while (dr.Read())
                    {
                        columnOrdinals = columnOrdinals ?? Enumerable.Range(0, dr.FieldCount).ToDictionary(i => dr.GetName(i), i => i, StringComparer.InvariantCultureIgnoreCase);
                        list_Dept.Add(dr.GetInt32(columnOrdinals["DeptId"]), dr.GetString(columnOrdinals["DepartmentName"]) ?? string.Empty);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(list_Dept.OrderBy(kvp => kvp.Value));
    }

    [WebMethod(EnableSession=true)]
    public string Bind_DrpProject(int compid=0)
    {
        var list_Project = new Dictionary<int, string>();
        Dictionary<string, int> columnOrdinals = null;
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[] { new SqlParameter("@compid", Session["companyid"]) };
                using (SqlDataReader dr = SqlHelper.ExecuteReader(utils._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetProjects", param))
                {
                    while (dr.Read())
                    {
                        columnOrdinals = columnOrdinals ?? Enumerable.Range(0, dr.FieldCount).ToDictionary(i => dr.GetName(i), i => i, StringComparer.InvariantCultureIgnoreCase);
                        list_Project.Add(dr.GetInt32(columnOrdinals["ProjectID"]), dr.GetString(columnOrdinals["ProjectName"]) ?? string.Empty);
                    };
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(list_Project.OrderBy(kvp => kvp.Value));
    }

}
