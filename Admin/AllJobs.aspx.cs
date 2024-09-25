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

public partial class Admin_AllJobs : System.Web.UI.Page
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
    public void bindjob()
    {
        string ss = "select * from Job_Master where CompId='" + drpcompanylist.SelectedValue + "'";
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
    protected void btngenerate_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/AllJobs.aspx";
            if (drpcompanylist.SelectedValue != "0" && drpstafflist.SelectedValue != "0")
            {
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
                    string str = "select distinct j.JobId,j.JobName  " +
                    " from dbo.TimeSheet_Table as t left join Staff_Master as s on s.StaffCode=t.StaffCode" +
                    " left join dbo.Job_Master as j on j.JobId=t.JobId" +
                    " left join dbo.Designation_Master as d on d.DsgId=s.DsgId" +
                    " where t.Status='Approved' and t.jobId in (" + idstf + ") and t.StaffCode ='" + drpstafflist.SelectedValue + "' and t.Date between '" + Fdob + "' and '" + dob + "'";

                    DataTable dtavail = db.GetDataTable(str);


                    DataList2.DataSource = dtavail;
                    DataList2.DataBind();

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
                        //}
                    }
                    Session["dtclient"] = null;
                    Session["dtjob"] = dtjob;
                    string startdate = fromdate.Text;
                    string enddate = txtenddate.Text;
                    Session["startdate"] = startdate;
                    Session["enddate"] = enddate;
                    if (dtjob.Rows.Count > 0 && startdate != "" && enddate != "")
                    {
                        Response.Redirect("~/report1.aspx?staff=" + drpstafflist.SelectedValue + "&comp=" + drpcompanylist.SelectedValue + "&pagename=AllJob");
                    }
                    else
                    {
                        chkjob.Checked = false;
                        drpcompanylist_SelectedIndexChanged(sender, e);
                        MessageControl1.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
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
    protected void drpcompanylist_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindjob();
        bindstaff();
    }
}
