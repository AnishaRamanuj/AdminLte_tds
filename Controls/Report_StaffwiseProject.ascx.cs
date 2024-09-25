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
public partial class controls_Report_StaffwiseProject : System.Web.UI.UserControl
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
                if (Session["Jr_ApproverId"] == "true")
                {
                    Session["StaffType"] = "App";
                }

            }
            string dat = DateTime.Now.Month + "/" + DateTime.Now.Year;
            txtmonth.Text = dat;
            //getCompanyData(hdnCompid.Value);
            //if (IsCSV == "True")
            //{
            //    btnCSV.Visible = true;
            //}
        }

        txtmonth.Attributes.Add("onkeyup", "CountFrmTitle(this);");
    }

    private void getCompanyData(string compid)
    {
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);
            DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_getCompanyData", param);
            IsCSV = ds.Tables[0].Rows[0]["IsCSV"].ToString();
            deci = ds.Tables[0].Rows[0]["Timesheet_Decimals"].ToString();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    protected void btngen_Click(object sender, EventArgs e)
    {
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
        string ReportName = "";
        if (hdnstaffcode.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one staff !", MessageDisplay.DisplayStyles.Error);
            return;
        }
        if (hdnprojectid.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
            return;
        }
        string s = "";
        DateTime strdate = Convert.ToDateTime(txtmonth.Text, ci);
        string thisMonth = strdate.ToString("MMMM");
        string mon = strdate.Month.ToString();
        string year = strdate.ToString("yyyy");
        int comp = Convert.ToInt32(hdnCompid.Value);
        getCompanyData(comp.ToString());
        DataSet dsss = getdata(comp);
        if (dsss.Tables != null && dsss.Tables[0].Rows.Count > 0)
        {
            DataTable dt = new DataTable();
            dt = dsss.Tables[0];
            Session["dt"] = dt;

            Session["monthdate"] = txtmonth.Text;
            Response.Redirect("~/ProjectWiseDetailsForm.aspx");
        }
        else
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
            SqlCommand cmd = new SqlCommand("usp_GetProjectWiseDetails", sqlConn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@ProjectId", hdnprojectid.Value.Trim(','));
            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            sda.Fill(ds);
            cmd.CommandTimeout = 999999999;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
            sqlConn.Close();
        }

        catch (Exception ex)
        {
            throw ex;
        }
        return ds;
    }
    



}