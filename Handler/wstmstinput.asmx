<%@ WebService Language="C#" Class="wstmstinput" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;
using System.Globalization;
using System.Web.Configuration.Common;
using System.Data.Common;
using System.Collections.Generic;
using CommonLibrary;
using Microsoft.ApplicationBlocks1.Data;
using System.Web.Script.Serialization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class wstmstinput  : System.Web.Services.WebService {

    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]
    public string timesheetlogindetails(int compid,int StaffCode) {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
       
        List<tbl_JobMaster> obj_client = new List<tbl_JobMaster>();
        try {
            
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
        
            param[1] = new SqlParameter("@StaffCode", StaffCode);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_getclients", param))
            { 
             while (drrr.Read())
             {
                 obj_client.Add(new tbl_JobMaster()
                 {
                     cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                     ClientName = objComm.GetValue<string>(drrr["clientname"].ToString())
                 });
             }
            }
        }
            catch(Exception e)
        {
            throw e;
        }
        IEnumerable<tbl_JobMaster> tbl = obj_client as IEnumerable<tbl_JobMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string bindproject(int compid, int cltid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_JobMaster> obj_project = new List<tbl_JobMaster>();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid",cltid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_bindproject", param))
                while (drrr.Read())
                {
                    obj_project.Add(new tbl_JobMaster()
                    {
                        projectid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        projectname = objComm.GetValue<string>(drrr["ProjectName"].ToString())
                    });
                
                    
                }
            
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_JobMaster> tbl = obj_project as IEnumerable<tbl_JobMaster>;
        var object1 = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
            }

    public string bindproject(int compid, int cltid,int projectid,int staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_JobMaster> obj_project = new List<tbl_JobMaster>();
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@projectid", projectid);
            param[3] = new SqlParameter("@staffcode", staffcode);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_bindjob", param))
                while (drrr.Read())
                {
                    obj_project.Add(new tbl_JobMaster()
                    {
                        projectid = objComm.GetValue<int>(drrr["MJobId"].ToString()),
                        projectname = objComm.GetValue<string>(drrr["MJobName"].ToString())
                    });


                }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_JobMaster> tbl = obj_project as IEnumerable<tbl_JobMaster>;
        var object1 = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
}
    [WebMethod]
    public string bindjobdetails(int jobid, int staffcode, int compid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_JobMaster> obj_satffjobdetail = new List<tbl_JobMaster>();
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@mjobid", jobid);
            param[2] = new SqlParameter("@staffcode", staffcode);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_bindjobdetails", param))
                while (drrr.Read())
                {
                    obj_satffjobdetail.Add(new tbl_JobMaster()
                    {
                        superApp = objComm.GetValue<string>(drrr["Supappr"].ToString()),
                        Approver=objComm.GetValue<string>(drrr["topappr"]),
                        startDT=objComm.GetValue<string>(drrr["createdate"]), 
                        endDT=objComm.GetValue<string>(drrr["enddate"]),
                        spendhours=objComm.GetValue<int>(drrr["spendhours"]),
                        totalbudhours=objComm.GetValue<int>(drrr["BudHours"]),
                        actualhours=objComm.GetValue<int>(drrr["budgethours"]),
                        balancehours = (objComm.GetValue<int>(drrr["budgethours"]) - objComm.GetValue<int>(drrr["spendhours"]))
                    
                    });


                }
            
        }

        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_JobMaster> tbl = obj_satffjobdetail as IEnumerable<tbl_JobMaster>;
        var object1 = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    
    
    
}