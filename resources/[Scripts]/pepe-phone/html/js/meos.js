var CurrentMeosPage = null;
var OpenedPerson = null;

$(document).on('click', '.meos-block', function(e){
    e.preventDefault();
    var PressedBlock = $(this).data('meosblock');
    OpenMeosPage(PressedBlock);
});

OpenMeosPage = function(page) {
    CurrentMeosPage = page;
    $(".meos-"+CurrentMeosPage+"-page").css({"display":"block"});
    $(".meos-homescreen").animate({
        left: 30+"vh"
    }, 200);
    $(".meos-tabs").animate({
        left: 0+"vh"
    }, 200, function(){
        $(".meos-tabs-footer").animate({
            bottom: 0,
        }, 200)
        if (CurrentMeosPage == "alerts") {
            $(".meos-recent-alert").removeClass("noodknop");
            $(".meos-recent-alert").css({"background-color":"#004682"}); 
        }
    });
}

SetupMeosHome = function() {
    $("#meos-app-name").html("Welcome " + QB.Phone.Data.PlayerData.charinfo.firstname + " " + QB.Phone.Data.PlayerData.charinfo.lastname);
}

MeosHomePage = function() {
    $(".meos-tabs-footer").animate({
        bottom: -5+"vh"
    }, 200);
    setTimeout(function(){
        $(".meos-homescreen").animate({
            left: 0+"vh"
        }, 200, function(){
            if (CurrentMeosPage == "alerts") {
                $(".meos-alert-new").remove();
            }
            $(".meos-"+CurrentMeosPage+"-page").css({"display":"none"});
            CurrentMeosPage = null;
            $(".person-search-results").html("");
            $(".vehicle-search-results").html("");
        });
        $(".meos-tabs").animate({
            left: -30+"vh"
        }, 200);
    }, 400);
}

$(document).on('click', '.meos-tabs-footer', function(e){
    e.preventDefault();
    MeosHomePage();
});

$(document).on('click', '.person-search-result', function(e){
    e.preventDefault();

    var ClickedPerson = this;
    var ClickedPersonId = $(this).attr('id');
    var ClickedPersonData = $("#"+ClickedPersonId).data('PersonData');

    var Gender = "Male";
    if (ClickedPersonData.gender == 1) {
        Gender = "Female";
    }
    var HasLicense = "Yes";
    if (!ClickedPersonData.driverlicense) {
        HasLicense = "No";
    }
    var appartmentid = {};
    if (ClickedPersonData.appartmentid) {
        appartmentid = ClickedPersonData.appartmentid;
    }

    var OpenElement = '<div class="person-search-result-name">Name: '+ClickedPersonData.firstname+' '+ClickedPersonData.lastname+'</div> <div class="person-search-result-bsn">CID: '+ClickedPersonData.citizenid+'</div> <div class="person-opensplit"></div> &nbsp; <div class="person-search-result-dob">Day of birth: '+ClickedPersonData.birthdate+'</div> <div class="person-search-result-number">Telephone number: '+ClickedPersonData.phone+'</div> <div class="person-search-result-nationality">Nationality: '+ClickedPersonData.nationality+'</div> <div class="person-search-result-gender">Gender: '+Gender+'</div> <div class="person-search-result-driverslicense">Drivers license: '+HasLicense+'</div> &nbsp; <div class="person-search-result-apartment"><span id="'+ClickedPersonId+'">Apartment: ' +ClickedPersonData.appartmentname+ ' ('+ClickedPersonData.appartmentid+')</span> &nbsp; ';

    if (OpenedPerson === null) {
        $(ClickedPerson).html(OpenElement)
        OpenedPerson = ClickedPerson;
    } else if (OpenedPerson == ClickedPerson) {
        var PreviousPersonId = $(OpenedPerson).attr('id');
        var PreviousPersonData = $("#"+PreviousPersonId).data('PersonData');
        var PreviousElement = '<div class="person-search-result-name">Name: '+PreviousPersonData.firstname+' '+PreviousPersonData.lastname+'</div> <div class="person-search-result-bsn">CID: '+PreviousPersonData.citizenid+'</div>';
        $(ClickedPerson).html(PreviousElement)
        OpenedPerson = null;
    } else {
        var PreviousPersonId = $(OpenedPerson).attr('id');
        var PreviousPersonData = $("#"+PreviousPersonId).data('PersonData');
        var PreviousElement = '<div class="person-search-result-name">Name: '+PreviousPersonData.firstname+' '+PreviousPersonData.lastname+'</div> <div class="person-search-result-bsn">CID: '+PreviousPersonData.citizenid+'</div>';
        $(OpenedPerson).html(PreviousElement)
        $(ClickedPerson).html(OpenElement)
        OpenedPerson = ClickedPerson;
    }
});


$(document).on('click', '.confirm-search-person-test', function(e){
    e.preventDefault();
    var SearchName = $(".person-search-input").val();

    if (SearchName !== "") {
        $.post('http://pepe-phone/FetchSearchResults', JSON.stringify({
            input: SearchName,
        }), function(result){
            if (result != null) {
                $(".person-search-results").html("");
                $.each(result, function (i, person) {
                    var PersonElement = '<div class="person-search-result" id="person-'+i+'"><div class="person-search-result-name">Name: '+person.firstname+' '+person.lastname+'</div> <div class="person-search-result-bsn">CID: '+person.citizenid+'</div> </div>';
                    $(".person-search-results").append(PersonElement);
                    $("#person-"+i).data("PersonData", person);
                });
            } else {
                QB.Phone.Notifications.Add("police", "MEOS", "There are no search results!");
                $(".person-search-results").html("");
            }
        });
    } else {
        QB.Phone.Notifications.Add("police", "MEOS", "There are no search results!");
        $(".person-search-results").html("");
    }
});

$(document).on('click', '.confirm-search-vehicle', function(e){
    e.preventDefault();
    var SearchName = $(".vehicle-search-input").val();
    
    if (SearchName !== "") {
        $.post('http://pepe-phone/FetchVehicleResults', JSON.stringify({
            input: SearchName,
        }), function(result){
            if (result != null) {
                $(".vehicle-search-results").html("");
                $.each(result, function (i, vehicle) {
                    var APK = "Yes";
                    if (!vehicle.status) {
                        APK = "No";
                    }
                    var Flagged = "No";
                    if (vehicle.isFlagged) {
                        Flagged = "Yes";
                    }
                    
                    var VehicleElement = '<div class="vehicle-search-result"> <div class="vehicle-search-result-name">'+vehicle.label+'</div> <div class="vehicle-search-result-plate">Kenteken: '+vehicle.plate+'</div> <div class="vehicle-opensplit"></div> &nbsp; <div class="vehicle-search-result-owner">Eigenaar: '+vehicle.owner+'</div> &nbsp; <div class="vehicle-search-result-apk">APK: '+APK+'</div> <div class="vehicle-search-result-warrant">Gesignaleerd: '+Flagged+'</div> </div>'
                    $(".vehicle-search-results").append(VehicleElement);
                });
            }
        });
    } else {
        QB.Phone.Notifications.Add("police", "MEOS", "There are no search results!");
        $(".vehicle-search-results").html("");
    }
});

$(document).on('click', '.scan-search-vehicle', function(e){
    e.preventDefault();
    $.post('http://pepe-phone/FetchVehicleScan', JSON.stringify({}), function(vehicle){
        if (vehicle != null) {
            $(".vehicle-search-results").html("");
            var APK = "Yes";
            if (!vehicle.status) {
                APK = "No";
            }
            var Flagged = "No";
            if (vehicle.isFlagged) {
                Flagged = "Yes";
            }

            var VehicleElement = '<div class="vehicle-search-result"> <div class="vehicle-search-result-name">'+vehicle.label+'</div> <div class="vehicle-search-result-plate">License Plate: '+vehicle.plate+'</div> <div class="vehicle-opensplit"></div> &nbsp; <div class="vehicle-search-result-owner">Owner: '+vehicle.owner+'</div> &nbsp; <div class="vehicle-search-result-apk">MOT: '+APK+'</div> <div class="vehicle-search-result-warrant">Signaled: '+Flagged+'</div> </div>'
            $(".vehicle-search-results").append(VehicleElement);
        } else {
            QB.Phone.Notifications.Add("police", "MEOS", "No vehicle nearby!");
            $(".vehicle-search-results").append("");
        }
    });
});

AddPoliceAlert = function(data) {
    var randId = Math.floor((Math.random() * 10000) + 1);
    var AlertElement = '';
    if (data.alert.coords != undefined && data.alert.coords != null) {
        AlertElement = '<div class="meos-alert" id="alert-'+randId+'"> <span class="meos-alert-new" style="margin-bottom: 1vh;">NEW</span> <p class="meos-alert-type">Notification: '+data.alert.title+'</p> <p class="meos-alert-description">'+data.alert.description+'</p> <hr> <div class="meos-location-button">LOCATION</div> </div>';
    } else {
        AlertElement = '<div class="meos-alert" id="alert-'+randId+'"> <span class="meos-alert-new" style="margin-bottom: 1vh;">NEW</span> <p class="meos-alert-type">Notification: '+data.alert.title+'</p> <p class="meos-alert-description">'+data.alert.description+'</p></div>';
    }
    $(".meos-recent-alerts").html('<div class="meos-recent-alert" id="recent-alert-'+randId+'"><span class="meos-recent-alert-title">Notification: '+data.alert.title+'</span><p class="meos-recent-alert-description">'+data.alert.description+'</p></div>');
    if (data.alert.title == "Colleague assistance") {
        $(".meos-recent-alert").css({"background-color":"#d30404"}); 
        $(".meos-recent-alert").addClass("emergency button");
    }
    $(".meos-alerts").prepend(AlertElement);
    $("#alert-"+randId).data("alertData", data.alert);
    $("#recent-alert-"+randId).data("alertData", data.alert);
}

$(document).on('click', '.meos-recent-alert', function(e){
    e.preventDefault();
    var alertData = $(this).data("alertData");

    if (alertData.coords != undefined && alertData.coords != null) {
        $.post('http://pepe-phone/SetAlertWaypoint', JSON.stringify({
            alert: alertData,
        }));
    } else {
        QB.Phone.Notifications.Add("police", "MEOS", "This Notification has no GPS Location!");
    }
});

$(document).on('click', '.meos-location-button', function(e){
    e.preventDefault();
    var alertData = $(this).parent().data("alertData");
    $.post('http://pepe-phone/SetAlertWaypoint', JSON.stringify({
        alert: alertData,
    }));
});

$(document).on('click', '.meos-clear-alerts', function(e){
    $(".meos-alerts").html("");
    $(".meos-recent-alerts").html('<div class="meos-recent-alert"> <span class="meos-recent-alert-title">You have no notifications!</span></div>');
    QB.Phone.Notifications.Add("police", "MEOS", "All Notifications have been removed!");
});