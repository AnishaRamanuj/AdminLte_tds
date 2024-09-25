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

public partial class controls_Team_strengthnHours : System.Web.UI.UserControl
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
        }
    }

    protected void btngenexp_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                if (hdnJobid.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                else
                {
                    Session["compid"] = hdnCompid.Value;
                    Session["date"] = Convert.ToDateTime(hdnmonth.Value, info);
                    Session["Jobid"] = Convert.ToInt32(hdnJobid.Value);
                    Session["ProjectName"] = hdnProjectName.Value;
                    Response.Redirect("~/Company/Page_TeamStrenght.aspx", false);
                }
            }
            else
            {
                Response.Redirect("~/Company/Team_strengthnHours.aspx", false);
            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
        }
    }
}