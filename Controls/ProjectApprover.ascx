<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProjectApprover.ascx.cs" Inherits="controls_ProjectApprover" %>
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

<script type="text/javascript">
    var needproject = true, needstaff = false;
    $(document).ready(function () {
        $('.sidebar-main-toggle').click();
        $("[id*= txtfrom]").val($("[id*= hdnFrom]").val());
        $("[id*= txtto]").val($("[id*= hdnTo]").val());

        pageFiltersReset();



        $("[id*=txtfrom]").on('change', function () {
            pageFiltersReset();
        });

        $("[id*=txtto]").on('change', function () {
            pageFiltersReset();
        });

        $("[id*=chkTStatusAll]").on("click", function () {
            if ($(this).attr('checked')) {
                $("[id*=chkSubmitted]").attr('checked', 'checked');
                $("[id*=chkSaved]").attr('checked', 'checked');
                $("[id*=chkApproved]").attr('checked', 'checked');
            }
            else {
                $("[id*=chkSubmitted]").removeAttr('checked');
                $("[id*=chkSaved]").removeAttr('checked');
                $("[id*=chkApproved]").removeAttr('checked');
            }
            TStatusCheck();
        });

        ////check all Project
        $("[id*=chkProject]").on("click", function () {

            if ($(".clProject").length == 0) {
                return false;
            }
            var check = $(this).is(':checked');
            $(".clProject").each(function () {
                if (check) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked');
                }

            });
            needproject = false, needstaff = true;
            GetPrpject_Staff();
        });

        ////check all Stff
        $("[id*=chkStaff]").on("click", function () {
            var check = $(this).is(':checked');
            if ($(".clStaff").length == 0) {
                return false;
            }
            $(".clStaff").each(function () {
                if (check) {
                    $(this).attr('checked', 'checked');
                }
                else { $(this).removeAttr('checked'); }
            });
        });


        $("[id*=btngen]").on("click", function () {
            $("[id*= hdnFrom]").val($("[id*= txtfrom]").val());
            $("[id*= hdnTo]").val($("[id*= txtto]").val());
        });


    });

    function pageFiltersReset() {
        needproject = true, needclient = false;
        $("[id*=chkProject]").removeAttr('checked');

        $("[id*=chkStaff]").removeAttr('checked');

        $("[id*=tblStaffname] tbody").empty();
        $("[id*=tblStaffname] thead").empty();
        $("[id*=tblProjectName] tbody").empty();
        $("[id*=tblProjectName] thead").empty();

        $("[id*=lblProjcount]").html('0');
        $("[id*=lblStaffcount]").html('0');
        GetPrpject_Staff();
    }

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

        if (count == 3)
        { $("[id*=chkTStatusAll]").attr('checked', 'checked'); }
        else { $("[id*=chkTStatusAll]").removeAttr('checked'); }

        if (selectedTStatus == '') {
            $("[id*=chkApproved]").attr('checked', 'checked');
            selectedTStatus = 'Approved';
        }
        $("[id*=hdnTStatusCheck]").val(selectedTStatus);
        pageFiltersReset();
    }

    function GetPrpject_Staff() {
        GetAllSelected();
        var compid = $("[id*=hdnCompanyID]").val();
        //var Date = $("[id*=txtdateBindStaff]").val();
        //Date = Date.split('-');
        var Start = $("[id*=txtfrom]").val();
        var end = $("[id*=txtto]").val();
        var Projectid = $("[id*=hdnselectedProject]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/JobAllocationHours.asmx/GetProjStaffreport",
            data: '{compid:' + compid + ',Start:"' + Start + '",end:"' + end + '",needproject:"' + needproject + '",needstaff:"' + needstaff + '",Projectid:"' + Projectid + '",TStatus:"' + $("[id*=hdnTStatusCheck]").val() + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: OnSuccess,
            failure: function (response) {

            },
            error: function (response) {

            }
        });
    }

    function OnSuccess(response) {
        var obj = jQuery.parseJSON(response.d);
        console.log(obj);
        var tableRowsProj = '', tableRowsclt = '';
        var countProj = 0, countClt = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "Project") {
                countProj += 1;
                tableRowsProj += "<tbody><tr><td><input type='checkbox' onclick='singleProjectcheck()' class='cl" + vl.Type + " Chkbox' value='" + vl.Id + "' /></td><td>" + vl.Name + "</td></tr></tbody>";
            }
            else if (vl.Type == "Staff") {
                countClt += 1;
                tableRowsclt += "<tbody><tr><td><input type='checkbox' checked='checked' onclick='singleclient()'  class='cl" + vl.Type + " Chkbox' value='" + vl.Id + "' /></td><td>" + vl.Name + "</td></tr></tbody>";
            }
        });
        if (needproject) {
            //$("[id*=chkProject]").removeAttr('checked');
            //$("[id*=chkProject]").parent().find('label').text("Check All Project Name (Count : " + countProj + ")");
            //$("[id*=Panel1]").html("<table>" + tableRowsProj + "</table>");

            $("[id*=lblProjcount]").html(countProj);
            $("[id*=tblProjectName]").append(tableRowsProj);
        }
        if (needstaff) {
            if (countClt != 0)

                $("[id*=chkStaff]").attr('checked', 'checked');
            else
                $("[id*=chkStaff]").removeAttr('checked');
            //$("[id*=chkStaff]").parent().find('label').text("Check All Staff Name (Count : " + countClt + ")");
            //$("[id*=Panel2]").html("<table>" + tableRowsclt + "</table>");

            $("[id*=lblStaffcount]").html(countClt);
            $("[id*=tblStaffname]").append(tableRowsclt);
        }
        GetAllSelected();
    }

    //////check single Project
    function singleProjectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length) {
            $("[id*=chkProject]").attr('checked', true);
        }
        else {
            $("[id*=chkProject]").removeAttr('checked');
        }
        needproject = false, needstaff = true;
        GetPrpject_Staff();
    }

    function GetAllSelected() {
        var selectClient = '', selectProject = '';
        $(".clProject:checked").each(function () {
            selectProject += $(this).val() + ',';
        });
        $(".clStaff:checked").each(function () {
            selectClient += $(this).val() + ',';
        });
        $("[id*=hdnselectedProject]").val(selectProject);

        $("[id*=hdnselectedStaff]").val(selectClient);
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


    .allTimeSheettle tr:hover {
        cursor: inherit;
        background: #F2F2F2;
        border: 1px solid #ccc;
        padding: 5px;
        color: #474747;
    }

    .allTimeSheettle {
        cursor: pointer;
    }

    .Pager b {
        margin-top: 2px;
        float: left;
    }

    .Pager span {
        text-align: center;
        display: inline-block;
        width: 20px;
        margin-right: 3px;
        line-height: 150%;
        border: 1px solid #BCBCBC;
    }

    .Pager a {
        text-align: center;
        display: inline-block;
        width: 20px;
        background-color: #BCBCBC;
        color: #fff;
        border: 1px solid #BCBCBC;
        margin-right: 3px;
        line-height: 150%;
        text-decoration: none;
    }
</style>


<div class="page-content">
    <asp:HiddenField ID="hdnCompanyID" runat="server" />
    <asp:HiddenField ID="hdnselectedProject" runat="server" />
    <asp:HiddenField ID="hdnselectedStaff" runat="server" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved" />
    <asp:HiddenField ID="hdnPages" runat="server" />
    <asp:HiddenField runat="server" ID="hdnFrom" />
    <asp:HiddenField runat="server" ID="hdnTo" />
    <div class="content-wrapper">
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Project Staff Hours Report</span></h4>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

                <asp:Button ID="btngen" runat="server" OnClick="btngen_Click" CssClass="btn bg-success legitRipple"
                    Text="Generate Report" />

            </div>

        </div>
        <div class="content">
            <div class="divstyle card">
                <div id="" class="totbodycatreg" style="height: 700px;">
                    <div style="width: 100%;">
                        <uc1:MessageControl ID="MessageControl1" runat="server" />
                    </div>
                    <div class="row_report " runat="server" id="divReportInput">
                        <div class="card-body">
                            <table width="100%" style="padding-left: 60px;">
                                <tr>
                                    <td style="width: 25px">
                                        <asp:Label ID="Label11" runat="server" Text="From" ForeColor="Black" Font-Bold="True"
                                            Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                                    </td>
                                    <td style="width: 107px">
                                        <input type="date" id="txtfrom" name="txtfrom" class="form-control" />
                                    </td>
                                    <td style="width: 25px">
                                        <asp:Label ID="Label13" runat="server" Text="To" ForeColor="Black" Font-Bold="True"
                                            Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                                    </td>
                                    <td style="width: 107px">
                                        <input type="date" id="txtto" name="txtto" class="form-control" />
                                    </td>
                                    <td valign="middle">
                                        <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status"
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
                           
                                    </td>
                                    <td>
                                        <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Report Type" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td valign="middle" align="center">:
                                    </td>
                                    <td valign="middle">
                                        <asp:RadioButton runat="server" ID="rsummary" Text="Billable" Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                                            <asp:RadioButton runat="server" ID="rdetailed" Text="Non-Billable" GroupName="rbtn" />&nbsp;
                                    </td>
                                </tr>

                            </table>
                        </div>


                        <div id="dvEditInvoice2" class="row">
                            <div class="col-md-6">

                                <!-- White background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold">
                                            <input type="checkbox" class="Chkbox" id="chkProject" name="chkProject" />Project <span id="lblProjcount" name="lblProjcount" class="badge badge-success badge-pill Spancount">0</span></h6>
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
                            <div class="col-md-6">

                                <!-- Grey background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold"><i class="icon-user-check mr-2"></i>
                                            <input type="checkbox" class="Chkbox" id="chkStaff" name="chkStaff" />Staff <span id="lblStaffcount" name="lblStaffcount" class="badge badge-success badge-pill Spancount">0</span></h6>
                                        <div class="header-elements">
                                            <div class="list-icons">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card-body">
                                        <div class="form-group row">
                                            <div style="height: 450px; width: 100%; overflow-y: scroll;">
                                                <table id="tblStaffname" name="tblStaffname" class="table table-hover table-xs font-size-base"></table>
                                            </div>
                                        </div>


                                    </div>



                                </form>
                                <!-- /grey background, left button spacing -->



                            </div>

                        </div>


                    </div>
                </div>
            </div>
        </div>


    </div>
</div>
