using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;

public partial class Admin_AllJobs_FortNight_Report : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();

    private decimal _W1_chargeTot;
    private decimal _W1_HrsTot;
    private decimal _W1_OpeTot;

    private decimal _W2_chargeTot;
    private decimal _W2_HrsTot;
    private decimal _W2_OpeTot;

    protected void Page_Load(object sender, EventArgs e)
    {
        if(Session["admin"]!=null)
        {
            GetAllClients();
        }
        else
        {
            Response.Redirect("Default.aspx");
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
        lbldatenow.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;

        if (Session["dt_jb_frt"] != null)
        {
            DataTable dt_jb_frt = Session["dt_jb_frt"] as DataTable;
            DataClientList.DataSource = dt_jb_frt;
            DataClientList.DataBind();
        }

        lblfort_1.Text= Convert.ToDateTime( Session["frt_1"]).ToString("dd MMM") + " - " + Convert.ToDateTime( Session["frt_2"]).ToString("dd MMM");
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
