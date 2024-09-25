<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddAssignments.ascx.cs" Inherits="controls_AddAssignments" %>

<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<script src="../jquery/dist/jquery.contextMenu.js" type="text/javascript"></script>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>
<link href="../jquery/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" language="javascript">
    var main_obj = [];
    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        $("[id*=hdnEditAid]").val('0');
        $("[id*=hdnPages]").val(1);
        var PageSize = 25;
        var pageIndex = $("[id*=hdnpageIndex]").val();
        var compid = $("[id*=hdnCompany_id]").val();
        bind_Grd(compid, 1, '');
        var aid = 0;
        GetDept(aid, compid);
        //GetJob(aid, compid);


        $("[id*= btnAdd]").live('click', function () {
            $("[id*=drpDept]").val(0);
            $("[id*= Txt2]").val('');
            $("[id*=drpDept]").attr("disabled", false);
            var compid = $("[id*=hdnCompany_id]").val();
            $find("ListModalPopupBehavior").show();
            if (main_obj.length > 0) {
                $("#tabsLoader").css('display', 'block');
                CreateJobnametable(main_obj);
            } else {
                GetJob(0, compid)
            }
           
            
        });

        $("[id*= BtnN]").live('click', function () {
            $find("ListDeletePopup").hide();
        });

        $("[id*= chkAll]").live('click', function () {
            $('.loader').show();
            var chkprop = $(this).is(':checked');
            setTimeout(function () {
                $("input[name=chkJob]").each(function () {
                    if (chkprop)
                    { $(this).attr('checked', 'checked'); }
                    else
                    { $(this).removeAttr('checked'); }
                });
                $("input[name=chkJob]").each(function () {
                    var jobrow = $(this).closest("tr");
                    if (chkprop) {
                        $(this).attr('checked', 'checked'); //sftrow.css('display', 'block');
                    }
                    else {
                        $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                    }
                });
                $('.loader').hide();
            }, 1000);
        });


        $("[id*= BtnY]").live('click', function () {
            var newDate = new Date();
            $find("ListDeletePopup").hide();
            var compid = $("[id*=hdnCompany_id]").val();
            var aid = $("[id*=hdnDeleteid]").val();
            var ip = $("[id*= hdnIP]").val();
            var usr = $("[id*= hdnName]").val();
            var uT = $("[id*= hdnUser]").val();
            $.ajax({
                type: "POST",
                url: "../Handler/wsAssignment.asmx/Delete_Assignment",
                data: '{compid:' + compid + ',aid:' + aid + ',ip:"' + ip + '",usr:"' + usr + '", ut:"' + uT + '", dt: "' + newDate + '" }',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList.length > 0) {

                        var aid = myList[0].Assign_Id;
                        $("[id*=hdnDeleteid]").val('0');

                        var aid = myList[0].Assign_Id;
                        if (parseFloat(aid) == 0) {
                            alert(myList[0].messg);
                        }
                        else {
                            $("[id*=hdnDeleteid]").val(0);

                            alert('Record deleted successfully');
                            bind_Grd(compid, 1, '');
                        }
                    }
                },
                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Job Assign To This Assignment Cant Delete');
                }
            });
        });

        $("[id*= BtnSubmit]").live('click', function () {
            var d = $("[id*=drpDept]").val();
            var a = $("[id*=Txt2]").val();
            var compid = $("[id*=hdnCompany_id]").val();
            var aid = $("[id*=hdnEditAid]").val();
            if (a == '') {
                alert("Assignment Name Must be filled !!!");
            } else {
                if (aid == "0") {
                    insert_Assign(compid, a, d);
                }
                else {
                    update_Assign(compid, a, d, aid);
                }
            }
        });

        $("[id*= btnCancel]").live('click', function () {
            $find("ListModalPopupBehavior").hide();
            $(".modalganesh").hide();
        });

        $("[id*= btnAsearch]").live('click', function () {
            var srch = $("[id*=txtsearch]").val();
            bind_Grd(compid, 1, srch);
        });
    });



    function bind_Grd(compid, pageIndex, srch) {
        $.ajax({
            type: "POST",
            url: "../Handler/wsAssignment.asmx/BindGrd",
            data: '{compid:' + compid + ',p:' + pageIndex + ', srch:"' + srch + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: OnSuccess,
            failure: OnError,
            error: OnError
        });
    }


    function OnSuccess(response) {

        var xmlDoc = $.parseXML(response.d);
        var xml = $(xmlDoc);
        var customers = xml.find("attc");

        $("[id*=tbl_Assg] tbody").remove();
        var trHTML = '';
        if (customers.length > 0) {
            var srno = 1;
            $.each(customers, function () {
                var customer = $(this);
                trHTML += '<tr>';
                trHTML += "<td width='80px' style='text-align: center' >" + $(this).find("Sino").text() + "<input type='hidden' id='hdnAid' value='" + $(this).find("Assign_Id").text() + "' name='hdnAid'></td>";
                trHTML += "<td width='450px' style='text-align: left'  >" + $(this).find("Assign_Name").text() + "<input type='hidden' id='hdnAname' value='" + $(this).find("Assign_Name").text() + "' name='hdnAname'></td>";
                trHTML += "<td width='300px' style='text-align: left'  >" + $(this).find("DepartmentName").text() + "</td>";
                var roleedit = $("[id*=hdnedit]").val();
                if (roleedit == 'False') { }
                else {
                    trHTML += "<td width='80px'><img src='../images/edit.png' style='cursor:pointer; height:18px; width:18px;' onclick='Edit_Assign($(this))' id='btnEdit' name='btnEdit'></td>"
                }
                var roledelete = $("[id*=hdndelete]").val();
                if (roledelete == 'False') { }
                else {
                    trHTML += "<td width='80px'><img src='../images/delete.png' style='cursor:pointer; height:18px; width:18px;' onclick='Delete_Assign($(this))' id='btnHDel' name='btnHDel'></td>"
                }
                trHTML += '</tr>';
            });
            $("[id*=tbl_Assg]").append(trHTML);

            $(".modalganesh").hide();
            var pager = xml.find("attc1");
            var RecordCount = parseInt(pager.find("RecordCount").text());
            Pager(RecordCount);
        }
        else {
            var RecordCount = 0;
            Pager(RecordCount);
        }
    };


    function Pager(RecordCount) {
        $(".Pager").ASPSnippets_Pager({
            ActiveCssClass: "current",
            PagerCssClass: "pager",
            PageIndex: parseInt($("[id*=hdnPages]").val()),
            PageSize: parseInt(25),
            RecordCount: parseInt(RecordCount)
        });

        ////pagging changed bind LeaveMater with new page index
        $(".Pager .page").on("click", function () {
            $("[id*=hdnPages]").val($(this).attr('page'));
            var compid = $("[id*=hdnCompany_id]").val();
            bind_Grd(compid, ($(this).attr('page')), '')
        });
    }

    function Edit_Assign(i) {
        var row = i.closest("tr");
        var aid = row.find("input[name=hdnAid]").val()
        $("[id*= hdnEditAid]").val(aid);
        $("[id*= Txt2]").val(row.find("input[name=hdnAname]").val())
        var compid = $("[id*=hdnCompany_id]").val();
        $("[id*=drpDept]").attr("disabled", true);
        GetDept(aid, compid);
        GetJob(aid, compid);
        $find("ListModalPopupBehavior").show();
    }

    function Delete_Assign(i) {
        var row = i.closest("tr");
        var aid = row.find("input[name=hdnAid]").val()
        $("[id*= hdnDeleteid]").val(aid);
        $("[id*= Txt2]").val(row.find("input[name=hdnAname]").html())
        var compid = $("[id*=hdnCompany_id]").val();
        $find("ListDeletePopup").show();
    }

    function GetDept(aid, compid) {
        $.ajax({
            type: "POST",
            url: "../Handler/wsAssignment.asmx/BindDept",
            data: '{compid:' + compid + ',aid:' + aid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                $("[id*=drpDept]").empty();
                for (var i = 0; i < myList.length; i++) {

                    $('#<%= drpDept.ClientID %>').append("<option value='" + myList[i].DeptId + "'>" + myList[i].DepartmentName + "</option>");
                    if (parseFloat(myList[i].ischecked) > 0) {
                        $("[id*=drpDept]").val(myList[i].DeptId);
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

    function GetJob(aid, compid) {
        try {
            $("#tabsLoader").css('display', 'block');
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsAssignment.asmx/BindJob",
                data: '{compid:' + compid + ',aid:' + aid + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (aid == '0') {
                        main_obj = myList;
                    }
                    CreateJobnametable(myList);
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

    }

    function CreateJobnametable(myList) {
        var tr;
        var vadfds = "";
        $("[id*=tblJob] tbody").remove();
        for (var i = 0; i < myList.length; i++) {
            vadfds = "";
            if (parseFloat(myList[i].ischecked) > 0) {
                vadfds = 'checked';
            }
            tr = $('<tr><td> <input type="hidden" name="hdnmjid" value="' + myList[i].mJobID + '"> <input type="checkbox" name="chkJob" value="' + myList[i].mJobID + '"' + vadfds + ' />' + myList[i].MJobName + '</td></tr>');
            $('#tblJob').append(tr);

            $("#tabsLoader").css('display', 'none');
        }
        $("#tabsLoader").css('display', 'none');
    }

    function insert_Assign(compid, a, d) {

        var Alljid = '';
        $("input[name=chkJob]").each(function () {
            var chkprop = $(this).is(':checked');
            if (chkprop) {
                var srow = $(this).closest("tr");
                var jid = srow.find("input[name=hdnmjid]").val();
                Alljid = jid + ',' + Alljid;
            }
        });

        $.ajax({
            type: "POST",
            url: "../Handler/wsAssignment.asmx/Insert_Assignment",
            data: '{compid:"' + compid + '",a:"' + a + '",d:"' + d + '", jid:"' + Alljid + '"}',
            //            data: '{compid:' + compid + ',a:' + a + ',d:' + d + ', jid:"' + Alljid + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length > 0) {
                    if (myList[0].Assign_Id > 0) {
                        var aid = myList[0].Assign_Id;
                        ClearALL();
                        $find("ListModalPopupBehavior").hide();
                        alert('Record saved successfully');
                        bind_Grd(compid, 1, '');
                    }
                    else {
                        alert('Error!!!Duplication entry not allowed.');
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


    function update_Assign(compid, a, d, aid) {

        var Alljid = '';
        $("input[name=chkJob]").each(function () {
            var chkprop = $(this).is(':checked');
            if (chkprop) {
                var srow = $(this).closest("tr");
                var jid = srow.find("input[name=hdnmjid]").val();
                Alljid = jid + ',' + Alljid;
            }
        });

        $.ajax({
            type: "POST",
            url: "../Handler/wsAssignment.asmx/Update_Assignment",
            data: '{compid:"' + compid + '",a:"' + a + '",d:"' + d + '", aid:"' + aid + '", jid:"' + Alljid + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length > 0) {
                    if (myList[0].Assign_Id > 0) {
                        var aid = myList[0].Assign_Id;
                        $("[id*=hdnEditAid]").val(0);
                        ClearALL();
                        $find("ListModalPopupBehavior").hide();
                        alert('Record update successfully');
                        bind_Grd(compid, 1, '');
                    }
                    else {
                        alert('Error!!!Duplication entry not allowed.');
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
    //    ////////////////grid loader function for set height and width of gird size to loader div
    //    function ShowGridLoader() {
    //        var he = $(".gridwithloader").height();
    //        var wi = $(".gridwithloader").width();
    //        $('.gridloader').css("height", he);
    //        $('.gridloader').css("width", wi);
    //        $('.gridloader').show();
    //    }
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

    function ClearALL() {
        $("[id*=drpDept]").val(0);
        $("[id*= Txt2]").val('');
        $("[id*=hdnEditAid]").val(0);
        $("input[name=chkJob]").each(function () {
            var parrentchk = $(this).find('input[type=checkbox]').is(':checked');
            if (parrentchk == true) {
                $(this).removeAttr('checked');
            }

        });
    }

    ///Vlidetion given for textbox
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
        /***************************tab loader css*****************************************************/
    #tabsLoader {
        position: absolute;
        z-index: 9999999;
        height: 448px;
        width: 975px;
        background-color: Black;
        filter: alpha(opacity=40);
        opacity: 0.6;
        -moz-opacity: 0.8;
    }

    /*----- Tabs -----*/
    .tabs {
        width: 100%;
        display: inline-block;
        border: 1px;
    }

    .tab-links {
        margin: 0px;
        padding: 0px;
    }

        /* Clearfix */
        .tab-links:after {
            display: block;
            clear: both;
            content: '';
        }

        .tab-links li {
            margin: 0px 3px;
            float: left;
            list-style: none;
        }

        .tab-links a {
            padding: 9px 15px;
            display: inline-block;
            border-radius: 6px 6px 0px 0px;
            background: #f2f2f2;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            color: #474747;
            transition: all linear 0.15s;
        }

            .tab-links a:hover {
                background: #1464F4;
                text-decoration: none;
                color: #fff;
                border: 1px;
            }

    li.active a, li.active a:hover {
        background: #1464F4;
        color: #fff;
    }

    /*----- Content of Tabs -----*/
    .tab-content {
        padding: 15px;
        border-radius: 3px; /*box-shadow:-1px 1px 1px rgba(0,0,0,0.15); */ /*background:#fff; */
        border: 1px solid #1464F4;
        min-height: 300px;
    }

    .tab {
        display: none;
    }

        .tab.active {
            display: block;
        }



    .modalBackground {
        background-color: Gray;
        filter: alpha(opacity=70);
        opacity: 0.7;
    }

    .Button {
        font-family: Verdana,Arial,Helvetica,sans-serif;
        font-size: 11px;
        font-weight: 600;
        height: 25px;
        color: #1464F4;
        -webkit-border-radius: 4px;
        -moz-border-radius: 4px;
        border-radius: 4px;
        cursor: pointer;
    }

    .Head1 {
        font-size: 14px;
        font-family: Verdana,Arial,Helvetica,sans-serif;
        color: #3D80E8;
        font-weight: bold;
        overflow: hidden;
        border-bottom-color: White;
    }

    .divspace {
        height: 20px;
    }

    .headerstyle1_page {
        border-bottom: 1px solid #55A0FF;
        float: left;
        margin: 0 0 10px;
        overflow: hidden;
    }

    .headerpage {
        height: 23px;
    }

    .error {
        background-color: #FF0000;
        background-image: none !important;
        color: #FFFFFF !important;
        margin: 0 0 10px;
        width: 95% !important;
    }

    .property_tab {
    }

    .property_tab {
    }

    .drp {
        font-family: Verdana,Arial,Helvetica,sans-serif;
        font-size: 12px;
        -webkit-border-radius: 3px;
        -moz-border-radius: 3px;
        border-radius: 3px;
        width: 80px;
    }

    .EditJobTble2 {
    }

        .EditJobTble2 td {
        }

            .EditJobTble2 td select {
                border: 1px solid #BCBCBC;
                border-radius: 5px;
                height: auto !important;
                padding: 3px 5px;
                font-size: 12px;
                width: 1000px;
            }

    .Pager b {
        margin-top: 2px;
        float: left;
    }

    .Pager span {
        text-align: center;
        display: inline-block;
        width: 20px;
        margin-right: 3px;
        line-height: 150%;
        border: 1px solid #BCBCBC;
    }

    .Pager a {
        text-align: center;
        display: inline-block;
        width: 20px;
        background-color: #BCBCBC;
        color: #fff;
        border: 1px solid #BCBCBC;
        margin-right: 3px;
        line-height: 150%;
        text-decoration: none;
    }

    .cssButton
{
    cursor: pointer; /*background-image: url(../Images/ButtonBG1.png);*/
    background-color: #d3d3d3;
    border: 0px;
    padding: 4px 15px 4px 15px;
    color: Black;
    border: 1px solid #c4c5c6;
    border-radius: 3px;
    font: bold 12px verdana, arial, "Trebuchet MS" , sans-serif;
    text-decoration: none;
    opacity: 0.8;

}
.cssButton:focus
{
    background-color: #69b506;
    border: 1px solid #3f6b03;
    color: White;
    opacity: 0.8;
}
.cssButton:hover
{
    background-color: #69b506;
    border: 1px solid #3f6b03;
    color: White;
    opacity: 0.8;
}
.cssPageTitle2
{
    font: bold 14px verdana, arial, "Trebuchet MS" , sans-serif;
    /*border-bottom: 2px solid #0b9322;*/
    padding: 7px;
    color: #0b9322;
}
 .cssPageTitle
{
    font: bold 14px verdana, arial, "Trebuchet MS" , sans-serif;
    border-bottom: 2px solid #0b9322;
   
    color: #0b9322;
}
</style>


<div class="divstyle" style="height: auto">
    <table style="width: 100%" class="cssPageTitle">
        <tr>
            <td class="cssPageTitle2">
                <asp:Label ID="Label18" runat="server" style="margin-left:10px;" Text="Manage Assignments"></asp:Label>
            </td>           
        </tr>
    </table>

    <div id="Div8" runat="server" class="masterdiv1a">
        <div style="width: 100%; float: left;">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
            <asp:HiddenField ID="hdnCompany_id" runat="server" />
            <asp:HiddenField ID="hdnpageIndex" runat="server" />
            <asp:HiddenField ID="hdnPages" runat="server" />
            <asp:HiddenField ID="hdnIP" runat="server" />
            <asp:HiddenField ID="hdnName" runat="server" />
            <asp:HiddenField ID="hdnUser" runat="server" />
            <div>
                <asp:Panel ID="Panel5" runat="server">
                    <div>
                        <div id="searchloc" runat="server">
                            <div style="float: left; width: 100%; margin: 10px; padding-bottom: 5px; overflow: auto;" class="serachJob">
                                <asp:Label ID="Label26" runat="server" Text="Search Assignments" CssClass="LabelFontStyle labelChange"></asp:Label>&nbsp;&nbsp;

                                <asp:TextBox ID="txtsearch" runat="server" CssClass="txtbox"></asp:TextBox>
                                &nbsp;<input id="btnAsearch" type="button" value="Search" class="cssButton" />

                                <input id="btnAdd" type="button" class="cssButton labelChange"
                                    value="Add Assignments" runat="server" />

                            </div>
                        </div>
                    </div>
                </asp:Panel>
            </div>

        </div>

        <div class="divfloatleftn" style="float: left; margin: 10px; padding-left: 5px; width: 1175px; padding-right: 15px;">
            <asp:Panel ID="Panel1" runat="server">
                <table id="tbl_Assg" width="1175px" border="1px" class="norecordTble" style="border-collapse: collapse; padding-left: 120px;">
                    <thead>
                        <tr>
                            <th class="grdheader" style="text-align: center">Sr.No
                            </th>
                            <th class="grdheader">Assignments
                            </th>
                            <th class="grdheader">Departments
                            </th>
                            <th class="grdheader" id="thedit" runat="server">Edit
                            </th>
                            <th class="grdheader" id="thdelete" runat="server">Delete
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr style="color: rgb(0, 0, 102); height: 15px;">

                            <td width="50px" style="text-align: right"></td>
                            <td width="450px" style="text-align: right"></td>
                            <td width="300px" style="text-align: right"></td>
                            <td width="80px"></td>
                            <td width="80px"></td>
                        </tr>
                    </tbody>
                </table>

                <table id="tblPager" style="border: 1px solid #BCBCBC; border-bottom: none; background-color: rgba(219,219,219,0.54); text-align: right; width:1175px;"
                    cellpadding="2" cellspacing="0" width="1100px">
                    <tr>
                        <td>
                            <div class="Pager">
                            </div>
                        </td>
                    </tr>
                </table>
            </asp:Panel>


            <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server"></asp:Button><br />

            <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" BackgroundCssClass="modalBackground" CancelControlID="btnCancel"
                BehaviorID="ListModalPopupBehavior" DropShadow="False" PopupControlID="panel10"
                RepositionMode="RepositionOnWindowScroll" TargetControlID="hideModalPopupViaClientOrginal2">
            </cc1:ModalPopupExtender>
            <asp:Panel ID="panel10" runat="server" Width="1000px" Height="560px" BackColor="#FFFFFF" CssClass="RoundpanelNarr1">
                <div class="Ttlepopu">
                    <label class="labelChange">Add Assignments </label>
                    <asp:HiddenField ID="hdnEditAid" runat="server" />
                </div>
                <table class="addDesignatnation" style="padding-left: 5px; padding-right: 5px;">

                    <tr>
                        <td class="style7" style="width: 20px;">
                            <asp:Label ID="Label1" runat="server" ForeColor="Black" Text="Assignments" CssClass="LabelFontStyle labelChange"></asp:Label>
                        </td>
                        <td style="width: 250px">
                            <asp:TextBox ID="Txt2" runat="server" CssClass="txtbox" TabIndex="0" Width="250px"></asp:TextBox>
                        </td>
                        <td>
                            <asp:Label ID="Label3" runat="server" ForeColor="Black" Text="Department" Font-Bold="true" CssClass="LabelFontStyle labelChange"></asp:Label>
                        </td>
                        <td style="width: 250px">
                            <asp:DropDownList ID="drpDept" runat="server" CssClass="DropDown" TabIndex="0" Width="250px"></asp:DropDownList>
                        </td>
                    </tr>
                </table>
                <fieldset style="border: solid 1px black; padding: 10px; padding-top: 5px; height: 400px; overflow: scroll;">
                    <legend style="font-weight: bold; color: Red;" cssclass="LabelFontStyle labelChange">Activity List</legend>
                    <label class="labelChange">Select All </label>
                    <input id="chkAll" value="Select All" type="checkbox" />
                           <div id="tabsLoader">
                        <div class="centerganesh" style="margin: 172px auto;">
                            <img alt="loadting" src="../images/progress-indicator.gif">
                        </div>
                    </div>
                    <table style="overflow: scroll; height: 100px; width: 806px;">
                        <tr>
                            <td style="vertical-align: top;">
                                <table id="tblJob" width="880px">
                                </table>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <div class="space"></div>



                <div class="popup">
                </div>
                <div class="space"></div>
                <div class="noteText" style="padding-left:20px;">
                    Notes:
            <div class="txtboxNewError">
                <span class="labelstyle">Edit Mode, Existing selected Activity will not be removed</span>
                    </div>
                </div>

                <div class="space" style="padding-top: 10px;"></div>
                <div style="padding-left:20px;">
                <input id="BtnSubmit" type="button" class="cssButton" value="Save" />
                &nbsp;
                            <asp:Button ID="btnCancel" runat="server" CssClass="cssButton" Text="Cancel" />
                    </div>
            </asp:Panel>


            <asp:Button Style="display: none" ID="Button1" runat="server"></asp:Button><br />

            <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="modalBackground" CancelControlID="BtnN"
                BehaviorID="ListDeletePopup" DropShadow="False" PopupControlID="panel2"
                RepositionMode="RepositionOnWindowScroll" TargetControlID="Button1">
            </cc1:ModalPopupExtender>
            <asp:Panel ID="panel2" runat="server" Width="680px" BackColor="#FFFFFF" CssClass="RoundpanelNarr RoundpanelNarrExtra">
                <div class="Ttlepopu">
                    <label class="labelChange">Delete Assignments </label>
                    <asp:HiddenField ID="hdnDeleteid" runat="server" />
                </div>

                <div class="space"></div>
                <label class="labelChange">Are you sure want to delete? </label>
                <div class="space"></div>
                <input id="BtnY" type="button" class="TbleBtns TbleBtnsPading" value="Yes" />
                &nbsp;
                            <input id="BtnN" type="button" class="TbleBtns TbleBtnsPading" value="No" />
            </asp:Panel>
        </div>
    </div>

</div>
<asp:HiddenField ID="hidpermission" runat="server" />
<asp:HiddenField ID="hdnedit" runat="server" />
<asp:HiddenField ID="hdndelete" runat="server" />

