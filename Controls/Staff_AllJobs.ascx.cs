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

public partial class controls_Staff_AllJobs : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    private readonly JobMaster job = new JobMaster();
    JobStaffTable jobstaff = new JobStaffTable();
    StaffMaster staff = new StaffMaster();
    DataTable dtjob = new DataTable();
    DataTable dtclient = new DataTable();
    public Boolean BlnApprover = false;
    public string UserType = "";
    public string Staffid = "";


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
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
                else
                {
                    Response.Redirect("~/Default.aspx");
                }

                UserType = Session["usertype"].ToString();
                if (UserType == "staff")
                {
                    Staffid = Session["staffid"].ToString();
                }

                string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
                fromdate.Text = dat;
                txtenddate.Text = dat;
                if (Request.QueryString["nodata"] != null)
                {
                    MessageControl1.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
                }
            }
            bindstaff();
            fromdate.Attributes.Add("onblur", "checkForm();");
            txtenddate.Attributes.Add("onblur", "checkForms();");
        }
    }

    public void bindstaff()
    {
        //string ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' order by StaffName";
        string ss = "";
        if (UserType == "staff")
        {

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
                //ss = "select distinct(StaffCode),StaffName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and  Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'  order by StaffName";
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
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
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

    public void bindjob()
    {
        string ss = "";
        if (UserType == "staff")
        {
            ////ss = "select * from vw_JobnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "'  order by JobName";
            //ss = "select distinct(JobId),JobName from Job_Master where CompId='" + ViewState["compid"].ToString() + "' and JobApprover='" + Staffid + "' and JobStatus='OnGoing'";
            //DataTable App = db.GetDataTable(ss);
            //if (App.Rows.Count != 0)
            //{
            //    BlnApprover = true;
            //}
            //if (BlnApprover == true)
            if (Session["Jr_ApproverId"] == "true")
            {
                Session["StaffType"] = "App";
                //ss = "select distinct(JobId),JobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and  Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'  order by StaffName";
                ss = "SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'" +
                " union" +
                " SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by mJobName";

            }

            else
            {
                //ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by StaffName";
                ss = "select distinct(JobId),JobName from vw_JobnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "'  order by JobName";
            }

        }

        else
        {
            ss = "select distinct(mJobId),mJobName from Jobname_Master where CompId='" + ViewState["compid"].ToString() + "' order by mJobName";
        }

        //string ss = "select j.JobId,j.jobName from Job_Staff_Table as js inner join Job_Master as j on j.JobId=js.JobId where js.StaffCode='" + drpstafflist.SelectedValue + "'";
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
            Label1.Visible = false;
        }
    }


    protected void btngenerate_Click(object sender, EventArgs e)
    {
        try
        {
            
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/AllJobs.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "staff/AllJobs.aspx";
            }
            if (fromdate.Text == "" || txtenddate.Text == "" || drpstafflist.SelectedValue == "0")
            {
                MessageControl1.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
            else
            {
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
                Session["mjobid"] = idjob;
                Session["Stf"]=drpstafflist.SelectedValue;
                string str = "SELECT distinct( dbo.JobName_Master.MJobId), dbo.JobName_Master.MJobName FROM Staff_Master INNER JOIN dbo.Company_Master ON dbo.Staff_Master.CompId = dbo.Company_Master.CompId INNER JOIN dbo.JobName_Master ON dbo.Company_Master.CompId = dbo.JobName_Master.CompId INNER JOIN  dbo.Job_Staff_Table ON dbo.Staff_Master.StaffCode = dbo.Job_Staff_Table.StaffCode AND dbo.JobName_Master.CompId = dbo.Job_Staff_Table.CompId INNER JOIN dbo.TimeSheet_Table ON dbo.Staff_Master.StaffCode = dbo.TimeSheet_Table.StaffCode AND dbo.Job_Staff_Table.JobId = dbo.TimeSheet_Table.JobId  where TimeSheet_Table.Status='Approved' and JobName_Master.mjobId in (" + idjob + ") and TimeSheet_Table.staffCode ='" + drpstafflist.SelectedValue + "' and TimeSheet_Table.Date between '" + ST + "' and '" + Ed + "'";
                DataTable dtavail = db.GetDataTable(str);
                DataList2.DataSource = dtavail;
                DataList2.DataBind();

               
                string startdate = fromdate.Text;
                string enddate = txtenddate.Text;
                string stftype = UserType;
                string sql1 = "";

                UserType = Session["usertype"].ToString();
                if (UserType == "staff")
                {
                     //if (BlnApprover == true)
                    if (Session["Jr_ApproverId"] == "true")
                    {
                        sql1 = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid=" + ViewState["compid"].ToString() + " and t.status='Approved' and t.staffcode in (" + drpstafflist.SelectedValue + ") and j.mJobID in (" + idjob + ")and Date between '" + ST + "' and '" + Ed + "' order by clientname";
                    }
                    else 
                    {
                        sql1 = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId  where t.compid=" + ViewState["compid"].ToString() + " and t.status='Approved' and t.StaffCode in (" + drpstafflist.SelectedValue + ") and j.mJobID in (" + idjob + ")and Date between '" + ST + "' and '" + Ed + "'  order by clientname";
                    }
                }
                else
                {
                    sql1 = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId  where t.compid=" + ViewState["compid"].ToString() + " and t.status='Approved' and t.StaffCode in (" + drpstafflist.SelectedValue + ") and j.mJobID in (" + idjob + ")and Date between '" + ST + "' and '" + Ed + "'  order by clientname";
                }

                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                sqlConn.Open();
                SqlCommand cmd1 = new SqlCommand("delete from Detailed2Loops where Usr='" + Session["StaffType"] + "' and RptName='JobwiseSummary'", sqlConn);
                cmd1.ExecuteNonQuery();
                SqlCommand cmd2 = new SqlCommand("delete from Summary2Loops where Usr='" + Session["StaffType"] + "' and RptName='JobwiseSummary'", sqlConn);
                cmd2.ExecuteNonQuery();
                SqlCommand cmd3 = new SqlCommand("delete from GrandTotal2Loops where Usr='" + Session["StaffType"] + "' and RptName='JobwiseSummary'", sqlConn);
                cmd3.ExecuteNonQuery();
                SqlDataAdapter dscmd = new SqlDataAdapter(sql1, sqlConn);
                DataSet ds = new DataSet();
                dscmd.Fill(ds, "Product");
                if (ds.Tables[0].Rows.Count > 0)
                {
                    Response.Redirect("~/Report_Staff_AllJobs.aspx?staff=" + drpstafflist.SelectedValue + "&comp=" + ViewState["compid"].ToString() + "&pagename=AllJob" + "&pagefolder=Staff", false);

                }
                else
                {
                    bindjob();
                    chkjob.Checked = false;
                    MessageControl1.SetMessage("Timesheets Not Approved", MessageDisplay.DisplayStyles.Error);
                }
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
    protected void drpstafflist_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindjob();
    }
}
