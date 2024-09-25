using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using JTMSProject;
using System.Web.Security;
using System.Text;
using System.Net.Mail;
using System.Configuration;
using AjaxControlToolkit;
using System.Text.RegularExpressions;
using System.IO;
using System.Collections;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml;
using System.Web.Services;
using System.Management;
using System.Web.Caching;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using CommonLibrary;
using Microsoft.Reporting.WebForms;

public partial class controls_Report_Voucher : System.Web.UI.UserControl
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
    private string SD, ED ;
    private string ss1, tempfileName;
    CultureInfo info = new CultureInfo("en-GB");
    public static CultureInfo ci = new CultureInfo("en-GB");
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();

                hdnStaffCode.Value = "0";

            }
            else if (Session["staffid"] != null)
            {
                hdnCompid.Value = Session["cltcomp"].ToString();
                ViewState["compid"] = Session["cltcomp"].ToString();
            }
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
            if (hdnCompid.Value != "206")
            {
                rbtn1.Checked = true;
                rbtn1.Visible = false;
                rbtn2.Visible = false;
                BindClient();
            }
        }

        txtstartdate1.Attributes.Add("onblur", "checkForm();");

        txtenddate2.Attributes.Add("onblur", "checkForms();");
    }

    protected void BindClient()
    {
        SD = txtstartdate1.Text;
        ED = txtenddate2.Text;
        CultureInfo info = new CultureInfo("en-US", false);
        DateTime Fdob = new DateTime(1900, 1, 1);
        DateTime dob = new DateTime(1900, 1, 1);
        String _dateFormat = "dd/MM/yyyy";
        if (txtstartdate1.Text.Trim() != "" && !DateTime.TryParseExact(txtstartdate1.Text.Trim(), _dateFormat, info,
                                                                                        DateTimeStyles.AllowWhiteSpaces, out Fdob))
        {
        }
        if (txtenddate2.Text.Trim() != "" && !DateTime.TryParseExact(txtenddate2.Text.Trim(), _dateFormat, info,
                                                                                              DateTimeStyles.AllowWhiteSpaces, out dob))
        {
        }
        DateTime EDT = dob;
        DateTime FDT = Fdob;


        SD = String.Format("{0:MM/dd/yyyy}", Fdob);
        ED = String.Format("{0:MM/dd/yyyy}", dob);


        string ss = "select Distinct c.ClientName,t.CLTId from TimeSheet_Table t inner join ExpenseTs e on e.tsid=t.tsid inner join Client_Master c on t.CLTId=c.CLTId "
        + " where t.StaffCode='" + Session["staffid"].ToString() + "' and t.compid= " + ViewState["compid"] + " and (CONVERT(date,t.date) between '" + SD + "' and '" + ED + "' ) order by c.ClientName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            drpClient.Items.Clear();
            
            drpClient.DataSource = dt;
            drpClient.DataBind();
            //if (rbtn1.Checked == true)
            //{
                drpClient.Items.Insert(0, "All");
            //}
            BindJob();

        }
        else
        {
            drpClient.Items.Clear();
            drpClient.Items.Insert(0, "--None--");
        }

    }


    public void BindJob()
    {
        drpjob.Items.Clear();  
        SD = txtstartdate1.Text;
        ED = txtenddate2.Text;
        CultureInfo info = new CultureInfo("en-US", false);
        DateTime Fdob = new DateTime(1900, 1, 1);
        DateTime dob = new DateTime(1900, 1, 1);
        String _dateFormat = "dd/MM/yyyy";
        if (txtstartdate1.Text.Trim() != "" && !DateTime.TryParseExact(txtstartdate1.Text.Trim(), _dateFormat, info,
                                                                                        DateTimeStyles.AllowWhiteSpaces, out Fdob))
        {
        }
        if (txtenddate2.Text.Trim() != "" && !DateTime.TryParseExact(txtenddate2.Text.Trim(), _dateFormat, info,
                                                                                              DateTimeStyles.AllowWhiteSpaces, out dob))
        {
        }
        DateTime EDT = dob;
        DateTime FDT = Fdob;


        SD = String.Format("{0:MM/dd/yyyy}", Fdob);
        ED = String.Format("{0:MM/dd/yyyy}", dob);
        if (drpClient.SelectedValue == "All")
        {
            drpjob.Items.Clear();
            drpjob.Items.Insert(0, "All");
            int c = int.Parse(ViewState["compid"].ToString());
            string f = txtstartdate1.Text;
            string t = txtenddate2.Text;
            string st = ddlStatus.SelectedValue;
            int s = int.Parse(hdnStaffCode.Value);
            BindExpList(c, f, t, st, s, 0, 0);
        }
        else
        {
            ss1 = "SELECT  distinct(jm.mjobname),j.jobid FROM ExpenseTs INNER JOIN TimeSheet_Table AS t ON ExpenseTs.TSId = t.TSId   inner join "
                + " Job_Master AS j ON t.JobId = j.JobId INNER JOIN JobName_Master AS jm ON jm.MJobId = j.mJobID INNER JOIN Client_Master AS c ON c.CLTId = t.CLTId "
                + "  where (CONVERT(date,t.date) between '" + SD + "' and '" + ED + "' )"
                + " and t.CLTId='" + drpClient.SelectedValue + "' and t.StaffCode='" + Session["staffid"].ToString() + "' order by jm.mjobname";
            DataTable dt1 = db.GetDataTable(ss1);
            if (dt1.Rows.Count != 0)
            {
                drpjob.Items.Clear();
                drpjob.DataSource = dt1;
                drpjob.DataBind();
                if (rbtn1.Checked == true)
                {
                    drpjob.Items.Insert(0, "All");
                }
                drpjob.SelectedIndex = 0;
                ViewState["Selval"] = drpjob.SelectedValue;

                int c = int.Parse(ViewState["compid"].ToString());
                string f = txtstartdate1.Text;
                string t = txtenddate2.Text;
                string st = ddlStatus.SelectedValue;
                int s = int.Parse(hdnStaffCode.Value);
                if (rbtn1.Checked == true)
                {
                }
                else
                {
                    int clt = int.Parse(drpClient.SelectedValue);
                    int j = int.Parse(drpjob.SelectedValue);
                    BindExpList(c, f, t, st, s, clt, j);
                }
            }
            else
            {
                ViewState["Selval"] = 0;
                //bindgridweek();
                drpjob.Items.Clear();
                drpjob.Items.Insert(0, "--None--");
            }
        }

        ViewState["selectedjob"] = drpjob.SelectedValue;
        ViewState["selectedclient"] = drpClient.SelectedValue;

    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        if (drpClient.SelectedValue == "" || drpClient.SelectedValue == "--None--")
        {  MessageControl1.SetMessage("Please select Client !", MessageDisplay.DisplayStyles.Error);
            return;
        }

        if (drpjob.SelectedValue == "0")
        {
            MessageControl1.SetMessage("Please select Job !", MessageDisplay.DisplayStyles.Error);
            return;
        }
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
        string id = "";



        foreach (DataListItem rw in DlstExp.Items)
        {
            Label lblId = (Label)rw.FindControl("Label50");
            decimal widd = decimal.Parse(lblId.Text);
            CheckBox chk = (CheckBox)rw.FindControl("chkitem");
            if (chk.Checked == true)
            {
                id += widd + ",";
            }
        }
        if (id != "")
        {
            id = id.Remove(id.Length - 1, 1);
        }

        if (id == "")
        {
            MessageControl1.SetMessage("Please select at least one Expense Voucher !", MessageDisplay.DisplayStyles.Error);
            return;
        }

        int comp = int.Parse(ViewState["compid"].ToString());
        DateTime FDT = Convert.ToDateTime(txtstartdate1.Text, info);
        DateTime EDT = Convert.ToDateTime(txtenddate2.Text, info);
        double clt = 0;
        double  j = 0;
        if (drpClient.SelectedValue == "All")
        {
            clt = 0;
            j = 0;
        }
        else
        {
             clt = Convert.ToInt16(drpClient.SelectedValue);
             j = Convert.ToInt16(drpjob.SelectedValue);
        }
        if (rbtn2.Checked == true)
        {
            ReportViewer1.ProcessingMode = ProcessingMode.Local;
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_Voucher.rdlc");
            DataSet_Exp dss = GetData(comp, FDT, EDT, clt, j, id);
            ReportDataSource datasource = new ReportDataSource("DataSet1", dss.Tables[0]);
            ReportViewer1.LocalReport.DataSources.Clear();
            ReportViewer1.LocalReport.DataSources.Add(datasource);
            ReportParameter[] parameters = new ReportParameter[8];
            parameters[0] = new ReportParameter("CompanyName", Convert.ToString(Session["CompanyName"]).Trim());
            parameters[1] = new ReportParameter("Period", ": " + FDT.ToString("dd/MM/yyyy").Trim() + " to " + EDT.ToString("dd/MM/yyyy").Trim());
            parameters[2] = new ReportParameter("ReportName", ": " + "Expense Voucher - " + (ddlStatus.SelectedValue == "All" ? "Saved, Submitted, Approved, Rejected" : ddlStatus.SelectedValue));
            parameters[3] = new ReportParameter("Client", ": " + Convert.ToString(drpClient.SelectedItem).Trim());
            parameters[4] = new ReportParameter("Job", ": " + Convert.ToString(drpjob.SelectedItem).Trim());
            parameters[5] = new ReportParameter("Staff", ": " + Convert.ToString(Session["fulname"]).Trim());
            parameters[6] = new ReportParameter("clientmaster", ": " + objlabelAccess.changelabel("Client", LtblAccess));
            parameters[7] = new ReportParameter("jobmaster", ": " + objlabelAccess.changelabel("Job Code", LtblAccess));


            this.ReportViewer1.LocalReport.SetParameters(parameters);
            ReportViewer1.LocalReport.DisplayName = "Expense Voucher - " + (ddlStatus.SelectedValue == "Both" ? "OnGoing, Compeleted" : ddlStatus.SelectedValue);
            ReportViewer1.LocalReport.Refresh();
            divReportInput.Visible = false;
            ReportViewer1.Visible = true;
            btnBack.Visible = true;
        }
        else
        {
            GetXLExport(comp, FDT, EDT, clt, j, id);
        }
    }

    private DataSet_Exp GetData(int comp, DateTime FromDAte, DateTime ToDate, double clt, double j, string id)
    {
        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        SqlCommand cmd = new SqlCommand("usp_report_ExpVoucher");
        cmd.Parameters.AddWithValue("@compid", comp);
        cmd.Parameters.AddWithValue("@FromDate", FromDAte);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        cmd.Parameters.AddWithValue("@Ids", id);
        cmd.Parameters.AddWithValue("@TStatus", ddlStatus.SelectedValue);
        cmd.Parameters.AddWithValue("@Staffcode", hdnStaffCode.Value);
        cmd.Parameters.AddWithValue("@CltID", clt);
        cmd.Parameters.AddWithValue("@JobID", j);     


        using (SqlConnection con = new SqlConnection(conString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                sda.SelectCommand = cmd;
                using (DataSet_Exp ds = new DataSet_Exp())
                {
                    sda.Fill(ds, "Datatable1");
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
    }
    protected void txtstartdate1_TextChanged(object sender, EventArgs e)
    {
        drpjob.Items.Clear(); 
        BindClient();
    }
    protected void txtenddate2_TextChanged(object sender, EventArgs e)
    {
        drpjob.Items.Clear();
        BindClient();
    }
    protected void drpClient_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindJob(); 
    }
    protected void drpjob_SelectedIndexChanged(object sender, EventArgs e)
    {
        int c = int.Parse(ViewState["compid"].ToString());
        string f = txtstartdate1.Text;
        string t = txtenddate2.Text;
        string st = ddlStatus.SelectedValue;
        int s = int.Parse(hdnStaffCode.Value);
        int clt = int.Parse(drpClient.SelectedValue);
        int j = int.Parse(drpjob.SelectedValue);
        BindExpList(c, f, t, st, s, clt, j); 
    }

    private void BindExpList(int c, string f, string t, string st, int s, double clt, double j)
    {
        try
        {
            string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            DataSet ds = new DataSet();

            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", c);
           
            param[1] = new SqlParameter("@FromDate", Convert.ToDateTime(f, ci));
            param[2] = new SqlParameter("@ToDate", Convert.ToDateTime(t, ci));
            param[3] = new SqlParameter("@TStatus", st);
            param[4] = new SqlParameter("@StaffCode", s);
            param[5] = new SqlParameter("@CltID", clt);
            param[6] = new SqlParameter("@JobID", j);
            ds = SqlHelper.ExecuteDataset(conString, CommandType.StoredProcedure, "usp_report_ExpVoucher_Name", param);
            DlstExp.DataSource = ds;
            DlstExp.DataBind();

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        double clt = 0;
        double j = 0;
        int c = int.Parse(ViewState["compid"].ToString());
        string f = txtstartdate1.Text;
        string t = txtenddate2.Text;
        string st = ddlStatus.SelectedValue;
        int s = int.Parse(hdnStaffCode.Value);
        if (drpClient.SelectedValue == "All")
        {
            clt=0;
            j=0;
        }
        else
        {
            if (drpClient.Text != "--None--")
            {

                clt = double.Parse(drpClient.SelectedValue);
                j = double.Parse(drpjob.SelectedValue);
            }
        }
        BindExpList(c, f, t, st, s, clt, j); 

    }
    protected void chkexp_CheckedChanged(object sender, EventArgs e)
    {
        if (chkexp.Checked == true)
        {
            foreach (DataListItem rw in DlstExp.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (chkexp.Checked == false)
        {
            foreach (DataListItem rw in DlstExp.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
        }
    }

    public void GetXLExport(int comp, DateTime FromDAte, DateTime ToDate, double clt, double j, string id)
    {
        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        SqlCommand cmd = new SqlCommand("usp_report_ExpVoucher_Register");
        cmd.Parameters.AddWithValue("@compid", comp);
        cmd.Parameters.AddWithValue("@FromDate", FromDAte);
        cmd.Parameters.AddWithValue("@ToDate", ToDate);
        cmd.Parameters.AddWithValue("@Ids", id);
        cmd.Parameters.AddWithValue("@TStatus", ddlStatus.SelectedValue);
        cmd.Parameters.AddWithValue("@Staffcode", hdnStaffCode.Value);
        cmd.Parameters.AddWithValue("@CltID", clt);
        cmd.Parameters.AddWithValue("@JobID", j);
        using (SqlConnection con = new SqlConnection(conString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                sda.SelectCommand = cmd;
                DataSet ds = new DataSet();
                
                sda.Fill(ds, "Datatable1");
                DataTable dt;
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    DumpExcel(dt);
                }
                else
                {
                    MessageBox.Show("No Records To EXPORT.");
                }

            }
        }

    }

    private void DumpExcel(DataTable tbl)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Voucher_Details");

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            ws.Cells["A1"].LoadFromDataTable(tbl, true);
            ws.Cells.AutoFitColumns();
            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:AI1"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            using (var memoryStream = new MemoryStream())
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=Voucher_Details.xls");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }



    protected void rbtn1_CheckedChanged(object sender, EventArgs e)
    {
        if (rbtn1.Checked == true)
        {
            rbtn2.Checked = false; 
            BindClient();

        }
    }
    protected void rbtn2_CheckedChanged(object sender, EventArgs e)
    {
        if (rbtn2.Checked == true)
        {
            rbtn1.Checked = false;
            BindClient();
        }
    }
}
