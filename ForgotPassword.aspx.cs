using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using JTMSProject;
using System.Web.Security;
using System.Text;
using System.Net.Mail;
using System.Configuration;
using Microsoft.ApplicationBlocks1.Data;
using Newtonsoft.Json.Linq;
using System.Threading.Tasks;
using System.IO;
using System.Net;
using System.Net.Mime;
public partial class ForgotPassword : System.Web.UI.Page
{
    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    SmtpClient smtp = new SmtpClient();
    Systme_Parameters param = new Systme_Parameters();
    System_Dal objSystem_Dal = new System_Dal();
    DataSet ds;
    bool isTrueSendMail = false;

    private readonly DBAccess db = new DBAccess();
    string pass = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                string ss = "select convert(varchar,getdate(),107) as date";
                DataTable dt = db.GetDataTable(ss);
                // Label1.Text = dt.Rows[0]["date"].ToString();
            }
            catch (Exception ex)
            {

            }
        }
    }


    //protected void btnchange_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        string email = hdnEmail.Value ;
    //        hdnEmail.Value = Convert.ToString(email);
    //        DataSet ds = new DataSet();

    //        SqlParameter[] param = new SqlParameter[1];
    //        param[0] = new SqlParameter("@email", email);
    //        ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_GetForgetPasswrd", param);
    //        if (ds.Tables[0].Rows.Count > 0)
    //        {
    //            DataTable dts;
    //            dts = ds.Tables[0];
    //            string password = Convert.ToString(ds.Tables[0].Rows[0]["Password"]);
    //            string custname = Convert.ToString(ds.Tables[0].Rows[0]["username"]);
    //            string usrname = Convert.ToString(ds.Tables[0].Rows[0]["ID"]);
    //            //string mobile = Convert.ToString(ds.Tables[0].Rows[0]["mobile"]);
    //            //SendSMS(mobile, usrname, password);
    //            SendNotificationEmail(usrname, password, custname);
                
    //        }
    //        else
    //        {
    //            MessageBox(this, "Username not found.");
    //        }

    //    }
    //    catch (Exception ex)
    //    {

    //        MessageBox(this, "Something went wrong.");
    //    }
    //}

    private void SendSMS(string mobile, string usr, string psd)
    {
        WebClient client = new WebClient();
        string auth = "D!~6094rfwybksnB7";
         
        string baseurl = "https://api.datagenit.com/sms?auth=" + auth + " &senderid=SAIBEX&msisdn=" + mobile + "&message=Username=" +usr + "  Password= " + psd + " url=www.timesheet.co.in/login/default.aspx Timesheet Support Team";
        Stream data = client.OpenRead(baseurl);
        StreamReader reader = new StreamReader(data);
        string s = reader.ReadToEnd();
        data.Close();
        reader.Close();
    }

    private void SendNotificationEmail (string usrname, string password, string custname )   //(DataSet dts)
    {
        string path = Server.MapPath(@"Images/h2.gif");
        LinkedResource Img = new LinkedResource(path, MediaTypeNames.Image.Gif);
        Img.ContentId = "MyImage";
        StringBuilder body = new StringBuilder();
        body.Append("<HTML>");
        body.Append("<HEAD>");
        body.Append("<TITLE>Welcome to JTMS (Job and Timesheet Software)</TITLE>");
        body.Append("<META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=iso-8859-1'>");
        body.Append("<style type='text/css'>");
        body.Append("<!--");
        body.Append(".style5 {font-family: Geneva, Arial, Helvetica, sans-serif; font-size: x-small; }");
        body.Append(".style13 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: small; font-weight: bold; }");
        body.Append(".style15 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: x-small; color: #999999; }");
        body.Append(".style19 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: small; }");
        body.Append(".style20 {font-size: small}");
        body.Append("-->");
        body.Append("</style>");
        body.Append("</HEAD>");
        body.Append("<BODY BGCOLOR=#FFFFFF LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0>");
        body.Append("<!-- ImageReady Slices (welcom-to-jtms.psd) -->");
        body.Append("<TABLE WIDTH=500 BORDER=0 align='left' CELLPADDING=0 CELLSPACING=0>");
        body.Append("<TR>");
        body.Append("<TD>&nbsp;</TD>");
        body.Append("</TR>");

        body.Append("<TR>");
        body.Append("<TD><table width='490' border='0' align='center'>");
        body.Append("         <tr>");
        body.Append("           <td><span class='style13'>Dear " + custname + ",</span></td>");
        body.Append("         </tr>");
        body.Append("         <tr>");
        body.Append("         <td>&nbsp;</td>");
        body.Append("         </tr>");
        body.Append("          <tr>");
        body.Append("           <td><span class='style19'>Please find your following details:</span></td>");
        body.Append("         </tr>");
        body.Append("         <tr>");
        body.Append("         <td>&nbsp;</td>");
        body.Append("         </tr>");
        body.Append("         <tr>");
        body.Append("            <td><table width='583' border='0' align='center'>");

        body.Append("                   <tr>");
        body.Append("                   <td width='187' class='style13'>Login URL </td>");
        body.Append("                   <td width='10' class='style13'>:</td>");
        body.Append("                   <td width='557' class='style13'><a href='http://login.timesheet.co.in/default.aspx' target='_blank'>http://login.timesheet.co.in/default.aspx</a></td>");
        body.Append("                   </tr>");
        body.Append("                  <tr>");
        body.Append("                   <td class='style13'>Username</td>");
        body.Append("                   <td class='style13'>:</td>");
        body.Append("                     <td class='style19'>" + usrname + "</td>");
        body.Append("                  </tr>");

        body.Append("                   <tr>");
        body.Append("                   <td class='style13'>Password</td>");
        body.Append("                    <td class='style13'>:</td>");
        body.Append("                    <td class='style19'>" + password + "</td>");
        body.Append("                   </tr>");


        body.Append("                 </table></td>");
        body.Append("            </tr>");


        body.Append("            <tr>");
        body.Append("              <td>&nbsp;</td>");
        body.Append("             </tr>");
        body.Append("             <tr>");
        body.Append("             <td><span class='style19'>Regards,</span></td>");
        body.Append("            </tr>");

        body.Append("            <tr>");
        body.Append("            <td>&nbsp;</td>");
        body.Append("             </tr>");
        body.Append("            <tr>");
        body.Append("             <td class='style13'><span>TEAM </span></td>");
        body.Append("            </tr>");
        body.Append("             <tr>");
        body.Append("            <td><span>JTMS Timesheet Software</span></td>");
        body.Append("            </tr>");
        body.Append("            <tr><td><div><img src=cid:MyImage width='131' height='42' border='0'></div></td>");
        body.Append("            </tr>");
        body.Append("            <tr>");
        body.Append("             <td class='style19'><div><a href='https://www.timesheet.co.in'>www.timesheet.co.in</a></div></td>");
        body.Append("            </tr>");
        body.Append("            <tr>");
        body.Append("             <td><table  width='583'><tr><td>Landline</td><td>:</td><td>022 - 35643644</td></tr>");
        body.Append("                       <tr><td>Mobile</td><td>:</td><td>9892606006/ 9004689590</td></tr>");
        body.Append("                       <tr><td>Email</td><td>:</td><td><a href='mailto:info@saibex.co.in'>info@saibex.co.in</a></td></tr>");
        body.Append("                  </table></td>");
        body.Append("             </tr>");
        body.Append("       </table>");
        body.Append("</td>");
        body.Append("</tr>");
        body.Append("</TABLE>");
        body.Append("<!-- End ImageReady Slices -->");
        body.Append("</BODY>");
        body.Append("</HTML>");
        // hdnBody.Value = body.ToString();

        AlternateView av1 = AlternateView.CreateAlternateViewFromString(body.ToString(), null, MediaTypeNames.Text.Html);
        av1.LinkedResources.Add(Img);
        SmtpClient smtp = new SmtpClient();
        smtp.Host = "mail.timesheetsoft.com";
        smtp.Port = 587;
        smtp.EnableSsl = true;
        smtp.Credentials = new System.Net.NetworkCredential("noreply@timesheetsoft.com", "Saibex2929@");
        smtp.DeliveryMethod = SmtpDeliveryMethod.Network;

        MailMessage message = new MailMessage();
        message.From = new MailAddress("noreply@timesheetsoft.com");
        message.Subject = "Reset Password";
        message.IsBodyHtml = true;
        message.AlternateViews.Add(av1);
        //message.Body = body.ToString();
        //hdnEmail.Value = "rjrajput@gmail.com";
        message.To.Add(hdnEmail.Value);
        //message.Bcc.Add("mufaddal0402@gmail.com");
        try
        {
            smtp.Send(message);
            MessageControl1.SetMessage("Mail has been sent to registered mail id.", MessageDisplay.DisplayStyles.Success);
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage(ex.ToString(), MessageDisplay.DisplayStyles.Error);
        }

    }



    public string GeneratePassword1(int PwdLength)
    {
        string pwdChars = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ0123456789";
        char[] pwdElements = pwdChars.ToCharArray();
        Random random = new Random();
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < PwdLength; i++)
        {
            int randomChar = random.Next(0, pwdElements.Length);
            builder.Append(pwdElements[randomChar]);
        }
        return builder.ToString();
    }
    public static void MessageBox(System.Web.UI.Page page, string strMsg)
    {
        //+ character added after strMsg "')"
        ScriptManager.RegisterClientScriptBlock(page, page.GetType(), "alertMessage", "alert('" + strMsg + "')", true);

    }
    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        Response.Redirect("Default.aspx");
    }
}


