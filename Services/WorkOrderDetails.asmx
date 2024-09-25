<%@ WebService Language="C#" Class="WorkOrderDetails" %>

using System;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Globalization;
using System.Web.Security;
using System.Text.RegularExpressions;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class WorkOrderDetails : System.Web.Services.WebService
{
    CommonFunctions objComm = new CommonFunctions();

    [WebMethod(EnableSession = true)]
    public string CheckDuplicateWONo(string workOrderNo, string workOrderId, string projectId)
    {
        WorkOrder_VM objWorkOrder_VM = new WorkOrder_VM();
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@WorkOrderNo", workOrderNo);
            param[2] = new SqlParameter("@WorkOrderId", workOrderId);
            param[3] = new SqlParameter("@ProjectId", projectId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_CheckDuplicateWONo", param))
            {
                while (drrr.Read())
                {
                    objWorkOrder_VM.WONumber = objComm.GetValue<string>(drrr["WorkOrderNo"].ToString());
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(objWorkOrder_VM);
    }

    [WebMethod(EnableSession = true)]
    public string GetProjects_WO(int woId)
    {
        List<ProjectMaster> objProjectMasterList = new List<ProjectMaster>();
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@WorkOrderId", woId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetProjects_WorkOrder", param))
            {
                while (drrr.Read())
                {
                    objProjectMasterList.Add(new ProjectMaster()
                    {
                        ProjectId = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<ProjectMaster> tbl = objProjectMasterList as IEnumerable<ProjectMaster>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetWorkOrderStatusList()
    {
        List<WorkOrderStatus_VM> workOrderStatusList = new List<WorkOrderStatus_VM>();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetWorkOrderStatusList", param))
            {
                while (drrr.Read())
                {
                    workOrderStatusList.Add(new WorkOrderStatus_VM()
                    {
                        WorkOrderStatusId = objComm.GetValue<int>(drrr["WorkOrderStatusId"].ToString()),
                        WorkOrderStatus = objComm.GetValue<string>(drrr["WorkOrderStatus"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(workOrderStatusList);
    }

    [WebMethod(EnableSession = true)]
    public string GetWorkOrderMilestoneList()
    {
        List<WorkOrderMilestone_VM> workOrderMilestoneList = new List<WorkOrderMilestone_VM>();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetWOMilestoneList", param))
            {
                while (drrr.Read())
                {
                    workOrderMilestoneList.Add(new WorkOrderMilestone_VM()
                    {
                        MilestoneId = objComm.GetValue<int>(drrr["MilestoneId"].ToString()),
                        MilestoneTitle = objComm.GetValue<string>(drrr["MilestoneTitle"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(workOrderMilestoneList);
    }

    [WebMethod(EnableSession = true)]
    public string GetPurchaseOrderMilestoneList()
    {
        List<PurchaseOrderMilestone_VM> purchaseOrderMilestoneList = new List<PurchaseOrderMilestone_VM>();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetPurchaseOrderMilestoneList", param))
            {
                while (drrr.Read())
                {
                    purchaseOrderMilestoneList.Add(new PurchaseOrderMilestone_VM()
                    {
                        MilestoneId = objComm.GetValue<int>(drrr["MilestoneId"].ToString()),
                        MilestoneTitle = objComm.GetValue<string>(drrr["MilestoneTitle"].ToString()),
                        MilestoneStartDate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        MilestoneEndDate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        MilestoneCompletePercentage = objComm.GetValue<int>(drrr["CompletePercentage"].ToString()),
                        PurchaseOrderNo = objComm.GetValue<string>(drrr["PurchaseOrderNo"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(purchaseOrderMilestoneList);
    }

    [WebMethod(EnableSession = true)]
    public string GetWorkOrderList()
    {
        List<ProjectMaster> objProjectMasterList = new List<ProjectMaster>();
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetWorkOrderList", param))
            {
                while (drrr.Read())
                {
                    objProjectMasterList.Add(new ProjectMaster()
                    {
                        ProjectId = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                        ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<ProjectMaster> tbl = objProjectMasterList as IEnumerable<ProjectMaster>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string UpsertWorkOrder(WorkOrder_VM workOrder_VM)
    {
        WorkOrder_VM objWorkOrder_VM = new WorkOrder_VM();
        try
        {
            string tDate = workOrder_VM.EndDate != "" ? Convert.ToDateTime(workOrder_VM.EndDate).ToString("MM/dd/yyyy") : null;
            SqlParameter[] param = new SqlParameter[16];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@ProjectId", workOrder_VM.ProjectId);
            param[2] = new SqlParameter("@WorkOrderId", workOrder_VM.WorkOrderId);
            param[3] = new SqlParameter("@WONumber", workOrder_VM.WONumber);
            param[4] = new SqlParameter("@WODate", workOrder_VM.WODate);
            param[5] = new SqlParameter("@WOAmount", workOrder_VM.WOAmount);
            param[6] = new SqlParameter("@StartDate", workOrder_VM.StartDate);
            param[7] = new SqlParameter("@EndDate", tDate);
            param[8] = new SqlParameter("@Configuration", workOrder_VM.Configuration);
            param[9] = new SqlParameter("@WOStatusId", workOrder_VM.WOStatusId);
            param[10] = new SqlParameter("@Comment", workOrder_VM.Comment);
            param[11] = new SqlParameter("@WorkStatusPercentage", workOrder_VM.WorkStatusPercentage);
            param[12] = new SqlParameter("@InvoiceAmount", workOrder_VM.InvoiceAmount);
            param[13] = new SqlParameter("@PaymentReceived", workOrder_VM.PaymentReceived);
            param[14] = new SqlParameter("@BalanceAmount", workOrder_VM.BalanceAmount);
            param[15] = new SqlParameter("@WOStatus", workOrder_VM.WOStatus);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpsertWorkOrder", param))
            {
                while (drrr.Read())
                {
                    objWorkOrder_VM.WorkOrderId = objComm.GetValue<int>(drrr["WorkOrderId"].ToString());
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(objWorkOrder_VM);
    }

    [WebMethod(EnableSession = true)]
    public string UpsertWorkOrderMilestoneMaster(WorkOrderMilestone_VM milestone)
    {
        int milestoneId = 0;
        try
        {
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@MilestoneId", milestone.MilestoneId);
            param[1] = new SqlParameter("@MilestoneTitle", milestone.MilestoneTitle);
            param[2] = new SqlParameter("@compid", Session["companyid"]);
            param[3] = new SqlParameter("@StartDate", milestone.MilestoneStartDate);
            param[4] = new SqlParameter("@EndDate", milestone.MilestoneEndDate);
            param[5] = new SqlParameter("@CompletePercentage", milestone.MilestoneCompletePercentage);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpsertWOMilestoneMaster", param))
            {
                while (drrr.Read())
                {
                    milestoneId = objComm.GetValue<int>(drrr["MilestoneId"].ToString());
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(milestoneId);
    }


    [WebMethod(EnableSession = true)]
    public string GetProjectDetails(int pId)
    {
        WorkOrderStatus_Project objWorkOrder_Project = new WorkOrderStatus_Project();
        try
        {
            SqlParameter[] param = new SqlParameter[12];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@ProjectId", pId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_WOGetProjectDetails", param))
            {
                while (drrr.Read())
                {
                    objWorkOrder_Project.ProjectName = drrr["ProjectName"] == DBNull.Value ? "" : Convert.ToString(drrr["ProjectName"]);
                    objWorkOrder_Project.ClientName = drrr["ClientName"] == DBNull.Value ? "" : Convert.ToString(drrr["ClientName"]);
                    objWorkOrder_Project.StartDate = drrr["StartDate"] == DBNull.Value ? "" : Convert.ToString(drrr["StartDate"]);
                    objWorkOrder_Project.EndDate = drrr["EndDate"] == DBNull.Value ? "" : Convert.ToString(drrr["EndDate"]);
                    objWorkOrder_Project.ProjCode = drrr["ProjectCode"] == DBNull.Value ? "" : Convert.ToString(drrr["ProjectCode"]);
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(objWorkOrder_Project);
    }

    [WebMethod(EnableSession = true)]
    public string GetWorkOrderById(int workOrderId)
    {
        WorkOrder_VM workOrder = new WorkOrder_VM();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@WorkOrderId", workOrderId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetWorkOrderById", param))
            {
                while (drrr.Read())
                {
                    workOrder.WorkOrderId = objComm.GetValue<int>(drrr["WorkOrderId"].ToString());
                    workOrder.WONumber = objComm.GetValue<string>(drrr["WorkOrderNo"].ToString());
                    workOrder.WODate = objComm.GetValue<string>(drrr["WODate"].ToString());
                    workOrder.WOAmount = objComm.GetValue<decimal>(drrr["WOAmount"].ToString());
                    workOrder.StartDate = objComm.GetValue<string>(drrr["StartDate"].ToString());
                    workOrder.EndDate = objComm.GetValue<string>(drrr["EndDate"].ToString());
                    workOrder.Configuration = objComm.GetValue<string>(drrr["Configuration"].ToString());
                    workOrder.WOStatusId = objComm.GetValue<int>(drrr["WOStatusId"].ToString());
                    workOrder.Comment = objComm.GetValue<string>(drrr["Comment"].ToString());
                    workOrder.ProjectId = objComm.GetValue<int>(drrr["ProjectId"].ToString());
                    workOrder.WorkStatusPercentage = objComm.GetValue<int>(drrr["WorkStatusPercentage"].ToString());
                    workOrder.InvoiceAmount = objComm.GetValue<decimal>(drrr["InvoiceAmount"].ToString());
                    workOrder.PaymentReceived = objComm.GetValue<decimal>(drrr["PaymentReceived"].ToString());
                    workOrder.BalanceAmount = objComm.GetValue<decimal>(drrr["BalanceAmount"].ToString());
                    workOrder.WorkOrderSteps = drrr["WorkOrderSteps"] == DBNull.Value ? 0 : objComm.GetValue<int>(drrr["WorkOrderSteps"].ToString());
                    workOrder.PurchaseOrdersCount = drrr["PurchaseOrdersCount"] == DBNull.Value ? 0 : objComm.GetValue<int>(drrr["PurchaseOrdersCount"].ToString());
                    workOrder.InvoicesCount = drrr["InvoicesCount"] == DBNull.Value ? 0 : objComm.GetValue<int>(drrr["InvoicesCount"].ToString());
                    workOrder.InvoicesSumTotalAmount = drrr["InvoicesSumTotalAmount"] == DBNull.Value ? 0 : objComm.GetValue<decimal>(drrr["InvoicesSumTotalAmount"].ToString());
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(workOrder);
    }

    [WebMethod(EnableSession = true)]
    public string UpsertPurchaseOrder(PurchaseOrder_VM purchaseOder_VM)
    {
        PurchaseOrder_VM objPurchaseOrder_VM = new PurchaseOrder_VM();
        try
        {
            string tDate = purchaseOder_VM.EndDate != "" ? Convert.ToDateTime(purchaseOder_VM.EndDate).ToString("MM/dd/yyyy") : null;
            SqlParameter[] param = new SqlParameter[16];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@PurchaseOrderId", purchaseOder_VM.PurchaseOrderId);
            param[2] = new SqlParameter("@WorkOrderId", purchaseOder_VM.WorkOrderId);
            param[3] = new SqlParameter("@PurchaseOrderNo", purchaseOder_VM.PONumber);
            param[4] = new SqlParameter("@PurchaseOrderDate", purchaseOder_VM.PODate);
            param[5] = new SqlParameter("@PurchaseOrderAmount", purchaseOder_VM.POAmount);
            param[6] = new SqlParameter("@StartDate", purchaseOder_VM.StartDate);
            param[7] = new SqlParameter("@EndDate", tDate);
            param[8] = new SqlParameter("@POMilestoneId", purchaseOder_VM.POMilestoneId);
            //param[9] = new SqlParameter("@POMilestoneStartDate", purchaseOder_VM.POMilestoneStartDate);
            //param[10] = new SqlParameter("@POMilestoneEndDate", purchaseOder_VM.POMilestoneEndDate);
            //param[11] = new SqlParameter("@POMilestoneCompletePercentage", purchaseOder_VM.POMilestoneCompletePercentage);
            param[12] = new SqlParameter("@PurchaseOrderStatusId", purchaseOder_VM.POStatusId);
            param[13] = new SqlParameter("@PurchaseOrderStatus", purchaseOder_VM.POStatus);

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
        PurchaseOrders objPurchaseOrders = new PurchaseOrders();
        PurchaseOrder_VM purchaseOrder_VM = new PurchaseOrder_VM();

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

                objPurchaseOrders.PurchaseOrder_VMList = objPurchaseOrder_VMList;
                decimal totalAmout = 0;
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            totalAmout = objComm.GetValue<decimal>(drrr["POTotalAmount"].ToString());
                        }
                    }
                }
                objPurchaseOrders.POTotalAmount = totalAmout;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(objPurchaseOrders);
    }

    [WebMethod(EnableSession = true)]
    public string GetPurchaseOrdersForDropdown(int workOrderId)
    {
        List<PurchaseOrder_VM> objPurchaseOrder_VMList = new List<PurchaseOrder_VM>();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@WorkOrderId", workOrderId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetPurchaseOrdersForDropdown", param))
            {
                while (drrr.Read())
                {
                    objPurchaseOrder_VMList.Add(new PurchaseOrder_VM()
                    {
                        PurchaseOrderId = objComm.GetValue<int>(drrr["PurchaseOrderId"].ToString()),
                        PONumber = objComm.GetValue<string>(drrr["PurchaseOrderNo"].ToString())
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

    [WebMethod(EnableSession = true)]
    public string GetPurchaseOrderEdit(int purchaseOrderId)
    {
        PurchaseOrder_VM objPurchaseOrder_VM = new PurchaseOrder_VM();
        try
        {
            SqlParameter[] param = new SqlParameter[6];

            param[0] = new SqlParameter("@PurchaseOrderId", purchaseOrderId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetPurchaseOrderById", param))
            {
                while (drrr.Read())
                {
                    objPurchaseOrder_VM.PurchaseOrderId = objComm.GetValue<int>(drrr["PurchaseOrderId"].ToString());
                    objPurchaseOrder_VM.PONumber = objComm.GetValue<string>(drrr["PurchaseOrderNo"].ToString());
                    objPurchaseOrder_VM.WorkOrderId = objComm.GetValue<int>(drrr["WorkOrderId"].ToString());
                    objPurchaseOrder_VM.PODate = objComm.GetValue<string>(drrr["PurchaseOrderDate"].ToString());
                    objPurchaseOrder_VM.POAmount = objComm.GetValue<decimal>(drrr["PurchaseOrderAmount"].ToString());
                    objPurchaseOrder_VM.StartDate = objComm.GetValue<string>(drrr["StartDate"].ToString());
                    objPurchaseOrder_VM.EndDate = objComm.GetValue<string>(drrr["EndDate"].ToString());
                    objPurchaseOrder_VM.POStatusId = objComm.GetValue<int>(drrr["PurchaseOrderStatusId"].ToString());
                    objPurchaseOrder_VM.POMilestoneId = objComm.GetValue<int>(drrr["POMilestoneId"].ToString());
                    //objPurchaseOrder_VM.POMilestoneStartDate = objComm.GetValue<string>(drrr["POMilestoneStartDate"].ToString());
                    //objPurchaseOrder_VM.POMilestoneEndDate = objComm.GetValue<string>(drrr["POMilestoneEndDate"].ToString());
                    //objPurchaseOrder_VM.POMilestoneCompletePercentage = objComm.GetValue<int>(drrr["POMilestoneCompletePercentage"].ToString());
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
    public string GetPurchaseOrderStatusList()
    {
        List<PurchaseOrderStatus_VM> purchaseOrderStatus_VMList = new List<PurchaseOrderStatus_VM>();
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetPurchaseOrderStatusList", param))
            {
                while (drrr.Read())
                {
                    purchaseOrderStatus_VMList.Add(new PurchaseOrderStatus_VM()
                    {
                        PurchaseOrderStatusId = objComm.GetValue<int>(drrr["PurchaseOrderStatusId"].ToString()),
                        PurchaseOrderStatus = objComm.GetValue<string>(drrr["PurchaseOrderStatus"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(purchaseOrderStatus_VMList);
    }

    [WebMethod(EnableSession = true)]
    public string SaveMilestone(string milestoneName)
    {
        List<PurchaseOrderStatus_VM> purchaseOrderStatus_VMList = new List<PurchaseOrderStatus_VM>();
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[0] = new SqlParameter("@Milestone", milestoneName);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_SaveMilestone", param))
            {
                while (drrr.Read())
                {
                    purchaseOrderStatus_VMList.Add(new PurchaseOrderStatus_VM()
                    {
                        PurchaseOrderStatusId = objComm.GetValue<int>(drrr["PurchaseOrderStatusId"].ToString()),
                        PurchaseOrderStatus = objComm.GetValue<string>(drrr["PurchaseOrderStatus"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(purchaseOrderStatus_VMList);
    }

    [WebMethod(EnableSession = true)]
    public string GetMilestoneDetails(string search)
    {
        List<PurchaseOrderMilestone_VM> milestone_VMList = new List<PurchaseOrderMilestone_VM>();
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@Search", search);
            //param[0] = new SqlParameter("@Milestone", milestoneName);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetPurchaseOrderMilestoneList", param))
            {
                while (drrr.Read())
                {
                    milestone_VMList.Add(new PurchaseOrderMilestone_VM()
                    {
                        MilestoneId = objComm.GetValue<int>(drrr["MilestoneId"].ToString()),
                        MilestoneTitle = objComm.GetValue<string>(drrr["MilestoneTitle"].ToString()),
                        PurchaseOrderNo = objComm.GetValue<string>(drrr["PurchaseOrderNo"].ToString()),
                        MilestoneStartDate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        MilestoneEndDate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        MilestoneCompletePercentage = objComm.GetValue<int>(drrr["CompletePercentage"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(milestone_VMList);
    }

    [WebMethod(EnableSession = true)]
    public string UpsertInvoice(PurchaseOrderInvoice_VM invoice)
    {
        int invoiceId = 0;
        DataTable dtInvoiceItems = new DataTable();
        dtInvoiceItems.Columns.Add("InvoiceId", typeof(int));
        dtInvoiceItems.Columns.Add("InvoiceItemId", typeof(int));
        dtInvoiceItems.Columns.Add("Description", typeof(string));
        dtInvoiceItems.Columns.Add("Quantity", typeof(int));
        dtInvoiceItems.Columns.Add("Amount", typeof(decimal));

        foreach (var item in invoice.InvoiceItems)
        {
            dtInvoiceItems.Rows.Add(item.InvoiceId, item.InvoiceItemId, item.Description, item.Quantity, item.Amount);
        }

        try
        {
            SqlParameter[] param = new SqlParameter[15];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@InvoiceId", invoice.InvoiceId);
            param[2] = new SqlParameter("@PurchaseOrderID", invoice.PurchaseOrderId);
            param[3] = new SqlParameter("@InvoiceNo", invoice.InvoiceNo);
            param[4] = new SqlParameter("@InvoiceDate", invoice.InvoiceDate);
            param[5] = new SqlParameter("@Discount", invoice.Discount);
            param[6] = new SqlParameter("@GST", invoice.GST);
            param[7] = new SqlParameter("@GSTPercentage", invoice.GSTPercentage);
            param[8] = new SqlParameter("@TotalAmount", invoice.TotalAmount);
            param[9] = new SqlParameter("@TermConditions", invoice.TermConditions);
            param[10] = new SqlParameter("@WorkOrderId", invoice.WorkOrderId);
            param[11] = new SqlParameter("@TempTable", dtInvoiceItems);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpsertInvoiceWO", param))
            {
                while (drrr.Read())
                {
                    invoiceId = objComm.GetValue<int>(drrr["InvoiceId"].ToString());
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(invoiceId);
    }

    [WebMethod(EnableSession = true)]
    public string CheckDuplicateInvoiceNo(string invoiceNo, string invoiceId, string workOrderId)
    {
        PurchaseOrderInvoice_VM invoice = new PurchaseOrderInvoice_VM();
        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@WorkOrderId", workOrderId);
            param[1] = new SqlParameter("@InvoiceNo", invoiceNo);
            param[2] = new SqlParameter("@InvoiceId", invoiceId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_CheckDuplicateInvoiceNo", param))
            {
                while (drrr.Read())
                {
                    invoice.InvoiceNo = objComm.GetValue<string>(drrr["InvoiceNumber"].ToString());
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(invoice);
    }

    //[WebMethod(EnableSession = true)]
    //public string UpsertInvoice(PurchaseOrderInvoice_VM woInvoice)
    //{
    //    int invoiceId = 0;
    //    DataTable dtInvoiceItems = new DataTable();
    //    dtInvoiceItems.Columns.Add("InvoiceId", typeof(int));
    //    dtInvoiceItems.Columns.Add("InvoiceItemId", typeof(int));
    //    dtInvoiceItems.Columns.Add("Description", typeof(string));
    //    dtInvoiceItems.Columns.Add("Quantity", typeof(int));
    //    dtInvoiceItems.Columns.Add("Amount", typeof(decimal));

    //    foreach (var item in woInvoice.WOInvoiceItems)
    //    {
    //        dtInvoiceItems.Rows.Add(0, 0, item.Description, item.Quantity, item.Amount);
    //    }

    //    try
    //    {
    //        SqlParameter[] param = new SqlParameter[15];
    //        param[0] = new SqlParameter("@CompId", Session["companyid"]);
    //        param[1] = new SqlParameter("@InvoiceId", woInvoice.InvoiceId);
    //        param[2] = new SqlParameter("@PurchaseOrderID", woInvoice.PurchaseOrderId);
    //        param[3] = new SqlParameter("@InvoiceNo", woInvoice.InvoiceNo);
    //        param[4] = new SqlParameter("@InvoiceDate", woInvoice.InvoiceDate);
    //        param[5] = new SqlParameter("@Discount", woInvoice.Discount);
    //        param[6] = new SqlParameter("@GST", woInvoice.GST);
    //        param[7] = new SqlParameter("@TotalAmount", woInvoice.TotalAmount);
    //        param[8] = new SqlParameter("@TermConditions", woInvoice.TermConditions);
    //        param[9] = new SqlParameter("@WorkOrderId", woInvoice.WorkOrderId);
    //        param[10] = new SqlParameter("@TempTable", dtInvoiceItems);

    //        using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpsertInvoiceWO", param))
    //        {
    //            while (drrr.Read())
    //            {
    //                invoiceId = objComm.GetValue<int>(drrr["InvoiceId"].ToString());
    //            }
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //    return new JavaScriptSerializer().Serialize(invoiceId);
    //}

    [WebMethod(EnableSession = true)]
    public string GetInvoiceList(string search, int workOrderId)
    {
        List<PurchaseOrderInvoice_VM> invoice_VMList = new List<PurchaseOrderInvoice_VM>();
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@CompId", Session["companyid"]);
            param[1] = new SqlParameter("@Search", search);
            param[2] = new SqlParameter("@WorkOrderId", workOrderId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetInvoiceList", param))
            {
                while (drrr.Read())
                {
                    invoice_VMList.Add(new PurchaseOrderInvoice_VM()
                    {
                        InvoiceId = objComm.GetValue<int>(drrr["InvoiceId"].ToString()),
                        InvoiceNo = objComm.GetValue<string>(drrr["InvoiceNo"].ToString()),
                        InvoiceDate = objComm.GetValue<string>(drrr["InvoiceDate"].ToString()),
                        TotalAmount = objComm.GetValue<decimal>(drrr["TotalAmount"].ToString()),
                        PurchaseOrderNo = objComm.GetValue<string>(drrr["PurchaseOrderNo"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(invoice_VMList);
    }

    [WebMethod(EnableSession = true)]
    public string GetPurchaseOrderInvoiceById(int invoiceId)
    {
        PurchaseOrderInvoice_VM invoice = new PurchaseOrderInvoice_VM();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@InvoiceId", invoiceId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetPurchaseOrderInvoiceById", param))
            {
                while (drrr.Read())
                {
                    invoice.InvoiceId = objComm.GetValue<int>(drrr["InvoiceId"].ToString());
                    invoice.WorkOrderId = objComm.GetValue<int>(drrr["WorkOrderId"].ToString());
                    invoice.PurchaseOrderId = objComm.GetValue<int>(drrr["PurchaseOrderId"].ToString());
                    invoice.InvoiceNo = objComm.GetValue<string>(drrr["InvoiceNo"].ToString());
                    invoice.InvoiceDate = objComm.GetValue<string>(drrr["InvoiceDate"].ToString());
                    invoice.Discount = objComm.GetValue<decimal>(drrr["Discount"].ToString());
                    invoice.GST = objComm.GetValue<string>(drrr["GST"].ToString());
                    invoice.GSTPercentage = objComm.GetValue<decimal>(drrr["GSTPercentage"].ToString());
                    invoice.TotalAmount = objComm.GetValue<decimal>(drrr["TotalAmount"].ToString());
                    invoice.TermConditions = objComm.GetValue<string>(drrr["TermConditions"].ToString());
                }

                List<PurchaseOrderInvoiceItem_VM> invoiceitems = new List<PurchaseOrderInvoiceItem_VM>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            invoiceitems.Add(new PurchaseOrderInvoiceItem_VM()
                            {
                                InvoiceItemId = objComm.GetValue<int>(drrr["InvoiceItemId"].ToString()),
                                InvoiceId = objComm.GetValue<int>(drrr["InvoiceId"].ToString()),
                                Description = objComm.GetValue<string>(drrr["Description"].ToString()),
                                Quantity = objComm.GetValue<int>(drrr["Quantity"].ToString()),
                                Amount = objComm.GetValue<decimal>(drrr["Amount"].ToString()),
                            });
                        }

                        invoice.InvoiceItems = invoiceitems;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(invoice);
    }

    [WebMethod(EnableSession = true)]
    public string GetMilestoneById(int milestoneId)
    {
        PurchaseOrderMilestone_VM milestone = new PurchaseOrderMilestone_VM();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@MilestoneId", milestoneId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetMilestoneById", param))
            {
                while (drrr.Read())
                {
                    milestone.MilestoneId = objComm.GetValue<int>(drrr["MilestoneId"].ToString());
                    milestone.MilestoneTitle = objComm.GetValue<string>(drrr["MilestoneTitle"].ToString());
                    milestone.MilestoneStartDate = objComm.GetValue<string>(drrr["StartDate"].ToString());
                    milestone.MilestoneEndDate = objComm.GetValue<string>(drrr["EndDate"].ToString());
                    milestone.MilestoneCompletePercentage = objComm.GetValue<int>(drrr["CompletePercentage"].ToString());
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(milestone);
    }
}