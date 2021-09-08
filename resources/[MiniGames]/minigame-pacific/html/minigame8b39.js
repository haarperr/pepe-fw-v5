let canvas = document.getElementById("canvas");
let ctx = canvas.getContext("2d");
let game_started = true;
let W = canvas.width;
let H = canvas.height;
let degrees = 0;
let new_degrees = 0;
let time = 0;
let color = "#ffffff";
let bgcolor = "#404b58";
let bgcolor2 = "#41a491";
let key_to_press;
let g_start, g_end;
let animation_loop;

let streak = 0;
let max_streak = 3;

function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1) + min); //The maximum is inclusive and the minimum is inclusive
}

function init() {
    // Clear the canvas every time a chart is drawn
    ctx.clearRect(0,0,W,H);

    // Background 360 degree arc
    ctx.beginPath();
    ctx.strokeStyle = bgcolor;
    ctx.lineWidth = 20;
    ctx.arc(W / 2, H / 2, 100, 0, Math.PI * 2, false);
    ctx.stroke();

    // Green zone
    ctx.beginPath();
    ctx.strokeStyle = bgcolor2;
    ctx.lineWidth = 20;
    ctx.arc(W / 2, H / 2, 100, g_start - 90 * Math.PI / 180, g_end - 90 * Math.PI / 180, false);
    ctx.stroke();

    // Angle in radians = angle in degrees * PI / 180
    let radians = degrees * Math.PI / 180;
    ctx.beginPath();
    ctx.strokeStyle = color;
    ctx.lineWidth = 20;
    ctx.arc(W / 2, H / 2, 100, 0 - 90 * Math.PI / 180, radians - 90 * Math.PI / 180, false);
    ctx.stroke();

    // Adding the key_to_press
    ctx.fillStyle = color;
    ctx.font = "100px sans-serif";
    let text_width = ctx.measureText(key_to_press).width;
    ctx.fillText(key_to_press, W / 2 - text_width / 2, H / 2 + 35);
}

function draw() {
        
    if(!game_started) return;
    if (typeof animation_loop !== undefined) clearInterval(animation_loop);

    document.querySelector('.stats .streak').innerHTML = streak;
    document.querySelector('.stats .max-streak').innerHTML = max_streak;

    g_start = getRandomInt(20,40) / 10;
    g_end = getRandomInt(5,10) / 10;
    g_end = g_start + g_end;

    degrees = 0;
    new_degrees = 360;

    key_to_press = ''+getRandomInt(1,4);

    time = getRandomInt(1, 3) * 5;

    animation_loop = setInterval(animate_to, time);

}

function animate_to() {
    if (degrees >= new_degrees) {
        console.log('Failed: timeout!');
        wrong();
        return;
    }

    degrees+=2;
    init();
}

function correct(){
    document.querySelector('.stats').classList.remove('wrong');
    if(streak > max_streak){
        max_streak = streak;
        $.post('http://game3/callback', JSON.stringify({
            success: true
        }));
    } else {
       draw();
       $.post('http://game3/callback', JSON.stringify({
        success: false
    }));
    }
    streak++;
    //draw();
}

function wrong(){
    document.querySelector('.stats').classList.add('wrong');
    if(streak > max_streak){
        max_streak = streak;
    game_started = false;
    } else {
    draw();
    }
    streak = 0;
}
function exit(){
    
}

function display2(bool) {
        if (bool) {
            draw();
            //$("#container").show();
            
        game_started = true;
        } else {
            exit()
            //$("#container").hide();
            
        game_started = false;
        }
}

display2(false)
window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display2(true)
                game_started = true;
                
            } else {
                display2(false)
                game_started = false;
            }
        }
})


document.onkeyup = function (data) 
{
    if (data.which == 27) 
    {
        console.log('ESC Key pressed');
        display2(false)
            
    game_started = false;
    }

};

document.addEventListener("keydown", function(ev) {
    let key_pressed = ev.key;
    let valid_keys = ['1','2','3','4'];

    if( valid_keys.includes(key_pressed) ){
        if( key_pressed === key_to_press ){
            let d_start = (180 / Math.PI) * g_start;
            let d_end = (180 / Math.PI) * g_end;
            if( degrees < d_start ){
                console.log('Failed: Too soon!');
                wrong();
            }else if( degrees > d_end ){
                console.log('Failed: Too late!');
                wrong();
            }else{
                console.log('Success!');
                correct();
            }
        }else{
            console.log('Failed: Pressed '+key_pressed+' instead of '+key_to_press);
            wrong();
        }
    }
});

//draw();