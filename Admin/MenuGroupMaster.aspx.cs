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

public partial class Admin_MenuGroupMaster : System.Web.UI.Page
{
    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            gv_mainmenu.DataBind();
            bindgrid();
            showpage();
          
        }
        // bindgrid();
    }

    private void showpage()
    {
        div1.Visible = false;
        div2.Visible = true;
        gv_mainmenu.Visible = true;
    }

    private void bindgrid()
    {
        try
        {
            con.Open();

            DataSet ds = new DataSet();
            SqlParameter[] objsqlparameter = new SqlParameter[1];
            objsqlparameter[0] = new SqlParameter("@search", txtSearch.Text);
            ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "bindname", objsqlparameter);
            gv_mainmenu.DataSource = ds;
            gv_mainmenu.DataBind();
         

        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }
        finally { con.Close(); }
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        MessageControl2.SetMessage("", MessageDisplay.DisplayStyles.None);
        int res = 0;
        try
        {
            con.Open();
            SqlParameter[] objSqlParameter = new SqlParameter[6];
            objSqlParameter[0] = new SqlParameter("@name", txtname.Text);
            objSqlParameter[1] = new SqlParameter("@PageName", txtpagename.Text);
            objSqlParameter[2] = new SqlParameter("@pagestatus", ddlpagestatus.Text);
            objSqlParameter[3] = new SqlParameter("@submenu", ddlsubmenu.SelectedValue);
            if (ddlsubmenu.SelectedValue == "1")
            {
                objSqlParameter[4] = new SqlParameter("@submenuname", txtsubpage.Text);
            }
            else
            {
                objSqlParameter[4] = new SqlParameter("@submenuname", "");
            }
           
            objSqlParameter[5] = new SqlParameter("@hid", Hid_id.Value);
            res = SqlHelper.ExecuteNonQuery(con,CommandType.StoredProcedure, "insupdtname", objSqlParameter);
            con.Close();
            if (res > 0)
            {
                showpage();
                bindgrid();
                MessageControl2.SetMessage("Your data saves successfully", MessageDisplay.DisplayStyles.Success);
            }
            else
            {
                MessageControl2.SetMessage("error...", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {
            var s = ex.Message.Split(' ');
            if (s != null)
            {
                if (s[5] == "'IX_GroupingMenuMaster_1'.")
                {
                    MessageControl2.SetMessage("Group Order already exist", MessageDisplay.DisplayStyles.Warning);
                }
                else if (s[5] == "'IX_GroupingMenuMaster'.")
                {
                    MessageControl2.SetMessage("Group Name already exist", MessageDisplay.DisplayStyles.Warning);
                }
                else
                {
                    MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
                }
            }

        }
        finally
        {
            if (con.State.ToString() == "Open")
                con.Close();
        }
    }
    public void gv_rowcommand1(object sender, GridViewCommandEventArgs e)
    {
        Hid_id.Value = e.CommandArgument.ToString();
        if (e.CommandName == "myedit")
        {
            txtname.Text = "";
           
            try
            {
                con.Open();

                DataSet ds = new DataSet();
                SqlParameter[] objSqlParameter = new SqlParameter[1];
                objSqlParameter[0] = new SqlParameter("@hid", Hid_id.Value);
                ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "nameedit", objSqlParameter);
                con.Close();
                txtname.Text = ds.Tables[0].Rows[0]["name"].ToString();
                txtpagename.Text = ds.Tables[0].Rows[0]["PageName"].ToString();
                ddlpagestatus.Text = ds.Tables[0].Rows[0]["PageStatus"].ToString();
                ddlsubmenu.SelectedValue = ds.Tables[0].Rows[0]["SubMenu"].ToString();
                txtsubpage.Text = ds.Tables[0].Rows[0]["SubName"].ToString();
                showpage2();
                MessageControl2.SetMessage("", MessageDisplay.DisplayStyles.None);
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

                DataSet ds = new DataSet();
                SqlParameter[] objSqlParameter = new SqlParameter[1];
                objSqlParameter[0] = new SqlParameter("@hid", Hid_id.Value);
                SqlHelper.ExecuteNonQuery(con, CommandType.StoredProcedure, "namedelete", objSqlParameter);
                MessageControl2.SetMessage("Your Data Deleted Successfully", MessageDisplay.DisplayStyles.Success); 
                con.Close();
                bindgrid();

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
                    con.Open();
                    DataSet ds = new DataSet();
                    SqlParameter[] objSqlParameter = new SqlParameter[1];
                    objSqlParameter[0] = new SqlParameter("@hid", Hid_id.Value);
                    ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "upmenu", objSqlParameter);
                    con.Close();
                    bindgrid();
                }
                catch (Exception ex)

                {
                    MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
                }
            }
            if (e.CommandName == "DOWN")
            {

                try
                {
                    con.Open();
                    DataSet ds = new DataSet();
                    SqlParameter[] objSqlParameter = new SqlParameter[1];
                    objSqlParameter[0] = new SqlParameter("@hid", Hid_id.Value);
                    ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "downmenu", objSqlParameter);
                    con.Close();
                    bindgrid();
                }
                catch (Exception ex)
                {
                    MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
                }
            }
        

    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        showpage2();
        Clear();
        Hid_id.Value = "0";
     
    }

    private void Clear()
    {
        txtname.Text = "";
        MessageControl2.SetMessage("", MessageDisplay.DisplayStyles.None);
        txtpagename.Text = "";
        txtsubpage.Text = "";
        ddlsubmenu.ClearSelection();
        ddlpagestatus.ClearSelection();
       
    }

    private void showpage2()
    {
        div1.Visible = true;
        div2.Visible = false;
        gv_mainmenu.Visible = false;
    }
    protected void btncancel_Click(object sender, EventArgs e)
    {
        showpage();
        Clear();

    }
    protected void btnsearch_Click(object sender, EventArgs e)
    {
        bindgrid();
        Clear();
    }
   

    
}