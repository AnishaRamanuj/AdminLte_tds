using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JTMSProject;
using System.Data;
using System.Web.Security;

public partial class Admin_Admin_Password : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["admin"] != null)
            {

            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
    }
    protected void btnchange_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["adminid"] != null)
            {
                //MembershipUser user = Membership.GetUser(Session["admin"].ToString());
                //bool status = user.ChangePassword(txtoldpwd.Text, txtconfirm.Text);
                string str = "select username,UserId,pwd from admin_privs where id='" + Session["adminid"] + "'";
                DataTable dt = db.GetDataTable(str);
                Guid uid = new Guid(dt.Rows[0]["UserId"].ToString());
                string pass = dt.Rows[0]["pwd"].ToString();
                //if (status.Equals(false))
                //{
                //    MessageControl1.SetMessage("Invalid Old Password", MessageDisplay.DisplayStyles.Error);
                //}
                if (pass != txtoldpwd.Text)
                {
                    MessageControl1.SetMessage("Invalid Old Password", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    if (txtnewpwd.Text != "" && txtconfirm.Text != "")
                    {
                        if (txtnewpwd.Text == txtconfirm.Text)
                        {
                            //string qry = "update admin_privs set pwd='" + txtconfirm.Text + "' where username='" + Session["admin"].ToString() + "'";
                            //db.ExecuteCommand(qry);
                            string qry = "update admin_privs set pwd='" + txtconfirm.Text + "' where id='" + Session["adminid"].ToString() + "';" +
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
            else if (Session["admin1"] != null)
            {
                MembershipUser user = Membership.GetUser(Session["admin1"].ToString());
                bool status = user.ChangePassword(txtoldpwd.Text, txtconfirm.Text);

                if (status.Equals(false))
                {
                    MessageControl1.SetMessage("Invalid Old Password", MessageDisplay.DisplayStyles.Error);
                }
                else if (status.Equals(true))
                {
                    if (txtnewpwd.Text == txtconfirm.Text)
                    {
                        string qry = "update admin_privs set pwd='" + txtconfirm.Text + "' where username='" + Session["admin1"].ToString() + "'";
                        db.ExecuteCommand(qry);
                        MessageControl1.SetMessage("Successfully updated the password", MessageDisplay.DisplayStyles.Success);
                    }
                    else
                    {
                        MessageControl1.SetMessage("Password Mismatch", MessageDisplay.DisplayStyles.Error);
                    }
                }
            }
            else
            {
                MessageControl1.SetMessage("Error!!!Session Expired", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("Error!!!Password Not Updated", MessageDisplay.DisplayStyles.Error);
        }
    }
}
