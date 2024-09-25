<%@ WebService Language="C#" Class="wsProjectBudgetingEdit" %>

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
using JTMSProject;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsProjectBudgetingEdit : System.Web.Services.WebService
{

    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]
    public string bind_Client(string compid)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<ProjectWiseBudgeting> objclt = new List<ProjectWiseBudgeting>();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_get_clients", param))
            {
                while (sdr.Read())
                {
                    objclt.Add(new ProjectWiseBudgeting
                    {
                        cltid = objcomm.GetValue<int>(sdr["CLTId"].ToString()),
                        clientname = objcomm.GetValue<string>(sdr["clientname"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<ProjectWiseBudgeting> tbl = objclt as IEnumerable<ProjectWiseBudgeting>;

        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod]
    public string Bind_job(string compid, string cltid)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<ProjectWiseBudgeting> objjob = new List<ProjectWiseBudgeting>();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_get_jobs", param))
            {
                while (sdr.Read())
                {
                    objjob.Add(new ProjectWiseBudgeting
                    {
                        mjobid = objcomm.GetValue<int>(sdr["mjobid"].ToString()),
                        MJobName = objcomm.GetValue<string>(sdr["MJobName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<ProjectWiseBudgeting> tbl = objjob as IEnumerable<ProjectWiseBudgeting>;

        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string get_editable_Budgetdata(string compid, string cltid, string mjobid, string PageIndex, string PageSize)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<ProjectWiseBudgeting> objjob = new List<ProjectWiseBudgeting>();
        DataSet ds = new DataSet();
        try {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", Convert.ToInt32(cltid));
            param[2] = new SqlParameter("@mjobid", Convert.ToInt32(mjobid));
            param[3] = new SqlParameter("@PageIndex", PageIndex);
            param[4] = new SqlParameter("@PageSize", PageSize);
            ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_get_editable_Budgetdata", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }
    [WebMethod]
    public void savejobbudget(string compid, string jobid, string newBudAmt, string newBudHours, string newtxtOtherAmt, string newCalendarDate1, string bid)
    {
        try
        {
            
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", jobid);
            param[2] = new SqlParameter("@newBudAmt", newBudAmt);
            param[3] = new SqlParameter("@newBudHours", newBudHours);
            param[4] = new SqlParameter("@newtxtOtherAmt", newtxtOtherAmt);
            param[5] = new SqlParameter("@newCalendarDate1", newCalendarDate1);
            param[6] = new SqlParameter("@bid", bid);
            SqlHelper.ExecuteNonQuery(sqlConn, CommandType.StoredProcedure, "usp_savejobbudget", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    
}