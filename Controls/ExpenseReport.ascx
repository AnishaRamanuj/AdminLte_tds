<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ExpenseReport.ascx.cs" Inherits="controls_ExpenseReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        Get_BranchName_Project_Job_Staff();
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
        $("[id*=txtstartdate1]").on("change", function () {
            Onpagefilterloads();
        });
        $("[id*=txtenddate2]").on("change", function () {
            Onpagefilterloads();
        });
        Get_BranchName_Project_Job_Staff();

        Onpagefilterloads();
        ///////barnch change project selected
        $("[id*=ddlBranch]").on('change', function () {
            //Onpagefilterloads();
            var ddl = document.getElementById("<%=ddlBranch.ClientID%>");
            $("[id*=hdnbranch]").val(ddl.options[ddl.selectedIndex].text);
            $("[id*=hdnBrId]").val($("[id*=ddlBranch]").val());
            OnpageProjectload();
        });

        $("[id*=btnImgLast]").on("click", function () {
            OnpageProjectload();
        });

     <%--  $("[id*=btngen]").on("click", function () {
            var selectproject = '';
            $(".clProject:checked").each(function () {
                selectproject += $(this).val() + ',';
            });
            $("[id*=hdnselectedprojectid]").val(selectproject);
            GetAllSelected();
            $("[id*=hdntype]").val($("[id*=ddlType]").val());
            var ddl = document.getElementById("<%=ddlBranch.ClientID%>");
            $("[id*=hdnbranch]").val(ddl.options[ddl.selectedIndex].text);
            $("[id*=hdnBrId]").val($("[id*=ddlBranch]").val());
        });--%>

        $("[id*=chkproject]").on("click", function () {
            if ($(".clProject").length == 0)
            { return false; }
            var check = $(this).attr('checked');
            $(".clProject").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
            projectwise = false, jobwise = true, staffwise = true;
            $("[id*=hdnRtype]").val("Project");
            OnpageProjectload();
        });

        $("[id*=chkjob]").on("click", function () {
            if ($(".cljob").length == 0)
            { return false; }
            var check = $(this).attr('checked');
            $(".cljob").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
            projectwise = false, jobwise = false, staffwise = true;
            $("[id*=hdnRtype]").val("job");
            OnpageProjectload();
        });

        $("[id*=chkstaff]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clstaff").each(function () {
                    $(this).attr('checked', 'checked');
                });

            }
            else {
                $(".clstaff:checked").each(function () {
                    $(this).removeAttr('checked');
                });
            }
            $('.modalganesh').css('display', 'none');

        });
    });




    <%--Function--%>
    function Get_BranchName_Project_Job_Staff() {
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Ws_Expense.asmx/Get_All_Project_Job_Staff_BranchName",
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
        $(".cljob:checked").each(function () {
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

    function singleprojectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length)
        { $("[id*=chkproject]").attr('checked', true); }
        else { $("[id*=chkproject]").removeAttr('checked'); }
        staffwise = true, projectwise = false, jobwise = true;
        $("[id*=hdnRtype]").val("Project");
        OnpageProjectload();
    }

    function singlejobcheck() {
        if ($(".cljob").length == $(".cljob:checked").length)
        { $("[id*=chkjob]").attr('checked', true); }
        else { $("[id*=chkjob]").removeAttr('checked'); }
        staffwise = true, projectwise = false, jobwise = false;
        $("[id*=hdnRtype]").val("job");
        OnpageProjectload();
    }
    var projectwise = false, jobwise = false, staffwise = true;
    function Onpagefilterloads() {
        projectwise = true, jobwise = false, staffwise = false;

        $("[id*=chkproject]").removeAttr('checked');
        $("[id*=chkproject]").parent().find('label').text("Project (0)");
        $("[id*=chkjob]").removeAttr('checked');
        $("[id*=chkjob]").parent().find('label').text("Job (0)");
        $("[id*=chkstaff]").removeAttr('checked');
        $("[id*=chkstaff]").parent().find('label').text("Staff (0)");
        OnpageProjectload();
    }

    function OnpageProjectload() {
        GetAllSelected();
        if (projectwise) {
            $("[id*=hdnselectedmjobid]").val('');
            $("[id*=hdnselectedprojectid]").val('Empty');
        }
        var compid = parseFloat($("[id*=hdnCompid]").val());
        var projectid = $("[id*=hdnselectedprojectid]").val();
        var jobid = $("[id*=hdnselectedmjobid]").val();
        var selectedstaffcode = $("[id*=hdnselectedstaff]").val();
        if ($("[id*=txtstartdate1]").val() == "" || $("[id*=txtstartdate1]").val() == undefined) {
            return false;
        }
        if ($("[id*=txtenddate2]").val() == "" || $("[id*=txtenddate2]").val() == undefined) {
            return false;
        }

        $(".modalganesh").show();

        var data = {
            currobj: {
                compid: compid,
                UserType: $("[id*=hdnUserType]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                StaffCode: $("[id*=hdnStaffCode]").val(),
                selectedstaffcode: selectedstaffcode,
                selectedprojectid: projectid,
                selectedjobid: jobid,
                staffwise: staffwise,
                projectwise: projectwise,
                jobwise: jobwise,
                fromdate: $("[id*=txtstartdate1]").val(),
                todate: $("[id*=txtenddate2]").val(),
                RType: $("[id*=hdnRptType]").val(),
                BrId: $("[id*=ddlBranch]").val()
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Ws_Expense.asmx/Get_Projectwise_Job_StaffAll_Selected",
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
            if (vl.Type == "Project") {
                countproject += 1;
                tableRowsproject += "<tr><td><input type='checkbox'  onclick='singleprojectcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "job") {
                countjob += 1;
                tableRowsjob += "<tr><td><input type='checkbox' checked='checked'  onclick='singlejobcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "staff") {
                countstafff += 1;
                tableRowsstaff += "<tr><td><input type='checkbox'  checked='checked' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });
        if (jobwise) {
            if (countjob != 0)
                $("[id*=chkjob]").attr('checked', 'checked');
            else
                $("[id*=chkjob]").removeAttr('checked');

            $("[id*=chkjob]").parent().find('label').text("Job (" + countjob + ")");
            $("[id*=Paneljb]").html("<table>" + tableRowsjob + "</table>");
        }
        if (staffwise) {

            if (countstafff != 0)
                $("[id*=chkstaff]").attr('checked', 'checked');
            else
                $("[id*=chkstaff]").removeAttr('checked');

            $("[id*=chkstaff]").parent().find('label').text("Staff (" + countstafff + ")");
            $("[id*=Panelstaff]").html("<table>" + tableRowsstaff + "</table>");
        }
        if (projectwise) {

            $("[id*=chkproject]").removeAttr('checked');
            $("[id*=chkproject]").parent().find('label').text("Project (" + countproject + ")");
            $("[id*=Panelprj]").html("<table>" + tableRowsproject + "</table>");
        }

        $(".modalganesh").hide();
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
<%--design part--%>
<div>

    <table class="cssPageTitle" style="width: 100%;">
        <tr>
            <td class="cssPageTitle2">
                <asp:Label ID="lblname" runat="server" Text="Project Expense" Style="margin-left: 20px;"></asp:Label>
            </td>
            <td style="float: right; padding-top: 5px; margin-left: 60px;">
                <asp:ImageButton ID="btnImgLast" ToolTip="Export To Excel"
                    runat="server" ImageUrl="~/images/xls-icon.png" OnClick="btnImgLast_Click" />
            </td>
        </tr>
    </table>   
    <asp:HiddenField runat="server" ID="hdndeptwise" />
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnUserType" />
    <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="Empty" />
    <asp:HiddenField runat="server" ID="hdnselectedprojectid" />
    <asp:HiddenField runat="server" ID="hdnselectedmjobid" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
    <asp:HiddenField runat="server" ID="hdnselectedstaff" />
    <asp:HiddenField runat="server" ID="hdntype" />
    <asp:HiddenField runat="server" ID="hdnbranch" />
    <asp:HiddenField runat="server" ID="hdnBrId" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
</div>
<div class="divstyle">
    <div id="div2" class="totbodycatreg" style="height: auto;">
        <div style="width: 100%;">
            <uc2:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div class="row_report" runat="server" id="divReportInput">
            <div>
                <table class="style1" style="padding-left: 25px; padding-top: 20px;">
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
                                            <asp:ListItem Value="0" Text="Select Branch"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td valign="middle">
                                        <asp:Label ID="Label11" runat="server" ForeColor="Black" Style="text-align: right" Text="From" Font-Bold="True"></asp:Label>
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
                                       
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 5px;"></td>
                                </tr>
                                <tr>

                                    <td valign="middle">
                                        <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Report Type" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center" valign="middle">:
                                    </td>
                                    <td valign="middle">
                                        <asp:RadioButton runat="server" ID="rsummary" Text="Summary" Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                                            <asp:RadioButton runat="server" ID="rdetailed" Text="Detailed" GroupName="rbtn" />&nbsp;
                                    </td>
                                    <%-- <td colspan="3">
                                        <asp:Button Style="margin-top: 0;" ID="btngen" runat="server" CssClass="TbleBtns"
                                            Text="Generate Report" OnClick="btngen_Click" />
                                    </td>--%>
                                    <%-- <td>
                                        <asp:ImageButton ID="btnImgLast" ToolTip="Export To Excel"
                                            runat="server" ImageUrl="~/images/xls-icon.png" OnClick="btnImgLast_Click" />
                                    </td>--%>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="20">
                            <table>
                                <tr>
                                    <td id="tdproject" runat="server" style="width: 380px;">
                                        <asp:CheckBox ID="chkproject" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                            Text="Project (0)" CssClass="labelChange" />
                                        <div id="Panelprj" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                        </div>
                                    </td>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkjob" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                            Text="Job (0)" CssClass="labelChange" />
                                        <div id="Paneljb" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                        </div>
                                    </td>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkstaff" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                            Text="Staff (0)" CssClass="labelChange" />
                                        <div id="Panelstaff" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
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
