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

public partial class controls_Client_SingleJobGroupAllJobs : System.Web.UI.UserControl
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
            UserType = Session["usertype"].ToString();
            if (UserType == "staff")
            {
                Staffid = Session["staffid"].ToString();
            }

            // bindcomp();
            bindclient();
            //bindjobgroup();
            //bindstaff();
            //bindjob();
            //Label7.Visible = true;
            //Label8.Visible = true;
            if (Request.QueryString["nodata"] != null)
            {
                MessageControl2.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
            }
        }

        //fromdate.Attributes.Add("readonly", "readonly");
        //txtenddate.Attributes.Add("readonly", "readonly");
    }

    public void bindjobgroup()
    {
        string cltid = "";
        cltid = drpclient.SelectedValue;  

        string ss = "";
        if (UserType == "staff")
        {
            //ss = "select * from Job_Master where CompId='" + ViewState["compid"].ToString() + "' and JobApprover='" + Staffid + "' and JobStatus='OnGoing'";
            //DataTable App = db.GetDataTable(ss);
            //if (App.Rows.Count != 0)
            //{
            //    BlnApprover = true;
            //}
            //if (BlnApprover == true)
            if (Session["Jr_ApproverId"] == "true")
            {
                Session["StaffType"] = "App";
                //ss = "select distinct(JobGId),JobGroupName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' and CLTId='" + cltid + "'  order by JobGroupName";
                ss = "select distinct(JobGId),JobGroupName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' " +
                " union" +
                " SELECT distinct(JobGId),JobGroupName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by JobGroupName";

            }
            else
            {
                ss = "select distinct(JobGId),JobGroupName from vw_JobGroupnAllJobs where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "'  and CLTId='" + cltid + "'  order by JobGroupName";
            }

        }

        else
        {
            ss = "select distinct(JobGId),JobGroupName from vw_JobGroupnAllJobs where CompId='" + ViewState["compid"].ToString() + "'  and CLTId='" + cltid + "' order by JobGroupName";
        }

        //string ss = "select * from JobGroup_Master where CompId='" + ViewState["compid"].ToString() + "'";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            DataList7.DataSource = dt;
            DataList7.DataBind();
            Label78.Visible = false;
            //drpclient.Items.Remove("--None--");
        }
        else
        {
            DataList7.DataSource = null;
            Label78.Visible = false;
        }
    }
    protected void chkjobgrp_CheckedChanged(object sender, EventArgs e)
    {
        if (chkjobgrp.Checked == true)
        {
            foreach (DataListItem rw in DataList7.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (chkjobgrp.Checked == false)
        {
            foreach (DataListItem rw in DataList7.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
        }
    }
    protected void btngenerate_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/Client_SingleJobGroupAllJobs.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "staff/Client_SingleJobGroupAllJobs.aspx";
            }
            int clnt = int.Parse(drpclient.SelectedValue);
            int comp = int.Parse(ViewState["compid"].ToString());
            //string startdate = fromdate.Text;
            //string enddate = txtenddate.Text;
            //Session["startdate"] = startdate;
            //Session["enddate"] = enddate;
            string idstf = "";
            foreach (DataListItem rw in DataList7.Items)
            {
                Label lblId = (Label)rw.FindControl("Label51");
                if (lblId.Text != null)
                {
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        idstf += widd + ",";
                    }
                }
            }
            if (idstf != "")
            {
                idstf = idstf.Remove(idstf.Length - 1, 1);
            }
              
                Session["dtjobgrp"] = idstf;

                Response.Redirect("~/Report_Client_SingleJobGroupAllJobs.aspx?comp=" + comp + "&clnt=" + clnt + "&pagename=JobGroup" + "&pagefolder=Client", false);

        }
        catch (Exception ex)
        {

        }
    }
    public void bindclient()
    {
        string ss = "";
        if (UserType == "staff")
        {
        //    //ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClinetnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by ClientName";
        //    ss = "select * from Job_Master where CompId='" + ViewState["compid"].ToString() + "' and JobApprover='" + Staffid + "' and JobStatus='OnGoing'";
        //    DataTable App = db.GetDataTable(ss);
        //    if (App.Rows.Count != 0)
        //    {
        //        BlnApprover = true;
        //    }
        //    if (BlnApprover == true)
          if (Session["Jr_ApproverId"] == "true")
          {
              Session["StaffType"] = "App";
                 //ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'  order by ClientName";
                ss = "select distinct(Cltid),ClientName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' " +
                " union" +
                " SELECT distinct(Cltid),ClientName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by ClientName";
            }

            else
            {
                ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClinetnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by ClientName";
            }
        }
        else
        {
            ss = "select * from Client_Master  where CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
        }
        //string ss = "select * from Client_Master where CompId='" + ViewState["compid"].ToString() + "'";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            drpclient.Items.Clear();
            drpclient.DataSource = dt;
            drpclient.DataBind();
            //drpclient.Items.Remove("--None--");
        }
        else
        {
            drpclient.Items.Clear();
            drpclient.Items.Insert(0, "--None--");
        }
    }
    protected void drpclient_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindjobgroup();
    }
}
