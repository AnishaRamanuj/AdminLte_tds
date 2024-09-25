/// <reference path="../JsTree/jquery.min.js" />
/// <reference path="moment.js" />
/// <reference path="../JsTree/jquery.timeentry.js" />
var toDaysDate = moment();
var currentWeek = [];
var Timesheet_inputs = [];
var locationstring = '<select style="width:100%; display:none;" class="DropDown rowlocation"><option value="0">Select Location</option></select>';
var CompanyPermissions = [];
var main_obj = [];
var tabPresents = [
{ 'tabid': 'tabone', 'tablabelid': 'taboneLabel', 'tabpresentdate': '' }
, { 'tabid': 'tabtwo', 'tablabelid': 'tabtwoLabel', 'tabpresentdate': '' }
, { 'tabid': 'tabthree', 'tablabelid': 'tabthreeLabel', 'tabpresentdate': '' }
, { 'tabid': 'tabfour', 'tablabelid': 'tabfourLabel', 'tabpresentdate': '' }
, { 'tabid': 'tabfive', 'tablabelid': 'tabfiveLabel', 'tabpresentdate': '' }
, { 'tabid': 'tabsix', 'tablabelid': 'tabsixLabel', 'tabpresentdate': '' }
, { 'tabid': 'tabseven', 'tablabelid': 'tabsevenLabel', 'tabpresentdate': '' }
, { 'tabid': 'tabAll', 'tablabelid': 'tabAllLabel', 'tabpresentdate': '' }
];
$(document).ready(function () {
    $('.modalganesh').css('display', 'block');
    /////////////page configuation settings
    CompanyPermissions = jQuery.parseJSON($("[id*=hdnCompanyPermission]").val());
    if (CompanyPermissions.length > 0) {
        if (CompanyPermissions[0].TimesheetInput_JobDetails_show == false) {
            $(".tbljobprojectdetails tr:eq(0)").hide();
            $(".tbljobprojectdetails tr:eq(1)").hide();
        }
        if (CompanyPermissions[0].TimesheetInput_Staff_BudgetedDetails_show == false) {
            $(".tbljobprojectdetails tr:eq(2)").hide();
            $(".tbljobprojectdetails tr:eq(3)").hide();
            $(".tbljobprojectdetails tr:eq(4)").hide();
        }
    }
    if ($("[id*=hdnTimesheetInputType]").val() == "taskwise") {
        ////////////front page task show
        $("#taskDropShowDown").css('display', '');
        ////////edit popup show task name row
        $("#edittaskname").closest("tr").css('display', '');
    }

    //////////location string
    try {
        if (CompanyPermissions[0].Location_mandatory) {
            locationstring = jQuery.parseJSON($("[id*=hdnlocations]").val());
            var optionSelect = '<option class="labelChange" value="0">Select Location</option>';
            $.each(locationstring, function (i, va) { optionSelect += '<option value="' + va.LocId + '">' + va.LocationName + '</option>'; });
            locationstring = '<select style="width:100%; display:none;" onchange="locationvalidationColorChange($(this))" class="DropDown rowlocation">' + optionSelect + '</select>';
            ////////edit popup show locaiton row
            $("#editlocaiton").append(optionSelect);
            $("#editlocaiton").closest("tr").css('display', '');

        }
    } catch (e) {
        console.log('Location getting error : ' + $("[id*=hdnlocations]").val());
        locationstring = '<select style="width:100%; display:none;" class="DropDown rowlocation"><option class="labelChange" value="0">Select Location</option></select>';
    }

    //////////expense drop down inside popup
    try {
        $('#ddlExpense').empty();
        $('#ddlExpense').append('<option class="labelChange" value="0">Select expense type</option>');
        if (CompanyPermissions[0].Expense_mandatory) {
            $.each(jQuery.parseJSON($("[id*=hdnExpense]").val()), function (i, va) {
                $('#ddlExpense').append('<option value="' + va.OpeId + '">' + va.OPEName + '</option>');
            });
        }

    } catch (e) {
        console.log('Expense log :' + e)
    }



    //////////Config end
    ////add evnets to buttons
    $("#btnFinalSubmitforApproval").attr('onclick', 'Submitforapproval()');

    ////////make popup time edit text box
    if (CompanyPermissions[0].Format_B == false) {
        $("#editfromtime").timeEntry({ show24Hours: true, spinnerImage: '' });
        $("#edittotime").timeEntry({ show24Hours: true, spinnerImage: '' });
    }
    else {
        $("#TxtedtTottime").timeEntry({ show24Hours: true, spinnerImage: '' });
    }
    ////////////get timesheet input related data /// <reference path="../Handler/" />
    if (main_obj.length == 0)
        ServerServiceToGetData('{compid:' + $("[id*=hdnCompanyID]").val() + ',staffcode:' + $("[id*=hdnStaffCode]").val() + ',inputType:"' + $("[id*=hdnTimesheetInputType]").val() + '"}', '../Handler/TimesheetInput.asmx/getTimesheetInpurtrelatedDetails', false, Onsuccess_client_projct_job_details);


    $("[id*=txtdate]").change(function () {
        if ($(this).val() != '' && $(this).val() != undefined && $(this).val() != null) {
            setDateChangeOnTextBoxChange();
        }
    });

    $("#ddlClient").change(function () { bindprojects(main_obj); });
    $("#ddlProject").change(function () { bindjob(main_obj); });
    $("#ddlJob").change(function () { $(".tbljobprojectdetails .txtbox").each(function () { $(this).val(''); }); if ($("[id*=hdnTimesheetInputType]").val() == "taskwise") { bindtask(main_obj); } bindJobdetails(); });
    $("#ddlTask").change(function () { });


    $("#btnSubmit").click(function () { saveTimesheets('Submitted'); });
    $("#btnSave").click(function () { saveTimesheets('Saved'); });

    ///////popup events
    if (CompanyPermissions[0].Format_B == false) {
        $("#editfromtime").blur(function () { getPopupTotalTime(); });
        $("#edittotime").blur(function () { getPopupTotalTime(); });
    }
    else {
        $("#TxtedtTottime").blur(function () { getPopupTotalTime(); });
    }
    //////expense popup event
    $("#txtexpenseamt").keyup(function (e) {
        var txtQty = $(this).val().replace(/[^0-9\.]/g, '');
        if (txtQty == '')
        { txtQty = '0'; }
        $(this).val(txtQty);
        return false;
    });
    setTimeout(function () { SafeChangeLabel('Oncepageload'); }, 1000);
});

////////////////////////////////success function page load..get first time job project details
function Onsuccess_client_projct_job_details(res) {
    main_obj = jQuery.parseJSON(res.d);
    main_obj = main_obj[0];
    if ($("[id*=hdnTimesheetInputType]").val() == "deptwise") {
        if (main_obj.list_job_master_ts == null || main_obj.list_job_master_ts.length == 0) {
            showError("Allocation Not Found !");
            $('.modalganesh').css('display', 'none');
            return false;
        }
        if (main_obj.list_Job_Assign == null || main_obj.list_Job_Assign.length == 0) {
            showError("Allocation Not Found !");
            $('.modalganesh').css('display', 'none');
            return false;
        }
        if (main_obj.list_Assign_Details == null || main_obj.list_Assign_Details.length == 0) {
            showError("Assignments Not Found !");
            $('.modalganesh').css('display', 'none');
            return false;
        }
    }
    else if ($("[id*=hdnTimesheetInputType]").val() == "") {
        if (main_obj.list_job_master_ts == null || main_obj.list_job_master_ts.length == 0) {
            showError("Allocation Not Found !");
            $('.modalganesh').css('display', 'none');
            return false;
        }
    }
    else if ($("[id*=hdnTimesheetInputType]").val() == "taskwise") {
        if (main_obj.list_job_master_ts == null || main_obj.list_job_master_ts.length == 0) {
            showError("Allocation Not Found !");
            $('.modalganesh').css('display', 'none');
            return false;
        }
        if (main_obj.list_job_task == null || main_obj.list_job_task.length == 0) {
            showError("Task Not Found !");
            $('.modalganesh').css('display', 'none');
            return false;
        }
    }

    setDateChangeOnTextBoxChange();
    $("#Timesheetmaintable").css("display", "block");
    $('.modalganesh').css('display', 'none');
}

function setDateChangeOnTextBoxChange() {
    currentWeek = enumerateDaysBetweenDates(moment($("[id*=txtdate]").val()).startOf('week'), moment($("[id*=txtdate]").val()).endOf('week'));
    insertNewDatesintoTabs();
    createTimesheetInputTable();
    $("[id*=txtdate]").val(moment($("[id*=txtdate]").val()).startOf('week').format('DD/MM/YYYY') + '-' + moment($("[id*=txtdate]").val()).endOf('week').format('DD/MM/YYYY'));
    /////client binding
    bindClients(main_obj);
    setTimeout(function () { getTimesheetsofSelectedWeek(); }, 1000);
}

var enumerateDaysBetweenDates = function (startDate, endDate) {
    var dates = [];
    dates.push(moment(startDate).format('MM/DD/YYYY'));
    var currDate = startDate.clone().startOf('day');
    var lastDate = endDate.clone().startOf('day');
    while (currDate.add(1, 'days').diff(lastDate) < 0) {
        dates.push(moment(currDate.clone().toDate()).format('MM/DD/YYYY'));
    }
    dates.push(moment(endDate).format('MM/DD/YYYY'));
    return dates;
};

function insertNewDatesintoTabs() {
    $.each(tabPresents, function (i, tab) {
        if (i < 7)
            tab.tabpresentdate = currentWeek[i];
    });
}

function createTimesheetInputTable() {
    if (currentWeek.length > 0) {

        $("#timesheetinputtable").empty();

        var timesheetinputheader = '<tr>';
        timesheetinputheader += '<th></th>';
        timesheetinputheader += '<th>Date</th>';
        timesheetinputheader += '<th>Day</th>';
        if (CompanyPermissions[0].Format_B == false) {
            timesheetinputheader += '<th>From<br>Time</th>';
            timesheetinputheader += '<th>To<br>Time</th>';
        }
        timesheetinputheader += '<th>Total<br>Time</th>';
        timesheetinputheader += '<th>Day<br>Total</th>';
        //////////condition wise columns
        if (CompanyPermissions[0].Location_mandatory) {
            timesheetinputheader += '<th class="labelChange">Location</th>';
        }
        if (CompanyPermissions[0].Expense_mandatory) {
            timesheetinputheader += '<th>Exp.<br>Entry</th>';
            timesheetinputheader += '<th>Exp.<br>Amt</th>';
        }
        timesheetinputheader += '<th>Narration</th>';
        timesheetinputheader += '</tr>';

        $("#timesheetinputtable").append(timesheetinputheader);

        $.each(currentWeek, function (i, va) {
            var trbody = '<tr>';
            var showcheckbox = '<input type="checkbox" onclick="onclickOfCheckbox($(this));" value="' + va + '" class="rowCheckbox"/><input type="hidden" class="rowtsExpense" /><input type="hidden" class="rowDate" value="' + va + '"/>';
            if (compareDates(moment(), moment(va)) == -1)
            { showcheckbox = ''; }

            /////freezed timesheets
            if (CompanyPermissions[0].IsFreezeYes) {
                if (Math.floor((moment() - moment(va)) / 86400000) <= CompanyPermissions[0].FreezeDays) {
                }
                else { showcheckbox = ''; }
            }
            trbody += '<td width="22px">' + showcheckbox + '</td>';
            trbody += '<td width="90px" style="padding-top:8px;">' + moment(va).format('DD MMM YYYY') + '</td>';
            trbody += '<td width="25px" style="padding-top:8px;">' + moment(va).format('ddd') + '</td>';
            if (CompanyPermissions[0].Format_B == false) {
                trbody += '<td width="50px"><input type="text" onblur="FormTimeCursortoTotime($(this))" class="txtbox rowFromTime" style="width:100%; display:none;"/></td>';
                trbody += '<td width="50px"><input type="text" onblur="Totimecalculation($(this))" class="txtbox rowToTime" style="width:100%; display:none;"/></td>';
                trbody += '<td width="22px" style="padding-top:8px; text-align:center;" class="rowTimeFormToTimeTotal">00:00</td>';

            }
            else {
                trbody += '<td width="50px"><input id="txttottime" name="txttottime" type="text" onblur="Totaltimecalculation($(this))" class="txtbox rowTotalTime" style="width:100%; display:none;"/></td>';
            }
            trbody += '<td width="22px" style="padding-top:8px; text-align:center;" class="rowDayTotal">00:00</td>';

            var narrwidth = 590;
            //////////location is mandatory
            if (CompanyPermissions[0].Location_mandatory) {
                trbody += '<td width="170px" style="text-align:center;">' + locationstring + '</td>';
                narrwidth = parseFloat(narrwidth - 180);
            }
            ////////if company uses expense
            if (CompanyPermissions[0].Expense_mandatory) {
                trbody += '<td width="25px" style="text-align:center;"><img class="rowexpense" onclick="ontsrowexpenseclick($(this))" style="margin:-4px;cursor:pointer;width:30px; display:none;" src="../images/ExpEntry.png"></td>';
                trbody += '<td width="50px" style="text-align:right;padding-top:8px;" class="rowamtexpense">0</td>';
                narrwidth = parseFloat(narrwidth - 90);
            }

            trbody += '<td width="' + (parseFloat(narrwidth) + 10) + 'px"><textarea class="txtbox rowNarration" rows="2" style="width:' + narrwidth + 'px;display:none; max-width:' + narrwidth + 'px; "></textarea></td>';
            trbody += '</tr>';
            $("#timesheetinputtable").append(trbody);
        });

        ////////add footer to timesheettable
        if (CompanyPermissions[0].Format_B == false) {
            var tfoot = '<tr>';
            tfoot += '<td colspan="5" style="border:none;background:#fff !important;"></td>';
            tfoot += '<td style="font-weight:bold;background: #fff !important;text-align:right;">Total</td>';
            tfoot += '<td id="tdweekFinalTotal" style="font-weight:bold;background: #fff !important;text-align:center;">00:00</td>';
            tfoot += '</tr>';
        }
        else {
            var tfoot = '<tr>';
            tfoot += '<td colspan="3" style="border:none;background:#fff !important;"></td>';
            tfoot += '<td style="font-weight:bold;background: #fff !important;text-align:right;">Total</td>';
            tfoot += '<td id="tdweekFinalTotal" style="font-weight:bold;background: #fff !important;text-align:center;">00:00</td>';
            tfoot += '</tr>';

        }
        $("#timesheetinputtable").append(tfoot);

        //        $(".rowDate").each(function (i, curr) {
        //            $('.displaydaterow', curr.closest("tr")).html(moment(currentWeek[i]).format('DD MMM YYYY'));
        //            $('.displaydateday', curr.closest("tr")).html(moment(currentWeek[i]).format('ddd'));
        //        });

        ////////////tabs change datewise
        $.each(tabPresents, function (i, tab) {
            if (i < 7) {
                $("[id*=" + tab.tablabelid + "]").html(moment(tab.tabpresentdate).format('DD MMM'));
            }
            else if (i == 7) {
                $("[id*=" + tab.tablabelid + "]").html(moment(tabPresents[0].tabpresentdate).format('DD MMM YYYY') + ' to ' + moment(tabPresents[6].tabpresentdate).format('DD MMM YYYY'));
            }
        });

        $(".rowFromTime,.rowToTime,.rowTotalTime").timeEntry({ show24Hours: true, spinnerImage: '' });
    }
    SafeChangeLabel('createTimesheetInputTable');
}

////////////////timesheet input table events
function onclickOfCheckbox(curr) {
    /////common changes
    ///from time, to time reset
    if (CompanyPermissions[0].Format_B == false) {
        $(".rowFromTime,.rowToTime", curr.closest("tr")).val("00:00");

        $(".rowTimeFormToTimeTotal", curr.closest("tr")).html("00:00");
        ////total time reset
        $(".rowTimeFormToTimeTotal", curr.closest("tr")).html("00:00");
        $(".rowTimeFormToTimeTotal", curr.closest("tr")).css('color', 'black');
    }
    else {
        $(".rowTotalTime", curr.closest("tr")).val("00:00");
    }
    ////location reset
    $(".rowlocation", curr.closest("tr")).val('0');
    $(".rowlocation", curr.closest("tr")).css('color', 'black');
    $(".rowlocation", curr.closest("tr")).css('border-color', 'rgb(169, 169, 169)');
    ////expense amt reset
    $(".rowamtexpense", curr.closest("tr")).html("0");
    $(".rowtsExpense", curr.closest("tr")).val("");
    /////narration text reset
    $(".rowNarration", curr.closest("tr")).val('');

    if (curr.is(':checked')) {
        if (CompanyPermissions[0].Format_B == false) {
            $(".rowFromTime,.rowToTime,.rowNarration,.rowexpense,.rowlocation", curr.closest("tr")).css('display', '');
        }
        else {
            $(".rowTotalTime,.rowNarration,.rowexpense,.rowlocation", curr.closest("tr")).css('display', '');
        }
    }
    else {
        if (CompanyPermissions[0].Format_B == false) {
            $(".rowFromTime,.rowToTime,.rowNarration,.rowexpense,.rowlocation", curr.closest("tr")).css('display', 'none');
        }
        else {
            $(".rowTotalTime,.rowNarration,.rowexpense,.rowlocation", curr.closest("tr")).css('display', 'none');
        }
    }
}

////////////timesheet input table text box from time to time
//////////form time
function FormTimeCursortoTotime(curr) {
    Totimecalculation(curr);
    //$(".rowToTime", curr.closest("tr")).focus();
}
function Totimecalculation(curr) {
    $(".rowTimeFormToTimeTotal", curr.closest("tr")).html('00:00');
    ///get from and to time
    var from = $(".rowFromTime", curr.closest("tr")).val();
    var to = $(".rowToTime", curr.closest("tr")).val();
    ///////check where empty or not
    if (from == "" || from == null || from == undefined || $(".rowFromTime", curr.closest("tr")).val().length != 5)
    { from = "00:00"; $(".rowFromTime", curr.closest("tr")).val(from); }
    if (to == "" || to == null || to == undefined || $(".rowToTime", curr.closest("tr")).val().length != 5)
    { to = "00:00"; $(".rowToTime", curr.closest("tr")).val(to); }
    //////check to time is greater than from time 
    /////so convert time format to float
    var fromno = from.split(':')[0] + '.' + from.split(':')[1];
    var tono = to.split(':')[0] + '.' + to.split(':')[1];

    if (parseFloat(fromno) > 0 && parseFloat(tono) > 0 && parseFloat(tono) > parseFloat(fromno)) {
        var resTime = compareTimes(from, to);
        $(".rowTimeFormToTimeTotal", curr.closest("tr")).html(resTime);
        $(".rowTimeFormToTimeTotal", curr.closest("tr")).css('color', 'black');
    }
    else { $(".rowTimeFormToTimeTotal", curr.closest("tr")).css('color', 'red'); }
}

function Totaltimecalculation(curr) {
    $(".rowDayTotal", curr.closest("tr")).html('00:00');
    //    ///get from and to time

    var Total = $(".rowTotalTime", curr.closest("tr")).val();
    //    var to = $(".rowToTime", curr.closest("tr")).val();
    ///////check where empty or not
    if (Total == "" || Total == null || Total == undefined || $(".rowTotalTime", curr.closest("tr")).val().length != 5)
    { Total = "00:00"; $(".rowTotalTime", curr.closest("tr")).val(from); }

    //////check to time is greater than from time 
    /////so convert time format to float
    var Totalno = Total.split(':')[0] + '.' + Total.split(':')[1];


    if (parseFloat(Totalno) > 0) {
        //        var resTime = compareTimes(from, to);
        $(".rowDayTotal", curr.closest("tr")).html(Totalno);
        $(".rowDayTotal", curr.closest("tr")).css('color', 'black');
    }
    else { $(".rowDayTotal", curr.closest("tr")).css('color', 'red'); }
}

//////////////expense click in timesheet input table
function ontsrowexpenseclick(curr) {
    resetExpensePopup();
    var ExpArry = [];
    if ($(".rowtsExpense", curr.closest("tr")).val() != '')
    { ExpArry = jQuery.parseJSON($(".rowtsExpense", curr.closest("tr")).val()); }
    makeExpenseTable(ExpArry);
    $("#btnExpensefindlSave").attr('onclick', 'saveExpensetothatDate("' + $(".rowCheckbox", curr.closest("tr")).val() + '")');
    $("#brnAddExpense").attr('onclick', 'addExpenseclick()');
    $("[id*=lblExpenseDae]").html('Expense entry for : ' + moment($(".rowCheckbox", curr.closest("tr")).val()).format('DD MMM YYYY'));
    $("#modalhidediv").css('display', '');
    $find("modalExpense").show();
}

function makeExpenseTable(curr) {
    $(".tblExpense tbody").empty();
    $.each(curr, function (i, va) {
        var row = '<tr>';
        row += '<td width="40%"><input type="hidden" value="' + va.ExpId + '"/>' + va.ExpName + '</td>';
        row += '<td width="15%" style="text-align:right;">' + va.Amt + '</td>';
        row += '<td width="40%">' + va.ExpNarration + '</td>';
        row += '<td style="text-align:center;"><img onclick="removeExpenseRow($(this))" style="margin:-4px;cursor:pointer;width:20px;" src="../images/Delete.png"></td>';
        row += '</tr>';
        $(".tblExpense tbody").append(row);
    });
    if (curr.length == 0) {
        $(".tblExpense tbody").append('<tr class="norecordstr"><th colspan="6" style="text-align:center;font-size:small;background:#fff;">No records found!</th></tr>');
    }
}


function addExpenseclick() {
    if ($("#ddlExpense").val() != 0 && $("#txtexpenseamt").val() != '' && $("#txtexpenseamt").val() != '0' && $("#txtexpenseamt").val() != undefined && $("#txtexpenseamt").val() != null) {
        $(".tblExpense .norecordstr").remove();
        var row = '<tr>';
        row += '<td  width="40%"><input type="hidden" value="' + $("#ddlExpense").val() + '"/>' + $("#ddlExpense :selected").text() + '</td>';
        row += '<td width="15%" style="text-align:right;">' + parseFloat($("#txtexpenseamt").val()) + '</td>';
        row += '<td   width="40%">' + $("#txtnarrexpense").val() + '</td>';
        row += '<td style="text-align:center;"><img onclick="removeExpenseRow($(this))" style="margin:-4px;cursor:pointer;width:20px;" src="../images/Delete.png"></td>';
        row += '</tr>';
        $(".tblExpense tbody").append(row);
        resetExpensePopup();
    }
    else { alert('Please select expense type and enter expense amount!'); }
}

function removeExpenseRow(curr) {
    curr.closest("tr").remove();
    if ($(".tblExpense tbody tr").length == 0)
    { $(".tblExpense tbody").append('<tr class="norecordstr"><th colspan="6" style="text-align:center;font-size:small;background:#fff;">No records found!</th></tr>'); }
}

function saveExpensetothatDate(dDdate) {
    try {
        $(".rowCheckbox").each(function () {
            if ($(this).val() == dDdate) {
                var jsonofexpens = [];
                $(".tblExpense tbody tr").each(function () {
                    var $currrow = $(this);
                    jsonofexpens.push({
                        'ExpId': $("input[type=hidden]", $(this).closest("tr")).val(),
                        'ExpName': $currrow.find(':eq(0)').text(),
                        'Amt': $currrow.find(':eq(2)').text(),
                        'ExpNarration': $currrow.find(':eq(3)').text()
                    });
                });
                var total = 0;
                $.each(jsonofexpens, function (i, va) { total += parseFloat(va.Amt); });
                jsonofexpens = JSON.stringify(jsonofexpens);
                $(".rowtsExpense", $(this).closest("tr")).val(jsonofexpens);
                $(".rowamtexpense", $(this).closest("tr")).html(total);
            }
        });
    } catch (e) {
        console.log('error in save expense');
    }
    $find("modalExpense").hide();
}

function resetExpensePopup() {
    $("#ddlExpense").val('0');
    $("#txtexpenseamt").val('0');
    $("#txtnarrexpense").val('');
}



///////////////function bind clients
function bindClients(crurrobj) {
    var distClients = [];
    //////////////empty clients
    resetDropdowns('Client');
    resetDropdowns('Project');
    resetDropdowns('Job');

    ////////task wise then 
    if ($("[id*=hdnTimesheetInputType]").val() == "taskwise")
        resetDropdowns('Task');
    ////////distincts client ids
    $.each(crurrobj.list_job_master_ts, function (i, va) {

        var jobstartdate = va.CreationDate;
        jobstartdate = eval("new " + jobstartdate.replace(/\//g, ""));
        jobstartdate = convertMMDDYYYYDate(jobstartdate);

        var jobenddate = va.ActualJobEndate;
        jobenddate = eval("new " + jobenddate.replace(/\//g, ""));
        jobenddate = convertMMDDYYYYDate(jobenddate);
        if (jobenddate == '01/01/1')
            jobenddate = currentWeek[6];
        //&& compareDates(jobenddate, currentWeek[6]) == 0
        // if (compareDates(jobstartdate, currentWeek[0]) == 0) 
        {
            var indexxx = distClients.map(function (d) { return d['id']; }).indexOf(va.CLTId);

            if (indexxx == -1)
                distClients.push({ 'id': va.CLTId, 'Name': va.ClientName });
        }
    });
    //////////////add clients to dropdown
    $.each(distClients, function (i, va) {
        $("#ddlClient").append('<option value="' + va.id + '">' + va.Name + '</option>');
    });
}

//////////////bind projects
function bindprojects(crurrobj) {
    var distProjects = [];
    resetDropdowns('Project');
    resetDropdowns('Job');
    ////////task wise then 
    if ($("[id*=hdnTimesheetInputType]").val() == "taskwise")
        resetDropdowns('Task');
    ////////distincts projcts ids
    $.each(crurrobj.list_job_master_ts, function (i, va) {
        if (va.CLTId == $("#ddlClient").val()) {
            var indexxx = distProjects.map(function (d) { return d['id']; }).indexOf(va.ProjectID);

            if (indexxx == -1)
                distProjects.push({ 'id': va.ProjectID, 'Name': va.ProjectName });
        }
    });
    //////////////add projects to dropdown
    $.each(distProjects, function (i, va) {
        $("#ddlProject").append('<option value="' + va.id + '">' + va.Name + '</option>');
    });
}

//////////////bind job
function bindjob(crurrobj) {
    var distjobids = [];
    resetDropdowns('Job');
    ////////task wise then 
    if ($("[id*=hdnTimesheetInputType]").val() == "taskwise")
        resetDropdowns('Task');
    ////////distincts job ids
    $.each(crurrobj.list_job_master_ts, function (i, va) {
        if (va.CLTId == $("#ddlClient").val() && va.ProjectID == $("#ddlProject").val()) {
            var indexxx = distjobids.map(function (d) { return d['id']; }).indexOf(va.JobId);

            if (indexxx == -1)
                distjobids.push({ 'id': va.JobId });
        }
    });
    var distMjobids = [];
    if ($("[id*=hdnTimesheetInputType]").val() == "deptwise") {
        //////get distinct assign ids and find distinct jobnames 
        ////////deparment wise job allocation
        $.each(crurrobj.list_Job_Assign, function (i, va) {
            var indexxx = distjobids.map(function (d) { return d['id']; }).indexOf(va.Jobid);
            if (indexxx != -1)
                $.each(crurrobj.list_Assign_Details, function (i, j) {
                    if (va.Assign_Id == j.Assign_Id) {

                        var indof = distMjobids.map(function (d) { return d['id']; }).indexOf(va.mJobid);

                        if (indof == -1)
                            distMjobids.push({ 'id': j.mJobid, 'Name': j.MJobName, 'jobid': va.Jobid });
                    }
                });
        });
    } else if ($("[id*=hdnTimesheetInputType]").val() == "" || $("[id*=hdnTimesheetInputType]").val() == "taskwise") {
        ////////if timesheet input type not define
        $.each(crurrobj.list_job_master_ts, function (i, va) {
            var indexxx = distjobids.map(function (d) { return d['id']; }).indexOf(va.JobId);
            if (indexxx != -1) {
                var indof = distMjobids.map(function (d) { return d['id']; }).indexOf(va.mJobID);

                if (indof == -1)
                    distMjobids.push({ 'id': va.mJobID, 'Name': va.MJobName, 'jobid': va.JobId });

            }
        });
    }
    //////////////add job to dropdown
    $.each(distMjobids, function (i, va) {
        $("#ddlJob").append('<option data-jobid="' + va.jobid + '" value="' + va.id + '">' + va.Name + '</option>');
    });
}

function bindtask(crurrobj) {
    resetDropdowns('Task');
    var disttaskids = [];
    $.each(crurrobj.list_job_task, function (i, va) {
        if (va.JobId == $("#ddlJob :selected").data('jobid')) {
            var indof = disttaskids.map(function (d) { return d['id']; }).indexOf(va.TaskId);

            if (indof == -1)
                disttaskids.push({ 'id': va.TaskId, 'Name': va.TaskName });
        }
    });
    //////////////add task to dropdown
    $.each(disttaskids, function (i, va) {
        $("#ddlTask").append('<option value="' + va.id + '">' + va.Name + '</option>');
    });
}

function bindJobdetails() {
    $.each(main_obj.list_job_master_ts, function (i, va) {
        if (va.JobId == $("#ddlJob :selected").data('jobid')) {
            ////Top Approver
            $(".tbljobprojectdetails .txtbox:eq(0)").val(va.SuperApprover);
            ////Sub Approver
            $(".tbljobprojectdetails .txtbox:eq(1)").val(va.Approvers);
            ///Start Date
            var dteNow = va.CreationDate;
            dteNow = eval("new " + dteNow.replace(/\//g, ""));
            dteNow = convertDate(dteNow);
            if (dteNow == '01/01/1')
                dteNow = '';
            $(".tbljobprojectdetails .txtbox:eq(2)").val(dteNow);
            ///End Date
            var dteNow2 = va.ActualJobEndate;
            dteNow2 = eval("new " + dteNow2.replace(/\//g, ""));
            dteNow2 = convertDate(dteNow2);
            if (dteNow2 == '01/01/1')
                dteNow2 = '';
            $(".tbljobprojectdetails .txtbox:eq(3)").val(dteNow2);
            /////Total Budgeted Hours
            $(".tbljobprojectdetails .txtbox:eq(4)").val(00);
            ////Spend Hours
            $(".tbljobprojectdetails .txtbox:eq(5)").val(00);
            ////Your Budgeted Hours
            $(".tbljobprojectdetails .txtbox:eq(6)").val(00);
            ////Actual Budgeted Hours
            $(".tbljobprojectdetails .txtbox:eq(7)").val(00);
            return false;
        }
    });


}

function convertDate(inputFormat) {
    function pad(s) { return (s < 10) ? '0' + s : s; }
    var d = new Date(inputFormat);
    return [pad(d.getDate()), pad(d.getMonth() + 1), d.getFullYear()].join('/');
}
function convertMMDDYYYYDate(inputFormat) {
    function pad(s) { return (s < 10) ? '0' + s : s; }
    var d = new Date(inputFormat);
    return [pad(d.getMonth() + 1), pad(d.getDate()), d.getFullYear()].join('/');
}

function saveTimesheets(status) {

    var msg = "";
    //////validate client
    if ($("#ddlClient").val() == null || $("#ddlClient").val() == undefined || $("#ddlClient").val() == "" || $("#ddlClient").val() == "0")
    { msg += ('\n Please select client !'); }
    //////validate project
    if ($("#ddlProject").val() == null || $("#ddlProject").val() == undefined || $("#ddlProject").val() == "" || $("#ddlProject").val() == "0")
    { msg += ('\n Please select project !'); }
    //////validate job
    if ($("#ddlJob").val() == null || $("#ddlJob").val() == undefined || $("#ddlJob").val() == "" || $("#ddlJob").val() == "0")
    { msg += ('\n Please select job !'); }
    if ($("[id*=hdnTimesheetInputType]").val() == "taskwise") {
        if ($("#ddlTask").val() == null || $("#ddlTask").val() == undefined || $("#ddlTask").val() == "" || $("#ddlTask").val() == "0")
        { msg += ('\n Please select task !'); }
    }
    ////////validate timesheet input table
    var countOfEntertimesheets = 0;
    var saveobj = [];
    $(".rowCheckbox").each(function () {
        if ($(this).is(':checked')) {
            //////for validation
            countOfEntertimesheets += 1;
            //////location validaiton
            var Addobj = true;
            if (CompanyPermissions[0].Location_mandatory) {
                if ($(".rowlocation", $(this).closest("tr")).val() == "0" || $(".rowlocation", $(this).closest("tr")).val() == undefined || $(".rowlocation", $(this).closest("tr")).val() == null || $(".rowlocation", $(this).closest("tr")).val() == "") {
                    $(".rowlocation", $(this).closest("tr")).css('color', 'red');
                    $(".rowlocation", $(this).closest("tr")).css('border-color', 'red');
                    Addobj = false;
                }
                else {
                    $(".rowlocation", $(this).closest("tr")).css('color', 'black');
                    $(".rowlocation", $(this).closest("tr")).css('border-color', 'rgb(169, 169, 169)');
                }
            }

            ////////for data save obj
            if (CompanyPermissions[0].Format_B == false) {
                if ($(".rowTimeFormToTimeTotal", $(this).closest("tr")).html().trim() != "00:00" && $(".rowTimeFormToTimeTotal", $(this).closest("tr")).html() != "" && $(".rowTimeFormToTimeTotal", $(this).closest("tr")).html().trim().length == 5) {
                    $(".rowTimeFormToTimeTotal", $(this).closest("tr")).css('color', 'black');
                    debugger
                    var valid = tsValidation($(this).val(), $(".rowFromTime", $(this).closest("tr")).val(), $(".rowToTime", $(this).closest("tr")).val(), 0);

                    if (valid != true)
                    { msg += '\n ' + valid; Addobj = false; }
                    var task = 0;

                    if ($("[id*=hdnTimesheetInputType]").val() == "taskwise")
                        task = $("#ddlTask").val();

                    var Expensts = [];
                    if ($(".rowtsExpense", $(this).closest("tr")).val() != '') {
                        Expensts = jQuery.parseJSON($(".rowtsExpense", $(this).closest("tr")).val());
                    }

                    ///////////add save details objects
                    if (Addobj)
                        saveobj.push({
                            StaffCode: $("[id*=hdnStaffCode]").val(),
                            JobId: $("#ddlJob :selected").data('jobid'),
                            CompId: $("[id*=hdnCompanyID]").val(),
                            CLTId: $("#ddlClient").val(),
                            FromTime: $(".rowFromTime", $(this).closest("tr")).val(),
                            ToTime: $(".rowToTime", $(this).closest("tr")).val(),
                            TotalTime: $(".rowTimeFormToTimeTotal", $(this).closest("tr")).html().trim(),
                            Date: $(this).val(),
                            Status: status + ',' + $(this).val(),
                            Narration: $(".rowNarration", $(this).closest("tr")).val(),
                            Project_Id: $("#ddlProject").val(),
                            mJob_Id: $("#ddlJob").val(),
                            Task_Id: task,
                            list_ExpenseTs: Expensts,
                            LocId: $(".rowlocation", $(this).closest("tr")).val()
                        });
                }
                else { $(".rowTimeFormToTimeTotal", $(this).closest("tr")).css('color', 'red'); }
            }
            else {

                var row = $(this).closest("tr");
                var t = row.find("input[name=txttottime]").val();

                if (t != "00:00" && t != "" && t.length == 5) {
                    $(".rowTotalTime", $(this).closest("tr")).css('color', 'black');

                    //                    var valid = tsValidation($(this).val(), $(".rowTotalTime", $(this).closest("tr")).val(), $(".rowToTime", $(this).closest("tr")).val(), 0);

                    //                    if (valid != true)
                    //                    { msg += '\n ' + valid; Addobj = false; }
                    Addobj = true;
                    var task = 0;

                    if ($("[id*=hdnTimesheetInputType]").val() == "taskwise")
                        task = $("#ddlTask").val();

                    var Expensts = [];
                    if ($(".rowtsExpense", $(this).closest("tr")).val() != '') {
                        Expensts = jQuery.parseJSON($(".rowtsExpense", $(this).closest("tr")).val());
                    }

                    ///////////add save details objects
                    if (Addobj)
                        saveobj.push({
                            StaffCode: $("[id*=hdnStaffCode]").val(),
                            JobId: $("#ddlJob :selected").data('jobid'),
                            CompId: $("[id*=hdnCompanyID]").val(),
                            CLTId: $("#ddlClient").val(),
                            FromTime: "00:00",
                            ToTime: $(".rowTotalTime", $(this).closest("tr")).val(),
                            TotalTime: $(".rowTotalTime", $(this).closest("tr")).val(),
                            Date: $(this).val(),
                            Status: status + ',' + $(this).val(),
                            Narration: $(".rowNarration", $(this).closest("tr")).val(),
                            Project_Id: $("#ddlProject").val(),
                            mJob_Id: $("#ddlJob").val(),
                            Task_Id: task,
                            list_ExpenseTs: Expensts,
                            LocId: $(".rowlocation", $(this).closest("tr")).val()
                        });
                }
                else { $(".rowTotalTime", $(this).closest("tr")).css('color', 'red'); }

            } ///// Total timesheet
        }
    });

    if (countOfEntertimesheets == 0) {
        msg += ('\n Please enter at least one timesheet !');
    }

    if (countOfEntertimesheets != 0 && countOfEntertimesheets != saveobj.length) {
        msg += ('\n Please check timesheet not enter properly !');
    }

    if (msg != "") {
        alert(msg);
        return false;
    }

    saveobj = JSON.stringify({ 'ts': saveobj });
    $('.modalganesh').css('display', 'block');
    ServerServiceToGetData(saveobj, '../Handler/TimesheetInput.asmx/savetimesheetinput', false, Onsuccess_saveTimesheets);
}

function Onsuccess_saveTimesheets(res) {
    var resultJsonofTs = jQuery.parseJSON(res.d);
    var ErrorCount = 0;
    if (resultJsonofTs.length > 0) {
        //////reset Timesheet input table after save
        $(".rowCheckbox:checked").each(function () {
            var dateOfrow = $(this).val();
            var statusOfsubmission = '';
            $.each(resultJsonofTs, function (i, va) {
                if (va.Status.split(',')[1] == dateOfrow) {
                    statusOfsubmission = va.StaffName;
                }
            });
            if (statusOfsubmission != 'error' && statusOfsubmission != "") {
                $(this).removeAttr('checked');
                onclickOfCheckbox($(this));
            } else { ErrorCount += 1; }
        });

        if (ErrorCount > 0)
        { showError('Timesheet saved successfully......Plase checked some timehseet are not saved'); }
        else { showSuccess('Timesheet saved successfully......'); }
        getTimesheetsofSelectedWeek();
    }
    else { showError("Getting error while saving.........."); }
    $('.modalganesh').css('display', 'none');
}

///////////get Timesheets of current week
function getTimesheetsofSelectedWeek() {
    if ($("[id*=txtdate]").val() != "" && currentWeek.length == 7) {
        $("#tabsLoader").css('display', 'block');
        var sendWeeksatrt = currentWeek[0];
        var endWeeksatrt = currentWeek[6];
        var sendObj = '{startdate:"' + sendWeeksatrt + '",enddate:"' + endWeeksatrt + '",staffcode:' + $("[id*=hdnStaffCode]").val() + ',compid:' + $("[id*=hdnCompanyID]").val() + '}';
        $("#btnSave").hide(); $("#btnSubmit").hide();
        ServerServiceToGetData(sendObj, '../Handler/TimesheetInput.asmx/getTimesheetsofSelectedWeek', false, Onsuccess_getSavedTimesheets);
    }
}

//////
function Onsuccess_getSavedTimesheets(res) {
    var ts = jQuery.parseJSON(res.d);
    Timesheet_inputs = ts;
    /////////////header will be change and set common for all tabs
    var commonheader = '';
    commonheader += "<tr>";
    commonheader += "<th style='text-align:center;'><input onclick='tabheadercheckboxcheck($(this))' type='checkbox'/></th>";
    commonheader += "<th style='text-align:right;'>#</th>";
    commonheader += "<th>Date</th>";
    commonheader += "<th class='labelChange'>Client Name</th>";
    commonheader += "<th class='labelChange'>Project Name</th>";
    commonheader += "<th class='labelChange'>Job Name</th>";
    if ($("[id*=hdnTimesheetInputType]").val() == "taskwise") {
        commonheader += "<th class='labelChange'>Task Name</th>";
    }
    if (CompanyPermissions[0].Format_B == false) {
        commonheader += "<th>From<br>Time</th>";
        commonheader += "<th>To<br>Time</th>";
        commonheader += "<th>Total<br>Time</th>";
    }
    else {
        commonheader += "<th>Total<br>Time</th>";
    }
    commonheader += "<th>Status</th>";
    commonheader += "<th>Time<br>Edit</th>";
    if (CompanyPermissions[0].Expense_mandatory)
    { commonheader += "<th>Exp.<br>Edit</th>"; }
    commonheader += "<th>Delete</th>";
    commonheader += "</tr>";

    $.each(tabPresents, function (i, tabva) {
        var tabdata = '';
        var tabid = tabva.tabid;
        var tabDatepresent = tabva.tabpresentdate;
        var srno = 0;
        /////make table empty
        $("[id*=" + tabid + "] .tabtables").empty();
        $.each(ts, function (i, va) {
            var tsDate = moment(eval("new " + va.Date.replace(/\//g, ""))).format("MM/DD/YYYY");
            if (tsDate == tabDatepresent || tabid == 'tabAll') {
                srno += 1;
                tabdata += "<tr>";
                var commonwidth = 175;
                var expCol = '';
                if (CompanyPermissions[0].Expense_mandatory) {
                    var imgpath = '';
                    if (va.OpeId == 0)
                    { imgpath = 'addnew.png'; }
                    else { imgpath = 'edit.png'; }
                    var datest = va.Status.split(',')[1].toString();
                    expCol = "<td style='width:37px; text-align:center;'><img style='margin:-4px;cursor:pointer;width:20px;' onclick='editTsExpense(" + va.TSId + ",$(this))' src='../images/" + imgpath + "'></td>";
                }
                if (va.Status.split(',')[0] == "Saved") {
                    tabdata += "<td style='text-align:center;'><input onclick='tabrowcheckboxcheck($(this))' type='checkbox' value='" + va.TSId + "'/></td>";
                }
                else { tabdata += "<td></td>"; }
                //#
                tabdata += "<td style='width:20px;text-align:right;'><input type='hidden' class='tabrowshownarration' value='" + va.Narration + "'/>" + srno + "</td>";
                //Date
                tabdata += "<td class='tabrowshowdate' data-usedate='" + va.Status.split(',')[1] + "' style='width:66px;text-align:center;'>" + moment(eval("new " + va.Date.replace(/\//g, ""))).format("DD/MM/YYYY") + "</td>";
                if (va.StaffName == "Leave") {
                    tabdata += "<td style='width:200px;' colspan='11'>" + va.ClientName + ' (' + va.ProjectName + ') ';
                    tabdata += "<b>From</b> : " + va.FromTime + " <b>To</b> : " + va.ToTime + " <b>Status</b> : " + va.Status.split(',')[0] + ' <b>Half Day</b> : ' + va.Narration;
                    tabdata += "</td>";
                }
                else {
                    ///Client Name
                    tabdata += "<td class='tabrowshowclientname' style='width:" + commonwidth + "px;'>" + va.ClientName + "</td>";
                    ////Project Name
                    tabdata += "<td class='tabrowshowprojectname' style='width:" + commonwidth + "px;'>" + va.ProjectName + "</td>";
                    ///	Job Name	
                    tabdata += "<td class='tabrowshowjobname' style='width:" + commonwidth + "px;'>" + va.MJobName + "</td>";
                    ////task name
                    if ($("[id*=hdnTimesheetInputType]").val() == "taskwise") {
                        tabdata += "<td class='tabrowshowtaskname' style='width:" + commonwidth + "px;'>" + va.TaskName + "</td>";
                    }
                    if (CompanyPermissions[0].Format_B == false) {
                        ////From Time
                        tabdata += "<td class='tabrowshowfromtime' style='width:38px;text-align:center;'>" + va.FromTime + "</td>";
                        ///To Time
                        tabdata += "<td class='tabrowshowtotime' style='width:38px;text-align:center;'>" + va.ToTime + "</td>";
                        ////Total Time
                        tabdata += "<td class='tabrowshowtotaltime' style='width:38px;text-align:center;'>" + va.TotalTime + "</td>";
                    }
                    else {
                        tabdata += "<td class='tabrowshowtotaltime' style='width:38px;text-align:center;'>" + va.TotalTime + "</td>";
                    }
                    ///Status
                    tabdata += "<td class='tabrowshowstatus' style='width:47px;text-align:center;'>" + va.Status.split(',')[0] + "</td>";
                    var editts = "<input type='hidden' class='tabrowshowlocation' value='" + va.LocId + "'/><img style='margin:-3px;cursor:pointer;width:20px;' onclick='editTsdata($(this)," + va.TSId + ")' src='../images/timeedit.png'>";
                    var deletets = "<img style='margin:-4px;cursor:pointer;width:20px;' onclick='deletesavedTimesheet(" + va.TSId + ")' src='../images/Delete.png'>";

                    if (va.Status.split(',')[0] == "Saved" || va.Status.split(',')[0] == "Rejected") {
                    }
                    else {
                        editts = ''; deletets = '';
                        if (CompanyPermissions[0].Expense_mandatory)
                            expCol = "<td></td>";
                    }
                    ///Time Edit
                    tabdata += "<td style='width:37px; text-align:center;'>" + editts + "</td>";
                    ////expense edit col
                    tabdata += expCol;
                    ////Delete
                    tabdata += "<td style='width:49px; text-align:center;'>" + deletets + "</td>";
                }
                tabdata += "</tr>";
            }
        });
        if (tabdata == '') {
            tabdata = '<tr><th style="text-align:center;background:#fff;width:970px; font-size:small;" colspan="25">No records found !</th></tr>';
        }
        tabdata = commonheader + tabdata;
        $("[id*=" + tabid + "] .tabtables").append(tabdata);
    });
    var finalweeltotal = "00:00";
    $(".rowCheckbox").each(function () {
        var dateOfrow = $(this).val();
        var DayTotal = '00:00';
        $.each(Timesheet_inputs, function (i, va) {
            if (dateOfrow == va.Status.split(',')[1] && va.TSId != 0)
            { DayTotal = timeaddtion(DayTotal, va.TotalTime); }
        });
        finalweeltotal = timeaddtion(finalweeltotal, DayTotal);
        DayTotal = convertTimeFormatToactual(DayTotal);
        $(".rowDayTotal", $(this).closest("tr")).html(DayTotal);
    });
    finalweeltotal = convertTimeFormatToactual(finalweeltotal);

    $('#tdweekFinalTotal').html(finalweeltotal);
    $("#btnSave").show(); $("#btnSubmit").show();
    setTimeout(function () { $("#tabsLoader").css('display', 'none'); }, 1000);
    //$(".tabtables input[type=checkbox]"); //.click(function () { tabrowcheckboxcheck($(this)); });
    SafeChangeLabel('createTimesheetInputTable');
}
///////////checkbox of tab 
////header
function tabheadercheckboxcheck(currobj) {
    var tbl = currobj.closest("table");
    tbl.find("input[type=checkbox]").each(function () {
        if (currobj.is(':checked'))
        { $(this).prop('checked', true); }
        else { $(this).prop('checked', false); }
    });
    tabrowcheckboxcheck(currobj);
}
////row
function tabrowcheckboxcheck(currobj) {
    //    var TSIDS = [];
    //    $(".tabtables input[type=checkbox]").each(function () {
    //        if ($(this).is(':checked'))
    //            if (TSIDS.indexOf($(this).val()) == -1)
    //            { TSIDS.push($(this).val()); }

    //        if (TSIDS.indexOf($(this).val()) > -1) { $(this).prop('checked', true); }
    //        else { $(this).prop('checked', false); }
    //    });
}

/////////delete saved timesheet
function deletesavedTimesheet(tsid) {
    var con = confirm('Are you sure want to delete?');
    if (con == true) {
        $("#tabsLoader").css('display', 'block');
        var sendObj = '{TSID:' + tsid + ',staffcode:' + $("[id*=hdnStaffCode]").val() + ',compid:' + $("[id*=hdnCompanyID]").val() + '}';
        ServerServiceToGetData(sendObj, '../Handler/TimesheetInput.asmx/deletesavedTimesheet', false, Onsuccess_timesheetdeleted);
    }
}
//////deleted success
function Onsuccess_timesheetdeleted(res) {
    if (res.d == "" || res.d == undefined || res.d == null || res.d == "error") { showError('Getting error while deleting timesheet!'); }
    else if (res.d == "success") { showSuccess("Timesheet deleted successfully"); getTimesheetsofSelectedWeek(); }
}
/////timesheet edit
function editTsdata(curr, tsid) {
    $("#tblTimesheetEdit #editdate").data('tsid', tsid);
    $("#tblTimesheetEdit #editdate").data('dateinmmddyy', $(".tabrowshowdate", curr.closest("tr")).data('usedate'));
    $("#tblTimesheetEdit #editdate").html($(".tabrowshowdate", curr.closest("tr")).html());
    $("#tblTimesheetEdit #editclientname").html($(".tabrowshowclientname", curr.closest("tr")).html());
    $("#tblTimesheetEdit #edtitprojectname").html($(".tabrowshowprojectname", curr.closest("tr")).html());
    $("#tblTimesheetEdit #editjobname").html($(".tabrowshowjobname", curr.closest("tr")).html());
    $("#tblTimesheetEdit #edittaskname").html($(".tabrowshowtaskname", curr.closest("tr")).html());
    if (CompanyPermissions[0].Format_B == false) {
        $("#tblTimesheetEdit #frtime").show();
        $("#tblTimesheetEdit #tottime").hide();
        $("#tblTimesheetEdit #editfromtime").val($(".tabrowshowfromtime", curr.closest("tr")).html());
        $("#tblTimesheetEdit #edittotime").val($(".tabrowshowtotime", curr.closest("tr")).html());
        $("#tblTimesheetEdit #edittotaltime").html($(".tabrowshowtotaltime", curr.closest("tr")).html());
    }
    else {
        $("#tblTimesheetEdit #tottime").show();
        $("#tblTimesheetEdit #frtime").hide();
        var t = $(".tabrowshowtotaltime", curr.closest("tr")).html();
        $("#tblTimesheetEdit #TxtedtTottime").val(t);
    }
    $("#tblTimesheetEdit #editstatus").html($(".tabrowshowstatus", curr.closest("tr")).html());
    $("#tblTimesheetEdit #editnarration").val($(".tabrowshownarration", curr.closest("tr")).val());
    $("#tblTimesheetEdit #editlocaiton").val($(".tabrowshowlocation", curr.closest("tr")).val())
    $("#tblTimesheetEdit #edittotaltime").css('color', 'black');
    $("#modalhidediv").css('display', '');
    $find("programmaticModalPopupOrginalBehavior").show();
}

/////timesheet expense edit
function editTsExpense(cuurTsid, cuurojb) {

    $("#btnExpensefindlSave").attr('onclick', 'saveExpesneOnEdittsidbased(' + cuurTsid + ')');
    $("[id*=lblExpenseDae]").html('Expense entry for : ' + moment($(".tabrowshowdate", cuurojb.closest("tr")).data('usedate')).format('DD MMM YYYY'));
    if (cuurojb.attr('src') == "../images/addnew.png")
    { Onsuccess_ExpenseEdit(null); }
    else {
        $('.modalganesh').css('display', 'block');
        var sendObj = '{TSID:' + cuurTsid + ',staffcode:' + $("[id*=hdnStaffCode]").val() + ',compid:' + $("[id*=hdnCompanyID]").val() + '}';
        ServerServiceToGetData(sendObj, '../Handler/TimesheetInput.asmx/getExpenseagiainsTSID', false, Onsuccess_ExpenseEdit);
    }
}
/////onexpense edit
function Onsuccess_ExpenseEdit(res) {
    debugger
    resetExpensePopup();
    var ExpArry = [];

    if (res != null && res != undefined)
        if (res.d.length != 0)
        { ExpArry = jQuery.parseJSON(res.d); }

    makeExpenseTable(ExpArry);
    $("#brnAddExpense").attr('onclick', 'addExpenseclick()');
    $("#modalhidediv").css('display', '');
    $find("modalExpense").show();
    $('.modalganesh').css('display', 'none');
}
////
function saveExpesneOnEdittsidbased(currTsId) {
    $('.modalganesh').css('display', 'block');
    var jsonofexpens = [];
    $(".tblExpense tbody tr").each(function () {
        var $currrow = $(this);
        jsonofexpens.push({
            'ExpId': $("input[type=hidden]", $(this).closest("tr")).val(),
            'ExpName': $currrow.find(':eq(0)').text(),
            'Amt': $currrow.find(':eq(2)').text(),
            'ExpNarration': $currrow.find(':eq(3)').text()
        });
    });
    jsonofexpens = JSON.stringify(jsonofexpens);
    var sendObj = '{TSID:' + currTsId + ',staffcode:' + $("[id*=hdnStaffCode]").val() + ',compid:' + $("[id*=hdnCompanyID]").val() + ',ts:' + jsonofexpens + '}';
    ServerServiceToGetData(sendObj, '../Handler/TimesheetInput.asmx/saveExpenseagiainsTSID', false, Onsuccess_ExpenseEditSave);
}
///////////////function expense save against tsid
function Onsuccess_ExpenseEditSave(res) {
    if (res.d == 'success') {
        showSuccess('Expense saved successfully.........');
        getTimesheetsofSelectedWeek();
    }
    else { showError('Error occoured while saving expense....'); }
    $find("modalExpense").hide();
    $('.modalganesh').css('display', 'none');
}
///////popup events
function getPopupTotalTime() {
    $("#tblTimesheetEdit #edittotaltime").html('00:00');
    ///get from and to time
    var from = $("#tblTimesheetEdit #editfromtime").val();
    var to = $("#tblTimesheetEdit #edittotime").val();
    ///////check where empty or not
    if (from == "" || from == null || from == undefined || $("#tblTimesheetEdit #editfromtime").val().length != 5)
    { from = "00:00"; $("#tblTimesheetEdit #editfromtime").val(from); }
    if (to == "" || to == null || to == undefined || $("#tblTimesheetEdit #edittotime").val().length != 5)
    { to = "00:00"; $("#tblTimesheetEdit #editfromtime").val(to); }
    //////check to time is greater than from time 
    /////so convert time format to float
    var fromno = from.split(':')[0] + '.' + from.split(':')[1];
    var tono = to.split(':')[0] + '.' + to.split(':')[1];

    if (parseFloat(fromno) > 0 && parseFloat(tono) > 0 && parseFloat(tono) > parseFloat(fromno)) {
        var resTime = compareTimes(from, to);
        $("#tblTimesheetEdit #edittotaltime").html(resTime);
        $("#tblTimesheetEdit #edittotaltime").css('color', 'black');
    }
}
////////////save click of popup
function saveEditTimesheetInput(status) {
    var msg = "";
    var ts;
    var valid;
    if (CompanyPermissions[0].Format_B == false) {
        if ($("#tblTimesheetEdit #edittotaltime").html() == "00:00" || $("#tblTimesheetEdit #edittotaltime").html().length != 5 || $("#tblTimesheetEdit #edittotaltime").html() == "" || $("#tblTimesheetEdit #edittotaltime").html() == undefined) {
            $("#tblTimesheetEdit #edittotaltime").css('color', 'red');
            alert('Please check time not enter proper!');
            return false;
        }
        else { $("#tblTimesheetEdit #edittotaltime").css('color', 'black'); }
        valid = tsValidation($("#tblTimesheetEdit #editdate").data('dateinmmddyy'), $("#tblTimesheetEdit #editfromtime").val(), $("#tblTimesheetEdit #edittotime").val(), $("#tblTimesheetEdit #editdate").data('tsid'));
    }
    else {
        var t = $("#tblTimesheetEdit #TxtedtTottime").val();
        if (t == "00:00" || t.length != 5 || t == "" || t == undefined) {
            $("#tblTimesheetEdit #TxtedtTottime").css('color', 'red');
            alert('Please check time not enter proper!');
            return false;
        }
        else {
            $("#tblTimesheetEdit #TxtedtTottime").css('color', 'black');
            valid = true;
        }
    }
    if (CompanyPermissions[0].Location_mandatory)
        if ($("#tblTimesheetEdit #editlocaiton").val() == "0" || $("#tblTimesheetEdit #editlocaiton").val() == null || $("#tblTimesheetEdit #editlocaiton").val() == undefined || $("#tblTimesheetEdit #editlocaiton").val() == '') {
            alert('Please select location!');
            return false;
        }



    if (valid != true)
    { alert(valid); return false; }
    if (CompanyPermissions[0].Format_B == false) {
        ts = {
            ts: {
                StaffCode: $("[id*=hdnStaffCode]").val(),
                CompId: $("[id*=hdnCompanyID]").val(),
                FromTime: $("#tblTimesheetEdit #editfromtime").val(),
                ToTime: $("#tblTimesheetEdit #edittotime").val(),
                TotalTime: $("#tblTimesheetEdit #edittotaltime").html(),
                TSId: $("#tblTimesheetEdit #editdate").data('tsid'),
                Date: $("#tblTimesheetEdit #editdate").data('dateinmmddyy'),
                Status: status,
                Narration: $("#tblTimesheetEdit #editnarration").val(),
                LocId: $("#tblTimesheetEdit #editlocaiton").val()
            }
        }
    }
    else {
        ts = {
            ts: {
                StaffCode: $("[id*=hdnStaffCode]").val(),
                CompId: $("[id*=hdnCompanyID]").val(),
                FromTime: "00:00",
                ToTime: t,
                TotalTime: t,
                TSId: $("#tblTimesheetEdit #editdate").data('tsid'),
                Date: $("#tblTimesheetEdit #editdate").data('dateinmmddyy'),
                Status: status,
                Narration: $("#tblTimesheetEdit #editnarration").val(),
                LocId: $("#tblTimesheetEdit #editlocaiton").val()
            }
        }

    }

    ts = JSON.stringify(ts);
    $('.modalganesh').css('display', 'block');

    ServerServiceToGetData(ts, '../Handler/TimesheetInput.asmx/saveeditSaveTimesheetInput', false, Onsuccess_saveeditTimesheets);
}
////////////////////success of edit timesheet save
function Onsuccess_saveeditTimesheets(res) {
    if (res.d == "success") {
        showSuccess('Timesheet saved successfully......');
        getTimesheetsofSelectedWeek();
    }
    else { showError("Getting error while saving.........."); }
    $find("programmaticModalPopupOrginalBehavior").hide();
    $('.modalganesh').css('display', 'none');
}

/////////timesheet save for approval
function Submitforapproval() {
    var TSIDS = [];
    $(".tabtables input[type=checkbox]:checked").each(function () {
        if (TSIDS.indexOf($(this).val()) == -1) {
            ///added by ganesh wajage 19/08/2017 for check value is only integer
            if (!isNaN($(this).val()))
                TSIDS.push($(this).val());
        }
    });
    if (TSIDS.length == 0) {
        alert('Please select at least one saved timesheet!');
        return false;
    }
    $('.modalganesh').css('display', 'block');
    var sendObj = '{TSIDS:"' + TSIDS.join(',') + '",staffcode:' + $("[id*=hdnStaffCode]").val() + ',compid:' + $("[id*=hdnCompanyID]").val() + '}';
    ServerServiceToGetData(sendObj, '../Handler/TimesheetInput.asmx/SubmitSavedTiemsheets', false, Onsuccess_Submitforapproval);
}

function Onsuccess_Submitforapproval(res) {
    $('.modalganesh').css('display', 'none');
    if (res.d == "success")
    { showSuccess('Timesheet submitted successfully......'); getTimesheetsofSelectedWeek(); }
    else { showError("Getting error while saving.........."); }
}

/////////////////timesheet validation
function tsValidation(datets, fromts, tots, tsid) {
    var resSt = true;
    $.each(Timesheet_inputs, function (i, va) {
        if (tsid != va.TSId && datets == va.Status.split(',')[1]) {
            if (va.StaffName == "Leave") {
                var leavemsg = true;
                if (va.Narration == "First Half on First Day" && va.FromTime == va.Status.split(',')[1]) {
                    if (parseFloat(fromts.replace(':', '.')) >= 14)
                        leavemsg = "Leave already applied can not enter timesheet!"
                }
                else if (va.Narration == "Second Half on First Day" && va.FromTime == va.Status.split(',')[1]) {
                    if (parseFloat(fromts.replace(':', '.')) <= 14)
                        leavemsg = "Leave already applied can not enter timesheet!"
                }
                else if (va.Narration == "First Half on Last Day" && va.ToTime == va.Status.split(',')[1]) {
                    if (parseFloat(fromts.replace(':', '.')) >= 14)
                        leavemsg = "Leave already applied can not enter timesheet!"
                }
                else
                { leavemsg = "Leave already applied can not enter timesheet!" }
                resSt = leavemsg;
            }
            else {
                var staffFrom = fromts;
                var staffTo = tots;
                var tsfrom = va.FromTime;
                var tsto = va.ToTime;

                staffFrom = parseFloat(staffFrom.replace(':', '.'))
                staffTo = parseFloat(staffTo.replace(':', '.'))
                tsfrom = parseFloat(tsfrom.replace(':', '.'));
                tsto = parseFloat(tsto.replace(':', '.'));

                var flagforTsValid = false;

                ////////modified by ganesh wajage 19/08/2017
                if (tsfrom <= staffFrom && tsto > staffFrom)
                    flagforTsValid = true;
                if (tsfrom < staffTo && tsto >= staffTo)
                    flagforTsValid = true;
                if (staffFrom < tsto && staffTo >= tsto)
                    flagforTsValid = true;

                if (flagforTsValid)
                    resSt = "Timesheet entry is already made for " + moment(va.Status.split(',')[1]).format('DD/MM/YYYY') + "  " + underline(va.FromTime) + "  to  " + underline(va.ToTime) + "  period. Please select different Date / Time.";

                console.log(staffFrom, staffTo, tsfrom, tsto);
            }
        }
    });
    return resSt;
}

//////////location validaton
function locationvalidationColorChange(curr) {
    if (CompanyPermissions[0].Location_mandatory) {
        if ($(".rowlocation", curr.closest("tr")).val() == "0" || $(".rowlocation", curr.closest("tr")).val() == undefined || $(".rowlocation", curr.closest("tr")).val() == null || $(".rowlocation", curr.closest("tr")).val() == "") {
            $(".rowlocation", curr.closest("tr")).css('color', 'red');
            $(".rowlocation", curr.closest("tr")).css('border-color', 'red');
        }
        else {
            $(".rowlocation", curr.closest("tr")).css('color', 'black');
            $(".rowlocation", curr.closest("tr")).css('border-color', 'rgb(169, 169, 169)');
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
            alert(response.responseText);
        },
        failure: function (response) {
            alert(response.responseText);
        }
    });
}

function convertTimeFormatToactual(DayTotal) {
    DayTotal = DayTotal.split(':');
    if (DayTotal[0].length == 1)
    { DayTotal[0] = "0" + DayTotal[0]; }
    if (DayTotal[1].length == 1)
    { DayTotal[1] = "0" + DayTotal[1]; }
    return DayTotal[0] + ':' + DayTotal[1];
}

function resetDropdowns(name) {
    $("#ddl" + name).empty();
    $("#ddl" + name).append('<option  class="labelChange" value="0">Select ' + name + '</option>');

    if (name != 'Task')
        $(".tbljobprojectdetails .txtbox").each(function () { $(this).val(''); });

    SafeChangeLabel('resetDropdowns');
}

function underline(s) {
    var arr = s.split('');
    s = arr.join('\u0332');
    if (s) s = s + '\u0332';
    return s;
}

function compareDates(dateTimeA, dateTimeB) {
    var momentA = moment(dateTimeA, "DD/MM/YYYY");
    var momentB = moment(dateTimeB, "DD/MM/YYYY");
    if (momentA > momentB) return 1;
    else if (momentA < momentB) return -1;
    else return 0;
}

function compareTimes(fromT, toT) {
    var now = "04/09/2016 " + toT + ":00";
    var then = "04/09/2016 " + fromT + ":00";
    var resTime = moment.utc(moment(now, "DD/MM/YYYY HH:mm:ss").diff(moment(then, "DD/MM/YYYY HH:mm:ss"))).format("HH:mm");
    return resTime;
}
function timeaddtion(startTime, endTime) {
    var firstHH = startTime.split(':')[0];
    var firstMM = startTime.split(':')[1];
    var endtHH = endTime.split(':')[0];
    var endMM = endTime.split(':')[1];

    var totalHH = parseFloat(firstHH) + parseFloat(endtHH);
    var totalMM = parseFloat(firstMM) + parseFloat(endMM);
    if (totalMM >= 60) {
        var realmin = totalMM % 60;
        var hours = Math.floor(totalMM / 60);
        totalHH = parseFloat(totalHH) + parseFloat(hours);
        totalMM = realmin;
    }

    return totalHH + ':' + totalMM;
}
function showSuccess(msg) {
    $("[id*=MessageControl1]").html(msg);
    $("[id*=MessageControl1]").attr('class', '');
    $("[id*=MessageControl1]").attr('class', 'success');
    disappearControl($("[id*=MessageControl1]").attr('id'));
    SafeChangeLabel('showSuccess');
}

function showError(msg) {
    $("[id*=MessageControl1]").html(msg);
    $("[id*=MessageControl1]").attr('class', '');
    $("[id*=MessageControl1]").attr('class', 'error');
    disappearControl($("[id*=MessageControl1]").attr('id'));
    SafeChangeLabel('showError');
}

function SafeChangeLabel(menthodname) {

    try {
        LabelChangeforall();
    } catch (e) {
        console.log(menthodname);
        console.log(e);
    }
}