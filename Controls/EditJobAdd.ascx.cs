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
using DataAccessLayer;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Collections.Generic;
using System.Web.Services;
using System.Web.Script.Services;


public partial class controls_EditJobAdd : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    private readonly JobMaster job = new JobMaster();
    private readonly JobName JobN = new JobName();
    private readonly JobgroupMaster jobgrp = new JobgroupMaster();
    private readonly ClientMaster client = new ClientMaster();
    private DateTime dtfromdate, dttodate, dtmaxfromdate, dtmaxfromfinal, dtto, dtcurrent;
    private float BudgetOthAmt, BudgetAmt;
    private int BudgetHrs;
    JobStaffTable jobstaff = new JobStaffTable();
    DataTable dt_st = new DataTable();
    private string Staffcode;
    private string DeptCodes;
    string ErrType = "";
    bool err = false;
    int item;
    private string maxfromdate, todate;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                // ViewState["compid"] = Session["companyid"].ToString();
                hdnJobid.Value = Session["jobid"].ToString();
                hdnCompanyid.Value = Session["companyid"].ToString();

            }
            else if (Session["staffid"] != null)
            {
                hdnCompanyid.Value = Session["cltcomp"].ToString();
                //ViewState["compid"] = Session["cltcomp"].ToString();
            }


            if (hdnCompanyid.Value != null)
            {
                drpclientname.Focus();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

            DataTable dummy = new DataTable();
            dummy.Columns.Add("fromdate");
            dummy.Columns.Add("BudgetAmt");
            dummy.Columns.Add("Budgethours");
            dummy.Rows.Add();

            gvCustomers.DataSource = dummy;
            gvCustomers.DataBind();


            Gridtimesheetdetails.DataSource = dummy;
            Gridtimesheetdetails.DataBind();

            StaffCount();
            //fillclient();
            //filljobs();
            filljobsGrp();
            //FillStaff();
            //FillDept();
            BindStaff();
            string dd11 = DateTime.Now.Day.ToString();
            string dd12 = DateTime.Now.Month.ToString();
            string dd13 = DateTime.Now.Year.ToString();
            string ddd = dd11 + "/" + dd12 + "/" + dd13;
            txtstartdate.Text = ddd;
            txtactualdate.Text = ddd;
            ////txtactualdate.Text = DateTime.Now.AddDays(15).Day + "/" + DateTime.Now.AddDays(15).Month + "/" + DateTime.Now.AddDays(15).Year;
            EditBind();
            Session["dt_st"] = null;
            Session["Update"] = "False";

            ////drpjobstatus.SelectedIndex = 1;
        }


        txtbudhours.Attributes.Add("ReadOnly", "ReadOnly");
        txtBudAmt.Attributes.Add("ReadOnly", "ReadOnly");
        txtbudamtOth.Attributes.Add("ReadOnly", "ReadOnly");

        //Javascript function for show only select staff in assign staff tab & staff budgeting tab
        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "checkall", "$(document).ready(function () { PagePostBackJust_Hide_Rows(); checkEmployeeAssign();}); ", true);
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
                Label15.Text = "Staffs(" + hdnStfCnt.Value + ")";
                Label8.Text = "Department(" + ds.Tables[1].Rows[0]["depid"].ToString() + ")";
            }
            else
            {
                Label15.Text = "Staffs(0)";
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

    public void filljobs()
    {
        string str2 = "SELECT mjobId,mJobname from JobName_Master where CompId='" + hdnCompanyid.Value.ToString() + "' order by mJobName";
        //string str2 = "SELECT mJobname,jobId from vw_Job_New where CLTid='" + drpclientname.SelectedValue + "' order by mJobName";
        DataTable dt_Job = db.GetDataTable(str2);
        if (dt_Job.Rows.Count == 0)
        {
            DrpJob.Enabled = false;
        }
        else
        {
            DrpJob.Enabled = true;
            DrpJob.DataSource = dt_Job;
            DrpJob.DataBind();
        }
    }

    //private bool CheckSubApprover()
    //{
    //    int count = 0;
    //    foreach (DataListItem rw in DlStaff.Items)
    //    {
    //        CheckBox chk1 = (CheckBox)rw.FindControl("chkitem");
    //        if (chk1.Checked == true)
    //        {
    //            count++;
    //        }
    //    }

    //    if (count > 0)
    //    {
    //        return true;
    //    }
    //    else
    //    {
    //        return false;
    //    }
    //}

    public void filljobsGrp()
    {
        string str2 = "SELECT JobGId,JobGroupName from JobGroup_Master where CompId='" + hdnCompanyid.Value.ToString() + "' order by JobGroupName";
        DataTable dt_Job = db.GetDataTable(str2);
        if (dt_Job.Rows.Count == 0)
        {
            drpjobgrp.Enabled = false;
        }
        else
        {
            drpjobgrp.DataSource = dt_Job;
            drpjobgrp.DataBind();
        }
    }

    //public void FillStaff()
    //{
    //    try
    //    {

    //        string str12 = "SELECT * FROM Staff_master where CompId='" + ViewState["compid"].ToString() + "' and Staff_Master.DateOfJoining <= getdate()  and DateOfLeaving is null order by StaffName";
    //        DataTable dt_client1 = db.GetDataTable(str12);
    //        if (dt_client1.Rows.Count == 0)
    //        {

    //        }
    //        else
    //        {
    //            dlstafflist.DataSource = dt_client1;
    //            dlstafflist.DataBind();

    //            if (gvStaffbudget.Rows.Count == 0)
    //            {
    //                gvStaffbudget.DataSource = dt_client1;
    //                gvStaffbudget.DataBind();
    //            }
    //        }
    //    }
    //    catch (Exception ex)
    //    {

    //    }
    //}

    //public void FillDept()
    //{
    //    try
    //    {

    //        string str12 = "SELECT * FROM Department_master where CompId='" + ViewState["compid"].ToString() + "'  order by DepartmentName";
    //        DataTable dt = db.GetDataTable(str12);
    //        if (dt.Rows.Count == 0)
    //        {
    //        }
    //        else
    //        {
    //            Gridstf.DataSource = dt;
    //            Gridstf.DataBind();
    //        }
    //    }
    //    catch (Exception ex)
    //    {

    //    }
    //}
    public void EditBind()
    {
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "asfdsadff", "$(document).ready(function () { callonpageload();    }); ", true);
        DataTable dt = new DataTable();
        //string str1 = "select * from vw_ClientJob where dbo.Job_Master.JobId='" + int.Parse(Session["jobid"].ToString()) + "'";
        string str1 = "select * from vw_ClientJob where JobId='" + int.Parse(hdnJobid.Value.ToString()) + "'";
        dt = db.GetDataTable(str1);
        if (dt != null)
        {
            if (dt.Rows.Count != 0)
            {
                //drpclientname.SelectedValue = dt.Rows[0]["CLTId"].ToString();
                //Bind Selected Client Name 
                #region Ganesh Get Selected Client ID In drpclientname Drop down
                string str = "SELECT * from Client_Master where CompId='" + hdnCompanyid.Value.ToString() + "' and CLTId = '" + dt.Rows[0]["CLTId"].ToString() + "' order by ClientName";
                DataTable dt_client = db.GetDataTable(str);
                if (dt_client.Rows.Count > 0)
                {
                    drpclientname.DataSource = dt_client;
                    drpclientname.DataBind();
                }
                drpclientname.Enabled = false;
                #endregion

                //Bind Selected Job name 
                #region Ganesh Get Selected Job ID In DrpJob Drop down
                string strdt_Job = "SELECT mjobId,mJobname from JobName_Master where CompId='" + hdnCompanyid.Value.ToString() + "' and mJobID='" + dt.Rows[0]["mJobID"].ToString() + "' order by mJobName";
                DataTable dt_Job = db.GetDataTable(strdt_Job);
                if (dt_Job.Rows.Count > 0)
                {
                    DrpJob.DataSource = dt_Job;
                    DrpJob.DataBind();
                }
                //DrpJob.SelectedValue = dt.Rows[0]["mJobID"].ToString();
                DrpJob.Enabled = false;
                #endregion
                //Staff Assign Staffbudget Amount set
                #region Ganesh----Staff Budget Amount and hours Edit
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", hdnCompanyid.Value.ToString());
                param[1] = new SqlParameter("@jobid", hdnJobid.Value.ToString());
                DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_GetSataffBudgetedStaffOnEditJobAdd", param);
                if (dss != null && dss.Tables.Count > 0)
                {
                    if (dss.Tables[0].Rows.Count > 0)
                    {
                        txtbudhours.Text = dss.Tables[0].Rows[0][0].ToString();
                        txtBudAmt.Text = dss.Tables[0].Rows[0][1].ToString();
                        txtbudamtOth.Text = dss.Tables[0].Rows[0][2].ToString();
                    }
                    else
                    {
                        txtbudhours.Text = "0";
                        txtBudAmt.Text = "0";
                        txtbudamtOth.Text = "0";
                    }
                }
                #endregion
                //Staff Assign Staffbudget Amount set

                ddlBudgetingselection.SelectedValue = dt.Rows[0]["BudgetingSelection"].ToString();

                if (dt.Rows[0]["JobGId"].ToString() != "0")
                {
                    drpjobgrp.SelectedValue = dt.Rows[0]["JobGId"].ToString();
                }
                else
                {
                    drpjobgrp.SelectedValue = "0";
                }
                //txtbudamtOth.Text = Convert.ToString(dt.Rows[0]["OtherBudAmt"]);
                //txtbudhours.Text = dt.Rows[0]["BudHours"].ToString();
                string[] fg = dt.Rows[0]["BudAMt"].ToString().Split('.');
                //txtBudAmt.Text = fg[0].ToString();
                //txtbudamtOth.Text=dt.ro



                if (dt.Rows[0]["JobStatus"].ToString() != null || dt.Rows[0]["JobStatus"].ToString() != "")
                {
                    drpjobstatus.Items.FindByText(dt.Rows[0]["JobStatus"].ToString()).Selected = true;
                }

                if (dt.Rows[0]["ActualJobEndate"].ToString() != null && dt.Rows[0]["ActualJobEndate"].ToString() != "01/01/1900")
                {
                    txtactualdate.Text = Convert.ToDateTime(dt.Rows[0]["ActualJobEndate"]).ToString("dd/MM/yyyy");
                    ////txtactualdate.Text = Convert.ToDateTime(dt.Rows[0]["ActualJobEndate"]).ToShortDateString();
                }
                else
                {
                    txtactualdate.Text = "";
                }
                if (dt.Rows[0]["CreationDate"].ToString() != null && dt.Rows[0]["CreationDate"].ToString() != "01/01/1900")
                {
                    txtstartdate.Text = Convert.ToDateTime(dt.Rows[0]["CreationDate"]).ToString("dd/MM/yyyy");
                    ////txtstartdate.Text = Convert.ToDateTime(dt.Rows[0]["CreationDate"]).ToShortDateString();
                }
                else
                {
                    txtstartdate.Text = "";
                }

                if (dt.Rows[0]["Billable"].ToString() != null && dt.Rows[0]["Billable"].ToString() != "False")
                {
                    DrpBillable.SelectedValue = "1";
                }
                else
                {
                    DrpBillable.SelectedValue = "0";
                }
            }
        }

        //string str3 = "select  dbo.Top_Approver.SuperAppId, dbo.Top_Approver.ApproverId, dbo.Job_Master.JobId from vw_JobApprover where dbo.Job_Master.JobId='" + int.Parse(Session["jobid"].ToString()) + "'";
        string str3 = "select  SUBSTRING(SuperAppId, 1, LEN(SuperAppId)-1 ) as SuperAppId, ApproverId,JobId from vw_JobApprover where JobId='" + int.Parse(hdnJobid.Value.ToString()) + "'";
        DataTable dt3 = db.GetDataTable(str3);
        if (dt3.Rows.Count != 0)
        {
            string SAppId = dt3.Rows[0]["SuperAppId"].ToString();
            drpdwnapp.SelectedValue = SAppId;

        }



    }
    public void BindStaff()
    {
        try
        {

            //string str12 = "SELECT * FROM Staff_master where CompId='" + ViewState["compid"].ToString() + "' and Staff_Master.DateOfJoining <= getdate() order by StaffName";
            string str12 = "SELECT * FROM Staff_master  INNER JOIN dbo.Department_Master ON dbo.Staff_Master.DepId = dbo.Department_Master.DepId where Staff_master.CompId='" + hdnCompanyid.Value.ToString() + "' and Staff_Master.DateOfJoining <= getdate() and DateOfLeaving is null  order by StaffName";
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

    protected void BtnUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            if (hdnCompanyid.Value != null)
            {
                if (DrpJob.Text != "" && drpclientname.SelectedValue != "0" && drpdwnapp.SelectedValue != "0" && txtactualdate.Text != "" && txtstartdate.Text != "")
                {
                    string jobname = DrpJob.Text.Trim();
                    int clientid = int.Parse(drpclientname.SelectedValue);
                    int compidd = int.Parse(hdnCompanyid.Value.ToString());
                    job.JobId = int.Parse(hdnJobid.Value.ToString());

                    job.JobName = DrpJob.Text;
                    job.mJobId = int.Parse(DrpJob.SelectedValue);
                    job.StaffCode = 0;
                    if (drpjobgrp.SelectedValue != "0")
                    {
                        job.JobGId = int.Parse(drpjobgrp.SelectedValue);
                    }
                    else
                    {
                        job.JobGId = 0;
                    }
                    if (drpjobstatus.SelectedValue != "0")
                    {
                        job.JobStatus = drpjobstatus.SelectedItem.Text;
                    }
                    else
                    {
                        job.JobStatus = "";
                        ////job.JobStatus = "OnGoing";
                    }

                    job.CLTId = int.Parse(drpclientname.SelectedValue);
                    job.CompId = int.Parse(hdnCompanyid.Value.ToString());
                    if (txtbudhours.Text != "")
                    {
                        job.BudHours = float.Parse(txtbudhours.Text);
                    }
                    else
                    {
                        job.BudHours = 0;
                    }
                    if (txtbudamtOth.Text != "")
                    {
                        job.OtherBudAmt = decimal.Parse(txtbudamtOth.Text);
                    }
                    else
                    {
                        job.OtherBudAmt = 0;
                    }
                    if (txtBudAmt.Text != "")
                    {
                        job.BudAMt = decimal.Parse(txtBudAmt.Text);
                    }
                    else
                    {
                        job.BudAMt = 0;
                    }

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
                    int app = 0;
                    int app1 = 0;

                    DateTime dob = dob1.AddHours(23).AddMinutes(59).AddSeconds(59).AddMilliseconds(59);
                    //DateTime Fdob = Fdob1.AddHours(11).AddMinutes(59).AddSeconds(59).AddMilliseconds(59);
                    DateTime Sdob = Sdob1.AddHours(1).AddMinutes(59).AddSeconds(59).AddMilliseconds(59);

                    if (dob < Sdob)
                    {
                        MessageControl1.SetMessage("Actual End Date must not be less than Creation Date", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {

                        //foreach (DataListItem rw in dlstafflist.Items)
                        //{


                        //    Label staff = (Label)rw.FindControl("lblStfName");
                        //    Label lblId = (Label)rw.FindControl("lblStfId");
                        //    CheckBox chk = (CheckBox)rw.FindControl("chkitemS");
                        //    int Cid = int.Parse(lblId.Text);
                        //    //if (approver == staff.Text)
                        //    //{
                        //    //    app = Cid;
                        //    //}
                        //    if (chk.Checked == true)
                        //    {
                        //        app1 = Cid;
                        //    }
                        //}

                        //if (app1 != 0)
                        //{
                        //if (app != 0)
                        //{
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
                            //////job.ActualJobEndate = DateTime.Now;

                        }
                        //if (txtestenddate.Text != "")
                        //{
                        //    job.EndDate = Fdob;

                        //}

                        ////job.EndDate = null;

                        if (txtstartdate.Text != "")
                        {
                            job.CreationDate = Sdob;

                        }
                        else
                        {
                            job.CreationDate = DateTime.Now;

                        }


                        int res = job.Update();
                        ViewState["compid"] = int.Parse(hdnCompanyid.Value);
                        Session["companyid"] = int.Parse(hdnCompanyid.Value);
                        Session["cltcomp"] = int.Parse(hdnCompanyid.Value);
                        item = job.JobId;
                        hdnJobid.Value = job.JobId.ToString();
                        if (res == 1)
                        {

                            InsertStaffAssign();


                            string del_str = "select * from Top_Approver where CompId='" + hdnCompanyid.Value.ToString() + "' and CLTId='" + clientid + "' and JobId='" + item + "'";
                            DataTable del_dt = db.GetDataTable(del_str);
                            if (del_dt.Rows.Count > 0)
                            {
                                string del_str1 = "delete from Top_Approver where CompId='" + hdnCompanyid.Value.ToString() + "' and CLTId='" + clientid + "' and JobId='" + item + "'";
                                db.ExecuteCommand(del_str1);
                            }


                            insertTopApprover();
                            Common ob = new Common();
                            SqlParameter[] param = new SqlParameter[4];
                            param[0] = new SqlParameter("@compid", hdnCompanyid.Value.ToString());
                            param[1] = new SqlParameter("@jobid", hdnJobid.Value.ToString());
                            if (ddlBudgetingselection.SelectedValue == "Project Budgeting")
                            { param[2] = new SqlParameter("@bud", 1); }
                            else if (ddlBudgetingselection.SelectedValue == "Staff Budgeting")
                            { param[2] = new SqlParameter("@bud", 2); }
                            else { param[2] = new SqlParameter("@bud", 0); }
                            param[3] = new SqlParameter("@budgeting", ddlBudgetingselection.SelectedValue);
                            int ress = SqlHelper.ExecuteNonQuery(ob._cnnString, CommandType.StoredProcedure, "usp_EditJob_Insert_TempStaff_To_StaffBudget", param);
                            //Updated popup starts
                            //string message = "Job successfully Updated";
                            //Page.ClientScript.RegisterStartupScript(this.GetType(), "Popup" , "ShowPopup('" + message + "');", true);
                            //updated popup ends.
                            MessageControl1.SetMessage("Job Successfully Posted", MessageDisplay.DisplayStyles.Success);
                            if (err == true)
                            {
                                MessageControl1.SetMessage("Error in " + ErrType, MessageDisplay.DisplayStyles.Error);
                            }

                            //SendNotificationEmail(emailid);
                            clearall();
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "newevenetcall", "$(document).ready(function () {  setTimeout('Redirect()',2000);    }); ", true);
                            //Label lblstat = (Label)this.Page.Master.FindControl("Label10");
                            //UpdatePanel updatepan = (UpdatePanel)this.Page.Master.FindControl("MasterUpdate");
                            //string query10 = "select count(JobStatus)as ongo from Job_Master where JobStatus='OnGoing' and CompId='" + ViewState["compid"].ToString() + "'";
                            //DataTable dt10 = db.GetDataTable(query10);
                            //if (dt10.Rows.Count != 0 && dt10 != null)
                            //{
                            //    lblstat.Text = dt10.Rows[0]["ongo"].ToString();
                            //}
                            //else
                            //{
                            //    lblstat.Text = "0";
                            //}
                            ////UpdatePanel1.Update();
                            //updatepan.Update();
                        }

                        else
                        {
                            MessageControl1.SetMessage("Error!!! Job cannot be Posted", MessageDisplay.DisplayStyles.Error);
                        }
                        //}
                        //else
                        //{
                        //    MessageControl1.SetMessage("Staff Name not in the List.", MessageDisplay.DisplayStyles.Error);

                        //}
                        //}
                        //else
                        //{
                        //    MessageControl1.SetMessage("No Staff selected for this job", MessageDisplay.DisplayStyles.Error);

                        //}
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
        }
    }

    public void InsertStaffAssign()
    {
        int i = 0;
        int j = 0;

    StartFor:
        try
        {
            j = 0;
            ErrType = "Staff Allocation";

            string delstfstr = "delete from Job_Staff_Table where compid='" + hdnCompanyid.Value.ToString() + "' and Jobid='" + item + "'";
            db.ExecuteCommand(delstfstr);


            hdnAllstfCheckByAjaxCode.Value = hdnAllstfCheckByAjaxCode.Value.TrimEnd(',');

            string[] hdnAllstfCheckByAjaxCodeSplit = hdnAllstfCheckByAjaxCode.Value.Split(',');
            if (hdnAllstfCheckByAjaxCode.Value != "")
            {
                for (i = 0; i < hdnAllstfCheckByAjaxCodeSplit.Length; i++)
                {
                    string st = "insert into Job_Staff_Table(Jobid,Staffcode,compid)values('" + item + "','" + hdnAllstfCheckByAjaxCodeSplit[i] + "','" + hdnCompanyid.Value.ToString() + "')";
                    db.ExecuteCommand(st);

                }
            }
            //foreach (DataListItem rw in dlstafflist.Items)
            //{


            //    j = rw.ItemIndex;
            //    Label lblId1 = (Label)rw.FindControl("lblStfId");
            //    int Cid1 = int.Parse(lblId1.Text);


            //    if (i > 0)
            //    {
            //        if (i == j)
            //        {
            //            i = 0;
            //            rw.ForeColor = System.Drawing.Color.Red;
            //        }
            //    }
            //    else if (i == 0)
            //    {
            //        Label lblId = (Label)rw.FindControl("lblStfId");
            //        int Cid = int.Parse(lblId.Text);
            //        CheckBox chk = (CheckBox)rw.FindControl("chkitemS");
            //        if (chk.Checked == true)
            //        {
            //            string str = "select * from Job_Staff_Table where compid='" + ViewState["compid"].ToString() + "' and Jobid='" + item + "' and StaffCode='" + Cid + "'";
            //            DataTable dt = db.GetDataTable(str);
            //            if (dt.Rows.Count == 0)
            //            {
            //                jobstaff.JobId = item;
            //                jobstaff.StaffCode = Cid;
            //                jobstaff.CompId = int.Parse(ViewState["compid"].ToString());
            //                int res2 = jobstaff.Insert();
            //                if (res2 != 1)
            //                {
            //                    //jobstaff.Delete();
            //                }
            //            }
            //            else
            //            {
            //                MessageControl1.SetMessage("Staff already assign with this job", MessageDisplay.DisplayStyles.Success);
            //            }
            //        }
            //    }
            //}
        }
        catch (Exception ex)
        {
            i = j;
            err = true;
            goto StartFor;
        }
    }


    public void insertTopApprover()
    {

        int i = 0;
        int j = 0;

    StartFor:
        try
        {
            string sappid = drpdwnapp.SelectedValue.ToString() + "y";
            hdnAllAppCheckByAjaxCode.Value = hdnAllAppCheckByAjaxCode.Value.TrimEnd(',');
            hdnAllAppDepidCheckByAjaxCode.Value = hdnAllAppDepidCheckByAjaxCode.Value.TrimEnd(',');

            string[] hdnAllAppCheckByAjaxCodesplit = hdnAllAppCheckByAjaxCode.Value.Split(',');
            string[] hdnAlldepCheckByAjaxCodesplit = hdnAllAppDepidCheckByAjaxCode.Value.Split(',');
            if (hdnAllAppCheckByAjaxCode.Value != "")
            {
                for (i = 0; i < hdnAllAppCheckByAjaxCodesplit.Length; i++)
                {
                    string str = "insert into Top_Approver(CompId,CLTId,JobId,DeptId,ApproverId,SuperAppId)values('" + hdnCompanyid.Value.ToString() + "','" + drpclientname.SelectedValue + "','" + item + "','" + hdnAlldepCheckByAjaxCodesplit[i] + "','" + hdnAllAppCheckByAjaxCodesplit[i] + "','" + sappid + "')";
                    db.ExecuteCommand(str);
                }
            }

            //foreach (DataListItem rw in DlStaff.Items)
            //{
            //    j = rw.ItemIndex;
            //    Label lblId1 = (Label)rw.FindControl("lblStfId");
            //    int Cid1 = int.Parse(lblId1.Text);


            //    if (i > 0)
            //    {
            //        if (i == j)
            //        {
            //            i = 0;
            //            rw.ForeColor = System.Drawing.Color.Red;
            //        }
            //    }
            //    else if (i == 0)
            //    {


            //        Label lblSId = (Label)rw.FindControl("lblstfid");
            //        int Sid = int.Parse(lblSId.Text);
            //        Label lblDId = (Label)rw.FindControl("lbldepid");
            //        int Did = int.Parse(lblDId.Text);
            //        string sappid = drpdwnapp.SelectedValue.ToString() + "y";
            //        CheckBox chk1 = (CheckBox)rw.FindControl("chkitem");

            //        if (chk1.Checked == true)
            //        {
            //            if (Sid != Convert.ToInt32(drpdwnapp.SelectedValue.ToString()))
            //            {
            //                string str = "insert into Top_Approver(CompId,CLTId,JobId,DeptId,ApproverId,SuperAppId)values('" + hdnCompanyid.Value.ToString() + "','" + drpclientname.SelectedValue + "','" + item + "','" + Did + "','" + Sid + "','" + sappid + "')";
            //                int resT = db.ExecuteCommand(str);

            //            }
            //            else
            //            {
            //                MessageControl2.SetMessage("Super Approver can't be sub approver", MessageDisplay.DisplayStyles.Info);
            //            }

            //        }
            //    }
            //}

        }
        catch (Exception ex)
        {
            ErrType = ErrType + "   " + "Approver";
            i = j;
            err = true;
            goto StartFor;
        }
    }
    public void clearall()
    {
        //DrpJob.Text = string.Empty;
        txtactualdate.Text = string.Empty;

        txtbudhours.Text = string.Empty;
        txtBudAmt.Text = string.Empty;


        ////drpclientname.SelectedValue = "0";
        ////drpjobgrp.SelectedValue = "0";
        ////drpjobstatus.SelectedValue = "0";
        //foreach (DataListItem rw in dlstafflist.Items)
        //{
        //    CheckBox chk = (CheckBox)rw.FindControl("chkitemS");
        //    chk.Checked = false;
        //}
    }


    protected string CheckNull(object objGrid)
    {
        if (object.ReferenceEquals(objGrid, DBNull.Value))
        {
            return "-";
        }
        else
        {
            return objGrid.ToString();
        }
    }

    public void ClearRecords()
    {
        txtBamt.Text = string.Empty;
        txtOBA.Text = string.Empty;
        txtBHours.Text = string.Empty;

    }

    protected void SqlDataSource2_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {

    }

    protected void btncancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("cmp_Managejob.aspx", true);
    }

}
