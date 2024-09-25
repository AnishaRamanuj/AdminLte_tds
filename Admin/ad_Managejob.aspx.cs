using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;

public partial class Admin_ad_Managejob : System.Web.UI.Page
{
    DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session["admin"] != null)
            {
                bindcomp();
                bindgrid();
            }

        }
    }
    public SqlDataSource userlist_data1
    {
        get { return SqlDataSource9; }
    }
    public SqlDataSource userlist_data
    {
        get { return SqlDataSource1; }
    }
    public void bindgrid()
    {
        //userlist_data.SelectCommand = "select row_number() over(order by j.CreationDate desc)as sino,j.JobId,j.JobName,jg.JobGroupName as jobgroup,s.StaffName as staff,j.Jobstatus from Job_Master as j inner join dbo.JobGroup_Master as jg on j.JobGId=jg.JobGId inner join Job_Staff_Table as js on js.JobId=j.JobId inner join dbo.Staff_Master as s on js.StaffCode=s.StaffCode where j.CLTId='" + Session["clientid"].ToString() + "'";
        try
        {
            userlist_data.SelectCommand = "select j.JobId,j.JobName,cl.ClientName,c.CompanyName,CONVERT(VARCHAR(10), j.CreationDate, 103) AS CreationDate from Job_Master as j left join dbo.Client_Master as cl on cl.CLTId=j.CLTId left join dbo.Company_Master as c on c.CompId=j.CompId where j.CompId='" + drpcompany.SelectedValue + "' order by j.JobName";
            Griddealers.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    public void bindcomp()
    {
        //userlist_data.SelectCommand = "select row_number() over(order by j.CreationDate desc)as sino,j.JobId,j.JobName,jg.JobGroupName as jobgroup,s.StaffName as staff,j.Jobstatus from Job_Master as j inner join dbo.JobGroup_Master as jg on j.JobGId=jg.JobGId inner join Job_Staff_Table as js on js.JobId=j.JobId inner join dbo.Staff_Master as s on js.StaffCode=s.StaffCode where j.CLTId='" + Session["clientid"].ToString() + "'";
        try
        {
            userlist_data1.SelectCommand = "SELECT * from Company_Master order by CompanyName";
            drpcompany.DataBind();
        }
        catch (Exception ex)
        {

        }
    }

    protected void btndelete_Click(object sender, EventArgs e)
    {
        try
        {
            ImageButton btndelete = sender as ImageButton;
            int id = Convert.ToInt32(btndelete.CommandArgument);
            //JobMaster job = new JobMaster(id);
            //job.Delete();
            string str = "delete from Job_Staff_Table where JobId ='" + id + "'";
            db.ExecuteCommand(str);
            string str1=" delete from Job_Master where JobId='"+ id +"'";
            db.ExecuteCommand(str1);
            bindgrid();
        }
        catch (Exception ex)
        {
            string es = ex.ToString();
        }
    }
    protected void Griddealers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Griddealers.PageIndex = e.NewPageIndex;
        bindgrid();
    }
    protected void Griddealers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "edit")
        {
            ImageButton btn = (ImageButton)e.CommandSource;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int compid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
            Session["jobid"] = compid;
            Response.Redirect("ad_editjob.aspx");
        }
        if (e.CommandName == "job")
        {
            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int compid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
            Response.Redirect("JobBreakup.aspx?job=" + compid + "&jobname=" + btn.Text);
        }
    }


    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindgrid();
    }
    protected void btnsrchjob_Click(object sender, EventArgs e)
    {
        string txtval = txtsrchjob.Text;
        userlist_data.SelectCommand = "select j.JobId,j.JobName,cl.ClientName,c.CompanyName,CONVERT(VARCHAR(10), j.CreationDate, 103) AS CreationDate from Job_Master as j left join dbo.Client_Master as cl on cl.CLTId=j.CLTId left join dbo.Company_Master as c on c.CompId=j.CompId where j.JobName like '%" + txtval + "%' and j.CompId='" + drpcompany.SelectedValue + "' order by j.JobName";
        Griddealers.DataBind();

    }
}
