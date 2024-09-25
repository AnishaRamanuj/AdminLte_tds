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

public partial class Admin_Staff_AllclientAllJobFortnight : System.Web.UI.Page
{
    public readonly DBAccess db = new DBAccess();
    public string[,] weeks = new string[2, 2];

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string dat =  DateTime.Now.Month + "/" + DateTime.Now.Year;
            txtenddate2.Text = dat; 
        }
        txtenddate2.Attributes.Add("onblur", "checkForm();");

    }
    protected void drpcompanylist_SelectedIndexChanged(object sender, EventArgs e)
    {
        drpstaff.Items.Clear();
        string ss = "select * from Staff_Master where CompId='" + drpcompanylist.SelectedValue + "' order by StaffName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            drpstaff.DataSource = dt;
            drpstaff.DataBind();
        }
    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Staff_AllclientAllJobFortnight.aspx";
            if (drpcompanylist.SelectedValue != "0" && drpstaff.SelectedValue != "0" && txtenddate2.Text != "")
            {
                calculateWeek();
                string StrSQL1 = "select distinct c.CLTId,c.ClientName,t.CompId from Client_Master as c  inner join TimeSheet_Table as t on t.CLTId=c.CLTId where t.StaffCode=" + drpstaff.SelectedValue;
                //string StrSQL1 = "select * from dbo.Client_Master where CompId='" + Request.QueryString["comp"].ToString() + "'";      
                DataTable dtUserInfo1 = db.GetDataTable(StrSQL1);
                string idstf = "";
                foreach (DataRow rw in dtUserInfo1.Rows)
                {
                    decimal widd = decimal.Parse(rw["CLTId"].ToString());
                    idstf += "'" + widd + "'" + ",";
                }
                if (idstf != "")
                {
                    idstf = idstf.Remove(idstf.Length - 1, 1);
                }
                string str = "select sum(TotalTime)as TotalTime, sum(Charges)as Charges, sum(OpeAmt)as OpeAmt,tot.ClientName,tot.ClTId from(select   ct.ClientName,t.ClTId,t.StaffCode,isnull(sum(convert(float,t.TotalTime)),0) as TotalTime,"
                    + " ( isnull(dbo.Hours_Charges(t.StaffCode,t.Date),0) )*isnull(sum(convert(float,t.TotalTime)),0)as Charges,"
                    + " isnull(sum(t.OpeAmt),0) as OpeAmt from dbo.Job_Master as j left join dbo.TimeSheet_Table as t on t.JobId=j.JobId  and j.CompId='" + drpcompanylist.SelectedValue + "' left join dbo.Client_Master as ct on ct.CLTId=t.ClTId where  j.ClTId in (" + idstf + ")"
                    + " and  t.Date>='" + Session["frt_1"].ToString() + "' and t.Date<='" + Session["frt_4"].ToString() + "' group by t.StaffCode,t.ClTId,ct.ClientName,t.Date)as tot group by  tot.ClTId,tot.ClientName";
                DataTable dtavail = db.GetDataTable(str);
                DataTable dt_jb_frt = new DataTable();
                int stf = 0;
                if (dtavail != null)
                {

                    foreach (DataRow rw in dtavail.Rows)
                    {
                        int Cid = int.Parse(rw["ClTId"].ToString());
                        string staff = rw["ClientName"].ToString();
                        stf = Cid;
                        if (dt_jb_frt == null || dt_jb_frt.Rows.Count == 0)
                        {
                            dt_jb_frt.Columns.Add("CLTId", System.Type.GetType("System.String"));
                            dt_jb_frt.Columns.Add("CompId", System.Type.GetType("System.String"));
                            dt_jb_frt.Columns.Add("ClientName", System.Type.GetType("System.String"));
                            DataRow dr = dt_jb_frt.NewRow();
                            dr["CLTId"] = Cid;
                            dr["CompId"] = drpcompanylist.SelectedValue;
                            dr["ClientName"] = staff;
                            dt_jb_frt.Rows.Add(dr);
                            dt_jb_frt.AcceptChanges();
                        }
                        else
                        {
                            DataRow dr = dt_jb_frt.NewRow();
                            dr["CLTId"] = Cid;
                            dr["CompId"] = drpcompanylist.SelectedValue;
                            dr["ClientName"] = staff;
                            dt_jb_frt.Rows.Add(dr);
                            dt_jb_frt.AcceptChanges();
                        }
                    }
                }

                Session["dt_clnt"] = dt_jb_frt;
                if (dt_jb_frt.Rows.Count > 0)
                {
                    Session["startdate"] = null;
                    Response.Redirect("../report1.aspx?comp=" + drpcompanylist.SelectedValue + "&staff=" + drpstaff.SelectedValue + "&dt=" + txtenddate2.Text + "&pagename=Staff_AllclientAllJobFortnight");
                    //Response.Redirect("Staff_AllClientAlljobFortnight_Report.aspx?comp=" + drpcompanylist.SelectedValue + "&staff=" + drpstaff.SelectedValue + "&dt=" + txtenddate2.Text);
                }
                else
                {
                    MessageControl1.SetMessage("No data found.", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
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
