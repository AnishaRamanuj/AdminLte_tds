<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="ad_editstaff.aspx.cs" Inherits="Admin_ad_editstaff" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="../controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
 <script language="javascript" type="text/javascript">
    function pad2(number) {
    return (number < 10 ? '0' : '') + number
   }
        function checkForm() {
        
            // regular expression to match required date format
            var dt = new Date();
            var day = dt.getDate();
            var mon =dt.getMonth() + 1;
            var yr = dt.getFullYear();
            var pin = document.getElementById("<%= txtjoindate.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%=txtjoindate.ClientID%>").focus();
                var month=pad2(mon);
                var m= document.getElementById("<%=HiddenField1.ClientID%>").value;
                 document.getElementById("<%=txtjoindate.ClientID%>").value =m ;
                 if(document.getElementById("<%=HiddenField1.ClientID%>").value=="")
                 {
                document.getElementById("<%=txtjoindate.ClientID%>").value =day+"/"+month+"/"+yr ;
                }
                return false;
            }
        }
         function checkForms() {
        
            // regular expression to match required date format
            var dt = new Date();
            var day = dt.getDate();
            var mon =dt.getMonth() + 1;
            var yr = dt.getFullYear();
            var pin = document.getElementById("<%= txtenddate.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%= txtenddate.ClientID%>").focus();
                var month=pad2(mon);
                 var m= document.getElementById("<%=HiddenField2.ClientID%>").value;
                 document.getElementById("<%=txtenddate.ClientID%>").value =m ;
                 if(document.getElementById("<%=HiddenField2.ClientID%>").value=="")
                 {
                document.getElementById("<%=txtenddate.ClientID%>").value =day+"/"+month+"/"+yr ;
                }
              
                return false;
            }
        }
       </script>
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
                <asp:Label ID="Label22" runat="server" CssClass="Head1" Text="Edit Staff Profile"></asp:Label>
            </div>
            <div id="Div81" class="seperotorrwr">
            </div>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div style="width: 99%; padding-left: 2px">
                        <uc1:MessageControl ID="MessageControl1" runat="server" />
                    </div>
                    <div id="contactdiv" class="insidetot" style="padding-bottom: 30px; padding-top: 10px">
                        <div class="cont_fieldset" style="width: 862px;">
                            <div id="Div77" class="seperotorrwr">
                            </div>
                            <div id="Div35" class="comprw">
                                <div id="Div36" class="leftrw_left">
                                    <asp:Label ID="Label16" runat="server" CssClass="labelstyle" Text="Company Name "></asp:Label>
                                </div>
                                <div id="Div37" class="rightrw">
                                    <asp:DropDownList ID="drpcompany" runat="server" AutoPostBack="True" DataTextField="CompanyName"
                                        CssClass="dropstyle" DataValueField="CompId" Width="200px" OnSelectedIndexChanged="drpcompany_SelectedIndexChanged"
                                        AppendDataBoundItems="True">
                                        <asp:ListItem Value="0">--Select--</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                                </div>
                            </div>
                            <div id="insidrw1" class="comprw">
                                <div id="insideleft1" class="leftrw_left">
                                    <asp:Label ID="Label1" runat="server" CssClass="labelstyle" Text="Staff Name "></asp:Label>
                                </div>
                                <div id="insideright1" class="rightrw">
                                    <asp:TextBox ID="txtstaffname" runat="server" CssClass="txtnrml_long"></asp:TextBox>
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
                                    <asp:Label ID="Label42" runat="server" CssClass="labelstyle" Text="City"></asp:Label></div>
                                <div id="Div100" class="rightrw">
                                    <asp:TextBox ID="txtcity" runat="server" CssClass="txtnrml"></asp:TextBox></div>
                            </div>
                            <div id="Div8" class="comprw">
                                <div id="Div9" class="leftrw_left">
                                    <asp:Label ID="Label4" runat="server" CssClass="labelstyle" Text="Username / Email"></asp:Label></div>
                                <div id="Div10" class="rightrw" style="text-align: bottom">
                                    <asp:TextBox ID="txtemail" runat="server" CssClass="txtnrml"></asp:TextBox></div>
                            </div>
                            <div id="Div1" class="comprw">
                                <div id="Div75" class="leftrw_left">
                                    <asp:Label ID="Label32" runat="server" CssClass="labelstyle" Text="Mobile"></asp:Label></div>
                                <div id="Div76" runat="server" class="rightrw" cssclass="txtnrml">
                                    <asp:TextBox ID="txtmob" runat="server" CssClass="numerictxtbox"></asp:TextBox><span
                                        lang="en-us">&nbsp;</span><asp:Label ID="Pherrmsg" runat="server" CssClass="errlabelstyle"></asp:Label></div>
                            </div>
                            <div class="comprw" style="overflow: hidden; width: 680px;">
                                <div class="leftrw_left">
                                    <asp:Label ID="Label19" runat="server" CssClass="labelstyle" Text="Department"></asp:Label>
                                </div>
                                <div class="rightrw" style="overflow: hidden; width: 550px;">
                                    <div style="overflow: hidden; width: 135px; float: left">
                                        <asp:DropDownList ID="drpdep" runat="server" DataTextField="DepartmentName" DataValueField="DepId"
                                            AppendDataBoundItems="true" CssClass="dropstyle" Width="130px">
                                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <div style="overflow: hidden; width: 72px; float: left; padding-left: 6px">
                                        <asp:Label ID="Label17" runat="server" CssClass="labelstyle" Text="Designation"></asp:Label>
                                    </div>
                                    <div style="overflow: hidden; width: 145px; float: left">
                                        <asp:DropDownList ID="drpdesig" runat="server" DataTextField="DesignationName" AppendDataBoundItems="true"
                                            CssClass="dropstyle" DataValueField="DsgId" Width="130px" AutoPostBack="True"
                                            OnSelectedIndexChanged="drpdesig_SelectedIndexChanged">
                                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:Label ID="Label11" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                                    </div>
                                    <div style="overflow: hidden; width: 50px; float: left; text-align: center;">
                                        <asp:Label ID="Label18" runat="server" CssClass="labelstyle" Text="Branch"></asp:Label>
                                    </div>
                                    <div style="overflow: hidden; width: 132px; float: left">
                                        <asp:DropDownList ID="drpbranch" runat="server" CssClass="dropstyle" DataTextField="BranchName"
                                            AppendDataBoundItems="true" DataValueField="BrId" Width="130px">
                                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="comprw" style="padding-bottom: 5px;">
                                <div class="leftrw_left" style="padding-top: 5px;">
                                    <asp:Label ID="Label9" runat="server" CssClass="labelstyle" Text="Date Of Joining"></asp:Label></asp:Label>
                                </div>
                                <div class="rightrw122">
                                    <div style="width: 25%; float: left;">
                                        <div style="float: left;">
                                            <asp:TextBox ID="txtjoindate" runat="server" CssClass="txtnrml" Width="80px"></asp:TextBox>
                                        </div>
                                        <div style="padding-top: 10px 0px 0px 0px; float: left;">
                                            <asp:Image ID="Image10" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                                        <cc1:CalendarExtender ID="txtjoindate_CalendarExtender" runat="server" Format="dd/MM/yyyy"
                                            PopupButtonID="Image10" TargetControlID="txtjoindate">
                                        </cc1:CalendarExtender>
                                        <div style="padding-left: 5px; float: left;">
                                            <asp:Label ID="Label3" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label></div>
                                    </div>
                                    <div style="width: 45%; float: left; padding-left: 1%">
                                        <div style="float: left; padding-right: 10px">
                                            <asp:Label ID="Label13" runat="server" CssClass="labelstyle" Text="Date Of Leaving"></asp:Label></div>
                                        <div style="float: left;">
                                            <asp:TextBox ID="txtenddate" runat="server" CssClass="txtnrml" Width="80px"></asp:TextBox></div>
                                        <div style="padding-top: 10px 0px 0px 0px; float: left;">
                                            <asp:Image ID="Image18" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                                        <cc1:CalendarExtender ID="txtenddate_CalendarExtender" runat="server" Format="dd/MM/yyyy"
                                            PopupButtonID="Image18" TargetControlID="txtenddate">
                                        </cc1:CalendarExtender>
                                    </div>
                                </div>
                            </div>
                            <div id="Div29" class="comprw">
                                <div id="Div30" class="leftrw_left">
                                    <asp:Label ID="Label10" runat="server" CssClass="labelstyle" Text="Hourly Charges"></asp:Label></div>
                                <div id="Div31" class="rightrw">
                                    <div style="float: left;">
                                        <asp:TextBox ID="txthourcharge" runat="server" CssClass="numerictxtbox" Width="80px"></asp:TextBox>
                                    </div>
                                    <asp:Label ID="Label43" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label></div>
                            </div>
                            <div id="Div20" class="comprw">
                                <div id="Div21" class="leftrw_left">
                                    <asp:Label ID="Label8" runat="server" CssClass="labelstyle" Text="Salary"></asp:Label></div>
                                <div id="Div22" class="rightrw">
                                    <asp:TextBox ID="txtcursal" runat="server" CssClass="numerictxtbox" Width="80px"></asp:TextBox>
                                    <asp:Label ID="Label26" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                                </div>
                            </div>
                            <div id="Div11" class="comprw">
                                <div id="Div12" class="leftrw_left">
                                    <asp:Label ID="Label5" runat="server" CssClass="labelstyle" Text="User Name"></asp:Label></div>
                                <div id="Div13" class="rightrw">
                                    <asp:TextBox ID="txtusername" runat="server" CssClass="txtnrml"></asp:TextBox></div>
                            </div>
                            <div id="Div14" class="comprw">
                                <div id="Div15" class="leftrw_left">
                                    <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text="Password"></asp:Label></div>
                                <div id="Div16" class="rightrw" style="padding-left: 5px">
                                    <asp:Label ID="lblpass" runat="server" CssClass="labelstyle" Text="password"></asp:Label></div>
                            </div>
                            <div id="Div26" class="comprw" style="padding-top: 10px">
                                <div id="Div27" class="leftrw_left">
                                </div>
                                <div id="Div28" class="rightrw">
                                    <asp:Button ID="btnupdate" runat="server" OnClick="btnupdate_Click" CssClass="buttonstyle_reg"
                                        Text="Update " />
                                    <span lang="en-us">&nbsp;</span><asp:Button ID="btncancel" runat="server" CssClass="buttonstyle_reg"
                                        OnClick="btncancel_Click" Text="Cancel" />
                                    <span lang="en-us">&nbsp;</span></div>
                            </div>
                               <div id="Div17" class="leftrw_left">
                                </div>
                                <div id="Div18" class="rightrw">
                                   
                                    <asp:HiddenField ID="HiddenField1" runat="server" />
                                    <asp:HiddenField ID="HiddenField2" runat="server" />
                                   
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
                        &nbsp;</div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>
