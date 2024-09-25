<%@ webservice language="C#" class="ExpenseSummary" %>

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
using Newtonsoft.Json;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ExpenseSummary : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");



    [WebMethod(EnableSession = true)]
    public string getCompanyExpenseMaster()
    {
        try
        {
            List<OPE_Master> objLocation = new List<OPE_Master>();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader((new CommonFunctions())._cnnString, CommandType.StoredProcedure, "usp_getCompanyExpenseMaster", param))
            {
                while (drrr.Read())
                {
                    objLocation.Add(new OPE_Master()
                    {
                        OpeId = (new CommonFunctions()).GetValue<int>(drrr["OpeId"].ToString()),
                        OPEName = (new CommonFunctions()).GetValue<string>(drrr["OPEName"].ToString()),
                    });
                }
            }
            return new JavaScriptSerializer().Serialize(objLocation as IEnumerable<OPE_Master>).ToString();
        }
        catch (Exception ex)
        {
            // MessageControl1.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
            return ex.Message;
        }
    }
    [WebMethod(EnableSession = true)]
    public string getCurrencyMaster()
    {
        try
        {
            List<tbl_Currency> objCurrency = new List<tbl_Currency>();
            using (SqlDataReader drrr = SqlHelper.ExecuteReader((new CommonFunctions())._cnnString, CommandType.StoredProcedure, "usp_getCurrencyMaster"))
            {
                while (drrr.Read())
                {
                    objCurrency.Add(new tbl_Currency()
                    {
                        Country = (new CommonFunctions()).GetValue<string>(drrr["Cntry"].ToString()),
                        Currency = (new CommonFunctions()).GetValue<string>(drrr["Currency"].ToString()),
                    });
                }
            }
            return new JavaScriptSerializer().Serialize(objCurrency as IEnumerable<tbl_Currency>).ToString();
        }
        catch (Exception ex)
        {
            // MessageControl1.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
            return ex.Message;
        }
    }


    [WebMethod(EnableSession = true)]
    public string GetSingleClientProjectExpenseRecords(string Sts, string filterType, string Srch, int pageIndex, int pageSize, string fromDate, string toDate,string staffcode,string sid, string Staffrole, int expType)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_InputsSummary> obj_Job = new List<vw_InputsSummary>();

        string stDate = fromDate != "" ? Convert.ToDateTime(fromDate).ToString("MM/dd/yyyy") : null;
        string edDate = toDate != "" ? Convert.ToDateTime(toDate).ToString("MM/dd/yyyy") : null;
        DataSet ds;
        if (Staffrole == "")
        {
            Staffrole = "Admin";
        }
        if (staffcode=="")
        {
            staffcode = "0";
        }
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[12];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@SearchType", filterType);
            param[2] = new SqlParameter("@srch", Srch);
            param[3] = new SqlParameter("@pageIndex", pageIndex);
            param[4] = new SqlParameter("@pageSize", pageSize);
            param[5] = new SqlParameter("@FromDate", stDate);
            param[6] = new SqlParameter("@ToDate", edDate);
            param[7] = new SqlParameter("@staffcode", staffcode);
            param[8] = new SqlParameter("@Sid", sid);
            param[9] = new SqlParameter("@staffrole", Staffrole);
            param[10] = new SqlParameter("@Sts", Sts);
            param[11] = new SqlParameter("@ExpType", expType);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_GetSingleClientProjectExpenseRecords", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        //IEnumerable<vw_InputsSummary> tbl = obj_Job as IEnumerable<vw_InputsSummary>;
        //var obbbbb = tbl;
        //return new JavaScriptSerializer().Serialize(tbl);

        return ds.GetXml();
    }

    [WebMethod(EnableSession = true)]
    public string GetSingleClientProjectInputHeader(string CLTId, string ProjectID)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_InputsSummaryHeader> obj_Job = new List<vw_InputsSummaryHeader>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@CLTId", CLTId);
            param[1] = new SqlParameter("@ProjectID", ProjectID);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GETProjectSummaryDetail", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_InputsSummaryHeader()
                    {

                        CLTId = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                        ProjectID = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        DeptName = objComm.GetValue<string>(drrr["Department_Name"].ToString()),
                        ScopeOfWork = objComm.GetValue<string>(drrr["ProductLine"].ToString()),
                        BudgetHours = objComm.GetValue<string>(drrr["BudgetHours"].ToString()),
                        TotalBilledHours = objComm.GetValue<string>(drrr["BillableHours"].ToString()),
                        ConsumePercentage = objComm.GetValue<double>(drrr["Percentage_Consume"].ToString()),
                        ProjectHours = objComm.GetValue<double>(drrr["Project_Hours"].ToString()),
                        ProjectCode = objComm.GetValue<string>(drrr["Project_Code"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_InputsSummaryHeader> tbl = obj_Job as IEnumerable<vw_InputsSummaryHeader>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    [WebMethod(EnableSession = true)]
    public string Bind_DrpClient(int compid, int staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<InputSummaryClient> obj_Job = new List<InputSummaryClient>();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", staffcode);
            using (SqlDataReader dr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_getClientByStaffCode", param))
            {
                while (dr.Read())
                {
                    obj_Job.Add(new InputSummaryClient()
                    {
                        ClientID = objComm.GetValue<int>(dr["ClientId"].ToString()),
                        ClientName = objComm.GetValue<string>(dr["ClientName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<InputSummaryClient> tbl = obj_Job as IEnumerable<InputSummaryClient>;
        var obbbbb = tbl;
        return JsonConvert.SerializeObject(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string Bind_DrpProject(int clientId, int staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<InputSummaryProject> obj_Job = new List<InputSummaryProject>();
        try
        {

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@clientId", clientId);
            param[1] = new SqlParameter("@staffcode", staffcode);

            using (SqlDataReader dr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_InputSummary_GetProjectData", param))
            {
                while (dr.Read())
                {
                    obj_Job.Add(new InputSummaryProject()
                    {
                        ProjectID = objComm.GetValue<int>(dr["ProjectID"].ToString()),
                        ProjectName = objComm.GetValue<string>(dr["ProjectName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<InputSummaryProject> tbl = obj_Job as IEnumerable<InputSummaryProject>;
        var obbbbb = tbl;
        return JsonConvert.SerializeObject(tbl);
    }


    [WebMethod(EnableSession = true)]
    public string GetInputSummaryByProjectIdAndDate(int InputId, int CLTId, int ProjectId, string receivedStrDate)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_ExpenseSummary> obj_Job = new List<vw_ExpenseSummary>();

        try
        {
            string receivedDate = receivedStrDate != "" ? Convert.ToDateTime(receivedStrDate, ci).ToString("MM/dd/yyyy") : null;
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@InputId", InputId);
            param[1] = new SqlParameter("@CLTId", CLTId);
            param[2] = new SqlParameter("@ProjectId", ProjectId);
            param[3] = new SqlParameter("@ReceivedDate", receivedDate);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetInputSummaryByProjectIDAndDate", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_ExpenseSummary()
                    {
                        Billable = objComm.GetValue<bool>(drrr["Billable"].ToString()),
                        ProjectID = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        ExpAutoId = objComm.GetValue<int>(drrr["ExpAutoId"].ToString()),
                        ExpNarration = objComm.GetValue<string>(drrr["ExpNarration"].ToString()),
                        Amt = objComm.GetValue<string>(drrr["Amt"].ToString()),
                        Currency = objComm.GetValue<string>(drrr["Currency"].ToString()),
                        EntryDate = objComm.GetValue<DateTime>(drrr["EntryDate"].ToString()),
                        EntryDateStr = objComm.GetValue<string>(drrr["EntryDate"].ToString()),
                        ProjectName= objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        ExpId = objComm.GetValue<int>(drrr["ExpId"].ToString()),
                        ExpType= objComm.GetValue<string>(drrr["ExpType"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_ExpenseSummary> tbl = obj_Job as IEnumerable<vw_ExpenseSummary>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string InsertUpdateExpenseSummary(int ExpAutoId, int ExpId, int ProjectId, string EntryDateStr, string ExpNarration, string Amt, string Currency, int billable, int staffcode, string FAT, string Mile)
    {

        bool isBillable = false;

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_InputsSummary> obj_Job = new List<vw_InputsSummary>();
        try
        {
            if (billable > 0)
            {
                isBillable = true;
            }
            string EntryDate = EntryDateStr != "" ? Convert.ToDateTime(EntryDateStr, ci).ToString("MM/dd/yyyy") : null;
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[12];
            param[0] = new SqlParameter("@ExpAutoId", ExpAutoId);
            param[1] = new SqlParameter("@ExpId", ExpId);
            param[2] = new SqlParameter("@ProjectId", ProjectId);
            param[3] = new SqlParameter("@EntryDate", EntryDate);
            param[4] = new SqlParameter("@ExpNarration", ExpNarration);
            param[5] = new SqlParameter("@Amt", Amt);
            param[6] = new SqlParameter("@Currency", Currency);
            param[7] = new SqlParameter("@CompId", Session["companyid"]);
            param[8] = new SqlParameter("@billable", isBillable);
            param[9] =new SqlParameter("@staffcode", staffcode);
            param[10] =new SqlParameter("@FAT", FAT);
            param[11] =new SqlParameter("@Mile", Mile);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateExpenseSummary", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_InputsSummary()
                    {
                        InputId = objComm.GetValue<int>(drrr["InputId"].ToString())

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_InputsSummary> tbl = obj_Job as IEnumerable<vw_InputsSummary>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string DeleteExpenseSummary(int ExpAutoId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_InputsSummary> obj_Job = new List<vw_InputsSummary>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@ExpAutoId", ExpAutoId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_DeleteExpenseSummary", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_InputsSummary()
                    {
                        InputId = objComm.GetValue<int>(drrr["inputId"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_InputsSummary> tbl = obj_Job as IEnumerable<vw_InputsSummary>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetClientRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnClientnStaff> obj_Job = new List<vw_JobnClientnStaff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetClient", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnClientnStaff()
                    {
                        TSId = objComm.GetValue<int>(drrr["sino"].ToString()),
                        stfBudChk = objComm.GetValue<string>(drrr["ClientCode"].ToString()),
                        Cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        ClientGroupName = objComm.GetValue<string>(drrr["ClientGroupName"].ToString()),
                        Departments = objComm.GetValue<string>(drrr["Country"].ToString()),
                        projectName = objComm.GetValue<string>(drrr["ContMob"].ToString()),
                        Billable = objComm.GetValue<string>(drrr["ContEmail"].ToString()),
                        Budgethours = objComm.GetValue<string>(drrr["ContPerson"].ToString()),
                        Jobid = objComm.GetValue<int>(drrr["CTGId"].ToString()),
                        projectid = objComm.GetValue<int>(drrr["prjcount"].ToString()),
                        StaffCode = objComm.GetValue<int>(drrr["staffcount"].ToString()),
                        UType = objComm.GetValue<string>(drrr["ClientRemark"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnClientnStaff> tbl = obj_Job as IEnumerable<vw_JobnClientnStaff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetClientDrp(string compid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Client> obj_Job = new List<tbl_Client>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetClientData", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_Client()
                    {

                        Cltid = objComm.GetValue<int>(drrr["ClientId"].ToString()),
                        Clientname = objComm.GetValue<string>(drrr["ClientName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Client> tbl = obj_Job as IEnumerable<tbl_Client>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string InsertUpdateClint(int compid, int cltid, string cltname, string hdnAllapp)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@cltname", cltname);
            param[3] = new SqlParameter("@hdnAllapp", hdnAllapp);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateCleint", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["cltid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod(EnableSession = true)]
    public string DeleteCleint(int compid, int cltid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@cltid", cltid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDeleteClient", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["cltid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetExpRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> obj_Job = new List<Expenses>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetExpense", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Expenses()
                    {
                        CompId = objComm.GetValue<int>(drrr["sino"].ToString()),
                        ExpenseId = objComm.GetValue<int>(drrr["OpeId"].ToString()),
                        ExpenseName = objComm.GetValue<string>(drrr["OPEName"].ToString()),
                        Tsid = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Expenses> tbl = obj_Job as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession = true)]
    public string DeleteExpense(int compid, int cltid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectActivity> obj_Job = new List<tbl_ProjectActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@expid", cltid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteExpense", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectActivity()
                    {
                        mjobid = objComm.GetValue<int>(drrr["Expid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectActivity> tbl = obj_Job as IEnumerable<tbl_ProjectActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetCltgrpRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ClientGroupMaster> obj_Job = new List<tbl_ClientGroupMaster>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetClientGrp", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ClientGroupMaster()
                    {
                        sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                        CgroupID = objComm.GetValue<int>(drrr["CTGId"].ToString()),
                        cGroupName = objComm.GetValue<string>(drrr["ClientGroupName"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["TotalCount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ClientGroupMaster> tbl = obj_Job as IEnumerable<tbl_ClientGroupMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetExpenseType()
    {
        CommonFunctions objComm = new CommonFunctions();
        DataSet ds;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_Exp_Type", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }
}