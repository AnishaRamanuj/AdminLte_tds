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
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using CommonLibrary;

public partial class controls_cmp_ManageJob : System.Web.UI.UserControl
{
    LabelAccess objlabelAccess = new LabelAccess();
    List<tbl_LabelAccess> LtblAccess;
    private readonly DBAccess db = new DBAccess();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                ViewState["compid"] = Session["companyid"].ToString();
                bindgrid1();

            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["cltcomp"].ToString();
            }
       
        }

    }
    public SqlDataSource userlist_data
    {
        get { return SqlDataSource1; }
    }

    public void bindgrid1()
    {

        try
        {
            userlist_data.SelectCommand = "select row_number() over(order by j.mJobName asc)as sino,j.JobId,j.mJobName,j.BudHours,CONVERT(numeric(18,2),j.BudAmt) as 'BudAmt',jg.JobGroupName as jobgroup,dbo.SumTotal(j.JobId) as Total,j.Jobstatus,CONVERT(VARCHAR(10), j.CreationDate, 103) AS CreationDate,(case when j.EndDate <> '' then CONVERT(VARCHAR(10),  j.EndDate, 103) else null end) as 'EndDate',DATEDIFF(DD,j.CreationDate,j.EndDate) as 'Diff' ,CM.ClientName from vw_Job_New as j left join dbo.JobGroup_Master as jg on j.JobGId=jg.JobGId LEFT OUTER JOIN Client_Master CM ON j.cltid=CM.CLTId where j.CompId='" + ViewState["compid"].ToString() + "' and JobStatus='OnGoing'  order by j.mJobName asc";
            Griddealers.DataBind();
        }
        catch (Exception ex)
        {

        }
    }



    protected void Griddealers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        try
        {
            Griddealers.PageIndex = e.NewPageIndex;
            bindgrid1();
            UpdatePanel1.Update();
        }
        catch (Exception ex)
        {

        }
    }
    protected void Griddealers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "edit")
            {
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int compid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
                Session["jobid"] = compid;
                Response.Redirect("EditJobAdd.aspx");
            }
            else if (e.CommandName == "job")
            {
                LinkButton btn = (LinkButton)e.CommandSource; 
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int compid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
                if (Request.QueryString["masters"] != null)
                {
                    Session["jobid"] = compid;
                    Response.Redirect("EditJobAdd.aspx?p=9");
                }
                else
                {
                    Response.Redirect("JobBreakup.aspx?job=" + compid + "&jobname=" + btn.Text);
                }
            }
            else if (e.CommandName == "del")
            {
                DBAccess.PrintDelete(Session["IP"].ToString(), "Job Master", Session["fulname"].ToString(), Session["usertype"].ToString(), hdnDT.Value);
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int id = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
                string StrSQL2 = "select TSId from TimeSheet_Table where JobId='" + id + "'";
                DataTable dttime = db.GetDataTable(StrSQL2);
                if (dttime.Rows.Count == 0)
                {
                    string query0 = "delete from Budget_Master where JobId=='" + id + "'; delete from tbl_Staff_budgeting where Job_Id='" + id + "';  delete from Job_Staff_Table where JobId='" + id + "';" +
                                    " delete from Job_Master where JobId='" + id + "'";
                    db.ExecuteCommand(query0);
                    userlist_data.DeleteCommand = query0;
                    Label lblstat = (Label)this.Page.Master.FindControl("Label10");
                    UpdatePanel updatepan = (UpdatePanel)this.Page.Master.FindControl("MasterUpdate");
                    string query1 = "select count(JobStatus)as ongo from Job_Master where JobStatus='OnGoing' and CompId='" + ViewState["compid"].ToString() + "'";
                    DataTable dt2 = db.GetDataTable(query1);
                    if (dt2.Rows.Count != 0 && dt2 != null)
                    {
                        MessageControl1.SetMessage("Job Deleted Sucessfully", MessageDisplay.DisplayStyles.Success);
                    }
                    else
                    {
                        MessageControl1.SetMessage("Some Issue while Deleting.Please contact your administrator", MessageDisplay.DisplayStyles.Error);
                    }

                    bindgrid1();
                    UpdatePanel1.Update();
                    updatepan.UpdateMode = UpdatePanelUpdateMode.Conditional;
                    updatepan.Update();
                }
                else
                {
                    MessageControl1.SetMessage("Timesheet Entry exists.So this job cannot be deleted", MessageDisplay.DisplayStyles.Error);

                }
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void btnsrchjob_Click(object sender, EventArgs e)
    {
        string txtval = "";
        string txtcl = "";
        if (ddlSearchby.SelectedValue == "Job")
        { txtval = txtSearchby.Text; }
        else if (ddlSearchby.SelectedValue == "Client")
        { txtcl = txtSearchby.Text; }
        string sql = "";

        if (txtval != "")
        {
            if (txtcl != "")
            {
                sql = "j.CompId='" + ViewState["compid"].ToString() + "' and  j.mJobName like '%" + txtval + "%' and CM.ClientName like '%" + txtcl + "%' order by j.mJobName asc";
            }

            else
            {
                sql = "j.CompId='" + ViewState["compid"].ToString() + "' and  j.mJobName like '%" + txtval + "%' order by j.mJobName asc";
            }
        }
        else
        {
            sql = "j.CompId='" + ViewState["compid"].ToString() + "' and CM.ClientName like '%" + txtcl + "%' order by j.mJobName asc";
        }


        userlist_data.SelectCommand = "select row_number() over(order by j.mJobName asc)as sino,j.JobId,j.mJobName,j.BudHours,CONVERT(numeric(18,2),j.BudAmt) as 'BudAmt',jg.JobGroupName as jobgroup,dbo.SumTotal(j.JobId) as Total,j.Jobstatus,CONVERT(VARCHAR(10), j.CreationDate, 103) AS CreationDate,(case when j.EndDate <> '' then CONVERT(VARCHAR(10),  j.EndDate, 103) else null end) as 'EndDate',DATEDIFF(DD,j.CreationDate,j.EndDate) as 'Diff' ,CM.ClientName from vw_Job_New as j left join dbo.JobGroup_Master as jg on j.JobGId=jg.JobGId LEFT OUTER JOIN Client_Master CM ON j.cltid=CM.CLTId where " + sql;
        Griddealers.DataBind();

    }
    protected void lnknewclient_Click(object sender, EventArgs e)
    {
        Response.Redirect("JobAdd.aspx?p=9");
    }
    protected void lnkreset_Click(object sender, EventArgs e)
    {
        Response.Redirect("cmp_ResetJob.aspx");
    }
    protected void Griddealers_RowDataBound(object sender, GridViewRowEventArgs e)
    {

    }
    protected void Btnjob_Click(object sender, EventArgs e)
    {
        Response.Redirect("CompletedJobs.aspx?p=9");

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

    protected void BtnExport_Click(object sender, EventArgs e)
    {
        LabelAccess objlabelAccess = new LabelAccess();
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(Session["companyid"].ToString()));
        try
        {
            string sql = "select  row_number() over(order by jn.mJobName asc)as Sr,  jn.MJobName, jg.JobGroupName, c.ClientName, cg.ClientGroupName,"
                      + "j.CreationDate, j.BudHours, j.BudAMt, j.ActualHours, j.ActualAmt, j.JobStatus, j.ActualJobEndate FROM dbo.Client_Master as c INNER JOIN "
                      + "dbo.Job_Master as j ON c.CLTId = j.CLTId INNER JOIN dbo.JobName_Master as jn ON j.mJobID = jn.MJobId LEFT OUTER JOIN dbo.JobGroup_Master as jg ON j.JobGId = jg.JobGId LEFT OUTER JOIN "
                      + "dbo.ClientGroup_Master as cg ON c.CTGId = cg.CTGId where j.CompId='" + ViewState["compid"].ToString() + "'   order by jn.mJobName asc";
            DataTable dt = db.GetDataTable(sql);
       
            
            foreach (DataColumn col in dt.Columns)
            {
                col.ColumnName = changelabel(col.ColumnName);
            }
            if (dt.Rows.Count > 0)
            {
                DumpExcel(dt);
            }
            else
            {
                MessageBox.Show("No Records To Export");
            }


            //if (Griddealers.Rows.Count > 0)
            //{
            //    Response.Clear();
            //    Response.Buffer = true;
            //    Response.AddHeader("content-disposition", "attachment;filename=Job_Master.xls");
            //    Response.Charset = "";
            //    Response.ContentType = "application/vnd.ms-excel";
            //    using (StringWriter sw = new StringWriter())
            //    {
            //        HtmlTextWriter hw = new HtmlTextWriter(sw);
            //        Griddealers.RenderControl(hw);

            //        //style to format numbers to string
            //        Response.Output.Write(sw.ToString());
            //        Response.End();
            //    }
            //}
        }
        catch (Exception ex)
        {
            //string ss = ex.StackTrace.ToString();
            //string s = ex.InnerException.ToString();
        }
    }


    private void DumpExcel(DataTable tbl)

    {


        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Job_Master");

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            ws.Cells["A1"].LoadFromDataTable(tbl, true);

            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:AI1"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            //Example how to Format Column 1 as numeric 
            //using (ExcelRange col = ws.Cells[2, 1, 2 + tbl.Rows.Count, 1])
            //{
            //    col.Style.Numberformat.Format = "#,##0.00";
            //    col.Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            //}

            ////Write it back to the client
            //Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            //Response.AddHeader("content-disposition", "attachment;  filename=SalesTracker.xlsx");
            //Response.BinaryWrite(pck.GetAsByteArray());


            using (var memoryStream = new MemoryStream())
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=Job_Master.xls");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }
}
