<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="true" CodeFile="TimesheetViewer.aspx.cs" Inherits="Company_TimesheetViewer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <script src="../js/d3.min.js" type="text/javascript"></script>
    <script src="../js/d3_tooltip.js" type="text/javascript"></script>
    <script src="../js/moment.js" type="text/javascript"></script>
    <script src="../js/form_select2.js" type="text/javascript"></script>
    <script src="../js/datatables.min.js" type="text/javascript"></script>
    <script src="../js/datatables_basic.js" type="text/javascript"></script>
    <script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>
    <script src="../js/echarts.min.js" type="text/javascript"></script>
    <script src="../JS/PopupAlert.js" type="text/javascript"></script>
    <script src="../JS/daterangepicker.min.js" type="text/javascript"></script>
    
    <script src="../js/bootstrap_multiselect.js" type="text/javascript"></script>
    <script src="https://cdn.jsdelivr.net/npm/emailjs-com@3/dist/email.min.js" type="text/javascript"></script>
    <link href="../css/daterangepicker.css" rel="stylesheet" type="text/css" />
   
    <script type="text/javascript">
        emailjs.init('9ptpXB8x4iMvLy91B')
    </script>

    <script language="javascript" type="text/javascript">
        var myProject = '';
        var minPageSize = 25;
        var start;
        var end;

        var TMStcChrt;

        var Chrtpie;
        $("[id*=dvmJob]").hide();
        var TBSel;
        $(document).ready(function () {
            TBSel = 'Timesheet';
            $("[id*=hdnPages]").val(1);
            $("[id*=hdnSize]").val(25);
            var maxLen = 900;
            start = moment($("[id*=hdnFromdate]").val());
            end = moment($("[id*=hdnTodate]").val());
            /////////////////// Date Range Configuration
            $('#Wkrange').daterangepicker({
                startDate: start,
                endDate: end,
                showDropdowns: true,
                autoApply: true,
                showCustomRangeLabel: false,
                alwaysShowCalendars: true,
                ranges: {
                    'Today': [moment(), moment()],
                    'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Last 7 Days': [moment().subtract(6, 'days'), moment()],
                    'Last 30 Days': [moment().subtract(29, 'days'), moment()],
                    'This Month': [moment().startOf('month'), moment().endOf('month')],
                    'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
                }
            }, cb);

            cb(start, end);
            //////////////////////// End of Configuration

            $('#Wkrange').on('apply.daterangepicker', function (ev, picker) {
                $("[id*=hdnFromdate]").val(picker.startDate.format('YYYY-MM-DD'));
                $("[id*=hdnTodate]").val(picker.endDate.format('YYYY-MM-DD'));


                if (TBSel == 'Project') {
                    Project_Summary();
                }
                else if (TBSel == 'Timesheet') {
                    chkStatus();
                }
                else if (TBSel == 'Team') {
                    Team_Summary();
                }
                else if (TBSel == 'Client') {
                    Client_Summary();
                }
            });

            $("[id*=txt-narr-length-left]").html(maxLen);
            $("body").on("dblclick", ".icon-checkmark2", function () {
                $(this).removeClass("icon-checkmark2").removeClass("text-success");
                $(this).addClass("icon-cross3").addClass("text-danger");
            });

            $("body").on("dblclick", ".icon-cross3", function () {
                $(this).removeClass("icon-cross3").removeClass("text-danger");
                $(this).addClass("icon-checkmark2").addClass("text-success");
            });
            $("[id*=txtdateBindStaff]").val($("[id*=hdntxtdateBindStaff]").val());
            $("[id*=lblweekdt]").html($("[id*=hdntxtdateBindStaff]").val());
            //$("[id*=txtfrom]").val($("[id*=hdnFromdate]").val());
            //$("[id*=txtto]").val($("[id*=hdnTodate]").val());
            CompanyPermissions = jQuery.parseJSON($("[id*=hdnCompanyPermission]").val());
            GetTimesheetVwrdropdown();
            //PieGraph();
            $('.sidebar-main-toggle').click();
            ///Hide Unhide Admin/Approver/Staff
            if ($("[id*=hdnEditStaffcode]").val() > 0) {
                if ($("[id*=hdnRolename]").val() == 'Staff') {
                    $("[id*=btnAppr]").hide();
                    $("[id*=btnRej]").hide();
                    $("[id*=chkAlltsid]").hide();
                    $("[id*=lblsct]").hide();
                    $("[id*=lblMytime]").hide();
                    $("[id*=chkMy]").hide();
                    $("[id*=btnStatusAppr]").hide();
                    $("[id*=btnStatusReject]").hide();
                    $("[id*=chkApprovedAll]").hide();
                    $("[id*=lblAppr]").hide();
                } else {
                    $("[id*=drpstatus]").val('Submitted');
                    $("[id*=drpstatus]").trigger('change');
                }
            } else {
                $("[id*=btnAppr]").hide();
                $("[id*=btnRej]").hide();
                $("[id*=chkAlltsid]").hide();
                $("[id*=lblsct]").hide();
                $("[id*=lblMytime]").hide();
                $("[id*=chkMy]").hide();

                $("[id*=btnStatusAppr]").hide();
                $("[id*=btnStatusReject]").hide();
                $("[id*=chkApprovedAll]").hide();
                $("[id*=lblAppr]").hide();
            }

            ///Setting the Date
            $("[id*=txtdateBindStaff]").val($("[id*=hdntxtdateBindStaff]").val());
            $("[id*=lblweekdt]").html($("[id*=hdntxtdateBindStaff]").val());
            //$("[id*=txtfrom]").val($("[id*=hdnFromdate]").val());
            //$("[id*=txtto]").val($("[id*=hdnTodate]").val());

            $('#editnarration').on('keypress', function (e) {
                var length = $(this).val().length + 1;
                var AmountLeft = maxLen - length;
                $("[id*=txt-narr-length-left]").html(AmountLeft);
                if (length >= maxLen && e.keyCode != 8) {
                    showWarningAlert('Maximum 900 Charaters are allowed in Narration');
                    e.preventDefault();
                }
            });


            $("[id*= drpclient3]").on('change', function () {

                $("[id*=hdnPages]").val(1);
                //$("[id*=hdnSize]").val(25);
                $("[id*= hdncid]").val($("[id*= drpclient3]").val());
                if (CompanyPermissions[0].ProjectnClient == 0) {
                    if ($("[id*=hdnPageLevel]").val() == '2') {
                        fillJobDrpdwn();
                    } else {
                        fillPrjDrpdwn();
                    }
                }
                if (TBSel == 'Project') {
                    Project_Summary();
                }
                else if (TBSel == 'Timesheet') {
                    chkStatus();
                }
                else if (TBSel == 'Team') {
                    Team_Summary();
                }
                else if (TBSel == 'Client') {
                    Client_Summary();
                }

            });

            $("[id*=btnexcel]").on('click', function () {
                Blockloadershow();
                $("[id*=hdnFmdat1]").val($("[id*= hdnFromdate]").val());
                $("[id*= hdnTodt1]").val($("[id*= hdnTodate]").val());
                // Code Added By SathishRam For Hiding BlockerUI On 21-Mar-2023
                var cookieval = makeid();
                $('#<%= hdnCookieName.ClientID %>').val(cookieval);
                test(cookieval);
                Blockloaderhide();
                // Code Added By SathishRam For Hiding BlockerUI On 21-Mar-2023
            });

            $("[id*=btnTSNot]").on('click', function () {
                Blockloadershow();
                $("[id*=hdnFmdat1]").val($("[id*= hdnFromdate]").val());
                $("[id*= hdnTodt1]").val($("[id*= hdnTodate]").val());
                Blockloaderhide();
            });

            $("[id*=btnMiniExcel]").on('click', function () {
                Blockloadershow();
                $("[id*=hdnFmdat1]").val($("[id*= hdnFromdate]").val());
                $("[id*= hdnTodt1]").val($("[id*= hdnTodate]").val());
                Blockloaderhide();
            });


            $("[id*= drpstatus]").on('change', function () {
                $("[id*=hdnPages]").val(1);
                //$("[id*=hdnSize]").val(25);
                chkStatus();
            });

            $("[id*= drpProj]").on('change', function () {
                $("[id*=hdnPages]").val(1);
                //$("[id*=hdnSize]").val(25);
                $("[id*= hdnpid]").val($("[id*= drpProj]").val());
                GetJobnamelevel3();
                if (TBSel == 'Project') {
                    Project_Summary();
                }
                else if (TBSel == 'Timesheet') {
                    chkStatus();
                }
                else if (TBSel == 'Team') {
                    Team_Summary();
                }
                else if (TBSel == 'Client') {
                    Client_Summary();
                }
            });

            $("[id*= drpTask]").on('change', function () {
                $("[id*=hdnPages]").val(1);
                //$("[id*=hdnSize]").val(25);
                $("[id*= hdntask]").val($("[id*= drpTask]").val());
                chkStatus();
            });

            $("[id*= drpDept]").on('change', function () {
                $("[id*=hdnPages]").val(1);
                //$("[id*=hdnSize]").val(25);
                $("[id*= hdndid]").val($("[id*= drpDept]").val());
                Project_Summary();
            });

 
            $("[id*= drpTMDp]").on('change', function () {
                $("[id*=hdnPages]").val(1);
                
                $("[id*= hdndid]").val($("[id*= drpTMDp]").val());
                Team_Summary();
            });

             
            $("[id*= drpteam]").on('change', function () {
                $("[id*=hdnPages]").val(1);
                //$("[id*=hdnSize]").val(25);
                 
                Team_Summary();
            });

            $("[id*= drpMjob3]").on('change', function () {
                $("[id*=hdnPages]").val(1);
                //$("[id*=hdnSize]").val(25);
                $("[id*= hdnjid]").val($("[id*= drpMjob3]").val());
                if (TBSel == 'Team') {
                    Team_Summary();
                }
                else if (TBSel == 'Client') {
                    Client_Summary();
                }
                else {
                    chkStatus();
                }
            });

            $("[id*= ddlDept]").on('change', function () {
                $("[id*=hdnPages]").val(1);
                //$("[id*=hdnSize]").val(25);
                //$("[id*= hdnjid]").val($("[id*= drpMjob3]").val());
                if (TBSel == 'Team') {
                    Team_Summary();
                }
                else if (TBSel == 'Client') {
                    Client_Summary();
                }
                else {
                    chkStatus();
                }
            });


            $("[id*= drpstaff3]").on('change', function () {
                $("[id*=hdnPages]").val(1);
                //$("[id*=hdnSize]").val(25);
                $("[id*= hdnsid]").val($("[id*= drpstaff3]").val());
                if (TBSel == 'Team') {
                    Team_Summary();
                }
                else if (TBSel == 'Client') {
                    Client_Summary();
                }
                else {
                    chkStatus();
                }
            });

            $("[id*= drpPageSize_AllApproved]").on('change', function () {
                $("[id*=hdnSize]").val($("[id*= drpPageSize_AllApproved]").val());
                chkStatus();
            });

            $("[id*=drpPageSize_Pending]").on('change', function () {
                $("[id*=hdnSize]").val($("[id*=drpPageSize_Pending]").val());
                chkStatus();
            });

            $("[id*=drpPageSize_StaffSummary]").on('change', function () {
                $("[id*=hdnSize]").val($("[id*=drpPageSize_StaffSummary]").val());
                chkStatus();
            });

            $("[id*=drpPageSize_Timesheetnotsubmitted]").on('change', function () {
                $("[id*=hdnSize]").val($("[id*=drpPageSize_Timesheetnotsubmitted]").val());
                chkStatus();
            });

            $("[id*=drpPageSize_MinHrs]").on('change', function () {
                $("[id*=hdnSize]").val($("[id*=drpPageSize_MinHrs]").val());
                chkStatus();
            });

            $("[id*= UpdateTS]").on('click', function () {
                UpdateTimehseet();
            });

            $("[id*= chkMy]").on('click', function () {
                //PieGraph();
                chkStatus();
            });

            $("[id*= btnSearch]").on('click', function () {
                let isBool = validateFromToDate();
                if (isBool) {
                    $("#divFromDate_GreaterThanError").css("display", "none");
                    $("#divToDate_LessThanError").css("display", "none");
                    $("#divToDateValidation_OneMonth").css("display", "none");
                    $("[id*=hdnPages]").val(1);
                    $("[id*=hdnSize]").val(25);
                    chkStatus();
                }
                return false;
            });

            $("[id*=btnEsave]").click(function () {
                var EId = $("#SelectExpense").val();
                if (parseInt(EId) == 0) {
                    showWarningAlert("Please select Expense Type");
                    return false;
                }
                var EAmt = $("[id*=txtEAmt]").val();
                if (parseFloat(EAmt) == 0 || EAmt == '' || EAmt == undefined) {
                    showWarningAlert("Please Enter valid Expense Amount");
                    return false;
                }
                var Cur = $("#drpCurrency").val();
                if (parseInt(Cur) == 0) {
                    showWarningAlert("Please select currency");
                    return false;
                }
                var ExpName = $("#SelectExpense option:selected").text();
                var ExpNar = $("[id*=txtNarration]").val();
                var del = "<a href='#' onclick='deleteExp($(this))'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1.25rem;color:red'></i></a>";
                var tr = "<tr><td>" + ExpName + "<input type='hidden' id='hdnExp' name='hdnExp' value='" + EId + "'></td><td>" + ExpNar + "</td><<td>" + EAmt + " " + "(" + Cur + ")" + "</td><td>" + del + "</td></tr>";
                $('#Tbl_Expense > tbody:first').append(tr);

                $('#SelectExpense').empty();
                $('#SelectExpense').append('<option class="labelChange" value="0">Select expense type</option>');
                $.each(jQuery.parseJSON($("[id*=hdnExpenseMaster]").val()), function (i, va) {
                    $('#SelectExpense').append('<option value="' + va.OpeId + '">' + va.OPEName + '</option>');
                });
                //////////Currency drop down inside popup
                $('#drpCurrency').empty();
                $('#drpCurrency').append('<option class="labelChange" value="0">Select</option>');
                $.each(jQuery.parseJSON($("[id*=hdnCurrencyMaster]").val()), function (i, va) {
                    $('#drpCurrency').append('<option value="' + va.Currency + '">' + va.Currency + '</option>');
                });
                $('#drpCurrency').val($("[id*=hdnTsCurrency]").val());
                $("[id*=txtEAmt]").val('');
                $("[id*=txtNarration]").val('');
            });

            $("[id*=btnSaveExpense]").click(function () {
                var Expense = '';
                $('#Tbl_Expense > tbody  > tr').each(function () {
                    var m = $(this).find("input[name=hdnExp]").val();
                    var Narr = $(this).find("td").eq(1).html().replace(/\,/g, '#CM').replace(/\//g, '#BS').replace(/\^/g, '#PW').replace(/\-/g, '#DS');
                    Expense = Expense + $(this).find("td").eq(0).text() + "," + m + "," + Narr + "," + $(this).find("td").eq(2).html() + "/";
                });
                if (Expense == '' || Expense == null || Expense == undefined) {
                    Expense = '0';
                }
                if (parseFloat($("[id*=hdnTsExpID]").val()) > 0) {
                    saveExpesneOnEdittsidbased($("[id*=hdnTsExpID]").val());
                }
                else {
                    var hdnExpId = $("[id*=hdnExpense]").val();
                    $('#' + hdnExpId).val(Expense);
                }
                $("[id*=Tbl_Expense] tbody").empty();
            });
            $("#btnECancel").click(function () { $("[id*=Tbl_Expense] tbody").empty(); });

            /* Code added By SathishRam On 12-March-2023 */
            function validateFromToDate() {
                let fromDate = new Date($("[id*= hdnFromdate]").val());
                let toDate = new Date($("[id*= hdnTodate]").val());
                $("#divFromDate_GreaterThanError").css("display", "none");
                $("#divToDate_LessThanError").css("display", "none");
                $("#divToDateValidation_OneMonth").css("display", "none");
                if (toDate < fromDate) {
                    $("#divFromDate_GreaterThanError").css("display", "block");
                    $("#divToDate_LessThanError").css("display", "block");
                    return false;
                }
                //let addedMonthDate = new Date(fromDate.setMonth(fromDate.getMonth() + 1));
                //if (fromDate < toDate) {
                //    if (toDate > addedMonthDate) {
                //        $("#divToDateValidation_OneMonth").css("display", "block");
                //        return false;
                //    }
                //}
                return true;
            }

            ///Approver Timesheet Button
            $("[id*= btnAppr]").on('click', function () {
                SubmiteApprButton('StatusSubmitted');
            });

            ///Reject Timesheet Button
            $("[id*= btnRej]").on('click', function () {
                var rr = "";
                var notice = new PNotify({
                    title: 'Confirmation',
                    text: '<p>Are you sure you want to Reject Timesheet?</p>',
                    hide: false,
                    type: 'warning',
                    confirm: {
                        confirm: true,
                        buttons: [
                            {
                                text: 'Yes',
                                addClass: 'btn btn-sm btn-primary'
                            },
                            {
                                addClass: 'btn btn-sm btn-link'
                            }
                        ]
                    },
                    buttons: {
                        closer: false,
                        sticker: false
                    }
                })

                // On confirm
                notice.get().on('pnotify.confirm', function () {
                    if (CompanyPermissions[0].RejectReasons == true) {
                        if ($("[id*=txtResn]").val().trim() === "") {
                            showWarningAlert('Reject Reason Mandory !')
                        }
                    }
                    else {
                        RejectTimesheet('StatusSubmitted');
                    }
                })

                // On cancel
                notice.get().on('pnotify.cancel', function () {
                });
            });

            $("[id*= btnStatusAppr]").on('click', function () {
                ApprovedStutApprButton('StatusApproved');
            });

            ///Reject Approved Timesheet Button
            $("[id*= btnStatusReject]").on('click', function () {
                var rr = "";
                var notice = new PNotify({
                    title: 'Confirmation',
                    text: '<p>Are you sure you want to Reject Timesheet?</p>',
                    hide: false,
                    type: 'warning',
                    confirm: {
                        confirm: true,
                        buttons: [
                            {
                                text: 'Yes',
                                addClass: 'btn btn-sm btn-primary'
                            },
                            {
                                addClass: 'btn btn-sm btn-link'
                            }
                        ]
                    },
                    buttons: {
                        closer: false,
                        sticker: false
                    }
                })

                // On confirm
                notice.get().on('pnotify.confirm', function () {
                    ApprovedStutRejButton('StatusApproved');
                })

                // On cancel
                notice.get().on('pnotify.cancel', function () {
                });
            });

            $("[id*= chkAlltsid]").on('click', function () {
                var chkprop = $(this).is(':checked');

                $("input[name=chkclt]").each(function () {
                    if (chkprop) {
                        $(this).attr('checked', 'checked');
                    }
                    else {
                        $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                    }
                });

            });

            $("[id*= chkApprovedAll]").on('click', function () {
                var chkprop = $(this).is(':checked');

                $("input[name=chkcltApp]").each(function () {
                    if (chkprop) {
                        $(this).attr('checked', 'checked');
                    }
                    else {
                        $(this).removeAttr('checked');
                    }
                });
            });

            $("[id*=Save3Reson]").on('click', function () {
                var r = $("[id*=txtResn]").val();
                Savereason(r);
            });

            $("[id*=Save2Reson]").on('click', function () {
                var r = $("[id*=txt2Resn]").val();
                Savereason(r);
            });

            $('#chkShowNarrationMessage').change(function () {
                if (this.checked) {
                    var column_ShowNarrMsg = "table ." + $(this).attr("name");
                    $(column_ShowNarrMsg).show();

                    var column_ShowNarrIcon = "table ." + "chkShowNarrationIcon";
                    $(column_ShowNarrIcon).hide();
                }
                else {
                    var column_ShowNarrMsg = "table ." + $(this).attr("name");
                    $(column_ShowNarrMsg).hide();

                    var column_ShowNarrIcon = "table ." + "chkShowNarrationIcon";
                    $(column_ShowNarrIcon).show();
                }
            });


            var element_Chrt_pie_labels = document.getElementById('pie_Chrt');
            if (element_Chrt_pie_labels) {

                // Initialize chart
                Chrtpie = echarts.init(element_Chrt_pie_labels);

            }


            $("[id*=btnExportPDF]").on('click', function () {
                // generatePDF();
                exportToPDF();
            });

 
            $("[id*=btnTMExportPDF]").on('click', function () {
                // generatePDF();
                TeamexportToPDF();
            });


            $("[id*=drptopprj]").on('change', function () {
                Project_Summary();

            });

            $("[id*=drpCltType]").on('change', function () {
                Client_Summary();
            });
        });


        ////////******************************Timesheets Viewer*******************************////////////////////

        function Timesheet() {
            TBSel = 'Timesheet';
            $("[id*=drpMjob3]").attr("disabled", false);
            $("[id*=drpDept]").attr("disabled", false);
            $("[id*=drpstatus]").attr("disabled", false);
            $("[id*=drpstaff3]").attr("disabled", false);
            $("[id*=ddlDept]").attr("disabled", false);
            $("[id*=chkMy]").attr("disabled", false);
            $("[id*=chkShowNarrationMessage]").attr("disabled", false);
            chkStatus();
        }

        function cb(start, end) {
            $('#Wkrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
        }

        function ApprovedStutApprButton(TypeStatus) {
            var All_tsid = "", r = "", s = "";
            Blockloadershow();
            var billable = 0;
            $("input[name=chkcltApp]:checked").each(function () {
                var row = $(this).closest("tr");
                var t = '';
                var tid = $(this).val();
                var etime = '';
                var etime = '00.00';
                billable = 0;
                r = $("#hdnResn_tsid_" + tid).val();

                if (row.find(".icon-checkmark2").length > 0) { billable = 1; }
                if ($("[id*=hdnDualApp]").val() == 'True') {
                    var ap = row.find("input[name=hdnaP]").val();
                    var t = row.find("input[name=hdnStatus]").val();
                    if (ap == 'Semi Approved' && t == 'Submitted') {
                        s = 'Semi Approved';
                        All_tsid = $(this).val() + ',' + s + ',' + r + ',' + etime + ',' + billable + '^' + All_tsid;
                    }
                    else if (ap == 'Approved' && t == 'Semi Approved') {
                        s = 'Approved';
                        All_tsid = $(this).val() + ',' + s + ',' + r + ',' + etime + ',' + billable + '^' + All_tsid;
                    }

                    else if (ap == 'Final' && t == 'Submitted') {
                        s = 'Approved';
                        All_tsid = $(this).val() + ',' + s + ',' + r + ',' + etime + ',' + billable + '^' + All_tsid;
                    }
                    else if (ap == 'Both' && t == 'Submitted') {
                        s = 'Approved';
                        All_tsid = $(this).val() + ',' + s + ',' + r + ',' + etime + ',' + billable + '^' + All_tsid;
                    }

                }
                else {
                    var t = row.find("input[name=hdnStatus]").val();
                    if (CompanyPermissions[0].Edit_Billing_Hrs == true) {
                        etime = row.find("input[id=txteditbillablehrs]").val();

                        var startTime = etime.replace(':', '.');
                        var firstHH = startTime.split('.')[0];
                        var firstMM = startTime.split('.')[1];
                        if (firstMM == undefined) {
                            firstMM = "0";
                        }

                        if (firstHH == undefined) {
                            firstHH = "0";
                        }

                        if (firstHH == "") {
                            firstHH = "0";
                        }
                        if (firstMM == "") {
                            firstMM = "0";
                        }

                        if (firstMM >= 60) {
                            var realmin = firstMM % 60;
                            var hours = Math.floor(firstMM / 60);
                            firstHH = parseFloat(firstHH) + parseFloat(hours);

                            firstMM = realmin;
                        }

                        if (firstMM < 10) {
                            if (parseFloat(firstMM.length) < 2) {
                                firstMM = firstMM + "0";
                            }
                        }

                        if (firstHH < 10) {
                            if (parseFloat(firstHH.length) < 2) {
                                firstHH = "0" + firstHH;
                            }
                        }
                        iTime = firstHH + '.' + firstMM;
                        etime = iTime;
                    }

                    if (r == undefined) {
                        r = '';
                    }
                    if (etime == undefined) {
                        etime = '00.00';
                    }

                    if (t == 'Submitted' || t == 'Approved') {
                        s = 'Approved';
                        var tt = $(this).val();
                        All_tsid = tt + ',' + s + ',' + r + ',' + etime + ',' + billable + '^' + All_tsid;
                    }
                }
            });

            if (All_tsid != '') {
                Update_Reject_Approve(All_tsid, 'A', r, TypeStatus);
            }
            else {
                showWarningAlert('Kindly Select atleast one record !!!');
                Blockloaderhide();
                return false;
            }
        }

        function ApprovedStutRejButton(TypeStatus) {
            Blockloadershow();
            var All_tsid = '';
            var r = '';
            var s = '';
            var billable = 0;
            $("input[name=chkcltApp]:checked").each(function () {
                var row = $(this).closest("tr");
                var t = '';
                billable = 0;
                if (row.find(".icon-checkmark2").length > 0) { billable = 1; }

                if ($("[id*=hdnDualApp]").val() == 'True') {
                    t = row.find("input[name=hdnStatus]").val();
                }
                else {
                    var etime = '00.00';
                    var t = row.find("input[name=hdnStatus]").val();

                    if (CompanyPermissions[0].Edit_Billing_Hrs == true) {
                        etime = row.find("td:eq(7)").html();
                        var startTime = etime.replace(':', '.');
                        var firstHH = startTime.split('.')[0];
                        var firstMM = startTime.split('.')[1];
                        if (firstMM == undefined) {
                            firstMM = "0";
                        }

                        if (firstHH == undefined) {
                            firstHH = "0";
                        }

                        if (firstHH == "") {
                            firstHH = "0";
                        }
                        if (firstMM == "") {
                            firstMM = "0";
                        }

                        if (firstMM >= 60) {
                            var realmin = firstMM % 60;
                            var hours = Math.floor(firstMM / 60);
                            firstHH = parseFloat(firstHH) + parseFloat(hours);
                            firstMM = realmin;
                        }

                        if (firstMM < 10) {
                            if (parseFloat(firstMM.length) < 2) {
                                firstMM = firstMM + "0";
                            }
                        }

                        if (firstHH < 10) {
                            if (parseFloat(firstHH.length) < 2) {
                                firstHH = "0" + firstHH;
                            }
                        }
                        iTime = firstHH + '.' + firstMM;
                        etime = iTime;
                    }
                }
                if (t == 'Submitted' || t == 'Approved' || t == 'Semi Approved') {

                    var tid = $(this).val();
                    r = $("#hdnResn_tsid_" + tid).val();
                    s = 'Rejected';

                    if (r == undefined) {
                        r = '';
                    }
                    if (etime == undefined) {
                        etime = '00.00';
                    }

                    All_tsid = $(this).val() + ',' + s + ',' + r + ',' + etime + ',' + billable + '^' + All_tsid;
                }
            });
            if (All_tsid != '') {
                Update_Reject_Approve(All_tsid, 'R', r, TypeStatus)
            }
            else {
                showWarningAlert('Kindly Select atleast one record !!!');
                Blockloaderhide();
                return false;
            }
        }

        function SubmiteApprButton(TypeStatus) {
            var All_tsid = "", r = "", s = "";
            Blockloadershow();
            var billable = 0;
            $("input[name=chkclt]:checked").each(function () {
                var row = $(this).closest("tr");
                var t = '';
                var tid = $(this).val();
                var etime = '';
                var etime = '00.00';
                billable = 0;

                if (row.find(".icon-checkmark2").length > 0) billable = 1;
                r = $("#hdnResn_tsid_" + tid).val();
                if ($("[id*=hdnDualApp]").val() == 'True') {
                    var ap = row.find("input[name=hdnaP]").val();
                    var t = row.find("input[name=hdnStatus]").val();
                    if (ap == 'Semi Approved' && t == 'Submitted') {
                        s = 'Semi Approved';
                        All_tsid = $(this).val() + ',' + s + ',' + r + ',' + etime + ',' + billable + '^' + All_tsid;
                    }
                    else if (ap == 'Approved' && t == 'Semi Approved') {
                        s = 'Approved';
                        All_tsid = $(this).val() + ',' + s + ',' + r + ',' + etime + ',' + billable + '^' + All_tsid;
                    }

                    else if (ap == 'Final' && t == 'Submitted') {
                        s = 'Approved';
                        All_tsid = $(this).val() + ',' + s + ',' + r + ',' + etime + ',' + billable + '^' + All_tsid;
                    }
                    else if (ap == 'Both' && t == 'Submitted') {
                        s = 'Approved';
                        All_tsid = $(this).val() + ',' + s + ',' + r + ',' + etime + ',' + billable + '^' + All_tsid;
                    }

                }
                else {
                    var t = row.find("input[name=hdnStatus]").val();
                    if (CompanyPermissions[0].Edit_Billing_Hrs == true) {
                        etime = row.find("input[id=txteditbillablehrs]").val();
                        var startTime = etime.replace(':', '.');
                        var firstHH = startTime.split('.')[0];
                        var firstMM = startTime.split('.')[1];
                        if (firstMM == undefined) {
                            firstMM = "0";
                        }

                        if (firstHH == undefined) {
                            firstHH = "0";
                        }
                        if (firstHH == "") {
                            firstHH = "0";
                        }
                        if (firstMM == "") {
                            firstMM = "0";
                        }

                        if (firstMM >= 60) {
                            var realmin = firstMM % 60;
                            var hours = Math.floor(firstMM / 60);
                            firstHH = parseFloat(firstHH) + parseFloat(hours);
                            firstMM = realmin;
                        }

                        if (firstMM < 10) {
                            if (parseFloat(firstMM.length) < 2) {
                                firstMM = firstMM + "0";
                            }
                        }

                        if (firstHH < 10) {
                            if (parseFloat(firstHH.length) < 2) {
                                firstHH = "0" + firstHH;
                            }
                        }
                        iTime = firstHH + '.' + firstMM;
                        etime = iTime;
                    }

                    if (t == 'Submitted' || t == 'Approved') {
                        s = 'Approved';
                        All_tsid = $(this).val() + ',' + s + ',' + r + ',' + etime + ',' + billable + '^' + All_tsid;
                    }
                }
            });

            if (All_tsid != '') {
                Update_Reject_Approve(All_tsid, 'A', r, TypeStatus);
            }
            else {
                showWarningAlert('Kindly Select atleast one record !!!');
                Blockloaderhide();
                return false;
            }
        }

        function ShowEditFr() {
            var tTime = '00:00';
            var FTime = '00:00';
            var totalHH = '00';
            var totalMM = '00';
            var rw = '';
            var txt = $("#editfromtime").id;
            var V = $("#editfromtime").val();
            var Mhrs = parseFloat(CompanyPermissions[0].MaxHrs);
            var ZeroD = CompanyPermissions[0].Zero_decimals;
            if (V == "" || V == null || V == undefined || V.length < 5 || V.length > 5) {
                V = ConvertFormat(i, V);
            }

            if (V != undefined) {
                if (V != '') {
                    var JM = V.split(':')[1];
                    var jhrs = V.replace(':', '.');
                    if (isNaN(jhrs) == true) {
                        $("#" + txt).val('00:00');
                    }

                    if (Mhrs > 0) {
                        if (jhrs > Mhrs) {
                            $("#" + txt).val('00:00');
                        }
                    }

                    if (jhrs > 23.59) {
                        $("#" + txt).val('00:00');
                    }
                    if (JM > 59) {
                        $("#" + txt).val('00:00');
                    }
                    if (ZeroD == false) {
                        if (JM > 00 && JM < 60) {
                            $("#" + txt).val('00:00');
                        }
                    }
                }
            }
        }

        function ShowEditTo() {
            var tTime = '00:00';
            var FTime = '00:00';
            var totalHH = '00';
            var totalMM = '00';
            var rw = '';
            var txt = $("#edittotime").id;
            var V = $("#edittotime").val();

            var Mhrs = parseFloat(CompanyPermissions[0].MaxHrs);
            var ZeroD = CompanyPermissions[0].Zero_decimals;
            if (V == "" || V == null || V == undefined || V.length < 5 || V.length > 5) {
                V = ConvertEditFormat($("#edittotime"), V);
            }

            var fromtime = tominutes($("#editfromtime").val());
            if (fromtime <= 0) {
                $("#editfromtime").val();
                $("#edittotime").val('00:00');
                showDangerAlert('From Time cannot be blank');
                return;
            }
            if (V != undefined) {
                if (V != '') {
                    var JM = V.split(':')[1];
                    var jhrs = V.replace(':', '.');
                    if (isNaN(jhrs) == true) {
                        $("#" + txt).val('00:00');
                    }

                    if (Mhrs > 0) {
                        if (jhrs > Mhrs) {
                            $("#" + txt).val('00:00');
                        }
                    }
                    if (jhrs > 23.59) {
                        $("#" + txt).val('00:00');
                    }
                    if (JM > 59) {
                        $("#" + txt).val('00:00');
                    }
                    if (ZeroD == false) {
                        if (JM > 00 && JM < 60) {
                            $("#" + txt).val('00:00');
                        }
                    }

                    ///////////// Getting TotalTime

                    var totime = tominutes($("#edittotime").val());
                    var difference = Math.abs(totime - fromtime);

                    var result = [
                        Math.floor(difference / 3600), // HOURS
                        Math.floor((difference % 3600) / 60)
                    ];

                    // formatting (0 padding and concatenation)
                    result = result.map(function (v) {
                        return v < 10 ? '0' + v : v;
                    }).join('.');
                    result = result.replace('.', ':');
                    $("#TxtedtTottime").val(result);
                    V = V.replace('.', ':');
                    $("#" + txt).val(V);
                }
            }
        }

        function Update_Reject_Approve(All_tsid, S, r, TypeStatus) {
            if (S == 'R') {
                S = "Rejected";
            }
            else if (S == 'A') {
                S = "Approved";
            }
            var data = {
                ts: {
                    //Compid: $("[id*=hdnCompanyid]").val(),
                    Timesheets: All_tsid,
                    JobApprover: $("[id*=hdnEditStaffcode]").val(),
                    Status: S,
                    Satffstatus: $("[id*=hdnDualApp]").val(),
                }
            };

            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/Update_Approve_Reject",
                data: JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    if (parseFloat(myList.length) > 0) {
                        showSuccessAlert('Timesheet updated sucessfully');
                        if ($("[id*=hdnPageLevel]").val() > 2) {
                            if ($("[id*=hdnDualApp]").val() == 'True') {
                                if ($("[id*=hdnEditStaffcode]").val() == 0) {
                                    Pending_Timesheets();
                                } else {
                                    PendDualAppBind_Timesheets();
                                }
                            } else {
                                if (TypeStatus == 'StatusApproved') {
                                    Bind_Timesheets();
                                } else {
                                    Pending_Timesheets();
                                }
                            }
                        } else {
                            Pending_2Timesheets();
                        }
                        Blockloaderhide();
                    }
                },
                failure: function (response) {
                    showDangerAlert('Cant Connect to Server' + response.d);
                    Blockloaderhide();
                },
                error: function (response) {
                    showDangerAlert('Error Occoured ' + response.d);
                    Blockloaderhide();
                }
            });
        }

        function RejectTimesheet(TypeStatus) {
            Blockloadershow();
            var All_tsid = '';
            var r = '';
            var s = '';
            var billable = 0;
            $("input[name=chkclt]:checked").each(function () {
                var row = $(this).closest("tr");
                var t = '';
                billable = 0;

                if (row.find(".icon-checkmark2").length > 0) billable = 1;
                if ($("[id*=hdnDualApp]").val() == 'True') {
                    t = row.find("input[name=hdnStatus]").val();
                }
                else {
                    var etime = '00.00';
                    var t = row.find("input[name=hdnStatus]").val();

                    if (CompanyPermissions[0].Edit_Billing_Hrs == true) {
                        etime = row.find("input[id=txteditbillablehrs]").val();
                        var startTime = etime.replace(':', '.');
                        var firstHH = startTime.split('.')[0];
                        var firstMM = startTime.split('.')[1];
                        if (firstMM == undefined) {
                            firstMM = "0";
                        }

                        if (firstHH == undefined) {
                            firstHH = "0";
                        }

                        if (firstHH == "") {
                            firstHH = "0";
                        }
                        if (firstMM == "") {
                            firstMM = "0";
                        }

                        if (firstMM >= 60) {
                            var realmin = firstMM % 60;
                            var hours = Math.floor(firstMM / 60);
                            firstHH = parseFloat(firstHH) + parseFloat(hours);
                            firstMM = realmin;
                        }

                        if (firstMM < 10) {
                            if (parseFloat(firstMM.length) < 2) {
                                firstMM = firstMM + "0";
                            }
                        }

                        if (firstHH < 10) {
                            if (parseFloat(firstHH.length) < 2) {
                                firstHH = "0" + firstHH;
                            }
                        }
                        iTime = firstHH + '.' + firstMM;
                        etime = iTime;
                    }
                }
                if (t == 'Submitted' || t == 'Approved' || t == 'Semi Approved') {

                    var tid = $(this).val();
                    r = $("#hdnResn_tsid_" + tid).val();
                    s = 'Rejected';
                    All_tsid = $(this).val() + ',' + s + ',' + r + ',' + etime + ',' + billable + '^' + All_tsid;
                }
            });


            if (All_tsid != '') {
                Update_Reject_Approve(All_tsid, 'R', r, TypeStatus)
                var rows = All_tsid.split("^").map(function (row) {
                    return row.split(",")[0];
                });

                $("input[name=chkclt]:checked").each(function () {
                    var row = $(this).closest("tr");
                    var id = $(this).val();
                    if (id != '') {
                        var staffemail = row.find("#hdnstaffemail_" + id).val();
                        var reason = row.find("#hdnResn_tsid_" + id).val();
                        var custname = row.find("td").eq(3).text()
                        var tdate = row.find("td").eq(1).text()

                        var tempparams = {
                            subject: "Timesheet rejected",
                            to_name: custname,
                            reply_to: staffemail,
                            tdate: tdate,
                            reason: reason
                        };

                        emailjs.send("service_nbqwp3f", "template_i13jifl", tempparams)
                            .then(function (res) {
                                if (res.text != 'OK') {
                                    showWarningAlert('Mail not sent');
                                }
                            });
                    }
                });

            }
            else {
                showWarningAlert('Kindly Select atleast one record !!!');
                Blockloaderhide();
                return false;
            }
        }

        /// Save Reason
        function Savereason(r) {
            var t = $("[id*=htsid]").val();
            $("#hdnResn_tsid_" + t).val(r);
            showSuccessAlert('Reason Saved !!!');
            $('#modal_h3').modal('hide');
            $('#modalNarr2lvl').modal('hide');
            RejectTimesheet('StatusSubmitted');
        }

        function fillJobDrpdwn() {
            var cltid = $("[id*= drpclient3]").val();
            var cid;
            $("[id*=drpMjob3]").empty();
            $("[id*=drpMjob3]").append("<option value=0>--Activity--</option>");
            if (myProject.length > 0) {
                $.each(myProject, function () {
                    cid = $(this).find("CLTId").text();
                    if (cid == cltid) {
                        $("[id*=drpMjob3]").append("<option value='" + $(this).find("MJobId").text() + "'>" + $(this).find("MJobName").text() + "</option>");
                    }
                });
            }

        }

        function fillPrjDrpdwn() {
            var cltid = $("[id*= drpclient3]").val();
            var distSBU = [];
            var cid;
            $("[id*=drpProj]").empty();
            $("[id*=drpProj]").append("<option value=0>--Project--</option>");

            if (myProject.length > 0) {
                $.each(myProject, function () {
                    cid = $(this).find("CLTId").text();
                    if (cid == cltid) {
                        $("[id*=drpProj]").append("<option value='" + $(this).find("ProjectID").text() + "'>" + $(this).find("ProjectName").text() + "</option>");
                    }
                })
            }



        }


        function chkStatus() {
            status = $("[id*=drpstatus]").val();
            if (status == 'All') {
                $("[id*=hdnTSStatus]").val($("[id*=drpstatus]").val());
                $("[id*=lblTs]").html('All Timesheet');
                $("[id*=divAllTimesheet]").show();
                $("[id*=divPenidingTS]").hide();
                $("[id*=divStaffsum]").hide();
                $("[id*=divTSNotSub]").hide();
                $("[id*=divMinHrs]").hide();
                $("[id*=divFromdate]").show();
                $("[id*=divTodate]").show();
                $("[id*=divExcel]").show();
                $("[id*=divJobActvdrp]").show();
                $("[id*=divClintdrp]").show();
                $("[id*=divDept]").show();
                $("[id*=divNarration]").show();
                $("[id*=btnStatusAppr]").hide();
                $("[id*=btnStatusReject]").hide();
                $("[id*=chkApprovedAll]").hide();
                $("[id*=lblAppr]").hide();
                if ($("[id*=hdnPageLevel]").val() == '4') {
                    $("[id*=divtskdrp]").show();
                    $("[id*=divprjdrp]").show();
                } else if ($("[id*=hdnPageLevel]").val() == '3') {
                    $("[id*=divprjdrp]").show();
                }
                if ($("[id*=hdnPageLevel]").val() > 2) {
                    if ($("[id*=hdnDualApp]").val() == 'True') {
                        if ($("[id*=hdnEditStaffcode]").val() == 0) {
                            Bind_Timesheets();
                        } else {
                            DualAppBind_Timesheets();
                        }
                    } else {
                        Bind_Timesheets();
                    }
                } else {
                    Bind_TwoLTimesheet();
                }
            }
            else if (status == 'Approved') {
                $("[id*=hdnTSStatus]").val($("[id*=drpstatus]").val());
                $("[id*=lblTs]").html('Approved Timesheet');
                $("[id*=divAllTimesheet]").show();
                $("[id*=divPenidingTS]").hide();
                $("[id*=divStaffsum]").hide();
                $("[id*=divTSNotSub]").hide();
                $("[id*=divMinHrs]").hide();
                $("[id*=divFromdate]").show();
                $("[id*=divTodate]").show();
                $("[id*=divExcel]").show();
                $("[id*=divJobActvdrp]").show();
                $("[id*=divClintdrp]").show();
                $("[id*=divDept]").show();
                $("[id*=divNarration]").show();
                if ($("[id*=hdnPageLevel]").val() == '4') {
                    $("[id*=divtskdrp]").show();
                    $("[id*=divprjdrp]").show();
                } else if ($("[id*=hdnPageLevel]").val() == '3') {
                    $("[id*=divprjdrp]").show();
                }

                if ($("[id*=hdnPageLevel]").val() > 2) {
                    if ($("[id*=hdnDualApp]").val() == 'True') {
                        if ($("[id*=hdnEditStaffcode]").val() == 0) {
                            Bind_Timesheets();
                        } else {
                            DualAppBind_Timesheets();
                        }
                    } else {
                        Bind_Timesheets();
                    }

                } else {
                    Bind_TwoLTimesheet();
                }
            }
            else if (status == 'Submitted') {
                $("[id*=lblsts]").html('Approval Pending');
                $("[id*=divAllTimesheet]").hide();
                $("[id*=divPenidingTS]").show();
                $("[id*=divStaffsum]").hide();
                $("[id*=divTSNotSub]").hide();
                $("[id*=divMinHrs]").hide();
                $("[id*=divJobActvdrp]").show();
                $("[id*=divClintdrp]").show();
                $("[id*=divDept]").show();
                $("[id*=divFromdate]").show();
                $("[id*=divTodate]").show();
                $("[id*=divNarration]").show();
                $("[id*=divExcel]").hide();
                if ($("[id*=hdnPageLevel]").val() == '4') {
                    $("[id*=divtskdrp]").show();
                    $("[id*=divprjdrp]").show();
                } else if ($("[id*=hdnPageLevel]").val() == '3') {
                    $("[id*=divprjdrp]").show();
                }
                if ($("[id*=hdnPageLevel]").val() > 2) {
                    if ($("[id*=hdnDualApp]").val() == 'True') {
                        if ($("[id*=hdnEditStaffcode]").val() == 0) {
                            Pending_Timesheets();
                        } else {
                            ///3 level Dual Approver
                            PendDualAppBind_Timesheets();
                        }
                    } else {
                        Pending_Timesheets();
                    }
                } else {
                    // 2level Approver/Approver can edit timesheet
                    Pending_2Timesheets();
                }
            }
            else if (status == 'StaffSumm') {
                $("[id*=divAllTimesheet]").hide();
                $("[id*=divPenidingTS]").hide();
                $("[id*=divStaffsum]").show();
                $("[id*=divTSNotSub]").hide();
                $("[id*=divMinHrs]").hide();
                $("[id*=divJobActvdrp]").hide();
                $("[id*=divClintdrp]").hide();
                $("[id*=divDept]").hide();
                $("[id*=divNarration]").hide();
                $("[id*=divprjdrp]").hide();
                $("[id*=divtskdrp]").hide();
                $("[id*=divFromdate]").hide();
                $("[id*=divTodate]").hide();
                $("[id*=divExcel]").hide();
                StaffsummaryData();
            } else if (status == 'TSNotSubmited') {
                $("[id*=divAllTimesheet]").hide();
                $("[id*=divPenidingTS]").hide();
                $("[id*=divStaffsum]").hide();
                $("[id*=divTSNotSub]").show();
                $("[id*=divMinHrs]").hide();
                $("[id*=divJobActvdrp]").hide();
                $("[id*=divClintdrp]").hide();
                $("[id*=divDept]").hide();
                $("[id*=divNarration]").hide();
                $("[id*=divprjdrp]").hide();
                $("[id*=divtskdrp]").hide();
                $("[id*=divFromdate]").hide();
                $("[id*=divTodate]").hide();
                $("[id*=divExcel]").hide();
                TSNotSubData();
            }
            else if (status == 'MiniHrs') {
                $("[id*=divAllTimesheet]").hide();
                $("[id*=divPenidingTS]").hide();
                $("[id*=divStaffsum]").hide();
                $("[id*=divTSNotSub]").hide();
                $("[id*=divMinHrs]").show();
                $("[id*=divJobActvdrp]").hide();
                $("[id*=divClintdrp]").hide();
                $("[id*=divDept]").hide();
                $("[id*=divprjdrp]").hide();
                $("[id*=divtskdrp]").hide();
                $("[id*=divNarration]").hide();
                $("[id*=divFromdate]").hide();
                $("[id*=divTodate]").hide();
                $("[id*=divExcel]").hide();
                MinimumHoours();
            }
            else if (status == 'Rejected') {
                $("[id*=lblsts]").html('Rejected Timesheet');
                $("[id*=divAllTimesheet]").hide();
                $("[id*=divPenidingTS]").show();
                $("[id*=divStaffsum]").hide();
                $("[id*=divTSNotSub]").hide();
                $("[id*=divMinHrs]").hide();
                $("[id*=divJobActvdrp]").show();
                $("[id*=divClintdrp]").show();
                $("[id*=divDept]").show();
                $("[id*=divFromdate]").show();
                $("[id*=divTodate]").show();
                $("[id*=divNarration]").show();
                $("[id*=divExcel]").hide();
                if ($("[id*=hdnPageLevel]").val() == '4') {
                    $("[id*=divtskdrp]").show();
                    $("[id*=divprjdrp]").show();
                } else if ($("[id*=hdnPageLevel]").val() == '3') {
                    $("[id*=divprjdrp]").show();
                }
                if ($("[id*=hdnPageLevel]").val() > 2) {
                    if ($("[id*=hdnDualApp]").val() == 'True') {
                        if ($("[id*=hdnEditStaffcode]").val() == 0) {
                            Pending_Timesheets();
                        } else {
                            ///3 level Dual Approver
                            PendDualAppBind_Timesheets();
                        }
                    } else {
                        Pending_Timesheets();
                    }
                } else {
                    // 2level Approver/Approver can edit timesheet
                    Pending_2Timesheets();
                }
            }
        }

        function TSNotSubData() {
            Blockloadershow();
            //var Compid = $("[id*=hdnCompanyid]").val();
            var Start = $("[id*=txtdateBindStaff]").val().split('-')[0];
            var end = $("[id*=txtdateBindStaff]").val().split('-')[1];
            var Staffcode = $("[id*=hdnEditStaffcode]").val();
            var Staffrole = $("[id*=hdnRolename]").val();
            var sid = $("[id*=drpstaff3]").val();
            if (sid == null) {
                sid = 0;
            }
            var wk = $("[id*=hdnwk]").val();
            var mmdd = CompanyPermissions[0].mmddyyyy;
            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/bind_Approver_TimesheetNotSubmitted",
                data: '{Start:"' + Start + '",end:"' + end + '",staffcode:' + Staffcode + ',sid:' + sid + ',Staffrole:"' + Staffrole + '",wk:"' + wk + '",pageIndex:' + $("[id*=hdnPages]").val() + ',pageSize:' + $("[id*=hdnSize]").val() + ', mmdd:' + mmdd + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tbl = "";
                    var ii = 1;
                    var RecordCount = 0;
                    $("[id*=tblTSNotSub] tbody").empty();
                    $("[id*=tblTSNotSub] thead").empty();
                    $("[id*=tblTSNotSub] tr").remove();

                    if (myList == null) {
                    } else {

                        tbl = tbl + "<thead><tr>";
                        tbl = tbl + "<th ></th>";
                        tbl = tbl + "<th>" + myList[0].Staffname + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[0].d1 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[0].d2 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[0].d3 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[0].d4 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[0].d5 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[0].d6 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[0].d7 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>Actual</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>Week</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>Send</th>";
                        tbl = tbl + "</tr></thead>";

                        $("[id*=tblTSNotSub]").append(tbl);
                        tbl = '';
                        tbl = tbl + "<thead><tr>";
                        tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
                        tbl = tbl + "<th style='font-weight: bold;'>Staff Name</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[1].d1 + "<input type='hidden' id='hdnD1' value='" + myList[1].d1 + "' name='hdnD1'></th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[1].d2 + "<input type='hidden' id='hdnD2' value='" + myList[1].d2 + "' name='hdnD2'></th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[1].d3 + "<input type='hidden' id='hdnD3' value='" + myList[1].d3 + "' name='hdnD3'></th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[1].d4 + "<input type='hidden' id='hdnD4' value='" + myList[1].d4 + "' name='hdnD4'></th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[1].d5 + "<input type='hidden' id='hdnD5' value='" + myList[1].d5 + "' name='hdnD5'></th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[1].d6 + "<input type='hidden' id='hdnD6' value='" + myList[1].d6 + "' name='hdnD6'></th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>" + myList[1].d7 + "<input type='hidden' id='hdnD7' value='" + myList[1].d7 + "' name='hdnD7'></th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>Total</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: left;'>Total</th>";
                        tbl = tbl + "<th style='font-weight: bold;text-align: left;'></th>";
                        tbl = tbl + "</tr></thead>";
                        $("[id*=tblTSNotSub]").append(tbl);

                        tbl = '';

                        if (myList.length > 2) {
                            for (var i = 2; i < myList.length; i++) {
                                tbl = tbl + "<tr>";
                                if (i == 2) {
                                    RecordCount = parseInt(myList[i].TotalCount) - i;
                                }
                                tbl = tbl + "<td >" + myList[i].SlNo + "<input type='hidden' id='hdnTSNotstaffcode' value='" + myList[i].staffcode + "' name='hdnTSNotstaffcode'><input type='hidden' id='hdnstaffemail' value='" + myList[i].staffemail + "' name='hdnstaffemail'></td>";
                                tbl = tbl + "<td style='width:12%;'>" + myList[i].Staffname + "</td>";
                                tbl = tbl + "<td style='width: auto; text-align: left;'>" + myList[i].d1 + "</td>";
                                tbl = tbl + "<td style='width: auto; text-align: left;'>" + myList[i].d2 + "</td>";
                                tbl = tbl + "<td style='width: auto; text-align: left;'>" + myList[i].d3 + "</td>";
                                tbl = tbl + "<td style='width: auto; text-align: left;'>" + myList[i].d4 + "</td>";
                                tbl = tbl + "<td style='width: auto; text-align: left;'>" + myList[i].d5 + "</td>";
                                tbl = tbl + "<td style='width: auto; text-align: left;'>" + myList[i].d6 + "</td>";
                                tbl = tbl + "<td style='width: auto; text-align: left;'>" + myList[i].d7 + "</td>";
                                tbl = tbl + "<td style='width: auto; text-align: left;'>" + myList[i].Total + "</td>";
                                tbl = tbl + "<td style='width: auto; text-align: left;'>" + myList[i].srno + "</td>";
                                tbl = tbl + "<td style='text-align: left;'><input id='btnWarning' name='btnWarning' type='button' value='Wrng' onclick='Send_Warning($(this))' class='btn btn-outline-warning rounded-round legitRipple' style='color:black;'></td>";
                                tbl = tbl + "</tr>";
                                ii = parseInt(ii) + 1;
                            }
                            $("[id*=tblTSNotSub]").append(tbl);
                            Pager(RecordCount);
                            if (RecordCount >= minPageSize) {
                                Pager(RecordCount);
                                $("#divPageSize_Timesheetnotsubmitted").css({ 'display': 'block' });
                                $("[id*=tblPager_TSNotSub]").show();
                            }
                            else {
                                Pager(0);
                                $("[id*=divPageSize_Timesheetnotsubmitted]").hide();
                                $("[id*=tblPager_TSNotSub]").hide();
                            }
                            Blockloaderhide();
                        } else {
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "</tr>";
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td colspan='13' style='text-align:center;'>No Record Found !!!</td>";
                            tbl = tbl + "</tr>";
                            $("[id*=tblTSNotSub]").append(tbl);
                            Pager(0);
                            $("[id*=tblPager_TSNotSub]").hide();
                            Blockloaderhide();
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

        function Send_Warning(i) {
            var row = i.closest("tr");
            var staffemail = row.find("input[name=hdnstaffemail]").val();
            var frtime = $("[id*=txtdateBindStaff]").val().split('-')[0];
            var totime = $("[id*=txtdateBindStaff]").val().split('-')[1];
            var custname = $("td", row.closest("tr")).eq(1).html();
            Blockloadershow();

            var tempparams = {
                to_name: custname,
                fromdate: frtime,
                Todate: totime,
                reply_to: staffemail,
                D1: $("[id*=hdnD1]").val(),
                D2: $("[id*=hdnD2]").val(),
                D3: $("[id*=hdnD3]").val(),
                D4: $("[id*=hdnD4]").val(),
                D5: $("[id*=hdnD5]").val(),
                D6: $("[id*=hdnD6]").val(),
                D7: $("[id*=hdnD7]").val(),
                TimeD1: $("td", row.closest("tr")).eq(2).html(),
                TimeD2: $("td", row.closest("tr")).eq(3).html(),
                TimeD3: $("td", row.closest("tr")).eq(4).html(),
                TimeD4: $("td", row.closest("tr")).eq(5).html(),
                TimeD5: $("td", row.closest("tr")).eq(6).html(),
                TimeD6: $("td", row.closest("tr")).eq(7).html(),
                TimeD7: $("td", row.closest("tr")).eq(8).html(),
            }

            emailjs.send("service_nbqwp3f", "template_tktyh4s", tempparams)
                .then(function (res) {
                    if (res.text == 'OK') {
                        Blockloaderhide();
                        showSuccessAlert('Warning send successfully!!!');
                        row.find("input[name=btnWarning]").attr("disabled", true);
                    } else {
                        Blockloaderhide();
                        showWarningAlert('Mail not send');
                    }
                });
        }

        function MinimumHoours() {
            Blockloadershow();

            //var Compid = $("[id*=hdnCompanyid]").val();
            var from = $("[id*=hdnFromdate]").val();
            var To = $("[id*=hdnTodate]").val();
            var Staffrole = $("[id*=hdnRolename]").val();
            var sid = $("[id*=drpstaff3]").val();
            var PageLevel = $("[id*=hdnPageLevel]").val();
            var SuperAppr = $("[id*=hdnSuperAppr]").val();
            var SubAppr = $("[id*=hdnSubAppr]").val();
            var Staffcode = $("[id*=hdnEditStaffcode]").val();

            if (sid == null || sid == '') {
                sid = 0;
            }
            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/bind_MinimumHrs",
                data: '{Start:"' + from + '",end:"' + To + '",staffcode:' + Staffcode + ',staff_role:"' + Staffrole + '",sid:' + sid + ',PageLevel:' + PageLevel + ',SuperAppr:"' + SuperAppr + '",SubAppr:"' + SubAppr + '",pageIndex:' + $("[id*=hdnPages]").val() + ',pageSize:' + $("[id*=hdnSize]").val() + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tbl = "";
                    var RecordCount = 0;
                    $("[id*=tblMinHrs] thead").empty();
                    $("[id*=tblMinHrs] tbody").empty();

                    tbl = tbl + "<thead><tr>";
                    tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
                    tbl = tbl + "<th style='font-weight: bold; text-align: left;' class='labelChange'>Staff </th>";
                    tbl = tbl + "<th style='font-weight: bold; text-align: left;' class='labelChange'>Department </th>";
                    tbl = tbl + "<th style='font-weight: bold; text-align: left;'class='labelChange'>Designation </th>";
                    tbl = tbl + "<th style='font-weight: bold; text-align: left;' class='labelChange'>Date</th>";
                    tbl = tbl + "<th style='font-weight: bold; text-align: left;'>Min Hours</th>";
                    tbl = tbl + "<th style='font-weight: bold; text-align: left;'>Total Time</th>";
                    tbl = tbl + "<th style='font-weight: bold; text-align: left;'>Diff</th>";
                    tbl = tbl + "</tr></thead>";

                    if (myList == null) {
                    }
                    else {
                        if (myList.length > 0) {
                            for (var i = 0; i < myList.length; i++) {
                                if (i == 0) {
                                    RecordCount = myList[i].TotalCount;
                                }
                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td style='width:5%;' >" + myList[i].SlNo + "</td>";
                                tbl = tbl + "<td style='width:15%; text-align: left;'>" + myList[i].Staffname + "</td>";
                                tbl = tbl + "<td style='width:10%; text-align: left;'>" + myList[i].Deptname + "</td>";
                                tbl = tbl + "<td style='width:10%; text-align: left;'>" + myList[i].DesignName + "</td>";
                                tbl = tbl + "<td style='width:10%; text-align: left;'>" + myList[i].Tdate + "</td>";
                                tbl = tbl + "<td style='width: 10%; text-align: left;'>" + myList[i].hors + "</td>";
                                tbl = tbl + "<td style='width: 10%; text-align: left;'>" + myList[i].totaltm + "</td>";
                                tbl = tbl + "<td style='width: 10%; text-align: left;'>" + myList[i].diff + "</td>";
                                tbl = tbl + "</tr>";
                            }
                            $("[id*=tblMinHrs]").append(tbl);
                            Pager(RecordCount);
                            if (RecordCount >= 25) {
                                Pager(RecordCount);
                                $("#divPageSize_MinHrs").css({ 'display': 'block' });
                                $("[id*=tblPager_MinHrs]").show();
                            }
                            else {
                                Pager(0);
                                $("[id*=divPageSize_MinHrs]").hide();
                                $("[id*=tblPager_MinHrs]").hide();
                            }
                            Blockloaderhide();
                        }
                        else {
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td >Record not found !!!</td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td style=width: auto' align='center'></td>";
                            tbl = tbl + "<td style=width: auto' align='center'></td>";
                            tbl = tbl + "<td style=width: auto' align='center'></td>";
                            tbl = tbl + "</tr>";
                            $("[id*=tblMinHrs]").append(tbl);
                            Pager(0);
                            $("[id*=tblPager_MinHrs]").hide();
                            Blockloaderhide();
                        }
                    }
                },
                failure: function (response) {
                    showDangerAlert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    showDangerAlert('Error Occoured ' + response.d);
                }
            });
        }

        function StaffsummaryData() {
            Blockloadershow();
            //var Compid = $("[id*=hdnCompanyid]").val();
            var Start = $("[id*=txtdateBindStaff]").val().split('-')[0];
            var end = $("[id*=txtdateBindStaff]").val().split('-')[1];
            var Staffcode = $("[id*=hdnEditStaffcode]").val();
            var Staffrole = $("[id*=hdnRolename]").val();
            var sid = $("[id*=drpstaff3]").val();
            if (sid == null) {
                sid = 0;
            }
            var PageLevel = $("[id*=hdnPageLevel]").val();
            var SuperAppr = $("[id*=hdnSuperAppr]").val();
            var SubAppr = $("[id*=hdnSubAppr]").val();
            var mmdd = CompanyPermissions[0].mmddyyyy;
            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/bind_StaffsummaryData",
                data: '{Start:"' + Start + '",end:"' + end + '",staffcode:' + Staffcode + ',sid:' + sid + ',Staffrole:"' + Staffrole + '",PageLevel:' + PageLevel + ',SuperAppr:"' + SuperAppr + '",SubAppr:"' + SubAppr + '",pageIndex:' + $("[id*=hdnPages]").val() + ',pageSize:' + $("[id*=hdnSize]").val() + ',mmdd: ' + mmdd + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tbl = "";
                    var ii = 1;
                    var RecordCount = 0;
                    $("[id*=tblStaffSummary] tbody").empty();
                    $("[id*=tblStaffSummary] thead").empty();
                    $("[id*=tblStaffSummary] tr").remove();
                    if (myList == null) {
                    } else {

                        tbl = tbl + "<thead><tr>";
                        tbl = tbl + "<th ></th>";
                        tbl = tbl + "<th>" + myList[0].Staffname + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[0].d1 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[0].d2 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[0].d3 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[0].d4 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[0].d5 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[0].d6 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[0].d7 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[0].Total + "</th>";
                        tbl = tbl + "</tr></thead>";

                        $("[id*=tblStaffSummary]").append(tbl);
                        tbl = '';
                        tbl = tbl + "<thead ><tr>";
                        tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
                        tbl = tbl + "<th style='font-weight: bold;'>Staff Name</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[1].d1 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[1].d2 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[1].d3 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[1].d4 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[1].d5 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[1].d6 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center;'>" + myList[1].d7 + "</th>";
                        tbl = tbl + "<th style='font-weight: bold; text-align: center; '>Total</th>";
                        tbl = tbl + "</tr></thead>";
                        $("[id*=tblStaffSummary]").append(tbl);

                        tbl = '';

                        if (myList.length > 3) {
                            for (var i = 2; i < myList.length; i++) {
                                tbl = tbl + "<tr>";
                                if (myList[i].Staffname == 'Total') {
                                    tbl = tbl + "<td ></td>";
                                } else {
                                    tbl = tbl + "<td >" + myList[i].SrNo + "</td>";
                                }

                                if (i == 2) {
                                    RecordCount = parseInt(myList[i].TotalCount) - i;
                                }
                                tbl = tbl + "<td style='width:15%;'>" + myList[i].Staffname + "</td>";
                                tbl = tbl + "<td style='width:auto; text-align:center'>" + myList[i].d1 + "</td>";
                                tbl = tbl + "<td style='width:auto; text-align:center'>" + myList[i].d2 + "</td>";
                                tbl = tbl + "<td style='width:auto; text-align:center'>" + myList[i].d3 + "</td>";
                                tbl = tbl + "<td style='width:auto; text-align:center'>" + myList[i].d4 + "</td>";
                                tbl = tbl + "<td style='width:auto; text-align:center'>" + myList[i].d5 + "</td>";
                                tbl = tbl + "<td style='width:auto; text-align:center'>" + myList[i].d6 + "</td>";
                                tbl = tbl + "<td style='width:auto; text-align:center'>" + myList[i].d7 + "</td>";
                                tbl = tbl + "<td style='width:auto; text-align:center''>" + myList[i].Total + "</td>";
                                tbl = tbl + "</tr>";
                                ii = parseInt(ii) + 1;
                            }
                            $("[id*=tblStaffSummary]").append(tbl);
                            Pager(RecordCount);
                            if (RecordCount >= minPageSize) {
                                Pager(RecordCount);
                                $("#divPageSize_StaffSummary").css({ 'display': 'block' });
                                $("[id*=tblPager_StaffSummary]").show();
                            }
                            else {
                                Pager(0);
                                $("[id*=divPageSize_StaffSummary]").hide();
                                $("[id*=tblPager_StaffSummary]").hide();
                            }
                            Blockloaderhide();
                        } else {
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "</tr>";
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td colspan='13' style='text-align:center;'>No Record Found !!!</td>";
                            tbl = tbl + "</tr>";
                            $("[id*=tblStaffSummary]").append(tbl);
                            Pager(0);
                            $("[id*=tblPager_StaffSummary]").hide();
                            Blockloaderhide();
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

        /// 3level dual Approver
        function PendDualAppBind_Timesheets() {
            Blockloadershow();
            //var compid = $("[id*=hdnCompanyid]").val();
            var muti = $("[id*=hdnPageLevel]").val();
            var cltid = $("[id*=drpclient3]").val();
            var projectid = $("[id*=drpProj]").val();
            var mjobid = $("[id*=drpMjob3]").val();
            var Sid = $("[id*=drpstaff3]").val();
            var frtime = $("[id*=txtdateBindStaff]").val().split('-')[0];
            var totime = $("[id*=txtdateBindStaff]").val().split('-')[1];
            var status = $("[id*=drpstatus]").val();
            var deptId = $("[id*=ddlDept]").val();
            var Staffcode = $("[id*=hdnEditStaffcode]").val();
            var Staffrole = $("[id*=hdnRolename]").val();
            var task = 0;
            if ($("[id*=hdnPageLevel]").val() == '4') {
                task = $("[id*=drpTask]").val();
            }
            var mmdd = CompanyPermissions[0].mmddyyyy;
            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/getDualApproverTimesheets",
                data: '{cltid:"' + cltid + '",projectid:"' + projectid + '",mjobid:"' + mjobid + '",staffcode:"' + Staffcode + '",frtime:"' + frtime + '",totime:"' + totime + '",status:"' + status + '",muti:' + muti + ',task:"' + task + '",Sid:' + Sid + ',Staffrole:"' + Staffrole + '",deptId:"' + deptId + '",pageIndex:' + $("[id*=hdnPages]").val() + ',pageSize:' + $("[id*=hdnSize]").val() + ',mmdd: ' + mmdd + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var RecordCount = 0;
                    var tbl = '';
                    $("[id*=tbl_PendingTS] tbody").empty();
                    $("[id*=tbl_PendingTS] thead").empty();

                    tbl = tbl + "<thead><tr>";
                    tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Date</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Staff</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Project</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Activity</th>";
                    if ($("[id*=hdnPageLevel]").val() > 3) {

                        tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Task</th>";
                    }

                    tbl = tbl + "<th style='font-weight: bold;'>Time</th>";
                    if (CompanyPermissions[0].Edit_Billing_Hrs == true) {
                        tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Edit Hrs</th>";
                    }

                    tbl = tbl + "<th style='font-weight: bold;' id='thNarrationIcon' class='chkShowNarrationIcon'>Narration</th>";
                    tbl = tbl + "<th style='font-weight: bold;' id='thNarrationMessage' class='chkShowNarrationMessage'>Narration</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Billable</th>";
                    if ($("[id*=hdnExpense]").val() == 'True') {
                        tbl = tbl + "<th style='font-weight: bold;'>Exp</th>";
                    }
                    tbl = tbl + "<th style='font-weight: bold;'>Status</th>";
                    if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {

                    } else {
                        tbl = tbl + "<th style='font-weight: bold;'>Reason</th>";
                    }

                    tbl = tbl + "</tr></thead>";
                    //  $("[id*=tbl_AllTimesheet]").append(tbl);
                    if (myList.length > 0) {

                        var sc = myList.length;

                        for (var i = 0; i < myList.length; i++) {
                            if (i == 0) {
                                RecordCount = myList[i].TotalCount;
                            }
                            if (myList[i].MJobName == 'Total') {
                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td style='text-align: left;font-weight: bold;'>" + myList[i].MJobName + "</td>";
                                if ($("[id*=hdnPageLevel]").val() > 3) {
                                    tbl = tbl + "<td></td>";
                                }
                                tbl = tbl + "<td style='text-align: left;font-weight: bold;'>" + myList[i].TotalTime + "</td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                if ($("[id*=hdnExpense]").val() == 'True') {
                                    tbl = tbl + "<td></td>";
                                }
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "</tr>";
                            } else {


                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td style='text-align: center;'>" + myList[i].Srno + "<input type='hidden' id='hdnATSid' value='" + myList[i].TSId + "' name='hdnATSid'></td>";
                                tbl = tbl + "<td style='text-align: left;'>" + myList[i].FromDT + "</td>";
                                tbl = tbl + "<td style='text-align: left;'>" + myList[i].StaffName + "</td>";
                                tbl = tbl + "<td style='text-align: left;'>" + myList[i].ProjectName + "</td>";
                                tbl = tbl + "<td style='text-align: left;'>" + myList[i].MJobName + "</td>";
                                if ($("[id*=hdnPageLevel]").val() > 3) {
                                    tbl = tbl + "<td style='text-align: left;'>" + myList[i].TaskName + "</td>";
                                }

                                tbl = tbl + "<td style='text-align: left;'>" + myList[i].TotalTime + "</td>";
                                if (CompanyPermissions[0].Edit_Billing_Hrs == true) {
                                    if (myList[i].Billable == true) {
                                        tbl = tbl + "<td style='width: 70px;'><input type='text' id='txteditbillablehrs' class='form-control' name='txteditbillablehrs' style='width: 70px;'    onblur='ShowBlur($(this))' value='" + myList[i].Edit_Billing_Hrs + "'> </td> ";
                                    } else {
                                        tbl = tbl + "<td style='width: 70px;'><input type='text' id='txteditbillablehrs' class='form-control' name='txteditbillablehrs' style='width: 70px;'    onblur='ShowBlur($(this))' value='" + myList[i].Edit_Billing_Hrs + "' disabled> </td> ";
                                    }
                                }

                                if (myList[i].Narration == '') {
                                    tbl = tbl + "<td style='text-align: center; class='chkShowNarrationIcon'><i class='icon-bubble9 mr-1'></i></td>";
                                } else {
                                    tbl = tbl + "<td style='text-align: center;cursor: pointer;' class='chkShowNarrationIcon'><i class='icon-bubble-lines4 mr-1 ' onclick='OpenNarration($(this))' data-toggle='modal' data-target='#modal_h3' ></i><input type='hidden' id='hdnNarr' value='" + myList[i].Narration + "' name='hdnNarr'></td>";
                                    // tbl = tbl + "<td style='text-align: left;'>" + myLisChkboxNarrationMsgt[i].Narration + "</td>";
                                }
                                tbl = tbl + "<td style='text-align: left;' id='tdNarrationMessage' class='chkShowNarrationMessage'>" + $(this).find("Narration").text() + "</td>";

                                //var bill = 'No';
                                if (myList[i].Billable == true) {
                                    tbl = tbl + "<td style='text-align: center;cursor: pointer;'> <i class='icon-checkmark2 mr-3 icon-2x' style='color: green;' ></i></td>";
                                    //bill = 'Yes';
                                } else {
                                    tbl = tbl + "<td style='text-align: center;cursor: pointer;'> <i class='icon-cross3 mr-3 icon-2x' style='color: red;' ></i></td>";
                                }

                                if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                                    if (myList[i].Status == 'Submitted') {
                                        tbl = tbl + "<td style='text-align: left;color: orange; font-weight: bold;'>" + myList[i].Status + "</td>";
                                    }
                                    else if (myList[i].Status == 'Saved') {
                                        tbl = tbl + "<td style='text-align: left;color: SkyBlue; font-weight: bold;'>" + myList[i].Status + "</td>";
                                    }
                                    else if (myList[i].Status == 'Approved') {
                                        tbl = tbl + "<td style='text-align: left;color: LimeGreen; font-weight: bold;'>" + myList[i].Status + "</td>";
                                    }
                                    else if (myList[i].Status == 'Rejected') {
                                        tbl = tbl + "<td style='text-align: left;color: IndianRed; font-weight: bold;'>" + myList[i].Status + "</td>";
                                    }
                                    else if (myList[i].Status == 'Semi Approved') {
                                        tbl = tbl + "<td style='text-align: left;color: Yellow; font-weight: bold;'>" + myList[i].Status + "</td>";
                                    }
                                }
                                else {
                                    tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + myList[i].Status + "' /><input type='hidden' id='hdnaP' name='hdnaP' value='" + myList[i].APattern + "' /><input type='checkbox' class='Chkbox' id='chkclt'  name='chkclt' value='" + myList[i].TSId + "' /></td>";
                                    tbl = tbl + "<td style='text-align: center;'> <i class='icon-compose mr-2 ' data-toggle='modal' data-target='#modal_h3' onclick='OpenReason($(this))' style='cursor: pointer;'></i><input type='hidden' id='hdnResn_tsid_" + myList[i].TSId + "' name='hdnResn_tsid_" + myList[i].TSId + "' value='' ></td>";
                                }
                                tbl = tbl + "</tr>";
                            }
                        };
                        $("[id*=tbl_PendingTS]").append(tbl);
                        Pager(RecordCount);
                        if (RecordCount >= minPageSize) {
                            Pager(RecordCount);
                            $("#divPageSize_Pending").css({ 'display': 'block' });
                            $("[id*=tblPager_Pending]").show();
                        }
                        else {
                            Pager(0);
                            $("[id*=divPageSize_Pending]").hide();
                            $("[id*=tblPager_Pending]").hide();
                        }
                        Blockloaderhide();
                    } else {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        if ($("[id*=hdnPageLevel]").val() > 3) {
                            tbl = tbl + "<td></td>";
                        }
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        if ($("[id*=hdnExpense]").val() == 'True') {
                            tbl = tbl + "<td></td>";
                        }
                        tbl = tbl + "</tr>";
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td colspan='13' style='text-align:center;'>No Record Found !!!</td>";
                        tbl = tbl + "</tr>";
                        $("[id*=tbl_PendingTS]").append(tbl);
                        Pager(0);
                        $("[id*=tblPager_Pending]").hide();
                        Blockloaderhide();
                    }

                    $("#chkShowNarrationMessage:not(:checked)").each(function () {
                        var column = "table ." + $(this).attr("name");
                        $(column).hide();
                    });
                },
                failure: function (response) {
                    showDangerAlert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    showDangerAlert('Error Occoured ' + response.d);
                }
            });
        }

        ///3/4 Approver grid
        function Pending_Timesheets() {
            Blockloadershow();
            var selectstatus = $("[id*=drpstatus]").val();
            //var compid = $("[id*=hdnCompanyid]").val();
            var muti = $("[id*=hdnPageLevel]").val();
            var cltid = $("[id*=drpclient3]").val();
            var deptId = $("[id*=ddlDept]").val();
            var projectid = $("[id*=drpProj]").val();
            var mjobid = $("[id*=drpMjob3]").val();
            var Sid = $("[id*=drpstaff3]").val();
            var frtime = $("[id*=hdnFromdate]").val();
            var totime = $("[id*=hdnTodate]").val();
            var status = $("[id*=drpstatus]").val();
            var Staffcode = $("[id*=hdnEditStaffcode]").val();
            var Staffrole = $("[id*=hdnRolename]").val();
            var ChckMyTS = $("[id*=chkMy]").is(':checked');
            var task = 0;
            if ($("[id*=hdnPageLevel]").val() == '4') {
                task = $("[id*=drpTask]").val();
            }
            if (deptId == null) {
                deptId = 0;
            }
            var mmdd = CompanyPermissions[0].mmddyyyy;
            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/bind_timesheets",
                data: '{cltid:"' + cltid + '",projectid:"' + projectid + '",mjobid:"' + mjobid + '",staffcode:"' + Staffcode + '",frtime:"' + frtime + '",totime:"' + totime + '",status:"' + status + '",muti:' + muti + ',task:"' + task + '",Sid:' + Sid + ',Staffrole:"' + Staffrole + '",ChckMyTS:"' + ChckMyTS + '",deptId:"' + deptId + '",pageIndex:' + $("[id*=hdnPages]").val() + ',pageSize:' + $("[id*=hdnSize]").val() + ', mmdd: ' + mmdd + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var xmlDoc = $.parseXML(msg.d);
                    var xml = $(xmlDoc);
                    var myList = xml.find("Table");
                    var RecordCount = 0;

                    var tbl = '';
                    $("[id*=tbl_PendingTS] tbody").empty();
                    $("[id*=tbl_PendingTS] thead").empty();

                    tbl = tbl + "<thead><tr>";
                    tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Date</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Submit Date</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Staff</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Project</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Activity</th>";
                    if ($("[id*=hdnPageLevel]").val() > 3) {

                        tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Task</th>";
                    }

                    tbl = tbl + "<th style='font-weight: bold;'>Time</th>";
                    if (CompanyPermissions[0].Edit_Billing_Hrs == true) {
                        tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Edit Hrs</th>";
                    }
                    tbl = tbl + "<th style='font-weight: bold;' id='thNarrationIcon' class='chkShowNarrationIcon'>Narration</th>";
                    tbl = tbl + "<th style='font-weight: bold;' id='thNarrationMessage' class='chkShowNarrationMessage'>Narration</th>";

                    tbl = tbl + "<th style='font-weight: bold;'>Billable</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Status</th>";
                    if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                    } else {
                        if ($("[id*=chkMy]").is(':checked') != true) {
                            tbl = tbl + "<th style='font-weight: bold;'>Reason</th>";
                        }
                    }
                    if ($("[id*=hdnRolename]").val() == 'Staff' || $("[id*=hdnRolename]").val() == 'Approver') {
                        if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                            if ($("[id*=hdnRolename]").val() == 'Approver' && ChckMyTS == true) {
                                tbl = tbl + "<th style='font-weight: bold;'>Actions</th>";
                            }
                            else if ($("[id*=hdnRolename]").val() == 'Staff') {
                                tbl = tbl + "<th style='font-weight: bold;'>Actions</th>";
                            }
                        }
                    }

                    tbl = tbl + "</tr></thead>";
                    if (myList.length > 0) {
                        $.each(myList, function (i, va) {
                            var p = $(this);
                            if (i == 0) {
                                RecordCount = $(this).find("TotalCount").text();
                            }
                            if ($(this).find("MJobName").text() == 'Total') {
                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td style='text-align: left;font-weight: bold;'>" + $(this).find("MJobName").text() + "</td>";
                                if ($("[id*=hdnPageLevel]").val() > 3) {
                                    tbl = tbl + "<td></td>";
                                }
                                tbl = tbl + "<td style='text-align: left;font-weight: bold;'>" + $(this).find("TotalTime").text() + "</td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                if ($("[id*=hdnExpense]").val() == 'True') {
                                    tbl = tbl + "<td></td>";
                                }
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "</tr>";
                            } else {
                                var tsid = $(this).find("TSID").text();

                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td style='text-align: center;'>" + $(this).find("SrNo").text() + "<input type='hidden' id='hdnATSid' value='" + $(this).find("TSID").text() + "' name='hdnATSid'></td>";
                                if (CompanyPermissions[0].mmddyyyy == 0) {
                                    tbl = tbl + "<td style='text-align: left;'>" + $(this).find("Date").text() + "&nbsp;&nbsp;<div class='text-center'>" + getDayName($(this).find("Date").text()) + "</div> <input type='hidden' id='hdnstaffemail_" + tsid + "' value='" + $(this).find("StaffEmail").text() + "' ></td>";
                                    tbl = tbl + "<td style='text-align: left;'>" + $(this).find("Submitted_Date").text() + "</td>";
                                }
                                else {
                                    var year;
                                    var month;
                                    var day;
                                    var dt = $(this).find("Date").text();
                                    dt = dt.split('/');
                                    year = dt[2], month = dt[1], day = dt[0];
                                    dt = month + '/' + day + '/' + year;
                                    //dt = moment(dt).format('MM/DD/YYYY')
                                    tbl = tbl + "<td style='text-align: left;'>" + dt + "<div class='text-center'>" + getDayName($(this).find("Date").text()) + "</div></td>";
                                    dt = $(this).find("Submitted_Date").text();
                                    dt = dt.split('/');
                                    year = dt[2], month = dt[1], day = dt[0];
                                    dt = month + '/' + day + '/' + year;
                                    tbl = tbl + "<td style='text-align: left;'>" + dt + "</td>";
                                }

                                tbl = tbl + "<td style='text-align: left;'>" + $(this).find("StaffName").text() + "<input type='hidden' id='hdnTStaffCode' value='" + $(this).find("staffCode").text() + "' name='hdnTStaffCode'><input type='hidden' id='hdnEditClientId' name='hdnEditClientId' value='" + $(this).find("CLTId").text() + "'/><input type='hidden' id='hdnJid' name='hdnJid' value='" + $(this).find("JobId").text() + "'/></td>";
                                tbl = tbl + "<td style='text-align: left;'>" + $(this).find("ProjectName").text() + "<input type='hidden' id='hdnClient' value='" + $(this).find("ClientName").text() + "' name='hdnClient'><input type='hidden' id='hdnProject' value='" + $(this).find("ProjectName").text() + "' name='hdnProject'><input type='hidden' id='hdnEditPojectId' name='hdnEditPojectId' value='" + $(this).find("Project_Id").text() + "'/></td>";
                                tbl = tbl + "<td style='text-align: left;'>" + $(this).find("MJobName").text() + "<input type='hidden' id='hdnJobname' value='" + $(this).find("MJobName").text() + "' name='hdnJobname'><input type='hidden' id='hdnEdiJobId' name='hdnEdiJobId' value='" + $(this).find("mJob_Id").text() + "'/></td>";
                                if ($("[id*=hdnPageLevel]").val() > 3) {
                                    tbl = tbl + "<td style='text-align: left;'>" + $(this).find("TaskName").text() + "</td>";
                                }

                                if (CompanyPermissions[0].Edit_Billing_Hrs == true) {
                                    if (Staffcode > 0 && Staffrole != "Staff") {
                                        if ($(this).find("Billable").text() == 'true') {
                                            var tTime = $(this).find("TotalTime").text();
                                            var totTime = tTime.split('.');
                                            var totHrs = '';
                                            if (totTime[0].length == 1) {
                                                totHrs = '0' + totTime[0];
                                            }
                                            else {
                                                totHrs = totTime[0]
                                            }
                                            var totalTime = totHrs + '.' + totTime[1];

                                            if ($(this).find("EditedBilling_Hrs").text() == "0.00" || $(this).find("EditedBilling_Hrs").text() == "00.00") {
                                                tbl = tbl + "<td style='text-align: left;'>" + totalTime + "<input type='hidden' id='hdnTotTime' value='" + totalTime + "' name='hdnTotTime'></td>";
                                                tbl = tbl + "<td style='width: 70px;'><input type='text' id='txteditbillablehrs' name='txteditbillablehrs'  class='form-control'  style='width: 70px;'   onblur='ShowBlur($(this))' value='" + $(this).find("TotalTime").text() + "')> </td> ";
                                            }
                                            else {
                                                ///Swaping of the column
                                                tbl = tbl + "<td style='text-align: left;'>" + $(this).find("EditedBilling_Hrs").text() + "</td>";
                                                tbl = tbl + "<td style='width: 70px;'><input type='text' id='txteditbillablehrs' name='txteditbillablehrs'  class='form-control'  style='width: 70px;'   onblur='ShowBlur($(this))' value='" + $(this).find("TotalTime").text() + "')> </td> ";
                                            }
                                        }
                                        else {
                                            var tTime = $(this).find("TotalTime").text();
                                            var totTime = tTime.split('.');
                                            var totHrs = '';
                                            if (totTime[0].length == 1) {
                                                totHrs = '0' + totTime[0];
                                            }
                                            else {
                                                totHrs = totTime[0]
                                            }
                                            var totalTime = totHrs + '.' + totTime[1];

                                            if ($(this).find("EditedBilling_Hrs").text() == "") {
                                                tbl = tbl + "<td style='text-align: left;'>" + totalTime + "<input type='hidden' id='hdnTotTime' value='" + totalTime + "' name='hdnTotTime'></td>";
                                                tbl = tbl + "<td style='width: 70px;'><input type='text' id='txteditbillablehrs' class='form-control' name='txteditbillablehrs' style='width: 70px;'    onblur='ShowBlur($(this))' value='00.00' disabled> </td> ";
                                            }
                                            else {
                                                tbl = tbl + "<td style='text-align: left;'>" + totalTime + "<input type='hidden' id='hdnTotTime' value='" + totalTime + "' name='hdnTotTime'></td>";
                                                tbl = tbl + "<td style='width: 70px;'><input type='text' id='txteditbillablehrs' class='form-control' name='txteditbillablehrs' style='width: 70px;'  onblur='ShowBlur($(this))' value='" + $(this).find("EditedBilling_Hrs").text() + "' disabled> </td> ";
                                            }
                                        }
                                    }
                                    else {
                                        var tTime = $(this).find("TotalTime").text();
                                        var totTime = tTime.split('.');
                                        var totHrs = '';
                                        if (totTime[0].length == 1) {
                                            totHrs = '0' + totTime[0];
                                        }
                                        else {
                                            totHrs = totTime[0]
                                        }
                                        var totalTime = totHrs + '.' + totTime[1];
                                        tbl = tbl + "<td style='text-align: left;'>" + totalTime + "<input type='hidden' id='hdnTotTime' value='" + totalTime + "' name='hdnTotTime'></td>";
                                        tbl = tbl + "<td style='width: 70px;'>" + $(this).find("EditedBilling_Hrs").text() + "</td> ";
                                    }
                                }
                                else {
                                    tbl = tbl + "<td style='text-align: left;'>" + $(this).find("TotalTime").text() + "</td>";
                                }

                                if ($(this).find("Narration").text() == '') {
                                    tbl = tbl + "<td style='text-align: center;' class='chkShowNarrationIcon'><i class='icon-bubble9 mr-1' ></i></td>";
                                } else {
                                    tbl = tbl + "<td class='chkShowNarrationIcon' style='text-align: center;cursor: pointer;'><i class='icon-bubble-lines4 mr-1 ' onclick='OpenNarration($(this))' data-toggle='modal' data-target='#modal_h3' ></i><input type='hidden' id='hdnNarr' value='" + $(this).find("Narration").text() + "' name='hdnNarr'></td>";
                                }
                                tbl = tbl + "<td style='text-align: left;' id='tdNarrationMessage' class='chkShowNarrationMessage'>" + $(this).find("Narration").text() + "</td>";

                                if ($(this).find("Billable").text() == 'true') {
                                    tbl = tbl + "<td style='text-align: center;cursor: pointer;'> <i class='icon-checkmark2 mr-3 icon-2x' style='color: green;' ></i><input type='hidden'  id='hdnBillable' name='hdnBillable' value=" + $(this).find("Billable").text() + " /></td>";
                                } else {
                                    tbl = tbl + "<td style='text-align: center;cursor: pointer;'> <i class='icon-cross3 mr-3 icon-2x' style='color: red;' ></i><input type='hidden'  id='hdnBillable' name='hdnBillable' value=" + $(this).find("Billable").text() + " /></td>";
                                }

                                if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                                    if ($(this).find("Status").text() == 'Submitted') {
                                        tbl = tbl + "<td style='text-align: left;color: orange;'>" + $(this).find("Status").text() + "</td>";
                                    }
                                    else if ($(this).find("Status").text() == 'Saved') {
                                        tbl = tbl + "<td style='text-align: left;color: SkyBlue;'>" + $(this).find("Status").text() + "</td>";
                                    }
                                    else if ($(this).find("Status").text() == 'Approved') {
                                        tbl = tbl + "<td style='text-align: left;color: LimeGreen;'>" + $(this).find("Status").text() + "</td>";
                                    }
                                    else if ($(this).find("Status").text() == 'Rejected') {
                                        tbl = tbl + "<td style='text-align: center;color: IndianRed;'>" + $(this).find("Status").text() + "";
                                        if ($(this).find("Reason").text() != '') {
                                            tbl = tbl + "<input type='hidden' id ='hdnReason' name ='hdnReason' value ='" + $(this).find("Reason").text() + "'/>"
                                                + "<br><i class='icon-bubble-lines4 mr-1' data-toggle='modal' data-target='#modal_Reason' onclick='ReasonPopup($(this))' />"
                                                + "</td>";
                                        }
                                        else { tbl = tbl + "</td>"; }
                                    }
                                    else if ($(this).find("Status").text() == 'Semi Approved') {
                                        tbl = tbl + "<td style='text-align: left;background-color: Yellow;'>" + $(this).find("Status").text() + "</td>";
                                    }
                                }
                                else {
                                    if ($("[id*=chkMy]").is(':checked') != true) {
                                        tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + $(this).find("Status").text() + "' /><input type='checkbox' class='Chkbox' id='chkclt'  name='chkclt' value='" + $(this).find("TSID").text() + "' /></td>";
                                        tbl = tbl + "<td style='text-align: center;'> <i class='icon-compose mr-2 ' data-toggle='modal' data-target='#modal_h3' onclick='OpenReason($(this))' style='cursor: pointer;'></i>"
                                            + "<input type='hidden' id='hdnResn_tsid_" + $(this).find("TSID").text() + "' name='hdnResn_tsid_" + $(this).find("TSID").text() + "' value='' >"
                                            + "<input type='hidden' id='hdnResn' name='hdnResn' value='" + $(this).find("Reason").text() + "' ' ></td>";
                                    } else {
                                        if ($(this).find("MyTS").text() == 1) {
                                            tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + $(this).find("Status").text() + "' /><input type='checkbox' class='Chkbox' id='chkclt'  name='chkclt' value='" + $(this).find("TSID").text() + "' /></td>";
                                        } else {
                                            if ($(this).find("Status").text() == 'Submitted') {
                                                tbl = tbl + "<td style='text-align: left;color: orange;font-weight: bold;'>" + $(this).find("Status").text() + "</td>";
                                            }
                                            else if ($(this).find("Status").text() == 'Saved') {
                                                tbl = tbl + "<td style='text-align: left;color: SkyBlue;font-weight: bold;'>" + $(this).find("Status").text() + "</td>";
                                            }
                                            else if ($(this).find("Status").text() == 'Approved') {
                                                tbl = tbl + "<td style='text-align: left;color: LimeGreen;font-weight: bold;'>" + $(this).find("Status").text() + "</td>";
                                            }
                                            else if ($(this).find("Status").text() == 'Rejected') {
                                                tbl = tbl + "<td style='text-align: center;color: IndianRed;font-weight: bold;'>" + $(this).find("Status").text() + "";
                                                if ($(this).find("Reason").text() != '') {
                                                    tbl = tbl + "<input type='hidden' id ='hdnReason' name ='hdnReason' value ='" + $(this).find("Reason").text() + "'/>"
                                                        + "<br><i class='icon-bubble-lines4 mr-1' data-toggle='modal' data-target='#modal_Reason' onclick='ReasonPopup($(this))' />"
                                                        + "</td>";
                                                }
                                                else { tbl = tbl + "</td>"; }
                                            }
                                            else if ($(this).find("Status").text() == 'Semi Approved') {
                                                tbl = tbl + "<td style='text-align: left;color: Yellow;font-weight: bold;'>" + $(this).find("Status").text() + "</td>";
                                            }
                                        }
                                    }
                                }
                                if ($("[id*=hdnRolename]").val() == 'Staff') {
                                    if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                                        if ($(this).find("Status").text() == 'Approved') {
                                            tbl = tbl + "<td style='text-align: center'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                        }
                                        else {
                                            tbl = tbl + "<td style='text-align: center'><div class='list-icons'><div class='dropdown'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='- 1'><i class='icon-more2'></i></a><div class='dropdown-menu dropdown-menu-right'><a href='#' data-toggle='modal' data-target='#modalEditTS2lvl' onclick='editTsdata($(this), " + $(this).find("TSID").text() + ")' name='edit' class='dropdown-item'><i class='far fa-edit' style='cursor: pointer;font-size:1rem;color:#00acc1'></i>&nbsp;Edit<input type='hidden'  id='hdneditdt' name='hdneditdt' value=" + moment(va.Date1).format('MM/DD/YYYY') + " /></a><a href='#' onclick='deletesavedTimesheet(" + $(this).find("TSID").text() + ")' name='delete' class='dropdown-item'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1rem;color:red'></i>&nbsp;Delete</a><a href='#' name='Expense' data-toggle='modal' data-target='#ModalExpenseId' class='dropdown-item' onclick='editTsExpense(" + $(this).find("TSID").text() + ",$(this))'><i class='fas fa-rupee-sign text-purple-600'></i>&nbsp;Expense</a></div></div></div></td>";
                                        }
                                    }
                                }
                                else if ($("[id*=hdnRolename]").val() == 'Approver') {
                                    if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                                        if (ChckMyTS == true) {
                                            if ($(this).find("Status").text() == 'Approved') {
                                                tbl = tbl + "<td style='text-align: center'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                            }
                                            else {
                                                if ($(this).find("staffCode").text() === $("[id*=hdnEditStaffcode]").val()) {
                                                    tbl = tbl + "<td style='text-align: center'><div class='list-icons'><div class='dropdown'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='- 1'><i class='icon-more2'></i></a><div class='dropdown-menu dropdown-menu-right'><a href='#' data-toggle='modal' data-target='#modalEditTS2lvl' onclick='editTsdata($(this), " + $(this).find("TSID").text() + ")' name='edit' class='dropdown-item'><i class='far fa-edit' style='cursor: pointer;font-size:1rem;color:#00acc1'></i>&nbsp;Edit<input type='hidden'  id='hdneditdt' name='hdneditdt' value=" + moment(va.Date1).format('MM/DD/YYYY') + " /></a><a href='#' onclick='deletesavedTimesheet(" + $(this).find("TSID").text() + ")' name='delete' class='dropdown-item'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1rem;color:red'></i>&nbsp;Delete</a><a href='#' name='Expense' data-toggle='modal' data-target='#ModalExpenseId' class='dropdown-item' onclick='editTsExpense(" + $(this).find("TSID").text() + ",$(this))'><i class='fas fa-rupee-sign text-purple-600'></i>&nbsp;Expense</a></div></div></div></td>";
                                                }
                                                else {
                                                    tbl = tbl + "<td style='text-align: center'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                                }
                                            }
                                        }
                                    }
                                }
                                tbl = tbl + "</tr>";
                            }
                        });
                        $("[id*=tbl_PendingTS]").append(tbl);
                        Pager(RecordCount);
                        if (RecordCount >= minPageSize) {
                            Pager(RecordCount);
                            $("#divPageSize_Pending").css({ 'display': 'block' });
                            $("[id*=tblPager_Pending]").show();
                        }
                        else {
                            Pager(0);
                            $("[id*=divPageSize_Pending]").hide();
                            $("[id*=tblPager_Pending]").hide();
                        }
                        Blockloaderhide();
                    } else {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        if ($("[id*=hdnPageLevel]").val() > 3) {
                            tbl = tbl + "<td></td>";
                        }
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        if ($("[id*=hdnExpense]").val() == 'True') {
                            tbl = tbl + "<td></td>";
                        }
                        tbl = tbl + "</tr>";
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td colspan='14' style='text-align:center;'>No Record Found !!!</td>";
                        tbl = tbl + "</tr>";
                        $("[id*=tbl_PendingTS]").append(tbl);
                        Pager(0);
                        $("[id*=tblPager_Pending]").hide();
                        Blockloaderhide();
                    }

                    $("#chkShowNarrationMessage:not(:checked)").each(function () {
                        var column = "table ." + $(this).attr("name");
                        $(column).hide();
                    });
                },
                failure: function (response) {
                    Blockloaderhide();
                    showDangerAlert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    Blockloaderhide();
                    showDangerAlert('Error Occoured ' + response.d);
                }
            });
        }

        function ConvertFormat(i, tTime) {

            var startTime = tTime.replace(':', '.');
            var firstHH = startTime.split('.')[0];
            var firstMM = startTime.split('.')[1];
            if (firstMM == undefined) {
                firstMM = "0";
            }

            if (firstHH == undefined) {
                firstHH = "0";
            }

            if (firstHH == "") {
                firstHH = "0";
            }
            if (firstMM == "") {
                firstMM = "0";
            }

            if (firstMM >= 60) {
                var realmin = firstMM % 60;
                var hours = Math.floor(firstMM / 60);
                firstHH = parseFloat(firstHH) + parseFloat(hours);
                firstMM = realmin;
            }

            if (firstMM < 10) {
                if (parseFloat(firstMM.length) < 2) {
                    firstMM = firstMM + "0";
                }
            }

            if (firstHH < 10) {
                if (parseFloat(firstHH.length) < 2) {
                    firstHH = "0" + firstHH;
                }
            }
            tTime = firstHH + ':' + firstMM;
            var txt = i[0].id;
            $("#txteditbillablehrs", i.closest("tr")).val(tTime);
        }

        // for edit billable textbox
        function ShowBlur(i) {
            var tTime = '00:00';
            var FTime = '00:00';
            var totalHH = '00';
            var totalMM = '00';
            var decimalHours = moment.duration("08:40").asHours();
            decimalHours = Math.round(decimalHours * 100) / 100
            var rw = i.closest("tr");
            var rIndex = i.closest("tr")[0].sectionRowIndex;
            var j = rw.find("input[name=txteditbillablehrs]").val();
            var txt = i[0].id;
            var V = i.val();
            if (V == "" || V == null || V == undefined || $("#" + txt, i.closest("tr")).val().length < 5 || $("#" + txt, i.closest("tr")).val().length > 5) {
                V = ConvertFormat(i, V);
            }
            var isValid = /^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/.test($("#txteditbillablehrs", i.closest("tr")).val());

            if (!isValid) {
                showWarningAlert('Invalid time format');
                $("#txteditbillablehrs", i.closest("tr")).val('00:00');
                return;
            }

            if (j == '') {
                j = j.replace(':', '.');
                $("#txteditbillablehrs", rw).val(j);

                if (j != undefined) {
                    if (j != '') {
                        var JM = j.split('.')[1];
                        if (JM == undefined) {
                            $("#txteditbillablehrs", rw).val('00.00');
                        }
                        var jhrs = j.replace(':', '.');
                        if (isNaN(jhrs) == true) {
                            $("#txteditbillablehrs", rw).val('00.00');
                        }
                        if (jhrs > 23.59) {
                            $("#txteditbillablehrs", rw).val('00.00');
                        }
                        if (JM > 59) {
                            $("#txteditbillablehrs", rw).val('00.00');
                        }
                        if (JM > 00 && JM < 60) {
                            $("#txteditbillablehrs", rw).val('00.00');
                        }
                    }

                    var startTime = $("#txteditbillablehrs", rw).val();
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

                    if (parseFloat(FTime) > 24.00) {
                        $("#txteditbillablehrs", row).val('00:00');
                        showWarningAlert('Total Time for the day exceeds more than 24 Hours');
                        return;
                    }
                }
            }
        }

        function Bind_TwoLTimesheet() {
            Blockloadershow();
            //var compid = $("[id*=hdnCompanyid]").val();
            var cltid = $("[id*=drpclient3]").val();
            var deptId = $("[id*=ddlDept]").val();
            var mjobid = $("[id*=drpMjob3]").val();
            var Sid = $("[id*=drpstaff3]").val();
            var frtime = $("[id*=hdnFromdate]").val();
            var totime = $("[id*=hdnTodate]").val();
            var status = $("[id*=drpstatus]").val();
            var Staffcode = $("[id*=hdnEditStaffcode]").val();
            var SuperAppr = $("[id*=hdnSuperAppr]").val();
            var SubAppr = $("[id*=hdnSubAppr]").val();
            var ChckMyTS = $("[id*=chkMy]").is(':checked');
            var selectstatus = $("[id*=drpstatus]").val();
            $("[id*=hdnmyStatus]").val(ChckMyTS);
            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/Bind_TwoLTimesheet",
                data: '{cltid:"' + cltid + '",mjobid:"' + mjobid + '",staffcode:"' + Staffcode + '",frtime:"' + frtime + '",totime:"' + totime + '",status:"' + status + '",Sid:' + Sid + ',SuperAppr:"' + SuperAppr + '",SubAppr:"' + SubAppr + '",ChckMyTS:"' + ChckMyTS + '",deptId:"' + deptId + '",pageIndex:' + $("[id*=hdnPages]").val() + ',pageSize:' + $("[id*=hdnSize]").val() + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var RecordCount = 0;

                    var tbl = '';
                    $("[id*=tbl_AllTimesheet] tbody").empty();
                    $("[id*=tbl_AllTimesheet] thead").empty();

                    tbl = tbl + "<thead><tr>";
                    tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Date</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Staff</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Client</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Activity</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>From Time</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>To Time</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Total</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Expense</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Location</th>";
                    tbl = tbl + "<th style='font-weight: bold;' id='thNarrationIcon' class='chkShowNarrationIcon'>Narration</th>";
                    tbl = tbl + "<th style='font-weight: bold;' id='thNarrationMessage' class='chkShowNarrationMessage'>Narration</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Bill</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Status</th>";

                    if (selectstatus == 'Approved' || selectstatus == 'All') {
                        tbl = tbl + "<th style='font-weight: bold;'>Approver</th>";
                    }


                    if ($("[id*=hdnRolename]").val() == 'Staff' || $("[id*=hdnRolename]").val() == 'Approver') {
                        if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                            if ($("[id*=hdnRolename]").val() == 'Approver' && ChckMyTS == true) {
                                tbl = tbl + "<th style='font-weight: bold;'>Actions</th>";
                            }
                            else if ($("[id*=hdnRolename]").val() == 'Staff') {
                                tbl = tbl + "<th style='font-weight: bold;'>Actions</th>";
                            }
                        }
                    }

                    if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                    } else {
                        if (selectstatus == 'Approved') {
                            tbl = tbl + "<th style='text-align:left;'></th>";
                            $("[id*=btnStatusAppr]").show();
                            $("[id*=btnStatusReject]").show();
                            $("[id*=chkApprovedAll]").show();
                            $("[id*=lblAppr]").show();
                        }
                        else {
                            $("[id*=btnStatusAppr]").hide();
                            $("[id*=btnStatusReject]").hide();
                            $("[id*=chkApprovedAll]").hide();
                            $("[id*=lblAppr]").hide();
                        }
                    }
                    tbl = tbl + "</tr></thead>";

                    if (myList.length > 0) {
                        var sc = myList.length;

                        for (var i = 0; i < myList.length; i++) {
                            if (i == 0) {
                                RecordCount = myList[i].TotalCount;
                            }
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td style='text-align: center;'>" + myList[i].Srno + "<input type='hidden' id='hdnATSid' value='" + myList[i].TSId + "' name='hdnATSid'></td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].Dt + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].StaffName + "<input type='hidden' id='hdnTStaffCode' name='hdnTStaffCode' value='" + Staffcode + "'><input type='hidden' id='hdnEditClientId' name='hdnEditClientId' value='" + myList[i].CLTId + "'/><input type='hidden' id='hdnJid' name='hdnJid' value='" + myList[i].JobId + "'/></td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].ClientName + "<input type='hidden' id='hdnClient' name='hdnClient' value='" + myList[i].ClientName + "'></td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].MJobName + "<input type='hidden' id='hdnJobname' name='hdnJobname' value='" + myList[i].MJobName + "'><input type='hidden' id='hdnEdiJobId' name='hdnEdiJobId' value='" + myList[i].mJobid + "'/></td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].FromDT + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].ToDT + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].TotalTime + "<input type='hidden' id='hdnTotTime' value='" + myList[i].TotalTime + "' name='hdnTotTime'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + myList[i].Status + "' /></td>";
                            if (myList[i].OpeAmt == 0) {
                                tbl = tbl + "<td style='text-align: left;'>0.00</td>";
                            } else {
                                tbl = tbl + "<td style='text-align: left;'>" + myList[i].OpeAmt + "</td>";
                            }

                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].Location + "</td>";
                            if (myList[i].Narration == '') {
                                tbl = tbl + "<td style='text-align: center;' class='chkShowNarrationIcon'><i class='icon-bubble9 mr-1 '></i></td>";
                            } else {
                                tbl = tbl + "<td style='text-align: center;cursor: pointer;' class='chkShowNarrationIcon'><i class='icon-bubble-lines4 mr-1' onclick='Open2Narration($(this))' data-toggle='modal' data-target='#modalNarr2lvl' ></i><input type='hidden' id='hdnNarr' value='" + myList[i].Narration + "' name='hdnNarr'></td>";
                            }

                            tbl = tbl + "<td style='text-align: left;' id='tdNarrationMessage' class='chkShowNarrationMessage'>" + myList[i].Narration + "</td>";
                            if (myList[i].Billable == true) {
                                tbl = tbl + "<td> <i class='icon-checkmark2 mr-3 icon-2x' style='color: green;'></i><input type='hidden'  id='hdnBillable' name='hdnBillable' value=" + myList[i].Billable + " /></td>";
                            } else {
                                tbl = tbl + "<td> <i class='icon-cross3 mr-3 icon-2x' style='color: red;'></i><input type='hidden'  id='hdnBillable' name='hdnBillable' value=" + myList[i].Billable + " /></td>";
                            }


                            if (myList[i].Status == 'Submitted') {
                                tbl = tbl + "<td style='text-align: left;color: orange;font-weight: bold;'>" + myList[i].Status + "<input type='hidden' id='hdnStatus' value='" + myList[i].Status + "' name='hdnStatus'></td>";
                            }
                            else if (myList[i].Status == 'Saved') {
                                tbl = tbl + "<td style='text-align: left;color: SkyBlue;font-weight: bold;'>" + myList[i].Status + "<input type='hidden' id='hdnStatus' value='" + myList[i].Status + "' name='hdnStatus'></td>";
                            }
                            else if (myList[i].Status == 'Approved') {
                                tbl = tbl + "<td style='text-align: center;color: LimeGreen;font-weight: bold;'>" + myList[i].Status + "<input type='hidden' id='hdnStatus' value='" + myList[i].Status + "' name='hdnStatus'>"
                                if (myList[i].Reason != '') {
                                    tbl = tbl + "<input type = 'hidden' id = 'hdnReason' name = 'hdnReason' value = '" + myList[i].Reason + "' />"
                                        + " <br><i class='icon-bubble-lines4 mr-1' data-toggle='modal' data-target='#modal_Reason' onclick='ReasonPopup($(this))' >"
                                        + "</td>";
                                }
                                else { tbl = tbl + "</td>"; }
                            }
                            else if (myList[i].Status == 'Rejected') {
                                tbl = tbl + "<td style='text-align: center;color: IndianRed;font-weight: bold;'>" + myList[i].Status + "<input type='hidden' id='hdnStatus' value='" + myList[i].Status + "' name='hdnStatus'>"
                                if (myList[i].Reason != '') {
                                    tbl = tbl + "<input type = 'hidden' id = 'hdnReason' name = 'hdnReason' value = '" + myList[i].Reason + "' />"
                                        + " <br><i class='icon-bubble-lines4 mr-1' data-toggle='modal' data-target='#modal_Reason' onclick='ReasonPopup($(this))' >"
                                        + "</td>";
                                }
                                else { tbl = tbl + "</td>"; }
                            }
                            else if (myList[i].Status == 'Semi Approved') {
                                tbl = tbl + "<td style='text-align: left;color: Yellow;font-weight: bold;'>" + myList[i].Status + "<input type='hidden' id='hdnStatus' value='" + myList[i].Status + "' name='hdnStatus'></td>";
                            }

                            if (selectstatus == 'Approved' || selectstatus == 'All') {
                                tbl = tbl + "<td style='text-align: left;'>" + myList[i].Approver + "</td>";
                            }




                            if ($("[id*=hdnRolename]").val() == 'Staff') {
                                if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                                    if (myList[i].Status == 'Approved') {
                                        tbl = tbl + "<td style='text-align: center;'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                    }
                                    else {
                                        tbl = tbl + "<td style='text-align: center;'><div class='list-icons'><div class='dropdown'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='- 1'><i class='icon-more2'></i></a><div class='dropdown-menu dropdown-menu-right'><a href='#' data-toggle='modal' data-target='#modalEditTS2lvl' onclick='edit2LvlTsdata($(this), " + myList[i].TSId + ")' name='edit' class='dropdown-item'><i class='far fa-edit' style='cursor: pointer;font-size:1rem;color:#00acc1'></i>&nbsp;Edit<input type='hidden'  id='hdneditdt' name='hdneditdt' value=" + myList[i].Dt + " /></a><a href='#' onclick='deletesavedTimesheet(" + myList[i].TSId + ")' name='delete' class='dropdown-item'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1rem;color:red'></i>&nbsp;Delete</a><a href='#' name='Expense' data-toggle='modal' data-target='#ModalExpenseId' class='dropdown-item' onclick='editTsExpense(" + myList[i].TSId + ",$(this))'><i class='fas fa-rupee-sign text-purple-600'></i>&nbsp;Expense</a></div></div></div></td>";
                                    }
                                }
                            }
                            else if ($("[id*=hdnRolename]").val() == 'Approver') {
                                if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                                    if (ChckMyTS == true) {
                                        if (myList[i].Status == 'Approved') {
                                            tbl = tbl + "<td style='text-align: center;'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                        }
                                        else {
                                            if (Staffcode === $("[id*=hdnEditStaffcode]").val()) {
                                                tbl = tbl + "<td style='text-align: center;'><div class='list-icons'><div class='dropdown'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='- 1'><i class='icon-more2'></i></a><div class='dropdown-menu dropdown-menu-right'><a href='#' data-toggle='modal' data-target='#modalEditTS2lvl' onclick='edit2LvlTsdata($(this), " + myList[i].TSId + ")' name='edit' class='dropdown-item'><i class='far fa-edit' style='cursor: pointer;font-size:1rem;color:#00acc1'></i>&nbsp;Edit<input type='hidden'  id='hdneditdt' name='hdneditdt' value=" + myList[i].Dt + " /></a><a href='#' onclick='deletesavedTimesheet(" + myList[i].TSId + ")' name='delete' class='dropdown-item'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1rem;color:red'></i>&nbsp;Delete</a><a href='#' name='Expense' data-toggle='modal' data-target='#ModalExpenseId' class='dropdown-item' onclick='editTsExpense(" + myList[i].TSId + ",$(this))'><i class='fas fa-rupee-sign text-purple-600'></i>&nbsp;Expense</a></div></div></div></td>";
                                            }
                                            else {
                                                tbl = tbl + "<td style='text-align: center;'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                            }
                                        }
                                    }
                                }
                            }

                            if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                            } else {
                                if (selectstatus == 'Approved') {
                                    tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + myList[i].Status + "' /><input type='checkbox' class='Chkbox' id='chkcltApp'  name='chkcltApp' value='" + myList[i].TSId + "' /></td>";
                                }
                            }

                            tbl = tbl + "</tr>";
                        };
                        $("[id*=tbl_AllTimesheet]").append(tbl);
                        Pager(RecordCount);
                        if (RecordCount >= minPageSize) {
                            Pager(RecordCount);
                            $("#divPageSize_AllApproved").css({ 'display': 'block' });
                            $("[id*=tblPager_AllApproved]").show();
                        }
                        else {
                            Pager(0);
                            $("[id*=divPageSize_AllApproved]").hide();
                            $("[id*=tblPager_AllApproved]").hide();
                        }
                        Blockloaderhide();
                    } else {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        if ($("[id*=hdnPageLevel]").val() > 3) {
                            tbl = tbl + "<td></td>";
                        }
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "</tr>";
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td colspan='13' style='text-align:center;'>No Record Found !!!</td>";
                        tbl = tbl + "</tr>";
                        $("[id*=tbl_AllTimesheet]").append(tbl);
                        $("#table-responsive").removeClass("table-scroll");
                        Pager(0);
                        $("[id*=tblPager_AllApproved]").hide();
                        Blockloaderhide();
                    }

                    $("#chkShowNarrationMessage:not(:checked)").each(function () {
                        var column = "table ." + $(this).attr("name");
                        $(column).hide();
                    });
                },
                failure: function (response) {
                    showDangerAlert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    showDangerAlert('Error Occoured ' + response.d);
                }
            });
        }

        function Pending_2Timesheets() {
            Blockloadershow();
            //var compid = $("[id*=hdnCompanyid]").val();
            var cltid = $("[id*=drpclient3]").val();
            var deptId = $("[id*=ddlDept]").val();
            var mjobid = $("[id*=drpMjob3]").val();
            var Sid = $("[id*=drpstaff3]").val();
            var frtime = $("[id*=hdnFromdate]").val();
            var totime = $("[id*=hdnTodate]").val();
            var status = $("[id*=drpstatus]").val();
            var Staffcode = $("[id*=hdnEditStaffcode]").val();
            var SuperAppr = $("[id*=hdnSuperAppr]").val();
            var SubAppr = $("[id*=hdnSubAppr]").val();
            var ChckMyTS = $("[id*=chkMy]").is(':checked');
            var selectstatus = $("[id*=drpstatus]").val();
            $("[id*=hdnmyStatus]").val(ChckMyTS);
            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/Bind_TwoLTimesheet",
                data: '{cltid:"' + cltid + '",mjobid:"' + mjobid + '",staffcode:"' + Staffcode + '",frtime:"' + frtime + '",totime:"' + totime + '",status:"' + status + '",Sid:' + Sid + ',SuperAppr:"' + SuperAppr + '",SubAppr:"' + SubAppr + '",ChckMyTS:"' + ChckMyTS + '",deptId:"' + deptId + '",pageIndex:' + $("[id*=hdnPages]").val() + ',pageSize:' + $("[id*=hdnSize]").val() + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var RecordCount = 0;
                    var tbl = '';
                    $("[id*=tbl_PendingTS] tbody").empty();
                    $("[id*=tbl_PendingTS] thead").empty();

                    tbl = tbl + "<thead><tr>";

                    if ($("[id*=hdnSuperAppr]").val() == 'True' || $("[id*=hdnSubAppr]").val() == 'True') {
                        if (CompanyPermissions[0].Apredittmst == true) {
                            tbl = tbl + "<th style='font-weight: bold;'></th>";
                        } else {
                            tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
                        }
                    } else {
                        tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
                    }
                    tbl = tbl + "<th style='font-weight: bold;'>Date</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Staff</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Client</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Activity</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>From Time</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>To Time</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Total</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Exp</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Location</th>";
                    tbl = tbl + "<th style='font-weight: bold;' id='thNarrationIcon' class='chkShowNarrationIcon'>Narration</th>";
                    tbl = tbl + "<th style='font-weight: bold;' id='thNarrationMessage' class='chkShowNarrationMessage'>Narration</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Bill</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Status</th>";

                    if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                    } else {
                        if ($("[id*=chkMy]").is(':checked') != true) {
                            tbl = tbl + "<th style='font-weight: bold;'>Reason</th>";
                        }
                    }
                    if ($("[id*=hdnRolename]").val() == 'Staff' || $("[id*=hdnRolename]").val() == 'Approver') {
                        if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                            if ($("[id*=hdnRolename]").val() == 'Approver' && ChckMyTS == true) {
                                tbl = tbl + "<th style='font-weight: bold;'>Actions</th>";
                            }
                            else if ($("[id*=hdnRolename]").val() == 'Staff') {
                                tbl = tbl + "<th style='font-weight: bold;'>Actions</th>";
                            }
                        }
                    }


                    tbl = tbl + "</tr></thead>";

                    if (myList.length > 0) {

                        var sc = myList.length;
                        for (var i = 0; i < myList.length; i++) {
                            if (i == 0) {
                                RecordCount = myList[i].TotalCount;
                            }
                            tbl = tbl + "<tr>";
                            ///To check Edit Timesheet Permission
                            if ($("[id*=hdnSuperAppr]").val() == 'True' || $("[id*=hdnSubAppr]").val() == 'True') {
                                if (CompanyPermissions[0].Apredittmst == true) {
                                    tbl = tbl + "<td style='text-align: center;'> <i class='icon-pencil mr-2' data-toggle='modal' data-target='#modalEditTS2lvl' onclick='editTsdata($(this)," + myList[i].TSId + " )' style='cursor: pointer;'></i></td>";
                                } else {
                                    tbl = tbl + "<td style='text-align: center;'>" + myList[i].Srno + "<input type='hidden' id='hdnATSid' value='" + myList[i].TSId + "' name='hdnATSid'></td>";
                                }
                            } else {
                                tbl = tbl + "<td style='text-align: center;'>" + myList[i].Srno + "<input type='hidden' id='hdnATSid' value='" + myList[i].TSId + "' name='hdnATSid'></td>";
                            }
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].Dt + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].StaffName + "<input type='hidden' id='hdnTStaffCode' name='hdnTStaffCode' value='" + Staffcode + "'><input type='hidden' id='hdnEditClientId' name='hdnEditClientId' value='" + myList[i].CLTId + "'/><input type='hidden' id='hdnJid' name='hdnJid' value='" + myList[i].JobId + "'/></td>";
                            if ($("[id*=hdnPageLevel]").val() == 2) {
                                tbl = tbl + "<td style='text-align: left;'>" + myList[i].ClientName + "<input type='hidden' id='hdnClient' name='hdnClient' value='" + myList[i].ClientName + "'></td>";
                            }
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].MJobName + "<input type='hidden' id='hdnJobname' name='hdnJobname' value='" + myList[i].MJobName + "'><input type='hidden' id='hdnEdiJobId' name='hdnEdiJobId' value='" + myList[i].mJobid + "'/></td>";

                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].FromDT + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].ToDT + "</td>";
                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].TotalTime + "<input type='hidden' id='hdnTotTime' value='" + myList[i].TotalTime + "' name='hdnTotTime'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + myList[i].Status + "' /></td>";
                            if (myList[i].OpeAmt == 0) {
                                tbl = tbl + "<td style='text-align: left;'>0.00</td>";
                            } else {
                                tbl = tbl + "<td style='text-align: left;'>" + myList[i].OpeAmt + "</td>";
                            }

                            tbl = tbl + "<td style='text-align: left;'>" + myList[i].Location + "</td>";
                            if (myList[i].Narration == '') {
                                tbl = tbl + "<td style='text-align: center;' class='chkShowNarrationIcon'><i class='icon-bubble9 mr-1'></i></td>";
                            } else {
                                tbl = tbl + "<td style='text-align: center;cursor: pointer;' class='chkShowNarrationIcon'><i class='icon-bubble-lines4 mr-1 ' onclick='Open2Narration($(this))' data-toggle='modal' data-target='#modalNarr2lvl' ></i><input type='hidden' id='hdnNarr' value='" + myList[i].Narration + "' name='hdnNarr'></td>";

                            }
                            tbl = tbl + "<td style='text-align: left;' id='tdNarrationMessage' class='chkShowNarrationMessage'>" + myList[i].Narration + "<input type='hidden' id='hdnNarr' value='" + myList[i].Narration + "' name='hdnNarr'></td>";


                            if (myList[i].Billable == true) {
                                tbl = tbl + "<td> <i class='icon-checkmark2 mr-3 icon-2x' style='color: green;'></i><input type='hidden'  id='hdnBillable' name='hdnBillable' value=" + myList[i].Billable + " /></td>";

                            } else {
                                tbl = tbl + "<td> <i class='icon-cross3 mr-3 icon-2x' style='color: red;'></i><input type='hidden'  id='hdnBillable' name='hdnBillable' value=" + myList[i].Billable + " /></td>";
                            }

                            //////////Pending_2Timesheets()

                            if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                                if (myList[i].Status == 'Submitted') {
                                    tbl = tbl + "<td style='text-align: left;color: orange;font-weight: bold;'>" + myList[i].Status + "</td>";
                                }
                                else if (myList[i].Status == 'Saved') {
                                    tbl = tbl + "<td style='text-align: left;color: SkyBlue;font-weight: bold;'>" + myList[i].Status + "</td>";
                                }
                                else if (myList[i].Status == 'Approved') {
                                    tbl = tbl + "<td style='text-align: left;color: LimeGreen;font-weight: bold;'>" + myList[i].Status + "</td>";
                                }
                                else if (myList[i].Status == 'Rejected') {
                                    tbl = tbl + "<td style='text-align: center;color: IndianRed;font-weight: bold;'>" + myList[i].Status + "";
                                    if (myList[i].Reason != '') {
                                        tbl = tbl + "<input type='hidden' id ='hdnReason' name ='hdnReason' value ='" + myList[i].Reason + "'/>"
                                            + "<br><i class='icon-bubble-lines4 mr-1' data-toggle='modal' data-target='#modal_Reason' onclick='ReasonPopup($(this))' />"
                                            + "</td>";
                                    }
                                    else { tbl = tbl + "</td>"; }
                                }
                                else if (myList[i].Status == 'Semi Approved') {
                                    tbl = tbl + "<td style='text-align: left;color: Yellow;font-weight: bold;'>" + myList[i].Status + "</td>";
                                }
                            }
                            else {
                                if ($("[id*=chkMy]").is(':checked') != true) {
                                    tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + myList[i].Status + "' /><input type='checkbox' class='Chkbox' id='chkclt'  name='chkclt' value='" + myList[i].TSId + "' /></td>";
                                    tbl = tbl + "<td style='text-align: center;'> <i class='icon-compose mr-2 ' data-toggle='modal' data-target='#modal_h3' onclick='OpenReason($(this))' style='cursor: pointer;'></i>"
                                        + "<input type='hidden' id='hdnResn_tsid_" + myList[i].TSID + "' name='hdnResn_tsid_" + $(this).find("TSID").text() + "' value='' >"
                                        + "<input type='hidden' id='hdnResn' name='hdnResn' value='" + myList[i].Reason + "' ' ></td>";
                                } else {
                                    if (myList[i].MyTS == 1) {
                                        tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + myList[i].Status + "' /><input type='checkbox' class='Chkbox' id='chkclt'  name='chkclt' value='" + myList[i].TSId + "' /></td>";
                                    } else {
                                        if (myList[i].Status == 'Submitted') {
                                            tbl = tbl + "<td style='text-align: left;color: orange;font-weight: bold;'>" + myList[i].Status + "</td>";
                                        }
                                        else if (myList[i].Status == 'Saved') {
                                            tbl = tbl + "<td style='text-align: left;color: SkyBlue;font-weight: bold;'>" + myList[i].Status + "</td>";
                                        }
                                        else if (myList[i].Status == 'Approved') {
                                            tbl = tbl + "<td style='text-align: left;color: LimeGreen;font-weight: bold;'>" + myList[i].Status + "</td>";
                                        }
                                        else if (myList[i].Status == 'Rejected') {
                                            tbl = tbl + "<td style='text-align: center;color: IndianRed;font-weight: bold;'>" + myList[i].Status + "";
                                            if (myList[i].Reason != '') {
                                                tbl = tbl + "<input type='hidden' id ='hdnReason' name ='hdnReason' value ='" + myList[i].Reason + "'/>"
                                                    + "<br><i class='icon-bubble-lines4 mr-1' data-toggle='modal' data-target='#modal_Reason' onclick='ReasonPopup($(this))' />"
                                                    + "</td>";
                                            }
                                            else { tbl = tbl + "</td>"; }
                                        }
                                        else if (myList[i].Status == 'Semi Approved') {
                                            tbl = tbl + "<td style='text-align: left;color: Yellow;font-weight: bold;'>" + myList[i].Status + "</td>";
                                        }
                                    }
                                }
                            }
                            if ($("[id*=hdnRolename]").val() == 'Staff') {
                                if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                                    if (myList[i].Status == 'Approved') {
                                        tbl = tbl + "<td style='text-align: center'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                    }
                                    else {
                                        tbl = tbl + "<td style='text-align: center'><div class='list-icons'><div class='dropdown'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='- 1'><i class='icon-more2'></i></a><div class='dropdown-menu dropdown-menu-right'><a href='#' data-toggle='modal' data-target='#modalEditTS2lvl' onclick='edit2LvlTsdata($(this), " + myList[i].TSId + ")' name='edit' class='dropdown-item'><i class='far fa-edit' style='cursor: pointer;font-size:1rem;color:#00acc1'></i>&nbsp;Edit<input type='hidden'  id='hdneditdt' name='hdneditdt' value=" + myList[i].Dt + " /></a><a href='#' onclick='deletesavedTimesheet(" + myList[i].TSId + ")' name='delete' class='dropdown-item'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1rem;color:red'></i>&nbsp;Delete</a><a href='#' name='Expense' data-toggle='modal' data-target='#ModalExpenseId' class='dropdown-item' onclick='editTsExpense(" + myList[i].TSId + ",$(this))'><i class='fas fa-rupee-sign text-purple-600'></i>&nbsp;Expense</a></div></div></div></td>";
                                    }
                                }
                            }
                            else if ($("[id*=hdnRolename]").val() == 'Approver') {
                                if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                                    if (ChckMyTS == true) {
                                        if (myList[i].Status == 'Approved') {
                                            tbl = tbl + "<td style='text-align: center'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                        }
                                        else {
                                            if (Staffcode === $("[id*=hdnEditStaffcode]").val()) {
                                                tbl = tbl + "<td style='text-align: center'><div class='list-icons'><div class='dropdown'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='- 1'><i class='icon-more2'></i></a><div class='dropdown-menu dropdown-menu-right'><a href='#' data-toggle='modal' data-target='#modalEditTS2lvl' onclick='edit2LvlTsdata($(this), " + myList[i].TSId + ")' name='edit' class='dropdown-item'><i class='far fa-edit' style='cursor: pointer;font-size:1rem;color:#00acc1'></i>&nbsp;Edit<input type='hidden'  id='hdneditdt' name='hdneditdt' value=" + myList[i].Dt + " /></a><a href='#' onclick='deletesavedTimesheet(" + myList[i].TSId + ")' name='delete' class='dropdown-item'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1rem;color:red'></i>&nbsp;Delete</a><a href='#' name='Expense' data-toggle='modal' data-target='#ModalExpenseId' class='dropdown-item' onclick='editTsExpense(" + myList[i].TSId + ",$(this))'><i class='fas fa-rupee-sign text-purple-600'></i>&nbsp;Expense</a></div></div></div></td>";
                                            }
                                            else {
                                                tbl = tbl + "<td style='text-align: center'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                            }
                                        }
                                    }
                                }
                            }


                            tbl = tbl + "</tr>";
                        };
                        $("[id*=tbl_PendingTS]").append(tbl);
                        Pager(RecordCount);
                        if (RecordCount >= minPageSize) {
                            Pager(RecordCount);
                            $("#divPageSize_Pending").css({ 'display': 'block' });
                            $("[id*=tblPager_Pending]").show();
                        }
                        else {
                            Pager(0);
                            $("[id*=divPageSize_Pending]").hide();
                            $("[id*=tblPager_Pending]").hide();
                        }
                        Blockloaderhide();
                    } else {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        if ($("[id*=hdnPageLevel]").val() > 3) {

                            tbl = tbl + "<td></td>";
                        }
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        if ($("[id*=hdnExpense]").val() == 'True') {
                            tbl = tbl + "<td></td>";
                        }
                        tbl = tbl + "</tr>";
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td colspan='13' style='text-align:center;'>No Record Found !!!</td>";
                        tbl = tbl + "</tr>";
                        $("[id*=tbl_PendingTS]").append(tbl);
                        Pager(0);
                        $("[id*=tblPager_Pending]").hide();
                        Blockloaderhide();
                    }

                    $("#chkShowNarrationMessage:not(:checked)").each(function () {
                        var column = "table ." + $(this).attr("name");
                        $(column).hide();
                    });
                },
                failure: function (response) {
                    showDangerAlert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    showDangerAlert('Error Occoured ' + response.d);
                }
            });
        }


        ////Dual Approver Timesheet 3 level
        function DualAppBind_Timesheets() {
            Blockloadershow();
            //var compid = $("[id*=hdnCompanyid]").val();
            var muti = $("[id*=hdnPageLevel]").val();
            var cltid = $("[id*=drpclient3]").val();
            var deptId = $("[id*=ddlDept]").val();
            var projectid = $("[id*=drpProj]").val();
            var mjobid = $("[id*=drpMjob3]").val();
            var Sid = $("[id*=drpstaff3]").val();
            //var frtime = $("[id*=txtdateBindStaff]").val().split('-')[0];
            //var totime = $("[id*=txtdateBindStaff]").val().split('-')[1];
            var frtime = $("[id*=hdnFromdate]").val();
            var totime = $("[id*=hdnTodate]").val();
            var status = $("[id*=drpstatus]").val();
            var Staffcode = $("[id*=hdnEditStaffcode]").val();
            var Staffrole = $("[id*=hdnRolename]").val();
            var task = 0;
            if ($("[id*=hdnPageLevel]").val() == '4') {
                task = $("[id*=drpTask]").val();
            }
            var mmdd = CompanyPermissions[0].mmddyyyy;
            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/getDualApproverTimesheets",
                data: '{cltid:"' + cltid + '",projectid:"' + projectid + '",mjobid:"' + mjobid + '",staffcode:"' + Staffcode + '",frtime:"' + frtime + '",totime:"' + totime + '",status:"' + status + '",Sid:' + Sid + ',Staffrole:"' + Staffrole + '",deptid:"' + deptId + '",pageIndex:' + $("[id*=hdnPages]").val() + ',pageSize:' + $("[id*=hdnSize]").val() + ',mmdd:' + mmdd + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: OnSuccess,
                failure: function (response) {
                    showDangerAlert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    showDangerAlert('Error Occoured ' + response.d);
                }
            });
        }

        ///////////////// All/ Approved Timesheet
        function Bind_Timesheets() {
            Blockloadershow();
            //var compid = $("[id*=hdnCompanyid]").val();
            var muti = $("[id*=hdnPageLevel]").val();
            var cltid = $("[id*=drpclient3]").val();
            var deptId = $("[id*=ddlDept]").val();
            var projectid = $("[id*=drpProj]").val();
            var mjobid = $("[id*=drpMjob3]").val();
            var Sid = $("[id*=drpstaff3]").val();
            var frtime = $("[id*=hdnFromdate]").val();
            var totime = $("[id*=hdnTodate]").val();
            var status = $("[id*=drpstatus]").val();
            var Staffcode = $("[id*=hdnEditStaffcode]").val();
            var Staffrole = $("[id*=hdnRolename]").val();
            var ChckMyTS = $("[id*=chkMy]").is(':checked');
            $("[id*=hdnmyStatus]").val(ChckMyTS);
            var task = 0;
            if ($("[id*=hdnPageLevel]").val() == '4') {
                task = $("[id*=drpTask]").val();
            }
            if (!deptId) {
                deptId = 0;
            }
            var mmdd = CompanyPermissions[0].mmddyyyy;
            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/bind_timesheets",
                data: '{cltid:"' + cltid + '",projectid:"' + projectid + '",mjobid:"' + mjobid + '",staffcode:"' + Staffcode + '",frtime:"' + frtime + '",totime:"' + totime + '",status:"' + status + '",muti:' + muti + ',task:"' + task + '",Sid:' + Sid + ',Staffrole:"' + Staffrole + '",ChckMyTS:"' + ChckMyTS + '",deptId:"' + deptId + '",pageIndex:' + $("[id*=hdnPages]").val() + ',pageSize:' + $("[id*=hdnSize]").val() + ', mmdd:' + mmdd + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: OnSuccess,

                failure: function (response) {
                    Blockloaderhide();
                    showDangerAlert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    Blockloaderhide();
                    showDangerAlert('Error Occoured ' + response.d);
                }
            });
        }

        function OnSuccess(responce) {
            var RecordCount = 0;
            var xmlDoc = $.parseXML(responce.d);
            var xml = $(xmlDoc);
            var myList = xml.find("Table");
            var allTotalTime = xml.find("Table1");
            var Staffcode = $("[id*=hdnEditStaffcode]").val();
            var Staffrole = $("[id*=hdnRolename]").val();
            var ChckMyTS = $("[id*=chkMy]").is(':checked');
            var selectstatus = $("[id*=drpstatus]").val();
            if (allTotalTime.length > 0) {
                $.each(allTotalTime, function () {
                    if ($(this).find("AllTotal").text() == 'All Total') {
                        $("[id*=lblTotalHrs]").html($(this).find("TotalTimeMin").text());
                        $("[id*=lblTotalBillHrs]").html($(this).find("TotalTimeBillMin").text());
                        $("[id*=lblTotalNonBillHrs]").html($(this).find("TotaltimeNonBill").text());
                    }
                });
            }

            var tbl = '';
            $("[id*=tbl_AllTimesheet] tbody").empty();
            $("[id*=tbl_AllTimesheet] thead").empty();

            tbl = tbl + "<thead><tr>";
            tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Date</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Submit Date</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Staff</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Project</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Activity</th>";
            if ($("[id*=hdnPageLevel]").val() > 3) {
                tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Task</th>";
            }
            tbl = tbl + "<th style='font-weight: bold;'>Time</th>";
            if (CompanyPermissions[0].Edit_Billing_Hrs == true) {
                tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Edit Hrs</th>";
            }
            tbl = tbl + "<th style='font-weight: bold;' id='thNarrationIcon' class='chkShowNarrationIcon'>Narration</th>";
            tbl = tbl + "<th style='font-weight: bold;' id='thNarrationMessage' class='chkShowNarrationMessage'>Narration</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Billable</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Status</th>";

            if (selectstatus == 'Approved' || selectstatus == 'All') {
                tbl = tbl + "<th style='font-weight: bold;'>Approver</th>";
            }

            tbl = tbl + "<th style='font-weight: bold;'>Apprd Date</th>";

            //if ($("[id*=hdnRolename]").val() == 'Staff' || $("[id*=hdnRolename]").val() == 'Approver' ) {
            if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                if ($("[id*=hdnRolename]").val() == 'Approver' && ChckMyTS == true) {
                    tbl = tbl + "<th style='font-weight: bold;'>Delete</th>";
                }
                else if ($("[id*=hdnRolename]").val() == 'Staff') {
                    tbl = tbl + "<th style='font-weight: bold;'>Delete</th>";
                }
                else if ($("[id*=hdnRolename]").val() == '') {
                    tbl = tbl + "<th style='font-weight: bold;'>Delete</th>";
                }

            }
            //}

            if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
            } else {
                if (selectstatus == 'Approved') {
                    tbl = tbl + "<th style='text-align:left;'></th>";
                    $("[id*=btnStatusAppr]").show();
                    $("[id*=btnStatusReject]").show();
                    $("[id*=chkApprovedAll]").show();
                    $("[id*=lblAppr]").show();
                }
                else {
                    $("[id*=btnStatusAppr]").hide();
                    $("[id*=btnStatusReject]").hide();
                    $("[id*=chkApprovedAll]").hide();
                    $("[id*=lblAppr]").hide();
                }
            }


            tbl = tbl + "</tr></thead>";
            if (myList.length > 0) {
                $.each(myList, function (i, va) {
                    var p = $(this);
                    RecordCount = $(this).find("TotalCount").text();
                    if ($(this).find("MJobName").text() == 'Total') {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td style='text-align: left;font-weight: bold;'>" + $(this).find("MJobName").text() + "</td>";
                        if ($("[id*=hdnPageLevel]").val() > 3) {
                            tbl = tbl + "<td></td>";
                        }
                        tbl = tbl + "<td style='text-align: left;font-weight: bold;'>" + $(this).find("TotalTime").text() + "</td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        if ($("[id*=hdnExpense]").val() == 'True') {
                            tbl = tbl + "<td></td>";
                        }
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "</tr>";
                    } else {
                        var dt = moment($(this).find("Date").text());
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td style='text-align: center;'>" + $(this).find("SrNo").text() + "<input type='hidden' id='hdnATSid' value='" + $(this).find("TSID").text() + "' name='hdnATSid'></td>";

                        if (CompanyPermissions[0].mmddyyyy == 0) {
                            tbl = tbl + "<td style='text-align: left;'>" + $(this).find("Date").text() + "<div class='text-center'>" + getDayName($(this).find("Date").text()) + "</div></td>";
                            tbl = tbl + "<td style='text-align: left;'>" + $(this).find("Submitted_Date").text() + "</td>";
                        }
                        else {
                            var year;
                            var month;
                            var day;
                            var dt = $(this).find("Date").text();
                            dt = dt.split('/');
                            year = dt[2], month = dt[1], day = dt[0];
                            dt = month + '/' + day + '/' + year;

                            tbl = tbl + "<td style='text-align: left;'>" + dt + "<div class='text-center'>" + getDayName($(this).find("Date").text()) + "</div></td>";
                            dt = $(this).find("Submitted_Date").text();
                            if (dt != '') {
                                dt = dt.split('/');
                                year = dt[2], month = dt[1], day = dt[0];
                                dt = month + '/' + day + '/' + year;
                            }
                            tbl = tbl + "<td style='text-align: left;'>" + dt + "</td>";

                        }
                        tbl = tbl + "<td style='text-align: left;'>" + $(this).find("StaffName").text() + "<input type='hidden' id='hdnTStaffCode' value='" + $(this).find("staffCode").text() + "' name='hdnTStaffCode'><input type='hidden' id='hdnEditClientId' name='hdnEditClientId' value='" + $(this).find("CLTId").text() + "'/><input type='hidden' id='hdnJid' name='hdnJid' value='" + $(this).find("JobId").text() + "'/></td>";

                        tbl = tbl + "<td style='text-align: left;'>" + $(this).find("ProjectName").text() + "<input type='hidden' id='hdnClient' value='" + $(this).find("ClientName").text() + "' name='hdnClient'><input type='hidden' id='hdnProject' value='" + $(this).find("ProjectName").text() + "' name='hdnProject'><input type='hidden' id='hdnEditPojectId' name='hdnEditPojectId' value='" + $(this).find("Project_Id").text() + "'/></td>";
                        tbl = tbl + "<td style='text-align: left;'>" + $(this).find("MJobName").text() + "<input type='hidden' id='hdnJobname' value='" + $(this).find("MJobName").text() + "' name='hdnJobname'><input type='hidden' id='hdnEdiJobId' name='hdnEdiJobId' value='" + $(this).find("mJob_Id").text() + "'/></td>";
                        if ($("[id*=hdnPageLevel]").val() > 3) {
                            tbl = tbl + "<td style='text-align: left;'>" + $(this).find("TaskName").text() + "</td>";
                        }

                        if (CompanyPermissions[0].Edit_Billing_Hrs == true) {
                            if ($(this).find("Billable").text() == 'true') {
                                var tTime = $(this).find("TotalTime").text();
                                var totTime = tTime.split('.');
                                var totHrs = '';
                                if (totTime[0].length == 1) {
                                    totHrs = '0' + totTime[0];
                                }
                                else {
                                    totHrs = totTime[0]
                                }
                                var totalTime = totHrs + '.' + totTime[1];

                                if (CompanyPermissions[0].SwapEdit == false) {
                                    tbl = tbl + "<td style='text-align: left;'>" + totalTime + "<input type='hidden' id='hdnTotTime' value='" + totalTime + "' name='hdnTotTime'></td>";
                                    tbl = tbl + "<td style='width: 70px;'>" + $(this).find("EditedBilling_Hrs").text() + "</td> ";
                                }
                                else {
                                    ///Swaping of the column
                                    tbl = tbl + "<td style='text-align: left;'>" + $(this).find("EditedBilling_Hrs").text() + "</td>";
                                    tbl = tbl + "<td style='width: 70px;'>" + totalTime + "<input type='hidden' id='hdnTotTime' value='" + totalTime + "' name='hdnTotTime'></td> ";
                                }
                            }
                            else {
                                var tTime = $(this).find("TotalTime").text();
                                var totTime = tTime.split('.');
                                var totHrs = '';
                                if (totTime[0].length == 1) {
                                    totHrs = '0' + totTime[0];
                                }
                                else {
                                    totHrs = totTime[0]
                                }
                                var totalTime = totHrs + '.' + totTime[1];

                                tbl = tbl + "<td style='text-align: left;'>" + totalTime + "<input type='hidden' id='hdnTotTime' value='" + totalTime + "' name='hdnTotTime'></td>";
                                tbl = tbl + "<td style='width: 70px;'>" + $(this).find("EditedBilling_Hrs").text() + "</td> ";
                            }
                        }
                        else {
                            var tTime = $(this).find("TotalTime").text();
                            var totTime = tTime.split('.');
                            var totHrs = '';
                            if (totTime[0].length == 1) {
                                totHrs = '0' + totTime[0];
                            }
                            else {
                                totHrs = totTime[0]
                            }
                            var totalTime = totHrs + '.' + totTime[1];
                            tbl = tbl + "<td style='text-align: left;'>" + totalTime + "<input type='hidden' id='hdnTotTime' value='" + totalTime + "' name='hdnTotTime'></td>";

                        }

                        if ($(this).find("Narration").text() == '') {
                            tbl = tbl + "<td style='text-align: center;' class='chkShowNarrationIcon'><i class='icon-bubble9 mr-1 '></i></td>";
                        } else {
                            tbl = tbl + "<td style='text-align: center;cursor: pointer;' class='chkShowNarrationIcon'><i class='icon-bubble-lines4 mr-1 ' onclick='OpenNarration($(this))' data-toggle='modal' data-target='#modal_h3' ></i><input type='hidden' id='hdnNarr' value='" + $(this).find("Narration").text() + "' name='hdnNarr'></td>";
                            // tbl = tbl + "<td style='text-align: left;'>" + myList[i].Narration + "</td>";
                        }
                        tbl = tbl + "<td style='text-align: left;' id='tdNarrationMessage' class='chkShowNarrationMessage'>" + $(this).find("Narration").text() + "</td>";

                        if ($(this).find("Billable").text() == 'true') {
                            tbl = tbl + "<td style='text-align: center;cursor: pointer;'> <i class='icon-checkmark2 mr-3 icon-2x' style='color: green;'></i><input type='hidden'  id='hdnBillable' name='hdnBillable' value=" + $(this).find("Billable").text() + " /></td>";
                            //bill = 'Yes';
                        } else {
                            tbl = tbl + "<td style='text-align: center;cursor: pointer;'>  <i class='icon-cross3 mr-3 icon-2x' style='color: red;'></i><input type='hidden'  id='hdnBillable' name='hdnBillable' value=" + $(this).find("Billable").text() + " /></td>";
                        }

                        if ($(this).find("Status").text() == 'Submitted') {
                            tbl = tbl + "<td style='text-align: left;color: orange;font-weight: bold;'>" + $(this).find("Status").text() + "<input type='hidden' id='hdnStatus' value='" + $(this).find("Status").text() + "' name='hdnStatus'></td>";
                        }
                        else if ($(this).find("Status").text() == 'Saved') {
                            tbl = tbl + "<td style='text-align: left;color: SkyBlue;font-weight: bold;'>" + $(this).find("Status").text() + "<input type='hidden' id='hdnStatus' value='" + $(this).find("Status").text() + "' name='hdnStatus'></td>";
                        }
                        else if ($(this).find("Status").text() == 'Approved') {
                            tbl = tbl + "<td style='text-align: center;color: LimeGreen;font-weight: bold;'>" + $(this).find("Status").text() + "<input type='hidden' id='hdnStatus' value='" + $(this).find("Status").text() + "' name='hdnStatus'>"
                            if ($(this).find("Reason").text() != '') {
                                tbl = tbl + "<input type = 'hidden' id = 'hdnReason' name = 'hdnReason' value = '" + $(this).find("Reason").text() + "' />"
                                    + " <br><i class='icon-bubble-lines4 mr-1' data-toggle='modal' data-target='#modal_Reason' onclick='ReasonPopup($(this))' >"
                                    + "</td>";
                            }
                            else { tbl = tbl + "</td>"; }
                        }
                        else if ($(this).find("Status").text() == 'Rejected') {
                            tbl = tbl + "<td style='text-align: center;color: IndianRed;font-weight: bold;'>" + $(this).find("Status").text() + "<input type='hidden' id='hdnStatus' value='" + $(this).find("Status").text() + "' name='hdnStatus'>"
                            if ($(this).find("Reason").text() != '') {
                                tbl = tbl + "<input type = 'hidden' id = 'hdnReason' name = 'hdnReason' value = '" + $(this).find("Reason").text() + "' />"
                                    + " <br><i class='icon-bubble-lines4 mr-1' data-toggle='modal' data-target='#modal_Reason' onclick='ReasonPopup($(this))' >"
                                    + "</td>";
                            }
                            else { tbl = tbl + "</td>"; }
                        }
                        else if ($(this).find("Status").text() == 'Semi Approved') {
                            tbl = tbl + "<td style='text-align: left;color: Yellow;font-weight: bold;'>" + $(this).find("Status").text() + "<input type='hidden' id='hdnStatus' value='" + $(this).find("Status").text() + "' name='hdnStatus'></td>";
                        }

                        if (selectstatus == 'Approved' || selectstatus == 'All') {
                            tbl = tbl + "<td style='text-align: left;'>" + $(this).find("JobApproverName").text() + "</td>";
                        }

                        tbl = tbl + "<td style='text-align: left;'>" + $(this).find("Approved_Date").text() + "</td>";

                        if ($("[id*=hdnRolename]").val() == 'Staff') {
                            if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                                if ($(this).find("Status").text() == 'Approved') {
                                    tbl = tbl + "<td style='text-align: center;'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                }
                                else {
                                    tbl = tbl + "<td style='text-align: center;'><a href='#' onclick='deletesavedTimesheet(" + $(this).find("TSID").text() + ")' name='delete' class='dropdown-item'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1rem;color:red'></i></a></td>";
                                }
                            }
                        }
                        else if ($("[id*=hdnRolename]").val() == 'Approver') {
                            if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                                if (ChckMyTS == true) {
                                    if ($(this).find("Status").text() == 'Approved') {
                                        tbl = tbl + "<td style='text-align: center;'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                    }
                                    else {
                                        if ($(this).find("staffCode").text() === $("[id*=hdnEditStaffcode]").val()) {
                                            tbl = tbl + "<td style='text-align: center;'><a href='#' onclick='deletesavedTimesheet(" + $(this).find("TSID").text() + ")' name='delete' class='dropdown-item'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1rem;color:red'></i></a></td>";
                                        }
                                        else {
                                            tbl = tbl + "<td style='text-align: center;'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                        }
                                    }
                                }
                            }
                        }
                        else if ($("[id*=hdnRolename]").val() == '') {

                            tbl = tbl + "<td style='text-align: center;'><a href='#' onclick='deletesavedTimesheet(" + $(this).find("TSID").text() + ")' name='delete' class='dropdown-item'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1rem;color:red'></i></a></td>";
                        }

                        if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                        } else {
                            if (selectstatus == 'Approved') {
                                tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + $(this).find("Status").text() + "' /><input type='checkbox' class='Chkbox' id='chkcltApp'  name='chkcltApp' value='" + $(this).find("TSID").text() + "' /></td>";
                            }
                        }
                        tbl = tbl + "</tr>";
                    }
                });

                $("[id*=tbl_AllTimesheet]").append(tbl);
                Pager(RecordCount);
                if (RecordCount >= minPageSize) {
                    Pager(RecordCount);
                    $("#divPageSize_AllApproved").css({ 'display': 'block' });
                    $("[id*=tblPager_AllApproved]").show();
                }
                else {
                    Pager(0);
                    $("[id*=divPageSize_AllApproved]").hide();
                    $("[id*=tblPager_AllApproved]").hide();
                }
                Blockloaderhide();
            } else {
                tbl = tbl + "<tr>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                if ($("[id*=hdnPageLevel]").val() > 3) {
                    tbl = tbl + "<td></td>";
                }
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "</tr>";
                tbl = tbl + "<tr>";
                tbl = tbl + "<td colspan='14' style='text-align:center;'>No Record Found !!!</td>";
                tbl = tbl + "</tr>";
                $("[id*=tbl_AllTimesheet]").append(tbl);
                Pager(0);
                Blockloaderhide();
            }

            $("#chkShowNarrationMessage:not(:checked)").each(function () {
                var column = "table ." + $(this).attr("name");
                $(column).hide();
            });
        }

        function getDayName(dateString) {
            var dateParts = dateString.split("/");
            var dateObject = new Date(+dateParts[2], dateParts[1] - 1, +dateParts[0]);
            var dt = moment(dateObject, "YYYY-MM-DD").toDate();
            return dayName = dt.format('dddd').substring(0, 3);
        }

        $("input:checkbox:not(:checked)").each(function () {
            var column = "table ." + $(this).attr("name");
            $(column).hide();
        });

        $("input:checkbox").click(function () {
            var column = "table ." + $(this).attr("name");
            $(column).toggle();
        });

        ///3/4 Level Reason
        function OpenReason(i) {
            var row = i.closest("tr");
            $("[id*=h3Narrat]").html('Reason');
            var Tsid = $("#hdnATSid", row).val();
            var Resn = $("#hdnResn_tsid_" + Tsid).val();
            $("[id*=htsid]").val(Tsid);
            var dt = $("td", row.closest("tr")).eq(1).html();
            var proj = $("td", row.closest("tr")).eq(4).html();
            var job = $("td", row.closest("tr")).eq(5).html();
            var staff = ''; totl = '';
            if ($("[id*=hdnPageLevel]").val() > 3) {
                staff = $("td", row.closest("tr")).eq(3).html();
                totl = $("td", row.closest("tr")).eq(6).html();
            } else {
                staff = $("td", row.closest("tr")).eq(3).html();
                totl = $("td", row.closest("tr")).eq(6).html();
            }
            var reason = $("#hdnResn", row).val();
            $("[id*=lblnrrdt]").html(dt);
            $("[id*=lblnrrPJ]").html(proj + '/' + job);
            $("[id*=lblnrrSf]").html(staff);
            $("[id*=lblnrrTT]").html(totl);
            $("[id*=pNarr]").hide();
            $("[id*=txtResn]").show();
            $("[id*=Save3Reson]").show();
            $("[id*=txtResn]").val(reason);
        }

        ///2Level Reason
        function Open2Reason(i) {
            var row = i.closest("tr");
            $("[id*=h2Narrat]").html('Reason');
            var Tsid = $("#hdnATSid", row).val();
            var Resn = $("#hdnResn_tsid_" + Tsid).val();
            $("[id*=htsid]").val(Tsid);

            var dt = $("td", row.closest("tr")).eq(1).html();
            var proj = $("td", row.closest("tr")).eq(4).html();
            var job = $("td", row.closest("tr")).eq(5).html();
            var staff = ''; totl = '';

            staff = $("td", row.closest("tr")).eq(3).html();
            totl = $("td", row.closest("tr")).eq(6).html();
            $("[id*=tdnrrdt]").html(dt);
            $("[id*=tdnrrPJ]").html(proj + '/' + job);
            $("[id*=tdnrrSf]").html(staff);
            $("[id*=tdnrrTT]").html(totl);
            $("[id*=p2lblNarr]").hide();
            $("[id*=txt2Resn]").show();
            $("[id*=Save2Reson]").show();
            $("[id*=txt2Resn]").val(Resn);
        }

        ///3/4 Level Narration
        function OpenNarration(i) {
            var row = i.closest("tr");
            $("[id*=h3Narrat]").html('Narration');
            var Narr = row.find("input[name=hdnNarr]").val();
            var dt = $("td", row.closest("tr")).eq(1).html();
            var proj = $("td", row.closest("tr")).eq(4).html();
            var job = $("td", row.closest("tr")).eq(5).html();
            var staff = ''; totl = '';
            if ($("[id*=hdnPageLevel]").val() > 3) {
                staff = $("td", row.closest("tr")).eq(3).html();
                totl = $("td", row.closest("tr")).eq(6).html();
            } else {
                staff = $("td", row.closest("tr")).eq(3).html();
                totl = $("td", row.closest("tr")).eq(6).html();
            }

            $("[id*=lblnrrdt]").html('');
            $("[id*=lblnrrPJ]").html('');
            $("[id*=lblnrrSf]").html('');
            $("[id*=lblnrrTT]").html('');
            $("[id*=lblnrrdt]").html(dt);
            $("[id*=lblnrrPJ]").html(proj + '/' + job);
            $("[id*=lblnrrSf]").html(staff);
            $("[id*=lblnrrTT]").html(totl);
            $("[id*=pNarr]").show();
            $("[id*=txtResn]").hide();
            $("[id*=Save3Reson]").hide();
            $("[id*=pNarr]").html(Narr);
        }

        ///Update Timesheet for 2 level on Edit Timesheet
        function UpdateTimehseet() {
            //var Compid = $("[id*=hdnCompanyid]").val();
            var TSID = $("[id*=htsid]").val();
            var FrTim = $("[id*=txtfromtime]").val();
            var ToTim = $("[id*=txtTotime]").val();
            var Totime = $("[id*=txtTotaltime]").val();
            var Narr = $("[id*=txtEditNarr]").val();
            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/UpdateTimehseet",
                data: '{TSID:' + TSID + ',FrTim:"' + FrTim + '",ToTim:"' + ToTim + '",Totalime:"' + Totime + '",Narr:"' + Narr + '"}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList[0].mjobid > 0) {
                        showSuccessAlert('Timesheet Updatede Successfully !!!');
                        $('#modalEditTS2lvl').modal('hide');
                        Pending_2Timesheets();
                    }
                },
                failure: function (response) {
                    showDangerAlert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    showDangerAlert('Error Occoured ' + response.d);
                }
            });
        }

        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode == 46) {
            }
            else if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }

        function validateDecimalNumber(Number) {
            Number.value = Number.value.replace(/[^0-9\.]/g, '');
        }

        //Edit Timesheet only for 2 Level
        function OpenEditTS(i) {
            var row = i.closest("tr");
            var Narr = row.find("input[name=hdnNarr]").val();
            var dt = $("td", row.closest("tr")).eq(1).html();
            var proj = $("td", row.closest("tr")).eq(3).html();
            var job = $("td", row.closest("tr")).eq(4).html();
            var staff = $("td", row.closest("tr")).eq(2).html();
            var Status = row.find("input[name=hdnStatus]").val();
            var Ft = $("td", row.closest("tr")).eq(5).html();
            var Totime = $("td", row.closest("tr")).eq(6).html();
            var TotalTime = $("td", row.closest("tr")).eq(7).html();
            var Tsid = $("#hdnATSid", row).val();
            $("[id*=htsid]").val(Tsid);
            $("[id*=lblclt]").html(proj + '/' + job);
            $("[id*=lblstaff]").html(staff);
            $("[id*=lblStatus]").html(Status);
            $("[id*=spandt]").html(dt);
            $("[id*=txtEditNarr]").val(Narr);
            $("[id*=txtfromtime]").val(Ft);
            $("[id*=txtTotime]").val(Totime);
            $("[id*=txtTotaltime]").val(TotalTime);
        }

        /////////delete saved timesheet
        function deletesavedTimesheet(tsid) {
            var notice = new PNotify({
                title: 'Confirmation',
                text: '<p>Are you sure you want to delete record?</p>',
                hide: false,
                type: 'warning',
                confirm: {
                    confirm: true,
                    buttons: [
                        {
                            text: 'Yes',
                            addClass: 'btn btn-sm btn-primary'
                        },
                        {
                            addClass: 'btn btn-sm btn-link'
                        }
                    ]
                },
                buttons: {
                    closer: false,
                    sticker: false
                }
            });

            // On confirm
            notice.get().on('pnotify.confirm', function () {
                DeleteRecord(tsid);
            })

            // On cancel
            notice.get().on('pnotify.cancel', function () {
            });
        }

        function DeleteRecord(tsid) {
            var TSID = tsid;
            var staffcode = $("[id*=hdnEditStaffcode]").val();
            //var compid = $("[id*=hdnCompanyid]").val();

            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/deletesavedTimesheet",
                data: '{TSID:' + TSID + ',staffcode:' + staffcode + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (response) {
                    if (response.d == "success") {
                        showSuccessAlert("Timesheet deleted successfully");
                        chkStatus();
                    }
                },
                failure: function (response) {
                    showDangerAlert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    showDangerAlert('Error Occoured ' + response.d);
                }
            });
        }

        function editTsdata(i, tsid) {
            $("[id*=dvmJob]").hide();
            $("[id*=hdnEdittsid]").val(tsid);
            $("[id*=dvAct]").show();
            $("[id*=hdn2lvl]").val('');
            var row = i.closest("tr");
            var dt = row.find("input[name=hdneditdt]").val();
            var billable = row.find("input[name=hdnBillable]").val();
            $("[id*=hdnedDate]").val(dt);
            var d = i.closest("tr").find('td:eq(2)').html();
            d = 'Edit Timesheet  ' + " &nbsp &nbsp &nbsp &nbsp" + d;
            $("#editdate").html(d);
            var clt = row.find("input[name=hdnClient]").val();
            $("#editclientname").html(clt);
            var jb = row.find("input[name=hdnJobname]").val();
            $("#editproject").html(row.find("input[name=hdnProject]").val());
            var pid = row.find("input[name=hdnEditPojectId]").val();
            $("#editjobname").html(jb);
            var hdnSfCode = row.find("input[name=hdnTStaffCode]").val();
            $("[id*=hdnTStfcode]").val(hdnSfCode);
            $("#TxtedtTottime").val(row.find("input[name=hdnTotTime]").val());
            $("#editstatus").html(row.find("input[name=hdnStatus]").val());
            $("[id*=hdnEJobid]").val(row.find("input[name=hdnJid]").val());
            $("[id*=hdnmjid]").val(row.find("input[name=hdnEdiJobId]").val());
            var cltid = 0;
            ////var pid = 0;
            var jid = 0;
            cltid = row.find("input[name=hdnEditClientId]").val();
            ////pid = row.find("input[name=hdnEditPojectId]").val();
            jid = row.find("input[name=hdnJid]").val();
            if (billable == 'true') {
                $("#editChk").attr('checked', 'true');
            }
            else {
                $("#editChk").removeAttr('checked');
            }
            var nr = row.find("input[name=hdnNarr]").val();
            $("#editnarration").val(row.find("input[name=hdnNarr]").val());
            var length = row.find("input[name=hdnNarr]").length + 1;
            var maxLen = 900;
            var AmountLeft = maxLen - length;
            $("[id*=txt-narr-length-left]").html(AmountLeft);
            bindjobForEdit(cltid, pid, hdnSfCode);
            var iji = row.find("input[name=hdnEdiJobId]").val();
            $("#ddlEditJob_").val(iji);
            $("#ddlEditJob_").trigger('change');
        }

        function edit2LvlTsdata(i, tsid) {
            $("[id*=dvmJob]").show();
            $("[id*=dvAct]").hide();
            $("[id*=dvprj]").hide();
            $("[id*=hdnEdittsid]").val(tsid);
            $("[id*=hdn2lvl]").val('2');
            var row = i.closest("tr");
            var dt = row.find("input[name=hdneditdt]").val();
            var billable = row.find("input[name=hdnBillable]").val();
            var d = i.closest("tr").find('td:eq(2)').html();
            var clt = row.find("input[name=hdnClient]").val();
            var jb = row.find("input[name=hdnJobname]").val();
            var hdnSfCode = row.find("input[name=hdnTStaffCode]").val();
            var cltid = 0;
            var jid = 0;
            var nr = row.find("input[name=hdnNarr]").val();
            var length = row.find("input[name=hdnNarr]").val().length + 1;
            var maxLen = 900;
            var AmountLeft = maxLen - length;
            var iji = row.find("input[name=hdnEdiJobId]").val();
            ////var mjid = hdnEdiJobId
            var mjid = row.find("input[name=hdnEdiJobId]").val();
            $("[id*=editproject]").val(jb);
            $("[id*=hdnedDate]").val(dt);
            d = 'Edit Timesheet  ' + " &nbsp &nbsp &nbsp &nbsp" + d;
            $("#editdate").html(d);
            $("#editclientname").html(clt);
            $("#editjobname").html(jb);
            $("[id*=hdnTStfcode]").val(hdnSfCode);
            $("#TxtedtTottime").val(row.find("input[name=hdnTotTime]").val());
            $("#editstatus").html(row.find("input[name=hdnStatus]").val());
            $("[id*=hdnEJobid]").val(row.find("input[name=hdnJid]").val());
            $("[id*=hdnmjid]").val(row.find("input[name=hdnEdiJobId]").val());
            cltid = row.find("input[name=hdnEditClientId]").val();
            jid = row.find("input[name=hdnJid]").val();
            if (billable == 'true') {
                $("#editChk").attr('checked', 'true');
            }
            else {
                $("#editChk").removeAttr('checked');
            }

            $("#editnarration").val(row.find("input[name=hdnNarr]").val());

            $("[id*=txt-narr-length-left]").html(AmountLeft);
            //bindjobForEdit(cltid, pid, hdnSfCode);
            //$("#ddlEditJob_").val(iji);
            //$("#ddlEditJob_").trigger('change');
        }



        ////////////save click of popup
        function saveEditTimesheetInput(status) {
            var msg = "";
            var ts;
            var valid;
            var ttime = $("#TxtedtTottime").val();
            var lvl = $("[id*=hdn2lvl]").val();
            var M = "";
            if (lvl == '2') {
                M = $("[id*=hdnmjid]").val();
            }
            else {
                M = $("#ddlEditJob_").val();
                if ($("#ddlEditJob_").val() == 0) {
                    showWarningAlert('Please select task');
                    return;
                }
            }
            if ($("#TxtedtTottime").val() == "00:00" || ttime.length != 5 || $("#TxtedtTottime").val() == "" || $("#TxtedtTottime").val() == undefined) {
                $("#edittotaltime").css('color', 'red');
                showWarningAlert('Please check time not enter proper!');
                return false;
            }
            else { $("#TxtedtTottime").css('color', 'black'); }
            var n = $("#editnarration").val();
            var l = n.length;
            if (l > (890)) {
                showWarningAlert('Maximum 900 Charaters are allowed in Narration');
                $("[id*=txtNarr]").val('');
            }
            else {

                valid = true;
                var t = $("#TxtedtTottime").val();
                var dt = '';
                dt = $("[id*=hdnedDate]").val();

                if (valid != true) { alert(valid); return false; }
                if (lvl == '2') {
                    ts = {
                        ts: {
                            FromTime: "00:00",
                            ToTime: t,
                            TotalTime: t,
                            TSId: $("[id*=hdnEdittsid]").val(),
                            Status: status,
                            Narration: $("#editnarration").val(),
                            LocId: 0,
                            Billable: $("[id*=editChk]").is(':checked'),
                            mJob_Id: M,
                            PageName: 'Timesheet Viewer Edit'
                        }
                    }
                }
                else {
                    ts = {
                        ts: {
                            FromTime: "00:00",
                            ToTime: t,
                            TotalTime: t,
                            TSId: $("[id*=hdnEdittsid]").val(),
                            Date: dt,
                            Status: status,
                            Narration: $("#editnarration").val(),
                            LocId: 0,
                            Billable: $("[id*=editChk]").is(':checked'),
                            DrawingAllocationId: $("[id*=drpEditSelectDrawing]").val(),
                            mJob_Id: M,
                            PageName: 'Timesheet Viewer Edit'
                        }
                    }
                }
                ts = JSON.stringify(ts);
                $('.modalganesh').css('display', 'block');
                if (lvl == '2') {
                    ServerServiceToGetData(ts, '../Services/TimesheetInput2.asmx/saveeditSaveTimesheetInput', false, Onsuccess_saveeditTimesheets);
                }
                else {
                    ServerServiceToGetData(ts, '../Handler/TimesheetInput.asmx/saveeditSaveTimesheetInput', false, Onsuccess_saveeditTimesheets);
                }
            }
        }


        ////////////////////success of edit timesheet save
        function Onsuccess_saveeditTimesheets(res) {
            $('.modalganesh').css('display', 'none');
            var myList = jQuery.parseJSON(res.d);
            if (myList == null) {
                showDangerAlert("Getting error while saving..........");
            }
            else {
                if (parseFloat(myList.length) == 0) {
                    showDangerAlert("Getting error while saving..........");
                }
                else {
                    if (parseFloat(myList.length) > 0) {
                        if (myList[0].Status == 'Saved & Submitted') {
                            showSuccessAlert('Few Timesheets have Saved & Submitted Successfully');
                        }
                        else {
                            showSuccessAlert('Timesheets Updated Successfully');
                        }
                        chkStatus();
                    }
                }
            }
        }


        //////////////ajax Commaon service
        function ServerServiceToGetData(data, url, torf, successFun) {
            $.ajax({
                url: url,
                data: data,
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: successFun,
                error: function (response) {
                    showWarningAlert(response.responseText);
                },
                failure: function (response) {
                    showWarningAlert(response.responseText);
                }
            });
        }

        /// 2 Level Narration
        function Open2Narration(i) {
            var row = i.closest("tr");
            var Narr = row.find("input[name=hdnNarr]").val();

            $("[id*=h2Narrat]").html('Narration');
            var dt = $("td", row.closest("tr")).eq(1).html();
            var proj = $("td", row.closest("tr")).eq(3).html();
            var job = $("td", row.closest("tr")).eq(4).html();
            var staff = ''; totl = '';

            staff = $("td", row.closest("tr")).eq(2).html();
            totl = $("td", row.closest("tr")).eq(7).html();

            $("[id*=tdnrrdt]").html(dt);
            $("[id*=tdnrrPJ]").html(proj + '/' + job);
            $("[id*=tdnrrSf]").html(staff);
            $("[id*=tdnrrTT]").html(totl);
            $("[id*=p2lblNarr]").show();
            $("[id*=txt2Resn]").hide();
            $("[id*=Save2Reson]").hide();
            $("[id*=p2lblNarr]").html(Narr);
        }

        function GetJobnamelevel3() {
            //var Compid = $("[id*=hdnCompanyid]").val();
            var staffcode = $("[id*=hdnEditStaffcode]").val();
            var projectid = $("[id*=drpProj]").val();
            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/GetJobdropdown",
                data: '{staffcode:' + staffcode + ',projectid:' + projectid + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);

                    //3 level Job name
                    $("[id*=drpMjob3]").empty();

                    $("[id*=drpMjob3]").append("<option value=0>--Activity--</option>");
                    for (var i = 0; i < myList.length; i++) {
                        $("[id*=drpMjob3]").append("<option value='" + myList[i].mjobid + "'>" + myList[i].MJobName + "</option>");
                    }
                },
                failure: function (response) {
                    showDangerAlert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    showDangerAlert('Error Occoured ' + response.d);
                }
            });
        }

        function GetTimesheetVwrdropdown() {
            var PageLevel = $("[id*=hdnPageLevel]").val();
            var staffcode = $("[id*=hdnEditStaffcode]").val();
            var staffrole = $("[id*=hdnRolename]").val();
            var SuperAppr = $("[id*=hdnSuperAppr]").val();
            var SubAppr = $("[id*=hdnSubAppr]").val();
            var muti = $("[id*=hdnPageLevel]").val();
            var cltid = $("[id*=drpclient3]").val();
            var projectid = $("[id*=drpProj]").val();
            var mjobid = $("[id*=drpMjob3]").val();
            var Sid = $("[id*=drpstaff3]").val();
            var frtime = $("[id*=hdnFromdate]").val();
            var totime = $("[id*=hdnTodate]").val();
            var status = $("[id*=drpstatus]").val();
            var ChckMyTS = $("[id*=chkMy]").is(':checked');
            var srchTxt = $("input[name=txtsrch]:visible").val();
            var currentPage = $("#hdnCurrentPage").val();
            //var pageSize = $("[name=drpPageSize]:visible").val();
            var pageIndex = $("[id*=hdnPages]").val();
            var pageSize = $("[id *= hdnSize]").val();
            var deptId = $("[id*=drpDept]").val();
            var task = 0;
            if ($("[id*=hdnPageLevel]").val() == '4') {
                task = $("[id*=drpTask]").val();
            }
            if (deptId == null || deptId == undefined) {
                deptId = 0;
            }
            if (cltid == null || cltid == undefined) {
                cltid = 0;
            }
            if (Sid == null) {
                Sid = 0;
            }
            if (status == null) {
                status = "All";
            }
            if (pageIndex == null || pageIndex == undefined) {
                pageIndex = 1;
            }
            if (pageSize == null || pageSize == undefined) {
                pageSize = 25;
            }
            Blockloadershow();
            var mmdd = CompanyPermissions[0].mmddyyyy;
            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/GetAlldropdown",
                data: '{PageLevel:' + PageLevel + ',staffcode:' + staffcode + ',staffrole:"' + staffrole + '",SuperAppr:"' + SuperAppr + '",SubAppr:"' + SubAppr + '", frtime:"' + frtime + '", totime:"' + totime + '", status:"' + status + '" ,pageIndex:' + pageIndex + ' , pageSize:' + pageSize + ', mmdd:' + mmdd + ' }',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var xmlDoc = $.parseXML(msg.d);
                    var xml = $(xmlDoc);
                    //var myList = xml.find("Table");

                    ////var myList = jQuery.parseJSON(msg.d);
                    var clintdrp = xml.find("Table1");  ////myList[0].list_ClientMaster;
                    var projdrp = xml.find("Table2");
                    var Jobname = xml.find("Table3");  //// myList[0].list_MjobMaster;
                    var staffdrp = xml.find("Table4"); ////myList[0].list_staffMaster;
                    var Taskdrp = xml.find("Table5");   ////myList[0].list_taskMaster;

                    var Depname = xml.find("Table6");   //// myList[0].list_depMaster;
                    var Dsg = xml.find("Table7");
                    var myList = xml.find("Table8");
                    var allTotalTime = xml.find("Table9");

                    //3 level Client
                    $("[id*=drpclient3]").empty();

                    $("[id*=drpclient3]").append("<option value=0>Client</option>");
                    if (clintdrp.length > 0) {
                        $.each(clintdrp, function () {

                            $("[id*=drpclient3]").append("<option value='" + $(this).find("CLTId").text() + "'>" + $(this).find("ClientName").text() + "</option>");
                            //// $('#drpTeam').append('<option value="' + $(this).find("Staffcode").text() + '">' + $(this).find("staffname").text() + '</option>');
                        });
                    }

                    if ($("[id*=hdnPageLevel]").val() == '2') {
                        if (CompanyPermissions[0].ProjectnClient == 1) {
                            $("[id*=divprjdrp]").hide();
                            $("[id*=drpMjob3]").empty();

                            $("[id*=drpMjob3]").append("<option value=0>--Activity--</option>");

                            if (Jobname.length > 0) {
                                $.each(Jobname, function () {

                                    $("[id*=drpMjob3]").append("<option value='" + $(this).find("mjobid").text() + "'>" + $(this).find("MJobName").text() + "</option>");
                                });
                            }

                        } else {
                            $("[id*=divprjdrp]").hide();
                            myProject = Jobname //myList[0].list_MjobMaster;
                        }
                    } else {
                        myProject = projdrp; //myList[0].list_ProjectMaster;
                    }

                    //3 level staff
                    $("[id*=drpstaff3]").empty();
                    if ($("[id*=hdnRolename]").val() != 'Staff') {
                        $("[id*=drpstaff3]").append("<option value=0>Team</option>");
                    }
                    if (staffdrp.length > 0) {
                        $.each(staffdrp, function () {
                            $("[id*=drpstaff3]").append("<option value='" + $(this).find("StaffCode").text() + "'>" + $(this).find("StaffName").text() + "</option>");
                        });
                    }

                    if ($("[id*=hdnPageLevel]").val() == '4') {
                        $("[id*=divtskdrp]").show();
                        $("[id*=drpTask]").empty();
                        $("[id*=drpTask]").append("<option value=0>--Task--</option>");

                        if (Taskdrp.length > 0) {
                            $.each(Taskdrp, function () {
                                $("[id*=drpTask]").append("<option value='" + $(this).find("TaskId").text() + "'>" + $(this).find("TaskName").text() + "</option>");
                            });

                        }
                    }

                    // Department Master Loading
                    $("[id*=ddlDept]").empty();
                    $("[id*=ddlDept]").append("<option value=0>--Department--</option>");

                    if (Depname.length > 0) {
                        $.each(Depname, function () {
                            $("[id*=ddlDept]").append("<option value='" + $(this).find("DepId").text() + "'>" + $(this).find("DepartmentName").text() + "</option>");
                        });
                    }

                    if (Depname.length > 0) {
                        var isChecked = "";
                        var dropdownControl = $("[id*=drpDept]");
                        dropdownControl.multiselect('destroy');
                        var TMdrpdownCtrl = $("[id*=drpTMDp]");
                        TMdrpdownCtrl.multiselect('destroy');
                        var option = "";
                        var selectedDep = [];
                        var dp = 0;
                        $.each(Depname, function () {

                            //isChecked = $(this).find("isChecked").text();
                            dp = $(this).find("DepId").text();
                            //if (isChecked != "") {
                            //    if (isChecked == dp) {
                            selectedDep.push('' + dp + '');
                            //    }
                            //}
                            option += "<option value='" + $(this).find("DepId").text() + "'>" + $(this).find("DepartmentName").text() + "</option>";
                            //// drpTMDp
                           
                        });


                        dropdownControl.html(option);
                        dropdownControl.multiselect({
                            allSelectedText: 'All Dept',
                            maxHeight: 200,
                            includeSelectAllOption: true,
                            nonSelectedText: "-Departments-",
                            enableFiltering: true,
                            includeFilterClearBtn: true,
                            enableCaseInsensitiveFiltering: true
                        });
                        dropdownControl.multiselect('selectAll', false);
                        dropdownControl.multiselect('updateButtonText');

                        dropdownControl.multiselect("clearSelection");
                        dropdownControl.multiselect('rebuild');

                        dropdownControl.val(selectedDep);
                        dropdownControl.multiselect("refresh");

                        ///// Team Dept
                        TMdrpdownCtrl.html(option);
                        TMdrpdownCtrl.multiselect({
                            allSelectedText: '-Departments-',
                            maxHeight: 200,
                            includeSelectAllOption: true,
                            nonSelectedText: "-Departments-",
                            enableFiltering: true,
                            includeFilterClearBtn: true,
                            enableCaseInsensitiveFiltering: true
                        });
                        TMdrpdownCtrl.multiselect('selectAll', false);
                        TMdrpdownCtrl.multiselect('updateButtonText');

                        TMdrpdownCtrl.multiselect("clearSelection");
                        TMdrpdownCtrl.multiselect('rebuild');

                        TMdrpdownCtrl.val(selectedDep);
                        TMdrpdownCtrl.multiselect("refresh");

                        //// End Team Dept
                    }


                    ///////////////////////// End of Departments



 

                    if (allTotalTime.length > 0) {
                        $.each(allTotalTime, function () {
                            if ($(this).find("AllTotal").text() == 'All Total') {
                                $("[id*=lblTotalHrs]").html($(this).find("TotalTimeMin").text());
                                $("[id*=lblTotalBillHrs]").html($(this).find("TotalTimeBillMin").text());
                                $("[id*=lblTotalNonBillHrs]").html($(this).find("TotaltimeNonBill").text());
                            }
                        });
                    }

                    //}

                    // Load Status
                    $("[id*=drpstatus]").empty();
                    $("[id*=drpstatus]").append("<option value='All'>All TimeSheet</option>");
                    $("[id*=drpstatus]").append("<option value='Approved'>Approved Timesheet</option>");
                    $("[id*=drpstatus]").append("<option value='Submitted'>Approval Pending</option>");
                    $("[id*=drpstatus]").append("<option value='StaffSumm'>Staff Summary</option>");
                    $("[id*=drpstatus]").append("<option value='TSNotSubmited'>TimeSheet Not Submitted</option>");
                    $("[id*=drpstatus]").append("<option value='MiniHrs'>Minimum Hours not Entered</option>");
                    $("[id*=drpstatus]").append("<option value='Rejected'>Rejected Timesheet</option>");
                    if ($("[id*=hdnIsRejected]").val() == 'Rejected') {
                        $("[id*=drpstatus]").val('Rejected');
                    }
                    var tbl = '';
                    var Staffcode = $("[id*=hdnEditStaffcode]").val();
                    var Staffrole = $("[id*=hdnRolename]").val();
                    var ChckMyTS = $("[id*=chkMy]").is(':checked');
                    var selectstatus = $("[id*=drpstatus]").val();

                    // var myList = xml.find("Table7");

                    $("[id*=tbl_AllTimesheet] tbody").empty();
                    $("[id*=tbl_AllTimesheet] thead").empty();

                    tbl = tbl + "<thead><tr>";
                    tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Date</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Submit Date</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Staff</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Project</th>";
                    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Activity</th>";
                    if ($("[id*=hdnPageLevel]").val() > 3) {
                        tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Task</th>";
                    }
                    tbl = tbl + "<th style='font-weight: bold;'>Time</th>";
                    if (CompanyPermissions[0].Edit_Billing_Hrs == true) {
                        tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Edit Hrs</th>";
                    }
                    tbl = tbl + "<th style='font-weight: bold;' id='thNarrationIcon' class='chkShowNarrationIcon'>Narration</th>";
                    tbl = tbl + "<th style='font-weight: bold;' id='thNarrationMessage' class='chkShowNarrationMessage'>Narration</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Billable</th>";
                    tbl = tbl + "<th style='font-weight: bold;'>Status</th>";

                    if (selectstatus == 'Approved' || selectstatus == 'All') {
                        tbl = tbl + "<th style='font-weight: bold;'>Approver</th>";
                    }

                    tbl = tbl + "<th style='font-weight: bold;'>Apprd Date</th>";

                    //if ($("[id*=hdnRolename]").val() == 'Staff' || $("[id*=hdnRolename]").val() == 'Approver') {
                    if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                        if ($("[id*=hdnRolename]").val() == 'Approver' && ChckMyTS == true) {
                            tbl = tbl + "<th style='font-weight: bold;'>Delete</th>";
                        }
                        else if ($("[id*=hdnRolename]").val() == 'Staff') {
                            tbl = tbl + "<th style='font-weight: bold;'>Delete</th>";
                        }
                        else if ($("[id*=hdnRolename]").val() == '') {
                            tbl = tbl + "<th style='font-weight: bold;'>Delete</th>";
                        }
                    }
                    //}

                    if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                    } else {
                        if (selectstatus == 'Approved') {
                            tbl = tbl + "<th style='text-align:left;'></th>";
                            $("[id*=btnStatusAppr]").show();
                            $("[id*=btnStatusReject]").show();
                            $("[id*=chkApprovedAll]").show();
                            $("[id*=lblAppr]").show();
                        }
                        else {
                            $("[id*=btnStatusAppr]").hide();
                            $("[id*=btnStatusReject]").hide();
                            $("[id*=chkApprovedAll]").hide();
                            $("[id*=lblAppr]").hide();
                        }
                    }


                    tbl = tbl + "</tr></thead>";
                    if (myList.length > 0) {
                        $.each(myList, function (i, va) {
                            var p = $(this);
                            RecordCount = $(this).find("TotalCount").text();
                            if ($(this).find("MJobName").text() == 'Total') {
                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td style='text-align: left;font-weight: bold;'>" + $(this).find("MJobName").text() + "</td>";
                                if ($("[id*=hdnPageLevel]").val() > 3) {
                                    tbl = tbl + "<td></td>";
                                }
                                tbl = tbl + "<td style='text-align: left;font-weight: bold;'>" + $(this).find("TotalTime").text() + "</td>";
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "<td></td>";
                                if ($("[id*=hdnExpense]").val() == 'True') {
                                    tbl = tbl + "<td></td>";
                                }
                                tbl = tbl + "<td></td>";
                                tbl = tbl + "</tr>";
                            } else {
                                var dt = moment($(this).find("Date").text());
                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td style='text-align: center;'>" + $(this).find("SrNo").text() + "<input type='hidden' id='hdnATSid' value='" + $(this).find("TSID").text() + "' name='hdnATSid'></td>";

                                if (CompanyPermissions[0].mmddyyyy == 0) {
                                    tbl = tbl + "<td style='text-align: left;'>" + $(this).find("Date").text() + "<div class='text-center'>" + getDayName($(this).find("Date").text()) + "</div></td>";
                                    tbl = tbl + "<td style='text-align: left;'>" + $(this).find("Submitted_Date").text() + "</td>";
                                }
                                else {
                                    var year;
                                    var month;
                                    var day;
                                    var dt = $(this).find("Date").text();
                                    dt = dt.split('/');
                                    year = dt[2], month = dt[1], day = dt[0];
                                    dt = month + '/' + day + '/' + year;

                                    tbl = tbl + "<td style='text-align: left;'>" + dt + "<div class='text-center'>" + getDayName($(this).find("Date").text()) + "</div></td>";
                                    dt = $(this).find("Submitted_Date").text();
                                    if (dt != '') {
                                        dt = dt.split('/');
                                        year = dt[2], month = dt[1], day = dt[0];
                                        dt = month + '/' + day + '/' + year;
                                    }
                                    tbl = tbl + "<td style='text-align: left;'>" + dt + "</td>";

                                }
                                tbl = tbl + "<td style='text-align: left;'>" + $(this).find("StaffName").text() + "<input type='hidden' id='hdnTStaffCode' value='" + $(this).find("staffCode").text() + "' name='hdnTStaffCode'><input type='hidden' id='hdnEditClientId' name='hdnEditClientId' value='" + $(this).find("CLTId").text() + "'/><input type='hidden' id='hdnJid' name='hdnJid' value='" + $(this).find("JobId").text() + "'/></td>";

                                tbl = tbl + "<td style='text-align: left;'>" + $(this).find("ProjectName").text() + "<input type='hidden' id='hdnClient' value='" + $(this).find("ClientName").text() + "' name='hdnClient'><input type='hidden' id='hdnProject' value='" + $(this).find("ProjectName").text() + "' name='hdnProject'><input type='hidden' id='hdnEditPojectId' name='hdnEditPojectId' value='" + $(this).find("Project_Id").text() + "'/></td>";
                                tbl = tbl + "<td style='text-align: left;'>" + $(this).find("MJobName").text() + "<input type='hidden' id='hdnJobname' value='" + $(this).find("MJobName").text() + "' name='hdnJobname'><input type='hidden' id='hdnEdiJobId' name='hdnEdiJobId' value='" + $(this).find("mJob_Id").text() + "'/></td>";
                                if ($("[id*=hdnPageLevel]").val() > 3) {
                                    tbl = tbl + "<td style='text-align: left;'>" + $(this).find("TaskName").text() + "</td>";
                                }

                                if (CompanyPermissions[0].Edit_Billing_Hrs == true) {
                                    if ($(this).find("Billable").text() == 'true') {
                                        var tTime = $(this).find("TotalTime").text();
                                        var totTime = tTime.split('.');
                                        var totHrs = '';
                                        if (totTime[0].length == 1) {
                                            totHrs = '0' + totTime[0];
                                        }
                                        else {
                                            totHrs = totTime[0]
                                        }
                                        var totalTime = totHrs + '.' + totTime[1];

                                        if (CompanyPermissions[0].SwapEdit == false) {
                                            tbl = tbl + "<td style='text-align: left;'>" + totalTime + "<input type='hidden' id='hdnTotTime' value='" + totalTime + "' name='hdnTotTime'></td>";
                                            tbl = tbl + "<td style='width: 70px;'>" + $(this).find("EditedBilling_Hrs").text() + "</td> ";
                                        }
                                        else {
                                            ///Swaping of the column
                                            tbl = tbl + "<td style='text-align: left;'>" + $(this).find("EditedBilling_Hrs").text() + "</td>";
                                            tbl = tbl + "<td style='width: 70px;'>" + totalTime + "<input type='hidden' id='hdnTotTime' value='" + totalTime + "' name='hdnTotTime'></td> ";
                                        }
                                    }
                                    else {
                                        var tTime = $(this).find("TotalTime").text();
                                        var totTime = tTime.split('.');
                                        var totHrs = '';
                                        if (totTime[0].length == 1) {
                                            totHrs = '0' + totTime[0];
                                        }
                                        else {
                                            totHrs = totTime[0]
                                        }
                                        var totalTime = totHrs + '.' + totTime[1];

                                        tbl = tbl + "<td style='text-align: left;'>" + totalTime + "<input type='hidden' id='hdnTotTime' value='" + totalTime + "' name='hdnTotTime'></td>";
                                        tbl = tbl + "<td style='width: 70px;'>" + $(this).find("EditedBilling_Hrs").text() + "</td> ";
                                    }
                                }
                                else {
                                    var tTime = $(this).find("TotalTime").text();
                                    var totTime = tTime.split('.');
                                    var totHrs = '';
                                    if (totTime[0].length == 1) {
                                        totHrs = '0' + totTime[0];
                                    }
                                    else {
                                        totHrs = totTime[0]
                                    }
                                    var totalTime = totHrs + '.' + totTime[1];
                                    tbl = tbl + "<td style='text-align: left;'>" + totalTime + "<input type='hidden' id='hdnTotTime' value='" + totalTime + "' name='hdnTotTime'></td>";

                                }

                                if ($(this).find("Narration").text() == '') {
                                    tbl = tbl + "<td style='text-align: center;' class='chkShowNarrationIcon'><i class='icon-bubble9 mr-1 '></i></td>";
                                } else {
                                    tbl = tbl + "<td style='text-align: center;cursor: pointer;' class='chkShowNarrationIcon'><i class='icon-bubble-lines4 mr-1 ' onclick='OpenNarration($(this))' data-toggle='modal' data-target='#modal_h3' ></i><input type='hidden' id='hdnNarr' value='" + $(this).find("Narration").text() + "' name='hdnNarr'></td>";
                                    // tbl = tbl + "<td style='text-align: left;'>" + myList[i].Narration + "</td>";
                                }
                                tbl = tbl + "<td style='text-align: left;' id='tdNarrationMessage' class='chkShowNarrationMessage'>" + $(this).find("Narration").text() + "</td>";

                                if ($(this).find("Billable").text() == 'true') {
                                    tbl = tbl + "<td style='text-align: center;cursor: pointer;'> <i class='icon-checkmark2 mr-3 icon-2x' style='color: green;'></i><input type='hidden'  id='hdnBillable' name='hdnBillable' value=" + $(this).find("Billable").text() + " /></td>";
                                    //bill = 'Yes';
                                } else {
                                    tbl = tbl + "<td style='text-align: center;cursor: pointer;'>  <i class='icon-cross3 mr-3 icon-2x' style='color: red;'></i><input type='hidden'  id='hdnBillable' name='hdnBillable' value=" + $(this).find("Billable").text() + " /></td>";
                                }

                                if ($(this).find("Status").text() == 'Submitted') {
                                    tbl = tbl + "<td style='text-align: left;color: orange;font-weight: bold;'>" + $(this).find("Status").text() + "<input type='hidden' id='hdnStatus' value='" + $(this).find("Status").text() + "' name='hdnStatus'></td>";
                                }
                                else if ($(this).find("Status").text() == 'Saved') {
                                    tbl = tbl + "<td style='text-align: left;color: SkyBlue;font-weight: bold;'>" + $(this).find("Status").text() + "<input type='hidden' id='hdnStatus' value='" + $(this).find("Status").text() + "' name='hdnStatus'></td>";
                                }
                                else if ($(this).find("Status").text() == 'Approved') {
                                    tbl = tbl + "<td style='text-align: center;color: LimeGreen;font-weight: bold;'>" + $(this).find("Status").text() + "<input type='hidden' id='hdnStatus' value='" + $(this).find("Status").text() + "' name='hdnStatus'>"
                                    if ($(this).find("Reason").text() != '') {
                                        tbl = tbl + "<input type = 'hidden' id = 'hdnReason' name = 'hdnReason' value = '" + $(this).find("Reason").text() + "' />"
                                            + " <br><i class='icon-bubble-lines4 mr-1' data-toggle='modal' data-target='#modal_Reason' onclick='ReasonPopup($(this))' >"
                                            + "</td>";
                                    }
                                    else { tbl = tbl + "</td>"; }
                                }
                                else if ($(this).find("Status").text() == 'Rejected') {
                                    tbl = tbl + "<td style='text-align: center;color: IndianRed;font-weight: bold;'>" + $(this).find("Status").text() + "<input type='hidden' id='hdnStatus' value='" + $(this).find("Status").text() + "' name='hdnStatus'>"
                                    if ($(this).find("Reason").text() != '') {
                                        tbl = tbl + "<input type = 'hidden' id = 'hdnReason' name = 'hdnReason' value = '" + $(this).find("Reason").text() + "' />"
                                            + " <br><i class='icon-bubble-lines4 mr-1' data-toggle='modal' data-target='#modal_Reason' onclick='ReasonPopup($(this))' >"
                                            + "</td>";
                                    }
                                    else { tbl = tbl + "</td>"; }
                                }
                                else if ($(this).find("Status").text() == 'Semi Approved') {
                                    tbl = tbl + "<td style='text-align: left;color: Yellow;font-weight: bold;'>" + $(this).find("Status").text() + "<input type='hidden' id='hdnStatus' value='" + $(this).find("Status").text() + "' name='hdnStatus'></td>";
                                }

                                if (selectstatus == 'Approved' || selectstatus == 'All') {
                                    tbl = tbl + "<td style='text-align: left;'>" + $(this).find("JobApproverName").text() + "</td>";
                                }

                                tbl = tbl + "<td style='text-align: left;'>" + $(this).find("Approved_Date").text() + "</td>";

                                if ($("[id*=hdnRolename]").val() == 'Staff') {
                                    if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                                        if ($(this).find("Status").text() == 'Approved') {
                                            tbl = tbl + "<td style='text-align: center;'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                        }
                                        else {
                                            tbl = tbl + "<td style='text-align: center;'><a href='#' onclick='deletesavedTimesheet(" + $(this).find("TSID").text() + ")' name='delete' class='dropdown-item'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1rem;color:red'></i></a></td>";
                                        }
                                    }
                                }
                                else if ($("[id*=hdnRolename]").val() == 'Approver') {
                                    if (selectstatus == 'All' || selectstatus == 'Submitted' || selectstatus == 'Rejected') {
                                        if (ChckMyTS == true) {
                                            if ($(this).find("Status").text() == 'Approved') {
                                                tbl = tbl + "<td style='text-align: center;'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                            }
                                            else {
                                                if ($(this).find("staffCode").text() === $("[id*=hdnEditStaffcode]").val()) {
                                                    tbl = tbl + "<td style='text-align: center;'><a href='#' onclick='deletesavedTimesheet(" + $(this).find("TSID").text() + ")' name='delete' class='dropdown-item'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1rem;color:red'></i></a></td>";
                                                }
                                                else {
                                                    tbl = tbl + "<td style='text-align: center;'><a href='#' class='list-icons-item' data-toggle='dropdown' tabindex='-1'><i class='icon-more2' style='cursor: no-drop;font-size: 1.25rem;color: #666666;pointer-events: none;'></i></a></td>"
                                                }
                                            }
                                        }
                                    }
                                }
                                else if ($("[id*=hdnRolename]").val() == '') {
                                    tbl = tbl + "<td style='text-align: center;'><a href='#' onclick='deletesavedTimesheet(" + $(this).find("TSID").text() + ")' name='delete' class='dropdown-item'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1rem;color:red'></i></a></td>";
                                }

                                if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                                } else {
                                    if (selectstatus == 'Approved') {
                                        tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + $(this).find("Status").text() + "' /><input type='checkbox' class='Chkbox' id='chkcltApp'  name='chkcltApp' value='" + $(this).find("TSID").text() + "' /></td>";
                                    }
                                }
                                tbl = tbl + "</tr>";
                            }
                        });

                        $("[id*=tbl_AllTimesheet]").append(tbl);
                        Pager(RecordCount);
                        if (RecordCount >= minPageSize) {
                            Pager(RecordCount);
                            $("#divPageSize_AllApproved").css({ 'display': 'block' });
                            $("[id*=tblPager_AllApproved]").show();
                        }
                        else {
                            Pager(0);
                            $("[id*=divPageSize_AllApproved]").hide();
                            $("[id*=tblPager_AllApproved]").hide();
                        }
                        Blockloaderhide();
                    } else {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        if ($("[id*=hdnPageLevel]").val() > 3) {
                            tbl = tbl + "<td></td>";
                        }
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "</tr>";
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td colspan='14' style='text-align:center;'>No Record Found !!!</td>";
                        tbl = tbl + "</tr>";
                        $("[id*=tbl_AllTimesheet]").append(tbl);
                        Pager(0);
                        Blockloaderhide();
                    }

                    $("#chkShowNarrationMessage:not(:checked)").each(function () {
                        var column = "table ." + $(this).attr("name");
                        $(column).hide();
                    });


                    Blockloaderhide();
                },
                failure: function (response) {
                    showDangerAlert('Cant Connect to Server' + response.d);
                    Blockloaderhide();
                },
                error: function (response) {
                    showDangerAlert('Error Occoured ' + response.d);
                    Blockloaderhide();
                }
            });
        }

        /////timesheet expense edit
        function editTsExpense(cuurTsid, cuurojb) {
            $('#SelectExpense').empty();
            $('#SelectExpense').append('<option class="labelChange" value="0">Select expense type</option>');
            $.each(jQuery.parseJSON($("[id*=hdnExpenseMaster]").val()), function (i, va) {
                $('#SelectExpense').append('<option value="' + va.OpeId + '">' + va.OPEName + '</option>');
            });
            $("[id*=hdnTsExpID]").val(cuurTsid);
            //////////Currency drop down inside popup
            $('#drpCurrency').empty();
            $('#drpCurrency').append('<option class="labelChange" value="0">Select</option>');
            $.each(jQuery.parseJSON($("[id*=hdnCurrencyMaster]").val()), function (i, va) {
                $('#drpCurrency').append('<option value="' + va.Currency + '">' + va.Currency + '</option>');
            });
            $('#drpCurrency').val($("[id*=hdnTsCurrency]").val());

            $("#btnExpensefindlSave").attr('onclick', 'saveExpesneOnEdittsidbased(' + cuurTsid + ')');
            $("[id*=lblExpenseDae]").html('Expense entry for : ' + moment($(".tabrowshowdate", cuurojb.closest("tr")).data('usedate')).format('DD MMM YYYY'));
            if (cuurojb.attr('src') == "../images/addnew.png") { Onsuccess_ExpenseEdit(null); }
            else {
                $('.modalganesh').css('display', 'block');
                var row = cuurojb.closest("tr");
                var hdnSfCode = row.find("input[name=hdnTStaffCode]").val();
                $("[id*=hdnTStfcode]").val(hdnSfCode);
                var sendObj = '{TSID:' + cuurTsid + ',staffcode:' + $("[id*=hdnTStfcode]").val() + '}';
                ServerServiceToGetData(sendObj, '../Handler/TimesheetInput.asmx/getExpenseagiainsTSID', false, Onsuccess_ExpenseEdit);
            }
        }
        /////onexpense edit
        function Onsuccess_ExpenseEdit(res) {
            var ExpArry = [];
            if (res != null && res != undefined)
                if (res.d.length != 0) { ExpArry = jQuery.parseJSON(res.d); }

            makeExpenseTable(ExpArry);
            $("#brnAddExpense").attr('onclick', 'addExpenseclick()');
            $("#modalhidediv").css('display', '');
            $('.modalganesh').css('display', 'none');
        }

        ////
        ////making Expense table for Expense edit
        function makeExpenseTable(Expense) {
            $("[id*=Tbl_Expense] tbody").empty();
            for (var i = 0; i < Expense.length; i++) {
                var expenseId = "<input type='hidden' id='hdnExp' name='hdnExp' value='" + Expense[i].ExpId + "'>";
                var rowNarr = Expense[i].ExpNarration.replace(/#CM/g, ',').replace(/#BS/g, '/').replace(/#PW/g, '^').replace(/#DS/g, '-');
                var del = "<a href='#' onclick='deleteExp($(this))'><i class='far fa-trash-alt' style='cursor: pointer;font-size:1.25rem;color:red'></i></a>";
                var tr = "<tr><td>" + Expense[i].ExpName + expenseId + "</td><td>" + rowNarr + "</td><td>" + Expense[i].Amt + " " + "(" + Expense[i].Currency + ")" + "</td><td>" + del + "</td></tr>";
                $('#Tbl_Expense > tbody:first').append(tr);
            }
        }

        function saveExpesneOnEdittsidbased(currTsId) {
            $('.modalganesh').css('display', 'block');
            var jsonofexpens = [];
            $("#Tbl_Expense > tbody  > tr").each(function () {
                var $currrow = $(this);
                jsonofexpens.push({
                    'ExpId': $("input[type=hidden]", $(this).closest("tr")).val(),
                    'ExpName': $currrow.find(':eq(0)').text(),
                    'ExpNarration': $currrow.find(':eq(2)').text(),
                    'Amt': $currrow.find(':eq(3)').text().replace(/\s*(?:\[[^\]]*\]|\([^)]*\))\s*/g, ""),
                    'Currency': $currrow.find(':eq(3)').text().match(/\(([^)]+)\)/)[1]
                });
            });
            jsonofexpens = JSON.stringify(jsonofexpens);
            var sendObj = '{TSID:' + currTsId + ',staffcode:' + $("[id*=hdnTStfcode]").val() + ',ts:' + jsonofexpens + '}';
            ServerServiceToGetData(sendObj, '../Handler/TimesheetInput.asmx/saveExpenseagiainsTSID', false, Onsuccess_ExpenseEditSave);
        }

        ///////////////function expense save against tsid
        function Onsuccess_ExpenseEditSave(res) {
            if (res.d == 'success') {
                showSuccessAlert('Expense saved successfully.........');
                chkStatus();
            }
            else { showDangerAlert('Error occoured while saving expense....'); }
            //$find("ModalExpenseId").hide();
            $('.modalganesh').css('display', 'none');
        }

        function deleteExp(i) {
            var notice = new PNotify({
                title: 'Confirmation',
                text: '<p>Are you sure you want to delete record?</p>',
                hide: false,
                type: 'warning',
                confirm: {
                    confirm: true,
                    buttons: [
                        {
                            text: 'Yes',
                            addClass: 'btn btn-sm btn-primary'
                        },
                        {
                            addClass: 'btn btn-sm btn-link'
                        }
                    ]
                },
                buttons: {
                    closer: false,
                    sticker: false
                }
            })

            // On confirm
            notice.get().on('pnotify.confirm', function () {
                i.closest('tr').remove();
            })

            // On cancel
            notice.get().on('pnotify.cancel', function () {
            });
        }

        // Code Added By SathishRam For Hiding BlockerUI On 21-Mar-2023
        function test(cookieval) {
            var cookie = ReadCookie('CookieReport');
            if (cookie != cookieval) {
                setTimeout(function () { test(cookieval) }, 1000);
                return true;
            }
            else {
                Blockloaderhide();
                return true;
            }
        }

        function makeid() {
            var text = "";
            var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            for (var i = 0; i < 5; i++)
                text += possible.charAt(Math.floor(Math.random() * possible.length));
            return text;
        }

        function ReadCookie(cookieName) {
            var theCookie = "" + document.cookie;
            var ind = theCookie.indexOf(cookieName);
            if (ind == -1 || cookieName == "") return "";
            var ind1 = theCookie.indexOf(';', ind);
            if (ind1 == -1) ind1 = theCookie.length;
            return unescape(theCookie.substring(ind + cookieName.length + 1, ind1));
        }
        // Code Added By SathishRam For Hiding BlockerUI On 21-Mar-2023

        function Pager(RecordCount) {
            $(".Pager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt($("[id*=hdnPages]").val()),
                PageSize: parseInt($("[id*=hdnSize]").val()),
                RecordCount: parseInt(RecordCount)
            });

            ////pagging changed bind LeaveMater with new page index
            $(".Pager .page").on("click", function () {
                $("[id*=hdnPages]").val($(this).attr('page'));
                chkStatus();
            });
        }

        function ConvertEditFormat(tTime) {
            var startTime = tTime.replace(':', '.');
            var firstHH = startTime.split('.')[0];
            var firstMM = startTime.split('.')[1];
            if (firstMM == undefined) {
                firstMM = "0";
            }

            if (firstHH == undefined) {
                firstHH = "0";
            }

            if (firstHH == "") {
                firstHH = "0";
            }
            if (firstMM == "") {
                firstMM = "0";
            }

            if (firstMM >= 60) {
                var realmin = firstMM % 60;
                var hours = Math.floor(firstMM / 60);
                firstHH = parseFloat(firstHH) + parseFloat(hours);

                firstMM = realmin;
            }

            if (firstMM < 10) {
                if (parseFloat(firstMM.length) < 2) {
                    firstMM = firstMM + "0";
                }
            }

            if (firstHH < 10) {
                if (parseFloat(firstHH.length) < 2) {
                    firstHH = "0" + firstHH;
                }
            }
            tTime = firstHH + ':' + firstMM;
            $("#TxtedtTottime").val(tTime);
        }

        function ShowEditChange() {
            var tTime = '00:00';
            var FTime = '00:00';
            var totalHH = '00';
            var totalMM = '00';

            var Mhrs = parseFloat(CompanyPermissions[0].MaxHrs);
            var ZeroD = CompanyPermissions[0].Zero_decimals;
            var V = 0;
            V = $("#TxtedtTottime").val();
            if ($("#TxtedtTottime").val().length < 5 || $("#TxtedtTottime").val().length > 5) {
                V = ConvertEditFormat(V);
            }

            var j = $("#TxtedtTottime").val();
            if (j != undefined) {
                if (j != '') {
                    var JM = j.split(':')[1];
                    var jhrs = j.replace(':', '.');
                    if (isNaN(jhrs) == true) {
                        $("#TxtedtTottime").val('00:00');
                    }
                    if (Project_hrs > 0) {
                        if (jhrs > Project_hrs) {
                            $("#TxtedtTottime").val('00:00');
                        }

                    } else {
                        if (Mhrs > 0) {
                            if (jhrs > Mhrs) {
                                $("#TxtedtTottime").val('00:00');
                            }
                        }
                    }

                    if (jhrs > 23.59) {
                        $("#TxtedtTottime").val('00:00');
                    }
                    if (JM > 59) {
                        $("#TxtedtTottime").val('00:00');
                    }
                    if (ZeroD == false) {
                        if (JM > 00 && JM < 60) {
                            $("#TxtedtTottime").val('00:00');
                        }
                    }
                    var startTime = $("#TxtedtTottime").val();
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

                    if (parseFloat(FTime) > 24.00) {
                        $("#TxtedtTottime").val('00:00');

                        showWarningAlert('Total Time for the day exceeds more than 24 Hours');
                        return;
                    }
                }
            }
        }

        function ReasonPopup(i) {
            var row = i.closest("tr");
            var reason = row.find("input[name=hdnReason]").val();
            $("#lblnrrdt1").html(row.find("input[name=hdnClient]").val());
            $("#lblnrrPJ1").html(row.find("input[name=hdnProject]").val());
            $("#lblnrrTT1").html(row.find("input[name=hdnTotTime]").val());
            $("[id*=txtResn1]").val(reason);
        }

        //*************Bind Job For Edit
        function bindjobForEdit(C, P, S) {
            Blockloadershow();
            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/GetViewer_EditJobdropdown",
                data: '{staffcode:' + S + ' ,projectid:' + P + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    $("[id*=ddlEditJob_]").empty();
                    if (myList.length > 0) {
                        var sc = myList.length;
                        $("[id*=ddlEditJob_]").append('<option value=0>Select</option>');
                        for (var i = 0; i < myList.length; i++) {
                            $("[id*=ddlEditJob_]").append('<option  value="' + myList[i].mjobid + '">' + myList[i].MJobName + '</option>');
                        }

                        var m = $("[id*=hdnmjid]").val();
                        $("#ddlEditJob_").val(m);
                        $("#ddlEditJob_").trigger('change');
                    }
                    Blockloaderhide();
                },
                failure: function (response) {
                    showDangerAlert('Cant Connect to Server' + response.d);
                    Blockloaderhide();
                },
                error: function (response) {
                    showDangerAlert('Error Occoured ' + response.d);
                    Blockloaderhide();
                }
            });
        }


        function ShowJobEditSelect(i) {

            //var P = $("#ddlEditProject_").val();
            //var C = $("[id*=hdnClientID]").val();

            //////var J = $("#ddlJob :selected", row).data('jobid');
            //var MM = $("#ddlEditJob_").val();
            //var M = "";
            //var J = "";
            //if (MM != undefined) {
            //    M = MM.split(',')[0];
            //    J = MM.split(',')[1];
            //}
            //Get_Job_Budgeted_Hours(M, J);
            //if (CompanyPermissions[0].Job_Hours == 1) {
            //    Get_Jobname_Hours(M, J);
            //}
            //var ST = '';
            //var Srt = '';
            //var ED = '';
            //var BL = '';
            //var Hide_BL = '';
            //var UFD = '';
            //var Jdt = '';
            //var Sdt = new Date();
            //var Edt = new Date();
            //var ProjectEnddt = '';
            //Hide_BL = CompanyPermissions[0].Hide_Bill;
            ////////// Check 4 job Start & end date
            //$.each(main_obj.list_job_master_ts, function (i, va) {
            //    if (va.JobId == J) {
            //        BL = va.Billable;
            //        ST = va.CreationDate;
            //        if (M == 55)
            //            BL = false;
            //        Srt = eval("new " + ST.replace(/\//g, ""));
            //        ST = moment(Srt).format('MMDDYYYY');
            //        Srt = moment(Srt).format('MM/dd/yyyy');
            //        //ST = convertDate(ST);
            //        if (va.PrjNeverEnd == true) {
            //            var cd = '';

            //            var d = new Date();
            //            MM = d.getMonth()
            //            if (MM < 10) {
            //                MM = "0" + MM;
            //            }
            //            dd = d.getDate()
            //            year = parseFloat(d.getFullYear()) + 1;
            //            cd = MM.toString() + '/' + dd.toString() + '/' + year.toString();
            //            ED = moment(cd).format('MMDDYYYY')
            //        }
            //        else {
            //            ED = va.ActualJobEndate;
            //            ProjectEnddt = moment(ED).format('MM/dd/yyyy');;
            //            ED = eval("new " + ED.replace(/\//g, ""));
            //            ED = moment(ED).format('MMDDYYYY')
            //            return false;
            //        }
            //    }
            //});

            ///// Made changes by Tejal Pawar (07/10/2020)
            //var today1 = new Date();
            //var fixdt1 = 0;
            //fixdt1 = moment(today1).format('MMDDYYYY');

            //var dt = '';
            //var year = '';
            //var MD = '';
            //year = ST.slice(4, 8);
            //MD = ST.slice(0, 4);
            //ST = year + MD;

            //year = ED.slice(4, 8);
            //MD = ED.slice(0, 4);
            //ED = year + MD;

            //year = fixdt1.slice(4, 8);
            //MD = fixdt1.slice(0, 4);
            //fixdt1 = year + MD;

            //if (parseFloat(ED) < parseFloat(fixdt1)) {
            //    showWarningAlert("Project Ended on " + ProjectEnddt + ". Timesheet Cannot be Entered!!!");
            //}
            //var jj = '', xy = '';




        }


        ////
        ////****************************************************** Project Summary ********************************////
        ////



        function Project_Summary() {
            TBSel = 'Project';
            Blockloadershow();
            var PLvl = $("[id*=hdnPageLevel]").val();
            var scode = $("[id*=hdnEditStaffcode]").val();
            var srole = $("[id*=hdnRolename]").val();

            var cltid = $("[id*=drpclient3]").val();
            var pid = $("[id*=drpProj]").val();

            var frtime = $("[id*=hdnFromdate]").val();
            var totime = $("[id*=hdnTodate]").val();
            var sts = 'All';

            var pfilter = $("[id*=drptopprj]").val();
            //var pageSize = $("[name=drpPageSize]:visible").val();
            var pIndex = $("[id*=hdnPages]").val();
            var pSize = $("[id *= hdnSize]").val();
            var dp = $("[id*=drpDept]").val();
            var mm = frtime.split('-')[1];
            var yy = frtime.split('-')[0];
            var dd = frtime.split('-')[2];
            var ddf = dd + '/' + mm + '/' + yy;

            mm = totime.split('-')[1];
            yy = totime.split('-')[0];
            dd = totime.split('-')[2];
            var tddt = dd + '/' + mm + '/' + yy;
            $("[id*=lblPrj]").html(ddf + ' - ' + tddt)
            $("[id*=drpMjob3]").attr("disabled", true);
            $("[id*=chkMy]").attr("disabled", true);
            $("[id*=drpstatus]").attr("disabled", true);
            $("[id*=drpstaff3]").attr("disabled", true);
            $("[id*=ddlDept]").attr("disabled", true);
            $("[id*=chkShowNarrationMessage]").attr("disabled", true);
            if (dp == undefined) {
                dp = '';
            }

            if (cltid == null || cltid == undefined) {
                cltid = 0;
            }

            if (sts == null) {
                sts = "All";
            }
            if (pIndex == null || pIndex == undefined) {
                pIndex = 1;
            }
            if (pSize == null || pSize == undefined) {
                pSize = 25;
            }



            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/ProjectSummary",
                data: '{PLvl:' + PLvl + ',scode:' + scode + ',srole:"' + srole + '",cid:"' + cltid + '",Pid:"' + pid + '", frtime:"' + frtime + '", totime:"' + totime + '", sts:"' + sts + '" ,pIndex:' + pIndex + ' , pSize:' + pSize + ', dp:"' + dp + '", pftr:"' + pfilter +'"}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: OnProjectSuccess,

                failure: function (response) {
                    Blockloaderhide();
                    showDangerAlert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    Blockloaderhide();
                    showDangerAlert('No Record Available ');
                }
            });
        }

        function OnProjectSuccess(responce) {
            var RecordCount = 0;
            var xmlDoc = $.parseXML(responce.d);
            var xml = $(xmlDoc);
            var TCnt = xml.find("Table");
            var MyList = xml.find("Table2");
            var MyHrs = xml.find("Table1");
            var MyPie = xml.find("Table3");
            var MyPteam = xml.find("Table4");

            var pageSize = $("[id*= hdnSize]").val();
            var tbl = '';
            $("[id*=tbl_ProjectSummary] tbody").empty();
            $("[id*=tbl_ProjectSummary] thead").empty();

            tbl = tbl + "<thead><tr>";
            tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
            tbl = tbl + "<th class='sorting_asc' tabindex='0' aria-controls='DataTables_Table_0' rowspan='1' colspan='1' aria-label='Name: activate to sort column descending' aria-sort='ascending'>Project</th> ";
            tbl = tbl + "<th style='font-weight: bold;'>Client</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Team</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Total Hrs</th>";
            tbl = tbl + "<th style='font-weight: bold; text-align:center;'>%</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Start DT</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>End DT</th>";
            //tbl = tbl + "<th style='font-weight: bold;' >Budget</th>";

            tbl = tbl + "<th style='font-weight: bold;'>Billable</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Non Billable</th>";

            tbl = tbl + "</tr></thead>";

            if (MyPie.length > 0) {

                (async function () {
                    await BindPieChart(MyPie);
                })();
            }
            else {
                Chrtpie.setOption({
                    series: [{
                        type: 'pie',
                        data: [] // Clear the data
                    }]
                });
            }

            if (TCnt.length > 0) {
                $.each(TCnt, function (i, va) {
                    var p = $(this);
                    RecordCount = $(this).find("TotalCount").text();

                });
            }
            if (MyHrs.length > 0) {
                $.each(MyHrs, function (i, va) {
                    $("[id*=lblTManHrs]").html($(this).find("TotalManHrs").text());
                    $("[id*=lblDlvPrjHrs]").html($(this).find("ProjDlyHrs").text());
                    $("[id*=lblHoliHrs]").html($(this).find("HolidayHrs").text());
                    $("[id*=lblTAvlHrs]").html($(this).find("AvailableHrs").text());
                    $("[id*=lblUtil]").html($(this).find("Utilisation").text() + '%');

                });
            }
            else {
                $("[id*=lblTManHrs]").html(0);
                $("[id*=lblDlvPrjHrs]").html(0);
                $("[id*=lblHoliHrs]").html(0);
                $("[id*=lblTAvlHrs]").html(0);
                $("[id*=lblUtil]").html('0%');
            }

            if (MyList.length > 0) {
                tbl = tbl + "<tbody>";
                $.each(MyList, function (i, va) {
                    tbl = tbl + "<tr  data-widget='expandable-table' aria-expanded='false'>";
                    tbl = tbl + "<td style='text-align: left;' class='col-0.5'>" + $(this).find("SrNo").text() + "</td>";
                    tbl = tbl + "<td style='text-align: left; color:blue;' class='col-4' ><i class='expandable-table-caret fas fa-caret-right fa-fw'style='color:#EC5800;' ></i> " + $(this).find("ProjectName").text() + "<input type='hidden' id='hdnProjectId' name='hdnProjectId' value='" + $(this).find("Projectid").text() + "'/></td>";
                    tbl = tbl + "<td style='text-align: left;' class='col-4'>" + $(this).find("ClientName").text() + "</td>";
                    tbl = tbl + "<td style='' class='col-1'>" + $(this).find("Stfcount").text() + "</td>";
                    tbl = tbl + "<td style='text-align: center;font-size: 18px; font-weight: bold;color:#17a2b8'; class='col-1'>" + $(this).find("TotalTimeMin").text() + "</td>";
                    tbl = tbl + "<td style='text-align: center; color:darkorange;font-weight:bold;' class='col-1'>" + $(this).find("Per").text() + "%</td>";
                    tbl = tbl + "<td style='' class='col-2'>" + $(this).find("Startdate").text() + "</td>";
                    tbl = tbl + "<td style='' class='col-2'>" + $(this).find("EndDate").text() + "</td>";
                    //tbl = tbl + "<td style='text-align: right;'>" + $(this).find("Budget").text() + "</td>";
                    tbl = tbl + "<td style='text-align: center;'>" + $(this).find("TotalTimeBillMin").text() + "</td>";
                    tbl = tbl + "<td style='text-align: center;'>" + $(this).find("TotaltimeNONBill").text() + "</td>";


                    tbl = tbl + "</tr>";
                    tbl = tbl + "<tr class='expandable-body d-none'>";
                    tbl = tbl + "<td colspan=10>" + BindProjectTeam($(this).find("Projectid").text(), MyPteam) + "</td>";
                    tbl = tbl + "</tr>";
                });
                tbl = tbl + "</tbody>";
                $("[id*=tbl_ProjectSummary]").append(tbl);


                ProjectSummary_Pager(RecordCount);
                if (RecordCount >= pageSize) {
                    ProjectSummary_Pager(RecordCount);
                    $("#divPageSize_AllApproved").css({ 'display': 'block' });
                    $("[id*=ProjectSummary_Pager]").show();
                }
                else {
                    ProjectSummary_Pager(0);
                    $("[id*=divPageSize_AllApproved]").hide();
                    $("[id*=ProjectSummary_Pager]").hide();
                }


                Blockloaderhide();
            } else {
                tbl = tbl + "<tr>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";

                tbl = tbl + "</tr>";
                tbl = tbl + "<tr>";
                tbl = tbl + "<td colspan='14' style='text-align:center;'>No Record Found !!!</td>";
                tbl = tbl + "</tr>";
                $("[id*=tbl_ProjectSummary]").append(tbl);
                ProjectSummary_Pager(0);
                Blockloaderhide();
            }

        }
        function ProjectSummary_Pager(RecordCount) {
            $(".Pager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt($("[id*=hdnPages]").val()),
                PageSize: parseInt($("[id*=hdnSize]").val()),
                RecordCount: parseInt(RecordCount)
            });

            ////pagging changed bind LeaveMater with new page index
            $(".Pager .page").on("click", function () {
                $("[id*=hdnPages]").val($(this).attr('page'));
                chkStatus();
            });
        }

        function BindProjectTeam(Pid, myPTeam) {
            var tbl = '';
            if (myPTeam.length > 0) {
                tbl = tbl + "<div class='p-0'>";
                tbl = tbl + "<table class='table table-hover'>";
                tbl = tbl + "<tbody>";


                $.each(myPTeam, function (i, va) {
                    if (Pid == $(this).find("projectid").text()) {
                        tbl = tbl + "<tr  data-widget='expandable-table' aria-expanded='false'>";
                        tbl = tbl + "<td style='text-align: left; padding-left:53px;' class='col-4' >" + $(this).find("staffname").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:32px;' class='col-4'>" + $(this).find("TotalMins").text() + "</td>";
                        tbl = tbl + "</tr>";
                    }
                })
                tbl = tbl + "</tbody></table></div>";

            }

            return tbl;
        }

        async function BindPieChart(allTotalTime) {


            var pie_rose_newdata = [];
            var pie_rose_colors = [];
            $.each(allTotalTime, function () {

                var nname = $(this).find("ProjectName").text();
                var nvalue = $(this).find("TotalTimeMin").text();

                pie_rose_newdata.push({ value: nvalue, name: nname });
            });


            pie_rose_colors: ['#2ec7c9', '#b6a2de', '#5ab1ef', '#ffb980', '#d87a80',
                '#8d98b3', '#e5cf0d', '#97b552', '#95706d', '#dc69aa',
                '#07a2a4', '#9a7fd1', '#588dd5', '#f5994e', '#c05050',
                '#59678c', '#c9ab00', '#7eb00a', '#6f5553', '#c14089',
                '#2ec7c9', '#b6a2de', '#5ab1ef', '#ffb980', '#d87a80',
            ]


            // Update pie chart

            Chrtpie.setOption({

                // Colors
                color: [
                    '#2ec7c9', '#b6a2de', '#5ab1ef', '#ffb980', '#d87a80',
                    '#8d98b3', '#e5cf0d', '#97b552', '#95706d', '#dc69aa',
                    '#07a2a4', '#9a7fd1', '#588dd5', '#f5994e', '#c05050',
                    '#59678c', '#c9ab00', '#7eb00a', '#6f5553', '#c14089'
                ],

                title: {
                    text: '',
                    subtext: ''
                },


                // Add series
                series: [
                    {
                        name: 'Increase (brutto)',
                        type: 'pie',
                        radius: ['15%', '80%'],
                        center: ['50%', '50.5%'],
                        itemStyle: {
                            normal: {
                                borderWidth: 1,
                                borderColor: '#fff'
                            }
                        },
                        data: pie_rose_newdata
                    }
                ]
            });
        }



        function generateColors(num) {
            const colors = [];
            for (let i = 0; i < num; i++) {
                const hue = Math.floor(Math.random() * 360);
                const color = `hsl(${hue}, 70%, 50%)`;
                colors.push(color);
            }
            return colors;
        }


        function getTableData() {
            var table = document.getElementById("tbl_ProjectSummary");
            var tbl = '';
            var jj = 0;
            jj = 1;

            for (var i = 0; i < table.rows.length; i++) {
                //var rowData = [];
                if (i > 0) {
                    for (var j = 0; j < table.rows[i].cells.length; j++) {
                        if (table.rows[i].cells.length > 2) {
                            tbl = tbl + table.rows[i].cells[j].innerText + '~';
                        }
                        // rowData.push(table.rows[i].cells[j].innerText);
                    }
                    if (table.rows[i].cells.length > 2) {
                        tbl = tbl + '^';
                        jj = jj + 1;
                    }
                }
                //tableData.push(rowData);
            }
            $("[id*=hdnTblCnt]").val(jj);

            var dts = $("[id*=lblTManHrs]").html() + '^' + $("[id*=lblHoliHrs]").html() + '^' + $("[id*=lblTAvlHrs]").html() + '^' + $("[id*=lblDlvPrjHrs]").html() + '^' + $("[id*=lblUtil]").html();
            tbl = dts + '|' + tbl;
            return tbl;
        }

        function exportToPDF() {
            var tableData = getTableData();

            // Get the ECharts chart image as before
            var chartImgData = Chrtpie.getDataURL({
                type: 'png',
                pixelRatio: 2,
                backgroundColor: '#fff'
            });
            var cmp = $("[id*=spnLogin]").html();
            var dts = $("[id*=lblPrj]").html();
            var ddt = cmp + '~' + dts;
            $("[id*=hdnPDFData]").val(ddt);
            $("[id*=hdnChrtImg]").val(chartImgData);
            $("[id*=hdntblData]").val(tableData);

            //$.ajax({
            //    type: "POST",
            //    url: '../Services/TimesheetViewer.asmx/SaveChartAndTableData',
            //    contentType: "application/json; charset=utf-8",
            //    dataType: "json",
            //    data: JSON.stringify({data}),
            //    success: function (response) {
            //        window.location.href = response.d;
            //    },
            //    error: function (err) {
            //        console.log("Error:", err);
            //    }
            //});
        }


        /////********************************************* End of Project Summary ****************************************////
        ///// ********************************************* Team Summary *************************************************////

        function Team_Summary() {
            TBSel = 'Team';
            Blockloadershow();
            var PLvl = $("[id*=hdnPageLevel]").val();
            var sCode = $("[id*=hdnEditStaffcode]").val();
            var sRole = $("[id*=hdnRolename]").val();
            var sid = $("[id*=drpstaff3]").val();
            var cid = $("[id*=drpclient3]").val();
            var pid = $("[id*=drpProj]").val();
            var mid = $("[id*=drpMjob3]").val();
            var frtime = $("[id*=hdnFromdate]").val();
            var totime = $("[id*=hdnTodate]").val();
            var status = 'All';
            var fltr = $("[id*=drpteam]").val(); 
            //var pageSize = $("[name=drpPageSize]:visible").val();
            var pIndex = $("[id*=hdnPages]").val();
            var pSize = $("[id *= hdnSize]").val();
            var dId = $("[id*=drpTMDp]").val();
            var mm = frtime.split('-')[1];
            var yy = frtime.split('-')[0];
            var dd = frtime.split('-')[2];
            var ddf = dd + '/' + mm + '/' + yy;
             
            mm = totime.split('-')[1];
            yy = totime.split('-')[0];
            dd = totime.split('-')[2];
            var tddt = dd + '/' + mm + '/' + yy;
            $("[id*=lblteam]").html(ddf + ' - ' + tddt)
            $("[id*=drpstatus]").attr("disabled", true);
            $("[id*=chkShowNarrationMessage]").attr("disabled", true);
            $("[id*=chkMy]").attr("disabled", true);
            $("[id*=drpMjob3]").attr("disabled", false);
            $("[id*=drpstaff3]").attr("disabled", false);
            $("[id*=ddlDept]").attr("disabled", true);

            if (dId == undefined) {
                dId = '';
            }

            if (cid == null || cid == undefined) {
                cid = 0;
            }

            if (status == null) {
                status = "All";
            }
            if (pIndex == null || pIndex == undefined) {
                pIndex = 1;
            }
            if (pSize == null || pSize == undefined) {
                pSize = 25;
            }

            $("[id*=lblTMTManHrs]").html(0);
            $("[id*=lblTMDlvPrjHrs]").html(0);
            $("[id*=lblTMHoliHrs]").html(0);
            $("[id*=lblTMTAvlHrs]").html(0);
            $("[id*=lblTMUtil]").html(0 + '%');

            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/TeamSummary",
                ////data: '{PageLevel:' + PageLevel + ',staffcode:' + staffcode + ',staffrole:"' + staffrole + '",Projectid:"' + projectid + '", frtime:"' + frtime + '", totime:"' + totime + '", status:"' + status + '" ,pageIndex:' + pageIndex + ' , pageSize:' + pageSize + ', dp:"' + dp + '" }',

                data: '{cid:"' + cid + '",pid:"' + pid + '",mid:"' + mid + '",sid:"' + sid + '",sCode:"' + sCode + '",frtime:"' + frtime + '",totime:"' + totime + '",sRole:"' + sRole + '",did:"' + dId + '",PLvl:' + PLvl + ',pIndex:' + pIndex + ',pSize:' + pSize + ',fltr:' + fltr + ' }',

                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: OnTeamSuccess,

                failure: function (response) {
                    Blockloaderhide();
                    showDangerAlert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    Blockloaderhide();
                    showDangerAlert('No Records Available ');
                }
            });
        }

        function OnTeamSuccess(responce) {
            var RecordCount = 0;
            var xmlDoc = $.parseXML(responce.d);
            var xml = $(xmlDoc);
            var TCnt = xml.find("Table");
            var MyList = xml.find("Table1");
            var MyPteam = xml.find("Table2");
            var MyBar = xml.find("Table3");
             
            
            var pageSize = $("[id*= hdnSize]").val();
            var tbl = '';
            $("[id*=tbl_TeamSummary] tbody").empty();
            $("[id*=tbl_TeamSummary] thead").empty();

            tbl = tbl + "<thead><tr>";
            tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
            tbl = tbl + "<th class='sorting_asc' tabindex='0' aria-controls='DataTables_Table_0' rowspan='1' colspan='1' aria-label='Name: activate to sort column descending' aria-sort='ascending'>StaffName</th> ";
            tbl = tbl + "<th style='font-weight: bold;'>Department</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Designation</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Total Hrs</th>";
            tbl = tbl + "<th style='font-weight: bold; text-align:center;'>Effort Hrs</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Leave</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Avail Hrs</th>";
            //tbl = tbl + "<th style='font-weight: bold;' >Budget</th>";

            tbl = tbl + "<th style='font-weight: bold;'>%</th>";
            //tbl = tbl + "<th style='font-weight: bold;'>Non Billable</th>";

            tbl = tbl + "</tr></thead>";

            if (MyBar.length > 0) {

                (async function () {
                    await TeamBarChart(MyBar);
                })();
            }
            //else {
            //    TMStcChrt.setOption({
            //        series: [{
            //            type: 'bar',
            //            data: [] // Clear the data
            //        }]
            //    });
            //}

            if (TCnt.length > 0) {
                $.each(TCnt, function (i, va) {
                    var p = $(this);
                    RecordCount = $(this).find("TotalCount").text();

                });
            }

            if (MyList.length > 0) {
                tbl = tbl + "<tbody>";
                $.each(MyList, function (i, va) {
                    tbl = tbl + "<tr  data-widget='expandable-table' aria-expanded='false'>";
                    tbl = tbl + "<td style='text-align: left;' class='col-0.5'>" + $(this).find("SrNo").text() + "</td>";
                    tbl = tbl + "<td style='text-align: left; color:blue;' class='col-3' ><i class='expandable-table-caret fas fa-caret-right fa-fw' ></i> " + $(this).find("StaffName").text() + "<input type='hidden' id='hdnStfId' name='hdnStfId' value='" + $(this).find("Staffcode").text() + "'/></td>";
                    tbl = tbl + "<td style='text-align: left;' class='col-3'>" + $(this).find("DepartmentName").text() + "</td>";
                    tbl = tbl + "<td style='text-align: center;' class='col-3'>" + $(this).find("DesignationName").text() + "</td>";
                    tbl = tbl + "<td style='text-align: center;' class='col-1'>" + $(this).find("TotalHrs").text() + "</td>";
                    tbl = tbl + "<td style='text-align: center;' class='col-1'>" + $(this).find("effortHrs").text() + "</td>";
                    tbl = tbl + "<td style='text-align: center;' class='col-1'>" + $(this).find("leaveHrs").text() + "</td>";
                    tbl = tbl + "<td style='text-align: center;' class='col-1'>" + $(this).find("AvailHrs").text() + "</td>";
                    //tbl = tbl + "<td style='text-align: right;'>" + $(this).find("Budget").text() + "</td>";

                    tbl = tbl + "<td style='text-align: center;'>" + $(this).find("Per").text() + "%</td>";
                    //tbl = tbl + "<td style='text-align: center;'>" + $(this).find("TotaltimeNONBill").text() + "</td>";


                    tbl = tbl + "</tr>";
                    tbl = tbl + "<tr class='expandable-body d-none'>";
                    tbl = tbl + "<td colspan=10>" + BindTeamDetails($(this).find("Staffcode").text(), MyPteam) + "</td>";
                    tbl = tbl + "<td colspan=10></td>";
                    tbl = tbl + "</tr>";
                });
                tbl = tbl + "</tbody>";
                $("[id*=tbl_TeamSummary]").append(tbl);


                TeamSummary_Pager(RecordCount);
                if (RecordCount >= pageSize) {
                    TeamSummary_Pager(RecordCount);
                    $("#divPageSize_AllApproved").css({ 'display': 'block' });
                    $("[id*=TeamSummary_Pager]").show();
                }
                else {
                    TeamSummary_Pager(0);
                    $("[id*=divPageSize_AllApproved]").hide();
                    $("[id*=TeamSummary_Pager]").hide();
                }


                Blockloaderhide();
            } else {
                tbl = tbl + "<tr>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";

                tbl = tbl + "</tr>";
                tbl = tbl + "<tr>";
                tbl = tbl + "<td colspan='14' style='text-align:center;'>No Record Found !!!</td>";
                tbl = tbl + "</tr>";
                $("[id*=tbl_TeamSummary]").append(tbl);
                TeamSummary_Pager(0);
                Blockloaderhide();
            }

        }
        function TeamSummary_Pager(RecordCount) {
            $(".Pager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt($("[id*=hdnPages]").val()),
                PageSize: parseInt($("[id*=hdnSize]").val()),
                RecordCount: parseInt(RecordCount)
            });

            ////pagging changed bind LeaveMater with new page index
            $(".Pager .page").on("click", function () {
                $("[id*=hdnPages]").val($(this).attr('page'));
                chkStatus();
            });
        }

        async function TeamBarChart(allTotalTime) {


            var Bar_Hrs = [];
            var Bar_Bill = [];
            var Bar_Non = [];
            var Bar_Mth = [];
            var i = 1;
            $.each(allTotalTime, function () {

                
                Bar_Bill[i] = $(this).find("BillMins").text();
                Bar_Non[i] = $(this).find("NonMins").text();
                Bar_Hrs[i] = $(this).find("TotalMins").text();
                Bar_Mth[i] = $(this).find("Mth").text();

                i = i + 1;
                //Bar_Hrs.push({ Th });
                //Bar_Bill.push({ Bill });
                //Bar_Non.push({ Non });
                //Bar_Mth.push({ Mth });
            });
            

            // Define element
            var columns_basic_element = document.getElementById('TM_Statistics');

            if (columns_basic_element) {

                // Initialize chart
                TMStcChrt = echarts.init(columns_basic_element);

                // Options
                TMStcChrt.setOption({

                    // Define colors
                    color: ['#2ec7c9', '#b6a2de', '#5ab1ef', '#ffb980', '#d87a80'],

                    // Global text styles
                    textStyle: {
                        fontFamily: 'Roboto, Arial, Verdana, sans-serif',
                        fontSize: 13
                    },

                    // Chart animation duration
                    animationDuration: 750,

                    // Setup grid
                    grid: {
                        left: 0,
                        right: 10,
                        top: 35,
                        bottom: 0,
                        containLabel: true
                    },

                     //Add legend
                    legend: {
                        data: ['Total Hours', 'Billable', 'Non Billable'],
                        itemHeight: 8,
                        itemGap: 15,
                        textStyle: {
                            padding: [0, 5]
                        }
                    },

                    // Add tooltip
                    tooltip: {
                        trigger: 'axis',
                        backgroundColor: 'rgba(0,0,0,0.75)',
                        padding: [10, 15],
                        textStyle: {
                            fontSize: 13,
                            fontFamily: 'Roboto, sans-serif'
                        },
                        axisPointer: {
                            type: 'shadow',
                            shadowStyle: {
                                color: 'rgba(0,0,0,0.025)'
                            }
                        }
                    },

                    // Horizontal axis
                    xAxis: [{
                        type: 'category',
                        data: [Bar_Mth[1], Bar_Mth[2], Bar_Mth[3], Bar_Mth[4], Bar_Mth[5], Bar_Mth[6], Bar_Mth[7], Bar_Mth[8], Bar_Mth[9], Bar_Mth[10], Bar_Mth[11], Bar_Mth[12]],
                        axisLabel: {
                            color: '#333',
                            fontSize: 15
                        },
                        axisLine: {
                            lineStyle: {
                                color: '#999'
                            }
                        },
                        axisTick: {
                            show: false
                        },
                    }],

                    // Vertical axis
                    yAxis: [{
                        type: 'value',
                        name: '',
                        axisLabel: {
                            color: '#333'
                        },
                        axisLine: {
                            lineStyle: {
                                color: '#999'
                            }
                        },
                        splitLine: {
                            lineStyle: {
                                color: ['#eee']
                            }
                        },
                        splitArea: {
                            show: true,
                            areaStyle: {
                                color: ['rgba(250,250,250,0.1)', 'rgba(0,0,0,0.01)']
                            }
                        }
                    },
                    {
                        type: 'value',
                        name: '',
                        axisLabel: {
                            color: '#333'
                        },
                        axisLine: {
                            lineStyle: {
                                color: '#999'
                            }
                        },
                        splitLine: {
                            lineStyle: {
                                color: ['#eee']
                            }
                        },
                        splitArea: {
                            show: true,
                            areaStyle: {
                                color: ['rgba(250,250,250,0.1)', 'rgba(0,0,0,0.01)']
                            }
                        }
                    },
                    {
                        type: 'value',
                        name: '',
                        axisLabel: {
                            color: '#333'
                        },
                        axisLine: {
                            lineStyle: {
                                color: '#999'
                                }
                        },
                        splitLine: {
                            lineStyle: {
                                color: ['#eee']
                            }
                        },
                        splitArea: {
                            show: true,
                            areaStyle: {
                                color: ['rgba(250,250,250,0.1)', 'rgba(0,0,0,0.01)']
                            }
                        }
                    }],

                    // Add series
                    series: [
                        {
                            name: 'Total Hours',
                            type: 'bar',
                            //data: [myline[1].d1, myline[1].d2, myline[1].d3, myline[1].d4, myline[1].d5, myline[1].d6, myline[1].d7]
                            data: [Bar_Hrs[1], Bar_Hrs[2], Bar_Hrs[3], Bar_Hrs[4], Bar_Hrs[5], Bar_Hrs[6], Bar_Hrs[7], Bar_Hrs[8], Bar_Hrs[9], Bar_Hrs[10], Bar_Hrs[11], Bar_Hrs[12]]
                        },
                        {
                            name: 'Billable',
                            type: 'bar',
                            //data: [myline[2].d1, myline[2].d2, myline[2].d3, myline[2].d4, myline[2].d5, myline[2].d6, myline[2].d7]
                            data: [Bar_Bill[1], Bar_Bill[2], Bar_Bill[3], Bar_Bill[4], Bar_Bill[5], Bar_Bill[6], Bar_Bill[7], Bar_Bill[8], Bar_Bill[9], Bar_Bill[10], Bar_Bill[11], Bar_Bill[12]]
                        },
                        {
                            name: 'NonBillable',
                            type: 'bar',
                            //data: [myline[3].d1, myline[3].d2, myline[3].d3, myline[3].d4, myline[3].d5, myline[3].d6, myline[3].d7],
                            data: [Bar_Non[1], Bar_Non[2], Bar_Non[3], Bar_Non[4], Bar_Non[5], Bar_Non[6], Bar_Non[7], Bar_Non[8], Bar_Non[9], Bar_Non[10], Bar_Non[11], Bar_Non[12]],
                            itemStyle: {
                                normal: {
                                    borderWidth: 2
                                }
                            }
                        }
                    ]
                });

            }
        }

        function BindTeamDetails(Staffcode, myPTeam) {
            var tbl = '';
            if (myPTeam.length > 0) {
                tbl = tbl + "<div class='p-0'>";
                tbl = tbl + "<table class='table table-hover'>";
                tbl = tbl + "<tbody>";


                $.each(myPTeam, function (i, va) {
                    if (Staffcode == $(this).find("StaffCode").text()) {
                        tbl = tbl + "<tr  data-widget='expandable-table' aria-expanded='false'>";
                        tbl = tbl + "<td style='text-align: left; padding-left:53px;' class='col-1' >" + $(this).find("Tdate").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:32px;' class='col-4'>" + $(this).find("Projectname").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:53px;' class='col-2' >" + $(this).find("MJobName").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:32px;' class='col-1'>" + $(this).find("TotalTimeMin").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:53px;' class='col-6' >" + $(this).find("narration").text() + "</td>";
                        ////tbl = tbl + "<td style='text-align: left; padding-left:32px;' class='col-4'>" + $(this).find("TotalMins").text() + "</td>";

                        tbl = tbl + "</tr>";
                    }
                })
                tbl = tbl + "</tbody></table></div>";

            }

            return tbl;
        }

        //function getTeamTableData() {
        //    var table = document.getElementById("tbl_TeamSummary");
        //    var tbl = '';
        //    var jj = 0;
        //    jj = 1;

        //    for (var i = 0; i < table.rows.length; i++) {
        //        //var rowData = [];
        //        if (i > 0) {
        //            for (var j = 0; j < table.rows[i].cells.length; j++) {
        //                if (table.rows[i].cells.length > 2) {
        //                    tbl = tbl + table.rows[i].cells[j].innerText + '~';
        //                }
        //                // rowData.push(table.rows[i].cells[j].innerText);
        //            }
        //            if (table.rows[i].cells.length > 2) {
        //                tbl = tbl + '^';
        //                jj = jj + 1;
        //            }
        //        }
        //        //tableData.push(rowData);
        //    }
        //    $("[id*=hdnTblCnt]").val(jj);

        //    var dts = $("[id*=lblTMTManHrs]").html() + '^' + $("[id*=lblTMHoliHrs]").html() + '^' + $("[id*=lblTMTAvlHrs]").html() + '^' + $("[id*=lblTMDlvPrjHrs]").html() + '^' + $("[id*=lblTMUtil]").html();
        //    tbl = dts + '|' + tbl;
        //    return tbl;
        //}

        function TeamexportToPDF() {
            var tableData = getTeamTableData();

            // Get the ECharts chart image as before
            var chartImgData = TMpieChrt.getDataURL({
                type: 'png',
                pixelRatio: 2,
                backgroundColor: '#fff'
            });
            var cmp = $("[id*=spnLogin]").html();
            var dts = $("[id*=lblPrj]").html();
            var ddt = cmp + '~' + dts;
            $("[id*=hdnPDFData]").val(ddt);
            $("[id*=hdnChrtImg]").val(chartImgData);
            $("[id*=hdntblData]").val(tableData);

        }

        ///// ********************************************* Client Summary *************************************************////

        function Client_Summary() {
            TBSel = 'Client';
            Blockloadershow();
            var PLvl = $("[id*=hdnPageLevel]").val();
            var sCode = $("[id*=hdnEditStaffcode]").val();
            var sRole = $("[id*=hdnRolename]").val();
            var sid = $("[id*=drpstaff3]").val();
            var cid = $("[id*=drpclient3]").val();
            var pid = $("[id*=drpProj]").val();
            var mid = $("[id*=drpMjob3]").val();
            var frtime = $("[id*=hdnFromdate]").val();
            var totime = $("[id*=hdnTodate]").val();
            var status = 'All';
            var fltr = $("[id*=drpCltType]").val();
            //var pageSize = $("[name=drpPageSize]:visible").val();
            var pIndex = $("[id*=hdnPages]").val();
            var pSize = $("[id *= hdnSize]").val();
            var dId = $("[id*=drpTMDp]").val();
            var mm = frtime.split('-')[1];
            var yy = frtime.split('-')[0];
            var dd = frtime.split('-')[2];
            var ddf = dd + '/' + mm + '/' + yy;

            mm = totime.split('-')[1];
            yy = totime.split('-')[0];
            dd = totime.split('-')[2];
            var tddt = dd + '/' + mm + '/' + yy;
            $("[id*=lblteam]").html(ddf + ' - ' + tddt)
            $("[id*=drpstatus]").attr("disabled", true);
            $("[id*=chkShowNarrationMessage]").attr("disabled", true);
            $("[id*=chkMy]").attr("disabled", true);
            $("[id*=drpMjob3]").attr("disabled", false);
            $("[id*=drpstaff3]").attr("disabled", false);
            $("[id*=ddlDept]").attr("disabled", false);

            if (dId == undefined) {
                dId = '';
            }

            if (cid == null || cid == undefined) {
                cid = 0;
            }

            if (status == null) {
                status = "All";
            }
            if (pIndex == null || pIndex == undefined) {
                pIndex = 1;
            }
            if (pSize == null || pSize == undefined) {
                pSize = 25;
            }

            $.ajax({
                type: "POST",
                url: "../Services/TimesheetViewer.asmx/ClientSummary",

                data: '{cid:"' + cid + '",pid:"' + pid + '",mid:"' + mid + '",sid:"' + sid + '",sCode:"' + sCode + '",frtime:"' + frtime + '",totime:"' + totime + '",sRole:"' + sRole + '",did:"' + dId + '",PLvl:' + PLvl + ',pIndex:' + pIndex + ',pSize:' + pSize + ',fltr:"' + fltr + '" }',

                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: OnClientSuccess,

                failure: function (response) {
                    Blockloaderhide();
                    showDangerAlert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    Blockloaderhide();
                    showDangerAlert('No Records Available ');
                }
            });
        }

        function OnClientSuccess(responce) {
            var RecordCount = 0;
            var xmlDoc = $.parseXML(responce.d);
            var xml = $(xmlDoc);
            var TCnt = xml.find("Table");
            var MyList = xml.find("Table1");
            var MyPteam = xml.find("Table2");



            var pageSize = $("[id*= hdnSize]").val();
            var tbl = '';
            $("[id*=tbl_ClientSummary] tbody").empty();
            $("[id*=tbl_ClientSummary] thead").empty();
            var fltr = $("[id*=drpCltType]").val();

            if (fltr == 'Stf') {

                tbl = tbl + "<thead><tr>";
                tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
                tbl = tbl + "<th class='sorting_asc' tabindex='0' aria-controls='DataTables_Table_0' rowspan='1' colspan='1' aria-label='Name: activate to sort column descending' aria-sort='ascending'>StaffName</th> ";
                tbl = tbl + "<th style='font-weight: bold;'>Department</th>";
                tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Designation</th>";
                tbl = tbl + "<th style='font-weight: bold; text-align:center;'>Effort Hrs</th>";

                tbl = tbl + "</tr></thead>";



                if (TCnt.length > 0) {
                    $.each(TCnt, function (i, va) {
                        var p = $(this);
                        RecordCount = $(this).find("TotalCount").text();

                    });
                }

                if (MyList.length > 0) {
                    tbl = tbl + "<tbody>";
                    $.each(MyList, function (i, va) {
                        tbl = tbl + "<tr  data-widget='expandable-table' aria-expanded='false'>";
                        tbl = tbl + "<td style='text-align: left;' class='col-0.5'>" + $(this).find("SrNo").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; color:blue;' class='col-3' ><i class='expandable-table-caret fas fa-caret-right fa-fw' ></i> " + $(this).find("StaffName").text() + "<input type='hidden' id='hdnStfId' name='hdnStfId' value='" + $(this).find("Staffcode").text() + "'/></td>";
                        tbl = tbl + "<td style='text-align: left;' class='col-3'>" + $(this).find("DepartmentName").text() + "</td>";
                        tbl = tbl + "<td style='text-align: center;' class='col-3'>" + $(this).find("DesignationName").text() + "</td>";
                        tbl = tbl + "<td style='text-align: center;' class='col-1'>" + $(this).find("effortHrs").text() + "</td>";

                        tbl = tbl + "</tr>";
                        tbl = tbl + "<tr class='expandable-body d-none'>";
                        tbl = tbl + "<td colspan=10>" + BindClientDetails($(this).find("Staffcode").text(), MyPteam) + "</td>";
                        tbl = tbl + "<td colspan=10></td>";
                        tbl = tbl + "</tr>";
                    });
                    tbl = tbl + "</tbody>";
                    $("[id*=tbl_ClientSummary]").append(tbl);


                    ClientSummary_Pager(RecordCount);
                    if (RecordCount >= pageSize) {
                        ClientSummary_Pager(RecordCount);
                        $("#divPageSize_AllApproved").css({ 'display': 'block' });
                        $("[id*=ClientSummary_Pager]").show();
                    }
                    else {
                        ClientSummary_Pager(0);
                        $("[id*=divPageSize_AllApproved]").hide();
                        $("[id*=ClientSummary_Pager]").hide();
                    }


                    Blockloaderhide();
                } else {
                    tbl = tbl + "<tr>";
                    tbl = tbl + "<td></td>";
                    tbl = tbl + "<td></td>";
                    tbl = tbl + "<td></td>";
                    tbl = tbl + "<td></td>";
                    tbl = tbl + "<td></td>";

                    tbl = tbl + "</tr>";
                    tbl = tbl + "<tr>";
                    tbl = tbl + "<td colspan='14' style='text-align:center;'>No Record Found !!!</td>";
                    tbl = tbl + "</tr>";
                    $("[id*=tbl_ClientSummary]").append(tbl);
                    ClientSummary_Pager(0);
                    Blockloaderhide();
                }
            }
            else if (fltr == 'Clt') {
                tbl = tbl + "<thead><tr>";
                tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
                tbl = tbl + "<th class='sorting_asc' tabindex='0' aria-controls='DataTables_Table_0' rowspan='1' colspan='1' aria-label='Name: activate to sort column descending' aria-sort='ascending'>Client</th> ";

                tbl = tbl + "<th style='font-weight: bold; text-align:center;'>Effort Hrs</th>";

                tbl = tbl + "</tr></thead>";



                if (TCnt.length > 0) {
                    $.each(TCnt, function (i, va) {
                        var p = $(this);
                        RecordCount = $(this).find("TotalCount").text();

                    });
                }

                if (MyList.length > 0) {
                    tbl = tbl + "<tbody>";
                    $.each(MyList, function (i, va) {
                        tbl = tbl + "<tr  data-widget='expandable-table' aria-expanded='false'>";
                        tbl = tbl + "<td style='text-align: left;' class='col-0.5'>" + $(this).find("SrNo").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; color:blue;' class='col-8' ><i class='expandable-table-caret fas fa-caret-right fa-fw' ></i> " + $(this).find("ClientName").text() + "<input type='hidden' id='hdnStfId' name='hdnStfId' value='" + $(this).find("Cltid").text() + "'/></td>";
                        //tbl = tbl + "<td style='text-align: left;' class='col-3'>" + $(this).find("DepartmentName").text() + "</td>";
                        //tbl = tbl + "<td style='text-align: center;' class='col-3'>" + $(this).find("DesignationName").text() + "</td>";
                        tbl = tbl + "<td style='text-align: center;' class='col-1'>" + $(this).find("effortHrs").text() + "</td>";

                        tbl = tbl + "</tr>";
                        tbl = tbl + "<tr class='expandable-body d-none'>";
                        tbl = tbl + "<td colspan=10>" + BindStaffDetails($(this).find("Cltid").text(), MyPteam) + "</td>";
                        tbl = tbl + "<td colspan=10></td>";
                        tbl = tbl + "</tr>";
                    });
                    tbl = tbl + "</tbody>";
                    $("[id*=tbl_ClientSummary]").append(tbl);


                    ClientSummary_Pager(RecordCount);
                    if (RecordCount >= pageSize) {
                        ClientSummary_Pager(RecordCount);
                        $("#divPageSize_AllApproved").css({ 'display': 'block' });
                        $("[id*=ClientSummary_Pager]").show();
                    }
                    else {
                        ClientSummary_Pager(0);
                        $("[id*=divPageSize_AllApproved]").hide();
                        $("[id*=ClientSummary_Pager]").hide();
                    }


                    Blockloaderhide();
                } else {
                    tbl = tbl + "<tr>";
                    tbl = tbl + "<td></td>";
                    tbl = tbl + "<td></td>";
                    tbl = tbl + "<td></td>";
                    //tbl = tbl + "<td></td>";
                    //tbl = tbl + "<td></td>";

                    tbl = tbl + "</tr>";
                    tbl = tbl + "<tr>";
                    tbl = tbl + "<td colspan='14' style='text-align:center;'>No Record Found !!!</td>";
                    tbl = tbl + "</tr>";
                    $("[id*=tbl_ClientSummary]").append(tbl);
                    ClientSummary_Pager(0);
                    Blockloaderhide();
                }
            }
        }
        function ClientSummary_Pager(RecordCount) {
            $(".Pager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt($("[id*=hdnPages]").val()),
                PageSize: parseInt($("[id*=hdnSize]").val()),
                RecordCount: parseInt(RecordCount)
            });

            ////pagging changed bind LeaveMater with new page index
            $(".Pager .page").on("click", function () {
                $("[id*=hdnPages]").val($(this).attr('page'));
                chkStatus();
            });
        }

        function BindClientDetails(Staffcode, myPTeam) {
            var tbl = '';
            if (myPTeam.length > 0) {
                tbl = tbl + "<div class='p-0'>";
                tbl = tbl + "<table class='table table-hover'>";
                tbl = tbl + "<tbody>";


                $.each(myPTeam, function (i, va) {
                    if (Staffcode == $(this).find("staffcode").text()) {
                        tbl = tbl + "<tr  data-widget='expandable-table' aria-expanded='false'>";
                        tbl = tbl + "<td style='text-align: left; padding-left:53px;' class='col-1' >" + $(this).find("Tdate").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:32px;' class='col-4'>" + $(this).find("Clientname").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:32px;' class='col-4'>" + $(this).find("ProjectName").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:53px;' class='col-2' >" + $(this).find("mjobName").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:32px;' class='col-1'>" + $(this).find("TotalHrs").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:53px;' class='col-6' >" + $(this).find("Narration").text() + "</td>";

                        tbl = tbl + "</tr>";
                    }
                })
                tbl = tbl + "</tbody></table></div>";

            }

            return tbl;
        }

        function BindStaffDetails(Cltid, myPTeam) {
            var tbl = '';
            if (myPTeam.length > 0) {
                tbl = tbl + "<div class='p-0'>";
                tbl = tbl + "<table class='table table-hover'>";
                tbl = tbl + "<tbody>";


                $.each(myPTeam, function (i, va) {
                    if (Cltid == $(this).find("Cltid").text()) {
                        tbl = tbl + "<tr  data-widget='expandable-table' aria-expanded='false'>";
                        tbl = tbl + "<td style='text-align: left; padding-left:53px;' class='col-1' >" + $(this).find("Tdate").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:32px;' class='col-4'>" + $(this).find("Staffname").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:32px;' class='col-4'>" + $(this).find("ProjectName").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:53px;' class='col-2' >" + $(this).find("mjobName").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:32px;' class='col-1'>" + $(this).find("TotalHrs").text() + "</td>";
                        tbl = tbl + "<td style='text-align: left; padding-left:53px;' class='col-6' >" + $(this).find("Narration").text() + "</td>";

                        tbl = tbl + "</tr>";
                    }
                })
                tbl = tbl + "</tbody></table></div>";

            }

            return tbl;
        }
    </script>

    <style type="text/css">
        .container {
            width: 90%;
            max-width: 1200px;
            background: #fff;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            margin-top: 20px;
        }

        .chart-container {
            position: relative;
            margin: auto;
            height: 40vh;
            width: 100%;
            z-index: 10;
            background: white;
        }

        .piechart-container {
            position: relative;
            width: 100%;
            height: 400px; /* Adjust height as needed */
        }

        .table-responsive {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        table, th, td {
          
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        thead {
            background-color: #f4f4f4;
        }

        .card {
            margin-bottom: 20px;
        }

        .col-md-9 {
            flex: 0 0 75%;
            max-width: 75%;
        }

        .col-md-4-1 {
            flex: 0 0 25%;
            max-width: 25%;
            padding-left: 20px;
            padding: 20px;
        }

        .row {
            display: flex;
            flex-wrap: wrap;
        }
        #pieChartContainer {
            width: 100%;
            height: 400px; /* Adjust height as needed */
        }


         .table-responsive {
            position: relative;
            width: 100%;
            z-index: 1;
            margin: auto;
            overflow: auto;
            max-height: 450px;
        }

        .table-scroll {
            overflow: auto;
            min-height: 450px;
        }

        .table-responsive table {
            width: 100%;
            min-width: 1280px;
            margin: auto;
            border-collapse: separate;
            border-spacing: 0;
        }

        .table-wrap {
            position: relative;
        }

        .table-responsive th,
        .table-responsive td {
            padding: 5px 10px;
            background: #fff;
            vertical-align: top;
        }

        .table-responsive thead th {
            position: -webkit-sticky;
            position: sticky;
            top: 0;
            z-index: 2;
        }
        /* safari and ios need the tfoot itself to be position:sticky also */
        .table-responsive tfoot,
        .table-responsive tfoot th,
        .table-responsive tfoot td {
            position: -webkit-sticky;
            position: sticky;
            bottom: 0;
            background: #666;
            color: #fff;
            z-index: 4;
        }

        thead th:first-child,
        tfoot th:first-child {
            z-index: 5;
        }

        .showPageSize {
            border: 1px solid;
            padding: 0px 8px;
            border-radius: 4px;
            color: #307D7E;
            border-color: orange;
        }

        .Pager b {
            margin-top: 2px;
            margin-left: 5px;
            float: left;
            padding-right: 35%;
            padding-top: 8px;
            width: 70%;
            text-align: center !important;
            display: flex;
            justify-content: start;
        }

        .Pager span {
            background-color: #26A69A;
            z-index: 1;
            color: #fff;
            border-color: #26a69a;
            /*/*position: relative;*/ */ overflow: hidden;
            text-align: center;
            /*min-width: 2.8rem;*/
            transition: all ease-in-out .15s;
            /*display: block;*/
            padding: .5rem 1rem;
            line-height: 1.5385;
            border-radius: 10rem;
            margin-right: 3px;
            text-align: center !important;
        }

        .Pager a {
            background-color: #fff;
            z-index: 1;
            color: black;
            border: 1px solid #26a69a;
            position: relative;
            overflow: hidden;
            text-align: center;
            /*min-width: 2.8rem;*/
            transition: all ease-in-out .15s;
            /*display: block;*/
            padding: .5rem 1rem;
            line-height: 1.5385;
            border-radius: 10rem;
            margin-right: 3px;
            text-align: center !important;
        }

        .Pager {
            margin-bottom: 0;
            background-color: #fff;
            border-color: #fff;
            margin-left: 2px;
            /*border-radius: 0.1875rem;*/
            display: flex;
            padding-left: 0;
            height: 40px;
            text-align: center !important;
        }

        .ShowPage {
            float: right;
            display: inline-block;
            margin: 0 0 0 1.25rem;
            width: 50px;
        }

        .Chkbox {
            height: 20px;
            width: 20px;
            cursor: pointer;
            margin-right: 5px;
        }

        .Spancount {
            height: 20px;
            width: 50px;
            font-size: 12px;
            font-weight: bold;
        }

        @media (max-width: 768px) {
            .chart-container {
                height: 50vh;
                width: 100vw;
            }

            .col-md-9, .col-md-4-1 {
                max-width: 100%;
                flex: 0 0 100%;
            }

            .col-md-3 {
                padding-left: 0;
            }
        }
        .calendar-container {
  
            cursor: pointer;
            padding: 10px 15px; /* Increase padding for better spacing */
   
            width: 100%;
            border-radius: 8px; /* Rounded corners */
    

            display: flex; /* Flexbox for alignment */
            align-items: center; /* Center items vertically */
            justify-content: flex-start; /* Align items to the left */
            transition: background-color 0.3s, box-shadow 0.3s; /* Smooth transitions */
            gap: 8px; /* Small gap between calendar icon and text */
        }

        .calendar-container:hover {
            background-color: #e3f2fd; /* Light blue background on hover */
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); /* Increase shadow on hover */
        }

        .calendar-container i.fa-calendar {
            color: #2196f3; /* Blue color for the calendar icon */
            font-size: 1.2em; /* Slightly larger icon */
            padding-left:20px;
        }

        .calendar-container i.fa-caret-down {
            color: #666; 
             margin-left: auto;
        }

        .calendar-container span {
            color: black; 
  

            margin: 0;
            font-size:18px;

        }
        .card1 {
            border: 2px solid #C6D2D9!important; /* Light gray border */
            border-radius: 8px; /* Rounded corners */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Subtle shadow for depth */
            background-color: #fff; /* White background */
            padding: 5px; /* Inner spacing */
            margin: 20px 0; /* Outer spacing */
            max-width: 100%; /* Ensure responsiveness */


        }/* Ensure responsiveness */
        .select-search option {
            font-weight: bold; /* Make text bold */
            color: #ff5733; /* Example: orange text color */
        }
        .select-search {
            font-weight: bold; /* Make text bold */
            color: #333; /* Dark text color */
            padding: 5px; /* Add some padding */
        }

    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField runat="server" ID="hdnCompanyid" />
    <asp:HiddenField runat="server" ID="hdnPageLevel" />
    <asp:HiddenField ID="hdnPages" runat="server" />
    <asp:HiddenField ID="hdnSize" runat="server" />
    <asp:HiddenField ID="hdnEditStaffcode" Value="0" runat="server" />
    <asp:HiddenField ID="hdntxtdateBindStaff" runat="server" />
    <asp:HiddenField ID="hdnRolename" runat="server" />
    <asp:HiddenField ID="hdnwk" runat="server" />
    <asp:HiddenField ID="hdnExpense" runat="server" />
    <asp:HiddenField ID="hdnCompanyPermission" runat="server" />
    <asp:HiddenField ID="hdnSuperAppr" runat="server" Value="false" />
    <asp:HiddenField ID="hdnSubAppr" runat="server" Value="false" />
    <asp:HiddenField ID="htsid" runat="server" />
    <asp:HiddenField ID="hdnDualApp" runat="server" Value="False" />
    <asp:HiddenField ID="hdnNarration" runat="server" />
    <asp:HiddenField ID="hdnFromdate" runat="server" />
    <asp:HiddenField ID="hdnFmdat1" runat="server" />
    <asp:HiddenField ID="hdnTodate" runat="server" />
    <asp:HiddenField ID="hdnTodt1" runat="server" />
    <asp:HiddenField ID="hdncid" runat="server" Value="0" />
    <asp:HiddenField ID="hdnpid" runat="server" Value="0" />
    <asp:HiddenField ID="hdnjid" runat="server" Value="0" />
    <asp:HiddenField ID="hdnsid" runat="server" Value="0" />
    <asp:HiddenField ID="hdntask" runat="server" Value="0" />
    <asp:HiddenField ID="hdndid" runat="server" Value="0" />
    <asp:HiddenField ID="hdnmyStatus" runat="server" Value="false" />
    <asp:HiddenField ID="hdnTSStatus" runat="server" Value="All" />
    <asp:HiddenField ID="hdnExpenseMaster" runat="server" />
    <asp:HiddenField ID="hdnCookieName" runat="server" />
    <asp:HiddenField runat="server" ID="hdnIsRejected" />
    <asp:HiddenField ID="hdnCurrencyMaster" runat="server" />
    <asp:HiddenField runat="server" ID="hdnChrtImg" />
    <asp:HiddenField ID="hdntblData" runat="server" />
    <asp:HiddenField ID="hdnTblCnt" runat="server" />
    <asp:HiddenField ID="hdnPDFData" runat="server" />
   

    <!-- /page header -->

   

<div class="content mt-0">
    <div id="div2levelAllocation" class="card" style="height: 55px;">
                        

            <div class="row">
                <div class="col-md-5">

                    <div class="row">
                        <div id="Wkrange"  class="calendar-container">
                            <i class="fa fa-calendar"></i>&nbsp;
                            <span></span><i class=""></i>
                        </div>

                    </div>

                </div>
                
                
            </div>
        </div>
                  


    <div class="card1">
        <div class="card-body" style="padding-top: 0px; align-content: center; padding-bottom: 10px;">
            <div class="row">

                <div class="col mt-0 d-flex justify-content-end">
                    <input type="checkbox" class="Chkbox" id="chkMy" name="chkMy" />
                    <label id="lblMytime" name="lblMytime" style="font-weight: bold;">Show My Timesheet</label>
                </div>
            </div>
           
         
             <div class="row ">
                <div class="col-3">
                    <div id="divStaffdrp">
                        
                        <div class="col-md-8">
                            <div>
                                
                                    <select id="drpstaff3" name="drpstaff3" class="form-control select-search" data-fouc>
                                    </select>
                                
                            </div>
                        </div>
                    </div>
            </div>

                 
               
                          <div class="col-3">
             
                    <div id="divClintdrp">
                        
                        <div class="col-md-8">
                            <select id="drpclient3" name="drpclient3" class="form-control select-search" data-fouc>
                            </select>
                        </div>
                    </div>
                     </div>
              
                   <div class="col-3">
                    <div id="divprjdrp">
                      
                        <div class="col-md-8">
                            <div>
                                
                                    <select id="drpProj" name="drpProj" class="form-control  select-search" data-fouc>
                                        <option value="0">Project</option>
                                    </select>
                                
                            </div>
                        </div>
                    </div>
                  </div>
                   
                
                 <div class="col-3">

                    <div id="divDept">
                         
                        <div class="col-md-8">
                            <div>
                                
                                    <select id="ddlDept" name="ddlDept" class="form-control  select-search" data-fouc>
                                        <option value="0">Department</option>
                                    </select>
                               
                            </div>
                        </div>
                    </div>
                      </div>
                   <div class="col-3">
                    <div id="divJobActvdrp">
                     
                        <div class="col-md-8">
                            <div>
                                
                                    <select id="drpMjob3" name="drpMjob3" class="form-control select-search" data-fouc>
                                        <option value="0">Activity</option>
                                    </select>
                                </div>
                           
                        </div>
                             </div>
                    </div>
                   <div class="col-3">
                    <div id="divtskdrp" style="display: none;">
                       
                        <div class="col-md-8">
                            <div>
                               
                                    <select id="drpTask" name="drpTask" class="form-control select-search" data-fouc>
                                    </select>
                               
                            </div>
                        </div>
                    </div>
                </div>

            
               
                   <div class="col-3">
                 <div id="divStatus"class="row">
                        

                            <div class="col-md-8">
                             
                                    <div>
                                        <select id="drpstatus" name="drpstatus" class="form-control select select2-hidden-accessible" data-fouc="">
                                            </select>
                                    </div>
                                </div>
                          

                        </div>
                       </div>
                 <div class="col-3">
                 <div id="divNarration" class="row">



                        <div class=" d-flex align-items-center justify-content-center mt-1">
                            <input type="checkbox" class="ChkboxNarrationMsg" id="chkShowNarrationMessage" name="chkShowNarrationMessage" />
                            <div class="col-form-label font-weight-bold ml-2">Show Narration</div>
                        </div>
                    </div>
               </div>
          

                  

            </div>
            </div>
        </div>
    </div>

        <div class="">
            <div class="col-md-12">
                <div class="card1 card-primary card-outline card-outline-tabs">
                    <div id="tbs" class="card-header p-3 border-bottom-0">
                        <ul class="nav nav-tabs" role="tablist">
                            <li class="nav-item"><a id="tb1" href="#TBTimesheet" onclick='Timesheet()' class="nav-link active " data-toggle="tab">Timesheet </a></li>
                            <li class="nav-item"><a id="tb2" href="#TBProject" onclick='Project_Summary()' class="nav-link" data-toggle="tab">Project Analytics  </a></li>
                            <li class="nav-item"><a id="tb3" href="#TBTeam" onclick='Team_Summary()' class="nav-link" data-toggle="tab">Team Summary </a></li>
                            <li class="nav-item"><a id="tb4" href="#TBClient" onclick='Client_Summary()' class="nav-link" data-toggle="tab">Client Summary </a></li>
                            

                        </ul>
                    </div>


                    <div class="tab-content">
                        <div class="tab-pane fade  active show" id="TBTimesheet">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div id="divAllTimesheet" class="">

                                              <div style="padding-top: 0px; align-content: center;">

          
                                            <div class="col-md-12">
                                                <div class="row">
                                                    <!-- First Label and Text -->
                                                    <div class="col-md-2 d-flex align-items-center">
                                                        <div class="col-form-label ">Total Hours:</div>
                                                        <label id="lblTotalHrs" class="font-weight-bold ml-2" style="color:darkorange; font-size:23px;margin-bottom:0rem!important"></label>
                                                    </div>
                                                    <!-- Second Label and Text -->
                                                    <div class="col-md-2 d-flex align-items-center">
                                                        <div class="col-form-label ">Billable:</div>
                                                        <label id="lblTotalBillHrs" class="font-weight-bold ml-2" style="color:green; font-size:23px;margin-bottom:0rem!important"></label>
                                                    </div>
                                                    <!-- Third Label and Text -->
                                                    <div class="col-md-5 d-flex align-items-center">
                                                        <div class="col-form-label ">Non-Billable:</div>
                                                        <label id="lblTotalNonBillHrs" class="font-weight-bold ml-2" style="color:red;font-size:23px; margin-bottom:0rem!important"></label>
                                                    </div>
                                                     <div class="ml-3">
                                                         
                                                            <asp:Button ID="btnexcel" runat="server" OnClick="btnexcel_Click" ToolTip="Export To Excel"
                                                              class="btn btn-success legitRipple buttons-pdf "
                                                                Text="Export To Excel"></asp:Button>

                                                      
                                                       </div>
                                                    
                                                    <div class="ml-3 d-flex flex-row showPageSize" id="divPageSize_AllApproved" style="display: none !important;">
                       

                                                            <div class="ml-2 d-flex justify-content-right align-items-right">
                                                                <select id="drpPageSize_AllApproved" name="drpPageSize_AllApproved" class="form-control select select2-hidden-accessible col-4 select-drop-size" data-fouc>
                                                                    <option value="25">25</option>
                                                                    <option value="50">50</option>
                                                                    <option value="100">100</option>
                                                                    <option value="200">200</option>
                                                                    <option value="500">500</option>
                                                                    <option value="1000">1000</option>
                                                                </select>
                                                            </div>
                       
                                                        </div>
                                                </div>
                                            </div>
                                        </div>
           

                                                <div class="row">
                 

                                                    <div class="col-6 d-flex flex-row justify-content-end mt-0">
                                                        <div>
                                                            <input type='button' id='btnStatusAppr' name='btnStatusAppr' class='btn btn-outline-success btn-sm' value='Approve' />
                                                        </div>
                                                        <div class="ml-3">
                                                            <input type='button' id='btnStatusReject' name='btnStatusReject' class='btn btn-outline-danger btn-sm' value='Reject' />
                                                        </div>
                                                        <div class="ml-3 d-flex align-items-center justify-content-center">
                                                            <input type="checkbox" class="Chkbox" id="chkApprovedAll" name="chkApprovedAll" />
                                                            <label style="font-weight: bold;" id="lblAppr" name="lblAppr" class="m-0">Select All</label>
                                                        </div>
                   

                                                    </div>
                                                </div>


                                                <div class="row">

                                                    <div class="col-md-12">

                                                        <div class="table-responsive" id="table-responsive">
                                                            <table id="tbl_AllTimesheet" class="table table-hover table-xs font-size-base "></table>
                                                        </div>
                                                        <table id="tblPager_AllApproved" style="border: 1px solid #BCBCBC; height: 50px; width: 100%; display: none;">
                                                            <tr>
                                                                <td>
                                                                    <div class="Pager">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>

                                        <div id="divPenidingTS" style="display: none;" class="card">

                                            <div class="card-body" style="padding-top: 0px; padding-bottom: 0px; padding-right: 0px; padding-left: 10px;">
                                                <div class="row">
                                                    <div class="col-6 mt-1">
                                                        <label id="lblsts" style="font-weight: bold;">Approval Pending</label>
                                                    </div>
                                                    <div class="col-6 d-flex flex-row justify-content-end mt-0">
                                                        <div>
                                                            <input type='button' id='btnAppr' name='btnAppr' class='btn btn-outline-success btn-sm' value='Approve' />
                                                        </div>
                                                        <div class="ml-3">
                                                            <input type='button' id='btnRej' name='btnRej' class='btn btn-outline-danger btn-sm' value='Reject' />
                                                        </div>
                                                        <div class="ml-3 d-flex align-items-center justify-content-center">
                                                            <input type="checkbox" class="Chkbox" id="chkAlltsid" name="chkAlltsid" />
                                                            <label style="font-weight: bold;" id="lblsct" name="lblsct" class="m-0">Select All</label>
                                                        </div>
                                                        <div class="ml-3 d-flex flex-row showPageSize" id="divPageSize_Pending" style="display: none !important;">
                                                            <%--<div class="d-flex justify-content-center align-items-center">
                                                                <label id="lblPageSize_Pending" name="lblPageSize" class="m-0">Show</label>
                                                            </div>--%>
                                                            <div class="ml-2 d-flex justify-content-center align-items-center">
                                                                <select id="drpPageSize_Pending" name="drpPageSize_Pending" class="form-control select select2-hidden-accessible col-4 select-drop-size" data-fouc>
                                                                    <option value="25">25</option>
                                                                    <option value="50">50</option>
                                                                    <option value="100">100</option>
                                                                    <option value="200">200</option>
                                                                    <option value="500">500</option>
                                                                    <option value="1000">1000</option>
                                                                </select>
                                                            </div>
                                                            <%--<div class="ml-2 d-flex justify-content-center align-items-center">
                                                                <label id="lblPageEntries_Pending" name="lblPageEntries" class="m-0">Records</label>
                                                            </div>--%>
                                                        </div>
                                                    </div>
                                                </div>

                                                <hr />

                                                <div class="row">

                                                    <div class="col-md-12">
                                                        <div class="table-responsive">
                                                            <table id="tbl_PendingTS" name="tbl_PendingTS" class="table table-hover table-xs font-size-base"></table>
                                                        </div>
                                                        <table id="tblPager_Pending" style="border: 1px solid #BCBCBC; height: 50px; width: 100%; display: none;">
                                                            <tr>
                                                                <td>
                                                                    <div class="Pager">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div id="divStaffsum" style="display: none;" class="card">

                                            <div class="card-body">

                                                <div class="row">
                                                    <div class="col-6 mt-1">
                                                        <label id="lblStaffSummarysts" style="font-weight: bold;">Staff Summary</label>
                                                    </div>
                                                    <div class="col-6 d-flex flex-row justify-content-end mt-2">
                                                        <div class="ml-3 d-flex flex-row showPageSize" id="divPageSize_StaffSummary" style="display: none !important;">
                                                            <%--<div class="d-flex justify-content-center align-items-center">
                                                                <label id="lblPageSize_StaffSummary" name="lblPageSize" class="m-0">Show</label>
                                                            </div>--%>
                                                            <div class="ml-2 d-flex justify-content-center align-items-center">
                                                                <select id="drpPageSize_StaffSummary" name="drpPageSize_StaffSummary" class="form-control select select2-hidden-accessible col-4 select-drop-size" data-fouc>
                                                                    <option value="25">25</option>
                                                                    <option value="50">50</option>
                                                                    <option value="100">100</option>
                                                                    <option value="200">200</option>
                                                                    <option value="500">500</option>
                                                                    <option value="1000">1000</option>
                                                                </select>
                                                            </div>
                                                            <%--<div class="ml-2 d-flex justify-content-center align-items-center">
                                                                <label id="lblPageEntries_StaffSummary" name="lblPageEntries" class="m-0">Records</label>
                                                            </div>--%>
                                                        </div>
                                                    </div>
                                                </div>
                                                <%-- <legend class="font-weight-bold">Staff Summary</legend>--%>

                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <div class="table-responsive">
                                                            <table id="tblStaffSummary" name="tblStaffSummary" class="table table-hover table-xs font-size-base "></table>
                                                        </div>
                                                        <table id="tblPager_StaffSummary" style="border: 1px solid #BCBCBC; height: 50px; width: 100%; display: none;">
                                                            <tr>
                                                                <td>
                                                                    <div class="Pager">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div id="divTSNotSub" style="display: none;" class="card">

                                            <div class="card-body" style="padding: 0;">
                                                <div class="row">
                                                    <div class="col-6 mt-1">
                                                        <label id="lblTimesheetnotsubmitted" style="font-weight: bold;">Timesheet not submitted</label>
                                                    </div>
                                                    <div class="col-6 d-flex flex-row justify-content-end mt-2">
                                                        <div class="col-3">
                                                            <asp:Button ID="Button1" runat="server" OnClick="btnTSNotl_Click"
                                                                class=" buttons-pdf btn btn-outline-success legitRipple"
                                                                Text="Export to Excel"></asp:Button>
                                                        </div>
                                                        <div class="ml-3 d-flex flex-row showPageSize" id="divPageSize_Timesheetnotsubmitted" style="display: none !important;">
                                                            <%--<div class="d-flex justify-content-center align-items-center">
                                                                <label id="lblPageSize_Timesheetnotsubmitted" name="lblPageSize" class="m-0">Show</label>
                                                            </div>--%>
                                                            <div class="ml-2 d-flex justify-content-center align-items-center">
                                                                <select id="drpPageSize_Timesheetnotsubmitted" name="drpPageSize_StaffSummary" class="form-control select select2-hidden-accessible col-4 select-drop-size" data-fouc>
                                                                    <option value="25">25</option>
                                                                    <option value="50">50</option>
                                                                    <option value="100">100</option>
                                                                    <option value="200">200</option>
                                                                    <option value="500">500</option>
                                                                    <option value="1000">1000</option>
                                                                </select>
                                                            </div>
                                                            <%--<div class="ml-2 d-flex justify-content-center align-items-center">
                                                                <label id="lblPageEntries_Timesheetnotsubmitted" name="lblPageEntries" class="m-0">Records</label>
                                                            </div>--%>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="row">

                                                    <div class="col-md-12">
                                                        <div class="table-responsive">
                                                            <table id="tblTSNotSub" name="tblTSNotSub" class="table table-hover table-xs font-size-base ">
                                                            </table>
                                                        </div>
                                                        <table id="tblPager_TSNotSub" style="border: 1px solid #BCBCBC; height: 50px; width: 100%; display: none;">
                                                            <tr>
                                                                <td>
                                                                    <div class="Pager">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div id="divMinHrs" style="display: none;" class="card">

                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-6 mt-1">
                                                        <label id="lblMinHrs" style="font-weight: bold;">Minimum Hours not Entered</label>
                                                    </div>
                                                    <div class="col-6 d-flex flex-row justify-content-end mt-2">
                                                        <div class="col-3">
                                                            <asp:Button ID="btnMiniExcel" runat="server" OnClick="btnMiniExcel_Click"
                                                                class=" buttons-pdf btn btn-outline-success legitRipple"
                                                                Text="Export to XL"></asp:Button>
                                                        </div>
                                                        <div class="col-4 ml-3 d-flex flex-row showPageSize" id="divPageSize_MinHrs" style="display: none !important;">
                                                            <%--<div class="d-flex justify-content-center align-items-center">
                                                                <label id="lblPageSize_MinHrs" name="lblPageSize" class="m-0">Show</label>
                                                            </div>--%>
                                                            <div class="ml-2 d-flex justify-content-center align-items-center">
                                                                <select id="drpPageSize_MinHrs" name="drpPageSize_MinHrs" class="form-control select select2-hidden-accessible col-4 select-drop-size" data-fouc>
                                                                    <option value="25">25</option>
                                                                    <option value="50">50</option>
                                                                    <option value="100">100</option>
                                                                    <option value="200">200</option>
                                                                    <option value="500">500</option>
                                                                    <option value="1000">1000</option>
                                                                </select>
                                                            </div>
                                                            <%--<div class="ml-2 d-flex justify-content-center align-items-center">
                                                                <label id="lblPageEntries_MinHrs" name="lblPageEntries" class="m-0">Records</label>
                                                            </div>--%>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row">

                                                    <div class="col-md-12">
                                                        <div class="table-responsive">
                                                            <table id="tblMinHrs" name="tblMinHrs" class="table table-hover table-xs font-size-base ">
                                                            </table>
                                                        </div>
                                                        <table id="tblPager_MinHrs" style="border: 1px solid #BCBCBC; height: 50px; width: 100%; display: none;">
                                                            <tr>
                                                                <td>
                                                                    <div class="Pager">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                 
                        <div class="tab-pane fade" id="TBProject">
                            
                           
                                <div class="card1">
                                    
                                          <div class="row">
                           <div class="col-3">
                           <div class="row" style="padding-left: 12px;"> 
                            <label  class="col-form-label col-1.5 font-weight-bold" >Date :</label> 
                            <label id="lblPrj" class="col-form-label "  style="padding-top: 0px; padding-left: 12px;text-align: center; font-size:large;font-weight:bold;color:darkorange;"></label>
                            </div>
                            </div>
                           
                                   <div class="col-3">
                                          <div class="row"> 
                                <label  class="col-form-label col-1.5 font-weight-bold" style="padding-top:6px;">Dept:</label>                                 
                                              <div class="col-md-10" style="padding-left: 25px;">
                                <select id="drpDept" name="drpDept" class="multiselect row form-control form-control-border" multiple="multiple"  data-mdb-placeholder="Select Value" aria-label="Period">
                                </select>
                            </div>
                          </div>
                       </div>
                       <div class="col-4">
                          <div class="row"> 

                                <label  class="col-form-label col-1.5 font-weight-bold" style="padding-top:6px;">Explore:</label> 
                                  <div class="col-md-7">
                                        <select id="drptopprj" name="drptopprj" class="form-control form-control-border select select2-hidden-accessible col-4 select-drop-size" data-fouc>
                                            <option value="ProjectName">Project Alphabatically</option>
                                            <option value="Top">Top Perfoming Project</option>
                                        </select>
                                 </div>
                          </div>
                       </div>

                                   <div class="ml-3">
                                                     
                                                            


                                                         <asp:ImageButton id="btnExportPDF" runat="server"   tooltip="Export To PDF"  OnClick="btnExportPDF_Click" Text ="Export PDF" ImageUrl="~/img/PDF.png" />
                                                        </div>
                                </div>
                                    </div>
                         

                          
                            <div class="row"> 
                            <div class="col-md-8">
                                <div class="card" style="height:333px; border: 2px solid #f4f6f9;border-radius: 8px;box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">
                                    <div class="card-body">

                                       
                                            <div class="chart-container  ">
                                                <div class="chart has-fixed-height svg-center" style="width:655px; height:300px;" id="pie_Chrt"></div>
                                            </div>
    

                                         
                                     </div>
                                 </div>
                             </div>
                                
                                    
                            <div class="col-md-4">
                                <div class="card" style="height:333px;border: 2px solid #f4f6f9;border-radius: 8px;box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">
                                    <div class="card-primary" >


                                        <div class="card-header">
                                            <h3 class="card-title ">Utilisation Hours Summary</h3>
                                        </div>
                                        <div class="card-body">
                                       
                                    <div class="form-group row" style="margin-bottom:1px;">
                                        <label class="col-form-label col-lg-5  " >Total Man Hrs</label>
                                        <div class="col-6" >
                                                <label id="lblTManHrs" class="col-form-label col-lg-8 form-control form-control-border"  style="padding-top: 10px;text-align: center; font-size:larger;font-weight:bold;color:darkorange;">0</label>
                                        </div>
                                    </div>
                                    <div class="form-group row" style="margin-bottom:1px;">
                                        <label class="col-form-label col-lg-5  " >Holiday Hrs</label>
                                        <div class="col-6" >
                                                <label id="lblHoliHrs" class="col-form-label col-lg-8 form-control form-control-border"  style="padding-top: 10px;text-align: center; font-size:larger;font-weight:bold;color:#007bff;">0</label>
                                        </div>
                                    </div>
                                    <div class="form-group row" style="margin-bottom:1px;">
                                        <label class="col-form-label col-lg-5 " >Available Man Hrs</label>
                                        <div class="col-6" >
                                                <label id="lblTAvlHrs" class="col-form-label col-lg-8 form-control form-control-border"  style="padding-top: 10px;text-align: center; font-size:larger;font-weight:bold;color:#d32535;">0</label>
                                        </div>
                                    </div>
                                    <div class="form-group row" style="margin-bottom:1px;">
                                        <label class="col-form-label col-lg-5 " >Proj.Dlvry Man Hrs</label>
                                        <div class="col-6" >
                                                <label id="lblDlvPrjHrs" class="col-form-label col-lg-8 form-control form-control-border" style="padding-top: 10px;text-align: center; font-size:larger;font-weight:bold;color:darkorange;">0</label>
                                        </div>
                                    </div>
                                    <div class="form-group row" style="margin-bottom:1px;">
                                        <label class="col-form-label col-lg-5 " >Utilization</label>
                                        <div class="col-6" >
                                                <label id="lblUtil" class="col-form-label col-lg-8 form-control  form-control-border"  style="padding-top: 10px;text-align: center; font-size:larger;font-weight:bold;color:#28a745;">0</label>
                                        </div>
                                    </div>
                                    </div>
                                    </div>
                               </div>
                          </div>

                            </div>
                            <div class="card"style="border: 2px solid #f4f6f9; border-radius: 8px;box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);">
                                <div class="card-body">

                                    <div class="row">
                                        <div class="col-md-12">

                                            <div class="table-responsive" id="table-Project">
                                                <table id="tbl_ProjectSummary" class="table table-hover table-xs font-size-base "></table>
                                            </div>
                                            <table id="ProjectSummary_Pager" style="border: 1px solid #BCBCBC; height: 50px; width: 100%;">
                                                <tr>
                                                    <td>
                                                        <div class="Pager">
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>

 
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>      
                        
                        <div class="tab-pane fade" id="TBTeam">
                            <div class="card1">
                            <div class="row"> 
                                
                                
                               <div class="col-3">
                                   <div class="row" style="padding-left: 12px;"> 
                                        <label  class="col-form-label col-1.5 font-weight-bold" >Date :</label> 
                                        <label id="lblteam" class="col-form-label "  style="padding-top: 0px; padding-left: 12px;text-align: center; font-size:large;font-weight:bold;color:darkorange;"></label>
                                    </div>
                                </div>
                           
                                <div class="col-4">
                                    <div class="row"> 
                                        <label  class="col-form-label col-2 font-weight-bold" style="padding-top:6px;">Dept&nbsp:</label> 
                                        <div class="col-md-6">
                                            <select id="drpTMDp" name="drpTMDp" class="multiselect row" multiple="multiple"  data-mdb-placeholder="Select Value" aria-label="Period">
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                 <div class="col-3">
                                          <div class="row"> 

                                <label  class="col-form-label col-1.5 font-weight-bold" style="padding-top:6px;">Explore:</label> 
                                              <div class="col-md-8">
                                <select id="drpteam" name="drpteam" class="form-control form-control-border select select2-hidden-accessible col-4 select-drop-size" data-fouc>
                                        <option value="1">Active</option>
                                        <option value="0">Inactive</option>
                                        <option value="2">Minimum Hours Not Entered</option>
                                        <option value="3">Best Performer</option>
                                        <option value="4">Lowest Performer</option>
                                 </select>
                            </div>
                          </div>
                                     </div>
                                <div class="ml-3">
                                    
                                    
                                    <asp:ImageButton id="btnTMExportPDF" runat="server"   Text ="Export PDF" Imageurl="~/img/PDF.png"/>
                                </div>
                              
                            </div>
                        </div>
                            <div class="card1">
                                <div class="card-body"  style="height:320px;">
                                        <div class="chart-container">
                                            <div class="chart has-fixed-height" style="height:300px;" id="TM_Statistics"></div>
                                        </div>
                                    </div>
                                </div>

                            <div class="card">
                                <div class="card-body">

                                    <div class="row">
                                        <div class="col-md-12">

                                            <div class="table-responsive"  >
                                                <table id="tbl_TeamSummary" class="table table-hover table-xs font-size-base "></table>
                                            </div>
                                            <table id="TeamSummary_Pager" style="border: 1px solid #BCBCBC; height: 50px; width: 100%;">
                                                <tr>
                                                    <td>
                                                        <div class="Pager">
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>

 
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>  

                        <div class="tab-pane fade" id="TBClient">
                            <div class="">
                                <div class="card-body">
                                    <div class="row"> 
                                        <label  class="col-form-label col-2 font-weight-bold" style="padding-top:6px;">Type&nbsp:</label> 
                                        <div class="col-md-4">
                                            <select id="drpCltType" name="drpCltType" class="form-control form-control-border select select2-hidden-accessible col-4 select-drop-size" data-fouc>
                                            <option value="Stf">Staffwise</option>
                                            <option value="Clt">Clientwise</option>                                            
                                            </select>
                                        </div>
                                    </div>
                                    <div class="row">

                                        <div class="table-responsive"  >
                                            <table id="tbl_ClientSummary" class="table table-hover table-xs font-size-base "></table>
                                        </div>
                                        <table id="ClientSummary_Pager" style="border: 1px solid #BCBCBC; height: 50px; width: 100%;">
                                            <tr>
                                                <td>
                                                    <div class="Pager">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>


                                    </div>
                                </div>
                            </div>
                        </div>  
               

                </div>
            </div>
        </div>

   
    <!-- Modal with h3 -->
    <div id="modal_h3" class="modal fade" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="h3Narrat" name="h3Narrat">Narration</h3>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <div class="modal-body">
                    <h7 class="font-weight-semibold">
                        <table>
                            <tr>
                                <td style="font-weight: bold; width: 135px;">Date</td>
                                <td></td>
                                <td id="lblnrrdt"></td>
                            </tr>
                            <tr>
                                <td style="font-weight: bold;">Project / Job</td>
                                <td></td>
                                <td id="lblnrrPJ"></td>
                            </tr>

                            <tr>
                                <td style="font-weight: bold;">Staff </td>
                                <td></td>
                                <td id="lblnrrSf"></td>
                            </tr>

                            <tr>
                                <td style="font-weight: bold;">Total Time</td>
                                <td></td>
                                <td id="lblnrrTT"></td>
                            </tr>
                        </table>

                    </h7>


                    <hr>

                    <h6 id="pNarr" class="font-weight-semibold"></h6>
                    <textarea id="txtResn" name="txtResn" rows="5" cols="5" class="form-control" placeholder="Enter your Reason here"></textarea>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-link" data-dismiss="modal">Close</button>
                    <button type="button" id="Save3Reson" class="btn bg-primary legitRipple" data-dismiss="modal">Save</button>
                </div>
            </div>
        </div>
    </div>

    <div id="modalNarr2lvl" class="modal fade" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="h2Narrat" name="h2Narrat" class="modal-title">Narration</h3>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <div class="modal-body">
                    <h7 class="font-weight-semibold">
                        <table>
                            <tr>
                                <td style="font-weight: bold; width: 135px;">Date</td>
                                <td></td>
                                <td id="tdnrrdt"></td>
                            </tr>
                            <tr>
                                <td style="font-weight: bold;">Client / Job</td>
                                <td></td>
                                <td id="tdnrrPJ"></td>
                            </tr>

                            <tr>
                                <td style="font-weight: bold;">Staff </td>
                                <td></td>
                                <td id="tdnrrSf"></td>
                            </tr>

                            <tr>
                                <td style="font-weight: bold;">Total Time</td>
                                <td></td>
                                <td id="tdnrrTT"></td>
                            </tr>
                        </table>

                    </h7>


                    <hr>

                    <h6 id="p2lblNarr" class="font-weight-semibold"></h6>
                    <textarea id="txt2Resn" name="txt2Resn" rows="5" cols="5" class="form-control" placeholder="Enter your Reason here"></textarea>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-link" data-dismiss="modal">Close</button>
                    <button type="button" id="Save2Reson" class="btn bg-primary legitRipple">Save</button>
                </div>
            </div>
        </div>
    </div>

    <div id="modalEditTS2lvl" class="modal fade" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-primary-1">
                    <h3 id="editdate" name="editdate" class="modal-title">Edit Timesheet</h3>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <div class="modal-body">

                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group row">
                                <asp:HiddenField ID="hdnEdittsid" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="hdnedDate" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="hdnTStfcode" runat="server"></asp:HiddenField>
                                <asp:HiddenField ID="hdnEJobid" runat="server" />
                                <asp:HiddenField ID="hdnmjid" runat="server" />
                                <asp:HiddenField ID="hdnPrehrs" runat="server" />
                                <asp:HiddenField ID="hdn2lvl" runat="server" />
                                <div class="col-lg-9">
                                </div>
                            </div>
                            <div class="row">
                                <label class="col-lg-3 col-form-label font-weight-bold">Client:</label>
                                <div class="col-lg-9">
                                    <label id="editclientname" class="col-form-label "></label>
                                </div>
                            </div>
                            <div id="dvprj" class="row">
                                <label class="col-lg-3 col-form-label font-weight-bold">Project:</label>
                                <div class="col-lg-9">
                                    <label id="editproject" class="col-form-label "></label>
                                </div>
                            </div>
                            <div class="row">
                                <label class="col-lg-3 col-form-label font-weight-bold">Job:</label>
                                <div id="dvAct" class="col-lg-9">
                                    <select id="ddlEditJob_" name="ddlEditJob_" class="form-control col-form-label select" style="font-size: 15px;" tabindex="-1" onchange="ShowJobEditSelect($(this))">
                                        <option value="0" selected="selected">Select</option>
                                    </select>
                                </div>
                                <div id="dvmJob" class="col-lg-9">
                                    <label id="editjobname" class="col-form-label "></label>

                                </div>
                            </div>
                            <div class="row">
                                <label class="col-lg-3 col-form-label font-weight-bold">Status:</label>
                                <div class="col-lg-3">
                                    <label id="editstatus" class="col-form-label "></label>
                                </div>
                                <div class="col-lg-2">
                                    <label class="col-form-label font-weight-bold">Billable</label>
                                </div>
                                <div class="col-lg-2">
                                    <input type="checkbox" id="editChk" name="editChk" class="Chkbox" style="cursor: pointer" />
                                </div>
                            </div>
                            <div class="row">
                                <label class="col-lg-3 col-form-label font-weight-bold">Total Time:</label>
                                <div class="col-lg-3">
                                    <input type="text" id="TxtedtTottime" name="TxtedtTottime" onchange="ShowEditChange()" class="form-control" style="font-size: 0.915rem;" value="00.00" />
                                </div>
                            </div>
                            <div class="row">
                                <label class="col-lg-3 col-form-label font-weight-bold">Narration:</label>
                                <div class="col-lg-9">
                                    <textarea id="editnarration" name="editnarration" rows="5" cols="5" class="form-control" placeholder="Enter your Narration here"></textarea>
                                    <div style="color: crimson"><span id="txt-narr-length-left"></span>&nbsp;Characters Remaining</div>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-warning  legitRipple" data-dismiss="modal">Close</button>
                    <%--<input type="button" id="btnapproveedit" class="btn btn-outline-primary rounded-round legitRipple" data-dismiss="modal" value="Submit For Approval" onclick="saveEditTimesheetInput('Submitted')" />--%>
                    <input type="button" id="btnapprovesave" class="btn btn-outline-success  legitRipple" data-dismiss="modal" value="Save" onclick="saveEditTimesheetInput('Saved')" />
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="ModalExpenseId" tabindex="-1" role="dialog" aria-labelledby="ModalExpenseId" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header bg-primary-1">
                    <h5 class="modal-title" id="exampleModalLabel">Expense</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-2 d-flex align-items-center justify-content-center">
                            <div class="font-weight-bold col-form-label">Expense:</div>
                        </div>
                        <div class="col-3">
                            <select id="SelectExpense" class="form-control select ">
                                <option value="0">Select</option>
                            </select>
                        </div>
                        <div class="col-2 d-flex align-items-center justify-content-center">
                            <div class="font-weight-bold col-form-label">Amount:</div>
                        </div>
                        <div class="col-2">
                            <input type="text" id="txtEAmt" runat="server" class="form-control form-control-border" placeholder="Amount" onkeyup="return validateDecimalNumber(this)" />
                        </div>
                        <div class="col-1 d-flex align-items-center justify-content-center">
                            <div class="font-weight-bold col-form-label">Curr.:</div>
                        </div>
                        <div class="col-2">
                            <select id="drpCurrency" name="drpCurrency"
                                class="form-control select">
                                <option value="0">Select</option>
                            </select>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-2 d-flex align-items-center justify-content-center">
                            <div class="font-weight-bold col-form-label">Narration:</div>
                        </div>
                        <div class="col-7">
                            <textarea id="txtNarration" name="txtNarration" class="form-control form-control-border" runat="server" type="text" />
                        </div>
                        <div class="col-3 text-right mt-3">
                            <input type="button" id="btnEsave" runat="server" class="btn btn-outline-success legitRipple" value="Save To Grid" />
                        </div>
                        <asp:HiddenField ID="hdnExpenseRowID" runat="server" />
                        <asp:HiddenField ID="hdnTsID" runat="server" />
                        <asp:HiddenField ID="hdnTsExpID" runat="server" />
                        <asp:HiddenField ID="hdnExSfcode" runat="server"></asp:HiddenField>
                        <asp:HiddenField ID="hdnTsCurrency" runat="server" />
                    </div>
                    <div class="row mt-5">
                        <table id="Tbl_Expense" class="table table-hover table-xs font-size-base">
                            <thead>
                                <tr>
                                    <th>Expense
                                    </th>
                                    <th>Narration
                                    </th>
                                    <th>Amount
                                    </th>
                                    <th>Delete</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" id="btnSaveExpense" name="btnSaveExpense" runat="server" data-dismiss="modal" class="btn btn-outline-success legitRipple" value="Save" />
                    <input type="button" id="btnECancel" runat="server" data-dismiss="modal" value="Cancel" class="btn btn-outline-success legitRipple" />
                </div>
            </div>
        </div>
    </div>


    <div id="modal_Reason" class="modal fade" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="modal-title" id="h3Narrat1" name="h3Narrat">Reject Reason</h3>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <div class="modal-body">
                    <h7 class="font-weight-semibold">
                        <table>
                            <tr>
                                <td style="font-weight: bold; width: 135px;">Date</td>
                                <td></td>
                                <td id="lblnrrdt1"></td>
                            </tr>
                            <tr>
                                <td style="font-weight: bold;">Project / Job</td>
                                <td></td>
                                <td id="lblnrrPJ1"></td>
                            </tr>
                            <tr>
                                <td style="font-weight: bold;">Total Time</td>
                                <td></td>
                                <td id="lblnrrTT1"></td>
                            </tr>
                        </table>
                    </h7>
                    <h6 id="pNarr1" class="font-weight-semibold"></h6>
                    <textarea id="txtResn1" name="txtResn1" rows="5" cols="5" class="form-control" placeholder="Enter your Reason here"></textarea>
                </div>

                <div class="modal-footer">
                    <button type="button" id="btnReson" data-dismiss="modal" class="btn btn-outline-success legitRipple">Close</button>
                </div>
            </div>
        </div>
    </div>
</div>
    <!-- /modal with h3 -->

</asp:Content>

