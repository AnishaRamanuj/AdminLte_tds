<%@ WebService Language="C#" Class="Project_staff" %>

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
using JTMSProject;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.IO;
using System.Drawing;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Project_staff  : System.Web.Services.WebService {
    public static CultureInfo ci = new CultureInfo("en-GB");

    [WebMethod(EnableSession=true)]
    public string Get_All_Staff_Client_Project_BranchName(int compid=0)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            if (Session["companyid"] != null)
            {
                SqlParameter[] param = new SqlParameter[1];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                using (SqlDataReader sdr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_All_Staff_Client_Project_BranchName", param))
                {
                    while (sdr.Read())
                    {
                        List_SM.Add(new tbl_StaffMaster
                        {
                            BrId = objComm.GetValue<int>(sdr["BrId"].ToString()),
                            Branch = objComm.GetValue<string>(sdr["BranchName"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    [WebMethod]
    public string Get_All_Staff_Client_Project_DepartmentName(int compid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_All_Staff_Client_Project_DepartmentName", param))
            {
                while (sdr.Read())
                {
                    List_SM.Add(new tbl_StaffMaster
                    {
                        DeptId = objComm.GetValue<int>(sdr["DepId"].ToString()),
                        DepartmentName = objComm.GetValue<string>(sdr["DepartmentName"].ToString()),
                    });
                }
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string Bind_Staff_Client_Project_All_Selected(ProjectStaff currobj)//int compid, string UserType, string status, string StaffCode)

    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            if (Session["companyid"] != null)
            {
                DateTime strdate = Convert.ToDateTime(currobj.frommonth, ci);
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[13];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@UserType", currobj.UserType);
                param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
                param[3] = new SqlParameter("@StaffCode", currobj.StaffCode == "" ? "0" : currobj.StaffCode);
                param[4] = new SqlParameter("@selectedstaffcode", currobj.selectedstaffcode.TrimEnd(','));
                param[5] = new SqlParameter("@selectedclientid", currobj.selectetdcltid.TrimEnd(','));
                param[6] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
                param[7] = new SqlParameter("@neetstaff", currobj.staffwise);
                param[8] = new SqlParameter("@neetclient", currobj.clientwise);
                param[9] = new SqlParameter("@needproject", currobj.projectwise);
                param[10] = new SqlParameter("@FromDate", strdate);
                param[11] = new SqlParameter("@RType", currobj.RType);


                //using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_report_Bind_staff_client_Project_selected", param))
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_report_Bind_staff_client_Project", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new tbl_StaffMaster()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                            Type = objComm.GetValue<string>(drrr["type"].ToString())
                        });
                    }
                    drrr.Close();
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }




    [WebMethod]

    public string Get_Staff_Client_Project_All_Selected(ProjectStaff currobj)//int compid, string UserType, string status, string StaffCode)
    {

        CommonFunctions objComm = new CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {

            DateTime strdate = Convert.ToDateTime(currobj.frommonth, ci);

            SqlParameter[] param = new SqlParameter[16];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@UserType", currobj.UserType);
            param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
            param[3] = new SqlParameter("@StaffCode", currobj.StaffCode == "" ? "0" : currobj.StaffCode);
            param[4] = new SqlParameter("@selectedstaffcode", currobj.selectedstaffcode.TrimEnd(','));
            param[5] = new SqlParameter("@selectedclientid", currobj.selectetdcltid.TrimEnd(','));
            param[6] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
            param[7] = new SqlParameter("@neetstaff", currobj.staffwise);
            param[8] = new SqlParameter("@neetclient", currobj.clientwise);
            param[9] = new SqlParameter("@needproject", currobj.projectwise);
            param[10] = new SqlParameter("@FromDate", strdate);
            param[11] = new SqlParameter("@RType", currobj.RType);
            param[12] = new SqlParameter("@Type", currobj.Type);
            param[13] = new SqlParameter("@needjob", currobj.jobwise);
            param[14] = new SqlParameter("@Brid", currobj.BrId);
            param[15] = new SqlParameter("@SelectedDept", currobj.selectedDeptid.TrimEnd(','));
            using (SqlDataReader sdr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Staff_Client_Project_All_Selected", param))
            {
                while (sdr.Read())
                {
                    List_SM.Add(new tbl_StaffMaster()
                    {
                        StaffCode = objComm.GetValue<int>(sdr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(sdr["name"].ToString()),
                        Type = objComm.GetValue<string>(sdr["type"].ToString())
                    });
                }
                sdr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);

    }





    [WebMethod]

    public string Get_Dept_Client_Project_All_Selected(ProjectStaff currobj)//int compid, string UserType, string status, string StaffCode)
    {

        CommonFunctions objComm = new CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {

            DateTime fromdate = Convert.ToDateTime(currobj.fromdate, ci);
            DateTime todate = Convert.ToDateTime(currobj.todate, ci);
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[15];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@UserType", currobj.UserType);
            param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
            param[3] = new SqlParameter("@StaffCode", currobj.StaffCode == "" ? "0" : currobj.StaffCode);
            param[4] = new SqlParameter("@selecteddepid", currobj.selectedDeptid.TrimEnd(','));
            param[5] = new SqlParameter("@selectedclientid", currobj.selectetdcltid.TrimEnd(','));
            param[6] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
            param[7] = new SqlParameter("@neetdept", currobj.deptwise);
            param[8] = new SqlParameter("@neetclient", currobj.clientwise);
            param[9] = new SqlParameter("@needproject", currobj.projectwise);
            param[10] = new SqlParameter("@FromDate", fromdate);
            param[11] = new SqlParameter("@Todate", todate);
            param[12] = new SqlParameter("@RType", currobj.RType);
            param[13] = new SqlParameter("@Type", currobj.Type);
            param[14] = new SqlParameter("@Brid", currobj.BrId);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Dept_Client_Project_All_Selected", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_StaffMaster()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                } drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }



    [WebMethod]

    public string Get_Project_Client_Dept_All_Selected(ProjectStaff currobj)//int compid, string UserType, string status, string StaffCode)
    {

        CommonFunctions objComm = new CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {

            DateTime fromdate = Convert.ToDateTime(currobj.fromdate, ci);
            DateTime todate = Convert.ToDateTime(currobj.todate, ci);
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[15];
            param[0] = new SqlParameter("@compid", currobj.compid);
            param[1] = new SqlParameter("@UserType", currobj.UserType);
            param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
            param[3] = new SqlParameter("@StaffCode", currobj.StaffCode == "" ? "0" : currobj.StaffCode);
            param[4] = new SqlParameter("@selecteddepid", currobj.selectedDeptid.TrimEnd(','));
            param[5] = new SqlParameter("@selectedclientid", currobj.selectetdcltid.TrimEnd(','));
            param[6] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
            param[7] = new SqlParameter("@neetdept", currobj.deptwise);
            param[8] = new SqlParameter("@neetclient", currobj.clientwise);
            param[9] = new SqlParameter("@needproject", currobj.projectwise);
            param[10] = new SqlParameter("@FromDate", fromdate);
            param[11] = new SqlParameter("@Todate", todate);
            param[12] = new SqlParameter("@RType", currobj.RType);

            param[13] = new SqlParameter("@Type", currobj.Type);
            param[14] = new SqlParameter("@Brid", currobj.BrId);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Project_Client_Dept_All_Selected", param))
            {
                while (drrr.Read())
                {
                    List_SM.Add(new tbl_StaffMaster()
                    {
                        StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                        Type = objComm.GetValue<string>(drrr["type"].ToString())
                    });
                } drrr.Close();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod(EnableSession=true)]
    public string Get_Client_Project_Selected(ProjectStaff currobj)//int compid, string UserType, string status, string StaffCode)
    {

        CommonFunctions objComm = new CommonFunctions();
        List<tbl_StaffMaster> List_SM = new List<tbl_StaffMaster>();

        try
        {
            if (Session["companyid"] != null)
            {
                DateTime fromdate = Convert.ToDateTime(currobj.fromdate, ci);
                DateTime todate = Convert.ToDateTime(currobj.todate, ci);
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[13];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@UserType", currobj.UserType);
                param[2] = new SqlParameter("@TStatus", currobj.status.TrimEnd(','));
                param[3] = new SqlParameter("@StaffCode", currobj.StaffCode == "" ? "0" : currobj.StaffCode);
                param[4] = new SqlParameter("@selectedclientid", currobj.selectetdcltid.TrimEnd(','));
                param[5] = new SqlParameter("@selectedprojectid", currobj.selectedprojectid.TrimEnd(','));
                param[6] = new SqlParameter("@neetclient", currobj.clientwise);
                param[7] = new SqlParameter("@needproject", currobj.projectwise);
                param[8] = new SqlParameter("@FromDate", fromdate);
                param[9] = new SqlParameter("@Todate", todate);
                param[10] = new SqlParameter("@RType", currobj.RType);

                param[11] = new SqlParameter("@Type", currobj.Type);
                param[12] = new SqlParameter("@Brid", currobj.BrId);
                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Get_Client_Project_Selected", param))
                {
                    while (drrr.Read())
                    {
                        List_SM.Add(new tbl_StaffMaster()
                        {
                            StaffCode = objComm.GetValue<int>(drrr["id"].ToString()),
                            StaffName = objComm.GetValue<string>(drrr["name"].ToString()),
                            Type = objComm.GetValue<string>(drrr["type"].ToString())
                        });
                    }
                    drrr.Close();
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_StaffMaster> tbl = List_SM as IEnumerable<tbl_StaffMaster>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
}