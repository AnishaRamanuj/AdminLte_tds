<%@ WebService Language="C#" Class="AreaMaster" %>

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
public class AreaMaster  : System.Web.Services.WebService {

    [WebMethod]
    public string GetAreaRecord(string Srch, int pageIndex, int pageSize)
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
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetArea", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod]
    public string GetAreaDetails(int hdnAreaId)
    {
        DataSet ds;
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        Common ob = new Common();

        string _Compid = ob.companyid.ToString();
        try
        {

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", _Compid);
            param[1] = new SqlParameter("@areaId", hdnAreaId);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetAreaProjectList", param);

            //using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetActivityList", param))
            //{
            //    while (drrr.Read())
            //    {
            //        obj_Job.Add(new tbl_ActivityMaster()
            //        {
            //            ActivityId = objComm.GetValue<int>(drrr["MJobId"].ToString()),
            //            ActivityName = objComm.GetValue<string>(drrr["MJobName"].ToString()),
            //            Jobid = objComm.GetValue<int>(drrr["ischecked"].ToString()),
            //        });
            //    }
            //}
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();

    }


    [WebMethod]
    public string InsertUpdateArea( int hdnAreaId, string Areaname, string hdnAllapp)
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
            param[1] = new SqlParameter("@AreaId", hdnAreaId);
            param[2] = new SqlParameter("@Areaname", Areaname);
            param[3] = new SqlParameter("@ProjectId", hdnAllapp);
            //ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdate_Area", param);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InserUpdate_Area", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectSubActivity()
                    {
                        Activity_Id = objComm.GetValue<int>(drrr["AreaId"].ToString()),
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
    public string DeleteArea( int Area_Id)
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
            param[1] = new SqlParameter("@AreaId", Area_Id);
            //ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Delete_Area", param);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Delete_Area", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_ProjectSubActivity()
                    {
                        Activity_Id = objComm.GetValue<int>(drrr["AreaId"].ToString()),
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