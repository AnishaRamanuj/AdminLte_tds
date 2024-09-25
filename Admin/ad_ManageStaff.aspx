﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="ad_ManageStaff.aspx.cs" Inherits="Admin_ad_ManageStaff" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="divtotbody" class="totbodycatreg1" style="height:auto;padding-bottom:30px">
<div align="right">
   
</div>
<div id="divtitl" class="totbodycatreg">
<div class="headerstyle_admin">
     <div class="headerstyle1_admin">
           <asp:Label ID="Label1" runat="server" Text="Manage Staff" 
            CssClass="Head1"></asp:Label></div></div>
            
            <div align="right" style="float:right;width: 100%; padding-bottom: 5px;">
   <span><asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/images/addnew.png" 
                 PostBackUrl="~/Admin/CompanyRegistration.aspx" /></span>   <asp:LinkButton ID="lnknewclient" runat="server" CssClass="masterLinks"
        PostBackUrl="~/Company/StaffRegistration.aspx">Add New Staff</asp:LinkButton>
  
</div>
<div style="padding-bottom: 0px; padding-top: 10px; width: 100%; float: left;padding-bottom:10px;">
            <div style="padding-bottom: 0px; width: 12%; float: left; padding-left: 2%; ">
                <asp:Label ID="Label18" runat="server" Text="Company Name"></asp:Label>
            </div>
            <div style="overflow: auto;padding-bottom: 0px; width: 58%; float: left;">
                &nbsp;<asp:DropDownList ID="drpcompany" runat="server" DataTextField="CompanyName" CssClass="dropstyle" DataValueField="CompId"
                    DataSourceID="SqlDataSource9" Width="300px" AutoPostBack="True"
                    OnSelectedIndexChanged="drpcompany_SelectedIndexChanged">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource9" runat="server" SelectCommand="SELECT * from Company_Master order by CompanyName"
                    ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>">
                </asp:SqlDataSource>
            </div>
        </div>
         <div id="searchstf" runat="server" style="float:left; text-align:right; width:98.5%; padding-bottom: 5px;padding-right:1%">
 <div style="float:right">
 <%-- <div style="float:left; text-align:right; width:70%; padding-top: 5px;">--%>
      <asp:Label ID="Label21" runat="server" Text="Search Staff"></asp:Label> &nbsp;&nbsp;
             <%-- <div style="float:right; text-align:right; width:26%;padding-right:1%;">    --%><asp:TextBox ID="txtsrchdtf" runat="server" CssClass="txtnrml" Width="150px"></asp:TextBox>
                  <asp:Button ID="btnsrchstf" runat="server" Text="Search" CssClass="buttonstyle_search" onclick="btnsrchstf_Click" 
                       />
</div></div>
<div style="padding-bottom: 10px; width: 97.5%; float: left;padding-left:10px;">
        <asp:GridView ID="Griddealers" runat="server" AutoGenerateColumns="False" BorderColor="#55A0FF"
            Width="100%" DataSourceID="SqlDataSource1" DataKeyNames="StaffCode" 
               onrowcommand="Griddealers_RowCommand" AllowPaging="True" 
               onpageindexchanging="Griddealers_PageIndexChanging" EmptyDataText="No records found!!!">
            <RowStyle Height="15px" />
            <Columns>
                <asp:TemplateField HeaderText="jobid" HeaderStyle-CssClass="grdheadermster" 
                    Visible="False">
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("StaffName") %>'
                                ></asp:Label>
                        </div>
                    </ItemTemplate>                  
<HeaderStyle CssClass="grdheadermster"></HeaderStyle>                  
                </asp:TemplateField>
              
                <asp:TemplateField HeaderText="Staff Name" 
                    HeaderStyle-CssClass="grdheadermster">
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:80%;">
                         <asp:LinkButton ID="lblfrname" runat="server" CssClass="grdLinks" Text='<%# bind("StaffName") %>' CommandName="job"
                               ></asp:LinkButton>
                        </div>
                    </ItemTemplate>                  
<HeaderStyle CssClass="grdheadermster"></HeaderStyle>                  
                </asp:TemplateField>
                  <asp:TemplateField HeaderStyle-CssClass="grdheadermster" 
                    HeaderText="ClientName">                  
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:80%">
                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("ClientName") %>'></asp:Label>
                        </div>
                    </ItemTemplate>

<HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                </asp:TemplateField>
                  <asp:TemplateField HeaderText="CompanyName">
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:80%">
                            <asp:Label ID="Label6" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("CompanyName") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <ItemStyle Width="140px" />
                      <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                </asp:TemplateField>    
                  <asp:TemplateField HeaderText="Department" 
                    HeaderStyle-CssClass="grdheadermster">
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:100px;">
                            <asp:Label ID="lbldepname" runat="server" CssClass="labelstyle" Text='<%# bind("DepartmentName") %>'
                               ></asp:Label>
                        </div>
                    </ItemTemplate>                  
<HeaderStyle CssClass="grdheadermster"></HeaderStyle>                  
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Designation">
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:80px;">
                            <asp:Label ID="Label3" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("DesignationName") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="grdheadermster" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Branch">
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:80px;">
                            <asp:Label ID="lblpassword" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("BranchName") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="grdheadermster" />
                </asp:TemplateField>
                         
               <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheadermster"> 
                    <ItemTemplate>
                        <div class="gridcolstyle" align="center">
                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit_sm1.jpg" ToolTip="Edit"
                                />
                        </div>
                    </ItemTemplate>                   
<HeaderStyle CssClass="grdheadermster"></HeaderStyle>                   
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Delete">
                    <ItemTemplate>
                       <div style="width:100%" align="center">
                        <asp:ImageButton ID="btndelete" runat="server" ImageUrl="~/images/delete1.jpg" 
                            CommandArgument='<%# bind("StaffCode") %>' onclick="btndelete_Click" onclientclick="javascript : return confirm('Are you sure want to delete?');"
                            ToolTip="Delete" /></div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="grdheadermster" />
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="grdheadermster" />
        </asp:GridView>
        </div>
</div>   
<div style="width: 100%; float: left; padding-top: 5px;padding-bottom:10px; height: 10px; padding-left: 25px; margin-top: 5px; font-weight: bold;">
                        Notes:
                    </div>
                    <div class="reapeatItem12"> 
 <div style="height: 25px;padding-top:10px;float:left; text-align:left; width:100%;">
        <span class="labelstyle" style="font-size:10px;padding-left:10px">Staff Master page to add / edit clients. A single staff is associated with

multiple Jobs, Timesheet Input & Expenses Input</span>
       </div></div>
<div id="div1" class="seperotorrwr"></div>   
<div id="griddiv" class="totbodycatreg">
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
            ></asp:SqlDataSource>
    </div>
</div>
</asp:Content>

