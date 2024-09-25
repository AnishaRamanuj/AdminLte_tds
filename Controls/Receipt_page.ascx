<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Receipt_page.ascx.cs" Inherits="controls_Receipt_page" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script src="../jquery/jquery-2.2.4.min.js" type="text/javascript"></script>
<script type="text/javascript" src="../jquery/moment.js"></script>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>

<script src="../jquery/Selectize/selectize.js" type="text/javascript"></script>
<script src="../jquery/Selectize/es5.js" type="text/javascript"></script>
<script src="../jquery/Selectize/index.js" type="text/javascript"></script>
<link href="../jquery/Selectize/normalize.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        $(document).ready(function () {


            $("[id*=dvReceipt]").show();
            $("[id*=dvEditReceipt]").hide();
            $("[id*=editsavedv]").hide();

            GetReceipt(1, 25);

            $("[id*=btnSrch]").click(function () {
                GetReceipt(1, 25);
            });

            $("[id*=btnAdd]").click(function () {
                $("[id*=dvReceipt]").hide();
                $("[id*=dvEditReceipt]").show();
                $("[id*=editsavedv]").show();
                reset();
            });

            $("[id*=btnCancel]").click(function () {

                $("[id*=dvReceipt]").show();
                $("[id*=dvEditReceipt]").hide();
                $("[id*=editsavedv]").hide();
            });

            GetClient();

            $("[id*=drpclient]").change(function () {
                var client = $("[id*=drpclient]").val();
                if (client == '') {
                    return
                } else {
                    GetInvoice();
                }
            });

            $("[id*=btnSave]").click(function () {
                var AllTSID = '';
                var Amt = $("[id*=txtReceiptAmt]").val();

                $("input[name=chkTsid]").each(function () {
                    var chkprop = $(this).is(':checked');
                    Assignrow = $(this).closest("tr");
                    amtt = $("td", Assignrow).eq(3).html();
                    if (chkprop) {
                        AllTSID = $(this).val() + ',' + amtt;
                    }
                });

                if (AllTSID == '') {
                    alert('Kindly Select atleast one Record!!');
                    return;
                }
                else {
                    var AllID = AllTSID.split(',')[1];
                    var Invoiceid = AllTSID.split(',')[0];

                    if (Amt == '0.00') {
                        alert('Kindly fill the Receipt Amount!!');
                        return;
                    }
                    else {
                        if (Amt > AllID) {
                            alert ('Kindly please check the Receipt Amount !!!')
                        }
                        else {
                            if (parseFloat($("[id*=hdnReceiptId]").val()) > 0) {
                                Update_Receipt(Amt, AllID, Invoiceid);
                            } {
                                InsertReceipt(Amt, AllID, Invoiceid);
                            }
                           
                        }
                    }
                }

            });
        });

        function Update_Receipt(Amt, InvoiceAmt, Invid) {
            var Compid = $("[id*=hdnCompanyID]").val();
            var RecptAmt = Amt;
            var Narra = $("[id*=txtNar]").val();
            var ReceiptNo = $("[id*=txtRecptNo]").val();
            var ReceiptDt = $("[id*=txtcurrentdt]").val();
            var MOP = $("[id*=drpInv]").val();
            var cltid = $("[id*=drpclient]").val();

            if (ReceiptNo == '') {
                alert('Kindly fill the Receipt No !!!');
                return
            }

            var Receptid = $("[id*=hdnReceiptId]").val();

            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/Update_Receipt",
                data: '{compid:' + Compid + ',ReceiptNo:"' + ReceiptNo + '",ReceiptDt:"' + ReceiptDt + '",Narra:"' + Narra + '",MOP:"' + MOP + '",Cltid:' + cltid + ',RecptAmt:"' + RecptAmt + '",InvoiceAmt:"' + InvoiceAmt + '",Invid:' + Invid + ',Receptid:' + Receptid + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList.length > 0) {
                        if (myList[0].TSId == -1) {
                            // Duplicate Entry found Message
                            alert('Save fail, duplicate record');
                        }
                        else {

                            // Save Entry found Message
                            alert('Record saved successfully !!!');
                            $("[id*=dvReceipt]").show();
                            $("[id*=dvEditReceipt]").hide();
                            $("[id*=editsavedv]").hide();
                            GetReceipt(1, 25);
                        }
                    }

                },
                failure: function (response) {
                    showErrorToast('Cant Connect to Server' + response.d);
                    //alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    showErrorToast('Error Occoured' + response.d);
                    //alert('Error Occoured ' + response.d);
                }
            });
        }


        function Edit_Receipt(i) {
            var row = i.closest("tr");
            var Rcpt = row.find("input[name=hdnRcptId]").val();
            var cltid = row.find("input[name=hdncltid]").val();
            var Narra = row.find("input[name=hdnNarra]").val();
            var MOT = row.find("input[name=hdnMop]").val();
           
            $("[id*=txtRecptNo]").val($("td", row).eq(2).html());
            $("[id*=txtcurrentdt]").val($("td", row).eq(1).html());
            $("[id*=txtReceiptAmt]").val($("td", row).eq(6).html());

            $("[id*=drpInv]").val(MOT);
            $("[id*=txtNar]").val(Narra);

            $("[id*=drpclient]").selectize()[0].selectize.destroy();
            $("[id*=drpclient]").val(cltid);
            $("[id*=drpclient]").selectize();

            $("[id*=dvReceipt]").hide();
            $("[id*=dvEditReceipt]").show();
            $("[id*=editsavedv]").show();

            $("[id*=hdnReceiptId]").val(Rcpt);

            GetInvoice();
        }

        function reset() {
            $("[id*=txtRecptNo]").val('');
            $("[id*=txtcurrentdt]").val();
            $("[id*=txtReceiptAmt]").val('0.00');

            $("[id*=drpclient]").selectize()[0].selectize.destroy();
            $("[id*=drpclient]").val(0);
            $("[id*=drpclient]").selectize();
            $("[id*=txtNar]").val('');
            $("[id*=tblInvoice] tbody").empty();
        }

        ////Bring the Invoice Details
        function GetReceipt(pageindex, pagesize) {
            var compid = $("[id*=hdnCompanyID]").val();
            var srch = $("[id*=txtRecptsrch]").val();
            var drpsrch = $("[id*=drpsrch]").val();

            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/Get_Receipt",
                data: '{compid:' + compid + ',srch:"' + srch + '",drpsrch:"' + drpsrch + '",pageindex:' + pageindex + ',pagesize:' + pagesize + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tbl = "";
                    $("[id*=tblReceipt] tbody").empty();

                    tbl = tbl + "<tr>";
                    tbl = tbl + "<th >Sr.No</th>";
                    tbl = tbl + "<th '>Receipt Date</th>";
                    tbl = tbl + "<th >Receipt.No</th>";
                    tbl = tbl + "<th class='labelChange'>Client</th>";
                    tbl = tbl + "<th class='labelChange'>Project</th>";
                    tbl = tbl + "<th >Inv Amt</th>";
                    tbl = tbl + "<th >Recpt Amt</th>";
                
                    tbl = tbl + "<th >Edit</th>";
                    tbl = tbl + "<th >Print</th>";
                    tbl = tbl + "<th >Delete</th>";
                    tbl = tbl + "</tr>";

                    if (myList.length > 0) {
                        for (var i = 0; i < myList.length; i++) {
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td style='text-align: center;width: 50px;'>" + myList[i].sino + " <input type='hidden' id='hdnRcptId' value='" + myList[i].InvId + "' name='hdnRcptId'> <input type='hidden' id='hdnNarra' value='" + myList[i].Narra + "' name='hdnNarra'></td>";
                            tbl = tbl + "<td >" + myList[i].InvDt + "</td>";
                            tbl = tbl + "<td >" + myList[i].InvNo + " </td>";
                            tbl = tbl + "<td >" + myList[i].ClientName + "<input type='hidden' id='hdncltid' value='" + myList[i].cltid + "' name='hdncltid'></td>";
                            tbl = tbl + "<td >" + myList[i].Projectname + "<input type='hidden' id='hdnMop' value='" + myList[i].Mop + "' name='hdnMop'></td>";
                            tbl = tbl + "<td style='width: 100px;text-align: right;'>" + myList[i].Charges + "</td>";
                            tbl = tbl + "<td style='width: 100px;text-align: right;'>" + myList[i].Receipt + "</td>";
        
                            tbl = tbl + "<td ><img src='../images/edit.png' style='cursor:pointer; height:18px; width:18px;' onclick='Edit_Receipt($(this))' id='btnEdit' name='btnEdit'></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ><img src='../images/delete.png' style='cursor:pointer; height:18px; width:18px;' onclick='Delete_Assign($(this))' id='btnHDel' name='btnHDel'></td>";
                            tbl = tbl + "</tr>";
                        }
                        $("[id*=tblReceipt]").append(tbl);
                        Pager(myList[0].Tcount);
                    }
                    else {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td > </td>"; 
                        tbl = tbl + "<td >No Record Found !!!</td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "</tr>";
                        $("[id*=tblReceipt]").append(tbl);
                        Pager(0);
                    }
                },
                failure: function (response) {
                    showErrorToast('Cant Connect to Server' + response.d);
                    //alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    showErrorToast('Error Occoured' + response.d);
                    //alert('Error Occoured ' + response.d);
                }
            });
        }

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
                GetReceipt(($(this).attr('page')), 25)
            });
        }

        function InsertReceipt(Amt,InvoiceAmt,Invid) {
            var Compid = $("[id*=hdnCompanyID]").val();
            var RecptAmt = Amt;
            var Narra = $("[id*=txtNar]").val();
            var ReceiptNo = $("[id*=txtRecptNo]").val();
            var ReceiptDt = $("[id*=txtcurrentdt]").val();
            var MOP = $("[id*=drpInv]").val();
            var cltid = $("[id*=drpclient]").val();

            if (ReceiptNo == '') {
                alert('Kindly fill the Receipt No !!!');
                return
            }

            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/Insert_Receipt",
                data: '{compid:' + Compid + ',ReceiptNo:"' + ReceiptNo + '",ReceiptDt:"' + ReceiptDt + '",Narra:"' + Narra + '",MOP:"' + MOP + '",Cltid:' + cltid + ',RecptAmt:"' + RecptAmt + '",InvoiceAmt:"' + InvoiceAmt + '",Invid:' + Invid + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList.length > 0) {
                        if (myList[0].TSId == -1) {
                            // Duplicate Entry found Message
                            alert('Save fail, duplicate record');
                        }
                        else {

                            // Save Entry found Message
                            alert('Record saved successfully !!!');
                            $("[id*=dvReceipt]").show();
                            $("[id*=dvEditReceipt]").hide();
                            $("[id*=editsavedv]").hide();
                            GetReceipt(1, 25);
                        }
                    }

                },
                failure: function (response) {
                    showErrorToast('Cant Connect to Server' + response.d);
                    //alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    showErrorToast('Error Occoured' + response.d);
                    //alert('Error Occoured ' + response.d);
                }
            });
        }

        function GetInvoice() {
            var Compid = $("[id*=hdnCompanyID]").val();
            var cltid = $("[id*=drpclient]").val();
            var Recptid = $("[id*=hdnReceiptId]").val();
            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/GetRecptInv",
                data: '{compid:' + Compid + ',cltid: ' + cltid + ',Recptid:' + Recptid + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
    
                    var tbl = "";
                    $("[id*=tblInvoice] tbody").empty();

                    tbl = tbl + "<tr>";
                    
                    tbl = tbl + "<th >Invoice.No</th>";
                    tbl = tbl + "<th '>Invoice Date</th>";
                    tbl = tbl + "<th class='labelChange'>Project</th>";
                    tbl = tbl + "<th >Amount</th>";
                    tbl = tbl + "<th style='text-align: center;'></th>";
                    tbl = tbl + "</tr>";

                    if (myList.length > 0) {
                        for (var i = 0; i < myList.length; i++) {
                            tbl = tbl + "<tr>";
                            
                            tbl = tbl + "<td >" + myList[i].InvNo + "</td>";
                            tbl = tbl + "<td >" + myList[i].InvDt + "</td>";
                            tbl = tbl + "<td >" + myList[i].Projectname + "</td>";
                            tbl = tbl + "<td style='width: 100px;text-align: right;'>" + myList[i].Balance + "</td>";
                            tbl = tbl + "<td style='text-align: center;'><input type='checkbox' onclick='checkboxes($(this))' name='chkTsid' id='chkTsid' value='" + myList[i].InvId + "' /></td>";
                            tbl = tbl + "</tr>";
                        }
                        $("[id*=tblInvoice]").append(tbl);
                     
                    }
                    else {
                        tbl = tbl + "<tr>";
                        
                        tbl = tbl + "<td > </td>";
                        tbl = tbl + "<td >No Record Found !!!</td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
            
           
                        tbl = tbl + "</tr>";
                        $("[id*=tblInvoice]").append(tbl);
                   
                    }


                },
                failure: function (response) {
                    showErrorToast('Cant Connect to Server' + response.d);
                    //alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    showErrorToast('Error Occoured' + response.d);
                    //alert('Error Occoured ' + response.d);
                }
            });
        }

        function checkboxes(i) {
            var chks = i.is(':checked');
            var rowr = i.closest("tr");
            if (chks == true) {
                $("input[name=chkTsid]").each(function () {
                    row = $(this).closest("tr");
                    chk = $(this).is(':checked');
                    if (chk == false) {
                        $("#chkTsid", row).attr("disabled", true);
                    }
                });
            } else {
                $("input[name=chkTsid]").each(function () {
                    row = $(this).closest("tr");
                    chk = $(this).is(':checked');
                    $("#chkTsid", row).attr("disabled", false);
                });
            }
        }

        function GetClient() {
            var Compid = $("[id*=hdnCompanyID]").val();
            var date = new Date();
            date = moment(date).format('MM/DD/YYYY');
            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/BindClient",
                data: '{compid:' + Compid + ',datec: "' + date + '"}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    $("[id*=drpclient]").selectize()[0].selectize.destroy();
                    $("[id*=drpclient]").empty();
                    $("[id*=drpclient]").append("<option value=0>--Select--</option>");
                    for (var i = 0; i < myList.length; i++) {

                        $("[id*=drpclient]").append("<option value='" + myList[i].CLTId + "'>" + myList[i].ClientName + "</option>");
                    }
                    $("[id*=drpclient]").selectize({
                    });


                   
                },
                failure: function (response) {
                    showErrorToast('Cant Connect to Server' + response.d);
                    //alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    showErrorToast('Error Occoured' + response.d);
                    //alert('Error Occoured ' + response.d);
                }
            });
        }
        </script>
  <style type="text/css">
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

        .cssPageTitle2 {
            font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
            /*border-bottom: 2px solid #0b9322;*/
            padding: 7px;
            color: #0b9322;
        }

        .cssPageTitle {
            font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
            border-bottom: 2px solid #0b9322;
            color: #0b9322;
        }

        .allTimeSheettle tr:hover {
            cursor: inherit;
            background: #F2F2F2;
            border: 1px solid #ccc;
            padding: 5px;
            color: #474747;
        }

        .allTimeSheettle {
            cursor: pointer;
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
    </style>

    <div class="divstyle" style="height: auto;padding-bottom:20px;">

        <table style="width: 100%" class="cssPageTitle">
            <tr>
                <td class="cssPageTitle2">
                    <asp:Label ID="Label4" runat="server" Style="margin-left: 10px;" Text="Receipt"></asp:Label>
                </td>
                            <td style="text-align:end;">            <div id="editsavedv">
                <input id="btnSave" type="button" class="cssButton labelChange" value="Save" />
                <input id="btnCancel" type="button" class="cssButton labelChange" value="Cancel" />
            </div></td>  
            </tr>
        </table>
        <asp:HiddenField ID="hdnCompanyID" runat="server" />
        <asp:HiddenField ID="hdnReceiptId" runat="server" value="0"/>
        <asp:HiddenField ID="hdnPages" runat="server" />
    </div>

<div id="dvReceipt">
       <div style="float: right; width: 100%;padding-bottom:10px;">
                 
                        <div style="float: left; padding-left: 1px">
                            <div id="searchbr" runat="server" style="float: left; width: 100%; margin: 10px; padding-bottom: 5px; ">
                                <div style="float: left;" >
                                    <table>
                                        <tr>
                                            <td style="padding-right:20px;">
                                                <label style="font-weight:bold" class="LabelFontStyle labelChange">Search Client / Receipt No</label>
                                            
                                            </td>
                                        <td style="padding-right:20px;">
                                                             <select id="drpsrch" name="drpsrch" runat="server" class="DropDown" style="width: 80px; height: 25px;">
                    <option value="clt" selected>Client</option>
                                                                  <option value="rcpt" >Receipt No</option>
                                                             
                </select>
                                            </td>
                                            <td style="padding-right:20px;">
                                                <input type="text" id="txtRecptsrch" name="txtRecptsrch" class="texboxcls" style="width:250px;"/>
                                            </td>


                                            <td style="padding-right:20px;">
                                           <input id="btnSrch" type="button" class="cssButton labelChange" value="Search" />
                                            </td>
                                            <td>
                                               <input id="btnAdd" type="button" class="cssButton labelChange" value="Add Receipt" />
                                            </td>
                           
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
               
                </div>
    <div>
        <table id="tblReceipt" width="1175px" border="1px" class="norecordTble allTimeSheettle" style="border-collapse: collapse; padding-left: 120px;"></table>
                 <table id="tblPager" style="border: 1px solid #BCBCBC; border-bottom: none; background-color: rgba(219,219,219,0.54); text-align: right; width:1175px;"
                    cellpadding="2" cellspacing="0" width="1100px">
                    <tr>
                        <td>
                            <div class="Pager">
                            </div>
                        </td>
                    </tr>
                </table>
    </div>
</div>

<div id="dvEditReceipt">
    <table style="padding-top: 20px;">
                <tr>
                        <td style="width: 50px;"></td>
            <td style="width: 80px" align="left">
                <asp:Label ID="Label1" Text="Receipt No." runat="server" Font-Bold="True" CssClass="labelChange" /></td>
                     <td style="width: 50px;"></td>
            <td>
                <input type="text" id="txtRecptNo" name="txtInvNo" class="texboxcls"/></td>
                    <td style="width: 50px;"></td>
                                <td style="width:90px;">
                <asp:Label ID="Label2" Text="Receipt Date" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
                     <td style="width: 50px;"></td>
                                                            <td style="width:200px;z-index:2;">
                                            <span style="float: left;">
                                                <asp:TextBox ID="txtcurrentdt" runat="server" CssClass="texboxcls" Width="80px"></asp:TextBox>
                                            </span>
                                            <div style="position: relative; float: left;z-index:2;">
                                                <asp:Image ID="Image1" runat="server" ImageUrl="~/images/calendar.png" />
                                            </div>
                                            <cc1:CalendarExtender ID="Calendarextender3" runat="server"  TargetControlID="txtcurrentdt"
                                                PopupButtonID="Image1" Format="dd/MM/yyyy" Enabled="True">
                                            </cc1:CalendarExtender>
                                        </td>
     
        </tr>
                <tr>
            <td colspan="4" style="height: 15px;"></td>
        </tr>
        <tr>
            <td style="width: 50px;"></td>
            <td style="width: 25px" align="left">
                <asp:Label ID="Label7" Text="Client" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
             <td style="width: 50px;"></td>
            <td>
                <select id="drpclient" name="drpclient" runat="server" class="DropDown" style="width: 230px; height: 25px;">
                    <option value="0">--Select--</option>
                </select></td>

 
        </tr>
        <tr>
            <td colspan="4" style="height: 15px;"></td>
        </tr>

    </table>
<div style="height:15px;">
        </div>
  
                                <div style="overflow:scroll; height:200px;">
                                    <table id="tblInvoice" width="1175px" border="1px" class="norecordTble allTimeSheettle" style="border-collapse: collapse; padding-left: 120px;">
                                  
                                    </table>
    
                                </div>
                                <div style="padding-top:20px;">
                                    <table>
                                        <tr>
                                            <td style="width:50px;"></td>
                                            <td> <label style="font-weight:bold" class="LabelFontStyle labelChange">Mode of Payment:</label></td>
                                            <td style="width:50px;"></td>
                                            <td><select id="drpInv" name="drpmop" runat="server" class="DropDown" style=" height: 25px;">
                                                                  <option value="Cash" >Cash</option>
                                                                  <option value="Funds_Transfer" selected>Funds Transfer</option>
                                                                  <option value="Cheque" >Cheque</option>
                                                <option value="Credit_Card" >Credit Card</option>
                                                <option value="Draft" >Draft</option>
                                              </select></td>
                                        </tr>
                                                        <tr>
            <td colspan="4" style="height: 15px;"></td>
        </tr>
                                        <tr>
                                             <td style="width:50px;"></td>
                                            <td><label style="font-weight:bold" class="LabelFontStyle labelChange">Narration:</label></td>
                                            <td style="width:50px;">
                                                </td>
                                            <td><input type="text" id="txtNar" name="txtNar" class="texboxcls" style="width:500px;"/></td>
                                        </tr>
                                                        <tr>
            <td colspan="4" style="height: 15px;"></td>
        </tr>
                                        <tr>
                                             <td style="width:50px;"></td>
                                            <td><label style="font-weight:bold" class="LabelFontStyle labelChange">Receipt Amount:</label></td>
                                            <td style="width:50px;"></td>
                                            <td><input type="text" style="text-align:right" id="txtReceiptAmt" name="txtReceiptAmt" class="texboxcls" value="0.00"/></td>
                                        </tr>
                                    </table>
                                </div>


    </div>