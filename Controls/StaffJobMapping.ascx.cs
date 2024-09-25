using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using JTMSProject;
using CommonLibrary;

public partial class controls_StaffJobMapping : System.Web.UI.UserControl
{
    int pageid = 161;
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    private readonly DBAccess db = new DBAccess();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            hdnpageIndex.Value = "1";
            if (Session["companyid"] != null)
            {
                ViewState["compid"] = Session["companyid"].ToString();
                hdnCompany_id.Value = Session["companyid"].ToString();
               
            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["cltcomp"].ToString();
                hdnCompany_id.Value = Session["cltcomp"].ToString();
            }

            if (ViewState["compid"] != null)
            {
                Div8.Style.Value = "display:block";
                //bindGrd(1, 25);
                hdnIP.Value = Session["IP"].ToString();
                hdnName.Value = Session["fulname"].ToString();
                hdnUser.Value = Session["usertype"].ToString();   

            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

            string objL = objDAL_PagePermissions.Dal_getRolepermission(pageid, Convert.ToInt32(Session["UserRole"]), Convert.ToInt32(Session["companyid"]));

            hidpermission.Value = objL;



            bool a = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "add");
            if (a == false)
            { //btnAdd.Visible = false; 
            }
            bool edit = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "edit");
            if (edit == false)
            {
                hdnedit.Value = edit.ToString();
                thedit.Visible = false;

            }
            bool d = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "delete");
            if (d == false)
            {
                hdndelete.Value = d.ToString();
            //    thdelete.Visible = false;
            }

        }

        txtsearch.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
    }

}
