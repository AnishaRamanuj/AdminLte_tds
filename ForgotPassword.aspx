<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ForgotPassword.aspx.cs" Inherits="ForgotPassword" %>

<%@ Register Src="controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>
<%--<script type="text/javascript" src="jquery/smtp.js"></script>--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
     <title>::JTMS::</title>
   <link href="css/layout.min.css" rel="stylesheet" type="text/css" />
    <link href="css/components.min.css" rel="stylesheet" type="text/css" />
    <link href="css/colors.min.css" rel="stylesheet" type="text/css" />

        <link href="css/all.min.css" rel="stylesheet" type="text/css" />
    <link href="icons/icomoon/styles.min.css" rel="stylesheet" type="text/css" />
    <link href="icons/fontawesome/styles.min.css" rel="stylesheet" type="text/css" />
    <link href="icons/material/styles.min.css" rel="stylesheet" type="text/css" />
    <link href="css/adminlte.min.css" rel="stylesheet" type="text/css" />
   <link href="../css/spinkit.css" rel="stylesheet" type="text/css" /> 

    <!-- Core JS files -->
     <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="JS/bootstrap.bundle.js" type="text/javascript"></script>
    <script src="JS/adminlte.js" type="text/javascript"></script>
    <!-- /core JS files -->

    <!-- Theme JS files -->
    <script src="js/interactions.min.js" type="text/javascript"></script>


    <script src="js/uniform.min.js" type="text/javascript"></script>
<script src="../js/noty.min.js" type="text/javascript"></script>
    <script src="../js/PopupAlert.js" type="text/javascript"></script>
    <script src="js/app.js" type="text/javascript"></script>
    <script src="js/smtp.js" type="text/javascript"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/emailjs-com@3/dist/email.min.js"></script>


    <script type="text/javascript">
        emailjs.init('9ptpXB8x4iMvLy91B')
    </script>

    <script type="text/javascript" language="javascript">
        $(document).ready(function () {


            $("[id*=btnForgot]").on('click', function () {
                //$("[id*=hdnEmail]").val($("[id*=txtemail]").val());
                //$("[id*=btnchange]").click();
                if ($("[id*=txtemail]").val() != '') {
                    SendMails($("[id*=txtemail]").val());
                } else {
                    showWarningAlert('Fill the registered Email id!!!');
                }

            });

        });

        function SendMails(email) {
            // var compid = $("[id*=hdnCompanyid]").val();
            $.ajax({
                type: "POST",
                url: "../Services/StaffMaster.asmx/GetForgetPassword",
                data: '{email:"' + email + '"}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var List = jQuery.parseJSON(msg.d);

                    var custname = '', usrname = '', password = '';

                    if (List.length > 0) {
                        custname = List[0].FirstName;
                        usrname = List[0].username;
                        password = List[0].password;
                    } else {
                        showWarningAlert('Fill the registered Email id');
                        return;
                    }
   
                    //email = List[0].Email;

                    var tempparams = {
                        from_name: 'Forget Password',
                        to_name: custname,
                        Username: usrname,
                        Password: password,
                        reply_to: email,
                    }

                    emailjs.send("service_nbqwp3f", "template_ebwv9sb", tempparams)
                    .then(function (res) {
                        //console.log("success", res.status);
                        if (res.text == 'OK') {
                            showSuccessAlert('Mail send successfully!!!');
                        } else {
                            showWarningAlert('Mail not send');
                        }
                      
                    })



                },
                failure: function (response) {

                },
                error: function (response) {

                }
            });
        }

        //function SendMails() {

        //    var b = $("[id*=hdnBody]").val();
        //    var email = $("[id*=hdnEmail]").val();
        //    var msg = '';
        //    Email.send({
        //        SecureToken: "b6c7afd9-23ee-41fb-9a1d-f80ed8ad600e",
        //        To: "mufaddal@saibex.co.in",
        //        From: "info.saibexnetwork@gmail.com",
        //        Subject: "Forget Password",
        //        Body: b
        //    }).then(
        //        //message => alert(message)
        //        message => msg
        //        );



        //}


        //function SendMails() {

        //    var b = $("[id*=hdnBody]").val();
        //    var email = $("[id*=hdnEmail]").val();


        //    Email.send({
        //        Host: "smtp.gmail.com",
        //        Username: "info@saibex.co.in",
        //        Password: "20indmxabeais_bigboss20",
        //        To: "mufaddal@saibex.co.in",
        //        From: "info@saibex.co.in",
        //        Subject: "Forget Password",
        //        Body: b
        //    }).then(
        //           message => alert(message)

        //         );



        //}

        //    Email.send("info.saibexnetwork@gmail.com", "mufaddal@saibex.co.in", "Forget Password", b, { token: "b6c7afd9-23ee-41fb-9a1d-f80ed8ad600e" });



    </script>
</head>
<body>

    <!-- Main navbar -->
   
     <div class="content-header">
                
    <div class="container-fluid">
        <div class="row mb-2">
          

		</div>			
               
	</div>
          
</div>

        <div class="d-md-none">
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar-mobile">
                <i class="icon-tree5"></i>
            </button>
        </div>



   



    


            <!-- Content area -->
            <div class="content d-flex justify-content-center align-items-center">

                <!-- Password recovery form -->
                <form class="login-form" runat="server">
                    <asp:HiddenField ID="hdnBody" runat="server" />
                    <asp:HiddenField ID="hdnEmail" runat="server" />
                    <uc1:MessageControl ID="MessageControl1" runat="server" />
                    <asp:ScriptManager ID="ScriptManager1" runat="server">
                    </asp:ScriptManager>
                    <div class="card mb-0">
                        <div class="card-body">
                            <div class="text-center mb-3">
                               <div class="login-logo">
            <img src="images/JTMSLogo.jpg" alt="JTMS" class="border-0 rounded-circle p-3 mb-3 mt-1" width="200" height="100"/>
            </div>
                                <h5 class="mb-0">Password recovery</h5>
                                <span class="d-block text-muted">We'll send you instructions in email</span>
                            </div>

                            <div class="form-group form-group-feedback form-group-feedback-right">
                                <input id="txtemail" type="email" class="form-control" placeholder="Your email" />
                                <div class="form-control-feedback">
                                    

                                </div>
                            </div>
                            <div class="form-group form-group-feedback form-group-feedback-right">
                                <input id="btnForgot" type="button" class="btn bg-blue btn-block" value="Reset password " />
                                <%--                                <div class="form-control-feedback">
                                <i class="icon-spinner11 mr-2"></i>
                                </div>--%>
                            </div>

                            <div class="social-auth-links text-center mb-3">
								<span class="px-2 font-weight-bold ">Contact us </span>
							</div>

							<div class="social-auth-links text-center mb-3">
								<label class="text-center">Mbl:<span class="font-weight-bold"> 9892606006 </span> </label>
								<label class="text-center" > Email : <span class="font-weight-bold">info@saibex.co.in</span></label>
							</div>
                        </div>
                    </div>
                </form>
                <!-- /password recovery form -->

            </div>
            <!-- /content area -->


           


        


</body>
</html>
