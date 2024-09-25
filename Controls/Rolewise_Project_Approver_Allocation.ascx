<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Rolewise_Project_Approver_Allocation.ascx.cs"
    Inherits="controls_Rolewise_Project_Approver_Allocation" %>
<%@ Register Src="../controls/MyMessageBox.ascx" TagName="MyMessageBox" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
      <script src="../js/jquery.min.js" type="text/javascript"></script>
 
    <script src="../js/jquery.min.js" type="text/javascript"></script>
    <script src="../js/bootstrap.bundle.min.js" type="text/javascript"></script>
    <script src="../js/blockui.min.js" type="text/javascript"></script>
    <script src="../js/ripple.min.js" type="text/javascript"></script>
    <script src="../js/jgrowl.min.js" type="text/javascript"></script>
    <script src="../js/pnotify.min.js" type="text/javascript"></script>
    <script src="../js/noty.min.js" type="text/javascript"></script>


    <script src="../js/interactions.min.js" type="text/javascript"></script>
    <script src="../js/datatables.min.js" type="text/javascript"></script>
    <script src="../js/switch.min.js" type="text/javascript"></script>
    <script src="../js/uniform.min.js" type="text/javascript"></script>
    <script src="../js/app.js" type="text/javascript"></script>

    <script src="../js/Ajax_Pager.min.js" type="text/javascript"></script>
    <script src="../js/components_popups.js" type="text/javascript"></script>

    <script src="../js/components_modals.js" type="text/javascript"></script>

    <script src="../js/PopupAlert.js" type="text/javascript"></script>
<script type="text/javascript" language="javascript">
    var main_obj = [];
    $(document).ready(function () {

        /////////////////////////////////////////////////////Dropdown Roles names////////////////////////////////////////////////////////

        Get_Roles_Projectwise_Rolesnames();

        ///////////////////////////////////////get roles by role names///////////////////////////////////////////
        $("[id*=dropRole]").on('change', function () {

            Get_Rolewise_Staff();

        });
        $("[id*=DropApp]").on('change', function () {

            Get_Rolewise_client_project_departrment();

        });


        $("[id*=DropProject]").on('change', function () {

            Get_Rolewise_project_staff();

        });

        ////////////////////////////////////////////////Check All Client Project Department checkbox click//////////////////////////////////////////
        $("[id*=chkACltPrj]").on('click', function () {
            var chk = $("[id*= chkACltPrj]").is(':checked');
            $("input[name=chkstaff]").each(function () {
                if (chk == true) {
                    $(this).attr('checked', 'checked');
                } else { $(this).removeAttr('checked'); }
            });
        });


        ////////////////////////////////////////////////save all Client Project department roles Aprrover //////////////////////////////////////////
        $("[id*=btnsaveApp]").on('click', function () {

            var hdnAstaff = "";

            // Get all Client Project department
            $("input[name=chkstaff]:checked").each(function () {
                var chka = $(this).is(':checked');
                if (chka) {
                    hdnAstaff = $(this).val() + ',' + hdnAstaff;
                }
            });

            var Type = 0;
            var x = document.getElementById("<%=radio_Project.ClientID%>");
            var y = document.getElementById("<%=radio_Staff.ClientID%>");
            var z = document.getElementById("<%=radio_staff_project.ClientID%>");

            if (x.checked) { Type = "Project" }
            if (y.checked) { Type = "Staff" }
            if (z.checked) { Type = "ProjectStaff" }
            if (hdnAstaff == "") {
                if (Type == "Project") {
                    alert("Please select atleast one Project");
                }
                else {
                    alert("Please select atleast one Staff");
                }
            }
            $.ajax({
                type: "POST",
                url: "../Handler/Rolewise_Project_Approver_Allocation.asmx/Save_Rolewise_Report_Head",
                data: '{compid:' + $("[id*=hdncompid]").val() + ',Type:"' + Type + '",Role_Id:' + $("[id*=dropRole]").val() + ',AllCPD:"' + hdnAstaff + '",RHeadId:' + $("[id*=DropApp]").val() + ',ProjectId:' + $("[id*=DropProject]").val() + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) { alert("Report Head Saved Successfully"); }
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


        ////////////////////////////////////////////////Radio button change event //////////////////////////////////////////
        $("[id*=radio_Project]").on('change', function () {
            $("[id*=dropRole]").val(0);
            $("[id*=DropProject]").val(0);
            $("[id*=tblstafflist] tbody").remove();
            $("[id*=DropApp]").empty();
            $("[id*=DropApp]").append("<option value=0>Select</option>");
            $("#dvProjectstaff").hide();
            $("[id*=lblCltPrj]").text("Client/Project");
        });
        $("[id*=radio_Staff]").on('change', function () {
            $("[id*=dropRole]").val(0);
            $("[id*=DropProject]").val(0);
            $("[id*=tblstafflist] tbody").remove();
            $("[id*=DropApp]").empty();
            $("[id*=DropApp]").append("<option value=0>Select</option>");
            $("#dvProjectstaff").hide();
            $("[id*=lblCltPrj]").text("Staff");
        });
        $("[id*=radio_staff_project]").on('change', function () {
            $("[id*=dropRole]").val(0);
            $("[id*=DropProject]").val(0);
            $("[id*=tblstafflist] tbody").remove();
            $("[id*=DropApp]").empty();
            $("[id*=DropApp]").append("<option value=0>Select</option>");
            $("#dvProjectstaff").show();
            $("[id*=lblCltPrj]").text("Staff");
        });
    });


    /////////////////////////*****************************Get staffnames by thair roles************************///////////////////////////////////////////

    function Get_Rolewise_project_staff() {
        $.ajax({
            type: "POST",
            url: "../Handler/Rolewise_Project_Approver_Allocation.asmx/Get_Rolewise_project_staff",
            data: '{compid:' + $("[id*=hdncompid]").val() + ',ProjectId:' + $("[id*=DropProject]").val() + ',Role_Id:' + $("[id*=dropRole]").val() + ',Headid:' + $("[id*=DropApp]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                main_obj = jQuery.parseJSON(msg.d);
                var tr = "";
                if (main_obj == null) {
                    $("#tblstafflist").append("<tr><td>No Record Found</td></tr>");
                }
                else {
                    if (main_obj.length == 0) {
                        $("#tblstafflist").append("<tr><td>No Record Found</td></tr>");
                    }
                    else {
                        for (var i = 0; i < main_obj.length; i++) {
                            vadfds = "";
                            if (parseFloat(main_obj[i].ischeck) > 0) {
                                vadfds = 'checked';
                            }
                            tr = $('<tr><td><input type="hidden" name="hdnStaffcode" value="' + main_obj[i].Id + '">  <input type="checkbox" id="chkstaff" name="chkstaff" value="' + main_obj[i].Id + '"' + vadfds + ' />' + main_obj[i].Name + '</td></tr>');
                            $("#tblstafflist").append(tr);
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
    /////////////////////////*****************************Get staffnames by thair roles************************///////////////////////////////////////////

    function Get_Rolewise_Staff() {
        var type = 0;
        var y = document.getElementById("<%=radio_Project.ClientID%>");
        if (y.checked == true) {
            type = 0
        }
        else {
            type = 1
        }
        $.ajax({
            type: "POST",
            url: "../Handler/Rolewise_Project_Approver_Allocation.asmx/Get_Rolewise_Staff",
            data: '{compid:' + $("[id*=hdncompid]").val() + ',Role_Id:' + $("[id*=dropRole]").val() + ',Type:' + type + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                main_obj = jQuery.parseJSON(msg.d);

                if (main_obj == null) { }
                else {
                    if (main_obj.length == 0) { }
                    else {
                        $("[id*=DropApp]").empty();
                        $("[id*=DropApp]").append("<option value=" + 0 + ">All</option>");
                        for (var i = 0; i < main_obj.length; i++) {
                            $("[id*=DropApp]").append("<option value=" + main_obj[i].Staffcode + ">" + main_obj[i].StaffNames + "</option>");
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

    /////////////////////////*****************************Get client project departrment by thair head************************///////////////////////////////////////////

    function Get_Rolewise_client_project_departrment() {
        var Type = 0;
        var x = document.getElementById("<%=radio_Project.ClientID%>");
        var y = document.getElementById("<%=radio_Staff.ClientID%>");
        var z = document.getElementById("<%=radio_staff_project.ClientID%>");

        if (x.checked) { Type = "Project" }
        if (y.checked) { Type = "Staff" }
        if (z.checked) { Type = "ProjectStaff" }
        $.ajax({
            type: "POST",
            url: "../Handler/Rolewise_Project_Approver_Allocation.asmx/Get_Rolewise_client_project_departrment",
            data: '{compid:' + $("[id*=hdncompid]").val() + ',Role_Id:' + $("[id*=dropRole]").val() + ',Type:"' + Type + '",Headid:' + $("[id*=DropApp]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                main_obj = jQuery.parseJSON(msg.d);

                var tr;
                $("[id*=tblstafflist] tbody").remove();
                if (main_obj == null) {
                    $("#tblstafflist").append("<tr><td>No Record Found</td></tr>");
                }
                else {
                    if (main_obj.length == 0) {
                        $("#tblstafflist").append("<tr><td>No Record Found</td></tr>");
                    }
                    else {
                        for (var i = 0; i < main_obj.length; i++) {
                            vadfds = "";
                            if (parseFloat(main_obj[i].ischeck) > 0) {
                                vadfds = 'checked';
                            }
                            if (main_obj[i].Type == "Project" || main_obj[i].Type == "Staff") {
                                if (main_obj[i].Id > 0 && main_obj[i].Id != null) {
                                    tr = $('<tr><td><input type="hidden" name="hdnStaffcode" value="' + main_obj[i].Id + '">  <input type="checkbox" id="chkstaff" name="chkstaff" value="' + main_obj[i].Id + '"' + vadfds + ' />' + main_obj[i].Name + '</td></tr>');
                                }
                                else {
                                    tr = $('<tr><td>' + main_obj[i].Name + '</td></tr>');
                                }
                                $("#tblstafflist").append(tr);
                            }
                            else {
                                $("[id*=DropProject]").append("<option value=" + main_obj[i].Id + ">" + main_obj[i].Name + "</option>");
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

    /////////////////////////*****************************Dropdown  Roles names************************///////////////////////////////////////////
    function Get_Roles_Projectwise_Rolesnames() {
        $.ajax({
            type: "POST",
            url: "../Handler/Rolewise_Project_Approver_Allocation.asmx/Get_Roles_Projectwise_Rolesnames",
            data: '{compid:' + $("[id*=hdncompid]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        $("[id*=dropRole]").empty();
                        $("[id*=dropRole]").append("<option value=" + 0 + ">All</option>");
                        for (var i = 0; i < myList.length; i++) {
                            $("[id*=dropRole]").append("<option value=" + myList[i].Role_Id + ">" + myList[i].Rolenames + "</option>");
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
    }
</style>
<div class="middleContainer">
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="Label18" runat="server" CssClass="Head1 labelChange" Text="Report Allocation"></asp:Label>
        </div>
    </div>
    <asp:HiddenField ID="hdncompid" runat="server" />
    <div class="tdMessageShow" style="border: 1px solid; display: none; font: Tahoma;
        font-size: 13px; text-transform: capitalize;">
        <table width="100%" align="center" height="30px" cellpadding="5" cellspacing="5"
            style="padding-top: 10px;">
            <tr>
                <td>
                    <asp:Label ID="lblAllMessage" Font-Bold="true" runat="server" Text="Label"></asp:Label>
                </td>
            </tr>
        </table>
    </div>
    <table style="width: 100%; padding-top: 15px;">
        <tr>
            <td>
            </td>
            <td>
                <asp:RadioButton ID="radio_Project" Checked="true" Text="Project" Font-Bold="true"
                    GroupName="r" runat="server" CssClass="labelChange" />
            </td>
            <td>
                <asp:RadioButton ID="radio_Staff" runat="server" Text="Staff" GroupName="r" Font-Bold="true"
                    CssClass="labelChange" />
            </td>
            <td>
                <asp:RadioButton ID="radio_staff_project" runat="server" Text="Staff Project" GroupName="r"
                    Font-Bold="true" CssClass="labelChange" />
            </td>
            <td style="font-weight: bold;">
                Roles
            </td>
            <td>
                <select id="dropRole" runat="server" style="width: 100px; height: 25px;" class="drop">
                    <option value="0" selected="selected">Select</option>
                </select>
            </td>
            <td>
                <asp:Label ID="lblReportHead" Text="Report Head:" CssClass="label" runat="server"></asp:Label>
            </td>
            <td style="width: 250px;">
                <select id="DropApp" runat="server" class="drop" style="margin: 8px 0 0; width: 250px;
                    height: 25px;">
                    <option value="0" selected="selected">Select</option>
                </select>
            </td>
            <td>
                <input id="btnsaveApp" type="button" value="Save" class="TbleBtns" />
            </td>
            
        </tr>
        <tr>
            <td>
            </td>
            <td colspan="7">
                <div id="dvProjectstaff" style="display: none; padding-top: 10px;">
                    <asp:Label ID="lblProject" CssClass="label" Text="&nbsp;&nbsp;&nbsp;&nbsp;Project"
                        runat="server"></asp:Label>&nbsp;&nbsp;
                    <select id="DropProject" runat="server" style="width: 700px; height: 25px;" class="drop">
                        <option value="0" selected="selected">Select</option>
                    </select></div>
            </td>
            <td>
            </td>
            <td>
            </td>
            <td>
            </td>
            <td>
            </td>
            <td>
            </td>
            <td>
            </td>
            <td>
            </td>
            <td>
            </td>
        </tr>
    </table>
    <div style="width: 99.5%;">
        <div id="dv_StaffHod_Selection" runat="server">
            <table style="padding-left: 18px; padding-top: 10px;">
                <tr>
                    <td colspan="6">
                        <table>
                            <tr style="border-color: Gray; border-width: thick;">
                                <td style="border-color: Gray; border-width: thick;">
                                    <asp:Label ID="lblCltPrj" Text="Client/Project:" CssClass="label" runat="server"></asp:Label>
                                    <input type="checkbox" id="chkACltPrj" /><label id="lblACltPrj">Check All</label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Panel ID="Panel6" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                        Height="400px" ScrollBars="Vertical" Style="overflow: auto; margin: 8px 0 0;
                                        float: left;" Width="470px">
                                        <table id="tblstafflist">
                                        </table>
                                    </asp:Panel>
                                </td>
                                <td valign="top" style="padding-top: 10px;">
                                </td>
                                <td valign="top">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>
