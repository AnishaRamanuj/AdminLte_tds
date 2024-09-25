using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using JTMSProject;
using System.Web.UI.WebControls;

public partial class controls_userlisting_control : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            bindgrid();
            //bindroles();
            //bindusername();
            bindcompany();
        }
        this.Page.Form.DefaultFocus = txtsearch.UniqueID;
        //this.Page.Form.DefaultButton = Button2.UniqueID;
        txtsearch.Attributes.Add("onfocus", "SearchCheck();");
        txtsearch.Attributes.Add("onblur", "showsearch(this);");
    }
    public SqlDataSource userlist_data
    {
        get { return SqlDataSource1; }
    }
    //public SqlDataSource userroles
    //{
    //    get { return SqlDataSourcerole; }
    //}
    public SqlDataSource usernames
    {
        get { return SqlDataSourceusrname; }
    }
    public void bindgrid()
    {
        try
        {
            userlist_data.SelectCommand = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status, (FirstName + '  ' + LastName)  CName, Role, Phone,CompanyName as fullname,Company_Master.CompId as mastid ,"
            + "s.Schemes, convert(varchar(3),datediff(day,getdate(),(dateadd(day,s.DayCount,Company_Master.CreatedDate)))) dys from Company_Master inner join SecurityPermission s on Company_Master.compid=s.compid  order by CompanyName asc";
            Griddealers.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    public void bindcompany()
    {
        try
        {
            usernames.SelectCommand = "select Company_Master.CompanyName,aspnet_Users.UserName from aspnet_Users inner join  Company_Master on aspnet_Users.UserId=Company_Master.UserId order by Company_Master.CompanyName";
            drpusername.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    //public void bindroles()
    //{
    //    userroles.SelectCommand = "select RoleName from aspnet_Roles";
    //    drproles.DataBind();
    //}
    //public void bindusername()
    //{
    //    usernames.SelectCommand = "select UserName from aspnet_Users";
    //    drpusername.DataBind();
    //}
    protected void Griddealers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Griddealers.PageIndex = e.NewPageIndex;
        bindgrid();
    }
    protected void Griddealers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "view")
            {
                LinkButton btn = (LinkButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                // int compid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
                Label lblstatus = (Label)row.FindControl("Label4");
                LinkButton lblfulname = (LinkButton)row.FindControl("Label2");
                Label lblid = (Label)row.FindControl("Label1");
                LinkButton usrname = (LinkButton)row.FindControl("lnkcmpName");
                //if (lblstatus.Text == "client")
                //{
                //    //Session["clientid"] = lblid.Text;
                //    Response.Redirect("ClientDetails.aspx?id=" + lblid.Text + "&username=" + btn.Text);
                //}
                //if (lblstatus.Text == "company")
                //{
                    //Session["clientid"] = lblid.Text;
                    Session["fulname1"] = lblfulname.Text;
                    Response.Redirect("~/Admin/CompanyDetails.aspx?id=" + lblid.Text + "&username=" + usrname.Text);
                //}
                //else if (lblstatus.Text == "staff")
                //{
                //    //Session["clientid"] = lblid.Text;
                //    Response.Redirect("StaffDetails.aspx?id=" + lblid.Text + "&username=" + btn.Text);
                //}
            }
        }
        catch (Exception ex)
        {

        }
    }

    protected void btnsearch_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            string username = "";
            string status = "";
            string str = "";
            string name = "";
            if (drpstatus.SelectedIndex != 0)
            {
                if (drpstatus.SelectedValue == "Active")
                {
                    status = "True";
                }
                else if (drpstatus.SelectedValue == "Suspended")
                {
                    status = "False";
                }
            }
            if (drpusername.SelectedIndex != 0)
                username = drpusername.SelectedValue;
            else if (txtsearch.Text != "search")
                name = txtsearch.Text;
            //else if (Session["text"] != null && Session["text1"] != null)
            //{
            //    username = Session["text"].ToString();
            //    name = Session["text1"].ToString();
            //}
            //else if (Session["text"] != null)
            //{
            //    username = Session["text"].ToString();
            //}
            if (name != "" && username != "" && status != "")
            {
                str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status, (FirstName + '  ' + LastName)  CName, Role, Phone,CompanyName as fullname,Company_Master.CompId as mastid ,"
                    + "s.Schemes, convert(varchar(3),datediff(day,getdate(),(dateadd(day,s.DayCount,Company_Master.CreatedDate)))) dys from Company_Master inner join SecurityPermission s on Company_Master.compid=s.compid  where username like '%" + username + "%' or CompanyName like '%" + name + "%' or Company_Master.IsApproved='" + status + "'  order by CompanyName asc";

                //str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status,Role,CompanyName as fullname,CompId as mastid from Company_Master where username like '%" + username + "%' or CompanyName like '%" + name + "%' or Company_Master.IsApproved='" + status + "' order by UserName asc";
            }
            if (name != "" && status != "")
            {
                    str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status, (FirstName + '  ' + LastName)  CName, Role, Phone,CompanyName as fullname,Company_Master.CompId as mastid ,"
                    + "s.Schemes, convert(varchar(3),datediff(day,getdate(),(dateadd(day,s.DayCount,Company_Master.CreatedDate)))) dys from Company_Master inner join SecurityPermission s on Company_Master.compid=s.compid  where username='" + name + "' or Company_Master.IsApproved='" + status + "' order by CompanyName asc";

                //str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status,Role,CompanyName as fullname,CompId as mastid from Company_Master where username='" + name + "' or Company_Master.IsApproved='" + status + "' order by UserName asc";
            }
            if (username != "" && status != "")
            {
                    str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status, (FirstName + '  ' + LastName)  CName, Role, Phone,CompanyName as fullname,Company_Master.CompId as mastid ,"
                    + "s.Schemes, convert(varchar(3),datediff(day,getdate(),(dateadd(day,s.DayCount,Company_Master.CreatedDate)))) dys from Company_Master inner join SecurityPermission s on Company_Master.compid=s.compid where username='" + username + "' or Company_Master.IsApproved='" + status + "' order by CompanyName asc";
                //str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status,Role,CompanyName as fullname,CompId as mastid from Company_Master where username='" + username + "' or Company_Master.IsApproved='" + status + "' order by UserName asc";
            }
            else if (name != "" && username != "")
            {
                //str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status,Role,CompanyName as fullname,CompId as mastid from Company_Master where username like '%" + username + "%' or CompanyName like '%" + name + "%' order by UserName asc";
                    str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status, (FirstName + '  ' + LastName)  CName, Role, Phone,CompanyName as fullname,Company_Master.CompId as mastid ,"
                    + "s.Schemes, convert(varchar(3),datediff(day,getdate(),(dateadd(day,s.DayCount,Company_Master.CreatedDate)))) dys from Company_Master inner join SecurityPermission s on Company_Master.compid=s.compid where username like '%" + username + "%' or CompanyName like '%" + name + "%' order by CompanyName asc";
            }
            else if (username != "")
            {
                //str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status,Role,CompanyName as fullname,CompId as mastid from Company_Master where username like '%" + username + "%' order by UserName asc";
                    str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status, (FirstName + '  ' + LastName)  CName, Role, Phone,CompanyName as fullname,Company_Master.CompId as mastid ,"
                    + "s.Schemes, convert(varchar(3),datediff(day,getdate(),(dateadd(day,s.DayCount,Company_Master.CreatedDate)))) dys from Company_Master inner join SecurityPermission s on Company_Master.compid=s.compid where username like '%" + username + "%' order by CompanyName asc";
            }
            else if (name != "")
            {
                //str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status,Role,CompanyName as fullname,CompId as mastid from Company_Master where CompanyName like '%" + name + "%' order by username";
                    str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status, (FirstName + '  ' + LastName)  CName, Role, Phone,CompanyName as fullname,Company_Master.CompId as mastid ,"
                    + "s.Schemes, convert(varchar(3),datediff(day,getdate(),(dateadd(day,s.DayCount,Company_Master.CreatedDate)))) dys from Company_Master inner join SecurityPermission s on Company_Master.compid=s.compid where CompanyName like '%" + name + "%' order by CompanyName";
            }
            else if (status != "")
            {
                //str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status,Role,CompanyName as fullname,CompId as mastid from Company_Master where Company_Master.IsApproved='" + status + "' order by UserName asc";
                     str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status, (FirstName + '  ' + LastName)  CName, Role, Phone,CompanyName as fullname,Company_Master.CompId as mastid ,"
                    + "s.Schemes, convert(varchar(3),datediff(day,getdate(),(dateadd(day,s.DayCount,Company_Master.CreatedDate)))) dys from Company_Master inner join SecurityPermission s on Company_Master.compid=s.compid where Company_Master.IsApproved='" + status + "' order by CompanyName asc";
            }
            else
            {
                //str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status,Role,CompanyName as fullname,CompId as mastid from Company_Master order by UserName asc";
                    str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status, (FirstName + '  ' + LastName)  CName, Role, Phone,CompanyName as fullname,Company_Master.CompId as mastid ,"
                    + "s.Schemes, convert(varchar(3),datediff(day,getdate(),(dateadd(day,s.DayCount,Company_Master.CreatedDate)))) dys from Company_Master inner join SecurityPermission s on Company_Master.compid=s.compid order by CompanyName asc";
            }
            userlist_data.SelectCommand = str;
            Griddealers.DataBind();
            Session["text"] = null;
        }
        catch (Exception ex)
        {

        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        Response.Redirect("CompanyRegistration.aspx");
    }
}
