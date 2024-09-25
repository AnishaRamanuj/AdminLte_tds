using JTMSProject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using CommonLibrary;
using Microsoft.ApplicationBlocks1.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class controls_Job_Budgeting : System.Web.UI.UserControl

{
    private readonly DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                hdncompid.Value = Session["companyid"].ToString();
                //hdnIP.Value = Session["IP"].ToString();
                hdnName.Value = Session["fulname"].ToString();
                hdnUser.Value = Session["usertype"].ToString();
                fill_dropdown();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

        }
        //txtbudhrss.Attributes.Add("onkeyup", "isNumber(this);");
    }
    public void fill_dropdown()
    {

        DataSet ds = new DataSet();
        int Compid = Convert.ToInt32(hdncompid.Value.ToString());
        SqlParameter[] param = new SqlParameter[1];
        string sqlConn = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        param[0] = new SqlParameter("@compID", Compid);

        ds = SqlHelper.ExecuteDataset(sqlConn, "usp_Get_Job_Budgeting_ProjectName_cilentname", param);
        if (ds.Tables[0].Rows.Count > 0)
        {
            ddlProject.Items.Clear();

            ddlProject.DataValueField = "jobid";
            ddlProject.DataTextField = "name";
            ddlProject.DataSource = ds.Tables[0];
            ddlProject.DataBind();
            ddlProject.Items.Insert(0, new ListItem("Select", "0"));
        }


    }
}