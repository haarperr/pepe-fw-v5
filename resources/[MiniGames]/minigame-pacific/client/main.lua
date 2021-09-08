KCore = nil

Citizen.CreateThread(function()
	while KCore == nil do
		TriggerEvent('KCore:GetObject', function(obj) KCore = obj end)
		Citizen.Wait(0)
	end
end)

local display2 = false

RegisterCommand("game3", function(source, args)
    GameCallback = callback
    SetDisplay2(true)
end)

RegisterCommand("off3", function(source, args)
    SetDisplay2(false)
end)

RegisterNUICallback("exit", function(data,cb)
    SetDisplay2(false)
    cb("ok")
end)

RegisterNUICallback("main3", function(data,cb)
    SetDisplay2(true)
    cb("ok")
    print("SHOWED.")
end)

function SetDisplay2(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display2 do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)


AddEventHandler('kwk-mingame2:client:result', function(callback)
    result = callback
    if result then
        print('Winner - HighDevelopment.eu to buy Pepe Framework!')
        print('Winner - HighDevelopment.eu to buy Pepe Framework!')
        print('Winner - HighDevelopment.eu to buy Pepe Framework!')
        print('Winner - HighDevelopment.eu to buy Pepe Framework!')
    else
        print('Loser - HighDevelopment.eu to buy Pepe Framework!')
        print('Loser - HighDevelopment.eu to buy Pepe Framework!')
        print('Loser - HighDevelopment.eu to buy Pepe Framework!')
        print('Loser - HighDevelopment.eu to buy Pepe Framework!')
    end

    TriggerEvent("debug", 'Mingame2: End Game Results Shown', 'success')
end)

RegisterNUICallback('callback', function(data, cb)
    SetDisplay2(false)
    TriggerEvent('kwk-mingame2:client:result', data.success)
    cb('ok')
end)