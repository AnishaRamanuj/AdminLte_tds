<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="MangePageLinks.aspx.cs" Inherits="Admin_MangePageLinks"%>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <div class="divstyle" style="height:auto";>
        <div class="headerstyle_admin" style="padding-bottom:10px;">
     <div class="headerstyle1_admin">
            <asp:Label ID="Label19" runat="server" Text="Manage Pages" CssClass="Head5"></asp:Label>
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
    <div style="width:885px;padding-left:10px;padding-right:5px">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table cellspacing="2" cellpadding="2" width="100%" align="center" border="0">
                <tbody>
                    <tr>
                        <td width="100%" colspan="2" height="5">
                            <asp:Label ID="lbl_msg" runat="server" CssClass="red"></asp:Label>
                        </td>
                    </tr>
                </tbody>
            </table>
            <asp:MultiView ID="mltItems" runat="server" ActiveViewIndex="1">
                <asp:View ID="vwNew" runat="server">
                    <table width="100%" border="0" align="center" cellpadding="2" cellspacing="2">
                        <tr>
                            <td colspan="2" align="right" valign="middle">
                                <asp:Label ID="lblPageMasterID" runat="server" Visible="False"></asp:Label>
                                <asp:LinkButton ID="lnkManage" runat="server" CssClass="adminlinks" OnClick="lnkManage_Click"
                                    CausesValidation="False">View Page Details</asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td width="40%" class="cont" align="right">
                                Menu Title
                            </td>
                            <td width="60%" align="left">
                                <asp:TextBox ID="Txt_Title" runat="server" CssClass="cont" Width="245px" ValidationGroup="cms"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rvType" runat="server" ControlToValidate="Txt_Title"
                                    CssClass="red" Display="Dynamic" ErrorMessage="Enter Menu Title" ValidationGroup="cms"></asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        
                        <tr>
                            <td width="40%" class="cont" align="right">
                                Menu Link
                            </td>
                            <td width="60%" class="cont" align="left">
                                <asp:TextBox ID="Txt_Link" runat="server" CssClass="cont" Width="245px" ValidationGroup="cms"></asp:TextBox>
                            </td>
                        </tr>
                        
                        <tr>
                            <td colspan="2" align="center">
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td align="left">
                                <asp:Button ID="btnSubmit" runat="server" CssClass="buttonstyle_search" OnClick="btnSubmit_Click"
                                    Text="Submit" ValidationGroup="cms" />
                            </td>
                        </tr>
                    </table>
                </asp:View>
                <asp:View ID="vwManage" runat="server">
                    <table cellspacing="2" cellpadding="2" width="100%" align="center" border="0">
                        <tbody>
                            <tr>
                                <td valign="middle" align="right" colspan="2">
                                    <asp:LinkButton ID="lnkAdd" OnClick="lnkAdd_Click" runat="server" CssClass="adminlinks">Add New Page</asp:LinkButton>
                                </td>
                            </tr>
                             <tr>
                    <td align="left" style="width: 10%;padding-left:2px;padding-bottom:10px" valign="top">
                        Select Role
                    </td>
                    <td align="left" valign="top">
                        <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" CssClass="dropstyle"
                            OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged" Width="100px">
                            <asp:ListItem Value="0">Company</asp:ListItem>
                            <asp:ListItem Value="1">Staff</asp:ListItem>
                        </asp:DropDownList>
                        <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                        <ProgressTemplate>
                            <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                    </asp:UpdateProgress>
                    </td>
                </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:DataList ID="dtMasterPages" runat="server" Width="100%" HorizontalAlign="Center" 
                                        DataSourceID="SQLPages" DataKeyField="MasterPageID">
                                        <AlternatingItemStyle BackColor="#F7F7F7"></AlternatingItemStyle>
                                        <ItemStyle CssClass="grdRow"></ItemStyle>
                                         <HeaderStyle CssClass="grdheadermster" />
                                        <HeaderTemplate>
                                            <table border="0" cellpadding="3" cellspacing="0" class="grdheadermster" style="width: 100%">
                                                <tr>
                                                    <td class="heading_white" style="width: 4%;padding-left:10px;" >
                                                        Edit
                                                    </td>
                                                    <td class="heading_white" style="width: 4%" >
                                                        Delete
                                                    </td>
                                                    <td class="heading_white" align="left" style="width: 26%" >
                                                        Page Title
                                                    </td>
                                                    <td class="heading_white" align="left" style="text-align: left; width: 20%;">
                                                        Link
                                                    </td>
                                                    <td  class="heading_white" style="width:5%;" align="right">Order</td>
                                                    <td class="heading_white" style="width: 5%" align="right">
                                                        Subpage
                                                    </td>
                                                </tr>
                                            </table>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <table style="width: 100%" cellspacing="0" cellpadding="3" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td style="width: 5%;" align="center">
                                                            <asp:ImageButton ID="ImgEdit" OnClick="ShowEdit" runat="server" ImageUrl="~/images/Edit_sm.gif">
                                                            </asp:ImageButton>
                                                        </td>
                                                        <td style="width: 5%;padding-left:5px;">
                                                            <asp:ImageButton ID="ImgDelete" OnClick="ShowDelete" runat="server" ImageUrl="~/images/Delete_sm.gif" onclientclick="javascript : return confirm('Are you sure want to delete?');">
                                                            </asp:ImageButton>
                                                        </td>
                                                        <td style="width: 30%">
                                                            <asp:Label ID="fpage_nameLabel" runat="server" Text='<%# Eval("PageTitle") %>'></asp:Label>
                                                        </td>
                                                        <td style="width: 25%">
                                                            <asp:Label ID="fpage_linkLabel" runat="server" Text='<%# Eval("PageName") %>'></asp:Label>
                                                        </td>
                                                        <td  style="width: 5%;" align="center" >
                                                            <asp:ImageButton ID="ImageButtonUp" runat="server" CommandArgument='<%# Eval("MasterPageID") %>'
                                                                ImageUrl="~/images/up_arrow.JPG" OnClick="ImageButtonUp_Click" />&nbsp;
                                                            <asp:ImageButton ID="ImageButtonDown" runat="server" CommandArgument='<%# Eval("MasterPageID") %>'
                                                                ImageUrl="~/images/down_arrow.jpg" OnClick="ImageButtonDown_Click" />
                                                        </td>
                                                        <td style="width: 5%" align="center">
                                                            <asp:Panel ID="Panel2" runat="server" CssClass="collapsePanelHeader" Height="30px">
                                                                <div style="vertical-align: middle; cursor: pointer">
                                                                    <%--<div style="float: left; margin-left: 20px;">
                                            <asp:Label ID="Label1" runat="server">(Show Details...)</asp:Label>
                                        </div>--%>
                                                                    <div style="float: right; vertical-align: middle; padding-top: 5px;padding-right:15px">
                                                                        <asp:ImageButton ID="Image1" runat="server" ImageUrl="~/images/edit_f2.png" AlternateText="(Show Details...)">
                                                                        </asp:ImageButton>
                                                                    </div>
                                                                </div>
                                                            </asp:Panel>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="5">
                                                             <asp:Label ID="LabelPageMasterID" runat="server" Visible="False" Text='<%# Eval("MasterPageID") %>'></asp:Label>
                                                            <asp:Panel ID="Panel1" runat="server" CssClass="collapsePanel" Width="100%" Height="0">
                                                                <table style="background-color: transparent" cellspacing="0" cellpadding="0" width="100%"
                                                                    border="0">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td align="right">
                                                                                <asp:LinkButton ID="lnkAdd" OnClick="lnkAddSubpage_Click" runat="server" CssClass="adminlinks"
                                                                                    Text="Add Subpage" CommandArgument='<%# Eval("MasterPageID") %>'></asp:LinkButton>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:GridView ID="GrdTypeMaster" runat="server" Width="100%" BorderColor="#55A0FF" DataSourceID="SqlDataSourceSubpage"
                                                                                    EmptyDataText="No subpage found" DataKeyNames="SubPageID" AutoGenerateColumns="False"
                                                                                    GridLines="Horizontal" CellPadding="3" BorderWidth="1px" BorderStyle="None" 
                                                                                    BackColor="White">
                                                                                    <FooterStyle CssClass="grdfooter" />
                                                                                    <RowStyle CssClass="grdRows" />
                                                                                    <EditRowStyle CssClass="grdEditRow" />
                                                                                    <SelectedRowStyle CssClass="grdSelectedRow" />
                                                                                    <PagerStyle CssClass="grdPageStyle" />
                                                                                    <HeaderStyle CssClass="grdheadermster" />
                                                                                    <AlternatingRowStyle CssClass="grdAltrRows" />
                                                                                    <Columns>
                                                                                        <asp:TemplateField HeaderText="Edit"><ItemTemplate><asp:ImageButton ID="ImgEdit" OnClick="ImgEdit_Click" runat="server" ImageUrl="~/images/Edit_sm.gif"
                                                                                                    CommandArgument='<%# Eval("SubPageID") %>'></asp:ImageButton></ItemTemplate><HeaderStyle HorizontalAlign="Left" CssClass="heading_white"></HeaderStyle><ItemStyle HorizontalAlign="Left" Width="25px"></ItemStyle></asp:TemplateField>
                                                                                        <asp:TemplateField HeaderText="Delete"><ItemTemplate><asp:ImageButton ID="ImgDelete" runat="server" ImageUrl="~/images/Delete_sm.gif" onclientclick="javascript : return confirm('Are you sure want to delete?');"
                                                                                                    OnClick="ImgDelete_Click" CommandArgument='<%# Eval("SubPageID") %>' /></ItemTemplate><HeaderStyle HorizontalAlign="Left" CssClass="heading_white"></HeaderStyle><ItemStyle HorizontalAlign="Left" Width="25px"></ItemStyle></asp:TemplateField>
                                                                                        <asp:BoundField DataField="PageTitle" HeaderText="Page Title" SortExpression="PageTitle"><HeaderStyle HorizontalAlign="Left" CssClass="heading_white"></HeaderStyle><ItemStyle HorizontalAlign="Left" Width="220px"></ItemStyle></asp:BoundField>
                                                                                        <asp:BoundField DataField="PageName" HeaderText="Link" SortExpression="PageName"><HeaderStyle HorizontalAlign="Left" CssClass="heading_white"></HeaderStyle><ItemStyle HorizontalAlign="Left"></ItemStyle></asp:BoundField>
                                                                                    </Columns>
                                                                                </asp:GridView>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </asp:Panel>
                                                       
                                                            <asp:SqlDataSource ID="SqlDataSourceSubpage" runat="server" SelectCommand="SELECT SubPageID, PageTitle, PageName FROM Subpage WHERE (MasterPageID = @page_master_id)"
                                                                ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
                                                                <SelectParameters>
                                                                    <asp:ControlParameter ControlID="LabelPageMasterID" Name="page_master_id" PropertyName="Text" />
                                                                </SelectParameters>
                                                            </asp:SqlDataSource>
                                                            <cc1:CollapsiblePanelExtender ID="cpeCMS" runat="Server" SkinID="CollapsiblePanelDemo"
                                                                SuppressPostBack="true" CollapsedImage="../images/edit_f2.png" ExpandedImage="../images/Copy of collapse_blue.jpg"
                                                                CollapsedText="(Show Details...)" ExpandedText="(Hide Details...)" ImageControlID="Image1"
                                                                Collapsed="True" CollapseControlID="Panel2" ExpandControlID="Panel2" TargetControlID="Panel1"></cc1:CollapsiblePanelExtender>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </ItemTemplate>
                                    </asp:DataList>
                                    <asp:SqlDataSource ID="SQLPages" runat="server" SelectCommand="SELECT MasterPageID, PageTitle, PageName,PageOrder FROM MasterPages where status=@roleID Order By PageOrder"
                                        ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
                                         <SelectParameters>
                                <asp:ControlParameter ControlID="DropDownList1" Name="roleID" PropertyName="SelectedValue" />
                            </SelectParameters>
                                    </asp:SqlDataSource>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </asp:View>
            </asp:MultiView>
            <input id="Item_ID" type="hidden" name="Item_ID" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
    </div>
    </div>
</asp:Content>

