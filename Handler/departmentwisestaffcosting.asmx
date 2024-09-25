<%@ WebService Language="C#" Class="departmentwisestaffcosting" %>
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
public class departmentwisestaffcosting  : System.Web.Services.WebService {
    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod(EnableSession=true)]
    public string Bind_Staff_Client_Project_Job_All_Selected(ReprotAllStaffCilentJob currobj)//int compid, string UserType, string status, string StaffCode)
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            if (Session["companyid"] != null)
            {
                DateTime fdate = Convert.ToDateTime(currobj.FromDate, ci);
                DateTime tdate = Convert.ToDateTime(currobj.ToDate, ci);
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[15];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
                param[2] = new SqlParameter("@selectedstaffcode", currobj.selectedstaffcode.TrimEnd(','));
                param[3] = new SqlParameter("@selectedclientid", currobj.selectedclientid.TrimEnd(','));
                param[4] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid);
                param[5] = new SqlParameter("@selecteddeptid", currobj.selecteddeptid);
                param[6] = new SqlParameter("@RType", currobj.RType);
                param[7] = new SqlParameter("@FromDate", Convert.ToDateTime(currobj.FromDate, ci));
                param[8] = new SqlParameter("@ToDate", Convert.ToDateTime(currobj.ToDate, ci));

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(NEwsqlConn, CommandType.StoredProcedure, "usp_Selection_ClientProjectdeptStaff", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new tbl_StaffMaster()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                            Type = objComm.GetValue<string>(drrr["type"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
}