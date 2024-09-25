<%@ WebService Language="C#" Class="Viewer" %>

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
public class Viewer  : System.Web.Services.WebService {

    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod(EnableSession=true)]
    public string GetTeam( int staffcode, string staffrole, string frtime, string totime)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            string fromdate;
            string todate;

            //if (mmdd == 0)
            //{
            fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
            todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
            //}
            //    else
            //{
            //    fromdate = frtime;
            //    todate = totime;
            //}

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@staffrole", staffrole);
            param[3] = new SqlParameter("@fromdate", fromdate);
            param[4] = new SqlParameter("@todate", todate);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_viewer_team", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Bind_Timesheet(string Sts, string staffcode, int sid, string Staffrole, string frtime, string totime, int mmdd) {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DataSet ds;
        try
        {
            string fromdate;
            string todate;

            if (mmdd == 0)
            {
                fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
                todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
            }
            else
            {
                fromdate = frtime;
                todate = totime;
            }

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Sts", Sts);
            param[2] = new SqlParameter("@staffcode", staffcode);
            param[3] = new SqlParameter("@staffrole", Staffrole);
            param[4] = new SqlParameter("@fromdate", fromdate);
            param[5] = new SqlParameter("@todate", todate);
            param[6] = new SqlParameter("@Sid", sid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_bind_Viewer", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();

    }


[WebMethod(EnableSession=true)]
    public string Bind_Expenses(string Sts, string staffcode, int sid, string Staffrole, string frtime, string totime, int mmdd, int expType) {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DataSet ds;
        try
        {
            string fromdate;
            string todate;

            if (mmdd == 0)
            {
                fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
                todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
            }
            else
            {
                fromdate = frtime;
                todate = totime;
            }

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Sts", Sts);
            param[2] = new SqlParameter("@staffcode", staffcode);
            param[3] = new SqlParameter("@staffrole", Staffrole);
            param[4] = new SqlParameter("@fromdate", fromdate);
            param[5] = new SqlParameter("@todate", todate);
            param[6] = new SqlParameter("@Sid", sid);
            param[7] = new SqlParameter("@ExpType", expType);
             

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_bind_ExpenseViewer", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();

    }

    [WebMethod(EnableSession=true)]
    public string Email_Timesheet(string tsid) {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        DataSet ds;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@tsid", tsid);


            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_viewer_Email", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();

    }


    [WebMethod(EnableSession=true)]
    public string Update_Approve_Reject(timesheet_table ts)
    {
        string result = "";
        string procname = "";
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> obj_ts = new List<timesheet_table>();
        try
        {
            if (ts.Satffstatus == "True")
            {
                procname = "usp_Bootstrap_Approver_DualTimesheet_Deptwise";
            }
            else
            {
                procname = "usp_Bootstrap_Approver_Timesheet_Deptwise";
            }
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", ts.JobApprover);
            param[2] = new SqlParameter("@sts", ts.Status);
            param[3] = new SqlParameter("@Tsid", ts.Timesheets);
            param[4] = new SqlParameter("@ApprovedPattern", ts.ApprovedPattern);


            using (SqlDataReader rs = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, procname, param))
            {

                while (rs.Read())
                {
                    obj_ts.Add(new timesheet_table()
                    {
                        TSId = objComm.GetValue<int>(rs["tsid"].ToString()),
                    });
                }
            }
            IEnumerable<timesheet_table> tbl = obj_ts as IEnumerable<timesheet_table>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }

 [WebMethod(EnableSession=true)]
    public string Expense_Approve_Reject(timesheet_table ts)
    {
        string result = "";
        string procname = "";
        CommonFunctions objComm = new CommonFunctions();
        List<timesheet_table> obj_ts = new List<timesheet_table>();
        try
        {
            
                procname = "usp_Bootstrap_Approver_Expenses";
           
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", ts.JobApprover);
            param[2] = new SqlParameter("@sts", ts.Status);
            param[3] = new SqlParameter("@Tsid", ts.Timesheets);
            param[4] = new SqlParameter("@approvedPattern", ts.ApprovedPattern);


            using (SqlDataReader rs = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, procname, param))
            {

                while (rs.Read())
                {
                    obj_ts.Add(new timesheet_table()
                    {
                        TSId = objComm.GetValue<int>(rs["tsid"].ToString()),
                        StaffName = objComm.GetValue<string>(rs["Appr"].ToString()),
                    });
                }
            }
            IEnumerable<timesheet_table> tbl = obj_ts as IEnumerable<timesheet_table>;
            var obbbbb = tbl;
            result = new JavaScriptSerializer().Serialize(tbl);
        }
        catch (Exception ex)
        {
            result = ex.Message;
        }
        return result;
    }


    [WebMethod(EnableSession=true)]
    public string PieGraphViewer(int staffcode, string frdt, string todt, string Staffrole, int sid, string Sts, int mmdd)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tblThumbLogins> listpie = new List<tblThumbLogins>();

        string fromdate;
        string todate;

        if (mmdd == 0)
        {
            fromdate = frdt != "" ? Convert.ToDateTime(frdt, ci).ToString("MM/dd/yyyy") : null;
            todate = todt != "" ? Convert.ToDateTime(todt, ci).ToString("MM/dd/yyyy") : null;
        }
        else
        {
            fromdate = frdt;
            todate = todt;
        }

        //string fromdate = frtime != "" ? Convert.ToDateTime(frtime, ci).ToString("MM/dd/yyyy") : null;
        //string todate = totime != "" ? Convert.ToDateTime(totime, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@fromdt", fromdate);
            param[3] = new SqlParameter("@todt", todate);
            param[4] = new SqlParameter("@staffrole", Staffrole);
            param[5] = new SqlParameter("@sid", sid);
            param[6] = new SqlParameter("@Sts", Sts);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ViewerPie", param))
            {
                while (drrr.Read())
                {
                    listpie.Add(new tblThumbLogins()
                    {
                        status = objComm.GetValue<string>(drrr["status"].ToString()),
                        ttime = objComm.GetValue<string>(drrr["totaltime"].ToString()),

                    });
                }
            }
        }

        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tblThumbLogins> tbl = listpie as IEnumerable<tblThumbLogins>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetExpenseType()
    {
        CommonFunctions objComm = new CommonFunctions();
        DataSet ds;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_Exp_Type", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }
}