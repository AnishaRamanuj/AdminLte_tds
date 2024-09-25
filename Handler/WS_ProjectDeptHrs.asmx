<%@ WebService Language="C#" Class="WS_ProjectDeptHrs" %>

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
public class WS_ProjectDeptHrs : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]
    public string Get_Project_Dept(ProjectDept_hrs currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<ProjectDept_hrs> List_SM = new List<ProjectDept_hrs>();
        try
        {
            DateTime strdate = Convert.ToDateTime(currobj.Fromdate, ci);
            DateTime enddate = Convert.ToDateTime(currobj.Todate, ci);

            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@SelectedProjectid", currobj.selectedProjectid.TrimEnd(','));
            param[2] = new SqlParameter("@Fdate", strdate);
            param[3] = new SqlParameter("@Tdate", enddate);
            param[4] = new SqlParameter("@Rtype", currobj.Rtype);
            param[5] = new SqlParameter("@needProject", currobj.needProject);
            param[6] = new SqlParameter("@needDept", currobj.needDept);
            param[7] = new SqlParameter("@Status", currobj.Status);
            param[8] = new SqlParameter("@Type", currobj.btype);

            DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Project_Dept_Data", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Project_Dept_Data", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new ProjectDept_hrs()
                    {
                        id = objComm.GetValue<int>(drrr["id"].ToString()),
                        Name = objComm.GetValue<string>(drrr["name"].ToString()),
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
        IEnumerable<ProjectDept_hrs> tbl = List_SM as IEnumerable<ProjectDept_hrs>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}