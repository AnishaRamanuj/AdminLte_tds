
var myProject = '';
var statusColorLegend = { "Submitted": "orange", "Saved": "SkyBlue", "Approved": "LimeGreen", "Rejected": "IndianRed", "Semi Approved": "Yellow" };
var editedDataElem;
Array.prototype.remove = function remove(item) {
    var output = [];
    for (var i = 0; i < this.length; i++) {
        if (this[i] != item) {
            output.push(this[i]);
        }
    }
    return output;
}
$(document).ready(function () {
    editedDataElem = $("div.grids-wrapper");
    $("body").on("dblclick", ".icon-checkmark2", function () {
        $(this).removeClass("icon-checkmark2").removeClass("text-success");
        $(this).addClass("icon-cross3").addClass("text-danger").addClass("edited");
        var tr = $(this).closest("tr");
        SetEditedData(tr.data("id"), "IsBillable", false);
        tr.find("input[name=txteditbillablehrs]").attr("disabled", "disabled").val("00.00");
    });

    $("body").on("dblclick", ".icon-cross3", function () {
        $(this).removeClass("icon-cross3").removeClass("text-danger");
        $(this).addClass("icon-checkmark2").addClass("text-success").addClass("edited");
        var tr = $(this).closest("tr");
        SetEditedData(tr.data("id"), "IsBillable", true);
        var editedHours = GetEditedData(tr.data("id"), "EditedHours");
        tr.find("input[name=txteditbillablehrs]")
            .removeAttr("disabled")
            .val(editedHours != undefined ? editedHours : tr.find("input[name=txteditbillablehrs]").closest("td").prev().text())
            .focus().blur();
    });
    CompanyPermissions = jQuery.parseJSON($("[id*=hdnCompanyPermission]").val());
    $("#hdnCurrentPage").val(1);
    $("[id*=hdnSize]").val(500);
    GetTimesheetVwrdropdown();
    PieGraph();
    $('.sidebar-main-toggle').click();
    ///Hide Unhide Admin/Approver/Staff
    if ($("[id*=hdnEditStaffcode]").val() > 0) {
        //if ($("[id*=hdnPageLevel]").val() > 2) {
        if ($("[id*=hdnRolename]").val() == 'Staff') {
            $("[id*=btnAppr]").hide();
            $("[id*=btnRej]").hide();
            $("[id*=chkAlltsid]").hide();
            $("[id*=lblsct]").hide();
            $("[id*=divStaffdrp]").hide();
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
    $("[id*=txtfrom]").val($("[id*=hdnFromdate]").val());
    $("[id*=txtto]").val($("[id*=hdnTodate]").val());

    $("[id*=btnnxt]").on('click', function () {
        var datevalue = $("[id*=txtdateBindStaff]").val();
        var fromdate = datevalue.split('-')[1];
        fromdate = fromdate.split('/');
        var year = fromdate[2], month = (parseFloat(fromdate[1]) - 1), day = (parseFloat(fromdate[0]) + 1);
        // The value of `meses`
        var offset = 6; // Tomorow
        var future_date = new Date(year, month, parseFloat(day) + parseFloat(offset));
        var dt = new Date(year, month, parseFloat(day));
        $("[id*=txtdateBindStaff]").val(dt.format('dd/MM/yyyy'));
        $("[id*=txtdateBindStaff]").val($("[id*=txtdateBindStaff]").val() + ' - ' + future_date.format('dd/MM/yyyy'));
        $("[id*=lblweekdt]").html($("[id*=txtdateBindStaff]").val());
        $("[id*=txtfrom]").val(dt.format('yyyy-MM-dd'));
        $("[id*=txtto]").val(future_date.format('yyyy-MM-dd'));

        $("[id*=hdnFromdate]").val(dt.format('dd/MM/yyyy'));
        $("[id*=hdnTodate]").val(future_date.format('dd/MM/yyyy'));

        $("[id*=hdnFmdat1]").val('');
        $("[id*=hdnFmdat1]").val(dt.format('yyyy-MM-dd'));

        $("[id*=hdnTodt1]").val('');
        $("[id*= hdnTodt1]").val(future_date.format('yyyy-MM-dd'));
        chkStatus();
        PieGraph();
    });

    $("[id*=btnPrv]").on('click', function () {
        var datevalue = $("[id*=txtdateBindStaff]").val();
        var fromdate = datevalue.split('-')[0];
        $("[id*=txtdateBindStaff]").val(fromdate);
        fromdate = fromdate.split('/');
        var year = fromdate[2], month = (parseFloat(fromdate[1]) - 1), day = (parseFloat(fromdate[0]) - 1);
        // The value of `meses`
        var offset = 6; // past
        var future_date = new Date(year, month, parseFloat(day) - parseFloat(offset));
        var dt = new Date(year, month, parseFloat(day));
        $("[id*=txtdateBindStaff]").val(dt.format('dd/MM/yyyy'));
        $("[id*=txtdateBindStaff]").val(future_date.format('dd/MM/yyyy') + ' - ' + $("[id*=txtdateBindStaff]").val());
        $("[id*=lblweekdt]").html($("[id*=txtdateBindStaff]").val());
        $("[id*=txtto]").val(dt.format('yyyy-MM-dd'));
        $("[id*=txtfrom]").val(future_date.format('yyyy-MM-dd'));


        $("[id*=hdnFromdate]").val(future_date.format('dd/MM/yyyy'));
        $("[id*=hdnTodate]").val(dt.format('dd/MM/yyyy'));

        $("[id*=hdnFmdat1]").val('');
        $("[id*=hdnFmdat1]").val(future_date.format('yyyy-MM-dd'));

        $("[id*=hdnTodt1]").val('');
        $("[id*= hdnTodt1]").val(dt.format('yyyy-MM-dd'));
        chkStatus();
        PieGraph();
    });

    $("[id*= drpclient3]").on('change', function () {
        $("[id*= hdncid]").val($("[id*= drpclient3]").val());
        if (CompanyPermissions[0].ProjectnClient == 0) {
            if ($("[id*=hdnPageLevel]").val() == '2') {

                fillJobDrpdwn();
            } else {
                fillPrjDrpdwn();
            }
        }
        chkStatus();
    });

    $("[id*= btnexcel]").on('click', function () {
        Blockloadershow();
        $("[id*=hdnFmdat1]").val($("[id*= txtfrom]").val());
        $("[id*= hdnTodt1]").val($("[id*= txtto]").val());
    });

    $("[id*= btnTSNot]").on('click', function () {
        Blockloadershow();
        $("[id*=hdnFmdat1]").val($("[id*= txtfrom]").val());
        $("[id*= hdnTodt1]").val($("[id*= txtto]").val());
    });

    $("[id*= btnMiniExcel]").on('click', function () {
        Blockloadershow();
        $("[id*=hdnFmdat1]").val($("[id*= txtfrom]").val());
        $("[id*= hdnTodt1]").val($("[id*= txtto]").val());
    });

    $("[id*= txtfrom]").on('change', function () {
        $("[id*=hdnFmdat1]").val('');
        $("[id*=hdnFmdat1]").val($("[id*= txtfrom]").val());
        $("[id*= hdnTodt1]").val($("[id*= txtto]").val());
        var frodt = $("[id*=hdnFmdat1]").val();
        chkStatus();
    });

    $("[id*= txtto]").on('change', function () {
        $("[id*=hdnTodt1]").val('');
        $("[id*= hdnTodt1]").val($("[id*= txtto]").val());
        $("[id*=hdnFmdat1]").val($("[id*= txtfrom]").val());
        chkStatus();
    });

    $("[id*= drpstatus]").on('change', function () {

        chkStatus();
    });

    $("[id*= drpProj]").on('change', function () {
        $("[id*= hdnpid]").val($("[id*= drpProj]").val());
        GetJobnamelevel3();
        chkStatus();
    });

    $("[id*= drpTask]").on('change', function () {
        $("[id*= hdntask]").val($("[id*= drpTask]").val());
        chkStatus();
    });

    $("[id*= drpMjob3]").on('change', function () {
        $("[id*= hdnjid]").val($("[id*= drpMjob3]").val());
        chkStatus();
    });

    $("[id*= drpstaff3]").on('change', function () {
        $("[id*= hdnsid]").val($("[id*= drpstaff3]").val());
        chkStatus();
    });

    $("[id*= UpdateTS]").on('click', function () {
        UpdateTimehseet();
    });

    $("[id*= chkMy]").on('click', function () {
        PieGraph();
        chkStatus();
    });

    $("[name= drpPageSize]").on('change', function () {
        $("#hdnCurrentPage").val("1");
        $("#hdnSize").val($(this).val());
        $("#chkAlltsid").prop("checked", false);
        if (this.id == "drpPageSize") {
            Bind_Timesheets();
        }
        else if (this.id == "drpPageSize_pending") {
            Pending_Timesheets();
        }
    });
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
            RejectTimesheet('StatusSubmitted');
        });

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
        var cBoxes = $("input[name=chkclt]:visible");
        if ($(this).is(':checked')) {
            cBoxes.prop("checked", true);
            AddRemoveSelectedIDsToEditedData(cBoxes.map(function () {
                return this.value;
            }), "add");
        }
        else {
            cBoxes.prop("checked", false);
            AddRemoveSelectedIDsToEditedData(cBoxes.map(function () {
                return this.value;
            }), "remove");
        }
    });

    $("[id*= chkApprovedAll]").on('click', function () {
        var chkprop = $(this).is(':checked');

        $("input[name=chkcltApp]").each(function () {

            if (chkprop) {
                $(this).attr('checked', 'checked');
            }
            else {
                $(this).removeAttr('checked'); //sftrow.css('display', 'none');
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

    $("[name=btnSrch]").on("click", function () {
        chkStatus();
    });

    $(".grids-wrapper").on("click", "input.selectedStatus", function () {
        SetEditedData(this.value.toString(), "IsSelected", $(this).is(":checked"));
    });

    $(".grids-wrapper").on("change", "input[name=txteditbillablehrs]", function () {
        SetEditedData($(this).closest("tr").data("id"), "EditedHours", this.value);
    });
});

///////////////////////////////////////////functionssssssss/////////////////////////////////////////////////////////////

function ApprovedStutApprButton(TypeStatus) {
    Blockloadershow();

    var editedData = GetEditedData();
    var editedRecords = [];
    var selectedIDs = editedData["SelectedIDs"] ?? [];
    for (var key in editedData) { if (key != "SelectedIDs" && selectedIDs.indexOf(key) >= 0) editedRecords.push(editedData[key]); }
    var request = {
        "EditedRecords": editedRecords,
        "SelectedIDs": selectedIDs,
        "Status": "Approved",
        "Compid": $("[id*=hdnCompanyid]").val(),
        "JobApprover": $("[id*=hdnEditStaffcode]").val(),
        "Staffstatus": $("[id*=hdnDualApp]").val(),
    };

    if ((editedRecords && editedRecords.length) || (selectedIDs && selectedIDs.length)) {
        //if (editedRecords && editedRecords.length) {
        //    $.each(editedRecords, function () {
        //        if (CompanyPermissions[0].Edit_Billing_Hrs == false || editedRecords["IsBillable"] == false) {
        //            this["EditedHours"] = "00.00";
        //        }
        //    });
        //}
        Update_Reject_Approve(request, TypeStatus);
    }
    else {
        showWarningAlert('Kindly select atleast one record !!!');
        Blockloaderhide();
        return false;
    }
}

function ApprovedStutRejButton(TypeStatus) {
    Blockloadershow();
    var editedData = GetEditedData();
    var editedRecords = [];
    var selectedIDs = editedData["SelectedIDs"] ?? [];
    for (var key in editedData) { if (key != "SelectedIDs" && selectedIDs.indexOf(key) >= 0) editedRecords.push(editedData[key]); }
    var request = {
        "EditedRecords": editedRecords,
        "SelectedIDs": selectedIDs,
        "Status": "Rejected",
        "Compid": $("[id*=hdnCompanyid]").val(),
        "JobApprover": $("[id*=hdnEditStaffcode]").val(),
        "Staffstatus": $("[id*=hdnDualApp]").val(),
    };

    if ((editedRecords && editedRecords.length) || (selectedIDs && selectedIDs.length)) {
        //if (editedRecords && editedRecords.length) {
        //    $.each(editedRecords, function () {
        //        if (CompanyPermissions[0].Edit_Billing_Hrs == false || editedRecords["IsBillable"] == false) {
        //            this["EditedHours"] = "00.00";
        //        }
        //    });
        //}
        Update_Reject_Approve(request, TypeStatus);
        var grid = $(".grids-wrapper table.table:visible");
        $.each(selectedIDs, function (i, id) {
            var row = $(grid.find("tr[data-id='" + id + "']"));

            var staffemail = row.find("#hdnstaffemail_" + id).val();
            var reason = row.find("#hdnResn_tsid_" + id).val();
            var custname = row.find("td:nth(3)").text();
            var tdate = row.find("td:nth(1)").text();

            var tempparams = {
                subject: "Timesheet rejected",
                to_name: custname,
                reply_to: staffemail,
                tdate: tdate,
                reason: reason
            };

            emailjs.send("service_nbqwp3f", "template_i13jifl", tempparams)
                .then(function (res) {
                    //console.log("success", res.status);
                    if (res.text != 'OK') {
                        showWarningAlert('Mail not sent');
                    }
                });
        });
    }
    else {
        showWarningAlert('Kindly select atleast one record !!!');
        Blockloaderhide();
        return false;
    }
}

function SubmiteApprButton(TypeStatus) {
    var editedData = GetEditedData();
    var editedRecords = [];
    var selectedIDs = editedData["SelectedIDs"] ?? [];
    for (var key in editedData) { if (key != "SelectedIDs" && selectedIDs.indexOf(key) >= 0) editedRecords.push(editedData[key]); }
    var request = {
        "EditedRecords": editedRecords,
        "SelectedIDs": selectedIDs,
        "Status": "Approved",
        "Compid": $("[id*=hdnCompanyid]").val(),
        "JobApprover": $("[id*=hdnEditStaffcode]").val(),
        "Staffstatus": $("[id*=hdnDualApp]").val(),
    };

    if ((editedRecords && editedRecords.length) || (selectedIDs && selectedIDs.length)) {
        //if (editedRecords && editedRecords.length) {
        //    $.each(editedRecords, function () {
        //        if (CompanyPermissions[0].Edit_Billing_Hrs == false || editedRecords["IsBillable"] == false) {
        //            this["EditedHours"] = "00.00";
        //        }
        //    });
        //}
        Update_Reject_Approve(request, TypeStatus);
    }
    else {
        showWarningAlert('Kindly select atleast one record !!!');
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
        //$("#" + txt, i.closest("tr")).val('00:00');
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
        //$("#" + txt, i.closest("tr")).val('00:00');
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

function Update_Reject_Approve(request, TypeStatus) {

    var data = {
        ts: request
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
                showSuccessAlert('Timesheet Update Successfully');
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
            ClearEditedData();
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
    //if (r == false) {
    //    return false;
    //}
    Blockloadershow();

    var editedData = GetEditedData();
    var editedRecords = [];
    var selectedIDs = editedData["SelectedIDs"] ?? [];
    for (var key in editedData) { if (key != "SelectedIDs" && selectedIDs.indexOf(key) >= 0) editedRecords.push(editedData[key]); }
    var request = {
        "EditedRecords": editedRecords,
        "SelectedIDs": selectedIDs,
        "Status": "Rejected",
        "Compid": $("[id*=hdnCompanyid]").val(),
        "JobApprover": $("[id*=hdnEditStaffcode]").val(),
        "Staffstatus": $("[id*=hdnDualApp]").val(),
    };

    if ((editedRecords && editedRecords.length) || (selectedIDs && selectedIDs.length)) {
        //if (editedRecords && editedRecords.length) {
        //    $.each(editedRecords, function () {
        //        if (CompanyPermissions[0].Edit_Billing_Hrs == false || editedRecords["IsBillable"] == false) {
        //            this["EditedHours"] = "00.00";
        //        }
        //    });
        //}

        Update_Reject_Approve(request, TypeStatus);

        $.each(selectedIDs, function (i, id) {
            var row = $("table#tbl_PendingTS tr[data-id='" + id + "']");

            var staffemail = row.find("#hdnstaffemail_" + id).val();
            var reason = row.find("#hdnResn_tsid_" + id).val();
            var custname = row.find("td:nth(3)").text();
            var tdate = row.find("td:nth(1)").text();

            var tempparams = {
                subject: "Timesheet rejected",
                to_name: custname,
                reply_to: staffemail,
                tdate: tdate,
                reason: reason
            };

            emailjs.send("service_nbqwp3f", "template_i13jifl", tempparams)
                .then(function (res) {
                    //console.log("success", res.status);
                    if (res.text != 'OK') {
                        showWarningAlert('Mail not sent');
                    }
                });
        });
        Blockloaderhide();
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
    SetEditedData(t, "Reason", r);
    showSuccessAlert('Reason Saved !!!');
    $('#modal_h3').modal('hide');
    $('#modalNarr2lvl').modal('hide');
}

function fillJobDrpdwn() {
    var cltid = $("[id*= drpclient3]").val();
    var distSBU = [];
    $.each(myProject, function (i, va) {
        if (va.jobid == cltid) {
            var indexxx = distSBU.map(function (d) { return d['id']; }).indexOf(va.mjobid);

            if (indexxx == -1)
                distSBU.push({ 'id': va.mjobid, 'Name': va.MJobName });
        }
    });

    $("[id*=drpMjob3]").empty();
    $("[id*=drpMjob3]").append("<option value=0>--Select--</option>");

    $.each(distSBU, function (i, va) {

        $("[id*=drpMjob3]").append('<option value="' + va.id + '">' + va.Name + '</option>');
    });
}

function fillPrjDrpdwn() {
    var cltid = $("[id*= drpclient3]").val();
    var distSBU = [];
    $.each(myProject, function (i, va) {
        if (va.Cid == cltid) {
            var indexxx = distSBU.map(function (d) { return d['id']; }).indexOf(va.Pid);

            if (indexxx == -1)
                distSBU.push({ 'id': va.Pid, 'Name': va.Project });
        }
    });

    $("[id*=drpProj]").empty();
    $("[id*=drpProj]").append("<option value=0>--Select--</option>");

    $.each(distSBU, function (i, va) {

        $("[id*=drpProj]").append('<option value="' + va.id + '">' + va.Name + '</option>');
    });
}

function PieGraph() {
    var compid = $("[id*=hdnCompanyid]").val();
    var frtime = $("[id*=txtdateBindStaff]").val().split('-')[0];
    var totime = $("[id*=txtdateBindStaff]").val().split('-')[1];
    var staffcode = $("[id*=hdnEditStaffcode]").val();
    var Pagelevel = $("[id*=hdnPageLevel]").val();
    var Staffrole = $("[id*=hdnRolename]").val();
    var SuperAppr = $("[id*=hdnSuperAppr]").val();
    var SubAppr = $("[id*=hdnSubAppr]").val();
    var ChckMyTS = $("[id*=chkMy]").is(':checked');
    $.ajax({
        type: "POST",
        url: "../Services/TimesheetViewer.asmx/PieGraphTSViewer",
        data: '{compid:' + compid + ',staffcode:' + staffcode + ',frtime:"' + frtime + '",totime:"' + totime + '",Pagelevel:' + Pagelevel + ',Staffrole:"' + Staffrole + '",SuperAppr:"' + SuperAppr + '",SubAppr:"' + SubAppr + '",ChckMyTS:"' + ChckMyTS + '"}',
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            var record = jQuery.parseJSON(msg.d);
            var myList = record[0].list_Pie;
            var myline = record[0].list_line;
            //if (myList[0].ttime > 0) {
            var pie_donut_element = document.getElementById('pie_donut');

            if (pie_donut_element) {

                // Initialize chart
                var pie_donut = echarts.init(pie_donut_element);


                //
                // Chart config
                //

                // Options
                pie_donut.setOption({

                    // Colors
                    color: [
                        'LimeGreen', 'orange', 'SkyBlue', 'IndianRed'
                        //'#8d98b3', '#e5cf0d', '#97b552', '#95706d', '#dc69aa',
                        //'#07a2a4', '#9a7fd1', '#588dd5', '#f5994e', '#c05050',
                        //'#59678c', '#c9ab00', '#7eb00a', '#6f5553', '#c14089'
                    ],

                    // Global text styles
                    textStyle: {
                        fontFamily: 'Roboto, Arial, Verdana, sans-serif',
                        fontSize: 13
                    },

                    // Add title
                    title: {
                        text: '',
                        //subtext: 'Open source information',
                        left: 'center',
                        textStyle: {
                            fontSize: 17,
                            fontWeight: 500
                        },
                        subtextStyle: {
                            fontSize: 12
                        }
                    },

                    // Add tooltip
                    tooltip: {
                        trigger: 'item',
                        backgroundColor: 'rgba(0,0,0,0.75)',
                        padding: [10, 15],
                        textStyle: {
                            fontSize: 13,
                            fontFamily: 'Roboto, sans-serif'
                        },
                        formatter: "{a} <br/>{b}: {c} ({d}%)"
                    },

                    // Add legend
                    legend: {
                        orient: 'vertical',
                        top: 'center',
                        left: 0,
                        data: [myList[1].status, myList[2].status, myList[3].status, myList[4].status],
                        itemHeight: 8,
                        itemWidth: 8
                    },

                    // Add series
                    series: [{
                        name: 'Status',
                        type: 'pie',
                        radius: ['50%', '70%'],
                        center: ['50%', '57.5%'],
                        itemStyle: {
                            normal: {
                                borderWidth: 1,
                                borderColor: '#fff'
                            }
                        },
                        data: [
                            { value: myList[1].ttime, name: myList[1].status },
                            { value: myList[2].ttime, name: myList[2].status },
                            { value: myList[3].ttime, name: myList[3].status },
                            { value: myList[4].ttime, name: myList[4].status }

                        ]
                    }]
                });
            }

            /////////////////////////////////////////////////////////////////////////////////////////////////
            //////Line Graph for Total Hours and Total Project
            var Line_TotalHours = document.getElementById('today-Hours');
            //d3.select('#today-Hours').empty();
            d3.select('svg').remove();
            var element = '#today-Hours';
            var height = 50;
            // Initialize chart only if element exsists in the DOM
            if ($(element).length > 0) {


                // Basic setup
                // ------------------------------

                // Add data set


                var dataset = [
                    {
                        'date': moment(myline[0].d1week).format("MM/DD/YY"),
                        'alpha': myline[1].d1week,
                        'Proj': myline[2].d1week,
                        'Exp': myline[3].d1week
                    }, {
                        'date': moment(myline[0].d2week).format("MM/DD/YY"),
                        'alpha': myline[1].d2week,
                        'Proj': myline[2].d2week,
                        'Exp': myline[3].d2week
                    }, {
                        'date': moment(myline[0].d3week).format("MM/DD/YY"),
                        'alpha': myline[1].d3week,
                        'Proj': myline[2].d3week,
                        'Exp': myline[3].d3week
                    }, {
                        'date': moment(myline[0].d4week).format("MM/DD/YY"),
                        'alpha': myline[1].d4week,
                        'Proj': myline[2].d4week,
                        'Exp': myline[3].d4week
                    }, {
                        'date': moment(myline[0].d5week).format("MM/DD/YY"),
                        'alpha': myline[1].d5week,
                        'Proj': myline[2].d5week,
                        'Exp': myline[3].d5week
                    }, {
                        'date': moment(myline[0].d6week).format("MM/DD/YY"),
                        'alpha': myline[1].d6week,
                        'Proj': myline[2].d6week,
                        'Exp': myline[3].d6week
                    }, {
                        'date': moment(myline[0].d7week).format("MM/DD/YY"),
                        'alpha': myline[1].d7week,
                        'Proj': myline[2].d7week,
                        'Exp': myline[3].d7week
                    }
                ];


                // Main variables
                var d3Container = d3.select(element),
                    margin = { top: 0, right: 0, bottom: 0, left: 0 },
                    width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right,
                    height = height - margin.top - margin.bottom,
                    padding = 20;

                // Format date
                var parseDate = d3.time.format('%m/%d/%y').parse,
                    formatDate = d3.time.format('%a, %B %e');

                // Colors
                var lineColor = '#fff',
                    guideColor = 'rgba(255,255,255,0.3)';



                // Add tooltip
                // ------------------------------

                var tooltip = d3.tip()
                    .attr('class', 'd3-tip')
                    .html(function (d) {
                        return '<ul class="list-unstyled mb-1">' +
                            '<li>' + '<div class="font-size-base my-1"><i class="icon-check2 mr-2"></i>' + formatDate(d.date) + '</div>' + '</li>' +
                            '<li>' + 'Total Hours: &nbsp;' + '<span class="font-weight-semibold float-right">' + d.alpha + '</span>' + '</li>' +
                            '<li>' + 'Projects/Jobs: &nbsp; ' + '<span class="font-weight-semibold float-right">' + d.Proj + '</span>' + '</li>' +
                            '<li>' + 'Total Expense: &nbsp; ' + '<span class="font-weight-semibold float-right">' + d.Exp + '</span>' + '</li>' +
                            '</ul>';
                    });



                // Create chart
                // ------------------------------

                // Add svg element
                var container = d3Container.append('svg');

                // Add SVG group
                var svg = container
                    .attr('width', width + margin.left + margin.right)
                    .attr('height', height + margin.top + margin.bottom)
                    .append('g')
                    .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')
                    .call(tooltip);



                // Load data
                // ------------------------------
                var TotalHrs = 0.00;
                var TotalProject = 0;

                dataset.forEach(function (d) {
                    d.date = parseDate(d.date);
                    d.alpha = d.alpha;
                    ////
                    TotalHrs = parseFloat(TotalHrs) + parseFloat(d.alpha);
                    TotalProject = parseInt(TotalProject) + parseInt(d.Proj);
                    ////
                });

                $("[id*=h3TH]").html(Math.round(TotalHrs));
                $("[id*=divtotprj]").html('Project/Job :' + TotalProject);
                // Construct scales
                // ------------------------------

                // Horizontal
                var x = d3.time.scale()
                    .range([padding, width - padding]);

                // Vertical
                var y = d3.scale.linear()
                    .range([height, 5]);



                // Set input domains
                // ------------------------------

                // Horizontal
                x.domain(d3.extent(dataset, function (d) {
                    return d.date;
                }));

                // Vertical
                y.domain([0, d3.max(dataset, function (d) {
                    return Math.max(d.alpha);
                })]);



                // Construct chart layout
                // ------------------------------

                // Line
                var line = d3.svg.line()
                    .x(function (d) {
                        return x(d.date);
                    })
                    .y(function (d) {
                        return y(d.alpha)
                    });



                //
                // Append chart elements
                //

                // Add mask for animation
                // ------------------------------

                // Add clip path
                var clip = svg.append('defs')
                    .append('clipPath')
                    .attr('id', 'clip-line-small');

                // Add clip shape
                var clipRect = clip.append('rect')
                    .attr('class', 'clip')
                    .attr('width', 0)
                    .attr('height', height);

                // Animate mask
                clipRect
                    .transition()
                    .duration(1000)
                    .ease('linear')
                    .attr('width', width);



                // Line
                // ------------------------------

                // Path
                var path = svg.append('path')
                    .attr({
                        'd': line(dataset),
                        'clip-path': 'url(#clip-line-small)',
                        'class': 'd3-line d3-line-medium'
                    })
                    .style('stroke', lineColor);

                // Animate path
                svg.select('.line-tickets')
                    .transition()
                    .duration(1000)
                    .ease('linear');



                // Add vertical guide lines
                // ------------------------------

                // Bind data
                var guide = svg.append('g')
                    .selectAll('.d3-line-guides-group')
                    .data(dataset);

                // Append lines
                guide
                    .enter()
                    .append('line')
                    .attr('class', 'd3-line-guides')
                    .attr('x1', function (d, i) {
                        return x(d.date);
                    })
                    .attr('y1', function (d, i) {
                        return height;
                    })
                    .attr('x2', function (d, i) {
                        return x(d.date);
                    })
                    .attr('y2', function (d, i) {
                        return height;
                    })
                    .style('stroke', guideColor)
                    .style('stroke-dasharray', '4,2')
                    .style('shape-rendering', 'crispEdges');

                // Animate guide lines
                guide
                    .transition()
                    .duration(1000)
                    .delay(function (d, i) { return i * 150; })
                    .attr('y2', function (d, i) {
                        return y(d.alpha);
                    });



                // Alpha app points
                // ------------------------------

                // Add points
                var points = svg.insert('g')
                    .selectAll('.d3-line-circle')
                    .data(dataset)
                    .enter()
                    .append('circle')
                    .attr('class', 'd3-line-circle d3-line-circle-medium')
                    .attr('cx', line.x())
                    .attr('cy', line.y())
                    .attr('r', 3)
                    .style('stroke', lineColor)
                    .style('fill', lineColor);



                // Animate points on page load
                points
                    .style('opacity', 0)
                    .transition()
                    .duration(250)
                    .ease('linear')
                    .delay(1000)
                    .style('opacity', 1);


                // Add user interaction
                points
                    .on('mouseover', function (d) {
                        tooltip.offset([-10, 0]).show(d);

                        // Animate circle radius
                        d3.select(this).transition().duration(250).attr('r', 4);
                    })

                    // Hide tooltip
                    .on('mouseout', function (d) {
                        tooltip.hide(d);

                        // Animate circle radius
                        d3.select(this).transition().duration(250).attr('r', 3);
                    });

                // Change tooltip direction of first point
                d3.select(points[0][0])
                    .on('mouseover', function (d) {
                        tooltip.offset([0, 10]).direction('e').show(d);

                        // Animate circle radius
                        d3.select(this).transition().duration(250).attr('r', 4);
                    })
                    .on('mouseout', function (d) {
                        tooltip.direction('n').hide(d);

                        // Animate circle radius
                        d3.select(this).transition().duration(250).attr('r', 3);
                    });

                // Change tooltip direction of last point
                d3.select(points[0][points.size() - 1])
                    .on('mouseover', function (d) {
                        tooltip.offset([0, -10]).direction('w').show(d);

                        // Animate circle radius
                        d3.select(this).transition().duration(250).attr('r', 4);
                    })
                    .on('mouseout', function (d) {
                        tooltip.direction('n').hide(d);

                        // Animate circle radius
                        d3.select(this).transition().duration(250).attr('r', 3);
                    })



                // Resize chart
                // ------------------------------

                // Call function on window resize
                window.addEventListener('resize', revenueResize);

                // Call function on sidebar width change
                var sidebarToggle = document.querySelector('.sidebar-control');
                sidebarToggle && sidebarToggle.addEventListener('click', revenueResize);

                // Resize function
                // 
                // Since D3 doesn't support SVG resize by default,
                // we need to manually specify parts of the graph that need to 
                // be updated on window resize
                function revenueResize() {

                    // Layout variables
                    width = d3Container.node().getBoundingClientRect().width - margin.left - margin.right;


                    // Layout
                    // -------------------------

                    // Main svg width
                    container.attr('width', width + margin.left + margin.right);

                    // Width of appended group
                    svg.attr('width', width + margin.left + margin.right);

                    // Horizontal range
                    x.range([padding, width - padding]);


                    // Chart elements
                    // -------------------------

                    // Mask
                    clipRect.attr('width', width);

                    // Line path
                    svg.selectAll('.d3-line').attr('d', line(dataset));

                    // Circles
                    svg.selectAll('.d3-line-circle').attr('cx', line.x());

                    // Guide lines
                    svg.selectAll('.d3-line-guides')
                        .attr('x1', function (d, i) {
                            return x(d.date);
                        })
                        .attr('x2', function (d, i) {
                            return x(d.date);
                        });
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

///Change Status Condition
function chkStatus(dontResetPageNumber) {
    status = $("#drpstatus").val();
    if (dontResetPageNumber == undefined) $("#hdnCurrentPage").val("1");
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
        $("[id*=divFromdate]").show();
        $("[id*=divTodate]").show();
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
        $("[id*=divprjdrp]").hide();
        $("[id*=divtskdrp]").hide();
        $("[id*=divFromdate]").hide();
        $("[id*=divTodate]").hide();
        $("[id*=divExcel]").hide();
        //TSNotSubData($("#hdnCurrentPage").val(), $("[id*=hdnSize]").val());
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
        $("[id*=divprjdrp]").hide();
        $("[id*=divtskdrp]").hide();

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
        $("[id*=divFromdate]").show();
        $("[id*=divTodate]").show();
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
    var Compid = $("[id*=hdnCompanyid]").val();
    var Start = $("[id*=txtdateBindStaff]").val().split('-')[0];
    var end = $("[id*=txtdateBindStaff]").val().split('-')[1];
    var Staffcode = $("[id*=hdnEditStaffcode]").val();
    var Staffrole = $("[id*=hdnRolename]").val();
    var sid = $("[id*=drpstaff3]").val();
    if (sid == null) {
        sid = 0;
    }
    var wk = $("[id*=hdnwk]").val();
    $.ajax({
        type: "POST",
        url: "../Services/TimesheetViewer.asmx/bind_Approver_TimesheetNotSubmitted",
        data: '{compid:' + Compid + ',Start:"' + Start + '",end:"' + end + '",staffcode:' + Staffcode + ',sid:' + sid + ',Staffrole:"' + Staffrole + '",wk:"' + wk + '"}',
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            var myList = jQuery.parseJSON(msg.d);
            var tbl = "";
            var ii = 1;
            $("[id*=tblTSNotSub] tbody").empty();
            $("[id*=tblTSNotSub] thead").empty();
            $("[id*=tblTSNotSub] tr").remove();


            if (myList == null) {
            } else {

                tbl = tbl + "<thead><tr>";
                tbl = tbl + "<th ></th>";
                tbl = tbl + "<th >" + myList[0].Staffname + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d1 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d2 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d3 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d4 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d5 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d6 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d7 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>Actual</th>";
                tbl = tbl + "<th style='font-weight: bold;'>Week</th>";
                tbl = tbl + "<th style='font-weight: bold;'>Send</th>";
                tbl = tbl + "</tr></thead>";

                $("[id*=tblTSNotSub]").append(tbl);
                tbl = '';
                tbl = tbl + "<thead><tr>";
                tbl = tbl + "<th style='font-weight: bold;'>Sr.No</th>";
                tbl = tbl + "<th style='font-weight: bold;'>Staff Name</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d1 + "<input type='hidden' id='hdnD1' value='" + myList[1].d1 + "' name='hdnD1'></th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d2 + "<input type='hidden' id='hdnD2' value='" + myList[1].d2 + "' name='hdnD2'></th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d3 + "<input type='hidden' id='hdnD3' value='" + myList[1].d3 + "' name='hdnD3'></th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d4 + "<input type='hidden' id='hdnD4' value='" + myList[1].d4 + "' name='hdnD4'></th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d5 + "<input type='hidden' id='hdnD5' value='" + myList[1].d5 + "' name='hdnD5'></th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d6 + "<input type='hidden' id='hdnD6' value='" + myList[1].d6 + "' name='hdnD6'></th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d7 + "<input type='hidden' id='hdnD7' value='" + myList[1].d7 + "' name='hdnD7'></th>";
                tbl = tbl + "<th style='font-weight: bold;'>Total</th>";
                tbl = tbl + "<th style='font-weight: bold;'>Total</th>";
                tbl = tbl + "<th style='font-weight: bold;'></th>";
                tbl = tbl + "</tr></thead>";
                $("[id*=tblTSNotSub]").append(tbl);

                tbl = '';

                if (myList.length > 2) {
                    for (var i = 2; i < myList.length; i++) {
                        tbl = tbl + "<tr>";
                        //if (myList[i].Staffname == 'Total') {
                        //    tbl = tbl + "<td ></td>";
                        //} else {
                        tbl = tbl + "<td >" + parseInt(ii) + "<input type='hidden' id='hdnTSNotstaffcode' value='" + myList[i].staffcode + "' name='hdnTSNotstaffcode'><input type='hidden' id='hdnstaffemail' value='" + myList[i].staffemail + "' name='hdnstaffemail'></td>";
                        //}
                        //  tbl = tbl + "<td >" + parseInt(ii) + "</td>";
                        tbl = tbl + "<td >" + myList[i].Staffname + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d1 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d2 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d3 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d4 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d5 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d6 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d7 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].Total + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].srno + "</td>";
                        tbl = tbl + "<td style='text-align: center;padding-left:0; padding-right:0;'><input id='btnWarning' name='btnWarning' type='button' value='Wrng' onclick='Send_Warning($(this))' class='btn btn-outline-warning rounded-round legitRipple'></td>";
                        tbl = tbl + "</tr>";
                        ii = parseInt(ii) + 1;
                    }
                    $("[id*=tblTSNotSub]").append(tbl);
                    Blockloaderhide();
                } else {
                    tbl = tbl + "<tr>";
                    tbl = tbl + "<td colspan='12'>No Record Found !!!</td>";
                    tbl = tbl + "</tr>";
                    $("[id*=tblTSNotSub]").append(tbl);
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
            //console.log("success", res.status);
            if (res.text == 'OK') {
                Blockloaderhide();
                showSuccessAlert('Warning send successfully!!!');
                row.find("input[name=btnWarning]").attr("disabled", true);
            } else {
                Blockloaderhide();
                showWarningAlert('Mail not send');
            }

        })
}

function MinimumHoours() {
    Blockloadershow();
    var Compid = $("[id*=hdnCompanyid]").val();
    var from = $("[id*=txtdateBindStaff]").val().split('-')[0];
    var To = $("[id*=txtdateBindStaff]").val().split('-')[1];
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
        data: '{compid:' + Compid + ',Start:"' + from + '",end:"' + To + '",staffcode:' + Staffcode + ',staff_role:"' + Staffrole + '",sid:' + sid + ',PageLevel:' + PageLevel + ',SuperAppr:"' + SuperAppr + '",SubAppr:"' + SubAppr + '"}',
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            var myList = jQuery.parseJSON(msg.d);
            var tbl = "";

            $("[id*=tblMinHrs] thead").empty();
            $("[id*=tblMinHrs] tbody").empty();


            tbl = tbl + "<thead><tr>";
            tbl = tbl + "<th style='font-weight: bold;'>Sr.No</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Staff Name</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Department Name</th>";
            tbl = tbl + "<th style='font-weight: bold;'class='labelChange'>Designation Name</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Date</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Minimum Hours</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Total Time</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Difference</th>";
            tbl = tbl + "</tr></thead>";

            if (myList == null) {

            }
            else {
                if (myList.length > 0) {
                    for (var i = 0; i < myList.length; i++) {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td >" + myList[i].srno + "</td>";
                        tbl = tbl + "<td >" + myList[i].Staffname + "</td>";
                        tbl = tbl + "<td >" + myList[i].Deptname + "</td>";
                        tbl = tbl + "<td >" + myList[i].DesignName + "</td>";
                        tbl = tbl + "<td >" + myList[i].Tdate + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].hors + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].totaltm + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].diff + "</td>";
                        tbl = tbl + "</tr>";
                    }
                    $("[id*=tblMinHrs]").append(tbl);
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
    var Compid = $("[id*=hdnCompanyid]").val();
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
    $.ajax({
        type: "POST",
        url: "../Services/TimesheetViewer.asmx/bind_StaffsummaryData",
        data: '{compid:' + Compid + ',Start:"' + Start + '",end:"' + end + '",staffcode:' + Staffcode + ',sid:' + sid + ',Staffrole:"' + Staffrole + '",PageLevel:' + PageLevel + ',SuperAppr:"' + SuperAppr + '",SubAppr:"' + SubAppr + '"}',
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            var myList = jQuery.parseJSON(msg.d);
            var tbl = "";
            var ii = 1;
            $("[id*=tblStaffSummary] tbody").empty();
            $("[id*=tblStaffSummary] thead").empty();
            $("[id*=tblStaffSummary] tr").remove();
            if (myList == null) {
            } else {

                tbl = tbl + "<thead><tr>";
                tbl = tbl + "<th ></th>";
                tbl = tbl + "<th >" + myList[0].Staffname + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d1 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d2 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d3 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d4 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d5 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d6 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].d7 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[0].Total + "</th>";
                tbl = tbl + "</tr></thead>";

                $("[id*=tblStaffSummary]").append(tbl);
                tbl = '';
                tbl = tbl + "<thead ><tr>";
                tbl = tbl + "<th style='font-weight: bold;'>Sr.No</th>";
                tbl = tbl + "<th style='font-weight: bold;'>Staff Name</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d1 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d2 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d3 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d4 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d5 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d6 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>" + myList[1].d7 + "</th>";
                tbl = tbl + "<th style='font-weight: bold;'>Total</th>";
                tbl = tbl + "</tr></thead>";
                $("[id*=tblStaffSummary]").append(tbl);

                tbl = '';

                if (myList.length > 3) {
                    for (var i = 2; i < myList.length; i++) {
                        tbl = tbl + "<tr>";
                        if (myList[i].Staffname == 'Total') {
                            tbl = tbl + "<td ></td>";
                        } else {
                            tbl = tbl + "<td >" + parseInt(ii) + "</td>";
                        }
                        //  tbl = tbl + "<td >" + parseInt(ii) + "</td>";
                        tbl = tbl + "<td >" + myList[i].Staffname + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d1 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d2 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d3 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d4 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d5 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d6 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].d7 + "</td>";
                        tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].Total + "</td>";
                        tbl = tbl + "</tr>";
                        ii = parseInt(ii) + 1;
                    }
                    $("[id*=tblStaffSummary]").append(tbl);
                    Blockloaderhide();
                } else {
                    tbl = tbl + "<tr>";
                    tbl = tbl + "<td colspan='10'>No Record Found !!!</td>";
                    tbl = tbl + "</tr>";
                    $("[id*=tblStaffSummary]").append(tbl);
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
    var compid = $("[id*=hdnCompanyid]").val();
    var muti = $("[id*=hdnPageLevel]").val();
    var cltid = $("[id*=drpclient3]").val();
    var projectid = $("[id*=drpProj]").val();
    var mjobid = $("[id*=drpMjob3]").val();
    var Sid = $("[id*=drpstaff3]").val();
    var frtime = $("[id*=txtdateBindStaff]").val().split('-')[0];
    var totime = $("[id*=txtdateBindStaff]").val().split('-')[1];
    var status = $("[id*=drpstatus]").val();
    //var status = "Semi Approved";
    var Staffcode = $("[id*=hdnEditStaffcode]").val();
    var Staffrole = $("[id*=hdnRolename]").val();
    var task = 0;
    if ($("[id*=hdnPageLevel]").val() == '4') {
        task = $("[id*=drpTask]").val();
    }

    $.ajax({
        type: "POST",
        url: "../Services/TimesheetViewer.asmx/getDualApproverTimesheets",
        data: '{compid:"' + compid + '",cltid:"' + cltid + '",projectid:"' + projectid + '",mjobid:"' + mjobid + '",staffcode:"' + Staffcode + '",frtime:"' + frtime + '",totime:"' + totime + '",status:"' + status + '",muti:' + muti + ',task:"' + task + '",Sid:' + Sid + ',Staffrole:"' + Staffrole + '"}',
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            var myList = jQuery.parseJSON(msg.d);

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
                tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Billable Edit Hrs</th>";
            }

            tbl = tbl + "<th style='font-weight: bold;'>Narration</th>";
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
                var editedData = GetEditedData();
                for (var i = 0; i < myList.length; i++) {
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
                        var editedRow = editedData[myList[i].TSId] ?? {};
                        var isSelected = (editedData["SelectedIDs"] ?? []).indexOf(myList[i].TSId.toString()) >= 0;
                        var billable = myList[i].Billable;
                        if ((editedRow["IsBillable"]) != undefined) {
                            billable = editedRow["IsBillable"];
                        }

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
                            if (billable == true) {
                                tbl = tbl + "<td style='width: 70px;'><input type='text' id='txteditbillablehrs' class='form-control' name='txteditbillablehrs' style='width: 70px;'    onblur='ShowBlur($(this))' value='" + myList[i].Edit_Billing_Hrs + "'> </td> ";
                            } else {
                                tbl = tbl + "<td style='width: 70px;'><input type='text' id='txteditbillablehrs' class='form-control' name='txteditbillablehrs' style='width: 70px;'    onblur='ShowBlur($(this))' value='" + myList[i].Edit_Billing_Hrs + "' disabled> </td> ";
                            }

                        }

                        if (myList[i].Narration == '') {
                            tbl = tbl + "<td style='text-align: center;'><i class='icon-bubble9 mr-1'></i></td>";
                        } else {
                            tbl = tbl + "<td style='text-align: center;cursor: pointer;'><i class='icon-bubble-lines4 mr-1 ' onclick='OpenNarration($(this))' data-toggle='modal' data-target='#modal_h3' ></i><input type='hidden' id='hdnNarr' value='" + myList[i].Narration + "' name='hdnNarr'></td>";
                            // tbl = tbl + "<td style='text-align: left;'>" + myList[i].Narration + "</td>";
                        }

                        //var bill = 'No';

                        if (billable == true) {
                            tbl = tbl + "<td style='text-align: center;cursor: pointer;'> <i class='icon-checkmark2 mr-3 icon-2x' style='color: green;' ></i></td>";
                            //bill = 'Yes';
                        } else {
                            tbl = tbl + "<td style='text-align: center;cursor: pointer;'> <i class='icon-cross3 mr-3 icon-2x' style='color: red;' ></i></td>";
                        }

                        if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                            if (myList[i].Status == 'Submitted') {
                                tbl = tbl + "<td style='text-align: left;background-color: orange;'>" + myList[i].Status + "</td>";

                            }
                            else if (myList[i].Status == 'Saved') {
                                tbl = tbl + "<td style='text-align: left;background-color: SkyBlue;'>" + myList[i].Status + "</td>";

                            }
                            else if (myList[i].Status == 'Approved') {
                                tbl = tbl + "<td style='text-align: left;background-color: LimeGreen;'>" + myList[i].Status + "</td>";

                            }
                            else if (myList[i].Status == 'Rejected') {
                                tbl = tbl + "<td style='text-align: left;background-color: IndianRed;'>" + myList[i].Status + "</td>";

                            }
                            else if (myList[i].Status == 'Semi Approved') {
                                tbl = tbl + "<td style='text-align: left;background-color: Yellow;'>" + myList[i].Status + "</td>";

                            }
                        }
                        else {
                            //tbl = tbl + "<td id='tdicon' name='tdicon' style='width: 217px;'><input type='button' id='btnSubmit' name='btnSubmit' class='btn btn-outline-success btn-sm' onclick='Single3Approived($(this))' value='Approved'><input type='button' id='btnRej' name='btnRej' class='btn btn-outline-danger ml-1 btn-sm' value='Reject'></td>";

                            tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + myList[i].Status + "' /><input type='hidden' id='hdnaP' name='hdnaP' value='" + myList[i].APattern + "' /><input type='checkbox' class='Chkbox' id='chkclt'  name='chkclt' value='" + myList[i].TSId + "' " + (isSelected ? "checked" : "") + " /></td>";
                            tbl = tbl + "<td style='text-align: center;'> <i class='icon-compose mr-2 ' data-toggle='modal' data-target='#modal_h3' onclick='OpenReason($(this))' style='cursor: pointer;'></i><input type='hidden' id='hdnResn_tsid_" + myList[i].TSId + "' name='hdnResn_tsid_" + myList[i].TSId + "' value='' ></td>";
                        }

                        tbl = tbl + "</tr>";
                    }

                };
                $("[id*=tbl_PendingTS]").append(tbl);

                Blockloaderhide();
            } else {
                var colspan = 10;
                tbl = tbl + "<tr>";
                if ($("[id*=hdnPageLevel]").val() > 3) {
                    colspan++;
                }
                if ($("[id*=hdnExpense]").val() == 'True') {
                    colspan++
                }
                tbl = tbl + "<td colspan='" + colspan + "'>No Record Found !!!</td>";

                tbl = tbl + "</tr>";
                $("[id*=tbl_PendingTS]").append(tbl);
                Blockloaderhide();

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

///3/4 Approver grid
function Pending_Timesheets() {
    Blockloadershow();
    var compid = $("[id*=hdnCompanyid]").val();
    var muti = $("[id*=hdnPageLevel]").val();
    var cltid = $("[id*=drpclient3]").val();
    var projectid = $("[id*=drpProj]").val();
    var mjobid = $("[id*=drpMjob3]").val();
    var Sid = $("[id*=drpstaff3]").val();
    //var frtime = $("[id*=txtdateBindStaff]").val().split('-')[0];
    //var totime = $("[id*=txtdateBindStaff]").val().split('-')[1];
    var frtime = $("[id*=txtfrom]").val();
    var totime = $("[id*=txtto]").val();
    var status = $("[id*=drpstatus]").val();
    var Staffcode = $("[id*=hdnEditStaffcode]").val();
    var Staffrole = $("[id*=hdnRolename]").val();
    var ChckMyTS = $("[id*=chkMy]").is(':checked');
    var srchTxt = $("input[name=txtsrch]:visible").val();
    var currentPage = $("#hdnCurrentPage").val();
    var pageSize = $("[name=drpPageSize]:visible").val();

    var task = 0;
    if ($("[id*=hdnPageLevel]").val() == '4') {
        task = $("[id*=drpTask]").val();
    }

    $.ajax({
        type: "POST",
        url: "../Services/TimesheetViewer.asmx/bind_timesheets",
        data: '{compid:"' + compid + '",cltid:"' + cltid + '",projectid:"' + projectid + '",mjobid:"' + mjobid +
            '",staffcode:"' + Staffcode + '",frtime:"' + frtime + '",totime:"' + totime + '",status:"' + status +
            '",muti:' + muti + ',task:"' + task + '",Sid:' + Sid + ',Staffrole:"' + Staffrole +
            '",ChckMyTS:"' + ChckMyTS + '",search:"' + srchTxt + '",pageIndex:' + currentPage + ',pageSize:' + pageSize + '}',
        dataType: 'text',
        contentType: "application/json",
        success: function (msg) {
            var data = $.parseJSON(msg);
            var myList = data.Data;
            //var xmlDoc = $.parseXML(msg.d);
            //var xml = $(xmlDoc);
            //var myList = xml.find("Table");

            var tbl = '';
            $("[id*=tbl_PendingTS] tbody").empty();
            $("[id*=tbl_PendingTS] thead").empty();

            tbl = tbl + "<thead><tr>";
            tbl = tbl + "<th style='font-weight: bold;'>Sr</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Date</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Submitted Date</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Staff</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Project</th>";
            tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Activity</th>";
            if ($("[id*=hdnPageLevel]").val() > 3) {

                tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Task</th>";
            }

            tbl = tbl + "<th style='font-weight: bold;'>Time</th>";
            if (CompanyPermissions[0].Edit_Billing_Hrs == true) {

                tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Billable Edit Hrs</th>";

            }

            tbl = tbl + "<th style='font-weight: bold;'>Narration</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Billable</th>";
            if ($("[id*=hdnExpense]").val() == 'True') {
                tbl = tbl + "<th style='font-weight: bold;'>Exp</th>";
            }
            tbl = tbl + "<th style='font-weight: bold;'>Status</th>";
            if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {

            } else {
                if ($("[id*=chkMy]").is(':checked') != true) {
                    tbl = tbl + "<th style='font-weight: bold;'>Reason</th>";
                }

            }

            tbl = tbl + "</tr></thead>";
            //  $("[id*=tbl_AllTimesheet]").append(tbl);
            if (myList.length > 1) {
                Pager(data.TotalCount);
                var editedData = GetEditedData();
                //var sc = myList.length;
                //for (var i = 0; i < myList.length; i++) {
                $.each(myList, function (i, obj) {
                    if (obj.mjobname == 'Total') {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td style='text-align: left;font-weight: bold;'>" + (obj.mjobname ?? "") + "</td>";
                        if ($("[id*=hdnPageLevel]").val() > 3) {
                            tbl = tbl + "<td></td>";
                        }
                        tbl = tbl + "<td style='text-align: left;font-weight: bold;'>" + (obj.totaltime ?? "") + "</td>";
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "<td></td>";
                        if ($("[id*=hdnExpense]").val() == 'True') {
                            tbl = tbl + "<td></td>";
                        }
                        tbl = tbl + "<td></td>";
                        tbl = tbl + "</tr>";
                    } else {
                        var billable = obj.billable;
                        var editedRow = editedData[obj.tsid] ?? {};
                        var isSelected = (editedData["SelectedIDs"] ?? []).indexOf(obj.tsid.toString()) >= 0;
                        if (editedRow["IsBillable"] != undefined) {
                            billable = editedData[obj.tsid]["IsBillable"];
                        }

                        tbl = tbl + "<tr data-id='" + obj.tsid + "'>";
                        tbl = tbl + "<td style='text-align: center;'>" + obj.srno +
                            "<input type='hidden' id='hdnATSid' value='" + obj.tsid + "' name='hdnATSid'>" +
                            "<input type='hidden' name='hdnstaffemail' id='hdnstaffemail_" + obj.tsid + "' value='" + (obj.staffemail ?? "") + "' name='hdnstaffemail'></td>";
                        tbl = tbl + "<td style='text-align: left;'>" + (obj.date ?? "") + "</td>";
                        tbl = tbl + "<td style='text-align: left;'>" + (obj.submitted_date ?? "") + "</td>";
                        tbl = tbl + "<td style='text-align: left;'>" + (obj.staffname ?? "") + "</td>";
                        tbl = tbl + "<td style='text-align: left;'>" + (obj.projectname ?? "") + "</td>";
                        tbl = tbl + "<td style='text-align: left;'>" + (obj.mjobname ?? "") + "</td>";
                        if ($("[id*=hdnPageLevel]").val() > 3) {
                            tbl = tbl + "<td style='text-align: left;'>" + (obj.taskname ?? "") + "</td>";
                        }


                        //
                        if (CompanyPermissions[0].Edit_Billing_Hrs == true) {
                            if (Staffcode > 0 && Staffrole != "Staff") {
                                if (billable == true) {

                                    if (obj.editedbilling_hrs == "0.00" || obj.editedbilling_hrs == "00.00") {
                                        tbl = tbl + "<td style='text-align: left;'>" + (obj.totaltime ?? "") + "</td>";
                                        tbl = tbl + "<td style='width: 70px;'><input type='text' id='txteditbillablehrs' name='txteditbillablehrs'  class='form-control'  style='width: 70px;'   onblur='ShowBlur($(this))' value='" + (obj.totaltime ?? "") + "')> </td> ";
                                    }
                                    else {
                                        ///Swaping of the column
                                        tbl = tbl + "<td style='text-align: left;'>" + (obj.editedbilling_hrs ?? "") + "</td>";
                                        tbl = tbl + "<td style='width: 70px;'><input type='text' id='txteditbillablehrs' name='txteditbillablehrs'  class='form-control'  style='width: 70px;'   onblur='ShowBlur($(this))' value='" + (obj.totaltime ?? "") + "')> </td> ";
                                    }

                                }
                                else {
                                    if (obj.editedbilling_hrs == "") {
                                        tbl = tbl + "<td style='text-align: left;'>" + (obj.totaltime ?? "") + "</td>";
                                        tbl = tbl + "<td style='width: 70px;'><input type='text' id='txteditbillablehrs' class='form-control' name='txteditbillablehrs' style='width: 70px;'    onblur='ShowBlur($(this))' value='00.00' disabled> </td> ";
                                    }
                                    else {
                                        tbl = tbl + "<td style='text-align: left;'>" + (obj.totaltime ?? "") + "</td>";
                                        tbl = tbl + "<td style='width: 70px;'><input type='text' id='txteditbillablehrs' class='form-control' name='txteditbillablehrs' style='width: 70px;'  onblur='ShowBlur($(this))' value='" + (obj.editedbilling_hrs ?? "") + "' disabled> </td> ";
                                    }
                                }
                            }
                            else {
                                tbl = tbl + "<td style='text-align: left;'>" + (obj.totaltime ?? "") + "</td>";
                                tbl = tbl + "<td style='width: 70px;'>" + (obj.editedbilling_hrs ?? "") + "</td> ";

                            }
                        }
                        else {
                            tbl = tbl + "<td style='text-align: left;'>" + (obj.totaltime ?? "") + "</td>";

                        }
                        if (obj.Narration) {
                            tbl = tbl + "<td style='text-align: center;cursor: pointer;'><i class='icon-bubble-lines4 mr-1 ' onclick='OpenNarration($(this))' data-toggle='modal' data-target='#modal_h3' ></i><input type='hidden' id='hdnNarr' value='" + obj.narration + "' name='hdnNarr'></td>";
                        } else {
                            tbl = tbl + "<td style='text-align: center;'><i class='icon-bubble9 mr-1 '></i></td>";
                        }

                        var editedBillable = editedRow["IsBillable"];
                        if (billable == true) {
                            tbl = tbl + "<td style='text-align: center;cursor: pointer;'> <i class='icon-checkmark2 mr-3 icon-2x" + (editedBillable ? " edited" : "") + "' style='color: green;' ></i></td>";
                        } else {
                            tbl = tbl + "<td style='text-align: center;cursor: pointer;'> <i class='icon-cross3 mr-3 icon-2x" + (editedBillable == false ? " edited" : "") + "' style='color: red;' ></i></td>";
                        }
                        if ($("[id*=hdnExpense]").val() == 'True') {
                            tbl = tbl + "<td style='text-align: left;'>" + (obj.opeamt ?? "") + "</td>";
                        }

                        if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                            tbl = tbl + "<td style='text-align: left;background-color: " + (statusColorLegend[obj.status] ?? "inherit") + ";'>" + obj.status + "</td>";
                        }
                        else {
                            if ($("[id*=chkMy]").is(':checked') != true) {
                                tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + obj.status + "' /><input type='checkbox' class='Chkbox selectedStatus' id='chkclt'  name='chkclt' value='" + obj.tsid + "' " + (isSelected ? "checked='checked'" : "") + " /></td>";
                                tbl = tbl + "<td style='text-align: center;'> <i class='icon-compose mr-2 ' data-toggle='modal' data-target='#modal_h3' onclick='OpenReason($(this))' style='cursor: pointer;'></i><input type='hidden' id='hdnResn_tsid_" + obj.tsid + "' name='hdnResn_tsid_" + obj.tsid + "' value='' ></td>";
                            } else {
                                if (obj.myts == 1) {
                                    tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + obj.status + "' /><input type='checkbox' class='Chkbox selectedStatus' id='chkclt'  name='chkclt' value='" + obj.tsid + "' " + (isSelected ? "checked='checked'" : "") + " /></td>";
                                } else {
                                    tbl = tbl + "<td style='text-align: left;background-color: " + (statusColorLegend[obj.status] ?? "inherit") + ";'>" + obj.status + "</td>";
                                }
                            }


                        }

                        tbl = tbl + "</tr>";
                    }
                });
                $("[id*=tbl_PendingTS]").append(tbl);

                Blockloaderhide();
            } else {
                Pager(0);

                var colspan = 10;
                tbl = tbl + "<tr>";
                if ($("[id*=hdnPageLevel]").val() > 3) {
                    colspan++;
                }

                if ($("[id*=hdnExpense]").val() == 'True') {
                    colspan++;
                }
                tbl = tbl + "<td colspan='" + colspan + "'>No Record Found !!!</td>";

                tbl = tbl + "</tr>";
                $("[id*=tbl_PendingTS]").append(tbl);
                Blockloaderhide();
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
        //$("#" + txt, i.closest("tr")).val('00:00');
    }
    var isValid = /^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/.test($("#txteditbillablehrs", i.closest("tr")).val());
    var isValid_WithDot = /^([0-1]?[0-9]|2[0-4])\.([0-5][0-9])(\.[0-5][0-9])?$/.test($("#txteditbillablehrs", i.closest("tr")).val());

    if (!isValid && !isValid_WithDot) {
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
    var compid = $("[id*=hdnCompanyid]").val();
    var cltid = $("[id*=drpclient3]").val();
    var mjobid = $("[id*=drpMjob3]").val();
    var Sid = $("[id*=drpstaff3]").val();
    //var frtime = $("[id*=txtdateBindStaff]").val().split('-')[0];
    //var totime = $("[id*=txtdateBindStaff]").val().split('-')[1];
    var frtime = $("[id*=txtfrom]").val();
    var totime = $("[id*=txtto]").val();
    var status = $("[id*=drpstatus]").val();
    var Staffcode = $("[id*=hdnEditStaffcode]").val();
    var SuperAppr = $("[id*=hdnSuperAppr]").val();
    var SubAppr = $("[id*=hdnSubAppr]").val();
    var ChckMyTS = $("[id*=chkMy]").is(':checked');
    $.ajax({
        type: "POST",
        url: "../Services/TimesheetViewer.asmx/Bind_TwoLTimesheet",
        data: '{compid:"' + compid + '",cltid:"' + cltid + '",mjobid:"' + mjobid + '",staffcode:"' + Staffcode + '",frtime:"' + frtime + '",totime:"' + totime + '",status:"' + status + '",Sid:' + Sid + ',SuperAppr:"' + SuperAppr + '",SubAppr:"' + SubAppr + '",ChckMyTS:"' + ChckMyTS + '"}',
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            var myList = jQuery.parseJSON(msg.d);


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
            tbl = tbl + "<th style='font-weight: bold;'>Exp</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Location</th>";

            tbl = tbl + "<th style='font-weight: bold;'>Narration</th>";

            tbl = tbl + "<th style='font-weight: bold;'>Bill</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Status</th>";


            tbl = tbl + "</tr></thead>";

            if (myList.length > 0) {

                var sc = myList.length;

                for (var i = 0; i < myList.length; i++) {
                    tbl = tbl + "<tr>";
                    tbl = tbl + "<td style='text-align: center;'>" + myList[i].Srno + "<input type='hidden' id='hdnATSid' value='" + myList[i].TSId + "' name='hdnATSid'></td>";
                    tbl = tbl + "<td style='text-align: left;'>" + myList[i].Dt + "</td>";
                    tbl = tbl + "<td style='text-align: left;'>" + myList[i].StaffName + "</td>";

                    tbl = tbl + "<td style='text-align: left;'>" + myList[i].ClientName + "</td>";

                    tbl = tbl + "<td style='text-align: left;'>" + myList[i].MJobName + "</td>";

                    tbl = tbl + "<td style='text-align: left;'>" + myList[i].FromDT + "</td>";
                    tbl = tbl + "<td style='text-align: left;'>" + myList[i].ToDT + "</td>";
                    tbl = tbl + "<td style='text-align: left;'>" + myList[i].TotalTime + "</td>";
                    if (myList[i].OpeAmt == 0) {
                        tbl = tbl + "<td style='text-align: left;'>0.00</td>";
                    } else {
                        tbl = tbl + "<td style='text-align: left;'>" + myList[i].OpeAmt + "</td>";
                    }

                    tbl = tbl + "<td style='text-align: left;'>" + myList[i].Location + "</td>";
                    if (myList[i].Narration == '') {
                        tbl = tbl + "<td style='text-align: center;'><i class='icon-bubble9 mr-1 '></i></td>";
                    } else {
                        tbl = tbl + "<td style='text-align: center;cursor: pointer;'><i class='icon-bubble-lines4 mr-1' onclick='Open2Narration($(this))' data-toggle='modal' data-target='#modalNarr2lvl' ></i><input type='hidden' id='hdnNarr' value='" + myList[i].Narration + "' name='hdnNarr'></td>";
                        // tbl = tbl + "<td style='text-align: left;'>" + myList[i].Narration + "</td>";
                    }


                    if (myList[i].Billable == true) {
                        tbl = tbl + "<td> <i class='icon-checkmark2 mr-3 icon-2x' style='color: green;'></i></td>";
                        //bill = 'Yes';
                    } else {
                        tbl = tbl + "<td> <i class='icon-cross3 mr-3 icon-2x' style='color: red;'></i></td>";
                    }

                    if (myList[i].Status == 'Submitted') {
                        tbl = tbl + "<td style='text-align: left;background-color: orange;'>" + myList[i].Status + "</td>";

                    }
                    else if (myList[i].Status == 'Saved') {
                        tbl = tbl + "<td style='text-align: left;background-color: SkyBlue;'>" + myList[i].Status + "</td>";

                    }
                    else if (myList[i].Status == 'Approved') {
                        tbl = tbl + "<td style='text-align: left;background-color: LimeGreen;'>" + myList[i].Status + "</td>";

                    }
                    else if (myList[i].Status == 'Rejected') {
                        tbl = tbl + "<td style='text-align: left;background-color: IndianRed;'>" + myList[i].Status + "</td>";

                    }

                    tbl = tbl + "</tr>";
                };
                $("[id*=tbl_AllTimesheet]").append(tbl);


                Blockloaderhide();
            } else {
                var colspan = 10;
                tbl = tbl + "<tr>";
                if ($("[id*=hdnPageLevel]").val() > 3) {
                    colspan++;
                }
                //if ($("[id*=hdnExpense]").val() == 'True') {
                //    colspan++;
                //}
                tbl = tbl + "<td colspan='" + colspan + "'>No Record Found !!!</td>";

                tbl = tbl + "</tr>";
                $("[id*=tbl_AllTimesheet]").append(tbl);
                Blockloaderhide();

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

function Pending_2Timesheets() {
    Blockloadershow();
    var compid = $("[id*=hdnCompanyid]").val();
    var cltid = $("[id*=drpclient3]").val();
    var mjobid = $("[id*=drpMjob3]").val();
    var Sid = $("[id*=drpstaff3]").val();
    //var frtime = $("[id*=txtdateBindStaff]").val().split('-')[0];
    //var totime = $("[id*=txtdateBindStaff]").val().split('-')[1];
    var frtime = $("[id*=txtfrom]").val();
    var totime = $("[id*=txtto]").val();
    var status = $("[id*=drpstatus]").val();
    var Staffcode = $("[id*=hdnEditStaffcode]").val();
    var SuperAppr = $("[id*=hdnSuperAppr]").val();
    var SubAppr = $("[id*=hdnSubAppr]").val();
    var ChckMyTS = $("[id*=chkMy]").is(':checked');
    $("[id*=hdnmyStatus]").val(ChckMyTS);
    $.ajax({
        type: "POST",
        url: "../Services/TimesheetViewer.asmx/Bind_TwoLTimesheet",
        data: '{compid:"' + compid + '",cltid:"' + cltid + '",mjobid:"' + mjobid + '",staffcode:"' + Staffcode + '",frtime:"' + frtime + '",totime:"' + totime + '",status:"' + status + '",Sid:' + Sid + ',SuperAppr:"' + SuperAppr + '",SubAppr:"' + SubAppr + '",ChckMyTS:"' + ChckMyTS + '"}',
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            var myList = jQuery.parseJSON(msg.d);

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

            tbl = tbl + "<th style='font-weight: bold;'>Narration</th>";

            tbl = tbl + "<th style='font-weight: bold;'>Bill</th>";
            tbl = tbl + "<th style='font-weight: bold;'>Status</th>";
            //if ($("[id*=hdnSuperAppr]").val() == 'True' || $("[id*=hdnSubAppr]").val() == 'True') {
            //    if ($("[id*=chkMy]").is(':checked') != true) {
            //        tbl = tbl + "<th style='font-weight: bold;'>Reason</th>";
            //    }

            //}

            if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {

            } else {
                if ($("[id*=chkMy]").is(':checked') != true) {
                    tbl = tbl + "<th style='font-weight: bold;'>Reason</th>";
                }
            }


            tbl = tbl + "</tr></thead>";

            if (myList.length > 0) {

                var sc = myList.length;

                for (var i = 0; i < myList.length; i++) {
                    var dataRow = myList[i];
                    var editedRow = editedData[dataRow.TSId] ?? {};
                    var isSelected = (editedData["SelectedIDs"] ?? []).indexOf(dataRow.TSId.toString()) >= 0;
                    var billable = dataRow.Billable;
                    if ((editedRow["IsBillable"]) != undefined) {
                        billable = editedRow["IsBillable"];
                    }

                    tbl = tbl + "<tr data-id='" + dataRow.TSId + "'>";
                    ///To check Edit Timesheet Permission
                    if ($("[id*=hdnSuperAppr]").val() == 'True' || $("[id*=hdnSubAppr]").val() == 'True') {
                        if (CompanyPermissions[0].Apredittmst == true) {
                            tbl = tbl + "<td style='text-align: center;'> <i class='icon-pencil mr-2 ' data-toggle='modal' data-target='#modalEditTS2lvl' onclick='OpenEditTS($(this))' style='cursor: pointer;'></i><input type='hidden' id='hdnATSid' value='" + dataRow.TSId + "' name='hdnATSid'></td>";
                        } else {
                            tbl = tbl + "<td style='text-align: center;'>" + dataRow.Srno + "<input type='hidden' id='hdnATSid' value='" + dataRow.TSId + "' name='hdnATSid'></td>";
                        }
                    } else {
                        tbl = tbl + "<td style='text-align: center;'>" + dataRow.Srno + "<input type='hidden' id='hdnATSid' value='" + dataRow.TSId + "' name='hdnATSid'></td>";
                    }


                    tbl = tbl + "<td style='text-align: left;'>" + dataRow.Dt + "</td>";
                    tbl = tbl + "<td style='text-align: left;'>" + dataRow.StaffName + "</td>";
                    if ($("[id*=hdnPageLevel]").val() == 2) {
                        tbl = tbl + "<td style='text-align: left;'>" + dataRow.ClientName + "</td>";
                    }
                    tbl = tbl + "<td style='text-align: left;'>" + dataRow.MJobName + "</td>";

                    tbl = tbl + "<td style='text-align: left;'>" + dataRow.FromDT + "</td>";
                    tbl = tbl + "<td style='text-align: left;'>" + dataRow.ToDT + "</td>";
                    tbl = tbl + "<td style='text-align: left;'>" + dataRow.TotalTime + "</td>";
                    if (dataRow.OpeAmt == 0) {
                        tbl = tbl + "<td style='text-align: left;'>0.00</td>";
                    } else {
                        tbl = tbl + "<td style='text-align: left;'>" + dataRow.OpeAmt + "</td>";
                    }

                    tbl = tbl + "<td style='text-align: left;'>" + dataRow.Location + "</td>";
                    if (dataRow.Narration == '') {
                        tbl = tbl + "<td style='text-align: center;'><i class='icon-bubble9 mr-1 '></i></td>";
                    } else {
                        tbl = tbl + "<td style='text-align: center;cursor: pointer;'><i class='icon-bubble-lines4 mr-1 ' onclick='Open2Narration($(this))' data-toggle='modal' data-target='#modalNarr2lvl' ></i><input type='hidden' id='hdnNarr' value='" + dataRow.Narration + "' name='hdnNarr'></td>";

                    }


                    if (billable == true) {
                        tbl = tbl + "<td> <i class='icon-checkmark2 mr-3 icon-2x' style='color: green;'></i></td>";

                    } else {
                        tbl = tbl + "<td> <i class='icon-cross3 mr-3 icon-2x' style='color: red;'></i></td>";
                    }

                    if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                        {

                            if (dataRow.Status == 'Submitted') {
                                tbl = tbl + "<td style='text-align: left;background-color: orange;'>" + dataRow.Status + "</td>";

                            }
                            else if (dataRow.Status == 'Saved') {
                                tbl = tbl + "<td style='text-align: left;background-color: SkyBlue;'>" + dataRow.Status + "</td>";

                            }
                            else if (dataRow.Status == 'Approved') {
                                tbl = tbl + "<td style='text-align: left;background-color: LimeGreen;'>" + dataRow.Status + "</td>";

                            }
                            else if (dataRow.Status == 'Rejected') {
                                tbl = tbl + "<td style='text-align: left;background-color: IndianRed;'>" + dataRow.Status + "</td>";

                            }
                        }
                    } else {
                        if ($("[id*=chkMy]").is(':checked') != true) {
                            tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + dataRow.Status + "' /><input type='checkbox' class='Chkbox' id='chkclt'  name='chkclt' value='" + dataRow.TSId + "' " + (isSelected ? "checked" : "") + " /></td>";
                            tbl = tbl + "<td style='text-align: center;'> <i class='icon-compose mr-2 ' data-toggle='modal' data-target='#modalNarr2lvl' onclick='Open2Reason($(this))' style='cursor: pointer;'></i><input type='hidden' id='hdnResn_tsid_" + dataRow.TSId + "' name='hdnResn_tsid_" + dataRow.TSId + "' value='' ></td>";
                        } else {
                            if (dataRow.Status == 'Submitted') {
                                tbl = tbl + "<td style='text-align: left;background-color: orange;'>" + dataRow.Status + "</td>";

                            }
                            else if (dataRow.Status == 'Saved') {
                                tbl = tbl + "<td style='text-align: left;background-color: SkyBlue;'>" + dataRow.Status + "</td>";

                            }
                            else if (dataRow.Status == 'Approved') {
                                tbl = tbl + "<td style='text-align: left;background-color: LimeGreen;'>" + dataRow.Status + "</td>";

                            }
                            else if (dataRow.Status == 'Rejected') {
                                tbl = tbl + "<td style='text-align: left;background-color: IndianRed;'>" + dataRow.Status + "</td>";

                            }
                        }

                    }

                    //if ($("[id*=hdnSuperAppr]").val() == 'True' || $("[id*=hdnSubAppr]").val() == 'True') {
                    //    if ($("[id*=chkMy]").is(':checked') != true) {
                    //        tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + dataRow.Status + "' /><input type='checkbox' class='Chkbox' id='chkclt'  name='chkclt' value='" + dataRow.TSId + "' /></td>";
                    //        tbl = tbl + "<td style='text-align: center;'> <i class='icon-compose mr-2 ' data-toggle='modal' data-target='#modalNarr2lvl' onclick='Open2Reason($(this))' style='cursor: pointer;'></i><input type='hidden' id='hdnResn_tsid_" + dataRow.TSId + "' name='hdnResn_tsid_" + dataRow.TSId + "' value='' ></td>";
                    //    } else {
                    //        if (dataRow.Status == 'Submitted') {
                    //            tbl = tbl + "<td style='text-align: left;background-color: orange;'>" + dataRow.Status + "</td>";

                    //        }
                    //        else if (dataRow.Status == 'Saved') {
                    //            tbl = tbl + "<td style='text-align: left;background-color: SkyBlue;'>" + dataRow.Status + "</td>";

                    //        }
                    //        else if (dataRow.Status == 'Approved') {
                    //            tbl = tbl + "<td style='text-align: left;background-color: LimeGreen;'>" + dataRow.Status + "</td>";

                    //        }
                    //        else if (dataRow.Status == 'Rejected') {
                    //            tbl = tbl + "<td style='text-align: left;background-color: IndianRed;'>" + dataRow.Status + "</td>";

                    //        }
                    //    }

                    //} else {


                    //    if (dataRow.Status == 'Submitted') {
                    //        tbl = tbl + "<td style='text-align: left;background-color: orange;'>" + dataRow.Status + "</td>";

                    //    }
                    //    else if (dataRow.Status == 'Saved') {
                    //        tbl = tbl + "<td style='text-align: left;background-color: SkyBlue;'>" + dataRow.Status + "</td>";

                    //    }
                    //    else if (dataRow.Status == 'Approved') {
                    //        tbl = tbl + "<td style='text-align: left;background-color: LimeGreen;'>" + dataRow.Status + "</td>";

                    //    }
                    //    else if (dataRow.Status == 'Rejected') {
                    //        tbl = tbl + "<td style='text-align: left;background-color: IndianRed;'>" + dataRow.Status + "</td>";

                    //    }
                    //}

                    tbl = tbl + "</tr>";
                };
                $("[id*=tbl_PendingTS]").append(tbl);

                Blockloaderhide();
            } else {
                var colspan = 10;
                tbl = tbl + "<tr>";
                if ($("[id*=hdnPageLevel]").val() > 3) {
                    colspan++;
                }
                if ($("[id*=hdnExpense]").val() == 'True') {
                    tbl = tbl + "<td></td>";
                }
                tbl = tbl + "<td colspan='" + colspan + "'>No Record Found !!!</td>";
                tbl = tbl + "</tr>";
                $("[id*=tbl_PendingTS]").append(tbl);
                Blockloaderhide();

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


////Dual Approver Timesheet 3 level
function DualAppBind_Timesheets() {
    Blockloadershow();
    var compid = $("[id*=hdnCompanyid]").val();
    var muti = $("[id*=hdnPageLevel]").val();
    var cltid = $("[id*=drpclient3]").val();
    var projectid = $("[id*=drpProj]").val();
    var mjobid = $("[id*=drpMjob3]").val();
    var Sid = $("[id*=drpstaff3]").val();
    //var frtime = $("[id*=txtdateBindStaff]").val().split('-')[0];
    //var totime = $("[id*=txtdateBindStaff]").val().split('-')[1];
    var frtime = $("[id*=txtfrom]").val();
    var totime = $("[id*=txtto]").val();
    var status = $("[id*=drpstatus]").val();
    var Staffcode = $("[id*=hdnEditStaffcode]").val();
    var Staffrole = $("[id*=hdnRolename]").val();
    var task = 0;
    if ($("[id*=hdnPageLevel]").val() == '4') {
        task = $("[id*=drpTask]").val();
    }

    $.ajax({
        type: "POST",
        url: "../Services/TimesheetViewer.asmx/getDualApproverTimesheets",
        data: '{compid:"' + compid + '",cltid:"' + cltid + '",projectid:"' + projectid + '",mjobid:"' + mjobid + '",staffcode:"' + Staffcode + '",frtime:"' + frtime + '",totime:"' + totime + '",status:"' + status + '",Sid:' + Sid + ',Staffrole:"' + Staffrole + '"}',
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
    var compid = $("[id*=hdnCompanyid]").val();
    var muti = $("[id*=hdnPageLevel]").val();
    var cltid = $("[id*=drpclient3]").val();
    var projectid = $("[id*=drpProj]").val();
    var mjobid = $("[id*=drpMjob3]").val();
    var Sid = $("[id*=drpstaff3]").val();
    //var frtime = $("[id*=txtdateBindStaff]").val().split('-')[0];
    //var totime = $("[id*=txtdateBindStaff]").val().split('-')[1];
    var frtime = $("[id*=txtfrom]").val();
    var totime = $("[id*=txtto]").val();
    var status = $("[id*=drpstatus]").val();
    var Staffcode = $("[id*=hdnEditStaffcode]").val();
    var Staffrole = $("[id*=hdnRolename]").val();
    var ChckMyTS = $("[id*=chkMy]").is(':checked');
    var srchTxt = $("input[name=txtsrch]:visible").val();
    var currentPage = $("#hdnCurrentPage").val();
    var pageSize = $("[name=drpPageSize]:visible").val();
    var task = 0;
    if ($("[id*=hdnPageLevel]").val() == '4') {
        task = $("[id*=drpTask]").val();
    }

    $.ajax({
        type: "POST",
        url: "../Services/TimesheetViewer.asmx/bind_timesheets",
        data: JSON.stringify({
            "compid": compid, "cltid": cltid, "projectid": projectid, "mjobid": mjobid,
            "staffcode": Staffcode, "frtime": frtime, "totime": totime, "status": status,
            "muti": muti, "task": task, "Sid": Sid, "Staffrole": Staffrole,
            "ChckMyTS": ChckMyTS, "search": srchTxt, "pageIndex": currentPage, "pageSize": pageSize
        }),
        dataType: 'text',
        contentType: "application/json",
        success: OnSuccess,

        failure: function (response) {
            showDangerAlert('Cant Connect to Server' + response.d);
        },
        error: function (response) {
            showDangerAlert('Error Occoured ' + response.d);
        }

    });

}

function OnSuccess(responce) {
    //var myList = jQuery.parseJSON(responce.d);
    var currGrid = $(".grids-wrapper table.table:visible");
    var data = $.parseJSON(responce);
    var myList = data.Data;
    //var xml = $(xmlDoc);
    //var myList = xml.find("Table");
    var Staffcode = $("[id*=hdnEditStaffcode]").val();
    var Staffrole = $("[id*=hdnRolename]").val();

    var selectstatus = $("[id*=drpstatus]").val();
    var tbl = '';
    $(currGrid.find("tbody")).empty();
    $(currGrid.find("thead")).empty();

    tbl = tbl + "<thead><tr>";
    tbl = tbl + "<th style='font-weight: bold;'>Sr.No</th>";
    tbl = tbl + "<th style='font-weight: bold;'>Date</th>";
    tbl = tbl + "<th style='font-weight: bold;'>Submitted Date</th>";
    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Staff</th>";
    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Project</th>";
    tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Activity</th>";
    if ($("[id*=hdnPageLevel]").val() > 3) {

        tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Task</th>";
    }
    tbl = tbl + "<th style='font-weight: bold;'>Time</th>";
    if (CompanyPermissions[0].Edit_Billing_Hrs == true) {

        tbl = tbl + "<th style='font-weight: bold;' class='labelChange'>Billable Edit Hrs</th>";

    }
    tbl = tbl + "<th style='font-weight: bold;'>Narration</th>";

    tbl = tbl + "<th style='font-weight: bold;'>Billable</th>";
    if ($("[id*=hdnExpense]").val() == 'True') {
        tbl = tbl + "<th style='text-align:left;'>Exp</th>";
    }
    tbl = tbl + "<th style='font-weight: bold;'>Status</th>";

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
    //  $("[id*=tbl_AllTimesheet]").append(tbl);
    if (myList.length > 1) {
        Pager(data.TotalCount);
        //var sc = myList.length;
        var editedData = GetEditedData();
        //for (var i = 0; i < myList.length; i++) {
        $.each(myList, function (i, obj) {
            if (obj.mjobname == 'Total') {
                tbl = tbl + "<tr>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td style='text-align: left;font-weight: bold;'>" + (obj.mjobname ?? "") + "</td>";
                if ($("[id*=hdnPageLevel]").val() > 3) {
                    tbl = tbl + "<td></td>";
                }
                tbl = tbl + "<td style='text-align: left;font-weight: bold;'>" + (obj.totaltime ?? "") + "</td>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td></td>";
                if ($("[id*=hdnExpense]").val() == 'True') {
                    tbl = tbl + "<td></td>";
                }
                tbl = tbl + "<td></td>";
                tbl = tbl + "</tr>";
            } else {
                var billable = obj.billable;
                var editedRow = editedData[obj.tsid] ?? {};
                var isSelected = (editedData["SelectedIDs"] ?? []).indexOf(obj.tsid.toString()) >= 0;
                if (editedRow["IsBillable"] != undefined) {
                    billable = editedData[obj.tsid]["IsBillable"];
                }

                tbl = tbl + "<tr data-id='" + obj.tsid + "'>";
                tbl = tbl + "<td style='text-align: center;'>" + obj.srno + "<input type='hidden' id='hdnATSid' value='" + obj.tsid + "' name='hdnATSid'></td>";
                tbl = tbl + "<td style='text-align: left;'>" + (obj.date ?? "") + "</td>";
                tbl = tbl + "<td style='text-align: left;'>" + (obj.submitted_date ?? "") + "</td>";
                tbl = tbl + "<td style='text-align: left;'>" + (obj.staffname ?? "") + "</td>";

                tbl = tbl + "<td style='text-align: left;'>" + (obj.projectname ?? "") + "</td>";
                tbl = tbl + "<td style='text-align: left;'>" + (obj.mjobname ?? "") + "</td>";
                if ($("[id*=hdnPageLevel]").val() > 3) {
                    tbl = tbl + "<td style='text-align: left;'>" + (obj.taskname ?? "") + "</td>";
                }

                if (CompanyPermissions[0].Edit_Billing_Hrs == true) {

                    if (billable) {

                        if (CompanyPermissions[0].SwapEdit == false) {
                            tbl = tbl + "<td style='text-align: left;'>" + (obj.totaltime ?? "") + "</td>";
                            tbl = tbl + "<td style='width: 70px;'>" + (obj.editedbilling_hrs ?? "") + "</td> ";
                        }
                        else {
                            ///Swaping of the column
                            tbl = tbl + "<td style='text-align: left;'>" + (obj.editedbilling_hrs ?? "") + "</td>";
                            tbl = tbl + "<td style='width: 70px;'>" + (obj.totaltime ?? "") + " </td> ";
                        }

                    }
                    else {
                        tbl = tbl + "<td style='text-align: left;'>" + (obj.totaltime ?? "") + "</td>";
                        tbl = tbl + "<td style='width: 70px;'>" + (obj.editedbilling_hrs ?? "") + "</td> ";
                    }

                }
                else {
                    tbl = tbl + "<td style='text-align: left;'>" + (obj.totaltime ?? "") + "</td>";

                }


                if (obj.Narration) {
                    // tbl = tbl + "<td style='text-align: left;'>" + myList[i].Narration + "</td>";
                    tbl = tbl + "<td style='text-align: center;cursor: pointer;'><i class='icon-bubble-lines4 mr-1 ' onclick='OpenNarration($(this))' data-toggle='modal' data-target='#modal_h3' ></i><input type='hidden' id='hdnNarr' value='" + obj.narration + "' name='hdnNarr'></td>";
                } else {
                    tbl = tbl + "<td style='text-align: center;'><i class='icon-bubble9 mr-1 '></i></td>";
                }

                var editedBillable = editedRow["IsBillable"];

                if (billable) {
                    tbl = tbl + "<td style='text-align: center;cursor: pointer;'> <i class='icon-checkmark2 mr-3 icon-2x" + (editedBillable ? " edited" : "") + "' style='color: green;'></i></td>";
                    //bill = 'Yes';
                } else {
                    tbl = tbl + "<td style='text-align: center;cursor: pointer;'>  <i class='icon-cross3 mr-3 icon-2x" + (editedBillable == false ? " edited" : "") + "' style='color: red;'></i></td>";
                }
                if ($("[id*=hdnExpense]").val() == 'True') {
                    tbl = tbl + "<td style='text-align: left;'>" + (obj.opeamt ?? "") + "</td>";
                }

                tbl = tbl + "<td style='text-align: left;background-color: " + (statusColorLegend[obj.status] ?? "inherit") + ";'>" + obj.status + "</td>";

                if ($("[id*=hdnEditStaffcode]").val() == 0 || $("[id*=hdnRolename]").val() == 'Staff') {
                } else {
                    if (selectstatus == 'Approved') {
                        tbl = tbl + "<td style='text-align: center;'><input type='hidden' id='hdnStatus' name='hdnStatus' value='" + obj.status + "' /><input type='checkbox' class='Chkbox selectedStatus' id='chkcltApp'  name='chkcltApp' value='" + obj.tsid + "' " + (isSelected ? "checked='checked'" : "") + " /></td>";
                    }
                }

                tbl = tbl + "</tr>";
            }

        });
        currGrid.append(tbl);


        Blockloaderhide();
    } else {
        Pager(0);
        var colspan = 10;
        tbl = tbl + "<tr>";
        if ($("[id*=hdnPageLevel]").val() > 3) {
            colspan++;
        }
        //if ($("[id*=hdnExpense]").val() == 'True') {
        //    colspan++;
        //}
        tbl = tbl + "<td colspan='" + colspan + "'>No Record Found !!!</td>";
        tbl = tbl + "</tr>";
        currGrid.append(tbl);
        Blockloaderhide();

    }

}

///3/4 Level Reason
function OpenReason(i) {
    var row = i.closest("tr");
    $("[id*=h3Narrat]").html('Reason');
    var Tsid = $("#hdnATSid", row).val();
    var Resn = $("#hdnResn_tsid_" + Tsid).val();
    var editedReason = GetEditedData(Tsid, "Reason");
    if (editedReason) {
        Resn = editedReason;
    }
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

    $("[id*=lblnrrdt]").html(dt);
    $("[id*=lblnrrPJ]").html(proj + '/' + job);
    $("[id*=lblnrrSf]").html(staff);
    $("[id*=lblnrrTT]").html(totl);
    $("[id*=pNarr]").hide();
    $("[id*=txtResn]").show();
    $("[id*=Save3Reson]").show();
    $("[id*=txtResn]").val(Resn);

}

///2Level Reason
function Open2Reason(i) {
    var row = i.closest("tr");
    //var Narr = row.find("input[name=hdnNarr]").val();

    $("[id*=h2Narrat]").html('Reason');
    var Tsid = $("#hdnATSid", row).val();
    var Resn = $("#hdnResn_tsid_" + Tsid).val();

    var editedReason = GetEditedData(Tsid, "Reason");
    if (editedReason) {
        Resn = editedReason;
    }

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
    var Compid = $("[id*=hdnCompanyid]").val();
    var TSID = $("[id*=htsid]").val();
    var FrTim = $("[id*=txtfromtime]").val();
    var ToTim = $("[id*=txtTotime]").val();
    var Totime = $("[id*=txtTotaltime]").val();
    var Narr = $("[id*=txtEditNarr]").val();
    $.ajax({
        type: "POST",
        url: "../Services/TimesheetViewer.asmx/UpdateTimehseet",
        data: '{compid:' + Compid + ',TSID:' + TSID + ',FrTim:"' + FrTim + '",ToTim:"' + ToTim + '",Totalime:"' + Totime + '",Narr:"' + Narr + '"}',
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
    var Compid = $("[id*=hdnCompanyid]").val();
    var staffcode = $("[id*=hdnEditStaffcode]").val();
    var projectid = $("[id*=drpProj]").val();
    $.ajax({
        type: "POST",
        url: "../Services/TimesheetViewer.asmx/GetJobdropdown",
        data: '{compid:' + Compid + ',staffcode:' + staffcode + ',projectid:' + projectid + '}',
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            var myList = jQuery.parseJSON(msg.d);

            //3 level Job name
            $("[id*=drpMjob3]").empty();

            $("[id*=drpMjob3]").append("<option value=0>--Select--</option>");
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
    var Compid = $("[id*=hdnCompanyid]").val();
    var PageLevel = $("[id*=hdnPageLevel]").val();
    var staffcode = $("[id*=hdnEditStaffcode]").val();
    var staffrole = $("[id*=hdnRolename]").val();
    var SuperAppr = $("[id*=hdnSuperAppr]").val();
    var SubAppr = $("[id*=hdnSubAppr]").val();
    $.ajax({
        type: "POST",
        url: "../Services/TimesheetViewer.asmx/GetAlldropdown",
        data: '{compid:' + Compid + ',PageLevel:' + PageLevel + ',staffcode:' + staffcode + ',staffrole:"' + staffrole + '",SuperAppr:"' + SuperAppr + '",SubAppr:"' + SubAppr + '"}',
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            var myList = jQuery.parseJSON(msg.d);
            var clintdrp = myList[0].list_ClientMaster;

            var staffdrp = myList[0].list_staffMaster;
            var Taskdrp = myList[0].list_taskMaster;
            var Jobname = myList[0].list_MjobMaster;
            //3 level Client
            $("[id*=drpclient3]").empty();

            $("[id*=drpclient3]").append("<option value=0>--Select--</option>");
            for (var i = 0; i < clintdrp.length; i++) {

                $("[id*=drpclient3]").append("<option value='" + clintdrp[i].CLTId + "'>" + clintdrp[i].ClientName + "</option>");
            }

            if ($("[id*=hdnPageLevel]").val() == '2') {
                if (CompanyPermissions[0].ProjectnClient == 1) {
                    $("[id*=divprjdrp]").hide();
                    $("[id*=drpMjob3]").empty();

                    $("[id*=drpMjob3]").append("<option value=0>--Select--</option>");
                    for (var i = 0; i < Jobname.length; i++) {

                        $("[id*=drpMjob3]").append("<option value='" + Jobname[i].mjobid + "'>" + Jobname[i].MJobName + "</option>");
                    }


                } else {
                    $("[id*=divprjdrp]").hide();
                    myProject = myList[0].list_MjobMaster;
                }

            } else {
                myProject = myList[0].list_ProjectMaster;
            }

            //3 level staff
            $("[id*=drpstaff3]").empty();
            $("[id*=drpstaff3]").append("<option value=0>--Select--</option>");
            for (var i = 0; i < staffdrp.length; i++) {

                $("[id*=drpstaff3]").append("<option value='" + staffdrp[i].id + "'>" + staffdrp[i].PNAME + "</option>");
            }

            if ($("[id*=hdnPageLevel]").val() == '4') {
                $("[id*=divtskdrp]").show();

                $("[id*=drpTask]").empty();
                $("[id*=drpTask]").append("<option value=0>--Select--</option>");
                for (var i = 0; i < Taskdrp.length; i++) {

                    $("[id*=drpTask]").append("<option value='" + Taskdrp[i].Task_Id + "'>" + Taskdrp[i].Task_name + "</option>");
                }
            }
            chkStatus();
            //if ($("[id*=hdnPageLevel]").val() > 2) {
            //    if ($("[id*=hdnDualApp]").val() == 'True') {
            //        if ($("[id*=hdnEditStaffcode]").val() == 0) {
            //            Bind_Timesheets();
            //        } else {
            //            DualAppBind_Timesheets();
            //        }
            //    } else {
            //        Bind_Timesheets();
            //    }

            //} else {

            //    Bind_TwoLTimesheet();
            //}




        },
        failure: function (response) {
            showDangerAlert('Cant Connect to Server' + response.d);
        },
        error: function (response) {
            showDangerAlert('Error Occoured ' + response.d);
        }
    });
}

function Pager(RecordCount) {
    $(".Pager").ASPSnippets_Pager({
        ActiveCssClass: "current",
        PagerCssClass: "pager",
        PageIndex: parseInt($("#hdnCurrentPage").val()),
        PageSize: parseInt($("[name=drpPageSize]:visible").val()),
        RecordCount: parseInt(RecordCount)
    });

    ////pagging changed bind LeaveMater with new page index
    $(".Pager .page").off("click").on("click", function () {
        $("#hdnCurrentPage").val($(this).attr('page'));
        $("#chkAlltsid").prop(("checked"), false);
        chkStatus(true);
    });
}

function AddRemoveSelectedIDsToEditedData(tsids, action) {
    var currGrid = $("#drpstatus").val();
    var currData = GetEditedData();
    var selectedIDs = currData["SelectedIDs"] ?? [];
    if (action == "add") {
        $.each(tsids, function (i, tsId) {
            selectedIDs.push(tsId);
        });
    }
    else {
        $.each(tsids, function (i, tsId) {
            selectedIDs = selectedIDs.remove(tsId);
        });
    }
    currData["SelectedIDs"] = selectedIDs;
    var data = editedDataElem.data("editedData") ?? {};
    data[currGrid] = currData;
    editedDataElem.data("editedData", data);
}

function SetEditedData(tsId, key, val) {
    var currGrid = $("#drpstatus").val();
    var currData = GetEditedData();
    var row = currData[tsId] ?? {};
    if (key == "IsSelected") {
        var selectedIDs = currData["SelectedIDs"] ?? [];
        if (val) {
            selectedIDs.push(tsId);
        }
        else {
            selectedIDs = selectedIDs.remove(tsId);
        }
        currData["SelectedIDs"] = selectedIDs;
    }
    else {
        row["TsId"] = tsId;
        row[key] = val;
        currData[tsId] = row;
    }
    var data = editedDataElem.data("editedData") ?? {};
    data[currGrid] = currData;
    editedDataElem.data("editedData", data);
}

function GetEditedData(tsId, key) {
    var currGrid = $("#drpstatus").val();
    var data = editedDataElem.data("editedData") ?? {};
    data = data[currGrid] ?? {};

    if (tsId) {
        data = data[tsId] ?? {};
        if (key) {
            return data[key];
        }
        else {
            return data;
        }
    }
    else {
        return data;
    }
}

function ClearEditedData() {
    var currGrid = $("#drpstatus").val();
    var data = editedDataElem.data("editedData") ?? {};
    data[currGrid] = {};
    editedDataElem.data("editedData", data);
}