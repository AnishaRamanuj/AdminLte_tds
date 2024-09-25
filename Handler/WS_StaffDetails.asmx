<%@ WebService Language="C#" Class="WS_StaffDetails" %>

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
public class WS_StaffDetails : System.Web.Services.WebService
{
    public SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");


    [WebMethod]
    public string Get_Staff_List(int compid, string Fdate, string todate)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<StaffListDatails> List_SM = new List<StaffListDatails>();

        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@fromdate", Convert.ToDateTime(Fdate, ci));
            param[2] = new SqlParameter("@todate", Convert.ToDateTime(todate, ci));

            //   DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "Usp_Get_Staff_for_Project_Details", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "Usp_Get_Staff_for_Project_Details", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new StaffListDatails()
                    {
                        id = objComm.GetValue<int>(drrr["id"].ToString()),
                        PNAME = objComm.GetValue<string>(drrr["NAME"].ToString()),
                        Type = objComm.GetValue<string>(drrr["Type"].ToString())
                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<StaffListDatails> tbl = List_SM as IEnumerable<StaffListDatails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetStaffRecord(int compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_staff> List_DS = new List<tbl_staff>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@search", Srch);
            param[2] = new SqlParameter("@pageindex", pageIndex);
            param[3] = new SqlParameter("@pagesize", pageSize);
            // DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_getstaff", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_getstaff", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_staff()
                    {
                        Compid = objComm.GetValue<int>(drrr["Compid"].ToString()),
                    });
                }

                List<tbl_staffMasterdetail> liststaffrec = new List<tbl_staffMasterdetail>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            liststaffrec.Add(new tbl_staffMasterdetail()
                            {
                                srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                                Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                Desig = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                                Dept = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                                HrsCharg = objComm.GetValue<int>(drrr["HourlyCharges"].ToString()),
                                Contractwork = objComm.GetValue<string>(drrr["Emp_Type"].ToString()),
                                Empid = objComm.GetValue<string>(drrr["staffBioServerid"].ToString()),
                                Phone = objComm.GetValue<string>(drrr["Mobile"].ToString()),
                                Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                            });
                        }
                    }
                }

                List<tbl_staffcount> liststaffcount = new List<tbl_staffcount>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            liststaffcount.Add(new tbl_staffcount()
                            {
                                staffcount = objComm.GetValue<int>(drrr["staffcount"].ToString()),


                            });
                        }
                    }
                }
                List<tbl_stafflimit> liststafflimit = new List<tbl_stafflimit>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            liststafflimit.Add(new tbl_stafflimit()
                            {
                                Stafflimit = objComm.GetValue<int>(drrr["Stafflimit"].ToString()),


                            });
                        }
                    }
                }
                foreach (var item in List_DS)
                {
                    item.list_staffMasterdetail = liststaffrec;
                    item.list_staffcount = liststaffcount;
                    item.list_stafflimit = liststafflimit;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_staff> tbl = List_DS as IEnumerable<tbl_staff>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetAlldropdown(int compid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Staffdropdwon> List_DS = new List<tbl_Staffdropdwon>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);

            //DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_getStaffdropdown", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_getStaffdropdown", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Staffdropdwon()
                    {
                        Compid = objComm.GetValue<int>(drrr["Compid"].ToString()),
                    });
                }
                List<Branch_Master> listBranchMaster = new List<Branch_Master>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listBranchMaster.Add(new Branch_Master()
                            {
                                BrId = objComm.GetValue<int>(drrr["BrId"].ToString()),
                                BranchName = objComm.GetValue<string>(drrr["BranchName"].ToString()),

                            });
                        }
                    }
                }
                List<Department_Master> listDepartmentMaster = new List<Department_Master>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listDepartmentMaster.Add(new Department_Master()
                            {
                                DepId = objComm.GetValue<int>(drrr["DepId"].ToString()),
                                DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),

                            });
                        }
                    }
                }
                List<Designation_Master> listDesignationMaster = new List<Designation_Master>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listDesignationMaster.Add(new Designation_Master()
                            {
                                DsgId = objComm.GetValue<int>(drrr["DsgId"].ToString()),
                                DesignationName = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                                HourlyCharges = objComm.GetValue<int>(drrr["HourlyCharges"].ToString()),
                            });
                        }
                    }
                }
                List<tbl_RoleMaster> listRoleMaster = new List<tbl_RoleMaster>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listRoleMaster.Add(new tbl_RoleMaster()
                            {
                                sRoleID = objComm.GetValue<int>(drrr["RoleID"].ToString()),
                                sRoleName = objComm.GetValue<string>(drrr["Rolename"].ToString()),

                            });
                        }
                    }
                }
                List<tbl_Staffrole> liststaffroleid = new List<tbl_Staffrole>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            liststaffroleid.Add(new tbl_Staffrole()
                            {
                                staffroleid = objComm.GetValue<int>(drrr["RoleID"].ToString()),

                            });
                        }
                    }
                }

                foreach (var item in List_DS)
                {
                    item.list_BranchMaster = listBranchMaster;
                    item.list_DepartmentMaster = listDepartmentMaster;
                    item.list_DesignationMaster = listDesignationMaster;
                    item.list_RoleMaster = listRoleMaster;
                    item.list_staffroleid = liststaffroleid;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Staffdropdwon> tbl = List_DS as IEnumerable<tbl_Staffdropdwon>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertNewStaff(int compid, string rid, string DOJ, string DoL, string UserName, string Comfpass, int Hourlychrg,string Emailid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<StaffListDatails> List_SM = new List<StaffListDatails>();
        string DOJs = DOJ != "" ? Convert.ToDateTime(DOJ, ci).ToString("MM/dd/yyyy") : null;
        string DoLs = DoL != "" ? Convert.ToDateTime(DoL, ci).ToString("MM/dd/yyyy") : null;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@DOJs", DOJs);
            param[2] = new SqlParameter("@DoLs", DoLs);
            param[4] = new SqlParameter("@rid", rid);
            param[5] = new SqlParameter("@UserName", UserName);
            param[6] = new SqlParameter("@Comfpass", Comfpass);
            param[7] = new SqlParameter("@Hourlychrg", Hourlychrg);
            param[8] = new SqlParameter("@emailid", Emailid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_InsertNewStaff", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new StaffListDatails()
                    {
                        id = objComm.GetValue<int>(drrr["staffcode"].ToString()),

                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<StaffListDatails> tbl = List_SM as IEnumerable<StaffListDatails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string EditStaff(int compid, int staffcode)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_staffMasterEdit> List_SM = new List<tbl_staffMasterEdit>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);

            //DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_EditStaffMaster", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_EditStaffMaster", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_staffMasterEdit()
                    {
                        Staffcode = objComm.GetValue<int>(drrr["staffcode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Desig = objComm.GetValue<int>(drrr["DsgId"].ToString()),
                        Dept = objComm.GetValue<int>(drrr["DepId"].ToString()),
                        HrsCharg = objComm.GetValue<int>(drrr["HourlyCharges"].ToString()),
                        Brid = objComm.GetValue<int>(drrr["BrId"].ToString()),
                        Add1 = objComm.GetValue<string>(drrr["Addr1"].ToString()),
                        Add2 = objComm.GetValue<string>(drrr["Addr2"].ToString()),
                        Add3 = objComm.GetValue<string>(drrr["Addr3"].ToString()),
                        city = objComm.GetValue<string>(drrr["city"].ToString()),
                        Contractwork = objComm.GetValue<string>(drrr["Emp_Type"].ToString()),
                        Empid = objComm.GetValue<string>(drrr["staffBioServerid"].ToString()),
                        Phone = objComm.GetValue<string>(drrr["Mobile"].ToString()),
                        DOJ = objComm.GetValue<string>(drrr["DOJ"].ToString()),
                        DOL = objComm.GetValue<string>(drrr["DOL"].ToString()),
                        username = objComm.GetValue<string>(drrr["username"].ToString()),
                        password = objComm.GetValue<string>(drrr["password"].ToString()),
                        Staff_roll = objComm.GetValue<int>(drrr["Staff_roll"].ToString()),
                        Qual = objComm.GetValue<string>(drrr["Qual"].ToString()),
                        Email = objComm.GetValue<string>(drrr["Email"].ToString()),
                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_staffMasterEdit> tbl = List_SM as IEnumerable<tbl_staffMasterEdit>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string UpdateStaff(int compid, string rid, string DOJ, string DoL, int Hourlychrg,int Staffcode)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<StaffListDatails> List_SM = new List<StaffListDatails>();
        string DOJs = DOJ != "" ? Convert.ToDateTime(DOJ, ci).ToString("MM/dd/yyyy") : null;
        string DoLs = DoL != "" ? Convert.ToDateTime(DoL, ci).ToString("MM/dd/yyyy") : null;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@DOJs", DOJs);
            param[2] = new SqlParameter("@DoLs", DoLs);
            param[3] = new SqlParameter("@rid", rid);
            param[4] = new SqlParameter("@Hourlychrg", Hourlychrg);
            param[5] = new SqlParameter("@Staffcode", Staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_UpdateStaffMaster", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new StaffListDatails()
                    {
                        id = objComm.GetValue<int>(drrr["staffcode"].ToString()),

                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<StaffListDatails> tbl = List_SM as IEnumerable<StaffListDatails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteStaff(int compid,int Staffcode)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<StaffListDatails> List_SM = new List<StaffListDatails>();

        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Staffcode", Staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_DeleteStaffMaster", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new StaffListDatails()
                    {
                        id = objComm.GetValue<int>(drrr["staffcode"].ToString()),

                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<StaffListDatails> tbl = List_SM as IEnumerable<StaffListDatails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

}