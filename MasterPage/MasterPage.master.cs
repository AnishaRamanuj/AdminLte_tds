using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.ApplicationBlocks1.Data;
using System.Data.SqlClient;
using System.Data;
using CommonLibrary;
using System.Web.Script.Serialization;
using JTMSProject;

public partial class MasterPage_MasterPage : System.Web.UI.MasterPage
{
    LabelAccess objlabelAccess = new LabelAccess();
    private readonly DBAccess db = new DBAccess();
    protected void Page_Load(object sender, EventArgs e)
    {
        //string s = Request.QueryString["id"];

        //if (!Page.IsPostBack)
        //{

            try
            {
                if (Session["companyid"] == null)
                {
                    Response.Redirect("~/Default.aspx");
                }
                hdnCompanyid.Value = Session["companyid"].ToString();
                //Session["Name"].ToString();

                string usr = Session["usertype"].ToString();
                if (usr == "company")
                {
                    hdnRole.Value = "Admin";
                    hdnLoginDetails.Value = (Session["fulname"].ToString() + "~" + Session["Name"].ToString());
                    hdnStaffQuta.Value = Session["StaffQuta"].ToString();
                    hdnStaffActive.Value = Session["StaffActive"].ToString();
                    hdnRemaining.Value = Session["DaysRemaining"].ToString();
                }
                else
                {
                    hdnRole.Value = "Staff";
                    hdnLoginDetails.Value = (Session["CompanyName"].ToString() + "~" + Session["fulname"].ToString());
                string queryImage = "SELECT ImageId, ImagePath  FROM tbl_Staff_Image  WHERE StaffCode = '" + Session["staffid"].ToString() + "'";
                DataTable dtImage = db.GetDataTable(queryImage);
                hdnStaffDBImage.Value = dtImage.Rows[0]["ImagePath"].ToString();
            }

                int roleid = Convert.ToInt32(Session["companyid"].ToString());
                hdnLabelValues.Value = objlabelAccess.DAL_GetLabelNewValues(Session["companyid"].ToString());


            }
            catch (Exception ex)
            {

            }
        //}
        GetLogo();
        GetMenuDetails();
        getCompanyPermissions();
    }


    protected void lnkusrname_Click(object sender, EventArgs e)
    {
        if (Session["companyid"] != null)
        {
            Response.Redirect("~/Company/CompanyHome1.aspx");
        }
    }


    protected void lnklogin_Click(object sender, EventArgs e)
    {
        HttpContext.Current.Response.Cookies.Add(new HttpCookie("tmxuserInfo", ""));
		
        if (Session["admin"] != null)
        {
            Session.Abandon();
            Session["admin"] = null;
            Response.Redirect("~/Default.aspx");
        }
        else if (Session["companyid"] != null)
        {
            Session.Abandon();
            Session["companyid"] = null;
            Response.Redirect("~/Default.aspx");
        }
        else
        {
            Response.Redirect("~/Default.aspx");
        }
    }


    public void GetMenuDetails()
    {
        //DAL_Menu objDAL_Menu = new DAL_Menu();
        List<menumaster> objL;
        string group_menu = "";

            string usr = Session["usertype"].ToString();
            if (usr == "company")
            {

                // objL = objDAL_PagePermissions.dal_bindmenu(Convert.ToInt32(Session["companyid"]));
                objL = dal_bindmenu(Convert.ToInt32(Session["companyid"]));
                group_menu = "<ul id=navMenu><li><a href=#>Permissions Not Allocated</a></li></ul>";
                if (objL.Count > 0)
                {

                    //group_menu = objlabelAccess.bindmenu(objL);
                    group_menu = bindmenu(objL);
                }
            }
            else
            {

                ////objL = objDAL_PagePermissions.dal_staffmenu(Convert.ToInt32(Session["staffid"].ToString()), Convert.ToInt32(Session["companyid"].ToString()));
                objL = dal_staffmenu(Convert.ToInt32(Session["staffid"].ToString()), Convert.ToInt32(Session["companyid"].ToString()));
                group_menu = "<ul id=navMenu><li><a href=#>Permissions Not Allocated</a></li></ul>";
                if (objL.Count > 0)
                {

                    // group_menu = objlabelAccess.bindmenu(objL);
                    group_menu = bindmenu(objL);
                }
            }
        
        //group_menu = "<ul id=navMenu><li><a href=Dashboard.aspx>Dashboard</a></li><li><a href=#>Masters<div class='arrow-down'></div></a><ul id=navMenu ><li><a href=AddRecords.aspx>Designation</a></li><li><a href=AddRecordsDep.aspx>Department</a></li><li><a href=AddRecordsBR.aspx>Branch</a></li><li><a href=ManageClient.aspx>Client</a></li><li><a href=Add_StaffRecord.aspx>Staff Master</a></li><li><a href=AddRecordsJN.aspx>Activity</a></li><li><a href=Add_Projects.aspx>Project</a></li><li><a href=AddRecordsOpe.aspx>Expense</a></li><li><a href=AddRecordsLoc.aspx>Location</a></li><li><a href=Manage_Holiday.aspx>Holiday</a></li><li><a href=ManageLeaveMaster_Daywise.aspx>Leave Master Daywise</a></li><li><a href=ManageLeaveMaster.aspx>Leave Master</a></li></ul></li><li><a href=#>Allocations<div class='arrow-down'></div></a><ul id=navMenu ><li><a href=AddAssignments.aspx>Assign Activity With Department</a></li><li><a href=Manage_JobAllocation.aspx>WBS Allocations</a></li><li><a href=StaffJobAllocation.aspx>Staffwise Allocation</a></li><li><a href=Rolewise_Staff_Approver_Allocation.aspx>Allocate Approver</a></li><li><a href=Manage_LeaveAllocation_Daywise.aspx>Leave Allocation Daywise</a></li><li><a href=Manage_LeaveAllocation.aspx>Leave Allocation</a></li><li><a href=LeaveApprover.aspx>Leave Approver</a></li></ul></li><li><a href=#>Timesheet & Leave<div class='arrow-down'></div></a><ul id=navMenu ><li><a href=Admin_Viewer.aspx>Admin Viewer</a></li><li><a href=#>Leave Management<div class='arrow-right'></div></a><ul id=navMenu ><li><a href=Leave_Application.aspx>Leave Application</a></li><li><a href=Leave_Application_Daywise.aspx>Leave Application Daywise</a></li><li><a href=Leave_Sanction.aspx>Leave Sanction</a></li><li><a href=Leave_Sanction_Daywise.aspx>Leave Sanction Daywise</a></li></ul></li><li><a href=TFStatusMaster.aspx>Project Status</a></li></ul></li><li><a href=#>Invoice & Reciept<div class='arrow-down'></div></a><ul id=navMenu ><li><a href=Invoice_page.aspx>Invoice</a></li><li><a href=Receipt_page.aspx>Reciepts</a></li></ul></li><li><a href=#>Resource Planning<div class='arrow-down'></div></a><ul id=navMenu ><li><a href=Expired_ProjectJob.aspx>Ending Project / WBS</a></li><li><a href=Project_Audit.aspx>Project Audit</a></li><li><a href=ProjectDetails.aspx>Project Cost</a></li></ul></li><li><a href=#>Reports<div class='arrow-down'></div></a><ul id=navMenu ><li><a href=#>Report<div class='arrow-right'></div></a><ul id=navMenu ><li><a href=Report_LeaveBalance.aspx>Leave Balance</a></li></ul></li><li><a href=#>Staff Report<div class='arrow-right'></div></a><ul id=navMenu ><li><a href=StaffAttendance.aspx>Attendance</a></li><li><a href=Report_Staff_Columnar_Summary.aspx>Staff Columnar Summary</a></li><li><a href=Staff_TimeSheet_Sumary.aspx>Timesheet Summary</a></li><li><a href=Staff_List.aspx>Staff List</a></li><li><a href=Staff_AllClientAllExpenses.aspx>Clientwise Expenses</a></li><li><a href=Department_List.aspx>Departmentwise List</a></li><li><a href=Allstaff_Columnar_MonthlyTimesheet_Summary.aspx>Columnar Month Summary</a></li><li><a href=All_Staff_Client_Project_Columnar.aspx>All Staff Client Project Columnar</a></li><li><a href=Report_Staff_ProjectwiseHours.aspx>Staff Projectwise Hours Report</a></li><li><a href=StaffwiseBillableNonBillableReport.aspx>Staff Billable/Non Billable Report</a></li></ul></li><li><a href=#>Client Report<div class='arrow-right'></div></a><ul id=navMenu ><li><a href=Report_Client_StaffHours.aspx>Client Staffwise Hours Report</a></li><li><a href=ClientGroup_AllStaff.aspx>Client Group All Staff</a></li><li><a href=Client_List.aspx>Client List</a></li><li><a href=ClientGroup_AllStaff_ReportDetailed.aspx>Client Group Details</a></li><li><a href=Report_ClientWiseSummryDetails.aspx>Client Wise Report</a></li></ul></li><li><a href=#>Department Report<div class='arrow-right'></div></a><ul id=navMenu ><li><a href=Report_DepartmentWiseSummary.aspx>Department Wise</a></li><li><a href=Report_Dept_Desg_Summary.aspx>Department & Designation Wise</a></li><li><a href=All_department_Client_Project_Summerise.aspx>All Department Client Project</a></li><li><a href=All_Department_Client_Staff_Report.aspx>Departmentwise Project Costing</a></li></ul></li><li><a href=#>Expense Report<div class='arrow-right'></div></a><ul id=navMenu ><li><a href=ReportStaffExpense.aspx>Staff Expense</a></li><li><a href=Expense_Allclients.aspx>All Clients</a></li><li><a href=ExpenseReport.aspx>Project Activity Report</a></li><li><a href=ReportProjectWiseStaffExpense.aspx>Projectwise Expense Report</a></li></ul></li><li><a href=#>Graph Report<div class='arrow-right'></div></a><ul id=navMenu ><li><a href=Team_strengthnHours.aspx>Project Report</a></li><li><a href=Staffwise_Report.aspx>Staff Report</a></li><li><a href=Clientwise_Grp.aspx>Client Report</a></li></ul></li><li><a href=#>MIS Report<div class='arrow-right'></div></a><ul id=navMenu ><li><a href=ApproverList.aspx>Staff Approver Details</a></li><li><a href=OngoingProjectList.aspx>Ongoing Project Report</a></li><li><a href=StaffDetails.aspx>Staff Details Report</a></li></ul></li><li><a href=#>Project Report<div class='arrow-right'></div></a><ul id=navMenu ><li><a href=ProjectSummary.aspx>Project Costing</a></li><li><a href=Report_Project_Clientwise_BillableHours.aspx>Billable Hours Summary Report</a></li><li><a href= Project_Departmentwise_Report.aspx>Project Billable Report</a></li><li><a href=ProjectwiseBillableNonBillableReport.aspx>Project Billable/Non Billable Report</a></li><li><a href=All_Project_Client_Department_Summerise.aspx>Projectwise Client and Departments</a></li><li><a href=Projectwise_staff_columnar_Report.aspx>Projectwise Staff columnar </a></li><li><a href=DepartmentwiseStaffCosting.aspx>Projectwise Staff Costing</a></li><li><a href=All_ClientProjectStaffJob.aspx>Projectwise Department and WBS</a></li><li><a href=AllClientProjectJobTask.aspx>Client Project WBS Task</a></li><li><a href=ProjectApprover.aspx>Project Staff Hours Report</a></li><li><a href=Project_Jsr.aspx>Project Jsr Report</a></li></ul></li><li><a href=#>Resource Report<div class='arrow-right'></div></a><ul id=navMenu ><li><a href=Resource_Utilization_Report.aspx>Resource Utilization Report</a></li><li><a href=Weekwise_Report.aspx>Resource Weekwise Report</a></li><li><a href=Resource_Planning.aspx>Resource Planning Report</a></li></ul></li><li><a href=Staff_WorkingPercentage.aspx>Resource Allocation Report</a></li><li><a href=#>Budgeting Report<div class='arrow-right'></div></a><ul id=navMenu ><li><a href=Client_Project_Assignment_Staff_Summary.aspx>WBS Budget Report</a></li><li><a href=ProjectwiseCostVsActuals.aspx>Projectwise Cost Vs Actuals</a></li><li><a href=ProjectandStaff_Budgeting.aspx>Project and Staff Budgeting</a></li><li><a href=ProjectDepartment_Budgeting.aspx>Project Department Budgeting</a></li></ul></li></ul></li><li><a href=#>Utilities<div class='arrow-down'></div></a><ul id=navMenu ><li><a href=Changepassword.aspx>Change Password</a></li><li><a href=ManageRoleAccess.aspx>Manage Permission</a></li><li><a href=FreezeDetail.Aspx>Unfreeze Timesheet</a></li><li><a href=CompanyProfile.aspx>Company Profile</a></li><li><a href=Email_SMTPSettings.aspx>SMTP Setting</a></li><li><a href=labelallocation.aspx>Label Allocation</a></li><li><a href=notificationmanager.aspx>Notification Manager</a></li><li><a href=Staff_IsUnlock.aspx>Staff Unlock</a></li><li><a href=Rolewise_Project_Approver_Allocation.aspx>Report Allocation</a></li></ul></li></ul>";
        //LiteralMainMenu.Text = group_menu;
    }

    public void GetLogo()
    {
        int Compid = Convert.ToInt32(Session["companyid"].ToString());

        //string lPath= Server.MapPath("~/img/Companylogo");
		
        //lPath + "\\" + Compid + ".jpg"   ;
        hdncomlogo.Value = Compid.ToString();

    }

    public string bindmenu(List<menumaster> objL)
    {   string group_menu = "";

        List<menumaster> ListMenuGroup = objL.GroupBy(test => test.Name.Trim().ToLower()).Select(grp => grp.First()).ToList();
        foreach (var mainitem in ListMenuGroup)
        {
            if (mainitem.GSubmenu > 1)
            {
                group_menu += "<li  class='nav-header '>" + mainitem.Name.ToString();
            }
            else if (mainitem.Name.Trim().ToLower() == mainitem.Menu_Title.Trim().ToLower())
            {
                if (mainitem.GROUP_ID == 17)
                {
                    group_menu += "<li  class='nav-item  '><a href=" + mainitem.PageName + " target='_blank' class='nav-link  '><i class=" + mainitem.MIcon + "></i><p>" + mainitem.Name.ToString() + "</p></a>";
                }
                else
                {
                    group_menu += "<li  class='nav-item  '><a href=" + mainitem.PageName + "  class='nav-link  '><i class=" + mainitem.MIcon + "></i><p>" + mainitem.Name.ToString() + "</p></a>";
                }
            }
            else
            {
                string sr = Session["staffid"].ToString();
               // int stf = Convert.ToInt32(Session["staffid"].ToString());
                if (sr == "" && mainitem.Name.ToString() == "Enter Timesheet")
                {
                }
                else
                {

                    /////////// Master
                    group_menu += "<li class='nav-item '><a href=#  class='nav-link  '><i class=" + mainitem.MIcon + "></i><p>" + mainitem.Name.ToString() + "<i class='fas fa-angle-left right'></i></p></a>";

                    var secondlevel = objL.Where(x => x.GROUP_ID == mainitem.GROUP_ID).GroupBy(x => x.SubName.Trim().ToLower()).Select(x => x.FirstOrDefault()).ToList();

                    int SecondLevelMenuCount = secondlevel.Count;

                    if (SecondLevelMenuCount > 0)
                        group_menu += "<ul class='nav nav-treeview' > ";

                    foreach (var layer2 in secondlevel)
                    {
                        if (sr == "" && layer2.Menu_Title.ToString() == "Enter Timesheet")
                        {
                        }
                        else
                        {

                            if (layer2.SubName.Trim().ToLower() == layer2.Menu_Title.Trim().ToLower())
                            {
                                group_menu += "<li  class='nav-item '><a href=" + layer2.PageName + " class='nav-link'></i><p>" + layer2.Menu_Title.ToString() + "</p></a></li>";
                            }
                            else
                            {
                                group_menu += "<li class='nav-item'><a href=# class='nav-link '></i><p>" + layer2.SubName.ToString() + "<i class='fas fa-angle-left right'></i></p></a>";

                                /////third  level menu start
                                var thirdLevel = objL.Where(x => x.SubName.Trim().ToLower() == layer2.SubName.Trim().ToLower() && x.GROUP_ID == layer2.GROUP_ID).ToList();

                                if (thirdLevel.Count > 0)
                                    group_menu += "<ul id=navMenu class='nav nav-treeview '>";

                                foreach (var thirdItem in thirdLevel)
                                {
                                    group_menu += "<li class='nav-item'><a href=" + thirdItem.PageName + "  class='nav-link '></i><p>" + thirdItem.Menu_Title.ToString() + "</p></a></li>";
                                }


                                if (thirdLevel.Count > 0)
                                    group_menu += "</ul>";
                                /////third  level menu END

                                group_menu += "</li>";
                            }
                        }
                    }

                    if (SecondLevelMenuCount > 0)
                        group_menu += "</ul>";
                }
                group_menu += "</li>";
            }
        }
        group_menu = "<ul class='nav nav-pills nav-sidebar flex-column' data-widget = 'treeview'  role='menu' data-accordion='false'> " + group_menu + " </ul>";
       
            hdnMnu.Value = group_menu;
       
        return group_menu;
    }


    public List<menumaster> dal_bindmenu(int p)
    {
        SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        List<menumaster> menulist = new List<menumaster>();
        SqlParameter[] param = new SqlParameter[1];
        param[0] = new SqlParameter("@Companyid", p);
        //  DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "bindmenu", param);
        using (SqlDataReader sdr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_bootstrap_bindmenu_New", param))
        {
            while (sdr.Read())
            {
                menulist.Add(new menumaster()
                {
                    SubName = (sdr["SubName"].ToString()),
                    GROUP_ID = Convert.ToInt16(sdr["GROUP_ID"].ToString()),
                    Name = (sdr["name"].ToString()),
                    PageName = (sdr["pagename"].ToString()),
                    Menu_Title = (sdr["menu_title"].ToString()),
                    MIcon = (sdr["Icon"].ToString()),
                    GSubmenu = Convert.ToInt16(sdr["GSubmenu"].ToString()),
                    GSubName = (sdr["GSubName"].ToString()),
                });
            }
        }
        return menulist;
    }


    public List<menumaster> dal_staffmenu(int p, int c)
    {
        SqlConnection sqlConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ToString());
        List<menumaster> staffmenulist = new List<menumaster>();
        SqlParameter[] param = new SqlParameter[2];
        param[0] = new SqlParameter("@staffcode", p);
        param[1] = new SqlParameter("@companyID", c);
        //DataSet ds = SqlHelper.ExecuteDataset(sqlConn, CommandType.StoredProcedure, "bindmenustaff", param);
        using (SqlDataReader sdr = SqlHelper.ExecuteReader(sqlConn, CommandType.StoredProcedure, "usp_bootstrap_bindmenustaff_new", param))
        {
            while (sdr.Read())
            {
                staffmenulist.Add(new menumaster()
                {
                    SubName = (sdr["SubName"].ToString()),
                    GROUP_ID = Convert.ToInt16(sdr["GROUP_ID"].ToString()),
                    Name = (sdr["name"].ToString()),
                    PageName = (sdr["pagename"].ToString()),
                    Menu_Title = (sdr["menu_title"].ToString()),
                    MIcon = (sdr["Icon"].ToString()),
                    GSubmenu = Convert.ToInt16(sdr["GSubmenu"].ToString()),
                    GSubName = (sdr["GSubName"].ToString()),
                });
            }
            return staffmenulist;
        }


    }

    public void getCompanyPermissions()
    {
        try
        {
            List<CompanyTimeThreshold> objCompanyTimeThreshold = new List<CompanyTimeThreshold>();
            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@compid", hdnCompanyid.Value);
            DataSet ds = SqlHelper.ExecuteDataset((new CommonFunctions())._cnnString, CommandType.StoredProcedure, "usp_getCompanyPermission", param);
            if (ds.Tables[0].Rows.Count > 0)
            {
                hdnHidenShow.Value = ds.Tables[0].Rows[0]["Hide_Billable"].ToString();
				hdnAttachmentMandatory.Value = ds.Tables[0].Rows[0]["Attachment_mandatory"].ToString();
            }
            //using (SqlDataReader drrr = SqlHelper.ExecuteReader((new CommonFunctions())._cnnString, CommandType.StoredProcedure, "usp_getCompanyPermission", param))
            //{
            //    while (drrr.Read())
            //    {
            //        objCompanyTimeThreshold.Add(new CompanyTimeThreshold()
            //        {
            //            Hide_Bill = new CommonFunctions().GetValue<bool>(drrr["Hide_Billable"].ToString()),
                        
            //        });
            //    }
            //}
            //hdnCompanyPermission.Value = objCompanyTimeThreshold[0].Hide_Bill.ToString();

            //return new JavaScriptSerializer().Serialize(objCompanyTimeThreshold as IEnumerable<CompanyTimeThreshold>).ToString();
        }
        catch (Exception ex)
        {
            //MessageControl1.SetMessage(ex.Message, MessageDisplay.DisplayStyles.Error);
            

        }
    }

    public class menumaster
    {

        public string SubName { get; set; }
        public int? GROUP_ID { get; set; }
        public string Name { get; set; }
        public string Menu_Title { get; set; }
        public string MIcon { get; set; }
        public string PageName { get; set; }
        public string GSubName { get; set; }
        public int GSubmenu { get; set; }

    }


}



