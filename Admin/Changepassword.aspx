<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="Changepassword.aspx.cs" Inherits="Admin_Changepassword" %>

<%@ Register src="../controls/MessageControl.ascx" tagname="MessageControl" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div>
    <div id="totbdy" class="totbodycatreg1" style="height:auto">
    <div class="headerstyle_admin">
     <div class="headerstyle1_admin">
        <asp:Label ID="Label22" runat="server" CssClass="Head1" 
            Text="Change Password"></asp:Label>
        </div></div>
                <uc1:messagecontrol ID="MessageControl1" runat="server" />       
    
     <div id="Div73" class="seperotorrwr">
         
        </div>    
    
<%--    <div style="padding-bottom: 3px; width: 100%; float: left; text-align:right;">
                <a href="javascript: history.go(-1)" 
                    style="font-family:Arial, Helvetica, sans-serif;color:#279BC0; font-size:11px; font-weight:bold; text-decoration:none;">
                Back</a>
            </div>--%>
     <div id="Div81" class="seperotorrwr"></div>    
   
    <div id="logindetailsdiv" class="insidetot">
    <div style="padding-top:10px;margin-left:10px;"> 
   <div id="Div45" class="seperotorrwr"></div>
    <div id="Div5" class="comprw">
    <div id="Div6" class="leftrw_left">
        <asp:Label ID="Label1" runat="server" CssClass="labelstyle" 
            Text="Old Password"></asp:Label>
        </div>
    <div id="Div7" class="rightrw">
        <asp:TextBox ID="txtoldpwd" runat="server" CssClass="txtnrml" 
            AutoCompleteType="Disabled" ></asp:TextBox>
        <asp:Label ID="Label2" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
        </div>
    </div>
    <div id="Div49" class="comprw">
    <div id="Div50" class="leftrw_left">
        <asp:Label ID="Label17" runat="server" CssClass="labelstyle" 
            Text="New Password"></asp:Label>
        </div>
    <div id="Div51" class="rightrw">
        <asp:TextBox ID="txtnewpwd" runat="server" CssClass="txtnrml" 
            AutoCompleteType="Disabled" TextMode="Password"></asp:TextBox>
        <asp:Label ID="Label52" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
        </div>
    </div>
    <div id="Div52" class="comprw">
    <div id="Div53" class="leftrw_left">
        <asp:Label ID="Label18" runat="server" CssClass="labelstyle" 
            Text="Confirm Password"></asp:Label>
        </div>
    <div id="Div54" class="rightrw">
        <asp:TextBox ID="txtconfirm" runat="server" CssClass="txtnrml" 
            TextMode="Password"></asp:TextBox>
        <asp:Label ID="Label53" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
        </div>
    </div>
    <div id="Div1" class="comprw">
    <div id="Div2" class="leftrw_left">
        </div>
    <div id="Div3" class="rightrw">
        <asp:Button ID="btnchange" runat="server" Text="Update Password" CssClass="buttonstyle_pwd"
            onclick="btnchange_Click" />
        </div>
    <div id="Div4" class="seperotorrwr"></div>
    </div>      
     </div>
<div style="width:670px; float: left; padding-top: 5px;padding-bottom:10px; height: 10px; padding-left: 25px; margin-top: 5px; font-weight: bold;">
                        Notes:
                    </div>
                   <div class="reapeatItem_admin">  
       <div id="msghead" class="totbodycatreg" style="padding-left: 5px;padding-bottom:5px;">
        <span class="labelstyle" style="color:Red; font-size:smaller;">Fields marked with * are required</span>
           
        </div></div>
     </div>
    
    </div>
    </div>
</asp:Content>

