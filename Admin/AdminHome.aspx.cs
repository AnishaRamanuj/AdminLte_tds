using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;

public partial class Admin_AdminHome : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session["admin"] != null)
            {
               // bindhome();
               // bindusername();
               // bindcompany();
               // Label22.Text = "Super Administrator";

            }

            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        //ClientScript.RegisterHiddenField("__EVENTTARGET", "Button2");

        //this.Page.Form.DefaultFocus = txtsearch1.UniqueID;
       //this.Page.Form.DefaultButton = Button2.UniqueID;
        //wind.add("onload()", "searchKeyPress(e);");
        //txtsearch1.Attributes.Add("onfocus", "SearchCheck1();");
        //txtsearch1.Attributes.Add("onblur", "showsearch1(this);");
    }
    //public void bindhome()
    //{
    //    try
    //    {
    //        int tot = 0;
    //        string strsql = "select count(IsApproved) as active from dbo.Company_Master where IsApproved='true' and dbo.UserRole(Company_Master.UserId)='Company'";
    //        string strsql1 = "select count(IsApproved) as sus from dbo.Company_Master where IsApproved='false' and dbo.UserRole(Company_Master.UserId)='Company'";
    //        // string strsql="select mem.UserId,dbo.fnUserStatus(mem.IsApproved) as status, from aspnet_Membership as mem inner join aspnet_Users as u on u.UserId=mem.UserId where u.UserName !='superadmin'";
    //        //string StrSQL = "select id,username,pwd from admin_privs where username='" + Session["admin"].ToString() + "'";
    //        DataTable dt1 = db.GetDataTable(strsql);
    //        lnkactive.Text = "Active (" + dt1.Rows[0]["active"].ToString() + ")";
    //        DataTable dt2 = db.GetDataTable(strsql1);
    //        lnksuspend.Text = "Suspended (" + dt2.Rows[0]["sus"].ToString() + ")";
    //        tot = int.Parse(dt1.Rows[0]["active"].ToString()) + int.Parse(dt2.Rows[0]["sus"].ToString());
    //        llbmember_count.Text = "All Customers (" + tot + ")";
    //        string strsql2 = "select Email,CONVERT(VARCHAR(10), CreateDate, 103) AS CreateDate from aspnet_Membership as mem inner join aspnet_Users as u on u.UserId=mem.UserId where u.UserName ='superadmin'";
    //        DataTable dt3 = db.GetDataTable(strsql2);
    //        Label22.Text = Session["admin"].ToString();
    //        lblusername.Text = Session["admin"].ToString();
    //        lblname.Text = "Super Administrator";
    //        lblemail.Text = dt3.Rows[0]["Email"].ToString();
    //        lblrole.Text = "superadmin";
    //        lblcreated.Text = dt3.Rows[0]["CreateDate"].ToString();
    //    }
    //    catch (Exception ex)
    //    {

    //    }
    //}
    //public SqlDataSource usernames
    //{
    //    get { return SqlDataSourceusrname; }
    //}
    //public void bindcompany()
    //{
    //    //usernames.SelectCommand = "select aspnet_Users.UserName from aspnet_Users inner join  Company_Master on aspnet_Users.UserId=Company_Master.UserId";
    //    usernames.SelectCommand = "select username,CompanyName from  Company_Master order by  CompanyName";
    //    //SqlDataSourceusrname.DataBind();
    //    drpusername.DataBind();
    //}
    //protected void Button2_Click(object sender, ImageClickEventArgs e)
    //{
    //     string username = "";
    //     string str="";
    //     string name = "";
    //     if (drpusername.SelectedIndex != 0)
    //     {
    //         username = drpusername.SelectedValue;
    //     }
    //     if (txtsearch1.Text != "search")
    //     {
    //         name = txtsearch1.Text;
    //     }
    //    if (username != "" && name != "")
    //    {
    //        str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status,Role,CompanyName as fullname,CompId as mastid from Company_Master where username like '%" + username + "%' or CompanyName like '%" + name + "%' order by UserName asc";
    //    }
    //    else if (username != "")
    //    {
    //        str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status,Role,CompanyName as fullname,CompId as mastid from Company_Master where username like '%" + username + "%' order by username";
    //    }
    //    else if (name != "")
    //    {
    //        str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status,Role,CompanyName as fullname,CompId as mastid from Company_Master where CompanyName like '%" + name + "%' order by username";
    //    } 
    //    else
    //    {
    //        str = "select password,Email,UserId,UserName,dbo.fnUserStatus(IsApproved) as status,Role,CompanyName as fullname,CompId as mastid from Company_Master order by username";

    //    }
    //    userlisting_control1.userlist_data.SelectCommand = str;
    //    userlisting_control1.DataBind();
    //}
    //protected void lnkactive_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        string str = "select convert(varchar(100),mem.password) as password,mem.Email,mem.UserId,u.UserName,dbo.fnUserStatus(mem.IsApproved) as status,dbo.UserRole(mem.UserId) as role,dbo.fnName(dbo.UserRole(mem.UserId),mem.UserId) as fullname,dbo.fnMasterId(dbo.UserRole(mem.UserId),mem.UserId) as mastid from Company_Master as mem inner join aspnet_Users as u on u.UserId=mem.UserId where dbo.fnUserStatus(mem.IsApproved)='Active' and dbo.UserRole(mem.UserId)='Company' order by UserName";
    //        userlisting_control1.userlist_data.SelectCommand = str;
    //        userlisting_control1.DataBind();
    //    }
    //    catch (Exception ex)
    //    {

    //    }
    //}
    //protected void lnksuspend_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        string str = "select convert(varchar(100),mem.password) as password,mem.Email,mem.UserId,u.UserName,dbo.fnUserStatus(mem.IsApproved) as status,dbo.UserRole(mem.UserId) as role,dbo.fnName(dbo.UserRole(mem.UserId),mem.UserId) as fullname,dbo.fnMasterId(dbo.UserRole(mem.UserId),mem.UserId) as mastid from Company_Master as mem inner join aspnet_Users as u on u.UserId=mem.UserId where dbo.fnUserStatus(mem.IsApproved)='Suspended' and dbo.UserRole(mem.UserId)='Company' order by UserName";
    //        userlisting_control1.userlist_data.SelectCommand = str;
    //        userlisting_control1.DataBind();
    //    }
    //    catch (Exception ex)
    //    {

    //    }
    //}
    //protected void llbmember_count_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        //userlisting_control1.userlist_data.SelectCommand = "select convert(varchar(100),mem.password) as password,mem.Email,mem.UserId,u.UserName,dbo.fnUserStatus(mem.IsApproved) as status,dbo.UserRole(mem.UserId) as role,dbo.fnName(dbo.UserRole(mem.UserId),mem.UserId) as fullname,dbo.fnMasterId(dbo.UserRole(mem.UserId),mem.UserId) as mastid from aspnet_Membership as mem inner join aspnet_Users as u on u.UserId=mem.UserId where dbo.UserRole(mem.UserId)='Company'";
    //        userlisting_control1.userlist_data.SelectCommand = "select convert(varchar(100),mem.password) as password,mem.Email,mem.UserId,u.UserName,dbo.fnUserStatus(mem.IsApproved) as status,dbo.UserRole(mem.UserId) as role,dbo.fnName(dbo.UserRole(mem.UserId),mem.UserId) as fullname,dbo.fnMasterId(dbo.UserRole(mem.UserId),mem.UserId) as mastid from Company_Master as mem inner join aspnet_Users as u on u.UserId=mem.UserId where dbo.UserRole(mem.UserId)='Company' order by UserName";
    //        userlisting_control1.DataBind();
    //    }
    //    catch (Exception ex)
    //    {

    //    }
    //}

    //protected void Button3_Click(object sender, EventArgs e)
    //{
    //    Response.Redirect("CompanyRegistration.aspx");
    //}
   
}
