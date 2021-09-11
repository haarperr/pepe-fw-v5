Framework = nil

local IsRobbing = false
local LastVehicle = nil
local isLoggedIn = false

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
        if not HasCurrentKey and IsPedInAnyVehicle(PlayerPedId(), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId() then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            SetVehicleEngineOn(Vehicle, false, false, true)
        end
     end
    end
end)

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
                           Framework.Functions.Progressbar("rob_keys", "Cướp chìa khóa xe...", 3000, false, true,
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
                 Framework.Functions.Notify("You have keys with the current licenseplate: "..Plate, 'success')
                 TriggerServerEvent('pepe-vehiclekeys:server:give:keys', GetPlayerServerId(Player), Plate, true)
            else
                Framework.Functions.Notify("Không có ai gần đó?", 'error')
            end
        else
            Framework.Functions.Notify("Bạn không có chìa khoá cho phương tiện này.", 'error')
        end
    end, Plate)
end)

RegisterNetEvent('pepe-items:client:use:lockpick')
AddEventHandler('pepe-items:client:use:lockpick', function(IsAdvanced)
 local Vehicle, VehDistance = Framework.Functions.GetClosestVehicle()
 local Plate = GetVehicleNumberPlateText(Vehicle)
 local VehicleLocks = GetVehicleDoorLockStatus(Vehicle)
 if VehDistance <= 4.5 then
--    Framework.Functions.TriggerCallback("pepe-vehiclekeys:server:has:keys", function(HasKey)
      if not HasKey then
       if IsPedInAnyVehicle(PlayerPedId(), false) then
          exports['pepe-assets']:RequestAnimationDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
          TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,3.0, 3.0, -1, 16, 0, false, false, false)
          exports['pepe-lockpick']:OpenLockpickGame(function(Success)
            TriggerEvent('pepe-lockpick:client:openLockpick', function(Success)
            -- exports['pepe-lock']:StartLockPickCircle(function(Success)
                -- exports['pepe-lockpick']:StartLockPickCircle(function(Success)
             if Success then
                 SetVehicleKey(Plate, true)
                 StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             else
                  if IsAdvanced then
                    if math.random(1,100) < 19 then
                      TriggerServerEvent('Framework:Server:RemoveItem', 'advancedlockpick', 1)
                      TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['advancedlockpick'], "remove")
                    end
                  else
                    if math.random(1,100) < 35 then
                      TriggerServerEvent('Framework:Server:RemoveItem', 'lockpick', 1)
                      TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['lockpick'], "remove")
                    end
                  end
                 Framework.Functions.Notify("Mislukt.", 'error')
                 StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             end
          end)
       else
          if VehicleLocks == 2 then
          exports['pepe-assets']:RequestAnimationDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
          TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,3.0, 3.0, -1, 16, 0, false, false, false)
        --  exports['pepe-lock']:StartLockPickCircle(function(Success)
            -- exports['pepe-lockpick']:StartLockPickCircle(function(Success)
            TriggerEvent('pepe-lockpick:client:openLockpick', function(Success)
             if Success then
                 SetVehicleDoorsLocked(Vehicle, 1)
                 Framework.Functions.Notify("Deur opengebroken", 'success')
                 TriggerEvent('pepe-vehicleley:client:blink:lights', Vehicle)
                 TriggerServerEvent("pepe-sound:server:play:distance", 5, "car-unlock", 0.2)
                 StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             else
                if IsAdvanced then
                    if math.random(1,100) < 25 then
                      TriggerServerEvent('Framework:Server:RemoveItem', 'advancedlockpick', 1)
                      TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['advancedlockpick'], "remove")
                    end
                  else
                    if math.random(1,100) < 35 then
                      TriggerServerEvent('Framework:Server:RemoveItem', 'lockpick', 1)
                      TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['lockpick'], "remove")
                    end
                end
                Framework.Functions.Notify("Mislukt.", 'error')
                StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
             end
           end)
          end
       end
      end
   end, Plate)  
 end
end)

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
                Framework.Functions.Notify("Vehicle locked", 'error')
                TriggerServerEvent("pepe-sound:server:play:distance", 5, "car-lock", 0.2)
            else
                Citizen.Wait(450)
                SetVehicleDoorsLocked(Vehicle, 1)
                ClearPedTasks(PlayerPedId())
                TriggerEvent('pepe-vehicleley:client:blink:lights', Vehicle)
                Framework.Functions.Notify("Vehicle unlocked", 'success')
                TriggerServerEvent("pepe-sound:server:play:distance", 5, "car-unlock", 0.2)
            end
         else
            Framework.Functions.Notify("Bạn không có chìa khoá cho phương tiện này.", 'error')
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