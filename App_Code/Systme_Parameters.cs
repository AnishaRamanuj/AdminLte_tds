using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Systme_Parameters
/// </summary>
public class Systme_Parameters
{
    public int _CompanyTimethresholdID { get; set; }
    public int _CompanyID { get; set; }
    public string _WeeklyThreshold { get; set; }
    public string _DailyThreshold { get; set; }
    public string Leave_Year { get; set; }
    public int _NumberOfDaysRequireInWeek { get; set; }
    public bool _IsFreeze { get; set; }
    public int _FreezeDays { get; set; }
    public int _CreatedBy { get; set; }
    public DateTime _CreatedDate { get; set; }
    public int _UpdatedBy { get; set; }
    public DateTime _UpdatedDate { get; set; }
    public int _ID { get; set; }
    public string _Mon { get; set; }
    public string _Tue { get; set; }
    public string _wed { get; set; }
    public string _thu { get; set; }
    public string _fri { get; set; }
    public string _Sat { get; set; }
    public string _Sun { get; set; }
    public bool _FormatA { get; set; }
    public bool _FormatB { get; set; }
    public bool _IsFreezeYes { get; set; }
    public bool _IsFreezeNo { get; set; }
    public int _SubmittedMail { get; set; }
    public int _ApprovedMail { get; set; }
    public int _Isrejected { get; set; }
    public string _StaffName { get; set; }
    public int _staffID { get; set; }
    public bool compecentryoffloc { get; set; }
    public bool chkaprbyHOD { get; set; }
    public bool chkmultiproject { get; set; }
    public bool chkleavewithoutpay { get; set; }
    public bool aprcanedittmst { get; set; }
    public bool chkbuddetail { get; set; }
    public bool chkjobdetail { get; set; }
    public bool chkexpence { get; set; }
    public bool ChkBill { get; set; }
    public bool chknarr { get; set; }
    public bool ChkVbill { get; set; }
    public string drpR { get; set; }
    public string drpP { get; set; }
    public bool ChkPAllocate { get; set; }
    public int staffID
    {
        get
        {
            return _staffID;
        }
        set
        {
            _staffID = value;
        }
    }
    public int CompanyTimethresholdID
    {
        get
        {
            return _CompanyTimethresholdID;
        }
        set
        {
            _CompanyTimethresholdID = value;
        }

    }
    public int CompanyID
    {
        get
        {
            return _CompanyID;
        }
        set
        {
            _CompanyID = value;
        }

    }
    public string WeeklyThreshold
    {
        get
        {
            return _WeeklyThreshold;
        }
        set
        {
            _WeeklyThreshold = value;
        }

    }
    public string DailyThreshold
    {
        get
        {
            return _DailyThreshold;
        }
        set
        {
            _DailyThreshold = value;
        }

    }
    public int NumberOfDaysRequireInWeek
    {
        get
        {
            return _NumberOfDaysRequireInWeek;
        }
        set
        {
            _NumberOfDaysRequireInWeek = value;
        }

    }
    public bool IsFreeze
    {
        get
        {
            return _IsFreeze;
        }
        set
        {
            _IsFreeze = value;
        }

    }
    public int FreezeDays
    {
        get
        {
            return _FreezeDays;
        }
        set
        {
            _FreezeDays = value;
        }

    }
    public int CreatedBy
    {
        get
        {
            return _CreatedBy;
        }
        set
        {
            _CreatedBy = value;
        }

    }
    public DateTime CreatedDate
    {
        get
        {
            return _CreatedDate;
        }
        set
        {
            _CreatedDate = value;
        }

    }
    public int UpdatedBy
    {
        get
        {
            return _UpdatedBy;
        }
        set
        {
            _UpdatedBy = value;
        }

    }
    public DateTime UpdatedDate
    {
        get
        {
            return _UpdatedDate;
        }
        set
        {
            _UpdatedDate = value;
        }

    }
    public int ID
    {
        get
        {
            return _ID;
        }
        set
        {
            _ID = value;
        }

    }

    public string Monday
    {
        get
        {
            return _Mon;
        }
        set
        {
            _Mon = value;
        }

    }
    public string Tuesday
    {
        get
        {
            return _Tue;
        }
        set
        {
            _Tue = value;
        }

    }
    public string Wednsday
    {
        get
        {
            return _wed;
        }
        set
        {
            _wed = value;
        }

    }
    public string Thursday
    {
        get
        {
            return _thu;
        }
        set
        {
            _thu = value;
        }

    }
    public string Friday
    {
        get
        {
            return _fri;
        }
        set
        {
            _fri = value;
        }

    }
    public string Saturday
    {
        get
        {
            return _Sat;
        }
        set
        {
            _Sat = value;
        }

    }
    public string Sunday
    {
        get
        {
            return _Sun;
        }
        set
        {
            _Sun = value;
        }

    }
    public bool FormatB
    {
        get
        {
            return _FormatB;
        }
        set
        {
            _FormatB = value;
        }

    }
    public bool FormatA
    {
        get
        {
            return _FormatA;
        }
        set
        {
            _FormatA = value;
        }

    }
    public bool IsFreezeYes
    {
        get
        {
            return _IsFreezeYes;
        }
        set
        {
            _IsFreezeYes = value;
        }

    }
    public bool IsFreezeNo
    {
        get
        {
            return _IsFreezeNo;
        }
        set
        {
            _IsFreezeNo = value;
        }

    }
    public int SubmittedMail
    {
        get
        {
            return _SubmittedMail;
        }
        set
        {
           _SubmittedMail = value;
        }

    }
    public int ApprovedMail
    {
        get
        {
            return _ApprovedMail;
        }
        set
        {
            _ApprovedMail = value;
        }

    }
    public int IsRejected
    {
        get
        {
            return _Isrejected;
        }
        set
        {
            _Isrejected = value;
        }

    }

    public string StaffName
    {
        get
        {
            return _StaffName;
        }

        set
        {
            _StaffName = value;
        }
    }


    public string Statementtype { get; set; }

    public bool Loaction { get; set; }

    public bool Reasons { get; set; }

    public bool LeaveFormat { get; set; }

    public bool TimesheetApprovedhierarchically { get; set; }

    public bool Approver_Charges { get; set; }
    public bool TopApprover_Charges { get; set; }
    public bool Staff_Charges { get; set; }

    public bool CheckStaffWithThumbPrint { get; set; }


}