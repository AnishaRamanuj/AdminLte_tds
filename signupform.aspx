<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="signupform.aspx.cs" Inherits="signupform" %>




<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
        <title>::JTMS::</title>
    
   <link rel="shortcut icon next prev" href="img\Logo_header.jpg" type="image/svg+xml" />
    <link rel="Stylesheet" type="text/css"  href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback" />
    <link href="css/all.min.css" rel="stylesheet" type="text/css" />
    <link href="icons/icomoon/styles.min.css" rel="stylesheet" type="text/css" />
    <link href="icons/fontawesome/styles.min.css" rel="stylesheet" type="text/css" />
    <link href="icons/material/styles.min.css" rel="stylesheet" type="text/css" />
    <link href="icons/Pe7/pe-icon-7-stroke.css" rel="stylesheet" type="text/css" />

    <link href="css/adminlte.min.css" rel="stylesheet" type="text/css" />
    
    <link href="css/colors.min.css" rel="stylesheet" type="text/css" />
    <link href="css/spinkit.css" rel="stylesheet" type="text/css" />   
     <link href="css/components.css" rel="stylesheet" type="text/css" /> 
    <!-- Core JS files -->
    <script src="JS/jquery.min.js" type="text/javascript"></script>
    <script src="JS/bootstrap.bundle.js" type="text/javascript"></script>
    <script src="JS/adminlte.js" type="text/javascript"></script>

    <script src="JS/blockui.min.js" type="text/javascript"></script>
    <script src="js/pnotify.min.js" type="text/javascript"></script>
    <script src="js/noty.min.js" type="text/javascript"></script>
    <script src="js/PopupAlert.js" type="text/javascript"></script>

    <script src="JS/select2.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/emailjs-com@3/dist/email.min.js"></script>

    <script type="text/javascript">
        emailjs.init('9ptpXB8x4iMvLy91B')
    </script>

    <script type="text/javascript" language="javascript">
        $(document).keypress(
          function (event) {
              if (event.which == '13') {
                  event.preventDefault();
              }
        });   

        var r = false;
        $(document).ready(function () {
            clearValues();

            $("[id*=btnSubmit]").on('click', function () {
                Validations();
               if (r == true) {
                   var hdndtls = $("[id*=txtName]").val() + '^' + $("[id*=txtfirstname]").val() + '^' + $("[id*=txtPhone]").val();
                   hdndtls = hdndtls + '^' + $("[id*=txtEmail]").val() + '^' + $("[id*=txtusername]").val() + '^' + $("[id*=txtpassword]").val();
                   $("[id*=hdndtls]").val(hdndtls);

                   $.ajax({
                       type: "POST",
                       url: "../Services/Company.asmx/CreateCompany",
                       data: '{hdndtls:"' + hdndtls + '" }',
                       dataType: 'json',
                       contentType: "application/json; charset=utf-8",
                       success: function (msg) {
                           var myList = jQuery.parseJSON(msg.d);
                           if (myList != null) { 
                               // c9454a24-2da5-4f55-81d3-c15b96b91eb6
                               showSuccessAlert(myList[0].Msg);
                               SendMails(myList[0].CompanyName, myList[0].FirstName, myList[0].Phone, myList[0].Email)

                               clearValues();
                           }
                           else {
                               showWarningAlert('Company Registration Failed');
                           }

                       },
                       failure: function (response) {
                           showDangerAlert('Company Registration Failed');
                       },
                       error: function (response) {
                           showDangerAlert('Company Registration Failed');
                       }
                   });
               }
            });

            $("[id*=txtName]").blur(function () {
                if (!Validations()) {
                   
                    return false;
                }
            });
            $("[id*=txtfirstname]").blur(function () {
                if (!Validations()) {
                 
                    return false;
                }
            });
            $("[id*=txtPhone]").blur(function () {
                if (!Validations()) {
                    return false;
                }
            });
            $("[id*=txtEmail]").blur(function () {
                if (!Validations()) {
                
                    return false;
                }
            });
            $("[id*=txtusername]").blur(function () {
                if (!Validations()) {
                   
                    return false;
                }
            });
            $("[id*=txtpassword]").blur(function () {
                if (!Validations()) {
                  
                    return false;
                }
            });

        });

        //function SendMails(Cname, CPer, Email, Phone ) {

        //    var b = '<span style= font-family: verdana; font-size: 10pt; >Dear Team,</span>';
        //    b = b + '<p><span style=font-family: verdana; font-size: 10pt;>New Client has Registerrd for Timesheet.</span></p>';
        //    b = b + '<p><span style=font-family: verdana; font-size: 10pt;>Details as follows,</span></p>';
        //    b = b + '<blockquote style=margin: 0px 0px 0px 40px; border: none; padding: 0px; >';
        //    b = b + '<div style= font-family: verdana;><span style= font-family: verdana; font-size: 10pt; ><strong>Company :</strong><span >' + Cname + '</span></div>';
        //    b = b + '<div style= font-family: verdana;><span style= font-family: verdana; font-size: 10pt; ><strong>Contact : </strong><span >' + CPer + '</span></div>';
        //    b = b + '<div style= font-family: verdana;><span style= font-family: verdana; font-size: 10pt; ><strong>Phone :</strong><span >' + Phone + '</span></div>';
        //    b = b + '<div style= font-family: verdana;><span style= font-family: verdana; font-size: 10pt; ><strong>Email :</strong><span >' + Email + '</span></div>';
        //    b = b + '</blockquote>';
        //    b = b + '<p><span style=font-family: verdana; font-size: 10pt;>Regards</span></p>';
        //    b = b + '</body>';
        //    //var email = $("[id*=hdnEmail]").val();
 
        //    Email.send({
        //        //SecureToken : "C973D7AD-F097-4B95-91F4-40ABC5567812",
        //        Host: "sh017.webhostingservices.com",
        //        Username: "noreply@timesheetsoft.com",
        //        Password: "Saibex2929@",
        //        Port: 587,
        //        To : 'info@saibex.co.in',
        //        From: "noreply@timesheetsoft.com",
        //        Subject : "Timesheet Enquiry",
        //        Body : b
        //    }).then(
        //      message => alert(message)
        //    );

        //    Email.send({
        //        SecureToken : "C973D7AD-F097-4B95-91F4-40ABC5567812",
        //        To : 'rjrajput@gmail.com',
        //        From: "noreply@timesheetsoft.com",
        //        Subject: "Timesheet Enquiry",
        //        Body : b
        //    }).then(
        //      message => alert(message)
        //    );
        //  }

        function SendMails(Cname, CPer, Email, Phone) {
 
            var Company = Cname;
            var Contact = CPer;
            var Phone = Phone;
            var Email = Email;

           

            var tempparams = {
                reply_to: 'rjrajput@gmail.com',
                Company: Cname,
                Contact: CPer,
                Phone: Phone,
                Email: Email,
            }

            emailjs.send("service_nbqwp3f", "template_869e4vo", tempparams)
                         .then(function (res) {
                             //console.log("success", res.status);
                             if (res.text == 'OK') {
                               //  showSuccessAlert('Warning send successfully!!!');
                             }

                         })


            var tparams = {
                reply_to: 'info@saibex.co.in',
                Company: Cname,
                Contact: CPer,
                Phone: Phone,
                Email: Email,
            }
            emailjs.send("service_nbqwp3f", "template_869e4vo", tparams)
                         .then(function (res) {

                         })
        }

        function clearValues()
        {
            $("[id*=txtName]").val('');
            $("[id*=txtfirstname]").val('');
            $("[id*=txtPhone]").val('');

            $("[id*=txtEmail]").val('');
            $("[id*=txtusername]").val('');
            $("[id*=txtpassword]").val('');


        }

        function Validations() {
            var emailExp = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
            var mobilevalidation = /^((\+)?(\d{2}[-]))?(\d{10}){1}?$/;
            var n = $("[id*=txtName]").val();
            var f = $("[id*=txtfirstname]").val();
            var p = $("[id*=txtPhone]").val();
            var e = $("[id*=txtEmail]").val();
            var u = $("[id*=txtusername]").val();
            var w = $("[id*=txtpassword]").val();

            if (n == '') {
                document.getElementById("tdcompanyname").innerHTML = "Company Name required.";
                document.getElementById("tdcompanyname").style.color = "Red";
                $('#txtName').css('border-color', 'red');

                r = false;
                return false;
            }
            else if (n == undefined) {
                document.getElementById("tdcompanyname").innerHTML = "Company Name required.";
                document.getElementById("tdcompanyname").style.color = "Red";
                $('#txtName').css('border-color', 'red');
                r = false;
                return false;
            }
            else
            {
                document.getElementById("tdcompanyname").innerHTML = "";
                document.getElementById("tdcompanyname").style.color = "Red";
                $('#txtName').css('border-color', 'black');
                r= true;
            }


            if (f == '') {
                document.getElementById("tdContactPerson").innerHTML = "Contact Name required.";
                document.getElementById("tdContactPerson").style.color = "Red";
                $('#txtfirstname').css('border-color', 'red');
                r = false;
                return false;
            }
            else if (f == undefined) {
                document.getElementById("tdContactPerson").innerHTML = "Contact Name required.";
                document.getElementById("tdContactPerson").style.color = "Red";
                $('#txtfirstname').css('border-color', 'red');
                r = false;
                return false;
            }
            else {
                document.getElementById("tdContactPerson").innerHTML = "";
                document.getElementById("tdContactPerson").style.color = "Red";
                $('#txtfirstname').css('border-color', 'black');
                r = true;
            }


            if (p == '') {
                document.getElementById("tdContactNumber").innerHTML = "Phone/Mobile required.";
                document.getElementById("tdContactNumber").style.color = "Red";
                $('#txtPhone').css('border-color', 'red');
                r = false;
                return false;
            }
            else if (p == undefined) {
                document.getElementById("tdContactNumber").innerHTML = "Phone/Mobile required.";
                document.getElementById("tdContactNumber").style.color = "Red";
                $('#txtPhone').css('border-color', 'red');
                r = false;
                return false;
            }
            else {
                document.getElementById("tdContactNumber").innerHTML = "";
                document.getElementById("tdContactNumber").style.color = "Red";
                $('#txtPhone').css('border-color', 'black');
                r = true;
            }

            if (e == '') {
                document.getElementById("tdEmailId").innerHTML = "Email id required.";
                document.getElementById("tdEmailId").style.color = "Red";
                $('#txtEmail').css('border-color', 'red');
                r = false;
                return false;
            }
            else if (e == undefined) {
                document.getElementById("tdEmailId").innerHTML = "Email id required.";
                document.getElementById("tdEmailId").style.color = "Red";
                $('#txtEmail').css('border-color', 'red');
                r = false;
                return false;
            }
            else {
                document.getElementById("tdEmailId").innerHTML = "";
                document.getElementById("tdEmailId").style.color = "Red";
                $('#txtEmail').css('border-color', 'black');
                r = true;
            }

            if (u == '') {
                document.getElementById("tdUsername").innerHTML = "UserName required.";
                document.getElementById("tdUsername").style.color = "Red";
                $('#txtusername').css('border-color', 'red');
                r = false;
                return false;
            }
            else if (u == undefined) {
                document.getElementById("tdUsername").innerHTML = "UserName required.";
                document.getElementById("tdUsername").style.color = "Red";
                $('#txtusername').css('border-color', 'red');
                r = false;
                return false;
            }
            else {
                document.getElementById("tdUsername").innerHTML = "";
                document.getElementById("tdUsername").style.color = "Red";
                $('#txtusername').css('border-color', 'black');
                r = true;
            }

            if (w == '') {
                document.getElementById("tdPassword").innerHTML = "Password required.";
                document.getElementById("tdPassword").style.color = "Red";
                $('#txtpassword').css('border-color', 'red');
                r = false;
                return false;
            }
            else if (w == undefined) {
                document.getElementById("tdPassword").innerHTML = "Password required.";
                document.getElementById("tdPassword").style.color = "Red";
                $('#txtpassword').css('border-color', 'red');
                r = false;
                return false;
            }
            else {
                document.getElementById("tdPassword").innerHTML = "";
                document.getElementById("tdPassword").style.color = "Red";
                $('#txtpassword').css('border-color', 'black');
                r = true;
            }

            if (!p.match(mobilevalidation)) {
                document.getElementById("tdContactNumber").innerHTML = "Please Check Your Mobile Number.";
                document.getElementById("tdContactNumber").style.color = "Red";
                $('#txtPhone').css('border-color', 'red');
                r = false;
                return false;
            }

            if (!e.match(emailExp)) {
                document.getElementById("tdEmailId").innerHTML = "Invalid Email id.";
                document.getElementById("tdEmailId").style.color = "Red";
                $('#txtEmail').css('border-color', 'red');
                r = false;
                return false;
            }
        }

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
        //function SuccessMsg(msg) {
        //    showSuccessAlert(msg);
        //}

        //function ErrMsg(msg) {
        //    showDangerAlert(msg);
        //}
 




    </script>
    <style type="text/css">
        .txtbox {
            background-color: #fffcfc;
            font-family: Verdana,Arial,Helvetica,sans-serif;
            font-size: 12px;
            font-style: normal;
            padding-left: 5px;
            color: #000000;
            /*-webkit-border-radius: 6px;
            -moz-border-radius: 6px;*/
            /*border-radius: 6px;*/
            border: 1px solid #000000;
        }

        .loginscreen {
            margin-left: 15%;
            margin-right: 15%;
            width: 70%;
            margin-top: -2%;
            margin-bottom: 10%;
            height: 100%;
            padding-left: 45px;
        }

        .divdata {
            padding-top: 35px;
        }

        .signupbutton {
            display: inline-block;
            padding: 10px 20px;
            width:88%;
            cursor: pointer;
            color: #fff;
            background-color: #0e5f8e;
            border: none;
            /*border-radius: 15px;*/
            box-shadow: 0 5px #999;
        }

            .signupbutton:hover {
                background-color: #4CAF50
            }

            .signupbutton:active {
                background-color: #4CAF50;
                box-shadow: 0 5px #666;
                transform: translateY(4px);
            }

        .headerdiv {
            height: 155px;
            width: 100%;
            background-color: #f36c00;

        }
        .divheader {
            height: 50px;
            width: 100%;
            background-color: #f36c00;
            margin-bottom :5px;
            margin-top :5px;
        }
        .anchorc {
            padding-left: 334px;
            font-size: 35px;
            font-family: "Brandon Text", "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-weight: bolder;
            color: white;
            text-decoration: none;
            padding-top: 100px;
            margin-top: 100px;
        }

        .anchorclass {
            padding-left: 341px;
            font-size: 14px;
            font-family: "Brandon Text", "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-weight: bolder;
            color: white;
            text-decoration: none;
            /*padding-top:100px;
            margin-top:100px;*/
        }

        .innertext {
            color: white;
            padding-left: 408px;
            font-family: "Brandon Text", "Helvetica Neue", Helvetica, Arial, sans-serif;
            font-size: 42px;
            margin-block-start:auto;
        }

        .innertext1 {
            color: white;
            padding-left: 498px;
            font-family: "Brandon Text", "Helvetica Neue", Helvetica, Arial, sans-serif;
        }
        .footerclass {
            margin-top:12%;
            padding-top:50px;
            width:85%;
            border-top:1px solid #ddd;
            font-size:15px;
            color:darkgrey;
            padding:5px 0 10px;
            text-align:center;

        }
        #formbody {
            margin: 0px;
        }u
    </style>
</head>
<body id="formbody"  runat="server">
	 <div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>
          
</div>

			<!-- Content area -->
			<div class="content d-flex justify-content-center align-items-center">

				<!-- Registration form -->
				<form runat="server" class="flex-fill">
                    <asp:ScriptManager ID="ScriptManager1" runat="server">
                    </asp:ScriptManager>
                   <asp:HiddenField ID="hdndtls" runat="server"/>
<%--                     <asp:HiddenField ID="hdnBody" runat="server"/>--%>

					<div id="datadiv" runat="server"  class="row">
						<div class="col-lg-6 offset-lg-3">
							<div class="card mb-0">
								<div class="card-body">

									<div class="text-center mb-3">
									    <img src="img/JTMS_Logo.jpg" alt="" />
                                        <h2 class="mb-0">Start your free 15-day trial.</h2>
										<span class="d-block text-muted">Fully functional. No credit card required.</span>
									</div>

									<div class="form-group form-group-feedback form-group-feedback-right">
										<input type="text" id="txtName" class="form-control form-control-border" placeholder="Company Name" />
										

                                        <div id="tdcompanyname"></div>
									</div>

									<div class="form-group form-group-feedback form-group-feedback-right">
										<input type="text" id="txtfirstname" class="form-control form-control-border" placeholder="Contact Person" />
										<div class="form-control-feedback">
										

										</div>
                                        <div id="tdContactPerson"></div>
									</div>

									<div class="row">
										<div class="col-md-6">
									        <div class="form-group form-group-feedback form-group-feedback-right">

										        <input type="email" id="txtEmail" class="form-control form-control-border" placeholder="Your email" />
										        <div class="form-control-feedback">
											        

										        </div>
                                                <div id="tdEmailId"></div>
									        </div>
										</div>

										<div class="col-md-6">
											<div class="form-group form-group-feedback form-group-feedback-right">
												<input type="text" id="txtPhone" class="form-control form-control-border" placeholder="Mobile Number" />
												<div class="form-control-feedback">
													

												</div>
                                                <div id="tdContactNumber"></div>
											</div>
										</div>
									</div>

									<div class="row">
										<div class="col-md-6">
											<div class="form-group form-group-feedback form-group-feedback-right">
												<input type="text" id="txtusername" class="form-control form-control-border" placeholder="UserName" />
												<div class="form-control-feedback">
													

												</div>
                                                <div id="tdUsername"></div>
											</div>
										</div>

										<div class="col-md-6">
											<div class="form-group form-group-feedback form-group-feedback-right">
												<input type="password" id="txtpassword"  class="form-control form-control-border" placeholder="Password" />
												<div class="form-control-feedback">
												

												</div>
                                                <div id="tdPassword"></div>
											</div>
										</div>
									</div>

									<button type="button" id="btnSubmit" class="btn btn-outline-success legitRipple" ><i class="fas fa-plus mr-2 fa-1x"></i>Create your free account</button>

							
                                </div>
							</div>
						</div>
					</div>

				</form>
				<!-- /registration form -->

			</div>
			<!-- /content area -->


			<!-- Footer -->
<%--			<div class="navbar navbar-expand-lg navbar-light">
				<div class="text-center d-lg-none w-100">
					<button type="button" class="navbar-toggler dropdown-toggle" data-toggle="collapse" data-target="#navbar-footer">
						<i class="icon-unfold mr-2"></i>
						Footer
					</button>
				</div>

			</div>--%>
			<!-- /footer -->
		<!-- /main content -->
		



		

	<!-- /page content -->
 

</body>

</html>
