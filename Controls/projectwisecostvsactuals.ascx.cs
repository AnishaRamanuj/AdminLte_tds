using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Services.Protocols;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Web.Script.Serialization;
using System.Globalization;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.IO;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;

public partial class controls_projectwisecostvsactuals : System.Web.UI.UserControl
{
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    string xlErr = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                hdncompid.Value = Session["companyid"].ToString();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            //txtfrmdt.Text = "01/04/" + (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year);
            //txttodt.Text = Convert.ToDateTime(DateTime.Now, ci).ToString("dd/MM/yyyy");
            TaskDeptJobwise();
        }
    }

    private void TaskDeptJobwise()
    {
        try
        {
            DataSet ds = new DataSet();
            SqlParameter[] parameter = new SqlParameter[1];
            parameter[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"]).ToString());
            ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_getClientProjectStaffJobs", parameter);
            if (ds != null)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    string strdept = ds.Tables[0].Rows[0]["Deptwise"].ToString();
                    if (strdept == "1")
                    {
                        tdjobselection.Visible = false;
                    }
                  
                }
            }


        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    protected void btngrnreport_Click(object sender, EventArgs e)
    {
        DataSet ds = new DataSet();
        try
        {
            
            SqlParameter[] param=new SqlParameter[7];
            param[0] = new SqlParameter("@compid", hdncompid.Value);
            param[1] = new SqlParameter("@selectedcltids", hdnselectedcltids.Value.TrimEnd(','));
            param[2] = new SqlParameter("@selectedprojectids", hdnselectedprojectids.Value.TrimEnd(','));
            param[3] = new SqlParameter("@from", Convert.ToDateTime(txtfrmdt.Text, ci));
            param[4] = new SqlParameter("@to", Convert.ToDateTime(txttodt.Text, ci));
            param[5] = new SqlParameter("@status", hdnTStatusCheck.Value.TrimEnd(','));
            param[6] = new SqlParameter("@selectedjobid", hdnselectedjobid.Value.TrimEnd(','));
            ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_generateClientProjectwiseBudgetingReport", param);
            gv_Budgting.DataSource = ds;
            gv_Budgting.DataBind();
            divReport.Visible = true;
           dv_input.Visible = false;
        }
        catch (Exception ex) { throw ex; }

    }
    protected void btncalcle_Click(object sender, EventArgs e)
    {
        divReport.Visible = false;
        dv_input.Visible = true;
    }
    protected void btnExportToexcel_Click(object sender, ImageClickEventArgs e)
    {
        DataSet ds = new DataSet();
        try
        {
            //Response.Clear();
            //Response.Buffer = true;
            //Response.AddHeader("content-disposition", "attachment;filename=ProjectWise_Budgeting " + Convert.ToDateTime(DateTime.Now).ToString("dd/MM/yyyy") + ".xls");
            //Response.Charset = "";
            //Response.ContentType = "application/vnd.ms-excel";

            //using (StringWriter sw = new StringWriter())
            //{
            //    HtmlTextWriter hw = new HtmlTextWriter(sw);

            //    gv_Budgting.RenderControl(hw);

            //    //style to format numbers to string
            //    string style = @"<style> .textmode { } </style>";
            //    Response.Write(style);
            //    Response.Output.Write(sw.ToString());
            //    Response.Flush();
            //    Response.End();
            SqlParameter[] param=new SqlParameter[7];
            param[0] = new SqlParameter("@compid", hdncompid.Value);
            param[1] = new SqlParameter("@selectedcltids", hdnselectedcltids.Value.TrimEnd(','));
            param[2] = new SqlParameter("@selectedprojectids", hdnselectedprojectids.Value.TrimEnd(','));
            param[3] = new SqlParameter("@from", Convert.ToDateTime(txtfrmdt.Text, ci));
            param[4] = new SqlParameter("@to", Convert.ToDateTime(txttodt.Text, ci));
            param[5] = new SqlParameter("@status", hdnTStatusCheck.Value);
            param[6] = new SqlParameter("@selectedjobid", hdnselectedjobid.Value.TrimEnd(','));
            ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_generateClientProjectwiseBudgetingexcelexport", param);
            DataTable dt = ds.Tables[0];
            if (dt.Rows.Count > 0)
            {
                DumpExcel(dt);
            }
            else {
                MessageBox.Show("No Records To EXPORT.");
            }
            }
        

        catch(Exception ex) {
            throw ex;
        }
    }



    private void DumpExcel(DataTable tbl)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("All_Timesheet");

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
                Response.AddHeader("content-disposition", "attachment;  filename=ProjectWise_Budgeting.xls");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }
}