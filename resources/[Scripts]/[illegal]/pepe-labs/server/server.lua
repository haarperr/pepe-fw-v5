local Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Functions.CreateCallback('pepe-illegal:server:get:config', function(source, cb)
    cb(Config)
end)

Citizen.CreateThread(function()
    Config.Labs[1]['Coords']['Enter'] = {['X'] = 180.22, ['Y'] = -1831.49, ['Z'] = 28.12}
    Config.Labs[2]['Coords']['Enter'] = {['X'] = 1741.41, ['Y'] = 6419.53, ['Z'] = 35.04}
    Config.Labs[3]['Coords']['Enter'] = {['X'] = 989.04, ['Y'] = -2421.48, ['Z'] = 29.83}
    Config.PedInteraction[1]['Coords'] = {['X'] = 257.78, ['Y'] = -1204.22, ['Z'] = 29.28, ['H'] = 269.63}
    Config.PedInteraction[2]['Coords'] = {['X'] = 871.565, ['Y'] = -158.0555, ['Z'] = 78.34542, ['H'] = 149.83982}
    Config.PedInteraction[3]['Coords'] = {['X'] = 704.9465, ['Y'] = -960.7758, ['Z'] = 30.39534, ['H'] = 262.591}
    Config.PedInteraction[4]['Coords'] = {['X'] = -88.69, ['Y'] = 6493.68, ['Z'] = 32.10, ['H'] = 230.06}
    Config.PedInteraction[7]['Coords'] = {['X'] = 410.43, ['Y'] = -1910.73, ['Z'] = 25.45, ['H'] = 84.58}
    Config.PedInteraction[14]['Coords'] = {['X'] = -661.78, ['Y'] = -861.60, ['Z'] = 24.49, ['H'] = 319.73}
end)

Framework.Functions.CreateCallback('pepe-illegal:serverhas:robbery:item', function(source, cb)
    local Player = Framework.Functions.GetPlayer(source)
    local StolenTv = Player.Functions.GetItemByName('stolen-tv')
    local StolenMicro = Player.Functions.GetItemByName('stolen-micro')
    local StolenPc = Player.Functions.GetItemByName('stolen-pc')
    local DuffleBag = Player.Functions.GetItemByName('duffel-bag')
    if StolenTv ~= nil then
        cb('StolenTv')
    elseif StolenMicro ~= nil then
        cb('StolenMicro')
    elseif StolenPc ~= nil then
        cb('StolenPc')
    elseif DuffleBag ~= nil then
        cb('Duffel')
    else 
        cb(false)
    end
end)

Framework.Functions.CreateCallback('pepe-illegal:server:has:drugs', function(source, cb)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    for k, v in pairs(Config.SellDrugs) do
        local DrugsData = Player.Functions.GetItemByName(k)
        if DrugsData ~= nil then
            cb(true)
        end
    end
    cb(false)
end)

Framework.Functions.CreateCallback('pepe-illegal:server:get:drugs:items', function(source, cb)
    local src = source
    local AvailableDrugs = {}
    local Player = Framework.Functions.GetPlayer(src)
    for k, v in pairs(Config.SellDrugs) do
        local DrugsData = Player.Functions.GetItemByName(k)
        if DrugsData ~= nil then
            table.insert(AvailableDrugs, {['Item'] = DrugsData.name, ['Amount'] = DrugsData.amount})
        end
    end
    cb(AvailableDrugs)
end)

RegisterServerEvent('pepe-illegal:server:unpack:coke')
AddEventHandler('pepe-illegal:server:unpack:coke', function()
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem('packed-coke-brick', 1) then
        Player.Functions.AddItem('pure-coke-brick', math.random(2, 3))
        TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['pure-coke-brick'], "add")
        TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items['packed-coke-brick'], "remove")
    end
end)

RegisterServerEvent('pepe-illegal:server:finish:corner:selling')
AddEventHandler('pepe-illegal:server:finish:corner:selling', function(Price, ItemName, ItemAmount)
    local Player = Framework.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(ItemName, ItemAmount) then
        Player.Functions.AddMoney('cash', Price, 'corner-selling')
        TriggerClientEvent('pepe-inventory:client:ItemBox', source, Framework.Shared.Items[ItemName], "remove")
    end
end)

-- // Labs Inventory \\ --

function SetItemTimeout(LabId, Slot, ItemName, Amount, Info)
    Citizen.CreateThread(function()
        for i = 1, Amount, 1 do
            local SellData = Config.AllowedItems[ItemName]
            if SellData ~= nil then
                SetTimeout(SellData['Wait'], function()
                    if Config.Labs[LabId]['Inventory'][Slot] ~= nil then
                        RemoveProduct(LabId, Slot, ItemName, 1)
                        AddProduct(LabId, SellData['ToSlot'], SellData['Success'], SellData['Reward-Amount'], Info, SellData['Force'])
                        if SellData['Success'] == 'coke-powder' then
                            TriggerClientEvent('pepe-illegal:client:play:sound:coke', -1)
                        end
                        TriggerClientEvent('pepe-illegal:client:sync:inventory', -1, LabId, Config.Labs[LabId]['Inventory'])
                    end
                end)
                if Amount > 1 then
                    Citizen.Wait(SellData['Wait'])
                end
            end
        end
    end)
end

function AddProduct(LabId, Slot, ItemName, amount, Info, Force)
    local Amount = tonumber(amount)
    local LabId = tonumber(LabId)
    if Config.Labs[LabId]['Inventory'][Slot] ~= nil and Config.Labs[LabId]['Inventory'][Slot].name == ItemName then
        Config.Labs[LabId]['Inventory'][Slot].amount = Config.Labs[LabId]['Inventory'][Slot].amount + Amount
    else
        local itemInfo = Framework.Shared.Items[ItemName:lower()]
        Config.Labs[LabId]['Inventory'][Slot] = {
            name = itemInfo["name"],
            amount = Amount,
            info = Info ~= nil and Info or "",
            label = itemInfo["label"],
            description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
            weight = itemInfo["weight"], 
            type = itemInfo["type"], 
            unique = itemInfo["unique"], 
            useable = itemInfo["useable"], 
            image = itemInfo["image"],
            slot = Slot,
        }
    end
    if Force then
        TriggerClientEvent('pepe-illegal:client:sync:inventory', -1, LabId, Config.Labs[LabId]['Inventory'])
        SetItemTimeout(LabId, Slot, ItemName, Amount, Info)
    end
    TriggerClientEvent('pepe-illegal:client:sync:inventory', -1, LabId, Config.Labs[LabId]['Inventory'])
end

function RemoveProduct(LabId, Slot, ItemName, Amount)
	local Amount = tonumber(Amount)
    local LabId = tonumber(LabId)
	if Config.Labs[LabId]['Inventory'][Slot] ~= nil and Config.Labs[LabId]['Inventory'][Slot].name == ItemName then
		if Config.Labs[LabId]['Inventory'][Slot].amount > Amount then
			Config.Labs[LabId]['Inventory'][Slot].amount = Config.Labs[LabId]['Inventory'][Slot].amount - Amount
            TriggerClientEvent('pepe-illegal:client:sync:inventory', -1, LabId, Config.Labs[LabId]['Inventory'])
		else
			Config.Labs[LabId]['Inventory'][Slot] = nil
			if next(Config.Labs[LabId]['Inventory']) == nil then
				Config.Labs[LabId]['Inventory'] = {}
                TriggerClientEvent('pepe-illegal:client:sync:inventory', -1, LabId, Config.Labs[LabId]['Inventory'])
			end
		end
	else
		Config.Labs[LabId]['Inventory'][Slot] = nil
		if Config.Labs[LabId]['Inventory'] == nil then
			Config.Labs[LabId]['Inventory'][Slot] = nil
            TriggerClientEvent('pepe-illegal:client:sync:inventory', -1, LabId, Config.Labs[LabId]['Inventory'])
		end
	end
    TriggerClientEvent('pepe-illegal:client:sync:inventory', -1, LabId, Config.Labs[LabId]['Inventory'])
end

function GetInventoryData(Campfire, Slot)
    local LabId = tonumber(Campfire)
    if Config.Labs[LabId]['Inventory'] ~= nil then
        return Config.Labs[LabId]['Inventory'][Slot]
    else
        return nil
    end
end

function CanItemBePlaced(item)
    local retval = false
    if Config.AllowedItems[item] ~= nil then
        retval = true
    end
    return retval
end

-- // Meth Labs \\ --

RegisterServerEvent('pepe-illegal:server:add:ingredient')
AddEventHandler('pepe-illegal:server:add:ingredient', function(LabId, IngredientName, Bool, Amount)
  Config.Labs[LabId]['Ingredient-Count'] = Config.Labs[LabId]['Ingredient-Count'] + Amount
  Config.Labs[LabId]['Ingredients'][IngredientName] = Bool
  if Config.Labs[LabId]['Ingredients']['meth-ingredient-1'] and Config.Labs[LabId]['Ingredients']['meth-ingredient-2'] then
    Config.Labs[LabId]['Cooking'] = true
    TriggerClientEvent('pepe-illegal:client:start:cooking', -1, LabId)
  end
  TriggerClientEvent('pepe-illegal:client:sync:meth', -1, Config.Labs[LabId], LabId, false)
end)

RegisterServerEvent('pepe-illegal:server:get:meth')
AddEventHandler('pepe-illegal:server:get:meth', function(RandomAmount, LabId)
 local src = source
 local Player = Framework.Functions.GetPlayer(src)
 ResetMethLab(LabId)
 Citizen.SetTimeout(150, function()
    Player.Functions.AddItem('meth-powder', RandomAmount)
    TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items['meth-powder'], "add")
 end)
end)

RegisterServerEvent('pepe-illegal:server:reset:meth')
AddEventHandler('pepe-illegal:server:reset:meth', function(LabId)
    ResetMethLab(LabId)
end)

function ResetMethLab(LabId)
 Config.Labs[LabId]['Cooking'] = false
 Config.Labs[LabId]['Ingredients']['meth-ingredient-1'] = false
 Config.Labs[LabId]['Ingredients']['meth-ingredient-2'] = false
 Config.Labs[LabId]['Ingredient-Count'] = 0
 TriggerClientEvent('pepe-illegal:client:sync:meth', -1, Config.Labs[LabId], LabId, true)
end

function GetCokeCrafting(ItemId)
    return Config.CokeCrafting[ItemId]
end

function GetMethCrafting(ItemId)
    return Config.MethCrafting[ItemId]
end

-- // Money Printer \\ --

RegisterServerEvent('pepe-illegal:server:add:printer:item')
AddEventHandler('pepe-illegal:server:add:printer:item', function(LabId, ItemType, Amount)
    Config.Labs[LabId][ItemType] = Config.Labs[LabId][ItemType] + Amount
    TriggerClientEvent('pepe-illegal:client:sync:items', -1, ItemType, Config.Labs[LabId][ItemType])
end)

RegisterServerEvent('pepe-illegal:server:remove:printer:item')
AddEventHandler('pepe-illegal:server:remove:printer:item', function(LabId, ItemType, Amount)
    Config.Labs[LabId][ItemType] = Config.Labs[LabId][ItemType] - Amount
    TriggerClientEvent('pepe-illegal:client:sync:items', -1, ItemType, Config.Labs[LabId][ItemType])
end)

RegisterServerEvent('pepe-illegal:server:set:printer:money')
AddEventHandler('pepe-illegal:server:set:printer:money', function(LabId, Amount)
    Config.Labs[LabId]['Total-Money'] = Config.Labs[LabId]['Total-Money'] + Amount
    TriggerClientEvent('pepe-illegal:client:sync:money', -1, Config.Labs[LabId]['Total-Money'])
end)

RegisterServerEvent('pepe-illegal:server:get:money:printer:money')
AddEventHandler('pepe-illegal:server:get:money:printer:money', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', Config.Labs[3]['Total-Money'], 'money-printer')
    Config.Labs[3]['Total-Money'] = 0
    TriggerClientEvent('pepe-illegal:client:sync:money', -1, Config.Labs[3]['Total-Money'])
end)

--- Electrnics 

RegisterServerEvent('pepe-illegal:server:sell:electrnoics')
AddEventHandler('pepe-illegal:server:sell:electrnoics', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    for k, v in pairs(Player.PlayerData.items) do
        if v.name == 'stolen-tv' then
            Player.Functions.RemoveItem('stolen-tv', 1)
            Player.Functions.AddItem('money-roll', math.random(50, 85))
            Player.Functions.AddMoney('cash', math.random(1500, 2100), 'sold-stolen-goods')
            TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['stolen-tv'], "remove")
        elseif v.name == 'stolen-micro' then
            Player.Functions.RemoveItem('stolen-micro', 1)
            Player.Functions.AddItem('money-roll', math.random(50, 85))
            Player.Functions.AddMoney('cash', math.random(1500, 2100), 'sold-stolen-goods')
            TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['stolen-micro'], "remove")
        elseif v.name == 'stolen-pc' then
            Player.Functions.RemoveItem('stolen-pc', 1)
            Player.Functions.AddItem('money-roll', math.random(50, 85))
            Player.Functions.AddMoney('cash', math.random(1500, 2100), 'sold-stolen-goods')
            TriggerClientEvent('pepe-inventory:client:ItemBox', Player.PlayerData.source, Framework.Shared.Items['stolen-pc'], "remove")
        end
    end
end)