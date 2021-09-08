Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback('pepe-board:server:GetActiveCops', function(source, cb)
    local retval = 0
    
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                retval = retval + 1
            end
        end
    end

    cb(retval)
end)

Framework.Functions.CreateCallback('pepe-board:server:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

RegisterServerEvent('pepe-board:server:SetActivityBusy')
AddEventHandler('pepe-board:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('pepe-board:client:SetActivityBusy', -1, activity, bool)
end)