<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="ManagePermission.aspx.cs" Inherits="Admin_ManagePermission" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
 <script type="text/javascript">
     $(document).ready(function () {

         $("input[type=checkbox][id*=CheckBox1]").live("click", function () {
             var chektf = $(this).prop('checked');

             var colsesttable = $(this).closest("table");

             $("input[type=checkbox]", colsesttable).each(function () {
                 if (chektf)
                 { $(this).prop("checked", "checked"); }
                 else
                 { $(this).removeProp("checked"); }
             });


         });

 
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
            height: 20px;
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
            cursor: pointer;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="divstyle" style="height:auto";>
      <div class="headerstyle_admin">
     <div class="headerstyle1_admin">
            <asp:Label ID="Label19" runat="server" Text="Manage Permission" CssClass="Head5"></asp:Label>
        </div></div>
    <asp:UpdateProgress DynamicLayout="false" ID="UpdateProgress1" runat="server">
          <ProgressTemplate>
              <div id="fixme" style="display: none;">
                  <div style="margin: auto; bottom: 50%; width: 74px; position: absolute; color: White;
                      font-size: 12px; left: 48%">
                      <img src="../images/ajax-loaderFacebook.gif" align="absmiddle" alt="loading" />
                      loading...
                  </div>
              </div>
             <%-- <img src="../images/ajax-loaderFacebook.gif" /> Loading ...--%></ProgressTemplate>
    </asp:UpdateProgress>
     <div style="width:885px;padding-left:10px;padding-right:5px;float:left;padding-top:10px;">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table border="0" cellpadding="2" cellspacing="2" style="width: 100%">
                <tr>
                    <td align="left" style="width: 15%;padding-left: 1%;" valign="top">
                        Select Company
                    </td>
                    <td align="left" valign="top" style="padding-left: 2%;padding-bottom:10px">
                        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" CssClass="dropstyle" DataSourceID="SqlDataSource2" Width="257px"
                            DataTextField="RoleName" DataValueField="RoleID" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                            ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" 
                            SelectCommand="SELECT [CompanyName] as RoleName, [CompId] as RoleID FROM [Company_Master] order by CompanyName">                            
                        </asp:SqlDataSource><asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                        <ProgressTemplate>
                            <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                    </asp:UpdateProgress>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="2" valign="top" style="padding-top:5px;">
                        <asp:GridView ID="GridViewPairCommission" runat="server" AllowSorting="True" BorderColor="#55A0FF" AutoGenerateColumns="False"
                            CssClass="grdMain" CellPadding="4" DataKeyNames="MasterPageID" DataSourceID="SQLPages"
                            GridLines="Horizontal" HorizontalAlign="Center" Width="98%">
                            <FooterStyle CssClass="grdfooter" />
                            <RowStyle CssClass="grdRows" />
                            <EditRowStyle CssClass="grdEditRow" />
                            <SelectedRowStyle CssClass="grdSelectedRow" />
                            <PagerStyle CssClass="grdPageStyle" />
                            <HeaderStyle CssClass="grdheadermster" />
                            <AlternatingRowStyle CssClass="grdAltrRows" />
                            <Columns>
                                <asp:TemplateField InsertVisible="False" SortExpression="MasterPageID">
                                    <EditItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("MasterPageID") %>'></asp:Label>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <table border="0" cellpadding="2" cellspacing="0" style="width: 100%">
                                            <tr>
                                                <td align="left" style="width: 20%;padding-left:5px;padding-top:5px">
                                                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("MasterChecked") %>'
                                                        Text='<%# Eval("PageTitle") %>' ValidationGroup='<%# Eval("MasterPageID") %>' />
                                                </td>
                                                <td align="left">
                                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("PageName") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td >
                                                    <asp:SqlDataSource ID="SqlDataSourceSubpage" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                                                        ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" SelectCommand="SELECT s.SubPageID, ' '+PageTitle AS Name,  CASE WHEN (a.SAdmin_Access) = 0 then CONVERT (bit , 0) ELSE CONVERT (bit , 1) END AS SubpageChecked FROM Subpage s inner join subpageaccess a on s.subpageid=a.subpageid WHERE s.MasterPageID = @page_master_id and a.compid=@roleid">
                                                        <SelectParameters>
                                                            <asp:ControlParameter ControlID="lblMasterID" Name="page_master_id" PropertyName="Text" />
                                                            <asp:ControlParameter ControlID="DropDownList1" Name="roleID" PropertyName="SelectedValue" />
                                                        </SelectParameters>
                                                    </asp:SqlDataSource>
                                                    <asp:Label ID="lblMasterID" runat="server" Text='<%# Eval("MasterPageID") %>' Visible="false"></asp:Label>
                                                </td>
                                                <td align="left">
                                                    <asp:DataList ID="DataList1" runat="server" DataKeyField="SubPageID" DataSourceID="SqlDataSourceSubpage"
                                                        RepeatColumns="2" RepeatDirection="Horizontal" CellPadding="2" Width="100%">
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="CheckBox2" runat="server" Checked='<%# Eval("SubpageChecked") %>'
                                                                Text='<%# Eval("Name") %>' ValidationGroup='<%# Eval("SubPageID") %>' />
                                                        </ItemTemplate>
                                                        <ItemStyle Width="33%" Height="30px" />
                                                    </asp:DataList>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SQLPages" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                            ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" SelectCommand="SELECT m.MasterPageID, ' '+PageTitle as PageTitle, PageName,  CASE WHEN (a.SAdmin_Access) = 0 then CONVERT (bit , 0) ELSE CONVERT (bit , 1) END AS MasterChecked FROM MasterPages m inner join masterpageaccess a on m.MasterPageID=a.MasterPageID where m.status=0 and a.compid=@roleid order by PageOrder">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="DropDownList1" Name="roleID" PropertyName="SelectedValue" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </td>
                </tr>
                <tr>
                    <td align="right" valign="top">
                    </td>
                    <td align="left" valign="top" style="padding-left: 45px;padding-top:5px;" >
                        <asp:Button ID="ButtonSubmit" runat="server" CssClass="buttonstyle_search" OnClick="ButtonSubmit_Click"
                            Text="Submit" />
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    </div>
    </div>
    
</asp:Content>

