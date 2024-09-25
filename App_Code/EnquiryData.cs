using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Data;
using DataAccessLayer;

/// <summary>
/// Summary description for EnquiryData
/// </summary>
public class EnquiryData : Common
{
    public string _EnquiryType { get; set; }
    public int _EnquiryTypeId { get; set; }
    public int _CreatedBy { get; set; }
    public int _InsertUpdateFlag { get; set; }
    public int _EnquirySourceId { get; set; }
    public string _EnquirySource { get; set; }

    public int _EnquiryStatusId { get; set; }
    public string _EnquiryStatus { get; set; }

    public string _MachineType { get; set; }
    public int _MachineTypeId { get; set; }


    public int InsertUpdateEnquiryType()
    {
        SqlParameter[] sqlparams = new SqlParameter[5];

        sqlparams[0] = new SqlParameter("@EnquiryType", SqlDbType.VarChar);
        sqlparams[0].Value = _EnquiryType;
        sqlparams[1] = new SqlParameter("@CreatedBy", SqlDbType.Int);
        sqlparams[1].Value = _CreatedBy;
        sqlparams[2] = new SqlParameter("@InsertUpdateFlag", SqlDbType.Int);
        sqlparams[2].Value = _InsertUpdateFlag;
        sqlparams[3] = new SqlParameter("@EnquiryTypeID", SqlDbType.Int);
        sqlparams[3].Value = _EnquiryTypeId;
        sqlparams[4] = new SqlParameter("@result", SqlDbType.Int);
        sqlparams[4].Value = ParameterDirection.Output;
        int result = Convert.ToInt32(SqlHelper.ExecuteScalar(_cnnString, CommandType.StoredProcedure, "usp_InsertUpdateEnquiryType", sqlparams));
        return result;

        // return 1;
    }

    public DataSet BindEnquiryType()
    {
        DataSet ds = new DataSet();
        SqlParameter[] sqlparams = new SqlParameter[3];
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_BindEnquiryType", sqlparams);
        return ds;
    }

    public int DeleteEnquiryType()
    {
        int result = 0;
        SqlParameter[] sqlparams = new SqlParameter[5];

        sqlparams[0] = new SqlParameter("@EnquiryTypeID", _EnquiryTypeId);
        result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_DeleteEnquiryType", sqlparams);
        return result;

    }

    public DataSet GetEnquiryTypeForSearch(string searchvalue)
    {
        DataSet ds = new DataSet();
        SqlParameter[] sqlparams = new SqlParameter[1];
        sqlparams[0] = new SqlParameter("@SearchValue", searchvalue);
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_GetSearchEnquiryType", sqlparams);
        return ds;
    }


    public int InsertUpdateEnquirySource()
    {
        SqlParameter[] sqlparams = new SqlParameter[5];

        sqlparams[0] = new SqlParameter("@EnquirySource", SqlDbType.VarChar);
        sqlparams[0].Value = _EnquirySource;
        sqlparams[1] = new SqlParameter("@CreatedBy", SqlDbType.Int);
        sqlparams[1].Value = _CreatedBy;
        sqlparams[2] = new SqlParameter("@InsertUpdateFlag", SqlDbType.Int);
        sqlparams[2].Value = _InsertUpdateFlag;
        sqlparams[3] = new SqlParameter("@EnquirySourceID", SqlDbType.Int);
        sqlparams[3].Value = _EnquirySourceId;
        sqlparams[4] = new SqlParameter("@result", SqlDbType.Int);
        sqlparams[4].Value = ParameterDirection.Output;
        int result = Convert.ToInt32(SqlHelper.ExecuteScalar(_cnnString, CommandType.StoredProcedure, "usp_InsertUpdateEnquirySource", sqlparams));
        return result;

        // return 1;
    }

    public DataSet BindEnquirySource()
    {
        DataSet ds = new DataSet();
        SqlParameter[] sqlparams = new SqlParameter[3];
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_BindEnquirySource", sqlparams);
        return ds;
    }

    public int DeleteEnquirySource()
    {
        int result = 0;
        SqlParameter[] sqlparams = new SqlParameter[5];

        sqlparams[0] = new SqlParameter("@EnquirySourceID", _EnquirySourceId);
        result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_DeleteEnquirySource", sqlparams);
        return result;

    }

    public DataSet GetEnquirySourceForSearch(string searchvalue)
    {
        DataSet ds = new DataSet();
        SqlParameter[] sqlparams = new SqlParameter[1];
        sqlparams[0] = new SqlParameter("@SearchValue", searchvalue);
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_GetSearchEnquirySource", sqlparams);
        return ds;
    }




    public int InsertUpdateEnquiryStatus()
    {
        SqlParameter[] sqlparams = new SqlParameter[5];

        sqlparams[0] = new SqlParameter("@EnquiryStatus", SqlDbType.VarChar);
        sqlparams[0].Value = _EnquiryStatus;
        sqlparams[1] = new SqlParameter("@CreatedBy", SqlDbType.Int);
        sqlparams[1].Value = _CreatedBy;
        sqlparams[2] = new SqlParameter("@InsertUpdateFlag", SqlDbType.Int);
        sqlparams[2].Value = _InsertUpdateFlag;
        sqlparams[3] = new SqlParameter("@EnquiryStatusID", SqlDbType.Int);
        sqlparams[3].Value = _EnquiryStatusId;
        sqlparams[4] = new SqlParameter("@result", SqlDbType.Int);
        sqlparams[4].Value = ParameterDirection.Output;
        int result = Convert.ToInt32(SqlHelper.ExecuteScalar(_cnnString, CommandType.StoredProcedure, "usp_InsertUpdateEnquiryStatus", sqlparams));
        return result;

        // return 1;
    }

    public DataSet BindEnquiryStatus()
    {
        DataSet ds = new DataSet();
        SqlParameter[] sqlparams = new SqlParameter[3];
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_BindEnquiryStatus", sqlparams);
        return ds;
    }

    public int DeleteEnquiryStatus()
    {
        int result = 0;
        SqlParameter[] sqlparams = new SqlParameter[5];

        sqlparams[0] = new SqlParameter("@EnquiryStatusID", _EnquiryStatusId);
        result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_DeleteEnquiryStatus", sqlparams);
        return result;

    }

    public DataSet GetEnquiryStatusForSearch(string searchvalue)
    {
        DataSet ds = new DataSet();
        SqlParameter[] sqlparams = new SqlParameter[1];
        sqlparams[0] = new SqlParameter("@SearchValue", searchvalue);
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_GetSearchEnquiryStatus", sqlparams);
        return ds;
    }







    public int InsertUpdateMachineType()
    {
        SqlParameter[] sqlparams = new SqlParameter[5];

        sqlparams[0] = new SqlParameter("@MachineType", SqlDbType.VarChar);
        sqlparams[0].Value = _MachineType;
        sqlparams[1] = new SqlParameter("@CreatedBy", SqlDbType.Int);
        sqlparams[1].Value = _CreatedBy;
        sqlparams[2] = new SqlParameter("@InsertUpdateFlag", SqlDbType.Int);
        sqlparams[2].Value = _InsertUpdateFlag;
        sqlparams[3] = new SqlParameter("@MachineTypeID", SqlDbType.Int);
        sqlparams[3].Value = _MachineTypeId;
        sqlparams[4] = new SqlParameter("@result", SqlDbType.Int);
        sqlparams[4].Value = ParameterDirection.Output;
        int result = Convert.ToInt32(SqlHelper.ExecuteScalar(_cnnString, CommandType.StoredProcedure, "usp_InsertUpdateMachineType", sqlparams));
        return result;

        // return 1;
    }

    public DataSet BindMachineType()
    {
        DataSet ds = new DataSet();
        SqlParameter[] sqlparams = new SqlParameter[3];
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_BindMachineType", sqlparams);
        return ds;
    }

    public int DeleteMachineType()
    {
        int result = 0;
        SqlParameter[] sqlparams = new SqlParameter[5];

        sqlparams[0] = new SqlParameter("@MachineTypeID", _MachineTypeId);
        result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_DeleteMachineType", sqlparams);
        return result;

    }

    public DataSet GetEnquiryMachineType(string searchvalue)
    {
        DataSet ds = new DataSet();
        SqlParameter[] sqlparams = new SqlParameter[1];
        sqlparams[0] = new SqlParameter("@SearchValue", searchvalue);
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_GetSearchMachineType", sqlparams);
        return ds;
    }

}
