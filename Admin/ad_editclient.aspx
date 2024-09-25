<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="ad_editclient.aspx.cs" Inherits="Admin_ad_editclient" %>
<%@ Register Src="../controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<script type="text/javascript" language="javascript">
    function ValidateText(i) {
        if (i.value == 0) {
            i.value = null;
        }
        if (i.value.length > 0) {
            i.value = i.value.replace(/[^\d]+/g, '');
        }
        CountFrmTitle(i, 15);
    }
    function CountFrmTitle(field, max) {
        if (field.value.length > max) {
            field.value = field.value.substring(0, max);
            alert("You are exceding the maximum limit");
        }
        else {

            var count = max - field.value.length;
        }
        validate();
    }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div>
        <div id="totbdy" class="totbodycatreg1" style="height: auto;">
            <div id="haeder" class="headerstyle" style="margin-left: 12px; width: 870px;">
                <asp:Label ID="Label22" runat="server" CssClass="Head1" Text="Edit Client Profile"></asp:Label>
            </div>
            <div id="Div23" style="width: 99%; padding-left: 2px;">
                <uc1:MessageControl ID="MessageControl1" runat="server" />
            </div>
            <div id="Div81" class="seperotorrwr">
            </div>
            <div id="contactdiv" class="insidetot">
                <div class="cont_fieldset" style="width: 862px;">
                    <div id="Div77" class="seperotorrwr">
                    </div>
                    <div id="insidrw1" class="comprw">
                        <div id="insideleft1" class="leftrw_left">
                            <asp:Label ID="Label1" runat="server" CssClass="labelstyle" Text="Client Name "></asp:Label>
                        </div>
                        <div id="insideright1" class="rightrw">
                            <asp:TextBox ID="txtclientname" runat="server" CssClass="txtnrml_long"></asp:TextBox>
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
                    <div id="Div35" class="comprw">
                        <div id="Div36" class="leftrw_left">
                            <asp:Label ID="Label13" runat="server" CssClass="labelstyle" Text="Company Name "></asp:Label>
                        </div>
                        <div id="Div37" class="rightrw">
                            <asp:DropDownList ID="drpcompany" runat="server" AutoPostBack="True" DataTextField="CompanyName"
                                CssClass="dropstyle" DataValueField="CompId" Width="177px" OnSelectedIndexChanged="drpcompany_SelectedIndexChanged">
                            </asp:DropDownList>
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
                    <div id="Div32" class="comprw">
                        <div id="Div33" class="leftrw_left">
                            <asp:Label ID="Label12" runat="server" CssClass="labelstyle" Text="Country"></asp:Label>
                        </div>
                        <div id="Div34" class="rightrw">
                            <asp:TextBox ID="txtcountry" runat="server" CssClass="txtnrml"></asp:TextBox>
                        </div>
                    </div>
                    <div id="Div8" class="comprw">
                        <div id="Div9" class="leftrw_left">
                            <asp:Label ID="Label4" runat="server" CssClass="labelstyle" Text="Pincode / Zipcode"></asp:Label>
                        </div>
                        <div id="Div10" class="rightrw">
                            <asp:TextBox ID="txtZip" runat="server" CssClass="numerictxtbox"></asp:TextBox>
                            <asp:Label ID="Label26" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div id="Div1" class="comprw">
                        <div id="Div75" class="leftrw_left">
                            <asp:Label ID="Label32" runat="server" CssClass="labelstyle" Text="Business Phone"></asp:Label>
                        </div>
                        <div id="Div76" class="rightrw">
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="numerictxtbox"></asp:TextBox>
                            <span lang="en-us">&nbsp;</span><asp:Label ID="Pherrmsg" runat="server" CssClass="errlabelstyle"></asp:Label>
                        </div>
                    </div>
                    <div id="Div20" class="comprw">
                        <div id="Div21" class="leftrw_left">
                            <asp:Label ID="Label8" runat="server" CssClass="labelstyle" Text="Business Fax"></asp:Label>
                        </div>
                        <div id="Div22" class="rightrw">
                            <asp:TextBox ID="txtfax" runat="server" CssClass="numerictxtbox"></asp:TextBox>
                            <span lang="en-us">&nbsp;</span><asp:Label ID="emailerrmsg1" runat="server" CssClass="errlabelstyle"></asp:Label>
                        </div>
                    </div>
                    <div id="Div29" class="comprw">
                        <div id="Div30" class="leftrw_left">
                            <asp:Label ID="Label10" runat="server" CssClass="labelstyle" Text="Website"></asp:Label>
                        </div>
                        <div id="Div31" class="rightrw">
                            <asp:TextBox ID="Texweb" runat="server" CssClass="txtnrml"></asp:TextBox>
                        </div>
                    </div>
                    <div id="Div11" class="comprw">
                        <div id="Div12" class="leftrw_left">
                            <asp:Label ID="Label5" runat="server" CssClass="labelstyle" Text="Contact Person"></asp:Label>
                        </div>
                        <div id="Div13" class="rightrw">
                            <asp:TextBox ID="txtcontperson" runat="server" CssClass="txtnrml"></asp:TextBox>
                        </div>
                    </div>
                    <div id="Div14" class="comprw">
                        <div id="Div15" class="leftrw_left">
                            <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text="Contact Mobile"></asp:Label>
                        </div>
                        <div id="Div16" class="rightrw">
                            <asp:TextBox ID="txtcontmob" runat="server" CssClass="numerictxtbox"></asp:TextBox>
                        </div>
                    </div>
                    <div id="Div17" class="comprw">
                        <div id="Div18" class="leftrw_left">
                            <asp:Label ID="Label7" runat="server" CssClass="labelstyle" Text="Contact Email"></asp:Label>
                        </div>
                        <div id="Div19" class="rightrw">
                            <asp:TextBox ID="txtcontemail" runat="server" CssClass="txtnrml"></asp:TextBox>  <asp:Label ID="Label3" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div class="comprw">
                        <div class="leftrw_left">
                            <asp:Label ID="Label11" runat="server" CssClass="labelstyle" Text="Client Group"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:DropDownList ID="drpclientgroup" runat="server" CssClass="dropstyle" DataTextField="ClientGroupName"
                                DataValueField="CTGId" Width="177px">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div id="Div26" class="comprw" style="padding-top: 10px">
                        <div id="Div27" class="leftrw_left">
                        </div>
                        <div id="Div28" class="rightrw">
                            <asp:Button ID="btnupdate" runat="server" CssClass="buttonstyle_reg" OnClick="btnupdate_Click"
                                Text="Update " />
                            <span lang="en-us">&nbsp;</span><asp:Button ID="btncancel" runat="server" CssClass="buttonstyle_reg"
                                OnClick="btncancel_Click" Text="Cancel" />
                            <span lang="en-us">&nbsp;</span></div>
                    </div>
                    <div id="Div44" class="seperotorrwr">
                    </div>
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
            </div>
        </div>
    </div>
</asp:Content>
