using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;
using System.Globalization;

public partial class Admin_Staff_TimeSheet_Sumary : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    DataTable dt_portStaff = new DataTable();
    decimal timee = 0;
    decimal charge = 0;
    decimal ope = 0;
    decimal total = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            txtstartdate1.Text = dat;
            txtenddate2.Text = dat; 

        }
        txtstartdate1.Attributes.Add("onblur", "checkForm();");

        txtenddate2.Attributes.Add("onblur", "checkForms();");
    }
    protected void drpcompanylist_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ss = "select * from Staff_Master where CompId='" + drpcompanylist.SelectedValue + "' order by StaffName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            Staff_List.DataSource = dt;
            Staff_List.DataBind();
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
    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Staff_TimeSheet_Sumary.aspx";
            if (drpcompanylist.SelectedValue != "0" && txtenddate2.Text != "" && txtstartdate1.Text != "")
            {
                int comp = int.Parse(drpcompanylist.SelectedValue);
                int stf = 0;
                foreach (DataListItem rw in Staff_List.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    int Cid = int.Parse(lblId.Text);
                    Label lblstaff = (Label)rw.FindControl("Label50");
                    string staff = lblstaff.Text;
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                    if (chk.Checked == true)
                    {
                        stf = Cid;
                        DataTable dt = GetTimeDetails(Cid);

                        if (dt.Rows.Count > 0)
                        {
                            for (int k = 0; k < dt.Rows.Count; k++)
                            {
                                if (dt_portStaff == null || dt_portStaff.Rows.Count == 0)
                                {
                                    dt_portStaff.Columns.Add("StaffCode", System.Type.GetType("System.String"));
                                    dt_portStaff.Columns.Add("StaffName", System.Type.GetType("System.String"));

                                    dt_portStaff.Columns.Add("Hours", System.Type.GetType("System.String"));
                                    dt_portStaff.Columns.Add("Charges", System.Type.GetType("System.String"));
                                    dt_portStaff.Columns.Add("OpeAmt", System.Type.GetType("System.String"));
                                    dt_portStaff.Columns.Add("Total", System.Type.GetType("System.String"));


                                    DataRow dr = dt_portStaff.NewRow();
                                    dr["StaffCode"] = Cid;
                                    dr["StaffName"] = staff;

                                    dr["Hours"] = dt.Rows[k]["Hours"].ToString();
                                    dr["Charges"] = dt.Rows[k]["Charges"].ToString();
                                    dr["OpeAmt"] = dt.Rows[k]["OpeAmt"].ToString();
                                    dr["Total"] = dt.Rows[k]["Total"].ToString();


                                    dt_portStaff.Rows.Add(dr);
                                    dt_portStaff.AcceptChanges();
                                }
                                else
                                {
                                    DataRow dr = dt_portStaff.NewRow();
                                   // dr["StaffCode"] = Cid;
                                    //dr["StaffName"] = staff;

                                    dr["Hours"] = dt.Rows[k]["Hours"].ToString();
                                    dr["Charges"] = dt.Rows[k]["Charges"].ToString();
                                    dr["OpeAmt"] = dt.Rows[k]["OpeAmt"].ToString();
                                    dr["Total"] = dt.Rows[k]["Total"].ToString();

                                    dt_portStaff.Rows.Add(dr);
                                    dt_portStaff.AcceptChanges();

                                }
                                //DataRow dr2 = dt_portStaff.NewRow();
                                //dr2["StaffCode"] = Cid;
                                //dr2["StaffName"] = staff;
                                //dt_portStaff.Rows.Add(dr2);
                                //dt_portStaff.AcceptChanges();
                            }
                        }
                        Session["Hour"] = timee;
                        Session["Charge"] = charge;
                        Session["Ope"] = ope;
                        Session["Total"] = total;
                        Session["dt_St_TSum"] = dt_portStaff;
                        if (dt_portStaff.Rows.Count > 0 && drpcompanylist.SelectedValue != "0")
                        {
                            string startdate = txtstartdate1.Text;
                            string enddate = txtenddate2.Text;
                            Session["startdate"] = startdate;
                            Session["enddate"] = enddate;


                            Response.Redirect("~/report1.aspx?comp=" + comp + "&timesheet=Staff" + "&pagename=StaffTimesheetSummary");
                        }
                        else
                        {
                            chkjob1.Checked = false;
                            MessageControl1.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                            drpcompanylist_SelectedIndexChanged(sender, e);
                        }
                    }
                    else
                    {
                        MessageControl1.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
                    }
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
        DateTime frmdate = new DateTime(1900, 1, 1);
        DateTime enddate = new DateTime(1900, 1, 1);
        String _dateFormat = "dd/MM/yyyy";
        if (txtstartdate1.Text.Trim() != "" && !DateTime.TryParseExact(txtstartdate1.Text.Trim(), _dateFormat, info,
                                                                                             DateTimeStyles.AllowWhiteSpaces, out frmdate))
        {
        }
        if (txtenddate2.Text.Trim() != "" && !DateTime.TryParseExact(txtenddate2.Text.Trim(), _dateFormat, info,
                                                                                              DateTimeStyles.AllowWhiteSpaces, out enddate))
        {
        }
        
        Session["frm_TSum"] = txtstartdate1.Text;
        Session["to_TSum"] = txtenddate2.Text;
        //string query = "select isnull(sum(convert(float,TotalTime)),0)as Hours,(isnull(sum(convert(float,TotalTime)),0)*"

        //                + " (select HourlyCharges from TimeSheet_Table where StaffCode='" + StfId + "'))as Charges,isnull(sum(convert(float,OpeAmt)),0)as OpeAmt,"

        //                + " ((isnull(sum(convert(float,TotalTime)),0)*(select HourlyCharges from TimeSheet_Table where StaffCode='" + StfId + "')))-(isnull(sum(convert(float,OpeAmt)),0))as Total"

        //                + " from dbo.TimeSheet_Table   where StaffCode='" + StfId + "' and Date>='" + frmdate + "' and Date<='" + enddate + "' having isnull(sum(convert(float,TotalTime)),0) >0.0";
        string query = "select isnull(sum(convert(float,TotalTime)),0)as Hours,(isnull(sum(convert(float,TotalTime)),0)* (isnull(dbo.Hours_Charges(StaffCode,Date),0)))as Charges,isnull(sum(convert(float,OpeAmt)),0)as OpeAmt, ((isnull(sum(convert(float,TotalTime)),0)* ( isnull(dbo.Hours_Charges(StaffCode,Date),0) )))+(isnull(sum(convert(float,OpeAmt)),0))as Total from dbo.TimeSheet_Table  where StaffCode='" + StfId + "' and Date>='" + frmdate + "' and Date<='" + enddate + "' group by StaffCode,Date   having isnull(sum(convert(float,TotalTime)),0) >0.0 ";
        DataTable dt = db.GetDataTable(query);
        if (dt.Rows.Count > 0)
        {
            decimal tottime = decimal.Parse(dt.Rows[0]["Hours"].ToString());
            decimal tottime1 = decimal.Parse(dt.Rows[0]["Charges"].ToString());
            decimal tottime2 = decimal.Parse(dt.Rows[0]["OpeAmt"].ToString());
            decimal tottime3 = decimal.Parse(dt.Rows[0]["Total"].ToString());
            timee += tottime;
            charge += tottime1;
            ope += tottime2;
            total += tottime3;
        }
        return dt;
    }
}
