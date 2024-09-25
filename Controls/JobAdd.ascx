<%@ Control Language="C#" AutoEventWireup="true" CodeFile="JobAdd.ascx.cs" Inherits="controls_JobAdd" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/StyleSkin.css" rel="stylesheet" type="text/css" />
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<style type="text/css">
    .ajax__tab_container
    {
        color: Black;
    }
    .property_tab .ajax__tab_outer .ajax__tab_inner .ajax__tab_tab
    {
        margin-right: 0;
    }
    .property_tab .ajax__tab_header
    {
        font-family: verdana,tahoma,helvetica;
        font-size: 12px;
    }
    .property_tab .ajax__tab_outer
    {
        background: none;
        height: auto;
        margin: 0 5px 0 0;
    }
    .property_tab .ajax__tab_inner
    {
        background: none repeat scroll 0 0 #F2F2F2;
        border: 1px solid #CCCCCC;
        border-bottom: none;
        padding: 0px;
        color: #474747;
        border-radius: 5px 5px 0 0;
    }
    .property_tab .ajax__tab_tab
    {
        background: none repeat scroll 0 0 rgba(0, 0, 0, 0);
        font-weight: bold;
        height: 13px;
        margin: 0;
        padding: 8px 15px;
    }
    
    
    
    .property_tab .ajax__tab_hover .ajax__tab_outer
    {
    }
    .property_tab .ajax__tab_hover .ajax__tab_inner
    {
    }
    .property_tab .ajax__tab_hover .ajax__tab_tab
    {
        background: #DFDFDF;
    }
    .property_tab .ajax__tab_active .ajax__tab_outer
    {
    }
    .property_tab .ajax__tab_active .ajax__tab_inner
    {
    }
    .property_tab .ajax__tab_active .ajax__tab_tab
    {
        background: #1464F4;
        color: #fff;
        border-radius: 5px 5px 0 0;
    }
    .property_tab .ajax__tab_body
    {
        font-family: verdana,tahoma,helvetica;
        font-size: 10pt;
        border: 1px solid #999999;
        border-top: 0;
        padding: 8px;
        background-color: #ffffff;
        width: 800px;
    }
    .modalBackground
    {
        background-color: Gray;
        filter: alpha(opacity=70);
        opacity: 0.7;
    }
    .Button
    {
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
    .Head1
    {
        font-size: 14px;
        font-family: Verdana,Arial,Helvetica,sans-serif;
        color: #0b9322;
        font-weight: bold;
        overflow: hidden;
        border-bottom-color: White;
    }
    .divspace
    {
        height: 20px;
    }
    .headerstyle1_page
    {
        border-bottom: 1px solid #0b9322;
        float: left;
        margin: 0 0 10px;
        overflow: hidden;
        width:1190px;
    }
    .headerpage
    {
        height: 23px;
    }
    .error
    {
        background-color: #FF0000;
        background-image: none !important;
        color: #FFFFFF !important;
        margin: 0 0 10px;
        width: 95% !important;
    }
    .property_tab
    {
    }
    .property_tab
    {
    }
    .drp
    {
        font-family:Verdana,Arial,Helvetica,sans-serif;
		font-size:12px;
		-webkit-border-radius: 3px;
        -moz-border-radius: 3px;
        border-radius: 3px;
        width:80px; 
    }
    
    .EditJobTble2{}
    .EditJobTble2 td{}
    .EditJobTble2 td  select {
    border: 1px solid #BCBCBC;
    border-radius: 5px;
    height: auto;
    padding: 3px 5px;
    font-size: 12px;
   
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

    .cssTextbox {
        font: normal 12px verdana, arial, "Trebuchet MS", sans-serif;
        height: 15px;
        border-radius: 4px;
        border: 1px solid #b5b5b5;
    }

    .cssTextboxLong {
        font: normal 12px verdana, arial, "Trebuchet MS", sans-serif;
        width: 350px;
        height: 25px;
        border-radius: 4px;
        border: 1px solid #b5b5b5;
    }

    .cssTextbox:focus {
        box-shadow: 0 0 5px rgba(81, 203, 238, 1);
        padding: 3px 0px 3px 3px;
        border: 1px solid rgba(81, 203, 238, 1);
    }

    .cssTextbox:hover {
        border: 1px solid rgba(81, 203, 238, 1);
    }

    .cssTextboxInt {
        font: normal 12px verdana, arial, "Trebuchet MS", sans-serif;
        height: 25px;
        text-align: right;
        border-radius: 4px;
        border: 1px solid #b5b5b5;
        padding-right: 5px;
    }

        .cssTextboxInt:focus {
            box-shadow: 0 0 5px rgba(81, 203, 238, 1);
            padding-right: 5px;
            border: 1px solid rgba(81, 203, 238, 1);
        }

        .cssTextboxInt:hover {
            padding-right: 5px;
            border: 1px solid rgba(81, 203, 238, 1);
        }
</style>
<script type="text/javascript">
    /////////////////pget load
    $(document).ready(function () {
        //////////////////////////page event start
        BudgetingChange();


        ///////////////click on add new client show modal popup
        $("[id*=AClient]").live('click', function () {
            $find("ModalPBehaviorIDopupExtender3").show();
            return false;
        });
        ///////////////click on add new job show modal popup
        $("[id*=AJob]").live('click', function () {
            $find("ModalPopupExtBehaviorIDender1").show();
            return false;
        });
        ///////////////click on add new job group show modal popup
        $("[id*=AGJob]").live('click', function () {
            $find("fasdfasfdas").show();
            return false;
        });
        //////////////IN modal popup save client name validation
        $("[id*=btnclientname]").live('click', function () {
            var txtclientname = $("[id*=txtclientname]").val();
            if (txtclientname == '') {
                alert('Please Enter Client Name !');
                return false;
            }
        });
        //////////////IN modal popup save Job name validation
        $("[id*=btJobNamens]").live('click', function () {
            var txtjob = $("[id*=txtjob]").val();

            if (txtjob == '') {
                alert('Please Enter Job Name !');
                return false;
            }
        });
        //////////////IN modal popup save job group name validation
        $("[id*=bJgtnsJg]").live('click', function () {
            var txtjg = $("[id*=txtjg]").val();
            if (txtjg == '') {
                alert('Please Enter JOBGROUP !');
                return false;
            }
        });
        ///////////for html created text box in staff budgeting tab and all text box used integer 
        $(".calbox").live('keydown', function (event) {
            if (event.keyCode == 8 || event.keyCode == 9) {
            } else {
                if (event.keyCode < 95) {
                    if (event.keyCode < 48 || event.keyCode > 57) {
                        event.preventDefault();
                    }
                } else {
                    if (event.keyCode < 96 || event.keyCode > 105) {
                        event.preventDefault();
                    }
                }
            }
        });
        /////////////////////////budgeting drop down change
        $("[id*=ddlBudgetingselection]").live("change", function () {
            BudgetingChange();
        });
        ////////////////////////////////tab2 assign staff check all
        $(".staffchkall").live('click', function () {
            ///CheckAll
            $('.loader').show();
            var parrentchk = $(this).find('input[type=checkbox]').is(':checked');
            /////////////check all department
            $("input[name=chkDeptname]").each(function () {
                if (parrentchk == true) {
                    $(this).attr('checked', 'checked');
                } else { $(this).removeAttr('checked'); }
            });

            $("input[name=chkSftname]").each(function () {
                if (parrentchk == true) {
                    $(this).attr('checked', 'checked');
                } else { $(this).removeAttr('checked'); }
            });

            $("input[name=chkStaffBudgetCheckEmp]").each(function () {
                if (parrentchk == true) {
                    $(this).attr('checked', 'checked'); $(this).closest("tr").css('display','');
                } else { $(this).removeAttr('checked'); $(this).closest("tr").hide(); }
            });

            $('.loader').hide();
        });

        ////////////////////tab2 assign staf on department check auto check staff 
        ///////////////////////// chk chkDeptname
        ///////////////////////////chkDeptname created in ajax htmlin aspx page
        $("input[name=chkDeptname]").live('click', function () {
            $('.loader').show();
            var currentobj = $(this);
            setTimeout(function () {
                var chkprop = currentobj.is(':checked');
                $("input[name=chkSftname]").each(function () {
                    var sftrow = $(this).closest("tr");
                    var hdndepid = sftrow.find("input[name=hdndepid]").val();
                    if (hdndepid == currentobj.val()) {
                        if (chkprop) {
                            $(this).attr('checked', 'checked');
                        }
                        else {
                            $(this).removeAttr('checked');
                        }
                    }
                });
                AssignStafftoStaffBudgeting();
                $('.loader').hide();
            }, 1000);
        });


        /////////////////////////tab2 assign Staff on selection
        /////////////////////////chk chkSftname 
        $("input[name=chkSftname]").live('click', function () {
            AssignStafftoStaffBudgeting();
        });
        /////////////////////////////btn save
        $("[id*=btnsave]").live('click', function () {
            var hdnAllstfCheckByAjaxCode = "";
            var hdnAllDepAjaxCode = "";
            var hdnAllAppAjaxCode = "";

            ///////////////checked staff id with budgeting
            $("input[name=chkStaffBudgetCheckEmp]:checked").each(function () {
                var row = $(this).closest("tr");
                hdnAllstfCheckByAjaxCode += $(this).val() + ',';
                hdnAllstfCheckByAjaxCode += $("input[name=txtHours]", $(this).closest("tr")).val() + ','; ////////txthours
                hdnAllstfCheckByAjaxCode += $("input[name=txtStaffbudget]", $(this).closest("tr")).val() + ','; ///////////////bugets
                hdnAllstfCheckByAjaxCode += $("input[name=txtPlanedDrawings]", $(this).closest("tr")).val() + ','; ////////////planed drawings
                hdnAllstfCheckByAjaxCode += $("input[name=txtAllocatedHrs]", $(this).closest("tr")).val() + ','; ////////////Allocated Hours
                hdnAllstfCheckByAjaxCode += $("input[name=txtStaffActualHrs]", $(this).closest("tr")).val() + ','; //////////////txtstaffActual Hours
                hdnAllstfCheckByAjaxCode += "/";
            });

            if (hdnAllstfCheckByAjaxCode == "") {
                alert('Warning : No Staff Selected for this job !');
            }

            $("[id*=hdnAllstfCheckByAjaxCode]").val(hdnAllstfCheckByAjaxCode);

            // Approver
            $("input[name=chkAppname]").each(function () {
                var chkprop = $(this).is(':checked');
                if (chkprop) {
                    hdnAllAppAjaxCode = $(this).val() + ',' + hdnAllAppAjaxCode;
                    var sftrow = $(this).closest("tr");
                    var hdnDepid = sftrow.find("input[name=hdnSdepid]").val();
                    hdnAllDepAjaxCode = hdnDepid + ',' + hdnAllDepAjaxCode;
                }
            });

            if (hdnAllAppAjaxCode == "") {
                alert('Warning : Sub Approver Not Selected !');
            }

            $("[id*=hdnAllAppCheckByAjaxCode]").val(hdnAllAppAjaxCode);
            $("[id*=hdnAllAppDepidCheckByAjaxCode]").val(hdnAllDepAjaxCode);
        });
        //////////////////////////page evnet end
    });

    //////////////show budgeting tab
    function BudgetingChange() {
        var bud = $("[id*=ddlBudgetingselection]").val();
        if (bud == 'Project Budgeting') {
            $("[id*=TabPanel1]").show();
            $("[id*=tab_pane_Staff_budgeting]").hide();
            $("[id*=TabPanel1]").click();
        } else if (bud == 'Staff Budgeting') {
            $("[id*=TabPanel1]").hide();
            $("[id*=tab_pane_Staff_budgeting]").show();
            $("[id*=tab_pane_Staff_budgeting]").click();
        }
        else {
            $("[id*=TabPanel3]").click();
            $("[id*=TabPanel1]").hide();
            $("[id*=tab_pane_Staff_budgeting]").hide();
        }
    }

    function AssignStafftoStaffBudgeting() {
        var staffcode = "";
        $("input[name=chkSftname]:checked").each(function () { staffcode = staffcode + "," + $(this).val(); });

        $("input[name=chkStaffBudgetCheckEmp]").each(function () {
            $(this).removeAttr('checked');
            $(this).closest('tr').hide();
        });

        if (staffcode != "") {
            var rono = 0;
            staffcode = staffcode.split(',');
            $("input[name=chkStaffBudgetCheckEmp]").each(function () {

                for (i = 0; i < staffcode.length; i++) {
                    if (staffcode[i] == $(this).val()) {
                        rono = parseFloat(rono) + 1;
                        $(this).attr('checked', 'checked');
                        $("td", $(this).closest('tr')).eq(0).html(rono);
                        $(this).closest('tr').css('display','');
                    }
                }

            });
        }
    }

    function checkEmployeeAssign() {
        var staffcode = "";
        $("input[name=chkSftname]").each(function () {
            if ($(this).prop('checked')) {
                if (staffcode == "") { staffcode = $(this).val(); }
                else { staffcode = staffcode + "," + $(this).val(); }
            }
        });

        if (staffcode != "") {
            $("[id*=hdnSelectdEmpForStaffBudget]").val(staffcode);
            staffcode = staffcode.split(',');
        }
    }

    ////CustomValidator for Select one SubApprover
    function customVaidationforselectoneSubApprover(sender, args) {
        var res = '';
        $("input[name=chkAppname]").each(function () {
            if ($(this).prop('checked')) {
                res = $(this).val() + ',' + res;
            }
        });
        $("[id*=hdnSSappid]").val(res);
        if (res == '')
        { args.IsValid = false; return; }
        args.IsValid = true;
    }

    function Redirect() {
        window.location = "cmp_Managejob.aspx?active=1&masters=1";
    }
     
</script>
<div id="totbdy" class="MainDiv">
    <asp:Button ID="btn_getapprovedemployee" Visible="false" runat="server" Text="Button"
        OnClick="btn_getapprovedemployee_Click" />
    <div class="headerpage">
        <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;" >
            <asp:Label ID="lblheader" runat="server" Text="Job Allocation" CssClass="Head1 labelChange"></asp:Label>
        </div>
    </div>
    <div>
        <uc1:MessageControl ID="MessageControl1" runat="server" />
        <uc1:MessageControl ID="MessageControl2" runat="server" />
        <asp:HiddenField ID="hdnCompanyid" runat="server" />
        <asp:HiddenField ID="hdnStfCnt" runat="server" />
        <asp:HiddenField ID="hdnJobid" runat="server" />
        <asp:HiddenField ID="hdnAllstfCheckByAjaxCode" runat="server" />
        <asp:HiddenField ID="hdnAllAppCheckByAjaxCode" runat="server" />
        <asp:HiddenField ID="hdnAllAppDepidCheckByAjaxCode" runat="server" />
        <asp:HiddenField ID="hdnSSappid" runat="server" />
    </div>
    <asp:Panel ID="Panel1" runat="server" class="panelLets">
        <fieldset style="border: solid 1px black; padding: 10px; width:1175px;">
        <legend style="font-weight:bold; color:Red;">Job Details</legend>
        <table style="width:1000px; padding-left:40px;">
                    <tr>
                    <td>
                    <div class="masterleft">
                        <asp:Label ID="Label3" runat="server" CssClass="labelstyle labelChange" Text="Client" Font-Size="Small"></asp:Label>
                    </div>
                    <div class="DivRight" style="width: 550px;">
                        <asp:DropDownList ID="drpclientname" runat="server" CssClass="cssTextbox" Width="435px" Height="30px" style ="margin-top:6px;"
                            AutoPostBack="True" DataValueField="CLTId" DataTextField="ClientName" OnSelectedIndexChanged="drpclientname_SelectedIndexChanged">
                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                        </asp:DropDownList>
                        <asp:Label ID="Label48" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        <asp:Button ID="AClient" runat="server" Text="Add" OnClick="AClient_Click" class="cssButton" />
                    </div>
                </td>
                <td>
                    <div class="masterleft">
                        <asp:Label ID="Label1" runat="server" CssClass="labelstyle labelChange" Text="Job Name"></asp:Label>
                    </div>
                    <div class="DivRight" style="width: 550px;">
                        <asp:DropDownList ID="DrpJob" runat="server" CssClass="cssTextbox" Width="435px" Height="30px" DataValueField="mjobId" style ="margin-top:6px;"
                            DataTextField="mjobName">
                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                        </asp:DropDownList>
                        <asp:Label ID="Label12" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        <asp:Button ID="AJob" runat="server" Text="Add" class="cssButton" OnClick="AJob_Click" />
                    </div>
                </td>

            </tr>
            
            <tr>
                <td>
                    <div class="masterleft">
                        <asp:Label ID="Label2" runat="server" CssClass="labelstyle labelChange" Text="Job Group" Font-Size="Small"></asp:Label>
                    </div>
                    <div class="DivRight" style="width: 550px;">
                        <asp:DropDownList ID="drpjobgrp" runat="server" CssClass="cssTextbox" Width="435px" Height="30px" style ="margin-top:6px;"
                            DataValueField="JobGId" DataTextField="JobGroupName">
                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                        </asp:DropDownList>
                        &nbsp;&nbsp;
                        <asp:Button ID="AGJob" runat="server" Text="Add" class="cssButton"
                            OnClick="AJobG_Click" />
                    </div>
                </td><td>
                    <div class="masterleft">
                        <asp:Label ID="Label4" runat="server" CssClass="labelstyle labelChange" Text="Job Status" Font-Size="Small"></asp:Label>
                    </div>
                    <div class="DivRight" style="width: 550px;">
                        <asp:DropDownList ID="drpjobstatus" runat="server" CssClass="cssTextbox" Width="200px" Height="30px" style ="margin-top:6px;">
                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                            <asp:ListItem Value="1">OnGoing</asp:ListItem>
                            <asp:ListItem Value="2">Completed</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </td>
            </tr>
            
            <tr>
                <td>
                   <div  class="divedBlockNew">
                    <div style="overflow: hidden; width: 100px; float: left">
                        <asp:Label ID="Label7" runat="server" CssClass="labelstyle" Text="Start Date" Font-Size="Small"></asp:Label>
                    </div>
                    <div style="overflow: hidden; width: 150px; float: left">
                        <asp:TextBox ID="txtstartdate" runat="server" CssClass="cssTextbox" Width="100px" Height="22px"></asp:TextBox>
                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtstartdate"
                            Mask="99/99/9999" MaskType="Date" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
                            CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                            CultureTimePlaceholder="" Enabled="True" />
                        <asp:Label ID="Label10" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtstartdate"
                            PopupButtonID="txtstartdate" Format="dd/MM/yyyy" Enabled="True">
                        </cc1:CalendarExtender>
                    </div>
                    <div style="overflow: hidden; width: 80px; float: left">
                        <asp:Label ID="Label13" runat="server" CssClass="labelstyle" Text="End Date" Font-Size="Small"></asp:Label>
                    </div>
                    <div style="overflow: hidden; width: 150px; float: left">
                        <asp:TextBox ID="txtactualdate" runat="server" CssClass="cssTextbox" Width="100px" Height="22px"></asp:TextBox>
                        <cc1:MaskedEditExtender ID="MaskedEditExtender16" runat="server" TargetControlID="txtactualdate"
                            Mask="99/99/9999" MaskType="Date" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
                            CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                            CultureTimePlaceholder="" Enabled="True" />
                        <asp:Label ID="Label26" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        <cc1:CalendarExtender ID="txtactualdate_CalendarExtender" runat="server" TargetControlID="txtactualdate"
                            PopupButtonID="txtactualdate" Format="dd/MM/yyyy" Enabled="True">
                        </cc1:CalendarExtender>
                    </div>
                  </div>   
                </td>
                <td>
                   <div >
                    <div class="masterleft" style="overflow: hidden; width:15%;; float: left" >
                        <asp:Label ID="Label19" runat="server" CssClass="labelstyle" Text="Billable" Font-Size="Small"></asp:Label>
                    </div>
                    <div style="overflow: hidden;  width:15%; float: left">
                        <asp:DropDownList ID="DrpBillable" runat="server" CssClass="cssTextbox" Height="25px" >
                            
                            <asp:ListItem Value="1">Yes</asp:ListItem>
                            <asp:ListItem Value="0">No</asp:ListItem>
                        </asp:DropDownList>
                    </div>  
                   </div><div class="masterleft">
                        <asp:Label ID="Label21" runat="server" CssClass="labelstyle" Text="Budgeting" Font-Size="Small"></asp:Label>
                    </div>
                    <div  class="DivRight" style="width:15%; float:left;">
                        <asp:DropDownList ID="ddlBudgetingselection" runat="server" CssClass="cssTextbox" Width="200px" Height="25px">
                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                            <asp:ListItem>Project Budgeting</asp:ListItem>
                            <asp:ListItem>Staff Budgeting</asp:ListItem>
                        </asp:DropDownList></div>            
            </td>  
            </tr> 
        </table></fieldset>
    </asp:Panel>
    <fieldset style="width:1175px; height:450px;">
    <legend style="font-weight:bold; color:Red;">Other Details</legend>
    <asp:Panel ID="Panel2" runat="server" Height="450px" Width="676px">
        <div class="DivSub">
        </div>
        <div class="tabularExtra" style="padding-left:10px; margin:10px;">
            <cc1:TabContainer ID="TabContainer1" runat="server" Height="290px" CssClass="property_tab"
                Width="669px" AutoPostBack="false" BorderColor="Green" 
                Style="padding-left: 15px" ActiveTabIndex="3">
                <cc1:TabPanel ID="TabPanel3" runat="server" HeaderText="Assign Approver">
                    <ContentTemplate>
                        <div>
                            <div>
                                <asp:Label ID="Label9" runat="server" Text="Super Approver"></asp:Label></div>
                            <div class="boexs">
                                <asp:DropDownList ID="drpdwnapp" runat="server" CssClass="cssTextbox" DataTextField="StaffName"
                                    DataValueField="StaffCode" Width="200px">
                                    <asp:ListItem Text="--Select one--" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="drpdwnapp"
                                    runat="server" InitialValue="0" Display="None" ValidationGroup="validjobAdd"
                                    ErrorMessage="Please Select Super Approver in Approver !"></asp:RequiredFieldValidator>
                                <asp:Label ID="Label11" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label></div>
                        </div>
                        <div>
                            <asp:Label ID="Label16" runat="server" Text="Sub Approver"></asp:Label>
                            <div style="width: 300px">
                                <asp:Panel ID="Panel5" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                    Height="200px" ScrollBars="Vertical" Style="overflow: auto; width: 330px; margin: 8px 0 0;
                                    float: left;" Width="350px">
                                    <div style="height: 280px; margin-right: 0px;">
                                        <div id="Div14">
                                            <div class="loader2">
                                                Please Wait.....
                                            </div>
                                        </div>
                                        <table id="datalistSftApprover">
                                        </table>
                                    </div>
                                </asp:Panel>
                                <div style="overflow: hidden; width: 80px; float: left; text-align: left">
                                </div>
                            </div>
                            <asp:Label ID="Label46" runat="server" CssClass="errlabelstyle" ForeColor="Red" Text="*"></asp:Label>
                        </div>
                    </ContentTemplate>
                </cc1:TabPanel>
                <cc1:TabPanel ID="tabPanel2" runat="server" ForeColor="Black">
                <HeaderTemplate>
                <asp:Label runat="server" Text="Assign Staff" CssClass="labelChange"></asp:Label>
                </HeaderTemplate>
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <div>
                                        <asp:Label ID="Label8" runat="server" CssClass="labelstyle labelChange" Text="Department" Font-Size="Small"></asp:Label></div>
                                    <div>
                                        <asp:Panel ID="Panel4" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                            Height="269px" ScrollBars="Vertical" Style="float: left; margin: 8px 0 0;" Width="313px">
                                            <div style="height: 280px; margin-right: 0px;">
                                                <div id="Div13">
                                                    <div class="loader">
                                                        Please Wait.....
                                                    </div>
                                                </div>
                                                <table id="datalistDeptName">
                                                </table>
                                            </div>
                                        </asp:Panel>
                                    </div>
                                </td>
                                <td>
                                    <div style="width: 20px">
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <asp:Label ID="Label15" runat="server" CssClass="labelstyle labelChange" Text="Staff" Font-Size="Small"></asp:Label>&nbsp;<asp:CheckBox
                                            ID="chkall" runat="server" Text="Check All" CssClass="staffchkall" /></div>
                                    <div style="height: 269px">
                                        <asp:Panel ID="Panel3" runat="server" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px"
                                            Height="265px" ScrollBars="Vertical" Style="overflow: auto; width: 300px; float: left;
                                            margin: 8px 0 0;" Width="265px">
                                            <div style="height: 280px; margin-right: 0px;">
                                                <div id="content2">
                                                    <div class="loader2">
                                                        Please Wait.....
                                                    </div>
                                                </div>
                                                <table id="datalistSftName">
                                                </table>
                                            </div>
                                        </asp:Panel>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </cc1:TabPanel>
                <cc1:TabPanel ID="TabPanel1" runat="server" HeaderText="Project Budgeting" ForeColor="Black">
                    <ContentTemplate>
                        <div class="DivSub">
                        </div>
                        <div style="height: 30px" class="tabdiderdiv">
                            <div class="DivLeft" style="width: 150px">
                                <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text="Budgeted Hours"></asp:Label></div>
                            <div class="DivRight" style="width: 480px;">
                                <asp:TextBox ID="txtbudhours" runat="server" CssClass="txtbox calbox" Width="88px"
                                    Text="0"></asp:TextBox></div>
                        </div>
                        <div style="height: 30px" class="tabdiderdiv">
                            <div class="DivLeft" style="padding-left: 5px; width: 150px">
                                <asp:Label ID="Label42" runat="server" CssClass="labelstyle" Text="Budget Amount"
                                    Font-Size="Small"></asp:Label></div>
                            <div class="DivRight" style="width: 480px;">
                                <asp:TextBox ID="txtBudAmt" runat="server" CssClass="txtbox calbox" Text="0" Width="88px"></asp:TextBox></div>
                        </div>
                        <div style="height: 30px" class="tabdiderdiv">
                            <div class="DivLeft" style="padding-left: 5px; width: 165px">
                                <asp:Label ID="Label14" runat="server" CssClass="labelstyle" Text="Other Budgeted"
                                    Font-Size="Small"></asp:Label></div>
                            <div class="DivRight" style="width: 480px;">
                                <asp:TextBox ID="txtbudamtOth" runat="server" Text="0" CssClass="txtbox calbox" Width="88px"></asp:TextBox></div>
                        </div>
                        <div style="height: 30px" class="tabdiderdiv">
                            <div class="noteText">
                                Notes:
                                <div class="txtboxNewError">
                                    <span class="labelstyle">Fields marked with * are required</span></div>
                            </div>
                            <div class="txtboxNew">
                                <span class="labelstyle labelChange" style="overflow: hidden; font-size: 11px;">If you maintaining
                                    Job wise budgeting update Budgeted Amount and Hours.</span>
                            </div>
                        </div>
                    </ContentTemplate>
                </cc1:TabPanel>
                <cc1:TabPanel ID="tab_pane_Staff_budgeting" runat="server" HeaderText="Staff Budgeting">
                    <ContentTemplate>
                        <asp:HiddenField ID="hdnSelectdEmpForStaffBudget" runat="server" />
                        <div style="max-height: 275px; overflow: auto;">
                            <div style="height: 270px; margin-right: 0px;">
                                <div id="Div15">
                                    <div class="loader2">
                                        Please Wait.....
                                    </div>
                                </div>
                                <table cellspacing="0" class="norecordTble" border="1" id="tblStaffbudget" style="border-collapse: collapse;">
                                    <thead>
                                        <tr>
                                            <th class="grdheader">
                                                SrNo
                                            </th>
                                            <th class="grdheader">
                                             <label class="labelChange">Staff Name</label>   
                                            </th>
                                            <th class="grdheader">
                                             <label class="labelChange">Department</label>
                                            </th>
                                            <th class="grdheader">
                                              <label class="labelChange">Designation</label>
                                            </th>
                                            <th class="grdheader">
                                                Hourly Amount
                                            </th>
                                            <th class="grdheader">
                                                Budget Hours
                                            </th>
                                            <th class="grdheader">
                                                Planned Drawings
                                            </th>
                                            <th class="grdheader">
                                                Allocated Hours
                                            </th>
                                            <th class="grdheader">
                                            <label class="labelChange">Staff Actual Hour Rate</label>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr style="color: rgb(0, 0, 102); height: 15px;">
                                            <td align="right">
                                            </td>
                                            <td style="width: 50%;">
                                            </td>
                                            <td>
                                            </td>
                                            <td>
                                            </td>
                                            <td align="right">
                                            </td>
                                            <td align="right">
                                            </td>
                                            <td align="right">
                                            </td>
                                            <td align="right">
                                            </td>
                                            <td align="right">
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <%--                            <asp:GridView runat="server" ID="gvStaffbudget" class="norecordTble" ShowHeaderWhenEmpty="true"
                                EmptyDataText="No Records Found !" HeaderStyle-Wrap="true" AutoGenerateColumns="false">
                                <HeaderStyle CssClass="grdheader" />
                                <RowStyle Height="15px" ForeColor="#000066" />
                                <Columns>
                                    <asp:TemplateField HeaderText="SrNo">
                                        <ItemStyle HorizontalAlign="Right" />
                                        <ItemTemplate>
                                            <asp:Label ID="lblSerialNo" runat="server" Text='<%#Container.DataItemIndex+1 %>'></asp:Label>
                                            <asp:HiddenField ID="hdnStaffCode" runat="server" Value='<%#Eval("StaffCode") %>' />
                                            <asp:CheckBox ID="chkStaffBudgetCheckEmp" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="StaffName" ItemStyle-Width="50%" HeaderText="Staff Name" />
                                    <asp:TemplateField HeaderText="Hourly Amount">
                                        <ItemStyle HorizontalAlign="Right" />
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtStaffbudget" Text="0" CssClass="txtbox" Width="50px" Style="text-align: right;"
                                                runat="server"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Budget Hours">
                                        <ItemStyle HorizontalAlign="Right" />
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtHours" Text="0" Width="50px" Style="text-align: right;" CssClass="txtbox"
                                                runat="server"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>--%>
                        </div>
                        <div style="height: 30px" class="tabdiderdiv">
                            <div class="txtboxNew">
                                <span class="labelstyle" style="overflow: hidden; font-size: 11px;">If you maintaining
                                    Staff wise budgeting update staff hourly Amount and Budgeted Hours. Plan Drawings
                                    will be only for engineering/architectural firms.</span>
                            </div>
                        </div>
                    </ContentTemplate>
                </cc1:TabPanel>
            </cc1:TabContainer>
            <table>
                <tr>
                    <td>
                        <asp:CustomValidator ID="CustomValidator1" Display="None" ClientValidationFunction="customVaidationforselectoneSubApprover"
                            ValidationGroup="validjobAdd" runat="server" ErrorMessage="Please Select At least one Sub Approver in Approver !"></asp:CustomValidator>
                        <asp:ValidationSummary ID="ValidationSummary1" ValidationGroup="validjobAdd" ShowMessageBox="true"
                            ShowSummary="false" runat="server" />
                        <asp:Button ID="btnsave" runat="server" ValidationGroup="validjobAdd" Text="Save" 
                            OnClick="BtnSave_Click" class="cssButton" />
                    </td>
                    <td>
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" class="cssButton" OnClick="btnCancel_Click" />
                    </td>
                </tr>
            </table>
        </div></fieldset>
    </asp:Panel>
</div>
<%----------------Modalpopup for Client-----------   --%>
<div>
    <asp:Button Style="display: none" ID="Button4" runat="server"></asp:Button>
    <br />
    <cc1:ModalPopupExtender ID="ModalPopupExtender3" runat="server" BackgroundCssClass="modalBackground"
        PopupControlID="panel8" CancelControlID="imgclientClose" BehaviorID="ModalPBehaviorIDopupExtender3"
        TargetControlID="Button4">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panel8" runat="server" CssClass="RoundpanelNarrNewpopNew">
        <uc1:MessageControl ID="MessageControl5" runat="server" />
        <div class="header1-1">
            <div class="Modalheader22">
                <asp:Label ID="Label18" runat="server" Text="Add Client" CssClass="Ttlepopu labelChange labelChange"></asp:Label>
            </div>
            <div id="Div7" class="ModalCloseButton">
                <img alt="" src="../images/error.png" id="imgclientClose" border="0" name="imgClose" />
            </div>
        </div>
        <div id="Div4" runat="server" class="Singleline-roundcornerJob">
            <div class="ModalSmasterleftrowNew">
           <label class="labelChange">Client Name</label> :</div>
            <div class="mastermid">
            </div>
            <div class="MSmasterright1New">
                <asp:TextBox ID="txtclientname" runat="server" Height="20px" Width="400px"></asp:TextBox>
            </div>
        </div>
        <div id="Div5" runat="server" class="Singleline-roundcornerJob">
            <div class="masterwholeincsep">
            </div>
            <div id="Div6" runat="server" class="ModalSingleline-roundcorner">
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="Smasterright3New">
                    <asp:Button ID="btnclientname" runat="server" Text="Save" class="TbleBtnsPading TbleBtns"
                        OnClick="btnclientname_Click" />
                    <asp:Button ID="btncname" runat="server" Text="Cancel" class="TbleBtnsPading TbleBtns"
                        OnClick="btncname_Click" Visible="false" />
                </div>
            </div>
        </div>
    </asp:Panel>
</div>
<%----------------Modalpopup for Job-----------   --%>
<div>
    <asp:Button Style="display: none" ID="Button1" runat="server"></asp:Button>
    <br />
    <cc1:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="modalBackground"
        PopupControlID="panel6" CancelControlID="img1" BehaviorID="ModalPopupExtBehaviorIDender1"
        TargetControlID="Button1">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panel6" runat="server" CssClass="RoundpanelNarrNewpopNew">
        <div class="header1">
            <uc1:MessageControl ID="MessageControl3" runat="server" />
        </div>
        <div class="header1-1">
            <div class="Modalheader22">
                <asp:Label ID="Label5" runat="server" Text="Add Job Name" CssClass="Ttlepopu labelChange"></asp:Label>
            </div>
            <div id="Div11" class="ModalCloseButton">
                <img alt="" src="../images/error.png" id="img1" border="0" name="imgClose" />
            </div>
        </div>
        <div id="Div8" runat="server" class="Singleline-roundcornerJob">
            <div class="ModalSmasterleftrowNew">
                <label class="labelChange">Job Name:</label> </div>
            <div class="mastermid">
            </div>
            <div class="MSmasterright1New">
                <asp:TextBox ID="txtjob" runat="server" Height="20px" Width="400px"></asp:TextBox>
            </div>
        </div>
        <div id="Div9" runat="server" class="Singleline-roundcornerJob">
            <div class="masterwholeincsep">
            </div>
            <div id="Div10" runat="server" class="ModalSingleline-roundcorner">
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="Smasterright3New">
                    <asp:Button ID="btJobNamens" runat="server" Text="Save" class="TbleBtnsPading TbleBtns"
                        OnClick="btns_Click" />
                    <asp:Button ID="btnc" runat="server" Text="Cancel" class="TbleBtnsPading TbleBtns"
                        OnClick="btnc_Click" Visible="false" />
                </div>
            </div>
        </div>
    </asp:Panel>
</div>
<%-------------------ModalPopup for jobgroup------------------------%>
<div>
    <asp:Button Style="display: none" ID="Button3" runat="server"></asp:Button>
    <br />
    <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" BackgroundCssClass="modalBackground"
        PopupControlID="panel7" CancelControlID="img2" BehaviorID="fasdfasfdas" TargetControlID="Button3">
    </cc1:ModalPopupExtender>
    <asp:Panel ID="panel7" runat="server" CssClass="RoundpanelNarrNewpopNew">
        <div class="header1">
                <uc1:MessageControl ID="MessageControl4" runat="server" />
        </div>
        <div class="header1-1">
            <div class="Modalheader22">
                <asp:Label ID="Label17" runat="server" Text="Add Job Group" CssClass="Ttlepopu labelChange"></asp:Label>
            </div>
            <div id="Div12" class="ModalCloseButton">
                <img alt="" src="../images/error.png" id="img2" border="0" name="imgClose" />
            </div>
        </div>
        <div id="Div1" runat="server" class="Singleline-roundcornerJob">
            <div class="ModalSmasterleftrowNew">
                <label class="labelChange">Job Group :</label> </div>
            <div class="mastermid">
            </div>
            <div class="MSmasterright1New">
                <asp:TextBox ID="txtjg" runat="server" Height="20px" Width="400px"></asp:TextBox>
            </div>
        </div>
        <div id="Div2" runat="server" class="Singleline-roundcornerJob">
            <div id="Div3" runat="server" class="ModalSingleline-roundcorner">
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="mastermid">
                </div>
                <div class="Smasterright3New">
                    <asp:Button ID="bJgtnsJg" runat="server" Text="Save" class="TbleBtnsPading TbleBtns"
                        OnClick="btnsJg_Click" />
                    <asp:Button ID="btncJg" runat="server" Text="Cancel" class="TbleBtnsPading TbleBtns"
                        OnClick="btncJg_Click" Visible="false" />
                </div>

            </div>
        </div>
    </asp:Panel>
</div>
