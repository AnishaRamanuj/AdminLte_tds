<%@ Control Language="C#" AutoEventWireup="true" CodeFile="All_Department_Job_Staff_Report.ascx.cs" Inherits="controls_All_Department_Job_Staff_Report" %>
<%--//////Register for reports messges and ajax tools--%>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"  Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<%--//////page created by Anil Gajre on 13/06/2018--%>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>
<script type="text/javascript">
    var Jobwise = true, staffwise = true;
    $(document).ready(function () {
        Get_Department_Client_Staff_Report_Departments();
        Get_Department_Job_Staff_Report_JobStaff();

        ///////////////get project Staff of selected department
        $("[id*=ddlDept]").on('change', function () {
            Jobwise = true, staffwise = true;
            Get_Department_Job_Staff_Report_JobStaff();
        });

        $("[id*=btnBack]").on("click", function () { $(".modalganesh").show(); });

        $("[id*=btngen]").on("click", function () {
            Get_All_Selected();
        });


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

        $("[id*=chkJob]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clJob").each(function () {
                    $(this).attr('checked', 'checked');
                });
            }
            else {
                $(".clJob:checked").each(function () {
                    $(this).removeAttr('checked');
                });
            }
            SingleProjectCheck();
            $('.modalganesh').css('display', 'none');
        });

        $("[id*=chkStaff]").on("click", function () {

            if ($(this).attr('checked')) {
                $(".clStaff").each(function () {
                    $(this).attr('checked', 'checked');
                });
            }
            else {
                $(".clStaff:checked").each(function () {
                    $(this).removeAttr('checked');
                });
            }

        });

    });




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

    }


    /////////////get department wise data

    function Get_Department_Job_Staff_Report_JobStaff() {
        Get_All_Selected();
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                StaffCode: $("[id*=hdnStaffCode]").val(),
                selectedJob: $("[id*=hdnselectedjobid]").val(),
                DeptId: $("[id*=ddlDept]").val(),
                Jobwise: Jobwise,
                staffwise: staffwise,
                fromdate: $("[id*=txtstartdate1]").val(),
                todate: $("[id*=txtenddate2]").val(),
                UserType: $("[id*=hdnUserType]").val()
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ws_All_Department_Client_Staff_Report.asmx/Get_Department_Job_Staff_Report_JobStaff",
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
        var tblProject = '', tblStaff = '';
        var countProject = 0, countStaff = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "Job") {
                countProject += 1;
                tblProject += "<tr><td><input type='checkbox' checked='checked' onclick='SingleProjectCheck()' class=cl" + vl.Type + " value='" + vl.Id + "'>" + vl.Name + "</td></tr>";

            }
            if (vl.Type == "Staff") {
                countStaff += 1;
                tblStaff += "<tr><td><input type='checkbox' checked='checked' class=cl" + vl.Type + " value='" + vl.Id + "'>" + vl.Name + "</td></tr>";

            }
        });
        if (Jobwise) {
            if (countProject != 0)
                $("[id*=chkJob]").attr('checked', 'checked');
            else
                $("[id*=chkJob]").removeAttr('checked');



            $("[id*=chkJob]").parent().find('label').text("Check All Project (Count : " + countProject + ")");
            $("[id*=PanelProject]").html("<table>" + tblProject + "</table>");

        }

        if (staffwise) {
            if (countStaff != 0)
                $("[id*=chkStaff]").attr('checked', 'checked');
            else
                $("[id*=chkStaff]").removeAttr('checked');

            $("[id*=chkStaff]").parent().find('label').text("Check All Staff (Count : " + countStaff + ")");
            $("[id*=Panelstaff]").html("<table>" + tblStaff + "</table>");
        }
    }


    //////////////////////on single project check

    function SingleProjectCheck() {
        if ($(".clJob").length == $(".clJob:checked").length)
        { $("[id*=chkJob]").attr('checked', true); }
        else { $("[id*=chkJob]").removeAttr('checked'); }
        Jobwise = false; staffwise = true;
        Get_Department_Job_Staff_Report_JobStaff();
    }


    ////////////////////////get all Project Staff data

    function Get_All_Selected() {
        var selectedProject = '', selectedStaff = '';
        $(".clJob:checked").each(function () {
            selectedProject += $(this).val() + ',';
        });
        $(".clStaff:checked").each(function () {
            selectedStaff += $(this).val() + ',';
        });
        $("[id*=hdnSelectedStaffCode]").val(selectedStaff);
        $("[id*=hdnselectedjobid]").val(selectedProject);
        var dep = $("[id*=ddlDept]");
        $("[id*=hdnDeptname]").val(dep.find("option:selected").text());
    }

    ////////////get departments names
    function Get_Department_Client_Staff_Report_Departments() {
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ws_All_Department_Client_Staff_Report.asmx/Get_Department_Client_Staff_Report_Departments",
            data: '{compid:' + $("[id*=hdnCompid]").val() + ',StaffCode:' + $("[id*=hdnStaffCode]").val() + '}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length == 0) { }
                else {
                    if (myList == null) { }
                    else {
                        $("[id*=ddlDept]").empty();
                        $("[id*=ddlDept]").append("<option value=" + 0 + ">Select Department</option>");
                        for (var i = 0; i < myList.length; i++) {
                            $("[id*=ddlDept]").append("<option value=" + myList[i].DeptId + ">" + myList[i].Department + "</option>");
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
</script>
<%--design part--%>
<div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
    <asp:Label ID="Label1" runat="server" Text="All  Department Project Staff" CssClass="Head1 labelChange"></asp:Label>
    <div style="float: right;">
        <asp:Button ID="btnBack" runat="server" CssClass="TbleBtns" Text="Back" Visible="false" OnClick="btnBack_Click" />
    </div>
    <asp:HiddenField runat="server" ID="hdndeptwise" />
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnUserType" />
    <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="Empty" />
    <asp:HiddenField runat="server" ID="hdnselectedclientid" />
    <asp:HiddenField runat="server" ID="hdnselectedjobid" />
    <asp:HiddenField runat="server" ID="hdnselectedprojectid" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
    <asp:HiddenField runat="server" ID="hdnselecteddept" />
    <asp:HiddenField runat="server" ID="hdntype" />
    <asp:HiddenField runat="server" ID="hdnbranch" Value="0" />
    <asp:HiddenField runat="server" ID="hdnDeptname" Value="0" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
</div>
<div class="divstyle">
    <div id="div2" class="totbodycatreg" style="height: auto;">
        <div style="width: 100%;">
            <uc2:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div class="row_report" runat="server" id="divReportInput">
            <table class="style1" style="padding-left: 25px; padding-top: 20px;">
                <tr>
                    <td valign="middle">
                        <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From" Font-Bold="True"></asp:Label>
                    </td>
                    <td align="center" valign="middle">
                        :
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
                    <td align="center" valign="middle">
                        :
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
                    <td valign="middle" align="center">
                        :
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
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblDept" CssClass="labelChange" Font-Bold="true" runat="server">Department</asp:Label>
                    </td>
                    <td>
                        :
                    </td>
                    <td colspan="4">
                        <asp:DropDownList ID="ddlDept" runat="server" CssClass="texboxcls" Width="250px">
                            <asp:ListItem Value="0" Text="Select Department"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:Button Style="margin-top: 0;" ID="btngen" runat="server" CssClass="TbleBtns"
                            Text="Generate Report" onclick="btngen_Click" />
                    </td>
                </tr>
            </table>
            <table>
                <tr>
                    <td id="tddept" runat="server" style="width: 380px;">
                        <asp:CheckBox ID="chkJob" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                            Text=" Check All Jobs (Count : 0)" CssClass="labelChange" />
                        <div id="PanelProject" style="border: 1px solid #B6D1FB; width: 95%; height: 450px;
                            overflow: auto;">
                        </div>
                    </td>
                    <td style="width: 380px;">
                        <asp:CheckBox ID="chkStaff" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                            Text=" Check All Staff (Count : 0)" CssClass="labelChange" />
                        <div id="Panelstaff" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <rsweb:ReportViewer ID="ReportViewer1" Width="1144px" SizeToReportContent="true"
            Visible="false" runat="server" AsyncRendering="False" InteractivityPostBackMode="AlwaysAsynchronous">
        </rsweb:ReportViewer>
    </div>
</div>