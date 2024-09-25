<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CompletedJobs.ascx.cs"
    Inherits="controls_CompletedJobs" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<style type="text/css">
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
    #div1
    {
        width: 1037px;
    }
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
        width: 970px;
        height: 23px;
    }
    .headerpage
    {
        height: 23px;
    }
    .divspace
    {
        height: 20px;
    }
</style>
<div id="divtotbody" class="testwhleinsidenew">
    <%--<div align="right">
    </div>--%>
    <uc1:MessageControl ID="MessageControl" runat="server" />
    <div id="divtitl" class="totbodycatreg">
        <div class="headerpage" style="width: 100%">
            <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
                <asp:Label ID="Label1" runat="server" Text="Completed Jobs" CssClass="Head1 labelChange"></asp:Label></div>
        </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div style="float: left; width: 106%; padding-left: 10px" align="left">
                    <uc1:MessageControl ID="MessageControl1" runat="server" />
                </div>
                <div style="float: right; text-align: right; width: 100%; padding-top: 10px;">
                    <div style="float: left; width: 100%; margin:10px; padding-bottom: 5px; overflow: auto;">
                        <asp:Panel ID="Panel5" runat="server" DefaultButton="btnsrchjob">
                            <div id="searchjob" runat="server">
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label21" runat="server" Font-Bold="true" Text="Filter By" CssClass="LabelFontStyle"></asp:Label>&nbsp;&nbsp;
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="ddlSearchby" CssClass="DropDown labelChange texboxcls" runat="server">
                                                <asp:ListItem>Job</asp:ListItem>
                                                <asp:ListItem>Client</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtSearchby" CssClass="texboxcls" runat="server"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:Button ID="btnsrchjob" runat="server" CssClass="TbleBtns TbleBtnsPading" OnClick="btnsrchjob_Click"
                                                Text="Search" />
                                        </td>


                                    </tr>
                                </table>
                            </div>
                        </asp:Panel>
                    </div>

                </div>
                <div style="overflow: hidden; padding-bottom: 10px; width: 100%; float: left; padding-left: 1px;
                    padding-top: 5px;">
                    <asp:GridView ID="Griddealers" runat="server" BorderColor="#55A0FF" BorderStyle="Solid" DataKeyNames="JobId"
                        BorderWidth="1px" AutoGenerateColumns="False" Width="100%" OnRowCommand="Griddealers_RowCommand"
                        OnPageIndexChanging="Griddealers_PageIndexChanging" EmptyDataText="No records found!!!"
                        OnRowDataBound="Griddealers_RowDataBound" PageSize="25">
                        <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast"
                            PageButtonCount="20" Position="Bottom" />
                        <PagerStyle CssClass="pagination" HorizontalAlign="Right" VerticalAlign="Middle" />
                        <RowStyle Height="15px" />
                        <Columns>
                            <asp:TemplateField HeaderText="jobid" HeaderStyle-CssClass="grdheadermster" Visible="False">
                                <ItemTemplate>
                                    <div class="gridcolstyle">
                                        <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("JobId") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderStyle-CssClass="grdheader" HeaderText="Sr.No.">
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="overflow: hidden; width: 40px;" align="center">
                                        <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text='<%# bind("sino") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Job" HeaderStyle-CssClass="grdheader">
                                <ItemTemplate>
                                    <div class="gridpages" style="width: 200px">
                                        <%--<asp:LinkButton ID="lblfrname" runat="server" CssClass="gridpages" Width="168px" Text='<%# bind("mJobName") %>' CommandName="job"></asp:LinkButton>--%>
                                        <asp:Label ID="lbljob" runat="server" CssClass="gridpages" Width="190px" Text='<%# bind("mJobName") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstlert" />
                                <HeaderStyle CssClass="grdheadermster labelChange"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Client" HeaderStyle-CssClass="grdheader">
                                <ItemTemplate>
                                    <div class="gridpages" style="width: 170px">
                                        <asp:Label ID="lblfrname1" runat="server" CssClass="gridpages" Width="170px" Text='<%# bind("ClientName") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstlert" />
                                <HeaderStyle CssClass="grdheader labelChange"></HeaderStyle>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Start Date">
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="overflow: hidden; width: 90px;">
                                        <asp:Label ID="lblcdate" runat="server" CssClass="labelstyle" Text='<%# bind("CreationDate") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstle2" />
                                <ItemStyle Width="90px" />
                                <HeaderStyle CssClass="grdheader" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="End Date">
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="overflow: hidden; width: 90px;">
                                        <asp:Label ID="lbledate" runat="server" CssClass="labelstyle" Text='<%# bind("ActualJobEnDate") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstle2" />
                                <ItemStyle Width="90px" />
                                <HeaderStyle CssClass="grdheader" />
                            </asp:TemplateField>
                            <%--                    <asp:TemplateField HeaderText="Approver">
                        <ItemTemplate>
                            <div class="gridcolstyle" style="overflow: hidden; width: 100px;">
                                <asp:Label ID="lblstf" runat="server" CssClass="labelstyle" Text='<%# bind("StaffName") %>'></asp:Label>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="griditemstle2" />
                        <ItemStyle Width="90px" />
                        <HeaderStyle CssClass="grdheadermster" />
                    </asp:TemplateField>--%>
                            <asp:TemplateField HeaderText="Budget Hours">
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="overflow: hidden; width: 30px;">
                                        <asp:Label ID="lblBhours" runat="server" CssClass="labelstyle" Text='<%# bind("BudHours") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstle2" />
                                <ItemStyle Width="30px" />
                                <HeaderStyle CssClass="grdheader" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Budget Amt.">
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="overflow: hidden; width: 80px;">
                                        <asp:Label ID="lblBAmt" runat="server" CssClass="labelstyle" Text='<%# bind("BudAmt") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstle2" />
                                <ItemStyle Width="30px" />
                                <HeaderStyle CssClass="grdheader" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actual Hours">
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="overflow: hidden; width: 80px;">
                                        <asp:Label ID="lblAhours" runat="server" CssClass="labelstyle" Text='<%# bind("ActualHours") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstle2" />
                                <ItemStyle Width="50px" />
                                <HeaderStyle CssClass="grdheader" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actual Amt.">
                                <ItemTemplate>
                                    <div class="gridcolstyle" style="overflow: hidden; width: 80px;">
                                        <asp:Label ID="lblAmt" runat="server" CssClass="labelstyle" Text='<%# bind("ActualAmt") %>'></asp:Label>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="griditemstle2" />
                                <ItemStyle Width="50px" />
                                <HeaderStyle CssClass="grdheader" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Change to Ongoing Status">
                                <ItemTemplate>
                                <div class="gridcolstyle" style="overflow: hidden; width: 110px;">
                                    <asp:LinkButton ID="lnkchangeStatus" runat="server" OnClientClick="javascript : return confirm('Are you sure want to change the status?');"
                                        Text="Click here" CommandArgument='<%#Eval("JobId") %>' OnClick="lnkChangeStatus_Click"></asp:LinkButton>
                                        </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle CssClass="grdheader" />
                    </asp:GridView>
                   <right>
                    <div style="padding-top:25px;"  > 
                         <asp:Button ID="BtnPrevious" runat="server" CssClass="TbleBtns TbleBtnsPading"  
                                                Text="Previous" onclick="BtnPrevious_Click" />                    
                         <asp:Button ID="BtnNext" runat="server" CssClass="TbleBtns TbleBtnsPading"  
                                                Text="Next" onclick="BtnNext_Click" />                    
                    </div></right>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <div id="div1" class="seperotorrwr">
    </div>
    <div id="griddiv" class="totbodycatreg">
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
            SelectCommand="select row_number() over(order by j.mJobName asc)as sino,j.JobId,j.mJobName,jg.JobGroupName as jobgroup,dbo.SumTotal(j.JobId) as Total,j.Jobstatus,CONVERT(VARCHAR(10), j.CreationDate, 103) AS CreationDate,CM.ClientName from vw_Job_New as j left join dbo.JobGroup_Master as jg on j.JobGId=jg.JobGId LEFT OUTER JOIN Client_Master CM ON j.cltid=CM.CLTId where j.CompId='' order by j.mJobName asc">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
        </asp:SqlDataSource>
    </div>
</div>
