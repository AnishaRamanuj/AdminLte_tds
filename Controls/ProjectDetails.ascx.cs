using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using JTMSProject;
using System.Web.UI.DataVisualization.Charting;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Collections.Generic;
using System.Web.Services;
using System.Web.Script.Services;
using DataAccessLayer;
using System.Globalization;
using CommonLibrary;
using System.Web.Script.Serialization;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using System.Net.Mail;
using System.IO;

public partial class controls_ProjectDetails : System.Web.UI.UserControl
{
    string xlErr = "";

    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());

    CultureInfo ci = new CultureInfo("en-GB");
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {


            if (Session["companyid"] != null)
            {

                ViewState["compid"] = Session["companyid"].ToString();
                hdnCompid.Value = ViewState["compid"].ToString();


            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["Companyid"].ToString();
                hdnCompid.Value = ViewState["compid"].ToString();
                hdnDept.Value = Session["deptwise"].ToString();
            }

            if (ViewState["compid"] != null)
            {
                ViewState["compid"] = Session["Companyid"].ToString();
                hdnCompid.Value = ViewState["compid"].ToString();
                hdnDept.Value = Session["deptwise"].ToString();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        DateTime date = DateTime.Now;

        DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
        DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);
        if (txtfrom.Text == "" || txtto.Text == "")
        {
            txtfrom.Text = firstDayOfMonth.ToString("dd/MM/yyyy");
            txtto.Text = lastDayOfMonth.ToString("dd/MM/yyyy");
            txtfrom.Attributes.Add("readonly", "readonly");
            txtto.Attributes.Add("readonly", "readonly");
        }
    }

    protected void btnExport_Project_Click(object sender, ImageClickEventArgs e)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            xlErr = "";
            string fromdate = txtfrom.Text != "" ? Convert.ToDateTime(txtfrom.Text, ci).ToString("MM/dd/yyyy") : null;
            string todate = txtto.Text != "" ? Convert.ToDateTime(txtto.Text, ci).ToString("MM/dd/yyyy") : null;
            Common ob = new Common();

            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", hdnCompid.Value);
            param[1] = new SqlParameter("@fdate", fromdate);
            param[2] = new SqlParameter("@todate", todate);
            param[3] = new SqlParameter("@Srch", hdnSrch.Value);
            param[4] = new SqlParameter("@status", hdnStatus.Value);

            ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "Usp_Dashboard_Project_Export", param);
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
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Project_Report");

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

            xlErr = "1";
            using (var memoryStream = new MemoryStream())
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=Project_Report.xls");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }

    protected void Export_Details_Click(object sender, ImageClickEventArgs e)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            xlErr = "";
            Common ob = new Common();

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", hdnCompid.Value);
            param[1] = new SqlParameter("@ProjectId ", hdnProjectid.Value);


            ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "Usp_Dashboard_Project_Details_Export", param);
            DataTable dt, dtt;
            dt = ds.Tables[0];
            dtt = ds.Tables[1];
            if (dt.Rows.Count > 0)
            {
                ExcelDetail(dt, dtt);
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

    private void ExcelDetail(DataTable tbl, DataTable tbll)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("ProjectDeatil_Report");

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            ws.Cells["B5"].LoadFromDataTable(tbl, true);
            ws.Cells.AutoFitColumns();

            ws.Cells["A1"].LoadFromDataTable(tbll, true);
            ws.Cells.AutoFitColumns();

            using (ExcelRange rng = ws.Cells["A1:C1"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["B5:E5"])
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

            xlErr = "1";
            using (var memoryStream = new MemoryStream())
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=ProjectDeatil_Report.xls");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }
}