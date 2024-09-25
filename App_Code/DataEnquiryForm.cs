using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;

/// <summary>
/// Summary description for EnquiryForm
/// </summary>
public class DataEnquiryForm : Common
{



    // public string _EnquiryNumber { get; set; }
    public int _StaffId { get; set; }
    public int _JobId { get; set; }
    public int _ClientId { get; set; }
    public int _MachineTypeId { get; set; }
    public string _MachineNumber { get; set; }
    public int _EnquiryTypeId { get; set; }
    public int _EnquirySourceId { get; set; }
    public int _EnquiryStatusId { get; set; }
    public int _EnquiryId { get; set; }
    public int _CompanyId { get; set; }
    public int _JobGid { get; set; }
    public int _SuperApproverId { get; set; }
    public string _Description { get; set; }
    public string _FilterValue { get; set; }
    public string _FilterColumn { get; set; }
    public bool _IsSearch { get; set; }
    public bool _IsDateFitler { get; set; }
    public DateTime _EnquiryDate { get; set; }
    public string _Fromdate { get; set; }
    public string _Todate { get; set; }
    public DataTable _dtJobId { get; set; }
    public int _EnquiryrefId { get; set; }
    public DataTable _dtJobStaff { get; set; }
    public DataSet BindDropDownData()
    {

        DataSet ds = new DataSet();
        SqlParameter[] sqlparams = new SqlParameter[1];
        sqlparams[0] = new SqlParameter("@CompID", SqlDbType.Int);
        sqlparams[0].Value = _CompanyId;
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_BindDropDownDataForEnquiry", sqlparams);
        return ds;
    }

    public DataSet BindJobName()
    {
        DataSet ds = new DataSet();
        SqlParameter[] sqlparams = new SqlParameter[1];
        sqlparams[0] = new SqlParameter("@EnquiryID", SqlDbType.Int);
        sqlparams[0].Value = _EnquiryId;
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_getJobNames", sqlparams);
        return ds;
    }

    public DataSet BindEqDetails()
    {
        DataSet ds = new DataSet();
        SqlParameter[] sqlparams = new SqlParameter[1];
        sqlparams[0] = new SqlParameter("@EnquiryID", SqlDbType.Int);
        sqlparams[0].Value = _EnquiryId;
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_ViewEnquiryDetails", sqlparams);
        return ds;
    }

    public DataSet BindJobs()
    {

        DataSet ds = new DataSet();
        SqlParameter[] sqlparams = new SqlParameter[2];
        sqlparams[0] = new SqlParameter("@JobGid", SqlDbType.Int);
        sqlparams[0].Value = _JobGid;
        sqlparams[1] = new SqlParameter("@CompID", SqlDbType.Int);
        sqlparams[1].Value = _CompanyId;
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_GetJobName_JobGroup", sqlparams);
        return ds;
    }


    public int CheckOrderGenerate()
    {
        int result = 0;
        SqlParameter[] sqlparams = new SqlParameter[2];
        sqlparams[0] = new SqlParameter("@EnquiryId", SqlDbType.Int);
        sqlparams[0].Value = _EnquiryId;
        sqlparams[1] = new SqlParameter("@result", SqlDbType.Int);
        sqlparams[1].Direction = ParameterDirection.Output;
        SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_CheckOrderGenerate", sqlparams);
        result = Convert.ToInt32(sqlparams[1].Value);
        return result;
    }
    public int InsertEnquiry(DataTable dt)
    {
        SqlParameter[] sqlparams = new SqlParameter[15];
        sqlparams[0] = new SqlParameter("@ClientID", SqlDbType.Int);
        sqlparams[0].Value = _ClientId;
        sqlparams[1] = new SqlParameter("@JobGID", SqlDbType.Int);
        sqlparams[1].Value = _JobGid;
        sqlparams[2] = new SqlParameter("@StaffID", SqlDbType.Int);
        sqlparams[2].Value = _StaffId;
        sqlparams[3] = new SqlParameter("@MachineTypeID", SqlDbType.Int);
        sqlparams[3].Value = _MachineTypeId;
        sqlparams[4] = new SqlParameter("@MachineNumber", SqlDbType.VarChar);
        sqlparams[4].Value = _MachineNumber;
        sqlparams[5] = new SqlParameter("@EnquiryDate", SqlDbType.DateTime);
        sqlparams[5].Value = _EnquiryDate;
        sqlparams[6] = new SqlParameter("@EnquirySourceID", SqlDbType.Int);
        sqlparams[6].Value = _EnquirySourceId;
        sqlparams[7] = new SqlParameter("@EnquiryStatusID", SqlDbType.Int);
        sqlparams[7].Value = _EnquiryStatusId;
        sqlparams[8] = new SqlParameter("@EnquiryTypeID", SqlDbType.Int);
        sqlparams[8].Value = _EnquiryTypeId;
        sqlparams[9] = new SqlParameter("@SuperApprover", SqlDbType.VarChar);
        sqlparams[9].Value = Convert.ToString(_SuperApproverId);
        sqlparams[10] = new SqlParameter("@SubApprover", dt);
        sqlparams[11] = new SqlParameter("@CompanyId", SqlDbType.Int);
        sqlparams[11].Value = _CompanyId;
        sqlparams[12] = new SqlParameter("@Description", SqlDbType.VarChar);
        sqlparams[12].Value = _Description;
        sqlparams[13] = new SqlParameter("@JobID", _dtJobId);
        sqlparams[14] = new SqlParameter("@JobStaff", _dtJobStaff);
        int result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_InsertIntoEnquiry", sqlparams);
        return result;
        // return 1;
    }


    public int EditEnquiry()
    {
        SqlParameter[] sqlparams = new SqlParameter[11];
        sqlparams[0] = new SqlParameter("@ClientID", SqlDbType.Int);
        sqlparams[0].Value = _ClientId;
        sqlparams[1] = new SqlParameter("@JobID", SqlDbType.Int);
        sqlparams[1].Value = _JobId;
        sqlparams[2] = new SqlParameter("@StaffID", SqlDbType.Int);
        sqlparams[2].Value = _StaffId;
        sqlparams[3] = new SqlParameter("@MachineTypeID", SqlDbType.Int);
        sqlparams[3].Value = _MachineTypeId;
        sqlparams[4] = new SqlParameter("@MachineNumber", SqlDbType.VarChar);
        sqlparams[4].Value = _MachineNumber;
        sqlparams[5] = new SqlParameter("@EnquiryDate", SqlDbType.DateTime);
        sqlparams[5].Value = _EnquiryDate;
        sqlparams[6] = new SqlParameter("@EnquirySourceID", SqlDbType.Int);
        sqlparams[6].Value = _EnquirySourceId;
        sqlparams[7] = new SqlParameter("@EnquiryStatusID", SqlDbType.Int);
        sqlparams[7].Value = _EnquiryStatusId;
        sqlparams[8] = new SqlParameter("@EnquiryTypeID", SqlDbType.Int);
        sqlparams[8].Value = _EnquiryTypeId;
        sqlparams[9] = new SqlParameter("@EnquiryID", SqlDbType.Int);
        sqlparams[9].Value = _EnquiryId;
        sqlparams[10] = new SqlParameter("@Description", SqlDbType.VarChar);
        sqlparams[10].Value = _Description;

        int result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_EditEnquiry", sqlparams);
        return result;
        // return 1;
    }

    public DataSet BindEnquiryData()
    {
        try
        {
            DataSet ds = new DataSet();
            SqlParameter[] sqlparams = new SqlParameter[6];
            sqlparams[0] = new SqlParameter("@FilterColumn", _FilterColumn);
            sqlparams[1] = new SqlParameter("@Filtervalue", _FilterValue);
            sqlparams[2] = new SqlParameter("@IsSearch", _IsSearch);
            sqlparams[3] = new SqlParameter("@IsdateFilter", _IsDateFitler);
            sqlparams[4] = new SqlParameter("@FromDate", _Fromdate);
            sqlparams[5] = new SqlParameter("@Todate", _Todate);
            ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_BindEnquiry", sqlparams);
            return ds;
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public int DeleteEnquiry()
    {
        int result = 0;
        SqlParameter[] sqlparams = new SqlParameter[3];
        sqlparams[0] = new SqlParameter("@EnquiryId", _EnquiryId);
        sqlparams[1] = new SqlParameter("@ApproverId", _StaffId);
        sqlparams[2] = new SqlParameter("@result", SqlDbType.Int);
        sqlparams[2].Direction = ParameterDirection.Output;
        SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_DeleteEnquiry", sqlparams);
        result = Convert.ToInt32(sqlparams[2].Value);
        return result;

    }

}