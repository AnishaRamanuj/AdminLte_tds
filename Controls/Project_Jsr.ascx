<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Project_Jsr.ascx.cs" Inherits="controls_Project_Jsr" %>
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

<script type="text/javascript">
    $(document).ready(function () {
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

        ////check all Project
        $("[id*=chkProject]").on("click", function () {

            if ($(".clProject").length == 0) {
                return false;
            }
            var check = $(this).is(':checked');
            $(".clProject").each(function () {
                if (check) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked');
                }

            });
            GetAllSelected();
        });

        $("[id*=drpStatus]").on('change', function () {
            pageFiltersReset();
        });

    });

    //////check single Project
    function singleProjectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length) {
            $("[id*=chkProject]").attr('checked', true);
        }
        else {
            $("[id*=chkProject]").removeAttr('checked');
        }
        GetAllSelected();
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

    function GetPrpject_Staff() {
        GetAllSelected();
        //var compid = $("[id*=hdnCompanyID]").val();
        var Status = $("[id*=drpStatus]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/JobAllocationHours.asmx/GetProjreport",
            data: '{Status:"' + Status + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: OnSuccess,
            failure: function (response) {

            },
            error: function (response) {

            }
        });
    }

    function OnSuccess(response) {
        var obj = jQuery.parseJSON(response.d);
        console.log(obj);
        var tableRowsProj = '', tableRowsclt = '';
        var countProj = 0, countClt = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "Project") {
                countProj += 1;
                tableRowsProj += "<tr><td><input type='checkbox' onclick='singleProjectcheck()' class='cl" + vl.Type + "' value='" + vl.Id + "' /></td><td>" + vl.Name + "</td></tr>";
            }

        });

        //$("[id*=chkProject]").removeAttr('checked');
        $("[id*=chkProject]").parent().find('label').text("Check All Project Name (Count : " + countProj + ")");
        $("[id*=Panel1]").html("<table>" + tableRowsProj + "</table>");

        GetAllSelected();
    }

    function GetAllSelected() {
        var selectProject = '';
        $(".clProject:checked").each(function () {
            selectProject += $(this).val() + ',';
        });

        $("[id*=hdnselectedProject]").val(selectProject);

    }

    function pageFiltersReset() {
        needproject = true, needclient = false;
        $("[id*=chkProject]").removeAttr('checked');
        $("[id*=chkProject]").parent().find('label').text("Check All Project Name (Count : 0)");

        $("[id*=Panel1]").html('');
        GetPrpject_Staff();
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

    .Pager b {
        margin-top: 2px;
        float: left;
    }

    .Pager span {
        text-align: center;
        display: inline-block;
        width: 20px;
        margin-right: 3px;
        line-height: 150%;
        border: 1px solid #BCBCBC;
    }

    .Pager a {
        text-align: center;
        display: inline-block;
        width: 20px;
        background-color: #BCBCBC;
        color: #fff;
        border: 1px solid #BCBCBC;
        margin-right: 3px;
        line-height: 150%;
        text-decoration: none;
    }
</style>


<div class="page-content">
    <asp:HiddenField ID="hdnCompanyID" runat="server" />
    <asp:HiddenField ID="hdnselectedProject" runat="server" />
    <asp:HiddenField ID="hdnselectedStaff" runat="server" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved" />
    <asp:HiddenField ID="hdnPages" runat="server" />

    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>				
						
</div>
   

            <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-left: 1rem;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Project JSR Report</span></h5>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

                <asp:Button ID="btngen" runat="server" OnClick="btngen_Click" CssClass="btn bg-success legitRipple"
                    Text="Generate Report" />



            </div>

    

        <div class="content">
            <div class="divstyle card">
                <div id="" class="totbodycatreg" style="height: 700px;">
                    <div style="width: 100%;">
                        <uc1:MessageControl ID="MessageControl1" runat="server" />
                    </div>
                    <div class="card-body">
                        <table width="1100px;" style="padding-left: 60px;">
                            <tr>
                                <td>
                                    <asp:Label ID="lblDate" Font-Bold="true" runat="server">Project Status</asp:Label>
                                </td>

                                <td>
                                    <select id="drpStatus" name="drpStatus" runat="server" class="DropDown" style="width: 100; height: 25px; z-index: -1;">
                                        <option value="OnGoing">OnGoing</option>
                                        <option value="Completed">Completed</option>
                                    </select>
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
                                             <td>
                                    <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Report Type" Font-Bold="True"></asp:Label>
                                </td>
                                <td valign="middle" align="center">:
                                </td>
                                <td valign="middle">
                                    <asp:RadioButton runat="server" ID="rsummary" Text="Billable" Checked="true" GroupName="rbtn" />&nbsp;&nbsp;
                                            <asp:RadioButton runat="server" ID="rdetailed" Text="Non-Billable" GroupName="rbtn" />&nbsp;
                                </td>
                            </tr>

                        </table>
                        <table style="padding-left: 55px; padding-top: 15px;">
                            <tr style="padding-top: 20px">
                                <td style="width: 550px;">
                                    <asp:CheckBox ID="chkProject" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                        Text="Project (0)" CssClass="labelChange" />
                                    <%--<label style="display: inline-block; color: Black; font-weight: bold; height: 20px;">Hours</label>--%>
                                    <div id="Panel1" style="border: 1px solid #B6D1FB; width: 85%; height: 450px; overflow: auto;">
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
   

