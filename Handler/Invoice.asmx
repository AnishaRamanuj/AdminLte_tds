<%@ WebService Language="C#" Class="Invoice" %>

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

public class Invoice : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]
    public string BindClient(int compid, string datec)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_job_ts> List_DS = new List<tbl_job_ts>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@datec", datec);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetClient_invoice", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_job_ts()
                    {
                        CLTId = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_job_ts> tbl = List_DS as IEnumerable<tbl_job_ts>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string BindProject(int compid, string datec, int cltid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_job_ts> List_DS = new List<tbl_job_ts>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@datec", datec);
            param[2] = new SqlParameter("@cltid", cltid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetProject_invoice", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_job_ts()
                    {
                        ProjectID = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_job_ts> tbl = List_DS as IEnumerable<tbl_job_ts>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string BindTimesheet(int compid, string Billed, int cltid, int projectid, string fromdt, string todatee)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<AllTimesheetModel2> List_DS = new List<AllTimesheetModel2>();
        string fromdate = fromdt != "" ? Convert.ToDateTime(fromdt, ci).ToString("MM/dd/yyyy") : null;
        string todate = todatee != "" ? Convert.ToDateTime(todatee, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@projectid", projectid);
            param[3] = new SqlParameter("@fromdate", fromdate);
            param[4] = new SqlParameter("@todate", todate);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Timesheet_Invoice", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new AllTimesheetModel2()
                    {
                        SID = objComm.GetValue<int>(drrr["sino"].ToString()),
                        TSId = objComm.GetValue<int>(drrr["tsid"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["Staffname"].ToString()),
                        mJobName = objComm.GetValue<string>(drrr["mjobname"].ToString()),
                        Date = objComm.GetValue<string>(drrr["tdate"].ToString()),
                        BudHours = objComm.GetValue<string>(drrr["TotalTime"].ToString()),
                        BudAmt = objComm.GetValue<string>(drrr["HourlyCharges"].ToString()),
                        Hod = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<AllTimesheetModel2> tbl = List_DS as IEnumerable<AllTimesheetModel2>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string BindCurrency(int compid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Currency> List_DS = new List<tbl_Currency>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[0];


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_getCurrency", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Currency()
                    {
                        Currency = objComm.GetValue<string>(drrr["Currency"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Currency> tbl = List_DS as IEnumerable<tbl_Currency>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Insert_Invoice(int compid, string InvoiceNo, string DueDate, string InvDate, string Fromdt, string Todt, int Cltid, int Projectid, string Curr, string AllTSID, string Hours, string Amt, string AllExpid, string Inv, string InvTax, string Exp, string ExpTax)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<timesheet_table> List_DS = new List<timesheet_table>();

        string fromdate = Fromdt != "" ? Convert.ToDateTime(Fromdt, ci).ToString("MM/dd/yyyy") : null;
        string todate = Todt != "" ? Convert.ToDateTime(Todt, ci).ToString("MM/dd/yyyy") : null;

        string DueDt = DueDate != "" ? Convert.ToDateTime(DueDate, ci).ToString("MM/dd/yyyy") : null;
        string InvDt = InvDate != "" ? Convert.ToDateTime(InvDate, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[17];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@InvoiceNo", InvoiceNo);
            param[2] = new SqlParameter("@DueDt", DueDt);
            param[3] = new SqlParameter("@InvDt", InvDt);
            param[4] = new SqlParameter("@fromdate", fromdate);
            param[5] = new SqlParameter("@todate", todate);
            param[6] = new SqlParameter("@Cltid", Cltid);
            param[7] = new SqlParameter("@Projectid", Projectid);
            param[8] = new SqlParameter("@Curr", Curr);
            param[9] = new SqlParameter("@AllTSID", AllTSID);
            param[10] = new SqlParameter("@Hours", Hours);
            param[11] = new SqlParameter("@Amt", Amt);
            param[12] = new SqlParameter("@AllExpid", AllExpid);
            param[13] = new SqlParameter("@Inv", Inv);
            param[14] = new SqlParameter("@InvTax", InvTax);
            param[15] = new SqlParameter("@Exp", Exp);
            param[16] = new SqlParameter("@ExpTax", ExpTax);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Insert_Invoice", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new timesheet_table()
                    {
                        TSId = objComm.GetValue<int>(drrr["Invid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<timesheet_table> tbl = List_DS as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Get_Invoice(int compid, string srch, string drpsrch, string drpinv, int pageindex, int pagesize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Invoice> List_DS = new List<tbl_Invoice>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Srch", srch);
            param[2] = new SqlParameter("@drpSrch", drpsrch);
            param[3] = new SqlParameter("@drpinv", drpinv);
            param[4] = new SqlParameter("@pageindex", pageindex);
            param[5] = new SqlParameter("@pagesize", pagesize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Invoice", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Invoice()
                    {
                        sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                        InvId = objComm.GetValue<int>(drrr["InvoiceId"].ToString()),
                        InvNo = objComm.GetValue<string>(drrr["InvoiceNo"].ToString()),
                        InvDt = objComm.GetValue<string>(drrr["Invoice_Dt"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        Charges = objComm.GetValue<string>(drrr["Charges"].ToString()),
                        Receipt = objComm.GetValue<string>(drrr["Receipt"].ToString()),
                        Balance = objComm.GetValue<string>(drrr["Balance"].ToString()),
                        Tcount = objComm.GetValue<int>(drrr["Tcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Invoice> tbl = List_DS as IEnumerable<tbl_Invoice>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Get_EditInvoice(int compid, int InvId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Invoice> List_DS = new List<tbl_Invoice>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@invid", InvId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Edit_Invoice", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Invoice()
                    {
                        cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                        projectid = objComm.GetValue<int>(drrr["Project_Id"].ToString()),
                        Due_date = objComm.GetValue<string>(drrr["Due_Date"].ToString()),
                        from_date = objComm.GetValue<string>(drrr["From_Dt"].ToString()),
                        to_date = objComm.GetValue<string>(drrr["To_Dt"].ToString()),
                        Hrs = objComm.GetValue<string>(drrr["Hours"].ToString()),
                        Charges = objComm.GetValue<string>(drrr["Net_Invoice"].ToString()),
                        InvAmt = objComm.GetValue<string>(drrr["Invoice_Amt"].ToString()),
                        Invtax = objComm.GetValue<string>(drrr["Invoice_TAX"].ToString()),
                        Exp = objComm.GetValue<string>(drrr["Exp_Amt"].ToString()),
                        Exptax = objComm.GetValue<string>(drrr["Exp_TAX"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Invoice> tbl = List_DS as IEnumerable<tbl_Invoice>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Update_Invoice(int compid, string InvoiceNo, string DueDate, string InvDate, string Fromdt, string Todt, int Cltid, int Projectid, string Curr, string AllTSID, string Hours, string Amt, int Invoiceid,string AllExpid, string Inv, string InvTax, string Exp, string ExpTax)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<timesheet_table> List_DS = new List<timesheet_table>();

        string fromdate = Fromdt != "" ? Convert.ToDateTime(Fromdt, ci).ToString("MM/dd/yyyy") : null;
        string todate = Todt != "" ? Convert.ToDateTime(Todt, ci).ToString("MM/dd/yyyy") : null;

        string DueDt = DueDate != "" ? Convert.ToDateTime(DueDate, ci).ToString("MM/dd/yyyy") : null;
        string InvDt = InvDate != "" ? Convert.ToDateTime(InvDate, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[18];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@InvoiceNo", InvoiceNo);
            param[2] = new SqlParameter("@DueDt", DueDt);
            param[3] = new SqlParameter("@InvDt", InvDt);
            param[4] = new SqlParameter("@fromdate", fromdate);
            param[5] = new SqlParameter("@todate", todate);
            param[6] = new SqlParameter("@Cltid", Cltid);
            param[7] = new SqlParameter("@Projectid", Projectid);
            param[8] = new SqlParameter("@Curr", Curr);
            param[9] = new SqlParameter("@AllTSID", AllTSID);
            param[10] = new SqlParameter("@Hours", Hours);
            param[11] = new SqlParameter("@Amt", Amt);
            param[12] = new SqlParameter("@Invid", Invoiceid);
            param[13] = new SqlParameter("@Inv", Inv);
            param[14] = new SqlParameter("@InvTax", InvTax);
            param[15] = new SqlParameter("@Exp", Exp);
            param[16] = new SqlParameter("@ExpTax", ExpTax);
            param[17] = new SqlParameter("@AllExpid", AllExpid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Update_Invoice", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new timesheet_table()
                    {
                        TSId = objComm.GetValue<int>(drrr["Invid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<timesheet_table> tbl = List_DS as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetRecptInv(int compid, int cltid, int Recptid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Invoice> List_DS = new List<tbl_Invoice>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@recpt", Recptid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Receipt_Invoice", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Invoice()
                    {
                        sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                        InvId = objComm.GetValue<int>(drrr["InvoiceId"].ToString()),
                        InvNo = objComm.GetValue<string>(drrr["InvoiceNo"].ToString()),
                        InvDt = objComm.GetValue<string>(drrr["Invoice_Dt"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        Charges = objComm.GetValue<string>(drrr["Net_Invoice"].ToString()),
                        Balance = objComm.GetValue<string>(drrr["Balance"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Invoice> tbl = List_DS as IEnumerable<tbl_Invoice>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Insert_Receipt(int compid, string ReceiptNo, string ReceiptDt, string Narra, string MOP, int Cltid, string RecptAmt, string InvoiceAmt, int Invid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<timesheet_table> List_DS = new List<timesheet_table>();

        string rcpdt = ReceiptDt != "" ? Convert.ToDateTime(ReceiptDt, ci).ToString("MM/dd/yyyy") : null;

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@ReceiptNo", ReceiptNo);
            param[2] = new SqlParameter("@rcpdt", rcpdt);
            param[3] = new SqlParameter("@Narra", Narra);
            param[4] = new SqlParameter("@MOP", MOP);
            param[5] = new SqlParameter("@Cltid", Cltid);
            param[6] = new SqlParameter("@RecptAmt", RecptAmt);
            param[7] = new SqlParameter("@InvoiceAmt", InvoiceAmt);
            param[8] = new SqlParameter("@Invid", Invid);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Insert_Receipt", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new timesheet_table()
                    {
                        TSId = objComm.GetValue<int>(drrr["Rcpt_Id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<timesheet_table> tbl = List_DS as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Get_Receipt(int compid, string srch, string drpsrch, int pageindex, int pagesize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Invoice> List_DS = new List<tbl_Invoice>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Srch", srch);
            param[2] = new SqlParameter("@drpSrch", drpsrch);
            param[3] = new SqlParameter("@pageindex", pageindex);
            param[4] = new SqlParameter("@pagesize", pagesize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Receipt", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Invoice()
                    {
                        sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Recptid = objComm.GetValue<int>(drrr["Receipt_Id"].ToString()),
                        InvNo = objComm.GetValue<string>(drrr["ReceiptNo"].ToString()),
                        InvDt = objComm.GetValue<string>(drrr["receipt_dt"].ToString()),
                        cltid = objComm.GetValue<int>(drrr["cltid"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        Charges = objComm.GetValue<string>(drrr["Net_Invoice"].ToString()),
                        Receipt = objComm.GetValue<string>(drrr["Amount"].ToString()),
                        Narra = objComm.GetValue<string>(drrr["Narration"].ToString()),
                        Mop = objComm.GetValue<string>(drrr["Funds_trf"].ToString()),
                        Tcount = objComm.GetValue<int>(drrr["Tcount"].ToString()),
                    
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Invoice> tbl = List_DS as IEnumerable<tbl_Invoice>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Update_Receipt(int compid, string ReceiptNo, string ReceiptDt, string Narra, string MOP, int Cltid, string RecptAmt, string InvoiceAmt, int Invid, int Receptid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<timesheet_table> List_DS = new List<timesheet_table>();

        string rcpdt = ReceiptDt != "" ? Convert.ToDateTime(ReceiptDt, ci).ToString("MM/dd/yyyy") : null;

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[10];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@ReceiptNo", ReceiptNo);
            param[2] = new SqlParameter("@rcpdt", rcpdt);
            param[3] = new SqlParameter("@Narra", Narra);
            param[4] = new SqlParameter("@MOP", MOP);
            param[5] = new SqlParameter("@Cltid", Cltid);
            param[6] = new SqlParameter("@RecptAmt", RecptAmt);
            param[7] = new SqlParameter("@InvoiceAmt", InvoiceAmt);
            param[8] = new SqlParameter("@Invid", Invid);
            param[9] = new SqlParameter("@recptid", Receptid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Update_Receipt", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new timesheet_table()
                    {
                        TSId = objComm.GetValue<int>(drrr["Rcpt_Id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<timesheet_table> tbl = List_DS as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string BindExpense(int compid, int cltid, int projectid, string fromdt, string todatee)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Expenses> List_DS = new List<Expenses>();
        string fromdate = fromdt != "" ? Convert.ToDateTime(fromdt, ci).ToString("MM/dd/yyyy") : null;
        string todate = todatee != "" ? Convert.ToDateTime(todatee, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@cltid", cltid);
            param[2] = new SqlParameter("@projectid", projectid);
            param[3] = new SqlParameter("@fromdate", fromdate);
            param[4] = new SqlParameter("@todate", todate);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Expense_Invoice", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new Expenses()
                    {

                        Tsid = objComm.GetValue<int>(drrr["ExpAutoId"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        ExpenseName = objComm.GetValue<string>(drrr["tDate"].ToString()),
                        opeName = objComm.GetValue<string>(drrr["OPEName"].ToString()),
                        ExpenseNarr = objComm.GetValue<string>(drrr["ExpNarration"].ToString()),
                        Amount = objComm.GetValue<string>(drrr["Amt"].ToString()),
                        StaffCode = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<Expenses> tbl = List_DS as IEnumerable<Expenses>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

          [WebMethod]
    public string DeleteInvoice(int compid,int InvId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<timesheet_table> List_DS = new List<timesheet_table>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Invid", InvId);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Delete_Invoice", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new timesheet_table()
                    {
                        TSId = objComm.GetValue<int>(drrr["Invid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<timesheet_table> tbl = List_DS as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

               [WebMethod]
    public string DeleteReceipt(int compid,int Rcpt)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<timesheet_table> List_DS = new List<timesheet_table>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Recpt", Rcpt);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Delete_Receipt", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new timesheet_table()
                    {
                        TSId = objComm.GetValue<int>(drrr["Recipt_id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<timesheet_table> tbl = List_DS as IEnumerable<timesheet_table>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
}