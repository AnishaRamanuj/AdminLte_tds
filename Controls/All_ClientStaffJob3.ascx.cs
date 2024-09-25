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


public partial class controls_All_ClientStaffJob3 : System.Web.UI.UserControl
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
    CultureInfo info = new CultureInfo("en-GB");
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
                hdnFrom.Value = (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year) + "-04-01";
                hdnTo.Value = Convert.ToDateTime(DateTime.Now, info).ToString("yyyy-MM-dd");
                if (Request.QueryString["nodata"] != null)
                {
                    MessageControl2.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
 
            
        }


    }
    public void bind()
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
                //ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'  order by ClientName";
                ss = "select distinct(Cltid),ClientName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' " +
                " union" +
                " SELECT distinct(Cltid),ClientName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by ClientName";

            }

            else
            {
                Session["StaffType"] = "Stf";
                ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClinetnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by ClientName";
            }
        }
        else
        {
            Session["StaffType"] = "Adm";
            //ss = "select * from Client_Master  where CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
            ss = "SELECT distinct(Client_Master.ClientName),Client_Master.Cltid FROM Job_Master INNER JOIN Client_Master ON dbo.Job_Master.CLTId = dbo.Client_Master.CLTId where client_master.CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
        }

        //string ss = "select * from Client_Master where CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
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

        // ********** Staff
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
                //ss = "select distinct(StaffCode),StaffName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' and DateOfLeaving IS Null  order by StaffName";
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
        if (dt1.Rows.Count != 0)
        {
            DlstStf.DataSource = dt1;
            DlstStf.DataBind();
            Label70.Visible = false;
        }
        else
        {
            DlstStf.DataSource = null;
            DlstStf.DataBind();
            Label70.Visible = true;
        }

        //***************** Job

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
                //ss = "select distinct(mJobId),mJobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'  order by mJobName";
                ss = "SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'" +
                " union" +

                " SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by mJobName";

            }

            else
            {
                //ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by StaffName";
                ss = "select distinct(mJobId),mJobName from vw_JobnClinetnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "'  order by mJobName";
            }

        }

        else
        {
            ss = "select distinct(mJobId),mJobName from vw_JobnStaff where CompId='" + ViewState["compid"].ToString() + "' order by mJobName";
        }
        string ss2 = ss;
        //string ss2 = "select * from Job_Master where CompId='" + ViewState["compid"].ToString() + "' order by JobName";
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
    }
    protected void btngenexp_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/All_ClientStaffJob3.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "staff/All_ClientStaffJob3.aspx";
            }
            if (hdnFrom.Value == "" || hdnTo.Value == "")
            {
                MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
            else
            {
                int comp = int.Parse(ViewState["compid"].ToString());
              
                //CultureInfo info = new CultureInfo("en-US", false);
                DateTime Fdob = Convert.ToDateTime(hdnFrom.Value, info);
                DateTime dob = Convert.ToDateTime(hdnTo.Value, info);
                //String _dateFormat = "dd/MM/yyyy";
                //if (txtfr.Text.Trim() != "" && !DateTime.TryParseExact(txtfr.Text.Trim(), _dateFormat, info,
                //                                                                                        DateTimeStyles.AllowWhiteSpaces, out Fdob))
                //{
                //}
                //if (txtend.Text.Trim() != "" && !DateTime.TryParseExact(txtend.Text.Trim(), _dateFormat, info,
                //                                                                                      DateTimeStyles.AllowWhiteSpaces, out dob))
                //{
                //}
                DateTime EDT = dob;
                DateTime FDT = Fdob;

                string ST = "";
                string Ed = "";
                ST = String.Format("{0:MM/dd/yyyy}", Fdob);
                Ed = String.Format("{0:MM/dd/yyyy}", dob);
                Session["startdate"] = FDT;
                Session["enddate"] = EDT;
                string id = "";
                //ArrayList[] ar= new Array[0];
                foreach (DataListItem rw in DlstJob.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label50");
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

                Session["job"] = id;

                string iddt = "";
                //ArrayList[] ar= new Array[0];
                foreach (DataListItem rw in DlstStf.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label50");
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        iddt += "'" + widd + "'" + ",";
                    }

                }
                if (iddt != "")
                {
                    iddt = iddt.Remove(iddt.Length - 1, 1);
                }
                Session["staff"] = iddt;

                string idstf = "";
                //ArrayList[] ar= new Array[0];
                foreach (DataListItem rw in DlstCLT.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label50");
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        idstf += "'" + widd + "'" + ",";
                    }

                }
                if (idstf != "")
                {
                    idstf = idstf.Remove(idstf.Length - 1, 1);
                }
                Session["clt"] = idstf;

                string stftype = Session["StaffType"].ToString();
                string stf = Session["staff"].ToString();
                string cl = Session["clt"].ToString();
                string job = Session["job"].ToString();
                string sql = "";

                if (stftype == "App")
                {
                    //sql = "SELECT  * FROM vw_All_ClientStaffJob3 where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ") and staffcode in (" + stf + ") and Date1 between '" + ST + "' and '" + Ed + "'and JobApprover='" + Session["IsApprover"].ToString() + "' order by Date";
                    sql = "SELECT  * FROM vw_All_ClientStaffJob3 where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ") and staffcode in (" + stf + ") and Date1 between '" + ST + "' and '" + Ed + "'  order by Date";
                }
                else if (stftype == "Adm")
                {

                    sql = "SELECT  * FROM vw_All_ClientStaffJob3 where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ") and staffcode in (" + stf + ") and Date1 between '" + ST + "' and '" + Ed + "' order by mjobname";
                }
                else if (stftype == "Stf")
                {
                    //sql = "SELECT  * FROM vw_All_ClientStaffJob3 where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ") and Date1 between '" + ST + "' and '" + Ed + "' and staffcode='" + Session["IsApprover"].ToString() + "' order by Date";
                    sql = "SELECT  * FROM vw_All_ClientStaffJob3 where CompId='" + comp + "' and MJobId in (" + job + ") and CLTId in (" + cl + ") and Date1 between '" + ST + "' and '" + Ed + "'  order by Date";
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
                    Response.Redirect("~/Report_All_ClientStaffJob3.aspx?comp=" + comp + "&pagename=All_clientstaffjob3" + "&pagefolder=Staff", false);
                }
                else
                {
                    MessageControl2.SetMessage("Timesheets Not Approved", MessageDisplay.DisplayStyles.Error);
                }
            }
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage("Timesheets Not Approved", MessageDisplay.DisplayStyles.Error);
        }
    }
    protected void chkjob_CheckedChanged(object sender, EventArgs e)
    {
        if (chkjob.Checked == true)
        {
            foreach (DataListItem rw in DlstJob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (chkjob.Checked == false)
        {
            foreach (DataListItem rw in DlstJob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
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
    protected void chkstaff_CheckedChanged(object sender, EventArgs e)
    {
        if (chkstaff.Checked == true)
        {
            foreach (DataListItem rw in DlstCLT.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
            foreach (DataListItem rw in DlstStf.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
            foreach (DataListItem rw in DlstJob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }

        }
        else if (chkstaff.Checked == false)
        {
            foreach (DataListItem rw in DlstCLT.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
            foreach (DataListItem rw in DlstStf.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
            foreach (DataListItem rw in DlstJob.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }

        }
    }




    protected void chk_staff(object sender, EventArgs e)
    {
        string Staffid = "";
        string StaffID = "";
        string JobID = "";
        string widd1 = "";
        string Clientid = "";
        //Client

        foreach (DataListItem dl1 in DlstStf.Items)
        {
            Label lblId = (Label)dl1.FindControl("Label50");
            string widd = lblId.Text;
            CheckBox chk = (CheckBox)dl1.FindControl("chkitem");
            if (chk.Checked == true)
            {
                StaffID = widd;
                widd1 = widd;
                string ss = "SELECT * FROM vw_Job_AllClientAllStaff_new WHERE StaffCode='" + widd + "'";
                DataTable dt = db.GetDataTable(ss);
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                    Clientid = dr["CLTId"].ToString();
                    foreach (DataListItem rw1 in DlstCLT.Items)
                    {
                        Label lblId2 = (Label)rw1.FindControl("Label50");
                        if (lblId2.Text == dr["CLTId"].ToString())
                        {
                            CheckBox chk2 = (CheckBox)rw1.FindControl("chkitem");
                            chk2.Checked = true;
                        }
                    }
                                   

                    
                        JobID = dr["MJobId"].ToString();
                        foreach (DataListItem rw in DlstJob.Items)
                        {
                            Label lblId1 = (Label)rw.FindControl("Label50");
                            if (lblId1.Text == dr["MJobId"].ToString())
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

   
}
