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

public partial class controls_Single_All_Clients_JobwiseSummary : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    DataTable dt_portStaff = new DataTable();
    decimal timee = 0;
    decimal charge = 0;
    decimal ope = 0;
    string stf = "";
     string Mjobid = "";
    decimal total = 0;
    private DataRow dr;
    string sql = "";
    private string staff, staff2;
    private int Cid, Cid2;
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
                        // ss = "select distinct(CLTId),ClientName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'  order by ClientName";
                        ss = "select distinct(Cltid),ClientName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' " +
                       " union" +
                        " SELECT distinct(Cltid),ClientName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by ClientName";

                    }

                    else
                    {
                        ss = "select distinct(CLTId),ClientName from vw_JobnStaffnApprover where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by ClientName";
                    }
                }

                else
                {
                    ss = "select * from client_Master where CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
                }

                //string ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' order by StaffName";
                DataTable dt = db.GetDataTable(ss);
                if (dt.Rows.Count != 0)
                {
                    Client_List.DataSource = dt;
                    Client_List.DataBind();
                }
                string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
                txtstartdate1.Text = dat;
                txtenddate2.Text = dat;
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
            //        Session["StaffType"] = "App";
            //       // ss = "select distinct(CLTId),ClientName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'  order by ClientName";
            //        ss = "select distinct(Cltid),ClientName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' " +
            //       " union" +
            //        " SELECT distinct(Cltid),ClientName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by ClientName";

            //    }

            //    else
            //    {
            //        ss = "select distinct(CLTId),ClientName from vw_JobnStaffnApprover where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by ClientName";
            //    }
            //}

            //else
            //{
            //    ss = "select * from client_Master where CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
            //}

            ////string ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' order by StaffName";
            //DataTable dt = db.GetDataTable(ss);
            //if (dt.Rows.Count != 0)
            //{
            //    Client_List.DataSource = dt;
            //    Client_List.DataBind();
            //}
            //string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            //txtstartdate1.Text = dat;
            //txtenddate2.Text = dat;
            //if (Request.QueryString["nodata"] != null)
            //{
            //    MessageControl1.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
            //}
        }

        txtstartdate1.Attributes.Add("onblur", "checkForm();");

        txtenddate2.Attributes.Add("onblur", "checkForms();");
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        if (Session["companyid"] != null)
        {
            Session["URL"] = "Company/Staff_TimeSheet_Sumary.aspx";
        }
        else if (Session["staffid"] != null)
        {
            Session["URL"] = "Staff/Staff_TimeSheet_Sumary.aspx";
        }
        if (txtenddate2.Text == "" || txtstartdate1.Text == "")
        {
            //MessageControl1.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);

        }
        else
        {
            int comp = int.Parse(ViewState["compid"].ToString());


            foreach (DataListItem rw in Client_List.Items)
            {
                Label lblId = (Label)rw.FindControl("Label51");
                decimal wid = decimal.Parse(lblId.Text);
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                if (chk.Checked == true)
                {
                    stf += "'" + wid + "'" + ",";
                    //stf += wid + ",";
                }
            }

            if (stf != "")
            {
                stf = stf.Remove(stf.Length - 1, 1);
            }
        
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

            Session["startDate"] = FDT;
            Session["enddate"] = EDT;
            Session["Hour"] = timee;
            Session["Charge"] = charge;
            Session["Ope"] = ope;
            Session["Total"] = total;
            Session["dt_St_TSum"] = dt_portStaff;
            Session["Cltid"] = stf;

            string ids = "";
            string stfid = "";
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        sqlConn.Open();
        sql = "SELECT distinct(dbo.Job_Master.MJobid),JobName_Master.MJobName FROM dbo.TimeSheet_Table INNER JOIN dbo.Job_Master ON dbo.TimeSheet_Table.JobId = dbo.Job_Master.JobId INNER JOIN dbo.JobName_Master ON dbo.Job_Master.MJobid = dbo.JobName_Master.MJobId INNER JOIN dbo.Client_Master ON dbo.Job_Master.CLTId = dbo.Client_Master.CLTId WHERE (dbo.TimeSheet_Table.CLTId IN (" + Session["Cltid"] + ") AND TimeSheet_Table.Date between '" + ST + "' and '" + Ed + "' AND (dbo.TimeSheet_Table.Status = 'Approved'))";
        SqlDataAdapter dscmd1 = new SqlDataAdapter(sql, sqlConn);
        DataSet ds1 = new DataSet();
        dscmd1.Fill(ds1, "Product");
        DataTable dt = db.GetDataTable(sql);
        int wid1 = 0;

        if (dt.Rows.Count > 0)
        {

            foreach (DataRow dr in dt.Rows)
            {
                ids = dr["MJobid"].ToString();

                //ids = rw["t.StaffCode"].ToString() ;
                stfid += "'" + ids + "'" + ",";
                //stfid += ids + ",";
            }
        }
        if (stfid != "")
        {
            stfid = stfid.Remove(stfid.Length - 1, 1);
        }
        Session["Mjobid"] = stfid;
            string startdate = txtstartdate1.Text;
            string enddate = txtenddate2.Text;
            string stftype = UserType;
            string sql1 = "";

            UserType = Session["usertype"].ToString();
            if (UserType == "staff")
            {
                //if (BlnApprover == true)
                if (Session["Jr_ApproverId"] == "true")
                {
                    sql1 = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid=" + comp + " and t.status='Approved' and t.cltid in (" + Session["Cltid"] + ") and j.mjobid in(" + Session["Mjobid"] + ") and Date between '" + ST + "' and '" + Ed + "' order by clientname";
                }
                else
                {
                    sql1 = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid=" + comp + " and t.status='Approved' and t.cltid in (" + Session["Cltid"] + ") and j.mjobid in(" + Session["Mjobid"] + ") and Date between '" + ST + "' and '" + Ed + "' order by clientname";
                }
            }
            else
            {
                sql1 = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid=" + comp + " and t.status='Approved' and t.cltid in (" + Session["Cltid"] + ") and j.mjobid in(" + Session["Mjobid"] + ") and Date between '" + ST + "' and '" + Ed + "' order by clientname";
                Session["StaffType"] = "adm";
            }

            SqlConnection sqlConn1 = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
            sqlConn1.Open();

            SqlCommand cmd1 = new SqlCommand("delete from Detailed2Loops where Usr='" + Session["StaffType"] + "' and compid= " + comp + "", sqlConn);
            cmd1.ExecuteNonQuery();
            SqlCommand cmd2 = new SqlCommand("delete from Summary2Loops where Usr='" + Session["StaffType"] + "'and compid= " + comp + "", sqlConn);
            cmd2.ExecuteNonQuery();
            SqlCommand cmd3 = new SqlCommand("delete from GrandTotal2Loops where Usr='" + Session["StaffType"] + "'and compid= " + comp + "", sqlConn);
            cmd3.ExecuteNonQuery();

          SqlDataAdapter dscmd = new SqlDataAdapter(sql1, sqlConn);
          DataSet ds = new DataSet();
              dscmd.Fill(ds, "Product");
            if (ds.Tables[0].Rows.Count > 0)
            {
                Response.Redirect("~/Report_Single_All_Client_Jobwise_Timesheet_Summary.aspx?comp=" + comp + "", false);

            }
         }
    }
    protected void chkjob1_CheckedChanged(object sender, EventArgs e)
    {
        if (chkjob1.Checked == true)
        {
            foreach (DataListItem rw in Client_List.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (chkjob1.Checked == false)
        {
            foreach (DataListItem rw in Client_List.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }
}
