using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using Microsoft.ApplicationBlocks1.Data;
using System.Data.SqlClient;
using System.Configuration;

/// <summary>
/// Summary description for FreezeUnFreeze_Dal
/// </summary>
public class FreezeUnFreeze_Dal
{
    string con = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
    public FreezeUnFreeze_Dal()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public int CompanyID { get; set; }
    public DateTime FDate { get; set; }
    public DateTime EDate { get; set; }
    public string type { get; set; }
    public int StaffId { get; set; }

    public DataSet GetStaffName()
    {
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@CompanyID", CompanyID);
            DataSet ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_GetStaffName", param);
            return ds;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

  

    public DataSet GetStaffUnFreezeDates()
    {
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@CompanyID", CompanyID);
            param[1] = new SqlParameter("@StaffId", StaffId);
            DataSet ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_GetStaffUnFreezeDates", param);
            return ds;
        }
        catch (Exception ex)
        {

            throw ex;
        }
    }

   

    public int SetFreezeUnfreezeStaff()
    {
        try
        {
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@CompanyID", CompanyID);
            param[1] = new SqlParameter("@StaffId", StaffId);
            param[2]=new SqlParameter("@typess",type);
            param[3] = new SqlParameter("@FDate", FDate);
            param[4] = new SqlParameter("@EDate", EDate);
            int result = SqlHelper.ExecuteNonQuery(con, CommandType.StoredProcedure, "usp_SetFreezeUnfreezeStaff", param);
            return result;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

   

}