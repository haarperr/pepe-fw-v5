Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Commands.Add("newscam", "Grab a news camera", {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Cam:ToggleCam", source)
    end
end)

Framework.Commands.Add("newsmic", "Grab a news mic", {}, false, function(source, args)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Mic:ToggleMic", source)
    end
end)

