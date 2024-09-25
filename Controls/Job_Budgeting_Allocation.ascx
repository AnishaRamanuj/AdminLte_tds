<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Job_Budgeting_Allocation.ascx.cs"
    Inherits="controls_Job_Budgeting_Allocation" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../StyleCss/Divstyle.css" rel="stylesheet" type="text/css" />
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        Get_Job_Budgeting_Allocation_Rolenames();

        //////On Role Change Get His Permission
        $("#selectRoles").on('change', function () {
            Get_Job_Budgeting_Allocation_ProjectNames();
        });

        //////on project Change get Departments
        $("#ddlProject").on('change', function () {
            Get_Job_Budgeting_Allocation_DepartmentNames();
        });
        //////on project Change get Departments
        $("#ddlDepartment").on('change', function () {
            $("[id*=hdnJobBudId]").val(0);
            clearForAddJobs();
            Get_Job_Budgeting_Allocation_JobDetails();
        });
        ///////for edit cancel
        $("#BtnClose").on('click', function () {
            Get_Job_Budgeting_Allocation_JobDetails();
        });

        ///////back to Add jobs

        $("#BtnBack").on('click', function () {
            clearForAddJobs();
            $("#BtnBack").hide();
        });
        $("#BtnAddJob").on('click', function () {
            if ($("#ddlDepartment").val() == '0') {
                alert("Please Select Department");
                return false;
            }
            $("#ddlJob").show();
            $("#lblJobnames").text('');
            $("#txtAHrs").val('0.00');
            $("[id*=hdnJobBudId]").val(0);
            ///Get_Job_Budgeting_Allocation_JobDetails();

            $find("ListModalPopupAddId").show();
        });


        /////////Allocate More Budgeting Hours from Buffer Hours

        $("#BtnAllocHrs").on('click', function () {
            if (parseFloat($("#txtBuffHrs").val()) == 0) { alert("Buffer Hours is Over"); return false; }
            $("#txtBudAllocHrs").val('00.00');

            var OldDate = ''
            $("#tblBudgetDetails > tbody  > tr").each(function () {
                var row = $(this).closest('tr');

                if (row.find("td").eq(2).html() == '') {

                    OldDate = row.find("td").eq(1).html().split('/');
                }
            });
            if (OldDate == '') {
                var date = new Date();
                var Month = date.getMonth();
                Month = Month + 1;
                if (Month < 10) { Month = "0" + Month; }
                var Day = date.getDate();
                if (Day < 10) { Day = "0" + Day; }
                var Year = date.getFullYear();
                $("#txtDate").val(Year + "-" + Month + "-" + Day);
            }
            else {
                var newdate = new Date(OldDate[1] + "/" + OldDate[0] + "/" + OldDate[2]);
                var mindate = new Date();
                mindate.setDate(newdate.getDate() + 1);
                /// OldDate[0] = parseInt(OldDate[0]) + 1;

                mindate = mindate.toISOString().slice(0, 10);

                $('#txtDate').attr('min', mindate);
            }
            $("[id*=hdnBudId]").val(0);
            $("#txtDate").prop('readonly', '');
            $("[id*=hdnJobHrs]").val(0);
            $find("ListModalPopupBehavior").show();

        });


        /////////Add and edit new Budgeting hours from buffer
        $("#BtnSubmit").on('click', function () {
            if ($("#txtDate").val() == '') {
                alert("Please Select Allocation Date");
                return false;
            }
            if ($("#txtBudAllocHrs").val() == '' || parseFloat($("#txtBudAllocHrs").val()) == 0) {
                alert("Please Input Budgeting Hours");
                return false;
            }
            var defhrs = parseFloat($("#txtBuffHrs").val()) + parseFloat($("[id*=hdnDeptHrs]").val()) - parseFloat($("#txtBudAllocHrs").val());
            if (defhrs < 0) {
                alert("Budgeted Hours is greater than Buffer Hours");
                return false;
            }
            $.ajax({
                type: "POST",
                url: "../Handler/Job_Budgeting_Allocation.asmx/Update_Job_Budgeting_Allocation_BudgetHours",
                data: '{Compid:' + $("[id*=hdncompid]").val() + ',AllocHrs:"' + $("#txtBudAllocHrs").val() + '",JobBudId:' + $("[id*=hdnJobBudId]").val() + ',BudId:' + $("[id*=hdnBudId]").val() + ',BudDate:"' + $("#txtDate").val() + '"}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) {
                                alert("Job Saved Successfully");
                                $("btnButSave").hide();
                                $("BtnAllocHrs").show();
                                Get_Job_Budgeting_Allocation_JobDetails();
                                $find("ListModalPopupBehavior").hide();

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


        });



        ///////////Save Job Budgeting

        $("#btnButSave").on('click', function () {
            if (parseFloat($("#txtBudHrs").val()) == '' || parseFloat($("#txtBudHrs").val() == 0)) {
                alert("Please Add Budgeted Hours"); return false;
            }
            if (parseFloat($("#txtBudHrs").val()) > parseFloat($("#txtBuffHrs").val())) {
                alert("Budgeted Hours Greater Than Buffer Hours"); return false;
            }
            $.ajax({
                type: "POST",
                url: "../Handler/Job_Budgeting_Allocation.asmx/Save_Job_Budgeting_Allocation_BudgetHours",
                data: '{Compid:' + $("[id*=hdncompid]").val() + ',AllocHrs:"' + $("#txtBudHrs").val() + '",JobBudId:' + $("[id*=hdnJobBudId]").val() + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) {
                                alert("Job Saved Successfully");
                                $("btnButSave").hide();
                                $("BtnAllocHrs").show();
                                Get_Job_Budgeting_Allocation_JobDetails();
                                $("#txtBuffHrs").val(parseFloat($("#txtAllocHrs").val()) - parseFloat($("#txtBudHrs").val()));
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

        });

        ///////////Add Jobs Hours Allocations

        $("#BtnSaveJob").on('click', function () {
            if ($("[id*=hdnJobBudId]").val() == 0) {
                if ($("#ddlJob").val() == 0) {
                    alert("Please Select Job name");
                    return false;
                }
            }
            var balance = parseFloat($("#txtRemainHrs").val() - parseFloat($("#txtAHrs").val()));
            if (balance < 0) { alert("Allocated Hours is Greater than Department Hours"); return false; }

            if ($("[id*=hdnDeptHrs]").val() == '') { }
            else {

                if (parseFloat($("#txtAHrs").val()) < parseFloat($("[id*=hdnDeptHrs]").val())) {
                    alert("Already Budgeted MoreHours");
                    return false;
                }
            }

            $.ajax({
                type: "POST",
                url: "../Handler/Job_Budgeting_Allocation.asmx/Save_Job_Budgeting_Allocation_Hours",
                data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + $("[id*=ddlProject]").val() + ',DeptId:' + $("[id*=ddlDepartment]").val() + ',ActivityId:' + $("[id*=ddlJob]").val() + ',AllocHrs:"' + $("#txtAHrs").val() + '",JobBudId:' + $("[id*=hdnJobBudId]").val() + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) {
                                alert("Job Saved Successfully");

                                $find("ListModalPopupAddId").hide();
                                Get_Job_Budgeting_Allocation_JobDetails();
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
        });

    });



    function clearForAddJobs() {
        $(".BudTr").hide();
        $("#btnButSave").hide();
        $("#BtnAllocHrs").hide();
        $("#BtnAddJob").show();
        $("#tblBudgetDetails").hide();
        $("#tblDeparments").show();
        $("#BtnBack").hide();

    }

    function Get_Job_Budgeting_Allocation_JobDetails() {
        $.ajax({
            type: "POST",
            url: "../Handler/Job_Budgeting_Allocation.asmx/Get_Job_Budgeting_Allocation_JobDetails",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',ProjectId:' + $("[id*=ddlProject]").val() + ',DeptId:' + $("#ddlDepartment").val() + ',JobBudId:' + $("[id*=hdnJobBudId]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) {

                    alert("Allocation Not Found");
                    return false;
                }
                else {
                    if (myList.length == 0) {
                        alert("Allocation Not Found");
                        return false;
                    }
                    else {
                        if (myList.length > 0) {
                            $("#lblDepTHrs").text("Department Hrs:" + myList[0].AllocHrs);
                            if (myList[0].tblBudJobname == null) {
                                $("[id*=ddlJob]").empty();
                                $("[id*=ddlJob]").append("<option value=" + 0 + ">Select</option>");
                            } else {
                                if (myList[0].tblBudJobname.length == 0) {
                                    $("[id*=ddlJob]").empty();
                                    $("[id*=ddlJob]").append("<option value=" + 0 + ">Select</option>");
                                } else {
                                    if (myList[0].tblBudJobname.length > 0) {
                                        $("[id*=ddlJob]").empty();
                                        $("[id*=ddlJob]").append("<option value=" + 0 + ">Select</option>");
                                        for (var j = 0; j < myList[0].tblBudJobname.length; j++) {

                                            $("[id*=ddlJob]").append("<option value=" + myList[0].tblBudJobname[j].ActivityId + ">" + myList[0].tblBudJobname[j].ActivityNames + "</option>");
                                        }
                                    }
                                }
                            }

                            /////////////bid table for allocated jobs
                            var TotalBudHrs = 0;
                            var Jobs = myList[0].tblJobTable;
                            if (Jobs == null) {
                                var trL = $("[id*=tblDeparments] tbody tr:last-child");
                                $("[id*=tblDeparments] tbody").empty();
                                $("td", trL).eq(0).html("");
                                $("td", trL).eq(1).html("");
                                $("td", trL).eq(2).html("No record found");
                                $("td", trL).eq(3).html("");
                                $("td", trL).eq(4).html("");
                                $("td", trL).eq(5).html("");
                                $("td", trL).eq(6).html("");
                                $("td", trL).eq(7).html("");
                                $("[id*=tblDeparments]").append(trL);
                                trL = $("[id*=tblDeparments] tbody tr:last-child").clone(true);
                                $("#txtRemainHrs").val(parseFloat(myList[0].AllocHrs) - parseFloat(TotalBudHrs) + ".00");
                            }
                            else {
                                if (Jobs.length == 0) {
                                    var trL = $("[id*=tblDeparments] tbody tr:last-child");
                                    $("[id*=tblDeparments] tbody").empty();
                                    $("td", trL).eq(0).html("");
                                    $("td", trL).eq(1).html("");
                                    $("td", trL).eq(2).html("No record found");
                                    $("td", trL).eq(3).html("");
                                    $("td", trL).eq(4).html("");
                                    $("td", trL).eq(5).html("");
                                    $("td", trL).eq(6).html("");
                                    $("td", trL).eq(7).html("");
                                    $("[id*=tblDeparments]").append(trL);
                                    trL = $("[id*=tblDeparments] tbody tr:last-child").clone(true);
                                    $("#txtRemainHrs").val(parseFloat(myList[0].AllocHrs) - parseFloat(TotalBudHrs) + ".00");
                                }
                                else {
                                    if (Jobs.length > 0) {
                                        var trL = $("[id*=tblDeparments] tbody tr:last-child");
                                        $("[id*=tblDeparments] tbody").empty();

                                        for (var i = 0; i < Jobs.length; i++) {

                                            $("td", trL).eq(0).html(Jobs[i].srno + "<input type='hidden' id='hdndepid' name='hdndepid' value='" + Jobs[i].Id + "'>");
                                            $("td", trL).eq(1).html(Jobs[i].MJobName);
                                            $("td", trL).eq(2).html(Jobs[i].AllocHrs);
                                            $("td", trL).eq(3).html(Jobs[i].BudgetHours);
                                            $("td", trL).eq(4).html(Jobs[i].BuffHours);
                                            $("td", trL).eq(5).html("<img src='../images/edit.png' onclick='showeditJobs($(this))'/>");
                                            $("td", trL).eq(6).html("<img src='../images/Delete.png' onclick='showDeleteJobs($(this))'/>");
                                            $("td", trL).eq(7).html("<span id='spAllc' style='color:blue; cursor:pointer; ' onclick='ShowAlloc($(this))'>Allocate</span>");
                                            $("[id*=tblDeparments]").append(trL);
                                            trL = $("[id*=tblDeparments] tbody tr:last-child").clone(true);

                                            TotalBudHrs = parseFloat(TotalBudHrs) + parseFloat(Jobs[i].AllocHrs);

                                        }
                                        $("#txtRemainHrs").val(parseFloat(myList[0].AllocHrs) - parseFloat(TotalBudHrs) + ".00");
                                    }
                                }
                            }

                            var BudgetDetails = myList[0].tbljobBudAlloc;
                            if (BudgetDetails == null) {
                                var trL = $("[id*=tblBudgetDetails] tbody tr:last-child");
                                $("[id*=tblBudgetDetails] tbody").empty();
                                $("td", trL).eq(0).html("");
                                $("td", trL).eq(1).html("");
                                $("td", trL).eq(2).html("No record found");
                                $("td", trL).eq(3).html("");
                                $("td", trL).eq(4).html("");
                                $("td", trL).eq(5).html("");
                                $("[id*=tblBudgetDetails]").append(trL);
                                trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);

                            } else {
                                if (BudgetDetails.length == 0) {
                                    var trL = $("[id*=tblBudgetDetails] tbody tr:last-child");
                                    $("[id*=tblBudgetDetails] tbody").empty();
                                    $("td", trL).eq(0).html("");
                                    $("td", trL).eq(1).html("");
                                    $("td", trL).eq(2).html("No record found");
                                    $("td", trL).eq(3).html("");
                                    $("td", trL).eq(4).html("");
                                    $("td", trL).eq(5).html("");
                                    $("[id*=tblBudgetDetails]").append(trL);
                                    trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);
                                }
                                else {
                                    if (BudgetDetails.length > 0) {
                                        var trL = $("[id*=tblBudgetDetails] tbody tr:last-child");
                                        $("[id*=tblBudgetDetails] tbody").empty();
                                        var TotalBudHrs = 0;
                                        for (var i = 0; i < BudgetDetails.length; i++) {
                                            $("td", trL).eq(0).html(BudgetDetails[i].sino + "<input type='hidden' id='hdnBId' name='hdnBId' value=" + BudgetDetails[i].Id + ">");
                                            $("td", trL).eq(1).html(BudgetDetails[i].FromDate);
                                            $("td", trL).eq(2).html(BudgetDetails[i].ToDate);
                                            $("td", trL).eq(3).html(BudgetDetails[i].BudgetHours);
                                            $("td", trL).eq(4).html("<img src='../images/edit.png' onclick='showedit($(this))'/>");
                                            if (BudgetDetails[i].ToDate == '') {
                                                $("td", trL).eq(5).html("<img src='../images/Delete.png' onclick='showDeletebudget($(this))'/>");
                                            }
                                            $("[id*=tblBudgetDetails]").append(trL);
                                            trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);
                                            TotalBudHrs = TotalBudHrs + parseFloat(BudgetDetails[i].BudgetHours);
                                        }
                                        $("#txtBudHrs").val(TotalBudHrs + ".00");
                                        $("#txtBuffHrs").val(parseFloat($("#txtAllocHrs").val()) - parseFloat($("#txtBudHrs").val()));
                                    }
                                }
                            }
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
    }

    function showDeleteJobs(i) {
        var newDate = new Date();
        var row = i.closest("tr");
        var ip = $("[id*= hdnIP]").val();
        var usr = $("[id*= hdnName]").val();
        var uT = $("[id*= hdnUser]").val();
        var dt = newDate;
        var Rtid = row.find("input[name=hdndepid]").val();
        $("[id*=hdnJobBudId]").val(Rtid);
        if (row.find("td").eq(3).html() != '' && parseFloat(row.find("td").eq(3).html()) != 0) {
            alert("Already Budgeted Cant Delete");
            return false;
        }
        var res = confirm("Are You Want To Delete?");
        if (res) {
            $.ajax({
                type: "POST",
                url: "../Handler/Job_Budgeting_Allocation.asmx/Delete_Job_Budgeting_Allocation_Jobs",
                data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobBudId:' + $("[id*=hdnJobBudId]").val() + ',ip:"' + ip + '",usr:"' + usr + '", ut:"' + uT + '", dt: "' + newDate + '" }',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList == null) { }
                    else {
                        if (myList.length == 0) { }
                        else {
                            if (myList.length > 0) {
                                alert("Job Deleted Successfully");
                                Get_Job_Budgeting_Allocation_JobDetails();
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
        }

    }

    function showDeletebudget(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdnBId]").val();
        $("[id*=hdnDeleteBudId]").val(Rtid);
        if (row.find("td").eq(2).html() != '') {
            alert("Cant Delete newest budget Exists");
            return false;
        }
        var Result = confirm("Want to Delete");
        if (Result) {
            $.ajax({
                type: "POST",
                url: "../Handler/Job_Budgeting_Allocation.asmx/Delete_Job_Budgeting_Allocation_Budget",
                data: '{Compid:' + $("[id*=hdncompid]").val() + ',DeleteBudId:' + Rtid + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (myList == null) {


                    }
                    else {
                        if (myList.length == 0) {

                        }
                        else {
                            if (myList.length > 0) {
                                alert("Deleted Successfully");
                                Get_Job_Budgeting_Allocation_JobDetails();
                                clearForAddJobs();
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
        }
    }

    function showedit(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdnBId]").val();
        $("[id*=hdnBudId]").val(Rtid);
        $("#txtDate").prop('readonly', 'readonly');
        $("#txtBudAllocHrs").val(parseFloat(row.find("td").eq(3).html()));
        $("[id*=hdnJobHrs]").val(row.find("td").eq(3).html());
        var today = row.find("td").eq(1).html().split('/');
        $("#txtDate").val(today[2] + "-" + today[1] + "-" + today[0]);

        $find("ListModalPopupBehavior").show();
    }

    function ShowAlloc(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdndepid]").val();
        $("[id*=hdnJobBudId]").val(Rtid);
        $(".BudTr").show();
        $("#BtnBack").show();
        $("#BtnAddJob").hide();
        if (row.find("td").eq(3).html() == '' || parseFloat(row.find("td").eq(3).html()) == 0) {
            $("#btnButSave").show();
            $("#BtnAllocHrs").hide();
            $("#txtBudHrs").removeAttr('readonly');
            $("#txtBudHrs").val('0.00');
        }
        else {
            $("#BtnAllocHrs").show();
            $("#btnButSave").hide();
            $("#txtBudHrs").val(row.find("td").eq(3).html() + ".00");
            $("#txtBudHrs").attr('readonly', 'readonly');
        }
        $("#txtAllocHrs").val(row.find("td").eq(2).html());
        $("#txtBuffHrs").val(row.find("td").eq(4).html());
        $("#tblDeparments").hide();
        $("#tblBudgetDetails").show();
        Get_Job_Budgeting_Allocation_JobDetails();
    }

    function showeditJobs(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdndepid]").val();
        $("[id*=hdnJobBudId]").val(Rtid);
        var jobname = row.find("td").eq(1).html();
        $("#lblJobnames").text(":" + jobname);
        $("#txtAHrs").val(row.find("td").eq(2).html());
        $("[id*=hdnremainHrs]").val(row.find("td").eq(2).html());
        $("#txtRemainHrs").val(parseFloat($("#txtRemainHrs").val()) + parseFloat(row.find("td").eq(2).html()));
        $("[id*=hdnDeptHrs]").val(row.find("td").eq(3).html());
        $("#ddlJob").hide();
        $find("ListModalPopupAddId").show();
    }



    function Get_Job_Budgeting_Allocation_ProjectNames() {
        $.ajax({
            type: "POST",
            url: "../Handler/Job_Budgeting_Allocation.asmx/Get_Job_Budgeting_Allocation_ProjectNames",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',StaffCode:' + $("[id*=hdnStaffcode]").val() + ',RoleId:' + $("#selectRoles").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) {

                    $("[id*=ddlProject]").empty();
                    $("[id*=ddlProject]").append("<option value=" + 0 + ">Select</option>");
                }
                else {
                    if (myList.length == 0) {
                        $("[id*=ddlProject]").empty();
                        $("[id*=ddlProject]").append("<option value=" + 0 + ">Select</option>");
                    }
                    else {
                        if (myList.length > 0) {
                            $("[id*=ddlProject]").empty();
                            $("[id*=ddlProject]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {

                                $("[id*=ddlProject]").append("<option value=" + myList[i].Id + ">" + myList[i].Name + "</option>");
                            }
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
    }


    function Get_Job_Budgeting_Allocation_DepartmentNames() {
        $.ajax({
            type: "POST",
            url: "../Handler/Job_Budgeting_Allocation.asmx/Get_Job_Budgeting_Allocation_DepartmentNames",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',ProjectId:' + $("[id*=ddlProject]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) {

                    $("[id*=ddlProject]").empty();
                    $("[id*=ddlProject]").append("<option value=" + 0 + ">Select</option>");
                }
                else {
                    if (myList.length == 0) {
                        $("[id*=ddlProject]").empty();
                        $("[id*=ddlProject]").append("<option value=" + 0 + ">Select</option>");
                    }
                    else {
                        if (myList.length > 0) {
                            $("[id*=ddlDepartment]").empty();
                            $("[id*=ddlDepartment]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {

                                $("[id*=ddlDepartment]").append("<option value=" + myList[i].Id + ">" + myList[i].Name + "</option>");
                            }
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
    }

    function Get_Job_Budgeting_Allocation_Rolenames() {
        $.ajax({
            type: "POST",
            url: "../Handler/Job_Budgeting_Allocation.asmx/Get_Job_Budgeting_Allocation_Rolenames",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',StaffCode:' + $("[id*=hdnStaffcode]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            $("[id*=selectRoles]").empty();
                            $("[id*=selectRoles]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {

                                $("[id*=selectRoles]").append("<option value=" + myList[i].RoleID + ">" + myList[i].Rolename + "</option>");
                            }
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
    }

</script>
<style type="text/css">
    label {
        font-weight: bold;
    }
</style>
<div class="divstyle">
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="Label2" runat="server" CssClass="Head1" Text="Job Budgeting Allocation"></asp:Label>
        </div>
    </div>
    <table style="float: right; width: 100%; padding: 10px;">
        <tr style="height: 30px;">
            <td style="width: 100px;">
                <label>
                    Roles
                </label>
            </td>
            <td style="width: 300px;">
                <select id="selectRoles" class="DropDown" style="width: 250px;">
                    <option value="0">Select</option>
                </select>
            </td>
            <td style="width: 100px;">
                <label id="lblProject">
                    Project
                </label>
            </td>
            <td style="width: 250px;">
                <select id="ddlProject" class="DropDown" style="width: 250px;">
                    <option value="0">Select</option>
                </select>
            </td>
            <td>
                <input type="button" id="BtnBack" value="Back" style="display: none;" class="TbleBtns TbleBtnsPading" />
            </td>
        </tr>
        <tr>
            <td style="width: 100px;">
                <label>
                    Department
                </label>
            </td>
            <td style="width: 300px;">
                <select id="ddlDepartment" class="DropDown" style="width: 250px;">
                    <option value="0">Select</option>
                </select>
            </td>
            <td>
                <input id="BtnAddJob" type="button" class="TbleBtns TbleBtnsPading" value="Add Job" />
            </td>
            <td>
                <label id="lblDepTHrs">
                </label>
            </td>
        </tr>
        <tr class="BudTr" style="display: none;">
            <td>
                <label id="lblAllocHrs">
                    Allocated Hrs.
                </label>
            </td>
            <td>
                <input type="text" class="txtbox" id="txtAllocHrs" readonly="readonly" />
            </td>
            <td>
                <label id="lblBudHrs">
                    Budget Hrs.
                </label>
            </td>
            <td>
                <input type="text" onblur="ValidBudgetHours(1)" value="0.00"
                    class="txtbox" id="txtBudHrs" />
            </td>
            <td>
                <label id="lblBuffHrs">
                    Buffer Hrs.
                </label>
            </td>
            <td>
                <input type="text" class="txtbox" id="txtBuffHrs" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <input id="btnButSave" type="button" class="TbleBtns TbleBtnsPading" value="Save" style="display: none" />
                <input id="BtnAllocHrs" type="button" class="TbleBtns TbleBtnsPading" value="Allocate Hours" style="display: none" />
            </td>
        </tr>
    </table>
    <center>
    <table id="tblDeparments" border="1px" class="norecordTble" style="border-collapse: collapse;
        width: 95%; display: none;">
        <thead>
            <tr>
                <th class="grdheader">
                    Sr.No
                </th>
                <th class="grdheader">
                    Activity
                </th>
                <th class="grdheader">
                    Alloacated Hrs.
                </th>
                <th class="grdheader">
                    Budgeted Hrs.
                </th>
                <th class="grdheader">
                    Buffer Hrs.
                </th>
                <th class="grdheader">
                    Edit
                </th>
                <th class="grdheader">
                    Delete
                </th>
                <th>
                </th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td align="center">
                </td>
                <td align="center">
                </td>
                <td align="center">
                </td>
            </tr>
        </tbody>
    </table>
    <table id="tblBudgetDetails" border="1px" class="norecordTble" style="border-collapse: collapse;
        width: 95%; display:none;">
        <thead>
            <tr>
                <th class="grdheader">
                    Sr.No
                </th>
                <th class="grdheader">
                    From Date
                </th>
                <th class="grdheader">
                    To Date
                </th>
                <th class="grdheader">
                    Bud.Hours
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
            <tr>
                <td>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td align="center">
                </td>
                <td align="center">
                </td>
            </tr>
        </tbody>
    </table></center>
    <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal1" runat="server"></asp:Button><br />
    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="modalBackground"
        CancelControlID="BtnClose" BehaviorID="ListModalPopupAddId" DropShadow="False"
        PopupControlID="panel1" RepositionMode="RepositionOnWindowScroll" TargetControlID="hideModalPopupViaClientOrginal1">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panel1" runat="server" Width="400px" Height="250px" BackColor="#FFFFFF"
        CssClass="RoundpanelNarr1">
        <div class="Ttlepopu">
            <label class="labelChange">
                Add Job
            </label>
        </div>
        <fieldset style="border: solid 1px black; padding: 10px; padding-top: 5px; height: 150px;">
            <table>
                <tr>
                    <td>
                        <label>
                            Job</label>
                    </td>
                    <td style="width: 250px;">
                        <label id="lblJobnames">
                        </label>
                        <select id="ddlJob" class="DropDown" style="width: 240px; display: none;">
                            <option value="0">Select</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label>
                            Remain Hours
                        </label>
                    </td>
                    <td>
                        <input type="text" class="txtbox" id="txtRemainHrs" readonly="readonly" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label>
                            Allocate Hour</label>
                    </td>
                    <td>
                        <input type="text" class="txtbox" id="txtAHrs" />
                    </td>
                </tr>
            </table>
        </fieldset>
        <div style="padding: 15px">
            <input id="BtnSaveJob" type="button" class="TbleBtns TbleBtnsPading" value="Save" />
            &nbsp;
            <input id="BtnClose" type="button" class="TbleBtns TbleBtnsPading" value="Cancel" />
        </div>
    </asp:Panel>
    <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server"></asp:Button><br />
    <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" BackgroundCssClass="modalBackground"
        CancelControlID="btnCancel" BehaviorID="ListModalPopupBehavior" DropShadow="False"
        PopupControlID="panel10" RepositionMode="RepositionOnWindowScroll" TargetControlID="hideModalPopupViaClientOrginal2">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panel10" runat="server" Width="400px" Height="250px" BackColor="#FFFFFF"
        CssClass="RoundpanelNarr1">
        <div class="Ttlepopu">
            <label class="labelChange">
                Alloacate Budgeting Hours
            </label>
        </div>
        <fieldset style="border: solid 1px black; padding: 10px; padding-top: 5px; height: 150px;">
            <table>
                <tr>
                    <td colspan="2">
                        <label>
                            Budget Date</label>
                    </td>
                    <td colspan="2">
                        <input type="date" class="txtbox" id="txtDate" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <label>
                            Budget Hour</label>
                    </td>
                    <td colspan="2">
                        <input type="text" class="txtbox" onblur="ValidBudgetHours(2)" id="txtBudAllocHrs" />
                    </td>
                </tr>
            </table>
        </fieldset>
        <div style="padding: 15px">
            <input id="BtnSubmit" type="button" class="TbleBtns TbleBtnsPading" value="Save" />
            &nbsp;
           
            <input id="btnCancel" type="button" class="TbleBtns TbleBtnsPading" value="Cancel" />
        </div>
    </asp:Panel>
    <asp:HiddenField ID="hdncompid" runat="server" />
    <asp:HiddenField ID="hdnStaffcode" runat="server" />
    <asp:HiddenField ID="hdnBudHrs" runat="server" />
    <asp:HiddenField ID="hdnBudHoursId" runat="server" Value="0" />
    <asp:HiddenField ID="hdnDid" runat="server" />
    <asp:HiddenField ID="hdnJobBudId" runat="server" />
    <asp:HiddenField ID="hdnJobHrs" runat="server" />
    <asp:HiddenField ID="hdndeptHrs" runat="server" />
    <asp:HiddenField ID="hdnremainHrs" runat="server" Value="0" />
    <asp:HiddenField ID="hdnBudId" runat="server" />
    <asp:HiddenField ID="hdnDeleteBudId" runat="server" />
    <asp:HiddenField ID="hdnIP" runat="server" />
    <asp:HiddenField ID="hdnName" runat="server" />
    <asp:HiddenField ID="hdnUser" runat="server" />

</div>
