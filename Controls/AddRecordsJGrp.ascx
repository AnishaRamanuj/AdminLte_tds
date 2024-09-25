<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddRecordsJGrp.ascx.cs"
    Inherits="controls_AddRecordsJGrp" %>
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
    .Head1
    {
        font-size: 14px;
        font-family: Verdana,Arial,Helvetica,sans-serif;
        color: #3D80E8;
        font-weight: bold;
        overflow: hidden;
        border-bottom-color: White;
    }
    .divspace
    {
        height: 10px;
    }
    .divspace1
    {
        height: 50px;
    }
    
    .pagination
    {
        font-size: 80%;
    }
    
    .pagination a
    {
        text-decoration: none;
        border: solid 1.5px #55A0FF;
        color: #15B;
    }
    .txtbox
    {
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
    
    .pagination a, .pagination span
    {
        display: block;
        float: left;
        padding: 0.1em 0.5em;
        margin-right: 1px;
        margin-bottom: 2px;
    }
    
    .pagination .current
    {
        background: #26B;
        color: #fff;
        border: solid 1px #AAE;
    }
    
    .pagination .current.prev, .pagination .current.next
    {
        color: #999;
        border-color: #999;
        background: #fff;
    }
    .Button
    {
        font-family: Verdana,Arial,Helvetica,sans-serif;
        font-size: 11px;
        font-weight: 600;
        height: 25px;
        color: #1464F4;
        -webkit-border-radius: 4px;
        -moz-border-radius: 4px;
        border-radius: 4px;
    }
    .modalBackground
    {
        background-color: Gray;
        filter: alpha(opacity=70);
        opacity: 0.7;
    }
    .error
    {
        color: #D8000C;
        background-color: #FFBABA;
        background-image: url('images/error.png');
    }
    .style1
    {
        width: 100%;
    }
    .headerstyle1_master
    {
        width: 1258px;
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
            var count = max - field.value.length;
        }
        validate();
    }

</script>
<div class="divstyle" style="height: auto">
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
            <asp:Label ID="Label18" runat="server" CssClass="Head1 labelChange" Text="Manage Job Group"
                Font-Bold="true"></asp:Label>
             <asp:HiddenField ID="hdnDT" runat="server" />
        </div>
    </div>
    <%--<div id="msghead"  runat="server" class="msgdiv">
        <span class="labelstyle" style="color:Red; font-size:smaller;">Fields marked with * are required</span>
           
        </div>--%>
    <div id="Div2" runat="server" class="masterdiv1a">
        <div style="width: 100%; float: left">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
            <div class="divspace">
            </div>
            <div id="Div3" class="seperotorrwr">
                <div id="searchdept" runat="server">
                    <div class="serachJob"  style="float: left; width: 100%; margin:10px; padding-bottom: 5px; overflow: auto;">
                        <asp:Label ID="Label22" runat="server" Text="Search Job Group" CssClass="LabelFontStyle labelChange"></asp:Label>&nbsp;&nbsp;
                        <asp:TextBox ID="txtsearchJobG" runat="server" CssClass="txtbox" Width="250px" Font-Names="Verdana"
                            Font-Size="8pt"></asp:TextBox>
                        <asp:Button ID="btnJobGsearch" runat="server" CssClass="TbleBtns TbleBtnsPading"
                            Text="Search" OnClick="btnJobGsearch_Click" />
                        &nbsp;&nbsp;
                        <asp:Button ID="btnaddJobG" runat="server" OnClick="btnaddJobG_Click" Text="Add Job Group"
                            CssClass="TbleBtns TbleBtnsPading labelChange" />
                    </div>
                </div>
            </div>
            <div style="float: right; text-align: right; width: 100%; padding-top: 5px;">
                <div style="float: left; width: 68%; padding-left: 10px">
                </div>
                <div style="float: right; width: 30%; padding-top: 5px;">
                </div>
                <asp:Panel ID="Panel14" runat="server">
                </asp:Panel>
            </div>
            <div>
                <div class="tableNewadd" style="float: right; margin:10px; padding-left:10px;">
                    <asp:Panel ID="Panel13" runat="server" Width="400px">
                        <asp:GridView ID="GrdJ" runat="server" AutoGenerateColumns="False" Width="100%" DataSourceID="SqlDataSource11"
                            DataKeyNames="mjobid" AllowPaging="True" OnPageIndexChanging="GrdJ_PageIndexChanging"
                            EmptyDataText="No records found!!!" PageSize="25" BackColor="White" CellPadding="3"
                            CssClass="norecordTble">
                            <PagerSettings FirstPageText="First" LastPageText="Last" PageButtonCount="10" Position="Bottom" />
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <PagerStyle HorizontalAlign="Left" VerticalAlign="Top" BackColor="White" ForeColor="#000066" />
                            <RowStyle Height="20px" Font-Names="Verdana" Font-Size="9pt" ForeColor="#000066" />
                            <Columns>
                                <asp:TemplateField HeaderText="mJobid" HeaderStyle-CssClass="grdheader" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblSid" runat="server" CssClass="labelstyle" Text='<%# bind("mJobid") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Job Name" HeaderStyle-CssClass="grdheader">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 300px;">
                                            <asp:Label ID="lblSTname" runat="server" CssClass="labelstyle" Text='<%# bind("mJobName") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                                </asp:TemplateField>
                            </Columns>
                            <SelectedRowStyle />
                            <HeaderStyle />
                        </asp:GridView>
                    </asp:Panel>
                </div>
                <div class="divfloatleftn divfloatleftnTble" style="float: left; margin:10px; padding-left:5px; width:730px; padding-right:15px;">
                    <asp:Panel ID="Panel15" runat="server">
                        <asp:GridView ID="GrdJG" runat="server" AutoGenerateColumns="False" Width="100%"
                            DataSourceID="SqlDataSource2" DataKeyNames="JobGId" AllowPaging="True" EmptyDataText="No records found!!!"
                            OnPageIndexChanging="GrdJG_PageIndexChanging" OnRowCommand="GrdJG_RowCommand"
                            PageSize="25" OnRowCancelingEdit="GrdJG_RowCancelingEdit" OnRowUpdating="GrdJG_RowUpdating"
                            OnRowEditing="GrdJG_RowEditing" OnRowDataBound="GrdJG_RowDataBound" BackColor="White"
                            CellPadding="3" OnSelectedIndexChanged="GrdJG_SelectedIndexChanged" CssClass="norecordTble"
                            OnRowCreated="GrdJG_RowCreated">
                            <PagerSettings FirstPageText="First" LastPageText="Last" PageButtonCount="10" Position="Bottom" />
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <PagerStyle HorizontalAlign="Left" VerticalAlign="Middle" BackColor="White" ForeColor="#000066" />
                            <RowStyle Height="20px" Font-Names="Verdana" Font-Size="9pt" ForeColor="#000066" />
                            <Columns>
                                <asp:TemplateField HeaderText="JobGId" HeaderStyle-CssClass="grdheader" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblDid" runat="server" CssClass="labelstyle" Text='<%# bind("JobGId") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Job Group Name" HeaderStyle-CssClass="grdheader">
                                    <EditItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;">
                                            <asp:TextBox ID="TextBox3" runat="server" Height="16px" Text='<%# bind("JobGroupName") %>'
                                                Width="241px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>
                                        </div>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;">
                                            <asp:LinkButton ID="lblJG" runat="server" CommandName="view" CssClass="labelstyle"
                                                Text='<%# bind("JobGroupName") %>'></asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheader">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit.png"
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
                                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("JobGId") %>'
                                            ImageUrl="~/images/Delete.png" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                            ToolTip="Delete" CommandName="delete" />
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader" />
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
        </div>
        <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server">
        </asp:Button><br />
        <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" BackgroundCssClass="modalBackground"
            CancelControlID="btnCancel2" BehaviorID="programmaticModalPopupOrginalBehavior"
            DropShadow="False" PopupControlID="panel10" RepositionMode="RepositionOnWindowScroll"
            TargetControlID="hideModalPopupViaClientOrginal2">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="panel10" runat="server" Width="400px" DefaultButton="BtnSubmit2" CssClass="RoundpanelNarr RoundpanelNarrExtra">
            <div>
                <h1 class="Ttlepopu labelChange">
                    Add Job Group</h1>
                <div style="display: none;">
                    <asp:Label ID="Label33" runat="server" Font-Bold="True" Font-Names="Verdana" Font-Size="8pt"
                        ForeColor="White" Text="Add Job Group" CssClass="labelChange"></asp:Label>
                    <%--<asp:Button ID="BtnClose2" runat="server" BackColor="White" 
                                BorderColor="White" BorderStyle="None" Font-Bold="True" Font-Names="Verdana" 
                                Font-Size="8pt" ForeColor="White" Height="16px" text="X" Width="16px" onclick="BtnClose2_Click" 
                                 />--%>
                </div>
                <table class="addDesignatnation">
                    <tr>
                        <td class="style1">
                            <asp:Label ID="Label1" runat="server" Text="Job Group" CssClass="LabelFontStyle labelChange"></asp:Label>
                        </td>
                        <td style="width: 250px;">
                            <asp:TextBox ID="Txt2" runat="server" CssClass="txtbox" Width="250px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                    <td colspan="2">
                    <div class="noteText">
            Notes:
            <div id="msghead" runat="server" class="txtboxNewError">
                <span class="labelstyle">Fields marked with * are required</span></div>
        </div></td>
                    </tr>
                    <tr>
                        <td style="width: 120px !important;">
                        </td>
                        <td class="style2">
                            <asp:Button ID="BtnSubmit2" runat="server" CssClass="TbleBtns TbleBtnsPading" Text="Save"
                                Width="70px" OnClick="BtnSubmit2_Click1" />
                            &nbsp;
                            <asp:Button ID="btnCancel2" runat="server" CssClass="TbleBtns TbleBtnsPading" Text="Cancel"
                                Width="70px" OnClick="btnCancel2_Click" />
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
    </div>
    <div id="griddiv" class="totbodycatreg">
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource11" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
        </asp:SqlDataSource>
    </div>
</div>
