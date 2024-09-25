<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="AllJobs_FortNight.aspx.cs" Inherits="Admin_AllJobs_FortNight" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="../controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
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
            var pin = document.getElementById("<%= txtenddate2.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%= txtenddate2.ClientID%>").focus();
                var month=pad2(mon);
                document.getElementById("<%= txtenddate2.ClientID%>").value = month+"/"+yr ;
                return false;
            }
        }
       </script>
    <div id="div1" class="totbodycatreg">
        <div class="headerstyle11">
            <div class="headerstyle112">
                <asp:Label ID="Label1" runat="server" Text="All jobs - Fortnight Report" CssClass="Head1"></asp:Label>
            </div>
        </div> <div style="overflow:auto;width:98%;padding-left:5px;padding-right:5px">
        <uc1:MessageControl ID="MessageControl1" runat="server" /></div>
        <div class="row_report">
            <div class="rowinnerstyle1">
                <asp:Label ID="Label9" runat="server" Text="Company Name"></asp:Label>
            </div>
            <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
                <asp:DropDownList ID="drpcompanylist" runat="server" DataTextField="CompanyName"
                    DataValueField="CompId" Width="240px" Height="20px" DataSourceID="SqlDropSrc" CssClass="dropstyle"
                    AutoPostBack="True" OnSelectedIndexChanged="drpcompanylist_SelectedIndexChanged"
                    AppendDataBoundItems="True">
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
        <div class="row_report">
          <div style="width: 420px; float: left; overflow: hidden">
            <div style="overflow: auto; width: 110px; float: left; padding-left: 40px;padding-top: 5px;">
                <asp:Label ID="Label16" runat="server" Text="Client Name"></asp:Label>
            </div>
            <div style="overflow: auto; width: 200px; height: 15px; padding-top: 5px;">
                <asp:CheckBox ID="chkjob1" runat="server" AutoPostBack="True" Text=" Check All" OnCheckedChanged="chkjob1_CheckedChanged" />
            </div>
            <div style="overflow: auto; padding-bottom: 0px; width:370px;float: left; padding-left:40px;">
                <asp:Panel ID="Panel4" runat="server" Style="width: 338px; padding-left: 10px; float: left;"
                    ScrollBars="Auto" BorderColor="#B6D1FB" BorderStyle="Solid" BorderWidth="1px"
                    Height="150px">
                    <asp:DataList ID="List_Client" runat="server" Width="310px">
                        <ItemTemplate>
                            <div style="overflow: auto; width: 300px; float: left;">
                                <div style="overflow: auto; width: 30px; float: left;">
                                    <asp:CheckBox ID="chkitem1" runat="server" />
                                </div>
                                <div class="dataliststyle">
                                    <asp:Label ID="Label50" runat="server" Text='<%# bind("ClientName") %>'></asp:Label>
                                    <asp:Label ID="Label51" runat="server" Text='<%# bind("CLTId") %>' Visible="False"></asp:Label>
                                </div>
                            </div>
                        </ItemTemplate>
                        <ItemStyle Height="17px" />
                    </asp:DataList>
                    <asp:Label ID="Label17" runat="server" CssClass="errlabelstyle" Text="No Jobs Found"
                        Font-Bold="True" Visible="false"></asp:Label>
                </asp:Panel>
                &nbsp;<asp:Label ID="Label18" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
            </div>
            </div>
            
        </div>
        <div class="row_report">
            <div class="rowinnerstyle1">
                <asp:Label ID="Label21" runat="server" Text="To"></asp:Label>
            </div>
            <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
                <div class="txtcal">
                    <asp:TextBox ID="txtenddate2" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox></div>
                <div class="imagecal">
                    <asp:Image ID="Image3" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                <cc1:CalendarExtender ID="Calendarextender2" runat="server" TargetControlID="txtenddate2"
                    PopupButtonID="Image3" Format="MM/yyyy">
                </cc1:CalendarExtender>
                <asp:Label ID="Label22" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
            </div>
        </div>
        <div class="row_report">
       <div class="rowinnerstyle1" style="width:200px;padding-left:150px;">
                <asp:Button ID="btngen" runat="server" Text="Generate Report" CssClass="buttonstyle"
                    OnClick="btngen_Click" />
            </div>
        </div>
         <div class="foot_top">
            Notes:
        </div>
        <div class="reapeatItem_client">
            <div id="msghead" class="totbodycatreg" style="overflow: auto; padding-left: 5px">
                <span class="labelstyle" style="overflow: auto; color: Red; font-size: smaller;">Fields
                    marked with * are required</span>
            </div>
        </div>
        <div class="row_report">
        </div>
    </div>
</asp:Content>
