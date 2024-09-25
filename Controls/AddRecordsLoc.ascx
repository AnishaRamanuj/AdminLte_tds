<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddRecordsLoc.ascx.cs"
    Inherits="controls_AddRecordsLoc" %>
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


    .headerpage {
        height: 32px;
    }

    .pagination {
        font-size: 80%;
    }

        .pagination a {
            text-decoration: none;
            border: solid 1.5px #55A0FF;
            color: #15B;
        }

    .Button {
        font-family: Verdana,Arial,Helvetica,sans-serif;
        font-size: 11px;
        font-weight: 600;
        height: 25px;
        color: #1464F4;
        -webkit-border-radius: 4px;
        -moz-border-radius: 4px;
        border-radius: 4px;
    }

    .button {
        font-family: Verdana;
        font-size: 8pt;
        font-weight: bold;
        color: #1464F4;
        background-color: #B2D3F5;
        border-color: #FF9900;
    }

    .txtbox {
        font-family: Verdana,Arial,Helvetica,sans-serif;
        font-size: 12px;
        font-style: normal;
        padding-left: 5px;
        color: #000000;
        height: 17px;
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

    .modalBackground {
        background-color: Gray;
        filter: alpha(opacity=70);
        opacity: 0.7;
    }

    .error {
        color: #D8000C;
        background-color: #FFBABA;
        background-image: url('images/error.png');
    }

    .style3 {
        width: 29px;
        height: 27px;
    }

    .style6 {
        width: 51px;
        height: 27px;
    }

    .style7 {
        width: 51px;
    }

    .cssPageTitle {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        border-bottom: 2px solid #0b9322;
        color: #0b9322;
    }

    .cssPageTitle2 {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        /*border-bottom: 2px solid #0b9322;*/
        padding: 7px;
        color: #0b9322;
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
                        <asp:Label ID="Label18" runat="server" Style="margin-left: 10px;" Text="Manage Location"></asp:Label>
                    </td>
                </tr>
            </table>
            <asp:HiddenField ID="hdnDT" runat="server" />
        </div>
    </div>
    <div id="Div8" runat="server" class="masterdiv1a">
        <div style="width: 100%; float: left;">
            <uc1:MessageControl ID="MessageControl5" runat="server" />
            <%-- <div id="Div9" class="seperotorrwr">
            </div>--%>
            <div>
                <asp:Panel ID="Panel5" runat="server" DefaultButton="btnlocsearch">
                    <div>
                        <div id="searchloc" runat="server">
                            <div style="float: left; width: 100%; margin: 10px; padding-bottom: 5px; overflow: auto;" class="serachJob">
                                <%--  <div style="float: left; text-align: right; width: 70%; padding-top: 5px;">--%>
                                <asp:Label ID="Label26" runat="server" Text="Search Location" CssClass="LabelFontStyle labelChange"></asp:Label>&nbsp;&nbsp;
                                <%--</div>
                    <div style="float: right; text-align: right; width: 29%;">--%>
                                <asp:TextBox ID="txtlocsearch" runat="server" onkeyup="CountFrmTitle(this,70);" CssClass="txtbox"></asp:TextBox>
                                &nbsp;<asp:Button ID="btnlocsearch" runat="server" Text="Search" CssClass="TbleBtnsPading TbleBtns"
                                    OnClick="btnlocsearch_Click" />
                                <asp:Button ID="Button4" runat="server" CssClass="TbleBtnsPading TbleBtns labelChange"
                                    OnClick="Button4_Click" Text="Add Location" />
                                <%-- </div>--%>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
        <div class="divfloatleftn" style="float: left; margin: 10px; padding-left: 5px; width: 1175px; padding-right: 15px;">
            <asp:Panel ID="Panel1" runat="server">
                <asp:GridView ID="GridView4" runat="server" AutoGenerateColumns="False" Width="100%"
                    DataSourceID="SqlDataSource5" DataKeyNames="LocId" AllowPaging="True" EmptyDataText="No records found!!!"
                    OnPageIndexChanging="GridView4_PageIndexChanging" OnRowCommand="GridView4_RowCommand"
                    PageSize="25" OnRowCancelingEdit="GridView4_RowCancelingEdit" OnRowEditing="GridView4_RowEditing"
                    OnRowUpdating="GridView4_RowUpdating" OnRowDataBound="GridView4_RowDataBound"
                    BackColor="White" CellPadding="3" Font-Names="Verdana" Font-Size="9pt" OnRowCreated="GridView4_RowCreated"
                    CssClass="norecordTble">
                    <PagerSettings FirstPageText="First" LastPageText="Last" PageButtonCount="10" Position="Bottom" />
                    <FooterStyle BackColor="White" ForeColor="#000066" />
                    <PagerStyle />
                    <RowStyle />
                    <Columns>
                        <asp:TemplateField HeaderText="LocId" HeaderStyle-CssClass="grdheadermster" Visible="False">
                            <ItemTemplate>
                                <div class="gridcolstyle">
                                    <asp:Label ID="lblfid" runat="server" CssClass="labelstyle labelChange" Text='<%# bind("LocId") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                            <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Location Name" HeaderStyle-CssClass="grdheadermster">
                            <ItemTemplate>
                                <div class="gridcolstyle" style="width: 450px;">
                                    <asp:LinkButton ID="lblfrname" runat="server" CssClass="labelstyle labelChange" Text='<%# bind("LocationName") %>'></asp:LinkButton>
                                </div>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <div class="gridcolstyle" style="width: 450px;">
                                    <asp:TextBox ID="TextBox3" runat="server" Height="16px" Text='<%# bind("LocationName") %>'
                                        Width="241px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>
                                </div>
                            </EditItemTemplate>
                            <HeaderStyle CssClass="grdheadermster labelChange"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheadermster">
                            <ItemTemplate>
                                <div class="gridcolstyle">
                                    <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/editnew.png"
                                        ToolTip="Edit" />
                                </div>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <div class="gridcolstyle">
                                    <asp:Button ID="Button2" runat="server" CssClass="TbleBtns TbleBtnsPading" CommandName="update"
                                        Text="Update" />
                                    &nbsp;<asp:Button ID="Button3" runat="server" CssClass="TbleBtns TbleBtnsPading"
                                        CommandName="cancel" Text="Cancel" />
                                </div>
                            </EditItemTemplate>
                            <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Delete">
                            <ItemTemplate>
                                <div style="width: 100%" align="center">
                                    <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("LocId") %>'
                                        ImageUrl="~/images/delete.jpg" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                        ToolTip="Delete" CommandName="delete" />
                                </div>
                            </ItemTemplate>
                            <HeaderStyle CssClass="grdheadermster" />
                        </asp:TemplateField>
                    </Columns>
                    <SelectedRowStyle />
                    <HeaderStyle />
                </asp:GridView>
            </asp:Panel>

            <div class="reapeatItem2">
            </div>
            <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server"></asp:Button>
            <asp:HiddenField ID="hidpermission" runat="server" />
            <br />
            <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" BackgroundCssClass="modalBackground"
                CancelControlID="btnCancel2" BehaviorID="programmaticModalPopupOrginalBehavior"
                DropShadow="False" PopupControlID="panel10" RepositionMode="RepositionOnWindowScroll"
                TargetControlID="hideModalPopupViaClientOrginal2">
            </cc1:ModalPopupExtender>
            <asp:Panel ID="panel10" runat="server" Width="400px" BackColor="#FFFFFF" DefaultButton="BtnSubmit2"
                CssClass="RoundpanelNarr RoundpanelNarrExtra">
                <div class="Ttlepopu">
                    <label class="labelChange">
                        Add Location
                    </label>
                    <%-- <asp:Button ID="BtnClose2" runat="server" BackColor="White" 
                                BorderColor="White" BorderStyle="None" Font-Bold="True" Font-Names="Verdana" 
                                Font-Size="8pt" ForeColor="White" Height="16px" text="X" Width="16px" onclick="BtnClose2_Click"  />--%>
                </div>
                <table class="addDesignatnation">
                    <tr>
                        <td class="style7">
                            <asp:Label ID="Label1" runat="server" ForeColor="Black" Text="Location" CssClass="LabelFontStyle labelChange"></asp:Label>
                        </td>
                        <td style="width: 250px">
                            <asp:TextBox ID="Txt2" runat="server" CssClass="txtbox" TabIndex="0" Width="250px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="noteText">
                                Notes:
                <div id="msghead" runat="server" class="txtboxNewError">
                    <span class="labelstyle">Fields marked with * are required</span>
                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <asp:Button ID="BtnSubmit2" runat="server" CssClass="TbleBtns TbleBtnsPading" TabIndex="1"
                                OnClick="BtnSubmit2_Click" Text="Save" />
                            &nbsp;
                                <asp:Button ID="btnCancel2" runat="server" CssClass="TbleBtns TbleBtnsPading" TabIndex="2"
                                    OnClick="btnCancel2_Click" Text="Cancel" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
        <div id="griddiv" class="totbodycatreg">
            <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
        </div>
    </div>
</div>
