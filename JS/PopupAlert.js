
// Override Noty defaults
Noty.overrideDefaults({
    theme: 'limitless',
    layout: 'topRight',
    type: 'alert',
    timeout: 2500
});



// Styled with white background
function showSuccessAlert(Texts) {
    new Noty({
        theme: ' alert alert-success alert-styled-left p-0 ',
        text: Texts,
        progressBar: true,
        closeWith: ['button']
    }).show();
 }


function showDangerAlert(Texts) {
     new Noty({
         theme: ' alert alert-danger alert-styled-left p-0 ',
         text: Texts,
         progressBar: true,
         closeWith: ['button']
     }).show();
}

function showDangerLongAlert(Texts) {
    new Noty({
        theme: ' alert alert-danger alert-styled-left p-0 ',
        text: Texts,
        progressBar: true,
        closeWith: ['button']
    }).show();
}

function showWarningAlert(Texts) {
    new Noty({
        theme: ' alert alert-warning alert-styled-left p-0 ',
        text: Texts,
        progressBar: true,
        closeWith: ['button']
    }).show();
}


function showInfoAlert(Texts) {
    new Noty({
        theme: ' alert alert-info alert-styled-left p-0 ',
        text: Texts,
        progressBar: true,
        closeWith: ['button']
    }).show();
}

function showPrimaryAlert(Texts) {
    new Noty({
        theme: ' alert alert-primary alert-styled-left p-0 ',
        text: Texts,  
        progressBar: true,
        closeWith: ['button']
    }).show();

}

function Blockloadershow() {
    $.blockUI({
        message: '<div style="color: #ff6600; opacity: 0.8; " class="la-ball-spin-fade-rotating la-2x"><div style="opacity: 0.8;" class="la-ball-spin-fade-rotating la-2x"></div><div  style="opacity: 0.8;" class="la-ball-spin-fade-rotating la-2x"></div> <div style="opacity: 0.8;" class="la-ball-spin-fade-rotating la-2x"></div><div  style="opacity: 0.8;" class="la-ball-spin-fade-rotating la-2x"></div><div  style="opacity: 0.8;" class="la-ball-spin-fade-rotating la-2x"></div><div  style="opacity: 0.8;" class="la-ball-spin-fade-rotating la-2x"></div><div  style="opacity: 0.8;" class="la-ball-spin-fade-rotating la-2x"></div><div  style="opacity: 0.8;" class="la-ball-spin-fade-rotating la-2x"></div><div  style="opacity: 0.8;" class="la-ball-spin-fade-rotating la-2x"></div></div>',
       // timeout: 2000, //unblock after 2 second
        overlayCSS: {
            
            opacity: 0.8,
            cursor: 'wait'
        },
        css: {
            border: 0,
            //padding: '10px 15px',
            color: '#79bbb5',
            left: '44%',
            width: 'auto',
            '-webkit-border-radius': 3,
            '-moz-border-radius': 3,
           // backgroundColor: '#333'
        }
    });
}

function Blockloaderhide() {
    $.unblockUI({
     //   timeout: 2000,
    });
}





