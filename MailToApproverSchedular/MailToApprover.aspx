<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MailToApprover.aspx.cs" Inherits="MailToApproverSchedular.MailToApprover" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="https://cdn.emailjs.com/dist/email.min.js"></script>
    <script src="JS/jquery.min.js"></script>
    <script src="JS/moment.min.js"></script>
    <script type="text/javascript">
            emailjs.init('9ptpXB8x4iMvLy91B')
     </script>
     <script type="text/javascript" language="javascript">
         $(document).ready(function () {
             var i = 0;
             var compcount = 0;
             $.ajax({
                 type: "POST",
                 url: "Service/EmailService.asmx/GetCompanyList",
                 dataType: 'json',
                 contentType: "application/json; charset=utf-8",
                 success: function (msg) {
                     var xmlDoc = $.parseXML(msg.d);
                     var xml = $(xmlDoc);
                     var CompanyList = xml.find("Table");
                     compcount = CompanyList.length;
                     $.each(CompanyList, function () {
                         var compID = $(this).find("CompId").text();
                         $.ajax({
                             type: "POST",
                             url: "Service/EmailService.asmx/GetApproverList",
                             data: '{CompanyID:' + $(this).find("CompId").text() + '}',
                             dataType: 'json',
                             contentType: "application/json; charset=utf-8",
                             success: function (msg) {
                                 var xmlDoc = $.parseXML(msg.d);
                                 var xml = $(xmlDoc);
                                 var ApproverList = xml.find("Table");

                                 var ApproverName = "";
                                 $.each(ApproverList, function () {
                                     ApproverName = $(this).find("StaffName").text();

                                     EmailID = $(this).find("Email").text();
                                     ApproverID = $(this).find("StaffCode").text();
                                     GetTimesheetData(compID, ApproverID, EmailID, ApproverName);
                                     //var currentdate = new Date();
                                     //var EmailDate;
                                     //EmailDate = moment(currentdate).format('DD-MM-YYYY');
                                     //var tempparams = {
                                     //    Subject: 'Timesheet Status Update',
                                     //    ApproverName: ApproverName,
                                     //    Date: EmailDate,
                                     //    TimesheetData: "This is test email",
                                     //    PendingCount: 10,
                                     //    reply_to: "krupa2316@gmail.com",//"info@saibex.co.in", //"info@saibex.co.in",//EmailID
                                     //}
                                     //emailjs.send("service_nbqwp3f", "template_623006p", tempparams)
                                     //    .then(function (res) {
                                     //        strBody = "";
                                     //    });
                                 });
                             },
                             //complete: function (msg) {
                                 

                                
                             //},
                             failure: function (response) {

                             },
                             error: function (response) {

                             }
                         });
                         i = i + 1;
                     });
                     //createFile();
                     //if (i == compcount) {
                     //    $.ajax({
                     //        type: "POST",
                     //        url: "Service/EmailService.asmx/SaveTextFile",
                     //        dataType: 'json',
                     //        contentType: "application/json; charset=utf-8",
                     //        success: function () {

                     //        },
                     //        failure: function (response) {

                     //        },
                     //        error: function (response) {

                     //        }
                     //    });
                     //}
                 },
                 failure: function (response) {

                 },
                 error: function (response) {

                 }
             });
         });


         function GetTimesheetData(compID, ApproverID, EmailID, ApproverName) {
             var currentdate = new Date();
             var EmailDate;
             EmailDate = moment(currentdate).format('DD-MM-YYYY');
             var strBody = "";
             $.ajax({
                 type: "POST",
                 url: "Service/EmailService.asmx/GetTimesheetStatus",
                 data: '{CompanyID:' + compID + ',ApproverID:' + ApproverID + '}',
                 dataType: 'json',
                 contentType: "application/json; charset=utf-8",
                 success: function (msg) {
                     var xmlDoc = $.parseXML(msg.d);
                     var xml = $(xmlDoc);
                     var CompanyDetailsList = xml.find("Table");
                     var HolidayList = xml.find("Table1");
                     var SubmittedList = xml.find("Table2");
                     var NotSubmittedList = xml.find("Table3");
                     var count = xml.find("Table4");
                     var PendingCount = count.find("PendingCount").text();
                     if (CompanyDetailsList.length > 0) {
                         const d = new Date();
                         let day = d.getDay()
                         if (day != 0) {
                             $.each(CompanyDetailsList, function () {

                                 //if ($(this).find("NumberOfDaysRequireInWeek").text() >= day) {
                                     if (HolidayList.length == 0) {
                                         strBody = "<b>Timesheets Submitted:</b><br/>";
                                         strBody += "<table style='border-collapse:collapse; width: 70%; border-width: 1px; border-spacing: 0px;'border='1' cellspacing='0' cellpadding='5'><tr>";
                                         strBody += "<td style='width: 6%; border-width: 1px; border-style: solid none solid solid; border-image: initial;color:white; background: rgb(68, 114, 196);'>Sr No</td>";
                                         strBody += "<td style='width: 13%; border-width: 1px; border-style: solid none solid solid; border-image: initial;color:white; background: rgb(68, 114, 196);'>Employee</td>";
                                         strBody += "<td style='width: 25%; border-width: 1px; border-style: solid none solid solid; border-image: initial;color:white;  background: rgb(68, 114, 196);'>Project</td>";
                                         strBody += "<td style='width: 10%; border-width: 1px; border-style: solid none solid solid; border-image: initial;color:white;  background: rgb(68, 114, 196);'>Activity</td>";
                                         strBody += "<td style='width: 10%; border-width: 1px; border-style: solid none solid solid; border-image: initial; color:white; background: rgb(68, 114, 196);'>Hrs</td></tr>";
                                         var sb = 0;
                                         var ns = 0;
                                         if (SubmittedList.length > 0) {

                                             var m = 0;
                                             $.each(SubmittedList, function () {
                                                 m = parseInt(m) + 1;
                                                 strBody += "<tr><td style='border-width: 1px; border-style: solid none solid solid; border-image: initial;'>" + m + "</td>";
                                                 strBody += "<td style='border-width: 1px; border-style: solid none solid solid; border-image: initial;'>" + $(this).find("StaffName").text() + "</td>";
                                                 strBody += "<td style='border-width: 1px; border-style: solid none solid solid; border-image: initial;'>" + $(this).find("ProjectName").text() + "</td>";
                                                 strBody += "<td style='border-width: 1px; border-style: solid none solid solid; border-image: initial;'>" + $(this).find("mjobname").text() + "</td>";
                                                 strBody += "<td style='border-width: 1px; border-style: solid none solid solid; border-image: initial;'>" + $(this).find("Hours").text() + "</td></tr>";
                                                 sb = 1;
                                             });
                                             strBody += "</table><br/><br/>";
                                         }
                                         else {
                                             strBody += "<tr><td colspan='5'>No Records found</td></tr>";
                                             strBody += "</table><br/><br/>";
                                         }

                                         if (sb == 0) {
                                             strBody = '';
                                         }

                                         strBody += "<b>Timesheets Not Submitted</b><br/>";
                                         strBody += "<table style='border-collapse:collapse; width: 50%; border-width: 1px; border-spacing: 0px;'border='1' cellspacing='0' cellpadding='5'><tr>";
                                         strBody += "<td style='width: 10%; border-width: 1px; border-style: solid none solid solid; border-image: initial;color:white;  background: rgb(68, 114, 196);'>Sr No</td>";
                                         strBody += "<td style='width: 90%; border-width: 1px; border-style: solid none solid solid; border-image: initial;color:white;  background: rgb(68, 114, 196);'>Employee</td></tr>";

                                         if (NotSubmittedList.length > 0) {
                                             var m = 0;
                                             $.each(NotSubmittedList, function () {
                                                 m = parseInt(m) + 1;
                                                 strBody += "<tr><td style='border-width: 1px; border-style: solid none solid solid; border-image: initial;'>" + m + "</td>";
                                                 strBody += "<td style='border-width: 1px; border-style: solid none solid solid; border-image: initial;'>" + $(this).find("staffname").text() + "</td></tr>";
                                                 ns = 1;
                                             });
                                             strBody += "</table><br/><br/>";
                                         }
                                         else {
                                             strBody += "<tr><td colspan='2'>No Records found</td></tr>";
                                             strBody += "</table><br/><br/>";
                                         }

                                         if (ns == 0 && sb == 0) {
                                             strBody = '';
                                         }
                                         if (strBody != '') {
                                             var tempparams = {
                                                 Subject: 'Timesheet Status Update',
                                                 ApproverName: ApproverName,
                                                 Date: EmailDate,
                                                 TimesheetData: strBody,
                                                 PendingCount: PendingCount,
                                                 reply_to: EmailID,
                                             }
                                             emailjs.send("service_nbqwp3f", "template_623006p", tempparams)
                                                 .then(function (res) {
                                                     strBody = "";
                                                 });
                                         }
                                     }

                                 //}
                             });
                         }

                     }
                 },
                 complete: function (msg) {
                     //$.ajax({
                     //    type: "POST",
                     //    url: "Service/EmailService.asmx/SaveTextFile",
                     //    dataType: 'json',
                     //    contentType: "application/json; charset=utf-8",
                     //    success: function () {

                     //    },
                     //    failure: function (response) {

                     //    },
                     //    error: function (response) {

                     //    }
                     //});
                 },
                 failure: function (response) {

                 },
                 error: function (response) {

                 }
             });
         }
         //function SendEmail(strSubject, strApproverName, EmailDate, strBody, intPendingCount, toEmail) {
         //    var tempparams = {
         //        Subject: strSubject,
         //        ApproverName: strApproverName,
         //        Date: EmailDate,
         //        TimesheetData: strBody,
         //        PendingCount: intPendingCount,
         //        reply_to: toEmail, //"info@saibex.co.in", //"info@saibex.co.in",//EmailID
         //    }
         //    emailjs.send("service_nbqwp3f", "template_623006p", tempparams)
         //        .then(function (res) {
         //        });
         //}
     </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
