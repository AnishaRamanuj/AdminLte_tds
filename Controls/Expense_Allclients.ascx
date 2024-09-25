<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Expense_Allclients.ascx.cs"
    Inherits="controls_Expense_Allclients" %>
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
<div id="div4" class="totbodycatreg">
    <table class="cssPageTitle" style="width: 100%;">
        <tr>
            <td class="cssPageTitle2">
                <asp:Label ID="lblname" runat="server" Text="All Clients" Style="margin-left: 10px;"></asp:Label>
            </td>
            <td style="float: right; padding-top: 5px; margin-left: 60px;">
                <asp:Button ID="btngenexp" runat="server" OnClick="btngenexp_Click" CssClass="cssButton"
                    Text="Generate Report" />
            </td>
        </tr>
    </table>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="msg_container">
                <uc2:MessageControl ID="MessageControl2" runat="server" />
                <asp:HiddenField ID="hdnHod" runat="server" />
            </div>
             <div style="overflow: auto; padding-bottom: 10px; font-weight: bold; float: left; padding-right: 10px; padding-top: 11px;">
                        <asp:Label ID="Label65"  style="margin-left:10px;" runat="server" Text="From : " ForeColor="Black"></asp:Label>
                    </div>
                    <div style="padding-top: 5px; float: left;">
                        <div style="overflow: auto; float: left;">
                            <asp:TextBox ID="txtfr" runat="server" CssClass="txtnrml texboxcls" Width="100px"></asp:TextBox>
                        </div>
                        <div style="overflow: auto; float: left; padding-right: 5px">
                            <asp:Image ID="Image8" runat="server" ImageUrl="~/images/calendar.png" />
                        </div>
                        <cc1:CalendarExtender ID="Calendarextender7" runat="server" TargetControlID="txtfr"
                            PopupButtonID="Image8" Format="dd/MM/yyyy">
                        </cc1:CalendarExtender>
                    </div>
                    <div style="overflow: auto; width: 29px; font-weight: bold; float: left; text-align: right; padding-top: 10px; padding-left: 20px;">
                        <asp:Label ID="Label67" runat="server" Text="To : " ForeColor="Black"></asp:Label>
                    </div>
                    <div style="overflow: auto; padding-left: 5px; padding-top: 5px; float: left;">
                        <div style="float: left;">
                            <asp:TextBox ID="txtend" runat="server" CssClass="txtnrml texboxcls" Width="100px"></asp:TextBox>
                        </div>
                        <div style="overflow: auto; float: left; padding-right: 5px">
                            <asp:Image ID="Image9" runat="server" ImageUrl="~/images/calendar.png" />
                        </div>
                        <cc1:CalendarExtender ID="Calendarextender8" runat="server" TargetControlID="txtend"
                            PopupButtonID="Image9" Format="dd/MM/yyyy">
                        </cc1:CalendarExtender>
                    </div>
            <div class="d_row">
                <div class="panel_headerstyle" style=" font-weight: bold;width: 100%;">
                   
                    <asp:CheckBox ID="chkclope" runat="server" style="margin-left:65px;" AutoPostBack="True" Text="Client " CssClass="labelChange"
                        OnCheckedChanged="chkclope_CheckedChanged" ForeColor="Black" />
                </div>
                <div style="overflow: auto; padding-bottom: 10px; width: 650px; padding-left: 55px; float: left;">
                    <asp:Panel ID="Panel9" runat="server" Style="width: 500px; padding-left: 10px; float: left;"
                        ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                        Height="400px">
                        <asp:DataList ID="DataList3" runat="server" Width="300px" ForeColor="Black">
                            <ItemTemplate>
                                <div style="overflow: auto; width: 300px; float: left;">
                                    <div style="overflow: auto; width: 30px; float: left;">
                                        <asp:CheckBox ID="chkitem" runat="server" />
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
                </div>
            </div>
            <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; padding-left: 55px; width: 100%; float: left;">

                <%--<div style="overflow: auto; padding-bottom: 10px; float: left;">
                    <asp:Button ID="btngenexp" runat="server" Text="Generate Report" CssClass="TbleBtns"
                        OnClick="btngenexp_Click" />
                </div>--%>
            </div>
            <div class="d_row">
                <div class="col_lft">
                </div>
                <div style="overflow: auto; padding-bottom: 10px; width: 100%; float: left; padding-left: 150px;">
                    <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                        <ProgressTemplate>
                            <img alt="loadting" src="../images/progress-indicator.gif" />
                        </ProgressTemplate>
                    </asp:UpdateProgress>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
