<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddRecords.ascx.cs" Inherits="controls_AddRecords" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        var newDate = new Date();
        $("[id*=hdnDT]").val(newDate);
    });
    </script>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
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
        height: 20px;
    }
    .headerstyle1_page
    {
        border-bottom: 1px solid #55A0FF;
        float: left;
        overflow: hidden;
        margin: 0 0 10px;
        width: 100%;
        height: 20px;
    }
    .headerpage
    {
        height: 23px;
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
    
    .Button:hover
    {
        border-color: #FFCC33;
    }
    .modalBackground
    {
        background-color: Gray;
        filter: alpha(opacity=70);
        opacity: 0.7;
    }
    .error
    {
        color: #fff !important;
        margin: 0 0 10px;
        background-color: #FFBABA;
        width: 100%;
    }
    .style1
    {
        width: 100%;
    }
    .headerstyle1_master
    {
        width: 1258px;
    }
    .style2
    {
        width: 133px;
    }
    
    .style3 span
    {
        color: #474747 !important;
    }
    .style3
    {
        color: #474747;
        font-size: 12px;
        font-weight: bold;
        height: 35px;
        width: 104px;
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
<style type="text/css">
    .cssPageTitle
{
    font: bold 14px verdana, arial, "Trebuchet MS" , sans-serif;
    border-bottom: 2px solid #0b9322;  
    color: #0b9322;
}
.cssButton
{
    cursor: pointer; /*background-image: url(../Images/ButtonBG1.png);*/
    background-color: #d3d3d3;
    border: 0px;
    padding: 4px 15px 4px 15px;
    color: Black;
    border: 1px solid #c4c5c6;
    border-radius: 3px;
    font: bold 12px verdana, arial, "Trebuchet MS" , sans-serif;
    text-decoration: none;
    opacity: 0.8;

}
.cssButton:focus
{
    background-color: #69b506;
    border: 1px solid #3f6b03;
    color: White;
    opacity: 0.8;
}
.cssButton:hover
{
    background-color: #69b506;
    border: 1px solid #3f6b03;
    color: White;
    opacity: 0.8;
}
.cssPageTitle2
{
    font: bold 14px verdana, arial, "Trebuchet MS" , sans-serif;
    /*border-bottom: 2px solid #0b9322;*/
    padding: 7px;
    color: #0b9322;
}
   .cssTextbox
{
    font: normal 12px verdana, arial, "Trebuchet MS" , sans-serif;
    height: 15px;
    border-radius: 4px;
    border: 1px solid #b5b5b5;
}

.cssTextboxLong
{
    font: normal 12px verdana, arial, "Trebuchet MS" , sans-serif;
    width: 350px;
    height: 25px;
    border-radius: 4px;
    border: 1px solid #b5b5b5;
}
.cssTextbox:focus
{
    box-shadow: 0 0 5px rgba(81, 203, 238, 1);
    padding: 3px 0px 3px 3px;
    border: 1px solid rgba(81, 203, 238, 1);
}

.cssTextbox:hover
{
    border: 1px solid rgba(81, 203, 238, 1);
}

.cssTextboxInt
{
    font: normal 12px verdana, arial, "Trebuchet MS" , sans-serif;
    height: 25px;
    text-align: right;
    border-radius: 4px;
    border: 1px solid #b5b5b5;
    padding-right: 5px;
}

.cssTextboxInt:focus
{
    box-shadow: 0 0 5px rgba(81, 203, 238, 1);
    padding-right: 5px;
    border: 1px solid rgba(81, 203, 238, 1);
}

.cssTextboxInt:hover
{
    padding-right: 5px;
    border: 1px solid rgba(81, 203, 238, 1);
}
    </style>
<div>
    <div>
         <table style="width: 100%" class="cssPageTitle">
        <tr>
            <td class="cssPageTitle2">
                <asp:Label ID="lblname" runat="server" style="margin-left:10px;"  Text="Manage Designation"></asp:Label>
            </td>           
        </tr>
    </table>
       <asp:HiddenField ID="hdnDT" runat="server" />
    </div>
    <div id="Div1" runat="server" class="masterdiv1a">
        <div style="float: center">
            <uc1:MessageControl ID="MessageControl2" runat="server" />
            <div class="serachJob" style="float: left">
                <div style="float: left; width: 100%; margin:10px; padding-bottom: 5px; overflow: auto;" id="searchdesg"
                    runat="server">
                    <asp:Label ID="Label21" style="margin-left:10px;" runat="server" CssClass="LabelFontStyle labelChange" Text="Search Designation"></asp:Label>
                    &nbsp;&nbsp;
                    <asp:TextBox ID="txtdesgsearch" runat="server" CssClass="cssTextbox" Width="250px" Font-Names="Verdana" onkeyup="CountFrmTitle(this,70);"
                        Font-Size="8pt"></asp:TextBox>
                    &nbsp;<asp:Button ID="btnsesg" runat="server" CssClass="cssButton"
                        OnClick="btnsesg_Click" Text="Search" />
                    &nbsp;&nbsp;<asp:Button ID="Button4" runat="server" CssClass="cssButton"
                        OnClick="Button4_Click" Text="Add Designation" />
                </div>
            </div>
            <div>
            </div>
            <div style="float: right; text-align: right; width: 100%; padding-top: 5px;">
                <div id="ctl00_ContentPlaceHolder1_AddRecords1_Panel14">
	
                
</div>
            </div>
            <div class="tableNewadd" style="float: right; margin:10px; padding-left:10px;">
                <asp:Panel ID="Panel3" runat="server">
                    <asp:GridView ID="GrdDsg" runat="server" CssClass="norecordTble" AutoGenerateColumns="False"
                        Width="100%"  DataKeyNames="Staffcode" AllowPaging="True"
                        EmptyDataText="No records found!!!" PageSize="50" BackColor="White" CellPadding="3"
                        OnPageIndexChanging="GrdDsg_PageIndexChanging" Font-Names="Verdana" Font-Size="9pt">
                        <PagerSettings FirstPageText="First" LastPageText="Last" PageButtonCount="10" Position="Bottom" />
                        <FooterStyle BackColor="White" ForeColor="#000066" />
                        <PagerStyle HorizontalAlign="Left" VerticalAlign="Top" BackColor="White" ForeColor="#000066" />
                        <RowStyle Height="15px" ForeColor="#000066" />
                        <Columns>
                            <asp:TemplateField HeaderText="Staff code" HeaderStyle-CssClass="grdheader labelChange" Visible="False">
                                <ItemTemplate>
                                    <div class="gridcolstyle">
                                        <asp:Label ID="lblSid" runat="server" CssClass="labelstyle" Text='<%# bind("Staffcode") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                               
                            </asp:TemplateField>
                           
                            <asp:TemplateField HeaderText="Staff Name For" HeaderStyle-CssClass="grdheader">                             
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="width: 300px; vertical-align:middle;">
                                        <asp:Label ID="lblSTname" runat="server" CssClass="labelstyle" Text='<%# bind("StaffName") %>'></asp:Label>
                                    </div>
                                    
                                </ItemTemplate>
                                <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                               
                            </asp:TemplateField>
                            
                        </Columns>
                        <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                    </asp:GridView>
                </asp:Panel>
            </div>
            <div class="divfloatleftn divfloatleftnTble" style="float: left; margin:10px; padding-left:5px; width:730px; padding-right:15px;">
                <asp:Panel ID="Panel2" runat="server" Width="100%">
                    <asp:GridView ID="Griddealers" runat="server" AutoGenerateColumns="False" Width="100%"
                        DataSourceID="SqlDataSource1" DataKeyNames="DsgId" OnRowCommand="Griddealers_RowCommand"
                        AllowPaging="True" OnPageIndexChanging="Griddealers_PageIndexChanging" PageSize="25"
                        EmptyDataText="No records found!!!" OnRowEditing="Griddealers_RowEditing" OnRowUpdating="Griddealers_RowUpdating"
                        OnRowCancelingEdit="Griddealers_RowCancelingEdit" OnRowDataBound="Griddealers_RowDataBound"
                        CssClass="norecordTble" OnRowCreated="Griddealers_RowCreated">
                        <PagerSettings FirstPageText="First" LastPageText="Last" PageButtonCount="10" Position="Bottom" />
                        <FooterStyle BackColor="White" ForeColor="#000066" />
                        <PagerStyle HorizontalAlign="Left" VerticalAlign="Middle" BackColor="White" ForeColor="#000066" />
                        <RowStyle Height="20px" Font-Names="Verdana" Font-Size="9pt" ForeColor="#000066" />
                        <Columns>
                            <asp:TemplateField HeaderText="jobid" HeaderStyle-CssClass="grdheader labelChange" Visible="False">
                                <ItemTemplate>
                                    <div class="gridcolstyle">
                                        <asp:Label ID="lblid" runat="server" CssClass="labelstyle" Text='<%# bind("DsgId") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <HeaderStyle CssClass="grdheader"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Designation Name" HeaderStyle-CssClass="grdheader ">
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="width: 300px;">
                                        <asp:LinkButton ID="lblDesg" runat="server" CommandName="view" CssClass="labelstyle"
                                            Text='<%# bind("DesignationName") %>'></asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <div class="gridcolstyle" style="width: 300px;">
                                        <asp:TextBox ID="TextBox1" runat="server" Height="16px" CssClass="cssTextbox" Text='<%# bind("DesignationName") %>'
                                            Width="180px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>
                                    </div>
                                </EditItemTemplate>
                                <HeaderStyle CssClass="grdheader labelChange" Width="520px"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Hrs. Chrg.">
                                <ItemTemplate>
                                    <div class="gridcolstyle">
                                        <asp:Label ID="Label3" runat="server" CssClass="labelstyle4" Text='<%# bind("HourlyCharges") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <div class="gridcolstyle">
                                        <asp:TextBox ID="TextBox2" runat="server" Height="16px" Text='<%# bind("HourlyCharges") %>'
                                            CssClass="cssTextbox" Width="50px" onkeyup="return  ValidateText(this);"></asp:TextBox>
                                    </div>
                                </EditItemTemplate>
                                <HeaderStyle CssClass="grdheader" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheader">
                                <ItemTemplate>
                                    <div class="gridcolstyle">
                                        <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit.png"
                                            ToolTip="Edit" Height="19px" Width="18px" />
                                    </div>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <div class="gridcolstyle">
                                        <asp:Button ID="Button2" runat="server" CssClass="cssButton" CommandName="update"
                                            Text="Update" />
                                        &nbsp;<asp:Button ID="Button3" runat="server" CssClass="cssButton"
                                            CommandName="cancel" Text="Cancel" />
                                    </div>
                                </EditItemTemplate>
                                <HeaderStyle CssClass="grdheader" Width="150px"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Delete">
                                <ItemTemplate>
                                    <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("DsgId") %>'
                                        ImageUrl="~/images/Delete.png" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                        ToolTip="Delete" CommandName="delete" />
                                </ItemTemplate>
                                <HeaderStyle CssClass="grdheader" Width="120px" />
                            </asp:TemplateField>
                        </Columns>
                        <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                    </asp:GridView>
                </asp:Panel>
            </div>
            
            <div class="reapeatItem4">
                <div id="msghead" runat="server" class="msgdiv" style="padding-left: 2%; float: left;
                    text-align: left; width: 650px;" align="left">
                </div>
               
            </div>
            <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal" runat="server">
            </asp:Button>
            <br />
            <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="modalBackground"
                CancelControlID="btnCancel" BehaviorID="programmaticModalPopupOrginalBehavior"
                DropShadow="False" PopupControlID="panelupgrade" RepositionMode="RepositionOnWindowScroll"
                TargetControlID="hideModalPopupViaClientOrginal">
            </cc1:ModalPopupExtender>
            <asp:Panel ID="panelupgrade" runat="server" DefaultButton="btndesignation" CssClass="RoundpanelNarr RoundpanelNarrExtra" Width="450px">
                <h1 class="Ttlepopu labelChange">
                    Add Designation</h1>
                <table width="100%" class="addDesignatnation">
                    <tr>
                        <td class="style3">
                            <asp:Label ID="Label31" runat="server" ForeColor="Black" Text="Designation" CssClass="LabelFontStyle labelChange"></asp:Label>
                        </td>
                        <td style="width: 250px">
                            <asp:TextBox ID="txtdesignation" runat="server" CssClass="cssTextbox" Font-Names="Verdana"
                                Font-Size="8pt" Width="250px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td class="style3">
                            <asp:Label ID="Label32" runat="server" Text="Hourly Charges" ForeColor="Black" CssClass="LabelFontStyle"></asp:Label>
                        </td>
                        <td style="width: 250px">
                            <asp:TextBox ID="txthourcharge" runat="server" CssClass="cssTextbox" onkeyup="return  ValidateText(this);"
                                Font-Names="Verdana" Font-Size="8pt" Width="75px"></asp:TextBox>
                            <asp:Label ID="Label15" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                    <td colspan="2">
                    <div class="noteText">
                Notes:
                <div class="txtboxNewError">
                    <span class="labelstyle">Fields marked with * are required</span></div>
            </div>
                    </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <asp:Button ID="btndesignation" runat="server" CssClass="cssButton"
                                Text="Save" OnClick="btndesignation_Click" />
                            &nbsp;
                            <asp:Button ID="btnCancel" runat="server" CssClass="cssButton" OnClick="btnCancel_Click"
                                Text="Cancel" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </div>
        <div id="griddiv" class="totbodycatreg">
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="SqlDataSource10" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
            </asp:SqlDataSource>
            <asp:HiddenField ID="hidpermission" runat="server" />
        </div>
    </div>
</div> 