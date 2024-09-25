﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="Client_List.aspx.cs" Inherits="Admin_Client_List" %>

<%@ Register Src="../controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   <div style="width: 903px; float: left;">
        <div class="headerstyle11">
            <div class="headerstyle112">
                <asp:Label ID="Label2" runat="server" Text="Client List" CssClass="Head1"></asp:Label>
            </div>
        </div>
           <div  class="msg_container">
        <uc1:MessageControl ID="MessageControl1" runat="server" /></div>
        <div id="divtitl" class="totbodycatreg">
            <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; width: 100%; float: left;">
                <div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px;">
                    <asp:Label ID="Label1" runat="server" Text="Company Name"></asp:Label>
                </div>
                <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
                    <asp:DropDownList ID="drpcompany" runat="server" AppendDataBoundItems="True" AutoPostBack="True"
                        DataTextField="CompanyName" DataValueField="CompId" CssClass="stf_drop" OnSelectedIndexChanged="drpcompany_SelectedIndexChanged"
                        >
                        <asp:ListItem Value="0">--Select--</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Label ID="Label56" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
                    <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                        <ProgressTemplate>
                            <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                    </asp:UpdateProgress>
                </div>
            </div>
        </div>
        <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; width: 100%; float: left;">
            <div style="width: 420px; float: left; overflow: hidden">
                <div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px;">
                    <asp:Label ID="Label3" runat="server" Text="Client Name"></asp:Label>
                </div>
                <div style="overflow: auto; width: 200px; height: 15px; padding-top: 5px;">
                    <asp:CheckBox ID="chkstaff" runat="server" AutoPostBack="True" OnCheckedChanged="chkstaff_CheckedChanged"
                        Text=" Check All" />
                </div>
                <div style="overflow: auto; padding-bottom: 0px; width:370px;float: left; padding-left:40px;">
                    <asp:Panel ID="Panel1" runat="server" Style="overflow: auto; width: 338px; padding-left: 10px;
                        float: left;" ScrollBars="Auto" BorderColor="#B6D1FB" BorderStyle="Solid" BorderWidth="1px"
                        Height="150px">
                        <asp:DataList ID="DataList1" runat="server" Width="310px">
                            <ItemTemplate>
                                <div style="overflow: auto; width: 300px; float: left;">
                                    <div style="overflow: auto; width: 30px; float: left;">
                                        <asp:CheckBox ID="chkitem" runat="server" />
                                    </div>
                                    <div class="dataliststyle">
                                        <asp:Label ID="Label50" runat="server" Text='<%# bind("ClientName") %>'></asp:Label>
                                        <asp:Label ID="Label51" runat="server" Text='<%# bind("CLTId") %>' Visible="False"></asp:Label>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <ItemStyle Height="17px" />
                        </asp:DataList>
                        <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle" Text="No Clients Found"
                            Font-Bold="True" Visible="false"></asp:Label>
                    </asp:Panel>
                    &nbsp;
                    <asp:Label ID="Label54" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
                </div>
            </div>
        </div>
        <div style="overflow: auto; padding-bottom: 10px; padding-top: 10px; width: 100%;
            float: left;">
            <div style="overflow: auto; width: 260px; height: 25px; padding-left: 150px; padding-top: 5px;
                float: left; text-align: left;">
                <asp:Button ID="btngenerate" runat="server" Text="Generate Report" CssClass="buttonstyle"
                    OnClick="btngenerate_Click" />
            </div>
        </div>
         <div class="footer_repeat">
                    Notes:
                </div>
                <div class="reapeatItem_client">
                    <div id="msghead" class="totbodycatreg" style="overflow: auto; padding-left: 5px">
                        <span class="labelstyle" style="overflow: auto; color: Red; font-size: smaller;">Fields
                            marked with * are required</span>
                    </div>
                </div>
                <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; width: 100%; float: left;">
                </div>
    </div>
</asp:Content>
