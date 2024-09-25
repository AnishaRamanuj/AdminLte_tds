﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class controls_Rolewise_Project_Approver_Allocation : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                hdncompid.Value = Session["companyid"].ToString();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
    }
}