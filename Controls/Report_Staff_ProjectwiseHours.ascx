<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Report_Staff_ProjectwiseHours.ascx.cs"
    Inherits="controls_Report_Staff_ProjectwiseHours" %>
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
    var needstaff = true, needProject = false;
    $(document).ready(function () {
        //   $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
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

        Get_All_Staff_Client_Project_BranchName();
        pageFiltersReset();

    

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

        ////check all staff
        $("[id*=chkstaff]").on("click", function () {

            if ($(".clStaff").length == 0)
            { return false; }
            var check = $(this).is(':checked');
            $(".clStaff").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else {
                    $(this).removeAttr('checked');
                }
            });
            needstaff = false, needProject = true;
            BindPageLoadStaff();
        });

        ////check all Project
        $("[id*=chkProject]").on("click", function () {
            var check = $(this).is(':checked');
            if ($(".clProject").length == 0)
            { return false; }
            $(".clProject").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
        });

        $("[id*=ddlBranch]").on("change", function () {
            needstaff = true, needproject = false;
            BindPageLoadStaff();
        });


    });

    function BindPageLoadStaff() {
        GetAllSelected();
        if ($("[id*=txtfrom]").val() == "" || $("[id*=txtfrom]").val() == undefined)
        { return false; }
        Blockloadershow();
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                Fromdate: $("[id*=txtfrom]").val(),
                Todate: $("[id*=txtto]").val(),
                selectedstaffCode: $("[id*=hdnSelectedStaffCode]").val(),
                needproject: needProject,
                needstaff: needstaff,
                BrId: $("[id*=ddlBranch]").val(),
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Report_Staff_ProjectwiseHours.asmx/Get_Staff_Project",
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
        var tableRowsstaff = '', tableRowsProj = '';
        var countstafff = 0, countProj = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "Staff") {
                countstafff += 1;
                tableRowsstaff += "<tbody><tr><td><input type='checkbox' onclick='singlestaffcheck()' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
            else if (vl.Type == "Project") {
                countProj += 1;
                tableRowsProj += "<tbody><tr><td><input type='checkbox' checked='checked' onclick='singleProjectcheck()'  class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
        });
        if (needstaff) {
            $("[id*=chkstaff]").removeAttr('checked');
            $("[id*=lblStaffcount]").html(countstafff);
            $("[id*=tblStaffname]").append(tableRowsstaff);

        }
        if (needProject) {
            if (countProj != 0)

                $("[id*=chkProject]").attr('checked', 'checked');
            else
                $("[id*=chkProject]").removeAttr('checked');


            $("[id*=lblProjcount]").html(countProj);
            $("[id*=tblProjName]").append(tableRowsProj);
        }
        Blockloaderhide();
        GetAllSelected();
    }

    function singleProjectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length)
        { $("[id*=chkProject]").attr('checked', true); }
        else { $("[id*=chkProject]").removeAttr('checked'); }
    }

    //////check single Staff
    function singlestaffcheck() {
        if ($(".clStaff").length == $(".clStaff:checked").length)
        { $("[id*=chkstaff]").attr('checked', true); }
        else { $("[id*=chkstaff]").removeAttr('checked'); }
        needstaff = false, needProject = true;
        BindPageLoadStaff();
    }

    function GetAllSelected() {
        var selectStaff = '', selectProject = '';
        $(".clStaff:checked").each(function () {
            selectStaff += $(this).val() + ',';
        });
        $(".clProject:checked").each(function () {
            selectProject += $(this).val() + ',';
        });
        $("[id*=hdnSelectedStaffCode]").val(selectStaff);

        $("[id*=hdnselectedProjectid]").val(selectProject);
    }

    function Get_All_Staff_Client_Project_BranchName() {
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/WS_StaffWise.asmx/Get_All_Staff_Project_Job_BranchName",
            data: '{compid:' + $("[id*=hdnCompid]").val() + '}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length == 0) { }
                else {
                    if (myList == null) { }
                    else {
                        $("[id*=ddlBranch]").empty();
                        $("[id*=ddlBranch]").append("<option value=" + 0 + ">All</option>");
                        for (var i = 0; i < myList.length; i++) {
                            $("[id*=ddlBranch]").append("<option value=" + myList[i].BrId + ">" + myList[i].Branch + "</option>");
                        }
                    }
                }
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        //Ajax end
    }

    function pageFiltersReset() {
        needstaff = true, needproject = false;
        $("[id*=chkstaff]").removeAttr('checked');

        $("[id*=chkProject]").removeAttr('checked');
        $("[id*=lblProjcount]").html("0");
        $("[id*=lblStaffcount]").html("0");
        $("[id*=tblStaffname] tbody").empty();
        $("[id*=tblStaffname] thead").empty();
        $("[id*=tblProjName] tbody").empty();
        $("[id*=tblProjName] thead").empty();

        BindPageLoadStaff();
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

    #content {
        overflow: hidden !important;
    }

    .loader {
        display: none;
        position: absolute;
        padding-top: 100px;
        width: 320px;
        height: 215px;
        z-index: 9999;
        text-align: center;
        vertical-align: middle;
        background: rgba(0,0,0,0.3);
        color: White;
        font-weight: bold;
        font-size: 18px;
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

    .cssPageTitle2 {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        /*border-bottom: 2px solid #0b9322;*/
        padding: 7px;
        color: #0b9322;
    }
</style>


<div class="page-content">
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="0" />
    <asp:HiddenField runat="server" ID="hdnselectedProjectid" Value="0" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
    <asp:HiddenField runat="server" ID="hdnBrid" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved" />
        <asp:HiddenField runat="server" ID="hdnFrom" />
    <asp:HiddenField runat="server" ID="hdnTo" />

    <div class="content-wrapper">
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Staff Projectwise Hours</span></h4>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>


                <asp:Button ID="btngen" runat="server"
                    CssClass="btn bg-success legitRipple" Text="Generate Report" OnClick="btngen_Click" />

            </div>
        </div>

        <div class="content">
            <div class="divstyle card">
                <div id="div2" class="totbodycatreg" style="height: 700px;">
                    <div style="width: 100%;">
                        <uc1:MessageControl ID="MessageControl1" runat="server" />
                    </div>
                    <div runat="server" id="div1">
                        <div class="card-body">
                            <table width="1100px;" style="padding-left: 85px; padding-top: 15px;">
                                <tr>
                                    <td style="vertical-align: top;">
                                        <table class="style1" width="1000px">
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
                                            <tr>
                                                <td colspan="6">
                                                    <div>
                                                        <table>
                                                            <tr>
                                                                <td valign="middle">
                                                                    <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Report Type" Font-Bold="True"></asp:Label></td>
                                                                <td align="center" valign="middle">:
                                                                </td>
                                                                <td valign="middle">
                                                                    <asp:RadioButton runat="server" ID="rsummary" Text="Summary" Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                                            <asp:RadioButton runat="server" ID="rdetailed" Text="Detailed" GroupName="rbtn" />&nbsp;
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>

                                                <td>
                                                    <asp:Label ID="lblBranch" Font-Bold="true" runat="server">Branch</asp:Label>
                                                </td>
                                                <td valign="middle" align="center">:
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlBranch" CssClass="texboxcls" runat="server" Width="154px">
                                                        <asp:ListItem Value="0" Text="Select Branch"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>



                        <div id="dvEditInvoice2" class="row">
                            <div class="col-md-6">

                                <!-- Grey background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold"><i class="icon-user-check mr-2"></i>
                                            <input type="checkbox" class="Chkbox" id="chkstaff" name="chkstaff" />Staff <span id="lblStaffcount" name="lblStaffcount" class="badge badge-success badge-pill Spancount">0</span></h6>
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
                                                <table id="tblProjName" name="tblProjName" class="table table-hover table-xs font-size-base"></table>
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


