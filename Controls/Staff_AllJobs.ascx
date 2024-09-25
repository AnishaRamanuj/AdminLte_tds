<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Staff_AllJobs.ascx.cs" Inherits="controls_Staff_AllJobs" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register src="MessageControl.ascx" tagname="MessageControl" tagprefix="uc1" %>
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
        var pin = document.getElementById("<%= fromdate.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
        // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {

            alert("Invalid date format: " + pin);
            document.getElementById("<%= fromdate.ClientID%>").focus();
            var days = pad2(day);
            var month = pad2(mon);
            document.getElementById("<%= fromdate.ClientID%>").value = days + "/" + month + "/" + yr;
            return false;
        }
    }
    function checkForms() {
        // regular expression to match required date format
        var dt = new Date();
        var day = dt.getDate();
        var mon = dt.getMonth() + 1;
        var yr = dt.getFullYear();
        var pin = document.getElementById("<%= txtenddate.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
        // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {

            alert("Invalid date format: " + pin);
            document.getElementById("<%= txtenddate.ClientID%>").focus();
            var days = pad2(day);
            var month = pad2(mon);
            document.getElementById("<%= txtenddate.ClientID%>").value = days + "/" + month + "/" + yr;
            return false;
        }
    }
       </script>

<div class="divstyle" style="height: auto">           
            <div class="headerpage">
                <div class="headerstyle1_page">
                    <asp:Label ID="Label2" runat="server" CssClass="Head1"  Text="All Jobs Report" ></asp:Label>
                </div>
            </div>
<div id="div2" class="totbodycatreg">        
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
        <div>
        <uc1:MessageControl ID="MessageControl1" runat="server" />
    </div>
            <div class="row_report">
                <div>
                   
                    <table class="style1" style="float:left; width:100%;">
                        <tr>
                            <td class="style2">
                                <table class="style1">
                                    <tr>
                                        <td class="style8">
                                            <asp:Label ID="Label10" runat="server" Font-Bold="True" Font-Names="Verdana" 
                                                Font-Size="8pt" ForeColor="Black" Text="Staff Name"></asp:Label>
                                        </td>
                                        <td align="right">
                                            <asp:DropDownList ID="drpstafflist" runat="server" DataTextField="StaffName" DataValueField="StaffCode"
                                                 Height="20px" CssClass="stf_drop texboxclsselect"
                                                AutoPostBack="True"           
                                                AppendDataBoundItems="True" 
                                                onselectedindexchanged="drpstafflist_SelectedIndexChanged">
                                                <asp:ListItem Value="0">--Select--</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
							
                                        <td class="style8" style="padding-top:10px;">
                                            <asp:Label ID="Label16" runat="server" Font-Bold="True" Font-Names="Verdana" 
                                                Font-Size="8pt" ForeColor="Black" Text="Select Job"></asp:Label>
                                        </td>
                                        <td align="left" style="padding-top:10px;">
                                            <asp:CheckBox ID="chkjob" runat="server" AutoPostBack="True" ForeColor="Black" Font-Bold="true" 
                                                OnCheckedChanged="chkjob_CheckedChanged" Text=" Check All" />
                                        </td>

                                    </tr>
                                </table>
                            </td>
                            <td>
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td class="style2" style="width:380px;">
                                <div style="padding-bottom: 10px; width: 379px; float: left; height:400px;">
                                    <asp:Panel ID="Panel4" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" 
                                        BorderWidth="1px" class="panel_style" Height="400px" ScrollBars="Auto" 
                                        Width="352px">
                                        <asp:DataList ID="DataList2" runat="server" ForeColor="Black" Width="340px">
                                            <ItemTemplate>
                                                <div style="overflow: auto; width: 300px; float: left;">
                                                    <div style="overflow: auto; width: 30px; float: left;">
                                                        <asp:CheckBox ID="chkitem1" runat="server" />
                                                    </div>
                                                    <div class="dataliststyle">
                                                        <asp:Label ID="Label50" runat="server" Text='<%# bind("mJobName") %>' 
                                                            Width="240px"></asp:Label>
                                                        <asp:Label ID="Label51" runat="server" Text='<%# bind("mJobId") %>' 
                                                            Visible="False" Width="10px"></asp:Label>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                            <ItemStyle Height="17px" />
                                        </asp:DataList>
                                        <asp:Label ID="Label17" runat="server" CssClass="errlabelstyle" 
                                            Font-Bold="True" Text="No Staff Found" Visible="False"></asp:Label>
                                    </asp:Panel>
                                    &nbsp;<asp:Label ID="Label1" runat="server" CssClass="errlabelstyle" 
                                        ForeColor="Red" Text=""></asp:Label>
                                    <asp:UpdateProgress ID="UpdateProgress1" runat="server" 
                                        AssociatedUpdatePanelID="UpdatePanel2">
                                        <ProgressTemplate>
                                            <img alt="loadting" src="../images/progress-indicator.gif" />
                                            &nbsp;
                                        </ProgressTemplate>
                                    </asp:UpdateProgress>
                                </div>
                            </td>
                            <td  style="vertical-align: top;">
                                <table>
                                    <tr>
                                        <td align="right" class="style17">
                                            <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="Date" 
                                                Font-Bold="True"></asp:Label>
                                        </td>
                                        <td align="center" class="style18">
                                            :</td>
                                        <td>
                                            <asp:TextBox ID="fromdate" runat="server" CssClass="texboxcls"></asp:TextBox>
                                            <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" 
                                                style="float: right; margin-right: 10px;" />
                                            <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red" 
                                                Text=""></asp:Label>
                                                <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="fromdate"
                                                    PopupButtonID="Img1" Format="dd/MM/yyyy">
                                                </cc1:CalendarExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" style="font:Bold; font-weight: bold;" class="style17">
                                            To</td>
                                        <td align="center" class="style18">
                                            :</td>
                                        <td>
                                            <asp:TextBox ID="txtenddate" runat="server" CssClass="texboxcls" ></asp:TextBox>
                                            <asp:Image ID="Img2" runat="server" ImageUrl="~/images/calendar.png" 
                                                style="float: right; margin-right: 10px;" />
                                            <asp:Label ID="Label6" runat="server" CssClass="errlabelstyle" ForeColor="Red" 
                                                Text=""></asp:Label>
                                                <cc1:CalendarExtender ID="Calendarextender2" runat="server" TargetControlID="txtenddate"
                        PopupButtonID="Img2" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                                        </td>
                                    </tr>
                                   
                                    <tr>
									 <td></td>
									 <td></td>
                                        <td align="left" class="style15">
                                            <asp:Button ID="Button1" runat="server" CssClass="TbleBtns" OnClick="btngenerate_Click" 
                                                Text="Generate Report" />

                                        </td>
                                    </tr>
                               
                                </table>
                            </td>
                        </tr>
                    </table>
                   
                </div>
                
            </div>           
             
        <%--<div class="notes">
        <asp:Label ID="Label23" runat="server" Font-Bold="True" ForeColor="Black" 
                     Text="Notes:"></asp:Label>
            <div id="msghead" class="totbodycatreg" style="overflow: auto; padding-left: 0px">
                <span class="labelstyle" style="overflow: auto; color: Red; font-size: smaller; padding-left:0px;">Fields
                    marked with * are required</span>
            </div>
        </div>--%>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
</div>


 
