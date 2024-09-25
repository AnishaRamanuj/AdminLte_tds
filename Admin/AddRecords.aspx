<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="AddRecords.aspx.cs" Inherits="Admin_AddRecords" %>
<%@ Register Src="../controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript" language="javascript">
        function ValidateText(i) 
        {
            if (i.value == 0) 
            {
                i.value = null;
            }
            if (i.value.length > 0) 
            {
                i.value = i.value.replace(/[^\d]+/g, '');
            }
            CountFrmTitle(i,12);
        }
        function CountFrmTitle(field, max) 
        {
            if (field.value.length > max) 
            {
                alert(field.value);
                field.value = field.value.substring(0, max);
                 alert("You are exceding the maximum limit");
             }
             else 
            {            
                var count = max - field.value.length;
            }
            
        }
        function validate() {
            regExpression = /^[a-zA-Z][a-zA-Z\s]+$/;
            var asd = document.getElementById("<%= txtdesignation.ClientID%>");

            if (!regExpression.test(asd.value)) {

                asd.value = asd.value.substring(0, asd.value.length - 1)

                return false;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
        <div class="totbodycatreg1" style="height: auto">
        <div class="headerstyle_admin">
            <div class="headerstyle1_admin">
                <asp:Label ID="Label19" runat="server" Text="" CssClass="Head5"></asp:Label>
            </div>
        </div>
        <div style="padding-bottom: 0px; padding-top: 10px; width: 100%; float: left; padding-left: 8px;
            overflow: auto;">
            <div style="overflow: auto; padding-bottom: 0px; width: 24%; float: left; padding-left: 1%" align="left">
                <asp:Label ID="Label18" runat="server" Text="Company Name" CssClass="labelstyle"></asp:Label>
            </div>
            <div style="overflow: auto; padding-bottom: 0px; width: 58%; float: left;">
                <asp:DropDownList ID="drpcompany" runat="server" DataTextField="CompanyName" DataValueField="CompId" CssClass="dropstyle"
                    DataSourceID="SqlDataSource9" Width="250px"  AutoPostBack="True"
                    OnSelectedIndexChanged="drpcompany_SelectedIndexChanged">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSource9" runat="server" SelectCommand="SELECT * from Company_Master order by CompanyName"
                    ConnectionString="<%$ ConnectionStrings:ConnectionString %>" ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>">
                </asp:SqlDataSource>
            </div>
        </div>
        <div id="Div1" runat="server" class="masterdiv">
            <div style="width: 97%; float: left">
                <uc1:MessageControl ID="MessageControl2" runat="server" />
                <div id="Div77" class="seperotorrwr">
                </div>
                <div id="add_desn" runat="server" class="masterdiv1" style="padding-left: 8px;">
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                            <asp:Label ID="Label1" runat="server" CssClass="labelstyle" Text="Designation Name"></asp:Label>
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:TextBox ID="txtdesignation" runat="server" CssClass="txtnrml_long"></asp:TextBox>
                            <asp:Label ID="Label23" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label><br />
                            <%--                     <asp:Label ID="labeldesig" runat="server" CssClass="labelstyle" Text="0"></asp:Label>
--%>
                        </div>
                    </div>
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text="Hourly Charges"></asp:Label>
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:TextBox ID="txthourcharge" runat="server" CssClass="numerictxtbox" onkeyup="return  ValidateText(this);"></asp:TextBox>
                            <asp:Label ID="Label15" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:Button ID="btndesignation" runat="server" Text="Submit" OnClick="btndesignation_Click" />
                        </div>
                    </div>
                </div>
                <div id="searchdesg" runat="server" style="width: 100%; padding-bottom: 5px; overflow: auto;
                    float: right; text-align: right;">
                    <div style="float: right;">
                        <%--  <div style="float:left; text-align:right; width:70%; padding-top: 5px;overflow:hidden">--%>
                        <asp:Label ID="Label21" runat="server" Text="Search Designation"></asp:Label>
                        &nbsp;&nbsp;<%--</div>--%>
                        <%--<div style="float:left; text-align:right; width:29%;overflow:hidden">  --%>
                        <asp:TextBox ID="txtdesgsearch" runat="server" CssClass="txtnrml" Width="150px"></asp:TextBox>
                        <asp:Button ID="btnsesg" runat="server" Text="Search" CssClass="buttonstyle_search" OnClick="btnsesg_Click" />
                    </div>
                    <%--</div>--%>
                </div>
                <div class="clearall">
                </div>
                <div style="float: right; text-align: right; width: 100%; padding-bottom: 5px; padding-top: 5px">
                    <div style="float: right;">
                        <asp:ImageButton ID="imgDesn" runat="server" ImageUrl="~/images/addnew_1.jpg" OnClick="lnknewclient_Click" />
                        <%--                      <asp:LinkButton ID="lnkDesn" runat="server" CssClass="masterLinks" OnClick="lnknewclient_Click">Add New</asp:LinkButton></div>           
--%>
                    </div>
                    <div class="mastergrid">
                        <asp:GridView ID="Griddealers" runat="server" AutoGenerateColumns="False" Width="100%"
                            BorderColor="#55A0FF" DataSourceID="SqlDataSource1" DataKeyNames="DsgId" OnRowCommand="Griddealers_RowCommand"
                            AllowPaging="True" OnPageIndexChanging="Griddealers_PageIndexChanging" EmptyDataText="No records found!!!"
                            PageSize="10" OnRowEditing="Griddealers_RowEditing" OnRowUpdating="Griddealers_RowUpdating"
                            OnRowCancelingEdit="Griddealers_RowCancelingEdit" OnRowDataBound="Griddealers_RowDataBound">
                             <RowStyle Height="15px" />
                            <Columns>
                                <asp:TemplateField HeaderText="jobid" HeaderStyle-CssClass="grdheadermster" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("DsgId") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Designation Name" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Text='<%# bind("DesignationName") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:TextBox ID="TextBox1" runat="server" Height="16px" Text='<%# bind("DesignationName") %>'
                                                Width="180px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Hourly Charges">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="Label3" runat="server" CssClass="labelstyle4" Text='<%# bind("HourlyCharges") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:TextBox ID="TextBox2" runat="server" Height="16px" Text='<%# bind("HourlyCharges") %>'
                                                Width="50px" CssClass="numerictxtbox" onkeyup="return  ValidateText(this);"></asp:TextBox>
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" align="center">
                                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit_sm1.jpg"
                                                ToolTip="Edit" />
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Button ID="Button2" runat="server" CommandName="update" Text="Update" />
                                            <asp:Button ID="Button3" runat="server" CommandName="cancel" Text="Cancel" />
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <div style="width: 100%" align="center">
                                            <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("DsgId") %>'
                                                ImageUrl="~/images/delete1.jpg" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                                ToolTip="Delete" CommandName="delete" />
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster" />
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="grdheadermster" />
                        </asp:GridView>
                    </div>
                    <div style="width: 100%; float: left; padding-top: 5px; padding-bottom: 10px; height: 10px;
                        padding-left: 2%; margin-top: 5px; font-weight: bold;text-align:left">
                        Notes:
                    </div>
                    <div class="reapeatItem3">
                        <div id="msghead" runat="server" class="msgdiv" style="padding-left: 2%; width: 100%;
                            float: left; text-align: left; width: 100%;">
                            <asp:Label ID="Label20" runat="server" Text="Fields marked with * are required" Font-Size="Smaller"
                                ForeColor="Red"></asp:Label>
                            <%--<span class="labelstyle"  style="color:Red; font-size:smaller;">Fields marked with * are required</span>      --%>
                        </div>
                        <div style="height: 25px; padding-top: 10px; float: left; text-align: left; width: 100%;">
                            <span class="labelstyle" style="font-size: 11px; font-weight: bold;">
                                Designation Master page to add / edit designations. A designation is associated
                                with Staff Master</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="Div2" runat="server" class="masterdiv">
            <div style="width: 97%; float: left">
                <uc1:MessageControl ID="MessageControl1" runat="server" />
                <div id="Div3" class="seperotorrwr">
                </div>
                <div id="add_depart" runat="server" class="masterdiv1" style="padding-left: 8px;">
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                            <asp:Label ID="Label3" runat="server" CssClass="labelstyle" Text="Department Name"></asp:Label>
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:TextBox ID="txtdeptname" runat="server" CssClass="txtnrml_long"></asp:TextBox>
                            <asp:Label ID="Label4" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:Button ID="btndept" runat="server" Text="Submit" OnClick="btndept_Click" />
                        </div>
                    </div>
                </div>
                <div id="searchdept" runat="server" style="float: left; text-align: right; width: 100%;
                    padding-bottom: 5px;">
                    <div style="float: right;">
                        <%--  <div style="float: left; text-align: right; width: 70%; padding-top: 5px;">--%>
                        <asp:Label ID="Label22" runat="server" Text="Search Department"></asp:Label>&nbsp;&nbsp;
                        <%--   </div>
                    <div style="float: right; text-align: right; width: 29%;">--%>
                        <asp:TextBox ID="txtsearchdept" runat="server" CssClass="txtnrml" Width="150px"></asp:TextBox>
                        <asp:Button ID="btndepsearch" runat="server" Text="Search" CssClass="buttonstyle_search" OnClick="btndepsearch_Click" />
                    </div>
                </div>
                <%-- </div>--%>
                <div style="float: right; text-align: right; width: 100%; padding-bottom: 5px; padding-top: 5px">
                    <div style="float: right;">
                        <asp:ImageButton ID="imgDepart" runat="server" ImageUrl="~/images/addnew_1.jpg" OnClick="LinkDepart_Click" />
                        <%--                    <asp:LinkButton ID="LinkDepart" runat="server" CssClass="masterLinks" OnClick="LinkDepart_Click">Add New Department</asp:LinkButton></div>
--%>
                    </div>
                    <div class="mastergrid">
                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" Width="100%"
                            DataSourceID="SqlDataSource2" DataKeyNames="DepId" AllowPaging="True" EmptyDataText="No records found!!!"
                            BorderColor="#55A0FF" OnPageIndexChanging="GridView1_PageIndexChanging" OnRowCommand="GridView1_RowCommand"
                            PageSize="10" OnRowCancelingEdit="GridView1_RowCancelingEdit" OnRowUpdating="GridView1_RowUpdating"
                            OnRowEditing="GridView1_RowEditing" OnRowDataBound="GridView1_RowDataBound">
                            <RowStyle Height="15px" />
                            <Columns>
                                <asp:TemplateField HeaderText="jobid" HeaderStyle-CssClass="grdheadermster" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("DepId") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Department Name" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Text='<%# bind("DepartmentName") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:TextBox ID="TextBox3" runat="server" Height="16px" Text='<%# bind("DepartmentName") %>'
                                                Width="241px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" align="center">
                                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit_sm1.jpg"
                                                ToolTip="Edit" />
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Button ID="Button2" runat="server" CommandName="update" Text="Update" />
                                            <asp:Button ID="Button3" runat="server" CommandName="cancel" Text="Cancel" />
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <div style="width: 100%" align="center">
                                            <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("DepId") %>'
                                                ImageUrl="~/images/delete1.jpg" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                                ToolTip="Delete" CommandName="delete" /></div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster" />
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="grdheadermster" />
                        </asp:GridView>
                    </div>
                    <div style="width: 100%; float: left; padding-top: 5px; padding-bottom: 10px; height: 10px;
                        padding-left: 2%; margin-top: 5px; font-weight: bold;text-align:left">
                        Notes:
                    </div>
                    <div class="reapeatItem3">
                        <div id="msghead1" runat="server" class="msgdiv" style="padding-left: 2%; float: left;
                            text-align: left; width: 100%;">
                            <span class="labelstyle" style="color: Red; font-size: smaller;float: left;width:167px;">Fields marked with
                                * are required</span>
                        </div>
                        <div style="height: 25px; padding-top: 10px; float: left; text-align: left; width: 100%;">
                            <span class="labelstyle" style="font-size: 11px; font-weight: bold;">
                                Department Master page to add / edit departments. A department is associated with
                                Staff Master</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="Div4" runat="server" class="masterdiv">
            <div style="width: 97%; float: left">
                <uc1:MessageControl ID="MessageControl3" runat="server" />
                <div id="Div5" class="seperotorrwr">
                </div>
                <div id="add_brch" runat="server" class="masterdiv1" style="padding-left: 8px;">
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                            <asp:Label ID="Label5" runat="server" CssClass="labelstyle" Text="Branch Name"></asp:Label>
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:TextBox ID="txtbranchname" runat="server" CssClass="txtnrml_long"></asp:TextBox>
                            <asp:Label ID="Label6" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:Button ID="btnbranch" runat="server" Text="Submit" OnClick="btnbranch_Click" />
                        </div>
                    </div>
                </div>
                <div id="searchbr" runat="server" style="float: left; text-align: right; width: 100%;
                    padding-bottom: 5px;">
                    <div style="float: right;">
                        <%--  <div style="float: left; text-align: right; width: 70%; padding-top: 5px;">--%>
                        <asp:Label ID="Label24" runat="server" Text="Search Branch"></asp:Label>&nbsp;&nbsp;
                        <%-- </div>
                    <div style="float: right; text-align: right; width: 29%;">--%>
                        <asp:TextBox ID="txtbrsearch" runat="server" CssClass="txtnrml" Width="150px"></asp:TextBox>
                        <asp:Button ID="btnsearchbr" runat="server" Text="Search" CssClass="buttonstyle_search" OnClick="btnsearchbr_Click" />
                        <%-- </div>--%>
                    </div>
                </div>
                <div style="float: left; text-align: right; width: 100%; padding-bottom: 5px; padding-top: 5px">
                    <div style="float: right;">
                        <asp:ImageButton ID="ImageBranch" runat="server" ImageUrl="~/images/addnew_1.jpg"
                            OnClick="LinkBranch_Click" />
                        <%--                    <asp:LinkButton ID="LinkBranch" runat="server" CssClass="masterLinks" OnClick="LinkBranch_Click">Add New Branch</asp:LinkButton></div>
--%>
                    </div>
                    <div class="mastergrid">
                        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" Width="100%"
                            BorderColor="#55A0FF" DataSourceID="SqlDataSource3" DataKeyNames="BrId" AllowPaging="True"
                            EmptyDataText="No records found!!!" OnPageIndexChanging="GridView2_PageIndexChanging"
                            OnRowCommand="GridView2_RowCommand" PageSize="10" OnRowCancelingEdit="GridView2_RowCancelingEdit"
                            OnRowEditing="GridView2_RowEditing" OnRowUpdating="GridView2_RowUpdating" OnRowDataBound="GridView2_RowDataBound">
                            <RowStyle Height="15px" />
                            <Columns>
                                <asp:TemplateField HeaderText="BrId" HeaderStyle-CssClass="grdheadermster" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("BrId") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Branch Name" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Text='<%# bind("BranchName") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:TextBox ID="TextBox3" runat="server" Height="16px" Text='<%# bind("BranchName") %>'
                                                Width="241px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" align="center">
                                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit_sm1.jpg"
                                                ToolTip="Edit" />
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Button ID="Button2" runat="server" CommandName="update" Text="Update" />
                                            <asp:Button ID="Button3" runat="server" CommandName="cancel" Text="Cancel" />
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <div style="width: 100%" align="center">
                                            <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("BrId") %>'
                                                ImageUrl="~/images/delete1.jpg" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                                ToolTip="Delete" CommandName="delete" /></div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster" />
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="grdheadermster" />
                        </asp:GridView>
                    </div>
                    <div style="width: 100%; float: left; padding-top: 5px; padding-bottom: 10px; height: 10px;
                        padding-left: 2%; margin-top: 5px; font-weight: bold;text-align:left">
                        Notes:
                    </div>
                    <div class="reapeatItem3">
                        <div id="msghead2" runat="server" class="msgdiv" style="padding-left: 2%; float: left;
                            text-align: left; width: 100%;">
                            <span class="labelstyle" style="color: Red; font-size: smaller;">Fields marked with
                                * are required</span>
                        </div>
                        <div style="height: 25px; padding-top: 10px; float: left; text-align: left; width: 100%;">
                            <span class="labelstyle" style="font-size: 11px; font-weight: bold;">
                                Branch Master page to add / edit Branches. A branch is associated with Staff Master</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="Div6" runat="server" class="masterdiv">
            <div style="width: 97%; float: left">
                <uc1:MessageControl ID="MessageControl4" runat="server" />
                <div id="Div7" class="seperotorrwr">
                </div>
                <div id="add_ope" runat="server" class="masterdiv1" style="padding-left: 8px;">
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                            <asp:Label ID="Label7" runat="server" CssClass="labelstyle" Text="OPE Name"></asp:Label>
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:TextBox ID="txtopename" runat="server" CssClass="txtnrml_long"></asp:TextBox>
                            <asp:Label ID="Label8" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:Button ID="btnope" runat="server" Text="Submit" OnClick="btnope_Click" />
                        </div>
                    </div>
                </div>
                <div id="searchope" runat="server" style="float: left; text-align: right; width: 100%;
                    padding-bottom: 5px;">
                    <div style="float: right;">
                        <%--     <div style="float: left; text-align: right; width: 70%; padding-top: 5px;">--%>
                        <asp:Label ID="Label25" runat="server" Text="Search OPE"></asp:Label>&nbsp;&nbsp;
                        <%--  </div>
                    <div style="float: right; text-align: right; width: 29%;">--%>
                        <asp:TextBox ID="txtopesearch" runat="server" CssClass="txtnrml" Width="150px"></asp:TextBox>
                        <asp:Button ID="btnopesearch" runat="server" Text="Search" CssClass="buttonstyle_search" OnClick="btnopesearch_Click" />
                        <%-- </div>--%>
                    </div>
                </div>
                <div style="float: left; text-align: right; width: 100%; padding-bottom: 5px; padding-top: 5px">
                    <div style="float: right;">
                        <asp:ImageButton ID="ImageOpe" runat="server" ImageUrl="~/images/addnew_1.jpg" OnClick="LinkOpe_Click" />
                        <%--                    <asp:LinkButton ID="LinkOpe" runat="server" CssClass="masterLinks" OnClick="LinkOpe_Click">Add New OPE</asp:LinkButton></div>
--%>
                    </div>
                    <div class="mastergrid">
                        <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False" Width="100%"
                            BorderColor="#55A0FF" DataSourceID="SqlDataSource4" DataKeyNames="OpeId" AllowPaging="True"
                            EmptyDataText="No records found!!!" OnPageIndexChanging="GridView3_PageIndexChanging"
                            OnRowCommand="GridView3_RowCommand" PageSize="10" OnRowCancelingEdit="GridView3_RowCancelingEdit"
                            OnRowEditing="GridView3_RowEditing" OnRowUpdating="GridView3_RowUpdating" OnRowDataBound="GridView3_RowDataBound">
                            <RowStyle Height="15px" />
                            <Columns>
                                <asp:TemplateField HeaderText="OpeId" HeaderStyle-CssClass="grdheadermster" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("OpeId") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="OPE Name" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Text='<%# bind("OPEName") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:TextBox ID="TextBox3" runat="server" Height="16px" Text='<%# bind("OPEName") %>'
                                                Width="241px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" align="center">
                                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit_sm1.jpg"
                                                ToolTip="Edit" />
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Button ID="Button2" runat="server" CommandName="update" Text="Update" />
                                            <asp:Button ID="Button3" runat="server" CommandName="cancel" Text="Cancel" />
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <div style="width: 100%" align="center">
                                            <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("OpeId") %>'
                                                ImageUrl="~/images/delete1.jpg" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                                ToolTip="Delete" CommandName="delete" />
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster" />
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="grdheadermster" />
                        </asp:GridView>
                    </div>
                    <div style="width: 100%; float: left; padding-top: 5px; padding-bottom: 10px; height: 10px;
                        padding-left: 2%; margin-top: 5px; font-weight: bold;text-align:left">
                        Notes:
                    </div>
                    <div class="reapeatItem3">
                        <div id="msghead3" runat="server" class="msgdiv" style="padding-left: 2%; float: left;
                            text-align: left; width: 100%;">
                            <span class="labelstyle" style="color: Red; font-size: smaller;float: left;width:167px">Fields marked with
                                * are required</span>
                        </div>
                        <div style="height: 25px; padding-top: 10px; float: left; text-align: left; width: 100%;">
                            <span class="labelstyle" style="font-size: 11px; font-weight: bold;">
                                OPE Master page to add / edit Expenses. A single expense is associated with multiple
                                Clients & Expenses Input</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="Div8" runat="server" class="masterdiv">
            <div style="width: 97%; float: left">
                <uc1:MessageControl ID="MessageControl5" runat="server" />
                <div id="Div9" class="seperotorrwr">
                </div>
                <div id="add_lctn" runat="server" class="masterdiv1" style="padding-left: 8px;">
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                            <asp:Label ID="Label9" runat="server" CssClass="labelstyle" Text="Location Name"></asp:Label>
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:TextBox ID="txtlocation" runat="server" CssClass="txtnrml_long"></asp:TextBox>
                            <asp:Label ID="Label10" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:Button ID="btnlocation" runat="server" Text="Submit" OnClick="btnlocation_Click" />
                        </div>
                    </div>
                </div>
                <div id="searchloc" runat="server" style="float: left; text-align: right; width: 100%;
                    padding-bottom: 5px;">
                    <div style="float: right;">
                        <%--  <div style="float: left; text-align: right; width: 70%; padding-top: 5px;">--%>
                        <asp:Label ID="Label26" runat="server" Text="Search Location"></asp:Label>&nbsp;&nbsp;
                        <%--</div>
                    <div style="float: right; text-align: right; width: 29%;">--%>
                        <asp:TextBox ID="txtlocsearch" runat="server" CssClass="txtnrml" Width="150px"></asp:TextBox>
                        <asp:Button ID="btnlocsearch" runat="server" CssClass="buttonstyle_search" Text="Search" OnClick="btnlocsearch_Click" />
                        <%-- </div>--%>
                    </div>
                </div>
                <div style="float: left; text-align: right; width: 100%; padding-bottom: 5px; padding-top: 5px">
                    <div style="float: right;">
                        <asp:ImageButton ID="ImageLocatn" runat="server" ImageUrl="~/images/addnew_1.jpg"
                            OnClick="LinkLocatn_Click" />
                        <%--                    <asp:LinkButton ID="LinkLocatn" runat="server" CssClass="masterLinks" OnClick="LinkLocatn_Click">Add New Location</asp:LinkButton></div>
--%>
                    </div>
                    <div class="mastergrid">
                        <asp:GridView ID="GridView4" runat="server" AutoGenerateColumns="False" Width="100%"
                            BorderColor="#55A0FF" DataSourceID="SqlDataSource5" DataKeyNames="LocId" AllowPaging="True"
                            EmptyDataText="No records found!!!" OnPageIndexChanging="GridView4_PageIndexChanging"
                            OnRowCommand="GridView4_RowCommand" PageSize="10" OnRowCancelingEdit="GridView4_RowCancelingEdit"
                            OnRowEditing="GridView4_RowEditing" OnRowUpdating="GridView4_RowUpdating" OnRowDataBound="GridView4_RowDataBound">
                            <RowStyle Height="15px" />
                            <Columns>
                                <asp:TemplateField HeaderText="OpeId" HeaderStyle-CssClass="grdheadermster" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("LocId") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Location Name" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Text='<%# bind("LocationName") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:TextBox ID="TextBox3" runat="server" Height="16px" Text='<%# bind("LocationName") %>'
                                                Width="241px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" align="center">
                                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit_sm1.jpg"
                                                ToolTip="Edit" />
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Button ID="Button2" runat="server" CommandName="update" Text="Update" />
                                            <asp:Button ID="Button3" runat="server" CommandName="cancel" Text="Cancel" />
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <div style="width: 100%" align="center">
                                            <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("LocId") %>'
                                                ImageUrl="~/images/delete1.jpg" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                                ToolTip="Delete" CommandName="delete" /></div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster" />
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="grdheadermster" />
                        </asp:GridView>
                    </div>
                    <div style="width: 100%; float: left; padding-top: 5px; padding-bottom: 10px; height: 10px;
                        padding-left: 2%; margin-top: 5px; font-weight: bold;text-align:left">
                        Notes:
                    </div>
                    <div class="reapeatItem3">
                        <div id="msghead4" runat="server" class="msgdiv" style="padding-left: 2%; float: left;
                            text-align: left; width: 100%;">
                            <span class="labelstyle" style="color: Red; font-size: smaller;">Fields marked with
                                * are required</span>
                        </div>
                        <div style="height: 25px; padding-top: 10px; float: left; text-align: left; width: 100%;">
                            <span class="labelstyle" style="font-size: 11px; font-weight: bold;">
                                Location Master page to add / edit locations. A location is associated with Timesheet
                                Input & Expenses Input</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="Div10" runat="server" class="masterdiv">
            <div style="width: 97%; float: left">
                <uc1:MessageControl ID="MessageControl6" runat="server" />
                <div id="Div11" class="seperotorrwr">
                </div>
                <div id="add_narn" runat="server" class="masterdiv1" style="padding-left: 8px;">
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                            <asp:Label ID="Label11" runat="server" CssClass="labelstyle" Text="Narration Name"></asp:Label>
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:TextBox ID="txtnaration" runat="server" CssClass="txtnrml_long"></asp:TextBox>
                            <asp:Label ID="Label12" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:Button ID="btnnaration" runat="server" Text="Submit" OnClick="btnnaration_Click" />
                        </div>
                    </div>
                </div>
                <div id="searchnar" runat="server" style="float: left; text-align: right; width: 100%;
                    padding-bottom: 5px;">
                    <div style="float: right;">
                        <%-- <div style="float: left; text-align: right; width: 70%; padding-top: 5px;">--%>
                        <asp:Label ID="Label27" runat="server" Text="Search Narration"></asp:Label>&nbsp;&nbsp;
                        <%-- </div>
                    <div style="float: right; text-align: right; width: 29%;">--%>
                        <asp:TextBox ID="txtnarsearch" runat="server" CssClass="txtnrml" Width="150px"></asp:TextBox>
                        <asp:Button ID="btnsearchnar" runat="server" Text="Search" CssClass="buttonstyle_search" OnClick="btnsearchnar_Click" />
                    </div>
                </div>
                <div style="float: left; text-align: right; width: 100%; padding-bottom: 5px; padding-top: 5px">
                    <div style="float: right;">
                        <asp:ImageButton ID="ImageNarn" runat="server" ImageUrl="~/images/addnew_1.jpg" OnClick="LinkNarn_Click" />
                        <%--                    <asp:LinkButton ID="LinkNarn" runat="server" CssClass="masterLinks" OnClick="LinkNarn_Click">Add New Narration</asp:LinkButton></div>
--%>
                    </div>
                    <div class="mastergrid">
                        <asp:GridView ID="GridView5" runat="server" AutoGenerateColumns="False" Width="100%"
                            BorderColor="#55A0FF" DataSourceID="SqlDataSource6" DataKeyNames="NarId" AllowPaging="True"
                            EmptyDataText="No records found!!!" OnPageIndexChanging="GridView5_PageIndexChanging"
                            OnRowCommand="GridView5_RowCommand" PageSize="10" OnRowCancelingEdit="GridView5_RowCancelingEdit"
                            OnRowEditing="GridView5_RowEditing" OnRowUpdating="GridView5_RowUpdating" OnRowDataBound="GridView5_RowDataBound">
                            <RowStyle Height="15px" />
                            <Columns>
                                <asp:TemplateField HeaderText="OpeId" HeaderStyle-CssClass="grdheadermster" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("NarId") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Narration Name" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Text='<%# bind("NarrationName") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:TextBox ID="TextBox3" runat="server" Height="16px" Text='<%# bind("NarrationName") %>'
                                                Width="241px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" align="center">
                                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit_sm1.jpg"
                                                ToolTip="Edit" />
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Button ID="Button2" runat="server" CommandName="update" Text="Update" />
                                            <asp:Button ID="Button3" runat="server" CommandName="cancel" Text="Cancel" />
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <div style="width: 100%" align="center">
                                            <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("NarId") %>'
                                                ImageUrl="~/images/delete1.jpg" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                                ToolTip="Delete" CommandName="delete" /></div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster" />
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="grdheadermster" />
                        </asp:GridView>
                    </div>
                    <div style="width: 100%; float: left; padding-top: 5px; padding-bottom: 10px; height: 10px;
                        padding-left: 2%; margin-top: 5px; font-weight: bold;text-align:left">
                        Notes:
                    </div>
                    <div class="reapeatItem3">
                        <div id="msghead5" runat="server" class="msgdiv" style="padding-left: 2%; float: left;
                            text-align: left; width: 100%;">
                            <span class="labelstyle" style="color: Red; font-size: smaller;">Fields marked with
                                * are required</span>
                        </div>
                        <div style="height: 25px; padding-top: 10px; float: left; text-align: left; width: 100%;">
                            <span class="labelstyle" style="font-size: 11px; font-weight: bold;">
                                Narration Master page to add / edit narrations. A narrations is associated with
                                Timesheet Input & Expenses Input</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="Div12" runat="server" class="masterdiv">
            <div style="width: 97%; float: left">
                <uc1:MessageControl ID="MessageControl7" runat="server" />
                <div id="Div13" class="seperotorrwr">
                </div>
                <div id="add_jobGrp" runat="server" class="masterdiv1" style="padding-left: 8px;">
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                            <asp:Label ID="Label13" runat="server" CssClass="labelstyle" Text="JOb Group Name"></asp:Label>
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:TextBox ID="txtjobgroup" runat="server" CssClass="txtnrml_long"></asp:TextBox>
                            <asp:Label ID="Label14" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:Button ID="btnjobgroup" runat="server" Text="Submit" OnClick="btnjobgroup_Click" />
                        </div>
                    </div>
                </div>
                <div id="searchjg" runat="server" style="float: left; text-align: right; width: 100%;
                    padding-bottom: 5px;">
                    <div style="float: right;">
                        <%-- <div style="float: left; text-align: right; width: 70%; padding-top: 5px;">--%>
                        <asp:Label ID="Label28" runat="server" Text="Search Job Group"></asp:Label>&nbsp;&nbsp;
                        <%--   </div>
                    <div style="float: right; text-align: right; width: 29%;">--%>
                        <asp:TextBox ID="txtjgsearch" runat="server" CssClass="txtnrml" Width="150px"></asp:TextBox>
                        <asp:Button ID="btnjgsearch" runat="server" CssClass="buttonstyle_search" Text="Search" OnClick="btnjgsearch_Click" />
                    </div>
                </div>
                <div style="float: left; text-align: right; width: 100%; padding-bottom: 5px; padding-top: 5px">
                    <div style="float: right;">
                        <asp:ImageButton ID="ImageJob" runat="server" ImageUrl="~/images/addnew_1.jpg" OnClick="LinkJob_Click" />
                        <%--                    <asp:LinkButton ID="LinkJob" runat="server" CssClass="masterLinks" OnClick="LinkJob_Click">Add New Job Group</asp:LinkButton></div>
--%>
                    </div>
                    <div class="mastergrid">
                        <asp:GridView ID="GridView6" runat="server" AutoGenerateColumns="False" Width="100%"
                            BorderColor="#55A0FF" DataSourceID="SqlDataSource7" DataKeyNames="JobGId" AllowPaging="True"
                            EmptyDataText="No records found!!!" OnPageIndexChanging="GridView6_PageIndexChanging"
                            OnRowCommand="GridView6_RowCommand" PageSize="10" OnRowCancelingEdit="GridView6_RowCancelingEdit"
                            OnRowEditing="GridView6_RowEditing" OnRowUpdating="GridView6_RowUpdating" OnRowDataBound="GridView6_RowDataBound">
                            <RowStyle Height="15px" />
                            <Columns>
                                <asp:TemplateField HeaderText="OpeId" HeaderStyle-CssClass="grdheadermster" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("JobGId") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Job Group Name" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Text='<%# bind("JobGroupName") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left">
                                            <asp:TextBox ID="TextBox3" runat="server" Height="16px" Text='<%# bind("JobGroupName") %>'
                                                Width="241px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" align="center">
                                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit_sm1.jpg"
                                                ToolTip="Edit" />
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Button ID="Button2" runat="server" CommandName="update" Text="Update" />
                                            <asp:Button ID="Button3" runat="server" CommandName="cancel" Text="Cancel" />
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <div style="width: 100%" align="center">
                                            <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("JobGId") %>'
                                                ImageUrl="~/images/delete1.jpg" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                                ToolTip="Delete" CommandName="delete" /></div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster" />
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="grdheadermster" />
                        </asp:GridView>
                    </div>
                    <div style="width: 100%; float: left; padding-top: 5px; padding-bottom: 10px; height: 10px;
                        padding-left: 2%; margin-top: 5px; font-weight: bold;text-align:left">
                        Notes:
                    </div>
                    <div class="reapeatItem3">
                        <div id="msghead6" runat="server" class="msgdiv" style="padding-left: 2%; float: left;
                            text-align: left; width: 100%;">
                            <span class="labelstyle" style="color: Red; font-size: smaller;">Fields marked with
                                * are required</span>
                        </div>
                        <div style="height: 25px; padding-top: 10px; float: left; text-align: left; width: 100%;">
                            <span class="labelstyle" style="font-size: 11px; font-weight: bold;">
                                Job Group Master page to add / edit job groups. A job group is associated Job Master.
                                Not Mandatory</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="Div14" runat="server" class="masterdiv">
            <div style="width: 97%; float: left">
                <uc1:MessageControl ID="MessageControl8" runat="server" />
                <div id="Div15" class="seperotorrwr">
                </div>
                <div id="add_cltGrp" runat="server" class="masterdiv1" style="padding-left: 8px;">
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                            <asp:Label ID="Label16" runat="server" CssClass="labelstyle" Text="Client Group Name"></asp:Label>
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:TextBox ID="txtclientgrp" runat="server" CssClass="txtnrml_long"></asp:TextBox>
                            <asp:Label ID="Label17" runat="server" CssClass="errlabelstyle" Text="*" ForeColor="Red"></asp:Label>
                        </div>
                    </div>
                    <div class="rowRegistration">
                        <div class="cols2RegistrationLeft">
                        </div>
                        <div class="cols2RegistrationRight">
                            <asp:Button ID="btnclientgrp" runat="server" Text="Submit" OnClick="btnclientgrp_Click" />
                        </div>
                    </div>
                </div>
                <div id="searchcg" runat="server" style="float: left; text-align: right; width: 100%;
                    padding-bottom: 5px;">
                    <div style="float: right;">
                        <%--  <div style="float: left; text-align: right; width: 70%; padding-top: 5px;">--%>
                        <asp:Label ID="Label29" runat="server" Text="Search Client Group"></asp:Label>&nbsp;&nbsp;
                        <%-- </div>
                    <div style="float: right; text-align: right; width: 29%;">--%>
                        <asp:TextBox ID="txtcgsearch" runat="server" CssClass="txtnrml" Width="150px"></asp:TextBox>
                        <asp:Button ID="btnsearchcg" runat="server" Text="Search" CssClass="buttonstyle_search" OnClick="btnsearchcg_Click" />
                    </div>
                </div>
                <div style="float: left; text-align: right; width: 100%; padding-bottom: 5px; padding-top: 5px">
                    <div style="float: right;">
                        <asp:ImageButton ID="ImageCltg" runat="server" ImageUrl="~/images/addnew_1.jpg" OnClick="LinkCltg_Click" />
                        <%--                    <asp:LinkButton ID="LinkCltg" runat="server" CssClass="masterLinks" OnClick="LinkCltg_Click">Add New Client Group</asp:LinkButton></div>
--%>
                    </div>
                    <div class="mastergrid">
                        <asp:GridView ID="GridView7" runat="server" AutoGenerateColumns="False" Width="100%"
                            BorderColor="#55A0FF" DataSourceID="SqlDataSource8" DataKeyNames="CTGId" AllowPaging="True"
                            EmptyDataText="No records found!!!" OnPageIndexChanging="GridView7_PageIndexChanging"
                            OnRowCommand="GridView7_RowCommand" PageSize="10" OnRowCancelingEdit="GridView7_RowCancelingEdit"
                            OnRowEditing="GridView7_RowEditing" OnRowUpdating="GridView7_RowUpdating" OnRowDataBound="GridView7_RowDataBound">
                            <RowStyle Height="15px" />
                            <Columns>
                                <asp:TemplateField HeaderText="OpeId" HeaderStyle-CssClass="grdheadermster" Visible="False">
                                    <ItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Label ID="lblfid" runat="server" CssClass="labelstyle" Text='<%# bind("CTGId") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Client Group Name" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:Label ID="lblfrname" runat="server" CssClass="labelstyle" Text='<%# bind("ClientGroupName") %>'></asp:Label>
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle" style="width: 450px;text-align:left" align="left">
                                            <asp:TextBox ID="TextBox3" runat="server" Height="16px" Text='<%# bind("ClientGroupName") %>'
                                                Width="241px" onkeyup="CountFrmTitle(this,70);"></asp:TextBox>
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="grdheadermster">
                                    <ItemTemplate>
                                        <div class="gridcolstyle" align="center">
                                            <asp:ImageButton ID="Button1" runat="server" CommandName="edit" ImageUrl="~/images/edit_sm1.jpg"
                                                ToolTip="Edit" />
                                        </div>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <div class="gridcolstyle">
                                            <asp:Button ID="Button2" runat="server" CommandName="update" Text="Update" />
                                            <asp:Button ID="Button3" runat="server" CommandName="cancel" Text="Cancel" />
                                        </div>
                                    </EditItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Delete">
                                    <ItemTemplate>
                                        <div style="width: 100%" align="center">
                                            <asp:ImageButton ID="btndelete" runat="server" CommandArgument='<%# bind("CTGId") %>'
                                                ImageUrl="~/images/delete1.jpg" OnClientClick="javascript : return confirm('Are you sure want to delete?');"
                                                ToolTip="Delete" CommandName="delete" /></div>
                                    </ItemTemplate>
                                    <HeaderStyle CssClass="grdheadermster" />
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle CssClass="grdheadermster" />
                        </asp:GridView>
                    </div>
                    <div style="width: 100%; float: left; padding-top: 5px; padding-bottom: 10px; height: 10px;
                        padding-left: 2%; margin-top: 5px; font-weight: bold;text-align:left">
                        Notes:
                    </div>
                    <div class="reapeatItem3">
                        <div id="msghead7" runat="server" class="msgdiv" style="padding-left: 2%; float: left;
                            text-align: left; width: 100%;">
                            <span class="labelstyle" style="color: Red; font-size: smaller;">Fields marked with
                                * are required</span>
                        </div>
                        <div style="height: 25px; padding-top: 10px; float: left; text-align: left; width: 100%;">
                            <span class="labelstyle" style="font-size: 11px; font-weight: bold;">
                                Client Group Master page to add / edit client groups. A client group is associated
                                Client Master. Not Mandatory</span>
                        </div>
                    </div>
                </div>
            </div>
            <div id="griddiv" class="totbodycatreg">
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" SelectCommand="select * from Designation_Master where CompId=@CompId order by DesignationName"
                    ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="drpcompany" Name="CompId" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server" SelectCommand="select * from Department_Master where CompId=@CompId order by DepartmentName"
                    ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="drpcompany" Name="CompId" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource3" runat="server" SelectCommand="select * from Branch_Master where CompId=@CompId order by BranchName"
                    ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="drpcompany" Name="CompId" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource4" runat="server" SelectCommand="select * from OPE_Master where CompId=@CompId order by OPEName"
                    ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="drpcompany" Name="CompId" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource5" runat="server" SelectCommand="select * from Location_Master where CompId=@CompId order by LocationName"
                    ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="drpcompany" Name="CompId" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource6" runat="server" SelectCommand="select * from Narration_Master where CompId=@CompId order by NarrationName"
                    ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="drpcompany" Name="CompId" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource7" runat="server" SelectCommand="select * from JobGroup_Master where CompId=@CompId order by JobGroupName"
                    ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="drpcompany" Name="CompId" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="SqlDataSource8" runat="server" SelectCommand="select * from ClientGroup_Master where CompId=@CompId order by ClientGroupName"
                    ConnectionString="<%$ ConnectionStrings:ConnectionString %>">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="drpcompany" Name="CompId" PropertyName="SelectedValue" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </div>
        </div>
</asp:Content>
