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

public partial class controls_ClientGroup_AllStaff : System.Web.UI.UserControl
{
    LabelAccess objlabelAccess = new LabelAccess();

    List<tbl_LabelAccess> LtblAccess;
    private readonly DBAccess db = new DBAccess();
    DataTable dt_portStaff = new DataTable();
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;
    string sql1;
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
                    if (Session["Jr_ApproverId"] == "true")
                    {
                        Session["StaffType"] = "App";
                    }
                }
                txtstartdate1.Text = Convert.ToDateTime(DateTime.Now.AddDays(-31), info).ToString("dd/MM/yyyy");
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
            //txtstartdate1.Text = Convert.ToDateTime(DateTime.Now.AddDays(-31), info).ToString("dd/MM/yyyy");
            //txtenddate2.Text = Convert.ToDateTime(DateTime.Now, info).ToString("dd/MM/yyyy");
        }

        txtstartdate1.Attributes.Add("onblur", "checkForm();");

        txtenddate2.Attributes.Add("onblur", "checkForms();");

    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
        if (hdnSelectedGroupid.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one Client Group !", MessageDisplay.DisplayStyles.Error);
            return;
        }
        int comp = int.Parse(ViewState["compid"].ToString());
        DateTime FDT = Convert.ToDateTime(txtstartdate1.Text, info);
        DateTime EDT = Convert.ToDateTime(txtenddate2.Text, info);

        ReportViewer1.ProcessingMode = ProcessingMode.Local;
        ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_ClientGroup.rdlc");
        DT_ClientGroup dsss = GetData(comp, FDT, EDT);
        ReportDataSource datasource = new ReportDataSource("DataSet1", dsss.Tables[0]);
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.LocalReport.DataSources.Add(datasource);
        ReportParameter[] parameters = new ReportParameter[9];
        parameters[0] = new ReportParameter("CompanyName", Convert.ToString(Session["CompanyName"]).Trim());
        parameters[1] = new ReportParameter("Period", ": " + FDT.ToString("dd/MM/yyyy").Trim() + " to " + EDT.ToString("dd/MM/yyyy").Trim());
        parameters[2] = new ReportParameter("ReportName", ": " + objlabelAccess.changelabel("Client Group All Staff - ",LtblAccess) + (ddlStatus.SelectedValue == "All" ? "Saved, Submitted, Approved, Rejected" : ddlStatus.SelectedValue));
        parameters[3] = new ReportParameter("PrintedBy", " : " + Convert.ToString(Session["Name"]).Trim());
        parameters[4] = new ReportParameter("cgmaster", "  " + objlabelAccess.changelabel("Client Group", LtblAccess));
        parameters[5]=  new ReportParameter("ClientNamemaster"," "+ objlabelAccess.changelabel("Client Name", LtblAccess));
        parameters[6] = new ReportParameter("jobNamemaster"," " + objlabelAccess.changelabel("Job Name", LtblAccess));
        parameters[7] = new ReportParameter("Expensemaster", " " + objlabelAccess.changelabel("Expense Amount", LtblAccess));
        parameters[8] = new ReportParameter("chargeopemaster", " " + objlabelAccess.changelabel("Charge + Expense Amount", LtblAccess));
        this.ReportViewer1.LocalReport.SetParameters(parameters);
        ReportViewer1.LocalReport.DisplayName = "Client Group All Staff - " + (ddlStatus.SelectedValue == "All" ? "Saved, Submitted, Approved, Rejected" : ddlStatus.SelectedValue);
        ReportViewer1.LocalReport.Refresh();
        divReportInput.Visible = false;
        ReportViewer1.Visible = true;
        btnBack.Visible = true;
        dvEditInvoice2.Visible = false;

    }
    private DT_ClientGroup GetData(int comp, DateTime FromDAte, DateTime ToDate)
    {
        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        SqlCommand cmd = new SqlCommand("usp_Report_ClientGroup");
        cmd.Parameters.AddWithValue("@compid", comp);
        cmd.Parameters.AddWithValue("@UserType", hdnUserType.Value);
        cmd.Parameters.AddWithValue("@FromDate", FromDAte);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        cmd.Parameters.AddWithValue("@Ids", hdnSelectedGroupid.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@TStatus", ddlStatus.SelectedValue);
        cmd.Parameters.AddWithValue("@Staffcode", hdnStaffCode.Value);
        using (SqlConnection con = new SqlConnection(conString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                sda.SelectCommand = cmd;
                using (DT_ClientGroup ds = new DT_ClientGroup())
                {
                    sda.Fill(ds, "DataTable_ClientGroup");
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
        dvEditInvoice2.Visible = true;
    }
}


