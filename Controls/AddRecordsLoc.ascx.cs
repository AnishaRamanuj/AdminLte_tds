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


public partial class controls_AddRecordsLoc : System.Web.UI.UserControl
{
    int pageid=88;
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    private readonly DBAccess db = new DBAccess();
    private readonly LocationMaster loc = new LocationMaster();

    DataView chk_dv;
    DataTable chk_dt;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            if (Session["companyid"] != null)
            {
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["cltcomp"].ToString();
            }

            if (ViewState["compid"] != null)
            {

                    Div8.Style.Value = "display:block";
                    txtlocsearch.Focus();
                    bindLocation();
                    //Label18.Text = "Location";

            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        Txt2.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");


        string objL = objDAL_PagePermissions.Dal_getRolepermission(pageid, Convert.ToInt32(Session["UserRole"]), Convert.ToInt32(Session["companyid"]));

        hidpermission.Value = objL;



        bool a = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "add");
        if (a == false)
        { Button4.Visible = false; }
        bool edit = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "edit");
        if (edit == false)
        {
            ((DataControlField)GridView4.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Edit"))
                .SingleOrDefault()).Visible = false;
        }
        bool d = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "delete");
        if (d == false)
        {
            ((DataControlField)GridView4.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Delete"))
                .SingleOrDefault()).Visible = false;

        }



    }

    public void displayblock(Boolean bln, Boolean bln1)
    {

        Div8.Style.Value = "display:none";
    }

 
    //protected void btnlocation_Click(object sender, EventArgs e)
    public void btnlocation()
    {
        try
        {
            if (ViewState["compid"] != null)
            {
                if (Txt2.Text != "")
                {
                    string str = "select LocationName from dbo.Location_Master where LocationName ='" + Txt2.Text.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {

                        loc.CompId = int.Parse(ViewState["compid"].ToString());
                        loc.id = 0;
                        loc.LocationName = Txt2.Text;
                        int res = loc.Insert();
                        if (res == 1)
                        {
                            MessageControl5.SetMessage("Location Added Successfully", MessageDisplay.DisplayStyles.Success);
                            clearall();
                            ModalPopupExtender2.Hide();
                        }
                        else
                            MessageControl5.SetMessage("Error!!!Location not Added", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
                        MessageControl5.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl5.SetMessage("Please Enter a Location.", MessageDisplay.DisplayStyles.Error);
                }
                bindLocation();
                clearall();
            }
            else
            {
                MessageControl5.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }
 
    //location//
    public SqlDataSource Location
    {
        get { return SqlDataSource5; }
    }
    public void bindLocation()
    {
        try
        {
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            Location.SelectCommand = "select * from Location_Master where CompId='" + ViewState["compid"].ToString() + "' order by LocationName";

            chk_dv = (DataView)Location.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl5.SetMessage("No Location Added", MessageDisplay.DisplayStyles.Error);

                }

                ModalPopupExtender2.Hide(); 
                searchloc.Style.Value = "display:block";
            }
            //if (add_lctn.Style.Value == "display:none")
            //{
            //    msghead4.Style.Value = "display:none";
            //    searchloc.Style.Value = "display:block";

            //}
            //else if (add_lctn.Style.Value == null || add_lctn.Style.Value == "display:block")
            //{
            //    msghead4.Style.Value = "display:block";
            //    searchloc.Style.Value = "display:none";

            //}
            else
            {
                msghead.Style.Value = "display:block";
                searchloc.Style.Value = "display:none";
            }
            GridView4.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView4_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView4.PageIndex = e.NewPageIndex;
        bindLocation();
    }
    protected void GridView4_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "delete")
            {
                DBAccess.PrintDelete(Session["IP"].ToString(), "Location Master", Session["fulname"].ToString(), Session["usertype"].ToString(), hdnDT.Value);
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int compid = int.Parse(GridView4.DataKeys[row.RowIndex].Value.ToString());
                //find staff for that desg
                string sql = "Select * from Timesheet_Table where LocId='" + compid + "'";
                DataTable dt = db.GetDataTable(sql);
                if (dt == null || dt.Rows.Count == 0)
                {
                    string StrSQL = "delete from dbo.Location_Master where LocId='" + compid + "'";
                    int res = db.ExecuteCommand(StrSQL);
                    if (res == 1)
                    {
                        MessageControl5.SetMessage("Location Deleted Successfully", MessageDisplay.DisplayStyles.Info);
                    }
                    else
                    {
                        MessageControl5.SetMessage("Location Not Deleted", MessageDisplay.DisplayStyles.Error);
                    }
                    Location.DeleteCommand = StrSQL;
                    bindLocation();
                }
                else
                {
                    string StrSQL = "delete from dbo.Location_Master where LocId='0'";
                    int res = db.ExecuteCommand(StrSQL);
                    Location.DeleteCommand = StrSQL;
                    MessageControl5.SetMessage("Cannot delete Location, Timesheet exist", MessageDisplay.DisplayStyles.Error);
                    bindLocation();
                }
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView4_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView4.EditIndex = e.NewEditIndex;
        btnlocsearch_Click(sender, e);
        txtlocsearch.Text = "";
        //bindLocation();
    }
    protected void GridView4_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView4.EditIndex = -1;
        bindLocation();
    }
    protected void GridView4_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)GridView4.Rows[e.RowIndex].FindControl("TextBox3")).Text);
            string mainCatgId = ((Label)GridView4.Rows[e.RowIndex].FindControl("lblfid")).Text;

            string str = "select LocationName from dbo.Location_Master where LocationName ='" + maincattext.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {
                string StrSQL = "update Location_Master set  LocationName='" + maincattext + "' where LocId=" + mainCatgId;
                Location.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                GridView4.EditIndex = -1;
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl5.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            bindLocation();
        }
        catch (Exception ex)
        {

        }
    }

 

    public void clearall()
    {
       Txt2.Text = string.Empty;
    }


 
    //protected void LinkLocatn_Click(object sender, EventArgs e)
    //{
    //    //Response.Redirect("AddRecords.aspx?loc=1&stt=new");
    //    //Label33.Text = "Add Location";
    //    //Label1.Text = "Location";

    //    ModalPopupExtender2.Show();
    //}
  

    protected void GridView4_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox3").Focus();
        }
    }

    protected void btnlocsearch_Click(object sender, EventArgs e)
    {
        string txtval = txtlocsearch.Text;
        Location.SelectCommand = "select * from Location_Master where LocationName like '%" + txtval + "%' and CompId='" + ViewState["compid"].ToString() + "' order by LocationName";
        GridView4.DataBind();

    }
  
 
    protected void Button4_Click(object sender, EventArgs e)
    {
        Txt2.Focus();
        ModalPopupExtender2.Show();
    }
    protected void BtnSubmit2_Click(object sender, EventArgs e)
    {
        btnlocation();
        Button4.Focus();
        
    }
    protected void btnCancel2_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender2.Hide();

    }
    protected void BtnClose2_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender2.Hide();

    }

    protected void GridView4_RowCreated(object sender, GridViewRowEventArgs e)
    {
        e.Row.Attributes.Add("onclick", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseover", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor=this.originalstyle;");
    }
}
