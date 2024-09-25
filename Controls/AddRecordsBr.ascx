<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddRecordsBr.ascx.cs" Inherits="controls_AddRecordsBr" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
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
        height: 23px;
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
        color: #fff !important;
        background-color: #FFBABA;
        background-image: none !important;
        width: 100% !important;
    }

    .style1 {
        height: 23px;
    }

    .style2 {
        top: 10px;
        height: 23px;
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
        color: #474747;
        font-size: 12px;
        font-weight: bold;
        height: 35px;
        width: 104px;
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
            field.value = field.value.replace(/[?,\/#!$%\^\*;:{}=\_`~@"+]/g, "");
            var count = max - field.value.length;
        }
    }

</script>

<div>
    <div>
        <div>
            <table style="width: 100%" class="cssPageTitle">
                <tr>
                    <td class="cssPageTitle2">
                        <asp:Label ID="lblname" runat="server" Style="margin-left: 10px;" Text="Manage Branch"></asp:Label>
                    </td>
                </tr>
            </table>
       
        </div>
    </div>
    <div id="Div4" runat="server" class="masterdiv1a">
        <div style="float: center">
            <uc1:MessageControl ID="MessageControl3" runat="server" />
            <div class="serachJob" style="float: left; width: 100%; margin: 20px; overflow: auto;">
                <div id="searchbr" runat="server">
                    <asp:Label ID="Label24" runat="server" Text="Search Branch" CssClass="LabelFontStyle labelChange"></asp:Label>
                    <asp:TextBox ID="txtbrsearch" runat="server" Width="250px" CssClass="cssTextbox" Font-Names="Verdana" onkeyup="CountFrmTitle(this,70);"
                        Font-Size="8pt"></asp:TextBox>
                    <asp:Button ID="btnsearchbr" runat="server" CssClass="cssButton" Text="Search"
                        OnClick="btnsearchbr_Click" /><asp:Button ID="btnaddbranch" runat="server" CssClass="cssButton"
                            OnClick="btnaddbranch_Click" Text="Add Branch" />
                </div>
            </div>

            <%--<div class="`"></div>--%>
            <div>

                <div class="tableNewadd" style="float: right; margin: 10px; padding-left: 10px;">
                    <asp:Panel ID="Panel12" runat="server">
                        <asp:GridView ID="GrdB" runat="server" AutoGenerateColumns="False" Width="100%"
                            DataKeyNames="Staffcode"
                            EmptyDataText="No records found!!!"
                            BackColor="White" CellPadding="3" Font-Names="Verdana"
                            Font-Size="9pt" CssClass="norecordTble"
                            OnPageIndexChanging="GrdB_PageIndexChanging" AllowPaging="True" PageSize="50">
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <RowStyle Height="20px" Font-Names="Verdana" Font-Size="9pt" ForeColor="#000066" />
                            <Columns>
                                <asp:TemplateField HeaderText="Staffcode" HeaderStyle-CssClass="grdheader" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblSid" runat="server" CssClass="labelstyle"
                                                Text='<%# bind("Staffcode") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Staff Name"
                                    HeaderStyle-CssClass="grdheader">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSTname" runat="server" CssClass="labelstyle"
                                            Text='<%# bind("StaffName") %>'></asp:Label>

                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheaderm labelChange"></HeaderStyle>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </asp:Panel>

                </div>


                <div class="divfloatleftn divfloatleftnTble" style="float: left; margin: 10px; padding-left: 5px; width: 730px; padding-right: 15px;">
                    <%--<div style ="float:left;width:68%;padding-left:10px"></div>
                   <div style ="float:right;padding-top:5px;">
    
                    </div>--%>
                    <asp:Panel ID="Panel11" runat="server">
                        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" Width="100%"
                            DataSourceID="SqlDataSource3" DataKeyNames="BrId" AllowPaging="True" EmptyDataText="No records found!!!"
                            OnPageIndexChanging="GridView2_PageIndexChanging" OnRowCommand="GridView2_RowCommand"
                            PageSize="25" OnRowCancelingEdit="GridView2_RowCancelingEdit" OnRowEditing="GridView2_RowEditing"
                            OnRowUpdating="GridView2_RowUpdating" OnRowDataBound="GridView2_RowDataBound"
                            BackColor="White" CellPadding="3" CssClass="norecordTble" OnRowCreated="GridView2_RowCreated">
                            <PagerSettings FirstPageText="First" LastPageText="Last" PageButtonCount="10" Position="Bottom" />
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <PagerStyle HorizontalAlign="Left" VerticalAlign="Middle" BackColor="White" ForeColor="#000066" />
                            <RowStyle Height="20px" Font-Names="Verdana" Font-Size="9pt" ForeColor="#000066" />
                            <Columns>
                                <asp:TemplateField HeaderText="BrId" HeaderStyle-CssClass="grdheader"
                                    Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle"
                                                Text='<%# bind("BrId") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Branch Name"
                                    HeaderStyle-CssClass="grdheader">
                                    <EditItemTemplate>

                                        <asp:TextBox ID="TextBox3" runat="server" CssClass="cssTextbox" Text='<%# bind("BranchName") %>'
                                            Width="241px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>

                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;">
                                            <asp:LinkButton ID="lblfrname" runat="server" CssClass="labelstyle" CommandName="view"
                                                Text='<%# bind("BranchName") %>'></asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheader">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit.png"
                                                ToolTip="Edit" Width="16px" />
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Button ID="Button2" runat="server" CssClass="cssButton"
                                                CommandName="update" Text="Update" />
                                            &nbsp;<asp:Button ID="Button3" runat="server" CssClass="cssButton"
                                                CommandName="cancel" Text="Cancel" />
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("BrId") %>'
                                            ImageUrl="~/images/Delete.png" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                            ToolTip="Delete" CommandName="delete" />

                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader" />
                                </asp:TemplateField>
                            </Columns>
                            <SelectedRowStyle Font-Bold="True"
                                ForeColor="White" />
                            <HeaderStyle CssClass="grdheader" />
                        </asp:GridView>
                    </asp:Panel>


                </div>
            </div>

        </div>


        <div class="reapeatItem2">
        </div>

        <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server"></asp:Button><br />

        <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" BackgroundCssClass="modalBackground" CancelControlID="btnCancel2"
            BehaviorID="programmaticModalPopupOrginalBehavior" DropShadow="False" PopupControlID="panel10"
            RepositionMode="RepositionOnWindowScroll" TargetControlID="hideModalPopupViaClientOrginal2">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="panel10" runat="server" Width="400px" BackColor="#FFFFFF" DefaultButton="BtnSubmit2"
            Height="138px" BorderColor="White" BorderStyle="None" CssClass="RoundpanelNarr RoundpanelNarrExtra">
            <h1 class="Ttlepopu labelChange">Add Branch</h1>
            <div>

                <div style="display: none;">


                    <asp:Label ID="Label33" runat="server" Font-Bold="True" Font-Names="Verdana"
                        Font-Size="8pt" ForeColor="White" Text="Add Branch 1111"></asp:Label>


                </div>
                <table class="addDesignatnation">
                    <tr>
                        <td class="style4">
                            <asp:Label ID="Label1" runat="server" Text="Branch" CssClass="LabelFontStyle labelChange"></asp:Label>:
                        </td>
                        <td style="width: 250px;">
                            <asp:TextBox ID="Txt2" runat="server" CssClass="cssTextbox" Style="273px !important;"></asp:TextBox>
                            <span class="errlabelstyle" style="color: Red;">*</span>
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
                        <td class="style4"></td>
                        <td class="style2">
                            <asp:Button ID="BtnSubmit2" runat="server" CssClass="cssButton" Text="Save"
                                OnClick="BtnSubmit2_Click" />

                            <asp:Button ID="btnCancel2" runat="server" CssClass="cssButton" Text="Cancel"
                                OnClick="btnCancel2_Click" />
                            <div id="Div22" align="right">
                            </div>
                        </td>
                    </tr>

                </table>

            </div>
        </asp:Panel>
    </div>








    <div id="griddiv" class="totbodycatreg">

        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlDataSource12" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>

        <asp:HiddenField ID="hidpermission" runat="server" />

    </div>


</div>
