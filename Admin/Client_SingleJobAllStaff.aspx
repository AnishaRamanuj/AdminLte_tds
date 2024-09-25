﻿<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="Client_SingleJobAllStaff.aspx.cs" Inherits="Admin_Client_SingleJobAllStaff" %>

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
            var pin = document.getElementById("<%= fromdate.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%=fromdate.ClientID%>").focus();
                var month=pad2(mon);
                var days=pad2(day);
                document.getElementById("<%=fromdate.ClientID%>").value =days+"/"+month+"/"+yr ;
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
                var days=pad2(day);
                document.getElementById("<%= txtenddate.ClientID%>").value = days+"/"+month+"/"+yr ;
                return false;
            }
        }
       </script>
    <div id="divtitl" class="totbodycatreg">
      <div class="headerstyle11"> <div class="headerstyle112">
            <asp:Label ID="Label9" runat="server" Text="Single Job-All Staffs Report" CssClass="Head1"></asp:Label></div></div>
          <div style="overflow:auto;width:98%;padding-left:5px;padding-right:5px">
      <uc2:MessageControl ID="MessageControl2" runat="server" /></div>
           <asp:UpdatePanel ID="UpdatePanel1" runat="server">
          <ContentTemplate>        
        <div style="overflow:auto;padding-bottom: 4px;padding-top:4px; width: 100%; float: left;">
            <div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px; padding-top: 5px;">
                <asp:Label ID="Label1" runat="server" Text="Company Name"></asp:Label>
            </div>
            <div style="overflow:auto;padding-bottom: 10px; width: 58%; float: left;">
                <asp:DropDownList ID="drpcompany" runat="server" DataTextField="CompanyName" DataValueField="CompId"
                    Width="240px" CssClass="dropstyle" Height="20px" AutoPostBack="True" OnSelectedIndexChanged="drpcompany_SelectedIndexChanged"
                    AppendDataBoundItems="True">
                    <asp:ListItem Value="0">--Select--</asp:ListItem>
                </asp:DropDownList>
                <asp:Label ID="Label56" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                 <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                 <ProgressTemplate>
                            <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                    </asp:UpdateProgress>
            </div>
            
        </div>
        <div style="overflow:auto;padding-bottom: 4px;padding-top:4px; width: 100%; float: left;">
            <div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px; padding-top: 5px;">
                <asp:Label ID="Label2" runat="server" Text="Client Name"></asp:Label>
            </div>
            <div style="overflow:auto;padding-bottom: 10px; width: 58%; float: left;">
                <asp:DropDownList ID="drpclient" runat="server" DataTextField="ClientName" DataValueField="CLTId"
                    Width="240px" Height="20px" CssClass="dropstyle" AppendDataBoundItems="True">
                    <asp:ListItem Value="0">--Select--</asp:ListItem>
                </asp:DropDownList>
                <asp:Label ID="Label55" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
            </div>
        </div>
        <div style="overflow:auto;padding-bottom: 4px;padding-top:4px; width: 100%; float: left;">
        <div style="width:420px;float:left;overflow:hidden">
            <div style="overflow: auto; padding-bottom:0px; width: 110px; float: left; padding-left: 40px; padding-top: 5px;">
                <asp:Label ID="Label3" runat="server" Text="Staff Name"></asp:Label>
            </div>
            <div style="overflow:auto;width:200px;height:15px;padding-top: 5px;">
                <asp:CheckBox ID="chkstaff" runat="server" AutoPostBack="True" OnCheckedChanged="chkstaff_CheckedChanged"
                    Text=" Check All" />
            </div>
            <div style="overflow:auto;padding-bottom: 0px; width: 370px;padding-left:40px;float: left;">
                <asp:Panel ID="Panel1" runat="server" style="overflow:auto;width:338px;padding-left:10px;float: left;" ScrollBars="Auto" BorderColor="#B6D1FB" Borderstyle="Solid" BorderWidth="1px"  Height="150px">
                    <asp:DataList ID="DataList1" runat="server" Width="500px">
                        <ItemTemplate>
                            <div style="overflow:auto;width: 490px; float: left;">
                                <div style="overflow:auto;width: 30px; float: left;">
                                    <asp:CheckBox ID="chkitem" runat="server" />
                                </div>
                                <div class="dataliststyle">
                                    <asp:Label ID="Label50" runat="server" Text='<%# bind("StaffName") %>'></asp:Label>
                                    <asp:Label ID="Label51" runat="server" Text='<%# bind("StaffCode") %>' Visible="False"></asp:Label>
                                </div>
                            </div>
                         </ItemTemplate><ItemStyle Height="17px" />    
                    </asp:DataList>
                    <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle" Text="No Staffs Found"
                        Font-Bold="True" Visible="false"></asp:Label>
                </asp:Panel>&nbsp; <asp:Label ID="Label54" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
            </div>
                           
        </div>
        <div style="width:450px;float:left;overflow:hidden">
            <div style="overflow: auto; padding-bottom:0px; width: 110px; float: left; padding-left: 40px; padding-top: 5px;">
                <asp:Label ID="Label4" runat="server" Text="Job Name"></asp:Label>
            </div>
            <div style="overflow:auto;width:200px;height:15px;padding-left:5px; padding-top: 5px;">
                <asp:CheckBox ID="chkjob" runat="server" AutoPostBack="True" Text=" Check All" OnCheckedChanged="chkjob_CheckedChanged" />
            </div>
            <div style="overflow:auto;padding-bottom: 0px; width: 370px;padding-left:40px;float: left;">
                <asp:Panel ID="Panel2" runat="server" style="overflow:auto;width:338px;padding-left:10px;float: left;" ScrollBars="Auto" BorderColor="#B6D1FB" Borderstyle="Solid" BorderWidth="1px"  Height="150px">
                    <asp:DataList ID="DataList2" runat="server" Width="500px">
                        <ItemTemplate>
                            <div style="overflow:auto;width: 490px; float: left;">
                                <div style="overflow:auto;width: 30px; float: left;">
                                    <asp:CheckBox ID="chkitem1" runat="server" />
                                </div>
                                <div class="dataliststyle">
                                    <asp:Label ID="Label50" runat="server" Text='<%# bind("JobName") %>'></asp:Label>
                                    <asp:Label ID="Label51" runat="server" Text='<%# bind("JobId") %>' Visible="False"></asp:Label>
                                </div>
                            </div>
                        </ItemTemplate><ItemStyle Height="17px" />    
                    </asp:DataList>
                    <asp:Label ID="Label8" runat="server" CssClass="errlabelstyle" Text="No Jobs Found"
                        Font-Bold="True" Visible="false"></asp:Label>
                </asp:Panel>&nbsp;<asp:Label ID="Label53" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
            </div>
                            

        </div>
        </div>
       <div style="overflow:auto;padding-bottom: 4px;padding-top:4px; width: 100%; float: left;">
            <div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px; padding-top: 5px;">
                <asp:Label ID="Label5" runat="server" Text="From"></asp:Label>
            </div>
            <div style="overflow:auto;width:110px;height:20px;padding-left:5px; padding-top: 5px;float: left;">
                <div style="overflow:auto;float: left; padding-right: 0px">
                    <asp:TextBox ID="fromdate" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox></div>
                <div style="overflow:auto;float: left; padding-right: 5px">
                    <asp:Image ID="Image18" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                <cc1:CalendarExtender ID="fromdate_CalendarExtender" runat="server" TargetControlID="fromdate"
                    PopupButtonID="Image18" Format="dd/MM/yyyy">
                </cc1:CalendarExtender>
                <asp:Label ID="Label52" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
            </div>
            <div style="overflow: auto; padding-bottom: 10px; width: 28px; float: left;text-align:right;padding-top: 5px;">
                <asp:Label ID="Label6" runat="server" Text="To"></asp:Label>
            </div>
            <div style="overflow:auto;width:110px;height:20px;padding-left:5px; padding-top: 5px;float: left;">
                <div style="overflow:auto;float: left; padding-right: 0px">
                    <asp:TextBox ID="txtenddate" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox></div>
                <div style="overflow:auto;float: left; padding-right: 5px">
                    <asp:Image ID="Image1" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                <cc1:CalendarExtender ID="txtenddate_Calendarextender1" runat="server" TargetControlID="txtenddate"
                    PopupButtonID="Image1" Format="dd/MM/yyyy">
                </cc1:CalendarExtender>
                <asp:Label ID="Label46" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
            </div>     
            <div style="overflow:auto;width:260px;height:25px;padding-left:52px; padding-top: 5px;float: left;text-align:left;">
                <asp:Button ID="btngenerate" runat="server" Text="Generate Report" CssClass="buttonstyle" OnClick="btngenerate_Click" />
            </div>
        </div>
        <div class="footer_repeat">
            Notes:
        </div>
        <div class="reapeatItem_client">
<div id="msghead" class="totbodycatreg" style="overflow:auto;padding-left: 5px">
            <span class="labelstyle" style="overflow:auto;color:Red; font-size:smaller;">Fields marked 
            with * are required</span>         
        </div>
        </div>
        <div style="overflow:auto;padding-bottom: 10px; padding-top: 10px; width: 100%; float: left;">
        </div>
        </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
