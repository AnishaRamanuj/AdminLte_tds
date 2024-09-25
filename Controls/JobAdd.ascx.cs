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

public partial class controls_JobAdd : System.Web.UI.UserControl
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
            filljobs();
            filljobsGrp();
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

    public void filljobs()
    {
        //string str2 = "SELECT mjobId,mJobname from JobName_Master where CompId='" + ViewState["compid"].ToString() + "' order by mJobName";
        //string str2 = "SELECT mJobname,jobId from vw_Job_New where CLTid='" + drpclientname.SelectedValue + "' order by mJobName";
        string str2 = " SELECT mjobId,mJobname from JobName_Master where CompId=" + hdnCompanyid.Value.ToString() + " and MJobId not in(select mJobID from job_master where CompId=" + hdnCompanyid.Value.ToString() + " and CLTId=" + drpclientname.SelectedValue + ")order by mJobName";
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

    //        string str12 = "SELECT * FROM Staff_master where CompId='" + hdnCompanyid.Value.ToString() + "' and Staff_Master.DateOfJoining <= getdate() and DateOfLeaving is null order by StaffName";
    //        DataTable dt_client1 = db.GetDataTable(str12);
    //        if (dt_client1.Rows.Count == 0)
    //        {

    //        }
    //        else
    //        {
    //            //dlstafflist.DataSource = dt_client1;
    //            //dlstafflist.DataBind();

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
    protected void drpclientname_SelectedIndexChanged(object sender, EventArgs e)
    {
        filljobs();
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

    //private bool CheckSubApprover()
    //{
    //    int count = 0;
    //    foreach (DataListItem rw in DlStaff.Items)
    //    {
    //        CheckBox chk1 = (CheckBox)rw.FindControl("chksubapproveritem");
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

    protected void BtnSave_Click(object sender, EventArgs e)
    {

        try
        {

            if (hdnCompanyid.Value != null)
            {

                ErrType = "Job";
                if (DrpJob.Text != "" && drpclientname.SelectedValue != "0" && drpdwnapp.SelectedValue != "0" && txtactualdate.Text != "" && txtstartdate.Text != "")
                {
                    string jobname = DrpJob.Text.Trim();
                    int clientid = int.Parse(drpclientname.SelectedValue);
                    int compidd = int.Parse(hdnCompanyid.Value.ToString());
                    string strquery = "select * from job_Master where CompId='" + compidd + "' and CLTId='" + clientid + "' and mJobId = '" + jobname + "'";
                    DataTable jobdup = db.GetDataTable(strquery);
                    if (jobdup.Rows.Count > 0)
                    {
                        MessageControl1.SetMessage("Job Name already exists.", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
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
                            job.JobStatus = "OnGoing";
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

                        DateTime dob = dob1.AddHours(23).AddMinutes(59).AddSeconds(59).AddMilliseconds(59);
                        //DateTime Fdob = Fdob1.AddHours(11).AddMinutes(59).AddSeconds(59).AddMilliseconds(59);
                        DateTime Sdob = Sdob1.AddHours(1).AddMinutes(59).AddSeconds(59).AddMilliseconds(59);

                        if (dob < Sdob)
                        {
                            MessageControl1.SetMessage("Actual End Date must not be less than Creation Date", MessageDisplay.DisplayStyles.Error);
                        }
                        else
                        {

                            string billable = DrpBillable.SelectedValue.ToString() ;
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


                            int res = job.Insert();
                            item = job.JobId;
                            ViewState["compid"] = int.Parse(hdnCompanyid.Value);
                            Session["companyid"] = int.Parse(hdnCompanyid.Value);
                            Session["cltcomp"] = int.Parse(hdnCompanyid.Value);

                            if (res == 1)
                            {
                                InsertStaffAssign();

                                // ErrType = ErrType + "  " + "Approver";
                                string del_str = "select * from Top_Approver where CompId='" + hdnCompanyid.Value.ToString() + "' and CLTId='" + clientid + "' and JobId='" + DrpJob.SelectedValue + "'";
                                DataTable del_dt = db.GetDataTable(del_str);
                                if (del_dt.Rows.Count > 0)
                                {
                                    string del_str1 = "delete from Top_Approver where CompId='" + hdnCompanyid.Value.ToString() + "' and CLTId='" + clientid + "' and JobId='" + DrpJob.SelectedValue + "'";
                                    db.ExecuteCommand(del_str1);
                                }

                                insertTopApprover();

                                #region Ganesh Staff Budget Amount and Hours add to Database
                                //GET selected staff budgetd amt and hours in datatable
                                hdnAllstfCheckByAjaxCode.Value = hdnAllstfCheckByAjaxCode.Value.TrimEnd('/');
                                string[] hdnAllstfCheckByAjaxCodeSplit = hdnAllstfCheckByAjaxCode.Value.Split('/');
                                DataTable dtStaffBugetsEmployee = new DataTable();
                                dtStaffBugetsEmployee.Columns.Add("staffcode");
                                dtStaffBugetsEmployee.Columns.Add("budgetamt");
                                dtStaffBugetsEmployee.Columns.Add("budgethr");
                                dtStaffBugetsEmployee.Columns.Add("planneddrawings");////////planDrawing
                                dtStaffBugetsEmployee.Columns.Add("allocatedhr");
                                dtStaffBugetsEmployee.Columns.Add("staffactualrate");
                                DataRow dr;
                                foreach (string row in hdnAllstfCheckByAjaxCodeSplit)
                                {
                                    string[] staffdetails = row.Split(',');
                                    if (staffdetails.Length == 7)
                                    {
                                        dr = dtStaffBugetsEmployee.NewRow();
                                        dr["staffcode"] = staffdetails[0];
                                        dr["budgetamt"] = staffdetails[1];
                                        dr["budgethr"] = staffdetails[2];
                                        dr["planneddrawings"] = staffdetails[3];
                                        dr["allocatedhr"] = staffdetails[4];
                                        dr["staffactualrate"] = staffdetails[5];
                                        dtStaffBugetsEmployee.Rows.Add(dr);
                                    }
                                }

                                Common ob = new Common();
                                SqlParameter[] param = new SqlParameter[8];
                                param[0] = new SqlParameter("@dtStaffBugetsEmployee", dtStaffBugetsEmployee);
                                param[1] = new SqlParameter("@compid", hdnCompanyid.Value.ToString());
                                param[2] = new SqlParameter("@jobnameid", DrpJob.SelectedValue);
                                param[3] = new SqlParameter("@clientid", drpclientname.SelectedValue);
                                if (ddlBudgetingselection.SelectedValue == "Project Budgeting")
                                {
                                    param[4] = new SqlParameter("@BudAMt", txtBudAmt.Text);
                                    param[5] = new SqlParameter("@BudHr", txtbudhours.Text);
                                    param[6] = new SqlParameter("@Other", txtbudamtOth.Text);
                                }
                                else
                                {
                                    param[4] = new SqlParameter("@BudAMt", 0);
                                    param[5] = new SqlParameter("@BudHr", 0);
                                    param[6] = new SqlParameter("@Other", 0);
                                }
                                param[7]=new SqlParameter("@BudgetingSelection",ddlBudgetingselection.SelectedValue);
                                int resu = SqlHelper.ExecuteNonQuery(ob._cnnString, CommandType.StoredProcedure, "usp_insertStaffBudgettingFromjobadd", param);
                                #endregion

                                MessageControl1.SetMessage("Job Successfully Posted", MessageDisplay.DisplayStyles.Success);
                                if (err == true)
                                {
                                    MessageControl1.SetMessage("Error in " + ErrType, MessageDisplay.DisplayStyles.Error);

                                }
                                //SendNotificationEmail(emailid);
                                clearall();
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "newevenetcall", "$(document).ready(function () {  setTimeout('Redirect()',3000);    }); ", true);


                                //Response.Redirect("cmp_Managejob.aspx", false);
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


            hdnAllstfCheckByAjaxCode.Value = hdnAllstfCheckByAjaxCode.Value.TrimEnd('/');

            string[] hdnAllstfCheckByAjaxCodeSplit = hdnAllstfCheckByAjaxCode.Value.Split('/');
            if (hdnAllstfCheckByAjaxCode.Value != "")
            {
                for (i = 0; i < hdnAllstfCheckByAjaxCodeSplit.Length; i++)
                {
                    string[] staffffff = hdnAllstfCheckByAjaxCodeSplit[i].ToString().Split(',');
                    string st = "insert into Job_Staff_Table(Jobid,Staffcode,compid)values('" + item + "','" + staffffff[0] + "','" + hdnCompanyid.Value.ToString() + "')";
                    db.ExecuteCommand(st);

                }
            }
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
        }
        catch (Exception ex)
        {
            ErrType = ErrType + "   " + "Approver";
            i = j;
            err = true;
            goto StartFor;
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
        txtbudhours.Text = string.Empty;
        txtBudAmt.Text = string.Empty;
        drpdwnapp.SelectedValue = "0";

        //drpclientname.SelectedValue = "0";
        //drpjobgrp.SelectedValue = "0";
        drpjobstatus.SelectedValue = "0";
        //foreach (DataListItem rw in dlstafflist.Items)
        //{
        //    CheckBox chk = (CheckBox)rw.FindControl("chkitemS");
        //    chk.Checked = false;
        //}

        //foreach (DataListItem rw in DlStaff.Items)
        //{
        //    CheckBox chk1 = (CheckBox)rw.FindControl("chksubapproveritem");
        //    chk1.Checked = false;
        //}

        //foreach (GridViewRow row in Gridstf.Rows)
        //{
        //    CheckBox chk = (CheckBox)row.FindControl("chk1");
        //    chk.Checked = false;
        //}
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
                            filljobs();
                            DrpJob.SelectedValue = JobN.mJobid.ToString() ; 
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
    protected void btnsJg_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                if (txtjg.Text != "")
                {
                    string str = "select JobGroupName from dbo.JobGroup_Master where JobGroupName ='" + txtjg.Text.Trim() + "' and CompId='" + hdnCompanyid.Value.ToString() + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {

                        jobgrp.CompId = int.Parse(hdnCompanyid.Value.ToString());
                        jobgrp.id = 0;
                        jobgrp.JobGroupName = txtjg.Text;
                        int res = jobgrp.Insert();
                        ViewState["compid"] = int.Parse(hdnCompanyid.Value);
                        Session["companyid"] = int.Parse(hdnCompanyid.Value);
                        Session["cltcomp"] = int.Parse(hdnCompanyid.Value);
                        if (res == 1)
                        {
                            filljobsGrp();
                            MessageControl4.SetMessage("Job Group Added Successfully", MessageDisplay.DisplayStyles.Success);
                            txtjg.Text = "";
                            drpjobgrp.SelectedValue = jobgrp.JobGId.ToString(); 
                        }
                        else
                            MessageControl4.SetMessage("Error!!!Job Group not Added", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
                        MessageControl4.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl4.SetMessage("Please Enter a Job Group.", MessageDisplay.DisplayStyles.Error);
                }

                txtjg.Text = "";
                ModalPopupExtender2.Show();
                txtjg.Focus();
            }
            else
            {
                MessageControl4.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {
            ViewState["compid"] = int.Parse(hdnCompanyid.Value);
            Session["companyid"] = int.Parse(hdnCompanyid.Value);
            Session["cltcomp"] = int.Parse(hdnCompanyid.Value);
        }

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
        //foreach (DataGridItem row in dlstafflist.Items)
        //{
        //    CheckBox chkitemS = (CheckBox)row.FindControl("chkitemS");
        //    Label lblStfId = (Label)row.FindControl("lblStfId");
        //    Label lblStfName = (Label)row.FindControl("lblStfName");
        //    if (chkitemS.Checked)
        //    {
        //        dr = dt.NewRow();
        //        dr["EmployeeID"] = lblStfId.Text;
        //        dr["EmployeeName"] = lblStfName.Text;
        //        dr["budgetamt"] = "0";
        //        dr["budgethr"] = "0";
        //    }
        //}

    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("cmp_Managejob.aspx", true);
    }
}
