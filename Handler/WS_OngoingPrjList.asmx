<%@ WebService Language="C#" Class="WS_OngoingPrjList" %>

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
public class WS_OngoingPrjList : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]
    public string Get_Project_List(PrjList currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<PrjList> List_SM = new List<PrjList>();

        try
        {
            DateTime strdate = Convert.ToDateTime(currobj.fdate, ci);
            DateTime enddate = Convert.ToDateTime(currobj.todate, ci);
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@stype", currobj.stype);
            param[2] = new SqlParameter("@fdate", strdate);
            param[3] = new SqlParameter("@todate", enddate);

            DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "Usp_Get_Ongoing_Project", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "Usp_Get_Ongoing_Project", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new PrjList()
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
        IEnumerable<PrjList> tbl = List_SM as IEnumerable<PrjList>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}