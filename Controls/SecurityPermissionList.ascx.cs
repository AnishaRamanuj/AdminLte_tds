using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_SecurityPermissionList : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
   
    protected void Grid_Permissions_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "edit")
            {
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                Label CompIdlbl = (Label)row.FindControl("CompIdlbl");
                string compid = CompIdlbl.Text;
                Response.Redirect("ManageSecurityPermission.aspx?compid=" + compid + "");
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void Button1_Click(object sender, ImageClickEventArgs e)
    {

    }
}
