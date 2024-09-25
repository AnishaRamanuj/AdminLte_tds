using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;

/// <summary>
/// Summary description for GenerateQuotation
/// </summary>
public class GenerateQuotation : Common
{

    public string _QuotationNumber { get; set; }
    public int _QuotationID { get; set; }
    public DateTime _QuotationDate { get; set; }
    public float _QuotationValue { get; set; }
    public int _CreatedBy { get; set; }
    public int _EnquiryId { get; set; }
    public int _OrderId { get; set; }
    public string _Attachment1 { get; set; }
    public string _Attachment2 { get; set; }
    public bool _IsSearch { get; set; }
    public string _Fromdate { get; set; }
    public string _Todate { get; set; }
    public DateTime PODate { get; set; }
    public string PONumber { get; set; }
    public float POValue { get; set; }

    public int GenerateOrderNumber(out string OrderNumber)
    {
        int result = 0;
        try
        {
            OrderNumber = string.Empty;
            SqlParameter[] sqlparams = new SqlParameter[4];
            sqlparams[0] = new SqlParameter("@QuotationId", _QuotationID);
            sqlparams[1] = new SqlParameter("@CreatedBy", _CreatedBy);
            sqlparams[2] = new SqlParameter("@result", SqlDbType.Int);
            sqlparams[2].Direction = ParameterDirection.Output;
            sqlparams[3] = new SqlParameter("@EnquiryID", _EnquiryId);
            OrderNumber = Convert.ToString(SqlHelper.ExecuteScalar(_cnnString, CommandType.StoredProcedure, "usp_GenerateOrderNumber", sqlparams));
            result = Convert.ToInt32(sqlparams[2].Value);
        }
        catch (Exception ex)
        {
            OrderNumber = string.Empty;
        }
        return result;
    }

    public DataSet GenerateQuotationNumber()
    {
        DataSet DS;
        SqlParameter[] sqlparams = new SqlParameter[1];
        sqlparams[0] = new SqlParameter("@EnquiryId", _EnquiryId);

        DS = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_GenerateQuotationNumberAgainstEnquiry", sqlparams);
        return DS;
    }
    public int InsertQuotation()
    {
        int result = 0;
        try
        {
            SqlParameter[] sqlparams = new SqlParameter[8];
            sqlparams[1] = new SqlParameter("@EnquiryId", _EnquiryId);
            sqlparams[2] = new SqlParameter("@QuotationNumber", _QuotationNumber);
            sqlparams[3] = new SqlParameter("@QuotationValue", _QuotationValue);
            sqlparams[4] = new SqlParameter("@QuotationDate", _QuotationDate);
            sqlparams[5] = new SqlParameter("@CreatedBy", _CreatedBy);
            sqlparams[6] = new SqlParameter("@Attachement1", _Attachment1);
            sqlparams[7] = new SqlParameter("@Attachement2", _Attachment2);
            result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_InsertIntoQuotation", sqlparams);
        }
        catch (Exception ex)
        {
            result = 0;
        }
        return result;

    }


    public DataSet BindQuotation()
    {
        try
        {
            DataSet ds;
            SqlParameter[] sqlparams = new SqlParameter[3];
            sqlparams[0] = new SqlParameter("@FromDate", _Fromdate);
            sqlparams[1] = new SqlParameter("@Todate", _Todate);
            sqlparams[2] = new SqlParameter("@IsSearch", _IsSearch);
            ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_BindQuotationDetails", sqlparams);
            return ds;
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public DataSet BindOrders()
    {
        DataSet ds;
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_GetOrders");
        return ds;
    }

    public DataSet ExportData()
    {
        DataSet ds;
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_ExportOrderDetails");
        return ds;
    }
    //public int UpdateOrderValue()
    //{
    //    int result = 0;
    //    SqlParameter[] sqlparams = new SqlParameter[4];
    //    sqlparams[0] = new SqlParameter("@OrderId", _OrderID);
    //    sqlparams[1] = new SqlParameter("@QuotationValue", _QuotationValue);
    //    sqlparams[2] = new SqlParameter("@OrderDate", _QuotationDate);
    //    sqlparams[3] = new SqlParameter("@CreatedBy", _CreatedBy);
    //    result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_UpdateQuotation", sqlparams);
    //    return 0;
    //}
    public int DeleteQuotation()
    {
        int result = 0;
        try
        {

            SqlParameter[] sqlparams = new SqlParameter[4];
            sqlparams[0] = new SqlParameter("@QuotationID", _QuotationID);
            sqlparams[1] = new SqlParameter("@DeletedBy", _CreatedBy);
            sqlparams[2] = new SqlParameter("@result", SqlDbType.Int);
            sqlparams[2].Direction = ParameterDirection.Output;
            sqlparams[3] = new SqlParameter("@EnquiryID", _EnquiryId);
            SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_DeleteQuotation", sqlparams);
            result = Convert.ToInt32(sqlparams[2].Value);
        }
        catch (Exception ex)
        {
            result = 0;
        }
        return result;
    }

    public int UpdatePodetails()
    {
        int result = 0;
        try
        {

            SqlParameter[] sqlparams = new SqlParameter[4];
            sqlparams[0] = new SqlParameter("@EnquiryID", _EnquiryId);
            sqlparams[1] = new SqlParameter("@PODate", SqlDbType.DateTime);
            sqlparams[1].Value = PODate;
            sqlparams[2] = new SqlParameter("@PONumber", SqlDbType.VarChar);
            sqlparams[2].Value = PONumber;
            sqlparams[3] = new SqlParameter("@POValue", SqlDbType.Decimal);
            sqlparams[3].Value = POValue;
            result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_UpdatePODetails", sqlparams);
        }
        catch (Exception ex)
        {
            result = 0;
        }
        return result;
    }

    public int DeleteOrders()
    {
        int result = 0;
        try
        {

            SqlParameter[] sqlparams = new SqlParameter[2];
            sqlparams[0] = new SqlParameter("@OrderId", _OrderId);
            sqlparams[1] = new SqlParameter("@DeletedBy", _CreatedBy);
            result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_DeleteQuotationOrder", sqlparams);
        }
        catch (Exception ex)
        {
            result = 0;
        }
        return result;
    }
}