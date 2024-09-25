using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using JTMSProject;
using System.Data;
using System.Web.UI.WebControls;

public partial class Admin_AdminMaster : System.Web.UI.MasterPage
{
    DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            try
            {
                this.Page.Form.DefaultButton = lblSession.UniqueID;
                if (Session["admin"] != null)
                {
                    string Amenu= "<div id='ddtopmenubar' class='mattblackmenu'><ul><li><a href='AdminHome.aspx'>Home</a></li><li><a href='#' rel='productmenu1'>Masters</a></li><li><a href='#' rel='productmenu4'>Utility</a></li></ul><ul id='productmenu1' class='ddsubmenustyle'><li><a href='AddRecords.aspx?desig=1'>Designation</a></li><li><a href='AddRecords.aspx?dep=1'>Department</a></li><li><a href='AddRecords.aspx?br=1'>Branch</a></li><li><a href='ad_ManageStaff.aspx?part=1'>Partner/Staff</a></li><li><a href='ad_Manageclient.aspx?cl=1'>Client</a></li><li><a href='ad_Managejob.aspx?job=1'>Job</a></li><li><a href='AddRecords.aspx?ope=1'>Ope</a></li><li><a href='AddRecords.aspx?loc=1'>Location</a></li><li><a href='AddRecords.aspx?nar=1'>Narration</a></li><li><a href='AddRecords.aspx?jg=1'>Job Group</a></li><li><a href='AddRecords.aspx?cg=1'>Client Group</a></li></ul><ul id='productmenu4' class='ddsubmenustyle'><li><a href='MangePageLinks.aspx'>Manage Pages</a> </li><li><a href='Admin_Password.aspx'>Change Password</a></li><li><a href='ManageSecurityPermission.aspx'>Manage Security Permission</a></li><li><a href='SecurityPermissionList.aspx'>Security PermissionList</a></li><li><a href='pagemenumaster.aspx'>Add New ASPX Pages</a></li><li><a href='MenuGroupMaster.aspx'>Add New Group For Menu</a></li><li><a href='superAdmincompanypagesright.aspx'>Manage Permission</a></li></ul>";
                    LiteralMainMenu.Text = Amenu;
                    ////bindhome();
                    //lblSession.Text = "Welcome " + Session["admin"].ToString();

                    //string ss = "select convert(varchar,getdate(),107) as date";
                    //DataTable dt = db.GetDataTable(ss);
                    //Label1.Text = dt.Rows[0]["date"].ToString();

                }
                else
                {
                    Response.Redirect("~/Default.aspx");
                }
            }
            catch (Exception ex)
            {

            }
        }
    }
    protected void lnklogin_Click(object sender, EventArgs e)
    {        HttpContext.Current.Response.Cookies.Add(new HttpCookie("tmxuserInfo", ""));
        if (Session["admin"] != null)
        {
            Session.Abandon();
            Session["admin"] = null;
            Response.Redirect("~/Default.aspx");
        }
        else
        {
            Response.Redirect("~/Default.aspx");
        }
    }
    protected void lblSession_Click(object sender, EventArgs e)
    {
        Response.Redirect("AdminHome.aspx");
    }
}
