using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;

public partial class Admin_ad_ManageStaff : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            //if (Session["clientid"] != null)
            //{
            //    bindgrid();
            //}
            if (Session["admin"] != null)
            {
                bindcomp();
                bindgrid();
            }
            //else if (Session["clientid"] != null)
            //{
            //    bindgrid();
            //}
        }
    }
    public SqlDataSource userlist_data1
    {
        get { return SqlDataSource9; }
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

    public SqlDataSource userlist_data
    {
        get { return SqlDataSource1; }
    }
    public void bindgrid()
    {
        try
        {
            //userlist_data.SelectCommand = "select row_number() over(order by s.DateOfJoining desc)as sino,s.StaffCode,s.StaffName,s.Mobile,d.DepartmentName,dsg.DesignationName,br.BranchName from Staff_Master as s inner join  dbo.Department_Master as d on d.DepId=s.DepId inner join dbo.Designation_Master  as dsg on dsg.DsgId=s.DsgId inner join dbo.Branch_Master as br on br.BrId=s.BrId where s.CLTId='" + Session["clientid"].ToString() + "'";
            //userlist_data.SelectCommand = "select c.CompanyName,cl.ClientName,s.StaffCode,s.StaffName,s.Mobile,d.DepartmentName,dsg.DesignationName,br.BranchName from Staff_Master as s inner join  dbo.Department_Master as d on d.DepId=s.DepId inner join dbo.Designation_Master  as dsg on dsg.DsgId=s.DsgId inner join dbo.Branch_Master as br on br.BrId=s.BrId inner join Client_Master as cl on s.CLTId=cl.CLTId inner join Company_Master as c on c.CompId=s.CompId";
            userlist_data.SelectCommand = "select c.CompanyName,cl.ClientName,s.StaffCode,s.StaffName,s.Mobile,d.DepartmentName,dsg.DesignationName,br.BranchName from Staff_Master as s left join  dbo.Department_Master as d on d.DepId=s.DepId left join dbo.Designation_Master  as dsg on dsg.DsgId=s.DsgId left join dbo.Branch_Master as br on br.BrId=s.BrId left join Client_Master as cl on s.CLTId=cl.CLTId left join Company_Master as c on c.CompId=s.CompId where s.CompId='" + drpcompany.SelectedValue + "' and s.IsDeleted<>'True' order by s.StaffName";
            Griddealers.DataBind();
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
            //StaffMaster staff = new StaffMaster(id);
            //staff.Delete();
            string str = "delete from Job_Staff_Table where StaffCode='" + id + "';"+
            " delete from Job_Master where StaffCode='"+id+"';"+
            " delete from Staff_Master where StaffCode='" + id + "'";
            db.ExecuteCommand(str);
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
            Session["stid"] = compid;
            Response.Redirect("ad_editstaff.aspx");
        }
        else if (e.CommandName == "job")
        {
            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int compid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
            Response.Redirect("ad_jobdetails.aspx?job_id=" + compid);
        }
    }
    protected void Griddealers_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindgrid();
    }
    protected void btnsrchstf_Click(object sender, EventArgs e)
    {
        string txtval = txtsrchdtf.Text;
        userlist_data.SelectCommand = "select c.CompanyName,cl.ClientName,s.StaffCode,s.StaffName,s.Mobile,d.DepartmentName,dsg.DesignationName,br.BranchName from Staff_Master as s left join  dbo.Department_Master as d on d.DepId=s.DepId left join dbo.Designation_Master  as dsg on dsg.DsgId=s.DsgId left join dbo.Branch_Master as br on br.BrId=s.BrId left join Client_Master as cl on s.CLTId=cl.CLTId left join Company_Master as c on c.CompId=s.CompId where s.CompId='" + drpcompany.SelectedValue + "' and s.IsDeleted<>'True' and  s.StaffName like '%" + txtval + "%' order by s.StaffName";
        //userlist_data.SelectCommand = "select c.CompanyName,cl.ClientName,s.StaffCode,s.StaffName,s.Mobile,d.DepartmentName,dsg.DesignationName,br.BranchName from Staff_Master as s left join  dbo.Department_Master as d on d.DepId=s.DepId left join dbo.Designation_Master  as dsg on dsg.DsgId=s.DsgId left join dbo.Branch_Master as br on br.BrId=s.BrId inner join Client_Master as cl on s.CLTId=cl.CLTId inner join Company_Master as c on c.CompId=s.CompId where s.StaffName like '%"+txtval+"%' order by s.StaffName";
        Griddealers.DataBind();

    }
}
