using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.ApplicationBlocks1.Data;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

/// <summary>
/// Summary description for System_Dal
/// </summary>
public class System_Dal
{
    public Int32 CompanyID { get; set; }
    string con = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
    //SqlConnection con = new SqlConnection(@"Data Source=.\SQLEXPRESS;Initial Catalog=FlinksterDB;Integrated Security=True");
    public DataSet fillSystem(Systme_Parameters objparam)
    {
        DataSet objfillds = new DataSet();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            {
                param[0] = new SqlParameter("@companyId", SqlDbType.Int);
                param[0].Value = objparam.CompanyID;
                param[1] = new SqlParameter("@StaffID", StaffID);
                objfillds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_FillSystem", param);
            }
        }
        catch (Exception)
        {

            throw;
        }
        return objfillds;
    }


    public DataSet GetaApproverIds(int CompanyID, int JobID, int ClientID)
    {
        DataSet ds = new DataSet();
        SqlParameter[] param = new SqlParameter[10];

        param[0] = new SqlParameter("@compid", CompanyID);
        param[1] = new SqlParameter("@Jobid", JobID);
        param[2] = new SqlParameter("@Client", ClientID);

        ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_GetApprovers", param);
        return ds;
    }


    public DataSet GetaApproverEmailIds(int CompanyID, string AppID)
    {
        DataSet ds = new DataSet();
        SqlParameter[] param = new SqlParameter[10];

        param[0] = new SqlParameter("@compid", CompanyID);
        param[1] = new SqlParameter("@Appid", AppID);


        ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_GetEmails", param);
        return ds;
    }

    public DataSet getLeaveYears(int compid) {
        DataSet ds = new DataSet();
        try {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@Compid", compid);
            ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_get_configuration_Leave_year", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds;
    }
    
    //public int UpdateSystem_dal(Systme_Parameters objparam)
    //{
    //    int objds = 0;
    //    try
    //    {
    //        SqlParameter[] param = new SqlParameter[42];
    //        param[0] = new SqlParameter("@CompanyId", SqlDbType.Int);
    //        param[0].Value = objparam.CompanyID;
    //        param[1] = new SqlParameter("@WeeklyThreshold", SqlDbType.VarChar);
    //        param[1].Value = objparam.WeeklyThreshold;
    //        param[2] = new SqlParameter("@NumberOfDaysRequiresinWeek", SqlDbType.Int);
    //        param[2].Value = objparam.NumberOfDaysRequireInWeek;
    //        param[3] = new SqlParameter("@Dailythreshold", SqlDbType.VarChar);
    //        param[3].Value = objparam.DailyThreshold;
    //        param[4] = new SqlParameter("@FreezeDays", SqlDbType.Int);
    //        param[4].Value = objparam.FreezeDays;
    //        param[5] = new SqlParameter("@mon", SqlDbType.Bit);
    //        param[5].Value = objparam.Monday;
    //        param[6] = new SqlParameter("@tue", SqlDbType.Bit);
    //        param[6].Value = objparam.Tuesday;
    //        param[7] = new SqlParameter("@wed", SqlDbType.Bit);
    //        param[7].Value = objparam.Wednsday;
    //        param[8] = new SqlParameter("@thu", SqlDbType.Bit);
    //        param[8].Value = objparam.Thursday;
    //        param[9] = new SqlParameter("@fri", SqlDbType.Bit);
    //        param[9].Value = objparam.Friday;
    //        param[10] = new SqlParameter("@sat", SqlDbType.Bit);
    //        param[10].Value = objparam.Saturday;
    //        param[11] = new SqlParameter("@sun", SqlDbType.Bit);
    //        param[11].Value = objparam.Sunday;
    //        param[12] = new SqlParameter("@formatA", SqlDbType.Bit);
    //        param[12].Value = objparam.FormatA;
    //        param[13] = new SqlParameter("@formatB", SqlDbType.Bit);
    //        param[13].Value = objparam.FormatB;
    //        param[14] = new SqlParameter("@IsfreezeYes", SqlDbType.Bit);
    //        param[14].Value = objparam.IsFreezeYes;
    //        param[15] = new SqlParameter("@IsfreezeNo", SqlDbType.Bit);
    //        param[15].Value = objparam.IsFreezeNo;
    //        param[16] = new SqlParameter("@IsSubmitted", SqlDbType.Bit);
    //        param[16].Value = objparam.SubmittedMail;
    //        param[17] = new SqlParameter("@Isapproved", SqlDbType.Bit);
    //        param[17].Value = objparam.IsApproved;
    //        param[18] = new SqlParameter("@IsRejected", SqlDbType.Bit);
    //        param[18].Value = objparam.IsRejected;
    //        param[19] = new SqlParameter("@StatementType", SqlDbType.VarChar);
    //        param[19].Value = objparam.Statementtype;
    //        param[20] = new SqlParameter("@Location", SqlDbType.Bit);
    //        param[20].Value = objparam.Loaction;
    //        param[21] = new SqlParameter("@LeaveFormat", SqlDbType.Bit);
    //        param[21].Value = objparam.LeaveFormat;
    //        param[22] = new SqlParameter("@Reasons", SqlDbType.Bit);
    //        param[22].Value = objparam.Reasons;
    //        param[23] = new SqlParameter("@TimesheetApprovedhierarchically", SqlDbType.Bit);
    //        param[23].Value = objparam.TimesheetApprovedhierarchically;
    //        param[24] = new SqlParameter("@Approver_Chrgs", SqlDbType.Bit);
    //        param[24].Value = objparam.Approver_Charges;
    //        param[25] = new SqlParameter("@TopApprover_Chrgs", SqlDbType.Bit);
    //        param[25].Value = objparam.TopApprover_Charges;
    //        param[26] = new SqlParameter("@Staff_Chrgs", SqlDbType.Bit);
    //        param[26].Value = objparam.Staff_Charges;
    //        param[27] = new SqlParameter("@CheckStaffWithThumbPrint", SqlDbType.Bit);
    //        param[27].Value = objparam.CheckStaffWithThumbPrint;
    //        param[28] = new SqlParameter("@compecentryoffloc", SqlDbType.Bit);
    //        param[28].Value = objparam.compecentryoffloc;
    //        param[29] = new SqlParameter("@aprbyHOD", SqlDbType.Bit);
    //        param[29].Value = objparam.chkaprbyHOD;
    //        param[30] = new SqlParameter("@leavewithoutpay", SqlDbType.Bit);
    //        param[30].Value = objparam.chkleavewithoutpay;
    //        param[31] = new SqlParameter("@aprcanedittmst", SqlDbType.Bit);
    //        param[31].Value = objparam.aprcanedittmst;
    //        param[32] = new SqlParameter("@buddetail", SqlDbType.Bit);
    //        param[32].Value = objparam.chkbuddetail;
    //        param[33] = new SqlParameter("@jobdatail", SqlDbType.Bit);
    //        param[33].Value = objparam.chkjobdetail;
    //        param[34] = new SqlParameter("@expmend", SqlDbType.Bit);
    //        param[34].Value = objparam.chkexpence;

    //        param[35] = new SqlParameter("@LeaveYear", SqlDbType.VarChar);
    //        param[35].Value = objparam.Leave_Year;

    //        param[36] = new SqlParameter("@NarrMand", SqlDbType.Bit);
    //        param[36].Value = objparam.chknarr;
    //        param[37] = new SqlParameter("@BillHide", SqlDbType.Bit);
    //        param[37].Value = objparam.ChkBill;
    //        param[38] = new SqlParameter("@MailReminder", SqlDbType.Bit);
    //        param[38].Value = objparam.drpR;
    //        param[39] = new SqlParameter("@MailPartial", SqlDbType.Bit);
    //        param[39].Value = objparam.drpP;
    //        param[40] = new SqlParameter("@PAllocate", SqlDbType.Bit);
    //        param[40].Value = objparam.ChkPAllocate;
    //        param[41] = new SqlParameter("@EditVbill", SqlDbType.Bit);
    //        param[41].Value = objparam.ChkVbill;

    //        objds = SqlHelper.ExecuteNonQuery(con, "usp_UpdateSystem", param);

    //    }
    //    catch (Exception ex)
    //    {

    //        throw;
    //    }
    //    return objds;
    //}

    public DataSet GetPaticularsDetails()
    {
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@CompanyId", CompanyID);
            DataSet ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_GetExpensePrint", param);
            return ds;
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }

    public DataSet GetFormAFormBPermissions()
    {
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@CompanyId", CompanyID);
            DataSet ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_GetFormAFormBPermissions", param);
            return ds;
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }

    public string Day { get; set; }

    public DataSet GetIStrue()
    {
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@CompanyId", CompanyID);
            DataSet ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_GetTrueToday", param);
            return ds;
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }

    public DataSet UnFreezDates()
    {
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@CompanyId", CompanyID);
            param[1] = new SqlParameter("@StaffID", StaffID);
            param[2] = new SqlParameter("@FDate", FDate);
            param[3] = new SqlParameter("@EDate", EDate);
            DataSet ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_GetUnFreezDates", param);
            return ds;
        }
        catch (Exception ex)
        {
            
            throw ex;
        }
    }

    public int StaffID { get; set; }

    public DateTime FDate { get; set; }

    public DateTime EDate { get; set; }
}