<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Staff_Profitability.ascx.cs" Inherits="controls_Staff_Profitability" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>

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
        var pin = document.getElementById("<%= txtstartdate1.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
            // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {

            alert("Invalid date format: " + pin);
            document.getElementById("<%= txtstartdate1.ClientID%>").focus();
            var days = pad2(day);
            var month = pad2(mon);
            document.getElementById("<%= txtstartdate1.ClientID%>").value = days + "/" + month + "/" + yr;
            return false;
        }
    }
    function checkForms() {
        // regular expression to match required date format
        var dt = new Date();
        var day = dt.getDate();
        var mon = dt.getMonth() + 1;
        var yr = dt.getFullYear();
        var pin = document.getElementById("<%= txtenddate2.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
            // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {

            alert("Invalid date format: " + pin);
            document.getElementById("<%= txtenddate2.ClientID%>").focus();
            var days = pad2(day);
            var month = pad2(mon);
            document.getElementById("<%= txtenddate2.ClientID%>").value = days + "/" + month + "/" + yr;
            return false;
        }
    }
</script>
<style type="text/css">
    .cssPageTitle {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        border-bottom: 2px solid #0b9322;
        padding: 7px;
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

    .cssPageTitle2 {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        /*border-bottom: 2px solid #0b9322;*/
        padding: 7px;
        color: #0b9322;
    }
</style>
<div class="divstyle" style="height: auto">
    <div class="headerpage">
        <div>
            <table style="width: 100%" class="cssPageTitle">
                <tr>
                    <td class="cssPageTitle2">
                        <asp:Label ID="Label8" runat="server" Style="margin-left: 50px;" Text="Staff Profitability salary"></asp:Label>
                    </td>
                    <td style="float: right; padding-top: 5px; margin-left: 60px;">
                        <asp:Button ID="btngen" runat="server"
                            CssClass="cssButton" Text="Generate Report" OnClick="btngen_Click" />
                    </td>
                </tr>
            </table>  
        </div>
    </div>
    <div id="div1" class="totbodycatreg">
        <%--<div class="headerstyle11">
        <div class="headerstyle112" style=" display:none;">
            <asp:Label ID="Label6" runat="server" Text="Staff Profitability vis-à-vis salary"
                CssClass="Head1" ForeColor="Black" Font-Names="Verdana" Font-Size="9pt"></asp:Label></div>
    </div>--%>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div style="width: 100%;">
                    <uc1:MessageControl ID="MessageControl1" runat="server" />
                </div>
                <div class="row_report">
                    <div>
                        <table class="style1" style="float: left; padding-left: 55px; padding-top: 15px;">
                            <tr>
                                <td class="style2">
                                    <table class="style1">
                                        <tr>
                                            <td class="style8">
                                                <asp:Label ID="Label2" runat="server" Font-Bold="True" Font-Names="Verdana"
                                                    Font-Size="8pt" ForeColor="Black" Text="Staff Name" CssClass="labelChange"></asp:Label>
                                            </td>
                                            <td align="right">
                                                <asp:CheckBox ID="chkjob1" runat="server" AutoPostBack="True" Text="Check All" OnCheckedChanged="chkjob1_CheckedChanged" ForeColor="Black" Font-Bold="true" Height="20px" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td class="style2">
                                    <div style="padding-bottom: 10px; width: 379px; float: left; height: 400px;">
                                        <asp:Panel ID="Panel1" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid"
                                            BorderWidth="1px" class="panel_style" Height="400px" ScrollBars="Auto"
                                            Width="352px">
                                            <asp:DataList ID="Staff_List" runat="server" ForeColor="Black" Width="340px">
                                                <ItemTemplate>
                                                    <div style="overflow: auto; width: 300px; float: left;">
                                                        <div style="overflow: auto; width: 30px; float: left;">
                                                            <asp:CheckBox ID="chkitem1" runat="server" />
                                                        </div>
                                                        <div class="dataliststyle">
                                                            <asp:Label ID="Label50" runat="server" Text='<%# bind("StaffName") %>'
                                                                Width="240px"></asp:Label>
                                                            <asp:Label ID="Label51" runat="server" Text='<%# bind("StaffCode") %>'
                                                                Visible="False" Width="10px"></asp:Label>
                                                        </div>
                                                    </div>
                                                </ItemTemplate>
                                                <ItemStyle Height="17px" />
                                            </asp:DataList>
                                            <asp:Label ID="Label3" runat="server" CssClass="errlabelstyle labelChange" Font-Bold="True" Text="No Staff Found" Visible="False"></asp:Label>
                                        </asp:Panel>
                                        &nbsp;<asp:Label ID="Label4" runat="server" CssClass="errlabelstyle"
                                            ForeColor="Red" Text="*"></asp:Label>
                                        <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                                            <ProgressTemplate>
                                                <img alt="loadting" src="../images/progress-indicator.gif" />
                                            </ProgressTemplate>
                                        </asp:UpdateProgress>
                                    </div>
                                </td>
                                <td style="vertical-align: top;">
                                    <table class="style1">
                                        <tr>
                                            <td align="right" class="style17">
                                                <asp:Label ID="Label5" runat="server" ForeColor="Black" Text="From"
                                                    Font-Bold="True"></asp:Label>
                                            </td>
                                            <td align="center" class="style18">:</td>
                                            <td>
                                                <asp:TextBox ID="txtstartdate1" runat="server" CssClass="texboxcls"></asp:TextBox>
                                                <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png"
                                                    Style="float: right; margin-right: 10px;" />
                                                <asp:Label ID="Label6" runat="server" CssClass="errlabelstyle" ForeColor="Red"
                                                    Text=""></asp:Label>
                                                <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtstartdate1"
                                                    PopupButtonID="Img1" Format="dd/MM/yyyy">
                                                </cc1:CalendarExtender>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" style="font: Bold; font-weight: bold;" class="style17">To</td>
                                            <td align="center" class="style18">:</td>
                                            <td>
                                                <asp:TextBox ID="txtenddate2" runat="server" CssClass="texboxcls"></asp:TextBox>
                                                <asp:Image ID="Img2" runat="server" ImageUrl="~/images/calendar.png" Style="float: right; margin-right: 10px;" />
                                                <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle" ForeColor="Red"
                                                    Text=""></asp:Label>
                                                <cc1:CalendarExtender ID="Calendarextender2" runat="server" TargetControlID="txtenddate2"
                                                    PopupButtonID="Img2" Format="dd/MM/yyyy">
                                                </cc1:CalendarExtender>
                                            </td>
                                        </tr>
                                        
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>
