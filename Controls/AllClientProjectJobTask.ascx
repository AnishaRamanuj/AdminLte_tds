<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AllClientProjectJobTask.ascx.cs"
    Inherits="controls_AllClientProjectJobTask" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<%--css file--%>
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>
<%--javascript file--%>
<%--javascript for all--%>
<script lang="javascript" type="text/javascript">
    $(document).ready(function () {
        $("[id*=hdnRtype]").val('');
        pageFiltersReset();
        ///////bind Data on page loading
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

            pageFiltersReset();
        });
        $("[id*=txtenddate2]").on("change", function () {

            pageFiltersReset();
        });
        $("[id*=btngen]").on("click", function () {

            var task = '';
            GetAllSelected();
            $(".cltask:checked").each(function () {
                task += $(this).val() + ',';
            });

            if (task == '')
            { alert('Please select at least one task Name!'); return false; }
            $(".modalganesh").show();
        });
        $("[id*=btnBack]").on("click", function () { $(".modalganesh").show(); });
        $("[id*=chkAclient]").on("click", function () {
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
        });
        $("[id*=chkAproject]").on("click", function () {

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
        });
        $("[id*=chkAjob]").on("click", function () {

            if ($(this).attr('checked')) {
                $(".cljob").each(function () {
                    $(this).attr('checked', 'checked');
                });

            }
            else {
                $(".cljob:checked").each(function () {
                    $(this).removeAttr('checked');
                });
            }
            singlejobcheck();
        });
        $("[id*=chkAtask]").on("click", function () {

            if ($(this).attr('checked')) {
                $(".cltask").each(function () {
                    $(this).attr('checked', 'checked');
                });

            }
            else {
                $(".cltask:checked").each(function () {
                    $(this).removeAttr('checked');
                });
            }
            singletaskcheck();
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
        pageFiltersReset();
    }
    //////// first time data loading on page client loading

    var needtask = false, needclient = true, needproject = false, needjob = false;
    function pageFiltersReset() {
        needtask = false, needclient = true, needproject = false, needjob = false;
        $("[id*=chkAtask]").removeAttr('checked');
        $("[id*=chkAtask]").parent().find('label').text("Check All Task Name (Count : 0)");
        $("[id*=chkAclient]").removeAttr('checked');
        $("[id*=chkclient]").parent().find('label').text("Check All Client Name (Count : 0)");
        $("[id*=chkAproject]").removeAttr('checked');
        $("[id*=chkproject]").parent().find('label').text("Check All Project Name (Count : 0)");
        $("[id*=chkAjob]").removeAttr('checked');
        $("[id*=chkAjob]").parent().find('label').text("Check All Job Name (Count : 0)");
        $("[id*=hdnRtype]").val('');

        $("[id*=Panelclt]").html('');
        $("[id*=Panelprj]").html('');
        $("[id*=Paneljob]").html('');
        $("[id*=Paneltask]").html('');
        BindPageLoadStaff();
    }
    function GetAllSelected() {
        var selecttask = '', selectclient = '', selectproject = '', selectjob = '';
        $(".cltask:checked").each(function () {
            selecttask += $(this).val() + ',';
        });
        $(".clclient:checked").each(function () {
            selectclient += $(this).val() + ',';
        });

        $(".clProject:checked").each(function () {
            selectproject += $(this).val() + ',';
        });
        $(".cljob:checked").each(function () {
            selectjob += $(this).val() + ',';
        });

        $("[id*=hdnSelectedtask]").val(selecttask);
        $("[id*=hdnselectedclientid]").val(selectclient);
        $("[id*=hdnselectedprojectid]").val(selectproject);
        $("[id*=hdnselectedjob]").val(selectjob);
    }
    function BindPageLoadStaff() {
        GetAllSelected();
        var RType = $("[id*=hdnRtype]").val();
        if (needclient) {
            $("[id*=hdnselectedclientid]").val('Empty');
            $("[id*=hdnSelectedtask]").val('');
            $("[id*=hdnselectedprojectid]").val('');
            $("[id*=hdnselectedjob]").val('');
        }
        if ($("[id*=txtstartdate1]").val() == "" || $("[id*=txtstartdate1]").val() == undefined)
        { return false; }
        $(".modalganesh").show();
        var data = {
            currobj: {

                compid: $("[id*=hdnCompid]").val(),
                UserType: $("[id*=hdnUserType]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                StaffCode: $("[id*=hdnStaffCode]").val(),
                selectedtask: $("[id*=hdnSelectedtask]").val(),
                selectedclientid: $("[id*=hdnselectedclientid]").val(),
                selectedprojectid: $("[id*=hdnselectedprojectid]").val(),
                selectedjobid: $("[id*=hdnselectedjob]").val(),
                FromDate: $("[id*=txtstartdate1]").val(),
                ToDate: $("[id*=txtenddate2]").val(),
                RType: $("[id*=hdnRtype]").val()
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Allclientprojectjobtask.asmx/Bind_Client_Project_Job_Task_All_Selected",
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
        var tableRowstask = '', tableRowsclient = '', tableRowsproject = '', tableRowsjob = '';
        var counttask = 0, countclient = 0, countproject = 0, countjob = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "task") {
                counttask += 1;
                tableRowstask += "<tr><td><input type='checkbox' checked='checked' onclick='singletaskcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "client") {
                countclient += 1;
                tableRowsclient += "<tr><td><input type='checkbox'  onclick='singleclientcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "job") {
                countjob += 1;
                tableRowsjob += "<tr><td><input type='checkbox' onclick='singlejobcheck()' checked='checked' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "Project") {
                countproject += 1;
                tableRowsproject += "<tr><td><input type='checkbox' onclick='singleprojectcheck()' checked='checked' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });


        if (needclient) {
            $("[id*=chkclient]").removeAttr('checked');
            $("[id*=chkclient]").parent().find('label').text("Check All Client Name (Count : " + countclient + ")");
            $("[id*=Panelclt]").html("<table>" + tableRowsclient + "</table>");
        }
        if (needproject) {

            if (countproject != 0)
                $("[id*=chkAproject]").attr('checked', 'checked');
            else
                $("[id*=chkAproject]").removeAttr('checked');

            $("[id*=chkAproject]").parent().find('label').text("Check All Project Name (Count : " + countproject + ")");
            $("[id*=Panelprj]").html("<table>" + tableRowsproject + "</table>");
        }

        if (needjob) {

            if (countjob != 0)
                $("[id*=chkAjob]").attr('checked', 'checked');
            else
                $("[id*=chkAjob]").removeAttr('checked');

            $("[id*=chkAjob]").parent().find('label').text("Check All Job Name(Count : " + countjob + ")");
            $("[id*=Paneljob]").html("<table>" + tableRowsjob + "</table>");
      
        }
        if (needtask) {
            if (counttask != 0)
                $("[id*=chkAtask]").attr('checked', 'checked');
            else
                $("[id*=chkAtask]").removeAttr('checked');


            $("[id*=chkAtask]").parent().find('label').text("Check All Task Name (Count : " + counttask + ")");
            $("[id*=Paneltask]").html("<table>" + tableRowstask + "</table>");
        }
        $(".modalganesh").hide();
    }

    ////check single task
    function singletaskcheck() {
        if ($(".cltask").length == $(".cltask:checked").length)
        { $("[id*=chkAtask]").attr('checked', true); }
        else { $("[id*=chkAtask]").removeAttr('checked'); }
    }
    //////check single client

    function singleclientcheck() {
        $("[id*=hdnRtype]").val('client');
        if ($(".clclient").length == $(".clclient:checked").length)
        { $("[id*=chkAclient]").attr('checked', true); }
        else { $("[id*=chkAclient]").removeAttr('checked'); }
        needtask = true, needclient = false, needproject = true, needjob = true;

        BindPageLoadStaff();


    }
    //////check single project
    function singleprojectcheck() {
        $("[id*=hdnRtype]").val('project');
        if ($(".clproject").length == $(".clproject:checked").length)
        { $("[id*=chkproject]").attr('checked', true); }
        else { $("[id*=chkproject]").removeAttr('checked'); }
        needtask = true, needclient = false, needproject = false, needjob = true;
        BindPageLoadStaff();
    }

    //////check single job
    function singlejobcheck() {
        $("[id*=hdnRtype]").val('job');
        if ($(".cljob").length == $(".cljob:checked").length)
        { $("[id*=chkAjob]").attr('checked', true); }
        else { $("[id*=chkAjob]").removeAttr('checked'); }
        needtask = true, needclient = false, needjob = false, needproject = false;
        BindPageLoadStaff();
    }
</script>
<%--this page Created by Anil Gajre on 29/09/2017 for job wise task defines--%>
<div class="headerpage">
        <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
            <asp:Label ID="Label1" runat="server" Text="All Client Project Job Task Report" CssClass="Head1 labelChange"></asp:Label>
        </div>
    </div>

<div style="float: right;"> <asp:Button ID="btnBack" runat="server" CssClass="TbleBtns" Text="Back" Visible="false" onclick="btnBack_Click"/></div>
<%--hiddn fields for storing client job project ids--%>
<asp:HiddenField runat="server" ID="hdnCompid" />
<asp:HiddenField runat="server" ID="hdnUserType" />
<asp:HiddenField runat="server" ID="hdnSelectedtask" Value="Empty" />
<asp:HiddenField runat="server" ID="hdnselectedclientid" />
<asp:HiddenField runat="server" ID="hdnselectedprojectid" />
<asp:HiddenField runat="server" ID="hdnStaffCode" />
<asp:HiddenField runat="server" ID="hdnselectedjob" />
<asp:HiddenField runat="server" ID="hdnRtype" />
<asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
<%--message control for giving success error or warning messages--%>
<div style="width: 100%;">
    <uc2:MessageControl ID="MessageControl1" runat="server" />
</div>
<%--inpurpart like date status and report type--%>
<div id="dvreportinput" runat="server">
<table style="padding-left:55px; padding-top:15px; width:1100px;">
                                        <tr>
                                        <td valign="middle">
                                            <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From" Font-Bold="True"></asp:Label>
                                        </td>
                                        <td align="center" valign="middle">
                                            :
                                         </td>
                                        <td valign="middle">
                                            <asp:TextBox ID="txtstartdate1" style="width:65px !important; float:left;" runat="server" CssClass="texboxcls" ></asp:TextBox>
                                            <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" />
                                            <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                                            <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtstartdate1" PopupButtonID="Img1" Format="dd/MM/yyyy">
                                            </cc1:CalendarExtender>
                                        </td>
                                        <td valign="middle">
                                            <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To" Font-Bold="True"></asp:Label>
                                        </td>
                                        <td align="center" valign="middle">
                                            :
                                        </td>
                                        <td valign="middle">
                                        <asp:TextBox ID="txtenddate2" runat="server" CssClass="texboxcls" style="width:65px !important; float:left;"></asp:TextBox>
                                        <asp:Image ID="Img2" runat="server" ImageUrl="~/images/calendar.png" />
                                        <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtenddate2" PopupButtonID="Img2" Format="dd/MM/yyyy">
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
                                                <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static" Checked="true"
                                                    onclick="TStatusCheck()" Text="Saved" />&nbsp;&nbsp;
                                                <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()" Checked="true"
                                                    ClientIDMode="Static" Text="Approved" />&nbsp;&nbsp;
                                                <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()" Checked="true"
                                                    ClientIDMode="Static" Text="Rejected" />
                                        </td>
                                        <td> <asp:Button Style="margin-top: -5px;" ID="btngen" runat="server" 
                                            CssClass="TbleBtns"  Text="Generate Report" onclick="btngen_Click" />
                                    </td>
                                        </tr>
                                <tr>
                                    <td colspan="6">
                                    </td>
                                    <td valign="middle">
                                        <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Report Type" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center" valign="middle">
                                        :
                                    </td>
                                    <td valign="middle">
                                        <asp:RadioButton runat="server" ID="rsummary" Text="Summarized" Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                                        <asp:RadioButton runat="server" ID="rdetailed" Text="Detailed" GroupName="rbtn" />&nbsp;
                                    </td>
  
                                    <td width="60px;">
                                    </td>
                                </tr>
</table>
<table class="style1" style="float: left; padding-left:55px;">

    <tr>
        <td style="width: 450px;">
            <asp:CheckBox ID="chkAclient" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                Text=" Check All Client Name (Count : 0)" CssClass="labelChange" />
            <div id="Panelclt" style="border: 1px solid #B6D1FB; width: 95%; height: 250px; overflow: auto;">
            </div>
        </td>
        <td style="width: 450px;">
            <asp:CheckBox ID="chkAproject" runat="server" ForeColor="Black" Font-Bold="true"
                Height="20px" Text=" Check All Project Name (Count : 0)" CssClass="labelChange" />
            <div id="Panelprj" style="border: 1px solid #B6D1FB; width: 95%; height: 250px; overflow: auto;">
            </div>
        </td>
    </tr>
    <tr>
        <td id="tddept" runat="server" style="width: 380px;">
            <asp:CheckBox ID="chkAjob" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                Text=" Check All Job Name (Count : 0)" CssClass="labelChange" />
            <div id="Paneljob" style="border: 1px solid #B6D1FB; width: 95%; height: 250px; overflow: auto;">
            </div>
        </td>
        <td style="width: 380px;">
            <asp:CheckBox ID="chkAtask" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                Text=" Check All Task Name (Count : 0)" CssClass="labelChange" />
            <div id="Paneltask" style="border: 1px solid #B6D1FB; width: 95%; height: 250px;
                overflow: auto;">
            </div>
        </td>
    </tr>
</table></div>
<div id="dvreport" runat="server">
   <rsweb:ReportViewer ID="ReportViewer1" Height="670px" Width="1144px" SizeToReportContent="true" 
                 Visible="false" runat="server" AsyncRendering="False" 
                 InteractivityPostBackMode="AlwaysAsynchronous">
        </rsweb:ReportViewer>
</div>
