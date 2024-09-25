<%@ WebService Language="C#" Class="Staff_WorkingPercentage_Report" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Data.SqlClient;
using CommonLibrary;
using System.Data;
using Microsoft.ApplicationBlocks.Data;
using System.Globalization;
using System.Web.Script.Serialization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Staff_WorkingPercentage_Report : System.Web.Services.WebService
{

    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]
    public string Get_Dept_Staff_All_Selected(ProjectStaff currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {

            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@selecteddepid", currobj.selectedDeptid.TrimEnd(','));
            param[2] = new SqlParameter("@neetdept", currobj.needDept);
            param[3] = new SqlParameter("@needStaff", currobj.needstaff);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_DepartmentStaff_Resource", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}