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
using System.Globalization;
using JTMSProject;

public partial class Admin_Staff_AllClientsAllJobsHoursConsumed : System.Web.UI.Page
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
            if (dt.Rows.Count != 0)
            {
                drpcompanylist.DataSource = dt;
                drpcompanylist.DataBind();
            }
            string dat = DateTime.Now.Month + "/" + DateTime.Now.Year;
            txtstartdate1.Text = dat;
           // txtenddate2.Text = dat; 

        }
        txtstartdate1.Attributes.Add("onblur", "checkForm();");

       // txtenddate2.Attributes.Add("readonly", "readonly");

    }
    public void bindstaff()
    {
        string ss = "select * from Staff_Master where CompId='" + drpcompanylist.SelectedValue + "' order by StaffName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            drpstafflist.Items.Clear();
            drpstafflist.DataSource = dt;
            drpstafflist.DataBind();
        }
        else
        {
            drpstafflist.Items.Clear();
            drpstafflist.Items.Insert(0, "--None--");
        }
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Staff_AllClientsAllJobsHoursConsumed.aspx";
            if (drpstafflist.SelectedValue != "0" && drpcompanylist.SelectedValue != "0")
            {
                int ss = int.Parse(drpstafflist.SelectedValue);
                int comp = int.Parse(drpcompanylist.SelectedValue);
                string startdate = txtstartdate1.Text;
                DateTime date = Convert.ToDateTime(txtstartdate1.Text);
                DateTime startDate = date;
                DateTime lastdate = DateTime.Now;
                DateTime endDate = startDate.AddMonths(1).AddDays(-1);
                //string startdate = txtstartdate1.Text;
                //string enddate = txtenddate2.Text;
                //Session["startdate"] = startdate;
                //Session["enddate"] = enddate;
                //CultureInfo info = new CultureInfo("en-US", false);
                //DateTime Fdob = new DateTime(1900, 1, 1);
                //DateTime dob = new DateTime(1900, 1, 1);
                //String _dateFormat = "dd/MM/yyyy";
                //if (Session["startdate"] != null && Session["enddate"] != null)
                //{
                //    if (Session["startdate"].ToString().Trim() != "" && !DateTime.TryParseExact(Session["startdate"].ToString().Trim(), _dateFormat, info,
                //                                                                                           DateTimeStyles.AllowWhiteSpaces, out Fdob))
                //    {
                //    }
                //    if (Session["enddate"].ToString().Trim() != "" && !DateTime.TryParseExact(Session["enddate"].ToString().Trim(), _dateFormat, info,
                //                                                                                          DateTimeStyles.AllowWhiteSpaces, out dob))
                //    {
                //    }
                //}
                string str = " select c.ClientName,j.JobName,dbo.TotalTime(t.TotalTime) as mints,s.StaffCode,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.Date as Date1,sum(CONVERT(float,t.TotalTime)) as time1,t.CompId " +
                                        " from dbo.TimeSheet_Table as t " +
                                        " left join  dbo.Staff_Master as s on s.StaffCode=t.StaffCode " +
                                        " left join  dbo.Job_Master as j on j.JobId=t.JobId " +
                                        " left join  dbo.Client_Master as c on c.CLTId=t.CLTId " +
                                        " where  t.Status='Approved' and t.CompId='" + comp + "' and t.StaffCode='" + ss + "' and t.Date between '" + startDate + "' and '" + endDate + "' group by t.Date,t.TotalTime,t.mints,c.ClientName,j.JobName,s.StaffCode,t.CompId ";
                DataTable dt = db.GetDataTable(str);
                if (dt.Rows.Count > 0)
                {
                    Session["startdate"] = null;
                    Session["enddate"] = null;
                    Response.Redirect("~/report1.aspx?comp=" + comp + "&staff=" + ss + "&dat=" + startdate + "&pagename=StaffAllClientsAllJobsHoursConsumed");
                }
                else
                {
                    MessageControl2.SetMessage("No Record Found", MessageDisplay.DisplayStyles.Error);
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
    protected void drpcompanylist_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindstaff();
    }
}
