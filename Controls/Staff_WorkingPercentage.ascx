<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Staff_WorkingPercentage.ascx.cs" Inherits="controls_Staff_WorkingPercentage" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />


<script language="javascript" type="text/javascript">
    var needstaff = false, needDept = true;
    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        BindPageLoadStaff();

        /////////////check all Department
        $("[id*=chkDept]").on("click", function () {
            if ($(".clDepartment").length == 0)
            { return false; }
            var check = $(this).attr('checked');
            $(".clDepartment").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else {
                    $(this).removeAttr('checked');
                }
            });
            needstaff = true, needDept = false;

            BindPageLoadStaff();
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
        });

    });

    function BindPageLoadStaff() {
        GetAllSelected();

        if ($("[id*=txtFromdate]").val() == "" || $("[id*=txtFromdate]").val() == undefined)
        { return false; }
        $(".modalganesh").show
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                selectedDeptid: $("[id*=hdnselectedDeptid]").val(),
                needstaff: needstaff,
                needDept: needDept,
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Staff_WorkingPercentage_Report.asmx/Get_Dept_Staff_All_Selected",
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
        var tableRowsstaff = '', tableRowsDept = '';
        var countstafff = 0, countDept = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "Staff") {
                countstafff += 1;
                tableRowsstaff += "<tr><td><input type='checkbox' checked='checked' onclick='singlestaffcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }

            else if (vl.Type == "Department") {
                countDept += 1;
                tableRowsDept += "<tr><td><input type='checkbox' onclick='singleDepartmentcheck()'  class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });


        if (needDept) {
            $("[id*=chkDept]").removeAttr('checked');
            $("[id*=chkDept]").parent().find('label').text("Check All Department Name (Count : " + countDept + ")");
            $("[id*=Panel2]").html("<table>" + tableRowsDept + "</table>");
        }
        if (needstaff) {
            if (countstafff != 0)

                $("[id*=chkstaff]").attr('checked', 'checked');
            else
                $("[id*=chkstaff]").removeAttr('checked');


            $("[id*=chkstaff]").parent().find('label').text("Check All Staff Name (Count : " + countstafff + ")");
            $("[id*=Panel3]").html("<table>" + tableRowsstaff + "</table>");
        }
        $(".modalganesh").hide();
        GetAllSelected();
    }


    function GetAllSelected() {
        var selectStaff = '', selectProject = '', selectDept = '';
        $(".clStaff:checked").each(function () {
            selectStaff += $(this).val() + ',';
        });
        $(".clDepartment:checked").each(function () {
            selectDept += $(this).val() + ',';
        });
        $("[id*=hdnSelectedStaffCode]").val(selectStaff);

        $("[id*=hdnselectedDeptid]").val(selectDept);
    }

    function singleDepartmentcheck() {
        if ($(".clDepartment").length == $(".clDepartment:checked").length)
        { $("[id*=chkDept]").attr('checked', true); }
        else { $("[id*=chkDept]").removeAttr('checked'); }
        needstaff = true, needDept = false;
        BindPageLoadStaff();
    }
    //////check single Staff
    function singlestaffcheck() {
        if ($(".clStaff").length == $(".clStaff:checked").length)
        { $("[id*=chkstaff]").attr('checked', true); }
        else { $("[id*=chkstaff]").removeAttr('checked'); }
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
        pageFiltersReset();
    }

    function pageFiltersReset() {
        needstaff = false, needclient = true, needjob = false;
        $("[id*=chkstaff]").removeAttr('checked');
        $("[id*=chkstaff]").parent().find('label').text("Check All Staff Name (Count : 0)");
        $("[id*=chkDept]").removeAttr('checked');
        $("[id*=chkDept]").parent().find('label').text("Check All Department Name (Count : 0)");

        $("[id*=Panel1]").html('');
        $("[id*=Panel2]").html('');
        $("[id*=Panel3]").html('');
        BindPageLoadStaff();
    }

</script>
<style type="text/css">
    .cssPageTitle {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        border-bottom: 2px solid #0b9322;
        padding: 7px;
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
</style>

<div class="divstyle">
    <div class="headerpage">
        <div>
            <table style="width: 100%" class="cssPageTitle">
                <tr>
                    <td class="cssPageTitle2">
                        <asp:Label ID="Label3" runat="server" Style="margin-left: 0px;" Text="Resource Allocation"></asp:Label>
                    </td>
                    <td style="float: right; padding-top: 5px; margin-left: 60px;">
                        <asp:Button ID="btngenexp" runat="server"
                            CssClass="cssButton" Text="Generate Report" OnClick="btngen_Click" />
                    </td>
                </tr>
            </table>

            <asp:HiddenField runat="server" ID="hdnCompid" />
            <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="Empty" />
            <asp:HiddenField runat="server" ID="hdnselectedDeptid" />

        </div>
        <div style="width: 100%;">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
        </div>
    </div>
    <table width="100%" runat="server" id="tbl1">
        <tr>
            <td>
                <div style="overflow: hidden; width: 100%;">
                    <div style="float: right; width: 70%">
                        <table>

                            <tr>
                                <td style="width: 380px;">
                                    <asp:CheckBox ID="chkDept" runat="server" ForeColor="Black"
                                        Font-Bold="true" Height="20px" Text=" Check All Department Name (Count : 0)" CssClass="labelChange" />
                                    <div id="Panel2" style="border: 1px solid #B6D1FB; width: 95%; height: 400px; overflow: auto;">
                                    </div>
                                </td>
                                <td style="width: 380px;">
                                    <asp:CheckBox ID="chkstaff" runat="server" ForeColor="Black"
                                        Font-Bold="true" Height="20px" Text=" Check All Staff Name (Count : 0)" CssClass="labelChange" />
                                    <div id="Panel3" style="border: 1px solid #B6D1FB; width: 95%; height: 400px; overflow: auto;">
                                    </div>
                                </td>
                            </tr>

                        </table>
                    </div>
                    <div style="float: left; width: 30%">
                        <table>
                            <tr>
                                <td>&nbsp;&nbsp;<b>From</b> 
                                </td>
                                <td>
                                    <asp:TextBox ID="txtFromdate" runat="server" Width="70px" CssClass="texboxcls"></asp:TextBox>
                                    <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" />
                                    <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
                                    <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtFromdate"
                                        PopupButtonID="Img1" Format="dd/MM/yyyy">
                                    </cc1:CalendarExtender>
                                </td>
                                <td>&nbsp;&nbsp; <b>To</b>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtToDate" runat="server" Width="70px" CssClass="texboxcls"></asp:TextBox>
                                    <asp:Image ID="Img2" runat="server" ImageUrl="~/images/calendar.png" />
                                    <asp:Label ID="Label2" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
                                    <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtToDate"
                                        PopupButtonID="Img2" Format="dd/MM/yyyy">
                                    </cc1:CalendarExtender>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </td>
        </tr>
    </table>
</div>
