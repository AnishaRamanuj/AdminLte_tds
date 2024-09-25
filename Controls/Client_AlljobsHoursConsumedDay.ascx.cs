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

public partial class controls_Client_AlljobsHoursConsumedDay : System.Web.UI.UserControl
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
                ViewState["compid"]= Session["companyid"].ToString();
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
                string dat = DateTime.Now.Month + "/" + DateTime.Now.Year;
                fromdate.Text = dat;
                //txtenddate.Text = dat; 
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
            //string dat = DateTime.Now.Month + "/" + DateTime.Now.Year;
            //fromdate.Text = dat;
            ////txtenddate.Text = dat; 
            //if (Request.QueryString["nodata"] != null)
            //{
            //    MessageControl2.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
            //}
        }

        fromdate.Attributes.Add("onblur", "checkForm();");
    }

    protected void btngenerate_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/Client_AlljobsHoursConsumedDay.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "staff/Client_AlljobsHoursConsumedDay.aspx";
            }
            if (drpclient.SelectedValue != "0" && ViewState["compid"] != null)
            {
                
                string startdate = fromdate.Text;
                DateTime date = Convert.ToDateTime(fromdate.Text);
                DateTime startDate = date;
                DateTime lastdate = DateTime.Now;
                DateTime endDate = startDate.AddMonths(1).AddDays(-1);
                DateTime EDT = endDate;
                DateTime FDT = startDate;
                string ST = "";
                string Ed = "";
                ST = String.Format("{0:MM/dd/yyyy}", startDate );
                Ed = String.Format("{0:MM/dd/yyyy}", endDate );
                Session["startdate"] = FDT;
                Session["enddate"] = EDT;
                Session["Clt"]  = int.Parse(drpclient.SelectedValue);
                int comp = int.Parse(ViewState["compid"].ToString());
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                sqlConn.Open();
                SqlCommand cmd1 = new SqlCommand("delete from Detailed2Loops where Usr='" + Session["StaffType"] + "' and compid='" + Session["companyid"] + "'", sqlConn);
                cmd1.ExecuteNonQuery();
                SqlCommand cmd2 = new SqlCommand("delete from Summary2Loops where Usr='" + Session["StaffType"] + "'  and compid='" + Session["companyid"] + "'", sqlConn);
                cmd2.ExecuteNonQuery();
                SqlCommand cmd3 = new SqlCommand("delete from GrandTotal2Loops where Usr='" + Session["StaffType"] + "'  and compid='" + Session["companyid"] + "'", sqlConn);
                cmd3.ExecuteNonQuery();
                SqlCommand cmd4 = new SqlCommand("delete from Stafftimereport where Usrname='" + Session["StaffType"] + "'  and compid='" + Session["companyid"] + "'", sqlConn);
                cmd4.ExecuteNonQuery();
                string str = " select c.ClientName,j.JobName,t.TotalTime,s.StaffCode,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.Date as Date1,t.CompId " +
                                        " from dbo.TimeSheet_Table as t " +
                                        " left join  dbo.Staff_Master as s on s.StaffCode=t.StaffCode " +
                                        " left join  dbo.Job_Master as j on j.JobId=t.JobId " +
                                        " left join  dbo.Client_Master as c on c.CLTId=t.CLTId " +
                                        " where  t.Status='Approved' and t.CompId='" + comp + "' and t.CLTId in(" + Session["Clt"] + ") and t.Date between '" + ST + "' and '" + Ed + "'";
                DataTable dt = db.GetDataTable(str);

                if (dt.Rows.Count > 0)
                {
                    Response.Redirect("~/Report_Client_AlljobsHoursConsumedDay.aspx?comp=" + comp + "&pagename=AlljobsHoursConsumedDay" + "&pagefolder=Client", false);
                }
                else
                {
                    MessageControl2.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                }
            }
        }
       catch (Exception ex)
        {

        }

    }
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindclient();
    }
    public void bindclient()
    {
        string ss = "";
        if (UserType == "staff")
        {
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
                Session["StaffType"] = "Stf";
                ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClientnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by ClientName";
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
}
