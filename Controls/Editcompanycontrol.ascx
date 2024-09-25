<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Editcompanycontrol.ascx.cs" Inherits="controls_Editcompanycontrol" %>

<%@ Register src="MessageControl.ascx" tagname="MessageControl" tagprefix="uc1" %>

<link href="../StyleCss/Style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="javascript">
    function ValidateText(i) {
        if (i.value == 0) {
            i.value = null;
        }
        if (i.value.length > 0) {
            i.value = i.value.replace(/[^\d]+/g, '');
        }
    }
    function CountFrmTitle(field, max) {
        if (field.value.length > max)
            field.value = field.value.substring(0, max);
             alert("You are exceeding the maximum limit");
        else {
            var count = max - field.value.length;
        }

    }
   
</script>

    
    <div id="totbdy" class="totbodycatreg1" style="overflow:hidden;height:auto;padding-bottom:30px";>
   
    <div id="haeder" class="headerstyle">
        <asp:Label ID="Label22" runat="server" CssClass="Head1" 
            Text="Edit Company Profile"></asp:Label>
        </div>
                <uc1:MessageControl ID="MessageControl1" runat="server" />

          
     <div id="contactdiv" class="insidetot3">
    <div class="cont_fieldset" style="margin-left:10px;">
    <div id="Div77" class="seperotorrwr"></div>
    <div id="insidrw1" class="comprw">       
    
    <div id="insideleft1" class="leftrw_left">
        <asp:Label ID="Label1" runat="server" CssClass="labelstyle" 
            Text="Company Name "></asp:Label>
        </div>
    <div id="insideright1" class="rightrw">
        <asp:TextBox ID="txtcompname" runat="server" CssClass="txtnrml_long"></asp:TextBox>
        <asp:Label ID="Label23" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
        </div>
    </div>
    <div id="Div2" class="comprw">
    <div id="Div3" class="leftrw_left">
        <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text="Address"></asp:Label>
        </div>
    <div id="Div4" class="rightrw">
        <asp:TextBox ID="txtaddr1" runat="server" CssClass="txtnrml_long"></asp:TextBox>
        </div>
    </div>
    <div id="Div5" class="comprw">
    <div id="Div6" class="leftrw_left">
        </div>
    <div id="Div7" class="rightrw">
        <asp:TextBox ID="txtaddr2" runat="server" CssClass="txtnrml_long"></asp:TextBox>
        </div>
    </div>
     <div id="Div78" class="comprw">
    <div id="Div96" class="leftrw_left">
        </div>
    <div id="Div97" class="rightrw">
        <asp:TextBox ID="txtaddr3" runat="server" CssClass="txtnrml_long"></asp:TextBox>
        </div>
    </div>
     <div id="Div98" class="comprw">
    <div id="Div99" class="leftrw_left">
        <asp:Label ID="Label42" runat="server" CssClass="labelstyle" Text="City"></asp:Label>
        </div>
    <div id="Div100" class="rightrw">
        <asp:TextBox ID="txtcity" runat="server" CssClass="txtnrml"></asp:TextBox>
        </div>
    </div>
    <div id="Div8" class="comprw">
    <div id="Div9" class="leftrw_left">
        <asp:Label ID="Label4" runat="server" CssClass="labelstyle" 
            Text="Pincode / Zipcode"></asp:Label>
        </div>
    <div id="Div10" class="rightrw" style="overflow:hidden;text-align:bottom">
        <asp:TextBox ID="txtZip" runat="server" CssClass="numerictxtbox"></asp:TextBox>       
        </div>
    </div>
    <div id="Div1" class="comprw">
    <div id="Div75" class="leftrw_left">
        <asp:Label ID="Label32" runat="server" CssClass="labelstyle" Text="Phone"></asp:Label>
        </div>
    <div id="Div76" class="rightrw">
        <asp:TextBox ID="txtPhone" runat="server" CssClass="numerictxtbox"></asp:TextBox>
        <span lang="en-us">&nbsp;</span><asp:Label ID="Pherrmsg" runat="server" 
            CssClass="errlabelstyle"></asp:Label>
        </div>
    </div>
      <div id="Div20" class="comprw">
    <div id="Div21" class="leftrw_left">
        <asp:Label ID="Label8" runat="server" CssClass="labelstyle" Text="Email"></asp:Label>
        </div>
    <div id="Div22" class="rightrw">
        <asp:TextBox ID="Txtemail" runat="server" CssClass="txtnrml"></asp:TextBox>
        <span lang="en-us">&nbsp;</span><asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
        </div>
        
    </div>
    <div id="Div29" class="comprw">
    <div id="Div30" class="leftrw_left">
        <asp:Label ID="Label10" runat="server" CssClass="labelstyle" Text="Website"></asp:Label>
        </div>
    <div id="Div31" class="rightrw">
        <asp:TextBox ID="Texweb" runat="server" CssClass="txtnrml"></asp:TextBox>  <span lang="en-us">&nbsp;</span><asp:Label ID="Label3" runat="server" 
            CssClass="errlabelstyle">Please use http:// before your address</asp:Label>
        </div>
        
    </div>
    <div id="Div26" class="comprw" style="padding-top:10px;">
    <div id="Div27" class="leftrw_left">
        </div>
    <div id="Div28" class="rightrw">
        <asp:Button ID="btnupdate" runat="server" CssClass="buttonstyle_reg" onclick="btnupdate_Click" 
            Text="Update " />
        <span lang="en-us">&nbsp;</span><asp:Button ID="btncancel" runat="server" CssClass="buttonstyle_reg"
            Text="Cancel" onclick="btncancel_Click" />
        <span lang="en-us">&nbsp;</span><asp:LinkButton ID="lbtchange" runat="server" 
            PostBackUrl="~/Company/Changepassword.aspx" Visible="False">Change Password</asp:LinkButton>
        </div>
        
    </div>    
    <div id="Div44" class="seperotorrwr"></div>
    </div>
    <div style="overflow:hidden;width: 96%; float: left; padding-top: 5px;padding-bottom:10px; height: 10px; padding-left: 2%; margin-top: 5px; font-weight: bold;">
                        Notes:
                    </div>
                    <div class="reapeatItem3"> 
            <div id="msghead" class="totbodycatreg" style="overflow:hidden;padding-left: 2%">
        <span class="labelstyle" style="overflow:hidden;color:Red; font-size:smaller;">Fields marked with * are required</span>
           
        </div></div>
    </div>
    </div>
