local HouseData, OffSets = nil, nil
local IsNearAppartment = false
local IsInAppartment = false
local CurrentAppartment = nil
local LoggedIn = false
local Other = nil
local Blips = nil

Framework = nil  

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(450, function()
      TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
      Citizen.Wait(150)
      AddBlipForAppartment()
      LoggedIn = true
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    RemoveAppartmentBlip()
    LoggedIn = false
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            if IsInAppartment then
              local PlayerCoords = GetEntityCoords(PlayerPedId())
                -- // Verlaten \\ --
                if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations[CurrentAppartment]['Enter']['X'] - OffSets.exit.x, Config.Locations[CurrentAppartment]['Enter']['Y'] - OffSets.exit.y, Config.Locations[CurrentAppartment]['Enter']['Z'] - OffSets.exit.z, true) < 1.2) then
                 DrawMarker(2, Config.Locations[CurrentAppartment]['Enter']['X'] - OffSets.exit.x, Config.Locations[CurrentAppartment]['Enter']['Y'] - OffSets.exit.y, Config.Locations[CurrentAppartment]['Enter']['Z'] - OffSets.exit.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                 Framework.Functions.DrawText3D(Config.Locations[CurrentAppartment]['Enter']['X'] - OffSets.exit.x, Config.Locations[CurrentAppartment]['Enter']['Y'] - OffSets.exit.y, Config.Locations[CurrentAppartment]['Enter']['Z'] - OffSets.exit.z + 0.12, _U("outside") ..'')
                    if IsControlJustReleased(0, 38) then
                        LeaveAppartment()
                    end
                end
                -- // Stash \\ --
                if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations[CurrentAppartment]['Enter']['X'] - OffSets.stash.x, Config.Locations[CurrentAppartment]['Enter']['Y'] - OffSets.stash.y, Config.Locations[CurrentAppartment]['Enter']['Z'] - OffSets.stash.z, true) < 1.0) then
                    DrawMarker(2, Config.Locations[CurrentAppartment]['Enter']['X'] - OffSets.stash.x, Config.Locations[CurrentAppartment]['Enter']['Y'] - OffSets.stash.y, Config.Locations[CurrentAppartment]['Enter']['Z'] - OffSets.stash.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                    Framework.Functions.DrawText3D(Config.Locations[CurrentAppartment]['Enter']['X'] - OffSets.stash.x, Config.Locations[CurrentAppartment]['Enter']['Y'] - OffSets.stash.y, Config.Locations[CurrentAppartment]['Enter']['Z'] - OffSets.stash.z + 0.1, _U("stash") ..'')
                    if IsControlJustReleased(0, 38) then
                        Other = {maxweight = 500000, slots = 20}
                        TriggerEvent("pepe-inventory:client:SetCurrentStash", Framework.Functions.GetPlayerData().metadata['appartment-data'].Id)
                        TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", Framework.Functions.GetPlayerData().metadata['appartment-data'].Id, Other)
                        TriggerEvent("pepe-sound:client:play", "stash-open", 0.4)
                    end
                end
                -- // Kleding Kast \\ --
                if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations[CurrentAppartment]['Enter']['X'] - OffSets.closet.x, Config.Locations[CurrentAppartment]['Enter']['Y'] - OffSets.closet.y, Config.Locations[CurrentAppartment]['Enter']['Z'] - OffSets.closet.z, true) < 1.2) then
                    DrawMarker(2, Config.Locations[CurrentAppartment]['Enter']['X'] - OffSets.closet.x, Config.Locations[CurrentAppartment]['Enter']['Y'] - OffSets.closet.y, Config.Locations[CurrentAppartment]['Enter']['Z'] - OffSets.closet.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                    Framework.Functions.DrawText3D(Config.Locations[CurrentAppartment]['Enter']['X'] - OffSets.closet.x, Config.Locations[CurrentAppartment]['Enter']['Y'] - OffSets.closet.y, Config.Locations[CurrentAppartment]['Enter']['Z'] - OffSets.closet.z + 0.1, _U("outfits") ..'')
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('pepe-clothing:client:openOutfitMenu')
                    end
                end
                -- // Log Uit \\ --
                if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations[CurrentAppartment]['Enter']['X'] - OffSets.logout.x, Config.Locations[CurrentAppartment]['Enter']['Y'] - OffSets.logout.y, Config.Locations[CurrentAppartment]['Enter']['Z'] - OffSets.logout.z, true) < 1.2) then
                    DrawMarker(2, Config.Locations[CurrentAppartment]['Enter']['X'] - OffSets.logout.x, Config.Locations[CurrentAppartment]['Enter']['Y'] - OffSets.logout.y, Config.Locations[CurrentAppartment]['Enter']['Z'] - OffSets.logout.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                    Framework.Functions.DrawText3D(Config.Locations[CurrentAppartment]['Enter']['X'] - OffSets.logout.x, Config.Locations[CurrentAppartment]['Enter']['Y'] - OffSets.logout.y, Config.Locations[CurrentAppartment]['Enter']['Z'] - OffSets.logout.z + 0.1, _U("logout") ..'')
                    if IsControlJustReleased(0, 38) then
                       LogoutPlayer()   
                    end
                end
            end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('pepe-appartments:client:enter:appartment')
AddEventHandler('pepe-appartments:client:enter:appartment', function(IsNew, AppartmentName)
    if IsNew then
        Citizen.SetTimeout(450, function()
            local Appartment = {}
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local CoordsTable = {x = Config.Locations[AppartmentName]['Enter']['X'], y = Config.Locations[AppartmentName]['Enter']['Y'], z = Config.Locations[AppartmentName]['Enter']['Z'] - 35.0}
            TriggerEvent("pepe-sound:client:play", "house-door-open", 0.1)
            Citizen.Wait(350)
            CurrentAppartment = AppartmentName
            if Framework.Functions.GetPlayerData().metadata['appartment-tier'] == 1 then
                Appartment = exports['pepe-interiors']:CreateMidAppartement(CoordsTable)
            else
                Appartment = exports['pepe-interiors']:CreateMidHotel(CoordsTable)
            end
            NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
            SetEntityHealth(PlayerPedId(), 200.0)
            TriggerEvent('pepe-weathersync:client:DisableSync')
            TriggerEvent('pepe-clothing:client:CreateFirstCharacter')
            IsInAppartment = true
            HouseData, OffSets = Appartment[1], Appartment[2]
        end)
    else
        local Appartment = {}
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        local CoordsTable = {x = Config.Locations[CurrentAppartment]['Enter']['X'], y = Config.Locations[CurrentAppartment]['Enter']['Y'], z = Config.Locations[CurrentAppartment]['Enter']['Z'] - 35.0}
        TriggerEvent("pepe-sound:client:play", "house-door-open", 0.1)
        OpenDoorAnim()
        Citizen.Wait(350)
        if Framework.Functions.GetPlayerData().metadata['appartment-tier'] == 1 then
            Appartment = exports['pepe-interiors']:CreateMidAppartement(CoordsTable)
        else
            Appartment = exports['pepe-interiors']:CreateMidHotel(CoordsTable)
        end
        NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
        TriggerEvent('pepe-weathersync:client:DisableSync')
        IsInAppartment = true
        HouseData, OffSets = Appartment[1], Appartment[2]
    end
end)

RegisterNetEvent('pepe-appartments:client:open:appartment:stash')
AddEventHandler('pepe-appartments:client:open:appartment:stash', function(AppartmentId)
    TriggerServerEvent("pepe-inventory:server:OpenInventory", "stash", AppartmentId)
    TriggerEvent("pepe-inventory:client:SetCurrentStash", AppartmentId)
end)

-- // Functions \\ --

function IsNearHouse()
  for k, v in pairs(Config.Locations) do
      local PlayerCoords = GetEntityCoords(PlayerPedId())
      local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['Enter']['X'], v['Enter']['Y'], v['Enter']['Z'], true)
      if Distance < 3.0 then
          if k == Framework.Functions.GetPlayerData().metadata['appartment-data'].Name then
              CurrentAppartment = k
              IsNearAppartment = true
              return true
          end
      end
  end
end

function LeaveAppartment()
    TriggerEvent("pepe-sound:client:play", "house-door-open", 0.1)
    OpenDoorAnim()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    exports['pepe-interiors']:DespawnInterior(HouseData, function()
        NetworkSetEntityInvisibleToNetwork(PlayerPedId(), false)
        SetEntityCoords(PlayerPedId(), Config.Locations[CurrentAppartment]['Enter']['X'], Config.Locations[CurrentAppartment]['Enter']['Y'], Config.Locations[CurrentAppartment]['Enter']['Z'])
        SetEntityHeading(PlayerPedId(), Config.Locations[CurrentAppartment]['Enter']['H'])
        TriggerEvent('pepe-weathersync:client:EnableSync')
        Citizen.Wait(1000)
        IsInAppartment = false
        IsNearAppartment = false
        CurrentAppartment = nil
        HouseData, OffSets = nil, nil
        DoScreenFadeIn(1000)
        TriggerEvent("pepe-sound:client:play", "house-door-close", 0.1)
    end)
end

function LogoutPlayer()
  TriggerEvent("pepe-sound:client:play", "house-door-open", 0.1)
  DoScreenFadeOut(500)
  while not IsScreenFadedOut() do
      Citizen.Wait(10)
  end
  exports['pepe-interiors']:DespawnInterior(HouseData, function()
      NetworkSetEntityInvisibleToNetwork(PlayerPedId(), false)
      SetEntityCoords(PlayerPedId(), Config.Locations[CurrentAppartment]['Enter']['X'], Config.Locations[CurrentAppartment]['Enter']['Y'], Config.Locations[CurrentAppartment]['Enter']['Z'])
      SetEntityHeading(PlayerPedId(), Config.Locations[CurrentAppartment]['Enter']['H'])
      TriggerEvent('pepe-weathersync:client:EnableSync')
      Citizen.Wait(1000)
      IsInAppartment = false
      CurrentAppartment = nil
      HouseData, OffSets = nil, nil
      TriggerEvent("pepe-sound:client:play", "house-door-close", 0.1)
      Citizen.Wait(450)
      TriggerServerEvent('pepe-appartments:server:logout')
  end)
end

function OpenDoorAnim()
  exports['pepe-assets']:RequestAnimationDict('anim@heists@keycard@')
  TaskPlayAnim( PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
  Citizen.Wait(400)
  ClearPedTasks(PlayerPedId())
end

function AddBlipForAppartment()
  Framework.Functions.GetPlayerData(function(PlayerData)
    local Appartment = Framework.Functions.GetPlayerData().metadata['appartment-data'].Name
    Blips = AddBlipForCoord(Config.Locations[Appartment]['Enter']['X'], Config.Locations[Appartment]['Enter']['Y'], Config.Locations[Appartment]['Enter']['Z'])
    SetBlipSprite (Blips, 475)
    SetBlipDisplay(Blips, 4)
    SetBlipScale  (Blips, 0.48)
    SetBlipAsShortRange(Blips, true)
    SetBlipColour(Blips, 26)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Locations[Appartment]['Label'])
    EndTextCommandSetBlipName(Blips)
  end)
end

function RemoveAppartmentBlip()
    RemoveBlip(Blips)
end