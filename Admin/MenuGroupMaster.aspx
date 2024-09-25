<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="MenuGroupMaster.aspx.cs" Inherits="Admin_MenuGroupMaster" ViewStateMode="Enabled" %>
    <%@ Register Src="../controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="divtotbody" class="totbodycatreg1" style="height: auto; padding-bottom: 30px">
        <div align="right">
        </div>
        <div id="divtitl" class="totbodycatreg">
            <div class="headerstyle_admin">
                <div class="headerstyle1_admin">
                    <asp:Label ID="Label1" runat="server" Text="Grouping Menu Masters" CssClass="Head1"></asp:Label>
                </div>
            </div>
        </div>
        <br />
        <center>
       <div style="width:100%"><uc1:MessageControl ID="MessageControl2" runat="server"/> </div> </center>
        <asp:HiddenField ID="Hid_id" runat="server" Value="0" />
        <br />
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
            ShowSummary="False" ValidationGroup="group1" />
        <div id="div1" runat="server" style="padding-left: 20px; width: 100%;">
        <center>
            <table>
                <tr>
                    <td>
                        Name
                    </td>
                    <td>
                        :
                    </td>
                    <td>
                        <asp:TextBox ID="txtname" runat="server" Style='text-transform: capitalize'></asp:TextBox><span
                            style="color: Red">*</span><asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                                runat="server" ErrorMessage="Pease enter menu" ControlToValidate="txtname" Display="None"
                                ValidationGroup="group1"></asp:RequiredFieldValidator>
                        &nbsp;
                    </td></tr>
                    <tr><td>
                    PageName
                    </td><td>:</td>
                    <td>
                        <asp:TextBox ID="txtpagename" runat="server"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtpagename"
                            Display="None" ErrorMessage="Please select Page Name " ValidationGroup="group1"></asp:RequiredFieldValidator>
                        </td></tr>
                        <tr><td>Page Status</td>
                        <td>:</td>
                        <td>
                             <asp:DropDownList ID="ddlpagestatus" runat="server" CssClass="dropstyle">
                            <asp:ListItem Selected="True" Value="0">Please select status</asp:ListItem>
                            <asp:ListItem Value="Admin">Admin</asp:ListItem>
                            <asp:ListItem Value="Staff">Staff</asp:ListItem>
                            <asp:ListItem Value="both">both</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="ddlpagestatus"
                            ErrorMessage="Please select page status" Display="None" InitialValue="0" 
                            ValidationGroup="group1"></asp:RequiredFieldValidator>
                        </td>
                        </tr>
                        <tr><td>Sub Menu</td>
                        <td>:</td>
                        <td>
                            <asp:DropDownList ID="ddlsubmenu" runat="server" 
                               >
                            <asp:ListItem Selected="True" Value="0">No</asp:ListItem>
                            <asp:ListItem Value="1">Yes</asp:ListItem>
                            </asp:DropDownList>                           
                        </td>
                        </tr>
                        <tr><td>Subpage Name</td>
                        <td>:</td>
                        <td><asp:TextBox ID="txtsubpage" runat="server"></asp:TextBox></td>
                        </tr>
                
                <tr>
                    <td>
                    </td>
                    <td>
                    </td>
                    <td>
                        <asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click" CssClass="buttonstyle_search"
                            ValidationGroup="group1" />
                        <asp:Button ID="btncancel" runat="server" Text="Cancel" OnClick="btncancel_Click"
                            CssClass="buttonstyle_search" />
                    </td>
                </tr>
            </table></center>
            <span style="color: Red">* field are mandatory</span>
        </div>
        <div id="div2" runat="server" style="padding-left: 20px;">
            <table>
                <tr>
                    <td>
                        <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
                        <asp:Button ID="btnsearch" runat="server" Text="search" OnClick="btnsearch_Click"
                            CssClass="buttonstyle_search" />
                        <asp:Button ID="btnAdd" runat="server" Width="110" Text="Add new Menu" CssClass="buttonstyle_search"
                            OnClick="btnAdd_Click" />
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <div style="padding-bottom: 10px; width: 96.5%; float: left; padding-left: 10px;">
            <asp:GridView ID="gv_mainmenu" runat="server" AutoGenerateColumns="false" EmptyDataText="No records found!!!"
                ShowHeaderWhenEmpty="true" OnRowCommand="gv_rowcommand1" Width="100%" BorderColor="#55A0FF"
                CssClass="gridcolstyle">
                <Columns>
                    <asp:TemplateField HeaderText="Name" HeaderStyle-CssClass="grdheadermster">
                        <ItemStyle Width="80%" />
                        <ItemTemplate>
                            <div class="gridpages">
                                <asp:Label ID="name" runat="server" CssClass="grdLinks" Text='<%#Eval("Name") %>'
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
                                <asp:Label ID="pagestatus" runat="server" CssClass="grdLinks" Text='<%#Eval("PageStatus") %>'
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
    </div>
</asp:Content>
