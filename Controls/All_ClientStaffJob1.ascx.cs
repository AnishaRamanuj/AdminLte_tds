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

public partial class controls_All_ClientStaffJob1 : System.Web.UI.UserControl
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
    DataTable dt_st = new DataTable();
    DataTable dtclient = new DataTable();
    public string UserType = "";
    public string Staffid = "";
    public string ClientID = "";
    public Boolean BlnApprover = false;
    public Boolean chkid = false;
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
                txtfrom.Text = dat;
                txtto.Text = dat;
                if (Request.QueryString["nodata"] != null)
                {
                    MessageControl2.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
           


            //bind();
            //job_new();
            //string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            //txtfrom.Text = dat;
            //txtto.Text = dat;
          
        }

        //txtfrom.Attributes.Add("readonly", "readonly");
        //txtto.Attributes.Add("readonly", "readonly");
        txtfrom.Attributes.Add("onblur", "checkForm();");

        txtto.Attributes.Add("onblur", "checkForms();");
    }
    public void job_new()
    {

        string ss = "";
        if (UserType == "staff")
        {

            //ss = "select * from Job_Master_new where CompId='" + ViewState["compid"].ToString() + "' and JobApprover='" + Staffid + "' and JobStatus='OnGoing'";
            //DataTable App = db.GetDataTable(ss);
            //if (App.Rows.Count != 0)
            //{
            //    BlnApprover = true;
            //}
            //if (BlnApprover == true)
            if (Session["Jr_ApproverId"] == "true")
            {
                Session["StaffType"] = "App";
                //ss = "select distinct(mJobId),mJobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by mJobName";
                ss = "SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'" +
                " union" +
                " SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by mJobName";

            }

            else
            {
                ss = "select distinct(mJobId),mJobName from Job_Master_new where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "'  order by mJobName";
            }

        }

        else
        {
            ss = "select distinct(mjobname),mjobid  from Job_Master_new where CompId='" + ViewState["compid"].ToString() + "' order by mJobName";
        }
        DataTable dt1 = db.GetDataTable(ss);
        if (dt1.Rows.Count != 0)
        {
            dljob.DataSource = dt1;
            dljob.DataBind();
            Label28.Visible = false;
        }
        else
        {

            dljob.DataSource = null;
            dljob.DataBind();
            Label28.Visible = true;
        }
    }

    public void bind()
    {
        string ss = "";
        if (UserType == "staff")
        {
            ////ss = "select * from vw_JobnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "'  order by JobName";
            //ss = "select * from Job_Master_new where CompId='" + ViewState["compid"].ToString() + "' and JobApprover='" + Staffid + "' and JobStatus='OnGoing'";
            //DataTable App = db.GetDataTable(ss);
            //if (App.Rows.Count != 0)
            //{
            //    BlnApprover = true;
            //    Session["StaffType"] = "App";
            //}
            //if (BlnApprover == true)
            if (Session["Jr_ApproverId"] == "true")
            {
                Session["StaffType"] = "App";
                //ss = "select distinct(mJobId),mJobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by mJobName";
                ss = "SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'" +
                " union" +

                " SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by mJobName";

            }

            else
            {
                Session["StaffType"] = "Stf";

                //ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by StaffName";
                ss = "select distinct(mJobId),mJobName from Job_Master_new where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "'  order by mJobName";
            }

        }

        else
        {
            Session["StaffType"] = "Adm";

            ss = "select * from Job_Master_new where CompId='" + ViewState["compid"].ToString() + "' order by mJobName";
        }


        //string ss = "select * from Job_Master where CompId='" + ViewState["compid"].ToString() + "' order by JobName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            
        }
        else
        {
            
        }

        //*************** Staff 
        //string ss = "";
        if (UserType == "staff")
        {


            if (Session["Jr_ApproverId"] == "true")
            {
                //ss = "select distinct(StaffCode),StaffName from vw_JobnStaffnApprover where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by StaffName";
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
        string ss1 = ss;

        //string ss1 = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' order by StaffName";
        DataTable dt1 = db.GetDataTable(ss1);
        if (dt.Rows.Count != 0)
        {
            dlstaff.DataSource = dt1;
            dlstaff.DataBind();
            Label28.Visible = false;
        }
        else
        {
            //dlstaff.Items.Clear();
            //dlstaff.Items.Insert(0, "--None--");
            dlstaff.DataSource = null;
            dlstaff.DataBind();
            Label28.Visible = true;
        }

        //**************** Client 
        //string ss = "";
        if (UserType == "staff")
        {

           
            //if (BlnApprover == true)
            if (Session["Jr_ApproverId"] == "true")
            {
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

        string ss2 = ss;
        //string ss2 = "select * from Client_Master where CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
        DataTable dt2 = db.GetDataTable(ss2);
        if (dt.Rows.Count != 0)
        {
            dlclient.DataSource = dt2;
            dlclient.DataBind();
            Label31.Visible = false;
        }
        else
        {
            //dlclient.Items.Clear();
            //dlclient.Items.Insert(0, "--None--");
            dlclient.DataSource = null;
            dlclient.DataBind();
            Label31.Visible = true;
        }
    }
    //protected void btngenerate1_Click(object sender, EventArgs e)
    //{
    //    string script = "$(document).ready(function () { $('[id*=btngenerate1]').click(); });";
    //    //ClientScript.RegisterStartupScript(this.GetType(), "click", script, true);

    //    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "click", script);
    //    System.Threading.Thread.Sleep(1000);
    //    try
    //    {
    //        if (Session["companyid"] != null)
    //        {
    //            Session["URL"] = "Company/All_ClientStaffJob1.aspx";
    //        }
    //        else if (Session["staffid"] != null)
    //        {
    //            Session["URL"] = "staff/All_ClientStaffJob1.aspx";
    //        }
    //        int comp = int.Parse(ViewState["compid"].ToString());
    //        if (txtfrom.Text == "" || txtto.Text == "")
    //        {
    //            MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
    //        }
    //        else
    //        {
    //            //int clnt = int.Parse(drpjoblist.SelectedValue);

    //            string idcl = "";
    //            foreach (DataListItem rw in dlclient.Items)
    //            {
    //                Label lblId = (Label)rw.FindControl("Label51");
    //                decimal widd = decimal.Parse(lblId.Text);
    //                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
    //                if (chk.Checked == true)
    //                {

    //                    idcl += "'" + widd + "'" + ",";
    //                }

    //            }
    //            if (idcl != "")
    //            {
    //                idcl = idcl.Remove(idcl.Length - 1, 1);
    //            }


    //            string idjob = "";
    //            foreach (DataListItem rw in dljob.Items)
    //            {
    //                Label lblId = (Label)rw.FindControl("Label56");
    //                decimal widd = decimal.Parse(lblId.Text);
    //                CheckBox chk = (CheckBox)rw.FindControl("chkitem2");
    //                if (chk.Checked == true)
    //                {
    //                    chkid = true;
    //                    idjob += "'" + widd + "'" + ",";
    //                }

    //            }
    //            if (idjob != "")
    //            {
    //                idjob = idjob.Remove(idjob.Length - 1, 1);
    //            }

    //            string id = "";
    //            foreach (DataListItem rw in dlstaff.Items)
    //            {
    //                Label lblId = (Label)rw.FindControl("Label51");
    //                decimal widd = decimal.Parse(lblId.Text);
    //                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
    //                if (chk.Checked == true)
    //                {
    //                    id += "'" + widd + "'" + ",";
    //                }

    //            }
    //            if (id != "")
    //            {
    //                id = id.Remove(id.Length - 1, 1);
    //            }
    //            Session["staff"] = id;
    //            Session["job"] = idjob;
    //            Session["clt"] = idcl;
    //            CultureInfo info = new CultureInfo("en-US", false);
    //            DateTime Fdob = new DateTime(1900, 1, 1);
    //            DateTime dob = new DateTime(1900, 1, 1);
    //            String _dateFormat = "dd/MM/yyyy";
    //            if (txtfrom.Text.Trim() != "" && !DateTime.TryParseExact(txtfrom.Text.Trim(), _dateFormat, info,
    //                                                                                                 DateTimeStyles.AllowWhiteSpaces, out Fdob))
    //            {
    //            }
    //            if (txtto.Text.Trim() != "" && !DateTime.TryParseExact(txtto.Text.Trim(), _dateFormat, info,
    //                                                                                                  DateTimeStyles.AllowWhiteSpaces, out dob))
    //            {
    //            }


    //            DateTime EDT = dob;
    //            DateTime FDT = Fdob;

    //            string ST = "";
    //            string Ed = "";
    //            ST = String.Format("{0:MM/dd/yyyy}", Fdob);
    //            Ed = String.Format("{0:MM/dd/yyyy}", dob);
    //            Session["startdate"] = FDT;
    //            Session["enddate"] = EDT;



    //            string stftype = Session["StaffType"].ToString();
    //            string stf = Session["staff"].ToString();
    //            string cl = Session["clt"].ToString();
    //            string job = Session["job"].ToString();
    //            string sql = "";


    //            //if (stftype == "App")
    //            //{
    //            //    sql = "SELECT  * FROM vw_All_ClientStaffJob1 where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ") and staffcode in (" + stf + ") and Date1 between '" + ST + "' and '" + Ed + "' and JobApprover='" + Session["IsApprover"].ToString() + "' order by Date";
    //            //}
    //            //else if (stftype == "Adm")
    //            //{
    //            //    //sql = "SELECT  * FROM vw_Job_AllClientAllStaff_new where CompId='" + comp + "' and MJobId in (" + job + " ) and Date1 between '" + Fdob + "' and '" + dob + "' order by Date";
    //            //    sql = "SELECT  * FROM vw_All_ClientStaffJob1 where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ") and staffcode in (" + stf + ") and Date1 between '" + ST + "' and '" + Ed + "' order by mjobname";
    //            //}
    //            //else if (stftype == "Stf")
    //            //{
    //            //    sql = "SELECT  * FROM vw_All_ClientStaffJob1 where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ") and Date1 between '" + ST + "' and '" + Ed + "' and staffcode='" + Session["IsApprover"].ToString() + "' order by Date";
    //            //}
    //            //SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    //            //sqlConn.Open();
    //            UserType = Session["usertype"].ToString();
    //            if (UserType == "staff")
    //            {
    //                if (BlnApprover == true)
    //                {
    //                    sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.cltid in (" + Session["clt"] + ") and j.mJobID in (" + Session["job"] + ")and t.Staffcode in (" + Session["staff"] + ") and Date between '" + ST + "' and '" + Ed + "' and JobApprover='" + Session["IsApprover"].ToString() + "' order by clientname";
    //                    Session["StaffType"] = Session["staffid"].ToString();
    //                }
    //                else
    //                {
    //                    sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.cltid in (" + Session["clt"] + ") and j.mJobID in (" + Session["job"] + ") and t.Staffcode in (" + Session["staff"] + ") and Date between '" + ST + "' and '" + Ed + "'  order by clientname";
    //                    Session["StaffType"] = Session["staffid"].ToString();
    //                }
    //            }
    //            else
    //            {
    //                sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.cltid in (" + Session["clt"] + ") and j.mJobID in (" + Session["job"] + ")and t.Staffcode in (" + Session["staff"] + ") and Date between '" + ST + "' and '" + Ed + "'  order by clientname";
    //                Session["StaffType"] = "Adm";
    //            }


    //            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    //            sqlConn.Open();
    //            SqlCommand cmd1 = new SqlCommand("delete from Detailed2Loops where Usr='" + Session["StaffType"] + "' and compid='" + comp + "'", sqlConn);
    //            cmd1.ExecuteNonQuery();
    //            SqlCommand cmd2 = new SqlCommand("delete from Summary2Loops where Usr='" + Session["StaffType"] + "' and compid='" + comp + "'", sqlConn);
    //            cmd2.ExecuteNonQuery();
    //            SqlCommand cmd3 = new SqlCommand("delete from GrandTotal2Loops where Usr='" + Session["StaffType"] + "' and compid='" + comp + "'", sqlConn);
    //            cmd3.ExecuteNonQuery();


    //            SqlDataAdapter dscmd = new SqlDataAdapter(sql, sqlConn);
    //            DataSet ds = new DataSet();
    //            dscmd.Fill(ds, "Product");
    //            if (ds.Tables[0].Rows.Count > 0)
    //            {
    //                Response.Redirect("~/Report_All_ClientStaffJob1.aspx?comp=" + comp + "&pagename=All_ClientStaffJob1" + "&pagefolder=Expense", false);
    //            }
    //            else
    //            {
    //                MessageControl2.SetMessage("Timesheets Not Approved", MessageDisplay.DisplayStyles.Error);
    //            }
    //        }
    //    }
    //    catch (Exception ex)
    //    {

    //    }
    //}

    protected void chkstaffbox_CheckedChanged(object sender, EventArgs e)
    {
        
    }
    protected void chkclientbox_CheckedChanged(object sender, EventArgs e)
    {
       
    }
    protected void chkitem_CheckedChanged(object sender, EventArgs e)
    {

    }

    protected void chkitem2_CheckedChanged(object sender, EventArgs e)
    {
        foreach (DataListItem dl1 in dljob.Items)
        {
            Label lblId = (Label)dl1.FindControl("Label56");
            string widd = lblId.Text;
            CheckBox chk = (CheckBox)dl1.FindControl("chkitem2");
            if (chk.Checked == true)
            {
                string ss = "SELECT DISTINCT(dbo.Client_Master.ClientName),dbo.Client_Master.ClTID, dbo.JobName_Master.MJobId FROM dbo.Job_Staff_Table INNER JOIN dbo.Staff_Master ON dbo.Job_Staff_Table.StaffCode = dbo.Staff_Master.StaffCode INNER JOIN dbo.Job_Master ON dbo.Job_Staff_Table.JobId = dbo.Job_Master.JobId INNER JOIN dbo.JobName_Master ON dbo.Job_Master.MJobid = dbo.JobName_Master.MJobId INNER JOIN  dbo.Client_Master ON dbo.Job_Master.CLTId = dbo.Client_Master.CLTId WHERE dbo.JobName_Master.MJobId='" + widd + "' order by Client_Master.ClientName asc";
                DataTable dt = db.GetDataTable(ss);
                if (dt.Rows.Count > 0)
                {

                    foreach (DataRow dr in dt.Rows)
                    {
                        ClientID = dr["ClTID"].ToString();
                        foreach (DataListItem rw in dlclient.Items)
                        {
                            Label lblId1 = (Label)rw.FindControl("Label51");
                            if (lblId1.Text == dr["ClTID"].ToString())
                            {
                                CheckBox chk1 = (CheckBox)rw.FindControl("chkitem1");
                                chk1.Checked = true;

                                string ss1 = "SELECT DISTINCT (dbo.Staff_Master.StaffCode), dbo.JobName_Master.MJobId,Staff_Master.StaffName FROM dbo.Job_Staff_Table INNER JOIN dbo.Staff_Master ON dbo.Job_Staff_Table.StaffCode = dbo.Staff_Master.StaffCode INNER JOIN dbo.Job_Master ON dbo.Job_Staff_Table.JobId = dbo.Job_Master.JobId INNER JOIN dbo.JobName_Master ON dbo.Job_Master.MJobid = dbo.JobName_Master.MJobId INNER JOIN dbo.Client_Master ON dbo.Job_Master.CLTId = dbo.Client_Master.CLTId WHERE (dbo.Client_Master.CLTId = '" + ClientID + "') and dbo.JobName_Master.MJobId ='" + widd + "' ORDER BY Staff_Master.StaffName asc";
                                DataTable dt1 = db.GetDataTable(ss1);
                                if (dt1.Rows.Count > 0)
                                {
                                    foreach (DataRow dr1 in dt1.Rows)
                                    {
                                        Staffid = dr1["StaffCode"].ToString();
                                        foreach (DataListItem rw1 in dlstaff.Items)
                                        {
                                            Label lblId2 = (Label)rw1.FindControl("Label51");
                                            if (lblId2.Text == dr1["StaffCode"].ToString())
                                            {
                                                CheckBox chk2 = (CheckBox)rw1.FindControl("chkitem");
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
    protected void chkJB_CheckedChanged(object sender, EventArgs e)
    {
        if (chkJB.Checked == true)
        {
            foreach (DataListItem rw in dljob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem2");
                chk.Checked = true;
            }
            foreach (DataListItem rw in dlclient.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
            foreach (DataListItem rw in dlstaff.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }

        }
        else if (chkJB.Checked == false)
        {
            foreach (DataListItem rw in dljob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem2");
                chk.Checked = false;
            }
            foreach (DataListItem rw in dlclient.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
            foreach (DataListItem rw in dlstaff.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }

        }
    }
    protected void chkCL_CheckedChanged(object sender, EventArgs e)
    {
        if (chkCL.Checked == true)
        {
            foreach (DataListItem rw in dlclient.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }

        }
        else if (chkCL.Checked == false)
        {
            foreach (DataListItem rw in dlclient.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }

        }
    }
    protected void ChkST_CheckedChanged(object sender, EventArgs e)
    {
        if (ChkST.Checked == true)
        {
            foreach (DataListItem rw in dlstaff.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }

        }
        else if (ChkST.Checked == false)
        {
            foreach (DataListItem rw in dlstaff.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }

        }

    }
    protected void btngenerate1_Click1(object sender, EventArgs e)
    {
        string script = "$(document).ready(function () { $('[id*=btngenerate1]').click(); });";
        Page.ClientScript.RegisterStartupScript(this.GetType(), "click", script);
        //ClientScript.RegisterStartupScript(this.GetType(), "click", script, true);

        //Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "click", script);
        System.Threading.Thread.Sleep(1000);
        try
        {
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/All_ClientStaffJob1.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "staff/All_ClientStaffJob1.aspx";
            }
            int comp = int.Parse(ViewState["compid"].ToString());
            if (txtfrom.Text == "" || txtto.Text == "")
            {
                MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
            else
            {
                //int clnt = int.Parse(drpjoblist.SelectedValue);

                string idcl = "";
                foreach (DataListItem rw in dlclient.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                    if (chk.Checked == true)
                    {

                        idcl += "'" + widd + "'" + ",";
                    }

                }
                if (idcl != "")
                {
                    idcl = idcl.Remove(idcl.Length - 1, 1);
                }


                string idjob = "";
                foreach (DataListItem rw in dljob.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label56");
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem2");
                    if (chk.Checked == true)
                    {
                        chkid = true;
                        idjob += "'" + widd + "'" + ",";
                    }

                }
                if (idjob != "")
                {
                    idjob = idjob.Remove(idjob.Length - 1, 1);
                }

                string id = "";
                foreach (DataListItem rw in dlstaff.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        id += "'" + widd + "'" + ",";
                    }

                }
                if (id != "")
                {
                    id = id.Remove(id.Length - 1, 1);
                }
                Session["staff"] = id;
                Session["job"] = idjob;
                Session["clt"] = idcl;
                CultureInfo info = new CultureInfo("en-US", false);
                DateTime Fdob = new DateTime(1900, 1, 1);
                DateTime dob = new DateTime(1900, 1, 1);
                String _dateFormat = "dd/MM/yyyy";
                if (txtfrom.Text.Trim() != "" && !DateTime.TryParseExact(txtfrom.Text.Trim(), _dateFormat, info,
                                                                                                     DateTimeStyles.AllowWhiteSpaces, out Fdob))
                {
                }
                if (txtto.Text.Trim() != "" && !DateTime.TryParseExact(txtto.Text.Trim(), _dateFormat, info,
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



                string stftype = Session["StaffType"].ToString();
                string stf = Session["staff"].ToString();
                string cl = Session["clt"].ToString();
                string job = Session["job"].ToString();
                string sql = "";


                if (stftype == "App")
                {
                    sql = "SELECT  * FROM vw_All_ClientStaffJob1 where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ") and staffcode in (" + stf + ") and Date1 between '" + ST + "' and '" + Ed + "'  order by Date";
                }
                else if (stftype == "Adm")
                {
                    //sql = "SELECT  * FROM vw_Job_AllClientAllStaff_new where CompId='" + comp + "' and MJobId in (" + job + " ) and Date1 between '" + Fdob + "' and '" + dob + "' order by Date";
                    sql = "SELECT  * FROM vw_All_ClientStaffJob1 where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ") and staffcode in (" + stf + ") and Date1 between '" + ST + "' and '" + Ed + "' order by mjobname";
                }
                else if (stftype == "Stf")
                {
                    sql = "SELECT  * FROM vw_All_ClientStaffJob1 where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ") and Date1 between '" + ST + "' and '" + Ed + "' and staffcode='" + Session["IsApprover"].ToString() + "' order by Date";
                }
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                sqlConn.Open();

                SqlDataAdapter dscmd = new SqlDataAdapter(sql, sqlConn);
                DataSet ds = new DataSet();
                dscmd.Fill(ds, "Product");
                if (ds.Tables[0].Rows.Count > 0)
                {
                    Response.Redirect("~/Report_All_ClientStaffJob1.aspx?comp=" + comp + "&pagename=All_ClientStaffJob1" + "&pagefolder=Expense", false);
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
}

