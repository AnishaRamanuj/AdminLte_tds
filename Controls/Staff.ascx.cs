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


public partial class controls_Staff : System.Web.UI.UserControl
{

    private readonly DBAccess db = new DBAccess();
    private readonly BranchMaster br = new BranchMaster();

    DataView chk_dv;
    DataTable chk_dt;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            if (Session["companyid"] != null)
            {
                ViewState["compid"] = Session["companyid"].ToString();
                hdnCompid.Value = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["cltcomp"].ToString();
            }

            if (ViewState["compid"] != null)
            {

                Div4.Style.Value = "display:block";
                txtsearch.Focus();
                //bindStaff();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        txtsearch.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
    }

    public void displayblock(Boolean bln, Boolean bln1)
    {
        Div4.Style.Value = "display:none";
    }
    
}
