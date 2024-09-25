<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Staff.ascx.cs" Inherits="controls_Staff" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>

<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<script src="../jquery/dist/jquery.contextMenu.js" type="text/javascript"></script>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>

<script type="text/javascript">
    $(document).ready(function () {
        $("[id*=hdnPages]").val(1);
        $("[id*=hdnpageIndex]").val(25);
        GetLeftStaff();

        $("[id*=btnSearch]").on('click', function () {
            GetLeftStaff();
        });

    });

    function GetLeftStaff() {
        var Compid = $("[id*=hdnCompid]").val();
        var Srch = $("[id*=txtsearch]").val();
        var PageIndex = $("[id*=hdnPages]").val();
        var PageSize = $("[id*=hdnpageIndex]").val();
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/wsStaff.asmx/GetLeftStaff",
            data: '{compid:' + Compid + ',srch: "' + Srch + '",pageindex: ' + PageIndex + ',pagesize:' + PageSize + '}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);

                var tbody = '';
                var tbl = '';
                $("[id*=tblleftstaff] tbody").empty();
                tbody = tbody + "<tr>" + "<th class='auto-style4'>Sr.No</th><th class='auto-style3'>Staff Name</th><th class='auto-style3'>Designation</th><th class='auto-style4'>Department</th>";
                tbody = tbody + "<th class='auto-style4'>Total Time</th><th class='auto-style4'>Date Of Joining</th><th class='auto-style4'>Date Of Leaving</th>";
                tbody = tbody + "<th class='auto-style4'>Edit</th>";
                tbody = tbody + "</tr>";
                if (myList == null) {
                } else {
                    if (myList.length == 0) {
                        tbl = tbl + "<tr>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td >" + 'No Records Found...' + "</td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "<td ></td>";
                        tbl = tbl + "</tr>";
                        tbody = tbody + tbl;
                        $("[id*=tblleftstaff]").append(tbody);
                    }
                    else {
                        if (myList.length > 0) {
                            var record = myList[0].list_RecordCount;
                            for (var i = 0; i < myList.length; i++) {
                                tbl = tbl + "<tr>";
                                tbl = tbl + "<td style='text-align: center;'>" + myList[i].Srno + "</td>";
                                tbl = tbl + "<td >" + myList[i].StaffName + "<input type='hidden' id='hdnstaffcode' name='hdnstaffcode' value='" + myList[i].StaffCode + "'>" + "</td>";
                                tbl = tbl + "<td >" + myList[i].designation + "</td>";
                                tbl = tbl + "<td >" + myList[i].DepartmentName + "</td>";
                                tbl = tbl + "<td style='text-align: center;'>" + myList[i].Total + "</td>";
                                tbl = tbl + "<td >" + myList[i].DateOfJoining + "</td>";
                                tbl = tbl + "<td style='width: 20px;'>" + "<input type='text' id='txtleavedate' name='txtleavedate' class='cssTextbox' value='" + myList[i].DateOfLeaving + "' disabled>" + "</td>";
                                tbl = tbl + "<td >" + "<img id='imgedit' name='imgedit' src='../images/edit.png'  class='edit' onclick='StaffEdit($(this))'/>" + "<div id='dvupdate' name='dvupdate' style='display:none; text-align-last: center;' ><input type='button' id='btnupdate' name='btnupdate' onclick='Updatestaff($(this))' value='Update' class='cssButton'><input type='button' value='Cancel' onclick='Cancelstaff($(this))' class='cssButton'></div>" + "</td>";
                                tbl = tbl + "</tr>";
                            }
                            tbody = tbody + tbl;
                            $("[id*=tblleftstaff]").append(tbody);
                            $('.loader').hide();

                            if (record[0].RecordCount != '') {
                                var RecordCount = parseFloat(record[0].RecordCount);
                                Pager(RecordCount);
                            }

                        }

                        else {
                            tbl = tbl + "<tr>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td >" + 'No Records Found...' + "</td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "<td ></td>";
                            tbl = tbl + "</tr>";
                            tbody = tbody + tbl;
                            $("[id*=tblleftstaff]").append(tbody);
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

    function StaffEdit(i) {
        var row = i.closest("tr")
        var rIndex = i.closest("tr")[0].sectionRowIndex;
        $("#txtleavedate", row).attr("disabled", false);
        $("#imgedit", row).hide();
        $("#dvupdate", row).show();
    }

    function Cancelstaff(i) {
        var row = i.closest("tr")
        var rIndex = i.closest("tr")[0].sectionRowIndex;
        $("#txtleavedate", row).attr("disabled", true);
        $("#imgedit", row).show();
        $("#dvupdate", row).hide();
    }

    function Updatestaff(i) {
        var row = i.closest("tr")
        var staffcode = $("#hdnstaffcode", row).val();
        var leavedate = $("#txtleavedate", row).val();
        if (leavedate == '') {
            UpdatefuncstaffLeave(staffcode);
        }
        else {
            alert("Please make it blank and update");
        }
    }

    function UpdatefuncstaffLeave(staffcode) {
        var Compid = $("[id*=hdnCompid]").val();
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/wsStaff.asmx/UpdateleftStaff",
            data: '{compid:' + Compid + ',Staffcode: ' + staffcode + '}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length > 0) {
                    if (myList[0].id == '1') {
                        alert("Date Of Leaving Upadeted Successfully!!!");
                        GetLeftStaff();
                    } else {

                    }
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

    ///validetion given to the textbox
    function CountFrmTitle(field, max) {
        if (field.value.length > max) {
            field.value = field.value.substring(0, max);
            alert("You are exceeding the maximum limit");
        }
        else {
            field.value = field.value.replace(/[?\#!$%\^\*;:{}=\_`~@"'+]/g, "");
            var count = max - field.value.length;
        }
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
            GetLeftStaff(($(this).attr('page')), 25);
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
        overflow: hidden;
        width: 970px;
        height: 23px;
    }

    .headerpage {
        height: 23px;
    }

    .divspace {
        height: 20px;
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
       .cssTextbox
{
    font: normal 12px verdana, arial, "Trebuchet MS" , sans-serif;
    height: 15px;
    border-radius: 4px;
    border: 1px solid #b5b5b5;
}

.cssTextboxLong
{
    font: normal 12px verdana, arial, "Trebuchet MS" , sans-serif;
    width: 350px;
    height: 25px;
    border-radius: 4px;
    border: 1px solid #b5b5b5;
}
.cssTextbox:focus
{
    box-shadow: 0 0 5px rgba(81, 203, 238, 1);
    padding: 3px 0px 3px 3px;
    border: 1px solid rgba(81, 203, 238, 1);
}

.cssTextbox:hover
{
    border: 1px solid rgba(81, 203, 238, 1);
}

.cssTextboxInt
{
    font: normal 12px verdana, arial, "Trebuchet MS" , sans-serif;
    height: 25px;
    text-align: right;
    border-radius: 4px;
    border: 1px solid #b5b5b5;
    padding-right: 5px;
}

.cssTextboxInt:focus
{
    box-shadow: 0 0 5px rgba(81, 203, 238, 1);
    padding-right: 5px;
    border: 1px solid rgba(81, 203, 238, 1);
}

.cssTextboxInt:hover
{
    padding-right: 5px;
    border: 1px solid rgba(81, 203, 238, 1);
}
</style>

<div class="divstyle" style="height: auto">
    <div class="headerpage">
        <div>
             <table style="width: 100%" class="cssPageTitle">
                    <tr>
                        <td class="cssPageTitle2">
                            <asp:Label ID="Label1" runat="server" Style="margin-left: 0px;" Text="Left Staff"></asp:Label>
                        </td>                        
                    </tr>
                </table>      
          
        </div>
    </div>
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField ID="hdnPages" runat="server" />
    <asp:HiddenField ID="hdnpageIndex" runat="server" />


    <div id="Div4" runat="server" class="masterdiv1a">
        <div style="width: 100%; float: left">
            <uc1:MessageControl ID="MessageControl" runat="server" />
            <div class="divspace"></div>
            <div style="float: left; width: 100%; margin: 10px; padding-bottom: 5px; overflow: auto;">
                <%--<asp:Panel ID="panel3" runat="server" DefaultButton="btnsearch">--%>
                <div style="float: left; width: 98%; padding-left: 1px">
                    <div id="searchStf" runat="server" style="float: left; width: 100%; padding-bottom: 5px;">
                        <div style="float: left;" class="serachJob">
                            <asp:Label ID="Label24" runat="server" Text="Search Staff" CssClass="LabelFontStyle labelChange"></asp:Label>&nbsp;&nbsp;
                        <asp:TextBox ID="txtsearch" runat="server" Width="250px" CssClass="cssTextbox"
                            Font-Names="Verdana" Font-Size="8pt"></asp:TextBox>
                            <input id="btnSearch" type="button" class="cssButton" value="Search" />
                        </div>
                    </div>
                </div>


                <%--</asp:Panel>--%>
            </div>
            <%--<div class="divspace"></div>--%>
            <div>


                <%--<div style ="float:left;width:68%;padding-left:10px"></div>
                   <div style ="float:right;padding-top:5px;">
    
                    </div>--%>
                <asp:Panel ID="Panel11" runat="server" Width="100%">
                    <table id="tblleftstaff" cellspacing="0" class="norecordTble" border="1" style="border-collapse: collapse; width: 100%;">
                        <thead>
                        </thead>
                    </table>
                    <table id="tblPager" style="border: 1px solid #BCBCBC; border-bottom: none; background-color: rgba(219,219,219,0.54); text-align: right;"
                        cellpadding="2" cellspacing="0" width="1200px">
                        <tr>
                            <td>
                                <div class="Pager">
                                </div>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>

        </div>


    </div>



    <div id="Div1" class="totbodycatreg">

        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>

        <asp:SqlDataSource ID="SqlDataSource12" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>

    </div>
</div>
