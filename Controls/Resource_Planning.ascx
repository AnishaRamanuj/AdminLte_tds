<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Resource_Planning.ascx.cs" Inherits="controls_Resource_Planning" %>
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
    var needstaff = false, needProject = true;
    $(document).ready(function () {
        $('.sidebar-main-toggle').click();
        var a = new Date();
        var dt = moment(a).format('YYYY-MM')
        $("[id*=txtmonth]").val(dt);
        $("[id*=hdnmonth]").val(dt);

        $("[id*=txtstartdate1]").val($("[id*=hdnFromdate]").val());
        $("[id*=txtenddate2]").val($("[id*=hdnTodate]").val());

        $("[id*= txtmonth]").on('change', function () {
            $("[id*= hdnmonth]").val($("[id*= txtmonth]").val());

        });

        $("[id*= txtstartdate1]").on('change', function () {
            $("[id*=hdnFromdate]").val($("[id*= txtstartdate1]").val());

        });

        $("[id*= txtenddate2]").on('change', function () {
            $("[id*= hdnTodate]").val($("[id*= txtenddate2]").val());

        });

        rediocheck();
        pageFiltersReset();

        ////check all staff
        $("[id*=chkstaff]").on("click", function () {
            var chkprop = $(this).is(':checked');

            $(".clStaff").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked');
                }
            });

        });

        ////check all Project
        $("[id*=chkProject]").on("click", function () {

            var chkprop = $(this).is(':checked');

            $(".clProject").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked');
                }
            });


            needstaff = true, needProject = false;
            BindPageLoadStaff();
        });

        $("[id*=rdetailed]").on("click", function () {
            rediocheck();
        });

        $("[id*=rsummary]").on("click", function () {
            rediocheck();
        });

        $("[id*=btGen]").on("click", function () {
            GenrateSummaryReport();
        });

    });

    function GenrateSummaryReport() {

    }

    function rediocheck() {
        if ($("[id*=rdetailed]").is(':checked') == true) {
            $("[id*=trDetails]").show();
            $("[id*=trSummry]").hide();
            $("[id*=btngenexp]").show();
            $("[id*=btGen]").hide();
        } else {
            $("[id*=trDetails]").hide();
            $("[id*=trSummry]").show();
            $("[id*=btngenexp]").hide();
            $("[id*=btGen]").show();
        }
    }



    function BindPageLoadStaff() {
        GetAllSelected();
        if ($("[id*=txtmonth]").val() == "" || $("[id*=txtmonth]").val() == undefined)
        { return false; }
        $(".modalganesh").show();
        var data = {
            currobj: {
                //compid: $("[id*=hdnCompid]").val(),
                Monthdate: $("[id*=txtmonth]").val(),
                selectedJobidCode: $("[id*=hdnselectedJobid]").val(),
                needproject: needProject,
                needstaff: needstaff,
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Report_Staff_ProjectwiseHours.asmx/Get_Staff_ProjectResource",
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
                tableRowsstaff += "<tr><td><input type='checkbox' checked='checked' onclick='singlestaffcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "Project") {
                countProj += 1;
                tableRowsProj += "<tr><td><input type='checkbox' onclick='singleProjectcheck()'  class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });
        if (needProject) {
            $("[id*=chkProject]").removeAttr('checked');
            $("[id*=chkProject]").parent().find('label').text("Project(" + countProj + ")");
            $("[id*=Panel2]").html("<table>" + tableRowsProj + "</table>");
        }
        if (needstaff) {
            if (countstafff != 0)

                $("[id*=chkstaff]").attr('checked', 'checked');
            else
                $("[id*=chkstaff]").removeAttr('checked');


            $("[id*=chkstaff]").parent().find('label').text("Staff (" + countstafff + ")");
            $("[id*=Panel3]").html("<table>" + tableRowsstaff + "</table>");
        }
        $(".modalganesh").hide();
        GetAllSelected();
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

        $("[id*=hdnselectedJobid]").val(selectProject);
    }

    function singleProjectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length)
        { $("[id*=chkProject]").attr('checked', true); }
        else { $("[id*=chkProject]").removeAttr('checked'); }
        needstaff = true, needProject = false;
        BindPageLoadStaff();
    }

    //////check single Staff
    function singlestaffcheck() {
        if ($(".clStaff").length == $(".clStaff:checked").length)
        { $("[id*=chkstaff]").attr('checked', true); }
        else { $("[id*=chkstaff]").removeAttr('checked'); }
    }

    function pageFiltersReset() {
        needstaff = true, needproject = false;
        $("[id*=chkstaff]").removeAttr('checked');
        $("[id*=chkstaff]").parent().find('label').text("Staff Name (Count : 0)");
        $("[id*=chkProject]").removeAttr('checked');
        $("[id*=chkProject]").parent().find('label').text("Project Name (Count : 0)");

        $("[id*=Panel2]").html('');
        $("[id*=Panel3]").html('');
        BindPageLoadStaff();
    }

</script>

<asp:HiddenField runat="server" ID="hdnCompid" />
<asp:HiddenField runat="server" ID="hdnSelectedStaffCode" />
<asp:HiddenField runat="server" ID="hdnselectedJobid" />
<asp:HiddenField runat="server" ID="hdnStaffCode" />
<asp:HiddenField runat="server" ID="hdnBrid" />
<asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved" />
<asp:HiddenField runat="server" ID="hdnmonth" />
<asp:HiddenField runat="server" ID="hdnFromdate" />
<asp:HiddenField runat="server" ID="hdnTodate" />

<div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>
          
</div>

        <!-- Page header -->
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-left: 1rem;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">
                    <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold">Resource Planning</span></h5>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>


                <img src="../images/xls-icon.png" id="btnExportToExcel" style="cursor: pointer; display: none;" />


                <asp:Button ID="btngenexp" runat="server" OnClick="btngenexp_Click" CssClass="btn bg-success legitRipple"
                    Text="Generate Report" />

                <asp:ImageButton ID="btGen" runat="server" ImageUrl="~/images/xls-icon.png" CssClass="btn btn-primary legitRipple legitRipple-empty"
                    OnClick="btnExportToExcel_Click1" />
            </div>
        </div>

        <!-- /page header -->

        <div class="content">

            <!-- Hover rows -->


            <div id="dvGrid" class="card">
                <div style="width: 100%;">
                    <uc1:MessageControl ID="MessageControl1" runat="server" />
                </div>
                <div class="row_report" runat="server" id="div1">
                    <div style="overflow: hidden; width: 100%; margin-top: 10px;">
                        <div style="float: left; width: 40%;">
                            <table>
                                <tr>
                                    <td valign="middle">&nbsp;&nbsp;
                                <asp:Label ID="Label3" runat="server" ForeColor="Black" Text="Report Type :" Font-Bold="True"></asp:Label></td>

                                    <td valign="middle">

                                        <asp:RadioButton runat="server" ID="rdetailed" Checked="true" Text="Detailed" GroupName="rbtn" />&nbsp;&nbsp;
                                <asp:RadioButton runat="server" ID="rsummary" Text="Summary" GroupName="rbtn" />&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="5" style="height: 7px;"></td>
                                </tr>
                                <tr id="trDetails" name="trDetails">
                                    <td style="font-weight: bold;">&nbsp;&nbsp; Month
                                    </td>
                                    <td>:</td>
                                    <td>
                                        <input type="month" style="width: 150px;" class="form-control form-control-border" id="txtmonth" name="txtmonth" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="5" style="height: 7px;"></td>
                                </tr>
                                <tr id="trSummry" name="trSummry">
                                    <td valign="middle">&nbsp;&nbsp;
                                <asp:Label ID="Label8" runat="server" ForeColor="Black" Text="From :"
                                    Font-Bold="True"></asp:Label>
                                    </td>

                                    <td class="col-lg-4">
                                        <input type="date" id="txtstartdate1" name="txtstartdate1" class="form-control" />

                                    </td>
                                    <td valign="middle">
                                        <asp:Label ID="Label10" runat="server" ForeColor="Black" Text="To :"
                                            Font-Bold="True"></asp:Label>
                                    </td>

                                    <td class="col-lg-4">
                                        <input type="date" id="txtenddate2" name="txtenddate2" class="form-control" />

                                    </td>


                                </tr>
                            </table>
                        </div>
                        <div style="float: right; width: 60%;">
                            <table>
                                <tr>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkProject" runat="server" ForeColor="Black"
                                            Font-Bold="true" Height="20px" Text="Project Name (0)" CssClass="labelChange" />
                                        <div id="Panel2" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                            <div id="content">
                                                <div class="loader">
                                                    Please Wait.....
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkstaff" runat="server" ForeColor="Black"
                                            Font-Bold="true" Height="20px" Text=" Staff Name (0)" CssClass="labelChange" />
                                        <div id="Panel3" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                        </div>
                                    </td>

                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

            </div>

        </div>
        <!-- /main content -->

 


