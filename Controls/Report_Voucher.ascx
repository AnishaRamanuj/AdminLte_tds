<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Report_Voucher.ascx.cs" Inherits="controls_Report_Voucher" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit"
    TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl"
    TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<link href="../StyleCss/Divstyle.css" rel="stylesheet" type="text/css" />
<script language="javascript" type="text/javascript">
    $(document).ready(function () {
//        BindPageLoadStaff();



//        $("[id*=btngen]").on("click", function () {

//            var voucher = '';
//            $(".chkitem:checked").each(function () {
//                voucher += $(this).val() + ',';
//            });

//            if (voucher == '')
//            { alert('Please select at least one Voucher !'); return false; }
//            $("[id*=hdnSelectedvoucher]").val(voucher);
//            $(".modalganesh").show();
//        });
//        $("[id*=btnBack]").on("click", function () { $(".modalganesh").show(); });
//        $("[id*=chkjob1]").on("click", function () {

//            var check = $(this).attr('checked');
//            $(".chkItems").each(function () {
//                if (check)
//                { $(this).attr('checked', 'checked'); }
//                else { $(this).removeAttr('checked'); }
//            });
//        });

//        $("[id*=txtstartdate1]").on("change", function () { BindPageLoadStaff(); });
//        $("[id*=txtenddate2]").on("change", function () { BindPageLoadStaff(); });
//       $("[id*=ddlStatus]").on("change", function () { BindPageLoadStaff(); });
    });
    function pad2(number) {
        return (number < 10 ? '0' : '') + number
    }
    function checkForm() {
        // regular expression to match required date format
        var dt = new Date();
        var day = dt.getDate();
        var mon = dt.getMonth() + 1;
        var yr = dt.getFullYear();
        var pin = document.getElementById("<%= txtstartdate1.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
        // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {

            alert("Invalid date format: " + pin);
            document.getElementById("<%= txtstartdate1.ClientID%>").focus();
            var days = pad2(day);
            var month = pad2(mon);
            document.getElementById("<%= txtstartdate1.ClientID%>").value = days + "/" + month + "/" + yr;
            return false;
        }
    }
    function checkForms() {
        // regular expression to match required date format
        var dt = new Date();
        var day = dt.getDate();
        var mon = dt.getMonth() + 1;
        var yr = dt.getFullYear();
        var pin = document.getElementById("<%= txtenddate2.ClientID%>").value;
        if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
        // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
        {

            alert("Invalid date format: " + pin);
            document.getElementById("<%= txtenddate2.ClientID%>").focus();
            var days = pad2(day);
            var month = pad2(mon);
            document.getElementById("<%= txtenddate2.ClientID%>").value = days + "/" + month + "/" + yr;
            return false;
        }
    }
//    function BindPageLoadStaff() {
//     debugger
//        if ($("[id*=txtstartdate1]").val() == "" || $("[id*=txtstartdate1]").val() == undefined)
//        { return false; }
//        var c = $("[id*=hdnCompid]").val();
//        var u = $("[id*=hdnUserType]").val();
//        var fr = $("[id*=txtstartdate1]").val();
//        var to = $("[id*=txtenddate2]").val();
//        var st = $("[id*=ddlStatus]").val();
//        var sc = $("[id*=hdnStaffCode]").val();
//        var clt = $("[id*=drpClient]").val();
//        var j = $("[id*=drpjob]").val();
//        $(".modalganesh").show();
//        //Ajax start
//        $.ajax({
//            type: "POST",
//            contentType: "application/json; charset=utf-8",
//            url: "../Handler/wsVoucher.asmx/BindExpList",
//            //data: "{compid:" + c + ",UserType:'" + u + "',FromDate:'" + fr + "',ToDate:'" + to + "',status:'" + st + "',StaffCode:'" + sc + "'}",
//            data: "{compid:" + c + ",UserType:'" + u + "',FromDate:'" + fr + "',ToDate:'" + to + "',ST:'" + st + "',StaffCode:'" + sc + "',clt:" + clt + ",j: " + j + "}",
//            dataType: "json",
//            success: OnSuccess,
//            failure: function (response) {

//            },
//            error: function (response) {

//            }
//        });
//        //Ajax end
//    }
//    function OnSuccess(response) {
//        var obj = jQuery.parseJSON(response.d);
//        var tableRows = '';
//        $("[id*=chkjob1]").parent().find('label').text("Check All Expenses (Count :" + obj.length + ")");
//        $.each(obj, function (i, vl) {
//            tableRows += "<tr><td><input type='checkbox' class='chkItems' value='" + vl.Tsid + "' /></td><td>" + vl.opeName + "</td></tr>";
//        });
//        $("[id*=chkjob1]").removeAttr('checked');
//        $("[id*=Panel1]").html("<table>" + tableRows + "</table>");
//        $(".modalganesh").hide();
//    }
</script>
<div class="divstyle">
    <div class="headerpage">
        <div class="headerstyle1_page">
            <asp:Label ID="Label2" runat="server" CssClass="Head1" Text="Expense Voucher"></asp:Label>
            <div style="float: right;">
                <asp:Button ID="btnBack" runat="server" CssClass="TbleBtns" Text="Back"
                    Visible="false" OnClick="btnBack_Click" /></div>
            <asp:HiddenField runat="server" ID="hdnCompid" />
            <asp:HiddenField runat="server" ID="hdnUserType" />
            <asp:HiddenField runat="server" ID="hdnSelectedVoucher" />
            <asp:HiddenField runat="server" ID="hdnStaffCode" />
        </div>
    </div>
    <div id="div2" class="totbodycatreg" style="height: 700px;">
        <div style="width: 100%;">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
        </div>
        <div class="row_report" runat="server" id="divReportInput">
            <div>
                <table class="style1" style="float: left;">
                    <tr>
                        <td style="vertical-align: top;">
                            <table class="style1">
                                 <tr>
                                    <td>
                                      <asp:RadioButton ID="rbtn1" runat="server" ForeColor="Black" Text="Detailed XL Report"
                                            Font-Bold="True" oncheckedchanged="rbtn1_CheckedChanged" AutoPostBack=true  ></asp:RadioButton>
                                    </td>
                                    <td >
                                        
                                    </td>
                                    <td>
                                      <asp:RadioButton ID="rbtn2" runat="server" ForeColor="Black" Text="Voucher Report"
                                            Font-Bold="True" oncheckedchanged="rbtn2_CheckedChanged" AutoPostBack=true ></asp:RadioButton>
                                    </td>
                                </tr>
                               <tr>
                                    <td>
                                        <asp:Label ID="Label11" runat="server" ForeColor="Black" Text="From"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center">
                                        :
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtstartdate1" runat="server" CssClass="texboxcls" 
                                            AutoPostBack="true" ontextchanged="txtstartdate1_TextChanged" ></asp:TextBox>
                                        <asp:Image ID="Image1" runat="server" ImageUrl="~/images/calendar.png"
                                            Style="float: left; margin-right: 10px;" />
                                        <asp:Label ID="Label5" runat="server" CssClass="errlabelstyle"
                                            ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender3" runat="server" TargetControlID="txtstartdate1"
                                            PopupButtonID="Image1" Format="dd/MM/yyyy">
                                        </cc1:CalendarExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label4" runat="server" ForeColor="Black" Text="To"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center">
                                        :
                                    </td>
                                    <td >
                                        <asp:TextBox ID="txtenddate2" runat="server" CssClass="texboxcls" 
                                            ontextchanged="txtenddate2_TextChanged" AutoPostBack="true"></asp:TextBox>
                                        <asp:Image ID="Image2" runat="server" ImageUrl="~/images/calendar.png"
                                            Style="float: left; margin-right: 10px;" />
                                        <asp:Label ID="Label7" runat="server" CssClass="errlabelstyle"
                                            ForeColor="Red" Text=""></asp:Label>
                                        <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtenddate2"
                                            PopupButtonID="Image2" Format="dd/MM/yyyy">
                                        </cc1:CalendarExtender>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label1" runat="server" ForeColor="Black" Text="Client"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center">
                                        :
                                    </td>
                                    <td>
                                        <div class="divedBlock">
                                            <asp:DropDownList ID="drpClient" runat="server" AutoPostBack="True" DataTextField="ClientName"
                                             DataValueField="CltId" Style="cursor: pointer; width: 310px !important;" 
                                                CssClass="dropstyleJob"  onselectedindexchanged="drpClient_SelectedIndexChanged"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label3" runat="server" ForeColor="Black" Text="Job"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center">
                                        :
                                    </td>
                                    <td>
                                        <div class="divedBlock">
                                                <asp:DropDownList ID="drpjob" runat="server" DataTextField="mJobname" DataValueField="JobID"
                                                    Style="cursor: pointer; width: 310px !important;" CssClass="dropstyleJob" AutoPostBack="true" 
                                                    onselectedindexchanged="drpjob_SelectedIndexChanged">
                                                </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="Label6" runat="server" ForeColor="Black" Text="Expense Approved"
                                            Font-Bold="True"></asp:Label>
                                    </td>
                                    <td align="center">
                                        :
                                    </td>
                                    <td>
                                        <div class="divedBlock">
                                            <asp:DropDownList runat="server" ID="ddlStatus" CssClass="dropstyleJob" AutoPostBack="true" 
                                                onselectedindexchanged="ddlStatus_SelectedIndexChanged">
                                                <asp:ListItem>All</asp:ListItem>
                                                <asp:ListItem Selected="True">Approved</asp:ListItem>
                                                <asp:ListItem>Submitted</asp:ListItem>
                                                <asp:ListItem>Rejected</asp:ListItem>
                                                
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>


                                <tr>
                                    <td>
                                    </td>
                                    <td colspan="2" align="left">
                                        <asp:Button ID="btngen" runat="server" CssClass="TbleBtns" OnClick="btngen_Click"
                                            Text="Generate Report" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td class="style2" style="width: 380px; padding-left: 10px;">
                            <table class="style1">
                                <tr>
                                    <td align="right">
                                        <asp:CheckBox  ID="chkexp" runat="server" ForeColor="Black" AutoPostBack="true"  
                                            Font-Bold="true" Height="20px" Text=" Check All" 
                                            oncheckedchanged="chkexp_CheckedChanged" />
                                    </td>
                                </tr>
                            </table>
                            <div style="padding-bottom: 10px; width: 379px; float: left;
                                height: 450px;">
                                <asp:Panel ID="Panel1" runat="server" BorderColor="#B6D1FB" BorderStyle="Solid"
                                    BorderWidth="1px" class="panel_style" Height="600px" ScrollBars="Auto"
                                    Width="352px">
                                <asp:DataList ID="DlstExp" runat="server" Width="350px" ForeColor="Black">
                                <ItemTemplate>
                                   <table >
                                      <tr style="height:17px" >
                                       <td>
                                            <asp:CheckBox ID="chkitem" runat="server" />
                                       </td>    
                                       <td>
                                            <asp:Label ID="Label50" runat="server" Text='<%# bind("tsid") %>' Visible="False"></asp:Label>
                                            <asp:Label ID="Label51" runat="server" Text='<%# bind("opeName") %>'></asp:Label>
                                        </td>
                                    </tr>
                                   </table> 
                                </ItemTemplate>
                                
                                </asp:DataList>
                                </asp:Panel>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <rsweb:ReportViewer ID="ReportViewer1" Height="670px" Width="795px"
            Visible="false" runat="server" AsyncRendering="False" InteractivityPostBackMode="AlwaysAsynchronous">
        </rsweb:ReportViewer>
    </div>
</div>
