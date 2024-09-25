<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Departmentwise_Approver_Allocation.ascx.cs"
    Inherits="controls_Departmentwise_Approver_Allocation" %>
<%@ Register Src="../controls/MyMessageBox.ascx" TagName="MyMessageBox" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script type="text/javascript" language="javascript">
    var main_obj = [];
    $(document).ready(function () {

        /////////////////////////////////////////////////////Dropdown department names////////////////////////////////////////////////////////

        Get_RolewiseAprrover_Rolenames();



        ////////////////////////////////////////////////Datalist Staff/Hod names on Roles change//////////////////////////////////////////

        $("[id*=DropRoleName]").live('change', function () {

            Get_RolewiseApprover_Roles_Details();

        });

        /////////////////////////////////////////////////////Check All Staff checkbox click//////////////////////////////////////////////////
        $("[id*= chkAstaff]").live('click', function () {
            var chk = $("[id*= chkAstaff]").is(':checked');
            $("input[name=chkstaff]").each(function () {
                if (chk == true) {
                    $(this).attr('checked', 'checked');
                } else { $(this).removeAttr('checked'); }
            });
        });
        ////////////////////////////////////////////////save all staff/hod Aprrover //////////////////////////////////////////
        $("[id*=btnsaveApp]").on('click', function () {

            var hdnAstaff = "";

            // Get all Staff and Sub Approver
            $("input[name=chkstaff]:checked").each(function () {
                var chka = $(this).is(':checked');
                if (chka) {
                    hdnAstaff = $(this).val() + ',' + hdnAstaff;
                }
            });
            if (hdnAstaff == "") { alert("Please Select Atleast One Staff"); return false; }




            $.ajax({
                type: "POST",
                url: "../Handler/Departmentwise_Approver_Allocation.asmx/Save_Departmentwise_Approver",
                data: '{compid:' + $("[id*=hdncompid]").val() + ',staffvalue:' + staffvalue + ',Deptid:' + $("[id*=dropDept]").val() + ',Allstaff:"' + hdnAstaff + '",AllHOD:"' + hdnAHOD + '",TopAppId:' + $("[id*=DroptopApp]").val() + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) { alert("Approver Saved Successfully"); }
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



    function Get_RolewiseApprover_Roles_Details() {

        $.ajax({
            type: "POST",
            url: "../Handler/Departmentwise_Approver_Allocation.asmx/Get_RolewiseApprover_Roles_Details",
            data: '{compid:' + $("[id*=hdncompid]").val() + ',RoleId:' + $("[id*=DropRoleName]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
            
             },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });

    }


    //    function Get_DepartmentwiseApprover_Staff_Details() {


    //        $.ajax({
    //            type: "POST",
    //            url: "../Handler/Departmentwise_Approver_Allocation.asmx/Get_DepartmentwiseApprover_Staff_Details",
    //            data: '{compid:' + $("[id*=hdncompid]").val() + ',staffvalue:' + staffvalue + ',Deptid:' + $("[id*=dropDept]").val() + '}',
    //            dataType: 'json',
    //            contentType: "application/json",
    //            success: function (msg) {
    //                main_obj = jQuery.parseJSON(msg.d);
    //                main_obj = main_obj[0];
    //                main_obj = main_obj.objtop;
    //                if (main_obj == null) { }
    //                else {
    //                    if (main_obj.length == 0) { }
    //                    else {
    //                        $("[id*=DroptopApp]").empty();
    //                        $("[id*=DroptopApp]").append("<option value=" + 0 + ">Select</option>");
    //                        for (var i = 0; i < main_obj.length; i++) {
    //                            $("[id*=DroptopApp]").append("<option value=" + main_obj[i].Staffcode + ">" + main_obj[i].StaffNames + "</option>");
    //                        }
    //                    }
    //                }
    //                main_obj = jQuery.parseJSON(msg.d);
    //                main_obj = main_obj[0];
    //                main_obj = main_obj.objstaff;
    //                var tr;
    //                $("[id*=tblstafflist] tbody").remove();
    //                if (main_obj == null) {
    //                    $("#tblstafflist").append("<tr><td>No Record Found</td></tr>");
    //                }
    //                else {
    //                    if (main_obj.length == 0) {
    //                        $("#tblstafflist").append("<tr><td>No Record Found</td></tr>");
    //                    }
    //                    else {


    //                        for (var i = 0; i < main_obj.length; i++) {
    //                            vadfds = "";
    //                            if (parseFloat(main_obj[i].Ischecked) > 0) {
    //                                vadfds = 'checked';
    //                            }

    //                            tr = $('<tr><td><input type="hidden" name="hdnStaffcode" value="' + main_obj[i].Staffcode + '">  <input type="checkbox" id="chkstaff" name="chkstaff" value="' + main_obj[i].Staffcode + '"' + vadfds + ' />' + main_obj[i].StaffNames + '</td></tr>');

    //                            $("#tblstafflist").append(tr);


    //                        }
    //                        $("[id*=DroptopApp]").val(main_obj[0].TopApproverId);
    //                    }
    //                }


    //                main_obj = jQuery.parseJSON(msg.d);
    //                main_obj = main_obj[0];
    //                main_obj = main_obj.objhod;
    //                var tr;
    //                $("[id*=tblhodlist] tbody").remove();
    //                if (main_obj == null) {
    //                    $("#tblhodlist").append("<tr><td>No Record Found</td></tr>");
    //                }
    //                else {
    //                    if (main_obj.length == 0) {
    //                        $("#tblhodlist").append("<tr><td>No Record Found</td></tr>");
    //                    }
    //                    else {


    //                        for (var i = 0; i < main_obj.length; i++) {
    //                            vadfds = "";
    //                            if (parseFloat(main_obj[i].Ischecked) > 0) {
    //                                vadfds = 'checked';
    //                            }

    //                            tr = $('<tr><td><input type="hidden" id="hdnStaffcode" name="hdnStaffcode" value="' + main_obj[i].Staffcode + '">  <input type="checkbox" id="chkHOD" name="chkHOD" value="' + main_obj[i].Staffcode + '"' + vadfds + ' />' + main_obj[i].StaffNames + ' (Dept:' + main_obj[i].DepartmentName + ')</td></tr>');

    //                            $("#tblhodlist").append(tr);
    //                        }
    //                    }
    //                }

    //            },
    //            failure: function (response) {
    //                alert('Cant Connect to Server' + response.d);
    //            },
    //            error: function (response) {
    //                alert('Error Occoured ' + response.d);
    //            }
    //        });

    //    }
    /////////////////////////*****************************Dropdown  Roles names************************///////////////////////////////////////////
    function Get_RolewiseAprrover_Rolenames() {
        $.ajax({
            type: "POST",
            url: "../Handler/Departmentwise_Approver_Allocation.asmx/Get_RolewiseAprrover_Rolenames",
            data: '{compid:' + $("[id*=hdncompid]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        $("[id*=DropRoleName]").empty();
                        $("[id*=DropRoleName]").append("<option value=" + 0 + ">All</option>");
                        for (var i = 0; i < myList.length; i++) {
                            $("[id*=DropRoleName]").append("<option value=" + myList[i].RoleId + ">" + myList[i].RoleName + "</option>");
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
    .drop
    {
        width: 212px;
        font-family: Verdana,Arial,Helvetica,sans-serif;
        border-radius: 5px;
        height: 25px;
        text-decoration: none;
    }
    .label
    {
        font-weight: bold;
        margin-left: 30px;
    }
</style>
<div class="middleContainer">
    <div class="TitleHeader">
        <asp:Label ID="lblheader" runat="server" Text="Departmentwise Approver Allocation"
            CssClass="Head"></asp:Label>
    </div>
    <div style="width: 99.5%;">
        <div class="tdMessageShow" style="border: 1px solid; display: none; font: Tahoma;
            font-size: 13px; text-transform: capitalize;">
            <table width="100%" align="center" height="30px" cellpadding="5" cellspacing="5">
                <tr>
                    <td>
                        <asp:Label ID="lblAllMessage" Font-Bold="true" runat="server" Text="Label"></asp:Label>
                    </td>
                </tr>
            </table>
        </div>
        <div id="dv_StaffHod_Selection" runat="server">
            <table width="100%">
                <tr>
                    <td style="width: 100px;">
                        <asp:Label ID="lblRoleName" CssClass="label" Text="Roles" runat="server"></asp:Label>
                    </td>
                    <td style="width: 100px;">
                        <select id="DropRoleName" runat="server" class="drop">
                            <option value="0" selected="selected">Select</option>
                        </select>
                    </td>
                    <td>
                        <asp:Label ID="lblAppname" CssClass="label" Text="Approver" runat="server"></asp:Label>
                    </td>
                    <td>
                        <select id="dropAppname" runat="server" class="drop">
                            <option value="0" selected="selected">Select</option>
                        </select>
                    </td>
                    <td>
                        <asp:Label ID="lbltopapp" CssClass="label" Text="Top Approver" runat="server"></asp:Label>
                    </td>
                    <td style="width: 100px;">
                        <select id="DroptopApp" runat="server" class="drop">
                            <option value="0" selected="selected">Select</option>
                        </select>
                    </td>
                    <td>
                        <input id="btnsaveApp" type="button" value="Save" class="TbleBtns" />
                    </td>
                </tr>
                <tr style="border-color: Gray; border-width: thick;">
                    <td colspan="6" style="border-color: Gray; border-width: thick;">
                        <asp:Label ID="lblstaff" Text="Staff:" CssClass="label" runat="server"></asp:Label>
                        <input type="checkbox" id="chkAstaff" /><label id="lblAstaff">Check All</label>
                    </td>
                </tr>
                <tr>
                    <td colspan="6">
                        <asp:Panel ID="Panel6" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                            Height="400px" ScrollBars="Vertical" Style="overflow: auto; margin: 8px 0 0;
                            float: left;" Width="470px">
                            <table id="tblstafflist">
                            </table>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <asp:HiddenField ID="hdncompid" runat="server" />
</div>
