using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JTMSProject;
using System.Data;
using System.Web.Security;

public partial class Admin_Changecompanypassword : System.Web.UI.Page
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
            if (Session["dealer"] != null)
            {
                MembershipUser user = Membership.GetUser(Session["dealer"].ToString());
                bool status = user.ChangePassword(txtoldpwd.Text, txtconfirm.Text);

                if (status.Equals(false))
                {
                    MessageControl1.SetMessage("Invalid Old Password", MessageDisplay.DisplayStyles.Error);
                }
                else if (status.Equals(true))
                {
                    if (txtnewpwd.Text == txtconfirm.Text)
                    {
                        string qry = "update Company_Master set password='" + txtconfirm.Text + "' where username='" + Session["dealer"].ToString() + "'";
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
