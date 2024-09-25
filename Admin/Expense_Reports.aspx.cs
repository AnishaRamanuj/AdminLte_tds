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

public partial class Admin_Expense_Reports : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    private readonly JobMaster job = new JobMaster();
    JobStaffTable jobstaff = new JobStaffTable();
    StaffMaster staff = new StaffMaster();
    CompanyMaster comp = new CompanyMaster();
    ClientMaster client = new ClientMaster();
    decimal timee = 0;
    decimal chargee = 0;
    decimal opee = 0;
    decimal chopee = 0;
    decimal timee1 = 0;
    decimal chargee1 = 0;
    decimal opee1 = 0;
    decimal chopee1 = 0;
    DataTable dtstaff = new DataTable();
    DataTable dtjob = new DataTable();
    DataTable dtclient = new DataTable();
    private decimal _totalrepurchaseamountTotal;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindtype();
            //lblprintedby.Text = "superadmin";
           

        }
    }
    public void bindtype()
    {
        if (Request.QueryString["pagename"] != null && Request.QueryString["comp"] != null)
        {
            if (Request.QueryString["pagename"].ToString() == "AllClients")
            {
                dtclient = Session["dtclient"] as DataTable;
                bind3();
                JobView.ActiveViewIndex = 2;
                Label46.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            }
            else if (Request.QueryString["pagename"].ToString() == "SingleClient")
            {
                dtclient = Session["dtclient"] as DataTable;
                Label11.Text = "Single Client -> All Expenses";
                bind3();
                JobView.ActiveViewIndex = 2;
                Label46.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            }
            else if (Request.QueryString["pagename"].ToString() == "AllStaffs")
            {
                dtstaff = Session["dtstaff"] as DataTable;
                bind4();
                JobView.ActiveViewIndex = 3;
                Label59.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            }
            else if (Request.QueryString["pagename"].ToString() == "SingleStaff")
            {
                Label11.Text = "Single Staff -> All Expenses";
                dtstaff = Session["dtstaff"] as DataTable;
                bind4();
                JobView.ActiveViewIndex = 3;
                Label59.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            }
            else if (Request.QueryString["pagename"].ToString() == "AlljobAllClientsAllStaff")
            {
                dtjob = Session["dtjob"] as DataTable;
                dtstaff = Session["dtstaff"] as DataTable;
                dtclient = Session["dtclient"] as DataTable;
                bind2();
                JobView.ActiveViewIndex = 1;
                Label86.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            }
            else if (Request.QueryString["pagename"].ToString() == "SinglejobAllClientsSingleStaff")
            {
                dtjob = Session["dtjob"] as DataTable;
                dtstaff = Session["dtstaff"] as DataTable;
                dtclient = Session["dtclient"] as DataTable;
                bind1();
                Label20.Text = "Single Job->AllClients->SingleStaff->AllExpenses";
                JobView.ActiveViewIndex = 0;
                Label36.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            }
        }
        //else if (Session["dtjob"] != null && Session["dtstaff"] != null && Session["dtclient"] != null)
        //{
        //    dtjob = Session["dtjob"] as DataTable;
        //    dtstaff = Session["dtstaff"] as DataTable;
        //    dtclient = Session["dtclient"] as DataTable;
        //    if (Request.QueryString["comp"] != null && dtjob.Rows.Count > 1 && dtstaff.Rows.Count > 1 && dtclient.Rows.Count >1)
        //    {
        //        bind2();
        //        JobView.ActiveViewIndex = 1;
        //        Label86.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
        //    }
        //    else if (Request.QueryString["comp"] != null && dtjob.Rows.Count == 1 && dtstaff.Rows.Count == 1)
        //    {
        //        bind1();
        //        Label20.Text = "Single Job->AllClients->SingleStaff->AllExpenses";
        //        JobView.ActiveViewIndex = 0;
        //        Label36.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
        //    }          

            
        //}
        else if (Request.QueryString["comp"] != null && Session["dtstaff"] != null && Session["dtjob"] != null)
        {
            dtjob = Session["dtjob"] as DataTable;
            dtstaff = Session["dtstaff"] as DataTable;
            if (Request.QueryString["comp"] != null && dtjob.Rows.Count ==1 && dtstaff.Rows.Count==1)
            {
                bind1();
                Label20.Text = "Single Job->AllClients->SingleStaff->AllExpenses";
                JobView.ActiveViewIndex = 0;
                Label36.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            }
            else if (Request.QueryString["comp"] != null && dtjob.Rows.Count > 1 && dtstaff.Rows.Count > 1)
            {
                bind1();
                Label20.Text = "All Jobs->AllClients->AllStaffs->AllExpenses";
                JobView.ActiveViewIndex = 0;
                Label36.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            }   
        }       
    }
    public void bind4()
    {
        int comp = int.Parse(Request.QueryString["comp"].ToString());
        string StrSQL = "select CompId,CompanyName,Phone,Email,Website,(Address1 +','+ Address2 +','+ Address3) as Addr from Company_Master where CompId=" + comp;
        DataTable dtUserInfo = db.GetDataTable(StrSQL);
        Label29.Text = dtUserInfo.Rows[0]["CompanyName"].ToString();
        //Label37.Text = dtUserInfo.Rows[0]["Addr"].ToString();
        //Label39.Text = dtUserInfo.Rows[0]["Phone"].ToString();
        //Label47.Text = dtUserInfo.Rows[0]["Email"].ToString();
        //Label48.Text = dtUserInfo.Rows[0]["Website"].ToString();

        //int clnt = int.Parse(Request.QueryString["clnt"].ToString());
        //int stfid = int.Parse(dtstaff.Rows[0]["StaffCode"].ToString());
        //string StrSQL1 = "select ClientName from Client_Master where CLTId=" + clnt;
        //string StrSQL2 = "select StaffName from Staff_Master where StaffCode=" + stfid;
        //DataTable dtUserInfo1 = db.GetDataTable(StrSQL1);
        //DataTable dtUserInfo2 = db.GetDataTable(StrSQL2);
        string start = Session["startdate"].ToString();
        string end = Session["enddate"].ToString();

        Label54.Text = start + " to " + end;

        //Label22.Text = dtUserInfo1.Rows[0]["ClientName"].ToString();
        //Label26.Text = dtUserInfo2.Rows[0]["StaffName"].ToString();


        Label59.Text = DateTime.Now.ToShortDateString();
        CultureInfo info = new CultureInfo("en-US", false);
        DateTime Fdob = new DateTime(1900, 1, 1);
        DateTime dob = new DateTime(1900, 1, 1);
        String _dateFormat = "dd/MM/yyyy";
        if (Session["startdate"].ToString().Trim() != "" && !DateTime.TryParseExact(Session["startdate"].ToString().Trim(), _dateFormat, info,
                                                                                             DateTimeStyles.AllowWhiteSpaces, out Fdob))
        {
        }
        if (Session["enddate"].ToString().Trim() != "" && !DateTime.TryParseExact(Session["enddate"].ToString().Trim(), _dateFormat, info,
                                                                                              DateTimeStyles.AllowWhiteSpaces, out dob))
        {
        }
        Datalist5.DataSource = dtstaff;
        Datalist5.DataBind();
        foreach (DataListItem item in Datalist5.Items)
        {
            Label lblid = (Label)item.FindControl("lbljobid");
            HtmlGenericControl nodatadiv = (HtmlGenericControl)item.FindControl("nodatadiv");

            string str = "select t.TSId,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.OpeAmt as ope,ope.OPEName " +
                            " from dbo.TimeSheet_Table as t " +
                            " left join dbo.OPE_Master as ope on ope.OpeId=t.OpeId" +
                            " where t.Status='Approved' and t.StaffCode='" + lblid.Text + "' and t.CompId='" + Request.QueryString["comp"].ToString() + "' and t.Date between '" + Fdob + "' and '" + dob + "'";
            DataTable dt = db.GetDataTable(str);
            GridView grdview = (GridView)item.FindControl("grdview4");
            if (dt.Rows.Count != 0)
            {
                grdview.DataSource = dt;
                grdview.DataBind();
                nodatadiv.Style.Value = "display:block";
            }
            else
            {
                nodatadiv.Style.Value = "display:none";
            }
        }

    }
    public void bind3()
    {
        int comp = int.Parse(Request.QueryString["comp"].ToString());
        string StrSQL = "select CompId,CompanyName,Phone,Email,Website,(Address1 +','+ Address2 +','+ Address3) as Addr from Company_Master where CompId=" + comp;
        DataTable dtUserInfo = db.GetDataTable(StrSQL);
        Label1.Text = dtUserInfo.Rows[0]["CompanyName"].ToString();
        Label5.Text = dtUserInfo.Rows[0]["Addr"].ToString();
        Label7.Text = dtUserInfo.Rows[0]["Phone"].ToString();
        Label8.Text = dtUserInfo.Rows[0]["Email"].ToString();
        Label9.Text = dtUserInfo.Rows[0]["Website"].ToString();

        //int clnt = int.Parse(Request.QueryString["clnt"].ToString());
        //int stfid = int.Parse(dtstaff.Rows[0]["StaffCode"].ToString());
        //string StrSQL1 = "select ClientName from Client_Master where CLTId=" + clnt;
        //string StrSQL2 = "select StaffName from Staff_Master where StaffCode=" + stfid;
        //DataTable dtUserInfo1 = db.GetDataTable(StrSQL1);
        //DataTable dtUserInfo2 = db.GetDataTable(StrSQL2);
        string start = Session["startdate"].ToString();
        string end = Session["enddate"].ToString();

        Label41.Text = start + " to " + end;

        //Label22.Text = dtUserInfo1.Rows[0]["ClientName"].ToString();
        //Label26.Text = dtUserInfo2.Rows[0]["StaffName"].ToString();


        Label46.Text = DateTime.Now.ToShortDateString();
        CultureInfo info = new CultureInfo("en-US", false);
        DateTime Fdob = new DateTime(1900, 1, 1);
        DateTime dob = new DateTime(1900, 1, 1);
        String _dateFormat = "dd/MM/yyyy";
        if (Session["startdate"].ToString().Trim() != "" && !DateTime.TryParseExact(Session["startdate"].ToString().Trim(), _dateFormat, info,
                                                                                             DateTimeStyles.AllowWhiteSpaces, out Fdob))
        {
        }
        if (Session["enddate"].ToString().Trim() != "" && !DateTime.TryParseExact(Session["enddate"].ToString().Trim(), _dateFormat, info,
                                                                                              DateTimeStyles.AllowWhiteSpaces, out dob))
        {
        }
        Datalist2.DataSource = dtclient;
        Datalist2.DataBind();
        foreach (DataListItem item in Datalist2.Items)
        {
            Label lblid = (Label)item.FindControl("lbljobid");
            HtmlGenericControl nodatadiv = (HtmlGenericControl)item.FindControl("nodatadiv");

            string str = "select t.TSId,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.OpeAmt as ope,ope.OPEName " +
                            " from dbo.TimeSheet_Table as t " +
                            " left join dbo.OPE_Master as ope on ope.OpeId=t.OpeId" +
                            " where t.Status='Approved' and t.CLTId='" + lblid.Text + "' and t.CompId='" + Request.QueryString["comp"].ToString() + "' and t.Date between '" + Fdob + "' and '" + dob + "'";
            DataTable dt = db.GetDataTable(str);
            GridView grdview = (GridView)item.FindControl("grdview3");
            if (dt.Rows.Count != 0)
            {
                grdview.DataSource = dt;
                grdview.DataBind();
                nodatadiv.Style.Value = "display:block";
            }
            else
            {
                nodatadiv.Style.Value = "display:none";
            }
        }

    }
    public void bind1()
    {
        int comp = int.Parse(Request.QueryString["comp"].ToString());
        string StrSQL = "select CompId,CompanyName,Phone,Email,Website,(Address1 +','+ Address2 +','+ Address3) as Addr from Company_Master where CompId=" + comp;
        DataTable dtUserInfo = db.GetDataTable(StrSQL);
        Label3.Text = dtUserInfo.Rows[0]["CompanyName"].ToString();
        Label15.Text = dtUserInfo.Rows[0]["Addr"].ToString();
        Label16.Text = dtUserInfo.Rows[0]["Phone"].ToString();
        Label17.Text = dtUserInfo.Rows[0]["Email"].ToString();
        Label18.Text = dtUserInfo.Rows[0]["Website"].ToString();

        //int clnt = int.Parse(Request.QueryString["clnt"].ToString());
        int stfid = int.Parse(dtstaff.Rows[0]["StaffCode"].ToString());
        //string StrSQL1 = "select ClientName from Client_Master where CLTId=" + clnt;
        //string StrSQL2 = "select StaffName from Staff_Master where StaffCode=" + stfid;
        //DataTable dtUserInfo1 = db.GetDataTable(StrSQL1);
        //DataTable dtUserInfo2 = db.GetDataTable(StrSQL2);
        string start = Session["startdate"].ToString();
        string end = Session["enddate"].ToString();

        Label28.Text = start + " to " + end;

        //Label22.Text = dtUserInfo1.Rows[0]["ClientName"].ToString();
        //Label26.Text = dtUserInfo2.Rows[0]["StaffName"].ToString();


        Label36.Text = DateTime.Now.ToShortDateString();
        CultureInfo info = new CultureInfo("en-US", false);
        DateTime Fdob = new DateTime(1900, 1, 1);
        DateTime dob = new DateTime(1900, 1, 1);
        String _dateFormat = "dd/MM/yyyy";
        if (Session["startdate"].ToString().Trim() != "" && !DateTime.TryParseExact(Session["startdate"].ToString().Trim(), _dateFormat, info,
                                                                                             DateTimeStyles.AllowWhiteSpaces, out Fdob))
        {
        }
        if (Session["enddate"].ToString().Trim() != "" && !DateTime.TryParseExact(Session["enddate"].ToString().Trim(), _dateFormat, info,
                                                                                              DateTimeStyles.AllowWhiteSpaces, out dob))
        {
        }
        Datalist1.DataSource = dtjob;
        Datalist1.DataBind();
        foreach (DataListItem item in Datalist1.Items)
        {
            Label lblid = (Label)item.FindControl("lbljobid");
            string str = "select t.TSId,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.OpeAmt as ope,ope.OPEName,s.StaffName,c.ClientName " +
                            " from dbo.TimeSheet_Table as t left join Staff_Master as s on s.StaffCode=t.StaffCode left join Client_Master as c on c.CLTId=t.CLTId " +
                            " left join dbo.OPE_Master as ope on ope.OpeId=t.OpeId" +
                            " where t.Status='Approved' and t.jobId='" + lblid.Text + "' and t.staffCode='" + stfid + "' and t.CompId='" + Request.QueryString["comp"].ToString() + "' and t.Date between '" + Fdob + "' and '" + dob + "'";

            DataTable dt = db.GetDataTable(str);
            GridView grdview = (GridView)item.FindControl("grdview");
            if (dt.Rows.Count != 0)
            {
                grdview.DataSource = dt;
                grdview.DataBind();
            }
        }

    }
    public void bind2()
    {
        int comp = int.Parse(Request.QueryString["comp"].ToString());
        string StrSQL = "select CompId,CompanyName,Phone,Email,Website,(Address1 +','+ Address2 +','+ Address3) as Addr from Company_Master where CompId=" + comp;
        DataTable dtUserInfo = db.GetDataTable(StrSQL);
        Label63.Text = dtUserInfo.Rows[0]["CompanyName"].ToString();
        Label65.Text = dtUserInfo.Rows[0]["Addr"].ToString();
        Label66.Text = dtUserInfo.Rows[0]["Phone"].ToString();
        Label67.Text = dtUserInfo.Rows[0]["Email"].ToString();
        Label68.Text = dtUserInfo.Rows[0]["Website"].ToString();
        string start = Session["startdate"].ToString();
        string end = Session["enddate"].ToString();

        Label78.Text = start + " to " + end;
        Label86.Text = DateTime.Now.ToShortDateString();
        //int clnt = int.Parse(Request.QueryString["clnt"].ToString());

        //int stfid = int.Parse(dtjob.Rows[0]["JobId"].ToString());
        //string StrSQL1 = "select ClientName from Client_Master where CLTId=" + clnt;
        //string StrSQL2 = "select JobName from Job_Master where JobId=" + stfid;
       // DataTable dtUserInfo1 = db.GetDataTable(StrSQL1);
        //DataTable dtUserInfo2 = db.GetDataTable(StrSQL2);
        //Label72.Text = dtUserInfo1.Rows[0]["ClientName"].ToString();
        //Label49.Text = dtUserInfo2.Rows[0]["JobName"].ToString();


        Label86.Text = DateTime.Now.ToShortDateString();
        CultureInfo info = new CultureInfo("en-US", false);
        DateTime Fdob = new DateTime(1900, 1, 1);
        DateTime dob = new DateTime(1900, 1, 1);
        String _dateFormat = "dd/MM/yyyy";
        if (Session["startdate"].ToString().Trim() != "" && !DateTime.TryParseExact(Session["startdate"].ToString().Trim(), _dateFormat, info,
                                                                                              DateTimeStyles.AllowWhiteSpaces, out Fdob))
        {
        }
        if (Session["enddate"].ToString().Trim() != "" && !DateTime.TryParseExact(Session["enddate"].ToString().Trim(), _dateFormat, info,
                                                                                              DateTimeStyles.AllowWhiteSpaces, out dob))
        {
        }
        Datalist3.DataSource = dtjob;
        Datalist3.DataBind();
        foreach (DataListItem item in Datalist3.Items)
        {
            Label lblid = (Label)item.FindControl("lbljobid");
            string str = "select distinct t.StaffCode,s.StaffName " +
                            " from dbo.TimeSheet_Table as t left join Staff_Master as s on s.StaffCode=t.StaffCode" +
                            " where t.JobId='" + lblid.Text + "'";

            DataTable dt = db.GetDataTable(str);
            DataList innerlist = (DataList)item.FindControl("Datalist4");
            innerlist.DataSource = dt;
            innerlist.DataBind();
            if (dt.Rows.Count != 0)
            {
                foreach (DataListItem item1 in innerlist.Items)
                {
                    Label lblstf = (Label)item1.FindControl("lblstaffcode");
                    string str1 = "select t.TSId,CONVERT(VARCHAR(10), t.Date, 103) AS Date,t.OpeAmt as ope,ope.OPEName,c.ClientName " +
                                    " from dbo.TimeSheet_Table as t left join Staff_Master as s on s.StaffCode=t.StaffCode left join Client_Master as c on c.CLTId=t.CLTId" +
                                    " left join dbo.OPE_Master as ope on ope.OpeId=t.OpeId" +
                                    " where t.Status='Approved' and t.StaffCode='" + lblstf.Text + "' and t.JobId='" + lblid.Text + "' and t.CompId='" + Request.QueryString["comp"].ToString() + "' and t.Date between '" + Fdob + "' and '" + dob + "'";

                    DataTable dt1 = db.GetDataTable(str1);
                    GridView grdview1 = (GridView)item1.FindControl("grdview2");
                    if (dt1.Rows.Count != 0)
                    {
                        grdview1.DataSource = dt1;
                        grdview1.DataBind();
                    }
                }
            }
            else
            {
                foreach (DataListItem item1 in innerlist.Items)
                {
                    Label lblstf = (Label)item1.FindControl("lblstaffname");
                    lblstf.Text = "No Records Found";
                }

            }
        }

    }
    protected void grdview_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {          
            Label ope = (Label)e.Row.FindControl("lblope");
            decimal totope = decimal.Parse(ope.Text);
            opee += totope;
        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            Label ope1 = (Label)e.Row.FindControl("Label31");        
            ope1.Text = opee.ToString();           
            opee1 += opee;          
            opee = 0;
            Label30.Text = opee1.ToString();
        }
    }
    protected void grdview2_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Label ope = (Label)e.Row.FindControl("lblope");
            decimal totope = decimal.Parse(ope.Text);
            opee += totope;
        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            Label ope1 = (Label)e.Row.FindControl("Label31");
            ope1.Text = opee.ToString();         
            opee1 += opee;         
            opee = 0;
            chopee = 0;
            Label81.Text = opee1.ToString();
        }
    }
    protected void grdview3_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Label ope = (Label)e.Row.FindControl("lblope");
            decimal totope = decimal.Parse(ope.Text);
            opee += totope;
        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            Label ope1 = (Label)e.Row.FindControl("Label31");
            ope1.Text = opee.ToString();
            opee1 += opee;
            opee = 0;
            chopee = 0;
            Label42.Text = opee1.ToString();
        }
    }
    protected void grdview4_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Label ope = (Label)e.Row.FindControl("lblope");
            decimal totope = decimal.Parse(ope.Text);
            opee += totope;
        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            Label ope1 = (Label)e.Row.FindControl("Label31");
            ope1.Text = opee.ToString();
            opee1 += opee;
            opee = 0;
            chopee = 0;
            Label55.Text = opee1.ToString();
        }
    }
}
