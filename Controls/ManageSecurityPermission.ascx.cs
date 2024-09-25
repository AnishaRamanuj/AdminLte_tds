using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JTMSProject;
using System.Data;

public partial class controls_ManageSecurityPermission : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["compid"] != null)
            {
                bindcomp();
                string compid = Request.QueryString["compid"];
                Bind(compid);
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        Text_Pricing.Attributes.Add("onkeyup", "return  ValidateText(this);");
        Text_StaffCount.Attributes.Add("onkeyup", "return  ValidateText(this);");
        Text_UserCount.Attributes.Add("onkeyup", "return  ValidateText(this);");
    }
    protected void Bind(string id)
    {
        try
        {
            string ss1 = "select * from SecurityPermission where CompId=" + id;
            DataTable dt1 = db.GetDataTable(ss1);
            if (dt1.Rows.Count != 0)
            {
                Drop_Company.SelectedValue = dt1.Rows[0]["CompId"].ToString();
                Drop_Scheme.SelectedValue = dt1.Rows[0]["Schemes"].ToString();
                Text_UserCount.Text = dt1.Rows[0]["UserCount"].ToString();
                Text_StaffCount.Text = dt1.Rows[0]["StaffCount"].ToString();
                Drop_Space.SelectedValue = dt1.Rows[0]["WebSpace"].ToString();
                Drop_Days.SelectedValue = dt1.Rows[0]["DayCount"].ToString();
                Text_Pricing.Text = dt1.Rows[0]["Price"].ToString();
                Radio_Version.SelectedValue = dt1.Rows[0]["Version"].ToString();
                btnSubmit.Text = "Update";
            }
        }
        catch (Exception ex)
        {

        }
    }
    public void bindcomp()
    {
        try
        {
            string ss1 = "select * from Company_Master order by CompanyName";
            DataTable dt1 = db.GetDataTable(ss1);
            Drop_Company.DataSource = dt1;
            Drop_Company.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            if (Drop_Company.SelectedIndex != 0)
            {
                if (Text_Pricing.Text != "")
                {
                    SecurityPermission per = new SecurityPermission();
                    per.CompId = Convert.ToInt32(Drop_Company.SelectedValue);
                    per.Schemes = Drop_Scheme.SelectedValue;
                    per.UserCount = Convert.ToInt32(Text_UserCount.Text);
                    per.StaffCount = Convert.ToInt32(Text_StaffCount.Text);
                    per.WebSpace = Drop_Space.SelectedValue;
                    per.DayCount = Convert.ToInt32(Drop_Days.SelectedValue);
                    per.Price = Convert.ToDecimal(Text_Pricing.Text);
                    per.Version = Radio_Version.SelectedValue;
                    if (Request.QueryString["compid"] != null)
                    {
                        string ss = "update SecurityPermission set Schemes='" + per.Schemes + "',UserCount='" + per.UserCount + "',StaffCount='" + per.StaffCount + "',WebSpace='" + per.WebSpace + "',DayCount='" + per.DayCount + "', Price='" + per.Price + "',Version='" + per.Version + "' where CompId ='" + per.CompId + "'";
                        db.ExecuteCommand(ss);                       
                    }
                    else
                    {
                        per.Insert();
                    }
                }
                else
                {
                    MessageControl1.SetMessage("Enter Price", MessageDisplay.DisplayStyles.Error);
                }
            }
            else
            {
                MessageControl1.SetMessage("Select Company", MessageDisplay.DisplayStyles.Error);
            }
        }
        catch (Exception ex)
        {
            string es = ex.ToString();
        }
    }

        
}
