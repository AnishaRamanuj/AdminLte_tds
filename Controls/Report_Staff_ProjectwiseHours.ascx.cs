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

public partial class controls_Report_Staff_ProjectwiseHours : System.Web.UI.UserControl
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

                hdnFrom.Value = firstDayOfMonth.ToString("yyyy-MM-dd");
                hdnTo.Value = lastDayOfMonth.ToString("yyyy-MM-dd");

            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
    }

    protected void btngen_Click(object sender, EventArgs e)
    {
        Session["Tstatus"] = hdnTStatusCheck.Value;
        Session["Staffcode"] = hdnSelectedStaffCode.Value.TrimEnd(',');
        Session["Projectid"] = hdnselectedProjectid.Value.TrimEnd(',');
        Session["strdate"] = hdnFrom.Value;
        Session["enddate"] = hdnTo.Value;

        string rd = rdetailed.Checked.ToString();
        Session["rb"] = rd;

        if (hdnselectedProjectid.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
            return;
        }
        else
        {
            Response.Redirect("~/Company/ReportPage_Staff_ProjectwiseHours.aspx", false);
        }
    }
}