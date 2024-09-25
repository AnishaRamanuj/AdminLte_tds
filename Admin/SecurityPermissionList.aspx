<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="SecurityPermissionList.aspx.cs" Inherits="Admin_SecurityPermissionList" %>

<%@ Register src="../controls/SecurityPermissionList.ascx" tagname="SecurityPermissionList" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <uc1:SecurityPermissionList ID="SecurityPermissionList1" runat="server" />
</asp:Content>

