<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Report_JobGroupWise.ascx.cs" Inherits="controls_Report_JobGroupWise" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="../controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
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
<script type="text/javascript" language="javascript">
    var needJobGrp = true; var needJob = false; var needClient = false;
    $(document).ready(function () {
        $('.sidebar-main-toggle').click();
        $("[id*= txtfrom]").val($("[id*= hdnFrom]").val());
        $("[id*= txtto]").val($("[id*= hdnTo]").val());

        $("[id*= txtfrom]").on('change', function () {
            $("[id*= hdnFrom]").val($("[id*= txtfrom]").val());
            pageFiltersReset();
        });

        $("[id*= txtto]").on('change', function () {
            $("[id*= hdnTo]").val($("[id*= txtto]").val());
            pageFiltersReset();
        });

        //$("[id*=txtstartdate1]").on('change', function () {
           
        //});

        //$("[id*=txtenddate2]").on('change', function () {
        //    pageFiltersReset();
        //});

        $("[id*=chkJobGrp]").on("click", function () {
            var check = $(this).is(':checked');

            $(".clJobGrp").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
  
            singleJobGroupcheck();
           
        });

        $("[id*=chkjob]").on("click", function () {
          
            var check = $(this).is(':checked');

            $(".clJob").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
        
 
            singlejobcheck();
          
        });

        $("[id*=chkclient]").on("click", function () {
            var check = $(this).is(':checked');
            $(".clclient").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });

            singleclientcheck();
         
        });

        $("[id*=btngen]").on("click", function () {

            var staffcode = '';
            GetAllSelected();
            $(".clclient:checked").each(function () {
                staffcode += $(this).val() + ',';
            });

            if (staffcode == '')
            { alert('Please select at least one Client Name!'); return false; }
            $(".modalganesh").show();
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
        pageFiltersReset();
    });
    ////////////// on page load Data on 21/05/2018
    function pageFiltersReset() {
        needJobGrp = true; needJob = false; needClient = false;
        $("[id*=chkJobGrp]").removeAttr('checked');
        $("[id*=chkJobGrp]").parent().find('label').text("Check All Job Groups (Count : 0)");
        $("[id*=chkclient]").removeAttr('checked');
        $("[id*=chkclient]").parent().find('label').text("Check All Client Name (Count : 0)");
        $("[id*=chkjob]").removeAttr('checked');
        $("[id*=chkjob]").parent().find('label').text("Check All Job Name (Count : 0)");

        $("[id*=Panel1]").html('');
        $("[id*=Panel2]").html('');
        $("[id*=Panel3]").html('');
        PageLoadData();
    }

    function PageLoadData() {
        GetAllSelected();
        if (needJobGrp) {
            $("[id*=hdnselectedclientid]").val('');
            $("[id*=hdnselectedjobid]").val('');
            $("[id*=hdnSelectedJobGrp]").val('Empty');
        }
        $(".modalganesh").show();

        var data = {
            currobj: {

                compid: $("[id*=hdnCompid]").val(),
                UserType: $("[id*=hdnUserType]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                StaffCode: $("[id*=hdnStaffCode]").val(),
                selectedJobGrp: $("[id*=hdnSelectedJobGrp]").val(),
                selectedclientid: $("[id*=hdnselectedclientid]").val(),
                selectedjobid: $("[id*=hdnselectedjobid]").val(),
                needJobGrp: needJobGrp,
                neetclient: needClient,
                needjob: needJob,
                FromDate: $("[id*=txtfrom]").val(),
                ToDate: $("[id*=txtto]").val(),
                RType: 'JobGrp'
            }
        };


        //////ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/wsStaff.asmx/Bind_JobGroup_Job_Client_All_Selected",
            data: JSON.stringify(data),
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        ///////ajax End
        $(".modalganesh").hide();

    }


    function OnSuccess(response) {
        var myList = jQuery.parseJSON(response.d);
        var CountJobGrp = 0, CountJob = 0, CountClient = 0;
        var JobGrpTr = '', JobTr = '', ClientTr = '';
        $.each(myList, function (i, vl) {
            if (vl.Type == "JobGrp") {
                JobGrpTr += "<tr><td><input type='checkbox' onclick='singleJobGroupcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
                CountJobGrp += 1;
            }
            else if (vl.Type == "client") {
                CountClient += 1;
                ClientTr += "<tr><td><input type='checkbox' checked='checked'  onclick='singleclientcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "Job") {
                CountJob += 1;
                JobTr += "<tr><td><input type='checkbox' checked='checked' onclick='singlejobcheck()'  class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });
        if (needJobGrp) {
            $("[id*=chkJobGrp]").parent().find('label').text("Check All Job Group (Count : " + CountJobGrp + ")");
            $("[id*=Panel1]").html("<table>" + JobGrpTr + "</table>");
        }
        if (needJob) {
            if (CountJob != 0)
                $("[id*=chkjob]").attr('checked', 'checked');

            else
                $("[id*=chkjob]").removeAttr('checked');

            $("[id*=chkjob]").parent().find('label').text("Check All Job (Count : " + CountJob + ")");
            $("[id*=Panel2]").html("<table>" + JobTr + "</table>");
        }

        if (needClient) {
            if (CountClient != 0)
                $("[id*=chkclient]").attr('checked', 'checked');

            else
                $("[id*=chkclient]").removeAttr('checked');

            $("[id*=chkclient]").parent().find('label').text("Check All clients (Count : " + CountClient + ")");
            $("[id*=Panel3]").html("<table>" + ClientTr + "</table>");

        }
    }

    function singleJobGroupcheck() {
        if ($(".clJobGrp").length == $(".clJobGrp:checked").length)
        { $("[id*=chkJobGrp]").attr('checked', true); }
        else { $("[id*=chkJobGrp]").removeAttr('checked'); }
        needJobGrp = false; needJob = true; needClient = true;
        PageLoadData();
    }
    function singleclientcheck() {
        if ($(".clclient").length == $(".clclient:checked").length)
        { $("[id*=chkclient]").attr('checked', true); }
        else { $("[id*=chkclient]").removeAttr('checked'); }
    }
    function singlejobcheck() {
        if ($(".clJob").length == $(".clJob:checked").length)
        { $("[id*=chkjob]").attr('checked', true); }
        else { $("[id*=chkjob]").removeAttr('checked'); }
        needJobGrp = false; needJob = false; needClient = true;
        PageLoadData();
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
        pageFiltersReset();
    }


    //////////////////////get All Data Selected values anil on 21/05/2018 4 pm
    function GetAllSelected() {

        var selectJobGrp = '', selectclient = '', selectjob = '';
        $(".clJobGrp:checked").each(function () {
            selectJobGrp += $(this).val() + ',';
        });
        $(".clclient:checked").each(function () {
            selectclient += $(this).val() + ',';
        });
        $(".clJob:checked").each(function () {
            selectjob += $(this).val() + ',';
        });
        $("[id*=hdnSelectedJobGrp]").val(selectJobGrp);
        $("[id*=hdnselectedclientid]").val(selectclient);
        $("[id*=hdnselectedjobid]").val(selectjob);
    }

</script>


<div class="page-content">
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnUserType" />
    <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="Empty" />
    <asp:HiddenField runat="server" ID="hdnSelectedJobGrp" Value="Empty" />
    <asp:HiddenField runat="server" ID="hdnselectedclientid" />
    <asp:HiddenField runat="server" ID="hdnselectedjobid" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
    <asp:HiddenField runat="server" ID="hdnFrom" />
    <asp:HiddenField runat="server" ID="hdnTo" />
    <div class="content-wrapper">
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">JobGroup Wise Report</span></h4>
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
                                                    <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From" Font-Bold="True"></asp:Label>
                                                </td>
                                                <td align="center" valign="middle">:
                                                </td>
                                                <td valign="middle">
                                               <%--     <asp:TextBox ID="txtstartdate1" runat="server" CssClass="texboxcls"></asp:TextBox>
                                                    <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" />
                                                    <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                                                    <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtstartdate1"
                                                        PopupButtonID="Img1" Format="dd/MM/yyyy">
                                                    </cc1:CalendarExtender>--%>
                                                     <input type="date" id="txtfrom" name="txtfrom" class="form-control" />
                                                </td>
                                                <td valign="middle">
                                                    <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To" Font-Bold="True"></asp:Label>
                                                </td>
                                                <td align="center" valign="middle">:
                                                </td>
                                                <td valign="middle">
                                                   <%-- <asp:TextBox ID="txtenddate2" runat="server" CssClass="texboxcls"></asp:TextBox>
                                                    <asp:Image ID="Img2" runat="server" ImageUrl="~/images/calendar.png" />
                                                    <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                                                    <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtenddate2"
                                                        PopupButtonID="Img2" Format="dd/MM/yyyy">
                                                    </cc1:CalendarExtender>--%>
                                                    <input type="date" id="txtto" name="txtto" class="form-control" />
                                                </td>
                                                <td valign="middle">
                                                    <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status" Font-Bold="True"></asp:Label>
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
                                            <tr>
                                                <td colspan="6"></td>
                                                <td valign="middle">
                                                    <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Report Type" Font-Bold="True"></asp:Label>
                                                </td>
                                                <td align="center" valign="middle">:
                                                </td>
                                                <td valign="middle">
                                                    <asp:RadioButton runat="server" ID="rsummary" Text="Summarized" Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                                            <asp:RadioButton runat="server" ID="rdetailed" Text="Detailed" GroupName="rbtn" />&nbsp;
                                                </td>
                                                <td></td>
                                                <td width="60px;"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>

                            </table>
                        </div>



                        <div id="dvEditInvoice2" class="row">
                            <div class="card-body">
                                <table>
                                    <tr>
                                        <td style="width: 250px;">
                                            <asp:CheckBox ID="chkJobGrp" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                                Text=" Check All Job Group (Count : 0)" CssClass="labelChange" />
                                            <div id="Panel1" style="border: 1px solid #B6D1FB; width: 333px; height: 500px; overflow: auto;">
                                            </div>
                                        </td>
                                        <td style="width: 250px;">
                                            <asp:CheckBox ID="chkjob" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                                Text=" Check All Job Name (Count : 0)" CssClass="labelChange" />
                                            <div id="Panel2" style="border: 1px solid #B6D1FB; width: 333px; height: 500px; overflow: auto;">
                                            </div>
                                        </td>
                                        <td style="width: 250px;">
                                            <asp:CheckBox ID="chkclient" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                                Text=" Check All Client Name (Count : 0)" CssClass="labelChange" />
                                            <div id="Panel3" style="border: 1px solid #B6D1FB; width: 333px; height: 500px; overflow: auto;">
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

                    <rsweb:ReportViewer ID="ReportViewer1" Height="670px" Width="1200px" Visible="false"
                        runat="server" AsyncRendering="False" InteractivityPostBackMode="AlwaysAsynchronous" CssClass="card-body">
                    </rsweb:ReportViewer>
                </div>
            </div>
        </div>
    </div>

</div>

