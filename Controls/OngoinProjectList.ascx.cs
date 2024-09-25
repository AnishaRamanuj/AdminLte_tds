using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Globalization;
using System.Data;
using Microsoft.Reporting.WebForms;
using System.Text;

public partial class controls_OngoinProjectList : System.Web.UI.UserControl
{
    LabelAccess objlabelAccess = new LabelAccess();
    List<CommonLibrary.tbl_LabelAccess> LtblAccess;
    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    string UserType = "";
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
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            DateTime date = DateTime.Now;

            DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
            DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

            hdnFrom.Value = firstDayOfMonth.ToString("yyyy-MM-dd");
            hdnTo.Value = lastDayOfMonth.ToString("yyyy-MM-dd");
        }
        

        if (Session["Error"].ToString() != "")
        {
            MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
            Session["Error"] = "";
        }

    }

    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                Session["selectedprojectid"] = hdnSelectedProjectid.Value;
                Session["frdate"] = hdnFrom.Value.Trim();
                Session["todate"] = hdnTo.Value.Trim();

                if (hdnSelectedProjectid.Value == "")
                {
                    MessageControl1.SetMessage("Please Select At Least One Project..", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    Response.Redirect("~/Company/OngoingProjectDetails_rpt.aspx", false);
                }
            }
            else
            {
                Response.Redirect("~/Company/OngoingProjectList.aspx", false);
            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
        }
    }
}