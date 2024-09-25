<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Budgeting_Allocation.ascx.cs"
    Inherits="controls_Budgeting_Allocation" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<link href="../StyleCss/Divstyle.css" rel="stylesheet" type="text/css" />
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="javascript">
    var main_obj = [];
    $(document).ready(function () {
        Get_Budgeting_Allocation_Rolenames();

        //////On Role Change Get His Permission
        $("#selectRoles").on('change', function () {
            Get_Budgeting_Allocation_BudgetingType();
        });
        //////////get dropdown of using thair selections
        $("#ddlBudType").on('change', function () {
            ClearAll();
            if ($("#ddlBudType").val() != '0') {

                $("#ddlProject").show();
                $("#lblProject").text('Project');
                Get_Budgeting_Allocation_ClientProjectDepartmentJob();

            }
            else {
                ClearAll();
            }
        });


        /////////when Project Budgeting

        $("#ddlProject").on('change', function () {
            if ($("#ddlBudType").val() == 'Project') {
                clearforProject();
                Get_Budgeting_Allocation_Details();
                $("#tblDeparments").hide();
            }
            else {
                $("#tblDeparments").show();
                Get_Budgeting_Allocation_Details();
                clearforDept();
            }
        });
        //        $("#ddlDepartment").on('change', function () {
        //            if ($("#ddlBudType").val() == 'Department') {
        //                Get_Budgeting_Allocation_Details();
        //            }
        //        });

        $("#ddlJob").on('change', function () {
            if ($("#ddlBudType").val() == 'Job') {
                Get_Budgeting_Allocation_Details();
            }
        });
        //////////save first time projected budget Hours
        $("#btnButSave").on('click', function () {
            if ($("#ddlProject").val() == '0') {
                alert("Please Select Project");
                return false;
            }
            Save_Budgeting_Allocation_ClientProjectDepartmentJob();
        });
        $("#btnCancel").on('click', function () {
            $("#txtBuffHrs").val(parseFloat($("#txtAllocHrs").val()) - parseFloat($("#txtBudHrs").val()));
        });

        $("#BtnClose").on('click', function () {
            Get_Budgeting_Allocation_Details();
        });

        ///////////Save Department with Allocation

        $("#BtnAddDept").on('click', function () {
            if ($("#ddlDepartment").val() == '0' && $("[id*=hdnBudHoursId]").val() == '0') {
                alert("Please Select Department");
                return false;
            }
            if ($("#txtAHrs").val() == 0 || $("#txtAHrs").val() == ' ') {
                alert("Please Add Hours");
                return false;
            }
            var deffHrs = parseFloat($("#txtAHrs").val()) - parseFloat($("[id*=hdnDeptHrs]").val())
            if (deffHrs < 0) {
                alert("Allocated hours can not be less than Budgeted hoursF");
                return false;
            }
            Save_Budgeting_Allocation_Departments_Hours();
        });

        /////////// save budgeting Hours
        $("#BtnSubmit").on('click', function () {
            Save_Budgeting_Allocation_Budgeted_Hours();

        });

        $("#BtnAllocHrs").on('click', function () {
            if ($("#ddlBudType").val() != '0') {
                if ($("#ddlProject").val() == '0') {
                    alert("Please Select Project");
                    return false;
                }
                else {
                    if ($("#ddlBudType").val() == 'Department') {
                        if ($("[id*=hdnBudHoursId]").val() == '0') {
                            alert("Please Select Department");
                            return false;
                        }
                    }
                    else {
                        if ($("#ddlBudType").val() == 'Job') {
                            if ($("#lblJob").val() == '0') {
                                alert("Please Select Job");
                                return false;
                            }
                        }
                    }
                }
            } else {
                alert("Select Budget Type");
                return false;
            }
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
            ///$("#txtDate").prop('readonly', '');
            $find("ListModalPopupBehavior").show();
        });


        $("#BtnAdd").on('click', function () {
            if ($("#ddlProject").val() == '0') {
                alert("Please Select Project");
            }
            $("#ddlDepartment").show();
            $("[id*=hdnBudHoursId]").val('0');
            $("#txtAHrs").val('0.00');
            $("#lbldeptnames").text(":");
            $find("ListModalPopupAddId").show();

        });
        $("#btnBack").on('click', function () {
            clearforDept();
            $("#btnBack").hide();
        });

    });

    function ClearAll() {
        $("#ddlProject").hide();
        $("#ddlJob").hide();
        $("#lblJob").text('');
        $("#lblAllocHrs").text('');
        $("#lblBudHrs").text('');
        $("#lblBuffHrs").text('');
        $("#tblBudgetDetails").hide();
        $("#txtAllocHrs").hide();
        $("#txtBudHrs").hide();
        $("#txtBuffHrs").hide();
        $("#btnButSave").hide();
        $("#BtnAllocHrs").hide();
        $("#BtnAdd").show();
        $("#lblProject").text('');
        $("#lblProjectHrs").text('');
        $("#tblDeparments").hide();
    }
    function clearforProject() {
        
        $("#lblProject").text('Project');
        $("#ddlJob").hide();
        $("#lblJob").text('');
        $("#lblAllocHrs").text('Allocated Hrs.');
        $("#lblBudHrs").text('Budgeted Hrs.');
        $("#lblBuffHrs").text('Buffer Hrs.');
        $("#tblBudgetDetails").show();
        $("#txtAllocHrs").show();
        $("#txtBudHrs").show();
        $("#txtBuffHrs").show();
        $("#btnButSave").show();
        $("#BtnAllocHrs").show();
        $("#BtnAdd").hide();
        $("#tblDeparments").hide();
        $("#lblProjectHrs").text('');
    }

    function clearforDept() {
        $("#ddlProject").show();
        $("#ddlJob").hide();
        $("#lblJob").text('');
        $("#lblAllocHrs").text('');
        $("#lblBudHrs").text('');
        $("#lblBuffHrs").text('');
        $("#tblBudgetDetails").hide();
        $("#txtAllocHrs").hide();
        $("#txtBudHrs").hide();
        $("#txtBuffHrs").hide();
        $("#btnButSave").hide();
        $("#BtnAllocHrs").hide();
        $("#BtnAdd").show();
        $("#lblProject").text('Project');
        //$("#lblProjectHrs").text('');
        $("#tblDeparments").show();
    }


    /////////get Project Details

    function Get_Budgeting_Allocation_Details() {

        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Get_Budgeting_Allocation_Details",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',BudgetType:"' + $("#ddlBudType").val() + '",JobId:' + $("#ddlProject").val() + ',BudDeptid:' + $("[id*=hdnBudHoursId]").val() + ',Activity:' + $("#ddlJob").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                main_obj = jQuery.parseJSON(msg.d);
                ///main_obj = main_obj[0];
                if (main_obj == null || main_obj.length == 0) {
                    alert("Allocation Not Found");
                    var trL = $("[id*=tblBudgetDetails] tbody tr:last-child");
                    $("[id*=tblBudgetDetails] tbody").empty();
                    $("td", trL).eq(0).html("");
                    $("td", trL).eq(1).html("");
                    $("td", trL).eq(2).html("No record found");
                    $("td", trL).eq(3).html("");
                    $("td", trL).eq(4).html("");
                    $("[id*=tblBudgetDetails]").append(trL);
                    $("#txtAllocHrs").val('0.00');
                    $("#txtBudHrs").val('0.00');
                    $("#txtBuffHrs").val('0.00');
                    return false;
                } else {
                    if ($("#ddlBudType").val() == 'Project') {
                        $("#txtAllocHrs").val(main_obj[0].AllocHrs);
                    }

                    $("#txtRemainHrs").val(main_obj[0].AllocHrs);
                    $("#lblProjectHrs").text("Project Hrs:"+main_obj[0].AllocHrs);
                }
                var List_Department = main_obj[0].list_Department;
                var Deptname = main_obj[0].list_Department_Names;
                if ($("#ddlBudType").val() == 'Department') {
                    Bind_Departments(List_Department, Deptname);
                }
                var myList = main_obj[0].list_Budgeting;
                var BudHrs = 0;
                if (myList == null) {
                    var trL = $("[id*=tblBudgetDetails] tbody tr:last-child");
                    $("[id*=tblBudgetDetails] tbody").empty();
                    $("td", trL).eq(0).html("");
                    $("td", trL).eq(1).html("");
                    $("td", trL).eq(2).html("No record found");
                    $("td", trL).eq(3).html("");
                    $("td", trL).eq(4).html("");

                    $("[id*=tblBudgetDetails]").append(trL);
                    trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);
                    if ($("#ddlBudType").val() == "Project") {
                        $("#txtBuffHrs").val(main_obj[0].AllocHrs);
                    }
                }
                else {
                    if (myList.length == 0) {
                        var trL = $("[id*=tblBudgetDetails] tbody tr:last-child");
                        $("[id*=tblBudgetDetails] tbody").empty();
                        $("td", trL).eq(0).html("");
                        $("td", trL).eq(1).html("");
                        $("td", trL).eq(2).html("No record found");
                        $("td", trL).eq(3).html("");
                        $("td", trL).eq(4).html("");

                        $("[id*=tblBudgetDetails]").append(trL);
                        trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);
                        
                        $("#txtBudHrs").prop('readonly', '');
                        $("#txtBudHrs").val('0.00');
                        if ($("#ddlBudType").val() == "Project") {
                            $("#btnButSave").show();
                            $("#txtBuffHrs").val(main_obj[0].AllocHrs);
                        }
                    }
                    else {
                        if (myList.length > 0) {
                            var trL = $("[id*=tblBudgetDetails] tbody tr:last-child");
                            $("[id*=tblBudgetDetails] tbody").empty();

                            for (var i = 0; i < myList.length; i++) {
                                $("td", trL).eq(0).html(myList[i].sino + "<input type='hidden' id='hdnBudId' name='hdnBudId' value=" + myList[i].Id + ">");
                                $("td", trL).eq(1).html(myList[i].FromDate);
                                $("td", trL).eq(2).html(myList[i].ToDate);
                                $("td", trL).eq(3).html(myList[i].BudgetHours);
                                $("td", trL).eq(4).html("<img src='../images/edit.png' onclick='showedit($(this))'/>");

                                $("[id*=tblBudgetDetails]").append(trL);
                                trL = $("[id*=tblBudgetDetails] tbody tr:last-child").clone(true);
                                BudHrs = BudHrs + parseFloat(myList[i].BudgetHours);
                            }
                            if (BudHrs > 0) {
                                $("#txtBudHrs").prop('readonly', 'readonly');
                                $("#btnButSave").hide();
                                $("#txtBudHrs").val(BudHrs+'.00');
                            }
                            else {
                                $("#txtBudHrs").prop('readonly', '');
                                if ($("#ddlBudType").val() == "Project") {
                                    $("#btnButSave").show();
                                }
                            }


                           
                                $("#txtBuffHrs").val(parseFloat($("#txtAllocHrs").val()) - BudHrs);
                                $("#txtBudHrs").val(BudHrs);
                            

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

    function Bind_Departments(Departments, Deptname) {
        var totalHrs = $("#txtRemainHrs").val();
        if (Departments == null || Departments.length == 0) {
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
        }
        else {
            var trL = $("[id*=tblDeparments] tbody tr:last-child");
            $("[id*=tblDeparments] tbody").empty();
            
            for (var i = 0; i < Departments.length; i++) {

                $("td", trL).eq(0).html(Departments[i].srno + "<input type='hidden' id='hdndepid' name='hdndepid' value='" + Departments[i].Id + "'>");
                    $("td", trL).eq(1).html(Departments[i].Name);
                    $("td", trL).eq(2).html(Departments[i].AllocHrs);
                    $("td", trL).eq(3).html(Departments[i].BudgetHours);
                    $("td", trL).eq(4).html(Departments[i].BuffHours);
                    $("td", trL).eq(5).html("<img src='../images/edit.png' onclick='showeditDepartment($(this))'/>");
                    $("td", trL).eq(6).html("<img src='../images/Delete.png' onclick='showDeleteDepartment($(this))'/>");
                    $("td", trL).eq(7).html("<span id='spAllc' style='color:blue; cursor:pointer; ' onclick='ShowAlloc($(this))'>Allocate</span>");
                    $("[id*=tblDeparments]").append(trL);
                    trL = $("[id*=tblDeparments] tbody tr:last-child").clone(true);
                    totalHrs = parseFloat(totalHrs) + parseFloat(Departments[i].AllocHrs);
                
            }
            
            $("#lblProjectHrs").text("Project Hrs : " +totalHrs+'.00');
        }
        if (Deptname == null || Deptname.length == 0) { }
        else {
            $("[id*=ddlDepartment]").empty();
            $("[id*=ddlDepartment]").append("<option value=" + 0 + ">Select</option>");
            for (var i = 0; i < Deptname.length; i++) {
                $("[id*=ddlDepartment]").append("<option value=" + Deptname[i].Id + ">" + Deptname[i].Name + "</option>");
            }
        }
    }

    function showDeleteDepartment(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdndepid]").val();
        if (row.find("td").eq(3).html() == '' || parseInt(row.find("td").eq(3).html()) == 0) {
            var Res = confirm("Want to Delete");
            if (Res) {
                Delete_Budgeting_Allocation_Department(Rtid);
            }
        }
        else {
            alert("Cant Delete already Budgeted");
        }
    }

    function Delete_Budgeting_Allocation_Department(Rtid) {
        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Delete_Budgeting_Allocation_Department",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',BudDeptId:' + Rtid + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            alert("Data Saved Successfully..");
                            Get_Budgeting_Allocation_Details();
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
    }

    function ShowAlloc(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdndepid]").val();

        $("[id*=hdnBudHoursId]").val(Rtid);
        Get_Budgeting_Allocation_Details();
        $("#txtAllocHrs").show();
        $("#txtBudHrs").show();
        $("#txtBuffHrs").show();
        $("#lblAllocHrs").text('Allocated Hrs.');
        $("#lblBudHrs").text('Budgeted Hrs.');
        $("#lblBuffHrs").text('Buffer Hrs.');
        $("#txtAllocHrs").val(row.find("td").eq(2).html());
        if (row.find("td").eq(3).html() == '') {
            $("#txtBudHrs").val('0.00');
            $("#btnButSave").show();
        } else {
            $("#txtBudHrs").val(row.find("td").eq(3).html());
            $("#btnButSave").hide();
            $("#BtnAllocHrs").show();
            $("#btnBack").show();

        }
        $("#BtnAdd").hide();
        $("#txtBuffHrs").val(row.find("td").eq(4).html());
        $("#tblDeparments").hide();
        $("#tblBudgetDetails").show();
       

    }
    function showeditDepartment(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdndepid]").val();
        $("[id*=hdnBudHoursId]").val(Rtid);
        var Deptname = row.find("td").eq(1).html();
        $("#lbldeptnames").text(":" + Deptname);
        $("#txtAHrs").val(row.find("td").eq(2).html());
        $("[id*=hdnremainHrs]").val(row.find("td").eq(2).html());
        $("[id*=hdnDeptHrs]").val(row.find("td").eq(3).html());
        $("#ddlDepartment").hide();
        $find("ListModalPopupAddId").show();
    }

    function showedit(i) {
        var row = i.closest("tr");
        var Rtid = row.find("input[name=hdnBudId]").val();
         $("[id*=hdnBudId]").val(Rtid);
        var BudHrs = row.find("td").eq(3).html();
        var BudDate = row.find("td").eq(1).html().split('/');
        $("#txtBuffHrs").val(parseFloat($("#txtBuffHrs").val()) + parseFloat(BudHrs));
        $("#txtBudAllocHrs").val(BudHrs);

        $("#txtDate").val(BudDate[2] + "-" + BudDate[1] + "-" + BudDate[0]);
        ///$("#txtDate").prop('readonly', '');
        $find("ListModalPopupBehavior").show();
    }


    function Save_Budgeting_Allocation_Budgeted_Hours() {
        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Save_Budgeting_Allocation_Budgeted_Hours",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + $("#ddlProject").val() + ',BudDeptId:' + $("[id*=hdnBudHoursId]").val() + ',Activity:' + $("#ddlJob").val() + ',BudHrs:"' + $("#txtBudAllocHrs").val() + '",BudgetType:"' + $("#ddlBudType").val() + '",BudHrsId:' + $("[id*=hdnBudId]").val() + ',BudDate:"' + $("#txtDate").val() + '"}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            alert("Data Saved Successfully..");
                            Get_Budgeting_Allocation_Details();
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
    }


    function Save_Budgeting_Allocation_Departments_Hours() {
        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Save_Budgeting_Allocation_Departments_Hours",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + $("#ddlProject").val() + ',Deptid:' + $("#ddlDepartment").val() + ',BudHrs:"' + $("#txtAHrs").val() + '",BudgetType:"' + $("#ddlBudType").val() + '",HdnDeptId:' + $("[id*=hdnBudHoursId]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            alert("Data Saved Successfully..");
                            Get_Budgeting_Allocation_Details();
                            $find("ListModalPopupAddId").show();
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

    function Save_Budgeting_Allocation_ClientProjectDepartmentJob() {
        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Save_Budgeting_Allocation_ClientProjectDepartmentJob",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',JobId:' + $("#ddlProject").val() + ',BudDeptid:' + $("[id*=hdnBudHoursId]").val() + ',Activity:' + $("#ddlJob").val() + ',BudHrs:"' + $("#txtBudHrs").val() + '",BuffHrs:"' + $("#txtBuffHrs").val() + '",BudgetType:"' + $("#ddlBudType").val() + '"}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            alert("Data Saved Successfully..");
                            Get_Budgeting_Allocation_Details();
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

    function AddBuffer(i) {
        if (i == 1) {
            $("#txtBuffHrs").val(parseFloat($("#txtBuffHrs").val()) + parseFloat($("#txtBudHrs").val()));
            $("[id*=hdnBudHrs]").val($("#txtBudHrs").val());
        }
        if (i == 2) {
            $("#txtBuffHrs").val(parseFloat($("#txtBuffHrs").val()) + parseFloat($("#txtBudAllocHrs").val()));
            $("[id*=hdnBudHrs]").val($("#txtBudAllocHrs").val());
        }
        
    }

    function ValidBudgetHours(i) {
        if (i == 1) {
            var defHrs = parseFloat($("#txtAllocHrs").val()) - parseFloat($("#txtBudHrs").val());
            if ($("#txtBudHrs").val() == '') { $("#txtBudHrs").val('0.00'); return false; }
            if (defHrs > -1) {
                $("#txtBuffHrs").val(defHrs);
            }
            else {
                alert("Budgeted Hours Gerater Than Project Hours");
                $("#txtBudHrs").val($("[id*=hdnBudHrs]").val());
                $("#txtBuffHrs").val(parseFloat($("#txtBuffHrs").val()) - parseFloat($("[id*=hdnBudHrs]").val()));
                return false;
            }
        }
        if (i == 2) {
            var defHrs = parseFloat($("#txtBuffHrs").val()) - parseFloat($("#txtBudAllocHrs").val());
            if (defHrs > -1) {
                $("#txtBuffHrs").val(defHrs);
            }
            else {
                alert("Budgeted Hours Gerater Than Allocated Hours");
                $("#txtBudAllocHrs").val($("[id*=hdnBudHrs]").val());
                $("#txtBuffHrs").val(parseFloat($("#txtBuffHrs").val()) - parseFloat($("[id*=hdnBudHrs]").val()));
                return false;
            }
        }
        if (i == 4) {
            var Hrs = parseFloat($("#txtRemainHrs").val()) + parseFloat($("[id*=hdnremainHrs]").val()) - parseFloat($("#txtAHrs").val());
            if (Hrs > -1) {
                $("#txtRemainHrs").val(parseFloat($("#txtRemainHrs").val()) + parseFloat($("[id*=hdnremainHrs]").val()) - parseFloat($("#txtAHrs").val()) + '.00');
            }
            else {
                alert("Allocated Hours is less Than Remains");
                $("#txtAHrs").val('0.00');
                return false;
            }
        }
    }

    function Get_Budgeting_Allocation_ClientProjectDepartmentJob() {
        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Get_Budgeting_Allocation_ClientProjectDepartmentJob",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',StaffCode:' + $("[id*=hdnStaffcode]").val() + ',RoleID:' + $("[id*=selectRoles]").val() + ',Budgeting_Type:"' + $("#ddlBudType").val() + '"}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) { }
                else {
                    if (myList.length == 0) { }
                    else {
                        if (myList.length > 0) {
                            $("[id*=ddlProject]").empty();
                            $("[id*=ddlProject]").append("<option value=" + 0 + ">Select</option>");
                            $("[id*=ddlDepartment]").empty();
                            $("[id*=ddlDepartment]").append("<option value=" + 0 + ">Select</option>");
                            $("[id*=ddlJob]").empty();
                            $("[id*=ddlJob]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {
                                if (myList[i].Type == 'Project') {
                                    $("[id*=ddlProject]").append("<option value=" + myList[i].Id + ">" + myList[i].Name + "</option>");
                                }
                                if (myList[i].Type == 'Department') {
                                    $("[id*=ddlDepartment]").append("<option value=" + myList[i].Id + ">" + myList[i].Name + "</option>");
                                }
                                if (myList[i].Type == 'Job') {
                                    $("[id*=ddlJob]").append("<option value=" + myList[i].Id + ">" + myList[i].Name + "</option>");
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
    function Get_Budgeting_Allocation_Rolenames() {
        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Get_Budgeting_Allocation_Rolenames",
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

    function Get_Budgeting_Allocation_BudgetingType() {
        $.ajax({
            type: "POST",
            url: "../Handler/Budgeting_Allocation.asmx/Get_Budgeting_Allocation_BudgetingType",
            data: '{Compid:' + $("[id*=hdncompid]").val() + ',StaffCode:' + $("[id*=hdnStaffcode]").val() + ',RoleID:' + $("[id*=selectRoles]").val() + '}',
            dataType: 'json',
            contentType: "application/json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                if (myList == null) {
                    $("[id*=ddlBudType]").empty();
                    $("[id*=ddlBudType]").append("<option value=" + 0 + ">Select</option>");
                }
                else {
                    if (myList.length == 0) {
                        $("[id*=ddlBudType]").empty();
                        $("[id*=ddlBudType]").append("<option value=" + 0 + ">Select</option>");
                    }
                    else {
                        if (myList.length > 0) {
                            $("[id*=ddlBudType]").empty();
                            $("[id*=ddlBudType]").append("<option value=" + 0 + ">Select</option>");
                            for (var i = 0; i < myList.length; i++) {

                                $("[id*=ddlBudType]").append("<option value=" + myList[i].Budgeting_type + ">" + myList[i].Budgeting_type + "</option>");
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
    label
    {
        font-weight: bold;
    }
</style>
<div class="divstyle">
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="Label2" runat="server" CssClass="Head1" Text="Rolewise Budgeting Allocation"></asp:Label>
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
                <select id="selectRoles" class="DropDown" style="width: 250px; ">
                    <option value="0">Select</option>
                </select>
            </td>
            <td style="width: 140px;">
                <label>
                    Budgeting Type
                </label>
            </td>
            <td style="width: 250px;">
                <select id="ddlBudType" class="DropDown" style="width: 250px;">
                    <option value="0">Select</option>
                </select>
            </td>
            <td><input type="button" id="btnBack" class="TbleBtns TbleBtnsPading" value="Back" style=" display:none" /></td>
        </tr>
        <tr>
            <td>
                <label id="lblProject">
                </label>
            </td>
            <td style="width: 250px;">
                <select id="ddlProject" class="DropDown" style="width: 250px; display: none;">
                    <option value="0">Select</option>
                </select>
            </td>
     
          <td><label id="lblProjectHrs"></label></td>
        </tr>
        <tr>
            <td>
                <label id="lblJob">
                </label>
            </td>
            <td style="width: 250px;">
                <select id="ddlJob" class="DropDown" style="width: 250px; display: none;">
                    <option value="0">Select</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>
                <label id="lblAllocHrs">
                    </label>
            </td>
            <td>
                <input type="text" class="txtbox" id="txtAllocHrs" readonly="readonly" style=" display:none;" />
            </td>
            <td>
                <label id="lblBudHrs">
                   
                </label>
            </td>
            <td>
                <input type="text" onblur="ValidBudgetHours(1)"  value="0.00"
                    class="txtbox" id="txtBudHrs" style=" display:none;" />
            </td>
            <td>
                <label id="lblBuffHrs">
                    
                </label>
            </td>
            <td>
                <input type="text" class="txtbox" id="txtBuffHrs" style=" display:none;" />
            </td>
        </tr>
        <tr>
            <td>
            </td>
            <td>
                <input id="btnButSave" type="button" class="TbleBtns TbleBtnsPading" value="Save" style=" display:none" />
                <input id="BtnAllocHrs" type="button" class="TbleBtns TbleBtnsPading" value="Allocate Hours" style=" display:none" />
                <input id="BtnAdd" type="button" class="TbleBtns TbleBtnsPading" value="Add" style=" display:none" />
            </td>
        </tr>
    </table>
    <center>
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
            </tr>
        </tbody>
    </table>
    <table id="tblDeparments" border="1px" class="norecordTble" style="border-collapse: collapse;
        width: 95%; display:none;">
        <thead>
            <tr>
                <th class="grdheader">
                    Sr.No
                </th>
                <th class="grdheader">
                    Departments
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
                <th></th>
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
                <td>
                </td>
                <td>
                </td>
                <td></td>
            </tr>
        </tbody>
    </table>
    </center>
    <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server">
    </asp:Button><br />
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
                        <input type="text" class="txtbox" onblur="ValidBudgetHours(2)"  id="txtBudAllocHrs" />
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



        <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal1" runat="server">
    </asp:Button><br />
      <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="modalBackground"
        CancelControlID="BtnClose" BehaviorID="ListModalPopupAddId" DropShadow="False"
        PopupControlID="panel1" RepositionMode="RepositionOnWindowScroll" TargetControlID="hideModalPopupViaClientOrginal1">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panel1" runat="server" Width="400px" Height="250px" BackColor="#FFFFFF"
        CssClass="RoundpanelNarr1">
        <div class="Ttlepopu">
            <label class="labelChange">
                Add Department
            </label>
        </div>
        <fieldset style="border: solid 1px black; padding: 10px; padding-top: 5px; height: 150px;">
            <table>
                <tr>
                    <td>
                        <label >
                            Department</label>
                    </td>
                   
                      <td style="width: 250px;">
                      <label id="lbldeptnames"></label>
                <select id="ddlDepartment" class="DropDown" style="width: 240px; display: none;">
                    <option value="0">Select</option>
                    
                </select>
            </td>
                </tr>
                <tr> <td><label>Remain Hours </label> </td>
                    <td><input type="text" class="txtbox" id="txtRemainHrs" readonly="readonly"/></td></tr>
                <tr>
                    <td>
                        <label>
                            Allocate Hour</label>
                    </td>
                    <td >
                        <input type="text" class="txtbox" id="txtAHrs" onblur="ValidBudgetHours(4)" />
                    </td>
                </tr>
            </table>
        </fieldset>
        <div style="padding: 15px">
            <input id="BtnAddDept" type="button" class="TbleBtns TbleBtnsPading" value="Save" />
            &nbsp;
            <input id="BtnClose" type="button" class="TbleBtns TbleBtnsPading" value="Cancel" />
          
        </div>
    </asp:Panel>




    <asp:HiddenField ID="hdncompid" runat="server" />
    <asp:HiddenField ID="hdnStaffcode" runat="server" />
    <asp:HiddenField ID="hdnBudHrs" runat="server" />
    <asp:HiddenField ID="hdnBudHoursId" runat="server" Value="0" />
     <asp:HiddenField ID="hdnDid" runat="server" />
     <asp:HiddenField ID="hdnBudId" runat="server" />
     <asp:HiddenField ID="hdnDeptHrs" runat="server" />
     <asp:HiddenField ID="hdnremainHrs" runat="server" Value="0" />
</div>
