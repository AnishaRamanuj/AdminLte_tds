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
using System.Globalization;
using JTMSProject;
using System.Data.SqlClient;

public partial class controls_Staff_Profitability : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    DataTable dt_portStaff = new DataTable();
    private int Cid;
    public string UserType = "";
    public Boolean BlnApprover = false ;
    public string Staffid = "";

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
                        // ss = "select distinct(StaffCode),StaffName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'  order by StaffName";
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
                if (dt.Rows.Count != 0)
                {
                    Staff_List.DataSource = dt;
                    Staff_List.DataBind();

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
            //       // ss = "select distinct(StaffCode),StaffName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'  order by StaffName";
            //        ss = "SELECT distinct(StaffCode), StaffName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and (Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "')" +
            //                " union" +
            //                " SELECT distinct(StaffCode), StaffName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by StaffName";

            //    }

            //    else
            //    {
            //        ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by StaffName";
            //    }
            //}

            //else
            //{
            //    ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' order by StaffName";
            //}
            
            
            
            ////string ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' order by StaffName";
            //DataTable dt = db.GetDataTable(ss);
            //if (dt.Rows.Count != 0)
            //{
            //    Staff_List.DataSource = dt;
            //    Staff_List.DataBind();

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
    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/Staff_Profitability.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "staff/Staff_Profitability.aspx";
            }
            if (txtenddate2.Text == "" || txtstartdate1.Text == "")
            {
                MessageControl1.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);

            }
            else
            {

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
                string id = "";
                string ST = "";
                string Ed = "";
                ST = String.Format("{0:MM/dd/yyyy}", Fdob);
                Ed = String.Format("{0:MM/dd/yyyy}", dob);
                Session["startdate"] = FDT;
                Session["enddate"] = EDT;
                int comp = int.Parse(ViewState["compid"].ToString());
              
                foreach (DataListItem rw in Staff_List.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                     Cid = int.Parse(lblId.Text);
                    Label lblstaff = (Label)rw.FindControl("Label50");
                    string staff = lblstaff.Text;
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                    if (chk.Checked == true)
                    {
                     
                        if (id == "")
                        {
                            id += Cid;

                        }
                        else
                        {
                            id += ",";
                            id +=  Cid ;
                        }

                        
                    }
                }
              
                Session["StaffCode"] = id;
                string sql = "";
                UserType = Session["usertype"].ToString();
                if (UserType == "staff")
                {
                    //if (BlnApprover == true)
                    if (Session["Jr_ApproverId"] == "true")
                    {
                        Session["StaffType"] = "App";
                        sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.Staffcode in (" + Session["StaffCode"] + ") and Date between '" + ST + "' and '" + Ed + "' order by clientname";
                        Session["StaffType"] = Session["staffid"].ToString();
                    }
                    else
                    {
                        sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.Staffcode in (" + Session["StaffCode"] + ") and Date between '" + ST + "' and '" + Ed + "'  order by clientname";
                        Session["StaffType"] = Session["staffid"].ToString();
                    }
                }
                else
                {
                    sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='" + comp + "' and t.Staffcode in (" + Session["StaffCode"] + ") and Date between '" + ST + "' and '" + Ed + "'  order by clientname";
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

                
                
               SqlDataAdapter dscmd = new SqlDataAdapter(sql, sqlConn);
            DataSet ds = new DataSet();
            dscmd.Fill(ds, "Product");
            if (ds.Tables[0].Rows.Count > 0)
            {
                    Response.Redirect("~/report_SatffProfitability.aspx?comp=" + comp + "&stfprof=prof" + "&pagename=SatffProfitability" + "&pagefolder=Staff", false);
            }
            else
            {
                MessageControl1.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
            }
            }
        }
        catch (Exception ex)
        {

        }
    }

    public DataTable GetTimeDetails(int StfId)
    {
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

            //DateTime frmdate = Convert.ToDateTime(txtstartdate1.Text);
            //DateTime enddate = Convert.ToDateTime(txtenddate2.Text);
            //Session["frm_prof"] = frmdate;
            //Session["to_prof"] = enddate;
            //Session["startdate"] = txtstartdate1.Text;
            //Session["enddate"] = txtenddate2.Text;
            string query = "select HourlyCharges,CurMonthSal,(select isnull(sum(convert(float,TotalTime)),0) from dbo.TimeSheet_Table "
                            + "  where StaffCode='" + StfId + "' and Date>='" + ST + "' and Date<='" + Ed + "')as Hours,"
                            + " (select isnull(sum(convert(float,TotalTime)),0) from dbo.TimeSheet_Table where StaffCode='" + StfId + "' and "
                            + " Date>='" + ST + "' and Date<='" + Ed + "')*HourlyCharges as TotCharge,"
                            + " case when (((select isnull(sum(convert(float,TotalTime)),0) from dbo.TimeSheet_Table"
                            + " where StaffCode='" + StfId + "' and Date>='" + ST + "' and Date<='" + Ed + "' )*HourlyCharges) -CurMonthSal )<0 then '0'"
                            + "else((select isnull(sum(convert(float,TotalTime)),0) from dbo.TimeSheet_Table where StaffCode='" + StfId + "'"
                            + "and Date>='" + ST + "' and Date<='" + Ed+ "' )* HourlyCharges) -CurMonthSal end  as Differ"
                            + " from Staff_Master where StaffCode='" + StfId + "'";
            DataTable dt = db.GetDataTable(query);
            return dt;
        
    }
}
