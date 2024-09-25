<%@ WebService Language="C#" Class="ProjectandStaff_Budgeting" %>

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
using System.Web.Script.Services;
using System.Linq;
using JTMSProject;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ProjectandStaff_Budgeting : System.Web.Services.WebService
{

    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    [WebMethod]
    public string FillClient(int Compid)
    {

        List<tbl_Projectstaff_Budg> List_Clint = new List<tbl_Projectstaff_Budg>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Compid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_BudgetClient", param))
            //using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_BudgetClient", param))
            {
                while (drrr.Read())
                {
                    List_Clint.Add(new tbl_Projectstaff_Budg()
                    {
                        Cltid = objComm.GetValue<int>(drrr["Cltid"].ToString()),
                        clientname = objComm.GetValue<string>(drrr["Clientname"].ToString()),
                    });
                }

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Projectstaff_Budg> tbl = List_Clint as IEnumerable<tbl_Projectstaff_Budg>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string FillProject(int Compid, int Cltid, string Job)
    {

        List<tbl_Projectstaff_Budg> List_Proj = new List<tbl_Projectstaff_Budg>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@cltid", Cltid);
            param[2] = new SqlParameter("@jobid", Job);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_BudgetProject", param))
            {
                while (drrr.Read())
                {
                    List_Proj.Add(new tbl_Projectstaff_Budg()
                    {
                        Projectname = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        multid = objComm.GetValue<string>(drrr["Projectid"].ToString()),
                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Projectstaff_Budg> tbl = List_Proj as IEnumerable<tbl_Projectstaff_Budg>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string FillStaffName(int Compid, int Jobid, int pageIndex, int pageNewSize, string sid)
    {
        List<tbl_Projectstaff_Budg> List_staff = new List<tbl_Projectstaff_Budg>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@jobid", Jobid);
            param[2] = new SqlParameter("@PageIndex", pageIndex);
            param[3] = new SqlParameter("@PageSize", pageNewSize);
            param[4] = new SqlParameter("@sid", sid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_BudgetStaffName", param))
            {
                while (drrr.Read())
                {
                    List_staff.Add(new tbl_Projectstaff_Budg()
                    {
                        Srno = objComm.GetValue<int>(drrr["Srno"].ToString()),
                        Jobid = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                        StaffCode = objComm.GetValue<int>(drrr["staffcode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        BudgetHrs = objComm.GetValue<int>(drrr["Budgethours"].ToString()),
                        AllocateHrs = objComm.GetValue<int>(drrr["AllocatedHours"].ToString()),
                        BudgetAmt = objComm.GetValue<int>(drrr["BudgetAmount"].ToString()),
                        ActualAmt = objComm.GetValue<int>(drrr["HourlyCharges"].ToString()),
                        frmdate = objComm.GetValue<string>(drrr["FromDate"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Projectstaff_Budg> tbl = List_staff as IEnumerable<tbl_Projectstaff_Budg>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string ProjectBudgSingle(int Compid, int Jobid)
    {
        List<tbl_ProjChk> List_staff = new List<tbl_ProjChk>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@jobid", Jobid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_ProjBudget_last", param))

            {
                while (drrr.Read())
                {
                    List_staff.Add(new tbl_ProjChk()
                    {
                        FromDt = objComm.GetValue<string>(drrr["FromDate"].ToString()),
                        BudHrs = objComm.GetValue<int>(drrr["BudHours"].ToString()),
                        BudAmt = objComm.GetValue<int>(drrr["BudAmt"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjChk> tbl = List_staff as IEnumerable<tbl_ProjChk>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string SavetheBudgetFirst(int Compid, int Jobid, int Projid, string Hours, int Amt, string FromDt, int cltid, string Budget_type, int totAllothrs, int totBudgAmt)
    {
        List<tbl_Projectstaff_Budg> List_staffbudget = new List<tbl_Projectstaff_Budg>();
        string fromdate = FromDt != "" ? Convert.ToDateTime(FromDt, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[10];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@projid", Projid);
            param[2] = new SqlParameter("@jobid", Jobid);
            param[3] = new SqlParameter("@Hours", Hours);
            param[4] = new SqlParameter("@amt", Amt);
            param[5] = new SqlParameter("@fdate", fromdate);
            param[6] = new SqlParameter("@cltid", cltid);
            param[7] = new SqlParameter("@Budget_Type", Budget_type);
            param[8] = new SqlParameter("@AllocateHrs", totAllothrs);
            param[9] = new SqlParameter("@ActulAmt", totBudgAmt);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Insert_ProjBudget", param))
            {
                while (drrr.Read())
                {
                    List_staffbudget.Add(new tbl_Projectstaff_Budg()
                    {
                        PrjectId = objComm.GetValue<int>(drrr["Budget_Id"].ToString()),
                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Projectstaff_Budg> tbl = List_staffbudget as IEnumerable<tbl_Projectstaff_Budg>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string FillBudgetGrid(int Compid, string Srch)
    {
        List<tbl_BudgetGrid> List_Budg = new List<tbl_BudgetGrid>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@srch", Srch);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Budget_Gtable", param))
            {
                while (drrr.Read())
                {
                    List_Budg.Add(new tbl_BudgetGrid()
                    {
                        Srno = objComm.GetValue<int>(drrr["Srno"].ToString()),
                        clientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        BudHrs = objComm.GetValue<string>(drrr["BudgetHours"].ToString()),
                        Jobid = objComm.GetValue<int>(drrr["JobId"].ToString()),
                        Budget_type = objComm.GetValue<string>(drrr["Budget_Type"].ToString()),
                        cltid = objComm.GetValue<int>(drrr["CltId"].ToString()),
                        staffcount = objComm.GetValue<int>(drrr["StaffCount"].ToString()),
                        multid = objComm.GetValue<string>(drrr["multid"].ToString()),
                        Project_Date = objComm.GetValue<string>(drrr["Project_Date"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_BudgetGrid> tbl = List_Budg as IEnumerable<tbl_BudgetGrid>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    //[WebMethod]
    //public string Editprojectlastrecord(int Compid, int Projid)
    //{
    //    List<tbl_ProjChk> List_projE = new List<tbl_ProjChk>();
    //    try
    //    {
    //        Common ob = new Common();
    //        SqlParameter[] param = new SqlParameter[2];
    //        param[0] = new SqlParameter("@compid", Compid);
    //        param[1] = new SqlParameter("@Peojectid", Projid);
    //        using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Edit_Projectbudget_Table", param))
    //        {
    //            while (drrr.Read())
    //            {
    //                List_projE.Add(new tbl_ProjChk()
    //                {
    //                    FromDt = objComm.GetValue<string>(drrr["FromDate"].ToString()),
    //                    BudHrs = objComm.GetValue<int>(drrr["BudHours"].ToString()),
    //                    BudAmt = objComm.GetValue<int>(drrr["BudAmt"].ToString()),
    //                    Todate = objComm.GetValue<string>(drrr["ToDate"].ToString()),
    //                });
    //            }
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //    IEnumerable<tbl_ProjChk> tbl = List_projE as IEnumerable<tbl_ProjChk>;
    //    var obbbbb = tbl;
    //    return new JavaScriptSerializer().Serialize(tbl);
    //}


    //Save Staff Budget first time
    [WebMethod]
    public string SaveStaffBudget(int Compid, int Projid, int Jobid, int Cltid, string frdate, string stfb, string Budgetype, int AllocateHrs, int ActulAmt)
    {
        List<tbl_Projectstaff_Budg> List_Staffb = new List<tbl_Projectstaff_Budg>();
        string fromdate = frdate != "" ? Convert.ToDateTime(frdate, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@projid", Projid);
            param[2] = new SqlParameter("@jobid", Jobid);
            param[3] = new SqlParameter("@frdate", fromdate);
            param[4] = new SqlParameter("@sffbudg", stfb);
            param[5] = new SqlParameter("@Budgetype", Budgetype);
            param[6] = new SqlParameter("@cltid", Cltid);
            param[7] = new SqlParameter("@AllocateHrs", AllocateHrs);
            param[8] = new SqlParameter("@ActulAmt", ActulAmt);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Save_Budget", param))
            {
                while (drrr.Read())
                {
                    List_Staffb.Add(new tbl_Projectstaff_Budg()
                    {
                        PrjectId = objComm.GetValue<int>(drrr["Budget_Id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Projectstaff_Budg> tbl = List_Staffb as IEnumerable<tbl_Projectstaff_Budg>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string BudgetDelete(int Compid, int Clt, int Jobid, string Budgtyp,string ip, string usr, string ut, string dt)
    {
        List<tbl_ProjChk> List_delete = new List<tbl_ProjChk>();
        DBAccess db = new DBAccess();
        DBAccess.PrintDelete(ip ,"Project/Staff Budgeting", usr, ut, dt);
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Compid);
            param[1] = new SqlParameter("@clt", Clt);
            param[2] = new SqlParameter("@jobid", Jobid);
            param[3] = new SqlParameter("@budgetype", Budgtyp);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_BudgetDelete", param))
            {
                while (drrr.Read())
                {
                    List_delete.Add(new tbl_ProjChk()
                    {
                        id = objComm.GetValue<int>(drrr["id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjChk> tbl = List_delete as IEnumerable<tbl_ProjChk>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string SetServerJobWiseBudgetDetails(UserDetails id)
    {
        List<UserDetails> details = new List<UserDetails>();
        try
        {
            Common ob = new Common();
            CultureInfo ci = new CultureInfo("en-GB");
            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", id.compid);
            param[1] = new SqlParameter("@jobid", id.jobid);
            param[2] = new SqlParameter("@otheram", id.StaffCode);
            param[3] = new SqlParameter("@BudgetAmt", id.BudgetAmt);
            param[4] = new SqlParameter("@Budgethours", id.Budgethours);
            param[5] = new SqlParameter("@temp_Id", id.temp_Id);
            param[6] = new SqlParameter("@fromdate", Convert.ToDateTime(id.fromdate, ci));
            DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Ajax_EditJob_SetServerJobWiseBudgetDetails", param);
            if (dss != null)
            {
                if (dss.Tables[0].Rows.Count > 0)
                {
                    if (dss.Tables[0].Rows[0][0].ToString() == "Error")
                    {
                        UserDetails user = new UserDetails();
                        user.StaffCode = "Error";
                        details.Add(user);
                    }
                    foreach (DataRow dtrow in dss.Tables[1].Rows)
                    {
                        UserDetails user = new UserDetails();
                        user.StaffCode = dtrow["otherAmt"].ToString();
                        user.todate = dtrow["todate"].ToString();
                        user.fromdate = dtrow["fromdate"].ToString();
                        user.BudgetAmt = dtrow["BudAmt"].ToString();
                        user.Budgethours = dtrow["Budhours"].ToString();
                        user.temp_Id = dtrow["Budget_Master_Temp_id"].ToString();
                        details.Add(user);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        var obbbbb = details;
        return new JavaScriptSerializer().Serialize(details);
    }

    [WebMethod]
    public string SaveOrUpdateBudget(UserDetails id)
    {
        List<UserDetails> details = new List<UserDetails>();
        try
        {
            Common ob = new Common();
            CultureInfo ci = new CultureInfo("en-GB");
            SqlParameter[] param = new SqlParameter[10];
            param[0] = new SqlParameter("@compid", id.compid);
            param[1] = new SqlParameter("@jobid", id.jobid);
            param[2] = new SqlParameter("@StaffCode", id.StaffCode);
            param[3] = new SqlParameter("@BudgetAmt", id.BudgetAmt);
            param[4] = new SqlParameter("@Budgethours", id.Budgethours);
            param[5] = new SqlParameter("@temp_Id", id.temp_Id);
            param[6] = new SqlParameter("@fromdate", Convert.ToDateTime(id.fromdate, ci));
            param[7] = new SqlParameter("@PlanedDrawing", id.PlanedDrawing);
            param[8] = new SqlParameter("@AllocatedHours", id.AllocatedHours);
            param[9] = new SqlParameter("@StaffActualHourRate", id.StaffActualHourRate);
            DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Ajax_EditJob_SaveOrUpdateBudget", param);
            if (dss != null)
            {
                if (dss.Tables[0].Rows.Count > 0)
                {
                    if (dss.Tables[0].Rows[0][0].ToString() == "Error")
                    {
                        UserDetails user = new UserDetails();
                        user.StaffCode = "Error";
                        details.Add(user);
                    }
                    foreach (DataRow dtrow in dss.Tables[1].Rows)
                    {
                        UserDetails user = new UserDetails();
                        user.temp_Id = dtrow["StaffbugdgetingTemp_Id"].ToString();
                        user.fromdate = dtrow["fromdate"].ToString();
                        user.todate = dtrow["todate"].ToString();
                        user.BudgetAmt = dtrow["BudgetAmount"].ToString();
                        user.Budgethours = dtrow["Budgethours"].ToString();
                        user.StaffActualHourRate = dtrow["StaffActualHourRate"].ToString();
                        user.AllocatedHours = dtrow["AllocatedHours"].ToString();
                        details.Add(user);
                    }
                }
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        var obbbbb = details;
        return new JavaScriptSerializer().Serialize(details);
    }

    [WebMethod]
    public string GetServerJobWiseBudgetDetails(int jobid, int compid)
    {
        List<UserDetails> details = new List<UserDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", jobid);
            DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Project_temp_insert", param);
            if (dss != null)
            {
                if (dss.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dtrow in dss.Tables[0].Rows)
                    {
                        UserDetails user = new UserDetails();
                        user.StaffCode = dtrow["otherAmt"].ToString();
                        user.todate = dtrow["todate"].ToString();
                        user.fromdate = dtrow["fromdate"].ToString();
                        user.BudgetAmt = dtrow["BudAmt"].ToString();
                        user.Budgethours = dtrow["Budhours"].ToString();
                        user.temp_Id = dtrow["Budget_Master_Temp_id"].ToString();
                        details.Add(user);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        var obbbbb = details;
        return new JavaScriptSerializer().Serialize(details);

    }

    [WebMethod]
    public string GetStafftempdata(int compid, int jobid, int staffcode)
    {
        List<UserDetails> details = new List<UserDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", jobid);
            param[2] = new SqlParameter("@staffcode", staffcode);
            DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Staff_temp_insert", param);
            if (dss != null)
            {
                if (dss.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dtrow in dss.Tables[0].Rows)
                    {
                        UserDetails user = new UserDetails();

                        user.todate = dtrow["todate"].ToString();
                        user.fromdate = dtrow["fromdate"].ToString();
                        user.BudgetAmt = dtrow["BudgetAmount"].ToString();
                        user.Budgethours = dtrow["Budgethours"].ToString();
                        user.AllocatedHours = dtrow["AllocatedHours"].ToString();
                        user.StaffActualHourRate = dtrow["StaffActualHourRate"].ToString();
                        user.temp_Id = dtrow["StaffbugdgetingTemp_Id"].ToString();
                        details.Add(user);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        var obbbbb = details;
        return new JavaScriptSerializer().Serialize(details);
    }

    [WebMethod]
    public string GetServerEditOnJobWiseTempId(UserDetails id)
    {
        List<UserDetails> details = new List<UserDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@temp_Id", id.temp_Id);
            DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Ajax_EditJob_GetServerEditOnJobWiseTempId", param);
            if (dss != null)
            {
                if (dss.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dtrow in dss.Tables[0].Rows)
                    {
                        UserDetails user = new UserDetails();
                        user.fromdate = dtrow["fromdate"].ToString();
                        user.BudgetAmt = dtrow["BudAmt"].ToString();
                        user.Budgethours = dtrow["BudHours"].ToString();
                        details.Add(user);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        var obbbbb = details;
        return new JavaScriptSerializer().Serialize(details);
    }

    [WebMethod]
    public string Update_ProjectStaff(int compid, int jobid, int projectid, string type)
    {
        List<UserDetails> details = new List<UserDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", jobid);
            param[2] = new SqlParameter("@Projectid", projectid);
            param[3] = new SqlParameter("@type", type);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Update_ProjectandStaff_Budget", param))
            {
                while (drrr.Read())
                {
                    details.Add(new UserDetails()
                    {
                        jobid = objComm.GetValue<int>(drrr["jobid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<UserDetails> tbl = details as IEnumerable<UserDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string CancelDeltemp(int compid, int jobid)
    {
        List<tbl_ProjChk> del = new List<tbl_ProjChk>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@jobid", jobid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Delete_Tempbudg", param))
            {
                while (drrr.Read())
                {
                    del.Add(new tbl_ProjChk()
                    {
                        id = objComm.GetValue<int>(drrr["id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjChk> tbl = del as IEnumerable<tbl_ProjChk>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetTempIDStaffDetails(UserDetails id)
    {
        List<UserDetails> details = new List<UserDetails>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@temp_Id", id.temp_Id);
            DataSet dss = SqlHelper.ExecuteDataset(ob._cnnString, CommandType.StoredProcedure, "usp_Ajax_EditJob_GetTempIDDetails", param);
            if (dss != null)
            {
                if (dss.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow dtrow in dss.Tables[0].Rows)
                    {
                        UserDetails user = new UserDetails();
                        user.fromdate = dtrow["fromdate"].ToString();
                        user.BudgetAmt = dtrow["BudgetAmount"].ToString();
                        user.Budgethours = dtrow["Budgethours"].ToString();
                        user.PlanedDrawing = dtrow["PlanedDrawing"].ToString();
                        user.StaffActualHourRate = dtrow["StaffActualHourRate"].ToString();
                        user.AllocatedHours = dtrow["AllocatedHours"].ToString();
                        details.Add(user);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<UserDetails> tbl = details as IEnumerable<UserDetails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    public class UserDetails
    {
        public string StaffCode { get; set; }
        public string BudgetAmt { get; set; }
        public string Budgethours { get; set; }
        public string temp_Id { get; set; }
        public string fromdate { get; set; }
        public string todate { get; set; }

        public string PlanedDrawing { get; set; }
        public string CompletedDrawing { get; set; }
        public string StaffActualHourRate { get; set; }

        public string AllocatedHours { get; set; }
        public int jobid { get; set; }
        public int compid { get; set; }
    }
}
