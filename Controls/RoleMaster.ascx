<%@ Control Language="C#"  AutoEventWireup="true"  CodeFile="RoleMaster.ascx.cs" Inherits="controls_RoleMaster" %>

<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>

<script type="text/javascript">
    /////////////////pget load
    $(document).ready(function () {
        var PageSizen = 25;
        var pageIndex = $("[id*=hdnpageIndex]").val();
        $("[id*=hdnPages]").val(1);
        $("[id*=hdnICount]").val(1);
        totalPages: 1;
        visiblePages: 1;
        getRole(pageIndex, PageSizen);
        TotalCount(pageIndex, PageSizen);
        Paging();


        //         /////////////// Save Click
        $("#btnSave").click(function () {
            var adid = $("[id*=hdnroleid]").val()
            var AdO = $("#TxtAddons").val()
            if (AdO == "") {
                alert("Enter Add-Ons");
                return;
            }

            if (adid == "") {

                InsertAddOns();
            }
            else {
                UpdateAddOns();
                $("#myModal .close").click();
            }
        });


        //         /////////////// Delete Yes Click
        $("#btnYes").click(function () {
            DeleteRtype();
        });

        //         /////////////// Add Click
        $("#btnAdd").click(function () {

            $("[id*=hdnroleid]").val("");
            $("[id*=btnSave]").text('Save & Addnew');
            $("[id*=TxtAddons]").val("");
            $('#myModal').modal('show');
        });


        //         /////////////// Search Click
        $("#btnSrch").click(function () {
            getAddOns(1, 25);
        });

    });

    function getRole(pageIndex, PageSizen) {
        $('.loader2').show();
        $.ajax({
            type: "POST",
            url: "JobAdd.aspx/bindRole",
            data: '{pageIndex: ' + pageIndex + ',pageNewSize: ' + PageSizen + ',compid:' + $("[id*=hdnCompanyid]").val() + '}',
            dataType: 'json',

            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                ///////////parse json query
                var myList = jQuery.parseJSON(msg.d);
                var tr;
                var vadfds = "";
                debugger
                /////////staff budgeting
                var trRT = $("[id*=tblRate] tbody tr:last-child").clone(true);
                $("[id*=tblRate] tbody").remove();
                for (var i = 0; i < myList.length; i++) {
                    $("td", trRT).eq(0).html((parseFloat(i) + 1)); ///////sr no
                    $("td", trRT).eq(1).html(myList[i].RoleName + "<input type='hidden' name='hdnrlid' value='" + myList[i].RoleId + "'>");
                    $("td", trRT).eq(2).html("<input type='button' id='btnEdit' name='btnEdit'> <img src='~/images/edit.png'></img></input>");
                    $("td", trRT).eq(3).html("<input type='button' id='btnDelete' name='btnDelete'> <img src='~/images/Delete.png'></img></input>");

                    $("[id*=tblRate]").append(trRT);
                    trRT = $("[id*=tblRate] tbody tr:last-child").clone(true);
                }

                twocheck = twocheck + 1;
                if (twocheck == onecheck) {
                    $('.loader2').hide();
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

    ////////  Save
    function InsertAddOns() {
        try {

            $(".box .overlay").css('display', 'block');
            var c = $("[id*=hdnCompanyid]").val();
            var r = $("#TxtAddons").val();
            var a = $("#TxtAmt").val();
            $.ajax({
                type: "POST",
                url: "Handlers/AddOns.asmx/InsertAddOns",
                data: '{compid:' + $("[id*=hdnCompanyid]").val() + ',addons :"' + $("#TxtAddons").val() + '",amt :' + a + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var myList = jQuery.parseJSON(response.d);
                    if (parseFloat(myList[0].AddOns_ID) > 0) {

                        getAddOns(1, 25);
                        TotalCount(pageIndex, PageSizen);
                        Paging();
                        SuccessShow("Saved Successfully.....");
                        ClearAll();
                    }
                    else if (parseFloat(myList[0].AddOns_ID) == -2)
                    { ErrorShow("Duplicate Entry"); }
                    else { ErrorShow("Error Occoured While Saving"); }
                    $(".box .overlay").css('display', 'none');
                },
                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
            $(".box .overlay").css('display', 'none');
        } catch (e) {
            alert(e.get_Description());
        }
    }

    function ShowEdit(i) {
        var row = i.closest("tr");
        var adid = row.find("input[name=hdnadid]").val();
        var Rtname = row.find("input[name=hdnadname]").val();
        var amt = row.find("input[name=hdnadamt]").val();
        $("[id*=btnSave]").text('Save');
        $("[id*=hdnaddonsid]").val(adid);

        $("[id*=TxtAddons]").val(Rtname);
        $("[id*=TxtAmt]").val(amt);
        $('#myModal').modal('show');
    }

    function ShowDelete(i) {
        var row = i.closest("tr");
        var adid = row.find("input[name=hdnadid]").val();
        $("[id*=hdndeleteId]").val(adid);
        $('#myDelete').modal('show');
    }

    function ClearAll() {
        $("#TxtSearch").val('');
        $("#TxtAddons").val('');
        $("[id*=TxtAmt]").val('');
    }

    function isNumber(evt) {
        evt = (evt) ? evt : window.event;
        var charCode = (evt.which) ? evt.which : evt.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        return true;
    }
    ////////  Save
    function UpdateAddOns() {
        try {
            $(".box .overlay").css('display', 'block');
            var aid = $("[id*=hdnaddonsid]").val();
            var c = $("[id*=hdnCompanyid]").val();
            var r = $("#TxtAddons").val();
            var a = $("#TxtAmt").val();

            $.ajax({
                type: "POST",
                url: "Handlers/AddOns.asmx/UpdateAddOns",
                data: '{addonsid: ' + aid + ',addons: "' + r + '",compid:' + c + ',amt :' + a + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {

                    var myList = jQuery.parseJSON(response.d);
                    debugger
                    if (parseFloat(myList[0].AddOns_ID) > 0) {
                        getAddOns(1, 25);
                        SuccessShow("Saved Successfully.....");
                        ClearAll();
                    }
                    else if (parseFloat(myList[0].AddOns_ID) == -2)
                    { ErrorShow("Duplicate Entry"); }
                    else {
                        ErrorShow("Error Occoured While Saving");
                    }
                    $("[id*=hdnaddonsid]").val("");
                    $(".box .overlay").css('display', 'none');

                },

                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }

            });
            $(".box .overlay").css('display', 'none');
        } catch (e) {
            alert(e.get_Description());
        }
    }


    ////////  Delete
    function DeleteRtype() {
        try {
            $.ajax({
                type: "POST",
                url: "Handlers/AddOns.asmx/DeleteAddOns",
                data: '{addonsid: ' + $("[id*=hdndeleteId]").val() + ',addonsname: "' + $("#TxtAddons").val() + '",compid:' + $("[id*=hdnCompanyid]").val() + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var myList = jQuery.parseJSON(response.d);

                    if (parseFloat(myList[0].AddOns_ID) > 0) {
                        getAddOns(1, 25);
                        SuccessShow("Deleted Successfully.....");
                    }

                    else {
                        ErrorShow("Error Occoured While Deleting");
                    }
                    $("[id*=hdndeleteId]").val("");
                    $(".box .overlay").css('display', 'none');
                },

                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });

        } catch (e) {
            alert(e.get_Description());
        }
        $(".box .overlay").css('display', 'none');
    }


    ////////  GetTotalCount
    function TotalCount(pageIndex, PageSizen) {
        try {
            $(".box .overlay").css('display', 'block');
            var srch = $("#TxtSearch").val();
            if (srch == "") {
                srch = "";
            }
            var calala = $.ajax({
                type: "POST",
                url: "Handlers/AddOns.asmx/GetTotalCount",
                data: '{compid:' + $("[id*=hdnCompanyid]").val() + ',srch:"' + srch + '"}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {

                    var myList = jQuery.parseJSON(msg.d);
                    if (parseFloat(myList[0].TCount) > 0) {
                        var iCount = myList[0].TCount
                        $("[id*=hdnICount]").val(iCount);
                        if (iCount > 25) {
                            var iPages = parseFloat(iCount) / 25;
                        }
                        else {
                            iPages = 1;
                        }
                        $("[id*=hdnPages]").val(iPages);

                    }
                    $(".box .overlay").css('display', 'none');
                },
                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
            $(".box .overlay").css('display', 'none');
        } catch (e) {
            alert(e.get_Description());
        }
    }
</script>
<div class="divstyle" style="height: auto">

    <asp:HiddenField ID="hdnpageIndex" runat="server" />
    <asp:HiddenField ID="hdnICount" runat="server" />
    <asp:HiddenField ID="hdnPages" runat="server" />
    <asp:HiddenField ID="hdndeleteId" runat="server" />
   <uc1:MessageControl ID="MessageControl1" runat="server" />
    <div class="headerpage">
        <div class="headerstyle1_page">

            <asp:Label ID="Label18" runat="server" CssClass="Head1 labelChange" Text="Manage Roles"></asp:Label>
        </div>
    </div>
    <div id="Div1" runat="server" class="masterdiv1a">
        <div style="float: left">
            <uc1:MessageControl ID="MessageControl2" runat="server" />
            <div class="serachJob" style="float: left">
                <div style="float: left; width: 100%; padding-bottom: 5px; overflow: auto;" id="searchdesg"
                    runat="server">
                    <asp:Label ID="Label21" runat="server" CssClass="LabelFontStyle labelChange" Text="Search Roles"></asp:Label>
                    &nbsp;&nbsp;
                    <input ID="txtdesgsearch" runat="server" class="txtbox" style="Width:250px; font:Verdana; font-size:8pt;"></input>
                    &nbsp;<asp:Button ID="btnSrch" runat="server" CssClass="TbleBtns TbleBtnsPading" Text="Search" />
                       
                    &nbsp;&nbsp;<asp:Button ID="BtnAdd" runat="server" CssClass="TbleBtns TbleBtnsPading labelChange" Text="Add Roles" />
                </div>
            </div>
            <div class="tableNewadd">
                    <table  cellspacing="0" class="norecordTble" border="1" id="tblRate" style="border-collapse: collapse;">
                        <thead>
                            <tr>
                                <th class="grdheader">
                                    SrNo
                                </th>
                                <th class="grdheader">
                                    <label class="labelChange">Role Name</label>   
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
                            <tr style="color: rgb(0, 0, 102); height: 15px;">
                                <td>
                                </td>
                                <td>
                                </td>
                                <td style="width: 50%;">
                                </td>
                                <td  style="width: 50%;">
                                </td>
                            </tr>
                        </tbody>
                    </table>
            </div>
            
             
        </div> 

        <asp:Button Style="display: none" ID="hideModalPopup" runat="server">
        </asp:Button><br />
        
        <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="modalBackground" CancelControlID="btnCancel" 
            BehaviorID="programmaticModalPopupOrginalBehavior" DropShadow="False" PopupControlID="panel10"
                RepositionMode="RepositionOnWindowScroll" TargetControlID="hideModalPopup">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="panel1" runat="server" Width="400px" BackColor="#FFFFFF" DefaultButton="BtnSubmit" 
        Height="138px" BorderColor="White" BorderStyle="None" CssClass="RoundpanelNarr RoundpanelNarrExtra">
	        <h1 class="Ttlepopu labelChange">Add Roles</h1>
            <asp:HiddenField id="hdnroleid" runat="server" />
        <div>
                       
            <table class="addDesignatnation" >
            <tr>
            <td class="style4" >
                <asp:Label ID="Label1" runat="server" Text="Roles"  CssClass="LabelFontStyle labelChange"></asp:Label>:
            </td>
            <td style="width: 250px;">
                    <asp:TextBox ID="Txt2" runat="server" CssClass="txtbox" style="273px !important; "></asp:TextBox>
			        <span class="errlabelstyle" style="color:Red;">*</span>
            </td>
            </tr>

                          
            <tr>
			<td class="style4" >
                          
            </td>
            <td  class="style2">
                <input type ="button"  ID="BtnSubmit" runat="server" class="TbleBtns TbleBtnsPading"  text="Save"  /> 
 
                <input type ="button" ID="btnCancel" runat="server" class="TbleBtns TbleBtnsPading"  text="Cancel"  />
 
                <div id="Div22" align="right">
                                        
                </div>
            </td>
            </tr>

            </table>
                        
         </div>
         </asp:Panel>
    </div>


</div> 
