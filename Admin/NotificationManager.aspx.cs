
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
using Microsoft.ApplicationBlocks.Data;
using System.Data.SqlClient;
using System.Collections.Generic;


public partial class Admin_NotificationManager : System.Web.UI.Page
{
    ConnectionClass connectionClass = new ConnectionClass();
    private readonly DBAccess db = new DBAccess();
    public static CultureInfo ci = new CultureInfo("en-GB");
    protected void Page_Load(object sender, EventArgs e)
    {
        string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
        if (!IsPostBack)
        {

            //divCompanyAndStff.Visible = false;
            divAllCompany.Visible = true;
            divSpecificStaff.Visible = false;
            divUrl.Visible = false;
            bindcomp();
            showpage();
            bindgrid();

            txtfrom.Text = dat;
            txtto.Text = dat;

        }
        //txtfrom.Attributes.Add("onblur", "checkForm();");

        //txtto.Attributes.Add("onblur", "checkForms();");
    }
    public void bindcomp()
    {
        try
        {
            DataSet ds = new DataSet();
            ds = SqlHelper.ExecuteDataset(connectionClass.getConnection(), CommandType.StoredProcedure, "usp_GetCompany");
            DataTable dt = new DataTable();
            dt = ds.Tables[0];
            chkCompany.DataSource = dt;
            chkCompany.DataTextField = "CompanyName";
            chkCompany.DataValueField = "CompId";
            chkCompany.DataBind();
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);

        }
    }

    public void bindstaff(string StrCompId)
    {
        try
        {
            DataSet ds = new DataSet();
            SqlParameter[] sqlParams = new SqlParameter[7];
            sqlParams[0] = new SqlParameter("@CompId", SqlDbType.VarChar);
            sqlParams[0].Value = StrCompId;
            ds = SqlHelper.ExecuteDataset(connectionClass.getConnection(), CommandType.StoredProcedure, "usp_GetStaffByCompIdNew", sqlParams);
            DataTable dt = new DataTable();
            dt = ds.Tables[0];
            chkListStaff.DataSource = dt;
            chkListStaff.DataTextField = "StaffName";
            chkListStaff.DataValueField = "StaffCode";
            chkListStaff.DataBind();
        }
        catch (Exception ex)

        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);

        }
    }

    //protected void chkCompanybox_CheckedChanged(object sender, EventArgs e)
    //{
    //    if (chkCompanybox.Checked == true)
    //    {
    //        foreach (ListItem item in chkCompany.Items)
    //        {
    //            item.Selected = true;
    //        }
    //    }
    //    else if (chkCompanybox.Checked == false)
    //    {
    //        foreach (ListItem item in chkCompany.Items)
    //        {
    //            item.Selected = false;
    //        }
    //    }

    //    DataTable dt = new DataTable();
    //    dt.Columns.Add("CompId");
    //    foreach (ListItem item in chkCompany.Items)
    //    {
    //        if (item.Selected)
    //        {
    //            var row = dt.NewRow();
    //            row["CompId"] = item.Value;
    //            dt.Rows.Add(row);
    //        }
    //    }

    //    bindstaff(dt);
    //}

    //protected void chkStaffbox_CheckedChanged(object sender, EventArgs e)
    //{
    //    if (chkStaffbox.Checked == true)
    //    {
    //        foreach (ListItem item in chkListStaff.Items)
    //        {
    //            item.Selected = true;
    //        }
    //    }
    //    else if (chkStaffbox.Checked == false)
    //    {
    //        foreach (ListItem item in chkListStaff.Items)
    //        {
    //            item.Selected = false;
    //        }
    //    }
    //}
    protected void OnCheckBox_Changed(object sender, EventArgs e)
    {
        try
        {
            string strCompId = string.Empty;
            DataTable dt = new DataTable();
            dt.Columns.Add("CompId");
            int count = 0;
            foreach (ListItem item in chkCompany.Items)
            {
                if (item.Selected)
                {
                    count = count + 1;
                    var row = dt.NewRow();
                    row["CompId"] = item.Value;
                    dt.Rows.Add(row);
                }
            }
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                strCompId = strCompId + dt.Rows[i]["CompId"].ToString();
                strCompId += (i < dt.Rows.Count - 1) ? "," : string.Empty;


            }
            strCompId.TrimEnd(',');
            chkCompanybox.Text = "Check All Company Name (Count :" + count + ")";
            if (rdoSpecificComStaff.Checked)
            {
                bindstaff(strCompId);
            }

            chkStaffbox.Checked = false;
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }
    }
    protected void chkIsLink_CheckedChanged(Object sender, EventArgs e)
    {
        if (chkIsLink.Checked)
        {
            divUrl.Visible = true;
        }
        else
        {
            divUrl.Visible = false;
        }

    }
    protected void chkIsActive_CheckedChanged(Object sender, EventArgs e)
    {

    }
    protected void Group1_CheckedChanged(Object sender, EventArgs e)
    {
        try
        {
            string strCompId = string.Empty;
            if (rdoAllComStaff.Checked)
            {
                divAllCompany.Visible = true;
                divSpecificStaff.Visible = false;
                bindcomp();
            }

            if (rdoSpecificComStaff.Checked)
            {

                divAllCompany.Visible = true;
                divSpecificStaff.Visible = true;
                DataTable dt = new DataTable();
                dt.Columns.Add("CompId");
                foreach (ListItem item in chkCompany.Items)
                {
                    if (item.Selected)
                    {
                        var row = dt.NewRow();
                        row["CompId"] = item.Value;
                        dt.Rows.Add(row);
                    }
                }
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    strCompId = strCompId + dt.Rows[i]["CompId"].ToString();
                    strCompId += (i < dt.Rows.Count - 1) ? "," : string.Empty;


                }
                strCompId.TrimEnd(',');

                bindstaff(strCompId);

            }
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }
    }
    protected void btngenerateNotification_Click(object sender, EventArgs e)
    {
        try
        {
            string strCompId = string.Empty;
            string strStaffId = string.Empty;
            if (!string.IsNullOrEmpty(txtMessage.Text) && !string.IsNullOrEmpty(txttitle.Text))
            {
                string title = txttitle.Text;
                string strtMessage = txtMessage.Text;
                bool Islink = false;
                bool IsActive = false;
                bool IsAllStaff = false;
                string strfrom = txtfrom.Text;
                string strTo = txtto.Text;
                string strUrl = string.Empty;

                //string fromdate = DateTime.ParseExact(txtfrom.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture)
                //            .ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);

                //string todate = DateTime.ParseExact(txtto.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture)
                //        .ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);


                DateTime from = Convert.ToDateTime(strfrom,ci);
                DateTime to = Convert.ToDateTime(strTo,ci);

                if (from > DateTime.Today.AddDays(-1) && to > DateTime.Today.AddDays(-1))
                {
                    if (chkIsLink.Checked)
                    {
                        Islink = true;
                        strUrl = txtUrl.Text;
                    }
                    if (chkIsActive.Checked)
                    {
                        IsActive = true;
                    }
                    DataTable dtCompId = new DataTable();
                    DataTable dtStaffId = new DataTable();
                    dtCompId.Columns.Add("CompId");
                    dtStaffId.Columns.Add("CompId");
                    dtStaffId.Columns.Add("StaffId");

                    if (rdoAllComStaff.Checked)
                    {
                        IsAllStaff = true;


                        foreach (ListItem item in chkCompany.Items)
                        {
                            if (item.Selected)
                            {
                                var row = dtCompId.NewRow();
                                row["CompId"] = item.Value;
                                dtCompId.Rows.Add(row);
                            }
                        }
                        for (int i = 0; i < dtCompId.Rows.Count; i++)
                        {
                            strCompId = strCompId + dtCompId.Rows[i]["CompId"].ToString();
                            strCompId += (i < dtCompId.Rows.Count - 1) ? "," : string.Empty;


                        }
                        strCompId.TrimEnd(',');


                    }
                    else
                    {
                        foreach (ListItem item in chkListStaff.Items)
                        {
                            if (item.Selected)
                            {
                                var row = dtStaffId.NewRow();
                                string StaffId = item.Value.Split('/')[0];
                                string CompId = item.Value.Split('/')[1];
                                row["StaffId"] = StaffId;
                                row["CompId"] = CompId;
                                dtStaffId.Rows.Add(row);
                            }
                        }
                        for (int i = 0; i < dtStaffId.Rows.Count; i++)
                        {
                            strCompId = strCompId + dtStaffId.Rows[i]["CompId"].ToString();
                            strCompId += (i < dtStaffId.Rows.Count - 1) ? "," : string.Empty;
                            strStaffId = strStaffId + dtStaffId.Rows[i]["StaffId"].ToString();
                            strStaffId += (i < dtStaffId.Rows.Count - 1) ? "," : string.Empty;

                        }
                        strCompId.TrimEnd(',');
                        strStaffId.TrimEnd(',');

                    }
                    SqlParameter[] sqlParams = new SqlParameter[11];
                    sqlParams[0] = new SqlParameter("@CompId", SqlDbType.VarChar);
                    sqlParams[0].Value = strCompId;

                    sqlParams[1] = new SqlParameter("@StaffId", SqlDbType.VarChar);
                    sqlParams[1].Value = strStaffId;

                    sqlParams[2] = new SqlParameter("@Title", SqlDbType.VarChar);
                    sqlParams[2].Value = title;

                    sqlParams[3] = new SqlParameter("@Message", SqlDbType.VarChar);
                    sqlParams[3].Value = strtMessage;

                    sqlParams[4] = new SqlParameter("@Url", SqlDbType.VarChar);
                    sqlParams[4].Value = strUrl;

                    sqlParams[5] = new SqlParameter("@FromDate", SqlDbType.DateTime);
                    sqlParams[5].Value = from;

                    sqlParams[6] = new SqlParameter("@Todate", SqlDbType.DateTime);
                    sqlParams[6].Value = to;

                    sqlParams[7] = new SqlParameter("@CreatedBy", SqlDbType.VarChar);
                    sqlParams[7].Value = Convert.ToString(Session["admin"]);

                    sqlParams[8] = new SqlParameter("@IsActive", SqlDbType.Bit);
                    sqlParams[8].Value = IsActive;

                    sqlParams[9] = new SqlParameter("@IsAllStaff", SqlDbType.Bit);
                    sqlParams[9].Value = IsAllStaff;

                    sqlParams[10] = new SqlParameter("@IsLink", SqlDbType.Bit);
                    sqlParams[10].Value = Islink;


                    SqlHelper.ExecuteNonQuery(connectionClass.getConnection(), CommandType.StoredProcedure, "usp_InsertNotificationSpecificCompAndStaffNew", sqlParams);
                    clear();
                    showpage();
                    bindgrid();
                    MessageBox(this, "Notification created successfully.");

                }
                else
                {
                    MessageBox(this, "Invalid From And To Date.");
                }
            }
            else
            {
                MessageBox(this, "All fields are mandatory.");
            }

        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }

    }

    protected void btnUpdateeNotification_Click(object sender, EventArgs e)
    {
        try
        {
            string strCompId = string.Empty;
            string strStaffId = string.Empty;
            if (!string.IsNullOrEmpty(txtMessage.Text) && !string.IsNullOrEmpty(txttitle.Text))
            {
                string title = txttitle.Text;
                string strtMessage = txtMessage.Text;
                bool Islink = false;
                bool IsActive = false;
                bool IsAllStaff = false;
                string strfrom = txtfrom.Text;
                string strTo = txtto.Text;
                string strUrl = string.Empty;


                //// string fromdate = DateTime.ParseExact(txtfrom.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture)
                //               .ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);

                // //  string todate = DateTime.ParseExact(txtto.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture)
                //           .ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);


                DateTime from = Convert.ToDateTime(strfrom,ci);
                DateTime to = Convert.ToDateTime(strTo,ci);
                if (from > DateTime.Today.AddDays(-1) && to > DateTime.Today.AddDays(-1))
                {
                    if (chkIsLink.Checked)
                    {
                        Islink = true;
                        strUrl = txtUrl.Text;
                    }
                    if (chkIsActive.Checked)
                    {
                        IsActive = true;
                    }
                    DataTable dtCompId = new DataTable();
                    DataTable dtStaffId = new DataTable();
                    dtCompId.Columns.Add("CompId");
                    dtStaffId.Columns.Add("CompId");
                    dtStaffId.Columns.Add("StaffId");

                    if (rdoAllComStaff.Checked)
                    {
                        IsAllStaff = true;


                        foreach (ListItem item in chkCompany.Items)
                        {
                            if (item.Selected)
                            {
                                var row = dtCompId.NewRow();
                                row["CompId"] = item.Value;
                                dtCompId.Rows.Add(row);
                            }
                        }
                        for (int i = 0; i < dtCompId.Rows.Count; i++)
                        {
                            strCompId = strCompId + dtCompId.Rows[i]["CompId"].ToString();
                            strCompId += (i < dtCompId.Rows.Count - 1) ? "," : string.Empty;


                        }
                        strCompId.TrimEnd(',');

                    }
                    else
                    {
                        foreach (ListItem item in chkListStaff.Items)
                        {
                            if (item.Selected)
                            {
                                var row = dtStaffId.NewRow();
                                string StaffId = item.Value.Split('/')[0];
                                string CompId = item.Value.Split('/')[1];
                                row["StaffId"] = StaffId;
                                row["CompId"] = CompId;
                                dtStaffId.Rows.Add(row);
                            }
                        }
                        for (int i = 0; i < dtStaffId.Rows.Count; i++)
                        {
                            strCompId = strCompId + dtStaffId.Rows[i]["CompId"].ToString();
                            strCompId += (i < dtStaffId.Rows.Count - 1) ? "," : string.Empty;
                            strStaffId = strStaffId + dtStaffId.Rows[i]["StaffId"].ToString();
                            strStaffId += (i < dtStaffId.Rows.Count - 1) ? "," : string.Empty;

                        }
                        strCompId.TrimEnd(',');
                        strStaffId.TrimEnd(',');

                    }
                    SqlParameter[] sqlParams = new SqlParameter[12];
                    sqlParams[0] = new SqlParameter("@CompId", SqlDbType.VarChar);
                    sqlParams[0].Value = strCompId;

                    sqlParams[1] = new SqlParameter("@StaffId", SqlDbType.VarChar);
                    sqlParams[1].Value = strStaffId;

                    sqlParams[2] = new SqlParameter("@Title", SqlDbType.VarChar);
                    sqlParams[2].Value = title;

                    sqlParams[3] = new SqlParameter("@Message", SqlDbType.VarChar);
                    sqlParams[3].Value = strtMessage;

                    sqlParams[4] = new SqlParameter("@Url", SqlDbType.VarChar);
                    sqlParams[4].Value = strUrl;

                    sqlParams[5] = new SqlParameter("@FromDate", SqlDbType.DateTime);
                    sqlParams[5].Value = from;

                    sqlParams[6] = new SqlParameter("@Todate", SqlDbType.DateTime);
                    sqlParams[6].Value = to;

                    sqlParams[7] = new SqlParameter("@CreatedBy", SqlDbType.VarChar);
                    sqlParams[7].Value = Convert.ToString(Session["admin"]);

                    sqlParams[8] = new SqlParameter("@IsActive", SqlDbType.Bit);
                    sqlParams[8].Value = IsActive;

                    sqlParams[9] = new SqlParameter("@IsAllStaff", SqlDbType.Bit);
                    sqlParams[9].Value = IsAllStaff;

                    sqlParams[10] = new SqlParameter("@IsLink", SqlDbType.Bit);
                    sqlParams[10].Value = Islink;

                    sqlParams[11] = new SqlParameter("@BroadcastID", SqlDbType.VarChar);
                    sqlParams[11].Value = Convert.ToString(Session["Broadcastid"]);



                    SqlHelper.ExecuteNonQuery(connectionClass.getConnection(), CommandType.StoredProcedure, "usp_UpdateNotificationSpecificCompAndStaffNew", sqlParams);
                    clear();
                    showpage();
                    bindgrid();

                    MessageBox(this, "Notification Updated successfully.");

                }
                else
                {
                    MessageBox(this, "Invalid From And To Date.");
                }
            }
            else
            {
                MessageBox(this, "All fields are mandatory.");
            }
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }
    }
    protected void btnAdd_Click(object sender, EventArgs e)
    {
        try
        {
            showpage2();
            btnUpdateeNotification.Visible = false;
            btngenerateNotification.Visible = true;
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }
    }

    public static void MessageBox(System.Web.UI.Page page, string strMsg)
    {
        //+ character added after strMsg "')"
        ScriptManager.RegisterClientScriptBlock(page, page.GetType(), "alertMessage", "alert('" + strMsg + "')", true);

    }

    private void bindgrid()
    {
        try
        {
            DataSet ds = new DataSet();
            string CreatedBy = Convert.ToString(Session["admin"]);
            SqlParameter[] objsqlparameter = new SqlParameter[2];
            objsqlparameter[0] = new SqlParameter("@search", txtSearch.Text);
            objsqlparameter[1] = new SqlParameter("@CreatedBy", CreatedBy);

            ds = SqlHelper.ExecuteDataset(connectionClass.getConnection(), CommandType.StoredProcedure, "usp_GetNotification", objsqlparameter);
            DataTable dt = new DataTable();
            dt = ds.Tables[0];
            gv_mainmenu.DataSource = ds;
            gv_mainmenu.DataBind();

        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }

    }


    private void showpage()
    {
        try
        {
            div1.Visible = false;
            div3.Visible = true;
            gv_mainmenu.Visible = true;
            divSpecificStaff.Visible = false;
            chkCompany.SelectedIndex = -1;
            rdoAllComStaff.Checked = true;
            rdoSpecificComStaff.Checked = false;
            chkCompanybox.Checked = false;
            chkCompanybox.Text = "Check All Company Name (Count :" + 0 + ")";
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }



    }
    private void showpage2()
    {
        try
        {
            div1.Visible = true;
            div3.Visible = false;
            gv_mainmenu.Visible = false;
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }
    }
    private void clear()
    {
        try
        {
            txtMessage.Text = string.Empty;
            txtUrl.Text = string.Empty;
            string dat = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
            txtfrom.Text = dat;
            txtto.Text = dat;
            txttitle.Text = string.Empty;
            bindcomp();
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }


    }


    protected void btnsearch_Click(object sender, EventArgs e)
    {
        bindgrid();
        // Clear();
    }

    protected void btncancel_Click(object sender, EventArgs e)
    {
        try
        {
            showpage();

            //bindcomp();
            clear();
            bindgrid();
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }

    }


    public void gv_rowcommand1(object sender, GridViewCommandEventArgs e)
    {
        string strCompId = string.Empty;
        string Broadcastid = e.CommandArgument.ToString();
        Session["Broadcastid"] = Broadcastid;
        if (e.CommandName == "myedit")
        {

            try
            {
                btnUpdateeNotification.Visible = true;
                btngenerateNotification.Visible = false;
                DataSet ds = new DataSet();
                SqlParameter[] objSqlParameter = new SqlParameter[1];
                objSqlParameter[0] = new SqlParameter("@BroadcastId", Broadcastid);
                ds = SqlHelper.ExecuteDataset(connectionClass.getConnection(), CommandType.StoredProcedure, "usp_GetNotificationWithId", objSqlParameter);
                txttitle.Text = ds.Tables[0].Rows[0]["Title"].ToString();
                txtMessage.Text = ds.Tables[0].Rows[0]["Message"].ToString();
                txtUrl.Text = ds.Tables[0].Rows[0]["Url"].ToString();
                txtfrom.Text = ds.Tables[0].Rows[0]["FromDate"].ToString();
                txtto.Text = ds.Tables[0].Rows[0]["Todate"].ToString();
                string IsActive = ds.Tables[0].Rows[0]["IsActive"].ToString();
                string IsAllStaff = ds.Tables[0].Rows[0]["IsAllStaff"].ToString();
                string IsIsLink = ds.Tables[0].Rows[0]["IsLink"].ToString();


                if (IsActive == "True")
                {
                    chkIsActive.Checked = true;
                }
                else
                {
                    chkIsActive.Checked = false;
                }

                if (IsAllStaff == "True")
                {
                    int count = 0;
                    divSpecificStaff.Visible = false;
                    divAllCompany.Visible = true;
                    rdoAllComStaff.Checked = true;
                    List<NotificationData> objListNotificationData = new List<NotificationData>();
                    foreach (DataRow dRow in ds.Tables[0].Rows)
                    {
                        NotificationData objNotificationData = new NotificationData();
                        objNotificationData.CompId = Convert.ToString(dRow["CompID"]);
                        objListNotificationData.Add(objNotificationData);
                    }
                    bindcomp();
                    foreach (ListItem item in chkCompany.Items)
                    {

                        string CompanyId = item.Value;
                        if (objListNotificationData.Any(x => x.CompId.Contains(CompanyId)))
                        {
                            item.Selected = true;
                            count = count + 1;
                        }

                    }
                    chkCompanybox.Text = "Check All Company Name (Count :" + count + ")";
                }
                else
                {
                    int count = 0;
                    rdoAllComStaff.Checked = false;
                    divSpecificStaff.Visible = true;
                    rdoSpecificComStaff.Checked = true;
                    List<NotificationData> objListNotificationData = new List<NotificationData>();
                    foreach (DataRow dRow in ds.Tables[0].Rows)
                    {
                        NotificationData objNotificationData = new NotificationData();
                        objNotificationData.CompId = Convert.ToString(dRow["CompID"]);
                        objNotificationData.StaffId = Convert.ToString(dRow["StaffID"]);
                        objListNotificationData.Add(objNotificationData);
                    }


                    bindcomp();
                    foreach (ListItem item in chkCompany.Items)
                    {
                        string CompanyId = item.Value;
                        if (objListNotificationData.Any(x => x.CompId.Contains(CompanyId)))
                        {
                            item.Selected = true;
                            count = count + 1;
                        }

                    }
                    chkCompanybox.Text = "Check All Company Name (Count :" + count + ")";


                    DataTable dt = new DataTable();
                    dt.Columns.Add("CompId");
                    foreach (ListItem item in chkCompany.Items)
                    {
                        if (item.Selected)
                        {
                            var row = dt.NewRow();
                            row["CompId"] = item.Value;
                            dt.Rows.Add(row);
                        }
                    }
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        strCompId = strCompId + dt.Rows[i]["CompId"].ToString();
                        strCompId += (i < dt.Rows.Count - 1) ? "," : string.Empty;


                    }
                    strCompId.TrimEnd(',');


                    bindstaff(strCompId);
                    int count1 = 0;
                    foreach (ListItem item in chkListStaff.Items)
                    {

                        //string StaffId = item.Value;
                        string StaffId = item.Value.Split('/')[0];
                        if (objListNotificationData.Any(x => x.StaffId.Contains(StaffId)))
                        {
                            item.Selected = true;
                            count1 = count1 + 1;
                        }

                    }
                    chkStaffbox.Text = "Check All Staff Name (Count :" + count1 + ")";

                }
                if (IsIsLink == "True")
                {
                    chkIsLink.Checked = true;
                }
                else
                {
                    chkIsLink.Checked = false;
                }
                showpage2();
            }

            catch (Exception ex)
            {
                MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
            }
        }

        if (e.CommandName == "mydelete")
        {
            try
            {
                DataSet ds = new DataSet();
                SqlParameter[] objSqlParameter = new SqlParameter[1];
                objSqlParameter[0] = new SqlParameter("@BroadcastId", Broadcastid);
                SqlHelper.ExecuteNonQuery(connectionClass.getConnection(), CommandType.StoredProcedure, "usp_DeleteNotificationCreatedByAdmin", objSqlParameter);
                MessageControl2.SetMessage("Your Data Deleted Successfully", MessageDisplay.DisplayStyles.Success);

                bindgrid();

            }

            catch (Exception ex)
            {


                MessageControl2.SetMessage("Something went wrong", MessageDisplay.DisplayStyles.Error);

            }

        }



    }
    public class NotificationData
    {
        public string CompId { get; set; }
        public string StaffId { get; set; }
    }


    protected void chkListStaff_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            int count = 0;
            foreach (ListItem item in chkListStaff.Items)
            {
                if (item.Selected)
                {
                    count = count + 1;

                }
            }
            chkStaffbox.Text = "Check All Staff Name (Count :" + count + ")";
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }
    }
}
