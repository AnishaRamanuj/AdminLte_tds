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

public partial class controls_All_ClientProjectJob_details : System.Web.UI.UserControl
{
    List<CommonLibrary.tbl_LabelAccess> LtblAccess;
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    CultureInfo info = new CultureInfo("en-GB");
    LabelAccess objlabelAccess = new LabelAccess();
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;
    public string JobID = "";
    public string Clientid = "";
    public string widd1 = "";
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
            else if (Session["staffid"] != null)
            {
                hdnCompid.Value = Session["cltcomp"].ToString();
                ViewState["compid"] = Session["cltcomp"].ToString();
            }
            departmentwise();
            //if (hdndeptwise.Value == "dept")
            //{
            //    chkdept.Text = "Check All department Name (Count : 0)";
            //}
            //else
            //{
            //    chkdept.Text = "Check All job Name (Count : 0)";
            //}
          
           
            if (Session["usertype"] != null)
            {
                UserType = Session["usertype"].ToString();
            }
            else
            { Session["companyid"] = null; Session["cltcomp"] = null; }
            hdnTypeU.Value = UserType;
            if (UserType == "staff")
            {
                hdnStaffCode.Value = Session["staffid"].ToString();
                Staffid = Session["staffid"].ToString();
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

    private void departmentwise()
    {
        try {
            DataSet ds = new DataSet();
            SqlParameter[] parameter = new SqlParameter[1];
            parameter[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"]).ToString());
            ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_getClientProjectStaffJobs", parameter);
            if (ds != null)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    string strdept = ds.Tables[0].Rows[0]["Deptwise"].ToString();
                    string strtask = ds.Tables[0].Rows[0]["Taskwise"].ToString();
                    if (strdept == "1")
                    {
                        hdndeptwise.Value = "dept";
                    }
                    if (strtask == "1")
                    {
                        hdndeptwise.Value = "task";
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
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
        string ReportName = "";
        if (hdnselecteddept.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one staff !", MessageDisplay.DisplayStyles.Error);
            return;
        }
        int comp = int.Parse(ViewState["compid"].ToString());
        DateTime FDT = Convert.ToDateTime(hdnFrom.Value, info);
        DateTime EDT = Convert.ToDateTime(hdnTo.Value, info);

        ReportViewer1.ProcessingMode = ProcessingMode.Local;

        if (rdetailed.Checked)
        {
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_Projectwise_staff_Details.rdlc");
            ReportName = objlabelAccess.changelabel("Client Projectwise Department and Job Detailed - ",LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
        }
        else
        {
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_projectwise_staff_summary.rdlc");
            ReportName = objlabelAccess.changelabel("Client Projectwise Department and Job Summarized - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
        }
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
       parameters[5] = new ReportParameter("expencecharges", "" + "Charge + Expense");
       parameters[6] = new ReportParameter("opeamount", "" + " Expense");
       this.ReportViewer1.LocalReport.SetParameters(parameters);
       ReportViewer1.LocalReport.Refresh();
       divReportInput.Visible = false;
       ReportViewer1.Visible = true;
       btnBack.Visible = true;
        btngen.Visible = false;
    }
    private DataSet GetData(int comp, DateTime FromDAte, DateTime ToDate)
    {
        DataSet ds = new DataSet();
        try
        {
           
            SqlParameter[] parameter = new SqlParameter[9];
            parameter[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"]).ToString());
            parameter[1] = new SqlParameter("@UserType",hdnTypeU.Value);
            parameter[2] = new SqlParameter("@TStatus",hdnTStatusCheck.Value.TrimEnd(','));
            parameter[3] = new SqlParameter("@StaffCode", hdnStaffCode.Value == "" ? "0" : hdnStaffCode.Value);
            parameter[4] = new SqlParameter("@selectedclientid",hdnselectedclientid.Value.TrimEnd(','));
            parameter[5] = new SqlParameter("@selecteddeptid", hdnselecteddept.Value.TrimEnd(','));
            parameter[6] = new SqlParameter("@FromDate", FromDAte);
            parameter[7] = new SqlParameter("@ToDate",ToDate);
            parameter[8] = new SqlParameter("@selectedprojectid", hdnselectedprojectid.Value.TrimEnd(','));
            if (rdetailed.Checked)
            {
                ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_clientProjecctjobwisedetails", parameter);
            }
            else
            {
                ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_clientProjectjobwiseSummary", parameter);
               
            }
           
         }
        catch(Exception ex)
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
        btngen.Visible = true;
    }

}