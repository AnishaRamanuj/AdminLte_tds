using CommonLibrary;
using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace MailToApproverSchedular.Service
{
    /// <summary>
    /// Summary description for EmailService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class EmailService : WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }

        [WebMethod]
        public string GetCompanyList()
        {
            CommonFunctions objCommonFunction = new CommonFunctions();
            DataSet ds = SqlHelper.ExecuteDataset(objCommonFunction._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetAllCompany");

            return ds.GetXml();
        }

        [WebMethod]
        public string GetApproverList(int CompanyID)
        {
            CommonFunctions objCommonFunction = new CommonFunctions();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", CompanyID);
            //// usp_Bootstrap_Mail_Timesheet_New
            DataSet ds = SqlHelper.ExecuteDataset(objCommonFunction._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_Approver_List", param);

            return ds.GetXml();
        }

        [WebMethod]
        public string GetTimesheetStatus(int CompanyID, int ApproverID)
        {
            CommonFunctions objCommonFunction = new CommonFunctions();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", CompanyID);
            param[1] = new SqlParameter("@Approvercode", ApproverID);
            param[2] = new SqlParameter("@CurrentDate", DateTime.Now.ToString("MM/dd/yyyy"));

            DataSet ds = SqlHelper.ExecuteDataset(objCommonFunction._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Mail_Timesheet_Status_Update", param);

            return ds.GetXml();
        }

        [WebMethod]
        public string SaveTextFile()
        {

            // Create the file in a specified directory
            string directoryPath = Server.MapPath("../Upload");// @"C:\inetpub\wwwroot\"; // Replace with your desired directory path
            string filePath = Path.Combine(directoryPath, "EmailSent.txt");

            if (File.Exists(filePath))
                File.Delete(filePath);
            //File.WriteAllText(filePath, "File Craeted");
            File.Create(filePath);
            return "";
        }        
    }
}