<%@ WebService Language="C#" Class="SubActivityMaster" %>

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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class SubActivityMaster : System.Web.Services.WebService
{
    [WebMethod]
    public string GetSubActivityRecord(string compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<vw_JobnSubActivityMaster> obj_Job = new List<vw_JobnSubActivityMaster>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetSubActivityDetails", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new vw_JobnSubActivityMaster()
                    {
                        TSId = objComm.GetValue<int>(drrr["sino"].ToString()),
                        AckId = objComm.GetValue<int>(drrr["Sub_Act_Id"].ToString()),
                        SubActivityName = objComm.GetValue<string>(drrr["SubActivity"].ToString()),
                        ActivityName = objComm.GetValue<string>(drrr["countActivity"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["TotalCount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<vw_JobnSubActivityMaster> tbl = obj_Job as IEnumerable<vw_JobnSubActivityMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod]
    public string GetActivityRecord(int compid, int hdnSubAckId)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ActivityMaster> obj_Job = new List<tbl_ActivityMaster>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@ackId", hdnSubAckId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetActivityList", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ActivityMaster()
                    {
                        ActivityId = objComm.GetValue<int>(drrr["MJobId"].ToString()),
                        ActivityName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        Jobid = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ActivityMaster> tbl = obj_Job as IEnumerable<tbl_ActivityMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod]
    public string InsertUpdateSubActv(int compid, int hdnSubAckId, string SubActname, string hdnAllapp)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectSubActivity> obj_Job = new List<tbl_ProjectSubActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@ackId", hdnSubAckId);
            param[2] = new SqlParameter("@activtyname", SubActname);
            param[3] = new SqlParameter("@Activity_Id", hdnAllapp);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdateSubActivity", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectSubActivity()
                    {
                        Activity_Id = objComm.GetValue<int>(drrr["AckId"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectSubActivity> tbl = obj_Job as IEnumerable<tbl_ProjectSubActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod]
    public string DeleteSubActiv(int compid, int Activity_Id)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectSubActivity> obj_Job = new List<tbl_ProjectSubActivity>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@ackId", Activity_Id);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDeleteSubActivity", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectSubActivity()
                    {
                        Activity_Id = objComm.GetValue<int>(drrr["ackId"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_ProjectSubActivity> tbl = obj_Job as IEnumerable<tbl_ProjectSubActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
}