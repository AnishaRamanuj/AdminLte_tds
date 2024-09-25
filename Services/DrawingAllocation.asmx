<%@ WebService Language="C#" Class="DrawingAllocation" %>

using System;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class DrawingAllocation : System.Web.Services.WebService
{
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    [WebMethod]
    public string OnPageLoad(int compid, int pageIndex, int pageSize, string Srch, string searchStatus)
    {
        DataSet ds;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@pageIndex", pageIndex);
            param[2] = new SqlParameter("@pageSize", pageSize);
            param[3] = new SqlParameter("@Srch", Srch);
            param[4] = new SqlParameter("@SearchStatus", searchStatus);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Drawing_OnLoad", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod]
    public string GetDrawingAllocationProjects(int compId, int clientId, int drawingAllocationId)
    {
        DataSet dds = new DataSet();
        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@CompId", compId);
            param[1] = new SqlParameter("@ClientId", clientId);
            param[2] = new SqlParameter("@DrawingAllocationId", drawingAllocationId);
            dds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetDrawingAllocationProjects", param);
            return dds.GetXml();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public string GetDrawingAllocationClients(int compId, int drawingAllocationId)
    {
        DataSet ds;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@CompId", compId);
            param[1] = new SqlParameter("@DrawingAllocationId", drawingAllocationId);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetDrawingAllocationClients", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod]
    public string GetProjectListOnClient(int compid, int clientid, int projectid, int drw_act_id, string parem, int Drawing_id)
    {
        List<Drawing_Staff> list_Staft = new List<Drawing_Staff>();
        DataSet dds = new DataSet();
        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@clientid", clientid);
            param[2] = new SqlParameter("@projectid", projectid);
            param[3] = new SqlParameter("@Param", parem);
            param[4] = new SqlParameter("@Drawing_Allocation_Id", drw_act_id);
            param[5] = new SqlParameter("@Drawing_Id", Drawing_id);
            if (parem == "P")
            {
                dds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "use_Bootstrap_GetProject_And_Activity", param);
            }
            else if (parem == "E1" || parem == "E2")
            {
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "use_Bootstrap_GetProject_And_Activity", param))
                {
                    while (drrr.Read())
                    {
                        if (parem.Equals("E2"))
                        {
                            list_Staft.Add(new Drawing_Staff()
                            {
                                EmpId = objComm.GetValue<int>(drrr["EmpId"].ToString()),
                                EmpName = objComm.GetValue<string>(drrr["EmpName"].ToString()),
                                IsChecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                            });
                        }
                        else if (parem.Equals("E1"))
                        {
                            list_Staft.Add(new Drawing_Staff()
                            {
                                EmpId = objComm.GetValue<int>(drrr["EmpId"].ToString()),
                                EmpName = objComm.GetValue<string>(drrr["EmpName"].ToString()),
                            });
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        if (parem.Equals("P"))
        {
            return dds.GetXml();
        }
        else
        {
            IEnumerable<Drawing_Staff> tbl = list_Staft as IEnumerable<Drawing_Staff>;
            return new JavaScriptSerializer().Serialize(tbl);
        }
    }

    [WebMethod]
    public string OnEdit(int compid, int DrwId)
    {
        List<tbl_Drawing> List_DS = new List<tbl_Drawing>();
        List<Drawing_Allocation> drwAllocation = new List<Drawing_Allocation>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@drw_id", DrwId);

            List_DS.Add(new tbl_Drawing()
            {
                Compid = compid
            });

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DrawingAllocation_Edit", param))
            {
                while (drrr.Read())
                {
                    drwAllocation.Add(new Drawing_Allocation()
                    {
                        ProjectId = objComm.GetValue<int>(drrr["ProjectId"].ToString()),
                        ClientId = objComm.GetValue<int>(drrr["ClientId"].ToString()),
                        Act_Id = objComm.GetValue<int>(drrr["mJob_Id"].ToString()),
                        Sub_Act_Id = objComm.GetValue<int>(drrr["Sub_Act_Id"].ToString()),
                        Drawing_Id = objComm.GetValue<int>(drrr["Drawing_Id"].ToString()),
                        StartDate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        EndDate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        TargetDate = objComm.GetValue<string>(drrr["TargetDate"].ToString()),
                        Revision = objComm.GetValue<string>(drrr["Revision"].ToString()),
                        Remark = objComm.GetValue<string>(drrr["Remerk"].ToString()),
                        DrawingNumber = objComm.GetValue<string>(drrr["DrawingNumber"].ToString()),
                        DrawingAllocationIdTimeSheet = objComm.GetValue<int>(drrr["DrawingAllocationIdTimeSheet"].ToString())
                    });
                }
                foreach (var item in List_DS)
                {
                    item.drwAllocation = drwAllocation;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Drawing> tbl = List_DS as IEnumerable<tbl_Drawing>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DrawingAllocation_Save(int compid, int drawing_All_id, int drpPrj, int drpCln, int drpAct, int drpSbAct, int drpDrw, string drpRev, string dtStart, string dtEnd, string dtTDate, string remark, string hdnSltEmp, string revFlag)
    {
        if (hdnSltEmp.Contains("/"))
        {
            hdnSltEmp = hdnSltEmp.Replace("/", "");
        }
        List<tbl_Drawing_Details> List_DS = new List<tbl_Drawing_Details>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[14];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@drw_all_id", drawing_All_id);
            param[2] = new SqlParameter("@drpPrj", drpPrj);
            param[3] = new SqlParameter("@drpCln", drpCln);
            param[4] = new SqlParameter("@drpAct", drpAct);
            param[5] = new SqlParameter("@drpSbAct", drpSbAct);
            param[6] = new SqlParameter("@drpDrw", drpDrw);
            param[7] = new SqlParameter("@drpRev", drpRev);
            param[8] = new SqlParameter("@dtStart", dtStart);
            param[9] = new SqlParameter("@dtEnd", dtEnd);
            param[10] = new SqlParameter("@dtTDate", dtTDate);
            param[11] = new SqlParameter("@remark", remark);
            param[12] = new SqlParameter("@SltEmpIds", hdnSltEmp);
            param[13] = new SqlParameter("@RevFlag", revFlag);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateDrawingAllocation", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Drawing_Details()
                    {
                        Pid = objComm.GetValue<int>(drrr["Drawing_Allocation_Id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Drawing_Details> tbl = List_DS as IEnumerable<tbl_Drawing_Details>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Delete_DrawingAllocation(int compid, int Pid, int Drawing_Id, int Drw_act_id, int drw_Allocation_Id)
    {
        List<tbl_Drawing_Details> List_DS = new List<tbl_Drawing_Details>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Drw_act_id", Drw_act_id);
            param[2] = new SqlParameter("@Drawing_Id", Drawing_Id);
            param[3] = new SqlParameter("@Pid", Pid);
            param[4] = new SqlParameter("@DrawingAllocationId", drw_Allocation_Id);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ProjectAllocation_Delete", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Drawing_Details()
                    {
                        Pid = objComm.GetValue<int>(drrr["Drawing_Allocation_Id"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Drawing_Details> tbl = List_DS as IEnumerable<tbl_Drawing_Details>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetDrawingNameFromDrawingId(int compid, int drawingId)
    {
        List<tbl_Drawing_Details> List_DS = new List<tbl_Drawing_Details>();

        SqlParameter[] param = new SqlParameter[6];
        param[0] = new SqlParameter("@compid", compid);
        param[1] = new SqlParameter("@clientid", 0);
        param[2] = new SqlParameter("@projectid", 0);
        param[3] = new SqlParameter("@Param", 'D');
        param[4] = new SqlParameter("@Drawing_Allocation_Id", 0);
        param[5] = new SqlParameter("@Drawing_Id", drawingId);
        using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "use_Bootstrap_GetProject_And_Activity", param))
        {
            while (drrr.Read())
            {
                List_DS.Add(new tbl_Drawing_Details()
                {
                    DrawingName = objComm.GetValue<string>(drrr["DrawingName"].ToString()),
                });
            }
        }
        IEnumerable<tbl_Drawing_Details> tbl = List_DS as IEnumerable<tbl_Drawing_Details>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetSubActivityIdBasedOnAckId(int compId, int ackId)
    {
        SqlParameter[] param = new SqlParameter[2];
        List<vw_JobnSubActivityMaster> List_subact = new List<vw_JobnSubActivityMaster>();
        param[0] = new SqlParameter("@compId", compId);
        param[1] = new SqlParameter("@ackId", ackId);
        using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_getsubactivitybasedAckId", param))
        {
            while (drrr.Read())
            {
                List_subact.Add(new vw_JobnSubActivityMaster()
                {
                    AckId = objComm.GetValue<int>(drrr["Sub_Act_Id"].ToString()),
                    ActivityName = objComm.GetValue<string>(drrr["SubActivity"].ToString()),
                });
            }
        }
        IEnumerable<vw_JobnSubActivityMaster> tbl = List_subact as IEnumerable<vw_JobnSubActivityMaster>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetDrawingListOnProject(int compId, int projectId)
    {
        List<tbl_ProjectDrawing> obj_Job = new List<tbl_ProjectDrawing>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@CompId", compId);
            param[1] = new SqlParameter("@ProjectId", projectId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstarp_GetDrawingListOnProject", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectDrawing()
                    {
                        DrawingId = objComm.GetValue<int>(drrr["Drawing_Id"].ToString()),
                        DrawingNumber = objComm.GetValue<string>(drrr["DrwNumber"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectDrawing> tbl = obj_Job as IEnumerable<tbl_ProjectDrawing>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string SaveSumbitDate(int drawingAllocationId, string submitDate)
    {
        var res = 0;
        Drawing_Allocation drawingAlloc = new Drawing_Allocation();
        try
        {
            string sDate = submitDate != "" ? Convert.ToDateTime(submitDate).ToString("MM/dd/yyyy") : null;
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@DrawingAllocationId", drawingAllocationId);
            param[2] = new SqlParameter("@SubmitDate", sDate);
            res = SqlHelper.ExecuteNonQuery(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstarp_SaveSubmitDate_DrawingAllocation", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        if (res > 0)
        { return "success"; }
        else { return "error"; }
    }
}