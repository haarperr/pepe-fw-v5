local OpeningRegister = false
local CurrentSafe, NearSafe = nil, false
local CurrentRegister, NearRegister = nil, false
local CurrentCops = 0
local isLoggedIn = false
local Framework = nil

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
  Citizen.SetTimeout(1250, function()
      TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
      Citizen.Wait(100)
      Framework.Functions.TriggerCallback("pepe-storerobbery:server:get:config", function(ConfigData)
        Config = ConfigData
      end)
      isLoggedIn = true
  end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('pepe-police:SetCopCount')
AddEventHandler('pepe-police:SetCopCount', function(Amount)
    CurrentCops = Amount
end)

-- Code

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(4)
        if isLoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            NearRegister = false
            for k, v in pairs(Config.Registers) do
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                if Distance < 1.2 then
                  NearRegister = true
                  CurrentRegister = k
                  if v['Robbed'] then
                    DrawText3D(v['X'], v['Y'], v['Z'], '~r~Register is empty...')
                  elseif v['Busy'] then
                    DrawText3D(v['X'], v['Y'], v['Z'], '~o~Robbing Register..')
                  end
               end
            end
            if not NearRegister then
                Citizen.Wait(1500)
                CurrentRegister = nil
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(4)
        if isLoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            NearSafe = false
            for k, v in pairs(Config.Safes) do
                local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                if Distance < 1.5 then
                    NearSafe = true
                    CurrentSafe = k
                    if v['Robbed'] then
                      DrawText3D(v['X'], v['Y'], v['Z'], '~r~Safe is empty...')
                    elseif v['Busy'] then
                      DrawText3D(v['X'], v['Y'], v['Z'], '~o~Robbing safe..')
                    end
                end
            end
             if not NearSafe then
                 Citizen.Wait(1500)
                 CurrentSafe = nil
             end
        else
           Citizen.Wait(1500)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('pepe-storerobbery:client:set:register:robbed')
AddEventHandler('pepe-storerobbery:client:set:register:robbed', function(RegisterId, bool)
    Config.Registers[RegisterId]['Robbed'] = bool
end)

RegisterNetEvent('pepe-storerobbery:client:set:register:busy')
AddEventHandler('pepe-storerobbery:client:set:register:busy', function(RegisterId, bool)
    Config.Registers[RegisterId]['Busy'] = bool
end)

RegisterNetEvent('pepe-storerobbery:client:safe:busy')
AddEventHandler('pepe-storerobbery:client:safe:busy', function(SafeId, bool)
    Config.Safes[SafeId]['Busy'] = bool
end)

RegisterNetEvent('pepe-storerobbery:client:safe:robbed')
AddEventHandler('pepe-storerobbery:client:safe:robbed', function(SafeId, bool)
    Config.Safes[SafeId]['Robbed'] = bool
end)

RegisterNetEvent('pepe-items:client:use:lockpick')
AddEventHandler('pepe-items:client:use:lockpick', function(IsAdvanced)
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    if NearRegister then
        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Registers[CurrentRegister]['X'], Config.Registers[CurrentRegister]['Y'], Config.Registers[CurrentRegister]['Z'], true)
        if Distance < 1.3 and not Config.Registers[CurrentRegister]['Robbed'] then
         if CurrentCops >= Config.PoliceNeeded then
                if IsAdvanced then
                    LockPickRegister(CurrentRegister, IsAdvanced)
                else
                    Framework.Functions.TriggerCallback('pepe-storerobbery:server:HasItem', function(HasItem)
                        if HasItem then
                            LockPickRegister(CurrentRegister, IsAdvanced)
                        else
                            Framework.Functions.Notify("You are missing something", "error")
                        end
                    end, "toolkit") 
                end
            else
                Framework.Functions.Notify("Not enough cops ("..Config.PoliceNeeded.." Needed)", "info")
            end
        end
    elseif NearSafe then
        local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Safes[CurrentSafe]['X'], Config.Safes[CurrentSafe]['Y'], Config.Safes[CurrentSafe]['Z'], true)
        if Distance < 1.3 and not Config.Safes[CurrentSafe]['Robbed'] then
            if CurrentCops >= Config.PoliceNeeded then
                if IsAdvanced then
                    CrackSafe(CurrentSafe, IsAdvanced)
                else
                    Framework.Functions.TriggerCallback('pepe-storerobbery:server:HasItem', function(HasItem)
                        if HasItem then
                            CrackSafe(CurrentSafe, IsAdvanced)
                        else
                            Framework.Functions.Notify("You are missing something", "error")
                        end
                    end, "toolkit") 
                end
            else
                Framework.Functions.Notify("Not enough cops ("..Config.PoliceNeeded.." Needed)", "info")
            end
        end

    end
end)

-- Function

function LockPickRegister(RegisterId, IsAdvanced)
 local LockPickTime = math.random(15000, 25000)
 if not IsWearingHandshoes() then
    TriggerServerEvent("pepe-police:server:CreateFingerDrop", GetEntityCoords(PlayerPedId()))
 end

 if math.random(1,10) < 9 then
    local StreetLabel = Framework.Functions.GetStreetLabel()
    TriggerServerEvent('pepe-police:server:send:alert:store', GetEntityCoords(PlayerPedId()), StreetLabel, Config.Registers[RegisterId]['SafeKey'])
 end

 TriggerServerEvent('pepe-storerobbery:server:set:register:busy', RegisterId, true)
 exports['pepe-lockpick']:OpenLockpickGame(function(Success)
     if Success then
         LockPickRegisterAnim(LockPickTime)
         TriggerServerEvent('pepe-storerobbery:server:set:register:robbed', RegisterId, true)
         TriggerServerEvent('pepe-storerobbery:server:set:register:busy', RegisterId, false)
         Framework.Functions.Progressbar("search_register", "Robbing Register..", LockPickTime, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done    
            OpeningRegister = false
            TriggerServerEvent('pepe-storerobbery:server:rob:register', RegisterId, true)
        end, function() -- Cancel
            OpeningRegister = false
            TriggerServerEvent('pepe-storerobbery:server:set:register:busy', RegisterId, false)
        end)
     else
        if IsAdvanced then
            if math.random(1,100) <= 19 then
              TriggerServerEvent('pepe-police:server:CreateBloodDrop', GetEntityCoords(PlayerPedId()))
              TriggerServerEvent('Framework:Server:RemoveItem', 'advancedlockpick', 1)
              TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['advancedlockpick'], "remove")
            end
        else
            if math.random(1,100) <= 35 then
              TriggerServerEvent('pepe-police:server:CreateBloodDrop', GetEntityCoords(PlayerPedId()))
              TriggerServerEvent('Framework:Server:RemoveItem', 'lockpick', 1)
              TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['lockpick'], "remove")
            end
        end
        Framework.Functions.Notify("Failed..", "error")
        TriggerServerEvent('pepe-storerobbery:server:set:register:busy', RegisterId, false)
     end
 end)
end

function CrackSafe(SafeId, IsAdvanced)
    if not IsWearingHandshoes() then
        TriggerServerEvent("pepe-police:server:CreateFingerDrop", GetEntityCoords(PlayerPedId()))
    end
    if math.random(1,100) < 40 then
        local StreetLabel = Framework.Functions.GetStreetLabel()
        TriggerServerEvent('pepe-police:server:send:alert:store', GetEntityCoords(PlayerPedId()), StreetLabel, SafeId)
    end
    FreezeEntityPosition(PlayerPedId(), true)
    TriggerServerEvent('pepe-storerobbery:server:safe:busy', SafeId, true)
    exports['minigame-safecrack']:StartSafeCrack(8, function(OutCome)
        if OutCome == true then
            TriggerServerEvent("pepe-storerobbery:server:safe:reward", SafeId)
            TriggerServerEvent('pepe-storerobbery:server:safe:busy', SafeId, false)
            TriggerServerEvent("pepe-storerobbery:server:safe:robbed", SafeId, true)
            FreezeEntityPosition(PlayerPedId(), false)
            TakeAnimation()
        elseif OutCome == false and OutCome ~= 'Escaped' then
            if IsAdvanced then
                if math.random(1,100) <= 10 then
                  TriggerServerEvent('pepe-police:server:CreateBloodDrop', GetEntityCoords(PlayerPedId()))
                  TriggerServerEvent('Framework:Server:RemoveItem', 'advancedlockpick', 1)
                  TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['advancedlockpick'], "remove")
                end
            else
                if math.random(1,100) <= 20 then
                  TriggerServerEvent('pepe-police:server:CreateBloodDrop', GetEntityCoords(PlayerPedId()))
                  TriggerServerEvent('Framework:Server:RemoveItem', 'lockpick', 1)
                  TriggerEvent("pepe-inventory:client:ItemBox", Framework.Shared.Items['lockpick'], "remove")
                end
            end
            Framework.Functions.Notify("Failed..", "error")
            TriggerServerEvent('pepe-storerobbery:server:safe:busy', SafeId, false)
            FreezeEntityPosition(PlayerPedId(), false)
        else
            Framework.Functions.Notify("Failed..", "error")
            TriggerServerEvent('pepe-storerobbery:server:safe:busy', SafeId, false)
            FreezeEntityPosition(PlayerPedId(), false)
        end
    end)
end

function LockPickRegisterAnim(time)
 time = time / 1000
 exports['pepe-assets']:RequestAnimationDict("veh@break_in@0h@p_m_one@")
 TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
 OpeningRegister = true
 Citizen.CreateThread(function()
     while OpeningRegister do
         TriggerServerEvent('pepe-hud:server:gain:stress', 1)
         TriggerServerEvent('pepe-storerobbery:server:rob:register', CurrentRegister, false)  
         TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
         Citizen.Wait(2000)
         time = time - 2
         if time <= 0 then
             OpeningRegister = false
             StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
         end
     end
 end)
end

function TakeAnimation()
 exports['pepe-assets']:RequestAnimationDict("amb@prop_human_bum_bin@idle_b")
 TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
 Citizen.Wait(1500)
 TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
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
  local factor = (string.len(text)) / 370
  DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
  ClearDrawOrigin()
end

function IsWearingHandshoes()
  local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
  local model = GetEntityModel(PlayerPedId())
  local retval = true
  if model == GetHashKey("mp_m_freemode_01") then
      if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
          retval = false
      end
  else
      if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
          retval = false
      end
  end
  return retval
end