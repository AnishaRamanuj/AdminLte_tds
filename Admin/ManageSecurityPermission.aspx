<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="ManageSecurityPermission.aspx.cs" Inherits="Admin_ManageSecurityPermission"  %>

<%@ Register src="../controls/ManageSecurityPermission.ascx" tagname="ManageSecurityPermission" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <uc1:ManageSecurityPermission ID="ManageSecurityPermission1" runat="server" />
</asp:Content>

