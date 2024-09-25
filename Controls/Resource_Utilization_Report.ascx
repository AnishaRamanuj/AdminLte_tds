<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Resource_Utilization_Report.ascx.cs" Inherits="controls_Resource_Utilization_Report" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%--<link href="../css/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>--%>
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
<script type="text/javascript" src="../js/table2excel.js"></script>
<script language="javascript" type="text/javascript">
    $(document).ready(function () {
        $('.sidebar-main-toggle').click();
        var a = new Date();
        var dt = moment(a).format('YYYY-MM')
        $("[id*=txtmonth]").val(dt);
        $("[id*=hdnmonth]").val(dt);

        pageFiltersReset();

        $("[id*=txtmonth]").on("change", function () {
            pageFiltersReset();
        });

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

            GetAllSelected();
        });

        $("[id*=btngenexp]").on("click", function () {
            GetgridReport();
        });

        $("[id*=btnBack]").on("click", function () {
            $("[id*=btngenexp]").show();
            $("[id*=btnBack]").hide();

            $("[id*=divReportInput]").show();
            $("[id*=divGridReport]").hide();
            $("[id*=btnExportToExcel]").hide();
        });

        $("[id*=btnExportToExcel]").on("click", function () {
            ExcelExport();
        });


    });


    function ExcelExport() {
        $("#divGridReport").table2excel({
            filename: "Utilization_report.xls"
        });
    }

    function GetgridReport() {
        //var compid = $("[id*=hdnCompid]").val();
        var staffcode = $("[id*=hdnSelectedStaffCode]").val();
        var Monthdt = $("[id*=txtmonth]").val();

        $.ajax({
            type: "POST",
            url: "../Handler/Report_Staff_ProjectwiseHours.asmx/GetgridReportUtilization",
            data: '{staffcode:"' + staffcode + '",Monthdt:"' + Monthdt + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                $("[id*=divReportInput]").hide();
                $("[id*=divGridReport]").show();

                $("[id*=btngenexp]").hide();
                $("[id*=btnBack]").show();
                $("[id*=tdexcel]").show();
                $("[id*=btnExportToExcel]").show();
                var dt = new Date(Monthdt.split('-')[1] + '/01/' + Monthdt.split('-')[0]);
                var Monthname = dt.toLocaleString('en-us', { month: 'short' });

                var myList = jQuery.parseJSON(msg.d);
                var RecordCount = 0;
                var tbl = '';
                $("[id*=tbl_Actvtrcd] tbody").empty();
                $("[id*=tbl_Actvtrcd] thead").empty();
                tbl = tbl + "<thead><tr>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Staff</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Department</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>1 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>2 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>3 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>4 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>5 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>6 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>7 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>8 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>9 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>10 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>11 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>12 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>13 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>14 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>15 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>16 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>17 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>18 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>19 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>20 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>21 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>22 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>23 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>24 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>25 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>26 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>27 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>28 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>29 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>30 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>31 - " + Monthname + "</th>";
                tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Total Billable Hours</th>";
                tbl = tbl + "</tr></thead>";

                if (myList.length > 0) {

                    for (var i = 0; i < myList.length; i++) {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td style='text-align: left;font-weight: bold;'>" + myList[i].Staff + "</td>";
                        tbl = tbl + "<td style='text-align: left;'>" + myList[i].Dept + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d1DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d2DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d3DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d4DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d5DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d6DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d7DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d8DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d9DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d10DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d11DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d12DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d13DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d14DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d15DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d16DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d17DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d18DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d19DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d20DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d21DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d22DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d23DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d24DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d25DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d26DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d27DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d28DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d29DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d30DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].d31DM + "</td>";
                        tbl = tbl + "<td style='text-align: center;'>" + myList[i].Tot + "</td>";
                        tbl = tbl + "</tr>";
                    };
                    $("[id*=tbl_Actvtrcd]").append(tbl);



                }

            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
    }



    function BindPageLoadStaff() {
        //  GetAllSelected();
        if ($("[id*=txtmonth]").val() == "" || $("[id*=txtmonth]").val() == undefined)
        { return false; }
        $(".modalganesh").show();
        var data = {
            currobj: {
                //compid: $("[id*=hdnCompid]").val(),
                Monthdate: $("[id*=txtmonth]").val(),
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Report_Staff_ProjectwiseHours.asmx/Get_Staff_ResourceUtilization",
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
        var tableRowsstaff = '';
        var countstafff = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "Staff") {
                countstafff += 1;
                tableRowsstaff += "<tr><td><input type='checkbox' onclick='singlestaffcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });

        $("[id*=chkstaff]").removeAttr('checked');
        $("[id*=chkstaff]").parent().find('label').text(" Staff (" + countstafff + ")");
        $("[id*=Panel1]").html("<table>" + tableRowsstaff + "</table>");

        $(".modalganesh").hide();
        GetAllSelected();
    }

    function GetAllSelected() {
        var selectStaff = '';
        $(".clStaff:checked").each(function () {
            selectStaff += $(this).val() + ',';
        });

        $("[id*=hdnSelectedStaffCode]").val(selectStaff);

    }


    //////check single Staff
    function singlestaffcheck() {
        if ($(".clStaff").length == $(".clStaff:checked").length)
        { $("[id*=chkstaff]").attr('checked', true); }
        else { $("[id*=chkstaff]").removeAttr('checked'); }
        GetAllSelected();
    }

    function pageFiltersReset() {
        $("[id*=chkstaff]").removeAttr('checked');
        $("[id*=chkstaff]").parent().find('label').text("Select Staff(0)");
        $("[id*=Panel1]").html('');
        BindPageLoadStaff();
    }
</script>


<asp:HiddenField runat="server" ID="hdnCompid" />
<asp:HiddenField runat="server" ID="hdnSelectedStaffCode" />
<asp:HiddenField runat="server" ID="hdnmonth" />

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
                    <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold">Resource Utilization</span></h5>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

                   
                        <img src="../images/xls-icon.png" id="btnExportToExcel" style="cursor: pointer;display:none;" />
               

                        <input type="button" id="btngenexp" name="btngenexp" class="btn bg-success legitRipple" value="Generate Report" />

                        <input type="button" id="btnBack" name="btnBack" class="btn btn-primary legitRipple legitRipple-empty" style="display: none;" value="Back" />
                  
            </div>
        </div>

        <!-- /page header -->

        <div class="content">

            <!-- Hover rows -->


            <div id="dvGrid" class="card">
                <div id="div2" class="totbodycatreg" style="height: 500px;">
                    <div style="width: 100%;">
                        <uc1:MessageControl ID="MessageControl1" runat="server" />
                    </div>
                    <div class="row_report" runat="server" id="divReportInput">
                        <div>
                            <div style="overflow: hidden; width: 100%; margin-top: 10px;">
                                <div style="float: left; width: 20%;">
                                    <table>
                                        <tr>
                                            <td style="font-weight: bold;">&nbsp;&nbsp; Month
                                            </td>
                                            <td>:</td>
                                            <td>
                                                <input type="month" style="width: 150px;" class="form-control" id="txtmonth" name="txtmonth" />
                                            </td>
                                  
                                        </tr>
                                    </table>
                                </div>
                                <div style="float: right; width: 80%;">
                                    <table>
                                        <tr>
                                            <td style="width: 380px;">
                                                <asp:CheckBox ID="chkstaff" runat="server" ForeColor="Black"
                                                    Font-Bold="true" Height="20px" Text="Staff Name (0)" CssClass="labelChange" />
                                                <div id="Panel1" style="border: 1px solid #B6D1FB; width: 130%; height: 450px; overflow: auto;">
                                                    <div id="content">
                                                        <div class="loader">
                                                            Please Wait.....
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="divGridReport" style="display: none;">
                        <div id="Div1" class="table-responsive card" style="overflow: scroll; padding-bottom: 10px; width: 100%; height: 500px;">
                            <table id="tbl_Actvtrcd" class="table table-hover table-xs font-size-base ">
                            </table>


                        </div>
                    </div>

                </div>

            </div>

        </div>
        <!-- /main content -->

   



