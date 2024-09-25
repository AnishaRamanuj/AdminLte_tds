<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="JobBreakup.aspx.cs" Inherits="Admin_JobBreakup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div id="divtitl" class="totbodycatreg">
     <div class="headerstyle_admin">
     <div class="headerstyle1_admin">
                            <asp:Label ID="Label18" runat="server" Text="BreakUp Details for " CssClass="Head1"></asp:Label>&nbsp;<asp:Label ID="lbljob" runat="server" Text="" CssClass="Head1"></asp:Label>    
                       
                    </div></div>
 <div style="overflow: hidden; padding-bottom: 10px; width: 98%; float: left; padding-left: 20px; padding-top: 5px;margin-top:10px">
                                <asp:GridView ID="Gridtimesheetdetails" runat="server" BorderColor="#55A0FF" BorderStyle="Solid"
                                    BorderWidth="1px" CellPadding="0" CellSpacing="0" AutoGenerateColumns="False"
                                     EmptyDataText="No records found!!!" UseAccessibleHeader="False" 
                                    Width="865px" ShowFooter="true" AllowPaging="True" DataSourceID="SqlDataSource1"
                                    OnPageIndexChanging="Gridtimesheetdetails_PageIndexChanging1" PageSize="8" 
                                    HorizontalAlign="Center" onrowdatabound="Gridtimesheetdetails_RowDataBound"                                 
                                    >
                                    <RowStyle Height="15px" />
                                    <Columns>
                                      <asp:TemplateField HeaderText="SINo" HeaderStyle-CssClass="grdheadermstertime">
                                            <ItemTemplate>
                                            <div class="gridcolstyle1" style="width: 20px;padding-left: 7px;text-align:center">
                                                <asp:Label ID="lblsino" Text='<%# bind("SINo") %>' runat="server"></asp:Label></div>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="griditemstletime" />
                                               <ItemStyle Width="30px" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Date" HeaderStyle-CssClass="grdheadermstertime">
                                            <ItemTemplate>
                                            <div class="gridcolstyle1" style="width: 65px;padding-left: 7px;">
                                                <asp:Label ID="lblweekTime" Text='<%# bind("Date") %>' runat="server"></asp:Label></div>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="griditemstletime" />
                                        </asp:TemplateField>
                                          <asp:TemplateField HeaderStyle-CssClass="grdheadermstertime" HeaderText="Staff">
                                            <ItemTemplate>
                                            <div class="gridcolstyle1" style="width: 110px;padding-left: 5px;">
                                                <asp:Label ID="lblmonthTime" Text='<%# bind("StaffName") %>' runat="server"></asp:Label></div>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="griditemstletime" />
                                        </asp:TemplateField> 
                                        <asp:TemplateField HeaderText="From"> 
                                            <ItemTemplate>
                                             <div class="gridcolstyle1" style="width: 35px;padding-left: 7px;">
                                                <asp:Label ID="jobname" Text='<%# bind("FromTime") %>' runat="server"></asp:Label></div>
                                            </ItemTemplate>                                          
                                            <HeaderStyle CssClass="grdheadermstertime" />
                                            <ItemStyle CssClass="griditemstletime" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="To">
                                            <ItemTemplate>
                                             <div class="gridcolstyle1" style="width: 35px;padding-left: 7px;">
                                                <asp:Label ID="lblName" Text='<%# bind("ToTime") %>' runat="server"></asp:Label></div>
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="grdheadermstertime" />
                                            <ItemStyle CssClass="griditemstletime" />
                                        </asp:TemplateField>
                                        <asp:TemplateField  HeaderText="Total">
                                            <ItemTemplate>
                                            <div class="gridcolstyle1" style="width: 40px;padding-left: 7px;">
                                                <asp:Label ID="lblTodayTime" Text='<%# bind("TotalTime") %>' runat="server"></asp:Label></div>
                                            </ItemTemplate>
                                            <FooterTemplate>
                                            <div class="gridcolstyle1" style="width: 40px;padding-left: 7px;">
                                                <asp:Label ID="lblTotal" runat="server" Font-Bold="True"></asp:Label></div>
                                            </FooterTemplate>
                                            <HeaderStyle CssClass="grdheadermstertime" HorizontalAlign="Center"/>
                                            <ItemStyle CssClass="griditemstletime" />
                                             <FooterStyle HorizontalAlign="Center" />
                                             <FooterStyle CssClass="griditemstletime" />
                                        </asp:TemplateField>
                                      
                                        <asp:TemplateField HeaderStyle-CssClass="grdheadermstertime" HeaderText="Narration">
                                            <ItemTemplate>
                                              <div class="gridcolstyle1" style="width: 300px;padding-left: 7px;text-align:left">
                                                <asp:Label ID="lblnarration" Text='<%# bind("Narration") %>' runat="server"></asp:Label></div>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="griditemstletime" />
                                        </asp:TemplateField>                                                                       
                                    </Columns>
                                </asp:GridView>
                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
                                </asp:SqlDataSource>
                            </div>
  </div>
</asp:Content>

