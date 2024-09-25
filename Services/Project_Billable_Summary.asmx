<%@ WebService Language="C#" Class="Project_Billable_Summary" %>

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
public class Project_Billable_Summary  : System.Web.Services.WebService {

    [WebMethod]
    public string OnPageLoad(int compid, string Projectid, string strdate, string enddate, string tstatus)
    {
        CultureInfo info = new CultureInfo("en-GB");
        CommonFunctions objComm = new CommonFunctions();
        DataSet ds = new DataSet();
        try
        {
            string fromdate = strdate != "" ? Convert.ToDateTime(strdate, info).ToString("MM/dd/yyyy") : null;
            string todate = enddate != "" ? Convert.ToDateTime(enddate, info).ToString("MM/dd/yyyy") : null;

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@selectedProjectid", Projectid);
            param[2] = new SqlParameter("@fromdate", fromdate);
            param[3] = new SqlParameter("@enddate", todate);
            param[4] = new SqlParameter("@Tstatus", tstatus);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "Usp_Get_Report_Data_Billable_Hours", param);

        }
        catch (Exception ex)
        {

        }
        return ds.GetXml();
    }

}