local HasItem, AddedProp = false, false
Framework = nil
LoggedIn = false

RegisterNetEvent('Framework:Client:OnPlayerLoaded')
AddEventHandler('Framework:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
        TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)    
        Citizen.Wait(1250)
        Framework.Functions.TriggerCallback('pepe-illegal:server:get:config', function(ConfigData)
            Config = ConfigData
        end)
        Citizen.Wait(350)
        SpawnNpcs()
        LoggedIn = true
    end)
end)

RegisterNetEvent('Framework:Client:OnPlayerUnload')
AddEventHandler('Framework:Client:OnPlayerUnload', function()
    DespawnNpcs()
    RemovePropFromHands()
    ResetCornerSelling()
    LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            Framework.Functions.TriggerCallback('pepe-illegal:serverhas:robbery:item', function(HoldItem)
                if HoldItem then
                    if not AddedProp then
                        AddedProp = true
                        AddPropToHands(HoldItem)
                    end
                else
                    if AddedProp then
                        AddedProp = false
                        RemovePropFromHands()
                    end
                end
            end)
            Citizen.Wait(350)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('pepe-illegal:client:unpack:coke')
AddEventHandler('pepe-illegal:client:unpack:coke', function()
    Citizen.SetTimeout(750, function()
        TriggerEvent('pepe-inventory:client:set:busy', true)
        TriggerEvent("pepe-sound:client:play", "unwrap", 0.4)
        Framework.Functions.Progressbar("open-brick", "Unwrapping..", 7500, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "amb@world_human_clipboard@male@idle_a",
            anim = "idle_c",
            flags = 49,
        }, {}, {}, function() -- Done
            TriggerEvent('pepe-inventory:client:set:busy', false)
            TriggerServerEvent('pepe-illegal:server:unpack:coke')
            Framework.Functions.Notify("Unwrapped woohoo", "success")
            StopAnimTask(PlayerPedId(), "amb@world_human_clipboard@male@idle_a", "idle_c", 1.0)
        end, function()
            TriggerEvent('pepe-inventory:client:set:busy', false)
            Framework.Functions.Notify("Canceled..", "error")
            StopAnimTask(PlayerPedId(), "amb@world_human_clipboard@male@idle_a", "idle_c", 1.0)
        end)
    end)
end)

-- // Functions \\ --

function GetActiveServerPlayers()
    local PlayerPeds = {}
    if next(PlayerPeds) == nil then
        for _, Player in ipairs(GetActivePlayers()) do
            local PlayerPed = GetPlayerPed(Player)
            table.insert(PlayerPeds, PlayerPed)
        end
        return PlayerPeds
    end
end

function AddPropToHands(PropName)
    HasItem = true
    exports['pepe-assets']:AddProp(PropName)
    if PropName ~= 'Duffel' then
        while HasItem do
            Citizen.Wait(4)
            if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
                exports['pepe-assets']:RequestAnimationDict("anim@heists@box_carry@")
                TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
            else
                Citizen.Wait(100)
            end
        end
    end
end

function RemovePropFromHands()
    HasItem = false
    exports['pepe-assets']:RemoveProp()
    StopAnimTask(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 1.0)
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