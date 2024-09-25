<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OngoinProjectList.ascx.cs" Inherits="controls_OngoinProjectList" %>
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
        /// $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        $('.sidebar-main-toggle').click();

        $("[id*= txtfrom]").val($("[id*= hdnFrom]").val());
        $("[id*= txtto]").val($("[id*= hdnTo]").val());

        BindPageLoadData();
        pageFiltersReset();

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

        $('#ddlType').on('change', function () {
            BindPageLoadData();
            var t = $("[id*=ddlType]").val();
            $("[id*=hdnStype]").val(t);
        });

        $("[id*=txtfrom]").on("change", function () {
            $("[id*= hdnFrom]").val($("[id*= txtfrom]").val());
            BindPageLoadData();

        });

        $("[id*=txtto]").on("change", function () {
            $("[id*= hdnTo]").val($("[id*= txtto]").val());
            BindPageLoadData();
        });
    });

    //bind data
    function BindPageLoadData() {
        $('.loader').show();
        var data = {
            currobj: {
                compid: $("[id*=hdnCompid]").val(),
                Fdate: $("[id*=txtfrom]").val(),
                todate: $("[id*=txtto]").val(),
                stype: $("[id*=ddlType]").val()
            }
        };        //Ajax start

        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/WS_OngoingPrjList.asmx/Get_Project_List",
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
        //if (obj == 0) {
        //    alert("No Record Found");
        //}
        console.log(obj);
        var tableRowsProject = '';
        var countproject = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "Project") {
                countproject += 1;
                tableRowsProject += "<tr><td><input type='checkbox' onclick='singleprojectcheck()' class='cl" + vl.Type + "' value='" + vl.id + "' /></td><td>" + vl.PNAME + "</td></tr>";
            }
        });
        $("[id*=chkProject]").removeAttr('checked');
        $("[id*=chkProject]").parent().find('label').text("Project (" + countproject + ")");
        $("[id*=Panel1]").html("<table>" + tableRowsProject + "</table>");

        $(".modalganesh").hide();
        GetAllSelected();
    }

    function singleprojectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length)
        { $("[id*=chkProject]").attr('checked', true); }
        else { $("[id*=chkProject]").removeAttr('checked'); }
        GetAllSelected();
    }

    function pageFiltersReset() {
        $("[id*=chkProject]").removeAttr('checked');
        $("[id*=chkProject]").parent().find('label').text("Project (0)");
        $("[id*=Panel1]").html('');
        BindPageLoadData();
    }

    function GetAllSelected() {
        var selectProject = '';
        $(".clProject:checked").each(function () {
            selectProject += $(this).val() + ',';
        });
        $("[id*=hdnSelectedProjectid]").val(selectProject);
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
    <asp:HiddenField ID="hdnSelectedProjectid" runat="server" />
    <asp:HiddenField ID="hdnStype" runat="server" />
    <asp:HiddenField ID="hdnval" runat="server" />
      <asp:HiddenField runat="server" ID="hdnFrom" />
        <asp:HiddenField runat="server" ID="hdnTo" />

   <div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>				
						
</div>

            <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-left: 1rem;">
               <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">Ongoing Project List</span></h5>
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
                        <table style="padding-top: 10px;">
                <tr>
                    <td>
                        <asp:Label ID="Label11" runat="server" ForeColor="Black" Style="margin-left: 60px;" Text="From" Font-Bold="True"></asp:Label>
                    </td>
                    <td align="center" valign="middle">:
                    </td>
                    <td>
                         <input type="date" id="txtfrom" name="txtfrom" class="form-control form-control-border" />
                    </td>
                    <td style="width: 20px;"></td>
                    <td>
                        <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To" Font-Bold="True"></asp:Label>
                    </td>
                    <td align="center" valign="middle">:
                    </td>
                    <td>
                          <input type="date" id="txtto" name="txtto" class="form-control form-control-border" />
                    </td>
                    <td style="width: 50px;"></td>
                    <td><b>Status</b></td>
                    <td>
                        <select id="ddlType" class="texboxcls" style="width: 120px;">
                            <%--<option selected value="">Select</option>--%>
                            <option value="OnGoing">OnGoing</option>
                            <option value="Completed">Completed</option>
                            <option value="All">All</option>
                        </select>
                    </td>
                </tr>

            </table>
            <table class="style1" style="float: left; padding-left: 50px; padding-top: 5px;">
                <tr>
                    <td>
                        <table align="center">
                            <tr>
                                <td style="width: 380px;">
                                    <asp:CheckBox ID="chkProject" runat="server" ForeColor="Black"
                                        Font-Bold="true" Height="20px" Text="Project (0)" CssClass="labelChange" />

                                    <div id="Panel1" style="border: 1px solid #B6D1FB; width: 500px; height: 450px; overflow: auto; margin-top: 8px;">
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
   

