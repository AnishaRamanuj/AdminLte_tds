<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Weekwise_Report.ascx.cs" Inherits="controls_Weekwise_Report" %>
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
    $(document).ready(function () {
        $('.sidebar-main-toggle').click();
        var a = new Date();
        var dt = moment(a).format('YYYY-MM')
        $("[id*=txtmonth]").val(dt);
        $("[id*=hdnmonth]").val(dt);



        pageFiltersReset();

        $("[id*=txtmonth]").on("change", function () {
            $("[id*= hdnmonth]").val($("[id*= txtmonth]").val());
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


    });

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
        $("[id*=chkstaff]").parent().find('label').text("Select Staff(Count : 0)");
        $("[id*=Panel1]").html('');
        BindPageLoadStaff();
    }
</script>

<style type="text/css">
    #content {
        overflow: hidden !important;
    }

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


<asp:HiddenField runat="server" ID="hdnCompid" />
<asp:HiddenField runat="server" ID="hdnSelectedStaffCode" />
<asp:HiddenField runat="server" ID="hdnmonth" />
<div class="page-content">
   <div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>
          
</div>
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-left: 1rem;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">
                    <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold">Resource Weekwise</span></h5>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>


                <asp:Button ID="btngenexp" runat="server" OnClick="btngenexp_Click" CssClass="btn btn-outline-success legitRipple"
                    Text="Export To XL" />


            </div>
        </div>

        <!-- /page header -->

        <div class="content">

            <!-- Hover rows -->


            <div id="dvGrid" class="card">
                <div style="width: 100%;">
                    <uc1:MessageControl ID="MessageControl1" runat="server" />
                </div>
                <div class="row_report" runat="server" id="divReportInput">
                    <div style="overflow: hidden; width: 100%; margin-top: 10px;">
                        <div style="float: left; width: 20%;">
                            <table>
                                <tr>
                                    <td>&nbsp;&nbsp; <b>Month</b>
                                    </td>
                                    <td>
                                        <input type="month" style="width: 150px;" class="form-control form-control-border" id="txtmonth" name="txtmonth" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div style="float: right; width: 80%;">
                            <table>
                                <tr>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkstaff" runat="server" ForeColor="Black"
                                            Font-Bold="true" Height="20px" Text="Staff (0)" CssClass="labelChange" />
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

        </div>
        <!-- /main content -->

    </div>





<%--<div class="divstyle">
    <div class="headerpage">
        <div>
            <table class="cssPageTitle" style="width: 100%;">
                <tr>
                    <td class="cssPageTitle2">
                        <asp:Label ID="lblname" runat="server" Text="Resource Weekwise" Style="margin-left: 0px;"></asp:Label>
                    </td>
                    <td style="float: right; padding-top: 5px; margin-left: 60px;">
                        <asp:Button ID="btngenexp" runat="server" OnClick="btngenexp_Click" CssClass="cssButton"
                            Text="Generate Report" />
                    </td>
                </tr>
            </table>

         

        </div>
    </div>

    <div id="div2" class="totbodycatreg" style="height: 500px;">


    </div>
</div>--%>
