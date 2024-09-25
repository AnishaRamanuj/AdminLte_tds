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
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;

public partial class controls_Staff_TimeSheet_Sumary : System.Web.UI.UserControl
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
                hdnTypeU.Value = UserType;
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
                //txtstartdate1.Text = "01/04/" + (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year);
                //txtenddate2.Text = Convert.ToDateTime(DateTime.Now, info).ToString("dd/MM/yyyy");

                hdnFrom.Value = (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year) + "-04-01";
                hdnTo.Value = Convert.ToDateTime(DateTime.Now, info).ToString("yyyy-MM-dd");
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

        //txtstartdate1.Attributes.Add("onblur", "checkForm();");

        //txtenddate2.Attributes.Add("onblur", "checkForms();");
    }


    protected void btngen_Click(object sender, EventArgs e)
    {
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
        ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_StaffWise_Timesheet_Summary.rdlc");
        DtStaffAllTimesheetSummary dsss = GetData(comp, FDT, EDT);
        ReportDataSource datasource = new ReportDataSource("DataSet", dsss.Tables[0]);
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.LocalReport.DataSources.Add(datasource);
        ReportParameter[] parameters = new ReportParameter[7];
        parameters[0] = new ReportParameter("CompanyName", Convert.ToString(Session["CompanyName"]).Trim());
        parameters[1] = new ReportParameter("Period", ": " + FDT.ToString("dd/MM/yyyy").Trim() + " to " + EDT.ToString("dd/MM/yyyy").Trim());
        parameters[2] = new ReportParameter("ReportName", ": " + "Timesheet Summary - " + hdnTStatusCheck.Value.TrimEnd(','));
        parameters[3] = new ReportParameter("PrintedBy", ": " + Convert.ToString(Session["Name"]).Trim());
        parameters[4] = new ReportParameter("staffnamemaster", " " + objlabelAccess.changelabel("Staff Name ",LtblAccess));
        parameters[5] = new ReportParameter("Expensemaster", " " + objlabelAccess.changelabel("Expense Amount ", LtblAccess));
        parameters[6] = new ReportParameter("chargeopemaster", " " + objlabelAccess.changelabel("charge + Expense Amount", LtblAccess));
        this.ReportViewer1.LocalReport.SetParameters(parameters);
        ReportViewer1.LocalReport.DisplayName = "Timesheet Summary - " + hdnTStatusCheck.Value.TrimEnd(',');
        ReportViewer1.LocalReport.Refresh();
        divReportInput.Visible = false;
        ReportViewer1.Visible = true;
        btnBack.Visible = true;
        btngen.Visible = false;
    }
    private DtStaffAllTimesheetSummary GetData(int comp, DateTime FromDAte, DateTime ToDate)
    {
        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        SqlCommand cmd = new SqlCommand("usp_GetStaffAllTimesheetSummary");
        cmd.Parameters.AddWithValue("@compid", comp);
        cmd.Parameters.AddWithValue("@from_date", FromDAte);
        cmd.Parameters.AddWithValue("@to_date", ToDate);
        cmd.Parameters.AddWithValue("@Ids", hdnSelectedStaffCode.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@TStatus", hdnTStatusCheck.Value.TrimEnd(','));
        using (SqlConnection con = new SqlConnection(conString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                sda.SelectCommand = cmd;
                using (DtStaffAllTimesheetSummary ds = new DtStaffAllTimesheetSummary())
                {
                    sda.Fill(ds, "DtStaffT");
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