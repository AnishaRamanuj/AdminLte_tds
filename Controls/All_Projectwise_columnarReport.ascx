<%@ Control Language="C#" AutoEventWireup="true" CodeFile="All_Projectwise_columnarReport.ascx.cs" Inherits="controls_All_Projectwise_columnarReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<%--  new page created by Anil Gajre on 22/08/2017 for project wise columnar report monthly detail--%>

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

<%-- javascript starting--%>
<script type="text/javascript">
    $(document).ready(function () {
        $('.sidebar-main-toggle').click();
        var a = new Date();
        var dt = moment(a).format('YYYY-MM')
        $("[id*=dtmonth]").val(dt);
        $("[id*=hdnmonth]").val(dt);

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
        ////check all project
        $("[id*=chkAproject]").on("click", function () {
            var chkprop = $(this).is(':checked');

            $(".clProject").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            });

            singleprojectcheck();
        });
        ///////check all client
        $("[id*=chkAclient]").on("click", function () {
            var chkprop = $(this).is(':checked');

            $(".clclient").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            });

            singleclientcheck();
        });
        /////////check all staff
        $("[id*=chkAstaff]").on("click", function () {
            var chkprop = $(this).is(':checked');

            $(".clstaff").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            });

            singlestaffcheck();
        });

        /////////filter month wise
        $("[id*=dtmonth]").on("change", function () {
            $("[id*=hdnmonth]").val($("[id*=dtmonth]").val());
            Onpagefilterloads();
        });

        Onpagefilterloads();
        $("[id*=btngen]").on("click", function () {
            var selectStaff1 = '';
            $(".clstaff:checked").each(function () {
                selectStaff1 += $(this).val() + ',';
            });
            $("[id*=hdnstaffcode]").val(selectStaff1);
            GetAllSelected();
        });
        $("[id*=btnBack]").on("click", function () { $(".modalganesh").show(); });

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
        Onpagefilterloads();
    }

    ///////////////on page load data functions
    var clientwise = true, projectwise = false, staffwise = false;
    function Onpagefilterloads() {
        clientwise = true, projectwise = false, staffwise = false;
        $("[id*=chkAclient]").removeAttr('checked');
        $("[id*=lblCltcount]").html('0');
        $("[id*=chkAproject]").removeAttr('checked');
        $("[id*=lblProjcount]").html('0');
        $("[id*=chkAstaff]").removeAttr('checked');
        $("[id*=lblStaffcount]").html('0');

        $("[id*=tblClientName] tbody").empty();
        $("[id*=tblClientName] thead").empty();
        $("[id*=tblProjectName] tbody").empty();
        $("[id*=tblProjectName] thead").empty();
        $("[id*=tblStaffName] tbody").empty();
        $("[id*=tblStaffName] thead").empty();

        onpageclientProjectload();
    }
    function onpageclientProjectload() {
        GetAllSelected();
        if (clientwise) {
            $("[id*=hdncltid]").val('Empty');
            //$("[id*=hdnprojectid]").val('');
            $("[id*=hdnstaffcode]").val('');
        }
        //var compid = parseFloat($("[id*=hdnCompid]").val());
        var cltid = $("[id*=hdncltid]").val();
        var projectid = $("[id*=hdnprojectid]").val();
        var selectedstaffcode = $("[id*=hdnstaffcode]").val();
        if ($("[id*=dtmonth]").val() == "" || $("[id*=dtmonth]").val() == undefined) {
            return false;
        }

        Blockloadershow();

        var data = {
            currobj: {
                //compid: compid,
                UserType: $("[id*=hdnTypeU]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                StaffCode: $("[id*=hdnstaffid]").val(),
                selectedstaffcode: selectedstaffcode,
                selectetdcltid: cltid,
                selectedprojectid: projectid,
                staffwise: staffwise,
                clientwise: clientwise,
                projectwise: projectwise,
                frommonth: $("[id*=dtmonth]").val(),
                RType: 'client'
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Projectstaff.asmx/Bind_Staff_Client_Project_All_Selected",
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
        var tableRowsstaff = '', tableRowsclient = '', tableRowsProject = '';
        var countstafff = 0, countclient = 0, countProject = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "staff") {
                countstafff += 1;
                tableRowsstaff += "<tbody><tr><td><input type='checkbox' checked='checked' onclick='singlestaffcheck()' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
            else if (vl.Type == "client") {
                countclient += 1;
                tableRowsclient += "<tbody><tr><td><input type='checkbox'  onclick='singleclientcheck()' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
            else if (vl.Type == "Project") {
                countProject += 1;
                tableRowsProject += "<tbody><tr><td><input type='checkbox' onclick='singleprojectcheck()' checked='checked' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
        });

        if (clientwise) {
            $("[id*=chkAclient]").removeAttr('checked');


            $("[id*=lblCltcount]").html(countclient);
            $("[id*=tblClientName]").append(tableRowsclient);

        }
        if (projectwise) {

            if (countProject != 0)
                $("[id*=chkAproject]").attr('checked', 'checked');
            else
                $("[id*=chkAproject]").removeAttr('checked');

            $("[id*=lblProjcount]").html(countProject);
            $("[id*=tblProjectName]").empty();
            $("[id*=tblProjectName]").append(tableRowsProject);

        }
        if (staffwise) {
            if (countstafff != 0)
                $("[id*=chkAstaff]").attr('checked', 'checked');
            else
                $("[id*=chkAstaff]").removeAttr('checked');

            $("[id*=lblStaffcount]").html(countstafff);
            $("[id*=tblStaffName]").empty();
            $("[id*=tblStaffName]").append(tableRowsstaff);
        }
        Blockloaderhide();
    }

    ////check single staff
    function singlestaffcheck() {
        if ($(".clstaff").length == $(".clstaff:checked").length)
        { $("[id*=chkAstaff]").attr('checked', true); }
        else { $("[id*=chkAstaff]").removeAttr('checked'); }
    }
    //////check single client
    function singleclientcheck() {
        if ($(".clclient").length == $(".clclient:checked").length)
        { $("[id*=chkAclient]").attr('checked', true); }
        else { $("[id*=chkAclient]").removeAttr('checked'); }
        staffwise = true, clientwise = false, projectwise = true;
        onpageclientProjectload();
    }
    //////check single project
    function singleprojectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length)
        { $("[id*=chkAproject]").attr('checked', true); }
        else { $("[id*=chkAproject]").removeAttr('checked'); }
        staffwise = true, clientwise = false, projectwise = false;
        onpageclientProjectload();
    }


    function GetAllSelected() {
        var selectStaff = '', selectclient = '', selectproject = '';
        $(".clstaff:checked").each(function () {
            selectStaff += $(this).val() + ',';
        });
        $(".clclient:checked").each(function () {
            selectclient += $(this).val() + ',';
        });
        $(".clProject:checked").each(function () {
            selectproject += $(this).val() + ',';
        });
        $("[id*=hdnstaffcode]").val(selectStaff);
        $("[id*=hdncltid]").val(selectclient);
        $("[id*=hdnprojectid]").val(selectproject);
    }


</script>

<style type="text/css">
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


<div class="page-content">
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdncltid" />
    <asp:HiddenField runat="server" ID="hdnprojectid" />
    <asp:HiddenField runat="server" ID="hdnstaffcode" />
    <asp:HiddenField runat="server" ID="hdnTypeU" />
    <asp:HiddenField runat="server" ID="hdnstaffid" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
    <asp:HiddenField runat="server" ID="hdnmonth" />
     <div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>				
						
</div>

            <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-left: 1rem;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Projectwise Staff Columnar Report</span></h5>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

                <asp:Button ID="btngen" runat="server" OnClick="btngen_Click" CssClass="btn bg-success legitRipple"
                    Text="Generate Report" />



                <asp:Button ID="btnBack" runat="server" CssClass="btn bg-primary legitRipple" Text="Back" Visible="false" OnClick="btnBack_Click" />

            </div>

        </div>
        <div class="content">
            <div class="divstyle card">
                <div id="" class="totbodycatreg" style="height: 700px;">
                    <div style="width: 100%;">
                        <uc2:MessageControl ID="MessageControl1" runat="server" />
                    </div>
                    <div class="row_report " runat="server" id="divReportInput">
                        <%--<div class="card-body">

                            <table width="100%;" style="padding-left: 55px; padding-top: 15px;">
                                <tr>
                                    <td valign="middle">
                                        <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td valign="middle" align="center">:
                                    </td>
                                    <td valign="middle">
                                   
                                    </td>
                                    <td>&nbsp;</td>

                                    <td valign="middle">
                                        <label style="font-weight: bold">Month</label></td>
                                    <td>:</td>
                                    <td style="width: 200px;">
                                       

                                    </td>

                                </tr>

                            </table>
                        </div>--%>
                        <div class="datatable-header">
                            <div id="DataTables_Table_1_filter" class="form-group row">
                                <div class="col-2">
                                    <asp:Label ID="Label1" runat="server" ForeColor="Black" Text="Timesheet Status"
                                        Font-Bold="True"></asp:Label>
                                </div>

                                <div class="col-4">
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

                                </div>
                                <div class="col-1">
                                    <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Month"
                                        Font-Bold="True"></asp:Label>
                                </div>
                                <div class="col-3">
                                    <input type="month" style="width: 155px;padding-bottom:20px;" class="form-control" id="dtmonth" name="dtmonth" />
                                </div>

                            </div>

                        </div>



                        <div id="dvEditInvoice2" class="row">
                            <div class="col-md-4">

                                <!-- Grey background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold"><i class="icon-user-check mr-2"></i>
                                            <input type="checkbox" class="Chkbox" id="chkAclient" name="chkAclient" />Client <span id="lblCltcount" name="lblCltcount" class="badge badge-success badge-pill Spancount">0</span></h6>
                                        <div class="header-elements">
                                            <div class="list-icons">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card-body">
                                        <div class="form-group row">
                                            <div style="height: 450px; width: 100%; overflow-y: scroll;">
                                                <table id="tblClientName" name="tblClientName" class="table table-hover table-xs font-size-base"></table>
                                            </div>
                                        </div>


                                    </div>

                                </form>
                                <!-- /grey background, left button spacing -->



                            </div>
                            <div class="col-md-4">

                                <!-- White background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold">
                                            <input type="checkbox" class="Chkbox" id="chkAproject" name="chkAproject" />Project <span id="lblProjcount" name="lblProjcount" class="badge badge-success badge-pill Spancount">0</span></h6>
                                        <div class="header-elements">
                                            <div class="list-icons">
                                            </div>
                                        </div>
                                    </div>



                                    <div class="card-body">
                                        <div class="form-group row">
                                            <div style="height: 450px; width: 100%; overflow-y: scroll;">
                                                <table id="tblProjectName" name="tblProjectName" class="table table-hover table-xs font-size-base"></table>
                                            </div>
                                        </div>


                                    </div>



                                </form>
                                <!-- /white background, left button spacing -->


                            </div>
                            <div class="col-md-4">

                                <!-- White background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold">
                                            <input type="checkbox" class="Chkbox" id="chkAstaff" name="chkAstaff" />Staff <span id="lblStaffcount" name="lblStaffcount" class="badge badge-success badge-pill Spancount">0</span></h6>
                                        <div class="header-elements">
                                            <div class="list-icons">
                                            </div>
                                        </div>
                                    </div>



                                    <div class="card-body">
                                        <div class="form-group row">
                                            <div style="height: 450px; width: 100%; overflow-y: scroll;">
                                                <table id="tblStaffName" name="tblStaffName" class="table table-hover table-xs font-size-base"></table>
                                            </div>
                                        </div>


                                    </div>



                                </form>
                                <!-- /white background, left button spacing -->


                            </div>

                        </div>


                    </div>

                    <rsweb:ReportViewer ID="ReportViewer1" CssClass="card" Height="670px" Width="1144px"
                        Visible="false" runat="server" AsyncRendering="False"
                        InteractivityPostBackMode="AlwaysAsynchronous">
                    </rsweb:ReportViewer>
                </div>
            </div>
        </div>









