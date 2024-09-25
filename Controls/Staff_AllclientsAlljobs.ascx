<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Staff_AllclientsAlljobs.ascx.cs" Inherits="controls_Staff_AllclientsAlljobs" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
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
            var pin = document.getElementById("<%=fromdate.ClientID%>").value;
            if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%= fromdate.ClientID%>").focus();
                var month=pad2(mon);
                var days=pad2(day);
                document.getElementById("<%= fromdate.ClientID%>").value =days+"/"+month+"/"+yr ;
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
<div id="div1" class="totbodycatreg">
    <div style="width: 903px; float: left;">
        <div style="width: 30px; float: left; overflow: hidden">
        </div>
        <div class="headerstyle11">
	 <div class="headerstyle1_page">
                <asp:Label ID="Label2" runat="server" Text="All Clients - All Jobs Reports" 
                    CssClass="Head1"></asp:Label></div>
       </div>
    </div>
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <div style="width:100%;">
                <uc1:MessageControl ID="MessageControl1" runat="server" />
            </div>

            <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; width: 100%; float: left;">
                <div style="width: 270px; float: left; overflow: hidden">
			  <div style="margin:5px 0 0px; display:inline-block; width:200px; height:26px;">
                   <div style="overflow: auto; padding-bottom: 0px; width: 110px; float: left; 
                        padding-top: 5px;">
                        <asp:Label ID="Label91" runat="server" Text="Client Name" ForeColor="Black" 
                            Font-Bold="True" Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                    </div>
                    <div style="font-weight:bold;margin-top: 3px; ">
                        <asp:CheckBox ID="chkclient" runat="server" AutoPostBack="True" Text=" Check All"
                            OnCheckedChanged="chkclient_CheckedChanged" ForeColor="Black" 
                            Font-Names="Verdana" Font-Size="9pt" />
                    </div>
  </div>


                    <div style="overflow: auto; padding-bottom: 0px; width: 260px; float: left;">
                         <asp:Panel ID="Panel1" runat="server" class="panel_style" ScrollBars="Auto" BorderColor="#CCCCCC"
                            BorderStyle="Solid" BorderWidth="1px" Height="150px">
                            <asp:DataList ID="dlclientlist" runat="server" Width="250px" ForeColor="Black" 
                                Font-Names="Verdana" Font-Size="8pt">
                                <ItemTemplate>
                                    <div style="overflow: auto; width: 250px; float: left;">
                                        <div style="overflow: auto; width: 30px; float: left;">
                                            <asp:CheckBox ID="chkitem" runat="server" AutoPostBack="true"  
                                                oncheckedchanged="chkitem_CheckedChanged" />
                                        </div>
                                        <div class="dataliststyle">
                                            <asp:Label ID="Label50" runat="server" Text='<%# bind("ClientName") %>'></asp:Label>
                                            <asp:Label ID="Label51" runat="server" Text='<%# bind("CLTId") %>' Visible="False"></asp:Label>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle Height="17px" />
                            </asp:DataList>
                            <asp:Label ID="Label14" runat="server" CssClass="errlabelstyle" Text="No Clients Found"
                                Font-Bold="True" Visible="False" Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                        </asp:Panel>
                     
                    </div>
                </div>


                <div style="width: 290px; float: left; overflow: hidden">

	 <div style="margin:5px 0 0;  display:inline-block; width:250px; height:26px;">
                    <div style="overflow: auto; padding-bottom: 0px; width: 110px; float: left; padding-left:0px;
                        padding-top: 5px; ">
                        <asp:Label ID="Label11" runat="server" Text="Job Name" ForeColor="Black" 
                            Font-Bold="True" Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                    </div>
                    <div style="overflow: auto;padding-left: 5px; padding-top: 5px; font-weight:bold;">
                        <asp:CheckBox ID="chkjob" runat="server" AutoPostBack="True" OnCheckedChanged="chkjob_CheckedChanged"
                            Text=" Check All" ForeColor="Black" Font-Names="Verdana" Font-Size="9pt" />
                    </div>
 </div>


                    <div style="overflow: auto; padding-bottom: 0px; width: 280px; padding-left: 0px;
                        float: left;">
                        <asp:Panel ID="Panel2" runat="server" class="panel_style" ScrollBars="Auto" BorderColor="#CCCCCC"
                            BorderStyle="Solid" BorderWidth="1px" Height="150px">
                            <asp:DataList ID="DataList2" runat="server" Width="250px" ForeColor="Black" 
                                Font-Names="Verdana" Font-Size="8pt">
                                <ItemTemplate>
                                    <div style="overflow: auto; width: 250px; float: left;">
                                        <div style="overflow: auto; width: 30px; float: left;">
                                            <asp:CheckBox ID="chkitem1" runat="server" AutoPostBack="true"
                                                oncheckedchanged="chkitem1_CheckedChanged" />
                                        </div>
                                        <div class="dataliststyle">
                                            <asp:Label ID="Label50" runat="server" Text='<%# bind("mJobName") %>'></asp:Label>
                                            <asp:Label ID="Label51" runat="server" Text='<%# bind("mJobId") %>' Visible="False"></asp:Label>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle Height="17px" />
                            </asp:DataList>
                            <asp:Label ID="Label1" runat="server" CssClass="errlabelstyle" Text="No Jobs Found"
                                Font-Bold="True" Visible="False" Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                        </asp:Panel>
                        &nbsp;
                        <asp:Label ID="Label16" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                    </div>
                    
                </div>
                
                
           



            
            <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; width: 300px; float: left;">
		
			

                    <div style="overflow: auto; padding-bottom: 0px; width: 300px; 
                        float: left;">

 <div style="margin:0px; display:inline-block; width:300px; height:26px;">
                    <div style="overflow: auto; padding-bottom: 0px; width: 110px; float: left; 
                        padding-top: 5px;">
                        <asp:Label ID="Label3" runat="server" Text="Staff Name" ForeColor="Black" 
                            Font-Bold="True" Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                    </div>
                    <div style="overflow: auto;padding-left: 5px;">
                        <strong><asp:CheckBox ID="ChkST" runat="server" AutoPostBack="True" 
                            Text=" Check All" ForeColor="Black" Font-Names="Verdana" Font-Size="9pt" 
                            oncheckedchanged="ChkST_CheckedChanged" /></strong>
                    </div>
			</div>

                        <asp:Panel ID="Panel3" runat="server" class="panel_style" ScrollBars="Auto" BorderColor="#CCCCCC"
                            BorderStyle="Solid" BorderWidth="1px" Height="150px">
                            <asp:DataList ID="DTStaffLST" runat="server" Width="250px" ForeColor="Black" 
                                Font-Names="Verdana" Font-Size="8pt">
                                <ItemTemplate>
                                    <div style="overflow: auto; width: 250px; float: left;">
                                        <div style="overflow: auto; width: 30px; float: left;">
                                            <asp:CheckBox ID="chkitem1" runat="server" AutoPostBack="true"/>
                                        </div>
                                        <div class="dataliststyle">
                                            <asp:Label ID="Label50" runat="server" Text='<%# bind("StaffName") %>'></asp:Label>
                                            <asp:Label ID="Label51" runat="server" Text='<%# bind("StaffCode") %>' Visible="False"></asp:Label>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle Height="17px" />
                            </asp:DataList>
                            <asp:Label ID="Label4" runat="server" CssClass="errlabelstyle" Text="No Staff Found"
                                Font-Bold="True" Visible="False" Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                        </asp:Panel>
                        &nbsp;
                        <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                    </div>

            </div>      

 </div>      
            
            <div style=" padding-bottom: 4px; padding-top: 4px; width: 100%;
                float: left;">
                <div style="overflow: auto; padding-bottom: 0; float: left;font-weight:bold;
                    padding-top: 11px;">
                    <asp:Label ID="Label17" runat="server" Text="From 	:" ForeColor="Black" 
                        Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                </div>
                <div style=" height: 20px; padding-left: 5px; padding-top: 5px;
                    float: left;">
                    <div style=" float: left;">
                        <asp:TextBox ID="fromdate" runat="server" CssClass="texboxcls texboxclsnew" ></asp:TextBox></div>
                    <div style="float: left; padding-right: 5px">
                        <asp:Image ID="Image18" runat="server" ImageUrl="~/images/calendar.png" 
                                                style="float: right; margin-right: 10px;" /></div>
                    <cc1:CalendarExtender ID="fromdate_CalendarExtender" runat="server" TargetControlID="fromdate"
                        PopupButtonID="Image18" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                    <asp:Label ID="Label52" runat="server" CssClass="errlabelstyle" Text="" ForeColor="Red"></asp:Label>
                </div>
                <div style="overflow: auto; padding-bottom:0; width:28px; float: left; text-align: right;font-weight:bold;
                    padding-top: 10px;">
                    <asp:Label ID="Label19" runat="server" Text="To :" ForeColor="Black" 
                        Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                </div>
                <div style=" height: 20px; padding-left: 5px; padding-top: 5px;
                    float: left;">
                    <div style=" float: left;">
                        <asp:TextBox ID="txtenddate" runat="server" CssClass="texboxcls texboxclsnew"></asp:TextBox></div>
                    <div style="overflow: auto; float: left; padding-right: 5px">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/calendar.png" 
                                                style="float: right; margin-right: 10px;" /></div>
                    <cc1:CalendarExtender ID="txtenddate_Calendarextender1" runat="server" TargetControlID="txtenddate"
                        PopupButtonID="Image1" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                    <asp:Label ID="Label46" runat="server" CssClass="errlabelstyle" Text="" ForeColor="Red"></asp:Label>
                </div>
                <div style="float: left;">
                    <asp:Button ID="btngenerate" runat="server" OnClick="btngenerate_Click" CssClass="TbleBtns"
                        Text="Generate Report" />
                </div>
            </div>
            <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; width: 100%; float: left;">
                <div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px;
                    padding-top: 5px;">
                </div>
                <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;padding-left:150px;">
                 <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel2" runat="server">
                    <ProgressTemplate>
                        <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                </asp:UpdateProgress></div>
            </div>
           
       
        </ContentTemplate>
    </asp:UpdatePanel>
</div>
