using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;

public partial class Admin_AllJobs_FortNight : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    DataTable dt_jb_frt = new DataTable();
    public string[,] weeks = new string[2, 2];
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["admin"] != null)
            { 
            }
            else
            {
                Response.Redirect("Default.aspx");
            }
            string dat = DateTime.Now.Month + "/" + DateTime.Now.Year;
            //fromdate.Text = dat;
            txtenddate2.Text = dat;
            txtenddate2.Attributes.Add("onblur", "checkForm();");
        }     
    }
    protected void drpcompanylist_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (drpcompanylist.SelectedIndex != 0)
        {
            string qry = string.Format("select * from dbo.Client_Master where CompId='"+ drpcompanylist.SelectedValue+"' order by ClientName");
            DataTable dt_clt = db.GetDataTable(qry);
            if (dt_clt.Rows.Count != 0)
            {
                List_Client.DataSource = dt_clt;
                List_Client.DataBind();
            }
           
        }
    }
    protected void chkjob1_CheckedChanged(object sender, EventArgs e)
    {
        if (chkjob1.Checked == true)
        {
            foreach (DataListItem rw in List_Client.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (chkjob1.Checked == false)
        {
            foreach (DataListItem rw in List_Client.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/AllJobs_FortNight.aspx";
            if (drpcompanylist.SelectedIndex != 0 && txtenddate2.Text != "")
            {
                calculateWeek();
                int comp = int.Parse(drpcompanylist.SelectedValue);
                string idstf = "";
                foreach (DataListItem rw in List_Client.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    decimal widd = decimal.Parse(lblId.Text);
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                    if (chk.Checked == true)
                    {
                        idstf += "'" + widd + "'" + ",";
                    }

                }
                if (idstf != "")
                {
                    idstf = idstf.Remove(idstf.Length - 1, 1);
                }
                string str1 = "select sum(TotalTime)as TotalTime, sum(Charges)as Charges, sum(OpeAmt)as OpeAmt,tot.ClientName,tot.ClTId from(" +
                                        " select  ct.ClientName,t.ClTId,t.StaffCode,isnull(sum(convert(float,t.TotalTime)),0) as TotalTime," +
                                        " ( isnull(dbo.Hours_Charges(t.StaffCode,t.Date),0) )*isnull(sum(convert(float,t.TotalTime)),0)as Charges," +
                                        " isnull(sum(t.OpeAmt),0) as OpeAmt from dbo.Job_Master as j left join dbo.TimeSheet_Table as t on t.JobId=j.JobId left join Client_Master as c on c.CLTId=t.CLTId and j.CompId='" + comp + "' left join dbo.Client_Master as ct on ct.CLTId=t.ClTId where  j.ClTId in (" + idstf + ") " +
                                        " and  t.Date >='" + Convert.ToDateTime(Session["frt_1"]).ToString() + "' and t.Date <='" + Convert.ToDateTime(Session["frt_4"]).ToString() + "' group by t.StaffCode,t.ClTId,ct.ClientName,t.Date)as tot group by  tot.ClTId,tot.ClientName";

                DataTable dtavail = db.GetDataTable(str1);
                List_Client.DataSource = dtavail;
                List_Client.DataBind();
                int stf = 0;
                foreach (DataListItem rw in List_Client.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    int Cid = int.Parse(lblId.Text);
                    Label lblstaff = (Label)rw.FindControl("Label50");
                    string staff = lblstaff.Text;
                    //CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                    //if (chk.Checked == true)
                    //{
                    stf = Cid;
                    if (dt_jb_frt == null || dt_jb_frt.Rows.Count == 0)
                    {
                        dt_jb_frt.Columns.Add("CLTId", System.Type.GetType("System.String"));
                        dt_jb_frt.Columns.Add("CompId", System.Type.GetType("System.String"));
                        dt_jb_frt.Columns.Add("ClientName", System.Type.GetType("System.String"));
                        DataRow dr = dt_jb_frt.NewRow();
                        dr["CLTId"] = Cid;
                        dr["CompId"] = comp;
                        dr["ClientName"] = staff;
                        dt_jb_frt.Rows.Add(dr);
                        dt_jb_frt.AcceptChanges();
                    }
                    else
                    {
                        DataRow dr = dt_jb_frt.NewRow();
                        dr["CLTId"] = Cid;
                        dr["CompId"] = comp;
                        dr["ClientName"] = staff;
                        dt_jb_frt.Rows.Add(dr);
                        dt_jb_frt.AcceptChanges();
                    }
                    // }
                }
                Session["dt_jb_frt"] = dt_jb_frt;
                if (dt_jb_frt.Rows.Count > 0)
                {
                    Response.Redirect("../report1.aspx?dt=" + txtenddate2.Text + "&comp=" + comp + "&pagename=AllJobs_FortNight_Report");
                    //Response.Redirect("../report1.aspx?comp=" + comp + "&pagename=AllJobs_FortNight_Report");
                }
                else if (idstf == "")
                {
                    chkjob1.Checked = false;
                    drpcompanylist_SelectedIndexChanged(sender, e);
                    MessageControl1.SetMessage("No Clients Selected.", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    chkjob1.Checked = false;
                    drpcompanylist_SelectedIndexChanged(sender, e);
                    MessageControl1.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                chkjob1.Checked = false;
                MessageControl1.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }

    public void calculateWeek()
    {
        DateTime date = Convert.ToDateTime(txtenddate2.Text);

        DateTime startDate = date;
        DateTime lastdate = DateTime.Now;
        DateTime endDate = startDate.AddMonths(1).AddDays(-1);
        int i = 0;
        for (DateTime result = startDate; result <= endDate; result = lastdate.AddDays(1))
        {
            if (result.Day != 31)
            {
                weeks[i, 0] = result.ToString();
                if (result.AddDays(14) >= endDate)
                {
                    weeks[i, 1] = endDate.ToString();
                    lastdate = result.AddDays(14);
                }
                else
                {
                    weeks[i, 1] = result.AddDays(14).ToString();
                    lastdate = result.AddDays(14);
                }
            }
            else
            {
                weeks[i - 1, 1] = result.ToString();
                lastdate = result.AddDays(14);
            }
            i++;

        }

        if (weeks.Length > 0)
        {
            Session["frt_1"] = Convert.ToDateTime(weeks[0, 0].ToString());
            Session["frt_2"] = Convert.ToDateTime(weeks[0, 1].ToString());
            Session["frt_3"] = Convert.ToDateTime(weeks[1, 0].ToString());
            Session["frt_4"] = Convert.ToDateTime(weeks[1, 1].ToString());
        }

    }
}
