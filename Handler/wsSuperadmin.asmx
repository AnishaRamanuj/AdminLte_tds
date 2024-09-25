<%@ WebService Language="C#" Class="wsSuperadmin" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Data.SqlClient;
using CommonLibrary;
using System.Data;
using Microsoft.ApplicationBlocks.Data;
using System.Web.Script.Serialization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsSuperadmin  : System.Web.Services.WebService {

    [WebMethod]
    public string getCompany(string srch)
    {
        string result = "";
        CommonFunctions objComm = new CommonFunctions();
        List<SuperAdminCompany> obj_ts = new List<SuperAdminCompany>();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@srch", srch);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_companySuperadmin", param))
            {
                while (drrr.Read())
                {
                    obj_ts.Add(new SuperAdminCompany()
                    {
                        CompanyName = objComm.GetValue<string>(drrr["CompanyName"].ToString()),
                        AmcST = objComm.GetValue<string>(drrr["AmcST"].ToString()),
                        AmcEnd = objComm.GetValue<string>(drrr["AmcEnd"].ToString()),
                        Schemes = objComm.GetValue<string>(drrr["Schemes"].ToString()),
                        StaffCount = objComm.GetValue<int>(drrr["StaffCount"].ToString()),
                        Phone = objComm.GetValue<string>(drrr["Phone"].ToString()),
                        CompId = objComm.GetValue<int>(drrr["CompId"].ToString()),
                        ContactP = objComm.GetValue<string>(drrr["ContactP"].ToString()),
                        daysLeft = objComm.GetValue<int>(drrr["daysLeft"].ToString()),
                        VerType = objComm.GetValue<int>(drrr["VerType"].ToString()),
                        usr = objComm.GetValue<string>(drrr["usr"].ToString()),
                        pwd = objComm.GetValue<string>(drrr["pwd"].ToString()),                        
                    });
                }
            }

            IEnumerable<SuperAdminCompany> tbl = obj_ts as IEnumerable<SuperAdminCompany>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }


    [WebMethod]
    public string getCompanyDetails(int compid)
    {
        string result = "";
        CommonFunctions objComm = new CommonFunctions();
        List<SuperAdminCompanyDetails> obj_ts = new List<SuperAdminCompanyDetails>();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_companySuperadmin_details", param))
            {
                while (drrr.Read())
                {
                    obj_ts.Add(new SuperAdminCompanyDetails()
                    {////Phone, phone1, phone2, DailyThreshold , Max_hours, Future_Date, WeekStart, Leave_Year,NumberOfDaysRequireInWeek, @group_id 'Leave' , @page_id 'Leave_Type'
                        Phone = objComm.GetValue<string>(drrr["Phone"].ToString()),
                        phone1 = objComm.GetValue<string>(drrr["phone1"].ToString()),
                        phone2 = objComm.GetValue<string>(drrr["phone2"].ToString()),
                        Max_hours = objComm.GetValue<string>(drrr["Max_hours"].ToString()),
                        DailyThreshold = objComm.GetValue<string>(drrr["DailyThreshold"].ToString()),
                        Future_Date = objComm.GetValue<string>(drrr["Future_Date"].ToString()),
                        WeekStart = objComm.GetValue<int>(drrr["WeekStart"].ToString()),
                        Leave_Year = objComm.GetValue<string>(drrr["Leave_Year"].ToString()),
                        NumberOfDaysRequireInWeek = objComm.GetValue<int>(drrr["NumberOfDaysRequireInWeek"].ToString()),
                        Leave = objComm.GetValue<int>(drrr["Leave"].ToString()),
                        Leave_Type = objComm.GetValue<int>(drrr["Leave_Type"].ToString()),  
                        Email  = objComm.GetValue<string>(drrr["Email"].ToString()),  
                        Email1  = objComm.GetValue<string>(drrr["Email1"].ToString()),                  
                    });
                }
            }

            IEnumerable<SuperAdminCompanyDetails> tbl = obj_ts as IEnumerable<SuperAdminCompanyDetails>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }

    [WebMethod]
    public string SaveCompany(string rd)
    {
        string result = "";
        CommonFunctions objComm = new CommonFunctions();
        List<SuperAdminCompany> obj_ts = new List<SuperAdminCompany>();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@rd", rd);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_companySuperadmin_Save", param))
            {
                while (drrr.Read())
                {
                    obj_ts.Add(new SuperAdminCompany()
                    {
                        CompanyName = objComm.GetValue<string>(drrr["CompanyName"].ToString()),
                    });
                }
            }

            IEnumerable<SuperAdminCompany> tbl = obj_ts as IEnumerable<SuperAdminCompany>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }

}
    
