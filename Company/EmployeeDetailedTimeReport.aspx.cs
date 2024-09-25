using ClosedXML.Excel;
using CommonLibrary;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Threading;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Linq;
public partial class Company_Employee_DetailedTimeReport : System.Web.UI.Page
{
    string xlErr = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                ViewState["compid"] = Session["companyid"].ToString();
                hdnCompanyid.Value = Session["companyid"].ToString();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
    }

    public void btnexcel_Click(object sender, EventArgs e)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DataTable reportDataTable = new DataTable();
        try
        {
            string fmDate = hdnFromDate.Value != "" ? Convert.ToDateTime(hdnFromDate.Value).ToString("MM/dd/yyyy") : null;
            string tDate = hdnToDate.Value != "" ? Convert.ToDateTime(hdnToDate.Value).ToString("MM/dd/yyyy") : null;

            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@CompId", hdnCompanyid.Value);
            param[1] = new SqlParameter("@pageIndex", 0);
            param[2] = new SqlParameter("@pageSize", 0);
            param[3] = new SqlParameter("@EmpIds", hdnSelectedStaffs.Value);
            param[4] = new SqlParameter("@FromDate", fmDate);
            param[5] = new SqlParameter("@ToDate", tDate);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_EmployeeDetailedTimeReport", param);
            reportDataTable = ds.Tables[0];

            if (reportDataTable.Rows.Count > 0)
            {
                DumpExcel(reportDataTable);
            }
            else
            {
                MessageBox.Show("No Records To EXPORT.");
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    private void DumpExcel(DataTable tbl)
    {
        using (XLWorkbook wb = new XLWorkbook())
        {
            //Create the worksheet
            string Ttype = "";

                Ttype = "EmployeeDetail_Report";
           

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            wb.Worksheets.Add(tbl, Ttype);
            wb.Worksheets.Worksheet(1).Columns().AdjustToContents();
            wb.Worksheets.Worksheet(1).Rows().AdjustToContents();
            //wb.Worksheets.Worksheet(1).Column(11).Style.DateFormat.Format = "hh:mm";
            //wb.Worksheets.Worksheet(1).Column(12).Style.DateFormat.Format = "hh:mm";
            xlErr = "1";
            System.Web.HttpResponse response = System.Web.HttpContext.Current.Response;
            response.Clear();
            response.Buffer = true;
            response.Charset = "";
            response.ContentType = "application/vnd.openxmlformats-     officedocument.spreadsheetml.sheet";
            response.AddHeader("content-disposition", "attachment;filename=" + Ttype + ".xlsx");
            using (MemoryStream stream = GetStream(wb))
            {
                response.BinaryWrite(stream.ToArray());
            }
            // Code Added By SathishRam For Hiding BlockerUI On 21-Mar-2023
            //Create cookie for stop jquery message blockUi
            HttpCookie CookieReport = new HttpCookie("CookieReport");
            CookieReport.Value = hdnCookieName.Value;
            CookieReport.Expires = DateTime.Now.AddSeconds(30);
            Response.Cookies.Add(CookieReport);

            Response.Flush();
            Response.Close();
            Response.End();
        }
    }
    public MemoryStream GetStream(XLWorkbook excelWorkbook)
    {
        MemoryStream fs = new MemoryStream();
        excelWorkbook.SaveAs(fs);
        fs.Position = 0;
        return fs;
    }
}