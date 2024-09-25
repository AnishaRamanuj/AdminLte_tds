using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;

public partial class controls_ProjectApprover : System.Web.UI.UserControl
{
    CultureInfo info = new CultureInfo("en-GB");
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                string comp = Session["companyid"].ToString();
                hdnCompanyID.Value = Session["companyid"].ToString();

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
            /////set Current week start and end date for staff summary
            DateTime date = DateTime.Now;

            DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
            DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

        
                hdnFrom.Value = firstDayOfMonth.ToString("yyyy-MM-dd");
                hdnTo.Value = lastDayOfMonth.ToString("yyyy-MM-dd");
            
          
        }

    }

    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                //string Date1 = txtdateBindStaff.Text;
                //string[] date = Date1.Split('-');
            
                string start = hdnFrom.Value != "" ? Convert.ToDateTime(hdnFrom.Value, info).ToString("MM/dd/yyyy") : null;
                string end = hdnTo.Value != "" ? Convert.ToDateTime(hdnTo.Value, info).ToString("MM/dd/yyyy") : null;

                hdnCompanyID.Value = Session["companyid"].ToString();
                Session["Tstatus"] = hdnTStatusCheck.Value;
                Session["projectid"] = hdnselectedProject.Value.TrimEnd(',');
                Session["stfid"] = hdnselectedStaff.Value.TrimEnd(',');
                Session["strdate"] = start;
                Session["enddate"] = end;
                Session["fulldate"] = start + '-' + end;
                string rd = rdetailed.Checked.ToString();
                Session["rb"] = rd;

                if (hdnselectedStaff.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one Staff !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                else
                {
                    Response.Redirect("~/Company/ProjectApprover_Report.aspx", false);
                }
            }
            else
            {
                Response.Redirect("~/Company/ProjectApprover.aspx", false);
            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
        }
    }
}