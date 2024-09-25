<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PayslipTemplate1.ascx.cs" Inherits="controls_PayslipTemplate1" %>
<style type="text/css">
    .form-label {
        margin-bottom: 0;
        font-size: inherit;
        line-height: 1.5385;
    }

    .form-font-weight-bold {
        font-size: 15px !important;
        font-weight: bold !important;
    }

    .form-font-weight-bolder {
        font-size: 16px !important;
        font-weight: bolder !important;
    }
</style>
<section class="content">
    <div id="PayslipTemplate1_" class="card">
        <div class='card-body'>
            <div class='row'>
                <div class="col-2" style="padding-left: 20px;">
                    <img name="imglogo1" width='100px' heigh='100px' class="elevation-2" alt="company Image" id="imglogo1" />
                </div>
                <div class='col-7'>
                    <h3>
                        <label id='lblCompany_' class='form-label font-weight-bold'>Demo3 Company Pvt Ltd</label></h3>
                    <h6>
                        <label id='lblCompanyAddress_' class='form-label h6'>Kandiwali Mumbai 400064 India</label></h6>
                </div>
                <div class='col-3 text-right'>
                    <h6>
                        <label id='lblPayslipText_' class='form-label h6'>Payslip For the Month</label></h6>
                    <h3>
                        <label id='lblPayslipMonth_' class='form-label font-weight-bold'>September 2023</label></h3>
                </div>
            </div>
            <div class='row'>
                <div class='col-12'>
                    <hr style='margin: 0px;' />
                </div>
            </div>
            <div class='row'>
                <div class='col-7' style="padding-left: 20px;">
                    <div class='row'>
                        <div class='col-4'>
                            <label class='font-weight-bold form-label'>EMPLOYEE SUMMARY</label>
                        </div>
                        <div class='col-8'>
                            &nbsp;&nbsp;
                        </div>
                    </div>
                    <div class='row'>
                        <div class='col-3'>
                            <label class='form-label'>Employee Name</label>
                        </div>
                        <div class='col-9'>
                            :&nbsp;&nbsp;<label id='lblEmployeeName_' class='font-weight-bold form-label'>Abhay joshi</label>
                        </div>
                    </div>
                    <div class='row'>
                        <div class='col-3'>
                            <label class='form-label'>Employee ID</label>
                        </div>
                        <div class='col-9'>
                            :&nbsp;&nbsp;<label id='lblEmployeeID_' class='font-weight-bold form-label'>1232</label>
                        </div>
                    </div>
                    <div class='row'>
                        <div class='col-3'>
                            <label class='form-label'>Pay Period</label>
                        </div>
                        <div class='col-9'>
                            :&nbsp;&nbsp;<label id='PayPeriod_' class='font-weight-bold form-label'>September 2023</label>
                        </div>
                    </div>
                    <div class='row'>
                        <div class='col-3'>
                            <label class='form-label'>Pay Date</label>
                        </div>
                        <div class='col-9'>
                            :&nbsp;&nbsp;<label id='PayDate_' class='font-weight-bold form-label'>05/09/2023</label>
                        </div>
                    </div>
                </div>
                <div class='col-1'>
                    &nbsp;
                </div>
                <div class='col-4'>
                    <div style='border-top: 4px solid lightgray; border-left: 4px solid lightgray; border-right: 1px solid lightgray; border-bottom: 2px dashed lightgray; border-radius: 20px 20px 0px 0px; border-color: lightgray; background-color: #edfcf1; padding: 10px 10px 0px 10px; margin-left: 20px;'>
                        <label id='lblNetPayment_' class='font-weight-bold form-label' style='border-left: 10px solid #5fd068; margin-left: 10px; width: 90%; margin-right: 10px;'>&nbsp;&nbsp;₹116,666.00<br />
                            &nbsp;&nbsp;<span class='h6'>Employee Net Pay</span></label>
                        <br />
                        <br />
                    </div>
                    <div style='border-bottom: 4px solid lightgray; border-left: 4px solid lightgray; border-right: 1px solid lightgray; border-radius: 0px 0px 20px 20px; padding: 10px 10px 0px 10px; margin-left: 20px;'>
                        <div class='row'>
                            <div class='col-6'>
                                <label class='form-label'>Paid Days</label>
                            </div>
                            <div class='col-6'>:&nbsp;&nbsp;<label id='lblPaidDays_' class='font-weight-bold form-label'>30</label></div>
                        </div>
                        <div class='row'>
                            <div class='col-6'>
                                <label class='form-label'>LOP Days</label></div>
                            <div class='col-6'>:&nbsp;&nbsp;<label id='lblLOPdays_' class='font-weight-bold form-label'>0</label></div>
                        </div>
                        <br />
                    </div>
                </div>
            </div>
            <div class='row' style='border: 4px solid lightgray; border-radius: 20px;'>
                <span class='col-6' style='padding: 10px 20px 0px 20px;' id='divAddition_'></span>
                <span class='col-6' style='padding: 10px 20px 0px 20px;' id='divDeduction_'></span>
                <div class='col-6' style='padding: 5px 20px; background-color: lightgray; border-radius: 0px 0px 0px 20px;'>
                    <div class='row'>
                        <div class='col-6'>
                            <label class='font-weight-bold form-label'>Gross Earnings</label>
                        </div>
                        <div class='col-6 text-right'>
                            <label id='GrossEarning_' class='font-weight-bold form-label'>₹128,332.00</label>
                        </div>
                    </div>
                </div>
                <div class='col-6' style='padding: 5px 10px; background-color: lightgray; border-radius: 0px 0px 20px 0px;'>
                    <div class='row'>
                        <div class='col-6'>
                            <label class='font-weight-bold form-label'>Total Deductions </label>
                        </div>
                        <div class='col-6 text-right'>
                            <label id='totalDeductions_' class='font-weight-bold form-label'>₹11,666.00</label>
                        </div>
                    </div>
                </div>
            </div>
            <div class='row'>
                <div class='col-10' style='padding: 5px 20px; border-top: 4px solid lightgray; border-left: 4px solid lightgray; border-bottom: 4px solid lightgray; border-radius: 10px 0px 0px 10px;'>
                    <label class='font-weight-bold form-label'>TOTAL NET PAYABLE</label><br />
                    <label class='form-label'>Gross Earnings - Total Deductions</label>
                </div>
                <div class='col-2 text-right' style='padding: 5px 20px; background-color: #edfcf1; border-top: 4px solid lightgray; border-right: 4px solid lightgray; border-bottom: 4px solid lightgray; border-radius: 0px 10px 10px 0px;'>
                    <label id='Total_' class='form-font-weight-bolder form-label'></label>
                </div>
            </div>
            <div class='row'>
                <div class='col-12 text-right'>
                    <label class='form-label'>Amount In Words : 
                        <label id='lblAmtInWords_' style='text-transform: capitalize;' class='form-label font-weight-bold'>Indian Rupee Forty-Seven Thousand Five Hundred Only</label></label>
                    <hr style='margin-top: 0px;' />
                </div>
            </div>
        </div>
    </div>
</section>
