<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Client_AlljobsHoursConsumedDay.ascx.cs" Inherits="controls_Client_AlljobsHoursConsumedDay" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register src="MessageControl.ascx" tagname="MessageControl" tagprefix="uc2" %>
<script language="javascript" type="text/javascript">
    function pad2(number)
     {
    return (number < 10 ? '0' : '') + number
   }
        function checkForm() {
        
            // regular expression to match required date format
            var dt = new Date();
            var day = dt.getDate();
            var mon =dt.getMonth() + 1;
            var yr = dt.getFullYear();
            var pin = document.getElementById("<%= fromdate.ClientID%>").value;
            if (pin != '' && !pin.match(/^((0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%=fromdate.ClientID%>").focus();
                var month=pad2(mon);
                document.getElementById("<%=fromdate.ClientID%>").value = month+"/"+yr ;
                return false;
            }
        }
        
       </script>
<div id="divtitl" class="totbodycatreg" style="overflow: hidden;">
    
 <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px; width:1190px;">
            <asp:Label ID="Label3" runat="server" Text="All Jobs - Hours Consumed In a Day Report" CssClass="Head1 labelChange"></asp:Label></div>


    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="msg_container">
                <uc2:MessageControl ID="MessageControl2" runat="server" />
            </div>
             <table class="row_report" style="width:750px; padding-left:55px; padding-top:15px;">
             <tr>
             <td><asp:Label ID="Label2" runat="server" Font-Bold="true" Text="Client Name" ForeColor="Black" CssClass="labelChange"></asp:Label></td>
             <td> <asp:DropDownList ID="drpclient" runat="server" CssClass="stf_drop texboxclsselectnew" DataTextField="ClientName"
                        DataValueField="CLTId"   AppendDataBoundItems="True">
                        <asp:ListItem Value="0">--Select--</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Label ID="Label55" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label></td>
              <td style="font-weight:bold; font-size:small;">From :</td>
             <td><asp:TextBox ID="fromdate" runat="server" CssClass="txtnrml texboxcls" Width="70px"></asp:TextBox><div style="overflow: auto; padding-top: 10px 0px 0px 0px; float: right;">
                        <asp:Image ID="Image18" runat="server" ImageUrl="~/images/calendar.png" />
                    </div>
                    
                    <cc1:CalendarExtender ID="fromdate_CalendarExtender" runat="server" TargetControlID="fromdate"
                        PopupButtonID="Image18" Format="MM/yyyy">
                    </cc1:CalendarExtender></td>
             <td><asp:Button ID="btngenerate" runat="server" Text="Generate Report" CssClass="TbleBtns"
                        OnClick="btngenerate_Click" /></td>
             </tr></table>
            
           
           <%-- <div class="row_report">
                <div class="col_lft">
                    <asp:Label ID="Label6" runat="server" Text="To"></asp:Label>
                </div>
                <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
                    <div style="overflow: auto; float: left;">
                        <asp:TextBox ID="txtenddate" runat="server" CssClass="txtnrml texboxcls" Width="70px"></asp:TextBox>
                    </div>
                    <div style="overflow: auto; padding-top: 10px 0px 0px 0px; float: left;">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" />
                    </div>
                    <div style="overflow: auto; padding-left: 5px; float: left;">
                        <asp:Label ID="Label46" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                    </div>
                    <cc1:CalendarExtender ID="txtenddate_Calendarextender1" runat="server" TargetControlID="txtenddate"
                        PopupButtonID="Image1" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                </div>
            </div>--%>
            <div class="row_report">
                
                <div style="overflow: auto; padding-bottom: 10px; float: left;">
                    
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
