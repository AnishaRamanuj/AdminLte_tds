<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="AllJobs_FortNight_Report.aspx.cs" Inherits="Admin_AllJobs_FortNight_Report" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script type="text/javascript">
function PrintContent(obj)
{
var DocumentContainer = document.getElementById(obj);
var WindowObject = window.open('','PrintWindow','width=920,height=650,top=550,left=50,toolbars=no,scrollbars=yes,status=no,resizable=yes');

WindowObject.document.writeln(DocumentContainer.innerHTML);
WindowObject.document.close();
WindowObject.focus();
WindowObject.print();
WindowObject.close();
return false;
}
</script>

    <div id="div94"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;height:auto;padding-bottom:30px;padding-left:5px;width:890px">
<div style="width:100%; float:left;padding-left:5px">
 <div style="padding-bottom: 10px;padding-right:5px" align="right">
    <asp:Button ID="Button3" runat="server" Text="Print" OnClientClick="return PrintContent('Div90');" /></div>
      <div id="Div90"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
<div align="center" style="padding-bottom: 10px">
                        <asp:Label ID="Label1" runat="server" CssClass="Head1" Text="Company Name"></asp:Label>
                    </div>
                    <div style="display:none">
<div align="center">
                        <asp:Label ID="lblprofession" runat="server" CssClass="linkstyle" 
                            Text="Manager"></asp:Label>
                    </div>
<div align="center">
                        <asp:Label ID="lbladdress" runat="server" CssClass="linkstyle" Text="Address"></asp:Label>
                    </div>
<div align="center">
                        <asp:Label ID="lblcontno" runat="server" CssClass="linkstyle" Text="ContactNo"></asp:Label>
                        ,
                        <asp:Label ID="lblemail" runat="server" CssClass="linkstyle" Text="Email"></asp:Label>
                    </div>
<div align="center">
                        <asp:Label ID="lblwebsite" runat="server" CssClass="linkstyle" Text="website"></asp:Label>
                    </div></div>
<div ID="Div11" class="repcomp" style="border-top: thin double rgb(0, 0, 0); margin-top:10px; width:100%; padding-top:5px;">
                            <div id="Div12" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                        <asp:Label ID="Label5" runat="server" CssClass="labelstyle" Text="Report Name"></asp:Label>
                    </div>
                    <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                        :</div>
                    <div id="Div13"style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;"
                        <asp:Label ID="Label51" runat="server" CssClass="labelstyle" Text="All Clients -> All Jobs FortNight"></asp:Label>
                    </div>
                        </div>


<div style="width: 100%;float:left; border-top-style: dotted; border-bottom-style: dotted; border-top-width: thin; border-bottom-width: thin; border-top-color: #000000; border-bottom-color: #000000; padding-top: 10px; padding-bottom: 10px;">
                        <div style="width: 35%;float:left; font-weight: bold;">
                            ClientName</div>
                        <div style="width: 30%;float:left ;font-weight: bold; text-align:center;">
                            <asp:Label ID="lblfort_1" runat="server" Text="Label"></asp:Label>
                        </div>
                        <div style="width: 30%;float:left;font-weight: bold; text-align:center;">
                            <asp:Label ID="lblfort_2" runat="server" Text="Label"></asp:Label>
                        </div>                        
                    </div>
<div style="width:100%; float:left;">
    <asp:DataList ID="DataClientList" runat="server" Width="100%">
        <ItemTemplate>
           <div  style="width:100%; float:left; border-bottom-style: dotted; border-bottom-width: 1px; border-bottom-color: #000000; padding-bottom: 10px; padding-top: 10px;">
           <div style="width:35%; float:left"> 
               <asp:Label ID="Label2" runat="server" Text='<%# bind("ClientName") %>' ></asp:Label>
                <asp:Label ID="lblcltid" runat="server" Text='<%# bind("CLTId") %>' 
                   Visible="False" ></asp:Label>
                    <asp:Label ID="lblcmpid" runat="server" Text='<%# bind("CompId") %>' 
                   Visible="False" ></asp:Label>
           </div>
           <div style="width:30%; float:left">
           <asp:GridView ID="GridWeek1" runat="server"  Width="100%" 
        AutoGenerateColumns="False" Font-Size="Smaller" ShowFooter="True" 
                   GridLines="Horizontal" DataSourceID="SqlWeek1Src">
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                <div style="width:100%;   padding-top:13px;">
                    <%# GetW1Hrs(decimal.Parse(Eval("TotalTime").ToString())).ToString("N2")%>
                    </div>
                </ItemTemplate>
                 <ItemStyle Width="30px"   HorizontalAlign="Right"/>
                 <FooterTemplate>
                 <%# RetW1HrsTotal().ToString("N2")%>
                </FooterTemplate>
                <FooterStyle   HorizontalAlign="Right" />
                <HeaderTemplate>Hours</HeaderTemplate>
                 <HeaderStyle Font-Size="Smaller" />
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                <div style="width:100%;   padding-top:13px;">
                     <%# GetW1Charges(decimal.Parse(Eval("Charges").ToString())).ToString("N2")%>
                     </div>
                </ItemTemplate>
                <ItemStyle Width="30px"   HorizontalAlign="Right"/>
                <FooterTemplate>
                 <%# RetW1ChargesTotal().ToString("N2")%>
                </FooterTemplate>
                <FooterStyle   HorizontalAlign="Right" />
                <HeaderTemplate>Charges</HeaderTemplate>
                  <HeaderStyle Font-Size="Smaller" />
            </asp:TemplateField>            
            <asp:TemplateField>
                <ItemTemplate>
                <div style="width:100%;   padding-top:13px;">
                    <%# GetW1Ope(decimal.Parse(Eval("OpeAmt").ToString())).ToString("N2")%>
                    </div>
                </ItemTemplate>
                 <ItemStyle Width="30px"   HorizontalAlign="Right"/>
                 <FooterTemplate>
                 <%# RetW1OpeTotal().ToString("N2")%>
                </FooterTemplate>
                <FooterStyle   HorizontalAlign="Right" />
                 <HeaderTemplate>OPEAmt</HeaderTemplate>
                 <HeaderStyle Font-Size="Smaller" />
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
           <asp:SqlDataSource ID="SqlWeek1Src" runat="server" 
                   ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
                   SelectCommand=" select sum(TotalTime)as TotalTime, sum(Charges)as Charges, sum(OpeAmt)as OpeAmt from(
select  t.ClTId,t.StaffCode,isnull(sum(convert(float,t.TotalTime)),0) as TotalTime,
(select HourlyCharges from dbo.Staff_Master where StaffCode=t.StaffCode)*isnull(sum(convert(float,t.TotalTime)),0)as Charges,
isnull(sum(t.OpeAmt),0) as OpeAmt from dbo.Job_Master as j left join dbo.TimeSheet_Table as t on t.JobId=j.JobId  and j.CompId=@CompId  where  j.ClTId=@ClTId
and  t.Date&gt;=@Date1 and t.Date&lt;=@Date2 group by t.StaffCode,t.ClTId)as tot group by  tot.ClTId">
               <SelectParameters>
                   <asp:ControlParameter ControlID="lblcltid" Name="ClTId" PropertyName="Text" />
                   <asp:ControlParameter ControlID="lblcmpid" Name="CompId" PropertyName="Text" />
                   <asp:SessionParameter DefaultValue="" Name="Date1" SessionField="frt_1" />
                   <asp:SessionParameter DefaultValue="" Name="Date2" SessionField="frt_2" />
               </SelectParameters>
               </asp:SqlDataSource>
           </div>
           <div style="width:30%; float:left"> 
           <asp:GridView ID="GridWeek2" runat="server"  Width="100%" 
        AutoGenerateColumns="False" Font-Size="Smaller" ShowFooter="True" 
                   GridLines="Horizontal" DataSourceID="SqlWeek2Src">
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                <div style="width:100%; padding-top:13px; ">
                    <%# GetW2Hrs(decimal.Parse(Eval("TotalTime").ToString())).ToString("N2")%>
                </div>   
                </ItemTemplate>
                 <ItemStyle Width="30px"  HorizontalAlign="Right"/>
                 <FooterTemplate>
                 <%# RetW2HrsTotal().ToString("N2")%>
                </FooterTemplate>
                  <FooterStyle   HorizontalAlign="Right" />
                <HeaderTemplate>Hours</HeaderTemplate>
                 <HeaderStyle Font-Size="Smaller" />
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                <div style="width:100%;  padding-top:13px;">
                     <%# GetW2Charges(decimal.Parse(Eval("Charges").ToString())).ToString("N2")%>
                     </div>
                </ItemTemplate>
                <ItemStyle Width="30px"   HorizontalAlign="Right"/>
                <FooterTemplate>              
                 <%# RetW2ChargesTotal().ToString("N2")%>
                </FooterTemplate>
                  <FooterStyle   HorizontalAlign="Right" />
                 <HeaderTemplate>Charges</HeaderTemplate>
                  <HeaderStyle Font-Size="Smaller" />
            </asp:TemplateField>            
            <asp:TemplateField>
                <ItemTemplate>
                <div style="width:100%;  padding-top:13px;">
                    <%# GetW2Ope(decimal.Parse(Eval("OpeAmt").ToString())).ToString("N2")%>
                    </div>
                </ItemTemplate>
                 <ItemStyle Width="30px"   HorizontalAlign="Right"/>
                 <FooterTemplate>                 
                 <%# RetW2OpeTotal().ToString("N2")%>
                </FooterTemplate>
                <FooterStyle   HorizontalAlign="Right" />
                 <HeaderTemplate>OPEAmt</HeaderTemplate>
                 <HeaderStyle Font-Size="Smaller" />
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
           <asp:SqlDataSource ID="SqlWeek2Src" runat="server"
            ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
            SelectCommand=" select sum(TotalTime)as TotalTime, sum(Charges)as Charges, sum(OpeAmt)as OpeAmt from(
select  t.ClTId,t.StaffCode,isnull(sum(convert(float,t.TotalTime)),0) as TotalTime,
(select HourlyCharges from dbo.Staff_Master where StaffCode=t.StaffCode)*isnull(sum(convert(float,t.TotalTime)),0)as Charges,
isnull(sum(t.OpeAmt),0) as OpeAmt from dbo.Job_Master as j left join dbo.TimeSheet_Table as t on t.JobId=j.JobId  and j.CompId=@CompId where  j.ClTId=@ClTId
and  t.Date&gt;=@Date1 and t.Date&lt;=@Date2 group by t.StaffCode,t.ClTId)as tot group by  tot.ClTId">
               <SelectParameters>
                   <asp:ControlParameter ControlID="lblcltid" Name="ClTId" PropertyName="Text" />
                   <asp:ControlParameter ControlID="lblcmpid" Name="CompId" PropertyName="Text" />
                   <asp:SessionParameter DefaultValue="" Name="Date1" SessionField="frt_3" />
                   <asp:SessionParameter DefaultValue="" Name="Date2" SessionField="frt_4" />
               </SelectParameters></asp:SqlDataSource>
           </div>
           </div>
        </ItemTemplate>
    </asp:DataList>
 </div>
 <div style="float: left; width: 100%; border-top-style: double; border-bottom-style: double;
                border-top-width: thin; border-bottom-width: thin; border-top-color: #000000;
                border-bottom-color: #000000; margin-top: 10px; padding-top: 5px; padding-bottom: 5px">
                <div style="width: 100%; float: left;">
                    <div style="width: 65%; float: left;">
                        Printed by :
                        <asp:Label ID="lblprintedby" runat="server" Text="superadmin"></asp:Label>
                    </div>
                    <div style="width: 10%; float: right;">
                        page
                        <asp:Label ID="lblpageindex" runat="server" Text="1"></asp:Label>
                        of
                        <asp:Label ID="lbltotpages" runat="server" Text="1"></asp:Label>
                    </div>
                </div>
                <div style="width: 100%; float: left;">
                    <div style="width: 65%; float: left;">
                        Printed on :
                        <asp:Label ID="lbldatenow" runat="server" Text="Label"></asp:Label>
                    </div>
                    <div style="width: 10%; float: right;">
                    </div>
                </div>
            </div>
 </div>
 
    </div>
</div>
</asp:Content>

