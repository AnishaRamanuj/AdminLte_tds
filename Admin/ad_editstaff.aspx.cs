using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

public partial class Admin_ad_editstaff : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    private readonly StaffMaster staff = new StaffMaster();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["admin"] != null)
            {
                bindcomp();              
                bind_edit();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        txthourcharge.Attributes.Add("onkeyup", "return  ValidateText(this);");
        txtcursal.Attributes.Add("onkeyup", "return  ValidateText(this);");
        txtaddr1.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtaddr2.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtaddr3.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        //txtstaffname.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtmob.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtemail.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtstaffname.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txthourcharge.Attributes.Add("onkeyup", "return  ValidateText(this);");
        txtcursal.Attributes.Add("onkeyup", "return  ValidateText(this);");
        txtjoindate.Attributes.Add("readonly", "readonly");
        txtenddate.Attributes.Add("readonly", "readonly");
        txtstaffname.Focus();

    }
    public void binddept()
    {
        try
        {
            string ss = "select * from Department_Master where CompId='" + drpcompany.SelectedValue + "' order by DepartmentName";
            DataTable dt = db.GetDataTable(ss);
            drpdep.DataSource = dt;
            drpdep.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    public void binddesg()
    {
        try
        {
            string ss = "select * from Designation_Master where CompId='" + drpcompany.SelectedValue + "' order by DesignationName";
            DataTable dt = db.GetDataTable(ss);
            drpdesig.DataSource = dt;
            drpdesig.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    public void bindbranch()
    {
        try
        {
            string ss = "select * from Branch_Master where CompId='" + drpcompany.SelectedValue + "' order by BranchName";
            DataTable dt = db.GetDataTable(ss);
            drpbranch.DataSource = dt;
            drpbranch.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    public void bindcomp()
    {
        try
        {

            string ss = "select * from Company_Master order by CompanyName";
            DataTable dt = db.GetDataTable(ss);
            drpcompany.DataSource = dt;
            drpcompany.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    public void bindcharge()
    {
        try
        {
            string str = "select HourlyCharges from Designation_Master where DsgId='" + drpdesig.SelectedValue + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt.Rows.Count > 0 && dt != null)
            {
                string charge = dt.Rows[0]["HourlyCharges"].ToString();
                txthourcharge.Text = charge;
            }

        }
        catch (Exception ex)
        {

        }
    }
    public void bind_edit()
    {
        try
        {
            DataTable dt = new DataTable();
            string sqlqry = "select *,convert(nvarchar(20),DateOfJoining,103)as DateOfJoining1,convert(nvarchar(20),DateOfLeaving,103)as DateOfLeaving1 from Staff_Master where StaffCode='" + int.Parse(Session["stid"].ToString()) + "' order by StaffName";
            dt = db.GetDataTable(sqlqry);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    ViewState["Role"] = dt.Rows[0]["Role"].ToString();
                    ViewState["IsApproved"] = dt.Rows[0]["IsApproved"].ToString();
                    ViewState["UserId"] = dt.Rows[0]["UserId"].ToString();
                    if (drpcompany.Items.FindByValue(dt.Rows[0]["CompId"].ToString()) != null)
                    {
                        drpcompany.SelectedValue = dt.Rows[0]["CompId"].ToString();
                    }
                    else
                    {
                        drpcompany.SelectedValue = "1";

                    }
                    binddept();
                    binddesg();
                    bindbranch();
                    ViewState["cltid"] = dt.Rows[0]["CLTId"].ToString();
                    txtstaffname.Text = dt.Rows[0]["StaffName"].ToString();
                    if (drpdep.Items.FindByValue(dt.Rows[0]["DepId"].ToString()) != null)
                    {
                        drpdep.SelectedValue = dt.Rows[0]["DepId"].ToString();
                    }
                    else
                    {
                        drpdep.SelectedValue = "0";
                    }
                    if (drpdesig.Items.FindByValue(dt.Rows[0]["DsgId"].ToString()) != null)
                    {
                        drpdesig.SelectedValue = dt.Rows[0]["DsgId"].ToString();
                    }
                    else
                    {
                        drpdesig.SelectedValue = "0";
                    }
                    if (drpbranch.Items.FindByValue(dt.Rows[0]["BrId"].ToString()) != null)
                    {
                        drpbranch.SelectedValue = dt.Rows[0]["BrId"].ToString();
                    }
                    else
                    {
                        drpbranch.SelectedValue = "0";
                    }
                    string doj;
                    string dol;
                    if (dt.Rows[0]["DateOfJoining1"].ToString() != null && dt.Rows[0]["DateOfJoining1"].ToString() != "01/01/1900")
                    {
                        doj = dt.Rows[0]["DateOfJoining1"].ToString();
                    }
                    else
                    {
                        doj = "";
                    }
                    if (dt.Rows[0]["DateOfLeaving1"].ToString() != null && dt.Rows[0]["DateOfLeaving1"].ToString() != "01/01/1900")
                    {
                        dol = dt.Rows[0]["DateOfLeaving1"].ToString();
                    }
                    else
                    {
                        dol = "";
                    }
                    txtjoindate.Text = doj;
                    HiddenField1.Value = txtjoindate.Text;
                    txtenddate.Text = dol;
                    HiddenField2.Value = txtenddate.Text;
                    txthourcharge.Text = dt.Rows[0]["HourlyCharges"].ToString();
                    txtcursal.Text = dt.Rows[0]["CurMonthSal"].ToString();
                    txtusername.Text = dt.Rows[0]["username"].ToString();
                    lblpass.Text = dt.Rows[0]["password"].ToString();
                    txtemail.Text = dt.Rows[0]["Email"].ToString();
                    txtmob.Text = dt.Rows[0]["Mobile"].ToString();
                    txtcity.Text = dt.Rows[0]["City"].ToString();
                    txtaddr1.Text = dt.Rows[0]["Addr1"].ToString();
                    txtaddr2.Text = dt.Rows[0]["Addr2"].ToString();
                    txtaddr3.Text = dt.Rows[0]["Addr3"].ToString();


                }

            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void btncancel_Click(object sender, EventArgs e)
    {
        if (Session["admin"] != null)
        {
            Response.Redirect("ad_ManageStaff.aspx");
        }
    }
    protected void btnupdate_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["admin"] != null && ViewState["IsApproved"] != "")
            {
                if (drpdesig.SelectedValue != "0" && txtcursal.Text != "" && txthourcharge.Text != "" && txtstaffname.Text != "" && txtjoindate.Text != "" && drpcompany.SelectedValue != "0")
                {
                    if (emailValid(txtemail.Text))
                    {
                        staff.StaffCode = int.Parse(Session["stid"].ToString());
                        staff.StaffName = txtstaffname.Text;
                        staff.Addr1 = txtaddr1.Text;
                        staff.Addr2 = txtaddr2.Text;
                        staff.Addr3 = txtaddr3.Text;
                        staff.City = txtcity.Text;
                        staff.Email = txtemail.Text;
                        staff.Mobile = txtmob.Text;
                        staff.Role = ViewState["Role"].ToString();
                        staff.IsApproved = bool.Parse(ViewState["IsApproved"].ToString());
                        Guid uid = new Guid(ViewState["UserId"].ToString());
                        staff.UserId = uid;
                        CultureInfo info = new CultureInfo("en-US", false);
                        DateTime dob1 = new DateTime(1900, 1, 1);
                        DateTime Fdob1 = new DateTime(1900, 1, 1);
                        String _dateFormat = "dd/MM/yyyy";

                        if (txtjoindate.Text.Trim() != "" && !DateTime.TryParseExact(txtjoindate.Text.Trim(), _dateFormat, info,
                                                                                DateTimeStyles.AllowWhiteSpaces, out dob1))
                        {
                        }
                        if (txtenddate.Text.Trim() != "" && !DateTime.TryParseExact(txtenddate.Text.Trim(), _dateFormat, info,
                                                                              DateTimeStyles.AllowWhiteSpaces, out Fdob1))
                        {
                        }
                        DateTime dob = dob1.AddHours(23).AddMinutes(59).AddSeconds(59).AddMilliseconds(59);
                        DateTime Fdob = Fdob1.AddHours(23).AddMinutes(59).AddSeconds(59).AddMilliseconds(59);
                        if (dob > Fdob)
                        {
                            MessageControl1.SetMessage("Date of Joining must not be greater than Date of Leaving.", MessageDisplay.DisplayStyles.Error);
                        }
                        else
                        {
                            if (dob.ToString() != "1/1/1900 12:00:00 AM")
                            {
                                staff.DateOfJoining = dob;
                            }
                            else
                            {
                                staff.DateOfJoining = null;
                            }
                            if (Fdob.ToString() != "1/1/1900 12:00:00 AM")
                            {
                                staff.DateOfLeaving = Fdob;
                            }
                            else
                            {
                                staff.DateOfLeaving = null;
                            }
                            staff.CurMonthSal = float.Parse(txtcursal.Text);
                            staff.DepId = int.Parse(drpdep.SelectedValue);
                            staff.DsgId = int.Parse(drpdesig.SelectedValue);
                            staff.BrId = int.Parse(drpdesig.SelectedValue);
                            staff.CompId = int.Parse(drpcompany.SelectedValue);
                            staff.HourlyCharges = float.Parse(txthourcharge.Text);
                            staff.username = txtemail.Text;
                            staff.IsDeleted = false;
                            staff.CLTId = int.Parse(ViewState["cltid"].ToString());
                            staff.password = lblpass.Text.Trim();
                            int res = staff.Update();
                            if (res == 1)
                            {
                                //if (Session["admin"] != null)
                                //{
                                //    Response.Redirect("~/Admin/StaffDetails.aspx?id=" + Session["staffid"].ToString() + "&username=" + Session["staffname"].ToString());
                                //}
                                //else if (Session["clientid"] != null)
                                //{
                                Response.Redirect("ad_ManageStaff.aspx");
                                //}
                                MessageControl1.SetMessage("Staff Successfully Updated", MessageDisplay.DisplayStyles.Success);
                            }
                            else
                            {
                                MessageControl1.SetMessage("Error!!!Staff Updation not Completed.", MessageDisplay.DisplayStyles.Error);

                            }
                        }
                    }
                    else
                    {
                        MessageControl1.SetMessage("Invalid Username / Email", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl1.SetMessage("Mandatory Fields Must be Filled.", MessageDisplay.DisplayStyles.Error);

                }
            }
            else
            {
                MessageControl1.SetMessage("Error!!!Session Expired", MessageDisplay.DisplayStyles.Error);

            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        //bindclient();
        binddept();
        binddesg();
        bindbranch();
    }
    public bool emailValid(string email)
    {
        if (email != "")
        {
            string pattern = @"^[a-z][a-z|0-9|]*([_][a-z|0-9]+)*([.][a-z|0-9]+([_][a-z|0-9]+)*)?@[a-z][a-z|0-9|]*\.([a-z][a-z|0-9]*(\.[a-z][a-z|0-9]*)?)$";


            System.Text.RegularExpressions.Match match = Regex.Match(email.Trim(), pattern, RegexOptions.IgnoreCase);
            if (match.Success)
            {
                //string b = "true";
                //return b;
                return true;
            }
            else
            {
                //string b = "false";
                //return b;
                return false;
            }
        }
        else
        {
            return true;
        }
    }

    protected void drpdesig_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindcharge();
        UpdatePanel1.Update();
    }
}
