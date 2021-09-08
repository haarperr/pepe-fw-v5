Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

Framework.Commands.Add("logout", "Go back to the character selection", {}, false, function(source, args)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    Framework.Player.Logout(src)
    Citizen.Wait(650)
    TriggerClientEvent('pepe-characters:client:chooseChar', src)
end, "user")

RegisterServerEvent('pepe-characters:server:loadUserData')
AddEventHandler('pepe-characters:server:loadUserData', function(cData)
    local src = source
    if Framework.Player.Login(src, false, cData.citizenid) then
        print('^2[pepe-CORE]^7 '..GetPlayerName(src)..' (Citizen ID: '..cData.citizenid..') has succesfully loaded!')
        Framework.Commands.Refresh(src)
        TriggerClientEvent('pepe-spawn:client:choose:spawn', src)
        TriggerEvent("pepe-logs:server:SendLog", "joinleave", "Loaded", "green", "**".. GetPlayerName(src) .. "** ("..cData.citizenid.." | "..src..") loaded..")
	end
end)

RegisterServerEvent('pepe-characters:server:createCharacter')
AddEventHandler('pepe-characters:server:createCharacter', function(data)
    local src = source
    local newData = {firstname = data.firstname, lastname = data.lastname, birthdate = data.birthdate, nationality = data.nationality, gender = data.gender, cid = data.cid}
    if Framework.Player.Login(src, true, false, newData) then
        print('^2[pepe-CORE]^7 '..GetPlayerName(src)..' has succesfully created their char!')
        Framework.Commands.Refresh(src)
        GiveStarterItems(src)
        TriggerClientEvent('pepe-spawn:client:choose:appartment', src)
        TriggerClientEvent("pepe-characters:client:closeNUI", src)
	end
end)

RegisterServerEvent('pepe-characters:server:deleteCharacter')
AddEventHandler('pepe-characters:server:deleteCharacter', function(citizenid)
    local Player = Framework.Functions.GetPlayer(source)
    Framework.Player.DeleteCharacter(source, citizenid)
end)

Framework.Functions.CreateCallback("pepe-characters:server:get:char:data", function(source, cb)
    local steamId = GetPlayerIdentifiers(source)[1]
    local plyChars = {}
    exports['ghmattimysql']:execute('SELECT * FROM characters_metadata WHERE steam = @steam', {['@steam'] = steamId}, function(result)
        for i = 1, (#result), 1 do
            result[i].charinfo = json.decode(result[i].charinfo)
            result[i].money = json.decode(result[i].money)
            result[i].job = json.decode(result[i].job)
            table.insert(plyChars, result[i])
        end
        cb(plyChars)
    end)
end)

Framework.Functions.CreateCallback("pepe-characters:server:getSkin", function(source, cb, cid)
    local src = source
    Framework.Functions.ExecuteSql(false, "SELECT * FROM `characters_skins` WHERE `citizenid` = '"..cid.."'", function(result)
        if result[1] ~= nil then
            cb(result[1].model, result[1].skin)
        else
            cb(nil)
        end
    end)
end)

function GiveStarterItems(source)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    for k, v in pairs(Framework.Shared.StarterItems) do
        local info = {}
        if v.item == "id-card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "drive-card" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "A1-A2-A | AM-B | C1-C-CE"
        end
        Player.Functions.AddItem(v.item, v.amount, false, info)
    end
end