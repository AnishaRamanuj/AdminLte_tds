<%@ WebService Language="C#" Class="wsAudit" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Data.SqlClient;
using CommonLibrary;
using System.Data;
using Microsoft.ApplicationBlocks1.Data;
using System.Globalization;
using System.Web.Script.Serialization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsAudit  : System.Web.Services.WebService {

    [WebMethod]
    public string Get_ProjectName(staffprojectwise_Hours currobj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectwiseReport> List_SM = new List<tbl_ProjectwiseReport>();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", currobj.compid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetProjectName", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_ProjectwiseReport()
                    {
                        Jobid = objComm.GetValue<int>(drrr["JobId"].ToString()),
                        Projectname = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                    });
                }
                drrr.Close();
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectwiseReport> tbl = List_SM as IEnumerable<tbl_ProjectwiseReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetProjectHours(tbl_Audit currobj)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Audit> obj_Audit = new List<tbl_Audit>();

        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@jobid", currobj.jobid );
            param[2] = new SqlParameter("@startdt", currobj.Monthdate );
            param[3] = new SqlParameter("@enddt", currobj.Todate);
            //param[2] = new SqlParameter("@enDT", currobj.Monthdate );
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Audit", param))
            {
                while (drrr.Read())
                {
                    obj_Audit.Add(new tbl_Audit()
                    {
                        Hrs = objComm.GetValue<double>(drrr["TotalTime"].ToString()),
                        Monthdate = objComm.GetValue<string>(drrr["mthyr"].ToString()),

                    });
                }


                List<tbl_Audit_details> listAudit_D = new List<tbl_Audit_details>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAudit_D.Add(new tbl_Audit_details()
                            {
                                depCnt = objComm.GetValue<int>(drrr["depCnt"].ToString()),
                                StfCnt = objComm.GetValue<int>(drrr["StfCnt"].ToString()),
                                Sdate = objComm.GetValue<string>(drrr["Sdate"].ToString()),
                                Endate = objComm.GetValue<string>(drrr["Endate"].ToString()),
                                TotalDays = objComm.GetValue<int>(drrr["TotalDays"].ToString()),
                                PPer = objComm.GetValue<double>(drrr["PPer"].ToString()),
                                Peramt = objComm.GetValue<double>(drrr["Peramt"].ToString()),
                                Thrs = objComm.GetValue<double>(drrr["Thrs"].ToString()),
                                Rhrs = objComm.GetValue<double>(drrr["Rhrs"].ToString()),
                                Bhrs = objComm.GetValue<double>(drrr["Bhrs"].ToString()),
                                Currency = objComm.GetValue<string>(drrr["Currency"].ToString()),
                                Total_Invoice = objComm.GetValue<double>(drrr["Total_Invoice"].ToString()),
                                RBills = objComm.GetValue<double>(drrr["RBills"].ToString()),
                            });
                        }
                    }
                }

                foreach (var item in obj_Audit)
                {
                    item.list_Audit_Details = listAudit_D;

                }

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Audit> tbl = obj_Audit as IEnumerable<tbl_Audit>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }
}