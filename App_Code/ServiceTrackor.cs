using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for ServiceTrackor
/// </summary>
public class ServiceTrackor : Common
{

    public int EnquiryID { get; set; }
    public string ActionToTake { get; set; }
    public DateTime DateOfCompletion { get; set; }
    public string CurrentStatus { get; set; }
    public string Customer { get; set; }
    public string CustomerResponse { get; set; }
    public DateTime FinalDateOfCompletion { get; set; }
    public string FollowUpAction { get; set; }
    public string FollowUpOrder { get; set; }
    public string OfferGiven { get; set; }

    public string OrderConf { get; set; }
    public string OrderRecieved { get; set; }
    public string ParentComp { get; set; }
    public string PaymentFollowp1 { get; set; }
    public string PaymentRecieved { get; set; }
    public string PaymmentFollowp2 { get; set; }
    public DateTime PODate { get; set; }
    public string PONumber { get; set; }
    public float POValue { get; set; }
    public string ResponsiblePerson { get; set; }

    public string _FilterValue { get; set; }
    public string _FilterColumn { get; set; }
    public bool _IsSearch { get; set; }
    public bool _IsDateFitler { get; set; }
    public DateTime _EnquiryDate { get; set; }
    public string _Fromdate { get; set; }
    public string _Todate { get; set; }


    public DataSet BindEnquiryServiceTracker()
    {
        DataSet DS = null;
        SqlParameter[] sqlparams = new SqlParameter[6];
        sqlparams[0] = new SqlParameter("@FilterColumn", _FilterColumn);
        sqlparams[1] = new SqlParameter("@Filtervalue", _FilterValue);
        sqlparams[2] = new SqlParameter("@IsSearch", _IsSearch);
        sqlparams[3] = new SqlParameter("@IsdateFilter", _IsDateFitler);
        sqlparams[4] = new SqlParameter("@FromDate", _Fromdate);
        sqlparams[5] = new SqlParameter("@Todate", _Todate);
        DS = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_BindEnquiryServiceTracker", sqlparams);
        return DS;
    }
    public DataSet GetEnquiryDetailsForServiceTrackor()
    {
        SqlParameter[] sqlparams = new SqlParameter[9];
        sqlparams[0] = new SqlParameter("@EnquiryID", SqlDbType.Int);
        sqlparams[0].Value = EnquiryID;
        DataSet ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_GetEnquiryDetailsForServiceTracker", sqlparams);
        return ds;
    }

    public DataSet GetEnquiryDetailsForServiceTrackor_forExport(string CommaseperatedEnquiryID)
    {
        SqlParameter[] sqlparams = new SqlParameter[1];
        sqlparams[0] = new SqlParameter("@EnquiryID", SqlDbType.VarChar);
        sqlparams[0].Value = CommaseperatedEnquiryID;
        DataSet ds = SqlHelper.ExecuteDataset(_cnnString, CommandType.StoredProcedure, "usp_GetEnquiryDetailsForServiceTracker_Export", sqlparams);
        return ds;
    }

    public int UpdateEnquiry()
    {
        SqlParameter[] sqlparams = new SqlParameter[19];
        sqlparams[0] = new SqlParameter("@EnquiryID", SqlDbType.Int);
        sqlparams[0].Value = EnquiryID;
        sqlparams[1] = new SqlParameter("@ActionToTake", SqlDbType.VarChar);
        sqlparams[1].Value = ActionToTake;
        sqlparams[2] = new SqlParameter("@DateOfCompletion", SqlDbType.DateTime);
        sqlparams[2].Value = DateOfCompletion;
        sqlparams[3] = new SqlParameter("@CurrentStatus", SqlDbType.VarChar);
        sqlparams[3].Value = CurrentStatus;
        sqlparams[4] = new SqlParameter("@CustomerResponse", SqlDbType.VarChar);
        sqlparams[4].Value = CustomerResponse;
        sqlparams[5] = new SqlParameter("@FinalDateOfCompletion", SqlDbType.DateTime);
        sqlparams[5].Value = FinalDateOfCompletion;
        sqlparams[6] = new SqlParameter("@FollowUpAction", SqlDbType.VarChar);
        sqlparams[6].Value = FollowUpAction;
        sqlparams[7] = new SqlParameter("@FollowUpOrder", SqlDbType.VarChar);
        sqlparams[7].Value = FollowUpOrder;
        sqlparams[8] = new SqlParameter("@OfferGiven", SqlDbType.VarChar);
        sqlparams[8].Value = OfferGiven;

        sqlparams[9] = new SqlParameter("@OrderConf", SqlDbType.VarChar);
        sqlparams[9].Value = OrderConf;
        sqlparams[10] = new SqlParameter("@OrderRecieved", SqlDbType.VarChar);
        sqlparams[10].Value = OrderRecieved;

        sqlparams[11] = new SqlParameter("@ParentComp", SqlDbType.VarChar);
        sqlparams[11].Value = ParentComp;
        sqlparams[12] = new SqlParameter("@PaymentFollowp1", SqlDbType.VarChar);
        sqlparams[12].Value = PaymentFollowp1;
        sqlparams[13] = new SqlParameter("@PaymentRecieved", SqlDbType.VarChar);
        sqlparams[13].Value = PaymentRecieved;

        sqlparams[14] = new SqlParameter("@PaymmentFollowp2", SqlDbType.VarChar);
        sqlparams[14].Value = PaymmentFollowp2;
        sqlparams[15] = new SqlParameter("@PODate", SqlDbType.DateTime);
        sqlparams[15].Value = PODate;
        sqlparams[16] = new SqlParameter("@PONumber", SqlDbType.VarChar);
        sqlparams[16].Value = PONumber;
        sqlparams[17] = new SqlParameter("@POValue", SqlDbType.Decimal);
        sqlparams[17].Value = POValue;
        sqlparams[18] = new SqlParameter("@ResponsiblePerson", SqlDbType.VarChar);
        sqlparams[18].Value = ResponsiblePerson;

        int result = SqlHelper.ExecuteNonQuery(_cnnString, CommandType.StoredProcedure, "usp_UpdateEnquiryServiceTrack", sqlparams);
        return result;
        // return 1;
    }
}