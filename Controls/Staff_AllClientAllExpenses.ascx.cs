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

public partial class controls_Staff_AllClientAllExpenses : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    private readonly JobMaster job = new JobMaster();
    JobStaffTable jobstaff = new JobStaffTable();
    StaffMaster staff = new StaffMaster();
    CompanyMaster comp = new CompanyMaster();
    ClientMaster client = new ClientMaster();
    decimal timee = 0;
    decimal chargee = 0;
    decimal opee = 0;
    decimal chopee = 0;
    decimal timee1 = 0;
    decimal chargee1 = 0;
    decimal opee1 = 0;
    decimal chopee1 = 0;
    DataTable dtstaff = new DataTable();
    DataTable dtjob = new DataTable();
    DataTable dtclient = new DataTable();
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;

    private decimal _totalrepurchaseamountTotal;
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

                bind();
                string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
                txtstartdate1.Text = dat;
                txtenddate2.Text = dat;
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

            //bind();
            //string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            //txtstartdate1.Text = dat;
            //txtenddate2.Text = dat;
            //if (Request.QueryString["nodata"] != null)
            //{
            //    MessageControl2.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
            //}
        }

        txtstartdate1.Attributes.Add("onblur", "checkForm();");
        txtenddate2.Attributes.Add("onblur", "checkForms();");
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
               // ss = "select distinct(StaffCode),StaffName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and  Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by StaffName";
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

        //string ss1 = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' order by StaffName";
        DataTable dt1 = db.GetDataTable(ss);
        if (dt1.Rows.Count != 0)
        {
            //dlclientlist.Items.Clear();
            DataList8.DataSource = dt1;
            DataList8.DataBind();
            //drpclient.Items.Remove("--None--");
        }
        else
        {
            DataList8.DataSource = null;
            DataList8.DataBind();
        }
    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        if (CheckBox1.Checked == true)
        {
            foreach (DataListItem rw in DataList8.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (CheckBox1.Checked == false)
        {
            foreach (DataListItem rw in DataList8.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
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
                Session["URL"] = "Company/Staff_AllClientAllExpenses.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "staff/Staff_AllClientAllExpenses.aspx";
            }
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////
            if (txtenddate2.Text == "" || txtstartdate1.Text == "")
            {
                MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);

            }
            else
            {
                string id = "";
                foreach (DataListItem rw in DataList8.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    decimal wid = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        id += "'" + wid + "'" + ",";
                    }

                }
                if (id != "")
                {
                    id = id.Remove(id.Length - 1, 1);
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
                Session["startdate"] = FDT;
                Session["enddate"] = EDT;

                string str = "select distinct t.StaffCode,s.StaffName " +
                        " from dbo.TimeSheet_Table as t left join Client_Master as c on c.CLTId=t.CLTId " +
                        " left join dbo.OPE_Master as ope on ope.OpeId=t.OpeId" +
                        " left join dbo.Staff_Master as s on s.StaffCode=t.StaffCode" +
                        " where t.Status='Approved' and t.StaffCode in (" + id + ") and t.CompId='" + ViewState["compid"].ToString() + "' and t.Date between '" + ST + "' and '" + Ed + "' and convert(float,t.OpeAmt) > 0.0";

                DataTable dtavail = db.GetDataTable(str);


                /////////////////////////////////////////////////////////////////////////////////////////////////////////////

                //if (dtavail.Rows.Count > 0)
                //{
                DataList8.DataSource = dtavail;
                DataList8.DataBind();
                int stf1 = 0;
                foreach (DataListItem rw in DataList8.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    int Cid = int.Parse(lblId.Text);
                    Label lblstaff = (Label)rw.FindControl("Label50");
                    string staff = lblstaff.Text;
                    //CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    //if (chk.Checked == true)
                    //{
                    stf1 = Cid;
                    if (dtstaff == null || dtstaff.Rows.Count == 0)
                    {
                        dtstaff.Columns.Add("StaffCode", System.Type.GetType("System.String"));
                        dtstaff.Columns.Add("StaffName", System.Type.GetType("System.String"));
                        DataRow dr = dtstaff.NewRow();
                        dr["StaffCode"] = Cid;
                        dr["StaffName"] = staff;
                        dtstaff.Rows.Add(dr);
                        dtstaff.AcceptChanges();

                    }
                    else
                    {
                        DataRow dr = dtstaff.NewRow();
                        dr["StaffCode"] = Cid;
                        dr["StaffName"] = staff;
                        dtstaff.Rows.Add(dr);
                        dtstaff.AcceptChanges();
                    }
                    //  }
                }
                //}
                Session["dtstaff"] = dtstaff;
                Session["Staffcode"] = id;
                //string startdate = txtstartdate1.Text;
                //string enddate = txtenddate2.Text;
                //Session["startdate"] = startdate;
                //Session["enddate"] = enddate;

                //string dd = dtclient.Rows.Count.ToString();
                string dd1 = dtstaff.Rows.Count.ToString();
                if (dd1 == "0")
                {
                    bind();
                    MessageControl2.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    Response.Redirect("~/Report_Staff_AllClientAllExpenses.aspx?comp=" + ViewState["compid"].ToString() + "&pagename=Staff_AllClientAllExpense" + "&pagefolder=Staff", false);
                }
            }
        }
        catch (Exception ex)
        {

        }
    }
}
