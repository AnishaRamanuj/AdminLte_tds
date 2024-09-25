using JTMSProject;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI.WebControls;

public partial class controls_Report_TaskWiseDetails : System.Web.UI.UserControl
{
    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    private readonly DBAccess db = new DBAccess();
    DataTable dt_portStaff = new DataTable();
    decimal timee = 0;
    decimal charge = 0;
    decimal ope = 0;
    string stf = "";
    decimal total = 0;
    private DataRow dr;
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
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            if (ViewState["compid"] != null)
            {

                Binddata();
                string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
                DateTime date = DateTime.Now;
                DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);
                txtstartdate1.Text = firstDayOfMonth.ToString("dd/MM/yyyy");
                txtenddate2.Text = lastDayOfMonth.ToString("dd/MM/yyyy");
                if (Request.QueryString["nodata"] != null)
                {
                    MessageControl1.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        txtstartdate1.Attributes.Add("onblur", "checkForm();");

        txtenddate2.Attributes.Add("onblur", "checkForms();");
    }

    public void Binddata()
    {

        DataSet ds = new DataSet();
        string sp = "usp_GetTaskwiseData";
        SqlCommand cmd = new SqlCommand(sp, sqlConn);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@CompId", Convert.ToInt32(Session["cltcomp"].ToString()));
        cmd.CommandTimeout = 999999999;
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        da.Fill(ds);
        if (ds != null && ds.Tables[0].Rows.Count > 0)
        {
            Job_List.DataSource = ds;
            Job_List.DataBind();
        }
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
            //int comp = int.Parse(ViewState["compid"].ToString());


            foreach (DataListItem rw in Job_List.Items)
            {
                Label lblId = (Label)rw.FindControl("Label51");
                decimal wid = decimal.Parse(lblId.Text);
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                if (chk.Checked == true)
                {
                    stf += wid + ",";
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

            Session["startDate"] = FDT;
            Session["enddate"] = EDT;
            //Session["Hour"] = timee;
            //Session["Charge"] = charge;
            //Session["Ope"] = ope;
            //Session["Total"] = total;
            //Session["dt_St_TSum"] = dt_portStaff;
            //Session["Jobid"] = stf;

            string ST = "";
            string Ed = "";
            ST = String.Format("{0:MM/dd/yyyy}", FDT);
            Ed = String.Format("{0:MM/dd/yyyy}", EDT);

            DataSet dsss = getdata(Convert.ToInt32(Session["cltcomp"]),stf,ST,Ed);
            if (dsss.Tables != null && dsss.Tables[0].Rows.Count > 0)
            {
                DataTable dt = new DataTable();
               
                dt = dsss.Tables[0];
                Session["dt"] = dt;
                Session["startdate"] = ST;
                Session["enddate"] = Ed;
                Response.Redirect("~/ProjectTaskForm.aspx");
            }
            else
            {
                MessageControl1.SetMessage("No Records Found", MessageDisplay.DisplayStyles.Error);
            }

            //// select Staff for that job
            //string sql = "";

            //string stfid = "";
            //string ids = "";
            //int comp = int.Parse(ViewState["compid"].ToString());
            //sql = "SELECT  distinct(t.StaffCode) FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.CompId='" + comp + "' and j.mjobid in (" + stf + ") and t.status= 'Approved' and t.Date between '" + ST + "' and '" + Ed + "' order by t.staffcode";
            //DataTable dt = db.GetDataTable(sql);
            //if (dt.Rows.Count > 0)
            //{

            //    foreach (DataRow dr in dt.Rows)
            //    {
            //        ids = dr["StaffCode"].ToString();

            //        //ids = rw["t.StaffCode"].ToString() ;
            //        stfid += ids + ",";
            //    }
            //}
            //else
            //{
            //    MessageControl1.SetMessage("Timesheets Not Approved", MessageDisplay.DisplayStyles.Error);
            //    return;
            //}
            //if (stfid != "")
            //{
            //    stfid = stfid.Remove(stfid.Length - 1, 1);
            //}

            //Session["stfid"] = stfid;
            //UserType = Session["usertype"].ToString();


            //if (UserType == "staff")
            //{
            //    if (Session["Jr_ApproverId"] == "true")
            //    {
            //        Session["StaffType"] = "App";
            //        sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.CompId='" + comp + "' and t.status='Approved' and j.mjobid in (" + stf + ") and t.staffcode in (" + stfid + ") and t.Date between '" + ST + "' and '" + Ed + "'  order by t.Date";
            //        Session["StaffType"] = Session["staffid"].ToString();
            //    }
            //    else
            //    {

            //        sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.CompId='" + comp + "' and t.status='Approved' and j.mjobid in (" + stf + ") and t.staffcode in (" + stfid + ") and t.Date between '" + ST + "' and '" + Ed + "' order by t.Date";
            //        Session["StaffType"] = Session["staffid"].ToString();
            //    }
            //}
            //else
            //{
            //    sql = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.CompId='" + comp + "' and t.status='Approved' and j.mjobid in (" + stf + ") and t.staffcode in (" + stfid + ") and t.Date between '" + ST + "' and '" + Ed + "' order by t.Date";
            //    Session["StaffType"] = "Adm";
            //}
            //DataTable dt1 = db.GetDataTable(sql);
            //SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
            //sqlConn.Open();
            //SqlCommand cmd1 = new SqlCommand("delete from Detailed2Loops where Usr='" + Session["StaffType"] + "' and Compid='" + comp + "'", sqlConn);
            //cmd1.ExecuteNonQuery();
            //SqlCommand cmd2 = new SqlCommand("delete from Summary2Loops where Usr='" + Session["StaffType"] + "' and Compid='" + comp + "'", sqlConn);
            //cmd2.ExecuteNonQuery();
            //SqlCommand cmd3 = new SqlCommand("delete from GrandTotal2Loops where Usr='" + Session["StaffType"] + "' and Compid='" + comp + "'", sqlConn);
            //cmd3.ExecuteNonQuery();

            //if (dt1.Rows.Count > 0)
            //{

            //    //Response.Redirect("~/Report_Alljobs_Staffwise_Summary.aspx?comp=" + comp + "&Mjobid=" + stf + "&pagename=AllJobs_Staffwise_Summary", false);
            //    Response.Redirect("~/Report_Alljobs_Staffwise_Summary.aspx?comp=" + comp + "&pagename=AllJobs_Staffwise_Summary", false);
            //}
            //else
            //{
            //    MessageControl1.SetMessage("Timesheets Not Approved", MessageDisplay.DisplayStyles.Error);
            //}
        }

    }

    public DataSet getdata(int comp,string TaskID,string startdate,string enddate)
    {
        DataSet ds = new DataSet();
        try
        {
            //DateTime strdate = Convert.ToDateTime(txtmonth.Text, ci);
            string sp = "usp_GetTaskWiseDetails";
            SqlCommand cmd = new SqlCommand(sp, sqlConn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@TaskId", TaskID);
            cmd.Parameters.AddWithValue("@StartDate", startdate);
            cmd.Parameters.AddWithValue("@EndDate", enddate);
            cmd.CommandTimeout = 999999999;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
           // Session["monthdate"] = txtmonth.Text;
        }

        catch (Exception ex)
        {
            throw ex;
        }
        return ds;
    }

    protected void chkjob1_CheckedChanged(object sender, EventArgs e)
    {
        if (chkjob1.Checked == true)
        {
            foreach (DataListItem rw in Job_List.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (chkjob1.Checked == false)
        {
            foreach (DataListItem rw in Job_List.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }
}
