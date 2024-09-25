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

public partial class Admin_Staff_AllClientAlljobFortnight_Report : System.Web.UI.Page
{
    DBAccess db = new DBAccess();
    public string[,] weeks = new string[2, 2];
    private decimal _W1_chargeTot;
    private decimal _W1_HrsTot;
    private decimal _W1_OpeTot;

    private decimal _W2_chargeTot;
    private decimal _W2_HrsTot;
    private decimal _W2_OpeTot;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           if(Request.QueryString["comp"] !=null)
           {
               calculateWeek();
               GetAllClients();
               lbldatenow.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
           }
        }

    }
    public void calculateWeek()
    {
        DateTime date = Convert.ToDateTime(Request.QueryString["dt"].ToString());

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
                weeks[i-1, 1] = result.ToString();
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
    public void GetAllClients()
    {
        int comp = int.Parse(Request.QueryString["comp"].ToString());
        string StrSQL = "select CompId,CompanyName,Phone,Email,Website,(Address1 +','+ Address2 +','+ Address3) as Addr from Company_Master where CompId=" + comp;
        DataTable dtUserInfo = db.GetDataTable(StrSQL);
        Label1.Text = dtUserInfo.Rows[0]["CompanyName"].ToString();
        lbladdress.Text = dtUserInfo.Rows[0]["Addr"].ToString();
        lblcontno.Text = dtUserInfo.Rows[0]["Phone"].ToString();
        lblemail.Text = dtUserInfo.Rows[0]["Email"].ToString();
        lblwebsite.Text = dtUserInfo.Rows[0]["Website"].ToString();
        string StrSQL2 = "select StaffCode,StaffName from Staff_Master where StaffCode=" + Request.QueryString["staff"].ToString();
        //string StrSQL1 = "select * from dbo.Client_Master where CompId='" + Request.QueryString["comp"].ToString() + "'";      
        DataTable dtUserInfo2 = db.GetDataTable(StrSQL2);
        if (dtUserInfo2.Rows.Count > 0)
        {
            Label4.Text = dtUserInfo2.Rows[0]["StaffName"].ToString();
        }
       // string StrSQL1 = "select distinct c.CLTId,c.ClientName,t.CompId from Client_Master as c  inner join TimeSheet_Table as t on t.CLTId=c.CLTId where t.StaffCode=" + Request.QueryString["staff"].ToString();
        //string StrSQL1 = "select * from dbo.Client_Master where CompId='" + Request.QueryString["comp"].ToString() + "'";      
        DataTable dtUserInfo1 = Session["dt_clnt"] as DataTable;
        if (dtUserInfo1.Rows.Count > 0 )
        {
            DataClientList.DataSource = dtUserInfo1;
            DataClientList.DataBind();
        }
        foreach (DataListItem gvr in DataClientList.Items)
        {
            Label lbl = (Label)gvr.FindControl("lblcltid");
            HtmlGenericControl nodatadiv = (HtmlGenericControl)gvr.FindControl("nodatadiv");
            GridView GridWeek1 = (GridView)gvr.FindControl("GridWeek1");
            GridView GridWeek2 = (GridView)gvr.FindControl("GridWeek2");
            Label lblcomp = (Label)gvr.FindControl("lblcmpid");
            string str = "select sum(TotalTime)as TotalTime, sum(Charges)as Charges, sum(OpeAmt)as OpeAmt from(select  t.ClTId,t.StaffCode,isnull(sum(convert(float,t.TotalTime)),0) as TotalTime,"
                        +" (select HourlyCharges from dbo.Staff_Master where StaffCode=t.StaffCode)*isnull(sum(convert(float,t.TotalTime)),0)as Charges,"
                        + " isnull(sum(t.OpeAmt),0) as OpeAmt from dbo.Job_Master as j left join dbo.TimeSheet_Table as t on t.JobId=j.JobId  and j.CompId='" + lblcomp.Text + "'  where  j.ClTId='" + lbl.Text + "'"
                        + " and  t.Date >='" + Session["frt_1"].ToString() + "' and t.Date <='" + Session["frt_2"].ToString() + "' group by t.StaffCode,t.ClTId)as tot group by  tot.ClTId";
            DataTable dt = db.GetDataTable(str);
            GridWeek1.DataSource = dt;
            GridWeek1.DataBind();
            string str1 = "select sum(TotalTime)as TotalTime, sum(Charges)as Charges, sum(OpeAmt)as OpeAmt from(select  t.ClTId,t.StaffCode,isnull(sum(convert(float,t.TotalTime)),0) as TotalTime,"
                      + " (select HourlyCharges from dbo.Staff_Master where StaffCode=t.StaffCode)*isnull(sum(convert(float,t.TotalTime)),0)as Charges,"
                      + " isnull(sum(t.OpeAmt),0) as OpeAmt from dbo.Job_Master as j left join dbo.TimeSheet_Table as t on t.JobId=j.JobId  and j.CompId='" + lblcomp.Text + "'  where  j.ClTId='" + lbl.Text + "'"
                      + " and  t.Date >='" + Session["frt_3"].ToString() + "' and t.Date <='" + Session["frt_4"].ToString() + "' group by t.StaffCode,t.ClTId)as tot group by  tot.ClTId";
            DataTable dt1 = db.GetDataTable(str1);
            GridWeek2.DataSource = dt1;
            GridWeek2.DataBind();
            if (dt.Rows.Count == 0 && dt1.Rows.Count == 0)
            {
                nodatadiv.Style.Value = "display:none";
            }
            else
            {
                nodatadiv.Style.Value = "display:block";
            }
        }
        lblfort_1.Text = Convert.ToDateTime(Session["frt_1"]).ToString("dd MMM") + " - " + Convert.ToDateTime(Session["frt_2"]).ToString("dd MMM");
        lblfort_2.Text = Convert.ToDateTime(Session["frt_3"]).ToString("dd MMM") + " - " + Convert.ToDateTime(Session["frt_4"]).ToString("dd MMM");
    }

    /*Week 2*/

    public decimal GetW2Charges(decimal W2_charge)
    {
        _W2_chargeTot += W2_charge;
        return W2_charge;

    }

    public decimal RetW2ChargesTotal()
    {
        return _W2_chargeTot;
    }
    public decimal GetW2Hrs(decimal W2_hrs)
    {
        _W2_HrsTot += W2_hrs;
        return W2_hrs;

    }

    public decimal RetW2HrsTotal()
    {
        return _W2_HrsTot;
    }
    public decimal GetW2Ope(decimal W2_ope)
    {
        _W2_OpeTot += W2_ope;
        return W2_ope;

    }

    public decimal RetW2OpeTotal()
    {
        return _W2_OpeTot;
    }


    /*Week 1*/

    public decimal GetW1Charges(decimal W1_charge)
    {
        _W1_chargeTot += W1_charge;
        return W1_charge;

    }

    public decimal RetW1ChargesTotal()
    {
        return _W1_chargeTot;
    }
    public decimal GetW1Hrs(decimal W1_hrs)
    {
        _W1_HrsTot += W1_hrs;
        return W1_hrs;

    }

    public decimal RetW1HrsTotal()
    {
        return _W1_HrsTot;
    }
    public decimal GetW1Ope(decimal W1_ope)
    {
        _W1_OpeTot += W1_ope;
        return W1_ope;

    }

    public decimal RetW1OpeTotal()
    {
        return _W1_OpeTot;
    }
}
