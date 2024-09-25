<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Report_Project_Clientwise_BillableHours.ascx.cs" Inherits="controls_Report_Project_Clientwise_BillableHours" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script lang="javascript" type="text/javascript">
    var needproject = true, needclient = false;
    $(document).ready(function () {   
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });
        Get_All_Project_Client_BranchName();
        pageFiltersReset();

        $("[id*=txtstartdate1]").on("change", function () {
            pageFiltersReset();
        });

        $("[id*=txtenddate2]").on("change", function () {
            pageFiltersReset();
        });

        $("[id*=chkTStatusAll]").on("click", function () {
            if ($(this).attr('checked')) {
                $("[id*=chkSubmitted]").attr('checked', 'checked');
                $("[id*=chkSaved]").attr('checked', 'checked');
                $("[id*=chkApproved]").attr('checked', 'checked');
            }
            else {
                $("[id*=chkSubmitted]").removeAttr('checked');
                $("[id*=chkSaved]").removeAttr('checked');
                $("[id*=chkApproved]").removeAttr('checked');
            }
            TStatusCheck();
        });

        ////check all Project
        $("[id*=chkProject]").on("click", function () {

            if ($(".clProject").length == 0)
            {
                return false;
            }
            var check = $(this).attr('checked');
            $(".clProject").each(function () {
                if (check)
                {
                    $(this).attr('checked', 'checked');                    
                }
                else {
                    $(this).removeAttr('checked');                   
                }
              
            });            
            needproject = false, needclient = true;
            BindPageLoadData();
        });

        ////check all Client
        $("[id*=chkClient]").on("click", function () {
            var check = $(this).attr('checked');
            if ($(".clclient").length == 0)
            {
                return false;
            }
            $(".clclient").each(function () {
                if (check)
                {
                    $(this).attr('checked', 'checked');
                }
                else { $(this).removeAttr('checked'); }
            });
        });

        $("[id*=ddlBranch]").on("change", function () {
            needproject = true, needclient = false;
            BindPageLoadData();
        });
    });

    function Get_All_Project_Client_BranchName() {
        //Ajax start
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            url: "../Handler/WS_Project_Client_BillableHrs.asmx/Get_BranchList",
            data: '{compid:' + $("[id*=hdnCompid]").val() + '}',
            dataType: "json",
            success: function (msg) {
                var myList = jQuery.parseJSON(msg.d);
                if (myList.length == 0) { }
                else {
                    if (myList == null) { }
                    else {
                        $("[id*=ddlBranch]").empty();
                        $("[id*=ddlBranch]").append("<option value=" + 0 + ">All</option>");
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
        //bind data
        function BindPageLoadData() {
            GetAllSelected();
            if ($("[id*=txtstartdate1]").val() == "" || $("[id*=txtstartdate1]").val() == undefined)
            { return false; }
            $('.loader').show();
            var data = {
                currobj: {
                    compid: $("[id*=hdnCompid]").val(),
                    UserType: $("[id*=hdnUserType]").val(),
                    status: $("[id*=hdnTStatusCheck]").val(),
                    staffcode: $("[id*=hdnstaffcode]").val(),
                    selectedclientid : $("[id*=hdnselectedclient]").val(),
                    selectedprojectid : $("[id*=hdnSelectedProjectid]").val(),
                    needclient : needclient,
                    needProject: needproject,
                    fromdate: $("[id*=txtstartdate1]").val(),
                    todate: $("[id*=txtenddate2]").val(),              
                    BrId: $("[id*=ddlBranch]").val(),                    
                }
            };
            //Ajax start
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "../Handler/WS_Project_Client_BillableHrs.asmx/Get_Project_client",
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

        function pageFiltersReset() {
            needproject = true, needclient = false;
            $("[id*=chkProject]").removeAttr('checked');
            $("[id*=chkProject]").parent().find('label').text("Check All Project Name (Count : 0)");
            $("[id*=chkClient]").removeAttr('checked');
            $("[id*=chkClient]").parent().find('label').text("Check All Client Name (Count : 0)");

            $("[id*=Panel1]").html('');
            $("[id*=Panel2]").html('');
            BindPageLoadData();
        }

        function OnSuccess(response) {
            var obj = jQuery.parseJSON(response.d);
            console.log(obj);
            var tableRowsProj = '', tableRowsclt = '';
            var countProj = 0, countClt = 0;
            $.each(obj, function (i, vl) {
                if (vl.Type == "Project") {
                    countProj += 1;
                    tableRowsProj += "<tr><td><input type='checkbox' onclick='singleProjectcheck()' class='cl" + vl.Type + "' value='" + vl.id + "' /></td><td>" + vl.PNAME + "</td></tr>";
                }
                else if (vl.Type == "client") {                   
                    countClt += 1;
                    tableRowsclt += "<tr><td><input type='checkbox' checked='checked' onclick='singleclient()'  class='cl" + vl.Type + "' value='" + vl.id + "' /></td><td>" + vl.PNAME + "</td></tr>";
                }
            });
            if (needproject) {
                $("[id*=chkProject]").removeAttr('checked');
                $("[id*=chkProject]").parent().find('label').text("Check All Project Name (Count : " + countProj + ")");
                $("[id*=Panel1]").html("<table>" + tableRowsProj + "</table>");
            }
            if (needclient) {
                if (countClt != 0)

                    $("[id*=chkClient]").attr('checked', 'checked');
                else
                    $("[id*=chkClient]").removeAttr('checked');
                    $("[id*=chkClient]").parent().find('label').text("Check All Client Name (Count : " + countClt + ")");
                    $("[id*=Panel2]").html("<table>" + tableRowsclt + "</table>");
            }          
            GetAllSelected();
        }

        function singleclient() {
            if ($(".clclient").length == $(".clclient:checked").length)
            {
                $("[id*=chkClient]").attr('checked', true);
            }
            else {
                $("[id*=chkClient]").removeAttr('checked');
            }
        }
     
        //////check single Project
        function singleProjectcheck() {
            if ($(".clProject").length == $(".clProject:checked").length)
            {
                $("[id*=chkProject]").attr('checked', true);
            }
            else {
                $("[id*=chkProject]").removeAttr('checked');
            }
            needproject = false, needclient = true;
            BindPageLoadData();
        }        

        function GetAllSelected() {
            var selectClient = '', selectProject = '';
            $(".clProject:checked").each(function () {
                selectProject += $(this).val() + ',';
            });
            $(".clclient:checked").each(function () {
                selectClient += $(this).val() + ',';
            });
            $("[id*=hdnSelectedProjectid]").val(selectProject);

            $("[id*=hdnselectedclient]").val(selectClient);
        }

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

            if (count == 3)
            { $("[id*=chkTStatusAll]").attr('checked', 'checked'); }
            else { $("[id*=chkTStatusAll]").removeAttr('checked'); }

            if (selectedTStatus == '') {
                $("[id*=chkApproved]").attr('checked', 'checked');
                selectedTStatus = 'Approved';
            }
            $("[id*=hdnTStatusCheck]").val(selectedTStatus);
            pageFiltersReset();
        }
</script>
<style type="text/css">
        #content {
            overflow: hidden !important;
        }

        .loader {
            display: none;
            position: absolute;
            padding-top: 100px;
            width: 320px;
            height: 215px;
            z-index: 9999;
            text-align: center;
            vertical-align: middle;
            background: rgba(0,0,0,0.3);
            color: White;
            font-weight: bold;
            font-size: 18px;
        }
    </style>
<div class="divstyle">
    <asp:HiddenField runat="server" id="hdnCompid"/>
    <asp:HiddenField runat="server" ID="hdnSelectedProjectid"/>
    <asp:HiddenField runat="server" ID="hdnTStatusCheck" Value="Submitted,Saved,Approved" />
    <asp:HiddenField runat="server" ID="hdnselectedclient"/>
    <asp:HiddenField runat="server" ID="hdnUserType"/>
    <asp:HiddenField runat="server" ID="hdnstaffcode"/>
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left: 10px; margin-top: 10px;">
            <asp:Label ID="Label1" runat="server" CssClass="Head1 labelChange" Text="Billable Hours Summary"></asp:Label>
        </div>
    </div>
    <div id="div2" class="totbodycatreg" style="height: 500px;">
        <div style="width: 100%;">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div class="row_report" runat="server" id="divReportInput">
            <div>
                <table class="style1" style="float: left; padding-left: 50px; padding-top: 5px;">
                    <tr>
                        <td style="vertical-align: top;">
                            <table class="style1" width="100%;">
                                <tr>
                                    <%--<td>
                                        <asp:Label ID="lblBranch" Font-Bold="true" runat="server">Branch</asp:Label>
                                    </td>
                                    <td valign="middle" align="center">:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlBranch" CssClass="texboxcls" runat="server" Width="154px">
                                            <asp:ListItem Value="0" Text="Select Branch"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td style="width:15px;"></td>--%>
                                    
                                    <td valign="middle">
                                        <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center" valign="middle">:
                                    </td>
                                    <td valign="middle">
                                        <asp:TextBox ID="txtstartdate1" runat="server" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Img1" runat="server" ImageUrl="~/images/calendar.png" />
                                        <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle"
                                            ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtstartdate1"
                                            PopupButtonID="Img1" Format="dd/MM/yyyy">
                                        </cc1:CalendarExtender>
                                    </td>
                                    <td valign="middle">
                                        <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center" valign="middle">:
                                    </td>
                                    <td valign="middle">
                                        <asp:TextBox ID="txtenddate2" runat="server" CssClass="texboxcls"></asp:TextBox>
                                        <asp:Image ID="Img2" runat="server" ImageUrl="~/images/calendar.png" />
                                        <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle"
                                            ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtenddate2"
                                            PopupButtonID="Img2" Format="dd/MM/yyyy">
                                        </cc1:CalendarExtender>
                                    </td>
                                    <td style="width:15px;"></td>
                                    <td valign="middle">
                                        <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Timesheet Status"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td valign="middle" align="center">:
                                    </td>
                                    <td valign="middle" colspan="3">
                                        <asp:CheckBox ID="chkTStatusAll" ClientIDMode="Static" runat="server" Checked="true"
                                            Text="All" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkSubmitted" ClientIDMode="Static" runat="server" Checked="true"
                                            onclick="TStatusCheck()" Text="Submitted" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkSaved" runat="server" ClientIDMode="Static" Checked="true"
                                            onclick="TStatusCheck()" Text="Saved" />&nbsp;&nbsp;
                                        <asp:CheckBox ID="chkApproved" runat="server" onclick="TStatusCheck()" Checked="true"
                                            ClientIDMode="Static" Text="Approved" />&nbsp;&nbsp;
                           
                                    </td>
                                    <td>
                                        <asp:Button Style="margin-top: -5px;" ID="btngen" runat="server" OnClick="btngen_Click"
                                            CssClass="TbleBtns" Text="Generate Report" /></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        
                        <td colspan="20">
                            <table align="center">
                                <tr>
                                    <td style="width: 380px; padding-top:30px;">
                                        <asp:CheckBox ID="chkProject" runat="server" ForeColor="Black"
                                            Font-Bold="true" Height="20px" Text=" Check All Project Name (Count : 0)" CssClass="labelChange" />
                                        <div id="Panel1" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
                                        </div>
                                    </td>
                                    <td></td>
                                    <td style="width: 380px; padding-top:30px;">
                                        <asp:CheckBox ID="chkClient" runat="server" ForeColor="Black"
                                            Font-Bold="true" Height="20px" Text=" Check All Client Name (Count : 0)" CssClass="labelChange" />
                                        <div id="Panel2" style="border: 1px solid #B6D1FB; width: 95%; height: 450px; overflow: auto;">
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
