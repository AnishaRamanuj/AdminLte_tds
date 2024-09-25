<%@ WebService Language="C#" Class="ProjectwiseWorkhours" %>
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
public class ProjectwiseWorkhours : System.Web.Services.WebService
{
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    [WebMethod(EnableSession = true)]
    public string GetBranch(int CompId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<Branch_Master> listBranchMaster = new List<Branch_Master>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetBranchlist", param))
                {
                    while (drrr.Read())
                    {
                        listBranchMaster.Add(new Branch_Master()
                        {
                            BrId = objComm.GetValue<int>(drrr["BrId"].ToString()),
                            BranchName = objComm.GetValue<string>(drrr["BranchName"].ToString())
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
    public string GetProjectManager(int CompId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectManagers> listPrjMngrMaster = new List<tbl_ProjectManagers>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@compId", Session["companyid"]);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetProjectManagersName", param))
                {
                    while (drrr.Read())
                    {
                        listPrjMngrMaster.Add(new tbl_ProjectManagers()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(listPrjMngrMaster);
    }

    [WebMethod(EnableSession = true)]
    public string GetApprover(int CompId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectManagers> listPrjMngrMaster = new List<tbl_ProjectManagers>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@CompId", Session["companyid"]);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetApproverNameList", param))
                {
                    while (drrr.Read())
                    {
                        listPrjMngrMaster.Add(new tbl_ProjectManagers()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(listPrjMngrMaster);
    }

    [WebMethod(EnableSession = true)]
    public string GetEmployee(int CompId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectManagers> listPrjMngrMaster = new List<tbl_ProjectManagers>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetEmloyeeNameList", param))
                {
                    while (drrr.Read())
                    {
                        listPrjMngrMaster.Add(new tbl_ProjectManagers()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(listPrjMngrMaster);
    }

    [WebMethod(EnableSession = true)]
    public string GetProjectList(int branch, string fromDate, string toDate, int projectManager, int approver, int staff, string sortType)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_branchProject> listProjectMaster = new List<tbl_branchProject>();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[8];
                param[0] = new SqlParameter("@compID", Session["companyid"]);
                param[1] = new SqlParameter("@BrId", branch);
                param[2] = new SqlParameter("@StartDate", fromDate);
                param[3] = new SqlParameter("@EndDate", toDate);
                param[4] = new SqlParameter("@StaffCode", projectManager);
                param[5] = new SqlParameter("@approver", approver);
                param[6] = new SqlParameter("@staff", staff);
                param[7] = new SqlParameter("@SortBy", sortType);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetFilterProject", param))
                {
                    while (drrr.Read())
                    {
                        listProjectMaster.Add(new tbl_branchProject()
                        {
                            Project_Id = objComm.GetValue<int>(drrr["Project_Id"].ToString()),
                            ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString())
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(listProjectMaster);
    }


}