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

public partial class Admin_Client_AllJobSingleStaff : System.Web.UI.Page
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
            bindclient();
            bindstaff();
            bindjob();
            Label7.Visible = false;
            Label8.Visible = false;
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
    protected void btngenerate_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Client_AllJobSingleStaff.aspx";
            if (drpcompany.SelectedValue == "0" || drpcompany.SelectedValue == "--Select--")
            {
                MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
            else
            {
                int comp = int.Parse(drpcompany.SelectedValue);
                if (drpclient.SelectedValue == "0" || drpclient.SelectedValue == "--None--")
                {
                    MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    int clnt = int.Parse(drpclient.SelectedValue);
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

                    string id = "";
                    foreach (DataListItem rw in DataList2.Items)
                    {
                        Label lblId = (Label)rw.FindControl("Label51");
                        decimal wid = decimal.Parse(lblId.Text);
                        CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                        if (chk.Checked == true)
                        {
                            id += "'" + wid + "'" + ",";
                        }

                    }
                    if (id != "")
                    {
                        id = id.Remove(id.Length - 1, 1);
                    }
                    string idstf = "";
                    foreach (DataListItem rw in DataList1.Items)
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
                    string str = "select t.TSId,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.TotalTime as time1,s.StaffCode,s.StaffName,t.JobId,j.JobName,t.OpeAmt as ope,ope.OPEName,nar.NarrationName,isnull(t.HourlyCharges,0) as charges,isnull(sum(t.HourlyCharges+t.OpeAmt),0) as chope  " +
                        " from dbo.TimeSheet_Table as t left join Staff_Master as s on s.StaffCode=t.StaffCode" +
                        " left join dbo.OPE_Master as ope on ope.OpeId=t.OpeId" +
                        " left join dbo.Narration_Master as nar on nar.NarId=t.NarId" +
                        " left join dbo.Designation_Master as d on d.DsgId=s.DsgId" +
                        " left join dbo.Job_Master as j on j.JobId=t.JobId" +
                        " where t.Status='Approved' and t.jobId in (" + id + ") and t.CLTId='" + clnt + "' and t.staffCode in (" + idstf + ") and t.CompId='" + comp + "' and t.Date between '" + Fdob + "' and '" + dob + "' group by t.TSId,t.Date,t.TotalTime,t.OpeAmt,ope.OPEName,nar.NarrationName,t.HourlyCharges,t.JobId,j.JobName,s.StaffCode,s.StaffName";

                    DataTable dtavail = db.GetDataTable(str);


                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    DataList2.DataSource = dtavail;
                    DataList2.DataBind();
                    DataList1.DataSource = dtavail;
                    DataList1.DataBind();
                    int stf = 0;
                    //ArrayList[] ar= new Array[0];
                    foreach (DataListItem rw in DataList1.Items)
                    {
                        Label lblId = (Label)rw.FindControl("Label51");
                        int Cid = int.Parse(lblId.Text);
                        Label lblstaff = (Label)rw.FindControl("Label50");
                        string staff = lblstaff.Text;
                        stf = Cid;
                        if (dtstaff == null || dtstaff.Rows.Count == 0)
                        {
                            dtstaff.Columns.Add("StaffCode", System.Type.GetType("System.String"));
                            dtstaff.Columns.Add("StaffName", System.Type.GetType("System.String"));
                            DataRow dr = dtstaff.NewRow();
                            dr["StaffCode"] = Cid;
                            dr["StaffName"] = staff;
                            dtstaff.Rows.Add(dr);
                            dtstaff.AcceptChanges();
                        }
                        else
                        {
                            DataRow dr = dtstaff.NewRow();
                            dr["StaffCode"] = Cid;
                            dr["StaffName"] = staff;
                            dtstaff.Rows.Add(dr);
                            dtstaff.AcceptChanges();
                        }
                    }
                    Session["dtstaff"] = dtstaff;
                    int joid = 0;
                    foreach (DataListItem rw in DataList2.Items)
                    {
                        Label lblId = (Label)rw.FindControl("Label51");
                        int Cid = int.Parse(lblId.Text);
                        Label lbljob = (Label)rw.FindControl("Label50");
                        string job = lbljob.Text;
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
                    }
                    Session["dtjob"] = dtjob;
                    string startdate = fromdate.Text;
                    string enddate = txtenddate.Text;
                    Session["startdate"] = startdate;
                    Session["enddate"] = enddate;
                    string dd = dtstaff.Rows.Count.ToString();
                    string dd1 = dtjob.Rows.Count.ToString();

                    if (id == "")
                    {
                        chkstaff.Checked = false;
                        chkjob.Checked = false;
                        drpcompany_SelectedIndexChanged(sender, e);
                        MessageControl2.SetMessage("No Jobs Selected.", MessageDisplay.DisplayStyles.Error);
                    }
                    else if (idstf == "")
                    {
                        chkstaff.Checked = false;
                        chkjob.Checked = false;
                        drpcompany_SelectedIndexChanged(sender, e);
                        MessageControl2.SetMessage("No Staffs Selected.", MessageDisplay.DisplayStyles.Error);
                    }
                    else if (dd == "0" && dd1 == "0")
                    {
                        chkstaff.Checked = false;
                        chkjob.Checked = false;
                        drpcompany_SelectedIndexChanged(sender, e);
                        MessageControl2.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                    }
                    else if (drpclient.SelectedValue == "0" || startdate == "" || enddate == "")
                    {
                        chkstaff.Checked = false;
                        chkjob.Checked = false;
                        drpcompany_SelectedIndexChanged(sender, e);
                        MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
                        Response.Redirect("~/report1.aspx?comp=" + comp + "&clnt=" + clnt + "&pagename=AllJobSingleStaff");
                    }


                    //if (dd == "0" && dd1 == "0" || drpcompany.SelectedValue == "0" || drpclient.SelectedValue == "0" || startdate == "" || enddate == "")
                    //{
                    //    MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
                    //}
                    //else
                    //{
                    //    Response.Redirect("Client_Reports.aspx?comp=" + comp + "&clnt=" + clnt);
                    //}
                }
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindclient();
        bindstaff();
        bindjob();
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
    public void bindstaff()
    {
        string ss = "select * from Staff_Master where CompId='" + drpcompany.SelectedValue + "' order by StaffName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            DataList1.DataSource = dt;
            DataList1.DataBind();
            Label7.Visible = false;
        }
        else
        {
            DataList1.DataSource = null;
            DataList1.DataBind();
            Label7.Visible = false;
        }
    }
    public void bindjob()
    {
        string ss = "select * from Job_Master where CompId='" + drpcompany.SelectedValue + "' order by JobName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            DataList2.DataSource = dt;
            DataList2.DataBind();
            Label8.Visible = false;
        }
        else
        {
            DataList2.DataSource = null;
            DataList2.DataBind();
            Label8.Visible = false;
        }
    }
    protected void chkstaff_CheckedChanged(object sender, EventArgs e)
    {
        if (chkstaff.Checked == true)
        {
            foreach (DataListItem rw in DataList1.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (chkstaff.Checked == false)
        {
            foreach (DataListItem rw in DataList1.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
        }
    }
    protected void chkjob_CheckedChanged(object sender, EventArgs e)
    {
        if (chkjob.Checked == true)
        {
            foreach (DataListItem rw in DataList2.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (chkjob.Checked == false)
        {
            foreach (DataListItem rw in DataList2.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }
}
