<%@ Control Language="C#" AutoEventWireup="true" CodeFile="JobWiseClientGroupWiseStaffSummary.ascx.cs" Inherits="controls_JobwiseClientGroupwiseStaff_Summary" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit"
    TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl"
    TagPrefix="uc1" %>
<script language="javascript" type="text/javascript">
    var needstaff = false, needclientGrp = false, needjob = true;
    $(document).ready(function () {
        pageFiltersReset();

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
        ///////staff binding on date and timesheetstatus change
        $("[id*=txtstartdate1]").on("change", function () { pageFiltersReset(); });
        $("[id*=txtenddate2]").on("change", function () { pageFiltersReset(); });
        $("[id*=ddlStatus]").on("change", function () { pageFiltersReset(); });

        ////check all staff
        $("[id*=chkstaff]").on("click", function () {
            var check = $(this).attr('checked');
            if ($(".clstaff").length == 0)
            { return false; }
            $(".clstaff").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
        });

        ///////check all client Group
        $("[id*=chkClientGroup]").on("click", function () {
            if ($(".clclientGroup").length == 0)
            { return false; }
            var check = $(this).attr('checked');
            $(".clclientGroup").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
            needstaff = true, needclientGrp = false, needjob = false;
            $("[id*=hdnRtype]").val("clientGroup");
            BindPageLoadStaff();
        });

        /////////////check all job
        $("[id*=chkJob]").on("click", function () {
            if ($(".clJob").length == 0)
            { return false; }
            var check = $(this).attr('checked');
            $(".clJob").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
            needstaff = true, needclientGrp = true, needjob = false;
            $("[id*=hdnRtype]").val("Job");
            BindPageLoadStaff();
        });

    });
    ////functions
    function pad2(number) {
        return (number < 10 ? '0' : '') + number
    }

    function checkForm() {
        // regular expression to match required date format
        var dt = new Date();
        var day = dt.getDate();
        var mon = dt.getMonth() + 1;
        var yr = dt.getFullYear();
        var pin = document.getElementById("<%= txtstartdate1.ClientID%>").value;
            if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
                // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
            {

                alert("Invalid date format: " + pin);
                document.getElementById("<%= txtstartdate1.ClientID%>").focus();
            var days = pad2(day);
            var month = pad2(mon);
            document.getElementById("<%= txtstartdate1.ClientID%>").value = days + "/" + month + "/" + yr;
            return false;
        }
    }

    function checkForms() {
        // regular expression to match required date format
        var dt = new Date();
        var day = dt.getDate();
        var mon = dt.getMonth() + 1;
        var yr = dt.getFullYear();
        var pin = document.getElementById("<%= txtenddate2.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
            // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {

            alert("Invalid date format: " + pin);
            document.getElementById("<%= txtenddate2.ClientID%>").focus();
            var days = pad2(day);
            var month = pad2(mon);
            document.getElementById("<%= txtenddate2.ClientID%>").value = days + "/" + month + "/" + yr;
            return false;
        }
    }
    ////status check
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
        pageFiltersReset();
    }

    function BindPageLoadStaff() {
        GetAllSelected();

        if (needjob) {
            $("[id*=hdnselectedjobid]").val('Empty');
            $("[id*=hdnSelectedStaffCode]").val('');
        }
        if ($("[id*=txtstartdate1]").val() == "" || $("[id*=txtstartdate1]").val() == undefined) {
            return false;
        }
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                UserType: $("[id*=hdnUserType]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                StaffCode: $("[id*=hdnStaffCode]").val(),
                selectedstaffcode: $("[id*=hdnSelectedStaffCode]").val(),
                selectedclientgrpid: $("[id*=hdnselectedclientGrpid]").val(),
                selectedjobid: $("[id*=hdnselectedjobid]").val(),
                neetstaff: needstaff,
                neetclientgrp: needclientGrp,
                neetjob: needjob,
                FromDate: $("[id*=txtstartdate1]").val(),
                ToDate: $("[id*=txtenddate2]").val(),
                RType: $("[id*=hdnRtype]").val(),

            }
        };
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/WS_ClientGroup.asmx/bind_Job_ClientGroup_staff_Selected",
            data: JSON.stringify(data),
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {

            },
            error: function (response) {

            }
        });

    }
    //single click  job,cg, checked 
    function OnSuccess(response) {
        var obj = jQuery.parseJSON(response.d);
        console.log(obj);
        var tableRowsstaff = '', tableRowsclientGrp = '', tableRowsjob = '';
        var countstafff = 0, countclientGrp = 0, countjob = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "staff") {
                countstafff += 1;
                tableRowsstaff += "<tr><td><input type='checkbox' checked='checked' onclick='singlestaffcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }

            else if (vl.Type == "Job") {
                countjob += 1;
                tableRowsjob += "<tr><td><input type='checkbox'  onclick='singlejobcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }

            else if (vl.Type == "clientGroup") {
                countclientGrp += 1;
                tableRowsclientGrp += "<tr><td><input type='checkbox' onclick='singleclientGrpcheck()' checked='checked' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }

        });

        if (needjob) {
            $("[id*=chkJob]").removeAttr('checked');
            $("[id*=chkJob]").parent().find('label').text("Check All Job Name (Count : " + countjob + ")");
            $("[id*=Panel2]").html("<table>" + tableRowsjob + "</table>");
        }

        if (needclientGrp) {

            if (countclientGrp != 0)
                $("[id*=chkClientGroup]").attr('checked', 'checked');
            else
                $("[id*=chkClientGroup]").removeAttr('checked');

            $("[id*=chkClientGroup]").parent().find('label').text("Check All Client Group Name (Count : " + countclientGrp + ")");
            $("[id*=Panel3]").html("<table>" + tableRowsclientGrp + "</table>");
        }

        if (needstaff) {
            if (countstafff != 0)
                $("[id*=chkstaff]").attr('checked', 'checked');
            else
                $("[id*=chkstaff]").removeAttr('checked');


            $("[id*=chkstaff]").parent().find('label').text("Check All Staff Name (Count : " + countstafff + ")");
            $("[id*=Panel1]").html("<table>" + tableRowsstaff + "</table>");
        }

        GetAllSelected();
        $(".modalganesh").hide();
    }

    //////check single cg
    function singleclientGrpcheck() {
        if ($(".clclientGroup").length == $(".clclientGroup:checked").length)
        { $("[id*=chkClientGroup]").attr('checked', true); }
        else { $("[id*=chkClientGroup]").removeAttr('checked'); }
        needstaff = true, needclientGrp = false, needjob = false;
        $("[id*=hdnRtype]").val("clientGroup");
        BindPageLoadStaff();
    }

    //////check single project
    function singlejobcheck() {
        if ($(".clJob").length == $(".clJob:checked").length)
        { $("[id*=chkJob]").attr('checked', true); }
        else { $("[id*=chkJob]").removeAttr('checked'); }
        needstaff = true, needclientGrp = true, needjob = false;
        $("[id*=hdnRtype]").val("Job");
        BindPageLoadStaff();
    }


    function GetAllSelected() {
        var selectStaff = '', selectclientGrp = '', selectjob = '';
        $(".clclientGroup:checked").each(function () {
            selectclientGrp += $(this).val() + ',';
        });
        $(".clJob:checked").each(function () {
            selectjob += $(this).val() + ',';
        });
        $(".clstaff:checked").each(function () {
            selectStaff += $(this).val() + ',';
        });

        $("[id*=hdnSelectedStaffCode]").val(selectStaff);
        $("[id*=hdnselectedclientGrpid]").val(selectclientGrp);
        $("[id*=hdnselectedjobid]").val(selectjob);
    }


    function pageFiltersReset() {
        needstaff = false, needclientGrp = false, needjob = true;
        $("[id*=chkstaff]").removeAttr('checked');
        $("[id*=chkstaff]").parent().find('label').text("Check All Staff Name (Count : 0)");
        $("[id*=chkClientGroup]").removeAttr('checked');
        $("[id*=chkClientGroup]").parent().find('label').text("Check All Client Group Name (Count : 0)");
        $("[id*=chkJob]").removeAttr('checked');
        $("[id*=chkJob]").parent().find('label').text("Check All Job Name (Count : 0)");

        $("[id*=Panel1]").html('');
        $("[id*=Panel3]").html('');
        $("[id*=Panel2]").html('');
        BindPageLoadStaff();
    }
</script>
<div class="divstyle">
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="lbltittlename" runat="server" CssClass="Head1 labelChange" Text="Job Wise ClientGroup Wise Staff Summary Report"></asp:Label>
            <%--  <div style="float: right;">
                    <asp:Button ID="btnBack" runat="server" CssClass="TbleBtns" Text="Back" Visible="false"
                        OnClick="btnBack_Click" /></div>--%>
            <asp:HiddenField runat="server" ID="hdnCompid" />
            <asp:HiddenField runat="server" ID="hdnUserType" />
            <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="Empty" />
            <asp:HiddenField runat="server" ID="hdnselectedclientGrpid" />
            <asp:HiddenField runat="server" ID="hdnselectedjobid" />
            <asp:HiddenField runat="server" ID="hdnStaffCode" />
            <asp:HiddenField runat="server" ID="hdnClientgroup" />
            <asp:HiddenField runat="server" ID="hdnRtype" />
            <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
        </div>
    </div>
    <div id="div2" class="totbodycatreg" style="height: 700px;">
        <div style="width: 100%;">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
        </div>

        <div class="row_report" runat="server" id="divReportInput">
            <div>
                <table class="style1" style="padding-left: 55px; padding-top: 15px; width: 100%;">
                    <tr>
                        <td style="vertical-align: top;">
                            <table class="style1" width="1000px;">
                                <tr>
                                    <td valign="middle">
                                        <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center" valign="middle">:
                                    </td>
                                    <td valign="middle">
                                        <asp:TextBox ID="txtstartdate1" runat="server" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" />
                                        <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtstartdate1"
                                            PopupButtonID="Img1" Format="dd/MM/yyyy">
                                        </cc1:CalendarExtender>
                                    </td>
                                    <td valign="middle">
                                        <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center" valign="middle">:
                                    </td>
                                    <td valign="middle">
                                        <asp:TextBox ID="txtenddate2" runat="server" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Img2" runat="server" ImageUrl="~/images/calendar.png" />
                                        <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtenddate2"
                                            PopupButtonID="Img2" Format="dd/MM/yyyy">
                                        </cc1:CalendarExtender>
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
                                            <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()" Checked="true"
                                                ClientIDMode="Static" Text="Rejected" />
                                    </td>
                                    <td>
                                        <asp:Button Style="margin-top: -5px;" ID="btngen" runat="server" CssClass="TbleBtns"
                                            Text="Generate Report" OnClick="btngen_Click" /></td>
                                </tr>
                                <tr>
                                    <td colspan="6"></td>
                                    <td valign="middle">
                                        <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Report Type" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center" valign="middle">:
                                    </td>
                                    <td valign="middle">
                                        <asp:RadioButton runat="server" ID="rsummary" Text="Summarized" Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                                            <asp:RadioButton runat="server" ID="rdetailed" Text="Detailed" GroupName="rbtn" />&nbsp;
                                    </td>
                                    <td></td>
                                    <td width="60px;"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="20">
                            <table>
                                <tr>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkJob" runat="server" ForeColor="Black"
                                            Font-Bold="true" Height="20px" Text=" Check All Job Name (Count : 0)" CssClass="labelChange" />
                                        <div id="Panel2" style="border: 1px solid #B6D1FB; width: 95%; height: 400px; overflow: auto;">
                                        </div>
                                    </td>

                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkClientGroup" runat="server" ForeColor="Black" Font-Bold="true"
                                            Height="20px" Text=" Check All Client Group Name (Count : 0)" CssClass="labelChange" />
                                        <div id="Panel3" style="border: 1px solid #B6D1FB; width: 95%; height: 400px; overflow: auto;">
                                        </div>
                                    </td>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkstaff" runat="server" ForeColor="Black"
                                            Font-Bold="true" Height="20px" Text=" Check All Staff Name (Count : 0)" CssClass="labelChange" />
                                        <div id="Panel1" style="border: 1px solid #B6D1FB; width: 95%; height: 400px; overflow: auto;">
                                        </div>
                                    </td>

                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>

            </div>
        </div>

    </div>
</div>
