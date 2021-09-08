var cancelledTimer = null;

$('document').ready(function() {
    Progressbar = {};

    Progressbar.Progress = function(data) {
        clearTimeout(cancelledTimer);
        $("#progress-label").text(data.label);

        $(".progress-container").fadeIn('fast', function() {
            $("#progress-bar").stop().css({"width": 0, "background-color": "#e37d16a6"}).animate({
              width: '100%'
            }, {
              duration: parseInt(data.duration),
              complete: function() {
                $(".progress-container").fadeOut('fast', function() {
                    $('#progress-bar').removeClass('cancellable');
                    $("#progress-bar").css("width", 0);
                    $.post('http://pepe-progressbar/FinishAction', JSON.stringify({
                        })
                    );
                })
              }
            });
        });
    };
    
    Progressbar.ProgressCancel = function() {
        $("#progress-label").text("Canceled..");
        $("#progress-bar").stop().css( {"width": "100%", "background-color": "rgba(71, 0, 0, 0.8)"});
        $('#progress-bar').removeClass('cancellable');

        cancelledTimer = setTimeout(function () {
            $(".progress-container").fadeOut('fast', function() {
                $("#progress-bar").css("width", 0);
                $.post('http://pepe-progressbar/CancelAction', JSON.stringify({
                    })
                );
            });
        }, 1000);
    };

    Progressbar.CloseUI = function() {
        $('.main-container').fadeOut('fast');
    };
    
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case 'progress':
                Progressbar.Progress(event.data);
                break;
            case 'cancel':
                Progressbar.ProgressCancel();
                break;
        }
    });
});