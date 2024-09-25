using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;

public partial class Admin_Department_List : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    DataTable dt_dep = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["admin"] != null)
        {
            if (!IsPostBack)
            {
               
            }
        }
        else
        {
            Response.Redirect("~/Default.aspx");
        }

    }
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        GetDepartments();
    }
    public void GetDepartments()
    {
        string qry1 = string.Format("select * from dbo.Department_Master where CompId='{0}' ", drpcompany.SelectedValue);
        DataTable dt = db.GetDataTable(qry1);
        if (dt.Rows.Count != 0)
        {
            DepartmentList.DataSource = dt;
            DepartmentList.DataBind();
            Label14.Visible = false;
        }
        else
        {
            DepartmentList.DataSource = null;
            DepartmentList.DataBind();
            Label14.Visible = false;
        }
    }

    protected void btngenerate_Click(object sender, EventArgs e)
    {
        try
        {
            Session["URL"] = "Admin/Department_List.aspx";
            if (drpcompany.SelectedIndex != 0)
            {
                int comp = int.Parse(drpcompany.SelectedValue);
                int stf = 0;
                foreach (DataListItem rw in DepartmentList.Items)
                {
                    Label lblId = (Label)rw.FindControl("Label51");
                    int Cid = int.Parse(lblId.Text);
                    Label lblstaff = (Label)rw.FindControl("Label50");
                    string staff = lblstaff.Text;
                    CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                    if (chk.Checked == true)
                    {
                        stf = Cid;
                        if (dt_dep == null || dt_dep.Rows.Count == 0)
                        {
                            dt_dep.Columns.Add("DepId", System.Type.GetType("System.String"));
                            dt_dep.Columns.Add("DepName", System.Type.GetType("System.String"));
                            DataRow dr = dt_dep.NewRow();
                            dr["DepId"] = Cid;
                            dr["DepName"] = staff;
                            dt_dep.Rows.Add(dr);
                            dt_dep.AcceptChanges();
                        }
                        else
                        {
                            DataRow dr = dt_dep.NewRow();
                            dr["DepId"] = Cid;
                            dr["DepName"] = staff;
                            dt_dep.Rows.Add(dr);
                            dt_dep.AcceptChanges();
                        }
                    }
                }
                Session["dt_dep"] = dt_dep;
                if (dt_dep.Rows.Count <= 0)
                {
                    MessageControl1.SetMessage("No Staff Selected.", MessageDisplay.DisplayStyles.Error);
                }
                else
                {
                    string str = "select d.CompId,StaffCode,StaffName,d.DepartmentName,d.DepId from  dbo.Staff_Master as s inner join  dbo.Department_Master as d on s.DepId=d.DepId where d.CompId='" + comp + "'";
                    DataTable dt = db.GetDataTable(str);
                    if (dt.Rows.Count > 0)
                    {
                        Response.Redirect("~/report1.aspx?comp=" + comp + "&pagename=DepartmentList");
                    }
                    else
                    {
                        MessageControl1.SetMessage("No Record Found.", MessageDisplay.DisplayStyles.Error);
                    }
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
    protected void chk_allDepart_CheckedChanged(object sender, EventArgs e)
    {
        if (chk_allDepart.Checked == true)
        {
            foreach (DataListItem rw in DepartmentList.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = true;
            }
        }
        else if (chk_allDepart.Checked == false)
        {
            foreach (DataListItem rw in DepartmentList.Items)
            {
                CheckBox chk = (CheckBox)rw.FindControl("chkitem");
                chk.Checked = false;
            }
        }
    }
}
