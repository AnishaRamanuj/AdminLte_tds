<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Clientgroup_Budget_Actual.ascx.cs" Inherits="controls_Clientgroup_Budget_Actual" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
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
   
           <div class="headerstyle1_page">
        <asp:Label ID="Label1" runat="server" 
                    Text="Client/Jobwise Budget cost Vs Actual" CssClass="Head1" 
                   ></asp:Label>
    </div>



    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
             <div style="overflow:auto;width:98%;padding-left:5px; padding-right:5px; float:left;">
                <uc2:MessageControl ID="MessageControl2" runat="server" />
            </div>
          
          <div style="overflow: auto; padding-bottom: 4px; padding-top: 4px; width: 100%; float: left;">
                <div style="width: 370px; float: left; overflow: hidden">
                    <div style="overflow: auto; padding-bottom: 0px; width: 120px; float: left;
                        padding-top: 5px; height: 28px;">
                        <asp:Label ID="Label3" runat="server" Text="Client Name" ForeColor="Black" 
                            Font-Bold="True" Font-Italic="False" Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                    </div>
                    <div style="overflow: auto; width: 200px; height: 27px; padding-left: 5px; padding-top: 5px;">
                       <asp:CheckBox ID="chkbudcl" runat="server" AutoPostBack="True" Text=" Check All"
                        OnCheckedChanged="chkbudcl_CheckedChanged" ForeColor="Black" Font-Bold="True" 
                            Font-Names="Verdana" Font-Size="9pt" />
                    </div>
                    <div style="overflow: auto; padding-bottom: 0px; width: 370px;
                        float: left;">
                       <asp:Panel ID="Panel7"  runat="server" style="width:340px;padding-left:10px;float: left;" ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"  Height="150px">
                        <asp:DataList ID="dlbudclient" runat="server" Width="330px" ForeColor="Black" 
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
                        <asp:Label ID="Label42" runat="server" CssClass="errlabelstyle" Text="No Clients Found"
                            Font-Bold="True" Visible="False" Font-Names="Verdana" Font-Size="8pt"></asp:Label>
                    </asp:Panel>
                      
                    </div>
                </div>
                <div style="width: 450px; float: left; overflow: hidden">
                    <div style="overflow: auto; padding-bottom: 0px; width: 170px; float: left;
                        padding-top: 5px; height: 28px;">
                        <asp:Label ID="Label2" runat="server" Text="Job Name" ForeColor="Black" 
                            Font-Bold="True" Font-Italic="False" Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                    </div>
                    <div style="overflow: auto; width: 140px; height: 22px; padding-left: 5px; padding-top: 5px;">
                       <span style="font-weight:bold;"> <asp:CheckBox ID="chkbudjob" runat="server" AutoPostBack="True" Text=" Check All"
                        OnCheckedChanged="chkbudjob_CheckedChanged" ForeColor="Black" Font-Names="Verdana" 
                                               Font-Size="9pt" /></span>
                    </div>
                    <div style="overflow: auto; padding-bottom: 0px; width: 380px; float: left;">
                         <asp:Panel ID="Panel8"  runat="server" style="width:340px;padding-left:10px;float: left;" ScrollBars="Auto" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"  Height="150px">
                        <asp:DataList ID="dlbudjob" runat="server" Width="300px" ForeColor="Black" 
                                 Font-Names="Verdana" Font-Size="8pt" Height="117px">
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
                        <asp:Label ID="Label45" runat="server" CssClass="errlabelstyle" Text="No Jobs Found"
                            Font-Bold="True" Visible="False" Font-Names="Verdana" Font-Size="8pt"></asp:Label>
                    </asp:Panel>
                      
                    </div>
                </div>
            </div>
          
          <div style="overflow: hidden; padding-bottom: 4px; padding-top: 4px; width: 100%;
                float: left;">
               <div style="overflow: auto; padding-bottom: 10px; font-weight:bold; float: left; padding-top: 10px;">
                    <asp:Label ID="Label65" runat="server" Text="From : " ForeColor="Black"></asp:Label>
                </div>
               <div style=" padding-left: 5px; padding-top: 5px;float: left;">
                    <div style="overflow: auto; float: left;">
                       <asp:TextBox ID="txtfrmdt" runat="server" CssClass="texboxcls txtnrml" Width="70px"></asp:TextBox></div>
                    <div style="float: left;">
                        <asp:Image ID="Image18" runat="server" ImageUrl="~/images/calendar.png" /></div>
                <cc1:CalendarExtender ID="Calendarextender5" runat="server" TargetControlID="txtfrmdt"
                        PopupButtonID="Image18" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                 
                </div>
                 <div style="overflow: auto;  width: 29px; font-weight:bold; float: left; text-align: right;
                    padding-top: 10px;  padding-left: 20px;">
                    <asp:Label ID="Label67" runat="server" Text="To : " ForeColor="Black"></asp:Label>
                </div>
              <div style="padding-left: 5px; padding-top: 5px;
                    float: left;">
                    <div style="overflow: auto; float: left;">
                       <asp:TextBox ID="txttodt" runat="server" CssClass="txtnrml texboxcls" Width="70px"></asp:TextBox></div>
                     <div style="overflow: auto; float: left; padding-right: 5px">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/calendar.png" /></div>
                  <cc1:CalendarExtender ID="Calendarextender6" runat="server" TargetControlID="txttodt"
                        PopupButtonID="Image1" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                   
                </div>

                 <div style=" width: 178px; height: 25px; padding-left: 55px; padding-top: 5px;
                    float: left; text-align: left;">
                     <asp:CheckBox ID="CheckBox1" runat="server" AutoPostBack="True" Text=" Format 2"
                        ForeColor="Black" Font-Bold="False" OnCheckedChanged="chkcl_CheckedChanged"
                            Font-Names="Verdana" Font-Size="9pt" />
                            &nbsp;<%--<asp:Label ID="Label55" runat="server" CssClass="errlabelstyle" 
                         ForeColor="Red" Text="*"></asp:Label>--%>
                            </div>
                 

	<div style="  float: left; width: 100%;">
                     <asp:RadioButtonList ID="RadioButtonList1" runat="server" 
                      ForeColor="Black" Font-Bold="False" Font-Names="Verdana" Font-Size="9pt"
                RepeatDirection="Horizontal" AutoPostBack="true" Height="22px" 
                                    onselectedindexchanged="RadioButtonList1_SelectedIndexChanged" Width="410px">                              
                                <asp:ListItem Text=" Clientwise Details" Value="0"></asp:ListItem>
                                <asp:ListItem Text=" Staffwise Details" Value="1"></asp:ListItem>
                                <asp:ListItem Text=" Expense Details" Value="2"></asp:ListItem>
                                
                                </asp:RadioButtonList>
                                <span style="display:none;"><asp:Label ID="Label4" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label></span>
                </div>


                <div style="float: left; text-align: left; margin-top:10px;">
                    <asp:Button ID="btngrnreport" runat="server" CssClass="TbleBtns" 
                        Text="Generate Report" OnClick="btngrnreport_Click"/>
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
