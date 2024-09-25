<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Manage_Holiday.ascx.cs"
    Inherits="controls_Manage_Holiday" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        var newDate = new Date();
        $("[id*=hdnDT]").val(newDate);
    });
</script>
<style type="text/css">
    .Head1 {
        font-size: 14px;
        font-family: Verdana,Arial,Helvetica,sans-serif;
        color: #3D80E8;
        font-weight: bold;
        overflow: hidden;
        border-bottom-color: White;
    }

    .divspace {
        height: 20px;
    }

    .headerstyle1_page {
        border-bottom: 1px solid #55A0FF;
        float: left;
        overflow: hidden;
        margin: 0 0 10px;
        width: 100%;
        height: 20px;
    }

    .headerpage {
        height: 23px;
    }

    .pagination {
        font-size: 80%;
    }

        .pagination a {
            text-decoration: none;
            border: solid 1.5px #55A0FF;
            color: #15B;
        }

    .txtbox {
        font-family: Verdana,Arial,Helvetica,sans-serif;
        font-size: 12px;
        font-style: normal;
        padding-left: 5px;
        color: #000000;
        -webkit-border-radius: 4px;
        -moz-border-radius: 4px;
        border-radius: 4px;
        border: 1px solid #000000;
    }

    .pagination a, .pagination span {
        display: block;
        float: left;
        padding: 0.1em 0.5em;
        margin-right: 1px;
        margin-bottom: 2px;
    }

    .pagination .current {
        background: #26B;
        color: #fff;
        border: solid 1px #AAE;
    }

        .pagination .current.prev, .pagination .current.next {
            color: #999;
            border-color: #999;
            background: #fff;
        }

    .Button:hover {
        border-color: #FFCC33;
    }

    .modalBackground {
        background-color: Gray;
        filter: alpha(opacity=70);
        opacity: 0.7;
    }

    .error {
        color: #fff !important;
        margin: 0 0 10px;
        background-color: #FFBABA;
        width: 100%;
    }

    .style1 {
        width: 100%;
    }

    .headerstyle1_master {
        width: 1258px;
    }

    .style2 {
        width: 133px;
    }

    .style3 span {
        color: #474747 !important;
    }

    .style3 {
        color: #474747;
        font-size: 12px;
        font-weight: bold;
        height: 35px;
        width: 104px;
    }

    .ajax__calendar .ajax__calendar_container {
        background-color: #FFFFFF;
        border: 1px solid #646464;
        color: #000000;
        z-index: 9;
    }

    .recordTble th, .grdheader {
        overflow: hidden;
        background: #F2F2F2;
        border: none;
        color: #474747 !important;
        font-weight: bold;
        text-align: center;
        padding: 0 0 0 5px;
        min-height: 23px;
        font-size: 10px;
        height: 23px;
        border-right-style: solid;
        border-right-width: 1px;
        border-right-color: #55A0FF;
    }

    .recordTble td input[type="text"] {
        border: 1px solid #BCBCBC;
        height: auto !important;
        padding: 2px 1px;
        border-radius: 3px;
    }

        .recordTble td input[type="text"]:hover, .recordTble td input[type="text"]:focus {
            border: 1px solid #7C7C7C;
        }

    .recordTble td a {
        color: #474747;
        font-weight: normal;
        text-decoration: none;
    }

        .recordTble td a:hover {
            color: #3D80E8;
            text-decoration: underline;
        }

    .recordTble td, .recordTble th {
        border: 1px solid #BCBCBC;
        color: #474747;
        font-size: 11px;
        padding: 2px 5px;
    }

    .recordTblepadding td, .recordTblepadding th {
        padding: 2px !important;
    }

    .recordTble td select {
        border: 1px solid #CCCCCC;
        padding: 2px 3px;
        border-radius: 3px;
        width: 140px;
    }

    .tableNewadd .recordTble th:first-child {
        text-align: left;
    }


    .divfloatleftn .recordTble td, .divfloatleftn .recordTble th {
        border: 1px solid #BCBCBC;
        color: #474747;
        font-size: 12px;
        padding: 5px;
        text-align: center;
    }

        .divfloatleftn .recordTble td:first-child, .divfloatleftn .recordTble th:first-child {
            text-align: left;
        }

    .divfloatleftn .recordTble td {
        background: none repeat scroll 0 0 #FBFBFB;
        border: 1px solid #CCCCCC;
        border-radius: 5px;
        padding: 5px;
    }

        .divfloatleftn .recordTble td:first-child input[type="text"] {
            background: none repeat scroll 0 0 #FBFBFB;
            border: 1px solid #CCCCCC;
            border-radius: 5px;
            padding: 5px;
            width: 230px !important;
        }

    .cssPageTitle {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        border-bottom: 2px solid #0b9322;
        color: #0b9322;
    }

    .cssButton {
        cursor: pointer; /*background-image: url(../Images/ButtonBG1.png);*/
        background-color: #d3d3d3;
        border: 0px;
        padding: 4px 15px 4px 15px;
        color: Black;
        border: 1px solid #c4c5c6;
        border-radius: 3px;
        font: bold 12px verdana, arial, "Trebuchet MS", sans-serif;
        text-decoration: none;
        opacity: 0.8;
    }

        .cssButton:focus {
            background-color: #69b506;
            border: 1px solid #3f6b03;
            color: White;
            opacity: 0.8;
        }

        .cssButton:hover {
            background-color: #69b506;
            border: 1px solid #3f6b03;
            color: White;
            opacity: 0.8;
        }

    .cssPageTitle2 {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        /*border-bottom: 2px solid #0b9322;*/
        padding: 7px;
        color: #0b9322;
    }

    .cssTextbox {
        font: normal 12px verdana, arial, "Trebuchet MS", sans-serif;
        height: 15px;
        border-radius: 4px;
        border: 1px solid #b5b5b5;
    }

    .cssTextboxLong {
        font: normal 12px verdana, arial, "Trebuchet MS", sans-serif;
        width: 350px;
        height: 25px;
        border-radius: 4px;
        border: 1px solid #b5b5b5;
    }

    .cssTextbox:focus {
        box-shadow: 0 0 5px rgba(81, 203, 238, 1);
        padding: 3px 0px 3px 3px;
        border: 1px solid rgba(81, 203, 238, 1);
    }

    .cssTextbox:hover {
        border: 1px solid rgba(81, 203, 238, 1);
    }

    .cssTextboxInt {
        font: normal 12px verdana, arial, "Trebuchet MS", sans-serif;
        height: 25px;
        text-align: right;
        border-radius: 4px;
        border: 1px solid #b5b5b5;
        padding-right: 5px;
    }

        .cssTextboxInt:focus {
            box-shadow: 0 0 5px rgba(81, 203, 238, 1);
            padding-right: 5px;
            border: 1px solid rgba(81, 203, 238, 1);
        }

        .cssTextboxInt:hover {
            padding-right: 5px;
            border: 1px solid rgba(81, 203, 238, 1);
        }
</style>
<script type="text/javascript" language="javascript">
    function ValidateText(i) {
        if (i.value == 0) {
            i.value = null;
        }
        if (i.value.length > 0) {
            i.value = i.value.replace(/[^\d]+/g, '');
        }
        CountFrmTitle(i, 12);
    }
    function CountFrmTitle(field, max) {
        if (field.value.length > max) {
            field.value = field.value.substring(0, max);
            alert("You are exceding the maximum limit");

        }
        else {
            field.value = field.value.replace(/[?,\/#!$%&\^\*;:{}=\_`~@"'+]/g, "");
            var count = max - field.value.length;
        }
    }

</script>
<div class="divstyle" style="height: auto">
    <div>
        <div>
            <table style="width: 100%" class="cssPageTitle">
                <tr>
                    <td class="cssPageTitle2">
                        <asp:Label ID="lblname" runat="server" Style="margin-left: 10px;"  Text="Manage Holiday"></asp:Label>
                    </td>
                </tr>
            </table>
          
            <asp:HiddenField ID="hdnDT" runat="server" />
        </div>
    </div>
    <div id="Div1" runat="server" class="masterdiv1a">
        <div style="float: left">
            <uc1:MessageControl ID="MessageControl2" runat="server" />
            <div class="serachJob" style="float: left">
                <div style="float: left; width: 100%; margin: 10px; padding-bottom: 5px; overflow: auto;" id="searchdesg"
                    runat="server">
                    <asp:Label ID="Label21" runat="server" CssClass="LabelFontStyle" Text="Search Holiday"></asp:Label>
                    &nbsp;&nbsp;
                    <asp:TextBox ID="txtHolidaysearch" runat="server" CssClass="cssTextbox" Width="250px"
                        Font-Names="Verdana" Font-Size="8pt"></asp:TextBox>
                    &nbsp;<asp:Button ID="btnSHoliday" runat="server" CssClass="cssButton"
                        OnClick="btnSHoliday_Click" Text="Search" />
                    &nbsp;&nbsp;<asp:Button ID="BtnHolidayAdd" runat="server" CssClass="cssButton"
                        OnClick="BtnHolidayAdd_Click" Text="Add Holiday" />
                </div>
            </div>
            <div style="float: left; margin: 10px; padding-left: 5px; width: 1175px; padding-right: 15px;">
                <asp:Panel ID="Panel2" runat="server" Width="100%">
                    <asp:GridView ID="Griddealers" runat="server" AutoGenerateColumns="False" Width="100%"
                        DataSourceID="SqlDataSource1" DataKeyNames="HolidayId"
                        AllowPaging="True" OnPageIndexChanging="Griddealers_PageIndexChanging" PageSize="25"
                        EmptyDataText="No records found!!!" CssClass="recordTble"
                        OnRowDataBound="Griddealers_RowDataBound"
                        OnRowCommand="Griddealers_RowCommand">
                        <PagerSettings FirstPageText="First" LastPageText="Last" PageButtonCount="10" Position="Bottom" />
                        <FooterStyle BackColor="White" ForeColor="#000066" />
                        <PagerStyle HorizontalAlign="Left" VerticalAlign="Middle" BackColor="White" ForeColor="#000066" />
                        <SelectedRowStyle CssClass="selectedstyle"></SelectedRowStyle>
                        <RowStyle CssClass="rowstyle"></RowStyle>
                        <Columns>
                            <asp:TemplateField HeaderText="jobid" HeaderStyle-CssClass="grdheader" Visible="False">
                                <ItemTemplate>
                                    <div class="gridcolstyle">
                                        <asp:Label ID="lblid" runat="server" CssClass="labelstyle" Text='<%# bind("HolidayId") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <HeaderStyle CssClass="grdheader"></HeaderStyle>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Holiday Name" HeaderStyle-CssClass="grdheader">
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="width: 300px;">
                                        <asp:Label ID="lblDesg" runat="server" CssClass="labelstyle" Text='<%# bind("HolidayName") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>

                                <HeaderStyle CssClass="grdheader" Width="520px"></HeaderStyle>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Holiday Date" HeaderStyle-CssClass="grdheader">
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="width: 180px;">
                                        <center>  <asp:Label ID="lblDate" runat="server" CommandName="view" CssClass="labelstyle" Text='<%# bind("HolidayDate") %>'></asp:Label></center>
                                    </div>
                                </ItemTemplate>

                                <HeaderStyle CssClass="grdheader" Width="180px"></HeaderStyle>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Branch Name" HeaderStyle-CssClass="grdheader">
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="width: 300px;">
                                        <asp:Label ID="lblbr" runat="server" CssClass="labelstyle" Text='<%# bind("BranchName") %>'></asp:Label>
                                        <asp:HiddenField ID="hdnBrid" runat="server" Value='<%# bind("BrId") %>' />
                                    </div>
                                </ItemTemplate>

                                <HeaderStyle CssClass="grdheader" Width="520px"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheader">
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="text-align: center;">
                                        <asp:ImageButton ID="btnEdit" runat="server" CommandName="edit" ImageUrl="~/images/edit.png"
                                            ToolTip="Edit" Height="19px" Width="18px" CommandArgument='<%# bind("HolidayId") %>' />
                                    </div>
                                </ItemTemplate>
                                <HeaderStyle CssClass="grdheader" Width="120px"></HeaderStyle>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Delete">
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="text-align: center;">
                                        <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("HolidayId") %>'
                                            ImageUrl="~/images/Delete.png" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                            ToolTip="Delete" CommandName="delete" />
                                    </div>
                                </ItemTemplate>
                                <HeaderStyle CssClass="grdheader" Width="120px" />
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                    </asp:GridView>
                </asp:Panel>
            </div>
            <div class="reapeatItem4">
                <div id="msghead" runat="server" class="msgdiv" style="padding-left: 2%; float: left; text-align: left; width: 650px;"
                    align="left">
                </div>
                <div class="txtboxNew">
                </div>
            </div>
            <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal" runat="server"></asp:Button><br />
            <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="modalBackground"
                CancelControlID="btnCancel" BehaviorID="programmaticModalPopupOrginalBehavior"
                DropShadow="False" PopupControlID="panelupgrade" RepositionMode="RepositionOnWindowScroll"
                TargetControlID="hideModalPopupViaClientOrginal">
            </cc1:ModalPopupExtender>
            <asp:Panel ID="panelupgrade" runat="server" DefaultButton="btnHoliday" CssClass="RoundpanelNarr RoundpanelNarrExtra" Width="450px">
                <h1 class="Ttlepopu">Add Holiday</h1>
                <table width="100%" class="addDesignatnation">
                    <tr>
                        <asp:HiddenField ID="hdnEdit" runat="server" />
                        <td class="style3">
                            <asp:Label ID="Label31" runat="server" ForeColor="Black" Text="Holiday" CssClass="LabelFontStyle"></asp:Label>
                        </td>
                        <td style="width: 250px">
                            <div style="padding-left: 5px; float: left;">
                                <asp:TextBox ID="txtHoliday" runat="server" CssClass="cssTextbox" Font-Names="Verdana"
                                    Font-Size="8pt" Width="250px"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="style3">
                            <asp:Label ID="Label1" runat="server" ForeColor="Black" Text="Date" CssClass="LabelFontStyle"></asp:Label>
                        </td>
                        <td style="width: 250px">
                            <div style="padding-left: 5px; float: left;">

                                <asp:TextBox ID="txtDate" runat="server" CssClass="cssTextbox"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDate"
                                    Mask="99/99/9999" MaskType="Date" MessageValidatorTip="true" />
                                <cc1:CalendarExtender ID="Calendarextender2" runat="server" TargetControlID="txtDate"
                                    PopupButtonID="TxtDate" Format="dd/MM/yyyy" Enabled="True">
                                </cc1:CalendarExtender>
                                <asp:Label ID="Label68" runat="server" CssClass="errlabelstyle" Text="" ForeColor="Red"></asp:Label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="style3">
                            <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Branch" CssClass="LabelFontStyle"></asp:Label>
                        </td>
                        <td style="width: 250px">
                            <div style="padding-left: 5px; float: left;">
                                <asp:DropDownList ID="drpBr" runat="server" Width="225px" Height="27px" CssClass="cssTextbox" DataSourceID="" DataTextField="BranchName"
                                    DataValueField="BrId" AppendDataBoundItems="True">

                                    <asp:ListItem Value="0">--Select--</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </td>

                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <asp:Button ID="btnHoliday" runat="server" CssClass="cssButton" Text="Save"
                                OnClick="btnHoliday_Click" />
                            &nbsp;
                            <asp:Button ID="btnCancel" runat="server" CssClass="cssButton" OnClick="btnCancel_Click"
                                Text="Cancel" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
        <div id="griddiv" class="totbodycatreg">
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
            <asp:HiddenField ID="hidpermission" runat="server" />
        </div>
    </div>
</div>
