<%@ WebService Language="C#" Class="SubTask_Master" %>

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
public class SubTask_Master  : System.Web.Services.WebService {

    [WebMethod]
    public string GetSubTaskRecord(string Srch, int pageIndex, int pageSize)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        Common ob = new Common();

        string _Compid = ob.companyid.ToString();
        try
        {

            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetSubTask", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod]
    public string GetSubTaskDetails(int hdnSubTaskId)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        Common ob = new Common();

        string _Compid = ob.companyid.ToString();
        try
        {

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@SubTaskId", hdnSubTaskId);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetSubTaskProjectList", param);


        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();

    }


    [WebMethod]
    public string InsertUpdateSubTask(int hdnSubTaskId, string SubTask, string hdnAllapp)
    {
        //DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectSubActivity> obj_Job = new List<tbl_ProjectSubActivity>();

        Common ob = new Common();

        string _Compid = ob.companyid.ToString();

        try
        {

            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@SubTaskId", hdnSubTaskId);
            param[2] = new SqlParameter("@SubTaskname", SubTask);
            param[3] = new SqlParameter("@ProjectId", hdnAllapp);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdate_SubTask", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectSubActivity()
                    {
                        Activity_Id = objComm.GetValue<int>(drrr["SubTaskId"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        //return ds.GetXml();
        IEnumerable<tbl_ProjectSubActivity> tbl = obj_Job as IEnumerable<tbl_ProjectSubActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteSubTask(int SubTask_Id)
    {
        //DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_ProjectSubActivity> obj_Job = new List<tbl_ProjectSubActivity>();
        Common ob = new Common();

        string _Compid = ob.companyid.ToString();
        try
        {

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@SubTaskId", SubTask_Id);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Delete_SubTask", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectSubActivity()
                    {
                        Activity_Id = objComm.GetValue<int>(drrr["SubTaskId"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        //return ds.GetXml();
        IEnumerable<tbl_ProjectSubActivity> tbl = obj_Job as IEnumerable<tbl_ProjectSubActivity>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}
