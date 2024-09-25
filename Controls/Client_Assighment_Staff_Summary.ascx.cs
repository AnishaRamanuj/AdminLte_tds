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

public partial class controls_Client_Assighment_Staff_Summary : System.Web.UI.UserControl

{
    public Boolean BlnApprover = false;
    public string UserType = "";
    public string Staffid = "";
    private readonly DBAccess db = new DBAccess();
    CompanyMaster comp = new CompanyMaster();
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
                ViewState["compid"] = Session["companyid"].ToString();
            }
            UserType = Session["usertype"].ToString();
            if (UserType == "staff")
            {
                Staffid = Session["staffid"].ToString();
            }
            bindclient();
            string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            fromdate.Text = dat;
            txtenddate.Text = dat;
        }
      }
    protected void btngenerate_Click(object sender, EventArgs e)
    {
        if (Session["companyid"] != null)
        {
            Session["URL"] = "Company/Staff_AllclientsAlljobs.aspx";
        }
        else if (Session["staffid"] != null)
        {
            Session["URL"] = "staff/Staff_AllclientsAlljobs.aspx";
        }
        int comp = int.Parse(ViewState["compid"].ToString());

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

        string id = "";
        Boolean chkstat = false;
        foreach (DataListItem rw in dlclient.Items)
        {
            Label lblId = (Label)rw.FindControl("Label51");
            decimal wid = decimal.Parse(lblId.Text);
            CheckBox chk = (CheckBox)rw.FindControl("chkitem2");

            if (chk.Checked == true)
            {
                if (chkstat == false)
                {
                    id += wid + ",";
                    chkstat = true;
                }
                else
                {
                    id += wid + ",";
                }
            }
            

       
        }
        if (id != "")
        {
            id = id.Remove(id.Length - 1, 1);
        }
        Session["cltid"] = id;
        string jobid = "";
        string idj = "";
        string sql2 = "SELECT  distinct(j.mJobID) FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.CompId='" + comp + "' and t.cltid in (" + Session["cltid"] + ") and t.status= 'Approved' and t.Date between '" + ST + "' and '" + Ed + "'";
        //string sql2 = "SELECT distinct(j.mJobID) FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.cltid in (" + Session["cltid"] + ") and Date between '" + ST + "' and '" + Ed + "'  order by mjobid";
        DataTable dt = db.GetDataTable(sql2);
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                idj = dr["mJobID"].ToString();               
                jobid += idj + ",";
            }
        }
        if (jobid != "")
        {
            jobid = jobid.Remove(jobid.Length - 1, 1);
        }
        else
        {
            MessageControl2.SetMessage("Timesheets Not Approved", MessageDisplay.DisplayStyles.Error);
            return ;
        }
        Session["jobid"] = jobid;
        string stfid = "";
        string ids = "";
        string sql1 = "SELECT  distinct(t.StaffCode) FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.CompId='" + comp + "' and t.cltid in (" + Session["cltid"] + ") and j.mJobID in (" + Session["jobid"] + ") and t.status= 'Approved' and t.Date between '" + ST + "' and '" + Ed + "' order by t.staffcode";
        //string sql1 = "SELECT distinct(t.StaffCode) FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.cltid in (" + Session["cltid"] + ") and j.mJobID in (" + Session["jobid"] + ") and Date between '" + ST + "' and '" + Ed + "'  order by Staffcode";
        DataTable dt1 = db.GetDataTable(sql1);
        if (dt1.Rows.Count > 0)
        {
            foreach (DataRow dr in dt1.Rows)
            {
                ids = dr["StaffCode"].ToString();
                stfid += ids + ",";
            }
        }
        if (stfid != "")
        {
            stfid = stfid.Remove(stfid.Length - 1, 1);
        }
        Session["stfid"] = stfid;
        string sql = "";
                UserType = Session["usertype"].ToString();
                if (UserType == "staff")
                {
                    if (Session["Jr_ApproverId"].ToString() == "true")
                    {
                        sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.cltid in (" + Session["cltid"] + ") and j.mJobID in (" + Session["jobid"] + ")and t.Staffcode in (" + Session["stfid"] + ") and Date between '" + ST + "' and '" + Ed + "' order by clientname";
                        Session["StaffType"] = Session["staffid"].ToString();
                    }
                    else
                    {
                        sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.cltid in (" + Session["cltid"] + ") and j.mJobID in (" + Session["jobid"] + ") and t.Staffcode in (" + Session["stfid"] + ") and Date between '" + ST + "' and '" + Ed + "'  order by clientname";
                        Session["StaffType"] = Session["staffid"].ToString();
                    }
                }
                else
                {
                    sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.cltid in (" + Session["cltid"] + ") and j.mJobID in (" + Session["jobid"] + ")and t.Staffcode in (" + Session["stfid"] + ") and Date between '" + ST + "' and '" + Ed + "'  order by clientname";
                    Session["StaffType"] = "Adm";
                }                

               
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                sqlConn.Open();
                SqlCommand cmd1 = new SqlCommand("delete from Detailed2Loops where Usr='" + Session["StaffType"] + "' and compid='" + comp + "'", sqlConn);
                cmd1.ExecuteNonQuery();
                SqlCommand cmd2 = new SqlCommand("delete from Summary2Loops where Usr='" + Session["StaffType"] + "' and compid='" + comp + "'", sqlConn);
                cmd2.ExecuteNonQuery();
                SqlCommand cmd3 = new SqlCommand("delete from GrandTotal2Loops where Usr='" + Session["StaffType"] + "' and compid='" + comp + "'", sqlConn);
                cmd3.ExecuteNonQuery();

                Session["clientid"] = id;
                SqlDataAdapter dscmd = new SqlDataAdapter(sql, sqlConn);
                DataSet ds = new DataSet();
                dscmd.Fill(ds, "Product");
                if (ds.Tables[0].Rows.Count > 0)
                {
                    Response.Redirect("~/Report_Client_Assighment_Staff_Summary.aspx?comp=" + comp + "&pagename=Client_Assignment" + "&pagefolder=Staff", false);
                }
                else
                {
                    MessageControl2.SetMessage("Timesheets Not Approved", MessageDisplay.DisplayStyles.Error);
                }
          
    }
    public void bindclient()
    {
        try
        {
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
                    //ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClinetnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'  order by ClientName";
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

            //string ss = "select * from Client_Master where CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
            DataTable dt = db.GetDataTable(ss);
            if (dt.Rows.Count != 0)
            {
                //dlclient.Items.Clear();
                dlclient.DataSource = dt;
                dlclient.DataBind();
                //drpclient.Items.Remove("--None--");
            }
            else
            {
                //dlclient.Items.Clear();
                //dlclient.Items.Insert(0, "--None--");
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void chkclient_CheckedChanged(object sender, EventArgs e)
    {
        if (chkclient.Checked == true)
        {
            foreach (DataListItem rw in dlclient.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem2");
                chk.Checked = true;
            }
        }
        else if (chkclient.Checked == false)
        {
            foreach (DataListItem rw in dlclient.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem2");
                chk.Checked = false;
            }
        }
    }
}
