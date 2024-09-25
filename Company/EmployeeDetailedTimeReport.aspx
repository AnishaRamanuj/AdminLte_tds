<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true" CodeFile="EmployeeDetailedTimeReport.aspx.cs" Inherits="Company_Employee_DetailedTimeReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="../js/select2.min.js" type="text/javascript"></script>
    <script src="../js/form_select2.js" type="text/javascript"></script>
    <script src="../js/Ajax_Pager.min.js" type="text/javascript"></script>
    <script src="../js/components_popups.js" type="text/javascript"></script>
    <script src="../js/components_modals.js" type="text/javascript"></script>
    <script src="../js/PopupAlert.js" type="text/javascript"></script>
    <script src="../js/moment.js" type="text/javascript"></script>
    <script src="../js/bootstrap_multiselect.js" type="text/javascript"></script>

    <script language="javascript" type="text/javascript">
        $(document).ready(function () {
            $('.sidebar-main-toggle').click();
            $("[id*=hdnPages]").val(1);
            $("[id*=hdnSize]").val(2000);

            BindStaffDropdown();

            $("#btnGenerateReport").on('click', function () {
                var selectedStaffs = $("[id*=drpStaff]").val();

                if ($("[id*=txtFromDate]").val() == '') {
                    showDangerAlert("Please select from date!");
                    return;
                }

                if ($("[id*=txtToDate]").val() == '') {
                    showDangerAlert("Please select to date!");
                    return;
                }

                if (selectedStaffs == '') {
                    showDangerAlert("Please select staff!");
                    return;
                }

                if (selectedStaffs != null && selectedStaffs.length > 0 && $("[id*=txtFromDate]").val() != '' && $("[id*=txtToDate]").val() != '') {
                    GenerateReport(1, 2000);
                }
            });


        });

        function GenerateReport(pageIndex, pageSize) {
            Blockloadershow();
            $.ajax({
                type: "POST",
                url: "../Services/EmployeeDetailedTimeReport.asmx/GetEmpReport",
                data: '{compId:' + $("[id*=hdnCompanyid]").val() + ', staffs: "' + $("[id*=drpStaff]").val() + '", fromDate: "' + $("[id*=txtFromDate]").val() + '", toDate: "' + $("[id*=txtToDate]").val() + '", pageIndex: ' + pageIndex + ', pageSize: ' + pageSize + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var xmlDoc = $.parseXML(msg.d);
                    var xml = $(xmlDoc);
                    var empData = xml.find("Table");
                    if (empData != null && empData != undefined) {
                        BindReport(empData);
                    }
                    Blockloaderhide();
                },
                failure: function (response) {
                    Blockloaderhide();
                },
                error: function (response) {
                    Blockloaderhide();
                }
            });
        }

        function BindReport(report) {
            var tbl = '';
            var RecordCount;
            $("[id*=tbl_StaffEffort]").empty();
            tbl = '';
            tbl = tbl + "<thead><tr>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Date</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Start Time</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>End Time</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Project No.</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Proj. Name</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>ChangeOrder</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>AreaName</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Task</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>SubTask</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Employee</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Bill Hours</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Non Bill Hours</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Narr</th>";
            tbl = tbl + "</tr></thead> ";
            tbl = tbl + "<tbody>";
            var tc;
            if (report.length > 0) {

                $.each(report, function () {
                    tc = $(this).find("TotalCount").text();
                    tbl = tbl + "<tr>";
                    tbl = tbl + "<td><label id='lblDate' name='lblDate' >" + $(this).find("Date").text() + "</label></td>";
                    tbl = tbl + "<td><label id='lblfrmtime' name='lblfrmtime' >" + $(this).find("frmTime").text() + "</label></td>";
                    tbl = tbl + "<td><label id='lbltotime' name='lbltotime' >" + $(this).find("ToTime").text() + "</label></td>";
                    tbl = tbl + "<td><label id='lblProjectNo' name='lblProjectNo' >" + $(this).find("ProjectNo").text() + "</label></td>";
                    tbl = tbl + "<td><label id='lblProjName' name='lblProjName' >" + $(this).find("ProjectName").text() + "</label></td>";
                    tbl = tbl + "<td><label id='lblChange' name='lblChange' >" + $(this).find("ChangeOrderNew").text() + "</label></td>";
                    tbl = tbl + "<td><label id='lblAreaName' name='lblAreaName' >" + $(this).find("AreaName").text() + "</label></td>";
                    tbl = tbl + "<td><label id='lblTask' name='lblTask' >" + $(this).find("Task").text() + "</label></td>";
                    tbl = tbl + "<td><label id='lblSubTask' name='lblSubTask' >" + $(this).find("SubTask").text() + "</label></td>";
                    if ($(this).find("StaffName").text() == 'zzzzzzzzzz.Total') {
                        tbl = tbl + "<td><label id='lblEmployee' name='lblEmployee' ><p><b>" + $(this).find("StaffName").text().replace('zzzzzzzzzz.Total', "Total") + "</b></p></label></td>";
                        tbl = tbl + "<td><label id='lblBillableHours' name='lblBillableHours' ><p><b>" + $(this).find("BillableHrs").text() + "</b></p></label></td>";
                        tbl = tbl + "<td><label id='lblNonBillableHours' name='lblNonBillableHours' ><p><b>" + $(this).find("NonBillableHrs").text() + "</b></p></label></td>";
                    }
                    else {
                        tbl = tbl + "<td><label id='lblEmployee' name='lblEmployee' >" + $(this).find("StaffName").text() + "</label></td>";
                        tbl = tbl + "<td><label id='lblBillableHours' name='lblBillableHours' >" + $(this).find("BillableHrs").text() + "</label></td>";
                        tbl = tbl + "<td><label id='lblNonBillableHours' name='lblNonBillableHours' >" + $(this).find("NonBillableHrs").text() + "</label></td>";
                    }
                    tbl = tbl + "<td><label id='lblNarration' name='lblNarration' >" + $(this).find("Narration").text() + "</label></td>";
                    tbl = tbl + "</tr>";
                });
                tbl = tbl + "</tbody>"
                $("[id*=tbl_StaffEffort]").append(tbl);
            }
            else {
                tc = 0;
                tbl = tbl + "<tr>";
                tbl = tbl + "<td >No Record Found !!!</td>";
                tbl = tbl + "</tr>";
                $("[id*=tbl_StaffEffort]").append(tbl);
            }

            if (parseFloat(tc) > 0) {
                if (parseInt(tc) > parseInt($("[id*=hdnSize]").val())) {
                    RecordCount = parseFloat(tc);
                } else {
                    RecordCount = 0;
                }
            }
            Pager(RecordCount);

            MergeCommonRows($("[id*=tbl_StaffEffort]"))
        }

        function BindStaffDropdown() {
            Blockloadershow();
            $.ajax({
                type: "POST",
                url: "../Services/Profile.asmx/GetStaffs",
                data: '{compId:' + $("[id*=hdnCompanyid]").val() + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var staffList = jQuery.parseJSON(msg.d);
                    if (staffList != null && staffList != undefined) {
                        FillDropdownStaffs(staffList);
                    }
                    Blockloaderhide();
                },
                failure: function (response) {
                    showDangerAlert("Error!");
                    Blockloaderhide();
                },
                error: function (response) {
                    showDangerAlert("Error!");
                    Blockloaderhide();
                }
            });
        }

        function FillDropdownStaffs(data) {
            var dropdownControl = $("[id*=drpStaff]");
            dropdownControl.multiselect('destroy');
            var option = "";
            for (let i = 0; i < data.length; i++) {
                if (data[i].StaffName.indexOf("Select") <= -1) {
                    option += "<option value='" + data[i].StaffCode + "'>" + data[i].StaffName + "</option>";
                }
            }

            dropdownControl.html(option);
            dropdownControl.multiselect({
                allSelectedText: 'All',
                maxHeight: 200,
                includeSelectAllOption: true,
                nonSelectedText: "-Select-",
                enableFiltering: true,
                includeFilterClearBtn: true,
                enableCaseInsensitiveFiltering: true
            });
            dropdownControl.multiselect('selectAll', false);
            dropdownControl.multiselect('updateButtonText');
            dropdownControl.multiselect("clearSelection");
            dropdownControl.multiselect('rebuild');
            dropdownControl.multiselect("refresh");
        }

        function Pager(RecordCount) {
            $(".Pager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt($("[id*=hdnPages]").val()),
                PageSize: parseInt($("[id*=hdnSize]").val()),
                RecordCount: parseInt(RecordCount)
            });

            ////pagging changed bind LeaveMater with new page index
            $(".Pager .page").on("click", function () {
                $("[id*=hdnPages]").val($(this).attr('page'));
                pg = parseInt($("[id*=hdnSize]").val()),
                    GenerateReport(($(this).attr('page')), pg)
            });
        }

        function ExportAssignValues() {
            var selectedStaffs = $("[id*=drpStaff]").val();
            if ($("[id*=txtFromDate]").val() == '') {
                showDangerAlert("Please select from date!");
                return;
            }

            if ($("[id*=txtToDate]").val() == '') {
                showDangerAlert("Please select to date!");
                return;
            }

            if (selectedStaffs == '') {
                showDangerAlert("Please select staff!");
                return;
            }

            if (selectedStaffs != null && selectedStaffs.length > 0 && $("[id*=txtFromDate]").val() != '' && $("[id*=txtToDate]").val() != '') {
                $("[id*=hdnFromDate]").val($("[id*=txtFromDate]").val());
                $("[id*=hdnToDate]").val($("[id*=txtToDate]").val());
                $("[id*=hdnSelectedStaffs]").val(selectedStaffs);
            }
            // Code Added By SathishRam For Hiding BlockerUI On 21-Mar-2023
            var cookieval = makeid();
            $('#<%= hdnCookieName.ClientID %>').val(cookieval);
            test(cookieval);
            Blockloaderhide();
            // Code Added By SathishRam For Hiding BlockerUI On 21-Mar-2023
    
        }

        function MergeCommonRows(table) {
            var firstColumnBrakes = [];
            // iterate through the columns instead of passing each column as function parameter:
            //for (var i = 1; i <= table.find('th').length; i++) {
            for (var i = 4; i <= 4; i++) {
                var previous = null, cellToExtend = null, rowspan = 1;
                table.find("td:nth-child(" + i + ")").each(function (index, e) {
                    var jthis = $(this), content = jthis.text();
                    // check if current row "break" exist in the array. If not, then extend rowspan:
                    if (previous == content && content !== "" && $.inArray(index, firstColumnBrakes) === -1) {
                        // hide the row instead of remove(), so the DOM index won't "move" inside loop.

                        jthis.addClass('hidden');
                        cellToExtend.attr("rowspan", (rowspan = rowspan + 1));
                    } else {
                        // store row breaks only for the first column:
                        if (i === 1) firstColumnBrakes.push(index);
                        rowspan = 1;
                        previous = content;
                        cellToExtend = jthis;
                    }
                });
            }
            // now remove hidden td's (or leave them hidden if you wish):
            $('td.hidden').remove();
        }


        // Code Added By SathishRam For Hiding BlockerUI On 21-Mar-2023
        function test(cookieval) {
            var cookie = ReadCookie('CookieReport');
            if (cookie != cookieval) {
                setTimeout(function () { test(cookieval) }, 1000);
                return true;
            }
            else {
                Blockloaderhide();
                return true;
            }
        }

        function makeid() {
            var text = "";
            var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            for (var i = 0; i < 5; i++)
                text += possible.charAt(Math.floor(Math.random() * possible.length));
            return text;
        }

        function ReadCookie(cookieName) {
            var theCookie = "" + document.cookie;
            var ind = theCookie.indexOf(cookieName);
            if (ind == -1 || cookieName == "") return "";
            var ind1 = theCookie.indexOf(';', ind);
            if (ind1 == -1) ind1 = theCookie.length;
            return unescape(theCookie.substring(ind + cookieName.length + 1, ind1));
        }
        // Code Added By SathishRam For Hiding BlockerUI On 21-Mar-2023
    </script>

    <style type="text/css">
        .Pager b {
            margin-top: 2px;
            margin-left: 5px;
            float: left;
            padding-right: 40%;
            padding-top: 8px;
            width: 60%;
            text-align: left !important;
        }

        .Pager span {
            background-color: #26A69A;
            z-index: 1;
            color: #fff;
            border-color: #26a69a;
            /*/*position: relative;*/ */ overflow: hidden;
            text-align: center;
            min-width: 2.8rem;
            transition: all ease-in-out .15s;
            /*display: block;*/
            padding: .5rem 1rem;
            line-height: 1.5385;
            border-radius: 10rem;
            margin-right: 3px;
            text-align: center !important;
        }

        .Pager a {
            background-color: #eee;
            z-index: 1;
            color: #fff;
            border-color: #26a69a;
            position: relative;
            overflow: hidden;
            text-align: center;
            min-width: 2.8rem;
            transition: all ease-in-out .15s;
            /*display: block;*/
            padding: .5rem 1rem;
            line-height: 1.5385;
            border-radius: 10rem;
            margin-right: 3px;
            text-align: center !important;
        }

        .Pager {
            margin-bottom: 0;
            background-color: #fff;
            border-color: #fff;
            margin-left: 2px;
            /*border-radius: 0.1875rem;*/
            display: flex;
            padding-left: 0;
            height: 40px;
            text-align: center !important;
        }

        .ShowPage {
            float: right;
            display: inline-block;
            margin: 0 0 0 1.25rem;
            width: 50px;
        }

        .ButtonPadding {
            padding: 0px 0px 0px 20px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField runat="server" ID="hdnCompanyid" />
    <asp:HiddenField ID="hdnPages" runat="server" />
    <asp:HiddenField ID="hdnSize" runat="server" />
    <asp:HiddenField ID="hdnFromDate" runat="server" />
    <asp:HiddenField ID="hdnToDate" runat="server" />
    <asp:HiddenField ID="hdnSelectedStaffs" runat="server" />
    <asp:HiddenField ID="hdnCookieName" runat="server" />
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-1">
            </div>
        </div>
    </div>
    <div class="page-header " style="height: 40px;">
        <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-left: 1rem;">
            <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">
                <h5><span class="font-weight-bold">Employee Detail Time Report</span></h5>
                <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
            </div>
        </div>
    </div>
    <div class="content">
        <div id="" class="card">
            <div class="card-body">
                <div class="form-group row">
                    <div style="padding-top: 10px;" class="col-lg-1.5">
                        <label style="font-weight: bold;">Employee:</label>
                    </div>
                    <div class="col-lg-3">
                        <select id="drpStaff" name="drpStaff" class="multiselect" multiple="multiple">
                        </select>
                    </div>
                    <div class="col-lg-1">
                        <label style="font-weight: bold; padding-top: 10px; float: right">From:</label>
                    </div>
                    <div class="col-lg-2">
                        <input type="date" style="width: 120px; float: left" class="form-control form-control-border" id="txtFromDate" name="txtFromDate" />
                    </div>
                    <div class="col-lg-1.5" style="padding-top: 10px;">
                        <asp:Label ID="Label1" runat="server" ForeColor="Black" Font-Bold="True">To:</asp:Label>
                    </div>
                    <div class="col-lg-2">
                        <input type="date" style="width: 120px;" class="form-control form-control-border" id="txtToDate" name="txtToDate" />
                    </div>

                    <div style="padding-top: 10px; padding-left: 15px;">
                        <button type="button" id="btnGenerateReport" style="float: left;" class="btn btn btn-success legitRipple">Generate Report</button>
                    </div>
                    <div style="padding-top: 10px; padding-left: 15px;">
                        <asp:Button ID="btnexcel" runat="server" OnClientClick="ExportAssignValues();" OnClick="btnexcel_Click"
                            class="btn btn-outline-success legitRipple"
                            Text="Export to XL"></asp:Button>
                    </div>
                </div>
            </div>
            <div class="card-body">
                <div class="table-responsive" style="height: 500px;">
                    <table id="tbl_StaffEffort" name="tbl_StaffEffort" class="table table-hover table-xs font-size-base"></table>
                </div>
                <table id="tblPager" style="border: 1px solid #BCBCBC; height: 50px; width: 100%; float: right">
                    <tr>
                        <td>
                            <div class="Pager">
                            </div>
                        </td>
                    </tr>
                </table>

            </div>
        </div>
    </div>
</asp:Content>
