using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JTMSProject;
using System.Globalization;
using Microsoft.Reporting.WebForms;
using CommonLibrary;
using Microsoft.ApplicationBlocks1.Data;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using System.IO;


public partial class controls_Weekwise_Report : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    CultureInfo info = new CultureInfo("en-GB");
    AllTimesheetGridBind objAllTimesheetGridBind = new AllTimesheetGridBind();
    LabelAccess objlabelAccess = new LabelAccess();
    List<tbl_LabelAccess> LtblAccess;
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
              //  string dat = DateTime.Now.Month + "/" + DateTime.Now.Year;
                //txtmonth.Text = dat;
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
                weekwiseReport tblTimesheetGrid = new weekwiseReport();

                if (hdnmonth.Value == "")
                {
                    MessageControl1.SetMessage("From Date Cannot be blank", MessageDisplay.DisplayStyles.Error);
                    return;
                }

                if (hdnSelectedStaffCode.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one Staff !", MessageDisplay.DisplayStyles.Error);
                    return;
                }

                tblTimesheetGrid.compid = Session["companyid"].ToString();
                tblTimesheetGrid.staffid = hdnSelectedStaffCode.Value;
                tblTimesheetGrid.mondate = Convert.ToDateTime(hdnmonth.Value, info);
                DateTime date = Convert.ToDateTime(hdnmonth.Value, info);
                string month = date.ToString("MMM");
                int Year = date.Year;

                DataSet ds = objAllTimesheetGridBind.GetWeekwise_Export(tblTimesheetGrid);
                DataTable dt;
                dt = ds.Tables[0];

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DumpExcel_Timesheet(dt, "Weekwise_Report" + "-" + "" + month + "" + "-" + "" + Year + "");
                }
                else
                {
                    MessageControl1.SetMessage("No Records Found, Export Failed", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                Response.Redirect("~/Company/Weekwise_Report.aspx", false);
            }
        }
        catch(Exception ex)
        {
            MessageControl1.SetMessage("No Timesheet Found..", MessageDisplay.DisplayStyles.Error);
        }
    }

    private void DumpExcel_Timesheet(DataTable tbl, string Sname)
    {
        LabelAccess objlabelAccess = new LabelAccess();
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(Session["companyid"].ToString()));
        foreach (DataColumn col in tbl.Columns)
        {
            col.ColumnName = changelabel(col.ColumnName);   
        }
        int t = tbl.Columns.Count;

        tbl.Columns["w1Billable"].ColumnName = "Week1_B";
        tbl.Columns["w1Cosumed"].ColumnName = "Week1_C";
        tbl.Columns["w1Available"].ColumnName = "Week1_A";
        tbl.Columns["w2Billable"].ColumnName ="Week2_B";
        tbl.Columns["w2Cosumed"].ColumnName = "Week2_C";
        tbl.Columns["w2Available"].ColumnName = "Week2_A";
        tbl.Columns["w3Billable"].ColumnName = "Week3_B";
        tbl.Columns["w3Cosumed"].ColumnName = "Week3_C";
        tbl.Columns["w3Available"].ColumnName = "Week3_A";
        tbl.Columns["w4Billable"].ColumnName = "Week4_B";
        tbl.Columns["w4Cosumed"].ColumnName = "Week4_C";
        tbl.Columns["w4Available"].ColumnName = "Week4_A";

        //int cout =int.Parse(tbl1.Rows[0]["count"].ToString());

        if (t > 13)
        {
            tbl.Columns["w5Billable"].ColumnName = "Week5_B";
            tbl.Columns["w5Cosumed"].ColumnName = "Week5_C";
            tbl.Columns["w5Available"].ColumnName = "Week5_A";
        }

        tbl.AcceptChanges();

        try
        {
            using (ExcelPackage pck = new ExcelPackage())
            {
                //Create the worksheet
                ExcelWorksheet ws = pck.Workbook.Worksheets.Add(Sname);

                //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
                ws.Cells["A5"].LoadFromDataTable(tbl, true);
                ws.Cells.AutoFitColumns();
                //Format the header for column 1-3
                using (ExcelRange rng = ws.Cells["A5:AI5"])
                {
                    rng.Style.Font.Bold = true;
                    rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                    rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                    rng.Style.Font.Color.SetColor(Color.White);
                }
                ws.Cells[1,1].Value = Sname;
                //string ds = "D2:D" + (tbl.Rows.Count + 100).ToString();
                //using (ExcelRange rn = ws.Cells[ds])
                //{
                //    rn.Style.Numberformat.Format = "h:mm";
                //}
                Response.ClearContent();
                Response.Buffer = true;
                //Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", "TimeSheet-Staff Summary " + txtdateBindStaff.Text + ".xls"));
                //Response.ContentType = "application/ms-excel";
                using (var memoryStream = new MemoryStream())
                {
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", "attachment;  filename=" + Sname + ".xls");
                    pck.SaveAs(memoryStream);
                    memoryStream.WriteTo(Response.OutputStream);
                    Response.Flush();
                    Response.End();
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    

    public string changelabel(string ChangeLabel)
    {
        try
        {
            string s, r;
            foreach (var item in LtblAccess)
            {
                r = item.LabelName;
                s = item.LabelAccessValue;
                ChangeLabel = ChangeLabel.Replace(r, s);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ChangeLabel;
    }
}