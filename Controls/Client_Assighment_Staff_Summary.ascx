<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Client_Assighment_Staff_Summary.ascx.cs" Inherits="controls_Client_Assighment_Staff_Summary" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />    

 
 
<div class="divstyle" style="height: auto">
            <div class="headerpage">
                <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
                    <asp:Label ID="Label3" runat="server" CssClass="Head1 labelChange"  Text="Client Assignment - Staff Summary" ></asp:Label>
                </div>
            </div>
       
<div id="div2" class="totbodycatreg">        
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
        <div style="width: 100%;">
        <uc2:MessageControl ID="MessageControl2" runat="server" />
    </div>
            <div class="row_report">
                <div>
                   
                     <table class="style1" style="float: left; padding-left:55px; padding-top:15px;">
                        <tr>
                            <td class="style2">
                                <table class="style1">
                                    <tr>
                                        <td class="style8">
                                            <asp:Label ID="Label16" runat="server" Font-Bold="True" Font-Names="Verdana" 
                                                Font-Size="8pt" ForeColor="Black" Text="Client Name" CssClass="labelChange"></asp:Label>
                                        </td>
                                        <td align="left">
                                            <asp:CheckBox ID="chkclient" runat="server" AutoPostBack="True" ForeColor="Black" Font-Bold="true" 
                                                Height="20px" OnCheckedChanged="chkclient_CheckedChanged" Text=" Check All" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td class="style2" width="380px">
                                <div style="padding-bottom: 10px; width: 379px; float: left; height:400px;">
                                    <asp:Panel ID="Panel4" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" 
                                        BorderWidth="1px" class="panel_style" Height="400px" ScrollBars="Auto" 
                                        Width="352px">
                                        <asp:DataList ID="dlclient" runat="server" ForeColor="Black" Width="340px">
                                            <ItemTemplate>
                                                <div style="overflow: auto; width: 300px; float: left;">
                                                    <div style="overflow: auto; width: 30px; float: left;">
                                                        <asp:CheckBox ID="chkitem2" runat="server" />
                                                    </div>
                                                    <div class="dataliststyle">
                                                        <asp:Label ID="Label50" runat="server" Text='<%# bind("ClientName") %>' 
                                                            Width="240px"></asp:Label>
                                                        <asp:Label ID="Label51" runat="server" Text='<%# bind("CLTId") %>' 
                                                            Visible="False" Width="10px"></asp:Label>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                            <ItemStyle Height="17px" />
                                        </asp:DataList>
                                        <asp:Label ID="Label17" runat="server" CssClass="errlabelstyle" 
                                            Font-Bold="True" Text="No Records Found" Visible="False"></asp:Label>
                                    </asp:Panel>
                                    &nbsp;<asp:Label ID="Label18" runat="server" CssClass="errlabelstyle" 
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
                                            <asp:TextBox ID="fromdate" runat="server" CssClass="texboxcls" ></asp:TextBox>
                                            <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" 
                                                style="float: left; margin-right: 10px;" />
                                           
                                                <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="fromdate"
                                                    PopupButtonID="Img1" Format="dd/MM/yyyy">
                                                </cc1:CalendarExtender>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" style="font:Bold; font-weight: bold;" class="style17">
                                            To </td>
                                        <td align="center" class="style18">
                                            :</td>
                                        <td>
                                            <asp:TextBox ID="txtenddate" runat="server" CssClass="texboxcls"></asp:TextBox>
                                            <asp:Image ID="Img2" runat="server" ImageUrl="~/images/calendar.png" 
                                                style="float: left; margin-right: 10px;" />
                                          
                                                <cc1:CalendarExtender ID="Calendarextender2" runat="server" TargetControlID="txtenddate"
                        PopupButtonID="Img2" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                                        </td>
                                    </tr>
                                  
                                    <tr>
								<td></td>
								<td></td>
                                        <td align="left">
                                            <asp:Button ID="btngenerate" runat="server" CssClass="TbleBtns" OnClick="btngenerate_Click" 
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

