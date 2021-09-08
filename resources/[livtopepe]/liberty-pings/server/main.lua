Framework = nil
TriggerEvent('Framework:GetObject', function(obj) Framework = obj end)

-- Code

local Pings = {}

Framework.Commands.Add("ping", "", {{name = "action", help="id | accept | deny"}}, true, function(source, args)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local task = args[1]
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if task == "accept" then
            if Pings[src] ~= nil then
                TriggerClientEvent('pepe-pings:client:AcceptPing', src, Pings[src], Framework.Functions.GetPlayer(Pings[src].sender))
                TriggerClientEvent('Framework:Notify', Pings[src].sender, Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname.." accepted your ping!")
                Pings[src] = nil
            else
                TriggerClientEvent('Framework:Notify', src, "You don't have a ping open..", "error")
            end
        elseif task == "deny" then
            if Pings[src] ~= nil then
                TriggerClientEvent('Framework:Notify', Pings[src].sender, "Your ping has been rejected..", "error")
                TriggerClientEvent('Framework:Notify', src, "Tiy rejected the ping..", "success")
                Pings[src] = nil
            else
                TriggerClientEvent('Framework:Notify', src, "You don't have a ping open..", "error")
            end
        else
            TriggerClientEvent('pepe-pings:client:DoPing', src, tonumber(args[1]))
        end
    else
        TriggerClientEvent('Framework:Notify', src, "You don't have a phone..", "error")
    end
end)

RegisterServerEvent('pepe-pings:server:SendPing')
AddEventHandler('pepe-pings:server:SendPing', function(id, coords)
    local src = source
    local Player = Framework.Functions.GetPlayer(src)
    local Target = Framework.Functions.GetPlayer(id)
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if Target ~= nil then
            local OtherItem = Target.Functions.GetItemByName("phone")
            if OtherItem ~= nil then
                TriggerClientEvent('Framework:Notify', src, "You sent a ping to "..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname)
                Pings[id] = {
                    coords = coords,
                    sender = src,
                }
                TriggerClientEvent('Framework:Notify', id, "You recived a ping from "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname..". /ping 'accept | deny'")
            else
                TriggerClientEvent('Framework:Notify', src, "Could not send the ping, person may dont have a phone.", "error")
            end
        else
            TriggerClientEvent('Framework:Notify', src, "This person is not online..", "error")
        end
    else
        TriggerClientEvent('Framework:Notify', src, "You dont have a phone", "error")
    end
end)

RegisterServerEvent('pepe-pings:server:SendLocation')
AddEventHandler('pepe-pings:server:SendLocation', function(PingData, SenderData)
    TriggerClientEvent('pepe-pings:client:SendLocation', PingData.sender, PingData, SenderData)
end)