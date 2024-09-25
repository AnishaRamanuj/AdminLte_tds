using Microsoft.ApplicationBlocks1.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;

public partial class controls_Report_ProjectHours : System.Web.UI.UserControl
{
    List<CommonLibrary.tbl_LabelAccess> LtblAccess;
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    CultureInfo info = new CultureInfo("en-GB");
    LabelAccess objlabelAccess = new LabelAccess();
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;
    public string JobID = "";
    public string Clientid = "";
    public string widd1 = "";
    string IsCSV = "False";
    string deci = "False";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

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
            else
            {
                Response.Redirect("~/Default.aspx");
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
                DateTime datenow = DateTime.Now;

                //DateTime firstDayOfMonth = new DateTime(datenow.Year, datenow.Month, 1);
                //DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

                //string dat = DateTime.Now.Month + "/" + DateTime.Now.Year;
                txtmonth.Text = datenow.ToString("MM/yyyy");
                getCompanyData(hdnCompid.Value);
                DateTime date = Convert.ToDateTime(txtmonth.Text, info);
                DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);
                hdnstartdate1.Value = firstDayOfMonth.ToString("dd/MM/yyyy");
                hdnenddate2.Value = lastDayOfMonth.ToString("dd/MM/yyyy");
                //if (IsCSV == "True")
                //{
                //    btnCSV.Visible = true;
                //}
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
            //DateTime date = DateTime.Now;
            //DateTime date = Convert.ToDateTime(txtmonth.Text, info);
            //DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
            //DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

            //hdnstartdate1.Value = firstDayOfMonth.ToString("dd/MM/yyyy");
            //hdnenddate2.Value = lastDayOfMonth.ToString("dd/MM/yyyy");
            //getCompanyData(hdnCompid.Value);
            //if (IsCSV == "True")
            //{
            //    btnCSV.Visible = true;
            //}
        }
        //txtstartdate1.Attributes.Add("onkeyup", "CountFrmTitle(this,11);");
        //txtenddate2.Attributes.Add("onkeyup", "CountFrmTitle(this,11);");
    }


    private void getCompanyData(string compid)
    {
        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);
            DataSet ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_getCompanyData", param);
            IsCSV = ds.Tables[0].Rows[0]["IsCSV"].ToString();
            deci = ds.Tables[0].Rows[0]["Timesheet_Decimals"].ToString();
        }
        catch (Exception ex)
        {
            throw ex;
        }
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


        Response.AddHeader("Content-disposition", "attachment; filename= All_Department_Client_Project.csv");
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytesFromBuilder);
        Response.End();

        //return content.ToString();
    }


    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(hdnCompid.Value));
                string ReportName = "Period Vs Project :";
                if (hdnselecteddept.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one Department !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                if (hdnselectedprojectid.Value == "")
                {
                    MessageControl1.SetMessage("Please select at least one Project !", MessageDisplay.DisplayStyles.Error);
                    return;
                }
                int comp = int.Parse(ViewState["compid"].ToString());
                getCompanyData(comp.ToString());
                string branch = "All";
                if (hdnbranch.Value != "0")
                {
                    branch = hdnbranch.Value;
                }
                DataSet dsss = GetData(comp);

                if (dsss.Tables != null && dsss.Tables[0].Rows.Count > 0)
                {
                    DataTable dt = new DataTable();
                    DataTable dtdays = new DataTable();
                    dtdays = dsss.Tables[1];
                    dt = dsss.Tables[0];
                    Session["dt"] = dt;
                    Session["dtdays"] = dtdays;
                    Response.Redirect("~/MHLProjectWiseReport.aspx");
                }
                else
                {
                    MessageControl1.SetMessage("No Records Found", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                Response.Redirect("~/Company/Report_ProjectHours.aspx", false);
            }
        }
        catch(Exception ex)
        {
            MessageControl1.SetMessage("No Records Found", MessageDisplay.DisplayStyles.Error);
        }

    }
    private DataSet GetData(int comp)
    {
        DataSet ds = new DataSet();
        try
        {
            DateTime strdate = Convert.ToDateTime(txtmonth.Text, info);
            string conString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            SqlCommand cmd = new SqlCommand("usp_GetMHLProjectWise");
            cmd.Parameters.AddWithValue("@Project_ID", hdnselectedprojectid.Value.TrimEnd(','));
            cmd.Parameters.AddWithValue("@Compid", comp);
            cmd.Parameters.AddWithValue("@monthdate", strdate);
            Session["monthdate"] = txtmonth.Text;
            using (SqlConnection con = new SqlConnection(conString))
            {
                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    sda.SelectCommand = cmd;
                    sda.Fill(ds, "DataTable1");
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

    protected void btnBack_Click(object sender, EventArgs e)
    {
        divReportInput.Visible = true;
        //ReportViewer1.Visible = false;
        btnBack.Visible = false;
    }


    
}