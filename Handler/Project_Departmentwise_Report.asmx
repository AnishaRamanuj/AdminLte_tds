<%@ WebService Language="C#" Class="Project_Departmentwise_Report" %>

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
public class Project_Departmentwise_Report : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]
    public string Get_Project_Dept_Staff_All_Selected(ProjectStaff currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            DateTime fromdate = Convert.ToDateTime(currobj.fromdate, ci);
            DateTime todate = Convert.ToDateTime(currobj.todate, ci);

            SqlParameter[] param = new SqlParameter[10];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@selecteddepid", currobj.selectedDeptid.TrimEnd(','));
            param[2] = new SqlParameter("@selectedStaffid", currobj.selectedstaffcode.TrimEnd(','));
            param[3] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
            param[4] = new SqlParameter("@neetdept", currobj.needDept);
            param[5] = new SqlParameter("@needStaff", currobj.needstaff);
            param[6] = new SqlParameter("@neetproject", currobj.needProject);
            param[7] = new SqlParameter("@FromDate", fromdate);
            param[8] = new SqlParameter("@Todate", todate);
            param[9] = new SqlParameter("@brid", currobj.BrId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_ProjectDepartment_detail", param))
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