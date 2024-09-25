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

public partial class controls_ReportProjectWiseStaffExpense : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    CultureInfo info = new CultureInfo("en-GB");
    LabelAccess objlabelAccess = new LabelAccess();
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;
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
            if (Session["Error"].ToString() != "")
            {
                MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
                Session["Error"] = "";
            }
        }
    }

    protected void btngenerate_Click(object sender, EventArgs e)
    {
        try

        {
            hdnCompid.Value = Session["companyid"].ToString();
            Session["Tstatus"] = hdnTStatusCheck.Value;
            Session["projectid"] = hdnSelectedProjectid.Value.TrimEnd(',');
            Session["clientid"] = hdnselectedstaff.Value.TrimEnd(',');
            Session["strdate"] = hdnFrom.Value.Trim();
            Session["enddate"] = hdnTo.Value.Trim();
            Session["rsummery"] = rsummary.Checked;
            //if (rdetailed.Checked)
            //{
                if (Session["companyid"] != null)
                {
                   

                    if (hdnSelectedProjectid.Value == "")
                    {
                        MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
                        return;
                    }
                    else if (hdnselectedstaff.Value == "")
                    {
                        MessageControl1.SetMessage("Please select at least one Staff !", MessageDisplay.DisplayStyles.Error);
                        return;
                    }

                    else
                    {
                        Response.Redirect("~/Company/Report_ProjectWiseStaffExpenseSummerise.aspx", false);
                    }
                }
                else
                {
                    Response.Redirect("~/Company/ReportProjectWiseStaffExpense.aspx", false);
                }

            
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
        }
    }
}