<%@ Control Language="C#" AutoEventWireup="true" CodeFile="StaffAttendance.ascx.cs" Inherits="controls_StaffAttendance" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>



<script src="../js/jquery.min.js" type="text/javascript"></script>
<script type="text/javascript" src="../jquery/moment.js"></script>
<script src="../jquery/Selectize/selectize.js" type="text/javascript"></script>
<script src="../jquery/Selectize/es5.js" type="text/javascript"></script>
<script src="../jquery/Selectize/index.js" type="text/javascript"></script>
<link href="../jquery/Selectize/normalize.css" rel="stylesheet" type="text/css" />

<script src="../js/bootstrap.bundle.min.js" type="text/javascript"></script>
<script src="../js/blockui.min.js" type="text/javascript"></script>
<script src="../js/ripple.min.js" type="text/javascript"></script>
<script src="../js/jgrowl.min.js" type="text/javascript"></script>
<script src="../js/pnotify.min.js" type="text/javascript"></script>
<script src="../js/noty.min.js" type="text/javascript"></script>
<script src="../js/pdfmake.min.js" type="text/javascript"></script>
<script src="../js/vfs_fonts.min.js" type="text/javascript"></script>
<script src="../js/form_select2.js" type="text/javascript"></script>

<script type="text/javascript" src="../jquery/moment.js"></script>

<script src="../js/interactions.min.js" type="text/javascript"></script>
<script src="../js/datatables.min.js" type="text/javascript"></script>
<script src="../js/switch.min.js" type="text/javascript"></script>
<script src="../js/uniform.min.js" type="text/javascript"></script>
<script src="../js/app.js" type="text/javascript"></script>
<script src="../js/select2.min.js" type="text/javascript"></script>
<script src="../js/datatables_basic.js" type="text/javascript"></script>

<script src="../js/components_modals.js" type="text/javascript"></script>
<script src="../js/echarts.min.js" type="text/javascript"></script>
<script src="../js/PopupAlert.js" type="text/javascript"></script>
<script src="../js/Ajax_Pager.min.js" type="text/javascript"></script>

<script language="javascript" type="text/javascript">
    $(document).ready(function () {
        $('.sidebar-main-toggle').click();
        var a = new Date();
        var dt = moment(a).format('YYYY-MM')
        $("[id*=dtmonth]").val(dt);
        $("[id*=hdnmonth]").val(dt);

        $("[id*=dtmonth]").on("change", function () {
            $("[id*=hdnmonth]").val($("[id*=dtmonth]").val());
         
        });

    });
    
    function pad2(number) {
        return (number < 10 ? '0' : '') + number
    }

</script>
<asp:HiddenField ID="hdnmonth" runat="server" />

<div id="ctl00_ContentPlaceHolder1_StaffAttendance1_MessageControl1_msgBx" style="display: none;">
</div>
 <div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>				
						
</div>
        <div class="page-header " style="height: 50px;">
            <div class="page-header-content header-elements-md-inline" style="padding-top: -13px; padding-left: 1rem;">
                <div class="page-title d-flex" style="padding-top: 0px; padding-bottom: 0px;">

                    <h5><i class="icon-arrow-left52 mr-2"></i><span class="font-weight-bold">Staff Attendance</span></h5>
                    <a href="#" class="header-elements-toggle text-default d-md-none"><i class="icon-more"></i></a>
                </div>


            </div>
        </div>
        <uc1:MessageControl ID="MessageControl1" runat="server" />
        <div class="content">
            <div class="card">
                <div class="datatable-header">
                    <div class="form-group row">
                    <div class="col-lg-2">
                        <label  class="col-lg-10 col-form-label font-weight-bold">Select Month :</label></div>
                    <div class="col-2">

                         <input type="month" style="width:125px;" class="form-control" id="dtmonth" name="dtmonth" />
                    </div>

                    <div class="header-elements">
                        <div class="list-icons">
                         
                            <button type="submit" name="ctl00$ContentPlaceHolder1$StaffAttendance1$btngen" value="Generate Report" id="ctl00_ContentPlaceHolder1_StaffAttendance1_btngen" class="btn btn-outline-success legitRipple">
                              <i class="mi-library-books mr-2 fa-1x"></i>Generate Report
                            </button>
                        </div>
                    </div>
                </div>
                </div>
                
            </div>
        </div>




