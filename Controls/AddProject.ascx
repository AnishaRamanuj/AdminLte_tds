<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddProject.ascx.cs" Inherits="controls_AddProject" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script type="text/javascript" src="../jquery/moment.js"></script>
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        var newDate = new Date();
        $("[id*=hdnDT]").val(newDate);
        if ($("[id*=hdnlink]").val() == "1")
        {
            $("[id*=trCl]").hide();
        }
        else
        {
            $("[id*=trCl]").show();
        }
    });
    function ShowModalPopup(i) {
        if (i == 0) {
            $("[id*=txtprojectname]").val('');
            $("[id*=ddlClient]").val(0);
            $("[id*=txtprojecthour]").val('00.00');
            $("[id*=txtprojectamount]").val('0');
            $("[id*=txtusedhours]").val('00.00');
            $("[id*=hdnprojectid]").val(0);
            $("[id*=txtstartdate]").val('');
            $("[id*=txtactualdate]").val('');
        }
        $find("programmaticModalPopupOrginalBehavior").show();
        return false;
    }
    function HideModalPopup() {
        $find("programmaticModalPopupOrginalBehavior").hide();
        return false;
    }

    $(document).ready(function () {
        $("#txtusedhours").keypress(function () {
            $this = $(this);
            if ($this.val().length == 2) {
                $this.val($this.val() + ":");
            }
        });
        $("[id*=ddlProjectClient]").on('change', function () {
            $("[id*=txtsearch]").val('');
        });

        $("[id*=txtprojecthour]").blur(function () {

            var tTime = $("[id*=txtprojecthour]").val();
            if (tTime == '0') {
                tTime = '00.00';
            }
            var startTime = tTime.replace(':', '.');
            var firstHH = startTime.split('.')[0];
            var firstMM = startTime.split('.')[1];
            if (firstMM == undefined) {
                firstMM = "0";
            }

            if (firstHH == undefined) {
                firstHH = "0";
            }

            if (firstHH == "") {
                firstHH = "0";
            }
            if (firstMM == "") {
                firstMM = "0";
            }

            if (firstMM >= 60) {
                var realmin = firstMM % 60;
                var hours = Math.floor(firstMM / 60);
                firstHH = parseFloat(firstHH) + parseFloat(hours);

                firstMM = realmin;
            }

            if (firstMM < 10) {
                if (parseFloat(firstMM.length) < 2) {
                    firstMM = "0" + firstMM;
                }
            }

            if (firstHH < 10) {
                if (parseFloat(firstHH.length) < 2) {
                    firstHH = "0" + firstHH;
                }
            }
            tTime = firstHH + '.' + firstMM;
            $("[id*=txtprojecthour]").val(tTime);
        });

        $("[id*=txtusedhours]").blur(function () {

            var tTime = $("[id*=txtusedhours]").val();
            if (tTime == '0') {
                tTime = '00.00';
            }
            var startTime = tTime.replace(':', '.');
            var firstHH = startTime.split('.')[0];
            var firstMM = startTime.split('.')[1];
            if (firstMM == undefined) {
                firstMM = "0";
            }
            if (firstHH == undefined) {
                firstHH = "0";
            }

            if (firstHH == "") {
                firstHH = "0";
            }
            if (firstMM == "") {
                firstMM = "0";
            }
            if (firstMM >= 60) {
                var realmin = firstMM % 60;
                var hours = Math.floor(firstMM / 60);
                firstHH = parseFloat(firstHH) + parseFloat(hours);

                firstMM = realmin;
            }

            if (firstMM < 10) {
                if (parseFloat(firstMM.length) < 2) {
                    firstMM = "0" + firstMM;
                }
            }

            if (firstHH < 10) {
                if (parseFloat(firstHH.length) < 2) {
                    firstHH = "0" + firstHH;
                }
            }
            tTime = firstHH + '.' + firstMM;
            $("[id*=txtusedhours]").val(tTime);
        });

        //$("[id*=txtactualdate]").blur(function () {
        //    var ct1 = new Date();
        //    var ct2 = new Date();
        //    ct1 = moment($("[id*=txtstartdate]").val());
        //    ct2 = moment($("[id*=txtactualdate]").val());

        //    if (moment($("[id*=txtstartdate]").val()) > moment($("[id*=txtactualdate]").val()))
        //    {
        //        $("[id*=txtactualdate]").val();
        //        alert('End Date cannot be less then Start Date');
        //    }
        //});


    });

    //function CallServerSide(controlid) {
    //    $("[id*=hdnOnblur]").val('1');
    //    var s = $("[id*=txtstartdate]").val();
    //    var e = $("[id*=txtactualdate]").val();
    //    $("[id*=hdnST]").val(s);
    //    $("[id*=hdnEd]").val(e);
    //    setTimeout(__doPostBack(controlid, ''), 0);
    //}

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

    function StartDate() {
        alert('Start Date Cannot be Blank');
    }
    function Enddate() {
        alert('End Date Cannot be Blank');
    }

    function alertMessage() {
        alert('End Date Cannot be less than Start Date');
    }

</script>
<style type="text/css">
    .active_pager {
        line-height: 20px;
        display: inline-block;
        text-align: center;
        text-decoration: none;
        background-color: #f5f5f5;
        color: #969696;
        border: 1px solid #969696;
        padding: 2px;
    }

    .pager {
        padding: 2px;
        line-height: 20px;
        display: inline-block;
        text-align: center;
        text-decoration: none;
        background-color: #f5f5f5;
        color: #000;
        border: 1px solid #969696;
    }

    .txt_grds {
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
<div>
    <asp:HiddenField ID="hdnOnblur" runat="server" />
    <asp:HiddenField ID="hdnST" runat="server" />
    <asp:HiddenField ID="hdnEd" runat="server" />
    <asp:HiddenField ID="hdnlink" runat="server" />
    <table style="width: 100%" class="cssPageTitle">
        <tr>
            <td class="cssPageTitle2">
                <asp:Label ID="Label18" runat="server" Style="margin-left: 10px;" Text="Manage Projects"></asp:Label>
                <asp:Label ID="lblCount" runat="server" Style="margin-left: 10px;" Text=""></asp:Label>
            </td>
        </tr>
    </table>

    <asp:HiddenField ID="hdnDT" runat="server" />
</div>

<div style="width: 100%">
    <uc1:MessageControl ID="MessageControl2" runat="server" />
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true"
        ShowSummary="false" ValidationGroup="projectvalidate" />
</div>
<asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server"></asp:Button><br />
<cc1:ModalPopupExtender BackgroundCssClass="modalBackground" BehaviorID="programmaticModalPopupOrginalBehavior"
    RepositionMode="RepositionOnWindowScroll" DropShadow="False" ID="ModalPopupExtender2"
    TargetControlID="hideModalPopupViaClientOrginal2" CancelControlID="imgBudgetdClose"
    PopupControlID="panel10" runat="server">
</cc1:ModalPopupExtender>
<asp:Panel ID="panel10" runat="server" Width="650px" BackColor="#FFFFFF">

    <div id="Div1" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff; font-weight: bold;">
        <div id="Div2" style="width: 90%; float: left; height: 20px; padding-left: 2%; padding-top: 3%; padding-bottom: 3%;">
            <asp:Label ID="lblpopup" runat="server" CssClass="subHead1" Text="Add Project"></asp:Label>
        </div>
        <div id="Div3" class="ModalCloseButton">
            <img alt="" src="../images/error.png" id="imgBudgetdClose" border="0" name="imgClose"
                onclick="return HideModalPopup()" />
        </div>
    </div>
    <div id="divprojectadd" runat="server" class="comprw">
        <center>
            <table style="font-weight: bold; width: 580px;">
                <tr style="padding-bottom: 10px">
                    <td>
                    </td>
                </tr>
                <tr>
                    <td class="LabelFontStyle labelChange">
                        Project Name
                    </td>
                    <td>
                        :
                    </td>
                    <td>
                        <asp:TextBox ID="txtprojectname" runat="server" CssClass="cssTextbox" Font-Names="Verdana"
                            Font-Size="8pt" Width="345px" Height="22px"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Please Enter Project Name"
                            ControlToValidate="txtprojectname" ValidationGroup="projectvalidate" Display="None"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                </tr>
                <tr id="trCl">
                    <td class="LabelFontStyle labelChange">
                        Client Name
                    </td>
                    <td>
                        :
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlClient" runat="server" CssClass="cssTextbox" Width="345px" Height="22px">
                        </asp:DropDownList>
                        <asp:Label ID="Label3" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please Select Client Name"
                            ControlToValidate="ddlClient" InitialValue="0" ValidationGroup="projectvalidate"
                            Display="None"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td >Currency
                    </td>
                    <td>
                        :
                    </td>
                    <td style="width:360px;">
                        <asp:DropDownList ID="drpcash" runat="server" CssClass="txtbox" Width="100px" Height="30px" TabIndex="5">
                            <%-- <asp:ListItem> Indian Rupees</asp:ListItem>--%>
                        </asp:DropDownList>
                    </td>
            
                </tr>
              </table>
            <table style="width: 580px;font-weight: bold;">  

                <tr>

                    <td style="overflow: hidden; width:200px;   font-weight:bold;" class="LabelFontStyle labelChange">Start Date</td>
                    <td>
                        <asp:TextBox ID="txtstartdate" runat="server" CssClass="cssTextBoxDate"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtstartdate"
                                    Mask="99/99/9999" MaskType="Date" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
                                    CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                    CultureTimePlaceholder="" Enabled="True" />
                                <%--<asp:Label ID="Label10" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>--%>
                                <cc1:CalendarExtender ID="Calendarextender1" runat="server" TargetControlID="txtstartdate"
                                    PopupButtonID="txtstartdate" Format="dd/MM/yyyy" Enabled="True">
                                </cc1:CalendarExtender></td>
                    <td style="overflow: hidden; width:100px; padding-left: 5px; font-weight:bold;" class="LabelFontStyle labelChange">End Date</td>
                    <td><asp:TextBox ID="txtactualdate" runat="server" CssClass="cssTextBoxDate" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender16" runat="server" TargetControlID="txtactualdate"
                                    Mask="99/99/9999" MaskType="Date" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder=""
                                    CultureDateFormat="" CultureDatePlaceholder="" CultureDecimalPlaceholder="" CultureThousandsPlaceholder=""
                                    CultureTimePlaceholder="" Enabled="True" />
                                <%--<asp:Label ID="Label26" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>--%>
                                <cc1:CalendarExtender ID="txtactualdate_CalendarExtender" runat="server" TargetControlID="txtactualdate"
                                    PopupButtonID="txtactualdate" Format="dd/MM/yyyy" Enabled="True">
                                </cc1:CalendarExtender>


                    </td>
                </tr>
                </table>
            <table  style="width: 580px;font-weight: bold;">
                <tr >
                    <td  Style="width:189px;" class="LabelFontStyle labelChange">
                        Project Hours
                    </td>
                    <td Style="width:14px;">
                        :
                    </td>
                    <td>
                        <asp:TextBox ID="txtprojecthour" runat="server" CssClass="texboxcls txtFrmTime txt_grds" Style="text-align:right;"  
                            Font-Names="Verdana" Text="00.00" Font-Size="8pt" Width="50px" Height="19px"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Please Enter Project Hours"
                            ControlToValidate="txtprojecthour" Display="None" ValidationGroup="projectvalidate"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="Enter a Valid Time with Minutes"
                            Display="None" ValidationExpression="(\d+).[0-5][0-9]" ValidationGroup="projectvalidate"
                            ControlToValidate="txtprojecthour"></asp:RegularExpressionValidator>
                    </td>
                            <td style="padding-left: 50px;">
                        Status
                    </td>
                    <td style="text-align: right;">
                            <asp:DropDownList ID="drpstatus" runat="server" CssClass="cssTextbox" Width="130px" Height="22px">
                                <asp:ListItem Value="OnGoing">OnGoing</asp:ListItem>
                                 <asp:ListItem Value="OnHold">OnHold</asp:ListItem>
                                <asp:ListItem Value="Completed">Completed</asp:ListItem>
                        </asp:DropDownList>
                        <%--<select id="drpstatus" name="drpstatus" runat="server" class="DropDown" style="width: 130px; height: 25px;">--%>
                       <%--     <option>OnGoing</option>
                            <option>Completed</option>--%>
                        <%--</select>--%>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                </tr>
                <tr >
                    <td Style="width:189px;" class="LabelFontStyle labelChange">
                        Project Amount
                    </td>
                    <td Style="width:14px;">
                        :
                    </td>
                    <td>
                        <asp:TextBox ID="txtprojectamount" runat="server" CssClass="texboxcls" Font-Names="Verdana" Style="text-align:right;"
                            Text="0" Font-Size="8pt" Width="50px"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Enter Amount in Numeric"
                            ControlToValidate="txtprojectamount" ValidationExpression="\d+" ValidationGroup="projectvalidate"
                            Display="None"></asp:RegularExpressionValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtprojectamount"
                            Display="None" ErrorMessage="Please Enter Project Amount" ValidationGroup="projectvalidate"></asp:RequiredFieldValidator>
                    </td>
                                                <td style="padding-left: 50px;">
                        Product Line
                    </td>
                    <td style="text-align: right;">
              <asp:TextBox ID="txtpdtLine" runat="server" CssClass="cssTextbox" Font-Names="Verdana"
                            Font-Size="8pt" Width="125px" Height="22px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                </tr>
                <tr >
                    <td Style="width:189px;" class="LabelFontStyle labelChange">
                        Used Project Hours
                    </td>
                    <td Style="width:14px;">
                        :
                    </td>
                    <td>
                        <asp:TextBox ID="txtusedhours" runat="server" CssClass="texboxcls" Font-Names="Verdana"  Style="text-align:right;"
                            Text="00.00" Font-Size="8pt" Width="50px"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtusedhours"
                            Display="None" ErrorMessage="Please Enter used Project Amount" ValidationGroup="projectvalidate"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>

                    <td>
                        <table>
                            <tr>
                                <td>
                                    <asp:Button ID="btnsaveproject" runat="server" CssClass="cssButton" Text="Save" OnClick="btnsaveproject_Click"
                                        ValidationGroup="projectvalidate" UseSubmitBehavior="False" />
                                </td>
                                <td>
                                    <asp:Button ID="btncancel" runat="server" CssClass="cssButton" Text="Cancel" OnClientClick="return HideModalPopup()" />
                                    <asp:HiddenField ID="hdnprojectid" runat="server" Value="0" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </center>
    </div>
</asp:Panel>
<div id="divgridproject" runat="server" width="100%">
    <div style="overflow: hidden; width: 100%; float: left;">
    </div>
    <div style="float: left; padding-left: 1px">
        <div class="serachJob" style="float: left;">
            <table>
                <tr>
                    <td class="serachJob" style="float: left; width: 100%; margin: 10px; overflow: auto;">
                        <asp:Label ID="Label1" CssClass="serachJob" runat="server">Search Project/Client Name:</asp:Label>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlProjectClient" runat="server" CssClass="cssTextbox" Height="22px">
                            <asp:ListItem Value="Project" Text="Project"></asp:ListItem>
                            <asp:ListItem Value="Client" Text="Client"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:TextBox ID="txtsearch" runat="server" CssClass="cssTextbox" Font-Names="Verdana"
                            Font-Size="8pt" Width="150px"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Button ID="btnsrchproject" runat="server" CssClass="cssButton"
                            Text="Search" OnClick="btnsrchproject_Click" />
                    </td>
                    <td>
                        <asp:Button ID="btnaddproject" runat="server" CssClass="cssButton"
                            Text="Add Project" OnClientClick="return ShowModalPopup(0)" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div style="overflow: hidden; width: 100%; float: left;">
    </div>
    <div class="msterrhtbxwhlecntrllft" style="float: left; margin: 10px; width: 1175px; padding-right: 15px;">
        <asp:GridView ID="gvProjects" runat="server" AutoGenerateColumns="false" EmptyDataText="No record found!"
            ShowHeaderWhenEmpty="true" Width="100%" BorderColor="#55A0FF" CssClass="norecordTble"
            OnRowCommand="projects_alters">
            <%--    <PagerSettings Mode="NextPreviousFirstLast" FirstPageText="First" LastPageText="Last" NextPageText="Next" PreviousPageText="Previous" />
                <RowStyle Height="15px" />--%>
            <Columns>
                <asp:TemplateField HeaderStyle-CssClass="grdheader" HeaderText="Sr.No">
                    <ItemTemplate>
                        <div class="gridcolstyle" align="center">
                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text='<%# bind("sino") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <ItemStyle CssClass="griditemstlert1" Width="8%" BackColor="White" />
                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Project Name" HeaderStyle-CssClass="grdheader">
                    <ItemTemplate>
                        <div>
                            <asp:Label ID="projectname" runat="server" CssClass="labelstyle" Text='<%#Eval("ProjectName")%>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <ItemStyle Width="35%" CssClass="griditemstlert1" BackColor="White" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Client Name" HeaderStyle-CssClass="grdheader">
                    <ItemTemplate>
                        <div class="gridpages">
                            <asp:Label ID="clientname" runat="server" CssClass="labelstyle" Text='<%#Eval("clientName")%>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <ItemStyle Width="35%" CssClass="griditemstlert1" BackColor="White" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Start Date" HeaderStyle-CssClass="grdheader">
                    <ItemTemplate>
                        <div class="gridpages" style="text-align: center;">
                            <asp:Label ID="StartDate" runat="server" CssClass="labelstyle" Text='<%#Eval("StartDate")%>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <ItemStyle Width="20%" CssClass="griditemstlert1" BackColor="White" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="End Date" HeaderStyle-CssClass="grdheader">
                    <ItemTemplate>
                        <div class="gridpages" style="text-align: center;">
                            <asp:Label ID="EndDate" runat="server" CssClass="labelstyle" Text='<%#Eval("EndDate")%>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <ItemStyle Width="25%" CssClass="griditemstlert1" BackColor="White" />
                </asp:TemplateField>


                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheader">
                    <ItemStyle Width="12%" CssClass="griditemstlert1" BackColor="White" />
                    <ItemTemplate>
                        <div style="text-align: center">
                            <asp:ImageButton ID="edit" runat="server" CommandArgument='<%#Eval("ProjectID") %>'
                                CommandName="myedit" Width="24" CausesValidation="false" ImageUrl="~/images/edit.png" />
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Delete" HeaderStyle-CssClass="grdheader">
                    <ItemStyle Width="15%" CssClass="griditemstlert1" BackColor="White" />
                    <ItemTemplate>
                        <div style="text-align: center">
                            <asp:ImageButton ID="Delete" runat="server" CommandArgument='<%#Eval("ProjectID") %>'
                                ImageUrl="~/images/Delete.png" CommandName="mydelete" OnClientClick="return confirm('are you really want to delete data?');"
                                CausesValidation="false" Width="24" />
                        </div>
                    </ItemTemplate>
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
</div>
<asp:HiddenField ID="hidpermission" runat="server" />
