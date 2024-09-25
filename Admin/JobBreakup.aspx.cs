using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Admin_JobBreakup : System.Web.UI.Page
{
    int finalhr = 0;
    int finalmt = 0;
    int grdTotalhr = 0;
    int grdTotalmt = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["admin"] != null)
            {
                if (Request.QueryString["job"] != null)
                {
                    bindgrid();
                    if (Request.QueryString["jobname"] != null)
                    {
                        lbljob.Text = Request.QueryString["jobname"].ToString();
                    }
                }
            }
        }

    }
    public SqlDataSource userlist_data
    {
        get { return SqlDataSource1; }
    }
    public void bindgrid()
    {
        // userlist_data.SelectCommand = "select row_number() over(order by j.CreationDate desc)as sino,j.JobId,j.JobName,jg.JobGroupName as jobgroup,s.StaffName as staff,j.Jobstatus from Job_Master as j inner join dbo.JobGroup_Master as jg on j.JobGId=jg.JobGId inner join dbo.Staff_Master as s on j.StaffCode=s.StaffCode where j.CompId='" + ViewState["compid"].ToString() + "'";
        try
        {
            userlist_data.SelectCommand = "select row_number() over(order by t.Date asc)as SINo,t.FromTime,t.ToTime,s.StaffName,t.OpeAmt,t.TotalTime,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.Narration from TimeSheet_Table as t inner join Staff_Master as s on s.StaffCode=t.StaffCode where t.JobId='" + Request.QueryString["job"].ToString() + "' order by t.Date asc";
            Gridtimesheetdetails.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    protected void Gridtimesheetdetails_PageIndexChanging1(object sender, GridViewPageEventArgs e)
    {
        bindgrid();
    }
    protected void Gridtimesheetdetails_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string tt = Convert.ToString(DataBinder.Eval(e.Row.DataItem, "TotalTime"));
                string[] sp = tt.Split('.');
                int hr = Convert.ToInt32(sp[0].ToString());
                int mt = Convert.ToInt32(sp[1].ToString());
                //decimal rowTotal = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "TotalTime"));
                grdTotalhr = hr + grdTotalhr;
                grdTotalmt = mt + grdTotalmt;

            }
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                int mt = grdTotalmt % 60;
                int ethr = grdTotalmt / 60;
                finalhr = grdTotalhr + ethr;
                finalmt = mt;
                string mt1 = finalmt.ToString();
                if (mt1.Length == 1)
                {
                    mt1 = "0" + mt1;
                }
                Label lbl = (Label)e.Row.FindControl("lblTotal");
                string finalhr1 = finalhr.ToString();
                if (finalhr.ToString().Length == 1)
                {
                    finalhr1 = "0" + finalhr.ToString();
                }
                lbl.Text = finalhr1 + '.' + mt1;
                grdTotalhr = 0;
                grdTotalmt = 0;
            }
        }
        catch (Exception ex)
        {

        }
    }
}
