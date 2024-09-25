<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AddRecordsDep.ascx.cs" Inherits="controls_AddRecordsDep" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        var newDate = new Date();
        $("[id*=hdnDT]").val(newDate);
    });
</script>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<style type="text/css">
    .Head1 {
        font-size: 14px;
        font-family: Verdana,Arial,Helvetica,sans-serif;
        color: #3D80E8;
        font-weight: bold;
        overflow: hidden;
        border-bottom-color: White;
    }

    .divspace {
        height: 15px;
    }

    .headerpage {
        height: 23px;
    }

    .pagination {
        font-size: 80%;
    }

        .pagination a {
            text-decoration: none;
            border: solid 1.5px #55A0FF;
            color: #15B;
        }

    .headerstyle1_page {
        border-bottom: 1px solid #55A0FF;
        float: left;
        overflow: hidden;
        margin: 0 0 10px;
        width: 100%;
        height: 20px;
    }

    .txtbox {
        font-family: Verdana,Arial,Helvetica,sans-serif;
        font-size: 12px;
        font-style: normal;
        padding-left: 5px;
        color: #000000;
        -webkit-border-radius: 4px;
        -moz-border-radius: 4px;
        border-radius: 4px;
        border: 1px solid #000000;
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

    .Button {
        font-family: Verdana,Arial,Helvetica,sans-serif;
        font-size: 11px;
        font-weight: 600;
        height: 25px;
        color: #1464F4;
        -webkit-border-radius: 4px;
        -moz-border-radius: 4px;
        border-radius: 4px;
    }

    .modalBackground {
        background-color: Gray;
        filter: alpha(opacity=70);
        opacity: 0.7;
    }

    .error {
        color: #D8000C;
        background-color: #FFBABA;
        background-image: url('images/error.png');
    }

    .style1 {
        color: #474747;
        font-size: 12px;
        height: 40px;
        font-weight: bold;
    }

    .headerstyle1_master {
        width: 1258px;
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

<script type="text/javascript" language="javascript">
    function ValidateText(i) {
        if (i.value == 0) {
            i.value = null;
        }
        if (i.value.length > 0) {
            i.value = i.value.replace(/[^\d]+/g, '');
        }
        CountFrmTitle(i, 12);
    }
    function CountFrmTitle(field, max) {
        if (field.value.length > max) {
            field.value = field.value.substring(0, max);
            alert("You are exceding the maximum limit");

        }
        else {
            field.value = field.value.replace(/[?,\/#!$%\^\*;:{}=\_`~@"+]/g, "");
            var count = max - field.value.length;
        }
    }
</script>
<style type="text/css">
    .cssPageTitle
{
    font: bold 14px verdana, arial, "Trebuchet MS" , sans-serif;
    border-bottom: 2px solid #0b9322;  
    color: #0b9322;
}
.cssButton
{
    cursor: pointer; /*background-image: url(../Images/ButtonBG1.png);*/
    background-color: #d3d3d3;
    border: 0px;
    padding: 4px 15px 4px 15px;
    color: Black;
    border: 1px solid #c4c5c6;
    border-radius: 3px;
    font: bold 12px verdana, arial, "Trebuchet MS" , sans-serif;
    text-decoration: none;
    opacity: 0.8;

}
.cssButton:focus
{
    background-color: #69b506;
    border: 1px solid #3f6b03;
    color: White;
    opacity: 0.8;
}
.cssButton:hover
{
    background-color: #69b506;
    border: 1px solid #3f6b03;
    color: White;
    opacity: 0.8;
}
.cssPageTitle2
{
    font: bold 14px verdana, arial, "Trebuchet MS" , sans-serif;
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

    <div>
        <div>
            <table style="width: 100%" class="cssPageTitle">
                <tr>
                    <td class="cssPageTitle2">
                        <asp:Label ID="lblname" runat="server" Style="margin-left: 10px;" Text="Manage Department"></asp:Label>
                    </td>
                </tr>
            </table>
            <asp:HiddenField ID="hdnDT" runat="server" />
      <%--      <asp:Label ID="Label2" runat="server" CssClass="Head1 labelChange" Text="Manage Department"></asp:Label>--%>
        </div>
    </div>
    <div id="Div2" runat="server" class="masterdiv1a">
        <div style="float: center">
            <uc1:MessageControl ID="MessageControl1" runat="server" />
            <div class="serachJob" style="float: left">
                <div style="float: left; width: 100%; margin: 10px; padding-bottom: 5px; overflow: auto;" id="searchdesg" runat="server">
                    <asp:Label ID="Label22" runat="server" Text="Search Department" CssClass="LabelFontStyle labelChange" style="margin-left:10px;"></asp:Label>
                    <asp:TextBox ID="txtsearchdept" runat="server" CssClass="cssTextbox" Width="250px" Font-Names="Verdana" onkeyup="CountFrmTitle(this,70);"
                        Font-Size="8pt"></asp:TextBox>
                    <asp:Button ID="btndepsearch" runat="server" CssClass="cssButton"
                        Text="Search" OnClick="btndepsearch_Click" />
                    <asp:Button ID="btnadddept" runat="server" OnClick="btnadddept_Click1" Text="Add Department"
                        CssClass="cssButton" />
                </div>
            </div>

            <div class="divspace"></div>
            <div id="Div3" class="seperotorrwr">
                <div id="searchdept" runat="server">

                    <div class="serachJob" style="float: left">
                        &nbsp;&nbsp;
                        
                       
			
			
                        &nbsp;&nbsp;
                        
                    </div>
                </div>
            </div>

            <div style="float: right; text-align: right; width: 100%;">

                <div style="float: left; width: 68%; padding-left: 10px"></div>
                <div style="float: right; width: 30%; padding-top: 5px;">
                </div>
                <asp:Panel ID="Panel14" runat="server">
                </asp:Panel>
            </div>
            <div>


                <div class="tableNewadd" style="float: right; margin: 10px; padding-left: 10px;">
                    <asp:Panel ID="Panel13" runat="server">
                        <asp:GridView ID="GrdD" runat="server" AutoGenerateColumns="False" Width="100%"
                            DataKeyNames="Staffcode" AllowPaging="True" OnPageIndexChanging="GrdD_PageIndexChanging"
                            EmptyDataText="No records found!!!" PageSize="25" BackColor="White" CellPadding="3"
                            CssClass="norecordTble">
                            <PagerSettings FirstPageText="First" LastPageText="Last" PageButtonCount="10"
                                Position="Bottom" />
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <PagerStyle HorizontalAlign="Left"
                                VerticalAlign="Top" BackColor="White" ForeColor="#000066" />
                            <RowStyle Height="20px" Font-Names="Verdana" Font-Size="9pt" ForeColor="#000066" />
                            <Columns>
                                <asp:TemplateField HeaderText="Staffcode" HeaderStyle-CssClass="grdheader"
                                    Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblSid" runat="server" CssClass="labelstyle"
                                                Text='<%# bind("Staffcode") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Staff Name"
                                    HeaderStyle-CssClass="grdheader labelChange">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 300px;">
                                            <asp:Label ID="lblSTname" runat="server" CssClass="labelstyle"
                                                Text='<%# bind("StaffName") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                                </asp:TemplateField>
                            </Columns>
                            <SelectedRowStyle />
                            <HeaderStyle />
                        </asp:GridView>
                    </asp:Panel>

                </div>

                <div class="divfloatleftn divfloatleftnTble" style="float: left; margin: 10px; padding-left: 5px; width: 730px; padding-right: 15px;">

                    <asp:Panel ID="Panel15" runat="server">
                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" Width="100%"
                            DataSourceID="SqlDataSource2" DataKeyNames="DepId" AllowPaging="True"
                            EmptyDataText="No records found!!!" OnPageIndexChanging="GridView1_PageIndexChanging"
                            OnRowCommand="GridView1_RowCommand" PageSize="25" OnRowCancelingEdit="GridView1_RowCancelingEdit"
                            OnRowUpdating="GridView1_RowUpdating" OnRowEditing="GridView1_RowEditing"
                            OnRowDataBound="GridView1_RowDataBound" BackColor="White" CellPadding="3" OnSelectedIndexChanged="GridView1_SelectedIndexChanged"
                            CssClass="norecordTble" OnRowCreated="GridView1_RowCreated">
                            <PagerSettings FirstPageText="First" LastPageText="Last" PageButtonCount="10"
                                Position="Bottom" />
                            <FooterStyle BackColor="White" ForeColor="#000066" />
                            <PagerStyle HorizontalAlign="Left"
                                VerticalAlign="Middle" BackColor="White" ForeColor="#000066" />
                            <RowStyle Height="20px" Font-Names="Verdana" Font-Size="9pt" ForeColor="#000066" />
                            <Columns>
                                <asp:TemplateField HeaderText="jobid" HeaderStyle-CssClass="grdheader"
                                    Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblDid" runat="server" CssClass="labelstyle"
                                                Text='<%# bind("DepId") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Department Name"
                                    HeaderStyle-CssClass="grdheader">
                                    <EditItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;">
                                            <asp:TextBox ID="TextBox3" runat="server" Height="16px" CssClass="cssTextbox"  Text='<%# bind("DepartmentName") %>'
                                                Width="241px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>
                                        </div>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;">
                                            <asp:LinkButton ID="lblDept" runat="server" CommandName="view"
                                                CssClass="labelstyle" Text='<%# bind("DepartmentName") %>'></asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheader">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit.png"
                                                ToolTip="Edit" Height="19px" Width="18px" />
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Button ID="Button2" runat="server" CssClass="cssButton"
                                                CommandName="update" Text="Update" />
                                            &nbsp;<asp:Button ID="Button3" runat="server" CssClass="cssButton"
                                                CommandName="cancel" Text="Cancel" />
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheader"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("DepId") %>'
                                            ImageUrl="~/images/Delete.png" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                            ToolTip="Delete" CommandName="delete" />

                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheader" />
                                </asp:TemplateField>
                            </Columns>
                            <SelectedRowStyle />
                            <HeaderStyle />
                        </asp:GridView>
                    </asp:Panel>



                </div>
            </div>


            <div class="mastergrid">
            </div>

        </div>



        <div class="reapeatItem2">
        </div>


        <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server"></asp:Button><br />

        <cc1:ModalPopupExtender ID="ModalPopupExtender2" runat="server" BackgroundCssClass="modalBackground" CancelControlID="btnCancel2"
            BehaviorID="programmaticModalPopupOrginalBehavior" DropShadow="False" PopupControlID="panel10"
            RepositionMode="RepositionOnWindowScroll" TargetControlID="hideModalPopupViaClientOrginal2">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="panel10" runat="server" Width="450px" DefaultButton="BtnSubmit2" CssClass="RoundpanelNarr RoundpanelNarrExtra">
            <div>

                <h1 class="Ttlepopu labelChange">Add Department</h1>
                <div style="display: none;">

                    <asp:Label ID="Label33" runat="server" Font-Bold="True" Font-Names="Verdana"
                        Font-Size="8pt" ForeColor="White" Text="Add Department" CssClass="labelChange"></asp:Label>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <%--<asp:Button ID="BtnClose2" runat="server" BackColor="White" 
                                BorderColor="White" BorderStyle="None" Font-Bold="True" Font-Names="Verdana" 
                                Font-Size="8pt" ForeColor="White" Height="16px" text="X" Width="16px" onclick="BtnClose2_Click" 
                                 />--%>
                </div>
                <table class="addDesignatnation">
                    <tr>
                        <td class="style1">

                            <asp:Label ID="Label1" runat="server" Text="Department" CssClass="LabelFontStyle labelChange"></asp:Label>
                        </td>
                        <td style="width: 250px; padding-left: 25px;">
                            <asp:TextBox ID="Txt2" runat="server" CssClass="cssTextbox" Width="250px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="noteText">
                                Notes:  
                                <div id="msghead" runat="server" class="txtboxNewError">
                                    <span class="labelstyle">Fields marked with * are required</span>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" class="style2" colspan="2">
                            <asp:Button ID="BtnSubmit2" runat="server" CssClass="cssButton" Text="Save" Width="70px"
                                OnClick="BtnSubmit2_Click1" />
                            &nbsp;
                                    <asp:Button ID="btnCancel2" runat="server" CssClass="cssButton" Text="Cancel" Width="70px"
                                        OnClick="btnCancel2_Click1" />

                        </td>
                    </tr>

                </table>

            </div>
        </asp:Panel>


    </div>

    <div id="griddiv" class="totbodycatreg">
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource11" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"></asp:SqlDataSource>

    </div>

</div>

<asp:HiddenField ID="hidpermission" runat="server" />


