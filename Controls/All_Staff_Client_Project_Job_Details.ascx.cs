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

public partial class controls_All_Staff_Client_Project_Job_Details : System.Web.UI.UserControl
{
   
     LabelAccess objlabelAccess = new LabelAccess();
    List<CommonLibrary.tbl_LabelAccess> LtblAccess;
    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    string UserType = "";
    protected void Page_Load(object sender, EventArgs e)
    {
       

        if (!IsPostBack)
        {
            if (Session["companyid"].ToString() != null) {
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
            txtto.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            if (DateTime.Now.Month < 4)
            {
                txtfrom.Text = "01/04/" + (DateTime.Now.Year - 1);
            }
            else {
                txtfrom.Text = "01/04/" + (DateTime.Now.Year);
            }

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
     
        int comp = Convert.ToInt32(hdnCompid.Value);
        ReportViewer1.ProcessingMode = ProcessingMode.Local;
        ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Rrport_All_Staff_Client_Project_Job_Details.rdlc");
        ReportName = objlabelAccess.changelabel("Projectwise Staff columnar Report - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
        DataSet dsss = getdata(comp);
        ReportDataSource datasource = new ReportDataSource("DataSet1", dsss.Tables[0]);
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.LocalReport.DataSources.Add(datasource);
        ReportParameter[] parameters = new ReportParameter[7];
        parameters[0] = new ReportParameter("companyname", Convert.ToString(Session["CompanyName"]).Trim());
        parameters[1] = new ReportParameter("date", ": " + txtfrom.Text + "To " + txtto.Text);
        parameters[2] = new ReportParameter("reportname", ": " + ReportName);
        parameters[3] = new ReportParameter("printedby", ": " + Convert.ToString(Session["Name"]).Trim());
        parameters[4] = new ReportParameter("printeddate", ": " + DateTime.Now.ToString());
        parameters[5] = new ReportParameter("Expense", ": " + "Expense");
        parameters[6] = new ReportParameter("ExpenseCharges", ": " + "Expense+Charges");
    

        this.ReportViewer1.LocalReport.SetParameters(parameters);
        ReportViewer1.LocalReport.Refresh();
        divReportInput.Visible = false;
        ReportViewer1.Visible = true;
        btnBack.Visible = true;
    }
    public DataSet getdata(int comp)
    {
        DataSet ds = new DataSet();
        try
        {


            DateTime strdate = Convert.ToDateTime(txtfrom.Text, ci);
            DateTime end = Convert.ToDateTime(txtto.Text, ci);
            SqlCommand cmd = new SqlCommand("usp_Report_All_Staff_Client_Project_Job_Task_details", sqlConn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@compid", hdnCompid.Value);
            cmd.Parameters.AddWithValue("@UserType", UserType);
            cmd.Parameters.AddWithValue("@status", hdnTStatusCheck.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@Staff", hdnstaffcode.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@from", strdate);
            cmd.Parameters.AddWithValue("@end", end);
            cmd.Parameters.AddWithValue("@Client", hdncltid.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@Project", hdnprojectid.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@job", hdnjobids.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@StaffCode", hdnstaffid.Value);
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
    protected void btnBack_Click(object sender, EventArgs e)
    {
        divReportInput.Visible = true;
        ReportViewer1.Visible = false;
        btnBack.Visible = false;
    }
    
}