<%@ Control Language="C#" AutoEventWireup="true" CodeFile="All_Staff_Client_Project_Columnar.ascx.cs"
    Inherits="controls_All_Staff_Client_Project_Columnar" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%--  new page created by Anil Gajre on 27/01/2018 for project wise columnar report monthly detail--%>
<script src="../js/jquery.min.js" type="text/javascript"></script>
<script src="../js/bootstrap.bundle.min.js" type="text/javascript"></script>
<script src="../js/blockui.min.js" type="text/javascript"></script>
<script src="../js/ripple.min.js" type="text/javascript"></script>
<script src="../js/jgrowl.min.js" type="text/javascript"></script>
<script src="../js/pnotify.min.js" type="text/javascript"></script>
<script src="../js/noty.min.js" type="text/javascript"></script>

<script src="../js/form_select2.js" type="text/javascript"></script>
<script src="../js/d3.min.js" type="text/javascript"></script>

<script src="../jquery/moment.js" type="text/javascript"></script>
<script src="../js/interactions.min.js" type="text/javascript"></script>
<script src="../js/datatables.min.js" type="text/javascript"></script>

<script src="../js/uniform.min.js" type="text/javascript"></script>
<script src="../js/app.js" type="text/javascript"></script>
<script src="../js/select2.min.js" type="text/javascript"></script>

<script src="../js/Ajax_Pager.min.js" type="text/javascript"></script>

<script src="../js/components_modals.js" type="text/javascript"></script>
<script src="../js/echarts.min.js" type="text/javascript"></script>
<script src="../js/PopupAlert.js" type="text/javascript"></script>
<%--javascript file--%>
<script type="text/javascript">
    $(document).ready(function () {
        //  $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        $('.sidebar-main-toggle').click();
        var a = new Date();
        var dt = moment(a).format('YYYY-MM')
        $("[id*=dtmonth]").val(dt);
        $("[id*=hdnmonth]").val(dt);

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
        ////check all project
        $("[id*=chkAproject]").on("click", function () {
            var chkprop = $(this).is(':checked');

            $(".clProject").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            });
            singleprojectcheck();
        
        });
        ///////check all client
        $("[id*=chkAclient]").on("click", function () {
            var chkprop = $(this).is(':checked');

            $(".clclient").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            });

            singleclientcheck();
          
        });
        /////////check all staff
        $("[id*=chkAstaff]").on("click", function () {
         
            var chkprop = $(this).is(':checked');

            $(".clstaff").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            });

            singlestaffcheck();
          
        });

        /////////check all job
        $("[id*=chkAjob]").on("click", function () {

            var chkprop = $(this).is(':checked');

            $(".clJob").each(function () {

                if (chkprop) {
                    $(this).attr('checked', 'checked');
                }
                else {
                    $(this).removeAttr('checked'); //sftrow.css('display', 'none'); 
                }
            });
         
        });

        /////////filter month wise
        //$("[id*=txtmonth]").on("change", function () {
        //    Onpagefilterloads();
        //});
        $("[id*=dtmonth]").on("change", function () {
            $("[id*=hdnmonth]").val($("[id*=dtmonth]").val());
            Onpagefilterloads();
        });

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
        clientwise = false, projectwise = false, staffwise = true, jobwise = false;
        $("[id*=chkAclient]").removeAttr('checked');
        $("[id*=chkAproject]").removeAttr('checked');
        $("[id*=chkAstaff]").removeAttr('checked');
        $("[id*=chkAjob]").removeAttr('checked');
      
        $("[id*=tblStaffname] tbody").empty();
        $("[id*=tblStaffname] thead").empty();
        $("[id*=tblClientname] tbody").empty();
        $("[id*=tblClientname] thead").empty();
        $("[id*=tblProjname] tbody").empty();
        $("[id*=tblProjname] thead").empty();
        $("[id*=tblJobName] tbody").empty();
        $("[id*=tblJobName] thead").empty();

        $("[id*=lblStaffcount]").html("0");
        $("[id*=lblCLtcount]").html("0");
        $("[id*=lblPrjcount]").html("0");
        $("[id*=lblJobcount]").html("0");
        onpageclientProjectload();
    }
    function onpageclientProjectload() {
        $('.loader').show();
        GetAllSelected();
        if (staffwise) {
            $("[id*=hdncltid]").val('');
            //$("[id*=hdnprojectid]").val('');
            $("[id*=hdnstaffcode]").val('Empty');
        }
        var compid = parseFloat($("[id*=hdnCompid]").val());
        var cltid = $("[id*=hdncltid]").val();
        var projectid = $("[id*=hdnprojectid]").val();
        var selectedstaffcode = $("[id*=hdnstaffcode]").val();
        if ($("[id*=dtmonth]").val() == "" || $("[id*=dtmonth]").val() == undefined) {
            return false;
        }

        Blockloadershow();

        var data = {
            currobj: {
                compid: compid,
                UserType: $("[id*=hdnTypeU]").val(),
                status: $("[id*=hdnTStatusCheck]").val(),
                StaffCode: $("[id*=hdnstaffid]").val(),
                selectedstaffcode: selectedstaffcode,
                selectetdcltid: cltid,
                selectedprojectid: projectid,
                staffwise: staffwise,
                clientwise: clientwise,
                projectwise: projectwise,
                jobwise: jobwise,
                frommonth: $("[id*=dtmonth]").val(),
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
                tableRowsstaff += "<tbody><tr><td><input type='checkbox'  onclick='singlestaffcheck()' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
            else if (vl.Type == "client") {
                countclient += 1;
                tableRowsclient += "<tbody><tr><td><input type='checkbox' checked='checked'  onclick='singleclientcheck()' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
            else if (vl.Type == "Project") {
                countProject += 1;
                tableRowsProject += "<tbody><tr><td><input type='checkbox' onclick='singleprojectcheck()' checked='checked' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
            else if (vl.Type == "Job") {
                countJob += 1;
                tableRowsJobs += "<tbody><tr><td><input type='checkbox' checked='checked' class='cl" + vl.Type + " Chkbox' value='" + vl.StaffCode + "' /></td><td>" + vl.StaffName + "</td></tr></tbody>";
            }
        });

        if (clientwise) {
            if (countclient != 0)
                $("[id*=chkAclient]").attr('checked', 'checked');
            else
                $("[id*=chkAclient]").removeAttr('checked');

            //$("[id*=DvClient]").parent().find('label').text(" Clients ( " + countclient + ")").addClass("labelChange");
            //$("[id*=DvClient]").html("<table>" + tableRowsclient + "</table>");

            $("[id*=lblCLtcount]").html(countclient);
            $("[id*=tblClientname]").append(tableRowsclient);
        }
        if (projectwise) {

            if (countProject != 0)
                $("[id*=chkAproject]").attr('checked', 'checked');
            else
                $("[id*=chkAproject]").removeAttr('checked');

            //$("[id*=DvProject]").parent().find('label').text(" Projects (" + countProject + ")").addClass("labelChange");
            //$("[id*=DvProject]").html("<table>" + tableRowsProject + "</table>");

            $("[id*=lblPrjcount]").html(countProject);
            $("[id*=tblProjname]").append(tableRowsProject);
        }
        if (staffwise) {

            $("[id*=chkAstaff]").removeAttr('checked');
            //$("[id*=chkAstaff]").parent().find('label').text(" Staffs (" + countstafff + ")");
            //$("#chkAstaff").parent().find('label').addClass("labelChange");
            //$("[id*=dvstaff]").html("<table>" + tableRowsstaff + "</table>");

            $("[id*=lblStaffcount]").html(countstafff);
            $("[id*=tblStaffname]").append(tableRowsstaff);
        }
        Blockloaderhide();

        if (jobwise) {
            if (countJob != 0)
                $("[id*=chkAjob]").attr('checked', 'checked');
            else
                $("[id*=chkAjob]").removeAttr('checked');


            //$("[id*=chkAjob]").parent().find('label').text("Job (Count : " + countJob + ")");
            //$("#chkAjob").parent().find('label').addClass("labelChange");
            //$("[id*=Dvjob]").html("<table>" + tableRowsJobs + "</table>");
            $("[id*=lblJobcount]").html(countJob);
            $("[id*=tblJobName]").append(tableRowsJobs);
        }
        Blockloaderhide();
    }

    function SelectSingleDepartment() {
        var DeptId = '';
        $(".clDept:checked").each(function () {
            DeptId += $(this).val() + ',';
        });
        $("[id*=hdnDeptId]").val(DeptId);
        onpageclientProjectload();

    }

    ////check single staff
    function singlestaffcheck() {
        if ($(".clstaff").length == $(".clstaff:checked").length)
        { $("[id*=chkAstaff]").attr('checked', true); }
        else { $("[id*=chkAstaff]").removeAttr('checked'); }
        staffwise = false, clientwise = true, projectwise = true, jobwise = true;
        onpageclientProjectload();
    }
    //////check single client
    function singleclientcheck() {
        if ($(".clclient").length == $(".clclient:checked").length)
        { $("[id*=chkAclient]").attr('checked', true); }
        else { $("[id*=chkAclient]").removeAttr('checked'); }
        staffwise = false, clientwise = false, projectwise = true, jobwise = true;
        onpageclientProjectload();
    }
    //////check single project
    function singleprojectcheck() {
        if ($(".clProject").length == $(".clProject:checked").length)
        { $("[id*=chkAproject]").attr('checked', true); }
        else { $("[id*=chkAproject]").removeAttr('checked'); }
        staffwise = false, clientwise = false, projectwise = false, jobwise = true;
        onpageclientProjectload();
    }

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
        $(".clclient:checked").each(function () {
            selectclient += $(this).val() + ',';
        });
        $(".clProject:checked").each(function () {
            selectproject += $(this).val() + ',';
        });
        $(".clJob:checked").each(function () {
            selectjobs += $(this).val() + ',';
        });
        $("[id*=hdnstaffcode]").val(selectStaff);
        $("[id*=hdncltid]").val(selectclient);
        $("[id*=hdnprojectid]").val(selectproject);
        $("[id*=hdnjobids]").val(selectjobs);
    }

    function CountFrmTitle(field) {

        field.value = field.value.replace(/[?\#!$%\^\*;:{}=\_`~@"'+]/g, "");
    }


</script>
<style type="text/css">
    .dropdown dd,
    .dropdown dt {
        margin: 0px;
        padding: 0px;
        border: 1px;
        border-color: Black;
    }

    .dropdown ul {
        margin: -1px 0 0 0;
        background-color: #fbfbfb;
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

        .dropdown dt a span,
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
        color: Black;
    }

        .dropdown dd ul li a:hover {
            background-color: #fff;
        }

    .Chkbox {
        height: 20px;
        width: 20px;
        cursor: pointer;
        margin-right: 5px;
    }

    .Spancount {
        height: 20px;
        width: 50px;
        font-size: 12px;
        font-weight: bold;
    }
</style>



<div class="page-content">
    <asp:HiddenField runat="server" ID="hdnCompid" />
    <asp:HiddenField runat="server" ID="hdncltid" />
    <asp:HiddenField runat="server" ID="hdnprojectid" />
    <asp:HiddenField runat="server" ID="hdnstaffcode" />
    <asp:HiddenField runat="server" ID="hdnTypeU" />
    <asp:HiddenField runat="server" ID="hdnstaffid" />
    <asp:HiddenField runat="server" ID="hdnjobids" />
    <asp:HiddenField runat="server" ID="hdntype" />
    <asp:HiddenField runat="server" ID="hdnbranch" Value="0" />
    <asp:HiddenField runat="server" ID="hdnDeptId" Value="" />
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved,Rejected" />
    <asp:HiddenField runat="server" ID="hdnmonth" Value="" />
     <div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>				
						
</div>

            <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-left: 1rem;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold" runat="server">All Staff Client Project</span></h5>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>

                <asp:Button ID="btngen" runat="server" OnClick="btngen_Click" CssClass="btn bg-success legitRipple"
                    Text="Generate Report" />

                <asp:Button ID="btnBack" Style="float: left" runat="server" CssClass="btn btn-primary legitRipple" Text="Back" Visible="false"
                    OnClick="btnBack_Click" />

            </div>
        </div>

        <div class="content">
            <div class="divstyle card">
                <div id="" class="totbodycatreg" style="height: 700px;">
                    <div style="width: 100%;">
                        <uc2:MessageControl ID="MessageControl1" runat="server" />
                    </div>
                    <div runat="server" id="divReportInput">
                        <div class="card-body">
                            <table style="padding-left: 20px; padding-top: 15px;">
                                <tr>
                                    <td>
                                        <asp:Label ID="lblBranch" Font-Bold="true" runat="server">Branch</asp:Label>
                                    </td>
                                    <td valign="middle" align="center">:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlBranch" CssClass="texboxcls" runat="server">
                                            <asp:ListItem Value="0" Text="Select Branch"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width: 10px;"></td>
                                    <td valign="middle" style="width: 120px">
                                        <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td valign="middle" align="center">:
                                    </td>
                                    <td valign="middle">
                                        <asp:CheckBox ID="chkTStatusAll" ClientIDMode="Static" runat="server" Checked="true"
                                            Text="All" />&nbsp;&nbsp;
                        <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server" Checked="true"
                            onclick="TStatusCheck()" Text="Submitted" />&nbsp;&nbsp;
                        <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static" Checked="true" onclick="TStatusCheck()"
                            Text="Saved" />&nbsp;&nbsp;
                        <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()" Checked="true"
                            ClientIDMode="Static" Text="Approved" />&nbsp;&nbsp;
                        <asp:CheckBox ID="chkRejected" runat="server" onclick="TStatusCheck()" Checked="false"
                            ClientIDMode="Static" Text="Rejected" Style='display: none;' />
                                    </td>

                                    <td></td>
                                    <td>
                                        <asp:Button ID="btnCSV" runat="server" CssClass="TbleBtns" Text="Generate CSV" Visible="false"
                                            OnClick="btnCSV_Click" />
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="middle" style="width: 40px">
                                        <label style="font-weight: bold">
                                            Month</label>
                                    </td>
                                    <td>:
                                    </td>
                                    <td valign="middle" style="width: 100px">
                                <%--        <asp:TextBox ID="txtmonth" runat="server" Width="70px" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" />
                                        <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtmonth"
                                            PopupButtonID="Img1" Format="MM/yyyy">
                                        </cc1:CalendarExtender>--%>
                                         <input type="month" style="width:125px;" class="form-control" id="dtmonth" name="dtmonth" />
                                    </td>

                                    <td></td>

                                    <td>
                                        <asp:Label ID="Label3" runat="server" ForeColor="Black" Text="Department" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td valign="middle" align="center">:
                                    </td>
                                    <td>
                                        <dl id="dlDept" class="dropdown">
                                            <dt><a href="#" class="AStyle texboxcls "><span class="hida">Select Department</span> <i class="arrow right"
                                                style="float: right;"></i></a></dt>
                                            <dd>
                                                <div id="Dv_Department" class="mutliSelect">
                                                    <ul>
                                                        <li>
                                                            <input type="checkbox" value="0" />Select</li>
                                                    </ul>
                                                </div>
                                            </dd>
                                        </dl>
                                    </td>
                                    <td style="width: 30px">
                                        <asp:Label ID="Label2" runat="server" ForeColor="Black" Text="Type" Font-Bold="True"></asp:Label>
                                    </td>
                                    <td valign="middle" align="center">:
                                    </td>
                                    <td>
                                        <select id="ddlType" class="texboxcls" style="width: 90px;">
                                            <option value="All">All</option>
                                            <option value="1">Billable</option>
                                            <option value="0">Non Billable</option>
                                        </select>



                                    </td>

                                </tr>
                            </table>
                        </div>



                        <div id="dvEditInvoice2" class="row">
                            <div class="col-md-3">

                                <!-- Grey background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold"><i class="icon-user-check mr-2"></i>
                                            <input type="checkbox" class="Chkbox" id="chkAstaff" name="chkAstaff" />Staff <span id="lblStaffcount" name="lblStaffcount" class="badge badge-success badge-pill Spancount">0</span></h6>
                                        <div class="header-elements">
                                            <div class="list-icons">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card-body">
                                        <div class="form-group row">
                                            <div style="height: 450px; width: 100%; overflow-y: scroll;">
                                                <table id="tblStaffname" name="tblStaffname" class="table table-hover table-xs font-size-base"></table>
                                            </div>
                                        </div>


                                    </div>



                                </form>
                                <!-- /grey background, left button spacing -->



                            </div>

                            <div class="col-md-3">

                                <!-- Grey background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold"><i class="icon-user-check mr-2"></i>
                                            <input type="checkbox" class="Chkbox" id="chkAclient" name="chkAclient" />Client <span id="lblCLtcount" name="lblCLtcount" class="badge badge-success badge-pill Spancount">0</span></h6>
                                        <div class="header-elements">
                                            <div class="list-icons">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card-body">
                                        <div class="form-group row">
                                            <div style="height: 450px; width: 100%; overflow-y: scroll;">
                                                <table id="tblClientname" name="tblClientname" class="table table-hover table-xs font-size-base"></table>
                                            </div>
                                        </div>


                                    </div>



                                </form>
                                <!-- /grey background, left button spacing -->



                            </div>
                            <div class="col-md-3">

                                <!-- Grey background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold"><i class="icon-user-check mr-2"></i>
                                            <input type="checkbox" class="Chkbox" id="chkAproject" name="chkAproject" />Project <span id="lblPrjcount" name="lblPrjcount" class="badge badge-success badge-pill Spancount">0</span></h6>
                                        <div class="header-elements">
                                            <div class="list-icons">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card-body">
                                        <div class="form-group row">
                                            <div style="height: 450px; width: 100%; overflow-y: scroll;">
                                                <table id="tblProjname" name="tblProjname" class="table table-hover table-xs font-size-base"></table>
                                            </div>
                                        </div>


                                    </div>



                                </form>
                                <!-- /grey background, left button spacing -->



                            </div>

                            <div class="col-md-3">

                                <!-- White background, left button spacing -->
                                <form>

                                    <div class="card-header bg-white header-elements-inline">
                                        <h6 class="card-title font-weight-bold">
                                            <input type="checkbox" class="Chkbox" id="chkAjob" name="chkAjob" />Job <span id="lblJobcount" name="lblJobcount" class="badge badge-success badge-pill Spancount">0</span></h6>
                                        <div class="header-elements">
                                            <div class="list-icons">
                                            </div>
                                        </div>
                                    </div>



                                    <div class="card-body">
                                        <div class="form-group row">
                                            <div style="height: 450px; width: 100%; overflow-y: scroll;">
                                                <table id="tblJobName" name="tblJobName" class="table table-hover table-xs font-size-base"></table>
                                            </div>
                                        </div>


                                    </div>



                                </form>
                                <!-- /white background, left button spacing -->


                            </div>
                        </div>

                    </div>
                    <div id="tblreport" visible="false">
                        <table>
                            <tr>
                                <td></td>
                            </tr>
                        </table>
                    </div>
                    <rsweb:ReportViewer ID="ReportViewer1" Height="670px" Width="1144px" Visible="false"
                        runat="server" AsyncRendering="False" InteractivityPostBackMode="AlwaysAsynchronous">
                    </rsweb:ReportViewer>
                </div>
            </div>
        </div>
   




