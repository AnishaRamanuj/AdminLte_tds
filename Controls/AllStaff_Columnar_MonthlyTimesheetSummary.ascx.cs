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


public partial class controls_Allstaff_Columnar_MonthlyTimesheet_Summary : System.Web.UI.UserControl
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
    string stf = "";
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

            
                bindstaff();
           
            
                if (Request.QueryString["nodata"] != null)
                {
                    //MessageControl2.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
    

        }

      
    }
    public void bindstaff()
    {
        string ss = "";
        if (UserType == "staff")
        {
            if (Session["Jr_ApproverId"] == "true")
            {
                Session["StaffType"] = "App";
                //ss = "select distinct(StaffCode),StaffName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'  order by StaffName";
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


        //string ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' order by StaffName";
        DataTable dt = db.GetDataTable(ss);
        //if (dt.Rows.Count != 0)
        //{
        //    drpstafflist.DataSource = dt;
        //    drpstafflist.DataBind();
        //}
        //else
        //{
        //    drpstafflist.Items.Clear();
        //    drpstafflist.Items.Insert(0, "--None--");
        //}
        //DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            Staff_List.DataSource = dt;
            Staff_List.DataBind();
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
            //drpclient.Items.Clear();
            //drpclient.DataSource = dt;
            //drpclient.DataBind();
            //drpclient.Items.Remove("--None--");
        }
        else
        {
            drpclient.Items.Clear();
            drpclient.Items.Insert(0, "--None--");
        }
    }



    protected void chkjob1_CheckedChanged(object sender, EventArgs e)
    {
        if (chkjob1.Checked == true)
        {
            foreach (DataListItem rw in Staff_List.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (chkjob1.Checked == false)
        {
            foreach (DataListItem rw in Staff_List.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }



    protected void btngenerate_Click(object sender, EventArgs e)
    {
        //try
        //{
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/Allstaff_Columnar_MonthlyTimesheetSummary.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "staff/Allstaff_Columnar_MonthlyTimesheetSummary.aspx";
            }
            if (ViewState["compid"] != null)
            {

                foreach (DataListItem rw in Staff_List.Items)
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

                Session["stf"] = stf;
                //Session["dtclient"] = null;
                string startdate = hdnmonth.Value;
                DateTime date = Convert.ToDateTime(hdnmonth.Value);
                DateTime startDate = date;
                DateTime lastdate = DateTime.Now;
                DateTime endDate = startDate.AddMonths(1).AddDays(-1);

                DateTime EDT = endDate;
                DateTime FDT = startDate;
                string ST = "";
                string Ed = "";
                ST = String.Format("{0:MM/dd/yyyy}", startDate);
                Ed = String.Format("{0:MM/dd/yyyy}", endDate);
                Session["startdate"] = FDT;
                Session["enddate"] = EDT;
                Session["hdnTStatusCheck"] = hdnTStatusCheck.Value;

                //int clnt = int.Parse(drpclient.SelectedValue);
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
                //string str = " select c.ClientName,j.JobName,dbo.TotalTime(t.TotalTime) as mints,s.StaffCode,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.Date as Date1,sum(CONVERT(float,t.TotalTime)) as time1,t.CompId " +
                //                        " from dbo.TimeSheet_Table as t " +
                //                        " left join  dbo.Staff_Master as s on s.StaffCode=t.StaffCode " +
                //                        " left join  dbo.Job_Master as j on j.JobId=t.JobId " +
                //                        " left join  dbo.Client_Master as c on c.CLTId=t.CLTId " +
                //                        " where  t.CompId='" + comp + "' and t.StaffCode in(" + Session["stf"] + ") and t.Date between '" + ST + "' and '" + Ed + "' group by t.Date,t.TotalTime,t.mints,c.ClientName,j.JobName,s.StaffCode,t.CompId ";
                //DataTable dt = db.GetDataTable(str);
                //if (dt.Rows.Count > 0)
                //{
                //    Session["startdate"] = null;
                //    Session["enddate"] = null;
                //    Response.Clear();
                //    //Response.Redirect("~/report1.aspx", false);
                //    // Response.Redirect("~/Report_Staff_AllClientsAllJobsHoursConsumed.aspx?comp=" + comp + "&staff=" + ss + "&pagename=StaffAllClientsAllJobsHoursConsumed" + "&pagefolder=Staff", false);
                    Response.Redirect("~/report_AllStaff_Columnar_MonthlyTimesheet.aspx?comp=" + comp  + "&pagename=Allstaff_MonthlyTimesheet_Summary" + "&pagefolder=Client", false);
                //}
                //else
                //{
                //    MessageControl2.SetMessage("No Record Found", MessageDisplay.DisplayStyles.Error);
                //}

            }
    }

}
