using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;

public partial class Admin_ad_jobdetails : System.Web.UI.Page
{
    DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["job_id"] != null)
            {
                bind();
            }
        }
    }
    public SqlDataSource userlist_data
    {
        get { return SqlStaffSrc; }
    }
    public void bind()
    {
        try
        {
            int id = int.Parse(Request.QueryString["job_id"].ToString());
            //userlist_data.SelectCommand = "select row_number() over(order by j.CreationDate desc)as sino,j.JobId,j.JobName,j.StaffCode,jg.JobGroupName as jobgroup,s.StaffName as staff,j.Jobstatus from Job_Master as j inner join dbo.JobGroup_Master as jg on j.JobGId=jg.JobGId inner join dbo.Staff_Master as s on j.StaffCode=s.StaffCode where j.StaffCode='" + id + "'";
            //userlist_data.SelectCommand = "select distinct j.JobId,j.JobName,j.JobStatus,jg.JobGroupName,s.StaffCode from Job_Staff_Table as s inner join Job_Master as j on s.jobId=s.JobId inner join JobGroup_Master as jg on jg.JobGId=j.JobGId where s.StaffCode='" + id + "'";
            userlist_data.SelectCommand = "select row_number() over(order by j.JobName asc)as sino,j.JobId,j.JobName,jg.JobGroupName as jobgroup,j.Jobstatus,d.StaffCode,CONVERT(VARCHAR(10), j.CreationDate, 103) AS CreationDate from Job_Staff_Table as d left join Job_Master as j on d.JobId=j.JobId left join dbo.JobGroup_Master as jg on j.JobGId=jg.JobGId left join dbo.Staff_Master as s on d.StaffCode=s.StaffCode where s.StaffCode='" + id + "'";

            Griddealers.DataBind();
            JobView.ActiveViewIndex = 0;
        }
        catch (Exception ex)
        {

        }
    }
    protected void Griddealers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        bind();
    }
}
