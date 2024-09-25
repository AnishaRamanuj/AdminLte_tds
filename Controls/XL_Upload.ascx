<%@ Control Language="C#" AutoEventWireup="true" CodeFile="XL_Upload.ascx.cs" Inherits="controls_XL_Upload" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1"  %>
<%@ Register src="MessageControl.ascx" tagname="MessageControl" tagprefix="uc1" %>

<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<%--<script language="javascript" type="text/javascript">{
   
    $(document).ready(function () {

        $("[id*=BtnUpload]").live('click', function () {
            Fill_Table();
        });

    });

    function Fill_Table() {
        $.ajax({
            type: "POST",
            url: "XL_Upload.ascx.cs/Fillthetable",
            data: '{}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: OnSuccess,
            failure: function (response) {
                alert('Cant Connect to Server' + response.d);
            },
            error: function (response) {
                alert('Error Occoured ' + response.d);
            }
        });
    }

    function OnSuccess(responce) {
        var xmlDoc = $.parseXML(responce.d);
        var xml = $(xmlDoc);
        var tbl = '';
        var customers = xml.find("Table");
    }

}
    </script>
<style type="text/css">

    </style>
<div class="divstyle">
            <div class="headerpage">
            <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
                <asp:Label ID="Label22" runat="server" CssClass="Head1 labelChange" Text="Excel Import"></asp:Label>
            </div>
        </div>
<%--      <form>--%>
    <asp:FileUpload ID="FileUpload1" runat="server" />
<asp:Button ID="BtnUpload" Text="Upload"  runat="server"  />
<%--</form>--%>
    <div class="tbssystem">
                <cc1:TabContainer ID="TabContainer1" runat="server" Height="300px" CssClass="property_tab"
                    TabIndex="1" Width="200%" AutoPostBack="false" ActiveTabIndex="0">
                    
                    <cc1:TabPanel ID="TabPanel1" runat="server" HeaderText="JobName" ForeColor="Black">

                        <ContentTemplate>
                            <div>
                                <table id="tblJobName"><tr>
                                    <td>

                                    </td>
                                       </tr></table>
                            </div>
                        </ContentTemplate>
                    </cc1:TabPanel>
                    <cc1:TabPanel ID="TabPanel2" runat="server" HeaderText="Assignments" ForeColor="Black">
                        <HeaderTemplate>
                            <asp:Label ID="assign" runat="server" Text="Assignments"></asp:Label>
                        </HeaderTemplate>
                        <ContentTemplate>
                            <div>
                                <table id="Assignments">

                                </table>
                            </div>
                        </ContentTemplate>
                    </cc1:TabPanel>
                </cc1:TabContainer>
            </div>

 </div>
<asp:HiddenField ID="hdnCompid" runat="server" />--%>