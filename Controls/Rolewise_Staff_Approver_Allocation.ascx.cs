using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using JTMSProject;
using System.Web.Security;
using System.Text;
using System.Net.Mail;
using System.Configuration;
using AjaxControlToolkit;
using System.Text.RegularExpressions;
using System.IO;
using System.Collections;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml;
using System.Web.Services;
using System.Management;
using System.Web.Caching;
using System.Drawing;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using Microsoft.Reporting.WebForms;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using CommonLibrary;

public partial class controls_Rolewise_Staff_Approver_Allocation : System.Web.UI.UserControl
{

    LabelAccess objlabelAccess = new LabelAccess();
    List<tbl_LabelAccess> LtblAccess;

     protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {

                hdncompid.Value = Session["companyid"].ToString();
                hdnAppPatern.Value = Session["ApproverPattern"].ToString();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
    }



     protected void btnExportToExcel_Click(object sender, ImageClickEventArgs e)
     {
         try
         {
             SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
             string[] hdnval = TypeStaffRole.Value.Split(',');
             
             string sVal = hdnval[1];
             string RoleId = hdnval[2];
            
             if (sVal == "0")
             {
                 ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Please Select Approver Name')", true);
             }
             else
             {

                 SqlParameter[] param = new SqlParameter[4];
                 param[0] = new SqlParameter("@Compid", hdncompid.Value);
                 param[1] = new SqlParameter("@ApproverId", sVal);
                 param[2] = new SqlParameter("@RoleId", RoleId);
                 param[3] = new SqlParameter("@Type", hdnval[0]);
                 DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "Get_ApproverWise_ProjectStaff_Excel", param);
                 if (ds != null) {
                     if (ds.Tables[0].Rows.Count > 0)
                     {
                         DataTable dt = ds.Tables[0];
                         DumpExcel(dt);
                     }
                     else {
                         ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('No Record Found')", true);
                     }
                 }
             }

         }
         catch (Exception ex) {
             throw ex;
         }
     }


     private void DumpExcel(DataTable tbl)
     {
         LabelAccess objlabelAccess = new LabelAccess();
         LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(Session["companyid"].ToString()));
         foreach (DataColumn col in tbl.Columns)
         {
             col.ColumnName = changelabel(col.ColumnName);
         }

         using (ExcelPackage pck = new ExcelPackage())
         {
             //Create the worksheet
             ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Approver_Allocation");

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


             string ds = "K2:K";
             using (ExcelRange rn = ws.Cells[ds])
             {
                 rn.Style.Numberformat.Format = "h:mm";
             }

             using (var memoryStream = new MemoryStream())
             {
                 Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                 Response.AddHeader("content-disposition", "attachment;  filename=All_Timesheet_Admin.xls");
                 pck.SaveAs(memoryStream);
                 memoryStream.WriteTo(Response.OutputStream);
                 Response.Flush();
                 Response.End();
             }
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

        }
        return ChangeLabel;
    }
}