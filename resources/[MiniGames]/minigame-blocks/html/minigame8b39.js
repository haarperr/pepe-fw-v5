let timer_start, timer_game, timer_finish, timer_time, good_positions, wrong, right, speed, timerStart;
let game_started = false;
let streak = 0;
let max_streak = 0;
let best_time = 10;

// Get max streak from cookie
const regex = /max-streak_thermite=([\d]+)/g;
let cookie = document.cookie;
if((cookie = regex.exec(cookie)) !== null){
    max_streak = cookie[1];
}
// Get max streak from cookie
const regex_time = /best-time_thermite=([\d.]+)/g;
cookie = document.cookie;
if((cookie = regex_time.exec(cookie)) !== null){
    best_time = parseFloat(cookie[1]);
}

const sleep = (ms, fn) => {return setTimeout(fn, ms)};

const range = (start, end, length = end - start + 1) => {
    return Array.from({length}, (_, i) => start + i)
}

const shuffle = (arr) => {
    for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        const temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
}

let positions = range(0, 35);

// document.querySelector('#speed').addEventListener('input', function(ev){
//     document.querySelector('.speed_value').innerHTML = ev.target.value;
// });


$(function() {

    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }
    display(false)
    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
                start();
            } else {
                display(false)
            }
        }
    })
    document.onkeyup = function (data) 
    {
        if (data.which == 27) 
        {
            $.post('http://game2/exit', JSON.stringify({}));
            console.log('ESC Key pressed');
            reset();
        }

    };

})
function listener(ev){
    if(!game_started) return;

    if( good_positions.indexOf( parseInt(ev.target.dataset.position) ) === -1 ){
        wrong++;
        ev.target.classList.add('bad');
    }else{
        right++;
        ev.target.classList.add('good');
    }

    ev.target.removeEventListener('mousedown', listener);

    check();
}

function addListeners(){
    document.querySelectorAll('.group').forEach(el => {
        el.addEventListener('mousedown', listener);
    });
}

function check(){
    if(wrong === 3){
        resetTimer();
        game_started = false;
        streak = 0;

        let blocks = document.querySelectorAll('.group');
        good_positions.forEach( pos => {
            blocks[pos].classList.add('proper');
        });
        Fault();
        // return;
        reset();
    }
    if(right === 3){
    
        stopTimer();
        streak++;
        if(streak > max_streak){
            max_streak = streak;
            document.cookie = "max-streak_thermite="+max_streak;
            //$.post('http://game2/callback');
            Result();
            
        game_started = false;
        }
        let time = document.querySelector('.streaks .time').innerHTML;
        if(parseFloat(time) < best_time){
            best_time = parseFloat(time);
            document.cookie = "best-time_thermite="+best_time;
        }
        // let leaderboard = new XMLHttpRequest();
        // leaderboard.open("HEAD", 'streak.php?streak='+streak+'&max_streak='+max_streak+'&speed='+speed+'&time='+time);
        // leaderboard.send();
        reset();
    }
}

function Fault() {
    gameOver = true;
    game_started = false;
    wrong = 0;
    right = 0;
    $.post('http://game2/callback', JSON.stringify({
        success: false
    }));
}
function Result() {
    gameOver = true;
    game_started = false;
    wrong = 0;
    right = 0;
    $.post('http://game2/callback', JSON.stringify({
        success: true
    }));
}

function reset(){
    game_started = false;

    resetTimer();
    clearTimeout(timer_start);
    clearTimeout(timer_game);
    clearTimeout(timer_finish);

    document.querySelector('.splash').classList.remove('hidden');
    document.querySelector('.groups').classList.add('hidden');

    document.querySelectorAll('.group').forEach(el => { el.remove(); });

    //start();
}

function start(){
    wrong = 0;
    right = 0;

    shuffle(positions);
    good_positions = positions.slice(0, 3);

    let div = document.createElement('div');
    div.classList.add('group');
    const groups = document.querySelector('.groups');
    for(let i=0; i<36; i++){
        let group = div.cloneNode();
        group.dataset.position = i.toString();
        groups.appendChild(group);
    }

    addListeners();

    //document.querySelector('.streak').innerHTML = streak;
    // document.querySelector('.max_streak').innerHTML = max_streak;
    // document.querySelector('.best_time').innerHTML = best_time;

    timer_start = sleep(2000, function(){
        document.querySelector('.splash').classList.add('hidden');
        document.querySelector('.groups').classList.remove('hidden');

        let blocks = document.querySelectorAll('.group');
        good_positions.forEach( pos => {
            blocks[pos].classList.add('good');
        });

        timer_game = sleep(4000, function(){
            document.querySelectorAll('.group.good').forEach(el => { el.classList.remove('good')});
            game_started = true;

            startTimer();
            speed = 8;
        });
    });
}

function startTimer(){
    timerStart = new Date();
    timer_time = setInterval(timer,1);
}
function timer(){
    let timerNow = new Date();
    let timerDiff = new Date();
    timerDiff.setTime(timerNow - timerStart);
    let ms = timerDiff.getMilliseconds();
    let sec = timerDiff.getSeconds();
    if (ms < 10) {ms = "00"+ms;}else if (ms < 100) {ms = "0"+ms;}
    document.querySelector('.streaks .time').innerHTML = sec+"."+ms;
}
function stopTimer(){
    clearInterval(timer_time);
}
function resetTimer(){
    clearInterval(timer_time);
    document.querySelector('.streaks .time').innerHTML = '0.000';
}

//start();