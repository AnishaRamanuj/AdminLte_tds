using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;
using DataAccessLayer;
using Microsoft.ApplicationBlocks1.Data;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using CommonLibrary;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class controls_XL_Upload : System.Web.UI.UserControl
{
    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    public static CultureInfo ci = new CultureInfo("en-GB");
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
            {
            if (Session["companyid"] != null)
            {
                hdnCompid.Value = Session["companyid"].ToString();
                ViewState["compid"] = Session["companyid"].ToString();
            }
        }

    }


    //protected void BtnUpload_Click(object sender, EventArgs e)
 

}