using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Globalization;
using System.Data;
using Microsoft.Reporting.WebForms;
using System.Text;


public partial class controls_Report_JobWisePeriod : System.Web.UI.UserControl
{
    LabelAccess objlabelAccess = new LabelAccess();
    List<CommonLibrary.tbl_LabelAccess> LtblAccess;
    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    string UserType = "";
    string IsCSV = "False";
    string deci = "False";
    protected void Page_Load(object sender, EventArgs e)
    {


        if (!IsPostBack)
        {
            if (Session["companyid"].ToString() != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            if (Session["usertype"] != null)
            {
                UserType = Session["usertype"].ToString();
            }
            else
            { Session["companyid"] = null; Session["cltcomp"] = null; }
            hdnUserType.Value = UserType;
            if (UserType == "staff")
            {
                hdnstaffid.Value = Session["staffid"].ToString();

            }

            if (UserType == "staff")
            {
                if (Session["Jr_ApproverId"].ToString() == "true")
                {
                    Session["StaffType"] = "App";
                }

            }
            string dat = DateTime.Now.Month + "/" + DateTime.Now.Year;
            txtmonth.Text = dat;
        }
    }

    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"].ToString() != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
                string ReportName = "";
                if (hdnjobids.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one job !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                string s = "";
                int comp = Convert.ToInt32(hdnCompid.Value);
                DataSet dsss = getdata(comp);
                if (dsss.Tables != null && dsss.Tables[0].Rows.Count > 0)
                {
                    DataTable dt = new DataTable();
                    DataTable dtdays = new DataTable();
                    dt = dsss.Tables[0];
                    dtdays = dsss.Tables[1];
                    Session["dt"] = dt;
                    Session["dtdays"] = dtdays;

                    Response.Redirect("~/MHLJobWiseForm.aspx");
                }
                else
                {
                    MessageControl1.SetMessage("No Records Found", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                Response.Redirect("~/Report_JobWisePeriod.aspx");
            }
        }
        catch(Exception ex)
        {
            MessageControl1.SetMessage("No Records Found", MessageDisplay.DisplayStyles.Error);
        }
    }
    public DataSet getdata(int comp)
    {
        DataSet ds = new DataSet();
        try
        {
            DateTime strdate = Convert.ToDateTime(txtmonth.Text, ci);
            string sp = "usp_GetMHLJobWise";
            SqlCommand cmd = new SqlCommand(sp, sqlConn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@JobID", hdnjobids.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@CompId", hdnCompid.Value);
            cmd.Parameters.AddWithValue("@monthdate", strdate);
            cmd.CommandTimeout = 999999999;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            Session["monthdate"] = txtmonth.Text;
        }

        catch (Exception ex)
        {
            throw ex;
        }
        return ds;
    }
    protected void btnBack_Click(object sender, EventArgs e)
    {
        divReportInput.Visible = true;
        //ReportViewer1.Visible = false;
        btnBack.Visible = false;
    }

}