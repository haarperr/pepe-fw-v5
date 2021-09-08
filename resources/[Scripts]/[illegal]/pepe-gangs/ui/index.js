function nuiMessage(data) {
    console.log(JSON.stringify(data));
    $.post(`https://${GetParentResourceName()}/message`, JSON.stringify(data));
}


var app = new Vue({
    el: '.container',
    data: {
      menu: false,
      history: [],
      grades: [],
      nearby: [],
      members: [],
      vehicles: [],
      alertID: 0,
      selected: false,
      isBoss: false,
      money: 0,
      menuLabel: "Gang Menu",
    },
    methods: {
      to: function (menu) {
        if (this.menu !== false) {
            app.history.push(this.menu);
            $(".menu#" + this.menu).slideUp();
        }

        this.menu = menu;
        if (this.menu !== undefined && this.menu !== false && this.menu !== "0") {
            $(".menu#" + this.menu).slideDown();

            if (menu == "management") {
                this.history = [];
            }
        } else {
            nuiMessage({
                action: "close"
            })
        }
      }
    }
})

$(".item, i").click(function() {
    let element = $(this);
    let menu = element.attr("to");
    if (menu !== undefined) {
        app.to(menu);
    }
});

function AddMember(block) {
    let element = $(block);
    let id = element.attr("id");
    if (id !== undefined) {
        app.selected = { 'id': id };
        app.to("manage_grade");
    }
}

function ManageMember(block) {
    let element = $(block);
    let id = element.attr("id");
    let name = element.attr("name");
    let grade = element.attr("grade");
    let editable = element.attr("editable");
    if (id !== undefined && name !== undefined && grade !== undefined && editable == "1") {
        app.selected = { 'id': id, 'grade': grade, 'name': name };
        app.to("manage_member");
    }
}

function SelectGrade(block) {
    let element = $(block);
    let id = app.selected.id;
    let grade = element.attr("grade");
    if (id !== undefined && grade !== undefined) {
        nuiMessage({
            action: "update_grade",
            member: id,
            grade: grade
        })
        app.selected = false;
        app.to("management");
    }
}

function MemberAction(block) {
    let element = $(block);
    let id = app.selected.id;
    let action = element.attr("action");
    if (id !== undefined && action == "remove") {
        nuiMessage({
            action: "update_grade",
            member: id,
            grade: "none"
        })
        app.selected = false;
        app.to("management");
    } else if (action == "grade") {
        app.to("manage_grade");
    }
}

function SpawnVehicle(block) {
    let element = $(block);
    let model = element.attr("model");
    if (model !== undefined) {
        nuiMessage({
            action: "spawn_vehicle",
            model: model
        })
        app.to(false);
        nuiMessage({
            action: "close"
        })
    }
}

function Withdraw() {
    nuiMessage({
        action: "withdraw",
        amount: $(".menu#moneysafe #amount").val()
    })
}

function Deposit() {
    nuiMessage({
        action: "deposit",
        amount: $(".menu#moneysafe #amount").val()
    })
}

window.addEventListener("message", function(event) {
    let data = event.data;

    if (data.menu !== undefined) {
        app.to(data.menu);
    }

    if (data.members !== undefined) {
        app.members = data.members;
    }

    if (data.nearby !== undefined) {
        app.nearby = data.nearby;
    }

    if (data.grades !== undefined) {
        app.grades = data.grades;
    }

    if (data.money !== undefined) {
        app.money = data.money;
    }

    if (data.vehicles !== undefined) {
        app.vehicles = data.vehicles;
    }    
    
    if (data.isBoss !== undefined) {
        app.isBoss = data.isBoss;
    }

    if (data.label !== undefined) {
        app.menuLabel = data.label;
    }

    if (data.color !== undefined) {
        $(".menu .help").css("border-color", `RGB(${data.color[0]}, ${data.color[1]} , ${data.color[2]})`);
    }

    if (data.alert !== undefined) {
        let id = app.alertID + 1;
        app.alertID = id;
        $(".alerts").append(`<div class="alert w3-animate-left" id='${app.alertID}'><i class="${data.alert.icon}"></i> ${data.alert.label}</div>`);
        setTimeout(() => {
            let element = $(".alerts .alert#" + id);
            element.fadeOut(500);
            setTimeout(() => {
                element.remove();
            }, 1000);
        }, 3500);
    }
})