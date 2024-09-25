using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CommonLibrary;
using System.Data;
using Microsoft.Reporting.WebForms;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;

public partial class controls_StaffExpense : System.Web.UI.UserControl
{
    public string UserType = "";
    DAL_RepotStaffExpense objDAL_RepotStaffExpense = new DAL_RepotStaffExpense();
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
                hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
            if (Session["usertype"] != null)
            {
                UserType = Session["usertype"].ToString();
            }
            else
            { Session["companyid"] = null; Session["companyid"] = null; }
            hdnUserType.Value = UserType;
            if (UserType == "staff")
            {
                hdnStaffCode.Value = Session["staffid"].ToString();
            }

            if (UserType == "staff")
            {
                if (Session["Jr_ApproverId"].ToString() == "true")
                {
                    Session["StaffType"] = "App";
                }
            }
            if (string.IsNullOrEmpty(hdnStaffCode.Value)) hdnStaffCode.Value = "0";

            if (string.IsNullOrEmpty(hdnUserType.Value)) hdnUserType.Value = "";

            txtstartdate1.Text = "01/04/" + (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year);
            txtEndDate.Text = Convert.ToDateTime(DateTime.Now, info).ToString("dd/MM/yyyy");

            BindStaffRelatedExpense();
        }
    }

    private void BindStaffRelatedExpense()
    {
        try
        {
            List<tbl_StaffMaster> tblStaff = objDAL_RepotStaffExpense.DAL_GetExpenseStaff(Convert.ToInt32(hdnCompid.Value), Convert.ToInt32(hdnStaffCode.Value), hdnUserType.Value, string.Join(",", GetTimesheetStatus()).ToString(), txtstartdate1.Text, txtEndDate.Text);
            Label2.Text = "Staff Name (" + tblStaff.Count + ")";
            chksStaff.DataSource = tblStaff;
            chksStaff.DataValueField = "StaffCode";
            chksStaff.DataTextField = "StaffName";
            chksStaff.DataBind();
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }
    }

    private List<string> GetTimesheetStatus()
    {
        List<string> ExpensesStatus = new List<string>();

        if (chkSaved.Checked) ExpensesStatus.Add("Saved");
        if (chkSubmitted.Checked) ExpensesStatus.Add("Submitted");
        if (chkApproved.Checked) ExpensesStatus.Add("Approved");
        if (chkRejected.Checked) ExpensesStatus.Add("Rejected");

        return ExpensesStatus;
    }

    private void BindExpenseDropDown()
    {
        //    List<Expenses> tblExpense = objDAL_RepotStaffExpense.DAL_GetExpenseNames(Convert.ToInt32(hdnCompid.Value));
        //    ddlExpense.DataSource = tblExpense;
        //    ddlExpense.DataValueField = "ExpenseId";
        //    ddlExpense.DataTextField = "ExpenseName";
        //    ddlExpense.DataBind();
        //    ddlExpense.Items.Insert(0, new ListItem("All"));
    }
    protected void chkSubmitted_CheckedChanged(object sender, EventArgs e)
    {
        BindStaffRelatedExpense();
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        LabelAccess objlabelAccess = new LabelAccess();

        List<tbl_LabelAccess> LtblAccess;

        List<string> selectedValues = chksStaff.Items.Cast<ListItem>().Where(li => li.Selected).Select(li => li.Value).ToList();

        if (selectedValues.Count == 0)
        {
            MessageControl1.SetMessage("Please select at least on staff", MessageDisplay.DisplayStyles.Error);
            return;
        }
        ////companyid
        ////timesheet status
        ////selected staff
        //List<Expenses> tblExpenses = objDAL_RepotStaffExpense.DAL_GetSaffWiseExpensesdetails(Convert.ToInt32(hdnCompid.Value), string.Join(",", GetTimesheetStatus()).ToString(), string.Join(",", selectedValues).ToString());
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));

        ReportViewer1.ProcessingMode = ProcessingMode.Local;
        ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/ReportStaffExpense.rdlc");
        DataSet_StaffExpense dsss = GetData(Convert.ToInt32(hdnCompid.Value), string.Join(",", GetTimesheetStatus()).ToString(), string.Join(",", selectedValues).ToString());
        ReportDataSource datasource = new ReportDataSource("DataSet", dsss.Tables[0]);
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.LocalReport.DataSources.Add(datasource);
        ReportParameter[] parameters = new ReportParameter[6];
        parameters[0] = new ReportParameter("CompanyName", Convert.ToString(Session["CompanyName"]).Trim());
        parameters[1] = new ReportParameter("PrintedBy", ": " + Convert.ToString(Session["Name"]).Trim());
        parameters[2] = new ReportParameter("ReportName", ": " + objlabelAccess.changelabel("Staff Expense", LtblAccess));
        parameters[3] = new ReportParameter("staffNameHeader", objlabelAccess.changelabel("Staff Name", LtblAccess));
        parameters[4] = new ReportParameter("JobNameHeader", objlabelAccess.changelabel("Job Name", LtblAccess));
        parameters[5] = new ReportParameter("Period", ": " + txtstartdate1.Text + " To " + txtEndDate.Text);
        //parameters[6] = new ReportParameter("designationhearder", objlabelAccess.changelabel("Designation Name", LtblAccess));

        this.ReportViewer1.LocalReport.SetParameters(parameters);
        ReportViewer1.LocalReport.DisplayName = objlabelAccess.changelabel("Staff Expense", LtblAccess);
        ReportViewer1.LocalReport.Refresh();
        divReportInput.Visible = false;
        ReportViewer1.Visible = true;
        btnBack.Visible = true;
    }
    private DataSet_StaffExpense GetData(int Compid, string timesheetStaus, string StaffIDs)
    {
        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        SqlCommand cmd = new SqlCommand("usp_GetSaffWiseExpensesdetails");
        cmd.Parameters.AddWithValue("@compid", Compid);
        cmd.Parameters.AddWithValue("@timesheetStaus", timesheetStaus);
        cmd.Parameters.AddWithValue("@StaffIDs", StaffIDs);
        cmd.Parameters.AddWithValue("@StartDate", Convert.ToDateTime(txtstartdate1.Text, info));
        cmd.Parameters.AddWithValue("@EndDate", Convert.ToDateTime(txtEndDate.Text, info));
        cmd.CommandType = CommandType.StoredProcedure;
        using (SqlConnection con = new SqlConnection(conString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                sda.SelectCommand = cmd;
                using (DataSet_StaffExpense ds = new DataSet_StaffExpense())
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
    }
    protected void txtstartdate1_TextChanged(object sender, EventArgs e)
    {
        BindStaffRelatedExpense();
    }
    protected void txtEndDate_TextChanged(object sender, EventArgs e)
    {
        BindStaffRelatedExpense();
    }
}