
function Validations() {
    var Name;
    Name = document.getElementById("txtName").value;
    var uname = document.getElementById("txtfirstname").value;
    var Phone = document.getElementById("txtPhone").value;
    var Email = document.getElementById("txtEmail").value;
    var password = document.getElementById("txtpassword").value;
    //var Cpassword = document.getElementById("txtverifypwd").value;
    var username = document.getElementById("txtusername").value;
    var emailExp = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    var mobilevalidation = /^((\+)?(\d{2}[-]))?(\d{10}){1}?$/;
    if (Name == '' && Phone == '' && Email == '' && password == '' && username == '' && uname == '') {

        document.getElementById("tdcompanyname").innerHTML = "Company Name required.";
        document.getElementById("tdcompanyname").style.color = "Red";
        $('#txtName').css('border-color', 'red');

        document.getElementById("tdContactNumber").innerHTML = "Phone/Mobile required.";
        document.getElementById("tdContactNumber").style.color = "Red";
        $('#txtPhone').css('border-color', 'red');


        document.getElementById("tdContactPerson").innerHTML = "Contact Name required.";
        document.getElementById("tdContactPerson").style.color = "Red";
        $('#txtfirstname').css('border-color', 'red');

        document.getElementById("tdEmailId").innerHTML = "Email id required.";
        document.getElementById("tdEmailId").style.color = "Red";
        $('#txtEmail').css('border-color', 'red');



        document.getElementById("tdPassword").innerHTML = "Password required.";
        document.getElementById("tdPassword").style.color = "Red";
        $('#txtpassword').css('border-color', 'red');





        document.getElementById("tdUsername").innerHTML = "UserName required.";
        document.getElementById("tdUsername").style.color = "Red";
        $('#txtusername').css('border-color', 'red');
        return false;
    }
    if (Name == '') {

        document.getElementById("tdcompanyname").innerHTML = "Company Name required.";
        document.getElementById("tdcompanyname").style.color = "Red";
        $('#txtName').css('border-color', 'red');
        return false;

    }
    else {
        document.getElementById("tdcompanyname").innerHTML = "";
        $('#txtName').css('border-color', '');


    }


    if (uname == '') {

        document.getElementById("tdContactPerson").innerHTML = "Contact Name required.";
        document.getElementById("tdContactPerson").style.color = "Red";
        $('#txtfirstname').css('border-color', 'red');
        return false;

    }
    else {
        document.getElementById("tdContactPerson").innerHTML = "";
        $('#txtfirstname').css('border-color', '');


    }
    if (Phone == '') {

        document.getElementById("tdContactNumber").innerHTML = "Phone/Mobile required.";
        document.getElementById("tdContactNumber").style.color = "Red";
        $('#txtPhone').css('border-color', 'red');
        return false;

    }
    else {
        document.getElementById("tdContactNumber").innerHTML = "";
        $('#txtPhone').css('border-color', '');




    }


    if (Email == '') {
        document.getElementById("tdEmailId").innerHTML = "Email id required.";
        document.getElementById("tdEmailId").style.color = "Red";
        $('#txtEmail').css('border-color', 'red');
        return false;

    }
    else {
        document.getElementById("tdEmailId").innerHTML = "";
        $('#txtEmail').css('border-color', '');


    }

    if (username == '') {

        document.getElementById("tdUsername").innerHTML = "UserName required.";
        document.getElementById("tdUsername").style.color = "Red";
        $('#txtUsername').css('border-color', 'red');
        return false;
    }
    else {
        document.getElementById("tdUsername").innerHTML = "";
        $('#txtUsername').css('border-color', '');


    }
    if (password == '') {

        document.getElementById("tdPassword").innerHTML = "Password required.";
        document.getElementById("tdPassword").style.color = "Red";
        $('#txtpassword').css('border-color', 'red');
        return false;

    }
    else {
        document.getElementById("tdPassword").innerHTML = "";
        $('#txtpassword').css('border-color', '');


    }

    if (!Phone.match(mobilevalidation)) {

        document.getElementById("tdContactNumber").innerHTML = "Please Check Your Mobile Number.";
        document.getElementById("tdContactNumber").style.color = "Red";
        $('#txtPhone').css('border-color', 'red');
        return false;


    }
    else {

        document.getElementById("tdContactNumber").innerHTML = "";
        $('#txtPhone').css('border-color', '');


    }
    if (!Email.match(emailExp)) {

        document.getElementById("tdEmailId").innerHTML = "Invalid Email id.";
        document.getElementById("tdEmailId").style.color = "Red";
        $('#txtEmail').css('border-color', 'red');
        return false;


    }
    else {

        document.getElementById("tdEmailId").innerHTML = "";
        $('#txtEmail').css('border-color', '');


    }


}