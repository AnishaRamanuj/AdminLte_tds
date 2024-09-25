<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ApproverList.ascx.cs" Inherits="controls_ApproverList" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
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

<script lang="javascript" type="text/javascript">
    $(document).ready(function () {
        // $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        BindPageLoadData();
        pageFiltersReset();

        $("[id*=chkApprover]").on("click", function () {
            if ($(".clApprover").length == 0)
            { return false; }
            var check = $(this).is(':checked');
            $(".clApprover").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else {
                    $(this).removeAttr('checked');
                }
            });
            GetAllSelected();
        });
    });

    //bind data
    function BindPageLoadData() {
        //GetAllSelected();     
        $('.loader').show();
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val()
                //staffcode: $("[id*=hdnstaffcode]").val(),
                //selectedApprid: $("[id*=hdnselectedStaffcode]").val()              
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/WS_ApproverList.asmx/Get_Approver_List",
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
            if (vl.Type == "Approver") {
                countstafff += 1;
                tableRowsstaff += "<tr><td><input type='checkbox' onclick='singlestaffcheck()' class='cl" + vl.Type + "' value='" + vl.id + "' /></td><td>" + vl.PNAME + "</td></tr>";
            }
        });
        $("[id*=chkApprover]").removeAttr('checked');
        $("[id*=chkApprover]").parent().find('label').text("Approver (" + countstafff + ")");
        $("[id*=Panel1]").html("<table>" + tableRowsstaff + "</table>");

        $(".modalganesh").hide();
        GetAllSelected();
    }

    function singlestaffcheck() {
        if ($(".clApprover").length == $(".clApprover:checked").length)
        { $("[id*=chkApprover]").attr('checked', true); }
        else { $("[id*=chkApprover]").removeAttr('checked'); }
        GetAllSelected();
    }

    function pageFiltersReset() {
        $("[id*=chkApprover]").removeAttr('checked');
        $("[id*=chkApprover]").parent().find('label').text("Approver (0)");
        $("[id*=Panel1]").html('');
        BindPageLoadData();
    }

    function GetAllSelected() {
        var selectApprover = '';
        $(".clApprover:checked").each(function () {
            selectApprover += $(this).val() + ',';
        });
        $("[id*=hdnselectedStaffcode]").val(selectApprover);
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
    <asp:HiddenField ID="hdnCompid" runat="server" />
    <asp:HiddenField ID="hdnstaffcode" runat="server" />
    <asp:HiddenField ID="hdnselectedStaffcode" runat="server" />
    <asp:HiddenField ID="hdnSelectedProjectid" runat="server" />

    <div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>				
						
</div>

            <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-left: 1rem;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Approver Staff Report</span></h5>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

                <asp:Button ID="btngen" runat="server" OnClick="btngen_Click" CssClass="btn bg-success legitRipple"
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
                        <table class="style1" style="float: left; padding-left: 50px; padding-top: 5px;">
                            <tr>
                                <td>
                                    <table align="center">
                                        <tr>
                                            <td style="width: 380px;">
                                                <asp:CheckBox ID="chkApprover" runat="server" ForeColor="Black"
                                                    Font-Bold="true" Height="20px" Text="Approver (0)" CssClass="labelChange" />

                                                <div id="Panel1" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto; margin-top: 8px;">
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>


</div>



