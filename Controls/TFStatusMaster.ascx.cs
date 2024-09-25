using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_TFStatusMaster : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                ViewState["compid"] = Session["companyid"].ToString();
                hdnCompanyid.Value = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["cltcomp"].ToString();
                hdnCompanyid.Value = Session["companyid"].ToString();

            }
            if (ViewState["compid"] != null)
            {

            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "MakeStaffSummaryFooterfff", "$(document).ready(function () { MakeSmartSearch();}); ", true);
        DateTime date = DateTime.Now;
        hdnUpdt.Value = date.ToString("dd/MM/yyyy");
    }
}