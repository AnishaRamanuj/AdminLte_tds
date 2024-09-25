<%@ WebService Language="C#" Class="WS_Project_Client_BillableHrs" %>

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
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.IO;
using System.Drawing;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WS_Project_Client_BillableHrs  : System.Web.Services.WebService {

    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod]
    public string Get_BranchList(int compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<ProjectwiseBillable_Hrs> List_SM = new List<ProjectwiseBillable_Hrs>();

        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_All_Project_Client_BranchName", param))
            {
                while (sdr.Read())
                {
                    List_SM.Add(new ProjectwiseBillable_Hrs
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
        IEnumerable<ProjectwiseBillable_Hrs> tbl = List_SM as IEnumerable<ProjectwiseBillable_Hrs>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]

    public string Get_Project_client(ProjectwiseBillable_Hrs currobj)//int compid, string UserType, string status, string StaffCode)
    {

        CommonFunctions objComm = new CommonFunctions();
        List<ProjectwiseBillable_Hrs> List_SM = new List<ProjectwiseBillable_Hrs>();

        try
        {

            DateTime fromdate = Convert.ToDateTime(currobj.fromdate, ci);
            DateTime todate = Convert.ToDateTime(currobj.todate, ci);
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[11];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@UserType", currobj.UserType);
            param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
            param[3] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
            param[4] = new SqlParameter("@selectedclientid", currobj.selectedclientid.TrimEnd(','));
            param[5] = new SqlParameter("@neetclient", currobj.needclient);
            param[6] = new SqlParameter("@needproject", currobj.needProject);
            param[7] = new SqlParameter("@FromDate", fromdate);
            param[8] = new SqlParameter("@Todate", todate);
            param[9] = new SqlParameter("@staffcode", currobj.staffcode);
            param[10] = new SqlParameter("@Brid", currobj.BrId);

            //  DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Project_client_for_Billable_Hrs", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Project_client_for_Billable_Hrs", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new ProjectwiseBillable_Hrs()
                    {
                        id = objComm.GetValue<int>(drrr["id"].ToString()),
                        PNAME = objComm.GetValue<string>(drrr["NAME"].ToString()),
                        Type = objComm.GetValue<string>(drrr["Type"].ToString())
                    });
                } drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<ProjectwiseBillable_Hrs> tbl = List_SM as IEnumerable<ProjectwiseBillable_Hrs>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

          
   [WebMethod]
    public string Get_Project_StaffExpense(Projectwisestaffexpense currobj)//int compid, string UserType, string status, string StaffCode)
    {

        CommonFunctions objComm = new CommonFunctions();
        List<Projectwisestaffexpense> List_SM = new List<Projectwisestaffexpense>();

        try
        {

            DateTime fromdate = Convert.ToDateTime(currobj.fromdate, ci);
            DateTime todate = Convert.ToDateTime(currobj.todate, ci);
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[11];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@UserType", currobj.UserType);
            param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
            param[3] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
            param[4] = new SqlParameter("@selectedstaffid", currobj.selectedclientid.TrimEnd(','));
            param[5] = new SqlParameter("@neetstaff", currobj.needstaff);
            param[6] = new SqlParameter("@needproject", currobj.needProject);
            param[7] = new SqlParameter("@FromDate", fromdate);
            param[8] = new SqlParameter("@Todate", todate);
            param[9] = new SqlParameter("@staffcode", currobj.staffcode);
            param[10] = new SqlParameter("@Brid", currobj.BrId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_ProjectWiseStaff", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new Projectwisestaffexpense()
                    {
                        id = objComm.GetValue<int>(drrr["id"].ToString()),
                        PNAME = objComm.GetValue<string>(drrr["NAME"].ToString()),
                        Type = objComm.GetValue<string>(drrr["Type"].ToString())
                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<Projectwisestaffexpense> tbl = List_SM as IEnumerable<Projectwisestaffexpense>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}