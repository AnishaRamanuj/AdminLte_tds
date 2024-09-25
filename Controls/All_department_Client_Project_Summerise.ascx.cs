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

public partial class controls_All_department_Client_Project_Summerise : System.Web.UI.UserControl
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
    string IsCSV = "False";
    string deci = "False";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                hdnCompid.Value = Session["cltcomp"].ToString();
                ViewState["compid"] = Session["cltcomp"].ToString();
            }
            if (ViewState["compid"] != null)
            {
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
                    Staffid = Session["staffid"].ToString();
                }

                if (UserType == "staff")
                {
                    if (Session["Jr_ApproverId"].ToString() == "true")
                    {
                        Session["StaffType"] = "App";
                    }
                }
                DateTime date = DateTime.Now;

                DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

                txtstartdate1.Text = firstDayOfMonth.ToString("dd/MM/yyyy");
                txtenddate2.Text = lastDayOfMonth.ToString("dd/MM/yyyy");
                getCompanyData(hdnCompid.Value);
                if (IsCSV == "True")
                {
                    btnCSV.Visible = true;
                }
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

            //if (Session["usertype"] != null)
            //{
            //    UserType = Session["usertype"].ToString();
            //}
            //else
            //{ Session["companyid"] = null; Session["cltcomp"] = null; }
            //hdnUserType.Value = UserType;
            //if (UserType == "staff")
            //{
            //    hdnStaffCode.Value = Session["staffid"].ToString();
            //    Staffid = Session["staffid"].ToString();
            //}

            //if (UserType == "staff")
            //{
            //    if (Session["Jr_ApproverId"] == "true")
            //    {
            //        Session["StaffType"] = "App";
            //    }
            //}
            //DateTime date = DateTime.Now;

            //DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
            //DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

            //txtstartdate1.Text = firstDayOfMonth.ToString("dd/MM/yyyy") ;
            //txtenddate2.Text = lastDayOfMonth.ToString("dd/MM/yyyy");  
            //getCompanyData(hdnCompid.Value);
            //if (IsCSV == "True")
            //{
            //    btnCSV.Visible = true;
            //}
            btnBack.Visible = false;
        }
        txtstartdate1.Attributes.Add("onkeyup", "CountFrmTitle(this,11);");
        txtenddate2.Attributes.Add("onkeyup", "CountFrmTitle(this,11);");
    }


    private void getCompanyData(string compid)
    {
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);
            DataSet ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_getCompanyData", param);
            IsCSV = ds.Tables[0].Rows[0]["IsCSV"].ToString();
            deci = ds.Tables[0].Rows[0]["Timesheet_Decimals"].ToString();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    private void ConvertToCSV(DataSet ds)
    {
        StringBuilder content = new StringBuilder();

        if (ds.Tables.Count >= 1)
        {
            DataTable table = ds.Tables[0];

            if (table.Rows.Count > 0)
            {
                DataRow dr1 = (DataRow)table.Rows[0];
                int intColumnCount = dr1.Table.Columns.Count;
                int index = 1;

                //add column names
                foreach (DataColumn item in dr1.Table.Columns)
                {
                    content.Append(String.Format("\"{0}\"", item.ColumnName));
                    if (index < intColumnCount)
                        content.Append(",");
                    else
                        content.Append("\r\n");
                    index++;
                }

                //add column data
                foreach (DataRow currentRow in table.Rows)
                {
                    string strRow = string.Empty;
                    for (int y = 0; y <= intColumnCount - 1; y++)
                    {
                        strRow += "\"" + currentRow[y].ToString() + "\"";

                        if (y < intColumnCount - 1 && y >= 0)
                            strRow += ",";
                    }
                    content.Append(strRow + "\r\n");
                }
            }
        }


        byte[] bytesFromBuilder = Encoding.UTF8.GetBytes(content.ToString());


        Response.AddHeader("Content-disposition", "attachment; filename= All_Department_Client_Project.csv");
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytesFromBuilder);
        Response.End();

        //return content.ToString();
    }


    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                btngen.Visible = false;
                //lblname.Visible = false;
                LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
                string ReportName = "";
                if (hdnselecteddept.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one Department !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                if (hdnselectedprojectid.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                int comp = int.Parse(ViewState["compid"].ToString());
                getCompanyData(comp.ToString());
                DateTime FDT = Convert.ToDateTime(txtstartdate1.Text, info);
                DateTime EDT = Convert.ToDateTime(txtenddate2.Text, info);

                ReportViewer1.ProcessingMode = ProcessingMode.Local;



                ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_All_department_Client_Project_Summerise.rdlc");
                ReportName = objlabelAccess.changelabel("All Department Client Project Summarized - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
                string s = "";
                string branch = "All";
                if (hdnbranch.Value != "0")
                {
                    branch = hdnbranch.Value;
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
                parameters[5] = new ReportParameter("branch", ":" + branch);
                s = "";
                s = objlabelAccess.changelabel("Job", LtblAccess);
                parameters[6] = new ReportParameter("Job", s);
                this.ReportViewer1.LocalReport.SetParameters(parameters);
                ReportViewer1.LocalReport.Refresh();
                divReportInput.Visible = false;
                ReportViewer1.Visible = true;
                btnBack.Visible = true;
            }
            else
            {
                Response.Redirect("~/Company/All_department_Client_Project_Summerise.aspx", false);
            }
        }
        catch(Exception ex)
        {
            MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
        }
    }
    private DataSet GetData(int comp, DateTime FromDAte, DateTime ToDate)
    {
        DataSet ds = new DataSet();
        try
        {
            string sp = "";
            SqlParameter[] parameter = new SqlParameter[11];
            parameter[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"]).ToString());
            parameter[1] = new SqlParameter("@UserType", hdnUserType.Value);
            parameter[2] = new SqlParameter("@TStatus", hdnTStatusCheck.Value.TrimEnd(','));
            parameter[3] = new SqlParameter("@StaffCode", hdnStaffCode.Value == "" ? "0" : hdnStaffCode.Value);
            parameter[4] = new SqlParameter("@selectedclientid", hdnselectedclientid.Value.TrimEnd(','));
            parameter[5] = new SqlParameter("@selecteddeptid", hdnselecteddept.Value.TrimEnd(','));
            parameter[6] = new SqlParameter("@FromDate", FromDAte);
            parameter[7] = new SqlParameter("@ToDate", ToDate);
            parameter[8] = new SqlParameter("@selectedprojectid", hdnselectedprojectid.Value.TrimEnd(','));
            parameter[9] = new SqlParameter("@type", hdntype.Value);
            parameter[10] = new SqlParameter("@Branch", hdnBrId.Value);
            if (deci == "False")
            {
                sp = "usp_Report_All_department_Client_Project_Summerise_Decimals";
            }
            else
            {
                sp = "usp_Report_All_department_Client_Project_Summerise";
            }

            ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, sp, parameter);
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
        btngen.Visible = true;
        //lblname.Visible = true;

    }


    protected void btnCSV_Click(object sender, EventArgs e)
    {
        DataSet dssssss = new DataSet();
        DateTime FDT = Convert.ToDateTime(txtstartdate1.Text, info);
        DateTime EDT = Convert.ToDateTime(txtenddate2.Text, info);
        try
        {
            if (hdnselecteddept.Value == "")
            {
                MessageControl1.SetMessage("Please select at least one Department !", MessageDisplay.DisplayStyles.Error);
                return;
            }
            if (hdnselectedprojectid.Value == "")
            {
                MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
                return;
            }
          
            SqlParameter[] param = new SqlParameter[11];
            param[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"]).ToString());
            param[1] = new SqlParameter("@UserType", hdnUserType.Value);
            param[2] = new SqlParameter("@TStatus", hdnTStatusCheck.Value.TrimEnd(','));
            param[3] = new SqlParameter("@StaffCode", hdnStaffCode.Value == "" ? "0" : hdnStaffCode.Value);
            param[4] = new SqlParameter("@selectedclientid", hdnselectedclientid.Value.TrimEnd(','));
            param[5] = new SqlParameter("@selecteddeptid", hdnselecteddept.Value.TrimEnd(','));
            param[6] = new SqlParameter("@FromDate", FDT);
            param[7] = new SqlParameter("@ToDate", EDT);
            param[8] = new SqlParameter("@selectedprojectid", hdnselectedprojectid.Value.TrimEnd(','));
            param[9] = new SqlParameter("@type", hdntype.Value);
            param[10] = new SqlParameter("@Branch", hdnBrId.Value);
            dssssss = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_Report_All_department_Client_Project_Summerise_CSV", param);

            ConvertToCSV(dssssss);
        }

        catch (Exception ex)
        {
            throw ex;
        }
    }
}