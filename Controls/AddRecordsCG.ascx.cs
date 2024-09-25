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

public partial class controls_AddRecordsCG : System.Web.UI.UserControl
{
    int pageid = 85;
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    private readonly DBAccess db = new DBAccess();
    private readonly ClientgroupMaster clntgrp = new ClientgroupMaster();

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

                Div14.Style.Value = "display:block";
                txtcgsearch.Focus();
                bindClientGroup();
                //Label18.Text = "Client Group";
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        //Txt2.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");


        string objL = objDAL_PagePermissions.Dal_getRolepermission(pageid, Convert.ToInt32(Session["UserRole"]), Convert.ToInt32(Session["companyid"]));

        hidpermission.Value = objL;



        bool a = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "add");
        if (a == false)
        { ImageCltg.Visible = false; }
        bool edit = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "edit");
        if (edit == false)
        {
            ((DataControlField)GridView7.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Edit"))
                .SingleOrDefault()).Visible = false;
        }
        bool d = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "delete");
        if (d == false)
        {
            ((DataControlField)GridView7.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Delete"))
                .SingleOrDefault()).Visible = false;

        }

    }

    public void displayblock(Boolean bln, Boolean bln1)
    {
        Div14.Style.Value = "display:none";
    }



    //protected void btnclientgrp_Click(object sender, EventArgs e)
    public void btnclientgrp()
    {
        try
        {
            if (ViewState["compid"] != null)
            {
                if (Txt2.Text != "")
                {
                    string str = "select ClientGroupName from dbo.ClientGroup_Master where ClientGroupName ='" + Txt2.Text.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {

                        clntgrp.CompId = int.Parse(ViewState["compid"].ToString());
                        clntgrp.id = 0;
                        clntgrp.ClientGroupName = Txt2.Text;
                        int res = clntgrp.Insert();
                        if (res == 1)
                        {
                            MessageControl8.SetMessage("Client Group Added Successfully", MessageDisplay.DisplayStyles.Success);
                            clearall();
                            ModalPopupExtender2.Hide();

                        }
                        else
                            MessageControl8.SetMessage("Error!!!Client Group not Added", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
                        MessageControl8.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl8.SetMessage("Please Enter a Client Group.", MessageDisplay.DisplayStyles.Error);
                }
                bindClientGroup();
                clearall();
            }
            else
            {
                MessageControl8.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }


    public SqlDataSource CTGClient
    {
        get { return SqlDataSource10; }
    }
    public void bindCTGClient()
    {
        if (string.IsNullOrEmpty(Convert.ToString(Session["cid"])) || Convert.ToString(Session["cid"]) == "0")
        {
            // CTGClient.SelectCommand = "select * from Client_Master where CompId='" + ViewState["compid"].ToString() + "' order by ClientName";
        }
        else
        {
            CTGClient.SelectCommand = "select * from Client_Master where CtgId='" + Session["cid"].ToString() + "' order by ClientName";
        }
        chk_dv = (DataView)CTGClient.Select(DataSourceSelectArguments.Empty);
        chk_dt = chk_dv.ToTable();
        int i = chk_dt.Rows.Count;
        GrdC.DataBind();
    }



    //clientgroup//
    public SqlDataSource ClientGroup
    {
        get { return SqlDataSource8; }
    }
    public void bindClientGroup()
    {
        try
        {
            int cid = 0;
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            ClientGroup.SelectCommand = "select * from ClientGroup_Master where CompId='" + ViewState["compid"].ToString() + "' order by ClientGroupName";

            chk_dv = (DataView)ClientGroup.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl8.SetMessage("No Client Group Added", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    cid = int.Parse(chk_dt.Rows[0]["CTGid"].ToString());
                }
                ModalPopupExtender2.Hide();
                searchcg.Style.Value = "display:block";
            }

            else
            {
                msghead.Style.Value = "display:block";
                searchcg.Style.Value = "display:none";

            }
            GridView7.DataBind();
            Session["cid"] = cid;
            bindCTGClient();

        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView7_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView7.PageIndex = e.NewPageIndex;
        bindClientGroup();
    }
    protected void GridView7_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "del")
            {
                DBAccess.PrintDelete(Session["IP"].ToString(), "Client Group Master", Session["fulname"].ToString(), Session["usertype"].ToString(), hdnDT.Value);
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int compid = int.Parse(GridView7.DataKeys[row.RowIndex].Value.ToString());
                //find staff for that desg


                string sql = "Select * from Client_Master where CTGId='" + compid + "'";
                DataTable dt = db.GetDataTable(sql);
                if (dt == null || dt.Rows.Count == 0)
                {
                    string StrSQL = "delete from dbo.ClientGroup_Master where CTGId='" + compid + "'";
                    int res = db.ExecuteCommand(StrSQL);
                    if (res == 1)
                    {
                        MessageControl8.SetMessage("ClientGroup Deleted Successfully", MessageDisplay.DisplayStyles.Info);
                    }
                    else
                    {
                        MessageControl8.SetMessage("ClientGroup Not Deleted ", MessageDisplay.DisplayStyles.Error);
                    }
                    ClientGroup.DeleteCommand = StrSQL;
                    bindClientGroup();
                }
                else
                {
                    //string StrSQL = "delete from dbo.ClientGroup_Master where CTGId='" + compid + "'";
                    //int res = db.ExecuteCommand(StrSQL);
                    //ClientGroup.DeleteCommand = StrSQL;
                    MessageControl8.SetMessage("Cannot delete ClientGroup, Client already exist", MessageDisplay.DisplayStyles.Error);
                    //bindClientGroup();
                }

            }
            if (e.CommandName == "view")
            {
                LinkButton btn = (LinkButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                Session["cid"] = int.Parse(GridView7.DataKeys[row.RowIndex].Value.ToString());
                bindCTGClient();

            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView7_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)GridView7.Rows[e.RowIndex].FindControl("TextBox3")).Text);
            string mainCatgId = ((Label)GridView7.Rows[e.RowIndex].FindControl("lblfid")).Text;

            string str = "select ClientGroupName from dbo.ClientGroup_Master where ClientGroupName ='" + maincattext.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {
                string StrSQL = "update ClientGroup_Master set  ClientGroupName='" + maincattext + "' where CTGId=" + mainCatgId;
                ClientGroup.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                GridView7.EditIndex = -1;
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl8.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            bindClientGroup();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView7_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView7.EditIndex = -1;
        bindClientGroup();
    }
    protected void GridView7_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView7.EditIndex = e.NewEditIndex;
        btnsearchcg_Click(sender, e);
        txtcgsearch.Text = "";
        //bindClientGroup();
    }

    public void clearall()
    {
        Txt2.Text = string.Empty;
    }


    protected void LinkCltg_Click(object sender, EventArgs e)
    {
        //Response.Redirect("AddRecords.aspx?cg=1&stt=new");
        Label33.Text = "Add Client Group";
        Label1.Text = "Client Group";
        Txt2.Focus();
        ModalPopupExtender2.Show();
    }







    protected void GridView7_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox3").Focus();
        }
    }



    protected void btnsearchcg_Click(object sender, EventArgs e)
    {
        string txtval = txtcgsearch.Text;
        ClientGroup.SelectCommand = "select * from ClientGroup_Master where ClientGroupName like '%" + txtval + "%' and CompId='" + ViewState["compid"].ToString() + "' order by ClientGroupName";
        chk_dv = (DataView)ClientGroup.Select(DataSourceSelectArguments.Empty);
        chk_dt = chk_dv.ToTable();
        if (chk_dt == null || chk_dt.Rows.Count == 0)
        {
            Session["cid"] = "-1";
        }

        GridView7.DataBind();
        bindCTGClient();
    }


    protected void BtnSubmit2_Click(object sender, EventArgs e)
    {
        btnclientgrp();
        ImageCltg.Focus();

    }
    protected void btnCancel2_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender2.Hide();
    }

    protected void GridView7_RowCreated(object sender, GridViewRowEventArgs e)
    {
        e.Row.Attributes.Add("onclick", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseover", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor=this.originalstyle;");
    }
    protected void GrdC_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GrdC.PageIndex = e.NewPageIndex;
        bindCTGClient();
    }
}
