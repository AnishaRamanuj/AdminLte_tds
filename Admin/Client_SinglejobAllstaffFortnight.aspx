<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="Client_SinglejobAllstaffFortnight.aspx.cs" Inherits="Admin_Client_SinglejobAllstaffFortnight"  %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<%@ Register src="../controls/MessageControl.ascx" tagname="MessageControl" tagprefix="uc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
            var pin = document.getElementById("<%=txtenddate2.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%=txtenddate2.ClientID%>").focus();
                var month=pad2(mon);
                document.getElementById("<%=txtenddate2.ClientID%>").value =month+"/"+yr ;
                return false;
            }
        }
         
       </script>
    <div id="div1" class="totbodycatreg">
        <div class="headerstyle11">
            <div class="headerstyle112">
              <asp:Label ID="Label3" runat="server" Text="Single Jobs - All Staff - All Expenses Report" CssClass="Head1"></asp:Label>    
            </div>
        </div>
        <div style="overflow:auto;width:98%;padding-left:5px;padding-right:5px">
  <uc1:MessageControl ID="MessageControl1" runat="server" /></div>
 <div class="row_report">
<div class="rowinnerstyle1">
    <asp:Label ID="Label9" runat="server" Text="Company Name"></asp:Label>
</div>
<div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
    <asp:DropDownList ID="drpcompanylist" runat="server" 
        DataTextField="CompanyName" DataValueField="CompId" CssClass="dropstyle"
        Width="240px"  Height="20px"
        AutoPostBack="True" onselectedindexchanged="drpcompanylist_SelectedIndexChanged"          
        AppendDataBoundItems="True" DataSourceID="SqlDropSrc">
        <asp:ListItem Value="0">--Select--</asp:ListItem>
    </asp:DropDownList>
    
                    <asp:Label ID="Label10" runat="server" CssClass="errlabelstyle" Text="*"  
                        ForeColor="Red"></asp:Label>
                     <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                 <ProgressTemplate>
                            <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                    </asp:UpdateProgress>
                    <asp:SqlDataSource ID="SqlDropSrc" runat="server" 
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
        SelectCommand="select CompId,CompanyName from dbo.Company_Master order by CompanyName">
    </asp:SqlDataSource>
                    </div>  
</div>
 <div class="row_report">
<div class="rowinnerstyle1">
    <asp:Label ID="lblcltname" runat="server" Text="Client Name"></asp:Label>
</div>
<div style="overflow:auto;padding-bottom: 10px; width: 58%; float: left;">
    <asp:DropDownList ID="DropClient" runat="server"  CssClass="dropstyle" Width="240px"  Height="20px"
        AutoPostBack="True" DataTextField="ClientName" DataValueField="CLTId" >        
    </asp:DropDownList>
                    <asp:Label ID="errorlbl1" runat="server" CssClass="errlabelstyle" Text="*"  
                        ForeColor="Red"></asp:Label>                                  
                    </div>        
</div>
 <div class="row_report">
<div class="rowinnerstyle1">
    <asp:Label ID="Label16" runat="server" Text="Job Name"></asp:Label>
</div>
 <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
                        <asp:DropDownList ID="DropJob" runat="server" DataTextField="JobName" CssClass="dropstyle"
                            DataValueField="JobId"  Width="240px"  Height="20px">
                        </asp:DropDownList>
        <asp:Label ID="Label18" runat="server" CssClass="errlabelstyle" ForeColor="Red" 
        Text="*"></asp:Label>
    
                    </div>                      
</div>
 <div class="row_report">
<div class="rowinnerstyle1" style="padding-top:0px;">
    <asp:Label ID="Label21" runat="server" Text="To"></asp:Label>
</div>
<div style="overflow:auto;padding-bottom: 10px; width: 58%; float: left;">
   <div class="txtcal">  <asp:TextBox ID="txtenddate2" runat="server" CssClass="txtnrml"  Width="70px"></asp:TextBox></div>
          <div class="imagecal">       <asp:Image ID="Image3" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                    <cc1:calendarextender ID="Calendarextender2" 
         runat="server" TargetControlID="txtenddate2"
                        PopupButtonID="Image3" Format="MM/yyyy"></cc1:calendarextender>
    
                    <asp:Label ID="Label22" runat="server" CssClass="errlabelstyle" Text="*"  
                        ForeColor="Red"></asp:Label>
    
                    </div>     
</div>
 <div class="row_report">
<div style="overflow:auto;padding-bottom: 10px; width: 58%; float: left;padding-left:150px;">
    <asp:Button ID="btngen"  CssClass="buttonstyle" runat="server" Text="Generate Report" onclick="btngen_Click" 
         />               
    
                    </div>     
</div>
   <div class="footer_repeat">
                    Notes:
                </div>
                <div class="reapeatItem_client">
                    <div id="msghead" class="totbodycatreg" style="overflow: auto; padding-left: 5px">
                        <span class="labelstyle" style="overflow: auto; color: Red; font-size: smaller;">Fields
                            marked with * are required</span>
                    </div>
                </div>
<div style="overflow:auto;padding-bottom: 10px;padding-top:10px; width: 100%; float: left;">

</div>
</div>
</asp:Content>

