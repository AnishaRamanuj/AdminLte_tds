using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JTMSProject;
using System.Data;

public partial class Admin_Client_List : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    DataTable dtclient = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["admin"] != null)
        {
            if (!IsPostBack)
            {
                bindcomp();
            }
        }
        else
        {
            Response.Redirect("~/Default.aspx");
        }

    }
    public void bindcomp()
    {
        string ss = "select * from Company_Master order by CompanyName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            drpcompany.DataSource = dt;
            drpcompany.DataBind();
        }
    }
    public void bindclient()
    {
        string ss = "select * from Client_Master where CompId='" + drpcompany.SelectedValue + "' order by ClientName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            DataList1.DataSource = dt;
            DataList1.DataBind();
            Label7.Visible = false;
        }
        else
        {
            DataList1.DataSource = null;
            DataList1.DataBind();
            Label7.Visible = false;
        }
    }
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindclient();
    }
    protected void chkstaff_CheckedChanged(object sender, EventArgs e)
    {
        if (chkstaff.Checked == true)
        {
            foreach (DataListItem rw in DataList1.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (chkstaff.Checked == false)
        {
            foreach (DataListItem rw in DataList1.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
        }
    }
    protected void btngenerate_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Client_List.aspx";
            if (drpcompany.SelectedValue != "0")
            {
                int comp = int.Parse(drpcompany.SelectedValue);
                int stf = 0;
                foreach (DataListItem rw in DataList1.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    int Cid = int.Parse(lblId.Text);
                    Label lblstaff = (Label)rw.FindControl("Label50");
                    string staff = lblstaff.Text;
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        stf = Cid;
                        if (dtclient == null || dtclient.Rows.Count == 0)
                        {
                            dtclient.Columns.Add("CLTId", System.Type.GetType("System.String"));
                            dtclient.Columns.Add("ClientName", System.Type.GetType("System.String"));
                            DataRow dr = dtclient.NewRow();
                            dr["CLTId"] = Cid;
                            dr["ClientName"] = staff;
                            dtclient.Rows.Add(dr);
                            dtclient.AcceptChanges();
                        }
                        else
                        {
                            DataRow dr = dtclient.NewRow();
                            dr["CLTId"] = Cid;
                            dr["ClientName"] = staff;
                            dtclient.Rows.Add(dr);
                            dtclient.AcceptChanges();
                        }
                    }
                }
                Session["dtclient"] = dtclient;
                if (dtclient.Rows.Count > 0)
                {
                    Session["startdate"] = null;
                    Session["enddate"] = null;
                    Response.Redirect("~/report1.aspx?comp=" + comp + "&pagename=ClientList");
                }
                else
                {
                    drpcompany_SelectedIndexChanged(sender, e);
                    MessageControl1.SetMessage("No Clients Selected.", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                MessageControl1.SetMessage("Mandatory fields should be filled.", MessageDisplay.DisplayStyles.Error);
            }

        }
        catch (Exception ex)
        {

        }
    }

}
