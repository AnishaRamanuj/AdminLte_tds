using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;

public partial class controls_Project_Jsr : System.Web.UI.UserControl
{
    CultureInfo info = new CultureInfo("en-GB");
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                string comp = Session["companyid"].ToString();
                //hdnCompanyID.Value = Session["companyid"].ToString();

            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

            if (Session["Error"].ToString() != "")
            {
                MessageControl1.SetMessage("No Record Found", MessageDisplay.DisplayStyles.Error);
                Session["Error"] = "";
            }
 
            //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "MakeStaffSummaryFooterfff", "$(document).ready(function () { MakeSmartSearch();}); ", true);
        }

    }

    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {

                //hdnCompanyID.Value = Session["companyid"].ToString();
                Session["Tstatus"] = hdnTStatusCheck.Value;
                Session["projectid"] = hdnselectedProject.Value.TrimEnd(',');
                string rd = rdetailed.Checked.ToString();
                Session["rb"] = rd;

                if (hdnselectedProject.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                else
                {
                    Response.Redirect("~/Company/Project_Jsr_Report.aspx", false);
                }
            }
            else
            {
                Response.Redirect("~/Company/Project_Jsr.aspx", false);
            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
        }
    }
}