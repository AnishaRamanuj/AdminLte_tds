<%@ WebService Language="C#" Class="AdherenceReport" %>

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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class AdherenceReport : System.Web.Services.WebService
{
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    [WebMethod(EnableSession=true)]
    public string GetAdherenceReport(string searchMonth, string withoutHolidaysFlag)
    {
        List<Adherence_Report> obj_Job = new List<Adherence_Report>();
        string monthDate = searchMonth != "" ? Convert.ToDateTime(searchMonth).ToString("MM/dd/yyyy") : null;
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@CompId", Session["companyid"]);
                param[1] = new SqlParameter("@Searchdate", monthDate);
                param[2] = new SqlParameter("@WithoutHolidaysFlag", withoutHolidaysFlag);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstarp_Adherence_Report", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new Adherence_Report()
                        {
                            DeptName = objComm.GetValue<string>(drrr["DeptName"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                            Week1 = objComm.GetValue<int>(drrr["1"].ToString()),
                            Week2 = objComm.GetValue<int>(drrr["2"].ToString()),
                            Week3 = objComm.GetValue<int>(drrr["3"].ToString()),
                            Week4 = objComm.GetValue<int>(drrr["4"].ToString()),
                            Week5 = (HasColumn(drrr, "5") == false || drrr["5"] == null) ? 0 : objComm.GetValue<int>(drrr["5"].ToString()),
                            Week6 = (HasColumn(drrr, "6") == false || drrr["6"] == null) ? 0 : objComm.GetValue<int>(drrr["6"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(obj_Job);
    }

    public bool HasColumn(IDataRecord dr, string columnName)
    {
        for (int i = 0; i < dr.FieldCount; i++)
        {
            if (dr.GetName(i).Equals(columnName, StringComparison.InvariantCultureIgnoreCase))
                return true;
        }
        return false;
    }
}