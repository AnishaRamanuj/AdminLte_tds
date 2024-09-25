<%@ WebService Language="C#" Class="Finance_Budgeting" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.ApplicationBlocks1.Data;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;
using CommonLibrary;
using System.Web.Script.Serialization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Finance_Budgeting  : System.Web.Services.WebService {
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

    [WebMethod]
    public string Get_Finance_Budegeting_clientName(int Compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Finance_Budgeting> objtbl = new List<tbl_Finance_Budgeting>();
        string Results = "";
        try {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Compid);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Finance_Budegeting_clientName", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Finance_Budgeting {
                        CltId = objComm.GetValue<int>(sdr["CLTId"].ToString()),
                        ClientName = objComm.GetValue<string>(sdr["ClientName"].ToString()),
                    });
                }
            }

            IEnumerable<tbl_Finance_Budgeting> tbl = objtbl as IEnumerable<tbl_Finance_Budgeting>;
            Results = new JavaScriptSerializer().Serialize(tbl);
            return Results;
        }
        catch(Exception ex){
        return null;
        }
    }

    [WebMethod]
    public string Save_Finance_Budgeting_ProjectDetails(int Compid,int Cltid,int ProjectId,string PreUsedAmt,string PreUsedHrs,string BudAmt,string BuffAmt,string BudHrs,string BuffHrs)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Finance_Budgeting> objtbl = new List<tbl_Finance_Budgeting>();
        string Results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@Cltid", Cltid);
            param[2] = new SqlParameter("@ProjectId", ProjectId);
            param[3] = new SqlParameter("@PreUsedAmt", PreUsedAmt);
            param[4] = new SqlParameter("@PreUsedHrs", PreUsedHrs);
            param[5] = new SqlParameter("@BudAmt", BudAmt);
            param[6] = new SqlParameter("@BuffAmt", BuffAmt);
            param[7] = new SqlParameter("@BudHrs", BudHrs);
            param[8] = new SqlParameter("@BuffHrs", BuffHrs);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Finance_Budgeting_ProjectDetails", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Finance_Budgeting
                    {
                        CltId = objComm.GetValue<int>(sdr["jobid"].ToString()),
                    });
                }
            }

            IEnumerable<tbl_Finance_Budgeting> tbl = objtbl as IEnumerable<tbl_Finance_Budgeting>;
            Results = new JavaScriptSerializer().Serialize(tbl);
            return Results;
        }
        catch (Exception ex)
        {
            return null;
        }
    }



    [WebMethod]
    public string Save_Finance_Budgeting_BudgetAmount(int Compid, int Cltid, int ProjectId, string BudDate, string BudAmt, string Budhrs, int BudId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Finance_Budgeting> objtbl = new List<tbl_Finance_Budgeting>();
        string Results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@Cltid", Cltid);
            param[2] = new SqlParameter("@ProjectId", ProjectId);
            param[3] = new SqlParameter("@BudDate", BudDate);
            param[4] = new SqlParameter("@BudAmt", BudAmt);
            param[5] = new SqlParameter("@Budhrs", Budhrs);
            param[6] = new SqlParameter("@BudId", BudId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Finance_Budgeting_BudgetAmount", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Finance_Budgeting
                    {
                        CltId = objComm.GetValue<int>(sdr["jobid"].ToString()),
                    });
                }
            }

            IEnumerable<tbl_Finance_Budgeting> tbl = objtbl as IEnumerable<tbl_Finance_Budgeting>;
            Results = new JavaScriptSerializer().Serialize(tbl);
            return Results;
        }
        catch (Exception ex)
        {
            return null;
        }
    }



    [WebMethod]
    public string Save_Finance_Budgeting_EndDate(int Compid, int Cltid, int ProjectId, string EndDate)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Finance_Budgeting> objtbl = new List<tbl_Finance_Budgeting>();
        string Results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@Cltid", Cltid);
            param[2] = new SqlParameter("@ProjectId", ProjectId);
            param[3] = new SqlParameter("@EndDate", EndDate);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Save_Finance_Budgeting_EndDate", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Finance_Budgeting
                    {
                        CltId = objComm.GetValue<int>(sdr["JobId"].ToString()),
                    });
                }
            }

            IEnumerable<tbl_Finance_Budgeting> tbl = objtbl as IEnumerable<tbl_Finance_Budgeting>;
            Results = new JavaScriptSerializer().Serialize(tbl);
            return Results;
        }
        catch (Exception ex)
        {
            return null;
        }
    }
    

    [WebMethod]
    public string Get_Finance_Budegeting_ProjectName(int Compid ,int Cltid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Finance_Budgeting> objtbl = new List<tbl_Finance_Budgeting>();
        string Results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@Cltid", Cltid);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Finance_Budegeting_ProjectName", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Finance_Budgeting
                    {
                        ProjectID = objComm.GetValue<int>(sdr["ProjectID"].ToString()),
                        ProjectName = objComm.GetValue<string>(sdr["ProjectName"].ToString()),
                    });
                }
            }

            IEnumerable<tbl_Finance_Budgeting> tbl = objtbl as IEnumerable<tbl_Finance_Budgeting>;
            Results = new JavaScriptSerializer().Serialize(tbl);
            return Results;
        }
        catch (Exception ex)
        {
            return null;
        }
    }



    [WebMethod]
    public string Get_Finance_Budgeting_ProjectDetails(int Compid, int Cltid, int ProjectId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Finance_Budgeting> objtbl = new List<tbl_Finance_Budgeting>();
        string Results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@Cltid", Cltid);
            param[2] = new SqlParameter("@ProjectId", ProjectId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Finance_Budgeting_ProjectDetails", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Finance_Budgeting
                    {
                        StartDate = objComm.GetValue<string>(sdr["CreationDate"].ToString()),
                        EndDate = objComm.GetValue<string>(sdr["ActualJobEndate"].ToString()),
                        PreAmtUsed = objComm.GetValue<string>(sdr["Pre_AmountUsed"].ToString()),
                        PreHrsUsed = objComm.GetValue<string>(sdr["Pre_HoursUsed"].ToString()),
                        ProjectAmount = objComm.GetValue<string>(sdr["Project_Amount"].ToString()),
                        ProjectHours = objComm.GetValue<string>(sdr["Project_Hours"].ToString()),
                        Budget_Amt = objComm.GetValue<string>(sdr["BudgetAmount"].ToString()),
                        Buffer_Amt = objComm.GetValue<string>(sdr["BufferAmount"].ToString()),
                        Budget_Hrs = objComm.GetValue<string>(sdr["BudgetHours"].ToString()),
                        Buffer_Hrs = objComm.GetValue<string>(sdr["BufferHours"].ToString()),
                       
                    });
                }
            }

            IEnumerable<tbl_Finance_Budgeting> tbl = objtbl as IEnumerable<tbl_Finance_Budgeting>;
            Results = new JavaScriptSerializer().Serialize(tbl);
            return Results;
        }
        catch (Exception ex)
        {
            return null;
        }
    }







    [WebMethod]
    public string Get_Finance_Budgeting_BudgetDetails(int Compid, int Cltid, int ProjectId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Finance_Budgeting> objtbl = new List<tbl_Finance_Budgeting>();
        string Results = "";
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@Compid", Compid);
            param[1] = new SqlParameter("@Cltid", Cltid);
            param[2] = new SqlParameter("@ProjectId", ProjectId);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Get_Finance_Budgeting_BudgetDetails", param))
            {
                while (sdr.Read())
                {
                    objtbl.Add(new tbl_Finance_Budgeting
                    {
                        sino = objComm.GetValue<int>(sdr["sino"].ToString()),
                        FinBudId = objComm.GetValue<int>(sdr["FDetails_Id"].ToString()),
                        StartDate = objComm.GetValue<string>(sdr["FromDate"].ToString()),
                        EndDate = objComm.GetValue<string>(sdr["ToDate"].ToString()),

                        Budget_Amt = objComm.GetValue<string>(sdr["BudAmt"].ToString()),

                        Budget_Hrs = objComm.GetValue<string>(sdr["Budhours"].ToString()),
                        

                    });
                }
            }

            IEnumerable<tbl_Finance_Budgeting> tbl = objtbl as IEnumerable<tbl_Finance_Budgeting>;
            Results = new JavaScriptSerializer().Serialize(tbl);
            return Results;
        }
        catch (Exception ex)
        {
            return null;
        }
    }


    [WebMethod]

    public string Delete_Finance_Budegeting(int Compid, int FinBudId, string BudHrs, string BudAmt)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Finance_Budgeting> objtbl = new List<tbl_Finance_Budgeting>();
        string Results = "";
        try {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@FinBudId", FinBudId);
            param[2] = new SqlParameter("@BudHrs", BudHrs);
            param[3] = new SqlParameter("@BudAmt", BudAmt);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(conn, CommandType.StoredProcedure, "usp_Delete_Finance_Budegeting", param))
            {
                while (sdr.Read()) {
                    objtbl.Add(new tbl_Finance_Budgeting { 
                    Message=objComm.GetValue<string>(sdr["msg"].ToString()),
                    });
                }
            }
            IEnumerable<tbl_Finance_Budgeting> tbl = objtbl as IEnumerable<tbl_Finance_Budgeting>;
            Results = new JavaScriptSerializer().Serialize(tbl);
            return Results;
        }
        
        catch(Exception ex){
            Results = ex.Message;
        }
        return Results;
    }
    
}