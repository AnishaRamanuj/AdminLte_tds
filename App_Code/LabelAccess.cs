using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks1.Data;
using System.Data;
using CommonLibrary;
using System.Web.Script.Serialization;

/// <summary>
/// Summary description for LabelAccess
/// </summary>
public class LabelAccess : CommonLibrary.CommonFunctions
{
    public LabelAccess()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public string DAL_GetLabelNewValues(string companyID)
    {
        string result;

        if (string.IsNullOrEmpty(companyID))
            result = "";
        else
        {
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", companyID);
            using (SqlDataReader drrr = SqlHelper.ExecuteReader(_cnnString, CommandType.StoredProcedure, "usp_GetLabelAccessValues", param))
            {
                List<tbl_LabelAccess> ListLa = new List<tbl_LabelAccess>();
                while (drrr.Read())
                {
                    ListLa.Add(new tbl_LabelAccess()
                    {
                        LabelMasterID = GetValue<int>(drrr["LabelMasterID"].ToString()),
                        LabelName = GetValue<string>(drrr["LabelName"].ToString()),
                        LabelAccessValue = GetValue<string>(drrr["LabelAccessValue"].ToString()),
                    });
                }

                if (ListLa.Count() > 0)
                {
                    IEnumerable<tbl_LabelAccess> tbl = ListLa as IEnumerable<tbl_LabelAccess>;
                    var obbbbb = tbl;
                    result = new JavaScriptSerializer().Serialize(tbl);
                }
                else result = "";
            }
        }

        return result;
    }

    public List<tbl_LabelAccess> DAL_getLabeAccessList(int Company_ID)
    {
        List<tbl_LabelAccess> ListLa = new List<tbl_LabelAccess>();
        SqlParameter[] param = new SqlParameter[1];
        param[0] = new SqlParameter("@compid", Company_ID);
        using (SqlDataReader drrr = SqlHelper.ExecuteReader(_cnnString, CommandType.StoredProcedure, "usp_GetLabelAccessValues", param))
        {

            while (drrr.Read())
            {
                ListLa.Add(new tbl_LabelAccess()
                {
                    LabelMasterID = GetValue<int>(drrr["LabelMasterID"].ToString()),
                    LabelName = GetValue<string>(drrr["LabelName"].ToString()),
                    LabelAccessValue = GetValue<string>(drrr["LabelAccessValue"].ToString()),
                });
            }
        }
        return ListLa;
    }

    public string changelabel(string ChangeLabel, List<tbl_LabelAccess> LtblAccess)
    {
        try
        {
            string s, r;
            foreach (var item in LtblAccess)
            {
                r = item.LabelName;
                s = item.LabelAccessValue;
                ChangeLabel = ChangeLabel.Replace(r, s);
            }
        }
        catch (Exception ex)
        {

        }
        return ChangeLabel;
    }

    public string bindmenu(List<tbl_pagemenumaster> objL)
    {
        string group_menu = "";
        List<tbl_pagemenumaster> ListMenuGroup = objL.GroupBy(test => test.Name.Trim().ToLower()).Select(grp => grp.First()).ToList();
        foreach (var mainitem in ListMenuGroup)
        {
            if (mainitem.Name.Trim().ToLower() == mainitem.Menu_TItle.Trim().ToLower())
            {
                group_menu += "<li><a href=" + mainitem.PageName + ">" +  mainitem.Name.ToString() + "</a>";
            }
            else
            {
                group_menu += "<li><a href=#>" +  mainitem.Name.ToString()  + "<div class='arrow-down'></div></a>";

                var secondlevel = objL.Where(x => x.GROUP_ID == mainitem.GROUP_ID).GroupBy(x => x.SubName.Trim().ToLower()).Select(x => x.FirstOrDefault()).ToList();

                int SecondLevelMenuCount = secondlevel.Count;

                if (SecondLevelMenuCount > 0)
                    group_menu += "<ul id=navMenu >";

                foreach (var layer2 in secondlevel)
                {
                    if (layer2.SubName.Trim().ToLower() == layer2.Menu_TItle.Trim().ToLower())
                    {
                        group_menu += "<li><a href=" + layer2.PageName + ">" +  layer2.Menu_TItle.ToString()  + "</a></li>";
                    }
                    else
                    {
                        group_menu += "<li><a href=#>" +  layer2.SubName.ToString()  + "<div class='arrow-right'></div></a>";

                        /////third  level menu start
                        var thirdLevel = objL.Where(x => x.SubName.Trim().ToLower() == layer2.SubName.Trim().ToLower() && x.GROUP_ID == layer2.GROUP_ID).ToList();

                        if (thirdLevel.Count > 0)
                            group_menu += "<ul id=navMenu >";

                        foreach (var thirdItem in thirdLevel)
                        {
                            group_menu += "<li><a href=" + thirdItem.PageName + ">" +  thirdItem.Menu_TItle.ToString()  + "</a></li>";
                        }


                        if (thirdLevel.Count > 0)
                            group_menu += "</ul>";
                        /////third  level menu END

                        group_menu += "</li>";
                    }
                }

                if (SecondLevelMenuCount > 0)
                    group_menu += "</ul>";
            }
            group_menu += "</li>";

        }
        group_menu = "<ul id=navMenu>" + group_menu + "</ul>";
        return group_menu;
    }
}