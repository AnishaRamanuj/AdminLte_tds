<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true"
    CodeFile="Expense_Reports.aspx.cs" Inherits="Admin_Expense_Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .body
        {
            color: #000000;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
function PrintContent(obj)
{
var DocumentContainer = document.getElementById(obj);
var WindowObject = window.open('','PrintWindow','width=950,height=950,top=550,left=50,toolbars=no,scrollbars=yes,status=no,resizable=yes');

WindowObject.document.writeln(DocumentContainer.innerHTML);
WindowObject.document.close();
WindowObject.focus();
WindowObject.print();
WindowObject.close();
return false;
}
    </script>

    <div style="padding-left: 5px; width: 890px;">
        <asp:MultiView ID="JobView" runat="server">
            <asp:View ID="View1" runat="server">
                <div id="div7"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                    <div align="right">
                        &nbsp;&nbsp;
                    </div>
                    <div id="div18"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                        <div style="padding-bottom: 10px" align="right">
                            <asp:Button ID="Button3" runat="server" Text="Print" OnClientClick="return PrintContent('Div73');" /></div>
                        <div id="Div73"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                            <div style="padding-bottom: 10px" align="center">
                                <asp:Label ID="Label3" runat="server" Text="Company Name" CssClass="Head1"></asp:Label></div>
                           <div style="display:none">
                            <div align="center">
                                <asp:Label ID="Label14" runat="server" Text="Manager" CssClass="linkstyle"></asp:Label>
                            </div>
                            <div align="center">
                                <asp:Label ID="Label15" runat="server" Text="Address" CssClass="linkstyle"></asp:Label>
                            </div>
                            <div align="center">
                                <asp:Label ID="Label16" runat="server" Text="ContactNo" CssClass="linkstyle"></asp:Label>
                                ,
                                <asp:Label ID="Label17" runat="server" Text="Email" CssClass="linkstyle"></asp:Label>
                            </div>
                            <div align="center">
                                <asp:Label ID="Label18" runat="server" Text="website" CssClass="linkstyle"></asp:Label>
                            </div></div>
                            <div style="border-top-style: solid; border-top-width: thin; border-top-color: #000000;
                                height: 130px; padding-top: 1px; margin-top: 10px; padding-left: 0px;">
                                <div style="border-top-style: solid; border-top-width: thin; border-top-color: #000000;
                                    height: 130px; padding-top: 2px; padding-left: 5px;">
                                    <div style="width:100%;height: auto;margin-top: 5px;">
                                        <div id="Div19" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div20" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label19" runat="server" CssClass="labelstyle" Text="Report Name"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div21" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <%--<div id="Div7">
        <asp:Label ID="Label3" runat="server" CssClass="labelstyle" Text="Single job"></asp:Label>
        </div>--%>
                                                <asp:Label ID="Label20" runat="server" CssClass="labelstyle" Text="All job->All client->Single staff->All expenses"></asp:Label>
                                            </div>
                                        </div>
                                        <div id="Div25" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div26" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label23" runat="server" CssClass="labelstyle" Text="Job Name"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div27" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <asp:Label ID="Label24" runat="server" CssClass="labelstyle" Text="All job"></asp:Label>
                                            </div>
                                        </div>
                                        <div id="Div22" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div23" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label21" runat="server" CssClass="labelstyle" Text="Client Name"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div24" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <asp:Label ID="Label22" runat="server" CssClass="labelstyle" Text="All client"></asp:Label>
                                            </div>
                                        </div>
                                        <div id="Div28" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div29" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label25" runat="server" CssClass="labelstyle" Text="Staff Name"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div30" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <asp:Label ID="Label26" runat="server" CssClass="labelstyle" Text="Single Staff"></asp:Label>
                                            </div>
                                        </div>
                                        <div id="Div31" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div32" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label27" runat="server" CssClass="labelstyle" Text="Period"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div33" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <asp:Label ID="Label28" runat="server" CssClass="labelstyle" Text="xx-xx-xx to xx-xx-xx"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <div style="width: 100%; float: left; border-top-style: dotted; border-bottom-style: dotted;
                                        border-top-width: thin; border-bottom-width: thin; border-top-color: #000000;
                                        border-bottom-color: #000000; padding-top: 10px; padding-bottom: 10px;">
                                        <div style="width: 29%; float: left; font-weight: bold;">
                                            Job Name</div>
                                        <div style="width: 21%; float: left; font-weight: bold;">
                                            Client Name</div>
                                        <div style="width: 23%; float: left; font-weight: bold;">
                                            Staff Name</div>
                                        <%-- <div style="width: 10%;float:left;font-weight: bold;" >Charges</div>--%>
                                        <div style="width: 8%; float: left; font-weight: bold;">
                                            OPE</div>
                                        <%--<div style="width: 12%; float:left;font-weight: bold;" >Charges + OPE</div>--%>
                                        <div style="width: 14%; float: left; font-weight: bold;">
                                            OPE Type</div>
                                    </div>
                                    <div style="padding-top: 20px; padding-bottom: 20px; float: left; width: 100%">
                                        <asp:DataList ID="Datalist1" runat="server" Width="100%">
                                            <ItemTemplate>
                                                <div style="border-bottom:1px dotted #000000;width:100%;float:left;padding-bottom:10px;padding-top:10px;">
                                                    <div style="width: 28%; float: left; padding-top: 5px; padding-right: 1%">
                                                        <asp:Label ID="lbljobid" runat="server" CssClass="labelstyle" Text='<%# bind("JobId") %>'
                                                            Visible="False"></asp:Label>
                                                        <asp:Label ID="Label38" runat="server" CssClass="labelstyle" Text='<%# bind("JobName") %>'></asp:Label>
                                                    </div>
                                                    <div style="width: 70%; float: left; padding-top: 3px;">
                                                        <asp:GridView ID="grdview" runat="server" AutoGenerateColumns="False" Width="100%"
                                                            DataKeyNames="TSId" GridLines="None" ShowHeader="False" EmptyDataText="No Records Found"
                                                            OnRowDataBound="grdview_RowDataBound" ShowFooter="True">
                                                            <RowStyle Height="30px" />
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="jobid" HeaderStyle-CssClass="gridhaedstyle" Visible="false">
                                                                    <ItemTemplate>
                                                                        <div style="width:90px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("TsId") %>'
                                                                                Visible="False"></asp:Label>
                                                                        </div>
                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"></HeaderStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderStyle-CssClass="gridhaedstyle" FooterText="Total" HeaderText="Date">
                                                                    <ItemTemplate>
                                                                        <div style="width:127px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text='<%# bind("ClientName") %>'></asp:Label>
                                                                        </div>
                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                    <FooterStyle HorizontalAlign="Left" Font-Bold="True"></FooterStyle>
                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"></HeaderStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Hours" HeaderStyle-CssClass="gridhaedstyle">
                                                                    <ItemTemplate>
                                                                        <div style="width:127px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;" style="padding-left: 10px">
                                                                            <asp:Label ID="lbltime" runat="server" CssClass="labelstyle" Text='<%# bind("StaffName") %>'></asp:Label>
                                                                        </div>
                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                    <FooterStyle Font-Bold="True" />
                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"></HeaderStyle>
                                                                </asp:TemplateField>
                                                                <%-- <asp:TemplateField HeaderText="Charges" FooterText="99,99,999">
                    <ItemTemplate>
                        <div style="width:90px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                            <asp:Label ID="lblcharges" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("charges") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                     <div style="width: 10%;float:left;font-weight: bold;" >
                     <asp:Label ID="Label30" runat="server" Text="0"></asp:Label></div>
                    </FooterTemplate>
                    <FooterStyle Font-Bold="True" />
                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"/>
                </asp:TemplateField>--%>
                                                                <asp:TemplateField HeaderText="OPE" FooterText="99,99,999">
                                                                    <ItemTemplate>
                                                                        <div style="width:60px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                            <div style="text-align: right; width: 60px; padding-right: 19px">
                                                                                <asp:Label ID="lblope" runat="server" CssClass="labelstyle" Text='<%# bind("ope","{0:f2}") %>'></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                    <FooterTemplate>
                                                                        <div style="width:60px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                            <div style="text-align: right; width: 60px; padding-right: 19px">
                                                                                <asp:Label ID="Label31" runat="server" Text="0"></asp:Label></div>
                                                                        </div>
                                                                    </FooterTemplate>
                                                                    <FooterStyle Font-Bold="True" />
                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left" />
                                                                </asp:TemplateField>
                                                                <%--<asp:TemplateField HeaderText="Charges + OPE" FooterText="99,99,999">
                    <ItemTemplate>
                        <div style="width:90px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                            <asp:Label ID="lblchope" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("chope") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                           <div style="width: 12%;float:left;font-weight: bold;" >
                           <asp:Label ID="Label32" runat="server" Text="0"></asp:Label></div>
                    </FooterTemplate>
                       <FooterStyle Font-Bold="True" />
                       <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"/>
                </asp:TemplateField>    --%>
                                                                <asp:TemplateField HeaderText="OPE Type" HeaderStyle-CssClass="gridhaedstyle">
                                                                    <ItemTemplate>
                                                                        <div style="width:117px;padding:1% 1% 1%  1%;padding-left:10px; vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;" style="padding-left:20px">
                                                                            <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text='<%# bind("OPEName") %>'></asp:Label>
                                                                        </div>
                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                  
                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"></HeaderStyle>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                            <HeaderStyle CssClass="header" />
                                                        </asp:GridView>
                                                        <div id="Div35"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                                                            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
                                                            </asp:SqlDataSource>
                                                        </div>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:DataList>
                                    </div>
                                    <div style="width: 100%; float: left; border-top-style: dotted; border-bottom-style: dotted;
                                        border-top-width: thin; border-bottom-width: thin; border-top-color: #000000;
                                        border-bottom-color: #000000; padding-top: 10px; padding-bottom: 10px;">
                                        <div style="width: 68%; float: left; font-weight: bold;">
                                            Grand Total</div>
                                        <%-- <div style="width: 8%;float:left ;font-weight: bold;"><asp:Label ID="Label29" runat="server" Text="0"></asp:Label></div>--%>
                                        <div style="width: 8%; float: left; font-weight: bold; text-align:right;">
                                            <asp:Label ID="Label30" runat="server" Text="0"></asp:Label></div>
                                        <%--  <div style="width: 10%; float:left;font-weight: bold;" ><asp:Label ID="Label31" runat="server" Text="0"></asp:Label></div>--%>
                                        <div style="width: 14%; float: left; font-weight: bold;">
                                        </div>
                                    </div>
                                    <div style="float: left; width: 100%; border-top-style: double; border-bottom-style: double;
                                        border-top-width: thin; border-bottom-width: thin; border-top-color: #000000;
                                        border-bottom-color: #000000; margin-top: 10px;">
                                        <div style="width: 100%; float: left;">
                                            <div style="width: 65%; float: left;">
                                                Printed by:
                                                <asp:Label ID="Label33" runat="server" Text="superadmin"></asp:Label>
                                            </div>
                                            <div style="width: 10%; float: right;">
                                                page
                                                <asp:Label ID="Label34" runat="server" Text="1"></asp:Label>
                                                of
                                                <asp:Label ID="Label35" runat="server" Text="1"></asp:Label>
                                            </div>
                                        </div>
                                        <div style="width: 100%; float: left;">
                                            <div style="width: 65%; float: left;">
                                                Printed on:
                                                <asp:Label ID="Label36" runat="server" Text="Label"></asp:Label></div>
                                            <div style="width: 10%; float: right;">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="div34" class="seperotorrwr">
                    </div>
                </div>
            </asp:View>
            <asp:View ID="View2" runat="server">
                <div id="div54"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                    <div align="right">
                        &nbsp;&nbsp;
                    </div>
                    <div id="div55"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                        <div style="padding-bottom: 10px" align="right">
                            <asp:Button ID="Button1" runat="server" Text="Print" OnClientClick="return PrintContent('Div44');" /></div>
                        <div id="Div44"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                            <div style="padding-bottom: 10px" align="center">
                                <asp:Label ID="Label63" runat="server" Text="Company Name" CssClass="Head1"></asp:Label></div>
                            <div style="display:none">
                            <div align="center">
                                <asp:Label ID="Label64" runat="server" Text="Manager" CssClass="linkstyle"></asp:Label>
                            </div>
                            <div align="center">
                                <asp:Label ID="Label65" runat="server" Text="Address" CssClass="linkstyle"></asp:Label>
                            </div>
                            <div align="center">
                                <asp:Label ID="Label66" runat="server" Text="ContactNo" CssClass="linkstyle"></asp:Label>
                                ,
                                <asp:Label ID="Label67" runat="server" Text="Email" CssClass="linkstyle"></asp:Label>
                            </div>
                            <div align="center">
                                <asp:Label ID="Label68" runat="server" Text="website" CssClass="linkstyle"></asp:Label>
                            </div></div>
                            <div style="border-top-style: solid; border-top-width: thin; border-top-color: #000000;
                                height: 130px; padding-top: 1px; margin-top: 10px; padding-left: 0px;">
                                <div style="border-top-style: solid; border-top-width: thin; border-top-color: #000000;
                                    height: 130px; padding-top: 2px; padding-left: 5px;">
                                    <div style="width:100%;height: auto;margin-top: 5px;">
                                        <div id="Div56" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div57" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label69" runat="server" CssClass="labelstyle" Text="Report Name"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div58" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <%--<div id="Div7">
        <asp:Label ID="Label3" runat="server" CssClass="labelstyle" Text="Single job"></asp:Label>
        </div>--%>
                                                <asp:Label ID="Label70" runat="server" CssClass="labelstyle" Text="All client->All job->All staff->All expenses"></asp:Label>
                                            </div>
                                        </div>
                                        <div id="Div59" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div60" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label71" runat="server" CssClass="labelstyle" Text="Client Name"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div61" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <asp:Label ID="Label72" runat="server" CssClass="labelstyle" Text="All client"></asp:Label>
                                            </div>
                                        </div>
                                        <div id="Div62" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div63" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label73" runat="server" CssClass="labelstyle" Text="Job Name"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div64" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <asp:Label ID="Label74" runat="server" CssClass="labelstyle" Text="All job"></asp:Label>
                                            </div>
                                        </div>
                                        <div id="Div65" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div66" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label75" runat="server" CssClass="labelstyle" Text="Staff Name"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div67" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <asp:Label ID="Label76" runat="server" CssClass="labelstyle" Text="All Staff"></asp:Label>
                                            </div>
                                        </div>
                                        <div id="Div68" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div69" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label77" runat="server" CssClass="labelstyle" Text="Period"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div70" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <asp:Label ID="Label78" runat="server" CssClass="labelstyle" Text="xx-xx-xx to xx-xx-xx"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <div style="width: 100%; float: left; border-top-style: dotted; border-bottom-style: dotted;
                                        border-top-width: thin; border-bottom-width: thin; border-top-color: #000000;
                                        border-bottom-color: #000000; padding-top: 10px; padding-bottom: 10px;">
                                        <div style="width: 28%; float: left; font-weight: bold;">
                                            Job Name</div>
                                        <div style="width: 16%; float: left; font-weight: bold; padding-left: 2%;">
                                            Staff Name</div>
                                        <div style="width: 18%; float: left; font-weight: bold; padding-left: 2%;">
                                            Client Name</div>
                                        <div style="width: 13%; float: left; font-weight: bold; padding-left: 2%;">
                                            Date</div>
                                        <div style="width: 6%; float: left; font-weight: bold;" align="left">
                                            OPE</div>
                                        <div style="width: 9%; float: left; font-weight: bold; padding-left: 1%;" align="left">
                                            OPE Type</div>
                                    </div>
                                    <div style="padding-top: 20px; padding-bottom: 20px; float: left; width: 100%">
                                        <asp:DataList ID="Datalist3" runat="server" Width="100%">
                                            <ItemTemplate>
                                                <div style="border-bottom:1px dotted #000000;width:100%;float:left;padding-bottom:10px;padding-top:10px;">
                                                    <div style="width: 29%; float: left; padding-top: 5px; padding-right: 1%">
                                                        <asp:Label ID="lbljobid" runat="server" CssClass="labelstyle" Text='<%# bind("JobId") %>'
                                                            Visible="False"></asp:Label>
                                                        <asp:Label ID="Label38" runat="server" CssClass="labelstyle" Text='<%# bind("JobName") %>'></asp:Label>
                                                    </div>
                                                    <div style="width: 69%; float: left; padding-top: 5px;">
                                                        <asp:DataList ID="Datalist4" runat="server" Width="100%">
                                                            <ItemTemplate>
                                                                <div style="width: 100%; float: left">
                                                                    <div style="width: 25%; float: left; padding-top: 5px;">
                                                                        <asp:Label ID="lblstaffcode" runat="server" CssClass="labelstyle" Text='<%# bind("StaffCode") %>'
                                                                            Visible="False"></asp:Label>
                                                                        <asp:Label ID="lblstaffname" runat="server" CssClass="labelstyle" Text='<%# bind("StaffName") %>'></asp:Label>
                                                                    </div>
                                                                    <div style="width: 74%; float: left; padding-top: 3px;">
                                                                        <asp:GridView ID="grdview2" runat="server" AutoGenerateColumns="False" Width="100%"
                                                                            DataKeyNames="TSId" GridLines="None" ShowHeader="False" EmptyDataText="No Records Found"
                                                                            ShowFooter="True" OnRowDataBound="grdview2_RowDataBound">
                                                                            <RowStyle Height="30px" />
                                                                            <Columns>
                                                                                <asp:TemplateField HeaderText="jobid" HeaderStyle-CssClass="gridhaedstyle" Visible="false">
                                                                                    <ItemTemplate>
                                                                                        <div style="width:90px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("TsId") %>'
                                                                                                Visible="False"></asp:Label>
                                                                                        </div>
                                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"></HeaderStyle>
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="Hours" HeaderStyle-CssClass="gridhaedstyle">
                                                                                    <ItemTemplate>
                                                                                        <div style="width:187px;padding:0% 12% 0% 1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                                            <asp:Label ID="lbltime" runat="server" CssClass="labelstyle" Text='<%# bind("ClientName") %>'></asp:Label>
                                                                                        </div>
                                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"></HeaderStyle>
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderStyle-CssClass="gridhaedstyle" FooterText="Total" HeaderText="Date">
                                                                                    <ItemTemplate>
                                                                                        <div style="width:74px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text='<%# bind("Date") %>'></asp:Label>
                                                                                        </div>
                                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                                    <FooterStyle HorizontalAlign="Left" Font-Bold="True"></FooterStyle>
                                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"></HeaderStyle>
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="OPE" FooterText="99,99,999">
                                                                                    <ItemTemplate>
                                                                                        <div style="width:75px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                                            <div style="text-align: right; width: 70px;">
                                                                                                <asp:Label ID="lblope" runat="server" CssClass="labelstyle" Text='<%# bind("ope","{0:f2}") %>'></asp:Label>
                                                                                            </div>
                                                                                        </div>
                                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                                    <FooterTemplate>
                                                                                        <div style="width:75px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                                            <div style="text-align: right; width: 70px; ">
                                                                                                <asp:Label ID="Label31" runat="server" Text="0"></asp:Label></div>
                                                                                        </div>
                                                                                    </FooterTemplate>
                                                                                    <FooterStyle Font-Bold="True" />
                                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left" />
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="OPE Type" HeaderStyle-CssClass="gridhaedstyle">
                                                                                    <ItemTemplate>
                                                                                        <div style="width:117px;padding:1% 1% 1%  1%;padding-left:10px;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;" style="text-align:center">
                                                                                            <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text='<%# bind("OPEName") %>'></asp:Label>
                                                                                        </div>
                                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                                    <ItemStyle Width="260px" />
                                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"></HeaderStyle>
                                                                                </asp:TemplateField>
                                                                            </Columns>
                                                                            <HeaderStyle CssClass="header" />
                                                                        </asp:GridView>
                                                                        <div id="Div35"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                                                                            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
                                                                            </asp:SqlDataSource>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </ItemTemplate>
                                                        </asp:DataList>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:DataList>
                                    </div>
                                    <div style="width: 100%; float: left; border-top-style: dotted; border-bottom-style: dotted;
                                        border-top-width: thin; border-bottom-width: thin; border-top-color: #000000;
                                        border-bottom-color: #000000; padding-top: 10px; padding-bottom: 10px;">
                                        <div style="width: 68%; float: left; font-weight: bold;">
                                            Grand Total</div>
                                        <div style="width: 8%; float: left; font-weight: bold;">
                                            Date</div>
                                        <div style="width: 9%; float: left; font-weight: bold;text-align:right;padding-right: 3%;">
                                            <asp:Label ID="Label81" runat="server" Text="0"></asp:Label></div>
                                    </div>
                                    <div style="float: left; width: 100%; border-top-style: double; border-bottom-style: double;
                                        border-top-width: thin; border-bottom-width: thin; border-top-color: #000000;
                                        border-bottom-color: #000000; margin-top: 10px;">
                                        <div style="width: 100%; float: left;">
                                            <div style="width: 65%; float: left;">
                                                Printed by:
                                                <asp:Label ID="Label83" runat="server" Text="superadmin"></asp:Label>
                                            </div>
                                            <div style="width: 10%; float: right;">
                                                page
                                                <asp:Label ID="Label84" runat="server" Text="1"></asp:Label>
                                                of
                                                <asp:Label ID="Label85" runat="server" Text="1"></asp:Label>
                                            </div>
                                        </div>
                                        <div style="width: 100%; float: left;">
                                            <div style="width: 65%; float: left;">
                                                Printed on:
                                                <asp:Label ID="Label86" runat="server" Text="Label"></asp:Label></div>
                                            <div style="width: 10%; float: right;">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="div71" class="seperotorrwr">
                    </div>
                </div>
            </asp:View>
            <asp:View ID="View3" runat="server">
                <div id="div1"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                    <div align="right">
                        &nbsp;&nbsp;
                    </div>
                    <div id="div2"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                        <div style="padding-bottom: 10px" align="right">
                            <asp:Button ID="Button2" runat="server" Text="Print" OnClientClick="return PrintContent('Div45');" /></div>
                        <div id="Div45"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                            <div style="padding-bottom: 10px" align="center">
                                <asp:Label ID="Label1" runat="server" Text="Company Name" CssClass="Head1"></asp:Label></div>
                            <div style="display: none">
                                <div align="center">
                                    <asp:Label ID="Label4" runat="server" Text="Manager" CssClass="linkstyle"></asp:Label>
                                </div>
                                <div align="center">
                                    <asp:Label ID="Label5" runat="server" Text="Address" CssClass="linkstyle"></asp:Label>
                                </div>
                                <div align="center">
                                    <asp:Label ID="Label7" runat="server" Text="ContactNo" CssClass="linkstyle"></asp:Label>
                                    ,
                                    <asp:Label ID="Label8" runat="server" Text="Email" CssClass="linkstyle"></asp:Label>
                                </div>
                                <div align="center">
                                    <asp:Label ID="Label9" runat="server" Text="website" CssClass="linkstyle"></asp:Label>
                                </div>
                            </div>
                            <div style="border-top-style: solid; border-top-width: thin; border-top-color: #000000;
                                height: 130px; padding-top: 1px; margin-top: 10px; padding-left: 0px;">
                                <div style="border-top-style: solid; border-top-width: thin; border-top-color: #000000;
                                    height: 130px; padding-top: 2px; padding-left: 5px;">
                                    <div style="width:100%;height: auto;margin-top: 5px;">
                                        <div id="Div3" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div4" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label10" runat="server" CssClass="labelstyle" Text="Report Name"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div5" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <asp:Label ID="Label11" runat="server" CssClass="labelstyle" Text="All clients->All expenses"></asp:Label>
                                            </div>
                                        </div>
                                        <div id="Div6" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div8" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label12" runat="server" CssClass="labelstyle" Text="Client Name"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div9" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <asp:Label ID="Label13" runat="server" CssClass="labelstyle" Text="All clients"></asp:Label>
                                            </div>
                                        </div>
                                        <div id="Div16" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div17" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label40" runat="server" CssClass="labelstyle" Text="Period"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div36" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <asp:Label ID="Label41" runat="server" CssClass="labelstyle" Text="xx-xx-xx to xx-xx-xx"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <div style="width: 100%; float: left; border-top-style: dotted; border-bottom-style: dotted;
                                        border-top-width: thin; border-bottom-width: thin; border-top-color: #000000;
                                        border-bottom-color: #000000; padding-top: 10px; padding-bottom: 10px;">
                                        <div style="width: 40%; float: left; font-weight: bold;">
                                            Client Name</div>
                                        <%--<div style="width: 16%;float:left; font-weight: bold;padding-left:2%;" >Job Name</div>--%>
                                        <%--<div style="width: 18%;float:left; font-weight: bold;padding-left:2%;" >Staff Name</div>--%>
                                        <div style="width: 19%; float: left; font-weight: bold; padding-left: 2%;">
                                            Date</div>
                                        <div style="width: 9%; float: left; font-weight: bold;" align="left">
                                            OPE</div>
                                        <div style="width: 9%; float: left; font-weight: bold; padding-left: 1%;" align="left">
                                            OPE Type</div>
                                    </div>
                                    <div style="padding-top: 20px; padding-bottom: 20px; float: left; width: 100%">
                                        <asp:DataList ID="Datalist2" runat="server" Width="100%">
                                            <ItemTemplate>
                                                <div id="nodatadiv" runat="server" style="border-bottom:1px dotted #000000;width:100%;float:left;padding-bottom:10px;padding-top:10px;">
                                                    <div style="width: 40%; float: left; padding-top: 5px; padding-right: 1%">
                                                        <asp:Label ID="lbljobid" runat="server" CssClass="labelstyle" Text='<%# bind("CLTId") %>'
                                                            Visible="False"></asp:Label>
                                                        <asp:Label ID="Label38" runat="server" CssClass="labelstyle" Text='<%# bind("ClientName") %>'></asp:Label>
                                                    </div>
                                                    <div style="width: 59%; float: left; padding-top: 5px;">
                                                        <asp:GridView ID="grdview3" runat="server" AutoGenerateColumns="False" Width="100%"
                                                            GridLines="None" ShowHeader="False" EmptyDataText="No Records Found" ShowFooter="True"
                                                            OnRowDataBound="grdview3_RowDataBound">
                                                            <RowStyle Height="30px" />
                                                            <Columns>
                                                                <asp:TemplateField HeaderStyle-CssClass="gridhaedstyle" FooterText="Total" HeaderText="Date">
                                                                    <ItemTemplate>
                                                                        <div style="width:75px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text='<%# bind("Date") %>'></asp:Label>
                                                                        </div>
                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                    <FooterStyle HorizontalAlign="Left" Font-Bold="True"></FooterStyle>
                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"></HeaderStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="OPE" FooterText="99,99,999">
                                                                    <ItemTemplate>
                                                                        <div style="width:85px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                            <div style="text-align: right; width: 85px; ">
                                                                                <asp:Label ID="lblope" runat="server" CssClass="labelstyle" Text='<%# bind("ope","{0:f2}") %>'></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                    <FooterTemplate>
                                                                        <div style="width:85px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                            <div style="text-align: right; width: 85px;">
                                                                                <asp:Label ID="Label31" runat="server" Text="0"></asp:Label></div>
                                                                        </div>
                                                                    </FooterTemplate>
                                                                    <FooterStyle Font-Bold="True" />
                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left" />
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="OPE Type" HeaderStyle-CssClass="gridhaedstyle">
                                                                    <ItemTemplate>
                                                                        <div style="width:127px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;" style="text-align:center">
                                                                            <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text='<%# bind("OPEName") %>'></asp:Label>
                                                                        </div>
                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                    <ItemStyle Width="260px" />
                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"></HeaderStyle>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                            <HeaderStyle CssClass="header" />
                                                        </asp:GridView>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:DataList>
                                    </div>
                                    <div style="width: 100%; float: left; border-top-style: dotted; border-bottom-style: dotted;
                                        border-top-width: thin; border-bottom-width: thin; border-top-color: #000000;
                                        border-bottom-color: #000000; padding-top: 10px; padding-bottom: 10px;">
                                        <div style="width: 41%; float: left; font-weight: bold;">
                                            Grand Total</div>
                                        <div style="width: 12%; float: left; font-weight: bold;">
                                            Date</div>
                                        <div style="width: 12%; float: left; font-weight: bold; padding-right: 3%;text-align:right;">
                                            <asp:Label ID="Label42" runat="server" Text="0"></asp:Label></div>
                                    </div>
                                    <div style="float: left; width: 100%; border-top-style: double; border-bottom-style: double;
                                        border-top-width: thin; border-bottom-width: thin; border-top-color: #000000;
                                        border-bottom-color: #000000; margin-top: 10px;">
                                        <div style="width: 100%; float: left;">
                                            <div style="width: 65%; float: left;">
                                                Printed by:
                                                <asp:Label ID="Label43" runat="server" Text="superadmin"></asp:Label>
                                            </div>
                                            <div style="width: 30%; float: right;text-align:right">
                                                page
                                                <asp:Label ID="Label44" runat="server" Text="1"></asp:Label>
                                                of
                                                <asp:Label ID="Label45" runat="server" Text="1"></asp:Label>
                                            </div>
                                        </div>
                                        <div style="width: 100%; float: left;">
                                            <div style="width: 65%; float: left;">
                                                Printed on:
                                                <asp:Label ID="Label46" runat="server" Text="Label"></asp:Label></div>
                                            <div style="width: 10%; float: right;">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="div37" class="seperotorrwr">
                    </div>
                </div>
            </asp:View>
            <asp:View ID="View4" runat="server">
                <div id="div10"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                    <div align="right">
                        &nbsp;&nbsp;
                    </div>
                    <div id="div11"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                        <div style="padding-bottom: 10px" align="right">
                            <asp:Button ID="Button4" runat="server" Text="Print" OnClientClick="return PrintContent('Div46');" /></div>
                        <div id="Div46"  style="width:100%;margin:0px auto auto auto;height:auto;float:left;">
                            <div style="padding-bottom: 10px" align="center">
                                <asp:Label ID="Label29" runat="server" Text="Company Name" CssClass="Head1"></asp:Label></div>
                            <div style="display: none">
                                <div align="center">
                                    <asp:Label ID="Label32" runat="server" Text="Manager" CssClass="linkstyle"></asp:Label>
                                </div>
                                <div align="center">
                                    <asp:Label ID="Label37" runat="server" Text="Address" CssClass="linkstyle"></asp:Label>
                                </div>
                                <div align="center">
                                    <asp:Label ID="Label39" runat="server" Text="ContactNo" CssClass="linkstyle"></asp:Label>
                                    ,
                                    <asp:Label ID="Label47" runat="server" Text="Email" CssClass="linkstyle"></asp:Label>
                                </div>
                                <div align="center">
                                    <asp:Label ID="Label48" runat="server" Text="website" CssClass="linkstyle"></asp:Label>
                                </div>
                            </div>
                            <div style="border-top-style: solid; border-top-width: thin; border-top-color: #000000;
                                height: 130px; padding-top: 1px; margin-top: 10px; padding-left: 0px;">
                                <div style="border-top-style: solid; border-top-width: thin; border-top-color: #000000;
                                    height: 130px; padding-top: 2px; padding-left: 5px;">
                                    <div style="width:100%;height: auto;margin-top: 5px;">
                                        <div id="Div12" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div13" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label49" runat="server" CssClass="labelstyle" Text="Report Name"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div14" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <%--<div id="Div7">
        <asp:Label ID="Label3" runat="server" CssClass="labelstyle" Text="Single job"></asp:Label>
        </div>--%>
                                                <asp:Label ID="Label50" runat="server" CssClass="labelstyle" Text="All staffs->All expenses"></asp:Label>
                                            </div>
                                        </div>
                                        <div id="Div15" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div38" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label51" runat="server" CssClass="labelstyle" Text="Staff Name"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div39" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <asp:Label ID="Label52" runat="server" CssClass="labelstyle" Text="All staffs"></asp:Label>
                                            </div>
                                        </div>
                                        <%--    <div id="Div10" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
    <div id="Div11" class="repleft">
        <asp:Label ID="Label29" runat="server" CssClass="labelstyle" Text="Job Name  :"></asp:Label>
        </div>
         <div id="Div12" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
        <asp:Label ID="Label32" runat="server" CssClass="labelstyle" Text="All job"></asp:Label>
        </div>
    </div>
     <div id="Div13" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
    <div id="Div14" class="repleft">
        <asp:Label ID="Label37" runat="server" CssClass="labelstyle" Text="Staff Name  :"></asp:Label>
        </div>
    <div id="Div15" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
        <asp:Label ID="Label39" runat="server" CssClass="labelstyle" Text="All Staff"></asp:Label>
        </div>
        
    </div>--%>
                                        <div id="Div40" style="width:98%;min-height:20px;float:left;margin-right: 0px;height: 20px;">
                                            <div id="Div41" style="width:12%;padding:2px 1% 2px 0%;min-height:20px;height :auto !important;height:30px;text-align:right;float:left;text-align:left;">
                                                <asp:Label ID="Label53" runat="server" CssClass="labelstyle" Text="Period"></asp:Label>
                                            </div>
                                            <div style="width:.5%;min-height:30px;height:auto !important;height:20px;text-align:right;float:left;text-align:left;">
                                                :</div>
                                            <div id="Div42" style="width:84.5%;padding:2px 1%  2px 1%;min-height:20px;height:auto !important;height:30px;float:left;">
                                                <asp:Label ID="Label54" runat="server" CssClass="labelstyle" Text="xx-xx-xx to xx-xx-xx"></asp:Label>
                                            </div>
                                        </div>
                                    </div>
                                    <div style="width: 100%; float: left; border-top-style: dotted; border-bottom-style: dotted;
                                        border-top-width: thin; border-bottom-width: thin; border-top-color: #000000;
                                        border-bottom-color: #000000; padding-top: 10px; padding-bottom: 10px;">
                                        <div style="width: 40%; float: left; font-weight: bold;">
                                            Staff Name</div>
                                        <%--<div style="width: 16%;float:left; font-weight: bold;padding-left:2%;" >Job Name</div>--%>
                                        <%--<div style="width: 18%;float:left; font-weight: bold;padding-left:2%;" >Staff Name</div>--%>
                                        <div style="width: 19%; float: left; font-weight: bold; padding-left: 2%;">
                                            Date</div>
                                        <div style="width: 9%; float: left; font-weight: bold;" align="left">
                                            OPE</div>
                                        <div style="width: 9%; float: left; font-weight: bold; padding-left: 1%;" align="left">
                                            OPE Type</div>
                                    </div>
                                    <div style="padding-top: 20px; padding-bottom: 20px; float: left; width: 100%">
                                        <asp:DataList ID="Datalist5" runat="server" Width="100%">
                                            <ItemTemplate>
                                                <div id="nodatadiv" runat="server" style="border-bottom:1px dotted #000000;width:100%;float:left;padding-bottom:10px;padding-top:10px;">
                                                    <div style="width: 40%; float: left; padding-top: 5px; padding-right: 1%">
                                                        <asp:Label ID="lbljobid" runat="server" CssClass="labelstyle" Text='<%# bind("StaffCode") %>'
                                                            Visible="False"></asp:Label>
                                                        <asp:Label ID="Label38" runat="server" CssClass="labelstyle" Text='<%# bind("StaffName") %>'></asp:Label>
                                                    </div>
                                                    <div style="width: 59%; float: left; padding-top: 5px;">
                                                        <asp:GridView ID="grdview4" runat="server" AutoGenerateColumns="False" Width="100%"
                                                            GridLines="None" ShowHeader="False" EmptyDataText="No Records Found" ShowFooter="True"
                                                            OnRowDataBound="grdview4_RowDataBound">
                                                            <RowStyle Height="30px" />
                                                            <Columns>
                                                                <asp:TemplateField HeaderStyle-CssClass="gridhaedstyle" FooterText="Total" HeaderText="Date">
                                                                    <ItemTemplate>
                                                                        <div style="width:75px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text='<%# bind("Date") %>'></asp:Label>
                                                                        </div>
                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                    <FooterStyle HorizontalAlign="Left" Font-Bold="True"></FooterStyle>
                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"></HeaderStyle>
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="OPE" FooterText="99,99,999">
                                                                    <ItemTemplate>
                                                                        <div style="width:80px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                            <div style="text-align: right; width:80px;">
                                                                                <asp:Label ID="lblope" runat="server" CssClass="labelstyle" Text='<%# bind("ope","{0:f2}") %>'></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                    <FooterTemplate>
                                                                        <div style="width:80px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;">
                                                                            <div style="text-align: right; width: 80px;>
                                                                                <asp:Label ID="Label31" runat="server" Text="0"></asp:Label></div>
                                                                        </div>
                                                                    </FooterTemplate>
                                                                    <FooterStyle Font-Bold="True" />
                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left" />
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="OPE Type" HeaderStyle-CssClass="gridhaedstyle">
                                                                    <ItemTemplate>
                                                                        <div style="width:127px;padding:1% 1% 1%  1%;vertical-align:top;word-wrap:break-word;font-size:11px;font-family:Verdana,Arial,Helvetica,sans-serif;color:#000000;text-decoration:none;" style="text-align:center">
                                                                            <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text='<%# bind("OPEName") %>'></asp:Label>
                                                                        </div>
                                                                    </ItemTemplate><ItemStyle VerticalAlign="Top" />
                                                                    <ItemStyle Width="260px" />
                                                                    <HeaderStyle CssClass="gridhaedstyle" HorizontalAlign="Left"></HeaderStyle>
                                                                </asp:TemplateField>
                                                            </Columns>
                                                            <HeaderStyle CssClass="header" />
                                                        </asp:GridView>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:DataList>
                                    </div>
                                    <div style="width: 100%; float: left; border-top-style: dotted; border-bottom-style: dotted;
                                        border-top-width: thin; border-bottom-width: thin; border-top-color: #000000;
                                        border-bottom-color: #000000; padding-top: 10px; padding-bottom: 10px;">
                                        <div style="width: 41%; float: left; font-weight: bold;">
                                            Grand Total</div>
                                        <div style="width: 15.5%; float: left; font-weight: bold;">
                                            Date</div>
                                        <div style="width: 8%; float: left; font-weight: bold;text-align:right;padding-right: 3%;">
                                            <asp:Label ID="Label55" runat="server" Text="0"></asp:Label></div>
                                    </div>
                                    <div style="float: left; width: 100%; border-top-style: double; border-bottom-style: double;
                                        border-top-width: thin; border-bottom-width: thin; border-top-color: #000000;
                                        border-bottom-color: #000000; margin-top: 10px;">
                                        <div style="width: 100%; float: left;">
                                            <div style="width: 65%; float: left;">
                                                Printed by:
                                                <asp:Label ID="Label56" runat="server" Text="superadmin"></asp:Label>
                                            </div>
                                            <div style="width: 10%; float: right;">
                                                page
                                                <asp:Label ID="Label57" runat="server" Text="1"></asp:Label>
                                                of
                                                <asp:Label ID="Label58" runat="server" Text="1"></asp:Label>
                                            </div>
                                        </div>
                                        <div style="width: 100%; float: left;">
                                            <div style="width: 65%; float: left;">
                                                Printed on:
                                                <asp:Label ID="Label59" runat="server" Text="Label"></asp:Label></div>
                                            <div style="width: 10%; float: right;">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="div43" class="seperotorrwr">
                    </div>
                </div>
            </asp:View>
        </asp:MultiView>
    </div>
</asp:Content>
