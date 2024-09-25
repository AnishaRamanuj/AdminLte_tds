using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_StaffAttendance : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["admin"] != null)
        {
            if (!IsPostBack)
            {
                string dat = DateTime.Now.Month + "/" + DateTime.Now.Year;
                txtenddate2.Text = dat; 

            }
        }
        txtenddate2.Attributes.Add("onblur", "checkForm();");
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/StaffAttendance.aspx";
            if (drpcompanylist.SelectedIndex != 0 && txtenddate2.Text != "")
            {
                Response.Redirect("~/report1.aspx?comp=" + drpcompanylist.SelectedValue + "&dt=" + txtenddate2.Text + "&stfatt=Staff" + "&pagename=StaffAttendance");
                //Response.Redirect("StaffAttendance_Report.aspx?comp=" + drpcompanylist.SelectedValue + "&stfatt=Staff" + "&&dt=" + txtenddate2.Text + "");
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
}
