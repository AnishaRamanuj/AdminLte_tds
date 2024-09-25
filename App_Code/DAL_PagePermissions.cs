using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CommonLibrary;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Data;

/// <summary>
/// Summary description for DAL_PagePermissions
/// </summary>
public class DAL_PagePermissions : CommonFunctions
{
    SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());




    public List<tbl_pagemenumaster> DAL_BindPermissionTreeView(int compid, int Plevel)
    {
        List<tbl_pagemenumaster> LGroupMenu = new List<tbl_pagemenumaster>();
        SqlParameter[] param = new SqlParameter[2];
        param[0] = new SqlParameter("@Companyid", compid);
        param[1] = new SqlParameter("@Plevel", Plevel);
        using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "bindtreeview", param))
        {
            while (drrr.Read())
            {
                LGroupMenu.Add(new tbl_pagemenumaster()
                {

                    ID = GetValue<int>(drrr["ID"].ToString()),
                    GROUP_ID = GetValue<int>(drrr["GROUP_ID"].ToString()),
                    Name = GetValue<string>(drrr["name"].ToString()),
                    PageName = GetValue<string>(drrr["pagename"].ToString()),
                    PageStatus = GetValue<string>(drrr["PageStatus"].ToString()),
                    OrderBy = GetValue<string>(drrr["OrderBy"].ToString()),
                    SubMenu = GetValue<int>(drrr["submenu"].ToString()),
                    SubName = GetValue<string>(drrr["SubName"].ToString()),
                    Groupmenuorderby = GetValue<int>(drrr["Groupmenuorderby"].ToString()),
                    Menu_TItle = GetValue<string>(drrr["menu_title"].ToString()),
                    SelectedGroupID = GetValue<int>(drrr["SelectedGroupID"].ToString()),
                    SelectedPageMenuId = GetValue<int>(drrr["SelectedPageMenuId"].ToString()),
                    SelectedStaffGroupID = GetValue<int>(drrr["SelectedStaffGroupID"].ToString()),
                    SelectedStaffPageMenuId = GetValue<int>(drrr["SelectedStaffPageMenuId"].ToString()),
                    default_page = GetValue<bool>(drrr["default_page"].ToString()),
                    defaultstaff_page = GetValue<bool>(drrr["defaultstaff_page"].ToString()),
                    CompanyLevel = GetValue<int>(drrr["CompanyLevel"].ToString())
                });
            }
        }
        return LGroupMenu;
    }

    public string Dal_getRolepermission(int pageid, int roleid, int compid)
    {
        string permission;
        permission = "";
        SqlParameter[] param = new SqlParameter[3];
        param[0] = new SqlParameter("@compid", compid);
        param[1] = new SqlParameter("@pageid", pageid);
        param[2] = new SqlParameter("@roleid", roleid);
        DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_getRoles", param);
        if (ds.Tables[0].Rows.Count > 0)
        {
            permission = ds.Tables[0].Rows[0]["Pageinternalpermission"].ToString();
        }
        return permission;
    }

    public string Dal_getLinks(int compid)
    {
        string Link_JobnTask;
        SqlParameter[] param = new SqlParameter[1];
        param[0] = new SqlParameter("@compid", compid);
        DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_getLinks", param);
        Link_JobnTask = "0";
        if (Convert.ToInt16(ds.Tables[0].Rows.Count) > 0)
        {
            Link_JobnTask = ds.Tables[0].Rows[0]["Link_JobnTask"].ToString();
        }
        return Link_JobnTask;
    }


    public string Dal_getTasknJobLinks(int compid)
    {
        string Link_JobnTask;
        SqlParameter[] param = new SqlParameter[1];
        param[0] = new SqlParameter("@compid", compid);
        DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_getTasknJobLinks", param);
        Link_JobnTask = "0";
        if (Convert.ToInt16(ds.Tables[0].Rows.Count) > 0)
        {
            Link_JobnTask = ds.Tables[0].Rows[0]["Task_JobLink"].ToString();
        }
        return Link_JobnTask;
    }

    public List<tbl_pagemenumaster> dal_bindmenu(int p)
    {
        List<tbl_pagemenumaster> menulist = new List<tbl_pagemenumaster>();
        SqlParameter[] param = new SqlParameter[1];
        param[0] = new SqlParameter("@Companyid", p);
      //  DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "bindmenu", param);
        using (SqlDataReader sdr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "bindmenu", param))
        {
            while (sdr.Read())
            {
                menulist.Add(new tbl_pagemenumaster()
                {
                    SubName = GetValue<string>(sdr["SubName"].ToString()),
                    GROUP_ID = GetValue<int>(sdr["GROUP_ID"].ToString()),
                    Name = GetValue<string>(sdr["name"].ToString()),
                    PageName = GetValue<string>(sdr["pagename"].ToString()),
                    Menu_TItle = GetValue<string>(sdr["menu_title"].ToString()),
                });
            }
        }
        return menulist;
    }





    public List<tbl_pagemenumaster> dal_staffmenu(int p, int c)
    {
        List<tbl_pagemenumaster> staffmenulist = new List<tbl_pagemenumaster>();
        SqlParameter[] param = new SqlParameter[2];
        param[0] = new SqlParameter("@staffcode", p);
        param[1] = new SqlParameter("@companyID", c);
        DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "bindmenustaff", param);
        using (SqlDataReader sdr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "bindmenustaff", param))
        {
            while (sdr.Read())
            {
                staffmenulist.Add(new tbl_pagemenumaster()
                {
                    SubName = GetValue<string>(sdr["SubName"].ToString()),
                    GROUP_ID = GetValue<int>(sdr["GROUP_ID"].ToString()),
                    Name = GetValue<string>(sdr["name"].ToString()),
                    PageName = GetValue<string>(sdr["pagename"].ToString()),
                    Menu_TItle = GetValue<string>(sdr["menu_title"].ToString()),
                });
            }
            return staffmenulist;
        }


    }

    public List<tbl_pagemenumaster> DAL_BindPermissionTreeView1(int compid)
    {
        List<tbl_pagemenumaster> LGroupMenu = new List<tbl_pagemenumaster>();
        SqlParameter[] param = new SqlParameter[1];
        param[0] = new SqlParameter("@Companyid", compid);
        using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "bindstafftreeview", param))
        {
            while (drrr.Read())
            {
                LGroupMenu.Add(new tbl_pagemenumaster()
                {
                    pagemenuid = GetValue<int>(drrr["PageMenuID"].ToString()),
                    GROUP_ID = GetValue<int>(drrr["GROUP_ID"].ToString()),
                    Name = GetValue<string>(drrr["name"].ToString()),
                    PageName = GetValue<string>(drrr["pagename"].ToString()),
                    SubMenu = GetValue<int>(drrr["submenu"].ToString()),
                    SubName = GetValue<string>(drrr["SubName"].ToString()),


                    Menu_TItle = GetValue<string>(drrr["menu_title"].ToString()),
                    ID = GetValue<int>(drrr["ID"].ToString()),

                });
            }
        }
        return LGroupMenu;


    }



    public List<tbl_pagemenumaster> DAL_cxhecktree(int p)
    {
        List<tbl_pagemenumaster> LGroupMenu = new List<tbl_pagemenumaster>();
        SqlParameter[] param = new SqlParameter[1];
        param[0] = new SqlParameter("@staffid", p);

        using (SqlDataReader drrr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "staffpermission", param))
        {
            while (drrr.Read())
            {
                LGroupMenu.Add(new tbl_pagemenumaster()
                {
                    pagemenuid = GetValue<int>(drrr["PageMenuID"].ToString()),

                });
            }
        }
        return LGroupMenu;

    }

    public bool DAL_getpermission(string PermissionString, string CompareString)
    {
        bool res = true;
        foreach (var item in PermissionString.ToLower().Split(';'))
        {
            string[] curritem = item.Split('=');
            if (curritem[0].ToLower() == CompareString.ToLower().Trim())
            {
                res = Convert.ToBoolean(curritem[1]);
                break;
            }
        }
        return res;
    }


    public bool getdepartmentwise(int p)
    {
        bool dept = false;
        SqlParameter[] param = new SqlParameter[1];
        param[0] = new SqlParameter("@compid", p);
        DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_getdepartmentwise", param);

        if (ds != null)
        {
            if (ds.Tables[0].Rows.Count > 0)
            {
                dept = Convert.ToBoolean(ds.Tables[0].Rows[0]["deptwise"]);
            }
        }
        return dept;
    }

    public  bool getexpense(int cmp)
    {
        SqlParameter[] param = new SqlParameter[1];
        param[0] = new SqlParameter("@compid", cmp);

        DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_getExpense", param);
        bool expense = true;
        if (ds != null)
        {
            if (ds.Tables[0].Rows.Count > 0)
            {
                expense = Convert.ToBoolean(ds.Tables[0].Rows[0]["Expense_mandatory"]);
            }
        }
        return expense;


    }

    public string  getimagelogo(int p)
    {
        string strlogo="";
        SqlParameter[] param = new SqlParameter[1];
        param[0] = new SqlParameter("@compid", p);
        DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_getcomplogo", param);
        if (ds.Tables[0].Rows.Count > 0)
        {
            strlogo = ds.Tables[0].Rows[0]["imagepath"].ToString();
        }
        return strlogo;
        
    }

    public string Dal_getPronClt(int compid)
    {
        string Link_Pronclt;
        SqlParameter[] param = new SqlParameter[1];
        param[0] = new SqlParameter("@compid", compid);
        DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "usp_Bootstrap_GetCompanyDetails", param);
        Link_Pronclt = "0";
        if (Convert.ToInt16(ds.Tables[0].Rows.Count) > 0)
        {
            Link_Pronclt = ds.Tables[0].Rows[0]["ProjectnClient"].ToString();

        }
        return Link_Pronclt;
    }
}





