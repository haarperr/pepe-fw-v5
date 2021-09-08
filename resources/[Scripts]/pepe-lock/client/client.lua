Framework = nil
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if Framework == nil then
            TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
            Citizen.Wait(200)
        end
    end
end)
local Result = nil
local NUI_status = false

AddEventHandler('kwk-lockpick:client:openLockpick', function(callback)
    lockpickCallback = callback
    exports['pepe-lock']:StartLockPickCircle(total)
end)

function StartLockPickCircle(callback)
    if IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), true), -1) == PlayerPedId() then

    Result = nil
    NUI_status = true
    SendNUIMessage({
        action = 'start',
        value = 4,
    })
    while NUI_status do
        Wait(5)
        SetNuiFocus(NUI_status, NUI_status)
    end
    Wait(100)
    SetNuiFocus(false, false)
    lockpickCallback = callback
    print(lockpickCallback)
    return Result
end
end

RegisterNUICallback('fail', function()
        if math.random(1, 100) < 23 then
            TriggerServerEvent("Framework:Server:RemoveItem", "lockpick", 1)
            TriggerEvent('pepe-inventory:client:ItemBox', Framework.Shared.Items["lockpick"], "remove")
        end
        
        ClearPedTasks(PlayerPedId())
        Result = false
        Wait(100)
        NUI_status = false
        --print('fail')
end)


local openingDoor = false
RegisterNUICallback('success', function()
    local vehicle = Framework.Functions.GetClosestVehicle()
    if IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), true), -1) == PlayerPedId() then

        --if vehicle ~= nil then
        local lockpickTime = 2000
        LockpickDoorAnim(lockpickTime)
        Framework.Functions.Progressbar("veh_slot", "Forcing ignition..", lockpickTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "veh@break_in@0h@p_m_one@",
            anim = "low_force_entry_ds",
            flags = 16,
        }, {}, {}, function() -- Done
            openingDoor = false
            ClearPedTasks(PlayerPedId())
            Framework.Functions.Notify("Lockpick succesful!", 'success')
            HasKey = true
            SetVehicleDoorsLocked(Vehicle, 1)
            Framework.Functions.Notify("Vehicle lockpicked!", 'success')
            TriggerEvent('pepe-vehicleley:client:blink:lights', Vehicle)
            TriggerServerEvent("pepe-sound:server:play:distance", 5, "car-unlock", 0.2)
            StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
            IsHotwiring = false
            exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(vehicle), true)
            SetVehicleDoorsLocked(vehicle, 1)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            SetVehicleEngineOn(vehicle, false, false, true)

        end, function() -- Cancel
            openingDoor = false
            ClearPedTasks(PlayerPedId())
            Framework.Functions.Notify("Lockpick canceled..", "error")
        end)
        Citizen.CreateThread(function()
            while openingDoor do
                TriggerServerEvent('pepe-hud:Server:GainStress', math.random(1, 2))
                Citizen.Wait(10000)
            end
        end)
        Result = true
        Wait(100)
        NUI_status = false
        
    SetNuiFocus(false, false)
    print(Result)
    return Result
    end
end)


function LockpickDoorAnim(time)
    time = time / 1000
    loadAnimDict("veh@break_in@0h@p_m_one@")
    TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
    openingDoor = true
    Citizen.CreateThread(function()
        while openingDoor do
            TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Citizen.Wait(2000)
            time = time - 2
            if time <= 0 then
                openingDoor = false
                StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
            end
        end
    end)
end


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 0 )
    end
end
