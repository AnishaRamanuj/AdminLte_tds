<%@ Control Language="C#" AutoEventWireup="true" CodeFile="StaffwiseBillableNonBillableReport.ascx.cs" Inherits="controls_All_Staff_Client_Project_Summerise" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
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
<script type="text/javascript" src="../js/PDFMaker/html2pdf.bundle.js"></script>
<script type="text/javascript" src="../js/PDFMaker/html2pdf.bundle.min.js"></script>
 <script type="text/javascript" src="../js/table2excel.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $('.sidebar-main-toggle').click();
        /// $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        $("[id*= txtfrom]").val($("[id*= hdnFrom]").val());
        $("[id*= txtto]").val($("[id*= hdnTo]").val());
        $("[id*=hCompanyname]").html($("[id*=hdnCompname]").val());

        $("[id*= txtfrom]").on('change', function () {
            $("[id*= hdnFrom]").val($("[id*= txtfrom]").val());
            Onpagefilterloads();
        });

        $("[id*= txtto]").on('change', function () {
            $("[id*= hdnTo]").val($("[id*= txtto]").val());
            Onpagefilterloads();
        });

        $("[id*=btnBack]").click(function () {
            $("[id*=dvInvoice]").show();
            $("[id*=dvReport]").hide();
            $("[id*=btngen]").show();
        });

        Get_All_Staff_Client_Project_BranchName();
        $("[id*=chkTStatusAll]").on("click", function () {
            if ($(this).attr('checked')) {
                $("[id*=chkSubmitted]").attr('checked', 'checked');
                $("[id*=chkSaved]").attr('checked', 'checked');
                $("[id*=chkApproved]").attr('checked', 'checked');
                $("[id*=chkRejected]").attr('checked', 'checked');
            }
            else {
                $("[id*=chkSubmitted]").removeAttr('checked');
                $("[id*=chkSaved]").removeAttr('checked');
                $("[id*=chkApproved]").removeAttr('checked');
                $("[id*=chkRejected]").removeAttr('checked');
            }
            TStatusCheck();
        });

        Get_All_Staff_Client_Project_BranchName();
        $("[id*=ddlType]").on("change", function () {
            Onpagefilterloads();
        });

        Onpagefilterloads();
        ///////barnch change staff selected
        $("[id*=ddlBranch]").on('change', function () {
            Onpagefilterloads();
            var ddl = document.getElementById("<%=ddlBranch.ClientID%>");
            $("[id*=hdnbranch]").val(ddl.options[ddl.selectedIndex].text);
            $("[id*=hdnBrId]").val($("[id*=ddlBranch]").val());
        });

        $("[id*=btngen]").on("click", function () {
            var selectstaff = '';
            $(".clstaff:checked").each(function () {
                selectstaff += $(this).val() + ',';
            });
            $("[id*=hdnstaffcode]").val(selectstaff);
            GetAllSelected();


            if (selectstaff == '') {
                showWarningAlert('Kindly Select atleast one Staff !!!');
                return;
            } else {
                $("[id*=dvInvoice]").hide();
                $("[id*=dvReport]").show();
                $("[id*=btngen]").hide();
                GetGrid();
            }

        });

        $("[id*=chkproject]").on("click", function () {

            var chkprop = $(this).is(':checked');

            $(".clProject").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            });
            singleprojectcheck();

        });

        $("[id*=chkjob]").on("click", function () {

            var chkprop = $(this).is(':checked');

            $(".clJob").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            });


        });

        $("[id*=chkstaff]").on("click", function () {

            var chkprop = $(this).is(':checked');

            $(".clstaff").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            });


            singlestaffcheck();

        });
    });
    /////////////////////

    function test() {
        Blockloadershow();
        // Get the element.

        var Billablename = 'Non-Billable';
        var billtype = $("[id*=ddlType]").val();
        var TypeReport = $("[id*=rdetailed]").is(':checked');
        if (billtype == 1) {
            Billablename = 'Billable';
        }

        var Projecttype = '';
        if (TypeReport == true) {
            Projecttype = 'Report_Staffwise ' + Billablename + ' Details Report';
        }
        else {
            Projecttype = 'Report_Staffwise ' + Billablename + ' Summary Report';
        }


        var element = document.getElementById('divReportGrid');

        // Generate the PDF.
        html2pdf().from(element).set({
            filename: '' + Projecttype + '.pdf',
            html2canvas: { scale: 2 },
            jsPDF: { orientation: 'landscape', unit: 'in', format: 'letter', compressPDF: false }
        }).save();
        Blockloaderhide();
    }

    function ExcelExport() {
        var Billablename = 'Non-Billable';
        var billtype = $("[id*=ddlType]").val();
        var TypeReport = $("[id*=rdetailed]").is(':checked');
        if (billtype == 1) {
            Billablename = 'Billable';
        }

        var Projecttype = '';
        if (TypeReport == true) {
            Projecttype = 'Report_Staffwise ' + Billablename + ' Details Report';
        }
        else {
            Projecttype = 'Report_Staffwise ' + Billablename + ' Summary Report';
        }


        $("#divReportGrid").table2excel({
            filename: "" + Projecttype + ".xls"
        });
    }

    function GetGrid() {
        Blockloadershow();
        //var Compid = $("[id*=hdnCompid]").val();
        var frmdt = $("[id*=txtfrom]").val();
        var Todt = $("[id*=txtto]").val();
        var TStatus = $("[id*=hdnTStatusCheck]").val();
        var billtype = $("[id*=ddlType]").val();
        var brnch = $("[id*=ddlBranch]").val();
        var Staffids = $("[id*=hdnselectedstaff]").val();
        var projectids = $("[id*=hdnselectedprojectid]").val();
        var Jobids = $("[id*=hdnselectedmjobid]").val();
        var TypeReport = $("[id*=rdetailed]").is(':checked');

        $.ajax({
            type: "POST",
            url: "../Services/BudgetReporting.asmx/GetBillNonBillStaffwiseReport",
            data: '{frmdt:"' + frmdt + '",Todt:"' + Todt + '",TStatus:"' + TStatus + '",billtype:"' + billtype + '",brnch:"' + brnch + '",Staffids:"' + Staffids + '",projectids:"' + projectids + '",Jobids:"' + Jobids + '",TypeReport:"' + TypeReport + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var tbl = '', PName = '', actt = '';

                $("[id*=divdtrange]").html('From ' + moment(frmdt).format('DD/MM/YYYY') + ' ' + 'To ' + moment(Todt).format('DD/MM/YYYY'));

                $("[id*=tblReport] tbody").empty();
                $("[id*=tblReport] thead").empty();

                tbl = tbl + "<thead><tr>";
                tbl = tbl + "<th style='font-weight: bold;'>Project</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Activity</th>";
                if (TypeReport == true) {
                    tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Date</th>";
                }
                tbl = tbl + "<th style='font-weight: bold;'>Hours</th>";
                tbl = tbl + "<th style='font-weight: bold;'>Charges</th>";
                tbl = tbl + "<th style='font-weight: bold;'>Expense</th>";
                tbl = tbl + "<th style='font-weight: bold;'>Charges + Exp</th>";
                tbl = tbl + "</tr></thead>";

                if (myList.length > 0) {
                    for (var i = 0; i < myList.length; i++) {
                        tbl = tbl + "<tr>";
                        if (myList[i].Staffname != '') {
                            tbl = tbl + "<td style='font-weight: bold;'>Staff : " + myList[i].Staffname + "</td></tr><tr>";

                        }

                        if (PName != myList[i].client) {

                            if (myList[i].client == 'Total') {
                                tbl = tbl + "<td style='font-weight: bold;text-align: right;'>" + myList[i].client + "</td>";
                            }
                            else if (myList[i].client == 'Grand Total') {
                                tbl = tbl + "<td style='font-weight: bold;text-align: right;'>" + myList[i].client + "</td>";
                            }
                            else {
                                tbl = tbl + "<td >" + myList[i].client + "</td>";
                            }

                        } else {
                            if (actt != myList[i].Staffname) {
                                if (myList[i].client == 'Total') {
                                    tbl = tbl + "<td style='font-weight: bold;text-align: right;'>" + myList[i].client + "</td>";
                                }
                                else if (myList[i].client == 'Grand Total') {
                                    tbl = tbl + "<td style='font-weight: bold;text-align: right;'>" + myList[i].client + "</td>";
                                }
                                else {
                                    if (PName == myList[i].client) {
                                        tbl = tbl + "<td ></td>";
                                    } else {
                                        tbl = tbl + "<td >" + myList[i].client + "</td>";
                                    }
                                }

                            }
                            else {
                                tbl = tbl + "<td ></td>";
                            }
                        }


                        PName = myList[i].client;
                        actt = myList[i].Staffname;

                        //tbl = tbl + "<td >" + myList[i].BudgAmt + "</td>";
                        tbl = tbl + "<td >" + myList[i].Mjobname + "</td>";

                        if (TypeReport == true) {
                            tbl = tbl + "<td >" + myList[i].clientgrp + "</td>";
                        }

                        if (myList[i].client == 'Total') {
                            tbl = tbl + "<td style='text-align: center;font-weight: bold;'>" + myList[i].hours + "</td>";
                            tbl = tbl + "<td style='text-align: right;font-weight: bold;'>" + myList[i].charges + "</td>";

                            tbl = tbl + "<td style='text-align: center;font-weight: bold;'>" + myList[i].Exp + "</td>";
                            tbl = tbl + "<td style='text-align: right;font-weight: bold;'>" + myList[i].ExpCharges + "</td>";

                        }
                        else if (myList[i].client == 'Grand Total') {
                            tbl = tbl + "<td style='text-align: center;font-weight: bold;'>" + myList[i].hours + "</td>";
                            tbl = tbl + "<td style='text-align: right;font-weight: bold;'>" + myList[i].charges + "</td>";

                            tbl = tbl + "<td style='text-align: center;font-weight: bold;'>" + myList[i].Exp + "</td>";
                            tbl = tbl + "<td style='text-align: right;font-weight: bold;'>" + myList[i].ExpCharges + "</td>";
                        }
                        else {
                            tbl = tbl + "<td style='text-align: center;'>" + myList[i].hours + "</td>";
                            tbl = tbl + "<td style='text-align: right;'>" + myList[i].charges + "</td>";
                            tbl = tbl + "<td style='text-align: center;'>" + myList[i].Exp + "</td>";
                            tbl = tbl + "<td style='text-align: right;'>" + myList[i].ExpCharges + "</td>";

                        }


                        tbl = tbl + "</tr>";
                    }
                    $("[id*=tblReport]").append(tbl);
                    ////////////////
                    var Billablename = 'Non-Billable';

                    if (billtype == 1) {
                        Billablename = 'Billable';
                    }

                    var Projecttype = '';
                    if (TypeReport == true) {
                        Projecttype = 'Report : Staffwise ' + Billablename + ' Details Report';
                    }
                    else {
                        Projecttype = 'Report : Staffwise ' + Billablename + ' Summary Report';
                    }

                    $("[id*=tdReport]").html(Projecttype);

                    ///////////////////////

                } else {

                }
                Blockloaderhide();
            },
            failure: function (response) {
                //showErrorToast('Cant Connect to Server' + response.d);
                showDangerAlert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                //showErrorToast('Error Occoured' + response.d);
                showDangerAlert('Error Occoured ' + response.d);
            }
        });
    }



    //function start
    function Get_All_Staff_Client_Project_BranchName() {
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/WS_StaffWise.asmx/Get_All_Staff_Project_Job_BranchName",
            data: '{compid:0}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length == 0) { }
                else {
                    if (myList == null) { }
                    else {
                        $("[id*=ddlBranch]").empty();
                        $("[id*=ddlBranch]").append("<option value=" + 0 + ">All</option>");
                        for (var i = 0; i < myList.length; i++) {
                            $("[id*=ddlBranch]").append("<option value=" + myList[i].BrId + ">" + myList[i].Branch + "</option>");
                        }

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
    function TStatusCheck() {
        var selectedTStatus = '';
        var count = 0;
        var sbu = $("[id*=chkSubmitted]");
        if (sbu.attr('checked'))
        { count += 1; selectedTStatus += "Submitted,"; }

        sbu = $("[id*=chkSaved]");
        if (sbu.attr('checked'))
        { count += 1; selectedTStatus += "Saved,"; }

        sbu = $("[id*=chkApproved]");
        if (sbu.attr('checked'))
        { count += 1; selectedTStatus += "Approved,"; }


        sbu = $("[id*=chkRejected]");
        if (sbu.attr('checked'))
        { count += 1; selectedTStatus += "Rejected,"; }

        if (count == 4)
        { $("[id*=chkTStatusAll]").attr('checked', 'checked'); }
        else { $("[id*=chkTStatusAll]").removeAttr('checked'); }

        if (selectedTStatus == '') {
            $("[id*=chkApproved]").attr('checked', 'checked');
            selectedTStatus = 'Approved';
        }
        $("[id*=hdnTStatusCheck]").val(selectedTStatus);
        Onpagefilterloads();
    }

    function GetAllSelected() {
        var selectproject = '', selectjob = '', selectstaff = '';
        $(".clProject:checked").each(function () {
            selectproject += $(this).val() + ',';
        });
        $(".clJob:checked").each(function () {
            selectjob += $(this).val() + ',';
        });
        $(".clstaff:checked").each(function () {
            selectstaff += $(this).val() + ',';
        });
        $("[id*=hdnselectedprojectid]").val(selectproject);
        $("[id*=hdnselectedmjobid]").val(selectjob);
        $("[id*=hdnselectedstaff]").val(selectstaff);
        var r = $("[id*=ddlRptType]").val();
        $("[id*=hdnRptType]").val(r);
        var b = $("[id*=ddlBranch]").val();
        $("[id*=hdnbranch]").val(b);
    }

    //////check single staff 
    function singlestaffcheck() {
        if ($(".clstaff").length == $(".clstaff:checked").length) {
            $("[id*=chkstaff]").attr('checked', true);
        }
        else {
            $("[id*=chkstaff]").removeAttr('checked');
        }
        $("[id*=lblProjcount]").html("0");
        $("[id*=tblProjName] tbody").empty();
        $("[id*=tblProjName] thead").empty();

        $("[id*=lblJobcount]").html("0");
        $("[id*=tblJobName] tbody").empty();
        $("[id*=tblJobName] thead").empty();

        staffwise = false, projectwise = true, jobwise = true;
        onpagestaffProjectload();
    }

    //////check single project 
    function singleprojectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length) {
            $("[id*=chkproject]").attr('checked', true);
        }
        else {
            $("[id*=chkproject]").removeAttr('checked');
        }
        staffwise = false, projectwise = false, jobwise = true;
        $("[id*=lblJobcount]").html("0");
        $("[id*=tblJobName] tbody").empty();
        $("[id*=tblJobName] thead").empty();
        onpagestaffProjectload();
    }

    var projectwise = false, jobwise = false, staffwise = true;

    function Onpagefilterloads() {
        projectwise = false, jobwise = false, staffwise = true;
        $("[id*=chkstaff]").removeAttr('checked');
        $("[id*=chkproject]").removeAttr('checked');
        $("[id*=chkjob]").removeAttr('checked');

        $("[id*=lblProjcount]").html("0");
        $("[id*=lblStaffcount]").html("0");
        $("[id*=lblJobcount]").html("0");
        $("[id*=tblStaffname] tbody").empty();
        $("[id*=tblStaffname] thead").empty();
        $("[id*=tblJobName] tbody").empty();
        $("[id*=tblJobName] thead").empty();
        $("[id*=tblProjName] tbody").empty();
        $("[id*=tblProjName] thead").empty();

        onpagestaffProjectload();
    }
    //////////////////////////////////////////////Get All Staff Client Project////////////////////////////////////
    function onpagestaffProjectload() {
        GetAllSelected();
        if (staffwise) {
            $("[id*=hdnselectedprojectid]").val('');
            $("[id*=hdnselectedstaff]").val('Empty');
        }
        //var compid = parseFloat($("[id*=hdnCompid]").val());
        var projectid = $("[id*=hdnselectedprojectid]").val();
        var jobid = $("[id*=hdnselectedmjobid]").val();
        var selectedstaffcode = $("[id*=hdnselectedstaff]").val();
        if ($("[id*=txtfrom]").val() == "" || $("[id*=txtfrom]").val() == undefined) {
            return false;
        }
        if ($("[id*=txtto]").val() == "" || $("[id*=txtto]").val() == undefined) {
            return false;
        }

        Blockloadershow();

        var data = {
            currobj: {
                //compid: compid,
                UserType: $("[id*=hdnUserType]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                StaffCode: $("[id*=hdnStaffCode]").val(),
                selectedstaffcode: selectedstaffcode,
                selectedprojectid: projectid,
                selectedjobid: jobid,
                staffwise: staffwise,
                projectwise: projectwise,
                jobwise: jobwise,
                fromdate: $("[id*=txtfrom]").val(),
                todate: $("[id*=txtto]").val(),
                TType: $("[id*=ddlType]").val(),
                RType: 'staff',
                BrId: $("[id*=ddlBranch]").val()
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/WS_StaffWise.asmx/Get_Staffwise_Project_Job_All_Selected",
            data: JSON.stringify(data),
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        //Ajax end
    }

    function OnSuccess(response) {
        var obj = jQuery.parseJSON(response.d);
        console.log(obj);
        var tableRowsstaff = '', tableRowsproject = '', tableRowsjob = '';
        var countstafff = 0, countproject = 0, countjob = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "staff") {
                countstafff += 1;
                tableRowsstaff += "<tbody><tr><td><input type='checkbox'  onclick='singlestaffcheck()' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
            else if (vl.Type == "Project") {
                countproject += 1;
                tableRowsproject += "<tbody><tr><td><input type='checkbox' checked='checked'  onclick='singleprojectcheck()' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
            else if (vl.Type == "Job") {
                countjob += 1;
                tableRowsjob += "<tbody><tr><td><input type='checkbox' onclick='singlejobcheck()' checked='checked' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
        });
        if (projectwise) {
            if (countproject != 0)
                $("[id*=chkproject]").attr('checked', 'checked');
            else
                $("[id*=chkproject]").removeAttr('checked');

            $("[id*=lblProjcount]").html(countproject);
            $("[id*=tblProjName]").append(tableRowsproject);
        }
        if (jobwise) {

            if (countjob != 0)
                $("[id*=chkjob]").attr('checked', 'checked');
            else
                $("[id*=chkjob]").removeAttr('checked');

            $("[id*=lblJobcount]").html(countjob);
            $("[id*=tblJobName]").append(tableRowsjob);
        }
        if (staffwise) {

            $("[id*=chkstaff]").removeAttr('checked');

            $("[id*=lblStaffcount]").html(countstafff);
            $("[id*=tblStaffname]").append(tableRowsstaff);
        }
        Blockloaderhide();
    }

    function CountFrmTitle(field, max) {
        if (field.value.length > max) {
            field.value = field.value.substring(0, max);
            alert("You are exceeding the maximum limit");
        }
        else {
            field.value = field.value.replace(/[?\#!$%\^\*;:{}=\_`~@"'+]/g, "");
            var count = max - field.value.length;
        }
    }

</script>
<style type="text/css">
    .Chkbox {
        height: 20px;
        width: 20px;
        cursor: pointer;
        margin-right: 5px;
    }

    .Spancount {
        height: 20px;
        width: 50px;
        font-size: 12px;
        font-weight: bold;
    }

    .cssPageTitle {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        border-bottom: 2px solid #0b9322;
        /*padding: 7px;*/
        color: #0b9322;
    }

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

    .cssPageTitle2 {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        /*border-bottom: 2px solid #0b9322;*/
        padding: 7px;
        color: #0b9322;
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
</style>
<%--design part--%>



<div class="page-content">
    <asp:HiddenField runat="server" ID="hdndeptwise" />
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnUserType" />
    <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="Empty" />
    <asp:HiddenField runat="server" ID="hdnselectedprojectid" />
    <asp:HiddenField runat="server" ID="hdnselectedjobid" />
    <asp:HiddenField runat="server" ID="hdnselectedmjobid" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
    <asp:HiddenField runat="server" ID="hdnselectedstaff" />
    <asp:HiddenField runat="server" ID="hdntype" />
    <asp:HiddenField runat="server" ID="hdnbranch" />
    <asp:HiddenField runat="server" ID="hdnBrId" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
    <asp:HiddenField runat="server" ID="hdnFrom" />
    <asp:HiddenField runat="server" ID="hdnTo" />
    <asp:HiddenField ID="hdnCompname" runat="server" />
    <div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>				
						
</div>
    

        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-left: 1rem;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Billable/Non Billable Report For Staff</span></h5>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

                <button type="button" id="btngen" class="btn bg-success legitRipple">Generate Report</button>
            </div>
        </div>

        <div class="content">
            <div class="divstyle card">
                <div id="div2" class="totbodycatreg" style="height: 700px;">
                    <div style="width: 100%;">
                        <uc2:MessageControl ID="MessageControl1" runat="server" />
                    </div>
                    <div runat="server" id="dvInvoice">
                        <div class="card-body">
                            <table width="1100px;" style="padding-left: 85px; padding-top: 15px;">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <table class="style1" width="100%">
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblbranch" Font-Bold="true" runat="server">Branch</asp:Label>
                                                </td>
                                                <td>:
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlBranch" CssClass="texboxcls" runat="server" Width="120px">
                                                        <asp:ListItem Value="0" Text="All"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td valign="middle">
                                                    <asp:Label ID="Label11" runat="server" ForeColor="Black" Style="text-align: right" Text="From" Font-Bold="True"></asp:Label>
                                                </td>
                                                <td align="center" valign="middle">:
                                                </td>
                                                <td valign="middle">

                                                    <input type="date" id="txtfrom" name="txtfrom" class="form-control form-control-border" />
                                                </td>
                                                <td valign="middle">
                                                    <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To" Font-Bold="True"></asp:Label>
                                                </td>
                                                <td align="center" valign="middle">:
                                                </td>
                                                <td valign="middle">
                                                    <input type="date" id="txtto" name="txtto" class="form-control form-control-border" />
                                                </td>
                                                <td valign="middle">
                                                    <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status" Font-Bold="True"></asp:Label>
                                                </td>
                                                <td valign="middle" align="center">:
                                                </td>
                                                <td valign="middle" colspan="3">
                                                    <asp:CheckBox ID="chkTStatusAll" ClientIDMode="Static" runat="server" Checked="true"
                                                        Text="All" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server" Checked="true"
                                            onclick="TStatusCheck()" Text="Submitted" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static" Checked="true" onclick="TStatusCheck()"
                                            Text="Saved" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()" Checked="true"
                                            ClientIDMode="Static" Text="Approved" />&nbsp;&nbsp;
                                       
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 5px;"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lbltype" Font-Bold="true" runat="server">Type</asp:Label>
                                                </td>
                                                <td>:
                                                </td>
                                                <td>
                                                    <select id="ddlType" class="texboxcls" style="width: 120px;">
                                                        <%--<option value="All">All</option>--%>
                                                        <option value="1">Billable</option>
                                                        <option value="0">Non Billable</option>
                                                    </select>
                                                </td>
                                                <td valign="middle">
                                                    <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Report Type" Font-Bold="True"></asp:Label>
                                                </td>
                                                <td align="center" valign="middle">:
                                                </td>
                                                <td valign="middle">
                                                    <asp:RadioButton runat="server" ID="rsummary" Text="Summary" Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                                            <asp:RadioButton runat="server" ID="rdetailed" Text="Detailed" GroupName="rbtn" />&nbsp;
                                                </td>
                                                <td colspan="3"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>



                        <div id="dvEditInvoice2" class="row">
                            <div class="col-md-4">

                                <!-- Grey background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold"><i class="icon-user-check mr-2"></i>
                                            <input type="checkbox" class="Chkbox" id="chkstaff" name="chkstaff" />Staff <span id="lblStaffcount" name="lblStaffcount" class="badge badge-success badge-pill Spancount">0</span></h6>
                                        <div class="header-elements">
                                            <div class="list-icons">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card-body">
                                        <div class="form-group row">
                                            <div style="height: 450px; width: 100%; overflow-y: scroll;">
                                                <table id="tblStaffname" name="tblStaffname" class="table table-hover table-xs font-size-base"></table>
                                            </div>
                                        </div>


                                    </div>



                                </form>
                                <!-- /grey background, left button spacing -->



                            </div>

                            <div class="col-md-4">

                                <!-- White background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold">
                                            <input type="checkbox" class="Chkbox" id="chkproject" name="chkproject" />Project <span id="lblProjcount" name="lblProjcount" class="badge badge-success badge-pill Spancount">0</span></h6>
                                        <div class="header-elements">
                                            <div class="list-icons">
                                            </div>
                                        </div>
                                    </div>



                                    <div class="card-body">
                                        <div class="form-group row">
                                            <div style="height: 450px; width: 100%; overflow-y: scroll;">
                                                <table id="tblProjName" name="tblProjName" class="table table-hover table-xs font-size-base"></table>
                                            </div>
                                        </div>


                                    </div>



                                </form>
                                <!-- /white background, left button spacing -->


                            </div>
                            <div class="col-md-4">

                                <!-- White background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold">
                                            <input type="checkbox" class="Chkbox" id="chkjob" name="chkjob" />Job <span id="lblJobcount" name="lblJobcount" class="badge badge-success badge-pill Spancount">0</span></h6>
                                        <div class="header-elements">
                                            <div class="list-icons">
                                            </div>
                                        </div>
                                    </div>



                                    <div class="card-body">
                                        <div class="form-group row">
                                            <div style="height: 450px; width: 100%; overflow-y: scroll;">
                                                <table id="tblJobName" name="tblJobName" class="table table-hover table-xs font-size-base"></table>
                                            </div>
                                        </div>


                                    </div>



                                </form>
                                <!-- /white background, left button spacing -->


                            </div>
                        </div>

                    </div>

                    <div id="dvReport" style="display: none;" class="card">
                        <div class="card-header bg-white header-elements-inline">
                            <h5 class="card-title font-weight-bold"></h5>


                            <div class="header-elements">
                                <div class="list-icons">
                                     <button type="button" id="btnexcel" onclick="ExcelExport();" class=" buttons-pdf btn btn-outline-success legitRipple ">Export to XL <i class="icon-file-excel ml-2"></i></button>
                                    <button type="button" id="btnpdf" onclick="test();" class="buttons-pdf btn btn-outline-success legitRipple">Export to PDF <i class="icon-file-pdf ml-2"></i></button>
                                    <button type="button" id="btnBack" name="btnBack" class=" btn btn-outline-success legitRipple">Back</button>

                                </div>
                            </div>
                        </div>
                        <div id="divReportGrid">
                            <div class="card-header bg-white ">
                                <h5 id="hCompanyname" name="hCompanyname" class="card-title font-weight-bold text-center">Demo Company
                                </h5>

                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <div>
                                    <table style="font-weight: bold;">
                                        <tr>
                                            <td id="tdReport">Report : Projectwise Budgeting</td>
                                            <td style="width: 40%;"></td>
                                            <td>
                                                <div id="divdtrange" name="divdtrange" style="font-weight: bold;">From 01/04/2021 To 30/04/2021</div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table id="tblReport" class="table table-hover table-xs font-size-base ">
                                </table>

                            </div>
                        </div>
                    </div>


                </div>
            </div>
        </div>
    </div>

</div>
