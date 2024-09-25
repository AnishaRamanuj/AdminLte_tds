<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Assign_Approver_Deptwise.ascx.cs" Inherits="controls_Assign_Approver_Deptwise" %>
<%@ Register Src="../controls/MyMessageBox.ascx" TagName="MyMessageBox" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script type="text/javascript" language="javascript">

    $(document).ready(function () {
        Get_Staff();

        ///////////////////////////////////////get roles by role names///////////////////////////////////////////

        $("[id*=DropApp]").live('change', function () {
            var s = $("[id*=DropApp]").val();
            Get_Rolewise_client_project_departrment(s);

        });

        ///////////////////////////////check All Projects

        $("[id*=chkACltPrj]").on('change', function () {
            var chka = $(this).is(':checked');
            if (chka) {
                $("input[name=chkstaff]").attr('checked', true);
            }
            else {
                $("input[name=chkstaff]").attr('checked', false);
            }
        });


        ////////////////////////////////////////////////save all Client Project department roles Aprrover //////////////////////////////////////////
        $("[id*=btnsaveApp]").on('click', function () {

            var hdnAstaff = "";
            var s = $("[id*=DropApp]").val();
            // Get all Client Project department
            $("input[name=chkstaff]:checked").each(function () {
                var chka = $(this).is(':checked');
                if (chka) {
                    hdnAstaff = $(this).val() + ',' + hdnAstaff;
                }
            });

            $.ajax({
                type: "POST",
                url: "../Handler/Rolewise_Staff_Approver_Allocation.asmx/Save_Assign_Approver",
                data: '{compid:' + $("[id*=hdncompid]").val() + ', staffid:' + s + ', sft:"' + hdnAstaff + '"}',
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



    function Get_Staff() {

        $.ajax({
            type: "POST",
            url: "../Handler/Rolewise_Staff_Approver_Allocation.asmx/Get_Staff",
            data: '{compid:' + $("[id*=hdncompid]").val() + '}',
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


    function Get_Rolewise_client_project_departrment(s) {
 
        $.ajax({
            type: "POST",
            url: "../Handler/Rolewise_Staff_Approver_Allocation.asmx/Get_Approver_Projects",
            data: '{compid:' + $("[id*=hdncompid]").val() + ',staffid:' + s + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                main_obj = jQuery.parseJSON(msg.d);

                var tr="";
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
                            if (parseFloat(main_obj[i].isCheck) > 0) {
                                vadfds = 'checked';
                            }

                            if (main_obj[i].JobId > 0 && main_obj[i].JobId != null) {
                                tr = $('<tr><td><input type="hidden" name="hdnStaffcode" value="' + main_obj[i].JobId + '">  <input type="checkbox" id="chkstaff" name="chkstaff" value="' + main_obj[i].JobId + '"' + vadfds + ' />' + main_obj[i].ClientName + '</td></tr>');
                            }
                            else {
                                tr = $('<tr><td>' + main_obj[i].ClientName + '</td></tr>');
                            }
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
    <asp:HiddenField ID="hdnAppPatern" runat="server" />
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
<table style="width:100%; padding-top:15px;">
    <tr>
    <td></td>
    
    <td style="width:350px;">
    <asp:Label ID="lblReportHead" Text="Approver:" CssClass="label"  runat="server"></asp:Label>
    <select id="DropApp" runat="server" class="drop" style="margin: 8px 0 0; width: 250px;"><option value="0" selected="selected">Select</option></select> </td>
   
    <td><input id="btnsaveApp" type="button" value="Save" class="TbleBtns" style="float:left;" /></td>
    
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
                                    <asp:Label ID="lblCltPrj" Text="Client/Project:" CssClass="label" runat="server"></asp:Label>
                                    <input type="checkbox" id="chkACltPrj" />
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
                               
                                <td valign="top" style="padding-top:10px;">
                                <div id="dvAppPatern">
                                &nbsp;</div> 
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