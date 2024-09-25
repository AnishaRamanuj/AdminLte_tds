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

public partial class controls_Client_Project_Assignment_Staff_Summary : System.Web.UI.UserControl
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
                txtenddate2.Text = Convert.ToDateTime(DateTime.Now, info).ToString("dd/MM/yyyy");
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        txtstartdate1.Attributes.Add("onblur", "checkForm();");

        txtenddate2.Attributes.Add("onblur", "checkForms();");
    }



    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            int comp = int.Parse(ViewState["compid"].ToString());
            DataSet dsss = GetData(comp);

            if (dsss.Tables != null && dsss.Tables[0].Rows.Count > 0)
            {
                DataTable dt = new DataTable();
                dt = dsss.Tables[0];
                Session["dt"] = dt;
                Session["std"]= Convert.ToString(txtstartdate1.Text, info);
                Session["etd"] = Convert.ToString(txtenddate2.Text, info);
                Response.Redirect("~/Client_project_assignment_StaffSummary_Form.aspx");
            }
            else
            {
                MessageControl1.SetMessage("No Records Found", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }
    }

    private DataSet GetData(int comp)
    {
        DataSet ds = new DataSet();
        try
        {
            DateTime strdate = Convert.ToDateTime(txtstartdate1.Text, info);
            DateTime enddate = Convert.ToDateTime(txtenddate2.Text, info);
            string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            SqlCommand cmd = new SqlCommand("usp_report_Client_Project_Assignment");
            cmd.Parameters.AddWithValue("@compid", comp);
            cmd.Parameters.AddWithValue("@TStatus", hdnTStatusCheck.Value);
            cmd.Parameters.AddWithValue("@StaffCode", hdnStaffCode.Value);
            cmd.Parameters.AddWithValue("@selectedproject", hdnselectedprojectid.Value.Trim(','));
            cmd.Parameters.AddWithValue("@selectedclientid", hdnselectedclientid.Value.Trim(','));
            cmd.Parameters.AddWithValue("@selectedjobid", 0);
            cmd.Parameters.AddWithValue("@SelectedStaffCode", hdnSelectedStaffCode.Value.Trim(','));
            cmd.Parameters.AddWithValue("@FromDate", strdate);
            cmd.Parameters.AddWithValue("@ToDate", enddate);
            cmd.Parameters.AddWithValue("@UserType", hdnUserType.Value);
    
            using (SqlConnection con = new SqlConnection(conString))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    sda.SelectCommand = cmd;
                    sda.Fill(ds, "DT_Client_Project_Assignment_StaffSummary");
                    return ds;
                }
            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("No Timesheet Found..", MessageDisplay.DisplayStyles.Error);
        }
        return ds;
    }

}