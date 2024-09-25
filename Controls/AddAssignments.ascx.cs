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
public partial class controls_AddAssignments : System.Web.UI.UserControl
{
    int pageid = 161;
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    private readonly DBAccess db = new DBAccess();    
    private AllAssignments obj = new AllAssignments();
    Assignments tbl = new Assignments();
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
                //hdnIP.Value = Session["IP"].ToString();
                hdnName.Value = Session["fulname"].ToString();
                hdnUser.Value = Session["usertype"].ToString();
                //bindGrd(1, 25);
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

            txtsearch.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
            Txt2.Attributes.Add("onkeyup", "CountFrmTitle(this,40);");
            string objL = objDAL_PagePermissions.Dal_getRolepermission(pageid, Convert.ToInt32(Session["UserRole"]), Convert.ToInt32(Session["companyid"]));

            hidpermission.Value = objL;
            bool a = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "add");
            if (a == false)
            { btnAdd.Visible = false; }
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
                thdelete.Visible = false;
            }

        }
    }

}

    //public void bindGrd(int PgIndex, int PgSize)
    //{
    //    BtnPrevious.Visible = true;
    //    BtnNext.Visible = true;
    //    tbl.CompID = Convert.ToInt32(hdnCompany_id.Value);
    //    tbl.pageIndex = PgIndex;
    //    tbl.pageNewSize = PgSize;
    //    tbl.Srch = txtsearch.Text; 
    //    DataSet ds ;
    //    ds = obj.GetAssignments(tbl);
    //    Grd.DataSource = ds.Tables[0] ;
    //    Grd.DataBind();

    //    int totalCount = Convert.ToInt32(ds.Tables[1].Rows[0]["Assign_Name"].ToString()) ;
    //    if (totalCount > 0)
    //    {
    //        double totalPages = totalCount / PgSize;
    //        Math.Round((decimal)totalPages, 0);
    //        CurrentPageIndex.Value = PgIndex + "," + totalPages;
    //        int iRow = ds.Tables[0].Rows.Count-1;
    //        if (iRow == -1)
    //        {
    //            BtnNext.Visible = false;
    //            BtnPrevious.Visible = false;
    //            lblTotalRecords.Text = "0 entries.";
    //        }
    //        else
    //        {
    //            if (Convert.ToInt32(ds.Tables[0].Rows[iRow]["SiNo"]) == totalCount)
    //            { BtnNext.Visible = false; }

    //            if (Convert.ToInt32(ds.Tables[0].Rows[0]["SiNo"]) == 1)
    //            { BtnPrevious.Visible = false; }
    //            lblTotalRecords.Text = "Showing " + ds.Tables[0].Rows[0]["SiNo"] + " to " + ds.Tables[0].Rows[iRow]["SiNo"] + " of " + totalCount + " entries.";
    //        }
        
    //    }
    //    else
    //    {
    //        lblTotalRecords.Text = "";
    //        BtnPrevious.Visible = false;
    //        BtnNext.Visible = false;
    //    }
    //}
    
    //protected void btnAsearch_Click(object sender, EventArgs e)
    //{
    //    bindGrd(1, 25);
    //}


//}