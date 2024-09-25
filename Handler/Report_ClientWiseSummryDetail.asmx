<%@ WebService Language="C#" Class="Report_ClientWiseSummryDetail" %>

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
using System.Web.Script.Services;
using System.Linq;
using JTMSProject;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Report_ClientWiseSummryDetail  : System.Web.Services.WebService {

    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

    public Report_ClientWiseSummryDetail()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }


    //[WebMethod]
    //public string SetClientGroupDropdown(int compid, DateTime FromDAte, DateTime ToDate)
    //{
    //    List<tbl_Client_Group_DDL> list_tbl_Client_Group_DDL = new List<tbl_Client_Group_DDL>();

    //    try
    //    {
    //        Common ob = new Common();
    //        SqlParameter[] param = new SqlParameter[3];
    //        param[0] = new SqlParameter("@compid", compid);
    //        param[1] = new SqlParameter("@from", FromDAte);
    //        param[2] = new SqlParameter("@end", ToDate);
    //        DataSet ds = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Report_ClientWise_Summary_Details", param);

    //        if (ds != null)
    //        {
    //            if (ds.Tables[0].Rows.Count > 0)
    //            {
    //                foreach (DataRow dtrow in ds.Tables[0].Rows)
    //                {
    //                    tbl_Client_Group_DDL user = new tbl_Client_Group_DDL();
    //                    user.CTGID = objComm.GetValue<int>(dtrow["CTGID"].ToString());
    //                    user.ClientGroupName = dtrow["ClientGroupName"].ToString();
    //                    list_tbl_Client_Group_DDL.Add(user);
    //                }
    //            }

    //            //if (ds.Tables[1].Rows.Count > 0)
    //            //{

    //            //    foreach (DataRow dtrow in ds.Tables[1].Rows)
    //            //    {
    //            //        tbl_Client_DDL user = new tbl_Client_DDL();
    //            //        user.Cltid = objComm.GetValue<int>(dtrow["Cltid"].ToString());
    //            //        user.CtgID = objComm.GetValue<int>(dtrow["CtgID"].ToString());
    //            //        user.ClientName = dtrow["ClientName"].ToString();
    //            //        list_tbl_Client_DDL.Add(user);
    //            //    }
    //            //}


    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //    IEnumerable<tbl_Client_Group_DDL> tbl = list_tbl_Client_Group_DDL as IEnumerable<tbl_Client_Group_DDL>;
    //    var obbbbb = tbl;
    //    return new JavaScriptSerializer().Serialize(tbl);
    //}

    //[WebMethod]
    //public string SetClientDropdown(int compid, string ClientID, DateTime FromDAte, DateTime ToDate)
    //{
    //    List<tbl_Client_DDL> list_tbl_Client_DDL = new List<tbl_Client_DDL>();

    //    try
    //    {
    //        Common ob = new Common();
    //        SqlParameter[] param = new SqlParameter[4];
    //        param[0] = new SqlParameter("@compid", compid);
    //        param[1] = new SqlParameter("@clientid", ClientID.Remove(ClientID.LastIndexOf(","), 1));
    //        param[2] = new SqlParameter("@from", FromDAte);
    //        param[3] = new SqlParameter("@end", ToDate);
    //        DataSet ds = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetClientByGroup", param);

    //        if (ds != null)
    //        {
    //            if (ds.Tables[0].Rows.Count > 0)
    //            {

    //                foreach (DataRow dtrow in ds.Tables[0].Rows)
    //                {
    //                    tbl_Client_DDL user = new tbl_Client_DDL();
    //                    user.Cltid = objComm.GetValue<int>(dtrow["Cltid"].ToString());
    //                    user.CtgID = objComm.GetValue<int>(dtrow["CtgID"].ToString());
    //                    user.ClientName = dtrow["ClientName"].ToString();
    //                    list_tbl_Client_DDL.Add(user);
    //                }
    //            }
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //    IEnumerable<tbl_Client_DDL> tbl = list_tbl_Client_DDL as IEnumerable<tbl_Client_DDL>;
    //    var obbbbb = tbl;
    //    return new JavaScriptSerializer().Serialize(tbl);
    //}

    //[WebMethod]
    //public string GetClientSummaryreport(int compid, DateTime FromDAte, DateTime ToDate, string staff)
    //{
    //    List<tbl_Client_Summary> list_tbl_Client_Summary = new List<tbl_Client_Summary>();

    //    try
    //    {
    //        Common ob = new Common();
    //        SqlParameter[] param = new SqlParameter[5];
    //        param[0] = new SqlParameter("@compid", compid);
    //        param[1] = new SqlParameter("@from", FromDAte);
    //        param[2] = new SqlParameter("@end", ToDate);
    //        param[3] = new SqlParameter("@staff", staff.TrimEnd(','));
    //        param[4] = new SqlParameter("@Report", "Summary");

    //        DataSet ds = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Report_Clients_with_JobName", param);

    //        if (ds != null)
    //        {
    //            if (ds.Tables[0].Rows.Count > 0)
    //            {

    //                foreach (DataRow dtrow in ds.Tables[0].Rows)
    //                {
    //                    tbl_Client_Summary user = new tbl_Client_Summary();
    //                    //user.CompanyName =  dtrow["CompanyName"].ToString();
    //                    user.Period = "Period : " + FromDAte.ToString("dd/MM/yyyy").Trim() + " to " + ToDate.ToString("dd/MM/yyyy").Trim();
    //                    user.ReportName = "Client Wise Department Wise Report Summarized";
    //                    //user.PrintedBy = "PrintedBy : " + Convert.ToString(Session["Name"]).Trim();
    //                    user.cgmaster = dtrow["ClientGroupName"].ToString();
    //                    user.clientnamemaster = dtrow["ClientName"].ToString();
    //                    user.jobnamemaster = dtrow["jobname"].ToString();
    //                    user.deptmaster = dtrow["DepartmentName"].ToString();
    //                    user.desgmaster = dtrow["Designation"].ToString();
    //                    user.staffnamemaster = dtrow["StaffName"].ToString();
    //                    user.Expensemaster = dtrow["Charges"].ToString();
    //                    user.chargeopemaster = dtrow["ChargesOPE"].ToString();
    //                    list_tbl_Client_Summary.Add(user);
    //                }
    //            }
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //    IEnumerable<tbl_Client_Summary> tbl = list_tbl_Client_Summary as IEnumerable<tbl_Client_Summary>;
    //    var obbbbb = tbl;
    //    return new JavaScriptSerializer().Serialize(tbl);
    //}

    //[WebMethod]
    //public string GetClientDetailreport(int compid, DateTime FromDAte, DateTime ToDate, string staff)
    //{
    //    List<tbl_Client_Summary> list_tbl_Client_Summary = new List<tbl_Client_Summary>();

    //    try
    //    {
    //        Common ob = new Common();
    //        SqlParameter[] param = new SqlParameter[5];
    //        param[0] = new SqlParameter("@compid", compid);
    //        param[1] = new SqlParameter("@from", FromDAte);
    //        param[2] = new SqlParameter("@end", ToDate);
    //        param[3] = new SqlParameter("@staff", staff.TrimEnd(','));
    //        param[4] = new SqlParameter("@Report", "Details");

    //        DataSet ds = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Report_Clients_with_JobName_Narration", param);

    //        if (ds != null)
    //        {
    //            if (ds.Tables[0].Rows.Count > 0)
    //            {

    //                foreach (DataRow dtrow in ds.Tables[0].Rows)
    //                {
    //                    tbl_Client_Summary user = new tbl_Client_Summary();
    //                    //user.CompanyName =  dtrow["CompanyName"].ToString();
    //                    user.Period = "Period : " + FromDAte.ToString("dd/MM/yyyy").Trim() + " to " + ToDate.ToString("dd/MM/yyyy").Trim();
    //                    user.ReportName = "Client Wise Department Wise Report Summarized";
    //                    //user.PrintedBy = "PrintedBy : " + Convert.ToString(Session["Name"]).Trim();
    //                    user.cgmaster = dtrow["ClientGroupName"].ToString();
    //                    user.clientnamemaster = dtrow["ClientName"].ToString();
    //                    user.jobnamemaster = dtrow["jobname"].ToString();
    //                    user.deptmaster = dtrow["DepartmentName"].ToString();
    //                    user.desgmaster = dtrow["Designation"].ToString();
    //                    user.staffnamemaster = dtrow["StaffName"].ToString();
    //                    user.Expensemaster = dtrow["Charges"].ToString();
    //                    user.chargeopemaster = dtrow["ChargesOPE"].ToString();
    //                    user.Narration = dtrow["Narration"].ToString();
    //                    list_tbl_Client_Summary.Add(user);
    //                }
    //            }
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //    IEnumerable<tbl_Client_Summary> tbl = list_tbl_Client_Summary as IEnumerable<tbl_Client_Summary>;
    //    var obbbbb = tbl;
    //    return new JavaScriptSerializer().Serialize(tbl);
    //}

}