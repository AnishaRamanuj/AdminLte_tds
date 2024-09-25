<%@ WebService Language="C#" CodeBehind="~/App_Code/DCost.cs" Class="DCost" %>
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
using System.Linq;
using Newtonsoft.Json;



[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]

public class DCost : System.Web.Services.WebService
{
    [WebMethod(EnableSession = true)]
    public string GetProjectNameList(int compid = 0) //Get Project Name List
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        List<CostSheet> List_DS = new List<CostSheet>();
        List<CostSheet> listCostSheetMaster = new List<CostSheet>();

        int flag = 1;

        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[3];

                param[0] = new SqlParameter("@compID", Session["companyid"]);
                param[1] = new SqlParameter("@flag", flag);
                param[2] = new SqlParameter("@projectid", ' ');

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "GetCostSheetDetails", param))  //GetAllProjectName as per Company ID
                {
                    while (drrr.Read())
                    {
                        List_DS.Add(new CostSheet()
                        {
                            compid = objComm.GetValue<int>(drrr["CompId"].ToString()),
                        });
                    }

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listCostSheetMaster.Add(new CostSheet()
                                {
                                    ProjectName = (string)(drrr["ProjectName"].ToString()),
                                    projectid = (int)(drrr["ProjectID"]),
                                });
                            }
                        }
                    }
                }
                foreach (var item in List_DS)
                {
                    item.list_CostsheetMaster = listCostSheetMaster;

                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<CostSheet> tbl = List_DS as IEnumerable<CostSheet>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string GetCostSheetDetails(int projectid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<CostSheet> CostSheetDetails = new List<CostSheet>();
        List<CostSheet> List_DS = new List<CostSheet>();

        int flag = 2;
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@compId", Session["companyid"]);
                param[1] = new SqlParameter("@projectid", projectid);
                param[2] = new SqlParameter("@flag", flag);



                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "GetCostSheetDetails", param)) // Get All details 
                {
                    while (drrr.Read())
                    {
                        List_DS.Add(new CostSheet()
                        {
                            compid = objComm.GetValue<int>(drrr["CompId"].ToString()),

                        });
                    }

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                CostSheetDetails.Add(new CostSheet()
                                {
                                    StartDate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                                    EndDate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                                    ContractValue = objComm.GetValue<double>(drrr["Project_Amount"].ToString()),
                                    HourlyCharges = objComm.GetValue<double>(drrr["HourlyCharges"].ToString()),
                                });
                            }
                        }
                    }

                }
                foreach (var item in List_DS)
                {
                    item.list_CostsheetMaster = CostSheetDetails;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<CostSheet> tbl = List_DS as IEnumerable<CostSheet>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetReport(string sf, string fdt, string tdt, string status, string clt, string prj, string rpt, string dptskjb, string dep)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DataSet ds= null;

        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] parameter = new SqlParameter[9];
                parameter[0] = new SqlParameter("@Compid", Session["companyid"]);
                parameter[1] = new SqlParameter("@staff", sf);
                parameter[2] = new SqlParameter("@from", fdt);
                parameter[3] = new SqlParameter("@end", tdt);
                parameter[4] = new SqlParameter("@statuschk", status);
                parameter[5] = new SqlParameter("@Client", clt);
                parameter[6] = new SqlParameter("@Project", prj);
                if (rpt == "rsummary")
                {
                    parameter[7] = new SqlParameter("@Report", "Summary");
                }
                else
                {
                    parameter[7] = new SqlParameter("@Report", "detailed");
                }
                parameter[8] = new SqlParameter("@depttaskjobids", dep);
                string SP = "";
                if (dptskjb == "dept")
                {
                    SP = "usp_Bootstrap_Project_StaffCosting";
                }
                if (dptskjb == "task")
                {
                    SP = "usp_gettaskwisestaffcosting";
                }
                if (dptskjb == "job")
                {
                    SP = "usp_getjobwisestaffcosting";
                }

                ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, SP, parameter);
      
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
          return ds.GetXml();
    }


}


