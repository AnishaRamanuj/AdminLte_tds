<%@ WebService Language="C#" Class="Project_Budgeting_Edit" %>
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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class Project_Budgeting_Edit  : System.Web.Services.WebService {

    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]
    public string Get_Project_Budgeting_Edit_client_Job(int Compid, int CltId)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        List<tbl_Project_Budgeting_Edit> listBud = new List<tbl_Project_Budgeting_Edit>();

        try {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@CltId", CltId);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Get_Project_Budgeting_Edit_client_Job", param))
            {
                while (drrr.Read())
                {
                    listBud.Add(new tbl_Project_Budgeting_Edit()
                    {
                        ID = objComm.GetValue<int>(drrr["ID"].ToString()),
                        Name = objComm.GetValue<string>(drrr["Name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["Type"].ToString())
                    });
                }
            }
        }
        catch(Exception ex){
            return null;
        }
        IEnumerable<tbl_Project_Budgeting_Edit> tbl = listBud as IEnumerable<tbl_Project_Budgeting_Edit>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
        
    }
    
    
    
    
    ///////////////////////////////////////get budgeting data

    [WebMethod]
    public string Get_Project_Budgeting_Edit_BudgetDetails(int Compid, int CltId, int JobId, int PageIndex, int PageSize)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        List<tbl_Project_Budgeting_Edit> listBud = new List<tbl_Project_Budgeting_Edit>();

        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@CltId", CltId);
            param[2] = new SqlParameter("@JobId", JobId);
            param[3] = new SqlParameter("@PageIndex", PageIndex);
            param[4] = new SqlParameter("@PageSize", PageSize);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Get_Project_Budgeting_Edit_BudgetDetails", param))
            {
                while (sdr.Read())
                {
                    listBud.Add(new tbl_Project_Budgeting_Edit()
                    {
                        Bud_ID = objComm.GetValue<int>(sdr["Budget_Master_id"].ToString()),
                        JobId = objComm.GetValue<int>(sdr["JobId"].ToString()),
                        ClientName = objComm.GetValue<string>(sdr["clientname"].ToString()),
                        JobName = objComm.GetValue<string>(sdr["MJobName"].ToString()),
                        FromDate = objComm.GetValue<string>(sdr["FromDate"].ToString()),
                        Bud_Amount = objComm.GetValue<string>(sdr["BudAmt"].ToString()),
                        Bud_Hours = objComm.GetValue<string>(sdr["BudHours"].ToString()),
                        Other_Amount = objComm.GetValue<string>(sdr["OtherAmt"].ToString()),
                        Tcount = objComm.GetValue<int>(sdr["Tcount"].ToString()),
                    });
                    
                }
                sdr.Close();
            }
        }
        catch (Exception ex)
        {
            return null;
        }
        IEnumerable<tbl_Project_Budgeting_Edit> tbl = listBud as IEnumerable<tbl_Project_Budgeting_Edit>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }
    
    
    ////////////////////////////////save budgeting

    [WebMethod]
    public string SaveBudget(int Compid ,int BudId,int JobId,string NewDate,string NewBudAmt,string NewBudHrs,string NewOtherAmt) {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        List<tbl_Project_Budgeting_Edit> listBud = new List<tbl_Project_Budgeting_Edit>();

        try {
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@BudId", BudId);
            param[2] = new SqlParameter("@JobId", JobId);
            param[3] = new SqlParameter("@NewDate", NewDate);
            param[4] = new SqlParameter("@NewBudAmt", NewBudAmt);
            param[5] = new SqlParameter("@NewBudHrs", NewBudHrs);
            param[6] = new SqlParameter("@NewOtherAmt", NewOtherAmt);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Save_Project_Budgeting_Edit_BudgetDetails", param))
            {
                while (sdr.Read())
                {
                    listBud.Add(new tbl_Project_Budgeting_Edit()
                    {
                        Bud_ID = objComm.GetValue<int>(sdr["Budget_Master_id"].ToString()),
                    });
                }
            }
        }

        catch (Exception ex) {
            return ex.ToString();
        }
        IEnumerable<tbl_Project_Budgeting_Edit> tbl = listBud as IEnumerable<tbl_Project_Budgeting_Edit>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    
}