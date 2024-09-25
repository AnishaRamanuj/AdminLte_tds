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
using JTMSProject;
using System.Collections.Generic;


public partial class controls_Manage_Job : System.Web.UI.UserControl
{

    private readonly DBAccess db = new DBAccess();
    JobMaster jb = new JobMaster();
    LabelAccess objlabelAccess = new LabelAccess();
    List<tbl_LabelAccess> LtblAccess;
    const int pageSize = 25;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["companyid"] == null)
        {
            Response.Redirect("~/Default.aspx");
        }
        else
        {
            if (!IsPostBack)
            {
                if (Session["companyid"] != null)
                {
                    hdnCompanyid.Value = Session["companyid"].ToString();
                    ViewState["compid"] = Session["companyid"].ToString();
                    //GetCountRecords();
                    hdnPageINdex.Value = "1";
                    bindgrid1();

                }
                else if (Session["staffid"] != null)
                {
                    ViewState["compid"] = Session["cltcomp"].ToString();
                }
            }
        }
       

    }

    //public void GetCountRecords()
    //{
    //    string sql = "select count(j.JobId)as j from vw_Job_New as j left join dbo.JobGroup_Master as jg on j.JobGId=jg.JobGId LEFT OUTER JOIN Client_Master CM ON j.cltid=CM.CLTId where j.CompId='" + ViewState["compid"].ToString() + "' and JobStatus='OnGoing' ";
    //    DataTable dt2 = db.GetDataTable(sql);
    //    if (dt2.Rows.Count != 0 && dt2 != null)
    //    {
    //        int i = int.Parse(dt2.Rows[0]["j"].ToString());
    //        i = i / 25;
    //        if (i > 20)
    //        {
    //            i = 20;
    //            Griddealers.PagerSettings.PageButtonCount = i;
    //        }
    //    }
    //}
    //public SqlDataSource userlist_data
    //{
    //    get { return SqlDataSource1; }
    //}

    public void bindgrid1()
    {
        try
        {
            lblShowsGridRecords.Text = "Showing result 0";
            ////////////////edited by ganesh
            //////////on natu pathak error 
            BtnPrevious.Visible = false; BtnNext.Visible = false;
            vw_JobnClientnStaff tbl_jobs = new vw_JobnClientnStaff();
            if (ddlSearchby.SelectedValue == "Job")
            { tbl_jobs.MJobName = txtSearchby.Text; }
            else
            {
                tbl_jobs.MJobName = "";
            }
            if (ddlSearchby.SelectedValue == "Client")
            { tbl_jobs.ClientName = txtSearchby.Text; }
            else
            {
                tbl_jobs.ClientName = "";
            }
            tbl_jobs.CompId = Convert.ToInt32(hdnCompanyid.Value.ToString());
            tbl_jobs.jStatus = "OnGoing";
            tbl_jobs.pageIndex = Convert.ToInt32(hdnPageINdex.Value);
            tbl_jobs.pageNewSize = pageSize;
            DataSet ds = jb.Get_JobAllocation(tbl_jobs);

            int totalcount = 0;
            if (ds.Tables[1].Rows.Count > 0)
            {
                totalcount = Convert.ToInt32(ds.Tables[1].Rows[0]["jobid"].ToString());
            }

            if (totalcount > 0)
            {
                var totalIndex = (double)(totalcount / (float)pageSize);

                if (Convert.ToInt32(hdnPageINdex.Value) < totalIndex)
                { BtnNext.Visible = true; }

                if (Convert.ToInt32(hdnPageINdex.Value) != 1)
                { BtnPrevious.Visible = true; }

                lblShowsGridRecords.Text = "Showing result " + ds.Tables[0].Rows[0]["sino"].ToString() + " to " + ds.Tables[0].Rows[ds.Tables[0].Rows.Count - 1]["sino"].ToString() + " of " + totalcount;
            }

            Griddealers.DataSource = ds;
            Griddealers.DataBind();
            if (txtSearchby.Text == "")
            {
                hdnCntJob.Value = totalcount.ToString();
                Label1.Text = "Manage Job (" + hdnCntJob.Value + "/" + hdnCntJob.Value + ")";
            }
            else
            {
                Label1.Text = "Manage Job (" + totalcount + "/" + hdnCntJob.Value + ")";
            }
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
            hdnPageINdex.Value = "1";
            bindgrid1();
            // UpdatePanel1.Update();
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
                //if (Request.QueryString["masters"] != null)
                //{
                Session["jobid"] = compid;
                Response.Redirect("EditJobAdd.aspx");
                //}
                //else
                //{
                //    Response.Redirect("JobBreakup.aspx?job=" + compid + "&jobname=" + btn.Text);
                //}
            }
            else if (e.CommandName == "del")
            {
                DBAccess.PrintDelete(Session["IP"].ToString(), "Manage Job", Session["fulname"].ToString(), Session["usertype"].ToString(), hdnDT.Value);
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int id = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
                string StrSQL2 = "select TSId from TimeSheet_Table where JobId='" + id + "'";
                DataTable dttime = db.GetDataTable(StrSQL2);
                if (dttime.Rows.Count == 0)
                {
                    string query0 = "delete from Budget_Master where JobId='" + id + "'; delete from tbl_Staff_budgeting where Job_Id='" + id + "';  delete from Job_Staff_Table where JobId='" + id + "';" +
                                    " delete from Job_Master where JobId='" + id + "'";
                    db.ExecuteCommand(query0);
                    //userlist_data.DeleteCommand = query0;
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
                    hdnPageINdex.Value = "1";
                    bindgrid1();
                    //UpdatePanel1.Update();
                    //updatepan.UpdateMode = UpdatePanelUpdateMode.Conditional;
                    //updatepan.Update();
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
                sql = "  j.CompId='" + ViewState["compid"].ToString() + "' and  j.mJobName like '%" + txtval + "%' and CM.ClientName like '%" + txtcl + "%' ";
            }

            else
            {
                sql = "  j.CompId='" + ViewState["compid"].ToString() + "' and  j.mJobName like '%" + txtval + "%' ";
            }
        }
        else
        {
            sql = "  j.CompId='" + ViewState["compid"].ToString() + "' and CM.ClientName like '%" + txtcl + "%' ";
        }

        Session["Srch"] = sql;
        hdnPageINdex.Value = "1";
        bindgrid1();
        //sql =  "select row_number() over(order by j.mJobName asc)as sino,j.JobId,j.mJobName,j.BudHours,CONVERT(numeric(18,2),j.BudAmt) as 'BudAmt',jg.JobGroupName as jobgroup,dbo.SumTotal(j.JobId) as Total,j.Jobstatus,CONVERT(VARCHAR(10), j.CreationDate, 103) AS CreationDate,(case when j.EndDate <> '' then CONVERT(VARCHAR(10),  j.EndDate, 103) else null end) as 'EndDate',DATEDIFF(DD,j.CreationDate,j.EndDate) as 'Diff' ,CM.ClientName from vw_Job_New as j left join dbo.JobGroup_Master as jg on j.JobGId=jg.JobGId LEFT OUTER JOIN Client_Master CM ON j.cltid=CM.CLTId where " + sql;
        //DataTable dt2 = db.GetDataTable(sql);
        //if (dt2.Rows.Count != 0 && dt2 != null)
        //{
        //    Griddealers.DataSource = dt2;
        //    Griddealers.DataBind();
        //}


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
    protected void BtnPrevious_Click(object sender, EventArgs e)
    {
        hdnPageINdex.Value = (Convert.ToInt32(hdnPageINdex.Value) - 1).ToString();
        if (Convert.ToInt32(hdnPageINdex.Value) <= 0)
        { hdnPageINdex.Value = "1"; }
        bindgrid1();
    }
    protected void BtnNext_Click(object sender, EventArgs e)
    {
        hdnPageINdex.Value = (Convert.ToInt32(hdnPageINdex.Value) + 1).ToString();
        bindgrid1();
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
            //string sql = "select  row_number() over(order by jn.mJobName asc)as sino, jn.MJobName, jg.JobGroupName, c.ClientName, cg.ClientGroupName,"
            //          + "j.CreationDate, j.BudHours 'Budgeted Hours', j.BudAMt 'Budgeted Amount', j.ActualHours 'Actual Hours', j.ActualAmt 'Actual Amount', j.JobStatus, j.ActualJobEndate FROM dbo.Client_Master as c INNER JOIN "
            //          + "dbo.Job_Master as j ON c.CLTId = j.CLTId INNER JOIN dbo.JobName_Master as jn ON j.mJobID = jn.MJobId LEFT OUTER JOIN dbo.JobGroup_Master as jg ON j.JobGId = jg.JobGId LEFT OUTER JOIN "
            //          + "dbo.ClientGroup_Master as cg ON c.CTGId = cg.CTGId where j.CompId='" + ViewState["compid"].ToString() + "' and JobStatus='OnGoing'  order by jn.mJobName asc";

            string sql = "SELECT row_number() OVER (";
            sql += "ORDER BY j.mJobName ASC";
            sql += ") AS 'Sr No'";
            sql += ",j.mJobName 'JobName'";
            sql += ",CM.ClientName 'Client'";
            sql += ",j.BudHours 'Budgeted Time'";
            sql += ",CONVERT(NUMERIC(18, 2), j.BudAmt) AS 'Budgeted Amount'";
            sql += ",Replace(dbo.SumTotal(j.JobId),'.',':') AS 'Time Spend'";
            sql += ",sum(Convert(float,isnull(tt.totaltime,0))*isnull(tt.hourlycharges,0)) as 'Amount Spend'";
            sql += ",CONVERT(VARCHAR(10), j.CreationDate, 103) AS 'Start Date'";
            sql += ",CONVERT(VARCHAR(10), j.ActualJobEndate, 103) AS 'End Date'";
            sql += ",JobStatus";
            sql += ",DATEDIFF(DD, getdate(), j.ActualJobEndate) AS 'Days Left'";
            sql += "FROM vw_Job_New AS j";
            sql += " LEFT JOIN dbo.JobGroup_Master AS jg ON j.JobGId = jg.JobGId";
            sql += " LEFT JOIN Client_Master CM ON j.cltid = CM.CLTId";
            sql += " LEFT JOIN Timesheet_Table tt ON tt.Jobid = j.jobid";
            sql += " WHERE";
            if (txtSearchby.Text == "")
            {
                sql += " j.CompId = '" + ViewState["compid"].ToString() + "'";
            }
            else
            {
                string jobclientfilter = "";
                if (ddlSearchby.SelectedValue == "Job")
                { jobclientfilter = "j.mJobName"; }
                else { jobclientfilter = "CM.ClientName"; }

                sql += " j.CompId = '" + ViewState["compid"].ToString() + "' and " + jobclientfilter + " like '%" + txtSearchby.Text.Trim() + "%'";
            }
            sql += " GROUP BY j.JobId";
            sql += ",j.mJobName";
            sql += ",j.BudHours";
            sql += ",j.BudAmt";
            sql += ",CM.ClientName";
            sql += ",jg.JobGroupName";
            sql += ",j.Jobstatus";
            sql += ",j.CreationDate";
            sql += ",j.ActualJobEndate";

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
            ws.Cells.AutoFitColumns();
            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:AI1"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            string ds = "F2:F" + (tbl.Rows.Count + 100).ToString();
            using (ExcelRange rn = ws.Cells[ds])
            {
                rn.Style.Numberformat.Format = "h:mm";
                rn.Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            }

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


    protected void btnpage_Click(object sender, EventArgs e)
    {
        //Session["staff"] = hdnStfcode.Value;
        Session["jobid"] = hdnJobid.Value;
        Response.Redirect("EditJobAdd.aspx");
    }


    protected void btnApprover_Click(object sender, EventArgs e)
    {
        try
        {

            //string str12 = "SELECT * FROM Staff_master where CompId='" + ViewState["compid"].ToString() + "' and Staff_Master.DateOfJoining <= getdate() order by StaffName";
            string str12 = "SELECT * FROM Staff_master  INNER JOIN dbo.Department_Master ON dbo.Staff_Master.DepId = dbo.Department_Master.DepId where Staff_master.CompId='" + hdnCompanyid.Value.ToString() + "' and Staff_Master.DateOfJoining <= getdate() and DateOfLeaving is null  order by StaffName";
            DataTable dt = db.GetDataTable(str12);
            if (dt.Rows.Count == 0)
            {

            }
            else
            {
                //DlStaff.DataSource = dt;
                //DlStaff.DataBind();
                drpdwnapp.DataSource = dt;
                drpdwnapp.DataBind();
                drpdwnapp.Items.Insert(0, new ListItem("-------Select--------", "0"));
            }

            string str3 = "select  SUBSTRING(SuperAppId, 1, LEN(SuperAppId)-1 ) as SuperAppId, ApproverId,JobId from vw_JobApprover where JobId='" + int.Parse(hdnJobid.Value.ToString()) + "'";
            DataTable dt3 = db.GetDataTable(str3);
            if (dt3.Rows.Count != 0)
            {
                string SAppId = dt3.Rows[0]["SuperAppId"].ToString();
                drpdwnapp.SelectedValue = SAppId;

            }
        }
        catch (Exception ex)
        {

        }
    }
}
