<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Add_StaffRecord.ascx.cs" Inherits="controls_Add_StaffRecord" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>

<link href="../jquery/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />

<style type="text/css">
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

    .txt_grds {
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

    .headerpage {
        height: 23px;
        width: 100%;
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

    .modalganesh {
        z-index: 999999;
    }

    .cssPageTitle {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        border-bottom: 2px solid #0b9322;
        color: #0b9322;
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
</style>
<script language="javascript" type="text/javascript">

    $(document).ready(function () {
        $("[id*=hdnStaffLimit]").val(0);
        $("[id*=hdnCntSft]").val(0);
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        $("[id*=hdnPages]").val(1);
        $("[id*=txtsrchjob]").val('');
        var main_obj = [];

        GetAlldropdown();
        $("[id*=dvEdit]").hide();
        $("[id*=editsavedv]").hide();
        var newDate = new Date();
        $("[id*=hdnDT]").val(newDate);

        if ($("[id*=hidpermitionID]").val() == '0') {
            $("[id*=tdstfrol1]").hide();
            $("[id*=tdstfrol2]").hide();
        }

        $("[id*= btnsrchjob]").on('click', function () {
            GetStaffRecord(1, 25);
        });

        $("[id*= btnStaffAdd]").on('click', function () {
            var Staffcount = parseInt($("[id*=hdnCntSft]").val());
            Staffcount = parseInt(Staffcount) + 1;
            if (parseInt(Staffcount) <= parseInt($("[id*=hdnStaffLimit]").val())) {
                resetstaff();

                $("[id*=dvEdit]").show();
                $("[id*=editsavedv]").show();
                $("[id*=dvStaff]").hide();
                $("[id*=dvsrch]").hide();
            }
            else {
                alert('You Exceed the Staff Limit. Contact Saibex Network');
            }

        });

        $("[id*= btnCancel]").on('click', function () {
            $("[id*=dvEdit]").hide();
            $("[id*=editsavedv]").hide();
            $("[id*=dvStaff]").show();
            $("[id*=dvsrch]").show();
        });

        $("[id*= drpdesig]").on('change', function () {
            HourlyCharges();
        });

        $("[id*=txtemail]").on('change', function () {
            $("[id*=txtusrname]").val($(this).val());
        });

        $("[id*=btnSave]").on('click', function () {
            var sttf = $("[id*=hdnoldStaffcode]").val();
            if (sttf == '0') {
                InsertStaff();
            }
            else {
                updateStaff(sttf);
            }
        });

        $("[id*=btnedithourly]").on('click', function () {
            $("[id*=lblstfname]").html($("[id*=txtstaffname]").val());
            $find("mailingListModalPopupBehavior").show();
            BindHrlyGrd();
        });
        ////////////////////////////////////////////////////////////////////

        $("#btnHDel").live('click', function () {
            var row = $(this).closest("tr");
            var hid = row.find("input[type=hidden]").val();

            $("[id*=hdncode]").val(hid);
            RecordDelete();
        });

        // Hourly charges
        $("[id*= btnAdd]").live('click', function () {
            var frDT = $("[id*=txtfromdate]").val();
            var hrly = $("[id*=txthourlycharges]").val();
            var Stf = $("[id*=hdnoldStaffcode]").val();
            var hid = $("[id*=hdncode]").val();
            var toDT = $("[id*=txttodate]").val();
            if (frDT == "") {
                alert("From Date Not entered");
                return;
            }
            if (hrly == "") {
                alert("Hourly Charges Not entered");
                return;
            }

            if (parseFloat(hrly) == 0) {
                alert("Hourly Charges should be greater than zero");
                return;
            }
            if (hid == "") {
                hid = "0";
            }
            if (toDT == "") {
                toDT = "";
            }

            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Managestaff.aspx/insertHourlyGrd",
                data: '{staff:' + Stf + ',compid:' + $("[id*=hdnCompanyid]").val() + ', hrly:' + hrly + ', frDt:"' + frDT + '", hid:' + hid + ',toDT:"' + toDT + '"}',
                dataType: "json",
                success: function (msg) {

                    if (msg.d.length > 0) {

                        if (msg.d[0].Errmsg == "Hourly Charges Successfully Updated") {
                            BindHrlyGrd();
                            //window.location.href = "ManageStaff.aspx"

                            alert(msg.d[0].Errmsg);
                        }
                        else {
                            alert(msg.d[0].Errmsg);
                        }
                    }
                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //Ajax end
        });


        // Joining Date Insert
        $("[id*= BtnJn]").live('click', function () {
            var JDt = $("[id*=TxtJDate]").val();
            var Stf = $("[id*=hdnStfcode]").val();
            if (JDt == "") {
                alert("Joining Date Not entered");
                return;
            }

            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Managestaff.aspx/InsertJoining",
                data: '{staff:' + Stf + ',compid:' + $("[id*=hdnCompanyid]").val() + ', JDt:"' + JDt + '"}',
                dataType: "json",
                success: function (msg) {

                    if (msg.d.length > 0) {

                        if (msg.d[0].Errmsg == "Joining Date Successfully Updated") {
                            alert(msg.d[0].Errmsg);
                            $find("ListModalPopupBehavior").hide();
                        }
                        else {
                            alert(msg.d[0].Errmsg);
                        }
                    }
                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //Ajax end
        });



        $("#btnHEdit").live('click', function () {
            var row = $(this).closest("tr");
            var hid = row.find("input[type=hidden]").val();

            $("[id*=hdncode]").val(hid);
            document.getElementById('<%=txtfromdate.ClientID %>').value = $("td", $(this).closest("tr")).eq(1).html();
            document.getElementById('<%=txthourlycharges.ClientID %>').value = $("td", $(this).closest("tr")).eq(3).html();

        });
    });

    ///changes made on 11/08/2020
    function Delete_Temp(i) {
        var row = i.closest("tr");
        var staffcode = row.find("input[name=hdntempid]").val();
        var compid = $("[id*=hdnCompanyid]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/WS_StaffDetails.asmx/DeleteStaff",
            data: '{compid:' + compid + ',Staffcode:' + staffcode + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                //var myList = jQuery.parseJSON(msg.d);
                var myList = jQuery.parseJSON(msg.d);
                if (myList[0].id == '-1') {
                    alert("Timesheet Available Of This Staff Cant Delete !!!");
                } else {
                    alert("Successfully Deleted!!!");
                    GetStaffRecord(1, 25);
                }

                $('.loader').hide();
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
    }

    function updateStaff(sttf) {
        var compid = $("[id*=hdnCompanyid]").val();
        var Staffname = $("[id*=txtstaffname]").val();
        var Emailid = $("[id*=txtemail]").val();
        var FlatNo = $("[id*=txtaddress1]").val();
        var Bldgname = $("[id*=txtaddress2]").val();
        var street = $("[id*=txtaddress3]").val();
        var city = $("[id*=txtcity]").val();
        var Brid = $("[id*=drpbranch]").val();
        var Mob = $("[id*=txtmob]").val();
        var dept = $("[id*=drpdep]").val();
        var Desg = $("[id*=drpdesig]").val();
        var DOJ = $("[id*=txtjoindate]").val();
        var DoL = $("[id*=txtenddate]").val();
        var Empid = $("[id*=txtstaffThumbLoginID]").val();
        var Hourlychrg = $("[id*=txthourcharge]").val();
        var Staffrole = $("[id*=ddlsroll]").val();
        var Emptype = $("[id*=drpEType]").val();
        var Qlf = $("[id*=TxtQ]").val();
        var UserName = $("[id*=txtusrname]").val();
        var pass = $("[id*=txtpassword]").val();
        var Comfpass = $("[id*=txtConfirm]").val();

        if (Staffname == '' || Emailid == '' || dept == '0' || Desg == '0' || UserName == '' || pass == '' || Comfpass == '') {
            alert('Mandatory fields Must be filled.');
            return
        }

        if (pass != Comfpass) {
            alert('Password Mismatch');
            return
        }

        var rid = Staffname + '^' + FlatNo + '^' + Bldgname + '^' + street + '^' + city + '^' + Brid + '^' + Mob + '^' + dept + '^' + Desg + '^' + Empid + '^' + Hourlychrg + '^' + Emptype + '^' + Qlf + '^' + Staffrole;
        $.ajax({
            type: "POST",
            url: "../Handler/WS_StaffDetails.asmx/UpdateStaff",
            data: '{compid:' + compid + ',rid:"' + rid + '",DOJ:"' + DOJ + '",DoL:"' + DoL + '",Hourlychrg:' + Hourlychrg + ',Staffcode:' + sttf + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                //var myList = jQuery.parseJSON(msg.d);
                var myList = jQuery.parseJSON(msg.d);
                if (myList[0].id == '-1') {
                    alert('Duplicate Staffname found !!!');
                }
                else {
                    if (myList[0].id > 0) {
                        alert('Staff Updated Successfully !!!');
                        GetStaffRecord(1, 25);
                        $("[id*=dvEdit]").hide();
                        $("[id*=editsavedv]").hide();
                        $("[id*=dvStaff]").show();
                        $("[id*=dvsrch]").show();
                        $("[id*=txtsrchjob]").val('');
                    }
                }

                $('.loader').hide();
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
    }

    function resetstaff() {
        $("[id*=txtstaffname]").val('');
        $("[id*=txtemail]").val('');
        $("[id*=txtaddress1]").val('');
        $("[id*=txtaddress2]").val('');
        $("[id*=txtaddress3]").val('');
        $("[id*=txtcity]").val('');
        $("[id*=drpbranch]").val(0);
        $("[id*=txtmob]").val('');
        $("[id*=drpdep]").val(0);
        $("[id*=drpdesig]").val(0);
        //$("[id*=txtjoindate]").val('');
        $("[id*=txtenddate]").val('');
        $("[id*=txtstaffThumbLoginID]").val(0);
        $("[id*=txthourcharge]").val('');
        $("[id*=ddlsroll]").val($("[id*=hdnStaffrole]").val());
        $("[id*=drpEType]").val('');
        $("[id*=TxtQ]").val('');
        $("[id*=txtusrname]").val('');
        $("[id*=txtpassword]").val('');
        $("[id*=txtConfirm]").val('');
        $("[id*=hdnoldStaffcode]").val(0);
        $("[id*=btnedithourly]").hide();

        $("[id*=txtConfirm]").attr("disabled", false);
        $("[id*=txtpassword]").attr("disabled", false);
        $("[id*=txtusrname]").attr("disabled", false);
        $("[id*=txtemail]").attr("disabled", false);
    }

    ////StaffEdit
    function Edit_Show(i) {
        var row = i.closest("tr");
        var staffcode = row.find("input[name=hdntempid]").val();
        var compid = $("[id*=hdnCompanyid]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/WS_StaffDetails.asmx/EditStaff",
            data: '{compid:' + compid + ',staffcode:' + staffcode + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length > 0) {
                    $("[id*=txtstaffname]").val(myList[0].StaffName);
                    $("[id*=txtemail]").val(myList[0].Email);
                    $("[id*=txtaddress1]").val(myList[0].Add1);
                    $("[id*=txtaddress2]").val(myList[0].Add2);
                    $("[id*=txtaddress3]").val(myList[0].Add3);
                    $("[id*=txtcity]").val(myList[0].city);
                    $("[id*=drpbranch]").val(myList[0].Brid);
                    $("[id*=txtmob]").val(myList[0].Phone);
                    $("[id*=drpdep]").val(myList[0].Dept);
                    $("[id*=drpdesig]").val(myList[0].Desig);
                    $("[id*=txtjoindate]").val(myList[0].DOJ);
                    $("[id*=txtenddate]").val(myList[0].DOL);
                    $("[id*=txtstaffThumbLoginID]").val(myList[0].Empid);
                    $("[id*=txthourcharge]").val(myList[0].HrsCharg);
                    $("[id*=ddlsroll]").val(myList[0].Staff_roll);
                    $("[id*=drpEType]").val(myList[0].Contractwork);
                    $("[id*=TxtQ]").val(myList[0].Qual);
                    $("[id*=txtusrname]").val(myList[0].username);
                    $("[id*=txtpassword]").val(myList[0].password);
                    $("[id*=txtConfirm]").val(myList[0].password);
                    $("[id*=btnedithourly]").show();

                    $("[id*=txtConfirm]").attr("disabled", true);
                    $("[id*=txtpassword]").attr("disabled", true);
                    $("[id*=txtusrname]").attr("disabled", true);
                    $("[id*=txtemail]").attr("disabled", true);

                    $("[id*=hdnoldStaffcode]").val(myList[0].Staffcode);
                    $("[id*=dvEdit]").show();
                    $("[id*=editsavedv]").show();
                    $("[id*=dvStaff]").hide();
                    $("[id*=dvsrch]").hide();



                }

                $('.loader').hide();
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
    }

    function ValidateText(i) {
        if (i.value == 0) {
            i.value = null;
        }
        if (i.value.length > 0) {
            i.value = i.value.replace(/[^\d]+/g, '');
        }
    }

    function Emailvalid(field) {
        field.value = field.value.replace(/[?,\/#!$%\^\*;:{}=\_`~"+]/g, "");
    }

    /////Insert Staff
    function InsertStaff() {
        var Compid = $("[id*=hdnCompanyid]").val();
        var Staffname = $("[id*=txtstaffname]").val();
        var Emailid = $("[id*=txtemail]").val();
        var FlatNo = $("[id*=txtaddress1]").val();
        var Bldgname = $("[id*=txtaddress2]").val();
        var street = $("[id*=txtaddress3]").val();
        var city = $("[id*=txtcity]").val();
        var Brid = $("[id*=drpbranch]").val();
        var Mob = $("[id*=txtmob]").val();
        var dept = $("[id*=drpdep]").val();
        var Desg = $("[id*=drpdesig]").val();
        var DOJ = $("[id*=txtjoindate]").val();
        var DoL = $("[id*=txtenddate]").val();
        var Empid = $("[id*=txtstaffThumbLoginID]").val();
        var Hourlychrg = $("[id*=txthourcharge]").val();
        var Staffrole = $("[id*=ddlsroll]").val();
        var Emptype = $("[id*=drpEType]").val();
        var Qlf = $("[id*=TxtQ]").val();
        var UserName = $("[id*=txtusrname]").val();
        var pass = $("[id*=txtpassword]").val();
        var Comfpass = $("[id*=txtConfirm]").val();

        if (Staffname == '' || Emailid == '' || dept == '0' || Desg == '0' || UserName == '' || pass == '' || Comfpass == '') {
            alert('Mandatory fields Must be filled.');
            return
        }

        if (pass != Comfpass) {
            alert('Password Mismatch');
            return
        }

        var rid = Staffname + '^' + FlatNo + '^' + Bldgname + '^' + street + '^' + city + '^' + Brid + '^' + Mob + '^' + dept + '^' + Desg + '^' + Empid + '^' + Hourlychrg + '^' + Emptype + '^' + Qlf + '^' + Staffrole;

        $.ajax({
            type: "POST",
            url: "../Handler/WS_StaffDetails.asmx/InsertNewStaff",
            data: '{compid:' + Compid + ',rid:"' + rid + '",DOJ:"' + DOJ + '",DoL:"' + DoL + '",UserName:"' + UserName + '",Comfpass:"' + Comfpass + '",Hourlychrg:' + Hourlychrg + ',Emailid:"' + Emailid + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                //var myList = jQuery.parseJSON(msg.d);
                var myList = jQuery.parseJSON(msg.d);
                if (myList[0].id == '-1') {
                    alert('There already exists a user with this email address.');
                }
                else if (myList[0].id == '-2') {
                    alert('There already exists a user with this username.');
                } else if (myList[0].id == '-3') {
                    alert('Duplicate Staffname found !!!');
                } else {
                    if (myList[0].id > 0) {
                        $("[id*=hdnnewStaffcode]").val(myList[0].id);
                        document.getElementById('<%= btnmember.ClientID %>').click();
                    }
                }

                $('.loader').hide();
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });


}

function CheckPasswordStrength1(password) {
    var password_strength = document.getElementById("password_strength1");

    //TextBox left blank.
    if (password.length == 0) {
        password_strength.innerHTML = "";
        return;
    }

    //Regular Expressions.
    var regex = new Array();
    regex.push("[A-Z]"); //Uppercase Alphabet.
    regex.push("[a-z]"); //Lowercase Alphabet.
    regex.push("[0-9]"); //Digit.
    regex.push("[$@$!%*#?&]"); //Special Character.

    var passed = 0;

    //Validate for each Regular Expression.
    for (var i = 0; i < regex.length; i++) {
        if (new RegExp(regex[i]).test(password)) {
            passed++;
        }
    }

    //Validate for length of Password.
    if (passed > 2 && password.length > 8) {
        passed++;
    }

    //Display status.
    var color = "";
    var strength = "";
    switch (passed) {
        case 0:
        case 1:
            strength = "Weak";
            color = "red";
            break;
        case 2:
            strength = "Good";
            color = "darkorange";
            break;
        case 3:
        case 4:
            strength = "Strong";
            color = "green";
            break;
        case 5:
            strength = "Very Strong";
            color = "darkgreen";
            break;
    }
    password_strength.innerHTML = strength;
    password_strength.style.color = color;

}
function CheckPasswordStrength(password) {
    var password_strength = document.getElementById("password_strength");

    //TextBox left blank.
    if (password.length == 0) {
        password_strength.innerHTML = "";
        return;
    }

    //Regular Expressions.
    var regex = new Array();
    regex.push("[A-Z]"); //Uppercase Alphabet.
    regex.push("[a-z]"); //Lowercase Alphabet.
    regex.push("[0-9]"); //Digit.
    regex.push("[$@$!%*#?&]"); //Special Character.

    var passed = 0;

    //Validate for each Regular Expression.
    for (var i = 0; i < regex.length; i++) {
        if (new RegExp(regex[i]).test(password)) {
            passed++;
        }
    }

    //Validate for length of Password.
    if (passed > 2 && password.length > 8) {
        passed++;
    }

    //Display status.
    var color = "";
    var strength = "";
    switch (passed) {
        case 0:
        case 1:
            strength = "Weak";
            color = "red";
            break;
        case 2:
            strength = "Good";
            color = "darkorange";
            break;
        case 3:
        case 4:
            strength = "Strong";
            color = "green";
            break;
        case 5:
            strength = "Very Strong";
            color = "darkgreen";
            break;
    }
    password_strength.innerHTML = strength;
    password_strength.style.color = color;

}

function passwordmatch() {
    var spn_secpassword = document.getElementById("spn_secpassword");
    var firstpass = $("[id*=txtpassword]").val();
    var secndpass = $("[id*=txtConfirm]").val();
    var color = "";
    var strength = "";

    if (secndpass.length == 0) {
        spn_secpassword.innerHTML = "";
        return;
    }

    if (secndpass == firstpass) {
        strength = "Matched";
        color = "green";
    } else {
        strength = "UnMatched";
        color = "red";
    }
    spn_secpassword.innerHTML = strength;
    spn_secpassword.style.color = color;
}

///validetion given to the textbox
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

function HourlyCharges() {
    var Compid = $("[id*=hdnCompanyid]").val();
    var desig = $("[id*=drpdesig]").val();
    if (desig == 0) {
        $("[id*=txthourcharge]").val(0);
        return
    }
    $.ajax({
        type: "POST",
        url: "../Handler/ws_Dashboard.asmx/HorlyChargeStaff",
        data: '{compid:' + Compid + ', desig:' + desig + '}',
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            var myList = jQuery.parseJSON(msg.d);
            if (myList[0].Jobid > 0) {
                $("[id*=txthourcharge]").val(myList[0].Jobid);
            } else {

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

function GetAlldropdown() {
    var compid = $("[id*=hdnCompanyid]").val();
    $.ajax({
        type: "POST",
        url: "../Handler/WS_StaffDetails.asmx/GetAlldropdown",
        data: '{compid:' + compid + '}',
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            //var myList = jQuery.parseJSON(msg.d);
            main_obj = jQuery.parseJSON(msg.d);
            main_obj = main_obj[0];

            var myList = main_obj.list_BranchMaster;
            var brList = main_obj.list_DepartmentMaster;
            var depList = main_obj.list_DesignationMaster; 
            var roleList = main_obj.list_RoleMaster;   //
            var stff = main_obj.list_staffroleid;


            if (myList.length == 0 || roleList.length == 0 || brList.length == 0 || depList.length == 0 || stff.length == 0) {
                alert('Update Role, Designation, Branch, Department, Staffrole  Masters');
                $("[id*=btnStaffAdd]").attr("disabled", true);
                return;
            }

            ///Branch

            $("[id*=drpbranch]").empty();
            $("[id*=drpbranch]").append("<option value=0>--Select--</option>");

            for (var i = 0; i < main_obj.list_BranchMaster.length; i++) {

                $("[id*=drpbranch]").append("<option value='" + myList[i].BrId + "'>" + myList[i].BranchName + "</option>");
            }
            ////Department

            $("[id*=drpdep]").empty();
            $("[id*=drpdep]").append("<option value=0>--Select--</option>");

            for (var i = 0; i < main_obj.list_DepartmentMaster.length; i++) {

                $("[id*=drpdep]").append("<option value='" + brList[i].DepId + "'>" + brList[i].DepartmentName + "</option>");
            }
            ////Designation

            $("[id*=drpdesig]").empty();
            $("[id*=drpdesig]").append("<option value=0>--Select--</option>");

            for (var i = 0; i < main_obj.list_DesignationMaster.length; i++) {

                $("[id*=drpdesig]").append("<option value='" + depList[i].DsgId + "'>" + depList[i].DesignationName + "</option>");
            }

            ////Staff Role

            $("[id*=ddlsroll]").empty();
            $("[id*=ddlsroll]").append("<option value=0>--Select--</option>");

            for (var i = 0; i < main_obj.list_RoleMaster.length; i++) {

                $("[id*=ddlsroll]").append("<option value='" + roleList[i].sRoleID + "'>" + roleList[i].sRoleName + "</option>");
            }


            if (stff.length > 0) {
                $("[id*=ddlsroll]").val(stff[0].staffroleid);
                $("[id*=hdnStaffrole]").val(stff[0].staffroleid);
            }

            GetStaffRecord(1, 25);

            $('.loader').hide();
        },
        failure: function (response) {

        },
        error: function (response) {

        }
    });
}

function GetStaffRecord(pageIndex, Pagesize) {
    var compid = $("[id*=hdnCompanyid]").val();
    var Srch = $("[id*=txtsrchjob]").val();

    $.ajax({
        type: "POST",
        url: "../Handler/WS_StaffDetails.asmx/GetStaffRecord",
        data: '{compid:' + compid + ',Srch:"' + Srch + '",pageIndex:' + pageIndex + ',pageSize:' + Pagesize + '}',
        dataType: 'json',
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            var myList = jQuery.parseJSON(msg.d);
            var RecordCount = 0;
            var tbl = '';
            $("[id*=tblStaff] tbody").empty();

            tbl = tbl + "<tr>";
            tbl = tbl + "<th class='labelChange' style='text-align: center;'>Sr.No</th>";
            tbl = tbl + "<th class='labelChange'>Staff Name</th>";
            tbl = tbl + "<th class='labelChange'>Designation</th>";
            tbl = tbl + "<th class='labelChange'>Department</th>";
            tbl = tbl + "<th class='labelChange'>Hrs. Chrg.</th>";
            tbl = tbl + "<th class='labelChange'>Contract Wrks</th>";
            tbl = tbl + "<th class='labelChange'>EmpId.</th>";
            tbl = tbl + "<th class='labelChange'>Phone</th>";
            tbl = tbl + "<th >Edit</th>";
            tbl = tbl + "<th >Delete</th>";
            tbl = tbl + "</tr>";

            if (myList.length > 0) {
                var StaffLimit = myList[0].list_stafflimit;
                var sc = myList.length;

                for (var i = 0; i < myList.length; i++) {
                    tbl = tbl + "<tr>";
                    tbl = tbl + "<td style='text-align: center;'>" + myList[i].srno + "<input type='hidden' id='hdntempid' value='" + myList[i].Staffcode + "' name='hdntempid'></td>";
                    tbl = tbl + "<td style='text-align: left;'>" + myList[i].StaffName + "</td>";
                    tbl = tbl + "<td style='text-align: left;'>" + myList[i].Desig + "</td>";
                    tbl = tbl + "<td style='text-align: left;'>" + myList[i].Dept + "</td>";
                    tbl = tbl + "<td style='text-align: center;'>" + myList[i].HrsCharg + "</td>";
                    tbl = tbl + "<td style='text-align: left;'>" + myList[i].Contractwork + "</td>";
                    tbl = tbl + "<td style='text-align: center;'>" + myList[i].Empid + "</td>";
                    tbl = tbl + "<td style='text-align: center;'>" + myList[i].Phone + "</td>";
                    tbl = tbl + "<td style='text-align: center;'><img src='../images/edit.png' style='cursor:pointer; height:18px; width:18px;' onclick='Edit_Show($(this))' id='stfEdit' name='stfEdit'></td>";
                    tbl = tbl + "<td style='text-align: center;'><img src='../images/delete.png' style='cursor:pointer; height:18px; width:18px;' onclick='Delete_Temp($(this))' id='stfDel' name='stfDel'></td></tr>";
                };
                $("[id*=tblStaff]").append(tbl);

                $("[id*=Label1]").html('Manage Staff (' + sc + '/' + myList[0].Totalcount + ')');
                $("[id*=hdnStaffLimit]").val(StaffLimit[0].Stafflimit);
                $("[id*=hdnCntSft]").val(myList[0].Totalcount);
                if (parseFloat(myList[0].Totalcount) > 0) {
                    RecordCount = parseFloat(myList[0].Totalcount);

                }
                Pager(RecordCount);
            }

            else {
                tbl = tbl + "<tr>";

                tbl = tbl + "<td ></td>";
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
                $("[id*=tblStaff]").append(tbl);
                $("[id*=hdnStaffLimit]").val('2');
            }

            $('.loader').hide();
        },
        failure: function (response) {

        },
        error: function (response) {

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

        GetStaffRecord(($(this).attr('page')), 25)
    });
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function BindHrlyGrd() {

    Stf = $("[id*=hdnoldStaffcode]").val();

    //Ajax start
    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: "Managestaff.aspx/bindHourlyGrd",
        data: "{staff:" + Stf + ",compid:" + $("[id*=hdnCompanyid]").val() + "}",
        dataType: "json",
        success: function (msg) {

            var myList = jQuery.parseJSON(msg.d);


            var trhrly = $("[id*=tblhrlyCharges] tbody tr:last-child").clone(true);
            $("[id*=tblhrlyCharges] tbody").remove();
            for (var i = 0; i < myList.length; i++) {

                $("td", trhrly).eq(0).html((parseFloat(i) + 1) + "<input type='hidden' value='" + myList[i].HrlyID + "' name='hdnhid'>"); ///////sr no
                $("td", trhrly).eq(1).html(myList[i].frDate); ///staff name
                if (myList[0].toDate == "0") {
                    $("td", trhrly).eq(2).html("");
                }
                else {
                    $("td", trhrly).eq(2).html(myList[i].toDate); ///////////department
                }
                $("td", trhrly).eq(3).html(myList[i].HCharges); ////////Designation
                $("td", trhrly).eq(4).html("<img src='../images/edit.png' style='cursor:pointer; height:18px; width:18px;' id='btnHEdit' name='btnEdit'>");
                $("td", trhrly).eq(5).html("<img src='../images/delete.png' style='cursor:pointer; height:18px; width:18px;' id='btnHDel' name='btnDel'>");

                $("[id*=tblhrlyCharges]").append(trhrly);
                trhrly = $("[id*=tblhrlyCharges] tbody tr:last-child").clone(true);
            }

        },
        failure: function (response) {

        },
        error: function (response) {

        }
    });
    //Ajax end

}

function RecordDelete() {
    var hid = $("[id*=hdncode]").val();

    //Ajax start
    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: "Managestaff.aspx/DeleteCharges",
        data: "{hid:" + hid + ",compid:" + $("[id*=hdnCompanyid]").val() + "}",
        dataType: "json",
        success: function (msg) {
            var myList = jQuery.parseJSON(msg.d);
            var h = myList[0].HrlyID;
            if (parseFloat(h) > 0) {
                alert("Cannot delete, timesheet exist for this date range");
            }
            else {
                BindHrlyGrd();
                alert("Record deleted successfuly ");

            }

        },
        failure: function (response) {
            alert("Cannot delete, timesheet exist for this date range");
        },
        error: function (response) {
            alert("delete failed ");
        }
    });
    //Ajax end
}






</script>


<div id="divtotbody" class="testwhleinside">
    <%--<div id="div10" class="testwhleinside" onclick="HideMenu('contextMenu');" oncontextmenu="return false">--%>
    <div id="divtitl" class="totbodycatreg">
        <%--<asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <Triggers>
                <asp:PostBackTrigger ControlID="BtnExport" />
            </Triggers>
            <ContentTemplate>--%>
        <div>
            <div>
                <table style="width: 100%" class="cssPageTitle">
                    <tr>
                        <td class="cssPageTitle2">
                            <asp:Label ID="Label1" runat="server" Style="margin-left: 0px;" Text="Manage Staff"></asp:Label>
                        </td>
                        <td style="text-align: end;">
                            <div id="editsavedv">
                                <input id="btnSave" type="button" class="cssButton labelChange" value="Save" />
                                <input id="btnCancel" type="button" class="cssButton labelChange" value="Cancel" />
                            </div>
                        </td>
                    </tr>
                </table>

            </div>
        </div>
        <div style="float: left; width: 100%; padding-left: 10px" align="left">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
            <asp:HiddenField ID="hdnDT" runat="server" />
            <asp:HiddenField ID="hdnCntSft" runat="server" />
            <asp:HiddenField ID="hdnCompanyid" runat="server" />
            <asp:HiddenField ID="hdnStfcode" runat="server" />
            <asp:HiddenField ID="hdnLeft" runat="server" />
            <asp:HiddenField ID="hdnTop" runat="server" />
            <asp:HiddenField ID="hidpermitionID" runat="server" Value="0" />
            <asp:HiddenField ID="hdnStaffLimit" runat="server" />
            <asp:HiddenField ID="hdnPages" runat="server" />
            <asp:HiddenField ID="hdnStaffrole" runat="server" Value="0" />
            <asp:HiddenField ID="hdnnewStaffcode" runat="server" Value="0" />
            <asp:HiddenField ID="hdnoldStaffcode" runat="server" Value="0" />
        </div>

        <div id="dvsrch" style="width: 100%; overflow: hidden; padding-top: 5px;">
            <%--<asp:Panel ID="Panel5" runat="server" DefaultButton="btnsrchjob">--%>
            <div id="divBtn" style="display: none;">
               <%-- <asp:Button ID="btnpage" runat="server" Text="Edit" OnClick="btnpage_Click"></asp:Button>--%>
                <asp:Button ID="btnmember" runat="server" Text="Member" OnClick="btnmember_Click"></asp:Button>
            </div>

            <div style="float: left; padding-left: 1px">
                <div id="searchjob" runat="server" style="float: left; width: 100%; margin: 10px; padding-bottom: 5px; overflow: auto;">
                    <div class="serachJob" style="float: left;">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="Label21" runat="server" Text="Search Staff" CssClass="labelChange"></asp:Label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <%--<asp:TextBox ID="txtsrchjob" runat="server" CssClass="txtbox" Width="128px"></asp:TextBox>--%>
                                    <input type="text" id="txtsrchjob" onkeyup="CountFrmTitle(this,50);" name="txtsrchjob" class="texboxcls" style="width: 128px;" />
                                </td>
                                <td>

                                    <input id="btnsrchjob" runat="server" class="cssButton" value="Search" type="button" />
                                </td>
                                <td><a href="../Company/Staff.aspx">
                                    <input id="BtnStf" type="button" runat="server" value="Left Staff" class="cssButton labelChange" />
                                </a>

                                </td>
                                <td>
                                    <input id="btnStaffAdd" type="button" runat="server" value="Add Staff" class="cssButton labelChange" />

                                </td>
                                <td>
                                    <asp:ImageButton ID="BtnExport" runat="server" ImageUrl="~/Images/xls-icon.png" OnClick="BtnExport_Click" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <%--</asp:Panel>--%>
        </div>
        <div style="overflow: hidden; padding-bottom: 10px; width: 100%; float: left; padding-top: 5px;">
            <asp:HiddenField ID="hdnhchargepermission" runat="server" />
            <asp:HiddenField ID="hdnChangePasspermission" runat="server" />
            <asp:HiddenField ID="hdnrolepermission" runat="server" />
            <asp:HiddenField ID="hdnJOBpermission" runat="server" />
            <asp:HiddenField ID="hdnLOBpermission" runat="server" />
            <asp:HiddenField ID="hdnOtherDetailpermission" runat="server" />
        </div>
        <%--            </ContentTemplate>
        </asp:UpdatePanel>--%>
    </div>
    <div id="dvStaff">
        <table id="tblStaff" width="1175px" border="1px" class="norecordTble allTimeSheettle" style="border-collapse: collapse;">
        </table>
        <table id="tblPager" style="border: 1px solid #BCBCBC; border-bottom: none; background-color: rgba(219,219,219,0.54); text-align: right;"
            cellpadding="2" cellspacing="0" width="1195px">
            <tr>
                <td>
                    <div class="Pager">
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div id="griddiv" class="totbodycatreg">
    </div>
    <div id="Div20" class="comprw">
        <cc1:ModalPopupExtender runat="server" ID="ModalPopupExtender1" BehaviorID="mailingListModalPopupBehavior"
            TargetControlID="hiddenLargeImage" PopupControlID="panelupgrade" BackgroundCssClass="modalBackground"
            OkControlID="imgClose" DropShadow="false" RepositionMode="RepositionOnWindowScroll">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="panelupgrade" runat="server" Width="425px" Height="300px" BackColor="#FFFFFF">
            <asp:Button ID="hiddenLargeImage" runat="server" Style="display: none" />
            <div id="Div59" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff; font-weight: bold;">
                <div id="Div23" style="width: 90%; float: left; height: 20px; padding-left: 2%; padding-top: 10px">
                    <label class="subHead1">Edit Details</label>
                    <%--<asp:Label ID="Label15" runat="server" Text="Edit Details" CssClass="subHead1"></asp:Label>--%>
                </div>
                <div id="Div60" style="width: 8%; float: left; padding-top: 1%; text-align: right;">
                    <img src="../images/error.png" alt="image" id="imgClose" border="0" name="imgClose" />
                </div>
            </div>
            <div id="Hrly" style="width: 450px; float: left; overflow: hidden; padding-top: 5px; padding-bottom: 5px;">
                <div style="width: 409px; float: left; overflow: hidden; height: 15px; padding-top: 5px; padding-bottom: 5px;">
                    <div id="Div17" style="width: 425px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 50px;">
                        Staff Name:
                        <asp:Label ID="lblstfname" runat="server"></asp:Label>
                    </div>
                    <div id="Div18" style="width: 56px; float: left; overflow: hidden; font-weight: bold; height: 15px;">
                        <asp:HiddenField ID="hdncode" runat="server"></asp:HiddenField>
                    </div>
                    <div id="Div19" style="width: 250px; float: left; overflow: hidden; font-weight: bold;">
                    </div>
                </div>
                <table>
                    <tr>
                        <td>
                            <asp:Label ID="lblmsg" runat="server" ForeColor="#FF3300" Visible="False"></asp:Label>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                    </tr>
                    <tr>
                        <td>
                            <table>
                                <tr>
                                    <td style="width: 30px; padding-left: 10px;">
                                        <div style="width: 30px;">
                                            <asp:Label ID="Label53" runat="server" Text="From"></asp:Label>
                                        </div>
                                    </td>
                                    <td style="width: 120px">
                                        <span style="float: left;">
                                            <asp:TextBox ID="txtfromdate" runat="server" CssClass="texboxcls" Width="70px"></asp:TextBox>
                                        </span>
                                        <div style="position: relative; float: left;">
                                            <asp:Image ID="Image3" runat="server" ImageUrl="~/images/calendar.png" />
                                        </div>
                                        <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtfromdate"
                                            PopupButtonID="Image3" Format="dd/MM/yyyy" Enabled="True">
                                        </cc1:CalendarExtender>

                                    </td>
                                    <td style="width: 100px;">
                                        <div style="width: 100px;">
                                            <asp:Label ID="Label55" runat="server" Text="Hourly Charges"></asp:Label>
                                        </div>
                                    </td>
                                    <td style="width: 70px;">
                                        <div style="width: 70px;">
                                            <asp:TextBox ID="txthourlycharges" runat="server" Width="50px" CssClass="txtnrml"></asp:TextBox>
                                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender14" runat="server" TargetControlID="txthourlycharges"
                                                ValidChars="1234567890.">
                                            </cc1:FilteredTextBoxExtender>
                                        </div>
                                    </td>
                                    <td>
                                        <input type="button" id="btnAdd" value="Save" class="cssButton" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td class="style4" style="display: none">
                            <asp:Label ID="Label54" runat="server" Text="To"></asp:Label>
                        </td>
                        <td class="style10" style="display: none">
                            <asp:TextBox ID="txttodate" runat="server" CssClass="txtnrml" Width="70px" AutoPostBack="True"></asp:TextBox>
                            <cc1:CalendarExtender ID="txttodate_CalendarExtender" runat="server" Format="dd/MM/yyyy"
                                PopupButtonID="Image20" TargetControlID="txttodate">
                            </cc1:CalendarExtender>
                            <asp:Image ID="Image20" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" />
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ValidationGroup="g"
                                ControlToValidate="txttodate" Display="None" ErrorMessage="<b>Enter date in dd/MM/yyyy Format"
                                ValidationExpression="^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d$">*</asp:RegularExpressionValidator>
                            <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender3" runat="server" HighlightCssClass="validatorCalloutHighlight"
                                TargetControlID="RegularExpressionValidator1">
                            </cc1:ValidatorCalloutExtender>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 0px 0px 0px 225px;" colspan="6" class="style2">&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 0px 0px 0px 10px;">
                            <div style="height: 270px; margin-right: 0px;">
                                <div id="Div15">
                                    <%--                                    <div class="loader2">
                                            Please Wait.....
                                        </div>--%>
                                </div>
                                <asp:Panel ID="hrlyPnl" runat="server" Width="400px" Height="150px" ScrollBars="Auto">
                                    <table cellspacing="0" class="norecordTble" border="1" id="tblhrlyCharges" style="border-collapse: collapse; width: 382px;">
                                        <thead>
                                            <tr>
                                                <th class="grdheader">Sr
                                                </th>
                                                <th class="grdheader">From Date
                                                </th>
                                                <th class="grdheader">To Date
                                                </th>
                                                <th class="grdheader">Hourly Charges
                                                </th>
                                                <th class="grdheader">Edit
                                                </th>
                                                <th class="grdheader">Delete
                                                </th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr style="color: rgb(0, 0, 102); height: 15px;">
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                                <td align="right" style="width: 60px;"></td>
                                                <td align="center"></td>
                                                <td align="center"></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </asp:Panel>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 0px 0px 0px 225px;" colspan="6" class="style2">&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                    </tr>
                    <tr>
                        <td class="style2" colspan="6" style="padding: 0px 0px 0px 150px;"></td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <%-- <cc1:ModalPopupExtender runat="server" ID="ModalPopup2" BehaviorID="ListModalPopupBehavior"
            TargetControlID="hdnLargeImage" PopupControlID="panel1" BackgroundCssClass="modalBackground"
            OkControlID="Close2" DropShadow="false" RepositionMode="RepositionOnWindowScroll">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="panel1" runat="server" Width="300px" Height="250px" BackColor="#FFFFFF">
            <asp:Button ID="hdnLargeImage" runat="server" Style="display: none" />
            <div id="Div3" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff; font-weight: bold;">
                <div id="Div7" style="width: 88%; float: left; height: 20px; padding-left: 2%; padding-top: 10px">
                    <asp:Label ID="Label7" runat="server" Text="Edit Details" CssClass="subHead1"></asp:Label>
                </div>
                <div id="Div8" style="width: 8%; float: left; padding-top: 1%; text-align: right;">
                    <img src="../images/error.png" id="Close2" border="0" name="Close2" />
                </div>
            </div>
            <div id="Jn" style="width: 250px; float: left; overflow: hidden; padding-top: 20px; padding-bottom: 5px; display: none;">
                <div id="Div9" style="width: 250px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 40px;">
                    <label class="labelChange">Staff Name:</label>
                    <asp:Label ID="lbljStaff" runat="server"></asp:Label>
                </div>
                <div id="Div2" style="width: 250px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 50px;">
                    <asp:Label ID="Label4" Text="Joining Date:" runat="server"></asp:Label>
                    <asp:TextBox ID="TxtJDate" runat="server" CssClass="txtnrml" Width="70px" AutoPostBack="True"
                        CausesValidation="true" ValidationGroup="g"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd/MM/yyyy" PopupButtonID="ImgJn"
                        TargetControlID="TxtJDate">
                    </cc1:CalendarExtender>
                    <asp:Image ID="ImgJn" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ValidationGroup="g"
                        ControlToValidate="TxtJDate" Display="None" ErrorMessage="<b>RequiredField<br/>Please Enter Date</b>">*</asp:RequiredFieldValidator>
                    <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender2" runat="server" HighlightCssClass="validatorCalloutHighlight"
                        TargetControlID="RequiredFieldValidator2">
                    </cc1:ValidatorCalloutExtender>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ValidationGroup="g"
                        ControlToValidate="TxtJDate" Display="None" ErrorMessage="<b>Enter Date in dd/MM/yyyy format"
                        ValidationExpression="^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d$">*</asp:RegularExpressionValidator>
                </div>
                <div id="Div4" align="center" style="width: 280px; float: left; overflow: hidden; font-weight: bold;">
                    <input id="BtnJn" value="Save" class="cssButton" type="button" />
                </div>
            </div>
            <div id="Ln" style="width: 250px; float: left; overflow: hidden; padding-top: 20px; padding-bottom: 5px; display: none;">
                <div id="Div10" style="width: 250px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 40px;">
                    <label class="labelChange">
                        Staff Name:</label>
                    <asp:Label ID="lblRStaff" runat="server"></asp:Label>
                </div>
                <div id="Div5" style="width: 250px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 40px;">
                    <asp:Label ID="Label5" Text="Leaving Date:" runat="server"></asp:Label>
                    <asp:TextBox ID="TxtLNDate" runat="server" CssClass="txtnrml" Width="70px" AutoPostBack="True"
                        CausesValidation="true" ValidationGroup="g"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender2" runat="server" Format="dd/MM/yyyy" PopupButtonID="ImgLn"
                        TargetControlID="TxtLNDate">
                    </cc1:CalendarExtender>
                    <asp:Image ID="ImgLn" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ValidationGroup="g"
                        ControlToValidate="TxtLNDate" Display="None" ErrorMessage="<b>RequiredField<br/>Please Enter Date</b>">*</asp:RequiredFieldValidator>
                    <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender5" runat="server" HighlightCssClass="validatorCalloutHighlight"
                        TargetControlID="RequiredFieldValidator1">
                    </cc1:ValidatorCalloutExtender>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ValidationGroup="g"
                        ControlToValidate="TxtLNDate" Display="None" ErrorMessage="<b>Enter Date in dd/MM/yyyy format"
                        ValidationExpression="^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d$">*</asp:RegularExpressionValidator>
                    <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender6" runat="server" HighlightCssClass="validatorCalloutHighlight"
                        TargetControlID="RegularExpressionValidator3">
                    </cc1:ValidatorCalloutExtender>
                </div>
                <div id="Div6" align="center" style="width: 280px; float: left; overflow: hidden; font-weight: bold;">
                    <input id="BtnLN" value="Save" class="cssButton" type="button" />
                </div>
            </div>
            <div id="pass" style="width: 280px; float: left; overflow: hidden; padding-top: 20px; padding-bottom: 5px; display: none;">
                <div id="Div12" style="width: 270px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 40px;">
                    <label class="labelChange">
                        Staff Name:</label>
                    <asp:Label ID="lblPass" runat="server"></asp:Label>
                    <asp:HiddenField ID="hdnUid" runat="server"></asp:HiddenField>
                </div>
                <div id="divuser" style="width: 270px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 40px;">
                    <label class="labelChange">
                        UserName:</label>
                    <asp:Label ID="lbluserName" runat="server"></asp:Label>
                    <asp:HiddenField ID="hdnuserid" runat="server"></asp:HiddenField>
                </div>
                <div id="Div13" style="width: 270px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 50px;">
                    <asp:Label ID="Label9" Text="Change Password:" runat="server"></asp:Label>
                    <asp:TextBox ID="TxtPass" runat="server" CssClass="txtnrml" Width="100px"></asp:TextBox>
                    <span id="password_strength"></span>
                </div>
                <div id="Div14" align="center" style="width: 280px; float: left; overflow: hidden; font-weight: bold;">
                    <input id="BtnPass" value="Save" class="cssButton" type="button" />
                </div>
            </div>
            <div id="roll" style="width: 280px; float: left; overflow: hidden; padding-top: 20px; padding-bottom: 5px; display: none;">
                <div id="Div16" style="width: 270px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 40px;">
                    <label class="labelChange">
                        Staff Name:</label>
                    <asp:Label ID="lblstfroll" runat="server"></asp:Label>
                    <asp:HiddenField ID="hdnRid" runat="server"></asp:HiddenField>
                </div>
                <div id="Div21" style="width: 270px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 50px;">
                    <asp:Label ID="Label10" Text="Select Role" runat="server"></asp:Label>
                    <asp:DropDownList ID="ddlroll" runat="server">
                    </asp:DropDownList>
                </div>
                <div id="Div22" align="center" style="width: 280px; float: left; overflow: hidden; font-weight: bold;">
                    <input id="btnroll" value="Save" class="cssButton TbleBtnsPading" type="button" />
                </div>
            </div>
        </asp:Panel>--%>
    </div>

    <div id="dvEdit">
        <div style="height: 23px">
        </div>
        <table>
            <tr>
                <td style="width: 10px;"></td>
                <td style="width: 150px;">
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Staff Name</label></td>
                <td style="width: 300px;">
                    <input type="text" id="txtstaffname" name="txtstaffname" class="texboxcls" onkeyup="CountFrmTitle(this,70);" style="width: 230px;" />
                    <label style="font-weight: bold; color: red;" class="LabelFontStyle labelChange">*</label>
                </td>

                <td style="width: 130px;">
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Email</label></td>
                <td style="width: 300px;">
                    <asp:TextBox ID="txtemail" runat="server" CssClass="texboxcls" Width="230px"></asp:TextBox>
                    <%--<input type="text" id="txtemail" name="txtemail" class="texboxcls" style="width: 250px;" />--%>
                    <label style="font-weight: bold; color: red;" class="LabelFontStyle labelChange">*</label>
                </td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Mobile No.</label></td>
                <td>
                    <input type="text" id="txtmob" name="txtmob" onkeyup="return  ValidateText(this);" class="texboxcls" style="width: 120px;" /></td>
            </tr>
            <tr>
                <td colspan="5" style="height: 7px;"></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Flat No.</label></td>
                <td>
                    <input type="text" id="txtaddress1" name="txtaddress1" class="texboxcls" onkeyup="CountFrmTitle(this,50);" style="width: 230px;" /></td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Bldg Name</label></td>
                <td>
                    <input type="text" id="txtaddress2" name="txtaddress2" class="texboxcls" onkeyup="CountFrmTitle(this,50);" style="width: 230px;" /></td>
              
            </tr>
            <tr>
                <td colspan="5" style="height: 7px;"></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Street</label></td>
                <td>
                    <input type="text" id="txtaddress3" name="txtaddress3" onkeyup="CountFrmTitle(this,50);" class="texboxcls" style="width: 230px;" /></td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">City</label></td>
                <td>
                    <input type="text" id="txtcity" name="txtcity" onkeyup="CountFrmTitle(this,20);" class="texboxcls" style="width: 230px;" /></td>
           
            </tr>

            <tr>
                <td colspan="5" style="height: 7px;"></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Department</label></td>
                <td>
                    <select id="drpdep" name="drpdep" runat="server" class="DropDown" style="width: 240px; height: 25px;">
                        <option value="0">--Select--</option>
                    </select>
                    <label style="font-weight: bold; color: red;" class="LabelFontStyle labelChange">*</label>
                </td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Designation</label></td>
                <td>
                    <select id="drpdesig" name="drpdesig" runat="server" class="DropDown" style="width: 240px; height: 25px;">
                        <option value="0">--Select--</option>
                    </select>
                    <label style="font-weight: bold; color: red;" class="LabelFontStyle labelChange">*</label>
                </td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Branch</label></td>
                <td>
                    <select id="drpbranch" name="drpbranch" runat="server" class="DropDown" style="width: 130px; height: 25px;">
                        <option value="0">--Select--</option>
                    </select></td>
            </tr>
            <tr>
                <td colspan="5" style="height: 7px;"></td>
            </tr>
            <tr>
                <td></td>

                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Hourly Charges</label></td>
                <td>
                    <input type="text" id="txthourcharge" name="txthourcharge" class="texboxcls" style="width: 230px;" />
                    <label style="font-weight: bold; color: red;" class="LabelFontStyle labelChange">*</label>
                </td>
                <td>
                    <input id="btnedithourly" name="btnedithourly" type="button" class="cssButton labelChange" value="Edit Hourly Charges" />
                </td>
            </tr>
            <tr>
                <td colspan="5" style="height: 7px;"></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Date Of Joining</label></td>
                <td style="width: 107px">
                    <span style="float: left;">
                        <asp:TextBox ID="txtjoindate" runat="server" CssClass="texboxcls" Width="70px"></asp:TextBox>
                    </span>
                    <div style="position: relative; float: left;">
                        <asp:Image ID="Image2" runat="server" ImageUrl="~/images/calendar.png" />
                    </div>
                    <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtjoindate"
                        PopupButtonID="Image2" Format="dd/MM/yyyy" Enabled="True">
                    </cc1:CalendarExtender>
                    <label style="font-weight: bold; color: red;" class="LabelFontStyle labelChange">*</label>
                </td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Date of Leaving</label>
                </td>
                <td style="width: 107px">
                    <span style="float: left;">
                        <asp:TextBox ID="txtenddate" runat="server" CssClass="texboxcls" Width="70px"></asp:TextBox>
                    </span>
                    <div style="position: relative; float: left;">
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/calendar.png" />
                    </div>
                    <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtenddate"
                        PopupButtonID="Image1" Format="dd/MM/yyyy" Enabled="True">
                    </cc1:CalendarExtender>
                </td>
                     <td id="tdstfrol1">
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Staff Role</label></td>
                <td id="tdstfrol2">
                    <select id="ddlsroll" name="ddlsroll" runat="server" class="DropDown" style="width: 130px; height: 25px;">
                        <option value="0">--Select--</option>
                    </select>
                    <label style="font-weight: bold; color: red;" class="LabelFontStyle labelChange">*</label>
                </td>
            </tr>

            <tr>
                <td colspan="5" style="height: 7px;"></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Employeement Type</label></td>
                <td>
                    <select id="drpEType" name="drpEType" runat="server" class="DropDown" style="width: 240px; height: 25px;">
                        <option value="Permanent">Permanent</option>
                        <option value="Contract">Contract</option>
                    </select></td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Qualification</label></td>
                <td>
                    <input type="text" id="TxtQ" name="TxtQ" onkeyup="CountFrmTitle(this,30);" class="texboxcls" style="width: 230px;" /></td>
              <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Emp ID</label></td>
                <td>
                    <input type="text" id="txtstaffThumbLoginID" name="txtstaffThumbLoginID" onkeyup="CountFrmTitle(this,30);" class="texboxcls" style="width: 120px;" /></td>
            </tr>
            <tr>
                <td colspan="5" style="height: 7px;"></td>
            </tr>

            <tr>
                <td></td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">User Name</label></td>
                <td>
                    <asp:TextBox ID="txtusrname" runat="server" CssClass="texboxcls" Width="230px"></asp:TextBox>
                    <%--<input type="text" id="txtusrname" name="txtusrname" class="texboxcls" style="width: 250px;" />--%>
                    <label style="font-weight: bold; color: red;" class="LabelFontStyle labelChange">*</label>
                </td>

            </tr>
            <tr>
                <td colspan="5" style="height: 7px;"></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Password</label></td>
                <td>
                    <input type="password" id="txtpassword" name="txtpassword" onkeyup="CheckPasswordStrength1(this.value);" class="texboxcls" style="width: 230px;" />
                    <label style="font-weight: bold; color: red;" class="LabelFontStyle labelChange">*</label>
                    <%--<div class="txtboxNewError"><span class="labelstyle">Password minimum 8 character with alphanumeric (such as @,A, and !, for example).</span></div>--%>
                    <span id="password_strength1"></span>
                </td>

            </tr>
            <tr>
                <td colspan="5" style="height: 7px;"></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <label style="font-weight: bold" class="LabelFontStyle labelChange">Confirm Password</label></td>
                <td>
                    <asp:TextBox ID="txtConfirm" runat="server" CssClass="texboxcls" 
                        Width="230px"></asp:TextBox>
                    <%--<input type="text" id="txtConfirm" name="txtConfirm" class="texboxcls" onkeyup="passwordmatch();" style="width: 250px;" />--%>
                    <label style="font-weight: bold; color: red;" class="LabelFontStyle labelChange">*</label>
                    <span id="spn_secpassword"></span>
                </td>

            </tr>
        </table>

    </div>
</div>
