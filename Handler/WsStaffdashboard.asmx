<%@ WebService Language="C#" Class="WsStaffdashboard" %>
using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

/// <summary>
/// Summary description for WsStaffdashboard
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
[System.Web.Script.Services.ScriptService]
public class WsStaffdashboard : System.Web.Services.WebService
{

    public static CultureInfo ci = new CultureInfo("en-GB");

    public WsStaffdashboard()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    public class ProjectDetails
    {
        public Object[] Response { get; set; }
    }
    [WebMethod]
    public string bindStaffProjectDetails(string M, string yr, int staffcode, int Compid)
    {
        SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        ProjectDetails objProjectDetails = new ProjectDetails();
        objProjectDetails.Response = new Object[1];
        List<StaffProjectDetails> details = new List<StaffProjectDetails>();
        List<StaffProjectSummary> details1 = new List<StaffProjectSummary>();
        Result results = new Result();
        List<Result> objresults = new List<Result>();

        StaffProjectSummary staff = new StaffProjectSummary();
        //SqlConnection sqlConn = new SqlConnection(sqlConnrings["ConnectionString"].ToString());
        DataSet ds = new DataSet();
        try

        {
            sqlConn.Open();

            SqlParameter[] sqlParams = new SqlParameter[4];
            sqlParams[0] = new SqlParameter("@Month", M);
            //sqlParams[0].Value = M;
            sqlParams[1] = new SqlParameter("@year", yr);
            //sqlParams[1].Value = yr;
            sqlParams[2] = new SqlParameter("@staffcode", staffcode);
            sqlParams[3] = new SqlParameter("@compid", Compid);
            //sqlParams[2].Value = staffcode;

            ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_Getstaffprojectdetails", sqlParams);
            if (ds.Tables[0].Rows.Count > 0)
            {
                DataTable dt = ds.Tables[0];
                DataTable dt1 = ds.Tables[1];
                DataTable dt2 = ds.Tables[2];

                foreach (DataRow dr in dt.Rows)
                {

                    StaffProjectDetails staff1 = new StaffProjectDetails();
                    staff1.ProjectName = dr["ProjectName"].ToString();
                    //staff1.Approver = dr["Approver"].ToString();
                    staff1.ProjectStartDate = dr["ProjectStartDate"].ToString();
                    staff1.ProjectEndDate = dr["ProjectEndDate"].ToString();
                    staff1.TotalTime = dr["TotalTime"].ToString();
                    details.Add(staff1);

                }
                foreach (DataRow dr in dt1.Rows)
                {
                    staff.TotalProject = dr["Total Project"].ToString();
                    staff.TotalHours = dr["Total Hours"].ToString();

                }
                foreach (DataRow dr in dt2.Rows)
                {

                    staff.BillableHours = dr["Billable Hours"].ToString();
                    staff.BillableAmount = dr["Billable Amount"].ToString();


                }



            }
            else
            {

            }



        }
        catch (Exception ex)
        {
            throw ex;
        }
        //    details1.Add(staff);
        results.spd = details;
        results.sps = staff;
        objresults.Add(results);
        var ResponseText = new
        {
            spd = results.spd,
            sps = results.sps

        };
        objProjectDetails.Response[0] = ResponseText;
        string returndata = JsonConvert.SerializeObject(objProjectDetails);

        //IEnumerable<Result> tbl = objresults as IEnumerable<Result>;
        // var a = JsonConvert.SerializeObject(results);
        //var a = new JavaScriptSerializer().Serialize(tbl);

        return returndata;
    }


    public class Result
    {

        public List<StaffProjectDetails> spd { get; set; }
        public StaffProjectSummary sps { get; set; }
    }

    public class StaffProjectDetails
    {
        public string ProjectName { get; set; }
        public string Approver { get; set; }
        public string ProjectStartDate { get; set; }
        public string ProjectEndDate { get; set; }
        public string TotalTime { get; set; }


    }
    public class StaffProjectSummary
    {

        public string TotalProject { get; set; }
        public string TotalHours { get; set; }
        public string BillableAmount { get; set; }
        public string BillableHours { get; set; }
    }
}
