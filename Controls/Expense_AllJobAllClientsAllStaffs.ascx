<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Expense_AllJobAllClientsAllStaffs.ascx.cs" Inherits="controls_Expense_AllJobAllClientsAllStaffs" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
    function pad2(number) {
        return (number < 10 ? '0' : '') + number
    }
    function checkForm() {

        // regular expression to match required date format
        var dt = new Date();
        var day = dt.getDate();
        var mon = dt.getMonth() + 1;
        var yr = dt.getFullYear();
        var pin = document.getElementById("<%= txtfr.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
            // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {

            alert("Invalid date format: " + pin);
            document.getElementById("<%=txtfr.ClientID%>").focus();
            var month = pad2(mon);
            var days = pad2(day);
            document.getElementById("<%=txtfr.ClientID%>").value = days + "/" + month + "/" + yr;
            return false;
        }
    }
    function checkForms() {

        // regular expression to match required date format
        var dt = new Date();
        var day = dt.getDate();
        var mon = dt.getMonth() + 1;
        var yr = dt.getFullYear();
        var pin = document.getElementById("<%= txtend.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
            // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {

            alert("Invalid date format: " + pin);
            document.getElementById("<%= txtend.ClientID%>").focus();
            var month = pad2(mon);
            var days = pad2(day);
            document.getElementById("<%= txtend.ClientID%>").value = days + "/" + month + "/" + yr;
                return false;
            }
        }
</script>
<style type="text/css">
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
<div id="div4" class="totbodycatreg">
    <table class="cssPageTitle" style="width: 100%;">
        <tr>
            <td class="cssPageTitle2">
                <asp:Label ID="lblname" runat="server" Text="All Jobs Clients Staffs Report" Style="margin-left: 10px;"></asp:Label>
            </td>
            <td style="float: right; padding-top: 5px; margin-left: 60px;">
                <asp:Button ID="btngenexp" runat="server" OnClick="btngenexp_Click" CssClass="cssButton"
                    Text="Generate Report" />
            </td>
        </tr>
    </table>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
     
        <ContentTemplate>
            <div style="margin-left:20px;">
            <div style="overflow: auto; width: 100%; padding-left: 5px; padding-right: 5px; float: left;">
                <uc2:MessageControl ID="MessageControl2" runat="server" />
            </div>
            <div style="overflow: auto; padding-bottom: 10px; font-weight: bold; float: left; padding-top: 10px;">
                <asp:Label ID="Label65" runat="server" Text="From : " ForeColor="Black"></asp:Label>
            </div>
            <div style="padding-left: 5px; padding-top: 5px; float: left;">
                <div style="overflow: auto; float: left;">
                    <asp:TextBox ID="txtfr" runat="server" CssClass="texboxcls" Width="100px"></asp:TextBox>
                </div>
                <div style="float: left;">
                   <asp:Image ID="Image8" runat="server" ImageUrl="~/images/calendar.png" />
                </div>
                 <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle"
                                            ForeColor="Red" Text=""></asp:Label>
                <cc1:CalendarExtender ID="Calendarextender7" runat="server" TargetControlID="txtfr"
                    PopupButtonID="Image8" Format="dd/MM/yyyy">
                </cc1:CalendarExtender>
                
            </div>
            <div style="overflow: auto; width: 29px; font-weight: bold; float: left; text-align: right; padding-top: 10px; padding-left: 20px;">
                <asp:Label ID="Label67" runat="server" Text="To : " ForeColor="Black"></asp:Label>
            </div>
            <div style="padding-left: 5px; padding-top: 5px; float: left;">
                <div style="overflow: auto; float: left;">
                    <asp:TextBox ID="txtend" runat="server" CssClass="texboxcls" Width="100px"></asp:TextBox>
                </div>
                <div style="overflow: auto; float: left; padding-right: 5px">
                    <asp:Image ID="Image9" runat="server" ImageUrl="~/images/calendar.png" />
                </div>
                <cc1:CalendarExtender ID="Calendarextender8" runat="server" TargetControlID="txtend"
                    PopupButtonID="Image9" Format="dd/MM/yyyy">
                </cc1:CalendarExtender>
            </div>

            <div class="d_row">
                <table style="padding-top: 15px;">
                    <tr>
                        <td>
                            <asp:CheckBox ID="chkclope" runat="server" AutoPostBack="True" Font-Bold="true" Text=" Check All Client Name" CssClass="labelChange"
                                OnCheckedChanged="chkclope_CheckedChanged" ForeColor="Black" /></td>
                        <td>
                            <asp:CheckBox ID="chkstope" runat="server" AutoPostBack="True" Font-Bold="true" CssClass="labelChange" Text=" Check All Staff Name"
                                OnCheckedChanged="chkstope_CheckedChanged" ForeColor="Black" /></td>
                        <td>
                            <asp:CheckBox ID="chkjobope" runat="server" AutoPostBack="True" Font-Bold="true" Text=" Check All Job Name" CssClass="labelChange"
                                OnCheckedChanged="chkjobope_CheckedChanged" ForeColor="Black" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Panel ID="Panel9" runat="server" Style="width: 320px; padding-left: 10px; float: left;"
                                ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                Height="450px">
                                <asp:DataList ID="DlstCLT" runat="server" Width="282px" ForeColor="Black">
                                    <ItemTemplate>
                                        <div style="overflow: auto; width: 250px; float: left;">
                                            <div style="overflow: auto; width: 30px; float: left;">
                                                <asp:CheckBox ID="chkitem" runat="server" AutoPostBack="True"
                                                    OnCheckedChanged="chkitem_CheckedChanged" />
                                            </div>
                                            <div class="dataliststyle">
                                                <asp:Label ID="Label50" runat="server" Text='<%# bind("CLTId") %>' Visible="False"></asp:Label>
                                                <asp:Label ID="Label51" runat="server" Text='<%# bind("ClientName") %>'></asp:Label>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle Height="17px" />
                                </asp:DataList>
                                <asp:Label ID="Label60" runat="server" CssClass="errlabelstyle labelChange" Text="No Clients Found"
                                    Font-Bold="True" Visible="false"></asp:Label>
                            </asp:Panel>
                        </td>
                        <td>
                            <asp:Panel ID="Panel11" runat="server" Style="width: 320px; padding-left: 10px; float: left;"
                                ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                Height="450px">
                                <asp:DataList ID="DlstStf" runat="server" Width="255px" ForeColor="Black">
                                    <ItemTemplate>
                                        <div style="overflow: auto; width: 200px; float: left;">
                                            <div style="overflow: auto; width: 30px; float: left;">
                                                <asp:CheckBox ID="chkitem" runat="server" />
                                            </div>
                                            <div class="dataliststyle">
                                                <asp:Label ID="Label50" runat="server" Text='<%# bind("StaffCode") %>' Visible="False"></asp:Label>
                                                <asp:Label ID="Label51" runat="server" Text='<%# bind("StaffName") %>'></asp:Label>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle Height="17px" />
                                </asp:DataList>
                                <asp:Label ID="Label70" runat="server" CssClass="errlabelstyle labelChange" Text="No Staffs Found"
                                    Font-Bold="True" Visible="False"></asp:Label>
                            </asp:Panel>
                        </td>
                        <td style="vertical-align: top;">
                            <asp:Panel ID="Panel10" runat="server" Style="width: 320px; padding-left: 10px; float: left;"
                                ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                Height="450px">
                                <asp:DataList ID="DlstJob" runat="server" Width="330px" ForeColor="Black">
                                    <ItemTemplate>
                                        <div style="overflow: auto; width: 300px; float: left;">
                                            <div style="overflow: auto; width: 30px; float: left;">
                                                <asp:CheckBox ID="chkitem" runat="server" />
                                            </div>
                                            <div class="dataliststyle">
                                                <asp:Label ID="Label50" runat="server" Text='<%# bind("mJobId") %>' Visible="False"></asp:Label>
                                                <asp:Label ID="Label51" runat="server" Text='<%# bind("mJobName") %>'></asp:Label>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle Height="17px" />
                                </asp:DataList>
                                <asp:Label ID="Label63" runat="server" CssClass="errlabelstyle labelChange" Text="No Jobs Found"
                                    Font-Bold="True" Visible="false"></asp:Label>
                            </asp:Panel>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <div class="d_row" style="height: 230px;">
                                <div style="overflow: auto; padding-bottom: 10px; width: 100%; float: left; padding-left: 150px;">
                                    <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                                        <ProgressTemplate>
                                            <img alt="loadting" src="../images/progress-indicator.gif" />
                                        </ProgressTemplate>
                                    </asp:UpdateProgress>
                                </div>
                            </div>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                </table>
                <%--<div style="overflow: auto; padding-bottom: 10px; padding-top: 10px; width: 100%;
                float: left;">
                <div style="overflow: auto; padding-bottom: 10px; width: 20%; float: left; padding-left: 5%">
                </div>
                
            </div>--%>
                </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
