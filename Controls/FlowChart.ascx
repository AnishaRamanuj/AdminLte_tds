<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FlowChart.ascx.cs" Inherits="controls_FlowChart" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Src="MessageControl.ascx" TagName="MessageControl" TagPrefix="uc2" %>
<link href="../StyleCss/TimesheetInput.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="jquery/jquery-3.4.1.min.js"></script>

<script lang="javascript" type="text/javascript">
    $(document).ready(function () {
        $(document).ajaxStart(function () { $(".modalganesh").show(); }).ajaxStop(function () { $(".modalganesh").hide(); });

    });
</script>

<style type="text/css">
    .cssPageTitle {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        border-bottom: 2px solid #0b9322;
        /*padding: 7px;*/
        color: #0b9322;
    }

    .cssButton {
        cursor: pointer; /*background-image: url(../Images/ButtonBG1.png);*/
        background-color: #d3d3d3;
        border: 0px;
        padding: 4px 15px 4px 15px;
        color: Black;
        border: 1px solid #c4c5c6;
        border-radius: 3px;
        font: bold 12px verdana, arial, "Trebuchet MS", sans-serif;
        text-decoration: none;
        opacity: 0.8;
    }

        .cssButton:focus {
            background-color: #69b506;
            border: 1px solid #3f6b03;
            color: White;
            opacity: 0.8;
        }

        .cssButton:hover {
            background-color: #69b506;
            border: 1px solid #3f6b03;
            color: White;
            opacity: 0.8;
        }

    .cssPageTitle2 {
        font: bold 14px verdana, arial, "Trebuchet MS", sans-serif;
        /*border-bottom: 2px solid #0b9322;*/
        padding: 7px;
        color: #0b9322;
    }

    .stp{
        background: #F2F2F2;
        width: 200px;
        font-size: 14px;
        font-weight: bold;
        text-align-last: center;
    }

    .exp{
        font-size: 13px;
        font-style: italic;
    }
</style>

<div>
    <asp:HiddenField ID="hdnCompid" runat="server" />
    <asp:HiddenField ID="hdnstaffcode" runat="server" />
    <asp:HiddenField ID="hdnSelectedProjectid" runat="server" />
    <asp:HiddenField ID="hdnStype" runat="server" />
    <asp:HiddenField ID="hdnval" runat="server" />


    <table style="width: 100%" class="cssPageTitle">
        <tr>
            <td class="cssPageTitle2">
                <asp:Label ID="Label1" runat="server" Style="margin-left: 50px;" Text="TimeSheet FlowChart"></asp:Label>
            </td>

        </tr>
    </table>
    <div style="width: 100%;">
        <uc2:MessageControl ID="MessageControl1" runat="server" />
    </div>
    <div class="row_report" runat="server" id="divReportInput">
        <div style="padding-top: 30px;">
            <table style="border: 1px solid #CCC; margin-bottom: 0px; border-collapse: collapse; width: 1200px; padding-left: 15px; padding-right: 15px;">
                <tr>
                    <td></td>
                    <td class="stp">Step 1
                    </td>
                    <td style="padding-bottom:20px;">
                        <table>
                            <tr>
                                <td>
                                    
                                    <a href="../Company/ClientRegistration.aspx">
                                    <input type="button"  id="Btnclt" value="ADD Client" class="cssButton" />
                                        </a>
                                </td>

                            </tr>
                            <tr>
                                <td class="exp">Add New Clients.
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr></tr>
                <tr>
                    <td></td>
                    <td class="stp">Step 2
                    </td>
                    <td style="padding-bottom:20px;">
                        <table>
                            <tr>
                                <td>
                                    <a href="../Company/Add_Projects.aspx">
                                    <input type="button" id="BtnProject" value="ADD Project" class="cssButton" />
                                        </a>
                                </td>

                            </tr>
                            <tr>
                                <td class="exp">Create New Projects  & Allocate it with Clients.
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr></tr>
                <tr>
                    <td></td>
                    <td class="stp">Step 3
                    </td>
                    <td style="padding-bottom:20px;">
                        <table>
                            <tr>
                                <td>
                                    <a href="../Company/StaffRegistration.aspx">
                                        
                                    <input type="button" id="Btnstf" value="ADD Staff" class="cssButton" />
                                        </a>
                                </td>

                            </tr>
                            <tr>
                                <td class="exp">Create New Staff. Please create necessary <a href="../Company/AddRecordsDep.aspx"> Department </a>& <a href="../Company/AddRecords.aspx">Designations </a>for it. 
                                As all staff will be allocated on the basis of Department they are into. Please select the role for that staff as the role will define the staff is a User or Approver.
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr></tr>
                <tr>
                    <td></td>
                    <td class="stp">Step 4
                    </td>
                    <td style="padding-bottom:20px;">
                        <table>
                            <tr>
                                <td>
                                    <a href="../Company/AddRecordsJN.aspx">
                                    <input type="button" id="BtnAct" value="ADD Activity" class="cssButton" />
                                        </a>
                                </td>

                            </tr>
                            <tr>
                                <td class="exp">Activity is the name given to the work to be done.
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr></tr>
                <tr>
                    <td></td>
                    <td class="stp">Step 5
                    </td>
                    <td style="padding-bottom:20px;">
                        <table>
                            <tr>
                                <td>
                                    <a href="../Company/AddAssignments.aspx">
                                    <input type="button" id="BtnAssg" value="Assigning with Department" class="cssButton" />
                                        </a>
                                </td>

                            </tr>
                            <tr>
                                <td class="exp">Assigning the above activities with Department
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr></tr>
                <tr>
                    <td></td>
                    <td class="stp">Step 6(1)
                    </td>
                    <td style="padding-bottom:20px;">
                        <table>
                            <tr>
                                <td>
                                    <a href="../Company/Manage_JobAllocation.aspx">
                                    <input type="button" id="Btnalt" value="Job Allocation" class="cssButton" />
                                        </a>
                                </td>

                            </tr>
                            <tr>
                                <td class="exp">There are 2 methods of Allocating Jobs is by  Step 6(1) Job Allocation & other is Step 6(2) Staffwise Allocation.
(Allocate all Clients with Projects & Assigments which will allow automatically select  Department & Respective Staff in that Department will be selected.  After this process a User can Start entering his Timesheet.)

                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr></tr>
                <tr>
                    <td></td>
                    <td class="stp">Step 6(2)
                    </td>
                    <td style="padding-bottom:20px;">
                        <table>
                            <tr>
                                <td>
                                    <a href="../Company/StaffJobAllocation.aspx">
                                    <input type="button" id="BtnstfAlt" value="Staffwise  Allocation " class="cssButton" />
                                        </a>
                                </td>

                            </tr>
                            <tr>
                                <td class="exp">This is another way of allocation of Jobs by Staffwise also. Select the staff for which Job has to allocated. 
                                    Then selec t the Jobs from the grid and press save which will allocate the selected Jobs to the Staff.
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr></tr>
                <tr>
                    <td></td>
                    <td class="stp">Step 7
                    </td>
                    <td style="padding-bottom:20px;">
                        <table>
                            <tr>
                                <td>
                                    <a href="../Company/Rolewise_Staff_Approver_Allocation.aspx">
                                    <input type="button" id="BtnAppr" value="Approver Allocation" class="cssButton" />
                                        </a>
                                </td>

                            </tr>
                            <tr>
                                <td class="exp">Once the Job is allocated Click here for allocating Approvers for the Staff to work into. 
                                    Once the approvers are selected for the Staff then they will be responsible for approving the Users Submitted Timesheet.
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>
