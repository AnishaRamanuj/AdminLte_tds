using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml.Linq;
using JTMSProject;



public partial class Admin_MasterPage : System.Web.UI.MasterPage
{
    DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session["admin"] != null)
            {
                //bindhome();
                lblSession.Text = "Welcome " + Session["admin"].ToString();

                string ss = "select convert(varchar,getdate(),107) as date";
                DataTable dt = db.GetDataTable(ss);
                Label1.Text = dt.Rows[0]["date"].ToString();

            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "modalganeshkohide", "Hideloaderfromcode();", true);
    }
    protected void lnklogin_Click(object sender, EventArgs e)
    {
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
