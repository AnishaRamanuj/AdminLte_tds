using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DataAccessLayer;
using System.Data;
using System.Web.Services;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Web.Script.Serialization;
using System.Globalization;

public partial class controls_AddRoles : System.Web.UI.UserControl
{
    private static int PageSize = 25;
    private static Common objcommon = new Common();
    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["companyid"] == null)
        {
            Response.Redirect("~/Default.aspx");
        }
        txtSearchRoleName.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtRolename.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        if (!IsPostBack)
        {
            hdnCompanyId.Value = Session["companyid"].ToString();
            BindDummyRow();
            rolepermission();
        }
    }


    private void BindDummyRow()
    {
        DataTable dummy = new DataTable();
        dummy.Columns.Add("RowNumber");
        dummy.Columns.Add("RoleName");
        dummy.Columns.Add("RoleID");
        dummy.Rows.Add();
        gvRoleMaster.DataSource = dummy;
        gvRoleMaster.DataBind();
    }

    private void rolepermission()
    {

        DataSet ds = new DataSet();
        SqlParameter[] param = new SqlParameter[4];
        param[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"].ToString()));
        ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_getrolepermission", param);
        if (ds.Tables[0].Rows.Count > 0)
        {
            hidpermitionID.Value = ds.Tables[0].Rows[0]["rolepermitted"].ToString();
        }
    }

    
}