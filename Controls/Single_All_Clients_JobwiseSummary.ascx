<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Single_All_Clients_JobwiseSummary.ascx.cs" Inherits="controls_Single_All_Clients_JobwiseSummary" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
    function pad2(number) {
    return (number < 10 ? '0' : '') + number
   }
        function checkForm() 
        {
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
                document.getElementById("<%= txtstartdate1.ClientID%>").focus();
                var days=pad2(day);
                var month=pad2(mon);
                document.getElementById("<%= txtstartdate1.ClientID%>").value = days+"/"+month+"/"+yr ;
                return false;
            }
        }
         function checkForms() 
        {
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
                  var days=pad2(day);
                var month=pad2(mon);
                document.getElementById("<%= txtenddate2.ClientID%>").value = days+"/"+month+"/"+yr ;
                return false;
            }
        }
       </script>

        <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
            <asp:Label ID="Label6" runat="server" 
                Text="Job wise Summary" CssClass="Head1 labelChange" ></asp:Label></div>

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
 <ContentTemplate>
        <div style="width: 100%; padding-left: 5px; margin-top:25px; padding-right:5px;">
        <uc1:MessageControl ID="MessageControl1" runat="server" />
    </div>
            <div class="row_report">
              
              <div class="panel_headerstyle" style=" float: left; padding-left:55px; padding-top:15px; font-weight: bold; margin: 5px 0; width: 100%;">
               

                    <asp:CheckBox ID="chkjob1" runat="server" AutoPostBack="True" Text=" Check All Client Name" CssClass="labelChange"
                        ForeColor="Black" 
                        Height="20px" oncheckedchanged="chkjob1_CheckedChanged"/>
                </div>
                
                <div style="overflow: auto; width:600px; padding-left:55px; float: left;">
                    <asp:Panel ID="Panel4" runat="server" class="panel_style" ScrollBars="Auto" BorderColor="#CCCCCC"
                        BorderStyle="Solid" BorderWidth="1px" Height="150px">
                        <asp:DataList ID="Client_List" runat="server" Width="550px" ForeColor="Black">
                            <ItemTemplate>
                                <div style="overflow: auto; width: 300px; float: left;">
                                    <div style="overflow: auto; width: 30px; float: left;">
                                        <asp:CheckBox ID="chkitem1" runat="server" />
                                    </div>
                                    <div class="dataliststyle">
                                        <asp:Label ID="Label50" runat="server" Text='<%# bind("ClientName") %>'></asp:Label>
                                        <asp:Label ID="Label51" runat="server" Text='<%# bind("cltid") %>' Visible="False"></asp:Label>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <ItemStyle Height="17px" />
                        </asp:DataList>
                        <asp:Label ID="Label17" runat="server" CssClass="errlabelstyle labelChange" Text="No Staff Found"
                            Font-Bold="True" Visible="False"></asp:Label>
                    </asp:Panel>                
                        &nbsp;<asp:Label ID="Label18" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                </div>
            </div>           
            <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; padding-left:55px; width: 100%; float: left;">
            <div style="overflow: auto; padding-bottom: 10px; font-weight:bold; float: left; padding-right:10px;  padding-top: 11px;">
                    <asp:Label ID="Label19" runat="server" Text="From Date: " ForeColor="Black"></asp:Label>
                </div>
                <div style="  padding-top: 5px; float: left;">
                    <div style="overflow: auto; float: left;">
                        <asp:TextBox ID="txtstartdate1" runat="server" CssClass="txtnrml texboxcls" Width="100px"></asp:TextBox>
                    </div>
                    <div style="overflow: auto; float: left; padding-right: 5px">
                        <asp:Image ID="Image2" runat="server" ImageUrl="~/images/calendar.png" />
                    </div>
                    <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtstartdate1"
                        PopupButtonID="Image2" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                   
                </div>
                 <div style="overflow: auto; padding-bottom: 10px; width: 25px; float: left; text-align: right;
                    padding-top: 11px; padding-right:10px;">
                    <asp:Label ID="Label21" runat="server" Font-Bold="true" Text="To" ForeColor="Black"></asp:Label>
                </div>
                 <div style="width: 152px; height: 20px; padding-left: 5px; padding-top: 5px;
                    float: left;">
                    <div style="float: left;">
                        <asp:TextBox ID="txtenddate2" runat="server" CssClass="txtnrml texboxcls" Width="100px"></asp:TextBox>
                    </div>
                    <div style="overflow: auto; float: left; padding-right: 5px">
                        <asp:Image ID="Image3" runat="server" ImageUrl="~/images/calendar.png" />
                    </div>
                    <cc1:CalendarExtender ID="Calendarextender2" runat="server" TargetControlID="txtenddate2"
                        PopupButtonID="Image3" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                   
                </div>
				  <div style="overflow: auto; padding-bottom: 10px; float: left;">
                    <asp:Button ID="btngen" CssClass="TbleBtns" runat="server" Text="Generate Report"
                        Font-Bold="True" onclick="btngen_Click" />
                </div>
            </div>                               
            <div class="row_report">
               
              
                 <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;padding-left:150px;">
                 <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                    <ProgressTemplate>
                        <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                </asp:UpdateProgress></div>
            </div>
            <div class="row_report">
            </div>
          
      
        </ContentTemplate>
</asp:UpdatePanel>

