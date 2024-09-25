<%@ WebService Language="C#" Class="ProcessPayroll" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data.SqlClient;
using System.Data;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Globalization;
using System.Web.Security;
using System.Text.RegularExpressions;
using CommonLibrary;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ProcessPayroll : System.Web.Services.WebService
{
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

    [WebMethod(EnableSession = true)]
    public string GetPayslip(int Monthid, string selectedStaff)
    {
        DataSet ds = new DataSet();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Monthid", Monthid);
            param[2] = new SqlParameter("@selectedStaff", selectedStaff.Replace(",", "^"));

            ds = SqlHelper.ExecuteDataset(objComm._cnnString2, CommandType.StoredProcedure, "usp_Bootstrap_GetPayslip", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [System.Web.Services.WebMethod(EnableSession = true)]
    public string GetGeneratedMonths(int StaffCode)
    {
        List<int> generatedMonths = new List<int>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@CompID", Session["companyid"]);
            param[1] = new SqlParameter("@StaffCode", StaffCode);

            using (SqlDataReader reader = SqlHelper.ExecuteReader(objComm._cnnString2, CommandType.StoredProcedure, "usp_GetGeneratedMonthsForStaff", param))
            {
                while (reader.Read())
                {
                    generatedMonths.Add(Convert.ToInt32(reader["SalaryMonth"]));
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(generatedMonths);
    }

    [WebMethod(EnableSession = true)]
    public string GetCurrentYearDeatils()
    {
        DataSet ds = new DataSet();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "Usp_Payroll_FinancialYear", param);
            if (ds.Tables[1].Rows.Count > 0)
            {
                HttpContext.Current.Session["Financial_Year_Text"] = ds.Tables[1].Rows[0]["Financial_Year"].ToString();
                HttpContext.Current.Session["DB_Conn"] = ds.Tables[1].Rows[0]["DB_Connection_String"].ToString();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }
}