<%@ WebService Language="C#" Class="PurchaseOrder" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using System.Data.SqlClient;
using CommonLibrary;
using System.Data;
using Microsoft.ApplicationBlocks1.Data;
using System.Web.Script.Serialization;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class PurchaseOrder : System.Web.Services.WebService
{
    CommonFunctions objComm = new CommonFunctions();
    [WebMethod(EnableSession = true)]
    public string UpsertPurchaseOrder(PurchaseOrder_VM purchaseOder_VM)
    {
        PurchaseOrder_VM objPurchaseOrder_VM = new PurchaseOrder_VM();
        try
        {
            SqlParameter[] param = new SqlParameter[16];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@PurchaseOrderId", purchaseOder_VM.PurchaseOrderId);
            param[2] = new SqlParameter("@WorkOrderId", purchaseOder_VM.WorkOrderId);
            param[3] = new SqlParameter("@PurchaseOrderNo", purchaseOder_VM.PONumber);
            param[4] = new SqlParameter("@PurchaseOrderDate", purchaseOder_VM.PODate);
            param[5] = new SqlParameter("@PurchaseOrderAmount", purchaseOder_VM.POAmount);
            param[6] = new SqlParameter("@StartDate", purchaseOder_VM.StartDate);
            param[7] = new SqlParameter("@EndDate", purchaseOder_VM.EndDate);
            param[9] = new SqlParameter("@PurchaseOrderStatusId", purchaseOder_VM.POStatusId);
            param[10] = new SqlParameter("@PurchaseOrderStatus", purchaseOder_VM.POStatus);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpsertPurchaseOrder", param))
            {
                while (drrr.Read())
                {
                    objPurchaseOrder_VM.PurchaseOrderId = objComm.GetValue<int>(drrr["PurchaseOrderId"].ToString());
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(objPurchaseOrder_VM);
    }

    [WebMethod(EnableSession = true)]
    public string CheckDuplicatePONo(string purchaseOrderNo, int workOrderId)
    {
        PurchaseOrder_VM objPurchaseOrder_VM = new PurchaseOrder_VM();
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@PurchaseOrderNo", purchaseOrderNo);
            param[2] = new SqlParameter("@WorkOrderId", workOrderId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_CheckDuplicatePONo", param))
            {
                while (drrr.Read())
                {
                    objPurchaseOrder_VM.PONumber = objComm.GetValue<string>(drrr["PurchaseOrderNo"].ToString());
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(objPurchaseOrder_VM);
    }

    [WebMethod(EnableSession = true)]
    public string GetPODetails(int workOrderId, int pageIndex, int pageSize, string srchPO)
    {
        List<PurchaseOrder_VM> objPurchaseOrder_VMList = new List<PurchaseOrder_VM>();
        try
        {
            SqlParameter[] param = new SqlParameter[6];

            param[0] = new SqlParameter("@WorkOrderId", workOrderId);
            param[1] = new SqlParameter("@PageIndex", pageIndex);
            param[2] = new SqlParameter("@PageSize", pageSize);
            param[3] = new SqlParameter("@Srch", srchPO);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetPurchaseOrderList", param))
            {
                while (drrr.Read())
                {
                    objPurchaseOrder_VMList.Add(new PurchaseOrder_VM()
                    {
                        PurchaseOrderId = objComm.GetValue<int>(drrr["PurchaseOrderId"].ToString()),
                        PONumber = objComm.GetValue<string>(drrr["PurchaseOrderNo"].ToString()),
                        WorkOrderId = objComm.GetValue<int>(drrr["WorkOrderId"].ToString()),
                        PODate = objComm.GetValue<string>(drrr["PurchaseOrderDate"].ToString()),
                        POAmount = objComm.GetValue<decimal>(drrr["PurchaseOrderAmount"].ToString()),
                        StartDate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        EndDate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        POStatus = objComm.GetValue<string>(drrr["PurchaseOrderStatus"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(objPurchaseOrder_VMList);
    }

}