<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProjectDepartment_Budgeting.ascx.cs" Inherits="controls_ProjectDepartment_Budgeting" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<script src="../jquery/dist/jquery.contextMenu.js" type="text/javascript"></script>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<%--<link href="../jquery/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />--%>

<%--for selectize--%>
<script src="../jquery/Selectize/selectize.js" type="text/javascript"></script>
<script src="../jquery/Selectize/es5.js" type="text/javascript"></script>
<script src="../jquery/Selectize/index.js" type="text/javascript"></script>
<link href="../jquery/Selectize/normalize.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        Gridfill();
        $("[id*=dvGrid]").show();
        $("[id*=dvAddProject]").hide();
        $("[id*=dvbottom]").hide();
        $("[id*=drpDepart]").selectize();

        $("[id*=btnAdd]").on('click', function () {
            Reset();
        });

        $("[id*=drpname]").on('change', function () {
            FilldrpDept();
        });

        $("[id*=btnCancel]").on('click', function () {
            $("[id*=dvGrid]").show();
            $("[id*=dvAddProject]").hide();
            $("[id*=dvbottom]").hide();
            CnacelEmptyTemp();
        });

        $("[id*=btnSave]").on('click', function () {
            SaveDeptBudget();
        });

        $("[id*=btnUpdate]").on('click', function () {
            UpdateDepartmentBudget();
        });

        //budget clear button
        $("[id*=btnClear]").live('click', function () {
            $("[id*=txteditBudgetHoursp]").val('0');
            $("[id*=txtAlloctHrsp]").val('0');
            $("[id*=txteditBudgetedDate]").val('');
            $("[id*=hdnDepartmentBudgetingtemp]").val(0);
            return false;
        });

        ///Saving Temp data table on save of the popup
        $("[id*=btnEditSave]").live('click', function () {
            var datea = $("[id*=txteditBudgetedDate]").val();
            var hideid = $("[id*=hdnDepartmentBudgetingtemp]").val();
            if (datea != "") {
                var start = $("[id*=txtBudgDate]").val();
                var fa = start.split('/')
                var ta = datea.split('/')

                var a = new Date(fa[2], fa[1] - 1, fa[0]);
                var d = new Date(ta[2], ta[1] - 1, ta[0]); // for dd-MM-yyyy

                if (hideid > 0) {
                    $('.loader2').fadeIn(200); SetTempBudgetDetails();
                } else {
                    if (a > d) {
                        alert("Date Must be greater than Department Budget Start Date !");
                        return false;
                    }
                    else {
                        $('.loader2').fadeIn(200); SetTempBudgetDetails();
                    }
                }
            }
            else { alert('Please Enter Date !'); }
            return false;
        });

        //Serch Client Name from table
        $("[id*=btnSearch]").on('click', function () {
            SecoundGridfill();
        });

    });



    ///saving Department budget temp record
    function SetTempBudgetDetails() {
        var jobid = $("[id*=drpname]").val();
        var data = {
            id: {
                Dept: $("[id*=drpDepart]").val(),
                AllocatedHours: $("[id*=txtAlloctHrsp]").val(),
                Budgethours: $("[id*=txteditBudgetHoursp]").val(),
                temp_Id: $("[id*=hdnDepartmentBudgetingtemp]").val(),
                fromdate: $("[id*=txteditBudgetedDate]").val(),
                jobid: jobid,
                compid: $("[id*=hdnCompanyid]").val()
            }
        };
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectDepartment_Budgeting.asmx/SetTempBudgetDetails",
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
                        poptable(myList);
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

    function Gridfill() {
        var compid = $("[id*=hdnCompanyid]").val();
        var Srch = $("[id*=txtbrsearch]").val();
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectDepartment_Budgeting.asmx/GridFillDept",
            data: '{compid:' + compid + ',Srch:"' + Srch + '"}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var tbody = '';
                var tbl = '';
                $("[id*=tblBudget] tbody").empty();
                tbody = tbody + "<tr>" + "<th class='auto-style4'>Sr.No</th><th class='auto-style3'>Project Name</th><th class='auto-style3'>Client Name</th><th class='auto-style4'>Department Name</th>";
                tbody = tbody + "<th class='auto-style4'>Budgeted Date</th><th class='auto-style4'>Budgeted Hours</th>";
                tbody = tbody + "<th class='auto-style4'>Edit</th><th class='auto-style4'>Delete</th>";
                tbody = tbody + "</tr>";
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
                        tbody = tbody + tbl;
                        $("[id*=tblBudget]").append(tbody);
                        FillDrpClient();
                    }
                    else {
                        if (myList.length > 0) {

                            for (var i = 0; i < myList.length; i++) {
                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td style='text-align: center;'>" + myList[i].srno + "</td>";
                                tbl = tbl + "<td >" + myList[i].Projectname + "<input type='hidden' id='hdnjobid' name='hdnjobid' value='" + myList[i].Jobid + "'>" + "</td>";
                                tbl = tbl + "<td >" + myList[i].Clientname + "</td>";
                                tbl = tbl + "<td >" + myList[i].Deptname + "<input type='hidden' id='hdndepid' name='hdndepid' value='" + myList[i].depid + "'>" + "</td>";
                                tbl = tbl + "<td style='text-align: center;'>" + myList[i].Fromdate + "</td>";
                                tbl = tbl + "<td style='text-align: right;' >" + myList[i].BudgetHrs + "</td>";
                                tbl = tbl + "<td >" + "<img src='../images/edit.png'  class='edit' onclick='BudgetEdit($(this))'/>" + "</td>";
                                tbl = tbl + "<td style='text-align: center;' >" + "<img src='../images/Delete.png'  class='delete' onclick='BudgetDelete($(this))'/>" + "</td>";
                                tbl = tbl + "</tr>";
                            }
                            tbody = tbody + tbl;
                            $("[id*=tblBudget]").append(tbody);
                            FillDrpClient();
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
                            tbody = tbody + tbl;
                            $("[id*=tblBudget]").append(tbody);
                            FillDrpClient();
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

    ///Secound grid with out any function
    function SecoundGridfill() {
        var compid = $("[id*=hdnCompanyid]").val();
        var Srch = $("[id*=txtbrsearch]").val();
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectDepartment_Budgeting.asmx/GridFillDept",
            data: '{compid:' + compid + ',Srch:"' + Srch + '"}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var tbody = '';
                var tbl = '';
                $("[id*=tblBudget] tbody").empty();
                tbody = tbody + "<tr>" + "<th class='auto-style4'>Sr.No</th><th class='auto-style3'>Project Name</th><th class='auto-style3'>Client Name</th><th class='auto-style4'>Department Name</th>";
                tbody = tbody + "<th class='auto-style4'>Budgeted Date</th><th class='auto-style4'>Budgeted Hours</th>";
                tbody = tbody + "<th class='auto-style4'>Edit</th><th class='auto-style4'>Delete</th>";
                tbody = tbody + "</tr>";

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
                        tbody = tbody + tbl;
                        $("[id*=tblBudget]").append(tbody);
                    }
                    else {
                        if (myList.length > 0) {
                            for (var i = 0; i < myList.length; i++) {
                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td style='text-align: center;'>" + myList[i].srno + "</td>";
                                tbl = tbl + "<td >" + myList[i].Projectname + "<input type='hidden' id='hdnjobid' name='hdnjobid' value='" + myList[i].Jobid + "'>" + "</td>";
                                tbl = tbl + "<td >" + myList[i].Clientname + "</td>";
                                tbl = tbl + "<td >" + myList[i].Deptname + "<input type='hidden' id='hdndepid' name='hdndepid' value='" + myList[i].depid + "'>" + "</td>";
                                tbl = tbl + "<td style='text-align: center;'>" + myList[i].Fromdate + "</td>";
                                tbl = tbl + "<td style='text-align: right;' >" + myList[i].BudgetHrs + "</td>";
                                tbl = tbl + "<td >" + "<img src='../images/edit.png'  class='edit' onclick='BudgetEdit($(this))'/>" + "</td>";
                                tbl = tbl + "<td style='text-align: center;' >" + "<img src='../images/Delete.png'  class='delete' onclick='BudgetDelete($(this))'/>" + "</td>";
                                tbl = tbl + "</tr>";
                            }
                            tbody = tbody + tbl;
                            $("[id*=tblBudget]").append(tbody);

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
                            tbody = tbody + tbl;
                            $("[id*=tblBudget]").append(tbody);
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


    function BudgetEdit(i) {
        var row = i.closest("tr")
        var jobid = row.find("input[name=hdnjobid]").val();
        var dipt = row.find("input[name=hdndepid]").val();
        var deptname = $("td", row).eq(3).html();
        var ProjName = $("td", row).eq(1).html();
        var Clientname = $("td", row).eq(2).html();
        ///hide and show
        $("[id*=dvGrid]").hide();
        $("[id*=dvAddProject]").show();
        $("[id*=dvbottom]").show();
        $("[id*=btnUpdate]").show();
        $("[id*=btnEditBudget]").show();
        $("[id*=btnSave]").hide();
        ///insert values into the drop down whille in editing mode
        $("[id*=drpname]").selectize()[0].selectize.destroy();
        $("[id*=drpname]").val(jobid);
        FilldrpDept(dipt);
        EditDept(jobid, dipt);
        ///
        $("[id*=hdnPropjectName]").val(ProjName);
        $("[id*=hdnClientName]").val(Clientname);
        $("[id*=hdnDeptName]").val(deptname);
    }

    ///Save Department Budget
    function SaveDeptBudget() {
        var compid = $("[id*=hdnCompanyid]").val();
        var Jobid = $("[id*=drpname]").val();
        var Depid = $("[id*=drpDepart]").val();
        var BudgHrs = $("[id*=txtBudgHrs]").val();
        var AllocatBudg = $("[id*=txtAllocatHrs]").val();
        var BudgDt = $("[id*=txtBudgDate]").val();
        if (Jobid == '' || BudgHrs == '' || AllocatBudg == '' || BudgDt == '') {
            alert("Kindly fill the value");
        }
        else {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/ProjectDepartment_Budgeting.asmx/SaveDeptBudget",
                data: '{compid:' + compid + ',Jobid:' + Jobid + ',Depid:' + Depid + ',BudgHrs:' + BudgHrs + ',AllocatBudg:' + AllocatBudg + ',BudgDt:"' + BudgDt + '"}',
                dataType: "json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList[0].depid > 0) {
                        alert("Department Budgeted Successfully!!!");
                        $("[id*=dvGrid]").show();
                        $("[id*=dvAddProject]").hide();
                        $("[id*=dvbottom]").hide();
                        SecoundGridfill();
                    } else {
                        if (myList[0].depid == 0) {
                            alert("Department Budgeted Already!!!");
                        } else {
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

    function Reset() {
        $("[id*=dvGrid]").hide();
        $("[id*=dvAddProject]").show();
        $("[id*=dvbottom]").show();
        $("[id*=tdSave]").show();
        $("[id*=btnSave]").show();
        $("[id*=btnUpdate]").hide();
        $("[id*=btnEditBudget]").hide();
        $("[id*=txtBudgHrs]").val('');
        $("[id*=txtAllocatHrs]").val('');
        $("[id*=txtBudgDate]").val('');
        $("[id*=drpname]").selectize()[0].selectize.destroy();
        $("[id*=drpDepart]").selectize()[0].selectize.destroy();
        $("[id*=drpname]").val(0);
        $("[id*=drpDepart]").val(0);
        $("[id*=drpname]").selectize()[0].selectize.enable();
        $("[id*=drpDepart]").selectize()[0].selectize.enable();
        document.getElementById("ctl00_ContentPlaceHolder1_ProjectDepartment_Budgeting_txtBudgHrs").disabled = false;
        document.getElementById("ctl00_ContentPlaceHolder1_ProjectDepartment_Budgeting_txtAllocatHrs").disabled = false;
        document.getElementById("ctl00_ContentPlaceHolder1_ProjectDepartment_Budgeting_txtBudgDate").disabled = false;
    }

    function FillDrpClient() {
        var compid = $("[id*=hdnCompanyid]").val();
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectDepartment_Budgeting.asmx/FillDrpClient",
            data: '{compid:' + compid + '}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length == 0) { }
                else {
                    $("[id*=drpname]").empty();
                    $("[id*=drpname]").append("<option value=" + 0 + ">Select</option>");
                    for (var i = 0; i < myList.length; i++) {
                        $("[id*=drpname]").append("<option value=" + myList[i].Jobid + ">" + myList[i].Clientname + "</option>");
                    }
                    $("[id*=drpname]").selectize();

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

    //show popup
    function ShowModalPopup() {
        var c = $("[id*=hdnClientName]").val();
        var p = $("[id*=hdnPropjectName]").val();
        var d = $("[id*=hdnDeptName]").val();
        $("[id*=lblClientBudgetName]").html(c);
        $("[id*=lblProjectBudgetName]").html(p);
        $("[id*=lblDepartmentName]").html(d);
        $find("mailingListModalPopupBehavior").show();
        clareformEditProjectbudget();
        Gettempdata();
    }

    //while canceling the temp table will get empty and the page go back
    function CnacelEmptyTemp() {
        var compid = $("[id*=hdnCompanyid]").val();
        var jobid = $("[id*=drpname]").val();
        var Dept = $("[id*=drpDepart]").val();
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectDepartment_Budgeting.asmx/CnacelEmptyTemp",
            data: '{compid:' + compid + ',Jobid:' + jobid + ',Dept:' + Dept + '}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList[0].temp_Id > 0) {
                    SecoundGridfill();
                }
            },
            failure: function (response) {
            },
            error: function (response) {
            }
        });
    }

    function UpdateDepartmentBudget() {
        var compid = $("[id*=hdnCompanyid]").val();
        var jobid = $("[id*=drpname]").val();
        var Dept = $("[id*=drpDepart]").val();
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectDepartment_Budgeting.asmx/UpdateDepartmentBudget",
            data: '{compid:' + compid + ',Jobid:' + jobid + ',Dept:' + Dept + '}',
            dataType: "json",
            success: function (msg) {
                var mylist = jQuery.parseJSON(msg.d);
                if (mylist.length > 0) {
                    alert("Department Budget Updated Successfully !!!")
                    SecoundGridfill();
                    $("[id*=dvGrid]").show();
                    $("[id*=dvAddProject]").hide();
                    $("[id*=dvbottom]").hide();
                }
            }
        });
    }

    function Gettempdata() {
        var compid = $("[id*=hdnCompanyid]").val();
        var jobid = $("[id*=drpname]").val();
        var Dept = $("[id*=drpDepart]").val();
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectDepartment_Budgeting.asmx/Gettempdata",
            data: '{compid:' + compid + ',Jobid:' + jobid + ',Dept:' + Dept + '}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                poptable(myList);
            },
            failure: function (response) {
            },
            error: function (response) {
            }
        });
    }

    function poptable(response) {
        clareformEditProjectbudget();
        $("[id*=tblPrevous]").append("<tr class='mytable'><th>Sr.No</th><th>From Date</th><th>To Date</th><th>Budgeted Hours</th><th>Allocated Hours</th><th>Edit</th></tr>");
        if (response.length > 0) {
            for (var i = 0; i < response.length; i++) {
                $("[id*=tblPrevous]").append("<tr class='mytable'><td style='text-align: center;'>" +
                            (i + 1) + "</td><td width='80px'>" + //sr no
                            response[i].fromdate + "</td> <td width='80px'>" + //FromDate
                            response[i].todate + "</td> <td style='text-align: right;'>" + //Todate
                            response[i].Budgethours + "</td> <td style='text-align: right;'>" + //Budget Amount
                            response[i].AllocatedHours + "</td >" + //Hours
                            "<td><img src='../images/edit.png' style='cursor:pointer;' onclick=updatedata2(" + response[i].temp_Id + ") ></td></tr>");

                //Set Updated Amount & hours
                if (response[i].todate == '') {
                    $("[id*=txtBudgHrs]").val(response[i].Budgethours);
                    $("[id*=txtAllocatHrs]").val(response[i].AllocatedHours);
                    $("[id*=txtBudgDate]").val(response[i].fromdate);
                }
            }
        }
        else {
            $("[id*=tblPrevous]").append("<tr><td style='height:20px; border:1px solid #BCBCBC;' colspan='15'>No Records Found !</td></tr>");
        }
        $('.loader2').fadeOut(550);
    }

    function updatedata2(id) {
        $('.loader2').fadeIn(200);
        $("[id*=hdnDepartmentBudgetingtemp]").val(id);
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
            url: "../Handler/ProjectDepartment_Budgeting.asmx/GetTempRecordEdit",
            data: JSON.stringify(data),
            dataType: "json",
            success: function (msg) {
                var mylist = jQuery.parseJSON(msg.d);
                if (mylist.length > 0) {
                    $("[id*=txteditBudgetedDate]").val(mylist[0].fromdate);
                    $("[id*=txteditBudgetHoursp]").val(mylist[0].Budgethours);
                    $("[id*=txtAlloctHrsp]").val(mylist[0].AllocatedHours);
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

    function clareformEditProjectbudget() {
        $("[id*=tblPrevous]").empty();
        $("[id*=txteditBudgetHoursp]").val('0');
        $("[id*=txtAlloctHrsp]").val('0');
        $("[id*=txteditBudgetedDate]").val('');
        $("[id*=hdnDepartmentBudgetingtemp]").val('0');
    }

    /// hide popup
    function HideModalPopup() {
        $find("mailingListModalPopupBehavior").hide();
        return false;
    }

    ///Fill Department Name Dropdown
    function FilldrpDept(dept) {
        var compid = $("[id*=hdnCompanyid]").val();
        var Jobid = $("[id*=drpname]").val();
        var deptid = 0;
        if (dept > 0) {
            deptid = dept;
        }
        if (Jobid == '') { }
        else {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/ProjectDepartment_Budgeting.asmx/FilldrpDept",
                data: '{compid:' + compid + ',Jobid:' + Jobid + ',dept:' + deptid + '}',
                dataType: "json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList.length == 0) { }
                    else {
                        $("[id*=drpDepart]").selectize()[0].selectize.destroy();
                        $("[id*=drpDepart]").empty();
                        $("[id*=drpDepart]").append("<option value=" + 0 + ">Select</option>");
                        for (var i = 0; i < myList.length; i++) {
                            $("[id*=drpDepart]").append("<option value=" + myList[i].depid + ">" + myList[i].Deptname + "</option>");
                        }
                        if (dept > 0) {
                            $("[id*=drpDepart]").val(dept);
                            $("[id*=drpname]").selectize()[0].selectize.disable();
                            $("[id*=drpDepart]").selectize()[0].selectize.disable();

                        } else {
                            $("[id*=drpDepart]").selectize();
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

    ///Edit Department
    function EditDept(jobid, dipt) {
        var compid = $("[id*=hdnCompanyid]").val();
        var Jobid = jobid;
        var dept = dipt;
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ProjectDepartment_Budgeting.asmx/EditDept",
            data: '{compid:' + compid + ',Jobid:' + Jobid + ',dept:' + dept + '}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length > 0) {
                    $("[id*=txtBudgHrs]").val(myList[0].Budgethours);
                    $("[id*=txtAllocatHrs]").val(myList[0].AllocatedHours);
                    $("[id*=txtBudgDate]").val(myList[0].fromdate);
                    $("[id*=hdnDeptBudId]").val(myList[0].temp_Id);

                    document.getElementById("ctl00_ContentPlaceHolder1_ProjectDepartment_Budgeting_txtBudgHrs").disabled = true;
                    document.getElementById("ctl00_ContentPlaceHolder1_ProjectDepartment_Budgeting_txtAllocatHrs").disabled = true;
                    document.getElementById("ctl00_ContentPlaceHolder1_ProjectDepartment_Budgeting_txtBudgDate").disabled = true;
                }
                else {

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

    ///delete the Budget
    function BudgetDelete(i) {
        var newDate = new Date();
        var row = i.closest("tr")
        var x = confirm("Are you sure want to delete?");
        if (x == true) {
            var Dept = row.find("input[name=hdndepid]").val();
            var Jobid = row.find("input[name=hdnjobid]").val();
            var Compid = $("[id*=hdnCompanyid]").val();
            var ip = $("[id*= hdnIP]").val();
            var usr = $("[id*= hdnName]").val();
            var uT = $("[id*= hdnUser]").val();
            $.ajax({
                type: "POST",
                url: "../Handler/ProjectDepartment_Budgeting.asmx/BudgetDelete",
                data: '{Compid:' + Compid + ',Dept:' + Dept + ',Jobid:' + Jobid + ',ip:"' + ip + '",usr:"' + usr + '", ut:"' + uT + '", dt: "' + newDate + '" }',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList == null) {
                    }
                    if (myList[0].depid > 0) {
                        alert("Budget was Deleted!!! ");
                        SecoundGridfill();
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
        else {
            return false;
        }
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

    function validBudg() {
        var BudgHrs = $("[id*=txtBudgHrs]").val();
        var AllocatBudg = $("[id*=txtAllocatHrs]").val();
        if (parseFloat(BudgHrs) > parseFloat(AllocatBudg)) {
        } else {
            alert("Allocated Hours cannot be more than Budgeted Hours")
            $("[id*=txtAllocatHrs]").val(0);
        }
    }

</script>

<style type="text/css">
    .auto-style7 {
        width: 188px;
        height: 36px;
    }
</style>

<div id="dvGrid" class="divstyle" style="height: auto;">
    <asp:HiddenField ID="hdnDeptBudId" runat="server" />
    <asp:HiddenField ID="hdnPropjectName" runat="server" />
    <asp:HiddenField ID="hdnClientName" runat="server" />
    <asp:HiddenField ID="hdnDeptName" runat="server" />
    <asp:HiddenField ID="hdnIP" runat="server" />
    <asp:HiddenField ID="hdnName" runat="server" />
    <asp:HiddenField ID="hdnUser" runat="server" />
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <label class="Head1">Department Budgeting</label>
        </div>
    </div>
    <div>
        <div class="serachJob" style="float: left; width: 100%; margin: 20px; overflow: auto;">
            <div id="searchbr" runat="server">
                <asp:Label ID="Label24" runat="server" Text="Search Client" CssClass="LabelFontStyle labelChange"></asp:Label>
                <asp:TextBox ID="txtbrsearch" runat="server" Width="250px" CssClass="txtbox" Font-Names="Verdana"
                    Font-Size="8pt"></asp:TextBox>
                <input id="btnSearch" type="button" value="Search" class="TbleBtnsPading TbleBtns" />
                <input id="btnAdd" type="button" value="Add Department Budget" class="TbleBtnsPading TbleBtns" />

            </div>
        </div>
    </div>
    <div class="divstyle" style="height: auto; overflow: visible">

        <table id="tblBudget" cellspacing="0" class="norecordTble" border="1" style="border-collapse: collapse; width: 100%;">
            <thead>
            </thead>
        </table>

    </div>
</div>
<div id="dvAddProject" class="divstyle" style="height: auto; display: block;">
    <asp:HiddenField ID="hdnCompanyid" runat="server" />

    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <label class="Head1">Department Budgeting</label>
        </div>
    </div>

    <div class="serachJob" style="float: left; width: 100%; margin: 20px;">
        <div id="Div1" runat="server">
            <table>
                <tr>
                    <td>
                        <asp:Label ID="Label1" Font-Bold="true" runat="server" Text="Client/Project Name" CssClass="LabelFontStyle labelChange"></asp:Label>
                    </td>
                    <td>
                        <select id="drpname" name="drpname" class="DropDown" style="width: 350px; height: 25px;">
                            <option value="0">--Select--</option>
                        </select>
                    </td>
                    <td style="padding-left: 150px;">
                        <asp:Label ID="Label2" runat="server" Text="Department Name" CssClass="LabelFontStyle labelChange"></asp:Label>
                    </td>
                    <td>
                        <select id="drpDepart" name="drpDepart" class="DropDown" style="width: 250px; height: 25px;">
                            <option value="0">Select</option>
                        </select>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <div>
        <table style="margin: 20px;">
            <tr>
                <td class="auto-style7">
                    <label style="font-size: 14px; font-family: Arial; font-weight: bold;">Budgeted Hours </label>
                </td>
                <td>
                    <asp:TextBox ID="txtBudgHrs" Width="130px" Style="text-align: right;" runat="server"
                        CssClass="txtbox calbox" onkeypress="return isNumber(event)"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="auto-style7">
                    <label style="font-size: 14px; font-family: Arial; font-weight: bold;">Allocated Hours </label>
                </td>
                <td>
                    <asp:TextBox ID="txtAllocatHrs" Width="130px" Style="text-align: right;" runat="server"
                        CssClass="txtbox calbox" onkeypress="return isNumber(event)" onchange="validBudg()"></asp:TextBox>
                </td>

            </tr>
            <tr>
                <td class="auto-style7">
                    <label style="font-size: 14px; font-family: Arial; font-weight: bold;">Budgeted Date </label>
                </td>
                <td>
                    <asp:TextBox ID="txtBudgDate" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                    <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txtBudgDate" Mask="99/99/9999" MaskType="Date" MessageValidatorTip="true">
                    </cc1:MaskedEditExtender>
                    <cc1:CalendarExtender runat="server" ID="CalendarExtender4" TargetControlID="txtBudgDate" Format="dd/MM/yyyy" Enabled="True">
                    </cc1:CalendarExtender>
                </td>
                <td>
                    <input id="btnEditBudget" type="button" value="Edit Budget" class="TbleBtnsPading TbleBtns" onclick="return ShowModalPopup()" />
                </td>
            </tr>
        </table>
    </div>

    <%-- Popup for the Department Budget--%>
    <div>
        <asp:Button ID="hiddenLargeImage" runat="server" Style="display: none" />
        <cc1:ModalPopupExtender runat="server" ID="ModalPopupExtender1" BehaviorID="mailingListModalPopupBehavior"
            TargetControlID="hiddenLargeImage" PopupControlID="divDeptPopup" BackgroundCssClass="modalBackground"
            OkControlID="imgClose" DropShadow="false" RepositionMode="RepositionOnWindowScroll">
        </cc1:ModalPopupExtender>
        <div id="divDeptPopup" style="width: 560px; background-color: #FFFFFF;">
            <div style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff; font-weight: bold;">
                <div style="width: 90%; float: left; height: 20px; padding-left: 2%; padding-top: 1%">
                    <asp:Label ID="Label18" runat="server" Text="Add Department Rrecords"
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
                    <tr>
                        <td>
                            <b class="labelChange">Department Name</b>
                        </td>
                        <td width="70%" colspan="3">
                            <label id="lblDepartmentName"></label>
                        </td>
                    </tr>
                </table>
                <table cellspacing="0" cellpadding="0" align="center" style="margin: 4px auto 4px auto;">
                    <tr>
                        <td><b>
                            <asp:HiddenField ID="hdnDepartmentBudgetingtemp" runat="server" />
                            From Date&nbsp;

                        </b></td>
                        <td>
                            <asp:TextBox ID="txteditBudgetedDate" Style="margin: 2px;" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txteditBudgetedDate"
                                Mask="99/99/9999" MaskType="Date" MessageValidatorTip="true" />
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txteditBudgetedDate"
                                PopupButtonID="txteditBudgetedDate" Format="dd/MM/yyyy" Enabled="True">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Budgeted Hours&nbsp;</b></td>
                        <td>
                            <asp:TextBox ID="txteditBudgetHoursp" Width="100px" Style="margin: 2px; text-align: right;" runat="server"
                                CssClass="txtbox calbox" onkeypress="return isNumber(event)"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Allocated Hours&nbsp;</b></td>
                        <td>
                            <asp:TextBox ID="txtAlloctHrsp" Width="100px" Style="margin: 2px; text-align: right;" runat="server"
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
    </div>

    <div id="dvbottom">
        <table style="margin: 20px;">
            <tr>
                <td id="tdsave" style="padding-left: 5px;">
                    <input id="btnSave" type="button" value="Save" class="TbleBtnsPading TbleBtns" />
                </td>
                <td id="tdupdate" style="padding-left: 5px;">
                    <input id="btnUpdate" type="button" value="Update" class="TbleBtnsPading TbleBtns" />
                </td>
                <td style="padding-left: 5px;">
                    <input id="btnCancel" type="button" value="Cancel" class="TbleBtnsPading TbleBtns" />
                </td>
            </tr>
        </table>
    </div>
</div>
