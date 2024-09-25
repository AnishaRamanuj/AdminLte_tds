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

public partial class Admin_Job_List : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    DataTable dtjob = new DataTable();
    DataTable dtstaff = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["admin"] != null)
        {
            if (!IsPostBack)
            {
                bindcomp();
                //Menu1.Items[0].Selected = true;
            }
        }
        else
        {
            Response.Redirect("~/Default.aspx");
        }
        //txtfrom.Attributes.Add("readonly", "readonly");
        //txtto.Attributes.Add("readonly", "readonly");

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
    public void bindjob()
    {
        string ss = "select * from Job_Master where CompId='" + drpcompany.SelectedValue + "' order by JobName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            DataList2.DataSource = dt;
            DataList2.DataBind();
            Label7.Visible = false;
        }
        else
        {
            DataList2.DataSource = null;
            DataList2.DataBind();
            Label7.Visible = false;
        }
    }
    protected void btngenerate_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Job_List.aspx";
            if (drpcompany.SelectedValue == "0")
            {
                MessageControl1.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
            else
            {
                int comp = int.Parse(drpcompany.SelectedValue);
                string id = "";
                foreach (DataListItem rw in DataList2.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        id += "'" + widd + "'" + ",";
                    }

                }
                if (id != "")
                {
                    id = id.Remove(id.Length - 1, 1);

                    string str1 = " select distinct j.JobId,j.JobName,dbo.TotalTime(t.TotalTime) as mints,t.CompId,CONVERT(VARCHAR(10), j.ActualJobEndate, 103) AS ActualJobEndate,CONVERT(VARCHAR(10), j.CreationDate, 103) AS CreationDate,j.JobStatus,t.TotalTime as time1,t.OpeAmt as ope,isnull(sum(t.HourlyCharges),0) as charges,isnull(sum(t.HourlyCharges+t.OpeAmt),0) as chope " +
                                                " from dbo.TimeSheet_Table as t inner join Job_Master as j on j.JobId=t.JobId " +
                                                " left join dbo.OPE_Master as ope on ope.OpeId=t.OpeId " +
                                                " left join dbo.Staff_Master as s on s.StaffCode=t.StaffCode " +
                                                " left join dbo.Designation_Master as d on d.DsgId=s.DsgId " +
                                                " where t.Status='Approved' and convert(float,t.TotalTime) > 0.0 and j.JobId in (" + id + ") group by t.CompId,t.TotalTime,t.OpeAmt,t.HourlyCharges,j.ActualJobEndate,j.CreationDate,j.JobStatus,j.JobId,j.JobName";

                    DataTable dtavail = db.GetDataTable(str1);

                    DataList2.DataSource = dtavail;
                    DataList2.DataBind();
                    int stf = 0;
                    foreach (DataListItem rw in DataList2.Items)
                    {
                        Label lblId = (Label)rw.FindControl("Label51");
                        int Cid = int.Parse(lblId.Text);
                        Label lblstaff = (Label)rw.FindControl("Label50");
                        string staff = lblstaff.Text;
                        CheckBox chk = (CheckBox)rw.FindControl("chkitem");

                        stf = Cid;
                        if (dtjob == null || dtjob.Rows.Count == 0)
                        {
                            dtjob.Columns.Add("JobId", System.Type.GetType("System.String"));
                            dtjob.Columns.Add("JobName", System.Type.GetType("System.String"));
                            DataRow dr = dtjob.NewRow();
                            dr["JobId"] = Cid;
                            dr["JobName"] = staff;
                            dtjob.Rows.Add(dr);
                            dtjob.AcceptChanges();
                        }
                        else
                        {
                            DataRow dr = dtjob.NewRow();
                            dr["JobId"] = Cid;
                            dr["JobName"] = staff;
                            dtjob.Rows.Add(dr);
                            dtjob.AcceptChanges();
                        }
                    }

                    Session["dtjob"] = dtjob;
                    Session["dtstaff"] = null;
                    if (dtjob.Rows.Count > 0)
                    {
                        Session["startdate"] = null;
                        Session["enddate"] = null;
                        Response.Redirect("~/report1.aspx?comp=" + comp + "&pagename=Job_JobList");
                    }
                    else
                    {
                        CheckBox1.Checked = false;
                        drpcompany_SelectedIndexChanged(sender, e);
                        MessageControl1.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl1.SetMessage("No Job Selected.", MessageDisplay.DisplayStyles.Error);
                }
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        if (CheckBox1.Checked == true)
        {
            foreach (DataListItem rw in DataList2.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (CheckBox1.Checked == false)
        {
            foreach (DataListItem rw in DataList2.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
        }
    }
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindjob();
       // bindstaff();
    }
}
