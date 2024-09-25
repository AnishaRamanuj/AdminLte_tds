using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using JTMSProject;
using System.Net.Mail;
using System.IO;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using CommonLibrary;

public partial class controls_Resource_Planning : System.Web.UI.UserControl
{

    SmtpClient smtp = new SmtpClient();
    Systme_Parameters param = new Systme_Parameters();
    System_Dal objSystem_Dal = new System_Dal();
    string wk = "";
    CultureInfo ci = new CultureInfo("en-GB");
    AllTimesheetGridBind objAllTimesheetGridBind = new AllTimesheetGridBind();
    List<AllTimesheetModel> list_AllTimesheet;
    AllTimesheetModel tblTimesheetGrid = new AllTimesheetModel();
    string subject, MessageText, to;
    LabelAccess objlabelAccess = new LabelAccess();
    List<tbl_LabelAccess> LtblAccess;
    string xlErr = "";
    const int pageSize = 25;
    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                //hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                //hdnCompid.Value = Session["cltcomp"].ToString();
                ViewState["compid"] = Session["cltcomp"].ToString();
            }
            if (ViewState["compid"] != null)
            {


                DateTime date = DateTime.Now;
                DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);
                hdnFromdate.Value = firstDayOfMonth.ToString("yyyy-MM-dd");
                hdnTodate.Value = lastDayOfMonth.ToString("yyyy-MM-dd");
               
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            if (Session["Error"].ToString() != "")
            {
                MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
                Session["Error"] = "";
            }
        }
    }

    protected void btngenexp_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                //hdnCompid.Value = Session["companyid"].ToString();
                if (hdnmonth.Value == "")
                {
                    MessageControl1.SetMessage("From Date Cannot be blank", MessageDisplay.DisplayStyles.Error);
                    return;
                }

                if (hdnselectedJobid.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
                    return;
                }

                Session["Staffcode"] = hdnSelectedStaffCode.Value.TrimEnd(',');
                Session["Jobid"] = hdnselectedJobid.Value.TrimEnd(',');
                Session["monthdate"] = hdnmonth.Value;

                if (hdnSelectedStaffCode.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one Staff !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                else
                {
                    Response.Redirect("~/Company/ReportPage_Resource_Planning.aspx", false);
                }
            }
            else
            {
                Response.Redirect("~/Company/Resource_Planning.aspx", false);
            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
        }
    }

    protected void btnExportToExcel_Click1(object sender, ImageClickEventArgs e)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            //hdnCompid.Value = Session["companyid"].ToString();
            if (hdnmonth.Value == "")
            {
                MessageControl1.SetMessage("From Date Cannot be blank", MessageDisplay.DisplayStyles.Error);
                return;
            }

            if (hdnselectedJobid.Value == "")
            {
                MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
                return;
            }
            xlErr = "";
            string fromdate = hdnFromdate.Value != "" ? Convert.ToDateTime(hdnFromdate.Value, ci).ToString("MM/dd/yyyy") : null;
            string todate = hdnTodate.Value != "" ? Convert.ToDateTime(hdnTodate.Value, ci).ToString("MM/dd/yyyy") : null;
            Common ob = new Common();

            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@selectedstaffcode", hdnSelectedStaffCode.Value.TrimEnd(','));
            param[2] = new SqlParameter("@selectedjobid", hdnselectedJobid.Value.TrimEnd(','));
            param[3] = new SqlParameter("@fromdate", fromdate);
            param[4] = new SqlParameter("@todate", todate);
       
            ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_Resource_Planning_SummaryExcel", param);
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
        catch (Exception ex)
        {
            if (xlErr != "1")
            {
                MessageBox.Show("server not connected please try again.");
            }
        }
    }


    private void DumpExcel(DataTable tbl)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            string name = "Resource Planning Summary"+ hdnFromdate.Value + "-" + hdnTodate.Value ;
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add(name);

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            ws.Cells["A1"].LoadFromDataTable(tbl, true);
            ws.Cells.AutoFitColumns();
            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:ZZ1"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }


            xlErr = "1";
            using (var memoryStream = new MemoryStream())
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=Resource_Planning_Summary.xls");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }



}