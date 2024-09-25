<%@ WebService Language="C#" Class="WorkOrder" %>

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
public class WorkOrder : System.Web.Services.WebService
{
    CommonFunctions objComm = new CommonFunctions();

    [WebMethod(EnableSession = true)]
    public string GetWorkOrderDetails(WorkOrder_VM workOrder_VM)
    {
        WorkOrder_VM objWorkOrder_VM = new WorkOrder_VM();
        try
        {
            SqlParameter[] param = new SqlParameter[11];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@WorkOrderId", workOrder_VM.WorkOrderId);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(objWorkOrder_VM);
    }

    [WebMethod(EnableSession = true)]
    public string GetWorkOrderList(int pageIndex, int pageSize, string srch, string filterType, string managersId)
    {
        List<WorkOrder_VM> objWorkOrder_VMList = new List<WorkOrder_VM>();
        try
        {
            SqlParameter[] param = new SqlParameter[11];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@PageIndex", pageIndex);
            param[2] = new SqlParameter("@PageSize", pageSize);
            param[3] = new SqlParameter("@Srch", srch);
            param[4] = new SqlParameter("@FilterType", filterType);
            param[5] = new SqlParameter("@ManagersId", managersId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetWorkOrderList", param))
            {
                while (drrr.Read())
                {
                    objWorkOrder_VMList.Add(new WorkOrder_VM()
                    {
                        ProjectId = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        WorkOrderId = objComm.GetValue<int>(drrr["WorkOrderId"].ToString()),
                        WONumber = objComm.GetValue<string>(drrr["WorkOrderNo"].ToString()),
                        WODate = objComm.GetValue<string>(drrr["WODate"].ToString()),
                        WOAmount = objComm.GetValue<decimal>(drrr["WOAmount"].ToString()),
                        StartDate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        EndDate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        Configuration = objComm.GetValue<string>(drrr["Configuration"].ToString()),
                        WOStatus = objComm.GetValue<string>(drrr["WorkOrderStatus"].ToString()),
                        Comment = objComm.GetValue<string>(drrr["Comment"].ToString()),
                        WorkStatusPercentage = objComm.GetValue<int>(drrr["WorkStatusPercentage"].ToString()),
                        ProjectCode = objComm.GetValue<string>(drrr["Project_Code"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        ClientId = objComm.GetValue<int>(drrr["ClientId"].ToString()),
                        Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                        InvoiceAmount = objComm.GetValue<decimal>(drrr["InvoiceAmount"].ToString()),
                        PaymentReceived = objComm.GetValue<decimal>(drrr["PaymentReceived"].ToString()),
                        ProjectManager = objComm.GetValue<string>(drrr["ProjectManager"].ToString()),
                        BalanceAmount = objComm.GetValue<decimal>(drrr["BalanceAmount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(objWorkOrder_VMList);
    }

    [WebMethod(EnableSession = true)]
    public string GetManagerList()
    {
        List<staffs> staffs = new List<staffs>();
        try
        {
            SqlParameter[] param = new SqlParameter[12];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetProjectManagersName", param))

            {
                while (drrr.Read())
                {
                    staffs.Add(new staffs()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(staffs);
    }

    [WebMethod(EnableSession = true)]
    public string SetWorkOrderId(int workOrderId)
    {
        CommonFunctions objComm = new CommonFunctions();
        try
        {
            HttpContext.Current.Session["WorkOrderId"] = workOrderId;
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(true);
    }

    [WebMethod(EnableSession = true)]
    public string DeleteWorkOrder(int workOrderId)
    {
        WorkOrder_VM workOrder_VM = new WorkOrder_VM();
        try
        {
            SqlParameter[] param = new SqlParameter[12];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[2] = new SqlParameter("@WorkOrderId", workOrderId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteWorkOrder", param))
            {
                while (drrr.Read())
                {
                    workOrder_VM.WorkOrderId = objComm.GetValue<int>(drrr["WorkOrderId"].ToString());
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(workOrder_VM);
    }
}
