<%@ Control Language="C#" AutoEventWireup="true" CodeFile="All_Project_Client_Department_Summerise.ascx.cs" Inherits="controls_All_Project_Client_Department_Summerise" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/controls/MessageControl.ascx" TagName="MessageControl"
    TagPrefix="uc1" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%--//////page created by Anil Gajre on 31/01/2018--%>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>

<script type="text/javascript">
    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
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
        $("[id*=txtstartdate1]").on("change", function () {
            Onpagefilterloads();
        });
        $("[id*=txtenddate2]").on("change", function () {
            Onpagefilterloads();
        });
        $("[id*=ddlType]").on("change", function () { Onpagefilterloads(); });
        Onpagefilterloads();

        $("[id*=btngen]").on("click", function () {
            var selectStaff1 = '';
            $(".cldept:checked").each(function () {
                selectStaff1 += $(this).val() + ',';
            });
            $("[id*=hdnstaffcode]").val(selectStaff1);
            GetAllSelected();
            $("[id*=hdntype]").val($("[id*=ddlType]").val());
            var ddl = document.getElementById("<%=ddlBranch.ClientID%>");
            $("[id*=hdnbranch]").val(ddl.options[ddl.selectedIndex].text);
            $("[id*=hdnbr_id]").val($("[id*=ddlBranch]").val());
        });
        $("[id*=btnBack]").on("click", function () { $(".modalganesh").show(); });

        $("[id*=btnCSV]").on("click", function () {
            $(".modalganesh").show();
            var selectStaff1 = '';
            $(".clstaff:checked").each(function () {
                selectStaff1 += $(this).val() + ',';
            });
            $("[id*=hdnstaffcode]").val(selectStaff1);
            GetAllSelected();
            $("[id*=hdntype]").val($("[id*=ddlType]").val());
            $(".modalganesh").hide();
        });

        $("[id*=ddlBranch]").on('change', function () {
            Onpagefilterloads();
            var ddl = document.getElementById("<%=ddlBranch.ClientID%>");
            $("[id*=hdnbranch]").val(ddl.options[ddl.selectedIndex].text);
        });

        $("[id*=chkAclt]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clclient").each(function () {
                    $(this).attr('checked', 'checked');
                });
            }
            else {
                $(".clclient:checked").each(function () {
                    $(this).removeAttr('checked');
                });
            }
            singleclientcheck();
            $('.modalganesh').css('display', 'none');
        });


        $("[id*=chkAprj]").on("click", function () {
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

            singleprojectcheck();
            $('.modalganesh').css('display', 'none');
        });

        $("[id*=chkdept]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".cldept").each(function () {
                    $(this).attr('checked', 'checked');
                });
            }
            else {
                $(".cldept:checked").each(function () {
                    $(this).removeAttr('checked');
                });
            }
            $('.modalganesh').css('display', 'none');
        });
    });

    var clientwise = false, projectwise = false, deptwise = true;
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

    function GetAllSelected() {
        var selectclient = '', selectproject = '', selectdept = '';
        $(".clclient:checked").each(function () {
            selectclient += $(this).val() + ',';
        });
        $(".clProject:checked").each(function () {
            selectproject += $(this).val() + ',';
        });
        $(".cldept:checked").each(function () {
            selectdept += $(this).val() + ',';
        });
        $("[id*=hdnselectedclientid]").val(selectclient);
        $("[id*=hdnselectedprojectid]").val(selectproject);
        $("[id*=hdnselecteddept]").val(selectdept);
        var r = $("[id*=ddlRptType]").val();
        $("[id*=hdnRptType]").val(r);
        var b = $("[id*=ddlBranch]").val();
        $("[id*=hdnbranch]").val(b);

    }

    //////check single client
    function singleclientcheck() {
        if ($(".clclient").length == $(".clclient:checked").length)
        { $("[id*=chkAclt]").attr('checked', true); }
        else { $("[id*=chkAclt]").removeAttr('checked'); }
        deptwise = true, clientwise = false, projectwise = false;
        onpageclientProjectload();
    }
    //////check single project
    function singleprojectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length)
        { $("[id*=chkAprj]").attr('checked', true); }
        else { $("[id*=chkAprj]").removeAttr('checked'); }
        deptwise = true, clientwise = true, projectwise = false;
        onpageclientProjectload();
    }

    //////check single department 
    function singledeptcheck() {
        if ($(".cldept").length == $(".cldept:checked").length)
        { $("[id*=chkdept]").attr('checked', true); }
        else { $("[id*=chkdept]").removeAttr('checked'); }
        ///deptwise = false, clientwise = true, projectwise = true;
        ///onpageclientProjectload();
    }




    function Onpagefilterloads() {
        clientwise = false, projectwise = true, deptwise = false;
        $("[id*=chkdept]").removeAttr('checked');
        $("[id*=chkdept]").parent().find('label').text("Departments (Count : 0)");
        $("[id*=chkAclt]").removeAttr('checked');
        $("[id*=chkAclt]").parent().find('label').text("Clients (Count : 0)");
        $("[id*=chkAprj]").removeAttr('checked');
        $("[id*=chkAprj]").parent().find('label').text("Projects (Count : 0)");
        onpageclientProjectload();
    }


    //////////////////////////////////////////////Get All Department Client Project////////////////////////////////////
    function onpageclientProjectload() {
        GetAllSelected();
        if (projectwise) {
            $("[id*=hdnselectedclientid]").val('');
            $("[id*=hdnprojectid]").val('Empty');
            ///$("[id*=hdnselecteddept]").val('');
        }
        var compid = parseFloat($("[id*=hdnCompid]").val());
        var cltid = $("[id*=hdnselectedclientid]").val();
        var projectid = $("[id*=hdnselectedprojectid]").val();
        var selectedDeptid = $("[id*=hdnselecteddept]").val();
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
                selectedDeptid: selectedDeptid,
                selectetdcltid: cltid,
                selectedprojectid: projectid,
                deptwise: deptwise,
                clientwise: clientwise,
                projectwise: projectwise,
                fromdate: $("[id*=txtstartdate1]").val(),
                todate: $("[id*=txtenddate2]").val(),
                Type: $("[id*=ddlType]").val(),
                RType: 'project',
                BrId: $("[id*=ddlBranch]").val(),
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Projectstaff.asmx/Get_Project_Client_Dept_All_Selected",
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
        var tableRowsstaff = '', tableRowsclient = '', tableRowsProject = '';
        var countstafff = 0, countclient = 0, countProject = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "dept") {
                countstafff += 1;
                tableRowsstaff += "<tr><td><input type='checkbox' checked='checked'  onclick='singledeptcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "client") {
                countclient += 1;
                tableRowsclient += "<tr><td><input type='checkbox' checked='checked'  onclick='singleclientcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "Project") {
                countProject += 1;
                tableRowsProject += "<tr><td><input type='checkbox' onclick='singleprojectcheck()'  class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });

        if (clientwise) {
            if (countclient != 0)
                $("[id*=chkAclt]").attr('checked', 'checked');
            else
                $("[id*=chkAclt]").removeAttr('checked');

            $("[id*=chkAclt]").parent().find('label').text(" Clients (" + countclient + ")");
            $("[id*=Panelclt]").html("<table>" + tableRowsclient + "</table>");
        }
        if (projectwise) {
            $("[id*=chkAprj]").parent().find('label').text(" Projects (" + countProject + ")");
            $("[id*=Panelprj]").html("<table>" + tableRowsProject + "</table>");
        }
        if (deptwise) {
            if (countstafff != 0)
                $("[id*=chkdept]").attr('checked', 'checked');

            else
                $("[id*=chkdept]").removeAttr('checked');

            $("[id*=chkdept]").parent().find('label').text(" Departments (" + countstafff + ")");
            $("[id*=Paneldept]").html("<table>" + tableRowsstaff + "</table>");
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
                <asp:Label ID="lblname" runat="server" Text="All Project Client Department" Style="margin-left: 20px;"></asp:Label>
            </td>
            <td style="float: right; padding-top: 5px; margin-left: 60px;">
                <asp:Button ID="btngen" runat="server" OnClick="btngen_Click" CssClass="cssButton"
                    Text="Generate Report" />
            </td>
        </tr>
        <tr>
            <td style="float: left">
                <asp:Button ID="btnBack" Style="float: left" runat="server" CssClass="cssButton" Text="Back" Visible="false"
                    OnClick="btnBack_Click" />
            </td>
        </tr>
        <asp:HiddenField runat="server" ID="hdndeptwise" />
        <asp:HiddenField runat="server" ID="hdnCompid" />
        <asp:HiddenField runat="server" ID="hdnUserType" />
        <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="Empty" />
        <asp:HiddenField runat="server" ID="hdnselectedclientid" />
        <asp:HiddenField runat="server" ID="hdnselectedjobid" />
        <asp:HiddenField runat="server" ID="hdnselectedprojectid" />
        <asp:HiddenField runat="server" ID="hdnStaffCode" />
        <asp:HiddenField runat="server" ID="hdnselecteddept" />
        <asp:HiddenField runat="server" ID="hdnRptType" />
        <asp:HiddenField runat="server" ID="hdntype" />
        <asp:HiddenField runat="server" ID="hdnbranch" Value="0" />
        <asp:HiddenField runat="server" ID="hdnbr_id" Value="0" />
        <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
        <asp:HiddenField runat="server" ID="rb" Value="0" />
    </table>
</div>
<div class="divstyle">
    <div id="div2" class="totbodycatreg" style="height: auto;">
        <div style="width: 100%;">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
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
                                            <asp:ListItem Value="0" Text="All"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td valign="middle" style="width: 50px;">
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
                                    <td style="text-align: right">
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
                                        <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()" Checked="false"
                                            ClientIDMode="Static" Text="Rejected" Style='display: none;' />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 5px;"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lbltype" Font-Bold="true" runat="server">Type</asp:Label>
                                    </td>
                                    <td>:</td>
                                    <td>
                                        <select id="ddlType" class="texboxcls" style="width: 120px;">
                                            <option value="All">All</option>
                                            <option value="1">Billable</option>
                                            <option value="0">Non Billable</option>
                                        </select>
                                    </td>
                                    <td colspan="3">
                                        <div>
                                            <select id="ddlRptType" class="texboxcls" style="width: 120px;">
                                                <option value="Job">Job</option>
                                                <option value="Department">Department</option>
                                            </select>
                                        </div>
                                    </td>

                                    <td valign="middle">
                                        <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Report Type" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center" valign="middle">:
                                    </td>
                                    <td valign="middle">
                                        <asp:RadioButton runat="server" ID="rsummary" Text="Summarized" Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                                            <asp:RadioButton runat="server" ID="rdetailed" Text="Detailed" GroupName="rbtn" />&nbsp;
                                    </td>

                                    <td colspan="3"></td>
                                    <td colspan="2">
                                        <asp:Button ID="btnCSV" runat="server" CssClass="TbleBtns" Text="Generate CSV" Visible="false" OnClick="btnCSV_Click" />
                                    </td>
                                    <td></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="20">
                            <table>
                                <tr>

                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkAprj" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                            Text="Projects (0)" CssClass="labelChange" />
                                        <div id="Panelprj" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                        </div>
                                    </td>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkAclt" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                            Text="Clients (0)" CssClass="labelChange" />
                                        <div id="Panelclt" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                        </div>
                                    </td>
                                    <td id="tddept" runat="server" style="width: 380px;">
                                        <asp:CheckBox ID="chkdept" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                            Text="Departments (0)" CssClass="labelChange" />
                                        <div id="Paneldept" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <rsweb:ReportViewer ID="ReportViewer1" Width="1144px" SizeToReportContent="true" Visible="false" runat="server" AsyncRendering="False" InteractivityPostBackMode="AlwaysAsynchronous">
        </rsweb:ReportViewer>
    </div>
</div>
