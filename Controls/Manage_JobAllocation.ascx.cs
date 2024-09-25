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
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using CommonLibrary;

public partial class controls_Manage_JobAllocation : System.Web.UI.UserControl
{
    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());

    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();

    int pageid = 162; 
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            hdnpageIndex.Value = "1";
            hdnStfBud_New.Value = "";
            if (Session["companyid"] != null)
            {
                string Link_JobnTask = objDAL_PagePermissions.Dal_getLinks(Convert.ToInt32(Session["companyid"]));
                hdnlink.Value = Link_JobnTask;

                ViewState["compid"] = Session["companyid"].ToString();
                hdnCompanyid.Value = Session["companyid"].ToString();
                hdndptwise.Value = Session["deptwise"].ToString();
                hdnTaskwise.Value = Session["taskwise"].ToString(); 
            }
            else if (Session["staffid"] != null)
            {
                string Link_JobnTask = objDAL_PagePermissions.Dal_getLinks(Convert.ToInt32(Session["companyid"]));
                hdnlink.Value = Link_JobnTask;
                ViewState["compid"] = Session["cltcomp"].ToString();
                hdnCompanyid.Value = Session["cltcomp"].ToString();
            }
            if (ViewState["compid"] != null)
            {
                DivGrd.Style.Value = "display:block";
                hdnIP.Value = Session["IP"].ToString();
                hdnName.Value = Session["fulname"].ToString();
                hdnUser.Value = Session["usertype"].ToString();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

            getrolepermission();
        }
       ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "MakeStaffSummaryFooterfff", "$(document).ready(function () { MakeSmartSearch();}); ", true);
  
        txtSearchby.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
    }

    private void getrolepermission()
    {
        //string objL = objDAL_PagePermissions.Dal_getRolepermission(pageid, Convert.ToInt32(Session["UserRole"]), Convert.ToInt32(Session["companyid"]));
        //hdnrolepermission.Value = objL;
        //bool a = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "add");

        //if (a == false)
        //{
        //    btnadd.Visible = false;
        //}
     

        //bool e = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "edit");
        //if (e == false)
        //{

        //    thedit.Visible = false;
        //}

        //hdnroleedit.Value = e.ToString();
        //bool d = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "delete");
        //if (d == false)

        //{
        //    thdelete.Visible = false;
        //}



        //hdnroledelete.Value = d.ToString();

        //bool other = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "Edit Other Details");
        //hdnroleotherdetail.Value = other.ToString();
        //bool status = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "Edit Job Status");
        //hdnrolestatus.Value = status.ToString();
        //bool edate = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "Edit End Date");
        //hdnroleenddate.Value = edate.ToString();
        //bool bill = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "Edit Billable");
        //hdnrolebilliable.Value = bill.ToString();
        //bool appr = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "Edit Approver");
        //hdnroleapprover.Value = appr.ToString();
        //bool staff = objDAL_PagePermissions.DAL_getpermission(hdnrolepermission.Value, "Edit Staff");
        //hdnrolestaff.Value = staff.ToString();


        
    }

    protected void btnpage_Click(object sender, EventArgs e)
    {
        //Session["staff"] = hdnStfcode.Value;
        Session["jobid"] = hdnJobid.Value;
        Response.Redirect("EditJobAdd.aspx");
    }
    protected void btnExportToexcel_Click(object sender, ImageClickEventArgs e)
    {
        string Clt = "";
        string Prj = "";
        string Job = "";

        if (ddlSearchby.SelectedValue == "Project")
        {
            Prj = txtSearchby.Text; 
        }
        else
        {
            Clt = txtSearchby.Text; 
        }

        DataSet ds;
        SqlParameter[] param = new SqlParameter[6];
        param[0] = new SqlParameter("@compid", ViewState["compid"]);
        param[1] = new SqlParameter("@JobStatus", "OnGoing");
        param[2] = new SqlParameter("@Cname", Clt);
        param[3] = new SqlParameter("@jname", Job);
        param[4] = new SqlParameter("@project", Prj);
        param[5] = new SqlParameter("@hdndpt", hdndptwise.Value.ToString());

        ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_Bind_NewJobAllocation_XL", param);
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

    private void DumpExcel(DataTable tbl)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Job_Allocation");

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            ws.Cells["A1"].LoadFromDataTable(tbl, true);
            ws.Cells.AutoFitColumns();
            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:AI1"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  
                rng.Style.Font.Color.SetColor(Color.White);
            }


            //string ds = "J2:J" + (tbl.Rows.Count + 100).ToString();
            //using (ExcelRange rn = ws.Cells[ds])
            //{
            //    rn.Style.Numberformat.Format = "h:mm";
            //}


            using (var memoryStream = new MemoryStream())
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=Job_Allocation.xls");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }
}