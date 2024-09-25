using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using JTMSProject;
using System.Web.Security;
using System.Text;
using System.Net.Mail;
using System.Configuration;
using AjaxControlToolkit;
using System.Text.RegularExpressions;
using System.IO;
using System.Collections;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml;
using System.Web.Services;
using System.Management;
using System.Web.Caching;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using CommonLibrary;



public partial class controls_ManageClient : System.Web.UI.UserControl
{
    int pageid = 86;
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    private static string constr = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
    private readonly DBAccess db = new DBAccess();
    LabelAccess objlabelAccess = new LabelAccess();
    List<tbl_LabelAccess> LtblAccess;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                hdnCompanyid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["cltcomp"].ToString();
                //HtmlGenericControl lblstat = (HtmlGenericControl)this.Page.Master.FindControl("Totalsdiv");
                //lblstat.Style.Value = "display:block";
            }

            if (ViewState["compid"] != null)
            {
                bindgrid();
                txtsrchjob.Focus();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        txtsrchjob.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        //UpdatePanel1.Update();

        string objL = objDAL_PagePermissions.Dal_getRolepermission(pageid, Convert.ToInt32(Session["UserRole"]), Convert.ToInt32(Session["companyid"]));

        hidpermission.Value = objL;



        bool a = objDAL_PagePermissions.DAL_getpermission(hidpermission.Value, "add");
        if (a == false)
        { btnaddbranch.Visible = false; }
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

    public SqlDataSource userlist_data
    {
        get { return SqlDataSource1; }
    }
    public void bindgrid()
    {
        try
        {
            BtnPrevious.Visible = false; BtnNext.Visible = false;
            int j = 0;
            int i = 0;
            if (Session["first"] == null)
            {
                Session["first"] = 1;
                j = 1;
                i = 1;
            }
            else
            {
                i = int.Parse(Session["first"].ToString());
            }
            //i = Griddealers.PageIndex;
            if (i == 0)
            {
                i = 1;
                j = 1;
            }
            i = i * 25;
            j = i - 25;
            if (j == 0)
            {
                j = 1;
            }
        A10:
           string sql = "", sql2 = "";
            if (txtsrchjob.Text == "")
            {

                sql = "select * from (select row_number() over(order by  ClientName asc)as sino,CltID,ClientName, Address1, Address2,Address3,City, " 
                         + " Pin, Country, BusFax, BusPhone, Website, ContPerson, ContMob, ContEmail, ClientGroupName FROM  dbo.Client_Master "
                         + " LEFT OUTER JOIN dbo.ClientGroup_Master ON dbo.Client_Master.CTGId = dbo.ClientGroup_Master.CTGId where dbo.Client_Master.CompId='" + ViewState["compid"].ToString() + "') as a "
                         + " WHERE sino BETWEEN " + j + " AND " + i + "";
                sql2 = "select count(cltid) from  dbo.Client_Master LEFT OUTER JOIN dbo.ClientGroup_Master ON dbo.Client_Master.CTGId = dbo.ClientGroup_Master.CTGId  where dbo.Client_Master.CompId='" + ViewState["compid"].ToString() + "'";
            }
            else
            {
                if (Session["Srch"].ToString() == null)
                {
                    goto A10;
                }
                else
                {
                    
                    string srch = Session["Srch"].ToString();

                    sql = "select * from (select row_number() over(order by  ClientName asc)as sino,CltID,ClientName, Address1, Address2,Address3,City, "
                             + " Pin, Country, BusFax, BusPhone, Website, ContPerson, ContMob, ContEmail, ClientGroupName FROM  dbo.Client_Master "
                             + " LEFT OUTER JOIN dbo.ClientGroup_Master ON dbo.Client_Master.CTGId = dbo.ClientGroup_Master.CTGId where dbo.Client_Master.CompId='" + ViewState["compid"].ToString() + "' and " + srch + ") as a "
                             + " WHERE  sino BETWEEN " + j + " AND " + i + "";
                    sql2 = "select count(cltid) from dbo.Client_Master LEFT OUTER JOIN dbo.ClientGroup_Master ON dbo.Client_Master.CTGId = dbo.ClientGroup_Master.CTGId  where dbo.Client_Master.CompId='" + ViewState["compid"].ToString() + "'";


                }
            }

            DataTable dt2 = db.GetDataTable(sql);
            DataTable dtcount = db.GetDataTable(sql2);
            int totalcount = 0;
            if (dt2.Rows.Count > 0)
            {
                totalcount = Convert.ToInt32(dtcount.Rows[0][0].ToString());

                if (i <= totalcount)
                {
                    BtnNext.Visible = true;
                    BtnPrevious.Visible = true;
                }
                if (i >= totalcount)
                {
                    BtnNext.Visible = false;
                    BtnPrevious.Visible = true;
                }

                if (j == 1)
                {
                    if (dt2.Rows.Count == 25)
                    {
                        BtnNext.Visible = true;
                    }
                    BtnPrevious.Visible = false;
                }

            }

            Griddealers.DataSource = dt2;
            Griddealers.DataBind();
            if (txtsrchjob.Text == "")
            {
                hdnCntClient.Value = totalcount.ToString();
                Label1.Text = "Manage Client (" + hdnCntClient.Value + "/" + hdnCntClient.Value + ")";
            }
            else
            {
                Label1.Text = "Manage Client (" + totalcount + "/" + hdnCntClient.Value + ")";
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void btndelete_Click(object sender, EventArgs e)
    {
        try
        {
            DBAccess.PrintDelete(Session["IP"].ToString(), "Client Master", Session["fulname"].ToString(), Session["usertype"].ToString(), hdnDT.Value);
            ImageButton btndelete = sender as ImageButton;
            int id = Convert.ToInt32(btndelete.CommandArgument);
            ClientMaster client = new ClientMaster();
            string StrSQL2 = "select TSId from TimeSheet_Table where CLTId='" + id + "'";
            DataTable dttime = db.GetDataTable(StrSQL2);
            if (dttime.Rows.Count == 0)
            {
                ////  string sql2 = "Delete from Client_Master where CLTId='" + id + "'";
                //SqlConnection con = new SqlConnection(constr);
                //SqlCommand cmd = new SqlCommand("ClientMasterDelete", con);
                //cmd.CommandType = CommandType.StoredProcedure;
                //cmd.Parameters.Add("@CLTId", SqlDbType.Int).Value = id;
                //int res = cmd.ExecuteNonQuery();
                //if (res > 0)
                //{
                //    MessageBox.Show("Client deleted successfully");
                //}
                //else
                //{
                //    MessageBox.Show("Fail to delete client");
                //}
                //string StrSQL = "select UserId from Client_Master where CLTId='" + id + "'";
                //DataTable dtUserInfo = db.GetDataTable(StrSQL);
                client.CLTId = id;
                //ViewState["userid"] = dtUserInfo.Rows[0]["UserId"].ToString();
                //string StrSQL1 = " delete from aspnet_Membership where UserId='" + ViewState["userid"].ToString() + "';" +
                //                 " delete from dbo.aspnet_UsersInRoles where UserId='" + ViewState["userid"].ToString() + "';" +
                //                 " delete from dbo.aspnet_Users where UserId='" + ViewState["userid"].ToString() + "'";
                //db.ExecuteCommand(StrSQL1);

                int result = client.Delete();
                if (result > 0)
                {
                    MessageBox.Show("Client is being deleted succesfully ");
                }
                else
                {
                    MessageBox.Show("Failed to delete the client ");
                }
                 Session["companyid"]=hdnCompanyid.Value ;
                 Session["cltcomp"] = hdnCompanyid.Value;
                //bindgrid();
                //Label lblstat = (Label)this.Page.Master.FindControl("Label8");
                UpdatePanel updatepan = (UpdatePanel)this.Page.Master.FindControl("MasterUpdate");
                //string query1 = "select count(*) as totcount  from Client_Master where CompId='" + ViewState["compid"].ToString() + "'";
                //DataTable dt2 = db.GetDataTable(query1);
                //if (dt2.Rows.Count != 0 && dt2 != null)
                //{
                //    lblstat.Text = dt2.Rows[0]["totcount"].ToString();
                //}
                //else
                //{
                //    lblstat.Text = "0";
                //}
                bindgrid();
                UpdatePanel1.Update();
                updatepan.Update();
            }
            else
            {
                MessageControl1.SetMessage("Timesheet Entry exists.So this client cannot be deleted", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {
            string es = ex.ToString();
        }
    }
    protected void Griddealers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        Griddealers.PageIndex = e.NewPageIndex;
        bindgrid();
    }
    protected void Griddealers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "client")
            {
                LinkButton btn = (LinkButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int compid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
                Session["cltid"] = compid;
                //if (Request.QueryString["masters"] != null)
                //{
                    Response.Redirect("EditClient.aspx");
                //}
                //else
                //{
                //    Response.Redirect("ad_jobdetails.aspx?clt_id=" + Session["cltid"].ToString() + "");
                //}
            }
            else if (e.CommandName == "edit")
            {
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int compid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
                Session["cltid"] = compid;
                Response.Redirect("EditClient.aspx");
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void btnsrchjob_Click(object sender, EventArgs e)
    {
        string txtval = txtsrchjob.Text;
        string sql = "";
        if (txtsrchjob.Text != "")
        {
            if (ddlcltcgm.SelectedValue.ToString()== "client")
            {
                sql = " ClientName like '%" + txtval + "%' ";
            }
            else {
                sql = " ClientGroupName   like '%" + txtval + "%' ";
            }
        }

        Session["Srch"] = sql;
        Session["first"] = null;

        //userlist_data.SelectCommand = "select row_number() over(order by  ClientName asc)as sino,CLTId,City,Country,ClientName,BusFax,BusPhone,ContMob,'~/Company/cmp_staffdetails.aspx?clt_id='+convert(varchar(255),CLTId)as url from Client_Master where CompId='" + ViewState["compid"].ToString() + "' and ClientName like '%" + txtval + "%' order by ClientName ";
        //Griddealers.DataBind();
        bindgrid();



    }
    protected void lnknewclient_Click(object sender, EventArgs e)
    {
        Response.Redirect("ClientRegistration.aspx");
    }


    protected void BtnPrevious_Click(object sender, EventArgs e)
    {
        if (Session["first"].ToString() == "1")
        {
            BtnPrevious.Enabled = false;
        }
        else
        {
            int i = int.Parse(Session["first"].ToString());
            i = i - 1;
            Session["first"] = i;

            bindgrid();
        }

    }
    protected void BtnNext_Click(object sender, EventArgs e)
    {
        int i = int.Parse(Session["first"].ToString());
        i = i + 1;
        Session["first"] = i;

        bindgrid();

    }

    public string changelabel(string ChangeLabel)
    {
        try
        {
            string s, r;
            foreach (var item in LtblAccess)
            {
                r = item.LabelName;
                s = item.LabelAccessValue;
                ChangeLabel = ChangeLabel.Replace(r, s);
            }
        }
        catch (Exception ex)
        {

        }
        return ChangeLabel;
    }

    protected void BtnExport_Click(object sender, EventArgs e)
    {
        LabelAccess objlabelAccess = new LabelAccess();
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(Session["companyid"].ToString()));
        try
        {
            string sql="select row_number() over(order by  c.ClientName asc)as Sr, c.ClientName, c.Address1, c.Address2, c.Address3,c.City,c.Pin, c.Country, c.BusPhone, c.BusFax, c.Website, " 
                     + " c.ContPerson, c.ContMob, c.ContEmail, cg.ClientGroupName FROM dbo.ClientGroup_Master AS cg RIGHT OUTER JOIN dbo.Client_Master as c ON cg.CTGId = c.CTGId "
            + " where c.CompId='" + ViewState["compid"].ToString() + "' order by c.ClientName";
            DataTable dt = db.GetDataTable(sql);
            foreach (DataColumn col in dt.Columns)
            {
                col.ColumnName = changelabel(col.ColumnName);
            }
            
            if (dt.Rows.Count > 0)
            {
                DumpExcel(dt);
            }
            else
            {
                MessageBox.Show("No Records To Export");
            }


        //    if (Griddealers.Rows.Count > 0)
        //    {
        //        Response.Clear();
        //        Response.Buffer = true;
        //        Response.AddHeader("content-disposition", "attachment;filename=Client_Master.xls");
        //        Response.Charset = "";
        //        Response.ContentType = "application/vnd.ms-excel";
        //        using (StringWriter sw = new StringWriter())
        //        {
        //            HtmlTextWriter hw = new HtmlTextWriter(sw);
        //            Griddealers.RenderControl(hw);

        //            style to format numbers to string
        //            Response.Output.Write(sw.ToString());
        //            Response.End();
        //        }
        //    }
        }
        catch (Exception ex)
        {
            //string ss = ex.StackTrace.ToString();
            //string s = ex.InnerException.ToString();
        }
    }


    private void DumpExcel(DataTable tbl)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Client");

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            ws.Cells["A1"].LoadFromDataTable(tbl, true);

            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:AI1"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }

            //Example how to Format Column 1 as numeric 
            //using (ExcelRange col = ws.Cells[2, 1, 2 + tbl.Rows.Count, 1])
            //{
            //    col.Style.Numberformat.Format = "#,##0.00";
            //    col.Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
            //}

            ////Write it back to the client
            //Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            //Response.AddHeader("content-disposition", "attachment;  filename=SalesTracker.xlsx");
            //Response.BinaryWrite(pck.GetAsByteArray());


            using (var memoryStream = new MemoryStream())
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=Client.xlsx");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }

}
