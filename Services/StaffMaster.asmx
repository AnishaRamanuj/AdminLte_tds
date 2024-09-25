<%@ WebService Language="C#" Class="StaffMaster" %>

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
using JTMSProject;
using System.Security.Cryptography;
using System.IO;
using System.Text;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class StaffMaster : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");
    private readonly DBAccess db = new DBAccess();
    [WebMethod(EnableSession = true)]
    public string GetStaffRecord(string Srch, int pageIndex, int pageSize, string fromdate, string todate, int Depid, int Desig, int Vendrid, string PrimarySkillid, string SecondarySkillid, string CertificationID, int staffRecordCondition, string sRole, int branchid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        string DOJs = fromdate != "" ? Convert.ToDateTime(fromdate, ci).ToString("MM/dd/yyyy") : null;
        string DoLs = todate != "" ? Convert.ToDateTime(todate, ci).ToString("MM/dd/yyyy") : null;
        List<tbl_staff> List_DS = new List<tbl_staff>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[15];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@search", Srch);
            param[2] = new SqlParameter("@pageindex", pageIndex);
            param[3] = new SqlParameter("@pagesize", pageSize);
            param[4] = new SqlParameter("@fromdate", DOJs);
            param[5] = new SqlParameter("@todate", DoLs);
            param[6] = new SqlParameter("@Depid", Depid);
            param[7] = new SqlParameter("@Vendrid", Vendrid);
            param[8] = new SqlParameter("@PrimarySkillid", PrimarySkillid);
            param[9] = new SqlParameter("@SecondarySkillid", SecondarySkillid);
            param[10] = new SqlParameter("@CertificationID", CertificationID);
            param[11] = new SqlParameter("@StaffRecordCondition", staffRecordCondition);
            param[12] = new SqlParameter("@Desgid", Desig);
            param[13] = new SqlParameter("@sRole", sRole);
            param[14] = new SqlParameter("@branchid", branchid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_getstaffV2", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_staff()
                    {
                        Compid = 0,
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
                                Contractwork = objComm.GetValue<string>(drrr["RoleName"].ToString()),
                                HrsCharg = objComm.GetValue<int>(drrr["HourlyCharges"].ToString()),
                                Currency = objComm.GetValue<string>(drrr["Currency"].ToString()),
                                //RSalunke Commented Totalhours and Total Project Column
                                //Empid = objComm.GetValue<string>(drrr["Hours"].ToString()),
                                Phone = objComm.GetValue<string>(drrr["TotalProj"].ToString()),
                                Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                                PrimarySkill = objComm.GetValue<string>(drrr["PrimarySkill"].ToString()),
                                SecondarySkill = objComm.GetValue<string>(drrr["SecondarySkill"].ToString()),
                                CertificationName = objComm.GetValue<string>(drrr["CertificationName"].ToString()),
                                StaffImagePath = objComm.GetValue<string>(drrr["StaffImagePath"].ToString()),
                                RoleName = objComm.GetValue<string>(drrr["Rolename"].ToString()),
                                ApproverName = objComm.GetValue<string>(drrr["ApproverName"].ToString()),
                                Invite = objComm.GetValue<bool>(drrr["Invite"].ToString()),
                                InviteSentDate = objComm.GetValue<string>(drrr["InviteSentDate"].ToString()),
                                Branch = objComm.GetValue<string>(drrr["BranchName"].ToString())
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
                List<tbl_staffMasterdetail> listPrimeApprover = new List<tbl_staffMasterdetail>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listPrimeApprover.Add(new tbl_staffMasterdetail()
                            {
                                Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                Desig = objComm.GetValue<string>(drrr["DesignationName"].ToString()),
                                RoleName = objComm.GetValue<string>(drrr["Rolename"].ToString())
                            });
                        }
                    }
                }

                foreach (var item in List_DS)
                {
                    item.list_staffMasterdetail = liststaffrec;
                    item.list_staffcount = liststaffcount;
                    item.list_stafflimit = liststafflimit;
                    item.listPrimeApprover = listPrimeApprover;
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

    [WebMethod(EnableSession = true)]
    public string GetAlldropdown(int compid = 0)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Staffdropdwon> List_DS = new List<tbl_Staffdropdwon>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            //DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_getStaffdropdown", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_getStaffdropdown_New", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Staffdropdwon()
                    {
                        Compid = 0,
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

                List<tbl_Vendor> listVndrid = new List<tbl_Vendor>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listVndrid.Add(new tbl_Vendor()
                            {
                                VId = objComm.GetValue<int>(drrr["Vendrid"].ToString()),
                                Vendor = objComm.GetValue<string>(drrr["VendorName"].ToString()),
                            });
                        }
                    }
                }

                List<tbl_SKill> listskillid = new List<tbl_SKill>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listskillid.Add(new tbl_SKill()
                            {
                                SId = objComm.GetValue<int>(drrr["Skillid"].ToString()),
                                SKill = objComm.GetValue<string>(drrr["SkillName"].ToString())


                            });
                        }
                    }
                }

                List<tbl_Certificate> listCertificate = new List<tbl_Certificate>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listCertificate.Add(new tbl_Certificate()
                            {
                                CId = objComm.GetValue<int>(drrr["CertificationID"].ToString()),
                                CertificationName = objComm.GetValue<string>(drrr["CertificationName"].ToString())


                            });
                        }
                    }
                }

                List<tbl_Currency> lstCurrency = new List<tbl_Currency>();
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            lstCurrency.Add(new tbl_Currency()
                            {
                                Country = objComm.GetValue<string>(drrr["Cntry"].ToString()),
                                Currency = objComm.GetValue<string>(drrr["Currency"].ToString())
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
                    item.list_Vnd = listVndrid;
                    item.list_SK = listskillid;
                    item.list_Certificate = listCertificate;
                    item.list_Currency = lstCurrency;
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

    [WebMethod(EnableSession = true)]
    public string GetClientJobrecd(int compid = 0)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Staffmaster_JobAllocation> List_DS = new List<tbl_Staffmaster_JobAllocation>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            //DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_getStaffdropdown", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Boostrap_StaffClinetJobAlloc", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Staffmaster_JobAllocation()
                    {
                        Compid = 0,
                    });
                }
                List<tbl_Alloc_Client> listBranchMaster = new List<tbl_Alloc_Client>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listBranchMaster.Add(new tbl_Alloc_Client()
                            {
                                cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),

                            });
                        }
                    }
                }
                List<ProjectWiseBudgeting> listDepartmentMaster = new List<ProjectWiseBudgeting>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listDepartmentMaster.Add(new ProjectWiseBudgeting()
                            {
                                jobid = objComm.GetValue<int>(drrr["JobId"].ToString()),
                                cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                MJobName = objComm.GetValue<string>(drrr["Name"].ToString()),
                            });
                        }
                    }
                }
                foreach (var item in List_DS)
                {
                    item.list_clt = listBranchMaster;
                    item.list_clntjob = listDepartmentMaster;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Staffmaster_JobAllocation> tbl = List_DS as IEnumerable<tbl_Staffmaster_JobAllocation>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetProjectJobrecd(int Deptid, int Staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<JobStaffMappings> obj_Job = new List<JobStaffMappings>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Deptid", Deptid);
            param[2] = new SqlParameter("@StaffCode", Staffcode);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_StaffJobMappingV1", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new JobStaffMappings()
                    {
                        JobID = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                        ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        ProjectName = objComm.GetValue<string>(drrr["ProjectName"].ToString()),
                        StartDate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                        EndDate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        Status = objComm.GetValue<string>(drrr["Status"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<JobStaffMappings> tbl = obj_Job as IEnumerable<JobStaffMappings>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetProjectJobs(string compid, int Deptid, int Staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<JobStaffMappings> obj_Job = new List<JobStaffMappings>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Deptid", Deptid);
            param[2] = new SqlParameter("@StaffCode", Staffcode);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_All_StaffJobMapping", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new JobStaffMappings()
                    {
                        JobID = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                        Assign_Name = objComm.GetValue<string>(drrr["AssignmentName"].ToString()),
                        ischecked = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<JobStaffMappings> tbl = obj_Job as IEnumerable<JobStaffMappings>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    [WebMethod(EnableSession = true)]
    public string bindHourlyGrd(int Staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<HourlyCharges> obj_Job = new List<HourlyCharges>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@Company_ID", Session["companyid"]);
            param[1] = new SqlParameter("@StaffCode", Staffcode);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Hourly_Details", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new HourlyCharges()
                    {
                        HrlyID = objComm.GetValue<int>(drrr["id"].ToString()),
                        HCharges = objComm.GetValue<float>(drrr["hourlycharges"].ToString()),
                        frDate = objComm.GetValue<string>(drrr["fr"].ToString()),
                        toDate = objComm.GetValue<string>(drrr["todate"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<HourlyCharges> tbl = obj_Job as IEnumerable<HourlyCharges>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string EditStaff(int staffcode)
    {
        DataSet ds;

        CommonFunctions objComm = new CommonFunctions();
        List<tbl_StaffMasterEdit_Boostrap> List_SM = new List<tbl_StaffMasterEdit_Boostrap>();
        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", staffcode);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Boostrap_EditStaffMaster", param);

            DataTable table = ds.Tables["Table1"];

            DataRow row = table.Rows[0];
            var passwordOriginal = string.Empty;
            if (row != null)
            {

                var password = row["password"]!=DBNull.Value ? row["password"].ToString() : null;
                var rowkey = row["HashKey"]!=DBNull.Value ?  row["HashKey"].ToString():null;
                var rowsalt = row["Salt"]!=DBNull.Value ? row["Salt"].ToString():null;
                var userId = row["UserId"]!=DBNull.Value ? row["UserId"].ToString():null;
                string passEncrypt = string.Empty;
                if (string.IsNullOrEmpty(rowkey))
                {
                    string hashKey = "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=";
                    passEncrypt = string.Empty;
                    passEncrypt = Encrypt(password);

                    string strUpdateSql = "Update staff_master set password='" + passEncrypt + "',hashkey='" + hashKey + "' where StaffCode='" + staffcode + "'";
                    db.ExecuteCommand(strUpdateSql);

                    row["password"] = password;
                    row["HashKey"] = passEncrypt;
                }
                else
                {
                    string StrSQL = "select userid,password from aspnet_Membership where userid='" + userId + "'";

                    DataTable dtUserInfo = db.GetDataTable(StrSQL);
                    if (dtUserInfo != null && dtUserInfo.Rows.Count != 0)
                    {
                        passwordOriginal = dtUserInfo.Rows[0]["password"].ToString();

                    }

                    row["password"] = passwordOriginal;
                    row["HashKey"] = password;
                }
            }

            //using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Boostrap_EditStaffMaster_new", param))
            //{
            //    while (drrr.Read())
            //    {
            //        List_SM.Add(new tbl_StaffMasterEdit_Boostrap()
            //        {
            //            Compid = objComm.GetValue<int>(drrr["Compid"].ToString()),
            //        });
            //    }
            //    List<tbl_staffMasterEdit> listBranchMaster = new List<tbl_staffMasterEdit>();

            //    if (drrr.NextResult())
            //    {
            //        if (drrr.HasRows)
            //        {
            //            while (drrr.Read())
            //            {
            //                listBranchMaster.Add(new tbl_staffMasterEdit()
            //                {
            //                    Staffcode = objComm.GetValue<int>(drrr["staffcode"].ToString()),
            //                    StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
            //                    Desig = objComm.GetValue<int>(drrr["DsgId"].ToString()),
            //                    Dept = objComm.GetValue<int>(drrr["DepId"].ToString()),
            //                    HrsCharg = objComm.GetValue<int>(drrr["HourlyCharges"].ToString()),
            //                    Currency = objComm.GetValue<string>(drrr["Currency"].ToString()),
            //                    Brid = objComm.GetValue<int>(drrr["BrId"].ToString()),
            //                    Add1 = objComm.GetValue<string>(drrr["Addr1"].ToString()),
            //                    Add2 = objComm.GetValue<string>(drrr["Addr2"].ToString()),
            //                    Add3 = objComm.GetValue<string>(drrr["Addr3"].ToString()),
            //                    city = objComm.GetValue<string>(drrr["city"].ToString()),
            //                    Contractwork = objComm.GetValue<string>(drrr["Emp_Type"].ToString()),
            //                    Empid = objComm.GetValue<string>(drrr["staffBioServerid"].ToString()),
            //                    Phone = objComm.GetValue<string>(drrr["Mobile"].ToString()),
            //                    DOJ = objComm.GetValue<string>(drrr["DOJ"].ToString()),
            //                    DOL = objComm.GetValue<string>(drrr["DOL"].ToString()),
            //                    username = objComm.GetValue<string>(drrr["username"].ToString()),
            //                    password = objComm.GetValue<string>(drrr["password"].ToString()),
            //                    Staff_roll = objComm.GetValue<int>(drrr["Staff_roll"].ToString()),
            //                    Qual = objComm.GetValue<string>(drrr["Qual"].ToString()),
            //                    Email = objComm.GetValue<string>(drrr["Email"].ToString()),
            //                    Vendorid = objComm.GetValue<int>(drrr["Vendrid"].ToString()),
            //                    ReportTo = objComm.GetValue<int>(drrr["ReportTo"].ToString()),
            //                    Encrypt_Password = objComm.GetValue<int>(drrr["Encrypt_Password"].ToString()),
            //                });
            //            }
            //        }
            //    }
            //    List<tbl_ProjectActivity> listDepartmentMaster = new List<tbl_ProjectActivity>();

            //    if (drrr.NextResult())
            //    {
            //        if (drrr.HasRows)
            //        {
            //            while (drrr.Read())
            //            {
            //                listDepartmentMaster.Add(new tbl_ProjectActivity()
            //                {
            //                    mjobid = objComm.GetValue<int>(drrr["JobId"].ToString()),

            //                });
            //            }
            //        }
            //    }

            //    List<tbl_Alloc_Client> listcltid = new List<tbl_Alloc_Client>();

            //    if (drrr.NextResult())
            //    {
            //        if (drrr.HasRows)
            //        {
            //            while (drrr.Read())
            //            {
            //                listcltid.Add(new tbl_Alloc_Client()
            //                {
            //                    cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),

            //                });
            //            }
            //        }
            //    }

            //    List<tbl_SKill> listskillid = new List<tbl_SKill>();

            //    if (drrr.NextResult())
            //    {
            //        if (drrr.HasRows)
            //        {
            //            while (drrr.Read())
            //            {
            //                listskillid.Add(new tbl_SKill()
            //                {
            //                    SId = objComm.GetValue<int>(drrr["Skillid"].ToString()),
            //                    SKill = objComm.GetValue<string>(drrr["SkillName"].ToString()),
            //                    isChecked = objComm.GetValue<int>(drrr["Ischecked"].ToString()),
            //                    SkillType = objComm.GetValue<int>(drrr["SkillType"].ToString())
            //                });
            //            }
            //        }
            //    }

            //    List<tbl_Certificate> listCertificateID = new List<tbl_Certificate>();

            //    if (drrr.NextResult())
            //    {
            //        if (drrr.HasRows)
            //        {
            //            while (drrr.Read())
            //            {
            //                listCertificateID.Add(new tbl_Certificate()
            //                {
            //                    CId = objComm.GetValue<int>(drrr["CertificationID"].ToString()),
            //                    CertificationName = objComm.GetValue<string>(drrr["CertificationName"].ToString()),
            //                    isChecked = objComm.GetValue<int>(drrr["Ischecked"].ToString()),

            //                });
            //            }
            //        }
            //    }

            //    List<tbl_StaffImage> staffImage = new List<tbl_StaffImage>();
            //    if (drrr.NextResult())
            //    {
            //        if (drrr.HasRows)
            //        {
            //            while (drrr.Read())
            //            {
            //                staffImage.Add(new tbl_StaffImage()
            //                {
            //                    ImgId = objComm.GetValue<int>(drrr["ImageId"].ToString()),
            //                    ImagePath = objComm.GetValue<string>(drrr["ImagePath"].ToString())
            //                });
            //            }
            //        }
            //    }

            //    foreach (var item in List_SM)
            //    {
            //        item.list_edit = listBranchMaster;
            //        item.list_jobid = listDepartmentMaster;
            //        item.list_cltid = listcltid;
            //        item.list_SK = listskillid;
            //        item.list_certificate = listCertificateID;
            //        item.staffImage = staffImage;
            //    }
            //}
        }
        catch (Exception ex)
        {
            throw ex;
        }
        //IEnumerable<tbl_StaffMasterEdit_Boostrap> tbl = List_SM as IEnumerable<tbl_StaffMasterEdit_Boostrap>;
        //var obbbbb = tbl;
        //return new JavaScriptSerializer().Serialize(tbl);
        return ds.GetXml();
    }



    [System.Web.Services.WebMethod(EnableSession = true)]
    public string InsertNewStaff(string rid, string DOJ, string DoL, string UserName, string Comfpass, int Hourlychrg, string Emailid, string hdnAllapp, string DeptTextName, string DesgTextName, string BranchTextName,
string PrimarySkill, string SecondarySkill, string Certificate)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<StaffListDatails> List_SM = new List<StaffListDatails>();
        string DOJs = DOJ != "" ? Convert.ToDateTime(DOJ, ci).ToString("MM/dd/yyyy") : null;
        string DoLs = DoL != "" ? Convert.ToDateTime(DoL, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            if (emailValid(Emailid))
            {
                MembershipCreateStatus status;
                string mail = Emailid + "Staff" + Session["companyid"];

                string hashKey = "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=";
                ////var passEncrypt = DBAccess.HashPassword(Comfpass.Trim(),hashKey);
                string passEncrypt = string.Empty;
                passEncrypt = Encrypt(Comfpass.Trim());
                Membership.CreateUser(UserName, Comfpass.Trim(), mail, "question", "answer", true, out status);
                switch (status)
                {
                    case (MembershipCreateStatus.Success):
                        {
                            Roles.AddUserToRole(UserName, "staff");
                            Guid uid = new Guid((Membership.GetUser(UserName).ProviderUserKey).ToString());
                            try
                            {
                                Common ob = new Common();
                                SqlParameter[] param = new SqlParameter[18];
                                param[0] = new SqlParameter("@compid", Session["companyid"]);
                                param[1] = new SqlParameter("@DOJs", DOJs);
                                param[2] = new SqlParameter("@DoLs", DoLs);
                                param[4] = new SqlParameter("@rid", rid);
                                param[5] = new SqlParameter("@UserName", UserName);
                                param[6] = new SqlParameter("@Comfpass", passEncrypt);
                                param[7] = new SqlParameter("@Hourlychrg", Hourlychrg);
                                param[8] = new SqlParameter("@emailid", Emailid);
                                param[9] = new SqlParameter("@Jobids", hdnAllapp);
                                param[10] = new SqlParameter("@DeptTextName", DeptTextName);
                                param[11] = new SqlParameter("@DesgTextName", DesgTextName);
                                param[12] = new SqlParameter("@BranchTextName", BranchTextName);
                                param[13] = new SqlParameter("@PrimarySkill", PrimarySkill);
                                param[14] = new SqlParameter("@SecondarySkill", SecondarySkill);
                                param[15] = new SqlParameter("@Certificate", Certificate);
                                param[16] = new SqlParameter("@uid", uid);
                                param[17] = new SqlParameter("@hashKey", hashKey);

                                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InsertNewStaffV2", param))
                                {
                                    while (drrr.Read())
                                    {
                                        int staffcode = objComm.GetValue<int>(drrr["staffcode"].ToString());
                                        List_SM.Add(new StaffListDatails()
                                        {
                                            id = staffcode
                                            //Msg = "Thanks for SignUP.Please check your Mail for Login Details.",
                                        });

                                        if (staffcode == -999)
                                        {
                                            int? errorCode = objComm.GetValue<int>(drrr["ErrorCode"].ToString());
                                            if (errorCode != null && errorCode != 0)
                                            {
                                                Membership.DeleteUser(UserName, true);
                                            }
                                        }
                                    }
                                }
                            }
                            catch (Exception saveStaffex)
                            {
                                //rollback memebership and user role
                                //Roles.RemoveUserFromRole(UserName, "staff");
                                Membership.DeleteUser(UserName, true);
                                throw saveStaffex;
                            }
                            break;
                        }
                    case MembershipCreateStatus.DuplicateUserName:
                        {
                            List_SM.Add(new StaffListDatails()
                            {
                                id = -2,
                            });
                            break;
                        }
                    case MembershipCreateStatus.DuplicateEmail:
                        {
                            List_SM.Add(new StaffListDatails()
                            {
                                id = -1,
                            });
                            break;
                        }
                    case MembershipCreateStatus.InvalidEmail:
                        {
                            List_SM.Add(new StaffListDatails()
                            {
                                id = -4,
                            });

                            break;
                        }
                    case MembershipCreateStatus.InvalidPassword:
                        {
                            List_SM.Add(new StaffListDatails()
                            {
                                id = -5,
                                // Msg = "The password provided is invalid. It must be seven characters long and have at least one non-alphanumeric character.",
                            });
                            break;
                        }
                    default:
                        {
                            List_SM.Add(new StaffListDatails()
                            {
                                id = 0,
                            });

                            break;
                        }
                }
            }
            else
            {
                List_SM.Add(new StaffListDatails()
                {
                    id = 0,
                    //Msg = "Invalid EMAIL ID",
                });
            }
        }
        //////////////////////////////////////////////////////////////////////////////////////////////////////


        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<StaffListDatails> tbl = List_SM as IEnumerable<StaffListDatails>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    public bool emailValid(string email)
    {
        if (email != "")
        {
            //  string pattern = @"^[a-z][a-z|0-9|[-]]*([_][-][a-z|0-9]+)*([.][a-z|0-9]+([_][-][a-z|0-9]+)*)?@[a-z][-][a-z|0-9|]*\.([a-z][-][a-z|0-9]*(\.[a-z][-][a-z|0-9]*)?)$";
            string pattern = @"^(?!\.)(""([^""\r\\]|\\[""\r\\])*""|"
           + @"([-a-z0-9!#$%&'*+/=?^_`{|}~]|(?<!\.)\.)*)(?<!\.)"
           + @"@[a-z0-9][\w\.-]*[a-z0-9]\.[a-z][a-z\.]*[a-z]$";

            System.Text.RegularExpressions.Match match = Regex.Match(email.Trim(), pattern, RegexOptions.IgnoreCase);
            if (match.Success)
            {
                //string b = "true";
                //return b;
                return true;
            }
            else
            {
                //string b = "false";
                //return b;
                return false;
            }
        }
        else
        {
            return true;
        }
    }

    ////// old code  
    //[WebMethod]
    //public string InsertNewStaff(int compid, string rid, string DOJ, string DoL, string UserName, string Comfpass, int Hourlychrg, string Emailid, string hdnAllapp, string DeptTextName, string DesgTextName, string BranchTextName, string hdnskill)
    //{
    //    CommonFunctions objComm = new CommonFunctions();
    //    List<StaffListDatails> List_SM = new List<StaffListDatails>();
    //    string DOJs = DOJ != "" ? Convert.ToDateTime(DOJ, ci).ToString("MM/dd/yyyy") : null;
    //    string DoLs = DoL != "" ? Convert.ToDateTime(DoL, ci).ToString("MM/dd/yyyy") : null;
    //    try
    //    {

    //        Common ob = new Common();
    //        SqlParameter[] param = new SqlParameter[14];
    //        param[0] = new SqlParameter("@compid", compid);
    //        param[1] = new SqlParameter("@DOJs", DOJs);
    //        param[2] = new SqlParameter("@DoLs", DoLs);
    //        param[4] = new SqlParameter("@rid", rid);
    //        param[5] = new SqlParameter("@UserName", UserName);
    //        param[6] = new SqlParameter("@Comfpass", Comfpass);
    //        param[7] = new SqlParameter("@Hourlychrg", Hourlychrg);
    //        param[8] = new SqlParameter("@emailid", Emailid);
    //        param[9] = new SqlParameter("@Jobids", hdnAllapp);
    //        param[10] = new SqlParameter("@DeptTextName", DeptTextName);
    //        param[11] = new SqlParameter("@DesgTextName", DesgTextName);
    //        param[12] = new SqlParameter("@BranchTextName", BranchTextName);
    //        param[13] = new SqlParameter("@hdnskill", hdnskill);

    //        using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InsertNewStaff", param))
    //        {
    //            while (drrr.Read())
    //            {
    //                List_SM.Add(new StaffListDatails()
    //                {
    //                    id = objComm.GetValue<int>(drrr["staffcode"].ToString()),

    //                });
    //            }
    //            drrr.Close();
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //    IEnumerable<StaffListDatails> tbl = List_SM as IEnumerable<StaffListDatails>;
    //    var obbbbb = tbl;
    //    return new JavaScriptSerializer().Serialize(tbl);
    //}

    [WebMethod(EnableSession = true)]
    public string UpdateStaff(string rid, string DOJ, string DoL, int Hourlychrg, int Staffcode, string hdnAllapp, string Comfpass, string PrimarySkill, string SecondarySkill, string Certificate)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<StaffListDatails> List_SM = new List<StaffListDatails>();
        string DOJs = DOJ != "" ? Convert.ToDateTime(DOJ, ci).ToString("MM/dd/yyyy") : null;
        string DoLs = DoL != "" ? Convert.ToDateTime(DoL, ci).ToString("MM/dd/yyyy") : null;
        try
        {
            string hashKey = "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=";
            ////var passEncrypt = DBAccess.HashPassword(Comfpass.Trim(),hashKey);
            string passEncrypt = string.Empty;
            passEncrypt = Encrypt(Comfpass.Trim());

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[13];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@DOJs", DOJs);
            param[2] = new SqlParameter("@DoLs", DoLs);
            param[3] = new SqlParameter("@rid", rid);
            param[4] = new SqlParameter("@Hourlychrg", Hourlychrg);
            param[5] = new SqlParameter("@Staffcode", Staffcode);
            param[6] = new SqlParameter("@Jobids", hdnAllapp);
            param[7] = new SqlParameter("@Newpassword", Comfpass.Trim());
            param[8] = new SqlParameter("@primaryskill", PrimarySkill);
            param[9] = new SqlParameter("@Secondaryskill", SecondarySkill);
            param[10] = new SqlParameter("@Certificate", Certificate);
            param[11] = new SqlParameter("@EncryptedPassword", passEncrypt);
            param[12] = new SqlParameter("@HashKey", hashKey);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpdateStaffMasterV2", param))
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

    [WebMethod(EnableSession = true)]
    public string GetTotalHours(string fromdate, string todate, int staffcode)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_HoursTotal> List_SM = new List<tbl_HoursTotal>();
        string DOJs = fromdate != "" ? Convert.ToDateTime(fromdate, ci).ToString("MM/dd/yyyy") : null;
        string DoLs = todate != "" ? Convert.ToDateTime(todate, ci).ToString("MM/dd/yyyy") : null;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@fromdate", DOJs);
            param[2] = new SqlParameter("@todate", DoLs);
            param[3] = new SqlParameter("@staffcode", staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_TotalHours_Graph", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_HoursTotal()
                    {
                        TotalHrs = objComm.GetValue<string>(drrr["TotalHours"].ToString()),
                        Billhrs = objComm.GetValue<string>(drrr["Billable"].ToString()),
                        NonBillhrs = objComm.GetValue<string>(drrr["NonBillable"].ToString()),
                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_HoursTotal> tbl = List_SM as IEnumerable<tbl_HoursTotal>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string GetTotalHoursBarGraph(string fromdate, string todate, int staffcode)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<list_weekname> List_SM = new List<list_weekname>();
        string DOJs = fromdate != "" ? Convert.ToDateTime(fromdate, ci).ToString("MM/dd/yyyy") : null;
        string DoLs = todate != "" ? Convert.ToDateTime(todate, ci).ToString("MM/dd/yyyy") : null;
        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@fromdate", DOJs);
            param[2] = new SqlParameter("@todate", DoLs);
            param[3] = new SqlParameter("@staffcode", staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_WeekHourBarGraph", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new list_weekname()
                    {
                        d1week = objComm.GetValue<string>(drrr["d1"].ToString()),
                        d2week = objComm.GetValue<string>(drrr["d2"].ToString()),
                        d3week = objComm.GetValue<string>(drrr["d3"].ToString()),
                        d4week = objComm.GetValue<string>(drrr["d4"].ToString()),
                        d5week = objComm.GetValue<string>(drrr["d5"].ToString()),
                        d6week = objComm.GetValue<string>(drrr["d6"].ToString()),
                        d7week = objComm.GetValue<string>(drrr["d7"].ToString()),
                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<list_weekname> tbl = List_SM as IEnumerable<list_weekname>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string DeleteCharges(int hid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<HourlyCharges> List_SM = new List<HourlyCharges>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@Company_ID", Session["companyid"]);
            param[1] = new SqlParameter("@hid", hid);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Hourly_Timesheet_Delete", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new HourlyCharges()
                    {
                        HrlyID = objComm.GetValue<int>(drrr["id"].ToString()),

                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<HourlyCharges> tbl = List_SM as IEnumerable<HourlyCharges>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string InsertUpdateHourlyGrd(int hid, int staff, int hrly, string frDt, string toDT)
    {
        CommonFunctions objComm = new CommonFunctions();
        string DOJs = frDt != "" ? Convert.ToDateTime(frDt, ci).ToString("MM/dd/yyyy") : null;
        string DOEs = toDT != "" ? Convert.ToDateTime(toDT, ci).ToString("MM/dd/yyyy") : null;
        List<HourlyCharges> List_SM = new List<HourlyCharges>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@hid", hid);
            param[2] = new SqlParameter("@frmdt", DOJs);
            param[3] = new SqlParameter("@todt", DOEs);
            param[4] = new SqlParameter("@staffcode", staff);
            param[5] = new SqlParameter("@Hourcht", hrly);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_InsertUpdateHourlyCharges", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new HourlyCharges()
                    {
                        HrlyID = objComm.GetValue<int>(drrr["id"].ToString()),
                        HCharges = objComm.GetValue<float>(drrr["hc"].ToString()),

                    });
                }
                drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<HourlyCharges> tbl = List_SM as IEnumerable<HourlyCharges>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession = true)]
    public string DeleteStaff(int Staffcode)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<StaffListDatails> List_SM = new List<StaffListDatails>();

        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Staffcode", Staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteStaffMaster", param))
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


    [WebMethod(EnableSession = true)]
    public string HorlyChargeStaff(int desig)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<End_Project> obj_Job = new List<End_Project>();

        try
        {

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Design", desig);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_HourlyChargesStaff", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new End_Project()
                    {
                        Jobid = objComm.GetValue<int>(drrr["HourlyCharges"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<End_Project> tbl = obj_Job as IEnumerable<End_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession = true)]
    public string GetStaffPassword(int staffcode)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_companyProfile> obj_Job = new List<tbl_companyProfile>();

        try
        {

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@staffcode", staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_EmailStaffLogin", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_companyProfile()
                    {
                        FirstName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Email = objComm.GetValue<string>(drrr["Email"].ToString()),
                        username = objComm.GetValue<string>(drrr["username"].ToString()),
                        password = objComm.GetValue<string>(drrr["Password"].ToString()) //DBAccess.DecryptPassword(objComm.GetValue<string>(drrr["Password"].ToString()), Convert.FromBase64String(objComm.GetValue<string>(drrr["Salt"].ToString())), Convert.FromBase64String(objComm.GetValue<string>(drrr["HashKey"].ToString()))),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_companyProfile> tbl = obj_Job as IEnumerable<tbl_companyProfile>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]
    public string GetForgetPassword(string email)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_companyProfile> obj_Job = new List<tbl_companyProfile>();

        try
        {

            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@email", email);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetForgetPasswrd", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_companyProfile()
                    {
                        FirstName = objComm.GetValue<string>(drrr["username"].ToString()),
                        username = objComm.GetValue<string>(drrr["ID"].ToString()),
                        password =objComm.GetValue<string>(drrr["Password"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_companyProfile> tbl = obj_Job as IEnumerable<tbl_companyProfile>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod]
    public string GetleftStaffRecord(int compid, int pageIndex, int pageSize, string Srch)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_staffMasterdetail> obj_Job = new List<tbl_staffMasterdetail>();

        try
        {
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Srch", Srch);
            param[2] = new SqlParameter("@pageIndex", pageIndex);
            param[3] = new SqlParameter("@pageSize", pageSize);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Boostrap_LeftStaff", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new tbl_staffMasterdetail()
                    {
                        srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        Empid = objComm.GetValue<string>(drrr["DateOfJoining"].ToString()),
                        Phone = objComm.GetValue<string>(drrr["DateOfLeaving"].ToString()),
                        Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_staffMasterdetail> tbl = obj_Job as IEnumerable<tbl_staffMasterdetail>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]
    public string Updateleftsatff(int compid, int staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<End_Project> obj_Job = new List<End_Project>();

        try
        {

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@staffcode", staffcode);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpdateLeftstaff", param))
            {
                while (drrr.Read())
                {
                    obj_Job.Add(new End_Project()
                    {
                        Jobid = objComm.GetValue<int>(drrr["staffcode"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<End_Project> tbl = obj_Job as IEnumerable<End_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }
    [WebMethod(EnableSession = true)]
    public string GetDeprtmentwiseStaff(string departmentid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_staffMasterdetail> obj_Job = new List<tbl_staffMasterdetail>();

        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@departmentid", departmentid);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDepartmentwiseStaff", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_staffMasterdetail()
                        {
                            Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_staffMasterdetail> tbl = obj_Job as IEnumerable<tbl_staffMasterdetail>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession = true)]
    public string GetAllCompanyStaffPermissions(string staffcode)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<menumaster> menumasters = new List<menumaster>();
        List<SimpleMenuMaster> simpleMenuMaster = new List<SimpleMenuMaster>();

        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@Companyid", Session["companyid"]);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_bindstafftreeview", param))
            {
                while (drrr.Read())
                {
                    menumasters.Add(new menumaster()
                    {
                        pagemenuid = Convert.ToInt16(drrr["PageMenuID"].ToString()),
                        GROUP_ID = Convert.ToInt16(drrr["GROUP_ID"].ToString()),
                        Name = (drrr["name"].ToString()),
                        PageName = (drrr["pagename"].ToString()),
                        SubMenu = (drrr["submenu"].ToString()),
                        SubName = (drrr["SubName"].ToString()),
                        Menu_Title = (drrr["menu_title"].ToString()),
                        ID = (drrr["ID"].ToString()),
                    });
                }
            }

            string groupPrefix = "group_";
            var parentMenuItems = menumasters.Select(m => new { m.Name, m.GROUP_ID }).Distinct().ToList();

            foreach (var menu in parentMenuItems)
            {
                simpleMenuMaster.Add(
                    new SimpleMenuMaster
                    {
                        MenuId = groupPrefix + (menu.GROUP_ID == null ? "0" : menu.GROUP_ID.ToString()),
                        MenuTitle = menu.Name,
                        ParentMenuId = groupPrefix + "0",
                        ParentMenuTitle = "Main",
                        IsValidPermissionItem = false
                    });
            }

            var level2MenuItems1 = menumasters.Where(m => m.SubMenu == "0").ToList();
            foreach (var menu in level2MenuItems1)
            {
                simpleMenuMaster.Add(
                    new SimpleMenuMaster
                    {
                        MenuId = menu.ID,
                        MenuTitle = menu.Menu_Title,
                        ParentMenuId = groupPrefix + (menu.GROUP_ID == null ? "0" : menu.GROUP_ID.ToString()),
                        ParentMenuTitle = menu.Name,
                        IsValidPermissionItem = true
                    });
            }

            var level2MenuItems2 = menumasters.Where(m => m.SubName != "").Select(m => new { m.SubName, m.GROUP_ID, m.Name }).Distinct().ToList();
            int menuId = int.MaxValue;
            foreach (var menu in level2MenuItems2)
            {
                if (!simpleMenuMaster.Exists(m => m.MenuTitle.ToLower() == menu.SubName.ToLower() && m.ParentMenuId == menu.GROUP_ID.ToString()))
                {
                    menuId--;
                    simpleMenuMaster.Add(
                        new SimpleMenuMaster
                        {
                            MenuId = groupPrefix + Convert.ToString(menuId),
                            MenuTitle = menu.SubName,
                            ParentMenuId = groupPrefix + (menu.GROUP_ID == null ? "0" : menu.GROUP_ID.ToString()),
                            ParentMenuTitle = menu.Name,
                            IsValidPermissionItem = false
                        });
                }
            }

            var level3MenuItems = menumasters.Where(m => m.Name != m.Menu_Title && m.SubMenu == "1").ToList();
            foreach (var menu in level3MenuItems)
            {
                var parent = simpleMenuMaster.Where(m => m.MenuTitle == menu.SubName).FirstOrDefault();
                string parentId = "-1";

                if (parent != null)
                    parentId = parent.MenuId;

                simpleMenuMaster.Add(
                    new SimpleMenuMaster
                    {
                        MenuId = menu.ID,
                        MenuTitle = menu.Menu_Title,
                        ParentMenuId = parentId,
                        ParentMenuTitle = menu.SubName,
                        IsValidPermissionItem = true
                    });
            }

            List<Int16> selectedStaffPageMenuIds = new List<Int16>();
            SqlParameter[] param2 = new SqlParameter[1];
            param2[0] = new SqlParameter("@staffid", staffcode);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "staffpermission", param2))
            {
                while (drrr.Read())
                {
                    selectedStaffPageMenuIds.Add(Convert.ToInt16(drrr["PageMenuID"].ToString()));
                }
            }

            foreach (var item in selectedStaffPageMenuIds)
            {
                var menu = simpleMenuMaster.Where(m => m.MenuId == item.ToString()).FirstOrDefault();
                if (menu != null)
                    menu.Checked = true;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(simpleMenuMaster.AsEnumerable());
    }

    [WebMethod(EnableSession = true)]
    public string InsertStaffPermissions(string staffcode, string selectedPermissions)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        try
        {
            SqlParameter[] objSqlParameter = new SqlParameter[3];
            objSqlParameter[0] = new SqlParameter("@user", staffcode);
            objSqlParameter[1] = new SqlParameter("@staff", selectedPermissions.TrimEnd(','));
            objSqlParameter[2] = new SqlParameter("@company_id", Session["companyid"]);
            DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_insertstaffpemission", objSqlParameter);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(true);
    }

    [WebMethod]
    public string GetReportToList(int compId)
    {
        List<tbl_ReportTo> tbl_reportto = new List<tbl_ReportTo>();
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        try
        {
            SqlParameter[] objSqlParameter = new SqlParameter[1];
            objSqlParameter[0] = new SqlParameter("@CompId", compId);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_GetReportoList", objSqlParameter))
            {
                while (drrr.Read())
                {
                    tbl_reportto.Add(new tbl_ReportTo()
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
        return new JavaScriptSerializer().Serialize(tbl_reportto);
    }

    [WebMethod(EnableSession = true)]
    public string InsertNewDepartment(string deptName)
    {
        List<Department_Master> listDepartmentMaster = new List<Department_Master>();
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        try
        {
            SqlParameter[] objSqlParameter = new SqlParameter[2];
            objSqlParameter[0] = new SqlParameter("@CompId", Session["companyid"]);
            objSqlParameter[1] = new SqlParameter("@DeptName", deptName);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_InsertPopulateNewDepartment", objSqlParameter))
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

    [WebMethod(EnableSession = true)]
    public string InsertNewDesignation(string designationName)
    {
        List<Designation_Master> listDesignation = new List<Designation_Master>();
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        try
        {
            SqlParameter[] objSqlParameter = new SqlParameter[2];
            objSqlParameter[0] = new SqlParameter("@CompId", Session["companyid"]);
            objSqlParameter[1] = new SqlParameter("@DesignationName", designationName);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_InsertPopulateNewDesignation", objSqlParameter))
            {
                while (drrr.Read())
                {
                    listDesignation.Add(new Designation_Master()
                    {
                        DsgId = objComm.GetValue<int>(drrr["DsgId"].ToString()),
                        DesignationName = objComm.GetValue<string>(drrr["DesignationName"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(listDesignation);
    }

    [WebMethod(EnableSession = true)]
    public string CheckForDuplicateDepartment(string deptName)
    {
        List<Department_Master> listDepartmentMaster = new List<Department_Master>();
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        try
        {
            SqlParameter[] objSqlParameter = new SqlParameter[2];
            objSqlParameter[0] = new SqlParameter("@CompId", Session["companyid"]);
            objSqlParameter[1] = new SqlParameter("@DeptName", deptName);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_CheckDuplicateDepartment", objSqlParameter))
            {
                while (drrr.Read())
                {
                    listDepartmentMaster.Add(new Department_Master()
                    {
                        DepId = objComm.GetValue<int>(drrr["DepId"].ToString())
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

    [WebMethod(EnableSession = true)]
    public string CheckForDuplicateDesignation(string designationName)
    {
        List<Designation_Master> listDesignation = new List<Designation_Master>();
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        try
        {
            SqlParameter[] objSqlParameter = new SqlParameter[2];
            objSqlParameter[0] = new SqlParameter("@CompId", Session["companyid"]);
            objSqlParameter[1] = new SqlParameter("@DesignationName", designationName);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_CheckDuplicateDesignation", objSqlParameter))
            {
                while (drrr.Read())
                {
                    listDesignation.Add(new Designation_Master()
                    {
                        DsgId = objComm.GetValue<int>(drrr["DesgId"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(listDesignation);
    }
    [WebMethod(EnableSession = true)]
    public string UpdateStaffDetails(int staffCode, string flatNo, string buildingName, string streetName, string city, string mobileNo)
    {
        tbl_Staff staff = new tbl_Staff();
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] objSqlParameter = new SqlParameter[7];
                objSqlParameter[0] = new SqlParameter("@CompId", Session["companyid"]);
                objSqlParameter[1] = new SqlParameter("@StaffCode", staffCode);
                objSqlParameter[2] = new SqlParameter("@FlatNo", flatNo);
                objSqlParameter[3] = new SqlParameter("@BuildingName", buildingName);
                objSqlParameter[4] = new SqlParameter("@StreetName", streetName);
                objSqlParameter[5] = new SqlParameter("@City", city);
                objSqlParameter[6] = new SqlParameter("@MobileNo", mobileNo);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_UpdateStaffDetails", objSqlParameter))
                {
                    while (drrr.Read())
                    {
                        staff.StaffCode = objComm.GetValue<int>(drrr["StaffId"].ToString());
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return new JavaScriptSerializer().Serialize(staff);
    }

    [WebMethod(EnableSession = true)]
    public string Branch(int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        DataSet ds;
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Branch", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }
    [WebMethod(EnableSession = true)]
    public string StaffCode_Check(int Sid, string SCode)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_staffMasterEdit> List_DS = new List<tbl_staffMasterEdit>();


        try
        {

            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Scode", SCode);
            param[2] = new SqlParameter("@Sid", Sid);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_StaffCode_Check", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_staffMasterEdit()
                    {
                        Skid = objComm.GetValue<int>(drrr["SCode"].ToString()),
                    });
                }
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_staffMasterEdit> trec = List_DS as IEnumerable<tbl_staffMasterEdit>;
        var obbbbb = trec;
        return new JavaScriptSerializer().Serialize(trec);
    }

    private string Encrypt(string clearText)
    {
        string EncryptionKey = "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=";
        byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
        using (Aes encryptor = Aes.Create())
        {
            Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
            encryptor.Key = pdb.GetBytes(32);
            encryptor.IV = pdb.GetBytes(16);
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(clearBytes, 0, clearBytes.Length);
                    cs.Close();
                }
                clearText = Convert.ToBase64String(ms.ToArray());
            }
        }
        return clearText;
    }

    private string Decrypt(string cipherText)
    {
        string EncryptionKey = "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4=";
        cipherText = cipherText.Replace(" ", "+");
        byte[] cipherBytes = Convert.FromBase64String(cipherText);
        using (Aes encryptor = Aes.Create())
        {
            Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
            encryptor.Key = pdb.GetBytes(32);
            encryptor.IV = pdb.GetBytes(16);
            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                {
                    cs.Write(cipherBytes, 0, cipherBytes.Length);
                    cs.Close();
                }
                cipherText = Encoding.Unicode.GetString(ms.ToArray());
            }
        }
        return cipherText;
    }



}