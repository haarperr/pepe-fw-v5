Framework = nil

TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

RegisterServerEvent('pepe-cityhall:server:requestId')
AddEventHandler('pepe-cityhall:server:requestId', function(identityData)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local licenses = {
        ["driver"] = true,
    }
    local info = {}
    if identityData.item == "id-card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif identityData.item == "drive-card" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "A1-A2-A | AM-B | C1-C-CE"
    end
    Player.Functions.AddItem(identityData.item, 1, false, info)
    TriggerClientEvent('pepe-inventory:client:ItemBox', src, Framework.Shared.Items[identityData.item], 'add')
end)

RegisterServerEvent('pepe-cityhall:server:ApplyJob')
AddEventHandler('pepe-cityhall:server:ApplyJob', function(job)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local JobInfo = Framework.Shared.Jobs[job]

    Player.Functions.SetJob(job, 0)

    TriggerClientEvent('Framework:Notify', src, "Xin chúc mừng bạn đã có công việc mới là "..JobInfo.label.."", "success")
end)
