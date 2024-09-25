<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SecurityPermissionList.ascx.cs" Inherits="controls_SecurityPermissionList" %>


<div id="divtotbody" class="totbodycatreg1" style="overflow:hidden;height:auto;width:890px">
<div id="divtitl">
<div class="headerstyle_admin">
     <div class="headerstyle1_admin">
           <asp:Label ID="Label1" runat="server" Text="Manage Security Permission" 
            CssClass="Head1"></asp:Label></div></div>
<div style="overflow:hidden;padding-bottom: 10px; width: 98%; float: left;padding-left:15px;padding-top:10px;">
        <asp:GridView ID="Grid_Permissions" runat="server" AutoGenerateColumns="False"  BorderColor="#55A0FF"
            Width="100%" DataSourceID="SqlGridSrc" DataKeyNames="SPId" 
               AllowPaging="True"   EmptyDataText="No records found!!!" 
            onrowcommand="Grid_Permissions_RowCommand">
            <RowStyle Height="15px" />
            <Columns>
                <asp:TemplateField HeaderText="Company Name" HeaderStyle-CssClass="grdheadermster">
                    <ItemTemplate>
                        <div class="gridpages" style="padding-left:3px;">
                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("CompanyName") %>'   ></asp:Label>
                                 <asp:Label ID="CompIdlbl" runat="server" CssClass="labelstyle" Visible="false" Text='<%# bind("CompId") %>'   ></asp:Label>
                        </div>
                    </ItemTemplate>                  
<HeaderStyle CssClass="grdheadermster"></HeaderStyle>                  
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-CssClass="grdheadermster" 
                    HeaderText="Schemes">                  
                    <ItemTemplate>
                        <div class="gridpages" style="padding-left:3px;">
                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("Schemes") %>'></asp:Label>
                        </div>
                    </ItemTemplate>

<HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Users" 
                    HeaderStyle-CssClass="grdheadermster">
                    <ItemTemplate>
                        <div class="gridpages" style="padding-right:3px;text-align:right">
                            <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Text='<%# bind("UserCount") %>'
                               ></asp:Label>
                        </div>
                    </ItemTemplate>                  
<HeaderStyle CssClass="grdheadermster"></HeaderStyle>                  
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Staffs">
                    <ItemTemplate>
                        <div class="gridpages" style="padding-right:3px;text-align:right">
                            <asp:Label ID="Label3" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("StaffCount") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="grdheadermster" />
                </asp:TemplateField>
          
                  <asp:TemplateField HeaderText="Space">
                    <ItemTemplate>
                        <div class="gridpages" style="padding-left:3px;">
                            <asp:Label ID="Label6" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("WebSpace") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>  
                </asp:TemplateField>
                  <asp:TemplateField HeaderText="Days">
                    <ItemTemplate>
                        <div class="gridpages" style="padding-right:3px;text-align:right">
                            <asp:Label ID="lblpassword" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("DayCount") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <ItemStyle Width="90px" />
                    <HeaderStyle CssClass="grdheadermster" />
                </asp:TemplateField>  
                  <asp:TemplateField HeaderText="Price">
                    <ItemTemplate>
                        <div class="gridpages" style="padding-right:3px;text-align:right">
                            <asp:Label ID="Labelprice" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("Price","{0:f2}") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>  
                </asp:TemplateField>
                  <asp:TemplateField HeaderText="Version">
                    <ItemTemplate>
                        <div class="gridpages" style="padding-left:3px;">
                            <asp:Label ID="lblversion" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("Version") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <ItemStyle Width="90px" />
                    <HeaderStyle CssClass="grdheadermster" />
                </asp:TemplateField>     
                   <asp:TemplateField HeaderText="">
                    <ItemTemplate>
                      <div style="padding-right:10px;padding-left:10px">
                             <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit_sm1.jpg"
                                                        ToolTip="Edit" CausesValidation="False" 
                                 />
                        </div>
                        
                    </ItemTemplate>
                    <ItemStyle Width="50px" />
                  
                </asp:TemplateField>                                      
            </Columns>
            <HeaderStyle CssClass="grdheadermster" />
        </asp:GridView>
        </div>
</div>   
<div id="div1" class="seperotorrwr"></div>   
<div id="griddiv" class="totbodycatreg">
        <asp:SqlDataSource ID="SqlGridSrc" runat="server" 
            ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="select s.SPId ,s.CompId,c.CompanyName ,s.Schemes ,s.UserCount ,

s.StaffCount ,s.WebSpace ,s.DayCount ,s.Price ,s.Version

  from SecurityPermission as s inner join dbo.Company_Master as c on c.CompId=s.CompId
" 
            ></asp:SqlDataSource>
    </div>
</div>