<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TFStatusMaster.ascx.cs" Inherits="controls_TFStatusMaster" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script src="../jquery/moment.js" type="text/javascript"></script>
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>

<%--<script src="../jquery/Selectize/selectize.js" type="text/javascript"></script>
<script src="../jquery/Selectize/es5.js" type="text/javascript"></script>
<script src="../jquery/Selectize/index.js" type="text/javascript"></script>
<link href="../jquery/Selectize/normalize.css" rel="stylesheet" type="text/css" />--%>

<script src="../jquery/jquery.searchabledropdown-1.0.8.min.js" type="text/javascript"></script>

<link href="../jquery/dist/jquery.contextMenu.css" rel="stylesheet" type="text/css" />
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
    var main_obj = [];
    var Prj_obj = [];
    var AddPrj_obj = [];

    var StatusList = ["On Going", "On Hold", "Completed"];
    var StatusCount = ["OnGoing", "OnHold", "Completed"];

    var HList = ["Green", "Yellow", "Red"];
    //var HCount = ["Green", "Yellow", "Red"];
    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        $("[id*=hdnPages]").val(1);

        GetProjRecord(1, 25);
        Getdropdown();


        $("[id*=drpProj]").change(function () {
            GetProjRecord(1, 25);
        });

        $("[id*=drpstt]").change(function () {
            GetProjRecord(1, 25);
        });

        $("[id*=drpH]").change(function () {
            GetProjRecord(1, 25);
        });

        $("[id*=btnSave]").click(function () {
            insertUpdaterecord();
        });

        //$("[id*=btnsrchjob]").click(function () {
        //    GetProjRecord(1, 25);
        //});

        //////////////////////////////////////////////////////////////////

        $("[id*=btnNsave]").click(function () {
            var i = $("[id*=hdnIndex]").val();
            if ($("[id*=hdnCommType]").val() == 'Actual') {
                $("[id*=hdnActCom_" + i + "]").val($("[id*=txtNarr]").val());
            } else {
                $("[id*=hdnCurrCom_" + i + "]").val($("[id*=txtNarr]").val());
            }
            $find("NarrModal").hide();
        });

    });





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

    //Getting the Main Grid
    function GetProjRecord(pageIndex, Pagesize) {
        var compid = $("[id*=hdnCompanyid]").val();
        var prjid = $("[id*=drpProj]").val();
        var status = $("[id*=drpstt]").val();
        var health = $("[id*=drpH]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/TFStatusMaster.asmx/Get_Grid",
            data: '{compid:' + compid + ',pageIndex:' + pageIndex + ',pageSize:' + Pagesize + ',prjid:' + prjid + ',status:"' + status + '",health:"' + health + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var RecordCount = 0;
                var tbl = '';
                $("[id*=tblPrj] tbody").empty();

                tbl = tbl + "<tr>";
                tbl = tbl + "<th class='labelChange' style='text-align: center;'>Sr.No</th>";
                tbl = tbl + "<th class='labelChange'>Project</th>";
                tbl = tbl + "<th class='labelChange'>Client</th>";
                tbl = tbl + "<th style='width:150px;' class='labelChange'>Start Date</th>";
                tbl = tbl + "<th style='width:150px;' class='labelChange'>End Date</th>";
                tbl = tbl + "<th class='labelChange'>Status</th>";
                tbl = tbl + "<th class='labelChange'>Health</th>";
                tbl = tbl + "<th class='labelChange' style='width:120px;'>Driver for Status (R/Y/G)</th>";
                tbl = tbl + "<th >Select</th>";
                //tbl = tbl + "<th >Delete</th>";
                tbl = tbl + "</tr>";

                if (myList.length > 0) {


                    for (var i = 0; i < myList.length; i++) {

                        //fill Status Dropdown
                        var StaffDropDown = "<Select style='width:100px;' id='drpStatus_" + i + "' name='drpStatus_" + i + "' class=' dropdownHK' onchange='PrjStatuss($(this))' disabled>";
                        for (var s = 0; s < StatusList.length; s++) {

                            StaffDropDown = StaffDropDown + "<option value='" + StatusCount[s] + "'>" + StatusList[s] + "</option>";
                        }
                        StaffDropDown = StaffDropDown + "</Select>";

                        //fill Health Dropdown
                        var HDropDown = "<Select style='width:100px;' id='drpPH_" + i + "' name='drpPH_" + i + "' class=' dropdownHK' onchange='HealthChange($(this))' disabled>";
                        for (var ss = 0; ss < HList.length; ss++) {

                            HDropDown = HDropDown + "<option value='" + HList[ss] + "'>" + HList[ss] + "</option>";
                        }
                        HDropDown = HDropDown + "</Select>";

                        //////////////////////////////////////////////////////
  
                        tbl = tbl + "<tr>"
                        tbl = tbl + "<td style='text-align: center;font-weight: bolder;'>" + myList[i].srno + "<input type='hidden' id='hdntempid' value='" + myList[i].Id + "' name='hdntempid'></td>";
                       
                        tbl = tbl + "<td style='text-align: left;font-weight: bolder;'>" + myList[i].Project + "<input type='hidden' id='hdnProjectid' value='" + myList[i].Project_ID + "' name='hdnProjectid'><input type='hidden' id='hdnProjstrt' value='" + myList[i].Projstartdt + "' name='hdnProjstrt'></td>";
                        tbl = tbl + "<td style='text-align: left;font-weight: bolder;'>" + myList[i].ClientName + "<input type='hidden' id='hdnDivid' value='" + myList[i].cltid + "' name='hdnDivid'></td>";
                        tbl = tbl + "<td style='text-align: center;font-weight: bolder;'><input type='hidden' id='hdnActCom_" + i + "' value='" + myList[i].ActulNarr + "' name='hdnActCom_" + i + "'><input style='width:130px;' type='date' id='Actdt' name='Actdt' value='" + moment(myList[i].ActualDt).format('YYYY-MM-DD') + "' disabled/></td>";
                        tbl = tbl + "<td style='text-align: center;font-weight: bolder;'><input type='hidden' id='hdnCurrCom_" + i + "' value='" + myList[i].CurrNarr + "' name='hdnCurrCom_" + i + "'><input style='width:130px;' type='date' id='Currdt' name='Currdt' value='" + moment(myList[i].CurrentDt).format('YYYY-MM-DD') + "' disabled/></td>";
                        tbl = tbl + "<td style='text-align: center;font-weight: bolder;'>" + StaffDropDown + "</td>";

                        if (myList[i].PrjHealth == 'Green') {

                            tbl = tbl + "<td style='text-align: center;background:palegreen'>" + HDropDown + "</td>";
                        } else if (myList[i].PrjHealth == 'Yellow') {

                            tbl = tbl + "<td style='text-align: center;background:#ffff008a'>" + HDropDown + "</td>";
                        } else {

                            tbl = tbl + "<td style='text-align: center;background:coral'>" + HDropDown + "</td>";
                        }

                        tbl = tbl + "<td style='text-align: center;font-weight: bolder;'><input style='width:100px;' type='input' id='txtDriv' class='texboxcls' value='" + myList[i].Narr + "' name='txtDriv'disabled></td>";

                        //tbl = tbl + "<td style='text-align: center;'><img src='../images/edit.png' style='cursor:pointer; height:18px; width:18px;' onclick='Edit_Show($(this))' id='stfEdit' name='stfEdit'></td>";
                        tbl = tbl + "<td style='text-align: center;'><input type='checkbox' id='chkEjob' name='chkEjob' onclick='singleJobcheck($(this))' value='" + myList[i].jobid + "'/></td></tr>";

                    };
                    $("[id*=tblPrj]").append(tbl);

                    //////////////////////////////////////////////////////////////////
                    for (var i = 0; i < myList.length; i++) {
                        $("[id*=drpStatus_" + i + "]").val(myList[i].PrjStatus);
                        $("[id*=drpPH_" + i + "]").val(myList[i].PrjHealth);
                    }
                    //////////////////////////////////////////////////////////////////

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
                    tbl = tbl + "</tr>";
                    $("[id*=tblPrj]").append(tbl);

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

            GetProjRecord(($(this).attr('page')), 25)
        });
    }



    function HealthChange(i) {
        var row = i.closest("tr");
        var rIndex = i.closest("tr")[0].sectionRowIndex;
        rIndex = rIndex - 1;
        var stut = $("[id*=drpStatus_" + rIndex + "]").val();
        var clr = $("[id*=drpPH_" + rIndex + "]").val();

        if (stut == 'Completed') {

            if (clr == 'Red') {
                $("[id*=drpPH_" + rIndex + "]").val('Green')
                alert('Cannot Change the Health into RED Because the Project Completed!!!');
            } else {
                $("#Actdt", row).attr("disabled", true);
                $("#Currdt", row).attr("disabled", true);
            }

        }

    }

    function PrjStatuss(i) {
        var row = i.closest("tr");
        var rIndex = i.closest("tr")[0].sectionRowIndex;
        rIndex = rIndex - 1;
        var stut = $("[id*=drpStatus_" + rIndex + "]").val();
        var clr = $("[id*=drpPH_" + rIndex + "]").val();

        if (stut == 'Completed') {

            if (clr == 'Red') {
                $("[id*=drpStatus_" + rIndex + "]").val('InProgress');
                alert('Cannot Close the Project Because the Health is RED!!!');
            } else {
                $("#Actdt", row).attr("disabled", true);
                $("#Currdt", row).attr("disabled", true);
            }

        } else {
            $("#Actdt", row).attr("disabled", false);
            $("#Currdt", row).attr("disabled", false);
        }
    }

    function singleJobcheck(i) {
        var chks = i.is(':checked');
        var row = i.closest("tr");
        var rIndex = i.closest("tr")[0].sectionRowIndex;

        rIndex = rIndex - 1;

        var stut = $("[id*=drpStatus_" + rIndex + "]").val();
        if (chks) {
            $("#txtDriv", row).attr("disabled", false);
            $("#Actdt", row).attr("disabled", false);
            $("#Currdt", row).attr("disabled", false);
            $("[id*=drpStatus_" + rIndex + "]").attr("disabled", false);
            $("[id*=drpPH_" + rIndex + "]").attr("disabled", false);
            if (stut == 'Completed') {
                $("#Actdt", row).attr("disabled", true);
                $("#Currdt", row).attr("disabled", true);
            }

        } else {
            $("#txtDriv", row).attr("disabled", true);
            $("#Actdt", row).attr("disabled", true);
            $("#Currdt", row).attr("disabled", true);
            $("[id*=drpStatus_" + rIndex + "]").attr("disabled", true);
            $("[id*=drpPH_" + rIndex + "]").attr("disabled", true);
            $("#chkEjob", row).removeAttr('checked');
        }
    }

    ///Insert Update the record
    function insertUpdaterecord() {
        var compid = $("[id*=hdnCompanyid]").val();
        var rcd = '', rIndex = 0;
        $("input[name=chkEjob]").each(function () {
            row = $(this).closest("tr");
            chk = $(this).is(':checked');

            if (chk == true) {
                var Prj = row.find("input[name=hdnProjectid]").val();
                var Divid = row.find("input[name=hdnDivid]").val();
                var Buid = row.find("input[name=hdnBuid]").val();
                var status = $("[id*=drpStatus_" + rIndex + "]").val();
                var Health = $("[id*=drpPH_" + rIndex + "]").val();
                var DrvNrr = row.find("input[name=txtDriv]").val();
                var Startdate = row.find("input[name=Actdt]").val();
                //var ActNrr = $("[id*=hdnActCom_" + rIndex + "]").val();
                var Enddate = row.find("input[name=Currdt]").val();
                //var CurrNrr = $("[id*=hdnCurrCom_" + rIndex + "]").val();
               
                var dt = '';
                var Mnt = '';
                var yr = '';

                dt = Startdate.split('-')[2];
                Mnt = Startdate.split('-')[1];
                yr = Startdate.split('-')[0];

                var strtt = yr + Mnt + dt;
                //End Date
                dt = Enddate.split('-')[2];
                Mnt = Enddate.split('-')[1];
                yr = Enddate.split('-')[0];

                var actdt = yr + Mnt + dt;

                if (parseFloat(strtt) > parseFloat(actdt)) {
                    alert('Please Select End Date Greater Than Start Date !!!');
                    return
                }
                //Current Date 
                //dt = CurrDate.split('-')[2];
                //Mnt = CurrDate.split('-')[1];
                //yr = CurrDate.split('-')[0];

                //var curdt = yr + Mnt + dt;
                //if (parseFloat(strtt) > parseFloat(curdt)) {
                //    showWarningToast('The Start Date of Project is Greater than Current Compl Date!!!');
                //    return
                //}
                //rcd = $(this).val() + '~' + Divid + '~' + Prj + '~' + status + '~' + Health + '~' + DrvNrr + '~' + ActDate  + '~' + CurrDate  + '^' + rcd;
                rcd = Prj + '~' + Divid + '~' + status + '~' + Health + '~' + DrvNrr + '~' + Startdate + '~' + Enddate + '^' + rcd;
            }
            rIndex = rIndex + 1;
        });

        if (rcd == '') {
            alert('Kindly Select atleast one record !!!');
            return
        }

        $.ajax({
            type: "POST",
            url: "../Handler/TFStatusMaster.asmx/InsertUpdateStatus",
            data: '{compid:' + compid + ',rcd:"' + rcd + '"}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length > 0) {
                    if (myList[0].Id == -1) {
                        // Duplicate Entry found Message
                        alert('Duplicate Entry found !!!');
                    }
                    else {

                        alert('Inserted successfully !!!');


                        GetProjRecord(1, 25);
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



    ///Drop Down
    function Getdropdown() {
        var compid = $("[id*=hdnCompanyid]").val();
        $.ajax({
            type: "POST",
            url: "../Handler/TFStatusMaster.asmx/GetProjectdropdown",
            data: '{compid:' + compid + '}',
            dataType: 'json',
            contentType: "application/json; charset=utf-8",
            success: function (msg) {
                var mylist = jQuery.parseJSON(msg.d);


                //Project Name

                $("[id*=drpProj]").empty();
                $("[id*=drpProj]").append("<option value=0>--Select--</option>");

                for (var i = 0; i < mylist.length; i++) {

                    $("[id*=drpProj]").append("<option value='" + mylist[i].projectid + "'>" + mylist[i].projectName + "</option>");
                }

                //////Status
                $("[id*=drpstt]").empty();
                $("[id*=drpstt]").append("<option value=All>--All--</option>");

                for (var i = 0; i < StatusList.length; i++) {

                    $("[id*=drpstt]").append("<option value='" + StatusCount[i] + "'>" + StatusList[i] + "</option>");
                }


                /////////Health
                $("[id*=drpH]").empty();
                $("[id*=drpH]").append("<option value=All>--All--</option>");

                for (var i = 0; i < HList.length; i++) {

                    $("[id*=drpH]").append("<option value='" + HList[i] + "'>" + HList[i] + "</option>");
                }

                $('.loader').hide();
            },
            failure: function (response) {

            },
            error: function (response) {

            }
        });
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

    .DropDown {
        min-height: 25px;
        max-height: 25px !important;
    }

    #txtRMSrch, #txtAssocSrch {
        background-position: 10px 10px;
        background-repeat: no-repeat;
        width: 80%;
        font-size: 16px;
        padding: 12px 20px 12px 40px;
        border: 1px solid #ddd;
        margin-bottom: 12px;
    }
</style>

<div id="divtotbody" class="testwhleinside">
    <div>
        <div>
            <table style="width: 100%" class="cssPageTitle">
                <tr>
                    <td class="cssPageTitle2">
                        <asp:Label ID="Label1" runat="server" Style="margin-left: 0px;" Text="Manage Project Status"></asp:Label>
                    </td>
                    <td style="text-align-last: right; padding-right: 10px;">
                        <%--<div id="editsavedv">--%>
                        <input id="btnSave" type="button" class="cssButton labelChange" value="Save" />
                        <%--               <input id="btnCancel" type="button" class="cssButton labelChange" value="Cancel" />--%>
                        <%--</div>--%>
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
        <asp:HiddenField ID="hdnPages" runat="server" />
        <asp:HiddenField ID="hdnoldJobid" runat="server" Value="0" />
        <asp:HiddenField ID="hdnUpdt" runat="server" />

        <asp:HiddenField ID="hdnIndex" runat="server" />
        <asp:HiddenField ID="hdnCommType" runat="server" />
    </div>
    <div id="dvtbl">
        <div id="dvsrch" style="width: 100%; padding-top: 5px;">
            <div style="float: left; padding-left: 1px">

                <table style="font-weight: bold; width: 100%; padding-top: 20px;">
                    
                    <tr>
                        <td style="width: 20px;"></td>
                        <td style="width: 80px;">
                            <label style="font-weight: bold" class="LabelFontStyle labelChange">Project</label></td>
                        <td>
                            <select id="drpProj" name="drpProj" runat="server" class="DropDown" style="width: 280px; height: 25px;">
                                <option value="0">--Select--</option>
                            </select>

                        </td>
                        <td style="width: 50px;"></td>
                        <td style="width: 100px;">
                            <label style="font-weight: bold" class="LabelFontStyle labelChange">View By:</label></td>
                        <%--<td style="width: 50px;"></td>--%>
                        <td style="width: 80px;">
                            <label style="font-weight: bold" class="LabelFontStyle labelChange">Status</label></td>
                        <td>
                            <select id="drpstt" name="drpstt" runat="server" class="DropDown" style="width: 130px; height: 25px;">
                                <option value="All">--All--</option>
                            </select>

                        </td>
                        <td style="width: 50px;"></td>
                        <td style="width: 100px;">
                            <label style="font-weight: bold" class="LabelFontStyle labelChange">Health</label></td>
                        <td>
                            <select id="drpH" name="drpH" runat="server" class="DropDown" style="width: 130px; height: 25px;">
                                <option value="All">--All--</option>
                            </select>

                        </td>

                    </tr>

                    <tr>
                        <td colspan="5" style="height: 7px;"></td>
                    </tr>

                </table>
        
            </div>
        </div>
        <div>
            <table>
                <tr>
                    <td>
                        <table id="tblPrj" width="1175px" border="1px" class="norecordTble allTimeSheettle" style="border-collapse: collapse; width: 99%;">
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
                    </td>
                </tr>
            </table>

        </div>
    </div>



    <%--Popup--%>
 
  

</div>
