using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JTMSProject;
using System.Data;
using System.Web.Security;

public partial class Admin_Changepassword : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {

            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        txtoldpwd.Focus();
    }
       
    protected void btnchange_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyname"] != null)
            {
                //MembershipUser user = Membership.GetUser(Session["companyname"].ToString());
                //bool status = user.ChangePassword(txtoldpwd.Text, txtconfirm.Text);
                string str = "select UserId,password from Company_Master where CompId='" + Session["companyid"] + "' order by CompanyName";
                DataTable dt = db.GetDataTable(str);
                Guid uid = new Guid(dt.Rows[0]["UserId"].ToString());
                string pass = dt.Rows[0]["password"].ToString();
                if (pass != txtoldpwd.Text)
                {
                    MessageControl1.SetMessage("Invalid Old Password", MessageDisplay.DisplayStyles.Error);
                }
                //if (status.Equals(false))
                //{
                //    MessageControl1.SetMessage("Invalid Old Password", MessageDisplay.DisplayStyles.Error);
                //}
                else
                {
                    if (txtnewpwd.Text != "" && txtconfirm.Text != "")
                    {
                        if (txtnewpwd.Text == txtconfirm.Text)
                        {
                            string qry = "update Company_Master set password='" + txtconfirm.Text + "' where username='" + Session["companyname"].ToString() + "';" +
                                " update aspnet_Membership set Password ='" + txtconfirm.Text + "' where UserId='" + uid + "'";
                            db.ExecuteCommand(qry);
                            MessageControl1.SetMessage("Successfully updated the password", MessageDisplay.DisplayStyles.Success);
                        }
                        else
                        {
                            MessageControl1.SetMessage("Password Mismatch", MessageDisplay.DisplayStyles.Error);
                        }
                    }
                    else
                    {
                        MessageControl1.SetMessage("Please enter a new password", MessageDisplay.DisplayStyles.Error);
                    }
                }
            }
            else
            {
                MessageControl1.SetMessage("Error!!!Session Expired", MessageDisplay.DisplayStyles.Success);
            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("Error!!!Password Not Updated", MessageDisplay.DisplayStyles.Error);
        }
    }
}
