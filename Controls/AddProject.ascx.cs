using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.ApplicationBlocks1.Data;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Configuration;
using JTMSProject;
using System.Globalization;


public partial class controls_AddProject : System.Web.UI.UserControl
{
    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    int pgSize = 25;
    int pageid = 159;
    private readonly DBAccess db = new DBAccess();
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    CultureInfo ci = new CultureInfo("en-GB");
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
                string Link_Pronclt = objDAL_PagePermissions.Dal_getPronClt(Convert.ToInt32(Session["companyid"]));
                hdnlink.Value = Link_Pronclt;
                Binddropdown();
                if (Link_Pronclt == "0")
                {
                    bindclient();
                }
                GetPageData(1, pgSize);
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        string objL = objDAL_PagePermissions.Dal_getRolepermission(pageid, Convert.ToInt32(Session["UserRole"]), Convert.ToInt32(Session["companyid"]));

        hidpermission.Value = objL;
        bool a = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "add");
        if (a == false)
        { btnaddproject.Visible = false; }
        bool edit = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "edit");
        if (edit == false)
        {
            ((DataControlField)gvProjects.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Edit"))
                .SingleOrDefault()).Visible = false;
        }
        bool d = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "delete");
        if (d == false)
        {
            ((DataControlField)gvProjects.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Delete"))
                .SingleOrDefault()).Visible = false;

        }


        txtsearch.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtprojectname.Attributes.Add("onkeyup", "CountFrmTitle(this,60);");

    }

    private void GetPageData(int currentpage, int pagesize)
    {
        try
        {   //// usp_Project_GetRecords
            //// usp_getrecords
            string Proc = "";
            if (hdnlink.Value == "1")
            {
                Proc = "usp_Project_GetRecords";
            }
            else
            {
                Proc = "usp_getrecords";
            }
            DataSet ds = new DataSet();
            SqlParameter[] objSqlParameter = new SqlParameter[5];
            objSqlParameter[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"]).ToString());
            objSqlParameter[1] = new SqlParameter("@PageIndex", currentpage);
            objSqlParameter[2] = new SqlParameter("@PageSize", pagesize);
            objSqlParameter[3] = new SqlParameter("@search", txtsearch.Text);
            objSqlParameter[4] = new SqlParameter("@ProjectClient", ddlProjectClient.SelectedValue);
            ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, Proc, objSqlParameter);

            int totalcount = 0;
            if (ds.Tables[0].Rows.Count > 0)
            {
                totalcount = Convert.ToInt32(ds.Tables[0].Rows[0]["totalcount"].ToString());
                lblCount.Text = '(' + Convert.ToString(totalcount) + ')';
                lblTotalRecords.Text = "Showing " + Convert.ToInt32(ds.Tables[0].Rows[0]["sino"].ToString()) + " to " + Convert.ToInt32(ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["sino"].ToString()) + " of " + totalcount + " entries.";
            }

            gvProjects.DataSource = ds;
            gvProjects.DataBind();
            PopulatePager(totalcount, currentpage);


        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage("Bind project data" + ex.Message, MessageDisplay.DisplayStyles.Error);
        }
    }

    private void PopulatePager(int totalcount, int currentpage)
    {
        double dblPageCount = (double)((decimal)totalcount / pgSize);
        int pageCount = (int)Math.Ceiling(dblPageCount);
        List<ListItem> pages = new List<ListItem>();
        if (pageCount > 0)
        {
            pages.Add(new ListItem("First", "1", currentpage > 1));
            for (int i = 1; i <= pageCount; i++)
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
        this.GetPageData(pageIndex, pgSize);
    }


    private void bindclient()
    {
        try
        {
            DataSet ds = new DataSet();
            SqlParameter[] objSqlParameter = new SqlParameter[1];
            objSqlParameter[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"]).ToString());
            ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_getclient", objSqlParameter);
            ddlClient.DataSource = ds;
            ddlClient.DataTextField = "ClientName";
            ddlClient.DataValueField = "cltid";
            ddlClient.DataBind();
            ddlClient.Items.Insert(0, new ListItem("Please select Client Name", "0"));
            ddlClient.SelectedValue = "0";
        }
        catch (Exception e)
        {
            MessageControl2.SetMessage("Error to Show Client", MessageDisplay.DisplayStyles.Error);
        }
    }

    protected void btnsaveproject_Click(object sender, EventArgs e)
    {
        savingproject();
    }

    private void savingproject()
    {
        try
        {
            string s = "";
            if (txtactualdate.Text == "")
            {

                ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage", "Enddate();", true);
                ModalPopupExtender2.Show();
                hdnOnblur.Value = "0";
                return;
            }
            else
            {
                if (txtstartdate.Text == "")
                {

                    ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage", "StartDate();", true);
                    ModalPopupExtender2.Show();
                    hdnOnblur.Value = "0";
                    return;
                }
                else
                {
                    var S1 = new DateTime();
                    var S2 = new DateTime();
                    var info = new CultureInfo("en-US", false);
                    String _dateFormat = "dd/MM/yyyy";
                    s = txtstartdate.Text;
                    if (s.Trim() != "" && !DateTime.TryParseExact(s.Trim(), _dateFormat, info, DateTimeStyles.AllowWhiteSpaces, out S1))
                    {

                    }
                    s = txtactualdate.Text;
                    if (s.Trim() != "" && !DateTime.TryParseExact(s.Trim(), _dateFormat, info, DateTimeStyles.AllowWhiteSpaces, out S2))
                    {

                    }

                    if (S2 < S1)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alertMessage", "alertMessage();", true);
                        ModalPopupExtender2.Show();
                        hdnOnblur.Value = "0";
                        return;
                    }
                }

            }

             SqlParameter[] objSqlParameter = new SqlParameter[12];
            objSqlParameter[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"]).ToString());
            objSqlParameter[1] = new SqlParameter("@projectname", txtprojectname.Text);
            if (hdnlink.Value  == "1")
            {
                int j = 0;
                objSqlParameter[2] = new SqlParameter("@clientid", j);
            }
            else
            {
                objSqlParameter[2] = new SqlParameter("@clientid", ddlClient.SelectedValue);
            }
            
            objSqlParameter[3] = new SqlParameter("@projecthours", txtprojecthour.Text);
            objSqlParameter[4] = new SqlParameter("@projectamount", txtprojectamount.Text);
            objSqlParameter[5] = new SqlParameter("@hid", hdnprojectid.Value);
            objSqlParameter[6] = new SqlParameter("@usedamount", txtusedhours.Text);
            objSqlParameter[7] = new SqlParameter("@currency", drpcash.Text);
            objSqlParameter[8] = new SqlParameter("@startDT", Convert.ToDateTime(txtstartdate.Text, ci));
            objSqlParameter[9] = new SqlParameter("@endDT", Convert.ToDateTime(txtactualdate.Text, ci));
            objSqlParameter[10] = new SqlParameter("@Status", drpstatus.SelectedValue);
            objSqlParameter[11] = new SqlParameter("@productLine", txtpdtLine.Text);

            SqlHelper.ExecuteNonQuery(con, CommandType.StoredProcedure, "usp_getprojectdata", objSqlParameter);
            MessageControl2.SetMessage("Your Data Saved Successfully....", MessageDisplay.DisplayStyles.Success);
            txtsearch.Text = "";
            GetPageData(1, pgSize);
            

        }
        catch (SqlException e)
        {
            if (e.Number == 18054)
            {
                MessageControl2.SetMessage("The Project with this Client is Already Exist", MessageDisplay.DisplayStyles.Error);
            }
        }
    }
    public void clear()
    {
        txtprojectamount.Text = "";
        txtprojecthour.Text = "";
        txtprojectname.Text = "";
        txtstartdate.Text = "";
        txtactualdate.Text = "";
        drpcash.ClearSelection();  
        ddlClient.ClearSelection();
    }
   
    protected void projects_alters(object sender, GridViewCommandEventArgs e)
    {
        hdnprojectid.Value = e.CommandArgument.ToString();
        if (e.CommandName == "myedit")
        {
            clear();
            try
            {
                con.Open();
                DataSet ds = new DataSet();
                SqlParameter[] objSqlParameter = new SqlParameter[1];
                objSqlParameter[0] = new SqlParameter("@hid", hdnprojectid.Value);
                ds = SqlHelper.ExecuteDataset(con, "editproject", objSqlParameter);
                txtprojectname.Text = ds.Tables[0].Rows[0]["ProjectName"].ToString();
                txtprojecthour.Text = ds.Tables[0].Rows[0]["Project_Hours"].ToString();
                txtprojectamount.Text = ds.Tables[0].Rows[0]["Project_Amount"].ToString();
                if (hdnlink.Value == "1")
                {
                    ddlClient.SelectedValue = "0";

                }
                else
                {
                    ddlClient.SelectedValue = ds.Tables[0].Rows[0]["ClientID"].ToString();
                }
                txtusedhours.Text = ds.Tables[0].Rows[0]["used_hours"].ToString();
                drpcash.SelectedValue  = ds.Tables[0].Rows[0]["currency"].ToString();
                txtstartdate.Text = ds.Tables[0].Rows[0]["startDate"].ToString();
                txtactualdate.Text = ds.Tables[0].Rows[0]["endDate"].ToString();
                if(ds.Tables[0].Rows[0]["JobStatus"].ToString() == "")
                {
                    drpstatus.SelectedValue = "OnGoing";
                }
                else { 
                drpstatus.SelectedValue = ds.Tables[0].Rows[0]["JobStatus"].ToString();
                }
                txtpdtLine.Text = ds.Tables[0].Rows[0]["ProductLine"].ToString();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "asdfkjhnhnaisdhfihi", "$(document).ready(function () {  setTimeout(function(){ ;ShowModalPopup(); }, 500)});", true);
            }
            catch (Exception ex)
            {
                MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
            }
            finally { con.Close(); }
        }
        if (e.CommandName == "mydelete")
        {
            try
            {
                DBAccess.PrintDelete(Session["IP"].ToString() ,"Project Master", Session["fulname"].ToString(), Session["usertype"].ToString(),hdnDT.Value );
                con.Open();
                DataSet ds;
                SqlParameter[] objSqlParameter = new SqlParameter[2];
                objSqlParameter[0] = new SqlParameter("@hid", hdnprojectid.Value);
                objSqlParameter[1] = new SqlParameter("@Compid", Convert.ToInt32(Session["companyid"].ToString()));
                ds = SqlHelper.ExecuteDataset(con,CommandType.StoredProcedure, "usp_deleteproject", objSqlParameter);
               
                if (ds.Tables[0].Rows[0]["ProjectId"].ToString() == "-1")
                {
                    MessageControl2.SetMessage("Project Already Allocated to Job",MessageDisplay.DisplayStyles.Error);
                }
                else
                {

                    MessageControl2.SetMessage("Data deleted successfully", MessageDisplay.DisplayStyles.Success);
                    GetPageData(1, pgSize);
                }
            }
            catch (Exception ex)
            {

                var s = ex.Message.Split(' ');
                if (s != null)
                {
                    if (s[3] == "conflicted")
                    {
                        MessageControl2.SetMessage("Your Data Used SomeWhere", MessageDisplay.DisplayStyles.Info);
                    }
                }
                else
                {
                    MessageControl2.SetMessage("please select valid data", MessageDisplay.DisplayStyles.Error);
                }
            }
            finally { con.Close(); }
        }
    }
   
    protected void btnsrchproject_Click(object sender, EventArgs e)
    {
        
        GetPageData(1, pgSize);

    }

    public void Binddropdown()
    {

        try
        {
            DataSet ds = new DataSet();
            ds = SqlHelper.ExecuteDataset(db.ConString, CommandType.StoredProcedure, "usp_getCurrency");
            drpcash.DataSource = ds;
            drpcash.DataTextField = "Currency";
            drpcash.DataValueField = "Country";
            drpcash.DataBind();
            drpcash.Items.Insert(0, new ListItem("INR"));



        }
        catch (Exception ex)
        {
            throw ex;
        }

    }

}