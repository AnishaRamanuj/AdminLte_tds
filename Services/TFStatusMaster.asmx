<%@ WebService Language="C#" Class="TFStatusMaster" %>

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
public class TFStatusMaster : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");


    [WebMethod]
    public string GetProjectdropdown(int compid, int Pagelevel)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<_Bind_project> List_DS = new List<_Bind_project>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@pagelevel", Pagelevel);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Status_Proj_Dropdown", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new _Bind_project()
                    {

                        projectid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        projectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),

                    });
                }


            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<_Bind_project> tbl = List_DS as IEnumerable<_Bind_project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateStatus(int compid, string rcd,int Pagelevel)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();
        //string DateUpdated = DateUpdate != "" ? Convert.ToDateTime(DateUpdate, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@rcd", rcd);
            param[2] = new SqlParameter("@pagelevel",Pagelevel);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InsertUpdate_Status", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["STID"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string Get_Grid(int compid, int pageIndex, int pageSize, int prjid, string status, string health, int Pagelevel)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Status_TF_Grid> List_DS = new List<tbl_Status_TF_Grid>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@PageIndex", pageIndex);
            param[2] = new SqlParameter("@PageSize", pageSize);
            param[3] = new SqlParameter("@Prj", prjid);
            param[4] = new SqlParameter("@status", status);
            param[5] = new SqlParameter("@health", health);
            param[6] = new SqlParameter("@pagelevel", Pagelevel);

            DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Status_GridTF", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Status_GridTF", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Status_TF_Grid()
                    {
                        srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Id = objComm.GetValue<int>(drrr["ID"].ToString()),
                        //jobid = objComm.GetValue<int>(drrr["jobid"].ToString()),
                        cltid = objComm.GetValue<int>(drrr["Divid"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        //BusinessUnit = objComm.GetValue<string>(drrr["BusUnitName"].ToString()),
                        Project_ID = objComm.GetValue<int>(drrr["ProjectId"].ToString()),
                        Project = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        PrjHealth = objComm.GetValue<string>(drrr["ProjectHealth"].ToString()),
                        PrjStatus = objComm.GetValue<string>(drrr["ProjectStatus"].ToString()),
                        ActualDt = objComm.GetValue<string>(drrr["ActualDt"].ToString()),
                        CurrentDt = objComm.GetValue<string>(drrr["CurrentDt"].ToString()),
                        //Buid = objComm.GetValue<int>(drrr["buid"].ToString()),
                        Narr = objComm.GetValue<string>(drrr["Narration"].ToString()),
                        //CurrNarr = objComm.GetValue<string>(drrr["Currentdt_Comment"].ToString()),
                        //ActulNarr = objComm.GetValue<string>(drrr["Actualdt_Comment"].ToString()),
                        Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                        //Projstartdt = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Status_TF_Grid> tbl = List_DS as IEnumerable<tbl_Status_TF_Grid>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



}