using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;
using System.Globalization;

public partial class Admin_ad_editjob : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    private readonly JobMaster job = new JobMaster();
    JobStaffTable jobstaff = new JobStaffTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session["admin"] != null)
            {
                if (Session["jobid"] != null)
                {
                    bindcomp();
                    //data();
                    bind_edit();
                }
            }

            else
            {
                Response.Redirect("~/Default.aspx");
            }

        }
        txtstartdate.Attributes.Add("onblur", "checkFormanother();");
        txtactualdate.Attributes.Add("onblur", "checkForms();");
        txtestenddate.Attributes.Add("onblur", "checkForm();");
        txtactualamt.Attributes.Add("readonly", "raedonly");
        txtactualhours.Attributes.Add("readonly", "raedonly");
        txtbudhours.Attributes.Add("onkeyup", "return  ValidateText1(this);");
        txtbudamt.Attributes.Add("onkeyup", "return  ValidateText(this);");
        txtactualhours.Attributes.Add("onkeyup", "return  ValidateText(this);");
        txtactualamt.Attributes.Add("onkeyup", "return  ValidateText(this);");
        txtclientname.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtclientname.Focus();

    }
    public void bindcomp()
    {
        try
        {
            string ss = "select * from Company_Master order by CompanyName";
            DataTable dt = db.GetDataTable(ss);
            drpcompany.DataSource = dt;
            drpcompany.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    public void bindclient()
    {
        try
        {
            string ss = "select * from Client_Master where CompId='" + drpcompany.SelectedValue + "' order by ClientName";
            DataTable dt = db.GetDataTable(ss);
            drpclient.DataSource = dt;
            drpclient.DataBind();
            if (dt.Rows.Count == 0 || dt == null)
            {
                drpclient.Items.Clear();
                btnupdate.Enabled = false;
                MessageControl1.SetMessage("No Client under the company", MessageDisplay.DisplayStyles.Error);

            }
            else
            {

                btnupdate.Enabled = false;
                data();
            }
        }
        catch (Exception ex)
        {

        }
    }
    public void bindjobgroup()
    {
        try
        {
            string ss = "select * from JobGroup_Master where CompId='" + drpcompany.SelectedValue + "' order by JobGroupName";
            DataTable dt = db.GetDataTable(ss);
            if (dt.Rows.Count != 0)
            {
                drpjobgroup.DataSource = dt;
                drpjobgroup.DataBind();

            }
        }
        catch (Exception ex)
        {

        }
    }
    public void data()
    {
        try
        {
            string str = "SELECT * from Staff_Master where CompId='" + drpcompany.SelectedValue + "' and Staff_Master.DateOfJoining < getdate() order by StaffName";
            DataTable dt = db.GetDataTable(str);
            DataList1.DataSource = dt;
            DataList1.DataBind();

            drpapprover.DataSource = dt;
            drpapprover.DataBind();
            if (dt.Rows.Count == 0 || dt == null)
            {
                btnupdate.Enabled = false;
                nodiv.Style.Value = "display:block";
                MessageControl1.SetMessage("No staff under the company", MessageDisplay.DisplayStyles.Error);

            }
            else
            {
                nodiv.Style.Value = "display:none";
                btnupdate.Enabled = true;
            }

        }
        catch (Exception ex)
        {

        }
    }
    public void bind_edit()
    {
        try
        {
            DataTable dt = new DataTable();
            //string sqlqry = "select *,Staff_Master.StaffCode,convert(nvarchar(20),Job_Master.ActualJobEndate,103)as ActualJobEndate1,convert(nvarchar(20),Job_Master.EndDate,103)as EndDate1 from Job_Master inner join Staff_Master on Staff_Master.StaffCode=Job_Master.JobApprover where Job_Master.JobId='" + int.Parse(Session["jobid"].ToString()) + "'";
            string sqlqry = "select *,convert(nvarchar(20),j.CreationDate,103)as CreationDate1,convert(nvarchar(20),j.ActualJobEndate,103)as ActualJobEndate1,convert(nvarchar(20),j.EndDate,103)as EndDate1 from Job_Master as j where j.JobId='" + int.Parse(Session["jobid"].ToString()) + "' order by JobName";
            dt = db.GetDataTable(sqlqry);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    ViewState["date"] = dt.Rows[0]["CreationDate"].ToString();
                    if (drpcompany.Items.FindByValue(dt.Rows[0]["CompId"].ToString()) != null)
                    {
                        drpcompany.SelectedValue = dt.Rows[0]["CompId"].ToString();
                    }
                    else
                    {
                        drpcompany.SelectedValue = "1";

                    }
                    bindclient();
                    bindjobgroup();
                    if (drpclient.Items.FindByValue(dt.Rows[0]["CLTId"].ToString()) != null)
                    {
                        drpclient.SelectedValue = dt.Rows[0]["CLTId"].ToString();
                    }
                    else
                    {
                        drpclient.SelectedValue = "1";

                    }
                    data();
                    txtstartdate.Text = dt.Rows[0]["CreationDate1"].ToString();
                    HiddenField3.Value = txtstartdate.Text;
                    txtclientname.Text = dt.Rows[0]["JobName"].ToString();
                    string sqlqry1 = "select * from Job_Staff_Table where JobId='" + int.Parse(Session["jobid"].ToString()) + "'";
                    DataTable dt1 = db.GetDataTable(sqlqry1);

                    foreach (DataListItem rw in DataList1.Items)
                    {
                        Label lblId = (Label)rw.FindControl("Label51");
                        int Cid = int.Parse(lblId.Text);
                        CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                        //chk.Checked = true;

                        foreach (DataRow dr in dt1.Rows)
                        {
                            if (lblId.Text == dr["StaffCode"].ToString())
                            {
                                chk.Checked = true;
                            }
                        }
                    }
                    //drpstaff.SelectedValue = dt.Rows[0]["StaffCode"].ToString();
                    drpapprover.SelectedValue = dt.Rows[0]["JobApprover"].ToString();
                    if (dt.Rows[0]["JobGId"].ToString() != "0")
                    {
                        drpjobgroup.SelectedValue = dt.Rows[0]["JobGId"].ToString();
                    }
                    else
                    {
                        drpjobgroup.SelectedValue = "0";
                    }
                    drpjobstatus.SelectedItem.Text = dt.Rows[0]["JobStatus"].ToString();
                    txtbudhours.Text = dt.Rows[0]["BudHours"].ToString();
                    //txtactualhours.Text = dt.Rows[0]["ActualHours"].ToString();
                    string[] fg = dt.Rows[0]["BudAMt"].ToString().Split('.');
                    txtbudamt.Text = fg[0].ToString();

                    //string sqlqry2 = "select sum(OpeAmt) as Amt,sum(CONVERT(float, TotalTime)) as Time from TimeSheet_Table where JobId='" + Session["jobid"].ToString() + "'";
                    //DataTable dt3 = db.GetDataTable(sqlqry2);
                    //if (dt3.Rows.Count != 0)
                    //{
                    //    txtactualhours.Text = dt3.Rows[0]["Time"].ToString();
                    //    txtactualamt.Text = dt3.Rows[0]["Amt"].ToString();
                    //}
                    //else
                    //{
                    //    txtactualhours.Text = "0";
                    //    txtactualamt.Text = "0";
                    //}

                    string sqlqry2 = "select s.StaffCode,sum(convert(float,t.TotalTime)) as time,s.HourlyCharges from Timesheet_Table as t inner join Staff_Master as s on t.StaffCode=s.StaffCode  where t.JobId='" + Session["jobid"].ToString() + "' group by s.HourlyCharges,s.StaffCode";
                    DataTable dt3 = db.GetDataTable(sqlqry2);
                    if (dt3.Rows.Count != 0)
                    {
                        //  decimal tot = 0;
                        decimal tot3 = 0;
                        decimal tot2 = 0;
                        foreach (DataRow dr in dt3.Rows)
                        {
                            decimal charge = decimal.Parse(dr["HourlyCharges"].ToString());
                            decimal time = decimal.Parse(dr["time"].ToString());
                            tot3 += charge * time;
                            tot2 += time;
                        }

                        decimal tot = 0;
                        decimal tot1 = 0;
                        string dds = tot2.ToString();
                        if (dds.Contains("."))
                        {
                            string[] dd4 = dds.Split('.');
                            string dd5 = dd4[0].ToString();
                            decimal dd = decimal.Parse(dd5.ToString());
                            tot += dd;
                            string dd6 = dd4[1].ToString();
                            decimal dd1 = decimal.Parse(dd6.ToString());
                            tot1 += dd1;
                            if (tot1 >= 60)
                            {
                                tot1 = tot1 - 60;
                                tot = tot + 1;
                            }
                            string dd7 = tot + "." + tot1;
                            txtactualhours.Text = dd7;
                        }
                        else
                        {
                            txtactualhours.Text = dds;
                        }
                        txtactualamt.Text = tot3.ToString();
                    }
                    else
                    {
                        txtactualhours.Text = "0";
                        txtactualamt.Text = "0";
                    }
                    //string[] fg1 = dt.Rows[0]["ActualAmt"].ToString().Split('.');
                    //txtactualamt.Text = fg1[0].ToString();
                    //txtactualamt.Text = dt.Rows[0]["ActualAmt"].ToString();
                    //CultureInfo info = new CultureInfo("en-US", false);
                    //DateTime dob = new DateTime(1900, 1, 1);
                    //DateTime Fdob = new DateTime(1900, 1, 1);
                    //String _dateFormat = "dd/MM/yyyy";

                    //if (dt.Rows[0]["ActualJobEndate"].ToString().Trim() != "" && !DateTime.TryParseExact(dt.Rows[0]["ActualJobEndate"].ToString().Trim(), _dateFormat, info,
                    //                                                        DateTimeStyles.AllowWhiteSpaces, out dob))
                    //{
                    //}
                    //if (dt.Rows[0]["EndDate"].ToString().Trim() != "" && !DateTime.TryParseExact(dt.Rows[0]["EndDate"].ToString().Trim(), _dateFormat, info,
                    //                                                      DateTimeStyles.AllowWhiteSpaces, out Fdob))
                    //{
                    //}

                    if (dt.Rows[0]["EndDate1"].ToString() != null && dt.Rows[0]["EndDate1"].ToString() != "01/01/1900")
                    {
                        txtestenddate.Text = dt.Rows[0]["EndDate1"].ToString();
                        HiddenField1.Value = txtestenddate.Text;
                    }
                    else
                    {
                        txtestenddate.Text = "";
                        HiddenField1.Value = txtestenddate.Text;
                    }
                    if (dt.Rows[0]["ActualJobEndate1"].ToString() != null && dt.Rows[0]["ActualJobEndate1"].ToString() != "01/01/1900")
                    {
                        txtactualdate.Text = dt.Rows[0]["ActualJobEndate1"].ToString();
                        HiddenField2.Value = txtactualdate.Text;
                    }
                    else
                    {
                        txtactualdate.Text = "";
                        HiddenField2.Value = txtactualdate.Text;
                    }
                }

            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void btnupdate_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["admin"] != null)
            {
                if (drpapprover.SelectedValue != "0" && drpclient.SelectedValue != "0" && txtclientname.Text != "" && txtactualdate.Text != "")
                {
                    //string jobname = txtclientname.Text.Trim();
                    //int clientid =int.Parse( drpclient.SelectedValue);
                    //int compidd = int.Parse(drpcompany.SelectedValue);
                    //string strquery = "select * from job_Master where CompId='"+compidd+"' and CLTId='"+ clientid +"' and JobName like '%"+ jobname +"%'";
                    //DataTable jobdup = db.GetDataTable(strquery);
                    //if (jobdup.Rows.Count > 0)
                    //{
                    //    MessageControl1.SetMessage("Job Name already exists.", MessageDisplay.DisplayStyles.Error);
                    //}
                    //else
                    //{
                    job.CompId = int.Parse(drpcompany.SelectedValue);
                    job.JobId = int.Parse(Session["jobid"].ToString());
                    job.JobName = txtclientname.Text;
                    if (drpjobgroup.SelectedValue != "0")
                    {
                        job.JobGId = int.Parse(drpjobgroup.SelectedValue);
                    }
                    else
                    {
                        job.JobGId = 0;
                    }
                    job.StaffCode = 0;

                    CultureInfo info = new CultureInfo("en-US", false);
                    DateTime dob1 = new DateTime(1900, 1, 1);
                    DateTime Fdob = new DateTime(1900, 1, 1);
                    DateTime Sdob1 = new DateTime(1900, 1, 1);
                    String _dateFormat = "dd/MM/yyyy";

                    if (txtactualdate.Text.Trim() != "" && !DateTime.TryParseExact(txtactualdate.Text.Trim(), _dateFormat, info,
                                                                            DateTimeStyles.AllowWhiteSpaces, out dob1))
                    {
                    }
                    if (txtestenddate.Text.Trim() != "" && !DateTime.TryParseExact(txtestenddate.Text.Trim(), _dateFormat, info,
                                                                          DateTimeStyles.AllowWhiteSpaces, out Fdob))
                    {
                    }
                    if (txtstartdate.Text.Trim() != "" && !DateTime.TryParseExact(txtstartdate.Text.Trim(), _dateFormat, info,
                                                                         DateTimeStyles.AllowWhiteSpaces, out Sdob1))
                    {
                    }
                    if (dob1 < Sdob1)
                    {
                        MessageControl1.SetMessage("Actual End Date must not be less than Creation Cate", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
                        DateTime dob = dob1.AddHours(23).AddMinutes(59).AddSeconds(59).AddMilliseconds(59);
                        DateTime Sdob = Sdob1.AddHours(1).AddMinutes(59).AddSeconds(59).AddMilliseconds(59);
                        int app = 0;
                        int app1 = 0;
                        string approver = drpapprover.SelectedItem.Text;
                        foreach (DataListItem rw in DataList1.Items)
                        {
                            Label staff = (Label)rw.FindControl("Label50");
                            Label lblId = (Label)rw.FindControl("Label51");
                            int Cid = int.Parse(lblId.Text);
                            CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                            if (approver == staff.Text)
                            {
                                app = Cid;
                            }
                            if (chk.Checked == true)
                            {
                                app1 = Cid;
                            }
                        }
                        if (app1 != 0)
                        {
                            if (app != 0)
                            {
                                //if (ViewState["date"] != null)
                                //{
                                //    job.CreationDate = DateTime.Parse(ViewState["date"].ToString());
                                //}
                                //else
                                //{
                                job.CreationDate = Sdob;
                                //}
                                //job.JobApprover = app;
                                if (dob.ToString() != "1/1/1900 12:00:00 AM")
                                {
                                    job.ActualJobEndate = dob;
                                }
                                else
                                {
                                    job.ActualJobEndate = null;
                                }
                                if (Fdob.ToString() != "1/1/1900 12:00:00 AM")
                                {
                                    job.EndDate = Fdob;
                                }
                                else
                                {
                                    job.EndDate = null;
                                }
                                if (drpjobstatus.SelectedValue != "0")
                                {
                                    job.JobStatus = drpjobstatus.SelectedItem.Text;
                                }
                                else
                                {
                                    job.JobStatus = "OnGoing";
                                }
                                if (txtbudhours.Text != "" && txtbudhours.Text != "0")
                                {
                                    job.BudHours = float.Parse(txtbudhours.Text);
                                }
                                else
                                {
                                    job.BudHours = 0;
                                }
                                if (txtbudamt.Text != "" && txtbudamt.Text != "0.0000")
                                {
                                    job.BudAMt = decimal.Parse(txtbudamt.Text);
                                }
                                else
                                {
                                    job.BudAMt = 0;
                                }
                                if (txtactualhours.Text != "" && txtactualhours.Text != "0")
                                {
                                    job.ActualHours = float.Parse(txtactualhours.Text);
                                }
                                else
                                {
                                    job.ActualHours = 0;
                                }
                                if (txtactualamt.Text != "" && txtbudamt.Text != "0.0000")
                                {
                                    job.ActualAmt = decimal.Parse(txtactualamt.Text);
                                }
                                else
                                {
                                    job.ActualAmt = 0;
                                }
                                job.CLTId = int.Parse(drpclient.SelectedValue);
                                int res = job.Update();
                                int item = job.JobId;
                                string str = "delete from Job_Staff_Table where JobId='" + item + "'";
                                db.ExecuteCommand(str);
                                foreach (DataListItem rw in DataList1.Items)
                                {
                                    Label lblId = (Label)rw.FindControl("Label51");
                                    int Cid = int.Parse(lblId.Text);
                                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                                    if (chk.Checked == true)
                                    {
                                        jobstaff.JobId = item;
                                        jobstaff.StaffCode = Cid;
                                        jobstaff.Insert();
                                    }
                                }
                                if (res == 1)
                                    Response.Redirect("ad_Managejob.aspx");
                                else
                                    MessageControl1.SetMessage("Updation not Completed", MessageDisplay.DisplayStyles.Error);
                            }
                            else
                            {
                                MessageControl1.SetMessage("Staff Name not in the List", MessageDisplay.DisplayStyles.Error);

                            }
                        }
                        else
                        {
                            MessageControl1.SetMessage("No Staff selected for this job", MessageDisplay.DisplayStyles.Error);

                        }
                        //}
                    }
                }
                else
                {
                    MessageControl1.SetMessage("Mandatory Fields Must be Filled", MessageDisplay.DisplayStyles.Error);

                }
            }
            else
            {
                MessageControl1.SetMessage("Error!!!Session Expired", MessageDisplay.DisplayStyles.Error);

            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void btncancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("ad_Managejob.aspx");
    }
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindclient();
        //data();
    }
    protected void drpclient_SelectedIndexChanged(object sender, EventArgs e)
    {
        //data();
    }
}

