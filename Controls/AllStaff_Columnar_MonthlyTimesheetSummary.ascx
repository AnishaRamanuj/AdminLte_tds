<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AllStaff_Columnar_MonthlyTimesheetSummary.ascx.cs" Inherits="controls_Allstaff_Columnar_MonthlyTimesheet_Summary" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register src="MessageControl.ascx" tagname="MessageControl" tagprefix="uc2" %>

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

        $("[id*=chkTStatusAll]").on("click", function () {
            if ($(this).attr('checked')) {
                $("[id*=chkSubmitted]").attr('checked', 'checked');
                $("[id*=chkSaved]").attr('checked', 'checked');
                $("[id*=chkApproved]").attr('checked', 'checked');
                $("[id*=chkRejected]").attr('checked', 'checked');
            }
            else {
                $("[id*=chkSubmitted]").removeAttr('checked');
                $("[id*=chkSaved]").removeAttr('checked');
                $("[id*=chkApproved]").removeAttr('checked');
                $("[id*=chkRejected]").removeAttr('checked');
            }
            TStatusCheck();
        });
    });

    ///////get statuswise filter
    function TStatusCheck() {
        var selectedTStatus = '';
        var count = 0;

        var sbu = $("[id*=chkSubmitted]");
        if (sbu.attr('checked'))
        { count += 1; selectedTStatus += "Submitted,"; }

        sbu = $("[id*=chkSaved]");
        if (sbu.attr('checked'))
        { count += 1; selectedTStatus += "Saved,"; }

        sbu = $("[id*=chkApproved]");
        if (sbu.attr('checked'))
        { count += 1; selectedTStatus += "Approved,"; }


        sbu = $("[id*=chkRejected]");
        if (sbu.attr('checked'))
        { count += 1; selectedTStatus += "Rejected,"; }

        if (count == 4)
        { $("[id*=chkTStatusAll]").attr('checked', 'checked'); }
        else { $("[id*=chkTStatusAll]").removeAttr('checked'); }

        if (selectedTStatus == '') {
            $("[id*=chkApproved]").attr('checked', 'checked');
            selectedTStatus = 'Approved';
        }
        $("[id*=hdnTStatusCheck]").val(selectedTStatus);
//        Onpagefilterloads();
    }

    function pad2(number) {
        return (number < 10 ? '0' : '') + number
    }

 
</script>

<asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected"/>  
 <asp:HiddenField runat="server" ID="hdnmonth" Value="" />
<div class="page-content">
    <div class="content-wrapper">
        <!-- Page header -->
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold">Staff - Columnar Monthly Summary</span></h4>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>
                <asp:Button ID="btngenerate" runat="server" CssClass="btn btn-success legitRipple" OnClick="btngenerate_Click" Text="Generate Report" />  

               
            </div>

        </div>

        <div class="content">
            <div style="width: 100%;">
                     <uc2:MessageControl ID="MessageControl2" runat="server" />
            </div>
                <div class="row_report card">
                <div class="card-body">
            <table style="padding-left:35px; padding-top:10px;">
              <tr>
                <td valign="middle">
                    <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status"
                        Font-Bold="True"></asp:Label>
                </td>
                <td valign="middle" align="center">
                    :
                </td>
                <td valign="middle">
                    <asp:CheckBox ID="chkTStatusAll" ClientIDMode="Static" runat="server" Checked="true"
                        Text="All" />&nbsp;&nbsp;
                    <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server" Checked="true"
                        onclick="TStatusCheck()" Text="Submitted" />&nbsp;&nbsp;
                    <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static" Checked="true"
                        onclick="TStatusCheck()" Text="Saved" />&nbsp;&nbsp;
                    <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()" Checked="true"
                        ClientIDMode="Static" Text="Approved" />&nbsp;&nbsp;
                    <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()" Checked="true"
                        ClientIDMode="Static" Text="Rejected" />
                </td>
                <td>&nbsp;</td>
                                    
                <td valign="middle">
                    <label style="font-weight:bold">Month:</label></td>
                    <td>:</td>
                <td style="width: 200px;">
                      <%--  <asp:TextBox ID="fromdate" runat="server" CssClass="texboxcls"></asp:TextBox>
                        <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" 
                            style="float: left; margin-right: 10px;" />
                        <asp:Label ID="Label4" runat="server" CssClass="errlabelstyle" ForeColor="Red" 
                            Text=""></asp:Label>
                            <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="fromdate"
                                PopupButtonID="Img1" Format="MM/yyyy">
                            </cc1:CalendarExtender>  --%>   
                    <input type="month" style="width:125px;" class="form-control" id="dtmonth" name="dtmonth" />                                 
                                         
                </td>
                    <td>
                                                         
                </td>
                                    
              </tr>
              
            </table>                   
                    <table class="style1" style="padding-left:35px; width:100%;">
                        <tr>
                            <td class="style2">
                                <table class="style1">
                                    <tr>
                                        <td class="style8">
                                            <asp:Label ID="Label16" runat="server" Font-Bold="True" ForeColor="Black" Text="Staff Name" CssClass="labelChange"></asp:Label>
                                        </td>
                                        <td align="left">
                                            <asp:CheckBox ID="chkjob1" runat="server" AutoPostBack="True" ForeColor="Black" Font-Bold="true" 
                                                Height="20px" OnCheckedChanged="chkjob1_CheckedChanged" Text=" Check All" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td class="style2" style="width:380px;">
                                <div style="padding-bottom: 10px; width: 500px; float: left; height:400px;">
                                    <asp:Panel ID="Panel1" runat="server" BorderColor="#B6D1FB" BorderStyle="Solid" 
                                        BorderWidth="1px" class="panel_style" Height="400px" ScrollBars="Auto" 
                                        Width="450px">
                                        <asp:DataList ID="Staff_List" runat="server" ForeColor="Black" Width="340px">
                                            <ItemTemplate>
                                                <div style="overflow: auto; width: 300px; float: left;">
                                                    <div style="overflow: auto; width: 30px; float: left;">
                                                        <asp:CheckBox ID="chkitem1" runat="server" />
                                                    </div>
                                                    <div class="dataliststyle">
                                                        <asp:Label ID="Label50" runat="server" Text='<%# bind("StaffName") %>' 
                                                            Width="240px"></asp:Label>
                                                        <asp:Label ID="Label51" runat="server" Text='<%# bind("StaffCode") %>' 
                                                            Visible="False" Width="10px"></asp:Label>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                            <ItemStyle Height="17px" />
                                        </asp:DataList>
                                        <asp:Label ID="Label1" runat="server" CssClass="errlabelstyle labelChange" 
                                            Font-Bold="True" Text="No Staff Found" Visible="False"></asp:Label>
                                    </asp:Panel>
                               
                                </div>
                            </td>
                            <td style="vertical-align: top;">
                                <table class="style1">

                                    <tr style =" visibility :hidden ; display:none;"  >
                                        <td align="right" style="font:Bold; font-weight: bold;  " class="style17">
                                            To</td>
                                        <td align="center" class="style18">
                                            :</td>
                                        <td>
                                            <asp:TextBox ID="txtenddate2" runat="server" CssClass="texboxcls"></asp:TextBox>
                                            <asp:Image ID="Img2" runat="server" ImageUrl="~/images/calendar.png" 
                                                style="float: right; margin-right: 10px;" />
                                            <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red" 
                                                Text=""></asp:Label>
                                                <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtenddate2"
                        PopupButtonID="Img2" Format="dd/MM/yyyy">
                    </cc1:CalendarExtender>
                                        </td>
                                    </tr>
                                  
                                    <tr>
									<td></td>
									<td></td>
                                        <td align="left" class="style15" >


                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:DropDownList ID="drpclient" runat="server" AppendDataBoundItems="True" 
                                                CssClass="stf_drop" DataTextField="StaffName" DataValueField="StaffCode" 
                                                Height="20px" Visible="False">
                                                <asp:ListItem Value="0">--Select--</asp:ListItem>
                                            </asp:DropDownList>
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


