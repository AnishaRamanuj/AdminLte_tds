<%@ WebService Language="C#" Class="EmployeeDetailedTimeReport" %>

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
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class EmployeeDetailedTimeReport : System.Web.Services.WebService
{
    [WebMethod]
    public string GetEmpReport(int compId, string staffs, string fromDate, string toDate, int pageIndex, int pageSize)
    {
        CommonFunctions objComm = new CommonFunctions();
        DataSet ds;
        try
        {
             string fmDate = fromDate != "" ? Convert.ToDateTime(fromDate).ToString("MM/dd/yyyy") : null;
            string tDate = toDate != "" ? Convert.ToDateTime(toDate).ToString("MM/dd/yyyy") : null;
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@CompId", compId);
            param[1] = new SqlParameter("@pageIndex", pageIndex);
            param[2] = new SqlParameter("@pageSize", pageSize);
            param[3] = new SqlParameter("@EmpIds", staffs);
            param[4] = new SqlParameter("@FromDate", fmDate);
            param[5] = new SqlParameter("@ToDate", tDate);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_EmployeeDetailedTimeReport", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }
}