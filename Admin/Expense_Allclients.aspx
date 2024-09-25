<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="Expense_Allclients.aspx.cs" Inherits="Admin_Expense_Allclients" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="../controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
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
            var pin = document.getElementById("<%=txtfr.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%=txtfr.ClientID%>").focus();
                var month=pad2(mon);
                var days=pad2(day);
                document.getElementById("<%=txtfr.ClientID%>").value =days+"/"+month+"/"+yr ;
                return false;
            }
        }
         function checkForms() {
        
            // regular expression to match required date format
            var dt = new Date();
            var day = dt.getDate();
            var mon =dt.getMonth() + 1;
            var yr = dt.getFullYear();
            var pin = document.getElementById("<%= txtend.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%= txtend.ClientID%>").focus();
                var month=pad2(mon);
                var days=pad2(day);
                document.getElementById("<%= txtend.ClientID%>").value = days+"/"+month+"/"+yr ;
                return false;
            }
        }
       </script>
    <div style="width: 903px; float: left; height: auto; padding-bottom: 20px">
        <div class="headerstyle11">
            <div class="headerstyle112">
                <asp:Label ID="Label6" runat="server" Text="All Clients" CssClass="Head1"></asp:Label></div>
        </div>
           <div style="overflow: auto; width: 97%; padding-left: 5px;float:left;padding-right:5px">
                    <uc2:MessageControl ID="MessageControl2" runat="server" />
                </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
             
                <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; width: 100%; float: left;">
                    <div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px;">
                        <asp:Label ID="Label1" runat="server" Text="Company Name"></asp:Label>
                    </div>
                    <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
                        <asp:DropDownList ID="drpopecmp" runat="server" DataTextField="CompanyName" DataValueField="CompId"
                            Width="240px" Height="20px" CssClass="dropstyle" AutoPostBack="True" AppendDataBoundItems="True"
                            OnSelectedIndexChanged="drpopecmp_SelectedIndexChanged">
                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                        </asp:DropDownList>
                        <asp:Label ID="Label56" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
                        <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                            <ProgressTemplate>
                                <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                        </asp:UpdateProgress>
                    </div>
                </div>
                <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; width: 100%; float: left;">
                    <div style="width: 520px; float: left; overflow: hidden">
                        <div style="overflow: auto; width: 110px; float: left; padding-left: 40px;">
                            <asp:Label ID="Label3" runat="server" Text="Client Name"></asp:Label>
                        </div>
                        <div style="overflow: auto; ">
                            <asp:CheckBox ID="chkclope" runat="server" AutoPostBack="True" Text=" Check All"
                                OnCheckedChanged="chkclope_CheckedChanged" />
                        </div>
                        <div style="overflow: auto; padding-bottom: 0px; width: 400px; padding-left: 40px;
                            float: left;">
                            <asp:Panel ID="Panel1" runat="server" Style="overflow: auto; width: 338px; padding-left: 10px;
                                float: left;" ScrollBars="Auto" BorderColor="#B6D1FB" BorderStyle="Solid" BorderWidth="1px"
                                Height="150px">
                                <asp:DataList ID="DataList3" runat="server" Width="500px">
                                    <ItemTemplate>
                                        <div style="overflow: auto; width: 490px; float: left;">
                                            <div style="overflow: auto; width: 30px; float: left;">
                                                <asp:CheckBox ID="chkitem" runat="server" />
                                            </div>
                                            <div class="dataliststyle">
                                                <asp:Label ID="Label50" runat="server" Text='<%# bind("CLTId") %>' Visible="False"></asp:Label>
                                                <asp:Label ID="Label51" runat="server" Text='<%# bind("ClientName") %>'></asp:Label>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle Height="17px" />
                                </asp:DataList>
                                <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle" Text="No Jobs Found"
                                    Font-Bold="True" Visible="false"></asp:Label>
                            </asp:Panel>
                            &nbsp;<asp:Label ID="Label54" runat="server" CssClass="errlabelstyle" ForeColor="Red"
                                Text="*"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="row_report">
                    <div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px;
                        padding-top: 5px;">
                        <asp:Label ID="Label33" runat="server" Text="From"></asp:Label>
                    </div>
                    <div style="overflow: auto; width: 110px; height: 20px; padding-top: 5px; float: left;">
                        <div style="overflow: auto; width: 110px; height: 18px; float: left;">
                            <div class="txtcal">
                                <asp:TextBox ID="txtfr" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox></div>
                            <div class="imagecal">
                                <asp:Image ID="Image8" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                            <cc1:CalendarExtender ID="Calendarextender7" runat="server" TargetControlID="txtfr"
                                PopupButtonID="Image8" Format="dd/MM/yyyy">
                            </cc1:CalendarExtender>
                            <asp:Label ID="Label66" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div style="overflow: auto; padding-bottom: 10px; width: 25px; float: left; text-align: right;
                        padding-top: 5px; padding-right: 8px">
                        <asp:Label ID="Label35" runat="server" Text="To"></asp:Label>
                    </div>
                    <div style="overflow: auto; width: 110px; height: 20px; padding-left: 5px; padding-top: 5px;
                        float: left;">
                        <div class="txtcal">
                            <asp:TextBox ID="txtend" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox></div>
                        <div class="imagecal">
                            <asp:Image ID="Image9" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                        <cc1:CalendarExtender ID="Calendarextender8" runat="server" TargetControlID="txtend"
                            PopupButtonID="Image9" Format="dd/MM/yyyy">
                        </cc1:CalendarExtender>
                        <asp:Label ID="Label68" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                    </div>
                </div>
                <div class="row_report">
                    <div style="overflow: auto; width: 260px; height: 25px; padding-left: 150px; padding-top: 5px;
                        float: left; text-align: left;">
                        <asp:Button ID="btngenexp" runat="server" Text="Generate Report" OnClick="btngenexp_Click"
                            CssClass="buttonstyle" />
                    </div>
                </div>
                <div class="footer_repeat">
                    Notes:
                </div>
                <div class="reapeatItem_client">
                    <div id="msghead" class="totbodycatreg" style="overflow: auto; padding-left: 5px">
                        <span class="labelstyle" style="overflow: auto; color: Red; font-size: smaller;">Fields
                            marked with * are required</span>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
