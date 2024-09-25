<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Job_Budgeting.ascx.cs"
    Inherits="controls_Job_Budgeting" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
    <script src="../js/jquery.min.js" type="text/javascript"></script>
    <script src="../js/bootstrap.bundle.min.js" type="text/javascript"></script>
    <script src="../js/blockui.min.js" type="text/javascript"></script>
    <script src="../js/ripple.min.js" type="text/javascript"></script>
    <script src="../js/jgrowl.min.js" type="text/javascript"></script>
    <script src="../js/pnotify.min.js" type="text/javascript"></script>
    <script src="../js/noty.min.js" type="text/javascript"></script>

    <script src="../js/form_select2.js" type="text/javascript"></script>
    <script src="../js/d3.min.js" type="text/javascript"></script>

    <script src="../jquery/moment.js" type="text/javascript"></script>
    <script src="../js/interactions.min.js" type="text/javascript"></script>
    <script src="../js/datatables.min.js" type="text/javascript"></script>

    <script src="../js/uniform.min.js" type="text/javascript"></script>
    <script src="../js/app.js" type="text/javascript"></script>
    <script src="../js/select2.min.js" type="text/javascript"></script>

    <script src="../js/Ajax_Pager.min.js" type="text/javascript"></script>

    <script src="../js/components_modals.js" type="text/javascript"></script>
    <script src="../js/echarts.min.js" type="text/javascript"></script>
    <script src="../js/PopupAlert.js" type="text/javascript"></script>

<script type="text/javascript" language="javascript">

    $(document).ready(function () {

        var Pageindex = $("[id*=hdnpageindex]").val();
        var PageSize = 25;
        $("[id*=hdnPages]").val(1);
        //        Get_Project_Budgeting_ProjectName();
        //        usp_get_jobname();
        // Get_Project_Budgeting_ProjectName_Clientname();

        $("[id*=lblbudhr]").hide();
        $("[id*=lblBudHrs]").hide();
        $("[id*=lblbufhr]").hide();
        $("[id*=lblBufHrs]").hide();
        $("[id*=ddldept]").hide();
        $("[id*=Label1]").hide();
        $("[id*=lblProjectHrs]").hide();

        ////job budget grid date change
        $('#txtfromdate').blur(function () {

            var fr = $('#txtfromdate').val();
            var rw = '';
            var ij = 0;
            $('#tbl_jobfillgrid > tbody  > tr').each(function () {
                rw = $(this).closest("tr");
                var j = $("#txtfr", rw).val(fr);

            });
        });


        $('#txttodate').blur(function () {
            var tod = $('#txttodate').val();
            var rw = '';
            var ij = 0;
            $('#tbl_jobfillgrid > tbody  > tr').each(function () {
                rw = $(this).closest("tr");
                var j = $("#txtto", rw).val(tod);

            });
        });

        $('#txtbudhrss').blur(function () {
            var br = $('#txtbudhrss').val();
            var rw = '';
            var ij = 0;
            $('#tbl_jobfillgrid > tbody  > tr').each(function () {
                rw = $(this).closest("tr");
                var j = $("#txtbudhrs", rw).val(br);
            });
        });

        $('#txtbudamtt').blur(function () {
            var ba = $('#txtbudamtt').val();
            var rw = '';
            var ij = 0;
            $('#tbl_jobfillgrid > tbody  > tr').each(function () {
                rw = $(this).closest("tr");
                var j = $("#txtbudamt", rw).val(ba);

            });
        });

        $("[id*=ddlProject]").on('change', function () {
            Get_Budgeting_Allocation_Details();
            // var prj = $('#ddlProject option:selected').text();
            var prj = $("[id*=ddlProject]").find('option:selected').text();
            $('#lblprojectclinetname').html(prj);
            //Get_Job_Budgeting_DepartmentNames();
        });

        $("#txtStartDate").on('change', function () {
            Get_Budgeting_Allocation_Details();
            //var prj = $('#ddlProject option:selected').text();
            var prj = $("[id*=ddlProject]").find('option:selected').text();
            $('#lblprojectclinetname').html(prj);
            // Get_Job_Budgeting_DepartmentNames();
        });

        $("#txtEndDate").on('change', function () {
            Get_Budgeting_Allocation_Details();
            // var prj = $('#ddlProject option:selected').text();
            var prj = $("[id*=ddlProject]").find('option:selected').text();
            $('#lblprojectclinetname').html(prj);
            // Get_Job_Budgeting_DepartmentNames();
        });

        /////////add Project Budgeting
        $("#btnaddjob").on('click', function () {
            $("[id*=txtBudAllocHrs]").val("0.00");
            $("[id*=hdnBudHrs]").val(0);

            Get_fill_job_budgeting();
            $("#txtbudamtt").val("");
            ///temp
            // Get_Job_Budgeting_JobName();
            $("[id*=hdnBudId]").val(0);
            //  $find("ListModalPopupBehavior").show();

        });

        //////save Project Budgeting
        $("#BtnSubmit").on('click', function () {
            if ($("#SelectJobName").val() == 0) {
                alert("Please select Job Name");
                return false;
            }
            if (parseFloat($("#txtBudAllocHrs").val()) == 0) {
                alert("Please Add Job Hours");
                return false;
            }
            Save_Job_Budgeting_Allocated_Hours();
            //$find("BudModal").hide();
        });

        ////save Department budgeting
        $("#SaveDeptBudgeting").on('click', function () {
            Save_Job_budgeting_Budget_Hours();
        });
    });



    function Get_Job_Budgeting_DepartmentNames() {
        $.ajax({
            type: "POST",
            url: "../Handler/Job_budgeting.asmx/Get_Job_Budgeting_DepartmentNames",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + $("[id*=ddlProject]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            $("[id*=ddldept]").empty();
                            $("[id*=ddldept]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {

                                $("[id*=ddldept]").append("<option value=" + myList[i].Id + "," + myList[i].BudgetHours + ">" + myList[i].Name + "</option>");
                            }
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

    /////////save Department Budgeting

    function Save_Job_budgeting_Budget_Hours() {
        $.ajax({
            type: "POST",
            url: "../Handler/Job_budgeting.asmx/Save_Job_budgeting_Budget_Hours",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + $("#ddlProject").val() + ',DeptId:' + $("#ddldept").val().split(',')[0] + ',BudHrs:"' + $("#txtBudhrs").val() + '",BudHrsId:' + $("[id*=hdnBudId]").val() + ',BudDate:"' + $("#txtDate").val() + '",DetailBudId:' + $("[id*=hdnDetailBudId]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            if (parseFloat(myList[0].Id) > 0) {
                                alert("Activity budgeting saved successfully..");
                                Get_Job_Budgeting_BudgetDetails();
                                //$find("BudModal").hide();
                            }
                            else {

                                alert("Please Select Date Between " + myList[0].FromDate + " and " + myList[0].ToDate);
                                return false;

                            }
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

    ///////////Get Department Name

    function Get_Job_Budgeting_JobName() {
        $.ajax({
            type: "POST",
            url: "../Handler/Job_budgeting.asmx/Get_Job_Budgeting_JobName",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',DeptId:' + $("#ddldept").val().split(',')[0] + ',JobId:' + $("#ddlProject").val() + '}',

            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            $("[id*=SelectJobName]").empty();
                            $("[id*=SelectJobName]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {

                                $("[id*=SelectJobName]").append("<option value=" + myList[i].Id + ">" + myList[i].Name + "</option>");
                            }
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

    ///////////save budgeting hours
    function Save_Job_Budgeting_Allocated_Hours() {
        var fdate = $("[id*=txtfromdate]").val();
        var todate = $("[id*=txttodate]").val();
        var budamt = $("[id*=txtbudamtt]").val();
        var BudHrs = $("[id*=txtbudhrss]").val();
        var JobId = $("#ddlProject").val();
        var budget = '';
        var bb = '';
        if (budamt == '') {
            budamt = 0;
        }
        if (BudHrs == '') {
            BudHrs = 0;
        }
        $('#tbl_jobfillgrid > tbody  > tr').each(function () {
            row = $(this).closest("tr");
            var rIndex = $(this).closest("tr")[0].sectionRowIndex;
            var fr = $("#txtfr", row).val();
            var tod = $("#txtto", row).val();
            var jobid = $("#hdnjobid", row).val();
            var bhr = $("#txtbudhrs", row).val();
            var ba = $("#txtbudamt", row).val();
            var mjid = $("#hdnmjobid", row).val();
            var dpid = 0
            if (ba == '') {
                ba = 0;
            }
            if (bhr == '') {
                bhr = 0;
            }
            if (fr != '') {

                budget = budget + fr + "," + tod + "," + jobid + "," + bhr + "," + ba + "," + mjid + "," + dpid + ",";

            }
            if (budget != '') {
                bb = bb + budget + "^";
                budget = '';
            }
        });

        $.ajax({
            type: "POST",
            url: "../Handler/Job_budgeting.asmx/Save_Job_Budgeting_Allocated_Hours",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + JobId + ',DeptId:' + 0 + ',BudHrs:"' + BudHrs + '",fdate: "' + fdate + '",todate: "' + todate + '",budamt: "' + budamt + '", bb: "' + bb + '" }',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            alert("Data Saved Successfully..");

                            Get_Budgeting_Allocation_Details();
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

    function Get_Budgeting_Allocation_Details() {
        var DeptId = 0;
        var JobId = $("#ddlProject").val();
        $("#lblProjectHrs").text("Department Hours :" + $("[id*=ddldept]").val().split(',')[1] + ".00");
        $("#btnaddjob").show();
        $("#btnaddjob").attr("Value", "Add Budget");
        $("#tblBudgetDetails").show();
        var StartDate = $("[id*=txtStartDate]").val();
        var pgindex = $("[id*=hdnPages]").val();
        var EndDate = $("[id*=txtEndDate]").val();
        var pgsize = 25;
        if (StartDate == '') {
            return;
        }
        if (EndDate == '') {
            return;
        }
        $.ajax({
            type: "POST",
            url: "../Handler/Job_budgeting.asmx/Get_Job_Budgeting_DepartmentDetails",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + JobId + ',DeptId:' + DeptId + ',FromDate:"' + StartDate + '", ToDate:"' + EndDate + '", pageindex : ' + pgindex + ',pagesize: ' + pgsize + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                var TotalHrs = 0;
                var tbl = '';
                $("[id*=tblBudgetDetails] tr").remove();


                tbl = tbl + "<thead><tr>";
                tbl = tbl + "<th class='labelChange' style='text-align: center;font-weight: bold;'>Sr.No</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Job Name</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>From Date</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>To Date </th>";

                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Allocated Hrs. </th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Allocated Amount </th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Edit</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Delete</th>";
                tbl = tbl + "</tr></thead><tbody>";

                var RecordCount = 0;
                if (myList.length > 0) {


                    for (var i = 0; i < myList.length; i++) {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td>" + myList[i].sino + "<input type='hidden' id='hdnjobdetid' name='hdnjobdetid' value=" + myList[i].Jobdetid + "></td>";
                        tbl = tbl + "<td>" + myList[i].JobName + "</td>";
                        tbl = tbl + "<td>" + "<input type='Date' id='dtfrdate_' name='dtfrdate_' value=" + myList[i].FromDate + " disabled></td>";
                        tbl = tbl + "<td>" + "<input type='Date' id='dttodate_' name='dttodate_' value=" + myList[i].ToDate + " disabled></td>";
                        tbl = tbl + "<td>" + "<input type='Text' id='txtbdhrs_' name='txtbdhrs_' value=" + myList[i].BudgetHours + " disabled></td>";
                        tbl = tbl + "<td>" + "<input type='Text' id='txtbdamt_' name='txtbdamt_' value=" + myList[i].budamt + " .00  disabled  style='text-align: right;'></td> ";
                        tbl = tbl + "<td>" + "<img id='btneedit' name='btneedit' src='../images/edit.png' onclick='showbudedit($(this))'/>" + "<img id='btneupdate' name='btneupdate' src='../images/update.png' style='width:30px;display:none;' onclick='showbudUpdate($(this))'/>" + "<img id='btnecancle' name='btnecancle' src='../images/close.png' style='width:15px;padding-bottom:6px;padding-left: 3px;display:none;' onclick='Showecancle($(this))'/></td>";
                        tbl = tbl + "<td>" + "<img src='../images/Delete.png' onclick='showdelete($(this))'/></td>";
                        tbl = tbl + "</tr>";

                        //$("td", trL).eq(0).html(myList[i].sino + "<input type='hidden' id='hdnjobdetid' name='hdnjobdetid' value=" + myList[i].Jobdetid + ">");
                        //$("td", trL).eq(1).html(myList[i].JobName);
                        //$("td", trL).eq(2).html("<input type='Date' id='dtfrdate_' name='dtfrdate_' value=" + myList[i].FromDate + " disabled>");
                        //$("td", trL).eq(3).html("<input type='Date' id='dttodate_' name='dttodate_' value=" + myList[i].ToDate + " disabled>");
                        //$("td", trL).eq(4).html("<input type='Text' id='txtbdhrs_' name='txtbdhrs_' value=" + myList[i].BudgetHours + " disabled>");
                        //$("td", trL).eq(5).html("<input type='Text' id='txtbdamt_' name='txtbdamt_' value=" + myList[i].budamt + " .00  disabled  style='text-align: right;'> ");
                        //$("td", trL).eq(6).html("<img id='btneedit' name='btneedit' src='../images/edit.png' onclick='showbudedit($(this))'/>" + "<img id='btneupdate' name='btneupdate' src='../images/update.png' style='width:30px;display:none;' onclick='showbudUpdate($(this))'/>" + "<img id='btnecancle' name='btnecancle' src='../images/close.png' style='width:15px;padding-bottom:6px;padding-left: 3px;display:none;' onclick='Showecancle($(this))'/>");
                        //$("td", trL).eq(7).html("<img src='../images/Delete.png' onclick='showdelete($(this))'/>");
                        //$("[id*=tblBudgetDetails]").append(trL);
                        //trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);
                    }

                    if (parseFloat(myList[0].Totalcount) > 0) {
                        RecordCount = parseFloat(myList[0].Totalcount);
                    }
                    Pager(RecordCount);
                }
                else {

                    //$("td", trL).eq(0).html("");
                    //$("td", trL).eq(1).html("");
                    //$("td", trL).eq(2).html("");
                    //$("td", trL).eq(3).html("No record found");
                    //$("td", trL).eq(4).html("");
                    //$("td", trL).eq(5).html("");
                    //$("td", trL).eq(6).html("");
                    //$("td", trL).eq(7).html("");
                    //$("[id*=tblBudgetDetails]").append(trL);
                    //trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);
                    tbl = tbl + "<tr>";
                    tbl = tbl + "<td colspan='8' style='text-align: center;'>" + "No record found" + "</td>";
                    //tbl = tbl + "<td></td>");
                    //tbl = tbl + "<td></td>";
                    //tbl = tbl + "<td></td>";
                    //tbl = tbl + "<td></td>";
                    //tbl = tbl + "<td></td> ";
                    //tbl = tbl + "<td></td>";
                    //tbl = tbl + "<td>" + "<img src='../images/Delete.png' onclick='showdelete($(this))'/></td>";
                    tbl = tbl + "</tr>";
                }

                tbl = tbl + "</tbody>";
                tbl = tbl + "</table>";
                $("[id*=tblBudgetDetails]").append(tbl);

                $("#lblBudHrs").text(TotalHrs);
                $("#lblBufHrs").text(parseFloat($("#lblProjectHrs").text().split(':')[1]) - TotalHrs);

            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }

    function Pager(RecordCount) {
        $(".Pager").ASPSnippets_Pager({
            ActiveCssClass: "current",
            PagerCssClass: "pager",
            PageIndex: parseInt($("[id*=hdnPages]").val()),
            PageSize: parseInt(25),
            RecordCount: parseInt(RecordCount)
        });


        $(".Pager .page").on("click", function () {
            $("[id*=hdnPages]").val($(this).attr('page'));

            Get_Budgeting_Allocation_Details(($(this).attr('page')), 25);
        });
    }

    ///add budget 
    function Get_fill_job_budgeting() {
        var jobid = $("[id*=ddlProject]").val();
        var c = $("[id*=hdncompid]").val();
        var fdate = $("[id*=txtfromdate]").val();
        var todate = $("[id*=txttodate]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/Job_budgeting.asmx/Get_fill_job_budgeting",
            data: '{Compid:' + c + ' ,JobId:' + jobid + ',fdate:"' + fdate + '", todate:"' + todate + '"}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var tbl = '';
                $("[id*=tbl_jobfillgrid] tr").remove();

                tbl = tbl + "<thead><tr>";
                tbl = tbl + "<th class='labelChange' style='text-align: center;font-weight: bold;'>Sr.No</th>";

                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>From Date</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>To Date </th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Job Name</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Allocated Hrs. </th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Allocated Amt. </th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Delete</th>";


                tbl = tbl + "</tr></thead><tbody>";

                if (myList.length > 0) {


                    for (var i = 0; i < myList.length; i++) {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td >" + myList[i].sino + "<input type='hidden' id='hdnsino' name='hdnsino' value=" + myList[i].sino + "></td>";
                        tbl = tbl + "<td ><input type='date' id='txtfr' name='txtfr'  value=" + myList[i].FromDate + " ></td>";
                        tbl = tbl + "<td ><input type='date' id='txtto' name='txtto'  value=" + myList[i].todate + " >" + "<input type='hidden' id='hdnjobid' name='hdnjobid'  value=" + myList[i].jid + " ></td>";
                        tbl = tbl + "<td ><a href='#'  onclick='View_Show($(this))' >" + myList[i].Name + "</a><input type='hidden' id='hdnjobname' name='hdnjobname'  value=" + myList[i].Name + " > " + "<input type='hidden' id='hdnmjobid' name='hdnmjobid'  value=" + myList[i].jobid + " ></td>";
                        tbl = tbl + "<td ><input type='Textbox' id='txtbudhrs' name='txtbudhrs' style='width:80px; text-align: center;' value=" + myList[i].budhrs + " ></td>";
                        tbl = tbl + "<td ><input type='Textbox' id='txtbudamt' name='txtbudamt' style='text-align: right;' value=" + myList[i].budamt + " ></td>";
                        tbl = tbl + "<td style='text-align: center;'><a class='list-icons-item '><i class='icon-trash text-danger-600'  onclick='Delete_Show($(this))'></i></a></td></tr>";

                        tbl = tbl + "</tr>";
                    }
                    tbl = tbl + "</tbody>";
                    $("[id*=tbl_jobfillgrid]").append(tbl);
                } else {

                    $("td", trL).eq(0).html("");
                    $("td", trL).eq(1).html("");
                    $("td", trL).eq(2).html("No record found");
                    $("td", trL).eq(3).html("");
                    $("td", trL).eq(4).html("");
                    $("td", trL).eq(5).html("");


                    $("[id*=tbl_jobfillgrid]").append(trL);
                    trL = $("[id*=tbl_jobfillgrid] tbody tr:last-child").clone(true);

                }
                ///defaults date
                var d = new Date();
                var d = moment(d).format('MMDDYYYY');
                var mm = d.slice(0, 2);
                var y = new Date();
                y = moment(y).format('YYYYMMDD');
                var yy = y.slice(0, 4);
                if (parseFloat(mm) < 4) {
                    yy = parseFloat(yy) - 1;
                }

                var n = yy + '-04-01';
                $("[id*=txtfromdate]").val(n);
                $('#txtfromdate').blur();

                yy = parseFloat(yy) + 1;
                var n = yy + '-03-31';
                $("[id*=txttodate]").val(n);
                $('#txttodate').blur();

                var budhrs = '';
                $("[id*=txtbudhrss]").val(budhrs);
                $('#txtbudhrss').blur();

            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }

    function showAllocation(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdnDeptId]").val();
        $("[id*=hdnBudId]").val(Rtid);
        var BudHrs = row.find("td").eq(2).html();
        $("[id*=hdnBudHrs]").val(BudHrs);
        $("[id*=hdnDetailBudId]").val(0);
        $("#txtBudhrs").val('0.00');
        get_Date_Validation();
        Get_Job_Budgeting_BudgetDetails();
        // $find("ListModalPopupBehaviorDept").show();
    }

    function Get_Job_Budgeting_BudgetDetails() {
        $.ajax({
            type: "POST",
            url: "../Handler/Job_budgeting.asmx/Get_Job_Budgeting_BudgetDetails",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',BudHrsId:' + $("[id*=hdnBudId]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var trL = $("[id*=TblDeptbudDetails] tbody tr:last-child");
                var TotalHrs = 0;
                $("[id*=TblDeptbudDetails] tbody").empty();
                if (myList == null) {
                    $("td", trL).eq(0).html("");
                    $("td", trL).eq(1).html("");
                    $("td", trL).eq(2).html("No record found");
                    $("td", trL).eq(3).html("");
                    $("td", trL).eq(4).html("");
                    $("td", trL).eq(5).html("");
                    $("[id*=TblDeptbudDetails]").append(trL);
                    trL = $("[id*=TblDeptbudDetails] tbody tr:last-child").clone(true);
                }
                else {

                    if (myList.length > 0) {
                        $("td", trL).eq(4).html("<img src='../images/edit.png' onclick='showedit($(this))'/>");
                        $("td", trL).eq(5).html("<img src='../images/Delete.png' onclick='showJobDelete($(this))'/>");

                        for (var i = 0; i < myList.length; i++) {
                            $("td", trL).eq(0).html(myList[i].sino + "<input type='hidden' id='hdnDeptBudId' name='hdnDeptBudId' value=" + myList[i].Id + ">");
                            $("td", trL).eq(1).html(myList[i].FromDate);
                            $("td", trL).eq(2).html(myList[i].ToDate);
                            $("td", trL).eq(3).html(myList[i].BudgetHours);
                            if (myList[i].ToDate == '') {

                            }
                            else {
                                $("td", trL).eq(4).html('');
                                $("td", trL).eq(5).html('');
                            }
                            $("[id*=TblDeptbudDetails]").append(trL);
                            trL = $("[id*=TblDeptbudDetails] tbody tr:last-child").clone(true);
                            TotalHrs = TotalHrs + parseFloat(myList[i].BudgetHours);
                        }


                    } else {

                        $("td", trL).eq(0).html("");
                        $("td", trL).eq(1).html("");
                        $("td", trL).eq(2).html("No record found");
                        $("td", trL).eq(3).html("");
                        $("td", trL).eq(4).html("");
                        $("td", trL).eq(5).html("");
                        $("[id*=TblDeptbudDetails]").append(trL);
                        trL = $("[id*=TblDeptbudDetails] tbody tr:last-child").clone(true);

                    }
                }
                $("#lblDeptBudhrs").text(TotalHrs);
                $("#lblDeptBuffHrs").text($("[id*=hdnBudHrs]").val() - TotalHrs);

            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }

    function showJobDelete(i) {
        var newDate = new Date();
        var DeptId = $("[id*=ddldept]").val().split(',')[0];
        var JobId = $("#ddlProject").val();
        var ip = $("[id*= hdnIP]").val();
        var usr = $("[id*= hdnName]").val();
        var uT = $("[id*= hdnUser]").val();

        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdnDeptBudId]").val();
        var BudHrs = row.find("td").eq(3).html();
        var result = confirm("Are you sure want to delete data");
        if (result) {
            $.ajax({
                type: "POST",
                url: "../Handler/Job_budgeting.asmx/Delete_Job_Budgeting_BudgetedHours",
                data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + JobId + ',DeptId:' + DeptId + ',BudDptId:' + Rtid + ',BudHrs:"' + BudHrs + '",BudHrsId:' + $("[id*=hdnBudId]").val() + ',ip:"' + ip + '",usr:"' + usr + '", ut:"' + uT + '", dt: "' + newDate + '" }',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) {
                                alert(myList[0].message);
                                if (myList[0].message == "Delete Successfully") {
                                    Get_Job_Budgeting_BudgetDetails();
                                }
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

    function showbudedit(i) {
        var row = i.closest("tr");
        var rIndex = i.closest("tr")[0].sectionRowIndex;
        var jobdtid = $("#hdnjobdetid", row).val();
        $("#dtfrdate_", row).attr("disabled", false);
        $("#dttodate_", row).attr("disabled", false);
        $("#txtbdhrs_", row).attr("disabled", false);
        $("#txtbdamt_", row).attr("disabled", false);
        $("#btneedit", row).hide();
        $("#btneupdate", row).show();
        $("#btnecancle", row).show();
    }

    function showbudUpdate(i) {
        var row = i.closest("tr");
        var jobdtid = $("#hdnjobdetid", row).val();
        var fromdt = $("#dtfrdate_", row).val();
        var todate = $("#dttodate_", row).val();
        var BudHrs = $("#txtbdhrs_", row).val();
        var BudAmt = $("#txtbdamt_", row).val();
        var Compid = $("[id*=hdncompid]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/Job_budgeting.asmx/Update_JobBudgetDetail",
            data: '{Compid:' + Compid + ',Fromdt:"' + fromdt + '",Todt:"' + todate + '",BudHrs:"' + BudHrs + '",BudAmt:"' + BudAmt + '",JobBudDtl:' + jobdtid + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList[0].Jobid > 0) {
                    alert("Record Successfully Updated");
                    $("#dtfrdate_", row).attr("disabled", true);
                    $("#dttodate_", row).attr("disabled", true);
                    $("#txtbdhrs_", row).attr("disabled", true);
                    $("#txtbdamt_", row).attr("disabled", true);
                    $("#btneedit", row).show();
                    $("#btneupdate", row).hide();
                    $("#btnecancle", row).hide();
                }
                else {
                    alert("Record Not Updated");
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

    function Showecancle(i) {
        var row = i.closest("tr");
        var rIndex = i.closest("tr")[0].sectionRowIndex;
        var jobdtid = $("#hdnjobdetid", row).val();
        var dt = '#dtfrdate_' + rIndex
        $("#dtfrdate_" + rIndex).prop("disabled", false);
        $("[id*=dttodate_]" + rIndex, row).prop("disabled", false);
        $("[id*=dtfrdate_]").prop("disabled", true);
        $("[id*=dttodate_]").prop("disabled", true);
        $("[id*=txtbdhrs_]").prop("disabled", true);
        $("[id*=txtbdamt_]").prop("disabled", true);
        $("[id*=btneedit]").show();
        $("[id*=btneupdate]").hide();
        $("[id*=btnecancle]").hide();
    }

    function showdelete(i) {
        var row = i.closest("tr");
        var jobdtid = $("#hdnjobdetid", row).val();
        var Compid = $("[id*=hdncompid]").val();
        var result = confirm("Are you sure want to delete data");
        if (result) {
            $.ajax({
                type: "POST",
                url: "../Handler/Job_budgeting.asmx/Delete_JobBudgetDetail",
                data: '{Compid:' + Compid + ',JobBudDtl:' + jobdtid + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList[0].Jobid > 0) {
                        alert("Record Deleted Successfully");
                        Get_Budgeting_Allocation_Details();
                    } else {
                        alert("Record Not Deleted");
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

    /// fill dropdown with ProjectName + Clientname
    function Get_Project_Budgeting_ProjectName_Clientname() {
        $.ajax({
            type: "POST",
            url: "../Handler/Job_budgeting.asmx/Get_Project_Budgeting_ProjectName_Clientname",
            data: '{Compid:' + $("[id*=hdncompid]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            $("[id*=ddlProject]").empty();
                            $("[id*=ddlProject]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {

                                $("[id*=ddlProject]").append("<option value=" + myList[i].Id + ">" + myList[i].Name + "</option>");

                            }
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

    ////validation for date
    function get_Date_Validation() {
        var OldDate = '';

        $("#TblDeptbudDetails > tbody  > tr").each(function () {
            var row = $(this).closest('tr');

            if (row.find("td").eq(2).html() == '') {

                OldDate = row.find("td").eq(1).html().split('/');
            }
        });

        if (OldDate == '') {
            var date = new Date();
            var Month = date.getMonth();
            Month = Month + 1;
            if (Month < 10) { Month = "0" + Month; }
            var Day = date.getDate();
            if (Day < 10) { Day = "0" + Day; }
            var Year = date.getFullYear();
            $("#txtDate").val(Year + "-" + Month + "-" + Day);
        }
        else {
            var newdate = new Date(OldDate[1] + "/" + OldDate[0] + "/" + OldDate[2]);
            var mindate = new Date();
            mindate.setDate(newdate.getDate() + 1);

            mindate = mindate.toISOString().slice(0, 10);

            $('#txtDate').attr('min', mindate);
        }
    }

    ///////validation for budgeting hours

    function ValidBudgetHours(i) {
        if (i == 2) {
            var NewBudHrs = $("#txtBudAllocHrs").val();
            var BuffHrs = parseFloat($("#lblBufHrs").text()) + parseFloat($("[id*=hdnBudHrs]").val());
            if (parseFloat(NewBudHrs) > parseFloat(BuffHrs)) {
                alert("Budgeting Hours Greater Than Buffer Hours");
                $("#txtBudAllocHrs").val('0.00');
                return false;

            }

            if ($("#txtBudAllocHrs").val() == '' || $("#txtBudAllocHrs").val() == undefined) {
                $("#txtBudAllocHrs").val('0.00');
            }
        }
        if (i == 1) {

            var NewBudHrs = $("#txtBudhrs").val();
            var BuffHrs = parseFloat($("#lblDeptBuffHrs").text()) + parseFloat($("[id*=hdnBudHrs]").val());
            if (parseFloat(NewBudHrs) > parseFloat(BuffHrs)) {
                alert("Budgeting Hours Greater Than Buffer Hours");

                return false;
            }
        }

        function ClearAll() {
            $("#lblprojectclinetname").html("");
            $("#txtfromdate").val("");
            $("#txttodate").val("");
            $("#txtbudhrss").val("");
            $("#txtbudamtt").val("");

        }
    }
</script>
<style type="text/css">
    label {
        font-weight: bold;
    }

    .RightAlignment {
        text-align: right;
    }

    .Pager b {
        margin-top: 2px;
        margin-right: 10px;
        float: left;
    }

    .Pager span {
        text-align: center;
        display: inline-block;
        width: 20px;
        margin-right: 3px;
        margin-left: 5px;
        line-height: 150%;
        border: 1px solid #BCBCBC;
    }

    .Pager a {
        text-align: center;
        display: inline-block;
        width: 20px;
        background-color: #BCBCBC;
        color: #fff;
        border: 1px solid #BCBCBC;
        margin-right: 3px;
        line-height: 150%;
        text-decoration: none;
    }
</style>
    <!-- Page header -->
    <div id="throbber" style="display: none;">
        <img src="../images/loader.gif" />
    </div>

    <div class="page-header " style="height: 50px;">
        <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
            <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">
                <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold">Job Budgeting Allocation</span></h4>
                <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
            </div>


        </div>
    </div>
    <!-- /page header -->


    <div class="content" style="padding: 5px;">
        <div id="dvGrid" class="card">
            <div class="datatable-header">
                <div id="DataTables_Table_1_filter" class="form-group row">
                    <label class="col-lg-2 col-form-label font-weight-bold">Project Name:</label>
                    <div class="col-lg-4">
                        <asp:DropDownList ID="ddlProject" runat="server" CssClass="form-control select-search" data-fouc> </asp:DropDownList>
                    <%--<select id="ddlProject" class="form-control select-search" data-fouc>
                        <option value="0">Select</option>
                    </select>--%>
                    </div> 
                    <div class="col-lg-2">
                          <input id="txtStartDate" type="date" class="form-control" placeholder="dd/MM/yyyy" />
                    </div>
                      <div class="col-lg-2">
                          <input id="txtEndDate" type="date" class="form-control" placeholder="dd/MM/yyyy" />
                    </div>
                    <div class="col-2">
                        <button type="button" id="btnaddjob" style="float: left;" data-toggle='modal' data-target='#BudModal'  class="btn btn-outline-success rounded-round "><i class="fas fa-plus mr-2 fa-1x"></i>Add Budget</button>
                    </div>
                </div>

            </div>
            <div class="table-responsive">
                <table id="tblBudgetDetails" class="table datatable-js">
                </table>
                <table id="tblPager" style="border: 1px solid #BCBCBC; height: 50px; width: 100%">
                    <tr>
                        <td>
                            <div class="Pager">
                            </div>
                        </td>
                    </tr>
                </table>
            </div>        
<%------------------------------ Hidden Table ------------------  --%>   
        <table style="float: right; width: 100%; padding: 10px; display: none;"">
            <tr>
                <td style="width: 120px;">
                    <label id="">
                       
                    </label>
                </td>
                <td style="width: 250px;" colspan="2">
                </td>
                <td style="width: 120px;">
                    <label id="Label1">
                        Department :
                    </label>
                </td>
                <td style="width: 250px;" colspan="2">
                    <select id="ddldept" class="DropDown" style="width: 250px;">
                        <option value="0">Select</option>
                    </select>
                </td>
                <td>
                    <label id="">
                    </label>
                </td>
                <td>

                </td>
            </tr>
            <tr>
                <td>
                    <label id="lblbudhr">
                        Budgeted Hrs :</label>
                </td>
                <td style="width: 25px">
                    <label id="lblBudHrs">
                        0.00</label>
                </td>
            </tr>
            <tr>
                <td>
                    <label id="lblbufhr">
                        Buffer Hrs :</label>
                </td>
                <td>
                    <label id="lblBufHrs">
                        0.00</label>
                </td>
            </tr>

        </table>               

        </div>

    <asp:HiddenField runat="server" ID="hdncompid" />
    <asp:HiddenField runat="server" ID="hdnBudId" />
    <asp:HiddenField runat="server" ID="hdnBudHrs" />
    <asp:HiddenField runat="server" ID="hdnDetailBudId" />
    <asp:HiddenField ID="hdnPages" runat="server" />
    <asp:HiddenField ID="hdnpageindex" runat="server" />
      <asp:HiddenField ID="hdnIP" runat="server" />
            <asp:HiddenField ID="hdnName" runat="server" />
            <asp:HiddenField ID="hdnUser" runat="server" />
    </div>

    <div id="BudModal" class="modal fade" tabindex="-1">
        <div class="modal-dialog  modal-xl ">
            <div class="modal-content">
                <div class="modal-header bg-primary">
                    <h3 id="h2Narrat" name="h2Narrat" class="modal-title">Budget</h3>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <div class="modal-body">
                    <div class="form-group row">
                        <asp:HiddenField ID="htNarr" runat="server"></asp:HiddenField>
                        <label class="col-lg-2 font-weight-bold col-form-label">Project</label>

                        <div class="col-md-8">
                            <label id="lblprojectclinetname" class="col-lg-8 font-weight-bold col-form-label"></label>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label id="lblNDate" class="col-lg-2 font-weight-bold col-form-label">From Date:</label>

                        <div class="col-md-3">
                            <input type="date" class="txtbox" id="txtfromdate" name="txtfromdate" />
                        </div>
                        <div class="col-lg-2">
                            <label id="lblDate" class="col-lg-10 font-weight-bold col-form-label">To Date:</label>
                        </div>
                        <div class="col-md-3">
                             <input type="date" class="txtbox" id="txttodate" name="txttodate" />
                        </div> 
                    </div>
                    <div class="form-group row">
                        <label id="lblBH" class="col-lg-2 font-weight-bold col-form-label">Budget Hrs:</label>

                        <div class="col-md-3">
                             <input type="text" class="col-lg-10" id="txtbudhrss" name="txtbudhrss" />
                        </div>
                        <div class="col-md-2">
                            <label id="lblBM" class="col-lg-10 font-weight-bold col-form-label">Budget Amt:</label>
                        </div>
                        <div class="col-md-2">
                             <input type="text" class="col-lg-10" id="txtbudamtt" name="txtbudamtt" style="text-align: right;" value="0.00">
                        </div> 
                    </div>
                    <div class="form-group-row">
                        <div class="table-responsive">
                            <table id="tbl_jobfillgrid" class="table datatable-js">
                            </table>
                        </div> 
                    </div>
   
                </div>

                <div class="modal-footer">

                    <input type="button" id="BtnSubmit" data-dismiss="modal" value="Save" class="btn btn-success" />
                    <input id="btnCancel" type="button" data-dismiss="modal" value="Cancel" class="btn btn-link legitRipple" />  
                </div>
            </div>
        </div>
    </div>
