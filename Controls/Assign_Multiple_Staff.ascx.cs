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

public partial class controls_Assign_Multiple_Staff : System.Web.UI.UserControl
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
    public string UserType = "";
    public string Staffid = "";

    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            if (Session["companyid"] != null)
            {
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["cltcomp"].ToString();
            }
            if (ViewState["compid"] != null)
            {
                UserType = Session["usertype"].ToString();
                if (UserType == "staff")
                {
                    Staffid = Session["staffid"].ToString();
                    Session["IsApprover"] = Staffid;
                }
                bind();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            //UserType = Session["usertype"].ToString();
            //if (UserType == "staff")
            //{
            //    Staffid = Session["staffid"].ToString();
            //    Session["IsApprover"] = Staffid;
            //}
            //bind();
        }
    }


    public void bind()
    {
        // ********** Client
        string ss = "";
            ss = "SELECT distinct(ClientName),Cltid FROM Client_Master where CompId='" + ViewState["compid"].ToString() + "' order by ClientName";

        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            DlstCLT.DataSource = dt;
            DlstCLT.DataBind();
            Label60.Visible = false;
            //drpclient.Items.Remove("--None--");
        }
        else
        {
            DlstCLT.DataSource = null;
            DlstCLT.DataBind();
            Label60.Visible = true;
        }




        //// ********** Staff

        ss = "select distinct(StaffCode),StaffName from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' order by StaffName";
        string ss1 = ss;
        //string ss1 = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' order by StaffName";
        DataTable dt1 = db.GetDataTable(ss1);
        if (dt1.Rows.Count != 0)
        {
            drpStf.Items.Clear();
            drpStf.DataSource = dt1;
            drpStf.DataBind();
            drpStf.Items.Insert(0, "Select");
            Label70.Visible = false;
        }
        else
        {
            drpStf.Items.Clear();
            drpStf.Items.Insert(0, "Select");
            Label70.Visible = true;
        }

        
        
        
        //***************** Job


        ss = "Select distinct(jobid),  mjobname + '-->' + ClientName as mjobName from  vw_JobnClinetnStaff where CompId='" + ViewState["compid"].ToString() + "'  order by mjobName";
        string ss2 = ss;
        DataTable dt2 = db.GetDataTable(ss2);
        if (dt2.Rows.Count != 0)
        {
            DlstJob.DataSource = dt2;
            DlstJob.DataBind();
            Label63.Visible = false;
        }
        else
        {
            DlstJob.DataSource = null;
            DlstJob.DataBind();
            Label63.Visible = true;
        }



        ////***************** Job Group


        ss = "select distinct(JobGId),JobGroupName from vw_JobGroupnAllJobs where CompId='" + ViewState["compid"].ToString() + "' order by JobGroupName";
        string ss3 = ss;
        DataTable dt3 = db.GetDataTable(ss3);
        if (dt3.Rows.Count != 0)
        {
            DLstJgrp.DataSource = dt3;
            DLstJgrp.DataBind();
            Label63.Visible = false;
        }
        else
        {
            DLstJgrp.DataSource = null;
            DLstJgrp.DataBind();
            Label63.Visible = true;
        }

    }

    protected void ChkJgrp_CheckedChanged(object sender, EventArgs e)
    {
        if (ChkJgrp.Checked == true)
        {

            foreach (DataListItem rw in DLstJgrp.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitmJrp");
                chk.Checked = true;
            }

            foreach (DataListItem rw in DlstCLT.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }

            foreach (DataListItem rw in DlstJob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitmJob");
                chk.Checked = true;
            }
        }
        else if (ChkJgrp.Checked == false)
        {

            foreach (DataListItem rw in DLstJgrp.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitmJrp");
                chk.Checked = false;
            }


            foreach (DataListItem rw in DlstCLT.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }

            foreach (DataListItem rw in DlstJob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitmJob");
                chk.Checked = false;
            }
        }
    }


    protected void chkjob_CheckedChanged(object sender, EventArgs e)
    {
        if (chkjob.Checked == true)
        {
            foreach (DataListItem rw in DlstJob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitmJob");
                chk.Checked = true;
            }
        }
        else if (chkjob.Checked == false)
        {
            foreach (DataListItem rw in DlstJob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitmJob");
                chk.Checked = false;
            }
        }

    }



    protected void chkclient_CheckedChanged(object sender, EventArgs e)
    {
        if (chkclient.Checked == true)
        {
            foreach (DataListItem rw in DlstCLT.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (chkclient.Checked == false)
        {
            foreach (DataListItem rw in DlstCLT.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
        }
    }




    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        

        jobstaff.StaffCode = int.Parse(drpStf.SelectedValue.ToString())  ;
        string delstfstr = "delete from Job_Staff_Table where compid='" + ViewState["compid"].ToString() + "'  and staffcode='" + drpStf.SelectedValue + "'";
        db.ExecuteCommand(delstfstr);

        foreach (DataListItem dl1 in DlstJob.Items)
        {
            Label lblId = (Label)dl1.FindControl("Label50");
            string widd = lblId.Text;
            CheckBox chk = (CheckBox)dl1.FindControl("chkitmJob");
            if (chk.Checked == true)
            {
               //JobID = widd ;

                    if (drpStf.SelectedValue != "Select")
                    {
                        jobstaff.JobId = int.Parse(widd);

                        jobstaff.CompId = int.Parse(ViewState["compid"].ToString());
                        int res2 = jobstaff.Insert();
                        if (res2 != 1)
                        {
                            //jobstaff.Delete();
                            MessageControl.SetMessage("Job Error", MessageDisplay.DisplayStyles.Error);
                        }

                    }

             } 

        }

  
        MessageControl.SetMessage("Job Successfully Posted", MessageDisplay.DisplayStyles.Success);
    }
   

    protected void chkitmJrp_CheckedChanged(object sender, EventArgs e)
    {
        string Jgrpid = "";
        string JobID = "";
        string widd1 = "";
        string Clientid = "";

        resetChkJob();
        foreach (DataListItem dl1 in DLstJgrp.Items)
        {
            Label lblId = (Label)dl1.FindControl("Label50");
            string widd = lblId.Text;
            CheckBox chk = (CheckBox)dl1.FindControl("chkitmJrp");
            if (chk.Checked == true)
            {
                Jgrpid = widd;
                widd1 = widd;
                string ss = "SELECT * FROM vw_JobGroupnAllJobs WHERE JobGId='" + widd + "'";
                DataTable dt = db.GetDataTable(ss);
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow dr in dt.Rows)
                    {

                        //JobID = dr["JobId"].ToString();
                        foreach (DataListItem rw in DlstJob.Items)
                        {
                            Label lblId1 = (Label)rw.FindControl("Label50");
                            if (lblId1.Text == dr["JobId"].ToString())
                            {
                                CheckBox chk1 = (CheckBox)rw.FindControl("chkitmJob");
                                chk1.Checked = true;
                                JobID += "" + lblId1.Text + "" + ",";
                            }
                        }

                        Clientid = dr["CLTId"].ToString();
                        foreach (DataListItem rw in DlstCLT.Items)
                        {
                            Label lblId1 = (Label)rw.FindControl("Label50");
                            if (lblId1.Text == dr["CltId"].ToString())
                            {
                                CheckBox chk1 = (CheckBox)rw.FindControl("chkitem");
                                chk1.Checked = true;
                            }
                        }
                    }

                   
                }

            }
        }
    }

    private void resetChkJGrp()
    {
        foreach (DataListItem rw in DLstJgrp.Items)
        {
            CheckBox chk = (CheckBox)rw.FindControl("chkitmJrp");
            chk.Checked = false;
        }

        foreach (DataListItem rw in DlstCLT.Items)
        {
            CheckBox chk = (CheckBox)rw.FindControl("chkitem");
            chk.Checked = false;
        }

        foreach (DataListItem rw in DlstJob.Items)
        {
            CheckBox chk = (CheckBox)rw.FindControl("chkitmJob");
            chk.Checked = false;
        }


    }


    private void resetChkJob()
    {

        foreach (DataListItem rw in DlstJob.Items)
        {
            CheckBox chk = (CheckBox)rw.FindControl("chkitmJob");
            chk.Checked = false;
        }

        foreach (DataListItem rw in DlstCLT.Items)
        {
            CheckBox chk = (CheckBox)rw.FindControl("chkitem");
            chk.Checked = false;
        }

    }

    protected void drpStf_SelectedIndexChanged(object sender, EventArgs e)
    {
        string Jgrpid = "";
        string JobID = "";
        string widd1 = "";
        string Clientid = "";

        resetChkJGrp();
        //foreach (DataListItem dl1 in DLstJgrp.Items)

            
            if (drpStf.SelectedValue != "Select")
            {
               
               
                string ss = "SELECT dbo.JobGroup_Master.JobGroupName, dbo.Client_Master.ClientName, dbo.Job_Staff_Table.StaffCode, dbo.Job_Master.JobId, dbo.Job_Master.CLTId," 
                + " dbo.Job_Master.mJobID, dbo.JobName_Master.MJobName, dbo.JobGroup_Master.JobGId FROM dbo.Job_Master INNER JOIN dbo.JobGroup_Master ON "
                + " dbo.Job_Master.JobGId = dbo.JobGroup_Master.JobGId INNER JOIN dbo.Client_Master ON dbo.Job_Master.CLTId = dbo.Client_Master.CLTId INNER JOIN "
                + " dbo.Job_Staff_Table ON dbo.Job_Master.JobId = dbo.Job_Staff_Table.JobId INNER JOIN dbo.JobName_Master ON dbo.Job_Master.mJobID = dbo.JobName_Master.MJobId WHERE dbo.Job_Staff_Table.Staffcode='" + drpStf.SelectedValue + "'";
                DataTable dt = db.GetDataTable(ss);
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow dr in dt.Rows)
                    {


                        foreach (DataListItem rw in DLstJgrp.Items)
                        {
                            Label lblId1 = (Label)rw.FindControl("Label50");
                            if (lblId1.Text == dr["JobGId"].ToString())
                            {
                                CheckBox chk1 = (CheckBox)rw.FindControl("chkitmJrp");
                                chk1.Checked = true;
                                Jgrpid += "" + lblId1.Text + "" + ",";
                            }
                        }


                        //JobID = dr["JobId"].ToString();
                        foreach (DataListItem rw1 in DlstJob.Items)
                        {
                            Label lblId1 = (Label)rw1.FindControl("Label50");
                            if (lblId1.Text == dr["JobId"].ToString())
                            {
                                CheckBox chk1 = (CheckBox)rw1.FindControl("chkitmJob");
                                chk1.Checked = true;
                                JobID += "" + lblId1.Text + "" + ",";
                            }
                        }

                        Clientid = dr["CLTId"].ToString();
                        foreach (DataListItem rw2 in DlstCLT.Items)
                        {
                            Label lblId1 = (Label)rw2.FindControl("Label50");
                            if (lblId1.Text == dr["CltId"].ToString())
                            {
                                CheckBox chk1 = (CheckBox)rw2.FindControl("chkitem");
                                chk1.Checked = true;
                            }
                        }
                    }


                }

            }
       
    }




}