<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Staff_AllClientAllExpenses.ascx.cs" Inherits="controls_Staff_AllClientAllExpenses" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register src="MessageControl.ascx" tagname="MessageControl" tagprefix="uc2" %>
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

<div class="divstyle" style="height: auto">
            <div class="headerpage">
                <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
                    <asp:Label ID="Label1" runat="server" CssClass="Head1 labelChange"  Text="Client wise Expenses" ></asp:Label>
                </div>
            </div>
       
<div id="div2" class="totbodycatreg">        
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
        <div>
        <uc2:MessageControl ID="MessageControl2" runat="server" />
    </div>
            <div class="row_report">
                <div>
                   
                     <table class="style1" style="float: left; padding-left:55px; padding-top:15px;">
                        <tr>
                            <td class="style2">
                                <table class="style1">
                                    <tr>
                                        
                                        <td align="right">
                                            <asp:CheckBox ID="CheckBox1" runat="server" AutoPostBack="True" ForeColor="Black" Font-Bold="true" 
                                                Height="20px" OnCheckedChanged="CheckBox1_CheckedChanged" CssClass="labelChange" Text=" Check All Staff Name" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td class="style2"  style="width:400px;">
                                <div style="padding-bottom: 10px; width: 379px; float: left; height:400px;">
                                    <asp:Panel ID="Panel4" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" 
                                        BorderWidth="1px" class="panel_style" Height="400px" ScrollBars="Auto" 
                                        Width="352px">
                                        <asp:DataList ID="DataList8" runat="server" ForeColor="Black" Width="340px">
                                            <ItemTemplate>
                                                <div style="overflow: auto; width: 300px; float: left;">
                                                    <div style="overflow: auto; width: 30px; float: left;">
                                                        <asp:CheckBox ID="chkitem" runat="server" />
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
                                        <asp:Label ID="Label17" runat="server" CssClass="errlabelstyle labelChange" 
                                            Font-Bold="True" Text="No Staff Found" Visible="False"></asp:Label>
                                    </asp:Panel>
                                   
                                    <asp:UpdateProgress ID="UpdateProgress2" runat="server" 
                                        AssociatedUpdatePanelID="UpdatePanel2">
                                        <ProgressTemplate>
                                            <img alt="loadting" src="../images/progress-indicator.gif" />
                                            &nbsp;
                                        </ProgressTemplate>
                                    </asp:UpdateProgress>
                                </div>
                            </td>
                            <td style="vertical-align: top;">
                                <table class="style1">
                                    <tr>
                                        <td align="right" class="style17">
                                            <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From" 
                                                Font-Bold="True"></asp:Label>
                                        </td>
                                        <td align="center" class="style18">
                                            :</td>
                                        <td>
                                            <asp:TextBox ID="txtstartdate1" runat="server" CssClass="texboxcls"></asp:TextBox>&nbsp;&nbsp;
                                            <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" 
                                                style="float: left; margin-right: 10px;" />
                                            <asp:Label ID="Label2" runat="server" CssClass="errlabelstyle" ForeColor="Red" 
                                                Text=""></asp:Label>
                                                <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtstartdate1"
                                                    PopupButtonID="Img1" Format="dd/MM/yyyy">
                                                </cc1:CalendarExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" style="font:Bold; font-weight: bold;" class="style17" >
                                            To</td>
                                        <td align="center" class="style18">
                                            :</td>
                                        <td>
                                            <asp:TextBox ID="txtenddate2" runat="server" CssClass="texboxcls"></asp:TextBox>
                                            &nbsp;<asp:Image ID="Img2" runat="server" ImageUrl="~/images/calendar.png" 
                                                style="float: left; margin-right: 10px;" />
                                            
                                                <cc1:CalendarExtender ID="Calendarextender2" runat="server" TargetControlID="txtenddate2"
                        PopupButtonID="Img2" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                                        </td>
                                    </tr>
                                   
                                    <tr>
									<td></td>
									<td></td>
					
                                        <td align="left" class="style15" colspan="3">
                                            <asp:Button ID="btngen" runat="server" CssClass="TbleBtns"  OnClick="btngen_Click" 
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



