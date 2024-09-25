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

public partial class Admin_Client_SingleJobGroupAllJobs : System.Web.UI.Page
{
     private readonly DBAccess db = new DBAccess();
    private readonly JobMaster job = new JobMaster();
    JobStaffTable jobstaff = new JobStaffTable();
    StaffMaster staff = new StaffMaster();
    CompanyMaster compd = new CompanyMaster();
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
            bindcomp();
            string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            fromdate.Text = dat;
            txtenddate.Text = dat; 

        }
        fromdate.Attributes.Add("onblur", "checkForm();");
        txtenddate.Attributes.Add("onblur", "checkForms();");
 
    }
    public void bindcomp()
    {
        string ss = "select * from Company_Master order by CompanyName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            drpcompany.DataSource = dt;
            drpcompany.DataBind();
        }
    }
    public void bindjobgroup()
    {
        string ss = "select * from JobGroup_Master where CompId='" + drpcompany.SelectedValue + "'";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            DataList7.DataSource = dt;
            DataList7.DataBind();
            Label78.Visible = false;
            //drpclient.Items.Remove("--None--");
        }
        else
        {
            DataList7.DataSource = null;
            Label78.Visible = false;
        }
    }
    protected void chkjobgrp_CheckedChanged(object sender, EventArgs e)
    {
        if (chkjobgrp.Checked == true)
        {
            foreach (DataListItem rw in DataList7.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (chkjobgrp.Checked == false)
        {
            foreach (DataListItem rw in DataList7.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
        }
    }
    protected void btngenerate_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Client_SingleJobGroupAllJobs.aspx";
            if (drpcompany.SelectedValue != "0" && drpclient.SelectedValue != "0" && txtenddate.Text != "" && fromdate.Text != "")
            {
                string idstf = "";
                int comp = int.Parse(drpcompany.SelectedValue);
                foreach (DataListItem rw in DataList7.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        idstf += "'" + widd + "'" + ",";
                    }

                }
                if (idstf != "")
                {
                    idstf = idstf.Remove(idstf.Length - 1, 1);
                }
                CultureInfo info = new CultureInfo("en-US", false);
                DateTime Fdob = new DateTime(1900, 1, 1);
                DateTime dob = new DateTime(1900, 1, 1);
                String _dateFormat = "dd/MM/yyyy";
                if (fromdate.Text.Trim() != "" && !DateTime.TryParseExact(fromdate.Text.Trim(), _dateFormat, info,
                                                                                                     DateTimeStyles.AllowWhiteSpaces, out Fdob))
                {
                }
                if (txtenddate.Text.Trim() != "" && !DateTime.TryParseExact(txtenddate.Text.Trim(), _dateFormat, info,
                                                                                                      DateTimeStyles.AllowWhiteSpaces, out dob))
                {
                }
                string str = "select j.JobName,jg.JobGId,jg.JobGroupName " +
                                            " from Job_Master as j  " +
                                            " left join dbo.JobGroup_Master as jg on jg.JobGId=j.JobGId where" +
                                            " j.CLTId='" + drpclient.SelectedValue + "' and j.JobGId in (" + idstf + ") and j.CompId='" + comp + "'";

                DataTable dtavail = db.GetDataTable(str);
                //if (dtavail.Rows.Count > 0)
                //{
                DataList7.DataSource = dtavail;
                DataList7.DataBind();

                int jobgrp = 0;
                foreach (DataListItem rw in DataList7.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    int Cid = int.Parse(lblId.Text);
                    Label lbljob = (Label)rw.FindControl("Label50");
                    string job = lbljob.Text;
                    jobgrp = Cid;
                    if (dtjobgrp == null || dtjobgrp.Rows.Count == 0)
                    {
                        dtjobgrp.Columns.Add("JobGId", System.Type.GetType("System.String"));
                        dtjobgrp.Columns.Add("JobGroupName", System.Type.GetType("System.String"));
                        DataRow dr = dtjobgrp.NewRow();
                        dr["JobGId"] = Cid;
                        dr["JobGroupName"] = job;
                        dtjobgrp.Rows.Add(dr);
                        dtjobgrp.AcceptChanges();

                    }
                    else
                    {
                        DataRow dr = dtjobgrp.NewRow();
                        dr["JobGId"] = Cid;
                        dr["JobGroupName"] = job;
                        dtjobgrp.Rows.Add(dr);
                        dtjobgrp.AcceptChanges();
                    }
                }
                string startdate = fromdate.Text;
                string enddate = txtenddate.Text;
                Session["startdate"] = startdate;
                Session["enddate"] = enddate;
                Session["dtjobgrp"] = dtjobgrp;
                dtclient.Columns.Add("CLTId", System.Type.GetType("System.String"));
                dtclient.Columns.Add("ClientName", System.Type.GetType("System.String"));
                DataRow dr1 = dtclient.NewRow();
                dr1["CLTId"] = drpclient.SelectedValue;
                dr1["ClientName"] = drpclient.SelectedItem.Text;
                dtclient.Rows.Add(dr1);
                dtclient.AcceptChanges();
                Session["dtclient"] = dtclient;
                int clnt = int.Parse(drpclient.SelectedValue);
                if (idstf == "")
                {
                    chkjobgrp.Checked = false;
                    drpcompany_SelectedIndexChanged(sender, e);
                    MessageControl2.SetMessage("No Job Group Selected.", MessageDisplay.DisplayStyles.Error);
                }
                else if (dtjobgrp.Rows.Count == 0)
                {
                    chkjobgrp.Checked = false;
                    drpcompany_SelectedIndexChanged(sender, e);
                    MessageControl2.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    Response.Redirect("~/report1.aspx?comp=" + comp + "&clnt=" + clnt + "&pagename=JobGroup");
                }
            }
            else
            {
                MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindjobgroup();
        bindclient();
    }
    public void bindclient()
    {
        string ss = "select * from Client_Master where CompId='" + drpcompany.SelectedValue + "' order by ClientName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            drpclient.Items.Clear();
            drpclient.DataSource = dt;
            drpclient.DataBind();
            //drpclient.Items.Remove("--None--");
        }
        else
        {
            drpclient.Items.Clear();
            drpclient.Items.Insert(0, "--None--");
        }
    }
}

