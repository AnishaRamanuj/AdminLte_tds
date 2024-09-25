<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LeaveReport.ascx.cs" Inherits="controls_LeaveReport" %>

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
<script type="text/javascript" src="../js/table2excel.js"></script>
<script type="text/javascript">
    var CompanyPermissions = [];
    $(document).ready(function () {
        $('.sidebar-main-toggle').click();
        CompanyPermissions = jQuery.parseJSON($("[id*=hdnCompanyPermission]").val());
        var Frmdt = $("[id*= hdnFrom]").val();
        var todt = $("[id*= hdnTo]").val();
        $("[id*= txtfrom]").val(Frmdt);

        $("[id*= TextTodt]").val(todt);
        $("[id*=hCompanyname]").html($("[id*=hdnCompname]").val());

        GetLeaveYears();
        GetChangeRedio();


        $("[id*=txtfrom]").on('change', function () {

            pageFiltersReset();
        });

        $("[id*=TextTodt]").on('change', function () {
            var Dt = $("[id*=TextTodt]").val();
            pageFiltersReset();
        });

        $("[id*=redioBalance]").on('click', function () {
            GetChangeRedio();
        });

        $("[id*=redioDetail]").on('click', function () {
            GetChangeRedio();
        });

        $("[id*=SelectYear]").on('change', function () {
            pageFiltersReset();
        });

        $("[id*=ddpType]").on('change', function () {
            pageFiltersReset();
        });
        ////check all Stff
        $("[id*=chkStaff]").on("click", function () {
            var check = $(this).is(':checked');
            if ($(".clStaff").length == 0) {
                return false;
            }
            $(".clStaff").each(function () {
                if (check) {
                    $(this).attr('checked', 'checked');
                }
                else { $(this).removeAttr('checked'); }
            });

            CountAlloc();
        });


        $("[id*=btnReport]").click(function () {
            GetAllSelected();

            if ($("[id*=hdnselectedStaff]") == '') {
                showWarningAlert('Kindly Select atleast one Staff !!!');
                return;
            } else {
                $("[id*=divReportInput]").hide();
                $("[id*=dvReport]").show();
                $("[id*=btnReport]").hide();
                GetGrid();
            }

        });

        $("[id*=btnBack]").click(function () {
            $("[id*=divReportInput]").show();
            $("[id*=dvReport]").hide();
            $("[id*=btnReport]").show();
        });

    });

    function GetChangeRedio() {
        var Details = $("[id*=redioDetail]").is(':checked');
        var Balance = $("[id*=redioBalance]").is(':checked');

        if (Details == true) {
            $("[id*=dvlblLT]").show();
            $("[id*=dvptype]").show();
            $("[id*=dvFrm]").show();
            $("[id*=dvtxtfrm]").show();
            $("[id*=dvlblto]").show();
            $("[id*=dvtxtto]").show();

            $("[id*=dvlblyr]").hide();
            $("[id*=dvdrpyr]").hide();
        } else {
            $("[id*=dvlblLT]").hide();
            $("[id*=dvptype]").hide();
            $("[id*=dvFrm]").hide();
            $("[id*=dvtxtfrm]").hide();
            $("[id*=dvlblto]").hide();
            $("[id*=dvtxtto]").hide();

            $("[id*=dvlblyr]").show();
            $("[id*=dvdrpyr]").show();
        }
        pageFiltersReset();
    }

    function GetLeaveYears() {
        ///////ajax start
        //var Compid = $("[id*=hdnCompanyid]").val();
        $.ajax({
            type: "POST",
            url: "../Services/LeaveMng.asmx/GetLeaveYears",
            data: '{compid:0}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                $("[id*=SelectYear]").empty();

                if (myList.length > 0) {
                    for (var i = 0; i < myList.length; i++) {
                        $("[id*=SelectYear]").append("<option value='" + myList[i].Country + "'>" + myList[i].Country + "</option>");
                    }
                } else {
                    showWarningAlert('Kindly put the Leave Year !');
                }

            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
    }

    function CountAlloc() {
        var count = 0;
        $("input[name=chkstaffLV]").each(function () {
            Assignrow = $(this).closest("tr");
            chk = $(this).is(':checked');
            if (chk == true) {
                count = count + 1;
            }
        });
        $("[id*=lblStaffcount]").html(count);
    }

    function ExcelExport() {
        var Details = $("[id*=redioDetail]").is(':checked');
        var Balance = $("[id*=redioBalance]").is(':checked');
        var name = '';
        if (Details == true) {
            name = 'LeaveDetail.xls'
        } else {
            name = 'LeaveBalance.xls'
        }
        $("#divReportGrid").table2excel({

            filename: name
        });
    }

    function GetGrid() {
        Blockloadershow();
        //var Compid = $("[id*=hdnCompanyID]").val();
        var frmdt = $("[id*=txtfrom]").val();
        var Todt = $("[id*=TextTodt]").val();
        var TStatus = $("[id*=ddpType]").val();
        var Staffcodeids = $("[id*=hdnselectedStaff]").val();
        var Details = $("[id*=redioDetail]").is(':checked');
        var Balance = $("[id*=redioBalance]").is(':checked');
        var Year = $("[id*=SelectYear]").val();
        $.ajax({
            type: "POST",
            url: "../Services/LeaveMng.asmx/GetLeaveReport",
            data: '{frmdt:"' + frmdt + '",Todt:"' + Todt + '",TStatus:"' + TStatus + '",Staffcodeids:"' + Staffcodeids + '",Details:"' + Details + '",Balance:"' + Balance + '",Year:' + Year + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var tbl = '', PName = '', actt = '';

                if (Details == false) {
                    $("[id*=divdtrange]").html('Balance Report For the Year of ' + Year);

                } else {
                    $("[id*=divdtrange]").html('Detail Report From ' + moment(frmdt).format('DD/MM/YYYY') + ' ' + 'To ' + moment(Todt).format('DD/MM/YYYY'));

                }

                $("[id*=tblReport] tbody").empty();
                $("[id*=tblReport] thead").empty();
                if (Details == true) {
                    tbl = tbl + "<thead><tr>";
                    tbl = tbl + "<th style='font-weight: bold;'>Staff</th>";
                    tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Leave</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>App Date</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>From Date</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>To Date</th>";
                    if (CompanyPermissions[0].LeaveFormat == true) {
                        tbl = tbl + "<th style='font-weight: bold;'>Leave Hrs</th>";
                    } else {
                        tbl = tbl + "<th style='font-weight: bold;'>Leave Days</th>";
                    }
                    tbl = tbl + "<th style='font-weight: bold;'>Status</th>";

                    tbl = tbl + "<th style='font-weight: bold;'>Approver</th>";

                    tbl = tbl + "</tr></thead>";

                    if (myList.length > 0) {
                        for (var i = 0; i < myList.length; i++) {
                            tbl = tbl + "<tr>";

                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].staff + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].Leave + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].appdt + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].strtdt + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].endt + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].LevHrs + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].status + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].Appr + "</td>";

                            tbl = tbl + "</tr>";
                        }
                        $("[id*=tblReport]").append(tbl);
                    }
                }
                else {
                    tbl = tbl + "<thead><tr>";
                    tbl = tbl + "<th style='font-weight: bold;'>Staff</th>";
                    tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Leave</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Opening Balance</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Leave Taken</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Balance</th>";
                    tbl = tbl + "</tr></thead>";

                    if (myList.length > 0) {
                        for (var i = 0; i < myList.length; i++) {
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].staff + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].Leave + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].OpnBalc + "</td>";
                            tbl = tbl + "<td style='text-align: center;'>" + myList[i].LevTaken + "</td>";
                            tbl = tbl + "<td style='text-align: center;'>" + myList[i].Balance + "</td>";
                            tbl = tbl + "</tr>";
                        }
                        $("[id*=tblReport]").append(tbl);
                    }
                }


                Blockloaderhide();
            },
            failure: function (response) {
                //showErrorToast('Cant Connect to Server' + response.d);
                showDangerAlert('Cant Connect to Server' + response.d);
                Blockloaderhide();
            },
            error: function (response) {
                //showErrorToast('Error Occoured' + response.d);
                showDangerAlert('Error Occoured ' + response.d);
                Blockloaderhide();
            }
        });
    }


    function pageFiltersReset() {
        $("[id*=chkStaff]").removeAttr('checked');
        $("[id*=tblStaffname] tbody").empty();
        $("[id*=tblStaffname] thead").empty();
        $("[id*=lblStaffcount]").html('0');
        GetLeaveStaff();
    }



    function GetLeaveStaff() {
        //var compid = $("[id*=hdnCompanyID]").val();
        var Start = $("[id*=txtfrom]").val();
        var end = $("[id*=TextTodt]").val();
        var staffcode = $("[id*=hdnStaffCode]").val();
        if (staffcode == '') {
            staffcode = 0;
        }
        var TStatus = $("[id*=ddpType]").val();
        var Year = $("[id*=SelectYear]").val();
        if (Year == null) {
            Year = 0;
        }
        var Details = $("[id*=redioDetail]").is(':checked');
        var Balance = $("[id*=redioBalance]").is(':checked');

        $.ajax({
            type: "POST",
            url: "../Services/LeaveMng.asmx/GetLeaveStaff",
            data: '{Start:"' + Start + '",end:"' + end + '",staffcode:' + staffcode + ',TStatus:"' + TStatus + '",Year:' + Year + ',Details:"' + Details + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: OnSuccess,
            failure: function (response) {

            },
            error: function (response) {

            }
        });
    }

    function OnSuccess(response) {
        var obj = jQuery.parseJSON(response.d);
        console.log(obj);
        var tableRowsProj = '', tableRowsclt = '';
        var countProj = 0, countClt = 0;
        var Type = "Staff";
        $.each(obj, function (i, vl) {
            countClt += 1;
            tableRowsclt += "<tbody><tr><td><input id='chkstaffLV' name='chkstaffLV' type='checkbox'  onclick='CountAlloc()'  class='cl" + Type + " Chkbox' value='" + vl.Staffcode + "' /></td><td>" + vl.StaffNames + "</td></tr></tbody>";
        });

        $("[id*=chkStaff]").removeAttr('checked');
        $("[id*=lblStaffcount]").html(0);
        $("[id*=tblStaffname]").append(tableRowsclt);
    }



    function GetAllSelected() {
        var selectClient = '', selectProject = '';

        $(".clStaff:checked").each(function () {
            selectClient += $(this).val() + ',';
        });


        $("[id*=hdnselectedStaff]").val(selectClient);
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


<div class="page-content">
    <asp:HiddenField ID="hdnCompanyID" runat="server" />
    <asp:HiddenField ID="hdnStaffCode" runat="server" />
    <asp:HiddenField ID="hdnselectedStaff" runat="server" />
    <asp:HiddenField ID="hdnPages" runat="server" />
    <asp:HiddenField runat="server" ID="hdnFrom" />
    <asp:HiddenField runat="server" ID="hdnTo" />
    <asp:HiddenField runat="server" ID="hdnCompname" />
    <asp:HiddenField ID="hdnCompanyPermission" runat="server" />

    <div class="content-header">

        <div class="container-fluid">
            <div class="row mb-2">
            </div>

        </div>

    </div>
    <div class="page-header " style="height: 50px;">
        <div class="page-header-content header-elements-md-inline" style="padding-top: -4px; padding-bottom: 10px;">
            <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Leave Report</span></h5>
                <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
            </div>
            <div class="col-2">
                <button type="button" id="btnReport" class=" btn btn-outline-success legitRipple"><i class="mi-library-books mr-2 fa-1x"></i>Generate Report</button>
            </div>

        </div>

    </div>
    <div class="content">
        <div class="divstyle card">
            <div id="divReportInput" class="card-body">

                <div class="form-group row card-header bg-white header-elements-inline">
                    <div class="col-1" id="dvlblLT">
                        <label style="font-weight: bold; padding-top: 10px;">Leave Type</label>

                    </div>

                    <div class="col-2" id="dvptype">
                        <select id="ddpType" name="ddpType" class="form-control select select2-hidden-accessible" data-fouc>
                            <option value="All" selected>Select</option>
                            <option value="Approved">Approved</option>
                            <option value="Pending">Pending</option>
                        </select>
                    </div>

                    <div style="width: 50px;"></div>
                    <div id="dvFrm">
                        <label style="font-weight: bold; padding-top: 10px;">From</label>

                    </div>
                    <div class="col-2" id="dvtxtfrm">
                        <input type="date" id="txtfrom" name="txtfrom" class="form-control form-control-border" />

                    </div>
                    <div style="width: 50px;"></div>
                    <div id="dvlblto">
                        <label style="font-weight: bold; padding-top: 10px;">To</label>

                    </div>
                    <div class="col-2" id="dvtxtto">
                        <input type="date" id="TextTodt" name="TextTodt" class="form-control form-control-border" value="" />

                    </div>


                    <div id="dvlblyr">
                        <label style="font-weight: bold; padding-top: 10px;">Select Leave Year</label>

                    </div>
                    <div class="col-1" id="dvdrpyr">
                        <select id="SelectYear" name="SelectYear" class="form-control select select2-hidden-accessible col-4" data-fouc>
                        </select>
                    </div>

                    <div style="width: 50px;"></div>
                    <div class="col-1">
                        <label style="font-weight: bold; padding-top: 10px;">Report Type</label>

                    </div>
                    <div class="custom-control custom-radio custom-control-inline" style="padding-top: 10px;">
                        <input type="radio" class="custom-control-input" name="custom-inline-radio" id="redioDetail" checked>
                        <label class="custom-control-label" for="redioDetail">Details</label>
                    </div>

                    <div class="custom-control custom-radio custom-control-inline" style="padding-top: 10px;">
                        <input type="radio" class="custom-control-input" name="custom-inline-radio" id="redioBalance">
                        <label class="custom-control-label" for="redioBalance">Balance</label>
                    </div>
                </div>



                <div id="dvEditInvoice2" class="row">

                    <div class="col-md-6">

                        <!-- Grey background, left button spacing -->
                        <form>

                            <div class="card-header bg-white header-elements-inline">
                                <h6 class="card-title font-weight-bold"><i class="icon-user-check mr-2"></i>
                                    <input type="checkbox" class="Chkbox" id="chkStaff" name="chkStaff" />Staff <span id="lblStaffcount" name="lblStaffcount" class="badge badge-success badge-pill Spancount">0</span></h6>
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

                </div>


            </div>
            <div id="dvReport" style="display: none;" class="card">
                <div class="card-header bg-white header-elements-inline">
                    <h5 class="card-title font-weight-bold"></h5>


                    <div class="header-elements">
                        <div class="list-icons">
                            <button type="button" id="btnexcel" onclick="ExcelExport();" class="btn btn-outline-success legitRipple">Export to XL <i class="icon-file-excel ml-2"></i></button>
                            <button type="button" id="btnBack" name="btnBack" class="btn btn-outline-primary"><i class="fa fa-arrow-left mr-2 fa-1x"></i>Back</button>

                        </div>
                    </div>
                </div>
                <div id="divReportGrid">
                    <div class="card-header bg-white ">
                        <h5 id="hCompanyname" name="hCompanyname" class="card-title font-weight-bold text-center">Demo Company
                        </h5>

                        <div id="divdtrange" name="divdtrange" style="font-weight: bold;" class="text-muted  text-center">From 01/04/2021 To 30/04/2021</div>

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


