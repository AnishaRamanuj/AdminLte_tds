<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ManageTask.ascx.cs" Inherits="controls_ManageTask" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<script src="../jquery/jquery-1.8.2.min.js" type="text/javascript"></script>
<script src="../jquery/Ajax_Pager.min.js" type="text/javascript"></script>

<script type="text/javascript" language="javascript">

    $(document).ready(function () {
        $("[id*= divJb]").hide();
        $("[id*=hdnPages]").val(1);
        getTask(1, 25);


        $("[id*=btnadd]").live('click', function () {
            $("[id*=txttask]").val('');
            $("[id*=hdnTkid]").val(0);
            if ($("[id*=hdnlink]").val() == "1") {

                getProject(0);
            }

        });

        $("[id*=btnsrch]").live('click', function () {

            getTask(1, 25);

        });

        $("[id*= btnAddtask]").on('click', function () {
            var jid = "";
            var tid = 0;
         //   var hdnAllstf = "0";
            $("input[name=chkjb]").each(function () {
                var chks = $(this).is(':checked');
                var row = $(this).closest("tr");
                if (chks) {
                    var expdate = row.find("input[name=dtfrdate_]").val();
                    if (expdate == "") {
                        alert("Kindly Select the Date!!!");
                        return false;
                    } else {
                        jid = $(this).val() + ',' + expdate + '^' + jid;
                    }
                }
            });
            if ($("[id*=hdnTkid]").val() != '') {
                tid = $("[id*=hdnTkid]").val();
            }

            if (jid != "") {
                $("[id*=hdntid_all]").val(jid);
            }

            if ($("[id*=txttask]").val() != '') {
                var t = $("[id*=txttask]").val();
                if (jid != '') {
                    Save_Task(jid, t, tid);
                } else {
                    return false;
                }
            }

        });



    });

//////////hide modalpopup
    function HideModalPopup() {
        $find("programmaticModalPopupOrginalBehavior").hide();
        return false;
    }
    ///// show modalpopup
    function ShowModalPopup() {

        $find("programmaticModalPopupOrginalBehavior").show();
        return false;
    }

    function getTask(pageIndex, pageNewSize) {
        $('.loader').show();
        var compid = $("[id*=hdnCompanyid]").val();
        var l = $("[id*=hdnlink]").val();
        var t = $("[id*=drpSrch]").val();
        var s = $("[id*=txtsearch]").val();
        var data = {
            currobj: {
                CompId: compid,
                pageIndex: pageIndex,
                pageNewSize: pageNewSize,
                Link_JobnTask: l,
                jStatus: t,
                messg: s
            }
        };
        try {
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobName.asmx/bind_Task",
                data: JSON.stringify(data),
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tr='';
                    $("[id*=tblTsk]").empty();
                    if (myList.length > 0) {
                        var tbl = '';
                        tbl = tbl + "<tr>";

                        tbl = tbl + "<th>Sr.</th>";
                        tbl = tbl + "<th>Task</th>";
                        if (l == '1') {
                            
                            tbl = tbl + "<th>Projectname</th>";
                            tbl = tbl + "<th>De-Activation Date</th>";
                        }
                        tbl = tbl + "<th>Edit</th>";
                        tbl = tbl + "<th>Delete</th></tr>";
                        $("[id*=tblTsk]").append(tbl);

                        for (var i = 0; i < myList.length; i++) {
                            tr = '<tr><td style="text-align: center;">' + parseFloat(i + 1) + '</td>';
                            tr = tr + '<td>' + myList[i].Task_name + '<input type="hidden" id="hdnTskid" name="hdnTskid" value=' + myList[i].Task_Id + '></td>';
                            if (l == '1') {
                                
                                tr = tr + '<td>' + myList[i].ProjectName + '</td>';
                                tr = tr + '<td style="width:100px;">' + myList[i].expdate + '</td>';

                            }
                            tr = tr + '<td style="width:100px;text-align: center;"><img id="btnEdit" src="../images/edit.png" onclick="ShowEdit($(this))"/></td>';
                            tr = tr + '<td style="width:100px;text-align: center;"><img id="btnDel" src="../images/Delete.png" onclick="ShowDelete($(this))"/></td>';
                            tr = tr + '</tr>';
                            $('#tblTsk').append(tr);
                        }
                        $('.loader').hide();
                        var RecordCount = parseFloat(myList[0].TotalCount);
                        Pager(RecordCount);
                    }
                },
                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
        } catch (e) {
            alert(e.get_Description());
        }
    }

    function Pager(RecordCount) {
        $(".Pager").ASPSnippets_Pager({
            ActiveCssClass: "current",
            PagerCssClass: "pager",
            PageIndex: parseInt($("[id*=hdnPages]").val()),
            PageSize: parseInt(25),
            RecordCount: parseInt(RecordCount)
        });

        ////pagging changed bind LeaveMater with new page index
        $(".Pager .page").on("click", function () {
            $("[id*=hdnPages]").val($(this).attr('page'));

            getTask(($(this).attr('page')), 25);
        });
    }
    function getProject(tskid) {
        $('.loader').show();
        var compid = $("[id*=hdnCompanyid]").val();
        try {
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobName.asmx/bind_Task_Project",
                data: "{compid:'" + compid + "', tskid:'" + tskid + "'}",
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var tr = "", trd = "", Head = "<tr><td style='font-weight: bold;'>Project Name</td><td style='font-weight: bold; width:150px; padding-left: 300px;'>De-Activation Date</td></tr>";
                    var vadfds = "";
                    $("[id*=tblJb] tbody").remove();
                    $("[id*= divJb]").show();
                    $('#tblJb').append(Head);
                    for (var i = 0; i < myList.length; i++) {
                        vadfds = "";
                        if (parseFloat(myList[i].ischecked) > 0) {
                            vadfds = 'checked';
                        }
                        tr = "<tr><td style='width:600px;'><input type='hidden' name='hdnpid' value='" + myList[i].Projectid + "'><input type='checkbox' id='chkjb' name='chkjb' value='" + myList[i].Projectid + "'" + vadfds + " />" + myList[i].ProjectName + "</td>";
                        trd = "<td style='width:150px; padding-left: 300px;'><input type='Date' style='width: 130px;' id='dtfrdate_' name='dtfrdate_' value='"+ myList[i].expdate +"'></td></tr>";
                        tr = tr + trd;
                        $('#tblJb').append(tr);
                    }
                    $('#tblJb').append(tr);
                    $('.loader').hide();
                },
                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
        } catch (e) {
            alert(e.get_Description());
        }
    }

    function ShowEdit(i) {
        var row = i.closest("tr");
        var tskid = row.find("input[name=hdnTskid]").val();
        var tname = row.find('td:eq(1)').text();
        
        $("[id*=hdnTkid]").val(tskid);

        $("[id*=txttask]").val(tname);
        var l = $("[id*=hdnlink]").val();
        if (l == "1") {
            getProject(tskid);
        }
        ShowModalPopup();
    }

    function Save_Task(jid, t, tid) {
        var compid = $("[id*=hdnCompanyid]").val();
        var tid = parseFloat($("[id*=hdnTkid]").val());
        var data = {
            currobj: {
                CompId: compid,
                projectName: jid,
                Task_Id: tid,
                Task_name: t
            }
        };
        try {
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobName.asmx/Task_Save",
                data: JSON.stringify(data),
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var j = myList[0].Task_Id;
                    if (parseFloat(j) > 0) {
                        alert("Record Saved successfully");
                        HideModalPopup();
                        getTask(1, 25);
                    }
                    else if (parseFloat(j) == 0) {
                        alert("Task Name is already exists !!!");
                    }
                    else {
                        //alert("Cannot  Saved, Transaction exist");
                        HideModalPopup();
                        getTask(1, 25);
                    }
                },
                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
        } catch (e) {
            alert(e.get_Description());
        }
    }

    function ShowDelete(i) {
        var row = i.closest("tr");
        var tskid = row.find("input[name=hdnTskid]").val();
        var compid = $("[id*=hdnCompanyid]").val();
        var data = {
            currobj: {
                CompId: compid,
                Task_Id: tskid
            }
        };

        try {
            var calala = $.ajax({
                type: "POST",
                url: "../Handler/wsJobName.asmx/Delete_Task",
                data: JSON.stringify(data),
                dataType: 'json',
                contentType: "application/json",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    var j = myList[0].Task_Id;
                    if (parseFloat(j) > 0) {
                        alert("Record deleted successfully");
                        getTask(1, 25);
                    }
                    else {
                        alert("Cannot delete, Transaction exist");
                    }
                },
                failure: function (response) {
                    alert('Cant Connect to Server' + response.d);
                },
                error: function (response) {
                    alert('Error Occoured ' + response.d);
                }
            });
        } catch (e) {
            alert(e.get_Description());
        }
    }

</script>
<%--////pager classes--%>
 <style type="text/css">
    .Pager b
    {
        margin-top: 2px;
        margin-right:10px;
        float: left;
    }
    .Pager span
    {
        text-align: center;
        display: inline-block;
        width: 20px;
        margin-right: 3px;
        margin-left:5px;
        line-height: 150%;
        border: 1px solid #BCBCBC;
    }
    .Pager a
    {
        text-align: center;
        display: inline-block;
        width: 20px;
        background-color: #BCBCBC;
        color: #fff;
        border: 1px solid #BCBCBC;
        margin-right: 3px;
        line-height: 150%;
        text-decoration: none;
    }
     .lbl {
         padding-left:580px;
     }
</style>

    <div class="headerstyle1_page" style="padding-left:10px; margin-top:10px;">
        <asp:Label ID="Label18" runat="server" CssClass="Head1 labelChange" Text="Manage Tasks"></asp:Label>
    </div>
         <br />
    <div style="width: 100%">
        <uc1:MessageControl ID="MessageControl2" runat="server" />
    </div>

    <asp:HiddenField ID="hdntaskid" runat="server" Value="0" />
    <asp:HiddenField ID="hidpermission" runat="server" />
    <asp:HiddenField ID="hdnCompanyid" runat="server" />
    <asp:HiddenField ID="hdntid_all" runat="server" Value="0" />
    <asp:HiddenField ID="hdnlink" runat="server" />
    <asp:HiddenField ID="hdnPages" runat="server" />
    <asp:HiddenField ID="hdnpageIndex" runat="server" />
<%--/////pageload controlls and grid--%>

    <div id="taskSearchAdd" class="seperotorrwr" runat="server" style="padding:5px; float:left; width:100% " >
    <div class="serachJob" style="float: left; width: 100%; margin:10px; padding-bottom: 5px; overflow: auto;">
    <table>
        <tr style="font-weight:bold">
            <td>
                <asp:DropDownList ID="drpSrch" runat="server" CssClass="DropDown" >
                    <asp:ListItem Value="Task" Text="Task"></asp:ListItem>
                    <asp:ListItem Value="Projectname" Text="Project"></asp:ListItem>
                </asp:DropDownList>            
            </td>
            <td > Search </td>
            <td>:</td>
            <td>
                <asp:TextBox ID="txtsearch" runat="server" CssClass="txtbox" Font-Names="Verdana" Font-Size="8pt" Width="250px" onkeydown = "return (event.keyCode!=13);"></asp:TextBox>
            </td>
             <td>
                <input ID="btnsrch" runat="server" class="TbleBtns TbleBtnsPading" type="button" 
                     value="Search" />
            </td>
            <td>
                <asp:Button ID="btnadd" runat="server" OnClientClick=" return ShowModalPopup(0)" Text="Add Task" CssClass="TbleBtns TbleBtnsPading" />
            </td>
        </tr>
    </table>
    </div>
    <div style="padding:15px 0 0 0">
        <table id="tblTsk" width="1175px" border="1px" class="norecordTble" style="border-collapse: collapse;">
        </table>
        <table id="tblPager" style="border: 1px solid #BCBCBC; border-bottom: none; background-color: rgba(219,219,219,0.54); text-align: right;" cellpadding="2" cellspacing="0"  width="1175px">
            <tr>
                <td>
                    <div class="Pager">
                    </div>
                </td>
            </tr>
        </table>
    </div>
    </div>

    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true"
            ShowSummary="false" ValidationGroup="taskgroup" />
               <asp:Button Style="display: none" ID="hideModalPopupViaClientOrginal2" runat="server">
    </asp:Button><br />
    <cc1:ModalPopupExtender BackgroundCssClass="modalBackground" BehaviorID="programmaticModalPopupOrginalBehavior"
        RepositionMode="RepositionOnWindowScroll" DropShadow="False" ID="ModalPopupExtender2"
        TargetControlID="hideModalPopupViaClientOrginal2" CancelControlID="imgBudgetdClose"
        PopupControlID="panel10" runat="server">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="panel10" runat="server" Width="800px" BackColor="#FFFFFF">
      <div id="Div1" style="width: 100%; float: left; background-color: #55A0FF; color: #ffffff;
            font-weight: bold;">
            <div id="Div2" style="width: 90%; float: left; height: 20px; padding-left: 2%; padding-top: 1%">
                <asp:Label ID="lblpopup" runat="server" CssClass="subHead1" Text="Add Task"></asp:Label>
            </div>
            <div id="Div3" class="ModalCloseButton">
                <img alt="" src="../images/error.png" id="imgBudgetdClose" border="0" name="imgClose"
                    onclick="return HideModalPopup()" />
            </div>
        </div>
        <div style="padding:5px 5px 5px 5px" id="addtasks" runat="server" class="comprw">
                    <asp:HiddenField ID="hdnTkid" runat="server" />
         <table cellspacing="2" cellpadding="2" style="font-weight: bold">
           <tr style="padding-bottom: 10px">
            <td>
            </td>
          </tr>
          <tr>
            <td style="font-weight:bold">
            Task Name :
            </td>
       
            <td style="float:left">
            <asp:TextBox runat="server" ID="txttask" CssClass="texboxcls" Font-Names="Verdana" Font-Size="8pt" Width="250px"></asp:TextBox>
            <span style="color:Red">*</span>
            </td>
            <td>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ErrorMessage="Please Enter Task Name" ControlToValidate="txttask" 
                    ValidationGroup="taskgroup" Display="None"></asp:RequiredFieldValidator>
              </td>
        </tr>
          <tr style="padding-bottom: 10px">
            <td>
            </td>
            <td>
            </td>
            <td>
            </td>
          </tr>
        </table>
        <div id="divJb" class="divedBlock">
            <div style="overflow: hidden; width:115px;"> 
                    
                <%--<asp:Label ID="Label3" runat="server" Text="Project" CssClass="LabelFontStyle labelChange" ></asp:Label>--%>
               
            </div>     
            <div style="overflow: hidden; width:790px; height:300px; float: left; padding-left: 5px;">
              <asp:Panel ID="pnljb" runat="server" ScrollBars="Vertical" Height="280px" Width ="780px" >
                    <table id="tblJb" >
                    </table> 
              </asp:Panel>
            </div>   
        </div> 
         <div>
         <table><tr><td>
            <input ID="btnAddtask" value="Save" runat="server" class="TbleBtns" Width="25%" type="button" />
            </td><td>
            <asp:Button ID="btncancel" Text="Cancel" runat="server" Width="25%" CssClass="TbleBtns"  OnClientClick="return HideModalPopup()" />
       </td></tr></table>
        </div> 

        </div>
    </asp:Panel>




  
   
