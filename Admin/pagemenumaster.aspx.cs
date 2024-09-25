using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data.Sql;
using System.Configuration;
using System.Data;
using Microsoft.ApplicationBlocks1.Data;

public partial class Admin_pagemenumaster : System.Web.UI.Page
{
    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindddlgrpmenu();
            bindpagemenu();
            showpage2();

        }
    }

    private void bindpagemenu()
    {
        try
        {
            DataSet ds = new DataSet();
            SqlParameter[] objparameter = new SqlParameter[1];
            objparameter[0] = new SqlParameter("@search", txtSearch.Text);
            ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "bindpagemenu", objparameter);
            gv_pagemenu.DataSource = ds;
            gv_pagemenu.DataBind();
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage("error....", MessageDisplay.DisplayStyles.Error);
        }
    }

    private void bindddlgrpmenu()
    {
        DataSet ds = new DataSet();
        ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "bindddlgrpmenu");
        ddlgroupname.DataSource = ds;
        ddlgroupname.DataTextField = "Name";
        ddlgroupname.DataValueField = "ID";
        ddlgroupname.DataBind();
        ddlgroupname.Items.Insert(0, new ListItem("Please select Group Name", "0"));
        ddlgroupname.SelectedValue = "0";
    }
    public void clear()
    {
        txtmenutitle.Text = "";
        txtsubpage.Text = "";
        txtpagename.Text = "";
        ddlgroupname.ClearSelection();
        ddlpagestatus.ClearSelection();
        chkdefault.Checked = false;
        chkstaff.Checked = false;
        MessageControl2.SetMessage("", MessageDisplay.DisplayStyles.None);
    }
    public void showpage1()
    {
        div1.Visible = true;
        div2.Visible = false;
        div3.Visible = false;
    }
    public void showpage2()
    {
        div2.Visible = true;
        div3.Visible = true;
        div1.Visible = false;

    }
    protected void btncancel_Click(object sender, EventArgs e)
    {
        showpage2();
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        showpage1();
        MessageControl2.SetMessage("", MessageDisplay.DisplayStyles.None);
        Hid_id.Value = "0";
        clear();

    }
    protected void btnsubmit_Click(object sender, EventArgs e)
    {

        int res = 0;
        try
        {
            con.Open();
            SqlParameter[] objSqlParameter = new SqlParameter[9];
            objSqlParameter[0] = new SqlParameter("@grpid", ddlgroupname.SelectedValue);
            objSqlParameter[1] = new SqlParameter("@menutitle", txtmenutitle.Text);
            objSqlParameter[2] = new SqlParameter("@pagename", txtpagename.Text);
            objSqlParameter[3] = new SqlParameter("@pagestatus", ddlpagestatus.Text);
            objSqlParameter[4] = new SqlParameter("@submenu", ddlsubmenu.SelectedValue);

            if (ddlsubmenu.SelectedValue == "1")
            {
                objSqlParameter[5] = new SqlParameter("@submenuname", txtsubpage.Text);
            }
            else
            {
                objSqlParameter[5] = new SqlParameter("@submenuname", "");
            }
            objSqlParameter[6] = new SqlParameter("@default", chkdefault.Checked);
            objSqlParameter[7] = new SqlParameter("@hid", Hid_id.Value);
            objSqlParameter[8] = new SqlParameter("@staffdefault",chkstaff.Checked);
            res = SqlHelper.ExecuteNonQuery(con, CommandType.StoredProcedure, "insupdtpagemenu", objSqlParameter);
            con.Close();
            if (res > 0)
            {
                MessageControl2.SetMessage("Your Data Saved Successfully", MessageDisplay.DisplayStyles.Success);
                showpage2();
                bindpagemenu();

            }
            else
            {
                MessageControl2.SetMessage("error...or data already exist", MessageDisplay.DisplayStyles.Error);
            }
        }

        catch (Exception ex)
        {
            var s = ex.Message.Split(' ');
            if (s != null)
            {
                if (s[5] == "'IX_PageManuMaster'.")
                {
                    MessageControl2.SetMessage("Page Order already exist", MessageDisplay.DisplayStyles.Info);
                }
                else if (s[5] == "'IX_PageManuMaster_1'.")
                {
                    MessageControl2.SetMessage("Page Name already exist", MessageDisplay.DisplayStyles.Info);
                }
                else
                { MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error); }
            }

        }



        finally
        {
            if (con.State.ToString() == "Open")
                con.Close();
        }

    }

    protected void rowcommandpagemenu(object sender, GridViewCommandEventArgs e)
    {
        Hid_id.Value = e.CommandArgument.ToString();
        if (e.CommandName == "myedit")
        {
            clear();
            try
            {
                con.Open();
                DataSet ds = new DataSet();
                SqlParameter[] objSqlParameter = new SqlParameter[1];
                objSqlParameter[0] = new SqlParameter("@hid", Hid_id.Value);
                ds = SqlHelper.ExecuteDataset(con, "editpagemenu", objSqlParameter);
                ddlgroupname.SelectedValue = ds.Tables[0].Rows[0]["GROUP_ID"].ToString();
                txtmenutitle.Text = ds.Tables[0].Rows[0]["Menu_Title"].ToString();
                txtpagename.Text = ds.Tables[0].Rows[0]["PageName"].ToString();

                ddlpagestatus.Text = ds.Tables[0].Rows[0]["PageStatus"].ToString();
                ddlsubmenu.SelectedValue = ds.Tables[0].Rows[0]["SubMenu"].ToString();
                txtsubpage.Text = ds.Tables[0].Rows[0]["SubName"].ToString();
                chkdefault.Checked = Convert.ToBoolean(ds.Tables[0].Rows[0]["default_page"]);
                chkstaff.Checked = Convert.ToBoolean(ds.Tables[0].Rows[0]["defaultstaff_page"]);
                showpage1();
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
                con.Open();
                SqlParameter[] objSqlParameter = new SqlParameter[1];
                objSqlParameter[0] = new SqlParameter("@hid", Hid_id.Value);
                SqlHelper.ExecuteNonQuery(con, "deletepagemenu", objSqlParameter);
                bindpagemenu();
                MessageControl2.SetMessage("Data deleted successfully", MessageDisplay.DisplayStyles.Success);
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
        if (e.CommandName == "UP")
        {
            try
            {
                SqlParameter[] objSqlParameter = new SqlParameter[1];
                objSqlParameter[0] = new SqlParameter("@hid", Hid_id.Value);
                SqlHelper.ExecuteNonQuery(con, "usp_pagemenumaster_upmenu", objSqlParameter);
                bindpagemenu();

            }
            catch (Exception ex)
            { MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error); }
        }
        if (e.CommandName == "DOWN")
        {
            try
            {
                SqlParameter[] objSqlParameter = new SqlParameter[1];
                objSqlParameter[0] = new SqlParameter("@hid", Hid_id.Value);
                SqlHelper.ExecuteNonQuery(con, "usp_pagemenumaster_downpmenu", objSqlParameter);
                bindpagemenu();

            }
            catch (Exception ex)
            { MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error); }
        }
    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {
        bindpagemenu();
    }

}