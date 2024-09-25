using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;

public partial class Admin_AllJobAllCategory : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    DataTable dt_allJob = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {

        }

        //fromdate.Attributes.Add("readonly", "readonly");
        //txtenddate.Attributes.Add("readonly", "readonly");
    }
    protected void chkjob1_CheckedChanged(object sender, EventArgs e)
    {
        if (chkjob1.Checked == true)
        {
            foreach (DataListItem rw in dljoblist.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (chkjob1.Checked == false)
        {
            foreach (DataListItem rw in dljoblist.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/AllJobAllCategory.aspx";
            if (drpcompanylist.SelectedIndex != 0 && drpcompanylist.SelectedIndex != 0)
            {
                int comp = int.Parse(drpcompanylist.SelectedValue);
                string idstf = "";
                foreach (DataListItem rw in dljoblist.Items)
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
                string str = "select distinct j.JobId,jg.JobName " +
                             " from dbo.Job_Staff_Table as j left join dbo.Staff_Master as s on j.StaffCode=s.StaffCode " +
                             " left join dbo.Job_Master as jg on jg.JobId=j.JobId " +
                             " left join Designation_Master as d on s.DsgId=d.DsgId where j.JobId in (" + idstf + ")";

                DataTable dtavail = db.GetDataTable(str);

                dljoblist.DataSource = dtavail;
                dljoblist.DataBind();
                //if (dtavail.Rows.Count > 0)
                //{
                int stf = 0;
                foreach (DataListItem rw in dljoblist.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    int Cid = int.Parse(lblId.Text);
                    Label lblstaff = (Label)rw.FindControl("Label50");
                    string staff = lblstaff.Text;
                    stf = Cid;
                    if (dt_allJob == null || dt_allJob.Rows.Count == 0)
                    {
                        dt_allJob.Columns.Add("JobId", System.Type.GetType("System.String"));
                        dt_allJob.Columns.Add("JobName", System.Type.GetType("System.String"));
                        DataRow dr = dt_allJob.NewRow();
                        dr["JobId"] = Cid;
                        dr["JobName"] = staff;
                        dt_allJob.Rows.Add(dr);
                        dt_allJob.AcceptChanges();
                    }
                    else
                    {
                        DataRow dr = dt_allJob.NewRow();
                        dr["JobId"] = Cid;
                        dr["JobName"] = staff;
                        dt_allJob.Rows.Add(dr);
                        dt_allJob.AcceptChanges();
                    }
                }
                Session["dt_allJob"] = dt_allJob;
                if (dt_allJob.Rows.Count > 0)
                {
                    Response.Redirect("~/report1.aspx?comp=" + comp + "&clnt=" + drpClient.SelectedValue + "&pagename=AllJobAllCategory");
                }
                else if (idstf == "")
                {
                    chkjob1.Checked = false;
                    drpClient_SelectedIndexChanged(sender, e);
                    MessageControl1.SetMessage("No Jobs Found.", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    chkjob1.Checked = false;
                    drpClient_SelectedIndexChanged(sender, e);
                    MessageControl1.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
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
    protected void drpcompanylist_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            if (drpcompanylist.SelectedIndex != 0)
            {
                string qry = string.Format("select * from dbo.Client_Master where CompId='" + drpcompanylist.SelectedValue + "' order by ClientName");
                DataTable dt_clt = db.GetDataTable(qry);
                drpClient.DataSource = dt_clt;
                drpClient.DataBind();
                drpClient.Items.Insert(0, "--Select--");
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void drpClient_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            if (drpClient.SelectedIndex != 0)
            {
                string qry = string.Format("select * from dbo.Job_Master where CLTId='{0}' order by JobName", drpClient.SelectedValue);
                DataTable dt_job = db.GetDataTable(qry);
                dljoblist.DataSource = dt_job;
                dljoblist.DataBind();
            }
        }
        catch (Exception ex)
        {

        }
    }
}
