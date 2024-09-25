<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MessageControl.ascx.cs"
    Inherits="controls_MessageControl" %>
<style type="text/css">
    .info, .success, .warning, .validation
    {
        border: 1px solid;
        margin: 10px 0px;
        padding: 15px 10px 15px 50px;
        background-repeat: no-repeat;
        background-position: 10px center;
    }
    .info
    {
        color: #00529B;
        background-color: #BDE5F8;
        background-image: url('<%= ResolveClientUrl("~/images/KnobInfo.png") %>');
    }
   .error
    {
        color: white;
        background-color: red;
        background-image: url('<%= ResolveClientUrl("~/images/KnobInfo.png") %>');
    }
    .success
    {
        color: #4F8A10;
        background-color: #DFF2BF;
        background-image: url('<%= ResolveClientUrl("~/images/KnobValidGreen.png") %>');
    }
    .warning
    {
        color: #9F6000;
        background-color: #FEEFB3;
        background-image: url('<%= ResolveClientUrl("~/images/KnobAttention.png") %>');
    }
 
</style>

<script type="text/javascript">
//    window.onload = function() {
//        disappearControl('<%= msgBx.ClientID %>');
//    }

    function disappearControl(elementid) {        
        this.opacity = 0;
        this.height = 0;

        var fileProgressWrapper = document.getElementById(elementid);        
        if (fileProgressWrapper != null) {
            if (trim(fileProgressWrapper.innerHTML).length > 1) {
                this.opacity = 100;
                this.height = 25;
                fileProgressWrapper.style.display = 'block';
            }
            else fileProgressWrapper.style.display = 'none';
            setTimeout("disappear('" + elementid + "')", 5000);
        }
    }

    // Fades out and clips away the FileProgress box.
    function disappear(elementid) {

        var reduceOpacityBy = 15;
        var reduceHeightBy = 4;
        var rate = 30; // 15 fps

        var fileProgressWrapper = document.getElementById(elementid);
        //alert(elementid);

        if (this.opacity > 0) {
            this.opacity -= reduceOpacityBy;
            if (this.opacity < 0) {
                this.opacity = 0;
            }

            if (fileProgressWrapper.filters) {
                try {
                    fileProgressWrapper.filters.item("DXImageTransform.Microsoft.Alpha").opacity = this.opacity;
                } catch (e) {
                    // If it is not set initially, the browser will throw an error.  This will set it if it is not set yet.
                    fileProgressWrapper.style.filter = "progid:DXImageTransform.Microsoft.Alpha(opacity=" + this.opacity + ")";
                }
            } else {
                fileProgressWrapper.style.opacity = this.opacity / 100;
            }
        }

        if (this.height > 0) {
            this.height -= reduceHeightBy;
            if (this.height < 0) {
                this.height = 0;
            }

            fileProgressWrapper.style.height = this.height + "px";
            fileProgressWrapper.style.paddingTop = "0px";
            fileProgressWrapper.style.paddingBottom = "0px";
        }

        if (this.height > 0 || this.opacity > 0) {
            setTimeout("disappear('" + elementid + "')", rate);
        } else {
            fileProgressWrapper.style.display = "none";
        }
    }

    /**
    *
    *  Javascript trim, ltrim, rtrim
    *  http://www.webtoolkit.info/
    *
    **/

    function trim(str, chars) {
        return ltrim(rtrim(str, chars), chars);
    }

    function ltrim(str, chars) {
        chars = chars || "\\s";
        return str.replace(new RegExp("^[" + chars + "]+", "g"), "");
    }

    function rtrim(str, chars) {
        chars = chars || "\\s";
        return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
    }
</script>

<asp:Label ID="Label1" runat="server" Visible="False" ForeColor="Red">Message Control</asp:Label>
<div id="msgBx" runat="server">
</div>
