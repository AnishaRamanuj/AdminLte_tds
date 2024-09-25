<%@ Control Language="C#" AutoEventWireup="true" CodeFile="All_ClientStaffJob2.ascx.cs" Inherits="controls_All_ClientStaffJob2" %>
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
<div id="div4" class="totbodycatreg" style="min-height:500px;">

     <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
            <asp:Label ID="Label1" runat="server" Text="Client Detail Report"
                CssClass="Head1 labelChange"></asp:Label>
     </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <uc2:MessageControl ID="MessageControl2" runat="server" />
            </div>
            <div class="d_row">
                <div style="width: 320px; padding-left:55px; padding-top:15px; float: left; overflow: hidden">
                   <div style="overflow: auto; width: 200px; padding-left:10px; padding-top: 5px; font-weight:bold;">
                        <asp:CheckBox ID="chkclient" runat="server" AutoPostBack="True" CssClass="labelChange" Text=" Check All Client Name"
                            OnCheckedChanged="chkclient_CheckedChanged" ForeColor="Black" />
                    </div>
                        
                   
                    <div style="overflow: auto; padding-bottom: 0px;
                        float: left;">
                        
                        
                        <asp:Panel ID="Panel9" runat="server" Style="width: 295px; padding-left: 10px; float: left;"
                            ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                            Height="300px">
                            
                            <asp:DataList ID="DlstCLT" runat="server" Width="295px" ForeColor="Black">
                                <ItemTemplate>
                                    <div style="overflow: auto; width: 270px; float: left;">
                                        <div style="overflow: auto; width: 30px; float: left;">
                                            <asp:CheckBox ID="chkitem" runat="server" AutoPostBack="True"
                                                oncheckedchanged="chkitem_CheckedChanged" />
                                        </div>
                                        <div class="dataliststyle">
                                            <asp:Label ID="Label50" runat="server" Text='<%# bind("CLTId") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="Label51" runat="server" Text='<%# bind("ClientName") %>'></asp:Label>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle Height="17px" />
                            </asp:DataList>
                            <asp:Label ID="Label60" runat="server" CssClass="errlabelstyle labelChange" Text="No Clients Found"
                                Font-Bold="True" Visible="false"></asp:Label>
                        </asp:Panel>
                      
                    </div>
                </div>
                <div style="width:350px; float: left; padding-left:55px; padding-top:15px; overflow: hidden">
                    
                     <div style="overflow: auto; width: 200px; height: 26px; padding-left:10px; padding-top: 5px; font-weight:bold;">
                        <asp:CheckBox ID="chkstaff" runat="server" AutoPostBack="True" CssClass="labelChange" Text=" Check All Staff Name"
                            OnCheckedChanged="chkstaff_CheckedChanged" ForeColor="Black" />
                    </div>
                    <div style="overflow: auto; padding-bottom: 0px; width: 340px; float: left;">
                        <asp:Panel ID="Panel11" runat="server" Style="width: 320px; padding-left: 10px; float: left;"
                            ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                            Height="300px">
                            <asp:DataList ID="DlstStf" runat="server" Width="300px" ForeColor="Black">
                                <ItemTemplate>
                                    <div style="overflow: auto; width: 250px; float: left;">
                                        <div style="overflow: auto; width: 30px; float: left;">
                                            <asp:CheckBox ID="chkitem" runat="server" AutoPostBack="true"  />
                                        </div>
                                        <div class="dataliststyle">
                                            <asp:Label ID="Label50" runat="server" Text='<%# bind("StaffCode") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="Label51" runat="server" Text='<%# bind("StaffName") %>'></asp:Label>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle Height="17px" />
                            </asp:DataList>
                            <asp:Label ID="Label70" runat="server" CssClass="errlabelstyle labelChange" Text="No Staffs Found"
                                Font-Bold="True" Visible="False"></asp:Label>
                        </asp:Panel>
                      
                    </div>
                </div>
           
            <div style="overflow: auto; padding-bottom: 10px; padding-left:55px; padding-top:15px;  width:330px; float: left;">
                
                <div style="overflow: auto; width: 200px; height: 25px; padding-left:10px; padding-top: 5px; font-weight:bold;">
                    <asp:CheckBox ID="chkjob" runat="server" AutoPostBack="True" CssClass="labelChange" Text="Check All Job Name"
                        OnCheckedChanged="chkjob_CheckedChanged" ForeColor="Black" />
                </div>
                
                <div style="overflow: auto; padding-bottom: 10px; width: 100%; float: left;">
                    <asp:Panel ID="Panel10" runat="server" Style="width: 318px; padding-left: 10px; float: left;"
                        ScrollBars="Auto" BorderColor="#B6D1FB" BorderStyle="Solid" BorderWidth="1px"
                        Height="300px">
                        <asp:DataList ID="DlstJob" runat="server" Width="290px" ForeColor="Black">
                            <ItemTemplate>
                                <div style="overflow: auto; width:270px; float: left;">
                                    <div style="overflow: auto; width: 30px; float: left;">
                                        <asp:CheckBox ID="chkitem" runat="server" AutoPostBack="true"
                                            oncheckedchanged="chkitem_CheckedChangedjob"  />
                                    </div>
                                    <div class="dataliststyle">
                                        <asp:Label ID="Label50" runat="server" Text='<%# bind("mJobId") %>' Visible="False"></asp:Label>
                                        <asp:Label ID="Label51" runat="server" Text='<%# bind("mJobName") %>'></asp:Label>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <ItemStyle Height="17px" />
                        </asp:DataList>
                        <asp:Label ID="Label63" runat="server" CssClass="errlabelstyle labelChange" Text="No Jobs Found"
                            Font-Bold="True" Visible="false"></asp:Label>
                    </asp:Panel>
                   
                </div>
            </div>
             </div>
             <div style="padding-bottom: 4px; padding-top: 4px; padding-left:55px; width: 100%; float: left;">
                  <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; width: 100%; float: left;">
			 <div style="overflow: auto; padding-bottom: 10px; font-weight:bold; float: left; padding-right:10px;  padding-top: 11px;">
                    <asp:Label ID="Label65" runat="server" Text="From :" ForeColor="Black"></asp:Label>
                </div>
                <div style="  padding-top: 5px; float: left;">
                    <div style="overflow: auto; float: left;">
                        <asp:TextBox ID="txtfr" runat="server" CssClass="txtnrml texboxcls" Width="70px"></asp:TextBox>
                    </div>
                    <div style="overflow: auto; float: left; padding-right: 5px">
                        <asp:Image ID="Image8" runat="server" ImageUrl="~/images/calendar.png" />
                    </div>
                    <cc1:CalendarExtender ID="Calendarextender7" runat="server" TargetControlID="txtfr"
                        PopupButtonID="Image8" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                   
                </div>
               <div style="overflow: auto; padding-bottom: 10px; width:30px; float: left; text-align: right;
                    padding-top: 11px; padding-left:10px;">
                    <asp:Label ID="Label67" runat="server" Text="To :" ForeColor="Black" Font-Bold></asp:Label>
                </div>
                 <div style=" padding-left: 5px; padding-top: 5px;
                    float: left;">
                    <div style="float: left;">
                        <asp:TextBox ID="txtend" runat="server" CssClass="txtnrml texboxcls" Width="70px"></asp:TextBox>
                    </div>
                    <div style="overflow: auto; float: left; padding-right: 5px">
                        <asp:Image ID="Image9" runat="server" ImageUrl="~/images/calendar.png" />
                    </div>
                    <cc1:CalendarExtender ID="Calendarextender8" runat="server" TargetControlID="txtend"
                        PopupButtonID="Image9" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                  
                </div>
               <div style=" float: left;">
                    <asp:Button ID="btngenexp" runat="server" Text="Generate Report" CssClass="TbleBtns"
                        OnClick="btngenexp_Click" Font-Bold />
                </div>
                 <div style="float: left;">
                 <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                    <ProgressTemplate>
                        <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                </asp:UpdateProgress></div>
            </div>
            
            
            <%--<div style="overflow: auto; padding-bottom: 10px; padding-top: 10px; width: 100%;
                float: left;">
                <div style="overflow: auto; padding-bottom: 10px; width: 20%; float: left; padding-left: 5%">
                </div>
                
            </div>--%>
            <div style="overflow: auto; padding-bottom: 10px; padding-top: 10px; width: 100%;
                float: left;">
          
     
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
