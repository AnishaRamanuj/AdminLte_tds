<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Staffwise_Report.ascx.cs" Inherits="controls_Staffwise_Report" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>

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
<script src="../jquery/Selectize/selectize.js" type="text/javascript"></script>
<script src="../jquery/Selectize/es5.js" type="text/javascript"></script>
<script src="../jquery/Selectize/index.js" type="text/javascript"></script>
<link href="../jquery/Selectize/normalize.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">

    $(document).ready(function () {
        //  $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        $('.sidebar-main-toggle').click();
        var a = new Date();
        var dt = moment(a).format('YYYY-MM')
        $("[id*=dtmonth]").val(dt);
        $("[id*=hdnmonth]").val(dt);

        GetStaffName();

        $("[id*=dtmonth]").on("change", function () {
            GetStaffName();
        });

        $("[id*=drpstaff]").on("change", function () {
            var Staffname = $("[id*=drpstaff]").text();
            $("[id*=hdnStaffName]").val(Staffname);

            var Staffcode = $("[id*=drpstaff]").val();
            $("[id*=hdnStaffcode]").val(Staffcode);
            GetProjectstf();
        });

        ////check all Project
        $("[id*=chkProject]").on("click", function () {
            if ($(".clProject").length == 0)
            { return false; }
            var check = $(this).is(':checked');
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


    function GetProjectstf() {
        GetAllSelected();
        if ($("[id*=dtmonth]").val() == "" || $("[id*=dtmonth]").val() == undefined || $("[id*=drpclient]").val() == "")
        { return false; }
        $('.loader').show();
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                StaffCode: $("[id*=drpstaff]").val(),
                Monthdate: $("[id*=dtmonth]").val(),
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Report_Staff_ProjectwiseHours.asmx/Get_StaffProject",
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

    function GetStaffName() {
        if ($("[id*=dtmonth]").val() == "" || $("[id*=dtmonth]").val() == undefined || $("[id*=drpclient]").val() == "")
        { return false; }
        $('.loader').show();
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                Monthdate: $("[id*=dtmonth]").val(),
            }
        };
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Report_Staff_ProjectwiseHours.asmx/Get_StaffName",
            data: JSON.stringify(data),
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList == null) {
                } else {
                    if (myList.length == 0) { }
                    else {
                        $("[id*=drpstaff]").selectize()[0].selectize.destroy();
                        $("[id*=drpstaff]").empty();
                        $("[id*=drpstaff]").append("<option value=" + 0 + ">Select</option>");
                        for (var i = 0; i < myList.length; i++) {
                            $("[id*=drpstaff]").append("<option value=" + myList[i].StaffCode + ">" + myList[i].StaffName + "</option>");
                        }
                        $("[id*=drpstaff]").selectize();
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





<div class="page-content">

    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnStaffName" />
    <asp:HiddenField runat="server" ID="hdnSelectedProject" />
    <asp:HiddenField runat="server" ID="hdnStaffcode" />
    <asp:HiddenField runat="server" ID="hdnmonth" />
   <div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>				
						
</div>


            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Staffwise Report</span></h5>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

                <asp:Button ID="btngenexp" runat="server" OnClick="btngenexp_Click" CssClass="btn bg-success legitRipple"
                    Text="Generate Report" />



            </div>

        </div>
        <div class="content">
            <div class="divstyle card">
                <div id="" class="totbodycatreg" style="height: 700px;">
                    <div style="width: 100%;">
                    <uc2:MessageControl ID="MessageControl1" runat="server" />
                    </div>
                   <div class="card-body">
                <div style="float: left; width: 40%;padding-top: 15px;">
                    <table>
                        <tr>
                            <td style="width: 10px;"></td>
                            <td style="font-weight: bold;" cssclass="LabelFontStyle labelChange">
                                Staff</td>
                            <td>:</td>
                            <td>
                                <asp:DropDownList ID="drpstaff" runat="server" CssClass="DropDown" Width="335px" Height="30px">
                                </asp:DropDownList>

                            </td>
                        </tr>
                    </table>
                    <table>
                        <tr>
                            <td style="height: 50px;"></td>
                            <td style="font-weight: bold;">&nbsp;&nbsp; Month
                            </td>
                            <td>:</td>
                            <td>
                                    <input type="month" style="width: 125px;" class="form-control" id="dtmonth" name="dtmonth" />
                            </td>

                        </tr>
                    </table>
                </div>
                <div style="float: right; width: 60%;padding-top: 15px;">
                    <table>
                        <tr>
                            <td style="width: 380px; padding-left: 50px;">
                                <asp:CheckBox ID="chkProject" runat="server" ForeColor="Black"
                                    Font-Bold="true" Height="20px" Text="Project (0)" CssClass="labelChange" />
                                <div id="Panel1" style="border: 1px solid #B6D1FB; width: 110%; height: 450px; overflow: auto;">
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
    





