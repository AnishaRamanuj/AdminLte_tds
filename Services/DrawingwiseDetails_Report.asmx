<%@ WebService Language="C#" Class="DrawingwiseDetails_Report" %>

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
public class DrawingwiseDetails_Report : System.Web.Services.WebService
{
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

    [WebMethod(EnableSession = true)]
    public string GetDrawings()
    {
        List<tbl_Drawing> drawings = new List<tbl_Drawing>();
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDrawings", param))
            {
                while (drrr.Read())
                {
                    drawings.Add(new tbl_Drawing()
                    {
                        DrawingNo = objComm.GetValue<string>(drrr["DNumber"].ToString()),
                        DrwId = objComm.GetValue<int>(drrr["Drawing_Id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Drawing> tbl = drawings as IEnumerable<tbl_Drawing>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}