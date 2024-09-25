using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_Invoice_page : System.Web.UI.UserControl
{
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
        }
        DateTime date = DateTime.Now;
        txtcurrentdt.Text = date.ToString("dd/MM/yyyy");
        //txtcurrentdt.Attributes.Add("readonly", "readonly");

        txtDuedt.Text = date.ToString("dd/MM/yyyy");
        txtDuedt.Attributes.Add("readonly", "readonly");

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