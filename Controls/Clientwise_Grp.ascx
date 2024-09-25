<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Clientwise_Grp.ascx.cs" Inherits="controls_Clientwise_Grp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>
<script src="../jquery/Selectize/selectize.js" type="text/javascript"></script>
<script src="../jquery/Selectize/es5.js" type="text/javascript"></script>
<script src="../jquery/Selectize/index.js" type="text/javascript"></script>
<link href="../jquery/Selectize/normalize.css" rel="stylesheet" type="text/css" />


<script type="text/javascript">

    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        GetClientName();

        $("[id*=drpclient]").on("change", function () {
            var Clientname = $("[id*=drpclient]").text();
            $("[id*=hdnClientName]").val(Clientname);
            GetProjectName();
        });

        ////check all Project
        $("[id*=chkProject]").on("click", function () {
            if ($(".clProject").length == 0)
            { return false; }
            var check = $(this).attr('checked');
            $(".clProject").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else {
                    $(this).removeAttr('checked');
                }
            });
            GetAllSelected();
        });

    });

    //////check single Project
    function singleProjcheck() {
        if ($(".clProject").length == $(".clProject:checked").length)
        { $("[id*=chkProject]").attr('checked', true); }
        else { $("[id*=chkProject]").removeAttr('checked'); }
        GetAllSelected();
    }

    function GetAllSelected() {
        var selectProject = '';
        $(".clProject:checked").each(function () {
            selectProject += $(this).val() + ',';
        });
        $("[id*=hdnSelectedProject]").val(selectProject);

    }


    function GetProjectName() {
        //GetAllSelected();
        if ($("[id*=txtmonth]").val() == "" || $("[id*=txtmonth]").val() == undefined || $("[id*=drpclient]").val() == "")
        { return false; }
        $('.loader').show();
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                cltid: $("[id*=drpclient]").val(),

            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Report_Staff_ProjectwiseHours.asmx/Get_Client_Project",
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
        var tableRowsProj = '';
        var countProj = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "Project") {
                countProj += 1;
                tableRowsProj += "<tr><td><input type='checkbox' onclick='singleProjcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });

        $("[id*=chkProject]").removeAttr('checked');
        $("[id*=chkProject]").parent().find('label').text("Project (" + countProj + ")");
        $("[id*=Panel1]").html("<table>" + tableRowsProj + "</table>");

        $(".modalganesh").hide();
        GetAllSelected();
    }

    function GetClientName() {
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Report_Staff_ProjectwiseHours.asmx/Get_ClientName",
            data: JSON.stringify(data),
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList == null) {
                } else {
                    if (myList.length == 0) { }
                    else {
                        $("[id*=drpclient]").empty();
                        $("[id*=drpclient]").append("<option value=" + 0 + ">Select</option>");
                        for (var i = 0; i < myList.length; i++) {
                            $("[id*=drpclient]").append("<option value=" + myList[i].cltid + ">" + myList[i].clientname + "</option>");
                        }
                        $("[id*=drpclient]").selectize();
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

    button {
        background-color: #6BBE92;
        width: 302px;
        border: 0;
        padding: 10px 0;
        margin: 5px 0;
        text-align: center;
        color: #fff;
        font-weight: bold;
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

<div>
    <asp:Label ID="Label1" runat="server" CssClass="Head1 labelChange"></asp:Label>

    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnClientName" />
    <asp:HiddenField runat="server" ID="hdnSelectedProject" />
</div>
<table class="cssPageTitle" style="width: 100%;">
    <tr>
        <td class="cssPageTitle2">
            <asp:Label ID="lblname" runat="server" Text="Clientwise Report" Style="margin-left: 10px;"></asp:Label>
        </td>
        <td style="float: right; padding-top: 5px; margin-left: 60px;">
            <asp:Button ID="btngenexp" runat="server" OnClick="btngenexp_Click" CssClass="cssButton"
                Text="Generate Report" />
        </td>
    </tr>
</table>
<div class="divstyle">
    <div id="div2" class="totbodycatreg" style="height: auto;">
        <div style="width: 100%;">
            <uc2:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div class="row_report" runat="server" id="divReportInput">
            <div style="overflow: hidden; width: 100%; margin-top: 10px;">
                <div style="float: left; width: 40%;">
                    <table>
                        <tr>
                            <td style="width: 10px;"></td>
                            <td style="font-weight: bold;" cssclass="LabelFontStyle labelChange">Select Client</td>
                            <td>:</td>
                            <td>
                                <asp:DropDownList ID="drpclient" runat="server" CssClass="DropDown" Width="335px" Height="30px">
                                </asp:DropDownList>

                            </td>
                        </tr>
                    </table>
                    <table>
                        <tr>
                            <td style="height:50px;"></td>
                            <td style="font-weight: bold;">&nbsp;&nbsp; Month
                            </td>
                            <td>:</td>
                            <td>
                                <asp:TextBox ID="txtmonth" runat="server" Width="50px" CssClass="texboxcls"></asp:TextBox>
                                <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" />
                                <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                                <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtmonth"
                                    PopupButtonID="Img1" Format="MM/yyyy">
                                </cc1:CalendarExtender>
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="float: right; width: 60%;">
                    <table>
                        <tr>
                            <td style="width: 410px; padding-left: 50px;">
                                <asp:CheckBox ID="chkProject" runat="server" ForeColor="Black"
                                    Font-Bold="true" Height="20px" Text="Project(Count : 0)" CssClass="labelChange" />
                                <div id="Panel1" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                    <div id="content">
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

