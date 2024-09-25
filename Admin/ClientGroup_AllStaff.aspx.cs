using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;

public partial class Admin_ClientGroup_AllStaff : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    DataTable dt_portStaff = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

        }

    }
    protected void btngen_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/ClientGroup_AllStaff.aspx";
            if (drpcompanylist.SelectedValue == "0" || drpcompanylist.SelectedValue == "--Select--")
            {
                MessageControl1.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }
            else
            {
                int comp = int.Parse(drpcompanylist.SelectedValue);
                /////////////////////////////////////////////////////////////////////////////////////////////////////////////
                if (DropClientGroup.SelectedValue == "0" || DropClientGroup.SelectedValue == "--Select--")
                {
                    MessageControl1.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    string id = "";
                    foreach (DataListItem rw in Client_List.Items)
                    {
                        Label lblId = (Label)rw.FindControl("Label51");
                        decimal wid = decimal.Parse(lblId.Text);
                        CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                        if (chk.Checked == true)
                        {
                            id += "'" + wid + "'" + ",";
                        }

                    }
                    if (id != "")
                    {
                        id = id.Remove(id.Length - 1, 1);
                    }
                    string str = "select *,Client_Master.CLTId,Client_Master.ClientName from dbo.Job_Master inner join Client_Master on Job_Master.CLTId=Client_Master.CLTId where Job_Master.CLTId in (" + id + ")";

                    DataTable dtavail = db.GetDataTable(str);


                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    Client_List.DataSource = dtavail;
                    Client_List.DataBind();
                    int stf = 0;
                    foreach (DataListItem rw in Client_List.Items)
                    {
                        Label lblId = (Label)rw.FindControl("Label51");
                        int Cid = int.Parse(lblId.Text);
                        Label lblstaff = (Label)rw.FindControl("Label50");
                        string staff = lblstaff.Text;
                        stf = Cid;

                        if (dt_portStaff == null || dt_portStaff.Rows.Count == 0)
                        {
                            dt_portStaff.Columns.Add("CLTId", System.Type.GetType("System.String"));
                            dt_portStaff.Columns.Add("ClientName", System.Type.GetType("System.String"));

                            DataRow dr = dt_portStaff.NewRow();
                            dr["CLTId"] = Cid;
                            dr["ClientName"] = staff;

                            dt_portStaff.Rows.Add(dr);
                            dt_portStaff.AcceptChanges();
                        }
                        else
                        {
                            DataRow dr = dt_portStaff.NewRow();
                            dr["CLTId"] = Cid;
                            dr["ClientName"] = staff;

                            dt_portStaff.Rows.Add(dr);
                            dt_portStaff.AcceptChanges();
                        }
                    }
                    Session["dt_Ct_AlStaff"] = dt_portStaff;

                    if (id == "")
                    {
                        chkjob1.Checked = false;
                        MessageControl1.SetMessage("No Clients Selected.", MessageDisplay.DisplayStyles.Error);
                        DropClientGroup_SelectedIndexChanged(sender, e);
                    }
                    else if (dt_portStaff.Rows.Count > 0)
                    {
                        Session["startdate"] = null;
                        Session["enddate"] = null;
                        Response.Redirect("~/report1.aspx?comp=" + comp + "&clntgrp=" + DropClientGroup.SelectedValue + "&pagename=ClientGroup");
                    }
                    else
                    {
                        DropClientGroup_SelectedIndexChanged(sender, e);
                        MessageControl1.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                    }
                }
            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void drpcompanylist_SelectedIndexChanged(object sender, EventArgs e)
    {
        string query = string.Format("select * from dbo.ClientGroup_Master where CompId='{0}'", drpcompanylist.SelectedValue);
        DataTable dt_group = db.GetDataTable(query);
        if (dt_group.Rows.Count > 0)
        {
            DropClientGroup.DataSource = dt_group;
            DropClientGroup.DataBind();
            DropClientGroup.Items.Insert(0, "--Select--");
        }
    }
    protected void chkjob1_CheckedChanged(object sender, EventArgs e)
    {
        if (chkjob1.Checked == true)
        {
            foreach (DataListItem rw in Client_List.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = true;
            }
        }
        else if (chkjob1.Checked == false)
        {
            foreach (DataListItem rw in Client_List.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem1");
                chk.Checked = false;
            }
        }
    }
    protected void DropClientGroup_SelectedIndexChanged(object sender, EventArgs e)
    {

        string query = string.Format("select * from dbo.Client_Master where CTGId='{0}' order by ClientName", DropClientGroup.SelectedValue);
        DataTable dt_clients = db.GetDataTable(query);
        if (dt_clients.Rows.Count > 0)
        {
            Client_List.DataSource = dt_clients;
            Client_List.DataBind();
           
        }
    }
}
