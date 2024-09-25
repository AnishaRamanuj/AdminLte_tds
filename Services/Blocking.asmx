<%@ WebService Language="C#" Class="Blocking" %>

using System;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Globalization;
using System.Web.Security;
using System.Text.RegularExpressions;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Blocking  : System.Web.Services.WebService {

    [WebMethod(EnableSession=true)]
    public string FillProject( int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetProjectList", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string ProjectDates( int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);


            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetProject_BlockingDates", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Team( int Pid, int Bid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@Bid", Bid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_Project_BlockingTeam", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession = true)]
    public string SaveDates(int Pid, int Bid, string st, string ed)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@Bid", Bid);
            param[3] = new SqlParameter("@st", st);
            param[4] = new SqlParameter("@ed", ed);

            
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Blocking_SaveDates", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project()
                    {
                        Pid = objComm.GetValue<int>(drrr["Pid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Project> tbl = List_DS as IEnumerable<tbl_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string SaveTeam(int Pid, int Bid, string AllStf )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@Bid", Bid);
            param[3] = new SqlParameter("@AllStf", AllStf);
 
           
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Blocking_SaveTeam", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project()
                    {
                        Pid = objComm.GetValue<int>(drrr["Pid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Project> tbl = List_DS as IEnumerable<tbl_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string Delete_Dates( int Pid, int Bid )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@Bid", Bid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Delete_Project_BlockingDates", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project()
                    {
                        Pid = objComm.GetValue<int>(drrr["Pid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Project> tbl = List_DS as IEnumerable<tbl_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}