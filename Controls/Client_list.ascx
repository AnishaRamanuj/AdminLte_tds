<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Client_list.ascx.cs" Inherits="controls_Client_list" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

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
        BindPageLoadClient();



        $("[id*=btngen]").on("click", function () {

            var staffcode = '';
            $(".chkItems:checked").each(function () {
                staffcode += $(this).val() + ',';
            });

            if (staffcode == '')
            { alert('Please select at least one Client !'); return false; }
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





        $("[id*=ddlStatus]").on("change", function () { BindPageLoadClient(); });
    });

    function BindPageLoadClient() {
        $(".modalganesh").show();
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/wsStaff.asmx/BindClientList",
            data: "{compid:0}",
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        //Ajax end
    }

    function Onchkitemcheck() {
        if ($("input[type=checkbox][class*=chkItems]").length == $("input[type=checkbox][class*=chkItems]:checked").length)
        { $("[id*=chkjob1]").attr('checked', 'checked'); }
        else { $("[id*=chkjob1]").removeAttr('checked'); }
        try { LabelChangeforall(); } catch (e) { console.log(e); }
    }
    function OnSuccess(response) {
        var obj = jQuery.parseJSON(response.d);
        var tableRows = '';
        $("[id*=chkjob1]").parent().find('label').text("Check All Client Name (Count : " + obj.length + ")");
        $.each(obj, function (i, vl) {
            tableRows += "<tr><td><input type='checkbox' onclick='Onchkitemcheck()' class='chkItems' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
        });
        $("[id*=chkjob1]").removeAttr('checked');
        $("[id*=Panel1]").html("<table>" + tableRows + "</table>");
        $(".modalganesh").hide();
        try { LabelChangeforall(); } catch (e) { console.log(e); }
    }
</script>




    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnUserType" />
    <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
<div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>				
						
</div>
            <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-left: 1rem;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Client List</span></h5>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

             
                <asp:Button ID="btngen" runat="server" OnClick="btngen_Click" CssClass="btn bg-success legitRipple" Text="Generate Report" />


                <asp:Button ID="btnBack" runat="server" CssClass="btn btn-primary legitRipple" Text="Back"
                    Visible="false" OnClick="btnBack_Click" />
            </div>

     

        <div class="content">
            <div class="divstyle card">
                <div id="" class="totbodycatreg" style="height: 700px;">
                    <div style="width: 100%;">
                        <uc1:MessageControl ID="MessageControl1" runat="server" />
                    </div>
                    <div class="row_report " runat="server" id="divReportInput">
                        <div class="card-body">
                            <table class="style1" style="float: left; padding-left: 55px;">
                                <tr>
                                    <td class="style2" style="width: 380px; padding-left: 10px;">
                                        <table class="style1">
                                            <tr>
                                                <td align="right">
                                                    <asp:CheckBox ID="chkjob1" runat="server" ForeColor="Black" Font-Bold="true"
                                                        Height="20px" Text=" Check All" CssClass="labelChange" />
                                                </td>
                                            </tr>
                                        </table>
                                        <div style="padding-bottom: 10px; width: 379px; float: left; height: 450px;">
                                            <asp:Panel ID="Panel1" runat="server" BorderColor="#B6D1FB" BorderStyle="Solid"
                                                BorderWidth="1px" class="panel_style" Height="600px" ScrollBars="Auto"
                                                Width="352px">
                                            </asp:Panel>
                                        </div>
                                    </td>
                               
                                </tr>
                            </table>
                        </div>
                    </div>
                    <rsweb:ReportViewer ID="ReportViewer1" Height="670px" Width="99%"
                        Visible="false" runat="server" AsyncRendering="False" InteractivityPostBackMode="AlwaysAsynchronous">
                    </rsweb:ReportViewer>

                </div>
            </div>
        </div>
   







