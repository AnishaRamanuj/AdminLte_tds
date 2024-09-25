<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="EditCompanyProfile.aspx.cs" Inherits="Admin_EditCompanyProfile" %>

<%@ Register src="../controls/Editcompanycontrol.ascx" tagname="Editcompanycontrol" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <uc1:Editcompanycontrol ID="Editcompanycontrol1" runat="server" />
</asp:Content>

