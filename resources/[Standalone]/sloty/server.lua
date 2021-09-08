Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

--[[
RegisterServerEvent("nvanti_slots:BetsAndMoney")
AddEventHandler("nvanti_slots:BetsAndMoney", function(bets)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
        local xItem = xPlayer.getInventoryItem('chips')
        if xItem.count < 10 then
            TriggerClientEvent('nvanti:showNotification', _source, "Je hebt minimaal 10 chips nodig om te spelen!")
        else
            MySQL.Sync.execute("UPDATE users SET chips=@chips WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier, ['@jeton'] = xItem.count})
            TriggerClientEvent("nvanti_slots:UpdateSlots", _source, xItem.count)
            xPlayer.removeInventoryItem('chips', xItem.count)
        end
    end
end)]]--

RegisterServerEvent("nvanti_slots:BetsAndMoney")
AddEventHandler("nvanti_slots:BetsAndMoney", function()
   -- local Player = Framework.Functions.GetPlayer(_source)
    --local xItem = xPlayer.Functions.GetItemByName("casinochips")
    --local cash = Framework.Functions.GetPlayer(_source)
          -- TriggerClientEvent("nvanti_slots:UpdateSlots", _source, cash)
         TriggerClientEvent("nvanti_slots:UpdateSlots")
end)



RegisterServerEvent("nvanti_slots:updateCoins")
AddEventHandler("nvanti_slots:updateCoins", function(bets)
    local _source   = source
    local xPlayer   = Framework.Functions.GetPlayer(_source)
    if xPlayer then
        --MySQL.Sync.execute("UPDATE users SET zetony=@zetony WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier, ['@zetony'] = bets})
    end
end)

RegisterServerEvent("nvanti_slots:PayOutRewards")
AddEventHandler("nvanti_slots:PayOutRewards", function(amount)
    local _source   = source
    local xPlayer   = Framework.Functions.GetPlayer(_source)
    if xPlayer then
        amount = math.floor(tonumber(amount))
        if amount > 0 then
            xPlayer.Functions.AddItem('casinochips', amount)
        end
       -- MySQL.Sync.execute("UPDATE users SET zetony=0 WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier})
    end
end)

RegisterServerEvent("nvanti_slots:PayOutRewards")
AddEventHandler("nvanti_slots:PayOutRewards", function(amount)
    local _source   = source
    local xPlayer   = Framework.Functions.GetPlayer(_source)
    if xPlayer then
        amount = math.floor(tonumber(amount))
        if amount > 0 then
            xPlayer.Functions.AddItem('casinochips', count)
        end
        --MySQL.Sync.execute("UPDATE users SET chips=0 WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier})
    end
end)



RegisterServerEvent("route68_kasyno:WymienZetony")
AddEventHandler("route68_kasyno:WymienZetony", function(count)
    local _source   = source
    local xPlayer   = Framework.Functions.GetPlayer(_source)
    if xPlayer then
        local xItem = xPlayer.Functions.GetItemByName('casinochips').amount
        if xItem.count < count then
            --TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You don`t have that mush chips!'})
        elseif xItem.count >= count then
            local kwota = math.floor(count * 5)
            xPlayer.Functions.RemoveItem ('casinochips', count)
            --xPlayer.addMoney(kwota)
           -- TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You got $'..kwota..' for '..count..' chips.'})
        end
    end
end)

RegisterServerEvent("route68_kasyno:KupZetony")
AddEventHandler("route68_kasyno:KupZetony", function(count)
    local _source   = source
    local xPlayer   = Framework.Functions.GetPlayer(_source)
    if xPlayer then
        local cash = xPlayer.getMoney()
        local kwota = math.floor(count * 5)
        if kwota > cash then
           -- TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You don`t have that much money!'})
        elseif kwota <= cash then
            xPlayer.Functions.AddItem('casinochips', count)
           -- xPlayer.removeMoney(kwota)
           -- TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You got '..count..' chips for $'..kwota..'.'})
        end
    end
end)

RegisterServerEvent("route68_kasyno:KupAlkohol")
AddEventHandler("route68_kasyno:KupAlkohol", function(count, item)
    local _source   = source
    local xPlayer   = Framework.Functions.GetPlayer(_source)
    if xPlayer then
        local cash = xPlayer.getMoney()
        local kwota = math.floor(count * 10)
        if kwota > cash then
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You don`t have that much money!'})
        elseif kwota <= cash then
            xPlayer.Functions.AddItem(item, count)
            --xPlayer.removeMoney(kwota)
            TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You got '..count..' items for $'..count..'.'})
        end
    end
end)

RegisterServerEvent("route68_kasyno:getJoinChips")
AddEventHandler("route68_kasyno:getJoinChips", function()
     local _source   = source
     local xPlayer   = Framework.Functions.GetPlayer(_source)
    -- local identifier = xPlayer.identifier
    -- MySQL.Async.fetchAll('SELECT zetony FROM users WHERE @identifier=identifier', {
	-- 	['@identifier'] = identifier
	-- }, function(result)
	-- 	if result[1] then
    --         local zetony = result[1].zetony
    --         if zetony > 0 then
               -- TriggerClientEvent('pNotify:SendNotification', _source, {text = 'You got '..tostring(zetony)..' chips, because you left during slots game.'})
                --xPlayer.Functions.AddItem('casinochips', zetony)
    --            -- MySQL.Sync.execute("UPDATE users SET zetony=0 WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier})
    --         end
	-- 	end
	-- end)
end)