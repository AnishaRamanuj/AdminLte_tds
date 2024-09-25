using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using JTMSProject;
using System.Web.Security;
using System.Text;
using System.Net.Mail;
using System.Configuration;
using AjaxControlToolkit;
using System.Text.RegularExpressions;
using System.IO;
using System.Collections;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml;
using System.Web.Services;
using System.Management;
using System.Web.Caching;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using Microsoft.ApplicationBlocks1.Data;
using CommonLibrary;
using System.Web.Script.Serialization;

public partial class controls_Add_StaffRecord : System.Web.UI.UserControl
{
    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
    LabelAccess objlabelAccess = new LabelAccess();
    List<tbl_LabelAccess> LtblAccess;
    private readonly DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session["companyid"] != null)
            {
                ViewState["compid"] = Session["companyid"].ToString();
                hdnCompanyid.Value = Session["companyid"].ToString();
            }
            else if (Session["staffid"] != null)
            {
                ViewState["compid"] = Session["cltcomp"].ToString();
                hdnCompanyid.Value = Session["companyid"].ToString();

            }
            if (ViewState["compid"] != null)
            {
                //bindgrid(1, pagesize);
                //bindrole();
                //rolepermission();
                //getrolepermission();
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }

        }
        //txtsrchjob.Attributes.Add("onkeyup", "CountFrmTitle(this,50);");
        //TxtPass.Attributes.Add("onkeyup", "CheckPasswordStrength(this.value);");
        txtjoindate.Text = DateTime.Now.Day + "/" + DateTime.Now.Month + "/" + DateTime.Now.Year;
        txtConfirm.Attributes.Add("onkeyup", "passwordmatch();");
        txtjoindate.Attributes.Add("onkeyup", "CountFrmTitle(this,11);");
        txtenddate.Attributes.Add("onkeyup", "CountFrmTitle(this,11);");
        txtemail.Attributes.Add("onkeyup", "Emailvalid(this);");
        txtjoindate.Attributes.Add("readonly", "readonly");
        txtenddate.Attributes.Add("readonly", "readonly");
        rolepermission();
    }

    private void rolepermission()
    {

        DataSet ds = new DataSet();
        SqlParameter[] param = new SqlParameter[4];
        param[0] = new SqlParameter("@compid", Convert.ToInt32(Session["companyid"].ToString()));
        ds = SqlHelper.ExecuteDataset(conn, CommandType.StoredProcedure, "usp_getrolepermission", param);
        if (ds.Tables[0].Rows.Count > 0)
        {
            if(ds.Tables[0].Rows[0]["rolepermitted"].ToString() == "")
            {
                hidpermitionID.Value = "0";
            }
            else
            {
                hidpermitionID.Value = ds.Tables[0].Rows[0]["rolepermitted"].ToString();
            }
           
        }
    }

    protected void BtnExport_Click(object sender, EventArgs e)
    {
        LabelAccess objlabelAccess = new LabelAccess();
        LtblAccess = objlabelAccess.DAL_getLabeAccessList(Convert.ToInt32(Session["companyid"].ToString()));
        try
        {
            string sql = "select row_number() over(order by s.StaffName asc)as Sr, s.StaffName,rm.Rolename, s.Addr1, s.Addr2, s.Addr3, s.City, s.Mobile,"
                      + " s.Email, dep.DepartmentName, desg.DesignationName, br.BranchName, convert(varchar(10),s.DateOfJoining,103) as DateOfJoining , s.HourlyCharges, s.CurMonthSal, s.username, s.password, Qual, YrGd, YrPG, YrRj,s.staffBioServerid as EMPId "
                       + " FROM dbo.Staff_Master as s LEFT OUTER JOIN tbl_RoleMaster rm on s.Staff_roll =rm.RoleID LEFT OUTER JOIN dbo.Branch_Master as br ON s.BrId = br.BrId LEFT OUTER JOIN dbo.Department_Master as dep ON s.DepId = dep.DepId LEFT OUTER JOIN "
                     + " dbo.Designation_Master  as desg ON s.DsgId = desg.DsgId where s.CompId='" + ViewState["compid"].ToString() + "' and s.IsDeleted<>'True' and s.DateOfLeaving IS NULL order by s.StaffName";
            DataTable dt = db.GetDataTable(sql);

            foreach (DataColumn col in dt.Columns)
            {
                col.ColumnName = changelabel(col.ColumnName);
            }
            if (dt.Rows.Count > 0)
            {
                dt.Columns[17].ColumnName = "Qualification";
                dt.Columns[18].ColumnName = "Yr of Grad";
                dt.Columns[19].ColumnName = "Yr of P. Grad";
                dt.Columns[20].ColumnName = "Date of Re-join";
                dt.AcceptChanges();
                DumpExcel(dt);
            }
            else
            {
                MessageBox.Show("No Records To Export");
            }

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }


    private void DumpExcel(DataTable tbl)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("Staff_Master");

            //Load the datatable into the sheet, starting from cell A1. Print the column names on row 1
            ws.Cells["A1"].LoadFromDataTable(tbl, true);

            //Format the header for column 1-3
            using (ExcelRange rng = ws.Cells["A1:AI1"])
            {
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
            }
            using (var memoryStream = new MemoryStream())
            {
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=Staff.xlsx");
                pck.SaveAs(memoryStream);
                memoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }
    public string changelabel(string ChangeLabel)
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
            throw ex;
        }
        return ChangeLabel;
    }
    //protected void btnpage_Click(object sender, EventArgs e)
    //{

    //    Session["staff"] = hdnStfcode.Value;

    //    Response.Redirect("EditStaffDetails.aspx");
    //}

    protected void btnmember_Click(object sender, EventArgs e)
    {
        try
        {
            MembershipCreateStatus status;
            string mail = txtemail.Text + "- Staff" + hdnCompanyid.Value.ToString();

            Membership.CreateUser(txtusrname.Text, txtConfirm.Text, mail, "question", "answer", true, out status);

            Roles.AddUserToRole(txtusrname.Text, "staff");
            Guid uid = new Guid((Membership.GetUser(txtusrname.Text).ProviderUserKey).ToString());

            string st = "update staff_master set userid = '" + uid + "' where compid = '" + hdnCompanyid.Value + "' and staffcode = '" + hdnnewStaffcode.Value + "'";
            db.ExecuteCommand(st);

            MessageBox.InsertMessage("");
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}