using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_Receipt_page : System.Web.UI.UserControl
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
       
    }
}