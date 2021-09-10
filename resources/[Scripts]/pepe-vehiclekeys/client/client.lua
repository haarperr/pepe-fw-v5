Framework = nil

local IsRobbing = false
local LastVehicle = nil
local isLoggedIn = false

local HasKey = false



local IsHotwiring = false
local NeededAttempts = 0
local SucceededAttempts = 0
local FailedAttemps = 0
local AlertSend = false


RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
  Citizen.SetTimeout(1250, function()
      TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
      Citizen.Wait(100)
      Framework.Functions.TriggerCallback("pepe-vehiclekeys:server:get:key:config", function(config)
          Config = config
      end)
      isLoggedIn = true
  end)
end)

-- Code

-- // Loops \\ --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if isLoggedIn then
        local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
        if IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), true), -1) == PlayerPedId() then
            if LastVehicle ~= Vehicle then
            Framework.Functions.TriggerCallback("pepe-vehiclekeys:server:has:keys", function(HasKey)
                if HasKey then
                    HasCurrentKey = true
                    SetVehicleEngineOn(Vehicle, true, false, true)
                else 
                    HasCurrentKey = false
                    SetVehicleEngineOn(Vehicle, false, false, true)
                end
                LastVehicle = Vehicle
            end, Plate)  
            else
            Citizen.Wait(750)
          end
        else
            Citizen.Wait(750)
        end
        if not HasCurrentKey and IsPedInAnyVehicle(PlayerPedId(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(-1), false), -1) == PlayerPedId(-1) and Framework ~= nil and not IsHotwiring then
            local veh = GetVehiclePedIsIn(PlayerPedId(-1), false)
            SetVehicleEngineOn(veh, false, false, true)
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            local vehpos = GetOffsetFromEntityInWorldCoords(veh, 0, 1.5, 0.5)
            Framework.Functions.DrawText3D(vehpos.x, vehpos.y, vehpos.z, "~d~[Tap] ~w~Nhấn Tap để dùng lockpick")
            SetVehicleEngineOn(veh, false, false, true)


        end
     end
    end
end)
function Hotwire()
    if not HasKey then
        LockpickIgnition(false)
    end
end

RegisterNetEvent('lockpicks:UseLockpick')
AddEventHandler('lockpicks:UseLockpick', function(isAdvanced)
    if (IsPedInAnyVehicle(GetPlayerPed(-1))) then
        if not HasKey then
            LockpickIgnition(isAdvanced)
        end
    else
        LockpickDoor(isAdvanced)
    end
end)

--Use Lockpick 
function LockpickIgnition(isAdvanced)
    local Skillbar = exports['pepe-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = 3
    end
    if not HasKey then 
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        if vehicle ~= nil and vehicle ~= 0 then
            if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
                IsHotwiring = true
                SucceededAttempts = 0
                PoliceCall()

                if isAdvanced then
                    local maxwidth = 10
                    local maxduration = 1750
                    if FailedAttemps == 1 then
                        maxwidth = 10
                        maxduration = 1750
                    elseif FailedAttemps == 2 then
                        maxwidth = 9
                        maxduration = 1750
                    elseif FailedAttemps >= 3 then
                        maxwidth = 8
                        maxduration = 1750
                    end
                    widthAmount = math.random(5, maxwidth)
                    durationAmount = math.random(200, maxduration)
                else        
                    local maxwidth = 10
                    local maxduration = 1750
                    if FailedAttemps == 1 then
                        maxwidth = 9
                        maxduration = 1750
                    elseif FailedAttemps == 2 then
                        maxwidth = 8
                        maxduration = 1750
                    elseif FailedAttemps >= 3 then
                        maxwidth = 7
                        maxduration = 1750
                    end
                    widthAmount = math.random(5, maxwidth)
                    durationAmount = math.random(200, maxduration)
                end

                local dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
                local anim = "machinic_loop_mechandplayer"

                RequestAnimDict(dict)
                while not HasAnimDictLoaded(dict) do
                    RequestAnimDict(dict)
                    Citizen.Wait(100)
                end

                Skillbar.Start({
                    duration = math.random(5000, 5100),
                    pos = math.random(10, 15),
                    width = math.random(10, 11),
                }, function()
                    if IsHotwiring then
                        if IsHotwiring and NeededAttempts == 0 then
                            ClearPedTasksImmediately(GetPlayerPed(-1))
                            HasKey = false
                            SetVehicleEngineOn(vehicle, false, false, false)
                            Framework.Functions.Notify("يجب أن تكون في المركبة", "error")
                            IsHotwiring = false
                            FailedAttemps = 0
                            SucceededAttempts = 0
                            NeededAttempts = 0
                            TriggerServerEvent('pepe-hud:Server:GainStress', math.random(3, 5))
                            return
                        end
                                                if SucceededAttempts + 1 >= NeededAttempts then
                            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
                            if vehicle ~= nil and vehicle ~= 0 then
                                StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                                Framework.Functions.Notify("لقد نجحت")
                                HasKey = true
                                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                                IsHotwiring = false
                                FailedAttemps = 0
                                SucceededAttempts = 0
                                NeededAttempts = 0
--                               FreezeEntityPosition(vehicle, false)
                                TriggerServerEvent('pepe-hud:Server:GainStress', math.random(1, 4))
                            else
                                ClearPedTasksImmediately(GetPlayerPed(-1))
                                HasKey = false
                                SetVehicleEngineOn(vehicle, false, false, false)
                                Framework.Functions.Notify("يجب أن تكون في المركبة", "error")
                                IsHotwiring = false
                                FailedAttemps = 0
                                SucceededAttempts = 0
                                NeededAttempts = 0
                                TriggerServerEvent('pepe-hud:Server:GainStress', math.random(3, 5))
                            end
                        else
                            if vehicle ~= nil and vehicle ~= 0 then
                                TaskPlayAnim(GetPlayerPed(-1), dict, anim, 8.0, 8.0, -1, 16, -1, false, false, false)
                                if isAdvanced then
                                    local maxwidth = 10
                                    local maxduration = 1750
                                    if FailedAttemps == 1 then
                                        maxwidth = 10
                                        maxduration = 1750
                                    elseif FailedAttemps == 2 then
                                        maxwidth = 9
                                        maxduration = 1750
                                    elseif FailedAttemps >= 3 then
                                        maxwidth = 8
                                        maxduration = 1750
                                    end
                                    widthAmount = math.random(5, maxwidth)
                                    durationAmount = math.random(400, maxduration)
                                else        
                                    local maxwidth = 10
                                    local maxduration = 1750
                                    if FailedAttemps == 1 then
                                        maxwidth = 9
                                        maxduration = 1750
                                    elseif FailedAttemps == 2 then
                                        maxwidth = 8
                                        maxduration = 1750
                                    elseif FailedAttemps >= 3 then
                                        maxwidth = 7
                                        maxduration = 1750
                                    end
                                    widthAmount = math.random(5, maxwidth)
                                    durationAmount = math.random(300, maxduration)
                                end

                                SucceededAttempts = SucceededAttempts + 1
                                Skillbar.Repeat({
                                    duration = durationAmount,
                                    pos = math.random(10, 20),
                                    width = widthAmount,
                                })
                            else
                                ClearPedTasksImmediately(GetPlayerPed(-1))
                                HasKey = false
                                SetVehicleEngineOn(vehicle, false, false, false)
                                Framework.Functions.Notify("يجب أن تكون في المركبة", "error")
                                IsHotwiring = false
                                FailedAttemps = FailedAttemps + 1
                                local c = math.random(2)
                                local o = math.random(2)
                                if c == o then
                                    TriggerServerEvent('pepe-hud:Server:GainStress', math.random(1, 4))
                                end
                            end
                        end
                    end
                end, function()
                    if IsHotwiring then
                        StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
                        HasKey = false
                        SetVehicleEngineOn(vehicle, false, false, true)
                        Framework.Functions.Notify("لقد فشلت", "error")
                        IsHotwiring = false
                        FailedAttemps = FailedAttemps + 1
                        local c = math.random(2)
                        local o = math.random(2)
                        if c == o then
                            TriggerServerEvent('pepe-hud:Server:GainStress', math.random(1, 3))
                        end
                    end
                end)
                if (math.random(1,10) == 5) then
                    TriggerServerEvent('Framework:Server:RemoveItem', "lockpick", 1)
                    TriggerEvent("inventory:client:ItemBox", Framework.Shared.Items["lockpick"], "remove")
                    Framework.Functions.Notify("Lockpick mở khóa đã gỡ!", "error")
                end
            end
        end
    end
end
--end lockpick--





Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7)
        if isLoggedIn then
            if not IsRobbing then 
                if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= nil and GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 then
                    local Vehicle = GetVehiclePedIsTryingToEnter(PlayerPedId())
                    local Driver = GetPedInVehicleSeat(Vehicle, -1)
                    if Driver ~= 0 and not IsPedAPlayer(Driver) then
                       if IsEntityDead(Driver) then
                           IsRobbing = true
                           Framework.Functions.Progressbar("rob_keys", "Đang cướp chìa khóa xe...", 3000, false, true,
                            {}, {}, {}, {}, function()
                              SetVehicleKey(GetVehicleNumberPlateText(Vehicle, true), true)
                              IsRobbing = false
                           end) 
                       end
                    end
                end
             else
                Citizen.Wait(10)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if isLoggedIn then
            if IsControlJustReleased(1, Config.Keys["L"]) then
                ToggleLocks()
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('pepe-vehiclekeys:client:toggle:engine')
AddEventHandler('pepe-vehiclekeys:client:toggle:engine', function()
 local EngineOn = IsVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()))
 local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
 local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
 Framework.Functions.TriggerCallback("pepe-vehiclekeys:server:has:keys", function(HasKey)
     if HasKey then
         if EngineOn then
             SetVehicleEngineOn(Vehicle, false, false, true)
         else
             SetVehicleEngineOn(Vehicle, true, false, true)
         end
     else
         Framework.Functions.Notify("Bạn không có chìa khóa cho phương tiện này.", 'error')
     end
 end, Plate)
end)

RegisterNetEvent('pepe-vehiclekeys:client:set:keys')
AddEventHandler('pepe-vehiclekeys:client:set:keys', function(Plate, CitizenId, bool)
    Config.VehicleKeys[Plate] = {['CitizenId'] = CitizenId, ['HasKey'] = bool}
    LastVehicle = nil
end)

RegisterNetEvent('pepe-vehiclekeys:client:give:key')
AddEventHandler('pepe-vehiclekeys:client:give:key', function(TargetPlayer)
    local Vehicle, VehDistance = Framework.Functions.GetClosestVehicle()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    Framework.Functions.TriggerCallback("pepe-vehiclekeys:server:has:keys", function(HasKey)
        if HasKey then
            if Player ~= -1 and Player ~= 0 and Distance < 2.3 then
                 Framework.Functions.Notify("Bạn có chìa khóa với biển số xe: "..Plate, 'success')
                 TriggerServerEvent('pepe-vehiclekeys:server:give:keys', GetPlayerServerId(Player), Plate, true)
            else
                Framework.Functions.Notify("Không có ai gần đó?", 'error')
            end
        else
            Framework.Functions.Notify("Bạn không có chìa khóa cho phương tiện này.", 'error')
        end
    end, Plate)
end)

-- RegisterNetEvent('pepe-items:client:use:lockpick')
-- AddEventHandler('pepe-items:client:use:lockpick', function(IsAdvanced)
-- --     if (IsPedInAnyVehicle(GetPlayerPed(-1))) then
-- --         if not HasKey then
-- --             LockpickIgnition(isAdvanced)
-- --         end        
-- --         else
-- --             HasKey = false
-- --         SetVehicleEngineOn(veh, false, false, true)

-- -- function LockpickIgnition(IsAdvanced)

-- -- end
--  local Vehicle, VehDistance = Framework.Functions.GetClosestVehicle()
--  local Plate = GetVehicleNumberPlateText(Vehicle)
--  local VehicleLocks = GetVehicleDoorLockStatus(Vehicle)
--  if VehDistance <= 4.5 then
--    Framework.Functions.TriggerCallback("pepe-vehiclekeys:server:has:keys", function(HasKey)
--       if not HasKey then
--        if IsPedInAnyVehicle(PlayerPedId(), false) then
--           exports['pepe-assets']:RequestAnimationDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
--           TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,3.0, 3.0, -1, 16, 0, false, false, false)
--           exports['pepe-lockpick']:OpenLockpickGame(function(Success)
--             -- TriggerEvent('pepe-lockpick:client:openLockpick', function(Success)
--         --     exports['pepe-lockpick']:StartLockPickCircle(function(Success)
--             exports['pepe-lockpick']:openLockpick(function(Success)
--              if Success then
--                  SetVehicleKey(Plate, true)
--                  StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
--              else
--                   if IsAdvanced then
--                     if math.random(1,100) < 19 then
--                       TriggerServerEvent('Framework:Server:RemoveItem', 'advancedlockpick', 1)
--                       TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['advancedlockpick'], "remove")
--                     end
--                   else
--                     if math.random(1,100) < 35 then
--                       TriggerServerEvent('Framework:Server:RemoveItem', 'lockpick', 1)
--                       TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['lockpick'], "remove")
--                     end
--                   end
--                  Framework.Functions.Notify("Mislukt.", 'error')
--                  StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
--              end
--           end)
--        else
--           if VehicleLocks == 2 then
--           exports['pepe-assets']:RequestAnimationDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
--           TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,3.0, 3.0, -1, 16, 0, false, false, false)
--         --  exports['pepe-lockpick']:StartLockPickCircle(function(Success)
--         exports['pepe-lockpick']:openLockpick(function(Success)
--             TriggerEvent('pepe-lockpick:client:openLockpick', function(Success)
--              if Success then
--                  SetVehicleDoorsLocked(Vehicle, 1)
--                  Framework.Functions.Notify("Deur opengebroken", 'success')
--                  TriggerEvent('pepe-vehicleley:client:blink:lights', Vehicle)
--                  TriggerServerEvent("pepe-sound:server:play:distance", 5, "car-unlock", 0.2)
--                  StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
--              else
--                 if IsAdvanced then
--                     if math.random(1,100) < 25 then
--                       TriggerServerEvent('Framework:Server:RemoveItem', 'advancedlockpick', 1)
--                       TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['advancedlockpick'], "remove")
--                     end
--                   else
--                     if math.random(1,100) < 35 then
--                       TriggerServerEvent('Framework:Server:RemoveItem', 'lockpick', 1)
--                       TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['lockpick'], "remove")
--                     end
--                 end
--                 Framework.Functions.Notify("Mislukt.", 'error')
--                 StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
--              end
--            end)
--           end
--        end
--       end
--    end, Plate)  
--  end

-- end)
-- end)


-- // Lockpick \\ --






-- // Functions \\ --

function SetVehicleKey(Plate, bool)
 TriggerServerEvent('pepe-vehiclekeys:server:set:keys', Plate, bool)
end

function ToggleLocks()
 local Vehicle, VehDistance = Framework.Functions.GetClosestVehicle()
 if Vehicle ~= nil and Vehicle ~= 0 then
    local VehicleCoords = GetEntityCoords(Vehicle)
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local VehicleLocks = GetVehicleDoorLockStatus(Vehicle)
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if VehDistance <= 2.2 then
        Framework.Functions.TriggerCallback("pepe-vehiclekeys:server:has:keys", function(HasKey)
         if HasKey then
            exports['pepe-assets']:RequestAnimationDict("anim@mp_player_intmenu@key_fob@")
            TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', 'fob_click' ,3.0, 3.0, -1, 49, 0, false, false, false)
            if VehicleLocks == 1 then
                Citizen.Wait(450)
                SetVehicleDoorsLocked(Vehicle, 2)
                ClearPedTasks(PlayerPedId())
                TriggerEvent('pepe-vehicleley:client:blink:lights', Vehicle)
                Framework.Functions.Notify("Phương tiện đã khoá!", 'error')
                TriggerServerEvent("pepe-sound:server:play:distance", 5, "car-lock", 0.2)
            else
                Citizen.Wait(450)
                SetVehicleDoorsLocked(Vehicle, 1)
                ClearPedTasks(PlayerPedId())
                TriggerEvent('pepe-vehicleley:client:blink:lights', Vehicle)
                Framework.Functions.Notify("Phương tiện đã mở khoá", 'success')
                TriggerServerEvent("pepe-sound:server:play:distance", 5, "car-unlock", 0.2)
            end
         else
            Framework.Functions.Notify("Bạn không có chìa khóa cho phương tiện này.", 'error')
        end
    end, Plate)
    end
 end
end

RegisterNetEvent('pepe-vehicleley:client:blink:lights')
AddEventHandler('pepe-vehicleley:client:blink:lights', function(Vehicle)
 SetVehicleLights(Vehicle, 2)
 SetVehicleBrakeLights(Vehicle, true)
 SetVehicleInteriorlight(Vehicle, true)
 SetVehicleIndicatorLights(Vehicle, 0, true)
 SetVehicleIndicatorLights(Vehicle, 1, true)
 Citizen.Wait(450)
 SetVehicleIndicatorLights(Vehicle, 0, false)
 SetVehicleIndicatorLights(Vehicle, 1, false)
 Citizen.Wait(450)
 SetVehicleInteriorlight(Vehicle, true)
 SetVehicleIndicatorLights(Vehicle, 0, true)
 SetVehicleIndicatorLights(Vehicle, 1, true)
 Citizen.Wait(450)
 SetVehicleLights(Vehicle, 0)
 SetVehicleBrakeLights(Vehicle, false)
 SetVehicleInteriorlight(Vehicle, false)
 SetVehicleIndicatorLights(Vehicle, 0, false)
 SetVehicleIndicatorLights(Vehicle, 1, false)
end)