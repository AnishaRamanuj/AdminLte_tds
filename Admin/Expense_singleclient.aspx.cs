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

public partial class Admin_Expense_singleclient: System.Web.UI.Page
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
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string ss = "select * from Company_Master order by CompanyName";
            DataTable dt = db.GetDataTable(ss);
            drpopecmp.DataSource = dt;
            drpopecmp.DataBind();
            string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            txtfr.Text = dat;
            txtend.Text = dat; 

        }
       txtfr.Attributes.Add("onblur", "checkForm();");

        txtend.Attributes.Add("onblur", "checkForms();");
    }
    protected void drpopecmp_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ss = "select * from Client_Master where CompId='" + drpopecmp.SelectedValue + "' order by ClientName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            DataList3.DataSource = dt;
            DataList3.DataBind();
            Label7.Visible = false;
            //drpclient.Items.Remove("--None--");
        }
        else
        {
            DataList3.DataSource = null;
            DataList3.DataBind();
            Label7.Visible = false;
        }
    }
    protected void btngenexp_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Expense_singleclient.aspx";
            if (drpopecmp.SelectedValue == "0" || txtend.Text == "" || txtfr.Text == "")
            {
                MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
            else
            {
                int comp = int.Parse(drpopecmp.SelectedValue);
                string id = "";
                foreach (DataListItem rw in DataList3.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label50");
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

                    string str1 = " select t.CompId,t.CLTId,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.Date as Date1,t.OpeAmt as ope,ope.OPEName,c.ClientName,t.mints  " +
                                " from dbo.TimeSheet_Table as t " +
                                " inner join dbo.Client_Master as c on c.CLTId=t.CLTId " +
                                " left join dbo.OPE_Master as ope on ope.OpeId=t.OpeId " +
                                " where t.Status='Approved' and t.CLTId in (" + id + ") and t.Date between '" + Fdob + "' and '" + dob + "' and convert(float,t.OpeAmt) > 0.0 ";
                    DataTable dtavail = db.GetDataTable(str1);

                    DataList3.DataSource = dtavail;
                    DataList3.DataBind();
                    int stf = 0;
                    //ArrayList[] ar= new Array[0];
                    foreach (DataListItem rw in DataList3.Items)
                    {
                        Label lblId = (Label)rw.FindControl("Label50");
                        int Cid = int.Parse(lblId.Text);
                        Label lblstaff = (Label)rw.FindControl("Label51");
                        string staff = lblstaff.Text;
                        CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                        //if (chk.Checked == true)
                        //{
                        stf = Cid;
                        if (dtclient == null || dtclient.Rows.Count == 0)
                        {
                            dtclient.Columns.Add("CLTId", System.Type.GetType("System.String"));
                            dtclient.Columns.Add("ClientName", System.Type.GetType("System.String"));
                            DataRow dr = dtclient.NewRow();
                            dr["CLTId"] = Cid;
                            dr["ClientName"] = staff;
                            dtclient.Rows.Add(dr);
                            dtclient.AcceptChanges();
                        }
                        else
                        {
                            DataRow dr = dtclient.NewRow();
                            dr["CLTId"] = Cid;
                            dr["ClientName"] = staff;
                            dtclient.Rows.Add(dr);
                            dtclient.AcceptChanges();
                        }
                        // }
                    }
                    Session["dtclient"] = dtclient;
                    Session["dtjob"] = null;
                    Session["dtstaff"] = null;
                    string startdate = txtfr.Text;
                    string enddate = txtend.Text;
                    Session["startdate"] = startdate;
                    Session["enddate"] = enddate;
                    string dd = dtclient.Rows.Count.ToString();
                    string dd1 = dtjob.Rows.Count.ToString();
                    string dd2 = dtstaff.Rows.Count.ToString();
                    if (dtclient.Rows.Count <= 0)
                    {
                        chkclope.Checked = false;
                        drpopecmp_SelectedIndexChanged(sender, e);
                        MessageControl2.SetMessage("No Record Found.No Expense Amount Exists", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
                        Response.Redirect("~/report1.aspx?comp=" + comp + "&pagename=Expense_Allclients");
                    }
                }
                else
                {
                    MessageControl2.SetMessage("No Client Selected.", MessageDisplay.DisplayStyles.Error);
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
