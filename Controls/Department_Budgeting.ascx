<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Department_Budgeting.ascx.cs" Inherits="controls_Department_Budgeting" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../StyleCss/Divstyle.css" rel="stylesheet" type="text/css" />
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="javascript">

    $(document).ready(function () {
        Get_Project_Budgeting_ProjectName();

        $("#ddlProject").on('change', function () {

            Get_Budgeting_Allocation_Details();
        });

        /////////add Project Budgeting
        $("#btnButSave").on('click', function () {
            $("#txtBudAllocHrs").val("0.00");
            $("[id*=hdnBudHrs]").val(0);
            Get_Department_Budgeting_DepartmentName();
            $("[id*=hdnBudId]").val(0);
            $find("ListModalPopupBehavior").show();
        });

        //////save Project Budgeting
        $("#BtnSubmit").on('click', function () {
            Save_Department_Budgeting_Allocated_Hours();
        });

        ////save Department budgeting
        $("#SaveDeptBudgeting").on('click', function () {
            Save_Department_budgeting_Budget_Hours();
        });
    });


    /////////save Department Budgeting

    function Save_Department_budgeting_Budget_Hours() {
        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Save_Department_budgeting_Budget_Hours",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + $("#ddlProject").val().split(',')[0] + ',BudHrs:"' + $("#txtBudhrs").val() + '",BudHrsId:' + $("[id*=hdnBudId]").val() + ',BudDate:"' + $("#txtDate").val() + '",DetailBudId:' + $("[id*=hdnDetailBudId]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            if (parseFloat(myList[0].Id) > 0) {
                                alert("Department budgeting saved successfully..");

                                $find("ListModalPopupBehaviorDept").hide();
                            }
                            else {
                                alert("Please Select Date Between " + myList[0].FromDate + " and " + myList[0].ToDate);
                                return false;
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

    ///////////Get Department Name

    function Get_Department_Budgeting_DepartmentName() {
        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Get_Department_Budgeting_DepartmentName",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + $("#ddlProject").val().split(',')[0] + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            $("[id*=SelectDeptName]").empty();
                            $("[id*=SelectDeptName]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {

                                $("[id*=SelectDeptName]").append("<option value=" + myList[i].Id + ">" + myList[i].Name + "</option>");
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

    ///////////save budgeting hours
    function Save_Department_Budgeting_Allocated_Hours() {
        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Save_Department_Budgeting_Allocated_Hours",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + $("#ddlProject").val().split(',')[0] + ',BudHrs:"' + $("#txtBudAllocHrs").val() + '",DeptId:' + $("#SelectDeptName").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            alert("Data Saved Successfully..");
                            Get_Budgeting_Allocation_Details();
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
    }

    function Get_Budgeting_Allocation_Details() {
        var JobId = $("[id*=ddlProject]").val().split(',')[0];
        $("#lblProjectHrs").text("Project Hours :" + $("[id*=ddlProject]").val().split(',')[1] + ".00");
        $("#btnButSave").show();
        $("#btnButSave").attr("Value", "Add Department");
        $("#tblBudgetDetails").show();

        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Get_Department_Budgeting_DepartmentDetails",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + JobId + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var trL = $("[id*=tblBudgetDetails] tbody tr:last-child");
                var TotalHrs = 0;
                $("[id*=tblBudgetDetails] tbody").empty();
                if (myList == null) {
                    $("td", trL).eq(0).html("");
                    $("td", trL).eq(1).html("");
                    $("td", trL).eq(2).html("No record found");
                    $("td", trL).eq(3).html("");
                    $("td", trL).eq(4).html("");

                    $("[id*=tblBudgetDetails]").append(trL);
                    trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);
                }
                else {

                    if (myList.length > 0) {


                        for (var i = 0; i < myList.length; i++) {
                            $("td", trL).eq(0).html(myList[i].sino + "<input type='hidden' id='hdnDeptId' name='hdnDeptId' value=" + myList[i].Id + ">");
                            $("td", trL).eq(1).html(myList[i].Name);
                            $("td", trL).eq(2).html(myList[i].BudgetHours);
                            $("td", trL).eq(3).html("<img src='../images/Delete.png' onclick='showdelete($(this))'/>");
                            $("td", trL).eq(4).html("<span id='sp_Allocate' style='color:blue;' onclick='showAllocation($(this))' >Allocate</span>")
                            $("[id*=tblBudgetDetails]").append(trL);
                            trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);
                            TotalHrs = TotalHrs + parseFloat(myList[i].BudgetHours);
                        }


                    } else {

                        $("td", trL).eq(0).html("");
                        $("td", trL).eq(1).html("");
                        $("td", trL).eq(2).html("No record found");
                        $("td", trL).eq(3).html("");
                        $("td", trL).eq(4).html("");

                        $("[id*=tblBudgetDetails]").append(trL);
                        trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);

                    }
                }
                $("#lblBudHrs").text(TotalHrs);
                $("#lblBufHrs").text(parseFloat($("#lblProjectHrs").text().split(':')[1]) - TotalHrs);

            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }

    function showAllocation(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdnDeptId]").val();
        $("[id*=hdnBudId]").val(Rtid);
        var BudHrs = row.find("td").eq(2).html();
        $("[id*=hdnBudHrs]").val(BudHrs);
        $("[id*=hdnDetailBudId]").val(0);
        $("#txtBudhrs").val('0.00');
        get_Date_Validation();
        Get_Department_Budgeting_BudgetDetails();
        $find("ListModalPopupBehaviorDept").show();
    }

    function Get_Department_Budgeting_BudgetDetails() {
        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Get_Department_Budgeting_BudgetDetails",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',BudHrsId:' + $("[id*=hdnBudId]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var trL = $("[id*=TblDeptbudDetails] tbody tr:last-child");
                var TotalHrs = 0;
                $("[id*=TblDeptbudDetails] tbody").empty();
                if (myList == null) {
                    $("td", trL).eq(0).html("");
                    $("td", trL).eq(1).html("");
                    $("td", trL).eq(2).html("No record found");
                    $("td", trL).eq(3).html("");
                    $("td", trL).eq(4).html("");
                    $("td", trL).eq(5).html("");
                    $("[id*=TblDeptbudDetails]").append(trL);
                    trL = $("[id*=TblDeptbudDetails] tbody tr:last-child").clone(true);
                }
                else {

                    if (myList.length > 0) {


                        for (var i = 0; i < myList.length; i++) {
                            $("td", trL).eq(0).html(myList[i].sino + "<input type='hidden' id='hdnDeptBudId' name='hdnDeptBudId' value=" + myList[i].Id + ">");
                            $("td", trL).eq(1).html(myList[i].FromDate);
                            $("td", trL).eq(2).html(myList[i].ToDate);
                            $("td", trL).eq(3).html(myList[i].BudgetHours);
                            if (myList[i].ToDate == '') {
                                $("td", trL).eq(4).html("<img src='../images/edit.png' onclick='showedit($(this))'/>");
                                $("td", trL).eq(5).html("<img src='../images/Delete.png' onclick='showDeptDelete($(this))'/>");
                            }
                            else {
                                $("td", trL).eq(4).html('');
                                $("td", trL).eq(5).html('');
                            }
                            $("[id*=TblDeptbudDetails]").append(trL);
                            trL = $("[id*=TblDeptbudDetails] tbody tr:last-child").clone(true);
                            TotalHrs = TotalHrs + parseFloat(myList[i].BudgetHours);
                        }


                    } else {

                        $("td", trL).eq(0).html("");
                        $("td", trL).eq(1).html("");
                        $("td", trL).eq(2).html("No record found");
                        $("td", trL).eq(3).html("");
                        $("td", trL).eq(4).html("");
                        $("td", trL).eq(5).html("");
                        $("[id*=TblDeptbudDetails]").append(trL);
                        trL = $("[id*=TblDeptbudDetails] tbody tr:last-child").clone(true);

                    }
                }
                $("#lblDeptBudhrs").text(TotalHrs);
                $("#lblDeptBuffHrs").text($("[id*=hdnBudHrs]").val() - TotalHrs);

            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });

    }

    function showDeptDelete(i) {
        var newDate = new Date();
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdnDeptBudId]").val();
        var BudHrs = row.find("td").eq(3).html();
        var result = confirm("Do You want to delete Data");
        var ip = $("[id*= hdnIP]").val();
        var usr = $("[id*= hdnName]").val();
        var uT = $("[id*= hdnUser]").val();
        var aid = $("[id*= hdnDeleteid]").val();
        if (result) {
            $.ajax({
                type: "POST",
                url: "../Handler/Budgeting_Allocation.asmx/Delete_Department_Budgeting_BudgetedHours",
                data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + $("#ddlProject").val().split(',')[0] + ',BudDptId:' + Rtid + ',BudHrs:"' + BudHrs + '",BudHrsId:' + $("[id*=hdnBudId]").val() + ',ip:"' + ip + '",usr:"' + usr + '", ut:"' + uT + '", dt: "' + newDate + '" }',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) {
                                alert(myList[0].message);
                                if (myList[0].message == "Deleted Successfully") {
                                    Get_Department_Budgeting_BudgetDetails();
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
    }

    function showedit(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdnDeptBudId]").val();
        $("[id*=hdnDetailBudId]").val(Rtid);
        var BudHrs = row.find("td").eq(3).html();
        var BudDate = row.find("td").eq(1).html().split('/');
        ////$("#txtBuffHrs").val(parseFloat($("#txtBuffHrs").val()) + parseFloat(BudHrs));
        $("#txtBudhrs").val(BudHrs + '.00');
        $("[id*=hdnBudHrs]").val(BudHrs);
        $("#txtDate").val(BudDate[2] + "-" + BudDate[1] + "-" + BudDate[0]);
        $("#txtDate").prop('readonly', 'readonly');

    }

    function showdelete(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdnDeptId]").val();
        $("[id*=hdnBudId]").val(Rtid);
        var result = confirm("Do You want to delete Data");
        if (result) {
            $.ajax({
                type: "POST",
                url: "../Handler/Budgeting_Allocation.asmx/Delete_Department_Budgeting_AllocatedHours",
                data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + $("#ddlProject").val().split(',')[0] + ',BudHrsId:' + Rtid + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) {
                                alert(myList[0].message);
                                if (myList[0].message == "Deleted Successfully") {
                                    Get_Budgeting_Allocation_Details();
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
    }

    function Get_Project_Budgeting_ProjectName() {
        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Get_Department_Budgeting_ProjectName",
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
                            $("[id*=ddlProject]").empty();
                            $("[id*=ddlProject]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {

                                $("[id*=ddlProject]").append("<option value=" + myList[i].Id + "," + myList[i].BudgetHours + ">" + myList[i].Name + "</option>");
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

    ////validation for date
    function get_Date_Validation() {
        var OldDate = '';

        $("#TblDeptbudDetails > tbody  > tr").each(function () {
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
            $("#txtDate").val(Year + "-" + Month + "-" + Day);
        }
        else {
            var newdate = new Date(OldDate[1] + "/" + OldDate[0] + "/" + OldDate[2]);
            var mindate = new Date();
            mindate.setDate(newdate.getDate() + 1);

            mindate = mindate.toISOString().slice(0, 10);

            $('#txtDate').attr('min', mindate);
        }
    }

    ///////validation for budgeting hours

    function ValidBudgetHours(i) {
        if (i == 2) {
            var NewBudHrs = $("#txtBudAllocHrs").val();
            var BuffHrs = parseFloat($("#lblBufHrs").text()) + parseFloat($("[id*=hdnBudHrs]").val());
            if (parseFloat(NewBudHrs) > parseFloat(BuffHrs)) {
                alert("Budgeting Hours Greater Than Buffer Hours");

                return false;
            }
        }
        if (i == 1) {

            var NewBudHrs = $("#txtBudhrs").val();
            var BuffHrs = parseFloat($("#lblDeptBuffHrs").text()) + parseFloat($("[id*=hdnBudHrs]").val());
            if (parseFloat(NewBudHrs) > parseFloat(BuffHrs)) {
                alert("Budgeting Hours Greater Than Buffer Hours");

                return false;
            }
        }
    }
</script>
<style type="text/css">
    label {
        font-weight: bold;
    }

    .RightAlignment {
        text-align: right;
    }
</style>
<div class="divstyle">
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="Label2" runat="server" CssClass="Head1" Text="Department Budgeting Allocation"></asp:Label>
            <asp:HiddenField ID="hdnIP" runat="server" />
            <asp:HiddenField ID="hdnName" runat="server" />
            <asp:HiddenField ID="hdnUser" runat="server" />
        </div>
    </div>
    <table style="float: right; width: 100%; padding: 10px;">
        <tr>
            <td style="width: 120px;">
                <label id="lblProject">
                    Project :
                </label>
            </td>
            <td style="width: 250px;" colspan="2">
                <select id="ddlProject" class="DropDown" style="width: 250px;">
                    <option value="0">Select</option>
                </select>
            </td>
            <td>
                <label id="lblProjectHrs">
                </label>
            </td>
            <td>
                <input id="btnButSave" type="button" class="TbleBtns TbleBtnsPading" value="Save" style="display: none" /></td>
        </tr>

        <tr>
            <td>
                <label>Budgeted Hrs :</label>
            </td>
            <td style="width: 25px">
                <label id="lblBudHrs">0.00</label></td>
        </tr>
        <tr>
            <td>
                <label>Buffer Hrs :</label>
            </td>
            <td>
                <label id="lblBufHrs">0.00</label></td>
        </tr>
    </table>
    <center>
    <table id="tblBudgetDetails" border="1px" class="norecordTble" style="border-collapse: collapse;
        width: 95%; display:none;">
        <thead>
            <tr>
                <th class="grdheader">
                    Sr.No
                </th>
                <th class="grdheader">
                    Department Name
                </th>

                <th class="grdheader">
                    Allocated Hrs.
                </th>
                
                <th class="grdheader">
                    Delete
                </th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                </td>
                <td>
                </td>
                <td class="RightAlignment">
                </td>
                <td align="center">
                </td>
                <td align="center">
                </td>
            </tr>
        </tbody>
    </table></center>
    <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server"></asp:Button><br />
    <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" BackgroundCssClass="modalBackground"
        CancelControlID="btnCancel" BehaviorID="ListModalPopupBehavior" DropShadow="False"
        PopupControlID="panel10" RepositionMode="RepositionOnWindowScroll" TargetControlID="hideModalPopupViaClientOrginal2">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panel10" runat="server" Width="400px" Height="250px" BackColor="#FFFFFF"
        CssClass="RoundpanelNarr1">
        <div class="Ttlepopu">
            <label class="labelChange">
                Add Department
            </label>
        </div>
        <fieldset style="border: solid 1px black; padding: 10px; padding-top: 5px; height: 150px;">
            <table>
                <tr>
                    <td colspan="2">
                        <label>
                            Department Name</label>
                    </td>
                    <td colspan="2">
                        <select id="SelectDeptName">
                            <option value="0">Select</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <label>
                            Budget Hour</label>
                    </td>
                    <td colspan="2">
                        <input type="text" class="txtbox RightAlignment" onblur="ValidBudgetHours(2)" id="txtBudAllocHrs" />
                    </td>
                </tr>
            </table>
        </fieldset>
        <div style="padding: 15px">
            <input id="BtnSubmit" type="button" class="TbleBtns TbleBtnsPading" value="Save" />
            &nbsp;
           
            <input id="btnCancel" type="button" class="TbleBtns TbleBtnsPading" value="Cancel" />
        </div>
    </asp:Panel>


    <asp:Button Style="display: none" ID="btnHideDeptModal" runat="server"></asp:Button><br />
    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="modalBackground"
        CancelControlID="CancelDeptBudgeting" BehaviorID="ListModalPopupBehaviorDept" DropShadow="False"
        PopupControlID="panel1" RepositionMode="RepositionOnWindowScroll" TargetControlID="btnHideDeptModal">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panel1" runat="server" Width="500px" Height="400px" BackColor="#FFFFFF"
        CssClass="RoundpanelNarr1">
        <div class="Ttlepopu">
            <label class="labelChange">
                Allocate Department Budgeting
            </label>
        </div>
        <fieldset style="border: solid 1px black; padding: 10px; padding-top: 5px; height: 100px;">
            <table>
                <tr>
                    <td>
                        <label>
                            Budget Date</label>
                    </td>
                    <td colspan="2">
                        <input type="date" class="txtbox" id="txtDate" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label>
                            Budget Hour</label>
                    </td>
                    <td colspan="2">
                        <input type="text" class="txtbox RightAlignment" onblur="ValidBudgetHours(1)" id="txtBudhrs" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label>Budgeted Hrs :</label>
                    </td>
                    <td style="width: 25px">
                        <label id="lblDeptBudhrs">0.00</label></td>
                </tr>
                <tr>
                    <td>
                        <label>Buffer Hrs :</label>
                    </td>
                    <td>
                        <label id="lblDeptBuffHrs">0.00</label></td>
                </tr>
            </table>
        </fieldset>
        <div style="padding: 15px">
            <input id="SaveDeptBudgeting" type="button" class="TbleBtns TbleBtnsPading" value="Save" />
            &nbsp;
           
            <input id="CancelDeptBudgeting" type="button" class="TbleBtns TbleBtnsPading" value="Cancel" />
        </div>
        <div>
            <center>
    <table id="TblDeptbudDetails" border="1px" class="norecordTble" style="border-collapse: collapse;
        width: 95%;">
        <thead>
            <tr>
                <th class="grdheader">
                    Sr.No
                </th>
                <th class="grdheader">
                    From Date
                </th>
                <th class="grdheader">
                    To Date
                </th>
                <th class="grdheader">
                    Bud.Hours
                </th>
                <th class="grdheader">
                    Edit
                </th>
                <th class="grdheader">
                    Delete
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td class="RightAlignment">
                </td>
                <td align="center">
                </td>
                <td align="center"></td>
            </tr>
        </tbody>
    </table></center>
        </div>
    </asp:Panel>
    <asp:HiddenField runat="server" ID="hdncompid" />
    <asp:HiddenField runat="server" ID="hdnBudId" />
    <asp:HiddenField runat="server" ID="hdnBudHrs" />
    <asp:HiddenField runat="server" ID="hdnDetailBudId" />
</div>

