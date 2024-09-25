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
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;
using System.Web.Services;
public partial class Company_TimesheetViewer : System.Web.UI.Page
{
    string xlErr = "";
    CultureInfo ci = new CultureInfo("en-GB");
    bool isExpensetrue = false;
    int dft_mmddyyyy = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Request.QueryString["value"] != null && Request.QueryString["value"] != string.Empty)
            {
                hdnIsRejected.Value = Request.QueryString["value"];
            }

            if (Session["UserRole"].ToString() == "Admin")
            {
                if (Session["companyid"] != null)
                {
                    //ViewState["compid"] = Session["companyid"].ToString();
                    //hdnCompanyid.Value = Session["companyid"].ToString();
                    hdnPageLevel.Value = Session["PageLevel"].ToString();
                    hdnCompanyPermission.Value = getCompanyPermissions();
                    hdnDualApp.Value = Session["DualApprovers"].ToString();
                    hdnNarration.Value = Session["Narration"].ToString();
                    if (Session["RoleName"].ToString() == "Company-Admin")
                    {
                        hdnRolename.Value = "";
                    }
                    else
                    {
                        hdnRolename.Value = Session["RoleName"].ToString();
                    }
                }
                else
                {
                    Response.Redirect("~/Default.aspx");
                }
            }
            else
            {
                if (Session["staffid"].ToString() != "")
                {
                    //ViewState["compid"] = Session["companyid"].ToString();
                    //hdnCompanyid.Value = Session["companyid"].ToString();
                    hdnPageLevel.Value = Session["PageLevel"].ToString();
                    hdnEditStaffcode.Value = Session["staffid"].ToString();
                    hdnRolename.Value = Session["RoleName"].ToString();
                    hdnCompanyPermission.Value = getCompanyPermissions();
                    //hdnNarration.Value = Session["Narration"].ToString();
                }
                else
                {
                    Response.Redirect("~/Default.aspx");
                }
            }

        }
        //txtsrchjob.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        //TxtPass.Attributes.Add("onkeyup", "CheckPasswordStrength(this.value);");
        /////set Current week start and end date for staff summary
        DateTime baseDate = DateTime.Today;
        var thisWeekStart = baseDate.AddDays(-(int)baseDate.DayOfWeek);
        thisWeekStart = thisWeekStart.AddDays(1);
        var thisWeekEnd = thisWeekStart.AddDays(7).AddSeconds(-1);

        if (dft_mmddyyyy == 0)
        {
            hdntxtdateBindStaff.Value = thisWeekStart.ToString("dd/MM/yyyy") + " - " + thisWeekEnd.ToString("dd/MM/yyyy");
        }
        else
        {
            hdntxtdateBindStaff.Value = thisWeekStart.ToString("MM/dd/yyyy") + " - " + thisWeekEnd.ToString("MM/dd/yyyy");
        }
        hdnFromdate.Value = thisWeekStart.ToString("yyyy-MM-dd");
        hdnTodate.Value = thisWeekEnd.ToString("yyyy-MM-dd");
        hdnExpenseMaster.Value = getCompanyExpenseMaster();
        hdnCurrencyMaster.Value = getCurrencyMaster();
        hdnTsCurrency.Value = Session["Currency"].ToString();
        // txtdateBindStaff.Attributes.Add("readonly", "readonly");
        Get_Alltimesheets_companyThresholds();

    }

    protected string getCompanyPermissions()
    {
        try
        {
            List<CompanyTimeThreshold> objCompanyTimeThreshold = new List<CompanyTimeThreshold>();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader((new CommonFunctions())._cnnString, CommandType.StoredProcedure, "usp_getCompanyPermission", param))
            {
                while (drrr.Read())
                {
                    objCompanyTimeThreshold.Add(new CompanyTimeThreshold()
                    {
                        CompanyTimeThresholdId = (new CommonFunctions()).GetValue<int>(drrr["CompanyTimeThresholdId"].ToString()),
                        Multi_Levels = new CommonFunctions().GetValue<int>(drrr["Multi_Levels"].ToString()),
                        Autofillandhide = new CommonFunctions().GetValue<bool>(drrr["Autofill_and_hide"].ToString()),
                        Edit_Billing_Hrs = new CommonFunctions().GetValue<bool>(drrr["Edit_Billing_Hrs"].ToString()),
                        Apredittmst = new CommonFunctions().GetValue<bool>(drrr["Apredittmst"].ToString()),
                        ProjectnClient = new CommonFunctions().GetValue<int>(drrr["ProjectnClient"].ToString()),
                        SwapEdit = new CommonFunctions().GetValue<bool>(drrr["Swap_Editable_cols"].ToString()),
                        Expense_mandatory = (new CommonFunctions()).GetValue<bool>(drrr["Expense_mandatory"].ToString()),
                        mmddyyyy = new CommonFunctions().GetValue<int>(drrr["Default_MMDDYYYY"].ToString()),
                    });
                }
            }
            dft_mmddyyyy = (int)objCompanyTimeThreshold.Select(s => s.mmddyyyy).FirstOrDefault();
            return new JavaScriptSerializer().Serialize(objCompanyTimeThreshold as IEnumerable<CompanyTimeThreshold>).ToString();
        }
        catch (Exception ex)
        {
            //MessageControl1.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
            return ex.Message;

        }
    }


    private void Get_Alltimesheets_companyThresholds()
    {
        string wk = "";
        Common ob = new Common();
        DataSet ds = new DataSet();
        SqlParameter[] param = new SqlParameter[2];
        param[0] = new SqlParameter("@Compid", Session["companyid"]);
        param[1] = new SqlParameter("@staffcode", hdnEditStaffcode.Value);
        ds = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_Alltimesheets_companyThresholds", param);
        string format = ds.Tables[0].Rows[0]["Format_A"].ToString();
        //if (format == "True") { hdnTimesheetFormat.Value = "FormatA"; }
        //else { hdnTimesheetFormat.Value = "FormatB"; }

        if (Convert.ToBoolean(ds.Tables[0].Rows[0]["Mon"]) == false)
        {
            wk = "Mon";
        }
        if (Convert.ToBoolean(ds.Tables[0].Rows[0]["Tue"]) == false)
        {
            wk = wk + ",Tue";
        }
        if (Convert.ToBoolean(ds.Tables[0].Rows[0]["Wed"]) == false)
        {
            wk = wk + ",Wed";
        }
        if (Convert.ToBoolean(ds.Tables[0].Rows[0]["Thu"]) == false)
        {
            wk = wk + ",Thu";
        }
        if (Convert.ToBoolean(ds.Tables[0].Rows[0]["Fri"]) == false)
        {
            wk = wk + ",Fri";
        }
        if (Convert.ToBoolean(ds.Tables[0].Rows[0]["Sat"]) == false)
        {
            wk = wk + ",Sat";
        }
        if (Convert.ToBoolean(ds.Tables[0].Rows[0]["Sun"]) == false)
        {
            wk = wk + ",Sun";
        }

        hdnwk.Value = wk;
        hdnExpense.Value = ds.Tables[0].Rows[0]["Expense_mandatory"].ToString();
        //hdnMulti_Levels.Value = ds.Tables[0].Rows[0]["Multi_Levels"].ToString();

        if (Convert.ToInt32(hdnEditStaffcode.Value) != 0)
        {
            if (ds.Tables[1].Rows.Count > 0)
            {
                hdnSubAppr.Value = "True";
            }
            if (ds.Tables[2].Rows.Count > 0)
            {
                hdnSuperAppr.Value = "True";
            }
        }

    }



    protected void btnexcel_Click(object sender, EventArgs e)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        string Staffrole = "";
        string staffcode = "";
        if (hdnRolename.Value == "Company-Admin")
        {
            Staffrole = "";
            staffcode = "0";

        }
        else
        {
            Staffrole = hdnRolename.Value;
            staffcode = hdnEditStaffcode.Value;
        }

        try
        {
            string fromdate = hdnFmdat1.Value != "" ? Convert.ToDateTime(hdnFmdat1.Value, ci).ToString("MM/dd/yyyy") : null;
            string todate = hdnTodt1.Value != "" ? Convert.ToDateTime(hdnTodt1.Value, ci).ToString("MM/dd/yyyy") : null;
            Common ob = new Common();

            string spname = "";
            int PL = Convert.ToInt16(hdnPageLevel.Value);
            if (PL >= 3)
            {
                //if (hdnTSStatus.Value == "Approved")
                //{
                //    spname = "usp_Boostrap_ApproverReport";
                //}
                //else
                //{
                spname = "usp_Bootstrap_bind_timesheets_new";
                //}

                SqlParameter[] param = new SqlParameter[15];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@cltid", hdncid.Value);
                param[2] = new SqlParameter("@FromTime", fromdate);
                param[3] = new SqlParameter("@ToTime", todate);
                param[4] = new SqlParameter("@Status", hdnTSStatus.Value);
                param[5] = new SqlParameter("@mJid", hdnjid.Value);
                param[6] = new SqlParameter("@Staffcode", staffcode);  //hdnEditStaffcode.Value);
                param[7] = new SqlParameter("@projectid", hdnpid.Value);
                param[8] = new SqlParameter("@sid", Convert.ToInt32(hdnsid.Value));
                param[9] = new SqlParameter("@staffrole", Staffrole);  //hdnRolename.Value);
                param[10] = new SqlParameter("@task", hdntask.Value);
                param[11] = new SqlParameter("@ChckMyTS", hdnmyStatus.Value);
                param[12] = new SqlParameter("@deptId", Convert.ToInt32(0));
                param[13] = new SqlParameter("@pageIndex", Convert.ToInt32(0));
                param[14] = new SqlParameter("@pageSize", Convert.ToInt32(0));
                ds = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, spname, param);
            }
            else
            {
                spname = "usp_Bootstrap_2levelTimesheet_new";
                SqlParameter[] param = new SqlParameter[14];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@cltid", hdncid.Value);
                param[2] = new SqlParameter("@FromTime", fromdate);
                param[3] = new SqlParameter("@totime", todate);
                param[4] = new SqlParameter("@status", hdnTSStatus.Value);
                param[5] = new SqlParameter("@mJid", hdnjid.Value);
                param[6] = new SqlParameter("@Sid", Convert.ToInt32(hdnsid.Value));
                param[7] = new SqlParameter("@staffcode", hdnEditStaffcode.Value);
                param[8] = new SqlParameter("@SuperAppr", hdnSuperAppr.Value);
                param[9] = new SqlParameter("@SubAppr", hdnSubAppr.Value);
                param[10] = new SqlParameter("@ChckMyTS", hdnmyStatus.Value);
                param[11] = new SqlParameter("@deptId", Convert.ToInt32(0));
                param[12] = new SqlParameter("@pageIndex", Convert.ToInt32(0));
                param[13] = new SqlParameter("@pageSize", Convert.ToInt32(0));

                ds = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, spname, param);
            }

            xlErr = "";
            DataTable dt;
            dt = ds.Tables[0];
            if (dt.Rows.Count > 0)
            {
                DumpExcel(dt);
            }
            else
            {
                MessageBox.Show("No Records To EXPORT.");
                // Code Commented By SathishRam For Hiding BlockerUI On 21-Mar-2023
                // ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee1", "Blockloaderhide();", true);
                // Code Commented By SathishRam For Hiding BlockerUI On 21-Mar-2023
            }

        }
        catch (Exception ex)
        {
            if (xlErr != "1")
            {
                MessageBox.Show("server not connected please try again.");
                // Code Commented By SathishRam For Hiding BlockerUI On 21-Mar-2023
                // ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee1", "Blockloaderhide();", true);
                // Code Commented By SathishRam For Hiding BlockerUI On 21-Mar-2023
            }
        }
    }

    private void DumpExcel(DataTable tbl)
    {
        using (XLWorkbook wb = new XLWorkbook())
        {
            //Create the worksheet
            string Ttype = "";
            if (hdnTSStatus.Value == "Approved")
            {

                Ttype = "Approved_Timesheet";
            }
            else
            {
                Ttype = "All_Timesheet";
            }

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            wb.Worksheets.Add(tbl, Ttype);
            wb.Worksheets.Worksheet(1).Columns().AdjustToContents();
            wb.Worksheets.Worksheet(1).Rows().AdjustToContents();

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
            // Code Added By SathishRam For Hiding BlockerUI On 21-Mar-2023
            // Code Commented By SathishRam For Hiding BlockerUI On 21-Mar-2023
            // ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee1", "Blockloaderhide();", true);
            // Code Commented By SathishRam For Hiding BlockerUI On 21-Mar-2023
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

    protected void btnTSNotl_Click(object sender, EventArgs e)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        string Staffrole = "";
        string staffcode = "";
        if (hdnRolename.Value == "Company-Admin")
        {
            Staffrole = "";
            staffcode = "0";

        }
        else
        {
            Staffrole = hdnRolename.Value;
            staffcode = hdnEditStaffcode.Value;
        }
        try
        {
            string spname = "";
            if (hdnFmdat1.Value == "")
            {
                hdnFmdat1.Value = hdnFromdate.Value;
            }
            if (hdnTodt1.Value == "")
            {
                hdnTodt1.Value = hdnTodate.Value;
            }

            string fromdate = hdnFmdat1.Value != "" ? Convert.ToDateTime(hdnFmdat1.Value, ci).ToString("MM/dd/yyyy") : null;
            string todate = hdnTodt1.Value != "" ? Convert.ToDateTime(hdnTodt1.Value, ci).ToString("MM/dd/yyyy") : null;

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@start", fromdate);
            param[2] = new SqlParameter("@end", todate);
            param[3] = new SqlParameter("@staffcode", staffcode);  //hdnEditStaffcode.Value);
            param[4] = new SqlParameter("@sid", hdnsid.Value);
            param[5] = new SqlParameter("@staffrole", Staffrole); //hdnRolename.Value);
            param[6] = new SqlParameter("@wk", hdnwk.Value);

            ds = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_TimeSheetNotSubmitted_Excel", param);
            DataTable dt;
            dt = ds.Tables[0];
            if (dt.Rows.Count > 0)
            {
                TSNOTDumpExcel(dt);
            }
            else
            {
                MessageBox.Show("No Records To EXPORT.");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee1", "Blockloaderhide();", true);
            }
        }
        catch (Exception ex)
        {
            if (xlErr != "1")
            {
                MessageBox.Show("server not connected please try again.");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee1", "Blockloaderhide();", true);
            }
        }
    }

    private void TSNOTDumpExcel(DataTable tbl)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            string Ttype = "TimeSheetNotSubmitted";

            ExcelWorksheet ws = pck.Workbook.Worksheets.Add(Ttype);

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

            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee1", "Blockloaderhide();", true);
            xlErr = "1";
            using (var memoryStream = new MemoryStream())
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=TimeSheetNotSubmitted.xls");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }

    protected void btnMiniExcel_Click(object sender, EventArgs e)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        string Staffrole = "";
        string staffcode = "";
        if (hdnRolename.Value == "Company-Admin")
        {
            Staffrole = "";
            staffcode = "0";

        }
        else
        {
            Staffrole = hdnRolename.Value;
            staffcode = hdnEditStaffcode.Value;
        }
        try
        {
            string spname = "";
            //var Staffcode = hdnEditStaffcode.Value;
            var Pagelevel = hdnPageLevel.Value;
            if (Convert.ToInt32(staffcode) == 0)
            {
                spname = "usp_Bootstrap_Minimum_Hours_report_new";
            }
            else
            {
                if (Convert.ToInt32(Pagelevel) > 2)
                {
                    spname = "usp_Bootstrap_3Approverstaff_Minimum_Hours_report_new";
                }
                else
                {
                    spname = "usp_Bootstrap_2Approverstaff_Minimum_Hours_report_new";
                }
            }

            if (hdnFmdat1.Value == "")
            {
                hdnFmdat1.Value = hdnFromdate.Value;
            }
            if (hdnTodt1.Value == "")
            {
                hdnTodt1.Value = hdnTodate.Value;
            }

            string fromdate = hdnFmdat1.Value != "" ? Convert.ToDateTime(hdnFmdat1.Value, ci).ToString("MM/dd/yyyy") : null;
            string todate = hdnTodt1.Value != "" ? Convert.ToDateTime(hdnTodt1.Value, ci).ToString("MM/dd/yyyy") : null;

            Common ob = new Common();

            SqlParameter[] param = new SqlParameter[10];
            param[0] = new SqlParameter("@companyId", Session["companyid"]);
            param[1] = new SqlParameter("@from_date", fromdate);
            param[2] = new SqlParameter("@to_date", todate);
            param[3] = new SqlParameter("@Sid", hdnsid.Value);
            param[4] = new SqlParameter("@staffcode", staffcode); //hdnEditStaffcode.Value);
            param[5] = new SqlParameter("@staff_role", Staffrole); //hdnRolename.Value);
            param[6] = new SqlParameter("@SuperAppr", hdnSuperAppr.Value);
            param[7] = new SqlParameter("@SubAppr", hdnSubAppr.Value);
            param[8] = new SqlParameter("@pageIndex", Convert.ToInt32(0));
            param[9] = new SqlParameter("@pageSize", Convert.ToInt32(0));

            ds = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, spname, param);
            DataTable dt;
            dt = ds.Tables[0];
            if (dt.Rows.Count > 0)
            {
                MinimumDumpExcel(dt);
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee1", "Blockloaderhide();", false);
            }
            else
            {
                MessageBox.Show("No Records To EXPORT.");
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee1", "Blockloaderhide();", true);
            }
        }
        catch (Exception ex)
        {
            if (xlErr != "1")
            {
                MessageBox.Show("server not connected please try again.");
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee1", "Blockloaderhide();", true);
            }
        }
    }

    private void MinimumDumpExcel(DataTable tbl)
    {
        try
        {
            using (ExcelPackage pck = new ExcelPackage())
            {
                //Create the worksheet
                string Ttype = "Minimum Hours not Entered";

                ExcelWorksheet ws = pck.Workbook.Worksheets.Add(Ttype);

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

                //ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee1", "Blockloaderhide();", true);
                xlErr = "1";
                using (var memoryStream = new MemoryStream())
                {
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", "attachment;  filename=MinimumHoursnotEntered.xls");
                    pck.SaveAs(memoryStream);
                    memoryStream.WriteTo(Response.OutputStream);
                    Response.Flush();
                    Response.SuppressContent = true;  // Gets or sets a value indicating whether to send HTTP content to the client.
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee1", "Blockloaderhide();", false);
                }
            }
        }
        catch (Exception ex)
        {
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "alertEmployee1", "Blockloaderhide();", true);
            throw ex;
        }
    }

    public string getCompanyExpenseMaster()
    {
        try
        {
            List<OPE_Master> objLocation = new List<OPE_Master>();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader((new CommonFunctions())._cnnString, CommandType.StoredProcedure, "usp_getCompanyExpenseMaster", param))
            {
                while (drrr.Read())
                {
                    objLocation.Add(new OPE_Master()
                    {
                        OpeId = (new CommonFunctions()).GetValue<int>(drrr["OpeId"].ToString()),
                        OPEName = (new CommonFunctions()).GetValue<string>(drrr["OPEName"].ToString()),
                    });
                }
            }
            return new JavaScriptSerializer().Serialize(objLocation as IEnumerable<OPE_Master>).ToString();
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }

    public string getCurrencyMaster()
    {
        try
        {
            List<tbl_Currency> objCurrency = new List<tbl_Currency>();
            using (SqlDataReader drrr = SqlHelper.ExecuteReader((new CommonFunctions())._cnnString, CommandType.StoredProcedure, "usp_getCurrencyMaster_New"))
            {
                while (drrr.Read())
                {
                    objCurrency.Add(new tbl_Currency()
                    {
                        Country = (new CommonFunctions()).GetValue<string>(drrr["Cntry"].ToString()),
                        Currency = (new CommonFunctions()).GetValue<string>(drrr["Currency"].ToString()),
                    });
                }
            }
            return new JavaScriptSerializer().Serialize(objCurrency as IEnumerable<tbl_Currency>).ToString();
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }

    [System.Web.Services.WebMethod]
    public static string SaveChartAndTableData(string chartImage, string tableData)
    {
        // Remove base64 prefix and convert chart image to byte array
        string chartBase64 = chartImage.Split(',')[1];
        byte[] chartBytes = Convert.FromBase64String(chartBase64);
        if (!string.IsNullOrEmpty(chartBase64) && !string.IsNullOrEmpty(tableData))
        {
            //// Remove "data:image/png;base64," prefix from the base64 string
            //chartBase64 = chartBase64.Substring(chartBase64.IndexOf(",") + 1);

            // Create a new PDF document
            Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 10f); // Margins

            using (MemoryStream memoryStream = new MemoryStream())
            {
                PdfWriter writer = PdfWriter.GetInstance(pdfDoc, memoryStream);

                // Open the PDF document
                pdfDoc.Open();

                // Add the chart image to the PDF
                iTextSharp.text.Image pdfChartImage = iTextSharp.text.Image.GetInstance(chartBytes);
                pdfChartImage.ScaleToFit(500f, 300f); // Adjust chart size
                pdfDoc.Add(pdfChartImage);

                // Add spacing between chart and table
                pdfDoc.Add(new Paragraph("\n\n"));

                // Parse and add the HTML table to the PDF
                using (StringReader sr = new StringReader(tableData))
                {
                    // Parse the HTML content and add it to the PDF
                    XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
                }

                // Close the PDF document
                pdfDoc.Close();

                // Return the PDF as a downloadable file
                byte[] bytes = memoryStream.ToArray();
                memoryStream.Close();

                HttpContext.Current.Response.ContentType = "application/pdf";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=ChartAndTable.pdf");
                HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
                HttpContext.Current.Response.BinaryWrite(bytes);
                HttpContext.Current.Response.End();
               
            }
        }
        else
        {
            // Handle case when there is no data provided (e.g., return an error message)
            HttpContext.Current.Response.Write("No data received for PDF generation.");
        }
        return "";
    }




    protected void btnExportPDF_Click(object sender, ImageClickEventArgs e)
    {
        string chartImage;
        string tableData;
        chartImage = "";
        tableData = "";

        chartImage = hdnChrtImg.Value;
        tableData = hdntblData.Value;
        string[] ttb = tableData.Split('|');
        string utl = ttb[0];
        tableData = ttb[1];
        // Remove base64 prefix and convert chart image to byte array
        string chartBase64 = chartImage.Split(',')[1];
        byte[] chartBytes = Convert.FromBase64String(chartBase64);
        if (!string.IsNullOrEmpty(chartBase64) && !string.IsNullOrEmpty(tableData))
        {

            // Create a new PDF document
            Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 10f); // Margins

            using (MemoryStream memoryStream = new MemoryStream())
            {
                PdfWriter writer = PdfWriter.GetInstance(pdfDoc, memoryStream);

                // Open the PDF document
                pdfDoc.Open();

                string ddts = hdnPDFData.Value;
                string []dvls = ddts.Split('~');

                iTextSharp.text.Font font = new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 12, iTextSharp.text.Font.BOLD);
                Paragraph paragraph = new Paragraph(dvls[0], font);
                paragraph.Alignment = Element.ALIGN_CENTER;
                pdfDoc.Add(paragraph);

                // Add another paragraph with different alignment
                Paragraph PName = new Paragraph("Project Summary " + dvls[1]);
                PName.Alignment = Element.ALIGN_LEFT;
                pdfDoc.Add(PName);

                // Add spacing between chart and table
                pdfDoc.Add(new Paragraph("\n\n"));



                ///// Create the main table with two columns
                PdfPTable mainTable = new PdfPTable(2);
                mainTable.WidthPercentage = 100;
                //// Set relative column widths for the chart (left) and the table (right)
                float[] columnWidths = { 2.5f, 1.5f }; // Adjust as needed to balance chart and table space
                mainTable.SetWidths(columnWidths);

                //// Create the sub-table with 3 columns
                PdfPTable subTable = new PdfPTable(2);
                subTable.WidthPercentage = 100; // Set the sub-table to occupy the full width of the cell


                //// Add the chart image to the PDF

                iTextSharp.text.Image pdfChartImage = iTextSharp.text.Image.GetInstance(chartBytes);
                pdfChartImage.ScaleToFit(250f, 150f); // Adjust chart size
                pdfChartImage.Alignment = Element.ALIGN_LEFT;

                //// Add the chart to the left cell of the main table
                PdfPCell chartCell = new PdfPCell(pdfChartImage);
                chartCell.Border = PdfPCell.NO_BORDER; // Optional: Remove borders for a cleaner look
                chartCell.HorizontalAlignment = Element.ALIGN_LEFT; // Align the content within the cell
               
                mainTable.AddCell(chartCell);

                ////// Utilisation table
                // Create a bold font for the cell
                iTextSharp.text.Font boldFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 12);
                Phrase boldCenteredPhrase = new Phrase("Utilisation Hours Summary", boldFont);
                PdfPCell boldCenteredCell = new PdfPCell(boldCenteredPhrase)
                {
                    Colspan = 2,
                    HorizontalAlignment = Element.ALIGN_CENTER, // Center align text horizontally
                    VerticalAlignment = Element.ALIGN_MIDDLE,  // Middle align text vertically
                    Padding = 10,                              // Optional padding for better appearance
                    BorderWidth = 1                            // Border width (optional)
                };
                subTable.AddCell(boldCenteredCell);

                ////  1st Row
                string[] uVal = utl.Split('^');
                PdfPCell Subcell1 = new PdfPCell(new Phrase("Total Man Hours  " ));
                Subcell1.BackgroundColor = BaseColor.LIGHT_GRAY;
                Subcell1.BorderWidth = 1;
                subTable.AddCell(Subcell1);

                ////// value
                PdfPCell SubVal1 = new PdfPCell(new Phrase(uVal[0]));
                SubVal1.BackgroundColor = BaseColor.LIGHT_GRAY;
                SubVal1.BorderWidth = 1;
                subTable.AddCell(SubVal1);

                /////////////  2nd Row
                 
                PdfPCell Subcell2 = new PdfPCell(new Phrase("Holiday Hours  "));
                Subcell2.BackgroundColor = BaseColor.LIGHT_GRAY;
                Subcell2.BorderWidth = 1;
                subTable.AddCell(Subcell2);

                ////// 2st Row value
                PdfPCell SubVal2 = new PdfPCell(new Phrase(uVal[1]));
                SubVal2.BackgroundColor = BaseColor.LIGHT_GRAY;
                SubVal2.BorderWidth = 1;
                subTable.AddCell(SubVal2);

                /////////////  3rd Row

                PdfPCell Subcell3 = new PdfPCell(new Phrase("Available Man Hours  "));
                Subcell3.BackgroundColor = BaseColor.LIGHT_GRAY;
                Subcell3.BorderWidth = 1;
                subTable.AddCell(Subcell3);

                ////// 3rd Row value
                PdfPCell SubVal3 = new PdfPCell(new Phrase(uVal[2]));
                SubVal3.BackgroundColor = BaseColor.LIGHT_GRAY;
                SubVal3.BorderWidth = 1;
                subTable.AddCell(SubVal3);
               
                /////////////  4th Row

                PdfPCell Subcell4 = new PdfPCell(new Phrase("Proj.Dlvry Man Hrs  "));
                Subcell4.BackgroundColor = BaseColor.LIGHT_GRAY;
                Subcell4.BorderWidth = 1;
                subTable.AddCell(Subcell4);

                ////// 4th Row value
                PdfPCell SubVal4 = new PdfPCell(new Phrase(uVal[3]));
                SubVal4.BackgroundColor = BaseColor.LIGHT_GRAY;
                SubVal4.BorderWidth = 1;
                subTable.AddCell(SubVal4);

                /////////////  5th Row

                PdfPCell Subcell5 = new PdfPCell(new Phrase("Utilization  "));
                Subcell5.BackgroundColor = BaseColor.LIGHT_GRAY;
                Subcell5.BorderWidth = 1;
                subTable.AddCell(Subcell5);

                ////// 4th Row value
                PdfPCell SubVal5 = new PdfPCell(new Phrase(uVal[4]));
                SubVal5.BackgroundColor = BaseColor.LIGHT_GRAY;
                SubVal5.BorderWidth = 1;
                subTable.AddCell(SubVal5);

                ////// Adding the subtable to maintable
                mainTable.AddCell(subTable);

                pdfDoc.Add(mainTable);

                // Add spacing between chart and table
                pdfDoc.Add(new Paragraph("\n\n"));

                // Create a table with 3 columns
                PdfPTable Dtable = new PdfPTable(7);
                Dtable.WidthPercentage = 100; // Set table width to 100% of the page


                PdfPCell cell2 = new PdfPCell(new Phrase("Project"));
                cell2.BackgroundColor = BaseColor.LIGHT_GRAY;
                cell2.BorderWidth = 1;
                Dtable.AddCell(cell2);

                PdfPCell cell3 = new PdfPCell(new Phrase("Client"));
                cell3.BackgroundColor = BaseColor.LIGHT_GRAY;
                cell3.BorderWidth = 1;
                Dtable.AddCell(cell3);

                PdfPCell cell4 = new PdfPCell(new Phrase("Team"));
                cell4.BackgroundColor = BaseColor.LIGHT_GRAY; // Optional: Add background color to header
                cell4.BorderWidth = 1; // Set border width
                Dtable.AddCell(cell4);

                PdfPCell cell5 = new PdfPCell(new Phrase("Total Hrs"));
                cell5.BackgroundColor = BaseColor.LIGHT_GRAY;
                cell5.BorderWidth = 1;
                Dtable.AddCell(cell5);

                PdfPCell cell6 = new PdfPCell(new Phrase("%"));
                cell6.BackgroundColor = BaseColor.LIGHT_GRAY;
                cell6.BorderWidth = 1;
                Dtable.AddCell(cell6);

                PdfPCell cell7 = new PdfPCell(new Phrase("Start DT"));
                cell7.BackgroundColor = BaseColor.LIGHT_GRAY; // Optional: Add background color to header
                cell7.BorderWidth = 1; // Set border width
                Dtable.AddCell(cell7);

                PdfPCell cell8 = new PdfPCell(new Phrase("End DT"));
                cell8.BackgroundColor = BaseColor.LIGHT_GRAY;
                cell8.BorderWidth = 1;
                Dtable.AddCell(cell8);

                //PdfPCell cell9 = new PdfPCell(new Phrase("Billable"));
                //cell9.BackgroundColor = BaseColor.LIGHT_GRAY;
                //cell9.BorderWidth = 1;
                //Dtable.AddCell(cell9);

                //PdfPCell cell10 = new PdfPCell(new Phrase("Non Billable"));
                //cell10.BackgroundColor = BaseColor.LIGHT_GRAY;
                //cell10.BorderWidth = 1;
                //Dtable.AddCell(cell10);

                // Add rows to the table
                 string[] tr = tableData.Split('^');
                 int tcnt = Convert.ToInt32( hdnTblCnt.Value.ToString());
                //tcnt = tcnt - 1;
                if (tcnt < 0)
                {
                    tcnt = 0;
                }
                for (int i = 0; i <= tcnt-2; i++)
                {
                    string tRow = tr[i];
                    string[] tCol = tRow.Split('~');
                    for (int j = 1; j <= 7; j++)
                    {
                        PdfPCell cell = new PdfPCell(new Phrase(tCol[j]));
                        //cell.BackgroundColor = BaseColor.LIGHT_GRAY;
                        cell.HorizontalAlignment = Element.ALIGN_CENTER;
                        cell.BorderWidth = 1;
                        Dtable.AddCell(cell);

                        //Dtable.AddCell(new PdfPCell(new Phrase(tCol[j])) { BorderWidth = 1 });
                    }
                }
                pdfDoc.Add(Dtable);

                // Close the PDF document
                pdfDoc.Close();

                // Return the PDF as a downloadable file
                byte[] bytes = memoryStream.ToArray();
                memoryStream.Close();

                HttpContext.Current.Response.ContentType = "application/pdf";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=ChartAndTable.pdf");
                HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
                HttpContext.Current.Response.BinaryWrite(bytes);
                HttpContext.Current.Response.End();

            }
        }
        else
        {
            // Handle case when there is no data provided (e.g., return an error message)
            HttpContext.Current.Response.Write("No data received for PDF generation.");
        }
    }

    protected void btnTMExportPDF_Click(object sender, ImageClickEventArgs e)
    {
        string chartImage;
        string tableData;
        chartImage = "";
        tableData = "";

        chartImage = hdnChrtImg.Value;
        tableData = hdntblData.Value;
        string[] ttb = tableData.Split('|');
        string utl = ttb[0];
        tableData = ttb[1];
        // Remove base64 prefix and convert chart image to byte array
        string chartBase64 = chartImage.Split(',')[1];
        byte[] chartBytes = Convert.FromBase64String(chartBase64);
        if (!string.IsNullOrEmpty(chartBase64) && !string.IsNullOrEmpty(tableData))
        {

            // Create a new PDF document
            Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 10f); // Margins

            using (MemoryStream memoryStream = new MemoryStream())
            {
                PdfWriter writer = PdfWriter.GetInstance(pdfDoc, memoryStream);

                // Open the PDF document
                pdfDoc.Open();

                string ddts = hdnPDFData.Value;
                string[] dvls = ddts.Split('~');

                iTextSharp.text.Font font = new iTextSharp.text.Font(iTextSharp.text.Font.FontFamily.HELVETICA, 12, iTextSharp.text.Font.BOLD);
                Paragraph paragraph = new Paragraph(dvls[0], font);
                paragraph.Alignment = Element.ALIGN_CENTER;
                pdfDoc.Add(paragraph);

                // Add another paragraph with different alignment
                Paragraph PName = new Paragraph("Team Summary " + dvls[1]);
                PName.Alignment = Element.ALIGN_LEFT;
                pdfDoc.Add(PName);

                // Add spacing between chart and table
                pdfDoc.Add(new Paragraph("\n\n"));



                ///// Create the main table with two columns
                PdfPTable mainTable = new PdfPTable(2);
                mainTable.WidthPercentage = 100;
                //// Set relative column widths for the chart (left) and the table (right)
                float[] columnWidths = { 2.5f, 1.5f }; // Adjust as needed to balance chart and table space
                mainTable.SetWidths(columnWidths);

                //// Create the sub-table with 3 columns
                PdfPTable subTable = new PdfPTable(2);
                subTable.WidthPercentage = 100; // Set the sub-table to occupy the full width of the cell


                //// Add the chart image to the PDF

                iTextSharp.text.Image pdfChartImage = iTextSharp.text.Image.GetInstance(chartBytes);
                pdfChartImage.ScaleToFit(250f, 150f); // Adjust chart size
                pdfChartImage.Alignment = Element.ALIGN_LEFT;

                //// Add the chart to the left cell of the main table
                PdfPCell chartCell = new PdfPCell(pdfChartImage);
                chartCell.Border = PdfPCell.NO_BORDER; // Optional: Remove borders for a cleaner look
                chartCell.HorizontalAlignment = Element.ALIGN_LEFT; // Align the content within the cell

                mainTable.AddCell(chartCell);

                ////// Utilisation table
                // Create a bold font for the cell
                iTextSharp.text.Font boldFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 12);
                Phrase boldCenteredPhrase = new Phrase("Utilisation Hours Summary", boldFont);
                PdfPCell boldCenteredCell = new PdfPCell(boldCenteredPhrase)
                {
                    Colspan = 2,
                    HorizontalAlignment = Element.ALIGN_CENTER, // Center align text horizontally
                    VerticalAlignment = Element.ALIGN_MIDDLE,  // Middle align text vertically
                    Padding = 10,                              // Optional padding for better appearance
                    BorderWidth = 1                            // Border width (optional)
                };
                subTable.AddCell(boldCenteredCell);

                ////  1st Row
                string[] uVal = utl.Split('^');
                PdfPCell Subcell1 = new PdfPCell(new Phrase("Total Man Hours  "));
                Subcell1.BackgroundColor = BaseColor.LIGHT_GRAY;
                Subcell1.BorderWidth = 1;
                subTable.AddCell(Subcell1);

                ////// value
                PdfPCell SubVal1 = new PdfPCell(new Phrase(uVal[0]));
                SubVal1.BackgroundColor = BaseColor.LIGHT_GRAY;
                SubVal1.BorderWidth = 1;
                subTable.AddCell(SubVal1);

                /////////////  2nd Row

                PdfPCell Subcell2 = new PdfPCell(new Phrase("Holiday Hours  "));
                Subcell2.BackgroundColor = BaseColor.LIGHT_GRAY;
                Subcell2.BorderWidth = 1;
                subTable.AddCell(Subcell2);

                ////// 2st Row value
                PdfPCell SubVal2 = new PdfPCell(new Phrase(uVal[1]));
                SubVal2.BackgroundColor = BaseColor.LIGHT_GRAY;
                SubVal2.BorderWidth = 1;
                subTable.AddCell(SubVal2);

                /////////////  3rd Row

                PdfPCell Subcell3 = new PdfPCell(new Phrase("Available Man Hours  "));
                Subcell3.BackgroundColor = BaseColor.LIGHT_GRAY;
                Subcell3.BorderWidth = 1;
                subTable.AddCell(Subcell3);

                ////// 3rd Row value
                PdfPCell SubVal3 = new PdfPCell(new Phrase(uVal[2]));
                SubVal3.BackgroundColor = BaseColor.LIGHT_GRAY;
                SubVal3.BorderWidth = 1;
                subTable.AddCell(SubVal3);

                /////////////  4th Row

                PdfPCell Subcell4 = new PdfPCell(new Phrase("Dlvry Man Hrs  "));
                Subcell4.BackgroundColor = BaseColor.LIGHT_GRAY;
                Subcell4.BorderWidth = 1;
                subTable.AddCell(Subcell4);

                ////// 4th Row value
                PdfPCell SubVal4 = new PdfPCell(new Phrase(uVal[3]));
                SubVal4.BackgroundColor = BaseColor.LIGHT_GRAY;
                SubVal4.BorderWidth = 1;
                subTable.AddCell(SubVal4);

                /////////////  5th Row

                PdfPCell Subcell5 = new PdfPCell(new Phrase("Utilization  "));
                Subcell5.BackgroundColor = BaseColor.LIGHT_GRAY;
                Subcell5.BorderWidth = 1;
                subTable.AddCell(Subcell5);

                ////// 4th Row value
                PdfPCell SubVal5 = new PdfPCell(new Phrase(uVal[4]));
                SubVal5.BackgroundColor = BaseColor.LIGHT_GRAY;
                SubVal5.BorderWidth = 1;
                subTable.AddCell(SubVal5);

                ////// Adding the subtable to maintable
                mainTable.AddCell(subTable);

                pdfDoc.Add(mainTable);

                // Add spacing between chart and table
                pdfDoc.Add(new Paragraph("\n\n"));

                // Create a table with 3 columns
                PdfPTable Dtable = new PdfPTable(8);
                Dtable.WidthPercentage = 100; // Set table width to 100% of the page


                PdfPCell cell2 = new PdfPCell(new Phrase("Staff"));
                cell2.BackgroundColor = BaseColor.LIGHT_GRAY;
                cell2.BorderWidth = 1;
                Dtable.AddCell(cell2);

                PdfPCell cell3 = new PdfPCell(new Phrase("Department"));
                cell3.BackgroundColor = BaseColor.LIGHT_GRAY;
                cell3.BorderWidth = 1;
                Dtable.AddCell(cell3);

                PdfPCell cell4 = new PdfPCell(new Phrase("Designation"));
                cell4.BackgroundColor = BaseColor.LIGHT_GRAY; // Optional: Add background color to header
                cell4.BorderWidth = 1; // Set border width
                Dtable.AddCell(cell4);

                PdfPCell cell5 = new PdfPCell(new Phrase("Total Hrs"));
                cell5.BackgroundColor = BaseColor.LIGHT_GRAY;
                cell5.BorderWidth = 1;
                Dtable.AddCell(cell5);

                PdfPCell cell6 = new PdfPCell(new Phrase("Effort Hrs"));
                cell6.BackgroundColor = BaseColor.LIGHT_GRAY;
                cell6.BorderWidth = 1;
                Dtable.AddCell(cell6);

                PdfPCell cell7 = new PdfPCell(new Phrase("Leave"));
                cell7.BackgroundColor = BaseColor.LIGHT_GRAY; // Optional: Add background color to header
                cell7.BorderWidth = 1; // Set border width
                Dtable.AddCell(cell7);

                PdfPCell cell8 = new PdfPCell(new Phrase("Avail Hrs"));
                cell8.BackgroundColor = BaseColor.LIGHT_GRAY;
                cell8.BorderWidth = 1;
                Dtable.AddCell(cell8);

                PdfPCell cell9 = new PdfPCell(new Phrase("%"));
                cell9.BackgroundColor = BaseColor.LIGHT_GRAY;
                cell9.BorderWidth = 1;
                Dtable.AddCell(cell9);

                //PdfPCell cell10 = new PdfPCell(new Phrase("Non Billable"));
                //cell10.BackgroundColor = BaseColor.LIGHT_GRAY;
                //cell10.BorderWidth = 1;
                //Dtable.AddCell(cell10);

                // Add rows to the table
                string[] tr = tableData.Split('^');
                int tcnt = Convert.ToInt32(hdnTblCnt.Value.ToString());
                //tcnt = tcnt - 1;
                if (tcnt < 0)
                {
                    tcnt = 0;
                }
                for (int i = 0; i <= tcnt - 2; i++)
                {
                    string tRow = tr[i];
                    string[] tCol = tRow.Split('~');
                    for (int j = 1; j <= 8; j++)
                    {
                        PdfPCell cell = new PdfPCell(new Phrase(tCol[j]));
                        //cell.BackgroundColor = BaseColor.LIGHT_GRAY;
                        cell.HorizontalAlignment = Element.ALIGN_CENTER;
                        cell.BorderWidth = 1;
                        Dtable.AddCell(cell);

                        //Dtable.AddCell(new PdfPCell(new Phrase(tCol[j])) { BorderWidth = 1 });
                    }
                }
                pdfDoc.Add(Dtable);

                // Close the PDF document
                pdfDoc.Close();

                // Return the PDF as a downloadable file
                byte[] bytes = memoryStream.ToArray();
                memoryStream.Close();

                HttpContext.Current.Response.ContentType = "application/pdf";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=TeamChartAndTable.pdf");
                HttpContext.Current.Response.Cache.SetCacheability(HttpCacheability.NoCache);
                HttpContext.Current.Response.BinaryWrite(bytes);
                HttpContext.Current.Response.End();

            }
        }
        else
        {
            // Handle case when there is no data provided (e.g., return an error message)
            HttpContext.Current.Response.Write("No data received for PDF generation.");
        }
    }
}