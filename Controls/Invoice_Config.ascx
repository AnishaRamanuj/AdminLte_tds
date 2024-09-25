<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Invoice_Config.ascx.cs" Inherits="controls_Invoice_Config" %>
<style type="text/css">
    .style1
    {
        width: 100%;
    }
</style>

        <table cellpadding="0" cellspacing="0" class="style1" 
            style="font-family: Verdana; font-size: 10pt; font-weight: normal">
            <tr>
                <td colspan="3" class="d_row">
                    <asp:Label ID="Label4" runat="server" Font-Bold="True" 
                        Text="Invoice Configuration"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="style2">
                    &nbsp;</td>
                <td class="style3">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right" class="style4">
                    <asp:Label ID="Label1" runat="server" Text="Prefix"></asp:Label>
                </td>
                <td align="center" class="style3">
                    :</td>
                <td>
                    <asp:TextBox ID="txtprefix" runat="server" Width="212px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right" class="style4">
                    <asp:Label ID="Label2" runat="server" Text="Suffix"></asp:Label>
                </td>
                <td align="center" class="style3">
                    :</td>
                <td>
                    <asp:TextBox ID="txtSuffix" runat="server" Width="212px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right" class="style4">
                    <asp:Label ID="Label3" runat="server" Text="Voucher No"></asp:Label>
                </td>
                <td align="center" class="style3">
                    :</td>
                <td>
                    <asp:TextBox ID="txtVoucher" runat="server" Width="212px"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td align="right" class="style4">
                    &nbsp;</td>
                <td align="center" class="style3">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="left" class="style4" colspan="3">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Button ID="btnsubmit" runat="server" onclick="btnsubmit_Click" 
                        Text="Submit" />
                    &nbsp; <asp:Button ID="btnreset" runat="server" onclick="btnreset_Click" 
                        Text="Reset" />
                </td>
            </tr>
            <tr>
                <td class="style2">
                    &nbsp;</td>
                <td class="style3">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
        </table>





