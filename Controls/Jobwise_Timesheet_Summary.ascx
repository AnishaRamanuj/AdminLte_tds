<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Jobwise_Timesheet_Summary.ascx.cs" Inherits="controls_Jobwise_Timesheet_Summary" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
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

        $("[id*= txtfrom]").val($("[id*= hdnFrom]").val());
        $("[id*= txtto]").val($("[id*= hdnTo]").val());

        $("[id*= txtfrom]").on('change', function () {
            $("[id*= hdnFrom]").val($("[id*= txtfrom]").val());
            BindPageLoadStaff();
        });

        $("[id*= txtto]").on('change', function () {
            $("[id*= hdnTo]").val($("[id*= txtto]").val());
            BindPageLoadStaff();
        });



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

       
        $("[id*=ddlStatus]").on("change", function () { BindPageLoadStaff(); });

        BindPageLoadStaff();
    });


    function BindPageLoadStaff() {
        if ($("[id*=txtfrom]").val() == "" || $("[id*=txtfrom]").val() == undefined)
        { return false; }
        Blockloadershow();
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/wsStaff.asmx/BindPageLoadStaff",
            data: "{compid:" + $("[id*=hdnCompid]").val() + ",UserType:'" + $("[id*=hdnUserType]").val() + "',FromDate:'" + $("[id*=txtfrom]").val() + "',ToDate:'" + $("[id*=txtto]").val() + "',status:'" + $("[id*=hdnTStatusCheck]").val() + "',StaffCode:'" + $("[id*=hdnStaffCode]").val() + "'}",
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
        $("[id*=chkjob1]").parent().find('label').text("Check All Staff (" + obj.length + ")");
        $.each(obj, function (i, vl) {
            tableRows += "<tr><td><input type='checkbox' class='chkItems' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
        });
        $("[id*=chkjob1]").removeAttr('checked');
        $("[id*=Panel1]").html("<table>" + tableRows + "</table>");
        try { LabelChangeforall(); } catch (e) { console.log(e); }
        Blockloaderhide();

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


<div class="page-content">
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnUserType" />
    <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
    <asp:HiddenField runat="server" ID="hdnFrom" />
    <asp:HiddenField runat="server" ID="hdnTo" />
    <div class="content-wrapper">
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Jobwise Summary</span></h4>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

                <asp:Button ID="btngen" runat="server" OnClick="btngen_Click" CssClass="btn bg-success legitRipple"
                    Text="Generate Report" />

                <asp:Button ID="btnBack" Style="float: left" runat="server" CssClass="btn btn-primary legitRipple" Text="Back" Visible="false"
                    OnClick="btnBack_Click" />

            </div>
        </div>

        <div class="content">
            <div class="divstyle card">
                <div id="" class="totbodycatreg" style="height: 700px;">
                    <div style="width: 100%;">
                        <uc1:MessageControl ID="MessageControl1" runat="server" />
                    </div>
                    <div runat="server" id="divReportInput">
                        <div class="card-body">
                            <table style="padding-left: 20px; padding-top: 15px;">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <table class="style1" width="1000px;">
                                            <tr>
                                                <td valign="middle">
                                                    <asp:Label ID="Label1" runat="server" ForeColor="Black" Text="From" Font-Bold="True"></asp:Label>
                                                </td>
                                                <td align="center" valign="middle">:
                                                </td>
                                                <td valign="middle">
                                                    <input type="date" id="txtfrom" name="txtfrom" class="form-control" />
                                                </td>
                                                <td valign="middle">
                                                    <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="To" Font-Bold="True"></asp:Label>
                                                </td>
                                                <td align="center" valign="middle">:
                                                </td>
                                                <td valign="middle">

                                                    <input type="date" id="txtto" name="txtto" class="form-control" />
                                                </td>
                                                <td valign="middle">
                                                    <asp:Label ID="Label3" runat="server" ForeColor="Black" Text="Timesheet Status" Font-Bold="True"></asp:Label>
                                                </td>
                                                <td valign="middle" align="center">:
                                                </td>
                                                <td valign="middle" colspan="3">
                                                    <asp:CheckBox ID="chkTStatusAll" ClientIDMode="Static" runat="server" Checked="true"
                                                        Text="All" />&nbsp;&nbsp;
                                            <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server" Checked="true"
                                                onclick="TStatusCheck()" Text="Submitted" />&nbsp;&nbsp;
                                            <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static" Checked="true" onclick="TStatusCheck()"
                                                Text="Saved" />&nbsp;&nbsp;
                                            <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()" Checked="true"
                                                ClientIDMode="Static" Text="Approved" />&nbsp;&nbsp;
                                            <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()" Checked="true"
                                                ClientIDMode="Static" Text="Rejected" />
                                                </td>

                                            </tr>

                                        </table>
                                    </td>
                                </tr>

                            </table>
                        </div>



                        <div id="dvEditInvoice2" class="row">
                            <div class="card-body">
                                <table class="style1">
                                    <tr>
                                        <td align="right">
                                            <asp:CheckBox ID="chkjob1" runat="server" ForeColor="Black" Font-Bold="true"
                                                Height="20px" Text="Check All Staff" CssClass="labelChange" />
                                        </td>
                                    </tr>
                                </table>
                                <div style="padding-bottom: 10px; width: 300px; float: left; height: 450px;">
                                    <asp:Panel ID="Panel1" runat="server" BorderColor="#B6D1FB" BorderStyle="Solid"
                                        BorderWidth="1px" class="panel_style" Height="550px" ScrollBars="Auto"
                                        Width="450px">
                                    </asp:Panel>
                                </div>
                            </div>

                        </div>

                    </div>
                    <div id="tblreport" visible="false">
                        <table>
                            <tr>
                                <td></td>
                            </tr>
                        </table>
                    </div>

                    <%--   <rsweb:ReportViewer ID="ReportViewer2" Height="670px" Width="1200px" Visible="false"
                        runat="server" AsyncRendering="False" InteractivityPostBackMode="AlwaysAsynchronous" CssClass="card-body">
                    </rsweb:ReportViewer>--%>

                    <rsweb:ReportViewer ID="ReportViewer1" Height="670px" Width="1200px"
                        Visible="false" runat="server" AsyncRendering="False" InteractivityPostBackMode="AlwaysAsynchronous" CssClass="card-body">
                    </rsweb:ReportViewer>
                </div>
            </div>
        </div>
    </div>

</div>







<%--<div class="divstyle">
    <div class="headerpage">
        <div>
            <table class="cssPageTitle" style="width: 100%;">
                <tr>
                    <td class="cssPageTitle2">
                        <asp:Label ID="lblname" runat="server" Text="Jobwise Summary" Style="margin-left: 0px;"></asp:Label>
                    </td>
                    <td style="float: right; padding-top: 5px; margin-left: 60px;">
            </table>



        </div>
    </div>

    <div id="div2" class="totbodycatreg" style="height: 700px;">
        <div style="width: 100%;">
           
        </div>
        <div class="row_report" runat="server" id="divReportInput">
            <div>
                <table class="style1" style="float: left; padding-top: 15px;">
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
                                        <asp:TextBox ID="txtstartdate1" runat="server" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png"
                                            Style="float: right; margin-right: 10px;" />
                                        <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle"
                                            ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtstartdate1"
                                            PopupButtonID="Img1" Format="dd/MM/yyyy">
                                        </cc1:CalendarExtender>
                                    </td>

                                    <td>
                                        <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td>:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtenddate2" runat="server" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Img2" runat="server" ImageUrl="~/images/calendar.png"
                                            Style="float: right; margin-right: 10px;" />
                                        <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle"
                                            ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtenddate2"
                                            PopupButtonID="Img2" Format="dd/MM/yyyy">
                                        </cc1:CalendarExtender>
                                    </td>

                                    <td>
                                        <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td>:
                                    </td>
                                    <td>
                                        <asp:CheckBox ID="chkTStatusAll" ClientIDMode="Static" runat="server"
                                            Checked="true" Text="All" />
                                        <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server"
                                            Checked="true" onclick="TStatusCheck()" Text="Submitted" />
                                        <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static"
                                            Checked="true" onclick="TStatusCheck()" Text="Saved" />
                                        <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()"
                                            Checked="true" ClientIDMode="Static" Text="Approved" />
                                        <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()"
                                            Checked="true" ClientIDMode="Static" Text="Rejected" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="style2" style="width: 450px; padding-left: 10px;"></td>
                    </tr>
                </table>
            </div>
        </div>

    </div>
</div>--%>
