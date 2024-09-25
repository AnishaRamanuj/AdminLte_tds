using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using JTMSProject;
using System.Globalization;
using Microsoft.Reporting.WebForms;
using CommonLibrary;
using System.Collections.Generic;
using Microsoft.ApplicationBlocks1.Data;
using System.Web.Script.Serialization;

public partial class controls_Client_AllJobAllStaff : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    private readonly JobMaster job = new JobMaster();
    JobStaffTable jobstaff = new JobStaffTable();
    StaffMaster staff = new StaffMaster();
    CompanyMaster comp = new CompanyMaster();
    ClientMaster client = new ClientMaster();
    DataTable dtstaff = new DataTable();
    DataTable dtjob = new DataTable();
    DataTable dtjobgrp = new DataTable();
    DataTable dtclientgrp = new DataTable();
    DataTable dtclient = new DataTable();
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;
    public string JobID = "";
    public string Clientid = "";
    public string widd1 = "";
    CultureInfo info = new CultureInfo("en-GB");
    LabelAccess objlabelAccess = new LabelAccess();

    List<tbl_LabelAccess> LtblAccess;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                hdnCompid.Value = Session["cltcomp"].ToString();
                ViewState["compid"] = Session["cltcomp"].ToString();
            }
            if (ViewState["compid"] != null)
            {
                if (Session["usertype"] != null)
                {
                    UserType = Session["usertype"].ToString();
                }
                else
                { Session["companyid"] = null; Session["cltcomp"] = null; }
                hdnUserType.Value = UserType;
                if (UserType == "staff")
                {
                    hdnStaffCode.Value = Session["staffid"].ToString();
                    Staffid = Session["staffid"].ToString();
                }

                if (UserType == "staff")
                {
                    if (Session["Jr_ApproverId"] == "true")
                    {
                        Session["StaffType"] = "App";
                    }
                }

                txtstartdate1.Text = "01/04/" + (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year);
                txtenddate2.Text = Convert.ToDateTime(DateTime.Now, info).ToString("dd/MM/yyyy");
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            //if (Session["usertype"] != null)
            //{
            //    UserType = Session["usertype"].ToString();
            //}
            //else
            //{ Session["companyid"] = null; Session["cltcomp"] = null; }
            //hdnUserType.Value = UserType;
            //if (UserType == "staff")
            //{
            //    hdnStaffCode.Value = Session["staffid"].ToString();
            //    Staffid = Session["staffid"].ToString();
            //}

            //if (UserType == "staff")
            //{
            //    if (Session["Jr_ApproverId"] == "true")
            //    {
            //        Session["StaffType"] = "App";
            //    }
            //}

            //txtstartdate1.Text = "01/04/" + (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year);
            //txtenddate2.Text = Convert.ToDateTime(DateTime.Now, info).ToString("dd/MM/yyyy");
        }

        txtstartdate1.Attributes.Add("onblur", "checkForm();");

        txtenddate2.Attributes.Add("onblur", "checkForms();");
    }

    public void getCompanyDetails()
    {
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", hdnCompid.Value);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader((new CommonFunctions())._cnnString, CommandType.StoredProcedure, "usp_GetCompDetails_ClintStaffAll", param))
            {
                while (drrr.Read())
                {
                    hdnFormat.Value = drrr["Format_B"].ToString();
                }
            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
        divReportInput.Visible = true;
        ReportViewer1.Visible = false;
        btnBack.Visible = false;
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                getCompanyDetails();
                if (rdetailed.Checked)
                {
                    if (hdnFormat.Value == "False")
                    {
                        GetReport();
                    }
                    else
                    {
                        Report_Format_B();
                    }
                }
                else
                {
                    GetReport();
                }
            }
            else
            {
                Response.Redirect("~/Company/Client_AllJobAllStaff.aspx", false);
            }
        }
        catch(Exception ex)
        {
            MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
        }
    }

    public void Report_Format_B()
    {
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
        string ReportName = "";
        if (hdnSelectedStaffCode.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one staff !", MessageDisplay.DisplayStyles.Error);
            return;
        }
        int comp = int.Parse(ViewState["compid"].ToString());
        DateTime FDT = Convert.ToDateTime(txtstartdate1.Text, info);
        DateTime EDT = Convert.ToDateTime(txtenddate2.Text, info);

        ReportViewer1.ProcessingMode = ProcessingMode.Local;


        if (rdetailed.Checked)
        {

            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_Client_Job_Staff_Detail_with_Time.rdlc");
            ReportName = "All Client All Job Detailed - " + hdnTStatusCheck.Value.TrimEnd(',');
        }
        else
        {
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_ClientWiseJobWiseStaffWiseSummary.rdlc");
            ReportName = objlabelAccess.changelabel("All Client All Job Summarized - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
        }

        DT_Client_Job_Staff_Time dsss = GetTimenData(comp, FDT, EDT);
        ReportDataSource datasource = new ReportDataSource("DataSet1", dsss.Tables[0]);
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.LocalReport.DataSources.Add(datasource);
        ReportParameter[] parameters = new ReportParameter[10];
        parameters[0] = new ReportParameter("CompanyName", Convert.ToString(Session["fulname"]).Trim());
        parameters[1] = new ReportParameter("Period", ": " + FDT.ToString("dd/MM/yyyy").Trim() + " to " + EDT.ToString("dd/MM/yyyy").Trim());
        parameters[2] = new ReportParameter("ReportName", ": " + ReportName);
        parameters[3] = new ReportParameter("PrintedBy", ": " + Convert.ToString(Session["Name"]).Trim());
        parameters[4] = new ReportParameter("cgmaster", " " + objlabelAccess.changelabel("Client Name", LtblAccess));
        parameters[5] = new ReportParameter("jobnamemaster", " " + objlabelAccess.changelabel("Job Name", LtblAccess));
        parameters[6] = new ReportParameter("staffnamemaster", " " + objlabelAccess.changelabel("Staff Name", LtblAccess));
        parameters[7] = new ReportParameter("Expensemaster", " " + objlabelAccess.changelabel("Expense Amount", LtblAccess));
        parameters[8] = new ReportParameter("chargeopemaster", " " + objlabelAccess.changelabel("Charge + Expense Amount", LtblAccess));
        parameters[9] = new ReportParameter("expensedetail", " " + objlabelAccess.changelabel("Expense Details", LtblAccess));
        this.ReportViewer1.LocalReport.SetParameters(parameters);
        ReportViewer1.LocalReport.DisplayName = ReportName;
        ReportViewer1.LocalReport.Refresh();
        divReportInput.Visible = false;
        ReportViewer1.Visible = true;
        btnBack.Visible = true;


    }

    public void GetReport()
    {
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
        string ReportName = "";
        if (hdnSelectedStaffCode.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one staff !", MessageDisplay.DisplayStyles.Error);
            return;
        }
        int comp = int.Parse(ViewState["compid"].ToString());
        DateTime FDT = Convert.ToDateTime(txtstartdate1.Text, info);
        DateTime EDT = Convert.ToDateTime(txtenddate2.Text, info);

        ReportViewer1.ProcessingMode = ProcessingMode.Local;


        if (rdetailed.Checked)
        {
            if (hdnFormat.Value == "False")
            {
                ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_Client_Job_Staff_Detail_with_Time.rdlc");
                ReportName = "All Client All Job Detailed - " + hdnTStatusCheck.Value.TrimEnd(',');

            }
            else
            {
                ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_ClientWiseJobWiseStaffWiseDetail.rdlc");
                ReportName = "All Client All Job Detailed - " + hdnTStatusCheck.Value.TrimEnd(',');
            }
        }
        else
        {
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_ClientWiseJobWiseStaffWiseSummary.rdlc");
            ReportName = objlabelAccess.changelabel("All Client All Job Summarized - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
        }

        DtStaffWiseClientWistJobWiseTimesheetSummary dsss = GetData(comp, FDT, EDT);
        ReportDataSource datasource = new ReportDataSource("DataSet1", dsss.Tables[0]);
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.LocalReport.DataSources.Add(datasource);
        ReportParameter[] parameters = new ReportParameter[10];
        parameters[0] = new ReportParameter("CompanyName", Convert.ToString(Session["fulname"]).Trim());
        parameters[1] = new ReportParameter("Period", ": " + FDT.ToString("dd/MM/yyyy").Trim() + " to " + EDT.ToString("dd/MM/yyyy").Trim());
        parameters[2] = new ReportParameter("ReportName", ": " + ReportName);
        parameters[3] = new ReportParameter("PrintedBy", ": " + Convert.ToString(Session["Name"]).Trim());
        parameters[4] = new ReportParameter("cgmaster", " " + objlabelAccess.changelabel("Client Name", LtblAccess));
        parameters[5] = new ReportParameter("jobnamemaster", " " + objlabelAccess.changelabel("Job Name", LtblAccess));
        parameters[6] = new ReportParameter("staffnamemaster", " " + objlabelAccess.changelabel("Staff Name", LtblAccess));
        parameters[7] = new ReportParameter("Expensemaster", " " + objlabelAccess.changelabel("Expense Amount", LtblAccess));
        parameters[8] = new ReportParameter("chargeopemaster", " " + objlabelAccess.changelabel("Charge + Expense Amount", LtblAccess));
        parameters[9] = new ReportParameter("expensedetail", " " + objlabelAccess.changelabel("Expense Details", LtblAccess));
        this.ReportViewer1.LocalReport.SetParameters(parameters);
        ReportViewer1.LocalReport.DisplayName = ReportName;
        ReportViewer1.LocalReport.Refresh();
        divReportInput.Visible = false;
        ReportViewer1.Visible = true;
        btnBack.Visible = true;

    }


    private DtStaffWiseClientWistJobWiseTimesheetSummary GetData(int comp, DateTime FromDAte, DateTime ToDate)
    {
        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        SqlCommand cmd;

        if (rdetailed.Checked)
        {
            cmd = new SqlCommand("usp_Report_ClientwiseTimesheetDetailed");
        }

        else
        {
            cmd = new SqlCommand("usp_Report_ClientwiseTimesheetSummary");
        }
            

        cmd.Parameters.AddWithValue("@compid", comp);
        cmd.Parameters.AddWithValue("@UserType", hdnUserType.Value);
        cmd.Parameters.AddWithValue("@TStatus", hdnTStatusCheck.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@StaffCode", hdnStaffCode.Value == "" ? "0" : hdnStaffCode.Value);
        cmd.Parameters.AddWithValue("@selectedstaffcode", hdnSelectedStaffCode.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@selectedclientid", hdnselectedclientid.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@selectedjobid", hdnselectedjobid.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@FromDate", FromDAte);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        using (SqlConnection con = new SqlConnection(conString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                sda.SelectCommand = cmd;
                using (DtStaffWiseClientWistJobWiseTimesheetSummary ds = new DtStaffWiseClientWistJobWiseTimesheetSummary())
                {
                    sda.Fill(ds, "DataTable1");
                    return ds;
                }
            }
        }
    }


    private DT_Client_Job_Staff_Time GetTimenData(int comp, DateTime FromDAte, DateTime ToDate)
    {
        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        SqlCommand cmd;

        if (rdetailed.Checked)
            cmd = new SqlCommand("usp_Report_ClientwiseTimesheetDetailed_Format2");
        else
            cmd = new SqlCommand("usp_Report_ClientwiseTimesheetSummary");

        cmd.Parameters.AddWithValue("@compid", comp);
        cmd.Parameters.AddWithValue("@UserType", hdnUserType.Value);
        cmd.Parameters.AddWithValue("@TStatus", hdnTStatusCheck.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@StaffCode", hdnStaffCode.Value == "" ? "0" : hdnStaffCode.Value);
        cmd.Parameters.AddWithValue("@selectedstaffcode", hdnSelectedStaffCode.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@selectedclientid", hdnselectedclientid.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@selectedjobid", hdnselectedjobid.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@FromDate", FromDAte);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        using (SqlConnection con = new SqlConnection(conString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                sda.SelectCommand = cmd;
                using (DT_Client_Job_Staff_Time ds = new DT_Client_Job_Staff_Time())
                {
                    sda.Fill(ds, "DataTable1");
                    return ds;
                }
            }
        }
    }
}
