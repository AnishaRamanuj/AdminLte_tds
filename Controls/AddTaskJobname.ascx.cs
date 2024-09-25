using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_AddTaskJobname : System.Web.UI.UserControl
{
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["companyid"] != null)
        {
            string Link_JobnTask = objDAL_PagePermissions.Dal_getTasknJobLinks(Convert.ToInt32(Session["companyid"]));
            hdnlink.Value = Link_JobnTask;
            Session["Taskid"] = 0;
            //ViewState["compid"] = Session["companyid"].ToString();
            hdnCompanyid.Value = Session["companyid"].ToString();
        }
        else
        {
            Response.Redirect("~/Default.aspx");
        }
    }
}