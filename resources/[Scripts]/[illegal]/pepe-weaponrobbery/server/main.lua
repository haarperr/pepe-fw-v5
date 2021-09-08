Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

local timeOut = false

local alarmTriggered = false

Framework.Functions.CreateCallback('pepe-weashop:vitrineReward', function(source, cb)
	local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local otherchance = math.random(1, 2)
    local odd = math.random(1, 2)

    if otherchance == odd then
        local item = math.random(1, #Config.VitrineRewards)
        local amount = math.random(Config.VitrineRewards[item]["amount"]["min"], Config.VitrineRewards[item]["amount"]["max"])
        if Player.Functions.AddItem(Config.VitrineRewards[item]["item"], amount) then
            TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[Config.VitrineRewards[item]["item"]], 'add')
        else
            TriggerClientEvent('Framework:Notify', src, 'Your pockets are full..', 'error')
        end
    else
        local amount = math.random(1, 2)
        local data = {
            worth = math.random(200,2000)
        }
    
        Player.Functions.AddItem('markedbills', 1, false, data)
        TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items["markedbills"], 'add')
        TriggerClientEvent('Framework:Notify', src, 'Dirty cash recieved: $' ..data.worth, "success")

    end
end)	

Framework.Functions.CreateCallback('pepe-weashop:server:setVitrineState', function(source, cb, stateType, state, k)
	Config.Locations[k][stateType] = state
    TriggerClientEvent('pepe-weashop:client:setVitrineState', -1, stateType, state, k)
end)

Framework.Functions.CreateCallback('pepe-weashop:server:setTimeout', function(source, cb)
	if not timeOut then
        timeOut = true
        TriggerEvent('pepe-board:server:SetActivityBusy', "weaponshop", true)
        Citizen.CreateThread(function()
            Citizen.Wait(Config.Timeout)

            for k, v in pairs(Config.Locations) do
                Config.Locations[k]["isOpened"] = false
                TriggerClientEvent('pepe-weashop:client:setVitrineState', -1, 'isOpened', false, k)
                TriggerClientEvent('pepe-weashop:client:setAlertState', -1, false)
                TriggerEvent('pepe-board:server:SetActivityBusy', "weaponshop", false)
            end
            timeOut = false
            alarmTriggered = false
        end)
    end
end)

Framework.Functions.CreateCallback('pepe-weashop:server:PoliceAlertMessage', function(source, cb, title, coords, blip)
	local src = source
    local alertData = {
        title = title,
        coords = {x = coords.x, y = coords.y, z = coords.z},

        description = "Possible robbery at Ammunation store <br>Camera: 39",
    }

    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                if blip then
                    if not alarmTriggered then
                        TriggerClientEvent("pepe-phone:client:addPoliceAlert", v, alertData)
                        TriggerClientEvent("pepe-weashop:client:PoliceAlertMessage", v, title, coords, blip)
                        alarmTriggered = true
                    end
                else
                    TriggerClientEvent("pepe-phone:client:addPoliceAlert", v, alertData)
                    TriggerClientEvent("pepe-weashop:client:PoliceAlertMessage", v, title, coords, blip)
                end
            end
        end
    end
end)

Framework.Functions.CreateCallback('pepe-weashop:server:getCops', function(source, cb)
	local amount = 0
    for k, v in pairs(Framework.Functions.GetPlayers()) do
        local Player = Framework.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
	end
	cb(amount)
end)