<%@ Control Language="C#" AutoEventWireup="true" CodeFile="All_Job_All_Client.ascx.cs"
    Inherits="controls_All_Job_All_Client" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit"
    TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl"
    TagPrefix="uc1" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%--<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />--%>
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
    var needstaff = false, needclient = false, needjob = true;
    $(document).ready(function () {
        //////////////////////////////////////////////////before report filter
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

        pageFiltersReset();

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

        ///////staff binding on date and timesheetstatus change
        $("[id*=txtstartdate1]").on("change", function () { pageFiltersReset(); });
        $("[id*=txtenddate2]").on("change", function () { pageFiltersReset(); });
        $("[id*=ddlStatus]").on("change", function () { pageFiltersReset(); });

        ////check all staff
        $("[id*=chkstaff]").on("click", function () {
            var check = $(this).is(':checked');

            $(".chkstaff").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
            //var check = $(this).attr('checked');
            //if ($(".clstaff").length == 0)
            //{ return false; }
            //$(".clstaff").each(function () {
            //    if (check)
            //    { $(this).attr('checked', 'checked'); }
            //    else { $(this).removeAttr('checked'); }
            //});

        });

        ///////check all client
        $("[id*=chkclient]").on("click", function () {

            var check = $(this).is(':checked');

            $(".clclient").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
            //if ($(".clclient").length == 0)
            //{ return false; }
            //var check = $(this).attr('checked');
            //$(".clclient").each(function () {
            //    if (check)
            //    { $(this).attr('checked', 'checked'); }
            //    else { $(this).removeAttr('checked'); }
            //});
            needstaff = true, needclient = false, needjob = false;
            BindPageLoadStaff();
        });

        /////////////check all job
        $("[id*=chkjob]").on("click", function () {
            var check = $(this).is(':checked');

            $(".cljob").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });

            //if ($(".cljob").length == 0)
            //{ return false; }
            //var check = $(this).attr('checked');
            //$(".cljob").each(function () {
            //    if (check)
            //    { $(this).attr('checked', 'checked'); }
            //    else { $(this).removeAttr('checked'); }
            //});
            needstaff = true, needclient = true, needjob = false;
         
            BindPageLoadStaff();
        });


        $("[id*=btngen]").on("click", function () {

            var staffcode = '';
            GetAllSelected();
            $(".clstaff:checked").each(function () {
                staffcode += $(this).val() + ',';
            });

            if (staffcode == '')
            { alert('Please select at least one Staff Name!'); return false; }
            $(".modalganesh").show();
        });

        ///////////////////////////////////////////////////after reportviewer load
        $("[id*=btnBack]").on("click", function () { $(".modalganesh").show(); });


    });
    function pad2(number) {
        return (number < 10 ? '0' : '') + number
    }


    function BindPageLoadStaff() {
        GetAllSelected();
        if (needjob)
        { $("[id*=hdnselectedjobid]").val('Empty'); $("[id*=hdnSelectedStaffCode]").val(''); }

        if ($("[id*=txtfrom]").val() == "" || $("[id*=txtfrom]").val() == undefined)
        { return false; }
        $(".modalganesh").show();
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                UserType: $("[id*=hdnUserType]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                StaffCode: $("[id*=hdnStaffCode]").val(),
                selectedstaffcode: $("[id*=hdnSelectedStaffCode]").val(),
                selectedclientid: $("[id*=hdnselectedclientid]").val(),
                selectedjobid: $("[id*=hdnselectedjobid]").val(),
                neetstaff: needstaff,
                neetclient: needclient,
                needjob: needjob,
                FromDate: $("[id*=txtfrom]").val(),
                ToDate: $("[id*=txtto]").val(),
                RType: 'job'
            }

        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/wsStaff.asmx/Bind_Staff_Client_Job_All_Selected",
            data: JSON.stringify(data),
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
        console.log(obj);
        var tableRowsstaff = '', tableRowsclient = '', tableRowsjob = '';
        var countstafff = 0, countclient = 0, countjob = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "staff") {
                countstafff += 1;
                tableRowsstaff += "<tr><td><input type='checkbox' checked='checked' onclick='singlestaffcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "client") {
                countclient += 1;
                tableRowsclient += "<tr><td><input type='checkbox' checked='checked'  onclick='singleclientcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "job") {
                countjob += 1;
                tableRowsjob += "<tr><td><input type='checkbox' onclick='singlejobcheck()'  class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });

        if (needclient) {

            if (countclient != 0)
                $("[id*=chkclient]").attr('checked', 'checked');
            else
                $("[id*=chkclient]").removeAttr('checked');

            $("[id*=chkclient]").parent().find('label').text("Client (" + countclient + ")");
            $("[id*=Panel2]").html("<table>" + tableRowsclient + "</table>");
        }
        if (needjob) {
            $("[id*=chkjob]").removeAttr('checked');
            $("[id*=chkjob]").parent().find('label').text("Job Name (" + countjob + ")");
            $("[id*=Panel3]").html("<table>" + tableRowsjob + "</table>");
        }
        if (needstaff) {

            if (countstafff != 0)
                $("[id*=chkstaff]").attr('checked', 'checked');
            else
                $("[id*=chkstaff]").removeAttr('checked');

            $("[id*=chkstaff]").parent().find('label').text(" Staff(Count : " + countstafff + ")");
            $("[id*=Panel1]").html("<table>" + tableRowsstaff + "</table>");
        }
        try { LabelChangeforall(); } catch (e) { console.log(e); }
        $(".modalganesh").hide();

    }

    ////check single staff
    function singlestaffcheck() {
        if ($(".clstaff").length == $(".clstaff:checked").length)
        { $("[id*=chkstaff]").attr('checked', true); }
        else { $("[id*=chkstaff]").removeAttr('checked'); }
    }
    //////check single client
    function singleclientcheck() {
        if ($(".clclient").length == $(".clclient:checked").length)
        { $("[id*=chkclient]").attr('checked', true); }
        else { $("[id*=chkclient]").removeAttr('checked'); }
        needstaff = true, needclient = false, needjob = false;
        BindPageLoadStaff();
    }
    //////check single job
    function singlejobcheck() {
        if ($(".cljob").length == $(".cljob:checked").length)
        { $("[id*=chkjob]").attr('checked', true); }
        else { $("[id*=chkjob]").removeAttr('checked'); }
        needstaff = true, needclient = true, needjob = false;

        try { LabelChangeforall(); } catch (e) { console.log(e); }
        BindPageLoadStaff();

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



    function GetAllSelected() {
        var selectStaff = '', selectclient = '', selectjob = '';
        $(".clstaff:checked").each(function () {
            selectStaff += $(this).val() + ',';
        });
        $(".clclient:checked").each(function () {
            selectclient += $(this).val() + ',';
        });
        $(".cljob:checked").each(function () {
            selectjob += $(this).val() + ',';
        });
        $("[id*=hdnSelectedStaffCode]").val(selectStaff);
        $("[id*=hdnselectedclientid]").val(selectclient);
        $("[id*=hdnselectedjobid]").val(selectjob);
    }

    function pageFiltersReset() {
        needstaff = false, needclient = false, needjob = true;
        $("[id*=chkstaff]").removeAttr('checked');
        $("[id*=chkstaff]").parent().find('label').text("Staff(0)");
        $("[id*=chkclient]").removeAttr('checked');
        $("[id*=chkclient]").parent().find('label').text("Client(0)");
        $("[id*=chkjob]").removeAttr('checked');
        $("[id*=chkjob]").parent().find('label').text("Job(Count : 0)");

        $("[id*=Panel1]").html('');
        $("[id*=Panel2]").html('');
        $("[id*=Panel3]").html('');
        try { LabelChangeforall(); } catch (e) { console.log(e); }
        BindPageLoadStaff();
    }
</script>
<style type="text/css">
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
</style>


<div class="page-content">
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnUserType" />
    <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="Empty" />
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

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">All Job All Client</span></h4>
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
                                        <table class="style1" width="100%">
                                            <tr>
                                                <td valign="middle">
                                                    <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From"
                                                        Font-Bold="True"></asp:Label>
                                                </td>
                                                <td align="center" valign="middle">:
                                                </td>
                                                <td valign="middle">
                                    
                                                     <input type="date" id="txtfrom" name="txtfrom" class="form-control" />
                                                </td>
                                                <td valign="middle">
                                                    <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To"
                                                        Font-Bold="True"></asp:Label>
                                                </td>
                                                <td align="center" valign="middle">:
                                                </td>
                                                <td valign="middle">
                               
                                                      <input type="date" id="txtto" name="txtto" class="form-control" />
                                                </td>
                                                <td>
                                                    <asp:Label Style="margin-left: 40px;" ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status"
                                                        Font-Bold="True"></asp:Label>
                                                </td>
                                                <td valign="middle" align="center">:
                                                </td>
                                                <td valign="middle" colspan="3">
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
                                                <td valign="middle">
                                                    <asp:Label ID="Label2" Style="margin-left: 50px;" runat="server" ForeColor="Black" Text="Report Type"
                                                        Font-Bold="True"></asp:Label>
                                                </td>
                                                <td align="center" valign="middle">:
                                                </td>
                                                <td valign="middle">
                                                    <asp:RadioButton runat="server" ID="rsummary" Text="Summarized"
                                                        Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                                        <asp:RadioButton runat="server" ID="rdetailed" Text="Detailed"
                                            GroupName="rbtn" />&nbsp;
                                                </td>
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
                                        <td style="width: 380px;">
                                            <asp:CheckBox ID="chkjob" runat="server" ForeColor="Black" Font-Bold="true"
                                                Height="20px" Text="Job (0)" CssClass="labelChange" />
                                            <div id="Panel3" style="border: 1px solid #B6D1FB; width: 95%; height: 400px; overflow: auto;">
                                            </div>
                                        </td>
                                        <td style="width: 380px;">
                                            <asp:CheckBox ID="chkclient" runat="server" ForeColor="Black"
                                                Font-Bold="true" Height="20px" Text="Client(0)" CssClass="labelChange" />
                                            <div id="Panel2" style="border: 1px solid #B6D1FB; width: 95%; height: 400px; overflow: auto;">
                                            </div>
                                        </td>
                                        <td style="width: 380px;">
                                            <asp:CheckBox ID="chkstaff" runat="server" ForeColor="Black"
                                                Font-Bold="true" Height="20px" Text="Staff(0)" CssClass="labelChange" />
                                            <div id="Panel1" style="border: 1px solid #B6D1FB; width: 95%; height: 400px; overflow: auto;">
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
                        <asp:Label ID="lblname" runat="server" Text="All Job All Client" Style="margin-left:0px;"></asp:Label>
                    </td>
                    <td style="float: right; padding-top: 5px; margin-left: 60px;">
                        <asp:Button ID="" runat="server" OnClick="btngen_Click" CssClass="cssButton"
                            Text="Generate Report" />
                    </td>
                    </tr>
                <tr>
                    <td style="float:left;">
                        <asp:Button ID="" runat="server" CssClass="cssButton" Text="Back"
                    Visible="false" OnClick="btnBack_Click" />
                    </td>
                </tr>
            </table>
           

        </div>
    </div>

    <div id="div2" class="totbodycatreg" style="height: 650px;">
        <div style="width: 100%;">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div class="row_report" runat="server" id="">
            <div>
                <table class="style1" style="padding-left:0px; padding-top: 20px; width: 100%;">
           
                    <tr>
                        <td colspan="20">
                       
                        </td>
                    </tr>
                </table>
            </div>
        </div>
  
    </div>
</div>--%>
