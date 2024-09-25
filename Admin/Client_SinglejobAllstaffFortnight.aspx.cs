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

public partial class Admin_Client_SinglejobAllstaffFortnight : System.Web.UI.Page
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
    public string[,] weeks = new string[2, 2];
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string dat = DateTime.Now.Month + "/" + DateTime.Now.Year;
            txtenddate2.Text = dat;

        }

        txtenddate2.Attributes.Add("onblur", "checkForm();");
    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {

    }
    protected void drpcompanylist_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (drpcompanylist.SelectedIndex != 0)
        {
            string query = string.Format("select * from dbo.Client_Master where CompId='{0}' order by ClientName", drpcompanylist.SelectedValue);
            DataTable dt_clt = db.GetDataTable(query);
            if (dt_clt.Rows.Count != 0)
            {
                DropClient.DataSource = dt_clt;
                DropClient.DataBind();
                DropClient.Items.Insert(0, "--Select--");
            }
        }
        if (drpcompanylist.SelectedIndex != 0)
        {
            string query = string.Format("select * from dbo.Job_Master where CompId='{0}' order by JobName ", drpcompanylist.SelectedValue);
            DataTable dt_job = db.GetDataTable(query);
            if (dt_job.Rows.Count != 0)
            {
                DropJob.DataSource = dt_job;
                DropJob.DataBind();
                DropJob.Items.Insert(0, "--Select--");
            }
        }
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Client_SinglejobAllstaffFortnight.aspx";
            if (DropJob.SelectedIndex != 0 && drpcompanylist.SelectedIndex != 0 && txtenddate2.Text != "" && DropClient.SelectedValue != "0")
            {
                DateTime date = Convert.ToDateTime(txtenddate2.Text);
                calculateWeek();
                string str = "select s.StaffName,isnull(t.HourlyCharges,0) as Charges,isnull(sum(convert(float,TotalTime)),0)as TotalTime,isnull((isnull(sum(convert(float,TotalTime)),0)* t.HourlyCharges),0)as HourlyCharges,isnull(isnull(sum(OpeAmt),0),0) as OpeAmt,dbo.TotalTime(isnull(sum(convert(float,TotalTime)),0)) as mints,convert(varchar(50),dbo.TotalTime(isnull(sum(convert(float,TotalTime)),0))/60) + '.' + convert(varchar(50),dbo.TotalTime(isnull(sum(convert(float,TotalTime)),0))%60) as timet " +
                               "  from   dbo.Staff_Master as s right join dbo.Job_Staff_Table as j on s.StaffCode=j.StaffCode " +
                               "  left join  dbo.TimeSheet_Table as t on  t.JobId=j.JobId and t.StaffCode=j.StaffCode  and  t.Date>= '" + Convert.ToDateTime(weeks[0, 0].ToString()) + "'" +
                               "  and t.Date <='" + Convert.ToDateTime(weeks[1, 1].ToString()) + "'  where  j.JobId='" + DropJob.SelectedValue + "' and t.CompId='" + drpcompanylist.SelectedValue + "' group by s.StaffName,t.HourlyCharges";
                DataTable dt = db.GetDataTable(str);
                if (dt.Rows.Count > 0)
                {
                    // Response.Redirect("AllStaffFortNight_Report.aspx?dt=" + date + "&jb=" + DropJob.SelectedValue + "&comp=" + drpcompanylist.SelectedValue + "&pagename=Client_SinglejobAllstaffFortnight");
                    Response.Redirect("../report1.aspx?dt=" + date + "&jb=" + DropJob.SelectedValue + "&comp=" + drpcompanylist.SelectedValue + "&pagename=Client_SinglejobAllstaffFortnight");
                }
                else
                {
                    MessageControl1.SetMessage("No Record Found", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                MessageControl1.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }
    public void calculateWeek()
    {
        DateTime date = Convert.ToDateTime(txtenddate2.Text);
        DateTime startDate = date;
        DateTime lastdate = DateTime.Now;
        DateTime endDate = startDate.AddMonths(1).AddDays(-1);
        int i = 0;
        for (DateTime result = startDate; result <= endDate; result = lastdate.AddDays(1))
        {
            if (result.Day != 31)
            {
                weeks[i, 0] = result.ToString();
                if (result.AddDays(14) >= endDate)
                {
                    weeks[i, 1] = endDate.ToString();
                    lastdate = result.AddDays(14);
                }
                else
                {
                    weeks[i, 1] = result.AddDays(14).ToString();
                    lastdate = result.AddDays(14);
                }
            }
            else
            {
                weeks[i - 1, 1] = result.ToString();
                lastdate = result.AddDays(14);
            }
            i++;

        }

        if (weeks.Length > 0)
        {
            Session["frt_1"] = Convert.ToDateTime(weeks[0, 0].ToString());
            Session["frt_2"] = Convert.ToDateTime(weeks[0, 1].ToString());
            Session["frt_3"] = Convert.ToDateTime(weeks[1, 0].ToString());
            Session["frt_4"] = Convert.ToDateTime(weeks[1, 1].ToString());
        }

    }
}
