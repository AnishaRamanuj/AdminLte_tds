<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="Staff_TimeSheet_Sumary.aspx.cs" Inherits="Admin_Staff_TimeSheet_Sumary" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<%@ Register src="../controls/MessageControl.ascx" tagname="MessageControl" tagprefix="uc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
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
            var pin = document.getElementById("<%= txtstartdate1.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%=txtstartdate1.ClientID%>").focus();
                var month=pad2(mon);
                var days=pad2(day);
                document.getElementById("<%=txtstartdate1.ClientID%>").value =days+"/"+month+"/"+yr ;
                return false;
            }
        }
         function checkForms() {
        
            // regular expression to match required date format
            var dt = new Date();
            var day = dt.getDate();
            var mon =dt.getMonth() + 1;
            var yr = dt.getFullYear();
            var pin = document.getElementById("<%= txtenddate2.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%= txtenddate2.ClientID%>").focus();
                var month=pad2(mon);
                var days=pad2(day);
                document.getElementById("<%= txtenddate2.ClientID%>").value = days+"/"+month+"/"+yr ;
                return false;
            }
        }
       </script>
    <div id="div1" class="totbodycatreg">
        <div class="h_outer">
            <div class="h_inner">
                <div class="headerstyle112">
                    <asp:Label ID="Label6" runat="server" Text="TimeSheet Summary" CssClass="Head1"></asp:Label></div>
            </div>
            <br />
        </div>
        <div class="mbox_top">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div class="d_row">
            <div class="col_lft">
                <asp:Label ID="Label9" runat="server" Text="Company Name"></asp:Label>
            </div>
            <div class="col_rht">
                <asp:DropDownList ID="drpcompanylist" runat="server" DataTextField="CompanyName"
                    DataValueField="CompId" CssClass="stf_drop" AutoPostBack="True" OnSelectedIndexChanged="drpcompanylist_SelectedIndexChanged"
                    AppendDataBoundItems="True" DataSourceID="SqlDropSrc">
                    <asp:ListItem Value="0">--Select--</asp:ListItem>
                </asp:DropDownList>
                <asp:Label ID="Label10" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                    <ProgressTemplate>
                        <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                </asp:UpdateProgress>
                <asp:SqlDataSource ID="SqlDropSrc" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
                    SelectCommand="select CompId,CompanyName from dbo.Company_Master order by CompanyName">
                </asp:SqlDataSource>
            </div>
        </div>
        <div class="d_row">
            <div class="col_lft_nopading">
                <asp:Label ID="Label16" runat="server" Text="Staff Name"></asp:Label>
            </div>
            <div class="col_rht_nopading">
                <asp:CheckBox ID="chkjob1" runat="server" AutoPostBack="True" Text=" Check All" OnCheckedChanged="chkjob1_CheckedChanged" />
            </div>
            <div class="lst_panel">
                <asp:Panel ID="Panel4" runat="server" ScrollBars="Auto" CssClass="stf_lBox">
                    <asp:DataList ID="Staff_List" runat="server" Width="300px">
                        <ItemTemplate>
                            <div style="overflow: auto; width: 300px; float: left;">
                                <div style="overflow: auto; width: 30px; float: left;">
                                    <asp:CheckBox ID="chkitem1" runat="server" />
                                </div>
                                <div class="dataliststyle">
                                    <asp:Label ID="Label50" runat="server" Text='<%# bind("StaffName") %>'></asp:Label>
                                    <asp:Label ID="Label51" runat="server" Text='<%# bind("StaffCode") %>' Visible="False"></asp:Label>
                                </div>
                            </div>
                        </ItemTemplate>
                        <ItemStyle Height="17px" />
                    </asp:DataList>
                    <asp:Label ID="Label17" runat="server" CssClass="errlabelstyle" Text="No Staff Found"
                        Font-Bold="True" Visible="False"></asp:Label>
                </asp:Panel>
                &nbsp;<asp:Label ID="Label18" runat="server" CssClass="errlabelstyle" ForeColor="Red"
                    Text="*"></asp:Label>
            </div>
        </div>
        <div class="d_row">
            <div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px;
                padding-top: 5px;">
                <asp:Label ID="Label19" runat="server" Text="From"></asp:Label>
            </div>
            <div style="overflow: auto; width: 110px; height: 20px; padding-top: 5px; float: left;">
                <div class="txtcal">
                    <asp:TextBox ID="txtstartdate1" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox></div>
                <div class="imagecal">
                    <asp:Image ID="Image2" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtstartdate1"
                    PopupButtonID="Image2" Format="dd/MM/yyyy">
                </cc1:CalendarExtender>
                <asp:Label ID="Label20" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
            </div>
            <div style="overflow: auto; padding-bottom: 10px; width: 25px; float: left; text-align: right;
                padding-right: 8px; padding-top: 5px;">
                <asp:Label ID="Label21" runat="server" Text="To"></asp:Label>
            </div>
            <div style="overflow: auto; width: 110px; height: 20px; padding-left: 5px; padding-top: 5px;
                float: left;">
                <div class="txtcal">
                    <asp:TextBox ID="txtenddate2" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox></div>
                <div class="imagecal">
                    <asp:Image ID="Image3" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                <cc1:CalendarExtender ID="Calendarextender2" runat="server" TargetControlID="txtenddate2"
                    PopupButtonID="Image3" Format="dd/MM/yyyy">
                </cc1:CalendarExtender>
                <asp:Label ID="Label22" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
            </div>
        </div>
        <div class="d_row">
            <div class="col_lft">
            </div>
            <div class="col_rht">
                <asp:Button ID="btngen" CssClass="buttonstyle" runat="server" Text="Generate Report"
                    OnClick="btngen_Click" />
            </div>
        </div>
        <div class="foot_top">
            Notes:
        </div>
        <div class="foot_notes">
            <div id="msghead" class="totbodycatreg" style="overflow: auto; padding-left: 5px">
                <span class="labelstyle" style="overflow: auto; color: Red; font-size: smaller;">Fields
                    marked with * are required</span>
            </div>
        </div>
    </div>
</asp:Content>

