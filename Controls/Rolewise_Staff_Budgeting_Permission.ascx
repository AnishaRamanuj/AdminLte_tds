<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Rolewise_Staff_Budgeting_Permission.ascx.cs"
    Inherits="controls_Rolewise_Staff_Budgeting_Permission" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../StyleCss/Divstyle.css" rel="stylesheet" type="text/css" />
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        $("[id*=btnAddBudPermission]").live('click', function () {
            $("[id*=ddlRolenames]").val('0');
            $("[id*=ddlStaffNames]").val('0');
            $(".chkBud:checked").each(function () {
                $(this).removeAttr('checked');
            });
            $("[id*=hdnRoleStaffBudId]").val('0');
            $find("ListModalPopupBehavior").show();
        });
        //////////get Rolewise Staff Budgeting Details
        Get_Rolewise_Staff_Budgeting_Permission_Details();

        /////////////get Rolenames for Dropdown
        Get_Rolewise_Staff_Budgeting_Permission_RoleNames();

        $("#ddlRolenames").on('change', function () {
            ////////////Get Staffnames for Dropdown
            Get_Rolewise_Staff_Budgeting_Permission_StaffNames(0);
        });

        $("#selectRoles").on('change', function () {
            Get_Rolewise_Staff_Budgeting_Permission_Details();
        });

        $("[id*=btnSearch]").live('click', function () {
            Get_Rolewise_Staff_Budgeting_Permission_Details();
        });


        /////////////////////Save rolewise Permissions

        $("#BtnSubmit").on('click', function () {
            var permission = "";
            $(".chkBud:checked").each(function () {
                permission = permission + $(this).val() + ",";
            });
            if (permission == '') { alert("Please Select Atleast One Type"); }
            if ($("[id*=ddlRolenames]").val() == '' || $("[id*=ddlRolenames]").val() == '0') {
                alert("Please Select Role Name");
                return;
            }
            if ($("[id*=ddlStaffNames]").val() == '' || $("[id*=ddlStaffNames]").val() == '0') {
                alert("Please Select Staff Name");
                return;
            }
            $.ajax({
                type: "POST",
                url: "../Handler/Rolewise_Staff_Budgeting_Permission.asmx/Save_Rolewise_Staff_Budgeting_Permissions",
                data: '{Compid:' + $("[id*=hdncompid]").val() + ',RoleID:' + $("[id*=ddlRolenames]").val() + ',StaffCode:' + $("[id*=ddlStaffNames]").val() + ',permission:"' + permission + '",RoleStaffBudId:' + $("[id*=hdnRoleStaffBudId]").val() + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) {

                                alert("Data Saved Successfully");
                                Get_Rolewise_Staff_Budgeting_Permission_Details();
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

    //////////get Rolewise Staff Budgeting Details
    function Get_Rolewise_Staff_Budgeting_Permission_Details() {
        $.ajax({
            type: "POST",
            url: "../Handler/Rolewise_Staff_Budgeting_Permission.asmx/Get_Rolewise_Staff_Budgeting_Permission_Details",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',RoleID:' + $("[id*=selectRoles]").val() + ',Srch:"' + $("[id*=txtSrchStaff]").val() + '"}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) {
                    var trL = $("[id*=tblBudgetDetails] tbody tr:last-child");
                    $("[id*=tblBudgetDetails] tbody").empty();
                    $("td", trL).eq(0).html("");
                    $("td", trL).eq(1).html("");
                    $("td", trL).eq(2).html("No record found");
                    $("td", trL).eq(3).html("");
                    $("td", trL).eq(4).html("");
                    $("td", trL).eq(5).html("");
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
                        $("[id*=tblBudgetDetails]").append(trL);
                        trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);
                    }
                    else {
                        if (myList.length > 0) {

                            var trL = $("[id*=tblBudgetDetails] tbody tr:last-child");
                            $("[id*=tblBudgetDetails] tbody").empty();
                            for (var i = 0; i < myList.length; i++) {
                                $("td", trL).eq(0).html(myList[i].sino + "<input type='hidden' id='hdnBudId' name='hdnBudId' value=" + myList[i].RoleStaffBudId + ">");
                                $("td", trL).eq(1).html(myList[i].Rolename + "<input type='hidden' id='hdnRoleId' name='hdnRoleId' value=" + myList[i].RoleID + ">");
                                $("td", trL).eq(2).html(myList[i].StaffName + "<input type='hidden' id='hdnStaffCode' name='hdnStaffCode' value=" + myList[i].StaffCode + ">");
                                $("td", trL).eq(3).html(myList[i].Budgeting_type);
                                $("td", trL).eq(4).html("<img src='../images/edit.png' onclick='showedit($(this))'/>");
                                $("td", trL).eq(5).html("<img src='../images/delete.jpg' onclick='DeleteBudget($(this))' />");
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

    ///////edit budget

    function showedit(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdnBudId]").val();
        var RoleId = row.find("input[name=hdnRoleId]").val();
        $('input[type=checkbox]').prop('checked', false);
        var StaffCode = row.find("input[name=hdnStaffCode]").val();
        var BudgetingType = row.find("td").eq(3).html().split(',');
        for (var i = 0; i < BudgetingType.length; i++) {
            if (BudgetingType[i] != undefined || BudgetingType[i] != '') {
                $('input[type=checkbox][value=' + BudgetingType[i] + ']').prop('checked', true);
            }
        }
        $("#ddlRolenames").val(RoleId);
        Get_Rolewise_Staff_Budgeting_Permission_StaffNames(StaffCode);

        $("[id*=hdnRoleStaffBudId]").val(Rtid);
        $find("ListModalPopupBehavior").show();

    }

    function DeleteBudget(i) {
        var newDate = new Date();

        var result = confirm("Want to delete?");
        if (result) {
            var row = i.closest("tr");
            var Rtid = row.find("input[name=hdnBudId]").val();
            var ip = $("[id*= hdnIP]").val();
            var usr = $("[id*= hdnName]").val();
            var uT = $("[id*= hdnUser]").val();
            $.ajax({
                type: "POST",
                url: "../Handler/Rolewise_Staff_Budgeting_Permission.asmx/Delete_Rolewise_Staff_Budgeting_Permissions",
                data: '{Compid:' + $("[id*=hdncompid]").val() + ',RoleStaffBudId:' + Rtid + ',ip:"' + ip + '",usr:"' + usr + '", ut:"' + uT + '", dt: "' + newDate + '" }',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) {
                                alert("Deleted Data Successfully..");
                                Get_Rolewise_Staff_Budgeting_Permission_Details();
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

    function Get_Rolewise_Staff_Budgeting_Permission_StaffNames(StaffCode) {
        $.ajax({
            type: "POST",
            url: "../Handler/Rolewise_Staff_Budgeting_Permission.asmx/Get_Rolewise_Staff_Budgeting_Permission_StaffNames",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',RoleID:' + $("[id*=ddlRolenames]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            $("[id*=ddlStaffNames]").empty();
                            $("[id*=ddlStaffNames]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {

                                $("[id*=ddlStaffNames]").append("<option value=" + myList[i].StaffCode + ">" + myList[i].StaffName + "</option>");
                            }
                            $("#ddlStaffNames").val(StaffCode);
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

    function Get_Rolewise_Staff_Budgeting_Permission_RoleNames() {
        $.ajax({
            type: "POST",
            url: "../Handler/Rolewise_Staff_Budgeting_Permission.asmx/Get_Rolewise_Staff_Budgeting_Permission_RoleNames",
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
                            $("[id*=selectRoles]").empty();
                            $("[id*=selectRoles]").append("<option value=" + 0 + ">Select</option>");
                            $("[id*=ddlRolenames]").empty();
                            $("[id*=ddlRolenames]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {
                                $("[id*=selectRoles]").append("<option value=" + myList[i].RoleID + ">" + myList[i].Rolename + "</option>");
                                $("[id*=ddlRolenames]").append("<option value=" + myList[i].RoleID + ">" + myList[i].Rolename + "</option>");
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

</script>
<style type="text/css">
    label {
        font-weight: bold;
    }
</style>
<div class="divstyle">
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="Label2" runat="server" CssClass="Head1" Text="Rolewise Budgeting Permissions"></asp:Label>
        </div>
    </div>
    <table style="float: right; width: 100%; padding: 10px;">
        <tr style="height: 30px;">
            <td style="width: 70px;">
                <label>
                    Roles :</label>
            </td>
            <td style="width: 300px;">
                <select id="selectRoles" class="DropDown" style="width: 250px;">
                    <option value="0">Select</option>
                </select>
            </td>
            <td style="width: 70px;">
                <label>
                    Staff :</label>
            </td>
            <td style="width: 250px;">
                <input type="text" id="txtSrchStaff" class="txtbox" style="width: 250px;" />
            </td>
            <td>
                <input id="btnSearch" type="button" class="TbleBtnsPading TbleBtns labelChange" value="Search"
                    runat="server" />
            </td>
            <td>
                <input id="btnAddBudPermission" type="button" class="TbleBtnsPading TbleBtns labelChange"
                    value="New Permission" runat="server" />
            </td>
        </tr>
        <tr>
            <td colspan="6">
                <table id="tblBudgetDetails" border="1px" class="norecordTble" style="border-collapse: collapse; width: 100%; padding-left: 120px;">
                    <thead>
                        <tr>
                            <th class="grdheader">Sr.No
                            </th>
                            <th class="grdheader">Role Name
                            </th>
                            <th class="grdheader">Staff Name
                            </th>
                            <th class="grdheader">Budgeting Type
                            </th>
                            <th class="grdheader">Edit
                            </th>
                            <th class="grdheader">Delete
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td align="center"></td>
                            <td align="center"></td>
                        </tr>
                    </tbody>
                </table>
            </td>
        </tr>
    </table>
    <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server"></asp:Button><br />
    <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" BackgroundCssClass="modalBackground"
        CancelControlID="btnCancel" BehaviorID="ListModalPopupBehavior" DropShadow="False"
        PopupControlID="panel10" RepositionMode="RepositionOnWindowScroll" TargetControlID="hideModalPopupViaClientOrginal2">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panel10" runat="server" Width="400px" Height="250px" BackColor="#FFFFFF"
        CssClass="RoundpanelNarr1">
        <div class="Ttlepopu">
            <label class="labelChange">
                Alloacate Rolewise Budgeting
            </label>
        </div>
        <fieldset style="border: solid 1px black; padding: 10px; padding-top: 5px; height: 150px;">
            <table>
                <tr>
                    <td style="width: 70px;">
                        <label>
                            Roles :</label>
                    </td>
                    <td>
                        <select class="DropDown" id="ddlRolenames" style="width: 250px;">
                            <option value="0">Select</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="width: 70px;">
                        <label>
                            Staff :</label>
                    </td>
                    <td>
                        <select class="DropDown" id="ddlStaffNames" style="width: 250px;">
                            <option value="0">Select</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="checkbox" class="chkBud" value="Project" id="chkProject" />
                        <label>
                            Project</label>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="checkbox" class="chkBud" value="Department" id="chkDept" />
                        <label>
                            Department</label>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="checkbox" class="chkBud" value="Job" id="ChkJob" />
                        <label>
                            Job</label>
                    </td>
                </tr>

            </table>
        </fieldset>
        <div style="padding: 15px">
            <input id="BtnSubmit" type="button" class="TbleBtns TbleBtnsPading" value="Save" />
            &nbsp;
        <asp:Button ID="btnCancel" runat="server" CssClass="TbleBtns TbleBtnsPading" Text="Cancel" />
        </div>
    </asp:Panel>
    <asp:HiddenField ID="hdncompid" runat="server" />
    <asp:HiddenField ID="hdnRoleStaffBudId" runat="server" />
    <asp:HiddenField ID="hdnIP" runat="server" />
    <asp:HiddenField ID="hdnName" runat="server" />
    <asp:HiddenField ID="hdnUser" runat="server" />
</div>
