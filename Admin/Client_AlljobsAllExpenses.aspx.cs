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


public partial class Admin_Client_AlljobsAllExpenses : System.Web.UI.Page
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
            Session["URL"] = "Admin/Client_AlljobsAllExpenses.aspx";
            if (drpclient.SelectedValue != "0" && drpcompany.SelectedValue != "0" && txtenddate.Text != "" && fromdate.Text != "")
            {
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

                string str = "select t.TSId,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.OpeAmt as ope,ope.OPEName,j.JobName " +
                                " from dbo.TimeSheet_Table as t left join Job_Master as j on j.JobId=t.JobId " +
                                " left join dbo.OPE_Master as ope on ope.OpeId=t.OpeId" +
                                " where t.Status='Approved' and t.CLTId='" + drpclient.SelectedValue + "' and t.CompId='" + drpcompany.SelectedValue + "' and t.Date between '" + Fdob + "' and '" + dob + "' and convert(float,t.OpeAmt) > 0.0";

                DataTable dtavail = db.GetDataTable(str);
                if (dtavail.Rows.Count == 0)
                {
                    MessageControl2.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    string startdate = fromdate.Text;
                    string enddate = txtenddate.Text;
                    Session["startdate"] = startdate;
                    Session["enddate"] = enddate;
                    dtclient.Columns.Add("CLTId", System.Type.GetType("System.String"));
                    dtclient.Columns.Add("ClientName", System.Type.GetType("System.String"));
                    DataRow dr = dtclient.NewRow();
                    dr["CLTId"] = drpclient.SelectedValue;
                    dr["ClientName"] = drpclient.SelectedItem.Text;
                    dtclient.Rows.Add(dr);
                    dtclient.AcceptChanges();
                    Session["dtclient"] = dtclient;
                    int clnt = int.Parse(drpclient.SelectedValue);
                    int comp = int.Parse(drpcompany.SelectedValue);
                    Response.Redirect("~/report1.aspx?comp=" + comp + "&clnt=" + clnt + "&pagename=AlljobsAllExpenses");
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