using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using JTMSProject;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class controls_Invoice_Config : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    //private readonly JobMaster job = new JobMaster();
    private readonly InvoiceConfig inv = new InvoiceConfig();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtprefix.Focus();
        }


    }
    protected void btnsubmit_Click(object sender, EventArgs e)
    {
        try
        {
                 if (txtprefix.Text != "")
                    {
                        inv.Prefix = txtprefix.Text;
                    }
                    else
                    {
                        inv.Prefix = "";
                    }


                 if (txtSuffix.Text != "")
                 {
                     inv.Suffix  = txtSuffix.Text;
                 }
                 else
                 {
                     inv.Suffix = "";
                 }

                    //inv.CompId = 1;
                    

                    if (txtVoucher.Text != "")
                    {
                        inv.VId  = int.Parse(txtVoucher.Text);
                    }
                    else
                    {
                        inv.VId  = 0;
                    }

                    inv.Insert();
                
            }
         catch (Exception ex)
        {

        }
   }
    protected void btnreset_Click(object sender, EventArgs e)
    {
        txtprefix.Text = "";
        txtSuffix.Text = "";
        txtVoucher.Text = "";
        txtprefix.Focus();
    }
}
