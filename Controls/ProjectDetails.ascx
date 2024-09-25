<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProjectDetails.ascx.cs" Inherits="controls_ProjectDetails" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit"
    TagPrefix="cc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script src="../jquery/moment.js" type="text/javascript"></script>
<script src="../jquery/jquery-2.2.4.min.js" type="text/javascript"></script>
<script type="text/javascript" src="../menu/datetimepicker_css.js"></script>
<script src="../jquery/Selectize/selectize.js" type="text/javascript"></script>
<script src="../jquery/Selectize/es5.js" type="text/javascript"></script>
<script src="../jquery/Selectize/index.js" type="text/javascript"></script>
<link href="../jquery/Selectize/normalize.css" rel="stylesheet" type="text/css" />

<style type="text/css">
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


    .cssPageTitle2 {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        /*border-bottom: 2px solid #0b9322;*/
        padding: 7px;
        color: #0b9322;
    }

    .cssPageTitle {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        border-bottom: 2px solid #0b9322;
        color: #0b9322;
    }
</style>

<script type="text/javascript">
    $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
    $(document).ready(function () {
        Bind_Project();
        GetProject('');

        $("[id*= Btndsh]").on('click', function () {
            
            $("[id*=dvPrj]").show();
            $("[id*=dvDtls]").hide();
        });

        $("[id*= btnSearch]").on('click', function () {
            var srch = $("[id*=ddlSearch]").val();
            GetProject(srch);
        });

    });

    function DrillData(i) {
        var row = i.closest("tr");
        $("[id*=dvPrj]").hide();
        $("[id*=dvDtls]").show();
        var compid = $("[id*=hdnCompid]").val();

        var Pid = row.find("input[name=hdnPid]").val();
        $("[id*=hdnProjectid]").val(Pid);
        $.ajax({
            type: "POST",
            url: "../Handler/ws_Dashboard.asmx/Drill_Project",
            data: '{compid:"' + compid + '", pid:"' + Pid + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);


                var tbl = '';

                $("[id*=tblDtls] tbody").empty();

                tbl = tbl + "<tr>";
                tbl = tbl + "<th class='labelChange'>Department</th>";
                tbl = tbl + "<th class='labelChange'>StaffName</th>";
                tbl = tbl + "<th >Total Hrs</th>";
                tbl = tbl + "<th >Hourly Charges</th>";
                tbl = tbl + "</tr>";


                if (myList.length > 0) {
                    for (var i = 0; i < myList.length; i++) {
                        tbl = tbl + "<tr>";
                        var s = myList[i].Staffname


                        if (s == 'Total') {
                            tbl = tbl + "<td width='450px' style='text-align:left;'></td>";
                            tbl = tbl + "<td width='300px'  style='text-align:left; font-weight: bold;'>" + myList[i].Staffname + "</td>";
                            tbl = tbl + "<td  width='100px' style='text-align:center; font-weight: bold;'>" + myList[i].TotalTime + "</td>";
                            tbl = tbl + "<td  width='100px' style='text-align:right; font-weight: bold;'>" + myList[i].hCharge + "</td>";
                        }
                        else {
                            tbl = tbl + "<td width='450px' style='text-align:left;'>" + myList[i].Department + "</td>";
                            tbl = tbl + "<td width='300px'  style='text-align:left;'>" + myList[i].Staffname + "</td>";


                            tbl = tbl + "<td  width='100px' style='text-align:center;'>" + myList[i].TotalTime + "</td>";
                            tbl = tbl + "<td  width='100px' style='text-align:right;'>" + myList[i].hCharge + "</td>";
                        }

                        tbl = tbl + "</tr>";
                    }
                    $("[id*=tblDtls]").append(tbl);
                    myList = myList[0];
                    if (myList.list_Project_Details != null || myList.list_Project_Details.length > 0) {


                        $("[id*=Label10]").html(myList.list_Project_Details[0].Project);
                        $("[id*=Label9]").html(myList.list_Project_Details[0].StartDT);
                        $("[id*=Label12]").html(myList.list_Project_Details[0].EndDT);
                    }
                }
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
        $('.loader').hide();
    }

    function GetProject(srch) {
        var fr = $("[id*=txtfrom]").val();
        var to = $("[id*=txtto]").val();
        var compid = $("[id*=hdnCompid]").val();
        var Status = $("[id*=ddlStatus]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/ws_Dashboard.asmx/bind_Project",
            data: '{compid:"' + compid + '", fr:"' + fr + '", to:"' + to + '", srch:"' + srch + '",Status:"' + Status + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var tbl = '';
                $("[id*=tblPrj] tbody").empty();

                tbl = tbl + "<tr>";
                tbl = tbl + "<th ></th>";
                tbl = tbl + "<th class='labelChange'>Project</th>";
                tbl = tbl + "<th >Start Date</th>";
                tbl = tbl + "<th >End Date</th>";
                tbl = tbl + "<th >Status</th>";
                tbl = tbl + "<th class='labelChange'>Department</th>";
                tbl = tbl + "<th >Team</th>";
                tbl = tbl + "<th >Total Hrs</th>";
                tbl = tbl + "<th >Project Cost</th>";
                tbl = tbl + "</tr>";


                if (myList.length > 0) {
                    for (var i = 0; i < myList.length; i++) {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td style='text-align:center;cursor: pointer;'><img src='../Images/greenplus.jpg' style='height: 20px; width: 20px;' onclick='DrillData($(this))' /> </td>";
                        tbl = tbl + "<td style='text-align:left;'>" + myList[i].Project + "<input type='hidden' id='hdnPid' value='" + myList[i].ProjectId + "' name='hdnPid'></td>";
                        tbl = tbl + "<td style='text-align:center;'>" + myList[i].Startdt + "</td>";
                        tbl = tbl + "<td style='text-align:center;'>" + myList[i].Enddt + "</td>";
                        tbl = tbl + "<td style='text-align:left;'>" + myList[i].JobStatus + "</td>";
                        tbl = tbl + "<td style='text-align:center;'>" + myList[i].Department + "</td>";
                        tbl = tbl + "<td style='text-align:center;'>" + myList[i].TCount + "</td>";
                        tbl = tbl + "<td style='text-align:center;'>" + myList[i].TotalTime + "</td>";
                        tbl = tbl + "<td style='text-align:right;'>" + myList[i].hCharge + "</td>";

                        tbl = tbl + "</tr>";
                    }
                    $("[id*=tblPrj]").append(tbl);
                }
                else {
                    tbl = tbl + "<tr>";
                    tbl = tbl + "<td ></td>";
                    tbl = tbl + "<td > </td>";
                    tbl = tbl + "<td >No Record Found !!!</td>";
                    tbl = tbl + "<td ></td>";
                    tbl = tbl + "<td ></td>";
                    tbl = tbl + "<td ></td>";
                    tbl = tbl + "<td ></td>";
                    tbl = tbl + "<td ></td>";
                    tbl = tbl + "<td ></td>";
                    tbl = tbl + "</tr>";
                    $("[id*=tblPrj]").append(tbl);
                }
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
        $('.loader').hide();
    }
    function Bind_Project() {
        var fr = $("[id*=txtfrom]").val();
        var to = $("[id*=txtto]").val();
        var compid = $("[id*=hdnCompid]").val();

        $.ajax({
            type: "POST",
            url: "../Handler/ws_Dashboard.asmx/Project_Dropdown",
            data: '{compid:"' + compid + '", fr:"' + fr + '", to:"' + to + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var tbl = '';
                $("[id*=ddlSearch]").empty();
                $("[id*=ddlSearch]").append("<option value=0>--Select--</option>");
                for (var i = 0; i < myList.length; i++) {

                    $("[id*=ddlSearch]").append("<option value='" + myList[i].ProjectId + "'>" + myList[i].Project + "</option>");
                }
                $('#ddlSearch').selectize({
                });

            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
        $('.loader').hide();
    }
    </script>

<div class="divstyle" style="height: auto">

    <table style="width: 100%" class="cssPageTitle">
        <tr>
            <td class="cssPageTitle2">
                <asp:Label ID="Label4" runat="server" CssClass="labelChange" Style="margin-left: 10px;" Text="Project Cost"></asp:Label>
               
            </td>
        </tr>
    </table>
</div>

    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnDept" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
    <asp:HiddenField runat="server" ID="hdnStaffrole" />
    <asp:HiddenField runat="server" ID="hdnDeptwise" />
    <asp:HiddenField runat="server" ID="hdnSrch" value="0"/>
    <asp:HiddenField runat="server" ID ="hdnProjectid" Value ="0" />
    <asp:HiddenField runat="server" ID="hdnStatus" Value="OnGoing" />

   <div id="dvPrj" style="padding-top:20px;">

            <table width="100%">
                <tr>
                    <td style="width:50px;"></td>
                             <td style="width: 25px">
                                            <asp:Label ID="Label3" runat="server" Text="From" ForeColor="Black" Font-Bold="True"
                                                Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                                        </td>
                     <td style="width: 107px">
                                            <span style="float: left;">
                                                <asp:TextBox ID="txtfrom" runat="server" CssClass="texboxcls" Width="75px"></asp:TextBox>
                                            </span>
                                            <div style="position: relative; float: left;">
                                                <asp:Image ID="Image2" runat="server" ImageUrl="~/images/calendar.png" />
                                            </div>
                                            <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtfrom"
                                                PopupButtonID="Image2" Format="dd/MM/yyyy" Enabled="True">
                                            </cc1:CalendarExtender>
                                        </td>
                                        <td style="width: 20px">
                                            <asp:Label ID="Label2" runat="server" Text="To" ForeColor="Black" Font-Bold="True"
                                                Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                                        </td>
                    <td style="width: 130px">
                                            <span style="float: left;">
                                                <asp:TextBox ID="txtto" runat="server" CssClass="texboxcls" Width="75px"></asp:TextBox>
                                            </span>
                                            <div style="float: left;">
                                                <asp:Image ID="Image3" runat="server" ImageUrl="~/images/calendar.png" />
                                            </div>
                                            <cc1:CalendarExtender ID="Calendarextender2" runat="server" TargetControlID="txtto"
                                                PopupButtonID="Image3" Format="dd/MM/yyyy" Enabled="True">
                                            </cc1:CalendarExtender>
                                        </td>
                    <td style="width: 80px;">
                        <asp:Label runat="server" ID="Label13" CssClass="labelchange" Text="Project" Font-Bold="true"></asp:Label>
                    </td>
                    <td style="width: 300px;">
                        <select id="ddlSearch" name="ddlSearch" class='Dropdown' style='width: 280px; font-size: 10px;'>
                            <option value="0">Select</option>
                        </select>
                    </td>
                                       <td style="width:100px;">
                        <select id="ddlStatus" name="ddlStatus" class='Dropdown' style='width: 90px; font-size: 12px;'>
                            <option value="All">All</option>
                             <option value="OnGoing" selected>OnGoing</option>
                            <option value="Completed">Completed</option>
                        </select>
                    </td>

                    <td style="width: 100px; font: bold; font-weight: bold;">
                        <input id="btnSearch" type="button" value="Search" class="cssButton" />
                    </td>

                    <td style="width: 200px; font: bold; font-weight: bold;">
                        <asp:ImageButton ID="btnExport_Project" runat="server" ImageUrl="~/images/xls-icon.png"
                            OnClick="btnExport_Project_Click" />
                    </td>
                </tr>
            </table>
            <div style="padding-top: 30px;">
                <table id="tblPrj" class="tblBorderClass" style="width: 1196px;">

                    <tbody>
                        <tr style="color: rgb(0, 0, 102); height: 15px;">

                            <td width="80px"></td>
                            <td width="450px" style="text-align: right"></td>
                            <td width="300px" style="text-align: right"></td>
                            <td width="300px" style="text-align: right"></td>
                            <td width="150px" style="text-align: right"></td>
                            <td width="150px" style="text-align: right"></td>
                            <td width="80px"></td>

                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

     <div id="dvDtls" style="display:none;padding-top:20px;">
            <input type="button" id="Btndsh" value="Back" class="cssButton" />

                      

            <div style="padding-top: 10px;">
                <table runat="server" id="Table1" cellpadding="0" cellspacing="0" width="884px" height="40px" class="norecordTble" style="border-collapse: collapse;">
                    <tr valign="middle">
                        <td>

                            <asp:Label runat="server" ID="Label1" Text="Project"
                                Font-Bold="true" Width="50px"></asp:Label>
                        </td>
                        <td>

                            <asp:Label runat="server" ID="Label10" Text=""
                                Font-Bold="true" Width="380px"></asp:Label>
                        </td>
                        <td>
                            <asp:Label runat="server" ID="Label6" Text="Start Date"
                                Font-Bold="true" Width="80px"></asp:Label>
                        </td>
                        <td>
                            <asp:Label runat="server" ID="Label9" Text=""
                                Font-Bold="true" Width="100px"></asp:Label>
                        </td>
                        <td>
                            <asp:Label runat="server" ID="Label11" Text="End Date"
                                Font-Bold="true" Width="80px"></asp:Label>
                        </td>
                        <td>
                            <asp:Label runat="server" ID="Label12" Text=""
                                Font-Bold="true" Width="100px"></asp:Label>
                        </td>
                        <td><asp:ImageButton ID="Export_Details" runat="server" ImageUrl="~/images/xls-icon.png"
                            OnClick="Export_Details_Click" /></td>
                    </tr>
                            
                </table>
              
            </div>
            <div style="padding-top: 30px;">
                <table id="tblDtls" class="tblBorderClass" style="width: 1196px;">

                    <tbody>
                        <tr style="color: rgb(0, 0, 102); height: 15px;">

                            <td width="450px" style="text-align: right"></td>
                            <td width="300px" style="text-align: right"></td>
                            <td width="100px"></td>
                            <td width="100px"></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
