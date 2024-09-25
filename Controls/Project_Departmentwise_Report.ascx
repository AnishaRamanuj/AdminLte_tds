<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Project_Departmentwise_Report.ascx.cs"
    Inherits="controls_Project_Departmentwise_Report" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />

<script language="javascript" type="text/javascript">
    var needstaff = false, needProject = true, needDept = false;
    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        BindPageLoadStaff();
        Get_All_Staff_Client_Project_BranchName();
        $("[id*=hdnBrid]").val('0');
        ////tStatus chkall
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

        $("[id*=ddlBranch]").on("click", function () {
            var brid = $("[id*=ddlBranch]").val();
            $("[id*=hdnBrid]").val(brid)
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

        ///////check all Project
        $("[id*=chkProject]").on("click", function () {
            if ($(".clProject").length == 0)
            { return false; }
            var check = $(this).attr('checked');
            $(".clProject").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else {
                    $(this).removeAttr('checked');
                }
            });
            needstaff = true, needProject = false, needDept = true;
            BindPageLoadStaff();
        });

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
            needstaff = true, needProject = false, needDept = false;

            BindPageLoadStaff();
        });


    });

    function Get_All_Staff_Client_Project_BranchName() {
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Projectstaff.asmx/Get_All_Staff_Client_Project_BranchName",
            data: '{compid:' + $("[id*=hdnCompid]").val() + '}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length == 0) { }
                else {
                    if (myList == null) { }
                    else {
                        $("[id*=ddlBranch]").empty();
                        $("[id*=ddlBranch]").append("<option value=" + 0 + ">Select Branch</option>");
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

    function BindPageLoadStaff() {
        GetAllSelected();
        if (needProject)
        { $("[id*=hdnselectedProjectid]").val('Empty'); $("[id*=hdnSelectedStaffCode]").val(''); }
        if ($("[id*=txtstartdate1]").val() == "" || $("[id*=txtstartdate1]").val() == undefined)
        { return false; }
        $(".modalganesh").show
        var Branch = $("[id*=ddlBranch]").val();
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                selectedstaffcode: $("[id*=hdnSelectedStaffCode]").val(),
                selectedprojectid: $("[id*=hdnselectedProjectid]").val(),
                selectedDeptid: $("[id*=hdnselectedDeptid]").val(),
                needstaff: needstaff,
                needProject: needProject,
                needDept: needDept,
                FromDate: $("[id*=txtstartdate1]").val(),
                ToDate: $("[id*=txtenddate2]").val(),
                BrId: Branch,
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Project_Departmentwise_Report.asmx/Get_Project_Dept_Staff_All_Selected",
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
        var tableRowsstaff = '', tableRowsProject = '', tableRowsDept = '';
        var countstafff = 0, countProject = 0, countDept = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "Staff") {
                countstafff += 1;
                tableRowsstaff += "<tr><td><input type='checkbox' checked='checked' onclick='singlestaffcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "Project") {
                countProject += 1;
                tableRowsProject += "<tr><td><input type='checkbox'  onclick='singleprojectcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "Department") {
                countDept += 1;
                tableRowsDept += "<tr><td><input type='checkbox' onclick='singleDepartmentcheck()' checked='checked' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });

        if (needProject) {
            $("[id*=chkProject]").removeAttr('checked');
            $("[id*=chkProject]").parent().find('label').text("Project Name (" + countProject + ")");
            $("[id*=Panel2]").html("<table>" + tableRowsProject + "</table>");
        }
        if (needDept) {

            if (countDept != 0)
                $("[id*=chkDept]").attr('checked', 'checked');
            else
                $("[id*=chkDept]").removeAttr('checked');

            $("[id*=chkDept]").parent().find('label').text("Department Name( " + countDept + ")");
            $("[id*=Panel3]").html("<table>" + tableRowsDept + "</table>");
        }
        if (needstaff) {
            if (countstafff != 0)

                $("[id*=chkstaff]").attr('checked', 'checked');
            else
                $("[id*=chkstaff]").removeAttr('checked');


            $("[id*=chkstaff]").parent().find('label').text("Staff Name (" + countstafff + ")");
            $("[id*=Panel1]").html("<table>" + tableRowsstaff + "</table>");
        }
        $(".modalganesh").hide();
        GetAllSelected();
    }

    function GetAllSelected() {
        var selectStaff = '', selectProject = '', selectDept = '';
        $(".clStaff:checked").each(function () {
            selectStaff += $(this).val() + ',';
        });
        $(".clProject:checked").each(function () {
            selectProject += $(this).val() + ',';
        });
        $(".clDepartment:checked").each(function () {
            selectDept += $(this).val() + ',';
        });
        $("[id*=hdnSelectedStaffCode]").val(selectStaff);

        $("[id*=hdnselectedProjectid]").val(selectProject);

        $("[id*=hdnselectedDeptid]").val(selectDept);
    }

    //////check single Project
    function singleprojectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length)
        { $("[id*=chkProject]").attr('checked', true); }
        else { $("[id*=chkProject]").removeAttr('checked'); }
        needstaff = true, needProject = false, needDept = true;
        BindPageLoadStaff();
    }

    //////check single Department
    function singleDepartmentcheck() {
        if ($(".clDepartment").length == $(".clDepartment:checked").length)
        { $("[id*=chkDept]").attr('checked', true); }
        else { $("[id*=chkDept]").removeAttr('checked'); }
        needstaff = true, needProject = false, needDept = false;
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
        $("[id*=chkstaff]").parent().find('label').text("Staff Name (0)");
        $("[id*=chkProject]").removeAttr('checked');
        $("[id*=chkProject]").parent().find('label').text("Project Name (0)");
        $("[id*=chkDept]").removeAttr('checked');
        $("[id*=chkDept]").parent().find('label').text("Department Name (0)");

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
        <%--     <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="Label1" runat="server" CssClass="Head1 labelChange" Text="Project Billable Report"></asp:Label>
        </div>--%>
        <table style="width: 100%" class="cssPageTitle">
            <tr>
                <td class="cssPageTitle2">
                    <asp:Label ID="Label1" runat="server" Text="Project Billable Report" Style="margin-left: 50px;"></asp:Label>
                </td>
                <td style="float: right; padding-top: 5px; margin-left: 60px;">
                    <asp:Button Style="margin-top: 0;" ID="btngen" runat="server" CssClass="cssButton"
                        Text="Generate Report" OnClick="btngen_Click" />
                </td>

            </tr>
        </table>

        <div style="float: right;">
            <asp:Button ID="btnBack" runat="server" CssClass="TbleBtns" Text="Back"
                Visible="false" />
        </div>
        <asp:HiddenField runat="server" ID="hdnCompid" />
        <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="Empty" />
        <asp:HiddenField runat="server" ID="hdnselectedProjectid" />
        <asp:HiddenField runat="server" ID="hdnselectedDeptid" />
        <asp:HiddenField runat="server" ID="hdnStaffCode" />
        <asp:HiddenField runat="server" ID="hdnBrid" />
        <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
    </div>
    <div id="div2" class="totbodycatreg" style="height: 500px;">
        <div style="width: 100%;">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div class="row_report" runat="server" id="divReportInput">
            <div>
                <table class="style1" style="float: left; padding-left: 55px; padding-top: 15px;">
                    <tr>
                        <td style="vertical-align: top;">
                            <table class="style1" width="1000px">
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
                                        <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status"
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
                                        <asp:Label ID="lblBranch" Font-Bold="true" runat="server">Branch</asp:Label>
                                    </td>
                                    <td valign="middle" align="center">:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlBranch" CssClass="texboxcls" runat="server" Width="154px">
                                            <asp:ListItem Value="0" Text="Select Branch"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6"></td>

                                    <%--                                    <td valign="middle">
                                        <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Report Type"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center" valign="middle">
                                        :
                                    </td>
                                    <td valign="middle">
                                        <asp:RadioButton runat="server" ID="rsummary" Text="Summarized"
                                            Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                                        <asp:RadioButton runat="server" ID="rdetailed" Text="Detailed"
                                            GroupName="rbtn" />&nbsp;
                                    </td>--%>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="20">
                            <table>
                                <tr>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkProject" runat="server" ForeColor="Black"
                                            Font-Bold="true" Height="20px" Text="Project Name (0)" CssClass="labelChange" />
                                        <div id="Panel2" style="border: 1px solid #B6D1FB; width: 95%; height: 400px; overflow: auto;">
                                        </div>
                                    </td>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkDept" runat="server" ForeColor="Black" Font-Bold="true"
                                            Height="20px" Text="Department Name (0)" CssClass="labelChange" />
                                        <div id="Panel3" style="border: 1px solid #B6D1FB; width: 95%; height: 400px; overflow: auto;">
                                        </div>
                                    </td>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkstaff" runat="server" ForeColor="Black"
                                            Font-Bold="true" Height="20px" Text="Staff Name (0)" CssClass="labelChange" />
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
        <%--       <rsweb:ReportViewer ID="ReportViewer1" Height="100%" Width="1329px"
            Visible="false" runat="server" AsyncRendering="False" 
            InteractivityPostBackMode="AlwaysAsynchronous">
        </rsweb:ReportViewer>--%>
    </div>
</div>
