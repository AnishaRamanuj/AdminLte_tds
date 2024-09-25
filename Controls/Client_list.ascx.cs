using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using JTMSProject;
using Microsoft.Reporting.WebForms;
using System.Data.SqlClient;
using CommonLibrary;
using System.Collections.Generic;

public partial class controls_Client_list : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    DataTable dtclient = new DataTable();
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;
    LabelAccess objlabelAccess = new LabelAccess();

    List<tbl_LabelAccess> LtblAccess;


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
                    if (Session["Jr_ApproverId"] == "true")
                    {
                        Session["StaffType"] = "App";
                    }
                }
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            //if (Session["usertype"] != null)
            //{
            //    UserType = Session["usertype"].ToString();
            //}
            //else
            //{ Session["companyid"] = null; Session["cltcomp"] = null; }
            //hdnUserType.Value = UserType;
            //if (UserType == "staff")
            //{
            //    hdnStaffCode.Value = Session["staffid"].ToString();
            //    Staffid = Session["staffid"].ToString();
            //}

            //if (UserType == "staff")
            //{
            //    if (Session["Jr_ApproverId"] == "true")
            //    {
            //        Session["StaffType"] = "App";
            //    }
            //}
        }
    }
    protected void btnBack_Click(object sender, EventArgs e)
    {
        divReportInput.Visible = true;
        ReportViewer1.Visible = false;
        btnBack.Visible = false;
        btngen.Visible = true;
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));

        if (hdnSelectedStaffCode.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one staff !", MessageDisplay.DisplayStyles.Error);
            return;
        }
        int comp = int.Parse(ViewState["compid"].ToString());

        ReportViewer1.ProcessingMode = ProcessingMode.Local;
        ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_ClientList.rdlc");
        DtClientList dsss = GetData(comp);
        ReportDataSource datasource = new ReportDataSource("DataSet1", dsss.Tables[0]);
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.LocalReport.DataSources.Add(datasource);
        ReportParameter[] parameters = new ReportParameter[5];
        parameters[0] = new ReportParameter("CompanyName", Convert.ToString(Session["CompanyName"]).Trim());
        parameters[1] = new ReportParameter("PrintedBy", ": " + Convert.ToString(Session["Name"]).Trim());
        parameters[2] = new ReportParameter("ReportName", ": " + objlabelAccess.changelabel("Client List",LtblAccess));
        parameters[3] = new ReportParameter("clientnamemaster","" + objlabelAccess.changelabel("Client Name", LtblAccess));
        parameters[4] = new ReportParameter("cgroupmaster" ,""+ objlabelAccess.changelabel("Client Group", LtblAccess));

        this.ReportViewer1.LocalReport.SetParameters(parameters);
        ReportViewer1.LocalReport.DisplayName = objlabelAccess.changelabel("Client List",LtblAccess);
        ReportViewer1.LocalReport.Refresh();
        divReportInput.Visible = false;
        ReportViewer1.Visible = true;
        btnBack.Visible = true;
        btngen.Visible = false;
    }
    private DtClientList GetData(int comp)
    {
        string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        SqlCommand cmd = new SqlCommand("usp_report_BindClientList");
        cmd.Parameters.AddWithValue("@compid", comp);
        cmd.Parameters.AddWithValue("@SelectedStaffCode", hdnSelectedStaffCode.Value.TrimEnd(','));
        using (SqlConnection con = new SqlConnection(conString))
        {
            using (SqlDataAdapter sda = new SqlDataAdapter())
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                sda.SelectCommand = cmd;
                using (DtClientList ds = new DtClientList())
                {
                    sda.Fill(ds, "DataTable1");
                    return ds;
                }
            }
        }
    }
}
