<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Report_ProjectHours.ascx.cs" Inherits="controls_Report_ProjectHours" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<%--//////page created by Anil Gajre on 30/01/2018--%>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {


        $("[id*=chkTStatusAll]").on("click", function () {
            if ($(this).attr('checked')) {
                $("[id*=chkSubmitted]").attr('checked', 'checked');
                $("[id*=chkSaved]").attr('checked', 'checked');
                $("[id*=chkApproved]").attr('checked', 'checked');
                $("[id*=chkRejected]").attr('checked', 'checked');
            }
            else {
                $("[id*=chkSubmitted]").removeAttr('checked');
                $("[id*=chkSaved]").removeAttr('checked');
                $("[id*=chkApproved]").removeAttr('checked');
                $("[id*=chkRejected]").removeAttr('checked');
            }
            TStatusCheck();
        });
        $("[id*=txtmonth]").on("change", function () {
         
        //    var dt = new Date($(this).val());
        //     var month = dt.getMonth(),
        //    year = dt.getFullYear();
           
        //// GET THE FIRST AND LAST DATE OF THE MONTH.
        //   var FirstDay = new Date(year, month, 1);
        //    var LastDay = new Date(year, month + 1, 0);
           
        //    $("[id*=hdnstartdate1]").val(FirstDay.toDateString('dd/mon/yyyy'));
        //    $("[id*=hdnenddate2]").val(LastDay.toDateString('dd/mon/yyyy'));

            Onpagefilterloads();
        });
        //$("[id*=txtenddate2]").on("change", function () {
        //    Onpagefilterloads();
        //});
        Get_All_Staff_Client_Project_BranchName();
        $("[id*=ddlType]").on("change", function () { Onpagefilterloads(); });
        ///////barnch change staff selected
        $("[id*=ddlBranch]").on('change', function () {
            Onpagefilterloads();
            var ddl = document.getElementById("<%=ddlBranch.ClientID%>");
            $("[id*=hdnbranch]").val(ddl.options[ddl.selectedIndex].text);
        });
        Onpagefilterloads();
        $("[id*=btngen]").on("click", function () {
            var selectStaff1 = '';
            $(".cldept:checked").each(function () {
                selectStaff1 += $(this).val() + ',';
            });
            $("[id*=hdnstaffcode]").val(selectStaff1);
            GetAllSelected();
            $("[id*=hdntype]").val($("[id*=ddlType]").val());
            $("[id*=hdnBrId]").val($("[id*=ddlBranch]").val());
        });
        $("[id*=btnBack]").on("click", function () { $(".modalganesh").show(); });

        $("[id*=btnCSV]").on("click", function () {
            $(".modalganesh").show();
            var selectStaff1 = '';
            $(".clstaff:checked").each(function () {
                selectStaff1 += $(this).val() + ',';
            });
            $("[id*=hdnstaffcode]").val(selectStaff1);
            GetAllSelected();
            $("[id*=hdntype]").val($("[id*=ddlType]").val());
            $(".modalganesh").hide();
        });


        $("[id*=chkclient]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clclient").each(function () {
                    $(this).attr('checked', 'checked');
                });
            }
            else {
                $(".clclient:checked").each(function () {
                    $(this).removeAttr('checked');
                });
            }
            singleclientcheck();
            $('.modalganesh').css('display', 'none');
        });


        $("[id*=chkproject]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clProject").each(function () {
                    $(this).attr('checked', 'checked');
                });

            }
            else {
                $(".clProject:checked").each(function () {
                    $(this).removeAttr('checked');
                });
            }
            $('.modalganesh').css('display', 'none');

        });

        $("[id*=chkdept]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".cldept").each(function () {
                    $(this).attr('checked', 'checked');
                });
            }
            else {
                $(".cldept:checked").each(function () {
                    $(this).removeAttr('checked');
                });
            }
            singledeptcheck();
            $('.modalganesh').css('display', 'none');
        });
    });

    function Get_All_Staff_Client_Project_BranchName() {
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Projectstaff.asmx/Get_All_Staff_Client_Project_BranchName",
            data: '{compid:' + $("[id*=hdnCompid]").val() + '}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length == 0) { }
                else {
                    if (myList == null) { }
                    else {
                        $("[id*=ddlBranch]").empty();
                        $("[id*=ddlBranch]").append("<option value=" + 0 + ">Select Branch</option>");
                        for (var i = 0; i < myList.length; i++) {
                            $("[id*=ddlBranch]").append("<option value=" + myList[i].BrId + ">" + myList[i].Branch + "</option>");
                        }

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

    function TStatusCheck() {
        var selectedTStatus = '';
        var count = 0;

        var sbu = $("[id*=chkSubmitted]");
        if (sbu.attr('checked')) { count += 1; selectedTStatus += "Submitted,"; }

        sbu = $("[id*=chkSaved]");
        if (sbu.attr('checked')) { count += 1; selectedTStatus += "Saved,"; }

        sbu = $("[id*=chkApproved]");
        if (sbu.attr('checked')) { count += 1; selectedTStatus += "Approved,"; }


        sbu = $("[id*=chkRejected]");
        if (sbu.attr('checked')) { count += 1; selectedTStatus += "Rejected,"; }

        if (count == 4) { $("[id*=chkTStatusAll]").attr('checked', 'checked'); }
        else { $("[id*=chkTStatusAll]").removeAttr('checked'); }

        if (selectedTStatus == '') {
            $("[id*=chkApproved]").attr('checked', 'checked');
            selectedTStatus = 'Approved';
        }
        $("[id*=hdnTStatusCheck]").val(selectedTStatus);
        Onpagefilterloads();
    }

    function GetAllSelected() {
        var selectclient = '', selectproject = '', selectdept = '';
        $(".clclient:checked").each(function () {
            selectclient += $(this).val() + ',';
        });
        $(".clProject:checked").each(function () {
            selectproject += $(this).val() + ',';
        });
        $(".cldept:checked").each(function () {
            selectdept += $(this).val() + ',';
        });
        $("[id*=hdnselectedclientid]").val(selectclient);
        $("[id*=hdnselectedprojectid]").val(selectproject);
        $("[id*=hdnselecteddept]").val(selectdept);
    }


    function singleclientcheck() {
        if ($(".clclient").length == $(".clclient:checked").length) { $("[id*=chkclient]").attr('checked', true); }
        else { $("[id*=chkclient]").removeAttr('checked'); }
        deptwise = false, clientwise = false, projectwise = true;
        onpageclientProjectload();
    }
    //    //////check single project
    //    function singleprojectcheck() {
    //        if ($(".clProject").length == $(".clProject:checked").length)
    //        { $("[id*=chkproject]").attr('checked', true); }
    //        else { $("[id*=chkproject]").removeAttr('checked'); }
    //        needclient = false, needproject = false, needdept = true;
    //        onpageclientProjectload();
    //    }

    //////check single department 
    function singledeptcheck() {
        if ($(".cldept").length == $(".cldept:checked").length) { $("[id*=chkdept]").attr('checked', true); }
        else { $("[id*=chkdept]").removeAttr('checked'); }
        deptwise = false, clientwise = true, projectwise = true;
        onpageclientProjectload();
    }


    var clientwise = false, projectwise = false, deptwise = true;

    function Onpagefilterloads() {
        clientwise = false, projectwise = false, deptwise = true;
        $("[id*=chkdept]").removeAttr('checked');
        $("[id*=chkdept]").parent().find('label').text("Check All Departments (Count : 0)");
        $("[id*=chkclient]").removeAttr('checked');
        $("[id*=chkclient]").parent().find('label').text("Check All Clients (Count : 0)");
        $("[id*=chkproject]").removeAttr('checked');
        $("[id*=chkproject]").parent().find('label').text("Check All Projects (Count : 0)");
        onpageclientProjectload();
    }


    //////////////////////////////////////////////Get All Department Client Project////////////////////////////////////
    function onpageclientProjectload() {
        GetAllSelected();
        if (deptwise) {
            $("[id*=hdnselectedclientid]").val('');
            //$("[id*=hdnprojectid]").val('');
            $("[id*=hdnselecteddept]").val('Empty');
        }
        var month = $("[id*=txtmonth]").val();
        var compid = parseFloat($("[id*=hdnCompid]").val());
        var cltid = $("[id*=hdnselectedclientid]").val();
        var projectid = $("[id*=hdnselectedprojectid]").val();
        var selectedDeptid = $("[id*=hdnselecteddept]").val();
        //if ($("[id*=txtstartdate1]").val() == "" || $("[id*=txtstartdate1]").val() == undefined) {
        //    return false;
        //}
        //if ($("[id*=txtenddate2]").val() == "" || $("[id*=txtenddate2]").val() == undefined) {
        //    return false;
        //}

        $(".modalganesh").show();

        var data = {
            currobj: {
                compid: compid,
                UserType: $("[id*=hdnUserType]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                StaffCode: $("[id*=hdnStaffCode]").val(),
                selectedDeptid: selectedDeptid,
                selectetdcltid: cltid,
                selectedprojectid: projectid,
                deptwise: deptwise,
                clientwise: clientwise,
                projectwise: projectwise,
                fromdate: month,
                todate: month,
                //fromdate: $("[id*=hdnstartdate1]").val(),
                //todate: $("[id*=hdnenddate2]").val(),
                Type: $("[id*=ddlType]").val(),
                RType: 'Dept',
                BrId: $("[id*=ddlBranch]").val()
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Projectstaff.asmx/Get_Dept_Client_Project_All_Selected",
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

    function OnSuccess(response) {
        var obj = jQuery.parseJSON(response.d);
        console.log(obj);
        var tableRowsstaff = '', tableRowsclient = '', tableRowsProject = '';
        var countstafff = 0, countclient = 0, countProject = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "dept") {
                countstafff += 1;
                tableRowsstaff += "<tr><td><input type='checkbox'  onclick='singledeptcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "client") {
                countclient += 1;
                tableRowsclient += "<tr><td><input type='checkbox' checked='checked'  onclick='singleclientcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            else if (vl.Type == "Project") {
                countProject += 1;
                tableRowsProject += "<tr><td><input type='checkbox' onclick='singleprojectcheck()' checked='checked' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });

        if (clientwise) {
            if (countclient != 0)
                $("[id*=chkclient]").attr('checked', 'checked');
            else
                $("[id*=chkclient]").removeAttr('checked');

            $("[id*=chkclient]").parent().find('label').text("Check All Clients (Count : " + countclient + ")");
            $("[id*=Panelclt]").html("<table>" + tableRowsclient + "</table>");
        }
        if (projectwise) {

            if (countProject != 0)
                $("[id*=chkproject]").attr('checked', 'checked');
            else
                $("[id*=chkproject]").removeAttr('checked');

            $("[id*=chkproject]").parent().find('label').text("Check All Projects (Count : " + countProject + ")");
            $("[id*=Panelprj]").html("<table>" + tableRowsProject + "</table>");
        }
        if (deptwise) {

            $("[id*=chkdept]").removeAttr('checked');
            $("[id*=chkdept]").parent().find('label').text("Check All Departments (Count : " + countstafff + ")");
            $("[id*=Paneldept]").html("<table>" + tableRowsstaff + "</table>");
        }
        $(".modalganesh").hide();
    }

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

</script>
<%--design part--%>
<div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
    <asp:Label ID="Label1" runat="server" Text="Project Summary Monthly" CssClass="Head1 labelChange"></asp:Label>
    <div style="float: right;">
        <asp:Button ID="btnBack" runat="server" CssClass="TbleBtns" Text="Back" Visible="false"
            OnClick="btnBack_Click" />
    </div>
    <asp:HiddenField runat="server" ID="hdndeptwise" />
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdnUserType" />
    <asp:HiddenField runat="server" ID="hdnSelectedStaffCode" Value="Empty" />
    <asp:HiddenField runat="server" ID="hdnselectedclientid" />
    <asp:HiddenField runat="server" ID="hdnselectedjobid" />
    <asp:HiddenField runat="server" ID="hdnselectedprojectid" />
    <asp:HiddenField runat="server" ID="hdnStaffCode" />
    <asp:HiddenField runat="server" ID="hdnselecteddept" />
    <asp:HiddenField runat="server" ID="hdntype" />
    <asp:HiddenField runat="server" ID="hdnbranch" Value="0" />
    <asp:HiddenField runat="server" ID="hdnBrId" Value="0" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
    <asp:HiddenField runat="server" ID="hdnstartdate1" />
    <asp:HiddenField runat="server" ID="hdnenddate2" />
</div>
<div class="divstyle">
    <div id="div2" class="totbodycatreg" style="height: auto;">
        <div style="width: 100%;">
            <uc2:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div class="row_report" runat="server" id="divReportInput">
            <div>
                <table class="style1" style="padding-left: 25px; padding-top: 20px;">
                    <tr>
                        <td style="vertical-align: top;">
                            <table class="style1" width="100%">
                                <tr>
                                    <td>
                                        <asp:Label ID="lblbranch" Font-Bold="true" runat="server">Branch</asp:Label>
                                    </td>
                                    <td>:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlBranch" CssClass="texboxcls" runat="server" Width="120px">
                                            <asp:ListItem Value="0" Text="Select Branch"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td valign="middle">
                                        <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="Month" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center" valign="middle">:
                                    </td>
                                    <td valign="middle">
                                        <asp:TextBox ID="txtmonth" runat="server" Width="70px" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" />
                                        <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtmonth"
                                            PopupButtonID="Img1" Format="MM/yyyy">
                                        </cc1:CalendarExtender>
                                    </td>

                                    <td valign="middle">
                                        <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td valign="middle" align="center">:
                                    </td>
                                    <td valign="middle" colspan="3">
                                        <asp:CheckBox ID="chkTStatusAll" ClientIDMode="Static" runat="server" Checked="true"
                                            Text="All" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server" Checked="true"
                                            onclick="TStatusCheck()" Text="Submitted" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static" Checked="true" onclick="TStatusCheck()"
                                            Text="Saved" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()" Checked="true"
                                            ClientIDMode="Static" Text="Approved" />&nbsp;&nbsp;
                                        <%--                                        <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()" Checked="true"
                                            ClientIDMode="Static" Text="Rejected" />--%>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 5px;"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lbltype" Font-Bold="true" runat="server">Type</asp:Label>
                                    </td>
                                    <td>:
                                    </td>
                                    <td>
                                        <select id="ddlType" class="texboxcls" style="width: 120px;">
                                            <option value="All">All</option>
                                            <option value="1">Billable</option>
                                            <option value="0">Non Billable</option>
                                        </select>
                                    </td>
                                    <td colspan="3">
                                        <asp:Button Style="margin-top: 0;" ID="btngen" runat="server" CssClass="TbleBtns"
                                            Text="Generate Report" OnClick="btngen_Click" />
                                    </td>
                                    <td colspan="3">
                                     <%--   <asp:Button ID="btnCSV" runat="server" CssClass="TbleBtns" Text="Generate CSV" Visible="false"
                                            OnClick="btnCSV_Click" />--%>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="20">
                            <table>
                                <tr>
                                    <td id="tddept" runat="server" style="width: 380px;">
                                        <asp:CheckBox ID="chkdept" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                            Text=" Check All Departments (Count : 0)" CssClass="labelChange" />
                                        <div id="Paneldept" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                        </div>
                                    </td>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkclient" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                            Text=" Check All Clients (Count : 0)" CssClass="labelChange" />
                                        <div id="Panelclt" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                        </div>
                                    </td>
                                    <td style="width: 380px;">
                                        <asp:CheckBox ID="chkproject" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                            Text=" Check All Projects (Count : 0)" CssClass="labelChange" />
                                        <div id="Panelprj" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>
