using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using Microsoft.Reporting.WebForms;
using CommonLibrary;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Configuration;

public partial class controls_AllClientProjectJobTask : System.Web.UI.UserControl
{
    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    CultureInfo info = new CultureInfo("en-GB");
    string UserType = "";
    LabelAccess objlabelAccess = new LabelAccess();
    List<tbl_LabelAccess> LtblAccess;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtstartdate1.Text = "01/04/" + (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year);
            txtenddate2.Text = Convert.ToDateTime(DateTime.Now, info).ToString("dd/MM/yyyy");
            hdnCompid.Value = Session["companyid"].ToString();
            if (Session["usertype"] != null)
            {
                UserType = Session["usertype"].ToString();
            }
            else
            {
                Session["companyid"] = null; 
                Session["cltcomp"] = null; 
            }
            hdnUserType.Value = UserType;
            if (UserType == "staff")
            {
                hdnStaffCode.Value = Session["staffid"].ToString();

            }

            if (UserType == "staff")
            {
                if (Session["Jr_ApproverId"] == "true")
                {
                    Session["StaffType"] = "App";
                }

            }
        }
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        string ReportName = "";
        int comp = Convert.ToInt32(hdnCompid.Value);
        DateTime FDT = Convert.ToDateTime(txtstartdate1.Text, info);
        DateTime EDT = Convert.ToDateTime(txtenddate2.Text, info);
        ReportViewer1.ProcessingMode = ProcessingMode.Local;
        if (rdetailed.Checked)
        {
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_AllClientProjectJobTask_details.rdlc");
            ReportName = objlabelAccess.changelabel("All Client Project Job And Task Detailed", LtblAccess);
        }
        else
        {
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_AllClientProjectJobTask_Summerised.rdlc");
            ReportName = objlabelAccess.changelabel("All Client Project Job And Task Summerised", LtblAccess);
        }
        DataSet dsss = Getdata(comp, FDT, EDT);
        ReportDataSource datasource = new ReportDataSource("DataSet1", dsss.Tables[0]);
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.LocalReport.DataSources.Add(datasource);
        ReportParameter[] parameters = new ReportParameter[7];
        parameters[0] = new ReportParameter("CompanyName", Convert.ToString(Session["CompanyName"]).Trim());
        parameters[1] = new ReportParameter("Period", ": " + FDT.ToString("dd/MM/yyyy").Trim() + " to " + EDT.ToString("dd/MM/yyyy").Trim());
        parameters[2] = new ReportParameter("ReportName", ": " + ReportName);
        parameters[3] = new ReportParameter("PrintedBy", ": " + Convert.ToString(Session["Name"]).Trim());
        parameters[4] = new ReportParameter("opecharges", " " + objlabelAccess.changelabel("Charge + Expense", LtblAccess));
        parameters[5] = new ReportParameter("expense", objlabelAccess.changelabel("Expense", LtblAccess));
        parameters[6] = new ReportParameter("Printdate",":"+ DateTime.Now);
        this.ReportViewer1.LocalReport.SetParameters(parameters);
        ReportViewer1.LocalReport.DisplayName = ReportName;
        ReportViewer1.LocalReport.Refresh();
        dvreportinput.Visible = false;
        ReportViewer1.Visible = true;
        btnBack.Visible = true;
    }

    private DataSet Getdata(int comp, DateTime FDT, DateTime EDT)
    {
        DataSet ds = new DataSet();
        try
        {

            SqlParameter[] parameter = new SqlParameter[10];
            parameter[0] = new SqlParameter("@compid",comp);
            parameter[1] = new SqlParameter("@taskid",hdnSelectedtask.Value.TrimEnd(','));
            parameter[2] = new SqlParameter("@from",FDT);
            parameter[3] = new SqlParameter("@end",EDT);
            parameter[4] = new SqlParameter("@statuschk", hdnTStatusCheck.Value);
            parameter[5] = new SqlParameter("@Client",hdnselectedclientid.Value.TrimEnd(','));
            parameter[6] = new SqlParameter("@Project", hdnselectedprojectid.Value.TrimEnd(','));
            parameter[7] = new SqlParameter("@jobid", hdnselectedjob.Value.TrimEnd(','));
            parameter[8] = new SqlParameter("@StaffCode", hdnStaffCode.Value == "" ? "0" : hdnStaffCode.Value);
            parameter[9] = new SqlParameter("@UserType", hdnUserType.Value);
            if (rdetailed.Checked)
            {
                ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_AllClientProjectJobTask_details", parameter);
            }
            else
            {
                ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_AllClientProjectJobTask_Summerised", parameter);
            }

        }

        catch (Exception ex)
        {
            MessageControl1.SetMessage("error" + ex, MessageDisplay.DisplayStyles.Error);
        }
        return ds;
    }
    protected void btnBack_Click(object sender, EventArgs e)
    {
        dvreportinput.Visible = true;
        ReportViewer1.Visible = false;
        btnBack.Visible = false;
    }
}