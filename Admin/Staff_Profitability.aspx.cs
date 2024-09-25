using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;
using System.Globalization;

public partial class Admin_Staff_Profitability : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    DataTable dt_portStaff = new DataTable();
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
            Session["URL"] = "Admin/Staff_Profitability.aspx";
            if (drpcompanylist.SelectedIndex != 0 && txtstartdate1.Text != "" && txtenddate2.Text != "")
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
                        if (dt_portStaff == null || dt_portStaff.Rows.Count == 0)
                        {
                            dt_portStaff.Columns.Add("StaffCode", System.Type.GetType("System.String"));
                            dt_portStaff.Columns.Add("StaffName", System.Type.GetType("System.String"));

                            dt_portStaff.Columns.Add("Hours", System.Type.GetType("System.String"));
                            dt_portStaff.Columns.Add("HourlyCharges", System.Type.GetType("System.String"));
                            dt_portStaff.Columns.Add("TotCharge", System.Type.GetType("System.String"));
                            dt_portStaff.Columns.Add("CurMonthSal", System.Type.GetType("System.String"));
                            dt_portStaff.Columns.Add("Difference", System.Type.GetType("System.String"));

                            DataRow dr = dt_portStaff.NewRow();
                            dr["StaffCode"] = Cid;
                            dr["StaffName"] = staff;

                            dr["Hours"] = dt.Rows[0]["Hours"].ToString();
                            dr["HourlyCharges"] = dt.Rows[0]["HourlyCharges"].ToString();
                            dr["TotCharge"] = dt.Rows[0]["TotCharge"].ToString();
                            dr["CurMonthSal"] = dt.Rows[0]["CurMonthSal"].ToString();
                            dr["Difference"] = dt.Rows[0]["Differ"].ToString();

                            dt_portStaff.Rows.Add(dr);
                            dt_portStaff.AcceptChanges();
                        }
                        else
                        {
                            DataRow dr = dt_portStaff.NewRow();
                            dr["StaffCode"] = Cid;
                            dr["StaffName"] = staff;

                            dr["Hours"] = dt.Rows[0]["Hours"].ToString();
                            dr["HourlyCharges"] = dt.Rows[0]["HourlyCharges"].ToString();
                            dr["TotCharge"] = dt.Rows[0]["TotCharge"].ToString();
                            dr["CurMonthSal"] = dt.Rows[0]["CurMonthSal"].ToString();
                            dr["Difference"] = dt.Rows[0]["Differ"].ToString();

                            dt_portStaff.Rows.Add(dr);
                            dt_portStaff.AcceptChanges();
                        }
                    }
                }
                Session["dt_portStaff"] = dt_portStaff;
                if (dt_portStaff.Rows.Count > 0)
                {
                    string startdate = txtstartdate1.Text;
                    string enddate = txtenddate2.Text;
                    Session["startdate"] = startdate;
                    Session["enddate"] = enddate;

                    Response.Redirect("~/report1.aspx?comp=" + comp + "&stfprof=prof" + "&pagename=SatffProfitability");
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

        Session["frm_prof"] = txtstartdate1.Text;
        Session["to_prof"] = txtenddate2.Text;
        string query = "select HourlyCharges,CurMonthSal,(select isnull(sum(convert(float,TotalTime)),0) from dbo.TimeSheet_Table "
                        + "  where StaffCode='" + StfId + "' and Date>='" + frmdate + "' and Date<='" + enddate + "')as Hours,"
                        + " (select isnull(sum(convert(float,TotalTime)),0) from dbo.TimeSheet_Table where StaffCode='" + StfId + "' and "
                        + " Date>='" + frmdate + "' and Date<='" + enddate + "')*HourlyCharges as TotCharge,"
                        + " case when (((select isnull(sum(convert(float,TotalTime)),0) from dbo.TimeSheet_Table"
                        + " where StaffCode='" + StfId + "' and Date>='" + frmdate + "' and Date<='" + enddate + "' )*HourlyCharges) -CurMonthSal )<0 then '0'"
                        + "else((select isnull(sum(convert(float,TotalTime)),0) from dbo.TimeSheet_Table where StaffCode='" + StfId + "'"
                        + "and Date>='" + frmdate + "' and Date<='" + enddate + "' )* HourlyCharges) -CurMonthSal end  as Differ"
                        + " from Staff_Master where StaffCode='" + StfId + "'";
        DataTable dt = db.GetDataTable(query);
        return dt;
    }
}
