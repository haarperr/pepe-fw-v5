local ClosestBank = nil
local ItemsNeeded = {}
CurrentCops = 0
LoggedIn = false

Framework = nil 

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
        Citizen.Wait(250)
        Framework.Functions.TriggerCallback("pepe-bankrobbery:server:get:key:config", function(config)
            Config = config
        end)
       LoggedIn = true
        CloseBankDoor(6)
    end)
end)

RegisterNetEvent('pepe-police:SetCopCount')
AddEventHandler('pepe-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        if LoggedIn then
            IsInBank = false
            for k, v in pairs(Config.BankLocations) do
                local Distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.BankLocations[k]["Coords"]["X"], Config.BankLocations[k]["Coords"]["Y"], Config.BankLocations[k]["Coords"]["Z"])
                if Distance < 15 then
                    ClosestBank = k
                    ItemsNeeded = {
                        [1] = {name = Framework.Shared.Items["electronickit"]["name"], image = Framework.Shared.Items["electronickit"]["image"]},
                        [2] = {name = Framework.Shared.Items[Config.BankLocations[k]['card-type']]["name"], image = Framework.Shared.Items[Config.BankLocations[k]['card-type']]["image"]},
                    }
                    IsInBank = true
                end
            end
            if not IsInBank then
                Citizen.Wait(2000)
                ItemsNeeded = {}
                ClosestBank = nil
            end
        end
        Citizen.Wait(3)
    end
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(4)
      if ClosestBank ~= nil then
        if not Config.BankLocations[ClosestBank]['IsOpened'] then
            local Distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.BankLocations[ClosestBank]["Coords"]["X"], Config.BankLocations[ClosestBank]["Coords"]["Y"], Config.BankLocations[ClosestBank]["Coords"]["Z"])
            if Distance < 1.2 then
                if not ItemsShowed then
                ItemsShowed = true
                TriggerEvent('pepe-inventory:client:requiredItems', ItemsNeeded, true)
                end
            else
                if ItemsShowed then
                ItemsShowed = false
                TriggerEvent('pepe-inventory:client:requiredItems', ItemsNeeded, false)
                end
            end
        end
        if Config.BankLocations[ClosestBank]['IsOpened'] then
           for k, v in pairs(Config.BankLocations[ClosestBank]['Lockers']) do
            local LockerDistance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], true)
            if LockerDistance < 0.5 then
                if Config.BankLocations[ClosestBank]["Lockers"][k]['IsBusy'] then
                    DrawMarker(2, Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 242, 148, 41, 255, false, false, false, 1, false, false, false)
                    Framework.Functions.DrawText3D(Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], _U("not_available"))
                elseif Config.BankLocations[ClosestBank]["Lockers"][k]['IsOpend'] then
                    Framework.Functions.DrawText3D(Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], _U("opened"))
                    DrawMarker(2, Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 72, 48, 255, false, false, false, 1, false, false, false)
                else
                    Framework.Functions.DrawText3D(Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], _U("cracksafe"))
                    DrawMarker(2, Config.BankLocations[ClosestBank]["Lockers"][k]["X"], Config.BankLocations[ClosestBank]["Lockers"][k]["Y"], Config.BankLocations[ClosestBank]["Lockers"][k]["Z"], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 48, 255, 58, 255, false, false, false, 1, false, false, false)
                    if IsControlJustReleased(0, 38) then
                        LockpickLocker(k)
                    end
                end
            end
           end
        end
     end
    end
end)

-- // Event \\ --

RegisterNetEvent('pepe-banking:achieve')
AddEventHandler('pepe-banking:achieve', function()
    StopAnimTask(PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    TriggerEvent('pepe-inventory:client:set:busy', false)
    TriggerServerEvent('Framework:Server:RemoveItem', Config.BankLocations[ClosestBank]['card-type'], 1)
    TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items[Config.BankLocations[ClosestBank]['card-type']], "remove")
    TriggerServerEvent('pepe-bankrobbery:server:set:open', ClosestBank, true)
end)

RegisterNetEvent('pepe-banking:fail')
AddEventHandler('pepe-banking:fail', function()
    StopAnimTask(PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 3.0, 3.0, -1, 2, 0, 0, 0, 0)
    Framework.Functions.Notify(_U("failed_msg"), "error")
end)

RegisterNetEvent('pepe-bankrobbery:client:set:open')
AddEventHandler('pepe-bankrobbery:client:set:open', function(BankId, bool)
  Config.BankLocations[BankId]['IsOpened'] = bool
  if bool then
    Citizen.SetTimeout(2500, function()
            OpenBankDoor(BankId)
    end)
  else
    CloseBankDoor(BankId)
  end
end)

RegisterNetEvent('pepe-bankrobbery:client:set:cards')
AddEventHandler('pepe-bankrobbery:client:set:cards', function(BankId, CardData)
    Config.BankLocations[BankId]['card-type'] = CardData
end)

RegisterNetEvent('pepe-bankrobbery:client:set:state')
AddEventHandler('pepe-bankrobbery:client:set:state', function(BankId, LockerId, Type, bool)
  Config.BankLocations[BankId]['Lockers'][LockerId][Type] = bool
end)

RegisterNetEvent('pepe-bankrobbery:client:use:card')
AddEventHandler('pepe-bankrobbery:client:use:card', function(CardType)
    if ClosestBank ~= nil then
      local PlayerCoords = GetEntityCoords(PlayerPedId(), false)
      local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.BankLocations[ClosestBank]["Coords"]["X"], Config.BankLocations[ClosestBank]["Coords"]["Y"], Config.BankLocations[ClosestBank]["Coords"]["Z"], true)
      if Distance < 1.5 then
        if not Config.BankLocations[ClosestBank]['IsOpened'] then
            if Config.BankLocations[ClosestBank]['card-type'] == CardType then
                if CurrentCops >= Config.NeededCops then
                   Framework.Functions.TriggerCallback('pepe-bankrobbery:server:HasItem', function(HasItem)
                       if HasItem then
                           Framework.Functions.TriggerCallback("pepe-bankrobbery:server:get:status", function(Status)
                               if not Status then
                                   if Config.BankLocations[ClosestBank]['Alarm'] then
                                   TriggerServerEvent('pepe-police:server:send:bank:alert', GetEntityCoords(PlayerPedId()), Framework.Functions.GetStreetLabel(), Config.BankLocations[ClosestBank]['CamId'])
                                   end
                                   TriggerEvent('pepe-inventory:client:requiredItems', ItemsNeeded, false)
                                   TriggerEvent('pepe-inventory:client:set:busy', true)
                                   if ClosestBank ~= 6 then          
                                    local time = math.random(40,90)               
                                    TriggerEvent('pepe:numbers:start', time, function(result)
                                        if result then
                                            TriggerEvent('pepe-inventory:client:set:busy', false)
                                            TriggerServerEvent('pepe-bankrobbery:server:set:open', ClosestBank, true)
                                             Citizen.SetTimeout(1250, function()
                                               TriggerServerEvent('Framework:Server:RemoveItem', Config.BankLocations[ClosestBank]['card-type'], 1)
                                               TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items[Config.BankLocations[ClosestBank]['card-type']], "remove")    
                                             end)
                                        else
                                            TriggerEvent('pepe-inventory:client:set:busy', false)
                                            Framework.Functions.Notify(_U("failed_msg"), "error")
                                        end
                                    end)
                                   else
                                    exports['pepe-assets']:RequestAnimationDict("anim@heists@prison_heiststation@cop_reactions")
                                    TaskPlayAnim( PlayerPedId(), "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )

                                    exports['minigame-memoryminigame']:StartMinigame({
                                        success = 'pepe-banking:achieve',
                                        fail = 'pepe-banking:fail'
                                    })
                                end   
                               else
                                   Framework.Functions.Notify(_U("progress_msg"), "error")
                               end
                           end)
                       else
                           Framework.Functions.Notify(_U("missing_msg"), "error")
                       end
                   end, "electronickit")  
                else
                    Framework.Functions.Notify(_U("nocops"), "info")
                end
            else
                Framework.Functions.Notify(_U("not_correct_card"), "error")
            end
        end
      end
    end
end)

-- // Functions \\ --

-- function OnHackEnding(Outcome)
--     if Outcome then
--         TriggerEvent('pepe-inventory:client:set:busy', false)
--         TriggerServerEvent('pepe-bankrobbery:server:set:open', ClosestBank, true)
--          Citizen.SetTimeout(1250, function()
--            TriggerServerEvent('Framework:Server:RemoveItem', Config.BankLocations[ClosestBank]['card-type'], 1)
--            TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items[Config.BankLocations[ClosestBank]['card-type']], "remove")    
--          end)
--         else
--         TriggerEvent('pepe-inventory:client:set:busy', false)
--         Framework.Functions.Notify(_U("failed_msg"), "error")
--     end
-- end

function OpenBankDoor(BankId)
    local Object = GetClosestObjectOfType(Config.BankLocations[BankId]["Coords"]["X"], Config.BankLocations[BankId]["Coords"]["Y"], Config.BankLocations[BankId]["Coords"]["Z"], 5.0, Config.BankLocations[BankId]['Object']['Hash'], false, false, false)
    local CurrentHeading = Config.BankLocations[BankId]["Object"]['Closed'] 
    if Object ~= 0 then
        Citizen.CreateThread(function()
        while true do
            if BankId ~= 6 then
                if CurrentHeading ~= Config.BankLocations[BankId]['Object']['Opend'] then
                    SetEntityHeading(Object, CurrentHeading - 10)
                    CurrentHeading = CurrentHeading - 0.5
                else
                    break
                end
            else
                if CurrentHeading ~= Config.BankLocations[BankId]['Object']['Opend'] then
                    SetEntityHeading(Object, CurrentHeading + 10)
                    CurrentHeading = CurrentHeading + 0.5
                else
                    break
                end
            end
            Citizen.Wait(10)
        end
     end)
    end
end

function CloseBankDoor(BankId)
    local Object = GetClosestObjectOfType(Config.BankLocations[BankId]["Coords"]["X"], Config.BankLocations[BankId]["Coords"]["Y"], Config.BankLocations[BankId]["Coords"]["Z"], 5.0, Config.BankLocations[BankId]['Object']['Hash'], false, false, false)
    if Object ~= 0 then
        SetEntityHeading(Object, Config.BankLocations[BankId]["Object"]['Closed'])
    end
end

function LockpickLocker(LockerId)
    local Type = Config.BankLocations[ClosestBank]['Lockers'][LockerId]['Type']
    TriggerServerEvent('pepe-hud:server:gain:stress', math.random(1, 2))
    if Type == 'lockpick' then
        Framework.Functions.TriggerCallback("pepe-bankrobbery:server:HasLockpickItems", function(HasItem)
            if HasItem then
            TriggerServerEvent('pepe-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', true)
              exports['pepe-lockpick']:OpenLockpickGame(function(Success)
                  if Success then
                      Framework.Functions.Progressbar("break-safe", "Breaking Open..", math.random(10000, 15000), false, true, {
                          disableMovement = false,
                          disableCarMovement = false,
                          disableMouse = false,
                          disableCombat = true,
                      }, {
                          animDict = "anim@gangops@facility@servers@",
		                  anim = "hotwire",
		                  flags = 8,
                      }, {}, {}, function() -- Done
                           -- Remove Item Trigger.
                           StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                           TriggerServerEvent('pepe-bankrobbery:server:random:reward', math.random(1,3), ClosestBank)
                           TriggerServerEvent('pepe-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', false) 
                           TriggerServerEvent('pepe-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsOpend', true) 
                           TriggerServerEvent('Framework:Server:RemoveItem', "advancedlockpick", 1)
                           Framework.Functions.Notify(_U("success") .."", "success")
                      end, function()
                          StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
                          TriggerServerEvent('pepe-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', false)
                          Framework.Functions.Notify(_U("cancelled") .."", "error")
                      end)
                  else
                      Framework.Functions.Notify(_U("cancelled") .."", "error")
                      TriggerServerEvent('pepe-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', false) 
                  end
              end)
            else
                Framework.Functions.Notify(_U("nolockpicks") .."", "error")
            end
        end)
    elseif Type == 'drill' then
     Framework.Functions.TriggerCallback("pepe-bankrobbery:server:HasItem", function(HasItem)
        if HasItem then           
                    TriggerServerEvent('pepe-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', true)
                    PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", 1);
                    exports['pepe-assets']:RequestAnimationDict("anim@heists@fleeca_bank@drilling")
                    TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
                    exports['pepe-assets']:AddProp('Drill')
                    exports['minigame-drill']:StartDrilling(function(Success)
                       if Success then
                           exports['pepe-assets']:RemoveProp()
                           Framework.Functions.Notify(_U("success") .."", "success")
                           StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                           TriggerServerEvent('pepe-bankrobbery:server:random:reward', math.random(1,3))
                           TriggerServerEvent('pepe-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', false) 
                           TriggerServerEvent('pepe-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsOpend', true) 
                           TriggerServerEvent('Framework:Server:RemoveItem', "drill", 1)
                       else
                           exports['pepe-assets']:RemoveProp()
                           Framework.Functions.Notify(_U("cancelled") .."", "error")
                           StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
                           TriggerServerEvent('pepe-bankrobbery:server:set:state', ClosestBank, LockerId, 'IsBusy', false) 
                       end
                    end)
        else
            Framework.Functions.Notify(_U("nodrill") .."", "error")
        end
      end, 'drill')
    end
end