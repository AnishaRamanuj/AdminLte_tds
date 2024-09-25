<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="AllJobAllCategory.aspx.cs" Inherits="Admin_AllJobAllCategory" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="../controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="div1" class="totbodycatreg">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
               <div style="overflow: auto; overflow: auto; width: 99%; padding-left: 5px">
                    <uc1:MessageControl ID="MessageControl1" runat="server" />
                </div>
                <div class="headerstyle11">
                    <div class="headerstyle112">
                        <asp:Label ID="Label1" runat="server" Text="All Jobs - All Category Report" CssClass="Head1"></asp:Label></div>
                </div>
                <div class="row_report">
                    <div class="rowinnerstyle1">
                        <asp:Label ID="Label9" runat="server" Text="Company Name"></asp:Label>
                    </div>
                    <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
                        <asp:DropDownList ID="drpcompanylist" runat="server" DataTextField="CompanyName"
                            DataValueField="CompId" Width="240px" Height="20px" CssClass="dropstyle" DataSourceID="SqlDropSrc"
                            AutoPostBack="True" OnSelectedIndexChanged="drpcompanylist_SelectedIndexChanged"
                            AppendDataBoundItems="True">
                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                        </asp:DropDownList>
                        <asp:Label ID="Label10" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                            <ProgressTemplate>
                                <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                        </asp:UpdateProgress>
                        <asp:SqlDataSource ID="SqlDropSrc" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                            SelectCommand="select CompId,CompanyName from dbo.Company_Master order by CompanyName">
                        </asp:SqlDataSource>
                    </div>
                </div>
                <div class="row_report">
                    <div class="rowinnerstyle1">
                        <asp:Label ID="Label11" runat="server" Text="Client  Name"></asp:Label>
                    </div>
                    <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
                        <asp:DropDownList ID="drpClient" runat="server" DataTextField="ClientName" DataValueField="CLTId"
                            Width="240px" Height="20px" CssClass="dropstyle" OnSelectedIndexChanged="drpClient_SelectedIndexChanged"
                            AutoPostBack="True">
                        </asp:DropDownList>
                        <asp:Label ID="Label12" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                    </div>
                </div>
                <div class="row_report">
                 <div style="width: 420px; float: left; overflow: hidden">
                    <div style="overflow: auto;  width: 110px; float: left; padding-left: 40px;">
                        <asp:Label ID="Label16" runat="server" Text="Job Name"></asp:Label>
                    </div>
                    <div style="overflow: auto; width: 200px; height: 15px;">
                        <asp:CheckBox ID="chkjob1" runat="server" AutoPostBack="True" Text=" Check All" OnCheckedChanged="chkjob1_CheckedChanged" />
                    </div>
                    <div style="overflow: auto;  padding-bottom: 0px; width: 370px; float: left;padding-left:40px">
                        <asp:Panel ID="Panel4" runat="server" Style="width: 338px; padding-left: 10px; float: left;"
                            ScrollBars="Auto" BorderColor="#B6D1FB" BorderStyle="Solid" BorderWidth="1px"
                            Height="150px">
                            <asp:DataList ID="dljoblist" runat="server" Width="500px">
                                <ItemTemplate>
                                    <div style="overflow: auto; width: 490px; float: left;">
                                        <div style="overflow: auto; width: 30px; float: left;">
                                            <asp:CheckBox ID="chkitem1" runat="server" />
                                        </div>
                                        <div class="dataliststyle">
                                            <asp:Label ID="Label50" runat="server" Text='<%# bind("JobName") %>'></asp:Label>
                                            <asp:Label ID="Label51" runat="server" Text='<%# bind("JobId") %>' Visible="False"></asp:Label>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle Height="17px" />
                            </asp:DataList>
                            <asp:Label ID="Label17" runat="server" CssClass="errlabelstyle" Text="No Jobs Found"
                                Font-Bold="True" Visible="false"></asp:Label>
                        </asp:Panel>                        
                        &nbsp;<asp:Label ID="Label18" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
                    </div>
                    </div>
                </div>
                <div class="row_report">
                    <div style="overflow: auto; width: 260px; height: 25px; padding-left: 150px; padding-top: 5px;
                        float: left; text-align: left;">
                        <asp:Button ID="btngen" CssClass="buttonstyle" runat="server" Text="Generate Report"
                            OnClick="btngen_Click" />
                    </div>
                </div>
                <div style="overflow: auto; width: 100%; float: left; padding-top: 5px; padding-bottom: 10px;
                    height: 10px; padding-left: 40px; margin-top: 5px; font-weight: bold;">
                    Notes:
                </div>
                <div class="reapeatItem_client">
                    <div id="msghead" class="totbodycatreg" style="overflow: auto; padding-left: 5px">
                        <span class="labelstyle" style="overflow: auto; color: Red; font-size: smaller;">Fields
                            marked with * are required</span>
                    </div>
                </div>
                <div class="row_report">
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
