<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Rolewise_Staff_Approver_Allocation.ascx.cs" Inherits="controls_Rolewise_Staff_Approver_Allocation" %>
<%@ Register Src="../controls/MyMessageBox.ascx" TagName="MyMessageBox" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%--<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>--%>
<script type="text/javascript" language="javascript">
    var main_obj = [];
    $(document).ready(function () {

        //////////////////////////////////////////////finding Company Single or Dual Approver

        if ($("[id*=hdnAppPatern]").val() == "True") {
            $("#dvAppPatern").show();
        }
        else {
            $("#dvAppPatern").hide();
        }

        /////////////////////////////////////////////////////Dropdown Roles names////////////////////////////////////////////////////////

        Get_Rolesnames();

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

        $("[id*=chkallStf]").on('click', function () {
            var chk = $("[id*= chkallStf]").is(':checked');
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
//            if (hdnAstaff == "") {
//                if (Type == "Project") {
//                    alert("Please select atleast one Project");
//                }
//                else {
//                    alert("Please select atleast one Staff");
//                }
            //            }


            $.ajax({
                type: "POST",
                url: "../Handler/Rolewise_Staff_Approver_Allocation.asmx/Save_Rolewise_Report_Head",
                data: '{compid:' + $("[id*=hdncompid]").val() + ',Type:"' + Type + '",Role_Id:' + $("[id*=dropRole]").val() + ',AllCPD:"' + hdnAstaff + '",RHeadId:' + $("[id*=DropApp]").val() + ',ProjectId:' + $("[id*=DropProject]").val() + ',AppPatern:"'+$("#SelectAppPatern").val()+'"}',
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


        ////////////////////////////////////////////////Radio button change event //////////////////////////////////////////
        $("[id*=radio_Project]").on('change', function () {
            //$("[id*=dropRole]").val(0);
            //$("[id*=DropProject]").val(0);
            $("[id*=tbllist] tbody").remove();
            $("[id*=tblstafflist] tbody").remove();
            //$("[id*=DropApp]").empty();
            //$("[id*=DropApp]").append("<option value=0>Select</option>");
            $("#dvProjectstaff").hide();
            $("#dvProjectstafftbl").hide();
            $("#dvProjectstafflbl").hide();
            $("#dvProjectlbl").show(); 
            $("#dvProjecttbl").show(); 
            Get_Rolewise_client_project_departrment();

            $("[id*=lblCltPrj]").text("Client/Project");
        });
        $("[id*=radio_Staff]").on('change', function () {
            //$("[id*=dropRole]").val(0);
            //$("[id*=DropProject]").val(0);
            $("[id*=tbllist] tbody").remove();
            $("[id*=tblstafflist] tbody").remove();
            //$("[id*=DropApp]").empty();
            //$("[id*=DropApp]").append("<option value=0>Select</option>");
            $("#dvProjectstaff").hide();
            $("#dvProjectstafftbl").hide();
            $("#dvProjectstafflbl").hide();
            $("#dvProjectlbl").show();
            $("#dvProjecttbl").show();
            $("[id*=lblCltPrj]").text("Staff");
            Get_Rolewise_client_project_departrment();
        });
        $("[id*=radio_staff_project]").on('change', function () {
            //$("[id*=dropRole]").val(0);
            //$("[id*=DropProject]").val(0);
            $("[id*=tbllist] tbody").remove();
            $("[id*=tblstafflist] tbody").remove();
            //$("[id*=DropApp]").empty();
            //$("[id*=DropApp]").append("<option value=0>Select</option>");
            $("#dvProjectstaff").show();
            $("#dvProjectstafftbl").show();
            $("#dvProjectstafflbl").show();
            $("#dvProjectlbl").hide();
            $("#dvProjecttbl").hide();
            Get_Rolewise_client_project_departrment();
        });
    });


    function unloadEvents()
    {
        var Type = 0;
        var x = document.getElementById("<%=radio_Project.ClientID%>");
        var y = document.getElementById("<%=radio_Staff.ClientID%>");
        var z = document.getElementById("<%=radio_staff_project.ClientID%>");
        if (x.checked) { Type = "Project" }
        if (y.checked) { Type = "Staff" }
        if (z.checked) { Type = "ProjectStaff" }
        Type = Type + "," + $("[id*=DropApp]").val() + "," + $("[id*=dropRole]").val();
        $("[id*=TypeStaffRole]").val(Type);
    }

    /////////////////////////*****************************Get staffnames by thair roles************************///////////////////////////////////////////

    function Get_Rolewise_project_staff() {
        $.ajax({
            type: "POST",
            url: "../Handler/Rolewise_Staff_Approver_Allocation.asmx/Get_Rolewise_project_staff",
            data: '{compid:' + $("[id*=hdncompid]").val() + ',ProjectId:' + $("[id*=DropProject]").val() + ',Role_Id:' + $("[id*=dropRole]").val() + ',Headid:' + $("[id*=DropApp]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                main_obj = jQuery.parseJSON(msg.d);

                $("[id*=tblstafflist] tbody").remove();


                $("#tblstafflist").empty();

                var tr = "";
                if (main_obj == null) {
                    $("#tblstafflist").append("<tr><td>No Record Found</td></tr>");
                }
                else {
                    if (main_obj.length == 0) {
                        $("#tblstafflist").append("<tr><td>No Record Found</td></tr>");
                    }
                    else {
                        $("#SelectAppPatern").val(main_obj[0].AppPattern);
                        for (var i = 0; i < main_obj.length; i++) {
                            vadfds = "";
                            if (parseFloat(main_obj[i].ischeck) > 0) {
                                vadfds = 'checked';
                            }
                            tr = $('<tr><td><input type="hidden" name="hdnStaffcode" value="' + main_obj[i].Id + '"><input type="checkbox" id="chkstaff" name="chkstaff" value="' + main_obj[i].Id + '"' + vadfds + ' />' + main_obj[i].Name + '</td></tr>');
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
        var r = $("[id*=dropRole]").val();
        if (r == undefined)
        {
            return;
        }
        if (r == '')
        {
            return;
        }
        var type = 0;
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
                    if (main_obj.length == 0) {
                        $("[id*=DropApp]").empty();
                        $("[id*=tblstafflist]").empty();
                        alert("No Record Found!!!");
                    }
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
            url: "../Handler/Rolewise_Staff_Approver_Allocation.asmx/Get_Rolewise_client_project_departrment",
            data: '{compid:' + $("[id*=hdncompid]").val() + ',Role_Id:' + $("[id*=dropRole]").val() + ',Type:"' + Type + '",Headid:' + $("[id*=DropApp]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                main_obj = jQuery.parseJSON(msg.d);

                var tr;
                $("[id*=tbllist] tbody").remove();
                $("[id*=DropProject]").empty();
                $("[id*=DropProject]").append("<option value=0>Select</option>");
                if (main_obj == null) {
                    $("#tbllist").append("<tr><td>No Record Found</td></tr>");
                }
                else {
                    if (main_obj.length == 0) {
                        $("#tbllist").append("<tr><td>No Record Found</td></tr>");
                    }
                    else {
                        $("#SelectAppPatern").val(main_obj[0].AppPattern);
                        for (var i = 0; i < main_obj.length; i++) {
                            vadfds = "";
                            if (parseFloat(main_obj[i].ischeck) > 0) {
                                vadfds = 'checked';
                            }
                            if (main_obj[i].Type == "Project" || main_obj[i].Type == "Staff") {
                                if (main_obj[i].Id > 0 && main_obj[i].Id != null) {
                                    tr = $('<tr><td><input type="hidden" name="hdnStaffcode" value="' + main_obj[i].Id + '">  <input type="checkbox" id="chkstaff" name="chkstaff" value="' + main_obj[i].Id + '"' + vadfds + ' />' + main_obj[i].Name + '</td></tr>');
                                } else {
                                    tr = $('<tr><td>' + main_obj[i].Name + '</td></tr>');
                                }
                                $("#tbllist").append(tr);
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
    function Get_Rolesnames() {
        $.ajax({
            type: "POST",
            url: "../Handler/Rolewise_Staff_Approver_Allocation.asmx/Get_Roles_Projectwise_Rolesnames",
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
        <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
            <asp:Label ID="Label18" runat="server" CssClass="Head1 labelChange" Text="Approver Allocation"></asp:Label>
        </div>
    </div><asp:HiddenField ID="hdncompid" runat="server" />
    <asp:HiddenField ID="TypeStaffRole" runat="server" />
    <asp:HiddenField ID="hdnAppPatern" runat="server" />
   
     <div class="tdMessageShow" style="border: 1px solid; display: none; font: Tahoma;
            font-size: 13px; text-transform: capitalize;">
            <table style="width:100%; text-align:center; height:30px; padding:5px;">
                <tr>
                    <td>
                        <asp:Label ID="lblAllMessage" Font-Bold="true" runat="server" Text="Label"></asp:Label>
                    </td>
                </tr>
            </table>
        </div>
<table style="width:100%; padding-top:15px;">
    <tr>
    <td style="width:80px;" ><asp:Label ID="Label2" Text="Select Role" CssClass="label"  runat="server"></asp:Label></td>
    <td style="width:110px;"><select id="dropRole" runat="server" style="width: 100px;" class="drop"><option value="0" selected="selected">Select</option></select> </td>
    <td style="width:120px;"><asp:Label ID="lblReportHead" Text="Staff Rolewise" CssClass="label"  runat="server"></asp:Label> </td>
    <td style="width:270px;"><select id="DropApp" runat="server" class="drop" style="width: 250px;"><option value="0" selected="selected">Select</option></select> </td>
    <td style="width:100px;"><asp:Label ID="Label3" Text="Approver By" CssClass="label"  runat="server"></asp:Label> </td>
    <td><asp:RadioButton ID="radio_Project" Checked="true" Text="Project"  Font-Bold="true" GroupName="r" runat="server" CssClass="labelChange" > </asp:RadioButton> </td>
    <td><asp:RadioButton ID="radio_Staff" runat="server" Text="Staff" Font-Bold="true" GroupName="r" CssClass="labelChange" > </asp:RadioButton> </td>
    <td><asp:RadioButton ID="radio_staff_project" runat="server" Font-Bold="true" Text="Staff Project" GroupName="r" CssClass="labelChange" > </asp:RadioButton></td>
    <td></td>

    <td><input id="btnsaveApp" type="button" value="Save" class="TbleBtns" /></td>
    <td><asp:ImageButton ID="btnExportToExcel"  ToolTip="Export To Excel" runat="server" ImageUrl="~/images/xls-icon.png"  onclick="btnExportToExcel_Click" OnClientClick="unloadEvents()"  /></td>
      </tr>
      <tr>
    <td></td>
    <td colspan="7"></td>
    <td >                          
        <div id="dvAppPatern">
            <asp:Label ID="Label1" Text="Approver Patern:" CssClass="label" runat="server"></asp:Label>
            <select id="SelectAppPatern" class="drop">
                <option value="Both">Both</option>
                <option value="Semi Approved">Semi Approved</option>
                <option value="Approved">Approved</option>
                <option value="Final">Final Approval</option>
            </select>
        </div> 
    </td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
      </tr>
    </table>

    <div style="width: 99.5%;">
        
        <div id="dv_StaffHod_Selection" runat="server">
            <table style="padding-left:18px; padding-top:10px;">
                
                <tr>
                    <td colspan="6">
                        <table>
                            <tr style="border-color: Gray; border-width: thick;">
                                <td style="border-color: Gray; border-width: thick;">
                                    <div id="dvProjectlbl">
                                        <asp:Label ID="lblCltPrj" Text="Client/Project:" CssClass="label" runat="server"></asp:Label>
                                        <input type="checkbox" id="chkACltPrj" />
                                    </div>

                                </td>
                                <td valign="top" style="padding-top:10px;">

                                </td >
                                <td id="tdchkStf" valign="top" style="padding-top:10px;">
                                    <div id="dvProjectstafflbl" style=" display:none; padding-top:10px;">
                                        <asp:Label ID="lblStaff" Text="Staff:" CssClass="label" runat="server"></asp:Label>
                                        <input type="checkbox" id="chkallStf" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td >
                                    <div id="dvProjectstaff" style=" display:none; height:400px; padding-top:10px;">
                                            <asp:Label ID="lblProject" CssClass="label" Text="&nbsp;&nbsp;&nbsp;&nbsp;Project" runat="server"></asp:Label>
                                            &nbsp;&nbsp;<select id="DropProject" runat="server" style="width: 470px;" class="drop">
                                                <option value="0" selected="selected">Select</option>
                                            </select>
                                    </div>
                                    <div  id="dvProjecttbl" style="padding-top:10px;">
                                        <asp:Panel ID="Panel6" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                        Height="400px" ScrollBars="Vertical" Style="overflow: auto; margin: 8px 0 0;
                                        float: left;" Width="470px">
                                        <table id="tbllist">
                                        </table>
                                        </asp:Panel>
                                    </div> 
                                </td>
                               
                                <td valign="top" style="padding-top:10px;">

                                </td>
                                <td id="tdPnlStf" valign="top">
                                    <div id="dvProjectstafftbl" style=" display:none; padding-top:10px;">
                                    <asp:Panel ID="Panel1" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                        Height="400px" ScrollBars="Vertical" Style="overflow: auto; margin: 8px 0 0;
                                        float: left;" Width="470px">
                                        <table id="tblstafflist">
                                        </table>
                                    </asp:Panel>  
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
