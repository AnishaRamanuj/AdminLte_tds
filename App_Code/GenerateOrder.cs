using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using DataAccessLayer;
using System.Data;

/// <summary>
/// Summary description for GenerateOrder
/// </summary>
public class GenerateOrder : Common
{

    public string _OrderNumber { get; set; }
    public int _OrderId { get; set; }
    public int _EnquiryId { get; set; }
    public int _CreatedBy { get; set; }

    public float _OrderValue { get; set; }
    public DateTime _OrderDate { get; set; }

    public string GenerateOrderNumber()
    {
        string ordernumber = string.Empty;
        SqlParameter[] sqlparams = new SqlParameter[1];
        sqlparams[0] = new SqlParameter("@EnquiryId", _EnquiryId);
        ordernumber = Convert.ToString(SqlHelper.ExecuteScalar(_cnnString, CommandType.StoredProcedure, "usp_GenerateOrderNumber", sqlparams));
        return ordernumber;
    }


    public int InsertOrders()
    {
        int result = 0;
        SqlParameter[] sqlparams = new SqlParameter[6];
        sqlparams[1] = new SqlParameter("@EnquiryId", _EnquiryId);
        sqlparams[2] = new SqlParameter("@OrderNumber", _OrderNumber);
        sqlparams[3] = new SqlParameter("@OrderValue", _OrderValue);
        sqlparams[4] = new SqlParameter("@OrderDate", _OrderDate);
        sqlparams[5] = new SqlParameter("@CreatedBy", _CreatedBy);
        result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_InsertOrders", sqlparams);
        return result;

    }
    public DataSet BindOrders()
    {

        DataSet ds;
        ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_BindOrders");
        return ds;
    }

    public int UpdateOrderValue()
    {
        int result = 0;
        SqlParameter[] sqlparams = new SqlParameter[4];
        sqlparams[0] = new SqlParameter("@OrderId", _OrderId);
        sqlparams[1] = new SqlParameter("@OrderValue", _OrderValue);
        sqlparams[2] = new SqlParameter("@OrderDate", _OrderDate);
        sqlparams[3] = new SqlParameter("@CreatedBy", _CreatedBy);
        result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_UpdateOrders", sqlparams);
        return result;
    }
    public int DeleteOrder()
    {
        int result = 0;
        SqlParameter[] sqlparams = new SqlParameter[1];
        sqlparams[0] = new SqlParameter("@OrderId", _OrderId);
        result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_DeleteOrders", sqlparams);
        return result;
    }

}