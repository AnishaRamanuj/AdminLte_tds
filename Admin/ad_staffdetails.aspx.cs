using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JTMSProject;
using System.Data;
using System.Globalization;

public partial class Admin_ad_staffdetails : System.Web.UI.Page
{
    private readonly DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["stfid"] != null && Request.QueryString["stfid"] != "")
            {
                bind();
            }
            else
            {
                StaffView.ActiveViewIndex = 0;
            }
        }
    }
    public void bind()
    {
        try
        {
            int cltid = int.Parse(Request.QueryString["stfid"].ToString());
            StaffMaster staff = new StaffMaster(cltid);
            string query = "select *,Designation_Master.DesignationName as desgname,Department_Master.DepartmentName as depname,Branch_Master.BranchName as branch from Staff_Master left join Designation_Master on Staff_Master.DsgId=Designation_Master.DsgId left join Department_Master on Department_Master.DepId=Staff_Master.DepId left join Branch_Master on Branch_Master.BrId=Staff_Master.BrId where Staff_Master.StaffCode='" + Request.QueryString["stfid"].ToString() + "'";
            DataTable dt = db.GetDataTable(query);
            lbldesg.Text = dt.Rows[0]["desgname"].ToString();
            lbldep.Text = dt.Rows[0]["depname"].ToString();
            lblbr.Text = dt.Rows[0]["branch"].ToString();
            Labelcompname.Text = staff.StaffName;
            Labeladdr1.Text = staff.Addr1;
            Labeladdr2.Text = staff.Addr2;
            Labeladdr3.Text = staff.Addr3;
            Labelcharge.Text = staff.HourlyCharges.ToString();
            Labelcity.Text = staff.City;
            Labelphn.Text = staff.Mobile.ToString();
            labelemail.Text = staff.Email;
            labeljoin.Text = staff.DateOfJoining.ToString();
            Labelend.Text = staff.DateOfLeaving.ToString();
            Labelsal.Text = staff.CurMonthSal.ToString();
            StaffView.ActiveViewIndex = 1;
        }
        catch (Exception ex)
        {

        }
    }
    protected void lnkview_Click(object sender, EventArgs e)
    {
        try
        {
            LinkButton lnkview = sender as LinkButton;
            int stf_id;
            int.TryParse(lnkview.CommandArgument.ToString(), out stf_id);
            StaffMaster sfmaster = new StaffMaster(stf_id);
            Labelcompname.Text = sfmaster.StaffName;
            Labeladdr1.Text = sfmaster.Addr1;
            Labeladdr2.Text = sfmaster.Addr2;
            Labeladdr3.Text = sfmaster.Addr3;
            Labelcity.Text = sfmaster.City;
            Labelphn.Text = sfmaster.Mobile;
            labelemail.Text = sfmaster.Email;
            Labelcharge.Text = sfmaster.HourlyCharges.ToString();
            Labelsal.Text = sfmaster.CurMonthSal.ToString();
            DateTime dat = DateTime.Parse(sfmaster.DateOfJoining.ToString());
            //DateTime date = DateTime.ParseExact(dat.ToShortDateString(), "dd/MM/yyyy", null);
            string ss = dat.ToShortDateString();
            if (ss != "1/1/1900")
            {
                //DateTime date = DateTime.ParseExact(ss, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                string[] dd = ss.Split('/');
                labeljoin.Text = dd[1].ToString() + "/" + dd[0].ToString() + "/" + dd[2].ToString();

            }
            dat = DateTime.Parse(sfmaster.DateOfLeaving.ToString());
            ss = dat.ToShortDateString();
            if (ss != "1/1/1900")
            {
                string[] dds = ss.Split('/');
                Labelend.Text = dds[1].ToString() + "/" + dds[0].ToString() + "/" + dds[2].ToString();
            }
            //string dd = labeljoin.Text.ToString("dd/MM/yyyy");

            //Label5.Text = sfmaster.DepId.ToString();
            //Label5.Text = sfmaster.DsgId.ToString();
            //Label5.Text = sfmaster.BrId.ToString();
            StaffView.ActiveViewIndex = 1;
        }
        catch (Exception ex)
        {

        }
    }
    protected void Griddealers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "job")
        {
            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow row = (GridViewRow)btn.NamingContainer;
            int compid = int.Parse(Griddealers.DataKeys[row.RowIndex].Value.ToString());
            Response.Redirect("ad_jobdetails.aspx?job_id="+compid);
        }
    }
}
