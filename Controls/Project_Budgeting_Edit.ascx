<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Project_Budgeting_Edit.ascx.cs"
    Inherits="controls_Project_Budgeting_Edit" %>
<%--this page created by mr Anil Gajre on 21/06/2018--%>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>
<script type="text/javascript">
    var Projectwise = true, staffwise = false;
    $(document).ready(function () {

        var pageIndex = $("[id*=hdnpageIndex]").val();
        $("[id*=hdnPages]").val(1);
        Get_Project_Budgeting_Edit_client_Job(1);


        $("[id*=drpclient]").on('change', function () {

            Get_Project_Budgeting_Edit_client_Job(0);

        });

        $("[id*=ddljob]").on('change', function () {

            Get_Project_Budgeting_Edit_BudgetDetails(1, 25);

        });


    });

    //////////////////////get Jobs Budgeting Data
    function Get_Project_Budgeting_Edit_BudgetDetails(PageIndex, PageSize) {
        ///////Ajax Start
        $.ajax({
            type: "POST",
            url: "../Handler/Project_Budgeting_Edit.asmx/Get_Project_Budgeting_Edit_BudgetDetails",
            data: '{Compid:' + $("[id*=hdnCompid]").val() + ',CltId:' + $("[id*=drpclient]").val() + ',JobId:' + $("[id*=ddljob]").val() + ',PageIndex:' + PageIndex + ',PageSize:' + PageSize + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                
                var Count = 0;
                $("[id*=tabbudgetedit] tbody").remove();
                if (myList == null) { } else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            for (var i = 0; i < myList.length; i++) {
                                var tr = '';
                                tr = tr + "<tr><td><input type='checkbox' name='chkjob' id='chkjob' class='chknewbudget' value='" + myList[i].Bud_ID + "' onclick='showtextbox($(this))'/></td>";
                                tr = tr + "<td>" + myList[i].ClientName + "</td>";
                                tr = tr + "<td>" + myList[i].JobName + "</td>";
                                tr = tr + "<td>" + myList[i].FromDate + "</td>";
                                tr = tr + "<td class='isNumeric'>" + myList[i].Bud_Amount + "</td>";
                                tr = tr + "<td class='isNumeric'>" + myList[i].Bud_Hours + "</td>";
                                tr = tr + "<td class='isNumeric'>" + myList[i].Other_Amount + "</td>";
                                tr = tr + "<td><input type='date' id='txtFromdate' class='dateSize' /></td>";
                                tr = tr + "<td><input type='text' id='txtNewBudAmt' class='txtSize' onkeypress='return isNumberKey(event)' /></td>";
                                tr = tr + "<td><input type='text' id='txtNewBudHrs' class='txtSize' onkeypress='return isNumberKey(event)' /></td>";
                                tr = tr + "<td><input type='text' id='txtNewOtherAmt' class='txtSize' onkeypress='return isNumberKey(event)' /></td>";
                                tr = tr + "<td><input type='button' value='Save' id='btnsave' name='btnsave' class='txtSize' onclick=SaveBudget($(this))><input type='hidden' id='hdnJobId' value='" + myList[i].JobId + "'>";
                                $("[id*=tabbudgetedit]").append(tr);
                                Count = parseInt(myList[0].Tcount);

                            }
                            Pager(Count);
                        }
                        else {
                            $("[id*=tabbudgetedit]").append('<tr><td colspan=12>No record found....</td></tr>');
                            Pager(Count);
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

        ////Ajax End
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
            Get_Project_Budgeting_Edit_BudgetDetails(($(this).attr('page')), 25);
        });
    }

    function isNumberKey(evt) {
        var charCode = (evt.which) ? evt.which : event.keyCode
        if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;
        return true;
    }

    //////////////////////save Budegets
    function SaveBudget(n) {
        var tr = n.closest("tr");
        var BudId = $("#chkjob", tr).val();
        var JobId = $("#hdnJobId", tr).val();
        var NewDate = $("#txtFromdate", tr).val();
        var NewBudAmt = $("#txtNewBudAmt", tr).val();
        var NewBudHrs = $("#txtNewBudHrs", tr).val();
        var NewOtherAmt = $("#txtNewOtherAmt", tr).val();

        if (NewDate == "" || NewDate == undefined) {
            alert("Please Select New From Date");
            return false;
        }

        /////Ajax Start
        $.ajax({
            type: "POST",
            url: "../Handler/Project_Budgeting_Edit.asmx/SaveBudget",
            data: '{Compid:' + $("[id*=hdnCompid]").val() + ',BudId:' + BudId + ',JobId:' + JobId + ',NewDate:"' + NewDate + '",NewBudAmt:"' + NewBudAmt + '",NewBudHrs:"' + NewBudHrs + '",NewOtherAmt:"' + NewOtherAmt + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length > 0) {
                    alert("Budget Save Successfully....");
                    Get_Project_Budgeting_Edit_BudgetDetails(1, 25);
                } else {
                    alert("Budget Not Saved....");
                }
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
        //////ajax end

    }

    /////////////////////////show new textboxes
    function showtextbox(i) {
        var row = i.closest("tr");
        var currChkbox = $("#chkjob", row);
        if (currChkbox.is(':checked')) {
            $(".chknewbudget").removeAttr('checked');
            $("#chkjob", row).attr('checked', true);
            $(".txtSize").css('visibility', 'hidden');
            $(".txtSize", row).css('visibility', 'visible');
            $("input[type='text']", row).val('0.00');
        }
        else {
            $(".txtSize").css('visibility', 'hidden');
        }
    }

    //////////////////////get client and job name
    function Get_Project_Budgeting_Edit_client_Job(Clientwise) {
        /////Ajax Start
        $.ajax({
            type: "POST",
            url: "../Handler/Project_Budgeting_Edit.asmx/Get_Project_Budgeting_Edit_client_Job",
            data: '{Compid:' + $("[id*=hdnCompid]").val() + ',CltId:' + $("[id*=drpclient]").val() + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (Clientwise == 1) {
                    $("[id*=drpclient]").empty();
                    $("[id*=drpclient]").append("<option value=0>--Select--</option>");
                    for (var i = 0; i < myList.length; i++) {
                        if (myList[i].Type == "Client") {
                            $("[id*=drpclient]").append("<option value='" + myList[i].ID + "'>" + myList[i].Name + "</option>");
                        } 
                    }
                }
                $("[id*=ddljob]").empty();
                $("[id*=ddljob]").append("<option value=0>--Select--</option>");

                for (var i = 0; i < myList.length; i++) {

                    if (myList[i].Type == "Job") {
                        $("[id*=ddljob]").append("<option value='" + myList[i].ID + "'>" + myList[i].Name + "</option>");
                    }

                }
                Get_Project_Budgeting_Edit_BudgetDetails(1, 25);

            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
        //////ajax end

    }
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
    .txtSize
    {
        width:50px;
        visibility:hidden;
        
        }
       .dateSize
       {
            width:120px;
           }
       .isNumeric
           {
            text-align:right;   
            } 
           
</style>
<div id="dvfilter">
<asp:HiddenField ID="hdnCompid" runat="server" />
<asp:HiddenField ID="hdnPages" runat="server" />
    <table runat="server" style="padding-top: 15px; padding-left: 105px; padding-right: 15px;
        width: 900px;">
        <tr>
            <td style="width: 25px">
                <asp:Label ID="Label7" Text="Client" runat="server" Font-Bold="True" CssClass="labelChange" />
            </td>
            <td>
                <select id="drpclient" runat="server" class="DropDown" style="width: 350px; height: 500px;">
                    <option value="0">--Select--</option>
                </select>
            </td>
            <td style="width: 25px" align="left">
                <asp:Label ID="Label1" Text="Job" runat="server" Font-Bold="True" CssClass="labelChange" />
            </td>
            <td>
                <select id="ddljob" runat="server" class="DropDown" style="width: 350px; height: 500px;">
                    <option value="0">--Select--</option>
                </select>
            </td>
        </tr>
    </table>
<div id="dvEditingTable" style="padding:20px">
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
    <table id="tblPager" style="border-left: 1px solid #BCBCBC; border-right: 1px solid #BCBCBC;
        border-top: 1px solid #BCBCBC; background-color: rgba(219,219,219,0.54); text-align: right;
        width: 1150px; border-bottom-style: none; border-bottom-color: inherit; border-bottom-width: medium;"
        cellpadding="2" cellspacing="0">
        <tr>
            <td>
                <div class="Pager">
                </div>
            </td>
        </tr>
    </table>

</div>
</div>
