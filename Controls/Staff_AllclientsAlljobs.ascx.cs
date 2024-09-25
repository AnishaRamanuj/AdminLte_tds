using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
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

public partial class controls_Staff_AllclientsAlljobs : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    private readonly JobMaster job = new JobMaster();
    JobStaffTable jobstaff = new JobStaffTable();
    StaffMaster staff = new StaffMaster();
    DataTable dtjob = new DataTable();
    DataTable dtclient = new DataTable();
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;
    public string JobID = "";
    public string Clientid = "";
    public string widd1 = "";


    protected void Page_Load(object sender, EventArgs e)
    {
        //if ( ViewState["compid"] != null)
        //{
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

            bindstaff();
            bindjob();
            bindclient();
            string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            fromdate.Text = dat;
            txtenddate.Text = dat;
            if (Request.QueryString["nodata"] != null)
            {
                MessageControl1.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
            }
        }
        fromdate.Attributes.Add("onblur", "checkForm();");

        txtenddate.Attributes.Add("onblur", "checkForms();");
    }
    public void bindjob()
    {
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
                //ss = "select distinct(mJobId),mJobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and  Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by mJobName";
                ss = "SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'" +
                " union" +
                " SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by mJobName";

            }

            else
            {
                //ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by StaffName";
                ss = "select distinct(mJobId),mJobName from job_master_new where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "'  order by mJobName";
            }

        }

        else
        {
            ss = "select distinct(mJobId),mJobName from job_master_new where CompId='" + ViewState["compid"].ToString() + "' order by mJobName";
        }

        //string ss = "select * from Job_Master where CompId='" +  ViewState["compid"].ToString() + "' order by JobName";
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
                //ss = "select distinct(StaffCode),StaffName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by StaffName";
                ss = "SELECT distinct(StaffCode), StaffName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and (Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "')" +
                        " union" +
                        " SELECT distinct(StaffCode), StaffName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by StaffName";
            }

            else
            {
                ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by StaffName";
            }
        }

        else
        {
            ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' order by StaffName";
        }


        //string ss = "select * from Staff_Master where CompId='" +  ViewState["compid"].ToString() + "' order by StaffName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            DTStaffLST.DataSource = dt;
            DTStaffLST.DataBind();
            //Label1.Visible = false;
        }
        else
        {
            DTStaffLST.DataSource = null;
            DTStaffLST.DataBind();
            //Label1.Visible = true;
        }
    }
    public void bindclient()
    {
        string ss="";
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


        //string ss = "select * from Client_Master  where CompId='" +  ViewState["compid"].ToString() + "' order by ClientName";
        DataTable dt1 = db.GetDataTable(ss);
        if (dt1.Rows.Count != 0)
        {
            //dlclientlist.Items.Clear();
            dlclientlist.DataSource = dt1;
            dlclientlist.DataBind();
            //drpclient.Items.Remove("--None--");
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
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/Staff_AllclientsAlljobs.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "Staff/Staff_AllclientsAlljobs.aspx";
            }
            
           

           if (txtenddate.Text != "" && fromdate.Text != "")
            {

                string id = "";
                foreach (DataListItem rw in dlclientlist.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    decimal wid = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        //id += "'" + wid + "'" + ",";
                        id += wid + ",";
                    }

                }
                if (id != "")
                {
                    id = id.Remove(id.Length - 1, 1);
                }

                Session["clientid"] = id;
                string idjob = "";
                foreach (DataListItem rw in DataList2.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                    if (chk.Checked == true)
                    {
                        //idjob += "'" + widd + "'" + ",";
                        idjob += widd + ",";
                    }

                }
                if (idjob != "")
                {
                    idjob = idjob.Remove(idjob.Length - 1, 1);
                }

                Session["jobid"] = idjob;

                string idstf = "";
                foreach (DataListItem rw in DTStaffLST.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                    if (chk.Checked == true)
                    {
                       // idstf += "'" + widd + "'" + ",";
                        idstf += widd + ",";
                    }

                }
                if (idstf != "")
                {
                    idstf = idstf.Remove(idstf.Length - 1, 1);
                }
                Session["idstfs"] = idstf;

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
                DateTime EDT = dob;
                DateTime FDT = Fdob;

                string ST = "";
                string Ed = "";
                ST = String.Format("{0:MM/dd/yyyy}", Fdob);
                Ed = String.Format("{0:MM/dd/yyyy}", dob);
                Session["startdate"] = FDT;
                Session["enddate"] = EDT;
                string sql = "";
                
                int comp = int.Parse(ViewState["compid"].ToString());
                UserType = Session["usertype"].ToString();
                if (UserType == "staff")
                {
                    if (Session["Jr_ApproverId"] == "true")
                    {
                        sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.CompId='" + comp + "' and t.status='Approved' and t.Staffcode in (" + idstf + ") and t.CltId in (" + id + ") and t.Date between '" + ST + "' and '" + Ed + "' order by t.Date";
                        Session["StaffType"] = Session["staffid"].ToString();
                    }
                    else
                    {

                        sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.CompId='" + comp + "' and t.status='Approved' and t.Staffcode in (" + idstf + ") and t.CltId in (" + id + ") and t.Date between '" + ST + "' and '" + Ed + "' order by t.Date";
                        Session["StaffType"] = Session["staffid"].ToString();
                    }
                }
                else
                {
                    sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.CompId='" + comp + "' and t.status='Approved' and t.Staffcode in (" + idstf + ") and t.CltId in (" + id + ") and t.Date between '" + ST + "' and '" + Ed + "' order by t.Date";
                    Session["StaffType"] = "Adm";
                }
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                sqlConn.Open();
                SqlCommand cmd1 = new SqlCommand("delete from Detailed2Loops where Usr='" + Session["StaffType"] + "' and RptName='Staff_AllClientAllJobs'", sqlConn);
                cmd1.ExecuteNonQuery();
                SqlCommand cmd2 = new SqlCommand("delete from Summary2Loops where Usr='" + Session["StaffType"] + "' and RptName='Staff_AllClientAllJobs'", sqlConn);
                cmd2.ExecuteNonQuery();
                SqlCommand cmd3 = new SqlCommand("delete from GrandTotal2Loops where Usr='" + Session["StaffType"] + "' and RptName='Staff_AllClientAllJobs'", sqlConn);
                cmd3.ExecuteNonQuery();

                DataTable dt = db.GetDataTable(sql);
                if (dt.Rows.Count > 0)
                {
                    Response.Redirect("~/Report_Staff_AllclientsAlljobs.aspx?&comp=" + ViewState["compid"].ToString() + "&pagename=AllClientAllJob" + "&pagefolder=Staff", false);
                }
                else
                {
                    //chkclient.Checked = false;
                    //chkjob.Checked = false;
                    ////drpcompanylist_SelectedIndexChanged(sender, e);
                    //bindjob();
                    //bindclient();
                    MessageControl1.SetMessage("Timesheet Not Submited.", MessageDisplay.DisplayStyles.Error);
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
            foreach (DataListItem rw in DataList2.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
            foreach (DataListItem rw in DTStaffLST.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
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
            foreach (DataListItem rw in DataList2.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
            foreach (DataListItem rw in DTStaffLST.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }

    protected void chkitem_CheckedChanged(object sender, EventArgs e)
    {
        //Client

        foreach (DataListItem dl1 in dlclientlist.Items)
        {
            Label lblId = (Label)dl1.FindControl("Label51");
            string widd = lblId.Text;
            CheckBox chk = (CheckBox)dl1.FindControl("chkitem");
            if (chk.Checked == true)
            {
                Clientid = widd;
                widd1 = widd;
                string ss = "SELECT DISTINCT (dbo.JobName_Master.MJobId), JobName_Master.MJobName FROM dbo.Job_Staff_Table INNER JOIN Staff_Master ON dbo.Job_Staff_Table.StaffCode = dbo.Staff_Master.StaffCode INNER JOIN Job_Master ON dbo.Job_Staff_Table.JobId = dbo.Job_Master.JobId INNER JOIN JobName_Master ON dbo.Job_Master.MJobid = dbo.JobName_Master.MJobId INNER JOIN Client_Master ON dbo.Job_Master.CLTId = dbo.Client_Master.CLTId  WHERE dbo.Client_Master.CLTId='" + widd + "' order by jobname_master.mJobname asc";
                DataTable dt = db.GetDataTable(ss);
                if (dt.Rows.Count > 0)
                {

                    foreach (DataRow dr in dt.Rows)
                    {
                        JobID = dr["MJObId"].ToString();
                        foreach (DataListItem rw in DataList2.Items)
                        {
                            Label lblId1 = (Label)rw.FindControl("Label51");
                            if (lblId1.Text == dr["MJObId"].ToString())
                            {
                                CheckBox chk1 = (CheckBox)rw.FindControl("chkitem1");
                                chk1.Checked = true;

                                string ss1 = "SELECT DISTINCT (dbo.Staff_Master.StaffCode), dbo.JobName_Master.MJobId,Staff_Master.StaffName FROM dbo.Job_Staff_Table INNER JOIN dbo.Staff_Master ON dbo.Job_Staff_Table.StaffCode = dbo.Staff_Master.StaffCode INNER JOIN dbo.Job_Master ON dbo.Job_Staff_Table.JobId = dbo.Job_Master.JobId INNER JOIN dbo.JobName_Master ON dbo.Job_Master.MJobid = dbo.JobName_Master.MJobId INNER JOIN dbo.Client_Master ON dbo.Job_Master.CLTId = dbo.Client_Master.CLTId WHERE (dbo.Client_Master.CLTId = '" + widd + "') and dbo.JobName_Master.MJobId ='" + JobID + "' ORDER BY Staff_Master.StaffName asc";
                                DataTable dt1 = db.GetDataTable(ss1);
                                if (dt1.Rows.Count > 0)
                                {
                                    foreach (DataRow dr1 in dt1.Rows)
                                    {
                                        Staffid = dr1["StaffCode"].ToString();
                                        foreach (DataListItem rw1 in DTStaffLST.Items)
                                        {
                                            Label lblId2 = (Label)rw1.FindControl("Label51");
                                            if (lblId2.Text == dr1["StaffCode"].ToString())
                                            {
                                                CheckBox chk2 = (CheckBox)rw1.FindControl("chkitem1");
                                                chk2.Checked = true;
                                            }
                                        }
                                    }
                                }


                            }
                        }

                    }

                }

            }
        }
    }
    protected void chkitem1_CheckedChanged(object sender, EventArgs e)
    {
        //Job
    }
    protected void ChkST_CheckedChanged(object sender, EventArgs e)
    {
        if (ChkST.Checked == true)
        {
            foreach (DataListItem rw in DTStaffLST.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (ChkST.Checked == false)
        {
            foreach (DataListItem rw in DTStaffLST.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }
}
