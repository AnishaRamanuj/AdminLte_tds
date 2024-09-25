using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_Project_Budgeting_Edit : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
    }
}