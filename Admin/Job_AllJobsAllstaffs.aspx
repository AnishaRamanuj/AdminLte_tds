<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="Job_AllJobsAllstaffs.aspx.cs" Inherits="Admin_Job_AllJobsAllstaffs" %>

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
            var pin = document.getElementById("<%= txtfrom.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%=txtfrom.ClientID%>").focus();
                var month=pad2(mon);
                var days=pad2(day);
                document.getElementById("<%=txtfrom.ClientID%>").value =days+"/"+month+"/"+yr ;
                return false;
            }
        }
         function checkForms() {
        
            // regular expression to match required date format
            var dt = new Date();
            var day = dt.getDate();
            var mon =dt.getMonth() + 1;
            var yr = dt.getFullYear();
            var pin = document.getElementById("<%= txtto.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%= txtto.ClientID%>").focus();
                var month=pad2(mon);
                var days=pad2(day);
                document.getElementById("<%= txtto.ClientID%>").value = days+"/"+month+"/"+yr ;
                return false;
            }
        }
       </script>
    <div id="div2" class="totbodycatreg">
        <div class="headerstyle11">
            <div class="headerstyle112">
                <asp:Label ID="Label2" runat="server" Text="All Jobs - All Staffs Report" CssClass="Head1"></asp:Label></div>
        </div>
          <div style="overflow: auto; width: 97%; padding-left: 5px;padding-right:5px;">
                    <uc2:MessageControl ID="MessageControl2" runat="server" />
                </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
            
                <div class="row_report">
                    <div class="rowinnerstyle1">
                        <asp:Label ID="Label23" runat="server" Text="Company Name"></asp:Label>
                    </div>
                    <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
                        <asp:DropDownList ID="drpcomp" runat="server" DataTextField="CompanyName" DataValueField="CompId"
                            Width="240px" Height="20px" CssClass="dropstyle" AutoPostBack="True" AppendDataBoundItems="True"
                            OnSelectedIndexChanged="drpcomp_SelectedIndexChanged">
                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                        </asp:DropDownList>
                        <asp:Label ID="Label24" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                            <ProgressTemplate>
                                <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                        </asp:UpdateProgress>
                    </div>
                </div>
                <div class="row_report">
                    <div style="width: 420px; float: left; overflow: hidden">
                        <div style="overflow: auto; width: 110px; float: left; padding-left: 40px;">
                            <asp:Label ID="Label27" runat="server" Text="Staff Name"></asp:Label>
                        </div>
                        <div style="overflow: auto;">
                            <asp:CheckBox ID="chkstaffbox" runat="server" AutoPostBack="True" Text=" Check All"
                                OnCheckedChanged="chkstaffbox_CheckedChanged" />
                        </div>
                        <div style="overflow: auto; padding-bottom: 0px; width: 370px; padding-left: 40px;
                            float: left;">
                            <asp:Panel ID="Panel5" runat="server" Style="overflow: auto; width: 338px; padding-left: 10px;
                                float: left;" ScrollBars="Auto" BorderColor="#B6D1FB" BorderStyle="Solid" BorderWidth="1px"
                                Height="150px">
                                <asp:DataList ID="dlstaff" runat="server" Width="310px">
                                    <ItemTemplate>
                                        <div style="overflow: auto; width: 300px; float: left;">
                                            <div style="overflow: auto; width: 30px; float: left;">
                                                <asp:CheckBox ID="chkitem" runat="server" />
                                            </div>
                                            <div class="dataliststyle">
                                                <asp:Label ID="Label50" runat="server" Text='<%# bind("StaffName") %>'></asp:Label>
                                                <asp:Label ID="Label51" runat="server" Text='<%# bind("StaffCode") %>' Visible="False"></asp:Label>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle Height="17px" />
                                </asp:DataList>
                                <asp:Label ID="Label28" runat="server" CssClass="errlabelstyle" Text="No Staffs Found"
                                    Font-Bold="True" Visible="false"></asp:Label>
                            </asp:Panel>
                            &nbsp;<asp:Label ID="Label29" runat="server" CssClass="errlabelstyle" ForeColor="Red"
                                Text="*"></asp:Label>
                        </div>
                    </div>
                    <div style="width: 450px; float: left; overflow: hidden">
                        <div style="overflow: auto; width: 20%; float: left; padding-left: 40px">
                            <asp:Label ID="Label30" runat="server" Text="Job Name"></asp:Label>
                        </div>
                        <div style="overflow: auto; padding-left: 5px">
                            <asp:CheckBox ID="chkclientbox" runat="server" AutoPostBack="True" Text=" Check All"
                                OnCheckedChanged="chkclientbox_CheckedChanged" />
                        </div>
                        <div style="overflow: auto; padding-bottom: 0px; width: 370px; padding-left: 40px;
                            float: left;">
                            <asp:Panel ID="Panel6" runat="server" Style="overflow: auto; width: 338px; padding-left: 10px;
                                float: left;" ScrollBars="Auto" BorderColor="#B6D1FB" BorderStyle="Solid" BorderWidth="1px"
                                Height="150px">
                                <asp:DataList ID="dlclient" runat="server" Width="310px">
                                    <ItemTemplate>
                                        <div style="overflow: auto; width: 300px; float: left;">
                                            <div style="overflow: auto; width: 30px; float: left;">
                                                <asp:CheckBox ID="chkitem1" runat="server" />
                                            </div>
                                            <div class="dataliststyle">
                                                <asp:Label ID="Label50" runat="server" Text='<%# bind("JobName") %>'></asp:Label>
                                                <asp:Label ID="Label51" runat="server" Text='<%# bind("JobId") %>' Visible="False"></asp:Label>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle Height="17px" />
                                </asp:DataList>
                                <asp:Label ID="Label31" runat="server" CssClass="errlabelstyle" Text="No Clients Found"
                                    Font-Bold="True" Visible="false"></asp:Label>
                            </asp:Panel>
                            &nbsp;<asp:Label ID="Label32" runat="server" CssClass="errlabelstyle" ForeColor="Red"
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
                        <div class="txtcal">
                            <asp:TextBox ID="txtfrom" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox></div>
                        <div class="imagecal">
                            <asp:Image ID="Image4" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtfrom"
                            PopupButtonID="Image4" Format="dd/MM/yyyy">
                        </cc1:CalendarExtender>
                        <asp:Label ID="Label34" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                    </div>
                    <div style="overflow: auto; padding-bottom: 10px; width: 25px; float: left; text-align: right;
                        padding-top: 5px; padding-right: 8px">
                        <asp:Label ID="Label35" runat="server" Text="To"></asp:Label>
                    </div>
                    <div style="overflow: auto; width: 110px; height: 20px; padding-left: 5px; padding-top: 5px;
                        float: left;">
                        <div class="txtcal">
                            <asp:TextBox ID="txtto" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox></div>
                        <div class="imagecal">
                            <asp:Image ID="Image5" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                        <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtto"
                            PopupButtonID="Image5" Format="dd/MM/yyyy">
                        </cc1:CalendarExtender>
                        <asp:Label ID="Label36" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                    </div>
                    <div style="overflow: auto; width: 260px; height: 25px; padding-left: 55px; padding-top: 5px;
                        float: left; text-align: left;">
                        <asp:Button ID="btngenerate1" runat="server" Text="Generate Report" CssClass="buttonstyle"
                            OnClick="btngenerate1_Click" />
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
                <div style="overflow: auto; padding-bottom: 10px; padding-top: 10px; width: 100%;
                    float: left;">
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
