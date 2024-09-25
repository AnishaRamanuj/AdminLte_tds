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
using System.Globalization;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.IO;
using System.Drawing;
public partial class controls_Single_All_Jobs_Staffwise_Summary : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    DataTable dt_portStaff = new DataTable();
    decimal timee = 0;
    decimal charge = 0;
    decimal ope = 0;
    string stf = "";
    decimal total = 0;
    private DataRow dr;
    private string staff, staff2;
    private int Cid, Cid2;
    public string UserType = "";
    public string Staffid = "";
    public Boolean BlnApprover = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["cltcomp"].ToString();
            }
            if (ViewState["compid"] != null)
            {
                UserType = Session["usertype"].ToString();
                if (UserType == "staff")
                {
                    Staffid = Session["staffid"].ToString();
                    Session["IsApprover"] = Staffid;
                }
                string ss = "";
                if (UserType == "staff")
                {

                    //ss = "select * from Job_Master where CompId='" + ViewState["compid"].ToString() + "' and JobApprover='" + Staffid + "' and JobStatus='OnGoing'";
                    //DataTable App = db.GetDataTable(ss);
                    //if (App.Rows.Count != 0)
                    //{
                    //    BlnApprover = true;
                    //}
                    //if (BlnApprover == true)
                    if (Session["Jr_ApproverId"] == "true")
                    {
                        Session["StaffType"] = "App";
                        //ss = "select distinct(MJobid),MJobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "' and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "' order by mjobname";
                        ss = "SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where CompId='" + ViewState["compid"].ToString() + "'  and Approverid='" + Staffid + "' or SuperAppId='" + Session["SuperApp"].ToString() + "'" +
                        " union" +
                        " SELECT distinct(mjobid),MjobName from vw_JobnClientnStaff_new where Staffcode='" + Staffid + "' and (Approverid not in ('" + Staffid + "') or SuperAppId not in ('" + Session["SuperApp"].ToString() + "')) order by mJobName";
                    }
                    else
                    {
                        Session["StaffType"] = "Stf";
                        ss = "select distinct(MJobid),MJobName from vw_JobnStaffnApprover where CompId='" + ViewState["compid"].ToString() + "' and StaffCode='" + Staffid + "'  order by mjobname";
                        //ss = "select * from Staff_Master where CompId='" + ViewState["compid"].ToString() + "' and staffcode='" + Staffid + "' order by StaffName";
                    }
                }

                else
                {
                    Session["StaffType"] = "Adm";

                    ss = "select * from jobname_Master where CompId='" + ViewState["compid"].ToString() + "' order by mjobName";
                }

                //string ss = "select * from jobname_Master where CompId='" + ViewState["compid"].ToString() + "' order by mjobName";
                DataTable dt = db.GetDataTable(ss);
                if (dt.Rows.Count != 0)
                {
                    Job_List.DataSource = dt;
                    Job_List.DataBind();
                }
                //string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
                //hdnFrom.Value = dat;
                //hdnTo.Value = dat;
                DateTime date = DateTime.Now;
                DateTime firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

                hdnFrom.Value = firstDayOfMonth.ToString("yyyy-MM-dd");
                hdnTo.Value = lastDayOfMonth.ToString("yyyy-MM-dd");
                if (Request.QueryString["nodata"] != null)
                {
                    MessageControl1.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

        }


    }

    protected void btngen_Click(object sender, EventArgs e)
    {
        if (Session["companyid"] != null)
        {
            Session["URL"] = "Company/Staff_TimeSheet_Sumary.aspx";
        }
        else if (Session["staffid"] != null)
        {
            Session["URL"] = "Staff/Staff_TimeSheet_Sumary.aspx";
        }
        if (hdnFrom.Value == "" || hdnTo.Value == "")
        {
            //MessageControl1.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);

        }
        else
        {
            //int comp = int.Parse(ViewState["compid"].ToString());


            foreach (DataListItem rw in Job_List.Items)
            {
                Label lblId = (Label)rw.FindControl("Label51");
                decimal wid = decimal.Parse(lblId.Text);
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                if (chk.Checked == true)
                {
                    stf += wid + ",";
                }
            }

            if (stf != "")
            {
                stf = stf.Remove(stf.Length - 1, 1);
            }

            CultureInfo info = new CultureInfo("en-US", false);
            //DateTime Fdob = new DateTime(1900, 1, 1);
            //DateTime dob = new DateTime(1900, 1, 1);
            //String _dateFormat = "dd/MM/yyyy";
            //if (hdnFrom.Value.Trim() != "" && !DateTime.TryParseExact(hdnFrom.Value.Trim(), _dateFormat, info, DateTimeStyles.AllowWhiteSpaces, out Fdob))
            //{
            //}
            //if (hdnTo.Value.Trim() != "" && !DateTime.TryParseExact(hdnTo.Value.Trim(), _dateFormat, info, DateTimeStyles.AllowWhiteSpaces, out dob))
            //{
            //}
            DateTime EDT = Convert.ToDateTime(hdnFrom.Value, info);
            DateTime FDT = Convert.ToDateTime(hdnTo.Value, info);

            Session["startDate"] = FDT;
            Session["enddate"] = EDT;
            Session["Hour"] = timee;
            Session["Charge"] = charge;
            Session["Ope"] = ope;
            Session["Total"] = total;
            Session["dt_St_TSum"] = dt_portStaff;
            Session["Jobid"] = stf;

            string ST = "";
            string Ed = "";
            ST = String.Format("{0:MM/dd/yyyy}", EDT);
            Ed = String.Format("{0:MM/dd/yyyy}", FDT);

            // select Staff for that job
            string sql = "";

            string stfid = "";
            string ids = "";

            if (stfid != "")
            {
                stfid = stfid.Remove(stfid.Length - 1, 1);
            }

            Session["stfid"] = stfid;
            UserType = Session["usertype"].ToString();
            int compid = Convert.ToInt32(Session["companyid"].ToString()); 

            SqlParameter[] param = new SqlParameter[4];
            param[0] = new SqlParameter("@compid", compid);
            param[1] = new SqlParameter("@FromDate", ST);
            param[2] = new SqlParameter("@ToDate", Ed);
            param[3] = new SqlParameter("@mjobid", stf);

            DataSet ds;
            SqlConnection sqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
            ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "Usp_Jobwise_Staff_Summary", param);

            DataTable dts;
            dts = ds.Tables[0];
            if (dts.Rows.Count > 0)
            {
                DumpExcel(dts);
            }
            else
            {
                MessageBox.Show("No Records To EXPORT.");
            }

        }

    }

    private void DumpExcel(DataTable tbl)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Jobwise_Staff_Summary");

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            ws.Cells["A1"].LoadFromDataTable(tbl, true);
            ws.Cells.AutoFitColumns();
            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:AI1"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }


            string ds = "H2:H" + (tbl.Rows.Count + 100).ToString();
            using (ExcelRange rn = ws.Cells[ds])
            {
                //rn.Style.Numberformat.Format = "h:mm";
                rn.Style.Numberformat.Format = "0.00";
            }

            using (var memoryStream = new MemoryStream())
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=Jobwise_Staff_Summary.xls");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }

    protected void chkjob1_CheckedChanged(object sender, EventArgs e)
    {
        if (chkjob1.Checked == true)
        {
            foreach (DataListItem rw in Job_List.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (chkjob1.Checked == false)
        {
            foreach (DataListItem rw in Job_List.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }
}
