<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Report_JobWisePeriod.ascx.cs" Inherits="controls_Report_JobWisePeriod" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>

<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../jquery/jquery-1.8.2.min.js"></script>
<script language="javascript" type="text/javascript">
    $(document).ready(function () {

        $(".dropdown dt a").on('click', function () {
            $(".dropdown dd ul").slideToggle('fast');
        });

        $(".dropdown dd ul li a").on('click', function () {
            $(".dropdown dd ul").hide();
        });

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


        ///////barnch change staff selected
        $("[id*=ddlBranch]").on('change', function () {
            Onpagefilterloads();
            var ddl = document.getElementById("<%=ddlBranch.ClientID%>");
            $("[id*=hdnbranch]").val(ddl.options[ddl.selectedIndex].text);
        });

        ////check all Jobs
        $("[id*=chkAjob]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clJob").attr('checked', 'checked');
            }
            else {
                $(".clJob").removeAttr('checked');
            }
            $('.modalganesh').css('display', 'none');
        });


        /////////check all staff
        $("[id*=chkAstaff]").on("click", function () {
            $('.modalganesh').css('display', 'block');
            if ($(this).attr('checked')) {
                $(".clstaff").attr('checked', 'checked');
            }
            else {
                $(".clstaff").removeAttr('checked');
            }
            singlestaffcheck();
            $('.modalganesh').css('display', 'none');
        });

        $("[id*=chkAjob]").on("click", function () {
            if ($(this).attr('checked')) {
                $(".clJob").attr('checked', 'checked');
            }
            else {
                $(".clJob").removeAttr('checked');
            }

        });

        /////////filter month wise
        $("[id*=txtmonth]").on("change", function () { Onpagefilterloads(); });
        $("[id*=ddlType]").on("change", function () { Onpagefilterloads(); });
        Get_All_Staff_Client_Project_BranchName();
        Get_All_Staff_Client_Project_DepartmentName();
        Onpagefilterloads();

        $("[id*=btngen]").on("click", function () {
            var selectStaff1 = '';
            $(".clstaff:checked").each(function () {
                selectStaff1 += $(this).val() + ',';
            });
            $("[id*=hdnstaffcode]").val(selectStaff1);
            GetAllSelected();
            $("[id*=hdntype]").val($("[id*=ddlType]").val());
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
    });



    /////////Bind Department


    function Get_All_Staff_Client_Project_DepartmentName() {
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Projectstaff.asmx/Get_All_Staff_Client_Project_DepartmentName",
            data: '{compid:' + $("[id*=hdnCompid]").val() + '}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                var DeptList = '<ul>';
                if (myList.length == 0) { }
                else {
                    if (myList == null) { }
                    else {

                        for (var i = 0; i < myList.length; i++) {

                            DeptList = DeptList + "<li> <input type='checkbox' class='clDept' onclick='SelectSingleDepartment()' value='" + myList[i].DeptId + "' />" + myList[i].DepartmentName + "</li>";
                        }
                        DeptList = DeptList + "</ul>";
                        $("[id*=Dv_Department]").html(DeptList);
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

    function SelectSingleDepartment() {
        var DeptId = '';
        $(".clDept:checked").each(function () {
            DeptId += $(this).val() + ',';
        });
        $("[id*=hdnDeptId]").val(DeptId);
        onpageclientProjectload();

    }
    ///////get statuswise filter
    function TStatusCheck() {
        var selectedTStatus = '';
        var count = 0;

        var sbu = $("[id*=chkSubmitted]");
        if (sbu.attr('checked'))
        { count += 1; selectedTStatus += "Submitted,"; }

        sbu = $("[id*=chkSaved]");
        if (sbu.attr('checked'))
        { count += 1; selectedTStatus += "Saved,"; }

        sbu = $("[id*=chkApproved]");
        if (sbu.attr('checked'))
        { count += 1; selectedTStatus += "Approved,"; }


        sbu = $("[id*=chkRejected]");
        if (sbu.attr('checked'))
        { count += 1; selectedTStatus += "Rejected,"; }

        if (count == 4)
        { $("[id*=chkTStatusAll]").attr('checked', 'checked'); }
        else { $("[id*=chkTStatusAll]").removeAttr('checked'); }

        if (selectedTStatus == '') {
            $("[id*=chkApproved]").attr('checked', 'checked');
            selectedTStatus = 'Approved';
        }
        $("[id*=hdnTStatusCheck]").val(selectedTStatus);
        Onpagefilterloads();
    }

    ///////////////on page load data functions
    var clientwise = false, projectwise = false, staffwise = true, jobwise = false;
    function Onpagefilterloads() {
        staffwise = true, jobwise = false;
        //        $("[id*=chkAclient]").removeAttr('checked');
        //        $("#chkAclient").parent().find('label').text("Check All Clients (Count : 0)").addClass("labelChange");
        //        $("[id*=chkAproject]").removeAttr('checked');
        //        $("#chkAproject").parent().find('label').text("Check All Projects (Count : 0)").addClass("labelChange");
        $("[id*=chkAstaff]").removeAttr('checked');
        $("#chkAstaff").parent().find('label').text("Check All Staffs (Count : 0)").addClass("labelChange");
        $("[id*=chkAjob]").removeAttr('checked');
        $("[id*=chkAjob]").parent().find('label').text("Check All Job (Count : 0)").addClass("labelChange");
        $("[id*=Dvjob]").html("");
        onpageclientProjectload();
    }
    function onpageclientProjectload() {
        GetAllSelected();
        if (staffwise) {
            //            $("[id*=hdncltid]").val('');
            //$("[id*=hdnprojectid]").val('');
            $("[id*=hdnstaffcode]").val('Empty');
        }
        var compid = parseFloat($("[id*=hdnCompid]").val());
        //        var cltid = $("[id*=hdncltid]").val();
        //        var projectid = $("[id*=hdnprojectid]").val();
        var selectedstaffcode = $("[id*=hdnstaffcode]").val();
        if ($("[id*=txtmonth]").val() == "" || $("[id*=txtmonth]").val() == undefined) {
            return false;
        }

        $(".modalganesh").show();

        var data = {
            currobj: {
                compid: compid,
                UserType: $("[id*=hdnUserType]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                StaffCode: $("[id*=hdnstaffid]").val(),
                selectedstaffcode: selectedstaffcode,
                selectetdcltid: 0,
                selectedprojectid: 0,
                staffwise: staffwise,
                clientwise: clientwise,
                projectwise: projectwise,
                jobwise: jobwise,
                frommonth: $("[id*=txtmonth]").val(),
                Type: $("[id*=ddlType]").val(),
                RType: 'staff',
                BrId: $("[id*=ddlBranch]").val(),
                selectedDeptid: $("[id*=hdnDeptId]").val()
            }
        };
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/Projectstaff.asmx/Get_Staff_Client_Project_All_Selected",
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
        var tableRowsstaff = '', tableRowsclient = '', tableRowsProject = '', tableRowsJobs = '';
        var countstafff = 0, countclient = 0, countProject = 0, countJob = 0;
        $.each(obj, function (i, vl) {
            if (vl.Type == "staff") {
                countstafff += 1;
                tableRowsstaff += "<tr><td><input type='checkbox'  onclick='singlestaffcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
            //            else if (vl.Type == "client") {
            //                countclient += 1;
            //                tableRowsclient += "<tr><td><input type='checkbox' checked='checked'  onclick='singleclientcheck()' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            //            }
            //            else if (vl.Type == "Project") {
            //                countProject += 1;
            //                tableRowsProject += "<tr><td><input type='checkbox' onclick='singleprojectcheck()' checked='checked' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            //            }
            else if (vl.Type == "Job") {
                countJob += 1;
                tableRowsJobs += "<tr><td><input type='checkbox' checked='checked' class='cl" + vl.Type + "' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr>";
            }
        });

        //        if (clientwise) {
        //            if (countclient != 0)
        //                $("[id*=chkAclient]").attr('checked', 'checked');
        //            else
        //                $("[id*=chkAclient]").removeAttr('checked');

        //            $("[id*=DvClient]").parent().find('label').text("Check All Clients (Count : " + countclient + ")").addClass("labelChange");
        //            $("[id*=DvClient]").html("<table>" + tableRowsclient + "</table>");
        //        }
        //        if (projectwise) {

        //            if (countProject != 0)
        //                $("[id*=chkAproject]").attr('checked', 'checked');
        //            else
        //                $("[id*=chkAproject]").removeAttr('checked');

        //            $("[id*=DvProject]").parent().find('label').text("Check All Projects (Count : " + countProject + ")").addClass("labelChange");
        //            $("[id*=DvProject]").html("<table>" + tableRowsProject + "</table>");
        //        }
        if (staffwise) {

            $("[id*=chkAstaff]").removeAttr('checked');
            $("[id*=chkAstaff]").parent().find('label').text("Check All Staffs (Count : " + countstafff + ")");
            $("#chkAstaff").parent().find('label').addClass("labelChange");
            $("[id*=dvstaff]").html("<table>" + tableRowsstaff + "</table>");
        }
        $(".modalganesh").hide();

        if (jobwise) {
            if (countJob != 0)
                $("[id*=chkAjob]").attr('checked', 'checked');
            else
                $("[id*=chkAjob]").removeAttr('checked');


            $("[id*=chkAjob]").parent().find('label').text("Check All Job (Count : " + countJob + ")");
            $("#chkAjob").parent().find('label').addClass("labelChange");
            $("[id*=Dvjob]").html("<table>" + tableRowsJobs + "</table>");
        }
        $(".modalganesh").hide();
    }

    ////check single staff
    function singlestaffcheck() {
        if ($(".clstaff").length == $(".clstaff:checked").length)
        { $("[id*=chkAstaff]").attr('checked', true); }
        else { $("[id*=chkAstaff]").removeAttr('checked'); }
        staffwise = false, clientwise = true, projectwise = true, jobwise = true;
        onpageclientProjectload();
    }
    //    //////check single client
    //    function singleclientcheck() {
    //        if ($(".clclient").length == $(".clclient:checked").length)
    //        { $("[id*=chkAclient]").attr('checked', true); }
    //        else { $("[id*=chkAclient]").removeAttr('checked'); }
    //        staffwise = false, clientwise = false, projectwise = true, jobwise = true;
    //        onpageclientProjectload();
    //    }
    //    //////check single project
    //    function singleprojectcheck() {
    //        if ($(".clProject").length == $(".clProject:checked").length)
    //        { $("[id*=chkAproject]").attr('checked', true); }
    //        else { $("[id*=chkAproject]").removeAttr('checked'); }
    //        staffwise = false, clientwise = false, projectwise = false, jobwise = true;
    //        onpageclientProjectload();
    //    }

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


    function GetAllSelected() {
        var selectStaff = '', selectclient = '', selectproject = '', selectjobs = '';
        $(".clstaff:checked").each(function () {
            selectStaff += $(this).val() + ',';
        });
        //        $(".clclient:checked").each(function () {
        //            selectclient += $(this).val() + ',';
        //        });
        //        $(".clProject:checked").each(function () {
        //            selectproject += $(this).val() + ',';
        //        });
        $(".clJob:checked").each(function () {
            selectjobs += $(this).val() + ',';
        });
        $("[id*=hdnstaffcode]").val(selectStaff);
        //        $("[id*=hdncltid]").val(selectclient);
        //        $("[id*=hdnprojectid]").val(selectproject);
        $("[id*=hdnjobids]").val(selectjobs);
    }

    function CountFrmTitle(field, max) {
        if (field.value.length > max) {
            field.value = field.value.substring(0, max);
            alert("You are exceding the maximum limit");
        }
        else {
            field.value = field.value.replace(/[?\#!$%\^\*;:{}=\_`~@"'+]/g, "");
            var count = max - field.value.length;
        }
    }

</script>
<style type="text/css">
    .style1
    {
        width: 663px;
    }
    .style2
    {
        width: 422px;
    }
    .style3
    {
        width: 128px;
    }
    



i {
    border: solid black;
    border-width: 0 3px 3px 0;
    display: inline-block;
    padding: 3px;
}
.right {
    transform: rotate(45deg);
    -webkit-transform: rotate(45deg);
}
.AStyle {
  color: Black;
  background: none repeat scroll 0 0 #fbfbfb;
  border:1px solid #cccccc;
}

.dropdown dd,
.dropdown dt {
  margin: 0px;
  padding: 0px;
  border:1px;
  border-color:Black;
}

.dropdown ul {
  margin: -1px 0 0 0;
  background-color:#fbfbfb;
}

.dropdown dd {
  position: relative;
}

.dropdown a,
.dropdown a:visited {

  text-decoration: none;
  outline: none;
  font-size: 12px;
}

.dropdown dt a {
 
  display: block;
  padding: 8px 20px 5px 10px;
  min-height: 15px;

  overflow: hidden;
  border: 1px;
  width: 272px;
}


.multiSel span {
  cursor: pointer;
  display: inline-block;
  padding: 0 3px 2px 0;
}

.dropdown dd ul {
  
  border: 1px;

  display: none;
  left: 0px;
  padding: 2px 15px 2px 5px;
  position: absolute;
  top: 2px;
  width: 280px;
  list-style: none;
  height: auto;
  overflow: auto;
}

.dropdown span.value {
  display: none;
}

.dropdown dd ul li a {
  padding: 5px;
  display: block;
  color:Black;
  
}

.dropdown dd ul li a:hover {
  background-color: #fff;
}

button {
  background-color: #6BBE92;
  width: 302px;
  border: 0;
  padding: 10px 0;
  margin: 5px 0;
  text-align: center;
  color: #fff;
  font-weight: bold;
}

</style>
<div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
    <asp:Label ID="Label1" runat="server" Text="Job Wise Project" CssClass="Head1 labelChange"></asp:Label>
    <div style="float: right;">
        <asp:Button ID="btnBack" runat="server" CssClass="TbleBtns" Text="Back" Visible="false"
            OnClick="btnBack_Click" />
    </div>
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdncltid" />
    <asp:HiddenField runat="server" ID="hdnprojectid" />
    <asp:HiddenField runat="server" ID="hdnstaffcode" />
    <asp:HiddenField runat="server" ID="hdnUserType" />
    <asp:HiddenField runat="server" ID="hdnstaffid" />
    <asp:HiddenField runat="server" ID="hdnjobids" />
    <asp:HiddenField runat="server" ID="hdntype" />
    <asp:HiddenField runat="server" ID="hdnbranch" Value="0" />
    <asp:HiddenField runat="server" ID="hdnDeptId" Value="" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
</div>
<div class="divstyle">
    <div id="div2" class="totbodycatreg" style="height: 700px;">
        <div style="width: 100%;">
            <uc2:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div runat="server" id="divReportInput">
            <table width="1100px;" style="padding-left: 85px; padding-top: 15px;">
                <tr>
                    <td>
                        <asp:Label ID="lblBranch" Font-Bold="true" runat="server">Branch</asp:Label>
                    </td>
                    <td valign="middle" align="center">
                        :
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlBranch" CssClass="texboxcls" runat="server">
                            <asp:ListItem Value="0" Text="Select Branch"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td valign="middle" style="width: 120px">
                        <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status" Font-Bold="True"></asp:Label>
                    </td>
                    <td valign="middle" align="center">
                        :
                    </td>
                    <td valign="middle" style="width: 500px">
                        <asp:CheckBox ID="chkTStatusAll" ClientIDMode="Static" runat="server" Checked="true"
                            Text="All" />&nbsp;&nbsp;
                        <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server" Checked="true"
                            onclick="TStatusCheck()" Text="Submitted" />&nbsp;&nbsp;
                        <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static" Checked="true" onclick="TStatusCheck()"
                            Text="Saved" />&nbsp;&nbsp;
                        <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()" Checked="true"
                            ClientIDMode="Static" Text="Approved" />&nbsp;&nbsp;
                        <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()" Checked="false"
                            ClientIDMode="Static" Text="Rejected" style='display:none;'/>
                    </td>
                    <td>
                        <asp:Button ID="btngen" runat="server" OnClick="btngen_Click" CssClass="TbleBtns"
                            Text="Generate Report" />
                    </td>
                    <td>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        <label style="font-weight: bold">
                           Month</label>
                    </td>
                    <td>
                        :
                    </td>
                    <td>
                         <asp:TextBox ID="txtmonth" runat="server" Width="50px" CssClass="texboxcls" ></asp:TextBox>
                        <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" />
                        <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtmonth"
                            PopupButtonID="Img1" Format="MM/yyyy">
                        </cc1:CalendarExtender>
                    </td>
                    <td>
                        <asp:Label ID="Label3" runat="server" ForeColor="Black" Text="Department" Font-Bold="True"></asp:Label>
                    </td>
                    <td valign="middle" align="center">
                        :
                    </td>
                    <td>
                    <div id="dvDepartment" tabindex="-1">
                        <dl id="dlDept" class="dropdown">
                            <dt><a href="#" class="AStyle texboxcls "><span class="hida">Select Department</span>
                                <i class="arrow right" style="float: right;"></i></a></dt>
                            <dd>
                                <div id="Dv_Department" class="mutliSelect">
                                    <ul>
                                        <li>
                                            <input type="checkbox" value="0" />Select</li>
                                    </ul>
                                </div>
                            </dd>
                        </dl>
                        </div>
                    </td>
                    <td>
                        <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Type" Font-Bold="True"></asp:Label>
                    </td>
                    <td>
                        :
                    </td>
                    <td>
                        <select id="ddlType" class="texboxcls" style="width: 90px;">
                            <option value="All">All</option>
                            <option value="1">Billable</option>
                            <option value="0">Non Billable</option>
                        </select>
                    </td>
                    <td>
                </tr>
            </table>
            <table class="style1" style="padding-left: 65px;">
                <tr>
                    <td>
                        <table>
                            <tr>
                                <%--staff selection div--%>
                                <td style="width: 450px;">
                                    <asp:CheckBox ID="chkAstaff" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                        Text=" Check All Staff (Count : 0)" CssClass="labelChange" />
                                    <div id="dvstaff" style="border: 1px solid #B6D1FB; width: 98%; height: 450px; overflow: auto;">
                                    </div>
                                </td>
                                <%--  job selection div--%>
                                <td style="width: 450px;">
                                    <asp:CheckBox ID="chkAjob" runat="server" ForeColor="Black" Font-Bold="true" Height="20px"
                                        Text=" Check All job (Count : 0)" CssClass="labelChange" />
                                    <div id="Dvjob" style="border: 1px solid #B6D1FB; width: 150%; height: 450px; overflow: auto;">
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
