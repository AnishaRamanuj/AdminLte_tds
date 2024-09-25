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
using System.Text;
 

public partial class controls_All_Staff_Client_Project_Columnar : System.Web.UI.UserControl
{
    LabelAccess objlabelAccess = new LabelAccess();
    List<CommonLibrary.tbl_LabelAccess> LtblAccess;
    public static SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
    public static CultureInfo ci = new CultureInfo("en-GB");
    string UserType = "";
    string IsCSV = "False";
    string deci = "False";
    protected void Page_Load(object sender, EventArgs e)
    {     

        if (!IsPostBack)
        {
            if (Session["companyid"].ToString() != null) {
                hdnCompid.Value = Session["companyid"].ToString();
               
            }
            if (Session["usertype"] != null)
            {
                UserType = Session["usertype"].ToString();
            }
            else
            { Session["companyid"] = null; Session["cltcomp"] = null; }
            hdnTypeU.Value = UserType;
            if (UserType == "staff")
            {
                hdnstaffid.Value = Session["staffid"].ToString();

            }

            if (UserType == "staff")
            {
                if (Session["Jr_ApproverId"].ToString() == "true")
                {
                    Session["StaffType"] = "App";
                }

            }
           
            getCompanyData(hdnCompid.Value);
            if (IsCSV == "True")
            {
                btnCSV.Visible = true;
            }
            btnBack.Visible = false;
        }

       
    }

    private void getCompanyData(string compid)
    {
        try {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);
            DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_getCompanyData", param);
            IsCSV = ds.Tables[0].Rows[0]["IsCSV"].ToString();
            deci = ds.Tables[0].Rows[0]["Timesheet_Decimals"].ToString();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"].ToString() != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                
                btngen.Visible = false;
                LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
                string ReportName = "";
                if (hdnstaffcode.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one staff !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                if (hdnprojectid.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                string s = "";
                DateTime strdate = Convert.ToDateTime(hdnmonth.Value, ci);
                string thisMonth = strdate.ToString("MMMM");
                string mon = strdate.Month.ToString();
                string year = strdate.ToString("yyyy");
                int comp = Convert.ToInt32(hdnCompid.Value);
                getCompanyData(comp.ToString());
                ReportViewer1.ProcessingMode = ProcessingMode.Local;
                ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/staffReports/Report_All_Staff_Client_Project_Columnar.rdlc");
                ReportName = objlabelAccess.changelabel("Projectwise Staff columnar Report - ", LtblAccess) + hdnTStatusCheck.Value.TrimEnd(',');
                DataSet dsss = getdata(comp);
                ReportDataSource datasource = new ReportDataSource("DataSet1", dsss.Tables[0]);
                ReportViewer1.LocalReport.DataSources.Clear();
                ReportViewer1.LocalReport.DataSources.Add(datasource);
                ReportParameter[] parameters = new ReportParameter[39];
                parameters[0] = new ReportParameter("companyname", Convert.ToString(Session["CompanyName"]).Trim());
                parameters[1] = new ReportParameter("date", ": " + thisMonth + " " + year);
                parameters[2] = new ReportParameter("reportname", ": " + ReportName);
                parameters[3] = new ReportParameter("printedby", ": " + Convert.ToString(Session["Name"]).Trim());
                parameters[4] = new ReportParameter("printeddate", ": " + DateTime.Now.ToString());
                s = "";
                string branch = "All";
                if (hdnbranch.Value != "0")
                {
                    branch = hdnbranch.Value;
                }
                s = objlabelAccess.changelabel("Staff/Client/Project", LtblAccess);
                parameters[5] = new ReportParameter("project", s);
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

                s = "";
                s = objlabelAccess.changelabel("Job", LtblAccess);
                parameters[37] = new ReportParameter("Job", s);

                parameters[38] = new ReportParameter("branch", ":" + branch);

                this.ReportViewer1.LocalReport.SetParameters(parameters);
                ReportViewer1.LocalReport.Refresh();
                divReportInput.Visible = false;
                ReportViewer1.Visible = true;
                btnBack.Visible = true;
            }
            else
            {
                Response.Redirect("~/Company/All_Staff_Client_Project_Columnar.aspx", false);

            }
        }
        catch (Exception ex)
        {
            MessageControl1.SetMessage("No Record Found..", MessageDisplay.DisplayStyles.Error);
        }
    }
    public DataSet getdata(int comp)
    {
        DataSet ds = new DataSet();
        try
        {
            string sp = "";
            if (deci == "False")
            {
                sp = "usp_Report_All_Staff_Client_Project_Columnar_Decimals";
            }
            else
            {
                sp = "usp_Report_All_Staff_Client_Project_Columnar";
            }

            DateTime strdate = Convert.ToDateTime(hdnmonth.Value, ci);
            SqlCommand cmd = new SqlCommand(sp, sqlConn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@compid", hdnCompid.Value);
            cmd.Parameters.AddWithValue("@UserType", UserType);
            cmd.Parameters.AddWithValue("@status", hdnTStatusCheck.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@Staff", hdnstaffcode.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@monthdate", strdate);
            cmd.Parameters.AddWithValue("@Client", hdncltid.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@Project", hdnprojectid.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@job", hdnjobids.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@type", hdntype.Value);

            cmd.CommandTimeout = 999999999;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);

            sqlConn.Close();
        }

        catch (Exception ex)
        {
            throw ex;
        }
        return ds;
    }


    private void ConvertToCSV(DataSet ds)
    {
        StringBuilder content = new StringBuilder();

        if (ds.Tables.Count >= 1)
        {
            DataTable table = ds.Tables[0];

            if (table.Rows.Count > 0)
            {
                DataRow dr1 = (DataRow)table.Rows[0];
                int intColumnCount = dr1.Table.Columns.Count;
                int index = 1;

                //add column names
                foreach (DataColumn item in dr1.Table.Columns)
                {
                    content.Append(String.Format("\"{0}\"", item.ColumnName));
                    if (index < intColumnCount)
                        content.Append(",");
                    else
                        content.Append("\r\n");
                    index++;
                }

                //add column data
                foreach (DataRow currentRow in table.Rows)
                {
                    string strRow = string.Empty;
                    for (int y = 0; y <= intColumnCount - 1; y++)
                    {
                        strRow += "\"" + currentRow[y].ToString() + "\"";

                        if (y < intColumnCount - 1 && y >= 0)
                            strRow += ",";
                    }
                    content.Append(strRow + "\r\n");
                }
            }
        }


        byte[] bytesFromBuilder = Encoding.UTF8.GetBytes(content.ToString());


        Response.AddHeader("Content-disposition", "attachment; filename= Staff_Client_Project_Columnar.csv" );
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytesFromBuilder);
        Response.End();

        //return content.ToString();
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
        divReportInput.Visible = true;
        ReportViewer1.Visible = false;
        btnBack.Visible = false;
        btngen.Visible = true;
       
     
    }
    protected void btnCSV_Click(object sender, EventArgs e)
    {
        DataSet dssssss = new DataSet();
        try {
            if (hdnstaffcode.Value == "")
            {
                MessageControl1.SetMessage("Please select at least one staff !", MessageDisplay.DisplayStyles.Error);
                return;
            }
            DateTime strdate = Convert.ToDateTime(hdnmonth.Value, ci);
            SqlParameter[] param = new SqlParameter[9];
            param[0] = new SqlParameter("@compid", hdnCompid.Value);
            param[1] = new SqlParameter("@UserType", UserType);
            param[2] = new SqlParameter("@status", hdnTStatusCheck.Value.TrimEnd(','));
            param[3] = new SqlParameter("@Staff", hdnstaffcode.Value.TrimEnd(','));
            param[4] = new SqlParameter("@monthdate", strdate);
            param[5] = new SqlParameter("@Client", hdncltid.Value.TrimEnd(','));
            param[6] = new SqlParameter("@Project", hdnprojectid.Value.TrimEnd(','));
            param[7] = new SqlParameter("@job", hdnjobids.Value.TrimEnd(','));
            param[8] = new SqlParameter("@type", hdntype.Value);
            dssssss = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_Report_All_Staff_Client_Project_Columnar_CSV", param);

            ConvertToCSV(dssssss);
        }

        catch (Exception ex) {
            throw ex;
        }
    }
}