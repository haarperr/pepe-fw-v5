Framework = nil

TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)

Framework.Commands.Add("createbill", "Create a bill to send to another player", {{name="id", help="Player ID"},{name="ammount", help="Value of the bill"},{name="reason", help="Reason for the bill"}}, false, function(source, args)
    Player = Framework.Functions.GetPlayer(source)
    OtherPlayer = Framework.Functions.GetPlayer(tonumber(args[1]))
    if Player ~= nil then
        if OtherPlayer ~= nil then
            name = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname
            playerId = tonumber(args[1])
            price = tonumber(args[2])
            citizenid = Player.PlayerData.citizenid
            
            table.remove(args, 1)
            table.remove(args, 1)
            local reason = table.concat(args, " ")


            TriggerClientEvent("billing:client:sendBillingMail", playerId, name, price, reason,citizenid)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online")
        end
    end
end)

RegisterNetEvent('billing:server:PayBill')
AddEventHandler('billing:server:PayBill',function(data)
    Player = Framework.Functions.GetPlayer(source)
    OtherPlayer = Framework.Functions.GetPlayerByCitizenId(data[2])
    if Player ~= nil then
       Balance = Player.PlayerData.money["bank"]
       
       if Balance - data[1] >= 0 then
            Player.Functions.RemoveMoney("bank",data[1],"paid-bill")
            if OtherPlayer ~= nil then
                OtherPlayer.Functions.AddMoney("bank",data[1],"recieved-bill")
                TriggerClientEvent("Framework:Notify",OtherPlayer.PlayerData.source, "You recieved $"..data[1].." from "..Player.PlayerData.charinfo.firstname.. " ".. Player.PlayerData.charinfo.lastname , "success")
            end
       end
    end
end)
