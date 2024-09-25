<%@ Control Language="C#" AutoEventWireup="true" CodeFile="StaffExpense.ascx.cs"
    Inherits="controls_StaffExpense" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(document).ready(function () {
        $("[id*=Allchk]").on('click', function () {
            chkall();
        });
        $("[id*=chksStaff]").on('click', function () {
            if (($("[id*=chksStaff]").length - 1) == $("[id*=chksStaff] :checked").length)
            { $("[id*=Allchk]").prop('checked', 'true'); }
            else { $("[id*=Allchk]").removeProp('checked'); }
        });

    });
    function TStatusCheck() {
        debugger
        var count = 0;

        var sbu = $("[id*=chkSubmitted]");
        if (sbu.attr('checked'))
        { count += 1; }

        sbu = $("[id*=chkSaved]");
        if (sbu.attr('checked'))
        { count += 1; }

        sbu = $("[id*=chkApproved]");
        if (sbu.attr('checked'))
        { count += 1; }


        sbu = $("[id*=chkRejected]");
        if (sbu.attr('checked'))
        { count += 1; }

        if (count == 0) {
            $("[id*=chkApproved]").attr('checked', 'checked');
        }
        $("[id*=checkboxbutton]").click();
    }

    function chkall() {
        if ($("[id*=Allchk]").is(':checked')) {
            $("[id*=chksStaff]").each(function () {
                $(this).prop('checked', 'true');
            });
        }
        else {
            $("[id*=chksStaff]").each(function () {
                $(this).removeProp('checked');
            });
        }
    }
</script>
<div class="divstyle">
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
            <asp:Label ID="Label1" runat="server" CssClass="Head1 labelChange" Text="Staff Expense"></asp:Label>
            <div style="float: right;">
                <asp:Button ID="btnBack" runat="server" CssClass="TbleBtns" Text="Back" Visible="false"
                    OnClick="btnBack_Click" /></div>
            <asp:HiddenField runat="server" ID="hdnCompid" />
            <asp:HiddenField runat="server" ID="hdnUserType" />
            <asp:HiddenField runat="server" ID="hdnStaffCode" />
        </div>
    </div>
    <div id="div2" class="totbodycatreg" style="height:500px;">
        <div style="width: 100%;">
            <uc2:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div class="row_report" runat="server" id="divReportInput">
            <div>
                <table class="style1" style="padding-left:35px; padding-top:15px; width:1000px;">
                    <tr>
                        <td valign="middle">
                            <asp:Label ID="Label6" CssClass="labelChange" runat="server" ForeColor="Black" Text="Expense Status"
                                Font-Bold="True"></asp:Label>
                        </td>
                        <td valign="middle" align="center">
                            :
                        </td>
                        <td valign="middle">
                            <asp:Button ID="checkboxbutton" runat="server" OnClick="chkSubmitted_CheckedChanged"
                                Style="display: none;" />
                            <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server" Checked="true"
                                onclick="TStatusCheck()" Text="Submitted" />&nbsp;&nbsp;
                            <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static" Checked="true" onclick="TStatusCheck()"
                                Text="Saved" />&nbsp;&nbsp;
                            <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()" Checked="true"
                                ClientIDMode="Static" Text="Approved" />&nbsp;&nbsp;
                            <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()" Checked="true"
                                ClientIDMode="Static" Text="Rejected" />
                        </td> <td valign="middle">
                            <asp:Label ID="Label3" runat="server" ForeColor="Black" Text="From Date" Font-Bold="True"></asp:Label>
                        </td>
                        <td valign="middle" align="center">
                            :
                        </td>
                        <td valign="middle">
                            <asp:TextBox ID="txtstartdate1" runat="server" CssClass="texboxcls" 
                                AutoPostBack="True" ontextchanged="txtstartdate1_TextChanged"></asp:TextBox>
                            <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" Style="margin-right: 10px;" />
                            <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                            <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtstartdate1"
                                PopupButtonID="Img1" Format="dd/MM/yyyy">
                            </cc1:CalendarExtender>
                        </td>  <td valign="middle">
                            <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To Date" Font-Bold="True"></asp:Label>
                        </td>
                        <td valign="middle" align="center">
                            :
                        </td>
                        <td valign="middle">
                            <asp:TextBox ID="txtEndDate" runat="server" CssClass="texboxcls" 
                                AutoPostBack="True" ontextchanged="txtEndDate_TextChanged"></asp:TextBox>
                            <asp:Image ID="Image1" runat="server" ImageUrl="~/images/calendar.png" Style="margin-right: 10px;" />
                            <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                            <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtEndDate"
                                PopupButtonID="Image1" Format="dd/MM/yyyy">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr>
                       
                    </tr>
                    <tr>
                      
                    </tr>
                    <tr>
                        <td valign="top">
                            <asp:Label ID="Label2" runat="server" ForeColor="Black" CssClass="labelChange" Text="Staff Name"
                                Font-Bold="True"></asp:Label>
                        </td>
                        <td valign="top" align="center">
                            :
                        </td>
                        <td colspan="4" valign="middle" style="max-height: 200px; overflow: auto;">
                            <asp:CheckBox runat="server" ID="Allchk" Text="Select All" />
                            <br />
                            <div style="border: 1px solid #bcbcbc; Height:300px; width:500px; overflow: auto;">
                                <asp:CheckBoxList ID="chksStaff" runat="server">
                                </asp:CheckBoxList>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                        </td>
                        <td>
                            <asp:Button ID="btngen" runat="server" CssClass="TbleBtns" Text="Generate Report"
                                OnClick="btngen_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <rsweb:ReportViewer ID="ReportViewer1" Height="670px" Width="795px" Visible="false"
            runat="server" AsyncRendering="False" InteractivityPostBackMode="AlwaysAsynchronous">
        </rsweb:ReportViewer>
    </div>
</div>
