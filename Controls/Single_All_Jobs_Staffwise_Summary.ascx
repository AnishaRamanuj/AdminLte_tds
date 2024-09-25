<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Single_All_Jobs_Staffwise_Summary.ascx.cs" Inherits="controls_Single_All_Jobs_Staffwise_Summary" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
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
<script language="javascript" type="text/javascript">
    $(document).ready(function () {
        $('.sidebar-main-toggle').click();
        $("[id*= txtfrom]").val($("[id*= hdnFrom]").val());
        $("[id*= txtto]").val($("[id*= hdnTo]").val());

        $("[id*= txtfrom]").on('change', function () {
            $("[id*= hdnFrom]").val($("[id*= txtfrom]").val());
        });

        $("[id*= txtto]").on('change', function () {
            $("[id*= hdnTo]").val($("[id*= txtto]").val());
        });


    });

</script>



<div class="page-content">
    <asp:HiddenField runat="server" ID="hdnFrom" />
    <asp:HiddenField runat="server" ID="hdnTo" />
    <div class="content-wrapper">
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">All Jobs-Staff wise Summary</span></h4>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

            </div>
        </div>

        <div class="content">
            <div class="divstyle card">
                <div id="" class="totbodycatreg" style="height: 700px;">
                    <div style="width: 100%;">
                        <uc1:MessageControl ID="MessageControl1" runat="server" />
                    </div>
                    <div runat="server" id="divReportInput">
                        <div class="card-body">
                            <table style="padding-left: 20px; padding-top: 15px;">
                                <tr>
                                    <td>
                                        <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From"
                                            Font-Bold="True"></asp:Label></td>
                                    <td>:</td>
                                    <td>
                                        <input type="date" id="txtfrom" name="txtfrom" class="form-control" />

                                    </td>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To"
                                            Font-Bold="True"></asp:Label></td>
                                    <td>:</td>
                                    <td>
                                        <input type="date" id="txtto" name="txtto" class="form-control" />

                                    </td>
                                    <td style="width: 50px;"></td>
                                    <td>
                                        <asp:ImageButton ID="ImgXL" runat="server" ImageUrl="~/images/xls-icon.png" OnClick="btngen_Click" />

                                    </td>


                                </tr>

                            </table>
                        </div>

                        <div id="dvEditInvoice2" class="row">
                            <div class="card-body">
                                <div class="panel_headerstyle" style="float: left; padding-left: 55px; padding-top: 15px; font-weight: bold; margin: 5px 0; width: 100%;">

                                    <asp:CheckBox ID="chkjob1" runat="server" AutoPostBack="True" Text=" Check All Job Name" CssClass="labelChange"
                                        ForeColor="Black"
                                        Height="20px" OnCheckedChanged="chkjob1_CheckedChanged" />
                                </div>

                                <div style="overflow: auto; padding-bottom: 10px; padding-left: 55px; width: 550px; float: left;">
                                    <asp:Panel ID="Panel4" runat="server" class="panel_style" ScrollBars="Auto" BorderColor="#CCCCCC"
                                        BorderStyle="Solid" BorderWidth="1px" Height="250px">
                                        <asp:DataList ID="Job_List" runat="server" Width="300px" ForeColor="Black">
                                            <ItemTemplate>
                                                <div style="overflow: auto; width: 300px; float: left;">
                                                    <div style="overflow: auto; width: 30px; float: left;">
                                                        <asp:CheckBox ID="chkitem1" runat="server" />
                                                    </div>
                                                    <div class="dataliststyle">
                                                        <asp:Label ID="Label50" runat="server" Text='<%# bind("mjobname") %>'></asp:Label>
                                                        <asp:Label ID="Label51" runat="server" Text='<%# bind("mjobid") %>' Visible="False"></asp:Label>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                            <ItemStyle Height="17px" />
                                        </asp:DataList>
                                        <asp:Label ID="Label17" runat="server" CssClass="errlabelstyle" Text="No Staff Found"
                                            Font-Bold="True" Visible="False"></asp:Label>
                                    </asp:Panel>

                                </div>
                            </div>

                        </div>

                    </div>
                    <div id="tblreport" visible="false">
                    </div>

                </div>
            </div>
        </div>
    </div>

</div>





