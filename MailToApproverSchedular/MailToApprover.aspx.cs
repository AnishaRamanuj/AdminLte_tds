using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.Services;
using System.Net;
using System.Net.Mail;

namespace MailToApproverSchedular
{
    [System.Web.Script.Services.ScriptService]
    public partial class MailToApprover : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!Page.IsPostBack)
            //{
            //    string directoryPath = Server.MapPath("Upload");// @"C:\inetpub\wwwroot\"; // Replace with your desired directory path
            //    string filePath = Path.Combine(directoryPath, "EmailSent.txt");

            //    if (File.Exists(filePath))
            //        File.Delete(filePath);

            //    int i = 0;
            //    CommonFunction objCommonFunction = new CommonFunction();
            //    DataSet ds = SqlHelper.ExecuteDataset(objCommonFunction._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetAllCompany");
            //    foreach(DataRow dr in ds.Tables[0].Rows)
            //    {
            //        SqlParameter[] param = new SqlParameter[1];
            //        param[0] = new SqlParameter("@compid", dr["CompId"]);
            //        DataSet dsApprover = SqlHelper.ExecuteDataset(objCommonFunction._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_Approver_List", param);
            //        //foreach (DataRow drApp in dsApprover.Tables[0].Rows)
            //        for(int j=0;j<=20;j++)
            //        {
            //            //Page.ClientScript.RegisterClientScriptBlock(GetType(), "myScript" + i, "SendEmail('Timesheet Status Update','"+ drApp["StaffName"].ToString() + "','" + DateTime.Now.ToString("dd/MM/yyyy") + "','Test email using cs Page',10,'krupa2316@gmail.com');", true);
            //            ClientScript.RegisterStartupScript(this.GetType(), "myScript" + i, "SendEmail('Timesheet Status Update','" + "Test Approver"+i + "','" + DateTime.Now.ToString("dd/MM/yyyy") + "','Test email using cs Page',10,'krupa2316@gmail.com');", true);
            //            System.Threading.Thread.Sleep(10000);
            //            i++;
            //        }
            //    }              
            //    File.Create(filePath);
            //}
        }


        //public void SendEmail()
        //{
        //    // Mailtrap.io SMTP server settings
        //    var smtpHost = "smtp.mailtrap.io";
        //    var smtpPort = 2525;
        //    var smtpUsername = "your_username";
        //    var smtpPassword = "your_password";

        //    // Create a new SMTP client
        //    using (var client = new SmtpClient(smtpHost, smtpPort))
        //    {
        //        client.Credentials = new NetworkCredential(smtpUsername, smtpPassword);
        //        client.EnableSsl = true; // Mailtrap.io supports SSL

        //        // Create a new MailMessage
        //        var message = new MailMessage
        //        {
        //            From = new MailAddress("noreply@onlinetds.co.in"),
        //            Subject = "Test Email",
        //            Body = "This is a test email sent from ASP.NET using Mailtrap.io",
        //            IsBodyHtml = true,
        //        };

        //        // Add recipient(s)
        //        message.To.Add("recipient@example.com");

        //        // Send the email
        //        client.Send(message);
        //    }
        //}

    }
}