<%@ WebService Language="C#" Class="LeaveMng" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data.SqlClient;
using System.Data;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Globalization;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class LeaveMng : System.Web.Services.WebService
{

    [WebMethod(EnableSession=true)]
    public string GetLeaveRecord(string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<leave_Management> obj_Job = new List<leave_Management>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetLeave", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new leave_Management()
                    {
                        sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Leaveid = objComm.GetValue<int>(drrr["Leave_ID"].ToString()),
                        Leavename = objComm.GetValue<string>(drrr["Leave_Name"].ToString()),
                        Shortname = objComm.GetValue<string>(drrr["Shortname"].ToString()),
                        OpeningBal = objComm.GetValue<string>(drrr["Opening_Bal"].ToString()),
                        Min = objComm.GetValue<string>(drrr["Min_Days"].ToString()),
                        Max = objComm.GetValue<string>(drrr["Max_Days"].ToString()),
                        Accumulate_Days = objComm.GetValue<string>(drrr["Accumulate_Days"].ToString()),
                        Balance_CF = objComm.GetValue<string>(drrr["Balance_CF"].ToString()),
                        Balance_CF_Days = objComm.GetValue<string>(drrr["Balance_CF_Days"].ToString()),
                        Monthly_Allocation = objComm.GetValue<string>(drrr["Monthly_Allocation"].ToString()),
                        Monthly_Hours = objComm.GetValue<string>(drrr["Monthly_Hours"].ToString()),
                        AllowLessthenZero = objComm.GetValue<string>(drrr["AllowLessthenZero"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<leave_Management> tbl = obj_Job as IEnumerable<leave_Management>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string SaveAndUpdate(int Leaveid, string rid, int editid, string FrmD, string ToD, string MHrs, string ChekZero)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<leave_Management> obj_Job = new List<leave_Management>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Leaveid", Leaveid);
            param[2] = new SqlParameter("@rid", rid);
            param[3] = new SqlParameter("@editid", editid);
            param[4] = new SqlParameter("@FrmD", FrmD);
            param[5] = new SqlParameter("@ToD", ToD);
            param[6] = new SqlParameter("@MHrs", MHrs);
            param[7] = new SqlParameter("@ChekZero", ChekZero);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InsertUpdateLeave", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new leave_Management()
                    {
                        Leaveid = objComm.GetValue<int>(drrr["lvid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<leave_Management> tbl = obj_Job as IEnumerable<leave_Management>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string BindMonthlyLeave(int Lid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_MonthlyLeave> List_ML = new List<tbl_MonthlyLeave>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@lid", Lid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetLeave_Monthly_Master", param))
            {
                while (drrr.Read())
                {
                    List_ML.Add(new tbl_MonthlyLeave()
                    {
                        MLeave_ID = objComm.GetValue<int>(drrr["mLeave_id"].ToString()),
                        From_Days = objComm.GetValue<string>(drrr["JDays"].ToString()),
                        To_Days = objComm.GetValue<string>(drrr["Jdays_to"].ToString()),
                        Join_Hrs = objComm.GetValue<string>(drrr["JHours"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MonthlyLeave> tbl = List_ML as IEnumerable<tbl_MonthlyLeave>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string DeleteRecord(int Leaveid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_MonthlyLeave> List_ML = new List<tbl_MonthlyLeave>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@Company_ID", Session["companyid"]);
            param[1] = new SqlParameter("@Leave_ID", Leaveid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteLeaveMaster", param))
            {
                while (drrr.Read())
                {
                    List_ML.Add(new tbl_MonthlyLeave()
                    {
                        MLeave_ID = objComm.GetValue<int>(drrr["livid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MonthlyLeave> tbl = List_ML as IEnumerable<tbl_MonthlyLeave>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteMonthlyLeave(int Mid, int c, int Lid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_MonthlyLeave> List_ML = new List<tbl_MonthlyLeave>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", c);
            param[1] = new SqlParameter("@Mid", Mid);
            param[2] = new SqlParameter("@Lid", Lid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Delete_Leave_Monthly_Master", param))
            {
                while (drrr.Read())
                {
                    List_ML.Add(new tbl_MonthlyLeave()
                    {
                        Leave_ID = objComm.GetValue<int>(drrr["Leave_id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MonthlyLeave> tbl = List_ML as IEnumerable<tbl_MonthlyLeave>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetLeaveAllocationRecord(string Srch, int pageIndex, int pageSize, int year)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_leave_Alloc> obj_Job = new List<tbl_leave_Alloc>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            param[4] = new SqlParameter("@leaveYear", year);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_LeaveAllocation_staffDetails", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_leave_Alloc()
                    {
                        sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                        staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Email = objComm.GetValue<string>(drrr["Email"].ToString()),
                        OpeningBal = objComm.GetValue<string>(drrr["Opening_Balance"].ToString()),
                        Dept = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        Dsg = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        Brch = objComm.GetValue<string>(drrr["BranchName"].ToString()),
                        Leave_Taken = objComm.GetValue<string>(drrr["Leave_Taken"].ToString()),
                        Balance = objComm.GetValue<string>(drrr["Balance"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_leave_Alloc> tbl = obj_Job as IEnumerable<tbl_leave_Alloc>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetLeaveAllocationStaff(int staffcode, int year)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_leaveStaffdetails> List_DS = new List<tbl_leaveStaffdetails>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Staffid", staffcode);
            param[2] = new SqlParameter("@leaveYear", year);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetStaffCodeStaffLeaveDetils", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_leaveStaffdetails()
                    {
                        Staff = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Joindt = objComm.GetValue<string>(drrr["dtj"].ToString()),
                    });
                }
                List<tbl_leave_Alloc> listline = new List<tbl_leave_Alloc>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listline.Add(new tbl_leave_Alloc()
                            {
                                Dept = objComm.GetValue<string>(drrr["Leave_Name"].ToString()),
                                Dsg = objComm.GetValue<string>(drrr["Shortname"].ToString()),
                                OpeningBal = objComm.GetValue<string>(drrr["Opening_balance"].ToString()),
                                Leave_Taken = objComm.GetValue<string>(drrr["Leave_Taken"].ToString()),
                                Balance = objComm.GetValue<string>(drrr["Balance"].ToString()),
                                LeaveAllocationId = objComm.GetValue<int>(drrr["Leave_Allocation_ID"].ToString()),
                            });
                        }
                    }
                }
                foreach (var item in List_DS)
                {
                    item.list_line = listline;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_leaveStaffdetails> tbl = List_DS as IEnumerable<tbl_leaveStaffdetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetLeaveDrpdwn(int compid=0)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Leavedropdwn> List_DS = new List<tbl_Leavedropdwn>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Staffdrpdwn", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Leavedropdwn()
                    {
                        compid = objComm.GetValue<int>(drrr["compid"].ToString()),

                    });
                }
                List<tbl_Roleswise_staff> lisstaff = new List<tbl_Roleswise_staff>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            lisstaff.Add(new tbl_Roleswise_staff()
                            {
                                Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                StaffNames = objComm.GetValue<string>(drrr["StaffName"].ToString()),

                            });
                        }
                    }
                }
                List<leave_Management> listLeave = new List<leave_Management>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listLeave.Add(new leave_Management()
                            {
                                Leaveid = objComm.GetValue<int>(drrr["Leave_ID"].ToString()),
                                Leavename = objComm.GetValue<string>(drrr["Leave_Name"].ToString()),
                                OpeningBal = objComm.GetValue<string>(drrr["Opening_Bal"].ToString()),
                                Monthly_Allocation = objComm.GetValue<string>(drrr["Monthly_Allocation"].ToString()),
                                AllowLessthenZero = objComm.GetValue<string>(drrr["AllowLessthenZero"].ToString()),
                            });
                        }
                    }
                }
                foreach (var item in List_DS)
                {

                    item.list_staff = lisstaff;
                    item.list_leave = listLeave;
                }
            }
        }

        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Leavedropdwn> tbl = List_DS as IEnumerable<tbl_Leavedropdwn>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string GetMonthList(int lid, string Month)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_MonthlyLeave> List_ML = new List<tbl_MonthlyLeave>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@lid", lid);
            param[2] = new SqlParameter("@mth", Month);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetLeave_Monthly_List", param))
            {
                while (drrr.Read())
                {
                    List_ML.Add(new tbl_MonthlyLeave()
                    {
                        Leave_ID = objComm.GetValue<int>(drrr["Staffcode"].ToString()),
                        Leave_Name = objComm.GetValue<string>(drrr["Staffname"].ToString()),
                        MonthID = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                        MonthName = objComm.GetValue<string>(drrr["Month_Name"].ToString()),
                        Leave_Monthly = objComm.GetValue<string>(drrr["Opening"].ToString()),
                        yearID = objComm.GetValue<int>(drrr["year1"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MonthlyLeave> tbl = List_ML as IEnumerable<tbl_MonthlyLeave>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    [WebMethod(EnableSession=true)]
    public string LeaveAllocInsertUpdate(string Rid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_MonthlyLeave> List_ML = new List<tbl_MonthlyLeave>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@rid", Rid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_SaveLeaveAllocation", param))
            {
                while (drrr.Read())
                {
                    List_ML.Add(new tbl_MonthlyLeave()
                    {
                        Leave_ID = objComm.GetValue<int>(drrr["leave_id"].ToString()),


                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MonthlyLeave> tbl = List_ML as IEnumerable<tbl_MonthlyLeave>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string Allocate(tbl_MonthlyLeave id)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_MonthlyLeave> List_ML = new List<tbl_MonthlyLeave>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@lid", id.Leave_ID);
            param[2] = new SqlParameter("@mth", id.MonthName);
            param[3] = new SqlParameter("@hdnAllapp", id.Leave_Monthly);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Leave_Monthly_Allocate", param))
            {
                while (drrr.Read())
                {
                    List_ML.Add(new tbl_MonthlyLeave()
                    {
                        MonthName = objComm.GetValue<string>(drrr["Month_Name"].ToString()),
                        MonthID = objComm.GetValue<int>(drrr["month1"].ToString()),
                        yearID = objComm.GetValue<int>(drrr["year1"].ToString()),
                        Leave_Name = objComm.GetValue<string>(drrr["Remark"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MonthlyLeave> tbl = List_ML as IEnumerable<tbl_MonthlyLeave>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string DeleteLeaveMonthly(int m, int yr, int lid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_MonthlyLeave> List_ML = new List<tbl_MonthlyLeave>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@lid", lid);
            param[2] = new SqlParameter("@mth", m);
            param[3] = new SqlParameter("@yr", yr);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Leave_Monthly_Delete", param))
            {
                while (drrr.Read())
                {
                    List_ML.Add(new tbl_MonthlyLeave()
                    {
                        MonthName = objComm.GetValue<string>(drrr["Month_Name"].ToString()),
                        MonthID = objComm.GetValue<int>(drrr["month1"].ToString()),
                        yearID = objComm.GetValue<int>(drrr["year1"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MonthlyLeave> tbl = List_ML as IEnumerable<tbl_MonthlyLeave>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////////Leave Approver Allocation

    [WebMethod(EnableSession=true)]
    public string GetLeaveAllocationApprover(string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_leave_Alloc> obj_Job = new List<tbl_leave_Alloc>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetLeaveApprover", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_leave_Alloc()
                    {
                        sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                        staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Dept = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        OpeningBal = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        Balance = objComm.GetValue<string>(drrr["Mobile"].ToString()),
                        Email = objComm.GetValue<string>(drrr["Email"].ToString()),
                        Dsg = objComm.GetValue<string>(drrr["Appcount"].ToString()),
                        TotalCount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_leave_Alloc> tbl = obj_Job as IEnumerable<tbl_leave_Alloc>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string BindApprover(int staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Assignments> obj_Job = new List<Assignments>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", staffcode);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_ApproverLeave", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Assignments()
                    {
                        mJobID = objComm.GetValue<int>(drrr["staffcode"].ToString()),
                        MJobName = objComm.GetValue<string>(drrr["staff"].ToString()),
                        Assign_Name = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Assignments> tbl = obj_Job as IEnumerable<Assignments>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string GetApproverstaff(int staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<Assignments> obj_Job = new List<Assignments>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", staffcode);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetApproverstaff", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new Assignments()
                    {
                        mJobID = objComm.GetValue<int>(drrr["staffcode"].ToString()),
                        MJobName = objComm.GetValue<string>(drrr["staff"].ToString()),
                        Assign_Name = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<Assignments> tbl = obj_Job as IEnumerable<Assignments>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string LeaveApproverInsertUpdate(string Rid, int staffcode, int savetype)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_MonthlyLeave> List_ML = new List<tbl_MonthlyLeave>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@rid", Rid);
            param[2] = new SqlParameter("@staffcode", staffcode);
            param[3] = new SqlParameter("@savetype", savetype);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_SaveLeaveApprover", param))
            {
                while (drrr.Read())
                {
                    List_ML.Add(new tbl_MonthlyLeave()
                    {
                        Leave_ID = objComm.GetValue<int>(drrr["compid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MonthlyLeave> tbl = List_ML as IEnumerable<tbl_MonthlyLeave>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    //Leave Application/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    [WebMethod(EnableSession=true)]
    public string GetLeaveMasterDropdown(int Staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<leave_Management> List_ML = new List<leave_Management>();

        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@CompID", Session["companyid"]);
                param[1] = new SqlParameter("@Staffcode", Staffcode);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetLeaveMaster", param))
                {
                    while (drrr.Read())
                    {
                        List_ML.Add(new leave_Management()
                        {
                            Leaveid = objComm.GetValue<int>(drrr["Leave_ID"].ToString()),
                            Leavename = objComm.GetValue<string>(drrr["Leave_Name"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<leave_Management> tbl = List_ML as IEnumerable<leave_Management>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetAllLeaveDropdown(int compid=0)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<leave_Management> List_ML = new List<leave_Management>();

        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@CompID", Session["companyid"]);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetAllLeaveDropdown", param))
                {
                    while (drrr.Read())
                    {
                        List_ML.Add(new leave_Management()
                        {
                            Leaveid = objComm.GetValue<int>(drrr["Leave_ID"].ToString()),
                            Leavename = objComm.GetValue<string>(drrr["Leave_Name"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<leave_Management> tbl = List_ML as IEnumerable<leave_Management>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    [WebMethod(EnableSession=true)]
    public string GetLeaveApplication(int staffcode, string Satatus, int pageIndex, int pageSize, int Lvid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_LeaveApplication> obj_Job = new List<tbl_LeaveApplication>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[6];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@StaffCode", staffcode);
                param[2] = new SqlParameter("@pageIndex", pageIndex);
                param[3] = new SqlParameter("@pageSize", pageSize);
                param[4] = new SqlParameter("@LeaveId", Lvid);
                param[5] = new SqlParameter("@status", Satatus);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Boostrap_GetLeaveApplication", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_LeaveApplication()
                        {
                            sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                            Employee_ID = objComm.GetValue<int>(drrr["Employee_ID"].ToString()),
                            Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                            ApplicatnID = objComm.GetValue<int>(drrr["Leave_Application_Id"].ToString()),
                            Leavename = objComm.GetValue<string>(drrr["Leave_Name"].ToString()),
                            Shortname = objComm.GetValue<string>(drrr["Shortname"].ToString()),
                            AppDt = objComm.GetValue<string>(drrr["Application_DT"].ToString()),
                            FrmDt = objComm.GetValue<string>(drrr["Start_DT"].ToString()),
                            ToDt = objComm.GetValue<string>(drrr["End_DT"].ToString()),
                            Days = objComm.GetValue<string>(drrr["Leave_Days"].ToString()),
                            Hours = objComm.GetValue<string>(drrr["Hours_HH_MM"].ToString()),
                            Status = objComm.GetValue<string>(drrr["Status"].ToString()),
                            reason = objComm.GetValue<string>(drrr["Leave_Reasion"].ToString()),
                            Leavid = objComm.GetValue<int>(drrr["Leave_ID"].ToString()),
                            type = objComm.GetValue<string>(drrr["Half_type"].ToString()),
                            TotalCount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_LeaveApplication> tbl = obj_Job as IEnumerable<tbl_LeaveApplication>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string GetLeaveApplicationleavedetail(int staffcode, int Lvid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_LeaveAppldetail> obj_Job = new List<tbl_LeaveAppldetail>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[3];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@StaffCode", staffcode);
                param[2] = new SqlParameter("@LeaveId", Lvid);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_LeaveApplicationDetails", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_LeaveAppldetail()
                        {

                            SN = objComm.GetValue<string>(drrr["Shortname"].ToString()),
                            Min_days = objComm.GetValue<string>(drrr["Min_Days"].ToString()),
                            Max_Days = objComm.GetValue<string>(drrr["Max_Days"].ToString()),
                            Op_Bal = objComm.GetValue<string>(drrr["Opening_Balance"].ToString()),
                            LeaveTaken = objComm.GetValue<string>(drrr["Leave_Taken"].ToString()),
                            Bal = objComm.GetValue<string>(drrr["Balance"].ToString()),
                            Dailythrshhold = objComm.GetValue<string>(drrr["DailyThreshold"].ToString()),
                            AllowLessthenZero = objComm.GetValue<string>(drrr["AllowLessthenZero"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_LeaveAppldetail> tbl = obj_Job as IEnumerable<tbl_LeaveAppldetail>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string CheckDate(int staffcode, int leaveappid, string fromdt, string todate, int Leavid,string hfdt)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<leave_Management> obj_Job = new List<leave_Management>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[7];
                param[0] = new SqlParameter("@CompID", Session["companyid"]);
                param[1] = new SqlParameter("@staffcode", staffcode);
                param[2] = new SqlParameter("@Leave_Application_Id", leaveappid);
                param[3] = new SqlParameter("@FromDate", fromdt);
                param[4] = new SqlParameter("@ToDate", todate);
                param[5] = new SqlParameter("@Leavid", Leavid);
                param[6] = new SqlParameter("@HalfDayType", hfdt);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Boostrap_LeaveApplication_CheckDate", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new leave_Management()
                        {

                            Leavename = objComm.GetValue<string>(drrr["Result"].ToString()),
                            wdys = objComm.GetValue<int>(drrr["LeaveDys"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<leave_Management> tbl = obj_Job as IEnumerable<leave_Management>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    [WebMethod(EnableSession=true)]
    public string SaveUpadateApplictn(int staffcode, int leaveappid, string Appdate, string fromdt, string todate, string reason, string half, string Days, int LeaveID, string hours)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<leave_Management> obj_Job = new List<leave_Management>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[11];
                param[0] = new SqlParameter("@CompID", Session["companyid"]);
                param[1] = new SqlParameter("@staffcode", staffcode);
                param[2] = new SqlParameter("@Leave_Application_Id", leaveappid);
                param[3] = new SqlParameter("@Appdate", Appdate);
                param[4] = new SqlParameter("@FromDate", fromdt);
                param[5] = new SqlParameter("@ToDate", todate);
                param[6] = new SqlParameter("@leaveresion", reason);
                param[7] = new SqlParameter("@Days", Days);
                param[8] = new SqlParameter("@LeaveID", LeaveID);
                param[9] = new SqlParameter("@HalfDayType", half);
                param[10] = new SqlParameter("@Hours", hours);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_LeaveApplication_SaveStaffLeaveApplication", param))
                {
                    while (drrr.Read())
                    {
                        if (leaveappid == 0)
                        {
                            obj_Job.Add(new leave_Management()
                            {

                                Leaveid = objComm.GetValue<int>(drrr["rows"].ToString()),

                            });

                            List<list_stff_summary> lisstaff = new List<list_stff_summary>();

                            if (drrr.NextResult())
                            {
                                if (drrr.HasRows)
                                {
                                    while (drrr.Read())
                                    {
                                        lisstaff.Add(new list_stff_summary()
                                        {
                                            Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                            staffemail = objComm.GetValue<string>(drrr["Email"].ToString()),

                                        });
                                    }
                                }
                            }
                            foreach (var item in obj_Job)
                            {

                                item.list_Staff = lisstaff;

                            }
                        }
                        else
                        {
                            obj_Job.Add(new leave_Management()
                            {

                                Leaveid = objComm.GetValue<int>(drrr["rows"].ToString()),

                            });
                        }

                    }
                }
            }
        }

        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<leave_Management> tbl = obj_Job as IEnumerable<leave_Management>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }




    [WebMethod(EnableSession=true)]
    public string DeleteApplictn(int leaveappid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<leave_Management> obj_Job = new List<leave_Management>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@CompID", Session["companyid"]);
                param[1] = new SqlParameter("@Leave_Application_Id", leaveappid);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteLeaveApplication", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new leave_Management()
                        {

                            Leaveid = objComm.GetValue<int>(drrr["delete"].ToString()),

                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<leave_Management> tbl = obj_Job as IEnumerable<leave_Management>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetLeaveStaffdrpdown(int Staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Roleswise_staff> obj_Job = new List<tbl_Roleswise_staff>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@staffcode", Staffcode);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_LeaveSatfflist", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_Roleswise_staff()
                        {
                            Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                            StaffNames = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Roleswise_staff> tbl = obj_Job as IEnumerable<tbl_Roleswise_staff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    //////////////////////////////////////////////////////////////////////////////////////////Leave Sanction

    [WebMethod(EnableSession=true)]
    public string GetLeaveYears(int compid=0)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Currency> obj_Job = new List<tbl_Currency>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@CompID", Session["companyid"]);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetLeaveYears", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_Currency()
                        {

                            Country = objComm.GetValue<string>(drrr["LeaveYear"].ToString()),

                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Currency> tbl = obj_Job as IEnumerable<tbl_Currency>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetLeaveSanction(string Satatus, int Lvid, int pageIndex, int pageSize, int staffcode, string Staffname, string Leaveyear)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_LeaveApplication> obj_Job = new List<tbl_LeaveApplication>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[8];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@StaffCode", staffcode);
                param[2] = new SqlParameter("@pageIndex", pageIndex);
                param[3] = new SqlParameter("@pageSize", pageSize);
                param[4] = new SqlParameter("@LeaveId", Lvid);
                param[5] = new SqlParameter("@status", Satatus);
                param[6] = new SqlParameter("@staffname", Staffname);
                param[7] = new SqlParameter("@LeaveYear", Leaveyear);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetLeaveSancation", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_LeaveApplication()
                        {
                            sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                            Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                            Mob = objComm.GetValue<string>(drrr["Mobile"].ToString()),
                            email = objComm.GetValue<string>(drrr["Email"].ToString()),
                            ApplicatnID = objComm.GetValue<int>(drrr["Leave_Application_Id"].ToString()),
                            Leavename = objComm.GetValue<string>(drrr["Leave_Name"].ToString()),
                            Shortname = objComm.GetValue<string>(drrr["Shortname"].ToString()),
                            AppDt = objComm.GetValue<string>(drrr["Application_DT"].ToString()),
                            FrmDt = objComm.GetValue<string>(drrr["Start_DT"].ToString()),
                            ToDt = objComm.GetValue<string>(drrr["End_DT"].ToString()),
                            Days = objComm.GetValue<string>(drrr["Leave_Days"].ToString()),
                            Hours = objComm.GetValue<string>(drrr["Hours_HH_MM"].ToString()),
                            Status = objComm.GetValue<string>(drrr["Status"].ToString()),
                            reason = objComm.GetValue<string>(drrr["Leave_Reasion"].ToString()),
                            Leavid = objComm.GetValue<int>(drrr["Leave_ID"].ToString()),
                            type = objComm.GetValue<string>(drrr["Half_type"].ToString()),
                            TotalCount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_LeaveApplication> tbl = obj_Job as IEnumerable<tbl_LeaveApplication>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetLeaveSanctionleavedetail(int Lvid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_LeaveAppldetail> obj_Job = new List<tbl_LeaveAppldetail>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@CompID", Session["companyid"]);
                param[1] = new SqlParameter("@Leave_Application_Id", Lvid);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_LeaveSanctionDetails", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_LeaveAppldetail()
                        {

                            SN = objComm.GetValue<string>(drrr["Shortname"].ToString()),
                            Min_days = objComm.GetValue<string>(drrr["Min_Days"].ToString()),
                            Max_Days = objComm.GetValue<string>(drrr["Max_Days"].ToString()),
                            Op_Bal = objComm.GetValue<string>(drrr["Opening_Balance"].ToString()),
                            LeaveTaken = objComm.GetValue<string>(drrr["Leave_Taken"].ToString()),
                            Bal = objComm.GetValue<string>(drrr["Balance"].ToString()),
                            Dailythrshhold = objComm.GetValue<string>(drrr["DailyThreshold"].ToString()),
                            AllowLessthenZero = objComm.GetValue<string>(drrr["AllowLessthenZero"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_LeaveAppldetail> tbl = obj_Job as IEnumerable<tbl_LeaveAppldetail>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string SaveUpadateSanction(int staffcode, int leaveappid, string fromdt, string todate, string half, string Days, int LeaveID, string hours, string SaveStatus)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<leave_Management> obj_Job = new List<leave_Management>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[9];
                param[0] = new SqlParameter("@CompID", Session["companyid"]);
                param[1] = new SqlParameter("@staffcode", staffcode);
                param[2] = new SqlParameter("@Leave_Application_Id", leaveappid);
                param[3] = new SqlParameter("@FromDate", fromdt);
                param[4] = new SqlParameter("@ToDate", todate);
                param[5] = new SqlParameter("@Days", Days);
                param[6] = new SqlParameter("@HalfDayType", half);
                param[7] = new SqlParameter("@Hours", hours);
                param[8] = new SqlParameter("@Status", SaveStatus);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Leave_Sancation_SaveStaffLeaveApplication", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new leave_Management()
                        {

                            Leaveid = objComm.GetValue<int>(drrr["rows"].ToString()),

                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<leave_Management> tbl = obj_Job as IEnumerable<leave_Management>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    /////////////////////////////Leave Report //////////////////////////////////

    [WebMethod(EnableSession=true)]
    public string GetLeaveStaff(int staffcode, string Start, string end, string TStatus, int Year, string Details)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Roleswise_staff> obj_Job = new List<tbl_Roleswise_staff>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", staffcode);
            param[2] = new SqlParameter("@Start", Start);
            param[3] = new SqlParameter("@end", end);
            param[4] = new SqlParameter("@TStatus", TStatus);
            param[5] = new SqlParameter("@Year", Year);
            param[6] = new SqlParameter("@type", Details);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_StaffLeaveList", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_Roleswise_staff()
                    {
                        Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffNames = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Roleswise_staff> tbl = obj_Job as IEnumerable<tbl_Roleswise_staff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string GetLeaveReport(string frmdt, string Todt, string TStatus, string Staffcodeids, string Details, string Balance, int Year)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_GetLeaveReport> obj_Job = new List<tbl_GetLeaveReport>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@comp", Session["companyid"]);
            param[1] = new SqlParameter("@status", TStatus);
            param[2] = new SqlParameter("@from", frmdt);
            param[3] = new SqlParameter("@to", Todt);
            param[4] = new SqlParameter("@Empids", Staffcodeids);
            param[5] = new SqlParameter("@type", Details);
            param[6] = new SqlParameter("@Year1", Year);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "Usp_Bootstrap_Report_LeaveDetailsBalance", param))
                if (Details == "true")
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_GetLeaveReport()
                        {
                            staff = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                            Leave = objComm.GetValue<string>(drrr["LeaveName"].ToString()),
                            appdt = objComm.GetValue<string>(drrr["AppDate"].ToString()),
                            strtdt = objComm.GetValue<string>(drrr["FromDate"].ToString()),
                            endt = objComm.GetValue<string>(drrr["ToDate"].ToString()),
                            LevHrs = objComm.GetValue<string>(drrr["LeaveHrs"].ToString()),
                            status = objComm.GetValue<string>(drrr["Status"].ToString()),
                            Appr = objComm.GetValue<string>(drrr["Leave_Approver"].ToString()),
                        });
                    }
                }
                else
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_GetLeaveReport()
                        {
                            staff = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                            Leave = objComm.GetValue<string>(drrr["LeaveName"].ToString()),
                            OpnBalc = objComm.GetValue<string>(drrr["OpeningBalance"].ToString()),
                            LevTaken = objComm.GetValue<string>(drrr["LeaveTaken"].ToString()),
                            Balance = objComm.GetValue<string>(drrr["Balance"].ToString()),

                        });
                    }
                }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_GetLeaveReport> tbl = obj_Job as IEnumerable<tbl_GetLeaveReport>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string UpdateStaffLeaveDetails(tbl_LeaveAllocation_Json[] B)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_LeaveApplication> obj_Job = new List<tbl_LeaveApplication>();
        try
        {
            for (int i = 0; i < B.Length; i++)
            {
                SqlParameter[] param = new SqlParameter[7];
                param[0] = new SqlParameter("@CompId", Session["companyid"]);
                param[1] = new SqlParameter("@LeaveAllocationId", B[i].LeaveAllocationId);
                param[2] = new SqlParameter("@OpeningBalance", B[i].OpeningBalance);
                param[3] = new SqlParameter("@Balance", B[i].Balance);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpdateStaffLeaveDetails", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_LeaveApplication()
                        {
                            Leavid = objComm.GetValue<int>(drrr["rows"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception e)
        {
            return "Error";
        }
        return new JavaScriptSerializer().Serialize(obj_Job);
    }

}