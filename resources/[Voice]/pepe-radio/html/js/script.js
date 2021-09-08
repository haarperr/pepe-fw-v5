$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "open") {
            DBRadio.SlideUp()
        }

        if (event.data.type == "close") {
            DBRadio.SlideDown()
        }
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://pepe-radio/escape', JSON.stringify({}));
            DBRadio.SlideDown()
        } else if (data.which == 13) { // Escape key
            $.post('http://pepe-radio/joinRadio', JSON.stringify({
                channel: $("#channel").val()
            }));
        }
    };
});

DBRadio = {}

$(document).on('click', '#submit', function(e){
    e.preventDefault();

    $.post('http://pepe-radio/joinRadio', JSON.stringify({
        channel: $("#channel").val()
    }));
});

$(document).on('click', '#disconnect', function(e){
    e.preventDefault();

    $.post('http://pepe-radio/leaveRadio');
});

DBRadio.SlideUp = function() {
    $(".container").css("display", "block");
    $(".radio-container").animate({bottom: "6vh",}, 250);
}

DBRadio.SlideDown = function() {
    $(".radio-container").animate({bottom: "-110vh",}, 400, function(){
        $(".container").css("display", "none");
    });
}