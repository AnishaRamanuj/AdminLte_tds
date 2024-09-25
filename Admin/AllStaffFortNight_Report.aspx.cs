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

public partial class Admin_AllStaffFortNight_Report : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    public string[,] weeks = new string[6, 2];

    private decimal _W1_chargeTot;
    private decimal _W1_HrsTot;
    private decimal _W1_OpeTot;

    private decimal _W2_chargeTot;
    private decimal _W2_HrsTot;
    private decimal _W2_OpeTot;

    private decimal _M_chargeTot;
    private decimal _M_HrsTot;
    private decimal _M_OpeTot;
    private decimal _OpeChgTot;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["admin"] != null)
        {
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(Request.QueryString["dt"]))
                {
                    if (Request.QueryString["jb"] != null)
                    {
                        calculateWeek();
                        string qryW1 = "select s.StaffName,s.StaffCode,s.HourlyCharges as Charges,isnull(sum(convert(float,TotalTime)),0)as TotalTime,(isnull(sum(convert(float,TotalTime)),0)* s.HourlyCharges)as HourlyCharges,isnull(sum(OpeAmt),0)as OpeAmt"

                                        + " from   dbo.Staff_Master as s right join dbo.Job_Staff_Table as j on s.StaffCode=j.StaffCode "

                                        + " left join  dbo.TimeSheet_Table as t on  t.JobId=j.JobId and t.StaffCode=j.StaffCode "

                                        + " where  j.JobId='" + Convert.ToInt32(Request.QueryString["jb"].ToString()) + "' group by s.StaffName,s.HourlyCharges,s.StaffCode";
                        
                        DataTable dt = db.GetDataTable(qryW1);
                        staff.DataSource = dt;
                        staff.DataBind();

                        //foreach (GridViewRow gvr in staff.Rows)
                        //{
                        //    Label lbl = (Label)gvr.FindControl("Label2");
                        //    ViewState["staffid"] = lbl.Text;
                        GetWeek1();
                        GetWeek2();
                        GetMonthTotal();
                        GetweekHeader();
                        //}
                        lbldatenow.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
                        
                    }
                   
                    //GetWeek3();
                    //GetWeek4();
                    //GetWeek5();
                    
                    //GetweekHeader();
                }
            }
        }
    }
    public void GetweekHeader()
    {
        if (weeks.Length > 0)
        {
            if (!string.IsNullOrEmpty(weeks[0, 0]) && !string.IsNullOrEmpty(weeks[0, 1]))
            {
                lblWeek1.Text = Convert.ToDateTime(weeks[0, 0]).ToString("dd MMM") + " - " + Convert.ToDateTime(weeks[0, 1]).ToString("dd MMM");
                lblmonth.Text = "for " + Convert.ToDateTime(weeks[0, 0]).ToString("MMM yy");
            }
            if (!string.IsNullOrEmpty(weeks[1, 0]) && !string.IsNullOrEmpty(weeks[1, 1]))
                lblWeek2.Text = Convert.ToDateTime(weeks[1, 0]).ToString("dd MMM") + " - " + Convert.ToDateTime(weeks[1, 1]).ToString("dd MMM");

        }
        int comp = int.Parse(Request.QueryString["comp"].ToString());
        string StrSQL = "select CompId,CompanyName,Phone,Email,Website,(Address1 +','+ Address2 +','+ Address3) as Addr from Company_Master where CompId=" + comp;
        DataTable dtUserInfo = db.GetDataTable(StrSQL);
        Label63.Text = dtUserInfo.Rows[0]["CompanyName"].ToString();
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
            i++;

        }

    }
    public void GetWeek1()
    {
        if (!string.IsNullOrEmpty(weeks[0, 0]) && !string.IsNullOrEmpty(weeks[0, 1]))
        {

            string qryW1 = "select s.StaffName,isnull(s.HourlyCharges,0) as Charges,isnull(sum(convert(float,TotalTime)),0)as TotalTime,isnull((isnull(sum(convert(float,TotalTime)),0)* s.HourlyCharges),0) as HourlyCharges,isnull(sum(OpeAmt),0)as OpeAmt"

                            + " from   dbo.Staff_Master as s right join dbo.Job_Staff_Table as j on s.StaffCode=j.StaffCode "

                            + " left join  dbo.TimeSheet_Table as t on  t.JobId=j.JobId and t.StaffCode=j.StaffCode  and  t.Date>='" + Convert.ToDateTime(weeks[0, 0].ToString()) + "' "

                            + " and t.Date <='" + Convert.ToDateTime(weeks[0, 1].ToString()) + "' where  j.JobId='" + Convert.ToInt32(Request.QueryString["jb"].ToString()) + "' group by s.StaffName,s.HourlyCharges";
            DataTable dt_W1 = db.GetDataTable(qryW1);
            GridWeek1.DataSource = dt_W1;
            GridWeek1.DataBind();
        }
    }
    public void GetWeek2()
    {
        if (!string.IsNullOrEmpty(weeks[1, 0]) && !string.IsNullOrEmpty(weeks[1, 1]))
        {

            string qryW2 = "select s.StaffName,isnull(s.HourlyCharges,0) as Charges,isnull(sum(convert(float,TotalTime)),0)as TotalTime,isnull((isnull(sum(convert(float,TotalTime)),0)* s.HourlyCharges),0) as HourlyCharges,isnull(sum(OpeAmt),0)as OpeAmt"

                            + " from   dbo.Staff_Master as s right join dbo.Job_Staff_Table as j on s.StaffCode=j.StaffCode "

                            + " left join  dbo.TimeSheet_Table as t on  t.JobId=j.JobId and t.StaffCode=j.StaffCode  and  t.Date>='" + Convert.ToDateTime(weeks[1, 0].ToString()) + "' "

                            + " and t.Date <='" + Convert.ToDateTime(weeks[1, 1].ToString()) + "' where  j.JobId='" + Convert.ToInt32(Request.QueryString["jb"].ToString()) + "' group by s.StaffName,s.HourlyCharges";
            
            DataTable dt_W2 = db.GetDataTable(qryW2);
            GridWeek2.DataSource = dt_W2;
            GridWeek2.DataBind();
        }
    }
    public void GetMonthTotal()
    {
        if (!string.IsNullOrEmpty(Request.QueryString["dt"]))
        {
            DateTime Startdate = Convert.ToDateTime(Request.QueryString["dt"].ToString());
            DateTime endDate = Startdate.AddMonths(1).AddDays(-1);
            string qryM = "select s.StaffName,isnull(s.HourlyCharges,0) as Charges,isnull(sum(convert(float,TotalTime)),0)as TotalTime,isnull((isnull(sum(convert(float,TotalTime)),0)* s.HourlyCharges),0) as HourlyCharges,isnull(sum(OpeAmt),0)as OpeAmt,"

                            + " isnull((isnull(sum(convert(float,TotalTime)),0)* s.HourlyCharges)+(isnull(sum(OpeAmt),0)),0) as Ope_Chg "

                            + " from   dbo.Staff_Master as s right join dbo.Job_Staff_Table as j on s.StaffCode=j.StaffCode "

                            + " left join  dbo.TimeSheet_Table as t on  t.JobId=j.JobId and t.StaffCode=j.StaffCode  and  t.Date>='" + Startdate + "' "

                            + " and t.Date <='" + endDate + "' where  j.JobId='" + Convert.ToInt32(Request.QueryString["jb"].ToString()) + "' group by s.StaffName,s.HourlyCharges";
            DataTable dt_M = db.GetDataTable(qryM);
            GridMonth.DataSource = dt_M;
            GridMonth.DataBind();
        }

    }
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
    public decimal GetMCharges(decimal M_charge)
    {
        _M_chargeTot += M_charge;
        return M_charge;

    }
    public decimal RetMChargesTotal()
    {
        return _M_chargeTot;
    }
    public decimal GetMHrs(decimal M_hrs)
    {
        _M_HrsTot += M_hrs;
        return M_hrs;

    }
    public decimal RetMHrsTotal()
    {
        return _M_HrsTot;
    }
    public decimal GetMOpe(decimal M_ope)
    {
        _M_OpeTot += M_ope;
        return M_ope;

    }
    public decimal RetMOpeTotal()
    {
        return _M_OpeTot;
    }
    public decimal GetMOpeChg(decimal OpeChg)
    {
        _OpeChgTot += OpeChg;
        return OpeChg;

    }
    public decimal RetMOpeChgTotal()
    {
        return _OpeChgTot;
    }
}
