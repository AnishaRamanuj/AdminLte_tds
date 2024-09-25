<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddRoles.ascx.cs" Inherits="controls_AddRoles" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <link rel="stylesheet" href="../JsTree/Bootstrap_tree_style.css" />
    <link rel="stylesheet" href="../JsTree/jstree_style.min.css" />
    <script type="text/javascript" src="../JsTree/jstree.min.js"></script>
<script type="text/javascript">
    $(function () {
        GetRoleMaster(1, '');
        //////////on submit or press enter key event disabled
        $('form').bind("keypress", function (e) {
            if (e.keyCode == 13) {
                e.preventDefault();
                return false;
            }
        });

        ////////search Leave name
        $("[id*=txtSearchRoleName]").live('keyup', function (e) {
            if (e.keyCode == 13) {
                GetRoleMaster(1, $(this).val());
                return false;
            }
        });
        ////////////button add new Role Master
        $("[id*=btnAddNewRole]").live('click', function () {
            $("[id*=hdnRoleID]").val('0');
            $("[id*=btnSave]").attr('value', 'Save');
            $("[id*=txtRolename]").val('');
            $find("AddEditRoleMaster").show();
            $('.loader').hide();
            return false;
        });

        /////////////Button Save Roles
        $("[id*=btnSave]").live('click', function () {
            var rolename = $("[id*=txtRolename]").val();
            if (rolename =='') {
                alert('Kindly fill the Role Name!!!');
                return
            }

            $.ajax({
                type: "POST",
                url: "AddRoles.aspx/SaveRoleNames",
                data: '{compid:' + $("[id*=hdnCompanyId]").val() + ',rolename :"' + $("[id*=txtRolename]").val() + '",roleId:' + $("[id*=hdnRoleID]").val() + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d == "Success") {
                        SuccessShow("Save successfully........");
                        $("[id*=txtRolename]").val('');
                        GetRoleMaster(1, '');
                    }
                    else {
                        ErrorShow("On Save Error Or Role Name already exist !");
                    }
                },
                failure: OnError,
                error: OnError
            });
        });
    });

    function GetRoleMaster(PageIndex, rolesearch) {
        $.ajax({
            type: "POST",
            url: "AddRoles.aspx/GetRoleNames",
            data: '{pageIndex: ' + PageIndex + ',pageNewSize: ' + $("[id*=ddlpgsize]").val() + ',compid:' + $("[id*=hdnCompanyId]").val() + ',rolename :"' + rolesearch + '"}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess,
            failure: OnError,
            error: OnError
        });
    }
    var row;
    /////////////////bind leave master success funcation
    function OnSuccess(response) {
        var xmlDoc = $.parseXML(response.d);
        var xml = $(xmlDoc);
        var customers = xml.find("RoleMasterDetails");
        if (row == null) {
            row = $("[id*=gvRoleMaster] tr:last-child").clone(true);
        }
        $("[id*=gvRoleMaster] tr").not($("[id*=gvRoleMaster] tr:first-child")).remove();

        if (customers.length > 0) {
            var srno = 1;
            $.each(customers, function () {
                var customer = $(this);
                $("td", row).eq(0).html(srno);
                $("td", row).eq(1).html($(this).find("Rolename").text());
                $("td", row).eq(2).html("<img src='../images/edit.png' style='cursor:pointer; height:18px; width:18px;' id='Editbtn' onclick=editdata($(this)," + $(this).find("RoleID").text() + ") > <input type='hidden' id='hdnRoles' name='hdnRoles' values=" + $(this).find("RoleID").text() + ">");
                $("td", row).eq(3).html("<img src='../images/Delete.png' style='cursor:pointer; height:18px; width:18px;' onclick=deletedata(" + $(this).find("RoleID").text() + ") >");
                $("[id*=gvRoleMaster]").append(row);
                row = $("[id*=gvRoleMaster] tr:last-child").clone(true);
                srno = srno + 1;
            });
            var pager = xml.find("Pager");
            $(".Pager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(pager.find("PageIndex").text()),
                PageSize: parseInt(pager.find("PageSize").text()),
                RecordCount: parseInt(pager.find("RecordCount").text())
            });

        } else {
            var empty_row = row.clone(true);
            $("td:first-child", empty_row).attr("colspan", $("td", row).length);
            $("td:first-child", empty_row).removeClass("txtalign");
            $("td:first-child", empty_row).html("No records found !");
            $("td", empty_row).not($("td:first-child", empty_row)).remove();
            $("[id*=gvRoleMaster]").append(empty_row);
        }
        $('.gridloader').hide();
    };

    ////////////////ajax error
    function OnError(xhr, errorType, exception) {
        var responseText;
        var msg = "";
        try {
            responseText = jQuery.parseJSON(xhr.responseText);
            msg = msg + ("<div style='width:100%'><b>" + errorType + " " + exception + "</b></div>");
            msg = msg + ("<div style='width:100%'><u>Exception</u>:<br /><br />" + responseText.ExceptionType + "</div>");
            msg = msg + ("<div style='width:100%'><u>StackTrace</u>:<br /><br />" + responseText.StackTrace + "</div>");
            msg = msg + ("<div style='width:100%'><u>Message</u>:<br /><br />" + responseText.Message + "</div>");
        } catch (e) {
            responseText = xhr.responseText;
            msg = msg + (responseText);
        }
        ErrorShow(msg);
    }


    ///////////get data for edit
    function editdata(i,id) {
        var row = i.closest("tr");
        var rname = row.find('td:eq(1)').text();
        $("[id*=btnSave]").attr('value', 'Update');
        $('.loader').show();
        $("[id*=hdnRoleID]").val(id);
        $("[id*=txtSearchRoleName]").val('');
        $("[id*=lblpopup]").html('Edit Role');
        $("[id*=txtRolename]").val(rname);
        $find("AddEditRoleMaster").show();
        $('.loader').hide();
        
    }

    ////////////delete data from database
    function deletedata(id) {
        var Result = confirm("Are you sure want to delete ?");
        if (Result) {
            $.ajax({
                type: "POST",
                url: "AddRoles.aspx/DeleteRoleNames",
                data: '{compid:' + $("[id*=hdnCompanyId]").val() + ',roleid :"' + id + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d == "Delete") {
                        SuccessShow("Role Deleted Successfully");
                        GetRoleMaster(1, '');
                    }
                    else {
                        ErrorShow(response.d);
                    }
                },
                failure: OnError,
                error: OnError
            });
        }
    }


    function ErrorShow(msg) {
        $("[id*=lblAllMessage]").html(msg);
        setTimeout(function () { $('.tdMessageShow').slideDown('slow').delay(10000).slideUp('slow'); }, 500);
        $('.tdMessageShow').css('color', 'White');
        $('.tdMessageShow').css('background-color', 'red');

    }
    function SuccessShow(msg) {
        $("[id*=lblAllMessage]").html(msg);
        setTimeout(function () { $('.tdMessageShow').slideDown('slow').delay(5000).slideUp('slow'); }, 500);
        $('.tdMessageShow').css('color', '#4F8A10');
        $('.tdMessageShow').css('background-color', '#DFF2BF');
    }

    ///validetion given to the textbox
    function CountFrmTitle(field, max) {
        if (field.value.length > max) {
            field.value = field.value.substring(0, max);
            alert("You are exceeding the maximum limit");
        }
        else {
            field.value = field.value.replace(/[?\/#!$%\^\*;:{}=\_`~@"'+]/g, "");
            var count = max - field.value.length;
        }
    }

</script>
<style type="text/css">
    .txtalign
    {
        text-align: right !important;
    }
    .txtalignCenter
    {
        text-align: center !important;
    }
    .Pager span
    {
        color: #333;
        background-color: #F7F7F7;
        font-weight: bold;
        text-align: center;
        display: inline-block;
        width: 20px;
        margin-right: 3px;
        line-height: 150%;
        border: 1px solid #ccc;
    }
    .Pager a
    {
        text-align: center;
        display: inline-block;
        width: 20px;
        border: 1px solid #ccc;
        color: #fff;
        color: #333;
        margin-right: 3px;
        line-height: 150%;
        text-decoration: none;
    }
    #content
    {
        overflow: hidden !important;
    }
    
    .loader
    {
        display: none;
        position: absolute;
        left: 0px;
        top: 0px;
        width: 100%;
        height: 100%;
        z-index: 9999;
        background: rgba(0,0,0,0.3) url(../images/progress-indicator.gif) center center no-repeat;
    }
    #content2
    {
        overflow: hidden !important;
    }
    
    .gridloader
    {
        margin: auto;
        display: none;
        position: absolute;
        z-index: 9999;
        background: rgba(0,0,0,0.3) url(../images/progress-indicator.gif) center center no-repeat;
        overflow: hidden !important;
    }
    .highlight
    {
        text-transform: capitalize;
        background-color: #FFFFAF;
    }
    .allTimeSheettle
    {
        margin: 0px;
    }
    div.text_clear_button
    {
        background: url(../images/clear_cross.png);
        width: 11px;
        height: 11px;
        margin: 0;
        padding: 0;
        z-index: 2;
        position: absolute;
        cursor: pointer;
    }
    .jstree-proton .jstree-open > .jstree-ocl
    {
        background-position: -133px -5px !important;
    }
</style>
<div id="divtitl" class="testwhleinside">
    <div class="headerstyle11">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="Label2" runat="server" Text="Manage Role creation" CssClass="Head1 labelChange"></asp:Label></div>
    </div>
    <div style="width: 98%; padding-right: 2px; padding-left: 2px">
        <uc1:MessageControl ID="MessageControl2" runat="server" />
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
    </div>
    <div id="gridwithloader" style="width: 1160px; margin: 10px; padding-left: 10px;
        padding-right: 10px;">
        <table cellpadding="3" cellspacing="1" width="1160px" style="border-collapse: collapse;
            background: #F2F2F2; border: 1px solid #CCCCCC; margin-top: 5px; padding-left: 10px;
            padding-right: 10px; padding-top: 15px;">
            <tr>
                <td>
                    <b>Role Name<b>
                </td>
                <td>
                    <asp:TextBox ID="txtSearchRoleName" Width="200px" placeholder="Enter keyword and press enter..."
                        CssClass="texboxcls" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:Button ID="btnAddNewRole" runat="server" Text="Add New Role" CssClass="TbleBtns" />
                </td>
                <td width="52%">
                </td>
            </tr>
        </table>
        <div id="content2">
            <div class="gridloader">
            </div>
        </div>
        <asp:GridView ID="gvRoleMaster" runat="server" AutoGenerateColumns="false" CssClass="allTimeSheettle">
            <SelectedRowStyle CssClass="selectedstyle"></SelectedRowStyle>
            <RowStyle CssClass="rowstyle"></RowStyle>
            <HeaderStyle HorizontalAlign="Center" Height="32px" />
            <Columns>
                <asp:BoundField ItemStyle-CssClass="txtalign" DataField="RowNumber" HeaderText="Sr.No" />
                <asp:BoundField ItemStyle-Width="830px" ItemStyle-CssClass="gridcolstyle1 RoleName"
                    DataField="RoleName" HeaderText="Role Name" />
                <asp:BoundField ItemStyle-CssClass="gridcolstyle1 txtalignCenter" DataField="RoleID"
                    HeaderText="Edit" />
                <asp:BoundField ItemStyle-CssClass="gridcolstyle1 txtalignCenter" DataField="RoleID"
                    HeaderText="Delete" />
            </Columns>
        </asp:GridView>
        <table width="100%" style="border-collapse: collapse; margin-top: 0px; width: 100%;
            background: #F2F2F2; border: 1px solid #CCCCCC;">
            <tr>
                <td>
                    <table cellpadding="3" cellspacing="1" align="right">
                        <tr>
                            <td>
                                pg. size
                                        </td>
                            <td>
                                <asp:DropDownList ID="ddlpgsize" Style="cursor: pointer;" CssClass="texboxcls" runat="server">
                                    <asp:ListItem Selected="True">25</asp:ListItem>
                                    <asp:ListItem>50</asp:ListItem>
                                    <asp:ListItem>100</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <div class="Pager">
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <asp:HiddenField ID="hdnCompanyId" runat="server" />
    <asp:HiddenField ID="hidpermitionID" runat="server" />
    <cc1:ModalPopupExtender runat="server" ID="ModalPopupExtender2" BehaviorID="AddEditRoleMaster"
        TargetControlID="btnAddNewRole" PopupControlID="panel6" BackgroundCssClass="modalBackground"
        CancelControlID="btnCancel" OkControlID="imgBudgetdClose" DropShadow="false"
        RepositionMode="RepositionOnWindowScroll">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panel6" runat="server" Width="500px" BackColor="#FFFFFF">
        <div id="Div1" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff;
            font-weight: bold;">
            <div id="Div2" style="width: 90%; float: left; height: 20px; padding-left: 2%; padding-top: 1%">
                <asp:Label ID="lblpopup" runat="server" CssClass="subHead1"></asp:Label>
            </div>
            <div id="Div3" class="ModalCloseButton">
                <img alt="" src="../images/error.png" id="imgBudgetdClose" border="0" name="imgClose" />
            </div>
        </div>
        <asp:HiddenField ID="hdnRoleID" runat="server" />
        <fieldset>
            <table width="100%">
                <tr>
                    <td width="25%">
                        <b>Role Name :</b>
                    </td>
                    <td>
                        <asp:TextBox ID="txtRolename" Style="width: 90%" CssClass="texboxcls" runat="server"></asp:TextBox>
                    </td>
                    <td>
                    </td>
                </tr>
            </table>
            <table>
                <tr>
                    <td>
                        
                        <input type="button"  ID="btnSave" value="Save" class="TbleBtns" />
                    </td>
                    <td>
                        <asp:Button runat="server" ID="btnCancel" Text="Cancel" CssClass="TbleBtns" CausesValidation="false" />
                    </td>
                </tr>
            </table>
        </fieldset>
    </asp:Panel>
</div>
