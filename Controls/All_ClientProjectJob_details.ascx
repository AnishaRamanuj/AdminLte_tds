<%@ Control Language="C#" AutoEventWireup="true" CodeFile="All_ClientProjectJob_details.ascx.cs" Inherits="controls_All_ClientProjectJob_details" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
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
    $(document).ready(function () {
        $('.sidebar-main-toggle').click();

        $("[id*= txtfrom]").val($("[id*= hdnFrom]").val());
        $("[id*= txtto]").val($("[id*= hdnTo]").val());

        //////////////////////////////////////////////////before report filter
        pageFiltersReset();


        ////tStatus chkall
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
        //////date change event
        $("[id*=startdate1]").on("change", function () {
            pageFiltersReset();
        });
        $("[id*=txtenddate2]").on("change", function () {
            pageFiltersReset();
        });
        $("[id*=chkclient]").on("click", function () {


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


        $("[id*=chkproject]").on("click", function () {
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

        $("[id*=chkdept]").on("click", function () {
            var chkprop = $(this).is(':checked');

            $(".cldept").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            });

        });



        $("[id*=btngen]").on("click", function () {

            var deptid = '';
            GetAllSelected();
            $(".cldept:checked").each(function () {
                deptid += $(this).val() + ',';
            });

            if (deptid == '')
            { alert('Please select at least one Department!'); return false; }
            $(".modalganesh").show();
        });



        $("[id*=btnBack]").on("click", function () {
            $(".modalganesh").show();
        });
        //BindPageLoadStaff();
    });
    var needclient = true, needproject = false, needdept = false;

    function pageFiltersReset() {
        needclient = true, needproject = false, needdept = false;
        $("[id*=chkstaff]").removeAttr('checked');
        $("[id*=lblCltcount]").html('0');
        $("[id*=chkproject]").removeAttr('checked');
        $("[id*=lblProjcount]").html('0');
        $("[id*=chkdept]").removeAttr('checked');

        if ($("[id*=hdndeptwise]").val() == 'dept') {
            $("[id*=lblDcount]").html('0');
            //  $("[id*=chkdept]").parent().find('label').text("Check All Department Name (Count : 0)");
        }
        else {
            $("[id*=lblDcount]").html('0');
            //  $("[id*=chkdept]").parent().find('label').text("Check All job Name (Count : 0)");
        }

        $("[id*=tblClientName] tbody").empty();
        $("[id*=tblClientName] thead").empty();
        $("[id*=tblProjectName] tbody").empty();
        $("[id*=tblProjectName] thead").empty();
        $("[id*=tblDeptName] tbody").empty();
        $("[id*=tblDeptName] thead").empty();
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
        pageFiltersReset();
    }


    function GetAllSelected() {
        var selectclient = '', selectproject = '', selectdept = '';
        $(".clclient:checked").each(function () {
            selectclient += $(this).val() + ',';
        });
        $(".clProject:checked").each(function () {
            selectproject += $(this).val() + ',';
        });
        $(".cldept:checked").each(function () {
            selectdept += $(this).val() + ',';
        });
        $("[id*=hdnselectedclientid]").val(selectclient);
        $("[id*=hdnselectedprojectid]").val(selectproject);
        $("[id*=hdnselecteddept]").val(selectdept);
    }

    function BindPageLoadStaff() {
        GetAllSelected();


        if (needclient) {
            $("[id*=hdnselectedclientid]").val('Empty');
            $("[id*=hdnSelectedStaffCode]").val('');
            $("[id*=hdnselectedprojectid]").val('');
        }
        if ($("[id*=txtfrom]").val() == "" || $("[id*=txtfrom]").val() == undefined)
        { return false; }
        Blockloadershow();
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                UserType: $("[id*=hdnTypeU]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                StaffCode: $("[id*=hdnStaffCode]").val(),
                selectedclientid: $("[id*=hdnselectedclientid]").val(),
                selectedprojectid: $("[id*=hdnselectedprojectid]").val(),
                selecteddeptid: $("[id*=hdnselecteddept]").val(),
                neetclient: needclient,
                needproject: needproject,
                needdept: needdept,
                FromDate: $("[id*=txtfrom]").val(),
                ToDate: $("[id*=txtto]").val(),
                RType: 'client'
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/ws_projectReport.asmx/Bind_Client_Project_Deaprtment_All_Selected",
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
        var tableRowsclient = '', tableRowsproject = '', tabledept = '';
        var countclient = 0, countproject = 0, countdept = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "client") {
                countclient += 1;
                tableRowsclient += "<tbody><tr><td><input type='checkbox'  onclick='singleclientcheck()' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
            else if (vl.Type == "Project") {
                countproject += 1;
                tableRowsproject += "<tbody><tr><td><input type='checkbox' onclick='singleprojectcheck()' checked='checked' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
            else if (vl.Type == "dept") {
                countdept += 1;
                tabledept += "<tbody><tr><td><input type='checkbox' onclick='singledeptcheck()' checked='checked' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }


        });


        if (needclient) {
            $("[id*=chkclient]").removeAttr('checked');
            //$("[id*=chkclient]").parent().find('label').text("Check All Client Name (Count : " + countclient + ")");
            //$("[id*=Panelclt]").html("<table>" + tableRowsclient + "</table>");
           
            $("[id*=lblCltcount]").html(countclient);
            $("[id*=tblClientName]").append(tableRowsclient);
        }
        if (needproject) {

            if (countproject != 0)
                $("[id*=chkproject]").attr('checked', 'checked');
            else
                $("[id*=chkproject]").removeAttr('checked');

            //$("[id*=chkproject]").parent().find('label').text("Check All Project Name (Count : " + countproject + ")");
            //$("[id*=Panelprj]").html("<table>" + tableRowsproject + "</table>");

            $("[id*=lblProjcount]").html(countproject);
            $("[id*=tblProjectName]").append(tableRowsproject);
        }

        if (needdept) {

            if (countdept != 0)
                $("[id*=chkdept]").attr('checked', 'checked');
            else
                $("[id*=chkdept]").removeAttr('checked');

            if ($("[id*=hdndeptwise]").val() == 'dept') {

                //    $("[id*=chkdept]").parent().find('label').text("Check All Department Name (Count : " + countdept + ")");
            }
            else {
                // $("[id*=chkdept]").parent().find('label').text("Check All job Name (Count : " + countdept + ")");
            }

            //  $("[id*=Paneldept]").html("<table>" + tabledept + "</table>");

            $("[id*=lblProjcount]").html(countdept);
            $("[id*=tblDeptName]").append(tabledept);
        }

        Blockloaderhide();
    }
    //////check single client

    function singleclientcheck() {
        if ($(".clclient").length == $(".clclient:checked").length)
        { $("[id*=chkclient]").attr('checked', true); }
        else { $("[id*=chkclient]").removeAttr('checked'); }
        needstaff = true, needclient = false, needjob = true, needproject = true, needdept = true;
        BindPageLoadStaff();
    }
    //////check single project
    function singleprojectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length)
        { $("[id*=chkproject]").attr('checked', true); }
        else { $("[id*=chkproject]").removeAttr('checked'); }
        needclient = false, needproject = false, needdept = true;
        BindPageLoadStaff();
    }

    //////check single department or job
    function singledeptcheck() {
        if ($(".cldept").length == $(".cldept:checked").length)
        { $("[id*=chkdept]").attr('checked', true); }
        else { $("[id*=chkdept]").removeAttr('checked'); }
        needclient = false, needdept = false, needproject = false;
        BindPageLoadStaff();
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
    <asp:HiddenField runat="server" ID="hdndeptwise" />
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnTypeU" />
    <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="Empty" />
    <asp:HiddenField runat="server" ID="hdnselectedclientid" />
    <asp:HiddenField runat="server" ID="hdnselectedjobid" />
    <asp:HiddenField runat="server" ID="hdnselectedprojectid" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
    <asp:HiddenField runat="server" ID="hdnselecteddept" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
    <asp:HiddenField runat="server" ID="hdnFrom" />
    <asp:HiddenField runat="server" ID="hdnTo" />
    <div class="content-wrapper">
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Client Projectwise Department and Job Report</span></h4>
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
                        <div class="card-body">
                            <table width="1100px;" style="padding-left: 60px;">
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
                                        <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()" Checked="true"
                                            ClientIDMode="Static" Text="Rejected" />
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
                                                <td></td>
                                                <td width="60px;"></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>

                            </table>
                        </div>


                        <div id="dvEditInvoice2" class="row">
                            <div class="col-md-4">

                                <!-- Grey background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold"><i class="icon-user-check mr-2"></i>
                                            <input type="checkbox" class="Chkbox" id="chkclient" name="chkclient" />Client <span id="lblCltcount" name="lblCltcount" class="badge badge-success badge-pill Spancount">0</span></h6>
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
                                            <input type="checkbox" class="Chkbox" id="chkproject" name="chkproject" />Project <span id="lblProjcount" name="lblProjcount" class="badge badge-success badge-pill Spancount">0</span></h6>
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
                                            <input type="checkbox" class="Chkbox" id="chkdept" name="chkdept" />Department <span id="lblDcount" name="lblDcount" class="badge badge-success badge-pill Spancount">0</span></h6>
                                        <div class="header-elements">
                                            <div class="list-icons">
                                            </div>
                                        </div>
                                    </div>



                                    <div class="card-body">
                                        <div class="form-group row">
                                            <div style="height: 450px; width: 100%; overflow-y: scroll;">
                                                <table id="tblDeptName" name="tblDeptName" class="table table-hover table-xs font-size-base"></table>
                                            </div>
                                        </div>


                                    </div>



                                </form>
                                <!-- /white background, left button spacing -->


                            </div>

                        </div>


                    </div>

                    <rsweb:ReportViewer ID="ReportViewer1" CssClass="card" Width="1144px" SizeToReportContent="true"
                        Visible="false" runat="server" AsyncRendering="False"
                        InteractivityPostBackMode="AlwaysAsynchronous">
                    </rsweb:ReportViewer>
                </div>
            </div>
        </div>


    </div>
</div>





<%--     <div class="divstyle">
         <div id="div2" class="totbodycatreg" style="height:auto;" >
            <div style="width: 100%;">
               
            </div>
           
             <div class="row_report" runat="server" id="divReportInput">
                <div>
             <table class="style1" style="float: left; padding-left:55px; padding-top:10px; width:1100px;">
                   
                    <tr>
                        <td colspan="20">
                            <table>
                                <tr>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkclient" runat="server" ForeColor="Black"
                                            Font-Bold="true" Height="20px" Text=" Check All Client Name (Count : 0)" CssClass="labelChange" />
                                        <div id="Panelclt" style="border: 1px solid #B6D1FB; width: 95%;
                                            height:350px; overflow: auto;">
                                        </div>
                                    </td>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkproject" runat="server" ForeColor="Black"
                                            Font-Bold="true" Height="20px" Text=" Check All Project Name (Count : 0)" CssClass="labelChange" />
                                        <div id="Panelprj" style="border: 1px solid #B6D1FB; width: 95%;
                                            height: 350px; overflow: auto;">
                                        </div>
                                    </td>
                                   
                                  
                                     <td id="tddept" runat="server" style="width: 380px;">
                                        <asp:CheckBox ID="chkdept" runat="server" ForeColor="Black" Font-Bold="true"
                                            Height="20px" CssClass="labelChange"/>
                                        <div id="Paneldept" style="border: 1px solid #B6D1FB; width: 95%;
                                            height: 350px; overflow: auto;">
                                        </div>
                                    </td>
                                  
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
               </div>
             </div>
             
         </div>
     </div>
--%>