<%@ WebService Language="C#" Class="Dept_Client_Project_Summary" %>

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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Dept_Client_Project_Summary : System.Web.Services.WebService
{

    private static readonly CommonFunctions utils = new CommonFunctions();
    private static readonly CultureInfo ci = new CultureInfo("en-GB");
    public Dept_Client_Project_Summary()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string GetDepartemtReport(string compid, string frtime, string totime, string pjtids)
    {
        List<Departement_Report> obj_dept = new List<Departement_Report>();
        try
        {
            string fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
            string todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;

            SqlParameter[] param = new SqlParameter[]
            {
                new SqlParameter("@compid", compid),
                new SqlParameter("@selectedDeptId", pjtids),              
                new SqlParameter("@fromdate", frtime),
                new SqlParameter("@todate", totime)
            };

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(utils._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Rpt_Dept_Client_Project_Summary", param))
            {
                while (drrr.Read())
                {
                    obj_dept.Add(new Departement_Report()
                    {
                        DeptName = utils.GetValue<string>(drrr["DeptName"].ToString()),
                        ClientName = utils.GetValue<string>(drrr["ClientName"].ToString()),
                        ProjectName = utils.GetValue<string>(drrr["ProjectName"].ToString()),
                        ProjectId = utils.GetValue<string>(drrr["ProjectId"].ToString()),
                        ProjectStatus = utils.GetValue<string>(drrr["ProjectStatus"].ToString()),
                        JobName = utils.GetValue<string>(drrr["Scope_of_Work"].ToString()),
                        ActualHours = utils.GetValue<string>(drrr["ActualHours"].ToString()),
                        BillingHours = utils.GetValue<string>(drrr["BillingHours"].ToString()),
                        BudgetedHours = utils.GetValue<decimal>(drrr["BudgetedHours"].ToString()),
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

    [WebMethod]
    public string Bind_DrpDepartment(int compid)
    {
        var list_Department = new Dictionary<int, string>();
        Dictionary<string, int> columnOrdinals = null;
        try
        {
            SqlParameter[] param = new SqlParameter[] { new SqlParameter("@compid", compid), new SqlParameter("@mjobid", 0) };
            using (SqlDataReader dr = SqlHelper.ExecuteReader(utils._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDepartment", param))
            {
                while (dr.Read())
                {
                    columnOrdinals = columnOrdinals ?? Enumerable.Range(0, dr.FieldCount).ToDictionary(i => dr.GetName(i), i => i, StringComparer.InvariantCultureIgnoreCase);
                    list_Department.Add(dr.GetInt32(columnOrdinals["DepId"]), dr.GetString(columnOrdinals["DepartmentName"]) ?? string.Empty);
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(list_Department.OrderBy(kvp => kvp.Value));
    }

}