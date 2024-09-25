<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="AllJobs.aspx.cs" Inherits="Admin_AllJobs" %>

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
    <div id="divtotbody" class="stf_body" style="overflow:auto;height:auto;padding-bottom:30px;">
       
       <div class="h_outer">
            <div class="h_inner">
                <div class="headerstyle112">
                     <asp:Label ID="Label3" runat="server" Text="All Jobs Report" CssClass="Head1"></asp:Label> 
                    
                    </div>
            </div>
            <br />                      
        </div>        
        <div class="mbox_top">
         <uc1:MessageControl ID="MessageControl1" runat="server" />
        </div>
       
       
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
          <ContentTemplate>
           <div style="overflow:auto;width:99%;padding-left:5px">    
</div>
        <div id="divtitl" class="totbodycatreg">   
        <div class="row_report">
<div class="col_lft">
    <asp:Label ID="Label9" runat="server" Text="Company Name"></asp:Label>
</div>
<div class="col_rht">
    <asp:DropDownList ID="drpcompanylist" runat="server" DataTextField="CompanyName" DataValueField="CompId"
       CssClass="stf_drop" 
        AutoPostBack="True" onselectedindexchanged="drpcompanylist_SelectedIndexChanged"          
        AppendDataBoundItems="True">
        <asp:ListItem Value="0">--Select--</asp:ListItem>
    </asp:DropDownList>
    
                    <asp:Label ID="Label10" runat="server" CssClass="errlabelstyle" Text="*"  
                        ForeColor="Red"></asp:Label>
                            <asp:UpdateProgress ID="UpdateProgress2" AssociatedUpdatePanelID="UpdatePanel1" runat="server">
                 <ProgressTemplate>
                            <img alt="loadting" src="../images/progress-indicator.gif" /></ProgressTemplate>
                    </asp:UpdateProgress>
                    </div>     
</div>   
<div class="row_report">
<div class="col_lft">
    <asp:Label ID="Label2" runat="server" Text="Staff Name"></asp:Label>
</div>
<div class="col_rht">
    <asp:DropDownList ID="drpstafflist" runat="server" DataTextField="StaffName" DataValueField="StaffCode"
     CssClass="stf_drop" 
        AutoPostBack="True"           
        AppendDataBoundItems="True">
        <asp:ListItem Value="0">--Select--</asp:ListItem>
    </asp:DropDownList>
    
                    <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle" Text="*"  
                        ForeColor="Red"></asp:Label>
                    </div>     
</div>            
            <div class="row_report">
              <div style="width: 420px; float: left; overflow: hidden">
               <div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px;">
                    <asp:Label ID="Label4" runat="server" Text="Job Name"></asp:Label>
                </div>
               <div style="overflow: auto; width: 200px; height: 15px; padding-top: 5px;">
                    <asp:CheckBox ID="chkjob" runat="server" AutoPostBack="True" 
                        oncheckedchanged="chkjob_CheckedChanged" Text=" Check All" />
                        </div>
                     <div style="overflow: auto; padding-bottom: 0px; width:370px;float: left; padding-left:40px;">
                    <asp:Panel ID="Panel2" runat="server" ScrollBars="Auto" 
                        CssClass="stf_lBox">
                        <asp:DataList ID="DataList2" runat="server" Width="310px">
                            <ItemTemplate>
                                <div style="overflow:auto;width: 300px; float: left;">
                                    <div style="overflow:auto;width: 30px; float: left;">
                                        <asp:CheckBox ID="chkitem1" runat="server" />
                                    </div>
                                    <div class="stf_lBox_inner">
                                        <asp:Label ID="Label50" runat="server" Text='<%# bind("JobName") %>'></asp:Label>
                                        <asp:Label ID="Label51" runat="server" Text='<%# bind("JobId") %>' 
                                            Visible="False"></asp:Label>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <ItemStyle Height="17px" />
                        </asp:DataList>
                        <asp:Label ID="Label1" runat="server" CssClass="errlabelstyle" Font-Bold="True" 
                            Text="No Jobs Found" Visible="false"></asp:Label>
                    </asp:Panel>  &nbsp;<asp:Label ID="Label53" runat="server" CssClass="errlabelstyle" ForeColor="Red" 
                        Text="*"></asp:Label>
                </div>
                 </div>     
            </div>
            <div class="row_report">
               <div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px;
                    padding-top: 5px;">
                    <asp:Label ID="Label5" runat="server" Text="From"></asp:Label>
                </div>
                   <div style="overflow: hidden; width: 110px; height: 20px; padding-left: 5px; padding-top: 5px;
                    float: left;">
                     <div style="overflow:auto;float: left;"> <asp:TextBox ID="fromdate" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox></div>
                    <div style="overflow:auto;padding-top: 10px 0px 0px 0px; float: left;"><asp:Image ID="Image18" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                    <cc1:calendarextender id="fromdate_CalendarExtender" runat="server" 
                        format="dd/MM/yyyy" popupbuttonid="Image18" targetcontrolid="fromdate">
                    </cc1:calendarextender>
                     <div style="overflow:auto;padding-left: 5px; float: left;"> <asp:Label ID="Label52" runat="server" CssClass="errlabelstyle" ForeColor="Red" 
                        Text="*"></asp:Label></div>
                </div>                   
               <div style="overflow: auto; padding-bottom: 10px; width: 25px; float: left; text-align: right;
                    padding-top: 5px;">
                    <asp:Label ID="Label6" runat="server" Text="To"></asp:Label>
                </div>
                 <div style="overflow: hidden; width: 110px; height: 20px; padding-left: 5px; padding-top: 5px;
                    float: left;">
                     <div style="overflow:auto;float: left;"> <asp:TextBox ID="txtenddate" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox></div>
                    <div style="overflow:auto;padding-top: 10px 0px 0px 0px;padding-right:4px;float: left;"><asp:Image ID="Image1" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                    <cc1:calendarextender id="txtenddate_Calendarextender1" runat="server" 
                        format="dd/MM/yyyy" popupbuttonid="Image1" targetcontrolid="txtenddate">
                    </cc1:calendarextender>
                     &nbsp;<asp:Label ID="Label46" runat="server" CssClass="errlabelstyle" ForeColor="Red" 
                        Text="*"></asp:Label>
                </div>
            </div>
            <div class="row_report">
                <div class="col_lft">
                </div>
                <div class="col_rht">
                    <asp:Button ID="btngenerate" runat="server" onclick="btngenerate_Click" CssClass="buttonstyle"
                        Text="Generate Report" />
                </div>
            </div>
            <div class="row_report">
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

