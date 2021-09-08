Framework = nil
TriggerEvent("Framework:GetObject", function(obj) Framework = obj end)

Framework.Commands.Add("bill", "Create an invoice and send to another citizen", {{name="id", help="Player ID"},{name="Amount", help="The bills value"},{name="Reason", help="Reason for bill"}}, false, function(source, args)
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

            TriggerClientEvent('billing:client:sendBillingMail', playerId, name, price, reason, citizenid)
        else
            TriggerClientEvent('Framework:Notify', source, "The citizen is not online..", "error", 4500)
        end
    end
end)


RegisterNetEvent('billing:server:PayBill')
AddEventHandler('billing:server:PayBill', function(data)
    Player = Framework.Functions.GetPlayer(source)
    OtherPlayer = Framework.Functions.GetPlayerByCitizenId(data[2])
    if Player ~= nil then
        Balance = Player.PlayerData.money["bank"]

        if Balance - data[1] >= 0 then
            Player.Functions.RemoveMoney("bank",data[1], "paid-bills")
            if OtherPlayer ~= nil then
                OtherPlayer.Functions.AddMoney("cash",data[1], "recived-bill")

                TriggerClientEvent('Framework:Notify', OtherPlayer.PlayerData.source, 'You recived $'..data[1].. ' from '..Player.PlayerData.charinfo.firstname.. ' ' ..Player.PlayerData.charinfo.lastname, 'success')
            end
        end
    end
end)
