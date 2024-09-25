    <%@ Control Language="C#" AutoEventWireup="true" CodeFile="cmp_ManageJob.ascx.cs"
    Inherits="controls_cmp_ManageJob" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        var newDate = new Date();
        $("[id*=hdnDT]").val(newDate);
    });
    </script>
<style type="text/css">
    .Head1
    {
        font-size: 14px;
        font-family: Verdana,Arial,Helvetica,sans-serif;
        color: #3D80E8;
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
        border-bottom: 1px solid #55A0FF;
        float: left;
        overflow: hidden;
        width: 1000px;
        height: 23px;
    }
    .headerpage
    {
        height: 23px;
    }
    .pagination
    {
        font-size: 80%;
    }
    
    .pagination a
    {
        text-decoration: none;
        border: solid 1.5px #55A0FF;
        color: #15B;
    }
    
    .pagination a, .pagination span
    {
        display: block;
        float: left;
        padding: 0.1em 0.5em;
        margin-right: 1px;
        margin-bottom: 2px;
    }
    
    .pagination .current
    {
        background: #26B;
        color: #fff;
        border: solid 1px #AAE;
    }
    
    .pagination .current.prev, .pagination .current.next
    {
        color: #999;
        border-color: #999;
        background: #fff;
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
    }
</style>
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        debugger
        $("[id*=lbldiff]").each(function () {
            var diff=$(this).html();
            if(diff!='') {
                if(parseFloat(diff)<0) {
                    $(this).closest('tr').children('td,th').css('background-color','red');
                    $(this).closest('tr').children('td,th').css('color','#F0F0F0');
                    $(this).closest('tr').children('td,th').css('font-weight','bold');
                    $(this).closest('tr').find("[id*=lblfrname]").css('font-weight','bold');  
                    $(this).closest('tr').find("[id*=lblfrname]").css('color','#F0F0F0');
                }
            }
        });
    });
</script>
<div id="divtotbody" class="testwhleinside">
    <%--<div align="right">
    </div>--%>
    <div id="divtitl" class="totbodycatreg">
        <div class="headerpage">
            <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
                <asp:Label ID="Label1" runat="server" Text="Manage Job" CssClass="Head1 labelChange"></asp:Label>
             <asp:HiddenField ID="hdnDT" runat="server" />
            </div>
        </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
               <Triggers>
                    <asp:PostBackTrigger ControlID="BtnExport" />
                </Triggers>
            <ContentTemplate>
                <div style="float: left; width: 97%; padding-left: 10px" align="left">
                    <uc1:MessageControl ID="MessageControl1" runat="server" />
                </div>
                <div style="float: right; text-align: right; width: 100%; padding: 10px 0;">
                    <div style="float: left;">
                        <asp:Panel ID="Panel5" runat="server" DefaultButton="btnsrchjob">
                            <div id="searchjob" runat="server">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label21" runat="server" Text="Filter By" CssClass="LabelFontStyle"></asp:Label>&nbsp;&nbsp;
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlSearchby" CssClass="DropDown labelChange" runat="server">
                                                <asp:ListItem Value="Job">Job</asp:ListItem>
                                                <asp:ListItem Value="Client">Client</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtSearchby" CssClass="txtbox" runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:Button ID="btnsrchjob" runat="server" CssClass="TbleBtns TbleBtnsPading" OnClick="btnsrchjob_Click"
                                                Text="Search" />
                                        </td>
                                        <td>
                                            <asp:Button ID="btnjob" runat="server" Text="Completed Job" CssClass="TbleBtns TbleBtnsPading labelChange"
                                                OnClick="Btnjob_Click" />
                                        </td>
                                        <td>
                                            <asp:Button ID="btnadd" runat="server" CssClass="TbleBtns TbleBtnsPading labelChange" OnClick="lnknewclient_Click"
                                                Text="Allocate Job" />
                                        </td>
                                        <td>
                                        <asp:Button ID="BtnExport" runat="server" CssClass="TbleBtns TbleBtnsPading" Text="Export to Excel"
                                            OnClick="BtnExport_Click" />                                        
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </asp:Panel>
                    </div>
                    <%--<asp:ImageButton ID="ImageButton1" runat="server" 
                    ImageUrl="~/images/addnew_1.jpg" OnClick="lnknewclient_Click" Width="69px" />--%>
                    <%--<asp:LinkButton ID="lnkreset" runat="server" CssClass="lnkstle" OnClick="lnkreset_Click">Reset Job</asp:LinkButton> --%>
                </div>
                <div style="overflow: hidden; padding-bottom: 10px; width: 100%; float: left;">
                    <asp:GridView ID="Griddealers" runat="server" class="norecordTble" AutoGenerateColumns="False"
                        Width="100%" DataSourceID="SqlDataSource1" DataKeyNames="JobId" OnRowCommand="Griddealers_RowCommand"
                        AllowPaging="True" OnPageIndexChanging="Griddealers_PageIndexChanging" EmptyDataText="No records found!!!"
                        OnRowDataBound="Griddealers_RowDataBound" PageSize="25">
                        <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast"
                            PageButtonCount="20" Position="Bottom" />
                        <PagerStyle CssClass="pagination" HorizontalAlign="Right" VerticalAlign="Middle" />
                        <RowStyle Height="15px" />
                        <Columns>
                            <%--<asp:TemplateField HeaderText="jobid" HeaderStyle-CssClass="grdheader" Visible="False">
                                <ItemTemplate>
                                    <div class="gridcolstyle">
                                        
                                    </div>
                                </ItemTemplate>
                                <HeaderStyle CssClass="grdheader"></HeaderStyle>
                            </asp:TemplateField>--%>
                            <asp:TemplateField HeaderStyle-CssClass="grdheader" HeaderText="Sr No.">
                                <ItemTemplate>
                                    <div class="gridcolstyle" align="center">
                                        <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text='<%# bind("sino") %>'></asp:Label>
                                        <asp:Label ID="lblfid" runat="server" Visible="false" CssClass="labelstyle" Text='<%# bind("JobId") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <HeaderStyle CssClass="grdheader"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Job" HeaderStyle-CssClass="grdheader">
                                <ItemTemplate>
                                    <div class="gridpages" style="width: 170px">
                                        <asp:LinkButton ID="lblfrname" runat="server" CssClass="gridpages" Width="168px"
                                            Text='<%# bind("mJobName") %>' CommandName="job"></asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstlert" />
                                <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Client" HeaderStyle-CssClass="grdheadermster">
                                <ItemTemplate>
                                    <div class="gridpages" style="width: 170px">
                                        <asp:Label ID="lblfrname1" runat="server" CssClass="gridpages" Width="168px" Text='<%# bind("ClientName") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstlert" />
                                <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Budgeted Time">
                                <ItemTemplate>
                                    <div class="gridcolstyle" align="right">
                                        <asp:Label ID="Label6BudgetedTime" runat="server" CssClass="labelstyle" Text='<%# bind("BudHours") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstle4" />
                                <HeaderStyle CssClass="grdheader"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Budgeted Amount">
                                <ItemTemplate>
                                    <div class="gridcolstyle" align="right">
                                        <asp:Label ID="Label6BudgetedAmount" runat="server" CssClass="labelstyle" Text='<%# bind("BudAmt") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstle4" />
                                <HeaderStyle CssClass="grdheader"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Time Spend">
                                <ItemTemplate>
                                    <div class="gridcolstyle" align="right">
                                        <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text='<%# bind("Total") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstle4" />
                                <HeaderStyle CssClass="grdheader"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Amount Spend">
                                <ItemTemplate>
                                    <div class="gridcolstyle" align="right">
                                        <asp:Label ID="Label6AmountSpend" runat="server" CssClass="labelstyle" Text="0"></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstle4" />
                                <HeaderStyle CssClass="grdheader"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Start Date" HeaderStyle-CssClass="grdheader">
                                <ItemTemplate>
                                    <div class="gridcolstyle">
                                        <asp:Label ID="lblStartDate" runat="server" CssClass="labelstyle" Text='<%# bind("CreationDate") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstle2" />
                                <HeaderStyle CssClass="grdheader" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="End Date" HeaderStyle-CssClass="grdheader">
                                <ItemTemplate>
                                    <div class="gridcolstyle">
                                        <asp:Label ID="lblEndDate" runat="server" CssClass="labelstyle" Text='<%# bind("EndDate") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstle2" Width="70px" />
                                <HeaderStyle CssClass="grdheader" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Days Left" HeaderStyle-CssClass="grdheader">
                                <ItemTemplate>
                                    <div class="gridcolstyle">
                                        <asp:Label ID="lbldiff" runat="server" CssClass="labelstyle" Text='<%# bind("Diff") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstle2" />
                                <HeaderStyle CssClass="grdheader" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheader">
                                <ItemTemplate>
                                    <div style="text-align: center">
                                        <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit.png"
                                            ToolTip="Edit" /></div>
                                </ItemTemplate>
                                <HeaderStyle CssClass="grdheader" HorizontalAlign="Center"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Delete" HeaderStyle-CssClass="grdheader">
                                <ItemTemplate>
                                    <div style="overflow: hidden; width: 100%" align="center">
                                        <asp:ImageButton ID="btndelete" runat="server" ImageUrl="~/images/Delete.png" CommandArgument='<%# bind("JobId") %>'
                                            CommandName="del" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                            ToolTip="Delete" /></div>
                                </ItemTemplate>
                                <ItemStyle Width="60px" />
                                <HeaderStyle HorizontalAlign="Center" CssClass="grdheadermster" />
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle CssClass="grdheader" />
                    </asp:GridView>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div class="noteText">
        Notes:
        <div runat="server" class="txtboxNewError">
            <span class="labelstyle">Fields marked with * are required</span></div>
    </div>
    <div class="reapeatItem4">
       
    </div>
    <div id="div1" class="seperotorrwr">
    </div>
    <div id="griddiv" class="totbodycatreg">
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
        </asp:SqlDataSource>
    </div>
</div>
