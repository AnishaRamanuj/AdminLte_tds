<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeFile="ad_staffdetails.aspx.cs" Inherits="Admin_ad_staffdetails" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="Div20" class="totbodycatreg1" style="height:auto;width:880px;padding-left:10px;">
    <asp:MultiView ID="StaffView" runat="server">
        <asp:View ID="View1" runat="server">
        <div class="headerstyle_admin">
            <div class="headerstyle1_admin"> 
           <asp:Label ID="Label1" runat="server" Text="Staff List" 
            CssClass="Head1"></asp:Label></div>
        
            </div>
  <%--  <div style="padding-bottom: 3px; width: 100%; float: left; text-align:right;">
            <a style="font-family:Arial, Helvetica, sans-serif;color:#279BC0; font-size:11px; font-weight:bold; text-decoration:none;" href="javascript: history.go(-1)">Back</a>
            </div>--%>
    <div style="padding-bottom: 10px; width: 98%; float: left;padding-top:10px;padding-left:15px;">
        <asp:SqlDataSource ID="SqlStaffSrc" runat="server" 
            ConnectionString="<%$ ConnectionStrings:ConnectionString %>" SelectCommand="select distinct s.StaffCode,row_number() over(order by s.StaffName desc)as sino,s.StaffName,s.Mobile,d.DepartmentName,dsg.DesignationName,

br.BranchName from Staff_Master as s left join  dbo.Department_Master as d on d.DepId=s.DepId 

inner join  dbo.TimeSheet_Table as t on t.StaffCode=s.StaffCode 

left join dbo.Designation_Master  as dsg on dsg.DsgId=s.DsgId left join 

dbo.Branch_Master as br on br.BrId=s.BrId where t.CLTId=@clt_id group by s.StaffCode,s.StaffName,s.StaffName,s.Mobile,d.DepartmentName,dsg.DesignationName,br.BranchName">
            <SelectParameters>
                <asp:QueryStringParameter Name="clt_id" QueryStringField="clt_id" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:GridView ID="Griddealers" runat="server" AutoGenerateColumns="False" BorderColor="#55A0FF"
            Width="100%" DataSourceID="SqlStaffSrc" DataKeyNames="StaffCode" 
               AllowPaging="True" onrowcommand="Griddealers_RowCommand" 
            EmptyDataText="No Records found!!!" >
            <RowStyle Height="15px" />
            <Columns>
                <asp:TemplateField HeaderText="jobid" Visible="False">
                    <ItemTemplate>
                        <div class="gridcolstyle" >
                            <asp:Label ID="lblfid"  runat="server" CssClass="labelstyle" Text='<%# bind("StaffName") %>'
                                ></asp:Label>
                        </div>
                    </ItemTemplate>                  
<HeaderStyle CssClass="grdheadermster"></HeaderStyle>                    
                </asp:TemplateField>
                <asp:TemplateField HeaderText="SINo">                  
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:20px;text-align:center">
                            <asp:Label ID="Label2" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("sino") %>'></asp:Label>
                        </div>
                    </ItemTemplate>  
<HeaderStyle CssClass="grdheadermster"></HeaderStyle>    
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Staff Name" 
                    >
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:150px;">
                            <asp:LinkButton ID="lblfrname" runat="server" CssClass="grdLinks" Text='<%# bind("StaffName") %>' CommandName="job"
                               ></asp:LinkButton>
                        </div>
                    </ItemTemplate>        
                     <ItemStyle CssClass="griditemstlert1" />          
<HeaderStyle CssClass="grdheadermster"></HeaderStyle>                     
                </asp:TemplateField>
                  <asp:TemplateField HeaderText="Department" 
                   >
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:100px;">
                            <asp:Label ID="lbldepname" runat="server" CssClass="labelstyle" Text='<%# bind("DepartmentName") %>'
                               ></asp:Label>
                        </div>
                    </ItemTemplate> 
                     <ItemStyle CssClass="griditemstlert1" />                 
<HeaderStyle CssClass="grdheadermster"></HeaderStyle>                   
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Designation">
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:100px;">
                            <asp:Label ID="Label3" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("DesignationName") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                     <ItemStyle CssClass="griditemstlert1" />
                    <HeaderStyle CssClass="grdheadermster"></HeaderStyle>    
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Branch">
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:100px;">
                            <asp:Label ID="lblpassword" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("BranchName") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                     <ItemStyle CssClass="griditemstlert1" />
                   <HeaderStyle CssClass="grdheadermster"></HeaderStyle>    
                </asp:TemplateField>
                  <asp:TemplateField HeaderText=" Mobile">
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:70px;">
                            <asp:Label ID="Label6" runat="server" CssClass="labelstyle" 
                                Text='<%# bind("Mobile") %>'></asp:Label>
                        </div>
                    </ItemTemplate>
                    <ItemStyle Width="90px" />
                     <ItemStyle CssClass="griditemstlert1" />
                       <HeaderStyle CssClass="grdheadermster"></HeaderStyle> 
                </asp:TemplateField> 
                <asp:TemplateField HeaderText=" Profile">
                    <ItemTemplate>
                        <div class="gridcolstyle" style="width:50px;">
                            <asp:LinkButton ID="lnkview" CssClass="grdLinks" 
                                CommandArgument='<%# bind("StaffCode") %>' runat="server" 
                                onclick="lnkview_Click">View</asp:LinkButton>
                        </div>
                    </ItemTemplate>
                     <ItemStyle CssClass="griditemstlert1" />
                     <ItemStyle Width="70px" />
                       <HeaderStyle CssClass="grdheadermster"></HeaderStyle> 
                </asp:TemplateField>            
            </Columns>
           <HeaderStyle CssClass="grdheadermster"></HeaderStyle>    
        </asp:GridView>
       
        </div>
        </asp:View>
        <asp:View ID="View2" runat="server">
        <div style="width:100%">
        <div id="totbdy" class="totbodycatreg">
   
     <div class="headerstyle_admin">
            <div class="headerstyle1_admin">
        <asp:Label ID="Label22" runat="server" CssClass="Head1" 
            Text="Staff Profile"></asp:Label>
       
        </div></div>
        <%--<div style="padding-bottom: 3px; width: 100%; float: left; text-align:right;">
            <a style="width:95%; font-family:Arial, Helvetica, sans-serif;color:#279BC0; font-size:11px; font-weight:bold; text-decoration:none;" href="javascript: history.go(-1)">Back</a>
            </div>--%>
    
     <div id="Div81" class="seperotorrwr">
        </div>
     <div id="contactdiv" class="insidetot" style="padding-left: 15px">
    <div class="cont_fieldset" style="padding-left:15px;margin-left:0px">
  
    <div id="Div77" class="seperotorrwr"></div>
    <div id="insidrw1" class="comprw">       
    
    <div id="insideleft1" class="leftrw_left">
        <asp:Label ID="Label5" runat="server" CssClass="labelstyle" 
            Text="Staff Name"></asp:Label>
        </div>
    <div id="insideright1" class="rightrw">
        :&nbsp<asp:Label ID="Labelcompname" runat="server" CssClass="labelstyle" Text=""></asp:Label>
        </div>
    </div>
    <div id="Div2" class="comprw">
    <div id="Div3" class="leftrw_left">
        <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text="Address1"></asp:Label>
        </div>
    <div id="Div4" class="rightrw">
        :&nbsp<asp:Label ID="Labeladdr1" runat="server" CssClass="labelstyle" Text=""></asp:Label>
        </div>
    </div>
    <div id="Div5" class="comprw">
    <div id="Div6" class="leftrw_left">
        <asp:Label ID="Label3" runat="server"  CssClass="labelstyle" 
            Text="Address2"></asp:Label>
        </div>
    <div id="Div7" class="rightrw">
        :&nbsp<asp:Label ID="Labeladdr2" runat="server" CssClass="labelstyle" Text=""></asp:Label>
        </div>
    </div>
     <div id="Div78" class="comprw">
    <div id="Div96" class="leftrw_left">
        <asp:Label ID="Label38" runat="server" CssClass="labelstyle" Text="Address3"></asp:Label>
        </div>
    <div id="Div97" class="rightrw">
        :&nbsp<asp:Label ID="Labeladdr3" runat="server" CssClass="labelstyle" Text=""></asp:Label>
        </div>
    </div>
     <div id="Div98" class="comprw">
    <div id="Div99" class="leftrw_left">
        <asp:Label ID="Label42" runat="server" CssClass="labelstyle" Text="City"></asp:Label>
        </div>
    <div id="Div100" class="rightrw">
        :&nbsp<asp:Label ID="Labelcity" runat="server" CssClass="labelstyle" Text=""></asp:Label>
        </div>
    </div>  
    <div id="Div8" class="comprw">
    <div id="Div9" class="leftrw_left">
        <asp:Label ID="Label4" runat="server" CssClass="labelstyle" Text="Email"></asp:Label>
        </div>
    <div id="Div10" class="rightrw">
        :&nbsp<asp:Label ID="labelemail" runat="server" CssClass="labelstyle" Text=""></asp:Label>
        </div>
    </div>   
    <div id="Div1" class="comprw">
    <div id="Div75" class="leftrw_left">
        <asp:Label ID="Label32" runat="server" CssClass="labelstyle" Text="Phone"></asp:Label>
        </div>
    <div id="Div76" class="rightrw">
        :&nbsp<asp:Label ID="Labelphn" runat="server" CssClass="labelstyle" Text=""></asp:Label>
        </div>
    </div>
    <div id="Div37" class="comprw">
                        <div id="Div38" class="leftrw_left">
                         <asp:Label ID="Label8" runat="server" CssClass="labelstyle" Text="Department"></asp:Label>
                        </div>
                        <div id="Div40" class="rightrw">
                          :<asp:Label ID="lbldep" runat="server" CssClass="labelstyle" 
                                Text=""></asp:Label>
                        </div>
                    </div>
                      <div id="Div41" class="comprw">
                        <div id="Div21" class="leftrw_left">
                         <asp:Label ID="Label12" runat="server" CssClass="labelstyle" Text="Designation"></asp:Label>
                        </div>
                        <div id="Div23" class="rightrw">
                          :<asp:Label ID="lbldesg" runat="server" CssClass="labelstyle" 
                                Text=""></asp:Label>
                        </div>
                    </div>
                      <div id="Div45" class="comprw">
                        <div id="Div46" class="leftrw_left">
                         <asp:Label ID="Label13" runat="server" CssClass="labelstyle" Text="Branch"></asp:Label>
                        </div>
                        <div id="Div48" class="rightrw">
                          :<asp:Label ID="lblbr" runat="server" CssClass="labelstyle" 
                                Text=""></asp:Label>
                        </div>
                    </div>
    <div id="Div29" class="comprw">
    <div id="Div30" class="leftrw_left">
        <asp:Label ID="Label10" runat="server" CssClass="labelstyle" 
            Text="Hourly Charges"></asp:Label>
        </div>
    <div id="Div31" class="rightrw">
        :&nbsp<asp:Label ID="Labelcharge" runat="server" CssClass="labelstyle" Text=""></asp:Label>
        </div>
        
    </div>
    <div id="Div11" class="comprw">
    <div id="Div12" class="leftrw_left">
        <asp:Label ID="Label7" runat="server" CssClass="labelstyle" 
            Text="Salary"></asp:Label>
        </div>
    <div id="Div13" class="rightrw">
        :&nbsp<asp:Label ID="Labelsal" runat="server" CssClass="labelstyle" Text=""></asp:Label>
        </div>
        
    </div>
    <div id="Div14" class="comprw">
    <div id="Div15" class="leftrw_left">
        <asp:Label ID="Label9" runat="server" CssClass="labelstyle" 
            Text="Date Of Joining"></asp:Label>
        </div>
    <div id="Div16" class="rightrw">
        :&nbsp<asp:Label ID="labeljoin" runat="server" CssClass="labelstyle" Text=""></asp:Label>
        </div>
        
    </div>
    <div id="Div17" class="comprw">
    <div id="Div18" class="leftrw_left">
        <asp:Label ID="Label11" runat="server" CssClass="labelstyle" 
            Text="Date Of Leaving"></asp:Label>
        </div>
    <div id="Div19" class="rightrw">
        :&nbsp<asp:Label ID="Labelend" runat="server" CssClass="labelstyle" Text=""></asp:Label>
        </div>
        
    </div>
    <div id="Div44" class="seperotorrwr"></div>
    </div>
    </div>
    </div>
        </div>
        </asp:View>
    </asp:MultiView>
   </div>
</asp:Content>

