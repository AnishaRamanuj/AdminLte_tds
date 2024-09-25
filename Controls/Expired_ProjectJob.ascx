<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Expired_ProjectJob.ascx.cs" Inherits="controls_Expired_ProjectJob" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script src="../jquery/moment.js" type="text/javascript"></script>
<%--<script src="../jquery/jquery-3.4.1.min.js" type="text/javascript"></script>--%>
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>

<script type="text/javascript">
    $(document).ready(function () {

        $("[id*= txtfrom]").on('change', function () {
            GetEndProject();
        });

        $("[id*= txtto]").on('change', function () {
            GetEndProject();
        });

        $("[id*= btnSaveJob]").on('click', function () {
            UpdateExtenddate();
        });

        $("[id*= btnSrch]").on('click', function () {
            GetEndProject();
        });

        var a = new Date();
        var dt= moment(a).format('YYYY-MM-DD')
        $("[id*=extdt]").val(dt);

        $("[id*=dvextdt]").hide();

        GetEndProject();

        $('#extdt').on('change', function () {
            var dt = $('#extdt').val();

            if (dt == "") {
                alert("Kindly Do Not Keep Blank Dates!!!");
                return false;
            } else {

                $("input[name=chkEjob]").each(function () {
                    var row = $(this).closest("tr");
                    var chk = $(this).is(':checked');
                    if (chk == true) {
                        row.find("input[name=updt]").val(dt);
                    }
                });
            }
        });

    });


    ///for updating the end date of Project/job in job_master 
    function UpdateExtenddate() {
        var compid = $("[id*=hdnCompanyid]").val();
        var chk = "", row = "", enddt = "", rid = "";
        $("input[name=chkEjob]").each(function () {
            row = $(this).closest("tr");
            chk = $(this).is(':checked');
            if (chk == true) {
                enddt = row.find("input[name=updt]").val();
                if (enddt == "") {
                    alert("Kindly Do Not Keep Blank Dates!!!");
                    return false;
                } else {
                    rid = $(this).val() + ',' + enddt + '^' + rid;
                }
            }
        });
        if (rid == "") {
            alert("Kindly select atleast one record!!!");
            return false;
        }
        $.ajax({
            type: "POST",
            url: "../Handler/ws_Dashboard.asmx/UpdateEndProject",
            data: '{compid:' + compid + ', Rid:"' + rid + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList[0].Jobid == 1) {
                    alert("Updated Successfully !!!");
                    GetEndProject();
                    $("[id*=dvextdt]").hide();
                } else {

                }
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }

    function AllJobcheck(i) {
        var chkprop = i.is(':checked');
        
        if (chkprop) {
            $("[id*=chkEjob]").attr('checked', 'checked');
            $("[id*=updt]").attr("disabled", false);
            $("[id*=dvextdt]").show();
        }
        else {
            $("[id*=chkEjob]").removeAttr('checked');
            $("[id*=updt]").attr("disabled", true);
            $("[id*=dvextdt]").hide();
        }
    }


    ///single check
    function singleJobcheck(i) {
        var chks = i.is(':checked');
        var row = i.closest("tr");
        if (chks) {
            $("#updt", row).attr("disabled", false);
        } else {
            $("#updt", row).attr("disabled", true);
            $("#chkEjob", row).removeAttr('checked');
        }
    }

    function GetEndProject() {
        var compid = $("[id*=hdnCompanyid]").val();
        var Startdate = $("[id*=txtfrom]").val();
        var Enddate = $("[id*=txtto]").val();
        var Deptwise = $("[id*=hdnDept]").val();
        var ddl = $("[id*=ddlselect]").val();
        var Srch = $("[id*=txtsearch]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/ws_Dashboard.asmx/GetEndProject",
            data: '{compid:' + compid + ', Startdt:"' + Startdate + '",Enddt:"' + Enddate + '",Deptwise:' + Deptwise + ',ddl:"' + ddl + '",Srch:"' + Srch + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                var tbl = "", head = "";

                $("[id*=tblEndProject]").empty();
                head = head + "<tr>";
                head = head + "<th ><input type='checkbox' id='chkAll' name='chkAll' onclick='AllJobcheck($(this))' /></th>";
                head = head + "<th class='labelChange'>Client Name</th>";
                if ($("[id*=hdnDept]").val() == 1) {
                    head = head + "<th class='labelChange'>Project Name</th>";
                    $("[id*=lblpopup]").html('Projects Going To Be Expired');
                }
                else {
                    head = head + "<th class='labelChange'>Job Name</th>";
                    $("[id*=lblpopup]").html('Jobs Going To Be Expired');
                }
                head = head + "<th >Start Date</th>";
                head = head + "<th >End Date</th>";

                head = head + "</tr>";
                $("[id*=tblEndProject]").append(head);

                if (myList == null) {
                } else {
                    if (myList.length == 0) {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td >" + 'No Records Found...' + "</td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "</tr>";
                        $("[id*=tblEndProject]").append(tbl);
                        $("[id*=chkAll]").hide();
                    }
                    else {
                        if (myList.length > 0) {

                            $("[id*=lbljobcount]").html('(' + myList[0].Count + ')');
                            for (var i = 0; i < myList.length; i++) {
                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td style='text-align: center;'><input type='checkbox' id='chkEjob' name='chkEjob' onclick='singleJobcheck($(this))' value='" + myList[i].Jobid + "' /></td>";
                                tbl = tbl + "<td >" + myList[i].ClientName + "</td>";
                                tbl = tbl + "<td >" + myList[i].PrjName + "</td>";
                                tbl = tbl + "<td style='text-align: center;'>" + moment(myList[i].Strtdt).format('DD/MM/YYYY') + "</td>";
                                tbl = tbl + "<td style='text-align: center;'><input type='date' id='updt' name='updt' value='" + moment(myList[i].Enddt).format('YYYY-MM-DD') + "' disabled /></td></td>";
                                tbl = tbl + "</tr>";
                            }
                            $("[id*=tblEndProject]").append(tbl);
                        }
                        else {
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td >" + 'No Records Found...' + "</td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "</tr>";
                            $("[id*=tblEndProject]").append(tbl);
                            $("[id*=chkAll]").hide();
                        }
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
    }
</script>

<style type="text/css">
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

<div class="divstyle" style="height: auto">

    <table style="width: 100%" class="cssPageTitle">
        <tr>
            <td class="cssPageTitle2">
                <asp:Label ID="Label4" runat="server" CssClass="labelChange" Style="margin-left: 10px;" Text="Ending Project / Job "></asp:Label>
                <asp:Label ID="lbljobcount" runat="server" CssClass="labelChange" Text=""></asp:Label>
            </td>
            <td style="text-align-last: right; padding-right: 10px;">
                <input id="btnSaveJob" value="Save" runat="server" class="cssButton" width="25%" type="button" />
            </td>
        </tr>
    </table>
</div>
<asp:HiddenField runat="server" ID="hdnCompanyid" />
<asp:HiddenField runat="server" ID="hdnDept" />
<div>
    <div runat="server">
        <div>
            <div style="float: left; width: 100%; margin: 10px; padding-bottom: 5px; overflow: auto;" id="searchdesg"
                runat="server">
                <table>
                    <tr>
                        <td style="width: 25px; padding-left: 10px; padding-right: 15px;">
                            <asp:Label ID="Label2" runat="server" Text="Search" ForeColor="Black" Font-Bold="True"
                                Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                        </td>
                    <td>
                        <asp:DropDownList ID="ddlselect" runat="server" CssClass="cssTextbox" Height="22px">
                               <asp:ListItem Value="Client" Text="Client"></asp:ListItem>
                            <asp:ListItem Value="Project" Text="Project"></asp:ListItem>
                         
                        </asp:DropDownList>
                    </td>
                    <td style="padding-left:10px;">
                        <input id="txtsearch" name="txtsearch" class="texboxcls" type="text" style="font-size:12px; width:250px;"/>
          
                    </td>
                    <td style="padding-left:30px;">
                        <button id="btnSrch" type="button" class="cssButton">Search</button>
                  
                    </td>
                        <td style="width: 25px; padding-left: 10px; padding-right: 15px;">
                            <asp:Label ID="Label14" runat="server" Text="From" ForeColor="Black" Font-Bold="True"
                                Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                        </td>
                        <td style="width: 107px; padding-right: 30px;">
                            <span style="float: left;">
                                <asp:TextBox ID="txtfrom" runat="server" CssClass="texboxcls" Width="71px"></asp:TextBox>
                            </span>
                            <div style="position: relative; float: left;">
                                <asp:Image ID="Image2" runat="server" ImageUrl="~/images/calendar.png" />
                            </div>
                            <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtfrom"
                                PopupButtonID="Image2" Format="dd/MM/yyyy" Enabled="True">
                            </cc1:CalendarExtender>
                        </td>
                        <td style="width: 25px; padding-right: 15px;">
                            <asp:Label ID="Label16" runat="server" Text="To" ForeColor="Black" Font-Bold="True"
                                Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                        </td>
                        <td style="width: 107px">
                            <span style="float: left;">
                                <asp:TextBox ID="txtto" runat="server" CssClass="texboxcls" Width="71px"></asp:TextBox>
                            </span>
                            <div style="float: left;">
                                <asp:Image ID="Image3" runat="server" ImageUrl="~/images/calendar.png" />
                            </div>
                            <cc1:CalendarExtender ID="Calendarextender2" runat="server" TargetControlID="txtto"
                                PopupButtonID="Image3" Format="dd/MM/yyyy" Enabled="True">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="dvextdt">
            <table>
                <tr>
                    <td style="padding-left: 10px; padding-right: 15px;">
                        <asp:Label ID="Label1" runat="server" Text="Extend Date" ForeColor="Black" Font-Bold="True"
                            Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                    </td>
                    <td>
                        <input id="extdt" name="extdt" type="date"/>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <div>
        <div class="divfloatleftn divfloatleftnTble" style="float: left; margin: 10px; width: 98%; height: 700px; overflow: scroll">
            <table id="tblEndProject" class="allTimeSheettle" style="border-collapse: collapse;"></table>
        </div>
    </div>
</div>
