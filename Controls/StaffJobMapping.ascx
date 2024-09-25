<%@ Control Language="C#" AutoEventWireup="true" CodeFile="StaffJobMapping.ascx.cs" Inherits="controls_StaffJobMapping" %>


<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<script src="../jquery/dist/jquery.contextMenu.js" type="text/javascript"></script>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>

<link href="../jquery/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />


<script type="text/javascript" language="javascript">
    var rbtn = '';
    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        $("[id*=hdnEditAid]").val('0');
        $("[id*=hdnPages]").val(1);
        var PageSize = 25;
        var pageIndex = $("[id*=hdnpageIndex]").val();
        var compid = $("[id*=hdnCompany_id]").val();
        $("[id*= rold]").attr('checked', 'checked');
        bind_Grd(compid, 1, '', 'rold');
        $("[id*= dvDelete]").hide();
        $("[id*= dvSave]").show();

        $("[id*= rnew]").live('click', function () {
            $(this).attr('checked', 'checked');
            rbtn = 'rnew';
            var srch = $("[id*=txtsearch]").val();
            $("[id*= rold]").prop('checked', false);
            bind_Grd(compid, 1, srch, 'rnew');
        });

        $("[id*= rold]").live('click', function () {
            $(this).attr('checked', 'checked');
            var srch = $("[id*=txtsearch]").val();
            rbtn = 'rold';
            $("[id*= rnew]").prop('checked', false);
            bind_Grd(compid, 1, srch, 'rold');
        });

        $("[id*= ChkAssg]").live('click', function () {
            var chk = $("[id*= ChkAssg]").is(':checked');
            $("input[name=chkJob]").each(function () {
                if (chk == true) {
                    $(this).attr('checked', 'checked');
                } else { $(this).removeAttr('checked'); }
            });
        });

        $("[id*= btnAdd]").live('click', function () {
            $("[id*=drpDept]").val(0);
            $("[id*= Txt2]").val('');
            var aid = 0;
            var compid = $("[id*=hdnCompany_id]").val();
            GetDept(aid, compid);
            GetJob(aid, compid);
            $find("ListModalPopupBehavior").show();
        });

        $("[id*= BtnN]").live('click', function () {
            $find("ListDeletePopup").hide();
        });
        $("[id*= BtnDelRec]").live('click', function () {
            Delete_Assign();
        });

        $("[id*= BtnDelCancel]").live('click', function () {
            $find("ListModalPopupBehavior").hide();
            $("[id*= dvDelete]").hide();
            $("[id*= dvSave]").show();
            $("[id*= lblPop]").html('Staff Job Allocation');
            var srch = $("[id*=txtsearch]").val();
            bind_Grd(compid, 1, srh, 'rold');
        });
  

        $("[id*= BtnY]").live('click', function () {
            $find("ListDeletePopup").hide();
            var compid = $("[id*=hdnCompany_id]").val();
            var aid = $("[id*=hdnDeleteid]").val();
            $find("ListModalPopupBehavior").show();
            $("[id*= dvDelete]").show();
            $("[id*= dvSave]").hide();
            $("[id*= lblPop]").html('Delete Job Allocation');
            
            $.ajax({
                type: "POST",
                url: "../Handler/ws_StaffJobMapping.asmx/Show_Delete_Assignment",
                data: '{compid:' + compid + ',aid:' + aid + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tr;
                    var vadfds = "";
                    $("[id*=tblJob] tbody").remove();
                    for (var i = 0; i < myList.length; i++) {
                        vadfds = "";
                        if (parseFloat(myList[i].ischecked) > 0) {
                            vadfds = 'checked';
                        }
                        tr = $('<tr><td> <input type="hidden" name="hdnmjid" value="' + myList[i].JobID + '"> <input type="checkbox" name="chkJob" value="' + myList[i].JobID + '"' + vadfds + ' />' + myList[i].Assign_Name + '</td></tr>');
                        $('#tblJob').append(tr);

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
            //var d = $("[id*=drpDept]").val();
            //var a = $("[id*=Txt2]").val();
            var compid = $("[id*=hdnCompany_id]").val();
            var aid = $("[id*=hdnEditAid]").val();
            //if (aid == "0") {
            //    insert_Assign(compid, a, d);
            //}
            //else {
                update_Assign(compid, aid);
           // }
        });

        $("[id*= btnCancel]").live('click', function () {
            $find("ListModalPopupBehavior").hide();
            $(".modalganesh").hide();
        });

        $("[id*= btnAsearch]").live('click', function () {
            var srch = $("[id*=txtsearch]").val();
            var chk = $("[id*= rnew]").is(':checked');
            if (chk == true) {
                rb = 'rnew'
            }
            else
            {
                rb = 'rold'
            }
            bind_Grd(compid, 1, srch, rb );
        });
    });



    function bind_Grd(compid, pageIndex, srch, rbtn) {
        $.ajax({
            type: "POST",
            url: "../Handler/ws_StaffJobMapping.asmx/BindGrd",
            data: '{compid:' + compid + ',p:' + pageIndex + ', srch:"' + srch + '",rbtn: "' + rbtn + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: OnSuccess,
            failure: OnError,
            error: OnError
        });
    }


    function OnSuccess(response) {
        var mylist = jQuery.parseJSON(response.d);

        var customers = mylist[0].list_StaffJobMapping;

        $("[id*=tbl_Assg] tbody").remove();
        var trHTML = '';
        if (customers.length > 0) {
            var srno = 1;
            var RecordCount = 0;
            $("[id*=tbl_Assg] tbody").remove();

            for (var i = 0; i < customers.length; i++) {
                trHTML += '<tr>';
                trHTML += "<td width='80px' style='text-align: center'>" + customers[i].Sino + "<input type='hidden' id='hdnAid' value='" + customers[i].Staffcode + "' name='hdnAid'></td>";
                trHTML += "<td width='450px' style='text-align: left'>" + customers[i].StaffName + "<input type='hidden' id='hdnAname' value='" + customers[i].StaffName + "' name='hdnAname'></td>";
                trHTML += "<td width='300px' style='text-align: left'>" + customers[i].Department + "<input type='hidden' id='hdnDname' value='" + customers[i].Department + "' name='hdnDname'></td>";
                trHTML += "<td width='300px' style='text-align: left'>" + customers[i].Designation + "</td>";
                trHTML += "<td width='150px' style='text-align: center'>" + customers[i].TotPrj + "</td>";
                var roleedit = $("[id*=hdnedit]").val();
                if (roleedit == 'False') { }
                else {
                    trHTML += "<td width='80px'><img src='../images/edit.png' style='cursor:pointer; height:18px; width:18px;' onclick='Edit_Assign($(this))' id='btnEdit' name='btnEdit'></td>"
                }
                trHTML += "<td width='80px'><img src='../images/Delete.png' style='cursor:pointer; height:18px; width:18px;' onclick='Delete_Confirm($(this))' id='btnDelete' name='btnDelete'></td>"

                RecordCount = parseInt(customers[i].TCount);

                trHTML += '</tr>';
            };
            $("[id*=tbl_Assg]").append(trHTML);

            $(".modalganesh").hide();
            $("[id*=lblsj]").html('(' + mylist[0].Staffwith + ')');
            $("[id*=lblswoj]").html('(' + mylist[0].Staffwithout + ')');
            
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
            var srch = $("[id*=txtsearch]").val();
            bind_Grd(compid, ($(this).attr('page')), srch, rbtn)
        });
    }

    function Edit_Assign(i) {
        var row = i.closest("tr");
        var aid = row.find("input[name=hdnAid]").val()
        $("[id*= hdnEditAid]").val(aid);
        $("[id*= Txt2]").text(row.find("input[name=hdnAname]").val())
        $("[id*= lblDeptName]").text(row.find("input[name=hdnDname]").val())
        var compid = $("[id*=hdnCompany_id]").val();
        //GetDept(aid, compid);
        GetJob(aid, compid);
        $find("ListModalPopupBehavior").show();
    }

    function Delete_Confirm(i)
    {
        var row = i.closest("tr");
        var aid = row.find("input[name=hdnAid]").val();
        $("[id*= hdnEditAid]").val(aid);
        $("[id*= hdnDeleteid]").val(aid);
        $("[id*= Txt2]").text(row.find("input[name=hdnAname]").val());
        $("[id*= lblDeptName]").text(row.find("input[name=hdnDname]").val());
        var compid = $("[id*=hdnCompany_id]").val();
        $find("ListDeletePopup").show();

    }

    function Delete_Assign() {
        var newDate = new Date();
        
        $find("ListModalPopupBehavior").hide();
        $("[id*= dvDelete]").hide();
        $("[id*= dvSave]").show();
        var ip = $("[id*= hdnIP]").val();
        var usr = $("[id*= hdnName]").val();
        var uT = $("[id*= hdnUser]").val();
        var aid = $("[id*= hdnDeleteid]").val();

        var compid = $("[id*=hdnCompany_id]").val();

        try {
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/ws_StaffJobMapping.asmx/Delete_Assignment",
                data: '{compid:' + compid + ',aid:' + aid + ',ip:"' + ip + '",usr:"' + usr + '", ut:"' + uT + '", dt: "' + newDate + '" }',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    alert("Jobs Deleted");
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

    function GetJob(aid, compid) {
        try {
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/ws_StaffJobMapping.asmx/BindJob",
                data: '{compid:' + compid + ',aid:' + aid + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tr;
                    var vadfds = "";
                    $("[id*=tblJob] tbody").remove();
                    for (var i = 0; i < myList.length; i++) {
                        vadfds = "";
                        if (parseFloat(myList[i].ischecked) > 0) {
                            vadfds = 'checked';
                        }
                        tr = $('<tr><td> <input type="hidden" name="hdnmjid" value="' + myList[i].JobID + '"> <input type="checkbox" name="chkJob" value="' + myList[i].JobID + '"' + vadfds + ' />' + myList[i].Assign_Name + '</td></tr>');
                        $('#tblJob').append(tr);

                    }
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



    function update_Assign(compid, aid) {

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
            url: "../Handler/ws_StaffJobMapping.asmx/Update_Assignment",
            data: '{compid:"' + compid + '", aid:"' + aid + '", jid:"' + Alljid + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length > 0) {
                    var aid = myList[0].StaffCode;
                    $("[id*=hdnEditAid]").val(0);
                    ClearALL();
                    $find("ListModalPopupBehavior").hide();
                    alert('Record update successfully');
                    var srch = $("[id*=txtsearch]").val();
                    bind_Grd(compid, 1, srch, rbtn);
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
    /*----- Tabs -----*/
    .tabs
    {
        width: 100%;
        display: inline-block;
        border: 1px;
    }
    
    .tab-links
    {
        margin: 0px;
        padding: 0px;
    }
    
    /* Clearfix */
    .tab-links:after
    {
        display: block;
        clear: both;
        content: '';
    }
    
    .tab-links li
    {
        margin: 0px 3px;
        float: left;
        list-style: none;
    }
    
    .tab-links a
    {
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
    
    .tab-links a:hover
    {
        background: #1464F4;
        text-decoration: none;
        color: #fff;
        border: 1px;
    }
    
    li.active a, li.active a:hover
    {
        background: #1464F4;
        color: #fff;
    }
    
    /*----- Content of Tabs -----*/
    .tab-content
    {
        padding: 15px;
        border-radius: 3px; /*box-shadow:-1px 1px 1px rgba(0,0,0,0.15); */ /*background:#fff; */
        border: 1px solid #1464F4;
        min-height: 300px;
    }
    
    .tab
    {
        display: none;
    }
    
    .tab.active
    {
        display: block;
    }
    
    
    
    .modalBackground
    {
        background-color: Gray;
        filter: alpha(opacity=70);
        opacity: 0.7;
    }
    .Button
    {
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
    .Head1
    {
        font-size: 14px;
        font-family: Verdana,Arial,Helvetica,sans-serif;
        color: #3D80E8;
        font-weight: bold;
        overflow: hidden;
        border-bottom-color: White;
    }
    .divspace
    {
        height: 20px;
    }
    .headerstyle1_page
    {
        border-bottom: 1px solid #55A0FF;
        float: left;
        margin: 0 0 10px;
        overflow: hidden;
    }
    .headerpage
    {
        height: 23px;
    }
    .error
    {
        background-color: #FF0000;
        background-image: none !important;
        color: #FFFFFF !important;
        margin: 0 0 10px;
        width: 95% !important;
    }
    .property_tab
    {
    }
    .property_tab
    {
    }
    .drp
    {
        font-family: Verdana,Arial,Helvetica,sans-serif;
        font-size: 12px;
        -webkit-border-radius: 3px;
        -moz-border-radius: 3px;
        border-radius: 3px;
        width: 80px;
    }
    
    .EditJobTble2
    {
    }
    .EditJobTble2 td
    {
    }
    .EditJobTble2 td select
    {
        border: 1px solid #BCBCBC;
        border-radius: 5px;
        height: auto !important;
        padding: 3px 5px;
        font-size: 12px;
        width: 1000px;
    }
    .Pager b
    {
        margin-top: 2px;
        float: left;
    }
    .Pager span
    {
        text-align: center;
        display: inline-block;
        width: 20px;
        margin-right: 3px;
        line-height: 150%;
        border: 1px solid #BCBCBC;
    }
    .Pager a
    {
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
    .panelNarr  {
    background-color: #FFFFFF;
    left: 30% !important;
    margin: -270px 0 0 -300px;
    height: 260px;
    padding: 10px;
    top: 50% !important;
    width: 660px;
    }
        button {
        background-color: #6BBE92;
        width: 302px;
        border: 0;
        padding: 10px 0;
        margin: 5px 0;
        text-align: center;
        color: #fff;
        font-weight: bold;
    }

    .cssPageTitle {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        border-bottom: 2px solid #0b9322;
        /*padding: 7px;*/
        color: #0b9322;
    }

    .cssButton {
        cursor: pointer; /*background-image: url(../Images/ButtonBG1.png);*/
        background-color: #d3d3d3;
        border: 0px;
        padding: 4px 15px 4px 15px;
        color: Black;
        border: 1px solid #c4c5c6;
        border-radius: 3px;
        font: bold 12px verdana, arial, "Trebuchet MS", sans-serif;
        text-decoration: none;
        opacity: 0.8;
    }

    .cssPageTitle2 {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        /*border-bottom: 2px solid #0b9322;*/
        padding: 7px;
        color: #0b9322;
    }

    .cssButton:focus {
        background-color: #69b506;
        border: 1px solid #3f6b03;
        color: White;
        opacity: 0.8;
    }

    .cssButton:hover {
        background-color: #69b506;
        border: 1px solid #3f6b03;
        color: White;
        opacity: 0.8;
    }
        .cssTextbox {
        font: normal 12px verdana, arial, "Trebuchet MS", sans-serif;
        height: 15px;
        border-radius: 4px;
        border: 1px solid #b5b5b5;
    }

    .cssTextboxLong {
        font: normal 12px verdana, arial, "Trebuchet MS", sans-serif;
        width: 350px;
        height: 25px;
        border-radius: 4px;
        border: 1px solid #b5b5b5;
    }

    .cssTextbox:focus {
        box-shadow: 0 0 5px rgba(81, 203, 238, 1);
        padding: 3px 0px 3px 3px;
        border: 1px solid rgba(81, 203, 238, 1);
    }

    .cssTextbox:hover {
        border: 1px solid rgba(81, 203, 238, 1);
    }

    .cssTextboxInt {
        font: normal 12px verdana, arial, "Trebuchet MS", sans-serif;
        height: 25px;
        text-align: right;
        border-radius: 4px;
        border: 1px solid #b5b5b5;
        padding-right: 5px;
    }

        .cssTextboxInt:focus {
            box-shadow: 0 0 5px rgba(81, 203, 238, 1);
            padding-right: 5px;
            border: 1px solid rgba(81, 203, 238, 1);
        }

        .cssTextboxInt:hover {
            padding-right: 5px;
            border: 1px solid rgba(81, 203, 238, 1);
        }
</style>


<div class="divstyle" style="height: auto">
   <div>
     <div>
          <table class="cssPageTitle" style="width: 100%;">
                <tr>
                    <td class="cssPageTitle2">
                        <asp:Label ID="lblname" runat="server" text="Manage Staff Job Allocation" Style="margin-left: 10px;"></asp:Label>
                    </td>                    
                </tr>
            </table>
    
    </div>
   </div>
   
    <div id="Div8" runat="server" class="masterdiv1a">
        <div style="width: 100%; float: left;">
            <uc1:MessageControl ID="MessageControl1" runat="server" />    
            <asp:HiddenField ID="hdnCompany_id" runat="server" />
            <asp:HiddenField ID="hdnpageIndex" runat="server" />
            <asp:HiddenField ID="hdnPages" runat="server" />
            <asp:HiddenField ID="hdnIP" runat="server" />
            <asp:HiddenField ID="hdnName" runat="server" />
            <asp:HiddenField ID="hdnUser" runat="server" />
                        
                <div style="float: left;  width: 100%;padding-top:5px ">
                <asp:Panel ID="Panel5" runat="server" >
                    <div>
		                <div id="searchloc"  runat="server">
		                    <div style="float: left; width: 100%; margin:10px; padding-bottom: 5px; overflow: auto;" class="serachJob" >
                              <div style="float: left; width:50% ; margin:10px; padding-bottom: 5px; overflow: auto;">
                                   <asp:Label ID="Label26" runat="server" Text="Search Staff" CssClass="LabelFontStyle labelChange"></asp:Label>&nbsp;&nbsp;

                                <asp:TextBox ID="txtsearch" runat="server" CssClass="cssTextbox"></asp:TextBox>
                                &nbsp;<input id="btnAsearch" type="button"  value="Search" class="cssButton" />
                         
                                <%--<input id="btnAdd" type="button" class="TbleBtnsPading TbleBtns labelChange" 
                                     value="Add Mappings"  runat="server"/>--%>
                               </div> 
                                <div style="float: left; width:30% ; margin:10px; padding-bottom: 5px; overflow: auto;">
                                     <input type="radio" id="rold" value="Jobs Allocated"/>
                                    <label for="rold">Staff with Jobs</label>
                                     <label id="lblsj" style="font-weight:bold">(0)</label>
                                    <input type="radio" id="rnew" />
                                    <label for="rnew">Staff W/O Jobs</label>
                                    <label id="lblswoj" style="font-weight:bold">(0)</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                   
                                </div> 
                            </div>
                        </div>
                   </div>
               </asp:Panel>
               </div>

        </div>

        <div class="divfloatleftn" style="float: right; margin:10px; padding-left:10px;">   
                   <asp:Panel ID="Panel1" runat="server" >  
                        <table id="tbl_Assg" width="1175px" border="1px" class="norecordTble" style="border-collapse: collapse;">
                            <thead>
                                <tr>
                                    <th class="grdheader" style="text-align:center">
                                        Sr
                                    </th>
                                    <th class="grdheader">
                                        Staff
                                    </th>
                                    <th class="grdheader">
                                        Departments
                                    </th>
                                    <th class="grdheader">
                                        Designation
                                    </th>
                                    <th class="grdheader">
                                        Total Prj
                                    </th>
                                    <th class="grdheader" id="thedit" runat="server">
                                        Allocate
                                    </th>
                                    <th class="grdheader" id="th1" runat="server">
                                        Delete
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr style="color: rgb(0, 0, 102); height: 15px;">

                                    <td width="50px" style="text-align:right">
                                    </td>
                                    <td width="450px" style="text-align:right">
                                    </td>
                                    <td width="300px"  style="text-align:right" >
                                    </td
                                    <td width="300px"  style="text-align:right" >
                                    </td>
                                    <td width="150px"  style="text-align:right" >
                                    </td>
                                    <td width="80px"  >
                                    </td>
                                    <td width="80px" >
                                    </td>                                    
                                </tr>
                            </tbody>
                        </table>

                <table id="tblPager" style="border: 1px solid #BCBCBC; border-bottom: none; background-color: rgba(219,219,219,0.54);
                    text-align: right;" cellpadding="2" cellspacing="0" width="1100px">
                    <tr>
                        <td>
                            <div class="Pager">
                            </div>
                        </td>
                    </tr>
                </table> 
                </asp:Panel>
           
       
               <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server">
                </asp:Button><br />
        
                <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" BackgroundCssClass="modalBackground" CancelControlID="btnCancel" 
                    BehaviorID="ListModalPopupBehavior" DropShadow="False" PopupControlID="panel10"
                      TargetControlID="hideModalPopupViaClientOrginal2">
                </cc1:ModalPopupExtender>
                 <asp:Panel ID="panel10" runat="server" Width="1100px" height="530px" ScrollBars="Vertical" BackColor="#FFFFFF" CssClass="panelNarr">
                    <div class="Ttlepopu">
                        <label id="lblPop" class="labelChange">Staff Job Allocation </label> 
                        <asp:HiddenField ID="hdnEditAid" runat="server" />                                                  
                    </div>
                     <table style="padding-bottom:15px;">
                       
                         <tr>
                            <td style="width:80px;">
                                <asp:Label ID="Label1" runat="server" Font-Bold="true" Text="Staffname :"  CssClass="LabelFontStyle labelChange"></asp:Label>
                            </td>
                            <td style="width: 250px">
                                 <asp:Label ID="Txt2" ForeColor="Black" TabIndex="0" CssClass="LabelFontStyle labelChange" Width="250px" runat="server"></asp:Label>
                            </td>
                         <td>
                                <asp:Label ID="Label3" runat="server" Font-Bold="true"  Text="Department :"  CssClass="LabelFontStyle labelChange"></asp:Label>
                            </td>
                            <td style="width: 250px">
                                <asp:Label ID="lblDeptName" ForeColor="Black" CssClass="LabelFontStyle labelChange" runat="server"></asp:Label>
                            </td></tr>
                         
                     </table>
                     <table style="border: solid 1px black;">
                         <tr>
                             <td>Job List - ( ClientName ) - ( ProjectName )
                             </td>
                         </tr>
                         <tr>
                             <td>
                                 <fieldset  style="padding: 10px; padding-top:5px; height:350px; overflow:scroll; border:none;  ">
                                 <%--<legend style="font-weight:bold; color:Red;" class="LabelFontStyle labelChange"></legend>--%>
                                 <table style="overflow:scroll; height:90px;">
                                 <tr>
                                 <td><asp:CheckBox ID="ChkAssg" runat="server" ForeColor="Black" Text="Select All" CssClass="LabelFontStyle labelChange"></asp:CheckBox>    
                                 <br />
                                 <div class="popup"> 
                                     <table id="tblJob" width="850px">
                                     </table>
                                  </div> </td>
                                 </tr>
                                 </table>

                                 </fieldset>
                            </td>
                      </tr>

                     </table>
                    
                       <div class="noteText"> 
                        <div class="txtboxNewError">
                         </div>

                       </div> 
                        
                       <div id="dvSave" class="space" style="padding-top:10px;">    
                            <input id="BtnSubmit" type="button"  class="cssButton" value="Save"/>
                            &nbsp;
                            <asp:Button ID="btnCancel" runat="server"  CssClass="cssButton" Text="Cancel" />
                       </div>    
                       <div id="dvDelete">
                            <input id="BtnDelRec" type="button"  class="TbleBtns TbleBtnsPading" value="Delete"/>
                            &nbsp;
                            <input ID="BtnDelCancel" type="button"  class="TbleBtns TbleBtnsPading" Value="Cancel" />

                       </div>
                </asp:Panel>


                <asp:Button Style="display: none" ID="Button1" runat="server">
                </asp:Button><br />
        
                <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="modalBackground" CancelControlID="BtnN" 
                    BehaviorID="ListDeletePopup" DropShadow="False" PopupControlID="panel2"
                     RepositionMode="RepositionOnWindowScroll" TargetControlID="Button1">
                </cc1:ModalPopupExtender>
                 <asp:Panel ID="panel2" runat="server" Width="680px" BackColor="#FFFFFF" CssClass="RoundpanelNarr RoundpanelNarrExtra">
                    <div class="Ttlepopu">
                        <label class="labelChange">Delete Assignments </label> 
                        <asp:HiddenField ID="hdnDeleteid" runat="server" />
                    </div>

                     <div class="space"> </div>      
                     <label class="labelChange">Are you sure want to delete? </label> 
                     <div class="space"> </div>      
                            <input id="BtnY" type="button"  class="TbleBtns TbleBtnsPading" value="Yes"/>
                            &nbsp;
                            <input id="BtnN" type="button"  class="TbleBtns TbleBtnsPading" value="No" />
                </asp:Panel>
        </div>
</div>

</div> 
<asp:HiddenField ID="hidpermission" runat="server" />
 <asp:HiddenField ID="hdnedit" runat="server" />
<asp:HiddenField ID="hdndelete" runat="server" /> 