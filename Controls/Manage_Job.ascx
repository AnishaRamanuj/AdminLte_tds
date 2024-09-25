<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Manage_Job.ascx.cs" Inherits="controls_Manage_Job" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<script src="../jquery/dist/jquery.contextMenu.js" type="text/javascript"></script>
<link href="../jquery/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        var newDate = new Date();
        $("[id*=hdnDT]").val(newDate);
    });
    </script>
<style type="text/css">
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
        overflow: hidden;
        width: 1190px;
        height: 23px;
    }

    .headerpage {
        height: 23px;
    }

    .pagination {
        font-size: 80%;
    }

        .pagination a {
            text-decoration: none;
            border: solid 1.5px #55A0FF;
            color: #15B;
        }

        .pagination a, .pagination span {
            display: block;
            float: left;
            padding: 0.1em 0.5em;
            margin-right: 1px;
            margin-bottom: 2px;
        }

        .pagination .current {
            background: #26B;
            color: #fff;
            border: solid 1px #AAE;
        }

            .pagination .current.prev, .pagination .current.next {
                color: #999;
                border-color: #999;
                background: #fff;
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
    }

    .modalganesh {
        z-index: 999999;
    }

    .mytable th {
        padding: 3px;
        background-color: #F2F2F2;
        color: black;
        min-height: 25px;
        white-space: pre-wrap;
        border-color: #BCBCBC;
    }

    .mytable td {
        text-align: right;
        padding: 3px;
        border: 1px solid #BCBCBC;
    }
</style>
<script language="javascript" type="text/javascript">

    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });


        $("[id*= lblfrname]").on('click', function () {
            var sftrow = $(this).closest("tr");
            var Stf = sftrow.find("input[type=hidden]").val();
            var j = sftrow.find("input[type=hidden]").val();
            $("[id*=hdnJobid]").val('0');
            $("[id*=hdnJobid]").val(Stf);
            $("[id*=lblEpJob]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html())
            $("[id*=lblAjob]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html())
            $("[id*=lblAClient]").html($("td", $(this).closest("tr")).eq(2).find("[id*=lblClt]").html())
            $("[id*=lblEpClient]").html($("td", $(this).closest("tr")).eq(2).find("[id*=lblClt]").html())
            var t = $(this).position();
            openmenu(t.top, t.left);
        });

        $("[id*= btnEdit]").on('click', function () {

            var sftrow = $(this).closest("tr");
            var Stf = sftrow.find("input[type=hidden]").val();
            $("[id*=hdnJobid]").val('0');
            $("[id*=hdncode]").val('0');
            $("[id*=hdnJobid]").val(Stf);
            $("[id*=lblEpJob]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html())
            $("[id*=lblAjob]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html())
            $("[id*=lblAClient]").html($("td", $(this).closest("tr")).eq(2).find("[id*=lblClt]").html())
            $("[id*=lblEpClient]").html($("td", $(this).closest("tr")).eq(2).find("[id*=lblClt]").html())
            var t = $(this).position();
            openmenu(t.top, t.left);
        });


        // Job Status Change
        $("[id*= BtnSts]").live('click', function () {
            var sts = $("[id*=drpjobstatus]").val();
            var jobid = $("[id*=hdnJobid]").val();
            var compid = $("[id*=hdnCompanyid]").val();

            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/wsJob.asmx/insertJobStatus",
                data: "{jobid:" + jobid + ", cid:" + compid + ", sts:'" + sts + "'}",
                dataType: "json",
                success: function (msg) {

                    var myList = jQuery.parseJSON(msg.d);

                    alert(myList[0].Errmsg);
                    if (myList.length > 0) {
                        $find("ListModalPopupBehavior").hide();
                    }

                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //Ajax end
        });

        // Billable
        $("[id*= BtnBill]").live('click', function () {
            var bill = $("[id*=DrpBillable]").val();
            var jobid = $("[id*=hdnJobid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/wsJob.asmx/insertJobBillable",
                data: "{jobid:" + jobid + ", cid:" + compid + ", bill:'" + bill + "'}",
                dataType: "json",
                success: function (msg) {

                    var myList = jQuery.parseJSON(msg.d);

                    alert(myList[0].Errmsg);
                    if (myList.length > 0) {
                        $find("ListModalPopupBehavior").hide();
                    }
                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //Ajax end
        });

        // EndDate
        $("[id*= BtneDT]").live('click', function () {
            var endDT = $("[id*=TxtLNDate]").val();
            var jobid = $("[id*=hdnJobid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/wsJob.asmx/insertJobEndDT",
                data: '{jobid:' + jobid + ', cid:' + compid + ', endDT:"' + endDT + '"}',
                dataType: "json",
                success: function (msg) {

                    var myList = jQuery.parseJSON(msg.d);
                    if (myList.length > 0) {
                        if ("Job End Date Updated Successfully" == myList[0].Errmsg) {
                            $("[id*=hdngridJobId]").each(function () {
                                if ($(this).val() == $("[id*=hdnJobid]").val())
                                { $("td:eq(8)", $(this).closest("tr")).text(endDT); }
                            });
                            $find("ListModalPopupBehavior").hide();
                        }
                        alert(myList[0].Errmsg);
                    }
                    if (myList.length == 0) {
                        alert('Timesheet Exist, beyond the date');
                    }

                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //            //Ajax end
            //            return false;
        });


        // staff Check all
        $(".staffchkall").live('click', function () {
            ///CheckAll

            var parrentchk = $(this).find('input[type=checkbox]').is(':checked');
            /////////////check all department
            $("input[name=chkDeptname]").each(function () {
                if (parrentchk == true) {
                    $(this).attr('checked', 'checked');
                } else { $(this).removeAttr('checked'); }
            });

            $("input[name=chkSftname]").each(function () {
                if (parrentchk == true) {
                    $(this).attr('checked', 'checked');
                } else { $(this).removeAttr('checked'); }
            });

        });

        $("input[name=chkDeptname]").live('click', function () {

            var currentobj = $(this);

            var chkprop = currentobj.is(':checked');
            $("input[name=chkSftname]").each(function () {
                var sftrow = $(this).closest("tr");
                var hdndepid = sftrow.find("input[name=hdndepid]").val();
                if (hdndepid == currentobj.val()) {
                    if (chkprop) {
                        $(this).attr('checked', 'checked');
                    }
                    else {
                        $(this).removeAttr('checked');
                    }
                }
            });

        });

        // Approver
        $("[id*= btnAppr]").live('click', function () {
            var jobid = $("[id*=hdnJobid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            var sApp = $("[id*=drpdwnapp]").val();
            if (sApp == "") {
                alert('Please Select Super Approver');
                return false;
            }
            var hdnAllAppAjaxCode = "";
            $("input[name=chkAppname]").each(function () {
                var chkprop = $(this).is(':checked');
                if (chkprop) {
                    hdnAllAppAjaxCode = $(this).val() + ',' + hdnAllAppAjaxCode;
                }
            });

            if (hdnAllAppAjaxCode == "") {
                alert('Please Select At Least One Sub Approver');
                return false;
            }

            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/wsJob.asmx/insertJobApprover",
                data: "{jobid:" + jobid + ", cid:" + compid + ", appr:'" + hdnAllAppAjaxCode + "', sappr:" + sApp + "}",
                dataType: "json",
                success: function (msg) {

                    var myList = jQuery.parseJSON(msg.d);

                    alert(myList[0].Errmsg);
                    if (myList.length > 0) {
                        $find("ListModalPopupBhr").hide();
                    }
                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //Ajax end
        });
        //////////////////////////update single budget
        $("[id*=btnedtibudgesave]").live('click', function () {
            var datea = $("[id*=txtfromdate]").val();
            var amt = $("[id*=txteditHourlyAmount]").val();
            if (datea != "") {
                var start = $("[id*=txtstartdate]").val();
                var fa = start.split('/')
                var ta = datea.split('/')

                var a = new Date(fa[2], fa[1] - 1, fa[0]);
                var d = new Date(ta[2], ta[1] - 1, ta[0]); // for dd-MM-yyyy

                if (a > d) {
                    alert("Date Must be greater than Project Start Date !");
                    return false;
                }
                else {
                    $('.loader2').fadeIn(200); SetJobWiseBudgetDetails();
                    $find("mailingListModalPopupBehavior").hide();
                }
            }
            else { alert('Please Enter Date !'); }
            return false;
        });



        // Staff
        $("[id*= btnEmp]").live('click', function () {

            var jobid = $("[id*=hdnJobid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            var hdnAllstfCheckByAjaxCode = "";
            $("input[name=chkSftname]").each(function () {
                var chkprop = $(this).is(':checked');
                if (chkprop)
                { hdnAllstfCheckByAjaxCode = $(this).val() + ',' + hdnAllstfCheckByAjaxCode; }
            });
            if (hdnAllstfCheckByAjaxCode == "") {
                alert('Please Select At Least One staff');
                return false;
            }
            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/wsJob.asmx/insertJobStaff",
                data: "{jobid:" + jobid + ", cid:" + compid + ", stf:'" + hdnAllstfCheckByAjaxCode + "'}",
                dataType: "json",
                success: function (msg) {

                    var myList = jQuery.parseJSON(msg.d);

                    alert(myList[0].Errmsg);
                    if (myList.length > 0) {
                        $find("ListModalPopupBhr").hide();
                    }

                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //Ajax end
        });
        //////////////////////clear fileds in other budgeted amount popup
        $("[id*=btnEditbudgetclear]").live('click', function () {
            $("[id*=txtBamt]").val('0');
            $("[id*=txtBHours]").val('0');
            $("[id*=txtOBA]").val('0');
            $("[id*=txtfromdate]").val('');
            $("[id*=txtbudshowindate]").val('');
            $("[id*=txtstartdate]").val('');
            $("[id*=txtfromdate]").show();
            $("[id*=txtbudshowindate]").hide();
            $("[id*=txtstartdate]").hide();
            $("[id*=hdnJobwiseBudgetingtemp]").val('0');
            return false;
        });

    });
    function clareformEditStaffbudget() {
        $("[id*=Gridtimesheetdetails]").empty();
        $("[id*=txtBamt]").val('0');
        $("[id*=txtBHours]").val('0');
        $("[id*=txtOBA]").val('0');
        $("[id*=txtfromdate]").val('');
        $("[id*=txtstartdate]").val('');
        $("[id*=txtbudshowindate]").val('');
        $("[id*=txtfromdate]").show();
        $("[id*=txtbudshowindate]").hide();
        $("[id*=txtstartdate]").hide();
        $("[id*=hdnJobwiseBudgetingtemp]").val('0');

    }

    function SetJobWiseBudgetDetails() {
        var data = {
            id: {
                StaffCode: $("[id*=txtOBA]").val(),
                BudgetAmt: $("[id*=txtBamt]").val(),
                Budgethours: $("[id*=txtBHours]").val(),
                temp_Id: $("[id*=hdnJobwiseBudgetingtemp]").val(),
                fromdate: $("[id*=txtfromdate]").val(),
                jobid: $("[id*=hdnJobid]").val(),
                compid: $("[id*=hdnCompanyid]").val()
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "EditJobAdd.aspx/SetServerJobWiseBudgetDetails",
            data: JSON.stringify(data),
            dataType: "json",
            success: function (res) {
                if (res.d.length > 0) {
                    if (res.d[0].StaffCode == 'Error') {
                        alert('From Date Must Be Greater Than !');
                        $('.loader2').fadeOut(200);
                    }
                    else {
                        OnSuccess2(res);
                        alert('Save Successfully !');
                    }
                }
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        //Ajax end
    }

    ////////////////edit single budget
    function updatedata2(id) {
        $('.loader2').fadeIn(200);
        $("[id*=hdnJobwiseBudgetingtemp]").val(id);
        //        $("[id*=txtfromdate]").hide();
        //        $("[id*=txtbudshowindate]").show();
        $("[id*=txtfromdate]").show();
        $("[id*=txtbudshowindate]").hide();
        var data = {
            id: {
                StaffCode: 0,
                BudgetAmt: 0,
                Budgethours: 0,
                temp_Id: id,
                fromdate: 0
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "EditJobAdd.aspx/GetServerEditOnJobWiseTempId",
            data: JSON.stringify(data),
            dataType: "json",
            success: function (res) {

                if (res.d.length > 0) {
                    $("[id*=txtfromdate]").val(res.d[0].fromdate);
                    $("[id*=txtbudshowindate]").val(res.d[0].fromdate);
                    $("[id*=txtBHours]").val(res.d[0].Budgethours);
                    $("[id*=txtBamt]").val(res.d[0].BudgetAmt);
                    $("[id*=txtOBA]").val(res.d[0].StaffCode);
                }
                $('.loader2').fadeOut(550);
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        //Ajax end
    }

    /////update budget table
    function updateTempTablefromBudgetTable() {
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "EditJobAdd.aspx/updateTempTablefromBudgetTable",
            data: "{jobid:" + $("[id*=hdnJobid]").val() + ",compid:" + $("[id*=hdnCompanyid]").val() + "}",
            dataType: "json",
            success: OnSuccess2,
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        //Ajax end
    }



    //Budgeting Edit
    function GetJobWiseBudgetDetails() {
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "EditJobAdd.aspx/GetServerJobWiseBudgetDetails",
            data: "{jobid:" + $("[id*=hdnJobid]").val() + ",compid:" + $("[id*=hdnCompanyid]").val() + "}",
            dataType: "json",
            success: OnSuccess2,
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        //Ajax end
    }

    function OnSuccess2(response) {

        clareformEditStaffbudget();
        $("[id*=Gridtimesheetdetails]").append("<tr class='mytable'><th>Sr No.</th><th>From Date</th><th>To Date</th><th>Budgeted Amount</th><th>Budgeted Hours</th><th>Other Budgeted Amount</th><th></th></tr>");
        if (response.d.length > 0) {
            for (var i = 0; i < response.d.length; i++) {
                $("[id*=Gridtimesheetdetails]").append("<tr class='mytable'><td>" +
                            (i + 1) + "</td><td width='80px'>" + //sr no
                            response.d[i].fromdate + "</td> <td width='80px'>" + //FromDate
                            response.d[i].todate + "</td> <td>" + //Todate
                            response.d[i].BudgetAmt + "</td> <td>" + //Budget Amount
                            response.d[i].Budgethours + "</td><td>" + //Hours
                            response.d[i].StaffCode + "</td>" + //Other Amt
                            "<td><img src='../images/edit.png' style='cursor:pointer;' onclick=updatedata2(" + response.d[i].temp_Id + ") ></td></tr>");

                //Set Updated Amount & hours
                if (response.d[i].todate == '') {
                    $("[id*=txtbudhours]").val(response.d[i].Budgethours);
                    $("[id*=txtBudAmt]").val(response.d[i].BudgetAmt);
                    $("[id*=txtbudamtOth]").val(response.d[i].StaffCode);
                }
                $("[id*=txtstartdate]").val(response.d[0].fromdate);
            }
        }
        else {
            $("[id*=Gridtimesheetdetails]").append("<tr><td style='height:20px; border:1px solid #BCBCBC;' colspan='15'>No Records Found !</td></tr>");
        }
        $('.loader2').fadeOut(550);
    }

    function openmenu(tt, ll) {
        $.contextMenu({

            selector: '.context-menu-one',
            trigger: 'left',
            determinePosition: function ($menu) {
                $menu.css('display', 'block')
            .position({ my: "center top", at: "center bottom", of: this, offset: "0 5" })

            },
            callback: function (key, options) {
                if (key == "Other") {
                    document.getElementById('<%= btnpage.ClientID %>').click();
                }


                else {
                    modalShow(key);
                }

            },
            items: {
                "Edit": { name: "Edit", icon: function ($element, key, item) { return 'context-menu-icon context-menu-icon-quit'; } },
                "sep1": "---------",
                "Job": { name: "Job Status" },
                "endDT": { name: "End Date" },
                "Bill": { name: "Billable" },
                "Approver": { name: "Assign Approver" },
                "Staff": { name: "Assign Staff" },
                "Budget": { name: "Edit Budget" },
                "Other": { name: "Other details" }
            }
        });

    }

    var onecheck = 1;
    var twocheck = 1;
    var chekcall = 0;

    function modalShow(s) {

        //        if (s == 'Approver') {
        //            $find("mailingListModalPopupBehavior").show();
        //            var Stf = $("[id*=hdnJobid]").val();
        //            $("[id *= divBtn]").hide();
        //            $("[id *= Hrly]").show();
        //            $("[id *= Ln]").hide();
        //            $("[id *= Jn]").hide();
        //            $("[id *= pass]").hide();
        //            $("[id *= oth]").hide();
        //            BindHrlyGrd();
        //        }
        if (s == 'Budget') {
            $find("mailingListModalPopupBehavior").show();
            clareformEditStaffbudget();
            ///updateTempTablefromBudgetTable();
            $('.loader2').fadeIn(200);
            GetJobWiseBudgetDetails();
        }
        if (s == 'Bill') {
            $find("ListModalPopupBehavior").show();
            var jobid = $("[id*=hdnJobid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            $("[id*= Bill]").show();
            $("[id*= JSts]").hide();
            $("[id*= eDT]").hide();
            $("[id*= oth]").hide();


            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/wsJob.asmx/JobDetails",
                data: "{jobid:" + jobid + ", cid:" + compid + "}",
                dataType: "json",
                success: function (msg) {

                    var myList = jQuery.parseJSON(msg.d);
                    $("[id*=lblBjob]").html(myList[0].mJobName);
                    $("[id*=DrpBillable]").val(myList[0].bill);
                    $("[id*=lblBclient]").html(myList[0].ClientName);
                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //Ajax end

        }

        if (s == 'endDT') {
            $find("ListModalPopupBehavior").show();
            var jobid = $("[id*=hdnJobid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            $("[id*= eDT]").show();
            $("[id*= Bill]").hide();
            $("[id*= JSts]").hide();
            $("[id*= oth]").hide();

            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/wsJob.asmx/JobDetails",
                data: "{jobid:" + jobid + ", cid:" + compid + "}",
                dataType: "json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    $("[id*=lblEJob]").html(myList[0].mJobName);
                    $("[id*=lblEclient]").html(myList[0].ClientName);
                    $("[id*=lblSTDT]").html(myList[0].startDT);
                    $("[id*=TxtLNDate]").val(myList[0].endDT);
                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //Ajax end

        }

        if (s == 'Job') {

            $find("ListModalPopupBehavior").show();
            var jobid = $("[id*=hdnJobid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            $("[id*= JSts]").show();
            $("[id*= Bill]").hide();
            $("[id*= eDT]").hide();
            $("[id*= oth]").hide();


            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/wsJob.asmx/JobDetails",
                data: "{jobid:" + jobid + ", cid:" + compid + "}",
                dataType: "json",
                success: function (msg) {

                    var myList = jQuery.parseJSON(msg.d);

                    $("[id*=lblSjob]").html(myList[0].mJobName);
                    $("[id*=drpjobstatus]").val(myList[0].JobStatus);
                    $("[id*=lblSclient]").html(myList[0].ClientName);

                    // document.getElementById('<%=drpjobstatus.ClientID %>').value = myList[0].JobStatus
                    // document.getElementById('<%=lblSjob.ClientID %>').html = myList[0].mJobName


                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //Ajax end
        }

        if (s == 'Approver') {
            $find("ListModalPopupBhr").show();
            $("[id*= Appr]").show();
            $("[id*= Emp]").hide();

            var jobid = $("[id*=hdnJobid]").val();
            var compid = $("[id*=hdnCompanyid]").val();

            getApprover(jobid, compid);

        }

        if (s == 'Staff') {

            $find("ListModalPopupBhr").show();
            $("[id*=Emp]").show();
            $("[id*=Appr]").hide();

            var jobid = $("[id*=hdnJobid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            getDept(jobid, compid);
            getStaff(jobid, compid);
        }

        if (s == 'oth') {
            var Stf = $("[id*=hdngridStaffcode]").val();
            '<% Session["staff"] = "' + Stf + '"; %>';

            window.location.href = "editstaffdetails.aspx";
        }

    }


    // Getting Staff checklist box
    function getStaff(jobid, compid) {
        //        $('.loader2').show();
        $.ajax({
            type: "POST",
            url: "../Handler/wsJob.asmx/bindStaff",
            data: '{compid:' + compid + ',jobid:' + jobid + '}',
            dataType: 'json',
            contentType: "application/json; charsetdidil=utf-8",
            success: function (msg) {
                ///////////parse json query
                var myList = jQuery.parseJSON(msg.d);
                var tr;
                var vadfds = "";
                $("[id*=datalistSftName] tbody").remove();
                /////////staff 
                var checked = "";
                var rowno = 0;
                for (var i = 0; i < myList.length; i++) {
                    checked = "";
                    if (myList[i].ischecked == "1")
                    { checked = "checked"; }
                    else {
                        checked = "";
                    }
                    tr = ("<tr ><td>" + "<input type='checkbox' name='chkSftname' value='" + myList[i].StaffCode + "' " + checked + "><input type='hidden' name='hdndepid' value='" + myList[i].DeptId + "'>" + myList[i].StaffName + "</td></tr>");
                    $('#datalistSftName').append(tr);

                }
                twocheck = twocheck + 1;

                if (twocheck == onecheck) {
                    //  $('.loader2').hide();
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

    function getApprover(jobid, compid) {
        //        $('.loader2').show();
        $.ajax({
            type: "POST",
            url: "../Handler/wsJob.asmx/bindApprover",
            data: '{compid:' + compid + ',jobid:' + jobid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var tr;
                var vadfds = "";
                $("[id*=datalistSftApprover] tbody").remove();
                $("[id*=drpdwnapp]").empty();

                for (var i = 0; i < myList.length; i++) {
                    var vadfds = "";
                    var dstyle = "";
                    if (parseFloat(myList[i].ischecked) > 0) {
                        vadfds = 'checked';
                    }
                    else {
                    }
                    tr = ("<tr ><td>" + "<input type='checkbox' name='chkAppname' value='" + myList[i].StaffCode + "'" + vadfds + "><input type='hidden' name='hdnSdepid' value='" + myList[i].DeptId + "'>" + myList[i].StaffName + "</td></tr>");
                    $('#datalistSftApprover').append(tr);
                    $('#<%= drpdwnapp.ClientID %>').append("<option value='" + myList[i].StaffCode + "'>" + myList[i].StaffName + "</option>");

                }
                if (parseFloat(myList[0].SuperAppId) > 0) {
                    $("[id*=drpdwnapp]").val(myList[0].SuperAppId);
                }

                twocheck = twocheck + 1;

                if (twocheck == onecheck) {

                    // $('.loader2').hide();
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


    // getting Dept chklist box
    function getDept(jobid, compid) {
        //        $('.loader').show();
        try {
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJob.asmx/bindDept",
                data: '{compid:' + compid + ',jobid:' + jobid + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tr;
                    var vadfds = "";
                    $("[id*=datalistDeptName] tbody").remove();
                    for (var i = 0; i < myList.length; i++) {
                        vadfds = "";
                        if (parseFloat(myList[i].ischecked) > 0) {
                            vadfds = 'checked';
                        }
                        tr = $('<tr><td> <input type="checkbox" name="chkDeptname" value="' + myList[i].DeptId + '"' + vadfds + ' />' + myList[i].DepartmentName + '</td></tr>');
                        $('#datalistDeptName').append(tr);

                    }
                    //                    $('.loader').hide();
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



    $(function () {
        fromserverload();
    });


    function fromserverload() {
        $("[id*=lbldiff]").each(function () {
            var diff = $(this).html();
            if (diff != '') {
                if (parseFloat(diff) < 0) {
                    $(this).closest('tr').children('td,th').css('background-color', 'red');
                    $(this).closest('tr').children('td,th').css('color', '#F0F0F0');
                    $(this).closest('tr').children('td,th').css('font-weight', 'bold');
                    $(this).closest('tr').find("[id*=lblfrname]").css('font-weight', 'bold');
                    $(this).closest('tr').find("[id*=lblfrname]").css('color', '#F0F0F0');
                }
            }
        });
    }
</script>
<div id="divtotbody" class="testwhleinside">
    <%--<div align="right">
    </div>--%>
    <div id="divtitl" class="totbodycatreg">
        <div class="headerpage">
            <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
                <asp:Label ID="Label1" runat="server" Text="Manage Job" CssClass="Head1 labelChange"></asp:Label>
                <asp:HiddenField ID="hdnDT" runat="server" />
            </div>
        </div>
        <div style="float: left; width: 97%; padding-left: 10px" align="left">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
            <asp:HiddenField ID="hdnCntJob" runat="server" />
            <asp:HiddenField ID="hdnCompanyid" runat="server" />
            <asp:HiddenField ID="hdnJobid" runat="server" />
            <asp:HiddenField ID="hdncode" runat="server" />
            <asp:HiddenField ID="hdnPageINdex" runat="server" />
        </div>
        <div style="float: right; text-align: right; width: 100%; padding: 10px 0;">
            <div style="float: left;">
                <asp:Panel ID="Panel5" runat="server" DefaultButton="btnsrchjob">
                    <div id="divBtn" style="display: none;">
                        <asp:Button ID="btnpage" runat="server" Text="Edit" OnClick="btnpage_Click"></asp:Button>
                    </div>
                    <div style="float: left; width: 100%; margin: 10px; padding-bottom: 5px; overflow: auto;" id="searchjob" runat="server">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="Label21" runat="server" Font-Bold="true" Text="Filter By" CssClass="LabelFontStyle"></asp:Label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlSearchby" CssClass="DropDown labelChange" runat="server" Width="50px" Height="27px">
                                        <asp:ListItem>Job</asp:ListItem>
                                        <asp:ListItem>Client</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSearchby" CssClass="txtbox" runat="server" Width="250px" Height="25px"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Button ID="btnsrchjob" runat="server" CssClass="TbleBtns TbleBtnsPading" OnClick="btnsrchjob_Click"
                                        Text="Search" />
                                </td>
                                <td>
                                    <asp:Button ID="btnjob" runat="server" Text="Completed Jobs" CssClass="TbleBtns TbleBtnsPading labelChange"
                                        OnClick="Btnjob_Click" />
                                </td>
                                <td>
                                    <asp:Button ID="btnadd" runat="server" CssClass="TbleBtns TbleBtnsPading labelChange"
                                        OnClick="lnknewclient_Click" Text="Allocate Job" UseSubmitBehavior="False" />
                                </td>
                                <td>
                                    <asp:ImageButton ID="BtnExport" runat="server" ImageUrl="~/Images/xls-icon.png" Text="Export to Excel"
                                        OnClick="BtnExport_Click" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </asp:Panel>
            </div>
            <%--<asp:ImageButton ID="ImageButton1" runat="server" 
                    ImageUrl="~/images/addnew_1.jpg" OnClick="lnknewclient_Click" Width="69px" />--%>
            <%--<asp:LinkButton ID="lnkreset" runat="server" CssClass="lnkstle" OnClick="lnkreset_Click">Reset Job</asp:LinkButton> --%>
        </div>
        <div style="overflow: hidden; padding-bottom: 10px; width: 1170px; float: left; padding-left: 15px; padding-right: 10px;">
            <asp:GridView ID="Griddealers" runat="server" class="norecordTble" AutoGenerateColumns="False"
                Width="100%" OnRowCommand="Griddealers_RowCommand" DataKeyNames="JobId" OnPageIndexChanging="Griddealers_PageIndexChanging"
                EmptyDataText="No records found!!!" OnRowDataBound="Griddealers_RowDataBound" ShowHeaderWhenEmpty="true"
                PageSize="25">
                <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast"
                    PageButtonCount="20" Position="Bottom" />
                <PagerStyle CssClass="pagination" HorizontalAlign="Right" VerticalAlign="Middle" />
                <RowStyle Height="15px" />
                <Columns>
                    <asp:TemplateField HeaderStyle-CssClass="grdheader" HeaderText="Sr No.">
                        <ItemTemplate>
                            <div class="gridcolstyle" align="center">
                                <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text='<%# bind("sino") %>'></asp:Label>
                                <asp:Label ID="lblfid" runat="server" Visible="false" Text='<%# bind("JobId") %>'></asp:Label>
                                <asp:HiddenField ID="hdngridJobId" runat="server" Value='<%# bind("JobId") %>' />
                            </div>
                        </ItemTemplate>
                        <HeaderStyle CssClass="grdheader"></HeaderStyle>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Job" HeaderStyle-CssClass="grdheader">
                        <ItemTemplate>
                            <div style="width: 170px">
                                <asp:LinkButton ID="lblfrname" name="lblfrname" runat="server" CssClass="context-menu-one"
                                    Width="168px" Text='<%# bind("mJobName") %>'></asp:LinkButton>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="griditemstlert" />
                        <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Client" HeaderStyle-CssClass="grdheadermster">
                        <ItemTemplate>
                            <div class="gridpages" style="width: 170px">
                                <asp:Label ID="lblClt" runat="server" CssClass="gridpages" Width="168px" Text='<%# bind("ClientName") %>'></asp:Label>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="griditemstlert" />
                        <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                    </asp:TemplateField>


                    <asp:TemplateField HeaderText="Time Spend">
                        <ItemTemplate>
                            <div class="gridcolstyle" align="right">
                                <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text='<%# bind("Total") %>'></asp:Label>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="griditemstle4" />
                        <HeaderStyle CssClass="grdheader"></HeaderStyle>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Amount Spend">
                        <ItemTemplate>
                            <div class="gridcolstyle" align="right">
                                <asp:Label ID="Label6AmountSpend" Text='<%# bind("AmountSpend") %>' runat="server"
                                    CssClass="labelstyle"></asp:Label>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="griditemstle4" />
                        <HeaderStyle CssClass="grdheader"></HeaderStyle>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Start Date" HeaderStyle-CssClass="grdheader">
                        <ItemTemplate>
                            <div class="gridcolstyle">
                                <asp:Label ID="lblStartDate" runat="server" CssClass="labelstyle" Text='<%# bind("CreationDate") %>'></asp:Label>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="griditemstle2" />
                        <HeaderStyle CssClass="grdheader" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="End Date" HeaderStyle-CssClass="grdheader">
                        <ItemTemplate>
                            <div class="gridcolstyle">
                                <asp:Label ID="lblEndDate" runat="server" CssClass="labelstyle" Text='<%# bind("EndDate") %>'></asp:Label>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="griditemstle2" Width="70px" />
                        <HeaderStyle CssClass="grdheader" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Days Left" HeaderStyle-CssClass="grdheader">
                        <ItemTemplate>
                            <div class="gridcolstyle">
                                <asp:Label ID="lbldiff" runat="server" CssClass="labelstyle" Text='<%# bind("Diff") %>'></asp:Label>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="griditemstle2" />
                        <HeaderStyle CssClass="grdheader" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheader">
                        <ItemTemplate>
                            <div style="text-align: center">
                                <asp:ImageButton ID="btnEdit" runat="server" CssClass="context-menu-one" ImageUrl="~/images/edit.png"
                                    ToolTip="Edit" />
                            </div>
                        </ItemTemplate>
                        <HeaderStyle CssClass="grdheader" HorizontalAlign="Center"></HeaderStyle>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Delete" HeaderStyle-CssClass="grdheader">
                        <ItemTemplate>
                            <div style="overflow: hidden; width: 100%" align="center">
                                <asp:ImageButton ID="btndelete" runat="server" ImageUrl="~/images/Delete.png" CommandArgument='<%# bind("JobId") %>'
                                    CommandName="del" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                    ToolTip="Delete" />
                            </div>
                        </ItemTemplate>
                        <ItemStyle Width="60px" />
                        <HeaderStyle HorizontalAlign="Center" CssClass="grdheadermster" />
                    </asp:TemplateField>
                </Columns>
                <HeaderStyle CssClass="grdheader" />
            </asp:GridView>
            <div style="text-align: right;">
                <asp:Label runat="server" Style="float: left;" Font-Bold="true" ID="lblShowsGridRecords"></asp:Label>
                <asp:Button ID="BtnPrevious" runat="server" CssClass="TbleBtns TbleBtnsPading" Text="Previous"
                    OnClick="BtnPrevious_Click" />
                <asp:Button ID="BtnNext" runat="server" CssClass="TbleBtns TbleBtnsPading" Text="Next"
                    OnClick="BtnNext_Click" />
            </div>
        </div>
    </div>
    <div class="noteText">
        Notes:
        <div id="Div1" runat="server" class="txtboxNewError">
            <span class="labelstyle">Fields marked with * are required</span>
        </div>
    </div>
    <div class="reapeatItem4">
    </div>
    <div id="div2" class="seperotorrwr">
    </div>
    <div id="griddiv" class="totbodycatreg">
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
    </div>
    <div id="Div20" class="comprw">
        <cc1:ModalPopupExtender runat="server" ID="ModalPopup2" BehaviorID="ListModalPopupBehavior"
            TargetControlID="hdnLargeImage" PopupControlID="panel2" BackgroundCssClass="modalBackground"
            OkControlID="Close2" DropShadow="false" RepositionMode="RepositionOnWindowScroll">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="panel2" runat="server" Width="360px" Height="180px" BackColor="#FFFFFF">
            <asp:Button ID="hdnLargeImage" runat="server" Style="display: none" />
            <div id="Div3" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff; font-weight: bold;">
                <div id="Div7" style="width: 88%; float: left; height: 20px; padding-left: 2%; padding-top: 10px">
                    <asp:Label ID="Label7" runat="server" Text="Edit Details" CssClass="subHead1"></asp:Label>
                </div>
                <div id="Div8" style="width: 8%; float: left; padding-top: 1%; text-align: right;">
                    <img src="../images/error.png" id="Close2" border="0" name="Close2" />
                </div>
            </div>
            <div id="Bill" style="width: 360px; float: left; overflow: hidden; padding-top: 20px; padding-bottom: 5px; display: none;">
                <div id="Div9" style="width: 358px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 30px;">
                    <label class="labelChange">
                        Job:</label>
                    <asp:Label ID="lblBjob" runat="server"></asp:Label>
                </div>
                <div id="Div15" style="width: 358px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 30px;">
                    <label class="labelChange">
                        Client:</label>
                    <asp:Label ID="lblBclient" runat="server"></asp:Label>
                </div>
                <div id="Div31" style="width: 358px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 30px;">
                    <asp:Label ID="Label4" Text="Billable:" runat="server"></asp:Label>
                    <asp:DropDownList ID="DrpBillable" runat="server" CssClass="drp">
                        <asp:ListItem Value="1">Yes</asp:ListItem>
                        <asp:ListItem Value="0">No</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div id="Div4" align="center" style="width: 358px; float: left; overflow: hidden; font-weight: bold;">
                    <input id="BtnBill" value="Save" class="TbleBtns TbleBtnsPading" type="button" />
                </div>
            </div>
            <div id="eDT" style="width: 360px; float: left; overflow: hidden; padding-top: 20px; padding-bottom: 5px; display: none;">
                <div id="Div10" style="width: 358px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 30px;">
                    <label class="labelChange">
                        Job:</label>
                    <asp:Label ID="lblEJob" runat="server"></asp:Label>
                </div>
                <div id="Div16" style="width: 358px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 30px;">
                    <label class="labelChange">
                        Client:</label>
                    <asp:Label ID="lblEclient" runat="server"></asp:Label>
                </div>
                <div id="Div5" style="width: 358px; float: left; overflow: hidden; padding-left: 10px; height: 30px;">
                    <table width="358">
                        <tr>
                            <td>Start Date:
                            </td>
                            <td>
                                <asp:Label ID="lblSTDT" Text="" runat="server"></asp:Label>
                            </td>
                            <td></td>
                            <td>
                                <asp:Label ID="Label5" Text="End Date:" runat="server"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="TxtLNDate" runat="server" CssClass="txtnrml" Width="70px" CausesValidation="true"
                                    ValidationGroup="g"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd/MM/yyyy" PopupButtonID="ImgLn"
                                    TargetControlID="TxtLNDate">
                                </cc1:CalendarExtender>
                                <asp:Image ID="ImgLn" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ValidationGroup="g"
                                    ControlToValidate="TxtLNDate" Display="None" ErrorMessage="<b>RequiredField<br/>Please Enter Date</b>">*</asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender5" runat="server" HighlightCssClass="validatorCalloutHighlight"
                                    TargetControlID="RequiredFieldValidator3">
                                </cc1:ValidatorCalloutExtender>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ValidationGroup="g"
                                    ControlToValidate="TxtLNDate" Display="None" ErrorMessage="<b>Enter Date in dd/MM/yyyy format"
                                    ValidationExpression="^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d$">*</asp:RegularExpressionValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender6" runat="server" HighlightCssClass="validatorCalloutHighlight"
                                    TargetControlID="RegularExpressionValidator4">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="Div6" align="center" style="width: 358px; float: left; overflow: hidden; font-weight: bold;">
                    <input id="BtneDT" value="Save" class="TbleBtns TbleBtnsPading" type="button" />
                </div>
            </div>
            <div id="JSts" style="width: 360px; float: left; overflow: hidden; padding-top: 20px; padding-bottom: 5px; display: none;">
                <div id="Div12" style="width: 358px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 30px;">
                    <label class="labelChange">
                        Job:</label>
                    <asp:Label ID="lblSjob" runat="server"></asp:Label>
                </div>
                <div id="Div11" style="width: 358px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 30px;">
                    <label class="labelChange">
                        Client</label>
                    <asp:Label ID="lblSclient" runat="server"></asp:Label>
                </div>
                <div id="Div13" style="width: 358px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 30px;">
                    <asp:Label ID="Label9" Text="Job Status:" runat="server" CssClass="labelChange"></asp:Label>
                    <asp:DropDownList ID="drpjobstatus" runat="server" CssClass="DropDown" Width="100px">
                        <asp:ListItem Value="OnGoing">OnGoing</asp:ListItem>
                        <asp:ListItem Value="Completed">Completed</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div id="Div14" align="center" style="width: 358px; float: left; overflow: hidden; font-weight: bold;">
                    <input id="BtnSts" value="Save" class="TbleBtns TbleBtnsPading" type="button" />
                </div>
            </div>
        </asp:Panel>
        <cc1:ModalPopupExtender runat="server" ID="ModalPopup1" BehaviorID="ListModalPopupBhr"
            ClientIDMode="Static" TargetControlID="hdnImageBtn" PopupControlID="Mpanel1"
            BackgroundCssClass="modalBackground" OkControlID="Close1" DropShadow="false"
            RepositionMode="RepositionOnWindowScroll">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="Mpanel1" runat="server" Width="460px" Height="520px" BackColor="#FFFFFF">
            <asp:Button ID="hdnImageBtn" runat="server" Style="display: none" />
            <div id="Div17" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff; font-weight: bold;">
                <div id="Div18" style="width: 88%; float: left; height: 20px; padding-left: 2%; padding-top: 10px">
                    <asp:Label ID="Label3" runat="server" Text="Edit Details" CssClass="subHead1"></asp:Label>
                </div>
                <div id="Div19" style="width: 8%; float: left; padding-top: 1%; text-align: right;">
                    <img src="../images/error.png" id="Close1" border="0" name="Close1" />
                </div>
            </div>
            <div id="Appr" style="width: 460px; float: left; overflow: hidden; padding-top: 20px; padding-bottom: 5px; display: none;">
                <div id="Div22" style="width: 358px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 30px;">
                    <label class="labelChange">
                        Job:</label>
                    <asp:Label ID="lblAjob" runat="server"></asp:Label>
                </div>
                <div id="Div23" style="width: 458px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 30px;">
                    <label class="labelChange">
                        Client:</label>
                    <asp:Label ID="lblAClient" runat="server"></asp:Label>
                </div>
                <div id="Div24" style="width: 458px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px;">
                    <%--Sub Approver--%>
                    <div>
                        <div>
                            <div>
                                <asp:Label ID="Label11" runat="server" Text="Super Approver"></asp:Label>
                            </div>
                            <div class="boexs">
                                <asp:DropDownList ID="drpdwnapp" name="drpdwnapp" runat="server" CssClass="dropstyle"
                                    DataTextField="StaffName" DataValueField="StaffCode" Width="200px">
                                    <asp:ListItem Value="0">--Select one--</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div>
                            <div style="padding: 0 0 5px;">
                                <asp:Label ID="Label19" runat="server" Text="Sub Approver"></asp:Label>
                                <asp:Label ID="Label46" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
                            </div>
                        </div>
                        <div style="width: 458px; height: 280px">
                            <asp:Panel ID="Panel23" runat="server" Height="240px" ScrollBars="Vertical" Style="border: 1px solid #ccc; overflow: auto; width: 358px; float: left; padding: 5px;">
                                <div style="height: 280px; margin-right: 0px;">
                                    <table id="datalistSftApprover">
                                    </table>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
                <div id="Div25" align="center" style="width: 458px; float: left; overflow: hidden; font-weight: bold;">
                    <input id="btnAppr" value="Save" class="TbleBtns TbleBtnsPading" type="button" />
                </div>
            </div>
            <div id="Emp" style="width: 460px; float: left; overflow: hidden; padding-top: 20px; padding-bottom: 5px; display: none;">
                <div id="Div27" style="width: 458px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 30px;">
                    <label class="labelChange">
                        Job:</label>
                    <asp:Label ID="lblEpJob" runat="server"></asp:Label>
                </div>
                <div id="Div28" style="width: 458px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 30px;">
                    <label class="labelChange">
                        Client:</label>
                    <asp:Label ID="lblEpClient" runat="server"></asp:Label>
                </div>
                <div id="Div29" style="width: 458px; float: left; overflow: hidden; padding-left: 10px; height: 350px;">
                    <table style="height: 300px">
                        <tr>
                            <td>
                                <div>
                                    <asp:Label ID="Label14" runat="server" CssClass="labelstyle labelChange" Text="Department"></asp:Label>
                                </div>
                                <div>
                                    <asp:Panel ID="Panel4" runat="server" Height="280px" ScrollBars="Vertical" Style="margin: 8px 0 0; overflow: auto; width: 200px; padding: 5px; border: 1px solid #ccc; float: left;">
                                        <div style="height: 260px; margin-right: 0px;">
                                            <table id="datalistDeptName">
                                            </table>
                                        </div>
                                    </asp:Panel>
                                </div>
                            </td>
                            <td>
                                <div style="width: 5px">
                                </div>
                            </td>
                            <td>
                                <div>
                                    <asp:CheckBox ID="chkall" runat="server" Text="Check All" CssClass="staffchkall" />&nbsp;
                                    <asp:Label ID="Label15" runat="server" CssClass="labelstyle" Text="Staff"></asp:Label>
                                </div>
                                <div>
                                    <asp:Panel ID="Panel3" runat="server" Height="280px" ScrollBars="Vertical" Style="overflow: auto; margin: 8px 0 0; border: 1px solid #ccc; padding: 5px; width: 200px; float: left;">
                                        <div style="height: 260px; margin-right: 0px;">
                                            <table id="datalistSftName">
                                            </table>
                                        </div>
                                    </asp:Panel>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="Div30" align="center" style="width: 458px; float: left; overflow: hidden; font-weight: bold;">
                    <input id="btnEmp" value="Save" class="TbleBtns TbleBtnsPading" type="button" />
                </div>
            </div>
        </asp:Panel>
    </div>
    <div>
        <asp:Button ID="hiddenLargeImage" runat="server" Style="display: none" />
        <cc1:ModalPopupExtender runat="server" ID="ModalPopupExtender1" BehaviorID="mailingListModalPopupBehavior"
            TargetControlID="hiddenLargeImage" PopupControlID="panelupgrade" BackgroundCssClass="modalBackground"
            OkControlID="imgClose" DropShadow="false" RepositionMode="RepositionOnWindowScroll">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="panelupgrade" runat="server" Width="450px" BackColor="#FFFFFF">
            <div id="Div59" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff; font-weight: bold;">
                <div id="Div21" style="width: 90%; float: left; height: 20px; padding-left: 2%; padding-top: 1%">
                    <asp:Label ID="Label12" runat="server" Text="Job Wise Budgeting:" CssClass="subHead1"></asp:Label>
                </div>
                <div id="Div60" class="ModalCloseButton">
                    <img src="../images/error.png" id="imgClose" border="0" name="imgClose" />
                </div>
            </div>
            <br />
            <table align="center" width="50%">
                <tr>
                    <td>
                        <asp:HiddenField ID="hdnJobwiseBudgetingtemp" runat="server" />
                        From Date
                    </td>
                    <td>
                        <asp:TextBox ID="txtfromdate" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                        <asp:TextBox ID="txtbudshowindate" ReadOnly="true" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                        <asp:TextBox ID="txtstartdate" ReadOnly="true" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtfromdate"
                            Mask="99/99/9999" MaskType="Date" MessageValidatorTip="true" />
                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtfromdate"
                            PopupButtonID="txtfromdate" Format="dd/MM/yyyy" Enabled="True">
                        </cc1:CalendarExtender>
                    </td>
                </tr>
                <tr>
                    <td>Budget Amount
                    </td>
                    <td>
                        <asp:TextBox ID="txtBamt" runat="server" CssClass="txtbox calbox" Width="90px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>Budget Hours
                    </td>
                    <td>
                        <asp:TextBox ID="txtBHours" runat="server" CssClass="txtbox calbox" Width="90px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>Other Budget Amount
                    </td>
                    <td>
                        <asp:TextBox ID="txtOBA" runat="server" CssClass="txtbox calbox" Width="90px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table align="center">
                            <tr>
                                <td>
                                    <input id="btnedtibudgesave" class="TbleBtns" type="button" value="Save" />
                                </td>
                                <td>
                                    <input id="btnEditbudgetclear" class="TbleBtns" type="button" value="Clear" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <table align="center">
                <tr>
                    <td>
                        <%--<asp:GridView ID="Gridtimesheetdetails" runat="server">
                                <RowStyle Height="15px" />
                                <Columns>
                                    <asp:BoundField ItemStyle-Width="150px" DataField="fromdate" HeaderText="CustomerID" />
                                    <asp:BoundField ItemStyle-Width="150px" DataField="BudgetAmt" HeaderText="CustomerID" />
                                    <asp:BoundField ItemStyle-Width="150px" DataField="Budgethours" HeaderText="City" />
                                </Columns>
                            </asp:GridView>--%>
                        <table id="Gridtimesheetdetails" width="100%" style="border-collapse: collapse;" border="1"></table>
                    </td>
                </tr>
            </table>
            <div id="Div26">
                <div class="loader2">
                </div>
            </div>
        </asp:Panel>
    </div>
</div>
