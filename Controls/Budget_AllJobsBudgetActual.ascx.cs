﻿using System;
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

public partial class controls_Budget_AllJobsBudgetActual : System.Web.UI.UserControl
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
    public Boolean BlnApprover = false;
    public string JobID = "";
    public string id = "";
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
                job_new();
                string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
                txtfrmdt.Text = dat;
                txttodt.Text = dat;
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
            //job_new();
            //string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            //txtfrmdt.Text = dat;
            //txttodt.Text = dat;
        }
        txtfrmdt.Attributes.Add("onblur", "checkForm();");

        txttodt.Attributes.Add("onblur", "checkForms();");
    }
    public void job_new()
    {

        string ss = "";
        if (UserType == "staff")
        {
            if (Convert.ToString(Session["Jr_ApproverId"]).Equals("true"))
            {
                Session["StaffType"] = "App";
                // ss = "select distinct(mJobId),mJobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by mJobName";
                ss = "SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'" +
                " union" +

                " SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by mJobName";
            }
            else
            {
                //ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by StaffName";
                ss = "select distinct(mJobId),mJobName from vw_JobnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by mJobName";
            }
        }

        else
        {
            ss = "select distinct(mjobname),mjobid  from Job_Master_new where CompId='" + ViewState["compid"].ToString() + "' order by mJobName";
        }
        DataTable dt1 = db.GetDataTable(ss);
        if (dt1.Rows.Count != 0)
        {
            dlbudjob.DataSource = dt1;
            dlbudjob.DataBind();
            // Label28.Visible = false;
        }
        else
        {

            dlbudjob.DataSource = null;
            dlbudjob.DataBind();
            // Label28.Visible = true;
        }
    }

    public void bind()
    {
        try
        {
            string ss = "";

            if (UserType == "staff")
            {

                if (Convert.ToString(Session["Jr_ApproverId"]).Equals("true"))
                {
                    Session["StaffType"] = "App";
                    //ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by ClientName";
                    ss = "select distinct(Cltid),ClientName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' " +

                   " union" +

                    " SELECT distinct(Cltid),ClientName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by ClientName";
                }
                else
                {
                    Session["StaffType"] = "Stf";
                    ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClientnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by ClientName";
                }
            }
            else
            {
                Session["StaffType"] = "Adm";
                ss = "select * from Client_Master  where CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
            }
            string ss2 = ss;
            //string ss2 = "select client_name,CLTid from Client_Master where CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
            DataTable dt2 = db.GetDataTable(ss2);
            if (dt2.Rows.Count != 0)
            {
                dlbudclient.DataSource = dt2;
                dlbudclient.DataBind();
                Label42.Visible = false;
            }
            else
            {
                dlbudclient.DataSource = null;
                dlbudclient.DataBind();
                Label42.Visible = true;
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void chkbudcl_CheckedChanged(object sender, EventArgs e)
    {
        if (chkbudcl.Checked == true)
        {
            foreach (DataListItem rw in dlbudclient.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
            foreach (DataListItem rw in dlbudjob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (chkbudcl.Checked == false)
        {
            foreach (DataListItem rw in dlbudclient.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
            foreach (DataListItem rw in dlbudjob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }
    protected void chkbudjob_CheckedChanged(object sender, EventArgs e)
    {
        if (chkbudjob.Checked == true)
        {
            foreach (DataListItem rw in dlbudjob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (chkbudjob.Checked == false)
        {
            foreach (DataListItem rw in dlbudjob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }
    protected void btngrnreport_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/Budget_AllJobsBudgetActual.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "Staff/Budget_AllJobsBudgetActual.aspx";
            }
            if (ViewState["compid"].ToString() == "" || txtfrmdt.Text == "" || txttodt.Text == "")
            {
                MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
            else
            {
                int comp = int.Parse(ViewState["compid"].ToString());
                id = "";
                //ArrayList[] ar= new Array[0];
                foreach (DataListItem rw in dlbudclient.Items)
                {
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        Label lblId = (Label)rw.FindControl("Label50");
                        int Cid = int.Parse(lblId.Text);

                        id += Cid + ",";
                    }
                }

                if (id != "")
                {
                    id = id.Remove(id.Length - 1, 1);
                }

                Session["clt"] = id;
                id = "";
                foreach (DataListItem rw in dlbudjob.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label50");
                    int joid = int.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                    if (chk.Checked == true)
                    {
                        id += joid + ",";
                    }
                }

                if (id != "")
                {
                    id = id.Remove(id.Length - 1, 1);
                }

                Session["job"] = id;


                CultureInfo info = new CultureInfo("en-US", false);
                DateTime Fdob = new DateTime(1900, 1, 1);
                DateTime dob = new DateTime(1900, 1, 1);
                String _dateFormat = "dd/MM/yyyy";
                if (txtfrmdt.Text.Trim() != "" && !DateTime.TryParseExact(txtfrmdt.Text.Trim(), _dateFormat, info,
                                                                                                     DateTimeStyles.AllowWhiteSpaces, out Fdob))
                {
                }
                if (txttodt.Text.Trim() != "" && !DateTime.TryParseExact(txttodt.Text.Trim(), _dateFormat, info,
                                                                                                      DateTimeStyles.AllowWhiteSpaces, out dob))
                {
                }
                DateTime EDT = dob;
                DateTime FDT = Fdob;

                string ST = "";
                string Ed = "";
                ST = String.Format("{0:MM/dd/yyyy}", Fdob);
                Ed = String.Format("{0:MM/dd/yyyy}", dob);
                Session["startdate"] = FDT;
                Session["enddate"] = EDT;

                // string stftype = Session["StaffType"].ToString();

                string cl = Session["clt"].ToString();
                string job = Session["job"].ToString();
                string sql = "";
                //if (stftype == "App")
                //{
                //    sql = "SELECT  * FROM vw_Budget_AllJobsBudgetActual where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ")  and Date between '" + ST + "' and '" + Ed + "' and JobApprover='" + Session["IsApprover"].ToString() + "' order by Date";
                //}
                //else if (stftype == "Adm")
                //{
                //    sql = "SELECT  * FROM vw_Budget_AllJobsBudgetActual where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ") and Date between '" + ST + "' and '" + Ed + "' order by Date";
                //}
                //else if (stftype == "Stf")
                //{
                //    sql = "SELECT  * FROM vw_Budget_AllJobsBudgetActual where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ") and Date between '" + ST + "' and '" + Ed + "' and staffcode='" + Session["IsApprover"].ToString() + "' order by Date";
                //}

                UserType = Session["usertype"].ToString();
                if (UserType == "staff")
                {
                    if (Session["Jr_ApproverId"] == "true")
                    {
                        //sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.status='Approved' and t.CltId in (" + Session["clt"] + ") and j.mJobID in (" + Session["job"] + ")and Date between '" + ST + "' and '" + Ed + "' and JobApprover='" + Session["IsApprover"].ToString() + "' order by c.ClientName";
                        sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.status='Approved' and t.CltId in (" + Session["clt"] + ") and j.mJobID in (" + Session["job"] + ")and Date between '" + ST + "' and '" + Ed + "' and  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' " +
                         " union" +
                        " SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.status='Approved' and t.CltId in (" + Session["clt"] + ") and j.mJobID in (" + Session["job"] + ")and Date between '" + ST + "' and '" + Ed + "' and  (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by ClientName";
                    }
                    else
                    {
                        sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.status='Approved' and t.CltId in (" + Session["clt"] + ") and j.mJobID in (" + Session["job"] + ")and Date between '" + ST + "' and '" + Ed + "'  order by c.ClientName";
                    }
                }
                else
                {
                    sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.status='Approved' and t.CltId in (" + Session["clt"] + ") and j.mJobID in (" + Session["job"] + ")and Date between '" + ST + "' and '" + Ed + "'  order by c.ClientName";
                }
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                sqlConn.Open();
                SqlCommand cmd1 = new SqlCommand("delete from Detailed2Loops where Usr='" + Session["StaffType"] + "' and compid='" + comp + "'", sqlConn);
                cmd1.ExecuteNonQuery();
                SqlCommand cmd2 = new SqlCommand("delete from Summary2Loops where Usr='" + Session["StaffType"] + "' and compid='" + comp + "'", sqlConn);
                cmd2.ExecuteNonQuery();
                SqlCommand cmd3 = new SqlCommand("delete from GrandTotal2Loops where Usr='" + Session["StaffType"] + "' and compid='" + comp + "'", sqlConn);
                cmd3.ExecuteNonQuery();




                SqlDataAdapter dscmd = new SqlDataAdapter(sql, sqlConn);
                DataSet ds = new DataSet();
                dscmd.Fill(ds, "Product");
                if (ds.Tables[0].Rows.Count > 0)
                {
                    Response.Redirect("~/Report_Budget_AlljobsBudgetActual.aspx?comp=" + comp + "&id=" + id + "&pagename=Budget_AllJobsBudgetActual" + "&pagefolder=Budget", false);
                }
                else
                {
                    MessageControl2.SetMessage("Timesheets Not Approved", MessageDisplay.DisplayStyles.Error);
                }
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void chkitem_CheckedChanged(object sender, EventArgs e)
    {
        foreach (DataListItem dl1 in dlbudclient.Items)
        {
            Label lblId = (Label)dl1.FindControl("Label50");
            string widd = lblId.Text;
            CheckBox chk = (CheckBox)dl1.FindControl("chkitem");
            if (chk.Checked == true)
            {
                string ss = "SELECT DISTINCT (dbo.JobName_Master.MJobId), JobName_Master.MJobName FROM dbo.Job_Staff_Table INNER JOIN Staff_Master ON dbo.Job_Staff_Table.StaffCode = dbo.Staff_Master.StaffCode INNER JOIN Job_Master ON dbo.Job_Staff_Table.JobId = dbo.Job_Master.JobId INNER JOIN JobName_Master ON dbo.Job_Master.MJobid = dbo.JobName_Master.MJobId INNER JOIN Client_Master ON dbo.Job_Master.CLTId = dbo.Client_Master.CLTId  WHERE dbo.Client_Master.CLTId='" + widd + "' order by JobName_Master.MJobName asc";
                DataTable dt = db.GetDataTable(ss);
                if (dt.Rows.Count > 0)
                {

                    foreach (DataRow dr in dt.Rows)
                    {
                        JobID = dr["MJObId"].ToString();
                        foreach (DataListItem rw in dlbudjob.Items)
                        {
                            Label lblId1 = (Label)rw.FindControl("Label50");
                            if (lblId1.Text == dr["MJobId"].ToString())
                            {
                                CheckBox chk1 = (CheckBox)rw.FindControl("chkitem1");
                                chk1.Checked = true;




                            }
                        }

                    }

                }

            }
        }
    }
}
