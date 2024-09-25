<%@ Control Language="C#" AutoEventWireup="true" CodeFile="JobAllocation_Hours.ascx.cs" Inherits="controls_JobAllocation_Hours" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<script type="text/javascript" src="../jquery/moment.js"></script>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>
<link href="../jquery/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<%--<script src="../jquery/jquery.searchabledropdown-1.0.8.min.js" type="text/javascript"></script>--%>

<script type="text/javascript">
    var main_obj = [];
    var proj_obj = [];
    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        $("[id*=hdnPages]").val(1);
        
        GetClient();
        FillProject();
        $("[id*=Addimg]").val('Add');
        GetAllocateHours(1, 25);

        $("[id*=dvInvoice]").show();
        $("[id*=dvEditInvoice]").hide();
        $("[id*=editsavedv]").hide();

        $("[id*=btnAdd]").click(function () {
            $("[id*=dvInvoice]").hide();
            $("[id*=dvEditInvoice]").show();
            $("[id*=editsavedv]").show();
            reset();
        });

        $("[id*=btnSrch]").click(function () {
            GetAllocateHours(1, 25);
        });

        $("[id*=btnCancel]").click(function () {

            $("[id*=dvInvoice]").show();
            $("[id*=dvEditInvoice]").hide();
            $("[id*=editsavedv]").hide();
        });

        $("[id*=Addimg]").click(function () {
            var Jobhrs = $("[id*=txtjobhrs]").val();
            var mJobid = $("[id*=drpJob]").val();
            if (Jobhrs == '0.00' || Jobhrs == '00.00' || mJobid == '0') {
                return
            } else {
                AddTemp();
            }

        });

        $("[id*=drpclient]").change(function () {
            GetProject();
        });

        $("[id*=drpProject]").change(function () {
            //var projid = $("[id*=drpProject]").val();
            GetProjectDetail();
            GetSelectdJob();
        });

        $("[id*=drpJob]").change(function () {
            GetEditStaff(0);
            twoCalcProject();
        });

        $("[id*=btnSave]").click(function () {

            Insertrecord();

        });

    });

    function reset() {
        $("[id*=drpclient]").val(0);
        $("[id*=drpProject]").val(0);
        $("[id*=drpJob]").val(0);
        $("[id*=drpclient]").attr("disabled", false);
        $("[id*=drpProject]").attr("disabled", false);
        $("[id*=lblStartdt]").val('');
        $("[id*=lblEndt]").val('');
        $("[id*=lblStatus]").val('');
        $("[id*=txtProjHrs]").val('00.00');
        $("[id*=txtHrsAlloc]").val('00.00');
        $("[id*=txtHrsBalanc]").val('00.00');
        $("[id*=txtjobhrs]").val('00.00');
        $("[id*=hdnJobId]").val(0);
        $("[id*=hdnEdit]").val(0);
        $("[id*=chkstf]").attr("checked", false);
        $("[id*=txtStaffhrs]").val('00.00');
        //$("[id*=tblStaffname] tbody").empty();
        $("[id*=tblJobName] tbody").empty();
        $("[id*=drpstaff]").val(0);
        $("[id*=lbltothrs]").html('00.00');
    }

    ///Get Allocation Hours Grid
    function GetAllocateHours(pageindex, pagesize) {
        var Compid = $("[id*=hdnCompanyID]").val();
        var srch = $("[id*=txtInvsrch]").val();
        var drpSrch = $("[id*=drpsrch]").val();
         
        $.ajax({
            type: "POST",
            url: "../Handler/JobAllocationHours.asmx/GetAllocHrs",
            data: '{compid:' + Compid + ',srch:"' + srch + '",pageindex:' + pageindex + ',pagesize:' + pagesize + ',drpSrch:"' + drpSrch + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var tbl = "";
                $("[id*=tblGetHours] tbody").empty();

                tbl = tbl + "<tr>";
                tbl = tbl + "<th >Sr.No</th>";
                tbl = tbl + "<th class='labelChange'>Client</th>";
                tbl = tbl + "<th class='labelChange'>Project</th>";
                //tbl = tbl + "<th class='labelChange'>Project Leader</th>";
                tbl = tbl + "<th >Total Staff</th>";
                tbl = tbl + "<th >Hrs. Allocated</th>";
                tbl = tbl + "<th >Edit</th>";
                tbl = tbl + "<th >Delete</th>";
                tbl = tbl + "</tr>";

                if (myList.length > 0) {
                    for (var i = 0; i < myList.length; i++) {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td style='text-align: center;width: 50px;'>" + myList[i].sino + "<input type='hidden' id='hdnJobid' value='" + myList[i].Jobid + "' name='hdnJobid'></td>";
                        tbl = tbl + "<td >" + myList[i].Clintname + "<input type='hidden' id='hdnCltid' value='" + myList[i].cltid + "' name='hdnCltid'></td>";
                        tbl = tbl + "<td >" + myList[i].Projectname + "<input type='hidden' id='hdnProjid' value='" + myList[i].Projctid + "' name='hdnProjid'></td>";
                        //tbl = tbl + "<td >" + myList[i].LeaderName + "<input type='hidden' id='hdnPLid' value='" + myList[i].plid + "' name='hdnPLid'></td>";
                        tbl = tbl + "<td style='width: 100px;text-align: center;'>" + myList[i].Staffcount + "</td>";
                        tbl = tbl + "<td style='width: 100px;text-align: center;'>" + myList[i].Jobhrs + "</td>";
                        tbl = tbl + "<td style='text-align: center;'><img src='../images/edit.png' style='cursor:pointer; height:18px; width:18px;' onclick='Edit_AllocHrs($(this))' id='btnEdit' name='btnEdit'></td>";
                        tbl = tbl + "<td style='text-align: center;'><img src='../images/delete.png' style='cursor:pointer; height:18px; width:18px;' onclick='Delete_AllocHrs($(this))' id='btnHDel' name='btnHDel'></td>";
                        tbl = tbl + "</tr>";
                    }
                    $("[id*=tblGetHours]").append(tbl);
                    Pager(myList[0].Tcount);
                }
                else {
                    tbl = tbl + "<tr>";
                    tbl = tbl + "<td ></td>";
                    tbl = tbl + "<td > </td>";
                    tbl = tbl + "<td >No Record Found !!!</td>";
                    tbl = tbl + "<td ></td>";
                    tbl = tbl + "<td ></td>";
                    tbl = tbl + "<td ></td>";
                    tbl = tbl + "<td ></td>";
                    tbl = tbl + "</tr>";
                    $("[id*=tblGetHours]").append(tbl);
                    Pager(0);
                }

            },
            failure: function (response) {
                showErrorToast('Cant Connect to Server' + response.d);
                //alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                showErrorToast('Error Occoured' + response.d);
                //alert('Error Occoured ' + response.d);
            }
        });
    }

    ///function return for deleting the record
    function Delete_AllocHrs(i) {
        var row = i.closest("tr");
        //var mjobid = row.find("input[name=hdnmJobid]").val();
        var Jobid = row.find("input[name=hdnJobid]").val();
        var compid = $("[id*=hdnCompanyID]").val();
        var cltid = row.find("input[name=hdnCltid]").val();
        var projid = row.find("input[name=hdnProjid]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/JobAllocationHours.asmx/DeleteAllocHrs",
            data: '{compid:' + compid + ',Jobid:' + txtStaffhrs + ',cltid:' + cltid + ',projid:' + projid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList.length > 0) {
                    if (myList[0].Id == -1) {
                        // Duplicate Entry found Message
                        alert('Delete failed, TimeSheet Entry Exist against this Activity / Job');
                    }
                    else {

                        // Save Entry found Message
                        alert('Record Deleted successfully !!!');
                        GetAllocateHours(1, 25);
                    }


                }
            },
            failure: function (response) {
                showErrorToast('Cant Connect to Server' + response.d);
                //alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                showErrorToast('Error Occoured' + response.d);
                //alert('Error Occoured ' + response.d);
            }
        });
    }

    function Edit_Temp(i) {
        var row = i.closest("tr");
        var mjobid = row.find("input[name=hdntempJobid]").val();
        var tlid = row.find("input[name=hdntemptlid]").val();
        //FillProject();
        GetEditStaff(mjobid,tlid);
    }

    function Delete_Temp(i) {
        var row = i.closest("tr");
        var mjobid = row.find("input[name=hdntempJobid]").val();
        //var Jobid = $("[id*=hdnJobId]").val();
        var compid = $("[id*=hdnCompanyID]").val();
        var cltid = $("[id*=drpclient]").val();
        var Projectid = $("[id*=drpProject]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/JobAllocationHours.asmx/Temp_DeleteAllocHrs",
            data: '{compid:' + compid + ',mJobid:' + mjobid + ',cltid:' + cltid + ',Projectid:' + Projectid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList.length > 0) {
                    if (myList[0].Id == -1) {
                        // Duplicate Entry found Message
                        alert('Delete failed, TimeSheet Entry Exist against this Activity / Job');
                    }
                    else {

                        // Save Entry found Message
                        alert('Record Deleted successfully !!!');

                        GetSelectdJob();
                    }

                }
            },
            failure: function (response) {
                showErrorToast('Cant Connect to Server' + response.d);
                //alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                showErrorToast('Error Occoured' + response.d);
                //alert('Error Occoured ' + response.d);
            }
        });
    }

    ///function return for editing the record
    function Edit_AllocHrs(i) {
        var row = i.closest("tr");
        $("[id*=drpclient]").attr("disabled", true);
        $("[id*=drpProject]").attr("disabled", true);
        var Cltid = row.find("input[name=hdnCltid]").val();
        var Projid = row.find("input[name=hdnProjid]").val();
        //var PLID = row.find("input[name=hdnPLid]").val();
        var Jobid = row.find("input[name=hdnJobid]").val();
        var compid = $("[id*=hdnCompanyID]").val();
        $("[id*=hdnEdit]").val(2);
        $.ajax({
            type: "POST",
            url: "../Handler/JobAllocationHours.asmx/Get_EditAllocHrs",
            data: '{compid:' + compid + ',Jobid:' + Jobid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList.length > 0) {
                    $("[id*=dvInvoice]").hide();
                    $("[id*=dvEditInvoice]").show();
                    $("[id*=editsavedv]").show();

                    $("[id*=drpclient]").val(Cltid);
                    GetProject(Projid);
                    //$("[id*=drpstaff]").val(PLID);
                    $("[id*=drpJob]").val(0);
                    GetEditStaff();
                    GetSelectdJob();


                }
            },
            failure: function (response) {
                showErrorToast('Cant Connect to Server' + response.d);
                //alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                showErrorToast('Error Occoured' + response.d);
                //alert('Error Occoured ' + response.d);
            }
        });
    }

    function Insertrecord() {
        var Compid = $("[id*=hdnCompanyID]").val();
        //var Jobid = $("[id*=hdnJobId]").val();
        var cltid = $("[id*=drpclient]").val();
        var projectid = $("[id*=drpProject]").val();
        var editid = $("[id*=hdnEdit]").val();
        //var PLid = $("[id*=drpstaff]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/JobAllocationHours.asmx/InsertAllocHrs",
            data: '{compid:' + Compid + ',cltid:' + cltid + ',projectid:' + projectid + ',editid:' + editid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList.length > 0) {
                    if (myList[0].Id == -1) {
                        alert('Duplicate Entry Found!!!');
                    }
                    else if(myList[0].Id == -2){
                        alert('Kindly atleast add one Activity / Job!!!');
                    }
                    else {
                        if ($("[id*=hdnEdit]").val() > 0) {
                            alert('Updated Successfully !!!');
                        } else {
                            alert('Successfully Saved !!!');
                        }
                        $("[id*=dvInvoice]").show();
                        $("[id*=dvEditInvoice]").hide();
                        $("[id*=editsavedv]").hide();
                        GetAllocateHours(1, 25);
                    }
                }
            },
            failure: function (response) {
                showErrorToast('Cant Connect to Server' + response.d);
                //alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                showErrorToast('Error Occoured' + response.d);
                //alert('Error Occoured ' + response.d);
            }
        });
    }

    ///Addition of the total staff hours and also comparing with the job Hours
    function CalcuStffHours(i) {
        var row = i.closest("tr");

        if ($("#txtStaffhrs", row).val() == '' || $("#txtStaffhrs", row).val() == '0') {
            $("#txtStaffhrs", row).val('00.00');
        } else {
            var tTime = $("#txtStaffhrs", row).val();
            if (tTime == '0') {
                tTime = '00.00';
            }
            var startTime = tTime.replace(':', '.');
            var firstHH = startTime.split('.')[0];
            var firstMM = startTime.split('.')[1];
            if (firstMM == undefined) {
                firstMM = "0";
            }
            if (firstHH == undefined) {
                firstHH = "0";
            }
            if (firstHH == "") {
                firstHH = "0";
            }
            if (firstMM == "") {
                firstMM = "0";
            }

            if (firstMM >= 60) {
                var realmin = firstMM % 60;
                var hours = Math.floor(firstMM / 60);
                firstHH = parseFloat(firstHH) + parseFloat(hours);

                firstMM = realmin;
            }

            if (firstMM < 10) {
                if (parseFloat(firstMM.length) < 2) {
                    firstMM = firstMM + 0;
                }
            }

            if (firstHH < 10) {
                if (parseFloat(firstHH.length) < 2) {
                    firstHH = "0" + firstHH;
                }
            }
            tTime = firstHH + '.' + firstMM;
            $("#txtStaffhrs", row).val(tTime);
        }

        var JobHrs = $("[id*=txtjobhrs]").val();

        var tTime = '00:00';
        var FTime = '00:00';
        var totalHH = '00';
        var totalMM = '00';

        $(".clStaff:checked").each(function () {
            var staffHours = '';
            Assignrow = $(this).closest("tr");
            staffHours = $("#txtStaffhrs", Assignrow).val();
            var startTime = staffHours;

            startTime = startTime.replace('.', ':');
            var firstHH = startTime.split(':')[0];
            var firstMM = startTime.split(':')[1];
            tTime = tTime.replace('.', ':');
            var endtHH = tTime.split(':')[0];
            var endMM = tTime.split(':')[1];

            totalHH = parseFloat(firstHH) + parseFloat(endtHH);
            totalMM = parseFloat(firstMM) + parseFloat(endMM);

            if (totalMM >= 60) {
                var realmin = totalMM % 60;
                var hours = Math.floor(totalMM / 60);
                totalHH = parseFloat(totalHH) + parseFloat(hours);

                totalMM = realmin;
            }
            if (totalMM < 10) {
                if (parseFloat(totalMM.length) < 2) {
                    totalMM = totalMM + 0;
                }
            }

            if (totalHH < 10) {
                if (parseFloat(totalHH.length) < 2) {
                    totalHH = "0" + totalHH;
                }
            }
            FTime = totalHH + '.' + totalMM;

            ///Total Staff Hour
            tTime = FTime;
        });

        if (parseFloat(JobHrs) < parseFloat(tTime)) {
            alert('Staff Hours Should not be Exceeded!!!');
            $("#txtStaffhrs", row).val('00.00');
            //alert(tTime);
        }
    }

    function CalcuJob() {
        var Projecthrs = $("[id*=txtProjHrs]").val();
        var JobHhrs = $("[id*=txtjobhrs]").val();
        var hrsAlloc = $("[id*=txtHrsAlloc]").val();
        var tot = '';

        var tTime = '00.00';
        var FTime = '00.00';
        var totalHH = '00';
        var totalMM = '00';

        if (JobHhrs == '' || JobHhrs == '0') {
            $("[id*=txtjobhrs]").val('00.00');
            JobHhrs = $("[id*=txtjobhrs]").val();
        } else {

            var tTime = $("[id*=txtjobhrs]").val();
            if (tTime == '0') {
                tTime = '00.00';
            }
            var startTime = tTime.replace(':', '.');
            var firstHH = startTime.split('.')[0];
            var firstMM = startTime.split('.')[1];
            if (firstMM == undefined) {
                firstMM = "0";
            }

            if (firstHH == undefined) {
                firstHH = "0";
            }

            if (firstHH == "") {
                firstHH = "0";
            }
            if (firstMM == "") {
                firstMM = "0";
            }

            if (firstMM >= 60) {
                var realmin = firstMM % 60;
                var hours = Math.floor(firstMM / 60);
                firstHH = parseFloat(firstHH) + parseFloat(hours);

                firstMM = realmin;
            }

            if (firstMM < 10) {
                if (parseFloat(firstMM.length) < 2) {
                    firstMM = firstMM + 0;
                }
            }

            if (firstHH < 10) {
                if (parseFloat(firstHH.length) < 2) {
                    firstHH = "0" + firstHH;
                }
            }
            tTime = firstHH + '.' + firstMM;
            $("[id*=txtjobhrs]").val(tTime);
            JobHhrs = $("[id*=txtjobhrs]").val();
        }

        if ($("[id*=Addimg]").val() == 'Update') {
            startTime = $("[id*=txtHrsAlloc]").val();
        } else {
            startTime = $("[id*=hdnTotalHor]").val();
        }

        tTime = JobHhrs;
        ///Adding the records
        startTime = startTime.replace('.', ':');
        var firstHH = startTime.split(':')[0];
        var firstMM = startTime.split(':')[1];
        tTime = tTime.replace('.', ':');
        var endtHH = tTime.split(':')[0];
        var endMM = tTime.split(':')[1];

        totalHH = parseFloat(firstHH) + parseFloat(endtHH);
        totalMM = parseFloat(firstMM) + parseFloat(endMM);

        if (totalMM >= 60) {
            var realmin = totalMM % 60;
            var hours = Math.floor(totalMM / 60);
            totalHH = parseFloat(totalHH) + parseFloat(hours);

            totalMM = realmin;
        }
        if (totalMM < 10) {

            if (parseFloat(totalMM.length) < 2) {
                totalMM = totalMM + 0;
            }
        }

        if (totalHH < 10) {

            if (parseFloat(totalHH.length) < 2) {
                totalHH = "0" + totalHH;
            }
        }
        FTime = totalHH + '.' + totalMM;
        tTime = FTime;
        if (parseFloat(Projecthrs) < parseFloat(tTime)) {
            alert('The Project Hours is exceeded!!!');
            $("[id*=txtjobhrs]").val('00.00');
            return
        }
        $("[id*=txtHrsAlloc]").val(tTime);
        ///Substracting the Hour record

        //tTime = '00.00';
        startTime = $("[id*=txtProjHrs]").val();
        startTime = startTime.replace('.', ':');
        var firstHH = startTime.split(':')[0];
        var firstMM = startTime.split(':')[1];
        tTime = tTime.replace('.', ':');
        var endtHH = tTime.split(':')[0];
        var endMM = tTime.split(':')[1];

        totalHH = parseFloat(firstHH) - parseFloat(endtHH);
        totalMM = parseFloat(firstMM) - parseFloat(endMM);

        if (totalMM >= 60) {
            var realmin = totalMM % 60;
            var hours = Math.floor(totalMM / 60);
            totalHH = parseFloat(totalHH) + parseFloat(hours);

            totalMM = realmin;
        }
        if (totalMM < 10) {
            totalMM = "0" + totalMM;
        }

        if (totalHH < 10) {
            totalHH = "0" + totalHH;
        }
        FTime = totalHH + '.' + totalMM;
        tTime = FTime;

        $("[id*=txtHrsBalanc]").val(tTime);

    }

    function twoCalcProject() {
        var Projecthrs = $("[id*=txtProjHrs]").val();
        var alloctedhr = '00.00', tot = '';

        var tTime = '00.00';
        var FTime = '00.00';
        var totalHH = '00';
        var totalMM = '00';
        $('#tblJobName > tbody  > tr').each(function () {
            rw = $(this).closest("tr");
            amt = rw.find("td:eq(2)").html();

            if (amt != undefined) {

                var startTime = amt;
                if (startTime == '') {
                    startTime = '00.00';
                }
                startTime = startTime.replace('.', ':');
                var firstHH = startTime.split(':')[0];
                var firstMM = startTime.split(':')[1];
                tTime = tTime.replace('.', ':');
                var endtHH = tTime.split(':')[0];
                var endMM = tTime.split(':')[1];

                totalHH = parseFloat(firstHH) + parseFloat(endtHH);
                totalMM = parseFloat(firstMM) + parseFloat(endMM);

                if (totalMM >= 60) {
                    var realmin = totalMM % 60;
                    var hours = Math.floor(totalMM / 60);
                    totalHH = parseFloat(totalHH) + parseFloat(hours);

                    totalMM = realmin;
                }
                if (totalMM < 10) {
                    totalMM = "0" + totalMM;
                }

                if (totalHH < 10) {
                    totalHH = "0" + totalHH;
                }
                FTime = totalHH + '.' + totalMM;

                ///Total Staff Hour
                tTime = FTime;
            }
        });

        $("[id*=hdnTotalHor]").val(tTime);
        $("[id*=txtHrsAlloc]").val(tTime);

        startTime = $("[id*=txtProjHrs]").val();
        startTime = startTime.replace('.', ':');
        var firstHH = startTime.split(':')[0];
        var firstMM = startTime.split(':')[1];
        tTime = tTime.replace('.', ':');
        var endtHH = tTime.split(':')[0];
        var endMM = tTime.split(':')[1];

        totalHH = parseFloat(firstHH) - parseFloat(endtHH);
        totalMM = parseFloat(firstMM) - parseFloat(endMM);

        if (totalMM >= 60) {
            var realmin = totalMM % 60;
            var hours = Math.floor(totalMM / 60);
            totalHH = parseFloat(totalHH) + parseFloat(hours);

            totalMM = realmin;
        }
        if (totalMM < 10) {
            totalMM = "0" + totalMM;
        }

        if (totalHH < 10) {
            totalHH = "0" + totalHH;
        }
        FTime = totalHH + '.' + totalMM;
        tTime = FTime;

        $("[id*=txtHrsBalanc]").val(tTime);

    }
    function rewindtwoCalcProject() {
        var Projecthrs = $("[id*=txtProjHrs]").val();
        var alloctedhr = '00.00', tot = '';

        var tTime = '00.00';
        var FTime = '00.00';
        var totalHH = '00';
        var totalMM = '00';
        /////Substraction
        tTime = $("[id*=txtjobhrs]").val();

        startTime = $("[id*=hdnTotalHor]").val();
        startTime = startTime.replace('.', ':');
        var firstHH = startTime.split(':')[0];
        var firstMM = startTime.split(':')[1];
        tTime = tTime.replace('.', ':');
        var endtHH = tTime.split(':')[0];
        var endMM = tTime.split(':')[1];

        totalHH = parseFloat(firstHH) - parseFloat(endtHH);
        totalMM = parseFloat(firstMM) - parseFloat(endMM);

        if (totalMM >= 60) {
            var realmin = totalMM % 60;
            var hours = Math.floor(totalMM / 60);
            totalHH = parseFloat(totalHH) + parseFloat(hours);

            totalMM = realmin;
        }
        if (totalMM < 10) {
            totalMM = "0" + totalMM;
        }

        if (totalHH < 10) {
            totalHH = "0" + totalHH;
        }
        FTime = totalHH + '.' + totalMM;
        tTime = FTime;

        //$("[id*=hdnTotalHor]").val(tTime);
        $("[id*=txtHrsAlloc]").val(tTime);

        ///Addition
        tTime = $("[id*=txtHrsAlloc]").val();
        startTime = $("[id*=txtProjHrs]").val();
        startTime = startTime.replace('.', ':');
        var firstHH = startTime.split(':')[0];
        var firstMM = startTime.split(':')[1];
        tTime = tTime.replace('.', ':');
        var endtHH = tTime.split(':')[0];
        var endMM = tTime.split(':')[1];

        totalHH = parseFloat(firstHH) - parseFloat(endtHH);
        totalMM = parseFloat(firstMM) - parseFloat(endMM);

        if (totalMM >= 60) {
            var realmin = totalMM % 60;
            var hours = Math.floor(totalMM / 60);
            totalHH = parseFloat(totalHH) + parseFloat(hours);

            totalMM = realmin;
        }
        if (totalMM < 10) {
            totalMM = "0" + totalMM;
        }

        if (totalHH < 10) {
            totalHH = "0" + totalHH;
        }
        FTime = totalHH + '.' + totalMM;
        tTime = FTime;

        $("[id*=txtHrsBalanc]").val(tTime);
    }

    ///Adding the Temp Record
    function AddTemp() {
        var Compid = $("[id*=hdnCompanyID]").val();
        //var Jobid = $("[id*=hdnJobId]").val();
        var cltid = $("[id*=drpclient]").val();
        var Projectid = $("[id*=drpProject]").val();
        var mjobid = $("[id*=drpJob]").val();
        var JobHours = $("[id*=txtjobhrs]").val();
        var TLid = $("[id*=drpstaff]").val();
             
        if (JobHours == '') {
            alert("Kindly put the Activity / Job Hours");
            return;
        }

        var stf = '';
        //loop on the stff table
        $(".clStaff:checked").each(function () {
            var staffHours = '';
            Assignrow = $(this).closest("tr");
            staffHours = $("#txtStaffhrs", Assignrow).val();
            stf += $(this).val() + ',' + staffHours + '^';
        });

        if (stf == '') {
            alert('Atleast select one Staff Record !!!');
            return;
        }

        $.ajax({
            type: "POST",
            url: "../Handler/JobAllocationHours.asmx/TempAdd",
            data: '{compid:' + Compid + ',cltid:' + cltid + ',Projectid:' + Projectid + ',mJobid:' + mjobid + ',JobHours:"' + JobHours + '",stf:"' + stf + '",TLid:' + TLid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList.length > 0) {
                    alert('Save Staff against Activity / Job Successfully!!!');
                    GetSelectdJob(0);
                    $("[id*=txtjobhrs]").val('00.00');
                    $("[id*=drpJob]").val(0);
                    GetEditStaff(0);
                }
            },
            failure: function (response) {
                showErrorToast('Cant Connect to Server' + response.d);
                //alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                showErrorToast('Error Occoured' + response.d);
                //alert('Error Occoured ' + response.d);
            }
        });
    }

    ///Get StaffName against the Project

    function GetEditStaff(editmjobid,tlid) {
        var Compid = $("[id*=hdnCompanyID]").val();
        var cltid = $("[id*=drpclient]").val();
        var Projectid = $("[id*=drpProject]").val();
        var mjobid = $("[id*=drpJob]").val();
        if (editmjobid > 0) {
            mjobid = editmjobid;
            $("[id*=drpJob]").val(mjobid);
            $("[id*=drpstaff]").val(tlid);
        }

        $.ajax({
            type: "POST",
            url: "../Handler/JobAllocationHours.asmx/BindStaff",
            data: '{compid:' + Compid + ',cltid:' + cltid + ',Projectid:' + Projectid + ',mJobid:' + mjobid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                $("[id*=chkstf]").attr("checked", false);
                $("[id*=txtStaffhrs]").val('00.00');
                $("[id*=lbltothrs]").html('00.00');
                $("[id*=txtjobhrs]").val('00.00');
                
                $("[id*=Addimg]").val('Add');
                $("[id*=Addimg]").hide();
                document.getElementById("txtjobhrs").disabled = false;
                $("[id*=txtStaffhrs]").attr("disabled", false);
                $("[id*=drpstaff]").attr("disabled", false);
                //document.getElementById("txtStaffhrs").disabled = false;
                if (myList.length > 0) {

                    for (var i = 0; i < myList.length; i++) {
                        var srf = myList[i].Id;

                        $('#tblStaffname > tbody  > tr').each(function () {
                            rw = $(this).closest("tr");
                            stfcode = $("#chkstf", rw).val();
                            if (parseInt(stfcode) == parseInt(srf)) {
                                $("#chkstf", rw).attr("checked", true);
                                $("#txtStaffhrs", rw).val(myList[i].Name);
                                if (myList[i].Rolenames == '') {
                                    $("#lbltothrs", rw).html('00.00');
                                } else {
                                    $("#lbltothrs", rw).html(myList[i].Rolenames);
                                }
                               
                            }
                        });


                    }
                    $("[id*=txtjobhrs]").val(myList[0].Type);
                    $("[id*=drpstaff]").val(myList[0].Role_Id);
                    $("[id*=Addimg]").val('Add');
                    $("[id*=Addimg]").hide();
                    document.getElementById("txtjobhrs").disabled = true;
                    $("[id*=drpstaff]").attr("disabled", true);
                    $("[id*=txtStaffhrs]").attr("disabled", true);

                    if (editmjobid > 0) {
                        rewindtwoCalcProject();
                        $("[id*=Addimg]").show();
                        //document.getElementById("Addimg").disabled = false;
                        $("[id*=Addimg]").val('Update');
                        document.getElementById("txtjobhrs").disabled = false;
                        $("[id*=drpstaff]").attr("disabled", false);
                        //$("[id*=txtStaffhrs]").disabled = false;
                        $("[id*=txtStaffhrs]").attr("disabled", false);
                    }
                } else {
                    $("[id*=Addimg]").val('Add');
                    $("[id*=Addimg]").show();
                    document.getElementById("txtjobhrs").disabled = false;
                    $("[id*=drpstaff]").val(0);
                    //$("[id*=txtStaffhrs]").disabled = false;
                    $("[id*=txtStaffhrs]").attr("disabled", false);
                }
            },
            failure: function (response) {
                showErrorToast('Cant Connect to Server' + response.d);
                //alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                showErrorToast('Error Occoured' + response.d);
                //alert('Error Occoured ' + response.d);
            }
        });
    }

    function GetStaff(mjobidd) {

        if (mjobidd > 0) {
            mJobid = mjobidd;
        }
        //    url: "../Handler/JobAllocationHours.asmx/BindStaff",

        var obj = main_obj.list_Alloc_Staffname;

        if (obj.length > 0) {

            var tableRowsProj = '';
            var countProj = obj.length;

            for (var i = 0; i < obj.length; i++) {
                tableRowsProj = tableRowsProj + "<tr>";
             
                tableRowsProj = tableRowsProj + "<td ><input type='checkbox' id='chkstf' name='chkstf' class='cl" + obj[i].Type + "' value='" + obj[i].Staffcode + "' /></td>";
           
                tableRowsProj = tableRowsProj + "<td style='width:400px;'>" + obj[i].Staffname + "</td>";
                tableRowsProj = tableRowsProj + "<td><label  id='lbltothrs' name='lbltothrs' style='width:60px;text-align:center;' /></label></td>";
                tableRowsProj = tableRowsProj + "<td><input type='text' id='txtStaffhrs' name='txtStaffhrs' class='texboxcls' onkeypress='return isNumber(event)' onChange='CalcuStffHours($(this))' style='width:60px;text-align:center;' value='00.00' /></td></tr>";
              

            };
            //$("[id*=txtjobhrs]").val(obj[0].StaffNames);
            $("[id*=lblStaffcount]").parent().find('label').text("Staff Name (" + countProj + ")");
            $("[id*=Panel2]").html("<table id='tblStaffname'>" + tableRowsProj + "</table>");

            $(".modalganesh").hide();

        }
    }

    ///Project Detils with job
    function GetProjectDetail() {
        if ($("[id*=hdnEdit]").val() > 0) {
            //$("[id*=drpProject]").val(drpro);
            GetSelectdJob();
        }
        var P = $("[id*=drpProject]").val();

        //    url: "../Handler/JobAllocationHours.asmx/BindProjectDetail",

        $.each(main_obj.list_Alloc_Project, function (i, va) {
            if (va.Projid == P) {
                $("[id*=lblStartdt]").val(va.Startdate);
                $("[id*=lblEndt]").val(va.enddate);
                if (va.JobStatus == '') {
                    $("[id*=lblStatus]").val('OnGoing');
                } else {
                    $("[id*=lblStatus]").val(va.JobStatus);
                }

                var Projhrs = va.ProjectHrs;
                if (Projhrs == '0.00') {
                    $("[id*=txtProjHrs]").val('00.00');
                    $("[id*=txtHrsBalanc]").val('00.00');
                    alert('Project Hours is not available!!!');
                    $("[id*=drpJob]").disabled = true;
                    document.getElementById("txtjobhrs").disabled = true;

                    //document.getElementById("drpJob").disabled = true;
                } else {
                    $("[id*=txtProjHrs]").val(Projhrs);
                    $("[id*=txtHrsBalanc]").val(Projhrs);
                    $("[id*=drpJob]").disabled = false;
                    $("[id*=txtjobhrs]").disabled = false;
                    document.getElementById("txtjobhrs").disabled = false;
                }
                $("[id*=txtHrsAlloc]").val('00.00');
                $("[id*=txtjobhrs]").val('00.00');
                $("[id*=hdnTotalHor]").val('00.00');

            }
        });
    }

    function GetSelectdJob() {
        var Compid = $("[id*=hdnCompanyID]").val();
        //var Jobid = $("[id*=hdnJobId]").val();
        var cltid = $("[id*=drpclient]").val();
        var Projectid = $("[id*=drpProject]").val();
        //if (mjobid > 0) {
        //    GetStaff(mjobid);
        //}
        $.ajax({
            type: "POST",
            url: "../Handler/JobAllocationHours.asmx/BindJobname",
            data: '{compid:' + Compid + ',cltid:' + cltid + ',Projectid:' + Projectid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: OnSuccess,

            failure: function (response) {
                showErrorToast('Cant Connect to Server' + response.d);
                //alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                showErrorToast('Error Occoured' + response.d);
                //alert('Error Occoured ' + response.d);
            }
        });
    }

    function OnSuccess(response) {
        var myList = jQuery.parseJSON(response.d);
        var tbl = '';

        $("[id*=tblJobName] tbody").empty();

        tbl = tbl + "<tr>";
        tbl = tbl + "<th class='labelChange'>JobName</th>";
        tbl = tbl + "<th class='labelChange'>Task Leader</th>";
        tbl = tbl + "<th class='labelChange'>Hours</th>";
        tbl = tbl + "<th >Edit</th>";
        tbl = tbl + "<th >Delete</th>";
        tbl = tbl + "</tr>";

        if (myList.length > 0) {

            for (var i = 0; i < myList.length; i++) {
                tbl = tbl + "<tr>";
                tbl = tbl + "<td >" + myList[i].MJobName + "<input type='hidden' id='hdntempJobid' value='" + myList[i].mJobID + "' name='hdntempJobid'></td>";
                tbl = tbl + "<td >" + myList[i].Assign_Name + "<input type='hidden' id='hdntemptlid' value='" + myList[i].Assign_Id + "' name='hdntemptlid'></td>";
                tbl = tbl + "<td style='text-align: center;'>" + myList[i].DepartmentName + "</td>";
                tbl = tbl + "<td style='text-align: center;'><img src='../images/edit.png' style='cursor:pointer; height:18px; width:18px;' onclick='Edit_Temp($(this))' id='btnHEdit' name='btnHEdit'></td>";
                tbl = tbl + "<td style='text-align: center;'><img src='../images/delete.png' style='cursor:pointer; height:18px; width:18px;' onclick='Delete_Temp($(this))' id='btnHDel' name='btnHDel'></td></tr>";
            };
            $("[id*=tblJobName]").append(tbl);
            twoCalcProject();
        }
        else {
            tbl = tbl + "<tr>";

            tbl = tbl + "<td >No Record Found !!!</td>";
            tbl = tbl + "<td ></td>";
            tbl = tbl + "<td ></td>";
            tbl = tbl + "<td ></td>";
            tbl = tbl + "</tr>";
            $("[id*=tblJobName]").append(tbl);
            twoCalcProject();
        }

    }

    function Pager(RecordCount) {
        $(".Pager").ASPSnippets_Pager({
            ActiveCssClass: "current",
            PagerCssClass: "pager",
            PageIndex: parseInt($("[id*=hdnPages]").val()),
            PageSize: parseInt(25),
            RecordCount: parseInt(RecordCount)
        });

        ////pagging changed bind LeaveMater with new page index
        $(".Pager .page").on("click", function () {
            $("[id*=hdnPages]").val($(this).attr('page'));

            GetAllocateHours(($(this).attr('page')), 25)
        });
    }

    function FillProject() {
        var Compid = $("[id*=hdnCompanyID]").val();
        var Editid = $("[id*=hdnEdit]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/JobAllocationHours.asmx/BindProject",
            data: '{compid:' + Compid + ',Editid:' + Editid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                //var myList = jQuery.parseJSON(msg.d);
                proj_obj = jQuery.parseJSON(msg.d);


            },
            failure: function (response) {
                //showErrorToast('Cant Connect to Server' + response.d);
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                //showErrorToast('Error Occoured' + response.d);
                alert('Error Occoured ' + response.d);
            }
        });
    }

    ///Get Clint 
    function GetClient() {
        var Compid = $("[id*=hdnCompanyID]").val();

        $.ajax({
            type: "POST",
            url: "../Handler/JobAllocationHours.asmx/BindClient",
            data: '{compid:' + Compid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                //var myList = jQuery.parseJSON(msg.d);
                main_obj = jQuery.parseJSON(msg.d);
                main_obj = main_obj[0];
                var myList = main_obj.list_Alloc_Client;
                //$("[id*=drpclient]").selectize()[0].selectize.destroy();
                $("[id*=drpclient]").empty();
                $("[id*=drpclient]").append("<option value=0>--Select--</option>");

                for (var i = 0; i < main_obj.list_Alloc_Client.length; i++) {

                    $("[id*=drpclient]").append("<option value='" + myList[i].cltid + "'>" + myList[i].ClientName + "</option>");
                }

                ///fill Jobname drop down
                var mylistclient = main_obj.list_Alloc_Jobname;
                $("[id*=drpJob]").empty();
                $("[id*=drpJob]").append("<option value=0>--Select--</option>");

                for (var i = 0; i < main_obj.list_Alloc_Jobname.length; i++) {

                    $("[id*=drpJob]").append("<option value='" + mylistclient[i].mJobid + "'>" + mylistclient[i].mJobname + "</option>");
                }
                /////////////////////////fill project leader name
                var Lstaff = main_obj.list_Alloc_Staffname;
                $("[id*=drpstaff]").empty();
                $("[id*=drpstaff]").append("<option value=0>--Select--</option>");

                for (var i = 0; i < Lstaff.length; i++) {

                    $("[id*=drpstaff]").append("<option value='" + Lstaff[i].Staffcode + "'>" + Lstaff[i].Staffname + "</option>");
                }
                GetStaff();

            },
            failure: function (response) {
                //showErrorToast('Cant Connect to Server' + response.d);
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                //showErrorToast('Error Occoured' + response.d);
                alert('Error Occoured ' + response.d);
            }
        });
    }

    //Get Project
    function GetProject(drpro) {
        var C = $("[id*=drpclient]").val();

        //    url: "../Handler/JobAllocationHours.asmx/BindProject",
        var myList='';
        var distProjects = [];
        if ($("[id*=hdnEdit]").val() == '0') {
            myList = proj_obj;
        } else {
            myList = main_obj.list_Alloc_Project;
        }


        $.each(myList, function (i, va) {
            if (va.cltid == C) {
                var indexxx = distProjects.map(function (d) { return d['id']; }).indexOf(va.Projid);

                if (indexxx == -1)
                    if (va.JobStatus == 'Completed') {
                        if (drpro > 0) {
                            distProjects.push({ 'id': va.Projid, 'Name': va.Projectname });
                        }

                    } else {
                        distProjects.push({ 'id': va.Projid, 'Name': va.Projectname });
                    }

            }
        });

        $("[id*=drpProject]").empty();
        $("[id*=drpProject]").append("<option value=0>--Select--</option>");


        //////////////add projects to dropdown
        $.each(distProjects, function (i, va) {
            // $("#ddlProject").append('<option value="' + va.id + '">' + va.Name + '</option>');
            $("[id*=drpProject]").append('<option value="' + va.id + '">' + va.Name + '</option>');
        });

        if ($("[id*=hdnEdit]").val() > 0) {
            $("[id*=drpProject]").val(drpro);
            GetProjectDetail();
        }

    }

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


    //function MakeSmartSearch() {
    //    $("select").searchable({
    //        maxListSize: 200, // if list size are less than maxListSize, show them all
    //        maxMultiMatch: 300, // how many matching entries should be displayed
    //        exactMatch: false, // Exact matching on search
    //        wildcards: true, // Support for wildcard characters (*, ?)
    //        ignoreCase: true, // Ignore case sensitivity
    //        latency: 200, // how many millis to wait until starting search
    //        warnMultiMatch: 'top {0} matches ...',
    //        warnNoMatch: 'no matches ...',
    //        zIndex: 'auto'
    //    });
    //}

</script>

<style type="text/css">
    .cssButton {
        cursor: pointer; /*background-image: url(../Images/ButtonBG1.png);*/
        background-color: #d3d3d3;
        border: 0px;
        padding: 4px 15px 4px 15px;
        color: Black;
        border: 1px solid #c4c5c6;
        border-radius: 3px;
        font: bold 12px verdana, arial, "Trebuchet MS", sans-serif;
        text-decoration: none;
        opacity: 0.8;
    }

        .cssButton:focus {
            background-color: #69b506;
            border: 1px solid #3f6b03;
            color: White;
            opacity: 0.8;
        }

        .cssButton:hover {
            background-color: #69b506;
            border: 1px solid #3f6b03;
            color: White;
            opacity: 0.8;
        }

    .cssPageTitle2 {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        /*border-bottom: 2px solid #0b9322;*/
        padding: 7px;
        color: #0b9322;
    }

    .cssPageTitle {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        border-bottom: 2px solid #0b9322;
        color: #0b9322;
    }

    .allTimeSheettle tr:hover {
        cursor: inherit;
        background: #F2F2F2;
        border: 1px solid #ccc;
        padding: 5px;
        color: #474747;
    }

    .allTimeSheettle {
        cursor: pointer;
    }

    .Pager b {
        margin-top: 2px;
        float: left;
    }

    .Pager span {
        text-align: center;
        display: inline-block;
        width: 20px;
        margin-right: 3px;
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

<div class="divstyle" style="height: auto; padding-bottom: 20px;">

    <table style="width: 100%" class="cssPageTitle">
        <tr>
            <td class="cssPageTitle2">
                <asp:Label ID="Label4" runat="server" Style="margin-left: 10px;" Text="Timesheet Job Allocation - Hours"></asp:Label>
            </td>
            <td style="text-align: end;">
                <div id="editsavedv">
                    <input id="btnSave" type="button" class="cssButton labelChange" value="Save" />
                    <input id="btnCancel" type="button" class="cssButton labelChange" value="Cancel" />
                </div>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hdnCompanyID" runat="server" />
    <asp:HiddenField ID="hdnJobId" runat="server" Value="0" />
    <asp:HiddenField ID="hdnEdit" runat="server" Value="0" />
    <asp:HiddenField ID="hdnTotalHor" runat="server" Value="00.00" />
    <asp:HiddenField ID="hdnPages" runat="server" />
</div>

<div id="dvInvoice">
    <div style="float: right; width: 100%; padding-bottom: 10px;">

        <div style="float: left; padding-left: 1px">
            <div id="searchbr" runat="server" style="float: left; width: 100%; margin: 10px; padding-bottom: 5px;">
                <div style="float: left;">
                    <table>
                        <tr>
                            <td style="padding-right: 20px;">
                                <label style="font-weight: bold" class="LabelFontStyle labelChange">Search</label>

                            </td>
                            <td>
                                <select id="drpsrch" name="drpsrch" runat="server" class="DropDown" style="width: 80px; height: 25px;">
                                    <option value="P">Project</option>
                                    <option value="C">Client</option>
                                </select>
                            </td>
                            <td style="padding-right: 20px;">
                                <input type="text" id="txtInvsrch" name="txtInvsrch" class="texboxcls" style="width: 250px;" />
                            </td>
                            <td style="padding-right: 20px;">
                                <input id="btnSrch" type="button" class="cssButton labelChange" value="Search" />
                            </td>
                            <td>
                                <input id="btnAdd" type="button" class="cssButton labelChange" value="Add Activity Hours Allocation" />
                            </td>

                        </tr>
                    </table>
                </div>
            </div>
        </div>

    </div>
    <div>
        <table id="tblGetHours" width="1175px" border="1px" class="norecordTble allTimeSheettle" style="border-collapse: collapse; padding-left: 120px;"></table>
        <table id="tblPager" style="border: 1px solid #BCBCBC; border-bottom: none; background-color: rgba(219,219,219,0.54); text-align: right; width: 1175px;"
            cellpadding="2" cellspacing="0" width="1100px">
            <tr>
                <td>
                    <div class="Pager">
                    </div>
                </td>
            </tr>
        </table>
    </div>
</div>

<div id="dvEditInvoice">
    <table>
        <tr>
            <td style="width: 50px;"></td>
            <td style="width: 25px" align="left">
                <asp:Label ID="Label7" Text="Client" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
            <td style="width: 60px;"></td>
            <td>
                <select id="drpclient" name="drpclient" runat="server" class="DropDown" style="width: 230px; height: 25px;">
                    <option value="0">--Select--</option>
                </select></td>
            <td style="width: 50px;"></td>
            <td style="font-weight: bold;" class="labelChange">Project</td>
            <td style="width: 85px;"></td>
            <td>
                <select id="drpProject" name="drpProject" runat="server" class="DropDown" style="width: 230px; height: 25px; z-index: -1;">
                    <option value="0">--Select--</option>
                </select>
            </td>
                        <td style="width: 50px;"></td>
      
        </tr>
        <tr>
            <td colspan="4"></td>
        </tr>
    </table>
    <table>
        <tr>
            <td style="width: 50px;"></td>
            <td style="width: 100px;">
                <asp:Label ID="Label2" Text="Start Date:" runat="server" Font-Bold="True" CssClass="labelChange" /></td>

            <td style="width:235px;">
                <input type="text" id="lblStartdt" name="lblStartdt" style="width: 100px; text-align: center;" class="texboxcls" disabled />
                <%--<asp:Label ID="lblStartdt" Text="" runat="server" CssClass="labelChange" /></td>--%>
            <td style="width: 50px;"></td>


            <td style="width: 137px;">
                <asp:Label ID="Label3" Text="End Date:" runat="server" Font-Bold="True" CssClass="labelChange" /></td>

            <td style="width:230px;">
                <input type="text" id="lblEndt" name="lblEndt" style="width: 100px; text-align: center;" class="texboxcls" disabled />
                <%--<asp:Label ID="lblEndt" Text="" runat="server" CssClass="labelChange" /></td>--%>
          

            <td style="width: 110px;">
                <asp:Label ID="Label8" Text="Project Status:" runat="server" Font-Bold="True" CssClass="labelChange" /></td>

            <td>
                <input type="text" id="lblStatus" name="lblStatus" style="width: 100px; text-align: center;" class="texboxcls" disabled />
                <%--<asp:Label ID="lblStatus" Text="" runat="server" CssClass="labelChange" /></td>--%>
            <td style="width: 50px;"></td>
        </tr>


        <tr>
            <td colspan="4"></td>
        </tr>

    </table>
    <table>
        <tr>
            <td style="width: 50px;"></td>
            <td style="width: 100px;">
                <asp:Label ID="Label6" Text="Project Hrs:" runat="server" Font-Bold="True" CssClass="labelChange" /></td>

            <td style="width:235px;">
                <input type="text" id="txtProjHrs" name="txtProjHrs" style="width: 100px; text-align: center;" class="texboxcls" disabled /></td>


            <td style="width: 50px;"></td>
            <td style="width: 137px;">
                <asp:Label ID="Label9" Text="Hrs Allocated:" runat="server" Font-Bold="True" CssClass="labelChange" /></td>

            <td style="width:230px;">
                <input type="text" id="txtHrsAlloc" name="txtHrsAlloc" style="width: 100px; text-align: center;" class="texboxcls" value="00.00" disabled /></td>
           


            <td style="width: 110px;">
                <asp:Label ID="Label11" Text="Hrs Balance:" runat="server" Font-Bold="True" CssClass="labelChange" /></td>

            <td>
                <input type="text" id="txtHrsBalanc" name="txtHrsBalanc" style="width: 100px; text-align: center;" class="texboxcls" value="00.00" disabled /></td>

        </tr>


        <tr>
            <td colspan="4" style="height: 15px;"></td>
        </tr>

    </table>
    <table>
        <tr>
            <td style="width: 50px;"></td>
            <td style="width:100px;">
                <asp:Label ID="Label5" Text="Activity / Job" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
            <%--<td style="width: 50px;"></td>--%>
            <td>
                <select id="drpJob" name="drpJob" runat="server" class="DropDown" style="width: 230px; height: 25px;">
                    <option value="0">--Select--</option>
                </select></td>
            <td style="width: 50px;"></td>
            <td>
                <asp:Label ID="Label1" Text="Activity / Job Hours:" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
            <td>
                <input type="text" id="txtjobhrs" name="txtjobhrs" onkeypress="return isNumber(event)" onchange="CalcuJob()" style="width: 100px; text-align: center;" class="texboxcls" value="00.00" /></td>
            <td style="width: 30px;"></td>
           
                  <td style="font-weight: bold;" class="labelChange">Task Leader</td>
            <%--<td style="width: 50px;"></td>--%>
            <td>
                <select id="drpstaff" name="drpstaff" runat="server" class="DropDown" style="width: 230px; height: 25px; z-index: -1;">
                    <option value="0">--Select--</option>
                </select>
            </td>
             <td style="width: 108px;">
                <input id="Addimg" name="Addimg" type="button" class="cssButton" style="height: 30px;"></td>
        </tr>
        <tr>
            <td colspan="4" style="height: 15px;"></td>
        </tr>
    </table>
    <table style="padding-left: 55px;">
        <tr style="padding-top: 20px">
            <td style="width: 550px;">
                <label id="lblStaffcount" style="display: inline-block; color: Black; font-weight: bold; height: 20px;" class="labelChange">Staff Name</label>
                <%--<label style="display: inline-block; color: Black; font-weight: bold; height: 20px;">Hours</label>--%>
                <div id="Panel2" style="border: 1px solid #B6D1FB; width: 85%; height: 450px; overflow: auto;">
                </div>
            </td>
            <td style="width: 550px;">
                <label id="lbl" style="display: inline-block; color: Black; font-weight: bold; height: 20px;" class="labelChange">Selected Activity / Job</label>
                <div id="Panel3" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                    <table id="tblJobName" name="tblJobName" class="norecordTble allTimeSheettle" style="border-collapse: collapse; padding-left: 120px;"></table>
                </div>
            </td>
        </tr>
    </table>


</div>
