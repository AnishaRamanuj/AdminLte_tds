using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JTMSProject;
using System.Data;

public partial class Admin_AddRecords : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    private readonly DesignationMaster des = new DesignationMaster();
    private readonly DepartmentMaster dept = new DepartmentMaster();
    private readonly BranchMaster br = new BranchMaster();
    private readonly OpeMaster op = new OpeMaster();
    private readonly LocationMaster loc = new LocationMaster();
    private readonly NarrationMaster nar = new NarrationMaster();
    private readonly JobgroupMaster jobgrp = new JobgroupMaster();
    private readonly ClientgroupMaster clntgrp = new ClientgroupMaster();
    int compid = 0;
    DataView chk_dv;
    DataTable chk_dt;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {          
            if (Session["adminid"] != null)
            {
                bindcomp();
                if (Request.QueryString["desig"] != null)
                {
                    Div1.Style.Value = "display:block";
                    binddesig();
                    txtdesignation.Focus();
                    Label19.Text = "Designation";
                }
                else if (Request.QueryString["dep"] != null)
                {
                    Div2.Style.Value = "display:block";
                    binddept();
                    txtdeptname.Focus();
                    Label19.Text = "Department";
                }
                else if (Request.QueryString["br"] != null)
                {
                    Div4.Style.Value = "display:block";
                    bindbranch();
                    txtbranchname.Focus();
                    Label19.Text = "Branch";
                }
                else if (Request.QueryString["ope"] != null)
                {
                    Div6.Style.Value = "display:block";
                    bindOPE();
                    txtopename.Focus();
                    Label19.Text = "OPE";
                }
                else if (Request.QueryString["loc"] != null)
                {
                    Div8.Style.Value = "display:block";
                    bindLocation();
                    txtlocation.Focus();
                    Label19.Text = "Location";
                }
                else if (Request.QueryString["nar"] != null)
                {
                    Div10.Style.Value = "display:block";
                    bindNarration();
                    txtnaration.Focus();
                    Label19.Text = "Narration";
                }
                else if (Request.QueryString["jg"] != null)
                {
                    Div12.Style.Value = "display:block";
                    bindJobGroup();
                    txtjobgroup.Focus();
                    Label19.Text = "Job Group";
                }
                else if (Request.QueryString["cg"] != null)
                {
                    Div14.Style.Value = "display:block";
                    bindClientGroup();
                    txtclientgrp.Focus();
                    Label19.Text = "Client Group";
                }
                else
                {
                    Div1.Style.Value = "display:block";
                    binddesig();
                    txtdesignation.Focus();
                    Label18.Text = "Designation";
                }
                drpcompany.SelectedIndex = 0;
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        txtdesignation.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtdeptname.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtbranchname.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtopename.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtlocation.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtnaration.Attributes.Add("onkeyup", "CountFrmTitle(this,300);");
        txtjobgroup.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtclientgrp.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txthourcharge.Attributes.Add("onkeyup", "return  ValidateText(this);");
       // txtdesignation.Attributes.Add("onkeyup", "validate();");
    }
    protected void btndesignation_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["adminid"] != null)
            {
                if (txtdesignation.Text != "")
                {
                    if (txthourcharge.Text != "")
                    {
                        string str = "select DesignationName from dbo.Designation_Master where DesignationName ='" + txtdesignation.Text.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
                        DataTable dt = db.GetDataTable(str);
                        if (dt == null || dt.Rows.Count == 0)
                        {
                            des.CompId = int.Parse(drpcompany.SelectedValue);
                            des.id = int.Parse(Session["adminid"].ToString());
                            des.DesignationName = txtdesignation.Text;
                            des.HourlyCharges = int.Parse(txthourcharge.Text.Trim());
                            int res = des.Insert();
                            txtdesignation.Text = ""; txthourcharge.Text = "";
                            if (res == 1)
                            {
                                MessageControl2.SetMessage("Designation Added Successfully", MessageDisplay.DisplayStyles.Success);
                                clearall();
                                add_desn.Style.Value = "display:none";
                            }
                            else
                            {

                                MessageControl2.SetMessage("Error!!!Designation not Added", MessageDisplay.DisplayStyles.Error);
                            }
                        }
                        else
                        {
                            MessageControl2.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                        }
                    }
                    else
                    {
                        MessageControl2.SetMessage("Please Enter Hourly Charges.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl2.SetMessage("Please Enter a Designation.", MessageDisplay.DisplayStyles.Error);
                }
                binddesig();
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
    protected void btndept_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["adminid"] != null)
            {
                if (txtdeptname.Text != "")
                {
                    string str = "select DepartmentName from dbo.Department_Master where DepartmentName ='" + txtdeptname.Text.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {
                        dept.CompId = int.Parse(drpcompany.SelectedValue);
                        dept.id = int.Parse(Session["adminid"].ToString());
                        dept.DepartmentName = txtdeptname.Text;
                        int res = dept.Insert();
                        txtdeptname.Text = "";
                        if (res == 1)
                        {
                            MessageControl1.SetMessage("Deparment Added Successfully", MessageDisplay.DisplayStyles.Success);
                            clearall();
                            add_depart.Style.Value = "display:none";
                        }
                        else
                        {
                            MessageControl1.SetMessage("Error!!!Deparment not Added", MessageDisplay.DisplayStyles.Error);
                        }
                    }
                    else
                    {
                        MessageControl1.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl1.SetMessage("Please Enter a Department.", MessageDisplay.DisplayStyles.Error);
                }
                binddept();
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
    protected void btnbranch_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["adminid"] != null)
            {
                if (txtbranchname.Text != "")
                {
                    string str = "select BranchName from dbo.Branch_Master where BranchName ='" + txtbranchname.Text.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {
                        br.CompId = int.Parse(drpcompany.SelectedValue);
                        br.id = int.Parse(Session["adminid"].ToString());
                        br.BranchName = txtbranchname.Text;
                        int res = br.Insert();
                        txtbranchname.Text = "";
                        if (res == 1)
                        {
                            MessageControl3.SetMessage("Branch Added Successfully", MessageDisplay.DisplayStyles.Success);
                            clearall();
                            add_brch.Style.Value = "display:none";
                        }
                        else
                        {
                            MessageControl3.SetMessage("Error!!!Branch not Added", MessageDisplay.DisplayStyles.Error);
                        }
                    }
                    else
                    {
                        MessageControl3.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl3.SetMessage("Please Enter a Branch.", MessageDisplay.DisplayStyles.Error);
                }
                bindbranch();
            }
            else
            {
                MessageControl3.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void btnope_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["adminid"] != null)
            {
                if (txtopename.Text != "")
                {
                    string str = "select OPEName from dbo.OPE_Master where OPEName ='" + txtopename.Text.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {
                        op.CompId = int.Parse(drpcompany.SelectedValue);
                        op.id = int.Parse(Session["adminid"].ToString());
                        op.OPEName = txtopename.Text;
                        int res = op.Insert();
                        txtopename.Text = "";
                        if (res == 1)
                        {
                            MessageControl4.SetMessage("OPE Added Successfully", MessageDisplay.DisplayStyles.Success);
                            clearall();
                            add_ope.Style.Value = "display:none";
                        }
                        else
                        {
                            MessageControl4.SetMessage("Error!!!OPE not Added", MessageDisplay.DisplayStyles.Error);
                        }
                    }
                    else
                    {
                        MessageControl4.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl4.SetMessage("Please Enter OPE.", MessageDisplay.DisplayStyles.Error);
                }
                bindOPE();
            }
            else
            {
                MessageControl4.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void btnlocation_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["adminid"] != null)
            {
                if (txtlocation.Text != "")
                {
                    string str = "select LocationName from dbo.Location_Master where LocationName ='" + txtlocation.Text.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {
                        loc.CompId = int.Parse(drpcompany.SelectedValue);
                        loc.id = int.Parse(Session["adminid"].ToString());
                        loc.LocationName = txtlocation.Text;
                        int res = loc.Insert();
                        txtlocation.Text = "";
                        if (res == 1)
                        {
                            MessageControl5.SetMessage("Location Added Successfully", MessageDisplay.DisplayStyles.Success);
                            clearall();
                            add_lctn.Style.Value = "display:none";
                        }
                        else
                        {
                            MessageControl5.SetMessage("Error!!!Location not Added", MessageDisplay.DisplayStyles.Error);
                        }
                    }
                    else
                    {
                        MessageControl5.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl5.SetMessage("Please Enter a Location.", MessageDisplay.DisplayStyles.Error);
                }
                bindLocation();
            }
            else
            {
                MessageControl5.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    protected void btnnaration_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["adminid"] != null)
            {
                if (txtnaration.Text != "")
                {
                    string str = "select NarrationName from dbo.Narration_Master where NarrationName ='" + txtnaration.Text.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {
                        nar.CompId = int.Parse(drpcompany.SelectedValue);
                        nar.id = int.Parse(Session["adminid"].ToString());
                        nar.NarrationName = txtnaration.Text;
                        nar.StaffCode = 0;
                        int res = nar.Insert();
                        txtnaration.Text = "";
                        if (res == 1)
                        {
                            MessageControl6.SetMessage("Narration Added Successfully", MessageDisplay.DisplayStyles.Success);
                            clearall();
                            add_narn.Style.Value = "display:none";
                        }
                        else
                        {
                            MessageControl6.SetMessage("Error!!!Narration not Added", MessageDisplay.DisplayStyles.Error);
                        }
                    }
                    else
                    {
                        MessageControl6.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl6.SetMessage("Please Enter Narration.", MessageDisplay.DisplayStyles.Error);
                }
                bindNarration();
            }
            else
            {
                MessageControl6.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    protected void btnjobgroup_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["adminid"] != null)
            {
                if (txtjobgroup.Text != "")
                {
                    string str = "select JobGroupName from dbo.JobGroup_Master where JobGroupName ='" + txtjobgroup.Text.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {
                        jobgrp.CompId = int.Parse(drpcompany.SelectedValue);
                        jobgrp.id = int.Parse(Session["adminid"].ToString());
                        jobgrp.JobGroupName = txtjobgroup.Text;
                        int res = jobgrp.Insert();
                        txtjobgroup.Text = "";
                        if (res == 1)
                        {
                            MessageControl7.SetMessage("Job Group Added Successfully", MessageDisplay.DisplayStyles.Success);
                            clearall();
                            add_jobGrp.Style.Value = "display:none";
                        }
                        else
                        {
                            MessageControl7.SetMessage("Error!!!Job Group not Added", MessageDisplay.DisplayStyles.Error);
                        }
                    }
                    else
                    {
                        MessageControl7.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl7.SetMessage("Please Enter a Job Group.", MessageDisplay.DisplayStyles.Error);
                }
                bindJobGroup();
            }
            else
            {
                MessageControl7.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    protected void btnclientgrp_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["adminid"] != null)
            {
                if (txtclientgrp.Text != "")
                {
                    string str = "select ClientGroupName from dbo.ClientGroup_Master where ClientGroupName ='" + txtclientgrp.Text.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt == null || dt.Rows.Count == 0)
                    {
                        clntgrp.CompId = int.Parse(drpcompany.SelectedValue);
                        clntgrp.id = int.Parse(Session["adminid"].ToString());
                        clntgrp.ClientGroupName = txtclientgrp.Text;
                        int res = clntgrp.Insert();
                        txtclientgrp.Text = "";
                        if (res == 1)
                        {
                            MessageControl8.SetMessage("Client Group Added Successfully", MessageDisplay.DisplayStyles.Success);
                            clearall();
                            add_cltGrp.Style.Value = "display:none";
                        }
                        else
                        {
                            MessageControl8.SetMessage("Error!!!Client Group not Added", MessageDisplay.DisplayStyles.Error);
                        }
                    }
                    else
                    {
                        MessageControl8.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl8.SetMessage("Please Enter a Client Group.", MessageDisplay.DisplayStyles.Error);
                }
                bindClientGroup();
            }
            else
            {
                MessageControl8.SetMessage("Please Login Again", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
    public SqlDataSource company
    {
        get { return SqlDataSource9; }
    }
    public void bindcomp()
    {
        company.SelectCommand = "select * from Company_Master order by CompanyName";
        drpcompany.DataBind();
    }
    //designation//
    public SqlDataSource designation
    {
        get { return SqlDataSource1; }
    }
    public void binddesig()
    {
        try
        {
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            designation.SelectCommand = "select * from Designation_Master where CompId='" + drpcompany.SelectedValue + "' order by DesignationName";
            chk_dv = (DataView)designation.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl2.SetMessage("No Designation Added", MessageDisplay.DisplayStyles.Error);

                }

                add_desn.Style.Value = "display:none";
                searchdesg.Style.Value = "display:block";
            }
            else
            {
                searchdesg.Style.Value = "display:none";
                msghead.Style.Value = "display:block;float:left;";

            }
            Griddealers.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    protected void Griddealers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        binddesig();
    }
    protected void Griddealers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            ImageButton btn = (ImageButton)e.CommandSource;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int compid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
            string StrSQL = "delete from dbo.Designation_Master where DsgId='" + compid + "'";
            db.ExecuteCommand(StrSQL);
            designation.DeleteCommand = StrSQL;
            binddesig();
        }
    }
    protected void Griddealers_RowEditing(object sender, GridViewEditEventArgs e)
    {
        Griddealers.EditIndex = e.NewEditIndex;
        binddesig();
    }
    protected void Griddealers_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)Griddealers.Rows[e.RowIndex].FindControl("TextBox1")).Text);
            string maincattext1 = (((TextBox)Griddealers.Rows[e.RowIndex].FindControl("TextBox2")).Text);
            string mainCatgId = ((Label)Griddealers.Rows[e.RowIndex].FindControl("lblfid")).Text;
            string str = "select DesignationName,HourlyCharges from dbo.Designation_Master where DesignationName ='" + maincattext.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {
                string StrSQL = "update Designation_Master set DesignationName='" + maincattext + "' , HourlyCharges='" + maincattext1 + "'where DsgId='" + mainCatgId + "'";
                designation.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                Griddealers.EditIndex = -1;
            }
            else if (dt.Rows[0]["HourlyCharges"].ToString() != maincattext1)
            {
                string StrSQL = "update Designation_Master set HourlyCharges='" + maincattext1 + "' where DsgId='" + mainCatgId + "'";
                designation.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                Griddealers.EditIndex = -1;
                string str1 = "select DesignationName from dbo.Designation_Master where DsgId='" + mainCatgId + "'";
                DataTable dt1 = db.GetDataTable(str1);
                if (dt1.Rows[0]["DesignationName"].ToString() != maincattext)
                {
                    MessageControl2.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                e.Cancel = true;
                Griddealers.EditIndex = -1;
                //MessageControl2.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            binddesig();
        }
        catch (Exception ex)
        {

        }
    }
    protected void Griddealers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        Griddealers.EditIndex = -1;
        binddesig();
    }

    //department//
    public SqlDataSource department
    {
        get { return SqlDataSource2; }
    }
    public void binddept()
    {
        try
        {
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            department.SelectCommand = "select * from Department_Master where CompId='" + drpcompany.SelectedValue + "' order by DepartmentName";
            chk_dv = (DataView)department.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl1.SetMessage("No Departments Added", MessageDisplay.DisplayStyles.Error);

                }

                add_depart.Style.Value = "display:none";
                searchdept.Style.Value = "display:block";
            }
            //if (add_depart.Style.Value == "display:none")
            //{
            //    msghead1.Style.Value = "display:none";
            //    searchdept.Style.Value = "display:block";

            //}
            //else if (add_depart.Style.Value == null || add_depart.Style.Value == "display:block")
            //{
            //    msghead1.Style.Value = "display:block";
            //    searchdept.Style.Value = "display:none";

            //}
            else
            {
                msghead1.Style.Value = "display:block;float:left";
                searchdept.Style.Value = "display:none";
            }
            GridView1.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            ImageButton btn = (ImageButton)e.CommandSource;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int compid = int.Parse(GridView1.DataKeys[row.RowIndex].Value.ToString());
            string StrSQL = "delete from dbo.Department_Master where DepId='" + compid + "'";
            db.ExecuteCommand(StrSQL);
            department.DeleteCommand = StrSQL;
            binddept();
        }
    }
    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        binddept();
    }
    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)GridView1.Rows[e.RowIndex].FindControl("TextBox3")).Text);
            string mainCatgId = ((Label)GridView1.Rows[e.RowIndex].FindControl("lblfid")).Text;

            string str = "select DepartmentName from dbo.Department_Master where DepartmentName ='" + maincattext.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {
                string StrSQL = "update Department_Master set DepartmentName='" + maincattext + "' where DepId='" + mainCatgId + "'";
                department.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                GridView1.EditIndex = -1;
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl1.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            binddept();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView1.EditIndex = -1;
        binddept();
    }
    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView1.EditIndex = e.NewEditIndex;
        binddept();
    }

    //branch//
    public SqlDataSource branch
    {
        get { return SqlDataSource3; }
    }
    public void bindbranch()
    {
        try
        {
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            branch.SelectCommand = "select * from Branch_Master where CompId='" + drpcompany.SelectedValue + "' order by BranchName";
            chk_dv = (DataView)branch.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl3.SetMessage("No Branch Added", MessageDisplay.DisplayStyles.Error);

                }

                add_brch.Style.Value = "display:none";
                searchbr.Style.Value = "display:block";
            }
            //if (add_brch.Style.Value == "display:none")
            //{
            //    msghead2.Style.Value = "display:none";
            //    searchbr.Style.Value = "display:block";

            //}
            //else if (add_brch.Style.Value == null || add_brch.Style.Value == "display:block")
            //{
            //    msghead2.Style.Value = "display:block";
            //    searchbr.Style.Value = "display:none";

            //}
            else
            {
                msghead2.Style.Value = "display:block;float:left";
                searchbr.Style.Value = "display:none";
            }
            GridView2.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView2_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        bindbranch();
    }
    protected void GridView2_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            ImageButton btn = (ImageButton)e.CommandSource;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int compid = int.Parse(GridView2.DataKeys[row.RowIndex].Value.ToString());
            string StrSQL = "delete from dbo.Branch_Master where BrId='" + compid + "'";
            db.ExecuteCommand(StrSQL);
            branch.DeleteCommand = StrSQL;
            bindbranch();
        }
    }
    protected void GridView2_RowEditing(object sender, GridViewEditEventArgs e)
    {
        //GridView2.Rows[e.NewEditIndex].FindControl("TextBox3").Focus();
        GridView2.EditIndex = e.NewEditIndex;
        bindbranch();
    }
    protected void GridView2_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView2.EditIndex = -1;
        bindbranch();
    }
    protected void GridView2_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)GridView2.Rows[e.RowIndex].FindControl("TextBox3")).Text);
            string mainCatgId = ((Label)GridView2.Rows[e.RowIndex].FindControl("lblfid")).Text;

            string str = "select BranchName from dbo.Branch_Master where BranchName ='" + maincattext.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {
                string StrSQL = "update Branch_Master set BranchName='" + maincattext + "' where BrId='" + mainCatgId + "'";
                branch.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                GridView2.EditIndex = -1;
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl3.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            bindbranch();
        }
        catch (Exception ex)
        {

        }
    }

    //ope//
    public SqlDataSource OPE
    {
        get { return SqlDataSource4; }
    }
    public void bindOPE()
    {
        try
        {
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            OPE.SelectCommand = "select * from OPE_Master where CompId='" + drpcompany.SelectedValue + "' order by OPEName";
            chk_dv = (DataView)OPE.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl4.SetMessage("No OPE Added", MessageDisplay.DisplayStyles.Error);

                }

                add_ope.Style.Value = "display:none";
                searchope.Style.Value = "display:block";
            }
            //if (add_ope.Style.Value == "display:none")
            //{
            //    msghead3.Style.Value = "display:none";
            //    searchope.Style.Value = "display:block";

            //}
            //else if (add_ope.Style.Value == null || add_ope.Style.Value == "display:block")
            //{
            //    msghead3.Style.Value = "display:block";
            //    searchope.Style.Value = "display:none";

            //}
            else
            {
                msghead3.Style.Value = "display:block;float:left";
                searchope.Style.Value = "display:none";

            }

            GridView3.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView3_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        bindOPE();

    }
    protected void GridView3_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            ImageButton btn = (ImageButton)e.CommandSource;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int compid = int.Parse(GridView3.DataKeys[row.RowIndex].Value.ToString());
            string StrSQL = "delete from dbo.OPE_Master where OpeId='" + compid + "'";
            db.ExecuteCommand(StrSQL);
            OPE.DeleteCommand = StrSQL;
            bindOPE();
        }
    }
    protected void GridView3_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)GridView3.Rows[e.RowIndex].FindControl("TextBox3")).Text);
            string mainCatgId = ((Label)GridView3.Rows[e.RowIndex].FindControl("lblfid")).Text;
            string str = "select OPEName from dbo.OPE_Master where OPEName ='" + maincattext.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {

                string StrSQL = "update OPE_Master set  OPEName='" + maincattext + "' where OpeId='" + mainCatgId + "'";
                OPE.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                GridView3.EditIndex = -1;
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl4.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            bindOPE();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView3_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView3.EditIndex = -1;
        bindOPE();
    }
    protected void GridView3_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView3.EditIndex = e.NewEditIndex;
        bindOPE();
    }

    //location//
    public SqlDataSource Location
    {
        get { return SqlDataSource5; }
    }
    public void bindLocation()
    {
        try
        {
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            Location.SelectCommand = "select * from Location_Master where CompId='" + drpcompany.SelectedValue + "' order by LocationName";
            chk_dv = (DataView)Location.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl5.SetMessage("No Location Added", MessageDisplay.DisplayStyles.Error);

                }

                add_lctn.Style.Value = "display:none";
                searchloc.Style.Value = "display:block";
            }
            //if (add_lctn.Style.Value == "display:none")
            //{
            //    msghead4.Style.Value = "display:none";
            //    searchloc.Style.Value = "display:block";

            //}
            //else if (add_lctn.Style.Value == null || add_lctn.Style.Value == "display:block")
            //{
            //    msghead4.Style.Value = "display:block";
            //    searchloc.Style.Value = "display:none";

            //}
            else
            {
                msghead4.Style.Value = "display:block;float:left";
                searchloc.Style.Value = "display:none";

            }
            GridView4.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView4_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        bindLocation();
    }
    protected void GridView4_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            ImageButton btn = (ImageButton)e.CommandSource;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int compid = int.Parse(GridView4.DataKeys[row.RowIndex].Value.ToString());
            string StrSQL = "delete from dbo.Location_Master where LocId='" + compid + "'";
            db.ExecuteCommand(StrSQL);
            Location.DeleteCommand = StrSQL;
            bindLocation();
        }
    }
    protected void GridView4_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView4.EditIndex = e.NewEditIndex;
        bindLocation();
    }
    protected void GridView4_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView4.EditIndex = -1;
        bindLocation();
    }
    protected void GridView4_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)GridView4.Rows[e.RowIndex].FindControl("TextBox3")).Text);
            string mainCatgId = ((Label)GridView4.Rows[e.RowIndex].FindControl("lblfid")).Text;

            string str = "select LocationName from dbo.Location_Master where LocationName ='" + maincattext.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {
                string StrSQL = "update Location_Master set  LocationName='" + maincattext + "' where LocId='" + mainCatgId + "'";
                Location.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                GridView4.EditIndex = -1;
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl5.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            bindLocation();
        }
        catch (Exception ex)
        {

        }
    }

    //narration//
    public SqlDataSource Narration
    {
        get { return SqlDataSource6; }
    }
    public void bindNarration()
    {
        try
        {
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            Narration.SelectCommand = "select * from Narration_Master where CompId='" + drpcompany.SelectedValue + "' and StaffCode=0 order by NarrationName";

            chk_dv = (DataView)Narration.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl6.SetMessage("No Narration Added", MessageDisplay.DisplayStyles.Error);

                }

                add_narn.Style.Value = "display:none";
                searchnar.Style.Value = "display:block";
            }
            //if (add_narn.Style.Value == "display:none")
            //{
            //    msghead5.Style.Value = "display:none";
            //    searchnar.Style.Value = "display:block";

            //}
            //else if (add_narn.Style.Value == null || add_narn.Style.Value == "display:block")
            //{
            //    msghead5.Style.Value = "display:block";
            //    searchnar.Style.Value = "display:none";

            //}
            else
            {
                msghead5.Style.Value = "display:block;float:left";
                searchnar.Style.Value = "display:none";

            }
            GridView5.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView5_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        bindNarration();
    }
    protected void GridView5_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            ImageButton btn = (ImageButton)e.CommandSource;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int compid = int.Parse(GridView5.DataKeys[row.RowIndex].Value.ToString());
            string StrSQL = "delete from dbo.Narration_Master where NarId='" + compid + "'";
            db.ExecuteCommand(StrSQL);
            Narration.DeleteCommand = StrSQL;
            bindNarration();
        }
    }
    protected void GridView5_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)GridView5.Rows[e.RowIndex].FindControl("TextBox3")).Text);
            string mainCatgId = ((Label)GridView5.Rows[e.RowIndex].FindControl("lblfid")).Text;

            string str = "select NarrationName from dbo.Narration_Master where NarrationName ='" + maincattext.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {
                string StrSQL = "update Narration_Master set  NarrationName='" + maincattext + "' where NarId='" + mainCatgId + "'";
                Narration.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                GridView5.EditIndex = -1;
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl6.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            bindNarration();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView5_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView5.EditIndex = -1;
        bindNarration();
    }
    protected void GridView5_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView5.EditIndex = e.NewEditIndex;
        bindNarration();
    }

    //jobgroup//
    public SqlDataSource JobGroup
    {
        get { return SqlDataSource7; }
    }
    public void bindJobGroup()
    {
        try
        {
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            JobGroup.SelectCommand = "select * from JobGroup_Master where CompId='" + drpcompany.SelectedValue + "' order by JobGroupName";
            chk_dv = (DataView)JobGroup.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl7.SetMessage("No Job Group Added", MessageDisplay.DisplayStyles.Error);

                }

                add_jobGrp.Style.Value = "display:none";
                searchjg.Style.Value = "display:block";
            }
            //if (add_jobGrp.Style.Value == "display:none")
            //{
            //    msghead6.Style.Value = "display:none";
            //    searchjg.Style.Value = "display:block";

            //}
            //else if (add_jobGrp.Style.Value == null || add_jobGrp.Style.Value == "display:block")
            //{
            //    msghead6.Style.Value = "display:block";
            //    searchjg.Style.Value = "display:none";

            //}
            else
            {
                msghead6.Style.Value = "display:block;float:left";
                searchjg.Style.Value = "display:none";

            }
            GridView6.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView6_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        bindJobGroup();
    }
    protected void GridView6_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            ImageButton btn = (ImageButton)e.CommandSource;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int compid = int.Parse(GridView6.DataKeys[row.RowIndex].Value.ToString());
            string StrSQL = "delete from dbo.JobGroup_Master where JobGId='" + compid + "'";
            db.ExecuteCommand(StrSQL);
            JobGroup.DeleteCommand = StrSQL;
            bindJobGroup();
        }
    }
    protected void GridView6_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView6.EditIndex = e.NewEditIndex;
        bindJobGroup();
    }
    protected void GridView6_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView6.EditIndex = -1;
        bindJobGroup();
    }
    protected void GridView6_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)GridView6.Rows[e.RowIndex].FindControl("TextBox3")).Text);
            string mainCatgId = ((Label)GridView6.Rows[e.RowIndex].FindControl("lblfid")).Text;
            string str = "select JobGroupName from dbo.JobGroup_Master where JobGroupName ='" + maincattext.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {

                string StrSQL = "update JobGroup_Master set  JobGroupName='" + maincattext + "' where JobGId='" + mainCatgId + "'";
                JobGroup.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                GridView6.EditIndex = -1;
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl7.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            bindJobGroup();
        }
        catch (Exception ex)
        {

        }
    }

    //clientgroup//
    public SqlDataSource ClientGroup
    {
        get { return SqlDataSource8; }
    }
    public void bindClientGroup()
    {
        try
        {
            //userlist_data.SelectCommand = "select row_number() over(order by CreatedDate desc)as sino,CompId,username,password,CompanyName,Email,Phone,City from Company_Master";       
            ClientGroup.SelectCommand = "select * from ClientGroup_Master where CompId='" + drpcompany.SelectedValue + "' order by ClientGroupName ";
            chk_dv = (DataView)ClientGroup.Select(DataSourceSelectArguments.Empty);
            chk_dt = chk_dv.ToTable();
            if (string.IsNullOrEmpty(Request.QueryString["stt"]))
            {
                if (chk_dt.Rows.Count == 0)
                {
                    MessageControl8.SetMessage("No Client Group Added", MessageDisplay.DisplayStyles.Error);

                }

                add_cltGrp.Style.Value = "display:none";
                searchcg.Style.Value = "display:block";
            }
            //if (add_cltGrp.Style.Value == "display:none")
            //{
            //    msghead7.Style.Value = "display:none";
            //    searchcg.Style.Value = "display:block";

            //}
            //else if (add_cltGrp.Style.Value == null || add_cltGrp.Style.Value == "display:block")
            //{
            //    msghead7.Style.Value = "display:block";
            //    searchcg.Style.Value = "display:none";

            //}
            else
            {
                msghead7.Style.Value = "display:block;float:left";
                searchcg.Style.Value = "display:none";

            }
            GridView7.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView7_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        bindClientGroup();
    }
    protected void GridView7_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "delete")
        {
            ImageButton btn = (ImageButton)e.CommandSource;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int compid = int.Parse(GridView7.DataKeys[row.RowIndex].Value.ToString());
            string StrSQL = "delete from dbo.ClientGroup_Master where CTGId='" + compid + "'";
            db.ExecuteCommand(StrSQL);
            ClientGroup.DeleteCommand = StrSQL;
            bindClientGroup();
        }
    }
    protected void GridView7_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        try
        {
            string maincattext = (((TextBox)GridView7.Rows[e.RowIndex].FindControl("TextBox3")).Text);
            string mainCatgId = ((Label)GridView7.Rows[e.RowIndex].FindControl("lblfid")).Text;
            string str = "select ClientGroupName from dbo.ClientGroup_Master where ClientGroupName ='" + maincattext.Trim() + "' and CompId='" + drpcompany.SelectedValue + "'";
            DataTable dt = db.GetDataTable(str);
            if (dt == null || dt.Rows.Count == 0)
            {

                string StrSQL = "update ClientGroup_Master set  ClientGroupName='" + maincattext + "' where CTGId='" + mainCatgId + "'";
                ClientGroup.UpdateCommand = StrSQL;
                db.ExecuteCommand(StrSQL);
                GridView7.EditIndex = -1;
            }
            else
            {
                e.Cancel = true;
                //Griddealers.EditIndex = -1;
                MessageControl8.SetMessage("Error!!!Duplication entry not allowed.", MessageDisplay.DisplayStyles.Error);
            }
            bindClientGroup();
        }
        catch (Exception ex)
        {

        }
    }
    protected void GridView7_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView7.EditIndex = -1;
        bindClientGroup();
    }
    protected void GridView7_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView7.EditIndex = e.NewEditIndex;
        bindClientGroup();
    }
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (Request.QueryString["desig"] != null)
        {
            Div1.Style.Value = "display:block";
            designation.SelectCommand = "select * from Designation_Master where CompId='" + drpcompany.SelectedValue + "' order by DesignationName";
            Griddealers.DataBind();
        }
        else if (Request.QueryString["dep"] != null)
        {
            Div2.Style.Value = "display:block";
            department.SelectCommand = "select * from Department_Master where CompId='" + drpcompany.SelectedValue + "' order by Departmentname";
            GridView1.DataBind();

        }
        else if (Request.QueryString["br"] != null)
        {
            Div4.Style.Value = "display:block";
            branch.SelectCommand = "select * from Branch_Master where CompId='" + drpcompany.SelectedValue + "' order by BranchName";
            GridView2.DataBind();
        }
        else if (Request.QueryString["ope"] != null)
        {
            Div6.Style.Value = "display:block";
            OPE.SelectCommand = "select * from OPE_Master where CompId='" + drpcompany.SelectedValue + "' order by OPEName";
            GridView3.DataBind();
        }
        else if (Request.QueryString["loc"] != null)
        {
            Div8.Style.Value = "display:block";
            Location.SelectCommand = "select * from Location_Master where CompId='" + drpcompany.SelectedValue + "' order by LocationName";
            GridView4.DataBind();
        }
        else if (Request.QueryString["nar"] != null)
        {
            Div10.Style.Value = "display:block";
            Narration.SelectCommand = "select * from Narration_Master where CompId='" + drpcompany.SelectedValue + "' order by NarrationName";
            GridView5.DataBind();
        }
        else if (Request.QueryString["jg"] != null)
        {
            Div12.Style.Value = "display:block";
            JobGroup.SelectCommand = "select * from JobGroup_Master where CompId='" + drpcompany.SelectedValue + "' order by JobGroupName";
            GridView6.DataBind();
        }
        else if (Request.QueryString["cg"] != null)
        {
            Div14.Style.Value = "display:block";
            ClientGroup.SelectCommand = "select * from ClientGroup_Master where CompId='" + drpcompany.SelectedValue + "' order by ClientGroupName";
            GridView7.DataBind();
        }
    }
    public void clearall()
    {
        txtdesignation.Text = string.Empty;
        txthourcharge.Text = string.Empty;
        txtdeptname.Text = string.Empty;
        txtbranchname.Text = string.Empty;
        txtopename.Text = string.Empty;
        txtlocation.Text = string.Empty;
        txtnaration.Text = string.Empty;
        txtjobgroup.Text = string.Empty;
        txtclientgrp.Text = string.Empty;
    }
    protected void Griddealers_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            //Set the focus to control on the edited row
            //e.Row.Cells[1].Controls[0].Focus();

            //Or to a specific control in TemplateField
            e.Row.FindControl("TextBox1").Focus(); 
 
        }
    }
    protected void lnknewclient_Click(object sender, EventArgs e)
    {
        Response.Redirect("AddRecords.aspx?desig=1&stt=new");
    }
    protected void LinkCltg_Click(object sender, EventArgs e)
    {
        Response.Redirect("AddRecords.aspx?cg=1&stt=new");
    }
    protected void LinkJob_Click(object sender, EventArgs e)
    {
        Response.Redirect("AddRecords.aspx?jg=1&stt=new");
    }
    protected void LinkNarn_Click(object sender, EventArgs e)
    {
        Response.Redirect("AddRecords.aspx?nar=1&stt=new");
    }
    protected void LinkLocatn_Click(object sender, EventArgs e)
    {
        Response.Redirect("AddRecords.aspx?loc=1&stt=new");
    }
    protected void LinkOpe_Click(object sender, EventArgs e)
    {
        Response.Redirect("AddRecords.aspx?ope=1&stt=new");
    }
    protected void LinkBranch_Click(object sender, EventArgs e)
    {
        Response.Redirect("AddRecords.aspx?br=1&stt=new");
    }
    protected void LinkDepart_Click(object sender, EventArgs e)
    {
        Response.Redirect("AddRecords.aspx?dep=1&stt=new");
    }
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox3").Focus();
        }
    }
    protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox3").Focus();
        }
    }
    protected void GridView3_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox3").Focus();
        }
    }
    protected void GridView4_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox3").Focus();
        }
    }
    protected void GridView5_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox3").Focus();
        }
    }
    protected void GridView6_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox3").Focus();
        }
    }
    protected void GridView7_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowState == DataControlRowState.Edit)
        {
            e.Row.FindControl("TextBox3").Focus();
        }
    }
    protected void btnsesg_Click(object sender, EventArgs e)
    {
        string txtval = txtdesgsearch.Text;
        designation.SelectCommand = "select * from Designation_Master where DesignationName like '%"+txtval+"%' and CompId='"+ drpcompany.SelectedValue +"' order by DesignationName";
        Griddealers.DataBind();
    }
    protected void btndepsearch_Click(object sender, EventArgs e)
    {
        string txtval = txtsearchdept.Text;
        department.SelectCommand = "select * from Department_Master where DepartmentName like '%" + txtval + "%' and CompId='" + drpcompany.SelectedValue + "' order by DepartmentName";
        GridView1.DataBind();

    }
    protected void btnsearchcg_Click(object sender, EventArgs e)
    {
        string txtval = txtcgsearch.Text;
        ClientGroup.SelectCommand = "select * from ClientGroup_Master where ClientGroupName like '%" + txtval + "%' and CompId='" + drpcompany.SelectedValue + "' order by ClientGroupName";
        GridView7.DataBind();

    }
    protected void btnjgsearch_Click(object sender, EventArgs e)
    {
        string txtval = txtjgsearch.Text;
        JobGroup.SelectCommand = "select * from JobGroup_Master where JobGroupName like '%" + txtval + "%' and CompId='" + drpcompany.SelectedValue + "' order by JobGroupName";
        GridView6.DataBind();

    }
    protected void btnsearchnar_Click(object sender, EventArgs e)
    {
        string txtval = txtnarsearch.Text;
        Narration.SelectCommand = "select * from Narration_Master where NarrationName like '%" + txtval + "%' and CompId='" + drpcompany.SelectedValue + "' order by NarrationName";
        GridView5.DataBind();

    }
    protected void btnlocsearch_Click(object sender, EventArgs e)
    {
        string txtval = txtlocsearch.Text;
        Location.SelectCommand = "select * from Location_Master where LocationName like '%" + txtval + "%' and CompId='" + drpcompany.SelectedValue + "' order by LocationName";
        GridView4.DataBind();

    }
    protected void btnopesearch_Click(object sender, EventArgs e)
    {
        string txtval = txtopesearch.Text;
        OPE.SelectCommand = "select * from OPE_Master where OPEName like '%" + txtval + "%' and CompId='" + drpcompany.SelectedValue + "' order by OPEName";
        GridView3.DataBind();

    }
    protected void btnsearchbr_Click(object sender, EventArgs e)
    {
        string txtval = txtbrsearch.Text;
        branch.SelectCommand = "select * from Branch_Master where BranchName like '%" + txtval + "%' and CompId='" + drpcompany.SelectedValue + "' order by BranchName";
        GridView2.DataBind();

    }
}
