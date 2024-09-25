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


public partial class controls_AddRecordsJGrp : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    private readonly JobgroupMaster jobgrp = new JobgroupMaster();

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
                Div2.Style.Value = "display:block";
                //Txt2.Focus();
                txtsearchJobG.Focus();
                bindJGrp();
                //Label18.Text = "Department";

            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
            Txt2.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        }
 
    }

    public void displayblock(Boolean bln, Boolean bln1)
    {
        Div2.Style.Value = "display:none";
 
    }

    public void btnJGrp()
    {
        try
        {
            if (ViewState["compid"] != null)
            {
                if (Txt2.Text != "")
                {
                    string str = "select JobGroupName from dbo.JobGroup_Master where JobGroupName ='" + Txt2.Text.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {
                        jobgrp.id = 0;
                        jobgrp.CompId = int.Parse(ViewState["compid"].ToString());
                        jobgrp.JobGroupName = Txt2.Text;
                        int res = jobgrp.Insert();
                        if (res == 1)
                        {
                            MessageControl1.SetMessage("JobGroup Name Added Successfully", MessageDisplay.DisplayStyles.Success);
                            clearall();
                            ModalPopupExtender2.Hide();

                            //add_depart.Style.Value = "display:none";
                        }
                        else
                            MessageControl1.SetMessage("Error!!!JobGroup Name not Added", MessageDisplay.DisplayStyles.Error);
                    }
                    else
                    {
                        MessageControl1.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl1.SetMessage("Please Enter a JobGroup Name.", MessageDisplay.DisplayStyles.Error);
                }
                bindJGrp();

            }
            else
            {
                MessageControl1.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }


    public SqlDataSource Jobname
    {
        get { return SqlDataSource11; }
    }
    public void bindJobName()
    {
        Jobname.SelectCommand = "SELECT jg.JobGId, jg.JobGroupName, jn.MJobId, jn.MJobName FROM JobGroup_Master as jg INNER JOIN Job_Master as j ON jg.JobGId = j.JobGId INNER JOIN JobName_Master as jn ON j.mJobID = jn.MJobId where jg.JobGId='" + Session["JobGId"].ToString() + "' order by MJobName";
        chk_dv = (DataView)Jobname.Select(DataSourceSelectArguments.Empty);
        chk_dt = chk_dv.ToTable();
        int i = chk_dt.Rows.Count;
        GrdJ .DataBind();
    }

    public SqlDataSource JobGroup
    {
        get { return SqlDataSource2; }
    }
    public void bindJGrp()
    {
        try
        {
            int depid = 0;
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            JobGroup.SelectCommand = "select * from JobGroup_Master where CompId='" + ViewState["compid"].ToString() + "' order by JobGroupName";

            chk_dv = (DataView)JobGroup.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl1.SetMessage("No JobGroup Name Added", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    depid = int.Parse(chk_dt.Rows[0]["JobGId"].ToString());
                }
                ModalPopupExtender2.Hide();
                searchdept.Style.Value = "display:block";
            }

            else
            {
                msghead.Style.Value = "display:block";
                searchdept.Style.Value = "display:none";

            }
            GrdJG.DataBind();
            Session["JobGId"] = depid;
            bindJobName();

        }
        catch (Exception ex)
        {

        }
    }
    protected void GrdJG_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == "delete")
            {
                DBAccess.PrintDelete(Session["IP"].ToString(), "Job Group Master", Session["fulname"].ToString(), Session["usertype"].ToString(), hdnDT.Value);
                ImageButton btn = (ImageButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                int compid = int.Parse(GrdJG.DataKeys[row.RowIndex].Value.ToString());
                //find staff for that desg
                string sql = "Select * from job_master where JobGId='" + compid + "'";
                DataTable dt = db.GetDataTable(sql);
                if (dt == null || dt.Rows.Count == 0)
                {

                    string StrSQL = "delete from dbo.JobGroup_Master where JobGId='" + compid + "'";
                    int res = db.ExecuteCommand(StrSQL);
                    if (res == 1)
                    {
                        MessageControl1.SetMessage("Job Group Name Deleted Successfully", MessageDisplay.DisplayStyles.Info);
                    }
                    else
                    {
                        MessageControl1.SetMessage("Job Group Name Not Deleted", MessageDisplay.DisplayStyles.Error);
                    }

                    JobGroup.DeleteCommand = StrSQL;
                    bindJGrp();
                }
                else
                {
                    string StrSQL = "delete from dbo.JobGroup_Master where JobGId='0'";
                    int res = db.ExecuteCommand(StrSQL);
                    JobGroup.DeleteCommand = StrSQL;
                    MessageControl1.SetMessage("Cannot delete JobGroup Name, Job exist", MessageDisplay.DisplayStyles.Error);
                    bindJGrp();
                }

            }
            if (e.CommandName == "view")
            {
                LinkButton btn = (LinkButton)e.CommandSource;
                GridViewRow row = (GridViewRow)btn.NamingContainer;
                Session["JobGId"] = int.Parse(GrdJG.DataKeys[row.RowIndex].Value.ToString());
                bindJobName();

            }
        }
        catch (Exception ex)
        {

        }
    }


    protected void GrdJG_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GrdJG.EditIndex = e.NewPageIndex;
        bindJGrp();

    }




    protected void GrdJG_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)GrdJG.Rows[e.RowIndex].FindControl("TextBox3")).Text);
            string mainCatgId = ((Label)GrdJG.Rows[e.RowIndex].FindControl("lblDid")).Text;

            string str = "select JobGroupName from dbo.JobGroup_Master where JobGroupName ='" + maincattext.Trim() + "' and CompId='" + ViewState["compid"].ToString() + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {
                string StrSQL = "update JobGroup_Master set JobGroupName='" + maincattext + "' where JobGId=" + mainCatgId;
                JobGroup.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                GrdJG.EditIndex = -1;
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl1.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            bindJGrp();
        }
        catch (Exception ex)
        {

        }
    }



    protected void GrdJG_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GrdJG.EditIndex = -1;
        bindJGrp();
    }

    protected void GrdJG_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GrdJG.EditIndex = e.NewEditIndex;
        btnJobGsearch_Click(sender, e);
        txtsearchJobG.Text = "";
        //binddept();
        bindJobName();
    }

    public void clearall()
    {
        Txt2.Text = string.Empty;
    }

    protected void GrdJG_SelectedIndexChanged(object sender, EventArgs e)
    {
        GrdJG.SelectedRowStyle.BackColor = System.Drawing.Color.Yellow;
    }


    protected void GrdJG_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox3").Focus();
        }
    }


    protected void btnJobGsearch_Click(object sender, EventArgs e)
    {
        string txtval = txtsearchJobG.Text;
        JobGroup.SelectCommand = "select * from JobGroup_Master where JobGroupName like '%" + txtval + "%' and CompId='" + ViewState["compid"].ToString() + "' order by JobGroupName";
        //DataTable dt=db.GetDataTable(str);
        GrdJG.DataBind();
        if (GrdJG.Rows.Count == 0)
        {
            Session["JobGId"] = "";
            bindJobName();
        }


    }


    protected void Button4_Click(object sender, EventArgs e)
    {
        string txtval = txtsearchJobG.Text;
        JobGroup.SelectCommand = "select * from JobGroup_Master where JobGroupName like '%" + txtval + "%' and CompId='" + ViewState["compid"].ToString() + "' order by JobGroupName";
        GrdJG.DataBind();
    }

    protected void btnaddJobG_Click(object sender, EventArgs e)
    {
        Label33.Text = "Add JobGroup Name";
        Label1.Text = "Job Group Name";
        Txt2.Focus();
        ModalPopupExtender2.Show();
    }
   
    protected void BtnClose2_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender2.Hide();
    }
    protected void BtnSubmit2_Click1(object sender, EventArgs e)
    {

        btnJGrp();
        btnaddJobG.Focus();

    }

    protected void btnCancel2_Click(object sender, EventArgs e)
    {
        clearall();
        ModalPopupExtender2.Hide();

    }

    protected void GrdJG_RowCreated(object sender, GridViewRowEventArgs e)
    {
        e.Row.Attributes.Add("onclick", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseover", "this.originalstyle=this.style.backgroundColor;this.style.backgroundColor='#55A0FF'");

        e.Row.Attributes.Add("onmouseout", "this.style.backgroundColor=this.originalstyle;");
    }


    protected void GrdJ_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GrdJ.PageIndex = e.NewPageIndex;
        bindJobName();

    }
}

