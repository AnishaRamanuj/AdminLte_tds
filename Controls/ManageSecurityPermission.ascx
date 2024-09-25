<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ManageSecurityPermission.ascx.cs" Inherits="controls_ManageSecurityPermission" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register src="MessageControl.ascx" tagname="MessageControl" tagprefix="uc2" %>

<script type="text/javascript" language="javascript">
    function ValidateText(i) {
        if (i.value == 0) {
            i.value = null;
        }
        if (i.value.length > 0) {
            i.value = i.value.replace(/[^\d]+/g, '');
        }
    }
    function CountFrmTitle(field, max) {
        if (field.value.length > max) {
            field.value = field.value.substring(0, max);
            alert("You are exceding the maximum limit");

        }
        else {
            var count = max - field.value.length;
        }

    }
   
</script>
<style type="text/css">

.radio label 
{
	
	margin-right: 25px;
}

</style>
  <div id="totbdy" class="totbodycatreg">
   
     <%--   <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>--%>
        
        <uc2:MessageControl ID="MessageControl1" runat="server" />
        
 
    <%--<div id="contactdiv" class="insidetot">--%>
         <div class="headerstyle_admin">
     <div class="headerstyle1_admin">    <asp:Label ID="Label22" runat="server" CssClass="Head1" 
                    Text="Manage Security Permission"></asp:Label></div>
               
            </div> 
    <%--</div>--%>
    
    <div id="Div1" class="insidetot" style="padding-top:10px;">
        <div class="cont_fieldset_admin">         
          
            <div class="comprw_admin">
                <div class="leftrw_admin">
                    <asp:Label ID="Label1" runat="server" CssClass="labelstyle" Text="Company Name"></asp:Label>
                </div>
                <div class="rightrw_admin">
                    <asp:DropDownList ID="Drop_Company" runat="server" CssClass="dropstyle"
                        DataTextField="CompanyName" DataValueField="CompId" Width="300px" AppendDataBoundItems="true">
                        <asp:ListItem Text="-- Select --" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:Label ID="Label23" runat="server" CssClass="errlabelstyle" ForeColor="Red" 
                        Text="*"></asp:Label>
                </div>
            </div>   
            
             <div class="comprw_admin">
                <div class="leftrw_admin">
                    <asp:Label ID="Label2" runat="server" CssClass="labelstyle" Text="Scheme Purchased"></asp:Label>
                </div>
                <div class="rightrw_admin">
                    <asp:DropDownList ID="Drop_Scheme" runat="server" CssClass="dropstyle" Width="150px">
                        <asp:ListItem>Basic</asp:ListItem>
                        <asp:ListItem>Free Version</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
             <div class="comprw_admin">
                <div class="leftrw_admin">
                    <asp:Label ID="Label3" runat="server" CssClass="labelstyle" Text="No of Users allowed"></asp:Label>
                </div>
                <div class="rightrw_admin">
                   
                    <asp:TextBox ID="Text_UserCount" CssClass="numerictxtbox" runat="server" 
                        Width="70px" ></asp:TextBox>
                   
                </div>
            </div>
             <div class="comprw_admin">
                <div class="leftrw_admin">
                    <asp:Label ID="Label4" runat="server" CssClass="labelstyle" Text="No of Staff allowed"></asp:Label>
                </div>
                <div class="rightrw_admin">
                  
                    <asp:TextBox ID="Text_StaffCount" CssClass="numerictxtbox" runat="server" 
                        Width="70px"></asp:TextBox>
                  
                </div>
            </div>
             <div class="comprw_admin">
                <div class="leftrw_admin">
                    <asp:Label ID="Label5" runat="server" CssClass="labelstyle" Text="Web Storage Space"></asp:Label>
                </div>
                <div class="rightrw_admin">
                    <asp:DropDownList ID="Drop_Space" runat="server" CssClass="dropstyle" Width="150px">
                        <asp:ListItem>Unlimited</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
             <div class="comprw_admin">
                <div class="leftrw_admin">
                    <asp:Label ID="Label6" runat="server" CssClass="labelstyle" Text="No of days allowed"></asp:Label>
                </div>
                <div class="rightrw_admin">
                    <asp:DropDownList ID="Drop_Days" runat="server" CssClass="dropstyle" Width="50px">
                        <asp:ListItem>1</asp:ListItem>
                        <asp:ListItem>2</asp:ListItem>
                        <asp:ListItem>3</asp:ListItem>
                        <asp:ListItem>4</asp:ListItem>
                        <asp:ListItem>5</asp:ListItem>
                        <asp:ListItem>6</asp:ListItem>
                        <asp:ListItem>7</asp:ListItem>
                        <asp:ListItem>8</asp:ListItem>
                        <asp:ListItem>9</asp:ListItem>
                        <asp:ListItem>10</asp:ListItem>
                        <asp:ListItem>11</asp:ListItem>
                        <asp:ListItem>12</asp:ListItem>
                        <asp:ListItem>13</asp:ListItem>
                        <asp:ListItem>14</asp:ListItem>
                        <asp:ListItem>15</asp:ListItem>
                        <asp:ListItem>16</asp:ListItem>
                        <asp:ListItem>17</asp:ListItem>
                        <asp:ListItem>18</asp:ListItem>
                        <asp:ListItem>19</asp:ListItem>
                        <asp:ListItem>20</asp:ListItem>
                        <asp:ListItem>21</asp:ListItem>
                        <asp:ListItem>22</asp:ListItem>
                        <asp:ListItem>23</asp:ListItem>
                        <asp:ListItem>24</asp:ListItem>
                        <asp:ListItem>25</asp:ListItem>
                        <asp:ListItem>26</asp:ListItem>
                        <asp:ListItem>27</asp:ListItem>
                        <asp:ListItem>28</asp:ListItem>
                        <asp:ListItem>29</asp:ListItem>
                        <asp:ListItem>30</asp:ListItem>
                        <asp:ListItem>31</asp:ListItem>
                        <asp:ListItem>32</asp:ListItem>
                        <asp:ListItem>33</asp:ListItem>
                        <asp:ListItem>34</asp:ListItem>
                        <asp:ListItem>35</asp:ListItem>
                        <asp:ListItem>36</asp:ListItem>
                        <asp:ListItem>37</asp:ListItem>
                        <asp:ListItem>38</asp:ListItem>
                        <asp:ListItem>39</asp:ListItem>
                        <asp:ListItem>40</asp:ListItem>
                        <asp:ListItem>41</asp:ListItem>
                        <asp:ListItem>42</asp:ListItem>
                        <asp:ListItem>43</asp:ListItem>
                        <asp:ListItem>44</asp:ListItem>
                        <asp:ListItem>45</asp:ListItem>
                        <asp:ListItem>46</asp:ListItem>
                        <asp:ListItem>47</asp:ListItem>
                        <asp:ListItem>48</asp:ListItem>
                        <asp:ListItem>49</asp:ListItem>
                        <asp:ListItem>50</asp:ListItem>
                        <asp:ListItem>51</asp:ListItem>
                        <asp:ListItem>52</asp:ListItem>
                        <asp:ListItem>53</asp:ListItem>
                        <asp:ListItem>54</asp:ListItem>
                        <asp:ListItem>55</asp:ListItem>
                        <asp:ListItem>56</asp:ListItem>
                        <asp:ListItem>57</asp:ListItem>
                        <asp:ListItem>58</asp:ListItem>
                        <asp:ListItem>59</asp:ListItem>
                        <asp:ListItem>60</asp:ListItem>                     
                    </asp:DropDownList>
                </div>
            </div>
             <div class="comprw_admin">
                <div class="leftrw_admin">
                    <asp:Label ID="Label7" runat="server" CssClass="labelstyle" Text="Pricing"></asp:Label>
                </div>
                <div class="rightrw_admin">
                  
                    <asp:TextBox ID="Text_Pricing" CssClass="numerictxtbox" runat="server" 
                        Width="70px" ></asp:TextBox>
                  
                    <asp:Label ID="Label24" runat="server" CssClass="errlabelstyle" ForeColor="Red" 
                        Text="*"></asp:Label>
                  
                </div>
            </div>
             <div class="comprw_admin">
                <div class="leftrw_admin">
                    <asp:Label ID="Label8" runat="server" CssClass="labelstyle" Text="Version"></asp:Label>
                </div>
                <div class="rightrw_admin">
                   
                    <asp:RadioButtonList ID="Radio_Version" runat="server" CellPadding="2" 
                        CellSpacing="2" RepeatDirection="Horizontal" CssClass="radio" >
                        <asp:ListItem Selected="True"  > Hosted</asp:ListItem>
                        <asp:ListItem> Their Server</asp:ListItem>
                    </asp:RadioButtonList>
                   
                </div>
            </div>        
             <div class="comprw_admin" style="padding-top:5px;">
                <div class="leftrw_admin">
                    
                </div>
                <div class="rightrw_admin">
                   
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="buttonstyle_reg"
                        CausesValidation="False" onclick="btnSubmit_Click" />
                   
                    
                   
                </div>
            </div> 
             
        </div>
    </div>
   
    
  
        <div style="width: 96%; float: left; padding-top: 5px;padding-bottom:10px;padding-left: 24px; margin-top: 5px; font-weight: bold;">
                        Notes:
                        <asp:SqlDataSource ID="SqlCompSrc" runat="server" 
                            ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
                            SelectCommand="select CompId,CompanyName from dbo.Company_Master">
                        </asp:SqlDataSource>
                    </div>
    <div class="reapeatItem3" style="overflow:hidden;padding-left:10px;width:862px;">     
    <div id="msghead" class="totbodycatreg" style="overflow:hidden;">
    <span class="labelstyle" style="overflow:hidden;color:Red; font-size:smaller;">Fields marked with *  are required</span>        
    </div>
    <div style="overflow:hidden;height: 25px;padding-top:10px;">
        <span class="labelstyle" style="overflow:hidden;font-size:11px;font-weight:bold;">Company Master page to add / edit company</span>
       </div>
    </div>
 
    </div>
      