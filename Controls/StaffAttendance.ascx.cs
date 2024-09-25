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

public partial class controls_StaffAttendance : System.Web.UI.UserControl
{
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
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            //string dat = DateTime.Now.Month + "/" + DateTime.Now.Year;
            //txtenddate2.Text = dat; 
        }
      
       // txtenddate2.Attributes.Add("readonly", "readonly");
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                Session["URL"] = "Company/StaffAttendance.aspx";
            }
            else if (Session["staffid"] != null)
            {
                Session["URL"] = "staff/StaffAttendance.aspx";
            }
            if (ViewState["compid"] != null && hdnmonth.Value != "")
            {
                var dte = "";
                //Session["startdate"] = "01/" + txtenddate2.Text;
                string st = hdnmonth.Value;
                st ="01/" + st.Substring(5, 2) + "/" + st.Substring(0, 4);
                    
                Session["startdate"] =  st;
                Session["enddate"] = null;
                Response.Redirect("~/report_Staffattendance.aspx?comp=" + ViewState["compid"].ToString() + "&dt=" + hdnmonth.Value + "&stfatt=Staff" + "&pagename=StaffAttendance" + "&pagefolder=Staff",false);
            }
            else
            {
                MessageControl1.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
        }
    }
}
