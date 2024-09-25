<%@ WebService Language="C#" Class="ProjectMgr" %>

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
using System.Linq;
using Newtonsoft.Json;
using System.Security.Cryptography;  

using System.IO;


[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ProjectMgr  : System.Web.Services.WebService {

    public static CultureInfo ci = new CultureInfo("en-GB");
    [WebMethod(EnableSession=true)]
    public string OnPageLoad(int pageIndex, int pageSize, string Srch, string status,string sortType, int fltr, string staffcode , string rolename, string PjTy)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectonLoad> List_DS = new List<tbl_ProjectonLoad>();
        DataSet ds;
        try
        {
            Common ob = new Common();

          //  string Session["companyid"] = ob.companyid.ToString();

            SqlParameter[] param = new SqlParameter[10];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@pageIndex", pageIndex);
            param[2] = new SqlParameter("@pageSize", pageSize);
            param[3] = new SqlParameter("@Srch", Srch);
            param[4] = new SqlParameter("@status", status);
            param[5] = new SqlParameter("@SortBy", sortType);
            param[6] = new SqlParameter("@fltr", fltr);
            param[7] = new SqlParameter("@staffcode", staffcode);
            param[8] = new SqlParameter("@staffrole", rolename);
            param[9] = new SqlParameter("@PjTy", PjTy);
            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }
    [WebMethod(EnableSession=true)]
    public string OnPageLoad_Appr(int pageIndex, int pageSize, string Srch, string status,string sortType, int fltr, int Cltid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectonLoad> List_DS = new List<tbl_ProjectonLoad>();
        DataSet ds;
        try
        {

            Common ob = new Common();

           // string Session["companyid"] = ob.companyid.ToString();
            SqlParameter[] param = new SqlParameter[8];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@pageIndex", pageIndex);
            param[2] = new SqlParameter("@pageSize", pageSize);
            param[3] = new SqlParameter("@Srch", Srch);
            param[4] = new SqlParameter("@status", status);
            param[5] = new SqlParameter("@SortBy", sortType);
            param[6] = new SqlParameter("@fltr", fltr);
            param[7] = new SqlParameter("@Cltid", Cltid);


            ds = SqlHelper.ExecuteDataset(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Approver", param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

        return ds.GetXml();
    }

    [WebMethod(EnableSession=true)]
    public string Branch(int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_ProjectonLoad> List_DS = new List<tbl_ProjectonLoad>();
        DataSet ds;
        try
        {

            Common ob = new Common();

           //string Session["companyid"] = ob.companyid.ToString();
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

    public static string EncryptCookieValue(string plainText, string key)
    {
        using (Aes aesAlg = Aes.Create())
        {
            aesAlg.Key = Convert.FromBase64String(key);

            // Create a new IV for each encryption to ensure uniqueness
            aesAlg.GenerateIV();
            byte[] iv = aesAlg.IV;

            ICryptoTransform encryptor = aesAlg.CreateEncryptor(aesAlg.Key, iv);

            using (MemoryStream msEncrypt = new MemoryStream())
            {
                // Write the IV to the beginning of the stream
                msEncrypt.Write(iv, 0, iv.Length);

                using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
                {
                    swEncrypt.Write(plainText);
                }

                return Convert.ToBase64String(msEncrypt.ToArray());
            }
        }
    }

    [WebMethod(EnableSession=true)]
    public string get_Details(int Pid )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project_Grd> List_DS = new List<tbl_Project_Grd>();

        try
        {
            HttpContext.Current.Session["pid"] = Pid;
            HttpCookie PrjInfo = new HttpCookie("PrjID");

            PrjInfo["PID"] = EncryptCookieValue(Pid.ToString(), "c/5vDl5UusKXMRvqFrJtMrsFJvaUuWKrGT35BLJnuE4="); 
            PrjInfo.Secure = true;
            PrjInfo.HttpOnly = true;
            PrjInfo.Expires.AddDays(1);
            HttpContext.Current.Response.Cookies.Add(PrjInfo);
            List_DS.Add(new tbl_Project_Grd()
            {
                Pid = Pid,
            });
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_Project_Grd> tbl = List_DS as IEnumerable<tbl_Project_Grd>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession=true)]
    public string Update_Status(int Pid, string Sts )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project_Details> List_DS = new List<tbl_Project_Details>();
        DataSet ds;
        try
        {

            Common ob = new Common();

            //string Session["companyid"] = ob.companyid.ToString();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@Sts", Sts);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Update_Status", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project_Details()
                    {
                        Pid = objComm.GetValue<int>(drrr["Pid"].ToString()),
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
    public string Delete_Project(int Pid)
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project> List_DS = new List<tbl_Project>();
        try
        {
            Common ob = new Common();

            //string Session["companyid"] = ob.companyid.ToString();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_New_Bootstrap_Project_Delete", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project()
                    {
                        Pid = objComm.GetValue<int>(drrr["ProjectId"].ToString()),

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
    public string Update_ActivityMandatory(int Pid, int Sts )
    {
        CommonFunctions objComm = new CommonFunctions();
        List<tbl_Project_Details> List_DS = new List<tbl_Project_Details>();
        DataSet ds;
        try
        {

            Common ob = new Common();

           // string Session["companyid"] = ob.companyid.ToString();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@Pid", Pid);
            param[2] = new SqlParameter("@Sts", Sts);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Update_Project_Status", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Project_Details()
                    {
                        Pid = objComm.GetValue<int>(drrr["Pid"].ToString()),
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
    public string Delete_PLanner(int Pid, int Plid)
    {

        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();

        try
        {
            Common ob = new Common();

           // string Session["companyid"] = ob.companyid.ToString();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            param[1] = new SqlParameter("@ProjectID", Pid);
            param[2] = new SqlParameter("@plid", Plid);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_Planner_Datewise_Remove", param))
            {

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        return JsonConvert.SerializeObject(Plid);

    }

}