using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_Expired_ProjectJob : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {


            if (Session["companyid"] != null)
            {
        
                ViewState["compid"] = Session["companyid"].ToString();
                hdnCompanyid.Value = ViewState["compid"].ToString();
    

            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["Companyid"].ToString();
                hdnCompanyid.Value = ViewState["compid"].ToString();
                hdnDept.Value = Session["deptwise"].ToString();
            }

            if (ViewState["compid"] != null)
            {
                ViewState["compid"] = Session["Companyid"].ToString();
                hdnCompanyid.Value = ViewState["compid"].ToString();
                hdnDept.Value = Session["deptwise"].ToString();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        DateTime date = DateTime.Now;

        DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
        DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);
        if (txtfrom.Text == "" || txtto.Text == "")
        {
            txtfrom.Text = firstDayOfMonth.ToString("dd/MM/yyyy");
            txtto.Text = lastDayOfMonth.ToString("dd/MM/yyyy");
            txtfrom.Attributes.Add("readonly", "readonly");
            txtto.Attributes.Add("readonly", "readonly");
        }
    }
}