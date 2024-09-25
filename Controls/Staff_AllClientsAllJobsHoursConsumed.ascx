
<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Staff_AllClientsAllJobsHoursConsumed.ascx.cs" Inherits="controls_Staff_AllClientsAllJobsHoursConsumed" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/bootstrap.bundle.min.js" type="text/javascript"></script>
<script src="../js/blockui.min.js" type="text/javascript"></script>
<script src="../js/ripple.min.js" type="text/javascript"></script>
<script src="../js/jgrowl.min.js" type="text/javascript"></script>
<script src="../js/pnotify.min.js" type="text/javascript"></script>
<script src="../js/noty.min.js" type="text/javascript"></script>

<script src="../js/form_select2.js" type="text/javascript"></script>
<script src="../js/d3.min.js" type="text/javascript"></script>

<script src="../jquery/moment.js" type="text/javascript"></script>
<script src="../js/interactions.min.js" type="text/javascript"></script>
<script src="../js/datatables.min.js" type="text/javascript"></script>

<script src="../js/uniform.min.js" type="text/javascript"></script>
<script src="../js/app.js" type="text/javascript"></script>
<script src="../js/select2.min.js" type="text/javascript"></script>

<script src="../js/Ajax_Pager.min.js" type="text/javascript"></script>

<script src="../js/components_modals.js" type="text/javascript"></script>
<script src="../js/echarts.min.js" type="text/javascript"></script>
<script src="../js/PopupAlert.js" type="text/javascript"></script>   

 <script language="javascript" type="text/javascript">
     $(document).ready(function () {
         $('.sidebar-main-toggle').click();
         var a = new Date();
         var dt = moment(a).format('YYYY-MM')
         $("[id*=dtmonth]").val(dt);
         $("[id*=hdnmonth]").val(dt);

         $("[id*=dtmonth]").on("change", function () {
             $("[id*=hdnmonth]").val($("[id*=dtmonth]").val());
           
         });
     });

    function pad2(number) {
    return (number < 10 ? '0' : '') + number
   }
    
        </script>
 <asp:HiddenField runat="server" ID="hdnmonth" Value="" />
    <div class="page-content">
        <div class="content-wrapper">
                 <!-- Page header -->
            <div class="page-header " style="height: 50px;">
                <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                    <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                        <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold">Staff-Columnar Month Detail</span></h4>
                        <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                    </div>
                        <asp:Button ID="btngen" runat="server" CssClass="btn bg-success legitRipple" 
                                                 OnClick="btngen_Click" 
                                                Text="Generate Report" />

                </div>
            </div>

           <div class="content">
                      <div style="width: 100%;">
            <uc2:MessageControl ID="MessageControl1" runat="server" />
        </div>

                 <div class="row_report card">
                <div class="card-body">
                   
                    <table class="style1" style="width:100%; padding-top:15px; padding-left:35px;">
                        <tr>
                            <td class="style2">
                                <table class="style1">
                                    <tr>
                                       
                                        <td align="right">
                                            <asp:CheckBox ID="chkjob1" runat="server" AutoPostBack="True" ForeColor="Black" Font-Bold="true" 
                                                Height="20px" OnCheckedChanged="chkjob1_CheckedChanged" CssClass="labelChange" Text=" Check All Staff Name" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td class="style2" style="width:380px;">
                                <div style="padding-bottom: 10px; width: 400px; float: left; height:400px;">
                                    <asp:Panel ID="Panel1" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" 
                                        BorderWidth="1px" class="panel_style" Height="400px" ScrollBars="Auto" 
                                        Width="390px">
                                        <asp:DataList ID="Staff_List" runat="server" ForeColor="Black" Width="340px">
                                            <ItemTemplate>
                                                <div style="overflow: auto; width: 300px; float: left;">
                                                    <div style="overflow: auto; width: 30px; float: left;">
                                                        <asp:CheckBox ID="chkitem1" runat="server" />
                                                    </div>
                                                    <div class="dataliststyle">
                                                        <asp:Label ID="Label50" runat="server" Text='<%# Bind("StaffName") %>' 
                                                            Width="240px"></asp:Label>
                                                        <asp:Label ID="Label51" runat="server" Text='<%# Bind("StaffCode") %>' 
                                                            Visible="False" Width="10px"></asp:Label>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                            <ItemStyle Height="17px" />
                                        </asp:DataList>
                                        <asp:Label ID="Label2" runat="server" CssClass="errlabelstyle labelChange" 
                                            Font-Bold="True" Text="No Staff Found" Visible="False"></asp:Label>
                                    </asp:Panel>
                                </div>
                            </td>
                            <td style="vertical-align: top;">
                                <table class="style1">
                                    <tr>
                                        <td align="right" class="style17">
                                            <asp:Label ID="Label3" runat="server" ForeColor="Black" Text="Date" 
                                                Font-Bold="True"></asp:Label>
                                        </td>
                                        <td align="center" class="style18">
                                            :</td>
                                        <td>
<%--                                            <asp:TextBox ID="txtstartdate1" runat="server" CssClass="texboxcls" ></asp:TextBox>
                                            <asp:Image ID="img1" runat="server" ImageUrl="~/images/calendar.png" 
                                                style="float: right; margin-right: 10px;" />
                                            <asp:Label ID="Label4" runat="server" CssClass="errlabelstyle" ForeColor="Red" 
                                                Text=""></asp:Label>
                                                <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtstartdate1" PopupButtonID="img1" Format="MM/yyyy"></cc1:CalendarExtender> --%>
                                        
                                        <input type="month" style="width:125px;" class="form-control" id="dtmonth" name="dtmonth" />
                                        </td><td align="left" class="style15">
                                        

                                        </td>
                                    </tr>
                                    
                                 
                                    
                                    
                                </table>
                            </td>
                        </tr>
                    </table>
                   
                </div>
                
            </div>   
       
               </div>

            </div>
        </div>



