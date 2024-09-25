<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ManageClient.ascx.cs"
    Inherits="controls_ManageClient" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
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
        height: 36px;
    }

    .pagination {
        font-size: 80%;
    }


    .pagination {
        text-decoration: none;
        border: solid 1.5px #55A0FF;
        color: #15B;
    }

    .button {
        font-family: Verdana;
        font-size: 8pt;
        font-weight: bold;
        color: #1464F4;
        background-color: #B2D3F5;
        border-color: #FF9900;
    }

    .RoundpanelNarr {
        Width: 650px;
        background-color: #d3d3d3;
        Height: 280px;
        -webkit-border-radius: 15px;
        -moz-border-radius: 15px;
        border-radius: 15px;
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

    .style1 {
        height: 23px;
    }

    .style2 {
        top: 10px;
        height: 23px;
    }

    }

    .style1 {
        width: 487px;
    }

    .style2 {
        width: 463px;
    }

    .style3 {
        width: 77px;
    }

    .style4 {
        height: 18px;
    }

    .style5 {
        width: 21px;
    }

    .style6 {
        height: 18px;
        width: 21px;
    }

    .style7 {
        width: 100%;
    }

    .style8 {
        width: 57px;
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

    function CountFrmTitle(field, max) {
        if (field.value.length > max) {
            field.value = field.value.substring(0, max);
            alert("You are exceding the maximum limit");

        }
        else {
            field.value = field.value.replace(/[?,\/#!$%\^\*;{}=\`~@"'+]/g, "");
            var count = max - field.value.length;
        }
    }

</script>
<div id="divtotbody" class="testwhleinside">
    <div id="divtitl" class="totbodycatreg">

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <Triggers>
                <asp:PostBackTrigger ControlID="BtnExport" />
            </Triggers>
            <ContentTemplate>
                <div>
                    <div>
                        <table style="width: 100%" class="cssPageTitle">
                            <tr>
                                <td class="cssPageTitle2">
                                    <asp:Label ID="Label1" runat="server" Style="margin-left: 10px;" Text="Manage Client"></asp:Label>
                                </td>
                            </tr>
                        </table>
                     
                    </div>
                    <asp:HiddenField ID="hdnDT" runat="server" />
                </div>
                <div style="float: left; width: 100%; padding-left: 10px" align="left">
                    <uc1:MessageControl ID="MessageControl1" runat="server" />
                    <asp:HiddenField ID="hdnCompanyid" runat="server" />
                    <asp:HiddenField ID="hdnCntClient" runat="server" />
                </div>
                <div style="float: right; text-align: right; width: 100%; padding-top: 5px;">
                    <asp:Panel ID="Panel5" runat="server" DefaultButton="btnsrchjob">
                        <div style="float: left; width: 68%; padding-left: 1px">
                            <div id="searchbr" runat="server" style="float: left; width: 100%; margin: 10px; padding-bottom: 5px; overflow: auto;">
                                <div style="float: left;" class="serachJob">
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label24" runat="server" Text="Client / Client Group" CssClass="LabelFontStyle labelChange"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlcltcgm" runat="server" Width="100px" Height="25px" CssClass="cssTextbox">
                                                    <asp:ListItem Value="client" Text="Client"></asp:ListItem>
                                                    <asp:ListItem Value="clientgrp" Text="Client Group"></asp:ListItem>
                                                </asp:DropDownList></td>
                                            <td>
                                                <asp:TextBox ID="txtsrchjob" runat="server" Width="250px" CssClass="cssTextbox" Font-Names="Verdana"
                                                    Font-Size="8pt"></asp:TextBox>
                                            </td>
                                            <td>
                                                <asp:Button ID="btnsrchjob" runat="server" CssClass="cssButton"
                                                    Text="Search" OnClick="btnsrchjob_Click" />
                                            </td>
                                            <td>
                                                <asp:Button ID="btnaddbranch" runat="server" CssClass="cssButton" OnClick="lnknewclient_Click"
                                                    Text="Add Client" />
                                            </td>
                                            <td>
                                                <asp:ImageButton ID="BtnExport" runat="server" ImageUrl="~/Images/xls-icon.png" Text="Export to Excel"
                                                    OnClick="BtnExport_Click" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>
                </div>
                <div class="tableNewadd" style="width: 1160px; margin: 10px; padding-left: 10px; padding-right: 10px;">
                    <asp:Panel ID="Panel1" runat="server">
                        <asp:GridView ID="Griddealers" runat="server" AutoGenerateColumns="False" Width="100%"
                            DataKeyNames="CLTId" OnRowCommand="Griddealers_RowCommand"
                            PageSize="25" OnPageIndexChanging="Griddealers_PageIndexChanging"
                            CssClass="norecordTble" EmptyDataText="No records found!!!">
                            <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast"
                                PageButtonCount="20" Position="Bottom" />
                            <PagerStyle CssClass="pagination" HorizontalAlign="Right" VerticalAlign="Middle" />
                            <RowStyle Height="15px" />
                            <Columns>
                                <asp:TemplateField HeaderText="dealerid" HeaderStyle-CssClass="grdheader" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridpages">
                                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("CLTId") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheaderNew"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-CssClass="grdheaderNew " HeaderText="Sr No.">
                                    <ItemTemplate>
                                        <div class="gridpages" align="center">
                                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text='<%# bind("sino") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Client Name" HeaderStyle-CssClass="grdheader">
                                    <ItemTemplate>
                                        <div class="gridpages">
                                            <asp:Label ID="lnkcmpname" CssClass="gridpages" Width="300px" runat="server" Text='<%# bind("ClientName") %>'
                                                CommandName="client"></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="griditemstlert1" />
                                    <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Client Group" HeaderStyle-CssClass="grdheader">
                                    <ItemTemplate>
                                        <div class="gridpages">
                                            <asp:Label ID="lnkcmpgrp" CssClass="gridpages" Width="200px" runat="server" Text='<%# bind("ClientGroupName") %>'
                                                CommandName="client"></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="griditemstlert1" />
                                    <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="City">
                                    <ItemTemplate>
                                        <div class="gridpages">
                                            <asp:Label ID="Label3" runat="server" CssClass="labelstyle" Text='<%# bind("City") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="griditemstle1" />
                                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Country">
                                    <ItemTemplate>
                                        <div class="gridpages">
                                            <asp:Label ID="lblpassword" runat="server" CssClass="labelstyle" Text='<%# bind("Country") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="griditemstle1" />
                                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Phone">
                                    <ItemTemplate>
                                        <div class="gridpages">
                                            <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text='<%# bind("BusPhone") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="griditemstle2" />
                                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Mobile Number">
                                    <ItemTemplate>
                                        <div class="gridpages">
                                            <asp:Label ID="Label4" runat="server" CssClass="labelstyle" Text='<%# bind("ContMob") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="griditemstle2" />
                                    <HeaderStyle CssClass="grdheader" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheader">
                                    <ItemTemplate>
                                        <div class="gridpages" style="text-align: center;">
                                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit.png"
                                                Height="19px" Width="18px" ToolTip="Edit" />
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <div class="gridpages" style="text-align: center;">
                                            <asp:ImageButton ID="btndelete" runat="server" ImageUrl="~/images/Delete.png" CommandArgument='<%# bind("CLTId") %>'
                                                OnClick="btndelete_Click" ToolTip="Delete" OnClientClick="javascript : return confirm('Are you sure want to delete?');" />
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader" />
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="grdheader" />
                        </asp:GridView>
                        <div>
                            <asp:Button ID="BtnPrevious" runat="server" CssClass="TbleBtns TbleBtnsPading" Text="Previous"
                                OnClick="BtnPrevious_Click" />
                            <asp:Button ID="BtnNext" runat="server" CssClass="TbleBtns TbleBtnsPading" Text="Next"
                                OnClick="BtnNext_Click" />
                        </div>
                    </asp:Panel>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <div class="reapeatItem2">
        <div class="txtboxNew">
            <span class="labelstyle"></span>
        </div>
    </div>
    <div id="div1" class="seperotorrwr">
    </div>
    <div id="griddiv" class="totbodycatreg">
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
            SelectCommand="SELECT *,row_number() over(order by CreationDate desc)as sino,'/ad_jobdetails.aspx?clt_id='+convert(varchar(255),CLTId)as url FROM Client_Master"></asp:SqlDataSource>
        <asp:HiddenField ID="hidpermission" runat="server" />
    </div>
</div>
