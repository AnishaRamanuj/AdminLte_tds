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
    


public partial class Admin_DBconfig : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    //string prevPage = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session["admin"] != null)
            {
                
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

        }
       
    }
    protected void btnsubmit_Click(object sender, EventArgs e)
    {
        if (Session["admin"] != null && ViewState["IsApproved"] != "" && ViewState["username"] != "" && ViewState["password"] != "")
        {
            if (dbtxt.Text !="" && txtip.Text !="" && usertxt.Text !="" && pwdtxt.Text !="")
            {
                string sqlstr1 = "select * from DBConfig where DBName='" + dbtxt.Text + "'";
                DataTable dt1 = db.GetDataTable(sqlstr1);
                if (dt1.Rows.Count != 0 && dt1.Rows.Count!=null)
                {
                    MessageControl1.SetMessage("Duplicate Entry", MessageDisplay.DisplayStyles.Error);
                }            
                else
                {
                    string sqlstr = string.Format("insert into DBConfig(IpAddress,DBUsername,DBPassword,DBName)values('" + txtip.Text + "','" + usertxt.Text + "','" + pwdtxt.Text + "','" + dbtxt.Text + "')");
                    int res = db.ExecuteCommand(sqlstr);
                    if (res == 1)
                    {
                        Clear();
                        MessageControl1.SetMessage("Configuration Added Successfully", MessageDisplay.DisplayStyles.Success);
                    }
                    else
                    {
                        MessageControl1.SetMessage("Configuration Not Added", MessageDisplay.DisplayStyles.Error);
                    }
                }
            }
            else
            {
                MessageControl1.SetMessage("Fill Up All Required Fields", MessageDisplay.DisplayStyles.Error);
            }
        }
    }
    protected void btncancel_Click(object sender, EventArgs e)
    {
        if (Session["admin"] != null)
        {
            Response.Redirect("AdminHome.aspx");
        }
        //Response.Redirect(prevPage);
       
    }
    public void Clear()
    {
        txtip.Text = string.Empty;
        usertxt.Text = string.Empty;
        pwdtxt.Text = string.Empty;
        dbtxt.Text = string.Empty;
    
    }

}
