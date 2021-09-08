Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)
 
RegisterServerEvent('Openshop:kwk')
AddEventHandler('Openshop:kwk', function(bericht)
    local vaild = {}
    local invaild = {}

    local embed = {
        {
            ["color"] = "65450",
            ["description"] = "Someone opened the weaponshop.",
        }
    }
    PerformHttpRequest("CHANGEMEWEBHOOK", function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end
