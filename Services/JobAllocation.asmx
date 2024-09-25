<%@ WebService Language="C#" Class="JobAllocation" %>

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
public class JobAllocation  : System.Web.Services.WebService {

    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod]
    public string BindClient(int compid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_GetAllRecords_Allocation> List_DS = new List<tbl_GetAllRecords_Allocation>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_JobAllocation_onLoad", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_GetAllRecords_Allocation()
                    {
                        id = objComm.GetValue<int>(drrr["compid"].ToString()),

                    });
                }
                List<tbl_Alloc_Client> listAlloc_Client = new List<tbl_Alloc_Client>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAlloc_Client.Add(new tbl_Alloc_Client()
                            {
                                cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                ClientName = objComm.GetValue<string>(drrr["ClientName"].ToString()),

                            });
                        }
                    }
                }


                List<tbl_Alloc_Dept> listAlloc_Dep = new List<tbl_Alloc_Dept>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAlloc_Dep.Add(new tbl_Alloc_Dept()
                            {
                                Depid = objComm.GetValue<int>(drrr["depid"].ToString()),
                                DepartmentName = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),

                            });
                        }
                    }
                }

                List<tbl_Alloc_Staffname> listAlloc_Staffname = new List<tbl_Alloc_Staffname>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAlloc_Staffname.Add(new tbl_Alloc_Staffname()
                            {
                                Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                Type = objComm.GetValue<string>(drrr["Type"].ToString()),
                                Depid = objComm.GetValue<int>(drrr["depid"].ToString()),
                            });
                        }
                    }
                }

                List<tbl_Rolewise_Project_Approver_Allocation> listapp = new List<tbl_Rolewise_Project_Approver_Allocation>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listapp.Add(new tbl_Rolewise_Project_Approver_Allocation()
                            {
                                Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                StaffNames = objComm.GetValue<string>(drrr["StaffName"].ToString()),

                            });
                        }
                    }
                }
                List<tbl_Alloc_Jobname> listAlloc_jname = new List<tbl_Alloc_Jobname>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAlloc_jname.Add(new tbl_Alloc_Jobname()
                            {
                                mJobid = objComm.GetValue<int>(drrr["mjobid"].ToString()),
                                mJobname = objComm.GetValue<string>(drrr["mJobname"].ToString()),
                            });
                        }
                    }
                }

                List<tbl_Alloc_JobGroup> listAlloc_jgrp = new List<tbl_Alloc_JobGroup>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAlloc_jgrp.Add(new tbl_Alloc_JobGroup()
                            {
                                jgid = objComm.GetValue<int>(drrr["JobGId"].ToString()),
                                jGroupName = objComm.GetValue<string>(drrr["JobGroupName"].ToString()),

                            });
                        }
                    }
                }

                foreach (var item in List_DS)
                {
                    item.list_Alloc_Client = listAlloc_Client;
                    item.list_Alloc_Dept = listAlloc_Dep;
                    item.list_Alloc_Staffname = listAlloc_Staffname;
                    item.list_Alloc_jobnm  = listAlloc_jname;
                    item.list_Alloc_jGrp  = listAlloc_jgrp ;
                    item.list_Approver = listapp;
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_GetAllRecords_Allocation> tbl = List_DS as IEnumerable<tbl_GetAllRecords_Allocation>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]              //compid ,Srch ,pageIndex ,pageSize ,drpSrch 
    public string BindGrd(int compid, string Srch, int pageIndex, int pageSize, string drpSrch, string JobStatus)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_BindGrd_JobAllocate> List_DS = new List<tbl_BindGrd_JobAllocate>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Srch", Srch);
            param[2] = new SqlParameter("@pageindex", pageIndex);
            param[3] = new SqlParameter("@pagesize", pageSize);
            param[4] = new SqlParameter("@drpSrch", drpSrch);
            param[5] = new SqlParameter("@JobStatus",JobStatus);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Get_JobAllocation", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_BindGrd_JobAllocate()
                    {
                        sino = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Clintname = objComm.GetValue<string>(drrr["ClientName"].ToString()),
                        Jobname = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                        Diff = objComm.GetValue<int>(drrr["Diff"].ToString()),
                        ST = objComm.GetValue<string>(drrr["CreationDate"].ToString()),
                        ED = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                        Jobid = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                        Tcount = objComm.GetValue<int>(drrr["Tcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_BindGrd_JobAllocate> tbl = List_DS as IEnumerable<tbl_BindGrd_JobAllocate>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetJobname(int compid, int cltid )
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Alloc_Jobname> List_DS = new List<tbl_Alloc_Jobname>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Cltid", cltid);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetJobname_Allocation", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Alloc_Jobname()
                    {
                        mJobid = objComm.GetValue<int>(drrr["MJobId"].ToString()),
                        mJobname = objComm.GetValue<string>(drrr["mJobname"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Alloc_Jobname> tbl = List_DS as IEnumerable<tbl_Alloc_Jobname>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string BindEdit(int compid, int jid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_GetJobAllocate_Edit> List_DS = new List<tbl_GetJobAllocate_Edit>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            //param[1] = new SqlParameter("@cltid", cltid);
            param[1] = new SqlParameter("@jobid", jid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_JobAllocation_Edit", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_GetJobAllocate_Edit()
                    {
                        id = objComm.GetValue<int>(drrr["compid"].ToString()),

                    });
                }
                List<tbl_BindGrd_JobAllocate> listAlloc_Client = new List<tbl_BindGrd_JobAllocate>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAlloc_Client.Add(new tbl_BindGrd_JobAllocate()
                            {
                                cltid = objComm.GetValue<int>(drrr["CLTId"].ToString()),
                                ST = objComm.GetValue<string>(drrr["CreationDate"].ToString()),
                                ED = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                                Jobid = objComm.GetValue<int>(drrr["Jobid"].ToString()),
                                mjobid = objComm.GetValue<int>(drrr["MJobId"].ToString()),
                                Jobname = objComm.GetValue<string>(drrr["MJobName"].ToString()),
                                billable = objComm.GetValue<bool>(drrr["billable"].ToString()),
                                Status = objComm.GetValue<string>(drrr["Jobstatus"].ToString()),
                                JobGId = objComm.GetValue<int>(drrr["JobGId"].ToString()),
                                Narration = objComm.GetValue<string>(drrr["Narration"].ToString()),
                            });
                        }
                    }
                }


                List<tbl_Alloc_Staffname> listAlloc_Staffname = new List<tbl_Alloc_Staffname>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listAlloc_Staffname.Add(new tbl_Alloc_Staffname()
                            {
                                Staffcode = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                //Staffname = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                                isChecked = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                Depid = objComm.GetValue<int>(drrr["depid"].ToString()),
                            });
                        }
                    }
                }
                List<tbl_Rolewise_Project_Approver_Allocation> listApp = new List<tbl_Rolewise_Project_Approver_Allocation>();

                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            listApp.Add(new tbl_Rolewise_Project_Approver_Allocation()
                            {
                                Staffcode = objComm.GetValue<int>(drrr["Approverid"].ToString()),
                                Id = objComm.GetValue<int>(drrr["jobid"].ToString()),
                                Role_Id = objComm.GetValue<int>(drrr["RoleAppId"].ToString()),
                            });
                        }
                    }
                }
                foreach (var item in List_DS)
                {
                    item.list_Alloc_Edit = listAlloc_Client;
                    item.list_Alloc_Staffname = listAlloc_Staffname;
                    item.list_Approver = listApp;
                }
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_GetJobAllocate_Edit> tbl = List_DS as IEnumerable<tbl_GetJobAllocate_Edit>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod]   ////{compid:' + compid + ',j:' + j + ',m:' + m + ',c:' + c + ',s:' + s + ',b:' + b + ',g:' + g + ',st:"' + st + '",ed:"' + ed + '",All:"' + All_st + '"
    public string SaveAllocation(int compid, int j , int m , int c, string s, int b, int g, string st, string ed, string All, string apr, string n)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_GetJobAllocate_Edit> List_DS = new List<tbl_GetJobAllocate_Edit>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[12];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@j", j);
            param[2] = new SqlParameter("@c", c );
            param[3] = new SqlParameter("@s", s);
            param[4] = new SqlParameter("@b", b);
            param[5] = new SqlParameter("@g", g);
            param[6] = new SqlParameter("@st", st);
            param[7] = new SqlParameter("@ed", ed);
            param[8] = new SqlParameter("@all", All);
            param[9] = new SqlParameter("@m", m);
            param[10] = new SqlParameter("@apr", apr);
            param[11] = new SqlParameter("@narr", n);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Allocation_Save", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_GetJobAllocate_Edit()
                    {
                        id = objComm.GetValue<int>(drrr["JobId"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_GetJobAllocate_Edit> tbl = List_DS as IEnumerable<tbl_GetJobAllocate_Edit>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Delete_Job(int compid, int Jid )
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Alloc_Jobname> List_DS = new List<tbl_Alloc_Jobname>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@Jid", Jid);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_DeleteJob", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Alloc_Jobname()
                    {
                        mJobid = objComm.GetValue<int>(drrr["jid"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Alloc_Jobname> tbl = List_DS as IEnumerable<tbl_Alloc_Jobname>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


}