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

public partial class controls_AllJobAllCategory : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    DataTable dt_allJob = new DataTable();
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
               ViewState["compid"] =  Session["cltcomp"].ToString();
            }

            if (ViewState["compid"] != null)
            {
                UserType = Session["usertype"].ToString();
                if (UserType == "staff")
                {
                    Staffid = Session["staffid"].ToString();
                }
                string ss = "";
                if (UserType == "staff")
                {
                    ////ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClinetnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by ClientName";
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
                        //ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by ClientName";
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

                //string qry = string.Format("select * from dbo.Client_Master where CompId='" +ViewState["compid"].ToString() + "' order by ClientName");
                DataTable dt_clt = db.GetDataTable(ss);
                drpClient.DataSource = dt_clt;
                drpClient.DataBind();
                drpClient.Items.Insert(0, "--Select--");
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            //UserType = Session["usertype"].ToString();
            //if (UserType == "staff")
            //{
            //    Staffid = Session["staffid"].ToString();
            //}
            //string ss = "";
            //if (UserType == "staff")
            //{
            //    ////ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClinetnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by ClientName";
            //    //ss = "select * from Job_Master where CompId='" + ViewState["compid"].ToString() + "' and JobApprover='" + Staffid + "' and JobStatus='OnGoing'";
            //    //DataTable App = db.GetDataTable(ss);
            //    //if (App.Rows.Count != 0)
            //    //{
            //    //    BlnApprover = true;
            //    //}
            //    //if (BlnApprover == true)
            //    if (Session["Jr_ApproverId"] == "true")
            //    {
            //        Session["StaffType"] = "App";
            //        //ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by ClientName";
            //       ss = "select distinct(Cltid),ClientName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' " +
            //            " union" +
            //            " SELECT distinct(Cltid),ClientName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by ClientName";
            //    }

            //    else
            //    {
            //        ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClinetnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by ClientName";
            //    }
            //}
            //else
            //{
            //    ss = "select * from Client_Master  where CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
            //}

            ////string qry = string.Format("select * from dbo.Client_Master where CompId='" +ViewState["compid"].ToString() + "' order by ClientName");
            //DataTable dt_clt = db.GetDataTable(ss);
            //drpClient.DataSource = dt_clt;
            //drpClient.DataBind();
            //drpClient.Items.Insert(0, "--Select--");
        }

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
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/AllJobAllCategory.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "staff/AllJobAllCategory.aspx";
            }
            if (drpClient.SelectedValue != "--Select--")
            {

                int comp = int.Parse(ViewState["compid"].ToString());
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
                string str = "select distinct jm.mJobId,jm.mJobName " +
                             " FROM dbo.JobName_Master AS jm INNER JOIN  dbo.Job_Master AS jg ON jm.MJobId = jg.MJobid RIGHT OUTER JOIN " +
                             " dbo.Job_Staff_Table AS j LEFT OUTER JOIN  dbo.Staff_Master AS s ON j.StaffCode = s.StaffCode ON jg.JobId = j.JobId LEFT OUTER JOIN " +
                             " dbo.Designation_Master AS d ON s.DsgId = d.DsgId where jm.MJobId in (" + idstf + ")";

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
                    //CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                    //if (chk.Checked == true)
                    //{
                    stf = Cid;
                    if (dt_allJob == null || dt_allJob.Rows.Count == 0)
                    {
                        dt_allJob.Columns.Add("mJobId", System.Type.GetType("System.String"));
                        dt_allJob.Columns.Add("mJobName", System.Type.GetType("System.String"));
                        DataRow dr = dt_allJob.NewRow();
                        dr["mJobId"] = Cid;
                        dr["mJobName"] = staff;
                        dt_allJob.Rows.Add(dr);
                        dt_allJob.AcceptChanges();
                    }
                    else
                    {
                        DataRow dr = dt_allJob.NewRow();
                        dr["mJobId"] = Cid;
                        dr["mJobName"] = staff;
                        dt_allJob.Rows.Add(dr);
                        dt_allJob.AcceptChanges();
                    }
                    //}
                }

                Session["dt_allJob"] = dt_allJob;
                Session["JobId"] = idstf;
                jobs();
                Session["startdate"] = null;
                Session["enddate"] = null;
                if (dt_allJob.Rows.Count > 0 && ViewState["compid"].ToString() != "")
                {
                    Response.Redirect("~/Report_AllJobAllCategory.aspx?comp=" + comp + "&clnt=" + drpClient.SelectedValue + "&pagename=AllJobAllCategory" + "&pagefolder=Client", false);
                }
                else
                {
                    MessageControl1.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                MessageControl1.SetMessage("Mandatory Fields must be filled.", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void drpClient_SelectedIndexChanged(object sender, EventArgs e)
    {
        jobs();
    }
    public void jobs()
    {
        if (drpClient.SelectedIndex != 0)
        {
            string cltid=drpClient.SelectedValue ; 
            string ss = "";
            if (UserType == "staff")
            {
                ////ss = "select * from vw_JobnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "'  order by JobName";
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
                    //ss = string.Format("select distinct(mJobId),mJobName from vw_Job_AllClientAllStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' and CLTId='" + cltid + "' order by mJobName", drpClient.SelectedValue);
                    ss = "SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'  and CLTId='" + cltid + "'" +
                        " union" +
                        " SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "'))  and CLTId='" + cltid + "' order by mJobName";

                }

                else
                {
                    //ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by StaffName";
                    ss = string.Format("select distinct(mJobId),mJobName from vw_Job_AllClientAllStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' and CLTId='" + cltid + "' order by mJobName", drpClient.SelectedValue);
                }

            }

            else
            {
                ss = "select distinct(mJobId),mJobName from vw_Job_AllClientAllStaff_new where CompId='" + ViewState["compid"].ToString() + "' and CLTId='" + cltid + "' order by mJobName";
            }

            //string qry = string.Format("select * from dbo.Job_Master where CLTId='{0}' order by JobName", drpClient.SelectedValue);
            DataTable dt_job = db.GetDataTable(ss);
            dljoblist.DataSource = dt_job;
            dljoblist.DataBind();
        }

    }
}
