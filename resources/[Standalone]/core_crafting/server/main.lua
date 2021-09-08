Framework  = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)




function setCraftingLevel(identifier, level)
	exports.ghmattimysql:execute("UPDATE `characters_metadata` SET `crafting_level`= @xp WHERE `citizenid` = @identifier", {["@xp"] = level, ["@identifier"] = identifier}, function(result)
	end)
end

function getCraftingLevel(identifier)
    local level = exports.ghmattimysql:executeSync("SELECT crafting_level FROM characters_metadata WHERE `citizenid` = '" ..identifier.. "'", {})
    level = tonumber(level[1]["crafting_level"])
   
    return level
end

function giveCraftingLevel(identifier, level)
	exports.ghmattimysql:execute("UPDATE `characters_metadata` SET `crafting_level`= `crafting_level` + @xp WHERE `citizenid` = @identifier", {["@xp"] = level, ["@identifier"] = identifier}, function(result)
	end)
end

RegisterServerEvent("core_crafting:setExperiance")
AddEventHandler("core_crafting:setExperiance", function(identifier, xp)
        setCraftingLevel(identifier, xp)
    end)

RegisterServerEvent("core_crafting:giveExperiance")
AddEventHandler(
    "core_crafting:giveExperiance",
    function(identifier, xp)
        giveCraftingLevel(identifier, xp)
    end
)

function craft(src, item, retrying)
    local xPlayer = Framework.Functions.GetPlayer(src)
    local inventory = xPlayer.PlayerData.items
    local cancraft = true
    local emptyslot = 0
    local totalWeight = Framework.Player.GetTotalWeight(xPlayer.PlayerData.items)
    local itemInfo = Framework.Shared.Items[item:lower()]
    local canCarry = true

    local count = Config.Recipes[item].Amount

    if not retrying then 
        for k, v in pairs(Config.Recipes[item].Ingredients) do
            if xPlayer.Functions.GetItemByName(k) == nil then
                cancraft = false
            elseif xPlayer.Functions.GetItemByName(k).amount < v and xPlayer.Functions.GetItemByName(k) ~= nil then
                cancraft = false
            end
        end
        for _, v in pairs(inventory) do
            emptyslot = emptyslot + 1
        end
        if emptyslot == Framework.Config.Player.MaxInvSlots or (totalWeight + (itemInfo["weight"] * count)) > Framework.Config.Player.MaxWeight then
            cancraft = false
            canCarry = false
        end
    end

    if cancraft then
        for k, v in pairs(Config.Recipes[item].Ingredients) do
            if not Config.PermanentItems[k] then
                xPlayer.Functions.RemoveItem(k, v)
                if Config.ShowInventoryNotification then
                    TriggerClientEvent('prp-inventory:client:ItemBox', src, Framework.Shared.Items[k], "remove")
                end
            end
        end
        TriggerClientEvent("core_crafting:craftStart", src, item, count)
    else
        if emptyslot == Framework.Config.Player.MaxInvSlots then
            TriggerClientEvent("core_crafting:sendMessage", src, Config.Text["inv_limit_exceed"], "error")
        elseif not canCarry then
            TriggerClientEvent("core_crafting:sendMessage", src, Config.Text["you_cant_hold_item"], "error")
        else
            TriggerClientEvent("core_crafting:sendMessage", src, Config.Text["not_enough_ingredients"], "error")
        end
    end
end
RegisterServerEvent("core_crafting:itemCrafted")
AddEventHandler(
    "core_crafting:itemCrafted",
    function(item, count)
        local src = source
        local xPlayer = Framework.Functions.GetPlayer(src)

        if Config.Recipes[item].SuccessRate > math.random(0, Config.Recipes[item].SuccessRate) then
            if Config.UseLimitSystem then
                local xItem = xPlayer.Functions.GetItemByName(item)

                if xItem.count + count <= xItem.limit then
                    if Config.Recipes[item].isGun then
                        xPlayer.addWeapon(item, 0)
                    else
                        xPlayer.Functions.AddItem(item, count)
                        TriggerClientEvent('prp-inventory:client:ItemBox', source, Framework.Shared.Items[item], "add")

                    end
                    TriggerClientEvent("core_crafting:sendMessage", src, Config.Text["item_crafted"])
                    giveCraftingLevel(xPlayer.PlayerData.citizenid, Config.ExperiancePerCraft)
                else
                    TriggerEvent("core_crafting:craft", item)
                    TriggerClientEvent("core_crafting:sendMessage", src, Config.Text["inv_limit_exceed"])
                end
            else
                    if Config.Recipes[item].isGun then
                    xPlayer.Functions.AddItem(item, count)
                    TriggerClientEvent('prp-inventory:client:ItemBox', source, Framework.Shared.Items[item], "add")
                    else
                        xPlayer.Functions.AddItem(item, count)
                        TriggerClientEvent('prp-inventory:client:ItemBox', source, Framework.Shared.Items[item], "add")

                    end
                    TriggerClientEvent("core_crafting:sendMessage", src, Config.Text["item_crafted"])
                    giveCraftingLevel(xPlayer.PlayerData.citizenid, Config.ExperiancePerCraft)
            end
        else
            TriggerClientEvent("core_crafting:sendMessage", src, Config.Text["crafting_failed"])
        end
    end
)

RegisterServerEvent("core_crafting:craft")
AddEventHandler(
    "core_crafting:craft",
    function(item, retrying)
        local src = source
        craft(src, item, retrying)
    end
)


Framework.Functions.CreateCallback("core_crafting:getXP",function(source, cb, info)
        local xPlayer = Framework.Functions.GetPlayer(source)
        cb(getCraftingLevel(xPlayer.PlayerData.citizenid))
    end)


    Framework.Functions.CreateCallback("core_crafting:getItemNames", function(source, cb)
        local names = {}
            for _, v in ipairs(Framework.Shared.Items) do
            names[v.name] = v.label
            end
        cb(names)
        end)

RegisterCommand("givecraftingxp", function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = Framework.Functions.GetPlayer(source)

            if xPlayer.getGroup() == "user" or xPlayer.getGroup() == "superadmin" then
                if args[1] ~= nil then
                    local xTarget = Framework.Functions.GetPlayer(tonumber(args[1]))
                    if xTarget ~= nil then
                        if args[2] ~= nil then
                            giveCraftingLevel(xTarget.identifier, tonumber(args[2]))
                        else
                            TriggerClientEvent("core_multijob:sendMessage", source, Config.Text["wrong_usage"])
                        end
                    else
                        TriggerClientEvent("core_multijob:sendMessage", source, Config.Text["wrong_usage"])
                    end
                else
                    TriggerClientEvent("core_multijob:sendMessage", source, Config.Text["wrong_usage"])
                end
            else
                TriggerClientEvent("core_multijob:sendMessage", source, Config.Text["wrong_usage"])
            end
        end
    end,
    false
)

RegisterCommand(
    "setcraftingxp",
    function(source, args, rawCommand)
        if source ~= 0 then
            local xPlayer = Framework.Functions.GetPlayer(source)

            if xPlayer.getGroup() == "user" or xPlayer.getGroup() == "superadmin" then
                if args[1] ~= nil then
                    local xTarget = Framework.Functions.GetPlayer(tonumber(args[1]))
                    if xTarget ~= nil then
                        if args[2] ~= nil then
                            setCraftingLevel(xPlayer.PlayerData.citizenid, tonumber(args[2]))
                        else
                            TriggerClientEvent("core_multijob:sendMessage", source, Config.Text["wrong_usage"])
                        end
                    else
                        TriggerClientEvent("core_multijob:sendMessage", source, Config.Text["wrong_usage"])
                    end
                else
                    TriggerClientEvent("core_multijob:sendMessage", source, Config.Text["wrong_usage"])
                end
            else
                TriggerClientEvent("core_multijob:sendMessage", source, Config.Text["wrong_usage"])
            end
        end
    end,
    false
)
