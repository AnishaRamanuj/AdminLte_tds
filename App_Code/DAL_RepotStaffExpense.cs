using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CommonLibrary;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Data;
using System.Globalization;

/// <summary>
/// Summary description for DAL_RepotStaffExpense
/// </summary>
public class DAL_RepotStaffExpense : CommonLibrary.CommonFunctions
{
    public DAL_RepotStaffExpense()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public List<Expenses> DAL_GetExpenseNames(int compid)
    {
        List<Expenses> tblEx = new List<Expenses>();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(_cnnString, CommandType.StoredProcedure, "usp_GetExpenseNames", param))
            {
                while (drrr.Read())
                {
                    tblEx.Add(new Expenses()
                    {
                        ExpenseName = GetValue<string>(drrr["OPEName"].ToString()),
                        ExpenseId = GetValue<int>(drrr["OpeId"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return tblEx;
    }

    public List<tbl_StaffMaster> DAL_GetExpenseStaff(int Compid, int staffcode, string userType, string status, string StartDate, string Endate)
    {
        CultureInfo info = new CultureInfo("en-GB");
        List<tbl_StaffMaster> tbl = new List<tbl_StaffMaster>();
        try
        {
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@userType", userType);
            param[3] = new SqlParameter("@status", status);
            param[4] = new SqlParameter("@StartDate", Convert.ToDateTime(StartDate, info).ToString());
            param[5] = new SqlParameter("@Endate", Convert.ToDateTime(Endate, info).ToString());
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(_cnnString, CommandType.StoredProcedure, "usp_GetExpenseStaff", param))
            {
                while (drrr.Read())
                {
                    tbl.Add(new tbl_StaffMaster()
                    {
                        StaffName = GetValue<string>(drrr["StaffName"].ToString()),
                        StaffCode = GetValue<int>(drrr["StaffCode"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return tbl;
    }

    public List<Expenses> DAL_GetSaffWiseExpensesdetails(int Compid, string timesheetStaus, string StaffIDs)
    {
        List<Expenses> tbl = new List<Expenses>();
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@timesheetStaus", timesheetStaus);
            param[2] = new SqlParameter("@StaffIDs", StaffIDs);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(_cnnString, CommandType.StoredProcedure, "usp_GetSaffWiseExpensesdetails", param))
            {
                while (drrr.Read())
                {
                    tbl.Add(new Expenses()
                    {
                        StaffCode = GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = GetValue<string>(drrr["StaffName"].ToString()),
                        ExpenseNarr = GetValue<string>(drrr["ExpNarration"].ToString()),
                        EAmt = GetValue<float>(drrr["Amt"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return tbl;
    }
}