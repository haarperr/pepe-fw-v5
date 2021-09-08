local MinigameStarted = false
local MinigameFinished = false
local MinigameFailed = false
local MinigameCB = {}

-- TriggerEvent('ORP:LoadCore', function(obj) ORP = obj end)

-- RegisterCommand('minigame', function(source, args)
--     local time = tonumber(args[1])

--     TriggerEvent('onyx_numbers:start', time, function(result)
--         print('starting minigame')
--         if result then
--             print('success')
--         else
--             print('failed')
--         end
--     end)
-- end)

RegisterNetEvent('pepe:numbers:start')
AddEventHandler('pepe:numbers:start', function(time, cb)
    if not MinigameStarted then
        MinigameCB = cb
        MinigameStarted = true

        SendNUIMessage({action = "show", time = time})
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(false)

        Citizen.CreateThread(function()
            while MinigameStarted do
                Citizen.Wait(7)
                if MinigameFinished then
                    if MinigameFailed then
                        cb(false)
                        ResetMinigame()
                    else
                        cb(true)
                        ResetMinigame()
                    end
                end
            end
        end)
    end
end)

ResetMinigame = function()
    MinigameStarted = false
    MinigameFinished = false
    MinigameFailed = false
    MinigameCB = {}
    SendNUIMessage({action = "reset"})
end

RegisterNUICallback('GameFinished', function(data)
    SetNuiFocus(false, false)
    MinigameFailed = not data.status
    MinigameFinished = true
end)