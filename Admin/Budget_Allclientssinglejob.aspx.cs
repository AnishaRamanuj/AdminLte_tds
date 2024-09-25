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

public partial class Admin_Budget_Allclientssinglejob : System.Web.UI.Page
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
            drpbudcomp.DataSource = dt;
            drpbudcomp.DataBind();
            string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            txtfrmdt.Text = dat;
            txttodt.Text = dat; 

        }
        txtfrmdt.Attributes.Add("onblur", "checkForm();");

        txttodt.Attributes.Add("onblur", "checkForms();");
    }
    protected void drpbudcomp_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ss = "select * from Job_Master where CompId='" + drpbudcomp.SelectedValue + "' order by JobName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            dlbudjob.DataSource = dt;
            dlbudjob.DataBind();
            Label28.Visible = false;
        }
        else
        {
            dlbudjob.DataSource = null;
            dlbudjob.DataBind();
            Label28.Visible = false;

        }
        string ss2 = "select * from Client_Master where CompId='" + drpbudcomp.SelectedValue + "' order by ClientName";
        DataTable dt2 = db.GetDataTable(ss2);
        if (dt.Rows.Count != 0)
        {
            dlbudclient.DataSource = dt2;
            dlbudclient.DataBind();
            Label31.Visible = false;
        }
        else
        {
            dlbudclient.DataSource = null;
            dlbudclient.DataBind();
            Label31.Visible = false;
        }
    }
    protected void chkbudcl_CheckedChanged(object sender, EventArgs e)
    {
        if (chkbudcl.Checked == true)
        {
            foreach (DataListItem rw in dlbudclient.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (chkbudcl.Checked == false)
        {
            foreach (DataListItem rw in dlbudclient.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
        }
    }
    protected void chkbudjob_CheckedChanged(object sender, EventArgs e)
    {
        if (chkbudjob.Checked == true)
        {
            foreach (DataListItem rw in dlbudjob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (chkbudjob.Checked == false)
        {
            foreach (DataListItem rw in dlbudjob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }
    protected void btngrnreport_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Budget_Allclientssinglejob.aspx";
            if (drpbudcomp.SelectedValue == "0" || txtfrmdt.Text == "" || txttodt.Text == "")
            {
                MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
            else
            {
                int comp = int.Parse(drpbudcomp.SelectedValue);
                string id = "";
                foreach (DataListItem rw in dlbudclient.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label50");
                    decimal wid = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        id += "'" + wid + "'" + ",";
                    }
                }
                string id1 = "";
                foreach (DataListItem rw in dlbudjob.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label50");
                    decimal wid = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                    if (chk.Checked == true)
                    {
                        id1 += "'" + wid + "'" + ",";
                    }
                }
                if (id != "" && id1 != "")
                {
                    id = id.Remove(id.Length - 1, 1);
                    id1 = id1.Remove(id1.Length - 1, 1);
                    CultureInfo info = new CultureInfo("en-US", false);
                    DateTime Fdob = new DateTime(1900, 1, 1);
                    DateTime dob = new DateTime(1900, 1, 1);
                    String _dateFormat = "dd/MM/yyyy";
                    if (txtfrmdt.Text.Trim() != "" && !DateTime.TryParseExact(txtfrmdt.Text.Trim(), _dateFormat, info,
                                                                                                         DateTimeStyles.AllowWhiteSpaces, out Fdob))
                    {
                    }
                    if (txttodt.Text.Trim() != "" && !DateTime.TryParseExact(txttodt.Text.Trim(), _dateFormat, info,
                                                                                                          DateTimeStyles.AllowWhiteSpaces, out dob))
                    {
                    }
                    string str1 = " select distinct j.JobId,j.CreationDate as Date,j.CompId,j.jobName,j.BudHours,j.BudAMt,j.ActualHours,j.ActualAmt,c.ClientName,c.CLTId " +
                                  "  from dbo.job_Master as j inner join Client_Master as c on c.CLTId=j.CLTId " +
                                  "  where c.CLTId in (" + id + ") and j.JobId in (" + id1 + ") and j.CreationDate between '" + Fdob + "' and '" + dob + "' and convert(float,j.BudAMt) > 0.0 ";
                    DataTable dtavail = db.GetDataTable(str1);

                    dlbudclient.DataSource = dtavail;
                    dlbudclient.DataBind();
                    dlbudjob.DataSource = dtavail;
                    dlbudjob.DataBind();
                    int stf = 0;
                    //ArrayList[] ar= new Array[0];
                    foreach (DataListItem rw in dlbudclient.Items)
                    {
                        Label lblId = (Label)rw.FindControl("Label50");
                        int Cid = int.Parse(lblId.Text);
                        Label lblstaff = (Label)rw.FindControl("Label51");
                        string staff = lblstaff.Text;
                        CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                        //if (chk.Checked == true)
                        //{
                        stf = Cid;
                        if (dtclient == null || dtclient.Rows.Count == 0)
                        {
                            dtclient.Columns.Add("CLTId", System.Type.GetType("System.String"));
                            dtclient.Columns.Add("ClientName", System.Type.GetType("System.String"));
                            DataRow dr = dtclient.NewRow();
                            dr["CLTId"] = Cid;
                            dr["ClientName"] = staff;
                            dtclient.Rows.Add(dr);
                            dtclient.AcceptChanges();
                        }
                        else
                        {
                            DataRow dr = dtclient.NewRow();
                            dr["CLTId"] = Cid;
                            dr["ClientName"] = staff;
                            dtclient.Rows.Add(dr);
                            dtclient.AcceptChanges();
                        }
                        //}
                    }
                    Session["dtclient"] = dtclient;
                    int joid = 0;
                    foreach (DataListItem rw in dlbudjob.Items)
                    {
                        Label lblId = (Label)rw.FindControl("Label50");
                        int Cid = int.Parse(lblId.Text);
                        Label lbljob = (Label)rw.FindControl("Label51");
                        string job = lbljob.Text;
                        CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                        //if (chk.Checked == true)
                        //{
                        joid = Cid;
                        if (dtjob == null || dtjob.Rows.Count == 0)
                        {
                            dtjob.Columns.Add("JobId", System.Type.GetType("System.String"));
                            dtjob.Columns.Add("JobName", System.Type.GetType("System.String"));
                            DataRow dr = dtjob.NewRow();
                            dr["JobId"] = Cid;
                            dr["JobName"] = job;
                            dtjob.Rows.Add(dr);
                            dtjob.AcceptChanges();
                        }
                        else
                        {
                            DataRow dr = dtjob.NewRow();
                            dr["JobId"] = Cid;
                            dr["JobName"] = job;
                            dtjob.Rows.Add(dr);
                            dtjob.AcceptChanges();
                        }
                        // }
                    }
                    Session["dtjob"] = dtjob;
                    string startdate = txtfrmdt.Text;
                    string enddate = txttodt.Text;
                    Session["startdate"] = startdate;
                    Session["enddate"] = enddate;
                    string dd = dtclient.Rows.Count.ToString();
                    string dd1 = dtjob.Rows.Count.ToString();
                    if (dd == "0" || dd1 == "0")
                    {
                        chkbudcl.Checked = false;
                        chkbudjob.Checked = false;
                        drpbudcomp_SelectedIndexChanged(sender, e);
                        MessageControl2.SetMessage("No Records Found.No Budget Amount Exists", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
                        Response.Redirect("~/report1.aspx?comp=" + comp + "&pagename=Budget_AllclientsSinglejob");
                    }
                }
                else
                {
                    MessageControl2.SetMessage("No Client/Job Selected", MessageDisplay.DisplayStyles.Error);
                }
            }

        }
        catch (Exception ex)
        {

        }
    }
}
