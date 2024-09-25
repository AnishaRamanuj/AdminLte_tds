<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="Changecompanypassword.aspx.cs" Inherits="Admin_Changecompanypassword" %>

<%@ Register src="../controls/MessageControl.ascx" tagname="MessageControl" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div>
    <div id="totbdy" class="totbodycatreg">
                          <div class="headerstyle">
               <asp:Label ID="Label3" runat="server" Text="Change Passowrd" CssClass="Head1"></asp:Label> </div>
                       <uc1:MessageControl ID="MessageControl1" runat="server" />

    <div id="msghead" class="totbodycatreg">
            <asp:Label ID="Label29" runat="server" CssClass="labelstyle" 
                Text="Fields marked with "></asp:Label>
        <asp:Label ID="Label30" runat="server" CssClass="errlabelstyle" Text="*"></asp:Label>
         <asp:Label ID="Label31" runat="server" 
                CssClass="labelstyle" Text=" are required"></asp:Label>
        </div>
     <div id="Div73" class="seperotorrwr">
        </div>    
    <div id="errordiv" runat="server" class="insidetoterr">
       <div id="headerrdiv" runat="server" class="comprwerr11">
    <div id="Div79" class="leftrwerr11">
        </div>
    <div id="Div80" class="rightrwerr11">
        <asp:Label ID="Label34" runat="server" Font-Bold="True" 
            ForeColor="Crimson" Text="Whoops, we have a problem..." Width="100%"></asp:Label>
        </div>
    </div>
    <div id="successdiv" runat="server" class="divsuccess11" >
    <div id="Div141" class="leftrwerr12">
        </div>
    <div id="Div142" class="rightrwerr12">
        <asp:Label ID="Label36" runat="server" Font-Bold="True" 
            ForeColor="Crimson" Text="Successfully updated your password..." Width="100%"></asp:Label>
        </div>
    </div> 
     
    <div id="oldpwderr" class="comprwerr11" runat="server">
    <div id="Div129" class="leftrwerr11">
        <asp:Image ID="Image9" runat="server" ImageUrl="~/images/bullet.jpg" />
        </div>
    <div id="Div130" class="rightrwerr11">
        <asp:Label ID="lblloginerr" runat="server" 
           Text="Old password entered is wrong." Width="100%" CssClass="labelstyle"></asp:Label>
        </div>
        </div>
        
        <div id="passwrderr" class="comprwerr11" runat="server" >
        <div id="Div135" class="leftrwerr11">
        <asp:Image ID="Image14" runat="server" ImageUrl="~/images/bullet.jpg" />
        </div>
        <div id="Div115" class="rightrwerr11">
        <asp:Label ID="lblpasswrderr" runat="server" 
           Text="" Width="100%" CssClass="labelstyle"></asp:Label>
        </div>
    </div>
    
    <div id="Usererrdiv" runat="server" class="comprwerr11">
    <div id="Div120" class="leftrwerr11">
        <asp:Image ID="Image11" runat="server" ImageUrl="~/images/bullet.jpg" />
        </div>
    <div id="Div126" class="rightrwerr11">
        <asp:Label ID="lblusererr" runat="server" 
           Text="" Width="100%" CssClass="labelstyle"></asp:Label>
        </div>
    </div>
    
   
    
    
    </div>
     <div id="Div81" class="seperotorrwr"></div>
   
    <div id="logindetailsdiv" class="insidetot">
      <div>
     <%-- <legend>Login--%> Details</legend>
   <div id="Div45" class="seperotorrwr"></div>
    <div id="Div5" class="comprw">
    <div id="Div6" class="leftrw">
        <asp:Label ID="Label1" runat="server" CssClass="labelstyle" 
            Text="Old Password"></asp:Label>
        </div>
    <div id="Div7" class="rightrw">
        <asp:TextBox ID="txtoldpwd" runat="server" CssClass="txtnrml" 
            AutoCompleteType="Disabled" ></asp:TextBox>
        <asp:Label ID="Label2" runat="server" CssClass="errlabelstyle" Text="*"></asp:Label>
        </div>
    </div>
    <div id="Div49" class="comprw">
    <div id="Div50" class="leftrw">
        <asp:Label ID="Label17" runat="server" CssClass="labelstyle" 
            Text="New Password"></asp:Label>
        </div>
    <div id="Div51" class="rightrw">
        <asp:TextBox ID="txtnewpwd" runat="server" CssClass="txtnrml" 
            AutoCompleteType="Disabled" TextMode="Password"></asp:TextBox>
        <asp:Label ID="Label52" runat="server" CssClass="errlabelstyle" Text="*"></asp:Label>
        </div>
    </div>
    <div id="Div52" class="comprw">
    <div id="Div53" class="leftrw">
        <asp:Label ID="Label18" runat="server" CssClass="labelstyle" 
            Text="Confirm Password"></asp:Label>
        </div>
    <div id="Div54" class="rightrw">
        <asp:TextBox ID="txtconfirm" runat="server" CssClass="txtnrml" 
            TextMode="Password"></asp:TextBox>
        <asp:Label ID="Label53" runat="server" CssClass="errlabelstyle" Text="*"></asp:Label>
        </div>
    </div>
    <div id="Div1" class="comprw">
    <div id="Div2" class="leftrw">
        </div>
    <div id="Div3" class="rightrw">
        <asp:Button ID="btnchange" runat="server" Text="Update Password" 
            onclick="btnchange_Click" />
        </div>
    <div id="Div4" class="seperotorrwr"></div>
    </div>      
     </div>
     </div>
    
    </div>
    </div>
</asp:Content>

