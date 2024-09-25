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

public partial class Admin_ad_editclient : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    private readonly ClientMaster client = new ClientMaster();
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            if (Session["admin"] != null)
            {
                //if (Session["clientid"] != null)
                //{
                bindcomp();
                bindclgroup();
                bind_edit();
                //}
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

        }
        txtZip.Attributes.Add("onkeyup", "return  ValidateText(this);");
        //txtpin.Attributes.Add("onkeyup", "return  ValidateText(this);");
        txtclientname.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtaddr1.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtaddr2.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtaddr3.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        //txtpin.Attributes.Add("onkeyup", "CountFrmTitle(this,10);");
        txtPhone.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtcontmob.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtfax.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        Texweb.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtcontemail.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        //txtcontmobile.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        txtcontperson.Attributes.Add("onkeyup", "CountFrmTitle(this,70);");
        txtclientname.Focus();
    }
    public void bindclgroup()
    {
        try
        {
            string ss = "select * from ClientGroup_Master where CompId='" + drpcompany.SelectedValue + "' order by ClientGroupName";
            DataTable dt = db.GetDataTable(ss);
            drpclientgroup.DataSource = dt;
            drpclientgroup.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    public void bindcomp()
    {
        try
        {
            string ss = "select * from Company_Master order by CompanyName";
            DataTable dt = db.GetDataTable(ss);
            drpcompany.DataSource = dt;
            drpcompany.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
    public void bind_edit()
    {
        try
        {
            DataTable dt = new DataTable();
            string sqlqry = "select * from Client_Master where CLTId='" + int.Parse(Session["cltid"].ToString()) + "' order by ClientName";
            dt = db.GetDataTable(sqlqry);
            if (dt != null)
            {
                if (dt.Rows.Count > 0)
                {

                    if (drpcompany.Items.FindByValue(dt.Rows[0]["CompId"].ToString()) != null)
                    {
                        drpcompany.SelectedValue = dt.Rows[0]["CompId"].ToString();
                    }
                    else
                    {
                        drpcompany.SelectedValue = "1";

                    }
                    ViewState["date"] = dt.Rows[0]["CreationDate"].ToString();
                    ViewState["username"] = dt.Rows[0]["username"].ToString();
                    ViewState["password"] = dt.Rows[0]["password"].ToString();
                    ViewState["Role"] = dt.Rows[0]["Role"].ToString();
                    ViewState["IsApproved"] = dt.Rows[0]["IsApproved"].ToString();
                    ViewState["UserId"] = dt.Rows[0]["UserId"].ToString();
                    txtclientname.Text = dt.Rows[0]["ClientName"].ToString();
                    txtaddr1.Text = dt.Rows[0]["Address1"].ToString();
                    txtaddr2.Text = dt.Rows[0]["Address2"].ToString();
                    txtaddr3.Text = dt.Rows[0]["Address3"].ToString();
                    txtPhone.Text = dt.Rows[0]["BusPhone"].ToString();
                    txtcity.Text = dt.Rows[0]["City"].ToString();
                    txtZip.Text = dt.Rows[0]["Pin"].ToString();
                    txtcountry.Text = dt.Rows[0]["Country"].ToString();
                    txtfax.Text = dt.Rows[0]["BusFax"].ToString();
                    Texweb.Text = dt.Rows[0]["Website"].ToString();
                    //if (dt.Rows[0]["Partner"].ToString() != null)
                    //{
                    //    if (dt.Rows[0]["Partner"].ToString() == "True")
                    //    {
                    //        CheckBox1.Checked = true;
                    //    }
                    //    else if (dt.Rows[0]["Partner"].ToString() == "False")
                    //    {
                    //        CheckBox2.Checked = true;
                    //    }
                    //}
                    if (drpclientgroup.Items.FindByValue(dt.Rows[0]["CTGId"].ToString()) != null)
                    {
                        drpclientgroup.SelectedValue = dt.Rows[0]["CTGId"].ToString();
                    }
                    else
                    {
                        drpclientgroup.SelectedValue = "1";
                    }
                    txtcontperson.Text = dt.Rows[0]["ContPerson"].ToString();
                    txtcontmob.Text = dt.Rows[0]["ContMob"].ToString();
                    txtcontemail.Text = dt.Rows[0]["ContEmail"].ToString();

                }

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
            Response.Redirect("ad_Manageclient.aspx");
        }
        //else if (Session["clientid"] != null)
        //{
        //    Response.Redirect("~/client/ClientHome.aspx");
        //}
    }
    protected void btnupdate_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["admin"] != null && ViewState["IsApproved"] != "" && ViewState["username"] != "" && ViewState["password"] != "")
            {
                if (txtZip.Text != "" && txtclientname.Text != "" && txtcontemail.Text != "")
                {
                    if (websValid(Texweb.Text))
                    {
                        if (emailValid(txtcontemail.Text))
                        {
                            client.CompId = int.Parse(drpcompany.SelectedValue);
                            client.CLTId = int.Parse(Session["cltid"].ToString());
                            client.username = ViewState["username"].ToString();
                            client.password = ViewState["password"].ToString();
                            client.Role = ViewState["Role"].ToString();
                            client.IsApproved = bool.Parse(ViewState["IsApproved"].ToString());
                            Guid uid = new Guid(ViewState["UserId"].ToString());
                            client.UserId = uid;
                            client.ClientName = txtclientname.Text;
                            client.Address1 = txtaddr1.Text;
                            client.Address2 = txtaddr2.Text;
                            client.Address3 = txtaddr3.Text;
                            client.City = txtcity.Text;
                            client.Country = txtcountry.Text;
                            client.BusFax = txtfax.Text;
                            client.BusPhone = txtPhone.Text;
                            client.Pin = txtZip.Text;
                            client.Website = Texweb.Text;
                            client.CreationDate = DateTime.Parse(ViewState["date"].ToString());
                            //if (CheckBox1.Checked == true)
                            //{
                            //    client.Partner = "True";
                            //}
                            //else if (CheckBox2.Checked == true)
                            //{
                            client.Partner = "False";
                            //}
                            //else
                            //{
                            //    client.Partner = "False";
                            //}
                            client.ContPerson = txtcontperson.Text;
                            client.ContMob = txtcontmob.Text;
                            client.ContEmail = txtcontemail.Text;
                            if (drpclientgroup.SelectedValue != "")
                            {
                                client.CTGId = int.Parse(drpclientgroup.SelectedValue);
                            }
                            else
                            {
                                client.CTGId = 0;
                            }
                            int res = client.Update();
                            if (res == 1)
                                //if (Session["admin"] != null)
                                //{
                                //    Response.Redirect("~/Admin/ClientDetails.aspx?id=" + Session["clientid"].ToString() + "&username=" + Session["clientname"].ToString());
                                //}
                                //else if (Session["clientid"] != null)
                                //{
                                Response.Redirect("ad_Manageclient.aspx");
                            //}
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
                        MessageControl1.SetMessage("Invalid web address", MessageDisplay.DisplayStyles.Error);
                    }
                }
                else
                {
                    MessageControl1.SetMessage("Mandatory Fields Must be Filled", MessageDisplay.DisplayStyles.Error);

                }
            }
            else
            {
                MessageControl1.SetMessage("Error!!!session Expired", MessageDisplay.DisplayStyles.Error);

            }
        }
        catch (Exception ex)
        {

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
    //protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    //{
    //    CheckBox1.Checked = true;
    //    CheckBox2.Checked = false;
    //}
    //protected void CheckBox2_CheckedChanged(object sender, EventArgs e)
    //{
    //    CheckBox1.Checked = false;
    //    CheckBox2.Checked = true;
    //}
    protected void drpcompany_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindclgroup();
        
    }
}
