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

public partial class Admin_Client_AlljobsHoursConsumedDay : System.Web.UI.Page
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
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindcomp();
            //bindclient();
            //bindstaff();
            //bindjob();
            //Label7.Visible = true;
            //Label8.Visible = true;
            string dat = DateTime.Now.Month + "/" + DateTime.Now.Year;
            fromdate.Text = dat;
            //txtenddate.Text = dat; 

        }
        fromdate.Attributes.Add("onblur", "checkForm();");
        //txtenddate.Attributes.Add("readonly", "readonly");
 
    }
    public void bindcomp()
    {
        string ss = "select * from Company_Master order by CompanyName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            drpcompany.DataSource = dt;
            drpcompany.DataBind();
        }
    }
    protected void btngenerate_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Client_AlljobsHoursConsumedDay.aspx";
            if (drpclient.SelectedValue != "0" && drpcompany.SelectedValue != "0" && fromdate.Text != "")
            {
                Session["dtclient"] = null;
                string startdate = fromdate.Text;
                DateTime date = Convert.ToDateTime(fromdate.Text);
                DateTime startDate = date;
                DateTime lastdate = DateTime.Now;
                DateTime endDate = startDate.AddMonths(1).AddDays(-1);
                int clnt = int.Parse(drpclient.SelectedValue);
                //int clnt = int.Parse(drpclient.SelectedValue);
                int comp = int.Parse(drpcompany.SelectedValue);
                //string StrSQL1 = "select StaffCode,StaffName from Staff_Master where CLTId=" + clnt;
                string StrSQL1 = "select distinct StaffCode from TimeSheet_Table where CLTId=" + clnt;
                DataTable dtUserInfo1 = db.GetDataTable(StrSQL1);
                //CultureInfo info = new CultureInfo("en-US", false);
                //DateTime Fdob = new DateTime(1900, 1, 1);
                //DateTime dob = new DateTime(1900, 1, 1);
                //String _dateFormat = "dd/MM/yyyy";
                //if (fromdate.Text.Trim() != "" && !DateTime.TryParseExact(fromdate.Text.Trim(), _dateFormat, info,
                //                                                                                     DateTimeStyles.AllowWhiteSpaces, out Fdob))
                //{
                //}
                //if (txtenddate.Text.Trim() != "" && !DateTime.TryParseExact(txtenddate.Text.Trim(), _dateFormat, info,
                //                                                                                      DateTimeStyles.AllowWhiteSpaces, out dob))
                //{
                //}
                if (dtUserInfo1.Rows.Count != 0)
                {
                    string idstf = "";
                    foreach (DataRow rw in dtUserInfo1.Rows)
                    {
                        decimal widd = decimal.Parse(rw["StaffCode"].ToString());
                        //decimal widd = decimal.Parse(lblId.Text);
                        // CheckBox chk = (CheckBox)rw.FindControl("chkitem1");              
                        idstf += "'" + widd + "'" + ",";

                    }
                    if (idstf != "")
                    {
                        idstf = idstf.Remove(idstf.Length - 1, 1);
                        string str1 = "select t.TSId,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.Date as dt,t.OpeAmt as ope,ope.OPEName,j.JobName,j.JobId " +
                                           " from dbo.TimeSheet_Table as t left join Job_Master as j on j.JobId=t.JobId " +
                                           " left join dbo.OPE_Master as ope on ope.OpeId=t.OpeId" +
                                           " where t.Status='Approved' and t.CLTId='" + clnt + "' and t.CompId='" + comp + "' and t.Date between '" + startDate + "' and '" + endDate + "'";

                        DataTable dtavail = db.GetDataTable(str1);
                        string id = "";
                        string iddt = "";
                        if (dtavail.Rows.Count != 0)
                        {
                            foreach (DataRow rw in dtavail.Rows)
                            {
                                decimal widd = decimal.Parse(rw["JobId"].ToString());
                                DateTime widd1 = DateTime.Parse(rw["dt"].ToString());
                                //decimal widd = decimal.Parse(lblId.Text);
                                // CheckBox chk = (CheckBox)rw.FindControl("chkitem1");              
                                id += "'" + widd + "'" + ",";
                                iddt += "'" + widd1 + "'" + ",";

                            }
                            id = id.Remove(id.Length - 1, 1);
                            iddt = iddt.Remove(iddt.Length - 1, 1);
                            string str2 = "select distinct t.StaffCode,s.StaffName  " +
                                " from dbo.TimeSheet_Table as t " +
                                  "left join dbo.Staff_Master as s on s.StaffCode=t.StaffCode" +
                                " where  t.StaffCode in (" + idstf + ") and t.JobId in (" + id + ") and t.Date in (" + iddt + ") and t.CLTId='" + clnt + "' and t.CompId='" + comp + "' and t.Date between '" + startDate + "' and '" + endDate + "'  group by t.StaffCode,s.StaffName";

                            DataTable dtavail1 = db.GetDataTable(str2);
                            DataTable dtstf = new DataTable();
                            if (dtavail1.Rows.Count != 0)
                            {
                                foreach (DataRow dr1 in dtavail1.Rows)
                                {
                                    if (dtstf == null || dtstf.Rows.Count == 0)
                                    {
                                        dtstf.Columns.Add("StaffCode", System.Type.GetType("System.String"));
                                        dtstf.Columns.Add("StaffName", System.Type.GetType("System.String"));
                                        DataRow dr = dtstf.NewRow();
                                        dr["StaffCode"] = dr1["StaffCode"].ToString();
                                        dr["StaffName"] = dr1["StaffName"].ToString();
                                        dtstf.Rows.Add(dr);
                                        dtstf.AcceptChanges();
                                    }
                                    else
                                    {
                                        DataRow dr = dtstf.NewRow();
                                        dr["StaffCode"] = dr1["StaffCode"].ToString();
                                        dr["StaffName"] = dr1["StaffName"].ToString();
                                        dtstf.Rows.Add(dr);
                                        dtstf.AcceptChanges();
                                    }
                                }
                                Session["availstf"] = dtstf;
                                if (dtstf.Rows.Count > 0)
                                {
                                    Session["startdate"] = null;
                                    Session["enddate"] = null;
                                    Response.Redirect("~/report1.aspx?comp=" + comp + "&clnt=" + clnt + "&dat=" + startdate + "&pagename=AlljobsHoursConsumedDay");
                                }
                                else
                                {
                                    MessageControl2.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                                }
                            }
                            else
                            {
                                MessageControl2.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                            }
                        }
                    }
                    else
                    {
                        MessageControl2.SetMessage("No Staff Selected.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl2.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                MessageControl2.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindclient();
    }
    public void bindclient()
    {
        string ss = "select * from Client_Master where CompId='" + drpcompany.SelectedValue + "' order by ClientName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            drpclient.Items.Clear();
            drpclient.DataSource = dt;
            drpclient.DataBind();
            //drpclient.Items.Remove("--None--");
        }
        else
        {
            drpclient.Items.Clear();
            drpclient.Items.Insert(0, "--None--");
        }
    }
}