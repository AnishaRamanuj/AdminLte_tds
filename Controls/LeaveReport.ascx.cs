using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using CommonLibrary;
using System.Web.Script.Serialization;
using Microsoft.ApplicationBlocks1.Data;
using System.Globalization;

public partial class controls_LeaveReport : System.Web.UI.UserControl
{
    CultureInfo info = new CultureInfo("en-GB");
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                string comp = Session["companyid"].ToString();
                //hdnCompanyID.Value = Session["companyid"].ToString();
                hdnStaffCode.Value = Session["staffid"].ToString();
                hdnCompanyPermission.Value = getCompanyPermissions();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

            //if (Session["Error"].ToString() != "")
            //{
            //    //MessageControl1.SetMessage("No Record Found", MessageDisplay.DisplayStyles.Error);
            //    Session["Error"] = "";
            //}
            /////set Current week start and end date for staff summary
            DateTime date = DateTime.Now;

            DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
            DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);


            hdnFrom.Value = firstDayOfMonth.ToString("yyyy-MM-dd");
            hdnTo.Value = lastDayOfMonth.ToString("yyyy-MM-dd");
            hdnCompname.Value = Session["CompanyName"].ToString();

        }

    }

    protected string getCompanyPermissions()
    {
        try
        {
            List<CompanyTimeThreshold> objCompanyTimeThreshold = new List<CompanyTimeThreshold>();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", Session["companyid"]);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader((new CommonFunctions())._cnnString, CommandType.StoredProcedure, "usp_getCompanyPermission", param))
            {
                while (drrr.Read())
                {
                    objCompanyTimeThreshold.Add(new CompanyTimeThreshold()
                    {
                        LeaveFormat = (new CommonFunctions()).GetValue<bool>(drrr["Leave_Calculated_Hrs"].ToString()),

                    });
                }
            }

            return new JavaScriptSerializer().Serialize(objCompanyTimeThreshold as IEnumerable<CompanyTimeThreshold>).ToString();
        }
        catch (Exception ex)
        {
            //MessageControl1.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
            return ex.Message;

        }
    }
}