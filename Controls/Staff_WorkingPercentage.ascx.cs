using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JTMSProject;
using System.Globalization;
using Microsoft.Reporting.WebForms;
using CommonLibrary;
using Microsoft.ApplicationBlocks1.Data;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class controls_Staff_WorkingPercentage : System.Web.UI.UserControl
{

    private readonly DBAccess db = new DBAccess();
    CultureInfo info = new CultureInfo("en-GB");
    LabelAccess objlabelAccess = new LabelAccess();
    List<tbl_LabelAccess> LtblAccess;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                hdnCompid.Value = Session["cltcomp"].ToString();
                ViewState["compid"] = Session["cltcomp"].ToString();
            }
            if (ViewState["compid"] != null)
            {
                DateTime date = DateTime.Now;
                DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

                txtFromdate.Text = firstDayOfMonth.ToString("dd/MM/yyyy");
                txtToDate.Text = lastDayOfMonth.ToString("dd/MM/yyyy");

            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            if (Session["Error"].ToString() != "")
            {
                MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
                Session["Error"] = "";
            }
        }
    }

    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                Session["departid"] = hdnselectedDeptid.Value.TrimEnd(',');
                Session["staffcode"] = hdnSelectedStaffCode.Value.TrimEnd(',');
                Session["strdate"] = txtFromdate.Text.Trim();
                Session["enddate"] = txtToDate.Text.Trim();

                if (hdnSelectedStaffCode.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one Staff !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                else
                {
                    Response.Redirect("~/Company/Report_Staff_WorkingPercentage.aspx", false);
                }
            }
            else
            {
                Response.Redirect("~/Company/Staff_WorkingPercentage.aspx", false);
            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("No Record Found", MessageDisplay.DisplayStyles.Error);
        }
    }
}