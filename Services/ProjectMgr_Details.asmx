<%@ WebService Language="C#" Class="ProjectMgr_Details" %>

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
public class ProjectMgr_Details  : System.Web.Services.WebService {
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod(EnableSession=true)]
    public string OnLoad(int Compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetCompanyDetails", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }


    [WebMethod(EnableSession=true)]
    public string Teams( int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;


            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Team", param);


        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string ProjectDtlsnClient( int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {

            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_ProjectDtlsnClient", param);


        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }


    [WebMethod(EnableSession=true)]
    public string Project_Save(int Pid, string Pdts)
    {
        CommonFunctions objComm = new CommonFunctions();
        string Proc = "";

        Proc = "usp_New_Bootstrap_Project_Save";
        List<tbl_Project_Details> List_DS = new List<tbl_Project_Details>();
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@Pdts", Pdts);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, Proc, param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project_Details()
                    {
                        Pid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Project_Details> tbl = List_DS as IEnumerable<tbl_Project_Details>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string Project_Save_Details(int Pid, string Pdts,  string hdnOnly,  string ProjDtl, string ProjOverview, string ProjManagers, string Apprs)
    {
        CommonFunctions objComm = new CommonFunctions();
        string Proc = "";
        //if (hdnOnly == "0")
        //{
        Proc = "usp_New_Bootstrap_Project_Save_Details";
        //}
        //else if (hdnOnly == "1")
        //{
        //    Proc = "";
        //    // Proc = "usp_Bootstrap_ProjectOnly_Save"; /////////// ICT, GNS
        //}
        //else if (hdnOnly == "2")
        //{
        //    Proc = "usp_New_Bootstrap_Project_Save";
        //}
        List<tbl_Project_Details> List_DS = new List<tbl_Project_Details>();
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[7];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@Pdts", Pdts);
            param[3] = new SqlParameter("@ProjDtl", ProjDtl);
            param[4] = new SqlParameter("@ProjOverview", ProjOverview);
            param[5] = new SqlParameter("@ProjManagers", ProjManagers);
            param[6] = new SqlParameter("@Apprs", Apprs);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, Proc, param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project_Details()
                    {
                        Pid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Project_Details> tbl = List_DS as IEnumerable<tbl_Project_Details>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string DashBoard_Details( int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_ProjectDashboard", param);


        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string DashBoard_Graph( int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectGraph> List_DS = new List<tbl_ProjectGraph>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            //ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_DashBoardGraph", param);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_DashBoardGraph", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_ProjectGraph()
                    {
                        d1 = objComm.GetValue<string>(drrr["d1"].ToString()),
                        d2 = objComm.GetValue<string>(drrr["d2"].ToString()),
                        d3 = objComm.GetValue<string>(drrr["d3"].ToString()),
                        d4 = objComm.GetValue<string>(drrr["d4"].ToString()),
                        d5 = objComm.GetValue<string>(drrr["d5"].ToString()),
                        d6 = objComm.GetValue<string>(drrr["d6"].ToString()),
                        d7 = objComm.GetValue<string>(drrr["d7"].ToString()),
                        d8 = objComm.GetValue<string>(drrr["d8"].ToString()),
                        d9 = objComm.GetValue<string>(drrr["d9"].ToString()),
                        d10 = objComm.GetValue<string>(drrr["d10"].ToString()),
                        d11 = objComm.GetValue<string>(drrr["d11"].ToString()),
                        d12 = objComm.GetValue<string>(drrr["d12"].ToString()),
                        Total = objComm.GetValue<string>(drrr["Total"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_ProjectGraph> tbl = List_DS as IEnumerable<tbl_ProjectGraph>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string Team_Save( int Pid, string Teams)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@Teams", Teams);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Save_Team", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project()
                    {
                        Pid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Project> tbl = List_DS as IEnumerable<tbl_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession=true)]
    public string Activity( int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Activity", param);


        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Activity_Dept( int Pid, int dept)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {

            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@dpt", dept);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Get_ActivityDept", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Activity_Check(int aid,  int pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", pid);
            param[2] = new SqlParameter("@aid", aid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Activity_Check", param);


        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }


    [WebMethod(EnableSession=true)]
    public string Fill_Dept( int dp)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Department", param);

        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }



    [WebMethod(EnableSession=true)]
    public string Activity_Save( int Pid, string Activity, int dtype, string did)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@Activity", Activity);
            param[3] = new SqlParameter("@did", did);
            param[4] = new SqlParameter("@dtype", dtype);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Save_Activity", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project()
                    {
                        Pid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Project> tbl = List_DS as IEnumerable<tbl_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod(EnableSession=true)]
    public string New_Activity_Save( string Activity, string did, string dp)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Activity", Activity);
            param[2] = new SqlParameter("@did", did);
            param[3] = new SqlParameter("@dtype", dp);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Activity_Save", param);


            //using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Activity_Save", param))
            //{
            //    while (drrr.Read())
            //    {
            //        List_DS.Add(new tbl_Project()
            //        {
            //            Pid = objComm.GetValue<int>(drrr["Aid"].ToString()),
            //        });
            //    }
            //}
        }
        catch (Exception ex)
        {
            throw ex;
        }
        //IEnumerable<tbl_Project> tbl = List_DS as IEnumerable<tbl_Project>;
        //var obbbbb = tbl;
        //return new JavaScriptSerializer().Serialize(tbl);
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Get_Staff_dropDowns(int cid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Staffdropdwon> List_DS = new List<tbl_Staffdropdwon>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            //ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_getStaffdropdown", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_getStaffdropdown", param))
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
                                DepId = objComm.GetValue<int>(drrr["Depid"].ToString()),
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

                foreach (var item in List_DS)
                {
                    item.list_BranchMaster = listBranchMaster;
                    item.list_DepartmentMaster = listDepartmentMaster;
                    item.list_DesignationMaster = listDesignationMaster;
                    item.list_RoleMaster = listRoleMaster;
                    //item.list_staffroleid = liststaffroleid;
                    //item.list_Vnd = listVndrid;
                    //item.list_SK = listskillid;
                    //item.list_Certificate = listCertificate;
                    //item.list_Currency = lstCurrency;
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


    [WebMethod(EnableSession=true)]
    public string New_Staff_Save( string Stf, string em, int dp, int dg , int br , string rl , string us , string ps, string doj)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project_Team> List_DS = new List<tbl_Project_Team>();
        DataSet ds;
        try
        { Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            string DOJs = doj != "" ? Convert.ToDateTime(doj, ci).ToString("MM/dd/yyyy") : null;

            if (emailValid(em))
            {
                MembershipCreateStatus status;
                string mail = em + "Staff" ;

                Membership.CreateUser(us, ps.Trim(), mail, "question", "answer", true, out status);
                switch (status)
                {
                    case (MembershipCreateStatus.Success):
                        {
                            Roles.AddUserToRole(us, "staff");
                            Guid uid = new Guid((Membership.GetUser(us).ProviderUserKey).ToString());
                            try
                            {


                                SqlParameter[] param = new SqlParameter[11];
                                param[0] = new SqlParameter("@compid", Session["companyid"]);
                                param[1] = new SqlParameter("@stf", Stf);
                                param[2] = new SqlParameter("@eml", em);
                                param[3] = new SqlParameter("@Doj", DOJs);
                                param[4] = new SqlParameter("@Usr", us);
                                param[5] = new SqlParameter("@pass", ps);
                                param[6] = new SqlParameter("@dp", dp);
                                param[7] = new SqlParameter("@dg", dg);
                                param[8] = new SqlParameter("@br", br);
                                param[9] = new SqlParameter("@rl", rl);
                                param[10] = new SqlParameter("@uid", uid);
                                ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Staff_Save", param);
                                if (ds.Tables[0].Rows.Count > 0)
                                {
                                    foreach (DataRow dr in ds.Tables[0].Rows)
                                    {

                                        List_DS.Add(new tbl_Project_Team()
                                        {
                                            Sid = objComm.GetValue<int>(dr["staffcode"].ToString()),
                                            Staff = objComm.GetValue<string>(dr["staffname"].ToString()),
                                            Did = objComm.GetValue<int>(dr["DepId"].ToString()),
                                            Deprt = objComm.GetValue<string>(dr["DepartmentName"].ToString()),

                                        });
                                    }
                                }
                            }
                            catch (Exception saveStaffex)
                            {
                                //rollback memebership and user role
                                //Roles.RemoveUserFromRole(UserName, "staff");
                                Membership.DeleteUser(us, true);
                                throw saveStaffex;
                            }
                            break;
                        }
                    case MembershipCreateStatus.DuplicateUserName:
                        {
                            List_DS.Add(new tbl_Project_Team()
                            {
                                Sid = -2,
                            });
                            break;
                        }
                    case MembershipCreateStatus.DuplicateEmail:
                        {
                            List_DS.Add(new tbl_Project_Team()
                            {
                                Sid = -1,
                            });
                            break;
                        }
                    case MembershipCreateStatus.InvalidEmail:
                        {
                            List_DS.Add(new tbl_Project_Team()
                            {
                                Sid = -4,
                            });

                            break;
                        }
                    case MembershipCreateStatus.InvalidPassword:
                        {
                            List_DS.Add(new tbl_Project_Team()
                            {
                                Sid = -5,
                                // Msg = "The password provided is invalid. It must be seven characters long and have at least one non-alphanumeric character.",
                            });
                            break;
                        }
                    default:
                        {
                            List_DS.Add(new tbl_Project_Team()
                            {
                                Sid = 0,
                            });

                            break;
                        }
                }
            }
            else
            {
                List_DS.Add(new tbl_Project_Team()
                {
                    Sid = 0,
                    //Msg = "Invalid EMAIL ID",
                });
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Project_Team> tbl = List_DS as IEnumerable<tbl_Project_Team>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession=true)]
    public string New_Department_Save(string dp)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project_Team> List_DS = new List<tbl_Project_Team>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@dp", dp);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Department_Save", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project_Team()
                    {
                        Did = objComm.GetValue<int>(drrr["did"].ToString()),
                        Deprt = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Project_Team> tbl = List_DS as IEnumerable<tbl_Project_Team>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession=true)]
    public string New_Designation_Save(string dg)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project_Team> List_DS = new List<tbl_Project_Team>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@dg", dg);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Designation_Save", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project_Team()
                    {
                        Dsg = objComm.GetValue<int>(drrr["dsg"].ToString()),
                        Desgn = objComm.GetValue<string>(drrr["DesignationName"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Project_Team> tbl = List_DS as IEnumerable<tbl_Project_Team>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod(EnableSession=true)]
    public string MileStone_Grd( int Pid )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Milestone_Grd", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project()
                    {
                        Pid = objComm.GetValue<int>(drrr["ProjectID"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Project> tbl = List_DS as IEnumerable<tbl_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }

    [WebMethod(EnableSession=true)]
    public string MileStone_Master_Save(int Mid, string Mile )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_MileStone> List_DS = new List<tbl_MileStone>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Mid", Mid);
            param[2] = new SqlParameter("@MileStone", Mile);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Milestone_Save", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_MileStone()
                    {
                        Mile_Id = objComm.GetValue<int>(drrr["Mile_Id"].ToString()),
                        MileStone = objComm.GetValue<string>(drrr["Milestone_Name"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MileStone> tbl = List_DS as IEnumerable<tbl_MileStone>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string MileStone_View( int Pid )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Milestone_Grd", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string MileStone_Edit( int PMid )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@PMid", PMid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Milestone_Edit", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Update_Status( string Pid, string Sts, string PM )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@Sts", Sts);
            param[3] = new SqlParameter("@PM", PM);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_MileStone_Update_Status", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string MileStone_Task( int Pid )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Milestone_Task", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string MileStone_Save(int Mid, int Pid, string Mdtls, string MTask )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_MileStone_Project> List_DS = new List<tbl_MileStone_Project>();

        try
        {   if (MTask == ".")
            {
                MTask = "";
            }
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;


            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@Mdtls", Mdtls);
            param[3] = new SqlParameter("@MTask", MTask);
            param[4] = new SqlParameter("@Mid", Mid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Milestone_Save", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_MileStone_Project()
                    {
                        PMile_Id = objComm.GetValue<int>(drrr["Pmile_id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_MileStone_Project> tbl = List_DS as IEnumerable<tbl_MileStone_Project>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }


    [WebMethod(EnableSession=true)]
    public string ProjectMilenCurrency (int Pid )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Get_Project", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Project_Invoice (int Pid )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@pid", Pid);


            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Get_InvoiceNo", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Project_Timesheet (int Pid, string ST, string ED )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@ST", ST);
            param[3] = new SqlParameter("@ED", ED);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Get_Project_Timesheet", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Invoice_Timesheet (int Pid, string Tsid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@tsid", Tsid);


            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Get_Project_Timesheet_Invioce", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Invoice_Save (int Pid,int invId, string tbl, string rec, string tsid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@invId", invId);
            param[3] = new SqlParameter("@tbl", tbl);
            param[4] = new SqlParameter("@rec", rec);
            param[5] = new SqlParameter("@tsid", tsid);

            //ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Invoice_Save", param);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Invoice_Save", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project()
                    {
                        Pid = objComm.GetValue<int>(drrr["Inv_id"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Project> trec = List_DS as IEnumerable<tbl_Project>;
        var obbbbb = trec;
        return new JavaScriptSerializer().Serialize(trec);
    }

    [WebMethod(EnableSession=true)]
    public string Invoice_Grd (int Pid )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Invoice_Grd", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Invoice_Edit (int Pid, int InvId )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@InvId", InvId);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Invoice_Grd", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }


    [WebMethod(EnableSession=true)]
    public string Resource_Allocation (int pid, int stf, string st , string et )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", pid);
            param[2] = new SqlParameter("@Staffcode", stf);
            param[3] = new SqlParameter("@FromDate", st);
            param[4] = new SqlParameter("@ToDate", et);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Resource_Planning", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }
    [WebMethod(EnableSession=true)]
    public string Report_Onload ()
    {
        CommonFunctions objComm = new CommonFunctions();

        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[5];
            param[0] = new SqlParameter("@compid", Session["companyid"]);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Resource_Planning_Report_Onload", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Report_GetStaff (int did)
    {
        CommonFunctions objComm = new CommonFunctions();

        DataSet ds;
        try
        {
            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@depid", did);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Resource_Planning_Staff", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string ProjectCode_Check(int Pid, string PCode)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        DataSet ds;
        try
        {

            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;

            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pcode", PCode);
            param[2] = new SqlParameter("@Pid", Pid);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_bootstrap_ProjectCode_Check", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project()
                    {
                        Pid = objComm.GetValue<int>(drrr["PCode"].ToString()),
                    });
                }
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Project> trec = List_DS as IEnumerable<tbl_Project>;
        var obbbbb = trec;
        return new JavaScriptSerializer().Serialize(trec);
    }

    [WebMethod(EnableSession=true)]
    public string GetBranch(int compid, int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<ProjectwiseBillable_Hrs> listBranch = new List<ProjectwiseBillable_Hrs>();
        try
        {

            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;


            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@Compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Project_Branch", param))
            {
                while (drrr.Read())
                {
                    listBranch.Add(new ProjectwiseBillable_Hrs()
                    {
                        BrId = objComm.GetValue<int>(drrr["BrId"].ToString()),
                        Branch = objComm.GetValue<string>(drrr["BranchName"].ToString()),
                        id = objComm.GetValue<int>(drrr["isChecked"].ToString())
                    });
                }
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<ProjectwiseBillable_Hrs> trec = listBranch as IEnumerable<ProjectwiseBillable_Hrs>;
        var obbbbb = trec;
        return new JavaScriptSerializer().Serialize(trec);
    }

    [WebMethod(EnableSession=true)]
    public string GetOtherDept_Activity(int Pid, string dept)
    {   DataSet ds;
        CommonFunctions objComm = new CommonFunctions();
        List<ProjectwiseBillable_Hrs> listBranch = new List<ProjectwiseBillable_Hrs>();
        try
        {

            Common ob = new Common();

            // string _Compid = ob.companyid.ToString() ;


            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@Compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@dpt", dept);

            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Get_SelectedDept_Activity", param);


        }
        catch (Exception ex)
        {
            throw ex;
        }
        return ds.GetXml();
    }
    //[WebMethod(EnableSession=true)]
    //public void Dal_getPronClt(string compid)
    //{
    //        Common ob = new Common();

    //        // string _Compid = ob.companyid.ToString() ;
    //        CommonFunctions objComm = new CommonFunctions();
    //    try
    //    {
    //        SqlParameter[] param = new SqlParameter[1];
    //        param[0] = new SqlParameter("@Compid", Session["companyid"]);

    //        DataSet ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetCompanyDetails", param);

    //    }
    //    catch (Exception ex)
    //    {
    //        throw ex;
    //    }
    //    return ds.GetXml();
    //}
}