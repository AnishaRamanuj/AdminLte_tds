<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Managestaff.ascx.cs" Inherits="controls_Managestaff" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<script src="../jquery/dist/jquery.contextMenu.js" type="text/javascript"></script>
<link href="../jquery/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<style type="text/css">
    .active_pager {
        line-height: 20px;
        display: inline-block;
        text-align: center;
        text-decoration: none;
        background-color: #26B;
        color: #fff;
        border: solid 1px #AAE;
        padding: 2px;
    }

    .pager {
        padding: 2px;
        line-height: 20px;
        display: inline-block;
        text-align: center;
        text-decoration: none;
        border-color: #999;
        color: #999;
        background: #fff;
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
</style>
<script language="javascript" type="text/javascript">

    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });

        var newDate = new Date();
        $("[id*=hdnDT]").val(newDate);

        $("[id*= lblfrname]").on('click', function () {
            $("[id*=txtfromdate]").val('');
            $("[id*=txthourlycharges]").val('');
            $("[id*=lblmsg]").html('');
            var sftrow = $(this).closest("tr");
            var Stf = sftrow.find("input[type=hidden]").val();
            $("[id*=hdnStfcode]").val('0');
            $("[id*=hdncode]").val('0');
            $("[id*=lblstfname]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html());
            $("[id*=hdnStfcode]").val(Stf);
            $("[id*=lbljStaff]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html());
            $("[id*=lblRStaff]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html());
            $("[id*=lblPass]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html());
            $("[id*=lbluserName]").html($("[id*=hdnuName]", $(this).closest("tr")).val());
            $("[id*=lblstfroll]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html());
            var t = $(this).position();
            openmenu(t.top, t.left);
        });

        $("[id*= btnEdit]").on('click', function () {
            $("[id*=txtfromdate]").val('');
            $("[id*=txthourlycharges]").val('');
            $("[id*=lblmsg]").html('');
            var sftrow = $(this).closest("tr");
            var Stf = sftrow.find("input[type=hidden]").val();
            $("[id*=hdnStfcode]").val('0');
            $("[id*=hdncode]").val('0');
            $("[id*=lblstfname]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html());
            $("[id*=hdnStfcode]").val(Stf);
            $("[id*=lbljStaff]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html());
            $("[id*=lblRStaff]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html());
            $("[id*=lblPass]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html());
            $("[id*=lbluserName]").html($("[id*=hdnuName]", $(this).closest("tr")).val()); //change by anil gajre 28/04/2017
            $("[id*=lblstfroll]").html($("td", $(this).closest("tr")).eq(1).find("[id*=lblfrname]").html());
            var t = $(this).position();
            openmenu(t.top, t.left);
        });

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
            var Stf = $("[id*=hdnStfcode]").val();
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
                            window.location.href = "ManageStaff.aspx"

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



        // Leaving Date Insert
        $("[id*= BtnLN]").live('click', function () {
            var LDt = $("[id*=TxtLNDate]").val();
            var Stf = $("[id*=hdnStfcode]").val();
            if (LDt == "") {
                alert("Resign Date Not entered");
                return;
            }

            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Managestaff.aspx/InsertLeaving",
                data: '{staff:' + Stf + ',compid:' + $("[id*=hdnCompanyid]").val() + ', LDt:"' + LDt + '"}',
                dataType: "json",
                success: function (msg) {

                    if (msg.d.length > 0) {

                        if (msg.d[0].Errmsg == "Resign Date Successfully Updated") {
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


        // Password Change
        $("[id*= BtnPass]").live('click', function () {
            var Pass = $("[id*=TxtPass]").val();
            var Stf = $("[id*=hdnStfcode]").val();
            var Uid = $("[id*=hdnUid]").val();
            if (Pass == "") {
                alert("Password Not entered");
                return;
            }

            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Managestaff.aspx/insertPassword",
                data: '{staff:' + Stf + ',compid:' + $("[id*=hdnCompanyid]").val() + ', Uid:"' + Uid + '", Pass:"' + Pass + '"}',
                dataType: "json",
                success: function (msg) {

                    if (msg.d.length > 0) {

                        if (msg.d[0].Errmsg == "New Password Successfully Updated") {
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

        //select Rolls
        $("[id*=btnroll]").live('click', function () {
            var roll = $("[id*=ddlroll]").val();
            var Stf = $("[id*=hdnStfcode]").val();
            var Uid = $("[id*=hdnUid]").val();
            if (roll == "0") {
                alert("Please Select The Role");
                return;
            }
            //Ajax Start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Managestaff.aspx/manageRoll",
                data: '{staff:' + Stf + ',compid:' + $("[id*=hdnCompanyid]").val() + ', Uid:"' + Uid + '", roll:"' + roll + '"}',
                dataType: "json",
                success: function (msg) {

                    if (msg.d.length > 0) {

                        if (msg.d[0].Errmsg == "Staff Role Selected Successfully") {
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

        });


        $("#btnHEdit").live('click', function () {
            var row = $(this).closest("tr");
            var hid = row.find("input[type=hidden]").val();

            $("[id*=hdncode]").val(hid);
            document.getElementById('<%=txtfromdate.ClientID %>').value = $("td", $(this).closest("tr")).eq(1).html();
            document.getElementById('<%=txthourlycharges.ClientID %>').value = $("td", $(this).closest("tr")).eq(3).html();

        });
    });
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
            "Joining": { name: "Joining Date" },
            "Charges": { name: "Hourly Charges" },
            "Leaving": { name: "Leaving Date" },
            "Password": { name: "Change Password" },
            "Other": { name: "Other Details" },
            "ManageRoll": { name: "Manage Role" }
        };

        var rolehidid = $("[id*=hidpermitionID]").val();

        if (rolehidid == 'True') { }
        else { removeItem(items, 'name', 'Manage Role'); }


        var Hchargehidid = $("[id*=hdnhchargepermission]").val();
        if (Hchargehidid == 'False') { removeItem(items, 'name', 'Hourly Charges'); }


        var Cpasshidid = $("[id*=hdnChangePasspermission]").val();
        if (Cpasshidid == 'False') { removeItem(items, 'name', 'Change Password'); }


        var LOBhidid = $("[id*=hdnLOBpermission]").val();
        if (LOBhidid == 'False') { removeItem(items, 'name', 'Leaving Date'); }


        var JOBhidid = $("[id*=hdnJOBpermission]").val();
        if (Hchargehidid == 'False') { removeItem(items, 'name', 'Joining Date'); }


        var detailhidid = $("[id*=hdnOtherDetailpermission]").val();
        if (detailhidid == 'False') { removeItem(items, 'name', 'Other Details'); }



        $.contextMenu({

            selector: '.context-menu-one',
            trigger: 'left',
            //            position: function (opt, x, y) {
            //                opt.$menu.css({ top: tt, left: ll });
            //            },
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
            items: items
        });




}



function pad2(number) {
    return (number < 10 ? '0' : '') + number
}

function modalShow(s) {

    if (s == 'Charges') {
        $find("mailingListModalPopupBehavior").show();

        $("[id *= divBtn]").hide();
        $("[id *= Hrly]").show();
        $("[id *= Ln]").hide();
        $("[id *= Jn]").hide();
        $("[id *= pass]").hide();
        $("[id *= oth]").hide();
        $("[id *= roll]").hide();
        BindHrlyGrd();
    }
    if (s == 'Leaving') {
        $find("ListModalPopupBehavior").show();
        var Stf = $("[id*=hdnStfcode]").val();
        $("[id *= Ln]").show();
        $("[id *= Jn]").hide();
        $("[id *= pass]").hide();
        $("[id *= oth]").hide();
        $("[id *= roll]").hide();

        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "Managestaff.aspx/GetLeavingDT",
            data: "{staff:" + Stf + ",compid:" + $("[id*=hdnCompanyid]").val() + "}",
            dataType: "json",
            success: function (msg) {

                var myList = jQuery.parseJSON(msg.d);
                if (myList[0].ResignDT == "0") {
                    document.getElementById('<%=TxtLNDate.ClientID %>').value = ""
                }
                else {
                    document.getElementById('<%=TxtLNDate.ClientID %>').value = myList[0].ResignDT
                }
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        //Ajax end

    }

    if (s == 'Joining') {
        $find("ListModalPopupBehavior").show();
        Stf = $("[id*=hdnStfcode]").val();
        $("[id *= Jn]").show();
        $("[id *= Ln]").hide();
        $("[id *= pass]").hide();
        $("[id *= oth]").hide();
        $("[id *= roll]").hide();

        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "Managestaff.aspx/GetJoiningDT",
            data: "{staff:" + Stf + ",compid:" + $("[id*=hdnCompanyid]").val() + "}",
            dataType: "json",
            success: function (msg) {

                var myList = jQuery.parseJSON(msg.d);

                document.getElementById('<%=TxtJDate.ClientID %>').value = myList[0].JoinDT

            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
        //Ajax end

    }

    if (s == 'Password') {

        $find("ListModalPopupBehavior").show();
        Stf = $("[id*=hdnStfcode]").val();
        $("[id *= pass]").show();
        $("[id *= Ln]").hide();
        $("[id *= Jn]").hide();
        $("[id *= oth]").hide();
        $("[id *= roll]").hide();

        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "Managestaff.aspx/GetPassword",
            data: "{staff:" + Stf + ",compid:" + $("[id*=hdnCompanyid]").val() + "}",
            dataType: "json",
            success: function (msg) {

                var myList = jQuery.parseJSON(msg.d);

                document.getElementById('<%=TxtPass.ClientID %>').value = myList[0].UPass
                    $("[id*=hdnUid]").val(myList[0].UserID);
                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //Ajax end

        }
        if (s == 'ManageRoll') {
            $find("ListModalPopupBehavior").show();
            Stf = $("[id*=hdnStfcode]").val();
            var c = $("[id*=hdnCompanyid]").val();
            $("[id*=roll]").show();
            $("[id *= pass]").hide();
            $("[id *= Ln]").hide();
            $("[id *= Jn]").hide();
            $("[id *= oth]").hide();

            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Managestaff.aspx/getrollID",
                data: "{staff:" + Stf + ",compid:" + $("[id*=hdnCompanyid]").val() + "}",
                dataType: "json",
                success: function (msg) {

                    var myList = jQuery.parseJSON(msg.d);

                    document.getElementById('<%=ddlroll.ClientID %>').value = myList[0].rollid
                    $("[id*=hdnUid]").val(myList[0].UserID);
                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
            //Ajax end

            ////            //start ajax
            ////            $.ajax({
            ////                type: "POST",
            ////                contentType: "application/json; charset=utf-8",
            ////                url: "Managestaff.aspx/getrollID",
            ////                data: "{staff:' + Stf + ',compid:' + c + '}",
            ////                dataType: "json",
            ////                success: function (msg) {

            ////                    var myList = jQuery.parseJSON(msg.d);

            ////                    document.getElementById('<%=ddlroll.ClientID %>').value = myList[0].rollid
            ////                    $("[id*=hdnUid]").val(myList[0].UserID);
            ////                },
            ////                failure: function (response) {

            ////                },
            ////                error: function (response) {

            ////                }
            ////            });
        }



    if (s == 'oth') {
        Stf = $("[id*=hdngridStaffcode]").val();
        '<% Session["staff"] = "' + Stf + '"; %>';

        window.location.href = "editstaffdetails.aspx";
    }

}

function BindHrlyGrd() {

    Stf = $("[id*=hdnStfcode]").val();

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

function checkFormfrom() {

    // regular expression to match required date format
    var dt = new Date();
    var day = dt.getDate();
    var mon = dt.getMonth() + 1;
    var yr = dt.getFullYear();
    var pin = document.getElementById("<%= txtfromdate.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
            // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {
            alert("Invalid date format: " + pin);

            return false;
        }
    }


    function checkFormto() {

        // regular expression to match required date format
        var dt = new Date();
        var day = dt.getDate();
        var mon = dt.getMonth() + 1;
        var yr = dt.getFullYear();
        var pin = document.getElementById("<%= txttodate.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/)) {

            alert("Invalid date format: " + pin);
            document.getElementById("<%=txttodate.ClientID%>").focus();
            var month = pad2(mon);

            document.getElementById("<%= txttodate.ClientID%>").value = "";
            return false;
        }
    }

    function checkJoinDt() {

        // regular expression to match required date format
        var dt = new Date();
        var day = dt.getDate();
        var mon = dt.getMonth() + 1;
        var yr = dt.getFullYear();
        var pin = document.getElementById("<%= txttodate.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/)) {

            alert("Invalid date format: " + pin);
            document.getElementById("<%=txttodate.ClientID%>").focus();
            var month = pad2(mon);

            document.getElementById("<%= txttodate.ClientID%>").value = "";
            return false;
        }
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
            <asp:HiddenField ID="hidpermitionID" runat="server" />
            <asp:HiddenField ID="hdnStaffLimit" runat="server" />
        </div>
        <div style="width: 100%; overflow: hidden; padding-top: 5px;">
            <asp:Panel ID="Panel5" runat="server" DefaultButton="btnsrchjob">
                <div id="divBtn" style="display: none;">
                    <asp:Button ID="btnpage" runat="server" Text="Edit" OnClick="btnpage_Click"></asp:Button>
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
                                        <asp:TextBox ID="txtsrchjob" runat="server" CssClass="txtbox" Width="128px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:Button ID="btnsrchjob" runat="server" Text="Search" CssClass="cssButton"
                                            OnClick="btnsrchjob_Click" />
                                    </td>
                                    <td>
                                        <asp:Button ID="BtnStf" runat="server" Text="Left Staff" CssClass="cssButton"
                                            OnClick="btnstf_Click" />
                                    </td>
                                    <td>
                                        <asp:Button ID="ImageButton1" runat="server" CssClass="cssButton"
                                            OnClick="lnknewclient_Click" Text="Add Staff" />
                                    </td>
                                    <td>
                                        <asp:ImageButton ID="BtnExport" runat="server" ImageUrl="~/Images/xls-icon.png" OnClick="BtnExport_Click" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </asp:Panel>
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
    <div id="div1" class="seperotorrwr" style="padding-left: 10px; padding-right: 10px;">
        <asp:GridView ID="Griddealers" runat="server" CssClass="norecordTble" AutoGenerateColumns="False"
            Width="100%" DataKeyNames="StaffCode" OnRowCommand="Griddealers_RowCommand"
            OnRowDataBound="Griddealers_RowDataBound"
            EmptyDataText="No records found!!!">


            <Columns>
                <asp:TemplateField HeaderText="jobid" HeaderStyle-CssClass="grdheader" Visible="False">
                    <ItemTemplate>
                        <div class="gridcolstyle">
                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("username") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-CssClass="grdheader" HeaderText="Sr.No">
                    <ItemTemplate>
                        <div class="gridcolstyle" align="center">
                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text='<%# bind("sino") %>'></asp:Label>
                            <asp:HiddenField ID="hdngridStaffcode" runat="server" Value='<%# bind("StaffCode") %>' />
                            <asp:HiddenField ID="hdnuName" runat="server" Value='<%# bind("username") %>' />
                        </div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Staff Name" HeaderStyle-CssClass="grdheader">
                    <ItemTemplate>
                        <div style="width: 198px;">
                            <asp:LinkButton ID="lblfrname" runat="server" Text='<%# bind("StaffName") %>' Width="198px"
                                CssClass="context-menu-one"></asp:LinkButton>
                            <%--                                        <asp:LinkButton ID="LinkButton1" runat="server" CssClass="grdLinks" Text='<%# bind("StaffName") %>'
                                            CommandName="staff" oncontextmenu="ShowMenu('contextMenu',event);"></asp:LinkButton>--%>
                        </div>
                    </ItemTemplate>
                    <ItemStyle CssClass="griditemstlert1" />
                    <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Designation">
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:Label ID="Label3" runat="server" CssClass="labelstyle" Text='<%# bind("DesignationName") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <ItemStyle CssClass="griditemstle3" />
                    <HeaderStyle CssClass="grdheader labelChange" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Department" HeaderStyle-CssClass="grdheader">
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:Label ID="lbldepname" runat="server" CssClass="labelstyle" Text='<%# bind("DepartmentName") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <ItemStyle CssClass="griditemstle3" />
                    <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Hrs. Chrg.">
                    <ItemTemplate>
                        <div class="gridpages" style="text-align: right; padding-right: 20px; width: 50px;">
                            <asp:Label ID="lblpassword" runat="server" CssClass="labelstyle" Text='<%# bind("HourlyCharges") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="grdheader" />
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Contract Wrks">
                    <ItemTemplate>
                        <div class="gridpages" style="text-align: right; padding-right: 20px; width: 50px;">
                            <asp:Label ID="lblwrks" runat="server" CssClass="labelstyle" Text='<%# bind("Emp_Type") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="grdheader" />
                </asp:TemplateField>

                <asp:TemplateField HeaderText="EmpId.">
                    <ItemTemplate>
                        <div class="gridpages" style="text-align: right; padding-right: 20px; width: 50px;">
                            <asp:Label ID="lblempCode" runat="server" CssClass="labelstyle" Text='<%# bind("staffBioServerid") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="grdheader" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Phone">
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text='<%# bind("Mobile") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <ItemStyle CssClass="griditemstle2" />
                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Edit">
                    <ItemTemplate>
                        <div style="text-align: center;">
                            <asp:ImageButton ID="btnEdit" runat="server" ImageUrl="~/images/Edit.png" CssClass="context-menu-one" />
                            <%--<asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/images/Edit.png" oncontextmenu="ShowMenu('contextMenu',event);" />--%>
                        </div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="grdheader" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Delete">
                    <ItemTemplate>
                        <div style="text-align: center;">
                            <asp:ImageButton ID="btndelete" runat="server" ImageUrl="~/images/Delete.png" CommandArgument='<%# bind("StaffCode") %>'
                                OnClick="btndelete_Click" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                ToolTip="Delete" />
                        </div>
                    </ItemTemplate>
                    <HeaderStyle CssClass="grdheader" />
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="grdheader" />
        </asp:GridView>
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td style="width: 100%; text-align: right; background-color: #F3F3F3; border: 1px solid #BCBCBC; padding: 5px;">
                    <div>
                        <asp:Label Style="float: left; margin-top: 5px;" runat="server" ID="lblTotalRecords"></asp:Label>
                        <asp:Repeater ID="rptPager" runat="server">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkPage" runat="server" Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>'
                                    Enabled='<%# Eval("Enabled") %>' OnClick="Page_Changed" CssClass='<%# Convert.ToBoolean(Eval("Enabled")) == true ? "pager call" : "active_pager" %>'></asp:LinkButton>
                            </ItemTemplate>
                        </asp:Repeater>
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
                    <asp:Label ID="Label15" runat="server" Text="Edit Details" CssClass="subHead1"></asp:Label>
                </div>
                <div id="Div60" style="width: 8%; float: left; padding-top: 1%; text-align: right;">
                    <img src="../images/error.png" alt="image" id="imgClose" border="0" name="imgClose" />
                </div>
            </div>
            <div id="Hrly" style="width: 425px; float: left; overflow: hidden; padding-top: 5px; padding-bottom: 5px; display: none;">
                <div style="width: 409px; float: left; overflow: hidden; height: 15px; padding-top: 5px; padding-bottom: 5px;">
                    <div id="Div17" style="width: 425px; float: left; overflow: hidden; font-weight: bold; padding-left: 10px; height: 50px;">
                        Hour Charges:
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
                            <table style="width: 382px;">
                                <tr>
                                    <td style="width: 30px; padding-left: 10px;">
                                        <div style="width: 30px;">
                                            <asp:Label ID="Label53" runat="server" Text="From"></asp:Label>
                                        </div>
                                    </td>
                                    <td style="width: 100px;">
                                        <div style="width: 100px;">
                                            <asp:TextBox ID="txtfromdate" runat="server" CssClass="txtnrml" Width="70px" AutoPostBack="True"
                                                CausesValidation="true" ValidationGroup="g"></asp:TextBox>
                                            <cc1:CalendarExtender ID="txtfromdate_CalendarExtender" runat="server" Format="dd/MM/yyyy"
                                                PopupButtonID="Image19" TargetControlID="txtfromdate">
                                            </cc1:CalendarExtender>
                                            <asp:Image ID="Image19" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" />
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ValidationGroup="g"
                                                ControlToValidate="txtfromdate" Display="None" ErrorMessage="<b>RequiredField<br/>Please Enter Date</b>">*</asp:RequiredFieldValidator>
                                            <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender22" runat="server" HighlightCssClass="validatorCalloutHighlight"
                                                TargetControlID="RequiredFieldValidator1">
                                            </cc1:ValidatorCalloutExtender>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ValidationGroup="g"
                                                ControlToValidate="txtfromdate" Display="None" ErrorMessage="<b>Enter Date in dd/MM/yyyy format"
                                                ValidationExpression="^(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d$">*</asp:RegularExpressionValidator>
                                            <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender1" runat="server" HighlightCssClass="validatorCalloutHighlight"
                                                TargetControlID="RegularExpressionValidator3">
                                            </cc1:ValidatorCalloutExtender>
                                        </div>
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
        <cc1:ModalPopupExtender runat="server" ID="ModalPopup2" BehaviorID="ListModalPopupBehavior"
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
        </asp:Panel>
    </div>
</div>
