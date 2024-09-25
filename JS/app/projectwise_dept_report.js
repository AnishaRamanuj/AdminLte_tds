; var needstaff = true, needProject = false, checkboxListItems = [], selectedIds = [], checkboxListDepts = [], selectedDepts = [];
$(function () {
    $('.sidebar-main-toggle').click();
    $("[id*=txtFromdt]").val($("[id*=hdntxtfrom]").val());
    $("[id*=txtTodt]").val($("[id*=hdntxtto]").val());
    $("[id*=hCompanyname]").html($("[id*=hdnCompname]").val());
    $("[id*=hdnFromdate1]").val($("[id*=hdntxtfrom]").val());
    $("[id*=hdnTodate1]").val($("[id*=hdntxtto]").val());
    pageFiltersReset();
    BindPageLoadStaff();

    $("[id*=txtFromdt]").change(function () {
        pageFiltersReset();
    });

    $("[id*=txtTodt]").change(function () {
        pageFiltersReset();
    });

    $("[id*=txtFromdt]").change(function () {
        if ($(this).val() != '' && $(this).val() != undefined && $(this).val() != null) {
            $("[id*=hdnFromdate1]").val('');
            $("[id*=hdnFromdate1]").val($("[id*= txtFromdt]").val());
            LoadDepartments();
        }
    });

    $("[id*=txtTodt]").change(function () {
        if ($(this).val() != '' && $(this).val() != undefined && $(this).val() != null) {
            $("[id*=hdnTodate1]").val('');
            $("[id*=hdnTodate1]").val($("[id*= txtTodt]").val());
            LoadDepartments();
        }
    });

    $("[id*=btnReport]").click(function () {
        //GetAllSelected();
        if ($("[id*=hdnSelectedpjtCode]") == '') {
            showWarningAlert('Kindly Select atleast one project !!!');
            return;
        } else {
            $("[id*=dvInvoice]").hide();
            $("[id*=dvReport]").show();
            GetGrid();
        }
    });

    $("[id*=btnBack]").click(function () {
        $("[id*=dvInvoice]").show();
        $("[id*=dvReport]").hide();
        $("[id*=lblSelectedCount]").html('');
        $("[id*=lblSelSecCount]").html('');
        $("#chkallSelectPrimary").prop("checked", false);
        $("#chkallSelectSecondary").prop("checked", false);
        selectedIds = [];
        selectedDepts = [];
        selectedIds = [];
        BindPageLoadStaff();
        $("#tblDept").empty();
    });

    $("#tblProject").on("click", "input[name=chkSelectPrimary]", function () {
        LoadDepartments();
    });

    $("#chkallSelectPrimary").on('click', function () {
        var chkprop = $(this).is(':checked');
        $("input[name=chkSelectPrimary]").each(function () {
            if (chkprop) {
                $(this).prop('checked', true);
            }
            else {
                $(this).prop('checked', false);
            }
        });
        CountSelected(this);
        LoadDepartments();
    });

    $("#chkallSelectSecondary").on('click', function () {
        var chkprop = $(this).is(':checked');
        $("input[name=chkSelectDept]").each(function () {
            if (chkprop) {
                $(this).prop('checked', true);
            }
            else {
                $(this).prop('checked', false);
            }
        });
        CountSelectedDept(this);
    });
});

/////////////////////////////////////////////////////////////////////

function FilterList(checkboxListItems, txtBox) {
    function BuildCheckboxListTable(listItems) {
        var tblCheckBoxList = $("#tblProject");

        tblCheckBoxList.find("tr.checkboxListItem").remove();
        var tbl = "";
        $.each(listItems, function (i, obj) {
            tbl = tbl + `<tr class='checkboxListItem'>";
                                <td style='text-align:center;width:65px;'><input type='checkbox' class='Chkbox cb-item' onclick='CountSelected(this)'
                                id='chkSelectPrimary_` + obj.Key + `' name='chkSelectPrimary' value='` + obj.Key + `' `
                + (selectedIds.indexOf(obj.Key.toString()) >= 0 ? "checked" : "") + `/></td>
                                <td><label for='chkSelectPrimary_` + obj.Key + `' class='checkboxListItem'>` + obj.Value + `</label></td>
                            </tr>`;
        });
        tblCheckBoxList.append(tbl);
    }

    if (txtBox && txtBox.value.length < 2) {
        BuildCheckboxListTable(checkboxListItems);
        return;
    }
    var filtered = matchAndSort(txtBox.value, checkboxListItems);
    BuildCheckboxListTable(filtered);
}

function FilterDeptList(checkboxListDepts, txtBox) {
    function BuildCheckboxListTable(listItems) {
        var tblCheckBoxList = $("#tblDept");

        tblCheckBoxList.find("tr.checkboxListItem").remove();
        var tbl = "";
        $.each(listItems, function (i, obj) {
            tbl = tbl + `<tr class='checkboxListItem'>";
                                <td style='text-align:center;width:65px;'><input type='checkbox' class='Chkbox cb-item' onclick='CountSelectedDept(this)'
                                id='chkSelectDept_` + obj.Key + `' name='chkSelectDept' value='` + obj.Key + `' `
                + (selectedDepts.indexOf(obj.Key.toString()) >= 0 ? "checked" : "") + `/></td>
                                <td><label for='chkSelectDept_` + obj.Key + `' class='checkboxListItem'>` + obj.Value + `</label></td>
                            </tr>`;
        });
        tblCheckBoxList.append(tbl);
    }

    if (txtBox && txtBox.value.length < 2) {
        BuildCheckboxListTable(checkboxListDepts);
        return;
    }
    var filtered = matchAndSort(txtBox.value, checkboxListDepts);
    BuildCheckboxListTable(filtered);
}

function BindPageLoadStaff() {
    var Compid = $("[id*=hdnCompanyid]").val();
    $("#tblProject").empty();
    $.ajax({
        type: "POST",
        url: "../Services/Projectwise_Dept_Report.asmx/Bind_DrpProject",
        data: '{compid:' + Compid + '}',
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            checkboxListItems = jQuery.parseJSON(msg.d);
            var tbl = '';
            if ($.isEmptyObject(checkboxListItems)) {
                tbl = tbl + "<tr>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td>No Record Found...</td>";
                tbl = tbl + "</tr>";
                $("#tblProject").append(tbl);
            }
            else {
                tbl = tbl + "<tr><td colspan='2'><input type='search' id='txtFilter' class='form-control form-control-border' placeholder='Type to filter...' onkeyup='FilterList(checkboxListItems, this)' /></td></tr>";
                $("#tblProject").append(tbl);
                FilterList(checkboxListItems, document.getElementById("txtFilter"));
            }
            Blockloaderhide();
        }
    });
}

function CountSelected(chk) {
    if (chk.id == "chkallSelectPrimary") {
        var isChked = $(chk).is(":checked");
        if (isChked) {
            $.each($("#client-filter .cb-item:checked"), function () {
                if (selectedIds.indexOf(this.value) < 0) {
                    selectedIds.push(this.value);
                }
            });
        }
        else {
            $.each($("#client-filter .cb-item"), function () {
                var index = selectedIds.indexOf(this.value);
                if ($(this).is(":checked")) {
                    if (index < 0) {
                        selectedIds.push(this.value);
                    }
                }
                else {
                    if (index >= 0) {
                        selectedIds.splice(index, 1);
                    }
                }
            });
        }
    }
    else {
        if ($(chk).is(":checked")) {
            selectedIds.push(chk.value);
        }
        else {
            var index = selectedIds.indexOf(chk.value);
            if (index >= 0) {
                selectedIds.splice(index, 1);
            }
        }
    }
    var count = selectedIds.length;
    $("[id*=lblSelectedCount]").html(count);
}


function CountSelectedDept(chk) {
    if (chk.id == "chkallSelectSecondary") {
        var isChked = $(chk).is(":checked");
        if (isChked) {
            $.each($("#dept-filter .cb-item:checked"), function () {
                if (selectedDepts.indexOf(this.value) < 0) {
                    selectedDepts.push(this.value);
                }
            });
        }
        else {
            $.each($("#dept-filter .cb-item"), function () {
                var index = selectedDepts.indexOf(this.value);
                if ($(this).is(":checked")) {
                    if (index < 0) {
                        selectedDepts.push(this.value);
                    }
                }
                else {
                    if (index >= 0) {
                        selectedDepts.splice(index, 1);
                    }
                }
            });
        }
    }
    else {
        if ($(chk).is(":checked")) {
            selectedDepts.push(chk.value);
        }
        else {
            var index = selectedDepts.indexOf(chk.value);
            if (index >= 0) {
                selectedDepts.splice(index, 1);
            }
        }
    }
    var count = selectedDepts.length;
    $("#lblSelSecCount").html(count);
}

function pageFiltersReset() {
    needstaff = true, needproject = false;
    $("[id*=lblSelectedCount]").html('0');
    $("#tblProject tbody").empty();
    $("#tblProject thead").empty();
    $("[id*=chkstaff]").removeAttr('checked');
}

function LoadDepartments() {
    if (selectedIds.length == 0) {
        $("#tblDept").empty();
        var tbl = '';
        tbl = tbl + "<tr>";
        tbl = tbl + "<td></td>";
        tbl = tbl + "<td>No Record Found...</td>";
        tbl = tbl + "</tr>";
        $("#tblDept").append(tbl);
        return;
    }

    var compid = $("[id*=hdnCompanyid]").val();
    var frtime = $("[id*=txtFromdt]").val();
    var totime = $("[id*=txtTodt]").val();

    var req = {
        compid: compid,
        fromDate: frtime,
        toDate: totime,
        pjtids: selectedIds.join(",")
    };
    Blockloadershow();
    $.ajax({
        type: "POST",
        url: "../Services/Projectwise_Dept_Report.asmx/Bind_DrpDept",
        data: JSON.stringify(req),
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            $("#tblDept").empty();
            checkboxListDepts = jQuery.parseJSON(msg.d);
            var tbl = '';
            if ($.isEmptyObject(checkboxListDepts)) {
                tbl = tbl + "<tr>";
                tbl = tbl + "<td></td>";
                tbl = tbl + "<td>No Record Found...</td>";
                tbl = tbl + "</tr>";
                $("#tblDept").append(tbl);
            }
            else {
                tbl = tbl + "<tr><td colspan='2'><input type='search' id='txtFilterDept' class='form-control-border form-control' placeholder='Type to filter...' onkeyup='FilterDeptList(checkboxListDepts, this)' /></td></tr>";
                $("#tblDept").append(tbl);
                FilterDeptList(checkboxListDepts, document.getElementById("txtFilterDept"));
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

//////////////////////////////////////////////////////////////////////////////
function GetGrid() {
    Blockloadershow();
    var compid = $("[id*=hdnCompanyid]").val();
    var frtime = $("[id*=txtFromdt]").val();
    var totime = $("[id*=txtTodt]").val();
    var selectedDeptsStr = selectedDepts.join(",");
    var hdnSltEmp = '', chka = '';

    $("input[name=chkSelectPrimary]:checked").each(function () {
        chka = $(this).is(':checked');
        if (chka) {
            hdnSltEmp = $(this).val() + ',' + hdnSltEmp;
        }
    });
    $("[id*=hdnSelectedpjtCode]").val(hdnSltEmp);
    $("[id*=hdnSelectedDeptCode]").val(selectedDeptsStr);
    $.ajax({
        type: "POST",
        url: "../Services/Projectwise_Dept_Report.asmx/GetDepartemtReport",
        data: JSON.stringify({ compid: compid, frtime: frtime, totime: totime, pjtids: hdnSltEmp, deptIds: selectedDeptsStr }),
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            var myList = jQuery.parseJSON(msg.d);
            var tbl = '';
            $("[id*=divdtrange]").html('From ' + moment(frtime).format('DD/MM/YYYY') + ' ' + 'To ' + moment(totime).format('DD/MM/YYYY'));
            $("[id*=tblReport] tbody").empty();
            $("[id*=tblReport] thead").empty();
            tbl = tbl + "<thead><tr>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Studio Name</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Date</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Day</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Client Name</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Project Name</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Scope of Work</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Resource Name</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Task Group</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Task Description</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Reason</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Actual Effort Hours</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Billable Hours</th>";
            tbl = tbl + "<th class='labelChange' style='font-weight: bold;'>Non Billable Hours</th>";
            tbl = tbl + "</tr></thead>";
            var sampleProject = '';
            if (myList.length > 1) {
                tbl += "<tbody>";
                for (var i = 0; i < myList.length; i++) {
                    tbl = tbl + "<tr>";
                    var isTotalRow = (myList[i].Reason == 'Total' || myList[i].Reason == 'Grand Total') &&
                        myList[i].DeptName == '' && myList[i].Date == '' && myList[i].DayName == '';
                    if (!isTotalRow) {
                        tbl += "<td style='text-align: left;'>" + myList[i].DeptName + "</td>";
                        tbl += "<td style='text-align: Center;'>" + myList[i].Date + "</td>";
                        tbl += "<td style='text-align: left;'>" + myList[i].DayName + "</td>";
                        tbl += "<td style='text-align: left;'>" + myList[i].ClientName + "</td>";
                        tbl += "<td style='text-align: left;'>" + myList[i].ProjectName + "</td>";
                        tbl += "<td style='text-align: left;'>" + myList[i].ScopeofWork + "</td>";
                        tbl += "<td style='text-align: left;'>" + myList[i].ResourceName + "</td>";
                        tbl += "<td style='text-align: left;'>" + myList[i].JobName + "</td>";
                        tbl += "<td style='text-align: left;'>" + myList[i].TaskDescription + "</td>";
                        tbl += "<td style='text-align: left;'>" + myList[i].Reason + "</td>";
                        tbl += "<td style='text-align: left;'>" + myList[i].ActualHours + "</td>";
                        tbl += "<td style='text-align: left;'>" + myList[i].BillingHours + "</td>";
                        tbl += "<td style='text-align: left;'>" + myList[i].NonBillingHours + "</td>";
                    }
                    else {
						tbl = tbl + "<td ></td>";
                        tbl += "<td style='text-align: right;font-weight: bold;' colspan='9'>" + myList[i].Reason + "</td>";
                        tbl += "<td style='text-align: left;font-weight: bold;'>" + myList[i].ActualHours + "</td>";
                        tbl += "<td style='text-align: left;font-weight: bold;'>" + myList[i].BillingHours + "</td>";
                        tbl += "<td style='text-align: left;font-weight: bold;'>" + myList[i].NonBillingHours + "</td>";
                    }

                    tbl = tbl + "</tr>";
                }
                tbl += "<tbody>";

                $("[id*=tblReport]").append(tbl);
                Blockloaderhide();
            } else {
                tbl = tbl + "<tr>";
                tbl = tbl + "<td ></td>";
                tbl = tbl + "<td ></td>";
                tbl = tbl + "<td ></td>";
                tbl = tbl + "<td ></td>";
                tbl = tbl + "<td ></td>";
                tbl = tbl + "<td ></td>";
                tbl = tbl + "<td >No Record Found !!!</td>";
                tbl = tbl + "<td ></td>";
                tbl = tbl + "<td ></td>";
                tbl = tbl + "</tr>";
                $("[id*=tblReport]").append(tbl);
                Blockloaderhide();
            }
            Blockloaderhide();
        },
        failure: function (response) {
            showDangerAlert('Cant Connect to Server' + response.d);
        },
        error: function (response) {
            showDangerAlert('Error Occoured ' + response.d);
        }
    });
}

