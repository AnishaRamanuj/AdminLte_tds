using JTMSProject;
using Microsoft.ApplicationBlocks1.Data;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;

public partial class signupform : System.Web.UI.Page
{
    public readonly DBAccess db = new DBAccess();
    private readonly CompanyMaster comp = new CompanyMaster();
    public static CultureInfo ci = new CultureInfo("en-GB");
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //clearall();
            //Binddropdown();
        }

    }
    //public void clearall()
    //{
    //    txtName.Text = string.Empty;
    //    txtPhone.Text = string.Empty;
    //    //txtaddress2.Text = string.Empty;
    //    //txtaddress3.Text = string.Empty;
    //    //txtcity.Text = string.Empty;
    //    txtEmail.Text = string.Empty;
    //    txtPhone.Text = string.Empty;
    //    txtEmail.Text = string.Empty;
    //    txtfirstname.Text = string.Empty;
    //    //  txtlastname.Text = string.Empty;
    //    txtusername.Text = string.Empty;
    //    txtpassword.Text = string.Empty;
    //    //txtverifypwd.Text = string.Empty;
    //}
    public bool emailValid(string email)
    {
        if (email != "")
        {
            //  string pattern = @"^[a-z][a-z|0-9|[-]]*([_][-][a-z|0-9]+)*([.][a-z|0-9]+([_][-][a-z|0-9]+)*)?@[a-z][-][a-z|0-9|]*\.([a-z][-][a-z|0-9]*(\.[a-z][-][a-z|0-9]*)?)$";
            string pattern = @"^(?!\.)(""([^""\r\\]|\\[""\r\\])*""|"
           + @"([-a-z0-9!#$%&'*+/=?^_`{|}~]|(?<!\.)\.)*)(?<!\.)"
           + @"@[a-z0-9][\w\.-]*[a-z0-9]\.[a-z][a-z\.]*[a-z]$";

            System.Text.RegularExpressions.Match match = Regex.Match(email.Trim(), pattern, RegexOptions.IgnoreCase);
            if (match.Success)
            {
                //string b = "true";
                //return b;
                return true;
            }
            else
            {
                //string b = "false";
                //return b;
                return false;
            }
        }
        else
        {
            return true;
        }
    }
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
    //private void SendNotificationEmail(string emailid)
    //{
    //    string msg = "";

    //    string password = Convert.ToString(ViewState["custpwd"]);
    //    string custname = Convert.ToString(ViewState["custname"]);
    //    string custumername = Convert.ToString(ViewState["custusername"]);

    //    StringBuilder body = new StringBuilder();
    //    body.Append("<HTML>");
    //    body.Append("<HEAD>");
    //    body.Append("<TITLE>Welcome to JTMS (Job and Timesheet Software)</TITLE>");
    //    body.Append("<META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=iso-8859-1'>");
    //    body.Append("<style type='text/css'>");
    //    body.Append("<!--");
    //    body.Append(".style5 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: x-small; }");
    //    body.Append(".style13 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: small; font-weight: bold; }");
    //    body.Append(".style15 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: x-small; color: #999999; }");
    //    body.Append(".style19 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: small; }");
    //    body.Append(".style20 {font-size: small}");
    //    body.Append("-->");
    //    body.Append("</style>");
    //    body.Append("</HEAD>");
    //    body.Append("<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>");
    //    body.Append("<!-- ImageReady Slices (welcom-to-jtms.psd) -->");
    //    body.Append("<TABLE WIDTH=500 BORDER=0 align='center' CELLPADDING=0 CELLSPACING=0>");
    //    body.Append("<TR>");
    //    body.Append("<TD>&nbsp;</TD>");
    //    body.Append("</TR>");
    //    body.Append("<TR>");
    //    body.Append("<TD>");
    //    body.Append("<IMG SRC='http://www.timesheet.co.in/login/images/Welcome-To-JTMS_02.gif' WIDTH=500 HEIGHT=143 ALT=''></TD>");
    //    body.Append("	</TR>");
    //    body.Append("	<TR>");
    //    body.Append("		<TD><table width='490' border='0' align='center'>");
    //    body.Append("         <tr>");
    //    body.Append("           <td><div align='center' class='style19'>Its time to add fun to your work and get more done. Switch to JTMS.</div></td>");
    //    body.Append("          </tr>");
    //    body.Append("         ");
    //    body.Append("          <tr>");
    //    body.Append("           <td>&nbsp;</td>");
    //    body.Append("          </tr>");
    //    body.Append("         <tr>");
    //    body.Append("           <td><span class='style19'>Dear " + custname + ",</span></td>");
    //    body.Append("        </tr>");
    //    body.Append("        <tr>");
    //    body.Append("           <td>Company Name :" + comp.CompanyName + "</td>");
    //    body.Append("         </tr>");
    //    body.Append("          <tr>");
    //    body.Append("           <td Contact Person: " + comp.FirstName + "  </td>");
    //    body.Append("    </tr>");
    //    body.Append("          <tr>");
    //    body.Append("            <td>Phone : " + comp.Phone + " </td>");
    //    body.Append("          </tr>");
    //    body.Append("          <tr>");
    //    body.Append("            <td>Phone : " + comp.Email + " </td>");
    //    body.Append("          </tr>");
    //    body.Append("          ");
    //    body.Append("       <tr>");
    //    body.Append("         <td> <p class='style19'>Thanks for signing up. Easy, right?</p>   <div align='justify' class='style19'>It&rsquo;s full-on test drive time. We want to make sure you have what you need to get going with Job and Timesheet Software in no time at all. Please find 30-day free trial with the link below, and bookmark it for easy access:</div></td>");
    //    body.Append("       </tr>");
    //    body.Append("      <tr>");
    //    body.Append("         <td>&nbsp;</td>");
    //    body.Append("   </tr>");

    //    body.Append("    <tr>");
    //    body.Append("     <td><span class='style19'>Sign in to your Administrator account:</span></td>");
    //    body.Append("   </tr>");
    //    body.Append("   <tr>");
    //    body.Append("     <td><table width='463' border='0' align='center'>");
    //    body.Append("       <tr>");
    //    body.Append("   <td width='87' class='style13'>Web URL </td>");
    //    body.Append("     <td width='10' class='style13'>:</td>");
    //    body.Append("       <td width='357' class='style13'><a href='http://www.timesheet.co.in/Login/Default.aspx' target='_blank'>http://www.timesheet.co.in/Login/Default.aspx</a></td>");
    //    body.Append("     </tr>");
    //    body.Append("   <tr>");
    //    body.Append(" <td class='style13'>Username</td>");
    //    body.Append("    <td class='style13'>:</td>");
    //    body.Append("      <td class='style13'>" + custumername + "</td>");
    //    body.Append("  </tr>");
    //    body.Append("    <tr>");
    //    body.Append("    <td class='style13'>Password</td>");
    //    body.Append("     <td class='style13'>:</td>");
    //    body.Append("   <td class='style13'>" + password + "</td>");
    //    body.Append("   </tr>");
    //    body.Append("  </table></td>");
    //    body.Append(" </tr>");
    //    body.Append("  <tr>");
    //    body.Append("   <td>&nbsp;</td>");
    //    body.Append(" </tr>");

    //    body.Append("  ");
    //    body.Append("  <tr>");
    //    body.Append("   <td><div align='center' class='style19'><a href='http://www.timesheet.co.in/timesheet-software-screenshots.html' target='_blank'>Click here to view screenshots.</a></div></td>");
    //    body.Append("  </tr>");

    //    body.Append("  <tr>");
    //    body.Append("   <td>&nbsp;</td>");
    //    body.Append("  </tr>");
    //    body.Append(" <tr>");
    //    body.Append("     <td><div align='justify' class='style19'>Don't hesitate to contact us on info@saibex.co.in / 9892606006. If any assistance required.</div></td>");
    //    body.Append("  </tr>");

    //    body.Append(" <tr>");
    //    body.Append("   <td>&nbsp;</td>");
    //    body.Append("  </tr>");
    //    body.Append("  <tr>");
    //    body.Append("    <td><span class='style19'>Regards,</span></td>");
    //    body.Append("      </tr>");

    //    body.Append("  <tr>");
    //    body.Append("   <td>&nbsp;</td>");
    //    body.Append("  </tr>");
    //    body.Append(" <tr>");
    //    body.Append("    <td><span class='style19'>JTMS Team</span></td>");
    //    body.Append("  </tr>");
    //    body.Append("  <tr>");
    //    body.Append("    <td><span class='style19'>(022-28258159 / 28261255 / 9892606006)</span></td>");
    //    body.Append("  </tr>");
    //    body.Append("  <tr>");
    //    body.Append("   <td><hr></td>");
    //    body.Append("  </tr>");
    //    body.Append("   <tr>");
    //    body.Append("      <td align='center'><img src='http://www.timesheet.co.in/login/images/sn-welcome.jpg' width='189' height='88'></td>");
    //    body.Append("    </tr>");

    //    body.Append("   <tr>");
    //    body.Append("     <td><div align='center' class='style19'>C-3, 2nd floor, Satyander Bhuvan, New Nagardas Road, Opp Pinky Cinema,&nbsp;<br>");
    //    body.Append("     Andheri (E), Mumbai - 400069</div></td>");
    //    body.Append("   </tr>");
    //    body.Append("   <tr>");
    //    body.Append("     <td><table width='477' border='0' align='center'>");
    //    body.Append("      <tbody>");
    //    body.Append("     <tr>");
    //    body.Append("       <td width='33' class='style19'>email</td");
    //    body.Append("       <td width='10' class='style19'>:</td>");
    //    body.Append("       <td width='191' class='style19'><a href='mailto:info@saibex.co.in'>info@saibex.co.in</a></td>");
    //    body.Append("       <td width='26' class='style19'></td>");
    //    body.Append("      <td width='40' class='style19'>phone</td>");
    //    body.Append("       <td width='9' class='style19'>:</td>");
    //    body.Append("     <td width='138' class='style19'><div align='right'>28258159/28261255</div></td>");
    //    body.Append("       </tr>");
    //    body.Append("    </tbody>");
    //    body.Append("    </table>            </td>");
    //    body.Append("    </tr>");
    //    body.Append("    <tr>");
    //    body.Append("      <td>&nbsp;</td>");
    //    body.Append("    </tr>");
    //    body.Append("     <tr>");
    //    body.Append("       <td><div align='center'><span class='style15'>You&rsquo;ve received this email because you have sign-up on <a href='http://www.timesheet.co.in/' target='_blank'>www.timesheet.co.in</a> account with this email address.</span></div></td>");
    //    body.Append("       </tr>");
    //    body.Append("     </table></TD>");
    //    body.Append("	</TR>");
    //    body.Append("</TABLE>");
    //    body.Append("<!-- End ImageReady Slices -->");
    //    body.Append("</BODY>");
    //    body.Append("</HTML>");
    //    // hdnBody.Value = body.ToString();
    //    //ScriptManager.RegisterStartupScript(this, this.GetType(), "NewRegistration", "SendMails();", true);

    //    SmtpClient smtp = new SmtpClient();
    //    smtp.Host = "sh017.webhostingservices.com";
    //    smtp.Port = 587;
    //    smtp.EnableSsl = false;
    //    smtp.Credentials = new System.Net.NetworkCredential("noreply@timesheetsoft.com", "Saibex2929@");
    //    smtp.DeliveryMethod = SmtpDeliveryMethod.Network;

    //    MailMessage message = new MailMessage();
    //    message.From = new MailAddress("noreply@timesheetsoft.com");
    //    message.Subject = "Welcome to JTMS (Job and Timesheet Software)";
    //    message.IsBodyHtml = true;
    //    message.Body = body.ToString();
    //    message.To.Add("rjrajput@gmail.com");
    //    message.Bcc.Add("info@saibex.co.in");
    //    try
    //    {
    //        smtp.Send(message);

    //        msg = "Thanks for SignUP.Please check your Mail for Login Details.";
    //        string script = "window.onload = function() { SuccessMsg('" + msg + "'); };";
    //        ClientScript.RegisterStartupScript(this.GetType(), "SuccessMsg", script, true);
    //    }
    //    catch (Exception ex)
    //    {
    //        msg = ex.Message.ToString();
    //        string script = "window.onload = function() { ErrMsg('" + msg + "'); };";
    //        ClientScript.RegisterStartupScript(this.GetType(), "ErrMsg", script, true);
     
    //    }
    //}





    //protected void BtnOK_Click(object sender, EventArgs e)
    //{
    //    string msg = "";
    //    string script = "";
    //    try
    //    {
    //        string[] dtls = hdndtls.Value.ToString().Split('^') ;


    //        if (emailValid(dtls[3]))
    //        {

    //            MembershipCreateStatus status;
    //            string mail = dtls[3] + "- Company-Admin";

    //            Membership.CreateUser(dtls[4], dtls[5].Trim(), mail, "question",
    //                                          "answer", true, out status);
    //            switch (status)
    //            {
    //                case (MembershipCreateStatus.Success):
    //                    {
    //                        Roles.AddUserToRole(dtls[4], "company");
    //                        Guid uid = new Guid((Membership.GetUser(dtls[4]).ProviderUserKey).ToString());


    //                        //comp.UserId = uid;
    //                        //comp.Role = "company";
    //                        //comp.IsApproved = true;
    //                        //comp.id = 1;
    //                        comp.CompanyName = dtls[0];

    //                        comp.Email = dtls[3];
    //                        comp.Phone = dtls[2];
    //                        comp.FirstName = dtls[1];
    //                        //comp.LastName = txtlastname.Text;
    //                        comp.CreatedDate = DateTime.Now;
    //                        comp.username = dtls[4];
    //                        comp.password = dtls[5].Trim();
    //                        //comp.LastLogin = DateTime.Now;
    //                        //comp.Logins = 0;

    //                        //comp.Cash = drpcash.SelectedValue;
    //                        //comp.Freeze = "N";
    //                        //comp.Freezedays = 0;
    //                        SqlParameter[] sqlParams = new SqlParameter[25];
    //                        sqlParams[0] = new SqlParameter("@CompId", SqlDbType.Int);
    //                        sqlParams[0].Value = 0;

    //                        sqlParams[1] = new SqlParameter("@id", SqlDbType.Int);
    //                        sqlParams[1].Value = 1;

    //                        sqlParams[2] = new SqlParameter("@CompanyName", SqlDbType.VarChar);
    //                        sqlParams[2].Value = dtls[0];

    //                        sqlParams[3] = new SqlParameter("@Address1", SqlDbType.VarChar);
    //                        sqlParams[3].Value = "";

    //                        sqlParams[4] = new SqlParameter("@Address2", SqlDbType.VarChar);
    //                        sqlParams[4].Value = "";

    //                        sqlParams[5] = new SqlParameter("@Address3", SqlDbType.VarChar);
    //                        sqlParams[5].Value = "";

    //                        sqlParams[6] = new SqlParameter("@City", SqlDbType.VarChar);
    //                        sqlParams[6].Value = "";

    //                        sqlParams[7] = new SqlParameter("@Pin", SqlDbType.VarChar);
    //                        sqlParams[7].Value = "";

    //                        sqlParams[8] = new SqlParameter("@Phone", SqlDbType.VarChar);
    //                        sqlParams[8].Value = dtls[2];

    //                        sqlParams[9] = new SqlParameter("@Website", SqlDbType.VarChar);
    //                        sqlParams[9].Value = "";

    //                        sqlParams[10] = new SqlParameter("@Email", SqlDbType.VarChar);
    //                        sqlParams[10].Value = dtls[3];

    //                        sqlParams[11] = new SqlParameter("@username", SqlDbType.VarChar);
    //                        sqlParams[11].Value = dtls[4];

    //                        sqlParams[12] = new SqlParameter("@password", SqlDbType.VarChar);
    //                        sqlParams[12].Value = dtls[5];

    //                        sqlParams[13] = new SqlParameter("@CreatedDate", SqlDbType.DateTime);
    //                        sqlParams[13].Value = Convert.ToDateTime(DateTime.Now, ci);

    //                        sqlParams[14] = new SqlParameter("@Role", SqlDbType.NVarChar);
    //                        sqlParams[14].Value = "company";

    //                        sqlParams[15] = new SqlParameter("@IsApproved", SqlDbType.Bit);
    //                        sqlParams[15].Value = true;

    //                        sqlParams[16] = new SqlParameter("@UserId", SqlDbType.UniqueIdentifier);
    //                        sqlParams[16].Value = uid;

    //                        sqlParams[17] = new SqlParameter("@Logins", SqlDbType.Int);
    //                        sqlParams[17].Value = 0;

    //                        sqlParams[18] = new SqlParameter("@LastLogin", SqlDbType.DateTime);
    //                        sqlParams[18].Value = Convert.ToDateTime(DateTime.Now, ci);

    //                        sqlParams[19] = new SqlParameter("@FirstName", SqlDbType.VarChar);
    //                        sqlParams[19].Value = dtls[1];

    //                        sqlParams[20] = new SqlParameter("@LastName", SqlDbType.VarChar);
    //                        sqlParams[20].Value = "";

    //                        sqlParams[21] = new SqlParameter("@Cash", SqlDbType.VarChar);
    //                        sqlParams[21].Value = "INR";

    //                        sqlParams[22] = new SqlParameter("@CanAdminEnterTimesheet", SqlDbType.VarChar);
    //                        sqlParams[22].Value = "N";

    //                        sqlParams[23] = new SqlParameter("@Freeze", SqlDbType.VarChar);
    //                        sqlParams[23].Value = "N";

    //                        sqlParams[24] = new SqlParameter("@FreezeDays", SqlDbType.Int);
    //                        sqlParams[24].Value = 0;


    //                        DataSet ds = SqlHelper.ExecuteDataset(db.ConString, CommandType.StoredProcedure, "usp_Bootstrap_CreateCompany", sqlParams);
    //                        //int res = comp.Insert();
    //                        int Compid = Convert.ToInt32(ds.Tables[0].Rows[0]["CompId"]);

    //                        if (ds != null)
    //                        {
    //                            SecurityPermission per = new SecurityPermission();
    //                            per.CompId = Compid;
    //                            per.Schemes = "Free Version";
    //                            per.UserCount = 40;
    //                            per.StaffCount = 40;
    //                            per.WebSpace = "Unlimited";
    //                            per.DayCount = 30;
    //                            per.Price = 0;
    //                            per.Version = "Hosted";
    //                            per.Insert();
    //                            string StrSQL1 = "update aspnet_Membership set IsApproved='true' where UserId='" + uid + "'";
    //                            db.ExecuteCommand(StrSQL1);
    //                            SendNotificationEmail(dtls[3]);

    //                        }

    //                        // datadiv.Style.Value = "display:none";

    //                        break;



    //                    }

    //                case MembershipCreateStatus.DuplicateUserName:
    //                    {
    //                        msg = "USERNAME already exist, please try with different USERNAME";
    //                        // MessageControl1.SetMessage("USERNAME already exist, please try with different USERNAME", MessageDisplay.DisplayStyles.Error);
    //                         script = "window.onload = function() { ErrMsg('" + msg + "'); };";
    //                        ClientScript.RegisterStartupScript(this.GetType(), "ErrMsg", script, true);
    //                        break;
    //                    }
    //                case MembershipCreateStatus.DuplicateEmail:
    //                    {
    //                        msg = "EMAIL already exist, please try with different EMAIL ID";
    //                        // MessageControl1.SetMessage("EMAIL already exist, please try with different EMAIL ID", MessageDisplay.DisplayStyles.Error);
    //                         script = "window.onload = function() { ErrMsg('" + msg + "'); };";
    //                        ClientScript.RegisterStartupScript(this.GetType(), "ErrMsg", script, true);
    //                        break;
    //                    }
    //                case MembershipCreateStatus.InvalidEmail:
    //                    {
    //                        msg = "Email address you provided in invalid.";
    //                        //MessageControl1.SetMessage("Email address you provided in invalid.", MessageDisplay.DisplayStyles.Error);
    //                        script = "window.onload = function() { ErrMsg('" + msg + "'); };";
    //                        ClientScript.RegisterStartupScript(this.GetType(), "ErrMsg", script, true);
    //                        break;
    //                    }
    //                case MembershipCreateStatus.InvalidPassword:
    //                    {
    //                        msg = "The password provided is invalid. It must be seven characters long and have at least one non-alphanumeric character.";
    //                        //MessageControl1.SetMessage("The password provided is invalid. It must be seven characters long and have at least one non-alphanumeric character.", MessageDisplay.DisplayStyles.Error);
    //                        script = "window.onload = function() { ErrMsg('" + msg + "'); };";
    //                        ClientScript.RegisterStartupScript(this.GetType(), "ErrMsg", script, true);
    //                        break;
    //                    }
    //                default:
    //                    {
    //                        msg = status.ToString();
    //                        // MessageControl1.SetMessage(status.ToString(), MessageDisplay.DisplayStyles.Error);
    //                        script = "window.onload = function() { ErrMsg('" + msg + "'); };";
    //                        ClientScript.RegisterStartupScript(this.GetType(), "ErrMsg", script, true);
    //                        break;
    //                    }
    //            }


    //        }
    //        else
    //        {
    //            msg = "Invalid EMAIL ID";
    //            //MessageControl1.SetMessage("Invalid EMAIL ID", MessageDisplay.DisplayStyles.Error);
    //             script = "window.onload = function() { ErrMsg('" + msg + "'); };";
    //            ClientScript.RegisterStartupScript(this.GetType(), "ErrMsg", script, true);
    //        }

    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }

    //}
}
