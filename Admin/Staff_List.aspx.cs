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

public partial class Admin_Staff_List : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    DataTable dtstaff = new DataTable();
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
    public void bindstaff()
    {
        string ss = "select * from Staff_Master where CompId='" + drpcompany.SelectedValue + "' order by StaffName";
        DataTable dt = db.GetDataTable(ss);
        if (dt.Rows.Count != 0)
        {
            DataList1.DataSource = dt;
            DataList1.DataBind();
            Label14.Visible = false;
        }
        else
        {
            DataList1.DataSource = null;
            DataList1.DataBind();
            Label14.Visible = false;
        }
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
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindstaff();
    }
    protected void btngenerate_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Staff_List.aspx";
            if (drpcompany.SelectedIndex != 0)
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
                        if (dtstaff == null || dtstaff.Rows.Count == 0)
                        {
                            dtstaff.Columns.Add("StaffCode", System.Type.GetType("System.String"));
                            dtstaff.Columns.Add("StaffName", System.Type.GetType("System.String"));
                            DataRow dr = dtstaff.NewRow();
                            dr["StaffCode"] = Cid;
                            dr["StaffName"] = staff;
                            dtstaff.Rows.Add(dr);
                            dtstaff.AcceptChanges();
                        }
                        else
                        {
                            DataRow dr = dtstaff.NewRow();
                            dr["StaffCode"] = Cid;
                            dr["StaffName"] = staff;
                            dtstaff.Rows.Add(dr);
                            dtstaff.AcceptChanges();
                        }
                    }
                }
                Session["dtstaff"] = dtstaff;
                if (dtstaff.Rows.Count > 0)
                {
                    Response.Redirect("~/report1.aspx?comp=" + comp + "&pagename=StaffList");
                }
                else
                {
                    chkstaff.Checked = false;
                    MessageControl1.SetMessage("No Records Found.", MessageDisplay.DisplayStyles.Error);
                    drpcompany_SelectedIndexChanged(sender, e);
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
