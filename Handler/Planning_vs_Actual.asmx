<%@ WebService Language="C#" Class="Planning_vs_Actual" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Globalization;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Text;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Planning_vs_Actual : System.Web.Services.WebService
{

    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

    [WebMethod(EnableSession = true)]
    public string GetDeptRecordActivity(int mjobid)
    {
        CommonLibrary.CommonFunctions objComm = new CommonLibrary.CommonFunctions();
        List<tbl_DepartmentBudgeting> obj_Job = new List<tbl_DepartmentBudgeting>();
        try
        {
            if (Session["companyid"] != null)
            {
                Common ob = new Common();
                SqlParameter[] param = new SqlParameter[2];
                param[0] = new SqlParameter("@compid", Session["companyid"]);
                param[1] = new SqlParameter("@mjobid", mjobid);

                using (SqlDataReader drrr = SqlHelper.ExecuteReader(objComm._cnnString, CommandType.StoredProcedure, "usp_Bootstrap_GetDepartment", param))
                {
                    while (drrr.Read())
                    {
                        obj_Job.Add(new tbl_DepartmentBudgeting()
                        {
                            depid = objComm.GetValue<int>(drrr["DepId"].ToString()),
                            Deptname = objComm.GetValue<string>(drrr["DepartmentName"].ToString()),
                            Jobid = objComm.GetValue<int>(drrr["ischecked"].ToString()),
                        });
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

        IEnumerable<tbl_DepartmentBudgeting> tbl = obj_Job as IEnumerable<tbl_DepartmentBudgeting>;
        var obbbbb = tbl;
        return new JavaScriptSerializer().Serialize(tbl);
    }


    [WebMethod(EnableSession = true)]
    public string Get_PlanningvsActual_Report(ProjectStaff currobj)
    {
        CommonFunctions objcomm = new CommonFunctions();
        List<tbl_PlanningVsActual_Report> objtbl = new List<tbl_PlanningVsActual_Report>();
        StringBuilder strTable = new StringBuilder();
        //string results = "";
        DataSet ds;
        try
        {
            
                SqlParameter[] param = new SqlParameter[5];
                param[0] = new SqlParameter("@Compid", Session["companyid"]);
                param[1] = new SqlParameter("@FromDate", currobj.fromdate);
                param[2] = new SqlParameter("@ToDate", currobj.todate);
                param[3] = new SqlParameter("@selectedDepartmentid", currobj.selectedDeptid);
                param[4] = new SqlParameter("@selectedstaffcode", currobj.selectedstaffcode);


                //int wkj = 0;
                //int iRow = 0;
                //int stWeek = 0;
                //string PLid = "";

                ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_Bootstrap_PlanningvsActual_ReportNew", param);

                //if (ds.Tables[0].Rows.Count > 0)
                //{
                //    int workingHour = currobj.workingHour * 60;
                //    string MonthHeader = "", WeekHeader = "", tableSubHeader = "";
                //    int j = 1;
                //    strTable.Append("<tbody class='fc-body;'><tr><td colspan='4'></td>");
                //    for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                //    {
                //        // WeekHeader += "<td colspan='2' style='text-align: center; width:10%;'><b>W" + ds.Tables[1].Rows[i]["Weekk"] + "</b></td>";
                //        MonthHeader += "<td colspan='2' style='text-align: center; width:10%;'><b>Wk" + ds.Tables[1].Rows[i]["Weekk"] + "</b></td>";
                //        tableSubHeader += "<td style='text-align: center; width:5%;'><b>SOW%</b></td><td style='text-align: center; width:5%;'><b>Hours</b></td>";
                //        j++;
                //    }

                //    j = Convert.ToInt32(ds.Tables[0].Rows[0]["weekno"]);
                //    stWeek = j;
                //    // strTable.Append(MonthHeader + "</tr><tr><td colspan='4'></td>" + WeekHeader + "</tr>");
                //    strTable.Append(MonthHeader + "</tr>");
                //    strTable.Append("<tr >");
                //    strTable.Append("<td style='text-align: left; width:10%;'><b>Name</b></td>"); //Header
                //    strTable.Append("<td style='text-align: left; width:20%;'><b>Projects</b></td>"); //Header
                //    strTable.Append("<td style='text-align: left; width:5%;'><b>Engagement from</b></td>"); //Header
                //    strTable.Append("<td style='text-align: left; width:5%;'><b>Engagement To</b></td>"); //Header
                //    strTable.Append(tableSubHeader);
                //    strTable.Append("</tr>");
                //    string departmentName = "", StaffName = "", ProjectName = "";
                //    for (int k = 0; k < ds.Tables[3].Rows.Count; k++)
                //    {

                //        if (departmentName != ds.Tables[3].Rows[k]["DepartmentName"].ToString())
                //        {//////////////// Setting New department
                //            departmentName = ds.Tables[3].Rows[k]["DepartmentName"].ToString();
                //            ds.Tables[1].DefaultView.RowFilter = "DepartmentName='" + departmentName + "'";
                //            strTable.Append("<tr>");
                //            for (int d = 0; d < ds.Tables[1].DefaultView.Count; d++)
                //            {
                //                if (d == 0)
                //                {
                //                    strTable.Append("<td style='text-align: center; width:30%;'><b>" + ds.Tables[1].DefaultView[d]["DepartmentName"].ToString() + "</b></td>"); //Header
                //                    strTable.Append("<td colspan='3'></td>");
                //                    strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[1].DefaultView[d]["SOW"] + "</td>"); //Header
                //                    strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[1].DefaultView[d]["Actual"] + " </td > "); //Header
                //                }
                //                else
                //                {
                //                    strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[1].DefaultView[d]["SOW"] + "</td>"); //Header
                //                    strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[1].DefaultView[d]["Actual"] + "</td > "); //Header
                //                }
                //            }
                //            strTable.Append("</tr>");
                //        }

                //        if (StaffName != ds.Tables[3].Rows[k]["StaffName"].ToString())
                //        {
                //            ProjectName = "";
                //            PLid = "";
                //            StaffName = ds.Tables[3].Rows[k]["StaffName"].ToString();
                //            ds.Tables[2].DefaultView.RowFilter = "DepartmentName='" + departmentName + "' and StaffName='" + ds.Tables[3].Rows[k]["StaffName"].ToString() + "'";
                //            ////// Leave line after every staff
                //            strTable.Append("<tr>");
                //            strTable.Append("<td style='text-align: center; width:30%;'></td>");
                //            strTable.Append("<td colspan='3'></td>");
                //            strTable.Append("<td style='text-align: center; width:5%;'></td>");
                //            strTable.Append("<td style='text-align: center; width:5%;'></td>");
                //            for (int d = 0; d < ds.Tables[0].DefaultView.Count; d++)
                //            {
                //                strTable.Append("<td style='text-align: center; width:5%;'></td>");
                //            }
                //            strTable.Append("</tr><tr>");
                //            for (int d = 0; d < ds.Tables[2].DefaultView.Count; d++)
                //            {
                //                if (d == 0)
                //                {
                //                    strTable.Append("<td style='text-align: center; width:30%;'><b>" + ds.Tables[2].DefaultView[d]["StaffName"].ToString() + "</b></td>"); //Header
                //                    strTable.Append("<td colspan='3'></td>");
                //                    strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[2].DefaultView[d]["SOW"] + "</td>"); //Header
                //                    //strTable.Append("<td style='text-align: center; width:5%;'>" + timeConvert(Convert.ToInt32(ds.Tables[2].DefaultView[d]["Actual"])) + "(" + ((Convert.ToInt32(ds.Tables[2].DefaultView[d]["Actual"]) / currobj.workingHour) * 100) + "%)</td > "); //Header
                //                    strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[2].DefaultView[d]["Actual"] + "</td > "); //Header
                //                }
                //                else
                //                {

                //                    strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[2].DefaultView[d]["SOW"] + "</td>"); //Header
                //                    strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[2].DefaultView[d]["Actual"] + "</td > "); //Header
                //                    //strTable.Append("<td style='text-align: center; width:5%;'>" + timeConvert(Convert.ToInt32(ds.Tables[2].DefaultView[d]["Actual"])) + "(" + ((Convert.ToInt32(ds.Tables[2].DefaultView[d]["Actual"]) / currobj.workingHour) * 100) + "%)</td > "); //Header
                //                }
                //            }
                //            strTable.Append("</tr>");

                //        }

                //        if (StaffName == ds.Tables[3].Rows[k]["StaffName"].ToString() && PLid != ds.Tables[3].Rows[k]["Plid"].ToString())
                //        {
                //            ProjectName = ds.Tables[3].Rows[k]["ProjectName"].ToString();
                //            PLid = ds.Tables[3].Rows[k]["Plid"].ToString();
                //            iRow = 0;
                //            if (k != 0)
                //                strTable.Append("</tr>");

                //            strTable.Append("<tr>");
                //            strTable.Append("<td style='text-align: left; width:10%;'>" + ds.Tables[3].Rows[k]["StaffName"].ToString() + "</td>"); //Header
                //            strTable.Append("<td style='text-align: left; width:20%;'>" + ds.Tables[3].Rows[k]["ProjectName"].ToString() + "</td>"); //Header
                //            strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[3].Rows[k]["pfrdt"].ToString() + "</td>"); //Header
                //            strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[3].Rows[k]["pTodt"].ToString() + "</td>"); //Header
                //            wkj = Convert.ToInt32(ds.Tables[0].Rows[iRow]["weekno"]);
                //            int r = Convert.ToInt32(ds.Tables[3].Rows[k]["weekk"]);
                //            if (wkj == r)
                //            {
                //                strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[3].Rows[k]["SOW"].ToString() + "</td>"); //Header
                //                strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[3].Rows[k]["Actual"] + "</td > "); //Header
                //            }
                //            else if (wkj < r)
                //            {
                //                for (int d = wkj; d < r; d++)
                //                {
                //                    strTable.Append("<td style='text-align: center; width:5%;'></td>"); //Header
                //                    strTable.Append("<td style='text-align: center; width:5%;'></td > "); //Header
                //                    iRow = iRow + 1;
                //                }

                //                strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[3].Rows[k]["SOW"].ToString() + "</td>"); //Header
                //                strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[3].Rows[k]["Actual"] + "</td > "); //Header

                //            }
                //            iRow = iRow + 1;
                //        }
                //        else
                //        {


                //            int ii = 0;
                //            ii = ds.Tables[0].Rows.Count-1 ;
                //            if (ii >= iRow)
                //            {
                //                wkj = Convert.ToInt32(ds.Tables[0].Rows[iRow]["weekno"]);
                //            }
                //            else
                //            {
                //                wkj = Convert.ToInt32(ds.Tables[0].Rows[ii]["weekno"]);
                //            }
                //            int r = Convert.ToInt32(ds.Tables[3].Rows[k]["weekk"]);
                //            if (wkj == r)
                //            {
                //                strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[3].Rows[k]["SOW"].ToString() + "</td>"); //Header
                //                strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[3].Rows[k]["Actual"] +  "</td > "); //Header
                //            }
                //            else if (wkj < r)
                //            {
                //                for (int d = wkj; d < r; d++)
                //                {
                //                    strTable.Append("<td style='text-align: center; width:5%;'></td>"); //Header
                //                    strTable.Append("<td style='text-align: center; width:5%;'></td > "); //Header
                //                    iRow = iRow + 1;
                //                }

                //                strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[3].Rows[k]["SOW"].ToString() + "</td>"); //Header
                //                strTable.Append("<td style='text-align: center; width:5%;'>" + ds.Tables[3].Rows[k]["Actual"] + "</td > "); //Header

                //            }

                //            iRow = iRow + 1;
                //        }
                //    }
                //    strTable.Append("</tbody>");
                //}

                //return strTable.ToString();
                return ds.GetXml();            
        }
        catch (Exception ex)
        {
            return null;
            //return strTable.ToString();
        }

    }

    public string timeConvert(int n)
    {
        var num = n;
        decimal hours = (num / 60);
        var rhours = Math.Floor(hours);
        var minutes = (hours - rhours) * 60;
        var rminutes = Math.Round(minutes);
        var FinaldateTime = "";
        if (rhours.ToString().Length == 1)
            FinaldateTime = "0" + rhours;
        else
            FinaldateTime = rhours.ToString();
        if (rminutes.ToString().Length == 1)
            FinaldateTime += ":0" + rminutes;
        else
            FinaldateTime += ":" + rminutes;
        return FinaldateTime;
    }

}