<%@ WebService Language="C#" Class="DepartmentwiseStaffEffortReport" %>
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

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class DepartmentwiseStaffEffortReport : System.Web.Services.WebService
{
    public static CultureInfo ci = new CultureInfo("en-GB");
    CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
    Common ob = new Common();
    [WebMethod]
    public string GetStaffEffort(int compId, int depId, string month)
    {
        string monthDate = month != "" ? Convert.ToDateTime(month, ci).ToString("MM/dd/yyyy") : null;
        List<tbl_Staff_Effort> List_DS = new List<tbl_Staff_Effort>();
        List<tbl_Staff_Leave> List_DS_1 = new List<tbl_Staff_Leave>();
        try
        {
            SqlParameter[] param = new SqlParameter[3];
            param[0] = new SqlParameter("@CompId", compId);
            param[1] = new SqlParameter("@DeptId", depId);
            param[2] = new SqlParameter("@Monthdate", monthDate);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Staff_Effort_Summary_Report_V2", param))
            {
                while (drrr.Read())
                {
                    List_DS.Add(new tbl_Staff_Effort()
                    {
                        StaffCode = objComm.GetValue<string>(drrr["StaffCode"].ToString()),
                        StaffName = objComm.GetValue<string>(drrr["StaffName"].ToString()),
                        TimeType = objComm.GetValue<string>(drrr["TimeType"].ToString()),
                        Day1 = drrr["1"] == null ? 0 : objComm.GetValue<decimal>(drrr["1"].ToString()),
                        Day2 = drrr["2"] == null ? 0 : objComm.GetValue<decimal>(drrr["2"].ToString()),
                        Day3 = drrr["3"] == null ? 0 : objComm.GetValue<decimal>(drrr["3"].ToString()),
                        Day4 = drrr["4"] == null ? 0 : objComm.GetValue<decimal>(drrr["4"].ToString()),
                        Day5 = drrr["5"] == null ? 0 : objComm.GetValue<decimal>(drrr["5"].ToString()),
                        Day6 = drrr["6"] == null ? 0 : objComm.GetValue<decimal>(drrr["6"].ToString()),
                        Day7 = drrr["7"] == null ? 0 : objComm.GetValue<decimal>(drrr["7"].ToString()),
                        Day8 = drrr["8"] == null ? 0 : objComm.GetValue<decimal>(drrr["8"].ToString()),
                        Day9 = drrr["9"] == null ? 0 : objComm.GetValue<decimal>(drrr["9"].ToString()),
                        Day10 = drrr["10"] == null ? 0 : objComm.GetValue<decimal>(drrr["10"].ToString()),
                        Day11 = drrr["11"] == null ? 0 : objComm.GetValue<decimal>(drrr["11"].ToString()),
                        Day12 = drrr["12"] == null ? 0 : objComm.GetValue<decimal>(drrr["12"].ToString()),
                        Day13 = drrr["13"] == null ? 0 : objComm.GetValue<decimal>(drrr["13"].ToString()),
                        Day14 = drrr["14"] == null ? 0 : objComm.GetValue<decimal>(drrr["14"].ToString()),
                        Day15 = drrr["15"] == null ? 0 : objComm.GetValue<decimal>(drrr["15"].ToString()),
                        Day16 = drrr["16"] == null ? 0 : objComm.GetValue<decimal>(drrr["16"].ToString()),
                        Day17 = drrr["17"] == null ? 0 : objComm.GetValue<decimal>(drrr["17"].ToString()),
                        Day18 = drrr["18"] == null ? 0 : objComm.GetValue<decimal>(drrr["18"].ToString()),
                        Day19 = drrr["19"] == null ? 0 : objComm.GetValue<decimal>(drrr["19"].ToString()),
                        Day20 = drrr["20"] == null ? 0 : objComm.GetValue<decimal>(drrr["20"].ToString()),
                        Day21 = drrr["21"] == null ? 0 : objComm.GetValue<decimal>(drrr["21"].ToString()),
                        Day22 = drrr["22"] == null ? 0 : objComm.GetValue<decimal>(drrr["22"].ToString()),
                        Day23 = drrr["23"] == null ? 0 : objComm.GetValue<decimal>(drrr["23"].ToString()),
                        Day24 = drrr["24"] == null ? 0 : objComm.GetValue<decimal>(drrr["24"].ToString()),
                        Day25 = drrr["25"] == null ? 0 : objComm.GetValue<decimal>(drrr["25"].ToString()),
                        Day26 = drrr["26"] == null ? 0 : objComm.GetValue<decimal>(drrr["26"].ToString()),
                        Day27 = drrr["27"] == null ? 0 : objComm.GetValue<decimal>(drrr["27"].ToString()),
                        Day28 = drrr["28"] == null ? 0 : objComm.GetValue<decimal>(drrr["28"].ToString()),
                        Day29 = (HasColumn(drrr, "29") == false || drrr["29"] == null) ? 0 : objComm.GetValue<decimal>(drrr["29"].ToString()),
                        Day30 = (HasColumn(drrr, "30") == false || drrr["30"] == null) ? 0 : objComm.GetValue<decimal>(drrr["30"].ToString()),
                        Day31 = (HasColumn(drrr, "31") == false || drrr["31"] == null) ? 0 : objComm.GetValue<decimal>(drrr["31"].ToString()),
                        Total = drrr["Total"] == null ? 0 : objComm.GetValue<decimal>(drrr["Total"].ToString()),
                        AvgEfficiency = drrr["AvgEff"] == null ? 0 : objComm.GetValue<decimal>(drrr["AvgEff"].ToString()),
                    });
                }
                if (drrr.NextResult())
                {
                    if (drrr.HasRows)
                    {
                        while (drrr.Read())
                        {
                            List_DS_1.Add(new tbl_Staff_Leave()
                            {
                                StaffId = objComm.GetValue<int>(drrr["StaffCode"].ToString()),
                                StartDate = objComm.GetValue<string>(drrr["StartDate"].ToString()),
                                EndDate = objComm.GetValue<string>(drrr["EndDate"].ToString()),
                                LeaveDays =  objComm.GetValue<decimal>(drrr["Leave_Days"].ToString()),
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
        Departmentwise_Staff_Effort_Report departmentwise_Staff_Effort_Report = new Departmentwise_Staff_Effort_Report();
        departmentwise_Staff_Effort_Report.tbl_Staff_Effort = List_DS;
        departmentwise_Staff_Effort_Report.tbl_Staff_Leave = List_DS_1;
        return new JavaScriptSerializer().Serialize(departmentwise_Staff_Effort_Report);
    }

    public bool HasColumn(IDataRecord dr, string columnName)
    {
        for (int i = 0; i < dr.FieldCount; i++)
        {
            if (dr.GetName(i).Equals(columnName, StringComparison.InvariantCultureIgnoreCase))
                return true;
        }
        return false;
    }
}