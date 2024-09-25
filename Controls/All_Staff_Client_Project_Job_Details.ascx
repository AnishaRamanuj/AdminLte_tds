<%@ Control Language="C#" AutoEventWireup="true" CodeFile="All_Staff_Client_Project_Job_Details.ascx.cs" Inherits="controls_All_Staff_Client_Project_Job_Details" %>



<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>


<%--  new page created by Anil Gajre on 15/02/2018 for project wise columnar report monthly detail--%>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<%--css file--%>
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>


<%--javascript file--%>

<script type="text/javascript" >
    $(document).ready(function () {


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
        ////check all project
        $("[id*=chkAproject]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clProject").attr('checked', 'checked');
            }
            else {
                $(".clProject").removeAttr('checked');
            }
            singleprojectcheck();
            $('.modalganesh').css('display', 'none');
        });
        ///////check all client
        $("[id*=chkAclient]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clclient").attr('checked', 'checked');
            }
            else {
                $(".clclient").removeAttr('checked');
            }
            singleclientcheck();
            $('.modalganesh').css('display', 'none');
        });
        /////////check all staff
        $("[id*=chkAstaff]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clstaff").attr('checked', 'checked');
            }
            else {
                $(".clstaff").removeAttr('checked');
            }
            singlestaffcheck();
            $('.modalganesh').css('display', 'none');
        });

        /////////check all job
        $("[id*=chkAjob]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clJob").attr('checked', 'checked');
            }
            else {
                $(".clJob").removeAttr('checked');
            }
            $('.modalganesh').css('display', 'none');
        });

        /////////filter month wise
        $("[id*=txtmonth]").on("change", function () { Onpagefilterloads(); });
        $("[id*=ddlType]").on("change", function () { Onpagefilterloads(); });
        Onpagefilterloads();
        $("[id*=btngen]").on("click", function () {
            var selectStaff1 = '';
            $(".clstaff:checked").each(function () {
                selectStaff1 += $(this).val() + ',';
            });
            $("[id*=hdnstaffcode]").val(selectStaff1);
            GetAllSelected();
            $("[id*=hdntype]").val($("[id*=ddlType]").val());
        });
        $("[id*=btnBack]").on("click", function () { $(".modalganesh").show(); });

    });
    ///////get statuswise filter
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

    ///////////////on page load data functions
    var clientwise = false, projectwise = false, staffwise = true, jobwise = false;
    function Onpagefilterloads() {
        clientwise = false, projectwise = false, staffwise = true, jobwise = false;
        $("[id*=chkAclient]").removeAttr('checked');
        $("#chkAclient").parent().find('label').text("Check All Clients (Count : 0)").addClass("labelChange");
        $("[id*=chkAproject]").removeAttr('checked');
        $("#chkAproject").parent().find('label').text("Check All Projects (Count : 0)").addClass("labelChange");
        $("[id*=chkAstaff]").removeAttr('checked');
        $("#chkAstaff").parent().find('label').text("Check All Staffs (Count : 0)").addClass("labelChange");
        $("[id*=chkAjob]").removeAttr('checked');
        $("#chkAjob").parent().find('label').text("Check All Job (Count : 0)").addClass("labelChange");
        onpageclientProjectload();
    }
    function onpageclientProjectload() {
        GetAllSelected();
        if (staffwise) {
            $("[id*=hdncltid]").val('');
            //$("[id*=hdnprojectid]").val('');
            $("[id*=hdnstaffcode]").val('Empty');
        }
        var compid = parseFloat($("[id*=hdnCompid]").val());
        var cltid = $("[id*=hdncltid]").val();
        var projectid = $("[id*=hdnprojectid]").val();
        var selectedstaffcode = $("[id*=hdnstaffcode]").val();
        if ($("[id*=txtfrom]").val() == "" || $("[id*=txtfrom]").val() == undefined) {
            return false;
        }

        $(".modalganesh").show();

        var data = {
            currobj: {
                compid: compid,
                UserType: $("[id*=hdnUserType]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                StaffCode: $("[id*=hdnstaffid]").val(),
                selectedstaffcode: selectedstaffcode,
                selectetdcltid: cltid,
                selectedprojectid: projectid,
                staffwise: staffwise,
                clientwise: clientwise,
                projectwise: projectwise,
                jobwise: jobwise,
                fromdate: $("[id*=txtfrom]").val(),
                todate: $("[id*=txtto]").val(),
                RType: 'staff'
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/All_Staff_Client_Project_Job_Details.asmx/Get_Staff_Client_Project_All_Selected",
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
        var tableRowsstaff = '', tableRowsclient = '', tableRowsProject = '', tableRowsJobs = '';
        var countstafff = 0, countclient = 0, countProject = 0, countJob = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "staff") {
                countstafff += 1;
                tableRowsstaff += "<tr><td><input type='checkbox'  onclick='singlestaffcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "client") {
                countclient += 1;
                tableRowsclient += "<tr><td><input type='checkbox' checked='checked'  onclick='singleclientcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "Project") {
                countProject += 1;
                tableRowsProject += "<tr><td><input type='checkbox' onclick='singleprojectcheck()' checked='checked' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "Job") {
                countJob += 1;
                tableRowsJobs += "<tr><td><input type='checkbox' checked='checked' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });

        if (clientwise) {
            if (countclient != 0)
                $("[id*=chkAclient]").attr('checked', 'checked');
            else
                $("[id*=chkAclient]").removeAttr('checked');

            $("[id*=DvClient]").parent().find('label').text("Check All Clients (Count : " + countclient + ")").addClass("labelChange");
            $("[id*=DvClient]").html("<table>" + tableRowsclient + "</table>");
        }
        if (projectwise) {

            if (countProject != 0)
                $("[id*=chkAproject]").attr('checked', 'checked');
            else
                $("[id*=chkAproject]").removeAttr('checked');

            $("[id*=DvProject]").parent().find('label').text("Check All Projects (Count : " + countProject + ")").addClass("labelChange");
            $("[id*=DvProject]").html("<table>" + tableRowsProject + "</table>");
        }
        if (staffwise) {

            $("[id*=chkAstaff]").removeAttr('checked');
            $("[id*=chkAstaff]").parent().find('label').text("Check All Staffs (Count : " + countstafff + ")");
            $("#chkAstaff").parent().find('label').addClass("labelChange");
            $("[id*=dvstaff]").html("<table>" + tableRowsstaff + "</table>");
        }
        $(".modalganesh").hide();

        if (jobwise) {
            if (countJob != 0)
                $("[id*=chkAjob]").attr('checked', 'checked');
            else
                $("[id*=chkAjob]").removeAttr('checked');


            $("[id*=chkAjob]").parent().find('label').text("Check All Job (Count : " + countJob + ")");
            $("#chkAjob").parent().find('label').addClass("labelChange");
            $("[id*=Dvjob]").html("<table>" + tableRowsJobs + "</table>");
        }
        $(".modalganesh").hide();
    }

    ////check single staff
    function singlestaffcheck() {
        if ($(".clstaff").length == $(".clstaff:checked").length)
        { $("[id*=chkAstaff]").attr('checked', true); }
        else { $("[id*=chkAstaff]").removeAttr('checked'); }
        staffwise = false, clientwise = true, projectwise = true, jobwise = true;
        onpageclientProjectload();
    }
    //////check single client
    function singleclientcheck() {
        if ($(".clclient").length == $(".clclient:checked").length)
        { $("[id*=chkAclient]").attr('checked', true); }
        else { $("[id*=chkAclient]").removeAttr('checked'); }
        staffwise = false, clientwise = false, projectwise = true, jobwise = true;
        onpageclientProjectload();
    }
    //////check single project
    function singleprojectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length)
        { $("[id*=chkAproject]").attr('checked', true); }
        else { $("[id*=chkAproject]").removeAttr('checked'); }
        staffwise = false, clientwise = false, projectwise = false, jobwise = true;
        onpageclientProjectload();
    }


    function GetAllSelected() {
        var selectStaff = '', selectclient = '', selectproject = '', selectjobs = '';
        $(".clstaff:checked").each(function () {
            selectStaff += $(this).val() + ',';
        });
        $(".clclient:checked").each(function () {
            selectclient += $(this).val() + ',';
        });
        $(".clProject:checked").each(function () {
            selectproject += $(this).val() + ',';
        });
        $(".clJob:checked").each(function () {
            selectjobs += $(this).val() + ',';
        });
        $("[id*=hdnstaffcode]").val(selectStaff);
        $("[id*=hdncltid]").val(selectclient);
        $("[id*=hdnprojectid]").val(selectproject);
        $("[id*=hdnjobids]").val(selectjobs);
    }


        </script>



<div class="headerstyle1_page">
      <asp:Label ID="Label1" runat="server" Text="All Staff Client Project" CssClass="Head1 labelChange"></asp:Label>
      <div style="float: right;"> <asp:Button ID="btnBack" runat="server" CssClass="TbleBtns" Text="Back" Visible="false" OnClick="btnBack_Click"  />  </div>
      <asp:HiddenField runat="server" ID="hdnCompid" /> 
      <asp:HiddenField runat="server" ID="hdncltid" />
      <asp:HiddenField runat="server" ID="hdnprojectid" />
      <asp:HiddenField runat="server" ID="hdnstaffcode" />
      <asp:HiddenField runat="server" ID="hdnUserType" />  
      <asp:HiddenField runat="server" ID="hdnstaffid" />
      <asp:HiddenField runat="server" ID="hdnjobids" />
      <asp:HiddenField runat="server" ID="hdntype" />
      <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected"/>                         
</div>



<div class="divstyle">
        <div id="div2" class="totbodycatreg" style="height: 700px;">
            
             <div style="width: 100%;">
                <uc2:MessageControl ID="MessageControl1" runat="server" />
            </div>

            <div class="row_report" runat="server" id="divReportInput">
            <table width="100%">
              <tr>
                <td valign="middle">
                                        <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td valign="middle" align="center">
                                        :
                                    </td>
                                    <td valign="middle">
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
                                    
                                    
                                    <td valign="middle">
                                        <label style="font-weight:bold">From</label></td>
                                        <td>:</td>
                                    <td style="width: 110px;">
                                        <asp:TextBox ID="txtfrom" runat="server" Width="55px" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" />
                                        <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtfrom" PopupButtonID="Img1" Format="dd/MM/yyyy"></cc1:CalendarExtender>
                                         
                                    </td>
                                      <td valign="middle">
                                        <label style="font-weight:bold">To</label></td>
                                        <td>:</td>
                                    <td style="width: 110px;">
                                        <asp:TextBox ID="txtto" runat="server" Width="55px" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/calendar.png" />
                                        <asp:Label ID="Label3" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtto" PopupButtonID="Img1" Format="dd/MM/yyyy"></cc1:CalendarExtender>
                                         
                                    </td>
                                    
                                    
                                      <td><asp:Button Style="margin-top: 5px;" ID="btngen" runat="server" OnClick="btngen_Click" 
                                            CssClass="TbleBtns"  Text="Generate Report" /></td>
                                    
                </tr>
              
            </table>
                <table class="style1" style="float: left;">
                    <tr>
                        <td>
                            <table>
                                <tr>
                              <%--staff selection div--%>
                                   <td style="width: 260px;">
                                        <asp:CheckBox ID="chkAstaff" runat="server" ForeColor="Black" Font-Bold="true" Height="20px" Text=" Check All Staff (Count : 0)" CssClass="labelChange" />
                                        <div id="dvstaff" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                        </div>
                                    </td>
                              <%--  client selection div--%>
                                   <td style="width: 260px;">
                                        <asp:CheckBox ID="chkAclient" runat="server" ForeColor="Black" Font-Bold="true" Height="20px" Text=" Check All Client (Count : 0)" CssClass="labelChange" />
                                        <div id="DvClient" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;"></div>
                                   </td>
                              <%--  Project selection div--%>
                                   <td style="width: 260px;">
                                        <asp:CheckBox ID="chkAproject" runat="server" ForeColor="Black" Font-Bold="true" Height="20px" Text=" Check All Project (Count : 0)" CssClass="labelChange" />
                                        <div id="DvProject" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;"> </div>
                                   </td>
                              <%--  job selection div--%>
                                   <td style="width: 260px;">
                                        <asp:CheckBox ID="chkAjob" runat="server" ForeColor="Black" Font-Bold="true" Height="20px" Text=" Check All job (Count : 0)" CssClass="labelChange" />
                                        <div id="Dvjob" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;"> </div>
                                   </td>
                            
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <div id="tblreport"  visible="false">
                <table><tr><td></td></tr></table>
                </div>
            </div>
               <rsweb:ReportViewer ID="ReportViewer1" Height="670px" Width="1144px"
            Visible="false" runat="server" AsyncRendering="False" 
                 InteractivityPostBackMode="AlwaysAsynchronous">
        </rsweb:ReportViewer>
        </div>
</div>
