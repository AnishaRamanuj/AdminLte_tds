<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ReportProjectWiseStaffExpense.ascx.cs" Inherits="controls_ReportProjectWiseStaffExpense" %>
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
       
<script lang="javascript" type="text/javascript">
    var needproject = true, needstaff = false;
    $(document).ready(function () {
        ///$(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        $("[id*= txtfrom]").val($("[id*= hdnFrom]").val());
        $("[id*= txtto]").val($("[id*= hdnTo]").val());

        BindPageLoadData();
        pageFiltersReset();

        $("[id*=txtfrom]").on("change", function () {
            pageFiltersReset();
        });

        $("[id*=txtto]").on("change", function () {
            pageFiltersReset();
        });

        $("[id*=chkTStatusAll]").on("click", function () {
            if ($(this).is(":checked")) {
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
            var check = $(this).is(":checked");
           
            $(".clProject").each(function () {
                if (check) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked');
                }

            });
            needproject = false, needstaff = true;
            BindPageLoadData();
        });

        ////check all staff
        $("[id*=chkstaff]").on("click", function () {
            var check = $(this).is(":checked");
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

        $("[id*=ddlBranch]").on("change", function () {
            needproject = true, needstaff = false;
            BindPageLoadData();
        });
    });

    //function Get_All_Project_Client_BranchName() {
    //    //Ajax start
    //    $.ajax({
    //        type: "POST",
    //        contentType: "application/json; charset=utf-8",
    //        url: "../Handler/WS_Project_Client_BillableHrs.asmx/Get_BranchList",
    //        data: '{compid:' + $("[id*=hdnCompid]").val() + '}',
    //        dataType: "json",
    //        success: function (msg) {
    //            var myList = jQuery.parseJSON(msg.d);
    //            if (myList.length == 0) { }
    //            else {
    //                if (myList == null) { }
    //                else {
    //                    $("[id*=ddlBranch]").empty();
    //                    $("[id*=ddlBranch]").append("<option value=" + 0 + ">All</option>");
    //                    for (var i = 0; i < myList.length; i++) {
    //                        $("[id*=ddlBranch]").append("<option value=" + myList[i].BrId + ">" + myList[i].Branch + "</option>");
    //                    }
    //                }
    //            }
    //        },
    //        failure: function (response) {

    //        },
    //        error: function (response) {

    //        }
    //    });
    //    //Ajax end
    //}
    //bind data
    function BindPageLoadData() {

        GetAllSelected();
        if ($("[id*=txtfrom]").val() == "" || $("[id*=txtfrom]").val() == undefined)
        { return false; }
        $('.loader').show();
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                UserType: $("[id*=hdnUserType]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                staffcode: $("[id*=hdnstaffcode]").val(),
                selectedclientid: $("[id*=hdnselectedstaff]").val(),
                selectedprojectid: $("[id*=hdnSelectedProjectid]").val(),
                needstaff: needstaff,
                needProject: needproject,
                fromdate: $("[id*=txtfrom]").val(),
                todate: $("[id*=txtto]").val(),
                BrId: $("[id*=ddlBranch]").val(),
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/WS_Project_Client_BillableHrs.asmx/Get_Project_StaffExpense",
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

    function pageFiltersReset() {
        needproject = true, needstaff = false;
        $("[id*=chkProject]").removeAttr('checked');
       
        $("[id*=chkstaff]").removeAttr('checked');

        $("[id*=lblProjcount]").html("0");
        $("[id*=lblStaffcount]").html("0");
        $("[id*=tblStaffname] tbody").empty();
        $("[id*=tblStaffname] thead").empty();
        $("[id*=tblProjname] tbody").empty();
        $("[id*=tblProjname] thead").empty();

        BindPageLoadData();
    }

    function OnSuccess(response) {
        var obj = jQuery.parseJSON(response.d);
        console.log(obj);
        var tableRowsProj = '', tableRowsclt = '';
        var countProj = 0, countClt = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "Project") {
                countProj += 1;
                tableRowsProj += "<tbody><tr><td><input type='checkbox' onclick='singleProjectcheck()' class='cl" + vl.Type + " Chkbox' value='" + vl.id + "' /></td><td>" + vl.PNAME + "</td></tr></tbody>";
            }
            else if (vl.Type == "Staff") {

                countClt += 1;
                tableRowsclt += "<tbody><tr><td><input type='checkbox' checked='checked' onclick='singleStaff()'  class='cl" + vl.Type + " Chkbox' value='" + vl.id + "' /></td><td>" + vl.PNAME + "</td></tr></tbody>";
            }
        });
        if (needproject) {
            $("[id*=chkProject]").removeAttr('checked');
            //$("[id*=chkProject]").parent().find('label').text("Check All Project Name (Count : " + countProj + ")");
            //$("[id*=Panel1]").html("<table>" + tableRowsProj + "</table>");
            $("[id*=lblProjcount]").html(countProj);
            $("[id*=tblProjname]").append(tableRowsProj);

        }
        if (needstaff) {
            if (countClt != 0)

                $("[id*=chkstaff]").attr('checked', 'checked');
            else
                $("[id*=chkstaff]").removeAttr('checked');
            //$("[id*=chkstaff]").parent().find('label').text("Check All Staff Name (Count : " + countClt + ")");
            //$("[id*=Panel2]").html("<table>" + tableRowsclt + "</table>");

            $("[id*=lblStaffcount]").html(countClt);
            $("[id*=tblStaffName]").append(tableRowsclt);

        }
        GetAllSelected();
    }

    function singleStaff() {
        if ($(".clStaff").length == $(".clStaff:checked").length) {
            $("[id*=chkstaff]").attr('checked', true);
        }
        else {
            $("[id*=chkstaff]").removeAttr('checked');
        }
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
        BindPageLoadData();
    }

    function GetAllSelected() {
        var selectClient = '', selectProject = '';
        $(".clProject:checked").each(function () {

            selectProject += $(this).val() + ',';
        });
        $(".clStaff:checked").each(function () {
            selectClient += $(this).val() + ',';
        });
        $("[id*=hdnSelectedProjectid]").val(selectProject);

        $("[id*=hdnselectedstaff]").val(selectClient);
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
    <asp:HiddenField runat="server" id="hdnCompid"/>
    <asp:HiddenField runat="server" ID="hdnSelectedProjectid"/>
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved" />
    <asp:HiddenField runat="server" ID="hdnselectedstaff"/>
    <asp:HiddenField runat="server" ID="hdnUserType"/>
    <asp:HiddenField runat="server" ID="hdnstaffcode"/>
            <asp:HiddenField runat="server" ID="hdnFrom" />
        <asp:HiddenField runat="server" ID="hdnTo" />
    <div class="content-wrapper">
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Project Wise Staff Expense</span></h4>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

                <asp:Button ID="btngenerate" runat="server" OnClick="btngenerate_Click" CssClass="btn bg-success legitRipple"
                    Text="Generate Report" />

                <asp:Button ID="btnBack" Style="float: left" runat="server" CssClass="btn btn-primary legitRipple legitRipple-empty" Text="Back" Visible="false" />

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
                            
                            <table class="style1" width="100%;">
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
                                    <td style="width:15px;"></td>
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
   
                     
                                </tr>
                                <tr>                                 <td valign="middle">
                                        <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Report Type" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center" valign="middle">:
                                    </td>
                                    <td valign="middle">
                                        <asp:RadioButton runat="server" ID="rsummary" Text="Summarized" Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                                            <asp:RadioButton runat="server" ID="rdetailed" Text="Detailed" GroupName="rbtn" />&nbsp;
                                    </td></tr>
                            </table>
                      

                        </div>

                        <div id="dvEditInvoice2" class="row">
                            <div class="col-md-6">

                                <!-- Grey background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold"><i class="icon-user-check mr-2"></i>
                                            <input type="checkbox" class="Chkbox" id="chkProject" name="chkProject" />Project <span id="lblProjcount" name="lblProjcount" class="badge badge-success badge-pill Spancount">0</span></h6>
                                        <div class="header-elements">
                                            <div class="list-icons">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card-body">
                                        <div class="form-group row">
                                            <div style="height: 450px; width: 100%; overflow-y: scroll;">
                                                <table id="tblProjname" name="tblProjname" class="table table-hover table-xs font-size-base"></table>
                                            </div>
                                        </div>


                                    </div>



                                </form>
                                <!-- /grey background, left button spacing -->



                            </div>

                            <div class="col-md-6">

                                <!-- White background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold">
                                            <input type="checkbox" class="Chkbox" id="chkstaff" name="chkstaff" />Staff <span id="lblStaffcount" name="lblStaffcount" class="badge badge-success badge-pill Spancount">0</span></h6>
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
                   
                </div>
            </div>
        </div>
    </div>

</div>

