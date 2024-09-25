<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="ad_jobdetails.aspx.cs" Inherits="Admin_ad_jobdetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="divtotbody" class="totbodycatreg1" style="width:880px;padding-left:10px;height:auto">
    <asp:MultiView ID="JobView" runat="server">
        <asp:View ID="View1" runat="server">
            <div style="border-bottom:1px solid #55A0FF;margin-bottom:10px;">
                <asp:Label ID="Label1" runat="server" CssClass="Head1" Text="Job List"></asp:Label>
            </div>
        <%--    <div style="padding-bottom: 3px; width: 100%; float: left; text-align:right;">
                <a href="javascript: history.go(-1)" 
                    style="font-family:Arial, Helvetica, sans-serif;color:#279BC0; font-size:11px; font-weight:bold; text-decoration:none;">
                Back</a>
            </div>--%>
            <div style="padding-bottom: 10px; width: 100%; float: left;">
                <asp:SqlDataSource ID="SqlStaffSrc" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" >
                   
                </asp:SqlDataSource>
                <asp:GridView ID="Griddealers" runat="server" AllowPaging="True" BorderColor="#55A0FF"
                    AutoGenerateColumns="False" DataKeyNames="StaffCode" DataSourceID="SqlStaffSrc" 
                    Width="100%" EmptyDataText="No records found!!!" 
                    onpageindexchanging="Griddealers_PageIndexChanging">
                   <RowStyle Height="15px" />
                    <Columns>
                        <asp:TemplateField HeaderStyle-CssClass="gridhaedstyle" HeaderText="jobid" 
                            Visible="False">
                            <ItemTemplate>
                                <div class="gridcolstyle">
                                    <asp:Label ID="lblfid" runat="server" CssClass="labelstyle"
                                        Text='<%# bind("JobId") %>' ></asp:Label>
                                </div>
                            </ItemTemplate>
                         <HeaderStyle CssClass="grdheadermster"></HeaderStyle>     
                        </asp:TemplateField>
                        <asp:TemplateField HeaderStyle-CssClass="gridhaedstyle" HeaderText="SINo">
                            <ItemTemplate>
                                <div class="gridcolstyle" style="width:20px;text-align:center">
                                    <asp:Label ID="Label2" runat="server" CssClass="labelstyle" 
                                        Text='<%# bind("sino") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                           <HeaderStyle CssClass="grdheadermster"></HeaderStyle>     
                        </asp:TemplateField>
                        <asp:TemplateField HeaderStyle-CssClass="gridhaedstyle" HeaderText="Job Name">
                            <ItemTemplate>
                                <div class="gridcolstyle" style="width:497px;padding-left:3px;">
                                    <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" 
                                        Text='<%# bind("JobName") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                         <HeaderStyle CssClass="grdheadermster"></HeaderStyle>     
                        </asp:TemplateField>
                        <asp:TemplateField HeaderStyle-CssClass="gridhaedstyle" HeaderText="Job Group">
                            <ItemTemplate>
                                <div class="gridcolstyle" style="width:97px;padding-left:3px;">
                                    <asp:Label ID="lbldepname" runat="server" CssClass="labelstyle" 
                                        Text='<%# bind("jobgroup") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                             <ItemStyle Width="110px" />
                           <HeaderStyle CssClass="grdheadermster"></HeaderStyle>     
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Job Status">
                            <ItemTemplate>
                                <div class="gridcolstyle" style="width:87px;padding-left:3px;">
                                    <asp:Label ID="Label6" runat="server" CssClass="labelstyle" 
                                        Text='<%# bind("Jobstatus") %>'></asp:Label>
                                </div>
                            </ItemTemplate>
                             <ItemStyle Width="100px" />
                             <HeaderStyle CssClass="grdheadermster"></HeaderStyle>     
                        </asp:TemplateField>
                          <asp:TemplateField HeaderText="Job Start Date">
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:77px;padding-left:3px;">
                            <asp:Label ID="lblpassword" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("CreationDate") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <ItemStyle Width="90px" />
                  <HeaderStyle CssClass="grdheadermster"></HeaderStyle>     
                </asp:TemplateField>
                        <%--<asp:TemplateField HeaderText="Profile">
                            <ItemTemplate>
                                <div class="gridcolstyle">
                                    <asp:LinkButton ID="lnkview" runat="server" 
                                        CommandArgument='<%# bind("StaffCode") %>' CssClass="grdLinks" 
                                        onclick="lnkview_Click">View</asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                    </Columns>
                  <HeaderStyle CssClass="grdheadermster"></HeaderStyle>     
                </asp:GridView>
            </div>
        </asp:View>
        <asp:View ID="View2" runat="server">
            <div style="width:95%">
                <div id="totbdy" class="totbodycatreg">
                    <div id="haederstyle" style="border-bottom:1px solid #1964AD;margin-bottom:10px;">
                        <asp:Label ID="Label22" runat="server" CssClass="Head1" Text="Staff Profile"></asp:Label>
                    </div>
                  <%--  <div style="padding-bottom: 3px; width: 100%; float: left; text-align:right;">
                        <a href="javascript: history.go(-1)" 
                            style="width:95%; font-family:Arial, Helvetica, sans-serif;color:#279BC0; font-size:11px; font-weight:bold; text-decoration:none;">
                        Back</a>
                    </div>--%>
                    
                    <div ID="Div81" class="seperotorrwr">
                    </div>
                    <div ID="contactdiv" class="insidetot">
                        <div class="cont_fieldset">
                            <div ID="Div77" class="seperotorrwr">
                            </div>
                            <div ID="insidrw1" class="comprw">
                                <div ID="insideleft1" class="leftrw_left">
                                    <asp:Label ID="Label5" runat="server" CssClass="labelstyle" Text="Company Name"></asp:Label>
                                </div>
                                <div ID="insideright1" class="rightrw">
                                    :&nbsp;<asp:Label ID="Labelcompname" runat="server" CssClass="labelstyle" 
                                        Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div ID="Div2" class="comprw">
                                <div ID="Div3" class="leftrw_left">
                                    <asp:Label ID="Label43" runat="server" CssClass="labelstyle" Text="Address1"></asp:Label>
                                </div>
                                <div ID="Div4" class="rightrw">
                                    :&nbsp;<asp:Label ID="Labeladdr1" runat="server" CssClass="labelstyle" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div ID="Div5" class="comprw">
                                <div ID="Div6" class="leftrw_left">
                                    <asp:Label ID="Label44" runat="server" CssClass="labelstyle" Text="Address2"></asp:Label>
                                </div>
                                <div ID="Div7" class="rightrw">
                                    :&nbsp;<asp:Label ID="Labeladdr2" runat="server" CssClass="labelstyle" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div ID="Div78" class="comprw">
                                <div ID="Div96" class="leftrw_left">
                                    <asp:Label ID="Label38" runat="server" CssClass="labelstyle" Text="Address3"></asp:Label>
                                </div>
                                <div ID="Div97" class="rightrw">
                                    :&nbsp;<asp:Label ID="Labeladdr3" runat="server" CssClass="labelstyle" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div ID="Div98" class="comprw">
                                <div ID="Div99" class="leftrw_left">
                                    <asp:Label ID="Label42" runat="server" CssClass="labelstyle" Text="City"></asp:Label>
                                </div>
                                <div ID="Div100" class="rightrw">
                                    :&nbsp;<asp:Label ID="Labelcity" runat="server" CssClass="labelstyle" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div ID="Div8" class="comprw">
                                <div ID="Div9" class="leftrw_left">
                                    <asp:Label ID="Label4" runat="server" CssClass="labelstyle" Text="Username"></asp:Label>
                                </div>
                                <div ID="Div10" class="rightrw" style="text-align:bottom">
                                    :&nbsp;<asp:Label ID="Labeluser" runat="server" CssClass="labelstyle" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div ID="Div1" class="comprw">
                                <div ID="Div75" class="leftrw_left">
                                    <asp:Label ID="Label32" runat="server" CssClass="labelstyle" Text="Phone"></asp:Label>
                                </div>
                                <div ID="Div76" class="rightrw">
                                    :&nbsp;<asp:Label ID="Labelphn" runat="server" CssClass="labelstyle" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div ID="Div20" class="comprw">
                                <div ID="Div21" class="leftrw_left">
                                    <asp:Label ID="Label8" runat="server" CssClass="labelstyle" Text="Email"></asp:Label>
                                </div>
                                <div ID="Div22" class="rightrw">
                                    :&nbsp;<asp:Label ID="Labelemail" runat="server" CssClass="labelstyle" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div ID="Div29" class="comprw">
                                <div ID="Div30" class="leftrw_left">
                                    <asp:Label ID="Label10" runat="server" CssClass="labelstyle" 
                                        Text="Hourly Charges"></asp:Label>
                                </div>
                                <div ID="Div31" class="rightrw">
                                    :&nbsp;<asp:Label ID="Labelcharge" runat="server" CssClass="labelstyle" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div ID="Div11" class="comprw">
                                <div ID="Div12" class="leftrw_left">
                                    <asp:Label ID="Label7" runat="server" CssClass="labelstyle" 
                                        Text="Current Month Salary"></asp:Label>
                                </div>
                                <div ID="Div13" class="rightrw">
                                    :&nbsp;<asp:Label ID="Labelsal" runat="server" CssClass="labelstyle" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div ID="Div14" class="comprw">
                                <div ID="Div15" class="leftrw_left">
                                    <asp:Label ID="Label9" runat="server" CssClass="labelstyle" 
                                        Text="Date Of Joining"></asp:Label>
                                </div>
                                <div ID="Div16" class="rightrw">
                                    :&nbsp;<asp:Label ID="labeljoin" runat="server" CssClass="labelstyle" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div ID="Div17" class="comprw">
                                <div ID="Div18" class="leftrw_left">
                                    <asp:Label ID="Label11" runat="server" CssClass="labelstyle" 
                                        Text="Date Of Leaving"></asp:Label>
                                </div>
                                <div ID="Div19" class="rightrw">
                                    :&nbsp;<asp:Label ID="Labelend" runat="server" CssClass="labelstyle" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div ID="Div44" class="seperotorrwr">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </asp:View>
    </asp:MultiView>
</div>
</asp:Content>

