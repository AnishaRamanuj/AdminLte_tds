using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using JTMSProject;
using System.Web.Security;
using System.Text;
using System.Net.Mail;
using System.Configuration;
using AjaxControlToolkit;
using System.Text.RegularExpressions;
using System.IO;
using System.Collections;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml;
using System.Web.Services;
using System.Management;
using System.Web.Caching;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Web.Script.Serialization;

/// <summary>
/// changes made by anil gajre on 06/09/2017 for newly Data Binding
/// </summary>
public partial class controls_Managestaff : System.Web.UI.UserControl
{
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    int pagesize = 25;
    int pageid = 84; 
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    LabelAccess objlabelAccess = new LabelAccess();
    List<tbl_LabelAccess> LtblAccess;
    CultureInfo info = new CultureInfo("en-US", false);
    private readonly DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                ViewState["compid"] = Session["companyid"].ToString();
                hdnCompanyid.Value = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["cltcomp"].ToString();
                hdnCompanyid.Value = Session["companyid"].ToString();
               
            }
            if (ViewState["compid"] != null)
            {
                bindgrid(1, pagesize);
                bindrole();
                rolepermission();
                getrolepermission();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        
        }
        txtsrchjob.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        TxtPass.Attributes.Add("onkeyup", "CheckPasswordStrength(this.value);");
    }


    public void btnAdd_Click(object sender, EventArgs e)
    {
        bindgrid(1, pagesize);
    }

   

    private void getrolepermission()
    {
        
        string objL = objDAL_PagePermissions.Dal_getRolepermission(pageid, Convert.ToInt32(Session["UserRole"]), Convert.ToInt32(Session["companyid"]));
        hdnrolepermission.Value = objL;
        
        bool a = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "add");
        if (a == false)
        {
            ImageButton1.Visible = false;

        }
        bool e = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "edit");
        if (e == false)
        {
            ((DataControlField)Griddealers.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Edit"))
                .SingleOrDefault()).Visible = false;
        }
        bool d = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "delete");
        if (d == false)
        {
            ((DataControlField)Griddealers.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Delete"))
                .SingleOrDefault()).Visible = false;

        }

        bool hcharge = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "edit hourly charges");
        hdnhchargepermission.Value = hcharge.ToString();
        bool cpass = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "edit change password");
        hdnChangePasspermission.Value = cpass.ToString();
        bool JOB = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "edit joining date");
        hdnJOBpermission.Value = JOB.ToString();
        bool LOB = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "edit leaving date");
        hdnLOBpermission.Value = LOB.ToString();
        bool other = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "edit detail");
        hdnOtherDetailpermission.Value = other.ToString();


     

    }
    private void rolepermission()
    {

        DataSet ds = new DataSet();
        SqlParameter[] param = new SqlParameter[4];
        param[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"].ToString()));
        ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_getrolepermission", param);
        if (ds.Tables[0].Rows.Count > 0)
        {
            hidpermitionID.Value = ds.Tables[0].Rows[0]["rolepermitted"].ToString();
        }
    }
    private void bindrole()
    {
        try
        {
            DataSet ds = new DataSet();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"]).ToString());
            ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_Bindrole", param);
            ddlroll.DataSource = ds;
            ddlroll.DataTextField = "Rolename";
            ddlroll.DataValueField = "RoleID";
            ddlroll.DataBind();
            ddlroll.Items.Insert(0, new ListItem("Please select role Name", "0"));
            ddlroll.SelectedValue = "0";
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("You do not have a role permission", MessageDisplay.DisplayStyles.Error);
        }
    }
    public void bindgrid(int currentpage,int pagesize)
    {
        try
        {
            //////creating chages by anil gajre on 6/9/2017
            /////changing code inline to store procedure
            int totalcount = 0;
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"].ToString());
            param[1] = new SqlParameter("@search", txtsrchjob.Text);
            param[2]=new SqlParameter("@pageindex", currentpage);
            param[3] = new SqlParameter("@pagesize", pagesize);

            DataSet ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_getstaff", param);
            if (ds.Tables[0] != null)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    Griddealers.DataSource = ds;
                    Griddealers.DataBind();
                    Label1.Text = "Manage Staff (" + ds.Tables[0].Rows.Count.ToString() + "/" + ds.Tables[1].Rows[0]["staffcount"].ToString() + ")";
                    totalcount = Convert.ToInt32(ds.Tables[0].Rows[0]["totalcount"]);
                    hdnCntSft.Value = ds.Tables[1].Rows[0]["staffcount"].ToString();
                    hdnStaffLimit.Value = ds.Tables[2].Rows[0]["Stafflimit"].ToString();
                }
                else
                {
                    Griddealers.DataSource = ds;
                    Griddealers.DataBind();
                    Label1.Text = "Manage Staff (0/" + ds.Tables[1].Rows[0]["staffcount"].ToString() + ")";
                    hdnCntSft.Value = "0";
                    hdnStaffLimit.Value = ds.Tables[2].Rows[0]["Stafflimit"].ToString();
                }
            }
            PopulatePager(totalcount, currentpage);
            lblTotalRecords.Text = "Showing " + Convert.ToInt32(ds.Tables[0].Rows[0]["sino"].ToString()) + " to " + Convert.ToInt32(ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["sino"].ToString()) + " of " + totalcount + " entries.";
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("No Staff Found",MessageDisplay.DisplayStyles.Error);
        }
    }

    private void PopulatePager(int totalcount, int currentpage)
    {
        double dblPageCount = (double)((decimal)totalcount / pagesize);
        int pageCount = (int)Math.Ceiling(dblPageCount);
        List<ListItem> pages = new List<ListItem>();
        if (pageCount > 0)
        {
            int showMax = 10;
            int startPage;
            int endPage;
            if (pageCount <= showMax)
            {
                startPage = 1;
                endPage = pageCount;
                
            }
            else
            {
                startPage = currentpage;
                endPage = currentpage + showMax - 1;
             
            }

            pages.Add(new ListItem("First", "1", currentpage > 1));

            for (int i = startPage; i <= endPage; i++)
            {
                pages.Add(new ListItem(i.ToString(), i.ToString(), i != currentpage));
            }

            pages.Add(new ListItem("Last", pageCount.ToString(), currentpage < pageCount));
        }
        rptPager.DataSource = pages;
        rptPager.DataBind();
    }
    protected void Page_Changed(object sender, EventArgs e)
    {
        int pageIndex = int.Parse((sender as LinkButton).CommandArgument);
        this.bindgrid(pageIndex, pagesize);
    }

    protected void btndelete_Click(object sender, EventArgs e)
    {
        try
        {
            DBAccess.PrintDelete(Session["IP"].ToString(), "Staff Master", Session["fulname"].ToString(), Session["usertype"].ToString(), hdnDT.Value);
            ImageButton btndelete = sender as ImageButton;
            int id = Convert.ToInt32(btndelete.CommandArgument);
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@staffcode", id);
            SqlHelper.ExecuteNonQuery(conn, CommandType.StoredProcedure, "usp_deletestaff", param);
            txtsrchjob.Text = "";
                bindgrid(1,pagesize);
                Label lblstat = (Label)this.Page.Master.FindControl("Label9");
                //UpdatePanel updatepan = (UpdatePanel)this.Page.Master.FindControl("MasterUpdate");
                string query1 = "select count(*) as totcount  from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' and IsDeleted='False'";
                DataTable dt2 = db.GetDataTable(query1);
                if (dt2.Rows.Count != 0 && dt2 != null)
                {
                    string jj= dt2.Rows[0]["totcount"].ToString();
                }
                else
                {
                    lblstat.Text = "0";
                }
                //updatepan.Update();
                MessageControl1.SetMessage("Staff Deleted successfully......", MessageDisplay.DisplayStyles.Success);
                           
    }
            
        
        catch (Exception ex)
        {
            MessageControl1.SetMessage(ex.Message.ToString(), MessageDisplay.DisplayStyles.Error);
        }
    }
   
    protected void Griddealers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
          try
        {
            if (e.CommandName == "staff")
            {
                LinkButton btn = (LinkButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int compid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
                Label lblid = (Label)row.FindControl("lblfid");
                Session["fulname"] = btn.Text;
                Session["staff"] = compid;
             
                Response.Redirect("EditStaffDetails.aspx?p=9,139");
 
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    protected void Griddealers_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void btnsrchjob_Click(object sender, EventArgs e)
    {
        bindgrid(1,pagesize);
    }
    protected void lnknewclient_Click(object sender, EventArgs e)
    {

        int Staffcount = Convert.ToInt32(hdnCntSft.Value);
        Staffcount = Staffcount + 1;

        if (Staffcount <= Convert.ToInt32(hdnStaffLimit.Value) )
        {
            Response.Redirect("StaffRegistration.aspx?p=9,139");
        }
        else
        {
            MessageControl1.SetMessage("You Exceed the Staff Limit. Kindly Contact Saibex Network", MessageDisplay.DisplayStyles.Error);
        }  
    }

    protected void Griddealers_RowDataBound(object sender, GridViewRowEventArgs e)
    {

      
    }
    protected void btnstf_Click(object sender, EventArgs e)
    {
        Response.Redirect("Staff.aspx?p=9,139");
    }
    protected void BtnExport_Click(object sender, EventArgs e)
{ 
        LabelAccess objlabelAccess = new LabelAccess();
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(Session["companyid"].ToString()));
        try
        {
            string sql = "select row_number() over(order by s.StaffName asc)as Sr, s.StaffName,rm.Rolename, s.Addr1, s.Addr2, s.Addr3, s.City, s.Mobile,"
                      + " s.Email, dep.DepartmentName, desg.DesignationName, br.BranchName, convert(varchar(10),s.DateOfJoining,103) as DateOfJoining , s.HourlyCharges, s.CurMonthSal, s.username, s.password, Qual, YrGd, YrPG, YrRj,s.staffBioServerid as EMPId "
                       + " FROM dbo.Staff_Master as s LEFT OUTER JOIN tbl_RoleMaster rm on s.Staff_roll =rm.RoleID LEFT OUTER JOIN dbo.Branch_Master as br ON s.BrId = br.BrId LEFT OUTER JOIN dbo.Department_Master as dep ON s.DepId = dep.DepId LEFT OUTER JOIN "
                     + " dbo.Designation_Master  as desg ON s.DsgId = desg.DsgId where s.CompId='" + ViewState["compid"].ToString() + "' and s.IsDeleted<>'True' and s.DateOfLeaving IS NULL order by s.StaffName";
            DataTable dt = db.GetDataTable(sql);

            foreach (DataColumn col in dt.Columns)
            {
                col.ColumnName = changelabel(col.ColumnName);
            }
                        if (dt.Rows.Count > 0)
            {
                dt.Columns[17].ColumnName = "Qualification";
                dt.Columns[18].ColumnName = "Yr of Grad";
                dt.Columns[19].ColumnName = "Yr of P. Grad";
                dt.Columns[20].ColumnName = "Date of Re-join";
                dt.AcceptChanges();
                DumpExcel(dt);
            }
            else
            {
                MessageBox.Show("No Records To Export");
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }


    private void DumpExcel(DataTable tbl)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Staff_Master");

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            ws.Cells["A1"].LoadFromDataTable(tbl, true);

            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:AI1"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }
                using (var memoryStream = new MemoryStream())
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=Staff.xlsx");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }




    protected void Gridtimesheetdetails_PageIndexChanging1(object sender, GridViewPageEventArgs e)
    {

    }
    protected void Gridtimesheetdetails_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {

    }
    protected void Gridtimesheetdetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
    protected void Gridtimesheetdetails_RowEditing(object sender, GridViewEditEventArgs e)
    {

    }
    protected void Gridtimesheetdetails_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {

    }

    protected void btnpage_Click(object sender, EventArgs e)
    {

        Session["staff"] = hdnStfcode.Value;

        Response.Redirect("EditStaffDetails.aspx");
    }
    
   

    public string changelabel(string ChangeLabel)
    {
        try
        {
            string s, r;
            foreach (var item in LtblAccess)
            {
                r = item.LabelName;
                s = item.LabelAccessValue;
                ChangeLabel = ChangeLabel.Replace(r, s);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ChangeLabel;
    }

}


