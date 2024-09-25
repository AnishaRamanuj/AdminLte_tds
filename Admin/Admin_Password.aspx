<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="Admin_Password.aspx.cs" Inherits="Admin_Admin_Password" %>


<%@ Register src="../controls/MessageControl.ascx" tagname="MessageControl" tagprefix="uc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div>
        <div id="totbdy" class="totbodycatreg1" style="height:auto;padding-bottom:30px">
            <div class="headerstyle_admin">
     <div class="headerstyle1_admin">
                <asp:Label ID="Label22" runat="server" CssClass="Head5" Text="Change Password"></asp:Label>
               
            </div></div>
             <uc1:MessageControl ID="MessageControl1" runat="server" />
            
            <div id="Div73" class="seperotorrwr">
            </div>
            
            <div id="Div81" class="seperotorrwr">
            </div>
            <div id="logindetailsdiv" class="insidetot">
                 <div style="padding-top:10px;margin-left:10px;">                 
                    <div id="Div5" class="comprw">
                        <div id="Div6" class="leftrw_left">
                            <asp:Label ID="Label1" runat="server" CssClass="labelstyle" Text="Old Password"></asp:Label>
                        </div>
                        <div id="Div7" class="rightrw" style="padding-left:5px;">
                            <asp:TextBox ID="txtoldpwd" runat="server" AutoCompleteType="Disabled" 
                                CssClass="txtnrml"></asp:TextBox>
                            <asp:Label ID="Label2" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div id="Div49" class="comprw">
                        <div id="Div50" class="leftrw_left">
                            <asp:Label ID="Label17" runat="server" CssClass="labelstyle" 
                                Text="New Password"></asp:Label>
                        </div>
                        <div id="Div51" class="rightrw" style="padding-left:5px;">
                            <asp:TextBox ID="txtnewpwd" runat="server" AutoCompleteType="Disabled" 
                                CssClass="txtnrml" TextMode="Password"></asp:TextBox>
                            <asp:Label ID="Label52" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div id="Div52" class="comprw">
                        <div id="Div53" class="leftrw_left">
                            <asp:Label ID="Label18" runat="server" CssClass="labelstyle" 
                                Text="Confirm Password"></asp:Label>
                        </div>
                        <div id="Div54" class="rightrw" style="padding-left:5px;">
                            <asp:TextBox ID="txtconfirm" runat="server" CssClass="txtnrml" 
                                TextMode="Password"></asp:TextBox>
                            <asp:Label ID="Label53" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div id="Div1" class="comprw" style="padding-top:5px;">
                        <div id="Div2" class="leftrw_left">
                        </div>
                        <div id="Div3" class="rightrw" style="padding-left:5px;">
                            <asp:Button ID="btnchange" runat="server" CssClass="buttonstyle_pwd" onclick="btnchange_Click" 
                                Text="Update Password" />
                        </div>
                        <div id="Div4" class="seperotorrwr">
                        </div>
                    </div>
                </div>
                 <div style="width:670px; float: left; padding-top: 5px;padding-bottom:10px; height: 10px; padding-left: 25px; margin-top: 5px; font-weight: bold;">
                        Notes:
                    </div>
                   <div class="reapeatItem_admin">  
       <div id="msghead" class="totbodycatreg" style="padding-left: 5px;padding-bottom:5px;">
        <span class="labelstyle" style="color:Red; font-size:smaller;">Fields marked with * are required</span>
           
        </div></div></div>
        </div>
    </div>
</asp:Content>

