<%@ Control Language="C#" AutoEventWireup="true" CodeFile="User_Roles.ascx.cs" Inherits="controls_User_Roles" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../StyleCss/Divstyle.css" rel="stylesheet" type="text/css" />
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<script type="text/javascript" language="javascript">
    var main_obj = [];
    $(document).ready(function () {
        ////////Get All Required data for dropdown
        Get_User_Roles_Details();


        ////////on change of roles get Project details
        $("#ddlRoles").on('change', function () { Get_User_Roles_Projects(); });

        //////////////save Multiple roles Projects

        $("#btnsave").on('click', function () {
            Save_User_Roles_Projects();
        });

    });

    //////////Save Staff's Roles Projects

    function Save_User_Roles_Projects() {
        //////////////////get All Project Selected

        var SelectedProject = '';

        $("input[name=chkjob]:checked").each(function () {
            var chka = $(this).is(':checked');
            if (chka) {
                SelectedProject = $(this).val() + ',' + SelectedProject;
            }
        });

        $.ajax({
            type: "POST",
            url: "../Handler/User_Roles.asmx/Save_User_Roles_Projects",
            data: '{compid:' + $("[id*=hdncompid]").val() + ',Staffcode:' + $("#ddlStaff").val() + ',RoleId:' + $("#ddlRoles").val() + ',DeptId:' + $("#ddlDept").val() + ',SelectedProject:"' + SelectedProject + '"}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { $("#tblProjects").append("<tr><td>No Record Found</td></tr>"); }
                else {
                    if (myList.length == 0) { $("#tblProjects").append("<tr><td>No Record Found</td></tr>"); }
                    else {
                        if (myList.length > 0) {

                            alert("Approver Save Successfully");


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


    /////////Get All required data from database
    function Get_User_Roles_Details() {
        $.ajax({
            type: "POST",
            url: "../Handler/User_Roles.asmx/Get_User_Roles_Details",
            data: '{compid:' + $("[id*=hdncompid]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            $("[id*=DropApp]").empty();
                            $("[id*=DropApp]").append("<option value=" + 0 + ">Select</option>");
                            $("[id*=DropApp]").empty();
                            $("[id*=DropApp]").append("<option value=" + 0 + ">Select</option>");
                            $("[id*=DropApp]").empty();
                            $("[id*=DropApp]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {
                                if (myList[i].Type == 'staff') {
                                    $("[id*=ddlStaff]").append("<option value=" + myList[i].Id + ">" + myList[i].Name + "</option>");
                                }
                                if (myList[i].Type == 'role') {
                                    $("[id*=ddlRoles]").append("<option value=" + myList[i].Id + ">" + myList[i].Name + "</option>");
                                }
                                if (myList[i].Type == 'dept') {
                                    $("[id*=ddlDept]").append("<option value=" + myList[i].Id + ">" + myList[i].Name + "</option>");
                                }
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

    /////////get Project Listing

    function Get_User_Roles_Projects() {
        $.ajax({
            type: "POST",
            url: "../Handler/User_Roles.asmx/Get_User_Roles_Projects",
            data: '{compid:' + $("[id*=hdncompid]").val() + ',Staffcode:' + $("#ddlStaff").val() + ',RoleId:' + $("#ddlRoles").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                $("[id*=tblProjects] tbody").remove();
                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {

                            for (var i = 0; i < myList.length; i++) {
                                var ischeck = "";
                                if (parseFloat(myList[i].Type) > 0) {
                                    ischeck = 'checked';
                                }
                                tr = $('<tr><td><input type="hidden" name="hdnjobid" value="' + myList[i].Id + '">  <input type="checkbox" id="chkjob" name="chkjob" value="' + myList[i].Id + '"' + ischeck + ' />' + myList[i].Name + '</td></tr>');
                                $("#tblProjects").append(tr);

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
<div class="divstyle">
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="Label2" runat="server" CssClass="Head1" Text="User Roles"></asp:Label>
        </div>
        <fieldset style="border: solid 1px black; padding: 10px; width: 1175px;">
            <legend class="labelChange" style="font-weight: bold; color: Red;"></legend>
            <table>
                <tr>
                    <td style="width: 50px;">
                    </td>
                    <td style="overflow: hidden; width: 50px; float: left; padding-left: 5px; font-weight: bold;"
                        class="LabelFontStyle labelChange">
                        Staff
                    </td>
                    <td>
                        <select id="ddlStaff" name="ddlStaff" class="DropDown" style="width: 350px; height: 25px;">
                            <option value="0">--Select--</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="height: 15px;">
                    </td>
                </tr>
                <tr>
                    <td style="width: 50px;">
                    </td>
                    <td style="overflow: hidden; width: 50px; float: left; padding-left: 5px; font-weight: bold;"
                        class="LabelFontStyle labelChange">
                        Roles
                    </td>
                    <td>
                        <select id="ddlRoles" name="ddlRoles" class="DropDown" style="width: 350px; height: 25px;">
                            <option value="0">--Select--</option>
                        </select>
                    </td>
                    <td style="overflow: hidden; width: 100px; float: right; padding-left: 35px; font-weight: bold;"
                        class="LabelFontStyle labelChange">
                        Department
                    </td>
                    <td>
                        <select id="ddlDept" name="ddlDept" class="DropDown" style="width: 350px; height: 25px;">
                            <option value="0">--Select--</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="height: 15px;">
                    </td>
                </tr>
                <tr id="trAssign">
                    <td>
                    </td>
                    <td valign="top">
                        <asp:CheckBox ID="ChkAssg" runat="server" ForeColor="Black" Font-Bold="true" Text="Select All"
                            CssClass="LabelFontStyle labelChange"></asp:CheckBox>
                    </td>
                    <td colspan="2">
                        <fieldset style="border: solid 1px black; padding: 10px; width: 250px;">
                            <legend class="labelstyle labelChange" style="font-weight: bold; color: Red;">Projects</legend>
                            <asp:Panel ID="Panel6" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                Height="200px" ScrollBars="Vertical" Style="overflow: auto; margin: 8px 0 0;
                                float: left;" Width="435px">
                                <table id="tblProjects">
                                </table>
                            </asp:Panel>
                        </fieldset>
                    </td>
                    <td valign="top">
                        <input id="btnsave" type="button" value="Save" class="TbleBtns" />
                    </td>
                    <td>
                    </td>
                </tr>
            </table>
        </fieldset>
        <asp:HiddenField ID="hdncompid" runat="server" />
    </div>
</div>
