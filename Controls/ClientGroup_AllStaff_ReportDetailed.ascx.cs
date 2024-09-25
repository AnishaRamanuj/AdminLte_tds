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

public partial class controls_ClientGroup_AllStaff_ReportDetailed : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    DataTable dt_portStaff = new DataTable();
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;
     string stf = "";
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
                }
                string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
                txtstartdate1.Text = dat;
                txtenddate2.Text = dat;


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
                        //ss = "select DISTINCT ClientGroupName,CTGId FROM vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by ClientGroupName";
                        ss = "select distinct(CTGId),ClientGroupName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' " +
                       " union" +
                        " SELECT distinct(CTGId),ClientGroupName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by ClientName";
                    }

                    else
                    {
                        ss = "select DISTINCT ClientGroupName,CTGId FROM vw_JobnClientnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by ClientGroupName";
                    }
                }
                else
                {
                    string query = string.Format("select * from dbo.ClientGroup_Master where CompId='{0}' order by ClientGroupName", ViewState["compid"].ToString());
                    ss = query;
                }

                //string query = string.Format("select * from dbo.ClientGroup_Master where CompId='{0}' order by ClientGroupName", ViewState["compid"].ToString());
                DataTable dt_group = db.GetDataTable(ss);
                if (dt_group.Rows.Count > 0)
                {
                    DropClientGroup.DataSource = dt_group;
                    DropClientGroup.DataBind();
                    DropClientGroup.Items.Insert(0, "--Select--");
                    clientlist.DataSource = dt_group;
                    clientlist.DataBind();
                }
                else
                {
                    DropClientGroup.Items.Insert(0, "--None--");
                }
                if (Request.QueryString["nodata"] != null)
                {
                    MessageControl1.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
                }
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
            //string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            //txtstartdate1.Text = dat;
            //txtenddate2.Text = dat;


            //string ss = "";
            //if (UserType == "staff")
            //{
            //    //ss = "select * from Job_Master where CompId='" + ViewState["compid"].ToString() + "' and JobApprover='" + Staffid + "' and JobStatus='OnGoing'";
            //    //DataTable App = db.GetDataTable(ss);
            //    //if (App.Rows.Count != 0)
            //    //{
            //    //    BlnApprover = true;
            //    //}
            //    //if (BlnApprover == true)
            //    if (Session["Jr_ApproverId"] == "true")
            //    {
            //        //ss = "select DISTINCT ClientGroupName,CTGId FROM vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by ClientGroupName";
            //        ss = "select distinct(CTGId),ClientGroupName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' " +
            //       " union" +
            //        " SELECT distinct(CTGId),ClientGroupName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by ClientName";
            //    }

            //    else
            //    {
            //        ss = "select DISTINCT ClientGroupName,CTGId FROM vw_JobnClientnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by ClientGroupName";
            //    }
            //}
            //else
            //{
            //    string query = string.Format("select * from dbo.ClientGroup_Master where CompId='{0}' order by ClientGroupName", ViewState["compid"].ToString());
            //    ss = query;
            //}

            ////string query = string.Format("select * from dbo.ClientGroup_Master where CompId='{0}' order by ClientGroupName", ViewState["compid"].ToString());
            //DataTable dt_group = db.GetDataTable(ss);
            //if (dt_group.Rows.Count > 0)
            //{
            //    DropClientGroup.DataSource = dt_group;
            //    DropClientGroup.DataBind();
            //    DropClientGroup.Items.Insert(0, "--Select--");
            //    clientlist.DataSource = dt_group;
            //    clientlist.DataBind();
            //}
            //else
            //{
            //    DropClientGroup.Items.Insert(0, "--None--");
            //}
            //if (Request.QueryString["nodata"] != null)
            //{
            //    MessageControl1.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
            //}
        }

    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        //try
        {
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/ClientGroup_AllStaff.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "staff/ClientGroup_AllStaff.aspx";
            }
            if (DropClientGroup.SelectedIndex == 0)
            {
                int comp = int.Parse(ViewState["compid"].ToString());

                /////////////////////////////////////////////////////////////////////////////////////////////////////////////

                string id = "";
                CultureInfo info = new CultureInfo("en-US", false);
                DateTime Fdob = new DateTime(1900, 1, 1);
                DateTime dob = new DateTime(1900, 1, 1);
                String _dateFormat = "dd/MM/yyyy";
                if (txtstartdate1.Text.Trim() != "" && !DateTime.TryParseExact(txtstartdate1.Text.Trim(), _dateFormat, info,
                                                                                                     DateTimeStyles.AllowWhiteSpaces, out Fdob))
                {
                }
                if (txtenddate2.Text.Trim() != "" && !DateTime.TryParseExact(txtenddate2.Text.Trim(), _dateFormat, info,
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




                foreach (DataListItem rw in clientlist.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    decimal wid = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem1");


                    if (chk.Checked == true)
                    {
                        stf += "" + wid + "" + ",";
                    }
                }

                if (stf != "")
                {
                    stf = stf.Remove(stf.Length - 1, 1);
                }
                Session["cltid"] = stf;
                string jobid = "";
                string idj = "";
                string sql2 = "SELECT  distinct(j.mJobID) FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.CompId=' + comp + ' and c.CTGId in (" + Session["cltid"] + ") and t.status= 'Approved' and t.Date between '" + ST + "' and '" + Ed + "' order by mjobid";
                //string sql2 = "SELECT  distinct(j.mJobID) FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN  dbo.Client_Master AS c ON t.CLTId = c.CLTId INNER JOIN dbo.ClientGroup_Master cg ON c.CTGId =cg.CTGId where t.CompId='" + comp + "' and t.status='Approved' and cg.CTGId  in(" + Session["cltid"] + ") and Date between '" + ST + "' and '" + Ed + "'and JobApprover='" + Session["IsApprover"].ToString() + "' order by clientgroupname";
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
                Session["jobid"] = jobid;
                string stfid = "";
                string ids = "";

                string sql1 = "SELECT  distinct(t.StaffCode) FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.CompId=' + comp + ' and c.CTGId in (" + Session["cltid"] + ") and j.mJobID in (" + Session["jobid"] + ") and t.status= 'Approved' and t.Date between '" + ST + "' and '" + Ed + "' order by t.staffcode";

                DataTable dt1 = db.GetDataTable(sql1);
                if (dt1.Rows.Count > 0 )
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
                int comp1 = int.Parse(ViewState["compid"].ToString());
                UserType = Session["usertype"].ToString();
                if (UserType == "staff")
                {
                    //if (BlnApprover == true)
                    if (Session["Jr_ApproverId"] == "true")
                    {
                        sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp1 + "' and c.CTGId in (" + Session["cltid"] + ") and j.mJobID in (" + Session["jobid"] + ")and t.Staffcode in (" + Session["stfid"] + ") and Date between '" + ST +"' and '" + Ed + "' order by clientname";
                        Session["StaffType"] = Session["staffid"].ToString();
                    }
                    else
                    {
                        sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp1 + "' and c.CTGId in (" + Session["cltid"] + ") and j.mJobID in (" + Session["jobid"] + ") and t.Staffcode in (" + Session["stfid"] + ") and Date between '" + ST + "' and '" + Ed + "'  order by clientname";
                        Session["StaffType"] = Session["staffid"].ToString();
                    }
                }
                else
                {
                    sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp1 + "' and c.CTGId in (" + Session["cltid"] + ") and j.mJobID in (" + Session["jobid"] + ")and t.Staffcode in (" + Session["stfid"] + ") and Date between '" + ST + "' and '" + Ed + "'  order by clientname";
                    Session["StaffType"] = "Adm";
                }


                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                sqlConn.Open();
                SqlCommand cmd1 = new SqlCommand("delete from Detailed2Loops where Usr='" + Session["StaffType"] + "' and RptName='Client Group Report Detailed' and compid='" + comp1 + "'", sqlConn);
                cmd1.ExecuteNonQuery();
                SqlCommand cmd2 = new SqlCommand("delete from Summary2Loops where Usr='" + Session["StaffType"] + "' and RptName='Client Group Report Detailed' and compid='" + comp1 + "'", sqlConn);
                cmd2.ExecuteNonQuery();
                SqlCommand cmd3 = new SqlCommand("delete from GrandTotal2Loops where Usr='" + Session["StaffType"] + "' and RptName='Client Group Report Detailed' and compid='" + comp1 + "'", sqlConn);
                cmd3.ExecuteNonQuery();


                SqlDataAdapter dscmd = new SqlDataAdapter(sql, sqlConn);
                DataSet ds = new DataSet();
                dscmd.Fill(ds, "Product");
                if (ds.Tables[0].Rows.Count > 0)
                {

                    Response.Redirect("~/Single_All_ClientGroup_Report_Detailed.aspx?comp=" + comp1 + "&Clientgroup=" + stf + "&pagename=ClientGroup_Detailed" + "&pagefolder=Client", false);

                }
                else
                {
                    MessageControl1.SetMessage("Timesheets Not Approved", MessageDisplay.DisplayStyles.Error);
                }


            }
        }
    }
         
       

    protected void chkjob1_CheckedChanged(object sender, EventArgs e)
    {
        if (chkjob1.Checked == true)
        {
            foreach (DataListItem rw in clientlist.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (chkjob1.Checked == false)
        {
            foreach (DataListItem rw in clientlist.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }
    public void cliets()
    {
        string ss = "";
        string dd = "";
        dd = DropClientGroup.SelectedValue;
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
                //ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' and CTGId='" + dd + "' order by ClientName";
                ss = "select distinct(Cltid),ClientName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' " +
               " union" +
                " SELECT distinct(Cltid),ClientName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by ClientName";

            }

            else
            {
                ss = ("select DISTINCT ClientName,CLTid FROM vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' and CTGId='" + dd + "' order by ClientName");
            }
        }
        else
        {
            ss = string.Format("select * from dbo.Client_Master where CTGId='{0}'", DropClientGroup.SelectedValue);
        }
        //string query = string.Format("select * from dbo.Client_Master where CTGId='{0}'", DropClientGroup.SelectedValue);
        DataTable dt_clients = db.GetDataTable(ss);
        if (dt_clients.Rows.Count > 0)
        {
            clientlist.DataSource = dt_clients;
            clientlist.DataBind();

        }
    }
    protected void DropClientGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        cliets();
    }
}
