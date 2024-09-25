using System;
using System.Collections;
using System.Configuration;
using System.Data;
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
using System.Data.SqlClient;
using Microsoft.Reporting.WebForms;
using CommonLibrary;
using System.Collections.Generic;

public partial class controls_Jobwise_Timesheet_Summary : System.Web.UI.UserControl
{
    LabelAccess objlabelAccess = new LabelAccess();

    List<tbl_LabelAccess> LtblAccess;
    private readonly DBAccess db = new DBAccess();
    DataTable dt_portStaff = new DataTable();
    decimal timee = 0;
    decimal charge = 0;
    decimal ope = 0;
    string stf = "";
    decimal total = 0;
    private DataRow dr;
    private string staff, staff2;
    private int Cid, Cid2;
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;
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
                    if (Session["Jr_ApproverId"].ToString() == "true")
                    {
                        Session["StaffType"] = "App";
                    }
                }
                hdnFrom.Value = (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year) + "-04-01";
                hdnTo.Value = Convert.ToDateTime(DateTime.Now, info).ToString("yyyy-MM-dd");
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            btnBack.Visible = false;
        }

 
    }

    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                btngen.Visible = false;
             
                LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
                if (hdnSelectedStaffCode.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one staff !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                int comp = int.Parse(ViewState["compid"].ToString());
                DateTime FDT = Convert.ToDateTime(hdnFrom.Value, info);
                DateTime EDT = Convert.ToDateTime(hdnTo.Value, info);

                ReportViewer1.ProcessingMode = ProcessingMode.Local;
                ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_JobWise_Timesheet_Summary.rdlc");
                Dt_JobWise_Timesheet_Summary dsss = GetData(comp, FDT, EDT, stf);
                ReportDataSource datasource = new ReportDataSource("DataSet", dsss.Tables[0]);
                ReportViewer1.LocalReport.DataSources.Clear();
                ReportViewer1.LocalReport.DataSources.Add(datasource);
                ReportParameter[] parameters = new ReportParameter[8];
                parameters[0] = new ReportParameter("CompanyName", Convert.ToString(Session["CompanyName"]).Trim());
                parameters[1] = new ReportParameter("Period", ": " + FDT.ToString("dd/MM/yyyy").Trim() + " to " + EDT.ToString("dd/MM/yyyy").Trim());
                parameters[2] = new ReportParameter("ReportName", ": " + objlabelAccess.changelabel("Jobwise Summary - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(','));
                parameters[3] = new ReportParameter("PrintedBy", ": " + Convert.ToString(Session["Name"]).Trim());
                parameters[4] = new ReportParameter("staffnamemaster", " " + objlabelAccess.changelabel("Staff Name ", LtblAccess));
                parameters[5] = new ReportParameter("jobnamemaster", " " + objlabelAccess.changelabel("Job Name ", LtblAccess));
                parameters[6] = new ReportParameter("Expensemaster", " " + objlabelAccess.changelabel("Expense - ", LtblAccess));
                parameters[7] = new ReportParameter("chargeopemaster", " " + objlabelAccess.changelabel("Charges + Expense", LtblAccess));
                this.ReportViewer1.LocalReport.SetParameters(parameters);
                ReportViewer1.LocalReport.DisplayName = objlabelAccess.changelabel("Jobwise Summary - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
                ReportViewer1.LocalReport.Refresh();
                divReportInput.Visible = false;
                ReportViewer1.Visible = true;
                btnBack.Visible = true;
            }
            else
            {
                Response.Redirect("~/Company/Jobwise_Timesheet_Summary.aspx", false);

            }
        }
        catch(Exception ex)
        {
            MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
        }
    }
    private Dt_JobWise_Timesheet_Summary GetData(int comp, DateTime FromDAte, DateTime ToDate, string ids)
    {
        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        SqlCommand cmd = new SqlCommand("usp_Report_Staff_Jobwise_Summary1");
        cmd.Parameters.AddWithValue("@compid", comp);
        cmd.Parameters.AddWithValue("@from_date", FromDAte);
        cmd.Parameters.AddWithValue("@to_date", ToDate);
        cmd.Parameters.AddWithValue("@Id1", hdnSelectedStaffCode.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@TStatus",  hdnTStatusCheck.Value.TrimEnd(','));
        using (SqlConnection con = new SqlConnection(conString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                sda.SelectCommand = cmd;
                using (Dt_JobWise_Timesheet_Summary ds = new Dt_JobWise_Timesheet_Summary())
                {
                    sda.Fill(ds, "DataTable1");
                    return ds;
                }
            }
        }
    }
    protected void btnBack_Click(object sender, EventArgs e)
    {
        divReportInput.Visible = true;
        ReportViewer1.Visible = false;
        btnBack.Visible = false;
        btngen.Visible = true;
    }
}


