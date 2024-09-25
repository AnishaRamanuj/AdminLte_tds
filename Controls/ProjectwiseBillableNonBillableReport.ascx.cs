using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Globalization;
using System.Data.SqlClient;
using System.Configuration;
using Microsoft.ApplicationBlocks1.Data;
using Microsoft.Reporting.WebForms;
using System.Text;



public partial class controls_ProjectwiseBillableNonBillableReport : System.Web.UI.UserControl
{
   
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    CultureInfo info = new CultureInfo("en-GB");
    LabelAccess objlabelAccess = new LabelAccess();
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;
    public string JobID = "";
    public string Clientid = "";
    public string widd1 = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            if (Session["companyid"] != null)
            {
                //hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                //hdnCompid.Value = Session["cltcomp"].ToString();
                ViewState["compid"] = Session["cltcomp"].ToString();
            }
            if (ViewState["compid"] != null)
            {
                if (Session["usertype"] != null)
                {
                    UserType = Session["usertype"].ToString();
                }
                else
                { Session["companyid"] = null; Session["cltcomp"] = null; }
                hdnUserType.Value = UserType;
                if (UserType == "staff")
                {
                    hdnStaffCode.Value = Session["staffid"].ToString();
                    Staffid = Session["staffid"].ToString();
                }

                if (UserType == "staff")
                {
                    if (Session["Jr_ApproverId"].ToString() == "true")
                    {
                        Session["StaffType"] = "App";
                    }
                }
                DateTime date = DateTime.Now;

                DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

                hdnFrom.Value = firstDayOfMonth.ToString("yyyy-MM-dd");
                hdnTo.Value = lastDayOfMonth.ToString("yyyy-MM-dd");
                hdnCompname.Value = Session["CompanyName"].ToString();

            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            if (Session["Error"].ToString() != "")
            {
                MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
                Session["Error"] = "";
            }

        }

        
    }

    //protected void btngen_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        if (Session["companyid"] != null)
    //        {
    //            hdnCompid.Value = Session["companyid"].ToString();
    //            Session["Tstatus"] = hdnTStatusCheck.Value;
    //            Session["Staffcode"] = hdnStaffCode.Value;
    //            Session["Sscode"] = hdnselectedstaff.Value.TrimEnd(',');
    //            Session["SProjectid"] = hdnselectedprojectid.Value.TrimEnd(',');
    //            Session["Sjob"] = hdnselectedmjobid.Value.TrimEnd(',');
    //            Session["strdate"] = txtstartdate1.Text.Trim();
    //            Session["enddate"] = txtenddate2.Text.Trim();
    //            Session["brid"] = hdnBrId.Value;
    //            Session["type"] = hdntype.Value;
    //            Session["Branch"] = hdnbranch.Value;
    //            string rd = rdetailed.Checked.ToString();
    //            Session["rb"] = rd;
    //            //validation 
    //            if (hdnselectedprojectid.Value == "")
    //            {
    //                MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
    //                return;
    //            }
    //            else
    //            {
    //                Response.Redirect("~/Company/Projectwise_Job_StaffForm.aspx", false);
    //            }
    //        }
    //        else
    //        {
    //            Response.Redirect("~/Company/ProjectwiseBillableNonBillableReport.aspx", false);
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
    //    }
    //}


}

    