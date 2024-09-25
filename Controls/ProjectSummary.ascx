<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProjectSummary.ascx.cs" Inherits="controls_ProjectSummary" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="http://code.jquery.com/jquery-1.6.4.js"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>

<script lang="javascript" type="text/javascript">
    var needproject = true, needdept = false;
    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        pageFiltersReset();

        $('#ddlType').on('change', function () {
            BindPageLoadProject();
            var t = $("[id*=ddlType]").val();
            $("[id*=hdnStype]").val(t);
        });

        $('#ddlBill').on('change', function () {
            BindPageLoadProject();
        });
        $("[id*=txtstartdate1]").on("change", function () {
            pageFiltersReset();
        });
        $("[id*=txtenddate2]").on("change", function () {
            pageFiltersReset();
        });

        /////////check all Project
        $("[id*=chkProject]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clProject").attr('checked', 'checked');
            }
            else {
                $(".clProject").removeAttr('checked');
            }
            singleProjectcheck();
            $('.modalganesh').css('display', 'none');
        });


        $("[id*=btngen]").on("click", function () {
            $("[id*=hdnbilltype]").val($("[id*=ddlBill]").val());
        });

        ////check all Dept
        $("[id*=chkDepartment]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clDept").attr('checked', 'checked');
            }
            else {
                $(".clDept").removeAttr('checked');
            }
            $('.modalganesh').css('display', 'none');
        });
    });

    function BindPageLoadProject() {
        GetAllSelected();
        if ($("[id*=txtstartdate1]").val() == "" || $("[id*=txtstartdate1]").val() == undefined)
        { return false; }
        //$('.loader').show();
        $(".modalganesh").show();
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                selectedProjectId: $("[id*=hdnSelectedProjectid]").val(),
                Fromdate: $("[id*=txtstartdate1]").val(),
                Todate: $("[id*=txtenddate2]").val(),
                Rtype: '',
                needProject: needproject,
                needDept: needdept,
                status: $("[id*=ddlType]").val(),
                btype: $("[id*=ddlBill]").val(),
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/WS_ProjectDeptHrs.asmx/Get_Project_Dept",
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
        var tableRowsproject = '', tableRowsdept = '';
        var countproject = 0, countdept = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "Dept") {
                countdept += 1;
                tableRowsdept += "<tr><td><input type='checkbox' onclick='singleDeptcheck()'  checked='checked'  class='cl" + vl.Type + "' value='" + vl.id + "' /></td><td>" + vl.Name + "</td></tr>";
            }
            else if (vl.Type == "Project") {
                countproject += 1;
                tableRowsproject += "<tr><td><input type='checkbox' onclick='singleProjectcheck()' class='cl" + vl.Type + "' value='" + vl.id + "' /></td><td>" + vl.Name + "</td></tr>";
            }
        });
        if (needproject) {
            $("[id*=chkProject]").removeAttr('checked');
            $("[id*=chkProject]").parent().find('label').text("Project(" + countproject + ")");
            $("[id*=Panel1]").html("<table>" + tableRowsproject + "</table>");
        }
        if (needdept) {

            if (countdept != 0) {

                $("[id*=chkDepartment]").attr('checked', 'checked');
            }
            else {
                $("[id*=chkDepartment]").removeAttr('checked');
            }

            $("[id*=chkDepartment]").parent().find('label').text("Department (" + countdept + ")");
            $("[id*=Panel2]").html("<table>" + tableRowsdept + "</table>");
        }
        $(".modalganesh").hide();
        GetAllSelected();
    }

    function GetAllSelected() {
        var selectproject = '', selectdept = '';
        $(".clProject:checked").each(function () {
            selectproject += $(this).val() + ',';
        });
        $(".clDept:checked").each(function () {
            selectdept += $(this).val() + ',';
        });
        $("[id*=hdnSelectedProjectid]").val(selectproject);

        $("[id*=hdnselectedDeptid]").val(selectdept);
    }

    function singleProjectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length) {
            $("[id*=chkProject]").attr('checked', true);
        }
        else {
            $("[id*=chkProject]").removeAttr('checked');

        }
        needproject = false, needdept = true;
        BindPageLoadProject();
    }



    function singleDeptcheck() {
        if ($(".clDept").length == $(".clDept:checked").length)
        { $("[id*=chkDepartment]").attr('checked', true); }
        else { $("[id*=chkDepartment]").removeAttr('checked'); }

    }


    function pageFiltersReset() {
        needproject = true, needdept = false;
        $("[id*=chkProject]").removeAttr('checked');
        $("[id*=chkProject]").parent().find('label').text("Project (Count : 0)");
        $("[id*=chkDepartment]").removeAttr('checked');
        $("[id*=chkDepartment]").parent().find('label').text("Department (Count : 0)");

        $("[id*=Panel1]").html('');
        $("[id*=Panel2]").html('');
        BindPageLoadProject();
    }
</script>
<style type="text/css">
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
<div class="divstyle">
    <div class="headerpage">
        <div>
            <table class="cssPageTitle" style="width: 100%;">
                <tr>
                    <td class="cssPageTitle2">
                        <asp:Label ID="lblname" runat="server" Text="Project Summary" Style="margin-left: 10px;"></asp:Label>
                    </td>
                    <td style="float: right; padding-top: 5px; margin-left: 60px;">
                        <asp:Button ID="btngen" runat="server" OnClick="btngen_Click" CssClass="cssButton"
                            Text="Generate Report" />
                    </td>
                </tr>
            </table>

            <asp:HiddenField runat="server" ID="hdnbilltype" />
            <asp:HiddenField runat="server" ID="hdnCompid" />
            <asp:HiddenField runat="server" ID="hdnSelectedProjectid" />
            <asp:HiddenField runat="server" ID="hdnselectedDeptid" />
            <asp:HiddenField runat="server" ID="hdnStype" />

        </div>
    </div>

    <div id="div2" class="totbodycatreg" style="height: 500px;">
        <div style="width: 100%;">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
        </div>

        <div>
            <table style="margin-left: 10px; margin-top: 10px;">
                <tr>
                    <td>
                        <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From"
                            Font-Bold="True"></asp:Label>
                    </td>
                    <td>:
                    </td>
                    <td>
                        <asp:TextBox ID="txtstartdate1" runat="server" CssClass="texboxcls" Width="70px"></asp:TextBox>
                        <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" />
                        <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle"
                            ForeColor="Red" Text=""></asp:Label>
                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtstartdate1"
                            PopupButtonID="Img1" Format="dd/MM/yyyy">
                        </cc1:CalendarExtender>
                    </td>
                    <td></td>
                    <td>
                        <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To"
                            Font-Bold="True"></asp:Label>
                    </td>
                    <td>:
                    </td>
                    <td>
                        <asp:TextBox ID="txtenddate2" runat="server" CssClass="texboxcls" Width="70px"></asp:TextBox>
                        <asp:Image ID="Img2" runat="server" ImageUrl="~/images/calendar.png" />
                        <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle"
                            ForeColor="Red" Text=""></asp:Label>
                        <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtenddate2"
                            PopupButtonID="Img2" Format="dd/MM/yyyy">
                        </cc1:CalendarExtender>
                    </td>
                    <td><b style="margin-left: 30px;">Status</b></td>
                    <td>
                        <select id="ddlType" class="texboxcls" style="width: 120px;">
                            <option value="OnGoing">OnGoing</option>
                            <option value="Completed">Completed</option>
                            <option value="All">All</option>
                        </select>
                    </td>
                    <td><b style="margin-left: 30px;">Type</b></td>
                    <td>
                        <select id="ddlBill" class="texboxcls" style="width: 120px;">
                            <option value="All">All</option>
                            <option value="1">Billable</option>
                            <option value="0">Non Billable</option>
                        </select>
                    </td>
                    <td><b style="margin-left: 30px;">Report Type :</b></td>
                    <td>
                        <%--   <input type="radio" id="rsummary" name="rb" value="Summary"/>Summary &nbsp
                      <input type="radio" id="rdetailed" name="rb" value="Detailed"/>Detailed    --%>
                        <asp:RadioButton runat="server" ID="rsummary" Text="Summary" Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                        <asp:RadioButton runat="server" ID="rdetailed" Text="Detailed" GroupName="rbtn" />&nbsp;
                    </td>
                </tr>
            </table>
        </div>
        <div>
            <table style="margin-left: 10px; margin-top: 30px;">
                <tr>
                    <td style="width: 380px;">
                        <asp:CheckBox ID="chkProject" runat="server" ForeColor="Black"
                            Font-Bold="true" Height="20px" Text="Project (0)" CssClass="labelChange" />
                        <div id="Panel1" style="border: 1px solid #B6D1FB; height: 450px; overflow: auto; border-radius: 5px;">
                        </div>
                    </td>
                    <td style="width: 40px;"></td>
                    <td style="width: 380px;">
                        <asp:CheckBox ID="chkDepartment" runat="server" ForeColor="Black"
                            Font-Bold="true" Height="20px" Text="Department (0)" CssClass="labelChange" />
                        <div id="Panel2" style="border: 1px solid #B6D1FB; height: 450px; overflow: auto; border-radius: 5px;">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <%-- <table style="margin-left: 10px; margin-top: 10px;">
                    <tr>
                       
                    </tr>
                </table>
                <table style="margin-left: 10px; margin-top: 10px;">
                    <tr>
                         
                    </tr>
                </table>--%>

        <%--<div style="float: right; width: 70%;">
                <table style="margin-top: 10px; margin-left: 10px;">
                    <tr>
                        <td style="width: 380px;">
                            <asp:CheckBox ID="chkProject" runat="server" ForeColor="Black"
                                Font-Bold="true" Height="20px" Text="Project (0)" CssClass="labelChange" />
                            <div id="Panel1" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto; border-radius: 5px;">
                            </div>
                        </td>
                        <td style="width: 380px;">
                            <asp:CheckBox ID="chkDepartment" runat="server" ForeColor="Black"
                                Font-Bold="true" Height="20px" Text="Department (0)" CssClass="labelChange" />
                            <div id="Panel2" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto; border-radius: 5px;">
                            </div>
                        </td>
                    </tr>

                </table>
            </div>--%>
    </div>
</div>
</div>
