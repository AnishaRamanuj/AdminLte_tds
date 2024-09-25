<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>
<%@ Register Src="controls/MessageControl.ascx" TagName="MessageControl" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>JTMS-Timesheet Software </title>
    <!-- 
    - favicon
   -->
   <link rel="shortcut icon next prev" href="..\img\Logo_header.jpg" type="image/svg+xml" />
     <link rel="Stylesheet" type="text/css"  href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback" />

    <link href="css/all.min.css" rel="stylesheet" type="text/css" />
    <link href="icons/icomoon/styles.min.css" rel="stylesheet" type="text/css" />
    <link href="icons/fontawesome/styles.min.css" rel="stylesheet" type="text/css" />
    <link href="icons/material/styles.min.css" rel="stylesheet" type="text/css" />
    <link href="css/adminlte.min.css" rel="stylesheet" type="text/css" />
   <link href="../css/spinkit.css" rel="stylesheet" type="text/css" /> 
<link href="../css/components.css" rel="stylesheet" type="text/css" />   
    <!-- Core JS files -->
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="../JS/bootstrap.bundle.js" type="text/javascript"></script>
    <script src="../JS/adminlte.js" type="text/javascript"></script>

    <script src="../JS/blockui.min.js" type="text/javascript"></script>
    <script src="../js/pnotify.min.js" type="text/javascript"></script>
    <script src="../js/noty.min.js" type="text/javascript"></script>
    <script src="../js/PopupAlert.js" type="text/javascript"></script>
    <script type="text/javascript">
       



        var lat = '';
        var lng = '';

        $(document).ready(function () {
            GetLocation();

            //var loggedIn = getCookie("tmxlogin");
            //var chek = getCookie("tmxrem");
            //if (chek) {
            //    $("[id*=txtUsername]").val(getCookie("tmxuser"));
            //    $("[id*=txtPassword]").val(getCookie("tmxpwd"));
            //    $("[id*=chkRememberMe_]")[0].checked=true;
            //    if (loggedIn)
            //        Login();
            //} else {
            //    setCookie("tmxlogin", "false", 0);
            //    setCookie("tmxuser", '', 0);
            //    setCookie("tmxpwd", '', 0);
            //    setCookie("tmxrem", '', 0);
            //}
        });

        function GetLocation() {
            /* Chrome need SSL! */
            
            var is_chrome = /chrom(e|ium)/.test(navigator.userAgent.toLowerCase());
            var is_ssl = 'https:' == document.location.protocol;
            is_ssl = true;
            if (is_chrome && !is_ssl) {
               /* return false;*/
            }
            
            /* HTML5 Geolocation */
            navigator.geolocation.getCurrentPosition(
                function (position) { // success cb

                    /* Current Coordinate */
                    lat = position.coords.latitude;
                    lng = position.coords.longitude;
                    console.log('Lat:' + lat + "lng:" + lng);

                    $("[id*=hdnLat]").val(lat);
                    $("[id*=hdnLog]").val(lng);
                    

                    //var google_map_pos = new google.maps.LatLng(lat, lng);

                    ///* Use Geocoder to get address */
                    //var google_maps_geocoder = new google.maps.Geocoder();
                    //google_maps_geocoder.geocode(
                    //    { 'latLng': google_map_pos },
                    //    function (results, status) {
                    //        if (status == google.maps.GeocoderStatus.OK && results[0]) {
                    //            console.log(results[0].formatted_address);
                    //        }
                    //    }
                    //);
                },
                function () { // fail cb
                }
            );
        }


        function Login() {
            //var usr = $("[id*=txtUsername]").val();
            //var pss = $("[id*=txtPassword]").val();
            Blockloadershow();
            $.ajax({
                type: "POST",
                url: "../Services/Profile.asmx/CheckLogin",
                data: '{ lat:"' + lat + '", lng:"' + lng + '"}',
                //data: '{usr:"' + usr + '", pass:"' + pss + '", lat:"' + lat + '", lng:"' + lng + '"}',
                dataType: 'json',
                contentType: "application/json; charset=utf-8",
                success: function (msg) {
                    var myList = jQuery.parseJSON(msg.d);
                    if (myList.length > 0) {
                        var msg = myList[0].Msg;
                        Blockloaderhide();
                        if (msg == 'Invalid Username or Password') {
                            showDangerAlert('Invalid Username or Password');
                        }
                        else {
                            if (myList[0].url == '') {
                                showDangerAlert(myList[0].Msg);
                            }
                            else if (myList[0].Msg == 'url') {
                                window.location.href = myList[0].url;
                            }
                            else {
                                var mod = myList[0].Msg
                               
                                window.location.href = myList[0].url;
                           }
                        }
                    }
                    Blockloaderhide();
                },
                failure: function (response) {
                    Blockloaderhide();
                },
                error: function (response) {
                    Blockloaderhide();
                }
            });
        }
        
        function setCookie(cname, cvalue, exdays) {
            var d = new Date();
            d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
            var expires = "expires=" + d.toUTCString();
            document.cookie = cname + "=" + cvalue + "; " + expires;
        }

        function getCookie(cname) {
            var name = cname + "=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i];
                while (c.charAt(0) == ' ') c = c.substring(1);
                if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
            }
            return "";
        }
    </script>

</head>
<body class="login-page" style="min-height: 496.781px;">

	<div class="login-box">

		
		
        <div class="card">
						<div class="card-body login-card-body">
                            <div class="login-logo">
            <img src="images/JTMSLogo.jpg" alt="JTMS" class="border-0  p-3 mb-3 mt-1" width="200" height="100"/>
            </div>
                            <p class="login-box-msg font-weight-bold">Sign in to start your session</p>
				<!-- Login card -->
				<form class="login-form" runat="server" method="post" >
                    <asp:HiddenField runat="server" ID="hdnU"/>
                    <asp:HiddenField runat="server" ID="hdnP"/>
					<asp:HiddenField ID="hdnLat" runat="server" />
                    <asp:HiddenField ID="hdnLog" runat="server" />
					

							<div class="input-group mb-3">
								<input id="txtUsername"  type="text" runat="server" class="form-control form-control-border" placeholder="Username" />
								<div class="input-group-append">
                                    <div class="input-group-text">

                                   
									<i class="icon-user text-muted"></i>
								</div>
							</div>
                    </div>
							<div class="input-group mb-3">
								<input id="txtPassword" type="password" runat="server" class="form-control form-control-border" placeholder="Password" />
								<div class="input-group-append">
                                    <div class="input-group-text">
									<i class="icon-lock2 text-muted"></i>
								</div>

                              </div>
							</div>

							<div class="row">
								<div class="col-8">
                                    <div class="icheck-primary">
                                        <asp:CheckBox ID="chkRememberMe_" CssClass="form-input-styled" Text="Remember Me" runat="server" />
										<%--<input type="checkbox" id="remember_me" name="remember" class="form-input-styled"   />
                                        <label for="remember">
                                    Remember Me
                                  </label>--%>
								</div>	
								</div>
							<div class="col-4">
                                <asp:Button   id="btnSubmit" runat="server"  Cssclass="btn btn-outline-success legitRipple" text="Sign In" OnClick="btnSubmit_Click"></asp:Button>
                            </div>
                        </div>
                        </form>
							<div class="social-auth-links text-center mb-3">
								<span class="px-2 font-weight-bold ">Contact us </span>
							</div>

							<div class="social-auth-links text-center mb-3">
								<label class="text-center">Mbl:<span class="font-weight-bold"> 9892606006 </span> </label>
								<label class="text-center" > Email : <span class="font-weight-bold">info@saibex.co.in</span></label>
							</div>

							<p class="mb-1">
                        <a href="forgotPassword.aspx">I forgot my password</a>
                         </p>

							<p class="mb-0">
                     <a href="signupform.aspx" class="text-center">Register a new membership</a>
                         </p>
						</div>
					</div>
        </div>

    

</body>
</html>
