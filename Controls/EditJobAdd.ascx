<%@ Control Language="C#" AutoEventWireup="true" CodeFile="EditJobAdd.ascx.cs" Inherits="controls_EditJobAdd" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/StyleSkin.css" rel="stylesheet" type="text/css" />
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<style type="text/css">
    .ajax__tab_container
    {
        color: Black;
    }
    .property_tab .ajax__tab_outer .ajax__tab_inner .ajax__tab_tab
    {
        margin-right: 0;
    }
    .property_tab .ajax__tab_header
    {
        font-family: verdana,tahoma,helvetica;
        font-size: 12px;
    }
    .property_tab .ajax__tab_outer
    {
        background: none;
        height: auto;
        margin: 0 5px 0 0;
    }
    .property_tab .ajax__tab_inner
    {
        background: none repeat scroll 0 0 #F2F2F2;
        border: 1px solid #CCCCCC;
        border-bottom: none;
        padding: 0px;
        color: #474747;
        border-radius: 5px 5px 0 0;
    }
    .property_tab .ajax__tab_tab
    {
        background: none repeat scroll 0 0 rgba(0, 0, 0, 0);
        font-weight: bold;
        height: 13px;
        margin: 0;
        padding: 8px 15px;
    }
    .property_tab .ajax__tab_hover .ajax__tab_outer
    {
    }
    .property_tab .ajax__tab_hover .ajax__tab_inner
    {
    }
    .property_tab .ajax__tab_hover .ajax__tab_tab
    {
        background: #DFDFDF;
    }
    .property_tab .ajax__tab_active .ajax__tab_outer
    {
    }
    .property_tab .ajax__tab_active .ajax__tab_inner
    {
    }
    .property_tab .ajax__tab_active .ajax__tab_tab
    {
        background: #1464F4;
        color: #fff;
        border-radius: 5px 5px 0 0;
    }
    .property_tab .ajax__tab_body
    {
        font-family: verdana,tahoma,helvetica;
        font-size: 10pt;
        border: 1px solid #999999;
        border-top: 0;
        padding: 8px;
        background-color: #ffffff;
        width: 800px;
    }
    
    .modalBackground
    {
        background-color: Gray;
        filter: alpha(opacity=70);
        opacity: 0.7;
    }
    .error
    {
        color: #D8000C;
        background-color: #FFBABA;
        background-image: url('images/error.png');
    }
    .property_tab
    {
    }
    .property_tab
    {
    }
    .txtnrml
    {
    }
    
    
    .ajax__calendar .ajax__calendar_container
    {
        background-color: #FFFFFF;
        border: 1px solid #646464;
        color: #000000;
        z-index: 9;
    }
    
    #content
    {
        overflow: hidden !important;
    }
    
    .loader
    {
        display: none;
        margin-top: 23px;
        padding-bottom: 35px;
        position: absolute;
        left: 0px;
        top: 0px;
        width: 100%;
        height: 100%;
        z-index: 9999;
        background: rgba(0,0,0,0.3) url(../images/progress-indicator.gif) center center no-repeat;
    }
    
    .loader2
    {
        display: none;
        margin-top: 23px;
        padding-bottom: 35px;
        position: absolute;
        left: 0px;
        top: 0px;
        width: 100%;
        height: 100%;
        z-index: 9999;
        background: rgba(0,0,0,0.3) url(../images/progress-indicator.gif) center center no-repeat;
    }
    
    
    .mytable th
    {
        padding: 3px;
        background-color: #F2F2F2;
        color: black;
        min-height: 25px;
        white-space: pre-wrap;
        border-color: #BCBCBC;
    }
    .mytable td
    {
        text-align: right;
        padding: 3px;
        border: 1px solid #BCBCBC;
    }
</style>
<script type="text/javascript">
    /////////////////pget load
    $(document).ready(function () {
        //////////////////////////page event start

        // BudgetingChange();
        ///////////for html created text box in staff budgeting tab and all text box used integer 
        $(".calbox").live('keydown', function (event) {
            if (event.keyCode == 8 || event.keyCode == 9) {
            } else {
                if (event.keyCode < 95) {
                    if (event.keyCode < 48 || event.keyCode > 57) {
                        event.preventDefault();
                    }
                } else {
                    if (event.keyCode < 96 || event.keyCode > 105) {
                        event.preventDefault();
                    }
                }
            }
        });

        //////////Edit budget click show popup
        $("[id*=Btn1]").live('click', function () {
            if (bug_for_clickon_project_budgeting == 1) {
                $find("mailingListModalPopupBehavior").show();
                clareformEditStaffbudget();
                $('.loader2').fadeIn(200);
                GetJobWiseBudgetDetails();
            }
            bug_for_clickon_project_budgeting = 1;
            return false;
        });

        //////////////////////clear fileds in other budgeted amount popup
        $("[id*=btnEditbudgetclear]").live('click', function () {
            $("[id*=txtBamt]").val('0');
            $("[id*=txtBHours]").val('0');
            $("[id*=txtOBA]").val('0');
            $("[id*=txtfromdate]").val('');
            $("[id*=txtbudshowindate]").val('');
            $("[id*=txtfromdate]").show();
            $("[id*=txtbudshowindate]").hide();
            $("[id*=hdnJobwiseBudgetingtemp]").val('0');
            return false;
        });

        ///////////////////////modal popup save and update btn
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
                else { $('.loader2').fadeIn(200); SetJobWiseBudgetDetails(); }
            }
            else { alert('Please Enter Date !'); }
            return false;
        });

        ///////////////////staff budget modal popup claer fields btn
        $("[id*=Button1]").live('click', function () {
            clearform();
            return false;
        });

        /////////////////////tab staff budgeting, edit on staff budget
        $("[id*=btnEditedStaffBudgetdAmtHours]").live('click', function () {

            var datea = $("[id*=txteditStaffBudgetedDate]").val();
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
                else { SaveOrUpeateDateBudget(); }
            }
            else { alert('Please Enter Date !'); }
            return false;
        });
        /////////////////////////tab2 assign Staff on selection
        /////////////////////////chk chkSftname 
        $("input[name=chkSftname]").live('click', function () {
            AssignStafftoStaffBudgeting();
        });
        /////////////////////////budgeting drop down change
        $("[id*=ddlBudgetingselection]").live("change", function () {
            BudgetingChange();
        });


        ////////////////////////////////tab2 assign staff check all
        $(".staffchkall").live('click', function () {
            ///CheckAll
            $('.loader').show();
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

            $("input[name=chkStaffBudgetCheckEmp]").each(function () {
                if (parrentchk == true) {
                    $(this).attr('checked', 'checked'); $(this).closest("tr").css('display', '');
                } else { $(this).removeAttr('checked'); $(this).closest("tr").hide(); }
            });

            $('.loader').hide();

        });

        ////////////staff budgeting---- Staff Wise Edit buttonclick
        $("#btnEditsingleStaffBudget").live('click', function () {

            $("[id*=lblStaffBudgetName]").html('');
            $("[id*=lblStaffDept]").html('');
            $("[id*=gvCustomers]").empty();
            $find("StaffBudgetingpopup").show();

            var row = $(this).closest("tr");
            var staffcode = $("#hdnStaffCode", row).val();
            $('.loader').fadeIn(200);
            $("[id*=hdnEditClickStaffcode]").val(staffcode);
            AjaxGetStaffNameAndDepartment();
            AjaxBindGridDataUsing();
            return false;
        });

        ////////////btn save
        $("[id*=btnsave]").live('click', function () {
            var hdnAllstfCheckByAjaxCode = "";
            var hdnAllDepAjaxCode = "";
            var hdnAllAppAjaxCode = "";

            $("input[name=chkSftname]").each(function () {
                var chkprop = $(this).is(':checked');
                if (chkprop)
                { hdnAllstfCheckByAjaxCode = $(this).val() + ',' + hdnAllstfCheckByAjaxCode; }
            });

            if (hdnAllstfCheckByAjaxCode == "") {
                alert('Please Select At Least One staff');
            }

            $("[id*=hdnAllstfCheckByAjaxCode]").val(hdnAllstfCheckByAjaxCode);

            // Approver
            $("input[name=chkAppname]").each(function () {
                var chkprop = $(this).is(':checked');
                if (chkprop) {
                    hdnAllAppAjaxCode = $(this).val() + ',' + hdnAllAppAjaxCode;
                    var sftrow = $(this).closest("tr");
                    var hdnDepid = sftrow.find("input[name=hdnSdepid]").val();
                    hdnAllDepAjaxCode = hdnDepid + ',' + hdnAllDepAjaxCode;
                }

            });

            if (hdnAllAppAjaxCode == "") {
                alert('Please Select At Least One Sub Approver');
                return false;
            }

            $("[id*=hdnAllAppCheckByAjaxCode]").val(hdnAllAppAjaxCode);
            $("[id*=hdnAllAppDepidCheckByAjaxCode]").val(hdnAllDepAjaxCode);


        });


        // chk chkDeptname
        $("input[name=chkDeptname]").live('click', function () {
            $('.loader').show();
            var currentobj = $(this);
            setTimeout(function () {
                var chkprop = currentobj.is(':checked');
                $("input[name=chkSftname]").each(function () {
                    var sftrow = $(this).closest("tr");
                    var hdndepid = sftrow.find("input[name=hdndepid]").val();
                    if (hdndepid == currentobj.val()) {
                        if (chkprop) {
                            $(this).attr('checked', 'checked');
                            //sftrow.css('display', 'block');
                        }
                        else {
                            $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                        }
                    }

                });
                $('.loader').hide();
            }, 1000);
        });


        // Chk All Client
        $("[id*=chkClient]").live('click', function () {
            $('.loader').show();
            var chkprop = $(this).is(':checked');
            setTimeout(function () {
                $("input[name=chkDeptname]").each(function () {
                    if (chkprop)
                    { $(this).attr('checked', 'checked'); }
                    else
                    { $(this).removeAttr('checked'); }
                });
                $("input[name=chkSftname]").each(function () {
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
        /////////////////////////tab2 assign Staff on selection
        /////////////////////////chk chkSftname 
        $("input[name=chkSftname]").live('click', function () {
            AssignStafftoStaffBudgeting();
        });
        //////////////////////////page load end
        BudgetingChange();
    });

    ////////////////////ajax functions
    ////////////////bind girdview inside popup
    function AjaxBindGridDataUsing() {
        var staffcode = $("[id*=hdnEditClickStaffcode]").val();
        if (staffcode != "") {
            var data = {
                id: {
                    StaffCode: staffcode,
                    jobid: $("[id*=hdnJobid]").val(),
                    compid: $("[id*=hdnCompanyid]").val()
                }
            };
            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "EditJobAdd.aspx/BindGridTable",
                data: JSON.stringify(data),
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //Ajax end
        }
    }

    ///////////////////get popup grid view edit button on click staff budget details
    function updatedata(id) {

        $('.loader').fadeIn(200);
        $("[id*=hdnClickonEditforbudgetTempID]").val(id);
        $("[id*=txtjustshowingdate]").show();
        $("[id*=txteditStaffBudgetedDate]").hide();

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
            url: "EditJobAdd.aspx/GetTempIDDetails",
            data: JSON.stringify(data),
            dataType: "json",
            success: function (res) {

                if (res.d.length > 0) {
                    $("[id*=txtjustshowingdate]").val(res.d[0].fromdate);
                    $("[id*=txteditBudgetHours]").val(res.d[0].Budgethours);
                    $("[id*=txteditHourlyAmount]").val(res.d[0].BudgetAmt);
                    $("[id*=txteditStaffBudgetedDate]").val(res.d[0].fromdate);
                    $("[id*=txtPlaneedDrawings]").val(res.d[0].PlanedDrawing);
                    $("[id*=txtAllocatedHrs]").val(res.d[0].AllocatedHours);
                    $("[id*=txtStaffActualRateForJob]").val(res.d[0].StaffActualHourRate);

                }
                $('.loader').fadeOut(550);
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        //Ajax end
    }

    function SaveOrUpeateDateBudget() {
        $('.loader').fadeIn(200);
        var staffcode = $("[id*=hdnEditClickStaffcode]").val();
        if (staffcode != "") {
            var data = {
                id: {
                    StaffCode: staffcode,
                    BudgetAmt: $("[id*=txteditHourlyAmount]").val(),
                    Budgethours: $("[id*=txteditBudgetHours]").val(),
                    temp_Id: $("[id*=hdnClickonEditforbudgetTempID]").val(),
                    fromdate: $("[id*=txteditStaffBudgetedDate]").val(),
                    PlanedDrawing: $("[id*=txtPlaneedDrawings]").val(),
                    AllocatedHours: $("[id*=txtAllocatedHrs]").val(),
                    StaffActualHourRate: $("[id*=txtStaffActualRateForJob]").val(),
                    jobid: $("[id*=hdnJobid]").val(),
                    compid: $("[id*=hdnCompanyid]").val()
                }
            };
            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "EditJobAdd.aspx/SaveOrUpdateBudget",
                data: JSON.stringify(data),
                dataType: "json",
                success: function (res) {
                    if (res.d.length > 0) {
                        if (res.d[0].StaffCode == 'Error') {
                            alert('From Date Must Be Greater Than !');
                            $('.loader').fadeOut(200);
                        }
                        else {
                            OnSuccess(res);
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

    function updatedata2(id) {
        $('.loader2').fadeIn(200);
        $("[id*=hdnJobwiseBudgetingtemp]").val(id);
        $("[id*=txtfromdate]").hide();
        $("[id*=txtbudshowindate]").show();

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

    //////////////////ajax success functions
    function OnSuccess(response) {
        clearform();
        $("[id*=gvCustomers").empty();
        $("[id*=gvCustomers]").append("<tr class='mytable'><th>Sr No.</th><th>From Date</th><th>To Date</th><th>Hourly Amount</th><th>Budget Hours</th><th>Planned Drawings</th><th>Completed Drawings</th><th>Allocated Hours</th><th>Staff Actual Hour Rate</th><th></th></tr>");
        if (response.d.length > 0) {
            for (var i = 0; i < response.d.length; i++) {
                if (response.d[i].temp_Id == "NotPresent") {
                    $("[id*=txtStaffActualRateForJob]").val(response.d[i].StaffActualHourRate);
                }
                else {
                    $("[id*=gvCustomers]").append("<tr class='mytable'><td>" +
                            (i + 1) + "</td><td width='80px'>" + //sr no
                            response.d[i].fromdate + "</td> <td width='80px'>" + //FromDate
                            response.d[i].todate + "</td> <td>" + //Todate
                            response.d[i].BudgetAmt + "</td> <td>" + //Budget Amount
                            response.d[i].Budgethours + "</td><td>" +
                            response.d[i].PlanedDrawing + "</td> <td>" +
                            response.d[i].CompletedDrawing + "</td> <td>" +
                            response.d[i].AllocatedHours + "</td> <td>" +
                            response.d[i].StaffActualHourRate + "</td>" +
                            "<td><img src='../images/edit.png' style='cursor:pointer;' onclick=updatedata(" + response.d[i].temp_Id + ") ></td></tr>");

                    //Set Updated Amount & hours
                    if (response.d[i].todate == '') {
                        $("input[name=chkStaffBudgetCheckEmp]:checked").each(function () {
                            var row = $(this).closest("tr");
                            var staffcode = $(this).val();
                            if (staffcode == $("[id*=hdnEditClickStaffcode]").val()) {
                                $("td", row).eq(4).html(response.d[i].BudgetAmt);
                                $("td", row).eq(5).html(response.d[i].Budgethours);
                                $("td", row).eq(6).html(response.d[i].PlanedDrawing);
                                $("td", row).eq(7).html(response.d[i].AllocatedHours);
                                $("td", row).eq(8).html(response.d[i].StaffActualHourRate);
                            }
                        });
                    }
                }
            }
        }
        else {
            $("[id*=gvCustomers]").append("<tr><td style='height:20px; border:1px solid #BCBCBC;' colspan='12'>No Records Found !</td></tr>");
        }
        if (response.d.length == 1)
            $("[id*=gvCustomers]").append("<tr><td style='height:20px; border:1px solid #BCBCBC;' colspan='12'>No Records Found !</td></tr>");
        $('.loader').fadeOut(550);
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
            }
        }
        else {
            $("[id*=Gridtimesheetdetails]").append("<tr><td style='height:20px; border:1px solid #BCBCBC;' colspan='15'>No Records Found !</td></tr>");
        }
        $('.loader2').fadeOut(550);
    }




    //////////////////////functions
    function ValidateText(i) {
        if (i.value == 0) {
            i.value = null;
        }
        if (i.value.length > 0) {
            i.value = i.value.replace(/[^\d.]+/g, '');
        }
    }

    /////////////////////show staff Department and staff name
    function AjaxGetStaffNameAndDepartment() {
        $("[id*=gvCustomers]").empty();
        var staffcode = $("[id*=hdnEditClickStaffcode]").val();

        $("input[name=chkStaffBudgetCheckEmp]:checked").each(function () {
            if ($(this).val() == staffcode) {
                $("[id*=lblStaffBudgetName]").html($("td", $(this).closest("tr")).eq(1).html());
                $("[id*=lblStaffDept]").html($("td", $(this).closest("tr")).eq(2).html());
            }
        });


        //        if (staffcode != "") {
        //            var data = {
        //                id: {
        //                    StaffCode: staffcode
        //                }
        //            };
        //            //Ajax start
        //            $.ajax({
        //                type: "POST",
        //                contentType: "application/json; charset=utf-8",
        //                url: "EditJobAdd.aspx/GetStaffDetails",
        //                data: JSON.stringify(data),
        //                dataType: "json",
        //                success: function (res) {
        //                    
        //                    if (res.d.length > 0) {
        //                        
        //                    }
        //                },
        //                failure: function (response) {
        //                    
        //                },
        //                error: function (response) {
        //                   
        //                }
        //            });
        //            //Ajax end
        //        }
    }

    //////////////show budgeting tab
    function BudgetingChange() {
        var bud = $("[id*=ddlBudgetingselection]").val();
        if (bud == 'Project Budgeting') {
            $("[id*=TabPanel1]").show();
            $("[id*=tab_pane_Staff_budgeting]").hide();
            bug_for_clickon_project_budgeting = 0;
            $("[id*=EditJobAdd_TabContainer1_TabPanel1]").click();

        } else if (bud == 'Staff Budgeting') {
            $("[id*=TabPanel1]").hide();
            $("[id*=tab_pane_Staff_budgeting]").show();
            $("[id*=tab_pane_Staff_budgeting]").click();
        }
        else {
            $("[id*=TabPanel3]").click();
            $("[id*=TabPanel1]").hide();
            $("[id*=tab_pane_Staff_budgeting]").hide();
        }
    }

    var bug_for_clickon_project_budgeting = 0;

    function checkEmployeeAssign() {
        var staffcode = "";
        $("input[name=chkSftname]").each(function () {
            if ($(this).prop('checked')) {
                if (staffcode == "") { staffcode = $(this).val(); }
                else { staffcode = staffcode + "," + $(this).val(); }
            }
        });

        if (staffcode != "") {
            $("[id*=hdnSelectdEmpForStaffBudget]").val(staffcode);
            staffcode = staffcode.split(',');
        }
    }



    function AssignStafftoStaffBudgeting() {
        var staffcode = "";
        $("input[name=chkSftname]:checked").each(function () { staffcode = staffcode + "," + $(this).val(); });

        $("input[name=chkStaffBudgetCheckEmp]").each(function () {
            $(this).removeAttr('checked');
            $(this).closest('tr').hide();
        });

        if (staffcode != "") {
            var rono = 0;
            staffcode = staffcode.split(',');
            $("input[name=chkStaffBudgetCheckEmp]").each(function () {

                for (i = 0; i < staffcode.length; i++) {
                    if (staffcode[i] == $(this).val()) {
                        rono = parseFloat(rono) + 1;
                        $(this).attr('checked', 'checked');
                        $("td", $(this).closest('tr')).eq(0).html(rono);
                        $(this).closest('tr').css('display', '');
                    }
                }

            });
        }
    }

    function clearform() {
        $("[id*=txteditStaffBudgetedDate]").val('');
        $("[id*=txteditBudgetHours]").val('0');
        $("[id*=txteditHourlyAmount]").val('0');

        $("[id*=txtPlaneedDrawings]").val('0');
        $("[id*=txtAllocatedHrs]").val('0');
        $("[id*=txtStaffActualRateForJob]").val('0');

        $("[id*=txtjustshowingdate]").hide();
        $("[id*=txteditStaffBudgetedDate]").show();
        $("[id*=hdnClickonEditforbudgetTempID]").val('0');
    }

    function clareformEditStaffbudget() {
        $("[id*=Gridtimesheetdetails]").empty();
        $("[id*=txtBamt]").val('0');
        $("[id*=txtBHours]").val('0');
        $("[id*=txtOBA]").val('0');
        $("[id*=txtfromdate]").val('');
        $("[id*=txtbudshowindate]").val('');
        $("[id*=txtfromdate]").show();
        $("[id*=txtbudshowindate]").hide();
        $("[id*=hdnJobwiseBudgetingtemp]").val('0');

    }

    function Redirect() {
        window.location = "cmp_Managejob.aspx";
    }
</script>
<div id="totbdy" class="EditJobAdd">
    <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
        <asp:Label ID="Label11" runat="server" Text="Edit Job" CssClass="Head1 labelChange"></asp:Label>
    </div>
    <div>
        <uc1:MessageControl ID="MessageControl1" runat="server" />
        <uc1:MessageControl ID="MessageControl2" runat="server" />
        <asp:HiddenField ID="hdnCompanyid" runat="server" />
        <asp:HiddenField ID="hdnStfCnt" runat="server" />
        <asp:HiddenField ID="hdnJobid" runat="server" />
        <asp:HiddenField ID="hdnAllstfCheckByAjaxCode" runat="server" />
        <asp:HiddenField ID="hdnAllAppCheckByAjaxCode" runat="server" />
        <asp:HiddenField ID="hdnAllAppDepidCheckByAjaxCode" runat="server" />
        <asp:HiddenField ID="hdnSSappid" runat="server" />
    </div>
    <asp:Panel ID="Panel1" runat="server" class="panelLets">
       
            <fieldset style="border: solid 1px black; padding: 10px; width:1175px; margin:10px;">
            <legend style="font-weight:bold; color:Red;">Job Details</legend>
            <table style="width:1000px; padding-left:40px;">
                <tr>
                    <td>
                        <div class="masterleft">
                            <asp:Label ID="Label3" runat="server" CssClass="labelstyle labelChange" Text="Client" Font-Size="Small"></asp:Label>
                        </div>
                        <div class="DivRight" style="width: 550px;">
                            <asp:DropDownList ID="drpclientname" runat="server" CssClass="DropDown" Width="435px" Height="30px"
                                DataValueField="CLTId" DataTextField="ClientName">
                                <asp:ListItem Value="0">--Select--</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </td><td>
                        <div class="masterleft">
                            <asp:Label ID="Label1" runat="server" CssClass="labelstyle labelChange" Text="Job Name" Font-Size="Small"></asp:Label>
                        </div>
                        <div class="DivRight" style="width: 550px;">
                            <asp:DropDownList ID="DrpJob" runat="server" CssClass="DropDown" Width="435px" Height="30px" AutoPostBack="True"
                                DataValueField="mjobId" DataTextField="mjobName">
                                <asp:ListItem Value="0">--Select--</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="masterleft">
                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle labelChange" Text="Job Group" Font-Size="Small"></asp:Label>
                        </div>
                        <div class="DivRight" style="width: 550px;">
                            <asp:DropDownList ID="drpjobgrp" runat="server" CssClass="DropDown" Width="435px" Height="30px"
                                DataValueField="JobGId" DataTextField="JobGroupName">
                                <asp:ListItem Value="0">--Select--</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </td><td>
                        <div class="masterleft">
                            <asp:Label ID="Label4" runat="server" CssClass="labelstyle labelChange" Text="Job Status" Font-Size="Small"></asp:Label>
                        </div>
                        <div class="DivRight" style="width: 550px;">
                            <asp:DropDownList ID="drpjobstatus" runat="server" CssClass="DropDown" Width="200px" Height="30px">
                                <asp:ListItem Value="0">--Select--</asp:ListItem>
                                <asp:ListItem Value="1">OnGoing</asp:ListItem>
                                <asp:ListItem Value="2">Completed</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>

                      <div  class="divedBlockNew"> 
                        <div style="overflow: hidden; width: 100px; float: left">
                            <asp:Label ID="Label7" runat="server" CssClass="labelstyle" Text="Start Date" Font-Size="Small"></asp:Label>
                        </div>
                        <div style="overflow: hidden; width: 150px; float: left">
                            <asp:TextBox ID="txtstartdate" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtstartdate"
                                Mask="99/99/9999" MaskType="Date" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
                                CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                CultureTimePlaceholder="" Enabled="True" />
                            <asp:Label ID="Label10" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                            <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtstartdate"
                                PopupButtonID="txtstartdate" Format="dd/MM/yyyy" Enabled="True">
                            </cc1:CalendarExtender>
                        </div>
                    
                        <div style="overflow: hidden; width: 80px; float: left">
                            <asp:Label ID="Label13" runat="server" CssClass="labelstyle" Text="End Date" Font-Size="Small"></asp:Label>
                        </div>
                        <div style="overflow: hidden; width: 150px; float: left">
                            <asp:TextBox ID="txtactualdate" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="MaskedEditExtender16" runat="server" TargetControlID="txtactualdate"
                                Mask="99/99/9999" MaskType="Date" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
                                CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                CultureTimePlaceholder="" Enabled="True" />
                            <asp:Label ID="Label26" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                            <cc1:CalendarExtender ID="txtactualdate_CalendarExtender" runat="server" TargetControlID="txtactualdate"
                                PopupButtonID="txtactualdate" Format="dd/MM/yyyy" Enabled="True">
                            </cc1:CalendarExtender>
                        </div>
                       </div>  
                    </td><td>
                       <div >
                        <div class="masterleft" style="overflow: hidden; width:15%;; float: left" >
                            <asp:Label ID="Label19" runat="server" CssClass="labelstyle" Text="Billable" Font-Size="Small"></asp:Label>
                        </div>
                        <div  style="overflow: hidden;  width:15%; float: left">
                            <asp:DropDownList ID="DrpBillable" runat="server" CssClass="drp" >
                                <asp:ListItem Value="1">Yes</asp:ListItem>
                                <asp:ListItem Value="0">No</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="masterleft">
                            <asp:Label ID="Label21" runat="server" CssClass="labelstyle" Text="Budgeting" Font-Size="Small"></asp:Label>
                        </div>
                        <div class="DivRight" style="width:15%; float:left;">
                            <asp:DropDownList ID="ddlBudgetingselection" runat="server" CssClass="DropDown" Width="200px">
                                <asp:ListItem Value="0">--Select--</asp:ListItem>
                                <asp:ListItem>Project Budgeting</asp:ListItem>
                                <asp:ListItem>Staff Budgeting</asp:ListItem>
                            </asp:DropDownList>
                        </div>          
                       </div>   
                </td>
                </tr>
 
            </table>

            </fieldset>
        
    </asp:Panel>
    <fieldset style="width:1175px; height:450px;">
    <legend style="font-weight:bold; color:Red;">Other Details</legend>
    <div class="tabular" style="padding-left:10px; margin:10px;">
        <asp:Panel ID="Panel2" runat="server" Height="450px" Width="676px">
            <cc1:TabContainer ID="TabContainer1" runat="server" CssClass="property_tab" TabIndex="1"
                AutoPostBack="false" ActiveTabIndex="0" BorderColor="Green" Style="padding-left: 15px">
                <cc1:TabPanel ID="TabPanel3" runat="server" HeaderText="Assign Approver">
                    <ContentTemplate>
                        <div>
                            <div>
                                <div>
                                    <asp:Label ID="Label9" runat="server" Text="Super Approver"></asp:Label></div>
                                <div class="boexs">
                                    <asp:DropDownList ID="drpdwnapp" runat="server" CssClass="dropstyle" DataTextField="StaffName"
                                        DataValueField="StaffCode" Width="200px">
                                        <asp:ListItem Value="0">--Select one--</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div>
                                <div style="padding: 0 0 5px;">
                                    <asp:Label ID="Label16" runat="server" Text="Sub Approver"></asp:Label>
                                    <asp:Label ID="Label46" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label></div>
                            </div>
                            <div style="width: 300px">
                                <asp:Panel ID="Panel5" runat="server" Height="240px" ScrollBars="Vertical" Style="border: 1px solid #ccc;
                                    overflow: auto; width: 300px; float: left; padding: 5px;" Width="350px">
                                    <div style="height: 280px; margin-right: 0px;">
                                        <div id="Div6">
                                            <div class="loader2">
                                                Please Wait.....
                                            </div>
                                        </div>
                                        <table id="datalistSftApprover">
                                        </table>
                                    </div>
                                </asp:Panel>
                            </div>
                        </div>
                    </ContentTemplate>
                </cc1:TabPanel>
                <%--Coding for Assign Staff Panel--%>
                <cc1:TabPanel ID="tabPanel2" runat="server" ForeColor="Black">
                    <HeaderTemplate>
                       <asp:Label runat="server"  Text="Assign Staff" CssClass="labelChange" ></asp:Label></HeaderTemplate>
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <div>
                                        <div>
                                            <asp:Label ID="Label8" runat="server" CssClass="labelstyle labelChange" Text="Department"></asp:Label></div>
                                        <div>
                                            <asp:Panel ID="Panel4" runat="server" Height="280px" ScrollBars="Vertical" Style="overflow: auto;
                                                margin: 8px 0 0; width: 300px; padding: 5px; border: 1px solid #ccc; float: left;">
                                                <div style="height: 280px; margin-right: 0px;">
                                                    <div id="Div5">
                                                        <div class="loader">
                                                            Please Wait.....
                                                        </div>
                                                    </div>
                                                    <table id="datalistDeptName">
                                                    </table>
                                                </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div style="width: 20px">
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <div>
                                            <asp:CheckBox ID="chkall" runat="server" Text="Check All" CssClass="staffchkall" />&nbsp;
                                            <asp:Label ID="Label15" runat="server" CssClass="labelstyle labelChange" Text="Staff"></asp:Label>
                                        </div>
                                        <div>
                                            <asp:Panel ID="Panel3" runat="server" Height="280px" ScrollBars="Vertical" Style="overflow: auto;
                                                margin: 8px 0 0; border: 1px solid #ccc; padding: 5px; width: 300px; float: left;">
                                                <div style="height: 280px; margin-right: 0px;">
                                                    <div id="content2">
                                                        <div class="loader2">
                                                            Please Wait.....
                                                        </div>
                                                    </div>
                                                    <table id="datalistSftName">
                                                    </table>
                                                </div>
                                            </asp:Panel>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </cc1:TabPanel>
                <cc1:TabPanel ID="TabPanel1" runat="server" HeaderText="Budgeting" ForeColor="Black">
                    <ContentTemplate>
                        <div style="height: 30px" class="tabdiderdiv">
                            <div class="DivLeft" style="padding-left: 5px; width: 150px">
                                <asp:Label ID="Label42" runat="server" CssClass="labelstyle" Text="Budget Amount"
                                    Font-Size="Small"></asp:Label></div>
                            <div class="DivRight" style="width: 450px;">
                                <asp:TextBox ID="txtBudAmt" runat="server" CssClass="txtbox calbox" Width="88px"
                                    onkeyup="return  ValidateText(this);"></asp:TextBox></div>
                        </div>
                        <div style="height: 30px" class="tabdiderdiv">
                            <div class="DivLeft" style="padding-left: 5px; width: 150px">
                                <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text="Budgeted Hours"
                                    Font-Size="Small"></asp:Label></div>
                            <div class="DivRight" style="width: 450px;">
                                <asp:TextBox ID="txtbudhours" runat="server" CssClass="txtbox calbox" Width="88px"></asp:TextBox></div>
                        </div>
                        <div style="height: 30px" class="tabdiderdiv">
                            <div class="DivLeft" style="padding-left: 5px; width: 165px">
                                <asp:Label ID="Label14" runat="server" CssClass="labelstyle" Text="Other Budgeted Amount"
                                    Font-Size="Small" onkeyup="return  ValidateText(this);"></asp:Label></div>
                            <div class="DivRight DivRightExtra" style="width: 300px; height: 25px;">
                                <asp:Button ID="Btn1" runat="server" Text="Edit Budget" class="TbleBtns"></asp:Button>
                                <asp:TextBox ID="txtbudamtOth" Text="0" runat="server" CssClass="txtboxNew calbox"></asp:TextBox>
                            </div>
                            <div class="DivRight" style="width: 400px;">
                            </div>
                        </div>
                        <div style="height: 30px" class="tabdiderdiv">
                            <div class="noteText">
                                Notes:
                                <div class="txtboxNewError">
                                    <span class="labelstyle">Fields marked with * are required</span></div>
                            </div>
                            <div class="txtboxNew">
                                <span class="labelstyle labelChange" style="overflow: hidden; font-size: 11px;">If you maintaining
                                    Job wise budgeting update Budgeted Amount and Hours. Please Ignore Staff Budgeting.</span>
                            </div>
                        </div>
                    </ContentTemplate>
                </cc1:TabPanel>
                <cc1:TabPanel ID="tab_pane_Staff_budgeting" runat="server" >
                <HeaderTemplate>
                <asp:Label ID="staffbud" Text="Staff Budgeting" CssClass="labelChange" runat="server"></asp:Label>
                </HeaderTemplate>
                    <ContentTemplate>
                        <asp:HiddenField ID="hdnSelectdEmpForStaffBudget" runat="server" />
                        <div style="max-height: 275px; overflow: auto;">
                            <div style="height: 270px; margin-right: 0px;">
                                <div id="Div15">
                                    <div class="loader2">
                                        Please Wait.....
                                    </div>
                                </div>
                                <table cellspacing="0" class="norecordTble" border="1" id="tblStaffbudget" style="border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="grdheader">
                                                SrNo
                                            </th>
                                            <th class="grdheader">
                                                <label class="labelChange">Staff Name</label>  
                                            </th>
                                            <th class="grdheader">
                                               <label class="labelChange">Department</label> 
                                            </th>
                                            <th class="grdheader">
                                                <label class="labelChange">Designation</label> 
                                            </th>
                                            <th class="grdheader">
                                                Hourly Amount
                                            </th>
                                            <th class="grdheader">
                                                Budget Hours
                                            </th>
                                            <th class="grdheader">
                                                Planned Drawings
                                            </th>
                                            <th class="grdheader">
                                                Allocated Hours
                                            </th>
                                            <th class="grdheader">
                                               <label class="labelChange">Staff Actual Hour Rate</label> 
                                            </th>
                                            <th>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr style="color: rgb(0, 0, 102); height: 15px;">
                                            <td align="right">
                                            </td>
                                            <td style="width: 50%;">
                                            </td>
                                            <td>
                                            </td>
                                            <td>
                                            </td>
                                            <td align="right">
                                            </td>
                                            <td align="right">
                                            </td>
                                            <td align="right">
                                            </td>
                                            <td align="right">
                                            </td>
                                            <td align="right">
                                            </td>
                                            <td>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div style="height: 30px" class="tabdiderdiv">
                            <div class="txtboxNew">
                                <span class="labelstyle" style="overflow: hidden; font-size: 11px;">If you maintaining
                                    Staff wise budgeting update staff hourly Amount and Budgeted Hours. Please Ignore
                                    Job wise Budgeting.</span>
                            </div>
                        </div>
                    </ContentTemplate>
                </cc1:TabPanel>
            </cc1:TabContainer>
            <table>
                <tr>
                    <td>
                        <asp:Button ID="btnsave" runat="server" Text="Update" OnClick="BtnUpdate_Click" class="TbleBtns" />
                    </td>
                    <td>
                        <asp:Button ID="btncancel" runat="server" Text="Cancel" class="TbleBtns" OnClick="btncancel_Click" />
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <%------------Other Budgeted Amount Modal Popup--------------%>
        <div>
            <asp:Button ID="hiddenLargeImage" runat="server" Style="display: none" />
            <cc1:ModalPopupExtender runat="server" ID="ModalPopupExtender1" BehaviorID="mailingListModalPopupBehavior"
                TargetControlID="hiddenLargeImage" PopupControlID="panelupgrade" BackgroundCssClass="modalBackground"
                OkControlID="imgClose" DropShadow="false" RepositionMode="RepositionOnWindowScroll">
            </cc1:ModalPopupExtender>
            <asp:Panel ID="panelupgrade" runat="server" Width="450px" BackColor="#FFFFFF">
                <div id="Div59" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff;
                    font-weight: bold;">
                    <div id="Div23" style="width: 90%; float: left; height: 20px; padding-left: 2%; padding-top: 1%">
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
                            <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtfromdate"
                                Mask="99/99/9999" MaskType="Date" MessageValidatorTip="true" />
                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtfromdate"
                                PopupButtonID="txtfromdate" Format="dd/MM/yyyy" Enabled="True">
                            </cc1:CalendarExtender>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Budget Amount
                        </td>
                        <td>
                            <asp:TextBox ID="txtBamt" runat="server" CssClass="txtboxc calbox" Width="90px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Budget Hours
                        </td>
                        <td>
                            <asp:TextBox ID="txtBHours" runat="server" CssClass="txtbox calbox" Width="90px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Other Budget Amount
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
                            <asp:GridView ID="Gridtimesheetdetails" runat="server">
                                <RowStyle Height="15px" />
                                <Columns>
                                    <asp:BoundField ItemStyle-Width="150px" DataField="fromdate" HeaderText="CustomerID" />
                                    <asp:BoundField ItemStyle-Width="150px" DataField="BudgetAmt" HeaderText="CustomerID" />
                                    <asp:BoundField ItemStyle-Width="150px" DataField="Budgethours" HeaderText="City" />
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
                <div id="Div4">
                    <div class="loader2">
                    </div>
                </div>
            </asp:Panel>
        </div>
        <div id="Div20">
            <cc1:ModalPopupExtender runat="server" ID="ModalPopupExtender2" BehaviorID="StaffBudgetingpopup"
                TargetControlID="hiddenLargeImage" PopupControlID="panel6" BackgroundCssClass="modalBackground"
                OkControlID="imgBudgetdClose" DropShadow="false" RepositionMode="RepositionOnWindowScroll">
            </cc1:ModalPopupExtender>
            <asp:Panel ID="panel6" runat="server" Width="560px" BackColor="#FFFFFF">
                <div id="Div1" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff;
                    font-weight: bold;">
                    <div id="Div2" style="width: 90%; float: left; height: 20px; padding-left: 2%; padding-top: 1%">
                        <asp:Label ID="Label18" runat="server" Text="Edit Staff Budgeted Amount & Hours"
                            CssClass="subHead1"></asp:Label>
                    </div>
                    <div id="Div3" class="ModalCloseButton">
                        <img alt="" src="../images/error.png" id="imgBudgetdClose" border="0" name="imgClose" />
                    </div>
                </div>
                <asp:HiddenField ID="hdnEditClickStaffcode" runat="server" />
                <asp:HiddenField ID="hdnClickonEditforbudgetTempID" runat="server" />
                <div style="width: 550px; min-height: 300px; float: left; overflow: hidden; padding: 5px;">
                    <table align="center" cellpadding="5" width="100%" style="border-color: #BCBCBC;
                        border-collapse: collapse;" border="1" cellspacing="0">
                        <tr>
                            <td>
                                <b class="labelChange">Staff Name</b>
                            </td>
                            <td colspan="3" width="70%">
                                <asp:Label ID="lblStaffBudgetName" runat="server"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b class="labelChange">Department</b>
                            </td>
                            <td width="70%" colspan="3">
                                <asp:Label ID="lblStaffDept" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                    <table cellspacing="0" cellpadding="0" align="center" style="margin: 4px auto 4px auto;">
                        <tr>
                            <td>
                                <b>From Date&nbsp;</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txteditStaffBudgetedDate" Style="margin: 2px;" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                                <asp:TextBox ID="txtjustshowingdate" ReadOnly="true" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txteditStaffBudgetedDate"
                                    Mask="99/99/9999" MaskType="Date" MessageValidatorTip="true" />
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txteditStaffBudgetedDate"
                                    PopupButtonID="txteditStaffBudgetedDate" Format="dd/MM/yyyy" Enabled="True">
                                </cc1:CalendarExtender>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Budget Hours&nbsp;</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txteditBudgetHours" Width="50px" Style="margin: 2px;" runat="server"
                                    CssClass="txtbox calbox"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Hourly Amount&nbsp;</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txteditHourlyAmount" Width="50px" Style="margin: 2px;" runat="server"
                                    CssClass="txtbox calbox"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Planned Drawings&nbsp;</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txtPlaneedDrawings" Width="50px" Style="margin: 2px;" runat="server"
                                    CssClass="txtbox calbox"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b>Allocated Hours&nbsp;</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txtAllocatedHrs" Width="50px" Style="margin: 2px;" runat="server"
                                    CssClass="txtbox calbox"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <b class="labelChange">Staff Actual Hour Rate&nbsp;</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txtStaffActualRateForJob" Width="50px" Style="margin: 2px;" runat="server"
                                    CssClass="txtbox calbox"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td height="3px" colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Button ID="btnEditedStaffBudgetdAmtHours" runat="server" Text="Save" class="TbleBtns" />
                            </td>
                            <td>
                                <asp:Button ID="Button1" runat="server" Text="clear" class="TbleBtns" />
                            </td>
                        </tr>
                    </table>
                    <table id="shwoingdetals" align="center">
                        <tr>
                            <td>
                                <asp:GridView ID="gvCustomers" runat="server" AutoGenerateColumns="false" Font-Names="Arial"
                                    Font-Size="10pt" Width="100%" RowStyle-BackColor="#A1DCF2" HeaderStyle-BackColor="#3AC0F2"
                                    HeaderStyle-ForeColor="White">
                                    <Columns>
                                        <asp:BoundField ItemStyle-Width="150px" DataField="fromdate" HeaderText="CustomerID" />
                                        <asp:BoundField ItemStyle-Width="150px" DataField="BudgetAmt" HeaderText="CustomerID" />
                                        <asp:BoundField ItemStyle-Width="150px" DataField="Budgethours" HeaderText="City" />
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>
                    <div id="content">
                        <div class="loader">
                        </div>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div></fieldset>
</div>
