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

public partial class controls_Client_AlljobsAllExpenses : System.Web.UI.UserControl
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
            if (ViewState["compid"] != null)
            {
                UserType = Session["usertype"].ToString();
                if (UserType == "staff")
                {
                    Staffid = Session["staffid"].ToString();
                }

                bindclient();
                //bindstaff();
                //bindjob();
                //Label7.Visible = true;
                //Label8.Visible = true;
                string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
                fromdate.Text = dat;
                txtenddate.Text = dat;
                if (Request.QueryString["nodata"] != null)
                {
                    MessageControl2.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
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

            //bindclient();
            ////bindstaff();
            ////bindjob();
            ////Label7.Visible = true;
            ////Label8.Visible = true;
            //string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            //fromdate.Text = dat;
            //txtenddate.Text = dat;
            //if (Request.QueryString["nodata"] != null)
            //{
            //    MessageControl2.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
            //}
        }

        fromdate.Attributes.Add("onblur", "checkForm();");
        txtenddate.Attributes.Add("onblur", "checkForms();");
    }

    protected void btngenerate_Click(object sender, EventArgs e)
    {
        //try
        //{
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/Client_AlljobsAllExpenses.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "staff/Client_AlljobsAllExpenses.aspx";
            }
            if (drpclient.SelectedValue != "0" && ViewState["compid"] != null)
            {

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
                ST = String.Format("{0:MM/dd/yyyy}", Fdob );
                Ed = String.Format("{0:MM/dd/yyyy}", dob ); 

                string str = "select t.TSId,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.OpeAmt as ope,ope.OPEName,j.JobName " +
                                " from dbo.TimeSheet_Table as t left join Job_Master as j on j.JobId=t.JobId " +
                                " left join dbo.OPE_Master as ope on ope.OpeId=t.OpeId" +
                                " where t.Status='Approved' and t.CLTId='" + drpclient.SelectedValue + "' and t.CompId='" + ViewState["compid"].ToString() + "' and t.Date between '" + ST + "' and '" + Ed + "' and convert(float,t.OpeAmt) > 0.0";

                DataTable dtavail = db.GetDataTable(str);
                if (dtavail.Rows.Count == 0)
                {
                    MessageControl2.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    //string startdate = ST ;
                    //string enddate = Ed;
                    Session["startdate"] = FDT;
                    Session["enddate"] = EDT;
                    dtclient.Columns.Add("CLTId", System.Type.GetType("System.String"));
                    dtclient.Columns.Add("ClientName", System.Type.GetType("System.String"));
                    DataRow dr = dtclient.NewRow();
                    dr["CLTId"] = drpclient.SelectedValue;
                    dr["ClientName"] = drpclient.SelectedItem.Text;
                    dtclient.Rows.Add(dr);
                    dtclient.AcceptChanges();
                    Session["dtclient"] = dtclient;
                    int clnt = int.Parse(drpclient.SelectedValue);
                    int comp = int.Parse(ViewState["compid"].ToString());
                    Response.Redirect("~/Report1_Client_AlljobsAllExpenses.aspx?comp=" + comp + "&clnt=" + clnt + "&pagename=AlljobsAllExpenses" + "&pagefolder=Client", false);
                    //Response.Redirect("~/report1.aspx?comp=" + comp + "&job=" + jid + "&Cltid=" + clnt + "&pagename=AllJobAllStaff", false);
                }
            }
            //else
            //{
            //    MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            //}
        //}
        //catch (Exception ex)
        //{

        //}
    }
    public void bindclient()
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
               
               // ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by ClientName";
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
            drpclient.Items.Clear();
            drpclient.DataSource = dt;
            drpclient.DataBind();
        }
        else
        {
            drpclient.Items.Clear();
            drpclient.Items.Insert(0, "--None--");
        }
    }
}
