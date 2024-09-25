using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Globalization;
using System.Data;
using Microsoft.Reporting.WebForms;


/// <summary>
/// page created on 22/08/2017 by anil gajre 
/// </summary>

public partial class controls_All_Projectwise_columnarReport : System.Web.UI.UserControl
{
    LabelAccess objlabelAccess = new LabelAccess();
    List<CommonLibrary.tbl_LabelAccess> LtblAccess;
    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    string UserType = "";
    protected void Page_Load(object sender, EventArgs e)
    {
          //hdnCompid.Value = Session["companyid"].ToString();
        
        if (!IsPostBack)
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
            hdnTypeU.Value = UserType;
            if (UserType == "staff")
            {
                hdnstaffid.Value = Session["staffid"].ToString();
               
            }

            if (UserType == "staff")
            {
                if (Session["Jr_ApproverId"] == "true")
                {
                    Session["StaffType"] = "App";
                }
         
            }
            //string dat = DateTime.Now.Month + "/" + DateTime.Now.Year;
            //txtmonth.Text = dat;

        }
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(Session["companyid"]));
        string ReportName = "";
        if (hdnstaffcode.Value == "")
        {
            MessageControl1.SetMessage("Please select at least one staff !", MessageDisplay.DisplayStyles.Error);
            return;
        }
        DateTime strdate = Convert.ToDateTime(hdnmonth.Value, ci);
        string thisMonth= strdate.ToString("MMMM");
        string mon=strdate.Month.ToString();
        string year = strdate.ToString("yyyy");
        int comp = Convert.ToInt32(Session["companyid"]);
        ReportViewer1.ProcessingMode = ProcessingMode.Local;
        ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_projectwise_staff_columnar.rdlc");
        ReportName = objlabelAccess.changelabel("Projectwise Staff columnar Report - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
        DataSet dsss = getdata(comp);
        ReportDataSource datasource = new ReportDataSource("DataSet1", dsss.Tables[0]);
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.LocalReport.DataSources.Add(datasource);
        ReportParameter[] parameters = new ReportParameter[37];
        parameters[0] = new ReportParameter("companyname", Convert.ToString(Session["fulname"]).Trim());
        parameters[1] = new ReportParameter("date", ": " + thisMonth+ " " + year);
        parameters[2] = new ReportParameter("reportname", ": " + ReportName);
        parameters[3] = new ReportParameter("printedby", ": " + Convert.ToString(Session["Name"]).Trim());
        parameters[4] = new ReportParameter("printeddate", ": " + DateTime.Now.ToString());
        parameters[5] = new ReportParameter("project", "Client/Project/Staff");
        parameters[6] = new ReportParameter("d1", "1/" + mon);
        parameters[7] = new ReportParameter("d2", "2/" + mon);
        parameters[8] = new ReportParameter("d3", "3/" + mon);
        parameters[9] = new ReportParameter("d4", "4/" + mon);
        parameters[10] = new ReportParameter("d5", "5/" + mon);
        parameters[11] = new ReportParameter("d6", "6/" + mon);
        parameters[12] = new ReportParameter("d7", "7/" + mon);
        parameters[13] = new ReportParameter("d8", "8/" + mon);
        parameters[14] = new ReportParameter("d9", "9/" + mon);
        parameters[15] = new ReportParameter("d10", "10/" + mon);
        parameters[16] = new ReportParameter("d11", "11/" + mon);
        parameters[17] = new ReportParameter("d12", "12/" + mon);
        parameters[18] = new ReportParameter("d13", "13/" + mon);
        parameters[19] = new ReportParameter("d14", "14/" + mon);
        parameters[20] = new ReportParameter("d15", "15/" + mon);
        parameters[21] = new ReportParameter("d16", "16/" + mon);
        parameters[22] = new ReportParameter("d17", "17/" + mon);
        parameters[23] = new ReportParameter("d18", "18/" + mon);
        parameters[24] = new ReportParameter("d19", "19/" + mon);
        parameters[25] = new ReportParameter("d20", "20/" + mon);
        parameters[26] = new ReportParameter("d21", "21/" + mon);
        parameters[27] = new ReportParameter("d22", "22/" + mon);
        parameters[28] = new ReportParameter("d23", "23/" + mon);
        parameters[29] = new ReportParameter("d24", "24/" + mon);
        parameters[30] = new ReportParameter("d25", "25/" + mon);
        parameters[31] = new ReportParameter("d26", "26/" + mon);
        parameters[32] = new ReportParameter("d27", "27/" + mon);
        parameters[33] = new ReportParameter("d28", "28/" + mon);
        parameters[34] = new ReportParameter("d29", "29/" + mon);
        parameters[35] = new ReportParameter("d30", "30/" + mon);
        parameters[36] = new ReportParameter("d31", "31/" + mon);
     
        this.ReportViewer1.LocalReport.SetParameters(parameters);
        ReportViewer1.LocalReport.Refresh();
        divReportInput.Visible = false;
        ReportViewer1.Visible = true;
        btnBack.Visible = true;
        btngen.Visible = false;
    }
    public DataSet getdata(int comp)
    {
          DataSet ds = new DataSet();
        try
        {

          
            DateTime strdate = Convert.ToDateTime(hdnmonth.Value, ci);
            SqlCommand cmd = new SqlCommand("usp_ProjectwiseStaffColumnarReport", sqlConn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@compid", Session["companyid"]);
            cmd.Parameters.AddWithValue("@UserType", UserType);
            cmd.Parameters.AddWithValue("@status", hdnTStatusCheck.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@Staff", hdnstaffcode.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@monthdate", strdate);
            cmd.Parameters.AddWithValue("@Client",hdncltid.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@Project", hdnprojectid.Value.TrimEnd(','));
            cmd.CommandTimeout = 999999999;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);

        }

        catch(Exception ex)
        {
            throw ex;
        }
        return ds;
    }
    protected void btnBack_Click(object sender, EventArgs e)
    {
        divReportInput.Visible = true;
        ReportViewer1.Visible = false;
        btnBack.Visible = false;
        btngen.Visible = true;
    }

}