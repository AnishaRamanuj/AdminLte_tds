using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CommonLibrary;
using System.Configuration;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Data;

/// <summary>
/// Summary description for AllTimesheetGridBind
/// </summary>
public class AllTimesheetGridBind : CommonFunctions
{
    string con = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
    public AllTimesheetGridBind()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public List<AllTimesheetModel> GetAllTimesheetGrid(AllTimesheetModel obj)
    {
        try
        {
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@companyId", obj.CompID);
            param[1] = new SqlParameter("@PageIndex", obj.PageIndex);
            param[2] = new SqlParameter("@PageSize", obj.PageSize);
            param[3] = new SqlParameter("@cid", obj.CID);
            param[4] = new SqlParameter("@mJid", obj.mJID);
            param[5] = new SqlParameter("@Sid", obj.SID);
            param[6] = new SqlParameter("@Status", obj.Status);
            param[7] = new SqlParameter("@FromTime", obj.FromTime);
            param[8] = new SqlParameter("@ToTime", obj.ToTime);
            SqlDataReader dr = SqlHelper.ExecuteReader(con, CommandType.StoredProcedure, "usp_GetAllTimesheetGrid", param);

            List<AllTimesheetModel> list = new List<AllTimesheetModel>();
            while (dr.Read())
            {
                list.Add(new AllTimesheetModel()
                    {
                        IsApprover = false,
                        TSId = GetValue<int>(dr["TSId"].ToString()),
                        clientName = GetValue<string>(dr["clientName"].ToString()),
                        CLTId = GetValue<string>(dr["CLTId"].ToString()),
                        mJobName = GetValue<string>(dr["mJobName"].ToString()),
                        mJobId = GetValue<string>(dr["mJobId"].ToString()),
                        StaffName = GetValue<string>(dr["StaffName"].ToString()),
                        staffcode = GetValue<string>(dr["staffcode"].ToString()),
                        Date = GetValue<string>(dr["Date"].ToString()),
                        TotalTime = GetValue<string>(dr["TotalTime"].ToString()),
                        OpeAmt = GetValue<string>(dr["OpeAmt"].ToString()),
                        Narration = GetValue<string>(dr["Narration"].ToString()),
                        Status = GetValue<string>(dr["Status"].ToString()),
                        Freezed = GetValue<string>(dr["Freezed"].ToString()),
                        FromTime = GetValue<string>(dr["FromTime"].ToString()),
                        ToTime = GetValue<string>(dr["ToTime"].ToString()),
                        BudHours = GetValue<string>(dr["BudHours"].ToString()),
                        BudAmt = GetValue<string>(dr["BudAmt"].ToString()),
                        LocationName = GetValue<string>(dr["LocationName"].ToString()),
                        TotalCount = GetValue<int>(dr["TotalCount"].ToString()),
                        SrNo = GetValue<int>(dr["SrNo"].ToString()),
                        Reason = GetValue<string>(dr["Reason"].ToString()),
                        Task_Id = GetValue<int>(dr["Task_Id"].ToString()),
                        TaskName = GetValue<string>(dr["TaskName"].ToString()),
                        Taskwise = GetValue<int>(dr["Task_Id"].ToString()),
                    });

            }
          return list;
        }
        catch (Exception ex)
        {
            return null;
        }
    
    }



    public DataSet GetAllTimesheetGrid_Export(AllTimesheetModel obj)
    {
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlParameter[] param = new SqlParameter[7];
        param[0] = new SqlParameter("@companyId", obj.CompID);
        param[1] = new SqlParameter("@cid", obj.CID);
        param[2] = new SqlParameter("@mJid", obj.mJID);
        param[3] = new SqlParameter("@Sid", obj.SID);
        param[4] = new SqlParameter("@Status", obj.Status);
        param[5] = new SqlParameter("@FromTime", obj.FromTime);
        param[6] = new SqlParameter("@ToTime", obj.ToTime);
        return SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "New_GetAllTimesheet_export", param);
    }


    public DataSet GetLastTimesheet(AllTimesheetModel obj)
    {
        DataSet ds = new DataSet();
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter adap = new SqlDataAdapter();
        cmd.Connection = sqlConn;
        cmd.CommandText = "usp_LastTimesheets";
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandTimeout = 999999999;
        cmd.Parameters.AddWithValue("@companyId", obj.CompID);
        cmd.Parameters.AddWithValue("@PageIndex", obj.PageIndex);
        cmd.Parameters.AddWithValue("@PageSize", obj.PageSize);
        cmd.Parameters.AddWithValue("@from_date", obj.fr);
        cmd.Parameters.AddWithValue("@to_date", obj.to);
        cmd.Parameters.AddWithValue("@Sid", obj.SID);
        cmd.Parameters.AddWithValue("@wk", obj.WK);
        adap.SelectCommand = cmd;
        adap.Fill(ds, "attc");

        return ds;
        //return SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_LastTimesheets", param);
    }

    public DataSet GetLastTimesheetTwo(AllTimesheetModel obj)
    {
        DataSet ds = new DataSet();
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter adap = new SqlDataAdapter();
        cmd.Connection = sqlConn;
        cmd.CommandText = "usp_LastTimesheetsTwo";
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandTimeout = 999999999;
        cmd.Parameters.AddWithValue("@companyId", obj.CompID);
        cmd.Parameters.AddWithValue("@PageIndex", obj.PageIndex);
        cmd.Parameters.AddWithValue("@PageSize", obj.PageSize);
        cmd.Parameters.AddWithValue("@from_date", obj.fr);
        cmd.Parameters.AddWithValue("@to_date", obj.to);
        cmd.Parameters.AddWithValue("@Sid", obj.SID);
        cmd.Parameters.AddWithValue("@wk", obj.WK);
        adap.SelectCommand = cmd;
        adap.Fill(ds, "attc");

        return ds;
        //return SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_LastTimesheets", param);
    }
    public DataSet GetLastTimesheet_Export(AllTimesheetModel obj)
    {
        DataSet ds = new DataSet();
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter adap = new SqlDataAdapter();
        cmd.Connection = sqlConn;
        cmd.CommandText = "usp_LastTimesheets_Export";
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandTimeout = 999999999;


        cmd.Parameters.AddWithValue("@companyId", obj.CompID);
        cmd.Parameters.AddWithValue("@from_date", obj.fr);
        cmd.Parameters.AddWithValue("@to_date", obj.to);
        cmd.Parameters.AddWithValue("@Sid", obj.SID);
        cmd.Parameters.AddWithValue("@wk", obj.WK);
        adap.SelectCommand = cmd;
        adap.Fill(ds, "attc");

        return ds;

    }

    public DataSet GetWeekwise_Export(weekwiseReport obj)
    {
        DataSet ds = new DataSet();
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter adap = new SqlDataAdapter();
        cmd.Connection = sqlConn;
        cmd.CommandText = "usp_Weekwise_Report";
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandTimeout = 999999999;


        cmd.Parameters.AddWithValue("@compid", obj.compid);
        cmd.Parameters.AddWithValue("@selectedStaffcode", obj.staffid);
        cmd.Parameters.AddWithValue("@monthdate", obj.mondate);
     
        adap.SelectCommand = cmd;
        adap.Fill(ds, "attc");

        return ds;

    }


    public DataSet GetTimesheet4Hrs(AllTimesheetModel obj)
    {
        DataSet ds = new DataSet();

        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());

        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter adap = new SqlDataAdapter();
        cmd.Connection = sqlConn;
        cmd.CommandText = "usp_Timesheets_NotUpdate4Hrs";
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandTimeout = 999999999;

        cmd.Parameters.AddWithValue("@companyId", obj.CompID);
        cmd.Parameters.AddWithValue("@PageIndex", obj.PageIndex);
        cmd.Parameters.AddWithValue("@PageSize", obj.PageSize);
        cmd.Parameters.AddWithValue("@from_date", obj.fr);
        cmd.Parameters.AddWithValue("@to_date", obj.to);
        cmd.Parameters.AddWithValue("@Sid", obj.SID);
        adap.SelectCommand = cmd;
        adap.Fill(ds, "attc".ToString());

        return ds;
        //return SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_Timesheets_NotUpdate4Hrs", param);
    }


    public DataSet GetTimesheet4Hrs_Export(AllTimesheetModel obj)
    {
        DataSet ds = new DataSet();
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter adap = new SqlDataAdapter();
        cmd.Connection = sqlConn;
        cmd.CommandText = "usp_Timesheets_NotUpdate4Hrs_Export";
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandTimeout = 999999999;

        cmd.Parameters.AddWithValue("@companyId", obj.CompID);
        cmd.Parameters.AddWithValue("@from_date", obj.fr);
        cmd.Parameters.AddWithValue("@to_date", obj.to);
        cmd.Parameters.AddWithValue("@Sid", obj.SID);
        adap.SelectCommand = cmd;
        adap.Fill(ds, "attc");

        return ds;
        //return SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_Timesheets_NotUpdate4Hrs_Export", param);
    }

    public List<AllTimesheetModel> GetAllTimesheetGridStaffWise(AllTimesheetModel obj)
    {
        SqlParameter[] param = new SqlParameter[13];
        param[0] = new SqlParameter("@companyId", obj.CompID);
        param[1] = new SqlParameter("@PageIndex", obj.PageIndex);
        param[2] = new SqlParameter("@PageSize", obj.PageSize);
        param[3] = new SqlParameter("@cid", obj.CID);
        param[4] = new SqlParameter("@mJid", obj.mJID);
        param[5] = new SqlParameter("@Sid", obj.SID);
        param[6] = new SqlParameter("@Status", obj.Status);
        param[7] = new SqlParameter("@FromTime", obj.FromTime);
        param[8] = new SqlParameter("@ToTime", obj.ToTime);
        param[9] = new SqlParameter("@StaffCode", obj.StaffCode);
        param[10] = new SqlParameter("@LoginType", obj.LoginType);
        param[11] = new SqlParameter("@StaffMode", obj.StaffMode);
        param[12] = new SqlParameter("@Hod", obj.Hod);
        SqlDataReader dr = SqlHelper.ExecuteReader(con, CommandType.StoredProcedure, "New_GetAllTimesheetGridStaffWise", param);

        List<AllTimesheetModel> list = new List<AllTimesheetModel>();
        while (dr.Read())
        {
            list.Add(new AllTimesheetModel()
            {
                IsApprover = GetValue<bool>(dr["IsApprover"].ToString()),
                TSId = GetValue<int>(dr["TSId"].ToString()),
                clientName = GetValue<string>(dr["clientName"].ToString()),
                CLTId = GetValue<string>(dr["CLTId"].ToString()),
                mJobName = GetValue<string>(dr["mJobName"].ToString()),
                mJobId = GetValue<string>(dr["mJobId"].ToString()),
                StaffName = GetValue<string>(dr["StaffName"].ToString()),
                staffcode = GetValue<string>(dr["staffcode"].ToString()),
                Date = GetValue<string>(dr["Date"].ToString()),
                TotalTime = GetValue<string>(dr["TotalTime"].ToString()),
                OpeAmt = GetValue<string>(dr["OpeAmt"].ToString()),
                Narration = GetValue<string>(dr["Narration"].ToString()),
                Status = GetValue<string>(dr["Status"].ToString()),
                Freezed = GetValue<string>(dr["Freezed"].ToString()),
                FromTime = GetValue<string>(dr["FromTime"].ToString()),
                ToTime = GetValue<string>(dr["ToTime"].ToString()),
                BudHours = GetValue<string>(dr["BudHours"].ToString()),
                BudAmt = GetValue<string>(dr["BudAmt"].ToString()),
                LocationName = GetValue<string>(dr["LocationName"].ToString()),
                TotalCount = GetValue<int>(dr["TotalCount"].ToString()),
                SrNo = GetValue<int>(dr["SrNo"].ToString()),
                Reason = GetValue<string>(dr["Reason"].ToString()),
                Approver = GetValue<string>(dr["Approver"].ToString()),
                
            });

        }
        return list;

    }


    public DataSet GetAllTimesheet_Staff_Export(AllTimesheetModel obj)
    {
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlParameter[] param = new SqlParameter[9];
        param[0] = new SqlParameter("@companyId", obj.CompID);
        param[1] = new SqlParameter("@cid", obj.CID);
        param[2] = new SqlParameter("@mJid", obj.mJID);
        param[3] = new SqlParameter("@Sid", obj.SID);
        param[4] = new SqlParameter("@Status", obj.Status);
        param[5] = new SqlParameter("@FromTime", obj.FromTime);
        param[6] = new SqlParameter("@ToTime", obj.ToTime);
        param[7] = new SqlParameter("@StaffCode", obj.StaffCode);
        param[8] = new SqlParameter("@LoginType", obj.LoginType);
        //SqlDataReader dr = SqlHelper.ExecuteReader(con, CommandType.StoredProcedure, "New_GetAllTimesheetGridStaffWise", param);
        return SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "New_GetAllTimesheet_Staff_export", param);

    }

    public DataSet GetLeaveDetails(AllTimesheetModel obj)
    {
        SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        SqlParameter[] param = new SqlParameter[2];
        param[0] = new SqlParameter("@companyId", obj.CompID);
        param[1] = new SqlParameter("@sid", obj.SID);
        return SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "New_GetAllTimesheet_Staff_export", param);

    }
}
