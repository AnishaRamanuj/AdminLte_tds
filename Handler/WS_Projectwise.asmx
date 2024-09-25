<%@ WebService Language="C#" Class="WS_Projectwise" %>

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
public class WS_Projectwise  : System.Web.Services.WebService {
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod(EnableSession=true)]
    public string Get_All_Project_Job_Staff_BranchName(int compid=0)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<BranchNamenProjectJobStaff> List_SM = new List<BranchNamenProjectJobStaff>();

        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                using (SqlDataReader sdr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_All_Staff_Client_Project_BranchName", param))
                {
                    while (sdr.Read())
                    {
                        List_SM.Add(new BranchNamenProjectJobStaff
                        {
                            BrId = objComm.GetValue<int>(sdr["BrId"].ToString()),
                            Branch = objComm.GetValue<string>(sdr["BranchName"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<BranchNamenProjectJobStaff> tbl = List_SM as IEnumerable<BranchNamenProjectJobStaff>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string Get_Projectwise_Job_Staff_All_Selected(ProjectJobStaff currobj)//int compid, string UserType, string status, string StaffCode)
    {

        CommonFunctions objComm = new CommonFunctions();
        List<BranchNamenProjectJobStaff> List_SM = new List<BranchNamenProjectJobStaff>();

        try
        {
            if (Session["companyid"] != null)
            {
                DateTime fromdate = Convert.ToDateTime(currobj.fromdate, ci);
                DateTime todate = Convert.ToDateTime(currobj.todate, ci);
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[15];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@UserType", currobj.UserType);
                param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
                param[3] = new SqlParameter("@StaffCode", currobj.StaffCode == "" ? "0" : currobj.StaffCode);
                param[4] = new SqlParameter("@selectedstaffcode", currobj.selectedstaffcode.TrimEnd(','));
                param[5] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
                param[6] = new SqlParameter("@selectedjobid", currobj.selectedjobid.TrimEnd(','));
                param[7] = new SqlParameter("@neetstaff", currobj.staffwise);
                param[8] = new SqlParameter("@neetjob", currobj.jobwise);
                param[9] = new SqlParameter("@needproject", currobj.projectwise);
                param[10] = new SqlParameter("@FromDate", fromdate);
                param[11] = new SqlParameter("@Todate", todate);
                param[12] = new SqlParameter("@RType", currobj.RType);
                param[13] = new SqlParameter("@TType", currobj.TType);
                param[14] = new SqlParameter("@Brid", currobj.BrId);
                DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "Usp_Get_Projectwise_Job_Staff_All_Selected", param);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "Usp_Get_Projectwise_Job_Staff_All_Selected", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new BranchNamenProjectJobStaff()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                            Type = objComm.GetValue<string>(drrr["type"].ToString())
                        });
                    }
                    drrr.Close();
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<BranchNamenProjectJobStaff> tbl = List_SM as IEnumerable<BranchNamenProjectJobStaff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


}