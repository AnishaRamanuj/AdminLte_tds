using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.ApplicationBlocks1.Data;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;
using System.Web.Services.Protocols;
using DataAccessLayer;
using CommonLibrary;
using System.Web.Script.Serialization;
using System.Globalization;
using JTMSProject;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.IO;
using System.Drawing;

public partial class controls_ManageTask : System.Web.UI.UserControl
{

    //SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    int pagesize = 25;
    int pageid = 160;
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                string Link_JobnTask = objDAL_PagePermissions.Dal_getLinks(Convert.ToInt32(Session["companyid"]));
                hdnlink.Value = Link_JobnTask;
                Session["Taskid"] = 0;
                ViewState["compid"] = Session["companyid"].ToString();
                hdnCompanyid.Value = ViewState["compid"].ToString();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            //if (hdnlink.Value == "1")
            //{
            //    td_jobnames.Visible = true;

            //    gettask(1, pagesize);
                
            //}
            //else
            //{
            //    gettask(1, pagesize);
            //    td_jobnames.Style.Add("width", "0");
            //    td_jobnames.Visible = false;
            //}
            //Session["Taskid"] = 0;
            //gettask(1, pagesize);

            string objL = objDAL_PagePermissions.Dal_getRolepermission(pageid, Convert.ToInt32(Session["UserRole"]), Convert.ToInt32(Session["companyid"]));

            hidpermission.Value = objL;



            bool a = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "add");
            if (a == false)
            { btnadd.Visible = false; }
            bool edit = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "edit");
            //if (edit == false)
            //{
            //    ((DataControlField)gv_task.Columns
            //        .Cast<DataControlField>()
            //        .Where(fld => (fld.HeaderText == "Edit"))
            //        .SingleOrDefault()).Visible = false;
            //}
            //bool d = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "delete");
            //if (d == false)
            //{
            //    ((DataControlField)gv_task.Columns
            //        .Cast<DataControlField>()
            //        .Where(fld => (fld.HeaderText == "Delete"))
            //        .SingleOrDefault()).Visible = false;

            //}

        }
    }

 
}