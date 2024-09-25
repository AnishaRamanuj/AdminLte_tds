<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/MasterPage.master" AutoEventWireup="true"
    CodeFile="pagemenumaster.aspx.cs" Inherits="Admin_pagemenumaster" %>

<%@ Register Src="../controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="headerstyle1_admin">
        <asp:Label ID="Label1" runat="server" Text="Page Menu Masters" CssClass="Head1"></asp:Label>
    </div>
    <br />
    <center>
        <div style="width: 100%">
            <uc1:MessageControl ID="MessageControl2" runat="server" />
        </div>
    </center>
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="group1"
        ShowMessageBox="true" ShowSummary="false" />
    <br />
    <div id="div1" runat="server" style="width: 100">
        <center>
            <table>
                <tr>
                    <td>
                        GroupMenu
                    </td>
                    <td>
                        :
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlgroupname" runat="server" CssClass="dropstyle">
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlgroupname"
                            Display="None" ErrorMessage="Please select group menu" ValidationGroup="group1"
                            InitialValue="0"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Menu Title
                    </td>
                    <td>
                        :
                    </td>
                    <td>
                        <asp:TextBox ID="txtmenutitle" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtmenutitle"
                            Display="None" ErrorMessage="Please Enter Title Menu" ValidationGroup="group1"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        PageName
                    </td>
                    <td>
                        :
                    </td>
                    <td>
                        <asp:TextBox ID="txtpagename" runat="server" AutoPostBack="false"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtpagename"
                            Display="None" ErrorMessage="Please select Page Name " ValidationGroup="group1"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Page Status
                    </td>
                    <td>
                        :
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlpagestatus" runat="server" CssClass="dropstyle">
                            <asp:ListItem Selected="True" Value="0">Please select status</asp:ListItem>
                            <asp:ListItem>Admin</asp:ListItem>
                            <asp:ListItem>Staff</asp:ListItem>
                            <asp:ListItem>both</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="ddlpagestatus"
                            ErrorMessage="Please select page status" Display="None" InitialValue="0" ValidationGroup="group1"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        Sub Menu
                    </td>
                    <td>
                        :
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlsubmenu" runat="server">
                            <asp:ListItem Selected="True" Value="0">No</asp:ListItem>
                            <asp:ListItem Value="1">Yes</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        Subpage Name
                    </td>
                    <td>
                        :
                    </td>
                    <td>
                        <asp:TextBox ID="txtsubpage" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                    Default Page
                    </td>
                    <td>:</td>
                    <td>
                    <asp:CheckBox ID="chkdefault" runat="server" />
                    </td>
                    </tr>
                    <tr>
                     <td>
                    Default Staff Page
                    </td>
                      <td>:</td>
                    <td><asp:CheckBox ID="chkstaff" runat="server" /></td>
                    </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="btnsubmit" runat="server" Text="Submit" CssClass="buttonstyle" ValidationGroup="group1"
                            OnClick="btnsubmit_Click" />
                    </td>
                    <td>
                        <asp:Button ID="btncancel" runat="server" Text="Cancel" CssClass="buttonstyle" OnClick="btncancel_Click"
                            CausesValidation="false" />
                        <asp:HiddenField ID="Hid_id" runat="server" Value="0" />
                    </td>
                </tr>
            </table>
        </center>
    </div>
    <div id="div2" runat="server" style="padding-left: 20px;">
        <table>
            <tr>
                <td>
                    Enter Page name:
                    <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
                    <asp:Button ID="btnsearch" runat="server" Text="search" CssClass="buttonstyle_search"
                        OnClick="btnsearch_Click" />
                    <asp:Button ID="btnAdd" runat="server" Width="110" Text="Add new Menu" CssClass="buttonstyle_search"
                        OnClick="btnAdd_Click" />
                </td>
            </tr>
        </table>
    </div>
    <br />
    <div id="div3" runat="server">
        <asp:GridView ID="gv_pagemenu" runat="server" AutoGenerateColumns="false" EmptyDataText="No records found!!!"
            ShowHeaderWhenEmpty="true" Width="98%" BorderColor="#55A0FF" CssClass="gridcolstyle"
            OnRowCommand="rowcommandpagemenu">
            <Columns>
                <asp:TemplateField HeaderText="Group Name" HeaderStyle-CssClass="grdheadermster">
                    <ItemStyle Width="50%" />
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:Label ID="name" runat="server" CssClass="grdLinks" Text='<%#Eval("Name") %>'
                                Style='text-transform: capitalize'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Menu Title" HeaderStyle-CssClass="grdheadermster">
                    <ItemStyle Width="20%" />
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:Label ID="Title" runat="server" CssClass="grdLinks" Text='<%#Eval("Menu_Title") %>'
                                Style='text-transform: capitalize'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Page Name" HeaderStyle-CssClass="grdheadermster">
                    <ItemStyle Width="20%" />
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:Label ID="pagename" runat="server" CssClass="grdLinks" Text='<%#Eval("PageName") %>'
                                Style='text-transform: capitalize'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Page Status" HeaderStyle-CssClass="grdheadermster">
                    <ItemStyle Width="20%" />
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:Label ID="pagestaus" runat="server" CssClass="grdLinks" Text='<%#Eval("PageStatus") %>'
                                Style='text-transform: capitalize'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Sub Menu" HeaderStyle-CssClass="grdheadermster">
                    <ItemStyle Width="20%" />
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:Label ID="SubMenu" runat="server" CssClass="grdLinks" Text='<%#Eval("SubMenu") %>'
                                Style='text-transform: capitalize'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Sub Page Name" HeaderStyle-CssClass="grdheadermster">
                    <ItemStyle Width="20%" />
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:Label ID="SubName" runat="server" CssClass="grdLinks" Text='<%#Eval("SubName") %>'
                                Style='text-transform: capitalize'></asp:Label>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Order UP" HeaderStyle-CssClass="grdheadermster">
                    <ItemStyle Width="10%" />
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:ImageButton ID="up" runat="server" CommandArgument='<%#Eval("ID") %>' CommandName="UP"
                                ImageUrl="~/images/up_arrow.JPG" Width="24" CssClass="buttonstyle_search" /></div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Order DOWN" HeaderStyle-CssClass="grdheadermster">
                    <ItemStyle Width="10%" />
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:ImageButton ID="down" runat="server" CommandArgument='<%#Eval("ID") %>' CommandName="DOWN"
                                ImageUrl="~/images/down_arrow.jpg" Width="24" CssClass="buttonstyle_search" />
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheadermster">
                    <ItemStyle Width="10%" />
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:ImageButton ID="edit" runat="server" CommandArgument='<%#Eval("ID") %>' CommandName="myedit"
                                Text="Edit" CssClass="buttonstyle_search" Width="24" CausesValidation="false"
                                ImageUrl="~/images/edit.png" /></div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Delete" HeaderStyle-CssClass="grdheadermster">
                    <ItemStyle Width="10%" />
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:ImageButton ID="Delete" runat="server" CommandArgument='<%#Eval("ID") %>' Text="Delete"
                                ImageUrl="~/images/delete.gif" CommandName="mydelete" OnClientClick="return confirm('are you really want to delete data?');"
                                CssClass="buttonstyle_search" CausesValidation="false" Width="24" /></div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
