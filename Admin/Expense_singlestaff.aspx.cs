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

public partial class Admin_Expense_singlestaff : System.Web.UI.Page
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
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string ss = "select * from Company_Master order by CompanyName";
            DataTable dt = db.GetDataTable(ss);
            drpopecmp.DataSource = dt;
            drpopecmp.DataBind();
            string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            txtfr.Text = dat;
            txtend.Text = dat; 

        }
        txtfr.Attributes.Add("onblur", "checkForm();");

        txtend.Attributes.Add("onblur", "checkForms();");

    }
    protected void drpopecmp_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ss1 = "select * from Staff_Master where CompId='" + drpopecmp.SelectedValue + "' order by StaffName";
        DataTable dt1 = db.GetDataTable(ss1);
        if (dt1.Rows.Count != 0)
        {
            DataList4.DataSource = dt1;
            DataList4.DataBind();
            Label7.Visible = false;
        }
        else
        {
            DataList4.DataSource = null;
            DataList4.DataBind();
            Label7.Visible = false;
        }      
    }
    protected void btngenexp_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Expense_singlestaff.aspx";
            if (drpopecmp.SelectedValue == "0" || txtfr.Text == "" || txtend.Text == "")
            {
                MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
            else
            {
                int comp = int.Parse(drpopecmp.SelectedValue);
                Session["dtclient"] = null;
                string id = "";
                foreach (DataListItem rw in DataList4.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label50");
                    decimal wid = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        id += "'" + wid + "'" + ",";
                    }
                }
                if (id != "")
                {
                    id = id.Remove(id.Length - 1, 1);
                    CultureInfo info = new CultureInfo("en-US", false);
                    DateTime Fdob = new DateTime(1900, 1, 1);
                    DateTime dob = new DateTime(1900, 1, 1);
                    String _dateFormat = "dd/MM/yyyy";
                    if (txtfr.Text.Trim() != "" && !DateTime.TryParseExact(txtfr.Text.Trim(), _dateFormat, info,
                                                                                                         DateTimeStyles.AllowWhiteSpaces, out Fdob))
                    {
                    }
                    if (txtend.Text.Trim() != "" && !DateTime.TryParseExact(txtend.Text.Trim(), _dateFormat, info,
                                                                                                          DateTimeStyles.AllowWhiteSpaces, out dob))
                    {
                    }

                    string str1 = " select t.mints,t.CompId,t.StaffCode,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.Date as Date1,t.OpeAmt as ope,ope.OPEName,s.StaffName " +
                                " from dbo.TimeSheet_Table as t " +
                                " inner join dbo.Staff_Master as s on s.StaffCode=t.StaffCode " +
                                " left join dbo.OPE_Master as ope on ope.OpeId=t.OpeId " +
                                " where t.Status='Approved' and t.StaffCode in (" + id + ") and t.Date between '" + Fdob + "' and '" + dob + "' and convert(float,t.OpeAmt) > 0.0 ";
                    DataTable dtavail = db.GetDataTable(str1);

                    DataList4.DataSource = dtavail;
                    DataList4.DataBind();
                    int joid = 0;
                    Session["dtjob"] = null;
                    foreach (DataListItem rw in DataList4.Items)
                    {
                        Label lblId = (Label)rw.FindControl("Label50");
                        int Cid = int.Parse(lblId.Text);
                        Label lbljob = (Label)rw.FindControl("Label51");
                        string job = lbljob.Text;
                        CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                        //if (chk.Checked == true)
                        //{
                        joid = Cid;
                        if (dtstaff == null || dtstaff.Rows.Count == 0)
                        {
                            dtstaff.Columns.Add("StaffCode", System.Type.GetType("System.String"));
                            dtstaff.Columns.Add("StaffName", System.Type.GetType("System.String"));
                            DataRow dr = dtstaff.NewRow();
                            dr["StaffCode"] = Cid;
                            dr["StaffName"] = job;
                            dtstaff.Rows.Add(dr);
                            dtstaff.AcceptChanges();
                        }
                        else
                        {
                            DataRow dr = dtstaff.NewRow();
                            dr["StaffCode"] = Cid;
                            dr["StaffName"] = job;
                            dtstaff.Rows.Add(dr);
                            dtstaff.AcceptChanges();
                        }
                        //}
                    }
                    Session["dtstaff"] = dtstaff;
                    string startdate = txtfr.Text;
                    string enddate = txtend.Text;
                    Session["startdate"] = startdate;
                    Session["enddate"] = enddate;
                    string dd = dtclient.Rows.Count.ToString();
                    string dd1 = dtjob.Rows.Count.ToString();
                    string dd2 = dtstaff.Rows.Count.ToString();
                    if (dd2 == "0")
                    {
                        chkstope.Checked = false;
                        drpopecmp_SelectedIndexChanged(sender, e);
                        MessageControl2.SetMessage("No Record Found.No Expense Amount Exists", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
                        Response.Redirect("~/report1.aspx?comp=" + comp + "&pagename=Expense_AllStaffs");
                    }
                }
                else
                {
                    MessageControl2.SetMessage("No Staff Selected.", MessageDisplay.DisplayStyles.Error);
                }
            }
        }
        catch (Exception ex)
        {

        }
    }  
    protected void chkstope_CheckedChanged(object sender, EventArgs e)
    {
        if (chkstope.Checked == true)
        {
            foreach (DataListItem rw in DataList4.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (chkstope.Checked == false)
        {
            foreach (DataListItem rw in DataList4.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
        }
    }
}
