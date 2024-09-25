<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master"
    AutoEventWireup="true" CodeFile="superAdmincompanypagesright.aspx.cs"
    Inherits="Admin_superAdmincompanypagesright" %>

<%@ Register Src="../controls/MessageControl.ascx" TagName="MessageControl"
    TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .nodeLevel1
        {
            font: 17px Arial,Sans-Serif !important;
            color: red !important;
            margin-left: 5px;
        }
        .nodeLevel2
        {
            color: Blue !important;
            font: 15px Arial,Sans-Serif !important;
            margin-left: 10px;
        }
        .nodeLevel3
        {
            color: Green !important;
            font: 13px Arial,Sans-Serif !important;
            margin-left: 10px;
        }
        .ulActions
        {
            float: left;
            list-style: none;
            margin-left: 10px;
            margin-bottom: 10px;
        }
        .ulActions li
        {
            float: left;
            padding-right: 10px;
            text-decoration: underline;
            color: Blue;
        }
        .ulActions li:hover
        {
            cursor: pointer;
            text-decoration: none;
        }
        .clfor
        {
            padding: 5px 50px 0px 50px;
        }
    </style>
    <script type="text/javascript" src="../jquery/jquery-2.2.4.min.js"></script>
    <script type="text/javascript">
        //$(document).ready(function () {
        //    $("[id*=drplevel]").on('click', function () {
        //        var l =$("[id*=drplevel]").val();
        //        $("[id*=hdnLevel]").val(l);
        //    });
        //});

        function ulActionsClick(i) {

            var admin = 0;
            var staff = 0;

            var treeViewadmin = $("[id*=Treegroupadmin]");
            var treeNodesadmin = treeViewadmin.find('div[id$=Nodes]');
            var treeImagesadmin = treeViewadmin.find('img').not('img[alt=\'\']');

            var treeViewstaff = $("[id*=Treegroupstaff]");
            var treeNodesstaff = treeViewstaff.find('div[id$=Nodes]');
            var treeImagesstaff = treeViewstaff.find('img').not('img[alt=\'\']');

            if (i.outerText == 'Expand All') {
                admin = 1;
                staff = 1;
            }
            else if (i.outerText == 'Collapse All') {
                admin = 0;
                staff = 0;
            }
            else if (i.outerText == 'Expand Admin') {
                admin = 1;
                staff = 2;
            }
            else if (i.outerText == 'Expand Staff') {
                admin = 2;
                staff = 1;
            }
            else if (i.outerText == 'Collapse Admin') {
                admin = 0;
                staff = 2;
            }
            else if (i.outerText == 'Collapse Staff') {
                admin = 2;
                staff = 0;
            }

            if (admin == 1) {
                treeNodesadmin.css({ 'display': 'block' });
                treeImagesadmin.attr('src', '../TreeLineImages/minus.gif')
            }
            else if (admin == 0) {
                treeNodesadmin.css({ 'display': 'none' });
                treeImagesadmin.attr('src', '../TreeLineImages/plus.gif')
            }
            if (staff == 1) {
                treeNodesstaff.css({ 'display': 'block' });
                treeImagesstaff.attr('src', '../TreeLineImages/minus.gif')
            }
            else if (staff == 0) {
                treeNodesstaff.css({ 'display': 'none' });
                treeImagesstaff.attr('src', '../TreeLineImages/plus.gif')
            }
        }

        function onpageload() {
            //var l = $("[id*=hdnLevel]").val();
            //$("[id*=drplevel]").val(l);
            $("[id*=Treegroupadmin] input[type=checkbox]").bind("click", function () {
                var table = $(this).closest("table");
                if (table.next().length > 0 && table.next()[0].tagName == "DIV") {
                    //Is Parent CheckBox
                    var childDiv = table.next();
                    var isChecked = $(this).is(":checked");
                    $("input[type=checkbox]", childDiv).each(function () {
                        if (isChecked) {
                            $(this).attr("checked", "checked");
                        } else {
                            $(this).removeAttr("checked");
                        }
                    });
                } else {
                    //Is Child CheckBox
                    var parentDIV = $(this).closest("DIV");
                    if (0 < $("input[type=checkbox]:checked", parentDIV).length) {
                        $("input[type=checkbox]", parentDIV.prev()).attr("checked", "checked");
                    } else {
                        $("input[type=checkbox]", parentDIV.prev()).removeAttr("checked");
                    }
                }
            });
            $("[id*=Treegroupstaff] input[type=checkbox]").bind("click", function () {
                var table = $(this).closest("table");
                if (table.next().length > 0 && table.next()[0].tagName == "DIV") {
                    //Is Parent CheckBox
                    var childDiv = table.next();
                    var isChecked = $(this).is(":checked");
                    $("input[type=checkbox]", childDiv).each(function () {
                        if (isChecked) {
                            $(this).attr("checked", "checked");
                        } else {
                            $(this).removeAttr("checked");
                        }
                    });
                } else {
                    //Is Child CheckBox
                    var parentDIV = $(this).closest("DIV");
                    if (0 < $("input[type=checkbox]:checked", parentDIV).length) {
                        $("input[type=checkbox]", parentDIV.prev()).attr("checked", "checked");
                    } else {
                        $("input[type=checkbox]", parentDIV.prev()).removeAttr("checked");
                    }
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1"
    runat="Server">
    <div id="divtotbody" class="totbodycatreg1" style="height: auto;
        padding-bottom: 10px">
        <asp:HiddenField ID="hdnLevel" runat="server" />
        <div align="right">
        </div>
        <div id="divtitl" class="totbodycatreg">
            <div class="headerstyle_admin">
                <div class="headerstyle1_admin">
                    <asp:Label ID="Label1" runat="server" Text="Manage Permission"
                        CssClass="Head1"></asp:Label>
                </div>
            </div>
        </div>
        <br />
        <uc1:MessageControl ID="MessageControl2" runat="server" />
        <asp:ValidationSummary ID="ValidationSummary1" runat="server"
            ValidationGroup="group1" ShowMessageBox="true" ShowSummary="false" />
        <br />
        <br />
        <table>
            <tr>
                <td>
                    Select company Name:
                </td>
                <td>
                    <asp:DropDownList ID="ddlcompanyname" runat="server" CssClass="dataliststyle"
                        ValidationGroup="group1" AutoPostBack="True" OnSelectedIndexChanged="ddlcompanyname_SelectedIndexChanged">
                    </asp:DropDownList>
                </td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                        ErrorMessage="Please select Company!!!" Display="None" ValidationGroup="group1"
                        InitialValue="0" ControlToValidate="ddlcompanyname"></asp:RequiredFieldValidator>
                    <asp:Button ID="btnsubmit" runat="server" Text="Submit" OnClick="btnsubmit_Click"
                        ValidationGroup="group1" />
                        <asp:Button ID="btnrestore" runat="server" Text="Restore default" 
                        onclick="btnrestore_Click" />
<%--                        Department : <asp:CheckBox ID="chkdept" runat="server" />
                        Task : <asp:CheckBox ID="chktask" runat="server" />--%>
                     <asp:DropDownList id="drplevel"  runat="server" class="DropDown txtbox"  AutoPostBack="True" style="width: 150px; height: 25px;" OnSelectedIndexChanged="drplevel_SelectedIndexChanged"  >
                         <asp:ListItem Value="0" Text="Select"></asp:ListItem>
                         <asp:ListItem Value="2" Text="2 Level"></asp:ListItem>
                         <asp:ListItem Value="3" Text="3 Level"></asp:ListItem>
                         <asp:ListItem Value="4" Text="4 Level"></asp:ListItem>
                     </asp:DropDownList>  
                </td>
            </tr>
        </table>
    </div>
    <div id="div2" runat="server">
        <table width="100%">
            <tr>
                <td colspan="2">
                    <span class="ulActions">
                        Actions :</span>
                    <ul class="ulActions">
                        <li onclick='ulActionsClick(this)'>Expand All</li>
                        <li onclick='ulActionsClick(this)'>Collapse All</li>
                        <li onclick='ulActionsClick(this)'>Expand Admin</li>
                        <li onclick='ulActionsClick(this)'>Collapse Admin</li>
                        <li onclick='ulActionsClick(this)'>Expand Staff</li>
                        <li onclick='ulActionsClick(this)'>Collapse Staff</li>
                    </ul>
                </td>
            </tr>
            <tr>
                <td width="50%" class="clfor" valign="top" align="left">
                    <h3>
                        Admin Pages:</h3>
                    <hr />
                    <asp:TreeView ID="Treegroupadmin" runat="server" AutoGenerateDataBindings="False"
                        ImageSet="XPFileExplorer" ShowCheckBoxes="All" ExpandDepth="0"
                        ShowLines="True" NodeIndent="15" LineImagesFolder="~/TreeLineImages">
                        <LevelStyles>
                            <asp:TreeNodeStyle CssClass="nodeLevel1" />
                            <asp:TreeNodeStyle CssClass="nodeLevel2" />
                            <asp:TreeNodeStyle CssClass="nodeLevel3" />
                        </LevelStyles>
                        <HoverNodeStyle Font-Underline="True" ForeColor="#6666AA" />
                        <NodeStyle Font-Names="Tahoma" Font-Size="8pt" ForeColor="Black"
                            HorizontalPadding="2px" NodeSpacing="0px" VerticalPadding="2px">
                        </NodeStyle>
                        <ParentNodeStyle Font-Bold="False" />
                        <SelectedNodeStyle Font-Underline="False" HorizontalPadding="0px"
                            VerticalPadding="0px" BackColor="#B5B5B5" />
                    </asp:TreeView>
                </td>
                <td width="50%" class="clfor" valign="top" align="left">
                    <h3>
                        Staff Pages :</h3>
                    <hr />
                    <asp:TreeView ID="Treegroupstaff" runat="server" AutoGenerateDataBindings="False"
                        ImageSet="XPFileExplorer" ShowCheckBoxes="All" ExpandDepth="0"
                        ShowLines="True" NodeIndent="15" LineImagesFolder="~/TreeLineImages">
                        <LevelStyles>
                            <asp:TreeNodeStyle CssClass="nodeLevel1" />
                            <asp:TreeNodeStyle CssClass="nodeLevel2" />
                            <asp:TreeNodeStyle CssClass="nodeLevel3" />
                        </LevelStyles>
                        <HoverNodeStyle Font-Underline="True" ForeColor="#6666AA" />
                        <NodeStyle Font-Names="Tahoma" Font-Size="8pt" ForeColor="Black"
                            HorizontalPadding="2px" NodeSpacing="0px" VerticalPadding="2px">
                        </NodeStyle>
                        <ParentNodeStyle Font-Bold="False" />
                        <SelectedNodeStyle Font-Underline="False" HorizontalPadding="0px"
                            VerticalPadding="0px" BackColor="#B5B5B5" />
                    </asp:TreeView>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
