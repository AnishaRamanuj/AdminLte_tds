using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Web;
using System.Data;
using System.Reflection;
namespace CommonLibrary
{
    public class CommonFunctions : DataAccessLayer.Common
    {
        delegate bool TryParse<T>(string str, out T value);

        public T GetValue<T>(object value)
        {

            if (typeof(T).Name == "String" && (string)value == "")
            {
                value = "";
            }
            if (typeof(T).Name == "Int32" && (string)value == "")
            {
                value = 0;
            }
            ////float
            if (typeof(T).Name == "Single" && (string)value == "")
            {
                value = 0;
            }
            ////decimal
            if (typeof(T).Name == "Decimal" && (string)value == "")
            {
                value = 0;
            }
            if (typeof(T).Name == "DateTime" && (string)value == "")
            {
                value = default(DateTime);
            }
            if (typeof(T).Name == "Boolean" && (string)value == "")
            {
                value = default(bool);
            }
            return (T)Convert.ChangeType(value, typeof(T));
        }

        public static void PrintError(Exception ex, string PageName)
        {
            //write log to a text file

            FileInfo fi = new FileInfo(HttpContext.Current.Server.MapPath("~/upload/") + "ErrorLog.txt");
            if (!fi.Exists)
            {
                using (StreamWriter sw = fi.CreateText())
                {
                    sw.WriteLine("===================================================");
                    sw.WriteLine("This is a new exception from database access module : " + DateTime.Now);
                    sw.WriteLine("===================================================");
                    sw.WriteLine(ex.Message + ex.StackTrace + ex.Source + ex.HelpLink);
                    sw.WriteLine("===================================================");
                    sw.WriteLine("Page Name " + PageName);
                    sw.Close();
                }
            }
            else
            {
                fi.Refresh();
                if (!fi.IsReadOnly)
                {
                    using (StreamWriter sw = fi.AppendText())
                    {
                        sw.WriteLine("===================================================");
                        sw.WriteLine("This is a new exception from database access module : " + DateTime.Now);
                        sw.WriteLine("===================================================");
                        sw.WriteLine(ex.Message + ex.StackTrace + ex.Source + ex.HelpLink);
                        sw.WriteLine("===================================================");
                        sw.WriteLine("Page Name " + PageName);
                        sw.Close();
                    }
                }
            }
        }


        public static void PrintError(string Message)
        {
            //write log to a text file

            FileInfo fi = new FileInfo(HttpContext.Current.Server.MapPath("~/upload/") + "ErrorLog.txt");
            if (!fi.Exists)
            {
                using (StreamWriter sw = fi.CreateText())
                {
                    sw.WriteLine("===================================================");
                    sw.WriteLine("This is a new exception from database access module : " + DateTime.Now);
                    sw.WriteLine("===================================================");
                    sw.WriteLine(Message);
                    sw.WriteLine("===================================================");
                    sw.WriteLine("Page Name " + Message);
                    sw.Close();
                }
            }
            else
            {
                fi.Refresh();
                if (!fi.IsReadOnly)
                {
                    using (StreamWriter sw = fi.AppendText())
                    {
                        sw.WriteLine("===================================================");
                        sw.WriteLine("This is a new exception from database access module : " + DateTime.Now);
                        sw.WriteLine("===================================================");
                        sw.WriteLine(Message);
                        sw.WriteLine("===================================================");
                        sw.WriteLine("Page Name " + Message);
                        sw.Close();
                    }
                }
            }
        }

        public static DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);

            //Get all the properties
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Defining type of data column gives proper data table 
                var type = (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(Nullable<>) ? Nullable.GetUnderlyingType(prop.PropertyType) : prop.PropertyType);
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name, type);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {
                    //inserting property values to datatable rows
                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            //put a breakpoint here and check datatable
            return dataTable;
        }
    }
    public class TableEntity
    {

    }

    public class Departmentwise_Approver_staff
    {

        public string StaffNames { get; set; }
        public int Staffcode { get; set; }
        public int Ischecked { get; set; }
        public int TopApproverId { get; set; }
        public int DeptId { get; set; }
        public string DepartmentName { get; set; }
    }

    public class Departmentwise_Approver_HOD
    {

        public string StaffNames { get; set; }
        public int Staffcode { get; set; }
        public int Ischecked { get; set; }
        public string DepartmentName { get; set; }
    }

    public class End_Project
    {
        public int Jobid { get; set; }
        public string ClientName { get; set; }
        public string PrjName { get; set; }
        public string Strtdt { get; set; }
        public string Enddt { get; set; }
        public int Count { get; set; }

    }

    public class Departmentwise_Approver_TopApprover
    {

        public string StaffNames { get; set; }
        public int Staffcode { get; set; }

    }

    public class tbl_Roleswise_staff
    {

        public string StaffNames { get; set; }
        public int Staffcode { get; set; }

    }

    public class Rolewise_ClientProject_Dept
    {

        public string Name { get; set; }
        public int Id { get; set; }

    }
    public class ProjectDept_hrs
    {
        public int compid { get; set; }
        public string Fromdate { get; set; }
        public string Todate { get; set; }
        public string selectedProjectid { get; set; }
        public bool needProject { get; set; }
        public bool needDept { get; set; }
        public string Rtype { get; set; }
        public string Status { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public int id { get; set; }
        public string btype { get; set; }


    }
    public class RolewiseApp_Allocation
    {
        public int Compid { get; set; }
        public string DepartmentName { get; set; }
        public int Deptid { get; set; }
        public string StaffNames { get; set; }
        public int Staffcode { get; set; }
        public int Ischecked { get; set; }
        public int ApproverId { get; set; }
        public int TopApproverId { get; set; }
        public int RoleId { get; set; }
        public string RoleName { get; set; }

        public List<Departmentwise_Approver_TopApprover> objtop { get; set; }
        public List<Departmentwise_Approver_staff> objstaff { get; set; }
        public List<Departmentwise_Approver_HOD> objhod { get; set; }

    }

    public class tbl_Rolewise_Project_Approver_Allocation
    {
        public int Compid { get; set; }
        public string Rolenames { get; set; }
        public int Role_Id { get; set; }
        public string Type { get; set; }
        public string Name { get; set; }
        public int Id { get; set; }
        public int ischeck { get; set; }
        public string StaffNames { get; set; }
        public int Staffcode { get; set; }
        public string AppPattern { get; set; }
        public string Desig { get; set; }
        public string StaffAccessValue { get; set; }
    }
    public class tbl_ClientGroup
    {
        public int StaffCode { get; set; }

        public string StaffName { get; set; }

        public string Type { get; set; }

        public int desgid { get; set; }

        public string designation { get; set; }

        public string Branch { get; set; }

        public int BrId { get; set; }

        public int DeptId { get; set; }

        public string DepartmentName { get; set; }
        public string selectedclientgrpid { get; set; }
        public string neetclientgrp { get; set; }
        public string neetjob { get; set; }
    }

    public class ClientGroup_R
    {
        public int compid { get; set; }

        public string UserType { get; set; }

        public string status { get; set; }

        public string StaffCode { get; set; }

        public string selectedstaffcode { get; set; }

        public string selectedclientid { get; set; }

        public string selectedprojectid { get; set; }

        public string selectedjobid { get; set; }

        public bool neetstaff { get; set; }

        public bool neetclient { get; set; }

        public bool needjob { get; set; }

        public bool needproject { get; set; }

        public string ToDate { get; set; }

        public string FromDate { get; set; }

        public string RType { get; set; }

        public string selecteddesg { get; set; }

        public string selecteddeptid { get; set; }

        public string needdesg { get; set; }

        public string needdept { get; set; }
        public string selectedtask { get; set; }

        public bool needJobGrp { get; set; }

        public string selectedJobGrp { get; set; }
        public string selectedclientgrpid { get; set; }
        public string neetclientgrp { get; set; }
        public string neetjob { get; set; }
    }
    public class Staffwise
    {
        public int StaffCode { get; set; }

        public string StaffName { get; set; }

        public string Type { get; set; }

        public int desgid { get; set; }

        public string designation { get; set; }

        public string Branch { get; set; }

        public int BrId { get; set; }

        public int DeptId { get; set; }

        public string DepartmentName { get; set; }
        public string selectedclientgrpid { get; set; }
        public string neetclientgrp { get; set; }
        public string neetjob { get; set; }
    }


    public class StaffProject
    {
        public int compid { get; set; }

        public string selectetdcltid { get; set; }

        public string selectedprojectid { get; set; }

        public string selectedstaffcode { get; set; }

        public string RType { get; set; }
        public string Type { get; set; }

        public bool projectwise { get; set; }

        public bool jobwise { get; set; }

        public bool clientwise { get; set; }

        public bool staffwise { get; set; }

        public bool deptwise { get; set; }

        public string UserType { get; set; }

        public string frommonth { get; set; }

        public string status { get; set; }

        public string StaffCode { get; set; }

        public string fromdate { get; set; }


        public string todate { get; set; }

        public string selectedDeptid { get; set; }

        public int BrId { get; set; }
        public string selectedjobid { get; set; }
        public string projectid { get; set; }

        public string TType { get; set; }
    }


    public class BranchNamenProjectJobStaff
    {
        public int StaffCode { get; set; }

        public string StaffName { get; set; }

        public string Type { get; set; }

        public int desgid { get; set; }

        public string designation { get; set; }

        public string Branch { get; set; }

        public int BrId { get; set; }

        public int DeptId { get; set; }

        public string DepartmentName { get; set; }
        public string selectedclientgrpid { get; set; }
        public string neetclientgrp { get; set; }
        public string neetjob { get; set; }
    }



    public class ProjectJobStaff
    {
        public int compid { get; set; }

        public string selectetdcltid { get; set; }

        public string selectedprojectid { get; set; }

        public string selectedstaffcode { get; set; }

        public string RType { get; set; }
        public string Type { get; set; }

        public bool projectwise { get; set; }

        public bool jobwise { get; set; }

        public bool clientwise { get; set; }

        public bool staffwise { get; set; }

        public bool deptwise { get; set; }

        public string UserType { get; set; }

        public string frommonth { get; set; }

        public string status { get; set; }

        public string StaffCode { get; set; }

        public string fromdate { get; set; }


        public string todate { get; set; }

        public string selectedDeptid { get; set; }

        public int BrId { get; set; }
        public string selectedjobid { get; set; }
        public string projectid { get; set; }

        public string TType { get; set; }
    }

    public class tbl_Rolewise_Budgeting_Staff_Permission
    {
        public int Compid { get; set; }
        public int RoleID { get; set; }
        public int StaffCode { get; set; }
        public string Rolename { get; set; }
        public string StaffName { get; set; }
        public int RoleStaffBudId { get; set; }
        public string Budgeting_type { get; set; }
        public int sino { get; set; }
    }

    public class tbl_Budgeting_Allocation_main
    {
        public string AllocHrs { get; set; }
        public List<tbl_Budgeting_Allocation> list_Budgeting { get; set; }
        public List<tbl_Budgeting_Allocation_Department> list_Department { get; set; }
        public List<tbl_Budgeting_Allocation_Department_names> list_Department_Names { get; set; }
    }

    public class tbl_Budgeting_Allocation
    {
        public int Compid { get; set; }
        public int RoleID { get; set; }
        public int StaffCode { get; set; }
        public string Rolename { get; set; }
        public string Budgeting_type { get; set; }
        public int Id { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public string AllocHrs { get; set; }
        public string fdate { get; set; }
        public string todate { get; set; }
        public string BudgetHours { get; set; }
        public int sino { get; set; }
        public string message { get; set; }
        public int jobid { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string budamt { get; set; }
        public string budhrs { get; set; }
        public string bb { get; set; }
        public int jid { get; set; }
        public int Jobdetid { get; set; }
        public int JobBudId { get; set; }
        public string JobName { get; set; }
        public int Totalcount { get; set; }
    }

    public class tbl_JobBudget_Update
    {
        public int Compid { get; set; }
        public int Jobid { get; set; }
    }

    public class tbl_Job_Budgeting_Allocation
    {
        public int Compid { get; set; }
        public int RoleID { get; set; }
        public int StaffCode { get; set; }
        public string Rolename { get; set; }
        public string Budgeting_type { get; set; }
        public int Id { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public string AllocHrs { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string BudgetHours { get; set; }
        public int sino { get; set; }
    }
    public class tbl_Job_Budgeting_Allocation_Main
    {
        public string AllocHrs { get; set; }
        public List<tbl_Job_Budgeting_Allocation_jobNames> tblBudJobname { get; set; }
        public List<tbl_Job_Budgeting_Allocation> tbljobBudAlloc { get; set; }
        public List<tbl_Job_Budgeting_Allocation_JobTable> tblJobTable { get; set; }
    }
    public class tbl_Job_Budgeting_Allocation_jobNames
    {
        public int ActivityId { get; set; }
        public string ActivityNames { get; set; }
    }

    public class tbl_Job_Budgeting_Allocation_JobTable
    {
        public int srno { get; set; }
        public int Id { get; set; }
        public string MJobName { get; set; }
        public string AllocHrs { get; set; }
        public int mJobId { get; set; }
        public string BuffHours { get; set; }
        public string BudgetHours { get; set; }
    }
    public class tbl_Budgeting_Allocation_Department
    {
        public int srno { get; set; }
        public int Id { get; set; }
        public string Name { get; set; }
        public string AllocHrs { get; set; }
        public int DeptId { get; set; }
        public string BuffHours { get; set; }
        public string BudgetHours { get; set; }
        public int Totalcount { get; set; }
    }

    public class tbl_Budgeting_Allocation_Department_names
    {

        public int Id { get; set; }
        public string Name { get; set; }

    }

    public class tbl_Import_data
    {
        public string Jobname { get; set; }
    }

    public class tbl_Finance_Budgeting
    {
        public int Compid { get; set; }
        public int CltId { get; set; }
        public string ClientName { get; set; }
        public int ProjectID { get; set; }
        public string ProjectName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string PreAmtUsed { get; set; }
        public string PreHrsUsed { get; set; }
        public string ProjectAmount { get; set; }
        public string ProjectHours { get; set; }
        public string Budget_Amt { get; set; }
        public string Buffer_Amt { get; set; }
        public string Buffer_Hrs { get; set; }
        public string Budget_Hrs { get; set; }
        public int sino { get; set; }
        public int FinBudId { get; set; }
        public string Message { get; set; }
    }

    public class tbl_User_roles
    {
        public int Compid { get; set; }
        public string Rolenames { get; set; }
        public int Role_Id { get; set; }
        public string Type { get; set; }
        public string Name { get; set; }
        public int Id { get; set; }
        public int ischeck { get; set; }
        public string StaffNames { get; set; }
        public int Staffcode { get; set; }
    }

    public class bind_staff_unlock
    {
        public int compid { get; set; }
        public string userid { get; set; }
        public string staffname { get; set; }
        public string uid { get; set; }
        public string sucess { get; set; }
    }

    public class AllTimesheetModel
    {
        public string CompID { get; set; }

        public int TSId { get; set; }

        public string clientName { get; set; }

        public string CLTId { get; set; }

        public int CID { get; set; }

        public int PID { get; set; }
        public string Projectname { get; set; }

        public string mJobName { get; set; }

        public string mJobId { get; set; }

        public int mJID { get; set; }

        public string StaffName { get; set; }

        public string staffcode { get; set; }

        public int SID { get; set; }

        public string WK { get; set; }

        public string Date { get; set; }

        public string TotalTime { get; set; }

        public string OpeAmt { get; set; }

        public string Narration { get; set; }

        public string Status { get; set; }

        public string Freezed { get; set; }

        public string FromTime { get; set; }

        public string ToTime { get; set; }

        public string BudHours { get; set; }

        public string LocationName { get; set; }

        public string BudAmt { get; set; }

        public int TotalCount { get; set; }

        public int PageSize { get; set; }

        public int PageIndex { get; set; }

        public int SrNo { get; set; }

        public bool IsApprover { get; set; }

        public int StaffCode { get; set; }

        public string LoginType { get; set; }

        public string StaffMode { get; set; }

        public string Reason { get; set; }

        public DateTime fr { get; set; }

        public DateTime to { get; set; }

        public int Hod { get; set; }

        public int Task_Id { get; set; }

        public string TaskName { get; set; }

        public string Approver { get; set; }

        public int Taskwise { get; set; }
		public int TSEntryId { get; set; }

        public string JobId { get; set; }
		
    }
	

    public class weekwiseReport
    {
        public string compid { get; set; }
        public string staffid { get; set; }
        public DateTime mondate { get; set; }
    }

    public class staffs
    {
        public int StaffCode { get; set; }
        public string StaffName { get; set; }
    }

    public class _Bind_clients
    {

       public Int32 Cltid { get; set; }
        public string ClientName { get; set; }
        public Int32 CompId { get; set; }
        public int ClientId { get; set; }
        public int IsChecked { get; set; }
    }

    public class _Bind_project
    {
        public Int32 Cltid { get; set; }
        public string projectName { get; set; }
        public int projectid { get; set; }
        public Int32 CompId { get; set; }
        public int BUID { get; set; }
    }

    public class _Bind_jobs
    {
        public Int32 CompId { get; set; }
        public Int32 mJobID { get; set; }
        public string MJobName { get; set; }
    }
    public class _bind_staffs
    {
        public Int32 StaffCode { get; set; }
        public string StaffName { get; set; }
        public Int32 CompId { get; set; }
    }

    public class _bind_timesheets
    {
        public Int32 Cltid { get; set; }
        public Int32 CompId { get; set; }
        public Int32 mJobID { get; set; }
        public int projectid { get; set; }
        public Int32 StaffCode { get; set; }
        public string fromdate { get; set; }
        public string todate { get; set; }
        public string jStatus { get; set; }
        public string Status { get; set; }
        public int PageSize { get; set; }
        public int PageIndex { get; set; }

    }
    public class vw_JobnClientnStaff
    {
        public string Dt { get; set; }
        public string Ip { get; set; }
        public string User { get; set; }
        public string UType { get; set; }
        public Int32 Jobid { get; set; }
        public Int32 Cltid { get; set; }
        public Int32 StaffCode { get; set; }
        public Int32 CompId { get; set; }
        public Int32 mJobID { get; set; }
        public Int32 ApproverId { get; set; }
        public Int32 SuperAppId { get; set; }
        public Int32 DeptId { get; set; }
        public Int32 JobGId { get; set; }
        public Int32 CTGId { get; set; }
        public Int32 pageIndex { get; set; }
        public Int32 pageNewSize { get; set; }
        public Int32 ischecked { get; set; }
        public string ClientName { get; set; }
        public string MJobName { get; set; }
        public string StaffName { get; set; }
        public string DepartmentName { get; set; }
        public string DesignationName { get; set; }
        public string JobGroupName { get; set; }
        public string ClientGroupName { get; set; }
        public string DateOfLeaving { get; set; }
        public string CreationDate { get; set; }
        public string fromdate { get; set; }
        public string todate { get; set; }
        public string BudgetAmount { get; set; }
        public string BudgetOthAmount { get; set; }
        public string Budgethours { get; set; }
        public string Departments { get; set; }
        public string jStatus { get; set; }
        public string projectName { get; set; }
        public int projectid { get; set; }
        public int Assign_Id { get; set; }
        public string Assign_Name { get; set; }
        public string Task_name { get; set; }
        public int Task_Id { get; set; }
        public string Billable { get; set; }
        public int hdndpt { get; set; }
        public string hdnAllAdpt { get; set; }
        public int hndtsk { get; set; }
        public string hdnAlltsk { get; set; }
        public string hdnAllstf { get; set; }
        public string hdnAllapp { get; set; }
        public string messg { get; set; }
        public bool IsApprover { get; set; }
        public int TSId { get; set; }
        public string BudgetSelection { get; set; }
        public string Stf { get; set; }
        public int temp_Id { get; set; }
        public int bud_Id { get; set; }
        public string StaffActualHourRate { get; set; }
        public string StaffHourlyRate { get; set; }
        public string AllocatedHours { get; set; }
        public string PlanedDrawing { get; set; }
        public string CompletedDrawing { get; set; }
        public string endDT { get; set; }
        public string startDT { get; set; }
        public string stfBudChk { get; set; }
        public string Link_JobnTask { get; set; }
        public int TotalCount { get; set; }
        public string Date { get; set; }
        public string Status { get; set; }
        public string Date2 { get; set; }
        public string Date3 { get; set; }
        public string Date4 { get; set; }
        public string Date5 { get; set; }
        public string Date6 { get; set; }
        public string Date7 { get; set; }
        public string Total { get; set; }
        public int SrNo { get; set; }
    }

    public class tbl_task_Project
    {
        public int Task_Id { get; set; }
        public int Projectid { get; set; }
        public string ProjectName { get; set; }
        public string Task_name { get; set; }
        public int TotalCount { get; set; }
        public Int32 ischecked { get; set; }
        public string Link_JobnTask { get; set; }
        public Int32 pageIndex { get; set; }
        public Int32 pageNewSize { get; set; }
        public Int32 CompId { get; set; }
        public string jStatus { get; set; }
        public string messg { get; set; }
        public string expdate { get; set; }
    }

    public class tbl_task_Jobname
    {
        public int Task_Id { get; set; }
        public int mjobid { get; set; }
        public string mjobName { get; set; }
        public string Task_name { get; set; }
        public int TotalCount { get; set; }
        public Int32 ischecked { get; set; }
        public string Link_JobnTask { get; set; }
        public Int32 pageIndex { get; set; }
        public Int32 pageNewSize { get; set; }
        public Int32 CompId { get; set; }
        public string jStatus { get; set; }
        public string messg { get; set; }
    }

    public class vw_SaveJobWiseBudgetDetails
    {
        public string stfBudChk { get; set; }
        public Int32 Jobid { get; set; }
        public Int32 Cltid { get; set; }
        public Int32 StaffCode { get; set; }
        public Int32 CompId { get; set; }
        public string BudgetSelection { get; set; }
        public int bud_Id { get; set; }
    }

    public class vw_JobnClientnStaff_jbApprover
    {
        public Int32 pageIndex { get; set; }
        public Int32 pageNewSize { get; set; }
        public Int32 StaffCode { get; set; }
        public string StaffName { get; set; }
        public Int32 DeptId { get; set; }
        public Int32 ischecked { get; set; }
        public Int32 Jobid { get; set; }
        public Int32 CompId { get; set; }
        public string Date { get; set; }
        public string BudgetAmount { get; set; }
        public string BudgetOthAmount { get; set; }
        public string Budgethours { get; set; }
        public string DepartmentName { get; set; }
        public string DesignationName { get; set; }
        public string StaffHourlyRate { get; set; }
        public string AllocatedHours { get; set; }
        public string PlanedDrawing { get; set; }
        public string fromdate { get; set; }
        public string todate { get; set; }
        public int temp_Id { get; set; }
        public string hdnAllapp { get; set; }
        public string Stf { get; set; }
    }

    public class tbl_Job_Staff_Details
    {
        public Int32 pageIndex { get; set; }
        public Int32 pageNewSize { get; set; }
        public Int32 StaffCode { get; set; }
        public string StaffName { get; set; }
        public Int32 DeptId { get; set; }
        public Int32 ischecked { get; set; }
        public Int32 Jobid { get; set; }
        public Int32 CompId { get; set; }
        public string PerHrs { get; set; }
        public string Fromdate { get; set; }
        public string Todate { get; set; }
    }
    public class vw_JobnClientnStaff_bindclientproject
    {
        public string IP { get; set; }
        public string User { get; set; }
        public string UType { get; set; }
        public string dt { get; set; }
        public Int32 Cltid { get; set; }
        public string ClientName { get; set; }
        public Int32 ischecked { get; set; }
        public int projectid { get; set; }
        public string projectName { get; set; }
        public Int32 mJobID { get; set; }
        public string MJobName { get; set; }
        public Int32 Jobid { get; set; }
        public int Task_Id { get; set; }
        public string Task_name { get; set; }
        public int Assign_Id { get; set; }
        public string Assign_Name { get; set; }
        public Int32 DeptId { get; set; }
        public string DepartmentName { get; set; }
        public Int32 CompId { get; set; }
        public string BudgetSelection { get; set; }
        public Int32 pageIndex { get; set; }
        public Int32 pageNewSize { get; set; }
        public int hdndpt { get; set; }
        public string messg { get; set; }
        public string jStatus { get; set; }
        public string Strtdt { get; set; }
        public string Endt { get; set; }
    }

    public class JobAllocation
    {
        public int Assign_Id { get; set; }
        public string Assign_Name { get; set; }
        public int ischecked { get; set; }
        public int DeptId { get; set; }
    }

    public class vw_JobnClientnStaff_GetDetails
    {
        public int projectid { get; set; }
        public Int32 Jobid { get; set; }
        public Int32 Cltid { get; set; }
        public string jStatus { get; set; }
        public Int32 mJobID { get; set; }
        public string CreationDate { get; set; }
        public string todate { get; set; }
        public string hdnAllstf { get; set; }
        public string ClientName { get; set; }
        public string MJobName { get; set; }
        public Int32 SuperAppId { get; set; }
        public int hdndpt { get; set; }
        public Int32 CompId { get; set; }
        public string Billable { get; set; }
        public string hdnAllapp { get; set; }
        public string Stf { get; set; }
    }
    public class tbl_ProjectDetails_Joba
    {
        public string Strtdt { get; set; }
        public string Enddt { get; set; }
        public string Status { get; set; }
        public string Prijecthrs { get; set; }
        public int Jobid { get; set; }
        public List<tbl_User_roles> list_JobMapping { get; set; }

    }

    public class tbl_GetAllrecordAllocHrs
    {
        public int id { get; set; }

        public List<tbl_Alloc_Client> list_Alloc_Client { get; set; }
        public List<tbl_Alloc_Project> list_Alloc_Project { get; set; }
        public List<tbl_Alloc_Jobname> list_Alloc_Jobname { get; set; }
        public List<tbl_Alloc_Staffname> list_Alloc_Staffname { get; set; }
    }
    public class tbl_GetAllRecords_Allocation
    {
        public int id { get; set; }

        public List<tbl_Alloc_Client> list_Alloc_Client { get; set; }
        public List<tbl_Alloc_Dept> list_Alloc_Dept { get; set; }

        public List<tbl_Alloc_Staffname> list_Alloc_Staffname { get; set; }
        public List<tbl_Alloc_Jobname> list_Alloc_jobnm { get; set; }
        public List<tbl_Alloc_JobGroup> list_Alloc_jGrp { get; set; }
	public List<tbl_Rolewise_Project_Approver_Allocation> list_Approver { get; set; }
    }
    public class tbl_Alloc_Client
    {
        public int cltid { get; set; }
        public string ClientName { get; set; }
    }
    public class tbl_Alloc_JobGroup
    {
        public int jgid { get; set; }
        public string jGroupName { get; set; }
    }

    public class tbl_Alloc_Dept
    {
        public int Depid { get; set; }
        public string DepartmentName { get; set; }
        public int isChecked { get; set; }
    }

    public class tbl_Alloc_Project
    {
        public int cltid { get; set; }
        public int Projid { get; set; }
        public string Projectname { get; set; }
        public string ProjectHrs { get; set; }
        public string Startdate { get; set; }
        public string enddate { get; set; }
        public string JobStatus { get; set; }
    }

    public class tbl_Add_Project
    {
        public int cltid { get; set; }
        public int Projid { get; set; }
        public string Projectname { get; set; }
        public string ProjectHrs { get; set; }
        public string Startdate { get; set; }
        public string enddate { get; set; }
        public string JobStatus { get; set; }
    }
    public class tbl_Alloc_Jobname
    {
        public int mJobid { get; set; }
        public string mJobname { get; set; }
    }
    public class tbl_Alloc_Staffname
    {
        public int Staffcode { get; set; }
        public string Staffname { get; set; }
        public string Type { get; set; }
        public int Depid { get; set; }
        public int isChecked { get; set; }
    }
    public class tbl_GetJobAllocate_Edit
    {
        public int id { get; set; }

        public List<tbl_BindGrd_JobAllocate> list_Alloc_Edit { get; set; }
        public List<tbl_Alloc_Staffname> list_Alloc_Staffname { get; set; }
	public List<tbl_Rolewise_Project_Approver_Allocation> list_Approver { get; set; }
    }
    public class tbl_GetJobAllocHour
    {
        public string Clintname { get; set; }
        public string Projectname { get; set; }
        public string Jobname { get; set; }
        public int Staffcount { get; set; }
        public string Jobhrs { get; set; }
        public int sino { get; set; }
        public int cltid { get; set; }
        public int Projctid { get; set; }
        public int mjobid { get; set; }
        public int Jobid { get; set; }
        public int Tcount { get; set; }
        public int plid { get; set; }
        public string LeaderName { get; set; }

    }

    public class tbl_BindGrd_JobAllocate
    {
        public string Clintname { get; set; }
        public string ED { get; set; }
        public string Jobname { get; set; }
        public int Diff { get; set; }
        public string ST { get; set; }
        public int sino { get; set; }
        public int cltid { get; set; }
        public string Status { get; set; }
        public int mjobid { get; set; }
        public int Jobid { get; set; }
        public int Tcount { get; set; }
        public bool? billable { get; set; }
        public Int32 JobGId { get; set; }
 	public string Narration { get; set; }
    }
    public class vw_JobnClientnStaff_SaveOrUpdateBudget
    {
        public Int32 Jobid { get; set; }
        public Int32 CompId { get; set; }
        public Int32 StaffCode { get; set; }
        public string BudgetAmount { get; set; }
        public string Budgethours { get; set; }
        public int temp_Id { get; set; }
        public string fromdate { get; set; }
        public string AllocatedHours { get; set; }
        public string StaffActualHourRate { get; set; }
        public string Stf { get; set; }
        public string todate { get; set; }
    }
    public class vw_JobnClientnStaffTimesheet
    {
        public Int32 Jobid { get; set; }
        public Int32 Cltid { get; set; }
        public Int32 StaffCode { get; set; }
        public Int32 CompId { get; set; }
        public Int32 mJobID { get; set; }
        public Int32 ApproverId { get; set; }
        public Int32 SuperAppId { get; set; }
        public Int32 DeptId { get; set; }
        public Int32 JobGId { get; set; }
        public Int32 CTGId { get; set; }
        public Int32 pageIndex { get; set; }
        public Int32 pageNewSize { get; set; }
        public Int32 ischecked { get; set; }
        public string ClientName { get; set; }
        public string MJobName { get; set; }
        public string StaffName { get; set; }
        public string DepartmentName { get; set; }
        public string DesignationName { get; set; }
        public string JobGroupName { get; set; }
        public string ClientGroupName { get; set; }
        public string DateOfLeaving { get; set; }
        public string CreationDate { get; set; }
        public string fromdate { get; set; }
        public string todate { get; set; }
        public string BudgetAmount { get; set; }
        public string BudgetOthAmount { get; set; }
        public string Budgethours { get; set; }
        public string Departments { get; set; }
        public string jStatus { get; set; }
        public string projectName { get; set; }
        public int projectid { get; set; }
        public int Assign_Id { get; set; }
        public string Assign_Name { get; set; }
        public string Task_name { get; set; }
        public int Task_Id { get; set; }
        public string Billable { get; set; }
        public int hdndpt { get; set; }
        public string hdnAllAdpt { get; set; }
        public int hndtsk { get; set; }
        public string hdnAlltsk { get; set; }
        public string hdnAllstf { get; set; }
        public string hdnAllapp { get; set; }
        public string messg { get; set; }
        public bool IsApprover { get; set; }
        public int TSId { get; set; }
        public string BudgetSelection { get; set; }
        public string Stf { get; set; }
        public int temp_Id { get; set; }
        public int bud_Id { get; set; }
        public string StaffActualHourRate { get; set; }
        public string StaffHourlyRate { get; set; }
        public string AllocatedHours { get; set; }
        public string PlanedDrawing { get; set; }
        public string CompletedDrawing { get; set; }
        public string endDT { get; set; }
        public string startDT { get; set; }
        public string stfBudChk { get; set; }
        public string Link_JobnTask { get; set; }
        public int TotalCount { get; set; }
        public string Date { get; set; }
        public string Status { get; set; }
        public string Date2 { get; set; }
        public string Date3 { get; set; }
        public string Date4 { get; set; }
        public string Date5 { get; set; }
        public string Date6 { get; set; }
        public string Date7 { get; set; }
        public string Total { get; set; }
        public int SrNo { get; set; }
    }
    public class AllTimesheetModel2
    {
        public string CompID { get; set; }

        public int TSId { get; set; }

        public string clientName { get; set; }

        public string CLTId { get; set; }

        public int CID { get; set; }

        public string mJobName { get; set; }

        public string mJobId { get; set; }

        public int mJID { get; set; }

        public string StaffName { get; set; }

        public string staffcode { get; set; }

        public int SID { get; set; }

        public string WK { get; set; }

        public string Date { get; set; }

        public string TotalTime { get; set; }

        public string OpeAmt { get; set; }

        public string Narration { get; set; }

        public string Status { get; set; }

        public string Freezed { get; set; }

        public string FromTime { get; set; }

        public string ToTime { get; set; }

        public string BudHours { get; set; }

        public string LocationName { get; set; }

        public string BudAmt { get; set; }

        public int TotalCount { get; set; }

        public int PageSize { get; set; }

        public int PageIndex { get; set; }

        public int SrNo { get; set; }

        public bool IsApprover { get; set; }

        public int StaffCode { get; set; }

        public string LoginType { get; set; }

        public string StaffMode { get; set; }

        public string Reason { get; set; }

        public DateTime fr { get; set; }

        public DateTime to { get; set; }

        public int Hod { get; set; }

        public int Task_Id { get; set; }

        public string TaskName { get; set; }

        public string Approver { get; set; }

        public int Taskwise { get; set; }
    }


    public class Job_AddEdit
    {
        public string hdnAllAdpt { get; set; }
        public Int32 Jobid { get; set; }
        public Int32 Cltid { get; set; }
        public int projectid { get; set; }
        public Int32 SuperAppId { get; set; }
        public string fromdate { get; set; }
        public string todate { get; set; }
        public string Billable { get; set; }
        public string jStatus { get; set; }
        public int hdndpt { get; set; }
        public string hdnlAAldpt { get; set; }
        public Int32 CompId { get; set; }
        public Int32 mJobID { get; set; }
        public int hndtsk { get; set; }
        public string hdnAlltsk { get; set; }
        public string hdnAllstf { get; set; }
        public string hdnAllapp { get; set; }


    }

    public class config_get_data
    {
        public int Compid { get; set; }
        public string CompConf_Id { get; set; }
        public Boolean Multi_Roles { get; set; }
        public Boolean Dual_Approver { get; set; }
        public string Leave_Year { get; set; }
        public int WeekStart { get; set; }
        public Boolean Narration { get; set; }
        public Boolean Expense { get; set; }
        public Boolean Location_mandatory { get; set; }
        public Boolean Edit_Reject_Timesheet { get; set; }
        public Boolean Hide_Billable { get; set; }
        public Boolean Timesheet_Decimals { get; set; }
        public Boolean BBudget { get; set; }
        public Boolean Csv { get; set; }
        public double Max_hours { get; set; }
        public string WOff { get; set; }
        public int Wsrt { get; set; }
        public Boolean Mon { get; set; }
        public Boolean Tue { get; set; }
        public Boolean Wed { get; set; }
        public Boolean Thu { get; set; }
        public Boolean Fri { get; set; }
        public Boolean Sat { get; set; }
        public Boolean Sun { get; set; }
    }
    public class tbl_mjob_dept
    {
        public string MJobName { get; set; }
        public int Jobid { get; set; }
        public int Cltid { get; set; }
        public int ischecked { get; set; }
        public string Departments { get; set; }
    }

    public class ProjectWiseBudgeting
    {
        public Int32 compid { get; set; }
        public Int32 cltid { get; set; }
        public Int32 jobid { get; set; }
        public string clientname { get; set; }
        public string MJobName { get; set; }
        public Int32 mjobid { get; set; }
    }

    public class Project_master
    {
        public string projectName { get; set; }
        public int projectid { get; set; }
    }

    public class Client_Master
    {
        public int CLTId { get; set; }
        public int? CompId { get; set; }
        public string ClientName { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Address3 { get; set; }
        public string City { get; set; }
        public string Pin { get; set; }
        public string Country { get; set; }
        public string BusPhone { get; set; }
        public string BusFax { get; set; }
        public string Website { get; set; }
        public string ContPerson { get; set; }
        public string ContMob { get; set; }
        public string ContEmail { get; set; }
        public int? CTGId { get; set; }
        public DateTime? CreationDate { get; set; }
        public string Partner { get; set; }
        public string username { get; set; }
        public string password { get; set; }
        public string Role { get; set; }
        public bool? IsApproved { get; set; }
        public Guid? UserId { get; set; }
        public string ClientCode { get; set; }
        public Int32 ischecked { get; set; }
        public Int32 StaffCode { get; set; }
    }

    public class Branch_Master
    {
        public int BrId { get; set; }
        public int? CompId { get; set; }
        public string BranchName { get; set; }
    }

    public class Designation_Master
    {
        public int DsgId { get; set; }
        public int? CompId { get; set; }
        public string DesignationName { get; set; }
        public float? HourlyCharges { get; set; }
    }

    public class Department_Master
    {
        public int DepId { get; set; }
        public int? CompId { get; set; }
        public string DepartmentName { get; set; }
    }

    public class tbl_Year_Master
    {
        public int Fin_Year_ID { get; set; }
        public string Fin_Year { get; set; }
    }

    public class tbl_ProjectwiseReport
    {
        public int StaffCode { get; set; }
        public string StaffName { get; set; }
        public string Type { get; set; }
        public int Jobid { get; set; }
        public string Projectname { get; set; }
        public int cltid { get; set; }
        public string clientname { get; set; }

    }
    public class tbl_ApproverStaff
    {
        public string staff { get; set; }
        public string dept { get; set; }
        public string Proj { get; set; }
        public string projstatus { get; set; }
        public string Tottime { get; set; }
    }


    public class StaffListDatails
    {
        public int id { get; set; }
        public string PNAME { get; set; }
        public string Type { get; set; }
        public string staffcode { get; set; }
        public string selectedprojectid { get; set; }
        public int compid { get; set; }
        public string fdate { get; set; }
        public string todate { get; set; }

    }

    public class Tbl_Job_Task_Master
    {
        public int JSTkId { get; set; }

        public int? JobId { get; set; }

        public int? TaskId { get; set; }

        public int? CompId { get; set; }

        public int Projectid { get; set; }

        public int mjobid { get; set; }

        public string TaskName { get; set; }
        public DateTime Expdate { get; set; }
    }

    public class tbl_StaffMaster
    {
        public int StaffCode { get; set; }

        public string StaffName { get; set; }

        public string Type { get; set; }

        public int desgid { get; set; }

        public string designation { get; set; }

        public string Branch { get; set; }

        public int BrId { get; set; }

        public int DeptId { get; set; }

        public string DepartmentName { get; set; }
        public string DateOfLeaving { get; set; }
        public string DateOfJoining { get; set; }
        public int Srno { get; set; }
        public string Total { get; set; }
        public List<tbl_leftstaff> list_RecordCount { get; set; }
    }

    public class tbl_leftstaff
    {
        public int RecordCount { get; set; }
        public int id { get; set; }
    }

    public class tbl_Project_Budgeting_Edit
    {
        public int Compid { get; set; }

        public int CltId { get; set; }

        public int JobId { get; set; }

        public string FromDate { get; set; }

        public string Bud_Amount { get; set; }

        public string Bud_Hours { get; set; }

        public string Other_Amount { get; set; }

        public int Used_Hours { get; set; }

        public int Bud_ID { get; set; }

        public int ID { get; set; }

        public string Name { get; set; }

        public string Type { get; set; }

        public string ClientName { get; set; }

        public string JobName { get; set; }

        public int Tcount { get; set; }

    }

    public class tbl_GetProject_List
    {
        public int Sino { get; set; }
        public int project_id { get; set; }
        public int compid { get; set; }
        public string startdt { get; set; }
        public string enddt { get; set; }
        public string Projectname { get; set; }
        public string Billable { get; set; }
        public string NonBill { get; set; }
        public string Startdate { get; set; }
        public string Endate { get; set; }
        public int Dept { get; set; }
        public int Staffc { get; set; }
        public int BudAmt { get; set; }
        public string Totalhrs { get; set; }
        public int pageindex { get; set; }
        public int pageswize { get; set; }
    }
    public class tbl_Departmentwise_Report
    {
        public int compid { get; set; }

        public int DeptId { get; set; }

        public string Department { get; set; }

        public string UserType { get; set; }

        public string status { get; set; }

        public int StaffCode { get; set; }

        public string selectedProject { get; set; }

        public string selectedJob { get; set; }

        public bool Projectwise { get; set; }

        public bool Jobwise { get; set; }

        public bool staffwise { get; set; }

        public string fromdate { get; set; }

        public string todate { get; set; }

        public string Name { get; set; }

        public string Type { get; set; }

        public int Id { get; set; }


    }

    public class tbl_JobMaster
    {
        public int Jobid { get; set; }
        public int mJobid { get; set; }
        public string mJobName { get; set; }
        public string JobStatus { get; set; }
        public bool? Billable { get; set; }
        public string endDT { get; set; }
        public string startDT { get; set; }
        public string superApp { get; set; }
        public string Approver { get; set; }
        public string staffid { get; set; }
        public string staffname { get; set; }
        public string deptid { get; set; }
        public string deptname { get; set; }
        public int? CompId { get; set; }
        public string ClientName { get; set; }
        public int bill { get; set; }
        public string Errmsg { get; set; }
        public int cltid { get; set; }
        public int projectid { get; set; }
        public string projectname { get; set; }
        public int totalbudhours { get; set; }
        public int spendhours { get; set; }
        public int actualhours { get; set; }
        public int balancehours { get; set; }
    }

    public class tbl_ClientGroupMaster
    {
        public int sino { get; set; }
        public int CgroupID { get; set; }
        public string cGroupName { get; set; }
        public int TotalCount { get; set; }
    }


    public class tbl_DepartmentBudgeting
    {
        public int Jobid { get; set; }
        public string Clientname { get; set; }
        public int depid { get; set; }
        public string Deptname { get; set; }
        public string Projectname { get; set; }
        public int BudgetHrs { get; set; }
        public string Fromdate { get; set; }
        public int srno { get; set; }
    }

    public class Projectwisestaffexpense
    {
        public string Branch { get; set; }
        public int id { get; set; }
        public int BrId { get; set; }
        public string PNAME { get; set; }
        public string Type { get; set; }
        public string selectedprojectid { get; set; }
        public string selectedclientid { get; set; }
        public string needstaff { get; set; }
        public string needProject { get; set; }
        public string RType { get; set; }
        public string fromdate { get; set; }
        public string todate { get; set; }
        public string UserType { get; set; }
        public string status { get; set; }
        public int compid { get; set; }
        public string staffcode { get; set; }

    }

    public class tbl_Projectstaff_Budg
    {
        public int Compid { get; set; }
        public int Cltid { get; set; }
        public string clientname { get; set; }
        public int Jobid { get; set; }
        public string Projectname { get; set; }
        public int StaffCode { get; set; }
        public string StaffName { get; set; }
        public int HrsAmt { get; set; }
        public string Hrs { get; set; }
        public int BudgetHrs { get; set; }
        public int AllocateHrs { get; set; }
        public int BudgetAmt { get; set; }
        public int Srno { get; set; }
        public int PrjectId { get; set; }
        public int Staffcount { get; set; }
        public int ActualAmt { get; set; }
        public string frmdate { get; set; }
        public string multid { get; set; }
        public List<tbl_ProjChk> list_Proj { get; set; }
    }

    public class tbl_ProjChk
    {
        public string FromDt { get; set; }
        public int BudAmt { get; set; }
        public int BudHrs { get; set; }
        public string Todate { get; set; }
        public int id { get; set; }
    }

    public class tbl_BudgetGrid
    {
        public string ProjectName { get; set; }
        public string clientName { get; set; }
        public int Srno { get; set; }
        public string BudHrs { get; set; }
        public int Jobid { get; set; }
        public string Budget_type { get; set; }
        public int cltid { get; set; }
        public int staffcount { get; set; }
        public string multid { get; set; }
        public string Project_Date { get; set; }
    }



    public class tbl_RoleMaster
    {
        public Int32 pageIndex { get; set; }
        public Int32 pageNewSize { get; set; }
        public int? CompId { get; set; }
        public int sRoleID { get; set; }
        public string sRoleName { get; set; }

    }

    public class ProjectClientAssignment
    {
        public int StaffCode { get; set; }
        public string StaffName { get; set; }
        public string Type { get; set; }
        public int desgid { get; set; }
        public string designation { get; set; }
        public string Branch { get; set; }
        public int BrId { get; set; }
        public int DeptId { get; set; }
        public string DepartmentName { get; set; }
    }

    public class ReprotprojectassignmnetJob
    {
        public int compid { get; set; }
        public string UserType { get; set; }
        public string status { get; set; }
        public string StaffCode { get; set; }
        public string selectedstaffcode { get; set; }
        public string selectedclientid { get; set; }
        public string selectedclientgrpid { get; set; }
        public string neetclientgrp { get; set; }
        public string neetjob { get; set; }
        public string selectedprojectid { get; set; }
        public string selectedjobid { get; set; }
        public bool neetstaff { get; set; }
        public bool neetclient { get; set; }
        public bool needjob { get; set; }
        public bool needproject { get; set; }
        public string ToDate { get; set; }
        public string FromDate { get; set; }
        public string RType { get; set; }
        public string selecteddesg { get; set; }
        public string selecteddeptid { get; set; }
        public string needdesg { get; set; }
        public string needdept { get; set; }
        public string selectedtask { get; set; }
        public bool needJobGrp { get; set; }
        public string selectedJobGrp { get; set; }
    }

    public class Expenses
    {
        public int ExpenseId { get; set; }
        public int? CompId { get; set; }
        public string ExpenseName { get; set; }
        public bool? Billable { get; set; }
        public string ExpenseNarr { get; set; }
        public float EAmt { get; set; }
        public int Tsid { get; set; }
        public string opeName { get; set; }
        public string Amount { get; set; }
        public string StaffName { get; set; }

        public int StaffCode { get; set; }
    }

    public class ReprotAllStaffCilentJob
    {
        public int compid { get; set; }

        public string UserType { get; set; }

        public string status { get; set; }

        public string StaffCode { get; set; }

        public string selectedstaffcode { get; set; }

        public string selectedclientid { get; set; }

        public string selectedprojectid { get; set; }

        public string selectedjobid { get; set; }

        public bool neetstaff { get; set; }

        public bool neetclient { get; set; }

        public bool needjob { get; set; }

        public bool needproject { get; set; }

        public string ToDate { get; set; }

        public string FromDate { get; set; }

        public string RType { get; set; }

        public string selecteddesg { get; set; }

        public string selecteddeptid { get; set; }

        public string needdesg { get; set; }

        public string needdept { get; set; }
        public string selectedtask { get; set; }

        public bool needJobGrp { get; set; }

        public string selectedJobGrp { get; set; }
    }

    public class ProjectwiseBillable_Hrs
    {
        public string Branch { get; set; }
        public int id { get; set; }
        public int BrId { get; set; }
        public string PNAME { get; set; }
        public string Type { get; set; }
        public string selectedprojectid { get; set; }
        public string selectedclientid { get; set; }
        public string needclient { get; set; }
        public string needProject { get; set; }
        public string RType { get; set; }
        public string fromdate { get; set; }
        public string todate { get; set; }
        public string UserType { get; set; }
        public string status { get; set; }
        public int compid { get; set; }
        public string staffcode { get; set; }

    }

    public class ApproverList
    {

        public int id { get; set; }
        public string PNAME { get; set; }
        public string Type { get; set; }
        public string selectedprojectid { get; set; }
        public string selectedStaffcode { get; set; }
        public string needApprover { get; set; }
        public string needProject { get; set; }
        public string status { get; set; }
        public int compid { get; set; }
        public string staffcode { get; set; }
    }


    public class PrjList
    {
        public int id { get; set; }
        public string PNAME { get; set; }
        public string Type { get; set; }
        public string staffcode { get; set; }
        public string selectedprojectid { get; set; }
        public int compid { get; set; }
        public string stype { get; set; }
        public string fdate { get; set; }
        public string todate { get; set; }
        public string strdate { get; set; }
        public string endate { get; set; }
    }
    public class ProjectStaff
    {
        public int compid { get; set; }

        public string selectetdcltid { get; set; }

        public string selectedprojectid { get; set; }

        public string selectedstaffcode { get; set; }
        public int workingHour { get; set; }
        public string RType { get; set; }
        public string Type { get; set; }

        public bool projectwise { get; set; }

        public bool jobwise { get; set; }

        public bool clientwise { get; set; }

        public bool staffwise { get; set; }

        public bool deptwise { get; set; }

        public string UserType { get; set; }

        public string frommonth { get; set; }

        public string status { get; set; }

        public string StaffCode { get; set; }

        public string fromdate { get; set; }


        public string todate { get; set; }

        public string selectedDeptid { get; set; }

        public int BrId { get; set; }
        public bool needstaff { get; set; }
        public bool needProject { get; set; }
        public bool needDept { get; set; }

    }

    public class staffprojectwise_Hours
    {
        public int compid { get; set; }
        public string Fromdate { get; set; }
        public string Todate { get; set; }
        public string selectedstaffCode { get; set; }
        public bool needstaff { get; set; }
        public bool needproject { get; set; }
        public int BrId { get; set; }
        public string selectedJobidCode { get; set; }
        public bool needClient { get; set; }
        public string Monthdate { get; set; }
        public int cltid { get; set; }
        public int StaffCode { get; set; }
        public bool needJob { get; set; }
        public string selectedcltidCode { get; set; }
		public string rolename { get; set; }
    }

    public class projectwisebudgeting
    {
        public int compid { get; set; }
        public string cltid { get; set; }
        public string from { get; set; }
        public string to { get; set; }
        public string projectid { get; set; }
    }

    public class tblThumbLogins
    {
        public string LogDate { get; set; }
        public string ttime { get; set; }
        public string status { get; set; }
    }

    public class HourlyCharges
    {
        public int StaffCode { get; set; }
        public int HrlyID { get; set; }
        public string StaffName { get; set; }
        public float HCharges { get; set; }
        public string JoinDT { get; set; }
        public string ResignDT { get; set; }
        public string frDate { get; set; }
        public string toDate { get; set; }
        public int compid { get; set; }
        public string UserID { get; set; }
        public string UPass { get; set; }
        public string msg { get; set; }
        public int rollid { get; set; }
    }

    public class tbl_GroupingMenuMaster
    {
        public int ID { get; set; }

        public string Name { get; set; }

        public int? GroupMenuorderBy { get; set; }

        public string PageName { get; set; }

        public string PageStatus { get; set; }

        public int? SubMenu { get; set; }

        public string SubName { get; set; }

    }

    public class tbl_pagemenumaster
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

    public class tbl_LabelAccess
    {

        public int LabelMasterID { get; set; }

        public string LabelAccessValue { get; set; }

        public string LabelName { get; set; }
    }

    public class tbl_MonthlyLeave
    {
        public int Leave_ID { get; set; }
        public int MLeave_ID { get; set; }
        public string Leave_Name { get; set; }
        public string Company_ID { get; set; }
        public string Leave_Monthly { get; set; }
        public string Monthly_Hrs { get; set; }
        public string From_Days { get; set; }
        public string To_Days { get; set; }
        public string Join_Hrs { get; set; }
        public string MonthName { get; set; }
        public int MonthID { get; set; }
        public int yearID { get; set; }
        public int FromYear { get; set; }
    }

    public class CompanyTimeThreshold
    {
        public int CompanyTimeThresholdId { get; set; }
        public int? Companyid { get; set; }
        public string WeeklyThreshold { get; set; }
        public string DailyThreshold { get; set; }
        public int? CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public int? UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public int? NumberOfDaysRequireInWeek { get; set; }
        public bool? IsFreeze { get; set; }
        public int? FreezeDays { get; set; }
        public int IsFormat { get; set; }
        public bool? Mon { get; set; }
        public bool? Tue { get; set; }
        public bool? Wed { get; set; }
        public bool? Thu { get; set; }
        public bool? Fri { get; set; }
        public bool? Sat { get; set; }
        public bool? Sun { get; set; }
        public bool? Format_A { get; set; }
        public bool? Format_B { get; set; }
        public bool? IsFreezeYes { get; set; }
        public bool? IsFreezeNo { get; set; }
        public bool? Location_mandatory { get; set; }
        public bool? LeaveFormat { get; set; }
        public bool? RejectReasons { get; set; }
        public bool? TimesheetApprovedHierarchically { get; set; }
        public bool? Chrgs_Top_Approver { get; set; }
        public bool? Chrgs_Sub_Approver { get; set; }
        public bool? Chrgs_Staff { get; set; }
        public bool? CheckStaffWithThumbPrint { get; set; }
        public bool? compecentryoffloc { get; set; }
        public bool? ApprovedByHOD { get; set; }
        public bool? lwp { get; set; }
        public bool? Apredittmst { get; set; }
        public bool? RolePermitted { get; set; }
        public bool? TimesheetInput_JobDetails_show { get; set; }
        public bool? TimesheetInput_Staff_BudgetedDetails_show { get; set; }
        public string Freezeweekday { get; set; }
        public bool Expense_mandatory { get; set; }
        public string WeekStart { get; set; }
        public bool? isNarration { get; set; }
        public bool? isExpense { get; set; }
        public bool? isLocation { get; set; }
        public double? MaxHrs { get; set; }
        public bool? Hide_Bill { get; set; }
        public bool? Zero_decimals { get; set; }
        public bool? Edit_Reject_Timesheet { get; set; }
        public bool? IsBudgeted { get; set; }
        public int? Multi_Levels { get; set; }
        public bool? Autofillandhide { get; set; }
        public bool? Future_Date { get; set; }
        public double? Projectwise_Hrs { get; set; }
        public bool Edit_Billing_Hrs { get; set; }
        public int Link_JobnTask { get; set; }
        public int Link_TasknJob { get; set; }
        public int Job_Hours { get; set; }
        public int Calc_JobHrs { get; set; }
		public int ProjectnClient { get; set; }
		public bool? Edit_Submit { get; set; }
		public bool? Narration_Mandatory { get; set; }
        public int? SendMail_LeaveApplication { get; set; }
        public int? SendMail_LeaveApprover { get; set; }
		public string SatHoliday2_4 { get; set; }
		public bool AllowLeave { get; set; }
		 public bool AllowCheckinOut { get; set; }
        public bool? leave_wkly { get; set; }
		public bool? SwapEdit { get; set; }
        public bool Currency_mandatory { get; set; }
        public int? Drawing { get; set; }
        public int mmddyyyy { get; set; }
		public int OnlyProject { get; set; }
        public string UrlEmail { get; set; }
    }

    public class tbl_Viewer_Job_Assign
    {
        public int Job_Assign_id { get; set; }
        public int? Jobid { get; set; }

        public int? Assign_Id { get; set; }
        public int? Dept_Id { get; set; }
    }

    public class tbl_Job_Assign
    {
        public int Job_Assign_id { get; set; }

        public int? Jobid { get; set; }

        public int? Assign_Id { get; set; }

        public int? Dept_Id { get; set; }

        public int? Compid { get; set; }

    }

    public class tbl_ActivityMaster
    {
        public int Jobid { get; set; }
        public int ActivityId { get; set; }
        public string ActivityName { get; set; }
    }

    public class tbl_ProjectSubActivity
    {
        public int Activity_Id { get; set; }
    }

    public class vw_JobnSubActivityMaster
    {
        public Int32 AckId { get; set; }
        public string SubActivityName { get; set; }
        public string ActivityName { get; set; }
        public int TotalCount { get; set; }
        public int TSId { get; set; }
    }
   public class JobStaffMappings
    {
        public int StaffCode { get; set; }
        public Int32 Assign_Id { get; set; }
        public Int32 JobID { get; set; }
        public string Assign_Name { get; set; }
        public string ClientName { get; set; }
        public string ProjectName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Status { get; set; }
 
        public Int32 DeptId { get; set; }
        public Int32 pageIndex { get; set; }
        public Int32 pageNewSize { get; set; }
        public Int32 ischecked { get; set; }
        public int TotalCount { get; set; }
        public string Srch { get; set; }
        public string messg { get; set; }
    }


    public class Tbl_Assign_Details
    {
        public int Assign_Details_ID { get; set; }

        public int? Assign_Id { get; set; }

        public int? Depid { get; set; }

        public int? mJobid { get; set; }

        public int? Compid { get; set; }

        public string MJobName { get; set; }

        public int project_id { get; set; }

        public int Jobid { get; set; }

        public int Hrs { get; set; }

        public string HrsExt { get; set; }
		
        public bool Billable { get; set; }		
    }



    public class Tbl_Viewer_Assign_Details
    {
        public int? Assign_Id { get; set; }
        public int? mJobid { get; set; }
        public string MJobName { get; set; }
    }

    public class job_master_ts
    {
        public int JobId { get; set; }

        public int? CLTId { get; set; }

        public int? CompId { get; set; }

        public string JobName { get; set; }

        public int? JobGId { get; set; }

        public DateTime? CreationDate { get; set; }

        public int? StaffCode { get; set; }

        public DateTime? EndDate { get; set; }

        public float? BudHours { get; set; }

        public decimal? BudAMt { get; set; }

        public float? ActualHours { get; set; }

        public decimal? ActualAmt { get; set; }

        public string JobStatus { get; set; }

        public DateTime? ActualJobEndate { get; set; }

        public int? JobApprover { get; set; }

        public int? mJobID { get; set; }

        public decimal? OtherBudAmt { get; set; }

        public string BudgetingSelection { get; set; }

        public bool? Billable { get; set; }

        public int? ProjectID { get; set; }

        public string ClientName { get; set; }

        public string ProjectName { get; set; }

        public string Project_Hours { get; set; }

        public string Project_Amount { get; set; }

        public string MJobName { get; set; }

        public string SuperApprover { get; set; }

        public string Approvers { get; set; }
		
		public bool? BillVisible { get; set; }

        public bool? PrjNeverEnd { get; set; }
		
		public string PrjCode { get; set; }
		
		public string CltCode { get; set; }
		
		public string PlnType { get; set; }
    }

    public class tbl_job_ts
    {
        public int JobId { get; set; }

        public int? CLTId { get; set; }

        public int? CompId { get; set; }

        public int? isCheck { get; set; }

        public int? ProjectID { get; set; }

        public string ClientName { get; set; }

        public string ProjectName { get; set; }

        public int Id { get; set; }


    }

    public class tbl_Staff
    {
        public int StaffCode { get; set; }

        public string StaffName { get; set; }

    }

    public class tbl_MultiDept
    {
        public int Depid { get; set; }

        public string DepName { get; set; }

    }

    public class tbl_UnfreezedDates
    {
        public DateTime UnfreezedDate { get; set; }
    }

    public class TimesheetInputDepartmentWise
    {
        public string DepId { get; set; }

        public string DepartmentName { get; set; }

        public string staffBioServerid { get; set; }

        public string Branchname { get; set; }

        public string DesignationName { get; set; }

        public string HOD { get; set; }

        public List<tbl_Job_Assign> list_Job_Assign { get; set; }

        public List<Tbl_Assign_Details> list_Assign_Details { get; set; }

        public List<job_master_ts> list_job_master_ts { get; set; }

        public List<Tbl_Job_Task_Master> list_job_task { get; set; }

        public List<tbl_UnfreezedDates> list_UnfreezedDates { get; set; }

    }

    public class TimesheetInput_AllClients
    {
        public string DepId { get; set; }

        public string DepartmentName { get; set; }

        public string staffBioServerid { get; set; }

        public string Branchname { get; set; }

        public string DesignationName { get; set; }

        public string HOD { get; set; }

        public List<_Bind_clients> list_Job_Assign { get; set; }

        public List<_Bind_project> list_Assign_Details { get; set; }

        public List<_Bind_jobs> list_job_master_ts { get; set; }

        public List<tbl_UnfreezedDates> list_UnfreezedDates { get; set; }

    }

    public class Datemonth
    {
        public string d1DM { get; set; }
        public string d2DM { get; set; }
        public string d3DM { get; set; }
        public string d4DM { get; set; }
        public string d5DM { get; set; }
        public string d6DM { get; set; }
        public string d7DM { get; set; }

    }

    public class list_weekname
    {
        public string d1week { get; set; }
        public string d2week { get; set; }
        public string d3week { get; set; }
        public string d4week { get; set; }
        public string d5week { get; set; }
        public string d6week { get; set; }
        public string d7week { get; set; }
    }

    public class list_stff_summary
    {
        public string staffcode { get; set; }
        public string staffemail { get; set; }
        public int srno { get; set; }
        public string Staffname { get; set; }
        public string d1 { get; set; }
        public string d2 { get; set; }
        public string d3 { get; set; }
        public string d4 { get; set; }
        public string d5 { get; set; }
        public string d6 { get; set; }
        public string d7 { get; set; }
        public string Total { get; set; }
        public string TotalCount { get; set; }
        public string SrNo { get; set; }
        public string SlNo { get; set; }
    }

    public class list_vertical
    {
        public string d1vet { get; set; }
        public string d2vet { get; set; }
        public string d3vet { get; set; }
        public string d4vet { get; set; }
        public string d5vet { get; set; }
        public string d6vet { get; set; }
        public string d7vet { get; set; }
    }

    public class Staff_record
    {
        public int record { get; set; }

        public List<Datemonth> tbl_Datemonth { get; set; }

        public List<list_weekname> tbl_list_weekname { get; set; }


        public List<list_vertical> tbl_list_vertical { get; set; }
    }

    public class MinimumHrs
    {
        public int srno { get; set; }
        public string Tdate { get; set; }
        public string Staffname { get; set; }
        public string Deptname { get; set; }
        public string DesignName { get; set; }
        public string totaltm { get; set; }
        public string hors { get; set; }
        public string diff { get; set; }
        public string TotalCount { get; set; }
        public string SlNo { get; set; }
    }

    public class tbl_timesheet_not
    {
        public int srno { get; set; }
        public string Tdate { get; set; }
        public string Staffname { get; set; }
        public string Deptname { get; set; }
        public string DesignName { get; set; }
        public string Approver { get; set; }
        public string mobile { get; set; }
        public string email { get; set; }
        public int Totalcount { get; set; }
		public string TeamLeader { get; set; }      //New field added
    }

    public class TimesheetInputDepartmentWise_Approver
    {
        public string DepId { get; set; }

        public string DepartmentName { get; set; }

        //public string staffBioServerid { get; set; }

        //public string Branchname { get; set; }

        //public string DesignationName { get; set; }

        public string Staff_Roll { get; set; }

        public int e_Timesheet { get; set; }

        public List<tbl_Viewer_Job_Assign> list_Job_Assign { get; set; }

        public List<Tbl_Viewer_Assign_Details> list_Assign_Details { get; set; }

        public List<tbl_job_ts> list_job_master_ts { get; set; }

        //public List<Tbl_Job_Task_Master> list_job_task { get; set; }

        public List<tbl_Staff> list_Staffmaster { get; set; }

        //public List<tbl_MultiDept> list_MultiDep { get; set; }

    }



    public class tbl_Timesheets_data
    {
        public string MJobName { get; set; }
        public string StaffName { get; set; }
        public string TaskName { get; set; }
        public string Reason { get; set; }
        public string FromDT { get; set; }
        public string ToDT { get; set; }
        public int StaffCode { get; set; }
        public string Status { get; set; }
        public bool? Billable { get; set; }
        public string ClientName { get; set; }
        public string ProjectName { get; set; }
        public string TotalTime { get; set; }
        public int TotalCount { get; set; }
        public int Srno { get; set; }
        public int TSId { get; set; }
        public string Narration { get; set; }
        public float? OpeAmt { get; set; }
        public string Edit_Billing_Hrs { get; set; }
        public string Dt { get; set; }
        public string Location { get; set; }
		public int MyTs { get; set; }
		public string SubmittedDate { get; set; }
		public string Approver { get; set; }
        public int Cltid { get; set; }
        public int Jobid { get; set; }
        public int mJobid { get; set; }
    }

    public class BranchnameProjectJstaff
    {
        public int StaffCode { get; set; }

        public string StaffName { get; set; }

        public string Type { get; set; }

        public int desgid { get; set; }

        public string designation { get; set; }

        public string Branch { get; set; }

        public int BrId { get; set; }

        public int DeptId { get; set; }

        public string DepartmentName { get; set; }
        public string selectedclientgrpid { get; set; }
        public string neetclientgrp { get; set; }
        public string neetjob { get; set; }
    }


    public class Projectwise
    {
        public int compid { get; set; }

        public string selectetdcltid { get; set; }

        public string selectedprojectid { get; set; }

        public string selectedstaffcode { get; set; }

        public string RType { get; set; }
        public string Type { get; set; }

        public bool projectwise { get; set; }

        public bool jobwise { get; set; }

        public bool clientwise { get; set; }

        public bool staffwise { get; set; }

        public bool deptwise { get; set; }

        public string UserType { get; set; }

        public string frommonth { get; set; }

        public string status { get; set; }

        public string StaffCode { get; set; }

        public string fromdate { get; set; }


        public string todate { get; set; }

        public string selectedDeptid { get; set; }

        public int BrId { get; set; }
        public string selectedjobid { get; set; }
        public string projectid { get; set; }

        public string TType { get; set; }
    }


    public class tbl_StaffMaster_Project
    {
        public int StaffCode { get; set; }

        public string StaffName { get; set; }

        public string Type { get; set; }

        public int desgid { get; set; }

        public string designation { get; set; }

        public string Branch { get; set; }

        public int BrId { get; set; }

        public int DeptId { get; set; }

        public string DepartmentName { get; set; }
        public string selectedclientgrpid { get; set; }
        public string neetclientgrp { get; set; }
        public string neetjob { get; set; }
    }

    public class Assignments
    {
        public Int32 CompID { get; set; }
        public Int32 Assign_Id { get; set; }
        public Int32 mJobID { get; set; }
        public string Assign_Name { get; set; }
        public string MJobName { get; set; }
        public Int32 DeptId { get; set; }
        //public Int32 Did { get; set; }
        public string DepartmentName { get; set; }
        public Int32 pageIndex { get; set; }
        public Int32 pageNewSize { get; set; }
        public Int32 ischecked { get; set; }
        public int TotalCount { get; set; }
        public string Srch { get; set; }
        public string messg { get; set; }
    }


    public class Location_Master
    {
        public int LocId { get; set; }

        public int? CompId { get; set; }

        public int? id { get; set; }

        public string LocationName { get; set; }

        public int? Old_LocId { get; set; }

    }

    public class OPE_Master
    {
        public int OpeId { get; set; }

        public int? id { get; set; }

        public int? CompId { get; set; }

        public string OPEName { get; set; }

    }



    public class DashboardDetails
    {
        public int approved { get; set; }
        public int pending { get; set; }
        public int rejected { get; set; }
        public int active { get; set; }
        public int inactive { get; set; }
        public int lossmaking { get; set; }

        public int duenextweek { get; set; }
        public int Notallocatedjob { get; set; }
        public int allocatedjob { get; set; }

        public int Notallocatedstaff { get; set; }
        public int allocatedstaff { get; set; }
        public int Ongoing { get; set; }
        public int Completed { get; set; }
        public int compid { get; set; }
        public int staffcount { get; set; }
        public int NAstaffcnt { get; set; }
        public int tcount { get; set; }
    }

    public class StaffJobMapping
    {
        public int Sino { get; set; }
        public string StaffName { get; set; }
        public string Department { get; set; }
        public int TCount { get; set; }
        public int Staffcode { get; set; }
        public string Designation { get; set; }
        public int TotPrj { get; set; }
    }

    public class CountStaffwise
    {
        public int Staffwith { get; set; }
        public int Staffwithout { get; set; }
        public List<StaffJobMapping> list_StaffJobMapping { get; set; }
    }
    public class Dashboard_Projects
    {
        public string Department { get; set; }
        public int TCount { get; set; }
        public string Project { get; set; }
        public string JobStatus { get; set; }
        public string TotalTime { get; set; }
        public int ProjectId { get; set; }
        public double hCharge { get; set; }
        public string Startdt { get; set; }
        public string Enddt { get; set; }
    }


    public class Dashboard_Projects_Details
    {
        public string Department { get; set; }
        public string TotalTime { get; set; }
        public string Staffname { get; set; }
        public int ProjectId { get; set; }
        public double hCharge { get; set; }
        public List<Projects_Details> list_Project_Details { get; set; }
    }

    public class Projects_Details
    {
        public string StartDT { get; set; }
        public string Project { get; set; }
        public string EndDT { get; set; }
    }

    public class tbl_Audit
    {
        public int compid { get; set; }
        public DateTime Fromdate { get; set; }
        public string Todate { get; set; }
        public int jobid { get; set; }
        public string deptname { get; set; }
        public string Monthdate { get; set; }
        public int cltid { get; set; }
        public int TCount { get; set; }
        public double Hrs { get; set; }
        public List<tbl_Audit_details> list_Audit_Details { get; set; }
    }

    public class tbl_Audit_details
    {
        public int compid { get; set; }
        public int depCnt { get; set; }
        public int StfCnt { get; set; }
        public string Sdate { get; set; }
        public string Endate { get; set; }
        public int TotalDays { get; set; }
        public double PPer { get; set; }
        public double Peramt { get; set; }
        public double Thrs { get; set; }

        public double Rhrs { get; set; }
        public double Bhrs { get; set; }
        public string Currency { get; set; }
        public double Total_Invoice { get; set; }
        public double RBills { get; set; }
    }

    public class SuperAdminCompany
    {
        public string CompanyName { get; set; }
        public string AmcST { get; set; }
        public string AmcEnd { get; set; }
        public string Schemes { get; set; }
        public int StaffCount { get; set; }
        public string Phone { get; set; }
        public int CompId { get; set; }
        public string ContactP { get; set; }
        public int daysLeft { get; set; }
        public int VerType { get; set; }
        public int taskwise { get; set; }
        public string usr { get; set; }
        public string pwd { get; set; }
    }

    public class SuperAdminCompanyDetails
    {
        public string Phone { get; set; }
        public string phone1 { get; set; }
        public string phone2 { get; set; }
        public string Max_hours { get; set; }
        public string DailyThreshold { get; set; }
        public string Future_Date { get; set; }
        public int WeekStart { get; set; }
        public string Leave_Year { get; set; }
        public int NumberOfDaysRequireInWeek { get; set; }
        public int Leave { get; set; }
        public int Leave_Type { get; set; }
        public string Email1 { get; set; }
        public string Email { get; set; }
    }

    public class tbl_Invoice
    {
        public int sino { get; set; }
        public int InvId { get; set; }
        public string InvNo { get; set; }
        public string InvDt { get; set; }
        public string ClientName { get; set; }
        public string Projectname { get; set; }
        public string Charges { get; set; }
        public string InvAmt { get; set; }
        public string Invtax { get; set; }
        public string Exp { get; set; }
        public string Exptax { get; set; }
        public string Receipt { get; set; }
        public string Balance { get; set; }
        public string Narra { get; set; }
        public string Mop { get; set; }
        public int Tcount { get; set; }
        public int Recptid { get; set; }

        public string Due_date { get; set; }
        public string from_date { get; set; }
        public string to_date { get; set; }
        public int cltid { get; set; }
        public int projectid { get; set; }
        public string Hrs { get; set; }
    }



    public class tbl_Master_TF
    {
        public int srno { get; set; }
        public int Id { get; set; }
        public string Name { get; set; }
        public string CPerson { get; set; }
        public string Email { get; set; }
        public string Mobile { get; set; }
        public int Totalcount { get; set; }
        public double Chrgs { get; set; }
        public int CltId { get; set; }
        public int BuId { get; set; }
    }

    public class tbl_staff
    {
        public int Compid { get; set; }
        public List<tbl_staffMasterdetail> list_staffMasterdetail { get; set; }
        public List<tbl_staffcount> list_staffcount { get; set; }
        public List<tbl_stafflimit> list_stafflimit { get; set; }
		public List<tbl_staffMasterdetail> listPrimeApprover { get; set; }
    }
    public class tbl_staffMasterdetail
    {
        public int srno { get; set; }
        public int Staffcode { get; set; }
        public string StaffName { get; set; }
        public string Desig { get; set; }
        public string Dept { get; set; }
        public int HrsCharg { get; set; }
        public string Contractwork { get; set; }
        public string Empid { get; set; }
        public string Phone { get; set; }
        public int Totalcount { get; set; }
        public string PrimarySkill { get; set; }
        public string SecondarySkill { get; set; }
        public string CertificationName { get; set; }
		public string StaffImagePath { get; set; }
        public string RoleName { get; set; }
        public string Currency { get; set; }
		public string ApproverName { get; set; }
		public bool Invite { get; set; }
        public string InviteSentDate { get; set; }
		public string Branch { get; set; }
    }

    public class tbl_staffcount
    {
        public int staffcount { get; set; }
    }

    public class tbl_stafflimit
    {
        public int Stafflimit { get; set; }
    }
    public class tbl_Staffdropdwon
    {
        public int Compid { get; set; }
        public List<Branch_Master> list_BranchMaster { get; set; }
        public List<Department_Master> list_DepartmentMaster { get; set; }
        public List<Designation_Master> list_DesignationMaster { get; set; }
        public List<tbl_RoleMaster> list_RoleMaster { get; set; }
        public List<tbl_Staffrole> list_staffroleid { get; set; }
        public List<tbl_Qualification> list_Qlf { get; set; }
        public List<tbl_SKill> list_SK { get; set; }
        public List<tbl_Certificate> list_Certificate { get; set; }
        public List<tbl_Discipline> list_Dis { get; set; }
        public List<tbl_Country> list_Cnt { get; set; }
        public List<tbl_Vendor> list_Vnd { get; set; }
        public List<tbl_WManager> list_WMgr { get; set; }
        public List<tbl_Currency> list_Currency { get; set; }
    }
    public class tbl_Staffrole
    {
        public int staffroleid { get; set; }
    }

    public class tbl_staffMasterEdit
    {

        public int Staffcode { get; set; }
        public string StaffName { get; set; }
        public int Desig { get; set; }
        public int Dept { get; set; }
        public int HrsCharg { get; set; }
        public int Brid { get; set; }
        public string Add1 { get; set; }
        public string Add2 { get; set; }
        public string Add3 { get; set; }
        public string city { get; set; }
        public string Contractwork { get; set; }
        public string Empid { get; set; }
        public string Phone { get; set; }
        public string DOJ { get; set; }
        public string DOL { get; set; }
        public string username { get; set; }
        public string password { get; set; }
        public int Staff_roll { get; set; }
        public string Qual { get; set; }
        public string Email { get; set; }
        public int Vendorid { get; set; }
        public int Qualid { get; set; }
        public int Skid { get; set; }
        public string Vemail { get; set; }
        public string Gender { get; set; }
        public int DispId { get; set; }
        public int CountryId { get; set; }
        public int WId { get; set; }
        public string CST { get; set; }
        public int ReportTo { get; set; }
        public int Encrypt_Password { get; set; }
        public string Currency { get; set; }
    }

    public class tbl_EditDivision
    {
        public string Divname { get; set; }
        public List<BusinessUnit> list_BusinessUnit { get; set; }
        public List<SubBusinessUnit> list_SubBusinessUnit { get; set; }
    }
    public class tbl_Certificate
    {
        public string CertificationName { get; set; }
        public int CId { get; set; }
        public int isChecked { get; set; }
    }
    public class BusinessUnit
    {
        public int buid { get; set; }
    }
    public class SubBusinessUnit
    {
        public int Sbuid { get; set; }
    }

    public class tbl_ProductLine_Dropdowns
    {
        public int compid { get; set; }
        public List<tbl_BUnit> list_Unit { get; set; }
        public List<tbl_Division> list_DVS { get; set; }

    }
    /// <summary>
    /// Project Mastter new
    /// </summary>

    public class tbl_Project_TF_Grid
    {
        public int srno { get; set; }
        public int Id { get; set; }
        public string Name { get; set; }
        public string ClientName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Project_ID { get; set; }
        public string BusUnitName { get; set; }
        public string Bu_leader { get; set; }
        public string GeoName { get; set; }
        public int Totalcount { get; set; }

    }
	public class Adherence_Report
    {
          public string DeptName { get; set; }
        public string StaffName { get; set; }
        public int? Week1 { get; set; }
        public int? Week2 { get; set; }
        public int? Week3 { get; set; }
        public int? Week4 { get; set; }
        public int? Week5 { get; set; }
        public int? Week6 { get; set; }
    }

    public class tbl_Proj_Edit
    {
        public int compid { get; set; }
        public List<tbl_Project_TF_Edit> list_Prj { get; set; }
        public List<tbl_ProjectActivity> list_projActv { get; set; }
    }

    public class tbl_Project_TF_Edit
    {
        public int ProjectID { get; set; }
        public int ClientID { get; set; }
        public string ProjectName { get; set; }
        public string Project_Hours { get; set; }
        public string Project_Amount { get; set; }
        public string Used_Amount { get; set; }
        public string used_hours { get; set; }
        public string Currency { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Proj_ID { get; set; }
        public int CostCenterID { get; set; }
        public int BUid { get; set; }
        public int SBUid { get; set; }
        public int PLId { get; set; }
        public int FGId { get; set; }
        public int FCId { get; set; }
        public int Staffcode { get; set; }
        public int STid { get; set; }
        public int Gid { get; set; }
        public int MSid { get; set; }
        public int PCID { get; set; }
        public string GECP { get; set; }
        public string ModelsAffected { get; set; }
        public string BusinessImpact { get; set; }
        public string ProjectObjective { get; set; }
    }
    public class tbl_Project_TF_Edit_All
    {
        public int compid { get; set; }

        public List<tbl_Staff> list_staff { get; set; }
        public List<tbl_BUnit> list_Unit { get; set; }
        public List<tbl_Sub_BUnit> list_SUnit { get; set; }
        public List<tbl_Product_Line> list_PLine { get; set; }
        public List<tbl_FGroup> list_FGrp { get; set; }
        public List<tbl_FCategory> list_FCat { get; set; }
        public List<tbl_Division> list_DVS { get; set; }
        public List<tbl_Geo> list_Geo { get; set; }
        public List<tbl_Site> list_Site { get; set; }
        public List<tbl_Milestone> list_Mile { get; set; }
        public List<tbl_ProjComplx> list_ProjComplx { get; set; }
        public List<tbl_CostCeneter> list_CostCeneter { get; set; }
        public List<tbl_Currency> list_Currency { get; set; }
        public List<tbl_Alloc_Jobname> list_Activity { get; set; }
        public List<tbl_Project_TF_Edit> list_Prj { get; set; }
        public List<tbl_ProjectActivity> list_projActv { get; set; }
    }


    public class tbl_Project_TF_All
    {
        public int compid { get; set; }

        public List<tbl_Staff> list_staff { get; set; }
        public List<tbl_BUnit> list_Unit { get; set; }
        public List<tbl_Sub_BUnit> list_SUnit { get; set; }
        public List<tbl_Product_Line> list_PLine { get; set; }
        public List<tbl_FGroup> list_FGrp { get; set; }
        public List<tbl_FCategory> list_FCat { get; set; }
        public List<tbl_Division> list_DVS { get; set; }
        public List<tbl_Geo> list_Geo { get; set; }
        public List<tbl_Site> list_Site { get; set; }
        public List<tbl_Milestone> list_Mile { get; set; }
        public List<tbl_ProjComplx> list_ProjComplx { get; set; }
        public List<tbl_CostCeneter> list_CostCeneter { get; set; }
        public List<tbl_Currency> list_Currency { get; set; }
        public List<tbl_Alloc_Jobname> list_Activity { get; set; }
    }

    public class tbl_ProjectActivity
    {
        public int mjobid { get; set; }
    }
    public class tbl_BusLeader
    {
        public string BLName { get; set; }
        public int BLId { get; set; }
    }

    public class tbl_BUnit
    {
        public string BUName { get; set; }
        public int BUId { get; set; }
        public int Divid { get; set; }
    }

    public class tbl_Sub_BUnit
    {
        public string SBLName { get; set; }
        public int SBLId { get; set; }
        public int Divid { get; set; }
    }
    public class tbl_Product_Line
    {
        public string PName { get; set; }
        public int PId { get; set; }
        public int cltid { get; set; }
        public int buid { get; set; }
    }
    public class tbl_FGroup
    {
        public string FGName { get; set; }
        public int FGId { get; set; }
    }
    public class tbl_FCategory
    {
        public string FCName { get; set; }
        public int FCId { get; set; }
    }
    public class tbl_Division
    {
        public string Clientname { get; set; }
        public int Cltid { get; set; }
    }
    public class tbl_Geo
    {
        public string GName { get; set; }
        public int GId { get; set; }
    }
    public class tbl_Site
    {
        public string SName { get; set; }
        public int SId { get; set; }
    }
    public class tbl_Milestone
    {
        public string MName { get; set; }
        public int MId { get; set; }
        public int ProjectID { get; set; }
    }

    public class tbl_ProjComplx
    {
        public int PCid { get; set; }
        public string ProjectComplex { get; set; }
    }

    public class tbl_CostCeneter
    {
        public int Costid { get; set; }
        public string Costcenter { get; set; }
    }

    //// New


    public class tbl_Qualification
    {
        public string Qualification { get; set; }
        public int QId { get; set; }
    }
    public class tbl_SKill
    {
        public string SKill { get; set; }
        public int SId { get; set; }
	    public int isChecked { get; set; }
        public int SkillType { get; set; }
    }
    public class tbl_Discipline
    {
        public string Discipline { get; set; }
        public int DId { get; set; }
    }

    public class tbl_Country
    {
        public string Country { get; set; }
        public int CId { get; set; }
    }

    public class tbl_Vendor
    {
        public string Vendor { get; set; }
        public int VId { get; set; }
    }
    ///////////Job/Project Allocatio TF

    public class TimesheetInput_TF
    {
        public string Discipline { get; set; }

        public string DesignationName { get; set; }

        public string staffBioServerid { get; set; }

        public string Country { get; set; }

        public string WManager { get; set; }

        public List<tbl_Project_Data_TF> list_Project { get; set; }

        public List<tbl_Milestone> list_Milestone { get; set; }

        public List<Tbl_Assign_Details> list_Activity { get; set; }

        public List<tbl_UnfreezedDates> list_UnfreezedDates { get; set; }

    }

    public class tbl_JobAllocation_TF
    {
        public int compid { get; set; }

        public List<_Bind_clients> list_client { get; set; }
        public List<_Bind_project> list_Project { get; set; }
        public List<Departmentwise_Approver_HOD> list_ReportManager { get; set; }
        public List<Departmentwise_Approver_staff> list_staff { get; set; }
        public List<tbl_BUnit> listbu { get; set; }

    }


    public class tbl_Job_TF_Edit_All
    {
        public int cltid { get; set; }
        public int Projectid { get; set; }
        public int BUID { get; set; }
        public List<Departmentwise_Approver_HOD> list_Appr { get; set; }
        public List<Departmentwise_Approver_staff> list_staff { get; set; }
    }

    public class tbl_WManager
    {
        public string WManager { get; set; }
        public int WId { get; set; }
    }


    /// <summary>
    /// //Status
    /// </summary>

    public class tbl_Status_TF_Grid
    {
        public int srno { get; set; }
        public int Id { get; set; }
        public int jobid { get; set; }
        public string Project { get; set; }
        public string ClientName { get; set; }
        public string ActualDt { get; set; }
        public string CurrentDt { get; set; }
        public int Project_ID { get; set; }
        public int cltid { get; set; }
        public string PrjStatus { get; set; }
        public string PrjHealth { get; set; }
        public int Totalcount { get; set; }
        public string BusinessUnit { get; set; }
        public int Buid { get; set; }
        public string Narr { get; set; }
        public string CurrNarr { get; set; }
        public string ActulNarr { get; set; }
        public string Projstartdt { get; set; }
    }

    public class tbl_Statusdropdown
    {
        public int compid { get; set; }
        public List<_Bind_project> list_proj { get; set; }
        public List<tbl_BUnit> list_BUnit { get; set; }
    }

    public class tbl_Project_Data_TF
    {
        public int ProjectID { get; set; }
        public int jobid { get; set; }
        public string ProjectName { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string jStatus { get; set; }
        public int msid { get; set; }
    }

    public class timesheet_table_TF
    {
        public int TSId { get; set; }

        public int? StaffCode { get; set; }

        public string StaffName { get; set; }

        public int? JobId { get; set; }

        public int? CompId { get; set; }

        public int? JobApprover { get; set; }

        public string FromTime { get; set; }

        public string ToTime { get; set; }

        public string TotalTime { get; set; }

        public int? OpeId { get; set; }

        public float? OpeAmt { get; set; }
        public string Edit_Billing_Hrs { get; set; }

        public int? LocId { get; set; }

        public int? NarId { get; set; }

        public DateTime? Date { get; set; }

        public string Status { get; set; }

        public string Satffstatus { get; set; }

        public decimal? Mints { get; set; }

        public bool? Billable { get; set; }

        public string Narration { get; set; }

        public string InvoiceNo { get; set; }

        public DateTime? LastDate { get; set; }

        public float? HourlyCharges { get; set; }

        public string Reason { get; set; }

        public int? Freezed { get; set; }

        public int? Milestone_Id { get; set; }

        public int? Project_Id { get; set; }

        public int? Assign_Id { get; set; }

        public int? mJob_Id { get; set; }

        public int? Dept_Id { get; set; }

        public bool? isApprovalRemaining { get; set; }

        public int? EnquiryId { get; set; }

        public decimal? BillableAmt { get; set; }

        public string RoleName { get; set; }

        public string APattern { get; set; }

        public string Milestone { get; set; }

        public string ProjectName { get; set; }

        public string MJobName { get; set; }


        public string Timesheets { get; set; }

        public string FromDT { get; set; }

        public string ToDT { get; set; }

        public string HolidayDT { get; set; }
        public int TotalCount { get; set; }
        public int Srno { get; set; }
        public string Date1 { get; set; }
        public string Expenses { get; set; }

    }



    public class tbl_Milestone_Status
    {
        public int compid { get; set; }
        public int Id { get; set; }
        public List<tbl_BUnit> list_Unit { get; set; }
        public List<tbl_Division> list_DVS { get; set; }
        public List<tbl_Project_Milestone> list_PM { get; set; }
        public List<tbl_MileStone_Project> list_MSP { get; set; }
    }
    public class tbl_Project_Milestone
    {
        public int pid { get; set; }
        public int Bid { get; set; }
        public int cltid { get; set; }
        public string ProjectName { get; set; }

    }


	
    public class tbl_MileStone_Project
    {
        public int Compid { get; set; }
        public int Mile_Id { get; set; }
        public int PMile_Id { get; set; }
        public int Project_Id { get; set; }
        public int Task_Id { get; set; }
        public double MPercent { get; set; }
        public double MHours { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }

    }	

    /////////////////// Bootstrap
    public class tbl_ProjectonLoad
    {
        public int Compid { get; set; }
        public List<tbl_Project_Grd> list_Grd { get; set; }
        public List<tbl_Project_Dept> list_Dp { get; set; }
        public List<tbl_Project_Activity> list_Act { get; set; }
        public List<tbl_Project_Team> list_Team { get; set; }
        public List<tbl_Project_Client> list_Client { get; set; }
        public List<tbl_Currency> list_Currency { get; set; }
		public List<tbl_ProjectManagers> list_ProjectManager { get; set; }
        public List<tbl_ProjectMilestone> list_ProjectMilestone { get; set; }
    }
    
    public class tbl_Project_Grd
    {
        public int Compid { get; set; }
        public int Sr { get; set; }
        public int Pid { get; set; }
        public int Cid { get; set; }
        public string Project { get; set; }
        public string Client { get; set; }
        public int Jid { get; set; }
 	    public int Sid { get; set; }
        public int Totalcount { get; set; }
        public string StarDt { get; set; }
        public string EndDt { get; set; }
        public int Progress { get; set; }
    }
	public class Departmentwise_Staff_Effort_Report
    {
        public List<tbl_Staff_Leave> tbl_Staff_Leave { get; set; }
        public List<tbl_Staff_Effort> tbl_Staff_Effort { get; set; }
    }

    public class tbl_Project_Dept
    {
        public int Compid { get; set; }
        public int Pid { get; set; }
        public int Did { get; set; }
        public int Aid { get; set; }
        public int Mjid { get; set; }
        public string Department { get; set; }
        public int isChecked { get; set; }
    }

    public class tbl_Project_Activity
    {
        public int Compid { get; set; }
        public int Pid { get; set; }
        public int Aid { get; set; }
        public string Asid { get; set; }
        public string Did { get; set; }
        public string Activity { get; set; }

        public int isChecked { get; set; }
    }

    public class tbl_Project_Team
    {
        public int Compid { get; set; }
        public int Pid { get; set; }
        public int Sid { get; set; }
        public int Did { get; set; }
        public int Dsg { get; set; }
        public int Bid { get; set; }
        public string Staff { get; set; }
        public int isChecked { get; set; }
        public string Frmdt { get; set; }
        public string Todt { get; set; }
        public int Hrs { get; set; }
        public string Desgn { get; set; }
        public string Deprt { get; set; }
        public string Brch { get; set; }
    }
	
    public class tbl_Project 
    {
        public int Compid { get; set; }
        public int Pid { get; set; }
        public List<tbl_Project_Details> list_pd { get; set; }
        public List<tbl_HoursTotal> list_sm { get; set; }
        public List<list_weekname> list_wk { get; set; }
        public List<tbl_ProjectManagers> list_ProjectManager { get; set; }
    }

    public class tbl_Project_Details
    {
        public int Pid { get; set; }
        public string PCode { get; set; }
        public int Jid { get; set; }
        public string Project { get; set; }
        public string Client { get; set; }
        public string StarDt { get; set; }
        public string EndDt { get; set; }
        public int Cid { get; set; }
        public string PStatus { get; set; }
        public string Billable { get; set; }
        public double PHours { get; set; }
        public double PAmount { get; set; }
        public string ProductLine { get; set; }
        public string Currency { get; set; }
        public string Expires { get; set; }
		public int ProjectDays { get; set; }
        public double ProjectBudget { get; set; }
        public string ProjectOverview { get; set; }

    }

    public class tbl_Project_Client
    {
        public int Compid { get; set; }
        public int Pid { get; set; }
        public int Cid { get; set; }
        public string Client { get; set; }
        public int isChecked { get; set; }
    }

    public class tbl_Staffmaster_JobAllocation
    {
        public int Compid { get; set; }
        public List<tbl_Alloc_Client> list_clt { get; set; }
        public List<ProjectWiseBudgeting> list_clntjob { get; set; }
    }

    public class tbl_StaffMasterEdit_Boostrap
    {
        public int Compid { get; set; }
        public List<tbl_staffMasterEdit> list_edit { get; set; }
        public List<tbl_ProjectActivity> list_jobid { get; set; }
        public List<tbl_Alloc_Client> list_cltid { get; set; }
        public List<tbl_SKill> list_SK { get; set; }
        public List<tbl_Certificate> list_certificate { get; set; }
		public List<tbl_StaffImage> staffImage { get; set; }


    }

    public class tbl_HoursTotal
    {
        public string TotalHrs { get; set; }
        public string Billhrs { get; set; }
        public string NonBillhrs { get; set; }
    }



    public class tbl_Currency
    {
        public string Currency { get; set; }
        public string Country { get; set; }
    }

    public class tbl_TSViewerdropdwon
    {
         public int Compid { get; set; }
        public List<Client_Master> list_ClientMaster { get; set; }
        public List<tbl_Project_Details> list_ProjectMaster { get; set; }
        public List<ProjectWiseBudgeting> list_MjobMaster { get; set; }
        public List<StaffListDatails> list_staffMaster { get; set; }
        public List<tbl_task_Project> list_taskMaster { get; set; }
        public List<Department_Master> list_depMaster { get; set; }
        public List<tbl_Drawing> list_DrawingNoMaster { get; set; }
    }


    public class TimesheetInput_2Level 
    {
        public string TotalHrs { get; set; }
        public string Billable { get; set; }
        public string NonBillable { get; set; }
        public DateTime DOJ { get; set; }
        public DateTime DOL { get; set; }
        public List<ClientnJobs_2Level> list_CnJ { get; set; }
        public List<tbl_UnfreezedDates> list_UnfreezedDates { get; set; }
        public List<tbl_JobName> list_mJ { get; set; }
        public List<tbl_Client> list_Cl { get; set; }

    }

    public class ClientnJobs_2Level
    {
        public int Cid { get; set; }
        public int Jid { get; set; }
        public int mJid { get; set; }
        public string mJob { get; set; }
        public string Client { get; set; }
        public DateTime? StarDt { get; set; }
        public DateTime? EndDt { get; set; }
        public string JStatus { get; set; }
        public string Billable { get; set; }

    }
	
	    public class Timesheet_Pie
    {
        public string status { get; set; }
        public string ttime { get; set; }
        public List<Dashboard_Charts> list_CnJ { get; set; }
        public List<list_stff_summary> list_line { get; set; }
        public List<tbl_Topfive> list_Topfive { get; set; }
    }

	    public class Dashboard_Charts
    {

        public string TotalHours { get; set; }
        public string Billable { get; set; }
        public string NonBillable { get; set; }
        public string ICount { get; set; }
        public string PCount { get; set; }
        public string Scount { get; set; }
        public string Whrs { get; set; }
 
    }

 public class tbl_Staff_Leave
    {
        public int StaffId { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public decimal LeaveDays { get; set; }
        public int LeaveDateofMonth { get; set; }
		public string LeaveName { get; set; }
    }
    public class tbl_Topfive
    {
        public string project { get; set; }
        public string Job { get; set; }
        public string client { get; set; }
        public int staffcode { get; set; }
        public string Totlhrs { get; set; }
    }

    public class timesheet_table
    {
        public int TSId { get; set; }

        public int? StaffCode { get; set; }

        public string StaffName { get; set; }

        public int? JobId { get; set; }

        public int? CompId { get; set; }

        public int? CLTId { get; set; }

        public int? JobApprover { get; set; }

        public string FromTime { get; set; }

        public string ToTime { get; set; }

        public string TotalTime { get; set; }

        public int? OpeId { get; set; }

        public float? OpeAmt { get; set; }
        public string Edit_Billing_Hrs { get; set; }

        public int? LocId { get; set; }

        public int? NarId { get; set; }

        public DateTime? Date { get; set; }

        public string Status { get; set; }

        public string Satffstatus { get; set; }

        public decimal? Mints { get; set; }

        public bool? Billable { get; set; }

        public string Narration { get; set; }

        public string InvoiceNo { get; set; }

        public DateTime? LastDate { get; set; }

        public float? HourlyCharges { get; set; }

        public string BudgetHours { get; set; }

        public string Reason { get; set; }

        public int? Freezed { get; set; }

        public int? Task_Id { get; set; }

        public int? Project_Id { get; set; }

        public int? Assign_Id { get; set; }

        public int? mJob_Id { get; set; }

        public int? Dept_Id { get; set; }

        public bool? isApprovalRemaining { get; set; }

        public int? EnquiryId { get; set; }

        public decimal? BillableAmt { get; set; }

        public string RoleName { get; set; }

        public string APattern { get; set; }

        public string ClientName { get; set; }

        public string ProjectName { get; set; }

        public string MJobName { get; set; }

        public List<ExpenseTs> list_ExpenseTs { get; set; }
        public List<vw_DrawingMaster> list_Drawing { get; set; }
        public string TaskName { get; set; }

        public string Timesheets { get; set; }

        public string FromDT { get; set; }

        public string ToDT { get; set; }

        public string HolidayDT { get; set; }
        public int TotalCount { get; set; }
        public int Srno { get; set; }
        public string Date1 { get; set; }
        public string Expenses { get; set; }
        public string Halftype { get; set; }
		public string PageName { get; set; }
        public string Drawing { get; set; }
       public int DrawingAllocationId { get; set; }
	      public bool? OnSite { get; set; }
		  public float? ApprovedAmount { get; set; }

        public string ApprovedPattern { get; set; }
		public int AreaId { get; set; }
        public int OrChange { get; set; }
        public int SUbTKid { get; set; }
        public string SubTaskName { get; set; }
        public string AreaName { get; set; }

    }
    public class vw_DrawingMaster
    {
        public Int32 CompId { get; set; }
        public Int32 DrawingId { get; set; }
        public string DrawingName { get; set; }
        public string DrawingNumber { get; set; }
        public string DrawingDesc { get; set; }
        public int TSId { get; set; }
        public int DrawingAllocationId { get; set; }
        public string Revision { get; set; }
        public int ClientId { get; set; }
        public int TotalCount { get; set; }
        public string ClientName { get; set; }
        public int ProjectId { get; set; }
        public string AssignmentName { get; set; }
        public string ProjectName { get; set; }
        public string TargetDate { get; set; }
        public string EndDate { get; set; }
		public  string SubmitDate { get; set; }

    }

    public class tbl_ProjectDrawing
    {
        public int DrawingId { get; set; }
		 public string DrawingName { get; set; }
		 public string DrawingNumber { get; set; }
    }
    public class ExpenseTs
    {
        public int? TsExpId { get; set; }

        public int? ExpId { get; set; }

        public bool? Billable { get; set; }

        public string ExpNarration { get; set; }

        public float? Amt { get; set; }

        public string Attachment { get; set; }

        public int? TSId { get; set; }

        public int ExpAutoId { get; set; }
           public string FileName { get; set; }

        public string ExpName { get; set; }
        public string Currency { get; set; }
    }

    public class TSDiagram
    {
        public int Compid { get; set; }
        public List<tblThumbLogins> list_Pie { get; set; }
        public List<list_weekname> list_line { get; set; }
    }

    public class DB_Graph
    {
        public int Compid { get; set; }
        public string perct { get; set; }
        public List<list_stff_summary> list_line { get; set; }
        public List<tblThumbLogins> list_status { get; set; }
        public List<ApproverList> list_App { get; set; }
        public List<DashboardDetails> list_StatusCounts { get; set; }
    }

    public class tbl_ActivitywiseBudget
    {
        public string Mjobname { get; set; }
        public string Projectname { get; set; }
        public string JobHours { get; set; }
        public string Department { get; set; }
        public string TotalTime { get; set; }
        public string ActualCost { get; set; }
        public string staffname { get; set; }
    }

    public class tbl_StaffwiseBudget
    {
        public string Mjobname { get; set; }
        public string Projectname { get; set; }
        public string staffHours { get; set; }
        public string Staffname { get; set; }
        public string charges { get; set; }
        public string hours { get; set; }
        public string Eff { get; set; }
    }

    public class tbl_ProjectwiseBudget
    {
        public string Client { get; set; }
        public string Projectname { get; set; }
        public string PrjStart { get; set; } 
        public string PrjEnd { get; set; }
        public string BudgAmt { get; set; }
        public string Budghrs { get; set; }
        public string ActulAmt { get; set; }
        public string ActualHrs { get; set; }
        public string Diff { get; set; }
    }

    public class tbl_JobName
    {
        public string mjobName { get; set; }
        public int mjobid { get; set; }
    }
    public class tbl_Client
    {
        public string Clientname { get; set; }
        public int Cltid { get; set; }
    }

    public class tbl_JobClientSummaryReport
    {
        public string Mjobname { get; set; }
        public string client { get; set; }
        public string clientgrp { get; set; }
        public string Dept { get; set; }
        public string Desg { get; set; }
        public string Staffname { get; set; }
        public string Exp { get; set; }
        public string charges { get; set; }
        public string hours { get; set; }
        public string ExpCharges { get; set; }
    }
    public class leave_Management
    {
        public int sino { get; set; }
        public int Leaveid { get; set; }
        public string Leavename { get; set; }
        public string Shortname { get; set; }
        public string OpeningBal { get; set; }
        public string Min { get; set; }
        public string Max { get; set; }
        public int TotalCount { get; set; }
        public string Accumulate_Days { get; set; }
        public string Balance_CF { get; set; }
        public string Balance_CF_Days { get; set; }
        public string Monthly_Allocation { get; set; }
        public string Monthly_Hours { get; set; }
	    public string AllowLessthenZero { get; set; }
        public int wdys { get; set; }
        public List<list_stff_summary> list_Staff { get; set; }
    }

    public class tbl_leave_Alloc
    {
        public int sino { get; set; }
        public int staffcode { get; set; }
        public string StaffName { get; set; }
        public string Email { get; set; }
        public string OpeningBal { get; set; }
        public string Dept { get; set; }
        public string Dsg { get; set; }
        public string Brch { get; set; }
        public string Leave_Taken { get; set; }
        public string Balance { get; set; }
        public int TotalCount { get; set; }
        public int LeaveId { get; set; }
        public int LeaveAllocationId { get; set; }
    }

    public class tbl_leaveStaffdetails
    {
        public string Staff { get; set; }
        public string Joindt { get; set; }
        public List<tbl_leave_Alloc> list_line { get; set; }
    
    }

    public class tbl_Leavedropdwn
    {
        public int compid { get; set ;}
        public List<tbl_Roleswise_staff> list_staff { get; set; }
        public List<leave_Management> list_leave { get; set; }
    }
    public class tbl_Project_Staffwise_Report
    {
        public int SrNo { get; set; }
        public string ProjectName { get; set; }
        public string StaffName { get; set; }
        public string TotalBillable { get; set; }
        public string TotalNonBillable { get; set; }
        public string Others { get; set; }
        public string Total { get; set; }
        public int Totalcount { get; set; }
    }

    public class tbl_companyProfile
    {
        public int compid { get; set; }
        public string CompanyName { get; set; }
        public string Add1 { get; set; }
        public string Add2 { get; set; }
        public string Add3 { get; set; }
        public string City { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Cash { get; set; }
        public string username { get; set; }
        public string password { get; set; }
        public string encryptPassword { get; set; }
        public string Start { get; set; }
        public string Enddate { get; set; }
        public int StaffCount { get; set; }

        public List<tbl_Currency> list_Currency { get; set; }
    }

    public class tbl_LeaveApplication {
        public int sino { get; set; }
            public int ApplicatnID { get; set; }
            public string Leavename { get; set; }
            public string Shortname { get; set; }
            public string AppDt { get; set; }
            public string FrmDt { get; set; }
            public string ToDt { get; set; }
            public string Days { get; set; }
            public string Hours { get; set; }
            public string Status { get; set; }
            public string reason { get; set; }
            public string type { get; set; }
            public int Leavid { get; set; }
            public int TotalCount { get; set; }
            public string Staffname { get; set; }
            public int Employee_ID { get; set; }
            public string Mob { get; set; }
            public string email { get; set; }
    }

    public class JsonDataList_tbl_LeaveAllocation_JsonList
    {
        public List<tbl_LeaveAllocation_Json> jsonData { get; set; }
    }

    public class tbl_LeaveAllocation_Json
    {
        public int CompId { get; set; }
        public int LeaveAllocationId { get; set; }
        public decimal OpeningBalance { get; set; }
        public decimal Balance { get; set; }

    }

    public class tbl_LeaveAppldetail
    {
        public string SN { get; set; }
        public string Min_days { get; set; }
        public string Max_Days { get; set; }
        public string Op_Bal { get; set; }
        public string LeaveTaken { get; set; }
        public string Bal { get; set; }
        public string Dailythrshhold { get; set; }
	public string AllowLessthenZero { get; set; }
    }

    public class tbl_ResourcePlanning_AllocValid
    {
        public int Perhrs { get; set; }

        public List<tbl_ProjectwiseReport> list_Unit { get; set; }
    }

    public class CreateCompany
    {
        public int compid { get; set; }
        public string CompanyName { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string Msg { get; set; }
    }

    public class tbl_Holiday
    {
        public int sino { get; set; }
        public int Holid { get; set; }
        public string HoliName { get; set; }
        public string HoliDate { get; set; }
        public string HoliDate2 { get; set; }
        public string Branch { get; set; }
        public int Brnchid { get; set; }
        public int Totalcount { get; set; }
    }

    public class tbl_GetClientweise_Report
    {
        public string Client { get; set; }
        public string Projectname { get; set; }
        public string staffname { get; set; }
        public string mjobname { get; set; }
        public string hours { get; set; }
        public string Charges { get; set; }
    }

    public class tbl_Utilizationreport
    {
        public string Staff { get; set; }
        public string Dept { get; set; }
        public string d1DM { get; set; }
        public string d2DM { get; set; }
        public string d3DM { get; set; }
        public string d4DM { get; set; }
        public string d5DM { get; set; }
        public string d6DM { get; set; }
        public string d7DM { get; set; }
        public string d8DM { get; set; }
        public string d9DM { get; set; }
        public string d10DM { get; set; }
        public string d11DM { get; set; }
        public string d12DM { get; set; }
        public string d13DM { get; set; }
        public string d14DM { get; set; }
        public string d15DM { get; set; }
        public string d16DM { get; set; }
        public string d17DM { get; set; }
        public string d18DM { get; set; }
        public string d19DM { get; set; }
        public string d20DM { get; set; }
        public string d21DM { get; set; }
        public string d22DM { get; set; }
        public string d23DM { get; set; }
        public string d24DM { get; set; }
        public string d25DM { get; set; }
        public string d26DM { get; set; }
        public string d27DM { get; set; }
        public string d28DM { get; set; }
        public string d29DM { get; set; }
        public string d30DM { get; set; }
        public string d31DM { get; set; }
        public string Tot { get; set; }
    }

    public class tbl_GetLeaveReport
    {
          public string Leave { get; set; }
            public string staff { get; set; }
            public string appdt { get; set; }
            public string strtdt { get; set; }
            public string endt { get; set; }
            public string LevHrs { get; set; }
            public string status { get; set; }
            public string OpnBalc { get; set; }
            public string LevTaken { get; set; }
            public string Balance { get; set; }
			public string Appr { get; set; }
    }
    public class tbl_Leaveweek
    {
        public string Staffname { get; set; }
        public string Desgn { get; set; }
        public string Dept { get; set; }
        public string Leave { get; set; }
        public string start { get; set; }
        public string End { get; set; }
    }

    public class tbl_StaffLeaveweek
    {
        public int Approver { get; set; }
        public List<tbl_Leaveweek> list_leave { get; set; }
    }
	public class tbl_PlanneronLoad
    {
        public int Compid { get; set; }
        public string HrsAllocated { get; set; }
        public int Jid { get; set; }
        public string PlnType { get; set; }
        public int PlnTyid { get; set; }
        public List<tbl_Staff> list_Team { get; set; }
        public List<tbl_Planner_StaffJob> list_stfjob { get; set; }
        public List<tbl_Planner_JobDetails> list_jdtls { get; set; }
        public List<tbl_Budgeting_Allocation_Department_names> list_deptdtls { get; set; }
    }

    public class tbl_PlanneronForStaff
    {
         public List<tbl_Planner_JobDetails> list_jdtls { get; set; }

    }

    public class tbl_Planner_StaffJob
    {
        public int staffcode { get; set; }
        public int jobcnt { get; set; }
        public string StaffName { get; set; }
        public int jobid { get; set; }
        public string MJobName { get; set; }
        public int mJobid { get; set; }
    }

    public class tbl_Planner_JobDetails
    {
        public int staffcode { get; set; }
        public int jobid { get; set; }
        public int Tdays { get; set; }
        public int frDT { get; set; }
        public int toDT { get; set; }
        public string fDT { get; set; }
        public string tDT { get; set; }
        public string Pname { get; set; }
        public int Plid { get; set; }
        public string StaffName { get; set; }
        public float average { get; set; }
        public string comment { get; set; }
        public int mJobid { get; set; }
        public string MJobName { get; set; }
        public double Hours { get; set; }
        public string HrsExtend { get; set; }
        public int ProjectID { get; set; }
        public string ProjectStartDt { get; set; }
        public string ProjectEndDt { get; set; }
        public double HrsAllocated { get; set; }
        public string eff { get; set; }
        public int Pln { get; set; }
        public int Compid { get; set; }
        public string todayeff { get; set; }
        public int Prj_Block { get; set; }
        public string clientName { get; set; }
        public double effortHours { get; set; }
        public int pendingDays { get; set; }
        public string allocatedHours { get; set; }
        public string effort_hour { get; set; }
        public string jobStatus { get; set; }
		public string PLStartDt { get; set; }
        public string PLEndDt { get; set; }
        public string PLSTDt { get; set; }
        public string PLEDDt { get; set; }
		public string Approved { get; set; }
        public string Submitted { get; set; }
        public string Saved { get; set; }
        public string rejected { get; set; }
    }

    public class tbl_GetRecourdConfig
    {
        public bool FmtA { get; set; }
        public bool FmtB { get; set; }
        public bool loc { get; set; } 
		public bool Attch { get; set; } 
        public bool Narr { get; set; }
        public bool exp { get; set; }
        public bool Hidebill { get; set; }
        public bool Rej { get; set; }
        public bool Editbill { get; set; }
        public bool IsFreeze { get; set; }
        public int FreezeDays { get; set; }
        public float DailyHour { get; set; }
        public float weeklyThresh { get; set; }
        public bool Mon { get; set; }
        public bool Tue { get; set; }
        public bool Wed { get; set; }
        public bool Thu { get; set; }
        public bool Fri { get; set; }
        public bool Sat { get; set; }
        public bool Sun { get; set; }
        public bool FutureDT { get; set; }
        public int TSNOTSub { get; set; }
        public string Lvyr { get; set; }
		public string SatHoliday { get; set; }
        public int MinHrs { get; set; }
        public double MaxHrs { get; set; }
        public bool AllowLeave { get; set; }
		public int SendMailLeaveApprover { get; set; }
        public int SendMailLeaveApplication { get; set; }
        public int AutoApprove { get; set; }
        public int SendMailMonthlySummary { get; set; }
        public int RequireTimeSheetApproval { get; set; }
        public int Default_MMDDYYYY { get; set; }
        public int pageLevel { get; set; }
        public bool AllowCheckedInCheckOut { get; set; }
		public int SendMail_Daily_Summary { get; set; }
        

    }

    public class tbl_ResourceAllocRpt
    {
        public string Department { get; set; }
        public string staffname { get; set; }
        public string Desg { get; set; }
        public string Projectname { get; set; }
        public string Approvername { get; set; }
        public string Avg { get; set; }
        public string Bill { get; set; }
        public string NonBill { get; set; }
	    public string Startdt { get; set; }
        public string Endt { get; set; }
        public string JStartdt { get; set; }
        public string JEndt { get; set; }
        public string Wkg { get; set; }
    }
	
	    public class tbl_ProjectRptGrtph
    {
        public int Compid { get; set; }
        public List<tbl_ProjectGrph> list_Grph { get; set; }
        public List<tbl_PrjGrphSummary> list_Summary { get; set; }
    }

    public class tbl_ProjectGrph
    {
        public string project { get; set; }
        public string M1 { get; set; }
        public string M2 { get; set; }
        public string M3 { get; set; }
        public string M4 { get; set; }
        public string M5 { get; set; }
        public string M6 { get; set; }
        public string M7 { get; set; }
        public string M8 { get; set; }
        public string M9 { get; set; }
        public string M10 { get; set; }
        public string M11{ get; set; }
        public string M12 { get; set; }
    }

    public class tbl_PrjGrphSummary
    {
        public string client { get; set; }
        public string Project { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int Staffcount { get; set; }
        public int Deptcount { get; set; }
        public string Totaltime { get; set; }
    }

    public class Skill
    {
        public int SkillId { get; set; }
        public int SINo { get; set; }
        public int? CompId { get; set; }
        public string SkillName { get; set; }
        public string SkillType { get; set; }
        public int TotalCount { get; set; }
    }

    public class Certification
    {
        public int CertificationId { get; set; }
        public int? CompId { get; set; }
        public string CertificationName { get; set; }
        public int TotalCount { get; set; }
    }
    //public class CostSheet_Details
    //{
    //    public int compid { get; set; }
    //    public string EndDate { get; set; }
    //    public string StartDate { get; set; }
    //    public string ProjectName { get; set; }
    //    public float ContractValue { get; set; }
    //    public float StaffCostKeyPersonal { get; set; }
    //    public int StaffCostSupportPersonal { get; set; }
    //}
    //public class CostSheet
    //{
    //    public int Compid { get; set; }
    //    public List<CostSheet_Details> list_CostsheetMaster { get; set; }
    //}

    public class CostSheet
    {
        public int compid { get; set; }
        public string EndDate { get; set; }
        public string StartDate { get; set; }
        public string ProjectName { get; set; }
        public int projectid { get; set; }
        public double ContractValue { get; set; }
        public double TotalCost { get; set; }
        public double HrCharges { get; set; }
        public double HourlyCharges { get; set; }

        //------------------------------------------------------------

        public List<CostSheet> list_CostsheetMaster { get; set; }
    }
	
	public class tbl_ClienwiseProject
    {
        public int Srno { get; set; }
        public string ClientName { get; set; }
        public string ProjectName { get; set; }
        public string TotalHours { get; set; }
        public string Staffname { get; set; }
        public string Jobname { get; set; }
    }

    public class PlanningvsActualMonyhYear
    {
        public double WeekNo { get; set; }
        public string MonthYear { get; set; }
    }

    public class PlanningVsActualDepartmentTotal
    {
        public double WeekNo { get; set; }
        public string MonthYear { get; set; }
        public string DepartmentName { get; set; }
        public double TotalSOW { get; set; }
        public double TotalActual { get; set; }
    }

    public class PlanningVsActualsStaffTotal
    {
        public double WeekNo { get; set; }
        public string MonthYear { get; set; }
        public string StaffCode { get; set; }
        public string StaffName { get; set; }
        public string DepartmentName { get; set; }
        public double TotalSOW { get; set; }
        public double TotalActual { get; set; }
    }
    public class PlanningVsActualReport
    {

        public string StaffCode { get; set; }
        public string StaffName { get; set; }
        public string ProjectName { get; set; }
        public string DepartmentName { get; set; }
        public int ProjectID { get; set; }
        public int DepartmentID { get; set; }
        public double WeekNo { get; set; }
        public double SOW { get; set; }
        public double TotalActual { get; set; }
        public string MonthYearName { get; set; }
        public string EngagementFrom { get; set; }
        public string EngagementTo { get; set; }
    }
	public class tbl_ProjectManagers
    {
        public int StaffCode { get; set; }
        public int StaffRoll { get; set; }
        public string StaffName { get; set; }
        public int RoleId { get; set; }
        public string RoleName { get; set; }
        public string isChecked { get; set; }
    }
	public class tbl_ProjectMilestone
    {
        public int ProjectMilestoneId { get; set; }
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public int MilestoneId { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Status { get; set; }
        public int MilestoneStatusId { get; set; }
        public string MilestoneName { get; set; }
    }
	public class ProjectMilestoneMaster
    {
        public List<Project_master> list_ProjectMaster { get; set; }
        public List<tbl_Milestone> list_MilestoneMaster { get; set; }
        public List<tbl_ProjectMilestone> list_ProjectMilestone { get; set; }
    }
	public class tbl_StaffImage
    {
        public int ImgId { get; set; }
        public string ImagePath { get; set; }
    }
	 public class menumaster
    {
        public string SubName { get; set; }
        public int? GROUP_ID { get; set; }
        public string Name { get; set; }
        public string Menu_Title { get; set; }
        public string MIcon { get; set; }
        public string PageName { get; set; }
        public int? pagemenuid { get; set; }
        public string SubMenu { get; set; }
        public string ID { get; set; }
        public int SelectedStaffPageMenuId { get; set; }
    }
    public class SimpleMenuMaster
    {
        public string MenuId { get; set; }
        public string MenuTitle { get; set; }
        public string ParentMenuId { get; set; }
        public string ParentMenuTitle { get; set; }
        public bool IsValidPermissionItem { get; set; }
        public bool Checked { get; set; }
    }

    public class tbl_PlanningVsActual_Report
    {
        public double WeekNo { get; set; }
        public string MonthYear { get; set; }
        public List<PlanningVsActualDepartmentTotal> list_PlanningVsActualDepartmentTotal { get; set; }
        public List<PlanningVsActualsStaffTotal> list_tblPlanningVsActualsStaffTotal { get; set; }
        public List<PlanningVsActualReport> list_PlanningVsActualReport { get; set; }
    }
	public class Departement_Report 
    {
        public Int32 TotalCount { get; set; }
        public Int32 sino { get; set; }
        public string DeptName { get; set; }
        public string Date { get; set; }
        public string DayName { get; set; }
        public string ClientName { get; set; }
        public string ProjectName { get; set; }
        public string ResourceName { get; set; }
        public string JobName { get; set; }
        public string TaskDescription { get; set; }
        public string ActualHours { get; set; }
        public string BillingHours { get; set; }
        public string TotalActualHours { get; set; }
        public string TotalBillingHours { get; set; }
        public decimal BudgetedHours { get; set; }
        public string ScopeofWork { get; set; }
        public string Reason { get; set; }
        public string NonBillingHours { get; set; }
		public string ProjectId { get; set; }
        public string ProjectStatus { get; set; }
    }
	public class ListClient
    {
        public int CliendId { get; set; }
        public string ClientName { get; set; }
    }
	public class tbl_Staff_Effort
    {
        public string StaffCode { get; set; }
        public string StaffName { get; set; }
        public string TimeType { get; set; }
        public decimal Day1 { get; set; }
        public decimal Day2 { get; set; }
        public decimal Day3 { get; set; }
        public decimal Day4 { get; set; }
        public decimal Day5 { get; set; }
        public decimal Day6 { get; set; }
        public decimal Day7 { get; set; }
        public decimal Day8 { get; set; }
        public decimal Day9 { get; set; }
        public decimal Day10 { get; set; }
        public decimal Day11 { get; set; }
        public decimal Day12 { get; set; }
        public decimal Day13 { get; set; }
        public decimal Day14 { get; set; }
        public decimal Day15 { get; set; }
        public decimal Day16 { get; set; }
        public decimal Day17 { get; set; }
        public decimal Day18 { get; set; }
        public decimal Day19 { get; set; }
        public decimal Day20 { get; set; }
        public decimal Day21 { get; set; }
        public decimal Day22 { get; set; }
        public decimal Day23 { get; set; }
        public decimal Day24 { get; set; }
        public decimal Day25 { get; set; }
        public decimal Day26 { get; set; }
        public decimal Day27 { get; set; }
        public decimal Day28 { get; set; }
        public decimal Day29 { get; set; }
        public decimal Day30 { get; set; }
        public decimal Day31 { get; set; }
        public decimal Total { get; set; }
        public decimal AvgEfficiency { get; set; }
        public string Designation { get; set; }
        public int EmpId { get; set; }
        public string DateOfJoining { get; set; }
        public string DateOfLeaving { get; set; }
        public string EmpType { get; set; }
        public string DepartmentName { get; set; }
        public string staffBioServerid { get; set; }
        public int DeptId { get; set; }
    }
    public class tbl_MinimumHrsEffort
    {
        public decimal? CompanyThresold { get; set; }
        public List<tbl_Staff_Effort> tbl_Staff_Effort { get; set; }
    }
    public class ProjectMaster
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
    }
	public class HolidaysMaster
    {
        public tbl_Weekly_Holidays weeklyHolidays { get; set; }
        public List<tbl_Monthly_Holidays> list_Monthly_Holidays { get; set; }
    }
    public class Drawing_Staff
    {
        public int EmpId { get; set; }
        public string EmpName { get; set; }
        public int IsChecked { get; set; }
    }
    public class Drawing_Allocation
    {
         public int Drw_All_Id { get; set; }
        public int ProjectId { get; set; }
        public int ClientId { get; set; }
        public int Act_Id { get; set; }
        public int Sub_Act_Id { get; set; }
        public int Drawing_Id { get; set; }
        public string StartDate { get; set; }
        public string Revision { get; set; }
        public string EndDate { get; set; }
        public string TargetDate { get; set; }
        public string DrawingNumber { get; set; }
        public string Remark { get; set; }
        public string DrawingName { get; set; }
        public string ActivityName { get; set; }
        public int DrawingAllocationIdTimeSheet { get; set; }
    }
    public class tbl_Drawing_Details
    {
        public int Pid { get; set; }
        public string DrawingNumber { get; set; }
		 public string DrawingName { get; set; }
    }

    public class tbl_Drawing
    {
        public int Compid { get; set; }
        public int DrwId { get; set; }
        public int drw_act_id { get; set; }
        public string DrawingNo { get; set; }
        public List<Drawing_Allocation> drwAllocation = new List<Drawing_Allocation>();

    }

    public class tbl_Weekly_Holidays
    {
        public bool Sun { get; set; }
        public bool Mon { get; set; }
        public bool Tue { get; set; }
        public bool Wed { get; set; }
        public bool Thu { get; set; }
        public bool Fri { get; set; }
        public bool Sat { get; set; }
    }
    public class tbl_Monthly_Holidays
    {
        public string HolidayDate { get; set; }
            public string HolidayName { get; set; }
            public bool IsUpcoming { get; set; }
    }
	public class tbl_ClientProjectReport
    {
        public string Client { get; set; }
        public string Project { get; set; }
        public string TimeType { get; set; }
        public decimal Day1 { get; set; }
        public decimal Day2 { get; set; }
        public decimal Day3 { get; set; }
        public decimal Day4 { get; set; }
        public decimal Day5 { get; set; }
        public decimal Day6 { get; set; }
        public decimal Day7 { get; set; }
        public decimal Day8 { get; set; }
        public decimal Day9 { get; set; }
        public decimal Day10 { get; set; }
        public decimal Day11 { get; set; }
        public decimal Day12 { get; set; }
        public decimal Day13 { get; set; }
        public decimal Day14 { get; set; }
        public decimal Day15 { get; set; }
        public decimal Day16 { get; set; }
        public decimal Day17 { get; set; }
        public decimal Day18 { get; set; }
        public decimal Day19 { get; set; }
        public decimal Day20 { get; set; }
        public decimal Day21 { get; set; }
        public decimal Day22 { get; set; }
        public decimal Day23 { get; set; }
        public decimal Day24 { get; set; }
        public decimal Day25 { get; set; }
        public decimal Day26 { get; set; }
        public decimal Day27 { get; set; }
        public decimal Day28 { get; set; }
        public decimal Day29 { get; set; }
        public decimal Day30 { get; set; }
        public decimal Day31 { get; set; }
        public decimal Total { get; set; }
        public string ScopeofWork { get; set; }
    }
	public class tbl_ClientwiseProjects
    {
        public int ClientId { get; set; }
        public string Date { get; set; }
        public string Project { get; set; }
        public decimal TotalTime { get; set; }
        public decimal ActualTime { get; set; }
        public string DayofMonth { get; set; }
        public int TotalCount { get; set; }
    }
    public class tbl_Clients_Dept
    {
        public int ClientId { get; set; }
        public string ClientName { get; set; }
    }

    public class Activity_Dtl
    {
        public string status { get; set; }
        public string ttime { get; set; }
        public List<tbl_DepartmentBudgeting> list_Dept { get; set; }
        public List<tbl_Projectstaff_Budg> list_Project { get; set; }
        public List<Departmentwise_Approver_staff> list_Staff { get; set; }
        public List<AssignDeptProjectActivity> list_Assign { get; set; }

    }
    public class AssignDeptProjectActivity
    {
        public int MjobId { get; set; }
        public int AssignId { get; set; }
        public int ProjectId { get; set; }
        public int StaffCode { get; set; }
        public int DeptId { get; set; }
        public string ProjectName { get; set; }
        public string StaffName { get; set; }
        public string DepartmentName { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string Hrs { get; set; }

    }
    public class tbl_ReportTo
    {
        public int StaffCode { get; set; }
        public string StaffName { get; set; }
    }
    public class tbl_Staffs_Dept
    {
        public int StaffId { get; set; }
        public string StaffName { get; set; }
    }
    public class tbl_ResourceDetailedReport
    {
        public decimal TotalTime { get; set; }
        public decimal ActualTime { get; set; }
        public decimal AvailableTime { get; set; }
        public int NoOfProjects { get; set; }
        public int NoOfClients { get; set; }
    }
	public class vw_ProjectInputs
    {
        public string BillableHours { get; set; }
        public Int32 ProjectID { get; set; }
        public Int32 CLTId { get; set; }
        public Int32 pageIndex { get; set; }
        public Int32 pageNewSize { get; set; }
        public Int32 InputCounts { get; set; }
        public int TotalCount { get; set; }
        public string ProjectName { get; set; }
        public string ClientName { get; set; }
        public int SrNo { get; set; }
    }
    public class InputSummaryClient
    {
        public int ClientID { get; set; }
        public string ClientName { get; set; }

    }
    public class InputSummaryProject
    {
        public int ProjectID { get; set; }
        public string ProjectName { get; set; }

    }
    public class vw_InputsSummary
    {
        public DateTime ReceivedDate { get; set; }
        public Int32 ProjectID { get; set; }
        public Int32 CLTId { get; set; }
        public Int32 pageIndex { get; set; }
        public Int32 pageNewSize { get; set; }
        public string ReceivedInput { get; set; }
        public string TaskSummary { get; set; }
        public string SubmissionMade { get; set; }
        public int InputId { get; set; }
        public int SrNo { get; set; }
        public string BillableHours { get; set; }
        public int TotalCount { get; set; }
    }
	public class vw_InputsSummaryHeader
    {

         public Int32 ProjectID { get; set; }
        public Int32 CLTId { get; set; }
        public string ProjectName { get; set; }
        public string DeptName { get; set; }
        public string ClientName { get; set; }
        public string ScopeOfWork { get; set; }
        public string BudgetHours { get; set; }
        public string  TotalBilledHours { get; set; }
        public double ConsumePercentage { get; set; }
        public double ProjectHours { get; set; }
		public string ProjectCode { get; set; }

    }
	public class tbl_ActualBudgetedReport
    {
        public string ClientName { get; set; }
        public string ProjectName { get; set; }
        public string StaffName { get; set; }
        public string Designation { get; set; }
        public string Department { get; set; }
        public decimal ActualHrs { get; set; }
        public decimal BudgetedHrs { get; set; }
        public decimal DifferenceHrs { get; set; }
        public int DifferencePercentage { get; set; }
    }
	public class RoleApproverClient
    {
        public int ClientID { get; set; }
        public string ClientName { get; set; }

    }
    public class RoleApproverProject
    {
        public int ProjectID { get; set; }
        public string ProjectName { get; set; }

    }

    public class ApprovalAllocationProject
    {
        public int ProjectID { get; set; }
        public string ProjectName { get; set; }

    }
	public class tbl_StaffInfo
    {
        public int Staffcode { get; set; }
        public string Staffname { get; set; }
        public string Desgn { get; set; }
        public string Dept { get; set; }
        public string Approver { get; set; }
        public int SrNo { get; set; }
    }
	public class OverallEffort_Vs_Selected_Report
    {
        public int ProjectID { get; set; }
        public string ProjectName { get; set; }
        public string ClientName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int TotalApproved { get; set; }
        public int TotalSubmitted { get; set; }
        public int TotalSaved { get; set; }
        public int TotalRejected { get; set; }
        public int MonthApproved { get; set; }
        public int MonthSubmitted { get; set; }
        public int MonthSaved { get; set; }
        public int MonthRejected { get; set; }
        public int TotalCount { get; set; }
    }
    public class StaffAttendanceLog
    {
        public string StaffCode { get; set; }
        public DateTime CheckInOn { get; set; }
        public DateTime BreaktimeOn { get; set; }
        public string currentStatus { get; set; }
        public int CompId { get; set; }
    }
    public class tbl_Monthly_Attendance
    {
        public string AttenDate { get; set; }
        public string CheckInTime { get; set; }
        public string CheckOutTime { get; set; }
        public string CheckInLocation { get; set; }
        public string CheckOutLocation { get; set; }
        public string CheckInDevice { get; set; }
        public string CheckOutDevice { get; set; }
        public string ClockedTime { get; set; }

        public bool IsMobileDeviceCheckOut { get; set; }
        public bool IsMobileDeviceCheckIn { get; set; }
		public string staffname { get; set; }
        public string designation { get; set; }
public string department { get; set; }
    }
	
	public class DailyTimesheetInputEffort
    {
        public string DayEffort { get; set; }
        public string WeekEffort { get; set; }

        public string TotalEffort { get; set; }


    }
     public class vw_ExpenseSummary
    {
        public Boolean Billable { get; set; }
        public Int32 ProjectID { get; set; }
        public Int32 ExpAutoId { get; set; }
        public Int32 pageIndex { get; set; }
        public Int32 pageNewSize { get; set; }
        public string ExpNarration { get; set; }
        public DateTime EntryDate { get; set; }
        public string EntryDateStr { get; set; }
        public string ProjectName { get; set; }
        public string Currency { get; set; }
        public string ExpType { get; set; }
        public int ExpId { get; set; }
        public int SrNo { get; set; }
        public string Amt { get; set; }
        public int TotalCount { get; set; }
    }
	

    public class tbl_ProjectGraph
    {
        public string d1 { get; set; }
        public string d2 { get; set; }
        public string d3 { get; set; }
        public string d4 { get; set; }
        public string d5 { get; set; }
        public string d6 { get; set; }
        public string d7 { get; set; }
        public string d8 { get; set; }
        public string d9 { get; set; }
        public string d10 { get; set; }
        public string d11 { get; set; }
        public string d12 { get; set; }
        public string Total { get; set; }
    }

    public class tbl_MileStone
    {
        public int Compid { get; set; }
        public int Mile_Id { get; set; }
        public string MileStone { get; set; }
    }	
	public class tbl_branchProject
    {
        public int Project_Id { get; set; }
        public string ProjectName { get; set; }
           }
		   
		  public class WorkOrder_VM
    {
        public int WorkOrderId { get; set; }
        public string WONumber { get; set; }
        public int ProjectId { get; set; }
        public string ProjectCode { get; set; }
        public string WODate { get; set; }
        public decimal WOAmount { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string Configuration { get; set; }
        public int WOStatusId { get; set; }
        public string WOStatus { get; set; }
        public string Comment { get; set; }
        public int WorkStatusPercentage { get; set; }
        public string ProjectName { get; set; }
        public string ClientName { get; set; }
        public int ClientId { get; set; }
        public decimal InvoiceAmount { get; set; }
        public decimal PaymentReceived { get; set; }
        public int Totalcount { get; set; }
        public string ProjectManager { get; set; }
        public decimal BalanceAmount { get; set; }
        public int WorkOrderSteps { get; set; }
        public int? PurchaseOrdersCount { get; set; }
        public int? InvoicesCount { get; set; }
        public decimal? InvoicesSumTotalAmount { get; set; }
    }

    public class WorkOrderStatus_VM
    {
        public int WorkOrderStatusId { get; set; }
        public string WorkOrderStatus { get; set; }
    }

    public class WorkOrderMilestone_VM
    {
        public int MilestoneId { get; set; }
        public string MilestoneTitle { get; set; }
        public string MilestoneStartDate { get; set; }
        public string MilestoneEndDate { get; set; }
        public int MilestoneCompletePercentage { get; set; }
    }

    public class PurchaseOrderMilestone_VM
    {
        public int MilestoneId { get; set; }
        public string MilestoneTitle { get; set; }
        public string MilestoneStartDate { get; set; }
        public string MilestoneEndDate { get; set; }
        public int MilestoneCompletePercentage { get; set; }
        public string PurchaseOrderNo { get; set; }
    }

    public class PurchaseOrderStatus_VM
    {
        public int PurchaseOrderStatusId { get; set; }
        public string PurchaseOrderStatus { get; set; }
    }
    public class WorkOrderStatus_Project
    {
        public int ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string ClientName { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public string ProjCode { get; set; }

    }

    public class PurchaseOrder_VM
    {
        public int PurchaseOrderId { get; set; }
        public int WorkOrderId { get; set; }
        public string PONumber { get; set; }
        public string PODate { get; set; }
        public decimal POAmount { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int POStatusId { get; set; }
        public string POStatus { get; set; }
        public int POMilestoneId { get; set; }
        public decimal POTotalAmount { get; set; }
    }

    public class PurchaseOrders
    {
        public List<PurchaseOrder_VM> PurchaseOrder_VMList { get; set; }
        public decimal POTotalAmount { get; set; }
    }

    public class PurchaseOrderInvoice_VM
    {
        public int InvoiceId { get; set; }
        public int PurchaseOrderId { get; set; }
        public string PurchaseOrderNo { get; set; }
        public string InvoiceNo { get; set; }
        public string InvoiceDate { get; set; }
        public decimal Discount { get; set; }
        public string GST { get; set; }
        public decimal GSTPercentage { get; set; }
        public decimal TotalAmount { get; set; }
        public string TermConditions { get; set; }
        public List<PurchaseOrderInvoiceItem_VM> InvoiceItems { get; set; }
        public int WorkOrderId { get; set; }
    }

    public class PurchaseOrderInvoiceItem_VM
    {
        public int InvoiceItemId { get; set; }
        public int InvoiceId { get; set; }
        public string Description { get; set; }
        public int Quantity { get; set; }
        public decimal Amount { get; set; }
    }


    public class InvoiceReceipt_VM
    {
        public int ReceiptId { get; set; }
        public int WorkOrderId { get; set; }
        public int InvoiceId { get; set; }
        public string ReceiptNumber { get; set; }
        public string ReceiptDate { get; set; }
        public decimal ReceiptAmount { get; set; }
    }
	
	
	
	public class tbl_ProjectAnalysis
    {
        public int srno { get; set; }
        public string PrjCode { get; set; }
        public string Project { get; set; }
        public string Client { get; set; }
        public string Start { get; set; }
        public string End { get; set; }
        public string PrjManager { get; set; }
        public string Quote { get; set; }
        public string Budget { get; set; }
        public string Actual { get; set; }
        public string ActualPer { get; set; }
        public string totCount { get; set; }
    }
	
	public class tbl_ProjectBlocking
    {
        public string DT { get; set; }
        public string Cdt { get; set; }
        public int Staffcode { get; set; }
    }
	
	public class DataItem
    {
        public string DVal { get; set; }
        public string chartImage { get; set; }
    }
	
	public class TimeLogs
    {
        public string Id { get; set; }
        public DateTime EntryDate { get; set; }
        public string ProjectCode { get; set; }
        public string Jobid { get; set; }
        public bool Billable { get; set; }
        public string Narration { get; set; }
        public DateTime CheckIn { get; set; }
        public DateTime CheckOut { get; set; }
        public string TotalTM { get; set; }
        public int BrId { get; set; }
    }

    public class TimeLogOutput
    {
        public string Id { get; set; }
        public string ProjectCode { get; set; }
        public string Jobid { get; set; }
        public bool Billable { get; set; }
        public string CheckOut { get; set; }
        public string Narration { get; set; }
        public string CurrentTime { get; set; }
        public string DayTime { get; set; }
        public string WeekTime { get; set; }
    }

}



