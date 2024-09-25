<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Client_Job_Staff.ascx.cs" Inherits="controls_Client_Job_Staff" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
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
            var pin = document.getElementById("<%= txtfrmdt.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%=txtfrmdt.ClientID%>").focus();
                var month=pad2(mon);
                var days=pad2(day);
                document.getElementById("<%=txtfrmdt.ClientID%>").value =days+"/"+month+"/"+yr ;
                return false;
            }
        }
         function checkForms() {
        
            // regular expression to match required date format
            var dt = new Date();
            var day = dt.getDate();
            var mon =dt.getMonth() + 1;
            var yr = dt.getFullYear();
            var pin = document.getElementById("<%= txttodt.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%= txttodt.ClientID%>").focus();
                var month=pad2(mon);
                var days=pad2(day);
                document.getElementById("<%= txttodt.ClientID%>").value = days+"/"+month+"/"+yr ;
                return false;
            }
        }
       </script>
<div id="div3" class="totbodycatreg">

        <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
        <asp:Label ID="Label1" runat="server" Text="Approver Details" CssClass="Head1 labelChange" ></asp:Label>
        </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <div>
                <uc2:MessageControl ID="MessageControl2" runat="server" />
            </div>
          
          <div style="overflow: auto; padding-bottom: 4px; padding-left:55px; padding-top:15px; width: 100%; float: left;">
                <div style="width: 420px; float: left; overflow: hidden">
                    

                 <div style="overflow: auto; width: 200px; height: 27px;  font-weight: bold;line-height: 20px; padding-top: 5px;">
                       <asp:CheckBox ID="chkbudcl" runat="server" AutoPostBack="True" Text=" Check All Client Name" CssClass="labelChange"
                        OnCheckedChanged="chkbudcl_CheckedChanged" ForeColor="Black" 
                            Font-Names="Verdana" Font-Size="9pt" />
                    </div>
                    <div style="overflow: auto; padding-bottom: 0px; width: 500px; 
                        float: left;">
                       <asp:Panel ID="Panel7"  runat="server" style="width:380px; padding-left:10px; float: left;" ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"  Height="250px">
                        <asp:DataList ID="dlbudclient" runat="server" Width="450px" ForeColor="Black" 
                               Font-Names="Verdana" Font-Size="8pt">
                            <ItemTemplate>
                                <div style="overflow:auto;width: 300px; float: left;">
                                    <div style="overflow:auto;width: 30px; float: left;">
                                        <asp:CheckBox ID="chkitem" runat="server" AutoPostBack="True" 
                                            oncheckedchanged="chkitem_CheckedChanged"/>
                                    </div>
                                    <div class="dataliststyle">
                                        <asp:Label ID="Label50" runat="server" Text='<%# bind("CltId") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="Label51" runat="server" Text='<%# bind("ClientName") %>'></asp:Label>
                                    </div>
                                </div>
                            </ItemTemplate><ItemStyle Height="17px" />
                        </asp:DataList>
                        <asp:Label ID="Label42" runat="server" CssClass="errlabelstyle labelChange" Text="No Clients Found"
                            Font-Bold="True" Visible="False" Font-Names="Verdana" Font-Size="8pt"></asp:Label>
                    </asp:Panel>
                        
                    </div>
                </div>
                <div style="width: 419px; float: left; overflow: hidden">
                    
                    <div style="overflow: auto; height: 22px;  padding-top: 5px; font-weight:bold;">
                                           <asp:CheckBox ID="chkbudjob" runat="server" AutoPostBack="True" Text=" Check All Job Name" CssClass="labelChange"
                        OnCheckedChanged="chkbudjob_CheckedChanged" ForeColor="Black" Font-Names="Verdana" 
                                               Font-Size="9pt" />
                    </div>
                    <div style="overflow: auto; padding-bottom: 0px; width: 500px; 
                        float: left;">
                         <asp:Panel ID="Panel8"  runat="server" style="width:380px;padding-left:10px;float: left;" ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"  Height="250px">
                        <asp:DataList ID="dlbudjob" runat="server" Width="450px" ForeColor="Black" 
                                 Font-Names="Verdana" Font-Size="8pt" Height="250px">
                            <ItemTemplate>
                                <div style="overflow:auto;width: 300px; float: left;">
                                    <div style="overflow:auto;width: 30px; float: left;">
                                        <asp:CheckBox ID="chkitem1" runat="server" />
                                    </div>
                                    <div class="dataliststyle">
                                        <asp:Label ID="Label50" runat="server" Text='<%# bind("MJobId") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="Label51" runat="server" Text='<%# bind("MJobName") %>'></asp:Label>
                                    </div>
                                </div>
                            </ItemTemplate><ItemStyle Height="17px" />
                        </asp:DataList>
                        <asp:Label ID="Label45" runat="server" CssClass="errlabelstyle labelChange" Text="No Jobs Found"
                            Font-Bold="True" Visible="False" Font-Names="Verdana" Font-Size="8pt"></asp:Label>
                    </asp:Panel>
                                          </div>
                </div>
            </div>
          
          <div style="padding-bottom: 4px; padding-top: 4px; width: 100%; padding-left:55px; padding-top:15px;  float: left;">
               <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; width: 100%; float: left;">
			 <div style="overflow: auto; padding-bottom: 10px; font-weight:bold; float: left; padding-right:10px;  padding-top: 11px;">
                    <asp:Label ID="Label5" runat="server" Text="From : "></asp:Label>
                </div>
              <div style="  padding-top: 5px; float: left;">
                    <div style="overflow: auto; float: left;">
                       <asp:TextBox ID="txtfrmdt" runat="server" CssClass="txtnrml texboxcls" Width="70px"></asp:TextBox></div>
                    <div style="overflow: auto; float: left; padding-right: 5px">
                        <asp:Image ID="Image18" runat="server" ImageUrl="~/images/calendar.png" /></div>
                <cc1:CalendarExtender ID="Calendarextender5" runat="server" TargetControlID="txtfrmdt"
                        PopupButtonID="Image18" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                    
                </div>
               <div style="overflow: auto; padding-bottom: 10px; width: 30px; float: left; text-align: right;
                    padding-top: 11px; padding-left:10px;font-weight:bold;">
                    <asp:Label ID="Label6" runat="server" Text="To :" ></asp:Label>
                </div>
                 <div style="padding-left: 5px; padding-top: 5px;
                    float: left;">
                    <div style="float: left;">
                       <asp:TextBox ID="txttodt" runat="server" CssClass="txtnrml texboxcls" Width="70px"></asp:TextBox></div>
                    <div style="overflow: auto; float: left; padding-right: 5px">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/calendar.png" /></div>
                  <cc1:CalendarExtender ID="Calendarextender6" runat="server" TargetControlID="txttodt"
                        PopupButtonID="Image1" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                   
                </div>

  <div style="float: left;  margin:5px 0;">
                    <asp:Button ID="btngrnreport" runat="server" CssClass="TbleBtns" 
                        Text="Generate Report" OnClick="btngrnreport_Click" />
                </div>
                 
                            <div style=" width: 449px; height: 22px; padding-left: 55px; padding-top: 5px;
                    float: left; text-align: left; visibility: hidden;">
                     <asp:RadioButtonList ID="RadioButtonList1" runat="server" 
                      ForeColor="Black" Font-Bold="False" Font-Names="Verdana" Font-Size="9pt"
                RepeatDirection="Horizontal" AutoPostBack="true" Height="22px" 
                                    onselectedindexchanged="RadioButtonList1_SelectedIndexChanged" Width="410px">                              
                                <asp:ListItem Text=" Jobwise Details" Value="0"></asp:ListItem>
                                <asp:ListItem Text=" Staffwise Details" Value="1"></asp:ListItem>
                                
                                
                                </asp:RadioButtonList>
                                <asp:Label ID="Label4" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                </div>





              
                 <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;padding-left:150px;">
                 <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                    <ProgressTemplate>
                        <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                </asp:UpdateProgress></div>
            </div>
            
         
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
