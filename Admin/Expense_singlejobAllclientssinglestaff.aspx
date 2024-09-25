<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="Expense_singlejobAllclientssinglestaff.aspx.cs" Inherits="Admin_Expense_singlejobAllclientssinglestaff"  %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register src="../controls/MessageControl.ascx" tagname="MessageControl" tagprefix="uc2" %>
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
            var pin = document.getElementById("<%= txtfr.ClientID%>").value;
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
    <div id="div4" class="totbodycatreg">
        <div class="h_outer">
            <div class="h_inner">
                <div class="headerstyle112">
                    <asp:Label ID="Label2" runat="server" Text="Single Job - All Clients - Single Staff Report"
                        CssClass="Head1"></asp:Label>
                </div>
            </div>
            <br />
        </div>
        <div class="mbox_top">
            <uc2:MessageControl ID="MessageControl2" runat="server" />
        </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div style="overflow: auto; width: 99%; padding-left: 5px">
                </div>
                <div  class="d_row">
                    <div class="col_lft">
                        <asp:Label ID="Label39" runat="server" Text="Company Name"></asp:Label>
                    </div>
                    <div class="col_rht">
                        <asp:DropDownList ID="drpopecmp" runat="server" DataTextField="CompanyName" DataValueField="CompId"
                            CssClass="stf_drop" AutoPostBack="True" AppendDataBoundItems="True" OnSelectedIndexChanged="drpopecmp_SelectedIndexChanged">
                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                        </asp:DropDownList>
                        <%--<asp:SqlDataSource ID="SqlDataSource1" runat="server" SelectCommand="SELECT * from Company_Master"
                                                     ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>">
                         </asp:SqlDataSource>--%>
                        <asp:Label ID="Label40" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                            <ProgressTemplate>
                                <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                        </asp:UpdateProgress>
                    </div>
                </div>
                <div class="d_row">
                    <div style="width: 420px; float: left; overflow: hidden">
                        <div style="overflow: auto; padding-bottom: 0px; width: 110px; float: left; padding-left: 40px;
                            padding-top: 5px;">
                            <asp:Label ID="Label59" runat="server" Text="Client Name"></asp:Label>
                        </div>
                        <div style="overflow: auto; width: 200px; height: 15px; padding-top: 5px;">
                            <asp:CheckBox ID="chkclope" runat="server" AutoPostBack="True" Text=" Check All"
                                OnCheckedChanged="chkclope_CheckedChanged" />
                        </div>
                        <div style="overflow: auto; padding-bottom: 0px; width: 370px; padding-left: 40px;
                            float: left;">
                            <asp:Panel ID="Panel9" runat="server" ScrollBars="Auto" CssClass="stf_lBox">
                                <asp:DataList ID="DataList3" runat="server" Width="300px">
                                    <ItemTemplate>
                                        <div style="overflow: auto; width: 300px; float: left;">
                                            <div style="overflow: auto; width: 30px; float: left;">
                                                <asp:CheckBox ID="chkitem" runat="server" />
                                            </div>
                                            <div class="stf_lBox_inner">
                                                <asp:Label ID="Label50" runat="server" Text='<%# bind("CLTId") %>' Visible="False"></asp:Label>
                                                <asp:Label ID="Label51" runat="server" Text='<%# bind("ClientName") %>'></asp:Label>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle Height="17px" />
                                </asp:DataList>
                                <asp:Label ID="Label60" runat="server" CssClass="errlabelstyle" Font-Bold="True"
                                    Text="No Clients Found" Visible="false"></asp:Label>
                            </asp:Panel>
                            &nbsp;<asp:Label ID="Label61" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
                        </div>
                    </div>
                    <div style="width: 450px; float: left; overflow: hidden">
                        <div style="overflow: auto; padding-bottom: 0px; width: 110px; float: left; padding-left: 40px;
                            padding-top: 5px;">
                            <asp:Label ID="Label69" runat="server" Text="Staff Name"></asp:Label>
                        </div>
                        <div style="overflow: auto; width: 200px; height: 15px; padding-left: 5px; padding-top: 5px;">
                            <asp:CheckBox ID="chkstope" runat="server" AutoPostBack="True" Text=" Check All"
                                OnCheckedChanged="chkstope_CheckedChanged" />
                        </div>
                        <div style="overflow: auto; padding-bottom: 0px; width: 370px; padding-left: 40px;
                            float: left;">
                            <asp:Panel ID="Panel11" runat="server" ScrollBars="Auto" CssClass="stf_lBox">
                                <asp:DataList ID="DataList4" runat="server" Width="300px">
                                    <ItemTemplate>
                                        <div style="overflow: auto; width: 300px; float: left;">
                                            <div style="overflow: auto; width: 30px; float: left;">
                                                <asp:CheckBox ID="chkitem0" runat="server" />
                                            </div>
                                            <div class="stf_lBox_inner">
                                                <asp:Label ID="Label71" runat="server" Text='<%# bind("StaffCode") %>' Visible="False"></asp:Label>
                                                <asp:Label ID="Label72" runat="server" Text='<%# bind("StaffName") %>'></asp:Label>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                    <ItemStyle Height="17px" />
                                </asp:DataList>
                                <asp:Label ID="Label70" runat="server" CssClass="errlabelstyle" Font-Bold="True"
                                    Text="No Staffs Found" Visible="False"></asp:Label>
                            </asp:Panel>
                            &nbsp;<asp:Label ID="Label73" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
                        </div>
                    </div>
                </div>
                <div class="d_row">
                     <div class="col_lft_nopading">
                        <asp:Label ID="Label62" runat="server" Text="Job Name"></asp:Label>
                    </div>
                    <div class="col_rht_nopading">
                        <asp:CheckBox ID="chkjobope" runat="server" AutoPostBack="True" Text=" Check All"
                            OnCheckedChanged="chkjobope_CheckedChanged" />
                         </div>
                <div class="lst_panel">
                        <asp:Panel ID="Panel10" runat="server" ScrollBars="Auto" CssClass="stf_lBox">
                            <asp:DataList ID="DataList5" runat="server" Width="300px">
                                <ItemTemplate>
                                    <div style="overflow: auto; width: 300px; float: left;">
                                        <div style="overflow: auto; width: 30px; float: left;">
                                            <asp:CheckBox ID="chkitem1" runat="server" />
                                        </div>
                                        <div class="stf_lBox_inner">
                                            <asp:Label ID="Label50" runat="server" Text='<%# bind("JobId") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="Label51" runat="server" Text='<%# bind("JobName") %>'></asp:Label>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle Height="17px" />
                            </asp:DataList>
                            <asp:Label ID="Label63" runat="server" CssClass="errlabelstyle" Font-Bold="True"
                                Text="No Jobs Found" Visible="false"></asp:Label>
                        </asp:Panel>
                        &nbsp;<asp:Label ID="Label64" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
                    </div>
                </div>
                <div class="d_row">
                   <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; width: 100%; float: left;">
                    <div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px;
                        padding-top: 5px;">
                        <asp:Label ID="Label65" runat="server" Text="From"></asp:Label>
                    </div>
                    <div style="overflow: auto; width: 110px; height: 20px; padding-left: 5px; padding-top: 5px;
                        float: left;">
                        <div style="overflow: auto; float: left; padding-right: 0px">
                            <asp:TextBox ID="txtfr" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox>
                        <cc1:CalendarExtender ID="Calendarextender7" runat="server" TargetControlID="txtfr"
                            PopupButtonID="Image8" Format="dd/MM/yyyy">
                        </cc1:CalendarExtender>
                        </div>
                        <div style="overflow: auto; float: left; padding-right: 5px">
                            <asp:Image ID="Image8" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                        <asp:Label ID="Label66" runat="server" CssClass="errlabelstyle" Text="*" 
                            ForeColor="Red"></asp:Label>
                    </div>
                    <div style="overflow: auto; padding-bottom: 10px; width: 28px; float: left; text-align: right;
                        padding-top: 5px;">
                        <asp:Label ID="Label67" runat="server" Text="To"></asp:Label>
                    </div>
                    <div style="overflow: auto; width: 110px; height: 20px; padding-left: 5px; padding-top: 5px;
                        float: left;">
                        <div style="overflow: auto; float: left; padding-right: 0px">
                            <asp:TextBox ID="txtend" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox>
                        <cc1:CalendarExtender ID="Calendarextender8" runat="server" TargetControlID="txtend"
                            PopupButtonID="Image9" Format="dd/MM/yyyy">
                        </cc1:CalendarExtender>
                        </div>
                        <div style="overflow: auto; float: left; padding-right: 5px">
                            <asp:Image ID="Image9" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                        <asp:Label ID="Label68" runat="server" CssClass="errlabelstyle" Text="*" 
                            ForeColor="Red"></asp:Label>
                    </div>
                    <div style="overflow: auto; width: 260px; height: 25px; padding-left: 52px; padding-top: 5px;
                        float: left; text-align: left;">
                        <asp:Button ID="btngenexp" runat="server" Text="Generate Report" OnClick="btngenexp_Click"
                            CssClass="buttonstyle" />
                    </div>
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
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>

