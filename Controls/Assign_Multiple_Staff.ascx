<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Assign_Multiple_Staff.ascx.cs" Inherits="controls_Assign_Multiple_Staff" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />  
<script language="javascript" type="text/javascript">
    function pad2(number) {
        return (number < 10 ? '0' : '') + number
    }
       </script>

      <div id="div4" class="totbodycatreg">
    <div class="headerstyle11">
        <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
            <asp:Label ID="Label2" runat="server" Text="Job Group Allocation"
                CssClass="Head1 labelChange" ></asp:Label></div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="overflow: auto; width: 100%;">
                <uc2:MessageControl ID="MessageControl" runat="server" />
            </div>
         
            <div style="padding-left:165px; padding-right:15px; width:900px;">
            <table>
            <tr>
            <td style="width:500px;"> <asp:Label ID="Label69" runat="server" Text="Staff Name"  Font-Bold="true" CssClass="labelChange" style=" font-weight:bold; margn-bottom:5px;"></asp:Label></td>
            <td> <asp:Label ID="Label1" runat="server" Text="Job Group" Font-Bold="true" CssClass="labelChange"></asp:Label><asp:CheckBox ID="ChkJgrp" runat="server" Font-Bold="true"  AutoPostBack="True" Text=" Check All"
                                 ForeColor="Black" oncheckedchanged="ChkJgrp_CheckedChanged" /></td>
            </tr>
            <tr>
            <td><asp:Panel ID="Panel10" runat="server" Style="width: 350px;  float: left;"
                        ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                        Height="150px">

                        <asp:DropDownList ID="drpStf" runat="server" CssClass="dropstyle" DataTextField="StaffName"
                            DataValueField="StaffCode" Autopostback="true" Width="350px"
                            onselectedindexchanged="drpStf_SelectedIndexChanged"/>


                            <asp:Label ID="Label70" runat="server" CssClass="errlabelstyle labelChange" Text="No Staffs Found"
                                Font-Bold="True" Visible="False"></asp:Label>

                    </asp:Panel></td>
            <td><asp:Panel ID="Panel11" runat="server" Style="width: 350px; padding-left: 10px; float: left;"
                            ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                            Height="150px">
                        <asp:DataList ID="DLstJgrp" runat="server" ForeColor="Black">
                            <ItemTemplate>
                                <div style="overflow: auto; width: 240px; float: left;">
                                    <div style="overflow: auto; width: 30px; float: left;">
                                        <asp:CheckBox ID="chkitmJrp" runat="server"  
                                           Autopostback="true" oncheckedchanged="chkitmJrp_CheckedChanged"  />
                                              
                                    </div>
                                    <div class="dataliststyle">
                                        <asp:Label ID="Label50" runat="server" Text='<%# bind("JobGId") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="Label51" runat="server" Text='<%# bind("JobGroupName") %>'></asp:Label>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <ItemStyle Height="17px" />
                        </asp:DataList>

                        <asp:Label ID="Label3" runat="server" CssClass="errlabelstyle labelChange" Text="No Job Groups Found"
                            Font-Bold="True" Visible="false"></asp:Label>
                       </asp:Panel></td>
            </tr>
            <tr>
            <td><asp:Label ID="Label62" runat="server" Text="Job Name" Font-Bold="true"  CssClass="labelChange"></asp:Label> <asp:CheckBox ID="chkjob" runat="server" Font-Bold="true"  AutoPostBack="True" Text=" Check All"
                                    OnCheckedChanged="chkjob_CheckedChanged" ForeColor="Black" /></td>
            <td><asp:Label ID="Label59" runat="server" Text="Client Name" Font-Bold="true" 	 CssClass="labelChange"></asp:Label><asp:CheckBox ID="chkclient" runat="server" Font-Bold="true"  AutoPostBack="True" Text=" Check All"
                                OnCheckedChanged="chkclient_CheckedChanged" ForeColor="Black" /></td>
            </tr>
            <tr>
            <td><asp:Panel ID="Panel9" runat="server" Style="width: 350px; padding-left: 10px; float: left;"
                            ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                            Height="150px">

                        <asp:DataList ID="DlstJob" runat="server" ForeColor="Black">
                            <ItemTemplate>
                                <div style="overflow: auto; width: 240px; float: left;">
                                    <div style="overflow: auto; width: 30px; float: left;">
                                        <asp:CheckBox ID="chkitmJob" runat="server" 
                                           AutoPostBack="true"/>
                                    </div>
                                    <div class="dataliststyle">
                                        <asp:Label ID="Label50" runat="server" Text='<%# bind("JobId") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="Label51" runat="server" Text='<%# bind("mJobName") %>'></asp:Label>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <ItemStyle Height="17px" />
                        </asp:DataList>


                        <asp:Label ID="Label63" runat="server" CssClass="errlabelstyle labelChange" Text="No Jobs Found"
                            Font-Bold="True" Visible="false"></asp:Label>

                        </asp:Panel></td>
            <td><asp:Panel ID="Panel1" runat="server" Style="width: 350px; padding-left: 10px; float: left;"
                        ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                        Height="150px">

                            <asp:DataList ID="DlstCLT" runat="server" ForeColor="Black">
                                <ItemTemplate>
                                    <div style="overflow: auto; width: 250px; float: left;">
                                        <div style="overflow: auto; width: 30px; float: left;">
                                            <asp:CheckBox ID="chkitem" runat="server" AutoPostBack="True"
                                                 />
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

                    </asp:Panel></td>
            </tr>
            <tr>
            <td align="right" style="padding-left:350px;"><asp:Button ID="btnSubmit" runat="server" Text="Submit" 
                        CssClass="TbleBtns" onclick="btnSubmit_Click"/></td>
            <td></td>
            </tr>
            
            <tr>
            <td colspan="2" align="center"><asp:Label ID="Label4" runat="server" CssClass="errlabelstyle labelChange" Text="This utility will allow you to allocate Single Staff to Single / Multiple Jobs or job Groups."
                                Font-Bold="True" ></asp:Label></td>
            <td></td>
            </tr>
            <tr>
            <td colspan="2"><asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                    <ProgressTemplate>
                        <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                </asp:UpdateProgress></td>
            <td></td>
            </tr>
            </table>
            </div>  
        </ContentTemplate>
    </asp:UpdatePanel>
</div>

