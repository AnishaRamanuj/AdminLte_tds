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
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using System.Text;
using System.Globalization;
using System.Data.SqlClient;


public partial class controls_Expense_Allclients : System.Web.UI.UserControl
{
    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
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
                    Session["IsApprover"] = Staffid;
                }
                string st;
                hdnHod.Value = "0";
                st = "SELECT compecentryoffloc,LWP,ApprovedByHOD from CompanyTimeThreshold where Companyid='" + Session["companyid"].ToString() + "'";
                DataTable dt = db.GetDataTable(st);

                if (dt != null)
                {

                    if (dt.Rows[0]["ApprovedByHOD"].ToString() == "True")
                    {
                        hdnHod.Value = "1";
                    }
                }
                bind();
                DateTime date = DateTime.Now;

                DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

                txtfr.Text = firstDayOfMonth.ToString("dd/MM/yyyy");
                txtend.Text = lastDayOfMonth.ToString("dd/MM/yyyy");
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
           // if (UserType == "staff")
           // {
           //     Staffid = Session["staffid"].ToString();
           //     Session["IsApprover"] = Staffid;
           // }
           // string st;
           // hdnHod.Value = "0";
           // st = "SELECT compecentryoffloc,LWP,ApprovedByHOD from CompanyTimeThreshold where Companyid='" + Session["companyid"].ToString() + "'";
           // DataTable dt = db.GetDataTable(st);

           // if (dt != null)
           // {

           //     if (dt.Rows[0]["ApprovedByHOD"].ToString() == "True")
           //     {
           //         hdnHod.Value = "1";
           //     }
           // }
           // bind();
           // string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
           // txtfr.Text = dat;
           // txtend.Text = dat;
           // if (Request.QueryString["nodata"] != null)
           // {
           //     MessageControl2.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
           // }
        }

        txtfr.Attributes.Add("onblur", "checkForm();");

        txtend.Attributes.Add("onblur", "checkForms();");
    }
    public void bind()
    {
        DataTable dt = new DataTable();
        DataSet ds = new DataSet();
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
            if (Session["Jr_ApproverId"].ToString() == "true")
            {
                Session["StaffType"] = "App";
                //ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by ClientName";
                SqlParameter[] param = new SqlParameter[2];
                {
                    param[0] = new SqlParameter("@staffcode", Session["staffid"].ToString());
                    param[1] = new SqlParameter("@compid", Session["companyid"].ToString());
                    ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_bindClient_approver", param);
                }
                dt = ds.Tables[0];
            }

            else
            {
                Session["StaffType"] = "Stf";
                ss = "select DISTINCT ClientName,CLTid FROM vw_JobnClinetnStaff where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by ClientName";
                dt = db.GetDataTable(ss);
            }
        }
        else
        {
            Session["StaffType"] = "Adm";
            //ss = "select * from Client_Master  where CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
           ss = "SELECT distinct(Client_Master.ClientName),Client_Master.Cltid FROM Job_Master INNER JOIN Client_Master ON dbo.Job_Master.CLTId = dbo.Client_Master.CLTId where client_master.CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
           dt = db.GetDataTable(ss);
        }

        if (dt.Rows.Count != 0)
        {
            DataList3.DataSource = dt;
            DataList3.DataBind();
            Label60.Visible = false;
            //drpclient.Items.Remove("--None--");
        }
        else
        {
            DataList3.DataSource = null;
            DataList3.DataBind();
            Label60.Visible = true;
        }
    }
    protected void btngenexp_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/Expense_Allclients.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "Staff/Expense_Allclients.aspx";
            }
            if (txtfr.Text == "" || txtend.Text == "")
            {
                MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
            else
            {
                int comp = int.Parse(ViewState["compid"].ToString());
                int stf = 0;
                string idstf = "";
                foreach (DataListItem rw in DataList3.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label50");
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        idstf += "" + widd + "" + ",";
                    }

                }
                if (idstf != "")
                {
                    idstf = idstf.Remove(idstf.Length - 1, 1);
                }

                CultureInfo info = new CultureInfo("en-US", false);
                DateTime Fdob = new DateTime(1900, 1, 1);
                DateTime dob = new DateTime(1900, 1, 1);
                String _dateFormat = "dd/MM/yyyy";
                if (txtfr.Text.Trim() != "" && !DateTime.TryParseExact(txtfr.Text.Trim(), _dateFormat, info,
                                                                                                        DateTimeStyles.AllowWhiteSpaces, out Fdob))
                {
                }
                if (txtend.Text.Trim() != "" && !DateTime.TryParseExact(txtend.Text.Trim(), _dateFormat, info,
                                                                                                      DateTimeStyles.AllowWhiteSpaces, out dob))
                {
                }
                DateTime EDT = dob;
                DateTime FDT = Fdob;
                Session["clt"] = idstf;
                string ST = "";
                string Ed = "";
                ST = String.Format("{0:MM/dd/yyyy}", Fdob);
                Ed = String.Format("{0:MM/dd/yyyy}", dob);
                Session["startdate"] = FDT;
                Session["enddate"] = EDT;
                string stftype = Session["StaffType"].ToString();
                string sql="";
                SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
                sqlConn.Open();

                if (stftype == "App")
                {
                    sql = "SELECT  * FROM vw_Expense_Allclients where CompId='" + comp + "' and CLTId in (" + idstf + ") and Date1 between '" + ST + "' and '" + Ed + "' order by Date";
                }
                else if (stftype == "Adm")
                {
                    sql = "SELECT  * FROM vw_Expense_Allclients where CompId='" + comp + "' and CLTId in (" + idstf + ") and Date1 between '" + ST + "' and '" + Ed + "' order by Date";
                }
                else if (stftype == "Stf")
                {
                    sql = "SELECT  * FROM vw_Expense_Allclients where CompId='" + comp + "' and CLTId in (" + idstf + ") and Date1 between '" + ST + "' and '" + Ed + "' and StaffCode='" + Session["IsApprover"].ToString() + "' order by Date";
                }

                SqlDataAdapter dscmd = new SqlDataAdapter(sql, sqlConn);
                DataSet ds = new DataSet();
                dscmd.Fill(ds, "Product");
                if (ds.Tables[0].Rows.Count > 0)
                {
                    Response.Redirect("~/Report_Expense_Allclients.aspx?comp=" + comp + "&pagename=Expense_Allclients" + "&pagefolder=Expense", false);
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
    protected void chkclope_CheckedChanged(object sender, EventArgs e)
    {
        if (chkclope.Checked == true)
        {
            foreach (DataListItem rw in DataList3.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (chkclope.Checked == false)
        {
            foreach (DataListItem rw in DataList3.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
        }
    }
}
