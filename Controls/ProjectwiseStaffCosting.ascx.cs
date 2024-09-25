using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Configuration;
using Microsoft.Reporting.WebForms;
using CommonLibrary;


public partial class controls_ProjectwiseStaffCosting : System.Web.UI.UserControl
{
    SqlConnection sqlcon = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    CultureInfo info = new CultureInfo("en-GB");
    string UserType = "";
    LabelAccess objlabelAccess = new LabelAccess();
    List<tbl_LabelAccess> LtblAccess;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            hdnCompid.Value = Session["companyid"].ToString();
            TaskDeptJobwise();
            //if (hdnTaskDeptJobwise.Value == "dept") {
            //    chkdept.Text = "Check All Department Name (Count : 0)";
            //}
            //if (hdnTaskDeptJobwise.Value == "task") {
            //    chkdept.Text = "Check All Task Name (Count : 0)";
            //}
            if (Session["usertype"] != null)
            {
                UserType = Session["usertype"].ToString();
            }
            else
            { Session["companyid"] = null; Session["cltcomp"] = null; }
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
            hdnFrom.Value = (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year) + "-04-01";
            hdnTo.Value = Convert.ToDateTime(DateTime.Now, info).ToString("yyyy-MM-dd");
        }
    }

    private void TaskDeptJobwise()
    {
        try
        {
            DataSet ds = new DataSet();
            SqlParameter[] parameter = new SqlParameter[1];
            parameter[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"]).ToString());
            ds = SqlHelper.ExecuteDataset(sqlcon, CommandType.StoredProcedure, "usp_getClientProjectStaffJobs", parameter);
            if (ds != null)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    string strdept = ds.Tables[0].Rows[0]["Deptwise"].ToString();
                    string strtask = ds.Tables[0].Rows[0]["Taskwise"].ToString();
                    if (strdept == "1")
                    {
                        hdnTaskDeptJobwise.Value = "dept";
                    }
                    if (strtask == "1")
                    {
                        hdnTaskDeptJobwise.Value = "task";
                    }
                }
            }


        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    protected void btngen_Click(object sender, EventArgs e)
    {
        string ReportName = "";
        if (hdnSelectedStaffCode.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one Staff !", MessageDisplay.DisplayStyles.Error);
            return;
        }
      
        int comp = Convert.ToInt32(hdnCompid.Value);
        DateTime FDT = Convert.ToDateTime(hdnFrom.Value, info);
        DateTime EDT = Convert.ToDateTime(hdnTo.Value, info);

        ReportViewer1.ProcessingMode = ProcessingMode.Local;
        if (rdetailed.Checked)
        {
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_deparmentwiseStaffCostingdetaill.rdlc");
            ReportName = objlabelAccess.changelabel("Projectwise Staff Costing Detail", LtblAccess);
        }
        else
        {
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_deparmentwiseStaffCostingsummary.rdlc");
            ReportName = objlabelAccess.changelabel("Projectwise Staff Costing Summarize", LtblAccess);
        }

        DataSet dsss = Getdata(comp, FDT, EDT);
        ReportDataSource datasource = new ReportDataSource("DataSet1", dsss.Tables[0]);
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.LocalReport.DataSources.Add(datasource);
        ReportParameter[] parameters = new ReportParameter[8];
        parameters[0] = new ReportParameter("companyname", Convert.ToString(Session["CompanyName"]).Trim());
        parameters[1] = new ReportParameter("date", ": " + FDT.ToString("dd/MM/yyyy").Trim() + " to " + EDT.ToString("dd/MM/yyyy").Trim());
        parameters[2] = new ReportParameter("reportname", ": " + ReportName);
        parameters[3] = new ReportParameter("printedby", ": " + Convert.ToString(Session["Name"]).Trim());
        parameters[4] = new ReportParameter("chargeope", " " + objlabelAccess.changelabel("Charge + Expense", LtblAccess));
        parameters[5] = new ReportParameter("Expense", objlabelAccess.changelabel("Expense", LtblAccess));
        parameters[6] = new ReportParameter("printeddate", ": " + DateTime.Now);
        if (hdnTaskDeptJobwise.Value == "dept") {
            parameters[7] = new ReportParameter("taskdeptjob", " " + objlabelAccess.changelabel("Department", LtblAccess));
        }
        if (hdnTaskDeptJobwise.Value == "task") {
            parameters[7] = new ReportParameter("taskdeptjob", " " + objlabelAccess.changelabel("Task", LtblAccess));
        }
        if (hdnTaskDeptJobwise.Value == "job") {
            parameters[7] = new ReportParameter("taskdeptjob", " " + objlabelAccess.changelabel("Job Name", LtblAccess));
        }
        this.ReportViewer1.LocalReport.SetParameters(parameters);
        ReportViewer1.LocalReport.DisplayName = ReportName;
        ReportViewer1.LocalReport.Refresh();
        divReportInput.Visible = false;
        ReportViewer1.Visible = true;
        btnBack.Visible = true;
        btngen.Visible = false;
    }

    private DataSet Getdata(int compid, DateTime FromDAte, DateTime ToDate)
    {
        DataSet ds = new DataSet();
        try
        {
            SqlParameter[] parameter = new SqlParameter[9];
            parameter[0] = new SqlParameter("@Compid", compid);
            parameter[1] = new SqlParameter("@staff", hdnSelectedStaffCode.Value.TrimEnd(','));
            parameter[2] = new SqlParameter("@from", FromDAte);
            parameter[3] = new SqlParameter("@end", ToDate);
            parameter[4] = new SqlParameter("@statuschk", hdnTStatusCheck.Value);
            parameter[5] = new SqlParameter("@Client", hdnselectedclientid.Value.TrimEnd(','));
            parameter[6] = new SqlParameter("@Project", hdnselectedprojectid.Value.TrimEnd(','));
            if(rsummary.Checked)
            {
                parameter[7] = new SqlParameter("@Report", "Summary");
            }
            if (rdetailed.Checked)
            {
                parameter[7] = new SqlParameter("@Report", "detailed");
            }
            parameter[8] = new SqlParameter("@depttaskjobids", hdnselecteddept.Value.TrimEnd(','));
            if (hdnTaskDeptJobwise.Value == "dept")
            {
                ds = SqlHelper.ExecuteDataset(sqlcon, CommandType.StoredProcedure, "usp_getdepartmentwisestaffcosting", parameter);
            }
            if (hdnTaskDeptJobwise.Value == "task")
            {
                ds = SqlHelper.ExecuteDataset(sqlcon, CommandType.StoredProcedure, "usp_gettaskwisestaffcosting", parameter);
            }
            if (hdnTaskDeptJobwise.Value == "job") 
            {
                ds = SqlHelper.ExecuteDataset(sqlcon, CommandType.StoredProcedure, "usp_getjobwisestaffcosting", parameter);
            }

        }
            
        catch(Exception ex)
        {
        MessageControl1.SetMessage("Server Not Connected.."+ex,MessageDisplay.DisplayStyles.Error);
        }
        return ds;
    }
    protected void btnBack_Click(object sender, EventArgs e)
    {
        divReportInput.Visible = true;
        ReportViewer1.Visible = false;
        btnBack.Visible = false;
        btngen.Visible = true;
    }
}