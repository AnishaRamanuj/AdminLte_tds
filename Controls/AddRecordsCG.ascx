<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddRecordsCG.ascx.cs" Inherits="controls_AddRecordsCG" %>
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
        height: 15px;
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
        width: 100%;
    }

    .headerstyle1_master {
        width: 1258px;
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
    }

    function CountFrmTitle(field, max) {
        if (field.value.length > max) {
            field.value = field.value.substring(0, max);
            alert("You are exceding the maximum limit");

        }
        else {
            field.value = field.value.replace(/[?,\/#!$%\^\*;:{}=\_`~@"'+]/g, "");
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
                        <asp:Label ID="lblname" runat="server" Style="margin-left: 10px;" Text="Manage Client Group"></asp:Label>
                    </td>
                </tr>
            </table>          
        </div>
    </div>

    <asp:HiddenField ID="hdnDT" runat="server" />
    <div id="Div14" runat="server" class="masterdiv1a">
        <div style="width: 100%; float: left">
            <uc1:MessageControl ID="MessageControl8" runat="server" />

            <div id="Div3" class="seperotorrwr">

                <div id="searchcg" runat="server" style="float: left; width: 100%; margin: 10px; padding-bottom: 5px; overflow: auto;">

                    <div style="float: left; width: 100%; margin: 10px; padding-bottom: 5px; overflow: auto;" class="serachJob">
                        <asp:Label ID="Label22" runat="server" Text="Search Client Group" CssClass="LabelFontStyle labelChange" style="margin-left:10px;"></asp:Label>
                        <asp:TextBox ID="txtcgsearch" runat="server" CssClass="cssTextbox" Width="250px" onkeyup="CountFrmTitle(this,70);"
                            Font-Names="Verdana" Font-Size="8pt"></asp:TextBox>
                        <asp:Button ID="btnsearchcg" runat="server" CssClass="cssButton" Text="Search" OnClick="btnsearchcg_Click" />

                        <asp:Button ID="ImageCltg" runat="server" OnClick="LinkCltg_Click" Text="Add Client Group"
                            CssClass="cssButton" />
                    </div>
                </div>
            </div>
            <div style="width: 100%; padding-top: 5px;">


                <asp:Panel ID="Panel14" runat="server">
                </asp:Panel>
            </div>

            <div class="MiddleTble">

                <div class="divfloatleftn divfloatleftnTble" style="float: left; margin: 10px; padding-left: 5px; width: 730px; padding-right: 15px;">
                    <asp:Panel ID="Panel15" runat="server">
                        <asp:GridView ID="GridView7" runat="server" AutoGenerateColumns="False" Width="100%"
                            DataSourceID="SqlDataSource8" DataKeyNames="CTGId" AllowPaging="True" EmptyDataText="No records found!!!"
                            OnPageIndexChanging="GridView7_PageIndexChanging" OnRowCommand="GridView7_RowCommand"
                            PageSize="25" OnRowCancelingEdit="GridView7_RowCancelingEdit" OnRowEditing="GridView7_RowEditing"
                            OnRowUpdating="GridView7_RowUpdating" OnRowDataBound="GridView7_RowDataBound" OnRowCreated="GridView7_RowCreated" CssClass="norecordTble">
                            <PagerSettings FirstPageText="First" LastPageText="Last" PageButtonCount="10"
                                Position="Bottom" />
                            <FooterStyle />
                            <PagerStyle />
                            <RowStyle />
                            <Columns>
                                <asp:TemplateField HeaderText="OpeId" HeaderStyle-CssClass="grdheadermster" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("CTGId") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Client Group Name" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;">
                                            <asp:LinkButton ID="lblfrname" runat="server" CssClass="labelstyle" CommandName="view" Text='<%# bind("ClientGroupName") %>'></asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;">
                                            <asp:TextBox ID="TextBox3" runat="server" Height="16px" CssClass="cssTextbox" Text='<%# bind("ClientGroupName") %>'
                                                Width="241px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster labelChange"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="padding-left: 10px;">
                                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit.png"
                                                ToolTip="Edit" />
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Button ID="Button2" runat="server" CssClass="cssButton" CommandName="update" Text="Update" />
                                            <asp:Button ID="Button3" runat="server" CssClass="cssButton" CommandName="cancel" Text="Cancel" />
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <div style="width: 100%" align="center">
                                            <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("CTGId") %>'
                                                ImageUrl="~/images/Delete.png" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                                ToolTip="Delete" CommandName="del" />
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster" />
                                </asp:TemplateField>
                            </Columns>
                            <SelectedRowStyle />
                            <HeaderStyle />
                        </asp:GridView>
                    </asp:Panel>
                </div>


                <div class="tableNewadd" style="float: right; margin: 10px; padding-left: 10px;">
                    <asp:Panel ID="Panel13" runat="server">
                        <asp:GridView ID="GrdC" runat="server" AutoGenerateColumns="False" Width="450px"
                            DataSourceID="SqlDataSource10" DataKeyNames="CLTid" OnPageIndexChanging="GrdC_PageIndexChanging"
                            AllowPaging="True" EmptyDataText="No records found!!!"
                            PageSize="25" CssClass="norecordTble">
                            <PagerSettings FirstPageText="First" LastPageText="Last" PageButtonCount="10"
                                Position="Bottom" />
                            <FooterStyle />
                            <PagerStyle />
                            <RowStyle />

                            <Columns>
                                <asp:TemplateField HeaderText="Staffcode" HeaderStyle-CssClass="grdheadermster" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblSid" runat="server" CssClass="labelstyle" Text='<%# bind("CLTid") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster labelChange"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Client Name" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle labelChange" style="width: 300px;">
                                            <asp:Label ID="lblSTname" runat="server" CssClass="labelstyle" Text='<%# bind("ClientName") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster labelChange"></HeaderStyle>
                                </asp:TemplateField>
                            </Columns>
                            <SelectedRowStyle />
                            <HeaderStyle />

                        </asp:GridView>
                    </asp:Panel>
                </div>
            </div>
            <div class="mastergrid">
            </div>
        </div>






        <div class="reapeatItem2">


            <div class="txtboxNew">
            </div>


            <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server"></asp:Button><br />

            <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" BackgroundCssClass="modalBackground" CancelControlID="btnCancel2"
                BehaviorID="programmaticModalPopupOrginalBehavior" DropShadow="False" PopupControlID="panel10"
                RepositionMode="RepositionOnWindowScroll" TargetControlID="hideModalPopupViaClientOrginal2">
            </cc1:ModalPopupExtender>
            <asp:Panel ID="panel10" runat="server" Width="400px" BackColor="#FFFFFF" DefaultButton="BtnSubmit2"
                BorderColor="White" BorderStyle="None" CssClass="RoundpanelNarr RoundpanelNarrExtra">
                <div>

                    <div class="Ttlepopu">
                        <label class="labelChange">Client Group</label>
                        <span style="display: none;">
                            <asp:Label ID="Label33" runat="server" Font-Bold="True" CssClass="LabelFontStyle labelChange"
                                Font-Size="8pt" ForeColor="White" Text="Add Department"></asp:Label>
                        </span>

                        <%-- <asp:Button ID="BtnClose2" runat="server" BackColor="White" 
                                BorderColor="White" BorderStyle="None" Font-Bold="True" Font-Names="Verdana" 
                                Font-Size="8pt" ForeColor="White" Height="16px" text="X" Width="16px" />
                        --%>
                    </div>
                    <table class="addDesignatnation">
                        <tr>
                            <td class="style3">
                                <asp:Label ID="Label1" runat="server" Text="Client Group" CssClass="LabelFontStyle labelChange"></asp:Label>:
                            </td>
                            <td style="width: 250px;">
                                <asp:TextBox ID="Txt2" runat="server" CssClass="cssTextbox" Font-Names="Verdana" onkeyup="CountFrmTitle(this,70);"
                                    Width="250px"></asp:TextBox>
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
                            <td align="center" class="style2" colspan="2">
                                <asp:Button ID="BtnSubmit2" runat="server" CssClass="cssButton" Text="Save" OnClick="BtnSubmit2_Click" />

                                <asp:Button ID="btnCancel2" runat="server" CssClass="cssButton" Text="Cancel" OnClick="btnCancel2_Click" />
                                <div id="Div22" align="right">
                                </div>
                            </td>
                        </tr>

                    </table>

                </div>
            </asp:Panel>
        </div>



        <div id="griddiv" class="totbodycatreg">
            <asp:SqlDataSource ID="SqlDataSource8" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDataSource10" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
            <asp:HiddenField ID="hidpermission" runat="server" />
        </div>


    </div>
