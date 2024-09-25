<%@ WebService Language="C#" Class="WeeklyUtilizationReport" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Globalization;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Text;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WeeklyUtilizationReport : System.Web.Services.WebService
{
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

    [WebMethod]
    public string GetDepts(int compId, string fromDate, string toDate)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_DepartmentBudgeting> obj_Job = new List<tbl_DepartmentBudgeting>();
        try
        {
            Common ob = new Common();
            string fmDate = fromDate != "" ? Convert.ToDateTime(fromDate).ToString("MM/dd/yyyy") : null;
            string tDate = toDate != "" ? Convert.ToDateTime(toDate).ToString("MM/dd/yyyy") : null;

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compId", compId);
            param[1] = new SqlParameter("@FromDate", fmDate);
            param[2] = new SqlParameter("@ToDate", toDate);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetAllDepartments_Timesheet", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_DepartmentBudgeting()
                    {
                        depid = objComm.GetValue<int>(drrr["DepId"].ToString()),
                        Deptname = objComm.GetValue<string>(drrr["DepartmentName"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_DepartmentBudgeting> tbl = obj_Job as IEnumerable<tbl_DepartmentBudgeting>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
}