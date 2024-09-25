<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProjectWiseBudgetEditing.ascx.cs"
    Inherits="controls_ProjectWiseBudgetEditing" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>
<script src="../jquery/jquery.searchabledropdown-1.0.8.min.js" type="text/javascript"></script>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>

<script type="text/javascript">
    $(document).ready(function () {
    
        var PageSizen = 25;
        var pageIndex = $("[id*=hdnpageIndex]").val();
        $("[id*=hdnPages]").val(1);
        var compid = parseFloat($("[id*=hdnCompid]").val());
        Bind_Client(compid);
        Bind_job(compid, 0);
        $("[id*=drpclient]").on('change', function () {
            var cltid = $("[id*=drpclient]").val();
            Bind_job(compid, cltid);

            get_editable_Budgetdata(compid, cltid, 0, 1, 25);
        });
        $("[id*=ddljob]").on('change', function () {
            var cltid = $("[id*=drpclient]").val();
            var mjobid = $("[id*=ddljob]").val();

            get_editable_Budgetdata(compid, cltid, mjobid, 1, 25);
        });

        get_editable_Budgetdata(compid, 0, 0, 1, 25);

    });
    function isNumberKey(evt) {
        var charCode = (evt.which) ? evt.which : event.keyCode
        if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;
        return true;
    }
    function searchSel() {
        var input = document.getElementById('realtxt').value.toLowerCase();

        len = input.length;
        output = document.getElementById('drpclient').options;
        for (var i = 0; i < output.length; i++)
            if (output[i].text.toLowerCase().indexOf(input) != -1) {
                output[i].selected = true;
                break;
            }
        if (input == '')
            output[0].selected = true;
    }
    function Showchk(i) {
        
        var chkrow = i.closest("tr");
        var curchk = $("#chkjobid", chkrow);
        if (curchk.is(':checked')) {
            $(".chkjobid").removeAttr('checked');
            $(".txtBudAmt").css('display', 'none');
            $(".txtCalendarDate1").css('display', 'none');
            $(".txtBudHours").css('display', 'none');
            $(".txtOtherAmt").css('display', 'none');
            $(".btnsave").css('display', 'none');
            $("#chkjobid", chkrow).attr('checked', true);
            $("#txtBudAmt", chkrow).css('display', 'block');
            $("#txtCalendarDate1", chkrow).css('display', 'block');
            $("#txtBudHours", chkrow).css('display', 'block');
            $("#txtOtherAmt", chkrow).css('display', 'block');
            $("#txtBudHours", chkrow).val("0");
            $("#txtOtherAmt", chkrow).val("0");
            $("#btnsave", chkrow).css('display', 'block');
        }
        else {
            $("#txtBudAmt", chkrow).css('display', 'none');
            $("#txtCalendarDate1", chkrow).css('display', 'none');
            $("#txtBudHours", chkrow).css('display', 'none');
            $("#txtOtherAmt", chkrow).css('display', 'none');
            $("#btnsave", chkrow).css('display', 'none');
        }
        
    }
    function ShowSave(i) {
        var row = i.closest("tr");

        var jobid = $("#hdnjobid", row).val();
        var bid = $("#hdnbdid", row).val();
        var newBudHours = $("#txtBudHours", row).val();
        
        var newBudAmt = $("#txtBudAmt", row).val();
        if (newBudAmt == '' || newBudAmt=='0') {
            alert("Please Add New Budgeted Amount");
            return false;
        }
        var newCalendarDate1 = $("#txtCalendarDate1", row).val();
        if (newCalendarDate1 == '') {
            alert("Please Add New Date");
            return false;
        }
        var newtxtOtherAmt = $("#txtOtherAmt", row).val();
        var compid = $("[id*=hdnCompid]").val();
        savejobbudget(compid, jobid, newBudAmt, newBudHours, newtxtOtherAmt, newCalendarDate1,bid);
    }


    function savejobbudget(compid,jobid, newBudAmt, newBudHours, newtxtOtherAmt,newCalendarDate1, bid) {
        $.ajax({
            type: "POST",
            url: "../Handler/wsProjectBudgetingEdit.asmx/savejobbudget",
            data: '{compid:"' + compid + '",jobid:"' + jobid + '",newBudAmt:"' + newBudAmt + '",newBudHours:"' + newBudHours + '",newtxtOtherAmt:"' + newtxtOtherAmt + '",newCalendarDate1:"' + newCalendarDate1 + '", bid:"' + bid + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                alert("Job Save Successfully");
                var cltid=$("[id*=drpclient]").val();
                var jid = $("[id*=ddljob]").val();
                get_editable_Budgetdata(compid,cltid,jid, 1, 25);
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });

    }

    function get_editable_Budgetdata(compid, cltid, mjobid, PageIndex, PageSize) {
        $.ajax({
            type: "POST",
            url: "../Handler/wsProjectBudgetingEdit.asmx/get_editable_Budgetdata",
            data: '{compid:' + compid + ',cltid:' + cltid + ',mjobid:' + mjobid + ',PageIndex:' + PageIndex + ',PageSize:'+PageSize+'}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: OnSuccess,
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }

    function OnSuccess(response) {
        var xmltab = $.parseXML(response.d);
        var xml = $(xmltab);
        var Budget = xml.find("Table");
        $("[id*=tabbudgetedit] tbody").remove();
        var budgettr = "";
        var count = 1;
        if (Budget.length > 0) {
            $.each(Budget, function () {
                var tr = $(this);
                tr = '<tr><td><input id="chkjobid" type="checkbox" class="chkjobid" onclick="Showchk($(this))"/></td>';
                tr = tr + '<td><input id="hdnbdid" type="hidden" value=' + $(this).find("Budget_Master_id").text() + '>' + $(this).find("ClientName").text() + '</td>';
                tr = tr + '<td>' + $(this).find("MJobName").text() + '</td>';
                tr = tr + '<td>' + $(this).find("Date").text() + '</td>';
                tr = tr + '<td align="right">' + $(this).find("BudAmt").text() + '</td>';
                tr = tr + '<td align="right">' + $(this).find("BudHours").text() + '</td>';
                tr = tr + '<td align="right">' + $(this).find("OtherAmt").text() + '</td>';
                tr = tr + '<td> <input type="date" id="txtCalendarDate1" class="txtCalendarDate1" value="" style="display:none" /></td>';
                tr = tr + '<td><input id="txtBudAmt" type="text" class="txtBudAmt" onkeypress="return isNumberKey(event)" style="display:none;text-align:right;width:50px;"/></td>';
                tr = tr + '<td><input id="txtBudHours" type="text" class="txtBudHours" onkeypress="return isNumberKey(event)" style="display:none;text-align:right; width:50px;"/></td>';
                tr = tr + '<td><input id="txtOtherAmt" type="text" class="txtOtherAmt" onkeypress="return isNumberKey(event)"  style="display:none;text-align:right;width:50px;"/></td>';
                tr = tr + '<td><input id="btnsave" type="button" Value="Save" class="btnsave" onclick="ShowSave($(this))" style="display:none"/><input id="hdnjobid" type="hidden" value=' + $(this).find("JobId").text() + '></td></tr>';
                $("[id*=tabbudgetedit]").append(tr);
                count = count + 1;
                budgettr = $(this).find("bcount").text();
            });
//            if (budgettr < 25) { $("#tblPager").hide(); }

            var RecordCount =parseInt(budgettr);
                Pager(RecordCount);
        }
        else {
            $("[id*=tabbudgetedit]").append('<tr><td colspan=12>No record found....</td></tr>');
            RecordCount = 0;
            Pager(RecordCount);
        }
    }

       
        

    function Pager(RecordCount) {
        $(".Pager").ASPSnippets_Pager({
            ActiveCssClass: "current",
            PagerCssClass: "pager",
            PageIndex: parseInt($("[id*=hdnPages]").val()),
            PageSize: parseInt(25),
            RecordCount: (RecordCount)
        });
        $(".Pager .page").on("click", function () {
            $("[id*=hdnPages]").val($(this).attr('page'));
            var compid = parseFloat($("[id*=hdnCompid]").val());
            var cltid = $("[id*=drpclient]").val();
            var mjobid = $("[id*=ddljob]").val();
            get_editable_Budgetdata(compid,cltid,mjobid,($(this).attr('page')), 25)
        });
    }

   
    function Bind_Client(compid) {

        $.ajax({
            type: "POST",
            url: "../Handler/wsProjectBudgetingEdit.asmx/bind_Client",
            data: '{compid:' + compid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                $("[id*=drpclient]").empty();
                $("[id*=drpclient]").append("<option value=0>--Select--</option>");
                for (var i = 0; i < myList.length; i++) {

                    $("[id*=drpclient]").append("<option value='" + myList[i].cltid + "'>" + myList[i].clientname + "</option>");

                }
             ////   MakeSmartSearch();
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }
    function Bind_job(compid, cltid) {
   
        $.ajax({
            type: "POST",
            url: "../Handler/wsProjectBudgetingEdit.asmx/Bind_job",
            data: '{compid:' + compid + ',cltid:'+cltid+'}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                $("[id*=ddljob]").empty();
                $("[id*=ddljob]").append("<option value=0>--Select--</option>");
                for (var i = 0; i < myList.length; i++) {

                    $("[id*=ddljob]").append("<option value='" + myList[i].mjobid + "'>" + myList[i].MJobName + "</option>");

                }
               //// MakeSmartSearch();
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }


//    function MakeSmartSearch() {
//        $("select").searchable({
//            maxListSize: 200, // if list size are less than maxListSize, show them all
//            maxMultiMatch: 300, // how many matching entries should be displayed
//            exactMatch: false, // Exact matching on search
//            wildcards: true, // Support for wildcard characters (*, ?)
//            ignoreCase: true, // Ignore case sensitivity
//            latency: 200, // how many millis to wait until starting search
//            warnMultiMatch: 'top {0} matches ...',
//            warnNoMatch: 'no matches ...',
//            zIndex: '999'
//        });
    ///}

</script>
 <style type="text/css">
        .tabular
        {
            margin: 10px 0;
            width: auto;
        }
        .tabular .property_tab .ajax__tab_body
        {
            min-height: 100px !important;
            height: auto !important;
            position: absolute;
        }
        
        .property_tab .ajax__tab_body
        {
            padding: 5px;
            width: 995px !important;
        }
        
        .loading
        {
            font-family: Arial;
            font-size: 10pt;
            border: 5px solid #67CFF5;
            width: 200px;
            height: 100px;
            display: none;
            position: fixed;
            background-color: White;
            z-index: 999;
        }
        .pagination
        {
            font-size: 80%;
        }
        
        .pagination a
        {
            text-decoration: none;
            border: solid 1.5px #55A0FF;
            color: #15B;
        }
        
        .pagination a, .pagination span
        {
            display: block;
            float: left;
            padding: 0.1em 0.5em;
            margin-right: 1px;
            margin-bottom: 2px;
        }
        
        .pagination .current
        {
            background: #26B;
            color: #fff;
            border: solid 1px #AAE;
        }
        
        .pagination .current.prev, .pagination .current.next
        {
            color: #999;
            border-color: #999;
            background: #fff;
        }
        
        tr.cltoggleclass td
        {
            cursor: inherit;
            color: #fff;
            background: #25a0da;
            border-color: #25a0da !important;
        }
        
        .allTimeSheettle tr:hover
        {
            cursor: inherit;
            background: #F2F2F2;
            border: 1px solid #ccc;
            padding: 5px;
            color: #474747;
        }
        .allTimeSheettle
        {
            cursor: inherit;
        }
        
        
        .newstyleforbindstaff
        {
            text-align: center !important;
        }
        .newstyleforbindstaffLable
        {
            min-width: 100px;
        }
        .newtotalback
        {
            background: #F2F2F2;
            height: 35px;
            font-weight: bold;
        }
        .DropDown
        {
            max-height: 25px !important;
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
    </style>

<div class="testwhleinside">
    <asp:HiddenField ID="hdnPages" runat="server" />
    <asp:HiddenField ID="hdnpageIndex" runat="server" />
    <asp:HiddenField ID="hdnCompid" runat="server" />
    
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
            <asp:Label ID="Label18" runat="server" CssClass="Head1 labelChange" Text="ProjectWise Budget Editing"></asp:Label>
        </div>
    </div>

</div>
<div style="height:2500px">
<div id="dvfilter">
    <table id="tabfilters" runat="server" style="padding-top:15px; padding-left:165px; padding-right:15px; width:900px;">
        <tr>
            <td style="width: 25px" align="left">
                <asp:Label ID="Label7" Text="Client" runat="server" Font-Bold="True" CssClass="labelChange" />
            </td>
            <td>
            
                <select id="drpclient" runat="server" class="DropDown custom-select js-example-basic-single" style="width: 350px; height:500px;">

                    <option value="0">--Select--</option>
                </select>
            </td>
            <td style="width: 25px" align="left">
                <asp:Label ID="Label1" Text="Job" runat="server" Font-Bold="True" CssClass="labelChange" />
            </td>
            <td>
                <select id="ddljob" runat="server" class="DropDown custom-select" style="width: 350px; height:500px;">
                    <option value="0">--Select--</option>
                </select>
            </td>
            
        </tr>
    </table>
</div>
<div id="dvEditable" runat="server" style="width:1150px; padding-top:15px; padding-left:25px; height:1500; padding-right:25px;">
    <fieldset style="border: solid 1px black; padding: 10px; padding-top:5px; height:350px; overflow:scroll;">
    <table id="tabbudgetedit" border="1px" class="norecordTble" style="border-collapse: collapse;">
        <thead>
            <tr>
                <th class="grdheader">
                    
                </th>
                <th class="grdheader">
                    Client Name
                </th>
                <th class="grdheader">
                    Job Name
                </th>
                <th class="grdheader">
                    From Date
                </th>
                
                <th class="grdheader">
                    Last Budget Amount
                </th>
                <th class="grdheader">
                    Last Budget Hours
                </th>
                <th class="grdheader">
                    Last Other Amount
                </th>
                <th style="width:60px" class="grdheader">
                    New From Date
                </th>
                <th style="width:50px" class="grdheader">
                   New Budget Amount
                </th>
                <th style="width:50px" class="grdheader">
                    
                     New Budget Hours.
                </th>
                <th style="width:50px" class="grdheader">
                    New Other Amount
                </th>
                <th style="width:50px" class="grdheader">
                </th>
            </tr>
        </thead>
        <tbody>
            <tr style="color: rgb(0, 0, 102); height: 15px; border: 1px">
                <td width="80px" class="gridcolstyle1">
                </td>
                <td width="250px" align="right" class="gridcolstyle1">
                </td>
                <td width="150px" align="right" class="gridcolstyle1">
                </td>
                 <td width="150px" align="right" class="gridcolstyle1">
                </td>
                <td width="150px" align="left"  class="gridcolstyle1">
                </td>
                <td width="150px" align="left" class="gridcolstyle1">
                </td>
                <td width="100px" align="left" class="gridcolstyle1">
                </td>
                <td width="120px" align="right" class="gridcolstyle1">
                </td>
                <td width="70px" align="right" class="gridcolstyle1">
                </td>
                <td width="70px" align="right" class="gridcolstyle1">
                </td>
                <td width="70px" align="right" class="gridcolstyle1">
                </td>
                <td width="70px" align="right" class="gridcolstyle1">
                </td>
            </tr>
        </tbody>
    </table>
    </fieldset> 
    <table id="tblPager" style="border-left: 1px solid #BCBCBC; border-right: 1px solid #BCBCBC;
        border-top: 1px solid #BCBCBC; background-color: rgba(219,219,219,0.54); text-align: right;
        width: 1000px; border-bottom-style: none; border-bottom-color: inherit; border-bottom-width: medium;"
        cellpadding="2" cellspacing="0">
        <tr>
            <td>
                <div class="Pager">
                </div>
            </td>
        </tr>
    </table>
</div></div>