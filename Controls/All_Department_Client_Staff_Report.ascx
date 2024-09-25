<%@ Control Language="C#" AutoEventWireup="true" CodeFile="All_Department_Client_Staff_Report.ascx.cs"
    Inherits="controls_All_Department_Client_Staff_Report" %>
<%--//////Register for reports messges and ajax tools--%>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<%--//////page created by Anil Gajre on 13/06/2018--%>
<%--<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>--%>
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
    var Projectwise = true, staffwise = true;
    $(document).ready(function () {
        Get_Department_Client_Staff_Report_Departments();

        Get_Department_Client_Staff_Report_ProjectStaff();

        ///////////////get project Staff of selected department
        $("[id*=ddlDept]").on('change', function () {
            Projectwise = true, staffwise = true;
            Get_Department_Client_Staff_Report_ProjectStaff();
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

        $("[id*=chkProject]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clProject").each(function () {
                    $(this).attr('checked', 'checked');
                });
            }
            else {
                $(".clProject:checked").each(function () {
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

    function Get_Department_Client_Staff_Report_ProjectStaff() {
        Get_All_Selected();
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                //StaffCode: $("[id*=hdnStaffCode]").val(),
                selectedProject: $("[id*=hdnselectedProjectid]").val(),
                DeptId: $("[id*=ddlDept]").val(),
                Projectwise: Projectwise,
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
            url: "../Handler/ws_All_Department_Client_Staff_Report.asmx/Get_Department_Client_Staff_Report_ProjectStaff",
            data: JSON.stringify(data),
            dataType: 'json',
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
            if (vl.Type == "Project") {
                countProject += 1;
                tblProject += "<tr><td><input type='checkbox' checked='checked' onclick='SingleProjectCheck()' class=cl" + vl.Type + " value='" + vl.Id + "'>" + vl.Name + "</td></tr>";

            }
            if (vl.Type == "Staff") {
                countStaff += 1;
                tblStaff += "<tr><td><input type='checkbox' checked='checked' class=cl" + vl.Type + " value='" + vl.Id + "'>" + vl.Name + "</td></tr>";

            }
        });
        if (Projectwise) {
            if (countProject != 0)
                $("[id*=chkProject]").attr('checked', 'checked');
            else
                $("[id*=chkProject]").removeAttr('checked');



            $("[id*=chkProject]").parent().find('label').text("Check All Project (Count : " + countProject + ")");
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
        if ($(".clProject").length == $(".clProject:checked").length)
        { $("[id*=chkProject]").attr('checked', true); }
        else { $("[id*=chkProject]").removeAttr('checked'); }
        Projectwise = false; staffwise = true;
        Get_Department_Client_Staff_Report_ProjectStaff();
    }


    ////////////////////////get all Project Staff data

    function Get_All_Selected() {
        var selectedProject = '', selectedStaff = '';
        $(".clProject:checked").each(function () {
            selectedProject += $(this).val() + ',';
        });
        $(".clStaff:checked").each(function () {
            selectedStaff += $(this).val() + ',';
        });
        $("[id*=hdnSelectedStaffCode]").val(selectedStaff);
        $("[id*=hdnselectedProjectid]").val(selectedProject);
        var dep = $("[id*=ddlDept]");
        $("[id*=hdnDeptname]").val(dep.find("option:selected").text());
    }

    ////////////get departments names
    function Get_Department_Client_Staff_Report_Departments() {
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json",
            url: "../Handler/ws_All_Department_Client_Staff_Report.asmx/Get_Department_Client_Staff_Report_Departments",
            data: '{compid:' + $("[id*=hdnCompid]").val() + '}',
            dataType: 'json',
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
<div class="page-content">
    <asp:HiddenField runat="server" ID="hdndeptwise" />
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnUserType" />
    <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="Empty" />
    <asp:HiddenField runat="server" ID="hdnselectedclientid" />
    <asp:HiddenField runat="server" ID="hdnselectedJobid" />
    <asp:HiddenField runat="server" ID="hdnselectedProjectid" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
    <asp:HiddenField runat="server" ID="hdnselecteddept" />
    <asp:HiddenField runat="server" ID="hdntype" />
    <asp:HiddenField runat="server" ID="hdnbranch" Value="0" />
    <asp:HiddenField runat="server" ID="hdnDeptname" Value="0" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
            </div>
        </div>
    </div>
    <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-bottom: 1rem;">
        <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">
            <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">All  Department Project Staff</span></h5>
            <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
        </div>
        <div style="float: right;">
            <asp:Button ID="btnBack" runat="server" CssClass="btn btn-outline-success legitRipple" Text="Back" Visible="false" OnClick="btnBack_Click" />
        </div>
    </div>
</div>
<div class="content">
    <div class="divstyle card">
        <div id="div2" class="totbodycatreg" style="height: auto;">
            <div style="width: 100%;">
                <uc2:MessageControl ID="MessageControl1" runat="server" />
            </div>
            <div class="row_report" runat="server" id="divReportInput">
                <div class="card-body">
                    <table class="style1" style="padding-left: 25px; padding-top: 20px;">
                        <tr>
                            <td valign="middle">
                                <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From" Font-Bold="True"></asp:Label>
                            </td>
                            <td valign="center" valign="middle">:
                            </td>
                            <td valign="middle">
                                <asp:TextBox ID="txtstartdate1" runat="server" CssClass="form-control form-control-border"></asp:TextBox>
                            </td>
                            <td>
                                <asp:Image ID="Img1" runat="server" CssClass="icon-calendar52 text-primary-600" />
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
                                <asp:TextBox ID="txtenddate2" runat="server" CssClass="form-control form-control-border"></asp:TextBox>
                            </td>
                            <td>
                                <asp:Image ID="Img2" runat="server" CssClass="icon-calendar52 text-primary-600" />
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
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblDept" CssClass="labelChange" Font-Bold="true" runat="server">Department</asp:Label>
                            </td>
                            <td>:
                            </td>
                            <td colspan="4">
                                <asp:DropDownList ID="ddlDept" runat="server" CssClass="texboxcls" Width="250px">
                                    <asp:ListItem Value="0" Text="Select Department"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:Button Style="margin-top: 0;" ID="btngen" runat="server" CssClass="btn btn-outline-success legitRipple"
                                    Text="Generate Report" OnClick="btngen_Click" />
                            </td>
                        </tr>
                    </table>
                    <table>
                        <tr>
                            <td id="tddept" runat="server" style="width: 380px;">
                                <asp:CheckBox ID="chkProject" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                    Text=" Check All Projects (Count : 0)" CssClass="labelChange" />
                                <div id="PanelProject" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
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
            </div>
            <rsweb:ReportViewer ID="ReportViewer1" Width="1144px" SizeToReportContent="true"
                Visible="false" runat="server" AsyncRendering="False" InteractivityPostBackMode="AlwaysAsynchronous">
            </rsweb:ReportViewer>
        </div>
    </div>
</div>
