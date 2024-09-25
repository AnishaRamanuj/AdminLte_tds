<%@ Page Language="C#" MasterPageFile="~/Admin/AdminMaster.master"  CodeFile="Import.aspx.cs" Inherits="Admin_Import" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<table style="width: 100%">
<tr>
  <td> 
            Import Partner / Staff
  </td>
</tr>

<tr>
  <td> 
            
      <asp:FileUpload ID="Fup" runat="server" Width="500px" />
            
  </td>
</tr>

<tr>

  <td>
      <asp:DataGrid ID="Grd" runat="server" >
      </asp:DataGrid>
      
  </td>  
</tr>
<tr>
  <td> 
            
      <asp:Button ID="Button1" text="Submit" runat="server"  Width="102px" 
          onclick="Button1_Click" />
     <asp:Button ID="Button2" Text="Cancel" runat="server"  Width="102px" />             
  </td>


</tr>
</table>
</asp:Content>
