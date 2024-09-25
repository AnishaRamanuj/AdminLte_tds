<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Client_SingleJobGroupAllJobs.ascx.cs" Inherits="controls_Client_SingleJobGroupAllJobs" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register src="MessageControl.ascx" tagname="MessageControl" tagprefix="uc2" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />  
<div id="divtitl" class="totbodycatreg">
    
        <div class="headerstyle1_page">
            <asp:Label ID="Label3" runat="server" Text="Single JobGroup - All Jobs Report" CssClass="Head1" ></asp:Label>
        </div>
  
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div  class="msg_container">
                <uc2:MessageControl ID="MessageControl2" runat="server" />
            </div>
           <div  class="col_lft" style="font-weight:bold; display:block; float:left;">
                <div  class="col_lft" style="font-weight:bold; display:block; margin:10px 0 5px; float:left;">
                    <asp:Label ID="Label2" runat="server" Text="Client Name" ></asp:Label>
                </div>
             <div class="col_lft" style="font-weight:bold; display:block; margin:10px 0 5px; float:left; width:100%;">
                    <asp:DropDownList ID="drpclient" runat="server" CssClass="stf_drop texboxcls"  DataTextField="ClientName"
                        DataValueField="CLTId" onselectedindexchanged="drpclient_SelectedIndexChanged" 
                        Width="289px" AutoPostBack="true">
                        <asp:ListItem Value="0">--Select--</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Label ID="Label55" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                </div>
            </div>
            <div id="jobgrp" runat="server" style="overflow: auto;  width: 100%; float: left; display: block; font-weight:bold;">
              
                <div style="overflow: auto; width: 340px; height: 24px;">
		  <div class="col_lft" style="float:left;  padding-right: 10px; padding-top: 2px;">
                    <asp:Label ID="Label77" runat="server" Text="Job Group Name"></asp:Label>
                </div>
                    <asp:CheckBox ID="chkjobgrp" runat="server" AutoPostBack="True" Text=" Check All"
                        OnCheckedChanged="chkjobgrp_CheckedChanged" ForeColor="Black" />
                    
                </div>
                <div style="overflow: auto; width: 370px; float: left;">
                    <asp:Panel ID="Panel13" runat="server" class="panel_style" ScrollBars="Auto" BorderColor="#B6D1FB"
                        BorderStyle="Solid" BorderWidth="1px" Height="150px">
                        <asp:DataList ID="DataList7" runat="server" Width="335px" ForeColor="Black">
                            <ItemTemplate>
                                <div style="overflow: auto; width: 320px; float: left;">
                                    <div style="overflow: auto; width: 30px; float: left;">
                                        <asp:CheckBox ID="chkitem" runat="server" />
                                    </div>
                                    <div class="dataliststyle">
                                        <asp:Label ID="Label50" runat="server" Text='<%# bind("JobGroupName") %>'></asp:Label>
                                        <asp:Label ID="Label51" runat="server" Text='<%# bind("JobGId") %>' Visible="False"></asp:Label>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <ItemStyle Height="17px" />
                        </asp:DataList>
                        <asp:Label ID="Label78" runat="server" CssClass="errlabelstyle" Text="No Records Found"
                            Font-Bold="True" Visible="False" ForeColor="Black"></asp:Label>
                    </asp:Panel>
                    &nbsp;<asp:Label ID="Label79" runat="server" CssClass="errlabelstyle" ForeColor="Red"
                        Text=""></asp:Label>
                </div>
            </div>
            <div class="row_report">
                <div class="col_lft">
                </div>
                <div style="overflow: auto; padding-bottom: 10px;float: left;">
                    <asp:Button ID="btngenerate" runat="server" Text="Generate Report" CssClass="TbleBtns"
                        OnClick="btngenerate_Click" />
                </div>
                 <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;padding-left:150px;">
                 <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                    <ProgressTemplate>
                        <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                </asp:UpdateProgress></div>
            </div>
            
       
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
