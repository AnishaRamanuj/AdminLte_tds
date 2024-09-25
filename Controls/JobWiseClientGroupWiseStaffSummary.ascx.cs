using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using JTMSProject;
using System.Globalization;
using Microsoft.Reporting.WebForms;
using CommonLibrary;
using System.Collections.Generic;
using Microsoft.ApplicationBlocks1.Data;
using System.Web.Script.Serialization;

public partial class controls_JobwiseClientGroupwiseStaff_Summary : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    private readonly JobMaster job = new JobMaster();
    JobStaffTable jobstaff = new JobStaffTable();
    StaffMaster staff = new StaffMaster();
    CompanyMaster comp = new CompanyMaster();
    ClientMaster client = new ClientMaster();
    DataTable dtstaff = new DataTable();
    DataTable dtjob = new DataTable();
    DataTable dtjobgrp = new DataTable();
    DataTable dtclientgrp = new DataTable();
    DataTable dtclient = new DataTable();
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;
    public string JobID = "";
    public string Clientid = "";
    public string widd1 = "";
    CultureInfo info = new CultureInfo("en-GB");
    LabelAccess objlabelAccess = new LabelAccess();

    List<tbl_LabelAccess> LtblAccess;
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            hdnTStatusCheck.Value = "Submitted,Saved,Approved,Rejected";
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                hdnCompid.Value = Session["cltcomp"].ToString();
                ViewState["compid"] = Session["cltcomp"].ToString();
            }
            if (ViewState["compid"] != null)
            {
                if (Session["usertype"] != null)
                {
                    UserType = Session["usertype"].ToString();
                }
                else
                {
                    Session["companyid"] = null;
                    Session["cltcomp"] = null;
                }
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

                txtstartdate1.Text = "01/04/" + (DateTime.Now.Month <= 3 ? DateTime.Now.Year - 1 : DateTime.Now.Year);
                txtenddate2.Text = Convert.ToDateTime(DateTime.Now.Date).ToString("dd/MM/yyyy");
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
   
        txtstartdate1.Attributes.Add("onblur", "checkForm();");

        txtenddate2.Attributes.Add("onblur", "checkForms();");

    }

    protected void btngen_Click(object sender, EventArgs e)
   {
        try
        {
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else
            {
                Response.Redirect("~/Company/JobWiseClientGroupWiseStaffSummary.aspx", false);
            }
            // companywise labeling
            LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
            Session["Tstatus"]= hdnTStatusCheck.Value ;
            Session["Staffcode"]=hdnStaffCode.Value;
            Session["Sscode"]=hdnSelectedStaffCode.Value;
            Session["SClientGroup"]=hdnselectedclientGrpid.Value;
            Session["Sjob"]=hdnselectedjobid.Value;
            Session["strdate"] = txtstartdate1.Text.Trim();
            Session["enddate"] = txtenddate2.Text.Trim();
            string rd = rdetailed.Checked.ToString();
            Session["rb"] = rd;
            //validation 
            if (hdnselectedjobid.Value == "")
            {
                MessageControl1.SetMessage("Please select at least one Job !", MessageDisplay.DisplayStyles.Error);
                return;
            }
            else
            {
                Response.Redirect("~/JobWiseClientGroupWiseStaffsummaryForm.aspx", false);
            }

        }
        catch(Exception ex)
        {
            MessageControl1.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }
    }

    //private DataSet GetData(int comp)
    //{
    //    DataSet ds = new DataSet();
    //    try
    //    {
    //        DateTime strdate = Convert.ToDateTime(txtstartdate1.Text, info);
    //        DateTime enddate = Convert.ToDateTime(txtenddate2.Text, info);
    //        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
    //        SqlCommand cmd = new SqlCommand("Usp_Report_getdata_jowise_clientgrp_staffsummry");
    //        if (rdetailed.Checked)
    //            cmd = new SqlCommand("Usp_Report_getdata_jowise_clientgrp_staffsummry_Detailed");
    //        else
    //            cmd = new SqlCommand("Usp_Report_getdata_jowise_clientgrp_staffsummry");
    //        cmd.Parameters.AddWithValue("@compid", comp);
    //        cmd.Parameters.AddWithValue("@UserType", hdnUserType.Value);
    //        cmd.Parameters.AddWithValue("@TStatus", hdnTStatusCheck.Value);
    //        cmd.Parameters.AddWithValue("@StaffCode", hdnStaffCode.Value);
    //        cmd.Parameters.AddWithValue("@selectedstaffcode", hdnSelectedStaffCode.Value.Trim(','));
    //        cmd.Parameters.AddWithValue("@selectedclientgrpid", hdnselectedclientGrpid.Value.Trim(','));
    //        cmd.Parameters.AddWithValue("@selectedjobid", hdnselectedjobid.Value.Trim(','));
    //        cmd.Parameters.AddWithValue("@FromDate", strdate);
    //        cmd.Parameters.AddWithValue("@ToDate", enddate);
    //        using (SqlConnection con = new SqlConnection(conString))
    //        {
    //            using (SqlDataAdapter sda = new SqlDataAdapter())
    //            {
    //                cmd.Connection = con;
    //                cmd.CommandType = CommandType.StoredProcedure;
    //                sda.SelectCommand = cmd;
    //                sda.Fill(ds);
    //                return ds;
    //            }
    //        }

    //    }
    //    catch (Exception ex)
    //    {
    //        MessageControl1.SetMessage("No Timesheet Found..", MessageDisplay.DisplayStyles.Error);
    //    }
    //    return ds;
    //}
}