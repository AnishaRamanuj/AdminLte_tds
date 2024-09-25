<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="ad_editjob.aspx.cs" Inherits="Admin_ad_editjob" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register src="../controls/MessageControl.ascx" tagname="MessageControl" tagprefix="uc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<script language="javascript" type="text/javascript">
    function pad2(number) {
    return (number < 10 ? '0' : '') + number
   }
        function checkForm() {
        
            // regular expression to match required date format
            var dt = new Date();
            var day = dt.getDate();
            var mon =dt.getMonth() + 1;
            var yr = dt.getFullYear();
            var pin = document.getElementById("<%= txtestenddate.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%=txtestenddate.ClientID%>").focus();
                var month=pad2(mon);
                var m= document.getElementById("<%=HiddenField1.ClientID%>").value ;
                 document.getElementById("<%=txtestenddate.ClientID%>").value =m ;
                 if( document.getElementById("<%=HiddenField1.ClientID%>").value =="")
                 {
                document.getElementById("<%=txtestenddate.ClientID%>").value =day+"/"+month+"/"+yr ;
                }
                return false;
            }
        }
         function checkForms() {
        
            // regular expression to match required date format
            var dt = new Date();
            var day = dt.getDate();
            var mon =dt.getMonth() + 1;
            var yr = dt.getFullYear();
            var pin = document.getElementById("<%= txtactualdate.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%= txtactualdate.ClientID%>").focus();
                var month=pad2(mon);
                 var m= document.getElementById("<%=HiddenField2.ClientID%>").value ;
                 document.getElementById("<%=txtactualdate.ClientID%>").value =m ;
                 if( document.getElementById("<%=HiddenField2.ClientID%>").value =="")
                 {
                document.getElementById("<%=txtactualdate.ClientID%>").value =day+"/"+month+"/"+yr ;
                }
              
                return false;
            }
        }
          function checkFormanother() {
        
            // regular expression to match required date format
            var dt = new Date();
            var day = dt.getDate();
            var mon =dt.getMonth() + 1;
            var yr = dt.getFullYear();
            var pin = document.getElementById("<%= txtstartdate.ClientID%>").value;
             if (pin != '' && !pin.match(/^(?:(0[1-9]|[12][0-9]|3[01])[\- \/.](0[1-9]|1[012])[\- \/.](19|20)[0-9]{2})$/))
           // if (pin != '' && !pin.match("^[0-1][1-9][- / ]?(0[1-9]|[12][0-9]|3[01])[- /]?(18|19|20|21)\\d{2}$"))
             {
             
               alert("Invalid date format: " + pin);
                document.getElementById("<%= txtstartdate.ClientID%>").focus();
                var month=pad2(mon);
                  var m= document.getElementById("<%=HiddenField3.ClientID%>").value ;
                 document.getElementById("<%=txtstartdate.ClientID%>").value =m ;
                 if( document.getElementById("<%=HiddenField3.ClientID%>").value =="")
                 {
                document.getElementById("<%=txtstartdate.ClientID%>").value =day+"/"+month+"/"+yr ;
                }
                //document.getElementById("<%= txtstartdate.ClientID%>").value = day+"/"+month+"/"+yr ;
                return false;
            }
        }
       </script>

    <script type="text/javascript" language="javascript">
    function ValidateText(i) {
        if (i.value == 0) {
            i.value = null;
        }
        if (i.value.length > 0) {
            i.value = i.value.replace(/[^\d]+/g, '');
        }
        CountFrmTitle(i, 15);
    }
    function ValidateText1(i) {
        if (i.value == 0) {
            i.value = null;
        }
        if (i.value.length > 0) {
            i.value = i.value.replace(/[^\d]+/g, '');
        }
        CountFrmTitle(i, 9);
    }
    function CountFrmTitle(field, max) {
        if (field.value.length > max) {
            field.value = field.value.substring(0, max);
            alert("You are exceding the maximum limit");
        }
        else {

            var count = max - field.value.length;
        }
        validate();
    }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div>
        <div id="totbdy" class="totbodycatreg1" style="height:auto";>
            <div id="haeder" class="headerstyle" style="margin-left:12px;width:870px;">
                <asp:Label ID="Label22" runat="server" CssClass="Head1" Text="Edit Job Profile"></asp:Label>
              
              
            </div>
             <div id="Div1" style="width:99%;padding-left:2px">     
                            <uc1:MessageControl ID="MessageControl1" runat="server" />
                </div>
         
        <%--    
            <div style="padding-bottom: 3px; width: 100%; float: left; text-align:right;">
                <a href="javascript: history.go(-1)" 
                    style="font-family:Arial, Helvetica, sans-serif;color:#279BC0; font-size:11px; font-weight:bold; text-decoration:none;">
                Back</a>
            </div>--%>
            <div id="Div81" class="seperotorrwr">
            </div>
            <div id="contactdiv" class="insidetot">
                <div class="cont_fieldset"  style="width:862px;">
                  <%--  <legend>Job Details</legend>--%>
                    <div id="Div77" class="seperotorrwr">
                    </div>
                    <div id="insidrw1" class="comprw_admin">
                        <div id="insideleft1" class="leftrw_left_1">
                            <asp:Label ID="Label1" runat="server" CssClass="labelstyle" Text="Job Name "></asp:Label>
                        </div>
                        <div id="insideright1" class="rightrw">
                            <asp:TextBox ID="txtclientname" runat="server" CssClass="txtnrml_long"></asp:TextBox>
                            <asp:Label ID="Label23" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div class="comprw_admin">
                        <div class="leftrw_left_1">
                            <asp:Label ID="Label11" runat="server" CssClass="labelstyle" Text="Job Group Name"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:DropDownList ID="drpjobgroup" runat="server" CssClass="dropstyle" 
                                 DataTextField="jobGroupName" 
                                DataValueField="JobGId" Width="200px" AppendDataBoundItems="True">
                                <asp:ListItem Value="0">--Select--</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div id="Div35" class="comprw_admin">
                        <div id="Div36" class="leftrw_left_1">
                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text="Company Name "></asp:Label>
                        </div>
                        <div id="Div37" class="rightrw">
                            
                            <asp:DropDownList ID="drpcompany" runat="server" AutoPostBack="True" 
                               DataTextField="CompanyName" 
                                DataValueField="CompId" CssClass="dropstyle" Width="200px" 
                                onselectedindexchanged="drpcompany_SelectedIndexChanged">
                            </asp:DropDownList>
                            
                        </div>
                    </div>
                     <div class="comprw_admin">
                        <div class="leftrw_left_1">
                            <asp:Label ID="Label4" runat="server" CssClass="labelstyle" Text="Client Name"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:DropDownList ID="drpclient" runat="server" 
                                DataTextField="ClientName" DataValueField="CLTId" CssClass="dropstyle" 
                                Width="200px" onselectedindexchanged="drpclient_SelectedIndexChanged" 
                                AppendDataBoundItems="True">
                                <asp:ListItem Value="0">--Select--</asp:ListItem>
                            </asp:DropDownList>                                             
                            <asp:Label ID="Label9" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div id="Div17" class="comprw_admin" style="height:auto">
                        <div id="Div18" class="leftrw_left_1">
                            <asp:Label ID="Label7" runat="server" CssClass="labelstyle" Text="Add Team Members"></asp:Label>
                        </div>
                        <div id="Div19" class="rightrw_1">
                          <div style="width:300px">
                      <asp:Panel ID="Panel1" runat="server" style="overflow:auto;width:468px;float: left;" ScrollBars="Vertical" BorderColor="#B6D1FB" BorderStyle="Solid" BorderWidth="1px" Height="100px">
                            <asp:DataList ID="DataList1" runat="server" Width="450px">
                                <ItemTemplate>
                                  <div style="width: 435px; float: left;padding-left: 10px;padding-top:5px">
                                        <div style="width: 30px; float: left;">
                                            <asp:CheckBox ID="chkitem" runat="server" />
                                        </div>
                                          <div class="dataliststyle_new">
                                            <asp:Label ID="Label50" runat="server" Text='<%# bind("StaffName") %>'></asp:Label>
                                            <asp:Label ID="Label51" runat="server" Text='<%# bind("StaffCode") %>' 
                                                Visible="False"></asp:Label>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:DataList><div id="nodiv" runat="server" style="display:none;"> <asp:Label ID="Label12" runat="server" CssClass="errlabelstyle" Text="No Staff Found"></asp:Label></div></asp:Panel>
                            </div>              
                        </div><asp:Label ID="Label52" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                    </div>
                    <div class="comprw_admin" style="padding-top:5px;">
                        <div class="leftrw_left_1">
                            <asp:Label ID="Label3" runat="server" CssClass="labelstyle" Text="Approver"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:DropDownList ID="drpapprover" runat="server" DataTextField="StaffName" 
                                DataValueField="StaffCode" CssClass="dropstyle" Width="200px" 
                                AppendDataBoundItems="True">
                                <asp:ListItem Value="0">--Select--</asp:ListItem>
                            </asp:DropDownList>
                           <%-- <asp:SqlDataSource ID="SqlDataSourcestaff" runat="server" SelectCommand="SELECT * from Staff_Master where CLTId=@clientid"
                           
                                                     ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>">
                    <SelectParameters>
                      <asp:SessionParameter Name="clientid" SessionField="clientid" Type="Int32" />
            </SelectParameters>
                         </asp:SqlDataSource>--%>
                            <asp:Label ID="Label49" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    
                   
                    <div class="comprw_admin">
                        <div class="leftrw_left_1">
                            <asp:Label ID="Label15" runat="server" CssClass="labelstyle" 
                                Text="Estimate Job End Date"></asp:Label>
                        </div>
                        <div class="rightrw">
                           <div style="padding-left: 0px; float: left;"> <asp:TextBox ID="txtestenddate" runat="server" CssClass="txtnrml" Width="80px"></asp:TextBox></div>
                           <div style="padding-top: 10px 0px 0px 0px; float: left;"> <asp:Image ID="Image10" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                            <cc1:calendarextender id="txtestenddate_CalendarExtender" runat="server" 
                                format="dd/MM/yyyy" popupbuttonid="Image10" targetcontrolid="txtestenddate">
                            </cc1:calendarextender>
                        </div>
                    </div>
                      <div id="Div11" class="comprw_admin">
                        <div id="Div12" class="leftrw_left_1">
                            <asp:Label ID="Label5" runat="server" CssClass="labelstyle" Text="Budget Hours"></asp:Label>
                        </div>
                        <div id="Div13" class="rightrw">
                            <asp:TextBox ID="txtbudhours" runat="server" CssClass="numerictxtbox" 
                                Width="80px"></asp:TextBox>
                        </div>
                    </div>
                    <div id="Div14" class="comprw_admin">
                        <div id="Div15" class="leftrw_left_1">
                            <asp:Label ID="Label6" runat="server" CssClass="labelstyle" 
                                Text="Budget Amount"></asp:Label>
                        </div>
                        <div id="Div16" class="rightrw">
                            <asp:TextBox ID="txtbudamt" runat="server" CssClass="numerictxtbox" 
                                Width="80px"></asp:TextBox>
                        </div>
                    </div>
                      <div id="Div29" class="comprw_admin">
                        <div id="Div30" class="leftrw_left_1">
                            <asp:Label ID="Label10" runat="server" CssClass="labelstyle" 
                                Text="Actual Hours"></asp:Label>
                        </div>
                        <div id="Div31" class="rightrw">
                            <asp:TextBox ID="txtactualhours" runat="server" CssClass="numerictxtbox" 
                                Width="80px"></asp:TextBox>
                        </div>
                    </div>
                    <div id="Div20" class="comprw_admin">
                        <div id="Div21" class="leftrw_left_1">
                            <asp:Label ID="Label8" runat="server" CssClass="labelstyle" 
                                Text="Actual Amount"></asp:Label>
                        </div>
                        <div id="Div22" class="rightrw">
                            <asp:TextBox ID="txtactualamt" runat="server" CssClass="numerictxtbox" 
                                Width="80px"></asp:TextBox>
                            <span lang="en-us">&nbsp;</span><asp:Label ID="emailerrmsg1" runat="server" 
                                CssClass="errlabelstyle"></asp:Label>
                        </div>
                    </div>
                     <div class="comprw_admin">
                        <div class="leftrw_left_1">
                            <asp:Label ID="Label13" runat="server" CssClass="labelstyle" Text="Job Status"></asp:Label>
                        </div>
                        <div class="rightrw">
                            <asp:DropDownList ID="drpjobstatus" runat="server" Width="200px" CssClass="dropstyle"
                                AppendDataBoundItems="True">
                                <asp:ListItem Value="0">--Select--</asp:ListItem>
                                <asp:ListItem Value="1">OnGoing</asp:ListItem>
                                <asp:ListItem Value="2">Completed</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="comprw_admin">
                        <div class="leftrw_left_1">
                            <asp:Label ID="Label14" runat="server" CssClass="labelstyle" 
                                Text="Actual Job End Date"></asp:Label>
                        </div>
                        <div class="rightrw">
                          <div style="float: left;">  <asp:TextBox ID="txtactualdate" runat="server" CssClass="txtnrml" Width="80px"></asp:TextBox></div>
                           <div style="padding-top: 10px 0px 0px 0px; float: left;">  <asp:Image ID="Image18" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                            <cc1:calendarextender id="txtactualdate_CalendarExtender" runat="server" 
                                format="dd/MM/yyyy" popupbuttonid="Image18" targetcontrolid="txtactualdate">
                            </cc1:calendarextender>
                      <div style="padding-left: 5px; float: left;"> <asp:Label ID="Label53" runat="server" CssClass="errlabelstyle" Text="*" 
                        ForeColor="Red"></asp:Label></div>
                        </div>
                    </div>
                     <div class="comprw_admin">
                <div class="leftrw_left_1">
                    <asp:Label ID="Label16" runat="server" CssClass="labelstyle" Text="Actual Job Start Date"></asp:Label>
                </div>
                  <div class="rightrw">
                 <div style="float: left;"> <asp:TextBox ID="txtstartdate" CssClass="txtnrml" runat="server" Width="80px"></asp:TextBox></div>
                <div style="padding-top: 10px 0px 0px 0px; float: left;"> <asp:Image ID="Image1" runat="server" ImageUrl="~/images/pdate (17 x 15).jpg" /></div>
                    <cc1:calendarextender ID="Calendarextender1" runat="server" TargetControlID="txtstartdate" 
                        PopupButtonID="Image1" Format="dd/MM/yyyy">
                    </cc1:calendarextender>
                      <div style="padding-left: 5px; float: left;"> <asp:Label ID="Label17" runat="server" CssClass="errlabelstyle" Text="*" 
                        ForeColor="Red"></asp:Label></div>
                </div>
              
            </div>  
                   
                  
                    <div id="Div26" class="comprw_admin" style="padding-top:10px">
                        <div id="Div27" class="leftrw_left_1">
                        </div>
                        <div id="Div28" class="rightrw">
                            <asp:Button ID="btnupdate" runat="server" onclick="btnupdate_Click" CssClass="buttonstyle_reg"
                                Text="Update " />
                            <span lang="en-us">&nbsp;</span><asp:Button ID="btncancel" runat="server" CssClass="buttonstyle_reg"
                                onclick="btncancel_Click" Text="Cancel" />
                            <span lang="en-us">&nbsp;</span></div>
                    </div>
                     <div id="Div2" class="comprw_admin" style="padding-top:10px">
                        <div id="Div3" class="leftrw_left_1">
                            <asp:HiddenField ID="HiddenField1" runat="server" />
                        </div>
                        <div id="Div4" class="rightrw">
                            <asp:HiddenField ID="HiddenField2" runat="server" />
                            <asp:HiddenField ID="HiddenField3" runat="server" />
                          </div>
                    </div>
                    <div id="Div44" class="seperotorrwr">
                    </div>
                </div>
                 <div style="width: 100%; float: left; padding-top: 5px;padding-bottom:10px; height: 10px; padding-left: 10px; margin-top: 5px; font-weight: bold;margin-left:15px">
                        Notes:
                    </div>
                     <div class="reapeatItem3" style="width:862px;margin-left:12px">
                  <div id="msghead" class="totbodycatreg">
        <span class="labelstyle" style="color:Red; font-size:smaller;">Fields marked with * are required</span>
           
        </div></div>
            </div>
        </div>
    </div>
</asp:Content>

