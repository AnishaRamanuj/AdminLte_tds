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

public partial class Admin_AllClientSinglejob : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    private readonly JobMaster job = new JobMaster();
    JobStaffTable jobstaff = new JobStaffTable();
    StaffMaster staff = new StaffMaster();
    DataTable dtjob = new DataTable();
    DataTable dtclient = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session["admin"] != null)
        {
            if (!IsPostBack)
            {
                bindcomp();
                string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
                fromdate.Text = dat;
                txtenddate.Text = dat; 

            }
        }
        else
        {
            Response.Redirect("~/Default.aspx");
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
            drpcompanylist.DataSource = dt;
            drpcompanylist.DataBind();
        }
    }
    public void bindjob()
    {
        string ss = "select * from Job_Master where CompId='" + drpcompanylist.SelectedValue + "' order by JobName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            DataList2.DataSource = dt;
            DataList2.DataBind();
            Label1.Visible = false;
        }
        else
        {
            DataList2.DataSource = null;
            DataList2.DataBind();
            Label1.Visible = true;
        }
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
            //Label1.Visible = false;
        }
        else
        {
            drpstafflist.DataSource = null;
            drpstafflist.DataBind();
            //Label1.Visible = true;
        }
    }
    public void bindclient()
    {
        string ss = "select * from Client_Master  where CompId='" + drpcompanylist.SelectedValue + "' order by ClientName";      
        DataTable dt1 = db.GetDataTable(ss);
        if (dt1.Rows.Count != 0)
        {
            dlclientlist.DataSource = dt1;
            dlclientlist.DataBind();
            Label14.Visible = false;
        }
        else
        {
            dlclientlist.DataSource = null;
            dlclientlist.DataBind();
            Label14.Visible = true;
        }
    }
    protected void btngenerate_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Staff_AllClientSinglejob.aspx";
            if (drpcompanylist.SelectedValue != "0" && drpstafflist.SelectedValue != "0" && txtenddate.Text != "" && fromdate.Text != "")
            {
                string id = "";
                foreach (DataListItem rw in dlclientlist.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
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
                }
                string idstf = "";
                foreach (DataListItem rw in DataList2.Items)
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
                string str = "select distinct c.CLTId,j.JobId,j.JobName,c.ClientName  " +
                                " from dbo.TimeSheet_Table as t left join Staff_Master as s on s.StaffCode=t.StaffCode" +
                                " left join dbo.Job_Master as j on j.JobId=t.JobId" +
                                " left join dbo.Client_Master as c on c.CLTId=t.CLTId" +
                                " left join dbo.Designation_Master as d on d.DsgId=s.DsgId" +
                                " where t.Status='Approved' and t.StaffCode='" + drpstafflist.SelectedValue + "' and t.JobId in (" + idstf + ") and t.CLTId in (" + id + ") and t.Date between '" + Fdob + "' and '" + dob + "'";


                DataTable dtavail = db.GetDataTable(str);
                dlclientlist.DataSource = dtavail;
                dlclientlist.DataBind();
                DataList2.DataSource = dtavail;
                DataList2.DataBind();

                int cltid = 0;
                foreach (DataListItem rw in dlclientlist.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    int Cid = int.Parse(lblId.Text);
                    Label lbljob = (Label)rw.FindControl("Label50");
                    string job = lbljob.Text;
                    //CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    //if (chk.Checked == true)
                    //{
                    cltid = Cid;
                    if (dtclient == null || dtclient.Rows.Count == 0)
                    {
                        dtclient.Columns.Add("CLTId", System.Type.GetType("System.String"));
                        dtclient.Columns.Add("ClientName", System.Type.GetType("System.String"));
                        DataRow dr = dtclient.NewRow();
                        dr["CLTId"] = Cid;
                        dr["ClientName"] = job;
                        dtclient.Rows.Add(dr);
                        dtclient.AcceptChanges();
                    }
                    else
                    {
                        DataRow dr = dtclient.NewRow();
                        dr["CLTId"] = Cid;
                        dr["ClientName"] = job;
                        dtclient.Rows.Add(dr);
                        dtclient.AcceptChanges();
                    }
                    // }
                }
                Session["dtclient"] = dtclient;
                int joid = 0;
                foreach (DataListItem rw in DataList2.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    int Cid = int.Parse(lblId.Text);
                    Label lbljob = (Label)rw.FindControl("Label50");
                    string job = lbljob.Text;
                    //CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
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
                string startdate = fromdate.Text;
                string enddate = txtenddate.Text;
                Session["startdate"] = startdate;
                Session["enddate"] = enddate;
                if (dtjob.Rows.Count > 0 && dtclient.Rows.Count > 0)
                {
                    Response.Redirect("~/report1.aspx?staff=" + drpstafflist.SelectedValue + "&comp=" + drpcompanylist.SelectedValue + "&pagename=AllClientSingleJob");
                }
                else
                {
                    chkclient.Checked = false;
                    chkjob.Checked = false;
                    drpcompanylist_SelectedIndexChanged(sender, e);
                    MessageControl1.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
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
    protected void chkclient_CheckedChanged(object sender, EventArgs e)
    {
        if (chkclient.Checked == true)
        {
            foreach (DataListItem rw in dlclientlist.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (chkclient.Checked == false)
        {
            foreach (DataListItem rw in dlclientlist.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
        }
    }
    protected void drpcompanylist_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindjob();
        bindclient();
        bindstaff();
    }
}

