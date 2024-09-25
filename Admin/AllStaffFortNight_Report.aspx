<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="AllStaffFortNight_Report.aspx.cs" Inherits="Admin_AllStaffFortNight_Report" %>

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
     <div style="padding-bottom: 10px" align="right">
    <asp:Button ID="Button3" runat="server" Text="Print" OnClientClick="return PrintContent('Div90');" /></div>
      <div id="Div90"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
     <div style="padding-bottom: 10px" align="center">
          
            <asp:Label ID="Label63" runat="server" Text="Company Name" CssClass="Head1"></asp:Label></div>
             <div style="border-top-style: solid ; border-top-width: thin; border-top-color: #000000;height:130px; padding-top: 1px;margin-top: 10px;padding-left:0px;">
              <div style="border-top-style: solid; border-top-width: thin; border-top-color: #000000;height:130px; padding-top: 2px;padding-left:5px;">
            <div style="width:100%;height: auto;margin-top: 5px;">
           <div id="Div79" class="repcomp">
    <div id="Div80" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
        <asp:Label ID="Label115" runat="server" CssClass="labelstyle" Text="Report Name"></asp:Label>
        </div> <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">:</div>
    <div id="Div81" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
    <%--<div id="Div7">
        <asp:Label ID="Label3" runat="server" CssClass="labelstyle" Text="Single job"></asp:Label>
        </div>--%>
        
        <asp:Label ID="Label116" runat="server" CssClass="labelstyle" Text="Single Job - All Staffs Fortnight"></asp:Label>
        </div>
        
    </div>
    </div>
    <div  style="width:100%; float:left;padding-bottom:10px;padding-top: 10px;">
<div style="width:40%; float:left; text-align:center; padding-bottom:5px; padding-top:5px; border-bottom:1px solid #000; border-left:1px solid #000; border-top:1px solid #000;  font-size:smaller; font-weight:bold; "><asp:Label ID="lblstaff" runat="server" Text="Staff Name" ></asp:Label></div>
<div style="width:18%; float:left; text-align:center;padding-bottom:5px; padding-top:5px; border-bottom:1px solid #000; border-top:1px solid #000;   font-size:smaller; font-weight:bold; "><asp:Label ID="lblWeek1" runat="server"  ></asp:Label></div>
<div style="width:16%; float:left; text-align:center;padding-bottom:5px; padding-top:5px; border-bottom:1px solid #000; border-top:1px solid #000;   font-size:smaller; font-weight:bold; "><asp:Label ID="lblWeek2" runat="server"  ></asp:Label></div>
<div style="width:25%; float:left; text-align:center;padding-bottom:5px; padding-top:5px; border-bottom:1px solid #000; border-top:1px solid #000; border-right :1px solid #000;   font-size:smaller; font-weight:bold; "><asp:Label ID="lblmonth" runat="server"  ></asp:Label></div>
</div>
<div style="width:100%; float:left;">
 <div style="width:40%; float:left;padding-top:14px;">
<asp:GridView ID="staff" runat="server"  Width="100%" 
        AutoGenerateColumns="False" Font-Size="Smaller" ShowFooter="true" GridLines="Horizontal">
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
               
                <div style="width:100%; float:left;padding-top:13px;">
                    <b><asp:Label ID="Label1" runat="server" Text='<%# bind("StaffName") %>'></asp:Label><asp:Label ID="Label2" runat="server" Text='<%# bind("StaffCode") %>' Visible="false"></asp:Label></b><br />
                    </div> 
                  
                </ItemTemplate>
                <ItemStyle Width="30px" />
               <FooterTemplate>Total</FooterTemplate>
                <HeaderTemplate ></HeaderTemplate>
                <FooterStyle Font-Size="Smaller" HorizontalAlign="Center" Font-Bold="true" />
                 <HeaderStyle Font-Size="Smaller" HorizontalAlign="Right" />
            </asp:TemplateField>
           
        </Columns>
    </asp:GridView>
    </div>  
     <div style="width:18%; float:left; ">
<asp:GridView ID="GridWeek1" runat="server"  Width="100%" 
        AutoGenerateColumns="False" Font-Size="Smaller" ShowFooter="true" GridLines="Horizontal">
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
                     <%# GetW1Charges(decimal.Parse(Eval("HourlyCharges").ToString())).ToString("N2")%>
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
    </div>
 <div style="width:18%; float:left; "> 
<asp:GridView ID="GridWeek2" runat="server"  Width="100%" 
        AutoGenerateColumns="False" Font-Size="Smaller" ShowFooter="true" ShowHeader="true" GridLines="Horizontal">
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
                     <%# GetW2Charges(decimal.Parse(Eval("HourlyCharges").ToString())).ToString("N2")%>
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
    </div>

 <div style="width:23%;float:left; ">
<asp:GridView ID="GridMonth" runat="server"  Width="100%" 
        AutoGenerateColumns="False" Font-Size="Smaller" ShowFooter="true" GridLines="Horizontal">
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                <div style="width:100%;   padding-top:13px;">
                    <%# GetMHrs(decimal.Parse(Eval("TotalTime").ToString())).ToString("N2")%>
                    </div>
                </ItemTemplate>
                 <ItemStyle Width="25%"   HorizontalAlign="Right"/>
                 <FooterTemplate>
                 <%# RetMHrsTotal().ToString("N2")%>
                </FooterTemplate>
                <FooterStyle   HorizontalAlign="Right" />
                <HeaderTemplate>Hours</HeaderTemplate>
                 <HeaderStyle Font-Size="Smaller" />
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                <div style="width:100%;   padding-top:13px;">
                     <%# GetMCharges(decimal.Parse(Eval("HourlyCharges").ToString())).ToString("N2")%>
                     </div>
                </ItemTemplate>
                <ItemStyle Width="25%"   HorizontalAlign="Right"/>
                <FooterTemplate>
                 <%# RetMChargesTotal().ToString("N2")%>
                </FooterTemplate>
                <FooterStyle   HorizontalAlign="Right" />
                <HeaderTemplate>Charges</HeaderTemplate>
                  <HeaderStyle Font-Size="Smaller" />
            </asp:TemplateField>            
            <asp:TemplateField>
                <ItemTemplate>
                <div style="width:100%;   padding-top:13px;">
                    <%# GetMOpe(decimal.Parse(Eval("OpeAmt").ToString())).ToString("N2")%>
                    </div>
                </ItemTemplate>
                 <ItemStyle Width="25%"   HorizontalAlign="Right"/>
                 <FooterTemplate>
                 <%# RetMOpeTotal().ToString("N2")%>
                </FooterTemplate>
                <FooterStyle   HorizontalAlign="Right" />
                 <HeaderTemplate>OPEAmt</HeaderTemplate>
                 <HeaderStyle Font-Size="Smaller" />
            </asp:TemplateField>
            <asp:TemplateField>
                <ItemTemplate>
                <div style="width:100%;   padding-top:13px;">
                    <%# GetMOpeChg(decimal.Parse(Eval("Ope_Chg").ToString())).ToString("N2")%>
                    </div>
                </ItemTemplate>
                 <ItemStyle Width="25%"   HorizontalAlign="Right"/>
                 <FooterTemplate>
                 <%# RetMOpeChgTotal().ToString("N2")%>
                </FooterTemplate>
                <FooterStyle   HorizontalAlign="Right" />
                 <HeaderTemplate>Chg+OPE</HeaderTemplate>
                 <HeaderStyle Font-Size="Smaller" />
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    </div>
 </div>
 </div>
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
</asp:Content>

