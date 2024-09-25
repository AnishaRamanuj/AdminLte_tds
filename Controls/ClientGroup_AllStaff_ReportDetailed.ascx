<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ClientGroup_AllStaff_ReportDetailed.ascx.cs" Inherits="controls_ClientGroup_AllStaff_ReportDetailed" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%--<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />--%>
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
<script type="text/javascript" src="../js/PDFMaker/html2pdf.bundle.js"></script>
<script type="text/javascript" src="../js/PDFMaker/html2pdf.bundle.min.js"></script>
<script type="text/javascript" src="../js/table2excel.js"></script>
<script runat="server">
</script>

<div class="page-content">
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
            </div>
        </div>
    </div>
    <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-bottom: 1rem;">
        <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">
            <h5><span class="font-weight-bold" runat="server">Client Group Detailed</span></h5>
            <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
        </div>
    </div>
</div>
<div class="content">
    <div class="divstyle card">
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div>
                    <uc1:MessageControl ID="MessageControl1" runat="server" />
                </div>
                <div class="form-group row" style="padding-top: 0px;">
                    <div class="col-lg-0.5" style="padding-top: 5px; padding-left:10px;" >
                        <asp:Label ID="Label19" runat="server" Text="From :" ForeColor="Black"></asp:Label>
                    </div>
                    <div class="col-lg-1">
                        <asp:TextBox ID="txtstartdate1" runat="server" CssClass="form-control form-control-border"></asp:TextBox>
                    </div>
                    <div class="col-lg-1" style="padding-top: 5px;">
                        <asp:Image ID="Image2" runat="server" CssClass="icon-calendar52 text-primary-600" />
                    </div>
                    <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtstartdate1"
                        PopupButtonID="Image2" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>

                    <div class="col-lg-0.5" style="padding-top: 5px;">
                        <asp:Label ID="Label21" runat="server" Text="To :" ForeColor="Black"></asp:Label>
                    </div>
                    <div class="col-lg-1">
                        <asp:TextBox ID="txtenddate2" runat="server" CssClass="form-control form-control-border"></asp:TextBox>
                    </div>
                    <div class="col-lg-1" style="padding-top: 5px;">
                        <asp:Image ID="Image3" runat="server" CssClass="icon-calendar52 text-primary-600" />
                    </div>
                    <cc1:CalendarExtender ID="Calendarextender2" runat="server" TargetControlID="txtenddate2"
                        PopupButtonID="Image3" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>


                    <div style="overflow: auto; padding-bottom: 10px; float: left;">
                        <asp:Button ID="btngen" CssClass="btn btn-outline-success legitRipple" runat="server" Text="Generate Report"
                            OnClick="btngen_Click" Font-Bold="True" />
                    </div>
                </div>

                <div class="row_report">
                    <div class="panel_headerstyle" style="float: left; padding-left:5px; padding-top: 15px; font-weight: bold; margin: 5px 0; width: 100%;">
                        <asp:CheckBox ID="chkjob1" runat="server" AutoPostBack="True" CssClass="labelChange" Text=" Check All Client Group"
                            OnCheckedChanged="chkjob1_CheckedChanged" ForeColor="Black" />
                        <asp:DropDownList ID="DropClientGroup" runat="server" AutoPostBack="True"
                            CssClass="stf_drop" DataTextField="ClientGroupName" DataValueField="CTGId"
                            ForeColor="Black" Height="20px"
                            OnSelectedIndexChanged="DropClientGroup_SelectedIndexChanged" Visible="False">
                        </asp:DropDownList>
                    </div>
                    <div style="overflow: auto; width: 500px; padding-left:5px; float: left;">
                        <asp:Panel ID="Panel4" runat="server" class="panel_style" ScrollBars="Auto" BorderColor="#CCCCCC"
                            BorderStyle="Solid" BorderWidth="1px" Height="500px">
                            <asp:DataList ID="clientlist" runat="server" Width="450px" ForeColor="Black">
                                <ItemTemplate>
                                    <div style="overflow: auto; width: 300px; float: left;">
                                        <div style="overflow: auto; width: 30px; float: left;">
                                            <asp:CheckBox ID="chkitem1" runat="server" />
                                        </div>
                                        <div class="dataliststyle">
                                            <asp:Label ID="Label50" runat="server" Text='<%# bind("ClientGroupName") %>'></asp:Label>
                                            <asp:Label ID="Label51" runat="server" Text='<%# bind("CTGId") %>' Visible="False"></asp:Label>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle Height="17px" />
                            </asp:DataList>
                            <asp:Label ID="Label17" runat="server" CssClass="errlabelstyle labelChange" Text="No Staff Found"
                                Font-Bold="True" Visible="False"></asp:Label>
                        </asp:Panel>
                        &nbsp;<asp:Label ID="Label18" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                    </div>
                </div>

                <div class="row_report">
                    <div class="col_lft">
                    </div>

                    <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left; padding-left: 150px;">
                        <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                            <ProgressTemplate>
                                <img alt="loadting" src="../images/progress-indicator.gif" />
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </div>
                </div>
                <div class="row_report">
                </div>


            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</div>

