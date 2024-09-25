<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Team_strengthnHours.ascx.cs" Inherits="controls_Team_strengthnHours" %>
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

        GetProjectName();

        $("[id*=dtmonth]").on("change", function () {
            $("[id*=hdnmonth]").val($("[id*=dtmonth]").val());
        
        });

        $("[id*=drpproject]").on("change", function () {
            var jobid = $("[id*=drpproject]").val();
            $("[id*=hdnJobid]").val(jobid);
            var Projectname = $("[id*=drpproject]").text();
            $("[id*=hdnProjectName]").val(Projectname);

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
            url: "../Handler/Report_Staff_ProjectwiseHours.asmx/Get_ProjectName",
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
                        $("[id*=drpproject]").selectize();
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
</style>



<div class="page-content">
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnJobid" />
    <asp:HiddenField runat="server" ID="hdnProjectName" />
    <asp:HiddenField runat="server" ID="hdnmonth" />
    <div class="content-wrapper">
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: 10px; padding-bottom: 10px;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h4><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Projectwise Report</span></h4>
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
                    <div class="row_report " runat="server" id="div1">
                        <div class="card-body">
                            <table class="style1" width="100%">
                                <tr>
                                    <td style="height: 5px; padding-top: 20px;"></td>
                                </tr>
                                <tr>
                                    <td style="width: 50px;"></td>
                                    <td style="font-weight: bold;" cssclass="LabelFontStyle labelChange">Select Project</td>
                                    <td>:</td>
                                    <td>
                                        <asp:DropDownList ID="drpproject" runat="server" CssClass="DropDown" Width="335px" Height="30px">
                                        </asp:DropDownList>

                                    </td>
                                    <td style="font-weight: bold;">&nbsp;&nbsp; Month
                                    </td>
                                    <td>:</td>
                                    <td>
                                     <input type="month" style="width: 125px;" class="form-control" id="dtmonth" name="dtmonth" />
                                    </td>

                                    <td></td>
                                </tr>
                                <tr>
                                    <td style="height: 5px;"></td>
                                </tr>
                            </table>
                        </div>
                    </div>


                </div>
            </div>
        </div>
    </div>


</div>




