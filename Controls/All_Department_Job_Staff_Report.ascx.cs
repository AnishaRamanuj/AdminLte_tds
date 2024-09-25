using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Globalization;
using System.Data.SqlClient;
using System.Configuration;
using Microsoft.ApplicationBlocks1.Data;
using Microsoft.Reporting.WebForms;
using System.Text;

public partial class controls_All_Department_Job_Staff_Report : System.Web.UI.UserControl
{
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    List<CommonLibrary.tbl_LabelAccess> LtblAccess;
    LabelAccess objlabelAccess = new LabelAccess();
    CultureInfo info = new CultureInfo("en-GB");
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
            //else if (Session["companyid"] == null)
            //{
            //    Response.Redirect("~/Default.aspx");
            //}
             if (Session["staffid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();

            }
             if (ViewState["compid"] != null)
             {
                 if (Session["usertype"] != null)
                 {
                     hdnUserType.Value = Session["usertype"].ToString();
                     if (Session["usertype"] == "staff")
                     {
                         hdnStaffCode.Value = Session["staffid"].ToString();
                     }
                     else
                     {
                         hdnStaffCode.Value = "0";
                     }
                 }
                 else
                 { Session["companyid"] = null; Session["companyid"] = null; }
                 if (Session["usertype"] == "Staff")
                 {
                     hdnStaffCode.Value = Session["staffid"].ToString();
                 }
             }
             else
             {
                 Response.Redirect("~/Default.aspx");
             }
          
            txtstartdate1.Text = "01/04/" + (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year);
            txtenddate2.Text = Convert.ToDateTime(DateTime.Now, info).ToString("dd/MM/yyyy");
        }
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
        string ReportName = "";
        if (hdnSelectedStaffCode.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one Staff !", MessageDisplay.DisplayStyles.Error);
            return;
        }
        if (hdnselectedjobid.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one Job !", MessageDisplay.DisplayStyles.Error);
            return;
        }

        int comp = int.Parse(ViewState["compid"].ToString());
        DateTime FDT = Convert.ToDateTime(txtstartdate1.Text, info);
        DateTime EDT = Convert.ToDateTime(txtenddate2.Text, info);

        ReportViewer1.ProcessingMode = ProcessingMode.Local;
        ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/All_Department_Job_Staff_Report.rdlc");
        ReportName = objlabelAccess.changelabel("All Department Project Staff - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
        DataSet dsss = GetData(comp, FDT, EDT);
        ReportDataSource datasource = new ReportDataSource("DataSet1", dsss.Tables[0]);
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.LocalReport.DataSources.Add(datasource);
        ReportParameter[] parameters = new ReportParameter[7];
        parameters[0] = new ReportParameter("CompanyName", Convert.ToString(Session["fulname"]).Trim());
        parameters[1] = new ReportParameter("Date", ": " + FDT.ToString("dd/MM/yyyy").Trim() + " to " + EDT.ToString("dd/MM/yyyy").Trim());
        parameters[2] = new ReportParameter("reportname", ": " + ReportName);
        parameters[3] = new ReportParameter("printedby", ": " + Convert.ToString(Session["Name"]).Trim());
        parameters[4] = new ReportParameter("printeddate", ": " + DateTime.Now.ToString());
        string p = "";
        p = objlabelAccess.changelabel("JobName", LtblAccess);
        parameters[5] = new ReportParameter("JobName", p);
        string d = "";
        d = objlabelAccess.changelabel("Department", LtblAccess) + ":" + hdnDeptname.Value;
        parameters[6] = new ReportParameter("Department", d);

        this.ReportViewer1.LocalReport.SetParameters(parameters);
        ReportViewer1.LocalReport.Refresh();
        divReportInput.Visible = false;
        ReportViewer1.Visible = true;
        btnBack.Visible = true;
    }




    private DataSet GetData(int comp, DateTime FromDAte, DateTime ToDate)
    {
        DataSet ds = new DataSet();
        try
        {

            SqlParameter[] parameter = new SqlParameter[11];
            parameter[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"]).ToString());
            parameter[1] = new SqlParameter("@UserType", hdnUserType.Value);
            parameter[2] = new SqlParameter("@TStatus", hdnTStatusCheck.Value.TrimEnd(','));
            parameter[3] = new SqlParameter("@StaffCode", hdnStaffCode.Value == "" ? "0" : hdnStaffCode.Value);
            parameter[4] = new SqlParameter("@selectedStaffCode", hdnSelectedStaffCode.Value.TrimEnd(','));
            parameter[5] = new SqlParameter("@FromDate", FromDAte);
            parameter[6] = new SqlParameter("@ToDate", ToDate);
            parameter[7] = new SqlParameter("@selectedprojectid", hdnselectedjobid.Value.TrimEnd(','));


            ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_All_department_Job_Staff_Report", parameter);



        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("No Timesheet Found..", MessageDisplay.DisplayStyles.Error);
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