<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AdminCompanyReg.ascx.cs" Inherits="controls_AdminCompanyReg" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>

<script type="text/javascript" language="javascript">
    function disableFinishButton() {
        var arrInputs = document.getElementsByTagName('INPUT')

        for (var i = 0; i < arrInputs.length; i++) {
            if (arrInputs[i].getAttribute('id') != null) {
                if (arrInputs[i].getAttribute('id').indexOf('btnregister') > -1) {
                    arrInputs[i].disabled = true
                    break
                }
            }
        }
    }
    function ValidateText(i) {
        if (i.value == 0) {
            i.value = null;
        }
        if (i.value.length > 0) {
            i.value = i.value.replace(/[^\d]+/g, '');
        }
    }
    function CountFrmTitle(field, max) {
        if (field.value.length > max) {
            field.value = field.value.substring(0, max);
            alert("You are exceding the maximum limit");

        }
        else {
            var count = max - field.value.length;
        }

    }
   
</script>

<div id="totbdy" class="totbodycatreg">
    <uc2:MessageControl ID="MessageControl1" runat="server" />
    <div class="headerstyle_admin">
        <div class="headerstyle1_admin">
            <asp:Label ID="Label22" runat="server" CssClass="Head1" Text="Create Company"></asp:Label>
        </div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div id="Div1" class="insidetot" style="margin-top: 10px;">
                <fieldset class="cont_fieldset_admin">
                    <legend style="font-weight: bold; padding-left: 2px; padding-right: 2px">Company Information</legend>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label1" runat="server" CssClass="labelstyle" Text="Company Name"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="txtcompanyname" runat="server" CssClass="txtnrml" Width="75%"></asp:TextBox>
                            <asp:Label ID="Label23" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text="Address"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="txtaddress1" runat="server" CssClass="txtnrml" Width="75%"></asp:TextBox>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="txtaddress2" runat="server" CssClass="txtnrml" Width="75%"></asp:TextBox>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="txtaddress3" runat="server" CssClass="txtnrml" Width="75%"></asp:TextBox>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label44" runat="server" CssClass="labelstyle" Text="City"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="txtcity" runat="server" CssClass="txtnrml"></asp:TextBox>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label42" runat="server" CssClass="labelstyle" Text="Pin / Zip Code"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="txtpin" runat="server" CssClass="txtnrml"></asp:TextBox>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text="Contact No"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="txtmob" runat="server" CssClass="numerictxtbox"></asp:TextBox> <asp:Label ID="Label14" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                            <span lang="en-us">&nbsp;<asp:Label ID="Moberrmsg1" runat="server" CssClass="errlabelstyle"></asp:Label>
                            </span>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label9" runat="server" CssClass="labelstyle" Text="Website"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="txtwebsite" runat="server" CssClass="txtnrml">http://</asp:TextBox>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label13" runat="server" CssClass="labelstyle" Text="Currency"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:DropDownList ID="drpcash" CssClass="dropstyle" runat="server" Height="16px"
                                Width="115px">
                                <asp:ListItem>Rupees</asp:ListItem>
                                <asp:ListItem>Dollar</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label8" runat="server" CssClass="labelstyle" Text="Email"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="txtemail" runat="server" CssClass="txtnrml"></asp:TextBox>
                            <asp:Label ID="Label3" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                </fieldset>
            </div>
            <div id="logindetailsdiv" class="insidetot">
                <fieldset class="cont_fieldset_admin">
                    <legend style="font-weight: bold; padding-left: 2px; padding-right: 2px;">Login Information</legend>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label4" runat="server" CssClass="labelstyle" Text="First Name"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="txtfirstname" runat="server" CssClass="txtnrml"></asp:TextBox>
                            <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                            <span lang="en-us">&nbsp;</span><asp:Label ID="Label7" runat="server" CssClass="errlabelstyle"></asp:Label>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label10" runat="server" CssClass="labelstyle" Text="Last Name"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="txtlastname" runat="server" CssClass="txtnrml"></asp:TextBox>
                            <asp:Label ID="Label11" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                            <span lang="en-us">&nbsp;</span><asp:Label ID="Label12" runat="server" CssClass="errlabelstyle"></asp:Label>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label16" runat="server" CssClass="labelstyle" Text="UserName"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="txtnrml"></asp:TextBox>
                            <asp:Label ID="Label51" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label17" runat="server" CssClass="labelstyle" Text="Password"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="TxtPassword" runat="server" CssClass="txtnrml" AutoCompleteType="Disabled"
                                TextMode="Password"></asp:TextBox>
                            <asp:Label ID="Label52" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label18" runat="server" CssClass="labelstyle" Text="Confirm Password"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:TextBox ID="txtConfirm" runat="server" CssClass="txtnrml" TextMode="Password"></asp:TextBox>
                            <asp:Label ID="Label53" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                            <span lang="en-us">&nbsp;</span><asp:Label ID="lblerrpasword" runat="server" CssClass="errlabelstyle"></asp:Label>
                        </div>
                    </div>
                </fieldset>
            </div>
            <div class="comprw" style="margin-left: 17px; padding-top: 5px">
                <div class="leftrw_left">
                </div>
                <div class="rightrw">
                    <asp:Button ID="btnregister" runat="server" CssClass="buttonstyle_reg" Text="Register"
                        OnClientClick="window.setTimeout('disableFinishButton()',0); return true" OnClick="btnregister_Click" />
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <div class="comprw" style="margin-left: 17px; padding-top: 5px">
        <div class="leftrw_left">
        </div>
        <div class="rightrw">
            <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                <ProgressTemplate>
                    <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
            </asp:UpdateProgress>
        </div>
    </div>
    <div style="width: 670px; float: left; padding-top: 5px; padding-bottom: 10px; height: 10px;
        padding-left: 25px; margin-top: 5px; font-weight: bold;">
        Notes:
    </div>
    <div class="reapeatItem_admin">
        <div id="msghead" class="totbodycatreg" style="padding-left: 5px; padding-bottom: 5px;">
            <span class="labelstyle" style="color: Red; font-size: smaller;">Fields marked with
                * are required</span>
        </div>
        <div style="overflow: hidden; height: 25px; padding-top: 10px; padding-left: 5px;">
            <span class="labelstyle" style="overflow: hidden; font-size: 11px; font-weight: bold;">
                Company Master page to add / edit company</span>
        </div>
    </div>
</div>
