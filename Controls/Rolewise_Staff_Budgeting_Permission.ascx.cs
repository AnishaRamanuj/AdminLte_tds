﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JTMSProject;
public partial class controls_Rolewise_Staff_Budgeting_Permission : System.Web.UI.UserControl
{
    private readonly DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                hdncompid.Value = Session["companyid"].ToString();
                hdnIP.Value = Session["IP"].ToString();
                hdnName.Value = Session["fulname"].ToString();
                hdnUser.Value = Session["usertype"].ToString();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
    }
}