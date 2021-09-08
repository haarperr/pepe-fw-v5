local DutyBlips = {}
local ShopItems = {}
local ObjectList = {}
local NearPoliceGarage = false
local NearPoliceImpound = false
local CurrentGarage = nil
local Locaties = {["Politie"] = {[1] = {["x"] = 473.78, ["y"] = -992.64, ["z"] = 26.27, ["h"] = 0.0}, [2] = {["x"] = -445.87, ["y"] = 6013.88, ["z"] = 31.71, ["h"] = 0.0}}}
local FingerPrintSession = nil
PlayerJob = {}
isLoggedIn = false
onDuty = false

Framework = nil
Citizen.CreateThread(function() 
    while Framework == nil do
        TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(500, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
      Citizen.Wait(450)
      Framework.Functions.GetPlayerData(function(PlayerData)
      PlayerJob, onDuty = PlayerData.job, PlayerData.job.onduty 
      if PlayerJob.name == 'police' and PlayerData.job.onduty then
       TriggerEvent('pepe-radialmenu:client:update:duty:vehicles')
       TriggerEvent('pepe-police:client:set:radio')
       TriggerServerEvent("pepe-police:server:UpdateBlips")
       TriggerServerEvent("pepe-police:server:UpdateCurrentCops")
      end
      isLoggedIn = true 
      SpawnIncheckProp()
      end)
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(500, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)  
     Citizen.Wait(3500)
     Framework.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata['tracker'] then
          TriggerEvent('pepe-police:client:set:tracker', true)
        end
        if PlayerData.metadata['ishandcuffed'] then
            TriggerServerEvent('pepe-sound:server:play:distance', 2.0, 'handcuff', 0.2)
            Config.IsHandCuffed = true
        end
        isLoggedIn = true 
     end)
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
    if PlayerJob.name == 'police' then
      TriggerServerEvent("Framework:ToggleDuty", false)
      TriggerServerEvent("pepe-police:server:UpdateCurrentCops")
      if DutyBlips ~= nil then 
        for k, v in pairs(DutyBlips) do
            RemoveBlip(v)
        end
        DutyBlips = {}
      end
    end
    ClearPedTasks(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
end)

RegisterNetEvent('Framework:Client:OnJobUpdate')
AddEventHandler('Framework:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    TriggerServerEvent("pepe-police:server:UpdateBlips")
    if (PlayerJob ~= nil) and PlayerJob.name ~= "police" or PlayerJob.name ~= 'ambulance' then
        if DutyBlips ~= nil then
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
    end
end)

RegisterNetEvent('Framework:Client:SetDuty')
AddEventHandler('Framework:Client:SetDuty', function(Onduty)
TriggerServerEvent("pepe-police:server:UpdateBlips")
 if not Onduty then
    if PlayerJob.name == 'police' or PlayerJob.name == 'ambulance' then
     for k, v in pairs(DutyBlips) do
         RemoveBlip(v)
     end
     DutyBlips = {}
    end
 end
 onDuty = Onduty
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isLoggedIn then
            if PlayerJob.name == "police" then
                NearAnything = false
                local PlayerCoords = GetEntityCoords(PlayerPedId())

                for k, v in pairs(Config.Locations['checkin']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 2.0 then
                        NearAnything = true
                        DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                        if not onDuty then
                            DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, '~g~E~w~ - On Duty')
                            if IsControlJustReleased(0, Config.Keys['E']) then
                                TriggerServerEvent("Framework:ToggleDuty", true)
                                TriggerEvent('pepe-radialmenu:client:update:duty:vehicles')
                                TriggerServerEvent("pepe-police:server:UpdateCurrentCops")
                            end
                        else
                            DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, '~r~E~w~ - Off Duty')
                            if IsControlJustReleased(0, Config.Keys['E']) then
                                TriggerServerEvent("Framework:ToggleDuty", false)
                                TriggerEvent('pepe-radialmenu:client:update:duty:vehicles')
                                TriggerServerEvent("pepe-police:server:UpdateCurrentCops")
                            end
                        end
                    end
                end

               if onDuty then

                for k, v in pairs(Config.Locations['fingerprint']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 3.3 then
                        NearAnything = true
                        DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 50, 107, 168, 255, false, false, false, 1, false, false, false)
                    end
                    if Area < 2.0 then
                        NearAnything = true
                         DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, '~b~E~w~ - Finger Scanner')
                         if IsControlJustReleased(0, Config.Keys['E']) then
                            local Player, Distance = Framework.Functions.GetClosestPlayer()
                            if Player ~= -1 and Distance < 2.5 then
                                 TriggerServerEvent("pepe-police:server:show:machine", GetPlayerServerId(Player))
                            else
                                Framework.Functions.Notify("Nobody nearby", "error")
                            end
                        end
                    end
                end
                NearPoliceGarage = false
                for k, v in pairs(Config.Locations['garage']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 5.5 then
                        NearAnything = true
                        NearPoliceGarage = true
                        CurrentGarage = k
                    end
                end


                NearPoliceBossMenu = false

                for k, v in pairs(Config.Locations['boss']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 2.0 then
                        NearAnything = true
                        NearPoliceBossMenu = true

                        DrawText3D(v['X'], v['Y'], v['Z'], "~r~E~w~ Boss Menu")
                        if IsControlJustReleased(0, Config.Keys["E"]) then
                            TriggerServerEvent("pepe-bossmenu:server:openMenu")
                        end
                    end
                end


                NearPoliceImpound = false
                for k, v in pairs(Config.Locations['impound']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 8.0 then
                        NearAnything = true
                        NearPoliceImpound = true
                        if Area < 1.5 then
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                DrawText3D(v['X'], v['Y'], v['Z'], "~g~E~w~ - Store")
                            else
                                DrawText3D(v['X'], v['Y'], v['Z'], "~g~E~w~ - Vehicles")
                            end
                            if IsControlJustReleased(0, Config.Keys["E"]) then
                                if IsPedInAnyVehicle(PlayerPedId(), false) then
                                    Framework.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                else
                                    MenuImpound()
                                    currentGarage = Police
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end 
                    end
                end

                -- for k, v in pairs(Config.Locations['outfits']) do 
                --     local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                --     if Area < 1.5 then
                --         NearAnything = true
                --         DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, "~g~E~w~ - Outfits")
                --         DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                --         if IsControlJustReleased(0, Config.Keys["E"]) then
                --             TriggerServerEvent("pepe-outfits:server:openUI", true)
                --         end
                --     end
                -- end

                for k, v in pairs(Config.Locations['personal-safe']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 1.5 then
                        NearAnything = true
                        DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, "~g~E~w~ - Personal safe")
                        DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                        if IsControlJustReleased(0, Config.Keys["E"]) then
                          TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "personalsafe_"..Framework.Functions.GetPlayerData().citizenid)
                          TriggerEvent("pepe-inventory:client:SetCurrentStash", "personalsafe_"..Framework.Functions.GetPlayerData().citizenid)
                        end
                    end
                end

                for k, v in pairs(Config.Locations['work-shops']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 1.5 then
                        NearAnything = true
                        DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, "~g~E~w~ - Police safe")
                        DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                        if IsControlJustReleased(0, Config.Keys["E"]) then
                            SetWeaponSeries()
                            TriggerServerEvent("pepe-inventory:server:OpenInventory", "shop", "police", Config.Items)
                        end
                    end
                
                end
              end
              if not NearAnything then 
                  Citizen.Wait(1500)
                  CurrentGarage = nil
              end
            else
                Citizen.Wait(1000)
            end
        end 
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if Config.IsEscorted then
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
            EnableControlAction(0, 245, true)
            EnableControlAction(0, 38, true)
            EnableControlAction(0, 322, true)
            EnableControlAction(0, 249, true)

        end
        if Config.IsHandCuffed then
            DisableControlAction(0, 24, true) 
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 25, true) 
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 22, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(1, 37, true)
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 288, true)
            DisableControlAction(2, 199, true)
            DisableControlAction(2, 244, true)
            DisableControlAction(0, 137, true)
			DisableControlAction(0, 59, true) 
			DisableControlAction(0, 71, true) 
			DisableControlAction(0, 72, true) 
			DisableControlAction(0, 73, true) 
			DisableControlAction(2, 36, true) 
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 75, true) 
            DisableControlAction(27, 75, true)
            DisableControlAction(0, 245, true)
            if (not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3)) and not Framework.Functions.GetPlayerData().metadata["isdead"] then
                exports['pepe-assets']:RequestAnimationDict("mp_arresting")
                TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
        end
        if not Config.IsEscorted and not Config.IsHandCuffed then
            Citizen.Wait(2000)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('pepe-police:client:UpdateBlips')
AddEventHandler('pepe-police:client:UpdateBlips', function(players)
    if PlayerJob ~= nil and (PlayerJob.name == 'police' or PlayerJob.name == 'ambulance') and onDuty then
        if DutyBlips ~= nil then 
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
        if players ~= nil then
            for k, data in pairs(players) do
                local id = GetPlayerFromServerId(data.source)
                if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
                    CreateDutyBlips(id, data.label, data.job)
                end
            end
        end
	end
end)


RegisterNetEvent('pepe-police:client:bill:player')
AddEventHandler('pepe-police:client:bill:player', function(price)
    SetTimeout(math.random(2500, 3000), function()
        local gender = "Sir"
        if Framework.Functions.GetPlayerData().charinfo.gender == 1 then
            gender = "Mrs"
        end
        local charinfo = Framework.Functions.GetPlayerData().charinfo
        TriggerServerEvent('pepe-phone:server:sendNewMail', {
            sender = "Police Los Santos",
            subject = "New fine",
            message = "Dear " .. gender .. " " .. charinfo.lastname .. ",<br/><br />The United states courts has taken the money you owed to the state from your bank account.<br /><br />Total amount of the fine: <strong>$"..price.."</strong> <br><br>Please pay off your fine within <strong>14</strong> working days.<br/><br/>Sincerely,<br />The Courthouse",
            button = {}
        })
    end)
end)


-- // Cuff & Escort Event \\ --
RegisterNetEvent('pepe-police:client:cuff:closest')
AddEventHandler('pepe-police:client:cuff:closest', function()
if not IsPedRagdoll(PlayerPedId()) then
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 1.5 then
        local ServerId = GetPlayerServerId(Player)
        if not IsPedInAnyVehicle(GetPlayerPed(Player)) and not IsPedInAnyVehicle(PlayerPedId(), false) then
            TriggerServerEvent("pepe-police:server:cuff:closest", ServerId, true)
            HandCuffAnimation()
        else
            Framework.Functions.Notify("You cant cuff inside a vehicle", "error")
        end
    else
        Framework.Functions.Notify("Nobody nearby", "error")
    end
  else
      Citizen.Wait(2000)
  end
end)

RegisterNetEvent('pepe-police:client:get:cuffed')
AddEventHandler('pepe-police:client:get:cuffed', function()
    local Skillbar = exports['pepe-skillbar']:GetSkillbarObject()
    local NotifySend = false
    local SucceededAttempts = 0
    local NeededAttempts = 1
    if not Config.IsHandCuffed then
        GetCuffedAnimation()
        if math.random(1,3) == 2 then
            Skillbar.Start({
                duration = math.random(360, 375),
                pos = math.random(10, 30),
                width = math.random(10, 20),
            }, function()
                if SucceededAttempts + 1 >= NeededAttempts then
                    -- Finish
                    SucceededAttempts = 0
                    ClearPedTasks(PlayerPedId())
                    Framework.Functions.Notify("You broke free")
                else
                    -- Repeat
                    Skillbar.Repeat({
                        duration = math.random(500, 1300),
                        pos = math.random(10, 40),
                        width = math.random(5, 13),
                    })
                    SucceededAttempts = SucceededAttempts + 1
                end
            end, function()
                -- Fail
        Config.IsHandCuffed = true
        TriggerServerEvent("pepe-police:server:set:handcuff:status", true)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), 1)
        ClearPedTasks(PlayerPedId())
        SucceededAttempts = 0
        if not NotifySend then
            NotifySend = true
            Framework.Functions.Notify("You are soft-cuffed", "error")
            Citizen.Wait(100)
            NotifySend = false
        end
    end)
else
    Config.IsHandCuffed = true
    TriggerServerEvent("pepe-police:server:set:handcuff:status", true)
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), 1)
    ClearPedTasks(PlayerPedId())
end
    else
        Config.IsEscorted = false
        Config.IsHandCuffed = false
        DetachEntity(PlayerPedId(), true, false)
        TriggerServerEvent("pepe-police:server:set:handcuff:status", false)
        ClearPedTasks(PlayerPedId())
        Framework.Functions.Notify("You have been uncuffed", "error")
    end
end)

RegisterNetEvent('pepe-police:client:set:escort:status:false')
AddEventHandler('pepe-police:client:set:escort:status:false', function()
 if Config.IsEscorted then
  Config.IsEscorted = false
  DetachEntity(PlayerPedId(), true, false)
  ClearPedTasks(PlayerPedId())
 end
end)

RegisterNetEvent('pepe-police:client:escort:closest')
AddEventHandler('pepe-police:client:escort:closest', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted then
          if not IsPedInAnyVehicle(PlayerPedId()) then
            TriggerServerEvent("pepe-police:server:escort:closest", ServerId)
        else
         Framework.Functions.Notify("You cant escort in a vehicle", "error")
       end
     end
    else
        Framework.Functions.Notify("Nobody nearby", "error")
    end
end)

RegisterNetEvent('pepe-police:client:get:escorted')
AddEventHandler('pepe-police:client:get:escorted', function(PlayerId)
    if not Config.IsEscorted then
        Config.IsEscorted = true
        local dragger = GetPlayerPed(GetPlayerFromServerId(PlayerId))
        local heading = GetEntityHeading(dragger)
        SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(dragger, 0.0, 0.45, 0.0))
        AttachEntityToEntity(PlayerPedId(), dragger, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    else
        Config.IsEscorted = false
        DetachEntity(PlayerPedId(), true, false)
    end
end)

RegisterNetEvent('pepe-police:client:PutPlayerInVehicle')
AddEventHandler('pepe-police:client:PutPlayerInVehicle', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted  then
            TriggerServerEvent("pepe-police:server:set:in:veh", ServerId)
        end
    else
        Framework.Functions.Notify("Nobody nearby", "error")
    end
end)

RegisterNetEvent('pepe-police:client:SetPlayerOutVehicle')
AddEventHandler('pepe-police:client:SetPlayerOutVehicle', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted then
            TriggerServerEvent("pepe-police:server:set:out:veh", ServerId)
        end
    else
        Framework.Functions.Notify("Nobody nearby", "error")
    end
end)

RegisterNetEvent('pepe-police:client:set:out:veh')
AddEventHandler('pepe-police:client:set:out:veh', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        TaskLeaveVehicle(PlayerPedId(), vehicle, 16)
    end
end)

RegisterNetEvent('pepe-police:client:set:in:veh')
AddEventHandler('pepe-police:client:set:in:veh', function()
    if Config.IsHandCuffed or Config.IsEscorted then
        local vehicle = Framework.Functions.GetClosestVehicle()
        if DoesEntityExist(vehicle) then
			for i = GetVehicleMaxNumberOfPassengers(vehicle), -1, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    Config.IsEscorted = false
                    ClearPedTasks(PlayerPedId())
                    DetachEntity(PlayerPedId(), true, false)
                    Citizen.Wait(100)
                    SetPedIntoVehicle(PlayerPedId(), vehicle, i)
                    return
                end
            end
		end
    end
end)

RegisterNetEvent('pepe-police:client:steal:closest')
AddEventHandler('pepe-police:client:steal:closest', function()
    local player, distance = Framework.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerPed = GetPlayerPed(player)
        local playerId = GetPlayerServerId(player)
        if IsEntityPlayingAnim(playerPed, "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(playerPed, "mp_arresting", "idle", 3) or IsTargetDead(playerId) then
            Framework.Functions.TriggerCallback('pepe-police:server:is:inventory:disabled', function(IsDisabled)
                if not IsDisabled then
                    Framework.Functions.Progressbar("robbing_player", "Stealing stuff..", math.random(5000, 7000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
            }, {
                animDict = "random@shop_robbery",
                anim = "robbery_action_b",
                flags = 16,
            }, {}, {}, function() -- Done
                local plyCoords = GetEntityCoords(playerPed)
                local pos = GetEntityCoords(PlayerPedId())
                local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, plyCoords.x, plyCoords.y, plyCoords.z, true)
                if dist < 2.5 then
                    StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                    TriggerServerEvent("pepe-inventory:server:OpenInventory", "otherplayer", playerId)
                    TriggerEvent("pepe-inventory:server:RobPlayer", playerId)
                else
                    StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                    Framework.Functions.Notify("Nobody nearby", "error")
                end
            end, function() -- Cancel
                StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                Framework.Functions.Notify("Cancelled..", "error")
            end)
        else
            Framework.Functions.Notify("Too bad you cant rob eh puto", "error")
        end
    end, playerId)
        end
    else
        Framework.Functions.Notify("Nobody nearby", "error")
    end
end)

RegisterNetEvent('pepe-police:client:search:closest')
AddEventHandler('pepe-police:client:search:closest', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local playerId = GetPlayerServerId(Player)
        TriggerServerEvent("pepe-inventory:server:OpenInventory", "otherplayer", playerId)
        TriggerServerEvent("pepe-police:server:SearchPlayer", playerId)
    else
        Framework.Functions.Notify("Nobody nearby", "error")
    end
end)

RegisterNetEvent('pepe-police:client:impound:closest')
AddEventHandler('pepe-police:client:impound:closest', function() 
    local Vehicle, Distance = Framework.Functions.GetClosestVehicle()
    if Vehicle ~= 0 and Distance < 1.7 then
        Framework.Functions.Progressbar("impound-vehicle", "Removing vehicle..", math.random(10000, 15000), false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "random@mugging4",
            anim = "struggle_loop_b_thief",
            flags = 49,
        }, {}, {}, function() -- Done
             Framework.Functions.DeleteVehicle(Vehicle)
             Framework.Functions.Notify("Completed", "success")
        end, function()
            Framework.Functions.Notify("Cancelled..", "error")
        end)
    else
        Framework.Functions.Notify("No vehicle found nearby", "error")
    end
end)

RegisterNetEvent('pepe-police:client:impound:hard:closest')
AddEventHandler('pepe-police:client:impound:hard:closest', function() 
    local Vehicle, Distance = Framework.Functions.GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if Vehicle ~= 0 and Distance < 1.7 then
        Framework.Functions.Progressbar("impound-vehicle", "Seizing vehicle to impound..", math.random(10000, 15000), false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "random@mugging4",
            anim = "struggle_loop_b_thief",
            flags = 49,
        }, {}, {}, function() -- Done
             Framework.Functions.DeleteVehicle(Vehicle)
             TriggerServerEvent("pepe-police:server:impound:vehicle", Plate)
             Framework.Functions.Notify("Completed", "success")
        end, function()
            Framework.Functions.Notify("Cancelled..", "error")
        end)
    else
        Framework.Functions.Notify("No vehicle found nearby", "error")
    end
end)

RegisterNetEvent('pepe-police:client:enkelband:closest')
AddEventHandler('pepe-police:client:enkelband:closest', function()
    local Player, Distance = Framework.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("pepe-police:server:set:tracker",  GetPlayerServerId(Player))
    else
        Framework.Functions.Notify("Nobody nearby", "error")
    end
end)

RegisterNetEvent('pepe-police:client:set:tracker')
AddEventHandler('pepe-police:client:set:tracker', function(bool)
    local trackerClothingData = {}
    if bool then
        trackerClothingData.outfitData = {["accessory"] = { item = 13, texture = 0}}
        TriggerEvent('pepe-clothing:client:loadOutfit', trackerClothingData)
    else
        trackerClothingData.outfitData = {["accessory"] = { item = -1, texture = 0}}
        TriggerEvent('pepe-clothing:client:loadOutfit', trackerClothingData)
    end
end)

RegisterNetEvent('pepe-police:client:send:tracker:location')
AddEventHandler('pepe-police:client:send:tracker:location', function(RequestId)
    local Coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('pepe-police:server:send:tracker:location', Coords, RequestId)
end)

RegisterNetEvent('pepe-police:client:show:machine')
AddEventHandler('pepe-police:client:show:machine', function(PlayerId)
    FingerPrintSession = PlayerId
    SendNUIMessage({
        type = "OpenFinger"
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('pepe-police:client:show:fingerprint:id')
AddEventHandler('pepe-police:client:show:fingerprint:id', function(FingerPrintId)
 SendNUIMessage({
     type = "UpdateFingerId",
     fingerprintId = FingerPrintId
 })
 PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNetEvent('pepe-police:client:show:tablet')
AddEventHandler('pepe-police:client:show:tablet', function()
    exports['pepe-assets']:AddProp('Tablet')
    exports['pepe-assets']:RequestAnimationDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')
    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(500)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "databank",
    })
end)

RegisterNUICallback('ScanFinger', function(data)
    TriggerServerEvent('pepe-police:server:showFingerId', FingerPrintSession)
end)

RegisterNetEvent('pepe-police:client:spawn:vehicle')
AddEventHandler('pepe-police:client:spawn:vehicle', function(VehicleName)
    if VehicleName ~= 'polmav' then
      local RandomCoords = Config.Locations['garage'][CurrentGarage]['Spawns'][math.random(1, #Config.Locations['garage'][CurrentGarage]['Spawns'])]
      local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}    
      local CanSpawn = Framework.Functions.IsSpawnPointClear(CoordTable, 2.0)
      if CanSpawn then
      Framework.Functions.SpawnVehicle(VehicleName, function(Vehicle)
        SetVehicleNumberPlateText(Vehicle, "POLICE"..tostring(math.random(10, 99)))
        Citizen.Wait(25)
        exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
        exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
        --exports['pepe-emergencylights']:SetupEmergencyVehicle(Vehicle)
        Framework.Functions.Notify('Your duty vehicle is in one of the parking spots.', 'info')
       end, CoordTable, true, false)
    else
        Framework.Functions.Notify('Something is blocking the spot..', 'info')
    end
else
        local CoordTable = {x = 449.76, y = -980.87, z = 43.69, a = 90.57}
        local CanSpawn = Framework.Functions.IsSpawnPointClear(CoordTable, 3.0)
        if CanSpawn then
        Framework.Functions.SpawnVehicle('polmav', function(Vehicle)
            SetVehicleNumberPlateText(Vehicle, "POLICE"..tostring(math.random(10, 99)))
            Citizen.Wait(25)
         exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
         exports['pepe-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
         Framework.Functions.Notify('The helicopter is ready for take off on the roof..', 'info')
        end, CoordTable, true, false)
    else
        Framework.Functions.Notify('Something is blocking the helipad', 'info')
    end
    end
end)

RegisterNetEvent('pepe-police:client:open:evidence')
AddEventHandler('pepe-police:client:open:evidence', function(args)
 local Coords = GetEntityCoords(PlayerPedId())
 NearPolice = false
 for k, v in pairs(Locaties['Politie']) do
 local Gebied = GetDistanceBetweenCoords(Coords.x, Coords.y, Coords.z, v["x"], v["y"], v["z"], true)
   if Gebied <= 45.0 then
    NearPolice = true
     TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", "evidencestash_"..args, {
         maxweight = 2500000,
         slots = 50,
     })
     TriggerEvent("pepe-inventory:client:SetCurrentStash", "evidencestash_"..args)
   end
 end
 if not NearPolice then
    Framework.Functions.Notify("You need to be close nearby the Police station to use this function..", "error")
 end
end)

RegisterNetEvent('pepe-police:client:send:alert')
AddEventHandler('pepe-police:client:send:alert', function(Message, Anoniem)
    local PlayerData = Framework.Functions.GetPlayerData()
      if Anoniem then
        if (Framework.Functions.GetPlayerData().job.name == "police") and Framework.Functions.GetPlayerData().job.onduty then
         TriggerEvent('chatMessage', "ANONYMOUS CALL", "warning", Message)
         PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
        end
      else
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent("pepe-police:server:send:call:alert", PlayerCoords, Message)
        TriggerEvent("pepe-police:client:call:anim")
      end
end)

RegisterNetEvent('pepe-police:client:send:message')
AddEventHandler('pepe-police:client:send:message', function(Coords, Message, Name)
    if (Framework.Functions.GetPlayerData().job.name == "police" or Framework.Functions.GetPlayerData().job.name == "ambulance") and Framework.Functions.GetPlayerData().job.onduty then
        TriggerEvent('chatMessage', "911 Alert - " ..Name, "warning", Message)
        PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
        AddAlert('911', 66, 250, Coords)
    end
end)

RegisterNetEvent('pepe-police:client:call:anim')
AddEventHandler('pepe-police:client:call:anim', function()
    local isCalling = true
    local callCount = 5
    exports['pepe-assets']:RequestAnimationDict("cellphone@")
    TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 3.0, -1, -1, 49, 0, false, false, false)
    Citizen.Wait(1000)
    Citizen.CreateThread(function()
        while isCalling do
            Citizen.Wait(1000)
            callCount = callCount - 1
            if callCount <= 0 then
                isCalling = false
                StopAnimTask(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 1.0)
            end
        end
    end)
end)

RegisterNetEvent('pepe-police:client:spawn:object')
AddEventHandler('pepe-police:client:spawn:object', function(Type)
    Framework.Functions.Progressbar("spawn-object", "Placing object..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("pepe-police:server:spawn:object", Type)
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "anim@narcotics@trash", "drop_front", 1.0)
        Framework.Functions.Notify("Cancelled..", "error")
    end)
end)

RegisterNetEvent('pepe-police:client:delete:object')
AddEventHandler('pepe-police:client:delete:object', function()
    local objectId, dist = GetClosestPoliceObject()
    if dist < 5.0 then
        Framework.Functions.Progressbar("remove-object", "Removing object..", 2500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
            anim = "plant_floor",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
            TriggerServerEvent("pepe-police:server:delete:object", objectId)
        end, function() -- Cancel
            StopAnimTask(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
            Framework.Functions.Notify("Cancelled..", "error")
        end)
    end
end)

RegisterNetEvent('pepe-police:client:place:object')
AddEventHandler('pepe-police:client:place:object', function(objectId, type, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local heading = GetEntityHeading(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(PlayerPedId())
    local x, y, z = table.unpack(coords + forward * 0.5)
    local spawnedObj = CreateObject(Config.Objects[type].model, x, y, z, false, false, false)
    PlaceObjectOnGroundProperly(spawnedObj)
    SetEntityHeading(spawnedObj, heading)
    FreezeEntityPosition(spawnedObj, Config.Objects[type].freeze)
    ObjectList[objectId] = {
        id = objectId,
        object = spawnedObj,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent('pepe-police:client:remove:object')
AddEventHandler('pepe-police:client:remove:object', function(objectId)
    NetworkRequestControlOfEntity(ObjectList[objectId].object)
    DeleteObject(ObjectList[objectId].object)
    ObjectList[objectId] = nil
end)

RegisterNetEvent('pepe-police:client:set:radio')
AddEventHandler('pepe-police:client:set:radio', function()
 Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem)
    if HasItem then
        -- exports['pepe-radio']:SetRadioState(true)
        exports['pepe-radio']:JoinRadio(1, 1)
        Framework.Functions.Notify("Connected with OC-01", "info", 8500)
    end
 end, "radio")
end)

RegisterNetEvent('police:client:SeizeCash')
AddEventHandler('police:client:SeizeCash', function()
    local player, distance = Framework.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        Framework.Functions.TriggerCallback('police:SeizeCash', function()
        end, playerId)
    else
        Framework.Functions.Notify("None nearby!", "error")
    end
end)

RegisterNetEvent('police:client:SeizeDriverLicense')
AddEventHandler('police:client:SeizeDriverLicense', function()
    local player, distance = Framework.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        Framework.Functions.TriggerCallback('police:SeizeDriverLicense', function()
        end, playerId)
    else
        Framework.Functions.Notify("None nearby!", "error")
    end
end)



-- // Functions \\ --

function CreateDutyBlips(playerId, playerLabel, playerJob)
	local ped = GetPlayerPed(playerId)
    local blip = GetBlipFromEntity(ped)
	if not DoesBlipExist(blip) then
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 480)
        SetBlipScale(blip, 1.0)
        if playerJob == "police" then
            SetBlipColour(blip, 38)
        else
            SetBlipColour(blip, 35)
        end
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(playerLabel)
        EndTextCommandSetBlipName(blip)
		table.insert(DutyBlips, blip)
	end
end

function HandCuffAnimation()
 exports['pepe-assets']:RequestAnimationDict("mp_arrest_paired")
 Citizen.Wait(100)
 TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "cop_p2_back_right", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
 Citizen.Wait(3500)
 TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "exit", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
end

function GetCuffedAnimation(playerId)
 local cuffer = GetPlayerPed(GetPlayerFromServerId(playerId))
 local heading = GetEntityHeading(cuffer)
 exports['pepe-assets']:RequestAnimationDict("mp_arrest_paired")
 TriggerServerEvent('pepe-sound:server:play:distance', 2.0, 'handcuff', 0.2)
 SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))
 Citizen.Wait(100)
 SetEntityHeading(PlayerPedId(), heading)
 TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3.0, 3.0, -1, 32, 0, 0, 0, 0)
 Citizen.Wait(2500)
end

function GetClosestPoliceObject()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for id, data in pairs(ObjectList) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true)
            current = id
        end
    end
    return current, dist
end

function DrawText3D(x, y, z, text)
 SetTextScale(0.35, 0.35)
 SetTextFont(4)
 SetTextProportional(1)
 SetTextColour(255, 255, 255, 215)
 SetTextEntry("STRING")
 SetTextCentre(true)
 AddTextComponentString(text)
 SetDrawOrigin(x,y,z, 0)
 DrawText(0.0, 0.0)
 ClearDrawOrigin()
end

function IsTargetDead(playerId)
 local IsDead = false
  Framework.Functions.TriggerCallback('pepe-police:server:is:player:dead', function(result)
    IsDead = result
  end, playerId)
  Citizen.Wait(100)
  return IsDead
end

function GetVehicleList()
    local VehicleData = Framework.Functions.GetPlayerData().metadata['duty-vehicles']
    local Vehicles = {}
    if VehicleData.Standard then
        table.insert(Vehicles, "police:vehicle:touran")
        table.insert(Vehicles, "police:vehicle:klasse")
        table.insert(Vehicles, "police:vehicle:vito")
        table.insert(Vehicles, "police:vehicle:charger")
        table.insert(Vehicles, "vehicle:delete")
    end
    if VehicleData.Audi then
        table.insert(Vehicles, "police:vehicle:audi")
    end
    if VehicleData.Unmarked then
        table.insert(Vehicles, "police:vehicle:velar")
        table.insert(Vehicles, "police:vehicle:bmw")
        table.insert(Vehicles, "police:vehicle:unmaked:audi")
        table.insert(Vehicles, "vehicle:delete")
    end
    if VehicleData.Heli then 
        table.insert(Vehicles, "police:vehicle:heli")
        table.insert(Vehicles, "vehicle:delete")
    end
    if VehicleData.Motor then
        table.insert(Vehicles, "police:vehicle:motor")
        table.insert(Vehicles, "police:vehicle:motor2")
    end
    if VehicleData.Sheriff then
        table.insert(Vehicles, "police:vehicle:valorfpiu")
        table.insert(Vehicles, "police:vehicle:valorcharger")
        table.insert(Vehicles, "police:vehicle:valor18tahoe")
        table.insert(Vehicles, "police:vehicle:valorsilv")
        table.insert(Vehicles, "police:vehicle:valorcvpi")
        table.insert(Vehicles, "police:vehicle:valor13tahoe")
        table.insert(Vehicles, "police:vehicle:valor14charg")
        table.insert(Vehicles, "vehicle:delete")
    end
    return Vehicles
end

function SetWeaponSeries()
 Config.Items.items[1].info.serie = Framework.Functions.GetPlayerData().job.serial
 Config.Items.items[2].info.serie = Framework.Functions.GetPlayerData().job.serial
 Config.Items.items[3].info.serie = Framework.Functions.GetPlayerData().job.serial
end

function GetGarageStatus()
    return NearPoliceGarage
end

function GetEscortStatus()
    return Config.IsEscorted
end

function GetImpoundStatus()
    return NearPoliceImpound
end


function MenuImpound()
    ped = PlayerPedId();
    MenuTitle = "Impound"
    ClearMenu()
    Menu.addButton("Vehicles", "MenuImpound", nil)
    Menu.addButton("Close Menu", "closeMenuFull", nil) 
end

function ImpoundVehicleList()
    Framework.Functions.TriggerCallback("pepe-police:GetImpoundedVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "Vehicles:"
        ClearMenu()

        if result == nil then
            Framework.Functions.Notify("There are no seized vehicles", "error", 5000)
            closeMenuFull()
        else
            for k, v in pairs(result) do
                Menu.addButton(Framework.Shared.Vehicles[v.vehicle]["name"], "TakeOutImpound", v, "Confiscated")
            end
        end
            
        Menu.addButton("Back", "MenuImpound",nil)
    end)
end

function TakeOutImpound(vehicle)
    local coords = Config.Locations["impound"]
    Framework.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
    Framework.Functions.TriggerCallback('pepe-garage:server:get:vehicle:mods', function(Mods)
    Framework.Functions.SetVehicleProperties(veh, Mods)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, coords.h)
            closeMenuFull()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            exports['pepe-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
            exports['pepe-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100.0, false)
            SetVehicleEngineOn(veh, true, true)
        end, vehicle.plate)
    end, coords['X'], coords['Y'], coords['Z'], true)
end



function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function SpawnIncheckProp()
    local SpawnModel = GetHashKey('v_ind_cs_bucket')
    exports['pepe-assets']:RequestModelHash(SpawnModel)
    local Object = CreateObject(SpawnModel, 441.80, -982.02, 30.4, false, false, false)
    SetEntityHeading(Object, 265.15)
    FreezeEntityPosition(Object, true)
    SetEntityInvincible(Object, true)
    SetEntityVisible(Object, false)
end

RegisterNUICallback('CloseNui', function()
 SetNuiFocus(false, false)
 if exports['pepe-assets']:GetPropStatus() then
    exports['pepe-assets']:RemoveProp()
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "exit", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
 end
end)

RegisterNetEvent('police:client:EmergencySound')
AddEventHandler('police:client:EmergencySound', function()
    PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNetEvent('police:client:CallAnim')
AddEventHandler('police:client:CallAnim', function()
    local isCalling = true
    local callCount = 5
    TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 3.0, -1, -1, 49, 0, false, false, false)
    Citizen.Wait(1000)
    Citizen.CreateThread(function()
        while isCalling do
            Citizen.Wait(1000)
            callCount = callCount - 1
            if callCount <= 0 then
                isCalling = false
                StopAnimTask(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 1.0)
            end
        end
    end)
end)


RegisterNetEvent('police:client:Send112AMessage')
AddEventHandler('police:client:Send112AMessage', function(message)
    local PlayerData = Framework.Functions.GetPlayerData()
    if ((PlayerData.job.name == "police" or PlayerData.job.name == "ambulance") and onDuty) then
        TriggerEvent('chatMessage', "Anonymous report", "warning", message)
        TriggerEvent("police:client:EmergencySound")
    end
end)

RegisterNetEvent('police:client:SendEmergencyMessage')
AddEventHandler('police:client:SendEmergencyMessage', function(message)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("police:server:SendEmergencyMessage", coords, message)
    TriggerEvent("police:client:CallAnim")
end)

RegisterNetEvent('police:server:SendEmergencyMessageCheck')
AddEventHandler('police:server:SendEmergencyMessageCheck', function(MainPlayer, message, coords)
    local PlayerData = Framework.Functions.GetPlayerData()

    if ((PlayerData.job.name == "police" or PlayerData.job.name == "ambulance") and onDuty) then
        TriggerEvent('chatMessage', "911 MESSAGE - " .. MainPlayer.PlayerData.charinfo.firstname .. " " .. MainPlayer.PlayerData.charinfo.lastname .. " ("..MainPlayer.PlayerData.source..")", "error", message)
        TriggerEvent("police:client:EmergencySound")
        local transG = 250
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 280)
        SetBlipColour(blip, 4)
        SetBlipDisplay(blip, 4)
        SetBlipAlpha(blip, transG)
        SetBlipScale(blip, 0.9)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("911 Message")
        EndTextCommandSetBlipName(blip)
        while transG ~= 0 do
            Wait(180 * 4)
            transG = transG - 1
            SetBlipAlpha(blip, transG)
            if transG == 0 then
                SetBlipSprite(blip, 2)
                RemoveBlip(blip)
                return
            end
        end
    end
end)


RegisterNetEvent('police:client:CheckStatus')
AddEventHandler('police:client:CheckStatus', function()
    Framework.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.job.name == "police" then
            local player, distance = Framework.Functions.GetClosestPlayer()
            if player ~= -1 and distance < 5.0 then
                local playerId = GetPlayerServerId(player)
                Framework.Functions.TriggerCallback('police:GetPlayerStatus', function(result)
                    if result ~= nil then
                        for k, v in pairs(result) do
                            TriggerEvent("chatMessage", "STATUS", "warning", v)
                        end
                    end
                end, playerId)
            end
        end
    end)
end)

local SpikeConfig = {
    MaxSpikes = 5
}
local SpawnedSpikes = {}
local spikemodel = "P_ld_stinger_s"
local nearSpikes = false
local spikesSpawned = false
local ClosestSpike = nil

Citizen.CreateThread(function()
    while true do

        if isLoggedIn then
            GetClosestSpike()
        end

        Citizen.Wait(500)
    end
end)

function GetClosestSpike()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil

    for id, data in pairs(SpawnedSpikes) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, SpawnedSpikes[id].coords.x, SpawnedSpikes[id].coords.y, SpawnedSpikes[id].coords.z, true) < dist)then
                current = id
            end
        else
            dist = GetDistanceBetweenCoords(pos, SpawnedSpikes[id].coords.x, SpawnedSpikes[id].coords.y, SpawnedSpikes[id].coords.z, true)
            current = id
        end
    end
    ClosestSpike = current
end

RegisterNetEvent('pepe-police:client:SpawnSpikeStrip')
AddEventHandler('pepe-police:client:SpawnSpikeStrip', function()
    if #SpawnedSpikes + 1 < SpikeConfig.MaxSpikes then
        if PlayerJob.name == "police" and PlayerJob.onduty then
            local spawnCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
            local spike = CreateObject(GetHashKey(spikemodel), spawnCoords.x, spawnCoords.y, spawnCoords.z, 1, 1, 1)
            local netid = NetworkGetNetworkIdFromEntity(spike)
            SetNetworkIdExistsOnAllMachines(netid, true)
            SetNetworkIdCanMigrate(netid, false)
            SetEntityHeading(spike, GetEntityHeading(PlayerPedId()))
            PlaceObjectOnGroundProperly(spike)
            table.insert(SpawnedSpikes, {
                coords = {
                    x = spawnCoords.x,
                    y = spawnCoords.y,
                    z = spawnCoords.z,
                },
                netid = netid,
                object = spike,
            })
            spikesSpawned = true
            TriggerServerEvent('pepe-police:server:SyncSpikes', SpawnedSpikes)
            TriggerServerEvent('Framework:Server:RemoveItem', 'spikestrip', 1)
        end
    else
        Framework.Functions.Notify('There are no spikestrips left..', 'error')
    end
end)

RegisterNetEvent('pepe-police:client:SyncSpikes')
AddEventHandler('pepe-police:client:SyncSpikes', function(table)
    SpawnedSpikes = table
end)

Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            if ClosestSpike ~= nil then
                local tires = {
                    {bone = "wheel_lf", index = 0},
                    {bone = "wheel_rf", index = 1},
                    {bone = "wheel_lm", index = 2},
                    {bone = "wheel_rm", index = 3},
                    {bone = "wheel_lr", index = 4},
                    {bone = "wheel_rr", index = 5}
                }

                for a = 1, #tires do
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    local tirePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[a].bone))
                    local spike = GetClosestObjectOfType(tirePos.x, tirePos.y, tirePos.z, 15.0, GetHashKey(spikemodel), 1, 1, 1)
                    local spikePos = GetEntityCoords(spike, false)
                    local distance = Vdist(tirePos.x, tirePos.y, tirePos.z, spikePos.x, spikePos.y, spikePos.z)

                    if distance < 1.8 then
                        if not IsVehicleTyreBurst(vehicle, tires[a].index, true) or IsVehicleTyreBurst(vehicle, tires[a].index, false) then
                            SetVehicleTyreBurst(vehicle, tires[a].index, false, 1000.0)
                        end
                    end
                end
            end
        end

        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            if ClosestSpike ~= nil then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local dist = GetDistanceBetweenCoords(pos, SpawnedSpikes[ClosestSpike].coords.x, SpawnedSpikes[ClosestSpike].coords.y, SpawnedSpikes[ClosestSpike].coords.z, true)

                if dist < 4 then
                    if not IsPedInAnyVehicle(PlayerPedId()) then
                        if PlayerJob.name == "police" and PlayerJob.onduty then
                            DrawText3D(pos.x, pos.y, pos.z, '[E] Remove spikestrip')
                            if IsControlJustPressed(0, Keys["E"]) then
                                NetworkRegisterEntityAsNetworked(SpawnedSpikes[ClosestSpike].object)
                                NetworkRequestControlOfEntity(SpawnedSpikes[ClosestSpike].object)            
                                SetEntityAsMissionEntity(SpawnedSpikes[ClosestSpike].object)        
                                DeleteEntity(SpawnedSpikes[ClosestSpike].object)
                                table.remove(SpawnedSpikes, ClosestSpike)
                                ClosestSpike = nil
                                TriggerServerEvent('pepe-police:server:SyncSpikes', SpawnedSpikes)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(3)
    end
end)
