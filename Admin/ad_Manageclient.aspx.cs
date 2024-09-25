using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;

public partial class Admin_ad_Manageclient : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            bindcomp();
            bindgrid();
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
            userlist_data.SelectCommand = "select Company_Master.CompanyName,CLTId,Client_Master.City,Country,ClientName,BusFax,BusPhone,'~/Admin/ad_staffdetails.aspx?clt_id='+convert(varchar(255),CLTId)as url from Client_Master left join Company_Master on Company_Master.CompId=Client_Master.CompId where Client_Master.CompId='" + drpcompany.SelectedValue + "' order by Client_Master.ClientName";
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
            //ClientMaster client = new ClientMaster(id);
            //client.Delete();
            string str = "delete from Job_Staff_Table where StaffCode in(select StaffCode from Job_Master where CLTId='"+id+"');" +
           " delete from Job_Master where CLTid='" + id + "';" +
           " delete from Staff_Master where CLTId='" + id + "';" +
           " delete from Client_Master where CLTId='" + id + "'";
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
            Session["cltid"] = compid;
            Response.Redirect("ad_editclient.aspx");
           // bindgrid();
        }
    }
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindgrid();
    }
    protected void btnsrchclnt_Click(object sender, EventArgs e)
    {
        string txtval = txtsrchclnt.Text;
        userlist_data.SelectCommand = "select Company_Master.CompanyName,CLTId,Client_Master.City,Country,ClientName,BusFax,BusPhone,'~/Admin/ad_staffdetails.aspx?clt_id='+convert(varchar(255),CLTId)as url from Client_Master left join Company_Master on Company_Master.CompId=Client_Master.CompId where Client_Master.ClientName like '%" + txtval + "%' and Company_Master.CompId='" + drpcompany.SelectedValue + "' order by Client_Master.ClientName";
        Griddealers.DataBind();

    }
}

