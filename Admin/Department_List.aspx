<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="Department_List.aspx.cs" Inherits="Admin_Department_List" %>

<%@ Register src="../controls/MessageControl.ascx" tagname="MessageControl" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="divtotbody" style="overflow: auto; width: 100%; margin: 0px auto auto auto;
        height: auto; float: left; height: auto; ">
        <div class="h_outer">
            <div class="h_inner">
                <div class="headerstyle112">
                    <asp:Label ID="Label2" runat="server" Text="Staff List - All Departments List" CssClass="Head1"></asp:Label>
                </div>
            </div>
            <br />
        </div>
        <div class="mbox_top">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div id="divtitl" style="overflow: auto; width: 100%; margin: 0px auto auto auto;
            height: auto; float: left;">
            <div class="d_row">
                <div class="col_lft">
                    <asp:Label ID="Label1" runat="server" Text="Company Name"></asp:Label>
                </div>
                <div class="col_rht">
                    <asp:DropDownList ID="drpcompany" runat="server" AppendDataBoundItems="True" AutoPostBack="True"
                        DataTextField="CompanyName" DataValueField="CompId" CssClass="stf_drop" OnSelectedIndexChanged="drpcompany_SelectedIndexChanged"
                        DataSourceID="SqlCompSrc">
                        <asp:ListItem Value="0">--Select--</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Label ID="Label56" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
                    <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                        <ProgressTemplate>
                            <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                    </asp:UpdateProgress>
                    <asp:SqlDataSource ID="SqlCompSrc" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                        SelectCommand="select * from dbo.Company_Master order by CompanyName"></asp:SqlDataSource>
                </div>
            </div>
        </div>
        <div class="d_row">
            <div class="col_lft_nopading">
                <asp:Label ID="Label3" runat="server" Text="Department Name"></asp:Label>
            </div>
            <div class="col_rht_nopading">
                <asp:CheckBox ID="chk_allDepart" runat="server" AutoPostBack="True" Text=" Check All"
                    OnCheckedChanged="chk_allDepart_CheckedChanged" />
                </div>
                <div class="lst_panel">
                <asp:Panel ID="Panel2" runat="server" ScrollBars="Auto" CssClass="stf_lBox">
                    <asp:DataList ID="DepartmentList" runat="server" Width="300px">
                        <ItemTemplate>
                            <div style="overflow: auto; width: 300px; float: left;">
                                <div style="overflow: auto; width: 30px; float: left;">
                                    <asp:CheckBox ID="chkitem" runat="server" />
                                </div>
                                <div class="stf_lBox_inner">
                                    <asp:Label ID="Label50" runat="server" Text='<%# bind("DepartmentName") %>'></asp:Label>
                                    <asp:Label ID="Label51" runat="server" Text='<%# bind("DepId") %>' Visible="False"></asp:Label>
                                </div>
                            </div>
                        </ItemTemplate>
                        <ItemStyle Height="17px" />
                    </asp:DataList>
                    <asp:Label ID="Label14" runat="server" CssClass="errlabelstyle" Text="No Departments Found"
                        Font-Bold="True" Visible="False"></asp:Label>
                </asp:Panel>
                &nbsp;<asp:Label ID="Label54" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
            </div>
           
        </div>
        <div class="d_row">
            <div class="col_lft">
            </div>
            <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
                <asp:Button ID="btngenerate" runat="server" Text="Generate Report" CssClass="buttonstyle"
                    OnClick="btngenerate_Click" />
            </div>
        </div>
        <div class="foot_top">
            Notes:
        </div>
        <div class="foot_notes">
            <div id="msghead" style="overflow: auto; width: 100%; margin: 0px auto auto auto;
                height: auto; float: left;" style="overflow: auto; padding-left: 5px">
                <span class="labelstyle" style="overflow: auto; color: Red; font-size: smaller;">Fields
                    marked with * are required</span>
            </div>
        </div>
    </div>
</asp:Content>

