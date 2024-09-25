<%@ WebService Language="C#" Class="Ws_Expense" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data.SqlClient;
using System.Data;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Globalization;
using JTMSProject;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Ws_Expense : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]

    public string Get_All_Project_Job_Staff_BranchName(int compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<BranchnameProjectJstaff> List_SM = new List<BranchnameProjectJstaff>();

        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_All_Staff_Client_Project_BranchName", param))
            {
                while (sdr.Read())
                {
                    List_SM.Add(new BranchnameProjectJstaff
                    {
                        BrId = objComm.GetValue<int>(sdr["BrId"].ToString()),
                        Branch = objComm.GetValue<string>(sdr["BranchName"].ToString()),
                    });
                }
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<BranchnameProjectJstaff> tbl = List_SM as IEnumerable<BranchnameProjectJstaff>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

         [WebMethod]

    public string Get_Projectwise_Job_StaffAll_Selected(Projectwise currobj)//int compid, string UserType, string status, string StaffCode)
    {

        CommonFunctions objComm = new CommonFunctions();
        List<tbl_StaffMaster_Project> List_SM = new List<tbl_StaffMaster_Project>();

        try
        {

            DateTime fromdate = Convert.ToDateTime(currobj.fromdate, ci);
            DateTime todate = Convert.ToDateTime(currobj.todate, ci);
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[14];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@UserType", currobj.UserType);
            param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
            param[3] = new SqlParameter("@StaffCode", currobj.StaffCode == "" ? "0" : currobj.StaffCode);
            param[4] = new SqlParameter("@selectedjobid", currobj.selectedjobid.TrimEnd(','));
            param[5] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
            param[6] = new SqlParameter("@selectedstaffcode", currobj.selectedstaffcode.TrimEnd(','));
            param[7] = new SqlParameter("@neetstaff", currobj.staffwise);
            param[8] = new SqlParameter("@neetjob", currobj.jobwise);
            param[9] = new SqlParameter("@needproject", currobj.projectwise);
            param[10] = new SqlParameter("@FromDate", fromdate);
            param[11] = new SqlParameter("@Todate", todate);
            param[12] = new SqlParameter("@RType", currobj.RType);
            param[13] = new SqlParameter("@Brid", currobj.BrId);
            DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "Usp_Get_Expense_Project_Job_Staff_All_Selected", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "Usp_Get_Expense_Project_Job_Staff_All_Selected", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_StaffMaster_Project()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                } drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster_Project> tbl = List_SM as IEnumerable<tbl_StaffMaster_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



}