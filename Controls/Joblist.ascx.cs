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

public partial class controls_Joblist : System.Web.UI.UserControl
{
    LabelAccess objlabelAccess = new LabelAccess();

    List<tbl_LabelAccess> LtblAccess;
    private readonly DBAccess db = new DBAccess();
    DataTable dtjob = new DataTable();
    DataTable dtstaff = new DataTable();
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;
    public string id = "";
    CultureInfo info = new CultureInfo("en-GB");
    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());

    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
            if (Session["companyid"] != null)
            {   string Link_JobnTask = objDAL_PagePermissions.Dal_getLinks(Convert.ToInt32(Session["companyid"]));
                hdnlink.Value = Link_JobnTask;

                ViewState["compid"] = Session["companyid"].ToString();

                hdndptwise.Value = Session["deptwise"].ToString();
                hdnTaskwise.Value = Session["taskwise"].ToString(); 

                hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                string Link_JobnTask = objDAL_PagePermissions.Dal_getLinks(Convert.ToInt32(Session["companyid"]));
                hdnlink.Value = Link_JobnTask;

                ViewState["compid"] = Session["companyid"].ToString();

                hdndptwise.Value = Session["deptwise"].ToString();
                hdnTaskwise.Value = Session["taskwise"].ToString(); 
                hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
            if (ViewState["compid"] != null)
            {
                if (Session["usertype"] != null)
                {
                    UserType = Session["CompanyName"].ToString();
                }
                else
                { Session["companyid"] = null; Session["companyid"] = null; }
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
                DateTime date = DateTime.Now;

                DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

                hdnFrom.Value = firstDayOfMonth.ToString("yyyy-MM-dd");
                hdnTo.Value = lastDayOfMonth.ToString("yyyy-MM-dd");
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

        }

       
    }



    protected void btngen_Click(object sender, EventArgs e)
    {
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
        if (hdnSelectedmJob.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one Job !", MessageDisplay.DisplayStyles.Error);
            return;
        }
        int comp = int.Parse(ViewState["compid"].ToString());
        DateTime FDT = Convert.ToDateTime(hdnFrom.Value, info);
        DateTime EDT = Convert.ToDateTime(hdnTo.Value, info);
        string bill = ddlBillable.SelectedItem.ToString() ;
        if (bill == "Yes")
        {
            bill = "1";
        }
        else if (bill == "Yes")
        {
            bill = "0";
        }
        ReportViewer1.ProcessingMode = ProcessingMode.Local;

        if (hdnTaskwise.Value == "0")
        {
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_JobList.rdlc");
            DT_JobList dsss = GetData(comp, FDT, EDT, bill);
            ReportDataSource datasource = new ReportDataSource("DataSet1", dsss.Tables[0]);
            ReportViewer1.LocalReport.DataSources.Clear();
            ReportViewer1.LocalReport.DataSources.Add(datasource);
            ReportParameter[] parameters = new ReportParameter[9];
            parameters[0] = new ReportParameter("CompanyName", Convert.ToString(Session["CompanyName"]).Trim());
            parameters[1] = new ReportParameter("Period", ": " + FDT.ToString("dd/MM/yyyy").Trim() + " to " + EDT.ToString("dd/MM/yyyy").Trim());
            parameters[2] = new ReportParameter("ReportName", ": " + objlabelAccess.changelabel("Job List - ", LtblAccess) + (ddlStatus.SelectedValue == "All" ? "Saved, Submitted, Approved, Rejected" : ddlStatus.SelectedValue));
            parameters[3] = new ReportParameter("PrintedBy", ": " + Convert.ToString(Session["Name"]).Trim());
            parameters[4] = new ReportParameter("jobnamemaster", " " + objlabelAccess.changelabel("Job Name  ", LtblAccess));
            parameters[5] = new ReportParameter("jobgroupmaster", " " + objlabelAccess.changelabel("Job Group  ", LtblAccess));
            parameters[6] = new ReportParameter("cgroupmaster", " " + objlabelAccess.changelabel("Client Group ", LtblAccess));
            parameters[7] = new ReportParameter("clientnamemaster", " " + objlabelAccess.changelabel("Client Name  ", LtblAccess));
            parameters[8] = new ReportParameter("staffnamemaster", " " + objlabelAccess.changelabel("Staff Name  ", LtblAccess));
            this.ReportViewer1.LocalReport.SetParameters(parameters);
        }
        else
        {
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_JobList_Task.rdlc");
            DT_JobList_Task dsss = GetData_Task(comp, FDT, EDT, bill);
            ReportDataSource datasource = new ReportDataSource("DataSet1", dsss.Tables[0]);
            ReportViewer1.LocalReport.DataSources.Clear();
            ReportViewer1.LocalReport.DataSources.Add(datasource);
            ReportParameter[] parameters = new ReportParameter[11];
            parameters[0] = new ReportParameter("CompanyName", Convert.ToString(Session["CompanyName"]).Trim());
            parameters[1] = new ReportParameter("Period", ": " + FDT.ToString("dd/MM/yyyy").Trim() + " to " + EDT.ToString("dd/MM/yyyy").Trim());
            parameters[2] = new ReportParameter("ReportName", ": " + objlabelAccess.changelabel("Job List - ", LtblAccess) + (ddlStatus.SelectedValue == "All" ? "Saved, Submitted, Approved, Rejected" : ddlStatus.SelectedValue));
            parameters[3] = new ReportParameter("PrintedBy", ": " + Convert.ToString(Session["Name"]).Trim());
            parameters[4] = new ReportParameter("jobnamemaster", " " + objlabelAccess.changelabel("Job Name  ", LtblAccess));
            parameters[5] = new ReportParameter("jobgroupmaster", " " + objlabelAccess.changelabel("Job Group  ", LtblAccess));
            parameters[6] = new ReportParameter("cgroupmaster", " " + objlabelAccess.changelabel("Client Group ", LtblAccess));
            parameters[7] = new ReportParameter("clientnamemaster", " " + objlabelAccess.changelabel("Client Name  ", LtblAccess));
            parameters[8] = new ReportParameter("staffnamemaster", " " + objlabelAccess.changelabel("Staff Name  ", LtblAccess));
            parameters[9] = new ReportParameter("taskname", " " + objlabelAccess.changelabel("Task Name  ", LtblAccess));
            parameters[10] = new ReportParameter("projectname", " " + objlabelAccess.changelabel("Project Name  ", LtblAccess));
            this.ReportViewer1.LocalReport.SetParameters(parameters);
        }
        
        ReportViewer1.LocalReport.DisplayName = objlabelAccess.changelabel("Job List - ",LtblAccess) + (ddlStatus.SelectedValue == "Both" ? "OnGoing, Compeleted" : ddlStatus.SelectedValue);
        ReportViewer1.LocalReport.Refresh();
        divReportInput.Visible = false;
        ReportViewer1.Visible = true;
        btnBack.Visible = true;
        btngen.Visible = false;
    }

    private DT_JobList GetData(int comp, DateTime FromDAte, DateTime ToDate, string bill)
    {
        if (bill == "No")
        {
            bill = "0";
        } else if (bill == "Yes")
        {
            bill = "1";
        }


        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        SqlCommand cmd = new SqlCommand("usp_report_JobList");
        cmd.Parameters.AddWithValue("@compid", comp);
        cmd.Parameters.AddWithValue("@UserType", hdnUserType.Value);
        cmd.Parameters.AddWithValue("@FromDate", FromDAte);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        cmd.Parameters.AddWithValue("@Ids", hdnSelectedmJob.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@TStatus", ddlStatus.SelectedValue);
        cmd.Parameters.AddWithValue("@Staffcode", hdnStaffCode.Value);
        cmd.Parameters.AddWithValue("@Billable", bill);


        using (SqlConnection con = new SqlConnection(conString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                sda.SelectCommand = cmd;
                using (DT_JobList ds = new DT_JobList())
                {
                    sda.Fill(ds, "Datatable_JobList");
                    return ds;
                }
            }
        }
 
        
    }


    private DT_JobList_Task GetData_Task(int comp, DateTime FromDAte, DateTime ToDate, string bill)
    {
        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        SqlCommand cmd = new SqlCommand("usp_report_JobList_Task");
        cmd.Parameters.AddWithValue("@compid", comp);
        cmd.Parameters.AddWithValue("@UserType", hdnUserType.Value);
        cmd.Parameters.AddWithValue("@FromDate", FromDAte);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        cmd.Parameters.AddWithValue("@Ids", hdnSelectedmJob.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@TStatus", ddlStatus.SelectedValue);
        cmd.Parameters.AddWithValue("@Staffcode", hdnStaffCode.Value);
        cmd.Parameters.AddWithValue("@Billable", bill);


        using (SqlConnection con = new SqlConnection(conString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                sda.SelectCommand = cmd;
                using (DT_JobList_Task ds = new DT_JobList_Task())
                {
                    sda.Fill(ds, "Datatable_JobList_Task");
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
