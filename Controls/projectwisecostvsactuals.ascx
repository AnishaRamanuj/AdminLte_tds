<%@ Control Language="C#" AutoEventWireup="true" CodeFile="projectwisecostvsactuals.ascx.cs" Inherits="controls_projectwisecostvsactuals" %><%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<%--<% --Page created by anil gajre 17/10/2017-- %>--%>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" /><%--css file--%>
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script><%--javascript file--%>
<script type="text/javascript">
    var clientwise = true, projectwise = false,jobwise=false;

    $(document).ready(function () {
        $("[id*=chkAclient]").removeAttr('checked');
        $("[id*=chkAproject]").removeAttr('checked');
        var today = new Date();
        var yyyy = today.getFullYear() - 1;
        var month = today.getMonth() + 1;
        var dd = today.getDate();
        if (month < 4) {
            $("[id*=txtfrmdt]").val('01/04/' + yyyy);
        }
        else {
            $("[id*=txtfrmdt]").val('01/04/' + today.getFullYear());
        }
        $("[id*=txttodt]").val(dd + '/' + month + '/' + today.getFullYear());

        var from = $("[id*=txtfrmdt]").val();
        var to = $("[id*=txttodt]").val();
        var compid = $("[id*=hdncompid]").val();
        getclientprojectwisebudgeting(compid, 0, from, to, 0);


        $("[id*=btngrnreport]").on('click', function () {
            $("[id*=hdnselectedprojectids]").val('');
            getAllselected();


            if ($("[id*=hdnselectedprojectids]").val() == '') {
                alert('Please Select atleast one project');
                return false;
            }
            $(".modalganesh").show();
        });

        /////////////all client check
        $("[id*=chkAclient]").on('change', function () {
            if ($(this).attr('checked')) {
                $(".classclient").each(function () {
                    $(this).attr('checked', 'checked');
                });
                
            }
            else {
                $(".classclient").each(function () {
                    $(this).removeAttr('checked');
                });
            }
            singleclientcheck();
        });
        ///////////////////////check all project 
        $("[id*=chkAproject]").on('change', function () {
            if ($(this).attr('checked')) {
                $(".classproject").each(function () {
                    $(this).attr('checked', 'checked');
                });
            }
            else {
                $(".classproject").each(function () {
                    $(this).removeAttr('checked');
                });
            }
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
    function getclientprojectwisebudgeting(compid, cltid, from, to,projectid) {
        if ($("[id*=txtfrmdt]").val() == "" || $("[id*=txtfrmdt]").val() == undefined) {
           
            return false;
        }
        if ($("[id*=txttodt]").val() == "" || $("[id*=txttodt]").val() == undefined) {
            
            return false;
        }
        ///$(".modalganesh").show();
        var data = {
            currentobj: {
                compid: compid,
                cltid: cltid,
                from: from,
                to: to,
                projectid: projectid

            }
        };
        /////////ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/clientprojectwisebudgeting.asmx/getclientprojectwisebudgeting",
            data: JSON.stringify(data),
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {
                alert("server not responding please try again");
            },
            error: function (response) {
                alert("No Data Found");
            }
        });
        //ajax finish
    }

    function getAllselected() {
        var selectedcltids = '',selectedprojectids='';
        $(".classclient:checked").each(function () {
            selectedcltids += $(this).val() + ',';
        });
        $("[id*=hdnselectedcltids]").val(selectedcltids);
        $(".classproject:checked").each(function () {
            selectedprojectids += $(this).val() + ',';
        });
        $("[id*=hdnselectedprojectids]").val(selectedprojectids);

    }
    function OnSuccess(response) {
        var obj = jQuery.parseJSON(response.d);
        console.log(obj);
        var tableRowsjob = '', tableRowsclient = '', tableRowsProject = '';
        var countjob = 0, countclient = 0, countProject = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "staff") {
                countjob += 1;
                tableRowsstaff += "<tr><td><input type='checkbox' checked='checked' onclick='singlestaffcheck()' class='class" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "client") {
                countclient += 1;
                tableRowsclient += "<tr><td><input type='checkbox'  onclick='singleclientcheck()' class='class" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "project") {
                countProject += 1;
                tableRowsProject += "<tr><td><input type='checkbox' onclick='singleprojectcheck()' checked='checked' class='class" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });
        if (clientwise) {
            $("[id*=chkAclient]").removeAttr('checked');
            $("[id*=chkAclient]").parent().find('label').text(" Check All Client Name (Count :" + countclient + ")");
            $("[id*=DvClient]").html("<table>" + tableRowsclient + "</table>");

        }
        if (projectwise) {
            $("[id*=chkAproject]").attr('checked', 'checked');
            $("[id*=chkAproject]").parent().find('label').text(" Check All Project Name (Count :" + countProject + ")");
            $("[id=DvProject]").html("<table>" + tableRowsProject + "</table>");
            if (countProject == 0) {
                $("[id*=chkAproject]").removeAttr('checked');
            }
        }
        if (jobwise) {
            $("[id*=chkAjob]").attr('checked', 'checked');
            $("[id*=chkAjob]").parent().find('label').text(" Check All Job Name (Count :" + countjob + ")");
            $("[id=DvProject]").html("<table>" + tableRowsjob + "</table>");
            if (countjob == 0) {
                $("[id*=chkAjob]").removeAttr('checked');
            }
        }
    }
    function singleclientcheck() {
        clientwise = false; projectwise = true;
        var compid = $("[id*=hdncompid]").val();
        getAllselected();
        var selectedcltids = $("[id*=hdnselectedcltids]").val();
        var fromdate=$("[id*=txtfrmdt]").val();
        var todate = $("[id*=txttodt]").val();
        getclientprojectwisebudgeting(compid, selectedcltids, fromdate, todate,0);

    }
    function singleprojectcheck() {
        clientwise = false;projectwise = false;jobwise = true;
        var compid = $("[id*=hdncompid]").val();
        getAllselected();
        var selectedcltids = $("[id*=hdnselectedcltids]").val();
        var selectedprojectid = $("[id*=hdnselectedprojectids]").val();
        var fromdate = $("[id*=txtfrmdt]").val();
        var todate = $("[id*=txttodt]").val();
        getclientprojectwisebudgeting(compid, selectedcltids, fromdate, todate,selectedprojectid);
    }

</script>
<asp:HiddenField ID="hdncompid" runat="server" />
<asp:HiddenField ID="hdnselectedcltids" runat="server" />
<asp:HiddenField ID="hdnselectedprojectids" runat="server" />
<asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected"/>
<asp:HiddenField runat="server" ID="hdnselectedjobid" />
<div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;" >
      <asp:Label ID="Label1" runat="server" Text="Project wise Budgeting" CssClass="Head1 labelChange"></asp:Label>
      </div>
      <div id="dv_input" runat="server">
      <table style="width:1100px; padding-left:55px; padding-top:15px;">
      <tr>
      <td style="width:50px;"><asp:Label ID="Label65" runat="server" Font-Bold="true" Text="From : " ForeColor="Black"></asp:Label></td>
      <td style="width:110px;"><asp:TextBox ID="txtfrmdt" runat="server" CssClass="texboxcls txtnrml" Width="70px"></asp:TextBox><div style="float: right;">
                        <asp:Image ID="Image18" runat="server" ImageUrl="~/images/calendar.png" /></div>
                    <cc1:CalendarExtender ID="Calendarextender5" runat="server" TargetControlID="txtfrmdt"
                        PopupButtonID="Image18" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender></td>
                    <td style="width:20px;"></td>
      <td style="width:50px;"><asp:Label ID="Label67" runat="server" Font-Bold="true" Text="To : " ForeColor="Black"></asp:Label></td>
      <td style="width:112px;"> <div style="overflow: auto; float: left;">
                        <asp:TextBox ID="txttodt" runat="server" CssClass="txtnrml texboxcls" Width="70px"></asp:TextBox></div>
                    <div style="overflow: auto; float: right; padding-right: 5px">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/calendar.png" /></div>
                    <cc1:CalendarExtender ID="Calendarextender6" runat="server" TargetControlID="txttodt"
                        PopupButtonID="Image1" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender></td>
                     <td style="width:20px;"></td>
      <td><asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status" Font-Bold="True"></asp:Label></td>
      <td> <asp:CheckBox ID="chkTStatusAll" ClientIDMode="Static" runat="server" Checked="true" Text="All" /></td>
                
    <td> <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server" Checked="true"
                                        onclick="TStatusCheck()" Text="Submitted" /></td>
    <td> <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static" Checked="true"
                                        onclick="TStatusCheck()" Text="Saved" /></td>
    <td><asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()" Checked="true"
                                        ClientIDMode="Static" Text="Approved" /></td>
    <td><asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()" Checked="true"
                                        ClientIDMode="Static" Text="Rejected" /></td>
    <td><asp:Button ID="btngrnreport" runat="server" CssClass="TbleBtns" 
            Text="Generate Report" onclick="btngrnreport_Click" 
                /></td>
     
      </tr>
      </table>
            <div style="overflow: hidden; padding-bottom: 4px; padding-top: 18px; padding-left:25px; width: 102%;
                float: left;">
   
            </div>
            <table class="style1" style="float: left; padding-left:55px;">
                    <tr>
                        <td>
                            <table>
                                <tr>
                              <%--  client selection div--%>
                                   <td style="width: 450px;">
                                        <asp:CheckBox ID="chkAclient" runat="server" ForeColor="Black" Font-Bold="true" Height="20px" Text=" Check All Client Name (Count : 0)" CssClass="labelChange" />
                                        <div id="DvClient" style="border: 1px solid #B6D1FB; width: 95%; height: 500px; overflow: auto;"></div>
                                   </td>
                              <%--  Project selection div--%>
                                   <td id="jobselection" style="width: 450px;">
                                        <asp:CheckBox ID="chkAproject" runat="server" ForeColor="Black" Font-Bold="true" Height="20px" Text=" Check All Project Name (Count : 0)" CssClass="labelChange" />
                                        <div id="DvProject" style="border: 1px solid #B6D1FB; width: 95%; height: 500px; overflow: auto;"> </div>
                                   </td>
                               <%--staff selection div--%>
                                   <td id="tdjobselection" runat="server" style="width: 380px;">
                                        <asp:CheckBox ID="chkAjob" runat="server" ForeColor="Black" Font-Bold="true" Height="20px" Text=" Check All Job Name (Count : 0)" CssClass="labelChange" />
                                        <div id="dvstaff" style="border: 1px solid #B6D1FB; width: 95%; height: 500px; overflow: auto;">
                                        </div>
                                    </td>
                            
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>

                </div>

                <div runat="server" id="divReport" visible="false">
            <table>
                <tr>
                    <td>
                        <b>Export to</b>
                    </td>
                    <td>
                        <asp:ImageButton ID="btnExportToexcel" ImageUrl="~/Images/xls-icon.png" 
                            runat="server" onclick="btnExportToexcel_Click" />
                    </td>
                    <td width="40%">
                        <asp:Button ID="btncalcle" CssClass="TbleBtns" runat="server" Text="Cancel" OnClick="btncalcle_Click" />
                    </td>
                </tr>
            </table>
                 <div class="msterrhtbxwhlecntrllft">
               
                <asp:GridView ID="gv_Budgting" runat="server" AutoGenerateColumns="false" EmptyDataText="No records found!!!"
                    Width="100%" CssClass="allTimeSheettle">
                    <SelectedRowStyle CssClass="selectedstyle"></SelectedRowStyle>
                    <RowStyle CssClass="rowstyle"></RowStyle>
                    <Columns>
                        <asp:TemplateField HeaderText="Client Name">
                            <ItemStyle Width="25%" />
                            <ItemTemplate>
                                <div class="gridcolstyle1">
                                    <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Text='<%# bind("ClientName") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                            <HeaderStyle Width="100px" CssClass="grdheadermster labelChange"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Project Name">
                            <ItemStyle Width="25%" />
                            <ItemTemplate>
                                <div class="gridcolstyle1">
                                    <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Text='<%# bind("projectname") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                            <HeaderStyle Width="100px" CssClass="grdheadermster labelChange"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Budget Amout">
                            <ItemTemplate>
                                <div class="gridcolstyle1" style="text-align: right;">
                                    <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Width="90px" Text='<%# bind("BudgetAmount") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                            <HeaderStyle Width="100px" CssClass="grdheadermster"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Budget Hours">
                            <ItemTemplate>
                                <div class="gridcolstyle1" style="text-align: center;">
                                    <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Width="90px" Text='<%# bind("BudgetHours") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                            <HeaderStyle Width="100px" CssClass="grdheadermster"></HeaderStyle>
                        </asp:TemplateField>
                      <%--  <asp:TemplateField HeaderText="Budget Other Amount">
                            <ItemTemplate>
                                <div class="gridcolstyle1" style="text-align: right;">
                                    <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Width="90px" Text='<%# bind("BudgetOtherAmt") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                            <HeaderStyle Width="100px" CssClass="grdheadermster"></HeaderStyle>
                        </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="Actual Hours">
                            <ItemTemplate>
                                <div class="gridcolstyle1" style="text-align: center;">
                                    <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Width="90px" Text='<%# bind("actualhrs") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                            <HeaderStyle Width="100px" CssClass="grdheadermster"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actual Cost">
                            <ItemTemplate>
                                <div class="gridcolstyle1" style="text-align: right;">
                                    <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Width="90px" Text='<%# bind("actualcost") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                            <HeaderStyle Width="100px" CssClass="grdheadermster"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Difference">
                            <ItemTemplate>
                                <div class="gridcolstyle1" style="text-align: right;">
                                    <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Width="90px" Text='<%# bind("Diff") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                            <HeaderStyle Width="100px" CssClass="grdheadermster"></HeaderStyle>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle CssClass="grdheadermster" />
                </asp:GridView>
            </div>
            </div>