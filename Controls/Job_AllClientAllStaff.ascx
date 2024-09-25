<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Job_AllClientAllStaff.ascx.cs" Inherits="controls_Job_AllClientAllStaff" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
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
    var needstaff = true, needclient = false, needjob = false;
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
        //////////////////////////////////////////////////before report filter
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

        $("[id*=ddlStatus]").on("change", function () { pageFiltersReset(); });

        ////check all staff
        $("[id*=chkstaff]").on("click", function () {
            var check = $(this).is(':checked');
            if ($(".clstaff").length == 0)
            { return false; }
            $(".clstaff").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
            needstaff = false, needclient = true, needjob = true;
            BindPageLoadStaff();
        });

        ///////check all client
        $("[id*=chkclient]").on("click", function () {

            var check = $(this).is(':checked');
            $(".clclient").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
            needstaff = false, needclient = false, needjob = true;
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
        });


        $("[id*=btngen]").on("click", function () {

            var staffcode = '';
            GetAllSelected();
            $(".cljob:checked").each(function () {
                staffcode += $(this).val() + ',';
            });

            if (staffcode == '')
            { alert('Please select at least one Job Name!'); return false; }
            $(".modalganesh").show();
        });


        ///////////////////////////////////////////////////after reportviewer load
        $("[id*=btnBack]").on("click", function () { $(".modalganesh").show(); });


    });


    function BindPageLoadStaff() {
        GetAllSelected();
        if (needstaff)
        { $("[id*=hdnSelectedStaffCode]").val('Empty'); $("[id*=hdnselectedjobid]").val(''); }
        if ($("[id*=txtfrom]").val() == "" || $("[id*=txtfrom]").val() == undefined)
        { return false; }
        Blockloadershow();
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
                RType: 'Staff'
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
    function checkAdult(obj) {
        return obj.Type.size;
    }
    function OnSuccess(response) {
        var obj = jQuery.parseJSON(response.d);
        var tableRowsstaff = '', tableRowsclient = '', tableRowsjob = '';
        var countstafff = 0, countclient = 0, countjob = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "staff") {
                countstafff += 1;
                tableRowsstaff += "<tr><td><input type='checkbox' onclick='singlestaffcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "client") {
                countclient += 1;
                tableRowsclient += "<tr><td><input type='checkbox' checked='checked' onclick='singleclientcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "job") {
                countjob += 1;
                tableRowsjob += "<tr><td><input type='checkbox' onclick='singlejobcheck()' checked='checked' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });
        if (needstaff) {
            $("[id*=chkstaff]").removeAttr('checked');
            $("[id*=chkstaff]").parent().find('label').text("Check All Staff Name (Count : " + countstafff + ")");
            $("[id*=Panel1]").html("<table>" + tableRowsstaff + "</table>");
        }
        if (needclient) {
            if (countclient != 0)
                $("[id*=chkclient]").attr('checked', 'checked');
            else
                $("[id*=chkclient]").removeAttr('checked');

            $("[id*=chkclient]").parent().find('label').text("Check All Client Name (Count : " + countclient + ")");
            $("[id*=Panel2]").html("<table>" + tableRowsclient + "</table>");
        }
        if (needjob) {
            if (countjob != 0)
                $("[id*=chkjob]").attr('checked', 'checked');
            else
                $("[id*=chkjob]").removeAttr('checked');

            $("[id*=chkjob]").parent().find('label').text("Check All Job Name (Count : " + countjob + ")");
            $("[id*=Panel3]").html("<table>" + tableRowsjob + "</table>");
        }
        try { LabelChangeforall(); } catch (e) { console.log(e); }
        Blockloaderhide();
    }

    ////check single staff
    function singlestaffcheck() {
        if ($(".clstaff").length == $(".clstaff:checked").length)
        { $("[id*=chkstaff]").attr('checked', true); }
        else { $("[id*=chkstaff]").removeAttr('checked'); }
        needstaff = false, needclient = true, needjob = true;
        BindPageLoadStaff();
    }
    //////check single client
    function singleclientcheck() {
        if ($(".clclient").length == $(".clclient:checked").length)
        { $("[id*=chkclient]").attr('checked', true); }
        else { $("[id*=chkclient]").removeAttr('checked'); }
        needstaff = false, needclient = false, needjob = true;
        BindPageLoadStaff();
    }
    //////check single job
    function singlejobcheck() {
        if ($(".cljob").length == $(".cljob:checked").length)
        { $("[id*=chkjob]").attr('checked', true); }
        else { $("[id*=chkjob]").removeAttr('checked'); }
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
        needstaff = true, needclient = false, needjob = false;
        $("[id*=chkstaff]").removeAttr('checked');
        $("[id*=chkstaff]").parent().find('label').text("Check All Staff Name (Count : 0)");
        $("[id*=chkclient]").removeAttr('checked');
        $("[id*=chkclient]").parent().find('label').text("Check All Client Name (Count : 0)");
        $("[id*=chkjob]").removeAttr('checked');
        $("[id*=chkjob]").parent().find('label').text("Check All Job Name (Count : 0)");

        $("[id*=Panel1]").html('');
        $("[id*=Panel2]").html('');
        $("[id*=Panel3]").html('');
        BindPageLoadStaff();
    }
</script>

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

    <div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>				
						
</div>
    

            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">All Staff All Client</span></h4>
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
                                                <td valign="middle">
                                                    <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status"
                                                        Font-Bold="True"></asp:Label>
                                                </td>
                                                <td valign="middle" align="center">:
                                                </td>
                                                <td valign="middle" colspan="3">
                                                    <asp:CheckBox ID="chkTStatusAll" ClientIDMode="Static" runat="server"
                                                        Checked="true" Text="All" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server"
                                            Checked="true" onclick="TStatusCheck()" Text="Submitted" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static"
                                            Checked="true" onclick="TStatusCheck()" Text="Saved" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()"
                                            Checked="true" ClientIDMode="Static" Text="Approved" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()"
                                            Checked="true" ClientIDMode="Static" Text="Rejected" />
                                                </td>

                                            </tr>
                                            <tr>
                                                <td colspan="6"></td>
                                                <td valign="middle">
                                                    <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Report Type"
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
                                            <asp:CheckBox ID="chkstaff" runat="server" ForeColor="Black"
                                                Font-Bold="true" Height="20px" Text=" Check All" CssClass="labelChange" />
                                            <div id="Panel1" style="border: 1px solid #B6D1FB; width: 95%; height: 550px; overflow: auto;">
                                            </div>
                                        </td>
                                        <td style="width: 380px;">
                                            <asp:CheckBox ID="chkclient" runat="server" ForeColor="Black"
                                                Font-Bold="true" Height="20px" Text=" Check All Client Name (Count : 0)" CssClass="labelChange" />
                                            <div id="Panel2" style="border: 1px solid #B6D1FB; width: 95%; height: 550px; overflow: auto;">
                                            </div>
                                        </td>
                                        <td style="width: 380px;">
                                            <asp:CheckBox ID="chkjob" runat="server" ForeColor="Black" Font-Bold="true"
                                                Height="20px" Text=" Check All Job Name (Count : 0)" CssClass="labelChange" />
                                            <div id="Panel3" style="border: 1px solid #B6D1FB; width: 95%; height: 550px; overflow: auto;">
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>

                        </div>

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
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="Label1" runat="server" CssClass="Head1 labelChange" Text="All Staff All Client"></asp:Label>
            <div style="float: right;">
                <asp:Button ID="btnBack" runat="server" CssClass="TbleBtns" Text="Back"
                    Visible="false" OnClick="btnBack_Click" />
            </div>

        </div>
    </div>
    <div id="div2" class="totbodycatreg" style="height: 700px;">
        <div style="width: 100%;">
     
        </div>
        <div class="row_report" runat="server" id="divReportInput">
            <div>
              
            </div>
        </div>

    </div>
</div>--%>
