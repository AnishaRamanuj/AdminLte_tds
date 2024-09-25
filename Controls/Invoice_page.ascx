<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Invoice_page.ascx.cs" Inherits="controls_Invoice_page" %>

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
            $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
            GetInvoice(1,25);

            $("[id*=dvInvoice]").show();
            $("[id*=dvEditInvoice]").hide();
            $("[id*=editsavedv]").hide();


            GetClient();

            getCurrency();

            $("[id*=btnAdd]").click(function () {
                $("[id*=dvInvoice]").hide();
                $("[id*=dvEditInvoice]").show();
                $("[id*=editsavedv]").show();
                reset();
            });

            $("[id*=btnCancel]").click(function () {

                $("[id*=dvInvoice]").show();
                $("[id*=dvEditInvoice]").hide();
                $("[id*=editsavedv]").hide();
            });

            $("[id*=drpclient]").change(function () {
                var client = $("[id*=drpclient]").val();
                if (client == '') {
                    return
                } else {
                    $("[id*=timesheets] tbody").empty();
                    $("[id*=lbltotHrs]").html('00.00');
                    $("[id*=lbltotAmt]").html('0.00');
                    GetProject();
                }
            });

            $("[id*=drpProject]").change(function () {
                var projid = $("[id*=drpProject]").val();
                if (projid == '') {
                    return;
                } else {
                    GetTimesheet();
                    GetExpense();
                }

            });

            $("[id*=BtnSrh]").click(function () {
                GetTimesheet();
                GetExpense();
            });

            $("[id*=btnSrch]").click(function () {
                GetInvoice(1, 25);
            });

            $("[id*=btnSave]").click(function () {
                var AllTSID = '',AllExpid = '';
                var Invoiceid = $("[id*=hdnInvoiceId]").val();

                $("input[name=chkTsid]").each(function () {
                    var chkprop = $(this).is(':checked');
                    if (chkprop) {
                        AllTSID = $(this).val() + ',' + AllTSID;
                    }
                });

                $("input[name=chkExp]").each(function () {
                    var chkpro = $(this).is(':checked');
                    if (chkpro) {
                        AllExpid = $(this).val() + ',' + AllExpid;
                    }
                });

                if (AllTSID == '') {
                    alert('Kindly Select atleast one Record!!');
                    return;
                }
                else {
                    if (parseFloat($("[id*=hdnInvoiceId]").val()) > 0) {
                        UpdateInvoice(Invoiceid, AllTSID, AllExpid);
                    } else {
                        InsertInvoice(AllTSID, AllExpid);
                    }
                }

            });



        });

        function UpdateInvoice(Invoiceid, AllTSID, AllExpid) {
            var Compid = $("[id*=hdnCompanyID]").val();

            var InvoiceNo = $("[id*=txtInvNo]").val();

            if (InvoiceNo == '') {
                alert('');
                return
            }
            var DueDate = $("[id*=txtDuedt]").val();
            var InvDate = $("[id*=txtcurrentdt]").val();
            var Fromdt = $("[id*=txtfrom]").val();
            var Todt = $("[id*=txtto]").val();
            var Cltid = $("[id*=drpclient]").val();
            var Projectid = $("[id*=drpProject]").val();
            var Curr = $("[id*=drpcurr]").val();
            var Hours = $("[id*=lbltotHrs]").html();
            var Amt = $("[id*=lblNettot]").html();
            var Inv = $("[id*=lblInvTotal]").html();
            var InvTax = $("[id*=txtInvtax]").val();
            var Exp = $("[id*=lblExptotal]").html();
            var ExpTax = $("[id*=txtExptax]").val();
            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/Update_Invoice",
                data: '{compid:' + Compid + ',InvoiceNo:"' + InvoiceNo + '",DueDate:"' + DueDate + '",InvDate:"' + InvDate + '",Fromdt:"' + Fromdt + '",Todt:"' + Todt + '",Cltid:' + Cltid + ',Projectid:' + Projectid + ',Curr:"' + Curr + '",AllTSID:"' + AllTSID + '",Hours:"' + Hours + '",Amt:"' + Amt + '",Invoiceid:' + Invoiceid + ',AllExpid:"' + AllExpid + '",Inv:"' + Inv + '",InvTax:"' + InvTax + '",Exp:"' + Exp + '",ExpTax:"' + ExpTax + '"}',
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
                            alert('Record Updated successfully !!!');
                            $("[id*=dvInvoice]").show();
                            $("[id*=dvEditInvoice]").hide();
                            $("[id*=editsavedv]").hide();
                            GetInvoice(1,25);
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

        ///reset while editing
        function reset() {
            $("[id*=txtInvNo]").val('');

            $("[id*=drpclient]").selectize()[0].selectize.destroy();
            $("[id*=drpclient]").val(0);
            $("[id*=drpclient]").selectize();

            $("[id*=drpProject]").selectize()[0].selectize.destroy();
            $("[id*=drpProject]").val(0);
            $("[id*=drpProject]").selectize();

            $("[id*=timesheets] tbody").empty();
            $("[id*=tblExp] tbody").empty();

            $("[id*=drpcurr]").val('INR');

            $("[id*=hdnInvoiceId]").val(0);

            $("[id*=lbltotHrs]").html('00.00');
            $("[id*=lbltotAmt]").html('0.00');
            $("[id*=lblInvTotal]").html('0.00');
            $("[id*=lblExptotal]").html('0.00');
            $("[id*=lblNettot]").html('0.00');
            $("[id*=lblExp]").html('0.00');
            $("[id*=txtInvtax]").val('0.00');
            $("[id*=txtExptax]").val('0.00');
        }

        function Delete_Invoice(i) {
            var row = i.closest("tr");
            var InvId = row.find("input[name=hdnInvId]").val();
            var compid = $("[id*=hdnCompanyID]").val();
            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/DeleteInvoice",
                data: '{compid:' + compid + ',InvId:' + InvId + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList.length > 0) {
                        if (myList[0].TSId == -1) {
                            // Duplicate Entry found Message
                            alert('Delete failed, Receipt Exist against this Invoice');
                        }
                        else {

                            // Save Entry found Message
                            alert('Record Deleted successfully !!!');
                      
                            GetInvoice(1, 25);
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

        ///Edit function
        function Edit_Invoice(i) {
            var row = i.closest("tr");
            var InvId = row.find("input[name=hdnInvId]").val();
            $("[id*=txtInvNo]").val($("td", row).eq(2).html());
            $("[id*=txtcurrentdt]").val($("td", row).eq(1).html());
            $("[id*=hdnInvoiceId]").val(InvId);

            var compid = $("[id*=hdnCompanyID]").val();

            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/Get_EditInvoice",
                data: '{compid:' + compid + ',InvId:' + InvId + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList.length > 0) {
                        $("[id*=txtDuedt]").val(myList[0].Due_date);
                        $("[id*=txtfrom]").val(myList[0].from_date);
                        $("[id*=txtto]").val(myList[0].to_date);

                        $("[id*=drpclient]").selectize()[0].selectize.destroy();
                        $("[id*=drpclient]").val(myList[0].cltid);
                        $("[id*=drpclient]").selectize();

                        GetProject(myList[0].projectid);

                        $("[id*=lbltotHrs]").html(myList[0].Hrs);
                        $("[id*=lblNettot]").html(myList[0].Charges);
                        $("[id*=lbltotAmt]").html(myList[0].InvAmt);
                        $("[id*=lblInvTotal]").html(myList[0].InvAmt);
                        $("[id*=lblExptotal]").html(myList[0].Exp);
                        $("[id*=lblExp]").html(myList[0].Exp);

                        $("[id*=txtInvtax]").val(myList[0].Invtax);
                        $("[id*=txtExptax]").val(myList[0].Exptax);

                        $("[id*=dvInvoice]").hide();
                        $("[id*=dvEditInvoice]").show();
                        $("[id*=editsavedv]").show();
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

        ////Bring the Invoice Details
        function GetInvoice(pageindex,pagesize) {
            var compid = $("[id*=hdnCompanyID]").val();
            var srch = $("[id*=txtInvsrch]").val();
            var drpsrch = $("[id*=drpsrch]").val();
            var drpinv = $("[id*=drpInv]").val();
     
            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/Get_Invoice",
                data: '{compid:' + compid + ',srch:"' + srch + '",drpsrch:"' + drpsrch + '",drpinv:"' + drpinv + '",pageindex:' + pageindex + ',pagesize:' + pagesize + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tbl = "";
                    $("[id*=tblInvoice] tbody").empty();

                    tbl = tbl + "<tr>";
                    tbl = tbl + "<th >Sr.No</th>";
                    tbl = tbl + "<th '>Invoice Date</th>";
                    tbl = tbl + "<th >Invoice.No</th>";
                    tbl = tbl + "<th class='labelChange'>Client</th>";
                    tbl = tbl + "<th class='labelChange'>Project</th>";
                    tbl = tbl + "<th >Amount</th>";
                    tbl = tbl + "<th >Receipt</th>";
                    tbl = tbl + "<th >Balance</th>";
                    tbl = tbl + "<th >Edit</th>";
                    tbl = tbl + "<th >Print</th>";
                    tbl = tbl + "<th >Delete</th>";
                    tbl = tbl + "</tr>";

                    if (myList.length > 0) {
                        for (var i = 0; i < myList.length; i++) {
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td style='text-align: center;width: 50px;'>" + myList[i].sino + " <input type='hidden' id='hdnInvId' value='" + myList[i].InvId + "' name='hdnInvId'></td>";
                            tbl = tbl + "<td >" + myList[i].InvDt + "</td>";
                            tbl = tbl + "<td >" + myList[i].InvNo + "</td>";
                            tbl = tbl + "<td >" + myList[i].ClientName + "</td>";
                            tbl = tbl + "<td >" + myList[i].Projectname + "</td>";
                            tbl = tbl + "<td style='width: 100px;text-align: right;'>" + myList[i].Charges + "</td>";
                            tbl = tbl + "<td style='width: 100px;text-align: right;'>" + myList[i].Receipt + "</td>";
                            tbl = tbl + "<td style='width: 100px;text-align: right;'>" + myList[i].Balance + "</td>";
                            tbl = tbl + "<td ><img src='../images/edit.png' style='cursor:pointer; height:18px; width:18px;' onclick='Edit_Invoice($(this))' id='btnEdit' name='btnEdit'></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ><img src='../images/delete.png' style='cursor:pointer; height:18px; width:18px;' onclick='Delete_Invoice($(this))' id='btnHDel' name='btnHDel'></td>";
                            tbl = tbl + "</tr>";
                        }
                        $("[id*=tblInvoice]").append(tbl);
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
                        $("[id*=tblInvoice]").append(tbl);
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
                GetInvoice(($(this).attr('page')), 25)
            });
        }

        ///Insert Invoice Details
        function InsertInvoice(AllTSID,AllExpid) {
            var Compid = $("[id*=hdnCompanyID]").val();

            var InvoiceNo = $("[id*=txtInvNo]").val();

            if (InvoiceNo == '') {
                alert('Kindly fill the Invoice No !!!');
                return
            }
            var DueDate = $("[id*=txtDuedt]").val();
            var InvDate = $("[id*=txtcurrentdt]").val();
            var Fromdt = $("[id*=txtfrom]").val();
            var Todt = $("[id*=txtto]").val();
            var Cltid = $("[id*=drpclient]").val();
            var Projectid = $("[id*=drpProject]").val();
            var Curr = $("[id*=drpcurr]").val();
            var Hours = $("[id*=lbltotHrs]").html();
            var Amt = $("[id*=lblNettot]").html();
            var Inv = $("[id*=lblInvTotal]").html();
            var InvTax = $("[id*=txtInvtax]").val();
            var Exp = $("[id*=lblExptotal]").html();
            var ExpTax = $("[id*=txtExptax]").val();
            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/Insert_Invoice",
                data: '{compid:' + Compid + ',InvoiceNo:"' + InvoiceNo + '",DueDate:"' + DueDate + '",InvDate:"' + InvDate + '",Fromdt:"' + Fromdt + '",Todt:"' + Todt + '",Cltid:' + Cltid + ',Projectid:' + Projectid + ',Curr:"' + Curr + '",AllTSID:"' + AllTSID + '",Hours:"' + Hours + '",Amt:"' + Amt + '",AllExpid:"' + AllExpid + '",Inv:"' + Inv + '",InvTax:"' + InvTax + '",Exp:"' + Exp + '",ExpTax:"' + ExpTax + '"}',
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
                            $("[id*=dvInvoice]").show();
                            $("[id*=dvEditInvoice]").hide();
                            $("[id*=editsavedv]").hide();
                            GetInvoice(1,25);
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

        function getCurrency() {
            var Compid = $("[id*=hdnCompanyID]").val();
            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/BindCurrency",
                data: '{compid:' + Compid + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    $("[id*=drpcurr]").empty();
                    $("[id*=drpcurr]").append("<option value=0>--Select--</option>");
                    for (var i = 0; i < myList.length; i++) {

                        $("[id*=drpcurr]").append("<option value='" + myList[i].Currency + "'>" + myList[i].Currency + "</option>");
                    }
                    $("[id*=drpcurr]").val('INR');
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

        ///function made for the calculn of total Hours and Amt
        function CalculationEXp() {

            var amtr = '0';

            $("input[name=chkExp]").each(function () {
                Assignrow = $(this).closest("tr");
                chk = $(this).is(':checked');
                amt = $("td", Assignrow).eq(4).html();
                
                if (chk == true) {
               
                    amtr = parseFloat(amtr) + parseFloat(amt);
                }
            });
            $("[id*=lblExp]").html(amtr + '.00');
            $("[id*=lblExptotal]").html(amtr + '.00');
            NetTotal();
        }
        ///function made for the calculn of total Hours and Amt
        function Calculation() {

            var amtr = '0';

            var tTime = '00:00';
            var FTime = '00:00';
            var totalHH = '00';
            var totalMM = '00';

            $("input[name=chkTsid]").each(function () {
                Assignrow = $(this).closest("tr");
                chk = $(this).is(':checked');
                amt = $("td", Assignrow).eq(5).html();
                var startTime = $("td", Assignrow).eq(4).html();
                if (chk == true) {
                    startTime = startTime.replace('.', ':');
                    var firstHH = startTime.split(':')[0];
                    var firstMM = startTime.split(':')[1];
                    tTime = tTime.replace('.', ':');
                    var endtHH = tTime.split(':')[0];
                    var endMM = tTime.split(':')[1];

                    totalHH = parseFloat(firstHH) + parseFloat(endtHH);
                    totalMM = parseFloat(firstMM) + parseFloat(endMM);

                    if (totalMM >= 60) {
                        var realmin = totalMM % 60;
                        var hours = Math.floor(totalMM / 60);
                        totalHH = parseFloat(totalHH) + parseFloat(hours);

                        totalMM = realmin;
                    }
                    if (totalMM < 10) {
                        totalMM = "0" + totalMM;
                    }

                    if (totalHH < 10) {
                        totalHH = "0" + totalHH;
                    }
                    FTime = totalHH + '.' + totalMM;

                    tTime = FTime;

                    amtr = parseFloat(amtr) + parseFloat(amt);
                }
            });
            $("[id*=lbltotAmt]").html(amtr + '.00');
            $("[id*=lbltotHrs]").html(tTime);
            $("[id*=lblInvTotal]").html(amtr + '.00');
            NetTotal();
        }

        function NetTotal() {
            var Inv = $("[id*=lblInvTotal]").html();
            var InvTax = $("[id*=txtInvtax]").val();
            var Exp = $("[id*=lblExptotal]").html();
            var Exptax = $("[id*=txtExptax]").val();

            var nettotal = 0.00;
            nettotal = parseFloat(Inv) + parseFloat(InvTax) + parseFloat(Exp) + parseFloat(Exptax);
            $("[id*=lblNettot]").html(nettotal+ '.00');
        }

        //select all (check box)
        function AllJobcheck(i) {
            var chkprop = i.is(':checked');

            if (chkprop) {
                $("[id*=chkTsid]").attr('checked', 'checked');

            }
            else {
                $("[id*=chkTsid]").removeAttr('checked');

            }
            Calculation();
        }

        function Allexpcheck(i) {
            var chkprop = i.is(':checked');

            if (chkprop) {
                $("[id*=chkExp]").attr('checked', 'checked');

            }
            else {
                $("[id*=chkExp]").removeAttr('checked');

            }
            CalculationEXp();
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


                    $("[id*=drpProject]").selectize();
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


        function GetProject(Projectid) {
            var Compid = $("[id*=hdnCompanyID]").val();
            var date = new Date();
            date = moment(date).format('MM/DD/YYYY');
            var Cltid = $("[id*=drpclient]").val();
            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/BindProject",
                data: '{compid:' + Compid + ',datec: "' + date + '",cltid:' + Cltid + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    $("[id*=drpProject]").selectize()[0].selectize.destroy();
                    $("[id*=drpProject]").empty();
                    $("[id*=drpProject]").append("<option value=0>--Select--</option>");
                    for (var i = 0; i < myList.length; i++) {

                        $("[id*=drpProject]").append("<option value='" + myList[i].ProjectID + "'>" + myList[i].ProjectName + "</option>");
                    }

                    if (parseFloat($("[id*=hdnInvoiceId]").val()) > 0) {
                        $("[id*=drpProject]").val(Projectid);
                        GetTimesheet();
                        GetExpense();
                    }

                    $("[id*=drpProject]").selectize({
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

        //expense table
        function GetExpense() {
            var Compid = $("[id*=hdnCompanyID]").val();
           
            var cltid = $("[id*=drpclient]").val();
            var projectid = $("[id*=drpProject]").val();
            var fromdt = $("[id*=txtfrom]").val();

            var todate = $("[id*=txtto]").val();

            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/BindExpense",
                data: '{compid:' + Compid + ',cltid:' + cltid + ',projectid:' + projectid + ',fromdt: "' + fromdt + '",todatee: "' + todate + '"}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tbl = "";
                    $("[id*=tblExp] tbody").empty();

                    tbl = tbl + "<tr>";
                    tbl = tbl + "<th  class='labelChange'>Staff</th>";
                    tbl = tbl + "<th >Date</th>";
                    tbl = tbl + "<th >Expense Name</th>";
                    tbl = tbl + "<th >Narration</th>";
                    tbl = tbl + "<th >Amount</th>";
                    tbl = tbl + "<th style='text-align: center;'><input type='checkbox' name='chlAll' id='chlAll' onclick='Allexpcheck($(this))'/></th>";
                    tbl = tbl + "</tr>";

                    if (myList.length > 0) {
                        for (var i = 0; i < myList.length; i++) {
                            tbl = tbl + "<tr>";
                            //tbl = tbl + "<td style='text-align: center;width: 50px;'>" + myList[i].SID + "</td>";
                            tbl = tbl + "<td >" + myList[i].StaffName + "</td>";
                           
                            tbl = tbl + "<td style='width: 60px;'>" + myList[i].ExpenseName + "</td>";
                            tbl = tbl + "<td style='width: 200px;'>" + myList[i].opeName + "</td>";
                            tbl = tbl + "<td style='width: 400px;'>" + myList[i].ExpenseNarr + "</td>";
                            tbl = tbl + "<td style='width: 150px;text-align: right;'>" + myList[i].Amount + "</td>";
                            if (parseFloat(myList[i].StaffCode) > 0) {

                                if (parseFloat($("[id*=hdnInvoiceId]").val()) == myList[i].StaffCode) {
                                    tbl = tbl + "<td style='text-align: center;'><input type='checkbox' onclick='CalculationEXp()' name='chkExp' id='chkExp' value='" + myList[i].Tsid + "' checked/></td>";
                                }
                                else {
                                    tbl = tbl + "<td style='text-align: center;'></td>";
                                }
                            } else {
                            tbl = tbl + "<td style='text-align: center;'><input type='checkbox' onclick='CalculationEXp()' name='chkExp' id='chkExp' value='" + myList[i].Tsid + "' /></td>";
                            }

                            tbl = tbl + "</tr>";
                        }
                        $("[id*=tblExp]").append(tbl);
                    }
                    else {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td > </td>";
                        tbl = tbl + "<td >No Record Found !!!</td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                  
                        tbl = tbl + "</tr>";
                        $("[id*=tblExp]").append(tbl);
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

        function GetTimesheet() {
            var Compid = $("[id*=hdnCompanyID]").val();
            var Billed = $("[id*=drpBill]").val();
            var cltid = $("[id*=drpclient]").val();
            var projectid = $("[id*=drpProject]").val();
            var fromdt = $("[id*=txtfrom]").val();

            var todate = $("[id*=txtto]").val();

            $.ajax({
                type: "POST",
                url: "../Handler/Invoice.asmx/BindTimesheet",
                data: '{compid:' + Compid + ',Billed: "' + Billed + '",cltid:' + cltid + ',projectid:' + projectid + ',fromdt: "' + fromdt + '",todatee: "' + todate + '"}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tbl = "";
                    $("[id*=timesheets] tbody").empty();

                    tbl = tbl + "<tr>";
                    tbl = tbl + "<th >Sr.No</th>";
                    tbl = tbl + "<th  class='labelChange'>Staff</th>";
                    tbl = tbl + "<th class='labelChange'>Activity</th>";
                    tbl = tbl + "<th >Date</th>";
                    tbl = tbl + "<th >Hours</th>";
                    tbl = tbl + "<th >Amount</th>";
                    tbl = tbl + "<th style='text-align: center;'><input type='checkbox' name='chlAll' id='chlAll' onclick='AllJobcheck($(this))'/></th>";
                    tbl = tbl + "</tr>";

                    if (myList.length > 0) {
                        for (var i = 0; i < myList.length; i++) {
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td style='text-align: center;width: 50px;'>" + myList[i].SID + "</td>";
                            tbl = tbl + "<td >" + myList[i].StaffName + "</td>";
                            tbl = tbl + "<td style='width: 400px;'>" + myList[i].mJobName + "</td>";
                            tbl = tbl + "<td style='width: 60px;'>" + myList[i].Date + "</td>";
                            tbl = tbl + "<td style='width: 60px;text-align: center;'>" + myList[i].BudHours + "</td>";
                            tbl = tbl + "<td style='width: 150px;text-align: right;'>" + myList[i].BudAmt + "</td>";
                            if (parseFloat(myList[i].Hod) > 0) {

                                if (parseFloat($("[id*=hdnInvoiceId]").val()) == myList[i].Hod) {
                                    tbl = tbl + "<td style='text-align: center;'><input type='checkbox' onclick='Calculation()' name='chkTsid' id='chkTsid' value='" + myList[i].TSId + "' checked/></td>";
                                }
                                else {
                                    tbl = tbl + "<td style='text-align: center;'></td>";
                                }
                            } else {
                                tbl = tbl + "<td style='text-align: center;'><input type='checkbox' onclick='Calculation()' name='chkTsid' id='chkTsid' value='" + myList[i].TSId + "' /></td>";
                            }

                            tbl = tbl + "</tr>";
                        }
                        $("[id*=timesheets]").append(tbl);
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
                        tbl = tbl + "</tr>";
                        $("[id*=timesheets]").append(tbl);
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
                    <asp:Label ID="Label4" runat="server" Style="margin-left: 10px;" Text="Invoice"></asp:Label>
                </td>
                            <td style="text-align:end;">            <div id="editsavedv">
                <input id="btnSave" type="button" class="cssButton labelChange" value="Save" />
                <input id="btnCancel" type="button" class="cssButton labelChange" value="Cancel" />
            </div></td>  
            </tr>
        </table>
        <asp:HiddenField ID="hdnCompanyID" runat="server" />
        <asp:HiddenField ID="hdnInvoiceId" runat="server" value="0"/>
        <asp:HiddenField ID="hdnPages" runat="server" />
    </div>
<div id="dvInvoice">
       <div style="float: right; width: 100%;padding-bottom:10px;">
                 
                        <div style="float: left; padding-left: 1px">
                            <div id="searchbr" runat="server" style="float: left; width: 100%; margin: 10px; padding-bottom: 5px; ">
                                <div style="float: left;" >
                                    <table>
                                        <tr>
                                            <td style="padding-right:20px;">
                                                <label style="font-weight:bold" class="LabelFontStyle labelChange">Search Client / Invoice No</label>
                                            
                                            </td>
                                        <td style="padding-right:20px;">
                                                             <select id="drpsrch" name="drpsrch" runat="server" class="DropDown" style="width: 80px; height: 25px;">
                    <option value="clt" selected>Client</option>
                                                                  <option value="inv" >Invoice No</option>
                                                             
                </select>
                                            </td>
                                            <td style="padding-right:20px;">
                                                <input type="text" id="txtInvsrch" name="txtInvsrch" class="texboxcls" style="width:250px;"/>
                                            </td>

                                                                                        <td style="padding-right:20px;">
                                                <label style="font-weight:bold" class="LabelFontStyle labelChange">Invoices</label>
                                            
                                            </td>
                                                                                                   <td style="padding-right:20px;">
                                                             <select id="drpInv" name="drpInv" runat="server" class="DropDown" style="width: 80px; height: 25px;">
                    <option value="All" selected>All</option>
                                                                  <option value="UnPaid" >UnPaid</option>
                                                                  <option value="Paid" >Paid</option>
                </select>
                                            </td>
                                            <td style="padding-right:20px;">
                                           <input id="btnSrch" type="button" class="cssButton labelChange" value="Search" />
                                            </td>
                                            <td>
                                               <input id="btnAdd" type="button" class="cssButton labelChange" value="Add Invoice" />
                                            </td>
                           
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
               
                </div>
    <div>
        <table id="tblInvoice" width="1175px" border="1px" class="norecordTble allTimeSheettle" style="border-collapse: collapse; padding-left: 120px;"></table>
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

<div id="dvEditInvoice">
    <table style="padding-top: 20px;">
                <tr>
                        <td style="width: 50px;"></td>
            <td style="width: 80px" align="left">
                <asp:Label ID="Label1" Text="Invoice No." runat="server" Font-Bold="True" CssClass="labelChange" /></td>
                     <td style="width: 50px;"></td>
            <td>
                <input type="text" id="txtInvNo" name="txtInvNo" class="texboxcls"/></td>
                    <td style="width: 50px;"></td>
                                <td style="width:90px;">
                <asp:Label ID="Label2" Text="Invoice Date" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
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
                    <td style="width: 50px;"></td>
                                       <td style="width:90px;" >
                <asp:Label ID="Label5" Text="Due Date" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
                     <td style="width: 50px;"></td>
                                                            <td style="width:200px;">
                                            <span style="float: left;">
                                                <asp:TextBox ID="txtDuedt" runat="server" CssClass="texboxcls" Width="80px"></asp:TextBox>
                                            </span>
                                            <div style="position: relative; float: left;">
                                                <asp:Image ID="Image4" runat="server" ImageUrl="~/images/calendar.png" />
                                            </div>
                                            <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtDuedt"
                                                PopupButtonID="Image4" Format="dd/MM/yyyy" Enabled="True">
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
            <td style="width: 50px;"></td>
            <td style="font-weight: bold;" class="labelChange">Project</td>
             <td style="width: 50px;"></td>
            <td>
                <select id="drpProject" name="drpProject" runat="server" class="DropDown" style="width: 230px; height: 25px;z-index:-1;">
                    <option value="0">--Select--</option>
                </select>
            </td>
            <td style="width: 50px;"></td>
            <td style="font-weight: bold;" class="labelChange">Curr</td>
                         <td style="width: 50px;"></td>
            <td>
                <select id="drpcurr" name="drpcurr" runat="server" class="DropDown" style="width: 100px; height: 25px;">
                    <option value="0">--Select--</option>
                </select></td>
        </tr>
        <tr>
            <td colspan="4" style="height: 15px;"></td>
        </tr>

    </table>
<div style="height:15px;">
        </div>
<asp:Panel ID="Panel1" runat="server">
                    <cc1:TabContainer ID="TabContainer1" runat="server" CssClass="property_tab" TabIndex="1"
                        AutoPostBack="false" ActiveTabIndex="0" BorderColor="Green" Style="padding-left: 15px"
                        Width="1185px" Height="600px">
                        <cc1:TabPanel ID="TabPanel1" runat="server" HeaderText="All Timesheet" ForeColor="Black"
                            Width="1100px">
                            <HeaderTemplate>
                                Invoice
                            </HeaderTemplate>
                            <ContentTemplate>
                                <table width="1175px" class="alltimteToptbl" style="border: 1px solid #CCC; margin-bottom: 0px;
                                    background: #F2F2F2; border-collapse: collapse; padding-left:15px; padding-right:15px;"">
                                    <tr>
                                        <td style="padding-left:50px;width:60px;">
                                            <asp:Label ID="Label10" Text="Status" runat="server" Font-Bold="True" />
                                        </td>
                                        <td style="width:200px;">
                                            <select id="drpBill" runat="server" class="DropDown" style="width: 100px;">
                                                <option value="0" selected>Non-Billed</option>
                                                <option value="1">Billed</option>
                                            </select>
                                        </td>
                                        <td style="width:60px;">
                                            <asp:Label ID="Label11" runat="server" Text="From" ForeColor="Black" Font-Bold="True"
                                                Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                                        </td>
                                        <td style="width:200px;">
                                            <span style="float: left;">
                                                <asp:TextBox ID="txtfrom" runat="server" CssClass="texboxcls" Width="80px"></asp:TextBox>
                                            </span>
                                            <div style="position: relative; float: left;">
                                                <asp:Image ID="Image2" runat="server" ImageUrl="~/images/calendar.png" />
                                            </div>
                                            <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtfrom"
                                                PopupButtonID="Image2" Format="dd/MM/yyyy" Enabled="True">
                                            </cc1:CalendarExtender>
                                        </td>
                                        <td style="width:60px;">
                                            <asp:Label ID="Label13" runat="server" Text="To" ForeColor="Black" Font-Bold="True"
                                                Font-Names="Verdana" Font-Size="9pt"></asp:Label>
                                        </td>
                                        <td style="width:200px;">
                                            <span style="float: left;">
                                                <asp:TextBox ID="txtto" runat="server" CssClass="texboxcls" Width="80px"></asp:TextBox>
                                            </span>
                                            <div style="float: left;">
                                                <asp:Image ID="Image3" runat="server" ImageUrl="~/images/calendar.png" />
                                            </div>
                                            <cc1:CalendarExtender ID="Calendarextender2" runat="server" TargetControlID="txtto"
                                                PopupButtonID="Image3" Format="dd/MM/yyyy" Enabled="True">
                                            </cc1:CalendarExtender>
                                        </td>
                                     
                                        <td >
                                            <input id="BtnSrh" class="cssButton" type="button" value="Search" />
                                        </td>
                                  
                                       
                                    </tr>
                                </table>
                                <div style="overflow:scroll; height:500px;">
                                    <table id="timesheets" width="1175px" border="1px" class="norecordTble allTimeSheettle" style="border-collapse: collapse; padding-left: 120px;">
                                  
                                    </table>
    
                                </div>
                                <div style="padding-top:20px;">
                                    <table>
                                        <tr>
                                            <td style="width: 800px;"></td>
                                            <td><asp:Label ID="Label3" Text="Total" runat="server" Font-Bold="True"  /></td>
                                            <td style="width:40px;"></td>
                                            <td><asp:Label ID="lbltotHrs" Text="00.00" runat="server" Font-Bold="True"/></td>
                                            <td style="width: 20px;"></td>
                                            <td style="text-align:right;width:140px;"><asp:Label ID="lbltotAmt" Text="0.00" runat="server" Font-Bold="True"/></td>
                                            
                                        </tr>
                                    </table>
                                </div>
                            </ContentTemplate>
                        </cc1:TabPanel>
                                    <cc1:TabPanel ID="tabPanel2" runat="server" ForeColor="Black">
                <HeaderTemplate>
                    <label id="Expense" runat="server" class="labelChange">
                        Expense</label>
                </HeaderTemplate>

                <ContentTemplate>
             
                        <div style="height:400px;overflow:scroll;">
                                        <table id="tblExp" width="1175px" border="1px" class="norecordTble allTimeSheettle" style="border-collapse: collapse; padding-left: 120px;">
                                  
                                    </table>
                        </div>
                      <div style="padding-top:20px;">
                                    <table>
                                        <tr>
                                            <td style="width: 850px;"></td>
                                            <td><asp:Label ID="Label6" Text="Total" runat="server" Font-Bold="True"  /></td>
                                            <td style="width:40px;"></td>
                                            
                                            
                                            <td style="text-align:right;width:140px;"><asp:Label ID="lblExp" Text="0.00" runat="server" Font-Bold="True"/></td>
                                            
                                        </tr>
                                    </table>
                                </div>
                 
                </ContentTemplate>
            </cc1:TabPanel>
                                    <cc1:TabPanel ID="tabPanel3" runat="server" ForeColor="Black">
                <HeaderTemplate>
                    <label id="TAX" runat="server" class="labelChange">
                        TAX</label>
                </HeaderTemplate>

                <ContentTemplate>
                  
                        <div style="padding-top:20px;">
                           <table >
                               <tr>
                                   <td style="width:50px;"></td>
                                   <td style="width: 200px" >
                <asp:Label ID="Label8" Text="Invoice Amount" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
                                                                      <td style="width: 200px;text-align:right" >
                <asp:Label ID="lblInvTotal" Text="0.00" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
                               </tr>
                               <tr><td colspan="3" style="height:15px;"></td></tr>
                               <tr><td style="width:50px;"></td>
                                   <td style="width: 200px" >
                <asp:Label ID="Label9" Text="TAX" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
                                   <td style="text-align:right;"><input style="text-align:right;" onchange="NetTotal();" type="text" value="0.00" id="txtInvtax" name="txtInvtax" class="texboxcls"/></td>
                               </tr>
                               <tr><td colspan="3" style="height:15px;"></td></tr>
                               <tr><td style="width:50px;"></td>
                                   <td style="width: 200px" >
                <asp:Label ID="Label12" Text="Net Expenses Amount" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
                                   <td style="width: 200px;text-align:right" >
                <asp:Label ID="lblExptotal" Text="0.00"  runat="server" Font-Bold="True" CssClass="labelChange" /></td>
                               </tr>
                               <tr><td colspan="3" style="height:15px;"></td></tr>
                               <tr><td style="width:50px;"></td>
                                   <td style="width: 200px" >
                <asp:Label ID="Label14" Text="TAX" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
                                   <td style="text-align:right;"><input style="text-align:right;" onchange="NetTotal();" value="0.00" type="text" id="txtExptax" name="txtExptax" class="texboxcls"/></td>
                               </tr>
                               <tr><td colspan="3" style="height:15px;"></td></tr>
                               <tr><td style="width:50px;"></td>
                                   <td style="width: 80px" >
                <asp:Label ID="Label15" Text="Net Invoice Amount" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
                                           <td style="width: 200px;text-align:right" >
                <asp:Label ID="lblNettot" Text="0.00" runat="server" Font-Bold="True" CssClass="labelChange" /></td>
                               </tr>
                   
                           </table>
                        </div>
                 
                </ContentTemplate>
            </cc1:TabPanel>
            
                    </cc1:TabContainer>
                </asp:Panel>

    </div>

