Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('pepe-taco:server:start:black')
AddEventHandler('pepe-taco:server:start:black', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(source)
    TriggerClientEvent('pepe-taco:start:black:job', src)
    Player.Functions.AddItem("taco-bag", 1)
    TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['taco-bag'], 'add')
    TriggerClientEvent("hud:client:OnMoneyChange")
end)

Framework.Functions.CreateCallback('pepe-tacos:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('pepe-taco:server:reward:money')
AddEventHandler('pepe-taco:server:reward:money', function()
--Framework.Functions.CreateCallback('pepe-taco:server:reward:money', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', math.random(50, 312), "taco-shop-reward")
    TriggerClientEvent('Framework:Notify', source, "Taco delivered! Go back to the taco shop for a new delivery", "success")
    Player.Functions.RemoveItem('taco-bag', 1)
    TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['taco-bag'], 'remove')

end)

RegisterServerEvent('pepe-tacos:server:get:stuff')
AddEventHandler('pepe-tacos:server:get:stuff', function()
    local Player = Framework.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.AddItem('taco-box', 1)
        TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['taco-box'], 'add')
    end
end)


RegisterServerEvent('pepe-tacos:server:rem:taco')
AddEventHandler('pepe-tacos:server:rem:taco', function()
    local Player = Framework.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.RemoveItem('taco', 1)
        TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['taco'], 'add')
    end
end)

RegisterServerEvent('pepe-tacos:server:rem:tacobox')
AddEventHandler('pepe-tacos:server:rem:tacobox', function()
    local Player = Framework.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.RemoveItem('taco', 1)
        TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['taco'], 'add')
    end
end)

RegisterServerEvent('pepe-tacos:server:rem:stuff')
AddEventHandler('pepe-tacos:server:rem:stuff', function(what)
    local Player = Framework.Functions.GetPlayer(source)
    
   -- if Player ~= nil then
    if Player ~= nil and what == "meat" or what == "lettuce" or what == "taco-box" or what == "taco" then
        Player.Functions.RemoveItem(what, 1)
        TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['what'], 'add')
    end
end)

RegisterServerEvent('pepe-tacos:server:add:stuff')
AddEventHandler('pepe-tacos:server:add:stuff', function(what)
    local Player = Framework.Functions.GetPlayer(source)
    
    --if Player ~= nil then
    if Player ~= nil and what == "meat" or what == "lettuce" or what == "taco-box" or what == "taco" then
        Player.Functions.AddItem(what, 1)
        TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['what'], 'add')
    end
end)


RegisterServerEvent('pepe-taco:server:set:taco:count')
AddEventHandler('pepe-taco:server:set:taco:count', function(plusormin, stock, amount)
    local meatstock
    local lettucestock
    if plusormin == 'Min' then
        if stock == 'stock-meat' then
            Config.JobData[stock] = Config.JobData[stock] - amount
            TriggerClientEvent('pepe-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "stock-lettuce" then
            Config.JobData[stock] = Config.JobData[stock] - amount
            TriggerClientEvent('pepe-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "tacos" then
            Config.JobData[stock] = Config.JobData[stock] - amount
            TriggerClientEvent('pepe-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "register" then
            Config.JobData[stock] = Config.JobData[stock] - amount
            TriggerClientEvent('pepe-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        end   
    elseif plusormin == 'Plus' then
        if stock == 'stock-meat' then
            Config.JobData[stock] = Config.JobData[stock] + amount
            TriggerClientEvent('pepe-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "stock-lettuce" then
            Config.JobData[stock] = Config.JobData[stock] + amount
            TriggerClientEvent('pepe-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "tacos" then
            Config.JobData[stock] = Config.JobData[stock] + amount
            TriggerClientEvent('pepe-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "register" then
            Config.JobData[stock] = Config.JobData[stock] + amount
            TriggerClientEvent('pepe-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        end
    end
end)


Framework.Functions.CreateCallback('pepe-taco:server:get:ingredient', function(source, cb)
    local src = source
    local Ply = Framework.Functions.GetPlayer(src)
    local lettuce = Ply.Functions.GetItemByName("lettuce")
    local meat = Ply.Functions.GetItemByName("meat")
    if lettuce ~= nil and meat ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

Framework.Functions.CreateCallback('pepe-taco:server:get:tacobox', function(source, cb)
    local src = source
    local Ply = Framework.Functions.GetPlayer(src)
    local box = Ply.Functions.GetItemByName("taco-box")
    if box ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

Framework.Functions.CreateCallback('pepe-taco:server:get:tacos', function(source, cb)
    local src = source
    local Ply = Framework.Functions.GetPlayer(src)
    local taco = Ply.Functions.GetItemByName('taco')
    if taco ~= nil then
        cb(true)
    else
        cb(false)
    end
end)