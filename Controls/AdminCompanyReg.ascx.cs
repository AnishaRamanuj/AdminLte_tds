using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;
using System.Web.Security;
using System.Text;
using System.Configuration;
using System.Net.Mail;
using System.Text.RegularExpressions;

public partial class controls_AdminCompanyReg : System.Web.UI.UserControl
{
    //Calling Related Classes from App_Code
    private readonly DBAccess db = new DBAccess();
    private readonly CompanyMaster comp = new CompanyMaster();
    string pass = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //Checking Admin Session 
            if (Session["admin"] != null)
            {
                //Assign default focus to CompanyName Textbox
                txtcompanyname.Focus();

            }
            //else return to Default(Login) Page
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        //do javascript functions
        txtcompanyname.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtaddress1.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtaddress2.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtaddress3.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtpin.Attributes.Add("onkeyup", "CountFrmTitle(this,10);");
        txtmob.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtemail.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtwebsite.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtcity.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
    }
    protected void btnregister_Click(object sender, EventArgs e)
    {
        try
        {
            //Checking Mandatory Fields 
            if (txtcompanyname.Text != "" && txtemail.Text != "" && txtUsername.Text != "" && TxtPassword.Text != "" && txtConfirm.Text != "" && Session["adminid"] != null && txtfirstname.Text != "" && txtlastname.Text != "" && txtmob.Text!="")
            {
                //Checking website validation
                if (websValid(txtwebsite.Text))
                {
                    //Checking Email validation
                    if (emailValid(txtemail.Text))
                    {
                        //Compare Password and Confirm Password TextBoxes
                        if (TxtPassword.Text == txtConfirm.Text)
                        {
                            MembershipCreateStatus status;
                            string mail = txtemail.Text + "- Company-Admin";
                            //Create Membership for the Company
                            Membership.CreateUser(txtUsername.Text, TxtPassword.Text.Trim(), mail, "question", "answer", true, out status);
                            switch (status)
                            {
                                case (MembershipCreateStatus.Success):
                                    {
                                        //Add User to Corresponding Role
                                        Roles.AddUserToRole(txtUsername.Text, "company");
                                        Guid uid = new Guid((Membership.GetUser(txtUsername.Text).ProviderUserKey).ToString());
                                        comp.UserId = uid;
                                        comp.Role = "company";
                                        comp.IsApproved = true;
                                        comp.id = int.Parse(Session["adminid"].ToString());
                                        comp.CompanyName = txtcompanyname.Text;
                                        comp.Address1 = txtaddress1.Text;
                                        comp.Address2 = txtaddress2.Text;
                                        comp.Address3 = txtaddress3.Text;
                                        comp.City = txtcity.Text;
                                        comp.Email = txtemail.Text;
                                        comp.Phone = txtmob.Text;
                                        comp.Pin = txtpin.Text;
                                        comp.FirstName = txtfirstname.Text;
                                        comp.LastName = txtlastname.Text;
                                        comp.Website = txtwebsite.Text;
                                        comp.CreatedDate = DateTime.Now;
                                        comp.username = txtUsername.Text;
                                        comp.password = TxtPassword.Text.Trim();
                                        comp.LastLogin = DateTime.Now;
                                        comp.Cash = drpcash.SelectedValue;
                                        comp.Logins = 0;
                                        comp.Freeze = "N";
                                        comp.Freezedays = 0;
                                        //Inserting Company to Database Table(Company_Master)
                                        int res = comp.Insert();
                                        if (res == 1)
                                        {
                                            //Sending Mail for Company(Email ID taken from Email TextBox)
                                            SendNotificationEmail(txtemail.Text);
                                            //Insert Security Permission for Company 
                                            SecurityPermission per = new SecurityPermission();
                                            per.CompId = comp.CompId;
                                            per.Schemes = "Free Version";
                                            per.UserCount = 40;
                                            per.StaffCount = 40;
                                            per.WebSpace = "Unlimited";
                                            per.DayCount = 30;
                                            per.Price = 0;
                                            per.Version = "Hosted";
                                            per.Insert();
                                            //Assign Master Page Permission for the Company
                                            //DataTable dtMasters = db.GetDataTable("SELECT * FROM MasterPages WHERE PageTitle in ('Home','Masters','Utility')  AND Status=0");
                                            //foreach (DataRow row in dtMasters.Rows)
                                            //{
                                            //    int masterpageID;
                                            //    int.TryParse(row["MasterPageID"].ToString(), out masterpageID);
                                            //    MasterPageAccess masterPageAccess = new MasterPageAccess();
                                            //    masterPageAccess.CompID = comp.CompId;
                                            //    masterPageAccess.MasterPageID = masterpageID;
                                            //    masterPageAccess.Insert();
                                            //}
                                           

                                            //DataTable dtMasters = db.GetDataTable("SELECT * FROM MasterPages WHERE PageTitle  not in ('Billing')  AND Status=0");
                                            DataTable dtMasters = db.GetDataTable("SELECT * FROM MasterPages WHERE Status=0");
                                            foreach (DataRow row in dtMasters.Rows)
                                            {
                                                int masterpageID;
                                                int.TryParse(row["MasterPageID"].ToString(), out masterpageID);
                                                MasterPageAccess masterPageAccess = new MasterPageAccess();
                                                masterPageAccess.CompID = comp.CompId;                                                
                                                masterPageAccess.MasterPageID = masterpageID;
                                                masterPageAccess.Insert();
                                            }
                                            //Assign Sub Page Permission for the Company
                                            //DataTable dtSubPages = db.GetDataTable("SELECT * FROM Subpage WHERE PageTitle not in ('New Invoice','Invoice List','Timesheet Input','fgfg','Client List')  AND Status=0");
                                            //foreach (DataRow row in dtSubPages.Rows)
                                            //{
                                            //    int subpageID;
                                            //    int.TryParse(row["SubPageID"].ToString(), out subpageID);
                                            //    SubPageAccess subPageAccess = new SubPageAccess();
                                            //    subPageAccess.CompID = comp.CompId;
                                            //    subPageAccess.SubPageID = subpageID;
                                            //    subPageAccess.Insert();
                                            //}
                                            ////Assign Sub Page Permission for the Company
                                            //DataTable dtSubPages = db.GetDataTable("SELECT * FROM Subpage WHERE PageTitle not in ('Department','Branch','Expenses','Location','Narration','Job Group','Client Group','Manage Permission','New Invoice','Invoice List')  AND Status=0");
                                            DataTable dtSubPages = db.GetDataTable("SELECT * FROM Subpage WHERE Status=0");
                                            foreach (DataRow row in dtSubPages.Rows)
                                            {
                                                int subpageID;
                                                int.TryParse(row["SubPageID"].ToString(), out subpageID);
                                                SubPageAccess subPageAccess = new SubPageAccess();
                                                subPageAccess.CompID = comp.CompId;
                                                subPageAccess.SubPageID = subpageID;
                                                subPageAccess.Insert();
                                            }
                                        }
                                        string StrSQL1 = "update aspnet_Membership set IsApproved='true' where UserId='" + uid + "'";
                                        db.ExecuteCommand(StrSQL1);
                                        //Clear All Controls in the Page
                                        clearall();
                                        //Update the update Panel 
                                        UpdatePanel1.Update();
                                        //Showing 'Successfull' Message 
                                        MessageControl1.SetMessage("Successfully Registered", MessageDisplay.DisplayStyles.Success);
                                        break;
                                    }
                                case MembershipCreateStatus.DuplicateUserName:
                                    {
                                        MessageControl1.SetMessage("There already exists a user with this username", MessageDisplay.DisplayStyles.Error);
                                        break;
                                    }
                                case MembershipCreateStatus.DuplicateEmail:
                                    {
                                        MessageControl1.SetMessage("There already exists a user with this Email Id", MessageDisplay.DisplayStyles.Error);
                                        break;
                                    }
                                case MembershipCreateStatus.InvalidEmail:
                                    {
                                        MessageControl1.SetMessage("There email address you provided in invalid.", MessageDisplay.DisplayStyles.Error);
                                        break;
                                    }
                                default:
                                    {
                                        MessageControl1.SetMessage(status.ToString(), MessageDisplay.DisplayStyles.Error);
                                        break;
                                    }
                            }
                        }
                        else
                        {
                            MessageControl1.SetMessage("Password Mismatch", MessageDisplay.DisplayStyles.Error);
                        }
                    }
                    else
                    {
                        MessageControl1.SetMessage("Invalid Email ID", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl1.SetMessage("Invalid web address", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                MessageControl1.SetMessage("Mandatory Fields Must be Filled", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }
    //Clearing All Controls in the Page
    public void clearall()
    {    
        txtcompanyname.Text = string.Empty;
        txtaddress1.Text = string.Empty;
        txtaddress2.Text = string.Empty;
        txtaddress3.Text = string.Empty;
        txtcity.Text = string.Empty;
        txtemail.Text = string.Empty;
        txtmob.Text = string.Empty;
        txtpin.Text = string.Empty;
        txtwebsite.Text = string.Empty;
        txtUsername.Text = string.Empty;
        TxtPassword.Text = string.Empty;
    }
    //Email validation
    public bool emailValid(string email)
    {
        if (email != "")
        {
            string pattern = @"^[a-z][a-z|0-9|]*([_][a-z|0-9]+)*([.][a-z|0-9]+([_][a-z|0-9]+)*)?@[a-z][a-z|0-9|]*\.([a-z][a-z|0-9]*(\.[a-z][a-z|0-9]*)?)$";
            System.Text.RegularExpressions.Match match = Regex.Match(email.Trim(), pattern, RegexOptions.IgnoreCase);
            if (match.Success)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return true;
        }
    }
    //Website validation
    public bool websValid(string web)
    {
        if (web != "")
        {
            string pattern = @"^http\://(\S*)?$";
            System.Text.RegularExpressions.Match match = Regex.Match(web.Trim(), pattern, RegexOptions.IgnoreCase);
            if (match.Success)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return true;
        }
    }
    //Sending Mail for Company ,Regarding the Confirmation of Creation of Account with Login Details  
    private void SendNotificationEmail(string emailid)
    {
        SmtpClient smtp = new SmtpClient();
        string name = txtfirstname.Text + " " + txtlastname.Text;

        smtp.Host = "mail.timesheet.co.in";

        smtp.Credentials = new System.Net.NetworkCredential("admin@timesheet.co.in", "admin-123");



        MailMessage message = new MailMessage();
        message.From = new MailAddress("admin@timesheet.co.in");
        message.Subject = "JTMS - SignUp";
        message.IsBodyHtml = true;
        StringBuilder body = new StringBuilder();
        body.Append("<table>");
        body.Append("<tr><td></td></tr>");
        body.Append("<tr><td></td></tr>");
        body.Append("<tr><td><img src=\"http://timesheet.co.in/login/images/saibex_logo.jpg\"</td></tr>");
        body.Append("<tr><td></td></tr>");
        body.Append("<tr><td></td></tr>");
        body.Append("<tr><td>Dear <b>" + name + "</b> , </td></tr>");
        body.Append("<tr><td>Welcome to www.timesheet.co.in. This email confirms that your account has been created successfully.  Please find the following details</td></tr>");
        body.Append("<tr><td></td></tr>");
        body.Append("<tr><td></td></tr>");
        body.Append("<tr><td><table class=\"style25\"><tr><td style=\"width: 100px\"><b>Company Name :<b></td><td>&nbsp;" + txtcompanyname.Text + "</td></tr><tr><td style=\"width: 80px\"><b>Login&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; :<b></td><td align=\"left\">&nbsp;http://timesheet.co.in/login/</td></tr><tr><td style=\"width: 80px\"><b>User Name :<b></td><td>&nbsp;" + txtUsername.Text+ "</td></tr><tr><td style=\"width: 80px\"><b>Password&nbsp;&nbsp; :<b></td><td>&nbsp;" + TxtPassword.Text + " </td></tr><tr><td style=\"width: 80px\"><b>Website&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; :<b></td><td>&nbsp;<a target=\"_blank\" href=\"http://www.timesheet.co.in\">www.timesheet.co.in</a></td></tr></table></td></tr>");
        //body.Append("<tr><td><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Login :&nbsp;&nbsp;<b> http://timesheet.co.in/login/ </td></tr>");
        //body.Append("<tr><td><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;User Name :&nbsp;&nbsp;<b>" + txtusername.Text + " </td></tr>");
        //body.Append("<tr><td><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Password  :&nbsp;&nbsp;<b>" + txtpassword.Text + " </td></tr>");
        //body.Append("<tr><td><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Website   :&nbsp;&nbsp;<b><a target=\"_blank\" href=\"http://www.timesheet.co.in\">www.timesheet.co.in</a></td></tr>");               
        body.Append("<tr><td></td></tr>");
        body.Append("<tr><td></td></tr>");
        body.Append("<tr><td>Thank you for choosing Saibex <b>\"Job & Timesheet Management Software\"</b>, India's 1st web based Timesheet software.</td></tr>");
        body.Append("</table>");
        body.Append("<br />");
        body.Append("<br />");
        body.Append("Sincerely,<br />");
        body.Append("<span style=\"font-weight: bold; color: #000099;\">Team - Saibex</span>");
        body.Append("<br />");
        body.Append("<br />");
        body.Append(" <table class=\"style1\" style=\"width: 594px\"><tr><td> Saibex Network |</td></tr><tr><td><span style=\"font-size:10.0pt;line-height:115%;font-family:Arial,sans-serif;mso-fareast-font-family:Times New Roman;color:#888888;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA\">C3, Satyandra Bhavan, New Nagardas Road, Andheri (East), Mumbai - 400069 | Maharashtra | India |</span></td></tr><tr><td><span style=\"font-size:10.0pt;line-height:115%;font-family:Arial,sans-serif;mso-fareast-font-family:Times New Roman;color:#888888;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA\">Tel +91 9892606006 | +91 22 28258159 / 28261255 |</span></td></tr><tr><td><span style=\"font-size:10.0pt;line-height:115%;font-family:Arial,sans-serif;mso-fareast-font-family:Times New Roman;color:#888888;mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA\">Email :&nbsp;<a href=\"mailto:info@saibex.co.in\" target=\"_blank\"><span style=\"mso-bidi-font-size:11.0pt;line-height:115%;color:#222222\">info@saibex.co.in</span></a>&nbsp;|&nbsp;<a href=\"http://www.saibex.co.in\" target=\"_blank\"><span style=\"mso-bidi-font-size:11.0pt;line-height:115%;color:#2A5DB0\">www.saibex.co.in</span></a>&nbsp;|&nbsp;<a href=\"http://www.timesheet.co.in\" target=\"_blank\"><span style=\"mso-bidi-font-size:11.0pt;line-height:115%;color:#2A5DB0\">www.timesheet.co.in</span></a></span></td></tr></table>");
        message.Body = body.ToString();
        message.To.Add(emailid);
        try
        {
            smtp.Send(message);
        }
        catch (Exception ex) { }
    }
}
