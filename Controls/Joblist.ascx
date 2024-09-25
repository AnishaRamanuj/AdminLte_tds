<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Joblist.ascx.cs" Inherits="controls_Joblist" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />

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
            BindJobList();
        });

        $("[id*= txtto]").on('change', function () {
            $("[id*= hdnTo]").val($("[id*= txtto]").val());
            BindJobList();
        });


        BindJobList();

        //$("[id*=btngen]").on("click", function () {

          
           
        //});


        $("[id*=btnBack]").on("click", function () { $(".modalganesh").show(); });


        $("[id*=chkjob1]").on("click", function () {
            var check = $(this).is(':checked');

            $(".chkItems").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });

            var mJobid = '';
            $(".chkItems:checked").each(function () {
                mJobid += $(this).val() + ',';
            });

            //if (mJobid == '')
            //{
            //    alert('Please select at least one Job !'); return false;
            //}
            $("[id*=hdnSelectedmJob]").val(mJobid);

        });

        //$("[id*=txtstartdate1]").on("change", function () {
        //    BindJobList();
        //});
        //$("[id*=txtenddate2]").on("change", function () {
        //    BindJobList();
        //});
        $("[id*=ddlStatus]").on("change", function () { BindJobList(); });
        $("[id*=ddlBillable]").on("change", function () { BindJobList(); });

    });



    function BindJobList() {
        if ($("[id*=txtfrom]").val() == "" || $("[id*=txtfrom]").val() == undefined)
        { return false; }
        $(".modalganesh").show();
        var b = $("[id*=ddlBillable]").val();
        if (b == "Yes") {
            b = 1;
        }
        else if (b == "No") {
            b = 0;
        }
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/wsJob.asmx/BindJobList",
            data: "{compid:" + $("[id*=hdnCompid]").val() + ",UserType:'" + $("[id*=hdnUserType]").val() + "',FromDate:'" + $("[id*=txtfrom]").val() + "',ToDate:'" + $("[id*=txtto]").val() + "',status:'" + $("[id*=ddlStatus] :selected").text() + "',Staffcode:'" + $("[id*=hdnStaffCode]").val() + "',bill:'" + b + "'}",
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        //Ajax end
    }

    function SelectJob(i) {
        var mJobid = '';
        $(".chkItems:checked").each(function () {
            mJobid += $(this).val() + ',';
        });

        $("[id*=hdnSelectedmJob]").val(mJobid);
    }

    function OnSuccess(response) {
        var obj = jQuery.parseJSON(response.d);
        var tableRows = '';
        $("[id*=chkjob1]").parent().find('label').text("Check All Job Name (Count :" + obj.length + ")");
        $.each(obj, function (i, vl) {
            tableRows += "<tr><td><input type='checkbox' onclick='SelectJob($(this))' class='chkItems' value='" + vl.mJobid + "' /></td><td>" + vl.mJobName + "</td></tr>";
        });
        $("[id*=chkjob1]").removeAttr('checked');
        $("[id*=Panel1]").html("<table>" + tableRows + "</table>");
        try { LabelChangeforall(); } catch (e) { console.log(e); }
        $(".modalganesh").hide();
    }
</script>


<div class="page-content">
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnUserType" />
    <asp:HiddenField runat="server" ID="hdnSelectedmJob" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
    <asp:HiddenField ID="hdndptwise" runat="server" />
    <asp:HiddenField ID="hdnTaskwise" runat="server" />
    <asp:HiddenField ID="hdnlink" runat="server" />
    <asp:HiddenField runat="server" ID="hdnFrom" />
    <asp:HiddenField runat="server" ID="hdnTo" />
    <div class="content-wrapper">
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Job List Report</span></h4>
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
                                    <td>
                                        <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From"
                                            Font-Bold="True"></asp:Label></td>
                                    <td>:</td>
                                    <td>
                                        <input type="date" id="txtfrom" name="txtfrom" class="form-control" />

                                    </td>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To"
                                            Font-Bold="True"></asp:Label></td>
                                    <td>:</td>
                                    <td>
                                        <input type="date" id="txtto" name="txtto" class="form-control" />

                                    </td>
                                    <td>
                                        <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Job Status" CssClass="labelChange"
                                            Font-Bold="True"></asp:Label></td>
                                    <td>:</td>
                                    <td>
                                        <div class="divedBlock">
                                            <asp:DropDownList runat="server" ID="ddlStatus" CssClass="dropstyleJob">
                                                <asp:ListItem>Both</asp:ListItem>
                                                <asp:ListItem Selected="True">OnGoing</asp:ListItem>
                                                <asp:ListItem>Completed</asp:ListItem>

                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                    <td>
                                        <asp:Label ID="Label1" runat="server" ForeColor="Black" Text="Billable"
                                            Font-Bold="True"></asp:Label></td>
                                    <td>:</td>
                                    <td>
                                        <div class="divedBlock">
                                            <asp:DropDownList runat="server" ID="ddlBillable" CssClass="dropstyleJob">
                                                <asp:ListItem Selected="True">Both</asp:ListItem>
                                                <asp:ListItem>Yes</asp:ListItem>
                                                <asp:ListItem>No</asp:ListItem>

                                            </asp:DropDownList>
                                        </div>
                                </tr>

                            </table>
                        </div>

                        <div id="dvEditInvoice2" class="row">
                            <div class="card-body">
                                <table>
                                    <tr>

                                        <td class="style2" style="width: 380px; padding-left: 10px;">
                                            <table class="style1">
                                                <tr>
                                                    <td align="right">
                                                        <asp:CheckBox ID="chkjob1" runat="server" ForeColor="Black"
                                                            Font-Bold="true" Height="20px" Text=" Check All" CssClass="labelChange" />
                                                    </td>
                                                </tr>
                                            </table>
                                            <div style="padding-bottom: 10px; width: 379px; float: left; height: 450px;">
                                                <asp:Panel ID="Panel1" runat="server" BorderColor="#B6D1FB" BorderStyle="Solid"
                                                    BorderWidth="1px" class="panel_style" Height="600px" ScrollBars="Auto"
                                                    Width="500px">
                                                </asp:Panel>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
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
                    <rsweb:ReportViewer ID="ReportViewer1" Height="670px" Width="1150px"
                        Visible="false" runat="server" AsyncRendering="False"
                        InteractivityPostBackMode="AlwaysAsynchronous" CssClass="card-body">
                    </rsweb:ReportViewer>
                </div>
            </div>
        </div>
    </div>

</div>

