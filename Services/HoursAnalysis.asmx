<%@ WebService Language="C#" Class="HoursAnalysis" %>
using System;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class HoursAnalysis : System.Web.Services.WebService
{
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    [WebMethod(EnableSession = true)]
    public string GetDesignation(int CompId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<Branch_Master> listBranchMaster = new List<Branch_Master>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDesglist", param))
                {
                    while (drrr.Read())
                    {
                        listBranchMaster.Add(new Branch_Master()
                        {
                            BrId = objComm.GetValue<int>(drrr["DsgId"].ToString()),
                            BranchName = objComm.GetValue<string>(drrr["DesignationName"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(listBranchMaster);
    }

    [WebMethod(EnableSession = true)]
    public string GetReport(int pageIndex, int pageSize, int branch, string status, int project, int prjMngr, int desg)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectAnalysis> listPrjAnalysis = new List<tbl_ProjectAnalysis>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[8];

                param[0] = new SqlParameter("@compID", Session["companyid"]);
                param[1] = new SqlParameter("@pageindex", pageIndex);
                param[2] = new SqlParameter("@pagesize", pageSize);
                param[3] = new SqlParameter("@status", status);
                param[4] = new SqlParameter("@branch", branch);
                param[5] = new SqlParameter("@project", project);
                param[6] = new SqlParameter("@prjMngr", prjMngr);
                param[7] = new SqlParameter("@desg", desg);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetHoursAnalysis", param))
                {
                    while (drrr.Read())
                    {
                        listPrjAnalysis.Add(new tbl_ProjectAnalysis()
                        {
                            srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                            PrjCode = objComm.GetValue<string>(drrr["Project_Code"].ToString()),
                            Project = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                            Client = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                            Start = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                            End = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                            PrjManager = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                            Quote = objComm.GetValue<string>(drrr["Billable_Hrs"].ToString()),
                            Budget = objComm.GetValue<string>(drrr["NonBillable_Hrs"].ToString()),
                            Actual = objComm.GetValue<string>(drrr["Actual_Hrs"].ToString()),
                            ActualPer = objComm.GetValue<string>(drrr["Left_Hrs"].ToString()),
                            totCount = objComm.GetValue<string>(drrr["Totalcount"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(listPrjAnalysis);
    }

}
