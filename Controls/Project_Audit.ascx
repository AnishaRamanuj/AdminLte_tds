<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Project_Audit.ascx.cs" Inherits="controls_Project_Audit" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<%--<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../jquery/jquery-2.2.4.min.js"></script>

<script src="../jquery/Selectize/selectize.js" type="text/javascript"></script>
<script src="../jquery/Selectize/es5.js" type="text/javascript"></script>
<script src="../jquery/Selectize/index.js" type="text/javascript"></script>
<link href="../jquery/Selectize/normalize.css" rel="stylesheet" type="text/css" />--%>
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
<script type="text/javascript" src="../jquery/Chart.js"></script>
<script type="text/javascript">
    var myList = [];
    $(document).ready(function () {
        $('.sidebar-main-toggle').click();
        $("[id*= txtfrom]").val($("[id*= hdnFrom]").val());
        $("[id*= txtto]").val($("[id*= hdnTo]").val());

        $("[id*= txtfrom]").on('change', function () {
            $("[id*= hdnFrom]").val($("[id*= txtfrom]").val());
        });

        $("[id*= txtto]").on('change', function () {
            $("[id*= hdnTo]").val($("[id*= txtto]").val());
        });


        $("[id*=dvGrph]").hide();
        $("[id*=dvSelect]").show();
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        GetProjectName();

        $("[id*=drpproject]").on("change", function () {
            var jobid = $("[id*=drpproject]").val();
            $("[id*=hdnJobid]").val(jobid);
            var Projectname = $("#drpproject option:selected").text();
            $("[id*=hdnProjectName]").val(Projectname);

        });

        $("[id*=BtnBack]").on("click", function () {
            $("[id*=dvGrph]").hide();
            $("[id*=dvSelect]").show();
            $("[id*=BtnBack]").hide();
            $("[id*=btnAudit]").show();
        });

        $("[id*=btnAudit]").on("click", function () {
            var strtdt = '', enddt = '';
            strtdt = $("[id*=txtfrom]").val();

            enddt = $("[id*=txtto]").val();

            var data = {
                currobj: {
                    compid: parseFloat($("[id*=hdnCompid]").val()),
                    jobid: parseFloat($("[id*=drpproject]").val()),
                    Monthdate: strtdt,
                    Todate: enddt
                }
            };
            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/wsAudit.asmx/GetProjectHours",
                data: JSON.stringify(data),
                dataType: "json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    //myList = myList[0];
                    if (myList == null) {
                    } else {
                        if (myList.length == 0) { }
                        else {
                            if (parseFloat(myList.length) > 0) {
                                $("[id*=dvGrph]").show();
                                $("[id*=dvSelect]").hide();
                                $("[id*=BtnBack]").show();
                                $("[id*=btnAudit]").hide();

                                $("[id*=lblProject]").html($("[id*=hdnProjectName]").val());
                                var ii = 0;
                                var mondate = [], Hrsdt = [];
                                for (var i = 0; i < myList.length; i++) {

                                    mondate.push(myList[i].Monthdate);
                                    Hrsdt.push(parseInt(myList[i].Hrs));
                                    ii = i;
                                }
                                $("[id*=lblDate]").html(myList[0].Monthdate + ' - ' + myList[ii].Monthdate);

                                var ctx = document.getElementById("myChart");
                                var myChart = new Chart(ctx, {
                                    type: 'bar',
                                    data: {
                                        //labels: [myList[0].Monthdate, myList[1].Monthdate, myList[2].Monthdate, myList[3].Monthdate, myList[4].Monthdate, myList[5].Monthdate, myList[6].Monthdate, myList[7].Monthdate, myList[8].Monthdate, myList[9].Monthdate, myList[10].Monthdate, myList[11].Monthdate],
                                        labels: mondate,
                                        datasets: [{
                                            label: 'Timesheet',
                                            //data: [myList[0].Hrs, myList[1].Hrs, myList[2].Hrs, myList[3].Hrs, myList[4].Hrs,
                                            // myList[5].Hrs, myList[6].Hrs, myList[7].Hrs, myList[8].Hrs, myList[9].Hrs, myList[10].Hrs, myList[11].Hrs],
                                            data: Hrsdt,
                                            backgroundColor: ['rgba(153, 102, 255, 0.2)', 'rgba(153, 102, 255, 0.2)', 'rgba(153, 102, 255, 0.2)', 'rgba(153, 102, 255, 0.2)',
                                            'rgba(153, 102, 255, 0.2)', 'rgba(153, 102, 255, 0.2)', 'rgba(153, 102, 255, 0.2)', 'rgba(153, 102, 255, 0.2)', 'rgba(153, 102, 255, 0.2)',
                                            'rgba(153, 102, 255, 0.2)', 'rgba(153, 102, 255, 0.2)', 'rgba(153, 102, 255, 0.2)'
                                            ],
                                            borderColor: ['rgba(153, 102, 255, 1)', 'rgba(153, 102, 255, 1)', 'rgba(153, 102, 255, 1)', 'rgba(153, 102, 255, 1)', 'rgba(153, 102, 255, 1)',
                                       'rgba(153, 102, 255, 1)', 'rgba(153, 102, 255, 1)', 'rgba(153, 102, 255, 1)', 'rgba(153, 102, 255, 1)', 'rgba(153, 102, 255, 1)',
                                       'rgba(153, 102, 255, 1)', 'rgba(153, 102, 255, 1)'
                                            ],
                                            borderWidth: 1
                                        }]
                                    },
                                    options: {
                                        scales: {
                                            yAxes: [{
                                                ticks: {
                                                    beginAtZero: true
                                                }
                                            }]
                                        }
                                    }
                                });

                                myList = myList[0];
                                var mytbl = myList.list_Audit_Details;
                                $("[id*=lblST]").html(mytbl[0].Sdate);
                                $("[id*=lblED]").html(mytbl[0].Endate);
                                $("[id*=lblDays]").html(mytbl[0].TotalDays);
                                $("[id*=lblDep]").html(mytbl[0].depCnt);
                                $("[id*=lblTeam]").html(mytbl[0].StfCnt);
                                $("[id*=lblPPer]").html(mytbl[0].PPer);
                                $("[id*=lblRPer]").html(mytbl[0].Peramt);
                                $("[id*=lblTHrs]").html(mytbl[0].Thrs);
                                $("[id*=lblBHrs]").html(mytbl[0].Bhrs);
                                $("[id*=lblRhrs]").html(mytbl[0].Rhrs);
                                $("[id*=lblTbill]").html(mytbl[0].Total_Invoice);
                                $("[id*=lblCurr]").html(mytbl[0].Currency);
                                $("[id*=lblRbill]").html(mytbl[0].RBills);
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
        });
    });

    function GetProjectName() {
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/wsAudit.asmx/Get_ProjectName",
            data: JSON.stringify(data),
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList == null) {
                } else {
                    if (myList.length == 0) { }
                    else {
                        $("[id*=drpproject]").empty();
                        $("[id*=drpproject]").append("<option value=" + 0 + ">Select</option>");
                        for (var i = 0; i < myList.length; i++) {
                            $("[id*=drpproject]").append("<option value=" + myList[i].Jobid + ">" + myList[i].Projectname + "</option>");
                        }
                        //$("[id*=drpproject]").selectize();
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



</script>
<style type="text/css">
    .cssPageTitle {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        border-bottom: 2px solid #0b9322;
        padding: 7px;
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

    .center {
        margin-left: auto;
        margin-right: auto;
    }

    .tblBorderClass {
        border-collapse: collapse;
    }

        .tblBorderClass th {
            background: #F2F2F2;
        }

        .tblBorderClass td, .tblBorderClass th {
            padding: 5px;
            margin: 0px;
            border: 1px solid #bcbcbc;
        }

        .tblBorderClass tr td:nth-child(1), .tblBorderClass tr td:nth-child(2), .tblBorderClass tr td:nth-child(3) {
            text-align: center;
        }

        .tblBorderClass input[type=text] {
            max-width: 42px;
            min-height: 20px;
        }

        .tblBorderClass tr:hover td {
            background: #c7d4dd !important;
        }
</style>



<div class="page-content">
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnJobid" />
    <asp:HiddenField runat="server" ID="hdnProjectName" />
    <asp:HiddenField runat="server" ID="hdnFrom" />
    <asp:HiddenField runat="server" ID="hdnTo" />
    <div class="content-wrapper">
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Project Audit</span></h4>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>

                </div>
                <%-- <asp:Button ID="btngen" runat="server" OnClick="btngen_Click" CssClass=""
                    Text="Generate Report" />--%>
                <input id="btnAudit" type="button" value="Audit" class="btn bg-success legitRipple" />

                <%--      <asp:Button ID="Button1" Style="float: left" runat="server" CssClass="" Text="Back" Visible="false" />--%>
                <input type="button" id="BtnBack" value="Back" class="btn btn-primary legitRipple" style="display: none;" />

            </div>
        </div>

        <div class="content">
            <div class="divstyle card">
                <div id="" class="totbodycatreg" style="height: 700px;">
                    <div style="width: 100%;">
                        <uc2:MessageControl ID="MessageControl1" runat="server" />
                    </div>
                    <div runat="server">
                        <div class="card-body" id="dvSelect">
                            <div class="datatable-header">
                                <div id="DataTables_Table_1_filter" class="form-group row">
                                    <div class="col-2">
                                        <label style="font-weight: bold; padding-top: 10px;">Select Project</label>
                                    </div>
                                    <div class="col-3">
                                        <select id="drpproject" name="drpproject" class="form-control select-search" data-fouc>
                                        </select>

                                    </div>

                                    <div style="width: 50px;"></div>
                                    <div>
                                        <label style="font-weight: bold; padding-top: 10px;">From</label>

                                    </div>
                                    <div class="col-2">
                                        <input type="date" id="txtfrom" name="txtfrom" class="form-control" />

                                    </div>
                                    <div style="width: 50px;"></div>
                                    <div>
                                        <label style="font-weight: bold; padding-top: 10px;">To</label>

                                    </div>
                                    <div class="col-2">
                                        <input type="date" id="txtto" name="txtto" class="form-control" />

                                    </div>
                                </div>

                            </div>

                        </div>

                        <div id="dvEditInvoice2" class="row">
                            <div class="card-body">
                                <div id="dvGrph">
                                    <div>
                                    </div>
                                    <div>
                                        <table style="width: 100%;">
                                            <tr>
                                                <td style="text-align: center;">
                                                    <asp:Label runat="server" ID="lblProject" Text="" Font-Bold="true"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center;">
                                                    <asp:Label runat="server" ID="lblDate" Text="" Font-Bold="true" Width="150px"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="chart-container center" style="width: 600px; height: 300px;">
                                                        <canvas id="myChart" style="display: block;" class="chartjs-render-monitor"></canvas>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                        <table style="width: 70%; margin-left: 15%; margin-right: 15%;" class="tblBorderClass">
                                            <tr>
                                                <td style="text-align: center;">St Date</td>
                                                <td style="text-align: center;">End Date</td>
                                                <td style="text-align: center;">Days Left</td>
                                                <td style="text-align: center;">Department</td>
                                                <td style="text-align: center;">Team</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="lblST" Text=""></asp:Label></td>
                                                <td>
                                                    <asp:Label runat="server" ID="lblED" Text=""></asp:Label></td>
                                                <td>
                                                    <asp:Label runat="server" ID="lblDays" Text=""></asp:Label></td>
                                                <td style="text-align: center;">
                                                    <asp:Label runat="server" ID="lblDep" Text=""></asp:Label></td>
                                                <td style="text-align: center;">
                                                    <asp:Label runat="server" ID="lblTeam" Text=""></asp:Label></td>
                                            </tr>
                                        </table>
                                        <div style="height: 25px; width: 100%;">
                                        </div>
                                        <table style="width: 70%; margin-left: 15%; margin-right: 15%;" class="tblBorderClass">
                                            <tr>
                                                <td>Project Progress till date %</td>
                                                <td>
                                                    <asp:Label runat="server" ID="lblPPer" Text=""></asp:Label></td>
                                                <td style="width: 300px;"></td>
                                                <td>Resource Used till date %</td>
                                                <td>
                                                    <asp:Label runat="server" ID="lblRPer" Text=""></asp:Label></td>
                                            </tr>
                                        </table>
                                        <div style="height: 25px; width: 100%;">
                                        </div>
                                        <table style="width: 70%; margin-left: 15%; margin-right: 15%;" class="tblBorderClass">
                                            <tr>
                                                <td style="text-align: center;">Total Hrs</td>
                                                <td style="text-align: center;">Billable Hrs</td>
                                                <td style="text-align: center;">Remain Hrs</td>
                                                <td style="text-align: center;">Total Billing</td>
                                                <td style="text-align: center;">Currency</td>
                                                <td style="text-align: center;">Remaining Billing</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label runat="server" ID="lblTHrs" Text=""></asp:Label></td>
                                                <td>
                                                    <asp:Label runat="server" ID="lblBHrs" Text=""></asp:Label></td>
                                                <td>
                                                    <asp:Label runat="server" ID="lblRhrs" Text=""></asp:Label></td>
                                                <td style="text-align: center;">
                                                    <asp:Label runat="server" ID="lblTbill" Text=""></asp:Label></td>
                                                <td style="text-align: center;">
                                                    <asp:Label runat="server" ID="lblCurr" Text=""></asp:Label></td>
                                                <td style="text-align: center;">
                                                    <asp:Label runat="server" ID="lblRbill" Text=""></asp:Label></td>
                                            </tr>
                                        </table>
                                    </div>

                                </div>
                            </div>

                        </div>

                    </div>


                </div>
            </div>
        </div>
    </div>

</div>







<%--<table class="cssPageTitle" style="width: 100%;">
    <tr>
        <td class="cssPageTitle2">
            <asp:Label ID="lblname" runat="server" Text="Project Audit" Style="margin-left: 50px;"></asp:Label>
        </td>
        <td style="float: right; padding-top: 5px; margin-left: 60px;"></td>
    </tr>
</table>




<div class="divstyle">
    <div id="div2" class="totbodycatreg" style="height: auto;">
        <div style="width: 100%;">
        </div>
        <div class="row_report" runat="server" id="dvSelect">
            <div>
                <table class="style1" style="padding-left: 25px; padding-top: 20px;">
                    <tr>
                        <td style="vertical-align: top;"></td>
                    </tr>
                </table>
            </div>
        </div>

    </div>
</div>--%>
