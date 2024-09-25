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

public partial class Admin_MangePageLinks : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrid();

        }
        if (IsPostBack || DropDownList1.Items.Count <= 0) return;
        DropDownList1.SelectedIndex = 0;
        DropDownList1_SelectedIndexChanged(new object(), new EventArgs());
    }
    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGrid();
    }
    public void BindGrid()
    {
        //const string strSlect =
        //    "select fid,fpage_name,fpage_description,fpage_link,fpage_type,fpage_data,case factive when 1 then 'Active' when 0 then 'Inactive' end as factive, language  from  page_master where  fpage_type not  in (select fid from dropdowndata where fvalue='Page Link') and client_master is null order by position";
        //SQLPages.SelectCommand = strSlect;
        //SQLPages.DataBind();
     dtMasterPages.DataBind();
     UpdatePanel1.Update();
    }

    public void ShowSubpages(object sender, EventArgs e)
    {
        try
        {
            ImageButton ImgEdit = sender as ImageButton;
            if (ImgEdit == null) return;
            GridViewRow row = (GridViewRow)ImgEdit.NamingContainer;
            string Id = dtMasterPages.DataKeys[row.RowIndex] as string;
            Response.Redirect("subpage.aspx?id=" + db.EncryptData(Id));
        }
        catch (Exception ex)
        {

        }
    }

    protected void lnkManage_Click(object sender, EventArgs e)
    {
        mltItems.ActiveViewIndex = 1;
        BindGrid();
        lbl_msg.Text = "";
    }

    protected void lnkAdd_Click(object sender, EventArgs e)
    {
        lblPageMasterID.Text = "";
        mltItems.ActiveViewIndex = 0;
        Txt_Title.Text = "";
        Item_ID.Value = "";
        lbl_msg.Text = "";
    }

    protected void lnkManage_Click(object sender, ImageClickEventArgs e)
    {
        mltItems.ActiveViewIndex = 1;
        BindGrid();
        lbl_msg.Text = "";
    }

    protected void ImgAddItem_Click(object sender, ImageClickEventArgs e)
    {
        mltItems.ActiveViewIndex = 0;
        Txt_Title.Text = "";
        Item_ID.Value = "";
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
        Response.Redirect("website_management.aspx");
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            int pageMasterID;
            int roleID;
            int.TryParse(DropDownList1.SelectedValue, out roleID);

            // if sub page is adding or updating
            if (int.TryParse(lblPageMasterID.Text, out pageMasterID))
            {
                int subpageid;
                int.TryParse(Item_ID.Value, out subpageid);
                Subpage subpage = subpageid > 0 ? new Subpage(subpageid) : new Subpage();
                subpage.PageTitle = Txt_Title.Text;
                subpage.PageName = Txt_Link.Text;
                subpage.MasterPageID = pageMasterID;
                subpage.ModifiedDate = DateTime.Now;
                subpage.Status = roleID;
                int i = subpageid > 0 ? subpage.Update() : subpage.Insert();
            }
            // admin is adding new main page
            else
            {
                int pageid;
                int.TryParse(Item_ID.Value, out pageid);

                MasterPages masterPages = pageid > 0 ? new MasterPages(pageid) : new MasterPages();
                masterPages.PageTitle = Txt_Title.Text;
                masterPages.PageName = Txt_Link.Text;
                masterPages.ModifiedDate = DateTime.Now;
                masterPages.Status = roleID;
                masterPages.PageOrder = 0;
                int i = pageid > 0 ? masterPages.Update() : masterPages.Insert();
            }
            Txt_Title.Text = "";
            Txt_Link.Text = "";
        }
        catch (Exception ex)
        {
            DBAccess.PrintError(ex, "");
            lbl_msg.Text = "Could not save Menu Details";
        }
        dtMasterPages.DataBind();

        Item_ID.Value = null;
        lblPageMasterID.Text = string.Empty;

        mltItems.SetActiveView(vwManage);
    }

    protected void ShowEdit(object sender, ImageClickEventArgs e)
    {
        try
        {
            ImageButton ImgEdit = sender as ImageButton;
            if (ImgEdit != null)
            {
                DataListItem row = ImgEdit.NamingContainer as DataListItem;
                if (row != null)
                {
                    int Id;
                    if (int.TryParse(dtMasterPages.DataKeys[row.ItemIndex].ToString(), out Id))
                    {
                        MasterPages masterPages = new MasterPages(Id);
                        Txt_Title.Text = masterPages.PageTitle;
                        Txt_Link.Text = masterPages.PageName;
                        Item_ID.Value = Id.ToString();
                        mltItems.ActiveViewIndex = 0;
                    }
                    else
                    {
                        lbl_msg.Text = "Could not load item";
                    }
                }
            }
        }
        catch (Exception ex)
        {
            DBAccess.PrintError(ex, "");
            lbl_msg.Text = "Could not load item";
        }
    }

    protected void ShowDelete(object sender, ImageClickEventArgs e)
    {
        try
        {
            ImageButton ImgEdit = sender as ImageButton;
            if (ImgEdit != null)
            {
                DataListItem row = ImgEdit.NamingContainer as DataListItem;

                int Id = 0;
                if (row != null)
                    if (int.TryParse(dtMasterPages.DataKeys[row.ItemIndex].ToString(), out Id))
                    {
                        //string strUpdate = "update page_master set factive=0 where fid=" + Id;
                        db.CommandExecute("DELETE FROM SubPageAccess WHERE SubPageID = " + Id);
                        string strUpdate = "DELETE FROM Subpage where SubPageID=" + Id;
                        int res = db.CommandExecute(strUpdate);

                        db.CommandExecute("DELETE FROM MasterPageAccess where MasterPageID=" + Id);
                        strUpdate = "DELETE FROM MasterPages where MasterPageID=" + Id;
                        res = db.CommandExecute(strUpdate);

                        BindGrid();
                        lbl_msg.Text = res > 0 ? "Page has been deleted successfully" : "Could not delete Page";
                    }
                    else
                    {
                        lbl_msg.Text = "Could not delete Page";
                    }
            }
        }
        catch (Exception ex)
        {
            DBAccess.PrintError(ex, "");
            //db.PrintErrorLog(ex, "");
            lbl_msg.Text = "Could not delete Page";
        }
    }

    protected void lnkAddSubpage_Click(object sender, EventArgs e)
    {
        try
        {
            LinkButton link = sender as LinkButton;
            if (link == null) return;
            lblPageMasterID.Text = link.CommandArgument;
            mltItems.ActiveViewIndex = 0;
            Txt_Title.Text = "";
            Item_ID.Value = "";
            lbl_msg.Text = "";
        }
        catch (Exception ex)
        {

        }
    }

    protected void ImgEdit_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            ImageButton ImgEdit = sender as ImageButton;
            if (ImgEdit != null)
            {
                int Id;
                if (int.TryParse(ImgEdit.CommandArgument, out Id))
                {
                    Subpage subpage = new Subpage(Id);

                    Txt_Title.Text = subpage.PageTitle;
                    Txt_Link.Text = subpage.PageName;
                    Item_ID.Value = Id.ToString();
                    lblPageMasterID.Text = subpage.MasterPageID.ToString();
                    mltItems.ActiveViewIndex = 0;
                }
                else
                {
                    lbl_msg.Text = "Could not load item";
                }
            }
        }
        catch (Exception ex)
        {
            DBAccess.PrintError(ex, "");
            lbl_msg.Text = "Could not load item";
        }
    }

    protected void ImgDelete_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            ImageButton ImgEdit = sender as ImageButton;
            if (ImgEdit != null)
            {
                int Id;
                if (int.TryParse(ImgEdit.CommandArgument, out Id))
                {
                    db.CommandExecute("DELETE FROM SubPageAccess WHERE SubPageID = " + Id);
                    string strUpdate = "DELETE FROM Subpage where SubPageID=" + Id;
                    int res = db.CommandExecute(strUpdate);
                    BindGrid();
                    lbl_msg.Text = res > 0 ? "Page has been deleted successfully" : "Could not delete Page";
                }
                else
                {
                    lbl_msg.Text = "Could not delete Page";
                }
            }
        }
        catch (Exception ex)
        {
            DBAccess.PrintError(ex, "");
            lbl_msg.Text = "Could not delete Page";
        }
    }
    protected void ImageButtonUp_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            ImageButton img = sender as ImageButton;
            int roleID;
            int.TryParse(DropDownList1.SelectedValue, out roleID);
            if (img != null)
            {
                db.ExecuteCommand(string.Format("[ChangeMainPosition] {0}, 'up',{1}", img.CommandArgument, roleID));
            }
            SQLPages.DataBind();
            dtMasterPages.DataBind();
        }
        catch (Exception ex)
        {

        }
    }

    protected void ImageButtonDown_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            ImageButton img = sender as ImageButton;
            int roleID;
            int.TryParse(DropDownList1.SelectedValue, out roleID);
            if (img != null)
            {
                db.ExecuteCommand(string.Format("[ChangeMainPosition] {0}, 'down',{1}", img.CommandArgument, roleID));
            }
            SQLPages.DataBind();
            dtMasterPages.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    protected void DropDownList2_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}
