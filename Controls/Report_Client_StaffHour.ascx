<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Report_Client_StaffHour.ascx.cs"
    Inherits="controls_Report_Client_StaffHour" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>

<script language="javascript" type="text/javascript">
    var needstaff = false, needClient = true;
    $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
    $(document).ready(function () {
        pageFiltersReset();

        $("[id*=txtstartdate1]").on("change", function () {
            pageFiltersReset();
        });
        $("[id*=txtenddate2]").on("change", function () {
            pageFiltersReset();
        });

        ////check all staff
        $("[id*=chkstaff]").on("click", function () {
            var check = $(this).attr('checked');
            if ($(".clStaff").length == 0)
            { return false; }
            $(".clStaff").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });

            $("[id*=chkTStatusAll]").on("click", function () {
                if ($(this).attr('checked')) {
                    $("[id*=chkSubmitted]").attr('checked', 'checked');
                    $("[id*=chkSaved]").attr('checked', 'checked');
                    $("[id*=chkApproved]").attr('checked', 'checked');
                }
                else {
                    $("[id*=chkSubmitted]").removeAttr('checked');
                    $("[id*=chkSaved]").removeAttr('checked');
                    $("[id*=chkApproved]").removeAttr('checked');
                }
                TStatusCheck();
            });

        });


        ////check all Client
        $("[id*=chkClient]").on("click", function () {
            var check = $(this).attr('checked');
            if ($(".clClient").length == 0)
            { return false; }
            $(".clClient").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
            needstaff = true, needClient = false;
            BindPageLoadStaff();
        });


    });

    function BindPageLoadStaff() {
        GetAllSelected();
        if ($("[id*=txtstartdate1]").val() == "" || $("[id*=txtstartdate1]").val() == undefined)
        { return false; }
        $(".modalganesh").show
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                Fromdate: $("[id*=txtstartdate1]").val(),
                Todate: $("[id*=txtenddate2]").val(),
                selectedJobidCode: $("[id*=hdnselectedJobid]").val(),
                needClient: needClient,
                needstaff: needstaff,
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Report_Staff_ProjectwiseHours.asmx/Get_Client_Staff",
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
        var tableRowsstaff = '', tableRowsClient = '';
        var countstafff = 0, countClient = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "Staff") {
                countstafff += 1;
                tableRowsstaff += "<tr><td><input type='checkbox' checked='checked' onclick='singlestaffcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "Client") {
                countClient += 1;
                tableRowsClient += "<tr><td><input type='checkbox'  onclick='singleClientcheck()'  class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });
        if (needClient) {
            $("[id*=chkClient]").removeAttr('checked');
            $("[id*=chkClient]").parent().find('label').text("Client(" + countClient + ")");
            $("[id*=Panel2]").html("<table>" + tableRowsClient + "</table>");
        }
        if (needstaff) {
            if (needstaff != 0)

                $("[id*=chkstaff]").attr('checked', 'checked');
            else
                $("[id*=chkstaff]").removeAttr('checked');


            $("[id*=chkstaff]").parent().find('label').text("Staff (" + countstafff + ")");
            $("[id*=Panel3]").html("<table>" + tableRowsstaff + "</table>");
        }
        $(".modalganesh").hide();
        GetAllSelected();
    }

    function GetAllSelected() {
        var selectStaff = '', selectClient = '';
        $(".clStaff:checked").each(function () {
            selectStaff += $(this).val() + ',';
        });
        $(".clClient:checked").each(function () {
            selectClient += $(this).val() + ',';
        });
        $("[id*=hdnSelectedStaffCode]").val(selectStaff);

        $("[id*=hdnselectedJobid]").val(selectClient);
    }

    function singleClientcheck() {
        if ($(".clClient").length == $(".clClient:checked").length)
        { $("[id*=chkchkClient]").attr('checked', true); }
        else { $("[id*=chkchkClient]").removeAttr('checked'); }
        needstaff = true, needClient = false;
        BindPageLoadStaff();
    }

    //////check single Staff
    function singlestaffcheck() {
        if ($(".clStaff").length == $(".clStaff:checked").length)
        { $("[id*=chkstaff]").attr('checked', true); }
        else { $("[id*=chkstaff]").removeAttr('checked'); }

    }

    function pageFiltersReset() {
        needstaff = false, needClient = true;
        $("[id*=chkstaff]").removeAttr('checked');
        $("[id*=chkstaff]").parent().find('label').text("Staff (Count : 0)");
        $("[id*=chkClient]").removeAttr('checked');
        $("[id*=chkClient]").parent().find('label').text("Client (Count : 0)");

        $("[id*=Panel2]").html('');
        $("[id*=Panel3]").html('');
        BindPageLoadStaff();
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
</script>
<style type="text/css">
    button {
        background-color: #6BBE92;
        width: 302px;
        border: 0;
        padding: 10px 0;
        margin: 5px 0;
        text-align: center;
        color: #fff;
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
<div class="divstyle">
    <div class="headerpage">
        <div>
            <table class="cssPageTitle" style="width: 100%;">
                <tr>
                    <td class="cssPageTitle2">
                        <asp:Label ID="lblname" runat="server" Text="Client Staffwise Hours" Style="margin-left: 10px;"></asp:Label>
                    </td>
                    <td style="float: right; padding-top: 5px; margin-left: 60px;">
                        <asp:Button ID="btngen" runat="server" OnClick="btngen_Click" CssClass="cssButton"
                            Text="Generate Report" />
                    </td>
                </tr>
            </table>


            <asp:HiddenField runat="server" ID="hdnCompid" />
            <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="Empty" />
            <asp:HiddenField runat="server" ID="hdnselectedJobid" />
            <asp:HiddenField runat="server" ID="hdnBrid" />
            <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved" />
        </div>
    </div>

    <div id="div2" class="totbodycatreg" style="height: 500px;">
        <div style="width: 100%;">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div class="row_report" runat="server" id="divReportInput">
            <div>
                <table class="style1" style="float: left; padding-left: 10px; padding-top: 15px;">
                    <tr>
                        <td style="vertical-align: top;">
                            <table class="style1" width="100%">
                                <tr>
                                    <td valign="middle">
                                        <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center" valign="middle">:
                                    </td>
                                    <td valign="middle">
                                        <asp:TextBox ID="txtstartdate1" runat="server" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" />
                                        <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle"
                                            ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtstartdate1"
                                            PopupButtonID="Img1" Format="dd/MM/yyyy">
                                        </cc1:CalendarExtender>
                                    </td>
                                    <td valign="middle">
                                        <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center" valign="middle">:
                                    </td>
                                    <td valign="middle">
                                        <asp:TextBox ID="txtenddate2" runat="server" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Img2" runat="server" ImageUrl="~/images/calendar.png" />
                                        <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle"
                                            ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtenddate2"
                                            PopupButtonID="Img2" Format="dd/MM/yyyy">
                                        </cc1:CalendarExtender>
                                    </td>                                   
                                    <td valign="middle">
                                        <asp:Label ID="Label6" style="margin-left:30px;" runat="server" ForeColor="Black" Text="Timesheet Status"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td valign="middle" align="center">:
                                    </td>
                                    <td valign="middle" colspan="3">
                                        <asp:CheckBox ID="chkTStatusAll" ClientIDMode="Static" runat="server" Checked="true"
                                            Text="All" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server" Checked="true"
                                            onclick="TStatusCheck()" Text="Submitted" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static" Checked="true"
                                            onclick="TStatusCheck()" Text="Saved" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()" Checked="true"
                                            ClientIDMode="Static" Text="Approved" />&nbsp;&nbsp;                           
                                    </td>                                    
                                    <td>
                                        <asp:Label ID="Label2" style="margin-left:50px;" runat="server" ForeColor="Black" Text="Report Type" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td valign="middle" align="center">:
                                    </td>
                                    <td valign="middle">
                                        <asp:RadioButton runat="server" ID="rsummary" Text="Summary" Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                                            <asp:RadioButton runat="server" ID="rdetailed" Text="Detailed" GroupName="rbtn" />&nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="20">
                            <table align="center">
                                <tr>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkClient" runat="server" ForeColor="Black"
                                            Font-Bold="true" Height="20px" Text="Client (0)" CssClass="labelChange" />
                                        <div id="Panel2" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                        </div>
                                    </td>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkstaff" runat="server" ForeColor="Black"
                                            Font-Bold="true" Height="20px" Text="Staff (0)" CssClass="labelChange" />
                                        <div id="Panel3" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
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

