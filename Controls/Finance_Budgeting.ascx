<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Finance_Budgeting.ascx.cs"
    Inherits="controls_Finance_Budgeting" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../StyleCss/Divstyle.css" rel="stylesheet" type="text/css" />
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        $("[id*=BtnAllocateBuffHrs]").hide();
        ///////////get clients name dropdown
        Get_Finance_Budegeting_clientName();
        $("[id*=fldBudgetDtls]").hide();
        //////get project on selected client
        $("#ddlclient").on('change', function () {
            ClearAll();
            Get_Finance_Budegeting_ProjectName();

        });

        /////////update end dates

        $("[id*=btnUpdateNewDate]").live('click', function () {
            if ($("#ddlclient").val() == "0") {
                alert("Please Select Client Name ");
                return false;
            }
            if ($("#ddlProject").val() == "0") {
                alert("Please Select Project Name ");
                return false;
            }
            var date = new Date();

            var Month = date.getMonth();
            Month = Month + 1;
            if (Month < 10) { Month = "0" + Month; }
            var Day = date.getDate();
            if (Day < 10) { Day = "0" + Day; }
            var Year = date.getFullYear();
            $("#txtEndDate").val(Year + "-" + Month + "-" + Day);
            $find("ListModalPopupBehaviorId").show();
        });

        //////////update buffer

        $("[id*=BtnAllocateBuffHrs]").live('click', function () {
            if ($("#ddlclient").val() == "0") {
                alert("Please Select Client Name ");
                return false;
            }
            if ($("#ddlProject").val() == "0") {
                alert("Please Select Project Name ");
                return false;
            }
            if (parseFloat($("#txtProjectAmt").val()) == 0) {
                alert("Please Add and Save Project Amount");
                return false;
            }
            if (parseFloat($("#txtProjectHrs").val()) == 0) {
                alert("Please Add and Save Project Hours");
                return false;
            }
            var OldDate = ''
            $("#tblBudgetDetails > tbody  > tr").each(function () {
                var row = $(this).closest('tr');

                if (row.find("td").eq(2).html() == '') {

                    OldDate = row.find("td").eq(1).html().split('/');
                }
            });
            if (OldDate == '') {
                var date = new Date();

                var Month = date.getMonth();
                Month = Month + 1;
                if (Month < 10) { Month = "0" + Month; }
                var Day = date.getDate();
                if (Day < 10) { Day = "0" + Day; }
                var Year = date.getFullYear();
                $("#txtStartdate").val(Year + "-" + Month + "-" + Day);
            }
            else {
                var newdate = new Date(OldDate[1] + "/" + OldDate[0] + "/" + OldDate[2]);
                var mindate = new Date();
                mindate.setDate(newdate.getDate() + 1);
                /// OldDate[0] = parseInt(OldDate[0]) + 1;

                mindate = mindate.toISOString().slice(0, 10);
                $('#txtStartdate').attr('min', mindate);
            }
            $("#txtStartdate").prop('readonly', '');
            $("[id*=hdnBudgetId]").val('0');
            $("[id*=hdnHrs]").val('0');
            $("[id*=hdnAmt]").val('0');
            $("#lblClient").html($("#ddlclient option:selected").text());
            $("#lblProject").html($("#ddlProject option:selected").text());
            $("#txtallocateHrs").val("0.00");
            $("#txtBufferAmt").val("0.00");
            $find("ListModalPopupBehavior").show();
        });


        //////get project Budgeting data
        $("#ddlProject").on('change', function () {
            ClearAll();
            Get_Finance_Budgeting_ProjectDetails();
            Get_Finance_Budgeting_BudgetDetails();
        });

        $("[id*= btnSave]").live('click', function () {
            var cltid = $("#ddlclient").val();
            var Project = $("#ddlProject").val();
            var PreUsedAmt = $("#txtPreAmtUsed").val();
            var PreUsedHrs = $("#txtPreHrsUsed").val();
            var BudAmt = $("#txtBudAmt").val();
            var BuffAmt = $("#txtBuffAmt").val();
            var BudHrs = $("#txtBudHrs").val();
            var BuffHrs = $("#txtBuffHrs").val();


            $.ajax({
                type: "POST",
                url: "../Handler/Finance_Budgeting.asmx/Save_Finance_Budgeting_ProjectDetails",
                data: '{Compid:' + $("[id*=hdncompid]").val() + ',Cltid:' + cltid + ',ProjectId:' + Project + ',PreUsedAmt:"' + PreUsedAmt + '",PreUsedHrs:"' + PreUsedHrs + '",BudAmt:"' + BudAmt + '",BuffAmt:"' + BuffAmt + '",BudHrs:"' + BudHrs + '",BuffHrs:"' + BuffHrs + '"}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) {
                                alert("Finance budgeting saved successfully");
                                Get_Finance_Budgeting_ProjectDetails();
                                Get_Finance_Budgeting_BudgetDetails();
                                $find("ListModalPopupBehavior").hide();
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

        });


        ////////update 
        $("[id*= btnsavedate]").live('click', function () {
            var cltid = $("#ddlclient").val();
            var Project = $("#ddlProject").val();
            var EndDate = $("#txtEndDate").val();

            $.ajax({
                type: "POST",
                url: "../Handler/Finance_Budgeting.asmx/Save_Finance_Budgeting_EndDate",
                data: '{Compid:' + $("[id*=hdncompid]").val() + ',Cltid:' + cltid + ',ProjectId:' + Project + ',EndDate:"' + EndDate + '"}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) {
                                alert("Project's End Date Updated Successfully");
                                Get_Finance_Budgeting_ProjectDetails();
                                Get_Finance_Budgeting_BudgetDetails();
                                $find("ListModalPopupBehaviorId").hide();
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

        });

        $("[id*= BtnSubmit]").live('click', function () {
            var cltid = $("#ddlclient").val();
            var Project = $("#ddlProject").val();
            var BudDate = $("#txtStartdate").val().split('-');
            var Budhrs = $("#txtallocateHrs").val();
            var BudAmt = $("#txtBufferAmt").val();
            var BudId = $("[id*=hdnBudgetId]").val();
            var JobStart = $("#lblstartdate").text().split('/');
            var JobEnd = $("#lblenddate").text().split('/');
            var start = JobStart[2] + JobStart[1] + JobStart[0];
            var end = JobEnd[2] + JobEnd[1] + JobEnd[0];
            var jobDate = BudDate[0] + BudDate[1] + BudDate[2];
            if (parseFloat(jobDate) < parseFloat(start) || parseFloat(jobDate) > parseFloat(end)) {
                alert("Please Enter Date Between " + $("#lblstartdate").text() + " And " + $("#lblenddate").text());
                return false;
            }
            $.ajax({
                type: "POST",
                url: "../Handler/Finance_Budgeting.asmx/Save_Finance_Budgeting_BudgetAmount",
                data: '{Compid:' + $("[id*=hdncompid]").val() + ',Cltid:' + cltid + ',ProjectId:' + Project + ',BudDate:"' + $("#txtStartdate").val() + '",BudAmt:"' + BudAmt + '",Budhrs:"' + Budhrs + '",BudId:' + BudId + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) {
                                alert("Project Allocated Hours Saved Successfully");
                                Get_Finance_Budgeting_ProjectDetails();
                                Get_Finance_Budgeting_BudgetDetails();
                                $find("ListModalPopupBehavior").hide();
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

        });

    });


    function ClearAll() {
        $("#lblstartdate").html("");
        $("#lblenddate").html("");
        $("#txtPreAmtUsed").val("0.00");
        $("#txtPreHrsUsed").val("0.00");
        $("#txtProjectAmt").val("0.00");
        $("#txtProjectHrs").val("0.00");
        $("#txtBudAmt").val("0.00");
        $("#txtBuffAmt").val("0.00");
        $("#txtBudHrs").val("0.00");
        $("#txtBuffHrs").val("0.00");
        $("[id*=BtnAllocateBuffHrs]").hide();
    }

    ////////////Get Project Budgeting data

    function Get_Finance_Budgeting_ProjectDetails() {
        $.ajax({
            type: "POST",
            url: "../Handler/Finance_Budgeting.asmx/Get_Finance_Budgeting_ProjectDetails",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',Cltid:' + $("#ddlclient").val() + ',ProjectId:' + $("#ddlProject").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {

                            $("#lblstartdate").html(myList[0].StartDate);
                            $("#lblenddate").html(myList[0].EndDate);
                            $("#txtPreAmtUsed").val(myList[0].PreAmtUsed);
                            $("#txtPreHrsUsed").val(myList[0].PreHrsUsed);
                            $("#txtProjectAmt").val(myList[0].ProjectAmount);
                            $("#txtProjectHrs").val(myList[0].ProjectHours);
                            $("#txtBudAmt").val(myList[0].Budget_Amt);
                            $("#txtBuffAmt").val(myList[0].Buffer_Amt);
                            $("#txtBudHrs").val(myList[0].Budget_Hrs);
                            $("#txtBuffHrs").val(myList[0].Buffer_Hrs);
                            if (parseFloat(myList[0].ProjectHours) > 0) {
                                $("[id*=BtnAllocateBuffHrs]").show();
                            }
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


    function Get_Finance_Budgeting_BudgetDetails() {
        $.ajax({
            type: "POST",
            url: "../Handler/Finance_Budgeting.asmx/Get_Finance_Budgeting_BudgetDetails",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',Cltid:' + $("#ddlclient").val() + ',ProjectId:' + $("#ddlProject").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                $("[id*=fldBudgetDtls]").hide();
                if (myList == null) {
                    var trL = $("[id*=tblBudgetDetails] tbody tr:last-child");
                    $("[id*=tblBudgetDetails] tbody").empty();
                    $("td", trL).eq(0).html("");
                    $("td", trL).eq(1).html("");
                    $("td", trL).eq(2).html("No record found");
                    $("td", trL).eq(3).html("");
                    $("td", trL).eq(4).html("");
                    $("td", trL).eq(5).html("");
                    $("td", trL).eq(6).html("");

                    $("[id*=tblBudgetDetails]").append(trL);
                    trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);
                }
                else {
                    if (myList.length == 0) {
                        var trL = $("[id*=tblBudgetDetails] tbody tr:last-child");
                        $("[id*=tblBudgetDetails] tbody").empty();
                        $("td", trL).eq(0).html("");
                        $("td", trL).eq(1).html("");
                        $("td", trL).eq(2).html("No record found");
                        $("td", trL).eq(3).html("");
                        $("td", trL).eq(4).html("");
                        $("td", trL).eq(5).html("");
                        $("td", trL).eq(6).html("");
                        $("[id*=tblBudgetDetails]").append(trL);
                        trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);
                    }
                    else {
                        if (myList.length > 0) {
                            $("[id*=fldBudgetDtls]").show();
                            var trL = $("[id*=tblBudgetDetails] tbody tr:last-child");
                            $("[id*=tblBudgetDetails] tbody").empty();
                            for (var i = 0; i < myList.length; i++) {
                                $("td", trL).eq(0).html(myList[i].sino + "<input type='hidden' id='hdnFinBudId' name='hdnFinBudId' value=" + myList[i].FinBudId + ">");
                                $("td", trL).eq(1).html(myList[i].StartDate);
                                $("td", trL).eq(2).html(myList[i].EndDate);
                                $("td", trL).eq(3).html(myList[i].Budget_Amt);
                                $("td", trL).eq(4).html(myList[i].Budget_Hrs);
                                $("td", trL).eq(5).html("<img src='../images/edit.png' onclick='showedit($(this))'/>");
                                if (myList[i].EndDate == "") { $("td", trL).eq(6).html("<img src='../images/Delete.png' onclick='showdelete($(this))'>"); }
                                else {
                                    $("td", trL).eq(6).html("");
                                }
                                $("[id*=tblBudgetDetails]").append(trL);
                                trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);
                            }

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

    function showedit(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdnFinBudId]").val();
        var date = row.find("td").eq(1).html().split('/');
        var Amt = row.find("td").eq(3).html();
        var Hrs = row.find("td").eq(4).html();
        $("[id*=hdnHrs]").val(Hrs);
        $("[id*=hdnAmt]").val(Amt);
        $("#txtStartdate").val(date[2] + "-" + date[1] + "-" + date[0]);
        $("#txtStartdate").prop('readonly', 'readonly');
        $("#txtallocateHrs").val(Hrs);
        $("#txtBufferAmt").val(Amt);
        $("[id*=hdnBudgetId]").val(Rtid);
        $("#lblClient").html($("#ddlclient option:selected").text());
        $("#lblProject").html($("#ddlProject option:selected").text());
        $find("ListModalPopupBehavior").show();
    }
    function showdelete(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdnFinBudId]").val();
        var BudHrs = row.find('td:eq(4)').text();
        var BudAmt = row.find('td:eq(3)').text();
        $.ajax({
            type: "POST",
            url: "../Handler/Finance_Budgeting.asmx/Delete_Finance_Budegeting",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',FinBudId:' + Rtid + ',BudHrs:"' + BudHrs + '",BudAmt:"' + BudAmt + '"}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList == null) { }
                if (myList.length > 0) {
                    alert(myList[0].Message);
                    Get_Finance_Budgeting_BudgetDetails();
                    Get_Finance_Budgeting_ProjectDetails();
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

    /////////get all project names
    function Get_Finance_Budegeting_ProjectName() {
        $.ajax({
            type: "POST",
            url: "../Handler/Finance_Budgeting.asmx/Get_Finance_Budegeting_ProjectName",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',Cltid:' + $("#ddlclient").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            $("[id*=ddlProject]").empty();
                            $("[id*=ddlProject]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {
                                $("[id*=ddlProject]").append("<option value=" + myList[i].ProjectID + ">" + myList[i].ProjectName + "</option>");
                            }

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
    /////////get all client names
    function Get_Finance_Budegeting_clientName() {
        $.ajax({
            type: "POST",
            url: "../Handler/Finance_Budgeting.asmx/Get_Finance_Budegeting_clientName",
            data: '{Compid:' + $("[id*=hdncompid]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {

                            $("[id*=ddlclient]").empty();
                            $("[id*=ddlclient]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {
                                $("[id*=ddlclient]").append("<option value=" + myList[i].CltId + ">" + myList[i].ClientName + "</option>");
                            }

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

    function ValidateAmount() {
        var PAmt = $("#txtProjectAmt").val();
        var UAmt = $("#txtPreAmtUsed").val();
        var Bud = $("#txtBudAmt").val();
        var Buff = 0;
        if (PAmt == "undefined" || parseFloat(PAmt) == 0) {
            alert("Please Enter Project Amount");
            return;
        }
        if (PAmt == 0) {
            PAmt = 0;
        }

        if (UAmt == "undefined") {
            UAmt = 0;
        }
        if (UAmt == 0) {
            UAmt = 0;
        }

        if (Bud == "undefined") {
            Bud = 0;
        }
        if (Bud == 0) {
            Bud = 0;
        }

        var TAmt = parseFloat(UAmt) + parseFloat(Bud);
        if (PAmt < TAmt) {

        }
        Buff = parseFloat(PAmt) - parseFloat(TAmt);
        if (Buff > -1) {
            $("#txtBuffAmt").val(Buff);
        }
        else {
             
             $("#txtPreAmtUsed").val(0.00);
             
             alert("Please Add Valid Amount");
             return;
        }
    }


    function ValidateHrs() {
        var PHrs = $("#txtProjectHrs").val();
        var UHrs = $("#txtPreHrsUsed").val();
        var Bud = $("#txtBudHrs").val();
        var Buff = 0;
        if (PHrs == "undefined" || parseFloat(PHrs) == 0) {
            alert("Please Enter Project Hours");
            return false;
        }
        if (PHrs == 0) {
            PHrs = 0;
        }

        if (UHrs == "undefined") {
            UHrs = 0;
        }
        if (UHrs == 0) {
            UHrs = 0;
        }

        if (Bud == "undefined") {
            Bud = 0;
        }
        if (Bud == 0) {
            Bud = 0;
        }

        var Thrs = parseFloat(UHrs) + parseFloat(Bud);
        if (PHrs < Thrs) {

        }
        Buff = parseFloat(PHrs) - parseFloat(Thrs);
        if (Buff > -1) {
            $("#txtBuffHrs").val(Buff);
        }
        else {
             
             $("#txtPreHrsUsed").val('0.00');

             alert("Please Add Valid Hours");
             return false;
        }
     }

     function ValidationHoursAmount(i) {
         if (i == 1) {
             var defhrs = parseFloat($("#txtBuffHrs").val()) + parseFloat($("[id*=hdnHrs]").val()) - parseFloat($("#txtallocateHrs").val());
             if (defhrs > -1) { }
             else { alert("Budgeted Hours is Greater than Buffer Hours"); $("#txtallocateHrs").val($("[id*=hdnHrs]").val()); return false; }
         }
         if (i == 2) {
             var defAmt = parseFloat($("#txtBuffAmt").val()) + parseFloat($("[id*=hdnAmt]").val()) - parseFloat($("#txtBufferAmt").val());
             if (defAmt > -1) { }
             else { alert("Budgeted Amount is Greater than Buffer Amount"); $("#txtBufferAmt").val($("[id*=hdnAmt]").val()); return false; }
         }
     }
 

</script>
<style type="text/css">
.RightAlignment
{
   
    text-align:right;
    
    }
</style>
<div class="divstyle">
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="Label2" runat="server" CssClass="Head1" Text="Finance Budgeting"></asp:Label>
        </div>
        <fieldset style="border: solid 1px black; padding: 10px; width: 1175px;">
            <legend style="font-weight: bold; color: Red;"></legend>
            <table style="width: 1000px; padding-left: 40px;">
                <tr>
                    <td>
                        <div class="masterleft">
                            <asp:Label ID="Label3" runat="server" CssClass="labelstyle labelChange" Text="Client"
                                Font-Size="Small"></asp:Label>
                        </div>
                        <div class="DivRight" style="width: 550px;">
                            <select id="ddlclient" class="DropDown" style="width: 435px; height: 30px;">
                                <option value="0">Select</option>
                            </select>
                        </div>
                    </td>
                    <td>
                        <div class="masterleft" style="width: 20%;">
                            <asp:Label ID="Labe1" runat="server" CssClass="labelstyle labelChange" Text="Project"
                                Font-Size="Small"></asp:Label>
                        </div>
                        <div class="DivRight" style="width: 550px;">
                            <select id="ddlProject" class="DropDown" style="width: 435px; height: 30px;">
                                <option value="0">Select</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="height: 15px;">
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="divedBlockNew">
                            <div style="overflow: hidden; width: 100px; float: left">
                                <asp:Label ID="Label7" runat="server" CssClass="labelstyle" Text="Start Date" Font-Size="Small"></asp:Label>
                            </div>
                            <div style="overflow: hidden; width: 150px; float: left">
                            <label id="lblstartdate" class="LabelFontStyle"></label>
                                
                            </div>
                            <div style="overflow: hidden; width: 80px; float: left">
                                <asp:Label ID="Label13" runat="server" CssClass="labelstyle" Text="End Date" Font-Size="Small"></asp:Label>
                            </div>
                            <div style="overflow: hidden; width: 150px; float: left">
                            <label id="lblenddate" class="LabelFontStyle" ></label>
                                
                            </div>
                        </div>
                    </td>
                    <td>
                        <div>
                            <div class="masterleft" style="overflow: hidden; width: 20%; float: left;">
                                <asp:Label ID="Label4" runat="server" CssClass="labelstyle" Text="Pre Amt Used" Font-Size="Small"></asp:Label>
                            </div>
                            <div style="overflow: hidden; width: 25%; float: left">

                                <input type="text" id="txtPreAmtUsed" style=" Width:100px; Height:30px" class="txtbox RightAlignment"  onblur="ValidateAmount()" />
                            </div>
                            <div class="masterleft">
                                <asp:Label ID="Label8" runat="server" CssClass="labelstyle" Text="Pre Hrs Used" Font-Size="Small"></asp:Label>
                            </div>
                            <div class="DivRight" style="width: 15%; float: left;">
        
                                <input type="text" id="txtPreHrsUsed" style=" Width:100px; Height:30px" class="txtbox RightAlignment" onblur="ValidateHrs()"  />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="masterleft">
                            <asp:Label ID="Label1" runat="server" CssClass="labelstyle labelChange" Text="Project Amt"
                                Font-Size="Small"></asp:Label>
                        </div>
                        <div class="DivRight" style="width: 550px;">
                            <input type="text" id="txtProjectAmt"  style=" Width:100px; Height:30px" class="txtbox RightAlignment"  onblur="ValidateAmount()" />
                        </div>
                    </td>
                    <td>
                        <div>
                            <div class="masterleft" style="overflow: hidden; width: 20%; float: left;">
                                <asp:Label ID="Label6" runat="server" CssClass="labelstyle RightAlignment"  Text="Bud.Amount" Font-Size="Small"></asp:Label>
                            </div>
                            <div style="overflow: hidden; width: 25%; float: left">
                                      <input type="text" id="txtBudAmt" style=" Width:100px; Height:30px"  onblur="ValidateAmount()"  class="txtbox RightAlignment"  disabled="disabled" />
                            </div>
                            <div class="masterleft">
                                <asp:Label ID="Label11" runat="server" CssClass="labelstyle RightAlignment" Text="Buf.Amount" Font-Size="Small"></asp:Label>
                            </div>
                            <div class="DivRight" style="width: 15%; float: left;">
                                      <input type="text" id="txtBuffAmt" style=" Width:100px; Height:30px" class="txtbox RightAlignment" disabled="disabled" />
                            </div>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td>
                        <div class="masterleft">
                            <asp:Label ID="Label5" runat="server" CssClass="labelstyle labelChange" Text="Project.Hrs"
                                Font-Size="Small"></asp:Label>
                        </div>
                        <div class="DivRight" style="width: 550px;">
                                  <input type="text" id="txtProjectHrs" style=" Width:100px; Height:30px"  onblur="ValidateHrs()"  class="txtbox RightAlignment" />
                        </div>
                    </td>
                    <td>
                        <div>
                            <div class="masterleft" style="overflow: hidden; width: 20%; float: left;">
                                <asp:Label ID="Label19" runat="server" CssClass="labelstyle" Text="Bud.Hours" Font-Size="Small"></asp:Label>
                            </div>
                            <div style="overflow: hidden; width: 25%; float: left">
                                      <input type="text" id="txtBudHrs" style=" Width:100px; Height:30px" onblur="ValidateHrs()"  class="txtbox RightAlignment" disabled="disabled" />
                            </div>
                            <div class="masterleft">
                                <asp:Label ID="Label21" runat="server" CssClass="labelstyle" Text="Buf.Hrs" Font-Size="Small"></asp:Label>
                            </div>
                            <div class="DivRight" style="width: 20%; float: left;">
                                      <input type="text" id="txtBuffHrs" style=" Width:100px; Height:30px" class="txtbox RightAlignment" disabled="disabled" />
                            </div>
                        </div><input type="button" id="btnSave" class="TbleBtns TbleBtnsPading labelChange" value="Save" />
                    </td>
                  
                </tr>
            </table>
        </fieldset>
        <table><tr><td style="height:25px;"></td></tr> </table>
            <fieldset id="fldBudgetDtls" style="padding-top:25px; padding-left:85px;">
            <table id="tblBudgetDetails" border="1px" class="norecordTble" style="border-collapse: collapse; width: 95%; padding-left: 120px;">
            <thead>
            <tr>
            <th class="grdheader" style="width:25px;">Sr.No</th>
            <th class="grdheader">From Date</th>
            <th class="grdheader">To Date</th>
            <th class="grdheader">Bud.Amt</th>
            <th class="grdheader">Bud.Hours</th>
            <th class="grdheader">Edit</th>
            <th class="grdheader">Delete</th>
            </tr>
            </thead>
            <tbody><tr>
            <td></td>
            <td></td>
            <td></td>
            <td class="RightAlignment"></td>
            <td class="RightAlignment"></td>

            <td align="center"></td>
            <td align="center"></td>
            </tr>
            </tbody>
            </table>


                </fieldset>

             <input id="BtnAllocateBuffHrs" type="button" class="TbleBtnsPading TbleBtns labelChange" value="Allocated Buffer Hrs" runat="server"  /> 
            <input id="btnUpdateNewDate" type="button" class="TbleBtnsPading TbleBtns labelChange" value="Update New Date" runat="server" />

    </div>
    <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server">
    </asp:Button><br />
    <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" BackgroundCssClass="modalBackground"
        CancelControlID="btnCancel" BehaviorID="ListModalPopupBehavior" DropShadow="False"
        PopupControlID="panel10" RepositionMode="RepositionOnWindowScroll" TargetControlID="hideModalPopupViaClientOrginal2">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panel10" runat="server" Width="650px" Height="300px" BackColor="#FFFFFF"
        CssClass="RoundpanelNarr1">
        <div class="Ttlepopu">
            <label class="labelChange subHead1"  ">
               Alloacate Buffer Hours
            </label>

        </div>
        <table  style="padding-left: 5px; padding-right: 5px;">
            <tr>
                <td  style="width: 25px;">

                    <label style="font-weight:bold;" >Client :</label>
                </td>
                <td style="width: 300px">
                    <label id="lblClient"></label>
                </td>
               </tr> <tr>
                 <td  style="width:85px;">
                        <label style="font-weight:bold;">Project  :</label>
                </td>
                <td style="width: 300px">
                      <label id="lblProject"></label>
                </td>
            </tr>
        </table>
        <fieldset style="border: solid 1px black; padding: 10px; padding-top: 5px; height:150px; width:620px;">
        <table>
        <tr>
        <td><label style="font-weight:bold;">Alloction Date</label></td>
        <td>:</td>
        <td><input type="date" id="txtStartdate" class="txtbox" style="height:25px;" /></td>
        </tr>
        <tr><td style="height:15px;"></td></tr>
        <tr>
        <td>
        <label style="font-weight:bold;"> Budget Hours</label>
        </td>
        <td>:</td>
        <td>
        <input type="text" id="txtallocateHrs" onblur='ValidationHoursAmount(1)' class="txtbox RightAlignment"  style="height:25px;"/>
        </td>
        </tr>
                <tr><td style="height:15px;"></td></tr> <tr>
        <td>
        <label style="font-weight:bold;"> Budget Amount</label>
        </td>
        <td>:</td>
        <td>
        <input type="text" id="txtBufferAmt" onblur='ValidationHoursAmount(2)' class="txtbox RightAlignment" style="height:25px;" />
        </td>
        </tr>
        </table>
        </fieldset>
    


        <input id="BtnSubmit" type="button" class="TbleBtns TbleBtnsPading" value="Save" />
        &nbsp;
        <asp:Button ID="btnCancel" runat="server" CssClass="TbleBtns TbleBtnsPading" Text="Cancel" />
        
    </asp:Panel>


        <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="modalBackground"
        CancelControlID="btncanceldate" BehaviorID="ListModalPopupBehaviorId" DropShadow="False"
        PopupControlID="panel1" RepositionMode="RepositionOnWindowScroll" TargetControlID="hideModalPopupViaClientOrginal2">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panel1" runat="server" Width="450px" Height="300px" BackColor="#FFFFFF"
        CssClass="RoundpanelNarr1">
        <div class="Ttlepopu">
            <label class="labelChange">
               Update End Date 
            </label>

        </div>

        <fieldset style="border: solid 1px black; padding: 10px; padding-top: 5px; height:80px;">
        <table>
        <tr>
        <td><label>End Date:</label></td>
        <td><input type="date" id="txtEndDate" /></td>
        </tr>
      
        </table>
        </fieldset>
    


        <input id="btnsavedate" type="button" class="TbleBtns TbleBtnsPading" value="Save" />
        &nbsp;
        <asp:Button ID="btncanceldate" runat="server" CssClass="TbleBtns TbleBtnsPading" Text="Cancel" />
        
    </asp:Panel>
</div>
<asp:HiddenField ID="hdncompid" runat="server" />
<asp:HiddenField ID="hdnedit" runat="server" />
<asp:HiddenField ID="hdndelete" runat="server" />
<asp:HiddenField ID="hdnBudgetId" runat="server" />
<asp:HiddenField ID="hdnAmt" runat="server" />
<asp:HiddenField ID="hdnHrs" runat="server" />
