<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="DBconfig.aspx.cs" Inherits="Admin_DBconfig" Title="Untitled Page" %>
<%@ Register Src="../controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div id="haeder" class="headerstyle" style="margin-left: 12px; width: 870px;">
                <asp:Label ID="Label22" runat="server" CssClass="Head1" Text="Database Configuration"></asp:Label>
            </div>
            <div id="Div23" style="width: 99%; padding-left: 2px;">
                <uc1:MessageControl ID="MessageControl1" runat="server" />
            </div>
 <div id="insidrw1" class="comprw">
                        <div id="insideleft1" class="leftrw_left">
                            <asp:Label ID="iplbl" runat="server" CssClass="labelstyle" Text="IP Address"></asp:Label>
                        </div>
                        <div id="insideright1" class="rightrw">
                            <asp:TextBox ID="txtip" runat="server" CssClass="txtnrml_long"></asp:TextBox>
                            <asp:Label ID="Label1" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                     <div id="Div1" class="comprw">
                        <div id="Div2" class="leftrw_left">
                            <asp:Label ID="dblbl" runat="server" CssClass="labelstyle" Text="Database Name "></asp:Label>
                        </div>
                        <div id="Div3" class="rightrw">
                            <asp:TextBox ID="dbtxt" runat="server" CssClass="txtnrml_long"></asp:TextBox>
                            <asp:Label ID="Label2" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                     <div id="Div4" class="comprw">
                        <div id="Div5" class="leftrw_left">
                            <asp:Label ID="usernamelbl" runat="server" CssClass="labelstyle" Text="UserName "></asp:Label>
                        </div>
                        <div id="Div6" class="rightrw">
                            <asp:TextBox ID="usertxt" runat="server" CssClass="txtnrml_long"></asp:TextBox>
                            <asp:Label ID="Label3" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                     <div id="Div7" class="comprw">
                        <div id="Div8" class="leftrw_left">
                            <asp:Label ID="passwordlbl" runat="server" CssClass="labelstyle" Text="Password "></asp:Label>
                        </div>
                        <div id="Div9" class="rightrw">
                            <asp:TextBox ID="pwdtxt" runat="server" CssClass="txtnrml_long"></asp:TextBox>
                            <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                     <div id="Div26" class="comprw" style="padding-top: 10px">
                        <div id="Div27" class="leftrw_left">
                        </div>
                        <div id="Div28" class="rightrw">
                            <asp:Button ID="btnsubmit" runat="server" CssClass="buttonstyle_reg" OnClick="btnsubmit_Click"
                                Text="Submit " />
                            <span lang="en-us">&nbsp;</span><asp:Button ID="btncancel" runat="server" CssClass="buttonstyle_reg"
                                OnClick="btncancel_Click" Text="Cancel" />
                            <span lang="en-us">&nbsp;</span></div>
                    </div>
                    <div style="width: 862px; float: left; padding-top: 5px; padding-bottom: 10px; height: 10px;
                    padding-left: 10px; margin-top: 5px; font-weight: bold; margin-left: 15px">
                    Notes:
                </div>
                <div class="reapeatItem3" style="width: 862px; margin-left: 12px">
                    <div id="msghead" class="totbodycatreg">
                        <span class="labelstyle" style="color: Red; font-size: smaller;">Fields marked with
                            * are required</span>
                    </div>
                </div>
</asp:Content>

