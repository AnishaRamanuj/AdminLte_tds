using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_Assign_Approver_Deptwise : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) {
            if (Session["companyid"].ToString() != null)
            {

                hdncompid.Value = Session["companyid"].ToString();

            }
            else {
                Response.Redirect("../default.aspx");
            }
        }
    }
}