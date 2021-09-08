local LoggedIn = false
local NearHack = false
local CurrentCops = nil
local HasAlertSend = false

Framework = nil
  
RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
     TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
       Citizen.Wait(150)
     Framework.Functions.TriggerCallback("pepe-jewellery:server:GetConfig", function(config)
      Config = config
     end)
     LoggedIn = true
    end) 
end)

RegisterNetEvent('pepe-police:SetCopCount')
AddEventHandler('pepe-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

RegisterNetEvent('pepe-jewellery:client:set:vitrine:isopen')
AddEventHandler('pepe-jewellery:client:set:vitrine:isopen', function(CaseId, bool)
    Config.Vitrines[CaseId]["IsOpen"]= bool
end)

RegisterNetEvent('pepe-jewellery:client:set:vitrine:busy')
AddEventHandler('pepe-jewellery:client:set:vitrine:busy', function(CaseId, bool)
    Config.Vitrines[CaseId]["IsBusy"] = bool
end)

RegisterNetEvent('pepe-jewellery:client:set:cooldown')
AddEventHandler('pepe-jewellery:client:set:cooldown',function(bool)
    Config.Cooldown = bool
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
         local PlayerCoords = GetEntityCoords(PlayerPedId())
         local Distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.Locations['use-card']["Coords"]["X"], Config.Locations['use-card']["Coords"]["Y"], Config.Locations['use-card']["Coords"]["Z"], true)
         NearHack = false
         if Distance <= 1.5 then 
            NearHack = true
            DrawMarker(2, Config.Locations['use-card']["Coords"]["X"], Config.Locations['use-card']["Coords"]["Y"], Config.Locations['use-card']["Coords"]["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 3, 252, 32, 255, false, false, false, 1, false, false, false)
        end
         if not NearHack then
            Citizen.Wait(1500)
         end
    end
end)

-- Code

-- // Events \\ --

RegisterNetEvent('pepe-jewellery:client:use:card')
AddEventHandler('pepe-jewellery:client:use:card', function()
    local CurrentTime = GetClockHours()
    if NearHack then
        if CurrentTime >= 0 and CurrentTime <= 6 then
            if CurrentCops >= Config.PoliceNeeded then
                if not Config.Cooldown then
                    Framework.Functions.TriggerCallback('Framework:HasItem', function(HasItem)
                        if HasItem then
                            TriggerEvent('pepe-inventory:client:set:busy', true)
                            TriggerServerEvent('pepe-jewellery:server:set:cooldown', true)
                            StartMiniGame()
                        else
                            Framework.Functions.Notify(_U("missingsomething"), "error")
                        end
                    end, "electronickit")
                else
                Framework.Functions.Notify(_U("lockactive"), "error")
                end
            else
            Framework.Functions.Notify(_U("nocops"), "info")
            end
        else
            Framework.Functions.Notify(_U("notrighttime"), "error")
        end
    end
end)

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            InRange = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
                local JewelleryDist = GetDistanceBetweenCoords(PlayerCoords, Config.Locations['store']["Coords"]["X"], Config.Locations['store']["Coords"]["Y"], Config.Locations['store']["Coords"]["Z"], true)
                if JewelleryDist < 30.0 then
                    if Framework.Functions.GetPlayerData().job.name ~= 'police' and Framework.Functions.GetPlayerData().job.onduty or Framework.Functions.GetPlayerData().job.name == "police" and not Framework.Functions.GetPlayerData().job.onduty then
                    for k, v in pairs(Config.Vitrines) do
                        local VitrineDist = GetDistanceBetweenCoords(PlayerCoords, Config.Vitrines[k]["Coords"]["X"], Config.Vitrines[k]["Coords"]["Y"], Config.Vitrines[k]["Coords"]["Z"], true)
                        if VitrineDist < 0.6 then
                            InRange = true
                            if not Config.Vitrines[k]["IsOpen"] and not Config.Vitrines[k]["IsBusy"] then
                                Framework.Functions.DrawText3D(Config.Vitrines[k]["Coords"]["X"], Config.Vitrines[k]["Coords"]["Y"], Config.Vitrines[k]["Coords"]["Z"], _U("break"))
                                if IsControlJustReleased(0, 38) then
                                    if HasValidWeapon() then
                                        if not HasAlertSend then
                                            HasAlertSend = true
                                            TriggerServerEvent('pepe-police:server:send:alert:jewellery', GetEntityCoords(PlayerPedId()), Framework.Functions.GetStreetLabel())
                                         end
                                        SmashGlass(k)
                                    else
                                        Framework.Functions.Notify(_U("weaponweak"), "error")
                                    end
                                end
                            else
                                Citizen.Wait(200)
                            end
                        end
                    end
                else
                    Citizen.Wait(500)
                end
             else
                Citizen.Wait(1500)
             end
           if not InRange then
            Citizen.Wait(500)
           end
        end
    end
end)

-- // Functions \\ --

function StartMiniGame()
    exports['minigame-phone']:ShowHack()
    exports['minigame-phone']:StartHack(math.random(1,4), math.random(8,12), function(Success)
        if Success then
            TriggerServerEvent('pepe-doorlock:server:updateState', 28, false)
            TriggerServerEvent('Framework:Server:RemoveItem', 'yellow-card', 1)
            TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['yellow-card'], "remove")
            TriggerEvent('pepe-inventory:client:set:busy', false)
        else
            Framework.Functions.Notify(_U("failed"), "error")
            TriggerServerEvent('pepe-jewellery:server:set:cooldown', false)
            TriggerEvent('pepe-inventory:client:set:busy', false)
        end
        exports['minigame-phone']:HideHack()
    end)
end

function SmashGlass(CaseId)
    local Smashing = true
    LoadParticles()
    TriggerServerEvent('pepe-jewellery:server:set:vitrine:busy', CaseId, true)
    StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Framework.Functions.Progressbar("smash_vitrine", _U("smashing"), 15000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        Smashing = false
        Framework.Functions.TriggerCallback('pepe-jewellery:vitrine:reward')
        TriggerServerEvent('pepe-jewellery:server:start:reset')
        TriggerServerEvent('pepe-jewellery:server:set:vitrine:isopen', CaseId, true)
        TriggerServerEvent('pepe-jewellery:server:set:vitrine:busy', CaseId, false)
        TaskPlayAnim(PlayerPedId(), "missheist_jewel", "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end, function() -- Cancel
        Smashing = false
        TriggerServerEvent('pepe-jewellery:server:set:vitrine:busy', CaseId, false)
        TaskPlayAnim(PlayerPedId(), "missheist_jewel", "exit", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    end)
    while Smashing do
        exports['pepe-assets']:RequestAnimationDict("missheist_jewel")
        TaskPlayAnim(PlayerPedId(), "missheist_jewel", "smash_case", 3.0, 3.0, -1, 2, 0, 0, 0, 0 )
        Citizen.Wait(500)
        TriggerEvent("pepe-sound:client:play", "jewellery-glass", 0.25)
        LoadParticles()
        TriggerServerEvent('pepe-hud:server:gain:stress', math.random(1, 3))
        StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.6, 0).x, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.6, 0).y, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.6, 0).z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        Citizen.Wait(2500)
    end
end

function HasValidWeapon()
  local CurrentWeapon = GetSelectedPedWeapon(PlayerPedId())
  for k, v in pairs(Config.VitrineWeapons) do
    if CurrentWeapon == v then
        return true
    end
  end
end

function LoadParticles()
 if not HasNamedPtfxAssetLoaded("scr_jewelheist") then
    RequestNamedPtfxAsset("scr_jewelheist")
 end
 while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
    Citizen.Wait(0)
 end
 SetPtfxAssetNextCall("scr_jewelheist")
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