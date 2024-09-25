using JTMSProject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_Department_Budgeting : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                hdncompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
            if (ViewState["compid"] != null)
            {
                hdnIP.Value = Session["IP"].ToString();
                hdnName.Value = Session["fulname"].ToString();
                hdnUser.Value = Session["usertype"].ToString();

            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

        }
    }
}