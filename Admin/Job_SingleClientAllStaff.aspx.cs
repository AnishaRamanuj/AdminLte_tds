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

public partial class Admin_Job_SingleClientAllStaff : System.Web.UI.Page
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
            bindcomp();
            string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            txtfrom.Text = dat;
            txtto.Text = dat; 
        }
        txtfrom.Attributes.Add("onblur", "checkForm();");

        txtto.Attributes.Add("onblur", "checkForms();");

    }
    public void bindcomp()
    {
        string ss = "select * from Company_Master order by CompanyName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            drpcomp.DataSource = dt;
            drpcomp.DataBind();
        }
    }
    protected void btngenerate1_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Job_SingleClientAllStaff.aspx";
            if (drpcomp.SelectedValue == "0" || drpjoblist.SelectedValue == "0" && txtfrom.Text == "" && txtto.Text == "")
            {
                MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
            else
            {
                int comp = int.Parse(drpcomp.SelectedValue);
                //if (drpjoblist.SelectedValue == "0" || drpjoblist.SelectedValue == "--None--")
                //{
                //    MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
                //}
                //else
                //{
                int clnt = int.Parse(drpjoblist.SelectedValue);
                string idstf = "";
                foreach (DataListItem rw in dlclient.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                    if (chk.Checked == true)
                    {
                        idstf += "'" + widd + "'" + ",";
                    }

                }
                if (idstf != "")
                {
                    idstf = idstf.Remove(idstf.Length - 1, 1);
                }
                string id = "";
                foreach (DataListItem rw in dlstaff.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        id += "'" + widd + "'" + ",";
                    }

                }
                if (id != "")
                {
                    id = id.Remove(id.Length - 1, 1);
                }


                CultureInfo info = new CultureInfo("en-US", false);
                DateTime Fdob = new DateTime(1900, 1, 1);
                DateTime dob = new DateTime(1900, 1, 1);
                String _dateFormat = "dd/MM/yyyy";
                if (txtfrom.Text.Trim() != "" && !DateTime.TryParseExact(txtfrom.Text.Trim(), _dateFormat, info,
                                                                                                     DateTimeStyles.AllowWhiteSpaces, out Fdob))
                {
                }
                if (txtto.Text.Trim() != "" && !DateTime.TryParseExact(txtto.Text.Trim(), _dateFormat, info,
                                                                                                      DateTimeStyles.AllowWhiteSpaces, out dob))
                {
                }
                string str1 = "select d.CLTId,d.ClientName,s.StaffCOde,s.StaffName  " +
                                " from dbo.TimeSheet_Table as t left join Staff_Master as s on s.StaffCode=t.StaffCode" +
                                " left join dbo.Client_Master as d on d.CLTId=t.CLTId" +
                                " where t.Status='Approved' and t.StaffCode in (" + id + ") and t.CLTId in (" + idstf + ") and t.JobId='" + drpjoblist.SelectedValue + "' and t.CompId='" + comp + "' and t.Date between '" + Fdob + "' and '" + dob + "'";

                DataTable dtavail = db.GetDataTable(str1);

                dlclient.DataSource = dtavail;
                dlclient.DataBind();
                dlstaff.DataSource = dtavail;
                dlstaff.DataBind();
                int stf = 0;
                //ArrayList[] ar= new Array[0];
                foreach (DataListItem rw in dlclient.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    int Cid = int.Parse(lblId.Text);
                    Label lblstaff = (Label)rw.FindControl("Label50");
                    string staff = lblstaff.Text;
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
                }
                Session["dtclient"] = dtclient;
                int joid = 0;
                foreach (DataListItem rw in dlstaff.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    int Cid = int.Parse(lblId.Text);
                    Label lbljob = (Label)rw.FindControl("Label50");
                    string job = lbljob.Text;
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
                }
                Session["dtstaff"] = dtstaff;
                string startdate = txtfrom.Text;
                string enddate = txtto.Text;
                Session["startdate"] = startdate;
                Session["enddate"] = enddate;
                string dd = dtclient.Rows.Count.ToString();
                string dd1 = dtstaff.Rows.Count.ToString();
                if (id == "" || idstf == "")
                {
                    chkclientbox.Checked = false;
                    chkstaffbox.Checked = false;
                    drpcomp_SelectedIndexChanged(sender, e);
                    MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
                }
                else if (dd == "0" || dd1 == "0")
                {
                    chkclientbox.Checked = false;
                    chkstaffbox.Checked = false;
                    drpcomp_SelectedIndexChanged(sender, e);
                    MessageControl2.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    Response.Redirect("~/report1.aspx?comp=" + comp + "&job=" + drpjoblist.SelectedValue + "&pagename=Job_SingleClientAllStaff");
                }
                // }
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void drpcomp_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ss = "select * from Job_Master where CompId='" + drpcomp.SelectedValue + "' order by JobName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            drpjoblist.Items.Clear();
            drpjoblist.DataSource = dt;
            drpjoblist.DataBind();
            //drpclient.Items.Remove("--None--");
        }
        else
        {
            drpjoblist.Items.Clear();
            drpjoblist.Items.Insert(0, "--None--");
        }
        string ss1 = "select * from Staff_Master where CompId='" + drpcomp.SelectedValue + "' order by StaffName";
        DataTable dt1 = db.GetDataTable(ss1);
        if (dt.Rows.Count != 0)
        {
            dlstaff.DataSource = dt1;
            dlstaff.DataBind();
            Label28.Visible = false;
        }
        else
        {
            //dlstaff.Items.Clear();
            //dlstaff.Items.Insert(0, "--None--");
            dlstaff.DataSource = null;
            dlstaff.DataBind();
            Label28.Visible = false;
        }
        string ss2 = "select * from Client_Master where CompId='" + drpcomp.SelectedValue + "' order by ClientName";
        DataTable dt2 = db.GetDataTable(ss2);
        if (dt.Rows.Count != 0)
        {
            dlclient.DataSource = dt2;
            dlclient.DataBind();
            Label31.Visible = false;
        }
        else
        {
            //dlclient.Items.Clear();
            //dlclient.Items.Insert(0, "--None--");
            dlclient.DataSource = null;
            dlclient.DataBind();
            Label31.Visible = false;
        }
    }
    protected void chkstaffbox_CheckedChanged(object sender, EventArgs e)
    {
        if (chkstaffbox.Checked == true)
        {
            foreach (DataListItem rw in dlstaff.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (chkstaffbox.Checked == false)
        {
            foreach (DataListItem rw in dlstaff.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
        }
    }
    protected void chkclientbox_CheckedChanged(object sender, EventArgs e)
    {
        if (chkclientbox.Checked == true)
        {
            foreach (DataListItem rw in dlclient.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (chkclientbox.Checked == false)
        {
            foreach (DataListItem rw in dlclient.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }
}

