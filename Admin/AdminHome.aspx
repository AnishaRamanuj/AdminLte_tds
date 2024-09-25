<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="AdminHome.aspx.cs" Inherits="Admin_AdminHome" %>

<%@ Register src="../controls/userlisting_control.ascx" tagname="userlisting_control" tagprefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
   

    <script type="text/javascript" src="../jquery/jquery-2.2.4.min.js"></script>
    <script type="text/javascript" src="../jquery/jquery.searchabledropdown-1.0.8.min.js" ></script>
    <script type="text/javascript" src="../Stylecss/dropdowncontent.js"></script>
    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
            $("[id*=divEdit]").hide();
            GetCompanyList();
             
            $("[id*=BtnSave]").on('click', function () {
                var rd1 = "";
                var rd2 = "";
                var DT1 = [];
                var DT2 = [];
                var lblSTS1 = [];
                var cid = $("[id*=hdnCompid]").val();
                var L = $("[id*=SLevel]").val();
               // var N = $("[id*=lblName]").html();
                var CP = $("[id*=CPerson]").val();
                S = $("[id*=lblStatus]").html();
                lblSTS1 = S.split(' ');
                S = lblSTS1[0];
                var ST = $("[id*=Stype]").val();
                var SDT = $("[id*=txtstartdate]").val();
                DT1 = SDT.split('/');
                SDT = DT1[1] + '/' + DT1[0] + '/' + DT1[2];


                var EDT = $("[id*=txtactualdate]").val();
                DT2 = EDT.split('/');
                EDT = DT2[1] + '/' + DT2[0] + '/' + DT2[2];
                if (SDT == '')
                {
                    alert('Please enter Start DT');
                    return;
                }
                if (EDT == '') {
                    alert('Please enter End DT');
                    return;
                }
                if (SDT == undefined) {
                    alert('Please enter Start DT');
                    return;
                }
                if (EDT == undefined) {
                    alert('Please enter Start DT');
                    return;
                }

                var SCnt = $("[id*=txtStaffCnt]").val();
                var D = $("[id*=txtDays]").val();
                var P1 = $("[id*=CPhone1]").val();
                var P2 = $("[id*=CPhone2]").val();
                var P3 = $("[id*=CPhone3]").val();
                var E1 = $("[id*=Email1]").val();
                var E2 = $("[id*=Email2]").val();
                var DM = $("[id*=txtMin]").val();
                var M = $("[id*=txtMax]").val();
                var F = $("[id*=FTime]").val();
                var W = $("[id*=Week]").val();
                var WD = $("[id*=WDays]").val();
                var LA = $("[id*=ALeave]").val();
                var LT = $("[id*=TLeave]").val();
                var LC = $("[id*=CLeave]").val();
                if (SCnt == undefined) {
                    alert('Please enter Staff Count');
                    return;
                }
                if (SCnt == '') {
                    alert('Please enter Staff Count');
                    return;
                }
                if (D == undefined) {
                    alert('Please enter Days Left');
                    return;
                }
                if (D == '') {
                    alert('Please enter Days Left');
                    return;
                }
                if (W == undefined) {
                    alert('Please Select Week Start');
                    return;
                }
                if (W == '') {
                    alert('Please Select Week Start');
                    return;
                }

                rd1 = rd1 + cid + "," + L + "," + CP + "," + ST + "," + SDT + "," + EDT + "," + SCnt + "," + D + ",";
                rd2 = rd2 + P1 + "," + P2 + "," + P3 + "," + E1 + "," + E2 + "," + DM + "," + M + "," + F + "," + W + "," + WD + "," + LA + "," + LT + "," + LC + "," + S;
                rd3 = rd1 + rd2;
                $.ajax({
                    type: "POST",
                    url: "../Handler/wsSuperadmin.asmx/SaveCompany",
                    data: '{rd:"' + rd3 + '"}',
                    dataType: 'json',
                    contentType: "application/json; charset=utf-8",
                    success: function (msg) {
                        $("[id*=hdnCompid]").val('');
                        $("[id*=divEdit]").hide();
                        $("[id*=divComp]").show();
                        GetCompanyList();
                        emptyControls();
                        alert('Record Updated Successfully');
                    },
                    failure: function (response) {
                        alert('Cant Connect to Server' + response.d);
                    },
                    error: function (response) {
                        alert('Error Occoured ' + response.d);
                    }

                });
            });

            $("[id*=BtnCancel]").on('click', function () {
                $("[id*=divEdit]").hide();
                $("[id*=divComp]").show();
                $("[id*=hdnCompid]").val('');
                emptyControls();
            });


            $("[id*=txtStaffCnt]").on('change', function () {
                var x = $("[id*=txtStaffCnt]").val();
                if (isNaN(x) || x < 1 || x > 50000) {
                    alert('Enter Numeric Only or Less then 50000');
                    $("[id*=txtStaffCnt]").val(0);
                }
            });
            $("[id*=txtDays]").on('change', function () {
                var x = $("[id*=txtDays]").val();
                if (isNaN(x) || x < 1 || x > 365) {
                    alert('Enter Numeric Only or within 365 days');
                    $("[id*=txtDays]").val(0);
                }

            });

            $("[id*=txtMin]").on('change', function () {
                var txt = 'txtMin';
                validate_Decimals(txt);
            });

            $("[id*=txtMax]").on('change', function () {
                var txt = 'txtMax';
                validate_Decimals(txt);
            });

            $("[id*=txtstartdate]").on('blur', function () {
                var txt = $("[id*=txtstartdate]").val();
                validatedate(txt);
            });

            $("[id*=txtactualdate]").on('blur', function () {
                var txt = $("[id*=txtactualdate]").val();
                validatedate(txt);
            });

        });


        function GetCompanyList() {
            var srch = "s";

            $.ajax({
                type: "POST",
                url: "../Handler/wsSuperadmin.asmx/getCompany",
                data: '{srch:"' + srch + '"}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tbl = "";
                    $("[id*=tblReg]").empty();
                    $("[id*=tblDemo]").empty();
                    $("[id*=tblExp]").empty();
                    tbl = tbl + "<tr>";
                    tbl = tbl + "<th style='width: 500px;'>Company</th>";
                    tbl = tbl + "<th style='width: 100px;' class='labelChange'>Start DT</th>";
                    tbl = tbl + "<th style='width: 100px;'class='labelChange'>End DT</th>";
                    tbl = tbl + "<th style='width: 80px;'class='labelChange'>Staff</th>";
                    tbl = tbl + "<th style='width: 200px;' class='labelChange'>Contact P</th>";
                    tbl = tbl + "<th style='width: 100px;'>Phone</th>";
                    tbl = tbl + "<th style='width: 100px;'>Days Left</th>";
                    tbl = tbl + "<th style='width: 100px;'>Version</th>";
                    tbl = tbl + "<th style='width: 100px;'>Edit</th>";
                    tbl = tbl + "<th style='width: 100px;'>Login</th>";
                    tbl = tbl + "</tr>";
                    $("[id*=tblReg]").append(tbl);
                    $("[id*=tblDemo]").append(tbl);
                    $("[id*=tblExp]").append(tbl);
                    if (myList == null) {
                    }
                    else {
                        if (myList.length > 0) {
                            for (var i = 0; i < myList.length; i++) {
                                var vL = "";
                                tbl = "";
                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td >" + myList[i].CompanyName + "<input type='hidden' id='hdncid' value='" + myList[i].CompId + "' name='hdncid'></td>";
                                tbl = tbl + "<td >" + myList[i].AmcST + "<input type='hidden' id='hdnU' value='" + myList[i].usr + "' name='hdnU'></td>";
                                tbl = tbl + "<td >" + myList[i].AmcEnd + "<input type='hidden' id='hdnP' value='" + myList[i].pwd + "' name='hdnP'></td>";
                                tbl = tbl + "<td >" + myList[i].StaffCount + "</td>";
                                tbl = tbl + "<td >" + myList[i].ContactP + "</td>";
                                tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].Phone + "</td>";
                                tbl = tbl + "<td style=width: auto' align='center'>" + myList[i].daysLeft + "</td>";
                                if (myList[i].VerType == 2)
                                {
                                    vL= '2 Level';
                                }
                                if (myList[i].VerType == 3) {
                                    vL = '3 Level';
                                }
                                if (myList[i].VerType == 4) {
                                    vL = '4 Level';
                                }
                                var sts = '';
                                if (myList[i].Schemes == 'Full Version') {
                                    sts = '1 Active';
                                }
                                if (myList[i].Schemes == 'Free Version') {
                                    sts = '2 Demo';
                                }
                                if (myList[i].Schemes == 'Expired') {
                                    sts = '3 Expired';
                                }

                                tbl = tbl + "<td style=width: auto' align='center'>" + vL + "<input type='hidden' id='hdnsts' value='" + sts + "' name='hdnsts'></td>";
                                tbl = tbl + "<td style=width: auto' align='center'><img src='../images/edit.png' style='cursor:pointer; height:18px; width:18px;' onclick='Edit_Comp($(this))' id='btnEdit' name='btnEdit'></td>";
                                tbl = tbl + "<td style=width: auto' align='center'><input type='button' id='btnLogin' name='btnLogin' onclick='Login($(this))'></td>";
                                tbl = tbl + "</tr>";
                                if (myList[i].Schemes == 'Full Version') {
                                    $("[id*=tblReg]").append(tbl);
                                }
                                if (myList[i].Schemes == 'Free Version') {
                                    $("[id*=tblDemo]").append(tbl);
                                }
                                if (myList[i].Schemes == 'Expired') {
                                    $("[id*=tblExp]").append(tbl);
                                }
                            }
                            tbl = "</table>";
                            $("[id*=tblReg]").append(tbl);
                            $("[id*=tblDemo]").append(tbl);
                            $("[id*=tblExp]").append(tbl);
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


        function Edit_Comp(i) {
            var row = i.closest("tr");
            var cid = row.find("input[name=hdncid]").val();
            var sts = row.find("input[name=hdnsts]").val();
            var lvl = row.find('td:eq(7)').text();
            $("[id*=hdnCompid]").val(cid);
            var L = [];
            var S = [];
            L = lvl.split(" ");
            S = sts.split(" ");
            
            $("[id*=SLevel]").val(L[0]);
            $("[id*=divEdit]").show();
            $("[id*=divComp]").hide();
            $("[id*=lblName]").html(row.find('td:eq(0)').text());
            $("[id*=CPerson]").val(row.find('td:eq(4)').text());
            $("[id*=lblStatus]").html(lvl);

            $("[id*=Stype]").val(S[0]); 
            $("[id*=txtstartdate]").val(row.find('td:eq(1)').text());
            $("[id*=txtactualdate]").val(row.find('td:eq(2)').text());
            $("[id*=txtStaffCnt]").val(row.find('td:eq(3)').text());
            $("[id*=txtDays]").val(row.find('td:eq(6)').text());
            $.ajax({
                type: "POST",
                url: "../Handler/wsSuperadmin.asmx/getCompanyDetails",
                data: '{compid:' + cid + '}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList == null) {
                    }
                    else {
                        if (myList.length > 0) {

                            $("[id*=CPhone1]").val(myList[0].Phone);
                            $("[id*=CPhone2]").val(myList[0].Phone1);
                            $("[id*=CPhone3]").val(myList[0].Phone2);
                            $("[id*=Email1]").val(myList[0].Email);
                            $("[id*=Email2]").val(myList[0].Email1);

                            $("[id*=txtMin]").val(myList[0].DailyThreshold);
                            $("[id*=txtMax]").val(myList[0].Max_hours);
                            if (myList[0].Future_Date == true) {
                                $("[id*=FTime]").val(1);
                            }
                            else
                            {
                                $("[id*=FTime]").val(0);
                            }
                            $("[id*=Week]").val(myList[0].WeekStart);
                            $("[id*=WDays]").val(myList[0].NumberOfDaysRequireInWeek);
                            if (myList[0].Leave > 0) {
                                $("[id*=ALeave]").val(1);
                                if (myList[0].Leave_Type == 76)
                                { $("[id*=TLeave]").val(0); }
                                else
                                {
                                    $("[id*=TLeave]").val(1);
                                }
                                if (myList[0].Leave_Year == 'Calender')
                                { $("[id*=CLeave]").val(0); }
                                else
                                { $("[id*=CLeave]").val(1); }
                            }
                            else
                            {
                                $("[id*=ALeave]").val(2);
                                $("[id*=TLeave]").val(0);
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

        function emptyControls()
        {
             $("[id*=hdnCompid]").val('');
            $("[id*=SLevel]").val(0);
            $("[id*=lblName]").html('');
            $("[id*=CPerson]").val('');
             $("[id*=lblStatus]").html('');
            $("[id*=Stype]").val(0);
            $("[id*=txtstartdate]").val('');
            $("[id*=txtactualdate]").val('');
            $("[id*=txtStaffCnt]").val('');
            $("[id*=txtDays]").val('');
            $("[id*=CPhone1]").val('');
            $("[id*=CPhone2]").val('');
            $("[id*=CPhone3]").val('');
            $("[id*=Email1]").val('');
            $("[id*=Email2]").val('');
            $("[id*=txtMin]").val('');
            $("[id*=txtMax]").val('');
            $("[id*=FTime]").val('');
            $("[id*=Week]").val(0);
            $("[id*=WDays]").val(0);
            $("[id*=ALeave]").val(2);
            $("[id*=TLeave]").val(0);
            $("[id*=CLeave]").val(0);

        }

        function validatedate(inputText) {
            var dateformat = /^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$/;
            // Match the date format through regular expression
            if (inputText.value.match(dateformat)) {
                document.form1.text1.focus();
                //Test which seperator is used '/' or '-'
                var opera1 = inputText.value.split('/');
                var opera2 = inputText.value.split('-');
                lopera1 = opera1.length;
                lopera2 = opera2.length;
                // Extract the string into month, date and year
                if (lopera1 > 1) {
                    var pdate = inputText.value.split('/');
                }
                else if (lopera2 > 1) {
                    var pdate = inputText.value.split('-');
                }
                var dd = parseInt(pdate[0]);
                var mm = parseInt(pdate[1]);
                var yy = parseInt(pdate[2]);
                // Create list of days of a month [assume there is no leap year by default]
                var ListofDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
                if (mm == 1 || mm > 2) {
                    if (dd > ListofDays[mm - 1]) {
                        alert('Invalid date format!');
                        return false;
                    }
                }
                if (mm == 2) {
                    var lyear = false;
                    if ((!(yy % 4) && yy % 100) || !(yy % 400)) {
                        lyear = true;
                    }
                    if ((lyear == false) && (dd >= 29)) {
                        alert('Invalid date format!');
                        return false;
                    }
                    if ((lyear == true) && (dd > 29)) {
                        alert('Invalid date format!');
                        return false;
                    }
                }
            }
            else {
                alert("Invalid date format!");
                document.form1.text1.focus();
                return false;
            }
        }


        function validate_Decimals(txt) {

            var j = $("#" + txt).val();
             if (j != undefined) {
                 if (j != '') {
                     var JM = j.split(':')[1];
                     var jhrs = j.replace(':', '.');
                     if (isNaN(jhrs) == true) {
                         $("#" + txt).val('00:00');
                     }

                     if (jhrs > 23.59) {
                         $("#" + txt).val('00:00');
                     }
                     if (JM > 59) {
                         $("#" + txt).val('00:00');
                     }

                     var startTime = $("#" + txt).val();
                     //startTime = startTime.replace('.', ':');
                     $("#" + txt).val(startTime);

                 }

             }
        }

        function Login(i) {
            var row = i.closest("tr");
            var U = row.find("input[name=hdnU]").val();
            var P = row.find("input[name=hdnP]").val();
            var newWin = window.open("../Default.aspx?u=" + U + "&p=" + P, "_blank");
            if (!newWin || newWin.closed || typeof newWin.closed == 'undefined') {
                //POPUP BLOCKED
                alert('please allow popup window in your browser ');
            }
            //alert();
        }

 </script>
    <style type="text/css">


        .tabular {
            margin: 10px 0;
            width: auto;
        }

            .tabular .property_tab .ajax__tab_body {
                min-height: 100px !important;
                height: auto !important;
                position: absolute;
            }

        .property_tab .ajax__tab_body {
            width: 1175px;
            padding-left: 8px;
        }

        .loading {
            font-family: Arial;
            font-size: 10pt;
            border: 5px solid #67CFF5;
            width: 200px;
            height: 100px;
            display: none;
            position: fixed;
            background-color: White;
            z-index: 999;
        }

        .pagination {
            font-size: 80%;
        }

            .pagination a {
                text-decoration: none;
                border: solid 1.5px #55A0FF;
                color: #15B;
            }

            .pagination a, .pagination span {
                display: block;
                float: left;
                padding: 0.1em 0.5em;
                margin-right: 1px;
                margin-bottom: 2px;
            }

            .pagination .current {
                background: #26B;
                color: #fff;
                border: solid 1px #AAE;
            }

                .pagination .current.prev, .pagination .current.next {
                    color: #999;
                    border-color: #999;
                    background: #fff;
                }

        tr.cltoggleclass td {
            cursor: inherit;
            color: #fff;
            background: #25a0da;
            border-color: #25a0da !important;
        }

        .allTimeSheettle tr:hover {
            cursor: inherit;
            background: #F2F2F2;
            border: 1px solid #ccc;
            padding: 5px;
            color: #474747;
        }

        .allTimeSheettle {
            cursor: inherit;
        }


        .newstyleforbindstaff {
            text-align: center !important;
        }

        .newstyleforbindstaffLable {
            min-width: 100px;
        }

        .newtotalback {
            background: #F2F2F2;
            height: 35px;
            font-weight: bold;
        }

        .DropDown {
            max-height: 25px !important;
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

        .tblBorderClass {
            border-collapse: collapse;
        }

            .tblBorderClass th {
                background: #F2F2F2;
            }

            .tblBorderClass td, .tblBorderClass th {
                padding: 5px;
                margin: 0px;
                border: 1px solid #bcbcbc;
            }

            .tblBorderClass tr td:nth-child(1), .tblBorderClass tr td:nth-child(2), .tblBorderClass tr td:nth-child(3) {
                text-align: center;
            }

            .tblBorderClass input[type=text] {
                /*max-width: 42px;*/
                min-height: 20px;
            }

            .tblBorderClass tr:hover td {
                background: #c7d4dd !important;
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

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:HiddenField runat="server" ID="hdnCompid" />
    <div class="testwhleinside">
        <div class="headerstyle1_master" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="Label4" runat="server" Text="Company Details" CssClass="Head labelChange"></asp:Label>
        </div>
    </div>
<%--    <table width="100%" align="center">
        <tr>
            <td style="width: 50px;"></td>
            <td style="width: 25px" align="left">
                <asp:Label ID="Label7" Text="Client" runat="server" Font-Bold="True" CssClass="labelChange" />
            </td>
            <td>
                <select name="drpusername" id="drpusername" class="dropstyle" style="width:38%;">
		            <option selected="selected" value="--CompanyName--">--CompanyName--</option>
	            </select>
            </td>
            <td style="width: 50px;"></td>
            <td style="width: 25px" align="left">
                 
            </td>
            <td>
 
            </td>
        </tr>
        <tr>
            <td style="height: 8px;"></td>
        </tr>
 
        <tr id="trtaskk" style="display: none;">
            <td style="height: 8px;"></td>
        </tr>
 
    </table>--%>
    <div id="divComp" style="height: 20px;">
    <asp:Panel ID="Panel1" runat="server" Height ="720px">
        <cc1:TabContainer ID="TabContainer1" runat="server"  CssClass="property_tab" TabIndex="1"
            Width="1100px"  ActiveTabIndex="0">
            <cc1:TabPanel ID="TabPanel1" runat="server"  ForeColor="Black"
                Width="1100px" >
                <HeaderTemplate>
                    Active Clients
                </HeaderTemplate>
                <ContentTemplate>
                    <div style="overflow:scroll; height:500px;">
                        <table id="tblReg"  class="tblBorderClass" style=" width: auto; padding-left: 120px;">

                        </table>
                    </div>
                </ContentTemplate>
            </cc1:TabPanel>
            <cc1:TabPanel ID="tabPanel2" runat="server" ForeColor="Black">
                <HeaderTemplate>
                    <label id="StaffSummary" runat="server" class="labelChange">
                        Demo Clients</label>
                </HeaderTemplate>

                <ContentTemplate>
                       <div style="overflow:scroll; height:500px;">
                            <table id="tblDemo"  class="tblBorderClass"  style="width: auto; padding-left: 120px;">
                            </table>
                        </div>
                 
                </ContentTemplate>
            </cc1:TabPanel>
            <cc1:TabPanel ID="tabPanel3" runat="server" ForeColor="Black" >
                <HeaderTemplate>
                    <label id="Label1" runat="server" class="labelChange">
                        Expired Clients</label>
                </HeaderTemplate>
                <ContentTemplate>
                       <div style="overflow:scroll; height:500px;">
                            <table id="tblExp"  class="tblBorderClass"  style="width: auto; padding-left: 120px;">
                            </table>
                        </div>

                </ContentTemplate>
            </cc1:TabPanel>
        </cc1:TabContainer>
    </asp:Panel>
    </div>
    <div id="divEdit">
        <table style="width :98%" class="tblBorderClass">
            <tr>
                <td style="width:350px">
                    <label id="lblName" ></label>
                </td>
                <td style="width:350px">
                    <label id="lblCPerson" >Contact Person</label>
                    <input id="CPerson" type="text" style="width:250px"/>
                </td>
                <td style="width:350px">
                    <label  >Phone</label>
                    <input id="CPhone1" type="text" />
                </td>
                <td style="width:350px">
                    <label  >Phone</label>
                    <input id="CPhone2" type="text" />
                </td>
             

            </tr>
            <tr>

                <td>
                    <label >Phone</label>
                    <input id="CPhone3" type="text" />
                </td>
                <td>
                    <label  >Email</label>
                    <input id="Email1" type="text" disabled />
                </td>
                <td>
                    <label  >Email1</label>
                    <input id="Email2" type="text" />
                </td>
                <td>
                    <label id="lblStatus" ></label>
                </td>
            </tr>
        </table>
        <table  style="width :98%" class="tblBorderClass">
           <tr>
                <td>
                    <label >Status</label>
                    <select id="Stype">
                        <option value="1">Active</option>
                        <option value="2">Demo</option>
                        <option value="3">Expired</option>
                    </select>                 
                </td>
               <td>
                    <label id="lblLevel" >Level</label>
                    <select id="SLevel">
                        <option value="2">2 Level</option>
                        <option value="3">3 Level</option>
                        <option value="4">4 Level</option>
                    </select> 

                </td>
                <td>
                    <label >Bill DT</label>
                </td> 
                <td>
                  <asp:TextBox ID="txtstartdate" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtstartdate"
                                    Mask="99/99/9999" MaskType="Date" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
                                    CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                    CultureTimePlaceholder="" Enabled="True" />
                                <asp:Label ID="Label10" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                                <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtstartdate"
                                    PopupButtonID="txtstartdate" Format="dd/MM/yyyy" Enabled="True">
                                </cc1:CalendarExtender>                 
                </td>
                <td>
                    <label >Bill DT</label>
                </td> 
                <td>
                  <asp:TextBox ID="txtactualdate" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender16" runat="server" TargetControlID="txtactualdate"
                                    Mask="99/99/9999" MaskType="Date" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
                                    CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                    CultureTimePlaceholder="" Enabled="True" />
                                <asp:Label ID="Label26" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                                <cc1:CalendarExtender ID="txtactualdate_CalendarExtender" runat="server" TargetControlID="txtactualdate"
                                    PopupButtonID="txtactualdate" Format="dd/MM/yyyy" Enabled="True">
                                </cc1:CalendarExtender>                
                </td>
           </tr>
           <tr>
                <td>
                    <label >Staff Count</label>
                </td> 
                <td>
                   <input id="txtStaffCnt" type="text" style="width:100px"  />                   
                </td>
                <td>
                    <label >Days Left</label>                    
                </td> 
                <td>
                   <input id="txtDays" type="text" style="width:100px" />           
                </td>
                <td>
                    <label >Min Hours</label>
                   <input id="txtMin" type="text" style="width:100px"  />   
                </td> 
                <td>
                    <label >Max Hours</label>
                   <input id="txtMax" type="text" style="width:100px" />               
                </td>
           </tr>
           <tr>
                <td>
                    <label >Future DT TSheet</label>
                </td> 
                <td>
                    <select id="FTime">
                        <option value="0">No</option>
                        <option value="1">Yes</option>
                    </select>               
                </td>
                <td>
                    <label >WeekStart</label>
                </td> 
                <td>
                    <select id="Week">
                        <option value="1">Mon</option>
                        <option value="2">Tue</option>
                        <option value="3">Wed</option>
                        <option value="4">Thr</option>
                        <option value="5">Fri</option>
                        <option value="6">Sat</option>
                        <option value="7">Sun</option>
                    </select>                      
                </td>
                <td>
                    <label >Working Days</label>
                </td> 
                <td>
                    <select id="WDays">
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                    </select>                      
                </td>

           </tr> 
           <tr>
                <td>
                    <label >Leave Applicable</label>
                </td> 
                <td>
                    <select id="ALeave">
                        <option value="2">Select</option>
                        <option value="0">No</option>
                        <option value="1">Yes</option>
                    </select>                
                </td>
                <td>
                    <label >Leave Type</label>
                </td> 
                <td>
                    <select id="TLeave">
                        <option value="0">Select</option>
                        <option value="1">HourWise</option>
                        <option value="2">DayWise</option>
                    </select>                    
                </td>
                <td>
                    <label >Calculation</label>
                </td> 
                <td>
                    <select id="CLeave">
                        <option value="0">Select</option>
                        <option value="1">Calender Year</option>
                        <option value="2">Financial Year</option>
                    </select>

                </td>

           </tr> 
        </table>
        <div>
            <input id="BtnSave" type="button" value ="Save" class="cssButton" />
            <input id="BtnCancel" type="button" value ="Cancel"  class="cssButton" />
        </div>





    </div>
 </asp:Content>

