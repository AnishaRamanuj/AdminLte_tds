<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Staff_TimeSheet_Sumary.ascx.cs"
    Inherits="controls_Staff_TimeSheet_Sumary" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit"
    TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl"
    TagPrefix="uc1" %>
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
        //$(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        $('.sidebar-main-toggle').click();
        $("[id*= txtfrom]").val($("[id*= hdnFrom]").val());
        $("[id*= txtto]").val($("[id*= hdnTo]").val());

        $("[id*= txtfrom]").on('change', function () {
            $("[id*= hdnFrom]").val($("[id*= txtfrom]").val());
        });

        $("[id*= txtto]").on('change', function () {
            $("[id*= hdnTo]").val($("[id*= txtto]").val());
        });


        BindPageLoadStaff();
       
        ////tStatus chkall
        $("[id*=chkTStatusAll]").on("click", function () {
            if ($(this).is(':checked') == true) {
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

        $("[id*=btngen]").on("click", function () {

            var staffcode = '';
            $(".chkItems:checked").each(function () {
                staffcode += $(this).val() + ',';
            });

            if (staffcode == '')
            { alert('Please select at least one staff !'); return false; }
            $("[id*=hdnSelectedStaffCode]").val(staffcode);
            $(".modalganesh").show();
        });
        $("[id*=btnBack]").on("click", function () { $(".modalganesh").show(); });
        $("[id*=chkjob1]").on("click", function () {
            var check = $(this).is(':checked');
           
            $(".chkItems").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
        });

        $("[id*=txtstartdate1]").on("change", function () { BindPageLoadStaff(); });
        $("[id*=txtenddate2]").on("change", function () { BindPageLoadStaff(); });
        $("[id*=ddlStatus]").on("change", function () { BindPageLoadStaff(); });
    });
    function pad2(number) {
        return (number < 10 ? '0' : '') + number
    }
<%--    function checkForm() {
        // regular expression to match required date format
        var dt = new Date();
        var day = dt.getDate();
        var mon = dt.getMonth() + 1;
        var yr = dt.getFullYear();
        var pin = document.getElementById("<%= txtstartdate1.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
            // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {

            alert("Invalid date format: " + pin);
            document.getElementById("<%= txtstartdate1.ClientID%>").focus();
            var days = pad2(day);
            var month = pad2(mon);
            document.getElementById("<%= txtstartdate1.ClientID%>").value = days + "/" + month + "/" + yr;
            return false;
        }
    }--%>
<%--    function checkForms() {
        // regular expression to match required date format
        var dt = new Date();
        var day = dt.getDate();
        var mon = dt.getMonth() + 1;
        var yr = dt.getFullYear();
        var pin = document.getElementById("<%= txtenddate2.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
            // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {

            alert("Invalid date format: " + pin);
            document.getElementById("<%= txtenddate2.ClientID%>").focus();
            var days = pad2(day);
            var month = pad2(mon);
            document.getElementById("<%= txtenddate2.ClientID%>").value = days + "/" + month + "/" + yr;
            return false;
        }
    }--%>
    function BindPageLoadStaff() {
        if ($("[id*=txtfrom]").val() == "" || $("[id*=txtfrom]").val() == undefined)
        { return false; }
        $(".modalganesh").show();
       
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/wsStaff.asmx/BindPageLoadStaff",
            data: "{compid:" + $("[id*=hdnCompid]").val() + ",UserType:'" + $("[id*=hdnTypeU]").val() + "',FromDate:'" + $("[id*=txtfrom]").val() + "',ToDate:'" + $("[id*=txtto]").val() + "',status:'" + $("[id*=hdnTStatusCheck]").val() + "',StaffCode:'" + $("[id*=hdnStaffCode]").val() + "'}",
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        //Ajax end
    }
    function OnSuccess(response) {
        var obj = jQuery.parseJSON(response.d);
        var tableRows = '';
        $("[id*=chkjob1]").parent().find('label').text("Check All Staff Name (Count :" + obj.length + ")");
        $.each(obj, function (i, vl) {
            tableRows += "<tr><td><input type='checkbox' class='chkItems' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
        });
        $("[id*=chkjob1]").removeAttr('checked');
        $("[id*=Panel1]").html("<table>" + tableRows + "</table>");
        try { LabelChangeforall(); } catch (e) { console.log(e); }
        $(".modalganesh").hide();
    }


    function TStatusCheck() {

        var selectedTStatus = '';
        var count = 0;

        var sbu = $("[id*=chkSubmitted]");
        if (sbu.is(':checked') == true) {
            count += 1; selectedTStatus += "Submitted,";
        }

        sbu = $("[id*=chkSaved]");
        if (sbu.is(':checked') == true)
        { count += 1; selectedTStatus += "Saved,"; }

        sbu = $("[id*=chkApproved]");
        if (sbu.is(':checked') == true)
        { count += 1; selectedTStatus += "Approved,"; }


        sbu = $("[id*=chkRejected]");
        if (sbu.is(':checked') == true)
        { count += 1; selectedTStatus += "Rejected,"; }

        if (count == 4)
        { $("[id*=chkTStatusAll]").attr('checked', 'checked'); }
        else { $("[id*=chkTStatusAll]").removeAttr('checked'); }

        if (selectedTStatus == '') {
            $("[id*=chkApproved]").attr('checked', 'checked');
            selectedTStatus = 'Approved';
        }
        $("[id*=hdnTStatusCheck]").val(selectedTStatus);
        BindPageLoadStaff();
    }
</script>
<style type="text/css">
    #content {
        overflow: hidden !important;
    }

    .loader {
        display: none;
        position: absolute;
        padding-top: 100px;
        width: 320px;
        height: 215px;
        z-index: 9999;
        text-align: center;
        vertical-align: middle;
        background: rgba(0,0,0,0.3);
        color: White;
        font-weight: bold;
        font-size: 18px;
    }

    button {
        background-color: #6BBE92;
        width: 302px;
        border: 0;
        padding: 10px 0;
        margin: 5px 0;
        text-align: center;
        color: #fff;
        font-weight: bold;
    }

    .cssPageTitle {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        border-bottom: 2px solid #0b9322;
        /*padding: 7px;*/
        color: #0b9322;
    }

    .cssButton {
        cursor: pointer; /*background-image: url(../Images/ButtonBG1.png);*/
        background-color: #d3d3d3;
        border: 0px;
        padding: 4px 15px 4px 15px;
        color: Black;
        border: 1px solid #c4c5c6;
        border-radius: 3px;
        font: bold 12px verdana, arial, "Trebuchet MS", sans-serif;
        text-decoration: none;
        opacity: 0.8;
    }

    .cssPageTitle2 {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        /*border-bottom: 2px solid #0b9322;*/
        padding: 7px;
        color: #0b9322;
    }

    .cssButton:focus {
        background-color: #69b506;
        border: 1px solid #3f6b03;
        color: White;
        opacity: 0.8;
    }

    .cssButton:hover {
        background-color: #69b506;
        border: 1px solid #3f6b03;
        color: White;
        opacity: 0.8;
    }

             .Chkbox {
            height: 20px;
            width: 20px;
            cursor: pointer;
            margin-right: 5px;
        }

        .Spancount {
            height: 20px;
            width: 50px;
            font-size: 12px;
            font-weight: bold;
        }
</style>


   <asp:HiddenField runat="server" ID="hdnCompid" />
            <asp:HiddenField runat="server" ID="hdnTypeU" />
            <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" />
            <asp:HiddenField runat="server" ID="hdnStaffCode" />
            <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
    <asp:HiddenField runat="server" ID="hdnFrom" />
    <asp:HiddenField runat="server" ID="hdnTo" />
   
      <div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>
          
</div>
            <div class="page-header " style="height: 50px;">
                <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-left: 1rem;">
                    <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                        <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold">Timesheet Summary</span></h5>
                        <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                    </div>
                     <asp:Button ID="btngen" runat="server" OnClick="btngen_Click" CssClass="btn btn-outline-success legitRipple"
                            Text="Generate Report" />
                        <asp:Button ID="btnBack" runat="server" CssClass="btn btn-outline-success legitRipple" Text="Back"
                    Visible="false" OnClick="btnBack_Click" />

                </div>
            </div>

           <div class="content">
                      <div style="width: 100%;">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div class="row_report card" runat="server" id="divReportInput">
            <div class="card-body">
                <table class="style1" style="float: left; padding-left: 55px; padding-top: 15px;">
                    <tr>
                        <td style="vertical-align: top;">
                            <table class="style1">
                                <tr>
                                    <td>
                                        <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center">:
                                    </td>
                                    <td>
                                <%--        <asp:TextBox ID="txtstartdate1" runat="server" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/calendar.png"
                                            Style="float: right; margin-right: 10px;" />
                                        <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle"
                                            ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtstartdate1"
                                            PopupButtonID="Image1" Format="dd/MM/yyyy">
                                        </cc1:CalendarExtender>--%>
                                         <input type="date" id="txtfrom" name="txtfrom" class="form-control form-control-border" />
                                    </td>
                                
                                
                                    <td>
                                        <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center">:
                                    </td>
                                    <td>
                                     <%--   <asp:TextBox ID="txtenddate2" runat="server" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Image2" runat="server" ImageUrl="~/images/calendar.png"
                                            Style="float: right; margin-right: 10px;" />
                                        <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle"
                                            ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtenddate2"
                                            PopupButtonID="Image2" Format="dd/MM/yyyy">
                                        </cc1:CalendarExtender>--%>
                                        <input type="date" id="txtto" name="txtto" class="form-control form-control-border" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td valign="top" align="center">:
                                    </td>
                                    <td align="left">
                                        <asp:CheckBox ID="chkTStatusAll" ClientIDMode="Static" runat="server"
                                            Checked="true" Text="All" /><br />
                                        <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server"
                                            Checked="true" onclick="TStatusCheck()" Text="Submitted" /><br />
                                        <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static"
                                            Checked="true" onclick="TStatusCheck()" Text="Saved" /><br />
                                        <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()"
                                            Checked="true" ClientIDMode="Static" Text="Approved" /><br />
                                        <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()"
                                            Checked="true" ClientIDMode="Static" Text="Rejected" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br />
                                    </td>
                                </tr>

                            </table>
                        </td>
                        <td class="style2" style="width: 380px; padding-left: 41px;">
                            <table class="style1">
                                <tr>
                                    <td align="right">
                                        <asp:CheckBox ID="chkjob1" runat="server" ForeColor="Black" Font-Bold="true" CssClass="labelChange"
                                            Height="20px" Text=" Check All" />
                                    </td>
                                </tr>
                            </table>
                            <div style="padding-bottom: 10px; width: 379px; float: left; height: 450px;">
                                <asp:Panel ID="Panel1" runat="server" BorderColor="#B6D1FB" BorderStyle="Solid"
                                    BorderWidth="1px" class="panel_style" Height="450px" ScrollBars="Auto"
                                    Width="550px">
                                </asp:Panel>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <rsweb:ReportViewer ID="ReportViewer1" CssClass="card" Height="670px" Width="795px"
            Visible="false" runat="server" AsyncRendering="False" InteractivityPostBackMode="AlwaysAsynchronous">
        </rsweb:ReportViewer>
               </div>



