<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="NotificationManager.aspx.cs" Inherits="Admin_NotificationManager" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="../controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <script language="javascript" type="text/javascript">
        $(document).ready(function () {
           
            $(document).on('click', "[id*=chkCompanybox]", function () {

                var check = $(this).is(":checked")
                
                var chechboxlist = $('[id *= chkCompany]').find('input[type="checkbox"]')
                if (check) {
                   
                    chechboxlist.each(function () {
                        
                        $(this).attr('checked', 'checked');
                         
                     
                    });
                 
                     
                        
                }
                else {
                    chechboxlist.each(function () {
                        $(this).removeAttr('checked');
                       
                    });
                }
            });


            $(document).on('click', "[id*=chkStaffbox]", function () {

                var check = $(this).is(":checked")
                var chechboxlist = $('[id *= chkListStaff]').find('input[type="checkbox"]')
                if (check) {
                    chechboxlist.each(function () {
                        $(this).attr('checked', 'checked');
                    });
                }
                else {
                    chechboxlist.each(function () {
                        $(this).removeAttr('checked');
                    });
                }
            });
        });
        
    </script>

    <div id="div2" class="totbodycatreg">
        <div class="headerstyle11">
            <div class="headerstyle112">
                <asp:Label ID="Label2" runat="server" Text="Notification Manager" CssClass="Head1"></asp:Label>
            </div>
        </div>
        <div style="overflow: auto; width: 97%; padding-left: 5px; padding-right: 5px;">
            <uc2:MessageControl ID="MessageControl2" runat="server" />
        </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div id="div1" runat="server" style="padding-left: 20px; width: 100%;">
                    <div class="row_report">
                        <div class="rowinnerstyle1">
                            <asp:Label ID="Label7" runat="server" Text="Title"></asp:Label>
                              &nbsp;<asp:Label ID="Label11" runat="server" CssClass="errlabelstyle" ForeColor="Red"
                                Text="*"></asp:Label>
                        </div>
                        <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
                            <asp:TextBox ID="txttitle" runat="server"  ></asp:TextBox>
                          
                        </div>
                    </div>
                    <div class="row_report">
                        <div class="rowinnerstyle1">
                            <asp:Label ID="Label23" runat="server" Text="Message"></asp:Label>
                              &nbsp;<asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red"
                                Text="*"></asp:Label>
                        </div>
                        <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
                            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Height="86px" Width="328px"></asp:TextBox>
                          
                        </div>
                    </div>

                    <div class="row_report">
                        <div class="rowinnerstyle1">
                            <asp:Label ID="Label3" runat="server" Text="Reciever"></asp:Label>
                            <asp:Label ID="Label9" runat="server" CssClass="errlabelstyle" ForeColor="Red"
                                Text="*"></asp:Label>
                        </div>
                        <div style="overflow: auto ;padding-top: 5px;">
                            <asp:RadioButton ID="rdoAllComStaff" GroupName="Group1" Checked="true" AutoPostBack="true" Text="AllCompany" Value="Yes" runat="server" OnCheckedChanged="Group1_CheckedChanged" />
                            <asp:RadioButton ID="rdoSpecificComStaff" GroupName="Group1" AutoPostBack="true" Text="SpecificStaff" Value="No" runat="server" OnCheckedChanged="Group1_CheckedChanged" />
                        </div>
                    </div>

                    <div class="row_report">
                        <div style="width: 550px; float: left; overflow: hidden" id="divAllCompany" runat="server">
                            <div style="overflow: auto; width: 110px; float: left; padding-left: 40px;">
                                <asp:Label ID="Label27" runat="server" Text="Company"></asp:Label>
                                  &nbsp;<asp:Label ID="Label29" runat="server" CssClass="errlabelstyle" ForeColor="Red"
                                    Text="*"></asp:Label>
                            </div>
                            <div style="overflow: auto;">
                                <asp:CheckBox ID="chkCompanybox" runat="server" AutoPostBack="True"  Text=" Check All Company Name (Count : 0)" />
                            </div>
                            <div style="overflow: auto; padding-bottom: 0px; width: 400px; padding-left: 137px; float: left;">
                                <asp:Panel ID="Panel5" runat="server" Style="overflow: auto; width: 338px; padding-left: 10px; float: left;"
                                    ScrollBars="Auto" BorderColor="#B6D1FB" BorderStyle="Solid" BorderWidth="1px"
                                    Height="150px">

                                    <asp:CheckBoxList ID="chkCompany" runat="server"
                                        OnSelectedIndexChanged="OnCheckBox_Changed" AutoPostBack="true">
                                    </asp:CheckBoxList>
                                    <asp:Label ID="Label28" runat="server" CssClass="errlabelstyle" Text="No Company Found"
                                        Font-Bold="True" Visible="false"></asp:Label>
                                </asp:Panel>
                              
                            </div>
                        </div>
                        <div style="width: 450px; float: left; overflow: hidden" id="divSpecificStaff" runat="server">
                            <div style="overflow: auto; width: 20%; float: left; padding-left: 40px">
                                <asp:Label ID="Label30" runat="server" Text="Staff"></asp:Label>
                             
                                 
                            </div>
                            <div style="overflow: auto; padding-left: 5px">
                                <asp:CheckBox ID="chkStaffbox" runat="server" AutoPostBack="True"   Text=" Check All Staff Name (Count : 0)" />
                            </div>
                            <div style="overflow: auto; padding-bottom: 0px; width: 370px; padding-left: 40px; float: left;">
                                <asp:Panel ID="Panel6" runat="server" Style="overflow: auto; width: 338px; padding-left: 10px; float: left;"
                                    ScrollBars="Auto" BorderColor="#B6D1FB" BorderStyle="Solid" BorderWidth="1px"
                                    Height="150px">

                                    <asp:CheckBoxList ID="chkListStaff" OnSelectedIndexChanged="chkListStaff_SelectedIndexChanged" runat="server" AutoPostBack="true"></asp:CheckBoxList>
                                    <asp:Label ID="Label31" runat="server" CssClass="errlabelstyle" Text="No staff Found"
                                        Font-Bold="True" Visible="false"></asp:Label>
                                </asp:Panel>
                                
                            </div>
                        </div>
                    </div>
                    <br />
                    <div class="row_report">
                        <div class="rowinnerstyle1">
                            <asp:Label ID="Label6" runat="server" Text="IsLink"></asp:Label>
                        </div>
                        <div style="overflow: auto; padding-top: 5px; width: 58%; float: left;">
                            <asp:CheckBox ID="chkIsLink" Checked="false" runat="server" AutoPostBack="True" Text="" OnCheckedChanged="chkIsLink_CheckedChanged" />
                        </div>
                    </div>
                    <div class="row_report" id="divUrl" runat="server">
                        <div class="rowinnerstyle1">
                            <asp:Label ID="Label1" runat="server" Text="Url"></asp:Label>
                              &nbsp;<asp:Label ID="Label8" runat="server" CssClass="errlabelstyle" ForeColor="Red"
                                Text="*"></asp:Label>
                        </div>
                        <div style="overflow: auto; padding-bottom: 10px; width: 58%; float: left;">
                            <asp:TextBox ID="txtUrl" Width="50%" runat="server"></asp:TextBox>
                         
                        </div>
                    </div>



                    <div class="row_report">
                        <div style="overflow: auto; padding-bottom: 10px; width: 110px; float: left; padding-left: 40px; padding-top: 5px;">
                            <asp:Label ID="Label33" runat="server" Text="Date"></asp:Label>
                             <asp:Label ID="Label36" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                           <div style="overflow: auto; padding-bottom: 10px; width: 30px; float: left; text-align: right; padding-top: 5px; padding-right: 8px">
                            <asp:Label ID="Label10" runat="server" Text="From"></asp:Label>
                           
                        </div> 
                        <div style="overflow: auto; width: 110px; height: 20px; padding-top: 5px; float: left;">
                            <div class="txtcal">
                                <asp:TextBox ID="txtfrom" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox>
                            </div>
                            <div class="imagecal">
                                <asp:Image ID="Image4" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" />
                            </div>
                            <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtfrom"
                                PopupButtonID="Image4" Format="dd/MM/yyyy">
                            </cc1:CalendarExtender>
                           
                        </div>
                        <div style="overflow: auto; padding-bottom: 10px; width: 25px; float: left; text-align: right; padding-top: 5px; padding-right: 8px">
                            <asp:Label ID="Label35" runat="server" Text="To"></asp:Label>
                           
                        </div> &nbsp; &nbsp; &nbsp; &nbsp;

                        <div style="overflow: auto; width: 110px; height: 20px; padding-left: 5px; padding-top: 5px; float: left;">
                            <div class="txtcal">
                                <asp:TextBox ID="txtto" runat="server" CssClass="txtnrml" Width="70px"></asp:TextBox>
                            </div>
                            <div class="imagecal">
                                <asp:Image ID="Image5" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" />
                            </div>
                            <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtto"
                                PopupButtonID="Image5" Format="dd/MM/yyyy">
                            </cc1:CalendarExtender>
                           
                        </div>
                        <%--<div style="overflow: auto; width: 260px; height: 25px; padding-left: 55px; padding-top: 5px; float: left; text-align: left;">
                            <asp:Button ID="btngenerateNotification" runat="server" Text="Generate Notofication" CssClass="buttonstyle" OnClick="btngenerateNotification_Click" />

                             <asp:Button ID="btnUpdateeNotification" Visible="false" runat="server" Text="Update Notofication" CssClass="buttonstyle" OnClick="btnUpdateeNotification_Click" />
                        </div>

                         <div style="overflow: auto; width: 260px; height: 25px; padding-left:5px; padding-top: 5px; float: left; text-align: left;">
                             <asp:Button ID="btncancel" runat="server" Text="Cancel" OnClick="btncancel_Click"
                            CssClass="buttonstyle_search" />
                        </div>
                                 --%>
                    </div>

                    <div class="row_report">
                        <div class="rowinnerstyle1">
                            <asp:Label ID="Label4" runat="server" Text="IsActive"></asp:Label>
                        </div>
                        <div style="overflow: auto; padding-top: 5px; width: 110px; float: left;">
                            <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" AutoPostBack="True" Text="" OnCheckedChanged="chkIsActive_CheckedChanged" />
                        </div>
                                <div style="overflow: auto; width: 260px; height: 25px; padding-left: 55px; padding-top: 5px; float: left; text-align: left;">
                            <asp:Button ID="btngenerateNotification" runat="server" Text="Generate Notofication" CssClass="buttonstyle" OnClick="btngenerateNotification_Click" />

                             <asp:Button ID="btnUpdateeNotification" Visible="false" runat="server" Text="Update Notofication" CssClass="buttonstyle" OnClick="btnUpdateeNotification_Click" />
                        </div>

                         <div style="overflow: auto; width: 260px; height: 25px; padding-left:5px; padding-top: 5px; float: left; text-align: left;">
                             <asp:Button ID="btncancel" runat="server" Text="Cancel" OnClick="btncancel_Click"
                            CssClass="buttonstyle_search" />
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
                    <div style="overflow: auto; padding-bottom: 10px; padding-top: 10px; width: 100%; float: left;">
                    </div>

                </div>


                    <div id="div3" runat="server" style="padding-left: 20px;">
            <table>
                <tr>
                    <td>
                        <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
                        <asp:Button ID="btnsearch" runat="server" Text="Search" OnClick="btnsearch_Click"
                            CssClass="buttonstyle_search" />
                        <asp:Button ID="btnAdd" runat="server" Width="130" Text="Add new Notification" CssClass="buttonstyle_search"
                            OnClick="btnAdd_Click" />
                    </td>
                </tr>
            </table>
        </div>

                <div style="padding-bottom: 10px; width: 96.5%; float: left; padding-left: 10px;">
                    <asp:GridView ID="gv_mainmenu" runat="server" AutoGenerateColumns="false" EmptyDataText="No records found!!!"
                        ShowHeaderWhenEmpty="true" OnRowCommand="gv_rowcommand1" Width="100%" BorderColor="#55A0FF"
                        CssClass="gridcolstyle">
                        <Columns>
                            <asp:TemplateField Visible="false" HeaderText="BroadcastID" HeaderStyle-CssClass="grdheadermster">
                                <ItemStyle Width="15%" />
                                <ItemTemplate>
                                    <div class="gridpages">
                                        <asp:Label ID="BroadcastID" runat="server" CssClass="grdLinks" Text='<%#Eval("BroadcastID") %>'
                                            Style='text-transform: capitalize'></asp:Label>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField Visible="true" HeaderText="Title" HeaderStyle-CssClass="grdheadermster">
                                <ItemStyle Width="15%" />
                                <ItemTemplate>
                                    <div class="gridpages">
                                        <asp:Label ID="Title" runat="server" CssClass="grdLinks" Text='<%#Eval("Title") %>'
                                            Style='text-transform: capitalize'></asp:Label>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Message" HeaderStyle-CssClass="grdheadermster">
                                <ItemStyle Width="20%" />
                                <ItemTemplate>
                                    <div class="gridpages">
                                        <asp:Label ID="Message" runat="server" CssClass="grdLinks" Text='<%#Eval("Message") %>'
                                            Style='text-transform: capitalize'></asp:Label>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Url" HeaderStyle-CssClass="grdheadermster">
                                <ItemStyle Width="20%" />
                                <ItemTemplate>
                                    <div class="gridpages">
                                        <asp:Label ID="Url" runat="server" CssClass="grdLinks" Text='<%#Eval("Url") %>'
                                            Style='text-transform: capitalize'></asp:Label>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="FromDate" HeaderStyle-CssClass="grdheadermster">
                                <ItemStyle Width="10%" />
                                <ItemTemplate>
                                    <div class="gridpages">
                                        <asp:Label ID="FromDate" runat="server" CssClass="grdLinks" Text='<%#Eval("FromDate") %>'
                                            Style='text-transform: capitalize'></asp:Label>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Todate" HeaderStyle-CssClass="grdheadermster">
                                <ItemStyle Width="10%" />
                                <ItemTemplate>
                                    <div class="gridpages">
                                        <asp:Label ID="Todate" runat="server" CssClass="grdLinks" Text='<%#Eval("Todate") %>'
                                            Style='text-transform: capitalize'></asp:Label>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                           
                             <asp:TemplateField HeaderText="IsActive" HeaderStyle-CssClass="grdheadermster">
                                <ItemStyle Width="10%" />
                                <ItemTemplate>
                                    <div class="gridpages">
                                        <asp:Label ID="IsActive" runat="server" CssClass="grdLinks" Text='<%#Eval("IsActive") %>'
                                            Style='text-transform: capitalize'></asp:Label>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="CreatedDate" HeaderStyle-CssClass="grdheadermster">
                                <ItemStyle Width="10%" />
                                <ItemTemplate>
                                    <div class="gridpages">
                                        <asp:Label ID="CreatedDate" runat="server" CssClass="grdLinks" Text='<%#Eval("CreatedDate") %>'
                                            Style='text-transform: capitalize'></asp:Label>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="CreatedBy" HeaderStyle-CssClass="grdheadermster">
                                <ItemStyle Width="20%" />
                                <ItemTemplate>
                                    <div class="gridpages">
                                        <asp:Label ID="CreatedBy" runat="server" CssClass="grdLinks" Text='<%#Eval("CreatedBy") %>'
                                            Style='text-transform: capitalize'></asp:Label>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="AllCompany" HeaderStyle-CssClass="grdheadermster">
                                <ItemStyle Width="20%" />
                                <ItemTemplate>
                                    <div class="gridpages">
                                        <asp:Label ID="IsAllStaff" runat="server" CssClass="grdLinks" Text='<%#Eval("IsAllStaff") %>'
                                            Style='text-transform: capitalize'></asp:Label>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="IsLink" HeaderStyle-CssClass="grdheadermster">
                                <ItemStyle Width="20%" />
                                <ItemTemplate>
                                    <div class="gridpages">
                                        <asp:Label ID="IsLink" runat="server" CssClass="grdLinks" Text='<%#Eval("IsLink") %>'
                                            Style='text-transform: capitalize'></asp:Label>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                          
                            <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheadermster">
                                <ItemStyle Width="10%" />
                                <ItemTemplate>
                                    <div class="gridpages">
                                        <asp:ImageButton ID="edit" runat="server" CommandArgument='<%#Eval("BroadcastID") %>' CommandName="myedit"
                                            Text="Edit" CssClass="buttonstyle_search" Width="24" CausesValidation="false"
                                            ImageUrl="~/images/edit.png" />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Delete" HeaderStyle-CssClass="grdheadermster">
                                <ItemStyle Width="10%" />
                                <ItemTemplate>
                                    <div class="gridpages">
                                        <asp:ImageButton ID="Delete" runat="server" CommandArgument='<%#Eval("BroadcastID") %>' Text="Delete"
                                            ImageUrl="~/images/delete.gif" CommandName="mydelete" OnClientClick="return confirm('are you really want to delete data?');"
                                            CssClass="buttonstyle_search" CausesValidation="false" Width="24" />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </ContentTemplate>


        </asp:UpdatePanel>


          
    </div>
</asp:Content>

