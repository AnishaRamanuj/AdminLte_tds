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

public partial class Admin_Staff_AllClientAllExpenses : System.Web.UI.Page
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
    private decimal _totalrepurchaseamountTotal;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string ss = "select * from Company_Master order by CompanyName";
            DataTable dt = db.GetDataTable(ss);
            if (dt.Rows.Count != 0)
            {
                drpcompanylist.DataSource = dt;
                drpcompanylist.DataBind();
            }
            string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            txtstartdate1.Text = dat;
            txtenddate2.Text = dat; 
        }
        txtstartdate1.Attributes.Add("onblur", "checkForm();");

        txtenddate2.Attributes.Add("onblur", "checkForms();");
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
            Session["URL"] = "Admin/Staff_AllClientAllExpenses.aspx";
            /////////////////////////////////////////////////////////////////////////////////////////////////////////////
            if (drpcompanylist.SelectedValue != "0" && txtstartdate1.Text != "" && txtenddate2.Text != "")
            {
                int comp = int.Parse(drpcompanylist.SelectedValue);
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
                string str = "select distinct t.StaffCode,s.StaffName " +
                        " from dbo.TimeSheet_Table as t left join Client_Master as c on c.CLTId=t.CLTId " +
                        " left join dbo.OPE_Master as ope on ope.OpeId=t.OpeId" +
                        " left join dbo.Staff_Master as s on s.StaffCode=t.StaffCode" +
                        " where t.Status='Approved' and t.StaffCode in (" + id + ") and t.CompId='" + comp + "' and t.Date between '" + Fdob + "' and '" + dob + "' and convert(float,t.OpeAmt) > 0.0";

                DataTable dtavail = db.GetDataTable(str);


                /////////////////////////////////////////////////////////////////////////////////////////////////////////////

                if (dtavail.Rows.Count > 0)
                {
                    DataList8.DataSource = dtavail;
                    DataList8.DataBind();
                    int stf1 = 0;
                    foreach (DataListItem rw in DataList8.Items)
                    {
                        Label lblId = (Label)rw.FindControl("Label51");
                        int Cid = int.Parse(lblId.Text);
                        Label lblstaff = (Label)rw.FindControl("Label50");
                        string staff = lblstaff.Text;
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
                    }
                    Session["dtstaff"] = dtstaff;

                    string startdate = txtstartdate1.Text;
                    string enddate = txtenddate2.Text;
                    Session["startdate"] = startdate;
                    Session["enddate"] = enddate;
                    //string dd = dtclient.Rows.Count.ToString();
                    string dd1 = dtstaff.Rows.Count.ToString();
                    if (id == "")
                    {
                        CheckBox1.Checked = false;
                        drpcompanylist_SelectedIndexChanged(sender, e);
                        MessageControl2.SetMessage("No Staff Selected.", MessageDisplay.DisplayStyles.Error);
                    }
                    else if (dd1 == "0")
                    {
                        MessageControl2.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
                        Response.Redirect("~/report1.aspx?comp=" + drpcompanylist.SelectedValue + "&pagename=Staff_AllClientAllExpense");
                    }
                }
                else
                {
                    MessageControl2.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
                }

            }
            else
            {
                MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }  
    protected void drpcompanylist_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ss1 = "select * from Staff_Master where CompId='" + drpcompanylist.SelectedValue + "' order by StaffName";
        DataTable dt1 = db.GetDataTable(ss1);
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
}
