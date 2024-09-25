<%@ Control Language="C#" AutoEventWireup="true" CodeFile="All_ClientStaffJob3.ascx.cs" Inherits="controls_All_ClientStaffJob3" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
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

<script language="javascript" type="text/javascript">

    $(document).ready(function () {
        $('.sidebar-main-toggle').click();
        $("[id*= txtfr]").val($("[id*= hdnFrom]").val());
        $("[id*= txtend]").val($("[id*= hdnTo]").val());

        $("[id*= txtfr]").on('change', function () {
            $("[id*= hdnFrom]").val($("[id*= txtfr]").val());
        });

        $("[id*= txtend]").on('change', function () {
            $("[id*= hdnTo]").val($("[id*= txtend]").val());
        });

    });


</script>


<div class="page-content">
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnFrom" />
    <asp:HiddenField runat="server" ID="hdnTo" />
    <div class="content-wrapper">
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Staff Detail Report</span></h4>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

                <asp:Button ID="btngenexp" runat="server" Text="Generate Report" CssClass="btn bg-success legitRipple"
                    OnClick="btngenexp_Click" />

            </div>
        </div>

        <div class="content">
            <div class="divstyle card">
                <div id="" class="totbo dycatreg" style="height: 700px;">
                    <div style="width: 100%;">
                        <uc2:MessageControl ID="MessageControl2" runat="server" />
                    </div>
                    <div runat="server" id="divReportInput">
                        <div class="card-body">
                            <table style="padding-left: 20px; padding-top: 15px;">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <table class="style1" width="1000px;">
                                            <tr>
                                                <td valign="middle">
                                                    <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From"
                                                        Font-Bold="True"></asp:Label>
                                                </td>
                                                <td align="center" valign="middle">:
                                                </td>
                                                <td valign="middle">
                                                    <input type="date" id="txtfr" name="txtfr" class="form-control" />
                                                </td>
                                                <td valign="middle">
                                                    <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To"
                                                        Font-Bold="True"></asp:Label>
                                                </td>
                                                <td align="center" valign="middle">:
                                                </td>
                                                <td valign="middle">
                                                    <input type="date" id="txtend" name="txtend" class="form-control" />
                                                </td>


                                            </tr>

                                        </table>
                                    </td>
                                </tr>

                            </table>
                        </div>



                        <div id="dvEditInvoice2" class="row">
                            <div class="card-body">
                                <table style="width: 1100px; padding-left: 55px; padding-top: 15px;">
                                    <tr>
                                        <td>
                                            <asp:CheckBox ID="chkstaff" runat="server" Font-Bold="true" AutoPostBack="True" CssClass="labelChange" Text=" Check All Staff Name"
                                                OnCheckedChanged="chkstaff_CheckedChanged" ForeColor="Black" /></td>
                                        <td>
                                            <asp:CheckBox ID="chkclient" runat="server" Font-Bold="true" AutoPostBack="True" CssClass="labelChange" Text=" Check All Client Name"
                                                OnCheckedChanged="chkclient_CheckedChanged" ForeColor="Black" /></td>
                                        <td>
                                            <asp:CheckBox ID="chkjob" runat="server" Font-Bold="true" AutoPostBack="True" CssClass="labelChange" Text=" Check All Job Name"
                                                OnCheckedChanged="chkjob_CheckedChanged" ForeColor="Black" /></td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Panel ID="Panel11" runat="server" Style="width: 320px; padding-left: 10px; float: left;"
                                                ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                                Height="450px">
                                                <asp:DataList ID="DlstStf" runat="server" Width="300px" ForeColor="Black">
                                                    <ItemTemplate>
                                                        <div style="overflow: auto; width: 320px; float: left;">
                                                            <div style="overflow: auto; width: 30px; float: left;">
                                                                <asp:CheckBox ID="chkitem" OnCheckedChanged="chk_staff" runat="server" AutoPostBack="true" />
                                                            </div>
                                                            <div class="dataliststyle">
                                                                <asp:Label ID="Label50" runat="server" Text='<%# bind("StaffCode") %>' Visible="False"></asp:Label>
                                                                <asp:Label ID="Label51" runat="server" Text='<%# bind("StaffName") %>'></asp:Label>
                                                            </div>
                                                        </div>
                                                    </ItemTemplate>
                                                    <ItemStyle Height="17px" />
                                                </asp:DataList>
                                                <asp:Label ID="Label70" runat="server" CssClass="errlabelstyle labelChange" Text="No Staffs Found"
                                                    Font-Bold="True" Visible="False"></asp:Label>
                                            </asp:Panel>
                                        </td>
                                        <td>
                                            <asp:Panel ID="Panel9" runat="server" Style="width: 310px; padding-left: 10px; float: left;"
                                                ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                                Height="450px">
                                                <asp:DataList ID="DlstCLT" runat="server" ForeColor="Black">
                                                    <ItemTemplate>
                                                        <div style="overflow: auto; width: 250px; float: left;">
                                                            <div style="overflow: auto; width: 30px; float: left;">
                                                                <asp:CheckBox ID="chkitem" runat="server" AutoPostBack="True" />
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
                                            </asp:Panel>
                                        </td>
                                        <td>
                                            <asp:Panel ID="Panel10" runat="server" Style="width: 310px; padding-left: 10px; float: left;"
                                                ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                                Height="450px">
                                                <asp:DataList ID="DlstJob" runat="server" ForeColor="Black">
                                                    <ItemTemplate>
                                                        <div style="overflow: auto; width: 240px; float: left;">
                                                            <div style="overflow: auto; width: 30px; float: left;">
                                                                <asp:CheckBox ID="chkitem" runat="server" />
                                                            </div>
                                                            <div class="dataliststyle">
                                                                <asp:Label ID="Label50" runat="server" Text='<%# bind("mJobId") %>' Visible="False"></asp:Label>
                                                                <asp:Label ID="Label51" runat="server" Text='<%# bind("mJobName") %>'></asp:Label>
                                                            </div>
                                                        </div>
                                                    </ItemTemplate>
                                                    <ItemStyle Height="17px" />
                                                </asp:DataList>
                                                <asp:Label ID="Label63" runat="server" CssClass="errlabelstyle labelChange" Text="No Jobs Found"
                                                    Font-Bold="True" Visible="false"></asp:Label>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </div>

                        </div>

                    </div>


                </div>
            </div>
        </div>
    </div>

</div>




<div id="div4" class="totbodycatreg">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="overflow: auto; width: 100%;">
            </div>



            <%--         <div style="overflow: auto; padding-bottom: 4px; padding-top: 15px; width: 100%; padding-left: 55px;">
                <div style="overflow: auto; padding-bottom: 10px; width: 45px; float: left; padding-top: 5px; font-weight: bold;">
                    <asp:Label ID="Label65" runat="server" Text="From :" ForeColor="Black"></asp:Label>
                </div>
                <div style="width: 120px; float: left;">
                    <div style="float: left;">
                        <asp:TextBox ID="txtfr" runat="server" CssClass="texboxcls texboxclsnew"></asp:TextBox>
                    </div>
                    <div style="float: left; padding-right: 5px">
                        <asp:Image ID="Image8" runat="server" ImageUrl="~/images/calendar.png"
                            Style="float: right; margin-right: 10px;" />
                    </div>
                    <cc1:CalendarExtender ID="Calendarextender7" runat="server" TargetControlID="txtfr"
                        PopupButtonID="Image8" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                    <asp:Label ID="Label66" runat="server" CssClass="errlabelstyle" Text="" ForeColor="Red"></asp:Label>
                </div>
                <div style="overflow: auto; padding-bottom: 10px; width: 29px; float: left; text-align: right; padding-top: 5px; font-weight: bold;">
                    <asp:Label ID="Label67" runat="server" Text="To :" ForeColor="Black"></asp:Label>
                </div>
                <div style="padding-left: 5px; float: left;">
                    <div style="float: left;">
                        <asp:TextBox ID="txtend" runat="server" CssClass="texboxcls texboxclsnew"></asp:TextBox>
                    </div>
                    <div style="overflow: auto; float: left; padding-right: 5px">
                        <asp:Image ID="Image9" runat="server" ImageUrl="~/images/calendar.png"
                            Style="float: right; margin-right: 10px;" />
                    </div>
                    <cc1:CalendarExtender ID="Calendarextender8" runat="server" TargetControlID="txtend"
                        PopupButtonID="Image9" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                    <asp:Label ID="Label68" runat="server" CssClass="errlabelstyle" Text="" ForeColor="Red"></asp:Label>
                </div>
                <div style="float: left;">
                
                </div>
                <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left; padding-left: 150px;">
                    <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                        <ProgressTemplate>
                            <img alt="loadting" src="../images/progress-indicator.gif" />
                        </ProgressTemplate>
                    </asp:UpdateProgress>
                </div>
            </div>--%>
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
