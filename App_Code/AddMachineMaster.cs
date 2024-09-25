using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DataAccessLayer;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;

/// <summary>
/// Summary description for AddMachineMaster
/// </summary>
public class AddMachineMaster : Common
{

    public int _CmpnyID { get; set; }
    public int _ClientID { get; set; }
    public int _MachineTypeID { get; set; }
    public string _MachineNumber { get; set; }
    public DateTime _ManuacturingDate { get; set; }
    public DateTime _CommissionDate { get; set; }
    public int _MachineID { get; set; }
    public string _ProblemReported { get; set; }
    public string _AttendedBy { get; set; }
    public string _WorkDone { get; set; }
    public string _ActionTaken { get; set; }
    public string _Results { get; set; }
    public string _CurrentStatus { get; set; }
    public string _SparesReplaced { get; set; }
    public string _Attachment { get; set; }
    public string _Remarks { get; set; }
    public int _BreakDownTypeID { get; set; }
    public int _BreakDownID { get; set; }




    public DataSet BindClientName()
    {
        DataSet ds = new DataSet();
        SqlParameter[] sqlparams = new SqlParameter[1];
        sqlparams[0] = new SqlParameter("@CompID", SqlDbType.Int);
        sqlparams[0].Value = _CmpnyID;
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_BindClientNameForMachinMaster", sqlparams);
        return ds;
    }


    public DataSet BindMachineType()
    {
        DataSet ds = new DataSet();
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_BindMachineTypeForMachineMaster");
        return ds;
    }

    public DataSet BindMachineDetails()
    {
        DataSet ds = new DataSet();
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_BindMachineDetails");
        return ds;
    }

    public int InserIntoMachineMaster()
    {


        SqlParameter[] sqlparams = new SqlParameter[15];
        sqlparams[0] = new SqlParameter("@ClientID", SqlDbType.Int);
        sqlparams[0].Value = _ClientID;
        sqlparams[1] = new SqlParameter("@MachineTypeID", SqlDbType.Int);
        sqlparams[1].Value = _MachineTypeID;
        sqlparams[2] = new SqlParameter("@MachineNumber", SqlDbType.VarChar);
        sqlparams[2].Value = _MachineNumber;
        sqlparams[3] = new SqlParameter("@ManufacturingDate", SqlDbType.DateTime);
        sqlparams[3].Value = _ManuacturingDate;
        sqlparams[4] = new SqlParameter("@CommissionDate", SqlDbType.DateTime);
        sqlparams[4].Value = _CommissionDate;
        int result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_InserIntoMachineMaster", sqlparams);
        return result;
        // return 1;
    }

    public int InserIntoBreakDown()
    {

        SqlParameter[] sqlparams = new SqlParameter[12];
        sqlparams[0] = new SqlParameter("@Date", SqlDbType.DateTime);
        sqlparams[0].Value = _ManuacturingDate;
        sqlparams[1] = new SqlParameter("@ProblemReported", SqlDbType.VarChar);
        sqlparams[1].Value = _ProblemReported;
        sqlparams[2] = new SqlParameter("@AttendedBy", SqlDbType.VarChar);
        sqlparams[2].Value = _AttendedBy;
        sqlparams[3] = new SqlParameter("@WorkDone", SqlDbType.VarChar);
        sqlparams[3].Value = _WorkDone;
        sqlparams[4] = new SqlParameter("@ActionTaken", SqlDbType.VarChar);
        sqlparams[4].Value = _ActionTaken;
        sqlparams[5] = new SqlParameter("@Results", SqlDbType.VarChar);
        sqlparams[5].Value = _Results;
        sqlparams[6] = new SqlParameter("@CurrentStatus", SqlDbType.VarChar);
        sqlparams[6].Value = _CurrentStatus;
        sqlparams[7] = new SqlParameter("@SparesReplaced", SqlDbType.VarChar);
        sqlparams[7].Value = _SparesReplaced;
        sqlparams[8] = new SqlParameter("@Attachment", SqlDbType.VarChar);
        sqlparams[8].Value = _Attachment;
        sqlparams[9] = new SqlParameter("@Remarks", SqlDbType.VarChar);
        sqlparams[9].Value = _Remarks;
        sqlparams[10] = new SqlParameter("@MachineId", SqlDbType.Int);
        sqlparams[10].Value = _MachineID;
        sqlparams[11] = new SqlParameter("@BreakDownTypeID", SqlDbType.Int);
        sqlparams[11].Value = _BreakDownTypeID;
        int result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_InsertMachineBreakDownDetails", sqlparams);
        return result;
        // return 1;
    }

    public int EditIntoBreakDown()
    {

        SqlParameter[] sqlparams = new SqlParameter[13];
        sqlparams[0] = new SqlParameter("@Date", SqlDbType.DateTime);
        sqlparams[0].Value = _ManuacturingDate;
        sqlparams[1] = new SqlParameter("@ProblemReported", SqlDbType.VarChar);
        sqlparams[1].Value = _ProblemReported;
        sqlparams[2] = new SqlParameter("@AttendedBy", SqlDbType.VarChar);
        sqlparams[2].Value = _AttendedBy;
        sqlparams[3] = new SqlParameter("@WorkDone", SqlDbType.VarChar);
        sqlparams[3].Value = _WorkDone;
        sqlparams[4] = new SqlParameter("@ActionTaken", SqlDbType.VarChar);
        sqlparams[4].Value = _ActionTaken;
        sqlparams[5] = new SqlParameter("@Results", SqlDbType.VarChar);
        sqlparams[5].Value = _Results;
        sqlparams[6] = new SqlParameter("@CurrentStatus", SqlDbType.VarChar);
        sqlparams[6].Value = _CurrentStatus;
        sqlparams[7] = new SqlParameter("@SparesReplaced", SqlDbType.VarChar);
        sqlparams[7].Value = _SparesReplaced;
        sqlparams[8] = new SqlParameter("@Attachment", SqlDbType.VarChar);
        sqlparams[8].Value = _Attachment;
        sqlparams[9] = new SqlParameter("@MachineId", SqlDbType.Int);
        sqlparams[9].Value = _MachineID;
        sqlparams[10] = new SqlParameter("@Remarks", SqlDbType.VarChar);
        sqlparams[10].Value = _Remarks;
        sqlparams[11] = new SqlParameter("@BreakDownTypeID", SqlDbType.Int);
        sqlparams[11].Value = _BreakDownTypeID;
        sqlparams[12] = new SqlParameter("@BreakDownID", SqlDbType.Int);
        sqlparams[12].Value = _BreakDownID;
        int result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_EditMachineBreakDownDetails", sqlparams);
        return result;
        // return 1;
    }


    public int EditMachineMaster()
    {


        SqlParameter[] sqlparams = new SqlParameter[15];
        sqlparams[0] = new SqlParameter("@ClientID", SqlDbType.Int);
        sqlparams[0].Value = _ClientID;
        sqlparams[1] = new SqlParameter("@MachineTypeID", SqlDbType.Int);
        sqlparams[1].Value = _MachineTypeID;
        sqlparams[2] = new SqlParameter("@MachineNumber", SqlDbType.VarChar);
        sqlparams[2].Value = _MachineNumber;
        sqlparams[3] = new SqlParameter("@ManufacturingDate", SqlDbType.DateTime);
        sqlparams[3].Value = _ManuacturingDate;
        sqlparams[4] = new SqlParameter("@CommissionDate", SqlDbType.DateTime);
        sqlparams[4].Value = _CommissionDate;
        sqlparams[5] = new SqlParameter("@MachineId", SqlDbType.Int);
        sqlparams[5].Value = _MachineID;
        int result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_EditMachineMaster", sqlparams);
        return result;
        // return 1;
    }
    public int DeleteFromMachineMaster()
    {
        int result = 0;
        try
        {
            SqlParameter[] sqlparams = new SqlParameter[2];
            sqlparams[0] = new SqlParameter("@MachineId", SqlDbType.Int);
            sqlparams[0].Value = _MachineID;
            sqlparams[1] = new SqlParameter("@Result", SqlDbType.Int);
            sqlparams[1].Direction = ParameterDirection.Output;
            SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_DeleteFromMachineMaster", sqlparams);
            result = Convert.ToInt32(sqlparams[1].Value);
            return result;
        }
        catch (Exception ex)
        {
            return result;
        }

    }


    public DataSet GetDetailsForMachine()
    {
        SqlParameter[] sqlparams = new SqlParameter[15];
        sqlparams[0] = new SqlParameter("@MachineId", SqlDbType.Int);
        sqlparams[0].Value = _MachineID;
        DataSet ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_GetDetailsForMachine", sqlparams);
        return ds;
    }

    public DataSet BindBreakDownDetails()
    {
        SqlParameter[] sqlparams = new SqlParameter[15];
        sqlparams[0] = new SqlParameter("@MachineID", SqlDbType.Int);
        sqlparams[0].Value = _MachineID;
        DataSet ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_BindBreakDownDetails", sqlparams);
        return ds;
    }


    public DataSet GetBreakDownDetails()
    {
        SqlParameter[] sqlparams = new SqlParameter[15];
        sqlparams[0] = new SqlParameter("@BreakDownID", SqlDbType.Int);
        sqlparams[0].Value = _BreakDownID;
        DataSet ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_getBreakDownDetails", sqlparams);
        return ds;
    }

    public int DeleteIntoBreakDown()
    {


        SqlParameter[] sqlparams = new SqlParameter[15];
        sqlparams[0] = new SqlParameter("@MachineId", SqlDbType.Int);
        sqlparams[0].Value = _MachineID;
        int result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_DeleteMachineBreakDownDetails", sqlparams);
        return result;

    }
}