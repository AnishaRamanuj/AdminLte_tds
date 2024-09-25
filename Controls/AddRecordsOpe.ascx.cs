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

public partial class controls_AddRecordsOpe : System.Web.UI.UserControl
{
    int pageid = 87;
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    private readonly DBAccess db = new DBAccess();
    private readonly OpeMaster op = new OpeMaster();

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

                    Div6.Style.Value = "display:block";
                    txtopesearch.Focus();
                    bindOPE();
                    //Label18.Text = "Manage OPE";
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
            ((DataControlField)GridView3.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Edit"))
                .SingleOrDefault()).Visible = false;
        }
        bool d = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "delete");
        if (d == false)
        {
            ((DataControlField)GridView3.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Delete"))
                .SingleOrDefault()).Visible = false;

        }

    }

    public void displayblock(Boolean bln, Boolean bln1)
    {

        Div6.Style.Value = "display:none";
    }




 
    //protected void btnope_Click(object sender, EventArgs e)
    public void btnope()
    {
        try
        {
            if (ViewState["compid"] != null)
            {
                if (Txt2.Text != "")
                {
                    string str = "select OPEName from dbo.OPE_Master where OPEName ='" + Txt2.Text.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {

                        op.id = 0;
                        op.CompId = int.Parse(ViewState["compid"].ToString());
                        op.OPEName = Txt2.Text;
                        int res = op.Insert();
                        if (res == 1)
                        {
                            MessageControl4.SetMessage("OPE Added Successfully", MessageDisplay.DisplayStyles.Success);
                            clearall();
                            //add_ope.Style.Value = "display:none";
                        }
                        else
                            MessageControl4.SetMessage("Error!!!OPE not Added", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
                        MessageControl4.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl4.SetMessage("Please Enter OPE.", MessageDisplay.DisplayStyles.Error);
                }
                bindOPE();
                clearall();
            }
            else
            {
                MessageControl4.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }
 

    //ope//
    public SqlDataSource OPE
    {
        get { return SqlDataSource4; }
    }
    public void bindOPE()
    {
        try
        {
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            OPE.SelectCommand = "select * from OPE_Master where CompId='" + ViewState["compid"].ToString() + "' order by OPEName";

            chk_dv = (DataView)OPE.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl4.SetMessage("No OPE Added", MessageDisplay.DisplayStyles.Error);

                }

               
                searchope.Style.Value = "display:block";
            }
            //if (add_ope.Style.Value == "display:none")
            //{
            //    msghead3.Style.Value = "display:none";
            //    searchope.Style.Value = "display:block";

            //}
            //else if (add_ope.Style.Value == null || add_ope.Style.Value == "display:block")
            //{
            //    msghead3.Style.Value = "display:block";
            //    searchope.Style.Value = "display:none";

            //}
            else
            {
                msghead.Style.Value = "display:block";
                searchope.Style.Value = "display:none";
            }
            GridView3.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView3_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView3.PageIndex = e.NewPageIndex;
        bindOPE();

    }
    protected void GridView3_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "delete")
            {
                
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int compid = int.Parse(GridView3.DataKeys[row.RowIndex].Value.ToString());
                //find staff for that desg
                string sql = "Select * from Timesheet_Table where OpeId='" + compid + "'";
                DataTable dt = db.GetDataTable(sql);
                if (dt == null || dt.Rows.Count == 0)
                {
                    DBAccess.PrintDelete(Session["IP"].ToString(), "Expense Master", Session["fulname"].ToString(), Session["usertype"].ToString(), hdnDT.Value);
                
                    string StrSQL = "delete from dbo.OPE_Master where OpeId='" + compid + "'";
                    int res = db.ExecuteCommand(StrSQL);
                    if (res == 1)
                    {
                        MessageControl4.SetMessage("OPE Deleted Successfully", MessageDisplay.DisplayStyles.Info);
                    }
                    else
                    {
                        MessageControl4.SetMessage("OPE Not Deleted", MessageDisplay.DisplayStyles.Error);
                    }
                    OPE.DeleteCommand = StrSQL;
                    bindOPE();
                }
                else
                {
                    string StrSQL = "delete from dbo.OPE_Master where OpeId='0'";
                    int res = db.ExecuteCommand(StrSQL);
                    OPE.DeleteCommand = StrSQL;
                    MessageControl4.SetMessage("Cannot delete OPE, Timesheet exist", MessageDisplay.DisplayStyles.Error);
                    bindOPE();
                }
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView3_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)GridView3.Rows[e.RowIndex].FindControl("TextBox3")).Text);
            string mainCatgId = ((Label)GridView3.Rows[e.RowIndex].FindControl("lblfid")).Text;

            string str = "select OPEName from dbo.OPE_Master where OPEName ='" + maincattext.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {
                string StrSQL = "update OPE_Master set  OPEName='" + maincattext + "' where OpeId=" + mainCatgId;
                OPE.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                GridView3.EditIndex = -1;
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl4.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            bindOPE();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView3_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView3.EditIndex = -1;
        bindOPE();
    }
    protected void GridView3_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView3.EditIndex = e.NewEditIndex;
        btnopesearch_Click(sender, e);
        txtopesearch.Text = "";
        //bindOPE();
    }



    public void clearall()
    {
       Txt2.Text = string.Empty;
    }


  
    protected void LinkOpe_Click(object sender, EventArgs e)
    {
        //Response.Redirect("AddRecords.aspx?ope=1&stt=new");
        //Label33.Text = "Add Branch";
        //Label1.Text = "Branch";

        ModalPopupExtender2.Show();
    }
   
  
  


  
    protected void GridView3_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox3").Focus();
        }
    }


 
  
    protected void btnopesearch_Click(object sender, EventArgs e)
    {
        string txtval = txtopesearch.Text;
        OPE.SelectCommand = "select * from OPE_Master where OPEName like '%" + txtval + "%' and CompId='" + ViewState["compid"].ToString() + "' order by OPEName";
        GridView3.DataBind();
        

    }


    protected void BtnSubmit2_Click(object sender, EventArgs e)
    {
        btnope();
        Button4.Focus();
    }
    protected void btnCancel2_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender2.Hide();
    }

    protected void LinkOpe_Click(object sender, ImageClickEventArgs e)
    {

    }
    protected void Button4_Click(object sender, EventArgs e)
    {
        //Label33.Text = "Add Branch";
        //Label1.Text = "Branch";
        Txt2.Focus();
        ModalPopupExtender2.Show();
    }
    protected void BtnClose2_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender2.Hide();
    }
    protected void GridView3_RowCreated(object sender, GridViewRowEventArgs e)
    {
       // e.Row.Attributes.Add("onclick", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseover", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor=this.originalstyle;");
    }
}
