<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Report_Dept_Desg_Summary.ascx.cs"
    Inherits="controls_report_dept_desg_summary" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>


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
    var needdesg = false, needdept = true;
    $(document).ready(function () {
        $('.sidebar-main-toggle').click();
        $("[id*= txtfrom]").val($("[id*= hdnFrom]").val());
        $("[id*= txtto]").val($("[id*= hdnTo]").val());
        //////////////////////////////////////////////////before report filter
        pageFiltersReset();

        ////tStatus chkall
        $("[id*=chkTStatusAll]").on("click", function () {
            if ($(this).is(':checked') == true) {
                $("[id*=chkSubmitted]").attr('checked', 'checked');
                $("[id*=chkSaved]").attr('checked', 'checked');
                $("[id*=chkApproved]").attr('checked', 'checked');
                $("[id*=chkRejected]").attr('checked', 'checked');
            }
            else {
                $("[id*=chkSubmitted]").removeAttr('checked');
                $("[id*=chkSaved]").removeAttr('checked');
                $("[id*=chkApproved]").removeAttr('checked');
                $("[id*=chkRejected]").removeAttr('checked');
            }
            TStatusCheck();
        });

        ///////staff binding on date and timesheetstatus change
     

        $("[id*= txtfrom]").on('change', function () {
            $("[id*= hdnFrom]").val($("[id*= txtfrom]").val());
            pageFiltersReset();
        });

        $("[id*= txtto]").on('change', function () {
            $("[id*= hdnTo]").val($("[id*= txtto]").val());
            pageFiltersReset();
        });


        $("[id*=ddlStatus]").on("change", function () { pageFiltersReset(); });

        $("[id*=btngen]").on("click", function () {

            ////// Checking 4 dept
            var did = '';
            $("input[name=chkd]").each(function () {
                var chkprop = $(this).is(':checked');
                if (chkprop) {
                    did += $(this).val() + ',';
                }
            });
            $("[id*=hdnselecteddeptid]").val(did);

            ////// Checking 4 dsg
            var dsg = '';
            $("input[name=chkdsg]").each(function () {
                var chkprop = $(this).is(':checked');
                if (chkprop) {
                    dsg += $(this).val() + ',';
                }
            });
            $("[id*=hdnSelecteddesgid]").val(dsg);

        });

        ////check all desg
        $("[id*=chkdesg]").on("click", function () {
            var check = $(this).is(':checked');
            if ($(".cldesg").length == 0)
            { return false; }
            $(".cldesg").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });

        });

        ///////check all department
        $("[id*=chkdeptAll]").on("click", function () {
            if ($(".cldept").length == 0)
            { return false; }
            var check = $(this).is(':checked');
            $(".cldept").each(function () {
                if (check)
                { $(this).attr('checked', 'checked'); }
                else { $(this).removeAttr('checked'); }
            });
            needdesg = true, needdept = false;
            BindPageLoaddesg();
        });




    });
    function pad2(number) {
        return (number < 10 ? '0' : '') + number
    }


    function BindPageLoaddesg() {
        GetAllSelected();
        Blockloadershow();
        if (needdept)
        {
            $("[id*=hdnselecteddeptid]").val('Empty'); $("[id*=hdnSelecteddesgid]").val('');
        }
        if ($("[id*=txtfrom]").val() == "" || $("[id*=txtfrom]").val() == undefined)
        {
            Blockloaderhide();
            return false;
        }
       
        var data = {
            currobj: {
                //compid: $("[id*=hdnCompid]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                selecteddeptid: $("[id*=hdnselecteddeptid]").val(),
                FromDate: $("[id*=txtfrom]").val(),
                ToDate: $("[id*=txtto]").val()
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/wsStaff.asmx/Bind_dept_desg_All_Selected",
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
        var selecteddeptid;
        selecteddeptid = $("[id*=hdnselecteddeptid]").val();
        var obj = jQuery.parseJSON(response.d);
        console.log(obj);
        var tableRowsdesg = '', tableRowsdept = '';
        var countdesg = 0, countdept = 0;
        $.each(obj, function (i, vl) {
            if (selecteddeptid != "Empty") {
                countdesg += 1;
                tableRowsdesg += "<tr><td><input  id='chkdsg' name='chkdsg' type='checkbox' checked='checked' onclick='singledesgcheck()' class='cldesg' value='" + vl.desgid + "' /></td><td>" + vl.designation + "</td></tr>";
            }
            else if (selecteddeptid == "Empty") {
                countdept += 1;
                tableRowsdept += "<tr><td><input id='chkd' name='chkd' type='checkbox'  onclick='singledeptcheck()' class='cldept' value='" + vl.desgid + "' /></td><td>" + vl.designation + "</td></tr>";
            }

        });

        if (needdept) {
            $("[id*=chkdept]").removeAttr('checked');
            $("[id*=chkdept]").parent().find('label').text("Check All Department Name (Count : " + countdept + ")");
            $("[id*=Panel2]").html("<table>" + tableRowsdept + "</table>");
        }

        if (needdesg) {
            if (countdesg != 0)
                $("[id*=chkdesg]").attr('checked', 'checked');
            else
                $("[id*=chkdesg]").removeAttr('checked');


            $("[id*=chkdesg]").parent().find('label').text("Check All Designation Name (Count : " + countdesg + ")");
            $("[id*=Panel3]").html("<table>" + tableRowsdesg + "</table>");
        }


        Blockloaderhide();

    }
    function GetAllSelected() {
        var did = '';
        $("input[name=chkd]").each(function () {
            var chkprop = $(this).is(':checked');
            if (chkprop) {
                did += $(this).val() + ',';
            }

        });
        $("[id*=hdnselecteddeptid]").val(did);
    }



    ////check single desg
    function singledesgcheck() {
        if ($(".cldesg").length == $(".cldesg:checked").length)
        { $("[id*=chkdesg]").attr('checked', true); }
        else { $("[id*=chkdesg]").removeAttr('checked'); }
    }
    //////check single dept
    function singledeptcheck() {
        if ($(".cldept").length == $(".cldept:checked").length)
        { $("[id*=chkdept]").attr('checked', true); }
        else { $("[id*=chkdept]").removeAttr('checked'); }
        needdesg = true, needdept = false;
        BindPageLoaddesg();
    }

    function TStatusCheck() {
     
        var selectedTStatus = '';
        var count = 0;

        var sbu = $("[id*=chkSubmitted]");
        if (sbu.is(':checked') == true)
        {
            count += 1; selectedTStatus += "Submitted,";
        }

        sbu = $("[id*=chkSaved]");
        if (sbu.is(':checked') == true)
        { count += 1; selectedTStatus += "Saved,"; }

        sbu = $("[id*=chkApproved]");
        if (sbu.is(':checked') == true)
        { count += 1; selectedTStatus += "Approved,"; }


        sbu = $("[id*=chkRejected]");
        if (sbu.is(':checked') == true)
        { count += 1; selectedTStatus += "Rejected,"; }

        if (count == 4)
        { $("[id*=chkTStatusAll]").attr('checked', 'checked'); }
        else { $("[id*=chkTStatusAll]").removeAttr('checked'); }

        if (selectedTStatus == '') {
            $("[id*=chkApproved]").attr('checked', 'checked');
            selectedTStatus = 'Approved';
        }
        $("[id*=hdnTStatusCheck]").val(selectedTStatus);
        pageFiltersReset();
    }




    function pageFiltersReset() {
        needdesg = false, needdept = true;
        $("[id*=chkdesg]").removeAttr('checked');
        $("[id*=chkdesg]").parent().find('label').text("Check All Designation Name (Count : 0)");
        $("[id*=chkclient]").removeAttr('checked');
        $("[id*=chkclient]").parent().find('label').text("Check All  Department Name (Count : 0)");



        $("[id*=Panel2]").html('');
        $("[id*=Panel3]").html('');
        BindPageLoaddesg();
    }
</script>


<div class="page-content">
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnUserType" />
    <asp:HiddenField runat="server" ID="hdnSelecteddesgid" Value="Empty" />
    <asp:HiddenField runat="server" ID="hdnselecteddeptid" Value="Empty" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
        <asp:HiddenField runat="server" ID="hdnFrom" />
    <asp:HiddenField runat="server" ID="hdnTo" />
   <div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>				
						
</div>

            <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-bottom: 1rem;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold">All Department All Designation</span></h5>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>
               
              <asp:Button  ID="btngen" runat="server" CssClass="btn bg-success legitRipple"
                                    Text="Generate Report" OnClick="btngen_Click" />

                <asp:Button ID="btnBack" runat="server" CssClass="btn btn-primary legitRipple legitRipple-empty" Text="Back"
                    Visible="false" OnClick="btnBack_Click" />

            </div>
        </div>

        <div class="content">
            <div style="width: 100%;">
                <uc1:MessageControl ID="MessageControl1" runat="server" />
            </div>
            <div class="row_report card" runat="server" >
                <div class="card-body" runat="server" id="divReportInput">
                    <table style="padding-left: 55px; padding-top: 15px; width: 910px;">
                        <tr>
                            <td>
                                <b>From :</b>
                            </td>
                            <td>
                              <input type="date" id="txtfrom" name="txtfrom" class="form-control" />
                            </td>
                            <td style="padding: 0 0 0 20px">
                                <b>To :</b>
                            </td>
                            <td style="padding-right: 20px">
                                   <input type="date" id="txtto" name="txtto" class="form-control" />
                            </td>
                            <td>
                                <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status :"
                                    Font-Bold="True"></asp:Label>
                            </td>
                            <td>
                                <asp:CheckBox ID="chkTStatusAll" ClientIDMode="Static" runat="server" Checked="true"
                                    Text="All" />&nbsp;&nbsp;
                        <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server" Checked="true"
                            onclick="TStatusCheck()" Text="Submitted" />&nbsp;&nbsp;
                        <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static" Checked="true" onclick="TStatusCheck()"
                            Text="Saved" />&nbsp;&nbsp;
                        <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()" Checked="true"
                            ClientIDMode="Static" Text="Approved" />&nbsp;&nbsp;
                        <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()" Checked="true"
                            ClientIDMode="Static" Text="Rejected" />
                            </td>
                           
                        </tr>
                    </table>
                    <table style="padding-left: 55px;">
                        <tr style="padding-top: 20px">
                            <td style="width: 450px;">
                                <asp:CheckBox ID="chkdeptAll" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                    Text=" Check All Department Name (Count : 0)" CssClass="labelChange" />
                                <div id="Panel2" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                </div>
                            </td>
                            <td style="width: 450px;">
                                <asp:CheckBox ID="chkdesg" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                    Text=" Check All Designation Name (Count : 0)" CssClass="labelChange" />
                                <div id="Panel3" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <rsweb:ReportViewer ID="ReportViewer1" Height="670px" Width="795px"
                    Visible="false" runat="server" AsyncRendering="False" InteractivityPostBackMode="AlwaysAsynchronous">
                </rsweb:ReportViewer>
            </div>
           <%-- <div class="row_report" runat="server" id="divReportInput">
            </div>--%>
        </div>
  



    <%--<div class="divstyle">
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="Label1" runat="server" CssClass="Head1 labelChange" Text="All Department All Designation"></asp:Label>

            <div style="float: right;">
                
            </div>
        </div>
    </div>
    <div id="div2" class="totbodycatreg" style="height: 590px;">
        <div style="width: 100%;">
          
        </div>

</div>--%>
