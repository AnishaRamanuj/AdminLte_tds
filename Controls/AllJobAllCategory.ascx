<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AllJobAllCategory.ascx.cs" Inherits="controls_AllJobAllCategory" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/bootstrap.bundle.min.js" type="text/javascript"></script>
<script src="../js/blockui.min.js" type="text/javascript"></script>
<script src="../js/ripple.min.js" type="text/javascript"></script>
<script src="../js/jgrowl.min.js" type="text/javascript"></script>
<script src="../js/pnotify.min.js" type="text/javascript"></script>
<script src="../js/noty.min.js" type="text/javascript"></script>

<script src="../js/form_select2.js" type="text/javascript"></script>
<script src="../js/d3.min.js" type="text/javascript"></script>

<script src="../jquery/moment.js" type="text/javascript"></script>
<script src="../js/interactions.min.js" type="text/javascript"></script>
<script src="../js/datatables.min.js" type="text/javascript"></script>

<script src="../js/uniform.min.js" type="text/javascript"></script>
<script src="../js/app.js" type="text/javascript"></script>
<script src="../js/select2.min.js" type="text/javascript"></script>

<script src="../js/Ajax_Pager.min.js" type="text/javascript"></script>

<script src="../js/components_modals.js" type="text/javascript"></script>
<script src="../js/echarts.min.js" type="text/javascript"></script>
<script src="../js/PopupAlert.js" type="text/javascript"></script>


<div class="page-content">
    <div class="content-wrapper">
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">All Jobs - All Category Report</span></h4>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

                <asp:Button ID="btngen" runat="server" CssClass="btn bg-success legitRipple" Text="Generate Report"
                    OnClick="btngen_Click" />
            </div>
        </div>


        <div class="content">
            <div class="divstyle card">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="msg_container">
                            <uc1:MessageControl ID="MessageControl1" runat="server" />
                        </div>
                        <div class="row_report">

                            <div style="float: left; font-weight: bold; padding-left: 55px; margin: 5px; width: 100%;">
                                <div class="col_lft" style="float: left; padding-right: 10px; padding-top: 2px; display: block; font-weight: bold; margin: 5px 0; width: 100%;">
                                    <asp:Label ID="Label11" runat="server" Text="Client  Name" CssClass="labelChange"></asp:Label>
                                </div>
                                <asp:DropDownList ID="drpClient" runat="server" CssClass="stf_drop texboxclsselectnew" DataTextField="ClientName"
                                    DataValueField="CLTId" OnSelectedIndexChanged="drpClient_SelectedIndexChanged"
                                    AutoPostBack="True">
                                </asp:DropDownList>
                                <asp:Label ID="Label12" runat="server" CssClass="errlabelstyle" Text="" ForeColor="Red"></asp:Label>
                            </div>
                        </div>
                        <div class="row_report" style="padding-left: 55px;">

                            <div class="panel_headerstyle" style="float: left; font-weight: bold; margin: 5px 0; width: 100%;">


                                <asp:CheckBox ID="chkjob1" runat="server" AutoPostBack="True" Text=" Check All Job Name" CssClass="labelChange"
                                    OnCheckedChanged="chkjob1_CheckedChanged" ForeColor="Black" />
                            </div>
                            <div style="width: 370px; float: left;">
                                <asp:Panel ID="Panel4" runat="server" class="panel_style" ScrollBars="Auto" BorderColor="#CCCCCC"
                                    BorderStyle="Solid" BorderWidth="1px" Height="150px"
                                    Style="margin-right: 0px">
                                    <asp:DataList ID="dljoblist" runat="server" Width="300px" ForeColor="Black"
                                        Style="margin-top: 0px">
                                        <ItemTemplate>
                                            <div style="overflow: auto; width: 300px; float: left;">
                                                <div style="overflow: auto; width: 30px; float: left;">
                                                    <asp:CheckBox ID="chkitem1" runat="server" />
                                                </div>
                                                <div class="dataliststyle">
                                                    <asp:Label ID="Label50" runat="server" Text='<%# bind("mJobName") %>'></asp:Label>
                                                    <asp:Label ID="Label51" runat="server" Text='<%# bind("mJobId") %>' Visible="False"></asp:Label>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                        <ItemStyle Height="17px" />
                                    </asp:DataList>
                                    <asp:Label ID="Label17" runat="server" CssClass="errlabelstyle" Text="No Records Found"
                                        Font-Bold="True" Visible="false"></asp:Label>
                                </asp:Panel>
                                &nbsp;<asp:Label ID="Label18" runat="server" CssClass="errlabelstyle" ForeColor="Red"
                                    Text=""></asp:Label>
                            </div>
                        </div>
                        <div class="row_report">
                            <div class="col_lft">
                            </div>
                            <div style="overflow: auto; padding-left: 55px; padding-bottom: 10px; clear: both; float: left;">
                            </div>
                            <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left; padding-left: 150px;">
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
        </div>
    </div>
</div>


<%--<div id="div1" class="totbodycatreg">

    <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
        <asp:Label ID="Label1" runat="server" Text="All Jobs - All Category Report" CssClass="Head1 labelChange"></asp:Label>
    </div>

  



  
</div>--%>
