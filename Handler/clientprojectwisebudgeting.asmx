<%@ WebService Language="C#" Class="clientprojectwisebudgeting" %>

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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class clientprojectwisebudgeting  : System.Web.Services.WebService {
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]
    public string getclientprojectwisebudgeting(projectwisebudgeting currentobj)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();
        try {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", currentobj.compid);
            param[1] = new SqlParameter("@cltid", currentobj.cltid.TrimEnd(','));
            param[2] = new SqlParameter("@from", Convert.ToDateTime(currentobj.from, ci));
            param[3] = new SqlParameter("@to", Convert.ToDateTime(currentobj.to, ci));
            param[4] = new SqlParameter("@projectid", currentobj.projectid.TrimEnd(','));
            using (SqlDataReader drrrr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_getclientprojectwisebudgeting", param))
            {
                while (drrrr.Read())
                {
                    List_SM.Add(new tbl_StaffMaster()
                    {
                        StaffCode = objComm.GetValue<int>(drrrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrrr["type"].ToString())
                    });
                }
            }
            
        }
        catch (Exception ex)
        { throw ex; }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    
}