<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProjectandStaff_Budgeting.ascx.cs" Inherits="controls_ProjectandtStaff_Budgeting" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<script src="../jquery/dist/jquery.contextMenu.js" type="text/javascript"></script>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<link href="../jquery/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />

<%--for selectize--%>
<script src="../jquery/Selectize/selectize.js" type="text/javascript"></script>
<script src="../jquery/Selectize/es5.js" type="text/javascript"></script>
<script src="../jquery/Selectize/index.js" type="text/javascript"></script>
<link href="../jquery/Selectize/normalize.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        FillBudgGrid();
        $("[id*=dvupdate]").hide();
        $("[id*=btnSave]").hide();
        $("[id*=btnUpdate]").hide();
        $("[id*=hdnProjectBudgetingtemp]").val('0');

        $("[id*=drpclient]").on('change', function () {
            FillProject(0);
        });

        $("[id*=drpProject]").on('change', function () {
            var Job = $("[id*=drpProject]").val();
            var id = Job.split(',');
            if (Job == 0) {
                $("[id*=tblStaff]").empty();
                $("[id*=lbltotbudgAmt]").html('0');
                $("[id*=lbltotbudghrs]").html('0');
            } else {
                var count = id[2];
                $("[id*=txtstffcount]").val(count);
                Stfftbl(count, 0);
                ProjBudg();
            }

        });

        $("[id*=btnSave]").on('click', function () {
            var type = $("[id*=drpBudgType]").val();
            var dt = $("[id*=txteditProjBudgetedDate]").val();
            if (dt == "") {
                return alert("Kindly select the Budgeted Date!!!");
            }
            else {
                if (type == 'Project') {
                    SavetheProjBudgetFirst();
                }
                else if (type == 'Staff') {
                    SaveStaffBudget();
                }
                else if (type == 'both') {
                    SavetheProjBudgetFirst();
                }
                else if (type == '0') {
                    $("[id*=divprojectBudget]").hide();
                    $("[id*=dvStaffBudget]").hide();
                }
                $("[id*=dvAddProject]").hide();
                $("[id*=dvBudgetGrid]").show();
                $("[id*=dvupdate]").hide();

            }
        });

        $("[id*=btnStaffclr]").on('click', function () {
            $("[id*=txtjustshowingdate]").val('');
            $("[id*=TextBox2]").val('0');
            $("[id*=txteditHourlyAmount]").val('0');
            $("[id*=txtAllocatedHrs]").val('0');
            $("[id*=hdnStaffBudgetingtemp]").val('0');
            return false;
        });

        $("[id*=btnAdd]").on('click', function () {
            $("[id*=dvAddProject]").show();
            $("[id*=dvBudgetGrid]").hide();
            $("[id*=dvupdate]").show();
            $("[id*=btnSave]").show();
            $("[id*=btnUpdate]").hide();
            reset();
        });

        $("[id*=drpBudgType]").on('change', function () {
            Budgettypetoggle();
        });

        $("[id*=btnCancel]").on('click', function () {
            CancelDeltemp();
            $("[id*=dvAddProject]").hide();
            $("[id*=dvBudgetGrid]").show();
            $("[id*=dvupdate]").hide();
        });

        $("[id*=btnEditSave]").live('click', function () {
            var datea = $("[id*=txteditStaffBudgetedDate]").val();
            var hideid = $("[id*=hdnProjectBudgetingtemp]").val();
            if (datea != "") {
                var start = $("[id*=txtProjDate]").val();
                var fa = start.split('/')
                var ta = datea.split('/')

                var a = new Date(fa[2], fa[1] - 1, fa[0]);
                var d = new Date(ta[2], ta[1] - 1, ta[0]); // for dd-MM-yyyy

                if (hideid > 0) {
                    $('.loader2').fadeIn(200); SetJobWiseBudgetDetails();
                } else {
                    if (a > d) {
                        alert("Date Must be greater than Project Start Date !");
                        return false;
                    }
                    else {
                        $('.loader2').fadeIn(200); SetJobWiseBudgetDetails();
                    }
                }
            }
            else { alert('Please Enter Date !'); }
            return false;
        });


        //budget clear button
        $("[id*=btnClear]").live('click', function () {
            $("[id*=txteditBudgetHours]").val('0');
            $("[id*=txteditBudgetAmt]").val('0');
            $("[id*=txteditStaffBudgetedDate]").val('');
            return false;
        });

        $("[id*=btnUpdate]").on('click', function () {
            UpdateBudget();
        });

        $("[id*=btnSearch]").on('click', function () {
            SecoundBudgGrid();
        });

        /////////////////////tab staff budgeting, edit on staff budget
        $("[id*=btnEditedStaffBudgetdAmtHours]").live('click', function () {
            var hideid = $("[id*=hdnStaffBudgetingtemp]").val();
            
            var datea = $("[id*=txtjustshowingdate]").val();
            if (datea != "") {
                //var start = $("[id*=txteditProjBudgetedDate]").val();
                //var fa = start.split('/')
                //var ta = datea.split('/')

                //var a = new Date(fa[2], fa[1] - 1, fa[0]);
                //var d = new Date(ta[2], ta[1] - 1, ta[0]); // for dd-MM-yyyy
                if (hideid > 0) {
                    $('.loader2').fadeIn(200);
                    SaveOrUpeateDateBudget();
                }
                else {
                    //if (a > d) {
                    //    alert("Date Must be greater than Project Start Date !");
                    //    return false;
                    //}
                    //else {
                    SaveOrUpeateDateBudget();
                    //}
                }
            }
            else { alert('Please Enter Date !'); }
            return false;
        });



    });

    ///delete the temp table
    function CancelDeltemp() {
        var compid = $("[id*=hdnCompanyid]").val();
        var job = $("[id*=drpProject]").val()
        var ids = job.split(',');
        var jobid = ids[0];
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/CancelDeltemp",
            data: '{jobid:' + jobid + ',compid:' + compid + '}',
            dataType: "json",
            success: function (msg) {
                var mylist = jQuery.parseJSON(msg.d);
                if (mylist[0].id > 0) {
                }
            }
        });
    }


    //updateing multiple value into the both project and staff table
    function UpdateBudget() {
        var type = $("[id*=drpBudgType]").val();
        var compid = $("[id*=hdnCompanyid]").val();
        var job = $("[id*=drpProject]").val()
        var ids = job.split(',');
        var jobid = ids[0];
        var Projectid = ids[1];
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/Update_ProjectStaff",
            data: '{jobid:' + jobid + ',compid:' + compid + ',type:"' + type + '",projectid:' + Projectid + '}',
            dataType: "json",
            success: function (msg) {
                var mylist = jQuery.parseJSON(msg.d);
                if (mylist.length > 0) {
                    alert("Project Budget Updated Successfully !!!")
                    SecoundBudgGrid();
                    $("[id*=dvAddProject]").hide();
                    $("[id*=dvBudgetGrid]").show();
                    $("[id*=dvupdate]").hide();
                }
            }
        });
    }

    ///saving Project budget temp record
    function SetJobWiseBudgetDetails() {
        var job = $("[id*=drpProject]").val()
        var ids = job.split(',');
        var jobid = ids[0];
        var data = {
            id: {
                StaffCode: 0,
                BudgetAmt: $("[id*=txteditBudgetAmt]").val(),
                Budgethours: $("[id*=txteditBudgetHours]").val(),
                temp_Id: $("[id*=hdnProjectBudgetingtemp]").val(),
                fromdate: $("[id*=txteditStaffBudgetedDate]").val(),
                jobid: jobid,
                compid: $("[id*=hdnCompanyid]").val()
            }
        };
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/SetServerJobWiseBudgetDetails",
            data: JSON.stringify(data),
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length > 0) {
                    if (myList[0].StaffCode == 'Error') {
                        alert('From Date Must Be Greater Than !');
                        $('.loader2').fadeOut(200);
                    }
                    else {
                        OnSuccess2(myList);
                        alert('Save Successfully !');
                    }
                }
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
    }

    function Staffpopup(list) {
        clareformEditStaffbudget();
        $("[id*=tblstfflast]").append("<tr class='mytable'><th>Sr.No</th><th>From Date</th><th>To Date</th><th>Budgeted Hours</th><th>Allocated Hours</th><th>Budgeted Hourly Charges</th><th>Staff Actual Hour Rate</th><th>Edit</th></tr>");
        if (list.length > 0) {
            for (var i = 0; i < list.length; i++) {
                $("[id*=tblstfflast]").append("<tr class='mytable'><td style='text-align: center;'>" +
                            (i + 1) + "</td><td width='80px'>" + //sr no
                            list[i].fromdate + "</td> <td width='80px'>" + //FromDate
                            list[i].todate + "</td> <td style='text-align: right;'>" + //Todate
                            list[i].Budgethours + "</td> <td style='text-align: right;'>" + //Budget Amount
                            list[i].AllocatedHours + "</td> <td style='text-align: right;'>" +
                            list[i].BudgetAmt + "</td> <td style='text-align: right;'>" +
                            list[i].StaffActualHourRate + "</td >" + //Hours
                            "<td><img src='../images/edit.png' style='cursor:pointer;' onclick=updatestaff(" + list[i].temp_Id + ") ></td></tr>");

            }
        }
        else {
            $("[id*=tblstfflast]").append("<tr><td style='height:20px; border:1px solid #BCBCBC;' colspan='15'>No Records Found !</td></tr>");
        }
        $('.loader2').fadeOut(550);
    }

    function OnSuccess2(response) {
        clareformEditProjectbudget();
        $("[id*=tblPrevous]").append("<tr class='mytable'><th>Sr.No</th><th>From Date</th><th>To Date</th><th>Budgeted Amount</th><th>Budgeted Hours</th><th>Edit</th></tr>");
        if (response.length > 0) {
            for (var i = 0; i < response.length; i++) {
                $("[id*=tblPrevous]").append("<tr class='mytable'><td style='text-align: center;'>" +
                            (i + 1) + "</td><td width='80px'>" + //sr no
                            response[i].fromdate + "</td> <td width='80px'>" + //FromDate
                            response[i].todate + "</td> <td style='text-align: right;'>" + //Todate
                            response[i].BudgetAmt + "</td> <td style='text-align: right;'>" + //Budget Amount
                            response[i].Budgethours + "</td >" + //Hours
                            "<td><img src='../images/edit.png' style='cursor:pointer;' onclick=updatedata2(" + response[i].temp_Id + ") ></td></tr>");

                //Set Updated Amount & hours
                if (response[i].todate == '') {
                    $("[id*=txtHrsf]").val(response[i].Budgethours);
                    $("[id*=txtAmtf]").val(response[i].BudgetAmt);
                }
            }
        }
        else {
            $("[id*=tblPrevous]").append("<tr><td style='height:20px; border:1px solid #BCBCBC;' colspan='15'>No Records Found !</td></tr>");
        }
        $('.loader2').fadeOut(550);
    }

    ///edit staff budget popup
    function updatestaff(id) {
        $('.loader').fadeIn(200);
        $("[id*=hdnStaffBudgetingtemp]").val(id);
        var data = {
            id: {
                StaffCode: 0,
                BudgetAmt: 0,
                Budgethours: 0,
                temp_Id: id,
                fromdate: 0
            }
        };
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/GetTempIDStaffDetails",
            data: JSON.stringify(data),
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length > 0) {
                    $("[id*=txtjustshowingdate]").val(myList[0].fromdate);
                    $("[id*=TextBox2]").val(myList[0].Budgethours);
                    $("[id*=txteditHourlyAmount]").val(myList[0].BudgetAmt);
                    $("[id*=txtAllocatedHrs]").val(myList[0].AllocatedHours);
                    $("[id*=txtStaffActualRateForJob]").val(myList[0].StaffActualHourRate);
                }
                $('.loader').fadeOut(550);
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
    }

    //popup project budget temp data
    function GetJobWiseBudgetDetails() {
        //Ajax start
        var Job = $("[id*=drpProject]").val();
        var id = Job.split(',');
        var Jobid = id[0];
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/GetServerJobWiseBudgetDetails",
            data: "{jobid:" + Jobid + ",compid:" + $("[id*=hdnCompanyid]").val() + "}",
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                OnSuccess2(myList);
            },
            failure: function (response) {
            },
            error: function (response) {
            }
        });
        //Ajax end
    }


    //save the temp value into temp table staff budgets
    function SaveOrUpeateDateBudget() {
        $('.loader').fadeIn(200);
        var staffcode = $("[id*=hdnstaffcodetemp]").val();
        var Job = $("[id*=drpProject]").val();
        var id = Job.split(',');
        var Jobid = id[0];
        if (staffcode != "") {
            var data = {
                id: {
                    StaffCode: staffcode,
                    BudgetAmt: $("[id*=txteditHourlyAmount]").val(),
                    Budgethours: $("[id*=TextBox2]").val(),
                    temp_Id: $("[id*=hdnStaffBudgetingtemp]").val(),
                    fromdate: $("[id*=txtjustshowingdate]").val(),
                    PlanedDrawing: 0,
                    AllocatedHours: $("[id*=txtAllocatedHrs]").val(),
                    StaffActualHourRate: $("[id*=txtStaffActualRateForJob]").val(),
                    jobid: Jobid,
                    compid: $("[id*=hdnCompanyid]").val()
                }
            };
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/ProjectandStaff_Budgeting.asmx/SaveOrUpdateBudget",
                data: JSON.stringify(data),
                dataType: "json",
                success: function (msg) {
                    var mylist = jQuery.parseJSON(msg.d);
                    if (mylist.length > 0) {
                        if (mylist[0].StaffCode == 'Error') {
                            alert('From Date Must Be Greater Than !');
                            $('.loader').fadeOut(200);
                        }
                        else {
                            Staffpopup(mylist);
                            alert('Save Successfully !');
                        }
                    }
                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //Ajax end
        }
    }

    function GetStafftempdata(staffid) {
        var Job = $("[id*=drpProject]").val();
        var id = Job.split(',');
        var Jobid = id[0];
        var staffcode = staffid;
        $("[id*=hdnstaffcodetemp]").val(staffid);
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/GetStafftempdata",
            data: "{jobid:" + Jobid + ",compid:" + $("[id*=hdnCompanyid]").val() + ",staffcode:" + staffcode + "}",
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                Staffpopup(myList);
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
    }

    //clear the popup projectbudget
    function clareformEditProjectbudget() {
        $("[id*=tblPrevous]").empty();
        $("[id*=txteditBudgetHours]").val('0');
        $("[id*=txteditBudgetAmt]").val('0');
        $("[id*=txteditStaffBudgetedDate]").val('');
        $("[id*=hdnProjectBudgetingtemp]").val('0');
    }
    //clear the popup staffbudget
    function clareformEditStaffbudget() {
        $("[id*=tblstfflast]").empty();
        $("[id*=TextBox2]").val('0');
        $("[id*=txteditHourlyAmount]").val('0');
        $("[id*=txtAllocatedHrs]").val('0');
        $("[id*=txtjustshowingdate]").val('');
        $("[id*=hdnStaffBudgetingtemp]").val('0');
    }

    function updatedata2(id) {
        $('.loader2').fadeIn(200);
        $("[id*=hdnProjectBudgetingtemp]").val(id);
        var data = {
            id: {
                StaffCode: 0,
                BudgetAmt: 0,
                Budgethours: 0,
                temp_Id: id,
                fromdate: 0
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/GetServerEditOnJobWiseTempId",
            data: JSON.stringify(data),
            dataType: "json",
            success: function (msg) {
                var mylist = jQuery.parseJSON(msg.d);
                if (mylist.length > 0) {
                    $("[id*=txteditStaffBudgetedDate]").val(mylist[0].fromdate);
                    $("[id*=txteditBudgetHours]").val(mylist[0].Budgethours);
                    $("[id*=txteditBudgetAmt]").val(mylist[0].BudgetAmt);
                }
                $('.loader2').fadeOut(550);
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        //Ajax end
    }

    ///Take the staffname data into 25 packs
    function Stfftbl(totalcount, jobid) {
        var PageSizen = 3000;
        var gotoserver = parseFloat(totalcount) / parseFloat(PageSizen);
        var sid = ''
        if (jobid != '') {
            sid = jobid
        }
        gotoserver = parseInt(gotoserver) + 1;
        if (parseFloat(totalcount) <= PageSizen) {
            gotoserver = 1;
        }

        for (i = 1; i <= gotoserver; i++) {
            $('.loader2').show();
            onecheck = onecheck + 1;

            StaffTable(i, PageSizen, sid);
        }
    }

    var onecheck = 1;
    var twocheck = 1;
    var chekcall = 0;
    ///Condition on BudgetType dropdown
    function Budgettypetoggle() {
        var type = $("[id*=drpBudgType]").val();
        var p = $("#drpProject option:selected").html();
        if (type == 'Project') {
            $("[id*=divprojectBudget]").show();
            $("[id*=dvStaffBudget]").hide();
            $("[id*=lblprojbudget]").html(p);
            $("[id*=btnSave]").show();

        }
        else if (type == 'Staff') {
            $("[id*=divprojectBudget]").hide();
            $("[id*=dvStaffBudget]").show();
            $("[id*=lblprojstaff]").html(p);
            $("[id*=btnSave]").show();
            //$("[id*=tblStaff]").empty();
        }
        else if (type == 'both') {
            $("[id*=divprojectBudget]").show();
            $("[id*=dvStaffBudget]").show();
            $("[id*=lblprojstaff]").html(p);
            $("[id*=lblprojbudget]").html(p);
            $("[id*=btnSave]").show();
            $("[id*=tblStaff]").empty();

        }
        else if (type == '0') {
            $("[id*=divprojectBudget]").hide();
            $("[id*=dvStaffBudget]").hide();
            $("[id*=btnSave]").hide();
        }
    }

    function reset() {
        document.getElementById("drpBudgType").disabled = false;
        document.getElementById("drpclient").disabled = false;
        document.getElementById("drpProject").disabled = false;
        document.getElementById("btnEditBudget").display = true;
        document.getElementById("ctl00_ContentPlaceHolder1_Proj_StaffBudget_txtHrsf").disabled = false;
        document.getElementById("ctl00_ContentPlaceHolder1_Proj_StaffBudget_txtAmtf").disabled = false;
        document.getElementById("ctl00_ContentPlaceHolder1_Proj_StaffBudget_txteditProjBudgetedDate").disabled = false;
        $("[id*=lbltotbudgAmt]").html('0');
        $("[id*=lbltotbudghrs]").html('0');
        $("[id*=drpclient]").val('0');
        $("[id*=drpProject]").val('0');
        $("[id*=drpBudgType]").val('0');
        $("[id*=txtHrsf]").val('');
        $("[id*=txtAmtf]").val('');
        $("[id*=txteditProjBudgetedDate]").val('');
        $("[id*=lblbuddate]").html("Budgeted Start Date ");
        Budgettypetoggle();
        $("[id*=btnEditBudget]").hide();
        $("[id*=btnSave]").hide();
        $("[id*=txtstffcount]").val('0');
        $("[id*=lblbudgdt]").hide();
        $("[id*=tda]").hide();
        $("[id*=dtbudg]").hide();
    }

    ///Bring the Budget table
    function FillBudgGrid() {
        var Compid = $("[id*=hdnCompanyid]").val();
        var srch = $("[id*=txtbrsearch]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/FillBudgetGrid",
            data: '{Compid:' + Compid + ',Srch:"'+srch+'"}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var tbl = "";
                $("[id*=tblBudget] tbody").empty();
                if (myList == null) {
                } else {
                    if (myList.length == 0) {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td >" + 'No Records Found...' + "</td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "</tr>";
                        $("[id*=tblBudget]").append(tbl);
                        FillClient();
                    }
                    else {
                        if (myList.length > 0) {
                            for (var i = 0; i < myList.length; i++) {
                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td style='text-align: center;'>" + myList[i].Srno + "<input type='hidden' id='hdncltG' name='hdncltG' value='" + myList[i].cltid + "'>" + "</td>";
                                tbl = tbl + "<td >" + myList[i].ProjectName + "<input type='hidden' id='hdnJobid' name='hdnJobid' value='" + myList[i].multid + "'>" + "</td>";
                                tbl = tbl + "<td >" + myList[i].clientName + "<input type='hidden' id='hdnBudgType' name='hdnBudgType' value='" + myList[i].Budget_type + "'>" + "</td>";
                                tbl = tbl + "<td style='text-align: center;'>" + myList[i].Project_Date + "</td>";
                                tbl = tbl + "<td style='text-align: right;'>" + myList[i].BudHrs + "</td>";
                                tbl = tbl + "<td style='text-align: right;'>" + myList[i].staffcount + "</td>";
                                tbl = tbl + "<td >" + "<img src='../images/edit.png'  class='edit' onclick='BudgetEdit($(this))'/>" + "</td>";
                                tbl = tbl + "<td >" + "<img src='../images/Delete.png'  class='delete' onclick='BudgetDelete($(this))'/>" + "</td>";
                                tbl = tbl + "</tr>";
                            }
                            $("[id*=tblBudget]").append(tbl);
                            FillClient();
                        }
                        else {
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td >" + 'No Records Found...' + "</td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "</tr>";
                            $("[id*=tblBudget]").append(tbl);
                            FillClient();
                        }
                    }
                }
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }

    ///Budget Grid Only
    function SecoundBudgGrid() {
        var Compid = $("[id*=hdnCompanyid]").val();
        var srch = $("[id*=txtbrsearch]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/FillBudgetGrid",
            data: '{Compid:' + Compid + ',Srch:"' + srch + '"}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var tbl = "";
                $("[id*=tblBudget] tbody").empty();
                if (myList == null) {
                } else {
                    if (myList.length == 0) {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td >" + 'No Records Found...' + "</td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "</tr>";
                        $("[id*=tblBudget]").append(tbl);
                    }
                    else {
                        if (myList.length > 0) {
                            for (var i = 0; i < myList.length; i++) {
                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td style='text-align: center;'>" + myList[i].Srno + "<input type='hidden' id='hdncltG' name='hdncltG' value='" + myList[i].cltid + "'>" + "</td>";
                                tbl = tbl + "<td >" + myList[i].ProjectName + "<input type='hidden' id='hdnJobid' name='hdnJobid' value='" + myList[i].multid + "'>" + "</td>";
                                tbl = tbl + "<td >" + myList[i].clientName + "<input type='hidden' id='hdnBudgType' name='hdnBudgType' value='" + myList[i].Budget_type + "'>" + "</td>";
                                tbl = tbl + "<td style='text-align: center;'>" + myList[i].Project_Date + "</td>";
                                tbl = tbl + "<td style='text-align: right;'>" + myList[i].BudHrs + "</td>";
                                tbl = tbl + "<td style='text-align: right;'>" + myList[i].staffcount + "</td>";
                                tbl = tbl + "<td >" + "<img src='../images/edit.png'  class='edit' onclick='BudgetEdit($(this))'/>" + "</td>";
                                tbl = tbl + "<td >" + "<img src='../images/Delete.png'  class='delete' onclick='BudgetDelete($(this))'/>" + "</td>";
                                tbl = tbl + "</tr>";
                            }
                            $("[id*=tblBudget]").append(tbl);
                        }
                        else {
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td >" + 'No Records Found...' + "</td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "</tr>";
                            $("[id*=tblBudget]").append(tbl);
                        }
                    }
                }
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }

    ///Budget Edit 
    function BudgetEdit(i) {
        var row = i.closest("tr")
        var Budgtyp = row.find("input[name=hdnBudgType]").val();
        var Clt = row.find("input[name=hdncltG]").val();
        var Jobid = row.find("input[name=hdnJobid]").val();
        var projddt = $("td", row).eq(3).html();
        $("[id*=drpclient]").val(Clt);
        FillProject(Jobid);
        $("[id*=btnSave]").hide();
        $("[id*=btnUpdate]").show();
        $("[id*=drpBudgType]").val(Budgtyp);
        $("[id*=txteditProjBudgetedDate]").val(projddt);
        $("[id*=lblbuddate]").html("Project Start Date");
        Budgettypetoggle();
        document.getElementById("drpBudgType").disabled = true;
        document.getElementById("drpclient").disabled = true;
        $("[id*=dvAddProject]").show();
        $("[id*=dvBudgetGrid]").hide();
        $("[id*=lblbudgdt]").show();
        $("[id*=tda]").show();
        $("[id*=dtbudg]").show();
        $("[id*=btnEditBudget]").show();
        $("[id*=dvupdate]").show();
    }

    ///delete the Budget
    function BudgetDelete(i) {
        var newDate = new Date();
        var row = i.closest("tr")
        var x = confirm("Are you sure want to delete?");
        var ip = $("[id*= hdnIP]").val();
        var usr = $("[id*= hdnName]").val();
        var uT = $("[id*= hdnUser]").val();
        if (x == true) {

            var Clt = row.find("input[name=hdncltG]").val();
            var Job = row.find("input[name=hdnJobid]").val();
            var id = Job.split(',');
            var Jobid = id[0];
            var Compid = $("[id*=hdnCompanyid]").val();
            var Budgtyp = row.find("input[name=hdnBudgType]").val();
            $.ajax({
                type: "POST",
                url: "../Handler/ProjectandStaff_Budgeting.asmx/BudgetDelete",
                data: '{Compid:' + Compid + ',Clt:' + Clt + ',Jobid:' + Jobid + ',Budgtyp:"' + Budgtyp + '",ip:"' + ip + '",usr:"' + usr + '", ut:"' + uT + '", dt: "' + newDate + '" }',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList == null) {
                    }
                    if (myList[0].id) {
                        alert("Budget was Deleted!!! ");
                        SecoundBudgGrid();
                    }
                },
                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
        }
        else
        {
            return false;
        }
    }

    //// Filling the Client Name dropdown
    function FillClient() {
        var Compid = $("[id*=hdnCompanyid]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/FillClient",
            data: '{Compid:' + Compid + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList == null) {
                } else {
                    if (myList.length == 0) { }
                    else {
                        $("[id*=drpclient]").empty();
                        $("[id*=drpclient]").append("<option value=" + 0 + ">Select</option>");
                        for (var i = 0; i < myList.length; i++) {
                            $("[id*=drpclient]").append("<option value=" + myList[i].Cltid + ">" + myList[i].clientname + "</option>");
                        }
                        //$("[id*=drpclient]").selectize();
                    }
                }
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }
    ///Bring the Project Name into the dropdown
    function FillProject(Jobid) {
        var Compid = $("[id*=hdnCompanyid]").val();
        var cltid = $("[id*=drpclient]").val();
        var job = "";
        if (Jobid != "") {
            job = Jobid;
        }
        $.ajax({
            type: "POST",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/FillProject",
            data: '{Compid:' + Compid + ',Cltid:' + cltid + ',Job:"' + job + '"}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList == null) {
                } else {
                    if (myList.length == 0) { }
                    else {
                        $("[id*=drpProject]").empty();
                        $("[id*=drpProject]").append("<option value=" + 0 + ">Select</option>");
                        for (var i = 0; i < myList.length; i++) {
                            $("[id*=drpProject]").append("<option value=" + myList[i].multid + ">" + myList[i].Projectname + "</option>");
                        }
                    }
                }
                if (Jobid != "") {
                    $("[id*=drpProject]").val(Jobid);
                    document.getElementById("drpProject").disabled = true;
                    var id = Jobid.split(',');
                    var count = id[2];
                    $("[id*=txtstffcount]").val(count);
                    Stfftbl(count, Jobid);
                    $("[id*=btnSave]").hide();
                    ProjBudg();
                    document.getElementById("ctl00_ContentPlaceHolder1_Proj_StaffBudget_txtHrsf").disabled = true;
                    document.getElementById("ctl00_ContentPlaceHolder1_Proj_StaffBudget_txtAmtf").disabled = true;
                    document.getElementById("ctl00_ContentPlaceHolder1_Proj_StaffBudget_txteditProjBudgetedDate").disabled = true;
                }
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }


    ////Staff Budget Table
    function StaffTable(pageIndex, PageSizen, sid) {
        //$('.loader2').show();
        var Compid = $("[id*=hdnCompanyid]").val();
        var Job = $("[id*=drpProject]").val();
        var id = Job.split(',');
        var Jobid = id[0];

        $.ajax({
            type: "POST",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/FillStaffName",
            data: '{Compid:' + Compid + ',Jobid:' + Jobid + ',pageIndex: ' + pageIndex + ',pageNewSize: ' + PageSizen + ',sid:"' + sid + '"}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var tbody = "";
                var tbl = "";

                var trL = $("[id*=tblStaff] tbody tr:last-child");
                $("[id*=tblStaff] tbody").empty();
                if (myList == null) {
                } else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            tbody = tbody + "<tr>" + "<th class='auto-style4'>Sr.No</th><th class='auto-style3'>Staff Name</th>";
                            if (sid != '') {
                                tbody = tbody + "<th class='auto-style4'>Budgeted Date</th>";
                            }
                            else {
                            }
                            tbody = tbody + "<th class='auto-style4'>Budgeted Hours</th><th class='auto-style4'>Allocated Hours</th><th class='auto-style4'>Budgeted Hourly Charges</th><th class='auto-style4'>Actual Hourly Charges</th>";
                            if (sid != '') {
                                tbody = tbody + "<th class='auto-style4'>Edit</th>";
                            }
                            else {
                            }
                            tbody = tbody + "</tr>";
                            for (var i = 0; i < myList.length; i++) {

                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td style='text-align: center;'>" + myList[i].Srno + "</td>";
                                tbl = tbl + "<td >" + myList[i].StaffName + "<input type='hidden' id='hdnStaffcode' name='hdnStaffcode' value='" + myList[i].StaffCode + "'>" + "</td>";
                                if (sid != '') {
                                    tbl = tbl + "<td style='text-align: right;'>" + myList[i].frmdate + "</td>";
                                    tbl = tbl + "<td style='text-align: right;'>" + myList[i].BudgetHrs + "</td>";
                                    tbl = tbl + "<td style='text-align: right;'>" + myList[i].AllocateHrs + "</td>";
                                    tbl = tbl + "<td style='text-align: right;'>" + myList[i].BudgetAmt + "</td>";
                                } else {
                                    tbl = tbl + "<td >" + "<input style='text-align: right;' type='textbox' id='txthrs_" + i + "' name='txthrs_" + i + "' onkeypress='return isNumber(event)' onblur='CalcbudgHrs($(this))' value='0'>" + "<input type='hidden' id='hdnBdgHrs_" + i + "' name='hdnBdgHrs_" + i + "' value='0'>" + "</td>";
                                    tbl = tbl + "<td >" + "<input style='text-align: right;' type='textbox' id='txtAllocthrs_" + i + "' name='txtAllocthrs_" + i + "' onkeypress='return isNumber(event)' onblur='CalcBudgetAmt($(this))' value='0'>" + "<input type='hidden' id='hdnAllocthrs_" + i + "' name='hdnAllocthrs_" + i + "' value='0'>" + "</td>";
                                    tbl = tbl + "<td >" + "<input style='text-align: right;' type='textbox' id='txtamthrs_" + i + "' name='txtamthrs_" + i + "' onkeypress='return isNumber(event)' onblur='CalcBudgetAmt($(this))' value='0'>" + "<input type='hidden' id='hdnamthrs_" + i + "' name='hdnamthrs_" + i + "' value='0'>" + "</td>";
                                }

                                tbl = tbl + "<td style='text-align: right;'>" + myList[i].ActualAmt + "</td>";
                                if (sid != '') {
                                    tbl = tbl + "<td >" + "<img src='../images/edit.png'  class='edit' onclick='StaffBudgetEdit($(this))'/>" + "</td>";
                                }
                                else {

                                }
                                tbl = tbl + "</tr>";
                            }
                            tbody = tbody + tbl;
                            $("[id*=tblStaff]").append(tbody);
                            //$("[id*=txteditProjBudgetedDate]").val(myList[0].frmdate);
                        }
                        else {
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td >" + 'No Records Found...' + "</td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "</tr>";
                            $("[id*=tblStaff]").append(tbl);
                        }
                    }
                }
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }


    ///function for calc of the budgeted hrs
    function CalcbudgHrs(i) {
        var row = i.closest("tr")
        var rIndex = i.closest("tr")[0].sectionRowIndex;
        rIndex = rIndex - 1;
        var txt = i[0].id;
        var V = i.val();
        var BudgHrs = $("[id*=txtHrsf]").val();
        if (V == '') {
            var V = i.val(0);
            $("#hdnBdgHrs_" + rIndex).val(0);
        } else {
            $("#hdnBdgHrs_" + rIndex).val(V);
        }
        var addition = 0;
        var Index = 0;
        $('#tblStaff > tbody  > tr').each(function () {
            var row = $(this).closest("tr");
            var P = $("#hdnBdgHrs_" + Index, row).val();
            if (P != undefined) {
                addition = addition + parseFloat(P);
                Index = Index + 1;
            }
        });
        if (BudgHrs != '') {
            if (addition > BudgHrs) {
                i.val(0);
                $("#hdnBdgHrs_" + rIndex).val(0);
            }
            else {
                $("[id*=lbltotbudghrs]").html(addition);
            }
        } else {
            $("[id*=lbltotbudghrs]").html(addition);
        }
    }

    ///function Calculate total Budgeted Amt by multi the allochrs and Hrscharges
    function CalcBudgetAmt(i) {
        var row = i.closest("tr")
        var rIndex = i.closest("tr")[0].sectionRowIndex;
        var BudgetAmt = $("[id*=txtAmtf]").val();
        rIndex = rIndex - 1;
        var Allocthrs = $("#txtAllocthrs_" + rIndex).val();
        var HrslyCharge = $("#txtamthrs_" + rIndex).val();
        var budghrs = $("#txthrs_" + rIndex).val();

        if (parseFloat(budghrs) >= parseFloat(Allocthrs)) {
            var t = i.val();
            var amt = parseFloat(Allocthrs) * parseFloat(HrslyCharge);

            if (t == '') {
                $("#hdnamthrs_" + rIndex).val(0);
            }
            else {
                $("#hdnamthrs_" + rIndex).val(amt);
            }
            var addition = 0;
            var Index = 0;
            $('#tblStaff > tbody  > tr').each(function () {
                var row = $(this).closest("tr");
                var P = $("#hdnamthrs_" + Index, row).val();
                if (P != undefined) {
                    addition = addition + parseFloat(P);
                    Index = Index + 1;
                }
            });
            if (BudgetAmt != '') {
                if (addition > BudgetAmt) {
                    i.val(0);
                    $("#hdnamthrs_" + rIndex).val(0);
                }
                else {
                    $("[id*=lbltotbudgAmt]").html(addition);
                }
            } else {
                $("[id*=lbltotbudgAmt]").html(addition);
            }
        } else {
            alert("Allocated Hours cannot be more than Budgeted Hours");
            i.val(0);
        }
    }


    ///Staff Budget Popup
    function StaffBudgetEdit(i) {
        var row = i.closest("tr")
        var staffname = $("td", row).eq(1).html();
        var staffcode = row.find("input[name=hdnStaffcode]").val();
        var actualrate = $("td", row).eq(6).html();
        $("[id*=lblStaffBudgetName]").html(staffname);
        $("[id*=txtStaffActualRateForJob]").val(actualrate);
        $find("StaffBudgetingpopup").show();
        GetStafftempdata(staffcode);
    }



    ///Bring Project last record while editing project budget
    function ProjBudg() {
        var Compid = $("[id*=hdnCompanyid]").val();
        var Job = $("[id*=drpProject]").val();
        var id = Job.split(',');
        var Jobid = id[0];
        $.ajax({
            type: "POST",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/ProjectBudgSingle",
            data: '{Compid:' + Compid + ',Jobid:' + Jobid + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length > 0) {
                    $("[id*=txtHrsf]").val(myList[0].BudHrs);
                    $("[id*=txtAmtf]").val(myList[0].BudAmt);
                    $("[id*=txtProjDate]").val(myList[0].FromDt);

                }
                else {
                    $("[id*=txtHrsf]").val('');
                    $("[id*=txtAmtf]").val('');
                    $("[id*=txtProjDate]").val('');
                }
                var p = $("#drpProject option:selected").html();
                $("[id*=lblprojstaff]").html(p);
                $("[id*=lblprojbudget]").html(p);
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }

    ///Saving the Project Budget First time
    function SavetheProjBudgetFirst() {
        var Compid = $("[id*=hdnCompanyid]").val();
        var Job = $("[id*=drpProject]").val();
        var id = Job.split(',');
        var Jobid = id[0];
        var Projid = id[1];
        var Hours = $("[id*=txtHrsf]").val();
        var Amt = $("[id*=txtAmtf]").val();
        var FromDt = $("[id*=txteditProjBudgetedDate]").val();
        var cltid = $("[id*=drpclient]").val();
        var Budget_type = $("[id*=drpBudgType]").val();
        var totAllothrs = $("[id*=lbltotbudghrs]").html();
        var totBudgAmt = $("[id*=lbltotbudgAmt]").html();
        if (Hours == '' || Amt == '' || FromDt == '') {
            alert("Kindly fill the value");
        }
        else {
            $.ajax({
                type: "POST",
                url: "../Handler/ProjectandStaff_Budgeting.asmx/SavetheBudgetFirst",
                data: '{Compid:' + Compid + ',Projid:' + Projid + ',Jobid:' + Jobid + ',Hours:"' + Hours + '",Amt:' + Amt + ',FromDt:"' + FromDt + '",cltid:' + cltid + ',Budget_type:"' + Budget_type + '",totAllothrs:' + totAllothrs + ',totBudgAmt:' + totBudgAmt + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList == null) {
                    } else {
                        if (myList[0].PrjectId > 0) {
                            if (Budget_type == 'both') {
                                SaveStaffBudget();
                            } else {
                                alert("Project Budget Successfully Save");
                            }
                        }
                    }
                },
                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
        }
    }

    ///Saveing the staff budget
    function SaveStaffBudget() {
        var Compid = $("[id*=hdnCompanyid]").val();
        var Job = $("[id*=drpProject]").val();
        var id = Job.split(',');
        var Jobid = id[0];
        var Projid = id[1];
        var Cltid = $("[id*=drpclient]").val();
        var frdate = $("[id*=txteditProjBudgetedDate]").val();
        var Budgetype = $("[id*=drpBudgType]").val();
        var totAllothrs = $("[id*=lbltotbudghrs]").html();
        var totBudgAmt = $("[id*=lbltotbudgAmt]").html();
        var stfb = '';
        var Index = 0;
        $('#tblStaff > tbody  > tr').each(function () {
            var row = $(this).closest("tr");
            var staffcode = row.find("input[name=hdnStaffcode]").val();
            var Budgethrs = $("#txthrs_" + Index, row).val();
            var BudgAmt = $("#txtamthrs_" + Index, row).val();
            var AllocateHrs = $("#txtAllocthrs_" + Index, row).val();
            var ActulAmt = $("td", row).eq(5).html();

            if (staffcode != undefined) {
                stfb = stfb + staffcode + "," + Budgethrs + "," + BudgAmt + "," + AllocateHrs + "," + ActulAmt + "^";
                Index = Index + 1;
            }
        });
        $.ajax({
            type: "POST",
            url: "../Handler/ProjectandStaff_Budgeting.asmx/SaveStaffBudget",
            data: '{Compid:' + Compid + ',Projid:' + Projid + ',Jobid:' + Jobid + ',Cltid:' + Cltid + ',frdate:"' + frdate + '",stfb:"' + stfb + '",Budgetype:"' + Budgetype + '",AllocateHrs:' + totAllothrs + ',ActulAmt:' + totBudgAmt + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList[0].PrjectId > 0) {
                    if (Budgetype == 'both') {
                        alert("Project and Staff Budgeted Successfully!!!");
                        SecoundBudgGrid();
                    } else {
                        alert("Staff Budgeted Successfully!!!");
                        SecoundBudgGrid();
                    }
                } else {

                }

            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }

    //popup for Project edit
    function ShowModalPopup() {
        var c = $("#drpclient option:selected").html();
        var p = $("#drpProject option:selected").html();
        $("[id*=lblClientBudgetName]").html(c);
        $("[id*=lblProjectBudgetName]").html(p);
        $find("mailingListModalPopupBehavior").show();
        GetJobWiseBudgetDetails();
        //Editprojectlastrecord();
    }
    //popup hide
    function HideModalPopup() {
        $find("mailingListModalPopupBehavior").hide();
        return false;
    }

    ///Number validetion
    function isNumber(evt) {
        evt = (evt) ? evt : window.event;
        var charCode = (evt.which) ? evt.which : evt.keyCode;
        if (charCode == 46) {

        }
        else if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        return true;
    }

</script>
<style type="text/css">
    .edit, .delete {
        cursor: pointer;
        font-size: 20px;
        display: table;
        margin-left: auto;
        margin-right: auto;
    }

    .Head1 {
        font-size: 14px;
        font-family: Verdana,Arial,Helvetica,sans-serif;
        color: #3D80E8;
        font-weight: bold;
        overflow: hidden;
        border-bottom-color: White;
    }

    .drp {
        font-family: Verdana,Arial,Helvetica,sans-serif;
        font-size: 12px;
        -webkit-border-radius: 3px;
        -moz-border-radius: 3px;
        border-radius: 3px;
        width: 80px;
    }

    #txtProjhrs {
        width: 70px;
        margin-left: 20px;
    }

    #txtProjamt {
        width: 69px;
        margin-left: 11px;
    }

    .auto-style2 {
        width: 225px;
    }

    #btnAdd, #btnSave {
        width: 117px;
        margin-left: 47px;
    }

    .auto-style3 {
        width: 552px;
    }

    .auto-style4 {
        width: 147px;
    }

    .auto-style5 {
        width: 188px;
    }

    .auto-style7 {
        width: 188px;
        height: 36px;
    }

    .auto-style10 {
        width: 64%;
        margin-left: 36;
    }

    .auto-style11 {
        width: 90%;
        margin-left: 70;
    }


    .auto-style14 {
        width: 1269px;
    }

    .auto-style15 {
        width: 82px;
    }

    .auto-style16 {
        width: 259px;
    }

    .auto-style22 {
        width: 71px;
    }

    .auto-style23 {
        width: 74px;
    }

    .auto-style24 {
        width: 173px;
    }

    .auto-style25 {
        width: 245px;
    }
</style>

<%--Dispaly Budget Grid--%>
<div id="dvBudgetGrid" class="divstyle" style="height: auto;">
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <label class="Head1">Project/Staff Budgeting</label>
                <asp:HiddenField ID="hdnIP" runat="server" />
            <asp:HiddenField ID="hdnName" runat="server" />
            <asp:HiddenField ID="hdnUser" runat="server" />
        </div>
    </div>
    <div>
        <div class="serachJob" style="float: left; width: 100%; margin: 20px; overflow: auto;">
            <div id="searchbr" runat="server">
                <asp:Label ID="Label24" runat="server" Text="Search Client" CssClass="LabelFontStyle labelChange"></asp:Label>
                <asp:TextBox ID="txtbrsearch" runat="server" Width="250px" CssClass="txtbox" Font-Names="Verdana" 
                    Font-Size="8pt"></asp:TextBox>
                <input id="btnSearch" type="button" value="Search" class="TbleBtnsPading TbleBtns" />
                <input id="btnAdd" type="button" value="Add Budget" class="TbleBtnsPading TbleBtns" />

            </div>
        </div>
    </div>
    <div class="divstyle" style="height: auto; overflow: visible">
        <%--<div style="overflow:auto">--%>
        <table id="tblBudget" cellspacing="0" class="norecordTble" border="1" style="border-collapse: collapse; width: 100%;">
            <thead>
                <tr>
                    <th class="auto-style4">Sr.No</th>
                    <th class="auto-style3">Project Name</th>
                    <th class="auto-style3">Client Name</th>
                    <th class="auto-style4">Project Date</th>
                    <th class="auto-style4">Budgeted Hours</th>
                    <th class="auto-style4">Staff Count</th>
                    <th class="auto-style4">Edit</th>
                    <th class="auto-style4">Delete</th>
                </tr>
            </thead>
        </table>
        <%--    </div>--%>
    </div>

</div>

<%--Dispaly other page div for add project and staff budget--%>
<div id="dvAddProject" class="divstyle" style="height: auto; display: none;">
    <asp:HiddenField ID="hdnCompanyid" runat="server" />
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <label class="Head1">Project/Staff Budgeting</label>
        </div>

    </div>
    <div>
        <div style="float: left; width: 100%; margin: 10px; padding-top: 3px;">
            <table class="auto-style14">
                <tr>
                    <td class="auto-style7">
                        <label style="font-size: 14px; font-family: Arial;"><b>Client Name</b></label>
                    </td>
                    <td class="auto-style22">:</td>
                    <td class="auto-style16">
                        <select id="drpclient" class="auto-style10">
                            <option value="0">Select</option>
                        </select></td>
                    <td class="auto-style7">
                        <label style="font-size: 14px; font-family: Arial;"><b>BudgetType </b></label>
                    </td>
                    <td class="auto-style23">:</td>
                    <td class="auto-style24">
                        <select id="drpBudgType" class="auto-style11">
                            <option value="0">Select</option>
                            <option value="Project">Project Budget</option>
                            <option value="Staff">Staff Budget</option>
                            <option value="both">Project and Staff Budget</option>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td class="auto-style7">
                        <label style="font-size: 14px; font-family: Arial;"><b>Project Name </b></label>
                    </td>
                    <td class="auto-style22">:</td>
                    <td class="auto-style16">
                        <select id="drpProject" class="auto-style10">
                            <option value="0">Select</option>
                        </select>
                    </td>
                    <td class="auto-style7">
                        <label id="lblbuddate" style="font-size: 14px; font-family: Arial; font-weight: bold">Budgeted Start Date </label>
                    </td>
                    <td class="auto-style23">:</td>
                    <td class="auto-style24">
                        <asp:TextBox ID="txteditProjBudgetedDate" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txteditProjBudgetedDate" Mask="99/99/9999" MaskType="Date" MessageValidatorTip="true">
                        </cc1:MaskedEditExtender>
                        <cc1:CalendarExtender runat="server" ID="CalendarExtender2" TargetControlID="txteditProjBudgetedDate" Format="dd/MM/yyyy" Enabled="True">
                        </cc1:CalendarExtender>
                    </td>
                    <td>
                        <label style="font-size: 14px; font-family: Arial;"><b>Staff Count </b></label>
                        <asp:TextBox ID="txtstffcount" Width="50px" Style="margin: 2px; text-align: right;" runat="server"
                            CssClass="txtbox calbox" disabled>0</asp:TextBox>
                    </td>
                </tr>

            </table>
        </div>
    </div>
    <hr />
    <div id="divprojectBudget" style="float: left; width: 100%; margin: 10px; overflow: auto;">
        <label class="Head1">Project Budgeting for</label>
        <label id="lblprojbudget"><b></b></label>
        <table>
            <tr>
                <td class="auto-style7">
                    <label style="font-size: 14px; font-family: Arial;"><b>Projected Hours </b></label>
                    &nbsp;
                </td>
                <td class="auto-style15">:</td>
                <td class="auto-style25">
                    <asp:TextBox ID="txtHrsf" Width="130px" Style="margin: 2px; text-align: right;" runat="server"
                        CssClass="txtbox calbox" onkeypress="return isNumber(event)"></asp:TextBox>

                </td>
                <td class="auto-style7">
                    <label id="lblbudgdt" style="font-size: 14px; font-family: Arial; font-weight: bold">Budgeted Date </label>
                </td>
                <td id="tda" class="auto-style15">:</td>
                <td id="dtbudg">
                    <asp:TextBox ID="txtProjDate" runat="server" CssClass="cssTextBoxDate" disabled></asp:TextBox>
                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtProjDate" Mask="99/99/9999" MaskType="Date" MessageValidatorTip="true">
                    </cc1:MaskedEditExtender>
                    <cc1:CalendarExtender runat="server" ID="CalendarExtender4" TargetControlID="txtProjDate" Format="dd/MM/yyyy" Enabled="True">
                    </cc1:CalendarExtender>

                </td>
            </tr>
            <tr>
                <td class="auto-style5">
                    <label style="font-size: 14px; font-family: Arial;"><b>Projected Amount </b></label>
                    &nbsp;
                
                </td>
                <td class="auto-style15">:</td>
                <td class="auto-style25">
                    <asp:TextBox ID="txtAmtf" Width="130px" Style="margin: 2px; text-align: right;" runat="server"
                        CssClass="txtbox calbox" onkeypress="return isNumber(event)"></asp:TextBox></td>
                <td class="auto-style7">
                    <input id="btnEditBudget" type="button" value="Edit Budget" class="TbleBtnsPading TbleBtns" onclick="return ShowModalPopup()" /></td>
            </tr>
        </table>
    </div>
    <div id="dvStaffBudget" class="divstyle" style="height: auto;">
        <div class="headerpage">
            <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
                <table>
                    <tr>
                        <td>
                            <label class="Head1">Staff Budgeting for</label></td>

                        <td>
                            <label id="lblprojstaff"></label>
                        </td>
                        <td style="padding-left: 150px;"><b>Staff Budgeted Hours :</b></td>
                        <td>
                            <label id="lbltotbudghrs">0</label></td>
                        <td style="padding-left: 80px;"><b>Staff Budgeted Amount :</b></td>
                        <td>
                            <label id="lbltotbudgAmt">0</label></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="divstyle" style="height: auto; overflow: visible">
            <%--<div style="overflow:auto">--%>
            <table id="tblStaff" name="tblStaff" cellspacing="0" class="norecordTble" border="1" style="border-collapse: collapse; width: 100%;">
                <thead>
                </thead>
            </table>
            <%--    </div>--%>
        </div>
    </div>
    <%--    Popup For the Project Budget--%>
    <div>
        <asp:Button ID="hiddenLargeImage" runat="server" Style="display: none" />
        <cc1:ModalPopupExtender runat="server" ID="ModalPopupExtender1" BehaviorID="mailingListModalPopupBehavior"
            TargetControlID="hiddenLargeImage" PopupControlID="divProjectPopup" BackgroundCssClass="modalBackground"
            OkControlID="imgClose" DropShadow="false" RepositionMode="RepositionOnWindowScroll">
        </cc1:ModalPopupExtender>
        <div id="divProjectPopup" style="width: 560px; background-color: #FFFFFF;">
            <div style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff; font-weight: bold;">
                <div style="width: 90%; float: left; height: 20px; padding-left: 2%; padding-top: 1%">
                    <asp:Label ID="Label18" runat="server" Text="Add Project Rrecords"
                        CssClass="subHead1"></asp:Label>
                </div>
                <div class="ModalCloseButton">
                    <img alt="" src="../images/error.png" id="imgClose" border="0" onclick="return HideModalPopup()" />
                </div>
            </div>
            <div style="width: 550px; min-height: 300px; float: left; overflow: hidden; padding: 5px;">
                <table align="center" cellpadding="5" width="100%" style="border-color: #BCBCBC; border-collapse: collapse;"
                    border="1" cellspacing="0">
                    <tr>
                        <td>
                            <b class="labelChange">Client Name</b>
                        </td>
                        <td colspan="3" width="70%">
                            <label id="lblClientBudgetName"></label>
                            <%--<asp:Label ID="lblClientBudgetName" runat="server"></asp:Label>--%>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <b class="labelChange">Project Name</b>
                        </td>
                        <td width="70%" colspan="3">
                            <asp:Label ID="lblProjectBudgetName" runat="server"></asp:Label>
                        </td>
                    </tr>
                </table>
                <table cellspacing="0" cellpadding="0" align="center" style="margin: 4px auto 4px auto;">
                    <tr>
                        <td><b>
                            <asp:HiddenField ID="hdnProjectBudgetingtemp" runat="server" />
                            From Date&nbsp;

                        </b></td>
                        <td>
                            <asp:TextBox ID="txteditStaffBudgetedDate" Style="margin: 2px;" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txteditStaffBudgetedDate"
                                Mask="99/99/9999" MaskType="Date" MessageValidatorTip="true" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txteditStaffBudgetedDate"
                                PopupButtonID="txteditStaffBudgetedDate" Format="dd/MM/yyyy" Enabled="True">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Budgeted Hours&nbsp;</b></td>
                        <td>
                            <asp:TextBox ID="txteditBudgetHours" Width="100px" Style="margin: 2px; text-align: right;" runat="server"
                                CssClass="txtbox calbox" onkeypress="return isNumber(event)"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Budgeted Amount&nbsp;</b></td>
                        <td>
                            <asp:TextBox ID="txteditBudgetAmt" Width="100px" Style="margin: 2px; text-align: right;" runat="server"
                                CssClass="txtbox calbox" onkeypress="return isNumber(event)"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td height="3px" colspan="2"></td>
                    </tr>
                    <tr>
                        <td>
                            <input id="btnEditSave" type="button" value="Save" class="TbleBtnsPading TbleBtns" />
                        </td>
                        <td>
                            <input id="btnClear" type="button" value="Clear" class="TbleBtnsPading TbleBtns" />
                        </td>
                    </tr>
                </table>
                <table id="tblPrevous" cellspacing="0" class="norecordTble" border="1" style="border-collapse: collapse; width: 100%;">
                    <thead>
                        <tr>
                            <th>From Date</th>
                            <th>To Date</th>
                            <th>Hours</th>
                            <th>Amount</th>
                        </tr>
                    </thead>
                </table>
                <div id="content">
                    <div class="loader">
                    </div>
                </div>
            </div>
        </div>
        <div>
            <%--Secound Popup for the Staff budget edit--%>
            <cc1:ModalPopupExtender runat="server" ID="ModalPopupExtender2" BehaviorID="StaffBudgetingpopup"
                TargetControlID="hiddenLargeImage" PopupControlID="divStaffPopup" BackgroundCssClass="modalBackground"
                OkControlID="imgBudgetdClose" DropShadow="false" RepositionMode="RepositionOnWindowScroll">
            </cc1:ModalPopupExtender>
            <div id="divStaffPopup" style="width: 660px; background-color: #FFFFFF;">
                <div id="Div1" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff; font-weight: bold;">
                    <div id="Div2" style="width: 90%; float: left; height: 20px; padding-left: 2%; padding-top: 1%">
                        <asp:Label ID="Label1" runat="server" Text="Edit Staff Budgeted"
                            CssClass="subHead1"></asp:Label>
                    </div>
                    <div id="Div3" class="ModalCloseButton">
                        <img alt="" src="../images/error.png" id="imgBudgetdClose" border="0" name="imgClose" />
                    </div>
                </div>
                <%--         <asp:HiddenField ID="hdnEditClickStaffcode" runat="server" />--%>
                <asp:HiddenField ID="hdnstaffcodetemp" runat="server" />
                <div style="width: 650px; min-height: 300px; float: left; overflow: hidden; padding: 5px;">
                    <table align="center" cellpadding="5" width="100%" style="border-color: #BCBCBC; border-collapse: collapse;"
                        border="1" cellspacing="0">
                        <tr>
                            <td>
                                <b class="labelChange">Staff Name</b>
                            </td>
                            <td colspan="3" width="70%">
                                <asp:Label ID="lblStaffBudgetName" runat="server"></asp:Label>
                            </td>
                        </tr>

                    </table>
                    <table cellspacing="0" cellpadding="0" align="center" style="margin: 4px auto 4px auto;">
                        <tr>
                            <td>
                                <b>
                                    <asp:HiddenField ID="hdnStaffBudgetingtemp" runat="server" />
                                    From Date&nbsp;</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txtjustshowingdate" ReadOnly="true" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtjustshowingdate"
                                    Mask="99/99/9999" MaskType="Date" MessageValidatorTip="true" />
                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtjustshowingdate"
                                    PopupButtonID="txtjustshowingdate" Format="dd/MM/yyyy" Enabled="True">
                                </cc1:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Budget Hours&nbsp;</b>
                            </td>
                            <td>
                                <asp:TextBox ID="TextBox2" Width="100px" Style="margin: 2px; text-align: right;" runat="server"
                                    CssClass="txtbox calbox" onkeypress="return isNumber(event)"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Hourly Amount&nbsp;</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txteditHourlyAmount" Width="100px" Style="margin: 2px; text-align: right;" runat="server"
                                    CssClass="txtbox calbox" onkeypress="return isNumber(event)"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Allocated Hours&nbsp;</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txtAllocatedHrs" Width="100px" Style="margin: 2px; text-align: right;" runat="server"
                                    CssClass="txtbox calbox" onkeypress="return isNumber(event)"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b class="labelChange">Staff Actual Hour Rate&nbsp;</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txtStaffActualRateForJob" Width="100px" Style="margin: 2px; text-align: right;" runat="server"
                                    CssClass="txtbox calbox" onkeypress="return isNumber(event)" disabled></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td height="3px" colspan="2"></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Button ID="btnEditedStaffBudgetdAmtHours" runat="server" Text="Save" class="TbleBtns" />
                            </td>
                            <td>
                                <asp:Button ID="btnStaffclr" runat="server" Text="clear" class="TbleBtns" />
                            </td>
                        </tr>
                    </table>
                    <table id="shwoingdetals" align="center">
                        <tr>
                            <td>
                                <table id="tblstfflast" cellspacing="0" class="norecordTble" border="1" style="border-collapse: collapse; width: 100%;">
                                    <thead>
                                    </thead>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <div id="content">
                        <div class="loader">
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="dvupdate" style="padding-top: 20px; padding-left: 10px;">
    <input id="btnSave" type="button" value="Save" class="TbleBtnsPading TbleBtns" />
    <input id="btnUpdate" type="button" value="Update" class="TbleBtnsPading TbleBtns" />
    <input id="btnCancel" type="button" value="Cancel" class="TbleBtnsPading TbleBtns" />
</div>



