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


public partial class controls_Manage_Holiday : System.Web.UI.UserControl
{
    int pageid = 89;
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    private readonly DBAccess db = new DBAccess();
    private readonly HolidayMaster Holi = new HolidayMaster();
    public string FYR ="";
    DataView chk_dv;
    DataTable chk_dt;
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
                Div1.Style.Value = "display:block";
                DataSet ds = BindYear();
                DataSet dsBr = BindBranch(ViewState["compid"].ToString()); 
                if (ds.Tables[0].Rows.Count > 0)
                {
                    string Fyear = ds.Tables[0].Rows[0][1].ToString(); 
                    FYR = Fyear;
                    Session["Fyear"] = FYR; 
                    bindHoliday(Fyear);
                }
                if (dsBr.Tables[0].Rows.Count > 0)
                {
                    drpBr.DataSource = dsBr.Tables[0];
                    drpBr.DataBind();
                }
                txtHolidaysearch.Focus();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        txtHoliday.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtHolidaysearch.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");


        string objL = objDAL_PagePermissions.Dal_getRolepermission(pageid, Convert.ToInt32(Session["UserRole"]), Convert.ToInt32(Session["companyid"]));

        hidpermission.Value = objL;



        bool a = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "add");
        if (a == false)
        { BtnHolidayAdd.Visible = false; }
        bool edit = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "edit");
        if (edit == false)
        {
            ((DataControlField)Griddealers.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Edit"))
                .SingleOrDefault()).Visible = false;
        }
        bool d = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "delete");
        if (d == false)
        {
            ((DataControlField)Griddealers.Columns
                .Cast<DataControlField>()
                .Where(fld => (fld.HeaderText == "Delete"))
                .SingleOrDefault()).Visible = false;
        }
    }



    public  DataSet BindYear()
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
       
        try
        {
           return  SqlHelper.ExecuteDataset(NEwsqlConn, CommandType.StoredProcedure, "Usp_BindYear");
        }
        catch (Exception ex)
        {
            throw ex;
        }
       
    }

    public DataSet BindBranch(string compid)
    {
        SqlConnection NEwsqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());

        try
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", compid);
            return SqlHelper.ExecuteDataset(NEwsqlConn, CommandType.StoredProcedure, "usp_Bind_BranchMaster",param);
        }
        catch (Exception ex)
        {
            throw ex;
        }

    }

    //public void displayblock(Boolean bln, Boolean bln1)
    //{

    //    Div1.Style.Value = "display:none";
    //}

    protected void btnHoliday_Click(object sender, EventArgs e)
    {
        try
        {
            if (ViewState["compid"] != null)
            {
                if (txtHoliday.Text != "")
                {
                    FYR = Session["Fyear"].ToString();  
                    string hid = hdnEdit.Value;
                    string str = "select HolidayName from dbo.Holiday_Master where HolidayName ='" + txtHoliday.Text.Trim() + "' and Branch_id='" + drpBr.SelectedValue + "' and CompId='" + ViewState["compid"].ToString() + "' and Fin_Year='" + FYR + "'";
                        DataTable dt = db.GetDataTable(str);
                        if (dt == null || dt.Rows.Count == 0)
                        {
                            Holi.CompId = int.Parse(ViewState["compid"].ToString());
                            Holi.HolidayName = txtHoliday.Text;
                            CultureInfo info = new CultureInfo("en-US", false);
                            DateTime Fdob = new DateTime(1900, 1, 1);
                            DateTime dob = new DateTime(1900, 1, 1);
                            String _dateFormat = "dd/MM/yyyy";

                            if (txtDate.Text.Trim() != "" && !DateTime.TryParseExact(txtDate.Text.Trim(), _dateFormat, info,
                                                                                                                  DateTimeStyles.AllowWhiteSpaces, out dob))
                            {
                            }
                            DateTime EDT = dob;

                            Holi.Brid = drpBr.SelectedValue;
                            Holi.HolidayDate = EDT;
                            Holi.FinYr = FYR;
                            int res = 0;
                            if (hid == "")
                            {
                                Holi.id = 0;
                                res = Holi.Insert();
                            }
                            else
                            {
                                Holi.HolidayId  = Convert.ToInt16(hid);
                                res = Holi.Update(); 
                            }


                            if (res == 1)
                            {
                                MessageControl2.SetMessage("Holiday updated Successfully", MessageDisplay.DisplayStyles.Success);
                                clearall();
                                ModalPopupExtender1.Hide();
                            }
                            else
                            {
                                MessageControl2.SetMessage("Error!!!Holiday not updated", MessageDisplay.DisplayStyles.Info);
                                clearall();
                                ModalPopupExtender1.Hide();
                            }
                        }
                        else
                        {
                            MessageControl2.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                            clearall();
                            ModalPopupExtender1.Hide();
                        }

                }
                else
                {
                    MessageControl2.SetMessage("Please Enter a Holiday.", MessageDisplay.DisplayStyles.Info);
                }
                bindHoliday(FYR);
                BtnHolidayAdd.Focus();

            }
            else
            {
                MessageControl2.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }

    //public void UpdateHoliday()
    //{
    //    int hid = Convert.ToInt16(hdnEdit.Value); 

    //    string StrSQL = "update Holiday_Master set HolidayName='" + Holi.HolidayName  + "', Holidaydate='" + Holi.HolidayDate  + "', Branch_id=" + Holi.Brid + "  where Holidayid=" + hid ;
    //    db.ExecuteCommand(StrSQL);

    //}

    //Holiday//
    public SqlDataSource Holiday
    {
        get { return SqlDataSource1; }
    }
    public void bindHoliday(string Fyear)
    {
        try
        {
            int Holidayid = 0;
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            Holiday.SelectCommand = "select HolidayId, h.CompId, HolidayName, Convert(varchar(10),HolidayDate,103) as HolidayDate , branchname,b.brid  from Holiday_Master h left join branch_master b on h.Branch_id=b.brid where h.CompId='" + ViewState["compid"].ToString() + "' and h.Fin_year='" + Fyear + "' order by convert(datetime,HolidayDate,103) asc ";

            chk_dv = (DataView)Holiday.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl2.SetMessage("No Holiday Added", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    Holidayid = int.Parse(chk_dt.Rows[0]["Holidayid"].ToString());
                }
                //ModalPopupExtender1.Hide();
                //searchdesg.Style.Value = "display:block";
            }
            else
            {
                msghead.Style.Value = "display:block";
                //searchdesg.Style.Value = "display:none";

            }
            Griddealers.DataBind();
            Session["Holidayid"] = Holidayid;
     
        }
        catch (Exception ex)
        {

        }
    }


    protected void Griddealers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Griddealers.PageIndex = e.NewPageIndex;
        bindHoliday(FYR);
    }

    protected void Griddealers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "delete")
            {
                DBAccess.PrintDelete(Session["IP"].ToString(), "Holiday Master", Session["fulname"].ToString(), Session["usertype"].ToString(), hdnDT.Value);
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int compid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());

                FYR = Session["Fyear"].ToString();  
                string StrSQL = "delete from dbo.Holiday_Master where Holidayid=" + compid + " and fin_year='" + FYR + "'";
                
                int res = db.ExecuteCommand(StrSQL);
                Holiday.DeleteCommand = StrSQL;
                if (res == 1)
                {
                    MessageControl2.SetMessage("Holiday Deleted Successfully", MessageDisplay.DisplayStyles.Info);
                }
                else
                {
                    MessageControl2.SetMessage("Holiday Not Deleted", MessageDisplay.DisplayStyles.Error);
                }

                bindHoliday(FYR);

            }
            else if (e.CommandName == "edit")
            {
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int hid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
                string hn = (((Label)Griddealers.Rows[row.RowIndex].FindControl("lblDesg")).Text);
                string hd = ((Label)Griddealers.Rows[row.RowIndex].FindControl("lblDate")).Text;
                string br = (((HiddenField)Griddealers.Rows[row.RowIndex].FindControl("hdnBrid")).Value);
                txtHoliday.Text = hn;
                txtDate.Text = hd;
                drpBr.SelectedValue = br;
                hdnEdit.Value = hid.ToString() ;
                ModalPopupExtender1.Show();
            }

        }
        catch (Exception ex)
        {

        }
    }
 


    public void clearall()
    {
        txtHoliday.Text = string.Empty;
        txtDate.Text = string.Empty;
    }


    protected void Griddealers_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //if (e.Row.RowState == DataControlRowState.Edit)
        //{
        //    e.Row.FindControl("TextBox1").Focus();
        //}
    }

    protected void btnSHoliday_Click(object sender, EventArgs e)
    {
        string txtval = txtHolidaysearch.Text;
        Holiday.SelectCommand = "select HolidayId, h.CompId, HolidayName, Convert(varchar(10),HolidayDate,103) as HolidayDate , branchname,b.brid  from Holiday_Master h left join branch_master b on h.Branch_id=b.brid where h.CompId='" + ViewState["compid"].ToString() + "' and h.Fin_year='" + FYR + "' order by convert(datetime,HolidayDate,103) asc ";

    }


    protected void Griddealers_SelectedIndexChanged(object sender, EventArgs e)
    {

    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender1.Hide();

    }
    protected void BtnHolidayAdd_Click(object sender, EventArgs e)
    {
        txtHoliday.Text = "";
        txtDate.Text = "";
        txtHoliday.Focus();
        ModalPopupExtender1.Show();
    }
    protected void Btnclose_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender1.Hide();
    }



}
