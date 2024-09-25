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

public partial class controls_AddRecords : System.Web.UI.UserControl
{
    int pageid = 73;
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    private readonly DBAccess db = new DBAccess();
    private readonly DesignationMaster des = new DesignationMaster();

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
                    Div1.Style.Value = "display:block";
                    
                    binddesig();
                    txtdesgsearch.Focus();


            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        txtdesignation.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        //Txt2.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");


        string objL = objDAL_PagePermissions.Dal_getRolepermission(pageid, Convert.ToInt32(Session["UserRole"]), Convert.ToInt32(Session["companyid"]));

        hidpermission.Value = objL;



        bool a = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "add");
        if (a == false)
        { Button4.Visible = false; }
        bool edit = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "edit");
        if (edit == false)
        {
            ((DataControlField)Griddealers.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Edit"))
                .SingleOrDefault()).Visible = false;
        }
        bool d = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "delete");
        if (d == false)
        {
            ((DataControlField)Griddealers.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Delete"))
                .SingleOrDefault()).Visible = false;
        }
    }

    public void displayblock(Boolean bln,Boolean bln1)
    {

        Div1.Style.Value = "display:none";
    }

    protected void btndesignation_Click(object sender, EventArgs e)
    {
        try
        {
            if (ViewState["compid"] != null)
            {
                if (txtdesignation.Text != "")
                {
                    if (txthourcharge.Text != "")
                    {
                        string str = "select DesignationName from dbo.Designation_Master where DesignationName ='" + txtdesignation.Text.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
                        DataTable dt = db.GetDataTable(str);
                        if (dt == null || dt.Rows.Count == 0)
                        {
                            des.id = 0;
                            des.CompId = int.Parse(ViewState["compid"].ToString());
                            des.DesignationName = txtdesignation.Text;
                            des.HourlyCharges = int.Parse(txthourcharge.Text.Trim());
                            int res = des.Insert();
                            if (res == 1)
                            {
                                MessageControl2.SetMessage("Designation Added Successfully", MessageDisplay.DisplayStyles.Success);
                                clearall();
                                ModalPopupExtender1.Hide();  
                            }
                            else
                                MessageControl2.SetMessage("Error!!!Designation not Added", MessageDisplay.DisplayStyles.Info);
                        }
                        else
                        {
                            MessageControl2.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                        }
                    }
                    else
                    {
                        MessageControl2.SetMessage("Please Enter Hourly Charges.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl2.SetMessage("Please Enter a Designation.", MessageDisplay.DisplayStyles.Info);
                }
                binddesig();
                Button4.Focus();

            }
            else
            {
                MessageControl2.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }

    //designation//
    public SqlDataSource designation
    {
        get { return SqlDataSource1; }
    }
    public void binddesig()
    {
        try
        {

            int desgid = 0;
         

            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            designation.SelectCommand = "select * from Designation_Master where CompId='" + ViewState["compid"].ToString() + "' order by DesignationName";

            chk_dv = (DataView)designation.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
         
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl2.SetMessage("No Designation Added", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    desgid = int.Parse(chk_dt.Rows[0]["Dsgid"].ToString());
                }
                ModalPopupExtender1.Hide();
                //searchdesg.Style.Value = "display:block";
            }
            else
            {
                msghead.Style.Value = "display:block";
                //searchdesg.Style.Value = "display:none";

            }
            Griddealers.DataBind();
            Session["Dsgid"] = desgid;
            binddesigStaff();
        }
        catch (Exception ex)
        {

        }
    }
    //public SqlDataSource designationStaff
    //{
    //    get { return SqlDataSource10; }
    //}
    public void binddesigStaff()
    {

        SqlParameter[] param = new SqlParameter[3];
        param[0] = new SqlParameter("@companyId", ViewState["compid"]);
        param[1] = new SqlParameter("@fld", "s.DsgId");
        param[2] = new SqlParameter("@id", Session["Dsgid"]);
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_ListStaffResign", param);
        if (ds.Tables[0].Rows.Count > 0)
        {
        }
        
        //string dT = "";
        //dT = DateTime.Now.ToString("MM/dd/yyyy");
        //string sql ="";
        //sql = "select * from Staff_Master where DsgId='" + Session["Dsgid"].ToString() + "' and (DateOfLeaving > " + dT + "  or right(convert(varchar(10),ISNULL(DateOfLeaving, " + dT + " ),103),7)= right(convert(varchar(10), " + dT + " ,103),7)) ";
        //sql = sql + "and (DateOfJoining < " + dT + ")  order by StaffName";

         
        //chk_dv = (DataView)designation.Select(DataSourceSelectArguments.Empty);
        //chk_dt = chk_dv.ToTable();
        //int i = chk_dt.Rows.Count;
        GrdDsg.DataSource = ds.Tables[0];  
        GrdDsg.DataBind();
    }
    protected void Griddealers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Griddealers.PageIndex = e.NewPageIndex;
        binddesig();
    }
    protected void GrdDsg_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GrdDsg.PageIndex = e.NewPageIndex;
        binddesig();
    }
    protected void Griddealers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            
            if (e.CommandName == "delete")
            {
                        
                DBAccess.PrintDelete(Session["IP"].ToString(), "Designation Master", Session["fulname"].ToString(), Session["usertype"].ToString(), hdnDT.Value);
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int compid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
                //find staff for that desg
                string sql = "Select * from staff_master where DsgId='" + compid + "'";
                DataTable dt = db.GetDataTable(sql);
                if (dt == null || dt.Rows.Count == 0)
                {

                    string StrSQL = "delete from dbo.Designation_Master where DsgId='" + compid + "'";
                    int res = db.ExecuteCommand(StrSQL);
                    designation.DeleteCommand = StrSQL;
                    if (res == 1)
                    {
                        MessageControl2.SetMessage("Designation Deleted Successfully", MessageDisplay.DisplayStyles.Info);
                    }
                    else
                    {
                        MessageControl2.SetMessage("Designation Not Deleted", MessageDisplay.DisplayStyles.Error);
                    }

                    binddesig();
                }
                else
                {
                    string did = "0";
                    string StrSQL = "delete from dbo.Designation_Master where DsgId='" + did + "'";
                    int res = db.ExecuteCommand(StrSQL);
                    designation.DeleteCommand = StrSQL;

                    MessageControl2.SetMessage("Cannot delete Designation, Staff exist", MessageDisplay.DisplayStyles.Error);

                    binddesig();
                }
            }
            if (e.CommandName == "view")
            {
                LinkButton btn = (LinkButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                //btn.Font.Bold = true;
                Session["Dsgid"] = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
                binddesigStaff();                
                GrdDsg.HeaderRow.Cells[1].Text = "Staff Name For " + btn.Text;
              
               
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void Griddealers_RowEditing(object sender, GridViewEditEventArgs e)
    {
        Griddealers.EditIndex = e.NewEditIndex;

        btnsesg_Click(sender, e);
        txtdesgsearch.Text = "";

        //binddesig();

    }
    protected void Griddealers_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)Griddealers.Rows[e.RowIndex].FindControl("TextBox1")).Text);
            string maincattext1 = (((TextBox)Griddealers.Rows[e.RowIndex].FindControl("TextBox2")).Text);
            string mainCatgId = ((Label)Griddealers.Rows[e.RowIndex].FindControl("lblid")).Text;
            string str = "select DesignationName,HourlyCharges from dbo.Designation_Master where DesignationName ='" + maincattext.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {

                string StrSQL = "update Designation_Master set DesignationName='" + maincattext + "' , HourlyCharges='" + maincattext1 + "' where DsgId=" + mainCatgId;
                designation.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                Griddealers.EditIndex = -1;
                //binddesig();
            }
            else if (dt.Rows[0]["HourlyCharges"].ToString() != maincattext1)
            {
                string StrSQL = "update Designation_Master set HourlyCharges='" + maincattext1 + "' where DsgId='" + mainCatgId + "'";
                designation.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                Griddealers.EditIndex = -1;
                string str1 = "select DesignationName from dbo.Designation_Master where DsgId='" + mainCatgId + "'";
                DataTable dt1 = db.GetDataTable(str1);
                if (dt1.Rows[0]["DesignationName"].ToString() != maincattext)
                {
                    MessageControl2.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl2.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            binddesig();
        }
        catch (Exception ex)
        {

        }
    }
    protected void Griddealers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        Griddealers.EditIndex = -1;
        binddesig();
    }

   
    public void clearall()
    {
        txtdesignation.Text = string.Empty;
        txthourcharge.Text = string.Empty;
        //Txt2.Text = string.Empty;
        //txtbranchname.Text = string.Empty;
    }

 
    protected void Griddealers_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox1").Focus();
        }
    }

    protected void btnsesg_Click(object sender, EventArgs e)
    {
        string txtval = txtdesgsearch.Text;
        designation.SelectCommand = "select * from Designation_Master where DesignationName like '%" + txtval + "%' and CompId='" + ViewState["compid"].ToString() + "' order by DesignationName";
        Griddealers.DataBind();
        if (Griddealers.Rows.Count == 0)
        {
            Session["Dsgid"] = "";
            binddesigStaff();
        }
    }


    protected void Griddealers_SelectedIndexChanged(object sender, EventArgs e)
    {

    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender1.Hide();

    }
    protected void Button4_Click(object sender, EventArgs e)
    {
        txtdesignation.Text = "";
        txthourcharge.Text = "";
        txtdesignation.Focus();
        ModalPopupExtender1.Show(); 
    }
    protected void Btnclose_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender1.Hide();
    }

    protected void Griddealers_RowCreated(object sender, GridViewRowEventArgs e)
    {
        e.Row.Attributes.Add("onclick", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseover", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor=this.originalstyle;");
    }
    
}
