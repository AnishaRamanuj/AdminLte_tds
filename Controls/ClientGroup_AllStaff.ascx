<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ClientGroup_AllStaff.ascx.cs" Inherits="controls_ClientGroup_AllStaff" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit"
    TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl"
    TagPrefix="uc1" %>
<%--<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<link href="../StyleCss/Divstyle.css" rel="stylesheet" type="text/css" />--%>
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
<script type="text/javascript" src="../js/PDFMaker/html2pdf.bundle.js"></script>
<script type="text/javascript" src="../js/PDFMaker/html2pdf.bundle.min.js"></script>
<script type="text/javascript" src="../js/table2excel.js"></script>


<script language="javascript" type="text/javascript">
    $(document).ready(function () {
        BindGroup();



        $("[id*=btngen]").on("click", function () {

            var staffcode = '';
            $(".chkItems:checked").each(function () {
                staffcode += $(this).val() + ',';
            });

            if (staffcode == '')
            { alert('Please select at least one client group !'); return false; }
            $("[id*=hdnSelectedGroupid]").val(staffcode);
            $(".modalganesh").show();
        });

        $("[id*=btnBack]").on("click", function () { $(".modalganesh").show(); });
        $("[id*=chkjob1]").on("click", function () {

            var check = $(this).attr('checked');
            $(".chkItems").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
        });

        $("[id*=txtstartdate1]").on("change", function () { BindGroup(); });
        $("[id*=txtenddate2]").on("change", function () { BindGroup(); });
        $("[id*=ddlStatus]").on("change", function () { BindGroup(); });
    });
    function pad2(number) {
        return (number < 10 ? '0' : '') + number
    }
    function checkForm() {
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
    }
    function checkForms() {
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
    }
    function BindGroup() {
        if ($("[id*=txtstartdate1]").val() == "" || $("[id*=txtstartdate1]").val() == undefined)
        { return false; }
        $(".modalganesh").show();
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/wsClientGroup.asmx/BindGroup",
            data: "{compid:" + $("[id*=hdnCompid]").val() + ",UserType:'" + $("[id*=hdnUserType]").val() + "',FromDate:'" + $("[id*=txtstartdate1]").val() + "',ToDate:'" + $("[id*=txtenddate2]").val() + "',status:'" + $("[id*=ddlStatus] :selected").text() + "',StaffCode:'" + $("[id*=hdnStaffCode]").val() + "'}",
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
        $("[id*=chkjob1]").parent().find('label').text("Check All Client Group Name (Count :" + obj.length + ")");
        $.each(obj, function (i, vl) {
            tableRows += "<tr><td><input type='checkbox' class='chkItems' value='" + vl.CgroupID + "' /></td><td>" + vl.cGroupName + "</td></tr>";
        });
        $("[id*=chkjob1]").removeAttr('checked');
        $("[id*=Panel1]").html("<table>" + tableRows + "</table>");
        $(".modalganesh").hide();
        
    }
</script>
<div class="page-content">
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnUserType" />
    <asp:HiddenField runat="server" ID="hdnSelectedGroupid" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
            </div>
        </div>
    </div>

    <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-bottom: 1rem;">
        <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">
            <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Client Group All Staff</span></h5>
            <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
        </div>
        <div style="float: right;">
            <asp:Button ID="btnBack" runat="server" class="btn btn-outline-success legitRipple" Text="Back"
                Visible="false" OnClick="btnBack_Click" />
        </div>
    </div>
</div>
<div class="content">
    <div class="divstyle card">
        <div id="div2" class="totbodycatreg" style="height: 700px;">
            <div style="width: 100%;">
                <uc1:MessageControl ID="MessageControl1" runat="server" />
            </div>
            <div runat="server" id="divReportInput">
                <div class="card-body">
                    <div class="form-group row" style="padding-top:0px;">
                        <div class="col-lg-0.5" style="padding-top:5px;">
                        <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From" Font-Bold="True"></asp:Label>
                            </div>
                        <div class="col-lg-1">
                            <asp:TextBox ID="txtstartdate1" runat="server" CssClass="form-control form-control-border"></asp:TextBox>
                        </div>
                        <div class="col-lg-1" style="padding-top:5px;">
                            <asp:Image ID="Img1" runat="server" CssClass="icon-calendar52 text-primary-600" />
                        </div>
                        <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle"
                            ForeColor="Red" Text=""></asp:Label>
                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtstartdate1"
                            PopupButtonID="Img1" Format="dd/MM/yyyy">
                        </cc1:CalendarExtender>
                        <div class="col-lg-0.5" style="padding-top:5px;">
                        <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To" Font-Bold="True"></asp:Label>
                            </div>
                        <div class="col-lg-1">
                            <asp:TextBox ID="txtenddate2" runat="server" class="form-control form-control-border"></asp:TextBox>
                        </div>
                        <div class="col-lg-1" style="padding-top:5px;">
                            <asp:Image ID="Img2" runat="server" CssClass="icon-calendar52 text-primary-600" />
                        </div>
                        <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle"
                            ForeColor="Red" Text=""></asp:Label>
                        <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtenddate2"
                            PopupButtonID="Img2" Format="dd/MM/yyyy">
                        </cc1:CalendarExtender>

                        <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status"
                            Font-Bold="True"></asp:Label>
                        <div class="col-lg-2">
                            <asp:DropDownList runat="server" ID="ddlStatus" class="texboxcls">
                                <asp:ListItem>All</asp:ListItem>
                                <asp:ListItem Selected="True">Approved</asp:ListItem>
                                <asp:ListItem>Saved</asp:ListItem>
                                <asp:ListItem>Rejected</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div>
                            <asp:Button ID="btngen" runat="server" class="btn btn-outline-success legitRipple" OnClick="btngen_Click"
                                Text="Generate Report" />
                        </div>
                    </div>
                </div>
            </div>
            <div id="dvEditInvoice2" class="row" runat="server">              
                    <table>
                        <tr>
                            <td class="style2" style="width: 380px; padding-left: 10px;">
                                <table class="style1">
                                    <tr>
                                        <td align="right">
                                            <asp:CheckBox ID="chkjob1" runat="server" ForeColor="Black" Font-Bold="true"
                                                Height="20px" Text=" Check All" />
                                        </td>
                                    </tr>
                                </table>
                                <div style="padding-bottom: 10px; width: 379px; float: left; height:350px;">
                                    <asp:Panel ID="Panel1" runat="server" BorderColor="#B6D1FB" BorderStyle="Solid"
                                        BorderWidth="1px" class="panel_style" Height="550px" ScrollBars="Auto"
                                        Width="352px">
                                    </asp:Panel>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
           
            <rsweb:ReportViewer ID="ReportViewer1" Height="670px" Width="795px"
                Visible="false" runat="server" AsyncRendering="False" InteractivityPostBackMode="AlwaysAsynchronous">
            </rsweb:ReportViewer>
        </div>
    </div>
</div>
