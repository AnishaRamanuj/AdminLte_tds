using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Configuration;
using iTextSharp.text;
using iTextSharp.text.html.simpleparser;
using iTextSharp.text.pdf;
using Microsoft.ApplicationBlocks1.Data;

/// <summary>
/// Summary description for Data
/// </summary>
public class Data
{
    string _ConnectionString = WebConfigurationManager.ConnectionStrings["ConnectionString"].ToString();
    public Data()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public DataSet GetDataClientDetail()
    {
        SqlParameter[] sqlParams = new SqlParameter[12];
        sqlParams[0] = new SqlParameter("@Q1", @"SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='136' and t.cltid In (5,2,4,287,928,1) and j.mjobid in (71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) and t.staffcode in (8,4,260,282,2,66,3,1,7,6,280,274,5,129) and t.Status='Approved' ");
        sqlParams[1] = new SqlParameter("@comp", @"136");
        sqlParams[2] = new SqlParameter("@ST", @"2011-01-04");
        sqlParams[3] = new SqlParameter("@ED", @"2013-09-28");
        sqlParams[4] = new SqlParameter("@ID1", @"5,2,4,287,928,1");
        sqlParams[5] = new SqlParameter("@ID2", @"71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364");
        sqlParams[6] = new SqlParameter("@ID3", @"8,4,260,282,2,66,3,1,7,6,280,274,5,129");
        sqlParams[7] = new SqlParameter("@ID4", @"clientid");
        sqlParams[8] = new SqlParameter("@ID5", @"jobid");
        sqlParams[9] = new SqlParameter("@ID6", @"staffid");
        sqlParams[10] = new SqlParameter("@Rpt", @"clientdetail");
        sqlParams[11] = new SqlParameter("@UsrName", @"Adm");
        SqlHelper.ExecuteNonQuery(_ConnectionString, "SP_3Loops", sqlParams);
        return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT * FROM [Vw_Clientdetail] WHERE RptName = 'clientdetail' AND Usr = 'Adm' AND Compid = 136 ORDER BY SrNo");
        //return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT * FROM [Vw_Clientdetail] ORDER BY Srno");
    }

    public DataSet GetDataStaffSingle()
    {
        SqlParameter[] sqlParams = new SqlParameter[10];
        sqlParams[0] = new SqlParameter("@Q1", @"SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='136'  and t.staffcode in (8,4,260,282,2,66,3,1,7,6,280,274,5,413,129)and j.mJobId in (2,3,4,5,6,7,8,9,10,11,12,13,15,17,18,19,20,21,22,25,34,35,59,78,84,85,163,177,364,1746,1747,1752,1858,1890,1937) and t.Status='Approved'");
        sqlParams[1] = new SqlParameter("@compid", @"136");
        sqlParams[2] = new SqlParameter("@from_date", @"2012-01-04");
        sqlParams[3] = new SqlParameter("@to_date", @"2013-09-28");
        sqlParams[4] = new SqlParameter("@Id1", @"8,4,260,282,2,66,3,1,7,6,280,274,5,413,129");
        sqlParams[5] = new SqlParameter("@Id2", @"2,3,4,5,6,7,8,9,10,11,12,13,15,17,18,19,20,21,22,25,34,35,59,78,84,85,163,177,364,1746,1747,1752,1858,1890,1937");
        sqlParams[6] = new SqlParameter("@ID3", @"staffid");
        sqlParams[7] = new SqlParameter("@ID4", @"jobid");
        sqlParams[8] = new SqlParameter("@Rpt", @"JobwiseSummary");
        sqlParams[9] = new SqlParameter("@UsrName", @"Adm");
        SqlHelper.ExecuteNonQuery(_ConnectionString, "Sp_2Loops", sqlParams);
        return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "select * from vw_2loopsstaffsummary where CompId='136' and Usr in ('Adm') and RptName='JobwiseSummary'");
        //return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT * FROM [Vw_Clientdetail] ORDER BY Srno");
    }

    public DataSet GetDataColumnarDetail()
    {
        DataSet dsReportData = new DataSet();
        SqlParameter[] sqlParams = new SqlParameter[6];
        sqlParams[0] = new SqlParameter("@st_date", @"08/01/2013");
        sqlParams[1] = new SqlParameter("@Ed_date", @"08/31/2013");
        sqlParams[2] = new SqlParameter("@Staff", @"8,4,260,282,2,66,3,1,7,6,280,274,5,413,129");
        sqlParams[3] = new SqlParameter("@Compid", @"136");
        sqlParams[4] = new SqlParameter("@Rpt", @"StaffAllClientsAllJobsHoursConsumed");
        sqlParams[5] = new SqlParameter("@UsrName", @"Adm");
        SqlHelper.ExecuteNonQuery(_ConnectionString, "GetStaffTimeReportNew", sqlParams);

        SqlParameter[] sqlParamProc = new SqlParameter[2];
        sqlParamProc[0] = new SqlParameter("@st", @"Mon");
        sqlParamProc[1] = new SqlParameter("@Count1", @"31");
        dsReportData = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "CreateDateNames", sqlParamProc);
        dsReportData.Tables[0].TableName = "StaffColumnarDates";
        dsReportData.Tables.Add(SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "select * from Stafftimereport where CompId='136' and Usrname ='Adm' and rptName='StaffAllClientsAllJobsHoursConsumed'").Tables[0].Copy());
        dsReportData.Tables[1].TableName = "StaffColumnarReport";
        return dsReportData;
    }

    public DataSet GetDataStaffAttendance(int CompanyID, DateTime StartDate)
    {
        DataSet dsReportData = new DataSet();
        SqlParameter[] sqlParamProc = new SqlParameter[2];
        sqlParamProc[0] = new SqlParameter("@st", @"Mon");
        sqlParamProc[1] = new SqlParameter("@Count1", @"31");
        dsReportData = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.StoredProcedure, "CreateDateNames", sqlParamProc);
        dsReportData.Tables[0].TableName = "StaffAttendanceDates";

        SqlParameter[] sqlParams = new SqlParameter[2];
        sqlParams[0] = new SqlParameter("@compId", SqlDbType.Int);
        sqlParams[0].Value = CompanyID;
        sqlParams[1] = new SqlParameter("@st_date", SqlDbType.DateTime);
        sqlParams[1].Value = StartDate;
        dsReportData.Tables.Add(SqlHelper.ExecuteDataset(_ConnectionString, "GetStaffAttendance", sqlParams).Tables[0].Copy());
        return dsReportData;
    }

    public DataSet GetDataStaffTimesheetSummary(string Query, string CompanyID, DateTime FromDate, DateTime ToDate, string ID1, string ID3, string ReportName, string UserName)
    {
        SqlParameter[] sqlParams = new SqlParameter[8];
        sqlParams[0] = new SqlParameter("@Q1", Query);
        sqlParams[1] = new SqlParameter("@compid", CompanyID);
        sqlParams[2] = new SqlParameter("@from_date", FromDate);
        sqlParams[3] = new SqlParameter("@to_date", ToDate);
        sqlParams[4] = new SqlParameter("@Id1", ID1);
        sqlParams[5] = new SqlParameter("@Id3", ID3);
        sqlParams[6] = new SqlParameter("@Rpt", ReportName);
        sqlParams[7] = new SqlParameter("@UsrName", UserName);
        SqlHelper.ExecuteNonQuery(_ConnectionString, "Sp_1Loops", sqlParams);
        return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "select * from vw_Staffwise_Timesheet_Summary where CompId='" + CompanyID + "' and Usr = 'Adm' and RptName='Staff_Timesheet_Summary'");

    }

    public DataSet GetDataForJobDetails()
    {
        SqlParameter[] sqlParams = new SqlParameter[12];
        sqlParams[0] = new SqlParameter("@Q1", @"SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='136' and t.cltid In (5,2,4,287,928,1) and j.mjobid in (71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) and t.staffcode in (8,4,260,282,2,66,3,1,7,6,280,274,5,129) and t.Status='Approved' ");
        sqlParams[1] = new SqlParameter("@comp", @"136");
        sqlParams[2] = new SqlParameter("@ST", @"2012-01-04");
        sqlParams[3] = new SqlParameter("@ED", @"2013-09-28");
        sqlParams[4] = new SqlParameter("@ID1", @"5,2,4,287,928,1");
        sqlParams[5] = new SqlParameter("@ID2", @"71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364");
        sqlParams[6] = new SqlParameter("@ID3", @"8,4,260,282,2,66,3,1,7,6,280,274,5,129");
        sqlParams[7] = new SqlParameter("@ID4", @"clientid");
        sqlParams[8] = new SqlParameter("@ID5", @"jobid");
        sqlParams[9] = new SqlParameter("@ID6", @"staffid");
        sqlParams[10] = new SqlParameter("@Rpt", @"Jobdetail");
        sqlParams[11] = new SqlParameter("@UsrName", @"Adm");
        SqlHelper.ExecuteNonQuery(_ConnectionString, "SP_3Loops", sqlParams);
        return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT * FROM [Vw_JobDetail] WHERE RptName = 'Jobdetail' AND Usr = 'Adm' AND Compid = 136 ORDER BY MJobName,ClientName,StaffName,Date1");
        //return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT * FROM [Vw_Clientdetail] ORDER BY Srno");

    }

    public DataSet JobList()
    {
        string stftype = "Adm";
        string status1 = "All";
        DataSet ds = new DataSet();
        if (stftype == "App")
        {
            if (status1 == "All")
            {
                ds = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT  * FROM vw_Job_jobList where CompId=136 and MJobId IN (71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) and JobApprover=1");
            }
            else
            {
                ds = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT  * FROM vw_Job_jobList where CompId=136 and MJobId IN (71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) and JobApprover=1 ");
            }
        }
        else if (stftype == "Adm")
        {
            if (status1 == "All")
            {
                ds = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT  * FROM vw_Job_jobList where CompId=136 and MJobId IN(71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) ");
            }
            else
            {
                ds = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT  * FROM vw_Job_jobList where CompId=136 and MJobId IN(71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) ");
            }
        }
        else if (stftype == "Stf")
        {
            if (status1 == "All")
            {
                ds = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT  * FROM vw_Job_jobList where CompId=136 and MJobId IN(71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) and Staffcode=1");
            }
            else
            {
                ds = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT  * FROM vw_Job_jobList where CompId=136 and MJobId IN(71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) and Staffcode=1");
            }
        }

        return ds;
    }

    public DataSet GetStaff_ClientAssignmentReport()
    {
        SqlParameter[] sqlParams = new SqlParameter[12];
        sqlParams[0] = new SqlParameter("@Q1", @"SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='136' and t.cltid In (5,2,4,287,928,1) and j.mjobid in (71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) and t.staffcode in (8,4,260,282,2,66,3,1,7,6,280,274,5,129) and t.Status='Approved' ");
        sqlParams[1] = new SqlParameter("@comp", @"136");
        sqlParams[2] = new SqlParameter("@ST", @"2012-01-04");
        sqlParams[3] = new SqlParameter("@ED", @"2013-09-28");
        sqlParams[4] = new SqlParameter("@ID1", @"5,2,4,287,928,1");
        sqlParams[5] = new SqlParameter("@ID2", @"71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364");
        sqlParams[6] = new SqlParameter("@ID3", @"8,4,260,282,2,66,3,1,7,6,280,274,5,129");
        sqlParams[7] = new SqlParameter("@ID4", @"clientid");
        sqlParams[8] = new SqlParameter("@ID5", @"jobid");
        sqlParams[9] = new SqlParameter("@ID6", @"staffid");
        sqlParams[10] = new SqlParameter("@Rpt", @"Client_Assignment");
        sqlParams[11] = new SqlParameter("@UsrName", @"Adm");
        SqlHelper.ExecuteNonQuery(_ConnectionString, "SP_3Loops", sqlParams);
        return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "select * from vw_Staff_Client_Assignment WHERE RptName = 'Client_Assignment' AND Usr = 'Adm' AND Compid = 136 ORDER BY StaffName,ClientName,MJobName");
        //return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT * FROM [Vw_Clientdetail] ORDER BY Srno");
    }

    public DataSet GetStaffList()
    {
        DataSet ds = new DataSet();
        ds = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT  * FROM vw_StaffList where CompId=136 and Staffcode in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,28,19,21,32,34,45,56,42)");
        return ds;
    }

    public DataSet GetDataForStaffDetails()
    {
        SqlParameter[] sqlParams = new SqlParameter[12];
        sqlParams[0] = new SqlParameter("@Q1", @"SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='136' and t.cltid In (5,2,4,287,928,1) and j.mjobid in (71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) and t.staffcode in (8,4,260,282,2,66,3,1,7,6,280,274,5,129) and t.Status='Approved' ");
        sqlParams[1] = new SqlParameter("@comp", @"136");
        sqlParams[2] = new SqlParameter("@ST", @"2012-01-04");
        sqlParams[3] = new SqlParameter("@ED", @"2013-09-28");
        sqlParams[4] = new SqlParameter("@ID1", @"5,2,4,287,928,1");
        sqlParams[5] = new SqlParameter("@ID2", @"71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364");
        sqlParams[6] = new SqlParameter("@ID3", @"8,4,260,282,2,66,3,1,7,6,280,274,5,129");
        sqlParams[7] = new SqlParameter("@ID4", @"clientid");
        sqlParams[8] = new SqlParameter("@ID5", @"jobid");
        sqlParams[9] = new SqlParameter("@ID6", @"staffid");
        sqlParams[10] = new SqlParameter("@Rpt", @"Staffdetail");
        sqlParams[11] = new SqlParameter("@UsrName", @"Adm");
        SqlHelper.ExecuteNonQuery(_ConnectionString, "SP_3Loops", sqlParams);
        return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "select * from vw_job_clientstaff WHERE RptName = 'Jobdetail' AND Usr = 'Adm' AND Compid = 136 ORDER BY StaffName,ClientName,MJobName,Date1");
        //return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT * FROM [Vw_Clientdetail] ORDER BY Srno");
    }

    public DataSet GetStaffDepartmentList()
    {
        //SqlParameter[] sqlParams = new SqlParameter[12];
        //sqlParams[1] = new SqlParameter("@comp", @"136");
        //SqlHelper.ExecuteNonQuery(_ConnectionString, "SP_3Loops", sqlParams);
        DataSet ds = new DataSet();
        //ds.DataSetName = "AllStaffDeptList";
        //ds.WriteXmlSchema("AppCode/DataSet1.xsd");
        // ds.WriteXml("AppCode/DataSet1.xml");        
        ds = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT  * FROM vw_StaffDepartment_List where CompId=136 and Depid in (159,173,188,189,190,191,192,193,194,195,201,202,204,209,219,220,221,222,223,224,225,226)");
        return ds;
    }

    public DataSet GetStaffProbability()
    {
        DataSet ds = new DataSet();
        //   string sql1 = "SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName  FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.CompId=136 and t.status='Approved' and j.mjobid in (8,4,260,282,2,66,3,1,7,6,280,274,5,129) and t.staffcode in (" + Session["stfid"] + ")";
        SqlParameter[] sqlParams = new SqlParameter[8];
        sqlParams[0] = new SqlParameter("@Q1", @"SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='136' and t.cltid In (5,2,4,287,928,1) and j.mjobid in (71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) and t.staffcode in (8,4,260,282,2,66,3,1,7,6,280,274,5,129) and t.Status='Approved' ");
        sqlParams[1] = new SqlParameter("@compid", @"136");
        sqlParams[2] = new SqlParameter("@from_date", @"2012-01-04");
        sqlParams[3] = new SqlParameter("@to_date", @"2013-09-28");
        // sqlParams[4] = new SqlParameter("@Id1", @"5,2,4,287,928,1");
        sqlParams[4] = new SqlParameter("@Id1", @"8,4,260,282,2,66,3,1,7,6,280,274,5,129");
        // sqlParams[6] = new SqlParameter("@Id3", @"jobid");
        sqlParams[5] = new SqlParameter("@Id3", @"staffid");
        sqlParams[6] = new SqlParameter("@Rpt", @"SatffProfitability");
        sqlParams[7] = new SqlParameter("@UsrName", @"Adm");
        SqlHelper.ExecuteNonQuery(_ConnectionString, "Sp_1Loops", sqlParams);
        return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "select * from vw_StaffProfitability where CompId=136 and Usr in ('Adm') and RptName='SatffProfitability' order by StaffName");
    }

    public DataSet GetStaffExpensesData()
    {
        DataSet ds = new DataSet();
        ds = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT  * FROM vw_StaffAllClientAllExpenses where CompId=136 and StaffCode in(8,4,260,282,2,66,3,1,7,6,280,274,5,413,129)");
        return ds;
    }

    public DataSet GetAllClientJobStaffExpensesData()
    {
        DataSet ds = new DataSet();
        ds = SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "SELECT * FROM vw_Expense_AlljobsAllclientsAllstaffs where CompId=136 and staffcode in (8,4,260,282,2,66,3,1,7,6,280,274,5,413,129) and ope > 0.0 and convert(float,ope) > 0.0 order by Date");
        return ds;
    }

    public DataSet GetStaffAllJobs()
    {
        SqlParameter[] sqlParams = new SqlParameter[10];
        sqlParams[0] = new SqlParameter("@Q1", @"SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='136' and j.mjobid in (71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) and t.staffcode in (8,4,260,282,2,66,3,1,7,6,280,274,5,129) and t.Status='Approved' ");
        sqlParams[1] = new SqlParameter("@comp", @"136");
        sqlParams[2] = new SqlParameter("@from_date", @"2011-01-04");
        sqlParams[3] = new SqlParameter("@to_date", @"2013-09-28");
        sqlParams[4] = new SqlParameter("@ID1", @"8,4,260,282,2,66,3,1,7,6,280,274,5,129");
        sqlParams[5] = new SqlParameter("@ID2", @"71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364");
        sqlParams[6] = new SqlParameter("@ID3", @"Staffid");
        sqlParams[7] = new SqlParameter("@ID4", @"jobid");
        sqlParams[8] = new SqlParameter("@Rpt", @"StaffAllJobs");
        sqlParams[9] = new SqlParameter("@UsrName", @"Adm");
        SqlHelper.ExecuteNonQuery(_ConnectionString, "Sp_2Loops", sqlParams);
        return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "select * from vw_StaffAllJobs WHERE RptName = 'StaffAllJobs' AND Usr = 'Adm' AND Compid = 136 ORDER BY SrNo");
    }

    public DataSet GetStaffAllClientAllJobs()
    {
        SqlParameter[] sqlParams = new SqlParameter[10];
        sqlParams[0] = new SqlParameter("@Q1", @"SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='136' and j.mjobid in (71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) and t.cltid in (5,2,4,287,928,1) and t.Status='Approved' ");
        sqlParams[1] = new SqlParameter("@comp", @"136");
        sqlParams[2] = new SqlParameter("@from_date", @"2011-01-04");
        sqlParams[3] = new SqlParameter("@to_date", @"2013-09-28");
        sqlParams[4] = new SqlParameter("@ID1", @"8,4,260,282,2,66,3,1,7,6,280,274,5,129");
        sqlParams[5] = new SqlParameter("@ID2", @"71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364");
        sqlParams[6] = new SqlParameter("@ID3", @"Clientid");
        sqlParams[7] = new SqlParameter("@ID4", @"jobid");
        sqlParams[8] = new SqlParameter("@Rpt", @"Staff_AllClientAllJobs");
        sqlParams[9] = new SqlParameter("@UsrName", @"Adm");
        SqlHelper.ExecuteNonQuery(_ConnectionString, "Sp_2Loops", sqlParams);
        return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "select * from vw_StaffAllClientAllJobs WHERE RptName = 'Staff_AllClientAllJobs' AND Usr = 'Adm' AND Compid = 136 ORDER BY SrNo");
        // string str1 = "select * from vw_StaffAllClientAllJobs where CompId='" + comp + "' and clientid in (858,797,1,787,785,788,3,4,5,6,8,798,9,860,10,11,799,12,800,801,859,863,795,14,15,16,17,19,20,864,23,789,24,791,25,26,27,865,861,28,29,30,856,31,765,866,32,34,33,867,35,36,37,802,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,853,54,786,55,56,57,58,59,868,60,61,62,63,869,64,803,66,67,804,68,870,69,70,71,72,73,74,75,805,76,77,78,79,80,81) and JobID in (43,39,38,25,33,28,49,21,52,53,19,3,20,29,45,54,48,37,41,44,4,35,26,14,13,5,32,6,50,11,27,30,34,47,15,2,12,46,16,8,7,36,42,23,1,9,10) and Usr ='" + usrtype + "' and rptName='Staff_AllClientAllJobs'";

    }

    public string PrintReport(byte[] Bytes, string FileName1, string FileName2)
    {
        string _BASE_PATH = WebConfigurationManager.AppSettings["PrintBasePath"].ToString();
        string _FileLocation = string.Empty;
        byte[] bytes = Bytes;
        long CurrentDate = DateTime.Now.Ticks;
        FileStream fs = new FileStream(HttpContext.Current.Server.MapPath(_BASE_PATH + FileName1 + "_" + CurrentDate + "_.pdf"),
        FileMode.Create);
        fs.Write(bytes, 0, bytes.Length);
        fs.Close();

        var doc = new Document();
        var reader = new PdfReader(HttpContext.Current.Server.MapPath(_BASE_PATH + FileName1 + "_" + CurrentDate + "_.pdf"));
        _FileLocation = _BASE_PATH + FileName2 + "_" + CurrentDate + "_.pdf";

        using (var memoryStream = new MemoryStream())
        {
            var writer = PdfWriter.GetInstance(doc, memoryStream);
            doc.Open();

            // this action leads directly to printer dialogue
            var jAction = PdfAction.JavaScript("this.print(true);\r", writer);
            writer.AddJavaScript(jAction);

            var cb = writer.DirectContent;
            doc.AddDocListener(writer);

            for (var p = 1; p <= reader.NumberOfPages; p++)
            {
                doc.SetPageSize(reader.GetPageSize(p));
                doc.NewPage();
                var page = writer.GetImportedPage(reader, p);
                var rot = reader.GetPageRotation(p);
                if (rot == 90 || rot == 270)
                    cb.AddTemplate(page, 0, -1.0F, 1.0F, 0, 0, reader.GetPageSizeWithRotation(p).Height);
                else
                    cb.AddTemplate(page, 1.0F, 0, 0, 1.0F, 0, 0);
            }
            doc.Close();
            reader.Close();
            File.WriteAllBytes(HttpContext.Current.Server.MapPath(_FileLocation), memoryStream.ToArray());
        }
        return _FileLocation;
    }


    ////client folder data 



    public DataSet GetSingleAllClientJobWiseSummary()
    {
        SqlParameter[] sqlParams = new SqlParameter[10];
        sqlParams[0] = new SqlParameter("@Q1", @"SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode , j.BudAMt, j.BudHours, t.StaffName, c.ClientName FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid=136 and t.cltid in (5,2,4,287,928,1) and j.mJobID in (71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364)and t.Status='Approved'");
        sqlParams[1] = new SqlParameter("@compid", @"136");
        sqlParams[2] = new SqlParameter("@from_date", @"2011-01-04");
        sqlParams[3] = new SqlParameter("@to_date", @"2013-09-28");
        sqlParams[4] = new SqlParameter("@ID1", @"8,4,260,282,2,66,3,1,7,6,280,274,5,129");
        sqlParams[5] = new SqlParameter("@ID2", @"71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364");
        sqlParams[6] = new SqlParameter("@ID3", @"Clientid");
        sqlParams[7] = new SqlParameter("@ID4", @"jobid");
        sqlParams[8] = new SqlParameter("@Rpt", @"JobwiseTimesheetSummary");
        sqlParams[9] = new SqlParameter("@UsrName", @"Adm");
        SqlHelper.ExecuteNonQuery(_ConnectionString, "Sp_2Loops", sqlParams);
        return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "select * from vw_jobwise_summary where compid =136 and JobId in (71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) and Clientid in (8,4,260,282,2,66,3,1,7,6,280,274,5,129) and rptname='JobwiseTimesheetSummary' and Usr ='Adm'");


    }
    public DataSet AlljobsAllExpenses()
    {
        //SqlParameter[] sqlParams = new SqlParameter[10];
        //sqlP
        //sqlParams[1] = new SqlParameter("@compid", @"136");
        //sqlParams[2] = new SqlParameter("@from_date", @"2011-01-04");
        //sqlParams[3] = new SqlParameter("@to_date", @"2013-09-28");
        //sqlParams[4] = new SqlParameter("@ID1", @"8,4,260,282,2,66,3,1,7,6,280,274,5,129");
        return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, " SELECT  * FROM vw_AlljobsAllExpenses where CompId=136 and CLTId=5 and Date1 between '2011-01-04' and '2013-09-28' and JobApprover= 1  order by Date");
    }
    public DataSet ClientGroupSummaryReport()
    {
        SqlParameter[] sqlParams = new SqlParameter[12];
        sqlParams[0] = new SqlParameter("@Q1", @"SELECT t.TotalTime, t.HourlyCharges, t.OpeAmt, t.Date,  jm.MJobName AS jobname,  t.CLTId, j.mJobID, t.StaffCode,j.BudAMt,j.BudHours, t.StaffName, c.ClientName FROM dbo.TimeSheet_Table AS t INNER JOIN dbo.Job_Master AS j ON t.JobId = j.JobId INNER JOIN dbo.JobName_Master AS jm ON j.mJobID = jm.MJobId INNER JOIN dbo.Client_Master AS c ON t.CLTId = c.CLTId where t.compid='136' and t.cltid In (5,2,4,287,928,1) and j.mjobid in (71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364) and t.staffcode in (8,4,260,282,2,66,3,1,7,6,280,274,5,129) and t.Status='Approved' ");
        sqlParams[1] = new SqlParameter("@comp", @"136");
        sqlParams[2] = new SqlParameter("@from_date", @"2011-01-04");
        sqlParams[3] = new SqlParameter("@to_date", @"2013-09-28");
        sqlParams[4] = new SqlParameter("@ID1", @"5,2,4,287,928,1");
        sqlParams[5] = new SqlParameter("@ID2", @"71,73,74,177,163,2,3,4,59,5,6,7,8,9,10,11,85,12,13,1890,15,1858,25,78,1937,1746,1747,84,1752,16,17,35,18,19,20,21,22,364");
        sqlParams[6] = new SqlParameter("@ID3", @"8,4,260,282,2,66,3,1,7,6,280,274,5,129");
        sqlParams[7] = new SqlParameter("@ID4", @"clientgrpid");
        sqlParams[8] = new SqlParameter("@ID5", @"jobid");
        sqlParams[9] = new SqlParameter("@ID6", @"staffid");
        sqlParams[10] = new SqlParameter("@Rpt", @"Client Group Ret porDetailed");
        sqlParams[11] = new SqlParameter("@UsrName", @"Adm");
        SqlHelper.ExecuteNonQuery(_ConnectionString, "SP_3Loops", sqlParams);
        return SqlHelper.ExecuteDataset(_ConnectionString, CommandType.Text, "select * from vw_ClientGroup_Report_Detail where CompId=136 and Usr ='Adm' and RptName='Client Group Report Detailed'");
    }
}