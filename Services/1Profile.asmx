<%@ WebService Language="C#" Class="Profile" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data.SqlClient;
using System.Data;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Globalization;
using CommonLogin;
using System.Web.Security;
using JTMSProject;
using System.Net;
using System.IO;
using System.Text;
using System.Xml;
using System.Web.Configuration;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Profile : System.Web.Services.WebService
{
    private readonly DBAccess db = new DBAccess();
    [WebMethod(EnableSession = true)]
    public string GetdetailsCompany(int compid = 0)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_companyProfile> List_DS = new List<tbl_companyProfile>();

        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@compid", Session["companyid"]);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetCompanyProfile", param))
                {
                    while (drrr.Read())
                    {
                        List_DS.Add(new tbl_companyProfile()
                        {
                            CompanyName = objComm.GetValue<string>(drrr["CompanyName"].ToString()),
                            Add1 = objComm.GetValue<string>(drrr["Address1"].ToString()),
                            Add2 = objComm.GetValue<string>(drrr["Address2"].ToString()),
                            Add3 = objComm.GetValue<string>(drrr["Address3"].ToString()),
                            City = objComm.GetValue<string>(drrr["City"].ToString()),
                            Phone = objComm.GetValue<string>(drrr["Phone"].ToString()),
                            Email = objComm.GetValue<string>(drrr["Email"].ToString()),
                            FirstName = objComm.GetValue<string>(drrr["FirstName"].ToString()),
                            Cash = objComm.GetValue<string>(drrr["Cash"].ToString()),
                            username = objComm.GetValue<string>(drrr["username"].ToString()),
                            LastName = objComm.GetValue<string>(drrr["LastName"].ToString()),
                            password = objComm.GetValue<string>(drrr["password"].ToString()),
                            Start = objComm.GetValue<string>(drrr["Start"].ToString()),
                            Enddate = objComm.GetValue<string>(drrr["Enddate"].ToString()),
                            StaffCount = objComm.GetValue<int>(drrr["StaffCount"].ToString()),

                        });
                    }
                    List<tbl_Currency> listCurr = new List<tbl_Currency>();

                    if (drrr.NextResult())
                    {
                        if (drrr.HasRows)
                        {
                            while (drrr.Read())
                            {
                                listCurr.Add(new tbl_Currency()
                                {
                                    Country = objComm.GetValue<string>(drrr["Country"].ToString()),
                                    Currency = objComm.GetValue<string>(drrr["Currency"].ToString()),

                                });
                            }
                        }
                    }

                    foreach (var item in List_DS)
                    {

                        item.list_Currency = listCurr;

                    }
                }
            }
        }

        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_companyProfile> tbl = List_DS as IEnumerable<tbl_companyProfile>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession = true)]
    public string UpdatedataCompany(string rid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_MonthlyLeave> List_ML = new List<tbl_MonthlyLeave>();

        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@rid", rid);


                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpdateCompanyProfile", param))
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
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MonthlyLeave> tbl = List_ML as IEnumerable<tbl_MonthlyLeave>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string UpdateAdminPass(string Oldpass, string Newpass, int staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_MonthlyLeave> List_ML = new List<tbl_MonthlyLeave>();

        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[4];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@Oldpass", Oldpass);
                param[2] = new SqlParameter("@Newpass", Newpass);
                param[3] = new SqlParameter("@staffcode", staffcode);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpdateAdminPass", param))
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
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MonthlyLeave> tbl = List_ML as IEnumerable<tbl_MonthlyLeave>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GeUpdateConfig(string rd, string frezrd, string WorkingDays, string LeaveYr)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_MonthlyLeave> List_ML = new List<tbl_MonthlyLeave>();

        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[5];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@rd", rd);
                param[2] = new SqlParameter("@frezrd", frezrd);
                param[3] = new SqlParameter("@WorkingDays", WorkingDays);
                param[4] = new SqlParameter("@LeaveYr", LeaveYr);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpdateConfig", param))
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
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MonthlyLeave> tbl = List_ML as IEnumerable<tbl_MonthlyLeave>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod(EnableSession = true)]
    public string GetRecordConfig(int compid = 0)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_GetRecourdConfig> List_ML = new List<tbl_GetRecourdConfig>();

        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@compid", Session["companyid"]);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetRecourdConfig", param))
                {
                    while (drrr.Read())
                    {
                        List_ML.Add(new tbl_GetRecourdConfig()
                        {
                            FmtA = objComm.GetValue<bool>(drrr["Format_A"].ToString()),
                            FmtB = objComm.GetValue<bool>(drrr["Format_B"].ToString()),
                            Attch = objComm.GetValue<bool>(drrr["Attachment_mandatory"].ToString()),
                            loc = objComm.GetValue<bool>(drrr["Location_mandatory"].ToString()),
                            Narr = objComm.GetValue<bool>(drrr["Narration"].ToString()),
                            exp = objComm.GetValue<bool>(drrr["Expense"].ToString()),
                            Hidebill = objComm.GetValue<bool>(drrr["Hide_Billable"].ToString()),
                            Rej = objComm.GetValue<bool>(drrr["RejectReasons"].ToString()),
                            Editbill = objComm.GetValue<bool>(drrr["Edit_Billing_Hrs"].ToString()),
                            IsFreeze = objComm.GetValue<bool>(drrr["IsFreeze"].ToString()),
                            FreezeDays = objComm.GetValue<int>(drrr["FreezeDays"].ToString()),
                            DailyHour = objComm.GetValue<float>(drrr["DailyThreshold"].ToString()),
                            weeklyThresh = objComm.GetValue<float>(drrr["WeeklyThreshold"].ToString()),
                            Mon = objComm.GetValue<bool>(drrr["Mon"].ToString()),
                            Tue = objComm.GetValue<bool>(drrr["Tue"].ToString()),
                            Wed = objComm.GetValue<bool>(drrr["Wed"].ToString()),
                            Thu = objComm.GetValue<bool>(drrr["Thu"].ToString()),
                            Fri = objComm.GetValue<bool>(drrr["Fri"].ToString()),
                            Sat = objComm.GetValue<bool>(drrr["Sat"].ToString()),
                            Sun = objComm.GetValue<bool>(drrr["Sun"].ToString()),
                            FutureDT = objComm.GetValue<bool>(drrr["Future_Date"].ToString()),
                            TSNOTSub = objComm.GetValue<int>(drrr["TSNotSub"].ToString()),
                            Lvyr = objComm.GetValue<string>(drrr["LeaveYear"].ToString()),
                            SatHoliday = objComm.GetValue<string>(drrr["SatHoliday2_4"].ToString()),
                            AllowLeave = objComm.GetValue<bool>(drrr["AllowTimesheetonLeave"].ToString()),
                            MinHrs = objComm.GetValue<int>(drrr["MinHrs"].ToString()),
                            MaxHrs = objComm.GetValue<double>(drrr["Max_hours"].ToString()),
                            SendMailLeaveApplication = objComm.GetValue<int>(drrr["SendMail_LeaveApplication"].ToString()),
                            SendMailLeaveApprover = objComm.GetValue<int>(drrr["SendMail_LeaveApprover"].ToString()),
                            SendMailMonthlySummary = objComm.GetValue<int>(drrr["SendMail_Monthly_Summary"].ToString()),
                            RequireTimeSheetApproval = objComm.GetValue<int>(drrr["Auto_Approve"].ToString()),
                            pageLevel = objComm.GetValue<int>(drrr["Pagelevel"].ToString()),
                            Default_MMDDYYYY = objComm.GetValue<int>(drrr["Default_MMDDYYYY"].ToString()),
                            AllowCheckedInCheckOut = objComm.GetValue<bool>(drrr["AllowCheckedInCheckOut"].ToString()),
                            SendMail_Daily_Summary = objComm.GetValue<int>(drrr["SendMail_Daily_Summary"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_GetRecourdConfig> tbl = List_ML as IEnumerable<tbl_GetRecourdConfig>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [System.Web.Services.WebMethod(EnableSession = true)]
    public string CheckLogin(string lat, string lng) ////(string usr, string pass,string lat,string lng)
    {

        string emailid = "";
        CommonLogin.CommonLoginUsr objComm = new CommonLogin.CommonLoginUsr();
        List<Tbl_Login> obj = new List<Tbl_Login>();
        try
        {
            //Common ob = new Common();
            if (Membership.ValidateUser(Session["Username"].ToString(), Session["Password"].ToString()))
            {

                string FullAddress = GetFullAddress(Convert.ToString(Session["Lat"]), Convert.ToString(Session["Log"]));
                HttpContext.Current.Session["loginlocation"] = FullAddress;
                if (Roles.IsUserInRole(Session["Username"].ToString(), "superadmin"))
                {
                    HttpContext.Current.Session["roleid"] = "superadmin";
                    HttpContext.Current.Session["admin"] = "Mainuser";
                    obj.Add(new Tbl_Login()
                    {
                        Msg = objComm.GetValue<string>("Active"),
                        url = objComm.GetValue<string>("Admin/AdminHome.aspx"),
                        UsrRole = objComm.GetValue<string>("Admin"),

                    });
                }
                else if (Roles.IsUserInRole(Session["Username"].ToString(), "admin"))
                {
                    string StrSQL = "select id,username,pwd from admin_privs where username='" + Session["Username"].ToString() +
                                  "' and pwd='" + Session["Password"].ToString() + "'";
                    DataTable dtUserInfo = db.GetDataTable(StrSQL);
                    Session.Add("roleid", "admin");
                    if (dtUserInfo != null && dtUserInfo.Rows.Count != 0)
                    {
                        HttpContext.Current.Session["adminid1"] = Convert.ToInt32(dtUserInfo.Rows[0]["id"].ToString());
                        HttpContext.Current.Session["admin1"] = Session["Username"].ToString();

                        obj.Add(new Tbl_Login()
                        {
                            Msg = objComm.GetValue<string>("Active"),
                            url = objComm.GetValue<string>("Admin/AdminHome.aspx"),
                            UsrRole = objComm.GetValue<string>("Admin"),

                        });
                    }

                }


                else if (Roles.IsUserInRole(Session["Username"].ToString(), "company"))
                {
                    HttpContext.Current.Session["roleid"] = "company";
                    SqlParameter[] param = new SqlParameter[3];
                    param[0] = new SqlParameter("@username", Session["Username"].ToString());
                    param[1] = new SqlParameter("@password", Session["Password"].ToString());
                    param[2] = new SqlParameter("@IsApproved", "true");
                    DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Company_Login", param);
                    if (ds.Tables[0].Rows.Count > 0)
                    {

                        HttpContext.Current.Session["UserRole"] = "Admin";
                        HttpContext.Current.Session["Name"] = ds.Tables[0].Rows[0]["Name"].ToString();
                        HttpContext.Current.Session["CompanyName"] = ds.Tables[0].Rows[0]["CompanyName"].ToString();
                        HttpContext.Current.Session["currency"] = ds.Tables[0].Rows[0]["Cash"].ToString();
                        HttpContext.Current.Session["fulname"] = ds.Tables[0].Rows[0]["CompanyName"].ToString();
                        HttpContext.Current.Session["companyid"] = ds.Tables[0].Rows[0]["CompId"].ToString();
                        HttpContext.Current.Session["deptwise"] = ds.Tables[0].Rows[0]["deptwise"].ToString();
                        HttpContext.Current.Session["taskwise"] = ds.Tables[0].Rows[0]["taskwise"].ToString();
                        HttpContext.Current.Session["ApproverPattern"] = ds.Tables[0].Rows[0]["Dual_Approver"].ToString();
                        HttpContext.Current.Session["DualApprovers"] = ds.Tables[0].Rows[0]["Dual_Approver"].ToString();
                        HttpContext.Current.Session["StfRole"] = ds.Tables[0].Rows[0]["StaffRole"].ToString();
                        HttpContext.Current.Session["AdmTsheet"] = ds.Tables[0].Rows[0]["AdmTsheet"].ToString();
                        HttpContext.Current.Session["Expenses"] = ds.Tables[0].Rows[0]["expense"].ToString();
                        HttpContext.Current.Session["Narration"] = ds.Tables[0].Rows[0]["Narration"].ToString();
                        HttpContext.Current.Session["staffid"] = ds.Tables[0].Rows[0]["StaffCode"].ToString();
                        HttpContext.Current.Session["PageLevel"] = ds.Tables[0].Rows[0]["PageLevel"].ToString();
                        HttpContext.Current.Session["RoleName"] = ds.Tables[0].Rows[0]["Rolename"].ToString();
                        HttpContext.Current.Session["StaffQuta"] = ds.Tables[0].Rows[0]["StaffQuta"].ToString();
                        HttpContext.Current.Session["StaffActive"] = ds.Tables[0].Rows[0]["StaffActive"].ToString();
                        HttpContext.Current.Session["DaysRemaining"] = ds.Tables[0].Rows[0]["DaysRemainingAMC"].ToString();

                        HttpContext.Current.Session["usertype"] = "company";
                        string Compid = Session["companyid"].ToString();
                        // DBAccess.PrintLogin(hdnIP.Value, ds.Tables[0].Rows[0]["CompanyName"].ToString(), "Company", hdnDT.Value);
                        Compid = Compid + ",0," + Session["fulname"].ToString();
                        string Cid = db.EncryptData(Compid);
                        HttpContext.Current.Session["Cid"] = Cid;

                        int logins = 0;
                        if (ds.Tables[0].Rows[0]["Logins"].ToString() != "" && ds.Tables[0].Rows[0]["Logins"].ToString() != null)
                        {
                            logins = int.Parse(ds.Tables[0].Rows[0]["Logins"].ToString());
                        }
                        HttpContext.Current.Session["logins"] = logins;
                        string lastupdate = "";
                        DateTime lastup = new DateTime();
                        if (ds.Tables[0].Rows[0]["LastLogin1"].ToString() != "" && ds.Tables[0].Rows[0]["LastLogin1"].ToString() != null)
                        {
                            //lastup = DateTime.Parse(dtUserInfo.Rows[0]["LastLogin1"].ToString());
                            lastupdate = ds.Tables[0].Rows[0]["LastLogin1"].ToString();
                        }
                        else
                        {
                            //lastup = DateTime.Parse(dtUserInfo.Rows[0]["CreatedDate1"].ToString());
                            lastupdate = ds.Tables[0].Rows[0]["CreatedDate1"].ToString();
                        }
                        emailid = ds.Tables[0].Rows[0]["Email"].ToString();
                        string stat = "";
                        string schemes = "";

                        if (ds.Tables[1].Rows.Count > 0)
                        {
                            stat = ds.Tables[1].Rows[0]["DayRemaing"].ToString();
                            schemes = ds.Tables[1].Rows[0]["Schemes"].ToString();

                        }

                        if (schemes == "Free Version")
                        {
                            string q11 = "select cm.CreatedDate,cm.CompId,sp.DayCount,sp.Schemes,case when ((getdate()> (dateadd(day,sp.DayCount,cm.CreatedDate))) and (sp.Schemes='Free Version')) then 'Account Expired' when ((getdate()< (dateadd(day,sp.DayCount,cm.CreatedDate))) and (sp.Schemes='Free Version'))  then 'Free Trail will Expire in '+ convert(varchar(3),datediff(day,getdate(),(dateadd(day,sp.DayCount,cm.CreatedDate))))+' days' else 'Active' end as DayRemaing,convert(varchar(3),datediff(day,getdate(),(dateadd(day,sp.DayCount,cm.CreatedDate))))as days  from dbo.Company_Master  as cm inner join ( select DayCount,CompId,Schemes from dbo.SecurityPermission)sp on sp.CompId=cm.compId where cm.CompId='" + Session["companyid"].ToString() + "' and sp.Schemes='Free Version'";
                            DataTable dt11 = db.GetDataTable(q11);
                            int days = 0;
                            if (dt11.Rows.Count != 0 && dt11 != null)
                            {
                                days = Convert.ToInt32(dt11.Rows[0]["days"].ToString());
                                Session["days"] = days;
                            }
                            if (days == 15 || days == 20 || days == 25)
                            {
                                //SendNotificationEmail(emailid);
                            }
                        }
                        HttpContext.Current.Session["lastupdate"] = lastupdate;
                        int sss = logins + 1;

                        if (stat != "Account Expired")
                        {
                            HttpContext.Current.Session["Accstat"] = ds.Tables[1].Rows[0]["DayRemaing"].ToString();
                            HttpContext.Current.Session["SuperApp"] = "";
                            HttpContext.Current.Session["Jr_ApproverId"] = "false";

                            string countdy = ds.Tables[0].Rows[0]["DaysRemainingAMC"].ToString();
                            if (Convert.ToInt32(countdy) <= 0)
                            {
                                obj.Add(new Tbl_Login()
                                {
                                    Msg = objComm.GetValue<string>("Subscription Expired contact to Saibex Network (9892606006/9004466888)"),
                                    url = "",
                                    UsrRole = objComm.GetValue<string>("Company"),

                                });
                            }
                            else
                            {
                                string u = ds.Tables[0].Rows[0]["SubDomain"].ToString();
                                string url = HttpContext.Current.Session["Urlhost"].ToString();
                                string uh = HttpContext.Current.Session["Uhost"].ToString();
                                if (u == null || u == "")
                                {
                                    uh = "localhost";
                                }
                                if (uh == "localhost")
                                {
                                    obj.Add(new Tbl_Login()
                                    {
                                        Msg = objComm.GetValue<string>(ds.Tables[0].Rows[0]["softwares"].ToString()),

                                        url = objComm.GetValue<string>("Company/Admin_Dashboard.aspx"),
                                        UsrRole = objComm.GetValue<string>("Company"),

                                    });
                                }
                                else if (url == u)
                                {   
                                    obj.Add(new Tbl_Login()
                                    {
                                        Msg = objComm.GetValue<string>(ds.Tables[0].Rows[0]["softwares"].ToString()),

                                        url = objComm.GetValue<string>("Company/Admin_Dashboard.aspx"),
                                        UsrRole = objComm.GetValue<string>("Company"),

                                    });
                                }
                                else if (url != u)
                                {
                                     
                                    obj.Add(new Tbl_Login()
                                    {
                                        Msg = objComm.GetValue<string>(url),

                                        url = objComm.GetValue<string>(u),
                                        UsrRole = objComm.GetValue<string>("Company"),

                                    });
                                }

                            }

                        }
                        else
                        {
                            obj.Add(new Tbl_Login()
                            {
                                Msg = objComm.GetValue<string>("Subscription Expired contact to Saibex Network (9892606006/9004466888)"),
                                url = "",
                                UsrRole = objComm.GetValue<string>("Company"),

                            });

                        }

                    }
                    else
                    {
                        obj.Add(new Tbl_Login()
                        {
                            Msg = objComm.GetValue<string>("Invalid Username or Password"),
                            url = "",
                            UsrRole = objComm.GetValue<string>("Company"),

                        });
                    }



                }
                else if (Roles.IsUserInRole(Session["Username"].ToString(), "staff"))
                {
                    HttpContext.Current.Session["roleid"] = "staff";
                    SqlParameter[] param = new SqlParameter[3];
                    param[0] = new SqlParameter("@username", Session["Username"].ToString());
                    param[1] = new SqlParameter("@password", Session["Password"].ToString());
                    param[2] = new SqlParameter("@IsApproved", "true");
                    DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Staff_Login", param);
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        string dtl = "";
                        dtl = ds.Tables[0].Rows[0]["DateOfLeaving"].ToString();
                        if (dtl != "")
                        {
                            obj.Add(new Tbl_Login()
                            {
                                Msg = objComm.GetValue<string>("Staff Resigned"),
                                url = "",
                                UsrRole = objComm.GetValue<string>("staff"),

                            });

                        }
                        else
                        {

                            HttpContext.Current.Session["CompanyName"] = ds.Tables[0].Rows[0]["CompanyName"].ToString();
                            HttpContext.Current.Session["Name"] = ds.Tables[0].Rows[0]["username"].ToString();
                            HttpContext.Current.Session["fulname"] = ds.Tables[0].Rows[0]["StaffName"].ToString();
                            HttpContext.Current.Session["companyid"] = Convert.ToInt32(ds.Tables[0].Rows[0]["CompId"].ToString());
                            HttpContext.Current.Session["UserRole"] = Convert.ToInt32(ds.Tables[0].Rows[0]["staff_Roll"].ToString());
                            HttpContext.Current.Session["RoleName"] = ds.Tables[0].Rows[0]["Rolename"].ToString();
                            /////////////////ganesh timesheet input type
                            HttpContext.Current.Session["ApproverPattern"] = ds.Tables[0].Rows[0]["Dual_Approver"].ToString();
                            HttpContext.Current.Session["DualApprovers"] = ds.Tables[0].Rows[0]["Dual_Approver"].ToString();
                            HttpContext.Current.Session["Expenses"] = ds.Tables[0].Rows[0]["expense"].ToString();
                            HttpContext.Current.Session["Narration"] = ds.Tables[0].Rows[0]["Narration"].ToString();
                            HttpContext.Current.Session["deptwise"] = ds.Tables[0].Rows[0]["deptwise"].ToString();
                            HttpContext.Current.Session["taskwise"] = ds.Tables[0].Rows[0]["taskwise"].ToString();
                            HttpContext.Current.Session["PageLevel"] = ds.Tables[0].Rows[0]["PageLevel"].ToString();
                            HttpContext.Current.Session["DaysRemaining"] = ds.Tables[0].Rows[0]["DaysRemainingAMC"].ToString();
                            HttpContext.Current.Session["Currency"] = ds.Tables[0].Rows[0]["Currency"].ToString();
                            HttpContext.Current.Session["ApproverPattern"] = ds.Tables[0].Rows[0]["Dual_Approver"].ToString();
                            HttpContext.Current.Session["StaffQuta"] = ds.Tables[0].Rows[0]["StaffQuta"].ToString();
                            HttpContext.Current.Session["StaffActive"] = ds.Tables[0].Rows[0]["StaffActive"].ToString();
                            HttpContext.Current.Session["Drawing"] = ds.Tables[0].Rows[0]["Drawing"].ToString();
                            string das = ds.Tables[0].Rows[0]["DashboardType"].ToString();
                            /////////////////ganesh timesheet input type
                            string rl = ds.Tables[0].Rows[0]["Rolename"].ToString();
                            if (rl == "Company-Admin")
                            {
                                HttpContext.Current.Session.Add("usertype", "company");
                                HttpContext.Current.Session.Add("UserRole", "Admin");
                            }
                            else
                            {
                                HttpContext.Current.Session.Add("usertype", "staff");
                            }


                            HttpContext.Current.Session.Add("staffid", ds.Tables[0].Rows[0]["StaffCode"].ToString());
                            HttpContext.Current.Session.Add("staffname", ds.Tables[0].Rows[0]["username"].ToString());
                            if (ds.Tables[0].Rows[0]["AllowCheckedInCheckOut"] != DBNull.Value)
                            {


                                if (Convert.ToBoolean(ds.Tables[0].Rows[0]["AllowCheckedInCheckOut"]) == true)
                                {
                                    HttpContext.Current.Session.Add("AllowCheckedInCheckOut", true);
                                    if (ds.Tables[0].Rows[0]["AttendanceDate"] != DBNull.Value)
                                    {
                                        HttpContext.Current.Session.Add("AttendanceDate", ds.Tables[0].Rows[0]["AttendanceDate"].ToString());
                                    }
                                    if (ds.Tables[0].Rows[0]["CheckInDate"] != DBNull.Value)
                                    {
                                        HttpContext.Current.Session.Add("CheckInDate", ds.Tables[0].Rows[0]["CheckInDate"].ToString());
                                    }
                                    if (ds.Tables[0].Rows[0]["CheckOutDate"] != DBNull.Value)
                                    {
                                        HttpContext.Current.Session.Add("CheckOutDate", ds.Tables[0].Rows[0]["CheckOutDate"].ToString());
                                    }
                                    if (ds.Tables[0].Rows[0]["TotalTime"] != DBNull.Value)
                                    {
                                        HttpContext.Current.Session.Add("TotalTime", ds.Tables[0].Rows[0]["TotalTime"].ToString());
                                    }
                                }
                                else
                                {
                                    HttpContext.Current.Session.Add("AllowCheckedInCheckOut", false);
                                }
                            }
                            else
                            {
                                HttpContext.Current.Session.Add("AllowCheckedInCheckOut", false);
                            }

                            HttpContext.Current.Session["Timesheet"] = "true";

                            string stf = HttpContext.Current.Session["staffid"].ToString();
                            string stf1 = stf + 'y';
                            HttpContext.Current.Session["SuperApp"] = stf1;
                            if (ds.Tables[1].Rows.Count > 0)
                            {
                                HttpContext.Current.Session["Jr_ApproverId"] = "true";
                            }
                            else
                            {
                                HttpContext.Current.Session["Jr_ApproverId"] = "false";
                            }
                            //Response.Redirect("Company/Staff_Dashoard.aspx?p=1");

                            string remin = ds.Tables[0].Rows[0]["DaysRemainingAMC"].ToString();
                            if (Convert.ToInt32(remin) <= 0)
                            {
                                obj.Add(new Tbl_Login()
                                {
                                    Msg = objComm.GetValue<string>("Subscription Expired contact to Saibex Network (9892606006/9004466888)"),
                                    url = "",
                                    UsrRole = objComm.GetValue<string>("staff"),

                                });
                            }
                            else if (rl == "Company-Admin")
                            {
                                obj.Add(new Tbl_Login()
                                {
                                    Msg = objComm.GetValue<string>(ds.Tables[0].Rows[0]["softwares"].ToString()),
                                    url = objComm.GetValue<string>("Company/Admin_Dashboard.aspx"),
                                    UsrRole = objComm.GetValue<string>("Company"),
                                });
                            }

                            else if(das=="Yes")
                            {
                                obj.Add(new Tbl_Login()
                                {
                                    Msg = objComm.GetValue<string>(ds.Tables[0].Rows[0]["softwares"].ToString()),
                                    UsrRole = objComm.GetValue<string>("staff"),
                                    url = objComm.GetValue<string>("Company/Director_Dashboard.aspx"),
                                });
                            }
                            else
                            {
                                obj.Add(new Tbl_Login()
                                {
                                    Msg = objComm.GetValue<string>(ds.Tables[0].Rows[0]["softwares"].ToString()),
                                    UsrRole = objComm.GetValue<string>("staff"),
                                    url = objComm.GetValue<string>("Company/Staff_Dashoard.aspx"),
                                });
                            }
                        }
                    }
                    else
                    {
                        obj.Add(new Tbl_Login()
                        {
                            Msg = objComm.GetValue<string>("Invalid Username or Password"),

                            UsrRole = objComm.GetValue<string>("staff"),

                        });
                    }

                }

            }
            else
            {
                obj.Add(new Tbl_Login()
                {
                    Msg = objComm.GetValue<string>("Invalid Username or Password"),
                    url = "",
                });

            }

        }
        catch (Exception ex)
        {
            //throw ex;
        }

        IEnumerable<Tbl_Login> tbl = obj as IEnumerable<Tbl_Login>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }
    public string GetFullAddress(string latitude, string longitude)
    {
        //to Read the Stream
        StreamReader sr = null;
        string GoogleMapAPIKey = WebConfigurationManager.AppSettings["GoogleMapAPIKey"].ToString();
        //The Google Maps API Either return JSON or XML. We are using XML Here
        //Saving the url of the Google API 
        string url = string.Format("https://maps.googleapis.com/maps/api/geocode/xml?latlng={0},{1}&sensor=false&key=" + GoogleMapAPIKey, latitude, longitude);

        string Full_address = string.Empty;

        if (string.IsNullOrEmpty(latitude) || string.IsNullOrEmpty(longitude))
        {
            return "Location access denied by user";
        }
        //to Send the request to Web Client 
        WebClient wc = new WebClient();
        try
        {
            sr = new StreamReader(wc.OpenRead(url));
        }
        catch (Exception ex)
        {
            throw new Exception("The Error Occured" + ex.Message);
        }

        try
        {
            XmlTextReader xmlReader = new XmlTextReader(sr);
            bool latread = false;
            bool longread = false;
            bool addread = false;

            while (xmlReader.Read())
            {
                xmlReader.MoveToElement();
                switch (xmlReader.Name)
                {
                    case "lat":

                        if (!latread)
                        {
                            xmlReader.Read();
                            latitude = xmlReader.Value.ToString();
                            latread = true;

                        }
                        break;
                    case "lng":
                        if (!longread)
                        {
                            xmlReader.Read();
                            longitude = xmlReader.Value.ToString();
                            longread = true;
                        }
                        break;
                    case "formatted_address":
                        if (!addread)
                        {
                            xmlReader.Read();
                            Full_address = xmlReader.Value.ToString();
                            addread = true;
                        }
                        break;
                }
            }
        }
        catch (Exception ex)
        {
            Full_address = "Failed to retrive Address";
        }
        return Full_address;
    }

    [WebMethod]
    public string GetDepartments(int compId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<Department_Master> listDepartmentMaster = new List<Department_Master>();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@CompId", compId);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Departments", param))
            {
                while (drrr.Read())
                {
                    listDepartmentMaster.Add(new Department_Master()
                    {
                        DepId = objComm.GetValue<int>(drrr["DepId"].ToString()),
                        DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString())
                    });
                }

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(listDepartmentMaster);
    }
    [WebMethod]
    public string GetHolidays(int compId, string month)
    {
        CommonFunctions objComm = new CommonFunctions();
        CultureInfo ci = new CultureInfo("en-GB");
        string monthDate = month != "" ? Convert.ToDateTime(month, ci).ToString("MM/dd/yyyy") : null;
        HolidaysMaster holidayMaster = new HolidaysMaster();
        try
        {
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@CompID", compId);
            param[1] = new SqlParameter("@SelectedMonth", monthDate);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetHolidays", param))
            {
                while (drrr.Read())
                {
                    holidayMaster.weeklyHolidays = new tbl_Weekly_Holidays()
                    {
                        Sun = objComm.GetValue<bool>(drrr["Sun"].ToString()),
                        Mon = objComm.GetValue<bool>(drrr["Mon"].ToString()),
                        Tue = objComm.GetValue<bool>(drrr["Tue"].ToString()),
                        Wed = objComm.GetValue<bool>(drrr["Wed"].ToString()),
                        Thu = objComm.GetValue<bool>(drrr["Thu"].ToString()),
                        Fri = objComm.GetValue<bool>(drrr["Fri"].ToString()),
                        Sat = objComm.GetValue<bool>(drrr["Sat"].ToString())
                    };
                }
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        List<tbl_Monthly_Holidays> listMonthlyHolidays = new List<tbl_Monthly_Holidays>();
                        while (drrr.Read())
                        {
                            listMonthlyHolidays.Add(new tbl_Monthly_Holidays()
                            {
                                HolidayDate = objComm.GetValue<string>(drrr["HolidayDate"].ToString())
                            });
                        }
                        holidayMaster.list_Monthly_Holidays = listMonthlyHolidays;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(holidayMaster);
    }
    [WebMethod]
    public string GetClients(int compId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<_Bind_clients> objClientsList = new List<_Bind_clients>();
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@CompId", compId);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetClients", param))
            {
                while (drrr.Read())
                {
                    objClientsList.Add(new _Bind_clients()
                    {
                        ClientId = objComm.GetValue<int>(drrr["ClientId"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(objClientsList);
    }

    [WebMethod]
    public string GetStaffsLeaves(int compId, string searchMonth, string staffCodes)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Staff_Leave> leaves = new List<tbl_Staff_Leave>();

        string monthDate = searchMonth != "" ? Convert.ToDateTime(searchMonth).ToString("MM/dd/yyyy") : null;
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@CompId", compId);
            param[1] = new SqlParameter("@SearchMonth", monthDate);
            param[2] = new SqlParameter("@StaffCodes", staffCodes);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetStaffsLeaves", param))
            {
                while (drrr.Read())
                {
                    leaves.Add(new tbl_Staff_Leave()
                    {
                        StaffId = objComm.GetValue<int>(drrr["Employee_ID"].ToString()),
                        StartDate = objComm.GetValue<string>(drrr["Start_DT"].ToString()),
                        EndDate = objComm.GetValue<string>(drrr["End_DT"].ToString()),
                        LeaveDays = objComm.GetValue<decimal>(drrr["Leave_Days"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(leaves);
    }


    [WebMethod]
    public string GetStaffs(int compId)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<staffs> staff = new List<staffs>();

        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@CompId", compId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetStaffs", param))
            {
                while (drrr.Read())
                {
                    staff.Add(new staffs()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(staff);
    }
    [System.Web.Services.WebMethod(EnableSession = true)]
    public string Logout()
    {
        HttpContext.Current.Session.Clear();
        HttpContext.Current.Session.RemoveAll();
        HttpContext.Current.Session.Abandon();
        HttpContext.Current.Response.Cookies.Add(new HttpCookie("tmxuserInfo", ""));

        //HttpCookie userInfo = new HttpCookie("tmxuserInfo");
        //HttpCookie nameCookie = HttpContext.Current.Request.Cookies["userInfo"];

        ////Set the Expiry date to past date.
        //nameCookie.Expires = DateTime.Now.AddDays(-1);

        //Update the Cookie in Browser.
        //HttpContext.Current.Response.Cookies.Add(nameCookie);
        //HttpContext.Current.Response.Cookies["tmxlogin"].Value = "false";
        //HttpContext.Current.Response.Cookies["tmxlogin"].Expires.AddDays(-1);
        //    HttpContext.Current.Request.Cookies.Clear();
        //HttpContext.Current.Response.Cookies.Clear();

        //HttpCookie logged_in = HttpContext.Current.Request.Cookies["tmxuserInfo"];
        //if (logged_in != null)
        //{
        //    //Set the Expiry date to past date.
        //    logged_in.Expires = DateTime.Now.AddDays(-1);

        //    //Update the Cookie in Browser.
        //    HttpContext.Current.Response.Cookies.Add(logged_in);
        //}
        return "true";
    }


}