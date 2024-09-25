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
using System.Drawing;
using OfficeOpenXml;
using OfficeOpenXml.Style;

public partial class controls_ExpenseReport : System.Web.UI.UserControl
{
    List<CommonLibrary.tbl_LabelAccess> LtblAccess;
    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
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
                    { Session["companyid"] = null; Session["cltcomp"] = null;
                    }
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
                    //getCompanyData(hdnCompid.Value);

                }
                else
                {
                    Response.Redirect("~/Default.aspx");
                }


            }
            txtstartdate1.Attributes.Add("onkeyup", "CountFrmTitle(this,11);");
            txtenddate2.Attributes.Add("onkeyup", "CountFrmTitle(this,11);");
        }

    protected void btnImgLast_Click(object sender, ImageClickEventArgs e)
    {
       

        if (hdnselectedprojectid.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
            return;
        }
       

        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        try
        {
           
            string fromdate = txtstartdate1.Text != "" ? Convert.ToDateTime(txtstartdate1.Text, info).ToString("MM/dd/yyyy") : null;
            string todate = txtenddate2.Text != "" ? Convert.ToDateTime(txtenddate2.Text, info).ToString("MM/dd/yyyy") : null;
           
            SqlParameter[] param = new SqlParameter[11];
            param[0] = new SqlParameter("@compid", hdnCompid.Value);
            param[1] = new SqlParameter("@UserType", hdnUserType.Value);
            param[2] = new SqlParameter("@TStatus", hdnTStatusCheck.Value);
            param[3] = new SqlParameter("@StaffCode", hdnStaffCode.Value);
            param[4] = new SqlParameter("@selectedstaffcode", hdnselectedstaff.Value);
            param[5] = new SqlParameter("@selectedprojectid", hdnselectedprojectid.Value);
            param[6] = new SqlParameter("@selectedjobid", hdnselectedmjobid.Value);
            param[7] = new SqlParameter("@FromDate", fromdate);
            param[8] = new SqlParameter("@ToDate", todate);
            param[9] = new SqlParameter("@type", hdntype.Value);
            param[10] = new SqlParameter("@Brid", hdnBrId.Value);
            if (rdetailed.Checked)
            {
                ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "Usp_Get_Project_Job_Staffwise_Expense_Detailed_Report", param);
            }
            else
            {
                ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "Usp_Get_Project_Job_Staffwise_Expense_Summary_Report", param);
            }
            DataTable dt;
            dt = ds.Tables[0];
            if (dt.Rows.Count > 0)
            {
                DumpExcel(dt);
            }
            else
            {
                MessageBox.Show("No Records To EXPORT.");
            }
        }
        catch(Exception ex)
        {

        }

    }

    private void DumpExcel(DataTable tbl)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Expense Report");

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            ws.Cells["A1"].LoadFromDataTable(tbl, true);
            ws.Cells.AutoFitColumns();
            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:AI1"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }


            string ds = "J2:J" + (tbl.Rows.Count + 100).ToString();
            using (ExcelRange rn = ws.Cells[ds])
            {
                rn.Style.Numberformat.Format = "h:mm";
            }

          
            using (var memoryStream = new System.IO.MemoryStream())
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=Expense Report.xls");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }
    //public DataSet GetExpense_ExportExcel(ProjectExpenseExcel obj)
    //{
    //    DataSet ds = new DataSet();
    //    SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    //    SqlCommand cmd = new SqlCommand();
    //    SqlDataAdapter adap = new SqlDataAdapter();
    //    cmd.Connection = sqlConn;
    //    cmd.CommandText = "Usp_Get_Project_Job_Staffwise_Expense_Summary_Report";
    //    cmd.CommandType = CommandType.StoredProcedure;
    //    cmd.CommandTimeout = 999999999;


    //    cmd.Parameters.AddWithValue("@compid", obj.compid);
    //    cmd.Parameters.AddWithValue("@UserType", obj.UserType);
    //    cmd.Parameters.AddWithValue("@TStatus", obj.status);
    //    cmd.Parameters.AddWithValue("@StaffCode", obj.StaffCode);
    //    cmd.Parameters.AddWithValue("@selectedstaffcode", obj.selectedstaffcode);
    //    cmd.Parameters.AddWithValue("@selectedprojectid", obj.selectedprojectid);
    //    cmd.Parameters.AddWithValue("@selectedjobid", obj.selectedjobid);
    //    cmd.Parameters.AddWithValue("@FromDate", obj.FromDate);
    //    cmd.Parameters.AddWithValue("@ToDate", obj.ToDate);
    //    cmd.Parameters.AddWithValue("@type", obj.Type);
    //    cmd.Parameters.AddWithValue("@Brid", obj.BrId);
    //    adap.SelectCommand = cmd;
    //    adap.Fill(ds, "");

    //    return ds;

    //}


    //protected void btngen_Click(object sender, EventArgs e)
    //{
    //    Session["Tstatus"] = hdnTStatusCheck.Value;
    //    Session["Staffcode"] = hdnStaffCode.Value;
    //    Session["Sscode"] = hdnselectedstaff.Value.TrimEnd(',');
    //    Session["SProjectid"] = hdnselectedprojectid.Value.TrimEnd(',');
    //    Session["Sjob"] = hdnselectedmjobid.Value.TrimEnd(',');
    //    Session["strdate"] = txtstartdate1.Text.Trim();
    //    Session["enddate"] = txtenddate2.Text.Trim();
    //    Session["brid"] = hdnBrId.Value;
    //    Session["type"] = hdntype.Value;
    //    Session["Branch"] = hdnbranch.Value;
    //    string rd = rdetailed.Checked.ToString();
    //    Session["rb"] = rd;
    //    if (hdnselectedprojectid.Value == "")
    //    {
    //        MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
    //        return;
    //    }
    //    else
    //    {
    //        Response.Redirect("~/Project_Job_Staff_ExpenseForm.aspx", false);
    //    }
    //}
}