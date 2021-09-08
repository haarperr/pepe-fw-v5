Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

Framework.Commands.Add("skin", "Open the clothing menu", {}, false, function(source, args)
	TriggerClientEvent("pepe-clothing:client:openMenu", source)
end, "user")

RegisterServerEvent("pepe-clothing:saveSkin")
AddEventHandler('pepe-clothing:saveSkin', function(model, skin)
    local Player = Framework.Functions.GetPlayer(source)
    if model ~= nil and skin ~= nil then 
        Framework.Functions.ExecuteSql(false, "DELETE FROM `characters_skins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function()
          Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_skins` (`citizenid`, `model`, `skin`) VALUES ('"..Player.PlayerData.citizenid.."', '"..model.."', '"..skin.."')")
        end)
    end
end)

RegisterServerEvent("pepe-clothing:loadPlayerSkin")
AddEventHandler('pepe-clothing:loadPlayerSkin', function()
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_skins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            TriggerClientEvent("pepe-clothing:loadSkin", src, false, result[1].model, result[1].skin)
        else
            TriggerClientEvent("pepe-clothing:loadSkin", src, true)
        end
    end)
end)

RegisterServerEvent("pepe-clothing:saveOutfit")
AddEventHandler("pepe-clothing:saveOutfit", function(outfitName, model, skinData)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    if model ~= nil and skinData ~= nil then
        local outfitId = "outfit-"..math.random(1, 10).."-"..math.random(1111, 9999)
        Framework.Functions.ExecuteSql(false, "INSERT INTO `characters_outfits` (`citizenid`, `outfitname`, `model`, `skin`, `outfitId`) VALUES ('"..Player.PlayerData.citizenid.."', '"..outfitName.."', '"..model.."', '"..json.encode(skinData).."', '"..outfitId.."')", function()
            Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
                if result[1] ~= nil then
                    TriggerClientEvent('pepe-clothing:client:reloadOutfits', src, result)
                else
                    TriggerClientEvent('pepe-clothing:client:reloadOutfits', src, nil)
                end
            end)
        end)
    end
end)

RegisterServerEvent("pepe-clothing:server:removeOutfit")
AddEventHandler("pepe-clothing:server:removeOutfit", function(outfitName, outfitId)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)

    Framework.Functions.ExecuteSql(false, "DELETE FROM `characters_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `outfitname` = '"..outfitName.."' AND `outfitId` = '"..outfitId.."'", function()
        Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
            if result[1] ~= nil then
                TriggerClientEvent('pepe-clothing:client:reloadOutfits', src, result)
            else
                TriggerClientEvent('pepe-clothing:client:reloadOutfits', src, nil)
            end
        end)
    end)
end)

Framework.Functions.CreateCallback('pepe-clothing:server:getOutfits', function(source, cb)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local anusVal = {}

    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_outfits` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            for k, v in pairs(result) do
                result[k].skin = json.decode(result[k].skin)
                anusVal[k] = v
            end
            cb(anusVal)
        end
        cb(anusVal)
    end)
end)

Framework.Commands.Add("helmet", "Take off headwear, or put on headwear..", {}, false, function(source, args)
    TriggerClientEvent("pepe-clothing:client:adjustfacewear", source, 1) -- Hat
end)

Framework.Commands.Add("glasses", "Take off glasses, or put on glasses..", {}, false, function(source, args)
	TriggerClientEvent("pepe-clothing:client:adjustfacewear", source, 2)
end)

Framework.Commands.Add("mask", "Take mask off, or put on mask..", {}, false, function(source, args)
	TriggerClientEvent("pepe-clothing:client:adjustfacewear", source, 4)
end)