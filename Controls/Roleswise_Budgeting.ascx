<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Roleswise_Budgeting.ascx.cs" Inherits="controls_Roleswise_Budgeting" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<link href="../StyleCss/Divstyle.css" rel="stylesheet" type="text/css" />
<%@ Register src="MessageControl.ascx" tagname="MessageControl" tagprefix="uc1" %>

<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />

<div class="divstyle">
<div class="headerpage">
<div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
            <asp:Label ID="Label2" runat="server" CssClass="Head1" Text="Roleswise Budgeting"></asp:Label>
        </div>

        <fieldset style="border: solid 1px black; padding: 10px;">
        <legend style="font-weight:bold; color:Red;"></legend>
        <table>
        <tr>
        <td style="width:50px;"></td>
        <td style="overflow: hidden; width: 130px; float: left; padding-left: 5px; font-weight:bold;">Roles</td>
        <td style="overflow: hidden; width: 300px; float: left;"><asp:DropDownList ID="drpbranch" runat="server" CssClass="DropDown"
                    DataSourceID="" Height="27px" DataTextField="BranchName"
                    DataValueField="BrId" Width="275px" AppendDataBoundItems="True">
                    <asp:ListItem Value="0">--Select--</asp:ListItem>
                </asp:DropDownList><asp:Label ID="Label23" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label></td>
        <td style="overflow: hidden; width: 130px; float: left; padding-left: 5px; font-weight:bold;">Staff</td>
        <td ><asp:DropDownList ID="DropDownList1" runat="server" CssClass="DropDown"
                    DataSourceID="" Height="27px" DataTextField="BranchName"
                    DataValueField="BrId" Width="275px" AppendDataBoundItems="True">
                    <asp:ListItem Value="0">--Select--</asp:ListItem>
                </asp:DropDownList><asp:Label ID="Label47" runat="server" CssClass="errlabelstyle"
                    Text="*" ForeColor="Red"></asp:Label></td>
        </tr>
        <tr>
        <td colspan="5" style="height:7px;">
        </td></tr>
        <tr>
       <td style="width:50px;"></td>
        <td style="overflow: hidden; width: 130px; float: left; padding-left: 5px; font-weight:bold;">Roles</td>
        <td style="overflow: hidden; width: 300px; float: left"><asp:DropDownList ID="DropDownList2" runat="server" CssClass="DropDown"
                    DataSourceID="" Height="27px" DataTextField="BranchName"
                    DataValueField="BrId" Width="275px" AppendDataBoundItems="True">
                    <asp:ListItem Value="0">--Select--</asp:ListItem>
                </asp:DropDownList>
        <asp:Label ID="Label1" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label></td>
        <td style="overflow: hidden; width: 130px; float: left; padding-left: 5px; font-weight:bold;">Department</td>
        <td ><asp:DropDownList ID="DropDownList3" runat="server" CssClass="DropDown"
                    DataSourceID="" Height="27px" DataTextField="BranchName"
                    DataValueField="BrId" Width="275px" AppendDataBoundItems="True">
                    <asp:ListItem Value="0">--Select--</asp:ListItem>
                </asp:DropDownList><asp:Label ID="Label8" runat="server" CssClass="errlabelstyle"
                    Text="*" ForeColor="Red"></asp:Label></td>
        </tr>
         
         
         
        
        </table>
        </fieldset>
</div>
</div>