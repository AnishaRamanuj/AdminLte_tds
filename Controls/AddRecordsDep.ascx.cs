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
using Microsoft.ApplicationBlocks1.Data;
using System.Data.SqlClient;
public partial class controls_AddRecordsDep : System.Web.UI.UserControl
{
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    private readonly DBAccess db = new DBAccess();
    private readonly DepartmentMaster dept = new DepartmentMaster();

    DataView chk_dv;
    DataTable chk_dt;
    int pageid=74;

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
                    Div2.Style.Value = "display:block";
                    //Txt2.Focus();
                    txtsearchdept.Focus();
                    binddept();
                    //Label18.Text = "Department";

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
         { btnadddept.Visible = false; }
         bool edit = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "edit");
         if (edit == false)
         {
             ((DataControlField)GridView1.Columns
                 .Cast<DataControlField>()
                 .Where(fld => (fld.HeaderText == "Edit"))
                 .SingleOrDefault()).Visible = false;
         }
         bool d = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "delete");
         if (d == false)
         {
             ((DataControlField)GridView1.Columns
                 .Cast<DataControlField>()
                 .Where(fld => (fld.HeaderText == "Delete"))
                 .SingleOrDefault()).Visible = false;

         }
        




    }

    public void displayblock(Boolean bln, Boolean bln1)
    {

        Div2.Style.Value = "display:none";
    }


    //department//

    //protected void btndept_Click(object sender, EventArgs e)
    public void btndept()
    {
        try
        {
            if (ViewState["compid"] != null)
            {
                if (Txt2.Text != "")
                {
                    string str = "select DepartmentName from dbo.Department_Master where DepartmentName ='" + Txt2.Text.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {
                        dept.id = 0;
                        dept.CompId = int.Parse(ViewState["compid"].ToString());
                        dept.DepartmentName = Txt2.Text;
                        int res = dept.Insert();
                        if (res == 1)
                        {
                            MessageControl1.SetMessage("Department Added Successfully", MessageDisplay.DisplayStyles.Success);
                            clearall();
                            ModalPopupExtender2.Hide();

                            //add_depart.Style.Value = "display:none";
                        }
                        else
                            MessageControl1.SetMessage("Error!!!Department not Added", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
                        MessageControl1.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl1.SetMessage("Please Enter a Department.", MessageDisplay.DisplayStyles.Error);
                }
                binddept();

            }
            else
            {
                MessageControl1.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }

    //public SqlDataSource departStaff
    //{
    //    get { return SqlDataSource11; }
    //}
    public void binddepartStaff()
    {
        //departStaff.SelectCommand = "select * from Staff_Master where DepId='" + Session["Depid"].ToString() + "' order by StaffName";
        //chk_dv = (DataView)departStaff.Select(DataSourceSelectArguments.Empty);
        //chk_dt = chk_dv.ToTable();
        //int i = chk_dt.Rows.Count;
        SqlParameter[] param = new SqlParameter[3];
        param[0] = new SqlParameter("@companyId", ViewState["compid"]);
        param[1] = new SqlParameter("@fld", "s.Depid");
        param[2] = new SqlParameter("@id", Session["Depid"]);
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_ListStaffResign", param);
        if (ds.Tables[0].Rows.Count > 0)
        {
        }
        GrdD.DataSource = ds.Tables[0];  
        GrdD.DataBind();
    }

    public SqlDataSource department
    {
        get { return SqlDataSource2; }
    }
    public void binddept()
    {
        try
        {
            int depid = 0;
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            department.SelectCommand = "select * from Department_Master where CompId='" + ViewState["compid"].ToString() + "' order by DepartmentName";

            chk_dv = (DataView)department.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl1.SetMessage("No Departments Added", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    depid = int.Parse(chk_dt.Rows[0]["Depid"].ToString());
                }
                ModalPopupExtender2.Hide(); 
                searchdept.Style.Value = "display:block";
            }

            else
            {
                msghead.Style.Value = "display:block";
                searchdept.Style.Value = "display:none";

            }
            GridView1.DataBind();
            Session["Depid"] = depid;
            binddepartStaff();

        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "delete")
            {
                DBAccess.PrintDelete(Session["IP"].ToString(), "Department Master", Session["fulname"].ToString(), Session["usertype"].ToString(), hdnDT.Value);
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int compid = int.Parse(GridView1.DataKeys[row.RowIndex].Value.ToString());
                //find staff for that desg
                string sql = "Select * from staff_master where DepId='" + compid + "'";
                DataTable dt = db.GetDataTable(sql);
                if (dt == null || dt.Rows.Count == 0)
                {
 
                    string StrSQL = "delete from dbo.Department_Master where DepId='" + compid + "'";
                    int res = db.ExecuteCommand(StrSQL);
                    if (res == 1)
                    {
                        MessageControl1.SetMessage("Deparment Deleted Successfully", MessageDisplay.DisplayStyles.Info);
                    }
                    else
                    {
                        MessageControl1.SetMessage("Department Not Deleted", MessageDisplay.DisplayStyles.Error);
                    }

                    department.DeleteCommand = StrSQL;
                    binddept();
                }
                else
                {
                    string StrSQL = "delete from dbo.Department_Master where DepId='0'";
                    int res = db.ExecuteCommand(StrSQL);
                    department.DeleteCommand = StrSQL;
                    MessageControl1.SetMessage("Cannot delete Department, Staff exist", MessageDisplay.DisplayStyles.Error);
                    binddept();
                }

            }
            if (e.CommandName == "view")
            {
                LinkButton btn = (LinkButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                Session["Depid"] = int.Parse(GridView1.DataKeys[row.RowIndex].Value.ToString());
                binddepartStaff();
                GrdD.HeaderRow.Cells[1].Text = "Staff Name For " + btn.Text;
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.EditIndex = e.NewPageIndex;
        binddept();
    }
    //protected void GridView1_SelectedIndexChanged(object sender, GridViewPageEventArgs e)
    //{
    //    GridView1.SelectedRowStyle.BackColor = System.Drawing.Color.Yellow;
    //}
    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)GridView1.Rows[e.RowIndex].FindControl("TextBox3")).Text);
            string mainCatgId = ((Label)GridView1.Rows[e.RowIndex].FindControl("lblDid")).Text;

            string str = "select DepartmentName from dbo.Department_Master where DepartmentName ='" + maincattext.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {
                string StrSQL = "update Department_Master set DepartmentName='" + maincattext + "' where DepId=" + mainCatgId;
                department.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                GridView1.EditIndex = -1;
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl1.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            binddept();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView1.EditIndex = -1;
        binddept();
    }
    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView1.EditIndex = e.NewEditIndex;
        btndepsearch_Click(sender, e);
        txtsearchdept.Text = "";
        //binddept();
        binddepartStaff();
    }
    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridView1.SelectedRowStyle.BackColor=System.Drawing.Color.Yellow;
    }

    //protected void LinkDepart_Click(object sender, ImageClickEventArgs e)
    //{
    //    Label33.Text = "Add Department";
    //    Label1.Text = "Department";

    //    ModalPopupExtender2.Show();
    //}

 
    public void clearall()
    {
        Txt2.Text = string.Empty;
    }



    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox3").Focus();
        }

    }
 
 
    protected void btndepsearch_Click(object sender, EventArgs e)
    {
        string txtval = txtsearchdept.Text;
        department.SelectCommand = "select * from Department_Master where DepartmentName like '%" + txtval + "%' and CompId='" + ViewState["compid"].ToString() + "' order by DepartmentName";
        //DataTable dt=db.GetDataTable(str);
        GridView1.DataBind();
        if (GridView1.Rows.Count == 0)
        {
            Session["Depid"] = "";
            binddepartStaff();
        }
        

    }


    protected void Button4_Click(object sender, EventArgs e)
    {
        string txtval = txtsearchdept.Text;
        department.SelectCommand = "select * from Department_Master where DepartmentName like '%" + txtval + "%' and CompId='" + ViewState["compid"].ToString() + "' order by DepartmentName";
        GridView1.DataBind();
    }

  
    protected void btnadddept_Click1(object sender, EventArgs e)
    {
        Label33.Text = "Add Department";
        Label1.Text = "Department";
        Txt2.Text = "";
        Txt2.Focus();
        ModalPopupExtender2.Show();
        
    }
    protected void BtnClose2_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender2.Hide();
    }
    protected void BtnSubmit2_Click1(object sender, EventArgs e)
    {
        
            btndept();
            btnadddept.Focus();
      
    }
    protected void btnCancel2_Click1(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender2.Hide();

    }

    protected void GridView1_RowCreated(object sender, GridViewRowEventArgs e)
    {
        e.Row.Attributes.Add("onclick", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseover", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor=this.originalstyle;");
    }
    protected void GrdD_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GrdD.PageIndex = e.NewPageIndex;
        binddepartStaff();
    }
}
