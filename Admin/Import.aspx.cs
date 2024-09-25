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

public partial class Admin_Import : System.Web.UI.Page
{
    public string UserType = "";
    public string Filename = "";
    public string XLstr = ""; 
    protected void Page_Load(object sender, EventArgs e)
    {
        //UserType = Session["roleid"].ToString();
        //if (UserType == "admin")
        //{
            //Fup.Enabled = true;
            //Button1.Enabled = true;

        //}
        //else
        //{
        //    Fup.Enabled = false;
        //    Button1.Enabled = false;
        //}
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        if (Fup.PostedFile.FileName != null)
        {
            Filename = Fup.PostedFile.FileName;
            OpenConXL();

        }

    }

    public void OpenConXL()
    {
        XLstr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + Filename + ";Extended Properties=Excel 8.0"; 
        System.Data.OleDb.OleDbConnection xlCon = new System.Data.OleDb.OleDbConnection(XLstr);
        xlCon.Open();
       // Create a Command
        System.Data.OleDb.OleDbCommand xlCommand = new System.Data.OleDb.OleDbCommand("select * from [Sheet1$]", xlCon); 
        // Create a Adaptor
        System.Data.OleDb.OleDbDataAdapter xlAdpt= new System.Data.OleDb.OleDbDataAdapter();
        xlAdpt.SelectCommand = xlCommand;
  
        // Create Dataset
        DataSet xlset= new DataSet() ;
        
        //fill dataset
        xlAdpt.Fill(xlset, "[sheet1$]");

        Grd.DataSource = xlset;
        Grd.DataMember = xlset.Tables[0].ToString();
        int j = xlset.Tables[0].Rows.Count;
        for (int i = 0; i <= j - 1; i++)
        { 
          
        }


    }

}

