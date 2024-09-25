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

public partial class Admin_ManagePermission : System.Web.UI.Page
{

    private readonly DBAccess db = new DBAccess();

    protected void Page_Load(object sender, EventArgs e)
    {
        //if (Session["companyid"] != null)
        //{
        //    string comp = Session["companyid"].ToString();
        //}
        if (IsPostBack || DropDownList1.Items.Count <= 0) return;
        DropDownList1.SelectedIndex = 0;
        DropDownList1_SelectedIndexChanged(new object(), new EventArgs());
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridViewPairCommission.DataBind();
    }

    protected void ButtonSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            int roleID;
            int.TryParse(DropDownList1.SelectedValue, out roleID);
            db.CommandExecute("DELETE FROM MasterPageAccess WHERE CompID = " + roleID);
            db.CommandExecute("DELETE FROM SubPageAccess WHERE CompID = " + roleID);
            foreach (GridViewRow row in GridViewPairCommission.Rows)
            {
                CheckBox checkBox = row.FindControl("CheckBox1") as CheckBox;
                if (checkBox != null)
                {
                    int masterpageID;
                    int i;
                    if (checkBox.Checked)
                    {
                        i = 1;
                    }
                    else
                    {
                        i = 0;
                    }
                        int.TryParse(checkBox.ValidationGroup, out masterpageID);
                         
                        MasterPageAccess masterPageAccess = new MasterPageAccess();
                        masterPageAccess.SRights = i; 
                        masterPageAccess.CompID = roleID;
                        masterPageAccess.MasterPageID = masterpageID;
                        masterPageAccess.Insert();
                    
                }
                DataList dataList = row.FindControl("DataList1") as DataList;
                if (dataList != null)
                {
                    foreach (DataListItem item in dataList.Items)
                    {
                        checkBox = item.FindControl("CheckBox2") as CheckBox;
                        int i;
                        if (checkBox.Checked)
                        {
                            i = 1;
                        }
                        else
                        {
                            i = 0;
                        }

                        int subpageID;
                        int.TryParse(checkBox.ValidationGroup, out subpageID);

                        SubPageAccess subPageAccess = new SubPageAccess();
                        subPageAccess.CompID = roleID;
                        subPageAccess.SubPageID = subpageID;
                        subPageAccess.SRights = i; 
                        subPageAccess.Insert();
                    }
                }
            }
            GridViewPairCommission.DataBind();
        }
        catch (Exception ex)
        {

        }
    }
}
