using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;

public partial class Admin_superAdmincompanypagesright : System.Web.UI.Page
{
    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    DAL_PagePermissions objDAL_PagePermissions = new DAL_PagePermissions();
    List<pagemenumaster> objL;
    List<string> CheckAddNodes = new List<string>();
    int PLevel = 0;
    bool drp = false;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            bindddlcompany();
            div2.Visible = false;
            btnsubmit.Visible = false;
            btnrestore.Visible = false;
            
        }
    }

    private void BindPermissionTreeView()
    {
        Treegroupadmin.Nodes.Clear();
        Treegroupstaff.Nodes.Clear(); 
       objL = DAL_BindPermissionTreeView(Convert.ToInt32(ddlcompanyname.SelectedValue.ToString()), PLevel);
        if (objL.Count() > 0)
        {
            drp = true;
            hdnLevel.Value = objL[0].CompanyLevel.ToString();  
            drplevel.SelectedValue =   objL[0].CompanyLevel.ToString(); 

            List<pagemenumaster> ListMenuGroup = objL.Where(x => x.PageStatus.ToLower() == "admin" || x.PageStatus.ToLower() == "both").GroupBy(test => test.GROUP_ID).Select(grp => grp.First()).ToList();
            CheckAddNodes = new List<string>();

            BindTreeView(ListMenuGroup, 0, null, Treegroupadmin, "admin", ListMenuGroup.Where(x => x.SelectedPageMenuId > 0).ToList().Count() > 0 ? false : true);
            CheckAddNodes = new List<string>();
            ListMenuGroup = objL.Where(x => x.PageStatus.ToLower() == "staff" || x.PageStatus.ToLower() == "both").GroupBy(test => test.GROUP_ID).Select(grp => grp.First()).ToList();
            BindTreeView(ListMenuGroup, 0, null, Treegroupstaff, "staff", ListMenuGroup.Where(x => x.SelectedStaffPageMenuId > 0).ToList().Count() > 0 ? false : true);
            adminparentnodecheck();
            staffparentnodecheck();
        }
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "MakeStaffSummaryFooterfff", "$(document).ready(function () { onpageload();}); ", true);
    }

    private void BindTreeView(List<pagemenumaster> ListOfMenu, int parentId, TreeNode treeNode, TreeView CurrentTreeView, string status, bool isDefault)
    {
        foreach (var row in ListOfMenu)
        {
            //////////page status for admin pages or staff pages
            if (row.PageStatus.ToLower() == "both" || row.PageStatus.ToLower() == status) { }
            else continue;


            TreeNode child = new TreeNode
            {
                Checked = false,
                Text = parentId == 0 ? row.Name : row.Menu_TItle,
                Value = parentId == 0 ? row.GROUP_ID.ToString() : row.ID.ToString(),
                ToolTip = parentId == 0 ? "Master" : "",
                SelectAction = TreeNodeSelectAction.Expand
            };


            if (parentId == 0)
            {
                ////////////add level menu one
                CurrentTreeView.Nodes.Add(child);
                ///get sub childs
                List<pagemenumaster> ListOfSub = objL.Where(x => x.GROUP_ID == row.GROUP_ID).ToList();
                /////////go for second level menu
                if (ListOfSub.Count > 0)
                {
                    //////if second level menu having sub nodes
                    BindTreeView(ListOfSub.Where(x => x.SubName == "").ToList(), int.Parse(child.Value), child, CurrentTreeView, status, isDefault);
                    //////if second level menu having sub nodes with childs
                    List<pagemenumaster> subsubchild = ListOfSub.Where(x => x.SubName != "").GroupBy(x => x.SubName.ToLower()).Select(grp => grp.First()).ToList();
                    if (subsubchild.Count > 0)
                    {
                        foreach (var subChilditem in subsubchild)
                        {
                            TreeNode child2 = new TreeNode
                            {
                                Checked = false,
                                Text = subChilditem.SubName,
                                Value = parentId == 0 ? subChilditem.GROUP_ID.ToString() : subChilditem.ID.ToString(),
                                ToolTip = "Master",
                                SelectAction = TreeNodeSelectAction.Expand
                            };
                            child.ChildNodes.Add(child2);

                            ///////////////if third level menu is present
                            BindTreeView(ListOfSub.Where(x => x.SubName.ToLower() == subChilditem.SubName.ToLower()).ToList(), int.Parse(child.Value), child2, CurrentTreeView, status, isDefault);
                        }
                    }
                }
            }
            else
            {
                if (isDefault == true && row.default_page == true && status.ToLower() == "admin") child.Checked = true;
                if (isDefault == true && row.defaultstaff_page == true && status.ToLower() == "staff") child.Checked = true;

                if (row.SelectedPageMenuId > 0 && status.ToLower() == "admin")
                    child.Checked = true;

                if (row.SelectedStaffPageMenuId > 0 && status.ToLower() == "staff")
                    child.Checked = true;
                ////////////add level menu two or three
                treeNode.ChildNodes.Add(child);
            }
        }
    }

  

    private void bindddlcompany()
    {
        try
        {
            DataSet ds = new DataSet();
            ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "bindcompany");
            ddlcompanyname.DataSource = ds;
            ddlcompanyname.DataTextField = "CompanyName";
            ddlcompanyname.DataValueField = "compId";
            ddlcompanyname.DataBind();

            ddlcompanyname.Items.Insert(0, new ListItem("Please select company name", "0"));
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage("error....", MessageDisplay.DisplayStyles.Error);
        }
    }

    protected void btnsubmit_Click(object sender, EventArgs e)
    {
        submit();
    }

    protected void ddlcompanyname_SelectedIndexChanged(object sender, EventArgs e)
    {
        Treegroupadmin.Nodes.Clear();
        Treegroupstaff.Nodes.Clear();


        if (ddlcompanyname.SelectedValue == "0")
        {

            div2.Visible = false;
            btnsubmit.Visible = false;
            btnrestore.Visible = false;

        }
        else
        {
            //checkdepttask();
            BindPermissionTreeView();
            div2.Visible = true;
            btnsubmit.Visible = true;
            btnrestore.Visible = true;

        }
    }

  
    private void staffparentnodecheck()
    {
        foreach (TreeNode nodes in Treegroupstaff.Nodes)
        {
            foreach (TreeNode childnode in nodes.ChildNodes)
            {
                if (childnode.Checked == true)
                {
                    nodes.Checked = true;
                }
                foreach (TreeNode childnode1 in childnode.ChildNodes)
                {
                    if (childnode1.Checked == true)
                    {
                        nodes.Checked = true;
                        childnode.Checked = true;
                    }

                }

            }
        }
    }

    private void adminparentnodecheck()
    {
        foreach (TreeNode nodes in Treegroupadmin.Nodes)
        {
            foreach (TreeNode childnode in nodes.ChildNodes)
            {
                if (childnode.Checked == true)
                {
                    nodes.Checked = true;
                }
                foreach (TreeNode childnode1 in childnode.ChildNodes)
                {
                    if (childnode1.Checked == true)
                    {
                        nodes.Checked = true;
                        childnode.Checked = true;
                    }

                }

            }
        }
    }


    protected void btnrestore_Click(object sender, EventArgs e)
    {

        Treegroupadmin.Nodes.Clear();
        Treegroupstaff.Nodes.Clear();
        SqlParameter[] param = new SqlParameter[1];
        param[0] = new SqlParameter("@companyid", ddlcompanyname.SelectedValue);
        SqlHelper.ExecuteNonQuery(con, CommandType.StoredProcedure, "usp_Bootstrap_restoredefault", param);
        BindPermissionTreeView();
        submit();
    }


    public void submit()
    {
        try
        {
            if (drplevel.SelectedValue =="0")
            {
                MessageControl2.SetMessage("Select Level for Company", MessageDisplay.DisplayStyles.Error);
                return;
            } 

            string admin = "";
            string staff = "";
            foreach (TreeNode nodes in Treegroupadmin.CheckedNodes)
            {
                if (nodes.ToolTip != "Master")
                    admin = admin + nodes.Value + ",";
            }
            foreach (TreeNode nodes in Treegroupstaff.CheckedNodes)
            {
                if (nodes.ToolTip != "Master")
                    staff = staff + nodes.Value + ",";
            }

            SqlParameter[] objSqlParameter = new SqlParameter[4];
            objSqlParameter[0] = new SqlParameter("@admin", admin.TrimEnd(','));
            objSqlParameter[1] = new SqlParameter("@staff", staff.TrimEnd(','));
            objSqlParameter[2] = new SqlParameter("@company_id", ddlcompanyname.SelectedValue);
            objSqlParameter[3] = new SqlParameter("@PLevel", drplevel.SelectedValue );

            DataSet ds = SqlHelper.ExecuteDataset(con, CommandType.StoredProcedure, "usp_Bootstrap_insertadminpermission_New", objSqlParameter);
            MessageControl2.SetMessage("Your data saved successfully", MessageDisplay.DisplayStyles.Success);
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }

    }

    protected void drplevel_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (drp == false)
        {
            PLevel = Convert.ToInt16(drplevel.SelectedValue);
            if (PLevel > 0)
            {
                BindPermissionTreeView();
            }
        }
        drp = false;
    }

    public List<pagemenumaster> DAL_BindPermissionTreeView(int compid, int Plevel)
    {

        SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        List<pagemenumaster> LGroupMenu = new List<pagemenumaster>();
        try
        {

            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@Companyid", compid);
            param[1] = new SqlParameter("@Plevel", Plevel);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_Bootstrap_bindtreeview_New", param))
            {
                while (drrr.Read())
                {
                    LGroupMenu.Add(new pagemenumaster()
                    {

                        ID = Convert.ToInt16(drrr["ID"].ToString()),
                        GROUP_ID = Convert.ToInt16(drrr["GROUP_ID"].ToString()),
                        Name = (drrr["name"].ToString()),
                        PageName = (drrr["pagename"].ToString()),
                        PageStatus = (drrr["PageStatus"].ToString()),
                        OrderBy = (drrr["OrderBy"].ToString()),
                        SubMenu = Convert.ToInt16(drrr["submenu"].ToString()),
                        SubName = (drrr["SubName"].ToString()),
                        Groupmenuorderby = Convert.ToInt16(drrr["Groupmenuorderby"].ToString()),
                        Menu_TItle = (drrr["menu_title"].ToString()),
                        SelectedGroupID = Convert.ToInt16(drrr["SelectedGroupID"].ToString()),
                        SelectedPageMenuId = Convert.ToInt16(drrr["SelectedPageMenuId"].ToString()),
                        SelectedStaffGroupID = Convert.ToInt16(drrr["SelectedStaffGroupID"].ToString()),
                        SelectedStaffPageMenuId = Convert.ToInt16(drrr["SelectedStaffPageMenuId"].ToString()),
                        default_page = Convert.ToBoolean(drrr["default_page"].ToString()),
                        defaultstaff_page = Convert.ToBoolean(drrr["defaultstaff_page"].ToString()),
                        CompanyLevel = Convert.ToInt16(drrr["CompanyLevel"].ToString())
                    });
                }
            }
        }
        catch (Exception ex)
        {
            MessageControl2.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
        }
        return LGroupMenu;
    }

    public class pagemenumaster
    {
        public int ID { get; set; }
        public int? GROUP_ID { get; set; }
        public string Menu_TItle { get; set; }
        public string PageName { get; set; }
        public string PageStatus { get; set; }
        public string OrderBy { get; set; }
        public int? SubMenu { get; set; }
        public string SubName { get; set; }
        public string Name { get; set; }
        public int pagemenuid { get; set; }
        public int Groupmenuorderby { get; set; }
        public int SelectedGroupID { get; set; }
        public int SelectedPageMenuId { get; set; }
        public int permissiongroup { get; set; }
        public int permissionpage { get; set; }
        public int SelectedStaffGroupID { get; set; }
        public int SelectedStaffPageMenuId { get; set; }
        public bool default_page { get; set; }
        public int staffgroup { get; set; }
        public int staffpage { get; set; }
        public int staffid { get; set; }
        public bool defaultstaff_page { get; set; }
        public int CompanyLevel { get; set; }
        public string Pageinternalpermission { get; set; }
        public string rolepermission { get; set; }
    }
}



