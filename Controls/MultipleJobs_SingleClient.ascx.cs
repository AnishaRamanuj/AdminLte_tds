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
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using DataAccessLayer;

public partial class controls_MultipleJobs_SingleClient : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    private readonly JobMaster job = new JobMaster();
    private readonly JobName JobN = new JobName();
    private readonly JobgroupMaster jobgrp = new JobgroupMaster();
    private readonly ClientMaster client = new ClientMaster();
    JobStaffTable jobstaff = new JobStaffTable();
    DataTable dt_st = new DataTable();
    int startJobStaffcount = 0;
    int EndJobStaffcount = 0;
    int startAppcount = 0;
    int EndAppcount = 0;
    int item;
    string ErrType = "";
    bool err = false;


    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                hdnCompanyid.Value = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                hdnCompanyid.Value = Session["cltcomp"].ToString();
            }


            if (hdnCompanyid.Value != null)
            {
                drpclientname.Focus();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

            StaffCount();
            fillclient();
            //filljobs();
            //filljobsGrp();
            //FillStaff();
            //FillDept();
            BindStaff();
            Session["dt_st"] = null;
            string dd11 = DateTime.Now.Day.ToString();
            string dd12 = DateTime.Now.Month.ToString();
            string dd13 = DateTime.Now.Year.ToString();
            string ddd = dd11 + "/" + dd12 + "/" + dd13;
            txtstartdate.Text = ddd;
            //HiddenField2.Value = txtstartdate.Text;
            txtactualdate.Text = DateTime.Now.AddDays(15).Day + "/" + DateTime.Now.AddDays(15).Month + "/" + DateTime.Now.AddDays(15).Year;
            //HiddenField3.Value = txtactualdate.Text;
            //DrpJob.Focus();
            drpjobstatus.SelectedIndex = 1;
        }
    }


    public void StaffCount()
    {
        try
        {
            DataSet ds = new DataSet();
            int Compid = Convert.ToInt32(hdnCompanyid.Value.ToString());
            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
            //string ss = " SELECT COUNT(jobid) as jobid  FROM job_Master WHERE  CompId='" + hdnCompanyid.Value + "' and jobstatus<>'Completed'";
            //DataTable dt = db.GetDataTable(ss);
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@CompanyID", Compid);
            ds = SqlHelper.ExecuteDataset(sqlConn, "usp_GetStaff_DeptCount", param);
            if (ds.Tables[0].Rows.Count > 0)
            {
                hdnStfCnt.Value = ds.Tables[0].Rows[0]["staffcode"].ToString();
                Label15.Text = "Staff(" + hdnStfCnt.Value + ")";
                Label8.Text = "Department(" + ds.Tables[1].Rows[0]["depid"].ToString() + ")";
            }
            else
            {
                Label15.Text = "Staff(0)";
                Label8.Text = "Department(0)";
                hdnStfCnt.Value = "0";
            }

            //Label8 (dep)
        }
        catch (Exception ex)
        {

        }
    }


    public void fillclient()
    {
        try
        {
            string str = "SELECT * from Client_Master where CompId='" + hdnCompanyid.Value.ToString() + "' order by ClientName";
            DataTable dt_client = db.GetDataTable(str);
            if (dt_client.Rows.Count == 0)
            {
                drpclientname.Enabled = false;
            }
            else
            {
                drpclientname.DataSource = dt_client;
                drpclientname.DataBind();
            }
        }
        catch (Exception ex)
        {

        }
    }


    public void BindStaff()
    {
        try
        {
            string str12 = "SELECT * FROM Staff_master  INNER JOIN dbo.Department_Master ON dbo.Staff_Master.DepId = dbo.Department_Master.DepId where Staff_master.CompId='" + hdnCompanyid.Value.ToString() + "' and Staff_Master.DateOfJoining <= getdate() and DateOfLeaving is null order by StaffName";
            DataTable dt = db.GetDataTable(str12);
            if (dt.Rows.Count == 0)
            {

            }
            else
            {
                //DlStaff.DataSource = dt;
                //DlStaff.DataBind();
                drpdwnapp.DataSource = dt;
                drpdwnapp.DataBind();
                drpdwnapp.Items.Insert(0, new ListItem("-------Select--------", "0"));
            }
        }
        catch (Exception ex)
        {

        }
    }


    protected void BtnSave_Click(object sender, EventArgs e)
    {

        try
        {

            if (hdnCompanyid.Value != null)
            {

                ErrType = "Job";
                if ( drpdwnapp.SelectedValue != "0" && txtactualdate.Text != "" && txtstartdate.Text != "")
                {
                    //string jobname = DrpJob.Text.Trim();
                    int clientid = int.Parse(drpclientname.SelectedValue);
                    int compidd = int.Parse(hdnCompanyid.Value.ToString());
                    //string strquery = "select * from job_Master where CompId='" + compidd + "' and CLTId='" + clientid + "' and mJobId = '" + jobname + "'";
                    //DataTable jobdup = db.GetDataTable(strquery);
                    //if (jobdup.Rows.Count > 0)
                    //{
                    //    MessageControl1.SetMessage("Job Name already exists.", MessageDisplay.DisplayStyles.Error);
                    //}
                    //else
                    //{
                        //job.JobName = DrpJob.Text;
                        //job.mJobId = int.Parse(DrpJob.SelectedValue);
                        job.JobName = hdnAllmJobId.Value;
                        job.StaffId = hdnAllstfCheckByAjaxCode.Value;
                        job.ApprId = hdnAllAppCheckByAjaxCode.Value;
                        job.SAprId = drpdwnapp.SelectedValue + 'y'; 
                        job.StaffCode = 0;
                        //if (drpjobgrp.SelectedValue != "0")
                        //{
                        //    job.JobGId = int.Parse(drpjobgrp.SelectedValue);
                        //}
                        //else
                        //{
                            job.JobGId = 0;
                        //}
                        if (drpjobstatus.SelectedValue != "0")
                        {
                            job.JobStatus = drpjobstatus.SelectedItem.Text;
                        }
                        else
                        {
                            job.JobStatus = "OnGoing";
                        }

                        job.CLTId = int.Parse(drpclientname.SelectedValue);
                        job.CompId = int.Parse(hdnCompanyid.Value.ToString());
                        //if (txtbudhours.Text != "")
                        //{
                        //    job.BudHours = float.Parse(txtbudhours.Text);
                        //}
                        //else
                        //{
                            job.BudHours = 0;
                        //}
                        //if (txtbudamtOth.Text != "")
                        //{
                        //    job.OtherBudAmt = decimal.Parse(txtbudamtOth.Text);
                        //}
                        //else
                        //{
                            job.OtherBudAmt = 0;
                        //}
                        //if (txtBudAmt.Text != "")
                        //{
                        //    job.BudAMt = decimal.Parse(txtBudAmt.Text);
                        //}
                        //else
                        //{
                            job.BudAMt = 0;
                        //}

                        job.ActualHours = 0;

                        job.ActualAmt = 0;

                        CultureInfo info = new CultureInfo("en-US", false);
                        DateTime dob1 = new DateTime(1900, 1, 1);
                        DateTime Fdob1 = new DateTime(1900, 1, 1);
                        DateTime Sdob1 = new DateTime(1900, 1, 1);
                        String _dateFormat = "dd/MM/yyyy";

                        if (txtactualdate.Text.Trim() != "" && !DateTime.TryParseExact(txtactualdate.Text.Trim(), _dateFormat, info,
                                                                                DateTimeStyles.AllowWhiteSpaces, out dob1))
                        {
                        }
                        //if (txtestenddate.Text.Trim() != "" && !DateTime.TryParseExact(txtestenddate.Text.Trim(), _dateFormat, info,
                        //                                                      DateTimeStyles.AllowWhiteSpaces, out Fdob1))
                        //{
                        //}
                        if (txtstartdate.Text.Trim() != "" && !DateTime.TryParseExact(txtstartdate.Text.Trim(), _dateFormat, info,
                                                                             DateTimeStyles.AllowWhiteSpaces, out Sdob1))
                        {
                        }

                        DateTime dob = dob1.AddHours(23).AddMinutes(59).AddSeconds(59).AddMilliseconds(59);
                        //DateTime Fdob = Fdob1.AddHours(11).AddMinutes(59).AddSeconds(59).AddMilliseconds(59);
                        DateTime Sdob = Sdob1.AddHours(1).AddMinutes(59).AddSeconds(59).AddMilliseconds(59);

                        if (dob < Sdob)
                        {
                            MessageControl1.SetMessage("Actual End Date must not be less than Creation Date", MessageDisplay.DisplayStyles.Error);
                        }
                        else
                        {

                            string billable = DrpBillable.SelectedValue.ToString();
                            if (billable == "1")
                            {
                                job.Billable = 1;
                            }
                            else
                            {
                                job.Billable = 0;
                            }
                            if (txtactualdate.Text != "")
                            {
                                job.ActualJobEndate = dob;

                            }
                            else
                            {
                                job.ActualJobEndate = null;
                            }

                            job.EndDate = null;

                            if (txtstartdate.Text != "")
                            {
                                job.CreationDate = Sdob;
                            }
                            else
                            {
                                job.CreationDate = DateTime.Now;
                            }
                        

                            int res = job.InsertMultipleJobs();
                            item = job.JobId;
                            ViewState["compid"] = int.Parse(hdnCompanyid.Value);
                            Session["companyid"] = int.Parse(hdnCompanyid.Value);
                            Session["cltcomp"] = int.Parse(hdnCompanyid.Value);

                            if (res > 0)
                            {


                                MessageControl1.SetMessage("Job Successfully Posted", MessageDisplay.DisplayStyles.Success);
                                if (err == true)
                                {
                                    MessageControl1.SetMessage("Error in " + ErrType, MessageDisplay.DisplayStyles.Error);

                                }

                                clearall();
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "newevenetcall", "$(document).ready(function () {  setTimeout('Redirect()',3000);    }); ", true);



                            }
                            else
                            {
                                MessageControl1.SetMessage("Error!!! Job cannot be Posted", MessageDisplay.DisplayStyles.Error);
                            }

                        }

                }
                else
                {
                    MessageControl1.SetMessage("Mandatory fields Must be filled.", MessageDisplay.DisplayStyles.Error);

                }
            }
            else
            {
                MessageControl1.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {
            ViewState["compid"] = int.Parse(hdnCompanyid.Value);
            Session["companyid"] = int.Parse(hdnCompanyid.Value);
            Session["cltcomp"] = int.Parse(hdnCompanyid.Value);
            if (ErrType == "Job")
            {
                MessageControl1.SetMessage("Error in Job Tab.", MessageDisplay.DisplayStyles.Info);
            }
            if (ErrType == "Staff Allocation")
            {

                MessageControl1.SetMessage("Error in Assign Staff Tab.", MessageDisplay.DisplayStyles.Info);

            }
            if (ErrType == "Approver")
            {
                MessageControl1.SetMessage("Error in Approver Tab.", MessageDisplay.DisplayStyles.Info);
            }
            ErrType = "";

            string deljob = "delete from Job_Master where compid='" + hdnCompanyid.Value.ToString() + "' and Jobid='" + item + "'";
            db.ExecuteCommand(deljob);

            string delstf = " delete from Job_Staff_Table where compid='" + hdnCompanyid.Value.ToString() + "' and Jobid='" + item + "' ";
            db.ExecuteCommand(delstf);

            string delApp = "delete from Top_Approver where compid='" + hdnCompanyid.Value.ToString() + "' and Jobid='" + item + "' ";
            db.ExecuteCommand(delApp);
            MessageControl1.SetMessage("Job Not Saved", MessageDisplay.DisplayStyles.Error);

        }
    }



    public void RollBack()
    {
        string deljob = "delete from Job_Master where compid='" + hdnCompanyid.Value.ToString() + "' and Jobid='" + item + "'";
        db.ExecuteCommand(deljob);

        string delstf = " delete from Job_Staff_Table where compid='" + hdnCompanyid.Value.ToString() + "' and Jobid='" + item + "' ";
        db.ExecuteCommand(delstf);

        string delApp = "delete from Top_Approver where compid='" + hdnCompanyid.Value.ToString() + "' and Jobid='" + item + "' ";
        db.ExecuteCommand(delApp);
        MessageControl1.SetMessage("Job Not Saved", MessageDisplay.DisplayStyles.Error);

    }
    public void clearall()
    {
        //DrpJob.SelectedValue = "0";
        txtactualdate.Text = string.Empty;
        txtstartdate.Text = string.Empty;
        //txtbudhours.Text = string.Empty;
        //txtBudAmt.Text = string.Empty;
        drpdwnapp.SelectedValue = "0";

        //drpclientname.SelectedValue = "0";
        //drpjobgrp.SelectedValue = "0";
        drpjobstatus.SelectedValue = "0";

    }
    protected void AClient_Click(object sender, EventArgs e)
    {
        txtclientname.Focus();
        ModalPopupExtender3.Show();
    }
    protected void AJob_Click(object sender, EventArgs e)
    {
        txtjob.Focus();
        ModalPopupExtender1.Show();
    }
    protected void btns_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                if (txtjob.Text != "")
                {
                    string str = "select mJobName from dbo.JobName_Master where mJobName ='" + txtjob.Text.Trim() + "' and CompId='" + hdnCompanyid.Value.ToString() + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {

                        JobN.CompId = int.Parse(hdnCompanyid.Value.ToString());
                        JobN.id = 0;
                        JobN.mJobName = txtjob.Text;
                        int res = JobN.Insert();
                        ViewState["compid"] = int.Parse(hdnCompanyid.Value);
                        Session["companyid"] = int.Parse(hdnCompanyid.Value);
                        Session["cltcomp"] = int.Parse(hdnCompanyid.Value);
                        if (res == 1)
                        {
                            txtjob.Text = "";
                            MessageControl3.SetMessage("Job Added Successfully", MessageDisplay.DisplayStyles.Success);
                            //filljobs();
                            //DrpJob.SelectedValue = JobN.mJobid.ToString();
                        }

                    }
                    else
                    {
                        MessageControl3.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl3.SetMessage("Please Enter a Job Name.", MessageDisplay.DisplayStyles.Error);
                }

                txtjob.Text = "";
                ModalPopupExtender1.Show();
                txtjob.Focus();
            }
            else
            {
                MessageControl3.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {
            ViewState["compid"] = int.Parse(hdnCompanyid.Value);
            Session["companyid"] = int.Parse(hdnCompanyid.Value);
            Session["cltcomp"] = int.Parse(hdnCompanyid.Value);
        }
    }
    protected void btnc_Click(object sender, EventArgs e)
    {
        ModalPopupExtender1.Hide();
    }
    protected void AJobG_Click(object sender, EventArgs e)
    {
        txtjg.Focus();
        ModalPopupExtender2.Show();
    }

    protected void btncJg_Click(object sender, EventArgs e)
    {
        ModalPopupExtender2.Hide();
    }
    protected void btncname_Click(object sender, EventArgs e)
    {
        ModalPopupExtender3.Hide();
    }
    protected void btnclientname_Click(object sender, EventArgs e)
    {
        try
        {
            if (hdnCompanyid.Value != null)
            {

                if (txtclientname.Text != "")
                {

                    client.IsApproved = true;

                    client.ClientName = txtclientname.Text;
                    client.Address1 = "";
                    client.Address2 = "";
                    client.Address3 = "";
                    client.City = "";
                    client.BusPhone = "";
                    client.BusFax = "";
                    client.ContEmail = "";
                    client.ContMob = "";
                    client.ContPerson = "";
                    client.Country = "";
                    client.CompId = int.Parse(hdnCompanyid.Value.ToString());

                    client.CTGId = 0;

                    client.Partner = "False";

                    client.CreationDate = DateTime.Now;

                    client.Pin = "";
                    client.Website = "";
                    int res = client.Insert();

                    if (res == 1)
                    {
                        //SendNotificationEmail(txtcontemail.Text);
                        fillclient();

                        MessageControl5.SetMessage("Client Successfully Registered", MessageDisplay.DisplayStyles.Success);
                        drpclientname.SelectedValue = client.CLTId.ToString();

                    }
                    else
                    {
                        MessageControl5.SetMessage("Error!!! Client Registration not completed.", MessageDisplay.DisplayStyles.Error);
                    }



                }
                else
                {
                    MessageControl5.SetMessage("Mandatory fields Must be filled.", MessageDisplay.DisplayStyles.Error);
                }
                txtclientname.Text = "";
                txtclientname.Focus();

                ModalPopupExtender3.Show();

            }
            else
            {
                MessageControl5.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void btn_getapprovedemployee_Click(object sender, EventArgs e)
    {

        DataTable dt = new DataTable();
        DataRow dr;
        dt.Columns.Add("EmployeeID");
        dt.Columns.Add("EmployeeName");
        dt.Columns.Add("budgetamt");
        dt.Columns.Add("budgethr");


    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("cmp_Managejob.aspx", true);
    }
}
