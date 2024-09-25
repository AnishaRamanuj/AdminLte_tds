<%@ Control Language="C#" AutoEventWireup="true" CodeFile="All_ClientStaffJob1.ascx.cs"
    Inherits="controls_All_ClientStaffJob1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script runat="server">

    
</script>
<script src="jquery.js" type="text/javascript"></script>
<style type="text/css">
    .loading
    {
        font-family: Arial;
        font-size: 10pt;
        border: 5px solid #67CFF5;
        width: 200px;
        height: 100px;
        display: none;
        position: fixed;
        background-color: White;
        z-index: 999;
    }
</style>
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
        var pin = document.getElementById("<%= txtfrom.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
        // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {

            alert("Invalid date format: " + pin);
            document.getElementById("<%=txtfrom.ClientID%>").focus();
            var month = pad2(mon);
            var days = pad2(day);
            document.getElementById("<%=txtfrom.ClientID%>").value = days + "/" + month + "/" + yr;
            return false;
        }
    }
    function checkForms() {

        // regular expression to match required date format
        var dt = new Date();
        var day = dt.getDate();
        var mon = dt.getMonth() + 1;
        var yr = dt.getFullYear();
        var pin = document.getElementById("<%= txtto.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
        // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {

            alert("Invalid date format: " + pin);
            document.getElementById("<%= txtto.ClientID%>").focus();
            var month = pad2(mon);
            var days = pad2(day);
            document.getElementById("<%= txtto.ClientID%>").value = days + "/" + month + "/" + yr;
            return false;
        }
    }
    function ShowProgress() {
        setTimeout(function () {
            var modal = $('<div />');
            modal.addClass("modal");
            $('body').append(modal);
            var loading = $(".loading");
            loading.show();
            var top = Math.max($(window).height() / 2 - loading[0].offsetHeight / 2, 0);
            var left = Math.max($(window).width() / 2 - loading[0].offsetWidth / 2, 0);
            loading.css({ top: top, left: left });
        }, 200);
    }

    // Get the instance of PageRequestManager.
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    // Add initializeRequest and endRequest
    prm.add_initializeRequest(prm_InitializeRequest);
    prm.add_endRequest(prm_EndRequest);

    // Called when async postback begins
    function prm_InitializeRequest(sender, args) {
        // get the divImage and set it to visible
        var panelProg = $get('divImage');
        panelProg.style.display = '';
        // reset label text
        var lbl = $get('<%= this.lblText.ClientID %>');
        lbl.innerHTML = '';

        // Disable button that caused a postback
        //$get(args._postBackElement.id).disabled = true;
    }

    // Called when async postback ends
    function prm_EndRequest(sender, args) {
        // get the divImage and hide it again
        var panelProg = $get('divImage');
        panelProg.style.display = 'none';

        // Enable button that caused a postback
        $get(sender._postBackSettings.sourceElement.id).disabled = false;
    }

</script>
<div id="divtitl" class="totbodycatreg">
    <div class="loading" align="center" id="divImage">
        <asp:Label ID="lblText" runat="server" Text=""></asp:Label>
        Submitting Timesheet..<br />
        <br />
        <img src="../images/loader.gif" alt="" />
    </div>
    <div style="float: left;">
        <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px; width: 1155px;">
            <asp:Label ID="Label1" runat="server" Text="Job Detail Report" CssClass="Head1 labelChange"></asp:Label></div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="msg_container">
                <uc2:MessageControl ID="MessageControl2" runat="server" />
            </div>
            <div class="d_row">
                <div style="float: left; width: 300px; padding-left:35px; padding-top:15px;">
                    <div style="font-weight: bold; margin: 5px 0 0; height: 26px;">
                    <asp:CheckBox ID="chkJB" runat="server" AutoPostBack="True" Text=" Check All Job Name" CssClass="labelChange" ForeColor="Black" OnCheckedChanged="chkJB_CheckedChanged" />
                    </div>
                    <div style="overflow: auto; padding-bottom: 10px; float: left;">
                        <div style="overflow: hidden; padding-bottom: 0px; width: 320px; float: left;">
                            <asp:Panel ID="Panel7" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                Height="300px" ScrollBars="Auto" Style="width: 300px; padding-left: 10px; float: left;">
                                <asp:DataList ID="dljob" runat="server" ForeColor="Black" Width="250px" Font-Names="Verdana"
                                    Font-Size="8pt" Height="50px">
                                    <ItemTemplate>
                                        <div style="overflow: auto; width: 250px; float: left;">
                                            <div style="overflow: auto; width: 30px; float: left;">
                                                <asp:CheckBox ID="chkitem2" runat="server" AutoPostBack="True" OnCheckedChanged="chkitem2_CheckedChanged" />
                                            </div>
                                            <div class="dataliststyle">
                                                <asp:Label ID="Label55" runat="server" Text='<%# bind("MJobName") %>'></asp:Label>
                                                <asp:Label ID="Label56" runat="server" Text='<%# bind("MJobId") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="Label57" runat="server" CssClass="errlabelstyle" Font-Bold="True"
                                    Text="No Records Found" Visible="false"></asp:Label></div>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle Height="17px" />
                                </asp:DataList>
                                
                            </asp:Panel>
                        </div>
                    </div>
                </div>
                <div class="d_row" style="width:850px; float: left; margin-left: 10px; padding-top:15px;">
                    <div style="overflow: auto; padding-bottom: 10px; float: left; padding-left: 22px;">
                        <div style="overflow: hidden; padding-bottom: 0px; width: 340px; float: left;">
                            <div style="font-weight: bold; margin: 5px 0;">
                            <asp:CheckBox ID="chkCL" runat="server" AutoPostBack="True" Text=" Check All Client Name" CssClass="labelChange" ForeColor="Black" OnCheckedChanged="chkCL_CheckedChanged" />
                            </div>
                            <asp:Panel ID="Panel5" runat="server" Style="width: 320px; padding-left: 10px; float: left;"
                                BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px" Height="300px" ScrollBars="Auto">
                                <asp:DataList ID="dlclient" runat="server" Font-Names="Verdana" Font-Size="8pt" ForeColor="Black"
                                    Width="250px">
                                    <ItemTemplate>
                                        <div style="overflow: auto; width: 320px; float: left;">
                                            <div style="overflow: auto; width: 30px; float: left;">
                                                <asp:CheckBox ID="chkitem1" runat="server" />
                                            </div>
                                            <div class="dataliststyle">
                                                <asp:Label ID="Label50" runat="server" Text='<%# bind("ClientName") %>'></asp:Label>
                                                <asp:Label ID="Label51" runat="server" Text='<%# bind("CLTId") %>' Visible="False"></asp:Label>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle Height="17px" />
                                </asp:DataList>
                            </asp:Panel>
                            &nbsp;
                            <asp:Label ID="Label28" runat="server" CssClass="errlabelstyle" Font-Bold="True"
                                Font-Names="Verdana" Font-Size="9pt" Text="No Records Found" Visible="False"></asp:Label>
                        </div>
                        <div style="width: 350px; float: left; padding-left:25px; ">
                            <div style="font-weight: bold; margin: 5px 0;">
                                <asp:CheckBox ID="ChkST" runat="server" AutoPostBack="True" Text=" Check All Staff Name" ForeColor="Black"
                                        OnCheckedChanged="ChkST_CheckedChanged" />
                            </div>
                            <div style="overflow: auto; padding-bottom: 0px; width: 350px; float: left;">
                                <asp:Panel ID="Panel6" runat="server" Style="width: 320px; padding-left: 10px; float: left;"
                                    ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                    Height="300px">
                                    <asp:DataList ID="dlstaff" runat="server" Font-Names="Verdana" Font-Size="8pt" ForeColor="Black"
                                        Width="318px">
                                        <ItemTemplate>
                                            <div style="overflow: auto; width: 270px; float: left;">
                                                <div style="overflow: auto; width: 30px; float: left;">
                                                    <asp:CheckBox ID="chkitem" runat="server" OnCheckedChanged="chkitem_CheckedChanged" />
                                                </div>
                                                <div class="dataliststyle">
                                                    <asp:Label ID="Label50" runat="server" Text='<%# bind("StaffName") %>'></asp:Label>
                                                    <asp:Label ID="Label51" runat="server" Text='<%# bind("StaffCode") %>' Visible="False"></asp:Label>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                        <ItemStyle Height="17px" />
                                    </asp:DataList>
                                </asp:Panel>
                                &nbsp;
                                <asp:Label ID="Label31" runat="server" CssClass="errlabelstyle" Font-Bold="True"
                                    Font-Names="Verdana" Font-Size="9pt" Text="No Records Found" Visible="False"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="d_row" style="float: left; height:200px; padding-left:85px; padding-top:15px; width: 100%;">
                    <div style="overflow: auto; padding-bottom: 10px; font-weight: bold; float: left;
                        padding-top: 10px;">
                        <asp:Label ID="Label5" runat="server" Text=" From :"></asp:Label>
                    </div>
                    <div style="padding-left: 5px; padding-top: 5px; float: left;">
                        <div style="overflow: auto; float: left;">
                            <asp:TextBox ID="txtfrom" runat="server" CssClass="txtnrml texboxcls" Width="100px"></asp:TextBox></div>
                        <div style="float: left;">
                            <asp:Image ID="Image18" runat="server" ImageUrl="~/images/calendar.png" /></div>
                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtfrom"
                            PopupButtonID="Image18" Format="dd/MM/yyyy">
                        </cc1:CalendarExtender>
                    </div>
                    <div style="overflow: auto; padding-left: 15px; width: 28px; font-weight: bold; float: left;
                        text-align: right; padding-top: 10px;">
                        <asp:Label ID="Label6" runat="server" Text="To :"></asp:Label>
                    </div>
                    <div style="padding-left: 5px; padding-top: 5px; float: left;">
                        <div style="overflow: auto; float: left;">
                            <asp:TextBox ID="txtto" runat="server" CssClass="txtnrml texboxcls" Width="100px"></asp:TextBox></div>
                        <div style="overflow: auto; float: left; padding-right: 5px">
                            <asp:Image ID="Image1" runat="server" ImageUrl="~/images/calendar.png" /></div>
                        <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtto"
                            PopupButtonID="Image1" Format="dd/MM/yyyy">
                        </cc1:CalendarExtender>
                    </div>
                    <div style="margin: 0 0 10px; float: left; ">
                        <asp:Button ID="btngenerate1" runat="server" Text="Generate Report" CssClass="TbleBtns"
                            OnClick="btngenerate1_Click1" />
                    </div>
                    <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left; padding-left: 150px;">
                        <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                            <ProgressTemplate>
                                <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                        </asp:UpdateProgress>
                    </div>
                </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
