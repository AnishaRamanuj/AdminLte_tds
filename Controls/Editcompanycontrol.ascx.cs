using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JTMSProject;
using System.Text;
using System.Text.RegularExpressions;

public partial class controls_Editcompanycontrol : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    private readonly CompanyMaster comp = new CompanyMaster();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                //if (Session["dealerid"] != null)
                //{
                    bind_edit();
               // }
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
           
        }
        txtcompname.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtaddr1.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtaddr2.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtaddr3.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtZip.Attributes.Add("onkeyup", "CountFrmTitle(this,10);");
        txtPhone.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        Txtemail.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        Texweb.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtcity.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtcompname.Focus();
    }
    public void bind_edit()
    {
        try
        {
            DataTable dt = new DataTable();
            string sqlqry = "select * from Company_Master where CompId='" + int.Parse(Session["companyid"].ToString()) + "' order by CompanyName";
            dt = db.GetDataTable(sqlqry);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {
                    ViewState["username"] = dt.Rows[0]["username"].ToString();
                    ViewState["Password"] = dt.Rows[0]["password"].ToString();
                    ViewState["Role"] = dt.Rows[0]["Role"].ToString();
                    ViewState["IsApproved"] = dt.Rows[0]["IsApproved"].ToString();
                    ViewState["UserId"] = dt.Rows[0]["UserId"].ToString();
                    ViewState["date"] = dt.Rows[0]["CreatedDate"].ToString();
                    // Session["comp"] = dt.Rows[0]["CompId"].ToString();
                    txtcompname.Text = dt.Rows[0]["CompanyName"].ToString();
                    txtaddr1.Text = dt.Rows[0]["Address1"].ToString();
                    txtaddr2.Text = dt.Rows[0]["Address2"].ToString();
                    txtaddr3.Text = dt.Rows[0]["Address3"].ToString();
                    txtPhone.Text = dt.Rows[0]["Phone"].ToString();
                    txtcity.Text = dt.Rows[0]["City"].ToString();
                    txtZip.Text = dt.Rows[0]["Pin"].ToString();
                    Txtemail.Text = dt.Rows[0]["Email"].ToString();
                    Texweb.Text = dt.Rows[0]["Website"].ToString();
                }

            }
        }
        catch (Exception ex)
        {

        }
    }

    protected void btnupdate_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["companyid"] != null)
            {
                if (txtcompname.Text != "" && Txtemail.Text != "")
                {

                    if (websValid(Texweb.Text))
                    {
                        if (emailValid(Txtemail.Text))
                        {
                            comp.CompId = int.Parse(Session["companyid"].ToString());
                            comp.CompanyName = txtcompname.Text;
                            comp.Address1 = txtaddr1.Text;
                            comp.Address2 = txtaddr2.Text;
                            comp.Address3 = txtaddr3.Text;
                            comp.City = txtcity.Text;
                            comp.Email = Txtemail.Text;
                            comp.Phone = txtPhone.Text;
                            comp.Pin = txtZip.Text;
                            comp.FirstName = "";
                            comp.LastName = "";
                            comp.Website = Texweb.Text;
                            comp.CreatedDate = DateTime.Parse(ViewState["date"].ToString());
                            comp.Role = ViewState["Role"].ToString();
                            comp.IsApproved = bool.Parse(ViewState["IsApproved"].ToString());
                            Guid uid = new Guid(ViewState["UserId"].ToString());
                            comp.UserId = uid;
                            comp.username = ViewState["username"].ToString();
                            comp.password = ViewState["Password"].ToString().Trim();
                            int res = comp.Update();
                            if (res == 1)
                                if (Session["admin"] != null)
                                {
                                    Response.Redirect("~/Admin/CompanyDetails.aspx?id=" + Session["companyid"].ToString() + "&username=" + Session["companyname"].ToString());
                                }
                                else if (Session["companyid"] != null)
                                {
                                    Response.Redirect("~/Company/CompanyHome.aspx");
                                }
                                else
                                    MessageControl1.SetMessage("Updation not Completed", MessageDisplay.DisplayStyles.Error);
                        }
                        else
                        {
                            MessageControl1.SetMessage("Invalid Email ID", MessageDisplay.DisplayStyles.Error);
                        }
                    }
                    else
                    {
                        MessageControl1.SetMessage("Invalid web address.Please use http:// before your address", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl1.SetMessage("Mandatory Fields Must be Filled", MessageDisplay.DisplayStyles.Error);

                }
            }
            else
            {
                MessageControl1.SetMessage("Error!!!Session Expired", MessageDisplay.DisplayStyles.Error);

            }
        }
        catch (Exception ex)
        {

        }
    }
    protected void btncancel_Click(object sender, EventArgs e)
    {
        if (Session["admin"] != null)
        {
            Response.Redirect("~/Admin/CompanyDetails.aspx?id=" + Session["companyid"].ToString() + "&username=" + Session["companyname"].ToString());
        }
    }
    public bool emailValid(string email)
    {
        if (email != "")
        {
            string pattern = @"^[a-z][a-z|0-9|]*([_][a-z|0-9]+)*([.][a-z|0-9]+([_][a-z|0-9]+)*)?@[a-z][a-z|0-9|]*\.([a-z][a-z|0-9]*(\.[a-z][a-z|0-9]*)?)$";


            System.Text.RegularExpressions.Match match = Regex.Match(email.Trim(), pattern, RegexOptions.IgnoreCase);
            if (match.Success)
            {
                //string b = "true";
                //return b;
                return true;
            }
            else
            {
                //string b = "false";
                //return b;
                return false;
            }
        }
        else
        {
            return true;
        }
    }
    public bool websValid(string web)
    {
        if (web != "")
        {
            //System.Globalization.CompareInfo cmpUrl = System.Globalization.CultureInfo.InvariantCulture.CompareInfo;
            //if (cmpUrl.IsPrefix(web, "http://") == false)
            //{
            //    web = "http://" + web;
            //}
            string pattern = @"^http\://(\S*)?$";


            System.Text.RegularExpressions.Match match = Regex.Match(web.Trim(), pattern, RegexOptions.IgnoreCase);
            if (match.Success)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return true;
        }
    }
}
