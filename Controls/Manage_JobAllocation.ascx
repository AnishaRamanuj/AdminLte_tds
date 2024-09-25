<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Manage_JobAllocation.ascx.cs"
    Inherits="controls_Manage_JobAllocation" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<script src="../jquery/dist/jquery.contextMenu.js" type="text/javascript"></script>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>
<link href="../jquery/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />


    <script src="../jquery/jquery.searchabledropdown-1.0.8.min.js" type="text/javascript"></script>

<%--    <script src="../jquery/Selectize/selectize.js" type="text/javascript"></script>
    <script src="../jquery/Selectize/es5.js" type="text/javascript"></script>
    <script src="../jquery/Selectize/index.js" type="text/javascript"></script>
    <link href="../jquery/Selectize/normalize.css" rel="stylesheet" type="text/css" />--%>
<script language="javascript" type="text/javascript">

    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        $("[id*=divAddEdit]").hide();
        $("[id*=editsavedv]").hide();
        $("[id*=EditStfBud]").hide();
        $("[id*=StfBud]").hide();
        $("[id*=PrjBud]").hide();
        //$("[id*=Divbudget]").hide();
        $("[id*=EditStaffBud]").hide();
        $("[id*=hdnStfBud_New]").val('');
        var bug_for_clickon_project_budgeting = 0;
        var compid = 0;
        var PageSize = 25;
        var pageIndex = $("[id*=hdnpageIndex]").val();
        compid = $("[id*=hdnCompanyid]").val();
        $("[id*=hdnPages]").val(1);
        var jobid = 0;
        Bind_Jobs(1, 25);
        CreateTabs();
        Bind_Staff(compid, jobid);
        Bind_Approver(compid, jobid, 0);
        Bind_Dept(compid, jobid);
        $("[id*=lblassgnCount]").html('(0)');
        $("[id*=lblStaffCount]").html('(0)');
        // Bind_Staff_Vals(compid, jobid);
        //        fillData(compid, jobid);

        // For dynamic tabs 
        jQuery('.tab-links a').on('click', function (e) {
            var currentAttrValue = jQuery(this).attr('href');

            // Show/Hide Tabs
            jQuery('.tabs ' + currentAttrValue).show().siblings().hide();

            // Change/remove current tab to active
            jQuery(this).parent('li').addClass('active').siblings().removeClass('active');

            e.preventDefault();
        });

        //$("[id*= ChkAssg]").live('click', function () {
        //    var chk = $("[id*= ChkAssg]").is(':checked');
        //    $("input[name=chkAdpt]").each(function () {
        //        if (chk == true) {
        //            $(this).attr('checked', 'checked');
        //        }
        //        else {
        //            $(this).removeAttr('checked');
        //        }
        //        var sftrow = $(this).closest("tr");
        //        var currentobj = sftrow.find("input[name=hdnAdpid]").val();
        //        var chkprop = $(this).is(':checked');
        //        Chk_DeptnStf(currentobj, chkprop)
        //    });
        //});

        $("#selectStatus").on('change', function () {
            Bind_Jobs(1, 25);
        });

        $("[id*=btnsrchjob]").live('click', function () {
            Bind_Jobs(1, 25);
        });

        $("[id*=btnCancel]").live('click', function () {
            $("[id*=DivGrd]").show();
            $("[id*=divAddEdit]").hide();
            $("[id*=editsavedv]").hide();
            ClearData();
        });

        $("[id*=btnadd]").live('click', function () {
            document.getElementById("drpclient").disabled = false;
            document.getElementById("drpjob").disabled = false;
            fillData(compid, jobid);
            $("[id*=DivGrd]").hide();
            $("[id*=divAddEdit]").show();
            $("[id*=editsavedv]").show();
            $("[id*=tdclient]").show();
            $("[id*=tdproject]").show();
            $("[id*=tdjob]").show();

            $("[id*=hdnjid]").val('0');
            ClearData();
        });

        $("[id*=drpclient]").live('change', function () {
            var cid = $("[id*=drpclient]").val();
            var jobid = 0;
            var pid = 0;
            if (cid == '') {
            }
            else {
                Bind_Project(compid, cid, jobid, pid);
            }

        });

        $("[id*=drpproject]").live('change', function () {
            var prj = $("[id*=drpproject]").val();
          
            if (prj != '' || prj != 0) {
                Bind_ProjectStartEnd(compid, prj);
            }
   
            if ($("[id*=hdnlink]").val() == "1") {
                var pid = $("[id*=drpproject]").val();
                Bind_JobName(compid, jobid, pid, 1);
            }
            //            else {
            //                Bind_JobName(compid, jobid, pid, 0);
            //            }
        });




        $("[id*=drpjob]").live('change', function () {
            if ($("[id*=hdnlink]").val() == "1") {
                var mjid = $("[id*=drpjob]").val();
                Bind_Task(compid, jobid, mjid, 1)
            }
            //            else {
            //                Bind_Task(compid, jobid, mjid, 0)
            //            }
        });

        $("[id*=drpAssign]").live('change', function () {
            var aid = $("[id*=drpAssign]").val();
            Bind_AssignDept(compid, aid);
        });

        $("[id*=chkAdpt]").live('click', function () {
            $('.loader').show();
            var sftrow = $(this).closest("tr");
            var id = document.getElementById('chkAdpt').value
            var currentobj = sftrow.find("input[name=hdnAdpid]").val();
            var Assigid = sftrow.find("input[name=hdnadid]").val();
            var chkprop = $(this).is(':checked');
            var Assignrow = "", Chk = '';
            if (chkprop == true) {
                //loop made for checking the same department selected or not (Tejal 20/01/2020)
                $("input[name=chkAdpt]").each(function () {
                    Assignrow = $(this).closest("tr");
                    var Depid = Assignrow.find("input[name=hdnAdpid]").val();
                    var Asigid = Assignrow.find("input[name=hdnadid]").val();
                    chk = $(this).is(':checked');
                    if (chk == true) {
                        if (Depid == currentobj && Assigid != Asigid) {
                            alert("Assignment with same Department can not be selected!!!");
                            $("#chkAdpt", sftrow).prop("checked", false);
                        }
                    }

                });
            }

            Chk_DeptnStf(currentobj, chkprop);
            CountAssign();
            $('.loader').hide();
        });

        $("[id*=chkstf]").live('click', function () {
            CountStaff();
        });


        $("[id*=chkdp]").live('click', function () {
            $('.loader').show();
            var sftrow = $(this).closest("tr");
            var currentobj = sftrow.find("input[name=hdndpid]").val();
            var chkprop = $(this).is(':checked');

            $("input[name=chkstf]").each(function () {
                var sftrow = $(this).closest("tr");
                var hdnsid = sftrow.find("input[name=hdnsdpid]").val();
                if (hdnsid == currentobj) {
                    if (chkprop) {
                        $(this).attr('checked', 'checked');

                    }
                    else {
                        $(this).removeAttr('checked');
                    }
                }

            });

        });


        $("[id*=chkstf]").live('click', function () {
            $('.loader').show();
            var sftrow = $(this).closest("tr");
            var currentobj = sftrow.find("input[name=hdnsid]").val();
            var currenthod = sftrow.find("input[name=hdnhod]").val();
            var chkprop = $(this).is(':checked');

            $("input[name=chkApp]").each(function () {
                var sftrow = $(this).closest("tr");
                var hdnsid = sftrow.find("input[name=hdnapprid]").val();
                if (hdnsid == currentobj && currenthod == "true") {
                    if (chkprop) {
                        $(this).attr('checked', 'checked');

                    }
                    else {
                        $(this).removeAttr('checked');
                    }
                }
                CountStaff();
            });

        });

        $("[id*=chkdp1]").live('click', function () {
            $('.loader').show();
            var sftrow = $(this).closest("tr");
            var currentobj = sftrow.find("input[name=hdndpid]").val();
            var chkprop = $(this).is(':checked');
            // Check for Staffs
            $("input[name=chkstf]").each(function () {
                var sftrow = $(this).closest("tr");
                var hdnsid = sftrow.find("input[name=hdnsdpid]").val();
                if (hdnsid == currentobj) {
                    if (chkprop) {
                        $(this).attr('checked', 'checked');
                        //sftrow.css('display', 'block');
                    }
                    else {
                        $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                    }
                }

            });

        });

        $("[id*=btnSave]").live('click', function () {
            var jobid = $("[id*=hdnjid]").val();
            var cid = $("[id*=drpclient]").val();
            var pid = $("[id*=drpproject]").val();
            var sappid = $("[id*=drpdwnapp]").val();
            var fr = $("[id*=txtstartdate]").val();
            var to = $("[id*=txtactualdate]").val();
            var bill = $("[id*=DrpBillable]").val();
            var sts = $("[id*=drp_jobstatus]").val();
            var hdnAllAdpt = "0";
            var hdnAllapp = "0";
            var hdndpt = "0";
            var hdnAlltsk = "0";
            var hndtsk = "0";
            var hdnAllstf = "0";

            if (parseFloat(cid) == 0) {
                alert('Select Client');
                return;
            }
            if (parseFloat(pid) == 0) {
                alert('Select Project');
                return;
            }

            // Get all Sub Approver
            $("input[name=chkApp]:checked").each(function () {
                var chka = $(this).is(':checked');
                if (chka) {
                    hdnAllapp = $(this).val() + ',' + hdnAllapp;
                }
            });  // end function chkApp checked

            if (fr == "") {
                alert('From date cannot be blank');
                return;
            }

            if (to == "") {
                alert('To date cannot be blank');
                return;
            }

            ///////validation for start date is less than end date
            var CompareDate = Date_Proccess(fr, to)
            if (CompareDate) {
                alert("Please Select End Date Greater Than Start Date ");
                return;
            }

            if ($("[id*=hdndptwise]").val() == "1") {
                // this all will be saved as project wise and will be retrived as project wise.
                hdndpt = 1;
                $("input[name=chkAdpt]:checked").each(function () {
                    var chkprop = $(this).is(':checked');
                    if (chkprop) {
                        hdnAllAdpt = $(this).val() + ',' + hdnAllAdpt;
                    }
                });
            }

            else {
                var jid = $("[id*=drpjob]").val();
                if (parseFloat(jid) == 0) {
                    alert('Select Jobname');
                    return;
                }
                //staff
                if ($("[id*=hdnTaskwise]").val() == "1") {
                    // task 
                    var hndtsk = 1;
                    $("input[name=chktsk]:checked").each(function () {
                        var chkt = $(this).is(':checked');
                        if (chkt) {
                            hdnAlltsk = $(this).val() + ',' + hdnAlltsk;
                        }
                    });  //end function chktsk checked
                } // end if ($("[id*=hdnTaskwise]").val() == "1")
            } // end of else


            // Get all staff
            $("input[name=chkstf]:checked").each(function () {
                var chks = $(this).is(':checked');
                var row = $(this).closest("tr");
                if (chks) {
                    var ap = row.find("input[name=txtwrk]").val();
                    var frdate = row.find("input[name=dtfrdate_]").val();
                    var todate = row.find("input[name=dttodate_]").val();
                    hdnAllstf = $(this).val() + ',' + ap + ',' + frdate + ',' + todate + '^' + hdnAllstf;
                }
            });  // end function chkstf checked

            confirmSave(compid, jobid, cid, pid, sappid, fr, to, bill, sts, hdndpt, hdnAllAdpt, jid, hndtsk, hdnAlltsk, hdnAllstf, hdnAllapp);
        });


        $("[id*=btnJob_Status]").live('click', function () {
            var jobid = $("[id*=hdnjid]").val();
            var sts = $("[id*=drpstatus]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            var data = {
                currobj: {
                    CompId: compid,
                    Jobid: jobid,
                    jStatus: sts
                }
            };
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/updatestatus",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList.length > 0) {
                        $find("ListModalPopupBehavior").hide();

                        alert('Status Saved Successfully');
                    }
                    ClearData();

                    Bind_Jobs(1, 25);
                },

                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
        });

        $("[id*=btnJob_date]").live('click', function () {
            var jobid = $("[id*=hdnjid]").val();
            var from = $("[id*=txtstart]").val();
            var sts = $("[id*=txtenddate]").val();
            var compare = Date_Proccess(from, sts);
            if (compare) { alert("Please select End Date greater than From Date"); return; }
            var compid = $("[id*=hdnCompanyid]").val();
            var data = {
                currobj: {
                    CompId: compid,
                    Jobid: jobid,
                    jStatus: sts
                }
            };
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/updatenddate",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList.length > 0) {
                        $find("ListModalPopupBehavior").hide();

                        alert('End Date Saved Successfully');
                    }
                    ClearData();

                    Bind_Jobs(1, 25);
                },

                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
        });

        $("[id*=btnJob_Bill]").live('click', function () {
            var jobid = $("[id*=hdnjid]").val();
            var sts = $("[id*=drpbilliable]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            var data = {
                currobj: {
                    CompId: compid,
                    Jobid: jobid,
                    jStatus: sts
                }
            };
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/updatebillable",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList.length > 0) {
                        $find("ListModalPopupBehavior").hide();

                        alert('Data Saved Successfully');
                    }
                    ClearData();

                    Bind_Jobs(1, 25);
                },

                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });

        });

        $("[id*=btnJob_Approver]").live('click', function () {
            var jobid = $("[id*=hdnjid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            var sappid = $("[id*=drpdwnappr]").val();
            var cltid = $("[id*=hdnCltid]").val();
            var hdnAllapp = "0";

            $("input[id*=chkApp1]:checked").each(function () {
                var chka = $(this).is(':checked');
                if (chka) {
                    hdnAllapp = $(this).val() + ',' + hdnAllapp;
                }
            });
            var data = {
                currobj: {
                    CompId: compid,
                    Jobid: jobid,
                    SuperAppId: sappid,
                    hdnAllapp: hdnAllapp,
                    Cltid: cltid
                }
            };
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/updateapprover",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    $find("ListModalPopupBhr").hide();
                    alert('Data Saved Successfully');
                    ClearData();
                    Bind_Jobs(1, 25);
                },

                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });

        });

        $("[id*=btnJob_Staff]").live('click', function () {
            var jobid = $("[id*=hdnjid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            //var cltid = $("[id*=hdnCltid]").val();
            var hdnAllstf = "0";
            // Get all staff
            $("input[id*=chkstf1]:checked").each(function () {
                var chks = $(this).is(':checked');
                if (chks) {
                    hdnAllstf = $(this).val() + ',' + hdnAllstf;
                }
            });
            var data = {
                currobj: {
                    CompId: compid,
                    Jobid: jobid,
                    hdnAllstf: hdnAllstf

                }
            };
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/updatestaff",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    $find("ListModalPopupBhr").hide();

                    alert('Data Saved Successfully');

                    ClearData();

                    Bind_Jobs(1, 25);
                },

                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
        });

        $("input[name=chkSftname]").live('click', function () {
            AssignStafftoStaffBudgeting();
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

            //$("input[name=chkSftname]").each(function () {
            //    if (parrentchk == true) {
            //        $(this).attr('checked', 'checked');
            //    } else { $(this).removeAttr('checked'); }
            //});

            //Chkstaff
            var chkprop = $(this).is(':checked');
            $("input[name=chkstf]").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                    //sftrow.css('display', 'block');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
                //}

            });
            CountStaff();
            $("input[name=chkStaffBudgetCheckEmp]").each(function () {
                if (parrentchk == true) {
                    $(this).attr('checked', 'checked'); $(this).closest("tr").css('display', '');
                } else { $(this).removeAttr('checked'); $(this).closest("tr").hide(); }
            });

            $('.loader').hide();

        });


        ///////////////////////////////////////// Budgeting ///////////////////////////////////////////

        $("[id*=ddlBudgetingselection]").live("change", function () {
            BudgetingChange();
        });

        $("[id*=btnEditedStaffBudgetdAmtHours]").live('click', function () {

            var datea = $("[id*=txteditStaffBudgetedDate]").val();
            if (datea != "") {
                var start = $("[id*=hdnjstrt]").val();
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




        ///////////////////////budgeting drop down change
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
        //$("[id*=Btn1]").live('click', function () {
        //    if (bug_for_clickon_project_budgeting == 1) {
        //        //                $("[id*=EditJobwiseBud]").show();
        //        $find("Jobbudgetpopup").show();
        //        clareformEditStaffbudget();
        //        $('.loader2').fadeIn(200);
        //        GetJobWiseBudgetDetails();
        //    }
        //    bug_for_clickon_project_budgeting = 1;
        //    return false;
        //});

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
                var start = $("[id*=hdnjstrt]").val();
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


        ////////////staff budgeting---- Staff Wise Edit buttonclick
        $("#btnEditsingleStaffBudget").live('click', function () {

            $("[id*=lblStaffBudgetName]").html('');
            $("[id*=lblStaffDept]").html('');
            //            $("[id*=gvCustomers]").empty();
            $find("StaffBudgetingpopup").show();

            var row = $(this).closest("tr");
            var staffcode = $("#hdnStaffCode", row).val();
            $('.loader').fadeIn(200);
            $("[id*=hdnEditClickStaffcode]").val(staffcode);
            //            AjaxGetStaffNameAndDepartment();
            AjaxBindGridDataUsing();
            //            return false;
        });


        //$("[id*=btnBudgetSave]").live('click', function () {
        //    var jobid = $("[id*=hdnjid]").val();
        //    var compid = $("[id*=hdnCompanyid]").val();
        //    var hdndpt = $("[id*=hdndptwise]").val();
        //    var BS = $("[id*=ddlBudgetingselection]").val();
        //    var cltid = $("[id*=hdnCltid]").val();
        //    var b = 0;

        //    var hdnAllstfCheckByAjaxCode = "";
        //    var hdnAllDepAjaxCode = "";
        //    var hdnAllAppAjaxCode = "";

        //    ///////////////checked staff id with budgeting
        //    $("input[name=chkStaffBudgetCheckEmp]:checked").each(function () {
        //        var row = $(this).closest("tr");
        //        hdnAllstfCheckByAjaxCode += $(this).val() + ',';
        //        hdnAllstfCheckByAjaxCode += $("input[name=txtHours]", $(this).closest("tr")).val() + ','; ////////txthours
        //        hdnAllstfCheckByAjaxCode += $("input[name=txtStaffbudget]", $(this).closest("tr")).val() + ','; ///////////////bugets
        //        hdnAllstfCheckByAjaxCode += $("input[name=txtPlanedDrawings]", $(this).closest("tr")).val() + ','; ////////////planed drawings
        //        hdnAllstfCheckByAjaxCode += $("input[name=txtAllocatedHrs]", $(this).closest("tr")).val() + ','; ////////////Allocated Hours
        //        hdnAllstfCheckByAjaxCode += $("input[name=txtStaffActualHrs]", $(this).closest("tr")).val() + ','; //////////////txtstaffActual Hours
        //        hdnAllstfCheckByAjaxCode += "/";
        //    });

        //    if (hdnAllstfCheckByAjaxCode == "") {
        //        alert('Warning : No Staff Selected for this job !');
        //    }

        //    $("[id*=hdnstfBudCheck]").val(hdnAllstfCheckByAjaxCode);


        //    if (BS == "Project Budgeting") {
        //        b = 1;
        //    }
        //    else {
        //        b = 2;
        //    }
        //    var data = {
        //        currobj: {
        //            CompId: compid,
        //            Jobid: jobid,
        //            hdndpt: hdndpt,
        //            BudgetSelection: BS,
        //            bud_Id: b,
        //            Cltid: cltid,
        //            stfBudChk: hdnAllstfCheckByAjaxCode
        //        }
        //    };
        //    $.ajax({
        //        type: "POST",
        //        contentType: "application/json; charset=utf-8",
        //        url: "../Handler/wsJobAllocation.asmx/SaveJobWiseBudgetDetails",
        //        data: JSON.stringify(data),
        //        dataType: "json",

        //        success: function (msg) {
        //            var myList = jQuery.parseJSON(msg.d);
        //            clareformEditStaffbudget();
        //            if (myList.length > 0) {
        //                if (parseFloat(myList[0].Jobid) > 0) {
        //                    alert(b + "Budgeting saved");
        //                    $("[id*=Divbudget]").hide();
        //                    $("[id*=DivGrd]").show();
        //                    ClearData();
        //                }
        //            }


        //        },
        //        failure: function (response) {

        //        },
        //        error: function (response) {

        //        }
        //    });
        //    //Ajax end
        //});

        //$("[id*=btnBudgetCancel]").live('click', function () {
        //    $("[id*=Divbudget]").hide();
        //    $("[id*=DivGrd]").show();
        //    ClearData();
        //});
    });



    /////////date comparision function

    function ShowChange(i) {
        var row = i.closest("tr");

        var jhrs = row.find("input[name=txtwrk]").val();
        if (isNaN(jhrs) == true) {
            $("#txtwrk", row).val('0');
        }
    }

    function Date_Proccess(fr, to) {
        var starrDate = fr.split('/');
        var toDate = to.split('/');
        var Sdate = new Date(starrDate[2], starrDate[1] - 1, starrDate[0]);
        var Edate = new Date(toDate[2], toDate[1] - 1, toDate[0]);

        return Sdate > Edate;
    }

    function Chk_DeptnStf(currentobj, chkprop) {

        // Check for departments
        $("input[name=chkdp]").each(function () {
            var sftrow = $(this).closest("tr");
            var hdndepid = sftrow.find("input[name=hdndpid]").val();
            if (hdndepid == currentobj) {
                if (chkprop) {
                    $(this).attr('checked', 'checked');
                    //sftrow.css('display', 'block');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            }

        });

        // Check for Staffs
        $("input[name=chkstf]").each(function () {
            var sftrow = $(this).closest("tr");
            var hdnsid = sftrow.find("input[name=hdnsdpid]").val();
            if (hdnsid == currentobj) {
                if (chkprop) {
                    $(this).attr('checked', 'checked');
                    //sftrow.css('display', 'block');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            }

        });
        CountStaff();
    }

    function Chk_Dept(currentobj, chkprop) {

        // Check for departments
        $("input[name=chkdp]").each(function () {
            var sftrow = $(this).closest("tr");
            var hdndepid = sftrow.find("input[name=hdndpid]").val();
            if (hdndepid == currentobj) {
                if (chkprop) {
                    $(this).attr('checked', 'checked');
                    //sftrow.css('display', 'block');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            }

        });
    }

    ///Get the Count of Assign and Staff 
    function CountAssign() {
        var count = 0;
        $("input[name=chkAdpt]").each(function () {
            Assignrow = $(this).closest("tr");
            chk = $(this).is(':checked');
            if (chk == true) {
                count = count + 1;
            }
        });
        $("[id*=lblassgnCount]").html('(' + count + ')');
    }

    function CountStaff() {
        var count = 0;
        $("input[name=chkstf]").each(function () {
            Assignrow = $(this).closest("tr");
            chk = $(this).is(':checked');
            if (chk == true) {
                count = count + 1;
            }
        });
        $("[id*=lblStaffCount]").html('(' + count + ')');
    }

    function Bind_Jobs(pageIndex, pageNewSize) {
        var compid = $("[id*=hdnCompanyid]").val();
        var jStatus = $("#selectStatus").val();
        var ClientName = '';
        var projectName = '';
        if ($("[id*=txtSearchby]").val() != "") {
            if ($("[id*=ddlSearchby]").val() != "Client") {
                projectName = $("[id*=txtSearchby]").val();
                ClientName = '';
            }
            else {
                projectName = '';
                ClientName = $("[id*=txtSearchby]").val();
            }
        }


        var MJobName = ''

        var hdndpt = $("[id*=hdndptwise]").val();
        var data = {
            currobj: {
                CompId: compid,
                pageIndex: pageIndex,
                pageNewSize: pageNewSize,
                jStatus: jStatus,
                ClientName: ClientName,
                MJobName: MJobName,
                projectName: projectName,
                hdndpt: hdndpt
            }
        };
        try {
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/bind_JobGrid",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: OnSuccessJobs,

            });
        } catch (e) {

        }
    }

    function OnSuccessJobs(responce) {

        var xmlDoc = $.parseXML(responce.d);
        var xml = $(xmlDoc);
        var customers = xml.find("Table");

        $("[id*=tblGrd]").empty();
        var tbl = '';
        tbl = tbl + "<tr>";
        tbl = tbl + "<th style='text-align:left;' class='labelChange'>Sr</th>";
        tbl = tbl + "<th style='text-align:left;' class='labelChange'>Client</th>";
        tbl = tbl + "<th style='text-align:left;' class='labelChange'>Project</th>";

        if ($("[id*=hdnTaskwise]").val() == "1") {
            tbl = tbl + "<th style='text-align:left;' class='labelChange'>Jobname</th>";
            tbl = tbl + "<th style='text-align:left;' class='labelChange'>Task</th>";
        }
        tbl = tbl + "<th style='text-align:left;' class='labelChange'>Creation Date</th>";
        tbl = tbl + "<th style='text-align:left;' class='labelChange'>End Date</th>";
        tbl = tbl + "<th style='text-align:left;' class='labelChange'>Status</th>";
        tbl = tbl + "<th style='text-align:left;' class='labelChange'>Edit</th>";
        tbl = tbl + "<th style='text-align:left;' class='labelChange'>Delete</th>";

        tbl = tbl + "<tr>";

        $("[id*=tblGrd]").append(tbl);

        var tr;
        if (customers.length > 0) {
            var srno = 1;
            $.each(customers, function () {
                var customer = $(this);

                tr = '<tr><td><label id="Label20" class="labelstyle">' + $(this).find("sino").text() + '</label> <input type="hidden" id="hdnstfTot" name="hdnstfTot" value=' + $(this).find("stfTotal").text() + '></td>';
                tr = tr + '<td><label id="Label21" class="labelstyle">' + $(this).find("ClientName").text() + '</label> <input type="hidden" id="hdnjobid" name="hdnjobid" value=' + $(this).find("JobId").text() + '> </td>';
                tr = tr + '<td><label id="Label22" class="labelstyle">' + $(this).find("projectname").text() + '</label></td>';
                if ($("[id*=hdnTaskwise]").val() == "1") {
                    tr = tr + '<td><label id="Label23" class="labelstyle">' + $(this).find("mJobName").text() + '</label></td>';
                    tr = tr + '<td><label id="Label27" class="labelstyle">' + $(this).find("Taskname").text() + '</label></td>';
                }

                tr = tr + '<td><label id="Label24" class="labelstyle">' + $(this).find("CreationDate").text() + '</label></td>';
                tr = tr + '<td><label id="Label25" class="labelstyle">' + $(this).find("EndDate").text() + '</label></td>';
                tr = tr + '<td><label id="Label26" class="labelstyle">' + $(this).find("Jobstatus").text() + '</label></td>';

                var roleedit = $("[id*=hdnroleedit]").val();
                if (roleedit == 'False') { }
                else {
                    //var t = $(this).position();

                    tr = tr + '<td><img id="btnEdit"  Class="context-menu-one" src="../images/edit.png" onclick="ShowEdit($(this))"/></td>';

                }
                var roledelete = $("[id*=hdnroledelete]").val();
                if (roledelete == 'False') { }
                else {
                    tr = tr + '<td><img id="btnDel" src="../images/Delete.png" alt="Delete"  onclick="ShowDelete($(this))"/></td>';
                }
                tr = tr + '</tr>';
                $('#tblGrd').append(tr);
            });

            $(".modalganesh").hide();
            var pager = xml.find("Table1");
            var RecordCount = parseInt(pager.find("RecordCount").text());
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

            Bind_Jobs(($(this).attr('page')), 25)
        });
    }

    function fillData(compid, jobid) {
        Bind_Client(compid, jobid);
        // department wise as per aarnita
        if ($("[id*=hdndptwise]").val() == "1") {
            $("[id*=trAssign]").show();
            $("[id*=trjob]").hide();
            Bind_Assignments(compid, jobid);
            $("[id*=tr_job]").hide();
        }
        else {
            // as per AMS,De-Dietrich
            if ($("[id*=hdnTaskwise]").val() == "0") {
                $("[id*=tr_job]").show();
                Bind_JobName(compid, jobid, 0, 0);
            }
            if ($("[id*=hdnTaskwise]").val() == "1") {
                // as per AMS
                if ($("[id*=hdnlink]").val() == "0" || $("[id*=hdnlink]").val() == "") {
                    $("[id*=tr_job]").show();
                    Bind_JobName(compid, jobid, 0, 0);
                    Bind_Task(compid, jobid, 0, 0);
                }
            }
        }

        // Bind_Project(compid, cid, jobid, pid);
    }


    function removeItem(obj, prop, val) {
        var c, found = false;
        for (c in obj) {
            if (obj[c][prop] == val) {
                found = true;
                break;
            }
        }
        if (found) {
            delete obj[c];
        }
    }

    function openmenu(tt, ll) {
        items = {
            "Edit": { name: "Edit", icon: function ($element, key, item) { return 'context-menu-icon context-menu-icon-quit'; } },
            "sep1": "---------",
            "Job": { name: "Job Status" },
            "endDT": { name: "End Date" },
            "Bill": { name: "Billable" },
            //"Approver": { name: "Assign Approver" },
            "Staff": { name: "Assign Staff" },
            //"Budget": { name: "Budget" },
            "Other": { name: "Other details" }
        };




        $.contextMenu({

            selector: '.context-menu-one',
            trigger: 'left',
            determinePosition: function ($menu) {
                $menu.css('display', 'block')
            .position({ my: "center top", at: "center bottom", of: this, offset: "0 5" })



            },
            callback: function (key, options) {
                if (key == "Other") {
                    //document.getElementById('<%= btnpage.ClientID %>').click();

                    $("[id*=divAddEdit]").show();
                    $("[id*=editsavedv]").show();
                    $("[id*=DivGrd]").hide();
                    //                    $("[id*=drpclient]").disabled = true;
                    document.getElementById("drpclient").disabled = true;
                    document.getElementById("drpjob").disabled = true;
                    GetEditClient();

                }
                else {
                    modalShow(key);
                }

            },
            items: items

        });

    }


    function GetEditClient() {
        var jobid = $("[id*=hdnjid]").val();
        var compid = $("[id*=hdnCompanyid]").val();

        if ($("[id*=hdndptwise]").val() == "1") {
            $("[id*=trAssign]").show();
            $("[id*=trjob]").hide();

            $("[id*=tr_job]").hide();
        }
        else {
            // as per AMS,De-Dietrich
            if ($("[id*=hdnTaskwise]").val() == "0") {
                $("[id*=tr_job]").show();

            }
            if ($("[id*=hdnTaskwise]").val() == "1") {
                // as per AMS
                if ($("[id*=hdnlink]").val() == "0" || $("[id*=hdnlink]").val() == "") {
                    $("[id*=tr_job]").show();

                }
            }
        }


        $.ajax({
            type: "POST",
            url: "../Handler/wsJobAllocation.asmx/bind_Client",
            data: '{compid:' + compid + ',jobid:' + jobid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                //$("#drpclient").selectize()[0].selectize.destroy();
                $("[id*=drpclient]").empty();
                $("[id*=drpclient]").append("<option value=0>--Select--</option>");
                for (var i = 0; i < myList.length; i++) {

                    $("[id*=drpclient]").append("<option value='" + myList[i].Cltid + "'>" + myList[i].ClientName + "</option>");
                }

                GetEditData(jobid, compid);
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });





    }

    function GetEditData(jobid, compid) {
        var hdndpt = $("[id*=hdndptwise]").val();
        var data = {
            currobj: {
                CompId: compid,
                Jobid: jobid,
                hdndpt: hdndpt
            }

        };
        var calala = $.ajax({
            type: "POST",
            url: "../Handler/wsJobAllocation.asmx/GetDetails",
            data: JSON.stringify(data),
            dataType: "json",
            contentType: "application/json",
            success: function (msg) {
                var ListDB = jQuery.parseJSON(msg.d);

                if (parseFloat(ListDB.length) > 0) {
                    $("[id*=drpclient]").val(ListDB[0].Cltid);

                    $("[id*=DrpBillable]").val(ListDB[0].Billable);
                    var mjid = ListDB[0].mJobID;
                    $("[id*=drp_jobstatus]").val(ListDB[0].jStatus);

                    $("[id*=txtstartdate]").val(ListDB[0].CreationDate);

                    $("[id*=txtactualdate]").val(ListDB[0].todate);
                    $("[id*=drpbilliable]").val(ListDB[0].Billable);
                    $("[id*=hdnSappid]").val(ListDB[0].SuperAppId);
                    var sp = ListDB[0].SuperAppId;
                    var pid = ListDB[0].projectid
                    var cid = ListDB[0].Cltid;
                    Bind_Approver(compid, jobid, sp);
                    //$("[id*=drpdwnapp]").val(ListDB[0].SuperAppId);
                    Bind_Project(compid, cid, jobid, pid);
                    if (parseFloat(hdndpt) > 0) {
                        Bind_Assignments(compid, jobid);

                    }
                    else {
                        Bind_Staff(compid, jobid);
                        Bind_Dept(compid, jobid);
                    }
                    if (parseFloat($("[id*=hdnTaskwise]").val()) > 0) {
                        if ($("[id*=hdnlink]").val() == "1") {
                            Bind_JobName(compid, jobid, pid, 1);
                            Bind_Task(compid, jobid, mjid, 1);
                        }
                        else {
                            $("[id*=drpjob]").val(mjid);
                            Bind_Task(compid, jobid, 0, 0);
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

    function modalShow(s) {
        if (s == 'Job') {
            $find("ListModalPopupBehavior").show();
            $("[id*= divjobstatus]").show();
            $("[id*=divdates]").hide();
            $("[id*=divbiliable]").hide();
            $("[id*=divstatus]").show();
            $("[id*=divbtndate]").hide();
            $("[id*=dvbtnbill]").hide();
            // var row = $(this).closest("tr");
            var jobid = $("[id*=hdnjid]").val();
            // $("[id*=hdnjid]").val(jobid);
            var compid = $("[id*=hdnCompanyid]").val();
            var hdndpt = $("[id*=hdndptwise]").val();
            var data = {
                currobj: {
                    CompId: compid,
                    Jobid: jobid,
                    hdndpt: hdndpt
                }
            };
            //ajax start
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/GetstatusDetails",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function (msg) {
                    var ListDB = jQuery.parseJSON(msg.d);
                    if (parseFloat(ListDB.length) > 0) {
                        $("[id*=drpstatus]").val(ListDB[0].jStatus);
                        $("[id*=lblAjob]").html(ListDB[0].MJobName);
                        $("[id*=lblsupjob]").html(ListDB[0].MJobName);
                        $("[id*=lblAClient]").html(ListDB[0].ClientName);
                        $("[id*=lblsupclient]").html(ListDB[0].ClientName);
                    }
                },

                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
            //ajax end
        }

        if (s == 'endDT') {
            $find("ListModalPopupBehavior").show();
            $("[id*= divjobstatus]").hide();
            $("[id*=divdates]").show();
            $("[id*=divbiliable]").hide();
            $("[id*=divstatus]").hide();
            $("[id*=divbtndate]").show();
            $("[id*=dvbtnbill]").hide();
            var row = $(this).closest("tr");
            var jobid = $("[id*=hdnjid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            var hdndpt = $("[id*=hdndptwise]").val();
            var data = {
                currobj: {
                    CompId: compid,
                    Jobid: jobid,
                    hdndpt: hdndpt
                }
            };
            //ajax start
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/GetdateDetails",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function (msg) {
                    var ListDB = jQuery.parseJSON(msg.d);
                    if (parseFloat(ListDB.length) > 0) {
                        $("[id*=txtstart]").val(ListDB[0].CreationDate);
                        $("[id*=txtenddate]").val(ListDB[0].todate);
                        $("[id*=lblAjob]").html(ListDB[0].MJobName);
                        $("[id*=lblsupjob]").html(ListDB[0].MJobName);
                        $("[id*=lblAClient]").html(ListDB[0].ClientName);
                        $("[id*=lblsupclient]").html(ListDB[0].ClientName);
                    }
                },
                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
            //ajax end
        }
        if (s == 'Bill') {
            $find("ListModalPopupBehavior").show();

            $("[id*= divjobstatus]").hide();
            $("[id*=divdates]").hide();
            $("[id*=divbiliable]").show();
            $("[id*=divstatus]").hide();
            $("[id*=divbtndate]").hide();
            $("[id*=dvbtnbill]").show();
            var jobid = $("[id*=hdnjid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            var hdndpt = $("[id*=hdndptwise]").val();
            var data = {
                currobj: {
                    CompId: compid,
                    Jobid: jobid,
                    hdndpt: hdndpt
                }
            };
            //ajax start
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/GetbillDetails",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function (msg) {
                    var ListDB = jQuery.parseJSON(msg.d);
                    if (parseFloat(ListDB.length) > 0) {
                        $("[id*=txtstart]").val(ListDB[0].CreationDate);
                        $("[id*=txtenddate]").val(ListDB[0].todate);
                        $("[id*=lblAjob]").html(ListDB[0].MJobName);
                        $("[id*=lblAClient]").html(ListDB[0].ClientName);
                    }
                },

                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
            //ajax end
        }

        if (s == 'Approver') {
            $find("ListModalPopupBhr").show();
            $("[id*= divsuperapp1]").show();
            $("[id*=divstaff1]").hide();
            $("[id*=dvsavestaff]").hide();
            $("[id*= dvsaveappr]").show();

            var jobid = $("[id*=hdnjid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            var hdndpt = $("[id*=hdndptwise]").val();
            var data = {
                currobj: {
                    CompId: compid,
                    Jobid: jobid,
                    hdndpt: hdndpt
                }
            };
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/GetapprDetails",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function (msg) {
                    var ListDB = jQuery.parseJSON(msg.d);

                    if (parseFloat(ListDB.length) > 0) {
                        $("[id*=drpdwnappr]").empty();

                        $("[id*= hdnSappid]").val(ListDB[0].SuperAppId);
                        $("[id*=lblsupjob]").html(ListDB[0].MJobName);
                        $("[id*=lblsupclient]").html(ListDB[0].ClientName);
                        $("[id*=hdnCltid]").val(ListDB[0].Cltid);

                    }
                },

                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });

            Bind_Approver_ModalPopup(compid, jobid);


            //$("[id*=drpdwnappr]").val($("[id*= hdnSappid]").val());


        }

        //if (s == 'Budget') {
        //    var jobid = $("[id*=hdnjid]").val();
        //    var compid = $("[id*=hdnCompanyid]").val();
        //    var hdndpt = $("[id*=hdndptwise]").val();

        //    //$("[id*=Divbudget]").show();
        //    $("[id*=DivGrd]").hide();
        //    var data = {
        //        currobj: {
        //            CompId: compid,
        //            Jobid: jobid,
        //            hdndpt: hdndpt
        //        }

        //    };
        //    var calala = $.ajax({
        //        type: "POST",
        //        url: "../Handler/wsJobAllocation.asmx/bind_Job_Client_budget",
        //        data: JSON.stringify(data),
        //        dataType: "json",
        //        contentType: "application/json",
        //        success: function (msg) {
        //            var ListDB = jQuery.parseJSON(msg.d);

        //            if (parseFloat(ListDB.length) > 0) {


        //                $("[id*=Label231]").html(ListDB[0].projectName);
        //                $("[id*=Label221]").html(ListDB[0].ClientName);
        //                $("[id*=Label271]").html(ListDB[0].MJobName);
        //                $("[id*=hdnCltid]").val(ListDB[0].Cltid);
        //                var bs = ListDB[0].BudgetSelection
        //                if (bs == 'Staff Budgeting') {
        //                    //////// Staffwise
        //                    $("[id*=ddlBudgetingselection]").val('Staff Budgeting');
        //                    $("[id*=PrjBud]").hide();
        //                    $("[id*=StfBud]").show();
        //                    BudgetingChange();
        //                }
        //                else {

        //                    //////// Projectwise
        //                    $("[id*=ddlBudgetingselection]").val('Project Budgeting');
        //                    $("[id*=PrjBud]").show();
        //                    $("[id*=StfBud]").hide();
        //                    ProjectBudgeting();
        //                    BudgetingChange();
        //                }
        //            }

        //        },

        //        failure: function (response) {
        //            alert('Cant Connect to Server' + response.d);
        //        },
        //        error: function (response) {
        //            alert('Error Occoured ' + response.d);
        //        }
        //    });

        //}


        if (s == 'Staff') {
            $find("ListModalPopupBhr").show();
            $("[id*= divstaff1]").show();
            $("[id*=divsuperapp1]").hide();
            $("[id*=dvsavestaff]").show();
            $("[id*= dvsaveappr]").hide();
            var jobid = $("[id*=hdnjid]").val();
            var compid = $("[id*=hdnCompanyid]").val();
            var hdndpt = $("[id*=hdndptwise]").val();
            var data = {
                currobj: {
                    CompId: compid,
                    Jobid: jobid,
                    hdndpt: hdndpt
                }

            };
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/GetapprDetails",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function (msg) {
                    var ListDB = jQuery.parseJSON(msg.d);

                    if (parseFloat(ListDB.length) > 0) {


                        $("[id*=lblsupjob]").html(ListDB[0].MJobName);
                        $("[id*=lblsupclient]").html(ListDB[0].ClientName);
                        $("[id*=hdnCltid]").val(ListDB[0].Cltid);

                    }
                },

                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });

            Bind_Staff(compid, jobid);
            Bind_Dept(compid, jobid);

        }

    }


    // Creating tabs at runtime for approver, staff, task
    function CreateTabs() {

        var tabsContainer = $('#tabs');
        tabsContainer.empty();
        var l1 = '<li ><a href="#tabs-1">Approver</a></li>';
        var l2 = '<li class="active"><a href="#tabs-2">Staff</a></li>';
        var l3 = '<li><a href="#tabs-3">Task</a></li>';
        if ($("[id*=hdnTaskwise]").val() == "1") {
            var l = l1 + l2 + l3;
        }
        else {
            if ($("[id*=hdndptwise]").val() == "1") { l = l2; }
            else {
                var l = l1 + l2;
            }
        }

        var t1 = '<div id="tabs-1" class="tab active">';
        t1 = t1 + '<div> <div> Super Approver</div>';
        t1 = t1 + '<div class="boexs"><select id="drpdwnapp" class="dropstyleJob"  Width="400px"><option Value="0">--Select one--</option> </select></div>';
        t1 = t1 + '</div>';
        t1 = t1 + '<div><div> Sub Approver </div>';
        t1 = t1 + '<div style="width:400px; overflow-y:scroll; height:200px; border-color:#CCCCCC; border-style:solid; border-width:1px;"><div style="height: 190px; margin-right: 0px;"><div id="Div14">';
        t1 = t1 + '</div><table id="tblApprover"></table></div></div>';
        t1 = t1 + '</div></div>';

        if ($("[id*=hdndptwise]").val() == "1") {
            var t2 = '<div id="tabs-2" class="tab active">'
        }
        else {
            var t2 = '<div id="tabs-2" class="tab">'
        }
        t2 = t2 + '<table><tr><td><div><b>Department</b></div></div>';
        t2 = t2 + '<div style="width:350px; Height:269px; overflow-y:scroll; border-color:#CCCCCC; border-style: solid; border-width: 1px;">';
        t2 = t2 + '<div style="height: 280px; margin-right: 0px;"><div id="Div13"></div>';
        t2 = t2 + '<table id="tblDept"></table></div></asp:Panel></div></td><td><div style="width: 20px"></div></td>';
        //t2 = t2 + '<td><div ><div style="width:720px;"><label id="Label15" class="labelstyle labelChange"><b>Staff</b></label>&nbsp;<input type="checkbox" id="chkall" text="Check All" class="staffchkall" />';

        //t2 = t2 + '<label id="Label15" class="labelstyle labelChange" ><b style="padding-left: 160px;">Working % in a day</b> </label>';
        //t2 = t2 + '<label xgid="Label15" class="labelstyle labelChange" ><b style="padding-left: 20px;padding-right: 40px;">Working Start Dates</b></label>';
        //t2 = t2 + '<label id="Label15" class="labelstyle labelChange" ><b>Working End Dates</b></label></div>';
        //t2 = t2 + '<div style="height: 269px"><div ID="Panel3" style="height:265px; overflow-y:scroll; border-color:#CCCCCC; border-style: solid; border-width: 1px;">';
        //t2 = t2 + '<div style="height: 280px; margin-right: 0px;"><div id="content2"></div>';
        t2 = t2 + '</tr></table>';
        t2 = t2 + '</div>'; //last end

        var t3 = '<div id="tabs-3" class="tab">';
        t3 = t3 + '<div><label id="Label15" class="labelstyle labelChange" text="">Task</label>&nbsp;<input type="checkbox" id="chkalltsk" Text="Check All" CssClass="staffchkall" /></div>';
        t3 = t3 + '<div style="height: 269px"><div ID="Panel2" style="height:265px; width: 400px; overflow-y:scroll; border-color:#CCCCCC; border-style: solid; border-width: 1px;">';
        t3 = t3 + '<div style="height: 280px; margin-right: 0px;"><div id="Div3"><div class="loader2"></div><table id="tblTask"></table></div></div>';
        t3 = t3 + '</div></div>';


        if ($("[id*=hdnTaskwise]").val() == "1") {
            var t = t1 + t2 + t3;
        }
        else {
            if ($("[id*=hdndptwise]").val() == "1") { t = t2; }
            else {
                var t = t1 + t2;
            }
        }

        tabsContainer.append('<ul class="tab-links">' + l + '</ul>')
        tabsContainer.append('<div class="tab-content">' + t + '</div>');
    }

    function Bind_Client(compid, jobid) {
        $.ajax({
            type: "POST",
            url: "../Handler/wsJobAllocation.asmx/bind_Client",
            data: '{compid:' + compid + ',jobid:' + jobid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                $("[id*=drpclient]").empty();
                $("[id*=drpclient]").append("<option value=0>--Select--</option>");
                for (var i = 0; i < myList.length; i++) {

                    $("[id*=drpclient]").append("<option value='" + myList[i].Cltid + "'>" + myList[i].ClientName + "</option>");
                }
                //$('#drpclient').selectize({
                //});
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }

    function Bind_ProjectStartEnd(compid, prjid) {
        $.ajax({
            type: "POST",
            url: "../Handler/wsJobAllocation.asmx/Bind_ProjectStartEnd",
            data: '{compid:' + compid + ',prjid:' + prjid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length > 0) {
                    $("[id*=txtstartdate]").val(myList[0].Strtdt);
                    $("[id*=txtactualdate]").val(myList[0].Endt);
                } else {
                    $("[id*=txtstartdate]").val('');
                    $("[id*=txtactualdate]").val('');
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

    function Bind_Project(compid, cid, jobid, pid) {
        $.ajax({
            type: "POST",
            url: "../Handler/wsJobAllocation.asmx/bind_Project",
            data: '{compid:' + compid + ',cid:' + cid + ', jobid:' + jobid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                $("[id*=drpproject]").empty();
                $("[id*=drpproject]").append("<option value=0>--Select--</option>");
                for (var i = 0; i < myList.length; i++) {

                    $("[id*=drpproject]").append("<option value='" + myList[i].projectid + "'>" + myList[i].projectName + "</option>");
                }
                if (parseFloat(pid) > 0) {
                    $("[id*=drpproject]").val(pid);
                }
                if (parseFloat(jobid) > 0) {
                    document.getElementById("drpproject").disabled = true;
                }
                else {
                    document.getElementById("drpproject").disabled = false;
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

    function Bind_JobName(compid, jobid, pid, lnk) {
        $.ajax({
            type: "POST",
            url: "../Handler/wsJobAllocation.asmx/bind_Jobname",
            data: '{compid:' + compid + ',jobid:' + jobid + ', pid:' + pid + ', lnk:' + lnk + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var mjid = 0;
                var myList = jQuery.parseJSON(msg.d);
                $("[id*=drpjob]").empty();
                $("[id*=drpjob]").append("<option value=0>--Select--</option>");
                for (var i = 0; i < myList.length; i++) {
                    $("[id*=drpjob]").append("<option value='" + myList[i].mJobID + "'>" + myList[i].MJobName + "</option>");
                    if (parseFloat(myList[i].ischecked) > 0) {
                        mjid = myList[i].ischecked;
                    }
                }
                if (parseFloat(mjid) > 0) {
                    $("[id*=drpjob]").val(mjid);
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

    function Bind_Assignments(compid, jobid) {
        $.ajax({
            type: "POST",
            url: "../Handler/wsJobAllocation.asmx/bind_Assigment",
            data: '{compid:' + compid + ',jobid:' + jobid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                var tr;
                var vadfds = "";
                $("[id*=tblAssign] tbody").remove();

                for (var i = 0; i < myList.length; i++) {
                    vadfds = "";
                    if (parseFloat(myList[i].ischecked) > 0) {
                        vadfds = 'checked';
                    }

                    if (parseFloat(myList[i].Assign_Id) > 0) {
                        tr = $('<tr><td><input type="hidden" name="hdnAdpid" value="' + myList[i].DeptId + '"> <input type="hidden" name="hdnadid" value="' + myList[i].Assign_Id + '" /> <input type="checkbox" id="chkAdpt" name="chkAdpt" value="' + myList[i].Assign_Id + '"' + vadfds + ' />' + myList[i].Assign_Name + '</td></tr>');
                    } else {
                        tr = $('<tr><td style="font-weight: bold;"> ' + myList[i].Assign_Name + '</td></tr>');
                    }
                    $('#tblAssign').append(tr);
                }

                $("input[name=chkAdpt]:checked").each(function () {
                    var chkprop = $(this).is(':checked');
                    if (chkprop) {
                        var sftrow = $(this).closest("tr");
                        var currentobj = sftrow.find("input[name=hdnAdpid]").val();
                        Chk_Dept(currentobj, chkprop);
                    }
                });
                Bind_Staff_Vals(compid, jobid);
                CountAssign();
            },
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }

    function Bind_Approver_ModalPopup(compid, jobid) {
        $.ajax({
            type: "POST",
            url: "../Handler/wsJobAllocation.asmx/bind_Approver",
            data: '{compid:' + compid + ',jobid:' + jobid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                $("[id*=tblassignment] tbody").remove();

                $("[id*=drpdwnappr]").empty();

                $("[id*=drpdwnappr]").append("<option value=0>--Select--</option>");
                for (var i = 0; i < myList.length; i++) {

                    vadfds = "";
                    if (parseFloat(myList[i].ischecked) > 0) {
                        vadfds = 'checked';
                    }

                    tr = $('<tr><td> <input type="hidden" name="hdnapprid" value="' + myList[i].StaffCode + '"> <input type="checkbox" id="chkApp1" name="chkApp1" value="' + myList[i].StaffCode + '"' + vadfds + ' />' + myList[i].StaffName + '</td></tr>');
                    $('#tblassignment').append(tr);


                    // inserting into dropdown
                    $("[id*=drpdwnappr]").append("<option value='" + myList[i].StaffCode + "'>" + myList[i].StaffName + "</option>");
                    // $("[id*=drpdwnappr]").append("<option value='" + myList[i].StaffCode + "'>" + myList[i].StaffName + "</option>");
                }
                if ($("[id*=hdnSappid]").val() != "") {
                    $("[id*=drpdwnappr]").val($("[id*=hdnSappid]").val());

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


    function Bind_Approver(compid, jobid, sp) {
        $.ajax({
            type: "POST",
            url: "../Handler/wsJobAllocation.asmx/bind_Approver",
            data: '{compid:' + compid + ',jobid:' + jobid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                $("[id*=tblApprover] tbody").remove();

                $("[id*=drpdwnapp]").empty();

                $("[id*=drpdwnapp]").append("<option value=0>--Select--</option>");
                for (var i = 0; i < myList.length; i++) {

                    vadfds = "";
                    if (parseFloat(myList[i].ischecked) > 0) {
                        vadfds = 'checked';
                    }

                    tr = $('<tr><td> <input type="hidden" name="hdnapprid" value="' + myList[i].StaffCode + '"> <input type="checkbox" id="chkApp" name="chkApp" value="' + myList[i].StaffCode + '"' + vadfds + ' />' + myList[i].StaffName + '</td></tr>');
                    $('#tblApprover').append(tr);


                    // inserting into dropdown
                    $("[id*=drpdwnapp]").append("<option value='" + myList[i].StaffCode + "'>" + myList[i].StaffName + "</option>");
                    // $("[id*=drpdwnappr]").append("<option value='" + myList[i].StaffCode + "'>" + myList[i].StaffName + "</option>");
                }
                if ($("[id*=hdnSappid]").val() != "") {
                    $("[id*=drpdwnapp]").val($("[id*=hdnSappid]").val());

                }
                if (parseFloat(sp) > 0) {
                    $("[id*=drpdwnapp]").val(sp);
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

    function Bind_Staff(compid, jobid) {
        try {
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/bind_Staff",
                data: '{compid:' + compid + ',jobid:' + jobid + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tr;
                    var vadfds = "";
                    $("[id*=tblstaff] tbody").remove();
                    $("[id*=tblSft] tbody").remove();

                    for (var i = 0; i < myList.length; i++) {
                        vadfds = "";
                        if (parseFloat(myList[i].ischecked) > 0) {
                            vadfds = 'checked';
                        }


                        if ($("[id*=hdndptwise]").val() == "1") {
                            tr = '<tr><td style="width:250px;"><input type="hidden" name="hdnsdpid" value="' + myList[i].DeptId + '"> <input type="hidden"  name="hdnsid" value="' + myList[i].StaffCode + '"> <input type="hidden"  name="hdnhod" value="' + myList[i].IsApprover + '"> <input type="checkbox" id="chkstf" name="chkstf" value="' + myList[i].StaffCode + '"' + vadfds + '  />' + myList[i].StaffName + '</td>';
                            tr = tr + '<td> </td><td style="width:100px;text-align: center;"><input type="text" id="txtwrk" style="width:50px;" name="txtwrk"  onchange="ShowChange($(this))" value="0"></td>';
                            tr = tr + '<td> </td><td style="width:150px; padding-left: 20px;"><input type="Date"  id="dtfrdate_" name="dtfrdate_" value="' + myList[i].Fromdate + '" ></td>';
                            tr = tr + '<td> </td><td style="width:150px; padding-left: 20px;"><input type="Date"  id="dttodate_" name="dttodate_" value="' + myList[i].Todate + '" ></td></tr>';
                            ts = $('<tr><td><input type="hidden" name="hdnsdpid" value="' + myList[i].DeptId + '"> <input type="hidden"  name="hdnsid" value="' + myList[i].StaffCode + '"> <input type="checkbox" id="chkstf1" name="chkstf1" value="' + myList[i].StaffCode + '"' + vadfds + ' />' + myList[i].StaffName + '</td></tr>');
                        }
                        else {
                            tr = $('<tr><td style="width:250px;"><input type="hidden" name="hdnsdpid" value="' + myList[i].DeptId + '"> <input type="hidden"  name="hdnsid" value="' + myList[i].StaffCode + '"> <input type="hidden"  name="hdnhod" value="' + myList[i].IsApprover + '"> <input type="checkbox" id="chkstf" name="chkstf" value="' + myList[i].StaffCode + '"' + vadfds + ' />' + myList[i].StaffName + '</td></tr>');
                            ts = $('<tr><td><input type="hidden" name="hdnsdpid" value="' + myList[i].DeptId + '"> <input type="hidden"  name="hdnsid" value="' + myList[i].StaffCode + '"> <input type="checkbox" id="chkstf1" name="chkstf1" value="' + myList[i].StaffCode + '"' + vadfds + ' />' + myList[i].StaffName + '</td></tr>');
                        }
                        $('#tblstaff').append(ts);
                        $('#tblSft').append(tr);
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

    function Bind_Staff_Vals(compid, jobid) {
        try {
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/bind_Staff_Vals",
                data: '{compid:' + compid + ',jobid:' + jobid + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tr;
                    var selChk = "";

                    $("[id*=tblSft] tbody").remove();

                    for (var i = 0; i < myList.length; i++) {
                        selChk = "";

                        if (jobid > 0) {
                            if (parseFloat(myList[i].ischecked) > 0) {
                                selChk = 'checked';
                            }
                        }

                        tr = '<tr><td  style="width:250px;"><input type="hidden" name="hdnsdpid" value="' + myList[i].DeptId + '"> <input type="hidden"  name="hdnsid" value="' + myList[i].StaffCode + '"> <input type="hidden"  name="hdnhod" value="' + myList[i].IsApprover + '"> <input type="checkbox" id="chkstf" name="chkstf" value="' + myList[i].StaffCode + '"' + selChk + '  />' + myList[i].StaffName + '</td>';
                        if (selChk == 'checked') {
                            tr = tr + '<td></td><td style="width:100px;text-align: center;"><input type="text" id="txtwrk" style="width:50px;" name="txtwrk" onchange="ShowChange($(this))" value="' + myList[i].PerHrs + '"></td>';
                            tr = tr + '<td style="width:150px; padding-left: 20px;"><input type="Date" style="width: 125px;" id="dtfrdate_" name="dtfrdate_" value="' + myList[i].Fromdate + '" onblur="FromdateValidation($(this))"></td>';
                            tr = tr + '<td style="width:150px; padding-left: 20px;"><input type="Date" style="width: 125px;" id="dttodate_" name="dttodate_" value="' + myList[i].Todate + '"  ></td></tr>';
                        }
                        else {
                            tr = tr + '<td></td><td style="width:100px;text-align: center;"><input type="text" id="txtwrk" style="width:50px;" name="txtwrk"  onchange="ShowChange($(this))" value="0"></td>';
                            tr = tr + '<td style="width:150px; padding-left: 20px;"><input type="Date" style="width: 125px;" id="dtfrdate_" name="dtfrdate_" onblur="FromdateValidation($(this))" ></td>';
                            tr = tr + '<td style="width:150px; padding-left: 20px;"><input type="Date" style="width: 125px;" id="dttodate_" name="dttodate_"  ></td></tr>';
                        }

                        $('#tblSft').append(tr);
                        CountStaff();
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

    function FromdateValidation(i) {
        var row = i.closest("tr")
        var rIndex = i.closest("tr")[0].sectionRowIndex;
        var V = i.val();
        // var dt = push.moment(V).format('MM/DD/YYYY');
        var projstart = $("[id*=txtstartdate]").val();

        if (projstart > V) {
            var a = '';
        }


    }

    function Bind_Dept(compid, jobid) {
        try {
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/bind_StaffDepartment",
                data: '{compid:' + compid + ',jobid:' + jobid + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tr;
                    var vadfds = "";
                    $("[id*=tblDept] tbody").remove();
                    $("[id*=tbldepartment] tbody").remove();
                    for (var i = 0; i < myList.length; i++) {
                        vadfds = "";
                        if (parseFloat(myList[i].ischecked) > 0) {
                            vadfds = 'checked';
                        }
                        if ($("[id*=hdndptwise]").val() == "1") {
                            tr = $('<tr><td> <input type="hidden" name="hdndpid" value="' + myList[i].DeptId + '"> <input type="checkbox" id="chkdp" name="chkdp" value="' + myList[i].DeptId + '"' + vadfds + 'disabled />' + myList[i].DepartmentName + '</td></tr>');
                            tm = $('<tr><td> <input type="hidden" name="hdndpid" value="' + myList[i].DeptId + '"> <input type="checkbox" id="chkdp1" name="chkdp" value="' + myList[i].DeptId + '"' + vadfds + 'disabled />' + myList[i].DepartmentName + '</td></tr>');
                        } else {
                            tr = $('<tr><td> <input type="hidden" name="hdndpid" value="' + myList[i].DeptId + '"> <input type="checkbox" id="chkdp" name="chkdp" value="' + myList[i].DeptId + '"' + vadfds + ' />' + myList[i].DepartmentName + '</td></tr>');
                            tm = $('<tr><td> <input type="hidden" name="hdndpid" value="' + myList[i].DeptId + '"> <input type="checkbox" id="chkdp1" name="chkdp" value="' + myList[i].DeptId + '"' + vadfds + ' />' + myList[i].DepartmentName + '</td></tr>');
                        }
                        $('#tblDept').append(tr);
                        $('#tbldepartment').append(tm);

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


    function Bind_Task(compid, jobid, mjid, lnk) {
        try {
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/bind_Task",
                data: '{compid:' + compid + ',jobid:' + jobid + ',mjid:' + mjid + ', lnk:' + lnk + '}',
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tr;
                    var vadfds = "";
                    $("[id*=tblTask] tbody").remove();
                    for (var i = 0; i < myList.length; i++) {
                        vadfds = "";
                        if (parseFloat(myList[i].ischecked) > 0) {
                            vadfds = 'checked';
                        }
                        tr = $('<tr><td> <input type="hidden" name="hdntid" value="' + myList[i].Task_Id + '"> <input type="checkbox" id="chktsk" name="chktsk" value="' + myList[i].Task_Id + '"' + vadfds + ' />' + myList[i].Task_name + '</td></tr>');
                        $('#tblTask').append(tr);

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

    function ShowEdit(i) {
        var t = i.position();
        openmenu(t.top, t.left);

        var row = i.closest("tr");
        var jobid = row.find("input[name=hdnjobid]").val();
        var stf = row.find("input[name=hdnstfTot]").val();
        $("[id*=hdnCntStf]").val(stf);
        $("[id*=hdnjid]").val(jobid);

    }


    function ShowDelete(i) {
        try {
            var newDate = new Date();
            var row = i.closest("tr");
            var jobid = row.find("input[name=hdnjobid]").val();
            $("[id*=hdnjid]").val(jobid);
            var compid = $("[id*=hdnCompanyid]").val();
            var hdndpt = $("[id*=hdndptwise]").val();
            var ip = $("[id*= hdnIP]").val();
            var usr = $("[id*= hdnName]").val();
            var uT = $("[id*= hdnUser]").val();
            var data = {
                currobj: {
                    CompId: compid,
                    Jobid: jobid,
                    IP: ip,
                    User: usr,
                    UType: uT,
                    dt: newDate
                }
            };
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/Delete_Job",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList.length > 0) {
                        var Jobid = myList[0].Jobid;
                        if (parseFloat(Jobid) == 0) {
                            alert(myList[0].messg);
                        }
                        else {
                            alert('Job Delete Successfully');
                            ClearData();
                            Bind_Jobs(1, 25);
                        }
                        $("[id*=DivGrd]").show();
                        $("[id*=divAddEdit]").hide();
                        $("[id*=editsavedv]").hide();
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
    function confirmSave(compid, jobid, cid, pid, sappid, fr, to, bill, sts, hdndpt, hdnAllAdpt, jid, hndtsk, hdnAlltsk, hdnAllstf, hdnAllapp) {
        try {
            if (jid == undefined) {
                jid = '0';
            }

            var data = {
                currobj: {
                    CompId: compid,
                    Jobid: jobid,
                    Cltid: cid,
                    projectid: pid,
                    SuperAppId: sappid,
                    fromdate: fr,
                    todate: to,
                    Billable: bill,
                    jStatus: sts,

                    hdndpt: hdndpt,
                    hdnAllAdpt: hdnAllAdpt,
                    mJobID: jid,
                    hndtsk: hndtsk,
                    hdnAlltsk: hdnAlltsk,
                    hdnAllstf: hdnAllstf,
                    hdnAllapp: hdnAllapp

                }
            };
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobAllocation.asmx/Save_Job",
                data: JSON.stringify(data),
                dataType: "json",
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList.length > 0) {
                        alert('Job Saved Successfully');
                        ClearData();
                        $("[id*=DivGrd]").show();
                        $("[id*=divAddEdit]").hide();
                        $("[id*=editsavedv]").hide();
                        Bind_Jobs(1, 25);
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
            //            alert(e.get_Description());
        }

    }
    ///////////////////////////////////////////////////////Budgeting //////////////////////////////////////////////

    //function ProjectBudgeting() {

    //    var jobid = $("[id*=hdnjid]").val();
    //    var compid = $("[id*=hdnCompanyid]").val();
    //    var hdndpt = $("[id*=hdndptwise]").val();

    //    var data = {
    //        currobj: {
    //            CompId: compid,
    //            Jobid: jobid,
    //            hdndpt: hdndpt
    //        }

    //    };
    //    var calala = $.ajax({
    //        type: "POST",
    //        url: "../Handler/wsJobAllocation.asmx/bind_Project_budgeting",
    //        data: JSON.stringify(data),
    //        dataType: "json",
    //        contentType: "application/json",
    //        success: function (msg) {
    //            var ListDB = jQuery.parseJSON(msg.d);

    //            if (parseFloat(ListDB.length) > 0) {

    //                $("[id*=txtBudAmt]").val(ListDB[0].BudgetAmount);
    //                $("[id*=txtbudhours]").val(ListDB[0].Budgethours);
    //                $("[id*=txtbudamtOth]").val(ListDB[0].BudgetOthAmount);

    //            }
    //            else {
    //                $("[id*=txtBudAmt]").val(0);
    //                $("[id*=txtbudhours]").val(0);
    //                $("[id*=txtbudamtOth]").val(0);

    //            }

    //        },

    //        failure: function (response) {
    //            alert('Cant Connect to Server' + response.d);
    //        },
    //        error: function (response) {
    //            alert('Error Occoured ' + response.d);
    //        }
    //    });

    //}


    //function StaffBudgeting(i) {

    //    var jobid = $("[id*=hdnjid]").val();
    //    var compid = $("[id*=hdnCompanyid]").val();
    //    var hdndpt = $("[id*=hdndptwise]").val();
    //    $('.loader2').show();
    //    var data = {
    //        currobj: {
    //            CompId: compid,
    //            Jobid: jobid,
    //            hdndpt: hdndpt,
    //            pageIndex: i,
    //            pageNewSize: 100
    //        }

    //    };
    //    $.ajax({
    //        type: "POST",
    //        url: "../Handler/wsJobAllocation.asmx/bindStaff_Budgeting",
    //        data: JSON.stringify(data),
    //        dataType: 'json',
    //        contentType: "application/json; charsetdidil=utf-8",
    //        success: function (msg) {

    //            var myList = jQuery.parseJSON(msg.d);
    //            var tr;
    //            var vadfds = "";

    //            /////////staff budgeting
    //            var trStaff = $("[id*=tblStaffbudget] tbody tr:last-child").clone(true);
    //            $("[id*=tblStaffbudget] tbody").remove();
    //            var checked = "";
    //            var rowno = 0;
    //            for (var i = 0; i < myList.length; i++) {
    //                checked = "";
    //                if (myList[i].ischecked == "0")
    //                { checked = "checked"; }
    //                else {
    //                    checked = "";
    //                }
    //                //                    tr = ("<tr ><td>" + "<input type='checkbox' name='chkSftname' value='" + myList[i].StaffCode + "' " + checked + "><input type='hidden' name='hdndepid' value='" + myList[i].DeptId + "'>" + myList[i].StaffName + "</td></tr>");
    //                rowno = (parseFloat(rowno) + 1);
    //                trStaff.css('display', '');
    //                $("td", trStaff).eq(0).html(rowno);

    //                $("td", trStaff).eq(1).html(myList[i].StaffName + "<input type='hidden' id='hdnStaffCode' name='hdnStaffCode' value='" + myList[i].StaffCode + "'> <input type='checkbox' style='display:none;' name='chkStaffBudgetCheckEmp' value='" + myList[i].StaffCode + "' " + checked + ">"); ///staff name
    //                $("td", trStaff).eq(2).html(myList[i].DepartmentName); ///////////department
    //                $("td", trStaff).eq(3).html(myList[i].JobGroupName); ////////Designation
    //                if (myList[i].ischecked == "1") {
    //                    $("td", trStaff).eq(4).html(myList[i].BudgetAmount); ///////////Budget amount
    //                    $("td", trStaff).eq(5).html(myList[i].Budgethours); ////////hourly hours

    //                    $("td", trStaff).eq(6).html(myList[i].AllocatedHours); ////////Budget hours
    //                    $("td", trStaff).eq(7).html(myList[i].StaffHourlyRate); ///////////hourly amount
    //                    $("td", trStaff).eq(8).html("<img src='../images/edit.png' style='cursor:pointer; height:18px; width:18px;' id='btnEditsingleStaffBudget' name='btnEditsingleStaffBudget'>");
    //                }
    //                else {
    //                    $("td", trStaff).eq(4).html("<input type='textbox' class='txtbox calbox' name='txtHours' style='width:50px;text-align: right;' value='0' >"); ///////////Budget hours
    //                    $("td", trStaff).eq(5).html("<input type='textbox' class='txtbox calbox' name='txtStaffbudget' style='width:50px;text-align: right;' value='0'>"); ////////hourly amount
    //                    $("td", trStaff).eq(6).html("<input type='textbox' class='txtbox calbox' name='txtAllocatedHrs' style='width:50px;text-align: right;' value='0'>"); ////////Budget hours
    //                    $("td", trStaff).eq(7).html("<input type='textbox' class='txtbox calbox' name='txtStaffActualHrs' style='width:50px;text-align: right;' value='" + myList[i].StaffHourlyRate + "' >"); ///////////hourly amount
    //                    $("td", trStaff).eq(8).html();
    //                }



    //                $("[id*=tblStaffbudget]").append(trStaff);
    //                trStaff = $("[id*=tblStaffbudget] tbody tr:last-child").clone(true);
    //            }


    //            //                    twocheck = twocheck + 1;
    //            //                    
    //            //                    if (twocheck == onecheck) {
    //            $('.loader2').hide();
    //            //                    }
    //        },
    //        failure: function (response) {
    //            alert('Cant Connect to Server' + response.d);
    //        },
    //        error: function (response) {
    //            alert('Error Occoured ' + response.d);
    //        }
    //    });

    //}


    ////////////////bind girdview inside popup
    function AjaxBindGridDataUsing() {
        var staffcode = $("[id*=hdnEditClickStaffcode]").val();
        if (staffcode != "") {
            var data = {
                currobj: {
                    StaffCode: staffcode,
                    Jobid: $("[id*=hdnjid]").val(),
                    CompId: $("[id*=hdnCompanyid]").val()
                }
            };
            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/wsJobAllocation.asmx/BindGridTable",
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

    //////////////////ajax success functions
    function OnSuccess(response) {
        clearform();
        var myList = jQuery.parseJSON(response.d);
        var rowno = 0;
        var trStaff = $("[id*=gvCustomers] tbody tr:last-child").clone(true);
        $("[id*=gvCustomers] tbody").remove();
        if (myList.length > 0) {
            $("[id*=hdnjstrt]").val(myList[0].startDT);
            for (var i = 0; i < myList.length; i++) {

                if (myList[i].temp_Id == 0) {
                    $("[id*=txtStaffActualRateForJob]").val(myList[i].StaffActualHourRate);
                }
                else {
                    rowno = (parseFloat(rowno) + 1);
                    trStaff.css('display', '');
                    $("td", trStaff).eq(0).html(rowno);
                    $("td", trStaff).eq(1).html(myList[i].fromdate);
                    $("td", trStaff).eq(2).html(myList[i].todate);
                    $("td", trStaff).eq(3).html(myList[i].BudgetAmount);
                    $("td", trStaff).eq(4).html(myList[i].Budgethours);
                    //                    $("td", trStaff).eq(5).html(myList[i].PlanedDrawing);
                    //                    $("td", trStaff).eq(6).html(myList[i].CompletedDrawing);
                    $("td", trStaff).eq(5).html(myList[i].AllocatedHours);
                    $("td", trStaff).eq(6).html(myList[i].StaffActualHourRate);
                    $("td", trStaff).eq(7).html("<img src='../images/edit.png' style='cursor:pointer;' onclick=updatedata(" + myList[i].temp_Id + ") >");

                    $("[id*=gvCustomers]").append(trStaff);
                    trStaff = $("[id*=gvCustomers] tbody tr:last-child").clone(true);
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

    ////    //////////////////ajax success functions
    ////    function OnSuccess(response) {
    ////        clearform();
    ////        $("[id*=gvCustomers").empty();
    ////        $("[id*=gvCustomers]").append("<tr class='mytable'><th>Sr No.</th><th>From Date</th><th>To Date</th><th>Hourly Amount</th><th>Budget Hours</th><th>Planned Drawings</th><th>Completed Drawings</th><th>Allocated Hours</th><th>Staff Actual Hour Rate</th><th></th></tr>");
    ////        var myList = jQuery.parseJSON(response.d);
    ////        if (myList.length > 0) {
    ////            for (var i = 0; i < myList.length; i++) {
    ////                if (myList[i].temp_Id == 0) {
    ////                    $("[id*=txtStaffActualRateForJob]").val(myList[i].StaffActualHourRate);
    ////                }
    ////                else {
    ////                    $("[id*=gvCustomers]").append("<tr class='mytable'><td>" +
    ////                            (i + 1) + "</td><td width='80px'>" + //sr no
    ////                            myList[i].fromdate + "</td> <td width='80px'>" + //FromDate
    ////                            myList[i].todate + "</td> <td>" + //Todate
    ////                            myList[i].BudgetAmt + "</td> <td>" + //Budget Amount
    ////                            myList[i].Budgethours + "</td><td>" +
    ////                            myList[i].PlanedDrawing + "</td> <td>" +
    ////                            myList[i].CompletedDrawing + "</td> <td>" +
    ////                            myList[i].AllocatedHours + "</td> <td>" +
    ////                            myList[i].StaffActualHourRate + "</td>" +
    ////                            "<td><img src='../images/edit.png' style='cursor:pointer;' onclick=updatedata(" + myList[i].temp_Id + ") ></td></tr>");

    ////                    //Set Updated Amount & hours
    ////                    if (myList[i].todate == '') {
    ////                        $("input[name=chkStaffBudgetCheckEmp]:checked").each(function () {
    ////                            var row = $(this).closest("tr");
    ////                            var staffcode = $(this).val();
    ////                            if (staffcode == $("[id*=hdnEditClickStaffcode]").val()) {
    ////                                $("td", row).eq(4).html(myList[i].BudgetAmt);
    ////                                $("td", row).eq(5).html(myList[i].Budgethours);
    ////                                $("td", row).eq(6).html(myList[i].PlanedDrawing);
    ////                                $("td", row).eq(7).html(myList[i].AllocatedHours);
    ////                                $("td", row).eq(8).html(myList[i].StaffActualHourRate);
    ////                            }
    ////                        });
    ////                    }
    ////                }
    ////            }
    ////        }
    ////        else {
    ////            $("[id*=gvCustomers]").append("<tr><td style='height:20px; border:1px solid #BCBCBC;' colspan='12'>No Records Found !</td></tr>");
    ////        }
    ////        if (response.d.length == 1)
    ////            $("[id*=gvCustomers]").append("<tr><td style='height:20px; border:1px solid #BCBCBC;' colspan='12'>No Records Found !</td></tr>");
    ////        $('.loader').fadeOut(550);
    ////    }


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
            url: "Manage_Joballocation.aspx/GetTempIDDetails",
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
                currobj: {
                    StaffCode: staffcode,
                    BudgetAmount: $("[id*=txteditHourlyAmount]").val(),
                    Budgethours: $("[id*=txteditBudgetHours]").val(),
                    temp_Id: $("[id*=hdnClickonEditforbudgetTempID]").val(),
                    fromdate: $("[id*=txteditStaffBudgetedDate]").val(),
                    //                    PlanedDrawing: $("[id*=txtPlaneedDrawings]").val(),
                    AllocatedHours: $("[id*=txtAllocatedHrs]").val(),
                    StaffActualHourRate: $("[id*=txtStaffActualRateForJob]").val(),
                    Jobid: $("[id*=hdnjid]").val(),
                    CompId: $("[id*=hdnCompanyid]").val()
                }
            };

            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/wsJobAllocation.asmx/SaveOrUpdateBudget",
                data: JSON.stringify(data),
                dataType: "json",
                success: function (res) {
                    if (res.d.length > 0) {
                        if (res.d[0].Stf == 'Error') {
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

    //////////////////////Budgeting Edit
    //function GetJobWiseBudgetDetails() {
    //    //Ajax start
    //    var jobid = $("[id*=hdnjid]").val();
    //    var compid = $("[id*=hdnCompanyid]").val();
    //    var hdndpt = $("[id*=hdndptwise]").val();

    //    var data = {
    //        currobj: {
    //            CompId: compid,
    //            Jobid: jobid,
    //            hdndpt: hdndpt
    //        }

    //    };
    //    $.ajax({
    //        type: "POST",
    //        contentType: "application/json; charset=utf-8",
    //        url: "../Handler/wsJobAllocation.asmx/GetServerJobWiseBudgetDetails",
    //        data: JSON.stringify(data),
    //        dataType: "json",


    //        success: function (msg) {
    //            var myList = jQuery.parseJSON(msg.d);
    //            clareformEditStaffbudget();
    //            var tr;
    //            var vadfds = "";
    //            $("[id*=Gridtimesheetdetails] tbody").remove();
    //            $("[id*=Gridtimesheetdetails]").append("<tr class='mytable'><th>Sr No.</th><th>From Date</th><th>To Date</th><th>Budgeted Amount</th><th>Budgeted Hours</th><th>Other Budgeted Amount</th><th></th></tr>");
    //            if (myList.length > 0) {
    //                for (var i = 0; i < myList.length; i++) {
    //                    tr = '<tr  class="mytable" ><td>';
    //                    tr = tr + (i + 1) + "</td><td width='80px'>";
    //                    tr = tr + myList[i].fromdate + "</td> <td width='80px'>";
    //                    tr = tr + myList[i].todate + "</td> <td width='80px'>";
    //                    tr = tr + myList[i].BudgetAmount + "</td> <td width='80px'>";
    //                    tr = tr + myList[i].Budgethours + "</td> <td width='80px'>";
    //                    tr = tr + myList[i].Stf + "</td>";
    //                    tr = tr + "<td><img src='../images/edit.png' style='cursor:pointer;' onclick=updatedata2(" + myList[i].temp_Id + ") ></td></tr>";

    //                    $('#Gridtimesheetdetails').append(tr);

    //                    if (myList[i].todate == '') {
    //                        $("[id*=txtbudhours]").val(myList[i].Budgethours);
    //                        $("[id*=txtBudAmt]").val(myList[i].BudgetAmount);
    //                        $("[id*=txtbudamtOth]").val(myList[i].StaffCode);
    //                    }
    //                }
    //            }
    //            else {
    //                $("[id*=Gridtimesheetdetails]").append("<tr><td style='height:20px; border:1px solid #BCBCBC;' colspan='15'>No Records Found !</td></tr>");
    //            }

    //        },
    //        failure: function (response) {

    //        },
    //        error: function (response) {

    //        }
    //    });
    //    //Ajax end
    //}
    function OnSuccess2(response) {

        var myList = jQuery.parseJSON(response.d);
        clareformEditStaffbudget();
        var tr;
        var vadfds = "";
        $("[id*=Gridtimesheetdetails]").append("<tr class='mytable'><th>Sr No.</th><th>From Date</th><th>To Date</th><th>Budgeted Amount</th><th>Budgeted Hours</th><th>Other Budgeted Amount</th><th></th></tr>");
        if (myList.length > 0) {
            for (var i = 0; i < myList.length; i++) {
                tr = '<tr  class="mytable" ><td>';
                tr = tr + (i + 1) + "</td><td width='80px'>";
                tr = tr + myList[i].fromdate + "</td> <td width='80px'>";
                tr = tr + myList[i].todate + "</td> <td width='80px'>";
                tr = tr + myList[i].BudgetAmount + "</td> <td width='80px'>";
                tr = tr + myList[i].Budgethours + "</td> <td width='80px'>";
                tr = tr + myList[i].Stf + "</td>";
                tr = tr + "<td><img src='../images/edit.png' style='cursor:pointer;' onclick=updatedata2(" + myList[i].temp_Id + ") ></td></tr>";

                $('#Gridtimesheetdetails').append(tr);

                if (myList[i].todate == '') {
                    $("[id*=txtbudhours]").val(myList[i].Budgethours);
                    $("[id*=txtBudAmt]").val(myList[i].BudgetAmount);
                    $("[id*=txtbudamtOth]").val(myList[i].StaffCode);
                }
            }
        }
        else {
            $("[id*=Gridtimesheetdetails]").append("<tr><td style='height:20px; border:1px solid #BCBCBC;' colspan='15'>No Records Found !</td></tr>");
        }
        $('.loader2').fadeOut(550);
    }

    function SetJobWiseBudgetDetails() {
        var jobid = $("[id*=hdnjid]").val();
        var compid = $("[id*=hdnCompanyid]").val();
        var hdndpt = $("[id*=hdndptwise]").val();
        var data = {
            currobj: {
                StaffCode: $("[id*=txtOBA]").val(),
                BudgetAmount: $("[id*=txtBamt]").val(),
                Budgethours: $("[id*=txtBHours]").val(),
                temp_Id: $("[id*=hdnJobwiseBudgetingtemp]").val(),
                fromdate: $("[id*=txtfromdate]").val(),
                Jobid: jobid,
                CompId: compid
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/wsJobAllocation.asmx/SetServerJobWiseBudgetDetails",
            data: JSON.stringify(data),
            dataType: "json",
            success: function (res) {
                if (res.d.length > 0) {
                    if (res.d[0].Stf == 'Error') {
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
            url: "Manage_Joballocation.aspx/GetServerEditOnJobWiseTempId",
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
        $("input[name=chkSftname]:checked").each(function () {
            staffcode = staffcode + "," + $(this).val();
        });

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


    //function BudgetingChange() {
    //    var bud = $("[id*=ddlBudgetingselection]").val();
    //    var j=1;
    //    var ij = 1;
    //    ij= parseFloat($("[id*=hdnCntStf]").val());
    //    ij = Math.ceil(ij /100);
    //    if (bud == 'Project Budgeting') {
    //        $("[id*=PrjBud]").show();
    //        $("[id*=StfBud]").hide();
    //        bug_for_clickon_project_budgeting = 0;
    //        ProjectBudgeting();
    //    }
    //    else if (bud == 'Staff Budgeting') {
    //        $("[id*=PrjBud]").hide();
    //        $("[id*=StfBud]").show();
    //        if (ij > 1) {
    //            for (i = 1; i < ij; i++) {
    //                j = ij[i];
    //                StaffBudgeting(j);
    //            }
    //        }
    //        else {
    //            StaffBudgeting(ij);
    //        }
    //    }
    //}

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

    //function clareformEditStaffbudget() {
    //    $("[id*=Gridtimesheetdetails]").empty();
    //    $("[id*=txtBamt]").val('0');
    //    $("[id*=txtBHours]").val('0');
    //    $("[id*=txtOBA]").val('0');
    //    $("[id*=txtfromdate]").val('');
    //    $("[id*=txtbudshowindate]").val('');
    //    $("[id*=txtfromdate]").show();
    //    $("[id*=txtbudshowindate]").hide();
    //    $("[id*=hdnJobwiseBudgetingtemp]").val('0');

    //}

    function ClearData() {
        $("[id*=drpclient]").val(0);
        $("[id*=drpproject]").empty();
        $("[id*=drpjob]").val(0);
        $("[id*=drp_jobstatus]").val('OnGoing');
        $("[id*=drpdwnapp]").val(0);


        $("[id*=txtstartdate]").val('');
        $("[id*=txtactualdate]").val('');
        $("[id*=hdnSappid]").val('');

        $("input[type=checkbox]:checked").each(function () {
            $(this).removeAttr('checked');
        });
    }

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

    function MakeSmartSearch() {
        $("select").searchable({
            maxListSize: 200, // if list size are less than maxListSize, show them all
            maxMultiMatch: 300, // how many matching entries should be displayed
            exactMatch: false, // Exact matching on search
            wildcards: true, // Support for wildcard characters (*, ?)
            ignoreCase: true, // Ignore case sensitivity
            latency: 200, // how many millis to wait until starting search
            warnMultiMatch: 'top {0} matches ...',
            warnNoMatch: 'no matches ...',
            zIndex: 'auto'
        });
    }

</script>
<style type="text/css">
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

    .auto-style1 {
        width: 88%;
        float: left;
        height: 20px;
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

    .DropDown {
        min-height: 25px;
        max-height: 25px !important;
    }
</style>
<div id="divtotbody" class="testwhleinside">
    <div id="divtitl" class="totbodycatreg">
        <table style="width: 100%" class="cssPageTitle">
        <tr>
            <td class="cssPageTitle2">
                <asp:Label ID="Label4" runat="server" style="margin-left:10px;" CssClass="labelChange" Text="Job Allocation"></asp:Label>
            </td>     
            <td style="text-align:end;">            <div id="editsavedv">
                <input id="btnSave" type="button" class="cssButton labelChange" value="Save" />
                <input id="btnCancel" type="button" class="cssButton labelChange" value="Cancel" />
            </div></td>      
        </tr>
    </table>
        <div style="float: left; width: 97%; padding-left: 10px" align="left">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
            <asp:HiddenField ID="hdnCntJob" runat="server" />
            <asp:HiddenField ID="hdnCntStf" runat="server" />
            <asp:HiddenField ID="hdnCompanyid" runat="server" />
            <asp:HiddenField ID="hdnJobid" runat="server" />
            <asp:HiddenField ID="hdncode" runat="server" />
            <asp:HiddenField ID="hdndptwise" runat="server" />
            <asp:HiddenField ID="hdnTaskwise" runat="server" />
            <asp:HiddenField ID="hdnjid" runat="server" />
            <asp:HiddenField ID="hdnSappid" runat="server" />
            <asp:HiddenField ID="hdnPages" runat="server" />
            <asp:HiddenField ID="hdnpageIndex" runat="server" />
            <asp:HiddenField ID="hdnlink" runat="server" />
            <asp:HiddenField ID="hdnCltid" runat="server" />
            <asp:HiddenField ID="hdnroleotherdetail" runat="server" />
            <asp:HiddenField ID="hdnrolestatus" runat="server" />
            <asp:HiddenField ID="hdnroleenddate" runat="server" />
            <asp:HiddenField ID="hdnrolebilliable" runat="server" />
            <asp:HiddenField ID="hdnroleapprover" runat="server" />
            <asp:HiddenField ID="hdnrolestaff" runat="server" />
            <asp:HiddenField ID="hdnStfBud_New" runat="server" />
            <asp:HiddenField ID="hdnstfBudCheck" runat="server" />
                <asp:HiddenField ID="hdnIP" runat="server" />
            <asp:HiddenField ID="hdnName" runat="server" />
            <asp:HiddenField ID="hdnUser" runat="server" />
        </div>
        <div id="DivGrd" runat="server">
            <div style="float: left;">
                <asp:Panel ID="Panel5" runat="server" DefaultButton="btnsrchjob">
                    <div id="divBtn" style="display: none;">
                        <asp:Button ID="btnpage" runat="server" Text="Edit" OnClick="btnpage_Click"></asp:Button>
                    </div>
                    <div id="searchjob" runat="server" style="float: left; width: 100%; margin:10px; padding-bottom: 5px; ">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="Label21" runat="server" Text="Filter By"  Font-Bold="true" CssClass="LabelFontStyle"></asp:Label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlSearchby" CssClass="DropDown labelChange" runat="server">
                                        <asp:ListItem>Project</asp:ListItem>
                                        <asp:ListItem>Client</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSearchby" CssClass="txtbox" runat="server"></asp:TextBox>
                                </td>
                                <td style="padding-right:50px;">
                                    <asp:Button ID="btnsrchjob" runat="server" CssClass="cssButton" Text="Search" />
                                </td>
                                <td style="font-weight:bold">
                                        Status
                                </td>

                                <td style="padding-right:50px;">
                                <select id="selectStatus" class="DropDown">
                                <option value="OnGoing">OnGoing</option>
                                    <option value="OnHold">OnHold</option>
                                <option value="Completed">Completed</option>

                                </select>
                                </td>
                                <td style="padding-right:50px;">
                                    <input id="btnadd" runat="server" type="button" class="cssButton labelChange"
                                        value="Allocate Job" />
                                </td>
                                <td>
                                    <%--<asp:ImageButton ID="BtnExport" runat="server" ImageUrl="~/Images/xls-icon.png"
                                        Text="Export to Excel" />--%>
                                    <asp:ImageButton ID="btnExportToexcel" ImageUrl="~/Images/xls-icon.png" 
                                        runat="server" onclick="btnExportToexcel_Click" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </asp:Panel>
            </div>
            <div id="Div1" style="float: left; margin:10px; padding-left:5px; padding-right:15px;">
                <table id="tblGrd" width="1175px" border="1px" class="norecordTble" style="border-collapse: collapse;">

                </table>
                <table id="tblPager" style="border: 1px solid #BCBCBC; border-bottom: none; background-color: rgba(219,219,219,0.54); text-align: right;" cellpadding="2" cellspacing="0" width="1175px">
                    <tr>
                        <td>
                            <div class="Pager">
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <asp:HiddenField ID="hdnrolepermission" runat="server" />
        <asp:HiddenField ID="hdnroleadd" runat="server" />
        <asp:HiddenField ID="hdnroleedit" runat="server" />
        <asp:HiddenField ID="hdnroledelete" runat="server" />
        <%--divGrd--%>
        <div id="divAddEdit" style="overflow: hidden; padding-bottom: 10px; padding-top: 15px;width: 100%;
            float: left;">
            <%--<fieldset style="border: solid 1px black; padding: 10px; width:1175px;">--%>
              <%--  <legend class="labelChange" style="font-weight:bold; color:Red;"> Job Details</legend>--%>

            <div>
                <table>
                                    <tr>
                    <td style="width:20px;"></td>
                    <td >
                        <label class="labelstyle labelChange" style="font-weight:bold;padding-right: 50px;">Client</label>
                        </td>
                        <td>
                    <select id="drpclient" name="drpclient" class="DropDown" style="width:270px; height:25px;"><option value="0">--Select--</option>
                    </select>
                            </td><td>
                            <asp:Label ID="Label48" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label></td>
                   <td style="width:60px;"></td>
                     <td>
                         <label class="labelstyle labelChange" style="font-weight:bold;padding-right: 50px;">Project</label>
                         </td><td>
                         <select id="drpproject" name="drpproject" class="DropDown" style="width: 270px; height:25px;"><option value="0">--Select--</option>
                        </select>
                             </td><td>
                             <asp:Label ID="Label12" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </td>
                </tr>
                    <tr> <td colspan="5" style="height: 7px;"></td></tr>
                    <tr>
                        <td></td>
                        <td style="overflow: hidden; width:50px; float: left; padding-left: 5px; font-weight:bold;" class="LabelFontStyle labelChange">Status</td>
                    <td><asp:DropDownList ID="drp_jobstatus" runat="server" CssClass="DropDown" Width="200px" height="25px">
                                    <%--<asp:ListItem Value="0">--Select--</asp:ListItem>--%>
                                    <asp:ListItem Value="OnGoing">OnGoing</asp:ListItem>
                                    <asp:ListItem Value="OnHold">OnHold</asp:ListItem>
                                    <asp:ListItem Value="Completed">Completed</asp:ListItem>
                                </asp:DropDownList>
                        
                    </td>
                        <td> <asp:Label ID="Label1" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label></td>
                        <td style="width:60px;"></td>
                       <td style="overflow: hidden; width:50px; float: left; padding-left: 5px; font-weight:bold;" class="LabelFontStyle labelChange">Billable</td>
                         <td><asp:DropDownList ID="DrpBillable" runat="server" CssClass="DropDown" Width="100px" height="25px">
                                    <asp:ListItem Value="1">Yes</asp:ListItem>
                                    <asp:ListItem Value="0">No</asp:ListItem>
                                </asp:DropDownList>
                             
                         </td><td> <asp:Label ID="Label2" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label></td>
                    </tr>
                    <tr> <td colspan="5" style="height: 7px;"></td></tr>
                    <tr>
                        <td></td>
                               <td style="overflow: hidden; width:100px; float: left; padding-left: 5px; font-weight:bold;" class="LabelFontStyle labelChange">Start Date</td>
                    <td><asp:TextBox ID="txtstartdate" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtstartdate"
                                    Mask="99/99/9999" MaskType="Date" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
                                    CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                    CultureTimePlaceholder="" Enabled="True" />
                                <asp:Label ID="Label10" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                                <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtstartdate"
                                    PopupButtonID="txtstartdate" Format="dd/MM/yyyy" Enabled="True">
                                </cc1:CalendarExtender></td>
                        <td></td>    <td style="width:60px;"></td>
                           <td style="overflow: hidden; width:100px; float: left; padding-left: 5px; font-weight:bold;" class="LabelFontStyle labelChange">End Date</td>
                    <td><asp:TextBox ID="txtactualdate" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender16" runat="server" TargetControlID="txtactualdate"
                                    Mask="99/99/9999" MaskType="Date" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
                                    CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                    CultureTimePlaceholder="" Enabled="True" />
                                <asp:Label ID="Label26" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                                <cc1:CalendarExtender ID="txtactualdate_CalendarExtender" runat="server" TargetControlID="txtactualdate"
                                    PopupButtonID="txtactualdate" Format="dd/MM/yyyy" Enabled="True">
                                </cc1:CalendarExtender></td>
                    </tr>
                </table>
            </div>

            <table>
                <tr><td style="width:20px;"></td></tr>
                <tr>
                <td style="height:15px;"></td>
                </tr>
                <tr id="tr_job" name="tr_job">
                <td></td>
                 <td style="overflow: hidden; width:100px; float: left; padding-left: 5px; font-weight:bold;" CssClass="LabelFontStyle labelChange">Job Name</td>
                  <td colspan="2"><select id="drpjob" name="drpjob" class="DropDown" style="width: 455px; height:25px;"">
                                <option value="0">--Select--</option>
                            </select></td>
                   <td></td>
                    <td></td>
                
                </tr>
                
                <tr id="trAssign" style="display: none">
                    <td></td>
                    <td colspan="3">
                      
                        <label id="lblassgn" style="font-weight:bold;" class="labelstyle labelChange">
                                    Assignments</label>
                                                <label id="lblassgnCount" style="font-weight:bold;" class="labelstyle">
                                    </label>
                <asp:Panel ID="Panel6" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                Height="500px" ScrollBars="Vertical" Style="overflow: auto; margin: 8px 0 0;
                                float: left;" Width="435px">

                                <table id="tblAssign">
                                </table>
                            </asp:Panel></td>
                    <td>
                        <div style="width:720px;">
                            <label id="Label31" class="labelstyle labelChange" style="font-weight:bold">Staff </label>
                            &nbsp;<input type="checkbox" id="chkall"  class="staffchkall" />
                            <label id="lblStaffCount" class="labelChange" style="font-weight:bold"> </label>
                            <label id="Label32" class="labelstyle labelChange" style="font-weight:bold; padding-left: 140px;">Working % in a day</label>
                            <label id="Label33" class="labelstyle labelChange" style="font-weight:bold; padding-left: 20px;padding-right: 40px;">Working Start Dates</label>
                        <label id="Label34" class="labelstyle labelChange" style="font-weight:bold;">Working End Dates</label>
                        </div>
                        <div style="height: 500px;">
                            <asp:Panel runat="server" ID="Panel8" style="height:500px; overflow-y:scroll; border-color:#CCCCCC; border-style: solid; border-width: 1px;margin: 8px 0 0;">
                        <div style="height: 280px; margin-right: 0px;"><div id="content2"></div>
                        <table id="tblSft" class="allTimeSheettle" ></table></div></asp:Panel>
                            </div>
                    </td>
                    
                    
                </tr> 
                <tr>
                <td style="height:15px;"></td>
                </tr>

                </table>
            <%--</fieldset>--%>
              <%--  <fieldset style="border: solid 1px black; padding: 10px; width:1175px;">--%>
              <%--  <legend class="labelstyle labelChange" style="font-weight:bold; color:Red;">Other Details</legend>--%>
            <%--Changesc done Tejal (14/04/2020) this tab hided becoz it shos only Department name--%>
                <div id="div2" style="overflow: hidden; padding-bottom: 10px; width: 100%; float: left;display:none;">
                <div id="tabs" name="tabs" class="tabs">
                </div>
                <%-- div tabs --%>
            </div><%--</fieldset>--%>
            <%-- div2 --%>

        </div>

                                </div>
                            </div>

      
        <div id="Div20" class="comprw">
            <cc1:ModalPopupExtender runat="server" ID="ModalPopup_Job" BehaviorID="ListModalPopupBehavior"
                TargetControlID="hdnLargeImage" PopupControlID="panel2" BackgroundCssClass="modalBackground"
                OkControlID="Close2" DropShadow="false" RepositionMode="RepositionOnWindowScroll">
            </cc1:ModalPopupExtender>
            <asp:Panel ID="panel2" runat="server" Width="360px" Height="180px" BackColor="#FFFFFF">
                <asp:Button ID="hdnLargeImage" runat="server" Style="display: none" />
                <div id="Div3" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff;
                    font-weight: bold;">
                    <div id="Div7" style="padding-left: 2%; padding-top: 10px" class="auto-style1">
                        <asp:Label ID="Label8" runat="server" Text="Edit Details" CssClass="subHead1"></asp:Label>
                    </div>
                    <div id="Div8" style="width: 8%; float: left; padding-top: 1%; text-align: right;">
                        <img src="../images/error.png" id="Close2" border="0" name="Close2" alt="close" />
                    </div>
                </div>
                <div id="Div22" style="width: 358px; float: left; overflow: hidden; font-weight: bold;
                    padding-left: 30px; height: 20px; padding-top: 10px;">
                    <label class="labelChange">
                        Project:</label>
                    <asp:Label ID="lblAjob" runat="server"></asp:Label>
                </div>
                <div id="Div23" style="width: 458px; float: left; overflow: hidden; font-weight: bold;
                    padding-left: 30px;">
                    <label class="labelChange">
                        Client:</label>
                    <asp:Label ID="lblAClient" runat="server"></asp:Label>
                </div>
                <div id="divjobstatus" runat="server" style="padding-bottom: 20px; padding-top: 10px;">
                    <div style="overflow: hidden; width: 75px; float: left; font-size: 12px; font-weight: bold;
                        padding: 4px 0 0 30px;">
                        <asp:Label ID="lbljsattus" runat="server" CssClass="labelstyle labelChange" Text="Status"
                            Font-Size="Small"></asp:Label>
                    </div>
                    <div style="overflow: hidden; width: 230px; float: left; font-size: 12px; font-weight: bold;
                        padding-top: 4px;">
                        <asp:DropDownList ID="drpstatus" runat="server" CssClass="DropDown" Width="150px">
                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                            <asp:ListItem Value="OnGoing">OnGoing</asp:ListItem>
                            <asp:ListItem Value="Completed">Completed</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div id="divdates" runat="server" class="divedBlockNew" style="padding-left: 30px;
                    height: 48px;">
                    <div style="overflow: hidden; width: 100px; float: left">
                        <asp:Label ID="Label9" runat="server" CssClass="labelstyle" Text="Start Date" Font-Size="Small"></asp:Label>
                    </div>
                    <div style="overflow: hidden; width: 150px; float: left">
                        <asp:TextBox ID="txtstart" runat="server" CssClass="cssTextBoxDate" ReadOnly="True"></asp:TextBox>
                    </div>
                    <div style="overflow: hidden; width: 300px; padding-top: 3px">
                        <div style="overflow: hidden; width: 100px; float: left">
                            <asp:Label ID="Label14" runat="server" CssClass="labelstyle" Text="End Date" Font-Size="Small"></asp:Label>
                        </div>
                        <asp:TextBox ID="txtenddate" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txtenddate"
                            Mask="99/99/9999" MaskType="Date" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
                            CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                            CultureTimePlaceholder="" Enabled="True" />
                        <asp:Label ID="Label15" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtenddate"
                            PopupButtonID="txtenddate" Format="dd/MM/yyyy" Enabled="True">
                        </cc1:CalendarExtender>
                    </div>
                </div>
                <div id="divbiliable" style="padding-left: 30px" runat="server" class="divedBlockNew">
                    <asp:Label ID="Label11" runat="server" CssClass="labelstyle" Text="Billable" Font-Size="Small"></asp:Label>
                    <asp:DropDownList ID="drpbilliable" runat="server" CssClass="DropDown" Width="100px">
                        <asp:ListItem Value="1">Yes</asp:ListItem>
                        <asp:ListItem Value="0">No</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div id="divstatus" style="padding-left: 30px; padding-top: 10px;">
                    <input id="btnJob_Status" type="button" class="TbleBtns TbleBtnsPading labelChange"
                        value="Save" />
                </div>
                <div id="divbtndate" style="padding-left: 30px">
                    <input id="btnJob_date" type="button" class="TbleBtns TbleBtnsPading labelChange"
                        value="Save" />
                </div>
                <div id="dvbtnbill" style="padding-left: 30px">
                    <input id="btnJob_Bill" type="button" class="TbleBtns TbleBtnsPading labelChange"
                        value="Save" />
                </div>
            </asp:Panel>
        </div>
        <cc1:ModalPopupExtender runat="server" ID="ModalPopup1" BehaviorID="ListModalPopupBhr"
            ClientIDMode="Static" TargetControlID="hdnImageBtn" PopupControlID="Mpanel1"
            BackgroundCssClass="modalBackground" OkControlID="Close1" DropShadow="false"
            RepositionMode="RepositionOnWindowScroll">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="Mpanel1" runat="server" Width="460px" Height="520px" BackColor="#FFFFFF">
            <asp:Button ID="hdnImageBtn" runat="server" Style="display: none" />
            <div id="Div17" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff;
                font-weight: bold;">
                <div id="Div18" style="width: 88%; float: left; height: 20px; padding-left: 2%; padding-top: 10px">
                    <asp:Label ID="Label16" runat="server" Text="Edit Details" CssClass="subHead1"></asp:Label>
                </div>
                <div id="Div19" style="width: 8%; float: left; padding-top: 1%; text-align: right;">
                    <img src="../images/error.png" id="Close1" border="0" name="Close1" />
                </div>
            </div>
            <div id="Div4" style="width: 358px; float: left; overflow: hidden; font-weight: bold;
                padding-left: 10px; padding-top: 10px; height: 30px;">
                <label class="labelChange">
                    Job:</label>
                <asp:Label ID="lblsupjob" runat="server"></asp:Label>
            </div>
            <div id="Div6" style="width: 458px; float: left; overflow: hidden; font-weight: bold;
                padding-left: 10px; height: 30px;">
                <label class="labelChange">
                    Client:</label>
                <asp:Label ID="lblsupclient" runat="server"></asp:Label>
            </div>
            <div id="divsuperapp1" runat="server">
                <div id="Div9" style="width: 458px; overflow: hidden; font-weight: bold; padding-left: 10px;">
                    Super Approver</div>
                <div class="boexs" style="padding-left: 10px">
                    <select id="drpdwnappr" class="dropstyleJob" width="400px">
                        <option value="0">--Select one--</option>
                    </select></div>
                <div class="DivRight" style="width: 400px; padding-left: 10px;">
                    <%--                        <select id="drpAssign" class="DropDown" style= "width:435px;">
                    <option value="0">--Select--</option>
                </select>--%>
                    <div id="Div10" style="width: 458px; overflow: hidden; font-weight: bold; padding-left: 10px;">
                        Sub Approver</div>
                    <asp:Panel ID="Panel1" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                        Height="200px" ScrollBars="Vertical" Style="overflow: auto; margin: 8px 0 0;
                        float: left;" Width="430px">
                        <table id="tblassignment">
                        </table>
                    </asp:Panel>
                </div>
            </div>
            <div id="divstaff1" runat="server">
                <table>
                    <tr>
                        <td style="padding-left: 10px">
                            <div>
                                <label id="Label20" style="font-weight:bold;" class="labelstyle labelChange ">
                                    Department</label></div>
                            <asp:Panel ID="Panel3" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                Height="200px" ScrollBars="Vertical" Style="overflow: auto; margin: 8px 0 0;
                                float: left;" Width="200px">
                                <table id="tbldepartment">
                                </table>
                            </asp:Panel>
                        </td>
                    <%--    <td>
                            <div>
                                <label id="Label18" style="font-weight:bold;" class="labelstyle labelChange">
                                    Staff</label>&nbsp;<input type="checkbox" id="chkall" text="Check All" class="staffchkall" /></div>
                            <asp:Panel ID="Panel4" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                Height="200px" ScrollBars="Vertical" Style="overflow: auto; margin: 10px 0 0;
                                float: left;" Width="200px">
                                <table id="tblstaff">
                                </table>
                            </asp:Panel>
                        </td>--%>
                    </tr>
                </table>
            </div>
            <div id="dvsaveappr" style="padding-top: 20px; padding-left: 20px;">
                <input id="btnJob_Approver" type="button" class="TbleBtns TbleBtnsPading labelChange"
                    value="Save" />
            </div>
            <div id="dvsavestaff" style="padding-top: 20px; padding-left: 20px;">
                <input id="btnJob_Staff" type="button" class="TbleBtns TbleBtnsPading labelChange"
                    value="Save" />
            </div>
        </asp:Panel>
        <%--  <div id="EditJobwiseBud">--%>
        <asp:Button ID="hiddenLargeImage" runat="server" Style="display: none" />
        <cc1:ModalPopupExtender runat="server" ID="ModalPopupExtender1" BehaviorID="Jobbudgetpopup"
            TargetControlID="hiddenLargeImage" PopupControlID="panelupgrade" BackgroundCssClass="modalBackground"
            OkControlID="imgClose" DropShadow="false" RepositionMode="RepositionOnWindowScroll">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="panelupgrade" runat="server" Width="450px" BackColor="#FFFFFF">
            <div id="Div59" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff;
                font-weight: bold;">
                <div id="Div15" style="width: 90%; float: left; height: 20px; padding-left: 2%; padding-top: 1%">
                    <asp:Label ID="Label29" runat="server" Text="Job Wise Budgeting:" CssClass="subHead1"></asp:Label>
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
                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtfromdate"
                            Mask="99/99/9999" MaskType="Date" MessageValidatorTip="true" />
                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtfromdate"
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
                        <table id="Gridtimesheetdetails">
                        </table>
                    </td>
                </tr>
            </table>
            <div id="Div21">
                <div class="loader2">
                </div>
            </div>
        </asp:Panel>
        <%--    </div>--%>
<%--        <div id="EditStaffBud">--%>

            <cc1:ModalPopupExtender runat="server" ID="ModalPopupSftBudget" BehaviorID="StaffBudgetingpopup"
                TargetControlID="HdnBtnStfBud" PopupControlID="panel7" BackgroundCssClass="modalBackground"
                OkControlID="imgBudgetdClose" DropShadow="false" RepositionMode="RepositionOnWindowScroll">
            </cc1:ModalPopupExtender>
            <asp:Panel ID="panel7" runat="server" Width="560px" BackColor="#FFFFFF">
            <asp:Button ID="HdnBtnStfBud" runat="server" Style="display: none" />
                <div id="Div29" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff;
                    font-weight: bold;">
                    <div id="Div30" style="width: 90%; float: left; height: 20px; padding-left: 2%; padding-top: 1%">
                        <asp:Label ID="Label30" runat="server" Text="Edit Staff Budgeted Amount & Hours"
                            CssClass="subHead1"></asp:Label>
                    </div>
                    <div id="Div31" class="ModalCloseButton">
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
                    <asp:HiddenField ID="hdnjstrt" runat ="server" />
                    <table cellspacing="0" cellpadding="0" align="center" style="margin: 4px auto 4px auto;">
                        <tr>
                            <td>
                                <b>From Date&nbsp;</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txteditStaffBudgetedDate" Style="margin: 2px;" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                                <asp:TextBox ID="txtjustshowingdate" ReadOnly="true" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txteditStaffBudgetedDate"
                                    Mask="99/99/9999" MaskType="Date" MessageValidatorTip="true" />
                                <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txteditStaffBudgetedDate"
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
<%--                        <tr>
                            <td>
                                <b>Planned Drawings&nbsp;</b>
                            </td>
                            <td>
                                <asp:TextBox ID="txtPlaneedDrawings" Width="50px" Style="margin: 2px;" runat="server"
                                    CssClass="txtbox calbox"></asp:TextBox>
                            </td>
                        </tr>--%>
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
<%--                    <table id="shwoingdetals" align="center">
                        <tr>
                            <td>--%>
<%--                                <asp:GridView ID="gvCustomers" runat="server" AutoGenerateColumns="false" Font-Names="Arial"
                                    Font-Size="10pt" Width="100%" RowStyle-BackColor="#A1DCF2" HeaderStyle-BackColor="#3AC0F2"
                                    HeaderStyle-ForeColor="White">
                                    <Columns>
                                        <asp:BoundField ItemStyle-Width="150px" DataField="fromdate" HeaderText="CustomerID" />
                                        <asp:BoundField ItemStyle-Width="150px" DataField="BudgetAmt" HeaderText="CustomerID" />
                                        <asp:BoundField ItemStyle-Width="150px" DataField="Budgethours" HeaderText="City" />
                                    </Columns>
                                </asp:GridView>--%>
                                    <table id="gvCustomers"  class="mytable" >
                                        <thead>
                                            <tr class='mytable'>
                                                <th>Sr No.</th>
                                                <th>From Date</th>
                                                <th>To Date</th>
                                                <th>Hourly Amount</th>
                                                <th>Budget Hours</th>
<%--                                                <th>Planned Drawings</th>
                                                <th>Completed Drawings</th>--%>
                                                <th>Allocated Hours</th>
                                                <th>Staff Actual Hour Rate</th>
                                                <th></th>
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
<%--                                                <td align="right">
                                                </td>
                                                <td align="right">
                                                </td>--%>
                                                <td align="right">
                                                </td>
                                                <td align="right">
                                                </td>
                                                <td>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>

<%--                            </td>
                        </tr>
                    </table>--%>
                    <div id="content">
                        <div class="loader">
                        </div>
                    </div>
                </div>
            </asp:Panel>
<%--        </div>--%>
    </div>
</div>
