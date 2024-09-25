<%@ WebService Language="C#" Class="WS_ApproverList" %>

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
public class WS_ApproverList : System.Web.Services.WebService
{
    [WebMethod]
    public string Get_Approver_List(ApproverList currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<ApproverList> List_SM = new List<ApproverList>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", currobj.compid);          

            DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "Usp_Get_Approver_List", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "Usp_Get_Approver_List", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new ApproverList()
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
        IEnumerable<ApproverList> tbl = List_SM as IEnumerable<ApproverList>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
}