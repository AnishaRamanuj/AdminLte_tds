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

public partial class Admin_Staff_DaytoDayTimesheet : System.Web.UI.Page
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
    protected void drpcompanylist_SelectedIndexChanged(object sender, EventArgs e)
    {
        //bindclient();
        //bindstaff();
        //bindjob();
        string ss = "select * from Staff_Master where CompId='" + drpcompanylist.SelectedValue + "' order by StaffName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            DataList8.DataSource = dt;
            DataList8.DataBind();
            //Label7.Visible = false;
        }
        else
        {
            DataList8.DataSource = null;
            DataList8.DataBind();
            //Label14.Visible = true;
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
            Session["URL"] = "Admin/Staff_DaytoDayTimesheet.aspx";
            if (drpcompanylist.SelectedValue != "0" && txtenddate2.Text != "" && txtstartdate1.Text != "")
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
                    Session["stfid"] = id;
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
                    string str = "select t.Date as dat,CONVERT(VARCHAR(10), t.Date, 103) AS Date " +
                                       " from dbo.TimeSheet_Table as t " +
                                       " where t.StaffCode in (" + id + ") and Date between '" + Fdob + "' and '" + dob + "'";
                    DataTable dtavail = db.GetDataTable(str);
                    string iddt = "";
                    if (dtavail.Rows.Count != 0)
                    {
                        foreach (DataRow rw in dtavail.Rows)
                        {
                            DateTime widd1 = DateTime.Parse(rw["dat"].ToString());
                            //decimal widd = decimal.Parse(lblId.Text);
                            // CheckBox chk = (CheckBox)rw.FindControl("chkitem1");              
                            iddt += "'" + widd1 + "'" + ",";

                        }
                        if (iddt != "")
                        {
                            iddt = iddt.Remove(iddt.Length - 1, 1);
                        }
                        string str1 = "select distinct t.StaffCode,s.Staffname  " +
                               " from dbo.TimeSheet_Table as t left join Staff_Master as s on s.StaffCode=t.StaffCode" +
                               " left join dbo.Client_Master as c on c.CLTId=t.CLTId" +
                               " left join dbo.Narration_Master as nar on nar.NarId=t.NarId" +
                               " where t.Status='Approved' and t.StaffCode in (" + id + ") and t.Date in (" + iddt + ") and t.CompId='" + drpcompanylist.SelectedValue + "' and (t.OpeAmt >0.0 or convert (float,t.TotalTime) >0.0) group by s.StaffName,t.StaffCode";
                        DataTable dtavail1 = db.GetDataTable(str1);
                        if (dtavail1.Rows.Count > 0)
                        {
                            DataList8.DataSource = dtavail1;
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
                                //}
                            }
                        }
                        else
                        {
                            MessageControl2.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
                            drpcompanylist_SelectedIndexChanged(sender, e);
                        }
                        Session["dtstaff"] = dtstaff;
                        Session["startdate"] = txtstartdate1.Text;
                        Session["enddate"] = txtenddate2.Text;
                        if (dtstaff.Rows.Count > 0)
                        {
                            Response.Redirect("~/report1.aspx?comp=" + comp + "&pagename=Staff_DaytoDayReport");
                        }
                        else
                        {
                            CheckBox1.Checked = false;
                            MessageControl2.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                            drpcompanylist_SelectedIndexChanged(sender, e);
                        }
                    }
                    else
                    {
                        MessageControl2.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
                        drpcompanylist_SelectedIndexChanged(sender, e);
                    }
                }
                else
                {
                    MessageControl2.SetMessage("No Staff Selected.", MessageDisplay.DisplayStyles.Error);
                    drpcompanylist_SelectedIndexChanged(sender, e);
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
}
