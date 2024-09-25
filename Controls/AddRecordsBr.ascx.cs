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
using System.Data.SqlClient;
using  Microsoft.ApplicationBlocks.Data;

public partial class controls_AddRecordsBr : System.Web.UI.UserControl
{
    int pageid = 83;
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
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
            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["cltcomp"].ToString();
            }

            if (ViewState["compid"] != null)
            {

                    Div4.Style.Value = "display:block";
                    txtbrsearch.Focus();
                    bindbranch();
                   // Label18.Text = "Branch";

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
        { btnaddbranch.Visible = false; }
        bool edit = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "edit");
        if (edit == false)
        {
            ((DataControlField)GridView2.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Edit"))
                .SingleOrDefault()).Visible = false;
        }
        bool d = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "delete");
        if (d == false)
        {
            ((DataControlField)GridView2.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Delete"))
                .SingleOrDefault()).Visible = false;

        }



    }

    public void displayblock(Boolean bln, Boolean bln1)
    {

        Div4.Style.Value = "display:none";
    }



    //protected void btnbranch_Click(object sender, EventArgs e)
    public void btnbranch()
    {
        try
        {
            if (ViewState["compid"] != null)
            {
                if (Txt2.Text != "")
                {
                    string str = "select BranchName from dbo.Branch_Master where BranchName ='" + Txt2.Text.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {
                        br.id = 0;
                        br.CompId = int.Parse(ViewState["compid"].ToString());
                        br.BranchName = Txt2.Text;
                        int res = br.Insert();
                        if (res == 1)
                        {
                            MessageControl3.SetMessage("Branch Added Successfully", MessageDisplay.DisplayStyles.Success);
                            clearall();
                            ModalPopupExtender2.Hide();

                            //add_brch.Style.Value = "display:none";
                        }
                        else
                            MessageControl3.SetMessage("Error!!!Branch not Added", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
                        MessageControl3.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl3.SetMessage("Please Enter a Branch.", MessageDisplay.DisplayStyles.Error);
                }
                bindbranch();

            }
            else
            {
                MessageControl3.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }

    //branch//

    //public SqlDataSource BranchStaff
    //{
    //    get { return SqlDataSource12; }
    //}
    public void bindBranchStaff()
    {
        //BranchStaff.SelectCommand = "select * from Staff_Master where BrId='" + Session["Brid"].ToString() + "' and Compid='" + ViewState["compid"].ToString() + "' order by StaffName";
        //chk_dv = (DataView)BranchStaff.Select(DataSourceSelectArguments.Empty);
        //chk_dt = chk_dv.ToTable();
        //int i = chk_dt.Rows.Count;
        SqlParameter[] param = new SqlParameter[3];
        param[0] = new SqlParameter("@companyId", ViewState["compid"]);
        param[1] = new SqlParameter("@fld", "s.BrId");
        param[2] = new SqlParameter("@id", Session["BrId"]);
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_ListStaffResign", param);
        if (ds.Tables[0].Rows.Count > 0)
        {
        }
        GrdB.DataSource = ds.Tables[0]; 
        GrdB.DataBind();
    }
    public SqlDataSource branch
    {
        get { return SqlDataSource3; }
    }
    public void bindbranch()
    {
        try
        {
            int Brid = 0;
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            branch.SelectCommand = "select * from Branch_Master where CompId='" + ViewState["compid"].ToString() + "' order by BranchName";

            chk_dv = (DataView)branch.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl3.SetMessage("No Branch Added", MessageDisplay.DisplayStyles.Error);

                }
                else
                {
                    Brid = int.Parse(chk_dt.Rows[0]["Brid"].ToString());
                }
                 ModalPopupExtender2.Hide(); 

                //add_brch.Style.Value = "display:none";
                searchbr.Style.Value = "display:block";
            }

            else
            {
                msghead.Style.Value = "display:block";
                searchbr.Style.Value = "display:none";

            }
            GridView2.DataBind();
            Session["Brid"] = Brid;
            bindBranchStaff();

        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView2_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView2.PageIndex = e.NewPageIndex;
        bindbranch();
    }

    protected void GrdB_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GrdB.PageIndex = e.NewPageIndex;
        bindBranchStaff();
    }

    protected void GridView2_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "delete")
            {
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int compid = int.Parse(GridView2.DataKeys[row.RowIndex].Value.ToString());
                //find staff for that desg
                string sql = "Select * from staff_master where BrId='" + compid + "'";
                DataTable dt = db.GetDataTable(sql);
                if (dt == null || dt.Rows.Count == 0)
                {

                    string StrSQL = "delete from dbo.Branch_Master where BrId='" + compid + "'";
                    int res = db.ExecuteCommand(StrSQL);
                    if (res == 1)
                    {
                        MessageControl3.SetMessage("Branch Deleted Successfully", MessageDisplay.DisplayStyles.Info);
                    }
                    else
                    {
                        MessageControl3.SetMessage("Branch Not Deleted", MessageDisplay.DisplayStyles.Error);
                    }
                    branch.DeleteCommand = StrSQL;
                    bindbranch();

                }
                else
                {
                    string did = "0";
                    string StrSQL = "delete from dbo.Branch_Master where BrId='" + did + "'";
                    int res = db.ExecuteCommand(StrSQL);
                    branch.DeleteCommand = StrSQL;
                    MessageControl3.SetMessage("Cannot delete Branch, Staff exist", MessageDisplay.DisplayStyles.Error);
                    bindbranch();
                }
            }

            if (e.CommandName == "view")
            {
                LinkButton btn = (LinkButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                Session["Brid"] = int.Parse(GridView2.DataKeys[row.RowIndex].Value.ToString());
                bindBranchStaff();
                GrdB.HeaderRow.Cells[1].Text = "Staff Name For " + btn.Text;
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView2_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView2.EditIndex = e.NewEditIndex;
        btnsearchbr_Click(sender, e);
        txtbrsearch.Text = "";
        //bindbranch();
    }
    protected void GridView2_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView2.EditIndex = -1;
        bindbranch();
    }
    protected void GridView2_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)GridView2.Rows[e.RowIndex].FindControl("TextBox3")).Text);
            string mainCatgId = ((Label)GridView2.Rows[e.RowIndex].FindControl("lblfid")).Text;

            string str = "select BranchName from dbo.Branch_Master where BranchName ='" + maincattext.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {
                string StrSQL = "update Branch_Master set BranchName='" + maincattext + "' where BrId=" + mainCatgId;
                branch.UpdateCommand = StrSQL;
                int res = db.ExecuteCommand(StrSQL);
                if (res == 1)
                {
                    MessageControl3.SetMessage("Branch Updated Successfully", MessageDisplay.DisplayStyles.Info);
                }
                GridView2.EditIndex = -1;
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl3.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            bindbranch();
        }
        catch (Exception ex)
        {

        }
    }








    public void clearall()
    {
       Txt2.Text = string.Empty;
    }


    
 



    protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox3").Focus();
        }
    }

 
     protected void btnsearchbr_Click(object sender, EventArgs e)
    {
        string txtval = txtbrsearch.Text;
        branch.SelectCommand = "select * from Branch_Master where BranchName like '%" + txtval + "%' and CompId='" + ViewState["compid"].ToString() + "' order by BranchName";
        GridView2.DataBind();
        if (GridView2.Rows.Count == 0)
        {
            Session["Brid"] = "-1";
            bindBranchStaff();
        }

    }


     protected void BtnSubmit2_Click(object sender, EventArgs e)
     {
             btnbranch();
             btnaddbranch.Focus();
     }
    protected void btnCancel2_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender2.Hide();
    }

    protected void btnaddbranch_Click(object sender, EventArgs e)
    {
        Label33.Text = "Add Branch";
        Label1.Text = "Branch";
        Txt2.Text = "";
        Txt2.Focus();
        ModalPopupExtender2.Show(); 
    }
    protected void BtnClose2_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender2.Hide();

    }
    protected void GridView2_RowCreated(object sender, GridViewRowEventArgs e)
    {
        e.Row.Attributes.Add("onclick", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseover", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor=this.originalstyle;");
    }
    
}
