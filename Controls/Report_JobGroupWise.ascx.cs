using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Data.SqlClient;
using DataAccessLayer;
using System.Data;
using Microsoft.ApplicationBlocks1.Data;
using System.Text;
using System.Web.Services;
using System.Configuration;
using Microsoft.Reporting.WebForms;
using JTMSProject;
using CommonLibrary;
using System.Xml;

public partial class controls_Report_JobGroupWise : System.Web.UI.UserControl
{
    
    private static Common objcommon = new Common();
    public string UserType = "";
    public string Staffid = "";
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
            //txtenddate2.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            hdnFrom.Value = (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year) + "-04-01";
            hdnTo.Value = Convert.ToDateTime(DateTime.Now, info).ToString("yyyy-MM-dd");
        }
        //txtstartdate1.Attributes.Add("onblur", "checkForm();");

        //txtenddate2.Attributes.Add("onblur", "checkForms();");
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
        divReportInput.Visible = true;
        ReportViewer1.Visible = false;
        btnBack.Visible = false;
        btngen.Visible = true;
    }


    protected void btngen_Click(object sender, EventArgs e)
    {
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
        string ReportName = "";
        if (hdnselectedjobid.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one Client Name !", MessageDisplay.DisplayStyles.Error);
            return;
        }
        int comp = int.Parse(ViewState["compid"].ToString());
        DateTime FDT = Convert.ToDateTime(hdnFrom.Value, info);
        DateTime EDT = Convert.ToDateTime(hdnTo.Value, info);

        ReportViewer1.ProcessingMode = ProcessingMode.Local;


        if (rdetailed.Checked)
        {
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_JobGroupWise_Details.rdlc");
            ReportName = objlabelAccess.changelabel("Job Wise Department Wise Report Detailed - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
        }
        else
        {
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_JobGroupWise_Summary.rdlc");
            ReportName = objlabelAccess.changelabel("Job Wise Department Wise Report Summarized - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
        }

        Dt_DepartmentWiseSummaryNDetails dsss = GetData(comp, FDT, EDT);
        ReportDataSource datasource = new ReportDataSource("DataSet1", dsss.Tables[0]);
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.LocalReport.DataSources.Add(datasource);
        ReportParameter[] parameters = new ReportParameter[10];
        parameters[0] = new ReportParameter("CompanyName", Convert.ToString(Session["fulname"]).Trim());
        parameters[1] = new ReportParameter("Period", ": " + FDT.ToString("dd/MM/yyyy").Trim() + " to " + EDT.ToString("dd/MM/yyyy").Trim());
        parameters[2] = new ReportParameter("ReportName", ": " + ReportName);
        parameters[3] = new ReportParameter("PrintedBy", ": " + Convert.ToString(Session["Name"]).Trim());
        parameters[4] = new ReportParameter("jobnamemaster", " " + objlabelAccess.changelabel("Job Name", LtblAccess));
        parameters[5] = new ReportParameter("cgroupmaster", " " + objlabelAccess.changelabel("Client Group Name", LtblAccess));
        parameters[6] = new ReportParameter("clientnamemaster", " " + objlabelAccess.changelabel("Client Name", LtblAccess));
        parameters[7] = new ReportParameter("deptmaster", " " + objlabelAccess.changelabel("Department Name", LtblAccess));
        parameters[8] = new ReportParameter("desgmaster", " " + objlabelAccess.changelabel("Designation Name", LtblAccess));
        parameters[9] = new ReportParameter("staffnamemaster", " " + objlabelAccess.changelabel("Staff Name", LtblAccess));
        this.ReportViewer1.LocalReport.SetParameters(parameters);
        ReportViewer1.LocalReport.DisplayName = ReportName;
        ReportViewer1.LocalReport.Refresh();
        divReportInput.Visible = false;
        ReportViewer1.Visible = true;
        btnBack.Visible = true;
        btngen.Visible = false;
    }

    private Dt_DepartmentWiseSummaryNDetails GetData(int comp, DateTime FromDAte, DateTime ToDate)
    {
        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        SqlCommand cmd;

        if (rdetailed.Checked)
            cmd = new SqlCommand("usp_Report_JobGroupWise_with_JobName_Detail");
        else
            cmd = new SqlCommand("usp_Report_JobGroupWise_with_JobName_Summary");

        cmd.Parameters.AddWithValue("@Compid", comp);
        cmd.Parameters.AddWithValue("@UserType", hdnUserType.Value);
        cmd.Parameters.AddWithValue("@TStatus", hdnTStatusCheck.Value.TrimEnd(','));
        cmd.Parameters.AddWithValue("@StaffCode", hdnStaffCode.Value == "" ? "0" : hdnStaffCode.Value);
        cmd.Parameters.AddWithValue("@selectedJobGrp", hdnSelectedJobGrp.Value.TrimEnd(','));
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
                using (Dt_DepartmentWiseSummaryNDetails ds = new Dt_DepartmentWiseSummaryNDetails())
                {
                    try
                    {
                        sda.Fill(ds, "DataTable1");
                    }
                    catch (Exception ex)
                    {
                        string sds = ex.Message;
                    }

                    return ds;
                }
            }
        }
    }
}