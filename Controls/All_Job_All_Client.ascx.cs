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

public partial class controls_All_Job_All_Client : System.Web.UI.UserControl
{
    LabelAccess objlabelAccess = new LabelAccess();

    List<tbl_LabelAccess> LtblAccess;
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
                    UserType = Session["CompanyName"].ToString();
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
                    if (Session["Jr_ApproverId"].ToString() == "true")
                    {
                        Session["StaffType"] = "App";
                    }
                }
                //txtstartdate1.Text = "01/04/" + (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year);
                //txtenddate2.Text = Convert.ToDateTime(DateTime.Now, info).ToString("dd/MM/yyyy");
                hdnFrom.Value = (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year) + "-04-01";
                hdnTo.Value = Convert.ToDateTime(DateTime.Now, info).ToString("yyyy-MM-dd");
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            btnBack.Visible = false;
        }

        //txtstartdate1.Attributes.Add("onblur", "checkForm();");

        //txtenddate2.Attributes.Add("onblur", "checkForms();");
    }
    protected void btnBack_Click(object sender, EventArgs e)
    {
        divReportInput.Visible = true;
        ReportViewer1.Visible = false;
        btnBack.Visible = false;
        //lblname.Visible = true;
        btngen.Visible = true;
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                //lblname.Visible = false;
                btngen.Visible = false;
                LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
                string ReportName = "";
                if (hdnSelectedStaffCode.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one staff !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                int comp = int.Parse(ViewState["compid"].ToString());
                DateTime FDT = Convert.ToDateTime(hdnFrom.Value, info);
                DateTime EDT = Convert.ToDateTime(hdnTo.Value, info);

                ReportViewer1.ProcessingMode = ProcessingMode.Local;


                if (rdetailed.Checked)
                {
                    ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_JobWiseClientWiseStaffWiseDetail.rdlc");
                    ReportName = objlabelAccess.changelabel("All Job All Client Detailed - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
                }
                else
                {
                    ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_JobWiseClientWiseStaffWiseSummary.rdlc");
                    ReportName = objlabelAccess.changelabel("All Job All Client Summarized - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
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
                parameters[4] = new ReportParameter("jobnamemaster", " " + objlabelAccess.changelabel("Job Name", LtblAccess));
                parameters[5] = new ReportParameter("clientnamemaster", " " + objlabelAccess.changelabel("Client Name", LtblAccess));
                parameters[6] = new ReportParameter("staffnamemaster", " " + objlabelAccess.changelabel("Staff Name", LtblAccess));
                parameters[7] = new ReportParameter("Expensemaster", " " + objlabelAccess.changelabel("Expense Amount", LtblAccess));
                parameters[8] = new ReportParameter("chargeopemaster", " " + objlabelAccess.changelabel("Charge + Expense Amount", LtblAccess));
                parameters[9] = new ReportParameter("expensedetail", " " + objlabelAccess.changelabel("Expense detail", LtblAccess));
                this.ReportViewer1.LocalReport.SetParameters(parameters);
                ReportViewer1.LocalReport.DisplayName = ReportName;
                ReportViewer1.LocalReport.Refresh();
                divReportInput.Visible = false;
                ReportViewer1.Visible = true;
                btnBack.Visible = true;
            }
            else
            {
                Response.Redirect("~/Company/All_Job_All_Client.aspx", false);
            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
        }
    }
    private DtStaffWiseClientWistJobWiseTimesheetSummary GetData(int comp, DateTime FromDAte, DateTime ToDate)
    {
        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        SqlCommand cmd;

        if (rdetailed.Checked)
            cmd = new SqlCommand("usp_Report_JobwiseTimesheetDetailed");
        else
            cmd = new SqlCommand("usp_Report_JobwiseTimesheetSummary");

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

}