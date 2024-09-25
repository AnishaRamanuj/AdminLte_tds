<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="ClientGroup_AllStaff.aspx.cs" Inherits="Admin_ClientGroup_AllStaff" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>



<%@ Register src="../controls/MessageControl.ascx" tagname="MessageControl" tagprefix="uc1" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="div1" class="totbodycatreg">
     <div class="headerstyle11"> <div class="headerstyle112">
        <asp:Label ID="Label1" runat="server" Text=" Single ClientGroup-All Clients  Report" CssClass="Head1"></asp:Label></div></div>
    <div style="overflow:auto;width:98%;padding-left:2px;padding-right:5px;">
      <uc1:MessageControl ID="MessageControl1" runat="server" /></div>
  <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>    
      <div style="overflow:auto;padding-bottom: 4px;padding-top:4px; width: 100%; float: left;">
<div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px; padding-top: 5px;">
    <asp:Label ID="Label9" runat="server" Text="Company Name"></asp:Label>
</div>
<div style="overflow:auto;padding-bottom: 10px; width: 58%; float: left;">
    <asp:DropDownList ID="drpcompanylist" runat="server" 
        DataTextField="CompanyName" DataValueField="CompId"
        Width="240px" Height="20px" CssClass="dropstyle" 
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
                    </div>  </div>
 <div style="overflow:auto;padding-bottom: 4px;padding-top:4px; width: 100%; float: left;">
<div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px; padding-top: 5px;">
    <asp:Label ID="lblcltname" runat="server" Text="Client Group"></asp:Label>
</div>
<div style="overflow:auto;padding-bottom: 10px; width: 58%; float: left;">
    <asp:DropDownList ID="DropClientGroup" runat="server"         
        Width="240px" Height="20px" CssClass="dropstyle" 
        AutoPostBack="True" DataTextField="ClientGroupName" DataValueField="CTGId" 
        onselectedindexchanged="DropClientGroup_SelectedIndexChanged">        
    </asp:DropDownList>
    
                    <asp:Label ID="errorlbl1" runat="server" CssClass="errlabelstyle" Text="*"  
                        ForeColor="Red"></asp:Label>                                    
                    </div>         
</div>
<div style="overflow:auto;padding-bottom: 10px;padding-top:10px; width: 100%; float: left;">
<div style="width:420px;float:left;overflow:hidden">
<div style="overflow: auto; padding-bottom:0px; width: 110px; float: left; padding-left: 40px; padding-top: 5px;">
    <asp:Label ID="Label16" runat="server" Text="Client Name"></asp:Label>
</div>
 <div style="overflow:auto;width:200px;height:15px;padding-top: 5px;">
                        <asp:CheckBox ID="chkjob1" runat="server" AutoPostBack="True" 
                            Text=" Check All" oncheckedchanged="chkjob1_CheckedChanged"  />
                    </div> 
<div style="overflow:auto;padding-bottom: 0px; width: 370px;padding-left:40px;float: left;">
<asp:Panel ID="Panel4" runat="server" style="overflow:auto;width:338px;padding-left:10px;float: left;" ScrollBars="Auto" BorderColor="#B6D1FB" Borderstyle="Solid" BorderWidth="1px"  Height="150px">
    <asp:DataList ID="Client_List" runat="server" Width="310px">
                            <ItemTemplate>
                                <div style="overflow:auto;width: 300px; float: left;">
                                      <div style="overflow:auto;width: 30px; float: left;">
                                        <asp:CheckBox ID="chkitem1" runat="server" />
                                    </div>
                                      <div class="dataliststyle">
                                         <asp:Label ID="Label50" runat="server" Text='<%# bind("ClientName") %>'></asp:Label>
                                         <asp:Label ID="Label51" runat="server" Text='<%# bind("CLTId") %>' 
                                             Visible="False"></asp:Label>
                                    </div>
                                </div>
                            </ItemTemplate><ItemStyle Height="17px" />
                        </asp:DataList>
                          <asp:Label ID="Label17" runat="server" CssClass="errlabelstyle"  
        Text="No Clients Found" Font-Bold="True" Visible="False"></asp:Label> 
    </asp:Panel>&nbsp; <asp:Label ID="Label18" runat="server" CssClass="errlabelstyle" ForeColor="Red" 
        Text="*"></asp:Label></div>       
</div></div>
  <div class="row_report">
            <div class="col_lft">
            </div>
            <div style="overflow:auto;padding-bottom: 10px; width: 58%; float: left;">
    <asp:Button ID="btngen"  CssClass="buttonstyle" runat="server" Text="Generate Report" onclick="btngen_Click"  />               
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
<div style="overflow:auto;padding-bottom: 10px;padding-top:10px; width: 100%; float: left;">

</div>
</ContentTemplate>
</asp:UpdatePanel>
</div>
</asp:Content>

