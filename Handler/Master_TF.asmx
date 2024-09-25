<%@ WebService Language="C#" Class="Master_TF" %>

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
public class Master_TF : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");

    ////Business Unit 
    [WebMethod]
    public string GetBUnit(int compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@PageIndex", pageIndex);
            param[3] = new SqlParameter("@PageSize", pageSize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetBusinessUnit", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {
                        srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Id = objComm.GetValue<int>(drrr["Buid"].ToString()),
                        Name = objComm.GetValue<string>(drrr["BusUnitName"].ToString()),
                        Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateBU(int compid, string Busunitname, int Buid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", Buid);
            param[2] = new SqlParameter("@BusUnitName", Busunitname);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_InsertUpdate_BusinessUnit", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["Buid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteBU(int compid, int Buid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", Buid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Delete_BusinessUnit", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["Buid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    ////Sub Business Unit

    [WebMethod]
    public string GetSBUnit(int compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@PageIndex", pageIndex);
            param[3] = new SqlParameter("@PageSize", pageSize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetSubBusinessUnit", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {
                        srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Id = objComm.GetValue<int>(drrr["SBUid"].ToString()),
                        Name = objComm.GetValue<string>(drrr["SubBusUnitName"].ToString()),
                        Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateSBU(int compid, string Busunitname, int SBuid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", SBuid);
            param[2] = new SqlParameter("@BusUnitName", Busunitname);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_InsertUpdate_SubBusinessUnit", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["Buid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteSBU(int compid, int Buid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", Buid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Delete_SubBusinessUnit", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["Buid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    ////Product Line Master

    [WebMethod]
    public string GetProductLine(int compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@PageIndex", pageIndex);
            param[3] = new SqlParameter("@PageSize", pageSize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetProductLine", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {
                        srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Id = objComm.GetValue<int>(drrr["PLId"].ToString()),
                        Name = objComm.GetValue<string>(drrr["ProductLine_Name"].ToString()),
                        Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdatePL(int compid, string Busunitname, int SBuid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", SBuid);
            param[2] = new SqlParameter("@BusUnitName", Busunitname);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_InsertUpdate_ProductLine", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["Buid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeletePL(int compid, int Buid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", Buid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Delete_ProductLine", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["Buid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    ////Function Group Master

    [WebMethod]
    public string GetFunctionGroup(int compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@PageIndex", pageIndex);
            param[3] = new SqlParameter("@PageSize", pageSize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetFunctionGroup", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {
                        srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Id = objComm.GetValue<int>(drrr["FGId"].ToString()),
                        Name = objComm.GetValue<string>(drrr["FunctionGroupName"].ToString()),
                        Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateFG(int compid, string Busunitname, int SBuid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", SBuid);
            param[2] = new SqlParameter("@BusUnitName", Busunitname);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_InsertUpdate_FunctionGroup", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["Buid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteFG(int compid, int Buid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", Buid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Delete_FunctionGroup", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["Buid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    ////Function Category Master

    [WebMethod]
    public string GetFunctionCategory(int compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@PageIndex", pageIndex);
            param[3] = new SqlParameter("@PageSize", pageSize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetFunctionCategory", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {
                        srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Id = objComm.GetValue<int>(drrr["FCId"].ToString()),
                        Name = objComm.GetValue<string>(drrr["FunctionCategoryName"].ToString()),
                        Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateFC(int compid, string Busunitname, int SBuid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", SBuid);
            param[2] = new SqlParameter("@BusUnitName", Busunitname);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_InsertUpdate_FunctionCategory", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["Buid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteFC(int compid, int Buid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", Buid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Delete_FunctionCategory", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["Buid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }




    /// ///////////////////////////////////////////////// Mufaddal //////////////////////////////////////

    ////Business Unit 
    [WebMethod]
    public string GetData(int compid, string Srch, int pageIndex, int pageSize, string nm)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            string Proc = "";
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@PageIndex", pageIndex);
            param[3] = new SqlParameter("@PageSize", pageSize);
            if (nm == "Milestone")
            {
                Proc = "usp_Get_Milestone";
            }
            if (nm == "Site")
            {
                Proc = "usp_Get_Site";
            }
            if (nm == "Geo")
            {
                Proc = "usp_Get_Geo";
            }
            if (nm == "Discipline")
            {
                Proc = "usp_Get_Discipline";
            }
            if (nm == "Skill")
            {
                Proc = "usp_Get_Skill";
            }
            if (nm == "Qualification")
            {
                Proc = "usp_Get_Qualification";
            }
            if (nm == "WorkDay")
            {
                Proc = "usp_Get_WManager";
            }
            if (nm == "BU")
            {
                Proc = "usp_Get_BULeader";
            }
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, Proc, param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {
                        srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Id = objComm.GetValue<int>(drrr["id"].ToString()),
                        Name = objComm.GetValue<string>(drrr["Name"].ToString()),
                        Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdate(int compid, string txtval, int id, string nm)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            string Proc = "";
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@id", id);
            param[2] = new SqlParameter("@txtval", txtval);
            if (nm == "Milestone")
            {
                Proc = "usp_InsertUpdate_Milestone";
            }
            if (nm == "Site")
            {
                Proc = "usp_InsertUpdate_Site";
            }
            if (nm == "Geo")
            {
                Proc = "usp_InsertUpdate_Geo";
            }
            if (nm == "Discipline")
            {
                Proc = "usp_InsertUpdate_Discipline";
            }
            if (nm == "Skill")
            {
                Proc = "usp_InsertUpdate_Skill";
            }
            if (nm == "Qualification")
            {
                Proc = "usp_InsertUpdate_Qualification";
            }
            if (nm == "WorkDay")
            {
                Proc = "usp_InsertUpdate_WorkDay";
            }
            if (nm == "BU")
            {
                Proc = "usp_InsertUpdate_BULeader";
            }
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, Proc, param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["id"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string Delete(int compid, int id, string nm)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            string Proc = "";
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@id", id);

            if (nm == "Milestone")
            {
                Proc = "usp_Delete_Milestone";
            }
            if (nm == "Site")
            {
                Proc = "usp_Delete_Site";
            }
            if (nm == "Geo")
            {
                Proc = "usp_Delete_Geo";
            }
            if (nm == "Vendor")
            {
                Proc = "usp_Delete_Vendor";
            }
            if (nm == "Discipline")
            {
                Proc = "usp_Delete_Discipline";
            }
            if (nm == "Skill")
            {
                Proc = "usp_Delete_Skill";
            }
            if (nm == "Qualification")
            {
                Proc = "usp_Delete_Qualification";
            }
            if (nm == "WorkDay")
            {
                Proc = "usp_Delete_WManager";
            }
            if (nm == "BU")
            {
                Proc = "usp_Delete_BULeader";
            }
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, Proc, param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["id"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdate_Vendor(int compid, string txtval, int id, string P, string E, string M, string nm)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            string Proc = "";
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[6];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@id", id);
            param[2] = new SqlParameter("@txtval", txtval);
            param[3] = new SqlParameter("@CPerson", P);
            param[4] = new SqlParameter("@email", E);
            param[5] = new SqlParameter("@mobile", M);

            Proc = "usp_InsertUpdate_Vendor";

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, Proc, param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["id"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string GetData_Vendor(int compid, string Srch, int pageIndex, int pageSize, string nm)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            string Proc = "";
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@PageIndex", pageIndex);
            param[3] = new SqlParameter("@PageSize", pageSize);

            Proc = "usp_Get_Vendor";

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, Proc, param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {
                        srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Id = objComm.GetValue<int>(drrr["id"].ToString()),
                        Name = objComm.GetValue<string>(drrr["Name"].ToString()),
                        CPerson = objComm.GetValue<string>(drrr["Cperson"].ToString()),
                        Mobile = objComm.GetValue<string>(drrr["Mobile"].ToString()),
                        Email = objComm.GetValue<string>(drrr["Email"].ToString()),
                        Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
    ////Project Complexity

    [WebMethod]
    public string GetPC(int compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@PageIndex", pageIndex);
            param[3] = new SqlParameter("@PageSize", pageSize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetProjectComplex", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {
                        srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Id = objComm.GetValue<int>(drrr["PCID"].ToString()),
                        Name = objComm.GetValue<string>(drrr["ProjectComplexity"].ToString()),
                        Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdatePC(int compid, string Busunitname, int Buid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", Buid);
            param[2] = new SqlParameter("@BusUnitName", Busunitname);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_InsertUpdate_ProjectComplex", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["Buid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeletePC(int compid, int Buid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", Buid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Delete_ProjectComplex", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["PCID"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    ////Cost Center

    [WebMethod]
    public string GetCC(int compid, string Srch, int pageIndex, int pageSize)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@srch", Srch);
            param[2] = new SqlParameter("@PageIndex", pageIndex);
            param[3] = new SqlParameter("@PageSize", pageSize);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_GetCostCenter", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {
                        srno = objComm.GetValue<int>(drrr["sino"].ToString()),
                        Id = objComm.GetValue<int>(drrr["CostCenterID"].ToString()),
                        Name = objComm.GetValue<string>(drrr["CostCenter"].ToString()),
                        Totalcount = objComm.GetValue<int>(drrr["Totalcount"].ToString()),
                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string InsertUpdateCC(int compid, string Busunitname, int Buid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", Buid);
            param[2] = new SqlParameter("@BusUnitName", Busunitname);


            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_InsertUpdate_CostCenter", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["Buid"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }

    [WebMethod]
    public string DeleteCC(int compid, int Buid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_Master_TF> List_DS = new List<tbl_Master_TF>();

        try
        {
            Common ob = new Common();
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@buid", Buid);

            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Delete_CostCenter", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Master_TF()
                    {

                        Id = objComm.GetValue<int>(drrr["PCID"].ToString()),

                    });
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
        IEnumerable<tbl_Master_TF> tbl = List_DS as IEnumerable<tbl_Master_TF>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }
}